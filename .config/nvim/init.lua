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
	'https://github.com/mikavilpas/yazi.nvim',
	'https://github.com/MeanderingProgrammer/render-markdown.nvim',
	'https://github.com/karb94/neoscroll.nvim',
	'https://github.com/nvim-lualine/lualine.nvim',
	'https://github.com/saghen/blink.cmp',
	'https://github.com/saghen/blink.lib',
	'https://github.com/folke/which-key.nvim',
	'https://github.com/ClearAspect/onehalf',
	'https://github.com/rachartier/tiny-inline-diagnostic.nvim'
})

vim.o.background = 'light'
vim.cmd.colorscheme('onehalflight')

-- Hightlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})


-- Diagnostics

require('tiny-inline-diagnostic').setup({
	preset = "powerline",
	options = {
		multilines = true,
		show_code = false
	}
})

vim.diagnostic.config({
	virtual_lines = false,
	virtual_text = false,
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '✘',
			[vim.diagnostic.severity.WARN]  = '⚠',
			[vim.diagnostic.severity.INFO]  = 'ⓘ',
			[vim.diagnostic.severity.HINT]  = '➤',
		},
	},
})


-- LSP

vim.lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				checkThirdParty = false,
				library = vim.api.nvim_get_runtime_file('', true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})
vim.lsp.enable('lua_ls')

vim.lsp.enable('prismals')
vim.lsp.enable('oxfmt')
vim.lsp.enable('oxlint')
vim.lsp.enable('tilt_ls')

-- Rust

vim.lsp.config("rust_analyzer", {
	cmd = {
		vim.fn.expand("~/.local/share/mise/installs/rust-analyzer/latest/rust-analyzer"),
	},
})

vim.lsp.enable("rust_analyzer")

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

-- Launch sourcekit-lsp through `xcrun` so it resolves to the active Xcode toolchain (which has the iOS SDK).
vim.lsp.config('sourcekit', {
	cmd = { 'xcrun', 'sourcekit-lsp' },
})
vim.lsp.enable('sourcekit')

-- Format on save via LSP. If a dedicated formatter (oxfmt) is attached, only it
-- formats; otherwise fall back to whatever language server offers formatting.
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function(args)
		local has_oxfmt = false
		for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
			if c.name == 'oxfmt' then
				has_oxfmt = true
				break
			end
		end
		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 2000,
			filter = function(client)
				if has_oxfmt then
					return client.name == 'oxfmt'
				end
				return true
			end,
		})
	end,
})

-- Git

vim.g.lazygit_floating_window_scaling_factor = 1

require('gitsigns').setup {
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
				vim.cmd.normal({ ']c', bang = true })
			else
				gitsigns.nav_hunk('next')
			end
		end, { desc = 'Next hunk' })

		map('n', '[c', function()
			if vim.wo.diff then
				vim.cmd.normal({ '[c', bang = true })
			else
				gitsigns.nav_hunk('prev')
			end
		end, { desc = 'Previous hunk' })

		-- Actions
		map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'Stage hunk' })
		map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'Reset hunk' })

		map('v', '<leader>hs', function()
			gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { desc = 'Stage selected hunk' })

		map('v', '<leader>hr', function()
			gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
		end, { desc = 'Reset selected hunk' })

		map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'Stage buffer' })
		map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'Reset buffer' })
		map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'Preview hunk' })
		map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'Preview hunk inline' })

		map('n', '<leader>hb', function()
			gitsigns.blame_line({ full = true })
		end, { desc = 'Blame line' })

		map('n', '<leader>hd', gitsigns.diffthis, { desc = 'Diff this' })

		map('n', '<leader>hD', function()
			gitsigns.diffthis('~')
		end, { desc = 'Diff this (~)' })

		map('n', '<leader>hQ', function() gitsigns.setqflist('all') end, { desc = 'Hunks to quickfix (all)' })
		map('n', '<leader>hq', gitsigns.setqflist, { desc = 'Hunks to quickfix' })

		-- Text object
		map({ 'o', 'x' }, 'ih', gitsigns.select_hunk, { desc = 'Select hunk' })
	end
}

-- Markdown

require('render-markdown').setup({})

-- Scrolling

require('neoscroll').setup({})

-- Statusline

require('lualine').setup({
	options = {
		theme = 'onehalflight',
		globalstatus = true,
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { 'branch', 'diff', 'diagnostics' },
		lualine_c = {},
		lualine_x = { 'filetype' },
		lualine_y = { 'progress' },
		lualine_z = { 'location' },
	},
	winbar = {
		lualine_c = { { 'filename', path = 1 } },
	},
	inactive_winbar = {
		lualine_c = { { 'filename', path = 1 } },
	},
})

-- Completion

local cmp = require('blink.cmp')
cmp.setup({
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
	fuzzy = { implementation = "lua" }
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


-- Which-key

local wk = require('which-key')
wk.setup({})
wk.add({
	{ '<leader>h', group = 'Git hunks' },
})

-- Keymaps

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>o', '<cmd>only<CR>', { desc = 'Close all other splits' })

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>s', telescope.lsp_dynamic_workspace_symbols,
	{ desc = 'Telescope workspace symbols (methods/variables)' })
vim.keymap.set('n', '<leader>t', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>b', telescope.buffers, { desc = 'Telescope buffers' })

vim.keymap.set('n', '<leader>g', vim.cmd.LazyGit, { desc = 'Open Lazygit' })

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
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Diagnostics list' })

vim.keymap.set({ 'n', 'v' }, '<leader>a', vim.lsp.buf.code_action, { desc = 'Code actions' })
vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
