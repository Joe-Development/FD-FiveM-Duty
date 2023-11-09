RegisterServerEvent("fd-duty:onDuty")
AddEventHandler("fd-duty:onDuty", function(department, callsign)
    local source = source
    if Config.departments[department] then
        if IsPlayerAceAllowed(source, Config.departments[department]) then

            -- Timer Function will go here

            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 255, 255}, "You are now on duty as a " .. department .. " with callsign " .. callsign)
        else
            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You don't have permission to go on duty as a " .. department)
        end
    else
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Invalid department")
    end
end)
