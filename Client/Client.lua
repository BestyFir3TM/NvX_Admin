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

-- {Screenshot SyS} --
RegisterNetEvent('NvX_Admin:TakeScreen')
AddEventHandler('NvX_Admin:TakeScreen', function()
    ESX.TriggerServerCallback('NvX_Admin:CheckGroupPlayer', function(g)
        if g ~= nil and (g == 'owner' or g == 'admin' or g == 'mod' or g == 'helper') then 
            exports['screenshot-basic']:requestScreenshotUpload("https://novixdevelopment.000webhostapp.com/upload.php", "files[]", function(data)
                local image = json.decode(data)
                local upload = image.files[1].url 
                TriggerServerEvent('NvX_Admin:Screenshot', upload)
            end)
        else 
            ESX.ShowNotification(Config.LanguageSyS.NotHavePermission)
        end
    end)
end)

-- {Owner Menu} --
function NvX_OwnerMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'NvX_Admin_MenuOwner', {
        title = 'NvX_Admin - '..Config.LanguageSyS.Owner_TitleMenu,
        align = Config.MenuAlign,
        elements = {
            {
                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.AdministrationColor..'; span>'  
                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.AdministrationEmoji..' '
                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.Administration..' '
                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.AdministrationEmoji..'</span> <',

                value = 'NvX_Admin-AdministrationSub'
            },

            {
                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.PersonalColor..'; span>'  
                ..Config.LanguageSyS.Menu_Elements.PersonalEmoji..' '
                ..Config.LanguageSyS.Menu_Elements.Personal..' '
                ..Config.LanguageSyS.Menu_Elements.PersonalEmoji..'</span> <',

                value = 'NvX_Admin-PersonalSub'
            },

            {
                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.VehicleColor..'; span>'  
                ..Config.LanguageSyS.Menu_Elements.VehicleEmoji..' '
                ..Config.LanguageSyS.Menu_Elements.Vehicle..' '
                ..Config.LanguageSyS.Menu_Elements.VehicleEmoji..'</span> <',

                value = 'NvX_Admin-VehicleSub'
            },

            {
                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.VarsColor..'; span>'  
                ..Config.LanguageSyS.Menu_Elements.VarsEmoji..' '
                ..Config.LanguageSyS.Menu_Elements.Vars..' '
                ..Config.LanguageSyS.Menu_Elements.VarsEmoji..'</span> <',

                value = 'NvX_Admin-VarsSub'
            },
        }

    }, function(d, m)

        local NvX = d.current.value 

        if NvX == 'NvX_Admin-AdministrationSub' then 
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'NvX_Admin_MenuOwner_Administration', {
                title = 'NvX_Admin - '..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministration,
                align = Config.MenuAlign,
                elements = {
                    {
                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationListPlayerColor..'; span>'  
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationListPlayerEmoji..' '
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationListPlayer..' '
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationListPlayerEmoji..'</span> <',
        
                        value = 'NvX_Admin-AdministrationSub-ListPlayer'
                    },

                    {
                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationSearchByIDColor..'; span>'  
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationSearchByIDEmoji..' '
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationSearchByID..' '
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationSearchByIDEmoji..'</span> <',
        
                        value = 'NvX_Admin-AdministrationSub-SearchByID'
                    },

                    {
                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationBanListColor..'; span>'  
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationBanListEmoji..' '
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationBanList..' '
                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuAdministrationBanListEmoji..'</span> <',
        
                        value = 'NvX_Admin-AdministrationSub-BanList'
                    },
                }

            }, function(d, m)

                local NvX = d.current.value 
                    
                if NvX == 'NvX_Admin-AdministrationSub-ListPlayer' then 
                    ESX.TriggerServerCallback('NvX_Admin:GetPlayersList', function(e)
                        if e ~= nil then 
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'NvX_Admin_MenuOwner_Administration_ListPlayer', {
                                title = 'NvX_Admin - '..Config.LanguageSyS.Menu_Elements.AdministrationSection.ListPlayer,
                                align = Config.MenuAlign,
                                elements = e 
                            }, function(dhome, mhome)

                                if d.current.value ~= nil then 
                                    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'NvX_Admin_MenuOwner_Administration_ListPlayer_Sub', {
                                        title = 'NvX_Admin - '..Config.LanguageSyS.Menu_Elements.AdministrationSection.ListPlayerSub, 
                                        align = Config.MenuAlign,
                                        elements = {
                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManageColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManageEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManageEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Manage'
                                            },

                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerReviveColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerReviveEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerRevive..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerReviveEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Revive'
                                            },

                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerBanColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerBanEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerBan..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerBanEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Ban'
                                            },

                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerTeleportColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerTeleportEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerTeleport..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerTeleportEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Teleport'
                                            },

                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerMutesColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerMutesEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerMutes..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerMutesEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Mutes'
                                            },

                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerGiveColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerGiveEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerGive..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerGiveEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Give'
                                            },

                                            {
                                                label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerSettingsColor..'; span>'  
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerSettingsEmoji..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerSettings..' '
                                                ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerSettingsEmoji..'</span> <',
                                
                                                value = 'NvX_Admin-AdministrationSub-ListPlayer-Settings'
                                            },
                                        }
                                    }, function(d, m)

                                        local NvX = d.current.value 

                                        if NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Manage' then 
                                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'NvX_Admin_MenuOwner_Administration_ListPlayer_Sub_Manage', {
                                                title = Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage,
                                                align = Config.MenuAlign,
                                                elements = {
                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_CheckColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_CheckEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_Check..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_CheckEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Check'
                                                    },

                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_ScreenshotColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_ScreenshotEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_Screenshot..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_ScreenshotEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Screenshot'
                                                    },

                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_OpenInvColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_OpenInvEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_OpenInv..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_OpenInvEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Inv'
                                                    },

                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_SpectColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_SpectEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_Spect..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_SpectEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Spect'
                                                    },

                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_FreezeColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_FreezeEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_Freeze..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_FreezeEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Freeze'
                                                    },

                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_KillColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_KillEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_Kill..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_KillEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Kill'
                                                    },

                                                    {
                                                        label = '> <span style = color:'..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_WipeColor..'; span>'  
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_WipeEmoji..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_Wipe..' '
                                                        ..Config.LanguageSyS.Menu_Elements.AdministrationSection.SubMenuListPlayerManage_WipeEmoji..'</span> <',
                                        
                                                        value = 'NvX_Admin-AdministrationSub-ListPlayer-Wipe'
                                                    },
                                                }
                                            }, function(d, m)
                                            
                                                local NvX = d.current.value 

                                                if NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Check' then 
                                                    local ID = dhome.current.value 
                                                    ExecuteCommand('NvX_Admin_CheckPlayer'..' '..ID)

                                                elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Screenshot' then 
                                                    local ID = dhome.current.value 
                                                    ExecuteCommand('NvX_Admin_ScreenshotPlayer'..' '..ID)

                                                elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Inv' then 

                                                elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Spect' then 

                                                elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Freeze' then 

                                                elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Kill' then 

                                                elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Wipe' then 

                                                end

                                            end, function(d, m) 
                                                m.close()
                                            end)

                                        elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Revive' then 

                                        elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Ban' then 

                                        elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Teleport' then 

                                        elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Mutes' then 

                                        elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Give' then 

                                        elseif NvX == 'NvX_Admin-AdministrationSub-ListPlayer-Settings' then 

                                        end
                                    
                                    end, function(d, m)
                                        m.close()
                                    end)
                                end
                            
                            end, function(dhome, mhome)
                                mhome.close()
                            end)
                        end
                    end)

                elseif NvX == 'NvX_Admin-AdministrationSub-SearchByID' then 

                elseif NvX == 'NvX_Admin-AdministrationSub-BanList' then 

                end
            
            end, function(d, m)
                m.close()
            end)

        elseif NvX == 'NvX_Admin-PersonalSub' then 

        elseif NvX == 'NvX_Admin-VehicleSub' then 

        elseif NvX == 'NvX_Admin-VarsSub' then 

        end
    
    end, function(d, m)
        m.close()
    end)
end

-- {Admin Menu} --
function NvX_AdminMenu()
    ESX.UI.Menu.CloseAll()

end

-- {Mod Menu} --
function NvX_ModMenu()
    ESX.UI.Menu.CloseAll()

end

-- {Helper Menu} --
function NvX_HelperMenu()
    ESX.UI.Menu.CloseAll()

end