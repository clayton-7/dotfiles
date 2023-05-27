-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable highlight groups
vim.opt.termguicolors = true
vim.o.termguicolors = true

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim' -- Package manager

  -- LSP Configuration & Plugins
  use { 'neovim/nvim-lspconfig',
    requires = { -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'j-hui/fidget.nvim', -- Useful status updates for LSP
      'folke/neodev.nvim', -- Additional lua configuration, makes nvim stuff amazing
    },
  }

  use { 'hrsh7th/nvim-cmp', requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' }} -- Autocomplete
  use { 'nvim-treesitter/nvim-treesitter', run = function() pcall(require('nvim-treesitter.install').update{ with_sync = true }) end } -- Highlight, edit, and navigate code
  use { 'nvim-treesitter/nvim-treesitter-textobjects', after = 'nvim-treesitter' } -- Additional text objects via treesitter
  use { 'nvim-treesitter/nvim-treesitter-context' } -- show the function that you are in on top on the code
  use { 'akinsho/toggleterm.nvim', tag = '*', config = function() require("toggleterm").setup() end } -- terminal

  use 'cljoly/telescope-repo.nvim'
  use 'echasnovski/mini.pairs' -- autopairs
  use "nvim-tree/nvim-web-devicons"
  use "tikhomirov/vim-glsl" -- glsl syntax highlight

  -- debugger
  use 'mfussenegger/nvim-dap'
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'
  use 'sindrets/diffview.nvim' -- see files diff
  use "nvim-telescope/telescope-project.nvim"

  use "ellisonleao/gruvbox.nvim" -- Theme
  use "nvim-treesitter/playground" -- Theme

  use "RRethy/vim-illuminate" -- destacar variavel que o cursor esta em cima
  use 'lewis6991/impatient.nvim' -- iniciar mais rapido os modulos
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- comments
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } } -- Fuzzy Finder (files, lsp, etc)

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  use 'booperlv/nvim-gomove' -- move lines
  use 'rcarriga/nvim-notify' -- popup notifier
  use 'Shatur/neovim-session-manager' -- session manager
  use { "mcauley-penney/tidy.nvim", config = function() require("tidy").setup() end } -- trim spaces

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')

  if has_plugins then plugins(use) end
  if is_bootstrap then require('packer').sync() end
end)

require("notify").setup{
  background_colour = "#aaffaa",
  fps = 60,
  stages = "slide"
}

vim.notify = require("notify")
pcall(require('impatient'))

local Path = require('plenary.path')
require('session_manager').setup{
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  path_replacer = '__', -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
    'gitrebase',
  },
  autosave_ignore_buftypes = {}, -- All buffers of these bufer types will be closed before the session is saved.
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80,  -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
}

require("nvim-treesitter.configs").setup{
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

-- reiniciar para as att funcionarem.
if is_bootstrap then print 'restart nvim' return end

require('mini.pairs').setup()

require('treesitter-context').setup{
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
  zindex = 20, -- The Z-index of the context window
}

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })

vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- Setting options `:help vim.o`
vim.o.hlsearch = true     -- Set highlight on search
vim.wo.number = true      -- Make line numbers default
vim.o.mouse = 'a'         -- Enable mouse mode
vim.o.breakindent = true  -- Enable break indent
vim.o.undofile = true     -- Save undo history

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 200
vim.wo.signcolumn = 'yes'

---------------------------------------------------------------------------
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Basic Keymaps Set <space> as the leader key`:help mapleader` NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- move lines
require("gomove").setup{
  map_defaults = false, -- whether or not to map default key bindings, (true/false)
  reindent = true, -- whether or not to reindent lines moved vertically (true/false)
  undojoin = true, -- whether or not to undojoin same direction moves (true/false)
  move_past_end_col = false, -- whether to not to move past end column when moving blocks horizontally, (true/false)
}

-- stand out current line
vim.opt.cursorline = true
vim.opt.smartindent = true

vim.opt.so = 9999 -- cursor always on center

-- relative numbers
vim.cmd("set rnu")
-- vim.cmd("vs") -- start with vertical layout split

-- trim spaces
require("tidy").setup{ filetype_exclude = { "markdown", "diff" } }

