RegisterNetEvent("gcPhone:tchat_receive")
AddEventHandler("gcPhone:tchat_receive", function(message)
  SendNUIMessage({event = 'tchat_receive', message = message})
end)

RegisterNetEvent("gcPhone:tchat_channel")
AddEventHandler("gcPhone:tchat_channel", function(channel, messages)
  SendNUIMessage({event = 'tchat_channel', messages = messages})
end)

RegisterNUICallback('tchat_addMessage', function(data, cb)
  if data.message == '%pos%' then
    local myPos = GetEnetityCoords(PlayerPedId())
    data.message = 'GPS: ' .. math.floor(myPos.x*100)/100 .. ', '  math.floor(myPos.y*100)/100
  end
  if data.message == '%dest%' then
    local wayPointHandler = GetFirstBlipInfoId(8)
    if DoesBlipExist(wayPointHandler) then
      local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, wayPointHandler, Citizen.ResultAsVector())
      data.message = 'GPS: ' .. math.floor(coord.x*100)/100 .. ', '  math.floor(coord.y*100)/100 
    else
      print("error")
    end
  end
  TriggerServerEvent('gcPhone:tchat_addMessage', data.channel, data.message)
end)

RegisterNUICallback('tchat_getChannel', function(data, cb)
  TriggerServerEvent('gcPhone:tchat_channel', data.channel)
end)
