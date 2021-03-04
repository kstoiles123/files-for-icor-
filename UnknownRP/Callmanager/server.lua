Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP")

CallManagerServer = {}
Tunnel.bindInterface("CallManager",CallManagerServer)
Proxy.addInterface("CallManager",CallManagerServer)
CallManagerClient = Tunnel.getInterface("CallManager", "CallManager")

MySQL = module("vrp_mysql", "MySQL")

MySQL.createCommand("vRP/get_ticket_count","SELECT * FROM vrp_tickets WHERE user_id = @uid")
MySQL.createCommand("vRP/ticket_newplayer","INSERT INTO `vrp_tickets`(`user_id`, `ticket`) VALUES (@userid, 1)")
MySQL.createCommand("vRP/update_player_ticket", "UPDATE `vrp_tickets` SET `ticket`= @newticketcount WHERE user_id = @uid")

adminTickets = {}
nhsCalls = {}
pdCalls = {}

function CallManagerServer.GetTickets()
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
end

function CallManagerServer.GetPermissions()
    adminPerm = false
    nhsPerm = false
    pdPerm = false
    local source = source
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, cfg.AdminPerm}) then
        adminPerm = true;
    end
    return adminPerm
end

RegisterNetEvent('Take:Ticket')
AddEventHandler('Take:Ticket', function()
    local source = source
    local user_id = vRP.getUserId({source})
    MySQL.query("vRP/get_ticket_count", {uid = user_id}, function(Rows)
        vRP.giveBankMoney({user_id, 4000})
        if #Rows < 1 then
            MySQL.execute("vRP/ticket_newplayer", {userid = user_id})
        else
            MySQL.execute("vRP/update_player_ticket", {uid = user_id, newticketcount = Rows[1].ticket + 1})
        end
    end)
end)

function CallManagerServer.RemoveTicket(index, Type)
    if Type == "admin" then
        adminTickets[index] = nil
    elseif Type == "nhs" then
        nhsCalls[index] = nil
    else
        pdCalls[index] = nil
    end
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
end

RegisterCommand("calladmin", function(source, args, rawCommand)
    vRP.prompt({source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        local index = #adminTickets + 1
        adminTickets[index] = {GetPlayerName(source), source, Reason}
        TriggerClientEvent('Cyber:NotifyAdmin', -1)
        TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
    end})
end)

RegisterCommand("911", function(source, args, rawCommand)
    vRP.prompt({source, "Reason:", "", function(player, Reason)
        if Reason == "" then return end
        local index = #pdCalls + 1
        pdCalls[index] = {GetPlayerName(source), source, Reason}
        TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
    end})
end)

RegisterNetEvent('CallManager:AddNHSCalls')
AddEventHandler('CallManager:AddNHSCalls', function(Reason)
    local source = source
    local index = #nhsCalls + 1
    nhsCalls[index] = {GetPlayerName(source), source, Reason}
    TriggerClientEvent('CallManager:Table', -1, adminTickets, nhsCalls, pdCalls)
end)

function CallManagerServer.GetUpdatedCoords(target)
    local source = source
    local target = target
    return GetEntityCoords(GetPlayerPed(tonumber(target)))
end