local PLAYER_EVENT_ON_CHAT = 18
local PLAYER_EVENT_ON_COMMAND = 42

local Auctionator = {}

local function Debug(message)
    PrintDebug("[AuctionatorLua] " .. message)
end

local function Info(message)
    PrintInfo("[AuctionatorLua] " .. message)
end

local function split(inputString)
    local values = {}
    for i in string.gmatch(inputString, "([^%s]+)") do
        values[#values + 1] = i
    end

    return values
end

function Auctionator.AddItem(entry, buyoutPrice, quantity)
    RunCommand(".auctionator additem ".. entry.. " ".. buyoutPrice.. " ".. quantity)
end

function Auctionator.Status()
    RunCommand(".auctionator status")
end

function Auctionator.onCommand(event, player, msg, Type, lang)
    Debug("[Auctionator] onCommand ".. msg)

    local command = split(msg)
    Debug(command[1])

    if (command[1] == "ahn") then
        if (#command == 1) then
            Auctionator.Status()
            return
        end

        if (command[2] == "additem") then
            if (#command ~= 5) then
                if (player) then
                    player.Say("Usage: .ahn additem <item> <buyoutprice> <quantity>", 0);
                else
                    Info('Usage: .ahn additem <item> <buyoutprice> <quantity>')
                end
                return
            end

            Auctionator.AddItem(command[3], command[4], command[5])
        end
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_COMMAND, Auctionator.onCommand)
