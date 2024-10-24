local a, b = 10, 5;

local function timer(func, name)
    local start = os.clock()
    func()
    local elapsed = os.clock() - start;
    print(name .. " took " .. elapsed .. " seconds.")
end;

timer(function()
    local a = 10;
end, "OP_LOADK")

timer(function()
    local b = a;
end, "OP_MOVE")

timer(function()
    local c = a + b;
end, "OP_ADD")

timer(function()
    local d = a - b;
end, "OP_SUB")

timer(function()
    local e = a * b;
end, "OP_MUL")

timer(function()
    local f = a / b;
end, "OP_DIV")

timer(function()
    local g = a % 3;
end, "OP_MOD")

timer(function()
    local h = a ^ 2;
end, "OP_POW")

timer(function()
    local concatResult = "Hello" .. " " .. "World";
end, "OP_CONCAT")

timer(function()
    local isEqual = (a == b)
end, "OP_EQ")

timer(function()
    local isLessThan = (a < b)
end, "OP_LT")

timer(function()
    local isLessOrEqual = (a <= b)
end, "OP_LE")

timer(function()
    local function myFunction(x)
        return x * 2;
    end;

    local callResult = myFunction(a)
end, "OP_CALL")

timer(function()
    local function varargTest(...)
        local args = {...};
        return #args;
    end;

    local varargCount = varargTest(1, 2, 3)
end, "OP_VARARG")

timer(function()
    local function returnTest()
        return "Returned Value";
    end;

    local returnValue = returnTest()
end, "OP_RETURN")

timer(function()
    for i = 1, 3 do end;
end, "OP_FORLOOP")

timer(function()
    local limit = 3;
    local index = 0;

    for i = 1, limit do
        index = index + 1;
    end;
end, "OP_FORPREP")

timer(function()
    local function tailCallTest(n)
        if n == 0 then
            return "Done";
        else
            return tailCallTest(n - 1)
        end;
    end;

    local tailCallResult = tailCallTest(3)
end, "OP_TAILCALL")

timer(function()
    local function closeTest()
        local x = 10;
        return function()
            return x;
        end;
    end;

    local closure = closeTest()
    local closeValue = closure()
end, "OP_CLOSE")

timer(function()
    local function closureTest()
        return function(x) return x * 2 end;
    end;

    local closureFunc = closureTest()
    local closureResult = closureFunc(5)
end, "OP_CLOSURE")

timer(function()
    local function jumpTest()
        for i = 1, 5 do
            if i == 3 then
                break;
            end;
        end;
    end;
    
    jumpTest()
end, "OP_JMP")

print("All opcodes tested.")
