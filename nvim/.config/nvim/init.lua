-- Bootstrap lazy.nvim if it's not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- General Neovim settings
vim.opt.number = true               -- Show line numbers
vim.opt.relativenumber = true        -- Relative line numbers
vim.opt.expandtab = true             -- Convert tabs to spaces
vim.opt.tabstop = 4                  -- Number of spaces for a tab
vim.opt.shiftwidth = 4               -- Indentation size
vim.opt.smartindent = true           -- Enable smart indentation
vim.opt.wrap = false                 -- Disable line wrapping
vim.opt.clipboard = "unnamedplus"    -- Use system clipboard
vim.opt.mouse = "a"                  -- Enable mouse support
vim.opt.termguicolors = true         -- Enable 24-bit RGB colors

-- Setup lazy.nvim
require("lazy").setup({
   -- Alpha-nvim: Start page with custom header
   {
     "goolord/alpha-nvim",
     dependencies = { "nvim-tree/nvim-web-devicons" },
     config = function()
       local alpha = require("alpha")
       local dashboard = require("alpha.themes.dashboard")

       -- Custom ASCII header
       dashboard.section.header.val = {
         ".__   __.  _______   ______   ____    ____  __  .___  ___. ",
         "|  \\ |  | |   ____| /  __  \\  \\   \\  /   / |  | |   \\/   | ",
         "|   \\|  | |  |__   |  |  |  |  \\   \\/   /  |  | |  \\  /  | ",
         "|  . `  | |   __|  |  |  |  |   \\      /   |  | |  |\\/|  | ",
         "|  |\\   | |  |____ |  `--'  |    \\    /    |  | |  |  |  | ",
         "|__| \\__| |_______| \\______/      \\__/     |__| |__|  |__| ",
         "                                                          ",
       }

       -- Set buttons
       dashboard.section.buttons.val = {
         dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
         dashboard.button("f", "󰈞  Find file", ":Telescope find_files <CR>"),
         dashboard.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
         dashboard.button("n", "  File browser", ":NvimTreeToggle<CR>"),
         dashboard.button("q", "  Quit Neovim", ":qa<CR>"),
       }

       -- Set footer (optional)
       dashboard.section.footer.val =""

       -- Apply settings
       alpha.setup(dashboard.opts)

       -- Disable statusline and tabline on start screen
       vim.cmd([[
         autocmd FileType alpha setlocal nofoldenable
       ]])
     end,
   },

   -- OneDark theme with custom tweaks and transparency
   {
     "navarasu/onedark.nvim",
     config = function()
       require('onedark').setup {
         style = 'cool',                -- Use a cooler version of the OneDark theme
         transparent = true,            -- Enable transparent background
         term_colors = true,            -- Use terminal colors
         highlights = {                 -- Customize colors
           Comment = { fg = "#5c6370", italic = true }, -- Make comments italic
         },
       }
       require('onedark').load()
     end,
   },

   -- Add additional popular color schemes
   { "shaunsingh/nord.nvim" },        -- Nord theme
   { "gruvbox-community/gruvbox" },   -- Gruvbox theme
   { "folke/tokyonight.nvim" },       -- Tokyonight theme
   { "EdenEast/nightfox.nvim" },      -- Nightfox theme
   { "sainnhe/everforest" },          -- Everforest theme
   { "NLKNguyen/papercolor-theme" },  -- Papercolor (light and dark)
   { "sainnhe/sonokai" },             -- Sonokai theme
   { "rafamadriz/neon" },             -- Neon theme
   { "projekt0n/github-nvim-theme" }, -- GitHub theme
   { "tanvirtin/monokai.nvim" },      -- Monokai theme
   { "catppuccin/nvim", as = "catppuccin" }, -- Catppuccin theme
   { "dracula/vim", as = "dracula" }, -- Dracula theme
   { "mhartington/oceanic-next" },    -- Oceanic Next theme
   { "altercation/vim-colors-solarized" }, -- Solarized theme (light and dark)
   { "marko-cerovac/material.nvim" }, -- Material theme
   { "rose-pine/neovim", as = "rose-pine" }, -- Rose Pine theme

   -- Lualine: Status line with a theme and icons
   {
     "nvim-lualine/lualine.nvim",
     dependencies = { "nvim-tree/nvim-web-devicons" },
     config = function()
       require('lualine').setup({
         options = {
           theme = 'onedark',  -- Use OneDark theme for status line
           icons_enabled = true,
           component_separators = { left = '', right = ''},
           section_separators = { left = '', right = ''},
         },
       })
     end,
   },

   -- Bufferline: Display open files as tabs
   {
     'akinsho/bufferline.nvim',
     dependencies = { 'nvim-tree/nvim-web-devicons' },
     config = function()
       require("bufferline").setup({
         options = {
           diagnostics = "nvim_lsp",  -- Show diagnostics in bufferline
           offsets = {{ filetype = "NvimTree", text = "File Explorer", text_align = "left" }},
           separator_style = "slant", -- Use slanted separators
         }
       })
     end,
   },

   -- Smooth scrolling for better experience
   { "karb94/neoscroll.nvim", config = function() require('neoscroll').setup() end },

   -- Nvim-tree: File explorer with devicons
   {
     "nvim-tree/nvim-tree.lua",
     config = function()
       require("nvim-tree").setup({
         renderer = {
           icons = {
             show = {
               git = true,
               folder = true,
               file = true,
               folder_arrow = true,
             },
           },
         },
       })
       vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
     end,
     dependencies = { "nvim-tree/nvim-web-devicons" },
   },

   -- Telescope: Fuzzy finding and color scheme switching
   {
     "nvim-telescope/telescope.nvim",
     dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
     config = function()
       require("telescope").setup({
         defaults = {
           prompt_prefix = "> ",
           selection_caret = "> ",
           layout_strategy = "horizontal",
           sorting_strategy = "ascending",
         },
         pickers = {
           colorscheme = {
             enable_preview = true  -- Preview colorschemes in Telescope
           }
         },
       })
       vim.api.nvim_set_keymap("n", "<leader>cs", ":Telescope colorscheme<CR>", { noremap = true, silent = true })
     end,
   },

   -- ALE: Linter for Python and Bash
   { "dense-analysis/ale", config = function()
       vim.g.ale_fix_on_save = 1
       vim.g.ale_fixers = {
         python = {'black'},
         sh = {'shfmt'}
       }
       vim.g.ale_linters = {
         python = {'flake8'},
         sh = {'shellcheck'}
       }
     end,
   },

   -- Indent-Blankline: Version 3+ config (indent guides)
   {
     "lukas-reineke/indent-blankline.nvim",
     config = function()
       require("ibl").setup({
         indent = {
           char = "┊",  -- Change this character to any visual preference
         },
         scope = {
           show_start = true, -- Show scope start line
           show_end = true,   -- Show scope end line
         },
       })
     end,
   },

   -- Python and Bash support
   { "psf/black" },                   -- Python formatter
   { "vim-python/python-syntax" },    -- Python syntax
   { "davidhalter/jedi-vim" },        -- Python autocompletion
   { "sheerun/vim-polyglot" },        -- Language support for Bash, Python, etc.

})

-- Keybindings
vim.api.nvim_set_keymap("n", "<leader>cs", ":Telescope colorscheme<CR>", { noremap = true, silent = true }) -- Switch color schemes
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })            -- Toggle file explorer

