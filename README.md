# nvim

Neovim の個人設定。

## 運用方針

main ブランチ1本で運用する。

## セットアップ

必要なもの: Neovim 0.11.3 以上と git。
（`after/lsp/` による LSP 設定と nvim-lspconfig が 0.11.3 以上を要求する）

```sh
git clone <このリポジトリ> ~/.config/nvim
nvim
```

初回起動時に `init.lua` が lazy.nvim を `stdpath("data")/lazy/lazy.nvim` へクローンし、
`lua/plugins/` 配下の spec をまとめてインストールする。手動の準備は要らない。

## ファイル構成

```
init.lua              起動時の配線だけ
lua/
  options.lua         vim のオプション        → lua/README.md
  keymaps.lua         キーマップ              → lua/README.md
  plugins/            1ファイル1プラグイン    → lua/plugins/README.md
after/
  lsp/                1ファイル1サーバー      → after/lsp/README.md
lazy-lock.json        プラグインの固定バージョン（追跡しない）
```

| ファイル | 役割 |
| --- | --- |
| `init.lua` | `options` / `keymaps` の require と lazy.nvim のブートストラップのみ。設定の中身は書かない |
| [`lua/`](lua/README.md) | `options.lua` と `keymaps.lua`。オプションとキーマップの一覧はこちら |
| [`lua/plugins/`](lua/plugins/README.md) | プラグインの spec。入っているプラグインの一覧と追加・更新のルールはこちら |
| [`after/lsp/`](after/lsp/README.md) | LSP サーバーごとの設定。Neovim が直接読むので `require` は要らない |

## 書き足すときのルール

- **オプションを足す** → `lua/options.lua`
- **キーマップを足す** → `lua/keymaps.lua`。プラグイン固有のキーマップも spec 側ではなくここに書く（探す場所を1箇所にするため）
- **プラグインを足す** → `lua/plugins/` にファイルを新規作成する
- **LSP サーバーの設定を足す** → `after/lsp/` にファイルを新規作成する。
  インストール対象に入れるには `lua/plugins/lsp.lua` の `ensure_installed` にも足す

`init.lua` には何も足さない。ここに設定が増えると分割した意味が無くなる。

## スタイル

- Lua ファイルのインデントはタブ
- コメントとキーマップの `desc` は日本語で書く
- README はディレクトリごとに置く。設定を足したら、そのファイルと同じディレクトリの
  README を直す。ルート README にはディレクトリをまたぐ話（運用方針・セットアップ・
  全体構成・スタイル）だけ置き、個々のオプション名やプラグイン名は書かない
