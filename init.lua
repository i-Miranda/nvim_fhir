-- 0. Variables de entorno y compatibilidad
vim.env.CFLAGS = "-O0"
vim.cmd([[ source ~/.config/nvim/vimrc ]])

-- 1. Instalador de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Plugins
require("lazy").setup({
  { "neovim/nvim-lspconfig" }, -- Sigue siendo útil para las definiciones de servidores
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
  { "ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" }, opts = {} },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...}
})

-- 3. Configuración NATIVA de LSP (Neovim 0.11+)
-- En lugar de require('lspconfig'), usamos el nuevo sistema de plantillas
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- Función para activar servidores usando vim.lsp.config
local function setup_native(server_name, opts)
  opts = opts or {}
  opts.capabilities = vim.tbl_deep_extend('force', capabilities, opts.capabilities or {})
  -- La nueva forma: habilitamos el servidor directamente en el core
  -- Esto utiliza las configuraciones predefinidas de nvim-lspconfig pero con la API nueva
  vim.lsp.config(server_name, opts)
  vim.lsp.enable(server_name)
end

-- Configuración de servidores específicos
setup_native("lua_ls", {
  settings = { Lua = { diagnostics = { globals = {'vim'} } } }
})

setup_native("omnisharp", {
  -- Mason instala Omnisharp.cmd en Windows o omnisharp en Unix
  cmd = { "omnisharp" },
  settings = {
    RoslynExtensionsOptions = { enableImportCompletion = true }
  }
})

setup_native("sqlls", {
  filetypes = { "sql", "mysql" }
})

setup_native("bashls", {})

-- 4. Opciones de editor
-- (Tus opciones se mantienen igual)
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- COLOR
vim.o.background = "dark" -- or "light" for light mode
-- Default options:
require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd([[colorscheme gruvbox]])
