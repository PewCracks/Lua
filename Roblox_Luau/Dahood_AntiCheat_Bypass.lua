-- credits vanis for providing new anticheat data

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local tablefind = table.find;
local MainEvent = ReplicatedStorage.MainEvent;
local Flags = {
	"checkingSPEED",
	"BANREMOTE",
	"PERMAIDBAN",
	"KICKREMOTE",
	"BR_KICKPC",
	"BR_KICKMOBILE",
	"OneMoreTime",
	"TeleportDetect",
	"CHECKER_1",
	"CHECKER",
	"GUI_CHECK"
};

local Player = game:GetService("Players").LocalPlayer;
getsenv(Player.Character.Animate).checkingSPEED = function()
	return;
end;

for i, v in pairs(getconnections(Player.Character.HumanoidRootPart:GetPropertyChangedSignal("CFrame"))) do
	v:Disable();
end;

Player.CharacterAdded:Connect(function()
	getsenv(Player.Character.Animate).checkingSPEED = function()
		return;
	end;
end);


local __namecall;
__namecall = hookmetamethod(game, "__namecall", function(...)
	local args = {
		...
	};
	local self = args[1];
	local method = getnamecallmethod();
	if method == "FireServer" and self == MainEvent and tablefind(Flags, args[2]) then
		return;
	end;
	if not checkcaller() and (getfenv(2)).crash then
		local fenv = getfenv(2);
		fenv.crash = function()
		end;
		setfenv(2, fenv);
	end;
	return __namecall(...);
end);

local __newindex;
__newindex = hookmetamethod(game, "__newindex", function(t, k, v)
	if not checkcaller() and t:IsA("Humanoid") and (k == "WalkSpeed" or k == "JumpPower") then
		return;
	end;
	return __newindex(t, k, v);
end);
