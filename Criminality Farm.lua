local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local GuiService = game:GetService("GuiService")
local LogService = game:GetService("LogService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local CashPickupRemote = Events:WaitForChild("CZDPZUS")
local ClaimAllowanceRemote = Events:WaitForChild("CLMZALOW")
local ATMRemote = Events:WaitForChild("ATM")
local ShopRemote = Events:WaitForChild("SSHPRMTE1")
local MeleeRemote = Events:WaitForChild("XMHH.2")
local MeleeHitRemote = Events:FindFirstChild("XMHH2.2")
local ShopProtectionRemote = Events:FindFirstChild("BYZERSPROTEC")
local AutoPlayRemote = Events:FindFirstChild("BRBRBRRBLOOOL2")
local UpdateClientRemote = Events:FindFirstChild("UpdateClient")
local FallRemote = Events:FindFirstChild("__RZDONL")
local DropToolRemote = Events:FindFirstChild("PAZ_TA")

local LocalPlayer = Players.LocalPlayer
local UiParent = CoreGui

if type(gethui) == "function" then
    local ok, result = pcall(gethui)
    if ok and result then
        UiParent = result
    end
end
local Environment = getgenv and getgenv() or _G

local Config = {
    KeySystem = {
        ApiBase = "https://getjx.onrender.com",
        Service = "JX",
        Prefix = "JX_",
        ExpirationHours = 1,
        Keyless = false,
        SavedKeyFile = "JX/key.json",
        DiscordInvite = "https://discord.gg/getjxs"
    },
    Backend = {
        WebhookProxy = "https://jx3e.onrender.com/webhook/discord",
        TokenEndpoint = "https://jx3e.onrender.com/auth/token",
        RefreshEndpoint = "https://jx3e.onrender.com/auth/refresh",
        ApiKey = "sk_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p1"
    },
    Library = {
        Url = "https://raw.githubusercontent.com/jianlobiano/Serotonin-Library-Modified/refs/heads/main/Library.lua",
        Title = "JX | Criminality | FARM | Dsc.gg/getjxs",
        MobileButtonText = "JX"
    },
    Files = {
        Directory = "JX-CRIMINALITY-FARM",
        Configs = "JX-CRIMINALITY-FARM/Configs",
        Assets = "JX-CRIMINALITY-FARM/Assets",
        Settings = "JX_EarnMoney.txt",
        Device = "RBX/device.json"
    },
    Defaults = {
        AutoRespawn = true,
        AutoNotify = false,
        AutoPlay = false,
        AutoDeposit = false,
        AutoMoney = false,
        AutoAllowance = false,
        AntiAFK = false,
        AdminCheck = false,
        AntiFallDamage = false,
        HideBody = false,
        AutoDepositThresholdK = 5,
        BreakingMethod = "Crowbar",
        NotifyMinutes = 1,
        MoveSpeed = 32,
        PathMaxParamAttempts = 19,
        WaypointSpacing = 3,
        PickupDistance = 8,
        MoneySearchRadius = 42,
        MoneyCollectMaxPasses = 18,
        FarmTickSec = 0.2,
        FarmIdleWaitSec = 0.3,
        FarmRetryWaitSec = 1,
        FarmDeadWaitSec = 1.5,
        FarmBetweenTargetsSec = 0.5,
        RecoveryIdleSec = 8,
        ShopPreOpenSec = 0.75,
        ShopAfterOpenSec = 0.45,
        ShopBuyPollSec = 0.05,
        ShopBuyMaxWaitSec = 10,
        ShopPostBuySec = 1,
        IgnoreDuration = 6,
        DynamicRetargetEnabled = true,
        DebugPrintEnabled = false,
        AntiRejoin = true
    }
}

local Executor = {}
Executor.request = request or http_request or (syn and syn.request) or (http and http.request)
Executor.writeFile = writefile or (syn and syn.write_file)
Executor.readFile = readfile or (syn and syn.read_file)
Executor.isFile = isfile or (syn and syn.isfile)
Executor.isFolder = isfolder or (syn and syn.isfolder)
Executor.makeFolder = makefolder or (syn and syn.makefolder)
Executor.setClipboard = setclipboard or toclipboard or (syn and syn.set_clipboard)

local function safeCall(callback, ...)
    local result = table.pack(pcall(callback, ...))
    if not result[1] then
        return false, result[2]
    end
    return true, table.unpack(result, 2, result.n)
end

local function jsonEncode(value)
    local ok, result = safeCall(HttpService.JSONEncode, HttpService, value)
    return ok and result or nil
end

local function jsonDecode(value)
    local ok, result = safeCall(HttpService.JSONDecode, HttpService, value)
    return ok and result or nil
end

local function requestJson(options)
    if type(Executor.request) ~= "function" then
        return nil, "executor_request_missing"
    end
    local ok, response = safeCall(Executor.request, options)
    if not ok or type(response) ~= "table" then
        return nil, response or "request_failed"
    end
    local body = response.Body or response.body or ""
    local decoded = type(body) == "string" and jsonDecode(body) or body
    return {
        Success = response.Success == true or tonumber(response.StatusCode or response.Status) and tonumber(response.StatusCode or response.Status) >= 200 and tonumber(response.StatusCode or response.Status) < 300,
        StatusCode = tonumber(response.StatusCode or response.Status) or 0,
        Headers = response.Headers or response.headers or {},
        Body = body,
        Json = decoded
    }
end

local function ensureFolder(path)
    if type(Executor.makeFolder) ~= "function" or type(Executor.isFolder) ~= "function" then
        return false
    end
    local current = ""
    for segment in string.gmatch(path, "[^/]+") do
        current = current == "" and segment or current .. "/" .. segment
        if not Executor.isFolder(current) then
            safeCall(Executor.makeFolder, current)
        end
    end
    return true
end

ensureFolder(Config.Files.Directory)
ensureFolder(Config.Files.Configs)
ensureFolder(Config.Files.Assets)

local function writeText(path, content)
    if type(Executor.writeFile) ~= "function" then
        return false
    end
    local folder = string.match(path, "^(.*)/[^/]+$")
    if folder and folder ~= "" then
        ensureFolder(folder)
    end
    return safeCall(Executor.writeFile, path, content)
end

local function readText(path)
    if type(Executor.readFile) ~= "function" or type(Executor.isFile) ~= "function" then
        return nil
    end
    if not Executor.isFile(path) then
        return nil
    end
    local ok, content = safeCall(Executor.readFile, path)
    return ok and content or nil
end

local function notify(title, text, duration)
    safeCall(StarterGui.SetCore, StarterGui, "SendNotification", {
        Title = tostring(title),
        Text = tostring(text),
        Duration = tonumber(duration) or 5
    })
end

local function trim(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function parseCashTextToNumber(value)
    local text = tostring(value or ""):gsub("%s+", ""):upper()
    local multiplier = 1
    if text:sub(-1) == "K" then
        multiplier = 1000
        text = text:sub(1, -2)
    elseif text:sub(-1) == "M" then
        multiplier = 1000000
        text = text:sub(1, -2)
    elseif text:sub(-1) == "B" then
        multiplier = 1000000000
        text = text:sub(1, -2)
    end
    text = text:gsub("[^%d%.%-]", "")
    return math.floor((tonumber(text) or 0) * multiplier)
end

local function identifyExecutorName()
    if type(identifyexecutor) == "function" then
        local ok, name = safeCall(identifyexecutor)
        if ok and name then
            return tostring(name)
        end
    end
    if is_sirhurt_closure then
        return "SirHurt"
    end
    if KRNL_LOADED then
        return "Krnl"
    end
    if syn then
        return "Synapse X"
    end
    if pebc_execute then
        return "ProtoSmasher"
    end
    return "Unknown"
end

local function getDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Mobile"
    end
    return "PC"
end

local function getCharacter()
    return LocalPlayer.Character
end

local function getHumanoid(character)
    character = character or getCharacter()
    return character and character:FindFirstChildOfClass("Humanoid") or nil
end

local function getRoot(character)
    character = character or getCharacter()
    return character and character:FindFirstChild("HumanoidRootPart") or nil
end

local function isDead()
    local humanoid = getHumanoid()
    return not humanoid or humanoid.Health <= 0
end

local function findTextLabel(pathNames)
    local current = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    for _, name in ipairs(pathNames) do
        current = current and current:FindFirstChild(name)
    end
    if current and current:IsA("TextLabel") then
        return current
    end
    return nil
end

local function readCashAmountText()
    local candidates = {
        {"CoreGUI", "StatsFrame", "Frame2", "Frame", "Container", "Cash", "Amt"},
        {"CoreGUI", "StatsFrame", "Frame2", "Frame", "Container", "Cash"}
    }
    for _, path in ipairs(candidates) do
        local label = findTextLabel(path)
        if label then
            return trim(label.Text)
        end
    end
    return "0"
end

local function readBankAmountText()
    local candidates = {
        {"CoreGUI", "StatsFrame", "Frame2", "Frame", "Container", "Bank", "Amt"},
        {"CoreGUI", "StatsFrame", "Frame2", "Frame", "Container", "Bank"}
    }
    for _, path in ipairs(candidates) do
        local label = findTextLabel(path)
        if label then
            return trim(label.Text)
        end
    end
    return "0"
end

local function readAllowanceText()
    local candidates = {
        {"CoreGUI", "StatsFrame", "Frame2", "Frame", "Container", "Allowance", "Amt"},
        {"CoreGUI", "StatsFrame", "Frame2", "Frame", "Container", "Allowance"}
    }
    for _, path in ipairs(candidates) do
        local label = findTextLabel(path)
        if label then
            return trim(label.Text)
        end
    end
    return "Unknown"
end

local function readCashAmountValue()
    local data = LocalPlayer:FindFirstChild("PlayerbaseData2")
    local cash = data and data:FindFirstChild("Cash")
    if cash and tonumber(cash.Value) then
        return tonumber(cash.Value)
    end
    return parseCashTextToNumber(readCashAmountText())
end

local Device = {}

function Device.getHwid()
    local providers = {
        gethwid,
        get_hwid,
        syn and syn.gethwid
    }
    for _, provider in ipairs(providers) do
        if type(provider) == "function" then
            local ok, value = safeCall(provider)
            if ok and value and tostring(value) ~= "" then
                return tostring(value)
            end
        end
    end
    local existing = readText(Config.Files.Device)
    local decoded = existing and jsonDecode(existing)
    if type(decoded) == "table" and decoded.hwid then
        return tostring(decoded.hwid)
    end
    local generated = HttpService:GenerateGUID(false)
    writeText(Config.Files.Device, jsonEncode({hwid = generated}) or generated)
    return generated
end

function Device.getCountry()
    local response = requestJson({
        Url = "http://ip-api.com/json",
        Method = "GET"
    })
    if response and type(response.Json) == "table" then
        return tostring(response.Json.country or "Unknown")
    end
    return "Unknown"
end

local KeySystem = {
    Hwid = Device.getHwid(),
    RequestId = nil,
    Saved = nil
}

function KeySystem.fetchPublicConfig()
    local response = requestJson({
        Url = Config.KeySystem.ApiBase .. "/api/jx/public/config",
        Method = "GET",
        Headers = { ["Content-Type"] = "application/json" }
    })
    if response and response.Success and type(response.Json) == "table" then
        local settings = response.Json.settings or response.Json
        if settings.expirationHours then
            Config.KeySystem.ExpirationHours = tonumber(settings.expirationHours) or Config.KeySystem.ExpirationHours
        end
        if settings.keyless ~= nil then
            Config.KeySystem.Keyless = settings.keyless == true
        end
        return settings
    end
    return nil
end

function KeySystem.requestKey()
    local response, err = requestJson({
        Url = Config.KeySystem.ApiBase .. "/api/jx/keys/request",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonEncode({
            service = Config.KeySystem.Service,
            hwid = KeySystem.Hwid
        })
    })
    if not response or not response.Success then
        return false, err or response and response.Json or "request_failed"
    end
    local data = response.Json or {}
    KeySystem.RequestId = data.reqId or data.requestId or data.resId or data.id
    local url = data.checkpointUrl or data.url or data.link or data.keyUrl
    if url and type(Executor.setClipboard) == "function" then
        safeCall(Executor.setClipboard, tostring(url))
    end
    return true, data
end

function KeySystem.verifyKey(key)
    key = trim(key)
    if key == "" then
        return false, "Missing key"
    end
    local requestId = KeySystem.RequestId or HttpService:GenerateGUID(false)
    local response, err = requestJson({
        Url = Config.KeySystem.ApiBase .. "/api/jx/keys/verify",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonEncode({
            key = key,
            hwid = KeySystem.Hwid,
            reqId = requestId,
            service = Config.KeySystem.Service
        })
    })
    if not response or not response.Success then
        return false, err or response and response.Json or "verify_failed"
    end
    local data = response.Json or {}
    local valid = data.valid == true or data.ok == true or data._jx_valid_response == true
    if data.spoof_detected == true then
        return false, data.error or data.message or "HWID spoof detected"
    end
    if not valid then
        return false, data.error or data.message or "Invalid or expired key"
    end
    local expiresAt = tonumber(data.expiresAt) or os.time() + Config.KeySystem.ExpirationHours * 3600
    KeySystem.Saved = {
        key = key,
        hwid = KeySystem.Hwid,
        expiresAt = expiresAt,
        requestId = requestId,
        resId = data.resId,
        mode = data.mode
    }
    writeText(Config.KeySystem.SavedKeyFile, jsonEncode(KeySystem.Saved) or "")
    return true, data
end

function KeySystem.loadSavedKey()
    local content = readText(Config.KeySystem.SavedKeyFile)
    local saved = content and jsonDecode(content)
    if type(saved) ~= "table" or not saved.key then
        return nil
    end
    if saved.hwid and tostring(saved.hwid) ~= tostring(KeySystem.Hwid) then
        return nil
    end
    if tonumber(saved.expiresAt) and tonumber(saved.expiresAt) <= os.time() then
        return nil
    end
    KeySystem.Saved = saved
    return saved
end

local Auth = {
    Token = nil,
    ExpiresAt = 0
}

function Auth.requestToken()
    local response = requestJson({
        Url = Config.Backend.TokenEndpoint,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["X-API-Key"] = Config.Backend.ApiKey
        },
        Body = jsonEncode({
            userId = LocalPlayer.UserId,
            hwid = KeySystem.Hwid
        })
    })
    if response and response.Success and type(response.Json) == "table" and response.Json.token then
        Auth.Token = tostring(response.Json.token)
        Auth.ExpiresAt = os.time() + tonumber(response.Json.expiresIn or 300)
        return Auth.Token
    end
    return nil
end

function Auth.refreshToken()
    if not Auth.Token then
        return Auth.requestToken()
    end
    local response = requestJson({
        Url = Config.Backend.RefreshEndpoint,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. Auth.Token
        },
        Body = jsonEncode({token = Auth.Token})
    })
    if response and response.Success and type(response.Json) == "table" and response.Json.token then
        Auth.Token = tostring(response.Json.token)
        Auth.ExpiresAt = os.time() + tonumber(response.Json.expiresIn or 300)
        return Auth.Token
    end
    return Auth.requestToken()
