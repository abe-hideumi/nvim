# lua/plugins/

1ファイル1プラグイン。lazy.nvim がこのディレクトリごと読むので `init.lua` への追記は要らない。

## 入っているプラグイン

| プラグイン | 用途 |
| --- | --- |
| `nvim-telescope/telescope.nvim` | ファイル・文字列の絞り込み検索。**キーマップと `setup()` はまだ書いていない**ので `:Telescope` から呼ぶ |
| `neovim/nvim-lspconfig` | LSP クライアントの設定集。**読み込んでいるだけでサーバは未設定** |
| `nvimdev/dashboard-nvim` | 起動時のスタート画面（hyper テーマ）。`u` = `:Lazy update` / `c` = 設定を開く / `q` = 終了 |
| `nvim-neo-tree/neo-tree.nvim` | ファイルツリーを画面右側に表示。**キーマップはまだ書いていない**ので `:Neotree` から呼ぶ |
| `Bekaboo/dropbar.nvim` | ウィンドウ上部にパンくず表示 |
| `shellRaining/hlchunk.nvim` | カーソル位置のチャンク強調とインデントガイド |
| `nvim-treesitter/nvim-treesitter-context` | スクロール中に関数などの見出し行を上部に固定 |
| `rainbowhxch/accelerated-jk.nvim` | `j` / `k` を押し続けると移動が加速する |

プラグイン固有のキーマップも spec 側ではなく [`../keymaps.lua`](../keymaps.lua) に書く（一覧は [`lua/README.md`](../README.md)）。

## プラグインの追加

`<プラグイン名>.lua` を作って spec を1つ return する。
ファイル名はリポジトリ名から `.nvim` を落としたもの（`nvim-telescope/telescope.nvim` → `telescope.lua`）。

```lua
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
```

- 1ファイルに複数のプラグインを詰めない。依存は `dependencies` に書く
- 依存は他のプラグイン経由で入っていても省略しない。そちらを外したときに壊れる
- `setup()` が要るものだけ `config` を書く。要らないなら repo 名だけでよい
- 遅延読み込み（`event` / `ft` / `cmd`）は起動が遅くなってから足す。最初から付けない
- 追加したら上の表にも1行足す

プラグイン管理は lazy.nvim だけを使う。`vim.pack` は併用しない（混在させると起動時に落ちる）。

## プラグインの更新

`lazy-lock.json` はコンフリクトが面倒なので gitignore で追跡しない。
各PCで好きなタイミングで `:Lazy update` してよい。追跡していないぶん、
PC 間でプラグインのバージョンは揃わない。

メジャーバージョンを跨ぎたくないものは spec に `branch` を書いておく
（neo-tree の `branch = "v3.x"` など）。
