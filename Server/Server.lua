-- {Default Var For ESX} --
if Config.FrameWork == "NewESX" then 
    FW = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == "OldESX" then 
    FW = nil 
    TriggerEvent('esx:getSharedObject', function(obj) FW = obj end)
else
    print("^7[^3NvX_Admin^7 - ^1Server Side^7] Only Framework Avaible Is ESX (Legacy Or Not) Any Different Framework Is Not Supported")
end

-- {Permission List For Staffer} --
FW.RegisterServerCallback('NvX_Admin:CheckGroupPlayer', function(source, cb)
    local xPlayer = FW.GetPlayerFromId(source)

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
        print("^7[^3NvX_Admin^7] - Regeneration Of File NvX_Bans.json")
        Citizen.Wait(5000)
        print()
        print("^7[^3NvX_Admin^7] - File NvX_Bans.json Regenerated Correctly")
    else
        local Table = json.decode(File)

        if not Table then 
            SaveResourceFile(GetCurrentResourceName(), "NvX_Bans.json", "[]", -1)
            Table = {}

            print()
            print("^7[^3NvX_Admin^7] - NvX_Bans.json Is Corrupted...")
            print()
            print("^7[^3NvX_Admin^7] - Server Shutting Down In 3 Seconds...")
            Citizen.Wait(3000)
            os.exit()
        end
    end
end

if(GetCurrentResourceName() == "NvX_Admin") then 
    NvX_CheckJson()

    if Config.PrintsConsole then 
        print('^8~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        print("^7[^3NvX_Admin^7] - For Correctly Work")
        print("^7[^3NvX_Admin^7] - Check If esx_menu_default & esx_menu_dialog Is Started")
        print("^7[^3NvX_Admin^7] - Enjoy With Admin Menu")
        print('^8~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    end
else
    print("^7[^3NvX_Admin^7] - For Starting This Script, Rename It In Originale Name; NvX_Admin")
end