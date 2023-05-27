-- Powerarrow Awesome WM theme github.com/lcpz

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local theme                                     = {}
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow"
theme.font                                      = "JetBrains Mono 12"
theme.taglist_font                              = "JetBrains Mono 10"
theme.fg_normal                                 = "#ffffff"
theme.fg_focus                                  = "#ffffff"
theme.fg_urgent                                 = "#b74822"
theme.bg_normal                                 = "#50505030"
theme.bg_focus                                  = "#ffffff15"
theme.bg_urgent                                 = "#3F3F3F"
theme.taglist_fg_focus                          = "#ffffff"
theme.taglist_bg_focus                          = "#ffffff50"
-- theme.tasklist_bg_focus                         = "#00000000"
theme.tasklist_fg_focus                         = "#ffffff"
theme.tasklist_bg_normal                        = "#00000000"
theme.tasklist_fg_normal                        = "#00000000"
theme.tasklist_fg_minimize                      = "#00000000"
theme.tasklist_fg_minimize                      = "#00000000"
theme.tasklist_fg_minimize                      = "#00000000"
theme.border_width                              = 4
theme.border_normal                             = "#272727"
theme.border_focus                              = "#ff000011"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"
theme.titlebar_bg_focus                         = theme.bg_focus
theme.titlebar_bg_normal                        = theme.bg_normal
theme.titlebar_fg_focus                         = theme.fg_focus
theme.menu_height                               = 20
theme.menu_width                                = 140
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/floating.png"
theme.widget_ac                                 = theme.dir .. "/icons/ac.png"
theme.widget_battery                            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low                        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty                      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                                = theme.dir .. "/icons/mem.png"
theme.widget_temp                               = theme.dir .. "/icons/temp.png"
theme.widget_net                                = theme.dir .. "/icons/net.png"
theme.widget_hdd                                = theme.dir .. "/icons/hdd.png"
theme.widget_music                              = theme.dir .. "/icons/note.png"
theme.widget_music_on                           = theme.dir .. "/icons/note.png"
theme.widget_music_pause                        = theme.dir .. "/icons/pause.png"
theme.widget_music_stop                         = theme.dir .. "/icons/stop.png"
theme.widget_vol_high                           = theme.dir .. "/icons/vol_high.png"
theme.widget_vol_mid                            = theme.dir .. "/icons/vol_mid.png"
theme.widget_vol_low                            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no                             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute                           = theme.dir .. "/icons/vol_mute.png"
theme.widget_mail                               = theme.dir .. "/icons/mail.png"
theme.widget_mail_on                            = theme.dir .. "/icons/mail_on.png"
theme.widget_task                               = theme.dir .. "/icons/task.png"
theme.widget_scissors                           = theme.dir .. "/icons/scissors.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.useless_gap                               = 3
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png"

local markup = lain.util.markup
local separators = lain.util.separators

-- Textclock
local clock = awful.widget.watch("date +'%a %d %b %R:%S'", 1, function(widget, stdout)
    widget:set_markup("" .. markup.font(theme.font, stdout))
end)

