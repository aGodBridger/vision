-- VisionWare Loader
-- Loads from local file or GitHub

local Loader = {}

-- Load from local file (requires readfile - Synapse, Script-Ware, etc.)
function Loader.LoadLocal()
    local content = readfile("C:/Users/lukas/Documents/Vision/gui.txt")
    return loadstring(content)()
end

-- Load from GitHub raw URL
function Loader.LoadFromGitHub()
    local url = "https://raw.githubusercontent.com/aGodBridger/vision/main/gui.txt"
    local content = game:HttpGet(url)
    return loadstring(content)()
end

-- Auto-detect best method
function Loader.Load()
    if readfile and isfile and isfile("C:/Users/lukas/Documents/Vision/gui.txt") then
        return Loader.LoadLocal()
    else
        return Loader.LoadFromGitHub()
    end
end

return Loader