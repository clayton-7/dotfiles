local dap, dapui = require("dap"), require("dapui")
dapui.setup()

dap.listeners.before.attach.dapui_config = function() dapui.open() end
dap.listeners.before.launch.dapui_config = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

dap.adapters.codelldb = {
    type = 'server',
    port = "${port}",
    executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
    },
}

dap.configurations.c = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function()
            local cwd = vim.fn.getcwd()
            local bin = vim.fn.fnamemodify(cwd, ':t')
            return cwd .. "/" .. bin
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
dap.configurations.cpp = dap.configurations.c

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

vim.keymap.set({"n"}, "<leader>4", function() ExecTerm('make clean') end, { desc = "make clean" })
vim.keymap.set({"n"}, "<leader>5", function() Build('run') end, { desc = "build" })

vim.keymap.set("n", "<A-o>", ':LspClangdSwitchSourceHeader<CR>')
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = "Debugger toggle breakpoint" })
vim.keymap.set('n', '<leader>ds', dap.continue, { desc = "Debugger start/continue" })
vim.keymap.set('n', '<leader>dl', dap.step_into, { desc = "Debugger step into" })
vim.keymap.set('n', '<leader>dj', dap.step_over, { desc = "Debugger step over" })
vim.keymap.set('n', '<leader>dh', dap.step_out, { desc = "Debugger step out" })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = "Debugger open repl" })
vim.keymap.set('n', '<leader>dq', function() dap.terminate(); dapui.close() end, { desc = "Debugger terminate" })
vim.keymap.set({'n','v'}, '<leader>de', dapui.eval, { desc = "Debugger evaluate expression" })
vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = "Debugger toggle ui" })
