vim.o.number = true
vim.o.wrap = false

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.hlsearch = false
vim.o.signcolumn = 'yes'

vim.cmd.colorscheme('retrobox')

vim.keymap.set({'n', 'x'}, 'y', '"+y', {desc = 'Copy to clipboard'})
vim.keymap.set({'n', 'x'}, 'p', '"+p', {desc = 'Paste clipboard content'})

vim.g.mapleader = vim.keycode('<Space>')

vim.keymap.set('n', '<leader>h', '<cmd>echo "hello there"<cr>')
