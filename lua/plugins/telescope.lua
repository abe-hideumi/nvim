-- ファイル・文字列の絞り込み検索
-- `<C-f>` でファイル名検索。そのピッカーの中でもう一度 `<C-f>` を押すと全文検索へ切り替わる
-- `<leader>c` でクリップボードに入れた検索結果（Claude の出力など）をピッカーで開く

-- 1 行から `path:lnum:col:text` / `path:lnum:text` / `path:lnum` / `path` を拾う
-- 箇条書きの `- `、バッククォート、`**` は Claude の出力に混ざるので先に落とす
local function parse_line(line)
	local s = line:gsub("^%s*[-*+]%s+", ""):gsub("^%s*%d+%.%s+", "")
	s = vim.trim((s:gsub("[`*]", "")))

	if s == "" then
		return nil
	end

	-- col まである形（rg --vimgrep）を先に試す。text 側が数字始まりでも
	-- `:` の直後が数字でなければ 2 番目のパターンへ落ちるので取り違えない
	local file, lnum, col, text = s:match("^(%S-):(%d+):(%d+):?%s*(.*)$")

	if not file then
		file, lnum, text = s:match("^(%S-):(%d+):?%s*(.*)$")
	end

	if not file then
		file, text = s:match("^(%S+)$"), ""
	end

	if not file then
		return nil
	end

	return file, tonumber(lnum) or 1, tonumber(col) or 1, text
end

-- Claude を動かしたディレクトリと nvim の cwd がずれていても開けるよう、
-- cwd で見つからなければ git のルートからも探す
local function resolve(file)
	if vim.uv.fs_stat(file) then
		return file
	end

	local root = vim.fs.root(0, ".git")

	if root and vim.uv.fs_stat(root .. "/" .. file) then
		return root .. "/" .. file
	end

	return nil
end

local function open_clipboard_results()
	local items = {}

	for _, line in ipairs(vim.split(vim.fn.getreg("+"), "\n", { trimempty = true })) do
		local file, lnum, col, text = parse_line(line)
		-- 実在するパスだけ残す。地の文が混ざっていてもここで落ちる
		local path = file and resolve(file)

		if path then
			table.insert(items, { filename = path, lnum = lnum, col = col, text = text })
		end
	end

	if #items == 0 then
		vim.notify("クリップボードにファイルパスが見つかりません", vim.log.levels.WARN)
		return
	end

	vim.fn.setqflist({}, " ", { title = "Claude", items = items })
	require("telescope.builtin").quickfix()
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<C-f>", "<cmd>Telescope find_files<CR>", desc = "ファイルを絞り込み検索" },
		{ "<leader>c", open_clipboard_results, desc = "クリップボードの検索結果を開く" },
	},
	opts = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		-- 入力済みの文字列を default_text で引き渡し、打ち直さずに全文検索へ移る
		local switch_to_live_grep = function(prompt_bufnr)
			local prompt = action_state.get_current_line()
			actions.close(prompt_bufnr)
			require("telescope.builtin").live_grep({ default_text = prompt })
		end

		return {
			pickers = {
				find_files = {
					mappings = {
						i = { ["<C-f>"] = switch_to_live_grep },
						n = { ["<C-f>"] = switch_to_live_grep },
					},
				},
			},
		}
	end,
}
