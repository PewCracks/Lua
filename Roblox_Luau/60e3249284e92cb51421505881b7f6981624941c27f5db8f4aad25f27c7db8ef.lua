local v1 = debug.getupvalue(require(game.ReplicatedStorage.Fsys).load("RouterClient").init, 7)
local v2, v3, v4 = pairs(v1)
local vu5 = {}
while true do
    local v6
    v4, v6 = v2(v3, v4)
    if v4 == nil then
        break
    end
    v6.Name = v4
    vu5[v4] = v6
end
local v7 = require(game:GetService("ReplicatedStorage"):WaitForChild("Fsys"))
local vu8 = v7.load("UIManager")
local v9 = v7.load("ClientData").get("inventory").toys
local v10, v11, vu12 = pairs(v9)
local v13 = nil
while true do
    local v14
    vu12, v14 = v10(v11, vu12)
    if vu12 == nil then
        vu12 = v13
        break
    end
    if v14.id == "trade_license" then
        break
    end
end
local v19 = {
    ["ToolAPI/Equip"] = function(p15, p16, ...)
        if p16 == vu12 then
            vu8.set_app_visibility("TradeHistoryApp", true)
        end
        return vu5["ToolAPI/Equip"](p15, p16, ...)
    end,
    ["ToolAPI/Unequip"] = function(p17, p18)
        if p18 == vu12 then
            vu8.set_app_visibility("TradeHistoryApp", false)
        end
        return vu5["ToolAPI/Unequip"](p17, p18)
    end
}
debug.setupvalue(require(game.ReplicatedStorage.Fsys).load("RouterClient").init, 7, setmetatable(v19, {
    __index = vu5,
    __newindex = function(p20, p21, p22)
        if p21 == "ToolAPI/Equip" or p21 == "ToolAPI/Unequip" then
            rawset(p20, p21, p22)
        else
            vu5[p21] = p22
        end
    end
}))
local v23 = game:GetService("Players")
local v24 = game:GetService("ReplicatedStorage")
local v25 = require(v24:WaitForChild("Fsys")).load("UIManager")
local v26 = v25.apps.TradeHistoryApp
local vu27 = v25.apps.TradeApp
local vu28 = v23.LocalPlayer
if v26._ORIGINAL_create_trade_frame then
    v26._create_trade_frame = v26._ORIGINAL_create_trade_frame
end
if vu27._ORIGINAL_change_local_trade_state then
    vu27._change_local_trade_state = vu27._ORIGINAL_change_local_trade_state
end
if vu27._ORIGINAL_overwrite_local_trade_state then
    vu27._overwrite_local_trade_state = vu27._ORIGINAL_overwrite_local_trade_state
end
v26._ORIGINAL_create_trade_frame = v26._create_trade_frame
vu27._ORIGINAL_change_local_trade_state = vu27._change_local_trade_state
vu27._ORIGINAL_overwrite_local_trade_state = vu27._overwrite_local_trade_state
local vu29 = {}
function vu27._change_local_trade_state(p30, p31, ...)
    local v32 = p30:_get_local_trade_state()
    if v32 and v32.trade_id then
        if v32.sender ~= vu28 or not p31.sender_offer then
            if v32.recipient == vu28 and p31.recipient_offer then
                vu29[v32.trade_id] = {
                    items = table.clone(p31.recipient_offer.items),
                    isSender = false
                }
            end
        else
            vu29[v32.trade_id] = {
                items = table.clone(p31.sender_offer.items),
                isSender = true
            }
        end
    end
    return vu27._ORIGINAL_change_local_trade_state(p30, p31, ...)
end
function vu27._overwrite_local_trade_state(p33, p34, ...)
    if not p34 and vu27._last_trade_id then
        vu29[vu27._last_trade_id] = nil
    end
    return vu27._ORIGINAL_overwrite_local_trade_state(p33, p34, ...)
end
function v26._create_trade_frame(p35, p36, ...)
    if not (p36.trade_id and vu29[p36.trade_id]) then
        return p35:_ORIGINAL_create_trade_frame(p36, ...)
    end
    local v37 = vu29[p36.trade_id]
    local v38 = table.clone(p36)
    if v37.isSender then
        v38.sender_items = table.clone(v37.items)
    else
        v38.recipient_items = table.clone(v37.items)
    end
    return p35:_ORIGINAL_create_trade_frame(v38, ...)
end
local v39 = game:GetService("ReplicatedStorage")
local vu40 = game:GetService("Players")
local vu41 = require(v39:WaitForChild("Fsys")).load("UIManager")
local vu42 = nil
local vu43 = vu41.apps.TradeApp._overwrite_local_trade_state
function vu41.apps.TradeApp._overwrite_local_trade_state(p44, p45, ...)
    if p45 then
        local v46 = p45.sender == vu40.LocalPlayer and p45.sender_offer
        if not v46 then
            if p45.recipient ~= vu40.LocalPlayer then
                v46 = false
            else
                v46 = p45.recipient_offer
            end
        end
        if v46 and vu42 then
            v46.items = vu42
        end
    else
        vu42 = nil
    end
    return vu43(p44, p45, ...)
end
local vu47 = vu41.apps.TradeApp._change_local_trade_state
function vu41.apps.TradeApp._change_local_trade_state(p48, p49, ...)
    local v50 = vu41.apps.TradeApp.local_trade_state
    local v51 = v50 and (v50.sender == vu40.LocalPlayer and "sender_offer" or (v50.recipient == vu40.LocalPlayer and "recipient_offer" or false))
    if v51 then
        local v52 = p49[v51]
        if v52 and v52.items then
            vu42 = v52.items
        end
    end
    return vu47(p48, p49, ...)
