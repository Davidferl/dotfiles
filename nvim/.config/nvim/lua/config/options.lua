-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.fn.has("mac") == 1 then
  vim.opt.shell = "/opt/homebrew/bin/fish" -- Homebrew installation path on macOS
else
  vim.opt.shell = "/usr/bin/fish -l"
end
vim.g.lazyvim_prettier_needs_config = false
vim.opt.textwidth = 120
vim.opt.laststatus = 3
vim.opt.termguicolors = true
