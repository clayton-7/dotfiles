vim.loop.new_timer():start(0, 0, vim.schedule_wrap(function()
    vim.cmd('set filetype=cpp')
end))

vim.keymap.set({"n"}, "<leader>5", function()
    ExecTerm('clear && julec src -o main && ./main')
end, { desc = "build" })
