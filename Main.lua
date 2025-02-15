local _ = loadstring(game:HttpGet("https://github.com/eltrul/Bocchi/raw/refs/heads/main/BFKaitunConstants.lua"))(); 
local QuestManager = loadstring(game:HttpGet("https://github.com/eltrul/Bocchi/raw/refs/heads/main/BFQuestManager.lua"))();

ScriptStorage = {
    IsInitalized = false, 
    PlayerData = {}, 
    
    Connections = {
        LocalPlayer = {}
    }
} 

Players = game.Players 
LocalPlayer = Players.LocalPlayer 
Character = LocalPlayer.Character 

Humanoid = Character:WaitForChild("Humanoid") 
HumanoidRootPart = Character:WaitForChild("HumanoidRootPart") 

Services = {} 
Remotes = {} 

setmetatable(Services, {__index = function(_, Index) 
    return game:GetService(Index)
end
}); 

setmetatable(Remotes, {__index = function(_, Index) 
        return Services.ReplicatedStorage.Remotes[Index]
    end 
})

function AwaitUntilPlayerLoaded(Player, Timeout) 
    repeat wait() until Player.Character 
    
    Player.Character:WaitForChild("Humanoid") 
    repeat wait() until Player.Character.Humanoid.Health > 0
end 

function RegisterLocalPlayerEventsConnection() 
    
    for _, Connection in ScriptStorage.Connections.LocalPlayer do 
        pcall(function() 
            Connection:Disconnect() 
        end) 
    end 
    
    AwaitUntilPlayerLoaded(LocalPlayer) 
    
    pcall(function() 
        for _, ChildInstance in LocalPlayer.Data do 
            if not ChildInstance:IsA("Folder") then 
                ScriptStorage.Connections.LocalPlayer[ChildInstance.Name] = 1 
            end 
        end 
    end)
    
    LocalPlayer:SetAttribute("IsAvailable", true)
    
    ScriptStorage.Connections.LocalPlayer["HealthCheck"] = LocalPlayer.Character:WaitForChild("Humanoid"):GetPropertyChangedSignal("Health"):Connect(function() 
        local Health = LocalPlayer.Character.Humanoid.Health 
        
        LocalPlayer:SetAttribute("IsAvailable", Health > 10)
        ScriptStorage.LocalPlayerHealth = Health
    end)
    
end 

RegisterLocalPlayerEventsConnection(LocalPlayer) 

Players.PlayerAdded:Connect(function(Player) 
    if tostring(Player) == tostring(LocalPlayer) then 
        RegisterLocalPlayerEventsConnection(Player) 
    end 
end) 
