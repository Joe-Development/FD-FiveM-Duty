Config = {}

Config.departments = {
    ["SAST"] = "sast.duty", -- I would suggest it being a abbreivation like SAST or FBI
    ["FBI"] = "fbi.duty",
}

-- The webhooks must only be created for departments above, and there can only be one webhook per department
Config.webhooks = {
    ["police"] = "https://discord.com/api/webhooks/your-webhook-url",
    ["ems"] = "https://discord.com/api/webhooks/your-webhook-url",
}

return Config
