vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.guicursor = "n-v-c-i:block"
-- vim.opt.scrolloff = 999
-- vim.opt.cursorline = true
vim.opt.hlsearch = true
vim.opt.tabstop = 4
vim.opt.virtualedit = "all"

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
        gd = "gdscript",
        v = "v",
        pb = 'purebasic',
        pbi = 'purebasic',
    }
}

-- sometimes filetype is not detected
vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("filetype_by_extension", { clear = true }),
    pattern = "*",
    callback = function()
        vim.bo.filetype = vim.fn.fnamemodify(vim.fn.expand("%:e"), ":t")
    end,
})

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
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = true, layout = { fullscreen = false } },
            indent = { enabled = false },
            input = { enabled = false },
            notifier = { enabled = true },
            quickfile = { enabled = false },
            scope = { enabled = false },
            scroll = { enabled = false },
            statuscolumn = { enabled = false },
            words = { enabled = false },
            picker = {
                enabled = true,
                layout = { fullscreen = true },
                win = {
                    input = {
                        keys = {
                            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                        },
                    },
                    list = {
                        keys = {
                            ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                            ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                        },
                    },
                },
                sources = {
                    explorer = {
                        actions = {
                            bufadd = function(_, item)
                                if vim.fn.bufexists(item.file) == 0 then
                                    local buf = vim.api.nvim_create_buf(true, false)
                                    vim.api.nvim_buf_set_name(buf, item.file)
                                    vim.api.nvim_buf_call(buf, vim.cmd.edit)
                                end
                            end,
                            confirm_nofocus = function(picker, item)
                                if item.dir then
                                    picker:action 'confirm'
                                else
                                    picker:action 'bufadd'
                                end
                            end,
                        },
                        auto_close = true,
                        layout = {
                            fullscreen = false,
                            cycle = true,
                            preview = true,
                            layout = {
                                box = 'horizontal',
                                position = 'float',
                                height = 0.95,
                                width = 0,
                                border = 'rounded',
                                {
                                    box = 'vertical',
                                    width = 40,
                                    min_width = 40,
                                    { win = 'input', height = 1, title = '{title} {live} {flags}', border = 'single' },
                                    { win = 'list' },
                                },
                                { win = 'preview', width = 0, border = 'left' },
                            },
                        },
                    },
                },
            },
        },
        keys = {
            -- Top Pickers & Explorer
            { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Buffers" },
            { "<leader>/", function() Snacks.picker.resume() end, desc = "Grep" },
            { "<leader>nt", function() Snacks.picker.notifications() end, desc = "Notification History" },
            { "<C-b>", function() Snacks.explorer() end, desc = "File Explorer" },
            { "<leader>sf", function() Snacks.picker.files() end, desc = "Find Files" },
            { "<leader>sF", function()
                Snacks.picker.files { hidden = true, follow = true, cmd = 'fd', args = { '--type', 'd' }, transform = function(item)
                    return vim.fn.isdirectory(item.file) == 1
                end }
            end, desc = "find directory" },

            -- git
            { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
            { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
            { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
            { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
            -- Grep
            { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
            { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
            { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
            -- search
            { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
            { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
            { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
            { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
            { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
            { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
            { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
            { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
            { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
            { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
            { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
            { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
            { "<leader>u", function() Snacks.picker.undo() end, desc = "Undo History" },
            { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
            -- LSP
            { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
            { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
            -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
            { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
            -- Other
            { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
            { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
            { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
            { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
            { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
            { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
        win = { border = "rounded" } },
        keys = { {
              "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        version = false,
        event = "InsertEnter",
        config = function()
            require('mini.cursorword').setup{ delay = 50 }
            require('mini.splitjoin').setup()
            require('mini.comment').setup{  mappings = { comment_line = 'gc' } }
            require('mini.icons').setup()
            require('mini.completion').setup{ delay = { completion = 9999999999, info = 0, signature = 0 }}
        end,
    },
    { "sheerun/vim-polyglot" },
    {
        'tzachar/highlight-undo.nvim',
        opts = {
            hlgroup = "HighlightUndo",
            duration = 300,
            pattern = {"*"},
            ignored_filetypes = { "neo-tree", "fugitive", "TelescopePrompt", "mason", "lazy" },
        },
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-tree/nvim-web-devicons" },
    { -- session manager
        "Shatur/neovim-session-manager",
        priority = 1000,
        config = function()
            require('session_manager').setup {
                sessions_dir = require('plenary.path'):new(vim.fn.stdpath('data'), 'sessions'),
                autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
            }
        end,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim", opts = { ui = { border = "rounded" } } },
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            { "folke/neodev.nvim", opts = {} },
        },
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function() end,
            })

            require("mason").setup{ ui = { border = 'rounded' } }
            require("mason-lspconfig").setup()
        end,
    },
    { "pechorin/any-jump.vim" },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

    -- require("themes").nord,
    -- require("themes").nightfox,
    require("themes").warlock,
}, { ui = { border = "rounded" } })

local function set_opts(desc, silent)
    return { desc = desc, silent = silent and true or silent }
end

require("which-key").add{
    -- keybinds from "pechorin/any-jump.vim"
    { "<leader>j", desc = "Jump to definition under cursor", mode = "n" },
    { "<leader>j", desc = "Jump to selected text", mode = "v" },
    { "<leader>ab", desc = "Open previous opened file (after jump)", mode = "v" },
    { "<leader>al", desc = "Open last closed search window again", mode = "v" },
}

vim.o.winborder = 'rounded'

-- disable lsp annoyances
vim.diagnostic.config{
    virtual_text = false,
    signs = false,
    underline = false,
    update_in_insert = false,
}

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

vim.keymap.set('n', '<leader>st', function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd('J')
    vim.api.nvim_win_set_height(0, 20)
end)

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

function ExecTerm(cmd)
    open_terminal()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd .. "<CR>", true, false, true), 'n', true)
end

function Build(params, build_script_filepath, error_log_filepath)
    print("Building...")

    if not build_script_filepath then build_script_filepath = "build.sh" end
    if not error_log_filepath then error_log_filepath = "error.log" end
    if not params then params = "" end

    vim.fn.system('./' .. build_script_filepath)
    vim.fn.setqflist{}

    if vim.v.shell_error == 0 then
        vim.cmd('cclose')
        ExecTerm('clear && ./' .. build_script_filepath .. ' ' .. params)
    else
        vim.cmd('cfile ' .. error_log_filepath)
        vim.cmd('copen 15')
        vim.cmd.wincmd('J')
        vim.cmd('cfirst')
    end
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

vim.keymap.set("n", "<leader>nn", toggle_line_number, set_opts("Toggle line numbers", true))
vim.keymap.set('n', '<leader>bb', hide_bar, set_opts("Toggle bottom bars"))
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

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
