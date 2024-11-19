-- [[ Variables ]] --

if _VERSION ~= "Luau" then
    math.randomseed(os.time())
end;

local Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
local Char = function(v) return string.char(tostring(v)) end;
local Sub = string.sub;
local GSub = string.gsub;
local Byte = string.byte;
local Find = string.find;
local Format = string.format;

local Concat = table.concat;
local UnPack = table.unpack or unpack;

local Abs = math.abs;
local Floor = math.floor;
local Random = math.random;

local Dictionary = {};
for i = 0,255 do
    local V = Char(i)
    Dictionary[i] = V;
    Dictionary[V] = i;
end;

-- [[ Bit Library ]] --
local N, P; do N = 32; P = 2 ^ N; end;
local bit32 = (bit32 or bit) or nil;
if not bit32 then
    bit32 = {
        bxor = function(x,y)x,y=x%P,y%P;local r=0;local p=1;for i=1,N do local a,b=x%2,y%2;x,y=Floor(x/2),Floor(y/2)if a+b==1 then r=r+p end;p=2*p end;return r end,
        band = function(x,y)if y==255 then return x%256 end;if y==65535 then return x%65536 end;if y==4294967295 then return x%4294967296 end;x,y=x%P,y%P;local r=0;local p=1;for i=1,N do local a,b=x%2,y%2;x,y=Floor(x/2),Floor(y/2)if a+b==2 then r=r+p end;p=2*p end;return r end,
        rshift = function(x,s_amount)if Abs(s_amount)>=N then return 0 end;x=x%P;if s_amount>0 then return Floor(x*2^(-s_amount))else return x*2^(-s_amount)%P end end,
        lshift = function(x,s_amount)if Abs(s_amount)>=N then return 0 end;x=x%P;if s_amount<0 then return Floor(x*2^s_amount)else return x*2^s_amount%P end end
    };
end;

-- [[ Base64 ]] --
local Base64 = {
    Encode = function(data)return(GSub((GSub(data,".",function(char)local binary,ascii="",Byte(char)for i=8,1,-1 do binary=binary..(ascii%2^i-ascii%2^(i-1)>0 and"1"or"0")end;return binary end).."0000"),"%d%d%d?%d?%d?%d?",function(bits)if(#bits<6)then return""end;local value=0;for i=1,6 do value=value+(Sub(bits,i,i)=="1"and 2^(6-i)or 0)end;return Sub(Characters,value+1,value+1)end)..({"","==","="})[#data%3+1])end,
    Decode = function(data)return(GSub(GSub(GSub(data,Format("[^%s=]",Characters),""),".",function(char)if(char=="=")then return""end;local binary,index="",(Find(Characters,char)-1)for i=6,1,-1 do binary=binary..(index%2^i-index%2^(i-1)>0 and"1"or"0")end;return binary end),"%d%d%d?%d?%d?%d?%d?%d?",function(bits)if(#bits~=8)then return""end;local ascii=0;for i=1,8 do ascii=ascii+(Sub(bits,i,i)=="1"and 2^(8-i)or 0)end;return Char(ascii)end))end
};

-- [[ Misc Functions ]] --
local XORShift, GetPosition = function(Seed, Int1, Int2, Int3)
    Seed = bit32.bxor(Seed, bit32.lshift(Seed, Int1))
    Seed = bit32.bxor(Seed, bit32.rshift(Seed, Int2))
    Seed = bit32.bxor(Seed, bit32.lshift(Seed, Int3))

    return Seed;
end, function(Text, Pos1, Pos2, KeepAsString)
    local String = Sub(Text, Pos1, Pos2 or nil)

    if KeepAsString then
        return String;
    end;
    
    return Byte(String)
end;

-- [[ Generation Functions ]] --
local GenerateKey, GenerateIV = function(Key, Seed, RV, ...)
    for i = 1, #Key do
        Seed = XORShift(Seed + Byte(Key, i), UnPack({...})) * RV;
    end;

    return Seed;
end, function()
    local IV = "";

    for i = 1, 8 do
        IV = IV .. Dictionary[Random(0, 255)]
    end;

    return IV;
end;

local Encrypt, Decrypt = function(InitialInput, InitialKey)
    local RandomValue = {
        Random(1,255),
        Random(1,255),
        Random(1,255)
    };

    local CustomIV = GenerateIV()
    local RandomSeed = Random(1e4, 99e6)
    local Key = GenerateKey(InitialKey .. CustomIV, RandomSeed, (((RandomValue[2] * RandomValue[1] * RandomValue[3]) / RandomValue[1]) * RandomValue[3]), UnPack(RandomValue))
    local CustomSeed = Format("%02X", RandomSeed)
    local output = {
        CustomIV,                     -- IV randomaization
        Dictionary[#CustomSeed],      -- Seed Length
        Dictionary[RandomValue[1]],   -- R1
        Dictionary[RandomValue[2]],   -- R2
        Dictionary[RandomValue[3]],   -- R3
        CustomSeed                    -- randomized seed
    };

    local Output = Concat(output)
    for i = 1, #InitialInput do
        Key = XORShift(Key, UnPack(RandomValue))
        Output = Output .. Dictionary[bit32.bxor(Byte(InitialInput, i), bit32.band(Key, 0xFF))];
    end;

    return Base64.Encode(Output), Base64.Encode(CustomIV);
end, function(InitialInput, InitialKey, InitialIV)
    CipherText = Base64.Decode(tostring(InitialInput))

    local FoundIV = InitialIV and Base64.Decode(InitialIV) or GetPosition(CipherText, 1, 8, true)
    local FoundSeedLength = GetPosition(CipherText, 9, 9)
    
    local FoundSeed = tonumber(GetPosition(CipherText, 13, FoundSeedLength + 12, true), 16)

    local RandomizedValues = {
        GetPosition(CipherText, 10, 10), -- R1
        GetPosition(CipherText, 11, 11), -- R2
        GetPosition(CipherText, 12, 12)  -- R3
    };

    local CipherText = GetPosition(CipherText, FoundSeedLength + 13, nil, true)
    local Key = GenerateKey(InitialKey .. FoundIV, FoundSeed, (((RandomizedValues[2] * RandomizedValues[1] * RandomizedValues[3]) / RandomizedValues[1]) * RandomizedValues[3]), UnPack(RandomizedValues))
    
    local Output = "";
    for i = 1, #CipherText do
        Key = XORShift(Key, UnPack(RandomizedValues))
        Output = Output .. Dictionary[bit32.bxor(Byte(CipherText, i), bit32.band(Key, 0xFF))];
    end;

    return Output;
end;

local Amount = 10;
for i = 1, Amount do
    local OriginalText = "Thug shake";
    local Key = "Make this whatever you want";
    local EncryptedText, IV = Encrypt(OriginalText, Key)
    local DecryptedText = Decrypt(EncryptedText, Key)

    print("[ENCRYPTION ATTEMPT]:", Format("%s/%s", i, Amount))
    print("[ORIGINAL TEXT]:",      OriginalText)
    -- print("[ENCRYPTION IV]:",      IV)
    print("[DECRYPTION KEY]:",     Key)
    print("[ENCRYPTED TEXT]:",     EncryptedText)
    print("[DECRYPTED TEXT]:",     DecryptedText)
    print("[ISSIMILAR TEXT]:",     rawequal(OriginalText, DecryptedText))
    print("\n")
end;
