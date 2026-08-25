-- vim.opt変数
local opt = vim.opt

-- keymaps より先に読まれる必要がある
vim.g.mapleader = " "

-- 行番号の表示
opt.number = true

-- タブとインデントの設定
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

-- 検索設定
opt.ignorecase = true
opt.smartcase = true

-- copyでクリップボードに保存
opt.clipboard = "unnamedplus"
