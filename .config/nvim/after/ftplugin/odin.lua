vim.bo.errorformat = "%f(%l:%c) %m"

vim.keymap.set({"n"}, "<leader>5", function()
    Build('run')
end, { desc = "build" })

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    pattern = '[^l]*',
    command = 'cwindow',
    nested = true,
})

vim.api.nvim_create_autocmd('QuickFixCmdPost', {
    pattern = 'l*',
    command = 'lwindow',
    nested = true,
})
