local vehiclesToExplode = {}

RegisterCommand('setexplosive', function()
    local playerPed = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(playerPed, false)

    if DoesEntityExist(vehicle) and not IsEntityDead(vehicle) then
        local playerName = GetPlayerName(PlayerId())
        TriggerEvent("chatMessage", "^1[Server]", {255, 0, 0}, "Vehicle added for explosion.")
        print(string.format("Vehicle added for explosion by player %s", playerName))
        table.insert(vehiclesToExplode, {vehicle = vehicle, playerName = playerName})
    else
        TriggerEvent("chatMessage", "^1[Server]", {255, 0, 0}, "You are not in a vehicle or it's destroyed.")
    end
end, false)

RegisterCommand('detonate', function()
    if #vehiclesToExplode > 0 then
        for _, data in ipairs(vehiclesToExplode) do
            NetworkExplodeVehicle(data.vehicle, true, false, 0)
        end
        local playerNames = table.concat(vehiclesToExplode, ", ", function(data) return data.playerName end)
        TriggerEvent("chatMessage", "^1[Server]", {255, 0, 0}, "All vehicles have exploded!")
        print(string.format("All vehicles have exploded triggered by players: %s", playerNames))
        vehiclesToExplode = {}  -- Clear the table after exploding all vehicles
    else
        TriggerEvent("chatMessage", "^1[Server]", {255, 0, 0}, "No vehicles added for explosion.")
    end
end, false)
