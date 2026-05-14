hl.config({
    dwindle = {
        preserve_split = true,
        smart_resizing = true,
    },

    master = {
        new_status = "slave",
    },

    scrolling = {
        fullscreen_on_one_column = true,
        column_width = 0.5,
        follow_focus = true,
        follow_min_visible = 0.1,
        explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
        direction = "right",
    },
})
