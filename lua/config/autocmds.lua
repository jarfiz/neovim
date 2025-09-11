-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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
