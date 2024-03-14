-- {Default Var For ESX} --
if Config.FrameWork == "NewESX" then 
    ESX = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == "OldESX" then 
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    print("^7[^3NvX_Admin^7 - ^4Client Side^7] Only Framework Avaible Is ESX (Legacy Or Not) Any Different Framework Is Not Supported")
end