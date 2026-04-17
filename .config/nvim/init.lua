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
vim.opt.scrolloff = 999
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.virtualedit = "all"
vim.opt.termguicolors = true
vim.opt.completeopt = "menu,menuone,noselect,noinsert,fuzzy"
vim.opt.confirm = true
vim.o.commentstring = "// %s"
vim.opt.shiftwidth = 4
vim.cmd("set path+=./**,/usr/local/include,/usr/include")

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.on_yank{ timeout = 300, visual = true, higroup = "Visual" } end,
})

vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })
vim.api.nvim_create_autocmd("FileType", { pattern = "help", command = "wincmd L" })

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
    callback = function() vim.opt.formatoptions:remove{"c", "r", "o"} end,
})

vim.filetype.add{
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
        jule = "jule",
    }
}

-- sometimes filetype is not detected
vim.api.nvim_create_autocmd("BufRead", {
    group = vim.api.nvim_create_augroup("filetype_by_extension", { clear = true }),
    pattern = "*",
    callback = function()
        local name = vim.fn.fnamemodify(vim.fn.expand("%:e"), ":t")

        if name == "hpp" then
            vim.bo.filetype = "cpp"
        elseif name == "zc" then
            vim.bo.filetype = name
        elseif name == "gd" then
            vim.bo.filetype = name
        elseif name == "wgsl" then
            vim.bo.filetype = name
        end
    end,
})

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then error("Error cloning lazy.nvim:\n" .. out) end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { -- trim whitespaces
        "cappyzawa/trim.nvim",
        event = "InsertEnter",
        config = true,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "InsertEnter",
        opts = {
            signs = {
                add    = { text = "▏" },
                change = { text = "▏" },
            },
            signs_staged = {
                add    = { text = "▏" },
                change = { text = "▏" },
            }
        },
    },
    { -- Collection of various small independent plugins/modules
        "echasnovski/mini.nvim",
        version = false,
        event = "InsertEnter",
        config = function()
            require("mini.cursorword").setup{ delay = 50 }
            require("mini.splitjoin").setup()
            require("mini.comment").setup{ mappings = { comment_line = "gc" } }
            require("mini.icons").setup()
        end,
    },
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = { {"kkharji/sqlite.lua", module = "sqlite"} },
        config = function()
            require("neoclip").setup{
                enable_persistent_history = true,
                keys = {
                    telescope = {
                        i = {
                            select = "<cr>",
                            paste = "<c-y>p",
                            paste_behind = "<c-y>P",
                            replay = "<c-y>q",  -- replay a macro
                            delete = "<c-y>d",  -- delete an entry
                            edit = "<c-y>e",    -- edit an entry
                            custom = {},
                        },
                    },
                },
            }
            vim.keymap.set("n", "<leader>y", function()
                require("telescope").extensions.neoclip.default()
            end, { noremap = true, silent = true, desc = "yank history" })
        end,
    },
    { "DingDean/wgsl.vim" },
    { -- Autocompletion
        "saghen/blink.cmp",
        event = "InsertEnter",
        version = "*",
        build = "cargo +nightly build --release",
        dependencies = {
            "folke/lazydev.nvim",
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
                build = "make install_jsregexp",
                opts = {},
            },
        },
        opts = {
            keymap = {
                preset = "default",
                ["<C-n>"] = { "select_next", "show" },
                ["<C-p>"] = { "select_prev", "show" },
            },
            appearance = { nerd_font_variant = "mono" },
            completion = {
                documentation = { auto_show = true, auto_show_delay_ms = 0 },
                menu = { auto_show = false, max_height = 30 },
            },
            sources = {
                default = { "lsp", "path", "snippets", "lazydev", "buffer" },
                providers = {
                    lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
                    buffer = { opts = { get_bufnrs = vim.api.nvim_list_bufs } },
                },
            },

            snippets = { preset = "luasnip" },
            fuzzy = { implementation = "prefer_rust" },
            signature = { enabled = true },
        },
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    { "sheerun/vim-polyglot" },  -- code highlight
    { "kevinhwang91/nvim-bqf" }, -- better quickfix window
    { "nvim-tree/nvim-web-devicons" },
    { -- session manager
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        priority = 1000,
        config = function()
            require("session_manager").setup {
                sessions_dir = require("plenary.path"):new(vim.fn.stdpath("data"), "sessions"),
                autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
                autosave_ignore_dirs = { "~", "~/Downloads" },
            }
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        event = "InsertEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "princejoogie/dir-telescope.nvim",
            "debugloop/telescope-undo.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable "make" == 1 end,
            },
        },
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = { require("telescope.themes").get_dropdown() },
                    ["undo"] = {
                        side_by_side = true,
                        saved_only = true,
                        entry_format = "$TIME",
                        layout_strategy = "horizontal",
                        vim_diff_opts = {
                            ctxlen = 25, -- how many lines shows in the diff
                        },
                        layout_config = {
                            preview_width = 0.9,
                        },
                    },
                },

                defaults = {
                    mappings = {
                        i = {
                            ["<Esc>"] = require("telescope.actions").close,
                            ["<C-t>"] = require("telescope.actions.layout").toggle_preview,
                        }
                    },

                    buffer_previewer_maker = function(filepath, bufnr, opts)
                        filepath = vim.fn.expand(filepath)

                        require("plenary.job"):new({
                            command = "file",
                            args = { "--mime-type", "-b", filepath },
                            on_exit = function()
                                require("telescope.previewers").buffer_previewer_maker(filepath, bufnr, opts)
                            end
                        }):sync()
                    end,

                    layout_config = {
                        horizontal = { width = 0.99, height = 0.99 },
                    },

                    preview = {
                        treesitter = false,
                    },
                },
            }

            -- its required to install fd and ripgrep to make this works
            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            require("telescope").load_extension("dir")
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope dir find_files<CR>", { noremap = true, silent = true, desc = "Find files in a directory" })
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope dir live_grep<CR>", { noremap = true, silent = true, desc = "Search by grep in a directory" })

            -- delta its required: https://github.com/dandavison/delta
            require("telescope").load_extension("undo")
            vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")

            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
            vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
            vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
            vim.keymap.set("n", "<leader>s/", function()
                builtin.live_grep {
                    grep_open_files = true,
                    prompt_title = "Live Grep in Open Files",
                }
            end, { desc = "[S]earch [/] in Open Files" })
        end,
    },
    {
        "folke/which-key.nvim",
        event = "InsertEnter",
        opts = {
            delay = 200,
            win = { border = "rounded" },
            icons = {
                mappings = true,
                keys = {},
            },
            spec = {
                { "<leader>s", group = "[S]earch" },
                { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
            },
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "saghen/blink.cmp",
            { "mason-org/mason.nvim", opts = {} },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
                    map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

                    -- Find references for the word under your cursor.
                    map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

                    -- Jump to the implementation of the word under your cursor.
                    --  Useful when your language has ways of declaring types without an actual implementation.
                    map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

                    -- Jump to the definition of the word under your cursor.
                    --  This is where a variable was first declared, or where a function is defined, etc.
                    --  To jump back, press <C-t>.
                    map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map("grs", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map("grS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you"re not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
                end })

            vim.diagnostic.config {
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    }
                } or {},

                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            }

            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                displayContext = 5,
                                callSnippet = "Replace",
                            },
                        },
                    },
                },
            }

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, { "stylua" })
            require("mason-tool-installer").setup { ensure_installed = ensure_installed }

            require("mason-lspconfig").setup {
                ensure_installed = {},
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            }
        end,
    },
    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },

    -- require("themes").nord,
    -- require("themes").nightfox,
    -- require("themes").warlock,
    require("themes").darkvoid,
    -- require("themes").everforest,
}, { ui = { border = "rounded" } })

