local keymap = vim.keymap
local api = vim.api

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ移動" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ移動" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- 保存・終了
keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "終了" })
keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "全ウィンドウを終了" })

-- terminal モードを抜ける
keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "terminal モードを抜ける" })

-- 下にターミナルをトグルで開く
local term_buf = nil

keymap.set("n", "<leader>t", function()
	local alive = term_buf ~= nil
		and vim.api.nvim_buf_is_valid(term_buf)
		and vim.fn.jobwait({ vim.b[term_buf].terminal_job_id }, 0)[1] == -1

	if alive then
		local win = vim.fn.bufwinid(term_buf)
		if win ~= -1 then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	vim.cmd("belowright split")
	vim.cmd("resize 25")

	if alive then
		vim.api.nvim_win_set_buf(0, term_buf)
	else
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()
	end

	vim.cmd("startinsert")
end, { desc = "下にターミナルをトグル" })

-- LSP
-- サーバーが attach したバッファにだけ効かせたいので LspAttach で設定する
-- K (ドキュメント表示) と gr* (grr:参照一覧, grn:リネーム, gra:コードアクション,
-- gri:実装, grt:型定義) は Neovim 0.11+ の組み込み既定なのでここでは設定しない

-- カーソル下の識別子と、その直前のレシーバ名を返す
-- `prisma.contract` の contract 上なら "contract", "prisma"
local function accessor_under_cursor()
	local line = api.nvim_get_current_line()
	local col = api.nvim_win_get_cursor(0)[2] + 1 -- カーソル位置を1始まりに揃える

	if not line:sub(col, col):match("[%w_]") then
		return nil, nil
	end

	local from = col

	while from > 1 and line:sub(from - 1, from - 1):match("[%w_]") do
		from = from - 1
	end

	local to = col

	while to < #line and line:sub(to + 1, to + 1):match("[%w_]") do
		to = to + 1
    end

	return line:sub(from, to), line:sub(1, from - 1):match("([%w_]+)%.$")
end

-- prisma クライアントを指すレシーバか
-- ctx を巻き込まないよう、tx は完全一致と大文字始まりの Tx (mockTx など) だけ見る
local function is_prisma_receiver(name)
	return name:lower():find("prisma", 1, true) ~= nil or name == "tx" or name:match("Tx$") ~= nil
end

-- prisma.contract のようなアクセサから schema の `model Contract` へ飛ぶ
-- LSP に任せると 100MB 超の生成物 node_modules/.prisma/client/index.d.ts に着いてしまい、
-- テーブル定義を読みたいときに使えないので、こちらを先に試す。飛べたら true
local function jump_to_prisma_model()
	local word, receiver = accessor_under_cursor()

	if not word or not receiver or not is_prisma_receiver(receiver) then
		return false
	end

	-- src/features/prisma のような同名のソースディレクトリを拾わないよう、
	-- schema.prisma を持つ prisma ディレクトリだけを親方向に探す
	local dir = vim.fs.find(function(name, path)
		return name == "prisma" and vim.uv.fs_stat(path .. "/prisma/schema.prisma") ~= nil
	end, {
		upward = true,
		type = "directory",
		path = vim.fn.expand("%:p:h"),
		limit = 1,
	})[1]

	if not dir then
		return false
	end

	-- アクセサは camelCase、model 名は PascalCase
	local model = word:sub(1, 1):upper() .. word:sub(2)
	local result = vim
		.system({
			"rg",
			"--vimgrep",
			"--glob",
			"*.prisma",
			"^model " .. model .. "\\s*\\{",
			dir,
		}, { text = true })
		:wait()

	local hit = vim.split(result.stdout or "", "\n", { trimempty = true })[1]

	if not hit then
		return false
	end

	local file, lnum = hit:match("^(.-):(%d+):")

	if not file then
		return false
	end

	vim.cmd("normal! m'") -- 元の位置を jumplist に残して <C-o> で戻れるようにする
	vim.cmd.edit(file)
	api.nvim_win_set_cursor(0, { tonumber(lnum), 0 })
	vim.cmd("normal! zz")

	return true
end

api.nvim_create_autocmd("LspAttach", {
	group = api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		keymap.set("n", "gd", function()
			if jump_to_prisma_model() then
				return
			end

			vim.lsp.buf.definition()
		end, {
			buffer = ev.buf,
			desc = "定義へジャンプ (prisma のモデルは schema へ)",
		})
	end,
})
