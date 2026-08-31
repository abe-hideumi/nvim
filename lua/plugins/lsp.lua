return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},

	config = function()
		-- 1. Mason のセットアップ
		require("mason").setup()

		-- 2. Mason-lspconfig のセットアップ
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"ts_ls",
				"prismals",
				"lua_ls",
			},
			handlers = {
				-- デフォルトの自動セットアップ
				function(server_name)
					require("lspconfig")[server_name].setup({})
				end,
				-- lua_ls の個別の設定 (vimの警告を消す)
				["lua_ls"] = function()
					require("lspconfig").lua_ls.setup({
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,
			},
		})

		-- 3. LSP が有効になった時のキーマップ設定
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf }
				-- K でドキュメント表示 (ノーマルモードで Shift + k)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				-- gd で定義ジャンプ (ノーマルモードで g を押してから d)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				-- gr で参照一覧 (ノーマルモードで g を押してから r)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			end,
		})
	end,
}
