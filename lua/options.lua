local opt = vim.opt

-- Leader key の設定
vim.g.mapleader = " "

-- 行番号の表示
opt.number = true

-- タブとインデントの設定
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- 検索時の大文字・小文字の扱い
opt.ignorecase = true
opt.smartcase = true

-- OSのクリップボードを使用
opt.clipboard = "unnamedplus"

-- 起動引数のパスへ cwd を移す
-- `nvim .claude` や `nvim .claude/foo.md` で起動しても cwd は起動元シェルのまま
-- （= home）なので、ターミナルも Telescope も home を基準にしてしまう。
-- ここで cwd を引数の場所へ寄せる。引数がファイルならその親ディレクトリを使う。
-- 引数のバッファは init 実行前にフルパスへ解決済みなので、ここで移動しても
-- 開くファイルはずれない。
-- （'autochdir' はバッファを切り替えるたびに cwd が動いてしまうので使わない）
local args = vim.fn.argv()

if #args > 0 then
	local path = vim.fn.fnamemodify(args[1], ":p")

	if vim.fn.isdirectory(path) == 0 then
		path = vim.fn.fnamemodify(path, ":h")
	end

	if vim.fn.isdirectory(path) == 1 then
		vim.fn.chdir(path)
	end
end
