return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		-- ファイルアイコン。必須ではないが無いとアイコンが出ない
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				-- ツリーを画面右側に出す
				position = "right",
			},
		})
	end,
}
