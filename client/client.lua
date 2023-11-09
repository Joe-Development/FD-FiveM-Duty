local OnDuty = false

RegisterCommand("duty", function(source, args)
    local department = tostring(args[1])
    local callsign = table.concat(args[2], "")

    TriggerServerEvent("fd-duty:onDuty", department, callsign)
end, false)

RegisterCommand("offduty", function(source, args)
    local department = tostring(args[1])
    TriggerServerEvent("fd-duty:offDuty", department)
end, false)

RegisterNetEvent("fd-duty:SetOnDuty")
AddEventHandler("fd-duty:SetOnDuty", function(isOnDuty)
    OnDuty = isOnDuty
end)

exports("IsPlayerOnDuty", function()
    return OnDuty
end)