local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

-- Standard awesome library
local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window managment
local menubar = require("menubar")
require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")

-- Theme handling library
local beautiful     = require("beautiful")

-- Notification library
local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100

local lain          = require("lain")
local freedesktop   = require("freedesktop")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility

if awesome.startup_errors then
    naughty.notify{
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify{
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        }
        in_error = false
    end)
end

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "unclutter -root" }) -- entries must be comma-separated

local themes = {
    "powerarrow", -- 1
}

-- choose your theme here
local chosen_theme = themes[1]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

local modkey      = "Mod4"
local altkey      = "Mod1"
local ctrlkey     = "Control"
-- local terminal    = "alacritty"
local terminal    = "kitty"
local mediaplayer = "mpv"

local tag_names = { " 一 ", " 二 ", " 三 ", " 四 ", " 五 ", " 六 ", " 七 ", " 八 ", " 九 " }

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = tag_names
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.fair,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2
lain.layout.cascade.tile.master_count = 10

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e 'man awesome'" },
    { "edit config", "emacsclient -c -a emacs ~/.config/awesome/rc.lua" },
    { "arandr", "arandr" },
    { "restart", awesome.restart },
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Exit", "systemctl poweroff" },
        -- other triads can be put here
    }
})
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)

root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end)
))

local function create_key(modkeys, key, group, desc, func)
    return awful.key(modkeys, key, func, {description = desc, group = group})
end

local function volume_popup()
    local fd = io.popen("pactl get-sink-volume 0")
    if fd == nil then return end

    local status = fd:read("*all")
    fd:close()

    naughty.notify({ text = "Volume: ".. tonumber(string.match(status, "(%d?%d?%d)%%")) .. "%", timeout = 0.5, position = "top_middle" })
end

local function set_bar_enable(enable)
    for s in screen do
        s.mywibox.visible = enable
        if s.mybottomwibox then s.mybottomwibox.visible = enable end
    end
end

-- set_bar_enable(false)

