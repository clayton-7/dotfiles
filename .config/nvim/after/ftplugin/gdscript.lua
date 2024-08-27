local port = tonumber(os.getenv('GDScript_Port')) or 6005
local cmd = vim.lsp.rpc.connect('127.0.0.1', port)
local pipe = '/tmp/godot.pipe'

vim.lsp.start({
    name = 'Godot',
    cmd = cmd,
    root_dir = vim.fs.dirname(vim.fs.find({ 'project.godot', '.git' }, { upward = true })[1]),
    -- on_attach = function(client, bufnr)
    on_attach = function()
        vim.api.nvim_command('echo serverstart("' .. pipe .. '")')
    end
})

local dap = require("dap")
dap.adapters.godot = {
	type = "server",
	host = "127.0.0.1",
	port = 6006,
}

dap.configurations.gdscript = {
	{
		type = "godot",
		request = "launch",
		name = "Launch scene",
		project = "${workspaceFolder}",
		launch_scene = true
	}
}

vim.keymap.set({"n"}, "<leader>5", function()
    dap.continue()
end, { desc = "build" })
