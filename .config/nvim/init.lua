vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.so = 9999 -- cursor always on center

-- enable highlight groups
vim.opt.termguicolors = true

vim.opt.smartindent = true
-- vim.o.tabstop = 4
-- vim.o.shiftwidth = 4
-- vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.cursorline = true
vim.cmd("set rnu")                                   -- relative numbers
vim.g.zig_fmt_autosave = 0                           -- disable autoformat zig

vim.opt.guifont = { "JetBrains Mono" }               -- font

vim.o.hlsearch = true                                -- Set highlight on search
vim.wo.number = true                                 -- Make line numbers default
vim.o.mouse = 'a'                                    -- Enable mouse mode
vim.o.breakindent = true                             -- Enable break indent
vim.o.undofile = true                                -- Save undo history
vim.o.ignorecase = true                              -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'                            -- Keep signcolumn on by default
vim.o.updatetime = 250                               -- Decrease update time
vim.o.timeoutlen = 300
vim.o.completeopt = 'menu,menuone,noinsert,noselect' -- Set completeopt to have a better completion experience
vim.o.termguicolors = true                           -- NOTE: You should make sure your terminal supports this
vim.o.cmdheight = 0                                  -- bottom bar height

-- [[ Basic Keymaps ]] Keymaps for better default experience, See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Install package manager, https://github.com/folke/lazy.nvim `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({

  -- terminal
  {
    'akinsho/toggleterm.nvim',
    config = function() require("toggleterm").setup() end
  },

  -- debugger
  { 'mfussenegger/nvim-dap' },
  {
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" }
  },

  -- highlight current word
  { "RRethy/vim-illuminate" },
  { 'booperlv/nvim-gomove' },                    -- move lines

  { 'Shatur/neovim-session-manager' },           -- session manager
  { 'nvim-treesitter/nvim-treesitter-context' }, -- show the function that you are in on top on the code
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
  },
  { -- trim spaces
    "mcauley-penney/tidy.nvim",
    config = function() require("tidy").setup() end
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    config = function()
      require('telescope').load_extension('dap')
    end
  },

  { 'nvim-tree/nvim-web-devicons', opts = {} },

  -- Git related plugins
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  { 'sindrets/diffview.nvim' }, -- see files diff

  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth' },

  -- NOTE: This is where your plugins related to LSP can be installed. The configuration is done below. Search for lspconfig to find it below.
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP, NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        opts = {
          window = { blend = 0 },
        }
      },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },
  {
    'nacro90/numb.nvim', -- peek lines with :123
    config = function()
      require('numb').setup()
    end
  },
  {
    "mbbill/undotree",
    config = function()
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_SplitWidth = 50
      vim.g.undotree_DiffpanelHeight = 20
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_TreeNodeShape = "♦"
      vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "Toggle Undotree", silent = true })
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {
      ignored_next_char = "[%w%.]",
      enable_check_bracket_line = false,
      fast_wrap = {
        map = '<a-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        manual_position = true,
        highlight = 'Search',
        highlight_grey = 'Comment'
      },
    }
  },

  { "tikhomirov/vim-glsl" }, -- glsl syntax highlight
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add          = { text = '▌' }, -- https://www.fileformat.info/info/charset/UTF-32/list.htm?start=8680
        change       = { text = '▎' },
        delete       = { text = '▄' },
        topdelete    = { text = '▔' },
        changedelete = { text = '▏' },
        untracked    = { text = '┆' },
      },
      current_line_blame = true,
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk, { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
        vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk, { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
        vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk, { buffer = bufnr, desc = '[P]review [H]unk' })
      end,
    },
  },
  {
    -- 'psliwka/vim-smoothie'
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end
  },
  -- {
  --   -- Theme inspired by Atom
  --   'navarasu/onedark.nvim',
  --   priority = 1000,
  --   config = function()
  --     local green = "#99bc80"
  --     local orange = "#ce7700"
  --     local light_orange = "#ee9770"
  --     local yellow = "#dfbe81"
  --
  --     -- borders on lsp popup
  --     local border = { border = "rounded" }
  --     vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border)
  --     vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border)
  --     vim.diagnostic.config { float = border }
  --
  --     require('onedark').setup {
  --       style = "warm",     -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
  --       transparent = true, -- Show/hide background
  --       -- colors = {
  --       --     orange = green,
  --       --     green = light_orange,
  --       -- },
  --       highlights = {
  --         ['@punctuation'] = { fg = yellow },
  --         ['@punctuation.bracket'] = { fg = yellow },
  --         ['@punctuation.delimiter'] = { fg = yellow },
  --         ['@lsp.type.type'] = { fg = green },
  --         ['@type'] = { fg = green },
  --         ['Type'] = { fg = green },
  --         ['@lsp.type.struct'] = { fg = green },
  --         ['Structure'] = { fg = green },
  --         ['@operator'] = { fg = orange },
  --       },
  --     }
  --
  --     vim.cmd.colorscheme 'onedark'
  --   end,
  -- },
  -- {
  --   "doums/darcula",
  --   config = function()
  --     vim.cmd.colorscheme("darcula")
  --   end
  --
  -- },
  -- {
  --   "catppuccin/nvim",
  --   config = function()
  --     require("catppuccin").setup {
  --       background = {
  --         light = "latte",
  --         dark = "mocha",
  --       },
  --       -- TODO: move to its on file
  --       color_overrides = {
  --         latte = {
  --           rosewater = "#c14a4a",
  --           flamingo = "#c14a4a",
  --           red = "#c14a4a",
  --           maroon = "#c14a4a",
  --           pink = "#945e80",
  --           mauve = "#945e80",
  --           peach = "#c35e0a",
  --           yellow = "#b47109",
  --           green = "#6c782e",
  --           teal = "#4c7a5d",
  --           sky = "#4c7a5d",
  --           sapphire = "#4c7a5d",
  --           blue = "#45707a",
  --           lavender = "#45707a",
  --           text = "#654735",
  --           subtext1 = "#73503c",
  --           subtext0 = "#805942",
  --           overlay2 = "#8c6249",
  --           overlay1 = "#8c856d",
  --           overlay0 = "#a69d81",
  --           surface2 = "#bfb695",
  --           surface1 = "#d1c7a3",
  --           surface0 = "#e3dec3",
  --           base = "#f9f5d7",
  --           mantle = "#f0ebce",
  --           crust = "#e8e3c8",
  --         },
  --         mocha = {
  --           rosewater = "#ea6962",
  --           flamingo = "#ea6962",
  --           red = "#ea6962",
  --           maroon = "#ea6962",
  --           pink = "#d3869b",
  --           mauve = "#d3869b",
  --           peach = "#e78a4e",
  --           yellow = "#d8a657",
  --           green = "#a9b665",
  --           teal = "#89b482",
  --           sky = "#89b482",
  --           sapphire = "#89b482",
  --           blue = "#7daea3",
  --           lavender = "#7daea3",
  --           text = "#ebdbb2",
  --           subtext1 = "#d5c4a1",
  --           subtext0 = "#bdae93",
  --           overlay2 = "#a89984",
  --           overlay1 = "#928374",
  --           overlay0 = "#595959",
  --           surface2 = "#4d4d4d",
  --           surface1 = "#404040",
  --           surface0 = "#292929",
  --           base = "#1d2021",
  --           mantle = "#191b1c",
  --           crust = "#141617",
  --         },
  --       },
  --       transparent_background = true,
  --       show_end_of_buffer = false,
  --       integration_default = false,
  --       integrations = {
  --         barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
  --         cmp = true,
  --         gitsigns = true,
  --         hop = true,
  --         illuminate = true,
  --         native_lsp = { enabled = true, inlay_hints = { background = true } },
  --         neogit = true,
  --         neotree = true,
  --         semantic_tokens = true,
  --         treesitter = true,
  --         treesitter_context = true,
  --         vimwiki = true,
  --         which_key = true,
  --       },
  --       highlight_overrides = {
  --         all = function(colors)
  --           return {
  --             Visual = { fg = "#ffffff", bg = "#6060aa" },
  --             CmpItemMenu = { fg = colors.surface2 },
  --             CursorLineNr = { fg = colors.text },
  --             FloatBorder = { bg = colors.base, fg = colors.surface0 },
  --             GitSignsChange = { fg = colors.peach },
  --             LineNr = { fg = colors.overlay0 },
  --             LspInfoBorder = { link = "FloatBorder" },
  --             NeoTreeDirectoryIcon = { fg = colors.subtext0 },
  --             NeoTreeDirectoryName = { fg = colors.subtext0 },
  --             NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
  --             NeoTreeGitConflict = { fg = colors.red },
  --             NeoTreeGitDeleted = { fg = colors.red },
  --             NeoTreeGitIgnored = { fg = colors.overlay0 },
  --             NeoTreeGitModified = { fg = colors.peach },
  --             NeoTreeGitStaged = { fg = colors.green },
  --             NeoTreeGitUnstaged = { fg = colors.red },
  --             NeoTreeGitUntracked = { fg = colors.green },
  --             NeoTreeIndent = { fg = colors.surface1 },
  --             NeoTreeNormal = { bg = colors.mantle },
  --             NeoTreeNormalNC = { bg = colors.mantle },
  --             NeoTreeRootName = { fg = colors.subtext0, style = { "bold" } },
  --             NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
  --             NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
  --             NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
  --             NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
  --             NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
  --             NormalFloat = { bg = colors.base },
  --             Pmenu = { bg = colors.mantle, fg = "" },
  --             PmenuSel = { bg = colors.surface0, fg = "" },
  --             -- TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
  --             -- TelescopePreviewNormal = { bg = colors.crust },
  --             -- TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
  --             -- TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
  --             -- TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
  --             -- TelescopePromptNormal = { bg = colors.surface0 },
  --             -- TelescopePromptPrefix = { bg = colors.surface0 },
  --             -- TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
  --             -- TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
  --             -- TelescopeResultsNormal = { bg = colors.mantle },
  --             -- TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
  --             -- TelescopeSelection = { bg = colors.surface0 },
  --             VertSplit = { bg = colors.base, fg = colors.surface0 },
  --             WhichKeyFloat = { bg = colors.mantle },
  --             YankHighlight = { bg = colors.surface2 },
  --             FidgetTask = { fg = colors.subtext1 },
  --             FidgetTitle = { fg = colors.peach },
  --
  --             IblIndent = { fg = colors.surface0 },
  --             IblScope = { fg = colors.overlay0 },
  --
  --             Boolean = { fg = colors.mauve },
  --             Number = { fg = colors.mauve },
  --             Float = { fg = colors.mauve },
  --
  --             PreProc = { fg = colors.mauve },
  --             PreCondit = { fg = colors.mauve },
  --             Include = { fg = colors.mauve },
  --             Define = { fg = colors.mauve },
  --             Conditional = { fg = colors.red },
  --             Repeat = { fg = colors.red },
  --             Keyword = { fg = colors.red },
  --             Typedef = { fg = colors.red },
  --             Exception = { fg = colors.red },
  --             Statement = { fg = colors.red },
  --
  --             Error = { fg = colors.red },
  --             StorageClass = { fg = colors.peach },
  --             Tag = { fg = colors.peach },
  --             Label = { fg = colors.peach },
  --             Structure = { fg = colors.peach },
  --             Operator = { fg = colors.peach },
  --             Title = { fg = colors.peach },
  --             Special = { fg = colors.yellow },
  --             SpecialChar = { fg = colors.yellow },
  --             Type = { fg = colors.yellow, style = { "bold" } },
  --             Function = { fg = colors.green, style = { "bold" } },
  --             Delimiter = { fg = colors.subtext1 },
  --             Ignore = { fg = colors.subtext1 },
  --             Macro = { fg = colors.teal },
  --
  --             TSAnnotation = { fg = colors.mauve },
  --             TSAttribute = { fg = colors.mauve },
  --             TSBoolean = { fg = colors.mauve },
  --             TSCharacter = { fg = colors.teal },
  --             TSCharacterSpecial = { link = "SpecialChar" },
  --             TSComment = { link = "Comment" },
  --             TSConditional = { fg = colors.red },
  --             TSConstBuiltin = { fg = colors.mauve },
  --             TSConstMacro = { fg = colors.mauve },
  --             TSConstant = { fg = colors.text },
  --             TSConstructor = { fg = colors.green },
  --             TSDebug = { link = "Debug" },
  --             TSDefine = { link = "Define" },
  --             TSEnvironment = { link = "Macro" },
  --             TSEnvironmentName = { link = "Type" },
  --             TSError = { link = "Error" },
  --             TSException = { fg = colors.red },
  --             TSField = { fg = colors.blue },
  --             TSFloat = { fg = colors.mauve },
  --             TSFuncBuiltin = { fg = colors.green },
  --             TSFuncMacro = { fg = colors.green },
  --             TSFunction = { fg = colors.green },
  --             TSFunctionCall = { fg = colors.green },
  --             TSInclude = { fg = colors.red },
  --             TSKeyword = { fg = colors.red },
  --             TSKeywordFunction = { fg = colors.red },
  --             TSKeywordOperator = { fg = colors.peach },
  --             TSKeywordReturn = { fg = colors.red },
  --             TSLabel = { fg = colors.peach },
  --             TSLiteral = { link = "String" },
  --             TSMath = { fg = colors.blue },
  --             TSMethod = { fg = colors.green },
  --             TSMethodCall = { fg = colors.green },
  --             TSNamespace = { fg = colors.yellow },
  --             TSNone = { fg = colors.text },
  --             TSNumber = { fg = colors.mauve },
  --             TSOperator = { fg = colors.peach },
  --             TSParameter = { fg = colors.text },
  --             TSParameterReference = { fg = colors.text },
  --             TSPreProc = { link = "PreProc" },
  --             TSProperty = { fg = colors.blue },
  --             TSPunctBracket = { fg = colors.text },
  --             TSPunctDelimiter = { link = "Delimiter" },
  --             TSPunctSpecial = { fg = colors.blue },
  --             TSRepeat = { fg = colors.red },
  --             TSStorageClass = { fg = colors.peach },
  --             TSStorageClassLifetime = { fg = colors.peach },
  --             TSStrike = { fg = colors.subtext1 },
  --             TSString = { fg = colors.teal },
  --             TSStringEscape = { fg = colors.green },
  --             TSStringRegex = { fg = colors.green },
  --             TSStringSpecial = { link = "SpecialChar" },
  --             TSSymbol = { fg = colors.text },
  --             TSTag = { fg = colors.peach },
  --             TSTagAttribute = { fg = colors.green },
  --             TSTagDelimiter = { fg = colors.green },
  --             TSText = { fg = colors.green },
  --             TSTextReference = { link = "Constant" },
  --             TSTitle = { link = "Title" },
  --             TSTodo = { link = "Todo" },
  --             TSType = { fg = colors.yellow, style = { "bold" } },
  --             TSTypeBuiltin = { fg = colors.yellow, style = { "bold" } },
  --             TSTypeDefinition = { fg = colors.yellow, style = { "bold" } },
  --             TSTypeQualifier = { fg = colors.peach, style = { "bold" } },
  --             TSURI = { fg = colors.blue },
  --             TSVariable = { fg = colors.text },
  --             TSVariableBuiltin = { fg = colors.mauve },
  --
  --             ["@annotation"] = { link = "TSAnnotation" },
  --             ["@attribute"] = { link = "TSAttribute" },
  --             ["@boolean"] = { link = "TSBoolean" },
  --             ["@character"] = { link = "TSCharacter" },
  --             ["@character.special"] = { link = "TSCharacterSpecial" },
  --             ["@comment"] = { link = "TSComment" },
  --             ["@conceal"] = { link = "Grey" },
  --             ["@conditional"] = { link = "TSConditional" },
  --             ["@constant"] = { link = "TSConstant" },
  --             ["@constant.builtin"] = { link = "TSConstBuiltin" },
  --             ["@constant.macro"] = { link = "TSConstMacro" },
  --             ["@constructor"] = { link = "TSConstructor" },
  --             ["@debug"] = { link = "TSDebug" },
  --             ["@define"] = { link = "TSDefine" },
  --             ["@error"] = { link = "TSError" },
  --             ["@exception"] = { link = "TSException" },
  --             ["@field"] = { link = "TSField" },
  --             ["@float"] = { link = "TSFloat" },
  --             ["@function"] = { link = "TSFunction" },
  --             ["@function.builtin"] = { link = "TSFuncBuiltin" },
  --             ["@function.call"] = { link = "TSFunctionCall" },
  --             ["@function.macro"] = { link = "TSFuncMacro" },
  --             ["@include"] = { link = "TSInclude" },
  --             ["@keyword"] = { link = "TSKeyword" },
  --             ["@keyword.function"] = { link = "TSKeywordFunction" },
  --             ["@keyword.operator"] = { link = "TSKeywordOperator" },
  --             ["@keyword.return"] = { link = "TSKeywordReturn" },
  --             ["@label"] = { link = "TSLabel" },
  --             ["@math"] = { link = "TSMath" },
  --             ["@method"] = { link = "TSMethod" },
  --             ["@method.call"] = { link = "TSMethodCall" },
  --             ["@namespace"] = { link = "TSNamespace" },
  --             ["@none"] = { link = "TSNone" },
  --             ["@number"] = { link = "TSNumber" },
  --             ["@operator"] = { link = "TSOperator" },
  --             ["@parameter"] = { link = "TSParameter" },
  --             ["@parameter.reference"] = { link = "TSParameterReference" },
  --             ["@preproc"] = { link = "TSPreProc" },
  --             ["@property"] = { link = "TSProperty" },
  --             ["@punctuation.bracket"] = { link = "TSPunctBracket" },
  --             ["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
  --             ["@punctuation.special"] = { link = "TSPunctSpecial" },
  --             ["@repeat"] = { link = "TSRepeat" },
  --             ["@storageclass"] = { link = "TSStorageClass" },
  --             ["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
  --             ["@strike"] = { link = "TSStrike" },
  --             ["@string"] = { link = "TSString" },
  --             ["@string.escape"] = { link = "TSStringEscape" },
  --             ["@string.regex"] = { link = "TSStringRegex" },
  --             ["@string.special"] = { link = "TSStringSpecial" },
  --             ["@symbol"] = { link = "TSSymbol" },
  --             ["@tag"] = { link = "TSTag" },
  --             ["@tag.attribute"] = { link = "TSTagAttribute" },
  --             ["@tag.delimiter"] = { link = "TSTagDelimiter" },
  --             ["@text"] = { link = "TSText" },
  --             ["@text.danger"] = { link = "TSDanger" },
  --             ["@text.diff.add"] = { link = "diffAdded" },
  --             ["@text.diff.delete"] = { link = "diffRemoved" },
  --             ["@text.emphasis"] = { link = "TSEmphasis" },
  --             ["@text.environment"] = { link = "TSEnvironment" },
  --             ["@text.environment.name"] = { link = "TSEnvironmentName" },
  --             ["@text.literal"] = { link = "TSLiteral" },
  --             ["@text.math"] = { link = "TSMath" },
  --             ["@text.note"] = { link = "TSNote" },
  --             ["@text.reference"] = { link = "TSTextReference" },
  --             ["@text.strike"] = { link = "TSStrike" },
  --             ["@text.strong"] = { link = "TSStrong" },
  --             ["@text.title"] = { link = "TSTitle" },
  --             ["@text.todo"] = { link = "TSTodo" },
  --             ["@text.todo.checked"] = { link = "Green" },
  --             ["@text.todo.unchecked"] = { link = "Ignore" },
  --             ["@text.underline"] = { link = "TSUnderline" },
  --             ["@text.uri"] = { link = "TSURI" },
  --             ["@text.warning"] = { link = "TSWarning" },
  --             ["@todo"] = { link = "TSTodo" },
  --             ["@type"] = { link = "TSType" },
  --             ["@type.builtin"] = { link = "TSTypeBuiltin" },
  --             ["@type.definition"] = { link = "TSTypeDefinition" },
  --             ["@type.qualifier"] = { link = "TSTypeQualifier" },
  --             ["@uri"] = { link = "TSURI" },
  --             ["@variable"] = { link = "TSVariable" },
  --             ["@variable.builtin"] = { link = "TSVariableBuiltin" },
  --
  --             ["@lsp.type.class"] = { link = "TSType" },
  --             ["@lsp.type.comment"] = { link = "TSComment" },
  --             ["@lsp.type.decorator"] = { link = "TSFunction" },
  --             ["@lsp.type.enum"] = { link = "TSType" },
  --             ["@lsp.type.enumMember"] = { link = "TSProperty" },
  --             ["@lsp.type.events"] = { link = "TSLabel" },
  --             ["@lsp.type.function"] = { link = "TSFunction" },
  --             ["@lsp.type.interface"] = { link = "TSType" },
  --             ["@lsp.type.keyword"] = { link = "TSKeyword" },
  --             ["@lsp.type.macro"] = { link = "TSConstMacro" },
  --             ["@lsp.type.method"] = { link = "TSMethod" },
  --             ["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
  --             ["@lsp.type.namespace"] = { link = "TSNamespace" },
  --             ["@lsp.type.number"] = { link = "TSNumber" },
  --             ["@lsp.type.operator"] = { link = "TSOperator" },
  --             ["@lsp.type.parameter"] = { link = "TSParameter" },
  --             ["@lsp.type.property"] = { link = "TSProperty" },
  --             ["@lsp.type.regexp"] = { link = "TSStringRegex" },
  --             ["@lsp.type.string"] = { link = "TSString" },
  --             ["@lsp.type.struct"] = { link = "TSType" },
  --             ["@lsp.type.type"] = { link = "TSType" },
  --             ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
  --             ["@lsp.type.variable"] = { link = "TSVariable" },
  --           }
  --         end,
  --         latte = function(colors)
  --           return {
  --             IblIndent = { fg = colors.mantle },
  --             IblScope = { fg = colors.surface1 },
  --
  --             LineNr = { fg = colors.surface1 },
  --           }
  --         end,
  --       },
  --     }
  --
  --     -- vim.cmd.colorscheme("catppuccin")
  --   end
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   config = function()
  --     require("gruvbox").setup{
  --       palette_overrides = {
  --         -- dark0_hard = "#000000",
  --         dark0 = "#252525", ---------- background
  --         -- dark0_soft = "#000000",
  --         dark1 = "#303030", ---------- barra lateral esquerda onde fica os breakpoints e infos sobre a linha
  --         dark2 = "#555555", ---------- barra de indentacao
  --         dark3 = "#3f3f3f", ---------- selecao de linhas
  --         dark4 = "#777777", ---------- numeracao da linha
  --         -- light0_hard = "#000000",
  --         -- light0 = "#000000",
  --         -- light0_soft = "#000000",
  --         light1 = "#bfbfbf", --------- palavras principais(nome de variaveis criadas)
  --         light2 = "#dddddd", --------- cor padrao de icone sem cor especifica
  --         -- light3 = "#000000",
  --         light4 = "#aa9989", --------- letras marcadas para chamar atencao nos menus
  --         -- bright_red = "#ab3fff", ----- palavras reservadas da linguagem(keywords)
  --         bright_green = "#b4ad4a", --- funcoes
  --         bright_yellow = "#60b34e", -- Tipos de variaveis(int, float...)
  --         bright_blue = "#909090", ---- nome de parametro de func e parametro de struct
  --         bright_purple = "#b8b773", -- numeros e constantes
  --         bright_aqua = "#b8b773",----- include e defines
  --         bright_orange = "#33aa33", -- pontuacao
  --         neutral_red = "#ff1111", ---- erro no terminal
  --         neutral_green = "#aa5555", -- nome de arquivo .sh no explorer
  --         neutral_yellow = "#ff0000",-- arquivos com erro mp explorer
  --         neutral_blue = "#bfbfbf", --- cor da pasta no explorer
  --         neutral_purple = "#cccccc",-- pasta root do explorer
  --         neutral_aqua = "#aa5555", --- nome de arquivo (desconhecido eu acho) no explorer
  --         -- neutral_orange = "#000000",
  --         -- faded_red = "#000000",
  --         -- faded_green = "#000000",
  --         -- faded_yellow = "#000000",
  --         -- faded_blue = "#000000",
  --         -- faded_purple = "#000000",
  --         -- faded_aqua = "#000000",
  --         -- faded_orange = "#000000",
  --         gray = "#5d7759", ---------- comentarios
  --       },
  --       contrast = "hard",
  --       transparent_mode = true,
  --       invert_tabline = true,
  --       overrides = {
  --         StorageClass = { fg = "#de8600" }, -- static
  --         Delimiter = { fg = "#de8600" }, -- brackets
  --         Include = { fg = "#de8600" }, -- includes
  --         Operator = { fg = "#de8600" }, -- operators
  --         -- Identifier = { fg = "#929292" }, -- struct components
  --         Identifier = { fg = "#928272" }, -- struct components
  --         String = { fg = "#7b5e47" }, -- strings
  --         -- Keyword = { fg = "#ab3fff" }, -- if, else, for ...
  --         Keyword = { fg = "#c073fc" }, -- if, else, for ...
  --         Comment = { fg = "#3a6030" }, -- comment
  --         GitSignsAdd = { fg = "#9090ff" }, -- git
  --         GitSignsAddLn = { fg = "#9090ff" }, -- git
  --         GitSignsAddPreview = { fg = "#9090ff" }, -- git
  --         GitSignsChange = { fg = "#cc9910" }, -- git
  --         GitSignsChangeLn = { fg = "#cc9910" }, -- git
  --         GitSignsDelete = { fg = "#aa4010" }, -- git
  --         GitSignsTopdelete = { fg = "#aa4010" }, -- git
  --         GitSignsDeletePreview = { fg = "#aa4010" }, -- git
  --         GitSignsDeleteVirtLn = { fg = "#aa4010" }, -- git
  --         DiffAdd = { fg = "#589967"}, -- diff
  --         DiffChange = { fg = "#999960" }, -- diff
  --         DiffDelete = { fg = "#333333", bg = "#505050" }, -- diff
  --         DiffText = { fg = "#999960" }, -- diff
  --         FloatShadow = { fg = "#ffffff" }, --
  --         FloatShadowThrough = { fg = "#ffffff" }, --
  --       }
  --     }
  --
  --     vim.cmd("colorscheme gruvbox")
  --
  --   end,
  -- },
  {
    "sainnhe/gruvbox-material",
    config = function()
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 1
      vim.g.gruvbox_material_foreground = "mix"
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
  -- {
  --   "sainnhe/everforest",
  --   config = function()
  --     vim.g.everforest_background = "hard"
  --     vim.g.everforest_better_performance = 1
  --     vim.g.everforest_dim_inactive_windows = 1
  --     vim.g.everforest_ui_contrast = "high"
  --     vim.g.everforest_diagnostic_virtual_text = "colored"
  --
  --     vim.cmd("colorscheme everforest")
  --     vim.cmd("highlight Normal guibg=#11130d")
  --   end,
  -- },
  -- {
  --   "lifepillar/vim-gruvbox8",
  --   branch = "neovim",
  --   config = function()
  --     if vim.g.neovide then
  --       vim.opt.linespace = 0
  --       vim.g.neovide_scale_factor = 0.7
  --       -- vim.g.neovide_transparency = 0.67
  --       -- vim.g.gruvbox_transp_bg = 1
  --     end
  --
  --     vim.cmd("colorscheme gruvbox8_soft")
  --     vim.cmd("highlight Normal guibg=#11130d")
  --
  --   end,
  -- },

  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("codeium").setup{}
      -- vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true })
      -- vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
      -- vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
      -- vim.keymap.set('i', '<c-x>', function() return vim.cmd['codeium.Clear']() end, { expr = true })
    end
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = true,
        theme = 'onedark',
        section_separators = '',
        component_separators = { left = '⧸', right = '⧹' },
      },
    },
  },

  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   main = "ibl",
  --   opts = {
  --     char = '│',
  --   },
  --   config = function()
  --     require("ibl").setup {}
  --   end,
  -- },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.

      -- undo tree with telescope
      "debugloop/telescope-undo.nvim", -- https://dandavison.github.io/delta/installation.html
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- {
  --   'sigmaSd/nim-nvim-basic',
  --   config = function()
  --     require("nim-nvim").setup()
  --   end,
  --   -- If you're using Lazy, you can lazy load this plugin on file type event == "nim"
  --   ft = "nim"
  -- }
}, {})

