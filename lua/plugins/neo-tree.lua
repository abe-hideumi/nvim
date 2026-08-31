-- ファイルツリーを画面右側に表示
-- キーマップはまだ書いていないので `:Neotree` から呼ぶ
return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("neo-tree").setup({
			window = {
				-- ツリーを画面右側に出す
				position = "right",
			},

			filesystem = {
				filtered_items = {
					visible = true, -- フィルター対象の項目を消さずにグレー（暗く）表示する
					hide_dotfiles = true, -- ドットファイルを「フィルター対象」にする（これでグレー表示になります）
					hide_gitignored = true, -- gitignore対象も「フィルター対象」にしてグレー表示する
				},
			},
            -- インストールされているサーバーを自動で setup する
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
			},
		})
	end,
}
