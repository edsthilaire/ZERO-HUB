--[[
    ZERO HUB - BLOX FRUITS
    Created by: edsthilaire
    Last Update: 2025-10-30 21:55:41 UTC
    Discord: discord.gg/zerohub
]]

-- Verificar si es Blox Fruits
if game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635 then
    -- Cargar UI Library
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

    -- Variables Globales
    getgenv().Settings = {
        AutoQuest = false,
        AutoFarm = false,
        FastAttack = true,
        FarmDistance = 5,
        SelectedStat = "Melee",
        AutoStats = false,
        WhiteScreen = false
    }

    -- Crear Ventana Principal
    local Window = OrionLib:MakeWindow({
        Name = "ZERO HUB | Blox Fruits", 
        HidePremium = false,
        SaveConfig = true, 
        IntroEnabled = true,
        IntroText = "ZERO HUB",
        ConfigFolder = "ZERO_HUB"
    })

    -- Crear Tabs
    local Tabs = {
        Quest = Window:MakeTab({Name = "🎯 Auto Quest", Icon = "rbxassetid://4483345998"}),
        Farm = Window:MakeTab({Name = "⚔️ Farm", Icon = "rbxassetid://4483345998"}),
        Stats = Window:MakeTab({Name = "📊 Stats", Icon = "rbxassetid://4483345998"}),
        Teleport = Window:MakeTab({Name = "📍 Teleport", Icon = "rbxassetid://4483345998"}),
        Misc = Window:MakeTab({Name = "⚙️ Misc", Icon = "rbxassetid://4483345998"})
    }

    -- Funciones
    local function GetPlayerLevel()
        local Player = game.Players.LocalPlayer
        if Player.Data and Player.Data.Level then
            return Player.Data.Level.Value
        end
        return 1
    end

    local function SaveSettings()
        local json = game:GetService("HttpService"):JSONEncode(getgenv().Settings)
        writefile("ZERO_HUB/settings.json", json)
    end

    local function LoadSettings()
        if isfile("ZERO_HUB/settings.json") then
            getgenv().Settings = game:GetService("HttpService"):JSONDecode(readfile("ZERO_HUB/settings.json"))
        end
    end

    -- Auto Quest Tab
    Tabs.Quest:AddToggle({
        Name = "Enable Auto Quest",
        Default = false,
        Flag = "AutoQuest",
        Save = true,
        Callback = function(Value)
            getgenv().Settings.AutoQuest = Value
            SaveSettings()
        end
    })

    -- Farm Tab
    Tabs.Farm:AddToggle({
        Name = "Enable Auto Farm",
        Default = false,
        Flag = "AutoFarm",
        Save = true,
        Callback = function(Value)
            getgenv().Settings.AutoFarm = Value
            SaveSettings()
        end
    })

    -- Stats Tab
    Tabs.Stats:AddDropdown({
        Name = "Select Stat",
        Default = "Melee",
        Options = {"Melee", "Defense", "Sword", "Gun", "Demon Fruit"},
        Flag = "SelectedStat",
        Save = true,
        Callback = function(Value)
            getgenv().Settings.SelectedStat = Value
            SaveSettings()
        end
    })

    -- Misc Tab
    Tabs.Misc:AddToggle({
        Name = "White Screen",
        Default = false,
        Flag = "WhiteScreen",
        Save = true,
        Callback = function(Value)
            getgenv().Settings.WhiteScreen = Value
            SaveSettings()
            if Value then
                game:GetService("RunService"):Set3dRenderingEnabled(false)
            else
                game:GetService("RunService"):Set3dRenderingEnabled(true)
            end
        end
    })

    -- Anti AFK
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    -- Notify al iniciar
    OrionLib:MakeNotification({
        Name = "ZERO HUB",
        Content = "Script iniciado correctamente!\nCreado por: edsthilaire",
        Image = "rbxassetid://4483345998",
        Time = 5
    })

    -- Cargar configuración
    LoadSettings()

    -- Init Library
    OrionLib:Init()
else
    game.Players.LocalPlayer:Kick("🛑 Este script solo funciona en Blox Fruits!")
end
