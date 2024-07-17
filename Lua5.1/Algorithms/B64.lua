local Base64, b = {}, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

local GSub, Sub, Find, Byte, Char = string.gsub, string.sub, string.find, string.byte, string.char;

-- Roblox shit
if _VERSION == "Luau" and clonefunction then
    local C = clonefunction;

    GSub, Sub, Find, Byte, Char = C(GSub), C(Sub), C(Find), C(Byte), C(Char);
end;

function Base64.encode(data)
	return GSub(GSub(data, ".", function(x)
		local r, b = "", Byte(x);
		for i = 8, 1, -1 do
			r = r .. (b % 2 ^ i - b % 2 ^ (i - 1) > 0 and "1" or "0");
		end;
		return r;
	end) .. "0000", "%d%d%d?%d?%d?%d?", function(x)
		if #x < 6 then
			return "";
		end;
		local c = 0;
		for i = 1, 6 do
			c = c + (Sub(x, i, i) == "1" and 2 ^ (6 - i) or 0);
		end;
		return Sub(b, c + 1, c + 1);
	end) .. ({"", "==", "="})[(#data) % 3 + 1];
end;

function Base64.decode(data)
	return GSub(GSub(GSub(data, "[^" .. b .. "=]", ""), ".", function(x)
		if x == "=" then return ""; end;
		
        local r, f = "", Find(b, x) - 1;
        for i = 6, 1, -1 do
			r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and "1" or "0");
		end;

		return r;
	end), "%d%d%d?%d?%d?%d?%d?%d?", function(x)
		if #x ~= 8 then return ""; end;

		local c = 0;
		for i = 1, 8 do
			c = c + (Sub(x, i, i) == "1" and 2 ^ (8 - i) or 0);
		end;

		return Char(c);
	end);
end;

return Base64;