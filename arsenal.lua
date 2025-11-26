-- ts file was generated at discord.gg/25ms


pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "JX-ARSENAL!",
        Text = "Join Discord Server | Dsc.gg/getjx",
        Icon = "http://www.roblox.com/asset/?id=85279746515974",
        Duration = 5
    })
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Read-Me",
        Text = "Press RightAlt To Open/Close The Panel!",
        Icon = "",
        Duration = 5
    })
end)
local v1 = "https://raw.githubusercontent.com/ayawtandogaakongotin/buangka/main/MS-PAINT-UI/"
local vu2 = loadstring(game:HttpGet(v1 .. "Library.lua"))()
local v3 = loadstring(game:HttpGet(v1 .. "addons/ThemeManager.lua"))()
local v4 = loadstring(game:HttpGet(v1 .. "addons/SaveManager.lua"))()
vu2.ForceCheckbox = false
vu2.ShowToggleFrameInKeybinds = true
local v5 = vu2:CreateWindow({
    Title = "JX-ARSENAL",
    Footer = "Dsc.gg/getjx",
    ToggleKeybind = Enum.KeyCode.RightAlt,
    Center = true,
    AutoShow = true
})
local v6 = v5:AddTab("Main")
local v7 = v5:AddTab("Mods")
local v8 = v6:AddLeftTabbox("Features"):AddTab("Auto Farm")
local v9 = v6:AddRightGroupbox("HitBox Expander")
local v10 = v7:AddLeftGroupbox("Gun Mods")
local v11 = v6:AddRightGroupbox("Silent Aim")
local vu12 = game:GetService("Players")
local vu13 = vu12.LocalPlayer
local vu14 = game:GetService("RunService")
local vu15 = game:GetService("UserInputService")
local vu16 = game:GetService("ReplicatedStorage")
local vu17 = game:GetService("Workspace")
local vu18 = game:GetService("HttpService")
v8:AddToggle("AutoFarmToggle", {
    Text = "Auto Farm",
    Default = false,
    Tooltip = "Enables or disables auto farm functionality",
    Callback = function(pu19)
        getgenv().AutoFarm = pu19
        local vu20 = nil
        local vu21 = false
        local vu22 = vu12.LocalPlayer
        local vu23 = vu17.CurrentCamera
        pcall(function()
            if vu16.wkspc then
                vu16.wkspc.CurrentCurse.Value = pu19 and "Infinite Ammo" or ""
            end
        end)
        local function vu36()
            local v24 = math.huge
            local v25 = nil
            if not (vu22 and vu22.Character and vu22.Character:FindFirstChild("HumanoidRootPart")) then
                return nil
            end
            local v26 = vu12
            local v27, v28, v29 = pairs(v26:GetPlayers())
            while true do
                local v30
                v29, v30 = v27(v28, v29)
                if v29 == nil then
                    break
                end
                if v30 ~= vu22 and (v30.TeamColor ~= vu22.TeamColor and v30.Character) then
                    local v31 = v30.Character
                    local vu32 = v31:FindFirstChild("HumanoidRootPart")
                    local v33 = v31:FindFirstChild("Humanoid")
                    local v34
                    if vu32 and (v33 and v33.Health > 0) then
                        local v35
                        v35, v34 = pcall(function()
                            return (vu22.Character.HumanoidRootPart.Position - vu32.Position).Magnitude
                        end)
                        if v35 and (v34 and v34 < v24) then
                            if vu32.Position.Y < 0 then
                                v30 = v25
                                v34 = v24
                            end
                        else
                            v30 = v25
                            v34 = v24
                        end
                    else
                        v30 = v25
                        v34 = v24
                    end
                    v25 = v30
                    v24 = v34
                end
            end
            return v25
        end
        local function vu39()
            pcall(function()
                if vu16.wkspc then
                    vu16.wkspc.TimeScale.Value = 12
                end
            end)
            if vu20 then
                vu20:Disconnect()
                vu20 = nil
            end
            vu20 = vu14.Stepped:Connect(function()
                if getgenv().AutoFarm then
                    if vu22 and vu22.Character and vu22.Character:FindFirstChild("HumanoidRootPart") then
                        local vu37 = vu36()
                        if vu37 and vu37.Character and vu37.Character:FindFirstChild("HumanoidRootPart") then
                            local vu38 = vu37.Character.HumanoidRootPart.Position + Vector3.new(0, 0, - 4)
                            pcall(function()
                                vu22.Character.HumanoidRootPart.CFrame = CFrame.new(vu38)
                            end)
                            if vu37.Character:FindFirstChild("Head") and vu23 then
                                pcall(function()
                                    vu23.CFrame = CFrame.new(vu23.CFrame.Position, vu37.Character.Head.Position)
                                end)
                            end
                            if not vu21 then
                                pcall(function()
                                    mouse1press()
                                end)
                                vu21 = true
                            end
                        elseif vu21 then
                            pcall(function()
                                mouse1release()
                            end)
                            vu21 = false
                        end
                    end
                else
                    return
                end
            end)
        end
        local function v40(_)
            task.wait(0.5)
            if getgenv().AutoFarm then
                vu39()
            end
        end
        if pu19 then
            task.wait(0.5)
            vu39()
            vu12.LocalPlayer.CharacterAdded:Connect(v40)
        else
            pcall(function()
                if vu16.wkspc then
                    vu16.wkspc.CurrentCurse.Value = ""
                    vu16.wkspc.TimeScale.Value = 1
                end
            end)
            getgenv().AutoFarm = false
            if vu20 then
                local v41 = vu20
                vu20.Disconnect(v41)
                vu20 = nil
            end
            if vu21 then
                pcall(function()
                    mouse1release()
                end)
                vu21 = false
            end
        end
    end
})
local vu42 = false
local vu43 = false
local vu44 = {}
local vu45 = 21
local vu46 = 6
local vu47 = "FFA"
local vu48 = {
    "UpperTorso",
    "Head",
    "HumanoidRootPart"
}
local v49 = vu13
local v50 = Instance.new("ScreenGui", vu13.WaitForChild(v49, "PlayerGui"))
local vu51 = Instance.new("TextLabel", v50)
vu51.Size = UDim2.new(0, 200, 0, 50)
vu51.TextSize = 16
vu51.Position = UDim2.new(0.5, - 150, 0, 0)
vu51.Text = "Warning: Hitbox Expander Is Risky."
vu51.TextColor3 = Color3.new(1, 0, 0)
vu51.BackgroundTransparency = 1
vu51.Visible = false
local function vu54(p52, p53)
    if not vu44[p52] then
        vu44[p52] = {}
    end
    if not vu44[p52][p53.Name] then
        vu44[p52][p53.Name] = {
            CanCollide = p53.CanCollide,
            Transparency = p53.Transparency,
            Size = p53.Size
        }
    end
end
local function vu61(p55)
    if vu44[p55] then
        local v56, v57, v58 = pairs(vu44[p55])
        while true do
            local vu59
            v58, vu59 = v56(v57, v58)
            if v58 == nil then
                break
            end
            local vu60 = p55.Character
            if vu60 then
                vu60 = p55.Character:FindFirstChild(v58)
            end
            if vu60 and vu60:IsA("BasePart") then
                pcall(function()
                    vu60.CanCollide = vu59.CanCollide
                    vu60.Transparency = vu59.Transparency
                    vu60.Size = vu59.Size
                end)
            end
        end
    end
end
local function vu68(p62, p63)
    if not p62.Character then
        return nil
    end
    local v64, v65, v66 = ipairs(p62.Character:GetChildren())
    while true do
        local v67
        v66, v67 = v64(v65, v66)
        if v66 == nil then
            break
        end
        if v67:IsA("BasePart") and v67.Name:lower():match(p63:lower()) then
            return v67
        end
    end
    return nil
end
local function vu75(p69)
    local v70, v71, v72 = ipairs(vu48)
    while true do
        local v73
        v72, v73 = v70(v71, v72)
        if v72 == nil then
            break
        end
        local vu74 = p69.Character
        if vu74 then
            vu74 = p69.Character:FindFirstChild(v73) or vu68(p69, v73)
        end
        if vu74 and vu74:IsA("BasePart") then
            vu54(p69, vu74)
            pcall(function()
                vu74.CanCollide = not vu43
                vu74.Transparency = vu46 / 10
                vu74.Size = Vector3.new(vu45, vu45, vu45)
            end)
        end
    end
end
local function vu77(p76)
    return (vu47 == "FFA" or vu47 == "Everyone") and true or vu13.Team ~= p76.Team
end
local function vu79(p78)
    return vu77(p78)
end
local function vu85()
    local v80 = vu12
    local v81, v82, v83 = ipairs(v80:GetPlayers())
    while true do
        local v84
        v83, v84 = v81(v82, v83)
        if v83 == nil then
            break
        end
        if v84 ~= vu13 and v84.Character and v84.Character:FindFirstChild("HumanoidRootPart") then
            if vu79(v84) then
                vu75(v84)
            else
                vu61(v84)
            end
        end
    end
end
local function vu86(_)
    task.wait(0.1)
    if vu42 then
        vu85()
    end
end
local function v88(pu87)
    pu87.CharacterAdded:Connect(vu86)
    pu87.CharacterRemoving:Connect(function()
        vu61(pu87)
        vu44[pu87] = nil
    end)
end
local function vu93()
    local v89, v90, v91 = pairs(vu44)
    while true do
        local v92
        v91, v92 = v89(v90, v91)
        if v91 == nil then
            break
        end
        if not (v91.Parent and v91.Character and v91.Character:IsDescendantOf(game)) then
            vu61(v91)
            vu44[v91] = nil
        end
    end
