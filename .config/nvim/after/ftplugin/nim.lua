vim.keymap.set("n", "<leader>5", function()
    Build('clear && nim --verbosity:0 r src/main.nim')
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    Build('clear && nimble --mm:none -d:noCycleGC -d:release --opt:speed run')
end, { desc = "build for speed without cg" })