local function set_opts(desc, silent)
    return { desc = desc, silent = silent and silent or true }
end

vim.o.winborder = "rounded"

-- disable lsp annoyances
vim.diagnostic.config{
    virtual_text = false,
    signs = false,
    underline = false,
    update_in_insert = false,
}

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", set_opts("Exit terminal mode"))

-- yank to OS clipboard
vim.keymap.set("n", "<C-c>", '"+yy')
vim.keymap.set("v", "<C-c>", '"+y')
vim.keymap.set("n", "<C-S-c>", '"+yy')
vim.keymap.set("v", "<C-S-c>", '"+y')
vim.keymap.set("v", "p", '"_dP', { silent = true })

vim.keymap.set("v", "y", "ygv", { silent = true })

vim.keymap.set({ "n", "v" }, "<C-z>", "") -- disable ctrl z
vim.keymap.set("n", ";", "^", set_opts("Go to the first word on current line"))

vim.keymap.set("v", "<", "<gv", { silent = true })
vim.keymap.set("v", ">", ">gv", { silent = true })

vim.keymap.set("n", "<C-q>", ":bd!<CR>", set_opts("Close current buffer"))
vim.keymap.set("t", "<C-q>", "exit<CR><CR>", set_opts("Close current terminal buffer"))

vim.keymap.set("n", "zh", function() vim.cmd("bn") end, set_opts("Next buffer", true))
vim.keymap.set("n", "zl", function() vim.cmd("bp") end, set_opts("Previous buffer", true))

