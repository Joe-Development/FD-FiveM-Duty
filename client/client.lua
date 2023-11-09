RegisterCommand("duty", function(source, args)
    local department = args[1]
    local callsign = args[2]

    TriggerServerEvent("fd-duty:onDuty", department, callsign)
end)

RegisterCommand("offduty", function(source, args)
    local department = args[1]
    TriggerServerEvent("fd-duty:offDuty", department)
end)
