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

vim.keymap.set({"n"}, "<leader>5", function() ExecTerm("./build.sh run") end, { desc = "build and run" })
