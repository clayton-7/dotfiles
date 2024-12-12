vim.keymap.set({"n"}, "<leader>5", function()
    -- Build('clear && ./build.sh "-debug -sanitize:address -vet -vet-using-param -vet-cast -warnings-as-errors"')
    local flags = "-debug -vet-unused-imports -vet-shadowing -vet-using-stmt -vet-using-param -vet-cast -warnings-as-errors"
    Build('clear && ./build.sh "'.. flags ..'"')
end, { desc = "build" })

vim.keymap.set({"n"}, "<leader>6", function()
    Build('clear && ./build.sh')
end, { desc = "build" })
