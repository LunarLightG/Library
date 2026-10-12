-- LunarGui Assets helper
-- Returns Roblox-compatible image strings; it does not assume local PNG files
-- can be rendered by Roblox ImageLabels.
local Assets = {}

local function normalize(source)
    if type(source) ~= "string" or source == "" then return nil end
    if source:match("^rbxassetid://") or source:match("^rbxthumb://") then
        return source
    end
    if source:match("^https?://") then
        -- Roblox ImageLabel generally cannot display arbitrary web URLs directly.
        -- Keep the URL as a source reference; caller must resolve/host it as a Roblox asset.
        return source
    end
    if source:match("^%d+$") then
        return "rbxassetid://" .. source
    end
    return nil
end

function Assets.Resolve(source)
    return normalize(source)
end

function Assets.Apply(imageLabel, source)
    if not imageLabel then return false, "ImageLabel is required" end
    local resolved = normalize(source)
    if not resolved then return false, "Unsupported image source" end
    if resolved:match("^https?://") then
        return false, "A plain web URL is not necessarily a Roblox image asset; use a Roblox asset ID or a supported image-loading method"
    end
    local ok, err = pcall(function() imageLabel.Image = resolved end)
    if not ok then return false, tostring(err) end
    return true
end

return Assets