end
vu12.PlayerAdded:Connect(v88)
local v94 = vu12
local v95, v96, v97 = ipairs(vu12.GetPlayers(v94))
local vu98 = vu44
local vu99 = vu85
local vu100 = vu13
local vu101 = vu43
local vu102 = vu46
local vu103 = vu14
local vu104 = vu45
local vu105 = vu61
local vu106 = vu12
local vu107 = vu42
local vu108 = vu47
local vu109 = vu17
local vu110 = vu16
while true do
    local v111
    v97, v111 = v95(v96, v97)
    if v97 == nil then
        break
    end
    v88(v111)
end
v9:AddToggle("HitboxToggle", {
    Text = "Enable Hitbox",
    Default = false,
    Tooltip = "Enables or disables hitbox expansion",
    Callback = function(p112)
        vu107 = p112
        if p112 then
            coroutine.wrap(function()
                while vu107 do
                    vu99()
                    vu93()
                    task.wait(0.1)
                end
            end)()
        else
            local v113 = vu106
            local v114, v115, v116 = ipairs(v113:GetPlayers())
            while true do
                local v117
                v116, v117 = v114(v115, v116)
                if v116 == nil then
                    break
                end
                vu105(v117)
            end
            vu98 = {}
        end
    end
})
v9:AddSlider("HitboxSizeSlider", {
    Text = "Hitbox Size",
    Default = 21,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Compact = false,
    Callback = function(p118)
        vu104 = p118
        if vu107 then
            vu99()
        end
    end
})
v9:AddSlider("HitboxTransparencySlider", {
    Text = "Hitbox Transparency",
    Default = 6,
    Min = 1,
    Max = 10,
    Rounding = 0,
    Compact = false,
    Callback = function(p119)
        vu102 = p119
        if vu107 then
            vu99()
        end
    end
})
v9:AddDropdown("TeamCheckDropdown", {
    Values = {
        "FFA",
        "Team-Based",
        "Everyone"
    },
    Default = 1,
    Multi = false,
    Text = "Team Check",
    Tooltip = "Select team check mode",
    Callback = function(p120)
        vu108 = p120
        if vu107 then
            vu99()
        end
    end
})
v9:AddToggle("NoCollisionToggle", {
    Text = "No Collision",
    Default = false,
    Tooltip = "Disables collision for hitboxes",
    Callback = function(p121)
        vu101 = p121
        vu51.Visible = p121
        if vu107 then
            vu99()
        end
    end
})
local vu122 = false
local vu123 = false
local vu124 = Drawing.new("Circle")
vu124.Thickness = 2
vu124.NumSides = 75
vu124.Color = Color3.fromRGB(170, 0, 0)
vu124.Visible = false
vu124.Filled = false
vu124.Position = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X, game:GetService("UserInputService"):GetMouseLocation().Y)
local vu125 = {
    "RightUpperLeg",
    "LeftUpperLeg",
    "HeadHB",
    "HumanoidRootPart"
}
local vu126 = {}
local function vu129(p127, p128)
    if not vu126[p127] then
        vu126[p127] = {}
    end
    if not vu126[p127][p128.Name] then
        vu126[p127][p128.Name] = {
            CanCollide = p128.CanCollide,
            Transparency = p128.Transparency,
            Size = p128.Size
        }
    end
end
local function vu136(p130)
    if vu126[p130] then
        local v131, v132, v133 = pairs(vu126[p130])
        while true do
            local vu134
            v133, vu134 = v131(v132, v133)
            if v133 == nil then
                break
            end
            local vu135 = p130.Character
            if vu135 then
                vu135 = p130.Character:FindFirstChild(v133)
            end
            if vu135 and vu135:IsA("BasePart") then
                pcall(function()
                    vu135.CanCollide = vu134.CanCollide
                    vu135.Transparency = vu134.Transparency
                    vu135.Size = vu134.Size
                end)
            end
        end
        vu126[p130] = nil
    end
end
local function vu147()
    local v137 = vu106
    local v138, v139, v140 = ipairs(v137:GetPlayers())
    while true do
        local v141
        v140, v141 = v138(v139, v140)
        if v140 == nil then
            break
        end
        if v141 == vu100 or not v141.Character or not v141.Character:FindFirstChild("HumanoidRootPart") then
            vu136(v141)
        else
            local v142, v143, v144 = ipairs(vu125)
            while true do
                local v145
                v144, v145 = v142(v143, v144)
                if v144 == nil then
                    break
                end
                local vu146 = v141.Character:FindFirstChild(v145)
                if vu146 and vu146:IsA("BasePart") then
                    vu129(v141, vu146)
                    pcall(function()
                        vu146.CanCollide = false
                        vu146.Transparency = 10
                        vu146.Size = Vector3.new(13, 13, 13)
                    end)
                end
            end
        end
    end
end
local vu148 = nil
v11:AddToggle("SilentAimToggle", {
    Text = "Enable Silent Aim",
    Default = false,
    Tooltip = "Enables or disables silent aim",
    Callback = function(p149)
        vu122 = p149
        if p149 then
            vu148 = vu103.Stepped:Connect(function()
                if vu122 then
                    vu147()
                end
            end)
        else
            if vu148 then
                vu148:Disconnect()
                vu148 = nil
            end
            local v150 = vu106
            local v151, v152, v153 = ipairs(v150:GetPlayers())
            while true do
                local v154
                v153, v154 = v151(v152, v153)
                if v153 == nil then
                    break
                end
                vu136(v154)
            end
            vu126 = {}
        end
    end
})
vu103.RenderStepped:Connect(function()
    if vu123 then
        local v155 = vu15:GetMouseLocation()
        vu124.Position = Vector2.new(v155.X, v155.Y)
    end
end)
local vu156 = {
    FireRate = {},
    ReloadTime = {},
    EReloadTime = {},
    Auto = {},
    Spread = {},
    Recoil = {}
}
v10:AddToggle("InfiniteAmmoToggle", {
    Text = "Infinite Ammo",
    Default = false,
    Tooltip = "Enables or disables infinite ammo",
    Callback = function(pu157)
        pcall(function()
            if vu110.wkspc then
                vu110.wkspc.CurrentCurse.Value = pu157 and "Infinite Ammo" or ""
            end
        end)
    end
})
v10:AddToggle("FastReloadToggle", {
    Text = "Fast Reload",
    Default = false,
    Tooltip = "Reduces reload time",
    Callback = function(p158)
        local v159, v160, v161 = pairs(vu110.Weapons:GetChildren())
        while true do
            local v162
            v161, v162 = v159(v160, v161)
            if v161 == nil then
                break
            end
            if v162:FindFirstChild("ReloadTime") then
                if p158 then
                    if not vu156.ReloadTime[v162] then
                        vu156.ReloadTime[v162] = v162.ReloadTime.Value
                    end
                    v162.ReloadTime.Value = 0.01
                elseif vu156.ReloadTime[v162] then
                    v162.ReloadTime.Value = vu156.ReloadTime[v162]
                else
                    v162.ReloadTime.Value = 0.8
                end
            end
            if v162:FindFirstChild("EReloadTime") then
                if p158 then
                    if not vu156.EReloadTime[v162] then
                        vu156.EReloadTime[v162] = v162.EReloadTime.Value
                    end
                    v162.EReloadTime.Value = 0.01
                elseif vu156.EReloadTime[v162] then
                    v162.EReloadTime.Value = vu156.EReloadTime[v162]
                else
                    v162.EReloadTime.Value = 0.8
                end
            end
        end
    end
})
v10:AddToggle("FastFireRateToggle", {
    Text = "Fast Fire Rate",
    Default = false,
    Tooltip = "Increases fire rate",
    Callback = function(p163)
        local v164, v165, v166 = pairs(vu110.Weapons:GetDescendants())
        while true do
            local v167
            v166, v167 = v164(v165, v166)
            if v166 == nil then
                break
            end
            if v167.Name == "FireRate" or v167.Name == "BFireRate" then
                if p163 then
                    if not vu156.FireRate[v167] then
                        vu156.FireRate[v167] = v167.Value
                    end
                    v167.Value = 0.02
                elseif vu156.FireRate[v167] then
                    v167.Value = vu156.FireRate[v167]
                else
                    v167.Value = 0.8
                end
            end
        end
    end
})
v10:AddToggle("AlwaysAutoToggle", {
    Text = "Always Auto",
    Default = false,
    Tooltip = "Enables automatic fire for all weapons",
    Callback = function(p168)
        local v169, v170, v171 = pairs(vu110.Weapons:GetDescendants())
        while true do
            local v172
            v171, v172 = v169(v170, v171)
            if v171 == nil then
                break
            end
            if v172.Name == "Auto" or (v172.Name == "AutoFire" or (v172.Name == "Automatic" or (v172.Name == "AutoShoot" or v172.Name == "AutoGun"))) then
                if p168 then
                    if not vu156.Auto[v172] then
                        vu156.Auto[v172] = v172.Value
                    end
                    v172.Value = true
                elseif vu156.Auto[v172] then
                    v172.Value = vu156.Auto[v172]
                else
                    v172.Value = false
                end
            end
        end
    end
})
v10:AddToggle("NoSpreadToggle", {
    Text = "No Spread",
    Default = false,
    Tooltip = "Eliminates weapon spread",
    Callback = function(p173)
        local v174, v175, v176 = pairs(vu110.Weapons:GetDescendants())
        while true do
            local v177
            v176, v177 = v174(v175, v176)
            if v176 == nil then
                break
            end
            if v177.Name == "MaxSpread" or (v177.Name == "Spread" or v177.Name == "SpreadControl") then
                if p173 then
                    if not vu156.Spread[v177] then
                        vu156.Spread[v177] = v177.Value
                    end
                    v177.Value = 0
                elseif vu156.Spread[v177] then
                    v177.Value = vu156.Spread[v177]
                else
                    v177.Value = 1
                end
            end
        end
    end
})
v10:AddToggle("NoRecoilToggle", {
    Text = "No Recoil",
    Default = false,
    Tooltip = "Eliminates weapon recoil",
    Callback = function(p178)
        local v179, v180, v181 = pairs(vu110.Weapons:GetDescendants())
        while true do
            local v182
            v181, v182 = v179(v180, v181)
            if v181 == nil then
                break
            end
            if v182.Name == "RecoilControl" or v182.Name == "Recoil" then
                if p178 then
                    if not vu156.Recoil[v182] then
                        vu156.Recoil[v182] = v182.Value
                    end
                    v182.Value = 0
                elseif vu156.Recoil[v182] then
                    v182.Value = vu156.Recoil[v182]
                else
                    v182.Value = 1
                end
            end
        end
    end
})
local v183 = v5:AddTab("Player")
local v184 = v183:AddLeftGroupbox("Fly & Speed")
local v185 = v183:AddRightGroupbox("Jump Power")
local v186 = v183:AddLeftGroupbox("Others")
local vu187 = false
local vu188 = {
    flyspeed = 100
}
local vu189 = nil
local vu190 = nil
local vu191 = nil
local vu192 = {
    W = false,
    A = false,
    S = false,
    D = false,
    Space = false,
    LeftShift = false
}
local function vu199()
    if not vu190 then
        vu190 = vu15.InputBegan:Connect(function(p193, p194)
            if not p194 then
                local v195 = p193.KeyCode
                if v195 == Enum.KeyCode.W then
                    vu192.W = true
                end
                if v195 == Enum.KeyCode.S then
                    vu192.S = true
                end
                if v195 == Enum.KeyCode.A then
                    vu192.A = true
                end
                if v195 == Enum.KeyCode.D then
                    vu192.D = true
                end
                if v195 == Enum.KeyCode.Space then
                    vu192.Space = true
                end
                if v195 == Enum.KeyCode.LeftShift then
                    vu192.LeftShift = true
                end
            end
        end)
        vu191 = vu15.InputEnded:Connect(function(p196, p197)
            if not p197 then
                local v198 = p196.KeyCode
                if v198 == Enum.KeyCode.W then
                    vu192.W = false
                end
                if v198 == Enum.KeyCode.S then
                    vu192.S = false
                end
                if v198 == Enum.KeyCode.A then
                    vu192.A = false
                end
                if v198 == Enum.KeyCode.D then
                    vu192.D = false
                end
                if v198 == Enum.KeyCode.Space then
                    vu192.Space = false
                end
                if v198 == Enum.KeyCode.LeftShift then
                    vu192.LeftShift = false
                end
            end
        end)
    end
