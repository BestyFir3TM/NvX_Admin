Config = {
    PrintsConsole = true,
    CheckVersion = true, -- Active This If You Activate A Check Of Version
    FrameWork = "NewESX", -- Write: NewESX If Use ESX Legacy | Write: OldESX If Use Old ESX Version

    LanguageSyS = "IT", -- Avaible Language (EN, IT)

    ListPermission = {
        "owner",
        "admin",
        "mod",
        "helper"
    },

    OpenKey = 'HOME', -- Default Key For Open Menu (Configurable In Keybind In Game) 
    NameKey = 'PAGEUP', -- Default Key For Activate Name Players (Configurable In Keybind In Game) 
    NoClipKey = 'F9' -- Default Key For Activate NoClip (Configurable In Keybind In Game)
}

LanguageSyS = {
    ["IT"] = {
        ["NotHavePermission"] = "Non Hai Il Permesso",
        ["SeeNameTags_Active"] = "Nomi Giocatori Attivato",
        ["SeeNameTags_Deactive"] = "Nomi Giocatori Disattivato"
    },

    ["EN"] = {
        ["NotHavePermission"] = "You Not Have Permission",
        ["SeeNameTags_Active"] = "NameTags Activated",
        ["SeeNameTags_Deactive"] = "NameTags Deactivated"
    }
}