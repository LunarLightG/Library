-- LunarGui ConfigManager
-- Uses the real public methods provided by LunarGui.lua.
-- Delta's file API availability varies by version; every operation is guarded.

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(window, options)
    assert(type(window) == "table", "ConfigManager: window is required")
    options = type(options) == "table" and options or {}

    return setmetatable({
        Window = window,
        Folder = tostring(options.Folder or "LUNAR_Configs"),
    }, ConfigManager)
end

local function safeName(name)
    name = tostring(name or ""):gsub("[^%w%-%_ ]", ""):gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then return nil end
    return name
end

function ConfigManager:Save(name)
    name = safeName(name)
    if not name then return false, "Invalid config name" end
    if type(self.Window.SaveConfig) ~= "function" then
        return false, "LunarGui SaveConfig API unavailable"
    end
    local ok, result = pcall(self.Window.SaveConfig, self.Window, name)
    if not ok or result == false then
        return false, "Save failed; Delta file API may be unavailable"
    end
    return true
end

function ConfigManager:Load(name)
    name = safeName(name)
    if not name then return false, "Invalid config name" end
    if type(self.Window.LoadConfig) ~= "function" then
        return false, "LunarGui LoadConfig API unavailable"
    end
    local ok, result = pcall(self.Window.LoadConfig, self.Window, name)
    if not ok or result == false then return false, "Load failed or config not found" end
    return true
end

function ConfigManager:List()
    if type(self.Window.ListConfigs) ~= "function" then
        return {}, "LunarGui ListConfigs API unavailable"
    end
    local ok, result = pcall(self.Window.ListConfigs, self.Window)
    if not ok or type(result) ~= "table" then return {}, "List failed" end
    return result
end

function ConfigManager:Delete(name)
    name = safeName(name)
    if not name then return false, "Invalid config name" end
    if type(isfile) ~= "function" or type(delfile) ~= "function" then
        return false, "This Delta version does not expose isfile/delfile"
    end
    local path = self.Folder .. "/" .. name .. ".json"
    local ok, exists = pcall(isfile, path)
    if not ok or not exists then return false, "Config not found or path differs" end
    local deleted = pcall(delfile, path)
    return deleted, deleted and nil or "Delete failed"
end

function ConfigManager:Rename(oldName, newName)
    oldName, newName = safeName(oldName), safeName(newName)
    if not oldName or not newName then return false, "Invalid config name" end
    if type(isfile) ~= "function" or type(readfile) ~= "function"
        or type(writefile) ~= "function" or type(delfile) ~= "function" then
        return false, "This Delta version lacks required file APIs"
    end
    local oldPath = self.Folder .. "/" .. oldName .. ".json"
    local newPath = self.Folder .. "/" .. newName .. ".json"
    local ok, content = pcall(function()
        assert(isfile(oldPath), "Config not found")
        assert(not isfile(newPath), "Target config already exists")
        return readfile(oldPath)
    end)
    if not ok then return false, tostring(content) end
    local wrote = pcall(writefile, newPath, content)
    if not wrote then return false, "Could not write renamed config" end
    local removed = pcall(delfile, oldPath)
    if not removed then return false, "New config saved but old config could not be removed" end
    return true
end

return ConfigManager
