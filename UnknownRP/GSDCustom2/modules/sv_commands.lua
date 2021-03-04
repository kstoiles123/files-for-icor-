Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")

RegisterCommand("ooc", function(source, args, raw)
    if #args <= 0 then return end
    local message = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "^7^*OOC ^7^r | " .. GetPlayerName(source) .." : " , { 128, 128, 128 }, message, "ooc")
end)

RegisterCommand("getmyid", function(source)
	TriggerClientEvent('chatMessage', source, "[Server]", {255, 51, 51}, " PermID: " .. vRP.getUserId({source}))
end)

RegisterCommand("getmytempid", function(source)
	TriggerClientEvent('chatMessage', source, "[Server]", {255, 51, 51}, " Your TempID: " .. source)
end)