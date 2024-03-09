vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.showmode = false
vim.opt.so = 9999 -- cursor always on center

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = '->', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!

-- enable highlight groups
vim.opt.termguicolors = true

vim.opt.smartindent = true
-- vim.o.cursorline = true -- highlight current line
vim.cmd("set rnu")
vim.cmd("set guicursor=n-v-c-i:block")

-- key `o` does not create new comment
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    callback = function() vim.cmd("set formatoptions-=o") end
})

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
        lazy = true,
        config = function() require("toggleterm").setup() end
    },

    -- debugger
    { 'mfussenegger/nvim-dap' },
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        requires = { "mfussenegger/nvim-dap" }
    },

    -- highlight current word
    {
        "RRethy/vim-illuminate",
        event = "BufEnter",
        lazy = true,
        config = function()
            if vim.bo.filetype == "lua" then return end

            vim.cmd("highlight illuminatedWordText  guifg=#ffffff guibg=none gui=underline,bold")
            vim.cmd("highlight illuminatedWordRead  guifg=#ffffff guibg=none gui=underline,bold")
            vim.cmd("highlight illuminatedWordWrite guifg=#ffffff guibg=none gui=underline,bold")
        end
    },
    { 'booperlv/nvim-gomove' },                    -- move lines

    { -- session manager
        "Shatur/neovim-session-manager",
        priority = 1000,
        config = function()
            require('session_manager').setup {
                sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
                path_replacer = '__', -- The character to which the path separator will be replaced for session files.
                colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.

                -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
                autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
                autosave_last_session = true, -- Automatically save last session on exit and on session switch.

                -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
                autosave_ignore_not_normal = true,
                autosave_ignore_dirs = {}, -- A list of directories where the session will not be autosaved.
                autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
                    'gitcommit',
                    'gitrebase',
                },
                autosave_ignore_buftypes = {},    -- All buffers of these bufer types will be closed before the session is saved.
                autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
                max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
            }
        end,
    },
    { 'nvim-treesitter/nvim-treesitter-context' }, -- show the function that you are in on top on the code
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    },
    {
        "cappyzawa/trim.nvim",
        config = function()
            require("trim").setup{}
        end
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        config = function()
            require('telescope').load_extension('dap')
        end
    },

    { 'nvim-tree/nvim-web-devicons', opts = {}, lazy = true },

    -- change closures, press: cs"' to change this line from "" to ''
    -- { "tpope/vim-surround" },

    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            require("leap").create_default_mappings(true)
        end
    },

    -- Git related plugins
    { 'tpope/vim-fugitive' },
    { 'tpope/vim-rhubarb' },
    { 'sindrets/diffview.nvim' }, -- see files diff

    -- NOTE: This is where your plugins related to LSP can be installed. The configuration is done below. Search for lspconfig to find it below.
    { -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        priority = 1000,
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

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
        -- undo
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
        },
    },

    { -- Useful plugin to show you pending keybinds.
        'folke/which-key.nvim',
        event = 'VimEnter', -- Sets the loading event to 'VimEnter'
        config = function() -- This is the function that runs, AFTER loading
            require('which-key').setup()

            -- Document existing key chains
            require('which-key').register {
                ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
                ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
                ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
                ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
                ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            }
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp_signature").setup{
                hint_prefix = " "
            }
        end

    },

    { -- Adds git related signs to the gutter, as well as utilities for managing changes
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
                vim.keymap.set('n', '<leader>gp', require('gitsigns').prev_hunk,
                    { buffer = bufnr, desc = '[G]o to [P]revious Hunk' })
                vim.keymap.set('n', '<leader>gn', require('gitsigns').next_hunk,
                    { buffer = bufnr, desc = '[G]o to [N]ext Hunk' })
                vim.keymap.set('n', '<leader>ph', require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = '[P]review [H]unk' })
            end,
        },
    },
    { -- wildmenu autocompletion
        'gelguy/wilder.nvim',
        dependencies = {
            "romgrk/fzy-lua-native"
        },
        config = function()
            local wilder = require('wilder')
            wilder.setup({modes = {':', '/', '?'}})
        end,
    },

    -- require("themes").gruvbox_material,
    -- require("themes").onedark,
    -- require("themes").catppuccin,
    -- require("themes").gruvbox_baby,
    require("themes").bamboo,

    {
        "Exafunction/codeium.nvim",
        -- "Exafunction/codeium.vim",
        event = 'BufEnter',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function ()
            vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
            require("codeium").setup{}
        end,
    },

    {
        "Exafunction/codeium.vim",
        event = 'BufEnter',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
        },
        config = function ()
            vim.keymap.set('i', '<C-g>', function() return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
            vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
        end,
    },
    {
        -- Set lualine as statusline See `:help lualine.txt`
        'nvim-lualine/lualine.nvim',
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
    {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
            require('Comment.ft').set('wgsl', {'//%s', '/*%s*/'})
        end,
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system requirements installed.

            -- undo tree with telescope
            "debugloop/telescope-undo.nvim", -- https://dandavison.github.io/delta/installation.html
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
                cond = function() return vim.fn.executable('make') == 1 end,
            },
            { 'nvim-tree/nvim-web-devicons' }
        },
    },

    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
        build = ':TSUpdate',
    },
    {
        -- set tab space for different languages
        "FotiadisM/tabset.nvim",
        priority = 1000,
        config = function()
            require("tabset").setup {
                defaults = {
                    tabwidth = 4,
                    expandtab = true
                },
                languages = {
                    nim = {
                        tabwidth = 2,
                        expandtab = true
                    },
                    hare = {
                        tabwidth = 8,
                        expandtab = true
                    },
                    {
                        filetypes = { "go","python", "gdscript" },
                        config = {
                            tabwidth = 4,
                            expandtab = false
                        }
                    }
                }
            }
        end
    },
    {
        "brenton-leighton/multiple-cursors.nvim",
        opts = {},
        version = "*",
        keys = {
            -- {"<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i"}},
            -- {"<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i"}},
            {"<C-S-j>", "<Cmd>MultipleCursorsAddDown<CR>", mode = {"n", "i"}},
            {"<C-S-k>", "<Cmd>MultipleCursorsAddUp<CR>", mode = {"n", "i"}},
            -- {"<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>", mode = {"n", "i"}},
            {"<leader>d", "<Cmd>MultipleCursorsAddToWordUnderCursor<CR>", mode = {"n", "v"}},
        },
    },
    {
        "mg979/vim-visual-multi",
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = { signs = false }
    },
    {
        "sourcegraph/sg.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },

    -- { -- init screen
    --     "goolord/alpha-nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     config = function ()
    --         -- require("alpha").setup(require("alpha.themes.startify").config)
    --         require'alpha'.setup(require'alpha.themes.dashboard'.config)
    --     end
    -- },
    -- { -- nim treesitter
    --     "alaviss/nim.nvim"
    -- },
}, {})

