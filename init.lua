-- Pon esto al principio del archivo
vim.env.CFLAGS = "-O0"

-- Set rtp for vim flags
 vim.cmd([[ source vimrc ]])

-- 1. instalador de lazy.nvim
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
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
})

-- 3. Configuración NATIVA de Neovim 0.11 (No más warnings)
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Función auxiliar para arrancar LSPs sin usar el framework deprecado
local function setup_server(name, config)
  local lsp_config = require('lspconfig.configs')[name]
  if lsp_config then
    lsp_config.setup(vim.tbl_extend("force", {
      capabilities = capabilities,
    }, config))
  end
end

-- C# (Omnisharp con O mayúscula)
setup_server("omnisharp", {
  cmd = { mason_bin .. "Omnisharp" },
  root_dir = require('lspconfig.util').root_pattern("*.sln", "*.csproj", ".git") or vim.uv.cwd(),
  settings = {
    RoslynExtensionsOptions = { enableImportCompletion = true }
  }
})

-- Lua
setup_server("lua_ls", {
  cmd = { mason_bin .. "lua-language-server" },
  settings = { Lua = { diagnostics = { globals = {'vim'} } } }
})

-- Sql
setup_server("sqlls", {
    cmd = { mason_bin .. "sql-language-server" },
    filetypes = { "sql", "mysql" },
    root_dir = { function(fname)
		return root_pattern(fname) or vim.loop.os_homedir()
        end },			
    settings = { }
})

-- Bash
setup_server("bash-language-server", {
    cmd = { mason_bin .. "bash-language-server", "start" },
    cmd_env = {
        GLOB_PATTERN = "*@(.sh|.inc|.bash|.command)"
    },
    filetypes = { "sh" },
    root_dir = function(path)
        if not path or #path == 0 then
            return
        end
        local result = path:gsub(strip_sep_pat, ''):gsub(strip_dir_pat, '')
        if #result == 0 then
            return '/'
        end
        return result
    end,
})

-- 4. Opciones de editor
vim.opt.number = true
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Sincronizar PATH para procesos hijos
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