local Path = require('plenary.path')
require('session_manager').setup {
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'),               -- The directory where the session files will be saved.
  path_replacer = '__',                                                      -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++',                                                     -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true,                                              -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true,                                         -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_dirs = {},                                                 -- A list of directories where the session will not be autosaved.
  autosave_ignore_filetypes = {                                              -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_buftypes = {},    -- All buffers of these bufer types will be closed before the session is saved.
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80,             -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
}

-- [[ Highlight on yank ]] See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]] See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
    file_ignore_patterns = {
      "libs",
      "assets/textures",
      "assets/models",
    },
    layout_strategy = "vertical",
    layout_config = {
      height = 0.99,
      width = 0.99,
      prompt_position = "bottom",
      preview_height = 0.7,
    },
  },
  extensions = {
    undo = {
      use_delta = true,
      side_by_side = true,
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.8,
      },
    },
  }
}

-- TELESCOPE EXTENSIONS
pcall(require('telescope').load_extension, 'fzf')
require("telescope").load_extension("file_browser")
require("telescope").load_extension("undo")

vim.filetype.add { extension = { wgsl = "wgsl" } }

-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  modules = {},
  sync_install = false,
  ignore_install = {},
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'rust', 'vimdoc', 'vim', 'wgsl' },

  -- Autoinstall languages that are not installed. Defaults to false
  auto_install = true,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

