vim.keymap.set("n", "<leader>5", function()
    vim.cmd('TermExec cmd="clear && nim --verbosity:0 r src/main.nim"') -- using nim because it's faster then nimble
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    vim.cmd('TermExec cmd="clear && nimble --mm:none -d:noCycleGC -d:release --opt:speed run"')
end, { desc = "build for speed without cg" })
