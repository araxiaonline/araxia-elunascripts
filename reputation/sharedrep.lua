
local PLAYER_EVENT_ON_LOGIN = 3
local racesHorde = "(2, 5, 6, 8, 10)"
local racesAlliance = "(1, 3, 4, 7, 11)"

-- a little stolen function magic to allow us to do some string interpolation
-- from http://lua-users.org/wiki/StringInterpolation
local function interp(s, tab)
    return (s:gsub('($%b{})', function(w) return tab[w:sub(3, -2)] or w end))
end

local function OnPlayerLogin(event, player)
    local accountId = player:GetAccountId()
    local guid = player:GetGUID()

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
        {
            accountParam = accountId,
            raceParam = raceQuery,
            guidParam = tostring(guid) 
        }
    ))

    if results then
        repeat
            local repGuid = results:GetUInt32(0)
            local faction = results:GetUInt32(1)
            local standing = results:GetUInt32(2)
            player:Say("GUID " .. repGuid .. " Faction ".. tostring(faction) .. " standing ".. tostring(standing), 0)

            if repGuid ~= guid then
                player:SetReputation(faction, standing)
            end
        until not results:NextRow()
    end

end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOGIN, OnPlayerLogin)


-- '1', '68', '500'
-- '1', '76', '243'
-- '3', '947', '1179'
-- '3', '1052', '24'
-- '3', '1064', '12'
-- '3', '1067', '12'
-- '3', '1085', '12'
-- '3', '1124', '12'


-- '6', '81', '243'
-- '6', '530', '243'
-- '6', '911', '975'
-- '6', '932', '46499' // aldor
-- '6', '933', '3093'
-- '6', '934', '39499' // scryer
-- '6', '935', '42999'
-- '6', '936', '42999'
-- '6', '942', '42999'

-- '6', '967', '42999'
-- '6', '970', '45499'
-- '6', '989', '42999'
-- '6', '1011', '42999'
-- '6', '1038', '42999'
-- '6', '1073', '42999'
-- '6', '1077', '42999'
-- '6', '1090', '42999'
-- '6', '1091', '42999'
-- '6', '1098', '42999'
-- '6', '1104', '42999'
-- '6', '1105', '42999'
-- '6', '1106', '42999'
-- '6', '1119', '84999'
-- '6', '1156', '42999'