--------------------------------------------------------------------------------------------------------------------------------------------------

vim.filetype.add{
  extension = {
    gltf = "json",
    gui_script = "lua", -- defold
    render_script = "lua", -- defold
  },
}

--------------------------------------------------------------------------------------------------------------------------------------------------

vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99 -- do not close folds when a buffer is opened

-- [[ Configure LSP ]] This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('<leader>i', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>I', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('<leader>bf', vim.lsp.buf.format, 'format file')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

-- Enable the following language servers
local runtime_library = vim.api.nvim_get_runtime_file("", true)
table.insert(runtime_library, "${3rd}/Defold/library")

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- rust_analyzer = {},
  -- gdscript = {},
  wgsl_analyzer = { -- https://github.com/wgsl-analyzer/wgsl-analyzer
    command = "wgsl_analyzer",
    filetypes = { "wgsl" },
  },
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = {
          "vim", "init", "on_message", "on_input", "gui", "vmath", "timer", "msg", "app", "hash",
          "sys", "http", "pprint", "launcher", "window", "socket", "sound", "html5", "defos",
          "update", "final", "websocket", "updater", "go", "appManager", "final", "webview", "rnd", "MD5",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = runtime_library,
      },
      telemetry = { enable = false },
    },
  },
}
-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]] See `:help cmp`
local cmp = require('cmp')
local luasnip = require('luasnip')
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  sources = {
    { name = 'nvim_lsp_signature_help' },
    { name = 'nvim_lsp' },
    { name = "codeium" },
    { name = 'luasnip' },
    { name = 'path' },
  },
  experimental = {
    ghost_text = true,
  },
}

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