end
local function vu200()
    if vu190 then
        vu190:Disconnect()
        vu190 = nil
    end
    if vu191 then
        vu191:Disconnect()
        vu191 = nil
    end
    vu192 = {
        W = false,
        A = false,
        S = false,
        D = false,
        Space = false,
        LeftShift = false
    }
end
local function vu210()
    if not vu187 then
        vu187 = true
        vu199()
        if vu189 then
            vu189:Disconnect()
            vu189 = nil
        end
        vu189 = vu103.Heartbeat:Connect(function(_)
            local v201 = vu106.LocalPlayer
            if v201 and v201.Character then
                local vu202 = v201.Character:FindFirstChild("HumanoidRootPart")
                local vu203 = v201.Character:FindFirstChildOfClass("Humanoid")
                if vu202 and vu203 then
                    pcall(function()
                        vu203.PlatformStand = true
                    end)
                    local v204 = vu109.CurrentCamera
                    local v205 = v204 and v204.CFrame.LookVector or Vector3.new(0, 0, - 1)
                    local v206 = v204 and v204.CFrame.RightVector or Vector3.new(1, 0, 0)
                    local v207 = Vector3.new()
                    if vu192.W then
                        v207 = v207 + v205
                    end
                    if vu192.S then
                        v207 = v207 - v205
                    end
                    if vu192.D then
                        v207 = v207 + v206
                    end
                    if vu192.A then
                        v207 = v207 - v206
                    end
                    if vu192.Space then
                        v207 = v207 + Vector3.new(0, 1, 0)
                    end
                    if vu192.LeftShift then
                        v207 = v207 - Vector3.new(0, 1, 0)
                    end
                    local v208 = tonumber(vu188.flyspeed) or 100
                    if v207.Magnitude <= 0 then
                        pcall(function()
                            vu202.Velocity = Vector3.new(0, 0, 0)
                        end)
                    else
                        local vu209 = v207.Unit * v208
                        pcall(function()
                            vu202.Velocity = Vector3.new(vu209.X, vu209.Y, vu209.Z)
                        end)
                    end
                end
            else
                return
            end
        end)
    end
