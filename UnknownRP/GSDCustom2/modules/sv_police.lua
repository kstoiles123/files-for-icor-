RegisterServerEvent('Cyber:CheckForPerm')
AddEventHandler('Cyber:CheckForPerm', function()
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, "police"}) then
        TriggerClientEvent('Cyber:AllowPD', source)
    end
end)

RegisterServerEvent('Cyber:placeSpike')
AddEventHandler('Cyber:placeSpike', function(netid, coords)
    TriggerClientEvent('Cyber:addSpike', -1, netid, coords)
end)

RegisterServerEvent('Cyber:removeSpike')
AddEventHandler('Cyber:removeSpike', function(netid)
    TriggerClientEvent('Cyber:deleteSpike', -1, netid)
end)

RegisterServerEvent('Cyber:Police48')
AddEventHandler('Cyber:Police48', function(hash)
    local source = source
    TriggerClientEvent('GiveWepHash', source, hash)
end)

RegisterServerEvent('Finished:PD')
AddEventHandler('Finished:PD', function(paycheck)
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasGroup({user_id, "police"}) then
        vRP.giveMoney({userid, tonumber(paycheck)})
    end
end)