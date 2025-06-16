local port = tonumber(os.getenv('GDScript_Port')) or 6005
local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
local pipe = '/tmp/godot.pipe'

vim.o.commentstring = "#%s"

vim.o.tabstop = 8
vim.o.shiftwidth = 8

vim.loop.new_timer():start(100, 0, vim.schedule_wrap(function()
    vim.o.filetype = "gdscript"
    vim.o.tabstop = 8
    vim.o.shiftwidth = 8
end))

if not vim.lsp.buf_is_attached(0, vim.lsp.client.id) then
    vim.lsp.start{
        name = 'Godot',
        cmd = cmd,
        root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
        on_attach = function()
            vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
            vim.o.tabstop = 8
            vim.o.shiftwidth = 8
        end
    }
end

local ok, dap = pcall(require, "dap")
if not ok then return end

dap.adapters.godot = {
    type = "server",
    host = "127.0.0.1",
    port = 6006,
}

dap.configurations.gd = {
    {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true
    }
}

dap.configurations.gdscript = dap.configurations.gd

vim.keymap.set("n", "<leader>5", function()
    dap.continue()
end, { desc = "run debug" })

vim.keymap.set("n", "<leader>6", function()
    dap.close()
end, { desc = "stop debug" })
