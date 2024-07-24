vim.keymap.set("n", "<leader>5", function()
    Build("clear && odin run src -debug -define:WGPU_GFLW_GLUE_SUPPORT_WAYLAND=true")
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    Build("clear && odin build src")
end, { desc = "build" })
