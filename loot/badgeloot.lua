
local PLAYER_EVENT_ON_LOOT_ITEM = 32
local ITEM_BADGE_OF_JUSTICE = 29434

local function OnPlayerLootItem(event, player, item, count)
    local entry = item:GetDisplayId()

    if (entry == 29434) then
        player:AddItem(ITEM_BADGE_OF_JUSTICE, count)
    end
end

RegisterPlayerEvent(PLAYER_EVENT_ON_LOOT_ITEM, OnPlayerLootItem)