--------------------------------------------------------------------------- terminal
local ui = require("toggleterm.lazy").require("toggleterm.ui")

-- open/close terminal
local function set_terminal(open)
  if (open and not ui.find_open_windows()) or (not open and ui.find_open_windows()) then
    vim.cmd("ToggleTerm")
  end
end

--------------------------------------------------------------------------- DAP
local dap = require('dap')
local dapui = require('dapui')
dapui.setup()

vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '➡', texthl = '', linehl = '', numhl = '' })

local function get_executable_path()
  local handle = io.popen('jq ".[0].output" compile_commands.json')
  if handle == nil then return end

  local result = tostring(handle:read("*a"))
  handle:close()

  result = result:gsub("\"", "")

  return result:gsub("\n", "")
end

dap.configurations.c = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = get_executable_path(),
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.cpp = dap.configurations.c

-- read launch.json from folder .vscode
require('dap.ext.vscode').load_launchjs(nil, { codelldb = { 'c', 'cpp' } })

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb', -- INSTALL WITH MASON
    args = { "--port", "${port}" },
  }
}

local function start_debug()
  if vim.api.nvim_get_mode().mode == 't' then set_terminal(false) end

  dap.continue()
  local started = type(dap.session()) == 'table'

  if not started then
    print('cannot debug an empty file!')
  end
