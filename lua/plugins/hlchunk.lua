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
