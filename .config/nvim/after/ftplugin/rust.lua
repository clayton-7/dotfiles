vim.keymap.set("n", "<leader>5", function()
    vim.cmd('TermExec cmd="clear && cargo run"')
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    vim.cmd('TermExec cmd="clear && cargo run"')
    vim.cmd("ToggleTerm")
end, { desc = "build and run without terminal" })
