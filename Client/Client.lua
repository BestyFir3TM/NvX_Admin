-- {Default Var For ESX} --
if Config.FrameWork == "NewESX" then 
    ESX = exports['es_extended']:getSharedObject()
elseif Config.FrameWork == "OldESX" then 
    ESX = nil 
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
else
    if Config.PrintsConsole then 
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
        print("^7[^3NvX_Admin^7 - ^4Client Side^7] Only Framework Avaible Is ESX (Legacy Or Not) Any Different Framework Is Not Supported")
        print('^3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^7')
    end
end

-- {Open Menù Staff With KeyBind} -- 
RegisterKeyMapping('NvX_Admin_OpenStaffMenu', 'Open Menù STAFF', 'KEYBOARD', Config.OpenKey)
RegisterCommand('NvX_Admin_OpenStaffMenu', function()
    ESX.TriggerServerCallback('NvX_Admin:CheckGroupPlayer', function(group)
        if group ~= nil and(group == 'owner') then 
            NvX_OwnerMenu()
        elseif group ~= nil and(group == 'admin') then 
            NvX_AdminMenu()
        elseif group ~= nil and(group == 'mod') then 
            NvX_ModMenu()
        elseif group ~= nil and(group == 'helper') then 
            NvX_HelperMenu()
        else
            ESX.ShowNotification(Config.LanguageSyS.NotHavePermission)
        end
    end)
end)

-- {No Clip Keybind} -- 
RegisterKeyMapping('NvX_Admin_NoClip', 'NoClip Staff', 'KEYBOARD', Config.NoClipKey)
RegisterCommand('NvX_Admin_NoClip', function()
    ESX.TriggerServerCallback('NvX_Admin:CheckGroupPlayer', function(group)
        if group ~= nil and (group == 'owner' or group == 'admin' or group == 'mod' or group == 'helper') then 
            ExecuteCommand('NvX_Admin_NoClipV2')
        else
            ESX.ShowNotification(Config.LanguageSyS.NotHavePermission)
        end
    end)
end)

local NoClip = false 
RegisterNetEvent('NvX_Admin:NoClip')
AddEventHandler('NvX_Admin:NoClip', function()
    ESX.TriggerServerCallback('NvX_Admin:CheckGroupPlayer', function(group)
        if group ~= nil and (group == 'owner' or group == 'admin' or group == 'mod' or group == 'helper') then 
            NoClip = not NoClip 
            FreezeEntityPosition(PlayerPedId(), NoClip)
            SetEntityVisible(PlayerPedId(), not NoClip)
            SetPlayerCanUseCover(PlayerId(), not NoClip)

            if NoClip then 
                ESX.ShowNotification(Config.LanguageSyS.NoClipActivated)
            else
                ESX.ShowNotification(Config.LanguageSyS.NoClipDeactivated) 
            end
        else
            ESX.ShowNotification(Config.LanguageSyS.NotHavePermission)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do 
        if NoClip then  
            local yOff = 0.0 
            local zOff = 0.0 

            if IsDisabledControlPressed(0, 32) then 
                yOff = 0.5 
            end

            if IsDisabledControlPressed(0, 33) then 
                yOff = -0.5 
            end

            if IsDisabledControlPressed(0, 34) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())+3)
			end

			if IsDisabledControlPressed(0, 35) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId())-3)
			end

			if IsDisabledControlPressed(0, 85) then
				zOff = 0.2
			end

			if IsDisabledControlPressed(0, 48) then
				zOff = -0.2
			end

            local newPos = nil 

            if IsDisabledControlPressed(0, 21) then 
                newPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, yOff * (10 + 0.3), zOff * (10 + 0.3))
            else
                newPos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, yOff * (5 + 0.3), zOff * (5 + 0.3))
            end

            SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
			SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, false)
			SetEntityHeading(PlayerPedId(), GetGameplayCamRelativeHeading())
			SetEntityCoordsNoOffset(PlayerPedId(), newPos.x, newPos.y, newPos.z, NoClip, NoClip, NoClip)
			Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

-- {NameTags Keybind} --
RegisterKeyMapping('NvX_Admin_NameTags', 'NameTags Staff', 'KEYBOARD', Config.NameKey)
RegisterCommand('NvX_Admin_NameTags', function()
    ESX.TriggerServerCallback('NvX_Admin:CheckGroupPlayer', function(group)
        if group ~= nil and (group == 'owner' or group == 'admin' or group == 'mod' or group == 'helper') then 
            NvX_NameTags()
        else    
            ESX.ShowNotification(Config.LanguageSyS.NotHavePermission)     
        end
    end)
end)

local SeeNames = false 
function NvX_NameTags()
    SeeNames = not SeeNames 

    if SeeNames then 
        SeeNames = true 
        ESX.ShowNotification(Config.LanguageSyS.NameTagsActive)
    else
        SeeNames = false 
        ESX.ShowNotification(Config.LanguageSyS.NameTagsDeactive)
    end

    Citizen.CreateThread(function()
        while true do 
            Citizen.Wait(1)

            for s, ServerPlayers in ipairs(GetActivePlayers()) do 
                local Player = tonumber(ServerPlayers) 

                if GetPlayerPed(Player) ~= PlayerPedId() then 
                    Ped = GetPlayerPed(Player) 

                    NameTagOnPlayer = Citizen.InvokeNative(0xBFEFE3321A3F5015, Ped, "Name: "..GetPlayerName(Player).."\nID: ["..GetPlayerServerId(Player).."]\nHealth: "..GetEntityHealth(Ped), false, false, "", false)
                
                    if SeeNames then 
                        N_0x63bb75abedc1f6a0(NameTagOnPlayer, 9, true)
                    else
                        N_0x63bb75abedc1f6a0(NameTagOnPlayer, 0, false)
                    end

                    if not SeeNames then 
                        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, NameTagOnPlayer, 9, false)
                        Citizen.InvokeNative(0x63BB75ABEDC1F6A0, NameTagOnPlayer, 0, false)

                        RemoveMpGamerTag(idTesta)
                        return
                    end
                end
            end

            if not SeeNames then 
                return 
            end
        end
    end)

    if not SeeNames then 
        return 
    end
end

-- {Owner Menu} --
function NvX_OwnerMenu()
end

-- {Admin Menu} --
function NvX_AdminMenu()
end

-- {Mod Menu} --
function NvX_ModMenu()
end

-- {Helper Menu} --
function NvX_HelperMenu()
end