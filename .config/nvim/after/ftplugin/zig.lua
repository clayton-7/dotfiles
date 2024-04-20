vim.keymap.set("n", "<leader>5", function()
    vim.cmd('TermExec cmd="clear && zig build run"')
end, { desc = "build and run" })

vim.keymap.set("n", "<leader>6", function()
    vim.cmd('TermExec cmd="clear && zig build run"')
    vim.cmd("ToggleTerm")

end, { desc = "build and run without terminal" })

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

vim.g.zig_fmt_autosave = 0 -- disable autoformat zig

ls.add_snippets("zig", {
    s("print", {
        t('log.print('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("println", {
        t('log.println('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printstr", {
        t('log.print_str("'),
        i(1),
        t('", @src());'),
        i(2),
    }),
    s("printlnstr", {
        t('log.println_str('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printstrerr", {
        t('log.print_str_err("'),
        i(1),
        t('", @src());'),
        i(2),
    }),
    s("printerr", {
        t('log.print_err('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printlnerr", {
        t('log.println_err('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("printf", {
        t('log.printf("{'),
        i(1),
        t('}", .{ '),
        i(2),
        t(' }, @src());'),
        i(3),
    }),

    s("printferr", {
        t('log.printf_err("{'),
        i(1),
        t('}", .{ '),
        i(2),
        t(' }, @src());'),
        i(3),
    }),
    s("sizeof", {
        t('@sizeOf('),
        i(1),
        t(');'),
        i(2),
    }),
})
