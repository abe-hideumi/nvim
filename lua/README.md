# lua/

vim 本体の設定。プラグインの spec は [`plugins/`](plugins/README.md) にある。

| ファイル | 役割 |
| --- | --- |
| `options.lua` | `vim.opt` / `vim.g` の設定 |
| `keymaps.lua` | キーマップ。プラグイン固有のものもここに集める |

## オプション

`options.lua` で設定しているもの。

- `number` — 行番号を表示
- `tabstop` / `shiftwidth` = 4、`expandtab` — インデント幅4、タブはスペースに展開
- `ignorecase` + `smartcase` — 検索は大文字を含むときだけ大小を区別
- `clipboard = "unnamedplus"` — ヤンクをOSのクリップボードと共有

足したら上のリストにも1行足す。

## キーマップ

`keymaps.lua` で設定しているもの。leader キーは `<Space>`。

| キー | モード | 動作 |
| --- | --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | n | 左 / 下 / 上 / 右のウィンドウへ移動 |
| `<leader>w` | n | 保存 |
| `<leader>q` | n | 終了 |
| `<leader>t` | n | 画面下にターミナルをトグル（高さ25）。バッファは使い回すので閉じても中身が残る |
| `<C-n>` | t | terminal モードを抜ける |
| `j` / `k` | n | accelerated-jk（`gj` / `gk` ベースなので折り返し行も1行ずつ動く） |
| `gd` | n | 定義へジャンプ。LSP が attach したバッファでのみ有効 |

プラグイン固有のキーマップも spec 側ではなくここに書く（探す場所を1箇所にするため）。
足したら上の表にも1行足す。

`K`（ドキュメント表示）と `gr*`（`grr` 参照一覧 / `grn` リネーム / `gra` コードアクション /
`gri` 実装 / `grt` 型定義）は Neovim 0.11+ の組み込み既定なので、ここには書かない
（`:h lsp-defaults`）。とくに `gr` を自分で割り当てると `gr*` と前方一致して
`timeoutlen` のぶん待たされるので割り当てない。