--------------------------------------------------------------------------- theme
require("gruvbox").setup{
  palette_overrides = {
    -- dark0_hard = "#000000",
    dark0 = "#252525", ---------- background
    -- dark0_soft = "#000000",
    dark1 = "#303030", ---------- barra lateral esquerda onde fica os breakpoints e infos sobre a linha
    dark2 = "#555555", ---------- barra de indentacao
    dark3 = "#3f3f3f", ---------- selecao de linhas
    dark4 = "#777777", ---------- numeracao da linha
    -- light0_hard = "#000000",
    -- light0 = "#000000",
    -- light0_soft = "#000000",
    light1 = "#bfbfbf", --------- palavras principais(nome de variaveis criadas)
    light2 = "#dddddd", --------- cor padrao de icone sem cor especifica
    -- light3 = "#000000",
    light4 = "#aa9989", --------- letras marcadas para chamar atencao nos menus
    -- bright_red = "#ab3fff", ----- palavras reservadas da linguagem(keywords)
    bright_green = "#b4ad4a", --- funcoes
    bright_yellow = "#60b34e", -- Tipos de variaveis(int, float...)
    bright_blue = "#909090", ---- nome de parametro de func e parametro de struct
    bright_purple = "#b8b773", -- numeros e constantes
    bright_aqua = "#b8b773",----- include e defines
    bright_orange = "#33aa33", -- pontuacao
    neutral_red = "#ff1111", ---- erro no terminal
    neutral_green = "#aa5555", -- nome de arquivo .sh no explorer
    neutral_yellow = "#ff0000",-- arquivos com erro mp explorer
    neutral_blue = "#bfbfbf", --- cor da pasta no explorer
    neutral_purple = "#cccccc",-- pasta root do explorer
    neutral_aqua = "#aa5555", --- nome de arquivo (desconhecido eu acho) no explorer
    -- neutral_orange = "#000000",
    -- faded_red = "#000000",
    -- faded_green = "#000000",
    -- faded_yellow = "#000000",
    -- faded_blue = "#000000",
    -- faded_purple = "#000000",
    -- faded_aqua = "#000000",
    -- faded_orange = "#000000",
    gray = "#5d7759", ---------- comentarios
  },
  contrast = "soft",
  transparent_mode = true,
  invert_tabline = true,
  overrides = {
    StorageClass = { fg = "#de8600" }, -- static
    Delimiter = { fg = "#de8600" }, -- brackets
    Include = { fg = "#de8600" }, -- includes
    Operator = { fg = "#de8600" }, -- operators
    Identifier = { fg = "#929292" }, -- struct components
    String = { fg = "#7b5e47" }, -- strings
    Keyword = { fg = "#ab3fff" }, -- if, else, for ...
    Comment = { fg = "#3a6030" }, -- comment
    GitSignsAdd = { fg = "#9090ff" }, -- git
    GitSignsAddLn = { fg = "#9090ff" }, -- git
    GitSignsAddPreview = { fg = "#9090ff" }, -- git
    GitSignsChange = { fg = "#cc9910" }, -- git
    GitSignsChangeLn = { fg = "#cc9910" }, -- git
    GitSignsDelete = { fg = "#aa4010" }, -- git
    GitSignsTopdelete = { fg = "#aa4010" }, -- git
    GitSignsDeletePreview = { fg = "#aa4010" }, -- git
    GitSignsDeleteVirtLn = { fg = "#aa4010" }, -- git
    DiffAdd = { fg = "#589967"}, -- diff
    DiffChange = { fg = "#999960" }, -- diff
    DiffDelete = { fg = "#333333", bg = "#505050" }, -- diff
    DiffText = { fg = "#999960" }, -- diff
  }
}

vim.cmd("colorscheme gruvbox")
-- vim.opt.guifont = { "JetBrains Mono:h13" }
vim.opt.guifont = { "JetBrains Mono" } -- font

--------------------------------------------------------------------------- terminal

local lazy = require("toggleterm.lazy")
local ui = lazy.require("toggleterm.ui")

-- open/close terminal
local function set_terminal(open)
  if (open and not ui.find_open_windows()) or (not open and ui.find_open_windows()) then
    vim.cmd("ToggleTerm")
  end
end

--------------------------------------------------------------------------- comments
require('Comment').setup{ ignore = '^$' }

--------------------------------------------------------------------------- windows

--------------------------------------------------------------------------- buffers
local function change_buffer(next)
  if next then
    vim.cmd("bn")
  else
    vim.cmd("bp")
  end

  local buffer_name = vim.fn.expand('%'):reverse()
  local buffer_tmp = ""

  for i = 1, #buffer_name do
    local char = buffer_name:sub(i, i)

    if char == "/" or char == "\\" then
      buffer_name = buffer_tmp:reverse()
      break
    end

    buffer_tmp = buffer_tmp .. char
  end

  vim.notify(buffer_name, vim.log.levels.INFO, {
    title = "Buffer atual",
    timeout = 500,
    render = "compact",
    hide_from_history = true,
  })
end

