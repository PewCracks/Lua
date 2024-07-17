-- // For learning purposes. GitHub: PewCracks
print("[Bypasser]: Fetching Information.")

local function Decode(str)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/='
	return ((str:gsub('.', function(x)
		if x == '=' then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end)..'===='):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return '' end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end;

-- // get rid of webhook logger.
local old, old2;
old = hookfunction(syn.request, function(...)
	if (...)["Url"]:lower():find("www.gamenamelogger.x10.mx") then
		print("[Bypasser]: Bypassed Webhook request.")
		return nil;
	end;
	return old(...)
end)

-- // get rid of his setclipboard("")
old2 = hookfunction(setclipboard, function(...)
	if (...) == "" then
		return true;
	end;
	return old2(...)
end)

print("[Bypasser]: Bypassed Anti-Measures.")

local Get, Index = game["HttpGet"];
local Http = newcclosure(function(self, Url)
    if tostring(Url):lower():match("checkpoint.html") then 
		if tostring(Url):lower():find("&count=2") then
			local Base64 = tostring(Url):match("Key%=.*"):gsub("Key%=", ""):gsub("&C.*", "")
			local Decoded = Decode(Base64):match("%r%=.*"):sub(2)
			local Key = tostring(Decode(Decoded):match("%?.*"):sub(2)):gsub("=", "")
			--// Copy the key.
			setclipboard(Key)
			print("[Bypasser]: Bypassed, copied key to clipboard.")
		end;
    else
        return Get(self, Url)
    end;
end)

Index = hookmetamethod(game, "__index", function(self, Key)
    if checkcaller() then
        if self == game and Key == "HttpGet" then
            return Http;
        end;
    end;
    return Index(self, Key)
end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/thedragonslayer2/Key-System/main/Load.lua"))()
