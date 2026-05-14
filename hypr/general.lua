-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Variables/
local scheme = require("scheme.current")

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 6,

        border_size = 4,

        -- https://wiki.hypr.land/Configuring/Variables/#variable-types
        col = {
            active_border   = { colors = {"rgb(" .. scheme.primary_paletteKeyColor .. ")", "rgb(" .. scheme.secondary_paletteKeyColor .. ")"}, angle = 45 },
            inactive_border = "rgba(255,255,255,0.4)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "scrolling",
    },

    decoration = {
        rounding       = 4,
        rounding_power = 4,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled           = true,
            size              = 8,
            passes            = 2,
            vibrancy          = 0.1696,
            vibrancy_darkness = 0.8,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        accel_profile           = "flat",
        sensitivity             = 1,
        repeat_rate             = 25,
        emulate_discrete_scroll = 1,
        scroll_factor           = 1,
    },

    misc = {
        force_default_wallpaper   = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo     = false, -- If true disables the random hyprland logo / anime girl background. :(
        vrr                       = 3,
        mouse_move_enables_dpms   = false,
        allow_session_lock_restore = true,
        key_press_enables_dpms    = true,
    },

    render = {
        cm_enabled  = true,
        cm_auto_hdr = false,
    },

    cursor = {
        no_hardware_cursors = 0,
    },
})

-- Default curves, see https://wiki.hypr.land/Configuring/Animations/#curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1} } })
hl.curve("easeOutQuart",   { type = "bezier", points = { {0.25, 1},    {0.5, 1} } })
hl.curve("easeOutExpo",    { type = "bezier", points = { {0.16, 1},    {0.3, 1} } })

-- Default animations, see https://wiki.hypr.land/Configuring/Animations/
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 2.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 67%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 67%" })
hl.animation({ leaf = "windowsMove",   enabled = true, speed = 1.49, bezier = "linear",       style = "slide top 67%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "easeOutQuart", style = "slidevertfade top 30%" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 2.21, bezier = "easeOutExpo",  style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.94, bezier = "easeOutExpo",  style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })
