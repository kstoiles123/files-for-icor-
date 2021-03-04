local nhsRanks = {
    [1] = { Rank = "Cheif Medical Officer", PayCheck = 60000  },
    [2] = { Rank = "Deputy Cheif Medical Offier", PayCheck = 60000  },
    [3] = { Rank = "Assistant Cheif Medical Offier", PayCheck = 60000  },
    [4] = { Rank = "Commander", PayCheck = 60000  },
    [5] = { Rank = "Consultant", PayCheck = 60000  },
    [6] = { Rank = "Specialist", PayCheck = 60000  },
    [7] = { Rank = "Senior Doctor", PayCheck = 60000  },
    [8] = { Rank = "Doctor", PayCheck = 60000  },
    [9] = { Rank ="Junior Doctor", PayCheck = 60000  },
    [10] = { Rank = "Critical Care Paramedic", PayCheck = 60000  },
    [11] = { Rank = "Paramedic", PayCheck = 60000  },
    [12] = { Rank = "Trainee Paramedic", PayCheck = 60000  },
}

local ClockOn_Coords = {
    vector3(310.90142822266,-595.93170166016,43.28398513794),
    vector3(1836.7548828125,3685.396484375,34.270084381104),
    vector3(-259.52655029296,6330.7192382812,32.427276611328),
}

-- Dont edit below

local isPlayerOnDuty = false
local PayCheckTimer = 0
local HasStarted = false
local _SelectedRank = nil

RMenu.Add('nhs', 'main', RageUI.CreateMenu("NHS", "~b~NHS", 1300, 0))
RMenu:Get('nhs', 'main')

RageUI.CreateWhile(1.0, RMenu:Get('nhs', 'main'), nil, function()
    RageUI.IsVisible(RMenu:Get('nhs', 'main'), true, false, true, function()

        for k,v in pairs (nhsRanks) do

            RageUI.Button(v.Rank, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                if Selected then
                    if v.Rank == "Off Duty" then
                        notify('~g~Clocked Off')
                        SetResourceKvpInt("nhs_ClockedOn", 1)
                        HasStarted = false
                        PayCheckTimer = 0
                    else
                        NHSStartTimerCheck()
                        _SelectedRank = k
                        SetResourceKvpInt("nhs_ClockedOn", 2)
                        notify('~g~You have clocked on as ' .. v.Rank)
                    end
                end
            end, RMenu:Get('nhs', 'main'))

        end

    end)
end)

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(0)

        local Coords = GetEntityCoords(PlayerPedId())

        for i = 1, #ClockOn_Coords do
            DrawMarker(25, ClockOn_Coords[i].xy, ClockOn_Coords[i].z-0.98, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 51, 128, 255, 155, 0, 0, 0, 0, 0, 0, 0)

            if #(Coords - ClockOn_Coords[i]) < 1.0 then
            if IsControlJustPressed(1, 51) then
                TriggerServerEvent('Cyber:CheckForPermNHS')
                Citizen.Wait(100)

                    if isPlayerOnDuty then
                        RageUI.Visible(RMenu:Get('nhs', 'main'), not RageUI.Visible(RMenu:Get('nhs', 'main')))
                    end
                end
            end
        end
    end
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

RegisterNetEvent('Cyber:AllowNHS')
AddEventHandler('Cyber:AllowNHS', function()
    isPlayerOnDuty = true
end)

function NHSStartTimerCheck()
    PayCheckTimer = 1800
end

Citizen.CreateThread(function()
    while (true) do
        Citizen.Wait(1000)
        if (PayCheckTimer > 0) then
            HasStarted = true
            PayCheckTimer = PayCheckTimer - 1
        end

        if HasStarted and PayCheck == 0 then
            HasStarted = false
            notify('~g~Paycheck Recieved: ' .. nhsRanks[_SelectedRank].PayCheck)
            TriggerServerEvent('Finished:NHS', nhsRanks[_SelectedRank].PayCheck)
        end
    end
end)