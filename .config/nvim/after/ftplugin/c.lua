vim.opt.makeprg = "cmake --build build"

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "[^l]*",
    command = "cwindow",
    nested = true,
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    pattern = "l*",
    command = "lwindow",
    nested = true,
})

vim.keymap.set("n", "<A-o>", ":LspClangdSwitchSourceHeader<CR>")
