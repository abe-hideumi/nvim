local api = vim.api
local uv = vim.uv

-- 異常終了した Neovim が残したスワップファイルを起動時に掃除する。
--
-- スワップはバッファを開いている間だけ存在し、正常終了すれば自動で消える。
-- 残るのはターミナルを閉じる・クラッシュする・kill されるなどで
-- 後片付けができなかったときだけで、そのぶんは次回起動時に
-- 「Found a swap file」の確認を出してくる。
-- 救う中身が無いものだけをここで先に消して、確認を出させない。

-- スワップ先頭の block0 から、作成元の PID・ホスト名・元ファイル名を読む。
-- オフセットは Vim の struct block0 の並びによる（PID は 24、ホスト名は 68、
-- ファイル名は 108 から）。
local function read_block0(path)
	local fd = uv.fs_open(path, "r", 438)
	if not fd then
		return nil
	end

	local data = uv.fs_read(fd, 1008, 0)
	uv.fs_close(fd)

	if not data or #data < 1008 then
		return nil
	end

	-- PID は 4 バイトのリトルエンディアン
	local b1, b2, b3, b4 = data:byte(25, 28)

	return {
		pid = b1 + b2 * 256 + b3 * 65536 + b4 * 16777216,
		host = data:sub(69, 108):match("^[^%z]*"),
		fname = data:sub(109, 1008):match("^[^%z]*"),
	}
end

-- block0 のファイル名は "~/..." や "~ユーザー名/..." に短縮されて入っている。
-- パス全体を expand() に渡すとワイルドカードや $VAR まで展開してしまうので、
-- 先頭のチルダ部分だけを展開して、残りはそのまま繋ぐ。
local function expand_tilde(path)
	local tilde, rest = path:match("^(~[^/]*)(/.*)$")
	if not tilde then
		return path
	end

	local home = vim.fn.expand(tilde)
	if home == tilde or home == "" then
		return path
	end

	return home .. rest
end

-- 判定できないもの（PID が読めない、権限エラー）は生きている側に倒して触らない。
-- PID が使い回されていた場合も「生きている」と誤判定する側に倒れるので、
-- 消しすぎるより残しすぎるほうに倒れる。
local function is_alive(pid)
	if pid <= 0 then
		return true
	end

	local ok, _, errname = uv.kill(pid, 0)
	if ok == 0 then
		return true
	end

	return errname ~= "ESRCH"
end

-- 消してよいのは次を全部満たすものだけ。
--   1. このホストで作られた
--   2. 作成元のプロセスがもう居ない
--   3. 実ファイルが今もある
--   4. ディレクトリバッファ（ファイラー表示）である、または
--      実ファイルのほうがスワップより新しい（＝スワップに未保存の編集が無い）
-- クラッシュ直後の救うべきスワップは 4 で残るので、復旧の確認はちゃんと出る。
local function is_stale(path, b0)
	if b0.host ~= uv.os_gethostname() or is_alive(b0.pid) then
		return false
	end

	local orig = uv.fs_stat(expand_tilde(b0.fname))
	if not orig then
		return false
	end

	if orig.type == "directory" then
		return true
	end

	local swap = uv.fs_stat(path)
	return swap ~= nil and orig.mtime.sec >= swap.mtime.sec
end

local function clean_swap()
	local dir = vim.fn.stdpath("state") .. "/swap"
	local removed = {}

	for name, type in vim.fs.dir(dir) do
		if type == "file" then
			local path = dir .. "/" .. name
			local b0 = read_block0(path)

			if b0 and is_stale(path, b0) then
				if uv.fs_unlink(path) then
					table.insert(removed, vim.fn.fnamemodify(expand_tilde(b0.fname), ":t"))
				end
			end
		end
	end

	return removed
end

api.nvim_create_user_command("SwapClean", function()
	local removed = clean_swap()

	if #removed == 0 then
		vim.notify("掃除できるスワップファイルは無かった")
		return
	end

	vim.notify(("スワップファイルを %d 個削除した: %s"):format(#removed, table.concat(removed, ", ")))
end, { desc = "残骸スワップファイルを掃除" })

api.nvim_create_autocmd("VimEnter", {
	group = api.nvim_create_augroup("UserSwapClean", {}),
	callback = function()
		-- 起動を待たせないよう描画が済んでから走らせる。
		-- 起動時は通知を出さない（消す物が無いのが普通で、毎回の起動画面を汚すため）。
		-- 何が消えたか見たいときは :SwapClean を手で叩く。
		vim.schedule(clean_swap)
	end,
})
