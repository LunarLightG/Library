-- LUNAR HUB / LunarGui loader for Delta Android
local BASE = "https://raw.githubusercontent.com/LunarLightG/Library/main/"
local GUI_URL = BASE .. "LunarGui.lua"
local LOGO_URL = BASE .. "Assets/logo.png"
local BG_URL = BASE .. "Assets/background.png"

local function fetch(url)
    local ok, body = pcall(function()
        if type(request) == "function" then
            local r = request({Url = url, Method = "GET"})
            assert(r and r.Success and r.Body, "HTTP request failed")
            return r.Body
        end
        return game:HttpGet(url)
    end)
    if ok then return body end
    warn("[LunarGui] Download failed: " .. tostring(body))
    return nil
end

local function imageAsset(url, filename)
    if type(writefile) ~= "function" or type(getcustomasset) ~= "function" then
        warn("[LunarGui] Executor lacks writefile/getcustomasset; images may not display.")
        return nil
    end
    local body = fetch(url)
    if not body then return nil end
    local ok, asset = pcall(function()
        local folder = "LUNAR_HUB"
        if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder(folder) then
            makefolder(folder)
        end
        local path = folder .. "/" .. filename
        writefile(path, body)
        return getcustomasset(path)
    end)
    if ok then return asset end
    warn("[LunarGui] Could not register image asset: " .. tostring(asset))
    return nil
end

local source = fetch(GUI_URL)
assert(source, "Could not download LunarGui.lua")
local Library = assert(loadstring(source), "loadstring unavailable")()

local logo = imageAsset(LOGO_URL, "logo.png")
local background = imageAsset(BG_URL, "background.png")

local Window = Library:CreateWindow({
    Name = "LUNAR HUB",
    Tagline = "L U N A R   H U B",
    LogoImage = logo,
    BackgroundImage = background,
    BackgroundTransparency = 0.35,
    ConfigFolder = "LUNAR_Configs",
})

local Main = Window:AddTab("Main", "home")
local Settings = Window:AddTab("Settings", "settings")
local Credit = Window:AddTab("Credit", "info")

Main:AddSection("MAIN")
Main:AddLabel({Text = "LUNAR HUB is loaded"})
Settings:AddSection("SETTINGS")
Settings:AddLabel({Text = "Config support depends on executor file APIs."})
Credit:AddSection("CREDIT")
Credit:AddLabel({Text = "LunarLightG • LunarGui"})
Window:Open()
