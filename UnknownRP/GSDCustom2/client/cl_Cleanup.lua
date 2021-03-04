Citizen.CreateThread(function()
  while (true) do
    Citizen.Wait(60000 * 30)
    TriggerEvent('chatMessage', '[Vehicle Cleanup]', -1, " Cleanup in 30 Seconds!")

    CleanUp()
  end
end)

function CleanUp()
  local theVehicles = getVehicles()
  for veh in theVehicles do
      if DoesEntityExist(veh) then 
          if((GetPedInVehicleSeat(veh, -1)) == false) or ((GetPedInVehicleSeat(veh, -1)) == nil) or ((GetPedInVehicleSeat(veh, -1)) == 0)then
              Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( veh ) )
              TriggerEvent('chatMessage', '[Vehicle Cleanup]', -1, " Completed")
          end
      end
  end
end

local function getEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end
    
		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, enumerator)
    
		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next
  
		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function getVehicles()
  return getEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end