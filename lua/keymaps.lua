local keymap = vim.keymap
local api = vim.api

-- ウィンドウ移動
keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ移動" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ移動" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- 保存・終了
keymap.set("n", "<leader>w", ":w<CR>", { desc = "保存" })
keymap.set("n", "<leader>q", ":q<CR>", { desc = "終了" })
keymap.set("n", "<leader>Q", ":qa<CR>", { desc = "全ウィンドウを終了" })

-- terminal モードを抜ける
keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "terminal モードを抜ける" })

-- 下にターミナルをトグルで開く
local term_buf = nil

keymap.set("n", "<leader>t", function()
	local alive = term_buf ~= nil
		and vim.api.nvim_buf_is_valid(term_buf)
		and vim.fn.jobwait({ vim.b[term_buf].terminal_job_id }, 0)[1] == -1

	if alive then
		local win = vim.fn.bufwinid(term_buf)
		if win ~= -1 then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	vim.cmd("belowright split")
	vim.cmd("resize 25")

	if alive then
		vim.api.nvim_win_set_buf(0, term_buf)
	else
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()
	end

	vim.cmd("startinsert")
end, { desc = "下にターミナルをトグル" })

-- LSP
-- サーバーが attach したバッファにだけ効かせたいので LspAttach で設定する
-- K (ドキュメント表示) と gr* (grr:参照一覧, grn:リネーム, gra:コードアクション,
-- gri:実装, grt:型定義) は Neovim 0.11+ の組み込み既定なのでここでは設定しない
api.nvim_create_autocmd("LspAttach", {
	group = api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		keymap.set("n", "gd", vim.lsp.buf.definition, {
			buffer = ev.buf,
			desc = "定義へジャンプ",
		})
	end,
})
