local function GetByLaw(Number)
    local Output = {};
    local CurrentNumber, FirstNumber = Number, Number;

    Output[#Output + 1] = FirstNumber;

    while true do
        if #Output >= 3 and Output[#Output-2] == 4 and Output[#Output-1] == 2 and Output[#Output] == 1 then
            return {FirstNumber = FirstNumber, Sequence = Output};
        end;

        if CurrentNumber % 2 == 0 then
            CurrentNumber = CurrentNumber / 2;
        else
            CurrentNumber = CurrentNumber * 3 + 1;
        end;

        Output[#Output + 1] = CurrentNumber;
    end;
end;

local function Fetch(Number)
    local Output = {};

    for i = 1,Number do
        Output[i] = GetByLaw(i)
    end;

    return Output;
end;

for _,v in pairs(Fetch(20)) do
    print(string.format("(%d) - [%s]", v.FirstNumber, table.concat(v.Sequence, ",")))
end;

local Table = GetByLaw(21)

print(string.format("(%d) - [%s]", Table.FirstNumber, table.concat(Table.Sequence, ",")))