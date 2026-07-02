game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "JX-CRIMINALITY!",
    Text = "Join Discord Server | Dsc.gg/getjx",
    Duration = 5,
    Icon = "http://www.roblox.com/asset/?id=85279746515974"
})

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Read-Me",
    Text = "Press RightAlt To Open/Close The Panel!",
    Duration = 5
})

local BaseUrl = "https://raw.githubusercontent.com/jianlobiano/FREE/main/MS-PAINT-UI/"
local Library = loadstring(game:HttpGet(BaseUrl .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(BaseUrl .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(BaseUrl .. "addons/SaveManager.lua"))()

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true
Library.ShowCustomCursor = false

local Window = Library:CreateWindow({
    Title = "JX-CRIMINALITY",
    Footer = "Dsc.gg/getjx",
    Center = true,
    AutoShow = true,
    ToggleKeybind = Enum.KeyCode.RightAlt
})

local AltFarmTab = Window:AddTab("Alt Farm")
local SettingsTab = Window:AddTab("Settings")
local TPFarmBox = AltFarmTab:AddLeftGroupbox("TP Farm")
local MiscBox = AltFarmTab:AddRightGroupbox("Misc")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Events = ReplicatedStorage:WaitForChild("Events", 10)
local MeleeStart = Events:WaitForChild("XMHH.2", 5)
local MeleeHit = Events:WaitForChild("XMHH2.2", 5)
local DeathRespawn = Events:WaitForChild("DeathRespawn", 5)
local PositionRemote = Events:WaitForChild("__RZDONL", 5)

local tpFarmEnabled = false
local tpFarmTarget = ""
local meleeAuraEnabled = false
local meleeAuraDistance = 15
local infiniteStaminaEnabled = true
local antiAFKEnabled = true
local autoRespawnEnabled = true
local adminCheckEnabled = true

local tpSteppedConnection
local tpRenderConnection
local tpCharacterConnection
local tpHealthConnection
local meleeAuraConnection
local staminaCharacterConnection
local autoRespawnConnection
local adminCheckConnection
local saveCubeConnection
local saveVibeConnection
local saveMountainConnection

local collisionParts = {
    "Head",
    "Left Arm",
    "Right Arm",
    "Left Leg",
    "Right Leg"
}

local function disconnect(connection)
    if connection then
        connection:Disconnect()
    end
    return nil
end

local function setCharacterCollision(character, canCollide)
    if not character then
        return
    end

    for _, partName in ipairs(collisionParts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.CanCollide = canCollide
        end
    end
end

local function equipBackpackTool(character)
    local backpack = LocalPlayer.Backpack
    if not backpack or character:FindFirstChild("Foreshield") then
        return
    end

    local tool
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item:FindFirstChild("WeaponHandle") then
            tool = item
            break
        end
    end

    if not tool then
        tool = backpack:FindFirstChildOfClass("Tool")
    end

    if not tool or character:FindFirstChild("Foreshield") then
        return
    end

    task.wait(1)
    if character.Parent and tool.Parent == backpack then
        tool.Parent = character
    end
end

local function prepareTPCharacter(character)
    if not tpFarmEnabled or not character then
        return
    end

    local humanoid = character:WaitForChild("Humanoid", 5)
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if not humanoid or not root then
        return
    end

    setCharacterCollision(character, false)
    task.wait(0.5)

    local currentRoot = character:FindFirstChild("HumanoidRootPart")
    if currentRoot and PositionRemote then
        PositionRemote:FireServer("__---r", nil, currentRoot.CFrame)
    end

    equipBackpackTool(character)

    tpHealthConnection = disconnect(tpHealthConnection)
    tpHealthConnection = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if humanoid.Health > 0 and tpFarmEnabled then
            local tool = character:FindFirstChildOfClass("Tool")
            local shield = character:FindFirstChild("Foreshield")
            if not tool and not shield then
                equipBackpackTool(character)
            end
        end
    end)
end

local function stopTPFarm()
    tpSteppedConnection = disconnect(tpSteppedConnection)
    tpRenderConnection = disconnect(tpRenderConnection)
    tpCharacterConnection = disconnect(tpCharacterConnection)
    tpHealthConnection = disconnect(tpHealthConnection)
    setCharacterCollision(LocalPlayer.Character, true)
end

local function startTPFarm()
    tpFarmEnabled = true

    tpSteppedConnection = RunService.Stepped:Connect(function()
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local target = Players:FindFirstChild(tpFarmTarget)
        local targetCharacter = target and target.Character
        local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

        if humanoid and root and humanoid.Health > 0 and targetRoot then
            root.CFrame = targetRoot.CFrame + targetRoot.CFrame.LookVector * 3
        end
    end)

    tpRenderConnection = RunService.RenderStepped:Connect(function()
        local character = LocalPlayer.Character
        if not character then
            return
        end

        local tool = character:FindFirstChildOfClass("Tool")
        local shield = character:FindFirstChild("Foreshield")
        if not tool and not shield then
            equipBackpackTool(character)
        end
    end)

    tpCharacterConnection = LocalPlayer.CharacterAdded:Connect(prepareTPCharacter)
    prepareTPCharacter(LocalPlayer.Character)
end

TPFarmBox:AddToggle("TPFarmToggle", {
    Text = "TP Farm",
    Default = false,
    Callback = function(value)
        tpFarmEnabled = value
        if value then
            startTPFarm()
        else
            stopTPFarm()
        end
    end
})

TPFarmBox:AddInput("TPFarmTarget", {
    Text = "Type Username",
    Default = "",
    Placeholder = "Type Username",
    Numeric = false,
    Finished = false,
    Callback = function(value)
        tpFarmTarget = value
    end
})

local function attackPlayer(player, localRoot)
    local character = player.Character
    local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
    local targetHumanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
        return
    end

    if (localRoot.Position - targetRoot.Position).Magnitude > meleeAuraDistance then
        return
    end

    local localCharacter = LocalPlayer.Character
    local tool = localCharacter and localCharacter:FindFirstChildOfClass("Tool")
    if not tool then
        return
    end

    pcall(function()
        MeleeStart:InvokeServer("🍞", tick(), tool, "43TRFWX", "Normal", tick(), true)
        task.wait(0.3)
        MeleeHit:FireServer(
            "🍞",
            tick(),
            tool,
            "2389ZFX34",
            nil,
            true,
            tool:FindFirstChild("WeaponHandle"),
            character:FindFirstChild("Head"),
            character,
            localRoot.Position,
            targetRoot.Position
        )
    end)
end

local function stopMeleeAura()
    meleeAuraConnection = disconnect(meleeAuraConnection)
end

local function startMeleeAura()
    stopMeleeAura()
    meleeAuraEnabled = true

    meleeAuraConnection = RunService.RenderStepped:Connect(function()
        if not meleeAuraEnabled then
            return
        end

        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then
            return
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                attackPlayer(player, root)
            end
        end
    end)
end

MiscBox:AddToggle("MeleeAuraToggle", {
    Text = "Melee Aura",
    Default = false,
    Callback = function(value)
        meleeAuraEnabled = value
        if value then
            startMeleeAura()
        else
            stopMeleeAura()
        end
    end
})

MiscBox:AddSlider("MeleeAuraDistance", {
    Text = "Distance",
    Default = 15,
    Min = 1,
    Max = 15,
    Rounding = 0,
    Callback = function(value)
        meleeAuraDistance = value
    end
})

local function initializeStamina(character)
    if not character then
        return
    end

    character:WaitForChild("Humanoid", 5)

    local staminaObjects = {}
    for _, object in pairs(getgc(true)) do
        if typeof(object) == "table" and rawget(object, "S") ~= nil then
            table.insert(staminaObjects, object)
        end
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        local currentCharacter = LocalPlayer.Character
        if not currentCharacter or not currentCharacter:IsDescendantOf(workspace) then
            connection:Disconnect()
            return
        end

        if infiniteStaminaEnabled then
            for _, object in pairs(staminaObjects) do
                object.S = 100
            end
        end
    end)
end

MiscBox:AddToggle("InfiniteStaminaToggle", {
    Text = "Infinite Stamina",
    Tooltip = "Prevents stamina from draining",
    Default = true,
    Callback = function(value)
        infiniteStaminaEnabled = value
    end
})

initializeStamina(LocalPlayer.Character)
staminaCharacterConnection = LocalPlayer.CharacterAdded:Connect(initializeStamina)

local function startAntiAFK()
    LocalPlayer.Idled:Connect(function()
        if antiAFKEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

MiscBox:AddToggle("AntiAFKToggle", {
    Text = "Anti AFK",
    Default = true,
    Callback = function(value)
        antiAFKEnabled = value
        if value then
            startAntiAFK()
        end
    end
})

local function stopAutoRespawn()
    autoRespawnConnection = disconnect(autoRespawnConnection)
end

local function startAutoRespawn()
    stopAutoRespawn()
    autoRespawnConnection = RunService.RenderStepped:Connect(function()
        if not autoRespawnEnabled then
            return
        end

        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health <= 0 then
            DeathRespawn:InvokeServer("KMG4R904")
        end
    end)
end

MiscBox:AddToggle("AutoRespawnToggle", {
    Text = "Auto Respawn",
    Tooltip = "Automatically respawns you when dead",
    Default = true,
    Callback = function(value)
        autoRespawnEnabled = value
        if value then
            startAutoRespawn()
        else
            stopAutoRespawn()
        end
    end
})

startAutoRespawn()

local staffGroupIds = {
    4165692,
    8024440,
    32406137,
    14927228
}

local staffRoles = {
    Tester = true,
    Senior = true,
    Junior = true,
    Developer = true,
    Manager = true,
    Moderator = true,
    Owner = true,
    ["Tester+"] = true,
    Administrator = true,
    Holder = true,
    ["Developer+"] = true,
    Contributor = true,
    ["Community Manager"] = true
}

local staffUserIds = {
    [1163048] = true,
    [3111449] = true,
    [6514528] = true,
    [9066859] = true,
    [9212846] = true,
    [10497435] = true,
    [14855669] = true,
    [15598614] = true,
    [16983447] = true,
    [21831137] = true,
    [25048901] = true,
    [25689921] = true,
    [29706395] = true,
    [29761878] = true,
    [31365111] = true,
    [34616594] = true,
    [38578487] = true,
    [42066711] = true,
    [42662179] = true,
    [46567801] = true,
    [47352513] = true,
    [48058122] = true,
    [50585425] = true,
    [50801509] = true,
    [54087314] = true,
    [55476024] = true,
    [55893752] = true,
    [63238912] = true,
    [63315426] = true,
    [64489098] = true,
    [67180844] = true,
    [69262878] = true,
    [81275825] = true,
    [87189764] = true,
    [90814576] = true,
    [92504899] = true,
    [93281166] = true,
    [93428604] = true,
    [93676120] = true,
    [94693025] = true,
    [96783330] = true,
    [102045519] = true,
    [102146039] = true,
    [111250044] = true,
    [114332275] = true,
    [119861460] = true,
    [122209625] = true,
    [136584758] = true,
    [140172831] = true,
    [140837601] = true,
    [141193516] = true,
    [142821118] = true,
    [142989311] = true,
    [151691292] = true,
    [153835477] = true,
    [155413858] = true,
    [156152502] = true,
    [166406495] = true,
    [175931803] = true,
    [193945439] = true,
    [194512073] = true,
    [195538733] = true,
    [198610386] = true,
    [208929505] = true,
    [244844600] = true,
    [271400893] = true,
    [278097946] = true,
    [281593651] = true,
    [295331237] = true,
    [366613818] = true,
    [371665775] = true,
    [374665997] = true,
    [412741116] = true,
    [418086275] = true,
    [418199326] = true,
    [423005063] = true,
    [438805620] = true,
    [439942262] = true,
    [446849296] = true,
    [455275714] = true,
    [513615792] = true,
    [608073286] = true,
    [626833004] = true,
    [632886139] = true,
    [727189337] = true,
    [730176906] = true,
    [948293345] = true,
    [957835150] = true,
    [959606619] = true,
    [1024216621] = true,
    [1206543842] = true,
    [1229486091] = true,
    [1424338327] = true,
    [1517131734] = true,
    [1810535041] = true,
    [1863173316] = true,
    [1871290386] = true,
    [2457253857] = true,
    [3294804378] = true,
    [3659305297] = true,
    [3717066084] = true,
    [3923114296] = true,
    [3937697838] = true,
    [5005262660] = true,
    [5046659439] = true,
    [5046661126] = true,
    [5046662686] = true,
    [7713309208] = true
}

local function getStaffDetection(player)
    if not player or not player:IsA("Player") then
        return nil
    end

    for _, groupId in ipairs(staffGroupIds) do
        local okRank, rank = pcall(player.GetRankInGroup, player, groupId)
        if okRank and rank > 0 then
            local okRole, role = pcall(player.GetRoleInGroup, player, groupId)
            if okRole and staffRoles[role] then
                return string.format("- %s (Role: %s)", player.Name, role)
            end
        end
    end

    if staffUserIds[player.UserId] then
        return string.format("- %s (UserID: %d)", player.Name, player.UserId)
    end

    if not player:IsA("Player") then
        return nil
    end

    for _, child in ipairs(player:GetChildren()) do
        if child.Name == "Tracker$" then
            local trackedName = child.Name:gsub("Tracker$", "")
            local trackedPlayer = Players:FindFirstChild(trackedName)
            local tracking = trackedPlayer and trackedPlayer.Name or trackedName
            return string.format("- %s (Tracker: Active) - Tracking: %s", player.Name, tracking)
        end
    end

    return nil
end

local function kickForStaff(detections)
    if #detections == 0 then
        return
    end

    LocalPlayer:Kick("Staff joined\n\nStaff detected:\n" .. table.concat(detections, "\n"))
end

local function stopAdminCheck()
    adminCheckConnection = disconnect(adminCheckConnection)
end

local function startAdminCheck()
    adminCheckConnection = Players.PlayerAdded:Connect(function(player)
        if not adminCheckEnabled then
            return
        end

        local detection = getStaffDetection(player)
        if detection then
            kickForStaff({detection})
        end
    end)

    task.spawn(function()
        local detections = {}

        for _, player in ipairs(Players:GetPlayers()) do
            local detection = getStaffDetection(player)
            if detection then
                table.insert(detections, detection)
            end
        end

        if #detections > 0 then
            kickForStaff(detections)
            stopAdminCheck()
        end
    end)
end

MiscBox:AddToggle("AdminCheckToggle", {
    Text = "Admin Check",
    Tooltip = "Detects staff members via groups, UserIDs, and trackers",
    Default = true,
    Callback = function(value)
        adminCheckEnabled = value
        if value then
            startAdminCheck()
        end
    end
})

local function createTeleportToggle(id, text, position, connectionGetter, connectionSetter)
    TPFarmBox:AddToggle(id, {
        Text = text,
        Default = false,
        Callback = function(value)
            connectionSetter(disconnect(connectionGetter()))

            if value then
                connectionSetter(RunService.RenderStepped:Connect(function()
                    local character = LocalPlayer.Character
                    local root = character and character:FindFirstChild("HumanoidRootPart")
                    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                    if root and humanoid then
                        root.CFrame = CFrame.new(position)
                        if humanoid.Health <= 0 then
                            DeathRespawn:InvokeServer("KMG4R904")
                        end
                    end
                end))
            end
        end
    })
end

local saveCubePosition = Vector3.new(-4184.4, 102.7, 276.9)
local saveVibePosition = Vector3.new(-4857.5, -161.5, -918.3)
local saveMountainPosition = Vector3.new(-5896.5, 66.4, 3802.9)

createTeleportToggle(
    "SaveCubeToggle",
    "Teleport To Save Cube",
    saveCubePosition,
    function()
        return saveCubeConnection
    end,
    function(value)
        saveCubeConnection = value
    end
)

createTeleportToggle(
    "SaveVibeToggle",
    "Teleport To Vibecheck",
    saveVibePosition,
    function()
        return saveVibeConnection
    end,
    function(value)
        saveVibeConnection = value
    end
)

createTeleportToggle(
    "SaveMountainToggle",
    "Teleport To Mountain",
    saveMountainPosition,
    function()
        return saveMountainConnection
    end,
    function(value)
        saveMountainConnection = value
    end
)

local MenuBox = SettingsTab:AddLeftGroupbox("Menu")

MenuBox:AddToggle("KeybindMenuOpen", {
    Text = "Open Keybind Menu",
    Tooltip = "Show/hide the keybinds UI",
    Default = false,
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end
})

MenuBox:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Tooltip = "Enable/disable custom mouse cursor",
    Default = true,
    Callback = function(value)
        Library.ShowCustomCursor = value
    end
})

MenuBox:AddDropdown("NotificationSide", {
    Text = "Notification Side",
    Tooltip = "Where notifications will appear",
    Values = {"Left", "Right"},
    Default = "Right",
    Callback = function(value)
        Library:SetNotifySide(value)
    end
})

MenuBox:AddDropdown("DPIScale", {
    Text = "DPI Scale",
    Tooltip = "Adjust UI size",
    Values = {"50%", "75%", "100%", "125%", "150%", "175%", "200%"},
    Default = "100%",
    Callback = function(value)
        Library:SetDPIScale(tonumber(value:match("%d+")))
    end
})

MenuBox:AddDivider()
MenuBox:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightAlt",
    NoUI = true,
    Text = "Menu keybind"
})

MenuBox:AddButton("Unload Script", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind"})
ThemeManager:SetFolder("JX-CRIMINALITY-Alt-Farm")
SaveManager:SetFolder("JX-CRIMINALITY-Alt-Farm/CRIMINALITY-Alt-Farm")
SaveManager:SetSubFolder("CR1IMINALITY-Alt-Farm")
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)
SaveManager:LoadAutoloadConfig()
