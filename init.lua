-- 0. Variables de entorno y compatibilidad
vim.env.CFLAGS = "-O0"
vim.cmd([[ source ~/.config/nvim/vimrc ]])
vim.cmd([[ let g:browser='qutebrowser' ]])
vim.opt.termguicolors = true

-- 1. Instalador de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 2. Plugins
require("lazy").setup({
	{ "neovim/nvim-lspconfig" }, -- Sigue siendo útil para las definiciones de servidores
	{ "williamboman/mason.nvim", opts = {} },
	{
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = {
			-- "auto" | "roslyn" | "off"
			--
			-- - "auto": Does nothing for filewatching, leaving everything as default
			-- - "roslyn": Turns off neovim filewatching which will make roslyn do the filewatching
			-- - "off": Hack to turn off all filewatching. (Can be used if you notice performance issues)
			filewatching = "auto",

			-- Optional function that takes an array of targets as the only argument. Return the target you
			-- want to use. If it returns `nil`, then it falls back to guessing the target like normal
			-- Example:
			--
			-- choose_target = function(target)
			--     return vim.iter(target):find(function(item)
			--         if string.match(item, "Foo.sln") then
			--             return item
			--         end
			--     end)
			-- end
			choose_target = nil,

			-- Optional function that takes the selected target as the only argument.
			-- Returns a boolean of whether it should be ignored to attach to or not
			--
			-- I am for example using this to disable a solution with a lot of .NET Framework code on mac
			-- Example:
			--
			-- ignore_target = function(target)
			--     return string.match(target, "Foo.sln") ~= nil
			-- end
			ignore_target = nil,

			-- Whether or not to look for solution files in the child of the (root).
			-- Set this to true if you have some projects that are not a child of the
			-- directory with the solution file
			broad_search = false,

			-- Whether or not to lock the solution target after the first attach.
			-- This will always attach to the target in `vim.g.roslyn_nvim_selected_solution`.
			-- NOTE: You can use `:Roslyn target` to change the target
			lock_target = false,

			-- If the plugin should silence notifications about initialization
			silent = false,
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({ ["<CR>"] = cmp.mapping.confirm({ select = true }) }),
				sources = { { name = "nvim_lsp" } },
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			files = {
				no_ignore = true,
				hidden = true,
			},
		},
	},
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{ "ellisonleao/gruvbox.nvim",        priority = 1000,    config = true, opts = ... },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" }, -- Load before saving to enable format-on-save
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				javascript = { "biome" },
				typescript = { "biome" },
				html = { "htmlbeautifier" },
				css = { "biome" },
				cs = { "csharpier" },
				lua = { "stylua" },
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_format = "fallback", -- If csharpier fails, try the LSP
			},
		},
	},
	{
		'MeanderingProgrammer/render-markdown.nvim',
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
})

-- 3. Configuración NATIVA de LSP (Neovim 0.11+)
-- En lugar de require('lspconfig'), usamos el nuevo sistema de plantillas
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/"
vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

-- enable inline diagnostics globally (show errors + warnings + hints)
vim.diagnostic.config({
	virtual_text = {
		severity = { min = vim.diagnostic.severity.HINT },
		format = function(d)
			return d.message
		end,
	},
	signs = true,
	underline = true,
	float = { border = "rounded" },
})

-- Función para activar servidores usando vim.lsp.config
local function setup_native(server_name, opts)
	opts = opts or {}
	opts.capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities or {})
	-- La nueva forma: habilitamos el servidor directamente en el core
	-- Esto utiliza las configuraciones predefinidas de nvim-lspconfig pero con la API nueva
	vim.lsp.config(server_name, opts)
	vim.lsp.enable(server_name)
end

require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

-- Configuración de servidores específicos
setup_native("lua_ls", {
	settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
setup_native("roslyn", {
	on_attach = function()
		print("This will run when the server attaches!")
	end,
	settings = {
		["csharp|completion"] = {
			-- This allows you to see types even if you haven't added 'using'
			-- that namespace yet.
			dotnet_show_completion_items_from_unimported_namespaces = true,
			dotnet_provide_regex_completions = true,
		},
		["csharp|inlay_hints"] = {
			csharp_enable_inlay_hints_for_implicit_object_creation = true,
			csharp_enable_inlay_hints_for_implicit_variable_types = true,
			csharp_enable_inlay_hints_for_types = true,
			csharp_enable_inlay_hints_for_parameters = true,
		},
		["csharp|code_lens"] = {
			dotnet_enable_references_code_lens = true,
		},
	},
})

setup_native("clangd", {
	filetypes = { "c", "h", "cpp", "hpp" },
	cmd = { "clangd", "--compile-commands-dir=build" },
})

setup_native("sqlls", {
	filetypes = { "sql", "mysql" },
})

setup_native("bashls", {})

setup_native("asm-lsp", {
	filetypes = { "asm", "s", "S" },
})

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

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		always_show_tabline = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
			refresh_time = 16, -- ~60fps
			events = {
				"WinEnter",
				"BufEnter",
				"BufWritePost",
				"SessionLoadPost",
				"FileChangedShellPost",
				"VimResized",
				"Filetype",
				"CursorMoved",
				"CursorMovedI",
				"ModeChanged",
			},
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
