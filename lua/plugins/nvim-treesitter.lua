-- tree-sitter のパーサ（言語ごとの文法）を入れる・更新する
--
-- Neovim 本体は tree-sitter のエンジンと `vim.treesitter.*` の API は持っているが、
-- 同梱パーサは c / lua / markdown / markdown_inline / query / vim / vimdoc の7つだけで、
-- 本体だけではパーサを追加する手段が無い。そこを埋めるのがこのプラグイン。
--
-- ハイライトと折りたたみは自動では有効にならない。どちらも本体側の機能で、
-- `vim.treesitter.start()` / `foldexpr` を自分で呼ぶ必要がある。ここではまだ入れていない。
-- 今のところ入れている目的は treesitter-context にパーサを供給すること。
return {
	"nvim-treesitter/nvim-treesitter",

	-- `main` は `master` とは互換性の無い書き直し。`master` は Nvim 0.11 向けに凍結済みで、
	-- 設定方法もそちらは module 方式（`nvim-treesitter.configs`）と全く違う。
	-- 既定ブランチ任せにすると中身が入れ替わるので明示する
	branch = "main",

	-- 上流が「遅延ロードは非対応」と明記している。起動が遅くなっても event / ft は足さないこと
	lazy = false,

	-- プラグイン本体とパーサはバージョンが対応していないと壊れる。更新時に必ず揃える
	build = ":TSUpdate",

	config = function()
		-- 既に入っているものは何もしない。非同期なので起動は待たされない
		require("nvim-treesitter").install({
			"bash",
			"javascript",
			"jsdoc",
			"json",
			"lua",
			"markdown",
			"markdown_inline",
			"prisma",
			"tsx",
			"typescript",
			"yaml",
		})
	end,
}