end
local function vu214()
    vu187 = false
    vu200()
    if vu189 then
        vu189:Disconnect()
        vu189 = nil
    end
    local v211 = vu106.LocalPlayer
    if v211 and v211.Character then
        local vu212 = v211.Character:FindFirstChildOfClass("Humanoid")
        local vu213 = v211.Character:FindFirstChild("HumanoidRootPart")
        pcall(function()
            if vu212 then
                vu212.PlatformStand = false
            end
            if vu213 then
                vu213.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end
v184:AddToggle("PlayerFlyToggle", {
    Text = "Fly",
    Default = false,
    Tooltip = "Allows player to fly. Use KeyPicker to set a key if supported.",
    KeyPicker = {
        Default = "None",
        SyncToggleState = true,
        Mode = "Toggle"
    },
    Callback = function(p215)
        if p215 then
            vu210()
        else
            vu214()
        end
    end
})
v184:AddSlider("PlayerFlySpeed", {
    Text = "Fly Speed",
    Default = 100,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Tooltip = "Adjust fly speed",
    Callback = function(p216)
        vu188.flyspeed = p216
    end
})
local vu217 = game:GetService("RunService")
local vu218 = game:GetService("Players")
local vu219 = vu218.LocalPlayer
local vu220 = 25
local vu221 = false
local vu222 = {
    WalkSpeed = vu220,
    Method = "Velocity"
}
local v223 = {
    "Velocity",
    "Vector",
    "CFrame"
}
local function vu227(p224)
    if p224 then
        local vu225 = p224:FindFirstChildOfClass("Humanoid")
        local vu226 = p224:FindFirstChild("HumanoidRootPart")
        if vu225 then
            pcall(function()
                vu225.WalkSpeed = vu220
            end)
        end
        if vu226 then
            pcall(function()
                vu226.Velocity = Vector3.new(0, vu226.Velocity.Y, 0)
            end)
        end
    end
end
if vu219 then
    if vu219.Character then
        vu227(vu219.Character)
    end
    vu219.CharacterAdded:Connect(function(p228)
        p228:WaitForChild("Humanoid", 5)
        vu227(p228)
    end)
end
vu217.Heartbeat:Connect(function(pu229)
    local v230 = vu218.LocalPlayer
    if v230 and v230.Character then
        local vu231 = v230.Character:FindFirstChildOfClass("Humanoid")
        local vu232 = v230.Character:FindFirstChild("HumanoidRootPart")
        if vu221 and (vu231 and vu232) then
            local vu233 = vu222.WalkSpeed or vu220
            if vu222.Method ~= "Velocity" then
                if vu222.Method ~= "Vector" then
                    if vu222.Method ~= "CFrame" then
                        pcall(function()
                            vu231.WalkSpeed = vu233
                        end)
                    else
                        local vu234 = 0.1
                        pcall(function()
                            vu232.CFrame = vu232.CFrame + vu231.MoveDirection * vu233 * pu229 * vu234
                        end)
                    end
                else
                    local vu235 = 0.1
                    local vu236 = vu231.MoveDirection * vu233
                    pcall(function()
                        vu232.CFrame = vu232.CFrame + vu236 * pu229 * vu235
                    end)
                end
            else
                local vu237 = vu231.MoveDirection * vu233
                pcall(function()
                    vu232.Velocity = Vector3.new(vu237.X, vu232.Velocity.Y, vu237.Z)
                end)
            end
        elseif vu231 and vu231.WalkSpeed ~= vu220 then
            pcall(function()
                vu231.WalkSpeed = vu220
            end)
        end
    end
end)
v184:AddToggle("CustomWalkToggle", {
    Text = "Custom WalkSpeed",
    Default = false,
    Tooltip = "Toggle custom walkspeed. Use KeyPicker to set a key if supported.",
    KeyPicker = {
        Default = "None",
        SyncToggleState = true,
        Mode = "Toggle"
    },
    Callback = function(p238)
        vu221 = p238
        if not p238 then
            local v239 = vu218.LocalPlayer
            if v239 and v239.Character then
                vu227(v239.Character)
            end
        end
    end
})
v184:AddDropdown("WalkMethodDropdown", {
    Values = v223,
    Default = 1,
    Multi = false,
    Text = "Walk Method",
    Tooltip = "Choose walk method",
    Callback = function(p240)
        vu222.Method = p240
    end
})
v184:AddSlider("WalkSpeedPower", {
    Text = "Walkspeed Power",
    Default = vu220,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(p241)
        vu222.WalkSpeed = p241
    end
})
local vu242 = false
local vu243 = false
local vu244 = {
    JumpPower = 50,
    Method = "Velocity"
}
local v245 = {
    "Velocity",
    "Vector",
    "CFrame"
}
local vu246 = nil
local function vu251(pu247)
    if vu246 then
        vu246:Disconnect()
        vu246 = nil
    end
    if pu247 then
        local v248 = pu247:FindFirstChildOfClass("Humanoid")
        if v248 then
            vu246 = v248.Jumping:Connect(function(p249)
                if p249 and (vu242 and pu247) and pu247:FindFirstChild("HumanoidRootPart") then
                    local vu250 = pu247:FindFirstChild("HumanoidRootPart")
                    if vu244.Method ~= "Velocity" then
                        if vu244.Method ~= "Vector" then
                            if vu244.Method == "CFrame" then
                                pcall(function()
                                    if pu247.PrimaryPart then
                                        pu247:SetPrimaryPartCFrame(pu247:GetPrimaryPartCFrame() + Vector3.new(0, vu244.JumpPower, 0))
                                    else
                                        vu250.CFrame = vu250.CFrame + Vector3.new(0, vu244.JumpPower, 0)
                                    end
                                end)
                            end
                        else
                            pcall(function()
                                vu250.Velocity = Vector3.new(0, vu244.JumpPower, 0)
                            end)
                        end
                    else
                        pcall(function()
                            vu250.Velocity = Vector3.new(vu250.Velocity.X, vu244.JumpPower, vu250.Velocity.Z)
                        end)
                    end
                end
            end)
        end
    else
        return
    end
end
if vu219.Character then
    vu251(vu219.Character)
end
vu219.CharacterAdded:Connect(function(p252)
    task.wait(0.15)
    vu251(p252)
end)
v185:AddToggle("InfiniteJumpToggle", {
    Text = "Infinite Jump",
    Default = false,
    Tooltip = "Toggle infinite jump",
    Callback = function(p253)
        vu243 = p253
    end
})
vu15.JumpRequest:Connect(function()
    if vu243 then
        local v254 = vu218.LocalPlayer
        local v255 = v254.Character
        if v255 then
            v255 = v254.Character:FindFirstChildOfClass("Humanoid")
        end
        if v255 then
            v255:ChangeState("Jumping")
        end
    end
end)
v185:AddToggle("CustomJumpToggle", {
    Text = "Custom JumpPower",
    Default = false,
    Tooltip = "Toggle custom jumppower",
    Callback = function(p256)
        vu242 = p256
    end
})
v185:AddDropdown("JumpMethodDropdown", {
    Values = v245,
    Default = 1,
    Multi = false,
    Text = "Jump Method",
    Tooltip = "Choose jump method",
    Callback = function(p257)
        vu244.Method = p257
    end
})
v185:AddSlider("ChangeJumpPower", {
    Text = "Change JumpPower",
    Default = 50,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Compact = false,
    Callback = function(p258)
        vu244.JumpPower = p258
        local v259 = vu218.LocalPlayer
        local vu260 = v259 and v259.Character and v259.Character:FindFirstChildOfClass("Humanoid")
        if vu260 then
            pcall(function()
                vu260.UseJumpPower = true
            end)
        end
    end
})
v186:AddSlider("FOVSlider", {
    Text = "FOV Arsenal",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 0,
    Compact = false,
    Tooltip = "Change FOV",
    Callback = function(pu261)
        pcall(function()
            if vu219 and vu219.Settings and vu219.Settings:FindFirstChild("FOV") then
                vu219.Settings.FOV.Value = pu261
            end
        end)
        pcall(function()
            if vu109.CurrentCamera then
                vu109.CurrentCamera.FieldOfView = pu261
            end
        end)
    end
})
local vu262 = false
local vu263 = {}
local function vu269()
    vu263 = {}
    local v264 = vu218.LocalPlayer
    if v264 and v264.Character then
        local v265, v266, v267 = pairs(v264.Character:GetDescendants())
        while true do
            local vu268
            v267, vu268 = v265(v266, v267)
            if v267 == nil then
                break
            end
            if vu268:IsA("BasePart") then
                vu263[vu268] = vu268.CanCollide
                pcall(function()
                    vu268.CanCollide = false
                end)
            end
        end
    end
end
local function vu275()
    local v270, v271, v272 = pairs(vu263)
    while true do
        local vu273, vu274 = v270(v271, v272)
        if vu273 == nil then
            break
        end
        v272 = vu273
        if vu273 and vu273.Parent then
            pcall(function()
                vu273.CanCollide = vu274
            end)
        end
    end
    vu263 = {}
end
v186:AddToggle("NoclipToggle", {
    Text = "Toggle NoClip",
    Default = false,
    Tooltip = "Enable/disable noclip (restores on disable)",
    Callback = function(p276)
        vu262 = p276
        if p276 then
            vu269()
        else
            vu275()
        end
    end
})
vu218.LocalPlayer.CharacterAdded:Connect(function(_)
    task.wait(0.1)
    if vu262 then
        vu269()
    end
end)
local vu277 = false
v186:AddToggle("XrayToggle", {
    Text = "Toggle Xray",
    Default = false,
    Tooltip = "Toggle workspace xray (uses LocalTransparencyModifier)",
    Callback = function(p278)
        vu277 = p278
        if p278 then
            local v279 = vu109
            local v280, v281, v282 = ipairs(v279:GetDescendants())
            while true do
                local vu283
                v282, vu283 = v280(v281, v282)
                if v282 == nil then
                    break
                end
                if vu283:IsA("BasePart") then
                    pcall(function()
                        vu283.LocalTransparencyModifier = 0.5
                    end)
                end
            end
        else
            local v284 = vu109
            local v285, v286, v287 = ipairs(v284:GetDescendants())
            while true do
                local vu288
                v287, vu288 = v285(v286, v287)
                if v287 == nil then
                    break
                end
                if vu288:IsA("BasePart") then
                    pcall(function()
                        vu288.LocalTransparencyModifier = 0
                    end)
                end
            end
        end
    end
})
vu109.DescendantAdded:Connect(function(pu289)
    if vu277 and pu289:IsA("BasePart") then
        pcall(function()
            pu289.LocalTransparencyModifier = 0.5
        end)
    end
end)
local v290 = v7:AddRightGroupbox("Gun Color")
local vu291 = false
local vu292 = nil
local vu293 = 0
local function vu295(p294)
    return math.acos(math.cos(p294 * math.pi)) / math.pi
end
v290:AddToggle("RainbowGunToggle", {
    Text = "Rainbow Gun",
    Default = false,
    Tooltip = "Toggle Rainbow Gun",
    Callback = function(p296)
        vu291 = p296
        if vu291 then
            if vu292 then
                vu292:Disconnect()
                vu292 = nil
            end
            vu292 = vu217.RenderStepped:Connect(function()
                local v297 = vu109:FindFirstChild("Camera") or vu109.CurrentCamera
                if v297 and v297:FindFirstChild("Arms") then
                    local v298, v299, v300 = pairs(v297.Arms:GetDescendants())
                    while true do
                        local vu301
                        v300, vu301 = v298(v299, v300)
                        if v300 == nil then
                            break
                        end
                        if vu301:IsA("MeshPart") or vu301:IsA("Part") then
                            local vu302 = vu295(vu293)
                            pcall(function()
                                vu301.Color = Color3.fromHSV(vu302, 1, 1)
                            end)
                        end
                    end
                end
                vu293 = vu293 + 0.0008
                if vu293 >= 1 then
                    vu293 = vu293 - 1
                end
            end)
        elseif vu292 then
            vu292:Disconnect()
            vu292 = nil
        end
    end
})
local v303 = v5:AddTab("Visual"):AddLeftGroupbox("ESP")
local vu304 = vu109.CurrentCamera
local vu305 = {}
local vu306 = {
    Enabled = false,
    TeamCheck = false,
    EspMethod = "Show All",
    BoxEnabled = false,
    BoxGlowColor = Color3.fromRGB(255, 255, 255),
    BoxFillColor = Color3.fromRGB(153, 147, 147),
    BoxDesign = "2D Box",
    BoxModes = {},
    TracerEnabled = false,
    TracerOrigin = "Bottom",
    TracerColor = Color3.fromRGB(255, 255, 255),
    NameEnabled = false,
    NameColor = Color3.fromRGB(255, 255, 255),
    NamePos = "Top",
    HBEnabled = false,
    HBColor = Color3.fromRGB(0, 255, 0),
    HBPosition = "Outside Left",
    HBTextEnabled = false,
    HBTextPos = "Top",
    DistanceEnabled = false,
    DistanceColor = Color3.fromRGB(255, 255, 255)
}
v303:AddToggle("ESP_Master", {
    Text = "Enable ESP",
    Default = false,
    Callback = function(p307)
        vu306.Enabled = p307
    end
})
v303:AddDropdown("ESP_Method", {
    Values = {
        "Wall Check",
        "Show All"
    },
    Default = "Show All",
    Text = "Esp Method",
    Callback = function(p308)
        vu306.EspMethod = p308
    end
})
v303:AddToggle("ESP_Team", {
    Text = "Team Check",
    Default = false,
    Callback = function(p309)
        vu306.TeamCheck = p309
    end
})
local v311 = v303:AddToggle("ESP_Box", {
    Text = "Box ESP",
    Default = false,
    Callback = function(p310)
        vu306.BoxEnabled = p310
    end
})
v303:AddDropdown("ESP_BoxDesign", {
    Values = {
        "2D Box",
        "Corner Box",
        "3D Box"
    },
    Default = "2D Box",
    Text = "Box Design",
    Callback = function(p312)
        vu306.BoxDesign = p312
    end
})
v311:AddColorPicker("ESP_BoxGlow", {
    Default = vu306.BoxGlowColor,
    Title = "Box Glow",
    Transparency = 0,
    Callback = function(p313)
        vu306.BoxGlowColor = p313
    end
})
local v315 = v303:AddToggle("ESP_Tracer", {
    Text = "Tracer",
    Default = false,
    Callback = function(p314)
        vu306.TracerEnabled = p314
    end
})
v303:AddDropdown("ESP_TracerOrigin", {
    Values = {
        "Bottom",
        "Center",
        "Top"
    },
    Default = "Bottom",
    Text = "Tracer Origin",
    Callback = function(p316)
        vu306.TracerOrigin = p316
    end
})
v315:AddColorPicker("ESP_TracerColor", {
    Default = vu306.TracerColor,
    Title = "Tracer Color",
    Transparency = 0,
    Callback = function(p317)
        vu306.TracerColor = p317
    end
})
v303:AddToggle("ESP_Name", {
    Text = "Name ESP",
    Default = false,
    Callback = function(p318)
        vu306.NameEnabled = p318
    end
}):AddColorPicker("ESP_NameColor", {
    Default = vu306.NameColor,
    Title = "Name Color",
    Transparency = 0,
    Callback = function(p319)
        vu306.NameColor = p319
    end
})
v303:AddDropdown("ESP_NamePos", {
    Values = {
        "Top",
        "Bottom",
        "Left",
        "Right"
    },
    Default = "Top",
    Text = "Name Position",
    Callback = function(p320)
        vu306.NamePos = p320
    end
})
local v322 = v303:AddToggle("ESP_HB", {
    Text = "Health Bar",
    Default = false,
    Callback = function(p321)
        vu306.HBEnabled = p321
    end
})
v303:AddDropdown("ESP_HBPos", {
    Values = {
        "Outside Left",
        "Inside Left",
        "Outside Right",
        "Inside Right"
    },
    Default = "Outside Left",
    Text = "Healthbar Position",
    Callback = function(p323)
        vu306.HBPosition = p323
    end
})
v322:AddColorPicker("ESP_HBColor", {
    Default = vu306.HBColor,
    Title = "Health Bar Color",
    Transparency = 0,
    Callback = function(p324)
        vu306.HBColor = p324
    end
})
v303:AddToggle("ESP_HBText", {
    Text = "Health Text",
    Default = false,
    Callback = function(p325)
        vu306.HBTextEnabled = p325
    end
})
v303:AddDropdown("ESP_HBTextPos", {
    Values = {
        "Top",
        "Bottom",
        "Left",
        "Right"
    },
    Default = "Top",
    Text = "Health Text Position",
    Callback = function(p326)
        vu306.HBTextPos = p326
    end
})
v303:AddToggle("ESP_Distance", {
    Text = "Distance Esp",
    Default = false,
    Callback = function(p327)
        vu306.DistanceEnabled = p327
    end
}):AddColorPicker("ESP_DistanceColor", {
    Default = vu306.DistanceColor,
    Title = "Distance Color",
    Transparency = 0,
    Callback = function(p328)
        vu306.DistanceColor = p328
    end
})
local function vu331(p329)
    local v330 = p329.Character
    if v330 then
        if v330:FindFirstChildOfClass("Humanoid") then
            return v330
        else
            return nil
        end
    else
        return nil
    end
end
local function vu338(p332, p333)
    if type(p332) ~= "table" then
        return false
    end
    local v334, v335, v336 = pairs(p332)
    while true do
        local v337
        v336, v337 = v334(v335, v336)
        if v336 == nil then
            break
        end
        if v337 == p333 then
            return true
        end
    end
    return false
end
local function vu341(p339, p340)
    if not (vu306.TeamCheck and p339.Team) then
        return p340
    end
    if p339.TeamColor then
        p340 = p339.TeamColor.Color or p340
    end
    return p340
end
local function vu353(p342)
    if not p342 then
        return nil
    end
    local v343 = p342:FindFirstChild("HumanoidRootPart")
    if v343 and v343:IsA("BasePart") then
        return v343
    end
    local v344, v345, v346 = ipairs({
        "UpperTorso",
        "LowerTorso",
        "Torso",
        "Head"
    })
    while true do
        local v347
        v346, v347 = v344(v345, v346)
        if v346 == nil then
            break
        end
        local v348 = p342:FindFirstChild(v347)
        if v348 and v348:IsA("BasePart") then
            return v348
        end
    end
    local v349, v350, v351 = ipairs(p342:GetDescendants())
    while true do
        local v352
        v351, v352 = v349(v350, v351)
        if v351 == nil then
            break
        end
        if v352:IsA("BasePart") then
            return v352
        end
    end
    return nil
end
local function vu361(p354)
    local v355 = vu353(p354)
    if not v355 then
        return false
    end
    local v356 = vu109.CurrentCamera and vu109.CurrentCamera.CFrame.Position or workspace.CurrentCamera.CFrame.Position
    local v357 = v355.Position - v356
    local v358 = RaycastParams.new()
    v358.FilterType = Enum.RaycastFilterType.Blacklist
    v358.FilterDescendantsInstances = {}
    if vu219.Character then
        table.insert(v358.FilterDescendantsInstances, vu219.Character)
    end
    if vu109.CurrentCamera then
        table.insert(v358.FilterDescendantsInstances, vu109.CurrentCamera)
    end
    v358.IgnoreWater = true
    local v359 = workspace:Raycast(v356, v357, v358)
    if not v359 then
        return true
    end
    local v360 = v359.Instance
    if v360 then
        v360 = v359.Instance:IsDescendantOf(p354)
    end
    return v360
end
local function vu383(pu362)
    local v363, v364, v365 = pcall(function()
        return pu362:GetBoundingBox()
    end)
    if v363 and v364 then
        local v366 = v365 * 0.5
        local v367 = {
            v364.RightVector,
            v364.UpVector,
            v364.LookVector
        }
        local v368 = {
            v364.Position + v367[1] * v366.X + v367[2] * v366.Y + v367[3] * v366.Z,
            v364.Position + v367[1] * v366.X + v367[2] * v366.Y - v367[3] * v366.Z,
            v364.Position + v367[1] * v366.X - v367[2] * v366.Y + v367[3] * v366.Z,
            v364.Position + v367[1] * v366.X - v367[2] * v366.Y - v367[3] * v366.Z,
            v364.Position - v367[1] * v366.X + v367[2] * v366.Y + v367[3] * v366.Z,
            v364.Position - v367[1] * v366.X + v367[2] * v366.Y - v367[3] * v366.Z,
            v364.Position - v367[1] * v366.X - v367[2] * v366.Y + v367[3] * v366.Z,
            v364.Position - v367[1] * v366.X - v367[2] * v366.Y - v367[3] * v366.Z
        }
        local v369 = math.huge
        local v370 = math.huge
        local v371 = - math.huge
        local v372 = - math.huge
        local v373, v374, v375 = ipairs(v368)
        local v376 = false
        local v377 = {}
        while true do
            local v378
            v375, v378 = v373(v374, v375)
            if v375 == nil then
                break
            end
            local v379, v380 = vu304:WorldToViewportPoint(v378)
            v369 = math.min(v369, v379.X)
            v371 = math.max(v371, v379.X)
            v370 = math.min(v370, v379.Y)
            v372 = math.max(v372, v379.Y)
            v377[v375] = Vector2.new(v379.X, v379.Y)
            v376 = v376 or v380
        end
        if v376 then
            local v381 = v371 - v369
            local v382 = v372 - v370
            if v381 < 2 or v382 < 2 then
                return nil
            else
                return Vector2.new(v369, v370), Vector2.new(v381, v382), Vector2.new(v369 + v381 / 2, v370 + v382 / 2), v377
            end
        else
            return nil
        end
    else
        return nil
    end
end
local function vu392(pu384)
    local v385, v386, v387 = pcall(function()
        return pu384:GetBoundingBox()
    end)
    if not (v385 and v386) then
        return {}
    end
    local v388 = v387 * 0.5
    local v389 = v386.RightVector
    local v390 = v386.UpVector
    local v391 = v386.LookVector
    return {
        v386.Position + v389 * v388.X + v390 * v388.Y + v391 * v388.Z,
        v386.Position + v389 * v388.X + v390 * v388.Y - v391 * v388.Z,
        v386.Position + v389 * v388.X - v390 * v388.Y + v391 * v388.Z,
        v386.Position + v389 * v388.X - v390 * v388.Y - v391 * v388.Z,
        v386.Position - v389 * v388.X + v390 * v388.Y + v391 * v388.Z,
        v386.Position - v389 * v388.X + v390 * v388.Y - v391 * v388.Z,
        v386.Position - v389 * v388.X - v390 * v388.Y + v391 * v388.Z,
        v386.Position - v389 * v388.X - v390 * v388.Y - v391 * v388.Z
    }
end
local function vu398(p393, p394, p395, p396, p397)
    if p393 then
        if p394 == "Top" then
            p393.Center = true
            p393.Position = Vector2.new(p397.X, p395.Y - 14)
        elseif p394 == "Bottom" then
            p393.Center = true
            p393.Position = Vector2.new(p397.X, p395.Y + p396.Y + 6)
        elseif p394 == "Left" then
            p393.Center = false
            p393.Position = Vector2.new(p395.X - 8, p395.Y + p396.Y * 0.5)
        elseif p394 == "Right" then
            p393.Center = false
            p393.Position = Vector2.new(p395.X + p396.X + 8, p395.Y + p396.Y * 0.5)
        else
            p393.Center = true
            p393.Position = Vector2.new(p397.X, p395.Y - 14)
        end
    end
end
local function vu401(p399)
    local v400 = vu304.ViewportSize
    return Vector2.new(math.clamp(p399.X, 0, v400.X), math.clamp(p399.Y, 0, v400.Y))
end
local function vu403(pu402)
    if pu402 then
        pcall(function()
            if typeof(pu402) ~= "Instance" then
                if pu402.Remove then
                    pu402:Remove()
                elseif pu402.Destroy then
                    pu402:Destroy()
                else
                    pu402.Visible = false
                end
            else
                pu402:Destroy()
            end
        end)
    end
end
local function vu413(p404)
    if p404 then
        if p404.BoxFill then
            p404.BoxFill.Visible = false
        end
        if p404.BoxGlow then
            p404.BoxGlow.Visible = false
        end
        if p404.CornerLinesGlow then
            local v405, v406, v407 = ipairs(p404.CornerLinesGlow)
            while true do
                local v408
                v407, v408 = v405(v406, v407)
                if v407 == nil then
                    break
                end
                v408.Visible = false
            end
        end
        if p404.Wire3DGlow then
            local v409, v410, v411 = ipairs(p404.Wire3DGlow)
            while true do
                local v412
                v411, v412 = v409(v410, v411)
                if v411 == nil then
                    break
                end
                v412.Visible = false
            end
        end
        if p404.Tracer then
            p404.Tracer.Visible = false
        end
        if p404.NameText then
            p404.NameText.Visible = false
        end
        if p404.HB_BG then
            p404.HB_BG.Visible = false
        end
        if p404.HB_Fill then
            p404.HB_Fill.Visible = false
        end
        if p404.HBText then
            p404.HBText.Visible = false
        end
        if p404.DistLine1 then
            p404.DistLine1.Visible = false
        end
        if p404.DistLine2 then
            p404.DistLine2.Visible = false
        end
        if p404.DistLine3 then
            p404.DistLine3.Visible = false
        end
        if p404.DistText then
            p404.DistText.Visible = false
        end
    end
end
local function vu420(p414)
    local v415 = vu305[p414]
    if v415 then
        vu413(v415)
        local v416, v417, v418 = pairs(v415)
        while true do
            local v419
            v418, v419 = v416(v417, v418)
            if v418 == nil then
                break
            end
            vu403(v419)
        end
        vu305[p414] = nil
    end
end
local function vu427(pu421)
    if pu421 ~= vu219 then
        if not vu305[pu421] then
            local v422 = {
                BoxGlow = Drawing.new("Square")
            }
            v422.BoxGlow.Visible = false
            v422.BoxGlow.Filled = false
            v422.BoxGlow.Thickness = 2
            v422.BoxFill = Drawing.new("Square")
            v422.BoxFill.Visible = false
            v422.BoxFill.Filled = true
            v422.BoxFill.Transparency = 0.6
            v422.BoxFill.Thickness = 1
            v422.CornerLinesGlow = {}
            for v423 = 1, 8 do
                local v424 = Drawing.new("Line")
                v424.Visible = false
                v424.Thickness = 3
                v422.CornerLinesGlow[v423] = v424
            end
            v422.Wire3DGlow = {}
            for v425 = 1, 12 do
                local v426 = Drawing.new("Line")
                v426.Visible = false
                v426.Thickness = 3
                v422.Wire3DGlow[v425] = v426
            end
            v422.Tracer = Drawing.new("Line")
            v422.Tracer.Visible = false
            v422.Tracer.Thickness = 1.5
            v422.NameText = Drawing.new("Text")
            v422.NameText.Visible = false
            v422.NameText.Size = 13
            v422.NameText.Center = true
            v422.NameText.Outline = true
            v422.NameText.Font = 2
            v422.HB_BG = Drawing.new("Square")
            v422.HB_BG.Visible = false
            v422.HB_BG.Filled = true
            v422.HB_BG.Color = Color3.fromRGB(30, 30, 30)
            v422.HB_Fill = Drawing.new("Square")
            v422.HB_Fill.Visible = false
            v422.HB_Fill.Filled = true
            v422.HBText = Drawing.new("Text")
            v422.HBText.Visible = false
            v422.HBText.Size = 13
            v422.HBText.Center = true
            v422.HBText.Outline = true
            v422.HBText.Font = 2
            v422.DistLine1 = Drawing.new("Line")
            v422.DistLine1.Visible = false
            v422.DistLine1.Thickness = 2
            v422.DistLine2 = Drawing.new("Line")
            v422.DistLine2.Visible = false
            v422.DistLine2.Thickness = 2
            v422.DistLine3 = Drawing.new("Line")
            v422.DistLine3.Visible = false
            v422.DistLine3.Thickness = 1.5
            v422.DistText = Drawing.new("Text")
            v422.DistText.Visible = false
            v422.DistText.Size = 12
            v422.DistText.Center = true
            v422.DistText.Outline = true
            v422.DistText.Font = 2
            vu305[pu421] = v422
            pcall(function()
                pu421.CharacterRemoving:Connect(function()
                    vu413(vu305[pu421])
                end)
            end)
        end
    else
        return
    end
end
vu218.PlayerRemoving:Connect(function(p428)
    vu420(p428)
end)
vu218.PlayerAdded:Connect(function(p429)
    vu427(p429)
end)
local v430, v431, v432 = ipairs(vu218:GetPlayers())
local vu433 = vu413
local vu434 = vu306
local vu435 = vu420
local vu436 = vu353
local vu437 = vu304
local vu438 = vu305
local vu439 = vu427
while true do
    local v440
    v432, v440 = v430(v431, v432)
    if v432 == nil then
        break
    end
    vu439(v440)
end
vu217.RenderStepped:Connect(function()
    local v441, v442, v443 = pairs(vu438)
    while true do
        local v444
        v443, v444 = v441(v442, v443)
        if v443 == nil then
            break
        end
        if not v443 or v443.Parent ~= vu218 then
            vu435(v443)
        end
    end
    if vu434.Enabled then
        vu437 = vu109.CurrentCamera
        local v445 = vu218
        local v446, v447, v448 = ipairs(v445:GetPlayers())
        while true do
            local v449
            v448, v449 = v446(v447, v448)
            if v448 == nil then
                break
            end
            if v449 ~= vu219 then
                local vu450 = vu331(v449)
                local v451 = vu438[v449]
                if not v451 then
                    vu439(v449)
                    v451 = vu438[v449]
                end
                if vu450 then
                    local v452 = vu450:FindFirstChildOfClass("Humanoid")
                    if v452 and v452.Health > 0 then
                        local v453, v454, v455, _ = vu383(vu450)
                        if v453 then
                            if vu434.EspMethod ~= "Wall Check" or vu361(vu450) then
                                local vu456 = vu341(v449, vu434.BoxGlowColor)
                                local v457 = vu341(v449, vu434.BoxFillColor)
                                if vu434.BoxEnabled then
                                    if vu338(vu434.BoxModes, "Fill") and (vu434.BoxDesign == "2D Box" or vu434.BoxDesign == "Corner Box") then
                                        v451.BoxFill.Visible = true
                                        v451.BoxFill.Position = v453
                                        v451.BoxFill.Size = v454
                                        v451.BoxFill.Color = v457
                                        v451.BoxFill.Transparency = 0.6
                                    else
                                        v451.BoxFill.Visible = false
                                    end
                                    if vu434.BoxDesign ~= "2D Box" then
                                        if vu434.BoxDesign ~= "Corner Box" then
                                            v451.BoxGlow.Visible = false
                                            local v458, v459, v460 = ipairs(v451.CornerLinesGlow)
                                            while true do
                                                local v461
                                                v460, v461 = v458(v459, v460)
                                                if v460 == nil then
                                                    break
                                                end
                                                v461.Visible = false
                                            end
                                            local v462 = vu392(vu450)
                                            local v463 = {}
                                            local v464 = false
                                            for v465 = 1, 8 do
                                                local v466, v467 = vu437:WorldToViewportPoint(v462[v465])
                                                v463[v465] = Vector2.new(v466.X, v466.Y)
                                                if not v464 then
                                                    v464 = v467
                                                end
                                            end
                                            if v464 then
                                                local v468 = {
                                                    {
                                                        1,
                                                        2
                                                    },
                                                    {
                                                        1,
                                                        3
                                                    },
                                                    {
                                                        1,
                                                        5
                                                    },
                                                    {
                                                        2,
                                                        4
                                                    },
                                                    {
                                                        2,
                                                        6
                                                    },
                                                    {
                                                        3,
                                                        4
                                                    },
                                                    {
                                                        3,
                                                        7
                                                    },
                                                    {
                                                        4,
                                                        8
                                                    },
                                                    {
                                                        5,
                                                        6
                                                    },
                                                    {
                                                        5,
                                                        7
                                                    },
                                                    {
                                                        6,
                                                        8
                                                    },
                                                    {
                                                        7,
                                                        8
                                                    }
                                                }
                                                for v469 = 1, 12 do
                                                    local v470 = v469
                                                    local v471 = v468[v470]
                                                    local v472 = vu401(v463[v471[1] ])
                                                    local v473 = vu401(v463[v471[2] ])
                                                    local v474 = v451.Wire3DGlow[v470]
                                                    v474.Visible = true
                                                    v474.From = v472
                                                    v474.To = v473
                                                    v474.Color = vu456
                                                end
                                            else
                                                local v475, v476, v477 = ipairs(v451.Wire3DGlow)
                                                while true do
                                                    local v478
                                                    v477, v478 = v475(v476, v477)
                                                    if v477 == nil then
                                                        break
                                                    end
                                                    v478.Visible = false
                                                end
                                            end
                                            v451.BoxFill.Visible = false
                                        else
                                            v451.BoxGlow.Visible = false
                                            local v479, v480, v481 = ipairs(v451.Wire3DGlow)
                                            while true do
                                                local v482
                                                v481, v482 = v479(v480, v481)
                                                if v481 == nil then
                                                    break
                                                end
                                                v482.Visible = false
                                            end
                                            local v483 = math.clamp(math.min(v454.X, v454.Y) * 0.25, 6, 20)
                                            local v484 = Vector2.new(v453.X, v453.Y)
                                            local v485 = Vector2.new(v453.X + v454.X, v453.Y)
                                            local v486 = Vector2.new(v453.X, v453.Y + v454.Y)
                                            local v487 = Vector2.new(v453.X + v454.X, v453.Y + v454.Y)
                                            local vu488 = v451.CornerLinesGlow
                                            local function v493(p489, p490, p491)
                                                local v492 = vu488[p489]
                                                v492.Visible = true
                                                v492.From = vu401(p490)
                                                v492.To = vu401(p491)
                                                v492.Color = vu456
                                            end
                                            v493(1, v484, v484 + Vector2.new(v483, 0))
                                            v493(2, v484, v484 + Vector2.new(0, v483))
                                            v493(3, v485, v485 + Vector2.new(- v483, 0))
                                            v493(4, v485, v485 + Vector2.new(0, v483))
                                            v493(5, v486, v486 + Vector2.new(v483, 0))
                                            v493(6, v486, v486 + Vector2.new(0, - v483))
                                            v493(7, v487, v487 + Vector2.new(- v483, 0))
                                            v493(8, v487, v487 + Vector2.new(0, - v483))
                                        end
                                    else
                                        v451.BoxGlow.Visible = true
                                        v451.BoxGlow.Position = v453
                                        v451.BoxGlow.Size = v454
                                        v451.BoxGlow.Color = vu456
                                        local v494, v495, v496 = ipairs(v451.CornerLinesGlow)
                                        while true do
                                            local v497
                                            v496, v497 = v494(v495, v496)
                                            if v496 == nil then
                                                break
                                            end
                                            v497.Visible = false
                                        end
                                        local v498, v499, v500 = ipairs(v451.Wire3DGlow)
                                        while true do
                                            local v501
                                            v500, v501 = v498(v499, v500)
                                            if v500 == nil then
                                                break
                                            end
                                            v501.Visible = false
                                        end
                                    end
                                else
                                    v451.BoxGlow.Visible = false
                                    v451.BoxFill.Visible = false
                                    local v502, v503, v504 = ipairs(v451.CornerLinesGlow)
                                    while true do
                                        local v505
                                        v504, v505 = v502(v503, v504)
                                        if v504 == nil then
                                            break
                                        end
                                        v505.Visible = false
                                    end
                                    local v506, v507, v508 = ipairs(v451.Wire3DGlow)
                                    while true do
                                        local v509
                                        v508, v509 = v506(v507, v508)
                                        if v508 == nil then
                                            break
                                        end
                                        v509.Visible = false
                                    end
                                end
                                if vu434.NameEnabled then
                                    v451.NameText.Visible = true
                                    v451.NameText.Text = v449.Name
                                    v451.NameText.Color = vu434.NameColor
                                    vu398(v451.NameText, vu434.NamePos, v453, v454, v455)
                                else
                                    v451.NameText.Visible = false
                                end
                                if vu434.HBEnabled then
                                    local v510 = 3
                                    local v511 = 2
                                    local v512 = math.max(v454.Y - v511 * 2, 2)
                                    local v513 = math.clamp(v452.Health / math.max(1, v452.MaxHealth), 0, 1)
                                    local v514 = math.floor(v512 * v513)
                                    local v515
                                    if vu434.HBPosition ~= "Outside Left" then
                                        if vu434.HBPosition ~= "Inside Left" then
                                            if vu434.HBPosition ~= "Outside Right" then
                                                v515 = v453.X + v454.X - v510 - v511
                                            else
                                                v515 = v453.X + v454.X + v511
                                            end
                                        else
                                            v515 = v453.X + v511
                                        end
                                    else
                                        v515 = v453.X - v510 - v511
                                    end
                                    v451.HB_BG.Visible = true
                                    v451.HB_BG.Position = Vector2.new(v515, v453.Y + v511)
                                    v451.HB_BG.Size = Vector2.new(v510, v512)
                                    v451.HB_Fill.Visible = true
                                    v451.HB_Fill.Color = vu434.HBColor
                                    v451.HB_Fill.Size = Vector2.new(v510, v514)
                                    v451.HB_Fill.Position = Vector2.new(v515, v453.Y + v511 + (v512 - v514))
                                else
                                    v451.HB_BG.Visible = false
                                    v451.HB_Fill.Visible = false
                                end
                                if vu434.HBTextEnabled then
                                    v451.HBText.Visible = true
                                    local v516 = math.floor(v452.Health)
                                    v451.HBText.Text = "\226\157\164 " .. tostring(v516)
                                    v451.HBText.Color = vu434.HBColor
                                    vu398(v451.HBText, vu434.HBTextPos, v453, v454, v455)
                                else
                                    v451.HBText.Visible = false
                                end
                                if vu434.TracerEnabled then
                                    v451.Tracer.Visible = true
                                    v451.Tracer.Color = vu434.TracerColor
                                    local v517 = vu437.ViewportSize
                                    local v518
                                    if vu434.TracerOrigin ~= "Bottom" then
                                        if vu434.TracerOrigin ~= "Center" then
                                            v518 = Vector2.new(v517.X * 0.5, 2)
                                        else
                                            v518 = Vector2.new(v517.X * 0.5, v517.Y * 0.5)
                                        end
                                    else
                                        v518 = Vector2.new(v517.X * 0.5, v517.Y - 2)
                                    end
                                    local v519 = vu401(Vector2.new(v455.X, v455.Y))
                                    v451.Tracer.From = v518
                                    v451.Tracer.To = v519
                                else
                                    v451.Tracer.Visible = false
                                end
                                if vu434.DistanceEnabled then
                                    local v520 = math.clamp(math.min(v454.X, v454.Y) * 0.12, 6, 24)
                                    local v521 = Vector2.new(v455.X, v453.Y - 8)
                                    local v522 = Vector2.new(v455.X - v520, v453.Y - 8 - v520)
                                    local v523 = Vector2.new(v455.X + v520, v453.Y - 8 - v520)
                                    local v524 = vu401(v521)
                                    local v525 = vu401(v522)
                                    local v526 = vu401(v523)
                                    v451.DistLine1.Visible = true
                                    v451.DistLine1.From = v524
                                    v451.DistLine1.To = v525
                                    v451.DistLine1.Color = vu434.DistanceColor
                                    v451.DistLine2.Visible = true
                                    v451.DistLine2.From = v524
                                    v451.DistLine2.To = v526
                                    v451.DistLine2.Color = vu434.DistanceColor
                                    v451.DistLine3.Visible = true
                                    v451.DistLine3.From = v525
                                    v451.DistLine3.To = v526
                                    v451.DistLine3.Color = vu434.DistanceColor
                                    local vu527 = 0
                                    pcall(function()
                                        local v528 = vu219.Character
                                        if v528 then
                                            v528 = vu436(v528)
                                        end
                                        local v529 = vu436(vu450)
                                        if v528 and v529 then
                                            vu527 = math.floor((v528.Position - v529.Position).Magnitude)
                                        end
                                    end)
                                    v451.DistText.Visible = true
                                    v451.DistText.Text = tostring(vu527) .. " studs"
                                    v451.DistText.Color = vu434.DistanceColor
                                    v451.DistText.Position = Vector2.new(v524.X, v524.Y - v520 - 6)
                                    v451.DistText.Center = true
                                else
                                    v451.DistLine1.Visible = false
                                    v451.DistLine2.Visible = false
                                    v451.DistLine3.Visible = false
                                    v451.DistText.Visible = false
                                end
                            else
                                vu433(v451)
                            end
                        else
                            vu433(v451)
                        end
                    else
                        vu433(v451)
                    end
                else
                    vu433(v451)
                end
            end
        end
    else
        local v530, v531, v532 = pairs(vu438)
        while true do
            local v533
            v532, v533 = v530(v531, v532)
            if v532 == nil then
                break
            end
            vu433(v533)
        end
    end
end)
local v534 = v5:AddTab("Misc")
local v535 = v534:AddLeftGroupbox("Performance")
local v536 = v534:AddRightGroupbox("Server")
local vu537 = {}
local vu538 = {}
local vu539 = {
    GlobalShadows = game.Lighting.GlobalShadows,
    FogEnd = game.Lighting.FogEnd,
    Brightness = game.Lighting.Brightness
}
local vu540 = {
    WaterWaveSize = game.Workspace.Terrain.WaterWaveSize,
    WaterWaveSpeed = game.Workspace.Terrain.WaterWaveSpeed,
    WaterReflectance = game.Workspace.Terrain.WaterReflectance,
    WaterTransparency = game.Workspace.Terrain.WaterTransparency
}
local vu541 = {}
v535:AddToggle("AntiLag", {
    Text = "Anti Lag",
    Default = false,
    Callback = function(p542)
        if p542 then
            local v543, v544, v545 = pairs(game:GetService("Workspace"):GetDescendants())
            while true do
                local v546
                v545, v546 = v543(v544, v545)
                if v545 == nil then
                    break
                end
                if v546:IsA("BasePart") and not v546.Parent:FindFirstChild("Humanoid") then
                    vu537[v546] = v546.Material
                    v546.Material = Enum.Material.SmoothPlastic
                    local v547, v548, v549 = ipairs(v546:GetDescendants())
                    while true do
                        local vu550
                        v549, vu550 = v547(v548, v549)
                        if v549 == nil then
                            break
                        end
                        if vu550:IsA("Decal") or vu550:IsA("Texture") then
                            table.insert(vu538, vu550)
                            pcall(function()
                                vu550:Destroy()
                            end)
                        end
                    end
                end
            end
        else
            local v551, v552, v553 = pairs(vu537)
            while true do
                local v554
                v553, v554 = v551(v552, v553)
                if v553 == nil then
                    break
                end
                if v553 and v553:IsA("BasePart") then
                    v553.Material = v554
                end
            end
            vu537 = {}
        end
    end
})
v535:AddToggle("FPSBoost", {
    Text = "FPS Boost",
    Default = false,
    Callback = function(p555)
        if p555 then
            local v556 = game
            local v557 = v556.Workspace
            local v558 = v556.Lighting
            local v559 = v557.Terrain
            vu540.WaterWaveSize = v559.WaterWaveSize
            vu540.WaterWaveSpeed = v559.WaterWaveSpeed
            vu540.WaterReflectance = v559.WaterReflectance
            vu540.WaterTransparency = v559.WaterTransparency
            v559.WaterWaveSize = 0
            v559.WaterWaveSpeed = 0
            v559.WaterReflectance = 0
            v559.WaterTransparency = 0
            v558.GlobalShadows = false
            v558.FogEnd = 9000000000
            v558.Brightness = 0
            pcall(function()
                settings().Rendering.QualityLevel = "Level01"
            end)
            local v560, v561, v562 = pairs(v556:GetDescendants())
            while true do
                local vu563
                v562, vu563 = v560(v561, v562)
                if v562 == nil then
                    break
                end
                if vu563:IsA("Part") or (vu563:IsA("Union") or (vu563:IsA("CornerWedgePart") or vu563:IsA("TrussPart"))) then
                    vu537[vu563] = vu563.Material
                    vu563.Material = "Plastic"
                    vu563.Reflectance = 0
                elseif vu563:IsA("Decal") or vu563:IsA("Texture") then
                    table.insert(vu538, vu563)
                    vu563.Transparency = 1
                elseif vu563:IsA("ParticleEmitter") or vu563:IsA("Trail") then
                    vu563.Lifetime = NumberRange.new(0)
                elseif vu563:IsA("Explosion") then
                    vu563.BlastPressure = 1
                    vu563.BlastRadius = 1
                elseif vu563:IsA("Fire") or (vu563:IsA("SpotLight") or vu563:IsA("Smoke")) then
                    vu563.Enabled = false
                elseif vu563:IsA("MeshPart") then
                    vu537[vu563] = vu563.Material
                    vu563.Material = "Plastic"
                    vu563.Reflectance = 0
                    pcall(function()
                        vu563.TextureID = 0
                    end)
                end
            end
            local v564, v565, v566 = pairs(v558:GetChildren())
            while true do
                local v567
                v566, v567 = v564(v565, v566)
                if v566 == nil then
                    break
                end
                if v567:IsA("BlurEffect") or (v567:IsA("SunRaysEffect") or (v567:IsA("ColorCorrectionEffect") or (v567:IsA("BloomEffect") or v567:IsA("DepthOfFieldEffect")))) then
                    vu541[v567] = v567.Enabled
                    v567.Enabled = false
                end
            end
        else
            local v568 = game.Workspace.Terrain
            v568.WaterWaveSize = vu540.WaterWaveSize
            v568.WaterWaveSpeed = vu540.WaterWaveSpeed
            v568.WaterReflectance = vu540.WaterReflectance
            v568.WaterTransparency = vu540.WaterTransparency
            game.Lighting.GlobalShadows = vu539.GlobalShadows
            game.Lighting.FogEnd = vu539.FogEnd
            game.Lighting.Brightness = vu539.Brightness
            pcall(function()
                settings().Rendering.QualityLevel = "Automatic"
            end)
            local v569, v570, v571 = pairs(vu537)
            while true do
                local v572
                v571, v572 = v569(v570, v571)
                if v571 == nil then
                    break
                end
                if v571 and v571:IsA("BasePart") then
                    v571.Material = v572
                    v571.Reflectance = 0
                end
            end
            vu537 = {}
            local v573, v574, v575 = pairs(vu541)
            while true do
                local v576
                v575, v576 = v573(v574, v575)
                if v575 == nil then
                    break
                end
                if v575 then
                    v575.Enabled = v576
                end
            end
            vu541 = {}
            local v577, v578, v579 = pairs(vu538)
            while true do
                local vu580
                v579, vu580 = v577(v578, v579)
                if v579 == nil then
                    break
                end
                if vu580 and vu580.Parent then
                    pcall(function()
                        vu580.Transparency = 0
                    end)
                end
            end
            vu538 = {}
        end
    end
})
local vu581 = false
v535:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(p582)
        vu581 = p582
        local vu583 = game:GetService("Lighting")
        local function v584()
            if vu581 then
                vu583.Ambient = Color3.new(1, 1, 1)
                vu583.ColorShift_Bottom = Color3.new(1, 1, 1)
                vu583.ColorShift_Top = Color3.new(1, 1, 1)
            else
                vu583.Ambient = Color3.new(0.5, 0.5, 0.5)
                vu583.ColorShift_Bottom = Color3.new(0, 0, 0)
                vu583.ColorShift_Top = Color3.new(0, 0, 0)
            end
        end
        v584()
        vu583.LightingChanged:Connect(v584)
    end
})
v536:AddButton("Server Hop", function()
    local vu585 = game.PlaceId
    local vu586 = {}
    local vu587 = ""
    local vu588 = os.date("!*t").hour
    pcall(function()
        vu586 = vu18:JSONDecode(readfile("NotSameServers.json"))
    end)
    if # vu586 == 0 then
        pcall(function()
            local v589 = vu18
            local v590 = {
                vu588
            }
            writefile("NotSameServers.json", v589:JSONEncode(v590))
        end)
    end
    local function vu603()
        local vu591 = nil
        pcall(function()
            if vu587 ~= "" then
                vu591 = vu18:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. vu585 .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. vu587))
            else
                vu591 = vu18:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. vu585 .. "/servers/Public?sortOrder=Asc&limit=100"))
            end
        end)
        if not (vu591 and vu591.data) then
            return
        end
        if vu591.nextPageCursor and (vu591.nextPageCursor ~= "null" and vu591.nextPageCursor ~= nil) then
            vu587 = vu591.nextPageCursor
        end
        local v592, v593, v594 = pairs(vu591.data)
        while true do
            local v595
            v594, v595 = v592(v593, v594)
            if v594 == nil then
                return
            end
            local v596 = true
            local vu597 = tostring(v595.id)
            if tonumber(v595.maxPlayers) > tonumber(v595.playing) then
                local v598, v599, v600 = pairs(vu586)
                while true do
                    local v601
                    v600, v601 = v598(v599, v600)
                    if v600 == nil then
                        break
                    end
                    if vu597 == tostring(v601) then
                        v596 = false
                        break
                    end
                end
                if v596 then
                    table.insert(vu586, vu597)
                    pcall(function()
                        local v602 = vu18
                        writefile("NotSameServers.json", v602:JSONEncode(vu586))
                    end)
                    pcall(function()
                        game:GetService("TeleportService"):TeleportToPlaceInstance(vu585, vu597, game.Players.LocalPlayer)
                    end)
                    wait(4)
                end
            end
        end
    end
    spawn(function()
        while true do
            pcall(function()
                vu603()
                if vu587 ~= "" then
                    vu603()
                end
            end)
            wait(1)
        end
    end)
