local COMMAND_PREFIX = ".";
local IDENTIFIER_ALL = "*";
local WHITELISTED_IDS = {
	2823434956, 405922557
};

local G = getgenv()
local connections = {};
local connect = game.Loaded.Connect;

if G.ADMINCOMMANDS then pcall(G.ADMINCOMMANDS) end;

local function getService(service)
    service = game:GetService(service)
    return cloneref and cloneref(service) or service;
end;

local function addConnection(con, callback)
    local connection = connect(con, callback)
    connections[#connections + 1] = connection;
    return connection;
end;

local runService = getService("RunService")
local players = getService("Players")
local textChatService = getService("TextChatService")
local replicatedStorage = getService("ReplicatedStorage")
local soundService = getService("SoundService")
local debris = getService("Debris")

local isLegacyChat = textChatService.ChatVersion == Enum.ChatVersion.LegacyChatService;

local player = players.LocalPlayer;
local character = player.character;
local humanoid = character and character:FindFirstChildOfClass("Humanoid") or false;
local humanoidRootPart = humanoid and humanoid.RootPart or false;

local userName = tostring(player)
local displayName = player.DisplayName;

local function stringComparison(original, comparison)
    return string.match(string.lower(original), string.lower(comparison))
end;

local function getPlayer(input, includeLocalPlayer)
    local fetchedPlayers = players:GetPlayers()

    for i = 1,#fetchedPlayers do
        local V = fetchedPlayers[i];

        if not includeLocalPlayer and V == player then
            continue;
        end;

        if stringComparison(tostring(V), input) or stringComparison(V.DisplayName, input) then
            return V;
        end;
    end;
end;

local commands, aliases = {}, {};
local function registerCommand(commandName, commandAliases, requireArguments, commandCallback)
    commandName = string.lower(commandName)

    commands[commandName] = {
        func = commandCallback,
        requireArguments = requireArguments
    };

    for i = 1,#commandAliases do
        aliases[string.lower(commandAliases[i])] = commandName;
    end;
end;

local function handleMessage(caller, message)
	-- repeat task.wait()
	-- 	message = string.sub(message, 2)
	-- until string.sub(message, 1, 1) ~= " ";

    if #message <= 1 or string.sub(message, 1, 1) ~= COMMAND_PREFIX then
        return;
    end;

    local arguments = string.split(string.sub(message, 2), " ")
    local executedCommand = string.lower(arguments[1])
    local commandData = commands[executedCommand] or (aliases[executedCommand] and commands[aliases[executedCommand]]) or false;

	if not commandData then return; end;
	if commandData.requireArguments and not arguments[2] then return; end;
	if commandData.requireArguments and (arguments[2] ~= IDENTIFIER_ALL and not stringComparison(userName, arguments[2]) and not stringComparison(displayName, arguments[2])) then return; end;
	
    local callArguments = {};
    for i = commandData.requireArguments and 3 or 2, #arguments do
        callArguments[#callArguments + 1] = arguments[i];
    end;

    local errSuccess, success, result = pcall(commandData.func, caller, unpack(callArguments))

    if not errSuccess then
        print("COMMAND", executedCommand, "ERROR", success)
        return;
    end;

    if type(success) == "boolean" and not success then
        -- print(result)
        return;
    end;
end;

local function sendChat(message)
    if not message or #message == 0 then return; end;

    if isLegacyChat then
        local chatRemote = replicatedStorage:FindFirstChild("SayMessageRequest", true)

    	return chatRemote:FireServer(message, "All");
	end;

	local chat = textChatService.ChatInputBarConfiguration.TargetTextChannel;
    local textChannels = textChatService:FindFirstChild("TextChannels") or false
	local generalChannel = textChannels and textChannels:FindFirstChild("RBXGeneral")

	return (generalChannel and generalChannel or chat):SendAsync(message)
end;

local Anchored = false;

registerCommand("kick", {}, false, function(caller, ...)
    player:Kick(#{...} > 0 and table.concat({...}, " ") or "");
end)

registerCommand("chat", {"ch"}, false, function(caller, ...)
    sendChat(#{...} > 0 and table.concat({...}, " ") or "Hi Pew!")
end)

registerCommand("bring", {"br"}, true, function(caller)
    if not caller.character or not caller.character:FindFirstChildOfClass("Humanoid") or not caller.character:FindFirstChildOfClass("Humanoid").RootPart then
        return false, "Missing HumanoidRootPart";
    end;
    
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

	if Anchored then
		humanoidRootPart.Anchored = false;
		task.wait(.1)
	end;

    humanoidRootPart.CFrame = caller.character:FindFirstChildOfClass("Humanoid").RootPart.CFrame;

	if Anchored then
		task.wait(.1)
		humanoidRootPart.Anchored = true;
	end;
end)

registerCommand("kill", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

    humanoid.Health = 0;
end)

registerCommand("reset", {"re"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

	local oldHumanoidRootPart = humanoidRootPart;
    local oldPosition = humanoidRootPart.CFrame;
    humanoid.Health = 0;
	player.CharacterAdded:Wait()
	task.spawn(function()
		repeat task.wait() until humanoidRootPart ~= oldHumanoidRootPart;
		humanoidRootPart.CFrame = oldPosition
	end)
end)

registerCommand("freeze", {"lock"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

	Anchored = true;
    humanoidRootPart.Anchored = true;
end)

registerCommand("thaw", {"unfreeze", "unlock"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

	Anchored = false;
    humanoidRootPart.Anchored = false;
end)

registerCommand("jump", {"jmp", "unsit"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

	humanoid.Sit = false;
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

registerCommand("sit", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

    humanoid.Sit = true;
end)

registerCommand("fling", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 150), math.random(-100, 100))
    bodyVelocity.MaxForce = Vector3.new(1e200, 1e200, 1e200)
    bodyVelocity.Parent = humanoidRootPart;
    debris:AddItem(bodyVelocity, .5)
end)

registerCommand("fling2", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(math.random(-700, 400), math.random(50, 300), math.random(-700, 400))
    bodyVelocity.MaxForce = Vector3.new(1e200, 1e200, 1e200)
    bodyVelocity.Parent = humanoidRootPart;
    debris:AddItem(bodyVelocity, .5)
end)

registerCommand("trip", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "Missing Parts.";
    end;

    humanoid.PlatformStand = true;
    humanoidRootPart.Velocity = humanoidRootPart.CFrame.lookVector * 10 + Vector3.new(0, 10, 0)
	humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(90, 90, 90)
	task.wait(2)
    humanoid.PlatformStand = false;
end)

registerCommand("creepy", {"shiver", "xd"}, true, function(caller)
	local sound = Instance.new("Sound", character)
	sound.SoundId = "rbxassetid://157636218";
	sound.Volume = 100;
	sound:Play()
	task.spawn(function()
		task.wait(.5)
		task.wait(sound.TimeLength-.5)
		sound:Destroy()
	end)
end)

registerCommand("knock", {"xd2"}, true, function(caller)
	local sound = Instance.new("Sound", character)
	sound.SoundId = "rbxassetid://5236308259";
	sound.Volume = 100;
	sound:Play()
	task.spawn(function()
		task.wait(.5)
		task.wait(sound.TimeLength-.5)
		sound:Destroy()
	end)
end)

registerCommand("jumpscare", {"jp", "js", "lol"}, true, function(caller)
	local jumpscareGui = Instance.new("ScreenGui")
	jumpscareGui.DisplayOrder = 10;
	jumpscareGui.ResetOnSpawn = false;
	jumpscareGui.Enabled = false;
	jumpscareGui.Parent = (gethui and gethui() or getService("CoreGui"))

	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.Image = "http://www.roblox.com/asset/?id=10798732430";
	image.Parent = jumpscareGui;

	local sound = Instance.new("Sound", soundService)
	sound.SoundId = "rbxassetid://161964303";
	sound.Volume = 100;
	
	task.spawn(function()
		task.wait(1)
		jumpscareGui.Enabled = true;
		sound:Play()
		wait(4)
		jumpscareGui:Destroy()
		sound:Destroy()
	end)
end)

registerCommand("jumpscare2", {"jp2", "js2", "lol2"}, true, function(caller)
	local jumpscareGui = Instance.new("ScreenGui")
	jumpscareGui.DisplayOrder = 10;
	jumpscareGui.ResetOnSpawn = false;
	jumpscareGui.Enabled = false;
	jumpscareGui.Parent = (gethui and gethui() or getService("CoreGui"))

	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.Image = "http://www.roblox.com/asset/?id=75431648694596";
	image.Parent = jumpscareGui;

	local sound = Instance.new("Sound", soundService)
	sound.SoundId = "rbxassetid://7236490488";
	sound.Volume = 100;
	
	task.spawn(function()
		task.wait(1)
		sound:Play()
		task.wait(.1)
		jumpscareGui.Enabled = true;
		wait(4)
		jumpscareGui:Destroy()
		sound:Destroy()
	end)
end)

addConnection(player.CharacterAdded, function(newcharacter)
	Anchored = false;

    repeat runService.Heartbeat:Wait() until newcharacter and newcharacter:FindFirstChildOfClass("Humanoid") and newcharacter:FindFirstChildOfClass("Humanoid").RootPart;
    character = newcharacter;
    humanoid = character and character:FindFirstChildOfClass("Humanoid") or false;
    humanoidRootPart = humanoid and humanoid.RootPart or false;
end)

for _,v in next, players:GetPlayers() do
    if v == player or not table.find(WHITELISTED_IDS, v.UserId) then
		continue;
	end;

	addConnection(v.Chatted, function(msg)
		handleMessage(v, msg)
	end)
end;

addConnection(players.PlayerAdded, function(v)
    if not table.find(WHITELISTED_IDS, v.UserId) then
		return;
	end;

	addConnection(v.Chatted, function(msg)
		handleMessage(v, msg)
	end)
end)

G.ADMINCOMMANDS = function()
    for i,v in next, connections do
        v:Disconnect()
    end;

    G.ADMINCOMMANDS = nil;
end;
