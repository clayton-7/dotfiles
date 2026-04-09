vim.keymap.set("n", "<leader>4", function()
    ExecTerm('clear && ./build.sh clean')
end, { desc = "clean" })

vim.keymap.set("n", "<leader>5", function()
    ExecTerm('clear && ./build.sh run')
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    ExecTerm('clear && ./build.sh build_c')
end, { desc = "build c files" })
