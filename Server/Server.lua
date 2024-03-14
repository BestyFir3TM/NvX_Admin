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