end

dap.listeners.after.event_initialized["dapui_config"] = function()
  set_terminal(false)
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- TODO: move to its own file
local function run()
  vim.cmd('TermExec cmd="clear && ninja run"')
end

-- TODO: move to its own file
local function build(run_app)
  vim.cmd('TermExec cmd="clear && bear -- ninja build"')

  if run_app then run() end
end

--------------------------------------------------------------------------------------------------------------------------------------------------

local function set_opts(desc, silent)
  if silent == nil then silent = true end
  if desc == nil then desc = nil end

  return { desc = desc, silent = silent }
end

local telescope_bi = require('telescope.builtin')

vim.keymap.set('n', '<leader>?', telescope_bi.oldfiles, set_opts("[?] Find recently opened files"))
vim.keymap.set('n', '<leader><space>', telescope_bi.buffers, set_opts("[ ] Find existing buffers"))

-- vim.keymap.set('n', '<leader>/', function()
vim.keymap.set('n', '<leader>f', function()
  telescope_bi.current_buffer_fuzzy_find {
    layout_config = {
      height = 0.99,
      width = 0.99,
      prompt_position = "bottom",
      preview_height = 0.7,
    },
  }
end, set_opts("[/] Fuzzily search in current buffer]"))

vim.keymap.set('n', '<leader>gf', telescope_bi.git_files, set_opts("Search [G]it [F]iles"))
vim.keymap.set('n', '<leader>sf', telescope_bi.find_files, set_opts("[S]earch [F]iles"))
vim.keymap.set('n', '<leader>sh', telescope_bi.help_tags,  set_opts("[S]earch [H]elp"))
vim.keymap.set('n', '<leader>sw', telescope_bi.grep_string,set_opts("[S]earch current [W]ord"))
vim.keymap.set('n', '<leader>sg', telescope_bi.live_grep,  set_opts("[S]earch by [G]rep"))
vim.keymap.set('n', '<leader>sd', telescope_bi.diagnostics,set_opts("[S]earch [D]iagnostics"))

-- Debugger
vim.keymap.set({ 'n', 't' }, "<esc>", function() set_terminal(false) end, set_opts()) -- close terminal
vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, set_opts("Toggle breakpoint"))
vim.keymap.set("n", "<leader>1", dap.step_into, set_opts("Debug step into"))
vim.keymap.set("n", "<leader>2", dap.step_over, set_opts("Debug step over"))
vim.keymap.set("n", "<leader>3", dap.step_out, set_opts("Debug step out"))
vim.keymap.set("n", "<leader>4", dap.terminate, set_opts("Debug terminate"))
vim.keymap.set({ 'n', 't' }, "<leader>5", start_debug, set_opts("Debug start")) -- run debug

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- TODO: Move to a separate file
vim.keymap.set({ 'n', 't' }, "<leader>6", function() build(false) end, set_opts())  -- build
vim.keymap.set({ 'n', 't' }, "<leader>7", function() build(true) end, set_opts())   -- build and run
vim.keymap.set({ 'n', 't' }, "<leader>8", run, set_opts())                          -- run

