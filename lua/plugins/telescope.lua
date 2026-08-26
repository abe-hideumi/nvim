-- ファイル・文字列の絞り込み検索
-- キーマップと `setup()` はまだ書いていないので `:Telescope` から呼ぶ
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
