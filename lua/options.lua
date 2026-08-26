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
