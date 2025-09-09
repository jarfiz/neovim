-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Wrapping (VS Code "editor.wordWrap": "on")
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.showbreak = "↪ " -- optional marker

-- Scrolling
opt.scrolloff = 8

-- Clipboard
opt.clipboard = "unnamedplus"

-- Files
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.fixendofline = true
opt.fileformats = { "unix", "dos" }

-- Whitespace trimming (VS Code "files.trim*")
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*" },
  callback = function()
    -- remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- ensure single final newline
    if vim.bo.fileformat ~= "binary" then
      vim.cmd([[silent! %s/\($\n\s*\)\+\%$//]])
    end
  end,
})

-- Autosave (VS Code: "afterDelay": 300ms) but only for web files
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  pattern = { "*.html", "*.css", "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    if vim.bo.modified then
      vim.cmd("silent! write")
    end
  end,
})
