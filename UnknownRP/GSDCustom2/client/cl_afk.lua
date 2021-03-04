secondsUntilKick = 900
kickWarning = true

Citizen.CreateThread(function()
	while true do
		playerPed = GetPlayerPed(-1)
		if playerPed then
			currentPos = GetEntityCoords(playerPed)
			currentHeading = GetEntityHeading(playerPed)
			if currentPos == prevPos and currentHeading == previousHeading then
				if time > 0 then
					if kickWarning and time == math.ceil(secondsUntilKick / 4) then
						TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
					end
					if kickWarning and time == math.ceil(secondsUntilKick / 2) then
						TriggerEvent("chatMessage", "WARNING", {255, 0, 0}, "^1You'll be kicked in " .. time .. " seconds for being AFK!")
					end
					time = time - 1
				else
					TriggerServerEvent("kick:AFK")
				end
			else
				time = secondsUntilKick
			end
			prevPos = currentPos
			previousHeading = currentHeading
		end
		Wait(1000)
	end
end)