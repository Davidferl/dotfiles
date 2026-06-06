vim.o.number = true
vim.o.wrap = false

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.clipboard = 'unnamedplus'

vim.o.smartcase = true
vim.o.ignorecase = true

vim.o.hlsearch = true
vim.o.completeopt = 'menuone,noselect,popup'
vim.o.cursorline = true
vim.o.signcolumn = 'yes'
vim.o.laststatus = 3
vim.o.winborder = 'rounded'

vim.g.mapleader = vim.keycode('<space>')

vim.pack.add({
	'https://github.com/nvim-lua/plenary.nvim',
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/neovim/nvim-lspconfig',
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-telescope/telescope-ui-select.nvim',
	'https://github.com/kdheepak/lazygit.nvim',
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/rrethy/vim-illuminate',
	'https://github.com/MunifTanjim/nui.nvim',
	'https://github.com/clabby/difftastic.nvim',
	'https://github.com/mikavilpas/yazi.nvim',
	'https://github.com/MeanderingProgrammer/render-markdown.nvim',
	'https://github.com/karb94/neoscroll.nvim',
	'https://github.com/nvim-lualine/lualine.nvim',
	'https://github.com/Saghen/blink.cmp',
	'https://github.com/ThorstenRhau/token',
	'https://github.com/christoomey/vim-tmux-navigator',
})

vim.o.background = 'light'
vim.cmd.colorscheme('token')

-- Soften the diff colors; difftastic and other plugins inherit from these semantic groups
vim.api.nvim_set_hl(0, 'Added', { fg = '#8cb285' })
vim.api.nvim_set_hl(0, 'Removed', { fg = '#d29494' })

-- LSP

vim.lsp.enable('lua_ls')

-- ts_ls needs a `typescript` install to start; without one it exits before attaching.
-- Point it at whatever tsserver is on PATH (e.g. the global mise typescript) so it works
-- even before a project's deps are installed. Derive the lib dir from the binary:
-- <prefix>/typescript/bin/tsserver  ->  <prefix>/typescript/lib
local tsserver = vim.fn.exepath('tsserver')
if tsserver ~= '' then
	local real = vim.uv.fs_realpath(tsserver) or tsserver
	local lib = vim.fs.joinpath(vim.fs.dirname(vim.fs.dirname(real)), 'lib')
	vim.lsp.config('ts_ls', {
		init_options = { tsserver = { path = lib } },
	})
end
vim.lsp.enable('ts_ls')
vim.lsp.enable('prismals')
vim.lsp.enable('oxfmt')
vim.lsp.enable('oxlint')
vim.lsp.enable('tilt_ls')
vim.lsp.enable('sourcekit')

-- Git

vim.g.lazygit_floating_window_scaling_factor = 1

require('gitsigns').setup{
  current_line_blame = true,
  on_attach = function(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end)

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end)

    -- Actions
    map('n', '<leader>hs', gitsigns.stage_hunk)
    map('n', '<leader>hr', gitsigns.reset_hunk)

    map('v', '<leader>hs', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('v', '<leader>hr', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end)

    map('n', '<leader>hS', gitsigns.stage_buffer)
    map('n', '<leader>hR', gitsigns.reset_buffer)
    map('n', '<leader>hp', gitsigns.preview_hunk)
    map('n', '<leader>hi', gitsigns.preview_hunk_inline)

    map('n', '<leader>hb', function()
      gitsigns.blame_line({ full = true })
    end)

    map('n', '<leader>hd', gitsigns.diffthis)

    map('n', '<leader>hD', function()
      gitsigns.diffthis('~')
    end)

    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    map('n', '<leader>hq', gitsigns.setqflist)

    -- Text object
    map({'o', 'x'}, 'ih', gitsigns.select_hunk)
  end
}

-- Diff

require('difftastic-nvim').setup({
  vcs = 'git',
  download = false,
})

-- Markdown

require('render-markdown').setup({})

-- Scrolling

require('neoscroll').setup({})

-- Statusline

require('lualine').setup({
  options = {
    theme = 'token',
    globalstatus = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
})

-- Completion

require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'accept', 'fallback' },
  },
  completion = {
    documentation = { auto_show = true },
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
})

-- Telescope

require('telescope').setup({
  defaults = {
    sorting_strategy = 'ascending',
    layout_config = {
      prompt_position = 'top',
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      file_ignore_patterns = { '^%.git/' },
    },
    live_grep = {
      previewer = false,
      additional_args = function() return { '--hidden', '--glob', '!**/.git/*' } end,
    },
    buffers = {
      previewer = false,
    },
    lsp_dynamic_workspace_symbols = {
      symbols = { 'method', 'variable' },
      fname_width = 60,
      symbol_width = 30,
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown({}),
    },
  },
})
require('telescope').load_extension('ui-select')

-- Make the matched line in the grep preview clearly visible
vim.api.nvim_set_hl(0, 'TelescopePreviewLine', { bg = '#fff3a3', bold = true })

-- Diagnostics

vim.diagnostic.config({ underline = true, virtual_text = true, signs = true, severity_sort = true })

-- Keymaps

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>o', '<cmd>only<CR>', { desc = 'Close all other splits' })

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>s', telescope.lsp_dynamic_workspace_symbols, { desc = 'Telescope workspace symbols (methods/variables)' })
vim.keymap.set('n', '<leader>t', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', telescope.buffers, { desc = 'Telescope buffers' })

vim.keymap.set('n', '<leader>g', vim.cmd.LazyGit, { desc = 'Open Lazygit'})

vim.keymap.set('n', '<leader>dd', '<cmd>Difft origin/master...HEAD<CR>', { desc = 'Difftastic: diff branch against master' })
vim.keymap.set('n', '<leader>ds', '<cmd>Difft --staged<CR>', { desc = 'Difftastic: diff staged changes' })
vim.keymap.set('n', '<leader>dc', '<cmd>DifftClose<CR>', { desc = 'Difftastic: close diff' })

require('yazi').setup({
  open_for_directories = true,
  floating_window_scaling_factor = 1.0,
  yazi_floating_window_border = 'none',
  keymaps = {
    show_help = '<c-_>',
  },
})

vim.keymap.set('n', '<leader>e', '<cmd>Yazi<CR>', { desc = 'Open Yazi' })
vim.keymap.set('n', '<leader>cw', '<cmd>Yazi cwd<CR>', { desc = 'Open Yazi in cwd' })

vim.keymap.set('n', '<leader>r', '<cmd>edit!<CR>', { desc = 'Reload file from disk (:e!)' })

vim.keymap.set('n', 'Q', vim.diagnostic.open_float, { desc = 'Line diagnostics (float)' })
vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, { desc = 'Code actions' })