local globalkeys = my_table.join(
    create_key({ modkey }, "t", "awesome", "terminal", function() awful.spawn(terminal) end),
    create_key({ modkey }, "r", "awesome", "restart awesome", awesome.restart),
    create_key({ modkey }, "s", "awesome", "help", hotkeys_popup.show_help),
    create_key({ modkey }, "f", "awesome", "menubar", menubar.show),

    awful.key({ modkey }, "b", function()
        set_bar_enable(true)

        local timer = {
            timeout = 3.5,
            single_shot = true,
            autostart = true,
            callback = function() set_bar_enable(false) end
        }
        gears.timer(timer)
    end, { description = "Show wibox (bar)", group = "awesome"}),

    -- Toggle bar
    awful.key({ modkey, "Shift" }, "b", function()
        set_bar_enable(not screen[1].mywibox.visible)
    end, { description = "Toggle wibox (bar)", group = "awesome"}),

    -- Tag browsing with modkey
    awful.key({ modkey }, "Left",   awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({ modkey }, "Right",  awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({ altkey }, "Escape", awful.tag.history.restore, {description = "go back", group = "tag"}),

     -- Tag browsing ALT+TAB (ALT+SHIFT+TAB)
    awful.key({ altkey,         }, "Tab", awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({ altkey, "Shift" }, "Tab", awful.tag.viewprev, {description = "view previous", group = "tag"}),

    -- Default client focus
    awful.key({ modkey }, "j", function() awful.client.focus.byidx( 1) end, {description = "Focus next by index", group = "client"}),
    awful.key({ modkey }, "k", function() awful.client.focus.byidx(-1) end, {description = "Focus previous by index", group = "client"}),

    -- By direction client focus
    awful.key({ altkey }, "j", function()
        awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end
    end, {description = "Focus down", group = "client"}),

    awful.key({ altkey }, "k", function() awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end end,
        {description = "Focus up", group = "client"}),
    awful.key({ altkey }, "h", function() awful.client.focus.global_bydirection("left")
        naughty.notify({ text = "Current screen: " .. awful.screen.focused().index, timeout = 1.0, position = "top_middle" })
        if client.focus then client.focus:raise() end
    end, {description = "Focus left", group = "client"}),

    awful.key({ altkey }, "l", function() awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end
        naughty.notify({ text = "Current screen: " .. awful.screen.focused().index, timeout = 1.0, position = "top_middle" })

    end, {description = "Focus right", group = "client"}),

        -- By direction client focus with arrows
    awful.key({ ctrlkey, modkey }, "Down", function() awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end end,
        {description = "Focus down", group = "client"}),
    awful.key({ ctrlkey, modkey }, "Up", function() awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end end,
        {description = "Focus up", group = "client"}),
    awful.key({ ctrlkey, modkey }, "Left", function() awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end end,
        {description = "Focus left", group = "client"}),
    awful.key({ ctrlkey, modkey }, "Right", function() awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end end,
        {description = "Focus right", group = "client"}),

    awful.key({ }, "Print", function() awful.util.spawn("flameshot gui") end),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "h", function () awful.client.swap.byidx(1) end, {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.byidx(-1) end, {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Shift" }, "j", function () awful.tag.incnmaster( 1, nil, true) end, {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift" }, "k", function () awful.tag.incnmaster(-1, nil, true) end, {description = "decrease the number of master clients", group = "layout"}),

    awful.key({ modkey          }, ".", function()
        awful.screen.focus_relative(1)
        naughty.notify({ text = "Current screen focus", timeout = 1.0, position = "top_middle" })
    end, { description = "focus the next screen", group = "screen" }),

    awful.key({ modkey          }, ",", function()
        awful.screen.focus_relative(-1)
        naughty.notify({ text = "Current screen focus", timeout = 1.0, position = "top_middle" })
    end, {description = "focus the previous screen", group = "screen"}),

    awful.key({ modkey,         }, "u", awful.client.urgent.jumpto,
        {description = "jump to urgent client", group = "client"}),

    awful.key({ modkey          }, "l", function () awful.tag.incmwfact( 0.025) end,
        {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey          }, "h", function () awful.tag.incmwfact(-0.025) end,
        {description = "decrease master width factor", group = "layout"}),

    awful.key({ modkey, ctrlkey }, "h", function () awful.tag.incncol( 1, nil, true) end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, ctrlkey }, "l", function () awful.tag.incncol(-1, nil, true) end,
        {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,         }, "Tab", function () awful.layout.inc( 1) end,
        {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift" }, "Tab", function () awful.layout.inc(-1) end,
        {description = "select previous", group = "layout"}),

    awful.key({ modkey, ctrlkey }, "n", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            client.focus = c
            c:raise()
        end
    end, {description = "restore minimized", group = "client"}),

    -- Dropdown application
    awful.key({ modkey, }, "F12", function () awful.screen.focused().quake:toggle() end, {description = "dropdown application", group = "super"}),

    -- ALSA volume control
    awful.key({}, "XF86AudioPlay", function() os.execute("playerctl play-pause") end),
    awful.key({ }, "XF86AudioRaiseVolume", function ()
        os.execute(string.format("pactl set-sink-volume 0 +5%%", beautiful.volume.channel))
        beautiful.volume.update()
        volume_popup()
    end),

    awful.key({ }, "XF86AudioLowerVolume", function ()
        os.execute(string.format("pactl set-sink-volume 0 -5%%", beautiful.volume.channel))
        beautiful.volume.update()
        volume_popup()
    end),

    awful.key({ }, "XF86AudioMute",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()

            naughty.notify({ text = "Mute/Unmute", timeout = 0.5 })
        end),

    awful.key({ altkey, "Shift" }, "x", function ()
        awful.prompt.run {
            prompt       = "Run Lua code: ",
            textbox      = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
    end, {description = "lua execute prompt", group = "awesome"})
)

local clientkeys = my_table.join(
    awful.key({ altkey, "Shift" }, "m", lain.util.magnify_client, {description = "magnify client", group = "client"}),

    awful.key({ modkey, ctrlkey }, "space", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey}, "c", function (c) c:kill() end, {description = "close", group = "hotkeys"}),
    awful.key({ modkey,         }, "t", awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key({ modkey, ctrlkey }, "Return", function (c) c:swap(awful.client.getmaster()) end, {description = "move to master", group = "client"}),
    awful.key({ modkey, "Shift" }, "t", function (c) c.ontop = not c.ontop end, {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,         }, "o", function (c) c:move_to_screen() end, {description = "move to screen", group = "client"}),
    awful.key({ modkey,         }, "n", function (c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
    end, {description = "minimize", group = "client"}),

    awful.key({ modkey }, "m", function(c)
        c.maximized = not c.maximized
        c:raise()
    end, {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus

    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end

    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9, function()
            local t = awful.screen.focused().tags[i]
            if t then t:view_only() end
            naughty.notify({ text = "Tag: ".. tag_names[i], timeout = 1.0, position = "top_middle" })

        end, descr_view),

        -- Toggle tag display.
        awful.key({ modkey, ctrlkey }, "#" .. i + 9, function()
            local t = awful.screen.focused().tags[i]
            if t then awful.tag.viewtoggle(t) end
            naughty.notify({ text = "Tag: ".. tag_names[i], timeout = 1.0, position = "top_middle" })

        end, descr_toggle),

        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if not client.focus then return end
            local t = client.focus.screen.tags[i]

            if t then client.focus:move_to_tag(t) end
            naughty.notify({ text = "Tag: ".. tag_names[i], timeout = 1.0, position = "top_middle" })

        end, descr_move),

        -- Toggle tag on focused client.
        awful.key({ modkey, ctrlkey, "Shift" }, "#" .. i + 9, function()
            if not client.focus then return end
            local t = client.focus.screen.tags[i]

            if t then client.focus:toggle_tag(t) end
            naughty.notify({ text = "Tag: ".. tag_names[i], timeout = 1.0, position = "top_middle" })

        end, descr_toggle_focus)
    )
end

local clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } }, properties = { titlebars_enabled = false } },

    { rule = { class = "Force" }, properties = {
        titlebars_enabled = true, floating = true },
        callback = function(c)
            awful.placement.centered(c,nil)
        end
    },

    { rule = { class = "Gimp*", role = "gimp-image-window" },
          properties = { maximized = true } },

    { rule = { class = "inkscape" },
          properties = { maximized = true } },

    { rule = { class = mediaplayer },
          properties = { maximized = true } },

    { rule = { class = "Vlc" },
          properties = { maximized = true } },

    { rule = { class = "VirtualBox Manager" },
          properties = { maximized = true } },

    { rule = { class = "VirtualBox Machine" },
          properties = { maximized = true } },

    { rule = { class = "Xfce4-settings-manager" },
          properties = { floating = false } },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Blueberry",
          "Galculator",
          "Gnome-font-viewer",
          "Gpick",
          "Imagewriter",
          "Font-manager",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Oblogout",
          "Peek",
          "Skype",
          "System-config-printer.py",
          "Sxiv",
          "Unetbootin.elf",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "Preferences",
          "setup",
        }
    }, properties = { floating = true }},
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 21}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
end)

-- No border for maximized clients
local function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.with_shell("lxsession")
awful.spawn.with_shell("picom --experimental-backend")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("volumeicon")
awful.spawn.with_shell("nitrogen --restore")

awful.spawn.with_shell("ibus start")
awful.spawn.with_shell("gnome-clocks")
awful.spawn.with_shell("xrandr --output DP-0 --primary --dpi 132 --output HDMI-0 --right-of DP-0 --dpi 96 --rotate right")

local timer = {
    timeout = 0.3,
    single_shot = true,
    autostart = true,
    callback = function()
        local t = client.focus.screen.tags[9]
        if t then client.focus:move_to_tag(t) return end
    end
}
gears.timer(timer)
