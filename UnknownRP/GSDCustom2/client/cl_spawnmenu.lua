CanShowMenu = false

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(500)

        if (IsEntityDead(PlayerPedId())) then
            CanShowMenu = true
        end
    end
end)

AddEventHandler('playerSpawned', function()
    if CanShowMenu then
        RageUI.Visible(RMenu:Get('SpawnMenu', 'main'), not RageUI.Visible(RMenu:Get('SpawnMenu', 'main')))
        CanShowMenu = false
    end
end)

local Locations = {
    ["St Thomas"] = { coords = vector3(362.41110229492,-595.26007080078,28.6672000885) },
    ["Paleto Hospital"] = { coords =  vector3(-247.00408935546,6330.8017578125,32.426239013672) },
    ["Sandy Shores Hospital"] = { coords =  vector3(1841.6611328125,3669.1481933594,33.679946899414) }
}


RMenu.Add('SpawnMenu', 'main', RageUI.CreateMenu("Spawn Manager", "~b~Spawn Menu", 1300, 0))
RMenu:Get('SpawnMenu', 'main')

RageUI.CreateWhile(1.0, RMenu:Get('SpawnMenu', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('SpawnMenu', 'main'), true, false, true, function()

        for k,v in pairs (Locations) do

            RageUI.Button(k, nil, {RightLabel = "â†’â†’â†’"}, true, function(Hovered, Active, Selected)
                if (Selected) then
		            RageUI.CloseAll()
                    SetEntityCoords(PlayerPedId(), v.coords)
                end
            end, RMenu:Get('SpawnMenu', 'main'))

        end

    end)
end)
