local games = {
    ["Arsenal"] = {
        Ids = {286090429},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Arsenal"
    },
    ["Criminality"] = {
        Ids = {8343259840, 4588604953, 15169310267, 15169306359, 15169303036, 15169316384},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Criminality"
    },
    ["Murder Mystery 2"] = {
        Ids = {142823291},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Murder%20Mystery%202"
    },
    ["Build A Boat For A Treasure"] = {
        Ids = {537413528},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Build%20A%20Boat%20For%20A%20Treasure"
    },
    ["Anime Slap Tower"] = {
        Ids = {100055483398966},
        Script = "https://api.junkie-development.de/api/v1/luascripts/public/3506019d1683b65e21d48ab79d3f63c9cbbe6e09027bc200cb4829e803d37356/download"
    },
    ["99 Nights In The Forest"] = {
        Ids = {79546208627805, 126371807511901, 126509999114328},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/99%20Nights%20In%20The%20Forest"
    },
    ["Guess The County Flag Or Die"] = {
        Ids = {88817068170433},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Guess%20The%20Country%20Flag%20Or%20Die"
    },
    ["Blade Ball"] = {
        Ids = {
            13772394625, 14732610803, 14732683453, 15144787112,
            15144793136, 15165605681, 16064107724, 16456370330,
            16581637217, 16581648071, 17757592456, 92458008626219,
            111661204337143
        },
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Blade%20Ball"
    },
    ["Ro-Ghoul"] = {
        Ids = {914010731, 82244035210998, 109697727506667},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Ro-Ghoul"
    },
    ["Rivals"] = {
        Ids = {17625359962, 18126510175, 71874690745115, 117398147513099},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Rivals"
    },
    ["Tower Of Zombies"] = {
        Ids = {87226801158617, 87558966821867, 99122501338948, 102894077566745, 103051712867691},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Tower%20Of%20Zombies"
    },
    ["Steal A Brainrot"] = {
        Ids = {96342491571673, 109983668079237, 128762245270197},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Steal%20A%20Brainrot"
    },
    ["Blox Fruit"] = {
        Ids = {2753915549, 4442272183, 7449423635, 73902483975735, 76401440271920, 79091703265657, 85211729168715, 92968389658553, 95165932064349, 100117331123089, 101151419317285, 117896981438898, 122478697296975},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Blox%20Fruit"
    },
    ["Legends Of Speed"] = {
        Ids = {3101667897, 3232996272, 3276265788},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Legends%20Of%20Speed"
    },
    ["Murder VS Sheriff Duels"] = {
        Ids = {12355337193, 13771457545, 14195703130, 15385224902, 75453361115735},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Murder%20Vs%20Sheriff%20Dules"
    },
    ["Violence District"] = {
        Ids = {93978595733734},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Violence%20District"
    },
    ["Evade"] = {
        Ids = {9872472334, 10324346056, 10324347967, 10662542523, 10808838353, 11353528705, 96537472072550, 99214917572799, 121271605799901},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Evade"
    },
    ["Ninja Legends"] = {
        Ids = {3956818381},
        Script = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Ninja%20Legends"
    }
}

local placeId = game.PlaceId
local foundScript = nil
local gameName = nil

for name, data in pairs(games) do
    for _, id in ipairs(data.Ids) do
        if id == placeId then
            foundScript = data.Script
            gameName = name
            break
        end
    end
    if foundScript then break end
end

local function notify(title, text, dur)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Icon = "http://www.roblox.com/asset/?id=85279746515974",
            Duration = dur or 5
        })
    end)
end

local function createLoadingScreen(callback)
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "JXLoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = playerGui
    
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(1, 0, 1, 100)
    background.Position = UDim2.new(0, 0, 0, -100)
    background.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    background.BorderSizePixel = 0
    background.ZIndex = 10
    background.Parent = screenGui
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 25)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 25, 45))
    }
    gradient.Rotation = 45
    gradient.Parent = background
    
    local iconFrame = Instance.new("Frame")
    iconFrame.Name = "IconFrame"
    iconFrame.Size = UDim2.new(0, 120, 0, 120)
    iconFrame.Position = UDim2.new(0.5, -60, 0.5, -100)
    iconFrame.BackgroundTransparency = 1
    iconFrame.ZIndex = 11
    iconFrame.Parent = background
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "RobloxIcon"
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.Position = UDim2.new(0, 0, 0, 0)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://85279746515974"
    icon.ZIndex = 12
    icon.Parent = iconFrame
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0.5, 0)
    iconCorner.Parent = icon
    
    local jxText = Instance.new("TextLabel")
    jxText.Name = "JXText"
    jxText.Size = UDim2.new(0, 150, 0, 80)
    jxText.Position = UDim2.new(0.5, -75, 0.5, 50)
    jxText.BackgroundTransparency = 1
    jxText.Text = "JX"
    jxText.TextColor3 = Color3.fromRGB(255, 255, 255)
    jxText.TextScaled = true
    jxText.Font = Enum.Font.GothamBold
    jxText.ZIndex = 13
    jxText.TextTransparency = 1
    jxText.Parent = background
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(0, 300, 0, 40)
    loadingText.Position = UDim2.new(0.5, -150, 0.5, 120)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Loading..."
    loadingText.TextColor3 = Color3.fromRGB(200, 200, 200)
    loadingText.TextScaled = true
    loadingText.Font = Enum.Font.Gotham
    loadingText.ZIndex = 13
    loadingText.TextTransparency = 1
    loadingText.Parent = background
    
    local spinTween = TweenService:Create(
        iconFrame,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Rotation = 360}
    )
    spinTween:Play()
    
    local loadingFadeIn = TweenService:Create(
        loadingText,
        TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {TextTransparency = 0}
    )
    loadingFadeIn:Play()
    
    wait(1.5)
    
    local jxFadeIn = TweenService:Create(
        jxText,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {TextTransparency = 0, Position = UDim2.new(0.5, -75, 0.5, 30)}
    )
    
    local jxJump = TweenService:Create(
        jxText,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -75, 0.5, 10)}
    )
    
    local jxLand = TweenService:Create(
        jxText,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.5, -75, 0.5, 30)}
    )
    
    jxFadeIn:Play()
    jxFadeIn.Completed:Connect(function()
        jxJump:Play()
        jxJump.Completed:Connect(function()
            jxLand:Play()
            wait(1)
            spinTween:Cancel()
            screenGui:Destroy()
            if callback then callback() end
        end)
    end)
