-- lua-language-server の設定
-- vim をグローバル変数として認識させ、「未定義のグローバル `vim`」警告を消す
return {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}
