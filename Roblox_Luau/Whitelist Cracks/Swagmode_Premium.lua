-- // For learning purposes. GitHub: PewCracks

local Urls = {
	"https://raw.githubusercontent.com/swagmode/swagmode/main/swagmain",
	"https://raw.githubusercontent.com/swagmode/swagmode/main/swagcool",
	"https://raw.githubusercontent.com/swagmode/swagmode/main/swagdif"
};

local Get, index = game["HttpGet"];
local Http = newcclosure(function(self, Url)
    if table.find(Urls, Url) then
		print("Spoofed:", Url)
		return [[
			ModIDs = {]] .. ("729946737,"):rep(15000) .. [[}
			function swagnames()
				local Data = Instance.new("Folder", workspace)
				Data["Name"] = "Data_SM"
			end;
			local success,err = pcall(swagnames)
			return ModIDs;
		]]; -- WE GIVE EM THIS!
    elseif Url:match("http://swagmode.xyz/lala.php?") then
    	return;
    else
        return Get(self, Url)
    end;
end)

index = hookmetamethod(game, "__index", function(self, Key)
    if checkcaller() then
        if self == game and Key == "HttpGet" then
            return Http;
        end;
    end;
    return index(self, Key)
end)
