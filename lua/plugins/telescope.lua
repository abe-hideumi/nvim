-- ファイル・文字列の絞り込み検索
-- `<C-f>` でファイル名検索。そのピッカーの中でもう一度 `<C-f>` を押すと全文検索へ切り替わる
return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<C-f>", "<cmd>Telescope find_files<CR>", desc = "ファイルを絞り込み検索" },
	},
	opts = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		-- 入力済みの文字列を default_text で引き渡し、打ち直さずに全文検索へ移る
		local switch_to_live_grep = function(prompt_bufnr)
			local prompt = action_state.get_current_line()
			actions.close(prompt_bufnr)
			require("telescope.builtin").live_grep({ default_text = prompt })
		end

		return {
			pickers = {
				find_files = {
					mappings = {
						i = { ["<C-f>"] = switch_to_live_grep },
						n = { ["<C-f>"] = switch_to_live_grep },
					},
				},
			},
		}
	end,
}
