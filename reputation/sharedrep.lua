
local PLAYER_EVENT_ON_LOGIN = 3
local racesHorde = "(2, 5, 6, 8, 10)"
local racesAlliance = "(1, 3, 4, 7, 11)"

local function interp(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

local function OnPlayerLogin(event, player)
    local accountId = player:GetAccountId()
    local guid = player:GetGUID()
    player:Say("My Guid is ".. tostring(guid), 0)

    local raceQuery = racesHorde
    if player:IsAlliance() then
        raceQuery = racesAlliance
    end

    local queryString = [[
        SELECT
            guid 
            , faction
            , MAX(standing)
        FROM acore_characters.character_reputation
        WHERE standing != 0
        AND GUID IN (
            SELECT
                guid
            FROM characters
            WHERE
                account = ${accountParam}
                AND guid != ${guidParam}
                AND race IN ${raceParam}
        )
        GROUP BY faction;
    ]]

    local results = CharDBQuery(interp(queryString, 
        { accountParam = accountId, raceParam = raceQuery, guidParam = tostring(guid) }))

    if results then
        repeat
            local repGuid = results:GetUInt32(0)
            local faction = results:GetUInt32(1)
            local standing = results:GetUInt32(2)
            -- player:Say("GUID " .. repGuid .. " Faction ".. tostring(faction) .. " standing ".. tostring(standing), 0)

            if repGuid ~= guid then
                player:SetReputation(faction, standing)
            end
        until not results:NextRow()
    end

end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, OnPlayerLogin)
