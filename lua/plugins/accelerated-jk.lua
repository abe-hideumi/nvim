-- `j` / `k` を押し続けると移動が加速する
return {
	"rainbowhxch/accelerated-jk.nvim",

	-- rhs の <Plug> は再帰的に展開されないと効かないので remap を明示する
	-- （lazy.nvim の keys は vim.keymap.set 経由で、そちらの既定は noremap）
	keys = {
		{ "j", "<Plug>(accelerated_jk_gj)", remap = true, desc = "1行下へ（押し続けると加速）" },
		{ "k", "<Plug>(accelerated_jk_gk)", remap = true, desc = "1行上へ（押し続けると加速）" },
	},
}