end)
v536:AddButton("Rejoin Server", function()
    pcall(function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end)
end)
local v604 = {
    ["UI Settings"] = v5:AddTab("Settings")
}
local v605 = v604["UI Settings"]:AddLeftGroupbox("Menu")
v605:AddToggle("KeybindMenuOpen", {
    Default = vu2.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Tooltip = "Show/hide the keybinds UI",
    Callback = function(p606)
        vu2.KeybindFrame.Visible = p606
    end
})
v605:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Tooltip = "Enable/disable custom mouse cursor",
    Callback = function(p607)
        vu2.ShowCustomCursor = p607
    end
})
v605:AddDropdown("NotificationSide", {
    Values = {
        "Left",
        "Right"
    },
    Default = "Right",
    Text = "Notification Side",
    Tooltip = "Where notifications will appear",
    Callback = function(p608)
        vu2:SetNotifySide(p608)
    end
})
v605:AddDropdown("DPIScale", {
    Values = {
        "50%",
        "75%",
        "100%",
        "125%",
        "150%",
        "175%",
        "200%"
    },
    Default = "100%",
    Text = "DPI Scale",
    Tooltip = "Adjust UI size",
    Callback = function(p609)
        local v610 = p609:gsub("%%", "")
        local v611 = tonumber(v610)
        if v611 then
            vu2:SetDPIScale(v611)
        end
    end
})
v605:AddDivider()
v605:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightAlt",
    NoUI = true,
    Text = "Menu keybind"
})
v605:AddButton("Unload Script", function()
    vu2:Unload()
end)
vu2.ToggleKeybind = vu2.Options.MenuKeybind
v3:SetLibrary(vu2)
v4:SetLibrary(vu2)
v4:IgnoreThemeSettings()
v4:SetIgnoreIndexes({
    "MenuKeybind"
})
v3:SetFolder("JX-ARSENAL")
v4:SetFolder("JX-ARSENAL/ARSENAL")
v4:SetSubFolder("ARSENAL")
v4:BuildConfigSection(v604["UI Settings"])
v3:ApplyToTab(v604["UI Settings"])
v4:LoadAutoloadConfig()