vim.keymap.set('n', "<leader>9", dapui.eval, set_opts("Debug evaluate expression")) -- inspect values
-- vim.keymap.set("n", "<C-5>", dap.run_last, { silent = true })
vim.keymap.set("n", "<leader>0", dapui.toggle, set_opts("Debug toggle UI"))

-- put/remove tabs
-- vim.keymap.set("n", "<tab>", ":><CR>", { silent = true })
-- vim.keymap.set("n", "<S-tab>", ":<<CR>", { silent = true })
-- vim.keymap.set("v", "<tab>", ":><CR>gv<CR>k", { silent = true })
-- vim.keymap.set("v", "<S-tab>", ":<<CR>gv<CR>k", { silent = true })

vim.keymap.set("n", "<tab>", "==", set_opts("Format line"))
vim.keymap.set("v", "<tab>", "=", set_opts("Format block"))

-- replace words
vim.keymap.set("v", "<C-f>", ":s/old/new/g", set_opts("Replace block words"))
vim.keymap.set("n", "<leader>f", ":s/old/new/g", set_opts("Replace words"))
vim.keymap.set("n", "<leader>F", "*N:%s//new/gc", set_opts("Replace word under cursor"))

vim.keymap.set('n', 'gi', telescope_bi.lsp_references, set_opts("[/] [G]oto [I]mplementation"))

