RegisterServerEvent("fd-duty:onDuty")
AddEventHandler("fd-duty:onDuty", function(department)
    local source = source
    local discord = ExtractIdentifiers(source).discord:gsub("discord:", "")
    local currentTime = os.time() / 60

    if OnDuty[source] then
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You are already on duty as a " .. OnDuty[source])
        return
    end

    if Config.departments[department] then
        if IsPlayerAceAllowed(source, Config.departments[department]) then
            local insertResult = MySQL.Sync.insert("INSERT INTO onduty (discord, department, callsign, start_time) VALUES (@discord, @department, @callsign, @startTime)", {
                ['@discord'] = discord,
                ['@department'] = department,
                ['@callsign'] = "", 
                ['@startTime'] = currentTime
            })

            if insertResult then
                OnDuty[source] = department
                TriggerClientEvent("fd-duty:SetOnDuty", source, true)
                TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 255, 255}, "You are now on duty as a " .. department)
            else
                TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Failed to go on duty. Please try again.")
            end
        else
            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You don't have permission to go on duty as a " .. department)
        end
    else
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Invalid department")
    end
end)

RegisterServerEvent("fd-duty:offDuty")
AddEventHandler("fd-duty:offDuty", function(department)
    local source = source
    local discord = ExtractIdentifiers(source).discord:gsub("discord:", "")
    local currentTime = os.time() / 60 -- Convert to minutes

    if not OnDuty[source] then
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You are not currently on duty")
        return
    end

    if OnDuty[source] ~= department then
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You are on duty as a " .. OnDuty[source] .. ". Use /ofduty " .. OnDuty[source] .. " to go off duty")
        return
    end

    local insertResult = MySQL.Sync.insert("INSERT INTO dutylogs (discord, department, callsign, time) VALUES (@discord, @department, @callsign, @dutyTime)", {
        ['@discord'] = discord,
        ['@department'] = department,
        ['@callsign'] = "",
        ['@dutyTime'] = currentTime
    })

    if insertResult then
        OnDuty[source] = nil
        TriggerClientEvent("fd-duty:SetOnDuty", source, false)
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 255, 255}, "You are now off duty")
    else
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Failed to log duty. Please try again.")
    end
end)

exports("GetOnDutyPlayers", function()
    return OnDuty
end)

function ExtractIdentifiers(src)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        license = "",
        xbl = "",
        live = ""
    }
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)
        if string.find(id, "steam") then
            identifiers.steam = id
        elseif string.find(id, "ip") then
            identifiers.ip = id
        elseif string.find(id, "discord") then
            identifiers.discord = id
        elseif string.find(id, "license") then
            identifiers.license = id
        elseif string.find(id, "xbl") then
            identifiers.xbl = id
        elseif string.find(id, "live") then
            identifiers.live = id
        end
    end
    return identifiers
end

