vim.keymap.set("n", "<leader>5", function()
    vim.cmd('TermExec cmd="clear && pbcompiler -d -q main.pb"')
end, { desc = "build " })