-- Calendar
theme.cal = lain.widget.cal{
    attach_to = { clock },
    notification_preset = {
        font = "JetBrains Mono 11",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
}

-- ALSA volume
theme.volume = lain.widget.alsabar({
    --togglechannel = "IEC958,3",
    notification_preset = { font = theme.font, fg = theme.fg_normal },
})

-- MEM
local memicon = wibox.widget.imagebox(theme.widget_mem)
local mem = lain.widget.mem{
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
}

-- ALSA volume
local volicon = wibox.widget.imagebox(theme.widget_high)
theme.volume = lain.widget.alsa{
    settings = function()
        if volume_now.status == "off" then
            volicon:set_image(theme.widget_vol_mute)

        elseif tonumber(volume_now.level) == 0 then
            volicon:set_image(theme.widget_vol_no)

        elseif tonumber(volume_now.level) <= 25 then
            volicon:set_image(theme.widget_vol_low)

        elseif tonumber(volume_now.level) <= 75 then
            volicon:set_image(theme.widget_vol_mid)

        else
            volicon:set_image(theme.widget_vol_high)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
    end
}

-- Net
local neticon = wibox.widget.imagebox(theme.widget_net)
local net = lain.widget.net({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#FEFEFE", " " .. net_now.received .. " ↓↑ " .. net_now.sent .. " "))
    end
})

-- Separators
local arrow = separators.arrow_left

function theme.powerline_rl(cr, width, height)
    local arrow_depth, offset = height/2, 0

    -- Avoid going out of the (potential) clip area
    if arrow_depth < 0 then
        width  =  width + 2*arrow_depth
        offset = -arrow_depth
    end

    cr:move_to(offset + arrow_depth         , 0        )
    cr:line_to(offset + width               , 0        )
    cr:line_to(offset + width - arrow_depth , height/2 )
    cr:line_to(offset + width               , height   )
    cr:line_to(offset + arrow_depth         , height   )
    cr:line_to(offset                       , height/2 )

    cr:close_path()
end

local function pl(widget, bgcolor, pad)
    -- local b = function (cr)
    --     gears.shape.rounded_rect(cr, 100, 25, 100)
    -- end
    -- return wibox.container.background(wibox.container.margin(widget, 10, pad), bgcolor, b)
    -- return wibox.container.background(wibox.container.margin(widget, 10, pad), bgcolor, gears.shape.rounded_rect)
    return wibox.container.background(wibox.container.margin(widget, 10, pad), bgcolor, theme.powerline_rl)
end

function theme.at_screen_connect(s)
    -- Quake application
    -- s.quake = lain.util.quake({ app = awful.util.terminal })
    s.quake = lain.util.quake({ app = "termite", height = 0.50, argname = "--name %s" })

    -- All tags open with layout 1
    awful.tag(awful.util.tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(my_table.join(
       awful.button({}, 1, function() awful.layout.inc( 1) end),
       awful.button({}, 3, function() awful.layout.inc(-1) end),
       awful.button({}, 4, function() awful.layout.inc( 1) end),
       awful.button({}, 5, function() awful.layout.inc(-1) end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist{
        screen   = s,
        filter   = awful.widget.tasklist.filter.focused,
        buttons  = awful.util.taglist_buttons,
        shape_clip = true,
        style    = {
            shape_border_width = 2,
            shape_border_color = '#ff000015',
            shape  = gears.shape.rounded_rect,
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = {
                            left  = 10,
                            right = 10,
                        },
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    if s.index == 1 then
        s.mywibox = awful.wibar{
            position = "top",
            screen = s,
            shape = gears.shape.rounded_rect,
            height = 43,
            bg = "#101010aa",
            fg = theme.fg_normal,
        }
    else
        s.mywibox = awful.wibar{
            position = "top",
            screen = s,
            shape = gears.shape.rounded_rect,
            height = 30,
            bg = "#10101050",
            fg = theme.fg_normal,
        }
    end

    local function round_wibox(icon, widget)
        local round = wibox.widget{
            icon,
            widget,
            layout = wibox.layout.align.horizontal,
            -- shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, 2) end,
            shape = gears.shape.rounded_bar,
            shape_clip = true,
        }

        return round
    end

    local vol_widget = round_wibox(volicon, theme.volume.widget)
    local net_widget = round_wibox(nil, net.widget)
    local margin = 3
    local bg_widget_color = "#77777750"

    local systray = wibox.widget{
        {
            wibox.widget.systray(),
            left   = 10,
            top    = 2,
            bottom = 2,
            right  = 10,
            widget = wibox.container.margin,
        },
        bg         = bg_widget_color,
        shape      = gears.shape.rounded_rect,
        shape_clip = true,
        widget     = wibox.container.background,
    }
    -- systray only on primary monitor
    if s.index ~= 1 then systray = nil end

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            -- s.mylayoutbox,
            s.mytaglist,
            s.mypromptbox,
        },
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytasklist,
            -- wibox.container.background(wibox.container.margin(round_wibox(nil, s.mytasklist), margin*4, margin*4), bg_widget_color, gears.shape.rounded_rect),
        },
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            wibox.container.margin(nil, margin * 1.5),

            wibox.container.background(wibox.container.margin(vol_widget, margin, margin), bg_widget_color, gears.shape.rounded_rect),
            wibox.container.margin(nil, margin * 1.5),
            wibox.container.background(wibox.container.margin(net_widget, margin, margin), bg_widget_color, gears.shape.rounded_rect),
            wibox.container.margin(nil, margin * 1.5),
            wibox.container.background(wibox.container.margin(clock, margin * 3, margin * 3), bg_widget_color, gears.shape.rounded_rect),
        },
    }
end

return theme
