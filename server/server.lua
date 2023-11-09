RegisterServerEvent("fd-duty:onDuty")
AddEventHandler("fd-duty:onDuty", function(department)
    local source = source
    local discord = ExtractIdentifiers(source).discord:gsub("discord:", "")
    local currentTime = os.time() / 60

    local result = MySQL.Sync.fetchScalar("SELECT start_time FROM onduty WHERE discord = @discord AND department = @department ORDER BY start_time DESC LIMIT 1", {
        ['@discord'] = discord,
        ['@department'] = department
    })

    if result then
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "You are already on duty as a " .. department)
    else
        if Config.departments[department] then
            if IsPlayerAceAllowed(source, Config.departments[department]) then
                local insertResult = MySQL.Sync.insert("INSERT INTO onduty (discord, department, callsign, start_time) VALUES (@discord, @department, @callsign, @startTime)", {
                    ['@discord'] = discord,
                    ['@department'] = department,
                    ['@callsign'] = "", 
                    ['@startTime'] = currentTime
                })

                if insertResult then
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
    end
end)

RegisterServerEvent("fd-duty:offDuty")
AddEventHandler("fd-duty:offDuty", function(department)
    local source = source
    local discord = ExtractIdentifiers(source).discord:gsub("discord:", "")
    local currentTime = os.time() / 60 

    local result = MySQL.Sync.fetchScalar("SELECT start_time FROM onduty WHERE discord = @discord AND department = @department ORDER BY start_time DESC LIMIT 1", {
        ['@discord'] = discord,
        ['@department'] = department
    })

    if result then
        local startTime = tonumber(result)
        local dutyTime = currentTime - startTime

        local insertResult = MySQL.Sync.insert("INSERT INTO dutylogs (discord, department, callsign, time) VALUES (@discord, @department, @callsign, @dutyTime)", {
            ['@discord'] = discord,
            ['@department'] = department,
            ['@callsign'] = "", 
            ['@dutyTime'] = dutyTime
        })

        if insertResult then
            local webhookUrl = Config.webhooks[department] -- Replace with your webhook URL
            local message = {
                ["username"] = "Duty Log",
                ["content"] = "<@" .. discord .. "> has gone off duty.",
                ["embeds"] = {{
                    ["title"] = "Duty Log",
                    ["description"] = "Department: " .. department .. "\nTime: " .. dutyTime .. " minutes",
                    ["color"] = 16711680 -- Red color
                }}
            }

            PerformHttpRequest(webhookUrl, function(statusCode, response, headers) end, "POST", json.encode(message), {["Content-Type"] = "application/json"})

            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 255, 255}, "You are now off duty")
        else
            TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "Failed to log duty. Please try again.")
        end
    else
        TriggerClientEvent("chatMessage", source, "SYSTEM", {255, 0, 0}, "No on-duty record found for your department")
    end
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