-- [[ Highlight on yank ]] See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })

local _border = "rounded"

-- Rounded border for hover and signature
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = _border })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = _border })
vim.diagnostic.config{ float = { border = _border } }

vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function() vim.highlight.on_yank() end,
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
        file_ignore_patterns = {},
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
    ignore_install = { "nim" },
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

vim.filetype.add {
    extension = {
        gltf = "json",
        gui_script = "lua",    -- defold
        render_script = "lua", -- defold
        v = "v", -- v lang
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

    require("lsp_signature").on_attach({
        bind = true,
        hint_enable = false,
        -- handler_opts = {
        --     border = "rounded"
        -- },
    }, bufnr)

end

require("sg").setup {
    -- Pass your own custom attach function
    --    If you do not pass your own attach function, then the following maps are provide:
    --        - gd -> goto definition
    --        - gr -> goto references
    on_attach = on_attach,
}

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
                -- library = {
                --     "${3rd}/Defold/library"
                --     unpack(vim.api.nvim_get_runtime_file('', true)),
                -- }
                library = {
                    "${3rd}/Defold/library",
                    vim.env.VIMRUNTIME,
                },
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

---@diagnostic disable-next-line: missing-fields
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<CR>'] = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
        ['<C-y>'] = cmp.mapping.confirm { select = true }, -- confirm without replace

        -- move to the next snippet
        ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
        end, { 'i', 's' }),

        -- move to the previous snippet
        ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
        end, { 'i', 's' }),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = {
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
    -- TODO: check if file exists!
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
vim.keymap.set('n', '<leader>sh', telescope_bi.help_tags, set_opts("[S]earch [H]elp"))
vim.keymap.set('n', '<leader>sw', telescope_bi.grep_string, set_opts("[S]earch current [W]ord"))
vim.keymap.set('n', '<leader>sg', telescope_bi.live_grep, set_opts("[S]earch by [G]rep"))
vim.keymap.set('n', '<leader>sd', telescope_bi.diagnostics, set_opts("[S]earch [D]iagnostics"))

-- Debugger
vim.keymap.set({ 'n', 't' }, "<esc>", function() set_terminal(false) end, set_opts()) -- close terminal
vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, set_opts("Toggle breakpoint"))
vim.keymap.set("n", "<leader>1", dap.step_into, set_opts("Debug step into"))
vim.keymap.set("n", "<leader>2", dap.step_over, set_opts("Debug step over"))
vim.keymap.set("n", "<leader>3", dap.step_out, set_opts("Debug step out"))
vim.keymap.set("n", "<leader>4", dap.terminate, set_opts("Debug terminate"))

