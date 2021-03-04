local JobCenter_Coords = vector3(-314.2279663086,-946.50067138672,31.88062171936)

RMenu.Add('jobcenter', 'main', RageUI.CreateMenu("Bus Driver Job", "~b~Bus Driver Job", 1300, 0))
RMenu:Get('jobcenter', 'main')

RageUI.CreateWhile(1.0, RMenu:Get('jobcenter', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('jobcenter', 'main'), true, false, true, function()

        RageUI.Button("Spawn Bus", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
            if (Selected) then
                if not inBusJob then
                    StartBusjob()
                    inBusJob = true
                    RageUI.CloseAll()
                else
                    notify("Already in Bus Job!")
                end
            end
        end, RMenu:Get('jobcenter', 'main'))


    end)
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)

        local Coords = GetEntityCoords(PlayerPedId())
        DrawMarker(39, JobCenter_Coords.xy, JobCenter_Coords.z-0.98, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 255, 51, 51, 155, 0, 0, 0, 0, 0, 0, 0)

        if #(Coords - JobCenter_Coords) < 1.0 then
            DrawHelpMsg("Press ~INPUT_CONTEXT~ to spawn bus")
            if IsControlJustPressed(1, 51) then
                RageUI.Visible(RMenu:Get('jobcenter', 'main'), not RageUI.Visible(RMenu:Get('jobcenter', 'main')))
            end
        end
    end
end)

StartBusjob = function()
    SpawnBus()
    local selectedRoute = tostring(math.random(1,5))
    local DriveToFirstLocation = true
    local DriveToSecondLocation = false
    local DriveToThirdLocation = false
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(0)

            local coords = GetEntityCoords(PlayerPedId())

            if DriveToFirstLocation then
                SetNewWaypoint(cfg["Bus Job"]["Routes"][selectedRoute].Location1)

                if #(coords - cfg["Bus Job"]["Routes"][selectedRoute].Location1) < 10.0 then

                    if GetVehicleName(GetVehiclePedIsIn(PlayerPedId())) == string.lower(cfg["Bus Job"].Vehicle) then
                        DriveToFirstLocation = false
                        DriveToSecondLocation = true
                    end
                end
            end

            if DriveToSecondLocation then
                SetNewWaypoint(cfg["Bus Job"]["Routes"][selectedRoute].Location2)

                if #(coords - cfg["Bus Job"]["Routes"][selectedRoute].Location2) < 10.0 then

                    if GetVehicleName(GetVehiclePedIsIn(PlayerPedId())) == string.lower(cfg["Bus Job"].Vehicle) then
                        DriveToSecondLocation = false
                        DriveToThirdLocation = true
                    end
                end
            end

            if DriveToThirdLocation then
                SetNewWaypoint(cfg["Bus Job"]["Routes"][selectedRoute].Location3)

                if #(coords - cfg["Bus Job"]["Routes"][selectedRoute].Location3) < 10.0 then

                    if GetVehicleName(GetVehiclePedIsIn(PlayerPedId())) == string.lower(cfg["Bus Job"].Vehicle) then
                        DriveToThirdLocation = false
                        Paycheck();
                    end
                end
            end

        end
    end)
end

function DrawHelpMsg(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

Paycheck = function()
    if inBusJob then
        TriggerServerEvent('Cyber:3Bus')
        notify('~y~Well done, here is £' .. cfg["Bus Job"].pay_check)
        inBusJob = false
    end
end

SpawnBus = function()
	local hash = GetHashKey(cfg["Bus Job"].Vehicle)
	RequestModel(hash)
	local i = 0
	while not HasModelLoaded(hash) and i < 50 do
		Citizen.Wait(10)
		i = i + 1
	end
	if i >= 50 then
		return
	end
	local Ped = PlayerPedId()
	local Vehicle = CreateVehicle(hash, GetEntityCoords(Ped), GetEntityHeading(Ped), true, 0)
    i = 0
	while not DoesEntityExist(Vehicle) and i < 50 do
		Citizen.Wait(10)
		i = i + 1
	end
	if i >= 50 then
		return
	end
  SetPedIntoVehicle(Ped, Vehicle, -1)
  SetModelAsNoLongerNeeded(hash)
end


GetVehicleName = function(Model)
    local Name = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(Model)))
    return Name
end