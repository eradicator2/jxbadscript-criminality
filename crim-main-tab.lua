-- ============================================
-- MAIN TAB MODULE (Upload this to GitHub)
-- ============================================

local MainTabModule = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============ SILENT AIM V2 MODULE ============
function MainTabModule.CreateSilentAimV2()
    local SilentAim = {
        enabled = false,
        settings = {
            checkDowned = true,
            teamCheck = false,
            checkWhitelist = false,
            checkTarget = false,
            fovCircleCentered = false,
            drawColor = Color3.fromRGB(255, 255, 255),
            drawSize = 100,
            useHitChance = true,
            hitChance = 100,
            checkWall = true,
            targetPart = "Head",
            actualPart = "Head",
            drawCircle = false,
            targetChangeTime = 0.5,
            showHitPartNotification = false,
            notificationSize = 20,
            maxDistance = 120
        },
        currentTarget = nil,
        visualizeConnection = nil,
        randomizerTimer = 0
    }

    local ValidParts = {"Head", "HumanoidRootPart", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

    -- FOV Circle
    local circle = Drawing.new("Circle")
    circle.Visible = false
    circle.Transparency = 1
    circle.Thickness = 1.5
    circle.Filled = false

    -- Notification
    local notificationText = Drawing.new("Text")
    notificationText.Visible = false
    notificationText.Color = Color3.fromRGB(255, 255, 255)
    notificationText.Center = true
    notificationText.Outline = true
    notificationText.Font = 2

    local function UpdateCircleProps()
        circle.Color = SilentAim.settings.drawColor
        circle.Radius = SilentAim.settings.drawSize
    end

    local DrawCircleConnection
    local function UpdateCircle()
        if DrawCircleConnection then 
            DrawCircleConnection:Disconnect() 
            DrawCircleConnection = nil
        end
        if SilentAim.settings.drawCircle then
            circle.Visible = true
            UpdateCircleProps()
            local screenCenter = SilentAim.settings.fovCircleCentered and 
                Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or nil
            DrawCircleConnection = RunService.RenderStepped:Connect(function()
                circle.Position = screenCenter or UserInputService:GetMouseLocation()
            end)
        else
            circle.Visible = false
        end
    end

    local function ShowHitPartNotification(newPart)
        if not SilentAim.settings.showHitPartNotification then return end
        notificationText.Size = SilentAim.settings.notificationSize
        notificationText.Text = "New Hit Part: " .. newPart
        notificationText.Position = Vector2.new(Camera.ViewportSize.X - 200, Camera.ViewportSize.Y / 2)
        notificationText.Visible = true
        task.delay(1, function() 
            notificationText.Visible = false 
        end)
    end

    local randomTargetConnection
    local function StopRandomizer()
        if randomTargetConnection then
            randomTargetConnection:Disconnect()
            randomTargetConnection = nil
        end
    end

    local function StartRandomizer()
        StopRandomizer()
        if not SilentAim.enabled or SilentAim.settings.targetPart ~= "Random" then return end
        SilentAim.randomizerTimer = 0
        randomTargetConnection = RunService.Heartbeat:Connect(function(dt)
            SilentAim.randomizerTimer = (SilentAim.randomizerTimer or 0) + dt
            if SilentAim.randomizerTimer >= SilentAim.settings.targetChangeTime then
                local currentPart = SilentAim.settings.actualPart
                local newPart = ValidParts[math.random(1, #ValidParts)]
                if newPart ~= currentPart then
                    SilentAim.settings.actualPart = newPart
                    ShowHitPartNotification(newPart)
                end
                SilentAim.randomizerTimer = 0
            end
        end)
    end

    local function IsPlayerDowned(p)
        if not p or not p.Character then return false end
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 15 then return true end
        
        local cs = p.Character:FindFirstChild("CharStats")
        if cs then
            local downed = cs:FindFirstChild("Downed")
            if downed and typeof(downed.Value) == "boolean" then
                return downed.Value
            end
        end
        return false
    end

    local function GetSilentAimTarget(IsPlayerWhitelisted, IsPlayerTargeted)
        if not SilentAim.enabled then return nil end
        local closest, minDist = nil, SilentAim.settings.drawSize
        local screenCenter = SilentAim.settings.fovCircleCentered and 
            Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or UserInputService:GetMouseLocation()
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return nil end

        for _, player in pairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if SilentAim.settings.teamCheck and player.Team == LocalPlayer.Team then continue end
            if SilentAim.settings.checkWhitelist and IsPlayerWhitelisted and IsPlayerWhitelisted(player) then continue end
            if SilentAim.settings.checkTarget and IsPlayerTargeted and not IsPlayerTargeted(player) then continue end
            
            local character = player.Character
            if not character then continue end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root or humanoid.Health <= 0 or character:FindFirstChildOfClass("ForceField") then continue end
            if SilentAim.settings.checkDowned and IsPlayerDowned(player) then continue end

            local partName = SilentAim.settings.targetPart == "Random" and SilentAim.settings.actualPart or SilentAim.settings.targetPart
            local part = character:FindFirstChild(partName)
            if not part then continue end

            if (localRoot.Position - part.Position).Magnitude > SilentAim.settings.maxDistance then continue end
            if SilentAim.settings.checkWall then
                local parts = Camera:GetPartsObscuringTarget({part.Position}, {Camera, LocalPlayer.Character, character})
                if #parts > 0 then continue end
            end

            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen then
                local distance = (screenCenter - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                if distance < minDist then
                    closest = player
                    minDist = distance
                end
            end
        end

        if closest and SilentAim.settings.useHitChance and math.random(1, 100) > SilentAim.settings.hitChance then
            return nil
        end
        return closest
    end

    function SilentAim:Toggle(val, IsPlayerWhitelisted, IsPlayerTargeted)
        self.enabled = val
        
        if self.visualizeConnection then 
            self.visualizeConnection:Disconnect() 
            self.visualizeConnection = nil
        end
        if self.silentAimTask then 
            task.cancel(self.silentAimTask) 
            self.silentAimTask = nil
        end

        if val then
            self.silentAimTask = task.spawn(function()
                while self.enabled do
                    self.currentTarget = GetSilentAimTarget(IsPlayerWhitelisted, IsPlayerTargeted)
                    task.wait(0.1)
                end
            end)
            StartRandomizer()

            local success1, visualizeEvent = pcall(function()
                return ReplicatedStorage:WaitForChild("Events2", 5):WaitForChild("Visualize", 5)
            end)
            
            local success2, damageEvent = pcall(function()
                return ReplicatedStorage:WaitForChild("Events", 5):WaitForChild("ZFKLF__H", 5)
            end)

            if success1 and success2 and visualizeEvent and damageEvent then
                self.visualizeConnection = visualizeEvent.Event:Connect(function(_, shotCode, _, gun, _, startPos, bulletsPerShot)
                    local target = self.currentTarget
                    if not self.enabled or not gun or not target or not target.Character then return end
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if not tool or gun ~= tool or target.Character:FindFirstChildOfClass("ForceField") then return end

                    local partName = self.settings.targetPart == "Random" and self.settings.actualPart or self.settings.targetPart
                    local validPartName = partName
                    if partName == "HumanoidRootPart" then
                        validPartName = target.Character:FindFirstChild("UpperTorso") and "UpperTorso" or
                                       target.Character:FindFirstChild("Torso") and "Torso" or
                                       target.Character:FindFirstChild("LowerTorso") and "LowerTorso" or "Head"
                    end

                    local hitPart = target.Character:FindFirstChild(validPartName)
                    if not hitPart then return end

                    local hitPos = hitPart.Position
                    local bullets = {}
                    local bulletCount = type(bulletsPerShot) == "table" and #bulletsPerShot or 1
                    for i = 1, math.clamp(bulletCount, 1, 100) do
                        bullets[i] = CFrame.new(startPos, hitPos).LookVector
                    end

                    task.wait(0.005)
                    for idx, direction in pairs(bullets) do
                        pcall(function()
                            damageEvent:FireServer("🧈", gun, shotCode, idx, hitPart, hitPos, direction)
                        end)
                    end

                    if gun:FindFirstChild("Hitmarker") then
                        pcall(function()
                            gun.Hitmarker:Fire(hitPart)
                        end)
                    end
                end)
            end
        else
            StopRandomizer()
        end
    end

    function SilentAim:UpdateCircle()
        UpdateCircle()
    end

    function SilentAim:UpdateCircleProps()
        UpdateCircleProps()
    end

    function SilentAim:StartRandomizer()
        StartRandomizer()
    end

    function SilentAim:StopRandomizer()
        StopRandomizer()
    end

    return SilentAim
end

-- ============ OPTIMIZED SILENT AIM V1 MODULE ============
function MainTabModule.CreateSilentAimV1()
    local SilentAimV1 = {
        enabled = false,
        settings = {
            targetPart = "Head",
            hitChance = 100,
            wallCheck = true,
            maxDistance = 750,
            showFOVCircle = false,
            fovSize = 100,
            fovCircleCentered = false,
            checkDowned = true,
            teamCheck = false,
            checkWhitelist = false,
            checkTarget = false,
            useHitChance = true
        },
        validTargets = {},
        lastUpdateTime = 0,
        updateInterval = 0.05, -- Update every 50ms instead of every frame
        cachedPlayers = {},
        lastPlayerCount = 0
    }

    -- Cached FOV Circle (reuse instead of recreating)
    local FOVCircle = Drawing.new("Circle")
    FOVCircle.Color = Color3.new(1, 1, 1)
    FOVCircle.Thickness = 2
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.5
    FOVCircle.Visible = false
    FOVCircle.Radius = 100

    -- Cached raycast params (reuse instead of creating new ones)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true

    local FOVCircleConnection
    local function UpdateCircle()
        if FOVCircleConnection then
            FOVCircleConnection:Disconnect()
            FOVCircleConnection = nil
        end

        if SilentAimV1.settings.showFOVCircle then
            FOVCircle.Visible = true
            FOVCircle.Radius = SilentAimV1.settings.fovSize
            
            -- Reduced frequency circle updates
            FOVCircleConnection = RunService.Heartbeat:Connect(function()
                if SilentAimV1.settings.fovCircleCentered then
                    local screenSize = Camera.ViewportSize
                    FOVCircle.Position = Vector2.new(screenSize.X * 0.5, screenSize.Y * 0.5)
                else
                    FOVCircle.Position = UserInputService:GetMouseLocation()
                end
            end)
        else
            FOVCircle.Visible = false
        end
    end

    -- Optimized downed check with caching
    local downedCache = {}
    local downedCacheTime = {}
    local DOWNED_CACHE_DURATION = 0.5

    local function IsPlayerDowned(p)
        if not p or not p.Character then return false end
        
        local currentTime = tick()
        local playerId = p.UserId
        
        -- Check cache first
        if downedCache[playerId] and downedCacheTime[playerId] and 
           (currentTime - downedCacheTime[playerId]) < DOWNED_CACHE_DURATION then
            return downedCache[playerId]
        end
        
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 15 then 
            downedCache[playerId] = true
            downedCacheTime[playerId] = currentTime
            return true 
        end
        
        local cs = p.Character:FindFirstChild("CharStats")
        if cs then
            local downed = cs:FindFirstChild("Downed")
            if downed and typeof(downed.Value) == "boolean" then
                downedCache[playerId] = downed.Value
                downedCacheTime[playerId] = currentTime
                return downed.Value
            end
        end
        
        downedCache[playerId] = false
        downedCacheTime[playerId] = currentTime
        return false
    end

    -- Optimized player filtering
    local function UpdateCachedPlayers()
        local currentPlayerCount = #Players:GetPlayers()
        if currentPlayerCount == SilentAimV1.lastPlayerCount then
            return -- No change in player count, skip update
        end
        
        SilentAimV1.cachedPlayers = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not (SilentAimV1.settings.teamCheck and player.Team == LocalPlayer.Team) then
                    table.insert(SilentAimV1.cachedPlayers, player)
                end
            end
        end
        SilentAimV1.lastPlayerCount = currentPlayerCount
    end

    local renderConnection
    function SilentAimV1:Toggle(val, IsPlayerWhitelisted, IsPlayerTargeted)
        self.enabled = val

        if renderConnection then
            renderConnection:Disconnect()
            renderConnection = nil
        end

        if val then
            -- Use Heartbeat instead of RenderStepped for better performance
            renderConnection = RunService.Heartbeat:Connect(function()
                local currentTime = tick()
                
                -- Throttle updates to reduce CPU usage
                if currentTime - self.lastUpdateTime < self.updateInterval then
                    return
                end
                self.lastUpdateTime = currentTime
                
                self.validTargets = {}
                if not self.enabled then return end

                local character = LocalPlayer.Character
                if not character then return end
                local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
                if not root then return end

                local origin = Camera.CFrame.Position
                local screenCenter = self.settings.fovCircleCentered and 
                    Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5) or 
                    UserInputService:GetMouseLocation()

                -- Update cached players less frequently
                UpdateCachedPlayers()

                -- Pre-calculate common values
                local maxDistanceSquared = self.settings.maxDistance * self.settings.maxDistance
                local fovSizeSquared = self.settings.fovSize * self.settings.fovSize

                for _, player in ipairs(self.cachedPlayers) do
                    -- Quick validity checks first
                    if self.settings.checkWhitelist and IsPlayerWhitelisted and IsPlayerWhitelisted(player) then continue end
                    if self.settings.checkTarget and IsPlayerTargeted and not IsPlayerTargeted(player) then continue end
                    
                    local targetChar = player.Character
                    if not targetChar then continue end

                    local humanoid = targetChar:FindFirstChildOfClass("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then continue end
                    if targetChar:FindFirstChildOfClass("ForceField") then continue end
                    if self.settings.checkDowned and IsPlayerDowned(player) then continue end

                    local targetPart = targetChar:FindFirstChild(self.settings.targetPart)
                    if not targetPart then continue end

                    -- Use squared distance for faster comparison
                    local distanceSquared = (origin - targetPart.Position).Magnitude
                    if distanceSquared > maxDistanceSquared then continue end

                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if not onScreen then continue end
                    
                    -- Use squared magnitude for FOV check
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter)
                    local magSquared = screenDistance.X * screenDistance.X + screenDistance.Y * screenDistance.Y
                    if magSquared > fovSizeSquared then continue end

                    -- Wall check (most expensive operation, do it last)
                    if self.settings.wallCheck then
                        -- Update filter for raycast
                        raycastParams.FilterDescendantsInstances = {character, Camera}
                        
                        local result = Workspace:Raycast(origin, (targetPart.Position - origin).Unit * self.settings.maxDistance, raycastParams)
                        if not result or not result.Instance or not result.Instance:IsDescendantOf(targetChar) then
                            continue
                        end
                    end

                    table.insert(self.validTargets, {
                        Player = player, 
                        Part = targetPart,
                        ScreenDistance = math.sqrt(magSquared) -- Only calculate sqrt when needed
                    })
                end

                -- Sort by screen distance (only if we have targets)
                if #self.validTargets > 1 then
                    table.sort(self.validTargets, function(a, b)
                        return a.ScreenDistance < b.ScreenDistance
                    end)
                end
            end)

            -- Optimized Raycast Override
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local args = {...}
                local method = getnamecallmethod()

                if not checkcaller() and SilentAimV1.enabled and method == "Raycast" then
                    if #SilentAimV1.validTargets > 0 then
                        if not SilentAimV1.settings.useHitChance or math.random(1, 100) <= SilentAimV1.settings.hitChance then
                            local target = SilentAimV1.validTargets[1]
                            if target and target.Part then
                                local origin = Camera.CFrame.Position
                                local direction = (target.Part.Position - origin).Unit * 9999
                                args[2] = direction
                                return oldNamecall(self, unpack(args))
                            end
                        end
                    end
                end

                return oldNamecall(self, ...)
            end)
        end
    end

    function SilentAimV1:UpdateCircle()
        UpdateCircle()
    end

    -- Cleanup function to clear caches
    function SilentAimV1:Cleanup()
        downedCache = {}
        downedCacheTime = {}
        self.cachedPlayers = {}
        self.validTargets = {}
    end

    return SilentAimV1
end

-- ============ RAGE BOT MODULE ============
function MainTabModule.CreateRageBot()
    local RageBot = {
        enabled = false,
        settings = {
            checkDowned = true,
            wallCheck = true,
            hitlogEnabled = true,
            checkWhitelist = false,
            checkTarget = false,
            useFOV = false,
            teamCheck = false,
            fovRadius = 75,
            shootSpeed = 15,
            fireInterval = 0.17,
            maxDistance = 100,
            bulletTracerEnabled = false,
            tracerColor = Color3.fromRGB(255, 0, 0),
            showFOV = false
        },
        loopTask = nil,
        lastShotTime = 0,
        lastHitNotify = {}
    }

    local NOTIFY_COOLDOWN = 0.35
    local WallbangSamples = 72
    local WallbangRadius = 10
    local WallbangHeight = 6

    local RageCircle = Drawing.new("Circle")
    RageCircle.Color = Color3.fromRGB(255, 255, 255)
    RageCircle.Thickness = 1.5
    RageCircle.Filled = false
    RageCircle.Transparency = 0.5
    RageCircle.Radius = 75
    RageCircle.Visible = false

    local RageCircleConnection
    local function UpdateRageCircle()
        if RageCircleConnection then
            RageCircleConnection:Disconnect()
            RageCircleConnection = nil
        end
        
        if RageBot.settings.showFOV then
            RageCircle.Visible = true
            RageCircle.Radius = RageBot.settings.fovRadius
            RageCircleConnection = RunService.RenderStepped:Connect(function()
                RageCircle.Position = UserInputService:GetMouseLocation()
            end)
        else
            RageCircle.Visible = false
        end
    end

    local function createTracer(startPos, endPos)
        if not RageBot.settings.bulletTracerEnabled then return end
        local tracer = Instance.new("Part")
        tracer.Anchored = true
        tracer.CanCollide = false
        tracer.Material = Enum.Material.Neon
        tracer.Color = RageBot.settings.tracerColor
        tracer.Shape = Enum.PartType.Cylinder
        local distance = (startPos - endPos).Magnitude
        tracer.Size = Vector3.new(distance, 0.12, 0.12)
        tracer.CFrame = CFrame.new((startPos + endPos) / 2, endPos) * CFrame.Angles(0, math.pi / 2, 0)
        tracer.Parent = Workspace
        coroutine.wrap(function()
            for t = 0, 1, 0.02 do
                if tracer then
                    tracer.Transparency = t
                    task.wait(1/50)
                end
            end
            if tracer then tracer:Destroy() end
        end)()
    end

    local function RandomString(len)
        local s = ""
        for i = 1, len do s = s .. string.char(math.random(97, 122)) end
        return s
    end

    local function IsPlayerDowned(p)
        if not p or not p.Character then return false end
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 15 then return true end
        
        local cs = p.Character:FindFirstChild("CharStats")
        if cs then
            local downed = cs:FindFirstChild("Downed")
            if downed and typeof(downed.Value) == "boolean" then
                return downed.Value
            end
        end
        return false
    end

    local function IsValidTarget(p, IsPlayerWhitelisted, IsPlayerTargeted)
        if not p or not p.Character then return false end
        if p == LocalPlayer then return false end
        if RageBot.settings.teamCheck and p.Team == LocalPlayer.Team then return false end
        if RageBot.settings.checkWhitelist and IsPlayerWhitelisted(p) then return false end
        if RageBot.settings.checkTarget and not IsPlayerTargeted(p) then return false end
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return false end
        if hum.Health <= 0 then return false end
        if p.Character:FindFirstChildOfClass("ForceField") then return false end
        if RageBot.settings.checkDowned and IsPlayerDowned(p) then return false end
        return true
    end

    local function GetHeadPart(char)
        if not char then return nil end
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    end

    local function MakeRaycastParams()
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Blacklist
        rp.FilterDescendantsInstances = {}
        if LocalPlayer.Character then
            table.insert(rp.FilterDescendantsInstances, LocalPlayer.Character)
        end
        rp.IgnoreWater = true
        return rp
    end

    local function FindWallbangPoint(origin, targetPart)
        if not origin or not targetPart then return nil end
        local base = targetPart.Position
        local rp = MakeRaycastParams()
        for i = 1, WallbangSamples do
            local angle = (i / WallbangSamples) * math.pi * 2
            local r = WallbangRadius * (0.6 + math.random() * 0.8)
            local yOff = (math.random() * 2 - 1) * WallbangHeight
            local offset = Vector3.new(math.cos(angle) * r, yOff, math.sin(angle) * r)
            local testPoint = base + offset
            local dir = (testPoint - origin)
            if dir.Magnitude > 0 then
                local result = Workspace:Raycast(origin, dir, rp)
                if result then
                    if result.Instance and result.Instance:IsDescendantOf(targetPart.Parent) then
                        return testPoint
                    else
                        local distHitToTarget = (result.Position - base).Magnitude
                        if distHitToTarget <= 2.0 then
                            return testPoint
                        end
                    end
                else
                    return testPoint
                end
            end
        end
        return nil
    end

    local function GetClosestEnemy(IsPlayerWhitelisted, IsPlayerTargeted)
        local me = LocalPlayer.Character
        if not me or not me:FindFirstChild("HumanoidRootPart") then return nil end
        local closest, shortest = nil, math.huge
        local originPos = me.HumanoidRootPart.Position

        for _, p in ipairs(Players:GetPlayers()) do
            if IsValidTarget(p, IsPlayerWhitelisted, IsPlayerTargeted) then
                local head = GetHeadPart(p.Character)
                if head then
                    local dist3D = (originPos - head.Position).Magnitude
                    if dist3D <= RageBot.settings.maxDistance then
                        if RageBot.settings.useFOV then
                            local mousePos = UserInputService:GetMouseLocation()
                            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                            if onScreen then
                                local d2 = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                                if d2 <= RageBot.settings.fovRadius and d2 < shortest then
                                    shortest = d2
                                    closest = p
                                end
                            end
                        else
                            if dist3D < shortest then
                                shortest = dist3D
                                closest = p
                            end
                        end
                    end
                end
            end
        end
        return closest
    end

    local function SendHitNotification(targetPlayer, health, Library)
        if not RageBot.settings.hitlogEnabled then return end
        if not targetPlayer then return end
        local now = tick()
        local id = targetPlayer.UserId or targetPlayer.Name
        if RageBot.lastHitNotify[id] and now - RageBot.lastHitNotify[id] < NOTIFY_COOLDOWN then
            return
        end
        RageBot.lastHitNotify[id] = now

        if typeof(Library) == "table" and type(Library.Notify) == "function" then
            pcall(function()
                Library:Notify({
                    Title = "HitLog",
                    Description = "Hit " .. (targetPlayer.Name or "Unknown") .. " | Health: " .. tostring(math.floor(tonumber(health) or 0)),
                    Time = 2
                })
            end)
        end
    end

    local function Shoot(target, Library)
        if not target or not target.Character then return end
        local head = GetHeadPart(target.Character)
        if not head then return end
        if not LocalPlayer.Character then return end
        local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if not tool then return end
        local values = tool:FindFirstChild("Values")
        local hitMarker = tool:FindFirstChild("Hitmarker")
        if not values or not hitMarker then return end
        local ammo = values:FindFirstChild("SERVER_Ammo")
        if not ammo or ammo.Value <= 0 then return end

        local handle = tool:FindFirstChild("WeaponHandle")
        local origin = (handle and handle.Position) or Camera.CFrame.Position
        local aimPos = head.Position
        local dir = (aimPos - origin)
        local rp = MakeRaycastParams()

        local ray = Workspace:Raycast(origin, dir, rp)
        local lineOfSight = false
        if ray and ray.Instance and ray.Instance:IsDescendantOf(target.Character) then
            lineOfSight = true
        elseif not ray then
            lineOfSight = true
        end

        local chosenAimPoint = aimPos
        local wallbangFound = false
        if not lineOfSight then
            local found = FindWallbangPoint(origin, head)
            if found then
                chosenAimPoint = found
                wallbangFound = true
            end
        end

        if not lineOfSight and RageBot.settings.wallCheck and not wallbangFound then
            return
        end

        local finalDir = (chosenAimPoint - origin).Unit
        local key = RandomString(30) .. "0"

        pcall(function()
            if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("GNX_S") then
                ReplicatedStorage.Events.GNX_S:FireServer(tick(), key, tool, "FDS9I83", origin, {finalDir}, false)
            end
        end)
        pcall(function()
            if ReplicatedStorage and ReplicatedStorage:FindFirstChild("Events") and ReplicatedStorage.Events:FindFirstChild("ZFKLF__H") then
                ReplicatedStorage.Events.ZFKLF__H:FireServer("🧈", tool, key, 1, head, chosenAimPoint, finalDir)
            end
        end)

        ammo.Value = math.max(0, ammo.Value - 1)
        pcall(function() hitMarker:Fire(head) end)
        createTracer(origin, chosenAimPoint)

        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        local remaining = hum and hum.Health or 0
        SendHitNotification(target, remaining, Library)
    end

    function RageBot:Toggle(val, IsPlayerWhitelisted, IsPlayerTargeted, Library)
        self.enabled = val
        if val then
            if self.loopTask then return end
            self.loopTask = task.spawn(function()
                while self.enabled and LocalPlayer.Character do
                    local ok, tool = pcall(function() return LocalPlayer.Character:FindFirstChildOfClass("Tool") end)
                    if not ok or not tool then
                        task.wait(0.2)
                        continue
                    end

                    local target = GetClosestEnemy(IsPlayerWhitelisted, IsPlayerTargeted)
                    if target then
                        local now = tick()
                        if now - self.lastShotTime >= self.settings.fireInterval then
                            Shoot(target, Library)
                            self.lastShotTime = now
                        end
                    end
                    task.wait(0.05)
                end
                self.loopTask = nil
            end)
        end
    end

    function RageBot:UpdateShootSpeed(val)
        self.settings.shootSpeed = val
        self.settings.fireInterval = math.max(0.03, 0.35 - (val * 0.012))
    end

    function RageBot:UpdateFOVCircle()
        UpdateRageCircle()
    end

    return RageBot
end

-- ============ AIMBOT MODULE ============
function MainTabModule.CreateAimbot()
    local Aimbot = {
        enabled = false,
        settings = {
            usePrediction = false,
            wallCheckEnabled = true,
            lockKeyActive = false,
            lockedTarget = nil,
            predictionMultiplier = 0.10,
            showFOV = false,
            fovRadius = 150,
            teamCheckEnabled = false,
            checkWhitelist = false,
            checkTarget = false,
            checkDowned = false,
            lockedPart = "Head",
            lockMethod = "Toggle",
            showCircleButton = false,
            circleCenterOnly = false,
            randomChangeTime = 0.5,
            currentRandomPart = "Head",
            randomTimer = 0,
            smoothingX = 25,
            smoothingY = 25,
            circleSize = 40,
            circleXPercent = 50,
            circleYPercent = 50,
            autoChangeTarget = true,
            lockMouseButton = Enum.UserInputType.MouseButton2  -- UPDATED: Default to MB2 (Right Click)
        },
        gui = nil,
        fovCircle = nil,
        button = nil,
        IsPlayerWhitelisted = nil,
        IsPlayerTargeted = nil
    }

    local aimbotGUI = Instance.new("ScreenGui")
    aimbotGUI.Name = "AimbotGUI"
    aimbotGUI.Parent = game.CoreGui
    Aimbot.gui = aimbotGUI

    local aimbotFovCircle = Drawing.new("Circle")
    aimbotFovCircle.Color = Color3.fromRGB(255, 255, 255)
    aimbotFovCircle.Thickness = 1
    aimbotFovCircle.Filled = false
    aimbotFovCircle.Transparency = 0.5
    aimbotFovCircle.Radius = 150
    aimbotFovCircle.Visible = false
    Aimbot.fovCircle = aimbotFovCircle

    local FOVCircleConnection
    local function UpdateFOVCircle()
        if FOVCircleConnection then
            FOVCircleConnection:Disconnect()
            FOVCircleConnection = nil
        end
        
        if Aimbot.settings.showFOV then
            aimbotFovCircle.Visible = true
            aimbotFovCircle.Radius = Aimbot.settings.fovRadius
            FOVCircleConnection = RunService.RenderStepped:Connect(function()
                if Aimbot.settings.circleCenterOnly then
                    aimbotFovCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                else
                    aimbotFovCircle.Position = UserInputService:GetMouseLocation()
                end
            end)
        else
            aimbotFovCircle.Visible = false
        end
    end

    local function IsPlayerDowned(p)
        if not p or not p.Character then return false end
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 15 then return true end
        
        local cs = p.Character:FindFirstChild("CharStats")
        if cs then
            local downed = cs:FindFirstChild("Downed")
            if downed and typeof(downed.Value) == "boolean" then
                return downed.Value
            end
        end
        return false
    end

    local function GetClosestPlayerInFOV()
        local shortest = math.huge
        local fovCenter = Aimbot.settings.circleCenterOnly and 
            Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or 
            UserInputService:GetMouseLocation()
        local best = nil
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then return nil end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if not humanoid or humanoid.Health <= 0 then continue end
                if Aimbot.settings.teamCheckEnabled and player.Team == LocalPlayer.Team then continue end
                if Aimbot.settings.checkWhitelist and Aimbot.IsPlayerWhitelisted and Aimbot.IsPlayerWhitelisted(player) then continue end
                if Aimbot.settings.checkTarget and Aimbot.IsPlayerTargeted and not Aimbot.IsPlayerTargeted(player) then continue end
                if Aimbot.settings.checkDowned and IsPlayerDowned(player) then continue end

                local partName = (Aimbot.settings.lockedPart == "Random" and Aimbot.settings.currentRandomPart) or Aimbot.settings.lockedPart
                local part = player.Character:FindFirstChild(partName)
                if not part then continue end

                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - fovCenter).Magnitude
                    if distance < Aimbot.settings.fovRadius and distance < shortest then
                        if Aimbot.settings.wallCheckEnabled then
                            local origin = Camera.CFrame.Position
                            local direction = (part.Position - origin)
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            
                            local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
                            if raycastResult and not raycastResult.Instance:IsDescendantOf(player.Character) then
                                continue
                            end
                        end
                        best = player
                        shortest = distance
                    end
                end
            end
        end
        return best
    end

    local function SmoothAim(targetPosition)
        if not targetPosition then return end
        
        local currentCFrame = Camera.CFrame
        local targetCFrame = CFrame.new(currentCFrame.Position, targetPosition)
        
        local currentLook = currentCFrame.LookVector
        local targetLook = targetCFrame.LookVector
        
        local smoothFactorX = math.min(1, Aimbot.settings.smoothingX / 50)
        local smoothFactorY = math.min(1, Aimbot.settings.smoothingY / 50)
        
        local smoothedLookX = currentLook:lerp(targetLook, smoothFactorX)
        local smoothedLookY = currentLook:lerp(targetLook, smoothFactorY)
        
        local finalLook = Vector3.new(
            smoothedLookX.X,
            smoothedLookY.Y,
            (smoothedLookX.Z + smoothedLookY.Z) / 2
        ).Unit
        
        Camera.CFrame = CFrame.new(currentCFrame.Position, currentCFrame.Position + finalLook)
    end

    function Aimbot:CreateCircleButton()
        if self.button then return end
        
        local button = Instance.new("TextButton")
        button.Parent = self.gui
        button.Name = "LockButton"
        button.BackgroundColor3 = Color3.new(0, 0, 0)
        button.Size = UDim2.new(0, self.settings.circleSize, 0, self.settings.circleSize)
        button.TextSize = 12
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Text = "Lock"

        Instance.new("UICorner", button).CornerRadius = UDim.new(1, 8)
        local stroke = Instance.new("UIStroke", button)
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = Color3.new(1, 1, 1)
        stroke.LineJoinMode = Enum.LineJoinMode.Round
        stroke.Thickness = 1

        button.MouseButton1Click:Connect(function()
            if self.enabled then
                if self.settings.lockMethod == "Toggle" then
                    self.settings.lockKeyActive = not self.settings.lockKeyActive
                    if not self.settings.lockKeyActive then
                        self.settings.lockedTarget = nil
                    end
                elseif self.settings.lockMethod == "Hold" then
                    self.settings.lockKeyActive = true
                end
            end
        end)

        self.button = button
        self:UpdateButtonPosition()
    end

    function Aimbot:UpdateButtonPosition()
        if not self.button then return end
        self.button.Size = UDim2.new(0, self.settings.circleSize, 0, self.settings.circleSize)
        self.button.Position = UDim2.new(
            self.settings.circleXPercent / 100, -self.settings.circleSize / 2,
            self.settings.circleYPercent / 100, -self.settings.circleSize / 2
        )
    end

    function Aimbot:Toggle(val)
        self.enabled = val
        if not val then
            self.settings.lockKeyActive = false
            self.settings.lockedTarget = nil
        end
    end

    function Aimbot:UpdateFOVCircle()
        UpdateFOVCircle()
    end

    -- UPDATED: Setup input bindings with MB1/MB2 support
    function Aimbot:SetupInputBindings()
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed or not self.enabled or self.settings.showCircleButton then return end
            
            -- Check for mouse button input
            if input.UserInputType == self.settings.lockMouseButton then
                if self.settings.lockMethod == "Hold" then
                    self.settings.lockKeyActive = true
                elseif self.settings.lockMethod == "Toggle" then
                    self.settings.lockKeyActive = not self.settings.lockKeyActive
                    if not self.settings.lockKeyActive then
                        self.settings.lockedTarget = nil
                    end
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if self.settings.lockMethod ~= "Hold" or self.settings.showCircleButton or not self.enabled then return end
            
            -- Check for mouse button release
            if input.UserInputType == self.settings.lockMouseButton then
                self.settings.lockKeyActive = false
                self.settings.lockedTarget = nil
            end
        end)
    end

    function Aimbot:StartMainLoop()
        RunService.RenderStepped:Connect(function(deltaTime)
            -- Random part selection
            if self.settings.lockedPart == "Random" then
                self.settings.randomTimer = self.settings.randomTimer + deltaTime
                if self.settings.randomTimer >= self.settings.randomChangeTime then
                    local parts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
                    self.settings.currentRandomPart = parts[math.random(1, #parts)]
                    self.settings.randomTimer = 0
                end
            end

            -- Smart auto change target logic
            if self.settings.autoChangeTarget and self.settings.lockKeyActive then
                local needsNewTarget = false
                
                if self.settings.lockedTarget and self.settings.lockedTarget.Character then
                    local humanoid = self.settings.lockedTarget.Character:FindFirstChild("Humanoid")
                    
                    -- Check if target died
                    if not humanoid or humanoid.Health <= 0 then
                        needsNewTarget = true
                    end
                    
                    -- Check if target is downed
                    if self.settings.checkDowned and IsPlayerDowned(self.settings.lockedTarget) then
                        needsNewTarget = true
                    end
                    
                    -- Check if target is behind wall
                    if self.settings.wallCheckEnabled and not needsNewTarget then
                        local partName = (self.settings.lockedPart == "Random" and self.settings.currentRandomPart) or self.settings.lockedPart
                        local targetPart = self.settings.lockedTarget.Character:FindFirstChild(partName)
                        
                        if targetPart then
                            local origin = Camera.CFrame.Position
                            local direction = (targetPart.Position - origin)
                            local raycastParams = RaycastParams.new()
                            raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
                            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                            
                            local raycastResult = Workspace:Raycast(origin, direction, raycastParams)
                            if raycastResult and not raycastResult.Instance:IsDescendantOf(self.settings.lockedTarget.Character) then
                                needsNewTarget = true
                            end
                        end
                    end
                    
                    -- Check if target is out of FOV
                    if not needsNewTarget then
                        local partName = (self.settings.lockedPart == "Random" and self.settings.currentRandomPart) or self.settings.lockedPart
                        local targetPart = self.settings.lockedTarget.Character:FindFirstChild(partName)
                        
                        if targetPart then
                            local fovCenter = self.settings.circleCenterOnly and 
                                Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2) or 
                                UserInputService:GetMouseLocation()
                            
                            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                            if onScreen then
                                local distance = (Vector2.new(screenPos.X, screenPos.Y) - fovCenter).Magnitude
                                if distance >= self.settings.fovRadius then
                                    needsNewTarget = true
                                end
                            else
                                needsNewTarget = true
                            end
                        end
                    end
                else
                    needsNewTarget = true
                end
                
                if needsNewTarget then
                    self.settings.lockedTarget = GetClosestPlayerInFOV()
                end
            end

            -- Main aimbot logic
            if self.enabled and self.settings.lockKeyActive and 
               self.settings.lockedTarget and self.settings.lockedTarget.Character then
                
                local partName = (self.settings.lockedPart == "Random" and self.settings.currentRandomPart) or self.settings.lockedPart
                local targetPart = self.settings.lockedTarget.Character:FindFirstChild(partName)
                
                if targetPart then
                    local aimPosition = targetPart.Position
                    
                    if self.settings.usePrediction and self.settings.lockedTarget.Character:FindFirstChild("HumanoidRootPart") then
                        local velocity = self.settings.lockedTarget.Character.HumanoidRootPart.Velocity
                        aimPosition = aimPosition + (velocity * self.settings.predictionMultiplier)
                    end
                    
                    SmoothAim(aimPosition)
                end
            end
        end)
    end

    return Aimbot
end

-- ============ MELEE AURA MODULE ============
function MainTabModule.CreateMeleeAura()
    local MeleeAura = {
        enabled = false,
        settings = {
            showAnim = false,
            targetPart = "Head",
            checkDowned = true,
            teamCheck = false,
            checkWhitelist = false,
            checkTarget = false,
            distance = 10,
            targetChangeTime = 0.5
        },
        randomPart = "Head"
    }

    local ValidParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

    local function IsDowned(player)
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid then return true end
        if humanoid.Health <= 15 then return true end

        local stats = character:FindFirstChild("CharStats")
        if not stats then
            for _ = 1, 5 do
                task.wait(0.1)
                stats = character:FindFirstChild("CharStats")
                if stats then break end
            end
        end
        local downed = stats and stats:FindFirstChild("Downed")
        if downed and downed:IsA("BoolValue") then
            return downed.Value == true
        end

        return false
    end

    function MeleeAura:StartRandomizer()
        task.spawn(function()
            while true do
                if self.enabled and self.settings.targetPart == "Random" then
                    self.randomPart = ValidParts[math.random(1, #ValidParts)]
                    task.wait(self.settings.targetChangeTime)
                else
                    task.wait(0.5)
                end
            end
        end)
    end

    function MeleeAura:StartMainLoop(IsPlayerWhitelisted, IsPlayerTargeted)
        task.spawn(function()
            local remote1, remote2
            
            pcall(function()
                remote1 = ReplicatedStorage:WaitForChild("Events", 5):WaitForChild("XMHH.2", 5)
                remote2 = ReplicatedStorage:WaitForChild("Events", 5):WaitForChild("XMHH2.2", 5)
            end)
            
            if not remote1 or not remote2 then
                warn("Melee Aura: Required remotes not found")
                return
            end

            local attackTick = tick()
            local attackCooldown = 0.1

            local AttackCooldowns = {
                ["Fists"] = 0.05, ["Knuckledusters"] = 0.05, ["Nunchucks"] = 0.05, ["Shiv"] = 0.05,
                ["Bat"] = 1, ["Metal-Bat"] = 1, ["Chainsaw"] = 2.5, ["Balisong"] = 0.05,
                ["Rambo"] = 0.3, ["Shovel"] = 3, ["Sledgehammer"] = 2, ["Katana"] = 0.1, 
                ["Wrench"] = 0.1, ["Fire Axe"] = 2
            }

            local function GetTool()
                local character = LocalPlayer.Character
                return character and character:FindFirstChildOfClass("Tool")
            end

            local function GetMyHRP()
                local character = LocalPlayer.Character
                return character and character:FindFirstChild("HumanoidRootPart")
            end

            local function Attack(target)
                if not target then return end

                local character = LocalPlayer.Character
                local tool = GetTool()
                if not tool then return end

                local animationFolder = tool:FindFirstChild("AnimsFolder")
                local slashAnimation = animationFolder and animationFolder:FindFirstChild("Slash1")
                
                if tick() - attackTick >= attackCooldown then
                    local success, result = pcall(function()
                        return remote1:InvokeServer("🍞", tick(), tool, "43TRFWX", "Normal", tick(), true)
                    end)
                    
                    if not success then return end
                    
                    attackCooldown = AttackCooldowns[tool.Name] or 0.5

                    if self.settings.showAnim then
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        if humanoid and slashAnimation then
                            local animator = humanoid:FindFirstChild("Animator")
                            if animator then
                                local animationTrack = animator:LoadAnimation(slashAnimation)
                                animationTrack:Play()
                                animationTrack:AdjustSpeed(1.3)
                            end
                        end
                    end

                    task.wait(0.3)

                    local handle = tool:FindFirstChild("WeaponHandle") or tool:FindFirstChild("Handle")
                    if not handle and character then
                        handle = character:FindFirstChild("Right Arm")
                    end
                    
                    local hitPartName = self.settings.targetPart == "Random" and self.randomPart or self.settings.targetPart
                    local targetPart = target:FindFirstChild(hitPartName)
                    local myHRP = GetMyHRP()
                    
                    if not handle or not targetPart or not myHRP then return end

                    local arguments = {
                        "🍞", tick(), tool, "2389ZFX34", result, true,
                        handle, targetPart, target,
                        myHRP.Position, targetPart.Position
                    }

                    pcall(function()
                        if tool.Name == "Chainsaw" then
                            for i = 1, 15 do
                                remote2:FireServer(unpack(arguments))
                            end
                        else
                            remote2:FireServer(unpack(arguments))
                        end
                    end)

                    attackTick = tick()
                end
            end

            LocalPlayer.CharacterAdded:Connect(function(character)
                repeat task.wait() until character:FindFirstChild("HumanoidRootPart")
            end)

            while true do
                if self.enabled then
                    local myHRP = GetMyHRP()
                    if myHRP then
                        for _, player in pairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                local character = player.Character
                                local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                                local humanoid = character and character:FindFirstChildOfClass("Humanoid")

                                if humanoidRootPart and humanoid then
                                    local distance = (myHRP.Position - humanoidRootPart.Position).Magnitude
                                    if distance <= self.settings.distance then
                                        if self.settings.teamCheck and player.Team == LocalPlayer.Team then continue end
                                        if self.settings.checkDowned and IsDowned(player) then continue end
                                        if self.settings.checkWhitelist and IsPlayerWhitelisted(player) then continue end
                                        if self.settings.checkTarget and not IsPlayerTargeted(player) then continue end
                                        
                                        Attack(character)
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end

    return MeleeAura
end

return MainTabModule
