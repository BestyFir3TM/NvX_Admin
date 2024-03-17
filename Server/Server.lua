-- {Default Var For ESX} --
if Config.FrameWork == "NewESX" then 
    ESX = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == "OldESX" then 
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    print("^7[^3NvX_Admin^7 - ^1Server Side^7] Only Framework Avaible Is ESX (Legacy Or Not) Any Different Framework Is Not Supported")
    print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
end

-- {Permission List For Staffer} --
ESX.RegisterServerCallback('NvX_Admin:CheckGroupPlayer', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer ~= nil then 
        local Group = xPlayer.getGroup()

        if Group ~= nil then 
            cb(Group)
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)

-- {Check Resource Name With Check Json File, If Missing Is Creating That} -- 
function NvX_CheckJson()
    local File = LoadResourceFile(GetCurrentResourceName(), "NvX_Bans.json") 

    if not File or File == "" then 
        SaveResourceFile(GetCurrentResourceName(), "NvX_Bans.json", "[]", -1)

        print()
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        print("^7[^3NvX_Admin^7] - Regeneration Of File NvX_Bans.json")
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        Citizen.Wait(5000)
        print()
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        print("^7[^3NvX_Admin^7] - File NvX_Bans.json Regenerated Correctly")
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    else
        local Table = json.decode(File)

        if not Table then 
            SaveResourceFile(GetCurrentResourceName(), "NvX_Bans.json", "[]", -1)
            Table = {}

            print()
            print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
            print("^7[^3NvX_Admin^7] - NvX_Bans.json Is Corrupted...")
            print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
            print()
            print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
            print("^7[^3NvX_Admin^7] - Server Shutting Down In 3 Seconds...")
            print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
            Citizen.Wait(3000)
            os.exit()
        end
    end
end

if(GetCurrentResourceName() == "NvX_Admin") then 
    NvX_CheckJson()

    if Config.PrintsConsole then 
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        print("^7[^3NvX_Admin^7] - For Correctly Work")
        print("^7[^3NvX_Admin^7] - Check If esx_menu_default & esx_menu_dialog Is Started")
        print("^7[^3NvX_Admin^7] - Enjoy With Admin Menu")
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    end
else
    print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    print("^7[^3NvX_Admin^7] - For Starting This Script, Rename It In Originale Name; NvX_Admin")
    print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
end

-- {NoClip Command} -- 
RegisterCommand('NvX_Admin_NoClipV2', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local GroupPlayer = xPlayer.getGroup()

    if GroupPlayer ~= nil and (GroupPlayer == 'owner' or GroupPlayer == 'admin' or GroupPlayer == 'mod' or GroupPlayer == 'helper') then 
        TriggerClientEvent("NvX_Admin:NoClip", source)
    else 
        TriggerClientEvent('esx:showNotification', source, Config.LanguageSyS["NotHavePermission"])
    end
end)

