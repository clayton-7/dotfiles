vim.keymap.set("n", "<leader>5", function()
    Build('clear && zig build run')
end, { desc = "build and run" })

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

vim.g.zig_fmt_autosave = 0 -- disable autoformat zig

ls.add_snippets("zig", {
    s("trace", {
        t('log.TRACE('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("tracef", {
        t('log.TRACEF("'),
        i(1),
        t(' {'),
        i(2),
        t('}\\n", .{ '),
        i(3),
        t(' }, @src());'),
        i(4),
    }),

    s("info", {
        t('log.INFO('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("infof", {
        t('log.INFOF("'),
        i(1),
        t(' {'),
        i(2),
        t('}\\n", .{ '),
        i(3),
        t(' }, @src());'),
        i(4),
    }),
    s("debug", {
        t('log.DEBUG('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("debugf", {
        t('log.DEBUGF("'),
        i(1),
        t(' {'),
        i(2),
        t('}\\n", .{ '),
        i(3),
        t(' }, @src());'),
        i(4),
    }),
    s("warn", {
        t('log.warn('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("warnf", {
        t('log.WARNF("'),
        i(1),
        t(' {'),
        i(2),
        t('}\\n", .{ '),
        i(3),
        t(' }, @src());'),
        i(4),
    }),
    s("error", {
        t('log.ERROR('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("errorf", {
        t('log.ERRORF("'),
        i(1),
        t(' {'),
        i(2),
        t('}\\n", .{ '),
        i(3),
        t(' }, @src());'),
        i(4),
    }),
    s("fatal", {
        t('log.FATAL('),
        i(1),
        t(', @src());'),
        i(2),
    }),
    s("FATALF", {
        t('log.FATALF("'),
        i(1),
        t(' {'),
        i(2),
        t('}\\n", .{ '),
        i(3),
        t(' }, @src());'),
        i(4),
    }),
    s("sizeof", {
        t('@sizeOf('),
        i(1),
        t(');'),
        i(2),
    }),
})
