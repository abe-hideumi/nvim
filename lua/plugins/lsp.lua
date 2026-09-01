-- LSP クライアントの設定集。Neovim 本体の vim.lsp に各サーバーの起動方法を渡す
-- mason がサーバー本体をインストールし、mason-lspconfig が
-- インストール済みのものを vim.lsp.enable() で有効化する
-- サーバーごとの個別設定は spec 側ではなく ../../after/lsp/ に置く
-- キーマップは ../keymaps.lua に置く
return {
	"neovim/nvim-lspconfig",

	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},

	config = function()
		require("mason").setup()

		-- automatic_enable (既定 true) が
		-- インストール済みサーバーを vim.lsp.enable() で有効化する
		require("mason-lspconfig").setup({
			ensure_installed = {
				"clangd",
				"ts_ls",
				"prismals",
				"lua_ls",
			},
		})
	end,
}
