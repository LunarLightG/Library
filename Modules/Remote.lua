-- LunarGui Remote helper
-- Loads only URLs explicitly supplied by the caller. Review remote source before running.
local Remote = {}

function Remote.Fetch(url)
    if type(url) ~= "string" or not url:match("^https://") then
        return nil, "Only HTTPS URLs are accepted"
    end
    if type(game) ~= "userdata" and type(game) ~= "table" then
        return nil, "Roblox game object unavailable"
    end
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(body) ~= "string" or body == "" then
        return nil, "HTTP request failed or returned an empty body"
    end
    return body
end

function Remote.Run(url)
    local source, fetchError = Remote.Fetch(url)
    if not source then return false, fetchError end
    if type(loadstring) ~= "function" then
        return false, "loadstring is unavailable in this environment"
    end
    local compileOk, chunk = pcall(loadstring, source)
    if not compileOk or type(chunk) ~= "function" then
        return false, "Remote source failed to compile"
    end
    local runOk, result = pcall(chunk)
    if not runOk then return false, tostring(result) end
    return true, result
end

return Remote
