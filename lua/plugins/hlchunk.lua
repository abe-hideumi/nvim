-- カーソル位置のチャンク強調とインデントガイド
return {
	"shellRaining/hlchunk.nvim",
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
