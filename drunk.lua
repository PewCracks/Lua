--[[
    Drunk Imitation
    Made by Absent /akadmin & Pew ib2.dev
    PS: execute multiple times to get high
]]

local CONFIG = {
	-- // phases
    riseTime = 4,
	peakTime = 10,
	fadeTime = 6,

    -- // swizzle
	swizzleSpeed = 1.5,
	swizzleStrength = 3.5,
    bodyLeanAmount = 35,

    -- // stumbling
    stumbleChance = .03,
	stumbleForce = 4,
	maxStumbleTilt = 15,
    fallChance = .005,
	fallDuration = .3,
	
    -- // rest
	blur = 15,
	eyeLidStrength = 2,
	tilt = 25
};

local cloneref = cloneref or function(...) return ...; end;
local function getService(service)
    return cloneref(game:GetService(service))
end;

local players = getService("Players")
local runService = getService("RunService")
local lighting = getService("Lighting")
local soundService = getService("SoundService")

local player = players.LocalPlayer;
local camera = workspace.CurrentCamera;
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local connections = {};
local startTime = tick()
local seed = math.random(10000)
local currentLean = 0;
local stumbleOffset = Vector3.new(0, 0, 0);
local stumbleTilt = 0;
local falling = false;
local fallStart = 0;

connections[#connections + 1] = player.CharacterAdded:Connect(function(newcharacter)
    repeat runService.Heartbeat:Wait() until newcharacter and newcharacter:FindFirstChildOfClass("Humanoid") and newcharacter:FindFirstChildOfClass("Humanoid").RootPart;
    character = newcharacter;
    humanoid = character and character:FindFirstChildOfClass("Humanoid") or false;
    humanoidRootPart = humanoid and humanoid.RootPart or false;
end)

local function newInstance(className, properties)
    local inst = Instance.new(className)

    if properties then
        for k,v in properties do
            inst[k] = v;
        end;
    end;

    return inst;
end;

local gui = newInstance("ScreenGui", {
    Name = "eyelids",
    IgnoreGuiInset = true,
    DisplayOrder = 10000,
    ResetOnSpawn = false,
    Parent = player:WaitForChild("PlayerGui")
})

local effects = {
    blur = newInstance("BlurEffect", {
        Name = "blur",
        Size = 0,
        Parent = lighting
    }),
    colorCorrection = newInstance("ColorCorrectionEffect", {
        Name = "correction",
        Contrast = 0,
        Saturation = 0,
        Parent = lighting
    }),
    bodyGyro = newInstance("BodyGyro", {
        Name = "gyro",
        MaxTorque = Vector3.new(4000, 0, 4000),
        P = 3000,
        D = 500,
        CFrame = humanoidRootPart.CFrame,
        Parent = humanoidRootPart
    }),
    gui = gui,
    topLid = newInstance("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 0),
        Parent = gui
    }),
    bottomLid = newInstance("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 0),
        Parent = gui
    })
};

local function getNoise(speed, offset)
	return math.noise(tick() * speed, offset, seed)
end;

connections[#connections + 1] = runService.RenderStepped:Connect(function(dt)
	local elapsed = tick() - startTime;
	local totalTime = CONFIG.riseTime + CONFIG.peakTime + CONFIG.fadeTime;
	
    if elapsed >= totalTime then
		for _,v in effects do
            if v then
                v:Destroy()
            end;
        end;

        for i = 1,#connections do
            connections[i]:Disconnect()
        end;

		return;
	end;

	local progress;
	if elapsed < CONFIG.riseTime then
		progress = elapsed / CONFIG.riseTime;
	elseif elapsed < CONFIG.riseTime + CONFIG.peakTime then
		progress = 1;
	else
		progress = math.clamp(1 - ((elapsed - CONFIG.riseTime - CONFIG.peakTime) / CONFIG.fadeTime), 0, 1)
	end;

	local t = tick()

	if not falling and math.random() < CONFIG.fallChance * progress then
		falling = true;
		fallStart = t;
		humanoid.PlatformStand = true;
	end;

	if falling then
		if t - fallStart >= CONFIG.fallDuration then
			falling = false;
			humanoid.PlatformStand = false;
		end;
	end;

	if humanoid.MoveDirection.Magnitude >  .1 and not falling then
		local wave = math.sin(t * CONFIG.swizzleSpeed)
		local noise = getNoise(1.5, 55)
		local swayAmount = (wave + noise) * .5;

		local right = camera.CFrame.RightVector;
		local swayVector = right * swayAmount * CONFIG.swizzleStrength * progress;

		if math.random() < .03 * progress then
			stumbleOffset = Vector3.new(getNoise(5, 100) * CONFIG.stumbleForce, 0, getNoise(5,200)*CONFIG.stumbleForce)
			stumbleTilt = (getNoise(3, 300) - .5) * 2 * CONFIG.maxStumbleTilt * progress;
		end;

		stumbleOffset = stumbleOffset:Lerp(Vector3.zero, .08)
		stumbleTilt = stumbleTilt * .92;
		local finalMove = humanoid.MoveDirection + swayVector + stumbleOffset;
		humanoid:Move(finalMove, false)
	end;

	local leanTarget = math.sin(t * CONFIG.swizzleSpeed) * CONFIG.bodyLeanAmount * progress + stumbleTilt;
	currentLean += (leanTarget - currentLean) * .1;
	effects.bodyGyro.CFrame = CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, humanoidRootPart.Orientation.Y * math.pi/180, 0) * CFrame.Angles(0, 0, math.rad(currentLean))

	camera.CFrame *= CFrame.Angles(getNoise(.8, 1) * .07 * progress, getNoise(.8 ,2) * .1 * progress, math.rad(math.sin(t * 1.2) * CONFIG.tilt * progress))

	local fatigue = (math.sin(t * .5) + 1) * .5;
	local twitch = getNoise(4, 100)
	local lidState = math.clamp((fatigue * .2) + (twitch * .2), 0, 1) * CONFIG.eyeLidStrength * progress;

	effects.topLid.Size = UDim2.fromScale(1, lidState * .4)
	effects.bottomLid.Size = UDim2.fromScale(1, lidState * .2)
	effects.blur.Size = CONFIG.blur * progress + lidState * 5;
	effects.colorCorrection.Contrast = .25 * progress + lidState * .1;
	effects.colorCorrection.Saturation = -.6 * progress - lidState * .2;
end)
