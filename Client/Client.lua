-- {Default Var For ESX} --
if Config.FrameWork == "NewESX" then 
    ESX = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == "OldESX" then 
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    if Config.PrintsConsole then 
        print("^7[^3NvX_Admin^7 - ^4Client Side^7] Only Framework Avaible Is ESX (Legacy Or Not) Any Different Framework Is Not Supported")
    end
end

-- {Open Menù Staff With KeyBind} -- 
RegisterKeyMapping('_NvX_Admin_OpenStaffMenu', 'Open Menù STAFF', 'KEYBOARD', Config.OpenKey)
RegisterCommand('_NvX_Admin_OpenStaffMenu', function()
    FW.TriggerServerCallback('NvX_Admin:CheckGroupPlayer', function(group)
        if group ~= nil and(group == 'owner') then 
        elseif group ~= nil and(group == 'admin') then 
        elseif group ~= nil and(group == 'mod') then 
        elseif group ~= nil and(group == 'helper') then 
        else
            FW.ShowNotification('')
        end
    end)
end)