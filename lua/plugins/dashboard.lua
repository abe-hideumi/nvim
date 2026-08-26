return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		-- 起動時のスタート画面
		require("dashboard").setup({
			theme = "hyper",
			config = {
				-- 曜日ごとに変わるアスキーアートのヘッダ
				week_header = { enable = true },
				-- スタート画面で押せるショートカット
				shortcut = {
					{ desc = "Update", group = "@property", action = "Lazy update", key = "u" },
					{ desc = "Config", group = "Label", action = "edit ~/.config/nvim/init.lua", key = "c" },
					{ desc = "Quit", group = "Number", action = "quit", key = "q" },
				},
				-- 最近開いたファイル
				mru = { limit = 10 },
				-- プロジェクト一覧は Telescope 前提の機能なので今は切っておく
				project = { enable = false },
				footer = {},
			},
		})
	end,
}
