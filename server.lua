ESX = nil

if Config.ESX == 'old' then
     TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
elseif Config.ESX == 'new' then
    ESX = exports["es_extended"]:getSharedObject()
else
    print('Wrong ESX Type!')
end

RegisterCommand(Config.BlipsCommand, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == 'admin' then
        TriggerClientEvent('nkhd_staff:toggleBlips', source)
    else
        TriggerClientEvent('nkhd_staff:wrongclass', source)
    end
end, false)

ESX.RegisterServerCallback('esx_blips:getPlayerInfo', function(source, cb)
    local players = ESX.GetPlayers()
    local playerInfo = {}

    for i = 1, #players do
        local xPlayer = ESX.GetPlayerFromId(players[i])
        if xPlayer then
            local ped = GetPlayerPed(players[i])
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local name = GetPlayerName(players[i])
            playerInfo[players[i]] = {id = players[i], coords = coords, heading = heading, name = name}
        end
    end

    cb(playerInfo)
end)

RegisterNetEvent('nkhd_blips:sendWebhook', function(message)
    local content = {
      {
          ["color"] = Discord.Color,
          ["title"] = "**".. Discord.Title .."**\n",
          ["description"] = message,
          ["footer"] = {
              ["text"] = Discord.Footer,
          },
      }
  }
  
  PerformHttpRequest(Discord.Webhook, function(err, text, headers) end, 'POST', 
  json.encode({
    username = Discord.Name, 
    embeds = content, 
    avatar_url = Discord.Avatar
  }), { ['Content-Type'] = 'application/json' })
end)
