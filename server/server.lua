RegisterServerEvent("fd-duty:onDuty")
AddEventHandler("fd-duty:onDuty", function(department, callsign)
    local source = source

    -- Check if the department exists in the configuration
    if Config.departments[department] then
        -- Check if the player has permission for the department
        if IsPlayerAceAllowed(source, Config.departments[department]) then

            -- Timer Function will go here

            -- Notify the player that they are on duty
            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 255, 255}, "You are now on duty as a " .. department .. " with callsign " .. callsign)
        else
            -- Notify the player that they don't have permission for the department
            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You don't have permission to go on duty as a " .. department)
        end
    else
        -- Notify the player that the department doesn't exist
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Invalid department")
    end
end)
