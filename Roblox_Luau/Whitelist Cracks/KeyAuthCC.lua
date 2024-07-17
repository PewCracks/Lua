-- // For learning purposes. GitHub: PewCracks

local HttpS, RData; do 
    HttpS = game:GetService("HttpService"); License = ("a"):rep(16); RData = HttpS:JSONEncode({success = true, message = "Crack initiated.", info = {username = "Cracked", subscriptions = {subscription = "Pro", key = "Cracked", expiry = "Cracked", timeleft = "Cracked"}, ip = "Cracked", hwid = "Cracked", createdate = "Cracked", lastlogin = "Cracked"}})
end;

local Get, index = game["HttpGet"];
local Http = newcclosure(function(self, Url)
    if tostring(Url):match("%&type%=license") or tostring(Url):match("%&type%=login") then
        return RData;
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

-- Obfuscated File here