--------------------------------------------------------------------------- highlight
local illuminate = require('illuminate')

illuminate.configure{
  providers = { 'lsp', 'treesitter' },
  delay = 0,
  under_cursor = true,
  min_count_to_highlight = 1,
}

-- Highlight on yank `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = vim.highlight.on_yank,
  group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
  pattern = '*',
})

-- reading Defold scripts as lua
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.gui_script", "*.script" },
  callback = function()
    vim.opt.filetype = "lua"
  end,
  desc = "Reading Defold scripts as lua"
})

--------------------------------------------------------------------------- DAP
local dap = require('dap')
local dapui = require('dapui')
local current_os = vim.loop.os_uname().sysname

dapui.setup()

vim.fn.sign_define('DapBreakpoint', { text='🔴', texthl='', linehl='', numhl='' })
vim.fn.sign_define('DapStopped', { text='➡', texthl='', linehl='', numhl='' })

-- read launch.json from folder .vscode
require('dap.ext.vscode').load_launchjs(nil, { codelldb = {'c', 'cpp'} })

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = os.getenv("HOME") .. '/.config/nvim/codelldb/extension/adapter/codelldb', -- download from here: https://github.com/vadimcn/codelldb/releases
    args = {"--port", "${port}"},
  }
}

if current_os == "Windows" then
  dap.adapters.codelldb.executable.detached = true
  dap.adapters.codelldb.executable.command = '%userprofile%\\codelldb\\extension\\adapter\\codelldb.exe' -- download from here: https://github.com/vadimcn/codelldb/releases
end

---- read launch.json from folder .vscode
-- require('dap.ext.vscode').load_launchjs(nil, { cppdbg = {'c', 'cpp'} })
-- if current_os == 'Linux' then
--   dap.adapters.cppdbg = {
--     id = 'cppdbg',
--     type = 'executable',
--     command = os.getenv("HOME") .. '/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
--   }
-- elseif current_os == 'Windows' then
--   dap.adapters.cppdbg = {
--     id = 'cppdbg',
--     type = 'executable',
--     -- TODO: VERSAO PARA WINDOWS
--     command = '%userprofile%\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
--     options = { detached = false }
--   }
-- end

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

local function run()
  vim.cmd('TermExec cmd="clear && ninja run"')
end

local function build(run_app)
  vim.cmd('TermExec cmd="clear && bear -- ninja compile_shaders compile"')

  if run_app then run() end
end

---------------------------------------------------------------------------
-- Set lualine as statusline `:help lualine.txt`
require('lualine').setup{
  options = {
    icons_enabled = true,
    theme = 'gruvbox',
    component_separators = { left = '⧸', right = '⧹' },
  },
}

-- Enable `lukas-reineke/indent-blankline.nvim `:help indent_blankline.txt`
require('indent_blankline').setup{
  show_end_of_line = true,
  char = '│', -- barra indentacao
  space_char_blankline = " ",
  show_trailing_blankline_indent = false,
}

-- Gitsigns `:help gitsigns.txt`
require('gitsigns').setup{
  signs = {
    add          = { text = '▌' }, -- https://www.fileformat.info/info/charset/UTF-32/list.htm?start=8192
    change       = { text = '▎' },
    delete       = { text = '▄' },
    topdelete    = { text = '▔' },
    changedelete = { text = '▏' },
    untracked    = { text = '┆' },
  },
  current_line_blame = true,
}

