-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }

vim.keymap.set("i", "jj", "<Esc>", opts)
vim.keymap.set("i", "kk", "<Esc>", opts)

vim.keymap.set("i", "<C-CR>", "<C-o>o", opts)
vim.keymap.set("i", "<C-Enter>", "<C-o>o", opts)
vim.keymap.set("i", "<C-Return>", "<C-o>o", opts)

vim.keymap.set("i", "<C-S-CR>", "<C-o>O", opts)
vim.keymap.set("i", "<C-S-Enter>", "<C-o>O", opts)
vim.keymap.set("i", "<C-S-Return>", "<C-o>O", opts)

-- Normal mode: open a new line below/above and enter insert (o / O)
vim.keymap.set("n", "<C-CR>", "o", opts)
vim.keymap.set("n", "<C-Enter>", "o", opts)
vim.keymap.set("n", "<C-Return>", "o", opts)

vim.keymap.set("n", "<C-S-CR>", "O", opts)
vim.keymap.set("n", "<C-S-Enter>", "O", opts)
vim.keymap.set("n", "<C-S-Return>", "O", opts)

-- Visual mode: exit visual, then open new line below/above and enter insert
vim.keymap.set("v", "<C-CR>", "<Esc>o", opts)
vim.keymap.set("v", "<C-Enter>", "<Esc>o", opts)
vim.keymap.set("v", "<C-Return>", "<Esc>o", opts)

vim.keymap.set("v", "<C-S-CR>", "<Esc>O", opts)
vim.keymap.set("v", "<C-S-Enter>", "<Esc>O", opts)
vim.keymap.set("v", "<C-S-Return>", "<Esc>O", opts)


-- Duplicate line(s) down / up in normal and visual modes (Shift+Alt+J / Shift+Alt+K)
local function duplicate_down()
	local bufnr = vim.api.nvim_get_current_buf()
	local mode = vim.fn.mode()
	if mode == 'v' or mode == 'V' or mode == '\22' then
		-- Visual mode: get selection range (ensure start <= end)
		local s = vim.fn.getpos("'<")[2]
		local e = vim.fn.getpos("'>")[2]
		if s > e then s, e = e, s end
		local lines = vim.api.nvim_buf_get_lines(bufnr, s-1, e, false)
		-- insert after the selection
		vim.api.nvim_buf_set_lines(bufnr, e, e, false, lines)
		-- place cursor on first line of the inserted block
		vim.api.nvim_win_set_cursor(0, {e+1, 0})
	else
		-- Normal mode: duplicate current line below
		local r = vim.api.nvim_win_get_cursor(0)[1]
		local line = vim.api.nvim_buf_get_lines(bufnr, r-1, r, false)
		vim.api.nvim_buf_set_lines(bufnr, r, r, false, line)
		vim.api.nvim_win_set_cursor(0, {r+1, 0})
	end
end

local function duplicate_up()
	local bufnr = vim.api.nvim_get_current_buf()
	local mode = vim.fn.mode()
	if mode == 'v' or mode == 'V' or mode == '\22' then
		local s = vim.fn.getpos("'<")[2]
		local e = vim.fn.getpos("'>")[2]
		if s > e then s, e = e, s end
		local lines = vim.api.nvim_buf_get_lines(bufnr, s-1, e, false)
		-- insert before the selection
		vim.api.nvim_buf_set_lines(bufnr, s-1, s-1, false, lines)
		-- place cursor on first line of the inserted block
		vim.api.nvim_win_set_cursor(0, {s, 0})
	else
		local r = vim.api.nvim_win_get_cursor(0)[1]
		local line = vim.api.nvim_buf_get_lines(bufnr, r-1, r, false)
		-- insert above current line
		vim.api.nvim_buf_set_lines(bufnr, r-1, r-1, false, line)
		vim.api.nvim_win_set_cursor(0, {r, 0})
	end
end

-- Map several variants (Alt/Meta, shifted/unshifted) to cover terminals and GUIs
local dup_opts = vim.tbl_extend('force', opts, { expr = false })
for _, rhs in ipairs({duplicate_down, duplicate_up}) do end

-- Down: Shift+Alt+J (and common variants)
vim.keymap.set({'n', 'v'}, '<A-J>', duplicate_down, dup_opts)
vim.keymap.set({'n', 'v'}, '<A-j>', duplicate_down, dup_opts)
vim.keymap.set({'n', 'v'}, '<M-J>', duplicate_down, dup_opts)
vim.keymap.set({'n', 'v'}, '<M-j>', duplicate_down, dup_opts)

-- Up: Shift+Alt+K (and common variants)
vim.keymap.set({'n', 'v'}, '<A-K>', duplicate_up, dup_opts)
vim.keymap.set({'n', 'v'}, '<A-k>', duplicate_up, dup_opts)
vim.keymap.set({'n', 'v'}, '<M-K>', duplicate_up, dup_opts)
vim.keymap.set({'n', 'v'}, '<M-k>', duplicate_up, dup_opts)
