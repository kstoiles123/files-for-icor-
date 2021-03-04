CallManagerClient = {}
Tunnel.bindInterface("CallManager",CallManagerClient)
Proxy.addInterface("CallManager",CallManagerClient)
CallManagerServer = Tunnel.getInterface("CallManager","CallManager")
vRP = Proxy.getInterface("vRP")

local adminCalls = {}
local nhsCalls = {}
local pdCalls = {}

local savedCoords = nil
local takenticket = false

local isPlayerNHS = false
local isPlayerPD = false

RMenu.Add('callmanager', 'main', RageUI.CreateMenu("Call Manager", '~b~Call Manager', 1300, 0))
RMenu.Add("callmanager", "admin", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 0)))
RMenu.Add("callmanager", "police", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 0)))
RMenu.Add("callmanager", "nhs", RageUI.CreateSubMenu(RMenu:Get("callmanager", "main",  1300, 0)))
RMenu:Get('callmanager', 'main')

RageUI.CreateWhile(1.0, RMenu:Get('callmanager', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('callmanager', 'main'), true, false, true, function()  

        if isPlayerAdmin then
            RageUI.Button("Admin", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'admin'))
        end

        if isPlayerNHS then 
            RageUI.Button("PD", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'police'))
        end

        if isPlayerPD then
            RageUI.Button("NHS", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if (Hovered) then

                end
                if (Active) then

                end
                if (Selected) then

                end
            end, RMenu:Get('callmanager', 'nhs'))
        end

    end)
end)


RageUI.CreateWhile(1.0, RMenu:Get('callmanager', 'admin'), nil, function()
    RageUI.IsVisible(RMenu:Get('callmanager', 'admin'), true, false, true, function()  
        if adminCalls ~= nil then
            for k,v in pairs(adminCalls) do
                RageUI.Button(string.format("[%s] %s", v[2], v[1]), "Reason: " .. v[3], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if v[2] == GetPlayerServerId(PlayerId()) then
                            notify("~r~You can't take your own Ticket!")
                        else
                            savedCoords = GetEntityCoords(PlayerPedId())
                            CallManagerServer.GetUpdatedCoords({v[2]}, function(targetCoords)
                                SetEntityCoords(PlayerPedId(), targetCoords)
                            end)
                            TriggerServerEvent('Take:Ticket')
                            TriggerEvent('staffOn:true')
                            takenticket = true
                            CallManagerServer.RemoveTicket({k, "admin"})
                        end
                    end
                end, RMenu:Get('callmanager', 'admin'))
            end
        end
    end)
end)

RageUI.CreateWhile(1.0, RMenu:Get('callmanager', 'police'), nil, function()
    RageUI.IsVisible(RMenu:Get('callmanager', 'police'), true, false, true, function()  
        if pdCalls ~= nil then
            for k,v in pairs(pdCalls) do
                RageUI.Button(string.format("%s", v[1]), "Reason: " .. v[3], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if v[2] == GetPlayerServerId(PlayerId()) then
                            notify("~r~You can't take your own Call!")
                        else
                            CallManagerServer.RemoveTicket({k, "pd"})
                            CallManagerServer.GetUpdatedCoords({v[2]}, function(targetCoords)
                                SetNewWaypoint(targetCoords.x, targetCoords.y)
                            end)
                        end
                    end
                end, RMenu:Get('callmanager', 'police'))
            end
        end
    end)
end)

RageUI.CreateWhile(1.0, RMenu:Get('callmanager', 'nhs'), nil, function()
    RageUI.IsVisible(RMenu:Get('callmanager', 'nhs'), true, false, true, function()  
        if nhsCalls ~= nil then
            for k,v in pairs(nhsCalls) do
                RageUI.Button(string.format("%s", v[1]), "Reason: " .. v[3], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        if v[2] == GetPlayerServerId(PlayerId()) then
                            notify("~r~You can't take your own Call!")
                        else
                            CallManagerServer.RemoveTicket({k, "nhs"})
                            CallManagerServer.GetUpdatedCoords({v[2]}, function(targetCoords)
                                SetNewWaypoint(targetCoords.x, targetCoords.y)
                            end)
                        end
                    end
                end, RMenu:Get('callmanager', 'nhs'))
            end
        end
    end)
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)
        if IsControlJustPressed(1, cfg.Key) then
            CallManagerServer.GetPermissions({}, function(admin)
                isPlayerAdmin = admin;

                if GetResourceKvpInt("Police_ClockedOn") == 2 then
                    isPlayerPD = true;
                end
                if GetResourceKvpInt("nhs_ClockedOn") == 2 then
                    isPlayerNHS = true;
                end
            end)

            CallManagerServer.GetTickets()
            RageUI.Visible(RMenu:Get('callmanager', 'main'), not RageUI.Visible(RMenu:Get('callmanager', 'main')))
        end
    end
end)

RegisterNetEvent('CallManager:Table')
AddEventHandler('CallManager:Table', function(call, call2, call3)
    adminCalls = call
    nhsCalls = call2
    pdCalls = call3
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification( false, false)
end

RegisterCommand("return", function()
    if takenticket then
        if savedCoords == nil then return notify("~r~Couldn't get Last Position") end
        SetEntityCoords(PlayerPedId(), savedCoords)
        notify("~g~Returned.")
        takenticket = false
        TriggerEvent('staffOn:false')
    end
 end)

RegisterNetEvent('Cyber:NotifyAdmin')
AddEventHandler('Cyber:NotifyAdmin', function()
    if isPlayerAdmin then
        notify('~b~Admin ticket Received ')
    end
end)