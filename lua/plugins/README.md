# lua/plugins/

1ファイル1プラグイン。lazy.nvim がこのディレクトリごと読むので `init.lua` への追記は要らない。

何のプラグインかは各 `.lua` の先頭コメントに書く。この README には名前だけ並べる
（用途を2箇所に書くと片方が必ず古くなるため）。

## 入っているプラグイン

- `nvim-telescope/telescope.nvim`
- `neovim/nvim-lspconfig`
- `nvimdev/dashboard-nvim`
- `nvim-neo-tree/neo-tree.nvim`
- `Bekaboo/dropbar.nvim`
- `shellRaining/hlchunk.nvim`
- `nvim-treesitter/nvim-treesitter-context`
- `rainbowhxch/accelerated-jk.nvim`
- `simeji/winresizer`
- `lewis6991/gitsigns.nvim`
- `folke/which-key.nvim`
- `windwp/nvim-autopairs`

プラグイン固有のキーマップも spec 側ではなく [`../keymaps.lua`](../keymaps.lua) に書く（一覧は [`lua/README.md`](../README.md)）。

LSP サーバーごとの設定も spec 側ではなく [`../../after/lsp/`](../../after/lsp/README.md) に書く。

## プラグインの追加

`<プラグイン名>.lua` を作って spec を1つ return する。
ファイル名はリポジトリ名から `.nvim` を落としたもの（`nvim-telescope/telescope.nvim` → `telescope.lua`）。

```lua
-- ファイル・文字列の絞り込み検索
-- キーマップと `setup()` はまだ書いていないので `:Telescope` から呼ぶ
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
```

- ファイルの先頭に、そのプラグインが何をするものかを日本語コメントで書く。
  独自のキーや、まだ設定していない・意図的に切っている点もここに書く
- 1ファイルに複数のプラグインを詰めない。依存は `dependencies` に書く
- 依存は他のプラグイン経由で入っていても省略しない。そちらを外したときに壊れる
- `setup()` が要るものだけ `config` を書く。要らないなら repo 名だけでよい
- 遅延読み込み（`event` / `ft` / `cmd`）は起動が遅くなってから足す。最初から付けない
- 追加したら上のリストにも1行足す。用途はリストに書かない

プラグイン管理は lazy.nvim だけを使う。`vim.pack` は併用しない（混在させると起動時に落ちる）。

## プラグインの更新

`lazy-lock.json` はコンフリクトが面倒なので gitignore で追跡しない。
各PCで好きなタイミングで `:Lazy update` してよい。追跡していないぶん、
PC 間でプラグインのバージョンは揃わない。

メジャーバージョンを跨ぎたくないものは spec に `branch` を書いておく
（neo-tree の `branch = "v3.x"` など）。
