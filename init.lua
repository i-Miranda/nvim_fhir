-- 0. Variables de entorno y compatibilidad
vim.env.CFLAGS = "-O0"
vim.cmd([[ source ~/.config/nvim/vimrc ]])

-- 1. Instalador de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Plugins
require("lazy").setup({
  { "neovim/nvim-lspconfig" }, 
  { "williamboman/mason.nvim", opts = {} },
  { 
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({ ['<CR>'] = cmp.mapping.confirm({select = true}) }),
        sources = {{ name = 'nvim_lsp' }}
      })
    end
  },
  { "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {} 
    },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

-- 3. Configuración LSPs (Neovim 0.11 Ready)
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"

-- Actualizamos el PATH del sistema para que Neovim encuentre los ejecutables de Mason
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

--- Ayudante para configurar servidores de forma limpia
local function setup(server, config)
  config = config or {}
  config.capabilities = capabilities
  lspconfig[server].setup(config)
end

-- LUA
setup("lua_ls", {
  settings = { Lua = { diagnostics = { globals = {'vim'} } } }
})

-- C# (Omnisharp)
-- Nota: Omnisharp suele requerir el ejecutable 'omnisharp' en minúsculas en Linux/macOS
setup("omnisharp", {
  cmd = { "omnisharp" }, 
  settings = {
    RoslynExtensionsOptions = { enableImportCompletion = true }
  }
})

-- SQL
setup("sqlls", {
  filetypes = { "sql", "mysql" },
  root_dir = function() return vim.uv.cwd() end,
})

-- BASH
setup("bashls", {
  filetypes = { "sh", "bash" },
})

-- 4. Opciones de editor
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
