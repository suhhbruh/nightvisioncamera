Config = {}

-- Night vision items configuration
Config.NightVisionItems = {
    ["night_vision_camera"] = {
        messageOn = "Standard night vision enabled.",
        messageOff = "Standard night vision disabled.",
        mode = "night",
        filter = nil
    },
    ["advanced_night_vision_camera"] = {
        messageOn = "Advanced night vision enabled.",
        messageOff = "Advanced night vision disabled.",
        mode = "thermal",
        filter = "OrbitalCannon" -- Example filter name for thermal vision
    }
}

-- Keybind for toggling night vision
Config.ToggleKey = "F7"

-- Message display settings
Config.Messages = {
    NoNightvision = "You don't have any night vision cameras.",
    NotInVehicle = "You need to be in a vehicle to use night vision cameras."
}