-- {Get List Of Players} -- 
NvX_sPairs = function(t, order)
    local keys = {}

    for k in pairs(t) do 
        keys[#keys + 1] = k 
    end

    if order then 
        table.sort(keys, function(a, b) 
            return order(t, a, b)
        end)
    else
        table.sort(keys)
    end

    local i = 0 

    return function() 
        i = i + 1

        if keys[i] then 
            return keys[i], t[keys[i]]
        end
    end
end

ESX.RegisterServerCallback('NvX_Admin:GetPlayersList', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer then 
        local elements = {}

        for k, v in NvX_sPairs(GetPlayers()) do 
            local name = GetPlayerName(v)

            if name ~= nil then 
                table.insert(elements, {label = "Name: "..name.." ID: "..v, value = v})
            end
        end

        cb(elements)
    end
end)

-- {Command For Check Player} --
RegisterCommand('NvX_Admin_CheckPlayer', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local GroupPlayer = xPlayer.getGroup()

    if GroupPlayer ~= nil and (GroupPlayer == 'owner' or GroupPlayer == 'admin' or GroupPlayer == 'mod' or GroupPlayer == 'helper') then
        local playerId = args[1]
        local NamePlayer = GetPlayerName(playerId)
        local Check = 'Name: '..NamePlayer..'\nHealth: '..GetEntityHealth(GetPlayerPed(playerId)..'/'..GetEntityMaxHealth(GetPlayerPed(playerId))..'\nArmor: '..GetPLayerArmour(GetPlayerPed(playerId)..'/'..GetPlayerMaxArmour(playerId))) 
    
        TriggerClientEvent('esx:showNotification', source, ''..Check..'')
    else
        TriggerClientEvent('esx:showNotification', source, Config.LanguageSyS.NotHavePermission)
    end
end)

-- {Command For Screenshot Player} --
RegisterCommand('NvX_Admin_ScreenshotPlayer', function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local GroupPlayer = xPlayer.getGroup()

    if GroupPlayer ~= nil and (GroupPlayer == 'owner' or GroupPlayer == 'admin' or GroupPlayer == 'mod' or GroupPlayer == 'helper') then
        local ID = tonumber(args[1])

        TriggerEvent('NvX_Admin:GetIdentifiers', source, ID)

        TriggerClientEvent('NvX_Admin:TakeScreen', ID)

        TriggerClientEvent('esx:showNotification', source, Config.LanguageSyS.AdministrationSection.SubMenuListPlayerManage_ScreenshotDone)
    else
        TriggerClientEvent('esx:showNotification', source, Config.LanguageSyS.NotHavePermission)
    end
end)

RegisterServerEvent('NvX_Admin:GetIdentifiers')
AddEventHandler('NvX_Admin:GetIdentifiers', function(source, ID)
    local src = source 

    -- Staff Details 
    local s_steam = 'N/A'
    local s_discord = 'N/A'
    local s_license = 'N/A'
    local s_live = 'N/A'
    local s_xbl = 'N/A'
    local s_ip = 'N/A'
    local s_name = GetPlayerName(src)

    for m, n in ipairs(GetPlayerIdentifiers(src)) do 
        if n:match("steam") then
            s_steam = n
    
        elseif n:match("discord") then
            s_discord = n:gsub("discord:","")
    
        elseif n:match("license") then 
            s_license = n
    
        elseif n:match("live") then
            s_live = n
    
        elseif n:match("xbl") then 
            s_xbl = n 
    
        elseif n:match("ip") then
            s_ip = n:gsub("ip:","")
        end
    end

    -- Player Details
    local p_steam = 'N/A'
    local p_discord = 'N/A'
    local p_license = 'N/A'
    local p_live = 'N/A'
    local p_xbl = 'N/A'
    local p_ip = 'N/A'
    local p_name = GetPlayerName(ID)

    for m, n in ipairs(GetPlayerIdentifiers(src)) do 
        if n:match("steam") then
            p_steam = n
    
        elseif n:match("discord") then
            p_discord = n:gsub("discord:","")
    
        elseif n:match("license") then 
            p_license = n
    
        elseif n:match("live") then
            p_live = n
    
        elseif n:match("xbl") then 
            p_xbl = n 
    
        elseif n:match("ip") then
            p_ip = n:gsub("ip:","")
        end
    end

    PerformHttpRequest(Config_Logs.Screenshot, function() 
    end, "POST", json.encode({
        embeds = {{
            author = {
                name = "NvX_Admin - Screenshot Requested", 
                icon_url = "https://imgur.com/cHP8iwN.png",
            }, 

            title = "NvX_Admin - Admin Menù",
            description = "**[Staffer Details]** \n**``ID Staffer:``**`` "..src.." ``\n**``Name Staffer:``**`` "..s_name.." ``\n**``Steam Hex:``**`` "..s_steam.." ``\n**``License:``**`` "..s_license.." ``\n**``Discord ID:``**``"..s_discord.." ``\n**``Live:``**``"..s_live.." ``\n**``Xbox ID:``**``"..s_xbl.." ``\n**``IP:``**``"..s_ip.." ``\n\n**[Player Details]** \n**``ID Player:``**`` "..ID.." ``\n**``Name Player:``**`` "..p_name.." ``\n**``Steam Hex:``**`` "..p_steam.." ``\n**``License:``**`` "..p_license.." ``\n**``Discord ID:``**`` "..p_discord.." ``\n**``Live ID:``**`` "..p_live.." ``\n**``Xbox ID:``**`` "..p_xbl.." ``\n**``IP:``**`` "..p_ip.."`` \n\n**The Staffer** ``"..s_name.."`` \nHas Requested Screenshot Of Player ``"..p_name.."``", 
            color = 179870,
            footer = {
                text = 'NvX_Admin - Admin Menù Of Novix Development',
                icon_url = "https://imgur.com/cHP8iwN.png",
            }
        }}
    }), {
        ["Content-Type"] = "application/json"
    })
end)

RegisterServerEvent('NvX_Admin:Screenshot')
AddEventHandler('NvX_Admin:Screenshot', function(upload)
    NvX_LogDiscord(upload)
end)

function NvX_LogDiscord(image)
    if Config_Logs.Screenshot == nil or Config_Logs.Screenshot == '' then 
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        print("^7[^3NvX_Admin^7 - ^1Server Side^7] Webhook Missing In Config_Logs (Screenshot), Set Webhook For Screenshot Work Correctly")
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    else
        PerformHttpRequest(Config_Logs.Screenshot, function()
        end, "POST", json.encode({
            embeds = {{
                author = {
                    name = "",
                    icon_url = "https://imgur.com/cHP8iwN.png",
                },

                title = "**``Screenshot Requested``**",
                description = "",
                color = 179870,
                image = {
                    url = image
                },
                footer = {
                    text = 'NvX_Admin - Admin Menù Of Novix Development',
                    icon_url = "https://imgur.com/cHP8iwN.png",
                }
            }}
        }), {
            ["Content-Type"] = "application/json"
        })
    end
end