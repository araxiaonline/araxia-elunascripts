
local PLAYER_EVENT_ON_LOGIN = 3

local function OnPlayerLogin(event, player)
    local accountId = player:GetAccountId()

    local raceQuery = "(2, 5, 6, 8, 10)"
    if player:IsAlliance() then
        raceQuery = "(1, 3, 4, 7, 11)"
    end

    results = CharDBQuery("SELECT guid FROM characters WHERE account = " 
        .. accountId
        .. " AND race IN ".. raceQuery
    )

    local playerList = {}
    if results then
        repeat
            playerList[#playerList + 1] = results:GetUInt32(0)
        until not results:NextRow()
    end

end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, OnPlayerLogin)
