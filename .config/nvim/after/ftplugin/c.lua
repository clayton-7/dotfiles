local dap = require('dap')

vim.keymap.set("n", "<leader>5", function()
    if vim.api.nvim_get_mode().mode == 't' then vim.cmd("ToggleTerm") end

    dap.continue()
    local started = type(dap.session()) == 'table'

    if not started then print('cannot debug an empty file!') end
end, { desc = "run debug" })

vim.keymap.set("n", "<leader>6", function()
    vim.cmd('TermExec cmd="clear && bear -- ninja build"')
    vim.cmd("ToggleTerm")
end, { desc = "build" })


vim.keymap.set("n", "<leader>7", function()
    vim.cmd('TermExec cmd="clear && bear -- ninja build"')
    vim.cmd('TermExec cmd="clear && ninja run"')
end, { desc = "build and run" })
