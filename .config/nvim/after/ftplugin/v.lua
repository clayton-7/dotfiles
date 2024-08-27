local function build(cmd)
    vim.cmd('TermExec cmd="clear"')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('6<C-w>j', true, false, true), 'n', true)

    vim.loop.new_timer():start(50, 0, vim.schedule_wrap(function()
        vim.api.nvim_buf_delete(0, { force = true })

        vim.loop.new_timer():start(50, 0, vim.schedule_wrap(function()
            vim.cmd('TermExec cmd="'.. cmd ..'"')
        end))
    end))

end

vim.keymap.set({"n"}, "<leader>5", function()
    build("clear && v -g run .")
end, { desc = "build" })

vim.keymap.set({"n"}, "<leader>6", function()
    build("clear && v -prod .")
end, { desc = "build" })

local ls = require('luasnip')
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

ls.add_snippets("v", {
    s("debug", {
        t('logger.debug('),
        i(1),
        t(')'),
        i(2),
    }),
    s("debugl", {
        t('logger.debugl(@FILE_LINE, '),
        i(1),
        t(')'),
        i(2),
    }),
    s("error", {
        t('logger.error('),
        i(1),
        t(')'),
        i(2),
    }),
    s("errorl", {
        t('logger.errorl(@FILE_LINE, '),
        i(1),
        t(')'),
        i(2),
    }),
})


vim.api.nvim_create_augroup("vtags", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
    group = 'vtags',
    pattern = "*.v",
    callback = function()
        local command = 'pwd'

        local handle = io.popen(command)
        if handle == nil then return end

        local pwd = handle:read("*a")
        handle:close()

        vim.cmd([[silent !ctags -f $HOME/.tags/v.tags -R --options=$HOME/.ctags ]] .. pwd)
        vim.cmd('set tags=$HOME/.tags/v.tags')

    end,
})

-- local function list_tags(directory)
--     local command = "ls " .. directory
--
--     local handle = io.popen(command)
--     if handle == nil then return end
--
--     local result = handle:read("*a")
--     handle:close()
--
--     local handle1 = io.popen("echo " .. directory)
--     if handle1 == nil then return end
--
--     local dir = handle1:read("*a"):gsub("\n", "")
--     handle1:close()
--
--     -- local files = "tags"
--     local files = ""
--
--     for filename in result:gmatch("[^\r\n]+") do
--         local separator = #files == 0 and "" or ";"
--         files = files .. separator .. dir .. filename
--     end
--
--     return files
-- end
-- vim.api.nvim_create_augroup("vtags", { clear = true })
--
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     group = 'vtags',
--     pattern = "*.v",
--     callback = function()
--         local names = list_tags("$HOME/.tags/")
--         local tags = "set tags="..names
--         print(tags)
--         vim.cmd(tags)
--     end,
-- })
