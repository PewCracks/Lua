local unBangRateLimit = 5;

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local camera = workspace.Camera;

local player = players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character and character.Humanoid or false;
local rootPart = humanoid and humanoid.RootPart or false;

local playerConnections, heartbeatConnections = {}, {};
local trustedIds = {
    player.UserId;
};
local bannedIds = {
    148840371, -- R6 IY
    5918726674 -- R15 IY
};

local lastUnBang = tick()
workspace.FallenPartsDestroyHeight = 0/0;

local function isBot(user)
    -- // Annoying dhrp blush bots
    if user:find("blush") and (user:find("gg") or user:find("join")) then
        return true;
    end;

    return false;
end;

local function Initialize(cachedTargetUserId)
    local targetUserId = cachedTargetUserId;

    if heartbeatConnections[targetUserId] then
        heartbeatConnections[targetUserId]:Disconnect()
    end;
    
    return function(targetCharacter)
        heartbeatConnections[targetUserId] = runservice.Heartbeat:Connect(function()
            local targetHumanoid = targetCharacter and targetCharacter:FindFirstChild("Humanoid") or false;
            if not targetHumanoid or not rootPart then return; end;

            local targetRootPart = targetHumanoid and targetHumanoid.RootPart or false;
            if not targetRootPart then return; end;
            local magnitude = (targetRootPart.Position - rootPart.Position).Magnitude;

            if magnitude > 3 or targetHumanoid.SeatPart then return; end;

            local fuckUp = false;
            local target = tostring(game.Players:GetPlayerByUserId(targetUserId)):lower()
            
            if targetHumanoid.Sit or isBot(target) then
                fuckUp = true;
            else
                local activeTracks = targetHumanoid:GetPlayingAnimationTracks()
                for i,v in pairs(activeTracks) do
                    local animationId = v.Animation.AnimationId;

                    for _,x in pairs(bannedIds) do
                        if string.find(animationId, tostring(x)) then
                            fuckUp = true;
                            break;
                        end;
                    end;

                    if fuckUp then
                        break;
                    end;
                end;
            end;
            
            if not fuckUp then return; end;
            if tick()-lastUnBang <= unBangRateLimit then return; end;
            lastUnBang = tick()

            camera.CameraType = Enum.CameraType.Fixed;
            local currentPosition = rootPart.CFrame;
            rootPart.CFrame = currentPosition + Vector3.new(0, -1e3, 0);
            task.wait(.3)
            rootPart.CFrame = currentPosition;
            camera.CameraType = Enum.CameraType.Custom;
        end)
    end;
end;

for i,v in pairs(players:GetPlayers()) do
    local targetUserId = v.UserId;

    if table.find(trustedIds, targetUserId) then continue; end;

    playerConnections[targetUserId] = v.CharacterAdded:Connect(Initialize(targetUserId))

    Initialize(targetUserId)(v.Character)
end;

local newPlayer = players.PlayerAdded:Connect(function(v)
    local targetUserId = v.UserId;
    if playerConnections[targetUserId] then playerConnections[targetUserId]:Disconnect() end;

    playerConnections[targetUserId] = v.CharacterAdded:Connect(Initialize(targetUserId))
    Initialize(targetUserId)(v and v.CharacterAdded:Wait() and v.Character)
end)

local G = getgenv();
if G.stopAll then G.stopAll() end;

G.stopAll = function()
    for i,v in pairs(heartbeatConnections) do
        v:Disconnect()
    end;

    for i,v in pairs(playerConnections) do
        v:Disconnect()
    end;

    newPlayer:Disconnect()

    G.stopAll = nil;
end;
