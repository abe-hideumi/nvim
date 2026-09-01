# after/lsp/

1ファイル1サーバー。LSP サーバーの個別設定を置く。

Neovim 0.11+ の組み込み機構で、`runtimepath` 上の `lsp/<サーバー名>.lua` と
`after/lsp/<サーバー名>.lua` は `vim.lsp.enable()` 時に自動で読まれる（`:h lsp-config-merge`）。
`require` も lazy.nvim の `import` も要らないので、ファイルを置くだけでよい。

有効化そのものは [`../../lua/plugins/lsp.lua`](../../lua/plugins/lsp.lua) の
mason-lspconfig がやる。ここに書くのは「有効になったサーバーをどう設定するか」だけ。

## 入っている設定

- `lua_ls.lua`

何の設定かは各 `.lua` の先頭コメントに書く。この README には名前だけ並べる。

## なぜ `lsp/` ではなく `after/lsp/` なのか

設定は優先度の低い順に、こう畳み込まれる（`:h lsp-config-merge`）。

1. `'*'` に対する設定
2. `runtimepath` 上の全 `lsp/<サーバー名>.lua`
3. `runtimepath` 上の全 `after/lsp/<サーバー名>.lua`
4. `vim.lsp.config()` の呼び出し

2 の中は `runtimepath` 順に後勝ちで畳み込まれる。`~/.config/nvim` は
`runtimepath` の先頭、nvim-lspconfig はその後ろなので、`~/.config/nvim/lsp/` に
置くと **nvim-lspconfig 側の設定に負ける**。`after/` に置けば 3 として
最後に乗るので勝つ。`:h lsp.txt` の FAQ にも同じことが書いてある。

`vim.lsp.config()`（4）でも上書きできるが、そちらは呼ぶ順番を自分で管理する
必要がある（mason-lspconfig の `automatic_enable` より前に呼ばないと効かない）。
ファイルで置けば順序を気にしなくてよい。

## サーバー設定の追加

`<サーバー名>.lua` を作ってテーブルを1つ return する。
サーバー名は nvim-lspconfig の名前に合わせる（`lua_ls` / `ts_ls` / `clangd` など）。

```lua
-- clangd の設定
return {
	cmd = { "clangd", "--background-index" },
}
```

- `cmd` や `filetypes`、`root_markers` は nvim-lspconfig 側が持っているので、
  変えたい項目だけを書く。テーブルは深くマージされる
- ファイルの先頭に、何のサーバーで何を変えているのかを日本語コメントで書く
- 追加したら上のリストにも1行足す
- **インストール対象に足すのは別作業**。`lua/plugins/lsp.lua` の
  `ensure_installed` にサーバー名を足さないと mason が入れてくれない
