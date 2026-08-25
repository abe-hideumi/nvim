-- vim.keymap省略
local keymap = vim.keymap

-- ウィンドウ移動 (<C-w> h/j/k/l の短縮)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ移動" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ移動" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ移動" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ移動" })

-- <C-\><C-n> が terminal モードを抜けるシーケンス
keymap.set("t", "<C-n>", [[<C-\><C-n>]], { desc = "terminal モードを抜ける" })

-- 下にターミナルをトグルで開く。閉じてもシェルは残して使い回す
local term_buf = nil

keymap.set("n", "<leader>t", function()
  -- jobwait の timeout 0 は待たずに状態を返す。-1 が「まだ実行中」
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

  vim.cmd("botright split")
  vim.cmd("resize 25")

  if alive then
    vim.api.nvim_win_set_buf(0, term_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()
  end

  vim.cmd("startinsert")
end, { desc = "下にターミナルをトグル" })