-- Clear highlights
vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", set_opts("Clear all highlights"))

-- open/close git diff
vim.opt.fillchars:append { diff = "╱" } -- diagonal line on diffs
vim.keymap.set("n", "<leader>od", ":DiffviewOpen<CR>", set_opts("Open diff view"))
vim.keymap.set("n", "<leader>oh", ":DiffviewFileHistory<CR>", set_opts("Open diff view history "))
vim.keymap.set("n", "<leader>cd", ":DiffviewClose<CR>", set_opts("Close diff view"))

-- move lines
vim.keymap.set("n", "<S-h>", "<Plug>GoNSMLeft", set_opts("Move line left"))
vim.keymap.set("n", "<S-j>", "<Plug>GoNSMDown", set_opts("Move line down"))
vim.keymap.set("n", "<S-k>", "<Plug>GoNSMUp", set_opts("Move line up"))
vim.keymap.set("n", "<S-l>", "<Plug>GoNSMRight", set_opts("Move line right"))
vim.keymap.set("v", "<S-h>", "<Plug>GoVSMLeft", set_opts("Move block left"))
vim.keymap.set("v", "<S-j>", "<Plug>GoVSMDown", set_opts("Move block down"))
vim.keymap.set("v", "<S-k>", "<Plug>GoVSMUp", set_opts("Move block up"))
vim.keymap.set("v", "<S-l>", "<Plug>GoVSMRight", set_opts("Move block right"))

