local o = vim.o
local g = vim.g
local opt = vim.opt
local keymap = vim.keymap

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

require "lazydev".setup()

require "mini.completion".setup()

-- }}} LSP

-- SETTINGS {{{
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
-- }}} SETTINGS

-- COLORS {{{
require "mini.hues".setup({
  background = "#111111",
  foreground = "#ffffff",
  accent = "green",
  saturation = "high",
})
-- }}} COLORS

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

-- WORKSPACE {{{
local telescope_builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })
-- }}} WORKSPACE
-- }}} KEYBINDS
