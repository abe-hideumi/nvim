-- Gitの差分・履歴をタブで見る
-- <C-d> で差分をトグル(開く/閉じる)。ファイル履歴は `:DiffviewFileHistory` から呼ぶ
return {
	"sindrets/diffview.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- コマンドから呼んだときも遅延ロードが効くようにしておく
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewFocusFiles",
		"DiffviewToggleFiles",
	},
	keys = {
		{
			"<C-d>",
			function()
				local lib = require("diffview.lib")

				-- 開いている view が無ければ開く
				local view = lib.views[1]
				if not view then
					vim.cmd("DiffviewOpen")
					return
				end

				-- :DiffviewClose は「今いるタブの view」しか閉じないので、
				-- 別タブで押されたときは view のタブに移動してから閉じる
				if not lib.get_current_view() then
					vim.api.nvim_set_current_tabpage(view.tabpage)
				end
				vim.cmd("DiffviewClose")
			end,
			desc = "Gitの差分をトグル",
		},
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
