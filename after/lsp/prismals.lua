-- prisma-language-server の設定
-- diffview の `diffview:///<repo>/.git/:0:/...` のような実ファイルの無いバッファで起動すると、
-- バッファ名から組んだ存在しないディレクトリを scandir して ENOENT で落ちるので、実ファイルのときだけ起動する
return {
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name:match("^%a+://") or vim.fn.filereadable(name) == 0 then
			return
		end
		on_dir(vim.fs.root(bufnr, { ".git", "package.json" }))
	end,
}
