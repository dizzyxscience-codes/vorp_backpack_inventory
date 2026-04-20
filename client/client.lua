local isOpen = false

local function setUiState(state)
    isOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = state and "open" or "close"
    })
end

local function openBackpack()
    if isOpen then
        return
    end

    TriggerServerEvent("vorp_backpack_inventory:server:getInventory")
end

RegisterCommand(Config.OpenCommand, function()
    openBackpack()
end, false)

RegisterKeyMapping(Config.OpenCommand, "Open Backpack", "keyboard", Config.OpenKey)

RegisterNetEvent("vorp_backpack_inventory:client:openInventory", function(payload)
    if not payload then
        return
    end

    SetNuiFocus(true, true)
    isOpen = true

    SendNUIMessage({
        action = "open",
        title = Config.Title,
        maxWeight = Config.MaxWeight,
        unit = Config.WeightUnit,
        items = payload.items or {},
        weight = payload.weight or 0.0
    })
end)

RegisterNUICallback("close", function(_, cb)
    setUiState(false)
    cb({})
end)

RegisterNUICallback("useItem", function(data, cb)
    if not data or not data.name then
        cb({ ok = false })
        return
    end

    TriggerServerEvent("vorp_backpack_inventory:server:useItem", data.name)
    cb({ ok = true })
end)

RegisterNUICallback("dropItem", function(data, cb)
    if not data or not data.name then
        cb({ ok = false })
        return
    end

    local amount = tonumber(data.amount) or Config.DefaultDropAmount
    if amount < 1 then
        amount = 1
    end

    TriggerServerEvent("vorp_backpack_inventory:server:dropItem", data.name, amount)
    cb({ ok = true })
end)

RegisterNetEvent("vorp_backpack_inventory:client:refreshInventory", function(payload)
    if not isOpen then
        return
    end

    SendNUIMessage({
        action = "refresh",
        items = payload.items or {},
        weight = payload.weight or 0.0,
        maxWeight = Config.MaxWeight,
        unit = Config.WeightUnit
    })
end)

CreateThread(function()
    while true do
        Wait(0)
        if isOpen and IsControlJustPressed(0, 0x156F7119) then -- ESC
            setUiState(false)
        end
    end
end)
