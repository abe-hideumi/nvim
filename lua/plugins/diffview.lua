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
					-- DiffviewOpen は nvim の cwd でリポジトリを探すので、開いているファイルのディレクトリを渡す
					-- (cwd が repo の外や別の worktree でも、今見ているファイルの repo の差分が開く)
					local dir = vim.fn.expand("%:p:h")
					if vim.bo.buftype ~= "" or vim.fn.isdirectory(dir) == 0 then
						dir = vim.fn.getcwd()
					end
					local ok = pcall(vim.cmd, "DiffviewOpen -C" .. vim.fn.fnameescape(dir))
					if not ok then
						vim.notify("Git リポジトリの外なので差分を開けません: " .. dir, vim.log.levels.WARN)
					end
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
