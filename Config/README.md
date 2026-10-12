# Config storage

The original LunarGui library already provides `Window:SaveConfig(name)`,
`Window:LoadConfig(name)`, and `Window:ListConfigs()`. These rely on executor file APIs
inside the original library. Whether they work depends on the Delta version.

Config data is JSON and stores controls that were created with a usable `Flag`/Get/Set API.
Do not assume unsupported file operations work. Test save/load with a harmless setting first.
