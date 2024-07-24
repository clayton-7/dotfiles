vim.keymap.set("n", "<leader>5", function()
    Build("clear && v -g run .")
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    Build("clear && v -prod .")
end, { desc = "build" })
