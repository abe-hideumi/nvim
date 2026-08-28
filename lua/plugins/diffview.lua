-- Gitの差分・履歴をタブで見る
-- キーマップはまだ書いていないので `:DiffviewOpen` `:DiffviewFileHistory` から呼ぶ
return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		-- ファイル一覧パネルを右に置く(デフォルトは left)
		file_panel = {
			win_config = {
				position = "right",
				width = 35,
			},
		},
	},
}
