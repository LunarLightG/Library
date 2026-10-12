# LunarGui Library — Delta Android plan

This package keeps the supplied `LunarGui.lua` source as the core library and adds optional
helper modules. The core file is preserved rather than rewritten so its real API stays intact.

## Core API confirmed from the source

```lua
local LunarGui = loadstring(game:HttpGet("YOUR_RAW_GITHUB_URL"))()
local Window = LunarGui:CreateWindow({
    Name = "LUNAR HUB",
})

local Main = Window:AddTab("Main", "house")
Main:AddSection("General")
Main:AddButton({
    Name = "Example",
    Callback = function()
        print("Clicked")
    end,
})
Main:AddToggle({
    Name = "Example toggle",
    Flag = "ExampleToggle",
    Default = false,
    Callback = function(value)
        print("Toggle:", value)
    end,
})
```

Other confirmed public methods include:
- `Window:AddTab(name, icon)`, `Window:SelectTab(name)`
- `Tab:AddSection(text)`, `Tab:AddLabel(options)`, `Tab:AddButton(options)`
- `Tab:AddToggle(options)`, `Tab:AddSlider(options)`, `Tab:AddDropdown(options)`
- `Tab:AddImageBox(options)`, `Tab:AddTextbox(options)`
- `Window:SaveConfig(name)`, `Window:LoadConfig(name)`, `Window:ListConfigs()`
- `Window:Notify(text, good)`, `Window:Open()`, `Window:Close()`, `Window:Toggle()`
- `Window:Resize(w, h)`, `Window:SetThemeColor(color3OrHex)`, `Window:SetRainbow(on)`
- `Window:GetFlag(flag)`, `Window:SetFlag(flag, value)`, `Window:GetFlags()`
- `Window:SetFloatingVisible(visible)`, `Window:RefreshLayout()`, `Window:Destroy()`

## Optional modules

Modules are separate files for maintainability. They are not automatically imported by the core
library. Import them only through a loading mechanism supported by your environment. Some executor
environments do not support Roblox `require` for local files.

- `Modules/ConfigManager.lua`: wraps the core config methods and guarded delete/rename helpers.
- `Modules/Assets.lua`: validates Roblox asset references; warns when given arbitrary web URLs.
- `Modules/Remote.lua`: HTTPS fetch/compile/run helper. Only run remote code you trust and have reviewed.
- `Modules/Device.lua`: detects whether touch input is enabled.

## Delta Android limitations

- This package cannot verify which filesystem APIs are exposed by your installed Delta version.
- `SaveConfig`/`LoadConfig` only work when the required file APIs are available.
- Logo/background images stored as local PNG files are not automatically displayable by Roblox UI.
  Prefer a Roblox image asset ID or a verified Delta-supported image-loading API.
- Remote module loading needs network access and compatible `HttpGet`/`loadstring` support.
- Desktop-only keyboard controls may not be practical on a touch-only device.

## Suggested smoke test

1. Load the core library from a trusted raw GitHub URL.
2. Create a window and a tab with one harmless button and toggle.
3. Test `Window:SaveConfig("test")` and `Window:LoadConfig("test")`.
4. Test a Roblox image asset ID in an ImageLabel separately.
5. If a method returns false or errors, check the Delta API support instead of assuming success.

This project has not been runtime-tested inside Delta. The helper modules are optional and do not
claim to add unsupported executor APIs.
