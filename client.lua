local showBlips = false
local playerBlips = {}

RegisterNetEvent('nkhd_staff:wrongclass')
AddEventHandler('nkhd_staff:wrongclass', function()
    ESX.ShowNotification(_U('wrong_class'), 1000, 'error')
end)

RegisterNetEvent('nkhd_staff:toggleBlips')
AddEventHandler('nkhd_staff:toggleBlips', function(source)
    showBlips = not showBlips
    if showBlips then
        if Config.IngameNotification == 'ESX' then
            ESX.ShowNotification(_U('blips_on_esx'), 1000, 'success')
        elseif Config.IngameNotification == 'Normal' then
            ShowNotification(_U('blips_on'))
        elseif Config.IngameNotification == 'Advanced' then
            ESX.ShowAdvancedNotification('~r~Admin System', '~b~Blips', _U('blips_on'), 'CHAR_NKHD_ADMIN', 1)
        end
        showAllPlayerBlips()
        if Discord.Enable then 
            local playerId = PlayerId()
            local message = _U('playerid') .. GetPlayerServerId(playerId) .. " " ..  _U('webhook_blips_on')
            TriggerServerEvent('nkhd_blips:sendWebhook', message)
        end
    else
        if Config.IngameNotification == 'ESX' then
            ESX.ShowNotification(_U('blips_off_esx'), 1000, 'success')
        elseif Config.IngameNotification == 'Normal' then
            ShowNotification(_U('blips_off'))
        elseif Config.IngameNotification == 'Advanced' then
            ESX.ShowAdvancedNotification('~r~Admin System', '~b~Blips', _U('blips_off'), 'CHAR_NKHD_ADMIN', 1)
        end
        removeAllPlayerBlips()
        if Discord.Enable then 
            local playerId = PlayerId()
            local message = _U('playerid') .. GetPlayerServerId(playerId) .. " " ..  _U('webhook_blips_off')
            TriggerServerEvent('nkhd_blips:sendWebhook', message)
        end
    end
end)

function showAllPlayerBlips()
    Citizen.CreateThread(function()
        while showBlips do
            ESX.TriggerServerCallback('esx_blips:getPlayerInfo', function(playerInfo)
                local playerId = PlayerId()
                local serverId = GetPlayerServerId(playerId)
                for id, info in pairs(playerInfo) do
                    if id ~= serverId then
                        if not playerBlips[id] then
                            local blip = AddBlipForCoord(info.coords.x, info.coords.y, info.coords.z)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipScale(blip, 0.85)
                            SetBlipColour(blip, 0)
                            SetBlipAsShortRange(blip, false)

                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(info.name)
                            EndTextCommandSetBlipName(blip)

                            playerBlips[id] = blip
                        else
                            local blip = playerBlips[id]
                            SetBlipCoords(blip, info.coords.x, info.coords.y, info.coords.z)
                            SetBlipRotation(blip, math.floor(info.heading))
                        end
                    end
                end
            end)
            Citizen.Wait(Config.BlipsRefreshTime)
        end
        removeAllPlayerBlips()
    end)
end

function removeAllPlayerBlips()
    for id, blip in pairs(playerBlips) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
    playerBlips = {}
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end