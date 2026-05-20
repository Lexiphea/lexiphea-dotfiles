local envs = {
    WAYLAND_DISPLAY = "wayland-1",
    NVD_BACKEND = "direct",

    -- Nvidia driver backend.
    LIBVA_DRIVER_NAME = "nvidia",
    __GLX_VENDOR_LIBRARY_NAME = "nvidia",

    -- Qt platform.
    QT_QPA_PLATFORM = "wayland",
    QT_QPA_PLATFORMTHEME = "qtengine",

    -- XDG desktop environment.
    XDG_CURRENT_DESKTOP = "Hyprland",
    XDG_SESSION_DESKTOP = "Hyprland",
    XDG_SESSION_TYPE = "wayland",

    HYPRSHOT_DIR = "~/Pictures/Screenshots",

    HYPRCURSOR_THEME = "Bibata-Modern-Ice",
    HYPRCURSOR_SIZE = "24",

    XCURSOR_THEME = "Bibata-Modern-Ice",
    XCURSOR_SIZE = "24",

    BROWSER = "zen-browser",
}

for key, value in pairs(envs) do
    hl.env(key, value)
end
