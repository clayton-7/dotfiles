vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 200
vim.opt.timeoutlen = 250
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.guicursor = "n-v-c-i:block"
vim.opt.scrolloff = 999
vim.opt.hlsearch = true

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

vim.filetype.add {
    extension = {
        -- defold
        script = "lua",
        gui_script = "lua",
        render_script = "lua",

        wgsl = "wgsl",
        vert = "glsl",
        frag = "glsl",
        gltf = "json",

        v = "v",
        pb = 'purebasic',
        pbi = 'purebasic',
    }
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { -- trim whitespaces
        "cappyzawa/trim.nvim",
        event = "InsertEnter",
        config = true,
    },
    { -- Fuzzy Finder (files, lsp, etc)
        "nvim-telescope/telescope.nvim",
        event = "InsertEnter",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { -- If encountering errors, see telescope-fzf-native README for installation instructions
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable("make") == 1 end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
            { "nvim-tree/nvim-web-devicons", enabled = true },
        },
        config = function()
            local actions = require("telescope.actions")
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_ivy() },
                },
                defaults = {
                    mappings = { i = { ["<Esc>"] = actions.close } },

                    buffer_previewer_maker = function(filepath, bufnr, opts)
                        filepath = vim.fn.expand(filepath)

                        require('plenary.job'):new({
                            command = 'file',
                            args = { '--mime-type', '-b', filepath },
                            on_exit = function()
                                require('telescope.previewers').buffer_previewer_maker(filepath, bufnr, opts)
                            end
                        }):sync()
                    end
                },
            })

            -- Enable Telescope extensions if they are installed
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            setup_telescope_keybinds()
        end,
    },
    {
        'lewis6991/gitsigns.nvim',
        event = "InsertEnter",
        opts = {
            signs = {
                add          = { text = '▏' },
                change       = { text = '▏' },
            },
            signs_staged = {
                add          = { text = '▏' },
                change       = { text = '▏' },
            }
        },
    },
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        version = false,
        event = "InsertEnter",
        config = function()
            require('mini.cursorword').setup{ delay = 50 }
            require('mini.splitjoin').setup()
        end,
    },
    { -- set tab space for different languages
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
                        filetypes = { "go", "python", "gdscript", "v" },
                        config = {
                            tabwidth = 4,
                            expandtab = false
                        }
                    }
                }
            }
        end
    },
    { -- undo
        "mbbill/undotree",
        event = "InsertEnter",
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
        "nvim-neo-tree/neo-tree.nvim",
        event = "InsertEnter",
        branch = "v3.x",

        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            window = {
                position = "right",
                mappings = {
                    ["<Esc>"] = "close_window",
                    ["P"] = "toggle_preview",
                }
            }
        }
    },
    { -- wildmenu autocompletion
        'gelguy/wilder.nvim',
        event = 'CmdlineEnter',
        dependencies = { "romgrk/fzy-lua-native" },
        config = function()
            local wilder = require('wilder')

            wilder.setup({modes = {':', '/', '?'}})
            wilder.set_option('renderer', wilder.popupmenu_renderer(
            wilder.popupmenu_border_theme({
                highlighter = wilder.basic_highlighter(),
                min_width = '10%',
                max_height = '20%',
                reverse = 0,
                left = {' ', wilder.popupmenu_devicons()},
                right = {' ', wilder.popupmenu_scrollbar()},

                highlights = {
                    accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#15bbcc'}}),
                },

                next_key = 'a',
                previous_key = '<C-p>',
                accept_key = '<C-y>',
                -- reject_key = '<Up>',
            })
            ))
        end,
    },
    { -- session manager
        "Shatur/neovim-session-manager",
        priority = 1000,
        config = function()
            require('session_manager').setup {
                sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'sessions'),
                -- autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir,
                autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
            }
        end,
    },

    -- require("themes").simple_dark,
    require("themes").nord,
    -- require("themes").bamboo,
    -- require("themes").monotone,

}, { ui = { border = "rounded" } })

local function set_opts(desc, silent)
    return { desc = desc, silent = silent and true or silent }
end

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', set_opts('Exit terminal mode'))

-- yank to OS clipboard
vim.keymap.set("n", "<C-c>", '"+yy')
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-S-c>", '"+yy')
vim.keymap.set("v", "<C-S-c>", '"+y')
vim.keymap.set("v", "p", '"_dP', { silent = true })

vim.keymap.set("v", "y", 'ygv', { silent = true })
vim.keymap.set("c", "w\\", 'w', { silent = true })

vim.keymap.set({ "n", "v" }, "<C-z>", "") -- disable ctrl z
vim.keymap.set("n", "<C-b>", ':Neotree toggle right filesystem reveal<CR>', set_opts("File browser")) -- File browser

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", ";", "^", set_opts("Go to the first word on current line"))