vim.keymap.set("n", "<leader>sp", ":SessionManager load_session<CR>", set_opts("Open projects", true))
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, set_opts("Code action", true))

vim.keymap.set({ "n", "i", "v","t" }, "<F1>", "<Esc>", set_opts())

local toggle_whitespace = vim.opt.list

vim.keymap.set("n", "<leader>bh", function()
    toggle_whitespace = not toggle_whitespace
    vim.opt.list = toggle_whitespace
end, set_opts("Toggle whitespace characters"))

local function open_terminal(new_terminal)
    if not new_terminal then
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
                vim.cmd("bd!" .. buf)
                break
            end
        end
    end

    vim.cmd("tabnew | terminal")
end

vim.keymap.set("n", "<leader>t", function() open_terminal(true) end, set_opts("open terminal"))

vim.keymap.set("n", "<leader>st", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 20)
end, set_opts("open bottom terminal"))

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
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd .. "<CR>", true, false, true), "n", true)
end

function Build(params, build_script_filepath, error_log_filepath)
    print("Building...")

    if not build_script_filepath then build_script_filepath = "build.sh" end
    if not error_log_filepath then error_log_filepath = "error.log" end
    if not params then params = "" end

    local output = vim.fn.system("./" .. build_script_filepath)
    output = output:gsub("%z", "")
    vim.fn.setqflist{}

    if vim.v.shell_error == 0 then
        vim.cmd("cclose")
        -- ExecTerm("clear && ./" .. build_script_filepath .. " " .. params)
        ExecTerm("./" .. build_script_filepath .. " " .. params)
    else
        local err_file = io.open(error_log_filepath, "rw")
        if not err_file then print("no error file"); return end

        local err_data = err_file:read("l") or ""
        err_file:close()

        if #err_data <= 0 then
            err_file = io.open(error_log_filepath, "w")
            err_file:write(output)
            err_file:close()
        end

        vim.cmd("cfile " .. error_log_filepath)
        vim.cmd("copen 15")
        vim.cmd.wincmd("J")
        vim.cmd("cfirst")
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
        vim.cmd("set cmdheight=1")
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
vim.keymap.set("n", "<leader>bb", hide_bar, set_opts("Toggle bottom bars"))
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic Error messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

local config_group = vim.api.nvim_create_augroup("on_load_session", {})
vim.api.nvim_create_autocmd({ "User" }, {
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
