vim.keymap.set({"n"}, "<leader>5", function()
    Build("clear && ./build.sh -debug")
end, { desc = "build" })

vim.keymap.set({"n"}, "<leader>6", function()
    Build("clear && ./build.sh")
    -- Build("clear && odin run src")
end, { desc = "build" })