-- duplicate lines
vim.keymap.set("n", "<leader>j", "<Plug>GoNSDDown", set_opts("Duplicate line down"))
vim.keymap.set("n", "<leader>k", "<Plug>GoNSDUp", set_opts("Duplicate line up"))
vim.keymap.set("v", "<leader>j", "<Plug>GoVSDDown", set_opts("Duplicate block down"))
vim.keymap.set("v", "<leader>k", "<Plug>GoVSDUp", set_opts("Duplicate block up"))

vim.keymap.set({ 'n', 't' }, '<leader>t', "<cmd>ToggleTerm<CR>", set_opts("Toggle terminal"))

-- Switch between header and source C files
vim.keymap.set("n", "<A-o>", function()
  local extension = vim.fn.expand("%:e")

  if extension == "c" then
    vim.cmd(":e %<.h")
  elseif extension == "h" then
    vim.cmd(":e %<.c")
  end
end, set_opts("Switch between header and source C files"))

vim.keymap.set("n", "<C-s>", ':w<CR>', set_opts("Save current buffer", true)) -- save
vim.keymap.set("n", "<C-i>", '<C-I>', set_opts())                             -- go forward on jumplist

-- buffers
vim.keymap.set("n", "<c-tab>", function() vim.cmd("bn") end, set_opts("Next buffer", true))
vim.keymap.set("n", "<c-s-tab>", function() vim.cmd("bp") end, set_opts("Previous buffer"))
vim.keymap.set("n", "<C-q>", ":bn<CR>:bd #<CR>", set_opts("Close current buffer")) -- close buffer

-- better windows navegation
vim.keymap.set('n', "<C-h>", "<C-w>h", set_opts("Move left window"))
vim.keymap.set('n', "<C-j>", "<C-w>j", set_opts("Move down window"))
vim.keymap.set('n', "<C-k>", "<C-w>k", set_opts("Move up window"))
vim.keymap.set('n', "<C-l>", "<C-w>l", set_opts("Move right window"))

vim.keymap.set({ "n", "v" }, "<C-z>", "") -- disable ctrl z
vim.keymap.set("n", "<C-b>", ":Telescope file_browser<CR>", set_opts("File browser")) -- File browser

vim.keymap.set("v", "<leader>d", [[c"<C-r>""<Esc>]], set_opts("Wrap selected word with double quotes")) -- wrap with double quotes
vim.keymap.set("v", "<leader>q", [[c'<C-r>"'<Esc>]], set_opts("Wrap selected word with single quotes")) -- wrap with single quotes

vim.keymap.set("n", "ç", "^", set_opts("Go to the first word on current line")) -- go to the first word on the line

-- yank to OS clipboard
vim.keymap.set("n", "<C-S-c>", '"+yy')
vim.keymap.set("v", "<C-S-c>", '"+y')
vim.keymap.set("v", "p", '"_dP', set_opts())

vim.keymap.set("v", "y", 'ygv', set_opts())        -- stay on visual mode after yank
vim.keymap.set("i", "<A-p>", "<C-o>p", set_opts()) -- dont leave insert mode after yank

-- ignore case on quit
vim.keymap.set("c", "Q", "q")
vim.keymap.set("c", "QA", "qa")
vim.keymap.set("c", "Qa", "qa")

vim.keymap.set("c", "W", "w")
vim.keymap.set("c", "WA", "wa")
vim.keymap.set("c", "Wa", "wa")

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("i", "<C-s>", "<Esc>:w<CR>", set_opts("Save on insert mode")) -- save on insert mode

local hide_bottom_bar = false

local function hide_bar()
  hide_bottom_bar = not hide_bottom_bar

  if hide_bottom_bar then
    vim.cmd("set laststatus=0")
    vim.cmd("set cmdheight=0")
    vim.cmd("set noshowmode")
    vim.cmd("set noruler")
    vim.cmd("set noshowcmd")
  else
    vim.cmd("set laststatus=2")
    vim.cmd("set cmdheight=1")
    vim.cmd("set showmode")
    vim.cmd("set ruler")
    vim.cmd("set showcmd")
  end
end

hide_bar()

vim.keymap.set('n', '<leader>bh', hide_bar, set_opts("Toggle bottom bars"))

-- The line beneath this is called `modeline`. See `:help modeline`, set the tabsize in this file
-- vim: ts=2 sts=2 sw=2 et
