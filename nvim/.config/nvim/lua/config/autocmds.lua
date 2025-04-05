-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local indent_group = vim.api.nvim_create_augroup("FileTypeIndentation", { clear = true })

local function set_indent(ft, opts)
  vim.api.nvim_create_autocmd("FileType", {
    group = indent_group,
    pattern = ft,
    callback = function()
      for opt, val in pairs(opts) do
        vim.bo[opt] = val
      end
    end,
  })
end

set_indent("python", { shiftwidth = 4, tabstop = 4, expandtab = true })
set_indent("java", { shiftwidth = 4, tabstop = 4, expandtab = true })
set_indent("javascript", { shiftwidth = 2, tabstop = 2, expandtab = true })
set_indent("html", { shiftwidth = 2, tabstop = 2, expandtab = true })
