vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.guicursor = "n-v-c-i:block"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = "split"
vim.o.scrolloff = 999
vim.o.confirm = true
vim.o.commentstring = "// %s"
vim.o.winborder = "rounded"
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.o.completeopt = "fuzzy,menu,menuone,noinsert,popup"
vim.o.virtualedit = "all"
vim.loader.enable()

vim.pack.add{
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/cappyzawa/trim.nvim",
    "https://github.com/NMAC427/guess-indent.nvim",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/Shatur/neovim-session-manager",
    "https://github.com/EdenEast/nightfox.nvim",
}

vim.cmd.packadd("nvim.undotree")

require('nightfox').setup { palettes = { nordfox = { bg1 = "#343a46" } } }
vim.cmd("colorscheme nordfox")

require("guess-indent").setup{}
require("trim").setup{}
require("todo-comments").setup{ signs = false }
require("mini.cursorword").setup{ delay = 50 }
require("mini.splitjoin").setup()
require('mini.cmdline').setup()

require("session_manager").setup{
    sessions_dir = require("plenary.path"):new(vim.fn.stdpath("data"), "sessions"),
    autoload_mode = require("session_manager.config").AutoloadMode.Disabled,
    autosave_ignore_dirs = { "~", "~/Downloads" },
}

require("gitsigns").setup{
    signs = {
        add = { text = "▏" },
        change = { text = "▏" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
    },
}

vim.keymap.set("n", "<leader>u", "<cmd>Undotree<cr>", { noremap = true })
vim.keymap.set("v", "<", "<gv", { silent = true, noremap = true })
vim.keymap.set("v", ">", ">gv", { silent = true, noremap = true })
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true })
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("v", "p", '"_dP', { silent = true })
vim.keymap.set("v", "y", "ygv", { silent = true })
vim.keymap.set({ "n", "v" }, "<C-z>", "", { noremap = true }) -- disable ctrl z
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true })
vim.keymap.set("n", "<leader>sp", ":SessionManager load_session<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { silent = true, noremap = true })

vim.cmd("set path+=./**,/usr/local/include,/usr/include")

vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("no_auto_comment", { clear = true }),
    callback = function() vim.opt.formatoptions:remove{"c", "r", "o"} end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
    callback = function() vim.hl.hl_op{ timeout = 300, visual = true, --[[higroup = "Visual"]] } end,
})

vim.api.nvim_create_augroup("terminal_insert_mode", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", { group = "terminal_insert_mode", command = "startinsert" })

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name = ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= "install" and kind ~= "update" then return end

        if name == "telescope-fzf-native.nvim" then
            local result = vim.system({ "make" }, { cwd = ev.data.path }):wait()
            if result.code == 0 then return end

            local stderr = result.stderr or ""
            local stdout = result.stdout or ""
            local output = stderr ~= "" and stderr or stdout
            if output == "" then output = "No output from build command." end
            vim.notify(("Build failed for %s:\n%s"):format(name, output), vim.log.levels.ERROR)

            return
        end
    end,
})

vim.lsp.enable{ "lua_ls", "clangd", "rust_analyzer" }

-- vim.diagnostic.config{
--     virtual_text = false,
--     signs = false,
--     underline = false,
--     update_in_insert = false,
-- }

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
    end
})