end

function Auth.getToken()
    if not Auth.Token or os.time() >= Auth.ExpiresAt - 30 then
        return Auth.refreshToken()
    end
    return Auth.Token
end

local Settings = table.clone(Config.Defaults)
Settings.WebhookURL = ""
Settings.EarnMoneyTotal = 0

function Settings.save()
    local content = table.concat({
        "EarnMoney:" .. tostring(math.floor(Settings.EarnMoneyTotal)),
        "Webhook:" .. tostring(Settings.WebhookURL),
        "AutoRespawn:" .. tostring(Settings.AutoRespawn),
        "AutoNotify:" .. tostring(Settings.AutoNotify),
        "AutoPlay:" .. tostring(Settings.AutoPlay),
        "AutoDeposit:" .. tostring(Settings.AutoDeposit),
        "AutoMoney:" .. tostring(Settings.AutoMoney),
        "AutoAllowance:" .. tostring(Settings.AutoAllowance),
        "AntiAFK:" .. tostring(Settings.AntiAFK),
        "AdminCheck:" .. tostring(Settings.AdminCheck),
        "AntiFallDamage:" .. tostring(Settings.AntiFallDamage),
        "HideBody:" .. tostring(Settings.HideBody),
        "AutoDepositThresholdK:" .. tostring(Settings.AutoDepositThresholdK),
        "BreakingMethod:" .. tostring(Settings.BreakingMethod),
        "NotifyMinutes:" .. tostring(math.floor(math.clamp(tonumber(Settings.NotifyMinutes) or 1, 1, 10))),
        "MoveSpeed:" .. tostring(Settings.MoveSpeed),
        "AntiRejoin:" .. tostring(Settings.AntiRejoin)
    }, "\n")
    return writeText(Config.Files.Settings, content)
end

function Settings.load()
    local content = readText(Config.Files.Settings)
    if not content then
        return false
    end
    local booleanKeys = {
        AutoRespawn = true,
        AutoNotify = true,
        AutoPlay = true,
        AutoDeposit = true,
        AutoMoney = true,
        AutoAllowance = true,
        AntiAFK = true,
        AdminCheck = true,
        AntiFallDamage = true,
        HideBody = true,
        AntiRejoin = true
    }
    for line in string.gmatch(content, "[^\r\n]+") do
        local key, value = line:match("^([^:]+):(.*)$")
        if key == "EarnMoney" then
            Settings.EarnMoneyTotal = tonumber(value) or Settings.EarnMoneyTotal
        elseif key == "Webhook" then
            Settings.WebhookURL = trim(value)
        elseif booleanKeys[key] then
            Settings[key] = string.lower(trim(value)) == "true"
        elseif key == "AutoDepositThresholdK" then
            Settings.AutoDepositThresholdK = math.clamp(tonumber(value) or Settings.AutoDepositThresholdK, 1, 100)
        elseif key == "BreakingMethod" and (value == "Crowbar" or value == "Fist + Lockpick") then
            Settings.BreakingMethod = value
        elseif key == "NotifyMinutes" then
            Settings.NotifyMinutes = math.floor(math.clamp(tonumber(value) or Settings.NotifyMinutes, 1, 10))
        elseif key == "MoveSpeed" then
            Settings.MoveSpeed = math.clamp(tonumber(value) or Settings.MoveSpeed, 10, 45)
        end
    end
    return true
end

local function syncEnvironmentSettings()
    Environment.JXFarmNotifyTimeMinutes = Settings.NotifyMinutes
    Environment.JXFarmAutoRespawn = Settings.AutoRespawn
    Environment.JXFarmAutoNotify = Settings.AutoNotify
    Environment.JXFarmAutoPlay = Settings.AutoPlay
    Environment.JXFarmAutoDeposit = Settings.AutoDeposit
    Environment.JXFarmAutoMoney = Settings.AutoMoney
    Environment.JXFarmAutoAllowance = Settings.AutoAllowance
    Environment.JXFarmAntiAfk = Settings.AntiAFK
    Environment.JXFarmAdminCheck = Settings.AdminCheck
    Environment.JXFarmAntiFallDamage = Settings.AntiFallDamage
    Environment.JXFarmInvis = Settings.HideBody
    Environment.JXFarmAutoDepositThresholdK = Settings.AutoDepositThresholdK
    Environment.JXFarmBreakingMethod = Settings.BreakingMethod
    Environment.JXFarmSpeedV2 = Settings.MoveSpeed
    Environment.JXFarmWebhookURL = Settings.WebhookURL
    Environment.JXFarmAntiRejoin = Settings.AntiRejoin
    Environment.CV2_NoFall = Settings.AntiFallDamage
end

local Webhook = {}

