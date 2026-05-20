hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1", default = true, layout = "dwindle" })
hl.workspace_rule({ workspace = "special:gaming", monitor = "DP-1", no_shadow = true, layout = "master" })

hl.layer_rule({
    name = "vicinae-blur",
    match = {
        namespace = "vicinae",
    },
    blur = true,
    ignore_alpha = 0,
})

hl.layer_rule({
    name = "vicinae-no-animation",
    no_anim = true,
    match = { namespace = "vicinae"},
})

hl.window_rule({
    name = "kitty_tile_rule",
    match = { class = "^(kitty)$" },
    tile = true,
})

local games = "^((?i)steam_app_.*|lutris-game_class|gamescope|Minecraft.*|com.heroicgameslauncher.hgl)$"

hl.window_rule({
    name = "gaming_workspace_rule",
    match = { class = games },
    workspace = "special:gaming",
    content = "game",
    no_anim = true,
    no_blur = true,
    no_shadow = true,
    allows_input = true,
    rounding = 0,
    immediate = true,
    border_size = 0,
    monitor = "DP-1",
})

hl.window_rule({
    name = "maximize_rule",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "dragging_rule",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})

hl.layer_rule({
    name = "rofi_no_anim_rule",
    match = { class = "^(rofi)$" },
    no_anim = true,
})
