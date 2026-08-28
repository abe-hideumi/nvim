-- Gitの差分・履歴をタブで見る
-- キーマップはまだ書いていないので `:DiffviewOpen` `:DiffviewFileHistory` から呼ぶ
return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