function Webhook.send(title, description, fields)
    if trim(Settings.WebhookURL) == "" then
        return false
    end
    local token = Auth.getToken()
    local gameName = "Unknown Game"
    local ok, info = safeCall(MarketplaceService.GetProductInfo, MarketplaceService, game.PlaceId)
    if ok and type(info) == "table" and info.Name then
        gameName = tostring(info.Name)
    end
    local payload = {
        url = Settings.WebhookURL,
        username = "JX-Bot",
        avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png",
        embeds = {{
            title = title or "Script Executed",
            description = description or "JX-EXECUTED",
            color = 16711680,
            thumbnail = {url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(LocalPlayer.UserId) .. "&width=420&height=420&format=png"},
            fields = fields or {
                {name = "Username", value = LocalPlayer.Name, inline = true},
                {name = "User ID", value = tostring(LocalPlayer.UserId), inline = true},
                {name = "Account Age", value = tostring(LocalPlayer.AccountAge), inline = true},
                {name = "Game", value = gameName, inline = true},
                {name = "Place ID", value = tostring(game.PlaceId), inline = true},
                {name = "Job ID", value = tostring(game.JobId), inline = false},
                {name = "Executor", value = identifyExecutorName(), inline = true},
                {name = "Device", value = getDeviceType(), inline = true},
                {name = "Country", value = Device.getCountry(), inline = true}
            },
            footer = {text = "JX-EXECUTED"},
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local headers = { ["Content-Type"] = "application/json" }
    if token then
        headers.Authorization = "Bearer " .. token
    end
    local response = requestJson({
        Url = Config.Backend.WebhookProxy,
        Method = "POST",
        Headers = headers,
        Body = jsonEncode(payload)
    })
    return response and response.Success or false
end

local Farm = {
    Enabled = false,
    UserWantsFarm = false,
    Busy = false,
    Status = "Idle",
    DiedCount = 0,
    EarnMoneyTotal = Settings.EarnMoneyTotal,
    StartCash = 0,
    StartedAt = 0,
    LastNotifyAt = 0,
    LastDiedIncrementAt = 0,
    LastRejoinAt = 0,
    ProcessedList = {},
    SortedTargets = {},
    TempIgnoredTargets = {},
    ForcedNextTargetModel = nil,
    RetargetPending = false,
    CashAddedConnection = nil,
    CashAddedTextConnection = nil,
    LastCashAddedText = "",
    TargetConnections = {},
    DiedConnection = nil,
    RenderConnection = nil,
    AdminConnections = {},
    UI = {},
    State = {
        InProgress = false,
        CooldownUntil = 0,
        LastAttemptAt = 0,
        IsRising = false,
        HasReachedTargetY = false,
        SUZoneEntered = false,
        TowerZoneEntered = false,
        SW11ZoneEntered = false,
        CurrentZoneRoute = nil,
        SW11SavedEntryPathPoint = nil,
        SW11SavedVisualPath = nil,
        TowerFirstPosition = Vector3.new(-4520, 127, -783),
        TowerSecondPosition = Vector3.new(-4518, 149, -780),
        SW11FirstPosition = Vector3.new(-4693, -32, -717),
        SW11SecondPosition = Vector3.new(-4693, -44, -731),
        SW11ThirdPosition = Vector3.new(-4693, -32, -743),
        SUFirstPosition = Vector3.new(-3897, 4, -456),
        RecoveryLoopFixFrom = Vector3.new(-4475, -22, -363),
        RecoveryLoopFixTo = Vector3.new(-4481, 4, -362),
        TargetY = 4.8,
        LastTimeTick = 0,
        LastActiveAt = 0,
        LastMoveAt = 0,
        LastFistsRecoveryAt = 0,
        FistsRecoveryBusy = false,
        RetryCount = 0,
        LastShopMainPart = nil
    }
}

local TargetNames = {
    "MediumSafe_T_45",
    "MediumSafe_T_46",
    "MediumSafe_SEW_2",
    "MediumSafe_SEW_8",
    "MediumSafe_HO_24",
    "MediumSafe_HO_39",
    "MediumSafe_TS_20",
    "MediumSafe_VC_21",
    "MediumSafe_VC_30",
    "MediumSafe_VC_38",
    "SmallSafe_SW_11",
    "Register_HO_23",
    "Register_TS_27",
    "Register_TS_4"
}

local TargetPositions = {
    MediumSafe_SEW_2 = Vector3.new(-4312.640625, -93.04354095459, -813.551086425781),
    MediumSafe_T_46 = Vector3.new(-4513.88330078125, 153.078231811523, -805.10205078125),
    MediumSafe_VC_30 = Vector3.new(-4855.64794921875, -199.84228515625, -868.460571289062),
    SmallSafe_SW_11 = Vector3.new(-4683.93310546875, -32.621650695801, -832.013366699219),
    MediumSafe_HO_39 = Vector3.new(-4421.9951171875, 25.813669204712, -53.739181518555),
    MediumSafe_T_45 = Vector3.new(-4514.361328125, 153.078231811523, -859.273742675781),
    Register_HO_23 = Vector3.new(-4429.865234375, 25.892944335938, -41.588287353516),
    MediumSafe_HO_24 = Vector3.new(-4826.80078125, -77.030784606934, -189.607925415039),
    MediumSafe_TS_20 = Vector3.new(-4704.6767578125, 5.222457885742, -171.515075683594),
    Register_TS_27 = Vector3.new(-4676.37890625, 5.208802700043, -150.077056884766),
    Register_TS_4 = Vector3.new(-4676.37890625, 5.208802700043, -146.077056884766),
    MediumSafe_VC_38 = Vector3.new(-4749.26220703125, -199.84228515625, -972.707702636719),
    MediumSafe_VC_21 = Vector3.new(-4804.431640625, -199.84228515625, -972.726379394531),
    MediumSafe_SEW_8 = Vector3.new(-4711.03271484375, -149.143432617188, -868.823913574219)
}

local TargetNameSet = {}
for _, name in ipairs(TargetNames) do
    TargetNameSet[name] = true
end

local SUTargetNames = {
    MediumSafe_VC_21 = true,
    MediumSafe_VC_30 = true,
    MediumSafe_VC_38 = true,
    MediumSafe_SEW_2 = true,
    MediumSafe_SEW_8 = true,
    MediumSafe_HO_24 = true
}

local TowerTargetNames = {
    MediumSafe_T_45 = true,
    MediumSafe_T_46 = true
}

local SW11TargetNames = {
    SmallSafe_SW_11 = true
}

local ZoneRoutes = {
    MediumSafe_HO_39 = {
        zone = "HO",
        lowPos = Vector3.new(-4450, 4, -44),
        highPos = Vector3.new(-4448, 25, -48)
    },
    Register_HO_23 = {
        zone = "HO",
        lowPos = Vector3.new(-4450, 4, -44),
        highPos = Vector3.new(-4448, 25, -48)
    },
    MediumSafe_TS_20 = {
        zone = "TS",
        lowPos = Vector3.new(-4602, 4, -153),
        highPos = Vector3.new(-4609, 4, -153)
    },
    Register_TS_27 = {
        zone = "TS",
        lowPos = Vector3.new(-4602, 4, -153),
        highPos = Vector3.new(-4609, 4, -153)
    },
    Register_TS_4 = {
        zone = "TS",
        lowPos = Vector3.new(-4602, 4, -153),
        highPos = Vector3.new(-4609, 4, -153)
    }
}

Environment.JXFarmTargetPositions = TargetPositions

local function setUiText(control, text)
    if not control then
        return
    end
    if typeof(control) == "Instance" then
        control.Text = text
        return
    end
    if type(control) == "table" then
        if type(control.Set) == "function" then
            control:Set(text)
            return
        end
        if type(control.Update) == "function" then
            control:Update(text)
            return
        end
        if type(control.SetText) == "function" then
            control:SetText(text)
            return
        end
        local object = rawget(control, "Label") or rawget(control, "TextLabel") or rawget(control, "Instance")
        if typeof(object) == "Instance" and object:IsA("TextLabel") then
            object.Text = text
        end
    end
end

local function setStatus(value)
    Farm.Status = tostring(value)
    Environment.JXFarmActivity = Farm.Status
    if Farm.UI.Status then
        setUiText(Farm.UI.Status, "Status: " .. Farm.Status)
    end
end

local function isTargetBroken(model)
    local values = model and model:FindFirstChild("Values")
    local broken = values and values:FindFirstChild("Broken")
    return broken and broken:IsA("BoolValue") and broken.Value == true
end

local function getTargetPart(model)
    if not model then
        return nil
    end
    if model:IsA("BasePart") then
        return model
    end
    local mainPart = model:FindFirstChild("MainPart")
    return mainPart and mainPart:IsA("BasePart") and mainPart or nil
end

local function isSafeTarget(model)
    return model ~= nil and TargetNameSet[model.Name] == true
end

local function getMap()
    return Workspace:FindFirstChild("Map")
end

local function cleanIgnoredTargets()
    local now = tick()
    for target, expiresAt in pairs(Farm.TempIgnoredTargets) do
        if not target.Parent or expiresAt <= now then
            Farm.TempIgnoredTargets[target] = nil
        end
    end
end

local function rebuildTargets()
    local root = getRoot()
    local map = getMap()
    local targetFolder = map and map:FindFirstChild("BredMakurz")
    local targets = {}
    if not root or not targetFolder then
        Farm.SortedTargets = targets
        return targets
    end
    cleanIgnoredTargets()
    for _, object in ipairs(targetFolder:GetChildren()) do
        if object:IsA("Model") and TargetNameSet[object.Name] and not isTargetBroken(object) and not Farm.TempIgnoredTargets[object] then
            local part = object:FindFirstChild("MainPart")
            if part and part:IsA("BasePart") then
                table.insert(targets, {
                    obj = object,
                    part = part,
                    distance = (part.Position - root.Position).Magnitude
                })
            end
        end
    end
    table.sort(targets, function(left, right)
        return left.distance < right.distance
    end)
    Farm.SortedTargets = targets
    return targets
end

local function chooseTarget()
    if Farm.ForcedNextTargetModel and Farm.ForcedNextTargetModel.Parent and not isTargetBroken(Farm.ForcedNextTargetModel) then
        local model = Farm.ForcedNextTargetModel
        Farm.ForcedNextTargetModel = nil
        return model, getTargetPart(model)
    end
    for _, target in ipairs(rebuildTargets()) do
        if target.obj.Parent and target.part.Parent and not Farm.ProcessedList[target.obj] then
            return target.obj, target.part
        end
    end
    Farm.ProcessedList = {}
    for _, target in ipairs(rebuildTargets()) do
        if target.obj.Parent and target.part.Parent then
            return target.obj, target.part
        end
    end
    return nil, nil
end

local function createHighlight(model)
    if not model or model:FindFirstChild("ESP_Highlight") then
        return
    end
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = model
    highlight.FillColor = Color3.new(1, 0, 0)
    highlight.FillTransparency = 0.55
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    highlight.Parent = model
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Billboard"
    billboard.Adornee = getTargetPart(model)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 5000
    billboard.Size = UDim2.new(0, 180, 0, 32)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = model
    local label = Instance.new("TextLabel")
    label.Name = "BredMakurz"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.new(0, 0, 0)
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Text = model.Name
    label.Parent = billboard
end

local function refreshESP()
    local map = getMap()
    local targetFolder = map and map:FindFirstChild("BredMakurz")
    if not targetFolder then
        return
    end
    for _, object in ipairs(targetFolder:GetChildren()) do
        if object:IsA("Model") and isSafeTarget(object) then
            if isTargetBroken(object) then
                local highlight = object:FindFirstChild("ESP_Highlight")
                local billboard = object:FindFirstChild("ESP_Billboard")
                if highlight then
                    highlight:Destroy()
                end
                if billboard then
                    billboard:Destroy()
                end
            else
                createHighlight(object)
            end
        end
    end
end

local function disconnectTargetConnections()
    for object, connection in pairs(Farm.TargetConnections) do
        if connection then
            connection:Disconnect()
        end
        Farm.TargetConnections[object] = nil
    end
end

local function bindTargetModel(model)
    if not model or not model:IsA("Model") or not isSafeTarget(model) or Farm.TargetConnections[model] then
        return
    end
    local values = model:FindFirstChild("Values")
    local broken = values and values:FindFirstChild("Broken")
    if broken and broken:IsA("BoolValue") then
        Farm.TargetConnections[model] = broken:GetPropertyChangedSignal("Value"):Connect(function()
            Farm.ProcessedList[model] = nil
            Farm.RetargetPending = true
            task.defer(refreshESP)
        end)
    end
end

local function bindTargetTracking()
    disconnectTargetConnections()
    local map = getMap()
    local targetFolder = map and map:FindFirstChild("BredMakurz")
    if not targetFolder then
        return
    end
    for _, object in ipairs(targetFolder:GetChildren()) do
        bindTargetModel(object)
    end
    Farm.TargetConnections.TargetAdded = targetFolder.ChildAdded:Connect(function(object)
        task.defer(function()
            bindTargetModel(object)
            if object:IsA("Model") and isSafeTarget(object) then
                refreshESP()
            end
        end)
    end)
    Farm.TargetConnections.TargetRemoving = targetFolder.ChildRemoved:Connect(function(object)
        local connection = Farm.TargetConnections[object]
        if connection then
            connection:Disconnect()
            Farm.TargetConnections[object] = nil
        end
        Farm.ProcessedList[object] = nil
        Farm.TempIgnoredTargets[object] = nil
    end)
end

local function computePath(destination)
    local root = getRoot()
    local humanoid = getHumanoid()
    if not root or not humanoid then
        return nil
    end
    local path = PathfindingService:CreatePath({
        AgentRadius = math.max(2, root.Size.X * 0.5),
        AgentHeight = math.max(5, humanoid.HipHeight + root.Size.Y + 2),
        AgentCanJump = true,
        AgentCanClimb = true,
        WaypointSpacing = tonumber(Settings.WaypointSpacing) or 3,
        Costs = {}
    })
    local ok = safeCall(path.ComputeAsync, path, root.Position, destination)
    if not ok or path.Status ~= Enum.PathStatus.Success then
        return nil
    end
    return path:GetWaypoints()
end

local function facePosition(position)
    local root = getRoot()
    if root then
        local flat = Vector3.new(position.X, root.Position.Y, position.Z)
        if (flat - root.Position).Magnitude > 0.01 then
            root.CFrame = CFrame.lookAt(root.Position, flat)
        end
    end
end

local function moveToPosition(position, statusText)
    local root = getRoot()
    local humanoid = getHumanoid()
    if not root or not humanoid or isDead() then
        return false
    end
    setStatus(statusText or "Moving To Target")
    Environment.JXFarmMove = true
    local waypoints = computePath(position)
    if not waypoints then
        waypoints = {{Position = position, Action = Enum.PathWaypointAction.Walk}}
    end
    for _, waypoint in ipairs(waypoints) do
        if not Farm.Enabled or isDead() then
            Environment.JXFarmMove = false
            return false
        end
        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end
        local distance = (root.Position - waypoint.Position).Magnitude
        local duration = math.max(distance / math.max(Settings.MoveSpeed, 1), 0.05)
        local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            CFrame = CFrame.new(waypoint.Position, waypoint.Position + root.CFrame.LookVector)
        })
        tween:Play()
        local startedAt = tick()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if not Farm.Enabled or isDead() or tick() - startedAt > duration + 3 then
                tween:Cancel()
                Environment.JXFarmMove = false
                return false
            end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            task.wait()
        end
    end
    Environment.JXFarmMove = false
    return (root.Position - position).Magnitude <= 12
end

local function moveRoute(positions, statusText)
    for _, position in ipairs(positions) do
        if not moveToPosition(position, statusText) then
            return false
        end
    end
    return true
end

local function enterTower(model, part)
    Farm.State.TowerZoneEntered = true
    return moveRoute({
        Farm.State.TowerFirstPosition,
        Farm.State.TowerSecondPosition,
        part.Position
    }, "Moving To Target")
end

local function leaveTower()
    if not Farm.State.TowerZoneEntered then
        return true
    end
    setStatus("Leaving Tower")
    local moved = moveRoute({
        Farm.State.TowerSecondPosition,
        Farm.State.TowerFirstPosition
    }, "Leaving Tower")
    Farm.State.TowerZoneEntered = false
    setStatus("Idle")
    return moved
end

local function enterSW11(model, part)
    Farm.State.SW11ZoneEntered = true
    local root = getRoot()
    Farm.State.SW11SavedEntryPathPoint = root and root.Position or nil
    Farm.State.SW11SavedVisualPath = {
        Farm.State.SW11FirstPosition,
        Farm.State.SW11SecondPosition,
        Farm.State.SW11ThirdPosition
    }
    setStatus("Entering SW_11")
    return moveRoute({
        Farm.State.SW11FirstPosition,
        Farm.State.SW11SecondPosition,
        Farm.State.SW11ThirdPosition,
        part.Position
    }, "Entering SW_11")
end

local function leaveSW11()
    if not Farm.State.SW11ZoneEntered then
        return true
    end
    setStatus("Leaving SW_11")
    local moved = moveRoute({
        Farm.State.SW11ThirdPosition,
        Farm.State.SW11SecondPosition,
        Farm.State.SW11FirstPosition
    }, "Leaving SW_11")
    if moved and Farm.State.SW11SavedEntryPathPoint then
        moved = moveToPosition(Farm.State.SW11SavedEntryPathPoint, "Leaving SW_11")
    end
    Farm.State.SW11ZoneEntered = false
    Farm.State.SW11SavedEntryPathPoint = nil
    Farm.State.SW11SavedVisualPath = nil
    setStatus("Idle")
    return moved
end

local function enterZoneRoute(model, part)
    local route = ZoneRoutes[model.Name]
    if not route then
        return false
    end
    Farm.State.CurrentZoneRoute = route
    return moveRoute({route.lowPos, route.highPos, part.Position}, "Moving To Target")
end

local function leaveZoneRoute()
    local route = Farm.State.CurrentZoneRoute
    if not route then
        return true
    end
    local moved = moveRoute({route.highPos, route.lowPos}, "Leaving " .. route.zone)
    Farm.State.CurrentZoneRoute = nil
    return moved
end

local function enterSURoute(model, part)
    Farm.State.SUZoneEntered = true
    return moveRoute({Farm.State.SUFirstPosition, part.Position}, "Moving To Target")
end

local function leaveSURoute()
    if not Farm.State.SUZoneEntered then
        return true
    end
    local moved = moveToPosition(Farm.State.SUFirstPosition, "Leaving SU")
    Farm.State.SUZoneEntered = false
    return moved
end

local function moveToTargetByRoute(model, part)
    if SW11TargetNames[model.Name] then
        return enterSW11(model, part)
    end
    if TowerTargetNames[model.Name] then
        return enterTower(model, part)
    end
    if ZoneRoutes[model.Name] then
        return enterZoneRoute(model, part)
    end
    if SUTargetNames[model.Name] then
        return enterSURoute(model, part)
    end
    return moveToPosition(part.Position, "Moving To Target")
end

local function teleportRecovery(position)
    local root = getRoot()
    if not root or not position then
        return false
    end
    setStatus("Teleport Recovery")
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(position)
    task.wait(Settings.RecoveryIdleSec)
    return (root.Position - position).Magnitude <= 6
end

local function runRecoveryLoopFix()
    return moveRoute({
        Farm.State.RecoveryLoopFixFrom,
        Farm.State.RecoveryLoopFixTo
    }, "Recovery Move")
end

local function recoveryMove(position)
    local root = getRoot()
    if not root or not position then
        return false
    end
    setStatus("Recovery Move")
    if moveToPosition(position, "Recovering Path") then
        return true
    end
    if runRecoveryLoopFix() and moveToPosition(position, "Recovering Path") then
        return true
    end
    return teleportRecovery(position)
end

local function handlePostMoveSuccess(model)
    Farm.State.RetryCount = 0
    Farm.State.LastActiveAt = tick()
    Farm.State.HasReachedTargetY = true
    Farm.State.TargetY = getTargetPart(model) and getTargetPart(model).Position.Y or nil
    return true
end

local function handlePostMoveFailure(model, part)
    Farm.State.RetryCount += 1
    Farm.State.HasReachedTargetY = false
    if Farm.State.RetryCount <= 2 and part and recoveryMove(part.Position) then
        return true
    end
    Farm.TempIgnoredTargets[model] = tick() + math.max(1, tonumber(Settings.IgnoreDuration) or 6)
    Farm.RetargetPending = true
    return false
end

local function processTargetMoveOutcome(model, part, moved)
    if moved then
        return handlePostMoveSuccess(model)
    end
    return handlePostMoveFailure(model, part)
end

local function getTool(namePattern)
    local character = getCharacter()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({character, backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and string.find(string.lower(tool.Name), string.lower(namePattern), 1, true) then
                    return tool
                end
            end
        end
    end
    return nil
end

local function equipTool(tool)
    local humanoid = getHumanoid()
    if humanoid and tool then
        safeCall(humanoid.EquipTool, humanoid, tool)
        task.wait(0.1)
        return tool.Parent == getCharacter()
    end
    return false
end

local function unequipTools()
    local humanoid = getHumanoid()
    if humanoid then
        safeCall(humanoid.UnequipTools, humanoid)
    end
end

local function hasFistsTool()
    return getTool("fists") ~= nil
end

local ShopItemContracts = {
    Crowbar = {
        ShopType = "IllegalStore",
        Category = "Melees",
        ShopModelName = "Dealer"
    },
    Lockpick = {
        ShopType = "LegalStore",
        Category = "Misc",
        ShopModelName = "ArmoryDealer"
    }
}

local function getShopMainPart(contract)
    local map = getMap()
    local shops = map and map:FindFirstChild("Shopz")
    local shop = shops and shops:FindFirstChild(contract.ShopModelName)
    local mainPart = shop and shop:FindFirstChild("MainPart")
    return mainPart and mainPart:IsA("BasePart") and mainPart or nil
end

local function buyItem(itemName)
    local contract = ShopItemContracts[itemName]
    if not contract then
        return false
    end
    local shopMainPart = getShopMainPart(contract)
    if not shopMainPart then
        return false
    end
    if not moveToPosition(shopMainPart.Position, "Moving To Dealer for " .. itemName) then
        return false
    end
    task.wait(Settings.ShopPreOpenSec)
    setStatus(itemName == "Lockpick" and "Buying Lockpicks (idle 5s in shop)" or "Buying " .. itemName)
    if ShopProtectionRemote then
        safeCall(
            ShopProtectionRemote.FireServer,
            ShopProtectionRemote,
            true,
            "shop",
            shopMainPart,
            contract.ShopType
        )
    end
    local ok, success = safeCall(
        ShopRemote.InvokeServer,
        ShopRemote,
        contract.ShopType,
        contract.Category,
        itemName,
        shopMainPart,
        nil,
        true
    )
    if ShopProtectionRemote then
        safeCall(ShopProtectionRemote.FireServer, ShopProtectionRemote, false)
    end
    task.wait(Settings.ShopAfterOpenSec)
    if not ok or not success then
        return false
    end
    local startedAt = tick()
    while tick() - startedAt < Settings.ShopBuyMaxWaitSec do
        if getTool(itemName) then
            task.wait(Settings.ShopPostBuySec)
            return true
        end
        task.wait(Settings.ShopBuyPollSec)
    end
    return false
end

local function ensureBreakingTools()
    if Settings.BreakingMethod == "Fist + Lockpick" then
        if not hasFistsTool() then
            return false
        end
        local lockpick = getTool("lockpick")
        if not lockpick then
            setStatus("Moving To Dealer for Lockpick")
            if not buyItem("Lockpick") then
                return false
            end
        end
        return true
    end
    local crowbar = getTool("crowbar")
    if not crowbar then
        setStatus("Buying Crowbar")
        if not buyItem("Crowbar") then
            return false
        end
    end
    return true
end

local function countToolsByName(name)
    local total = 0
    local character = getCharacter()
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({character, backpack}) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and item.Name == name then
                    total += 1
                end
            end
        end
    end
    return total
end

local function findNearestLockpickShopPart()
    local root = getRoot()
    local selected
    local selectedDistance = math.huge
    for _, contract in ipairs({
        ShopItemContracts.Lockpick,
        ShopItemContracts.Crowbar
    }) do
        local part = getShopMainPart(contract)
        if part then
            local distance = root and (part.Position - root.Position).Magnitude or 0
            if distance < selectedDistance then
                selected = part
                selectedDistance = distance
            end
        end
    end
    return selected
end

local function purchaseLockpickAt(shopPart)
    if not shopPart then
        return false
    end
    local illegalOk, illegalAccepted, illegalMessage = safeCall(
        ShopRemote.InvokeServer,
        ShopRemote,
        "IllegalStore",
        "Misc",
        "Lockpick",
        shopPart,
        nil,
        true,
        nil
    )
    task.wait(0.25)
    local legalOk, legalAccepted, legalMessage = safeCall(
        ShopRemote.InvokeServer,
        ShopRemote,
        "LegalStore",
        "Misc",
        "Lockpick",
        shopPart,
        nil,
        true
    )
    return illegalOk
        and (illegalAccepted == true or illegalMessage == "PURCHASE COMPLETE")
        or legalOk
        and (legalAccepted == true or legalMessage == "PURCHASE COMPLETE")
end

local function buyLockpickBatch(quantity)
    quantity = math.max(1, math.floor(tonumber(quantity) or 7))
    local shopPart = findNearestLockpickShopPart()
    if not shopPart then
        return false
    end
    if not moveToPosition(shopPart.Position, "Moving To Dealer for Lockpick") then
        return false
    end
    local startingCount = countToolsByName("Lockpick")
    local successfulPurchases = 0
    for _ = 1, quantity do
        if not Farm.Enabled then
            break
        end
        if purchaseLockpickAt(shopPart) then
            successfulPurchases += 1
        end
        task.wait(0.20)
    end
    task.wait(0.75)
    return countToolsByName("Lockpick") > startingCount or successfulPurchases > 0
end

local function dropLockpick(tool)
    local root = getRoot()
    if not tool or not DropToolRemote or not root then
        return false
    end
    local ok = safeCall(
        DropToolRemote.FireServer,
        DropToolRemote,
        tool,
        nil,
        root.Position
    )
    return ok
end

local function tryLockpickTarget(target)
    local tool = getTool("Lockpick")
    if not tool then
        return false, "lockpick_missing"
    end
    if not equipTool(tool) then
        return false, "lockpick_equip_failed"
    end
    local remote = tool:FindFirstChild("Remote")
    if not remote or not remote:IsA("RemoteFunction") then
        return false, "lockpick_remote_missing"
    end
    local startOk, token = safeCall(
        remote.InvokeServer,
        remote,
        "S",
        target,
        "s"
    )
    if startOk and type(token) == "number" then
        task.wait(0.25)
        local finishOk = safeCall(
            remote.InvokeServer,
            remote,
            "D",
            target,
            "s",
            token
        )
        return finishOk, finishOk and "lockpick_success" or "lockpick_finish_failed"
    end
    dropLockpick(tool)
    return false, "lockpick_failed"
end

local function strikeTargetWithCrowbar(target)
    local tool = getTool("Crowbar")
    local character = getCharacter()
    local targetPart = getTargetPart(target)
    local rightArm = character and (
        character:FindFirstChild("Right Arm")
        or character:FindFirstChild("RightHand")
    )
    if not MeleeRemote
        or not MeleeHitRemote
        or not tool
        or not character
        or not rightArm
        or not targetPart
    then
        return false
    end
    equipTool(tool)
    local invokeOk, token = safeCall(
        MeleeRemote.InvokeServer,
        MeleeRemote,
        "🍞",
        tick(),
        tool,
        "DZDRRRKI",
        target,
        "Register"
    )
    if invokeOk and type(token) == "number" then
        local fireOk = safeCall(
            MeleeHitRemote.FireServer,
            MeleeHitRemote,
            "🍞",
            tick(),
            tool,
            "2389ZFX34",
            token,
            false,
            rightArm,
            targetPart,
            target,
            targetPart.Position,
            targetPart.Position
        )
        return fireOk
    end
    return invokeOk
end

local function breakTarget(target, targetPart)
    if not target or not target.Parent then
        return false
    end
    if isTargetBroken(target) then
        return true
    end
    if Settings.BreakingMethod == "Crowbar" then
        if not getTool("Crowbar") and not buyItem("Crowbar") then
            return false
        end
        local startedAt = tick()
        while Farm.Enabled
            and target.Parent
            and not isTargetBroken(target)
            and tick() - startedAt < 30
        do
            targetPart = getTargetPart(target)
            local root = getRoot()
            if not targetPart or not root then
                return false
            end
            if (targetPart.Position - root.Position).Magnitude > 8 then
                if not moveToTargetByRoute(target, targetPart) then
                    return false
                end
            end
            strikeTargetWithCrowbar(target)
            task.wait(0.25)
        end
    else
        local startedAt = tick()
        local nextBatchSize = 7
        while Farm.Enabled
            and target.Parent
            and not isTargetBroken(target)
            and tick() - startedAt < 120
        do
            targetPart = getTargetPart(target)
            local root = getRoot()
            if not targetPart or not root then
                return false
            end
            if (targetPart.Position - root.Position).Magnitude > 8 then
                if not moveToTargetByRoute(target, targetPart) then
                    return false
                end
            end
            if not getTool("Lockpick") then
                if not buyLockpickBatch(nextBatchSize) then
                    return false
                end
                nextBatchSize = 15
                if target.Parent and not isTargetBroken(target) then
                    targetPart = getTargetPart(target)
                    if targetPart then
                        moveToTargetByRoute(target, targetPart)
                    end
                end
            end
            local opened = tryLockpickTarget(target)
            if opened then
                local completedAt = tick()
                while target.Parent
                    and not isTargetBroken(target)
                    and tick() - completedAt < 12
                do
                    task.wait(0.10)
                end
                break
            end
            task.wait(1.25)
        end
    end
    unequipTools()
    return isTargetBroken(target)
end

local function getSpawnedBread()
    local filter = Workspace:FindFirstChild("Filter")
    return filter and filter:FindFirstChild("SpawnedBread") or nil
end

local function normalizeCashObject(object)
    local spawnedBread = getSpawnedBread()
    if not spawnedBread or not object then
        return nil
    end
    if object.Parent ~= spawnedBread then
        object = object.Parent
    end
    if object and object:IsA("BasePart") and object.Parent == spawnedBread then
        return object
    end
    return nil
end

local function collectCashObject(object)
    local cashObject = normalizeCashObject(object)
    local root = getRoot()
    if not cashObject or not root or (cashObject.Position - root.Position).Magnitude >= 10 then
        return false
    end
    local ok = safeCall(CashPickupRemote.FireServer, CashPickupRemote, cashObject, nil)
    return ok
end

local function clearNearbyCashNoMove()
    if not Settings.AutoMoney then
        return 0
    end
    local root = getRoot()
    local spawnedBread = getSpawnedBread()
    if not root or not spawnedBread then
        return 0
    end
    local collected = 0
    for _, cashObject in ipairs(spawnedBread:GetChildren()) do
        if cashObject:IsA("BasePart") and cashObject.Transparency < 1 and (cashObject.Position - root.Position).Magnitude <= Settings.PickupDistance then
            if collectCashObject(cashObject) then
                collected += 1
            end
        end
    end
    return collected
end

local function collectNearbyCash(duration)
    setStatus("Collecting")
    local startedAt = tick()
    while Farm.Enabled and tick() - startedAt < (duration or 3) do
        clearNearbyCashNoMove()
        task.wait(0.15)
    end
end

local function findNearestATMMainPart()
    local root = getRoot()
    local map = getMap()
    local atmFolder = map and map:FindFirstChild("ATMz")
    if not root or not atmFolder then
        return nil
    end
    local best
    local bestDistance = math.huge
    for _, atmModel in ipairs(atmFolder:GetChildren()) do
        if atmModel:IsA("Model") and atmModel.Name == "ATM" then
            local mainPart = atmModel:FindFirstChild("MainPart")
            if mainPart and mainPart:IsA("BasePart") then
                local distance = (mainPart.Position - root.Position).Magnitude
                if distance < bestDistance then
                    best = mainPart
                    bestDistance = distance
                end
            end
        end
    end
    return best
end

local function claimAllowance()
    if not Settings.AutoAllowance then
        return false
    end
    local allowance = readAllowanceText()
    if not string.find(string.upper(allowance), "READY", 1, true) then
        return false
    end
    local atmMainPart = findNearestATMMainPart()
    if not atmMainPart then
        return false
    end
    setStatus("Claiming Allowance")
    local ok, success = safeCall(
        ClaimAllowanceRemote.InvokeServer,
        ClaimAllowanceRemote,
        atmMainPart,
        nil
    )
    task.wait(0.5)
    return ok and success == true
end

local function tryDeposit(force)
    if not Settings.AutoDeposit and not force then
        return false
    end
    local cash = readCashAmountValue()
    local threshold = math.max(1, tonumber(Settings.AutoDepositThresholdK) or 5) * 1000
    if not force and cash < threshold then
        return false
    end
    local atmMainPart = findNearestATMMainPart()
    if not atmMainPart then
        return false
    end
    Farm.State.InProgress = true
    setStatus("Depositing Cash")
    local moved = moveToPosition(atmMainPart.Position, "Depositing Cash")
    local success = false
    if moved then
        local ok, result = safeCall(
            ATMRemote.InvokeServer,
            ATMRemote,
            "DP",
            cash,
            atmMainPart
        )
        success = ok and result == true
        task.wait(1)
    end
    Farm.State.InProgress = false
    return moved and success
end

local function TryDepositAllNow()
    return tryDeposit(true)
end

local function handleHackSuccess(model)
    Farm.ProcessedList[model] = true
    Farm.RetargetPending = false
    Farm.State.LastActiveAt = tick()
    collectNearbyCash(3)
    if SW11TargetNames[model.Name] then
        leaveSW11()
    elseif TowerTargetNames[model.Name] then
        leaveTower()
    elseif ZoneRoutes[model.Name] then
        leaveZoneRoute()
    elseif SUTargetNames[model.Name] then
        leaveSURoute()
    end
    return true
end

local function processTarget(model, part)
    if not model or not part then
        return false
    end
    local moved = moveToTargetByRoute(model, part)
    if not processTargetMoveOutcome(model, part, moved) then
        return false
    end
    if not breakTarget(model, part) then
        Farm.TempIgnoredTargets[model] = tick() + Settings.IgnoreDuration
        return false
    end
    return handleHackSuccess(model)
end

local function findCashAddedLabel()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    local core = playerGui and playerGui:FindFirstChild("CoreGUI")
    local stats = core and core:FindFirstChild("StatsFrame")
    local frame2 = stats and stats:FindFirstChild("Frame2")
    local frame = frame2 and frame2:FindFirstChild("Frame")
    local container = frame and frame:FindFirstChild("Container")
    local cash = container and container:FindFirstChild("Cash")
    if not cash then
        return nil
    end
    local added = cash:FindFirstChild("Added")
    if added and added:IsA("TextLabel") then
        return added
    end
    for _, object in ipairs(cash:GetDescendants()) do
        if object:IsA("TextLabel") and string.lower(object.Name) == "added" then
            return object
        end
    end
    return nil
end

local function processCashAddedText(text)
    text = trim(text)
    if text == "" or text == Farm.LastCashAddedText then
        return
    end
    Farm.LastCashAddedText = text
    if text:sub(1, 1) ~= "+" then
        return
    end
    local amount = parseCashTextToNumber(text)
    if amount > 0 then
        Farm.EarnMoneyTotal += amount
        Settings.EarnMoneyTotal = Farm.EarnMoneyTotal
    end
end

local function bindCashTracking()
    if Farm.CashAddedConnection then
        Farm.CashAddedConnection:Disconnect()
        Farm.CashAddedConnection = nil
    end
    if Farm.CashAddedTextConnection then
        Farm.CashAddedTextConnection:Disconnect()
        Farm.CashAddedTextConnection = nil
    end
    local label = findCashAddedLabel()
    if label then
        Farm.CashAddedTextConnection = label:GetPropertyChangedSignal("Text"):Connect(function()
            processCashAddedText(label.Text)
        end)
        processCashAddedText(label.Text)
        return
    end
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if playerGui then
        Farm.CashAddedConnection = playerGui.DescendantAdded:Connect(function(object)
            if object:IsA("TextLabel") and string.lower(object.Name) == "added" then
                task.defer(bindCashTracking)
            end
        end)
    end
end

local function refreshInfoLabels()
    local elapsed = Farm.StartedAt > 0 and math.floor(tick() - Farm.StartedAt) or 0
    local hours = math.floor(elapsed / 3600)
    local minutes = math.floor(elapsed % 3600 / 60)
    local seconds = elapsed % 60
    local currentCash = readCashAmountValue()
    local fallbackTotal = Settings.EarnMoneyTotal + math.max(0, currentCash - Farm.StartCash)
    if fallbackTotal > Farm.EarnMoneyTotal then
        Farm.EarnMoneyTotal = fallbackTotal
    end
    if Farm.UI.Died then
        setUiText(Farm.UI.Died, "Died: " .. tostring(Farm.DiedCount))
    end
    if Farm.UI.Bank then
        setUiText(Farm.UI.Bank, "Bank: " .. readBankAmountText())
    end
    if Farm.UI.Allowance then
        setUiText(Farm.UI.Allowance, "Allowance: " .. readAllowanceText())
    end
    if Farm.UI.Time then
        setUiText(Farm.UI.Time, string.format("Time: %02d:%02d:%02d", hours, minutes, seconds))
    end
    if Farm.UI.EarnMoney then
        setUiText(Farm.UI.EarnMoney, "Earn Money: " .. tostring(math.floor(Farm.EarnMoneyTotal)))
    end
end

local function resetInfo()
    Settings.EarnMoneyTotal = 0
    Farm.EarnMoneyTotal = 0
    Farm.StartCash = readCashAmountValue()
    Farm.DiedCount = 0
    Farm.StartedAt = tick()
    Settings.save()
    refreshInfoLabels()
    notify("Notification", "INFO reset complete", 4)
end

local function recommendServer()
    local targets = rebuildTargets()
    local count = #targets
    local text
    if count <= 2 then
        text = "Few targets (" .. tostring(count) .. "), too many competitors. Switch server."
    else
        text = "Enough targets (" .. tostring(count) .. "), farming is viable."
    end
    notify("Recommendation", text, 7)
end

--[[
Presumed administrator IDs from the pseudocode.
local AssumedAdministratorUserIds = {
    3294804378,
    93676120,
    54087314,
    81275825,
    140837601,
    1229486091,
    46567801,
    418086275,
    29706395,
    3717066084,
    1424338327,
    5046662686,
    5046661126,
    5046659439,
    418199326,
    1024216621,
    1810535041,
    63238912,
    111250044,
    63315426,
    730176906,
    141193516,
    194512073,
    193945439,
    412741116,
    195538733,
    102045519,
    955294,
    957835150,
    25689921,
    366613818,
    281593651,
    455275714,
    208929505,
    96783330,
    156152502,
    93281166,
    959606619,
    142821118,
    632886139,
    175931803,
    122209625,
    278097946,
    142989311,
    1517131734,
    446849296,
    87189764,
    67180844,
    9212846,
    47352513,
    48058122,
    155413858,
    10497435,
    513615792,
    55893752,
    55476024,
    151691292,
    136584758,
    16983447,
    3111449,
    94693025,
    271400893,
    5005262660,
    295331237,
    64489098,
    244844600,
    114332275,
    25048901,
    69262878,
    50801509,
    92504899,
    42066711,
    50585425,
    31365111,
    166406495,
    2457253857,
    29761878,
    21831137,
    948293345,
    439942262,
    38578487,
    1163048,
    7713309208,
    3659305297,
    15598614,
    34616594,
    626833004,
    198610386,
    153835477,
    3923114296,
    3937697838,
    102146039,
    119861460,
    371665775,
    1206543842,
    93428604,
    1863173316,
    90814576,
    374665997,
    423005063,
    140172831,
    42662179,
    9066859,
    438805620,
    14855669,
    727189337,
    1871290386,
    608073286,
}
]]
local function detectAdmin(player)
    if player == LocalPlayer then
        return false
    end
    if player:GetAttribute("IsAdmin") == true then
        return true
    end
    for _, containerName in ipairs({"leaderstats", "Data", "Values", "Admins", "Adminz"}) do
        local container = player:FindFirstChild(containerName)
        if container then
            local value = container:FindFirstChild("Admin") or container:FindFirstChild("IsAdmin")
            if value and value:IsA("BoolValue") and value.Value then
                return true
            end
        end
    end
    return false
end

local function rejoin(reason)
    if not Settings.AntiRejoin or tick() - Farm.LastRejoinAt < 10 then
        return
    end
    Farm.LastRejoinAt = tick()
    notify("JX", tostring(reason or "Rejoining"), 4)
    safeCall(TeleportService.Teleport, TeleportService, game.PlaceId, LocalPlayer)
end

local function adminCheck()
    if not Settings.AdminCheck then
        return false
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if detectAdmin(player) then
            rejoin("Admin detected")
            return true
        end
    end
    return false
end

local function bindAdminDetection()
    table.insert(Farm.AdminConnections, Players.PlayerAdded:Connect(function(player)
        task.wait(1)
        if Settings.AdminCheck and detectAdmin(player) then
            rejoin("Admin detected: " .. player.Name)
        end
    end))
    safeCall(function()
        local promptGui = CoreGui:FindFirstChild("RobloxPromptGui")
        local overlay = promptGui and promptGui:FindFirstChild("promptOverlay")
        if overlay then
            table.insert(Farm.AdminConnections, overlay.DescendantAdded:Connect(function(object)
                if object:IsA("TextLabel") then
                    local text = string.lower(tostring(object.Text))
                    if text:find("kick", 1, true) or text:find("kicked", 1, true) or text:find("disconnect", 1, true) or text:find("error", 1, true) then
                        rejoin("Prompt: " .. object.Text)
                    end
                end
            end))
        end
    end)
    safeCall(function()
        table.insert(Farm.AdminConnections, GuiService.ErrorMessageChanged:Connect(function(message)
            local text = string.lower(tostring(message))
            if text:find("kick", 1, true) or text:find("disconnect", 1, true) or text:find("error", 1, true) then
                rejoin("GuiService: " .. tostring(message))
            end
        end))
    end)
end

local function bindAntiAFK()
    LocalPlayer.Idled:Connect(function()
        if not Settings.AntiAFK then
            return
        end
        safeCall(VirtualUser.CaptureController, VirtualUser)
        safeCall(VirtualUser.ClickButton2, VirtualUser, Vector2.new())
    end)
end

local NoFallState = {
    HookInstalled = false,
    CharacterConnection = nil
}

local function applyNoFallCharacterState()
    if not Settings.AntiFallDamage then
        return
    end
    local character = getCharacter()
    if not character then
        return
    end
    local charStats = character:FindFirstChild("CharStats")
    if not charStats then
        return
    end
    local playerStats = charStats:FindFirstChild(LocalPlayer.Name)
        or charStats:FindFirstChild(tostring(LocalPlayer.UserId))
        or charStats
    local ragdollSwitch = playerStats:FindFirstChild("RagdollSwitch")
        or charStats:FindFirstChild("RagdollSwitch", true)
    local ragdollTime = playerStats:FindFirstChild("RagdollTime")
        or charStats:FindFirstChild("RagdollTime", true)
    if ragdollSwitch and ragdollSwitch:IsA("BoolValue") then
        ragdollSwitch.Value = false
    end
    if ragdollTime and (ragdollTime:IsA("NumberValue") or ragdollTime:IsA("IntValue")) then
        ragdollTime.Value = 0
    end
end

local function bindNoFall()
    Environment.CV2_NoFall = Settings.AntiFallDamage
    if not NoFallState.HookInstalled
        and type(hookmetamethod) == "function"
        and type(newcclosure) == "function"
        and type(getnamecallmethod) == "function"
    then
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            if Settings.AntiFallDamage
                and Environment.CV2_NoFall
                and self == FallRemote
                and getnamecallmethod() == "FireServer"
                and select(1, ...) == "FlllD"
            then
                return nil
            end
            return oldNamecall(self, ...)
        end))
        NoFallState.HookInstalled = true
    end
    if not NoFallState.CharacterConnection then
        NoFallState.CharacterConnection = RunService.Heartbeat:Connect(function()
            Environment.CV2_NoFall = Settings.AntiFallDamage
            applyNoFallCharacterState()
        end)
    end
    applyNoFallCharacterState()
end

local InvisState = {
    Enabled = false,
    WarningGui = nil,
    WarningLabel = nil,
    Animation = nil,
    Track = nil,
    HeartbeatConnection = nil
}

local function ensureInvisWarningGui()
    if InvisState.WarningGui and InvisState.WarningGui.Parent then
        return InvisState.WarningGui, InvisState.WarningLabel
    end
    local existing = UiParent:FindFirstChild("JXInvisWarningGUI")
        or UiParent:FindFirstChild("InvisWarningGUI")
        or UiParent:FindFirstChild("WarningGUI")
    if existing then
        InvisState.WarningGui = existing
        InvisState.WarningLabel = existing:FindFirstChildWhichIsA("TextLabel", true)
        return InvisState.WarningGui, InvisState.WarningLabel
    end
    local screen = Instance.new("ScreenGui")
    screen.Name = "JXInvisWarningGUI"
    screen.ResetOnSpawn = false
    screen.Parent = UiParent
    local label = Instance.new("TextLabel")
    label.Name = "TextLabel"
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Position = UDim2.new(0.5, 0, 0.75, 0)
    label.Size = UDim2.new(0, 420, 0, 52)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.Text = "VISIBLE WARNING"
    label.TextSize = 30
    label.TextColor3 = Color3.fromRGB(190, 190, 190)
    label.Visible = false
    label.Parent = screen
    InvisState.WarningGui = screen
    InvisState.WarningLabel = label
    return InvisState.WarningGui, InvisState.WarningLabel
end

local function setVisibleBodyTransparency(character, fromTransparency, toTransparency)
    if not character then
        return
    end
    for _, object in ipairs(character:GetDescendants()) do
        if object:IsA("BasePart")
            and object.Name ~= "HumanoidRootPart"
            and (fromTransparency == nil or object.Transparency == fromTransparency)
        then
            if fromTransparency ~= nil or object.Transparency ~= 1 then
                object.Transparency = toTransparency
            end
        end
    end
end

local function stopInvisTrack()
    if InvisState.Track then
        safeCall(InvisState.Track.Stop, InvisState.Track)
        InvisState.Track = nil
    end
end

local function updateInvisCharacter()
    if not InvisState.Enabled then
        return
    end
    local character = getCharacter()
    local humanoid = getHumanoid(character)
    local root = getRoot(character)
    local torso = character and character:FindFirstChild("Torso")
    local camera = Workspace.CurrentCamera
    if not character or not humanoid or not root or not torso or not camera then
        return
    end
    camera.CameraSubject = root
    if InvisState.WarningLabel then
        InvisState.WarningLabel.Visible = humanoid.FloorMaterial == Enum.Material.Air
    end
    local _, cameraYaw = camera.CFrame:ToOrientation()
    root.CFrame = CFrame.new(root.Position) * CFrame.fromOrientation(0, cameraYaw, 0)
    root.CFrame = root.CFrame * CFrame.Angles(math.rad(90), 0, 0)
    humanoid.CameraOffset = Vector3.new(0, 1.44, 0)
    if not InvisState.Animation then
        InvisState.Animation = Instance.new("Animation")
        InvisState.Animation.AnimationId = "rbxassetid://215384594"
    end
    stopInvisTrack()
    local ok, track = safeCall(humanoid.LoadAnimation, humanoid, InvisState.Animation)
    if ok and track then
        InvisState.Track = track
        track.Priority = Enum.AnimationPriority.Action4
        track:Play()
        track:AdjustSpeed(0)
        track.TimePosition = 0.3
    end
    RunService.RenderStepped:Wait()
    stopInvisTrack()
    local lookVector = camera.CFrame.LookVector
    local horizontal = Vector3.new(lookVector.X, 0, lookVector.Z)
    if horizontal.Magnitude > 0 then
        horizontal = horizontal.Unit
        root.CFrame = CFrame.new(root.Position, root.Position + horizontal)
    end
    setVisibleBodyTransparency(character, nil, 0.5)
end

local function ensureInvisHeartbeat()
    if InvisState.HeartbeatConnection then
        return
    end
    InvisState.HeartbeatConnection = RunService.Heartbeat:Connect(function()
        if InvisState.Enabled then
            safeCall(updateInvisCharacter)
        elseif InvisState.WarningLabel then
            InvisState.WarningLabel.Visible = false
        end
    end)
end

local function invisEnable()
    local character = getCharacter()
    if not character or not character:FindFirstChild("Torso") then
        notify("Invisibility NOT AVAILABLE", "R6 avatar required", 6)
        return false
    end
    InvisState.Enabled = true
    Settings.HideBody = true
    Environment.JXFarmInvis = true
    Environment.UserWantsInvis = true
    Environment.IsInvisEnabled = true
    ensureInvisWarningGui()
    ensureInvisHeartbeat()
    local root = getRoot(character)
    local camera = Workspace.CurrentCamera
    if camera and root then
        camera.CameraSubject = root
    end
    safeCall(updateInvisCharacter)
    return true
end

local function invisDisable()
    InvisState.Enabled = false
    Settings.HideBody = false
    Environment.JXFarmInvis = false
    Environment.UserWantsInvis = false
    Environment.IsInvisEnabled = false
    stopInvisTrack()
    local character = getCharacter()
    local humanoid = getHumanoid(character)
    local camera = Workspace.CurrentCamera
    if humanoid then
        humanoid.CameraOffset = Vector3.zero
    end
    if camera and humanoid then
        camera.CameraSubject = humanoid
    end
    setVisibleBodyTransparency(character, 0.5, 0)
    if InvisState.WarningLabel then
        InvisState.WarningLabel.Visible = false
    end
    return true
end

_G.Invis_Enable = invisEnable
_G.Invis_Disable = invisDisable

local function bindDeathTracking()
    if Farm.DiedConnection then
        Farm.DiedConnection:Disconnect()
        Farm.DiedConnection = nil
    end
    local humanoid = getHumanoid()
    if humanoid then
        Farm.DiedConnection = humanoid.Died:Connect(function()
            if tick() - Farm.LastDiedIncrementAt > 1 then
                Farm.LastDiedIncrementAt = tick()
                Farm.DiedCount += 1
                refreshInfoLabels()
            end
            setStatus("Dead")
        end)
    end
end

local function autoRespawnLoop()
    task.spawn(function()
        while true do
            if Settings.AutoRespawn and isDead() then
                setStatus("Dead")
                local character = LocalPlayer.CharacterAdded:Wait()
                character:WaitForChild("Humanoid", 15)
                task.wait(Settings.FarmDeadWaitSec)
                bindDeathTracking()
                if InvisState.Enabled then
                    task.defer(invisEnable)
                end
            end
            task.wait(1)
        end
    end)
end

local function performAutoPlayRemoteSequence()
    local invoked = false
    if AutoPlayRemote and AutoPlayRemote:IsA("RemoteFunction") then
        local ok = safeCall(
            AutoPlayRemote.InvokeServer,
            AutoPlayRemote,
            "",
            "\15daz\18tough\19"
        )
        invoked = ok
    end
    if UpdateClientRemote and UpdateClientRemote:IsA("RemoteEvent") then
        safeCall(UpdateClientRemote.FireServer, UpdateClientRemote)
    end
    return invoked
end

local function bindLoadTimeDetection()
    local state = Environment.JXFarmAutoPlayState
    if type(state) ~= "table" then
        state = {
            enabled = Settings.AutoPlay,
            busy = false,
            loadTimeDetected = false,
            loadTimeReadyAt = 0
        }
        Environment.JXFarmAutoPlayState = state
    end
    local function inspect(message)
        local textValue = tostring(message)
        if string.find(textValue, "LOAD%s*TIME%s*:") then
            state.loadTimeDetected = true
            state.loadTimeReadyAt = tick() + 5
            notify("Notification", "LOAD TIME detected. Auto Play starts in 5s.", 5)
        end
    end
    LogService.MessageOut:Connect(inspect)
    safeCall(function()
        for _, entry in ipairs(LogService:GetLogHistory()) do
            inspect(entry.message or entry.Message or entry.text or "")
        end
    end)
    task.spawn(function()
        while true do
            state.enabled = Settings.AutoPlay
            if state.enabled and not state.busy then
                state.busy = true
                local startedAt = tick()
                while Settings.AutoPlay and tick() - startedAt < 20 do
                    performAutoPlayRemoteSequence()
                    if state.loadTimeDetected and tick() >= state.loadTimeReadyAt then
                        Farm.UserWantsFarm = true
                        Farm.Enabled = true
                        state.loadTimeDetected = false
                        break
                    end
                    task.wait(0.2)
                end
                state.busy = false
            end
            task.wait(0.5)
        end
    end)
end

local function notifyLoop()
    task.spawn(function()
        while true do
            local interval = math.max(1, tonumber(Settings.NotifyMinutes) or 1) * 60
            if Settings.AutoNotify and Farm.Enabled and tick() - Farm.LastNotifyAt >= interval then
                Farm.LastNotifyAt = tick()
                Webhook.send("JX Farm Update", Farm.Status, {
                    {name = "Status", value = Farm.Status, inline = true},
                    {name = "Cash", value = readCashAmountText(), inline = true},
                    {name = "Bank", value = readBankAmountText(), inline = true},
                    {name = "Earn Money", value = tostring(math.floor(Farm.EarnMoneyTotal)), inline = true},
                    {name = "Died", value = tostring(Farm.DiedCount), inline = true},
                    {name = "Job ID", value = tostring(game.JobId), inline = false}
                })
            end
            task.wait(1)
        end
    end)
end

local function farmStep()
    if adminCheck() then
        return
    end
    if isDead() then
        setStatus("Dead")
        task.wait(Settings.FarmDeadWaitSec)
        return
    end
    if Settings.AutoMoney then
        clearNearbyCashNoMove()
    end
    if Settings.AutoAllowance then
        claimAllowance()
    end
    if tryDeposit(false) then
        task.wait(Settings.FarmBetweenTargetsSec)
        return
    end
    setStatus("Finding Target")
    local model, part = chooseTarget()
    if not model or not part then
        setStatus("Idle (all opened)")
        task.wait(Settings.FarmIdleWaitSec)
        return
    end
    processTarget(model, part)
    task.wait(Settings.FarmBetweenTargetsSec)
end

function Farm.start()
    if Farm.Enabled and Farm.Busy then
        return
    end
    Farm.Enabled = true
    Farm.UserWantsFarm = true
    Farm.Busy = true
    Farm.StartCash = readCashAmountValue()
    Farm.EarnMoneyTotal = Settings.EarnMoneyTotal
    Farm.StartedAt = tick()
    Farm.ProcessedList = {}
    Environment.JXFarmEnabled = true
    Environment.UserWantsFarm = true
    notify("Notification", "AutoFarm started", 4)
    task.spawn(function()
        while Farm.Enabled do
            local ok, err = xpcall(farmStep, debug.traceback)
            if not ok then
                setStatus("Idle")
                task.wait(Settings.FarmRetryWaitSec)
            end
            task.wait(Settings.FarmTickSec)
        end
        Farm.Busy = false
        setStatus("Idle")
    end)
end

function Farm.stop()
    Farm.Enabled = false
    Farm.UserWantsFarm = false
    Environment.JXFarmEnabled = false
    Environment.UserWantsFarm = false
    Environment.JXFarmMove = false
    setStatus("Idle")
    Settings.EarnMoneyTotal = Farm.EarnMoneyTotal
    Settings.save()
    notify("Notification", "AutoFarm stopped", 4)
end

local function makeRounded(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = object
end

local function makeLabel(parent, text, position, size)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(235, 235, 235)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = text
    label.Parent = parent
    return label
end

local function makeButton(parent, text, position, callback)
    local button = Instance.new("TextButton")
    button.Position = position
    button.Size = UDim2.new(0, 155, 0, 32)
    button.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
    button.TextColor3 = Color3.fromRGB(245, 245, 245)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Text = text
    button.Parent = parent
    makeRounded(button, 6)
    button.MouseButton1Click:Connect(callback)
    return button
end

local function createFarmGui()
    local source = game:HttpGet(Config.Library.Url)
    local Library = loadstring(source)()
    local Window = Library:Window({
        Name = Config.Library.Title,
        Logo = "85279746515974",
        MobileButtonText = Config.Library.MobileButtonText
    })
    local FarmPage = Window:Page({
        Name = "Farm",
        Columns = 2
    })
    local MiscPage = Window:Page({
        Name = "Misc",
        Columns = 2
    })
    local NotifierPage = Window:Page({
        Name = "Notifier",
        Columns = 2
    })
    local FarmSection = FarmPage:Section({
        Name = "Main",
        Side = 1
    })
    local UtilitySection = FarmPage:Section({
        Name = "Utility",
        Side = 1
    })
    local MiscSection = MiscPage:Section({
        Name = "Misc",
        Side = 1
    })
    local CharacterSection = MiscPage:Section({
        Name = "Character",
        Side = 2
    })
    local WebhookSection = NotifierPage:Section({
        Name = "Webhook",
        Side = 1
    })
    local FarmInfoSection = NotifierPage:Section({
        Name = "INFO",
        Side = 2
    })
    local function applySetting()
        syncEnvironmentSettings()
        Settings.save()
    end
    FarmSection:Toggle({
        Name = "Start Farm",
        Flag = "JXFarmEnabled",
        Default = Farm.Enabled,
        Callback = function(value)
            if value then
                Farm.start()
            else
                Farm.stop()
            end
        end
    })
    FarmSection:Dropdown({
        Name = "Breaking Method",
        Flag = "JXFarmBreakingMethod",
        Options = {"Crowbar", "Fist + Lockpick"},
        Default = Settings.BreakingMethod,
        Callback = function(value)
            if value == "Crowbar" or value == "Fist + Lockpick" then
                Settings.BreakingMethod = value
                applySetting()
            end
        end
    })
    FarmSection:Slider({
        Name = "Move Speed",
        Flag = "JXFarmSpeedV2",
        Min = 10,
        Max = 45,
        Default = Settings.MoveSpeed,
        Suffix = "",
        Decimals = 1,
        Callback = function(value)
            Settings.MoveSpeed = math.clamp(tonumber(value) or Settings.MoveSpeed, 10, 45)
            applySetting()
        end
    })
    UtilitySection:Toggle({
        Name = "Auto Pickup Money",
        Flag = "JXFarmAutoMoney",
        Default = Settings.AutoMoney,
        Callback = function(value)
            Settings.AutoMoney = value == true
            applySetting()
        end
    })
    UtilitySection:Toggle({
        Name = "Auto Deposit",
        Flag = "JXFarmAutoDeposit",
        Default = Settings.AutoDeposit,
        Callback = function(value)
            Settings.AutoDeposit = value == true
            applySetting()
        end
    })
    UtilitySection:Slider({
        Name = "Deposit At",
        Flag = "JXFarmAutoDepositThresholdK",
        Min = 1,
        Max = 100,
        Default = Settings.AutoDepositThresholdK,
        Suffix = "k",
        Decimals = 1,
        Callback = function(value)
            Settings.AutoDepositThresholdK = math.clamp(tonumber(value) or Settings.AutoDepositThresholdK, 1, 100)
            applySetting()
        end
    })
    UtilitySection:Toggle({
        Name = "Auto Claim Allowance",
        Flag = "JXFarmAutoAllowance",
        Default = Settings.AutoAllowance,
        Callback = function(value)
            Settings.AutoAllowance = value == true
            applySetting()
        end
    })
    UtilitySection:Toggle({
        Name = "Auto Play",
        Flag = "JXFarmAutoPlay",
        Default = Settings.AutoPlay,
        Callback = function(value)
            Settings.AutoPlay = value == true
            applySetting()
        end
    })
    MiscSection:Toggle({
        Name = "Auto Respawn",
        Flag = "JXFarmAutoRespawn",
        Default = Settings.AutoRespawn,
        Callback = function(value)
            Settings.AutoRespawn = value == true
            applySetting()
        end
    })
    MiscSection:Toggle({
        Name = "Auto Notify",
        Flag = "JXFarmAutoNotify",
        Default = Settings.AutoNotify,
        Callback = function(value)
            Settings.AutoNotify = value == true
            applySetting()
        end
    })
    MiscSection:Toggle({
        Name = "Anti-AFK",
        Flag = "JXFarmAntiAfk",
        Default = Settings.AntiAFK,
        Callback = function(value)
            Settings.AntiAFK = value == true
            applySetting()
        end
    })
    MiscSection:Toggle({
        Name = "Admin Check",
        Flag = "JXFarmAdminCheck",
        Default = Settings.AdminCheck,
        Callback = function(value)
            Settings.AdminCheck = value == true
            applySetting()
        end
    })
    MiscSection:Toggle({
        Name = "Anti Error/kick",
        Flag = "JXFarmAntiRejoin",
        Default = Settings.AntiRejoin,
        Callback = function(value)
            Settings.AntiRejoin = value == true
            applySetting()
        end
    })
    CharacterSection:Toggle({
        Name = "Hide Body",
        Flag = "JXFarmInvis",
        Default = Settings.HideBody,
        Callback = function(value)
            Settings.HideBody = value == true
            if Settings.HideBody then
                invisEnable()
            else
                invisDisable()
            end
            applySetting()
        end
    })
    CharacterSection:Toggle({
        Name = "Anti Fall Damage",
        Flag = "CharacterAntiFallDamage",
        Default = Settings.AntiFallDamage,
        Callback = function(value)
            Settings.AntiFallDamage = value == true
            applySetting()
        end
    })
    WebhookSection:Textbox({
        Name = "Webhook URL",
        Flag = "JXFarmWebhookURL",
        Default = tostring(Settings.WebhookURL),
        Callback = function(value)
            Settings.WebhookURL = trim(value)
        end
    })
    WebhookSection:Button({
        Name = "Save Webhook",
        Callback = function()
            applySetting()
            notify("Notification", "Webhook saved", 4)
        end
    })
    WebhookSection:Slider({
        Name = "Notify Time",
        Flag = "JXFarmNotifyTimeMinutes",
        Min = 1,
        Max = 10,
        Default = Settings.NotifyMinutes,
        Suffix = "m",
        Decimals = 1,
        Callback = function(value)
            Settings.NotifyMinutes = math.floor(math.clamp(tonumber(value) or Settings.NotifyMinutes, 1, 10))
            applySetting()
        end
    })
    Farm.UI.Status = FarmInfoSection:Label("Status: Idle")
    Farm.UI.Time = FarmInfoSection:Label("Time: 0")
    Farm.UI.EarnMoney = FarmInfoSection:Label("Earn Money: " .. tostring(math.floor(Farm.EarnMoneyTotal)))
    Farm.UI.Bank = FarmInfoSection:Label("Bank: ...")
    Farm.UI.Died = FarmInfoSection:Label("Died: 0")
    Farm.UI.Allowance = FarmInfoSection:Label("Allowance: ...")
    local resetCreated = pcall(function()
        FarmInfoSection:Button({
            Name = "Reset INFO",
            Callback = resetInfo
        })
    end)
    if not resetCreated then
        FarmInfoSection:Toggle({
            Name = "Reset INFO",
            Flag = "JXFarmResetInfoFallback",
            Default = false,
            Callback = function(value)
                if value then
                    resetInfo()
                end
            end
        })
    end
    Window:KeybindList()
    Window:Watermark("JX | Criminality | FARM")
    MiscPage:CreateSettingsPage()
    refreshInfoLabels()
end

local function createKeyGui(onVerified)
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    local previous = playerGui:FindFirstChild("KeySystemGUI")
    if previous then
        previous:Destroy()
    end
    local screen = Instance.new("ScreenGui")
    screen.Name = "KeySystemGUI"
    screen.ResetOnSpawn = false
    screen.Parent = playerGui
    local frame = Instance.new("Frame")
    frame.Name = "MainFrame"
    frame.Size = UDim2.new(0, 420, 0, 275)
    frame.Position = UDim2.new(0.5, -210, 0.5, -137)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Parent = screen
    makeRounded(frame, 10)
    local title = makeLabel(frame, "🔴 JX-Key System", UDim2.new(0, 18, 0, 12), UDim2.new(1, -36, 0, 32))
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    local status = makeLabel(frame, "🌟 Welcome! Press Get Key Button To Get Key!", UDim2.new(0, 18, 0, 50), UDim2.new(1, -36, 0, 46))
    status.TextWrapped = true
    local input = Instance.new("TextBox")
    input.Position = UDim2.new(0, 18, 0, 105)
    input.Size = UDim2.new(1, -36, 0, 42)
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 46)
    input.TextColor3 = Color3.fromRGB(245, 245, 245)
    input.PlaceholderColor3 = Color3.fromRGB(140, 140, 145)
    input.PlaceholderText = "Enter your Key here..."
    input.ClearTextOnFocus = false
    input.Font = Enum.Font.Gotham
    input.TextSize = 14
    input.Parent = frame
    makeRounded(input, 6)
    local getKey = makeButton(frame, "🔑 Get Key", UDim2.new(0, 18, 0, 160), function()
        status.Text = "Requesting key link..."
        task.spawn(function()
            local ok, data = KeySystem.requestKey()
            if ok then
                status.Text = "Key link copied to clipboard."
            else
                status.Text = "Unable to request key: " .. tostring(data)
            end
        end)
    end)
    getKey.Size = UDim2.new(0, 120, 0, 36)
    local checkKey = makeButton(frame, "✅ Check Key", UDim2.new(0, 150, 0, 160), function()
        status.Text = "Checking key..."
        task.spawn(function()
            local ok, data = KeySystem.verifyKey(input.Text)
            if ok then
                status.Text = "Saved key verified! Loading script..."
                task.wait(0.5)
                screen:Destroy()
                onVerified()
            else
                status.Text = tostring(data)
            end
        end)
    end)
    checkKey.Size = UDim2.new(0, 120, 0, 36)
    local discord = makeButton(frame, "💬 Discord", UDim2.new(0, 282, 0, 160), function()
        if type(Executor.setClipboard) == "function" then
            safeCall(Executor.setClipboard, Config.KeySystem.DiscordInvite)
        end
        status.Text = "Join Discord: " .. Config.KeySystem.DiscordInvite
    end)
    discord.Size = UDim2.new(0, 120, 0, 36)
    local close = makeButton(frame, "Close", UDim2.new(0, 282, 0, 213), function()
        screen:Destroy()
        notify("JX", "Key system closed.", 4)
    end)
    close.Size = UDim2.new(0, 120, 0, 34)
    local saved = KeySystem.loadSavedKey()
    if saved then
        input.Text = tostring(saved.key)
        status.Text = "📁 Saved key loaded! Click Check Key to verify."
    end
end

local function initializeFarm()
    Settings.load()
    syncEnvironmentSettings()
    Environment.JXFarmTempIgnoredTargets = Farm.TempIgnoredTargets
    Environment.JXFarmRunId = HttpService:GenerateGUID(false)
    Environment.UserWantsFarm = Farm.UserWantsFarm
    Environment.UserWantsInvis = Settings.HideBody
    Environment.IsInvisEnabled = InvisState.Enabled
    Environment.Invis_Toggle = Settings.HideBody
    bindAntiAFK()
    bindNoFall()
    bindAdminDetection()
    bindDeathTracking()
    bindLoadTimeDetection()
    bindCashTracking()
    bindTargetTracking()
    autoRespawnLoop()
    notifyLoop()
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        bindDeathTracking()
        bindCashTracking()
        bindTargetTracking()
        if Settings.HideBody then
            task.defer(invisEnable)
        end
    end)
    RunService.Heartbeat:Connect(function()
        refreshInfoLabels()
    end)
    task.spawn(function()
        while true do
            refreshESP()
            task.wait(3)
        end
    end)
    createFarmGui()
    recommendServer()
    notify("Notification", "JX-CRIMINALITY-FARM FULLY LOADED", 6)
    task.spawn(function()
        Webhook.send("Script Executed", "JX-EXECUTED")
    end)
end

local function start()
    KeySystem.fetchPublicConfig()
    if Config.KeySystem.Keyless then
        notify("JX", "Keyless mode enabled. Loading...", 4)
        initializeFarm()
        return
    end
    local saved = KeySystem.loadSavedKey()
    if saved then
        local ok = KeySystem.verifyKey(saved.key)
        if ok then
            notify("JX", "Saved key is valid! Loading Script...", 4)
            initializeFarm()
            return
        end
    end
    createKeyGui(initializeFarm)
end

start()