vim.keymap.set("v", "<", '<gv', { silent = true })
vim.keymap.set("v", ">", '>gv', { silent = true })

vim.keymap.set("n", "<C-q>", ":bd!<CR>", set_opts("Close current buffer"))
vim.keymap.set("t", "<C-q>", "exit<CR><CR>", set_opts("Close current terminal buffer"))

vim.keymap.set("n", "zh", function() vim.cmd("bn") end, set_opts("Next buffer", true))
vim.keymap.set("n", "zl", function() vim.cmd("bp") end, set_opts("Previous buffer", true))

vim.keymap.set("n", "<Leader>sp", ':SessionManager load_session<CR>', set_opts("Open projects", true))
vim.keymap.set("n", "<CR>", ':w<CR>', set_opts("Save current buffer", false))

vim.keymap.set({ 'n', 'i', 'v','t' }, '<F1>', "<Esc>", set_opts())

function setup_telescope_keybinds()
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { desc = desc })
    end

    -- See `:help telescope.builtin`
    local builtin = require("telescope.builtin")
    map("<leader>sh", builtin.help_tags, "Search Help")
    map("<leader>sk", builtin.keymaps, "Search Keymaps")
    map("<leader>sf", builtin.find_files, "Search Files")
    map("<leader>ss", builtin.builtin, "Search Select Telescope")
    map("<leader>sw", builtin.grep_string, "Search current Word")
    map("<leader>sg", builtin.live_grep, "Search by Grep")
    map("<leader>sd", builtin.diagnostics, "Search Diagnostics")
    map("<leader>sr", builtin.resume, "Search Resume")
    map("<leader>s.", builtin.oldfiles, 'Search Recent Files ("." for repeat)')
    map("<leader><leader>", builtin.buffers, "Find existing buffers")

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            winblend = 10,
            previewer = false,
        }))
    end, { desc = "Fuzzily search in current buffer" })

    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
            grep_open_files = true,
            prompt_title = "Live Grep in Open Files",
        })
    end, { desc = "Search in Open Files" })
end

local toggle_whitespace = vim.opt.list

vim.keymap.set("n", "<leader>bh", function()
    toggle_whitespace = not toggle_whitespace
    vim.opt.list = toggle_whitespace
end, set_opts("Toggle whitespace characters"))

local function open_terminal(new_terminal)
    if not new_terminal then
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
                vim.cmd('bd!' .. buf)
                break
            end
        end
    end

    vim.cmd('tabnew | terminal')
end

vim.keymap.set('n', '<leader>t', function() open_terminal(true) end, set_opts("open terminal"))

function tab_line()
    local tabline = ""

    for i = 1, vim.fn.tabpagenr("$") do
        -- Select the highlighting
        if i == vim.fn.tabpagenr() then
            tabline = tabline .. "%#TabLineSel#"
        else
            tabline = tabline .. "%#TabLine#"
        end

        tabline = tabline.."%"..(i).."T"

        local buflist = vim.fn.tabpagebuflist(i)
        local winnr = vim.fn.tabpagewinnr(i)
        local tab_name = vim.fn.bufname(buflist[winnr])

        -- format terminal name
        if vim.fn.getbufvar(buflist[1], "&buftype") == "terminal" then
            tab_name = tab_name:match("([^:]+)$")
        end

        tabline = tabline.." ".. i .." - ".. tab_name.." "
    end

    tabline = tabline .. "%#TabLineFill#%T"
    tabline = tabline .. "%=%#TabLine#%999X|close|"

    return tabline
end

vim.opt.tabline = "%!v:lua.tab_line()"

function Build(cmd)
    open_terminal()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd .. "<CR>", true, false, true), 'n', true)
end

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
        vim.cmd("set showmode")
        vim.cmd("set ruler")
        vim.cmd("set showcmd")
    end
end

local toggle_line = false
local function toggle_line_number()
    toggle_line = not toggle_line
    vim.opt.number = toggle_line
    vim.opt.relativenumber = toggle_line
end

vim.keymap.set("n", "<leader>n", toggle_line_number, set_opts("Toggle line numbers", true))
vim.keymap.set('n', '<leader>bb', hide_bar, set_opts("Toggle bottom bars"))

local config_group = vim.api.nvim_create_augroup('on_load_session', {})
vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = "SessionLoadPost",
    group = config_group,
    callback = hide_bar,
})

vim.api.nvim_create_augroup("terminal_insert_mode", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
    group = "terminal_insert_mode",
    command = "startinsert"
})

vim.loop.new_timer():start(100, 0, vim.schedule_wrap(function()
    vim.opt.formatoptions:remove{"c", "r", "o"}
    vim.cmd("wincmd =")

    -- enter in insert mode and exit to trigger the event InsertEnter
    local keys = vim.api.nvim_replace_termcodes("<Esc>i<Esc>", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
end))