end
local vu53 = game:GetService("TweenService")
local vu54 = game:GetService("Players").LocalPlayer
local vu55 = game:GetService("RunService")
local vu56 = {
    F = false,
    R = false,
    N = false,
    M = false
}
local _ = {
    Color3.fromRGB(170, 0, 255),
    Color3.fromRGB(0, 255, 100),
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(255, 50, 150)
}
task.spawn(function()
    local v57 = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
    set_thread_identity(2)
    local vu58 = v57("ClientData")
    local vu59 = v57("KindDB")
    local v60 = v57("RouterClient")
    local vu61 = v57("DownloadClient")
    local vu62 = v57("AnimationManager")
    local vu63 = v57("new:PetRigs")
    set_thread_identity(8)
    local vu64 = {}
    local vu65 = {}
    local vu66 = nil
    local vu67 = nil
    local vu68 = nil
    local function vu73(p69, p70)
        local v71 = vu58.get(p69)
        local v72 = table.clone(v71)
        vu58.predict(p69, p70(v72))
    end
    local function vu74()
        return game:GetService("HttpService"):GenerateGUID(false)
    end
    local function vu77(p75)
        if vu64[p75] then
            return vu64[p75]
        end
        local v76 = vu61.promise_download_copy("Pets", p75):expect()
        vu64[p75] = v76
        return v76
    end
    local function vu83(p78, p79)
        local v80 = vu74()
        local v81 = vu59[p78]
        if not v81 then
            warn("Pet ID not found: " .. p78)
            return nil
        end
        set_thread_identity(2)
        local v82 = {
            unique = v80,
            category = "pets",
            id = p78,
            kind = v81.kind,
            newness_order = math.random(1, 900000),
            properties = p79 or {}
        }
        vu58.get("inventory").pets[v80] = v82
        set_thread_identity(8)
        vu65[v80] = {
            data = v82,
            model = nil
        }
        return v82
    end
    local function vu88(p84)
        local v85 = vu74()
        local v86 = vu59[p84]
        if not v86 then
            warn("Toy ID not found: " .. p84)
            return nil
        end
        set_thread_identity(2)
        local v87 = {
            unique = v85,
            category = "toys",
            id = p84,
            kind = v86.kind,
            newness_order = math.random(1, 900000),
            properties = {}
        }
        vu58.get("inventory").toys[v85] = v87
        set_thread_identity(8)
        return v87
    end
    local function vu97(p89, p90)
        local v91 = p89:FindFirstChild("PetModel")
        if v91 then
            local v92, v93, v94 = pairs(p90.neon_parts)
            while true do
                local v95
                v94, v95 = v92(v93, v94)
                if v94 == nil then
                    break
                end
                local v96 = vu63.get(v91).get_geo_part(v91, v94)
                v96.Material = v95.Material
                v96.Color = v95.Color
            end
        end
    end
    local function vu100(pu98)
        vu73("pet_char_wrappers", function(p99)
            pu98.unique = # p99 + 1
            pu98.index = # p99 + 1
            p99[# p99 + 1] = pu98
            return p99
        end)
    end
    local function vu103(pu101)
        vu73("pet_state_managers", function(p102)
            p102[# p102 + 1] = pu101
            return p102
        end)
    end
    local function vu110(p104, p105)
        local v106, v107, v108 = pairs(p104)
        while true do
            local v109
            v108, v109 = v106(v107, v108)
            if v108 == nil then
                break
            end
            if p105(v109, v108) then
                return v108
            end
        end
        return nil
    end
    local function vu119(pu111)
        vu73("pet_char_wrappers", function(p112)
            local v114 = vu110(p112, function(p113)
                return p113.pet_unique == pu111
            end)
            if not v114 then
                return p112
            end
            table.remove(p112, v114)
            local v115, v116, v117 = pairs(p112)
            while true do
                local v118
                v117, v118 = v115(v116, v117)
                if v117 == nil then
                    break
                end
                v118.unique = v117
                v118.index = v117
            end
            return p112
        end)
    end
    local function vu126(p120)
        local vu121 = vu65[p120]
        if vu121 then
            if vu121.model then
                vu73("pet_state_managers", function(p122)
                    local v124 = vu110(p122, function(p123)
                        return p123.char == vu121.model
                    end)
                    if not v124 then
                        return p122
                    end
                    local v125 = table.clone(p122)
                    v125[v124] = table.clone(v125[v124])
                    v125[v124].states = {}
                    return v125
                end)
            end
        else
            return
        end
    end
    local function vu135(p127, pu128)
        local vu129 = vu65[p127]
        if vu129 then
            if vu129.model then
                vu73("pet_state_managers", function(p130)
                    local v132 = vu110(p130, function(p131)
                        return p131.char == vu129.model
                    end)
                    if not v132 then
                        return p130
                    end
                    local v133 = table.clone(p130)
                    v133[v132] = table.clone(v133[v132])
                    local v134 = {
                        {
                            id = pu128
                        }
                    }
                    v133[v132].states = v134
                    return v133
                end)
            end
        else
            return
        end
    end
    local function vu141(p136)
        local v137 = game.Players.LocalPlayer.Character
        if not v137 then
            return false
        end
        if not v137.PrimaryPart then
            return false
        end
        local v138 = p136:FindFirstChild("RidePosition", true)
        if not v138 then
            return false
        end
        local v139 = Instance.new("Attachment")
        v139.Parent = v138
        v139.Position = Vector3.new(0, 1.237, 0)
        v139.Name = "SourceAttachment"
        local v140 = Instance.new("RigidConstraint")
        v140.Name = "StateConnection"
        v140.Attachment0 = v139
        v140.Attachment1 = v137.PrimaryPart.RootAttachment
        v140.Parent = v137
        return true
    end
    local function vu144()
        vu73("state_manager", function(p142)
            local v143 = table.clone(p142)
            v143.states = {}
            v143.is_sitting = false
            return v143
        end)
    end
    local function vu148(pu145)
        vu73("state_manager", function(p146)
            local v147 = table.clone(p146)
            v147.states = {
                {
                    id = pu145
                }
            }
            v147.is_sitting = true
            return v147
        end)
    end
    local function vu154(p149)
        local vu150 = vu65[p149]
        if vu150 then
            if vu150.model then
                vu73("pet_state_managers", function(p151)
                    local v153 = vu110(p151, function(p152)
                        return p152.char == vu150.model
                    end)
                    if not v153 then
                        return p151
                    end
                    table.remove(p151, v153)
                    return p151
                end)
            end
        else
            return
        end
    end
    local function vu162(p155)
        local v156 = vu65[p155]
        if v156 then
            if v156.model then
                if vu68 then
                    vu68:Stop()
                    vu68:Destroy()
                end
                local v157 = v156.model:FindFirstChild("SourceAttachment", true)
                if v157 then
                    v157:Destroy()
                end
                if game.Players.LocalPlayer.Character then
                    local v158, v159, v160 = pairs(game.Players.LocalPlayer.Character:GetDescendants())
                    while true do
                        local v161
                        v160, v161 = v158(v159, v160)
                        if v160 == nil then
                            break
                        end
                        if v161:IsA("BasePart") and v161:GetAttribute("HaveMass") then
                            v161.Massless = false
                        end
                    end
                end
                vu126(p155)
                vu144()
                v156.model:ScaleTo(1)
                vu67 = nil
            end
        else
            return
        end
    end
    local function vu172(p163, p164, p165)
        local v166 = vu65[p163]
        if v166 then
            if v166.model then
                local v167 = game.Players.LocalPlayer
                if v167.Character then
                    if v167.Character.PrimaryPart then
                        vu67 = p163
                        vu135(p163, p165)
                        vu148(p164)
                        v166.model:ScaleTo(2)
                        vu141(v166.model)
                        vu68 = v167.Character.Humanoid.Animator:LoadAnimation(vu62.get_track("PlayerRidingPet"))
                        v167.Character.Humanoid.Sit = true
                        local v168, v169, v170 = pairs(v167.Character:GetDescendants())
                        while true do
                            local v171
                            v170, v171 = v168(v169, v170)
                            if v170 == nil then
                                break
                            end
                            if v171:IsA("BasePart") and v171.Massless == false then
                                v171.Massless = true
                                v171:SetAttribute("HaveMass", true)
                            end
                        end
                        vu68:Play()
                    end
                else
                    return
                end
            else
                return
            end
        else
            return
        end
    end
    local function vu174(p173)
        vu172(p173, "PlayerFlyingPet", "PetBeingFlown")
    end
    local function vu176(p175)
        vu172(p175, "PlayerRidingPet", "PetBeingRidden")
    end
    local function vu179(p177)
        local v178 = vu65[p177.unique]
        if v178 then
            if v178.model then
                vu162(p177.unique)
                vu119(p177.unique)
                vu154(p177.unique)
                v178.model:Destroy()
                v178.model = nil
                vu66 = nil
            end
        else
            return
        end
    end
    local function vu182(p180)
        if p180.category ~= "pets" then
            local _ = oldGet("ToolAPI/Equip").InvokeServer
            local _ = p180.unique
        else
            if vu66 then
                vu179(vu66)
            end
            local v181 = vu77(p180.kind):Clone()
            v181.Parent = workspace
            vu65[p180.unique].model = v181
            if p180.properties.neon or p180.properties.mega_neon then
                vu97(v181, vu59[p180.kind])
            end
            vu66 = p180
            vu100({
                char = v181,
                mega_neon = p180.properties.mega_neon,
                neon = p180.properties.neon,
                player = game.Players.LocalPlayer,
                entity_controller = game.Players.LocalPlayer,
                controller = game.Players.LocalPlayer,
                rp_name = p180.properties.rp_name or "",
                pet_trick_level = p180.properties.pet_trick_level,
                pet_unique = p180.unique,
                pet_id = p180.id,
                location = {
                    full_destination_id = "housing",
                    destination_id = "housing",
                    house_owner = game.Players.LocalPlayer
                },
                pet_progression = {
                    age = math.random(1, 900000),
                    percentage = math.random(0.01, 0.99)
                },
                are_colors_sealed = false,
                is_pet = true
            })
            vu103({
                char = v181,
                player = game.Players.LocalPlayer,
                store_key = "pet_state_managers",
                is_sitting = false,
                chars_connected_to_me = {},
                states = {}
            })
        end
    end
    local vu183 = v60.get
    local function v185(pu184)
        return {
            InvokeServer = function(_, ...)
                return pu184(...)
            end
        }
    end
    local vu189 = v185(function(p186, p187)
        local v188 = vu65[p186]
        if not v188 then
            return vu183("ToolAPI/Equip"):InvokeServer(p186, p187)
        end
        vu182(v188.data)
        return true, {
            action = "equip",
            is_server = true
        }
    end)
    local vu192 = v185(function(p190)
        local v191 = vu65[p190]
        if not v191 then
            return vu183("ToolAPI/Unequip"):InvokeServer(p190)
        end
        vu179(v191.data)
        return true, {
            action = "unequip",
            is_server = true
        }
    end)
    local vu194 = v185(function(p193)
        vu176(p193.pet_unique)
    end)
    local vu196 = v185(function(p195)
        vu174(p195.pet_unique)
    end)
    local vu197 = v185(function()
        vu162(vu67)
    end)
    local vu199 = (function(pu198)
        return {
            FireServer = function(_, ...)
                return pu198(...)
            end
        }
    end)(function()
        vu162(vu67)
    end)
    function v60.get(p200)
        if p200 == "ToolAPI/Equip" then
            return vu189
        elseif p200 == "ToolAPI/Unequip" then
            return vu192
        elseif p200 == "AdoptAPI/RidePet" then
            return vu194
        elseif p200 == "AdoptAPI/FlyPet" then
            return vu196
        elseif p200 == "AdoptAPI/ExitSeatStatesYield" then
            return vu197
        elseif p200 == "AdoptAPI/ExitSeatStates" then
            return vu199
        else
            return vu183(p200)
        end
    end
    local v201, v202, v203 = pairs(vu58.get("pet_char_wrappers"))
    local v204 = vu183
    while true do
        local v205
        v203, v205 = v201(v202, v203)
        if v203 == nil then
            break
        end
        v204("ToolAPI/Unequip"):InvokeServer(v205.pet_unique)
    end
    local vu206 = require(game.ReplicatedStorage.Fsys).load("InventoryDB")
    function GetPetByName(p207)
        local v208, v209, v210 = pairs(vu206.pets)
        while true do
            local v211
            v210, v211 = v208(v209, v210)
            if v210 == nil then
                break
            end
            if v211.name:lower() == p207:lower() then
                return v211.id
            end
        end
        return false
    end
    function GetToyByName(p212)
        local v213, v214, v215 = pairs(vu206.toys)
        while true do
            local v216
            v215, v216 = v213(v214, v215)
            if v215 == nil then
                break
            end
            if v216.name:lower() == p212:lower() then
                return v216.id
            end
        end
        return false
    end
    local v217 = Instance.new("ScreenGui")
    v217.Name = "SpeechBubbleApp "
    v217.Parent = vu54:WaitForChild("PlayerGui")
    local vu218 = Instance.new("Frame")
    vu218.Size = UDim2.new(0, 320, 0, 300)
    vu218.Position = UDim2.new(0.5, - 160, 0.4, - 150)
    vu218.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    vu218.BackgroundTransparency = 1
    vu218.BorderSizePixel = 0
    vu218.ZIndex = 1
    vu218.Parent = v217
    local v219 = Instance.new("UICorner")
    v219.CornerRadius = UDim.new(0, 10)
    v219.Parent = vu218
    local vu220 = Instance.new("UIStroke")
    vu220.Color = Color3.fromRGB(170, 0, 255)
    vu220.Thickness = 3
    vu220.Transparency = 0
    vu220.Parent = vu218
    local vu221 = Instance.new("Frame")
    vu221.Size = UDim2.new(0, 330, 0, 310)
    vu221.BackgroundColor3 = Color3.new(0, 0, 0)
    vu221.BackgroundTransparency = 0
    vu221.BorderSizePixel = 0
    vu221.ZIndex = 0
    vu221.Parent = v217
    local v222 = Instance.new("UICorner")
    v222.CornerRadius = UDim.new(0, 15.5)
    v222.Parent = vu221
    local v223 = vu218
    vu218.GetPropertyChangedSignal(v223, "Position"):Connect(function()
        vu221.Position = UDim2.new(vu218.Position.X.Scale, vu218.Position.X.Offset - 5, vu218.Position.Y.Scale, vu218.Position.Y.Offset - 5)
    end)
    vu221.Position = UDim2.new(vu218.Position.X.Scale, vu218.Position.X.Offset - 5, vu218.Position.Y.Scale, vu218.Position.Y.Offset - 5)
    local vu224 = {
        Color3.fromRGB(170, 0, 255),
        Color3.fromRGB(120, 0, 255),
        Color3.fromRGB(0, 100, 255),
        Color3.fromRGB(0, 200, 255),
        Color3.fromRGB(0, 255, 150),
        Color3.fromRGB(0, 255, 100),
        Color3.fromRGB(255, 100, 0),
        Color3.fromRGB(255, 50, 150)
    }
    local vu225 = 4
    local vu226 = 1
    local function vu228()
        local v227 = vu226 % # vu224 + 1
        vu53:Create(vu220, TweenInfo.new(vu225, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Color = vu224[v227]
        }):Play()
        vu226 = v227
        wait(vu225)
        vu228()
    end
    coroutine.wrap(vu228)()
    local v229 = Instance.new("TextLabel")
    v229.Size = UDim2.new(1, 0, 0, 25)
    v229.BackgroundTransparency = 1
    v229.Text = "m0_3a DC"
    v229.Font = Enum.Font.FredokaOne
    v229.TextSize = 20
    v229.TextColor3 = Color3.fromRGB(240, 240, 255)
    v229.Parent = vu218
    local v230 = Instance.new("Frame")
    v230.Size = UDim2.new(1, 0, 0, 30)
    v230.BackgroundTransparency = 1
    v230.Parent = vu218
    local vu231 = Instance.new("TextButton")
    vu231.Size = UDim2.new(0.5, 0, 1, 0)
    vu231.Position = UDim2.new(0, 0, 0, 0)
    vu231.Text = "Pets"
    vu231.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    vu231.BackgroundTransparency = 0.1
    vu231.Font = Enum.Font.FredokaOne
    vu231.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu231.TextSize = 16
    vu231.Parent = v230
    local vu232 = Instance.new("TextButton")
    vu232.Size = UDim2.new(0.5, 0, 1, 0)
    vu232.Position = UDim2.new(0.5, 0, 0, 0)
    vu232.Text = "Toys"
    vu232.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    vu232.BackgroundTransparency = 0.1
    vu232.Font = Enum.Font.FredokaOne
    vu232.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu232.TextSize = 16
    vu232.Parent = v230
    local v233 = Instance.new("UICorner")
    v233.CornerRadius = UDim.new(0, 6)
    v233.Parent = vu231
    v233:Clone().Parent = vu232
    local v234 = Instance.new("UIStroke")
    v234.Color = Color3.fromRGB(255, 255, 255)
    v234.Thickness = 1.5
    v234.Transparency = 0.1
    v234.Parent = vu231
    v234:Clone().Parent = vu232
    local v235 = Instance.new("UIStroke")
    v235.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v235.Color = Color3.new(0, 0, 0)
    v235.Thickness = 1.5
    v235.Transparency = 0
    v235.Parent = vu231
    v235:Clone().Parent = vu232
    local vu236 = Instance.new("Frame")
    vu236.Size = UDim2.new(1, 0, 1, - 55)
    vu236.Position = UDim2.new(0, 0, 0, 55)
    vu236.BackgroundTransparency = 1
    vu236.Visible = true
    vu236.Parent = vu218
    local vu237 = Instance.new("Frame")
    vu237.Size = UDim2.new(1, 0, 1, - 55)
    vu237.Position = UDim2.new(0, 0, 0, 55)
    vu237.BackgroundTransparency = 1
    vu237.Visible = false
    vu237.Parent = vu218
    vu231.MouseButton1Click:Connect(function()
        vu236.Visible = true
        vu237.Visible = false
        vu231.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
        vu232.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    vu232.MouseButton1Click:Connect(function()
        vu236.Visible = false
        vu237.Visible = true
        vu231.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        vu232.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end)
    vu231.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    vu232.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    local vu238 = Instance.new("TextBox")
    vu238.Size = UDim2.new(0.85, 0, 0, 28)
    vu238.Position = UDim2.new(0.075, 0, 0.1, 0)
    vu238.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    vu238.BackgroundTransparency = 0.2
    vu238.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu238.TextSize = 14
    vu238.Font = Enum.Font.FredokaOne
    vu238.PlaceholderText = "Enter Pet Name to Spawn"
    vu238.Text = ""
    vu238.ClearTextOnFocus = false
    vu238.Parent = vu236
    local v239 = Instance.new("UICorner")
    v239.CornerRadius = UDim.new(0, 6)
    v239.Parent = vu238
    local v240 = Instance.new("UIStroke")
    v240.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v240.Color = Color3.new(0, 0, 0)
    v240.Thickness = 1.2
    v240.Transparency = 0
    v240.Parent = vu238
    local vu241 = Instance.new("UIStroke")
    vu241.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vu241.Color = Color3.fromRGB(255, 255, 255)
    vu241.Thickness = 2.2
    vu241.Transparency = 0.25
    vu241.Parent = vu238
    local vu242 = {}
    local vu243 = {};
    (function()
        local v244 = require(game.ReplicatedStorage.Fsys).load("InventoryDB")
        local v245, v246, v247 = pairs(v244)
        while true do
            local v248
            v247, v248 = v245(v246, v247)
            if v247 == nil then
                break
            end
            if v247 == "pets" then
                local v249, v250, v251 = pairs(v248)
                while true do
                    local v252
                    v251, v252 = v249(v250, v251)
                    if v251 == nil then
                        break
                    end
                    vu242[# vu242 + 1] = v252.name
                    vu243[# vu243 + 1] = v252.name:lower():gsub("%s+", "")
                end
                break
            end
        end
    end)()
    local vu253 = {
        NEUTRAL = Color3.fromRGB(220, 220, 255),
        VALID = Color3.fromRGB(120, 255, 150),
        INVALID = Color3.fromRGB(255, 120, 120)
    }
    local vu254 = nil
    local function vu261(p255)
        local v256 = # p255
        local v257 = 1
        local v258 = ""
        while v257 <= v256 do
            if p255:sub(v257, v257):match("%S") then
                local v259 = v257
                while v257 <= v256 and p255:sub(v257, v257):match("%S") do
                    v257 = v257 + 1
                end
                local v260 = p255:sub(v259, v257 - 1)
                if # v260 > 0 then
                    v260 = v260:sub(1, 1):upper() .. v260:sub(2):lower()
                end
                v258 = v258 .. v260
            else
                v258 = v258 .. p255:sub(v257, v257)
                v257 = v257 + 1
            end
        end
        return v258
    end
    local vu262 = 1
    local function vu264(p263)
        if vu254 then
            vu254:Cancel()
        end
        vu254 = vu53:Create(vu241, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = p263
        })
        vu254:Play()
    end
    local v265 = vu238
    vu238.GetPropertyChangedSignal(v265, "Text"):Connect(function()
        vu262 = vu238.CursorPosition
        local v266 = vu238.Text
        local v267 = vu261(v266)
        if v267 ~= v266 then
            vu238.Text = v267
            local v268 = # v267 - # v266
            vu238.CursorPosition = math.max(1, math.min(vu262 + v268, # v267 + 1))
            return
        end
        local v269 = vu238.Text
        local v270 = v269:lower():gsub("%s+", "")
        local v271, v272, v273 = ipairs(vu242)
        local v274 = false
        while true do
            local v275
            v273, v275 = v271(v272, v273)
            if v273 == nil then
                break
            end
            if v275:lower() == v269:lower() then
                v274 = true
                break
            end
        end
        local v276 = table.find(vu243, v270) ~= nil
        local v277
        if v269 == "" then
            v277 = vu253.NEUTRAL
        elseif v274 then
            v277 = vu253.VALID
        elseif v276 then
            v277 = vu253.VALID
        else
            v277 = vu253.INVALID
        end
        vu264(v277)
    end)
    vu264(vu253.NEUTRAL)
    local vu278 = {
        "Shadow Dragon",
        "Bat Dragon",
        "Frost Dragon",
        "Giraffe",
        "Owl",
        "Parrot",
        "Crow",
        "Evil Unicorn",
        "Arctic Reindeer",
        "Hedgehog",
        "Dalmatian",
        "Turtle",
        "Kangaroo",
        "Lion",
        "Elephant",
        "Rhino",
        "Chocolate Chip Bat Dragon",
        "Cow",
        "Blazing Lion",
        "African Wild Dog",
        "Flamingo",
        "Diamond Butterfly",
        "Mini Pig",
        "Caterpillar",
        "Albino Monkey",
        "Candyfloss Chick",
        "Pelican",
        "Blue Dog",
        "Pink Cat",
        "Haetae",
        "Peppermint Penguin",
        "Winged Tiger",
        "Sugar Glider",
        "Shark Puppy",
        "Goat",
        "Sheeeeep",
        "Lion Cub",
        "Nessie",
        "Flamingo",
        "Frostbite Bear",
        "Balloon Unicorn",
        "Honey Badger",
        "Hot Doggo",
        "Crocodile",
        "Hare",
        "Ram",
        "Yeti",
        "Meetkat",
        "Jellyfish",
        "Happy Clown",
        "Orchid Butterfly",
        "Many Mackerel",
        "Strawberry Shortcake Bat Dragon",
        "Zombie Buffalo",
        "Fairy Bat Dragon"
    }
    local vu279 = Instance.new("TextButton")
    vu279.Size = UDim2.new(0.6, 0, 0, 25)
    vu279.Position = UDim2.new(0.2, 0, 0.6, 0)
    vu279.Text = "Spawn High Tier"
    vu279.BackgroundColor3 = Color3.fromRGB(200, 0, 200)
    vu279.BackgroundTransparency = 0.1
    vu279.Font = Enum.Font.FredokaOne
    vu279.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu279.TextSize = 16
    vu279.Parent = vu236
    local v280 = Instance.new("UICorner")
    v280.CornerRadius = UDim.new(0, 8)
    v280.Parent = vu279
    local vu281 = Instance.new("UIStroke")
    vu281.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vu281.Color = Color3.fromRGB(255, 255, 255)
    vu281.Thickness = 1.5
    vu281.Transparency = 0.1
    vu281.Parent = vu279
    local v282 = Instance.new("UIStroke")
    v282.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v282.Color = Color3.new(0, 0, 0)
    v282.Thickness = 1.5
    v282.Transparency = 0
    v282.Parent = vu279
    local vu283 = {
        BackgroundColor3 = vu279.BackgroundColor3,
        BackgroundTransparency = vu279.BackgroundTransparency,
        StrokeColor = Color3.fromRGB(255, 255, 255),
        StrokeThickness = 1.5,
        StrokeTransparency = 0.1
    }
    local vu284 = {
        endTime = 0,
        tween = nil,
        resetTween = nil
    }
    vu279.MouseEnter:Connect(function()
        if vu284.endTime < os.clock() then
            vu279.BackgroundColor3 = Color3.fromRGB(220, 0, 220)
            vu53:Create(vu281, TweenInfo.new(0.2), {
                Thickness = 2,
                Transparency = 0.05
            }):Play()
        end
    end)
    vu279.MouseLeave:Connect(function()
        if vu284.endTime < os.clock() then
            vu279.BackgroundColor3 = vu283.BackgroundColor3
            vu53:Create(vu281, TweenInfo.new(0.2), {
                Thickness = vu283.StrokeThickness,
                Transparency = vu283.StrokeTransparency
            }):Play()
        end
    end)
    vu279.MouseButton1Click:Connect(function()
        local v285 = os.clock()
        local v286 = 1.5
        local v287 = v285 < vu284.endTime
        if v287 then
            vu284.intensity = math.min(vu284.intensity + 0.3, 1.5)
            v286 = 1.5
        else
            vu284.intensity = 1
        end
        if vu284.strokeTween then
            vu284.strokeTween:Cancel()
        end
        if vu284.resetThread then
            coroutine.close(vu284.resetThread)
        end
        local v288 = Color3.fromRGB(255, 50, 50)
        local v289, v290, v291 = ipairs(vu278)
        local v292 = false
        while true do
            local v293
            v291, v293 = v289(v290, v291)
            if v291 == nil then
                break
            end
            local v294 = GetPetByName(v293)
            if v294 then
                if vu56.M then
                    vu83(v294, {
                        pet_trick_level = math.random(1, 5),
                        mega_neon = true,
                        rideable = vu56.R,
                        flyable = vu56.F,
                        age = math.random(1, 900000),
                        ailments_completed = 0,
                        rp_name = ""
                    })
                    v292 = true
                elseif vu56.N then
                    vu83(v294, {
                        pet_trick_level = math.random(0, 5),
                        neon = true,
                        rideable = vu56.R,
                        flyable = vu56.F,
                        age = math.random(1, 900000),
                        ailments_completed = 0,
                        rp_name = ""
                    })
                    v292 = true
                else
                    vu83(v294, {
                        pet_trick_level = math.random(1, 5),
                        neon = false,
                        mega_neon = false,
                        rideable = vu56.R,
                        flyable = vu56.F,
                        age = math.random(1, 900000),
                        ailments_completed = 0,
                        rp_name = ""
                    })
                    v292 = true
                end
            end
        end
        if v292 then
            v288 = Color3.fromRGB(0, 255 * vu284.intensity, 0)
        else
        end
        vu281.Color = v288
        vu281.Thickness = 2 * vu284.intensity
        vu281.Transparency = 0.1 / vu284.intensity
        if v287 then
            vu284.strokeTween = vu53:Create(vu281, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Thickness = 2.5 * vu284.intensity,
                Transparency = 0.05 / vu284.intensity
            })
            vu284.strokeTween:Play()
        end
        vu284.endTime = v285 + v286
        vu284.resetThread = task.delay(v286, function()
            if os.clock() >= vu284.endTime then
                vu53:Create(vu281, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    Color = vu283.StrokeColor,
                    Thickness = vu283.StrokeThickness,
                    Transparency = vu283.StrokeTransparency
                }):Play()
            end
        end)
    end)
    local vu295 = Instance.new("TextButton")
    vu295.Size = UDim2.new(0.6, 0, 0, 25)
    vu295.Position = UDim2.new(0.2, 0, 0.7, 0)
    vu295.Text = "Spawn Pet"
    vu295.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    vu295.BackgroundTransparency = 0.1
    vu295.Font = Enum.Font.FredokaOne
    vu295.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu295.TextSize = 16
    vu295.Parent = vu236
    local v296 = Instance.new("UICorner")
    v296.CornerRadius = UDim.new(0, 8)
    v296.Parent = vu295
    local vu297 = Instance.new("UIStroke")
    vu297.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vu297.Color = Color3.fromRGB(255, 255, 255)
    vu297.Thickness = 1.5
    vu297.Transparency = 0.1
    vu297.Parent = vu295
    local v298 = Instance.new("UIStroke")
    v298.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v298.Color = Color3.new(0, 0, 0)
    v298.Thickness = 1.5
    v298.Transparency = 0
    v298.Parent = vu295
    local vu299 = {
        BackgroundColor3 = vu295.BackgroundColor3,
        BackgroundTransparency = vu295.BackgroundTransparency,
        StrokeColor = Color3.fromRGB(255, 255, 255),
        StrokeThickness = 1.5,
        StrokeTransparency = 0.1
    }
    local vu300 = {
        endTime = 0,
        tween = nil,
        resetTween = nil
    }
    vu295.MouseEnter:Connect(function()
        if vu300.endTime < os.clock() then
            vu295.BackgroundColor3 = Color3.fromRGB(0, 130, 230)
            vu53:Create(vu297, TweenInfo.new(0.2), {
                Thickness = 2,
                Transparency = 0.05
            }):Play()
        end
    end)
    vu295.MouseLeave:Connect(function()
        if vu300.endTime < os.clock() then
            vu295.BackgroundColor3 = vu299.BackgroundColor3
            vu53:Create(vu297, TweenInfo.new(0.2), {
                Thickness = vu299.StrokeThickness,
                Transparency = vu299.StrokeTransparency
            }):Play()
        end
    end)
    _G.spawn_pet = nil
    local vu301 = {
        endTime = 0,
        strokeTween = nil,
        resetThread = nil,
        intensity = 1,
        lastSuccess = false
    }
    vu295.MouseButton1Click:Connect(function()
        local v302 = vu238.Text
        local v303 = os.clock()
        local v304 = 1.5
        local v305 = v303 < vu301.endTime
        if v305 then
            vu301.intensity = math.min(vu301.intensity + 0.3, 1.5)
            v304 = 1.5
        else
            vu301.intensity = 1
        end
        if vu301.strokeTween then
            vu301.strokeTween:Cancel()
        end
        if vu301.resetThread then
            coroutine.close(vu301.resetThread)
        end
        local v306 = Color3.fromRGB(255, 50, 50)
        local v307 = false
        if v302 == "" then
        else
            local v308 = GetPetByName(v302)
            if v308 then
                if vu56.M then
                    vu83(v308, {
                        pet_trick_level = math.random(1, 5),
                        mega_neon = true,
                        rideable = vu56.R,
                        flyable = vu56.F,
                        age = math.random(1, 900000),
                        ailments_completed = 0,
                        rp_name = ""
                    })
                elseif vu56.N then
                    vu83(v308, {
                        pet_trick_level = math.random(0, 5),
                        neon = true,
                        rideable = vu56.R,
                        flyable = vu56.F,
                        age = math.random(1, 900000),
                        ailments_completed = 0,
                        rp_name = ""
                    })
                else
                    vu83(v308, {
                        pet_trick_level = math.random(1, 5),
                        neon = false,
                        mega_neon = false,
                        rideable = vu56.R,
                        flyable = vu56.F,
                        age = math.random(1, 900000),
                        ailments_completed = 0,
                        rp_name = ""
                    })
                end

                v307 = true
            else

            end
        end
        vu301.lastSuccess = v307
        if v305 and vu301.lastSuccess then
            v306 = Color3.fromRGB(0, 255 * vu301.intensity, 0)
        end
        vu297.Color = v306
        vu297.Thickness = 2 * vu301.intensity
        vu297.Transparency = 0.1 / vu301.intensity
        if v305 then
            vu301.strokeTween = vu53:Create(vu297, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Thickness = 2.5 * vu301.intensity,
                Transparency = 0.05 / vu301.intensity
            })
            vu301.strokeTween:Play()
        end
        vu301.endTime = v303 + v304
        vu301.resetThread = task.delay(v304, function()
            if os.clock() >= vu301.endTime then
                vu53:Create(vu297, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    Color = vu299.StrokeColor,
                    Thickness = vu299.StrokeThickness,
                    Transparency = vu299.StrokeTransparency
                }):Play()
            end
        end)
    end)
    local v309 = Instance.new("Frame")
    v309.Name = "InfoBox"
    v309.Size = UDim2.new(0.85, 0, 0, 30)
    v309.Position = UDim2.new(0.075, 0, 0.45, 0)
    v309.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    v309.BackgroundTransparency = 0.5
    v309.BorderSizePixel = 0
    v309.Parent = vu236
    local v310 = Instance.new("UICorner")
    v310.CornerRadius = UDim.new(0, 8)
    v310.Parent = v309
    local vu311 = Instance.new("UIStroke")
    vu311.Color = Color3.fromRGB(255, 255, 255)
    vu311.Thickness = 1.2
    vu311.Transparency = 0.7
    vu311.Parent = v309
    local vu312 = Instance.new("Frame")
    vu312.Name = "TextContainer"
    vu312.Size = UDim2.new(1, 0, 1, 0)
    vu312.BackgroundTransparency = 1
    vu312.Parent = v309
    local v313 = Instance.new("UIListLayout")
    v313.FillDirection = Enum.FillDirection.Horizontal
    v313.HorizontalAlignment = Enum.HorizontalAlignment.Center
    v313.VerticalAlignment = Enum.VerticalAlignment.Center
    v313.Padding = UDim.new(0, 4)
    v313.Parent = vu312
    local vu314 = {
        M = Color3.fromRGB(170, 0, 255),
        N = Color3.fromRGB(0, 255, 100),
        F = Color3.fromRGB(0, 200, 255),
        R = Color3.fromRGB(255, 50, 150)
    }
    local vu315 = {
        pulsePhase = 0,
        pulseSpeed = 2,
        baseThickness = 1.2,
        maxThickness = 3,
        activeColors = nil,
        active = false
    }
    local function v326(p316)
        if vu315.active then
            vu315.pulsePhase = vu315.pulsePhase + p316 * vu315.pulseSpeed
            local v317 = (math.sin(vu315.pulsePhase) + 1) * 0.5
            vu311.Thickness = vu315.baseThickness + (vu315.maxThickness - vu315.baseThickness) * v317
            vu311.Transparency = 0.7 - 0.5 * v317
            if vu315.activeColors then
                local v318 = 0.8 + 0.4 * v317
                local v319, v320, v321 = ipairs(vu315.activeColors)
                local v322 = 0
                local v323 = 0
                local v324 = 0
                while true do
                    local v325
                    v321, v325 = v319(v320, v321)
                    if v321 == nil then
                        break
                    end
                    v322 = v322 + v325.R * v318
                    v323 = v323 + v325.G * v318
                    v324 = v324 + v325.B * v318
                end
                vu311.Color = Color3.new(math.min(v322 / # vu315.activeColors, 1), math.min(v323 / # vu315.activeColors, 1), math.min(v324 / # vu315.activeColors, 1))
            end
        end
    end
    local function vu330(p327, p328)
        local v329 = Instance.new("TextLabel")
        v329.Size = UDim2.new(0, 0, 1, 0)
        v329.AutomaticSize = Enum.AutomaticSize.X
        v329.BackgroundTransparency = 1
        v329.Text = p327
        v329.Font = Enum.Font.FredokaOne
        v329.TextSize = 16
        v329.TextColor3 = p328
        v329.TextXAlignment = Enum.TextXAlignment.Left
        v329.TextYAlignment = Enum.TextYAlignment.Center
        if p327 == "Mega Neon" then
            v329.Text = "Mega Neon"
        elseif p327 ~= "Ride" and (p327 ~= "Neon" and p327 ~= "Fly") then
            v329.Text = v329.Text .. " "
        end
        return v329
    end
    local function vu344(p331)
        local v332 = vu312
        local v333, v334, v335 = ipairs(v332:GetChildren())
        while true do
            local v336
            v335, v336 = v333(v334, v335)
            if v335 == nil then
                break
            end
            if v336:IsA("TextLabel") then
                v336:Destroy()
            end
        end
        local v337 = {}
        local v338 = {}
        local v339
        if p331.M then
            table.insert(v338, {
                "Mega Neon",
                vu314.M
            })
            table.insert(v337, vu314.M)
            v339 = true
        else
            v339 = false
        end
        if p331.N then
            table.insert(v338, {
                "Neon",
                vu314.N
            })
            table.insert(v337, vu314.N)
            v339 = true
        end
        if p331.F then
            table.insert(v338, {
                "Fly",
                vu314.F
            })
            table.insert(v337, vu314.F)
            v339 = true
        end
        if p331.R then
            table.insert(v338, {
                "Ride",
                vu314.R
            })
            table.insert(v337, vu314.R)
            v339 = true
        end
        local v340, v341, v342 = ipairs(v338)
        while true do
            local v343
            v342, v343 = v340(v341, v342)
            if v342 == nil then
                break
            end
            vu330(v343[1], v343[2]).Parent = vu312
        end
        if v339 then
            vu315.active = true
            vu315.activeColors = v337
        else
            vu315.active = false
            vu330("Normal", Color3.fromRGB(255, 255, 255)).Parent = vu312
            vu311.Color = Color3.fromRGB(255, 255, 255)
            vu311.Thickness = vu315.baseThickness
            vu311.Transparency = 0.7
        end
    end
    vu55.Heartbeat:Connect(v326)
    vu344({
        F = false,
        R = false,
        N = false,
        M = false
    })
    local v345 = {
        "F",
        "R",
        "N",
        "M"
    }
    local v346 = # v345
    local v347 = 0.18
    local v348 = 0.07
    local v349 = (1 - (v346 * v347 + (v346 - 1) * v348)) / 2
    local v350, v351, v352 = ipairs(v345)
    local vu353 = vu218
    local vu354 = vu253
    local vu355 = vu261
    local vu356 = vu262
    local v357 = vu237
    local v358 = vu314
    local v359 = vu236
    while true do
        local v360, vu361 = v350(v351, v352)
        if v360 == nil then
            break
        end
        v352 = v360
        local vu362 = Instance.new("TextButton")
        vu362.Size = UDim2.new(v347, 0, 0, 25)
        vu362.Position = UDim2.new(v349 + (v347 + v348) * (v360 - 1), 0, 0.3, 0)
        vu362.Text = vu361
        vu362.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        vu362.BackgroundTransparency = 0.2
        vu362.Font = Enum.Font.FredokaOne
        vu362.TextColor3 = Color3.fromRGB(255, 255, 255)
        vu362.TextSize = 16
        vu362.Parent = v359
        local v363 = Instance.new("UICorner")
        v363.CornerRadius = UDim.new(0, 6)
        v363.Parent = vu362
        local vu364 = Instance.new("UIStroke")
        vu364.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        vu364.Color = v358[vu361]
        vu364.Thickness = 2
        vu364.Transparency = 0.5
        vu364.Parent = vu362
        local v365 = Instance.new("UIStroke")
        v365.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        v365.Color = Color3.new(0, 0, 0)
        v365.Thickness = 1.5
        v365.Transparency = 0
        v365.Parent = vu362
        local vu366 = {
            Color = v358[vu361],
            Thickness = 2,
            Transparency = 0.5
        }
        vu362.MouseButton1Click:Connect(function()
            if vu361 ~= "M" or not vu56.N then
                if vu361 ~= "N" or not vu56.M then
                    vu56[vu361] = not vu56[vu361]
                    if vu56[vu361] then
                        vu362.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                        vu53:Create(vu364, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Color = Color3.fromRGB(0, 255, 0),
                            Thickness = 3,
                            Transparency = 0.2
                        }):Play()
                    else
                        vu362.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
                        vu53:Create(vu364, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                            Color = vu366.Color,
                            Thickness = vu366.Thickness,
                            Transparency = vu366.Transparency
                        }):Play()
                    end
                    vu344(vu56)
                end
            else
                return
            end
        end)
    end
    local vu367 = Instance.new("TextBox")
    vu367.Size = UDim2.new(0.85, 0, 0, 28)
    vu367.Position = UDim2.new(0.075, 0, 0.1, 0)
    vu367.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    vu367.BackgroundTransparency = 0.2
    vu367.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu367.TextSize = 14
    vu367.Font = Enum.Font.FredokaOne
    vu367.PlaceholderText = "Enter Toy Name to Spawn"
    vu367.Text = ""
    vu367.ClearTextOnFocus = false
    vu367.Parent = v357
    local v368 = Instance.new("UICorner")
    v368.CornerRadius = UDim.new(0, 6)
    v368.Parent = vu367
    local v369 = Instance.new("UIStroke")
    v369.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v369.Color = Color3.new(0, 0, 0)
    v369.Thickness = 1.2
    v369.Transparency = 0
    v369.Parent = vu367
    local vu370 = Instance.new("UIStroke")
    vu370.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vu370.Color = Color3.fromRGB(255, 255, 255)
    vu370.Thickness = 2.2
    vu370.Transparency = 0.25
    vu370.Parent = vu367
    local vu371 = {}
    local vu372 = {};
    (function()
        local v373 = require(game.ReplicatedStorage.Fsys).load("InventoryDB")
        local v374, v375, v376 = pairs(v373)
        while true do
            local v377
            v376, v377 = v374(v375, v376)
            if v376 == nil then
                break
            end
            if v376 == "toys" then
                local v378, v379, v380 = pairs(v377)
                while true do
                    local v381
                    v380, v381 = v378(v379, v380)
                    if v380 == nil then
                        break
                    end
                    vu371[# vu371 + 1] = v381.name
                    vu372[# vu372 + 1] = v381.name:lower():gsub("%s+", "")
                end
                break
            end
        end
    end)()
    local vu382 = nil
    local v383 = vu367
    vu367.GetPropertyChangedSignal(v383, "Text"):Connect(function()
        vu356 = vu367.CursorPosition
        local v384 = vu367.Text
        local v385 = vu355(v384)
        if v385 ~= v384 then
            vu367.Text = v385
            local v386 = # v385 - # v384
            vu367.CursorPosition = math.max(1, math.min(vu356 + v386, # v385 + 1))
            return
        end
        local v387 = vu367.Text
        local v388 = v387:lower():gsub("%s+", "")
        local v389, v390, v391 = ipairs(vu371)
        local v392 = false
        while true do
            local v393
            v391, v393 = v389(v390, v391)
            if v391 == nil then
                break
            end
            if v393:lower() == v387:lower() then
                v392 = true
                break
            end
        end
        local v394 = table.find(vu372, v388) ~= nil
        local v395
        if v387 == "" then
            v395 = vu354.NEUTRAL
        elseif v392 then
            v395 = vu354.VALID
        elseif v394 then
            v395 = vu354.VALID
        else
            v395 = vu354.INVALID
        end
        if vu382 then
            vu382:Cancel()
        end
        vu382 = vu53:Create(vu370, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Color = v395
        })
        vu382:Play()
    end)
    if vu382 then
        local v396 = vu382
        vu382.Cancel(v396)
    end
    vu382 = vu53:Create(vu370, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Color = vu354.NEUTRAL
    })
    local v397 = vu382
    vu382.Play(v397)
    local vu398 = Instance.new("TextButton")
    vu398.Size = UDim2.new(0.6, 0, 0, 25)
    vu398.Position = UDim2.new(0.2, 0, 0.3, 0)
    vu398.Text = "Spawn Toy"
    vu398.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
    vu398.BackgroundTransparency = 0.1
    vu398.Font = Enum.Font.FredokaOne
    vu398.TextColor3 = Color3.fromRGB(255, 255, 255)
    vu398.TextSize = 16
    vu398.Parent = v357
    local v399 = Instance.new("UICorner")
    v399.CornerRadius = UDim.new(0, 8)
    v399.Parent = vu398
    local vu400 = Instance.new("UIStroke")
    vu400.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vu400.Color = Color3.fromRGB(255, 255, 255)
    vu400.Thickness = 1.5
    vu400.Transparency = 0.1
    vu400.Parent = vu398
    local v401 = Instance.new("UIStroke")
    v401.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    v401.Color = Color3.new(0, 0, 0)
    v401.Thickness = 1.5
    v401.Transparency = 0
    v401.Parent = vu398
    local vu402 = {
        BackgroundColor3 = vu398.BackgroundColor3,
        BackgroundTransparency = vu398.BackgroundTransparency,
        StrokeColor = Color3.fromRGB(255, 255, 255),
        StrokeThickness = 1.5,
        StrokeTransparency = 0.1
    }
    local vu403 = {
        endTime = 0,
        strokeTween = nil,
        resetThread = nil,
        intensity = 1,
        lastSuccess = false
    }
    vu398.MouseEnter:Connect(function()
        if vu403.endTime < os.clock() then
            vu398.BackgroundColor3 = Color3.fromRGB(220, 120, 0)
            vu53:Create(vu400, TweenInfo.new(0.2), {
                Thickness = 2,
                Transparency = 0.05
            }):Play()
        end
    end)
    vu398.MouseLeave:Connect(function()
        if vu403.endTime < os.clock() then
            vu398.BackgroundColor3 = vu402.BackgroundColor3
            vu53:Create(vu400, TweenInfo.new(0.2), {
                Thickness = vu402.StrokeThickness,
                Transparency = vu402.StrokeTransparency
            }):Play()
        end
    end)
    vu398.MouseButton1Click:Connect(function()
        local v404 = vu367.Text
        local v405 = os.clock()
        local v406 = 1.5
        local v407 = v405 < vu403.endTime
        if v407 then
            vu403.intensity = math.min(vu403.intensity + 0.3, 1.5)
            v406 = 1.5
        else
            vu403.intensity = 1
        end
        if vu403.strokeTween then
            vu403.strokeTween:Cancel()
        end
        if vu403.resetThread then
            coroutine.close(vu403.resetThread)
        end
        local v408 = Color3.fromRGB(255, 50, 50)
        local v409 = false
        if v404 == "" then

        else
            local v410 = GetToyByName(v404)
            if v410 then
                vu88(v410)

                v409 = true
            else

            end
        end
        vu403.lastSuccess = v409
        if v407 and vu403.lastSuccess then
            v408 = Color3.fromRGB(0, 255 * vu403.intensity, 0)
        end
        vu400.Color = v408
        vu400.Thickness = 2 * vu403.intensity
        vu400.Transparency = 0.1 / vu403.intensity
        if v407 then
            vu403.strokeTween = vu53:Create(vu400, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                Thickness = 2.5 * vu403.intensity,
                Transparency = 0.05 / vu403.intensity
            })
            vu403.strokeTween:Play()
        end
        vu403.endTime = v405 + v406
        vu403.resetThread = task.delay(v406, function()
            if os.clock() >= vu403.endTime then
                vu53:Create(vu400, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                    Color = vu402.StrokeColor,
                    Thickness = vu402.StrokeThickness,
                    Transparency = vu402.StrokeTransparency
                }):Play()
            end
        end)
    end);
    (function()
        local v411 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local v412 = vu53:Create(vu353, v411, {
            Size = UDim2.new(0, 320, 0, 300)
        })
        local v413 = vu53:Create(vu353, v411, {
            BackgroundTransparency = 0
        })
        v412:Play()
        v413:Play()
    end)()
    local vu414 = nil
    local vu415 = nil
    local vu416 = nil
    vu353.InputBegan:Connect(function(pu417)
        if pu417.UserInputType == Enum.UserInputType.MouseButton1 or pu417.UserInputType == Enum.UserInputType.Touch then
            vu414 = true
            vu415 = pu417.Position
            vu416 = vu353.Position
            pu417.Changed:Connect(function()
                if pu417.UserInputState == Enum.UserInputState.End then
                    vu414 = false
                end
            end)
        end
    end)
    vu353.InputChanged:Connect(function(p418)
        if vu414 and (p418.UserInputType == Enum.UserInputType.MouseMovement or p418.UserInputType == Enum.UserInputType.Touch) then
            local v419 = p418.Position - vu415
            vu353.Position = UDim2.new(vu416.X.Scale, vu416.X.Offset + v419.X, vu416.Y.Scale, vu416.Y.Offset + v419.Y)
        end
    end)
end)
