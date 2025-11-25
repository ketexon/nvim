local o = vim.o
local g = vim.g
local opt = vim.opt
local keymap = vim.keymap

vim.cmd("colorscheme slate")

-- OPTIONS {{{
o.number = true
o.relativenumber = true
o.cursorline = true

o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.showmatch = true
o.hlsearch = true

o.showmode = true

o.history = 100

o.wildmode = "list:longest"

o.foldlevelstart = 99
o.foldmethod = "marker"

o.shiftwidth = 2

o.clipboard = "unnamedplus"

opt.sessionoptions = {
	"buffers",
	"curdir",
	"folds",
	"globals",
	"help",
	"localoptions",
	"options",
	"resize",
	"tabpages",
	"terminal",
	"winsize",
}

g.netrw_preview = 1  -- make preview split vertically (and open)
g.netrw_winsize = 80 -- 80% of screen

if vim.fn.has("win32") > 0 then
	vim.o.shell = 'pwsh.exe'
	vim.o.shellxquote = ''
	vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
	vim.o.shellquote = ''
	vim.o.shellpipe = '| Out-File -Encoding UTF8 %s'
	vim.o.shellredir = '| Out-File -Encoding UTF8 %s'
end
-- }}} OPTIONS

-- PLUGINS {{{

-- MINI {{{
local package_path = vim.fn.stdpath("data") .. "/site/"
local mini_path = package_path .. "pack/deps/start/mini.nvim"

local function mini_exists()
	return vim.uv.fs_stat(mini_path)
end

local function install_mini()
	local clone_cmd = {
		"git", "clone", "--filter=blob:none",
		"https://github.com/nvim-mini/mini.nvim", mini_path
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
end

if not mini_exists() then
	install_mini()
end

require "mini.deps".setup {
	path = { package = package_path },
}

-- }}} MINI

MiniDeps.add {
	source = "neovim/nvim-lspconfig",
	depends = {
		"williamboman/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
	},
}

MiniDeps.add {
	source = "nvim-treesitter/nvim-treesitter",
	checkout = "v0.10.0",
}

MiniDeps.add {
	source = "hrsh7th/nvim-cmp",
	depends = { "hrsh7th/cmp-nvim-lsp" },
}

MiniDeps.add {
	source = "folke/lazydev.nvim",
}

MiniDeps.add {
	source = "nvim-telescope/telescope.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
	},
}

require "mini.sessions".setup()

-- }}} PLUGINS


-- LSP {{{

require "mason".setup {
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
}
require "mason-lspconfig".setup {
	automatic_enable = true,
}

vim.lsp.enable("gdscript")
vim.lsp.enable("godot")

require "lazydev".setup()

require "mini.completion".setup()

-- }}} LSP

-- WORKSPACE {{{
local telescope_actions = require("telescope.actions")
require("telescope").setup {
	defaults = {
		mappings = {
			n = {
				["dd"] = telescope_actions.delete_buffer,
			},
			i = {
				["<C-d>"] = telescope_actions.delete_buffer,
			},
		},
	},
}
-- }}} WORKSPACE

-- KEYBINDS {{{
g.mapleader = " "
g.maplocalleader = " "

vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { desc = "LSP Hover" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostics open float" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation " })

vim.keymap.set("n", "<leader>fd", vim.lsp.buf.format, { desc = "LSP Format" })

-- WORKSPACE {{{
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })

vim.keymap.set("n", "<leader>nn", ":Explore<CR>")
vim.keymap.set("n", "<leader>nl", ":Lexplore<CR>")
vim.keymap.set("n", "<leader>nr", ":Rexplore<CR>")
-- }}} WORKSPACE

-- }}} KEYBINDS
