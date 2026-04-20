local function normalizeInventory(rawItems)
    local items = {}
    local totalWeight = 0.0

    if type(rawItems) ~= "table" then
        return items, totalWeight
    end

    for _, item in pairs(rawItems) do
        local count = tonumber(item.count or item.amount or item.qty or 0) or 0
        local weight = tonumber(item.weight or 0.0) or 0.0
        local label = item.label or item.name or "Unknown Item"
        local name = item.name or label
        local icon = item.icon or item.image or ""

        local row = {
            name = name,
            label = label,
            count = count,
            weight = weight,
            icon = icon
        }

        totalWeight = totalWeight + (weight * count)
        items[#items + 1] = row
    end

    table.sort(items, function(a, b)
        return a.label < b.label
    end)

    return items, totalWeight
end

local function fallbackItems()
    if not Config.EnableFallbackItems then
        return {}, 0.0
    end

    local items = {
        { name = "water", label = "Water", count = 4, weight = 0.5, icon = "" },
        { name = "bread", label = "Bread", count = 3, weight = 0.4, icon = "" },
        { name = "bandage", label = "Bandage", count = 2, weight = 0.2, icon = "" },
        { name = "revolver_ammo", label = "Revolver Ammo", count = 32, weight = 0.02, icon = "" }
    }

    local _, totalWeight = normalizeInventory(items)
    return items, totalWeight
end

local function getPlayerInventory(src)
    local success, data = pcall(function()
        if exports and exports.vorp_inventory and exports.vorp_inventory.getUserInventory then
            return exports.vorp_inventory:getUserInventory(src)
        end
        return nil
    end)

    if not success or not data then
        return fallbackItems()
    end

    local items, totalWeight = normalizeInventory(data)
    if #items == 0 and Config.EnableFallbackItems then
        return fallbackItems()
    end

    return items, totalWeight
end

local function sendInventory(src, eventName)
    local items, totalWeight = getPlayerInventory(src)
    TriggerClientEvent(eventName, src, {
        items = items,
        weight = totalWeight
    })
end

RegisterNetEvent("vorp_backpack_inventory:server:getInventory", function()
    local src = source
    sendInventory(src, "vorp_backpack_inventory:client:openInventory")
end)

RegisterNetEvent("vorp_backpack_inventory:server:useItem", function(itemName)
    local src = source
    if type(itemName) ~= "string" or itemName == "" then
        return
    end

    TriggerEvent(Config.UseItemEvent, src, itemName)
    sendInventory(src, "vorp_backpack_inventory:client:refreshInventory")
end)

RegisterNetEvent("vorp_backpack_inventory:server:dropItem", function(itemName, amount)
    local src = source
    if type(itemName) ~= "string" or itemName == "" then
        return
    end

    local dropAmount = tonumber(amount) or Config.DefaultDropAmount
    if dropAmount < 1 then
        dropAmount = 1
    end

    TriggerEvent(Config.DropItemEvent, src, itemName, dropAmount)
    sendInventory(src, "vorp_backpack_inventory:client:refreshInventory")
end)