end

local function loadScript(scriptUrl, scriptName)
    notify("JX-Loader", "Loading " .. tostring(scriptName) .. "...")
    local okFetch, body = pcall(function()
        return game:HttpGet(scriptUrl)
    end)
    if okFetch and type(body) == "string" and #body > 0 then
        local okLoad, fn = pcall(loadstring, body)
        if okLoad and type(fn) == "function" then
            pcall(fn)
        else
            notify("JX-Loader", "Failed to load " .. scriptName .. " (compile).", 5)
        end
    else
        notify("JX-Loader", "Failed to fetch " .. scriptName .. " script.", 5)
    end
end

local function createUnsupportedGameUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "JXLoaderUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    local UserInputService = game:GetService("UserInputService")
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    if isMobile then
        mainFrame.Size = UDim2.new(0.95, 0, 0.8, 0)
        mainFrame.Position = UDim2.new(0.025, 0, 0.1, 0)
    else
        mainFrame.Size = UDim2.new(0, 400, 0, 500)
        mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    end
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 5
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = mainFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 45)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    }
    gradient.Rotation = 135
    gradient.Parent = mainFrame
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    header.BorderSizePixel = 0
    header.ZIndex = 6
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "JX-Loader - Available Scripts"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 7
    title.Parent = header
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 40, 0, 40)
    closeButton.Position = UDim2.new(1, -50, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.ZIndex = 7
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "ScriptList"
    scrollFrame.Size = UDim2.new(1, -20, 1, -80)
    scrollFrame.Position = UDim2.new(0, 10, 0, 70)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 200)
    scrollFrame.ZIndex = 6
    scrollFrame.Parent = mainFrame
    
    local scrollCorner = Instance.new("UICorner")
    scrollCorner.CornerRadius = UDim.new(0, 12)
    scrollCorner.Parent = scrollFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.Name
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = scrollFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 15)
    padding.PaddingBottom = UDim.new(0, 15)
    padding.PaddingLeft = UDim.new(0, 15)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = scrollFrame
    
    local buttonCount = 0
    for scriptName, data in pairs(games) do
        buttonCount = buttonCount + 1
        
        local scriptButton = Instance.new("TextButton")
        scriptButton.Name = scriptName
        scriptButton.Size = UDim2.new(1, -20, 0, isMobile and 60 or 50)
        scriptButton.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        scriptButton.Text = scriptName
        scriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptButton.TextScaled = true
        scriptButton.Font = Enum.Font.Gotham
        scriptButton.ZIndex = 7
        scriptButton.Parent = scrollFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 10)
        buttonCorner.Parent = scriptButton
        
        local buttonGradient = Instance.new("UIGradient")
        buttonGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 120)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 90))
        }
        buttonGradient.Rotation = 45
        buttonGradient.Parent = scriptButton
        
        local originalColor = Color3.fromRGB(70, 70, 100)
        local hoverColor = Color3.fromRGB(100, 100, 140)
        
        scriptButton.MouseEnter:Connect(function()
            local hoverTween = game:GetService("TweenService"):Create(
                scriptButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = hoverColor, Size = UDim2.new(1, -15, 0, isMobile and 65 or 55)}
            )
            hoverTween:Play()
        end)
        
        scriptButton.MouseLeave:Connect(function()
            local leaveTween = game:GetService("TweenService"):Create(
                scriptButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = originalColor, Size = UDim2.new(1, -20, 0, isMobile and 60 or 50)}
            )
            leaveTween:Play()
        end)
        
        scriptButton.MouseButton1Click:Connect(function()
            local clickTween = game:GetService("TweenService"):Create(
                scriptButton,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, -25, 0, isMobile and 55 or 45)}
            )
            clickTween:Play()
            clickTween.Completed:Connect(function()
                screenGui:Destroy()
                loadScript(data.Script, scriptName)
            end)
        end)
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, buttonCount * (isMobile and 68 or 58) + 30)
    
    closeButton.MouseButton1Click:Connect(function()
        local fadeOut = game:GetService("TweenService"):Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}
        )
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    if not isMobile then
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = mainFrame.Position
            end
        end)
        
        header.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        header.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    local slideIn = game:GetService("TweenService"):Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {Size = isMobile and UDim2.new(0.95, 0, 0.8, 0) or UDim2.new(0, 400, 0, 500)}
    )
    
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    slideIn:Play()
    slideIn.Completed:Connect(function()
        mainFrame.Position = isMobile and UDim2.new(0.025, 0, 0.1, 0) or UDim2.new(0.5, -200, 0.5, -250)
    end)
end

if foundScript then
    createLoadingScreen(function()
        loadScript(foundScript, gameName)
    end)
else
    createLoadingScreen(function()
        notify("JX-Loader", "Game not supported. Opening script selector...", 3)
        createUnsupportedGameUI()
    end)
end