-- TODO: move to its own file
vim.keymap.set({ 'n', 't' }, "<leader>5", function()
    if vim.bo.filetype == "c" then
        start_debug()

    elseif vim.bo.filetype == "zig" then
        set_terminal(true)
        vim.cmd('TermExec cmd="clear && zig build run"')

    elseif vim.bo.filetype == "rust" then
        set_terminal(true)
        vim.cmd('TermExec cmd="clear && cargo run"')

    elseif vim.bo.filetype == "nim" then
        set_terminal(true)
        vim.cmd('TermExec cmd="clear && nim --verbosity:0 r src/main.nim"') -- using nim because it's faster then nimble
        -- vim.cmd('TermExec cmd="clear && nimble --verbosity:0 run"')
        -- vim.cmd('TermExec cmd="clear && nimble run"')
    end

end, set_opts("Debug start")) -- run debug

vim.keymap.set({ 'n', 't' }, "<leader>6", function()
    if vim.bo.filetype == "c" then
        build(false)

    elseif vim.bo.filetype == "zig" then
        vim.cmd('TermExec cmd="clear && zig build run"')
        set_terminal(false)

    elseif vim.bo.filetype == "rust" then
        vim.cmd('TermExec cmd="clear && cargo build"')
        set_terminal(false)

    elseif vim.bo.filetype == "nim" then
        set_terminal(true)
        vim.cmd('TermExec cmd="clear && nimble --mm:none -d:noCycleGC -d:release --opt:speed run"')
    end

end, set_opts("Debug start")) -- run debug

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- TODO: Move to a separate file
vim.keymap.set({ 'n', 't' }, "<leader>7", function() build(true) end, set_opts())   -- build and run
vim.keymap.set({ 'n', 't' }, "<leader>8", run, set_opts())                          -- run

vim.keymap.set('n', "<leader>9", dapui.eval, set_opts("Debug evaluate expression")) -- inspect values
-- vim.keymap.set("n", "<C-5>", dap.run_last, { silent = true })
vim.keymap.set("n", "<leader>0", dapui.toggle, set_opts("Debug toggle UI"))

-- put/remove tabs
vim.keymap.set("n", "<tab>", ":><CR>", { silent = true })
vim.keymap.set("n", "<S-tab>", ":<<CR>", { silent = true })
vim.keymap.set("v", "<tab>", ":><CR>gv", { silent = true })
vim.keymap.set("v", "<S-tab>", ":<<CR>gv", { silent = true })

-- vim.keymap.set("n", "<tab>", "==", set_opts("Format line"))
-- vim.keymap.set("v", "<tab>", "=", set_opts("Format block"))

-- replace words
vim.keymap.set("v", "<C-f>", ":s/old/new/g", set_opts("Replace block words"))
vim.keymap.set("n", "<leader>f", ":s/old/new/g", set_opts("Replace words"))
vim.keymap.set("n", "<leader>F", "*N:%s//new/gc", set_opts("Replace word under cursor"))

vim.keymap.set('n', 'gi', telescope_bi.lsp_references, set_opts("[/] [G]oto [I]mplementation"))

-- Clear highlights
vim.keymap.set('n', '<Esc>', "<cmd>nohlsearch<CR>", set_opts("Clear all highlights"))

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

    if extension == "c" or extension == "cpp" then
        vim.cmd(":e %<.h")
    elseif extension == "h" or extension == "hpp" then
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
vim.keymap.set("n", "<leader>e>", ":Telescope file_browser<CR>", set_opts("File browser")) -- File browser

vim.keymap.set("v", "<leader>d", [[c"<C-r>""<Esc>]], set_opts("Wrap selected word with double quotes")) -- wrap with double quotes
vim.keymap.set("v", "<leader>q", [[c'<C-r>"'<Esc>]], set_opts("Wrap selected word with single quotes")) -- wrap with single quotes

vim.keymap.set("n", "ç", "^", set_opts("Go to the first word on current line")) -- go to the first word on the line
vim.keymap.set({ "n", "v" }, "*", "*N")

-- yank to OS clipboard
vim.keymap.set("n", "<C-c>", '"+yy')
vim.keymap.set("v", "<C-c>", '"+y')
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

vim.keymap.set("n", "<leader>oc", ":CodyChat<CR>", set_opts("Open CodyChat"))

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

-----------------------------------------------------------------------------------------------------------------------------------------

local ls = luasnip
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

vim.g.zig_fmt_autosave = 0 -- disable autoformat zig

ls.add_snippets("zig", {
    s("print", {
        t('log.print('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("println", {
        t('log.println('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printstr", {
        t('log.print_str("'),
        i(1),
        t('", @src());'),
        i(2),
    }),
    s("printlnstr", {
        t('log.println_str('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printstrerr", {
        t('log.print_str_err("'),
        i(1),
        t('", @src());'),
        i(2),
    }),
    s("printerr", {
        t('log.print_err('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printlnerr", {
        t('log.println_err('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printf", {
        t('log.printf("{'),
        i(1),
        t('}", .{ '),
        i(2),
        t(' }, @src());'),
        i(3),
    }),

    s("printferr", {
        t('log.printf_err("{'),
        i(1),
        t('}", .{ '),
        i(2),
        t(' }, @src());'),
        i(3),
    }),
    s("sizeof", {
        t('@sizeOf('),
        i(1),
        t(');'),
        i(2),
    }),
})
