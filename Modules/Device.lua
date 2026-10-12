-- LunarGui device helper: detects touch capability for layout decisions.
local Device = {}

function Device.IsTouchEnabled()
    local ok, result = pcall(function()
        return game:GetService("UserInputService").TouchEnabled
    end)
    return ok and result == true
end

function Device.GetClass()
    return Device.IsTouchEnabled() and "Touch" or "Desktop"
end

return Device
