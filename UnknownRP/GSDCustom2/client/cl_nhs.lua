vRP = Proxy.getInterface("vRP")

local bodyBag = nil

local attached = false
local notloaded = true
Citizen.CreateThread(function()
    Citizen.Wait(1)
    while notloaded == true do
        local bag_model = "xm_prop_body_bag"
        RequestModel(bag_model)
        while not HasModelLoaded(bag_model) do
            Citizen.Wait(1)
        end
        notloaded = false
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(100)
        local pedEntity =PlayerPedId()
        if IsEntityVisible(pedEntity) then
            local playerPed = PlayerPedId()
            DeleteObject(bodyBag)
            DeleteEntity(bodyBag)
            SetEntityAsMissionEntity(bodyBag, false, false)
            SetEntityVisible(bodybag, false)
            SetModelAsNoLongerNeeded(bodyBag)
            bodyBag = nil
            attached = false
            justBagged = false
        end
    end
end)


RegisterCommand("bodybag", function(source, args, rawCommand)
    local closestPlayer = vRP.getNearestPlayer({2})
    local pedEntity = GetPlayerPed(GetPlayerFromServerId(closestPlayer))
    local targetPed = GetPlayerPed(closestPlayer)
    if IsEntityVisible(pedEntity) == false then
        return vRP.notify({"~r~ Already bagged"})
    end
    if closestPlayer then
        TriggerServerEvent('Cyber:TriggerBodyBag', closestPlayer)
    end
end)


function PutInBodybag()

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    
    deadCheck = vRP.isInComa()

    if deadCheck then
        attached = true
        SetEntityVisible(playerPed, false, false)
        Wait(1000)
        local bag_model = "xm_prop_body_bag"
        RequestModel(bag_model)

        while not HasModelLoaded(bag_model) do
            Citizen.Wait(1)
        end

        bodyBag = CreateObject(`xm_prop_body_bag`, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
        AttachEntityToEntity(bodyBag, playerPed, 0, -0.2, 0.75, -0.2, 0.0, 0.0, 0.0, false, false, false, false, 20, false)
        attached = true
    end
end

RegisterNetEvent('BODYBAG:PutInBag')
AddEventHandler('BODYBAG:PutInBag', function()
    PutInBodybag()
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if attached == true then
            local playerPed = PlayerPedId()
            Wait(299999)
            DeleteObject(bodyBag)
            DeleteEntity(bodyBag)
            DetachEntity(playerPed, true, false)
            SetEntityVisible(playerPed, true, true)
            SetEntityAsMissionEntity(bodyBag, false, false)
            SetEntityVisible(bodybag, false)
            SetModelAsNoLongerNeeded(bodyBag)
            bodyBag = nil
            attached = false
            justBagged = false
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        local playerPed = PlayerPedId()
        
        deadCheck =  vRP.isInComa()

        if deadCheck == false and attached == true then

            DetachEntity(playerPed, true, false)
            SetEntityVisible(playerPed, true, true)

            SetEntityAsMissionEntity(bodyBag, false, false)
            SetEntityVisible(bodybag, false)
            SetModelAsNoLongerNeeded(bodyBag)
            
            DeleteObject(bodyBag)
            DeleteEntity(bodyBag)

            bodyBag = nil
            attached = false
            justBagged = false

        end
        Citizen.Wait(1000)
    end
end)


local Hospitals = {
	vector3(308.66912841796,-591.76837158204,43.284004211426),
	vector3(1832.6276855468,3682.9201660156,34.270084381104),
	vector3(-254.54681396484,6332.7192382812,32.427249908448),
}

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)

        local coords = GetEntityCoords(PlayerPedId())

        for i = 1, #Hospitals do
            DrawMarker(25, Hospitals[i].xy, Hospitals[i].z-0.98, 0, 0, 0, 0, 0, 0, 0.9, 0.9, 0.9, 51, 255, 51, 155, 0, 0, 0, 0, 0, 0, 0)
            if #(Hospitals[i] - coords) < 1.0 then
                print("CLOSEE")
                DrawHelpMsg("Press ~INPUT_CONTEXT~ to Heal")

                if IsControlJustPressed(1, 51) then
                    SetEntityHealth(PlayerPedId(), 200)
                end
            end
        end
    end
end)

function DrawHelpMsg(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end