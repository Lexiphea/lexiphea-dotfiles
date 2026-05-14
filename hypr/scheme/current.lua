local M = {
    primary_paletteKeyColor = "71749b",
    secondary_paletteKeyColor = "74758b",
}

local paths = {
    os.getenv("HOME") .. "/.config/hypr/scheme/current.conf",
    os.getenv("HOME") .. "/.dotfiles/hypr/scheme/current.conf",
    os.getenv("HOME") .. "/.config/hypr/deprecated/scheme/current.conf",
    os.getenv("HOME") .. "/.dotfiles/hypr/deprecated/scheme/current.conf",
}

for _, path in ipairs(paths) do
    local file = io.open(path, "r")
    if file then
        for line in file:lines() do
            local name, value = line:match("^%s*%$([%w_]+)%s*=%s*([%x]+)%s*$")
            if name and value then
                M[name] = value
            end
        end

        file:close()
        break
    end
end

return M