-- Show imgs in telescope, install catimg to work
local function img_viewer(filepath, bufnr, opts)
  local is_image = function(_filepath)
    local split_path = vim.split(_filepath:lower(), '.', { plain = true })

    return vim.tbl_contains({ 'png', 'jpg' }, split_path[#split_path])
  end

  if is_image(filepath) then
    local term = vim.api.nvim_open_term(bufnr, {})

    local function send_output(_, data)
      for _, d in ipairs(data) do
        vim.api.nvim_chan_send(term, d..'\r\n')
      end
    end

    vim.fn.jobstart(
      { 'catimg', filepath },  -- Terminal image viewer command
      { on_stdout = send_output, stdout_buffered = true, pty = true }
    )
  else
    require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
  end
end

local telescope = require("telescope")

-- Configure Telescope `:help telescope` and `:help telescope.setup()`
telescope.setup{
  defaults = {
    file_ignore_patterns = {
      "libs",
      "assets/textures",
      "assets/models",
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      }
    },
    preview = {
      mime_hook = img_viewer,
    },
  },
}

telescope.load_extension("fzf") -- fuzzy finder native
telescope.load_extension("project") -- projects

local function change_project()
  vim.cmd("clearjumps")
  vim.cmd("%bd")
  telescope.extensions.project.project()
end

local telescope_bi = require('telescope.builtin')

-- Configure Treesitter `:help nvim-treesitter`
require('nvim-treesitter.configs').setup{
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'lua', 'vim', 'vimdoc' },
  auto_install = false,
  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
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

-- LSP settings. This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  vim.keymap.set("n", 'gr', telescope.lsp_references, { buffer = bufnr })
end

-- Setup neovim lua configuration
require('neodev').setup{ library = { plugins = { "nvim-dap-ui" }, types = true } }

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('mason').setup() -- Setup mason so it can manage external tooling

local mason_lspconfig = require("mason-lspconfig") -- Ensure the servers above are installed

local servers = {
  -- clangd = {},
  -- gopls = {},
  -- rust_analyzer = {},

  lua_ls = {
    Lua = {
      diagnostics = {
        globals = {
          'vim',
          "nvim_command_output",
        },
      },
      workspace = {
        checkThirdParty = false,
        libray = { "${3rd}/Defold/library" },
      },
      telemetry = { enable = false },
    },
  },
}

mason_lspconfig.setup_handlers{
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

require('lspconfig').glslls.setup{} -- glsl lsp, https://github.com/svenstaro/glsl-language-server

require('fidget').setup() -- Turn on lsp status information

-- nvim-cmp setup
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup{
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert{
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}


-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Clear highlights
vim.keymap.set("n", "<leader>H", ":nohlsearch<CR>", { silent = true })

-- better paste
vim.keymap.set("v", "p", '"_dP', { silent = true })
vim.keymap.set('n', '<leader>p', 'i<C-R>+')
vim.keymap.set({ "n", "v" }, "<C-S-c>", '"+yy')

-- ctrl-s to save
vim.keymap.set("n", "<C-s>", ':w<CR>', { silent = true })

-- go forward on jumplist
vim.keymap.set("n", "<C-i>", '<C-I>', { silent = true })

-- put/remove tabs
vim.keymap.set("n", "<tab>", ":><CR>", { silent = true })
vim.keymap.set("n", "<S-tab>", ":<<CR>", { silent = true })
vim.keymap.set("v", "<tab>", ":><CR>gv<CR>k", { silent = true })
vim.keymap.set("v", "<S-tab>", ":<<CR>gv<CR>k", { silent = true })

-- replace words
vim.keymap.set("n", "<C-f>", "*N:%s//new/c")
vim.keymap.set("v", "<C-f>", ":s/old/new/")

-- open/close git diff
vim.opt.fillchars:append { diff = "╱" } -- diagonal line on diffs
vim.keymap.set("n", "<leader>od", ":DiffviewOpen<CR>", { silent = true })
vim.keymap.set("n", "<leader>oh", ":DiffviewFileHistory<CR>", { silent = true })
vim.keymap.set("n", "<leader>cd", ":DiffviewClose<CR>", { silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set("n", '<leader>rn', vim.lsp.buf.rename)
vim.keymap.set("n", '<leader>ca', vim.lsp.buf.code_action)
vim.keymap.set("n", 'gd', vim.lsp.buf.definition)
vim.keymap.set("n", 'gD', vim.lsp.buf.declaration)
vim.keymap.set("n", 'gI', vim.lsp.buf.implementation)
vim.keymap.set("n", '<leader>de', vim.lsp.buf.type_definition)

vim.keymap.set("n", '<leader>i', vim.lsp.buf.hover)
vim.keymap.set("n", '<leader>I', vim.lsp.buf.signature_help)
vim.keymap.set("n", '<leader>bf', vim.lsp.buf.format)

vim.keymap.set("n", "ç", "^", { silent = true })

-- move lines
vim.keymap.set("n", "<S-h>", "<Plug>GoNSMLeft", { silent = true })
vim.keymap.set("n", "<S-j>", "<Plug>GoNSMDown", { silent = true })
vim.keymap.set("n", "<S-k>", "<Plug>GoNSMUp", { silent = true })
vim.keymap.set("n", "<S-l>", "<Plug>GoNSMRight", { silent = true })
vim.keymap.set("x", "<S-h>", "<Plug>GoVSMLeft", { silent = true })
vim.keymap.set("x", "<S-j>", "<Plug>GoVSMDown", { silent = true })
vim.keymap.set("x", "<S-k>", "<Plug>GoVSMUp", { silent = true })
vim.keymap.set("x", "<S-l>", "<Plug>GoVSMRight", { silent = true })

-- duplicate lines
vim.keymap.set("n", "<leader>h", "<Plug>GoNSDLeft", { silent = true })
vim.keymap.set("n", "<leader>j", "<Plug>GoNSDDown", { silent = true })
vim.keymap.set("n", "<leader>k", "<Plug>GoNSDUp", { silent = true })
vim.keymap.set("n", "<leader>l", "<Plug>GoNSDRight", { silent = true })
vim.keymap.set("x", "<leader>h", "<Plug>GoVSDLeft", { silent = true })
vim.keymap.set("x", "<leader>j", "<Plug>GoVSDDown", { silent = true })
vim.keymap.set("x", "<leader>k", "<Plug>GoVSDUp", { silent = true })
vim.keymap.set("x", "<leader>l", "<Plug>GoVSDRight", { silent = true })

vim.keymap.set({'n', 't'}, '<leader>t', "<cmd>ToggleTerm<CR>", { silent = true })
vim.keymap.set({'n', 't'}, '<leader>t', "<cmd>ToggleTerm<CR>", { silent = true })

vim.keymap.set("i", "<C-c>", require('Comment.api').toggle.linewise.current, { silent = true })
-- `gcc` - Toggles the current line using linewise comment
-- `gbc` - Toggles the current line using blockwise comment
-- `gc` - Toggles the region using linewise comment
-- `gb` - Toggles the region using blockwise comment

-- better windows navegation
vim.keymap.set('n', "<C-h>", "<C-w>h", { silent = true })
vim.keymap.set('n', "<C-j>", "<C-w>j", { silent = true })
vim.keymap.set('n', "<C-k>", "<C-w>k", { silent = true })
vim.keymap.set('n', "<C-l>", "<C-w>l", { silent = true })

vim.keymap.set("n", "<c-tab>", function() change_buffer(true) end)
vim.keymap.set("n", "<c-s-tab>", function() change_buffer(false) end)
vim.keymap.set("n", "[b", function() change_buffer(true) end)
vim.keymap.set("n", "]b", function() change_buffer(false) end)

vim.keymap.set("n", "<C-q>", ":bn<CR>:bd #<CR>", { silent = true })

-- Switch between header and source files
vim.keymap.set("n", "<A-o>", function()
  local extension = vim.fn.expand("%:e")

  if extension == "c" then
    vim.cmd(":e %<.h")
  elseif extension == "h" then
    vim.cmd(":e %<.c")
  end
end, { silent = true })

-- vim.keymap.set({'n', 'v', 'i', 'x'}, "<leader>g", illuminate.goto_prev_reference, { silent = true })
-- vim.keymap.set({'n', 'v', 'i', 'x'}, "<leader>j", illuminate.goto_next_reference, { silent = true })
-- vim.keymap.set({'n', 'v', 'i', 'x'}, "<leader>dd", illuminate.textobj_select, { silent = true })

vim.keymap.set({'n', 't'}, "<esc>", function() set_terminal(false) end, { silent = true })    -- close terminal
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { silent = true })
vim.keymap.set("n", "<leader>1", dap.step_into, { silent = true })
vim.keymap.set("n", "<leader>2", dap.step_over, { silent = true })
vim.keymap.set("n", "<leader>3", dap.step_out, { silent = true })
vim.keymap.set("n", "<leader>4", dap.terminate, { silent = true })
vim.keymap.set({'n', 't'}, "<leader>5", start_debug, { silent = true })                       -- run debug
vim.keymap.set({'n', 't'}, "<leader>6", function() build(false) end, { silent = true })       -- build
vim.keymap.set({'n', 't'}, "<leader>7", function() build(true) end, { silent = true })        -- build and run
vim.keymap.set({'n', 't'}, "<leader>8", run, { silent = true })                               -- run
vim.keymap.set('n', "<leader>9", dapui.eval, { silent = true })                               -- inspect values
-- vim.keymap.set("n", "<C-5>", dap.run_last, { silent = true })
vim.keymap.set("n", "<leader>0", dapui.toggle, { silent = true })

vim.keymap.set('n', '<leader>op', change_project, { desc = '[O]pen [P]rojects' })


-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', telescope_bi.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', telescope_bi.buffers, { desc = '[space] Find existing buffers' })
vim.keymap.set('n', '<leader>f', function()
  telescope_bi.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown{
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', 'gi', telescope_bi.lsp_references, { desc = '[/] [G]oto [I]mplementation' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', telescope_bi.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', telescope_bi.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_bi.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_bi.live_grep, { desc = '[S]earch by [G]rep' }) -- install rg(ripgrep) and fzf to work correctly
vim.keymap.set('n', '<leader>sd', telescope_bi.diagnostics, { desc = '[S]earch [D]iagnostics' })
