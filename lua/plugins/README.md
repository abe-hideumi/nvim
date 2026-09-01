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
- `saghen/blink.cmp`

プラグイン固有のキーマップは spec の `keys` に書く。そのプラグインを呼ぶキーは
そのプラグインのファイルにある、という状態にする（押すまで読み込まない遅延ロードも付いてくる）。
[`../keymaps.lua`](../keymaps.lua) に書くのは vim 本体のキーだけ。
どちらに書いたキーも [`lua/README.md`](../README.md) の表に1行足して、一覧はそこに集める。

```lua
	keys = {
		{ "<leader>x", "<cmd>SomeCommand<CR>", desc = "何をするか" },
		-- rhs が <Plug> のときは remap が要る。lazy.nvim は vim.keymap.set で張るので、
		-- 既定の noremap のままだと展開されず何も起きない
		{ "j", "<Plug>(accelerated_jk_gj)", remap = true, desc = "1行下へ" },
	},
```

処理を書きたいときは rhs を関数にする（diffview のトグルがその形）。

LSP サーバーごとの設定も spec 側ではなく [`../../after/lsp/`](../../after/lsp/README.md) に書く。

## プラグインの追加

`<プラグイン名>.lua` を作って spec を1つ return する。
ファイル名はリポジトリ名から `.nvim` を落としたもの（`nvim-telescope/telescope.nvim` → `telescope.lua`）。

```lua
-- ファイル・文字列の絞り込み検索
-- `<C-f>` でファイル検索。`setup()` はまだ書いていないので、他のピッカーは `:Telescope` から呼ぶ
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<C-f>", "<cmd>Telescope find_files<CR>", desc = "ファイルを絞り込み検索" },
	},
}
```

- ファイルの先頭に、そのプラグインが何をするものかを日本語コメントで書く。
  独自のキーや、まだ設定していない・意図的に切っている点もここに書く
- 1ファイルに複数のプラグインを詰めない。依存は `dependencies` に書く
- 依存は他のプラグイン経由で入っていても省略しない。そちらを外したときに壊れる
- `setup()` が要るものだけ `config` を書く。要らないなら repo 名だけでよい
- 遅延読み込み（`event` / `ft` / `cmd`）は起動が遅くなってから足す。最初から付けない。
  `keys` はキーマップの置き場所なので、遅延ロード目的でなくても最初から書く
- キーマップは `keys` に書く。足したら [`lua/README.md`](../README.md) のキー表にも1行足す
- 追加したら上のリストにも1行足す。用途はリストに書かない

プラグイン管理は lazy.nvim だけを使う。`vim.pack` は併用しない（混在させると起動時に落ちる）。

## プラグインの更新

`lazy-lock.json` はコンフリクトが面倒なので gitignore で追跡しない。
各PCで好きなタイミングで `:Lazy update` してよい。追跡していないぶん、
PC 間でプラグインのバージョンは揃わない。

メジャーバージョンを跨ぎたくないものは spec に `branch` を書いておく
（neo-tree の `branch = "v3.x"` など）。
