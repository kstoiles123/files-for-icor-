local blips = {
	-- Example {title="", colour=, id=, x=, y=, z=},
	{title="Safe Zone", colour=2, id=1, pos=vector3(333.91488647461,-597.16156005859,29.292747497559),dist=40,nonRP=false,setBit=false}, --ST THOOMAS
	{title="Safe Zone", colour=2, id=1, pos=vector3(157.22776794434,-1041.1833496094,28.883068084716),dist=50,nonRP=false,setBit=false}, -- leigon
	{title="Safe Zone", colour=2, id=1, pos=vector3(1705.8400878906,2595.4384765625,50.83985595704),dist=80,nonRP=false,setBit=false}, --prison
	{title="Safe Zone", colour=2, id=1, pos=vector3(-1472.3331298828,-657.93084716797,29.261665344238),dist=20,nonRP=false,setBit=false}, --motel greenzone
	{title="Safe Zone", colour=2, id=1, pos=vector3(-260.92904663086,-972.62976074219,31.21999168396),dist=30,nonRP=false,setBit=false}, --JobCentre
	{title="Safe Zone", colour=2, id=1, pos=vector3(246.30143737793,-782.50170898438,30.573167800903),dist=40,nonRP=false,setBit=false}, --BBCGarage
	{title="Safe Zone", colour=2, id=1, pos=vector3(3463.3479003906,2589.4458007813,17.442699432373),dist=40,nonRP=true,setBit=false}, --adminzone
	{title="Safe Zone", colour=2, id=1, pos=vector3(1133.0970458984,250.78565979004,-51.035778045654),dist=100,nonRP=false,setBit=false,interior=true}, --casino
}
     

	 
local pos1 = AddBlipForRadius(333.91488647461,-597.16156005859,29.292747497559, 40.0)
SetBlipColour(pos1, 2)
SetBlipAlpha(pos1, 180)
local pos2 = AddBlipForRadius(157.22776794434,-1041.1833496094,28.883068084716, 50.0)
SetBlipColour(pos2, 2)
SetBlipAlpha(pos2, 180)
local pos4 = AddBlipForRadius(1705.8544921875,2595.3459472656,50.187343597412, 80.0)
SetBlipColour(pos4, 2)
SetBlipAlpha(pos4, 180)
local pos7 = AddBlipForRadius(-1472.3331298828,-657.93084716797,29.261665344238, 20.0)
SetBlipColour(pos7, 2)
SetBlipAlpha(pos7, 180)
-- local pos8 = AddBlipForRadius(171.07974243164,-1024.8974609375,29.374752044678, 500.0)
-- SetBlipColour(pos8, 2)
-- SetBlipAlpha(pos8, 40)
local pos9 = AddBlipForRadius(-260.92904663086, -972.62976074219, 31.21999168396, 30.0)
SetBlipColour(pos9, 2)
SetBlipAlpha(pos9, 180)
local pos10 = AddBlipForRadius(246.30143737793,-782.50170898438,30.573167800903, 40.0)
SetBlipColour(pos10, 2)
SetBlipAlpha(pos10, 180)



InsideSafeZone = false
setDrawGreenZoneUI = false
setDrawNonRpZoneUI = false
Citizen.CreateThread(function()
	while true do
		for index,info in pairs(blips) do
			local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			safeZoneDist = #(plyCoords-info.pos) 
			while safeZoneDist < info.dist do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				safeZoneDist = #(plyCoords-info.pos)
				
				if info.nonRP then
					setDrawNonRpZoneUI = true
				else
					if not info.setBit then
						setDrawGreenZoneUI = true
						showEnterGreenzone = true
						showExitGreenzone = false
						greenzoneTimer = 5
						info.setBit = true
					end
					if info.interior then 
						setDrawGreenInterior = true
					end
				end
				Wait(1000)
			end
			if info.setBit then
				showEnterGreenzone = false
				showExitGreenzone = true
				greenzoneTimer = 5
				----print("greenzoneTimer = 10 #2 " .. tostring(greenzoneTimer))
				info.setBit = false
			end
			setDrawNonRpZoneUI = false
			setDrawGreenZoneUI = false
			showEnterGreenzone = false
			setDrawGreenInterior = false
			SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			--SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedBloodDamage(GetPlayerPed(-1))
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityCanBeDamaged(GetPlayerPed(-1), true)
			NetworkSetFriendlyFireOption(true)
		end
		Wait(1000)
	end
end)

Citizen.CreateThread(function()
	while true do
		local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		cityZoneDist = #(plyCoords-vector3(171.07974243164,-1024.8974609375,29.3747520446784))
		if cityZoneDist < 500 then
			inCityZone = true 
		else 
			inCityZone = false 
		end
		--print("inCityZone: " .. tostring(inCityZone))
		Wait(1000)
	end
end)


Citizen.CreateThread(function()
	while true do
		if setDrawGreenZoneUI then
			DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
			DisablePlayerFiring(GetPlayerPed(-1),true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
			DisableControlAction(0, 106, true) -- Disable in-game mouse controls
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 140, true)
		end
		if setDrawNonRpZoneUI then
			bank_drawTxt(0.76, 1.44, 1.0,1.0,0.4, "You have entered a non-RP greenzone, you may talk out of character here", 0, 255, 0, 255)
			DisableControlAction(2, 37, true) -- disable weapon wheel (Tab)
			DisablePlayerFiring(GetPlayerPed(-1),true) -- Disables firing all together if they somehow bypass inzone Mouse Disable
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 140, true)
		end
		if setDrawGreenInterior then 
			DisableControlAction(0, 106, true) -- Disable in-game mouse controls
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 22, true)
		end
		Wait(0)
	end
end)

--RegisterCommand("godmode",function()
	--print("showEnterGreenzone: " .. tostring(showEnterGreenzone))
	--print("showExitGreenzone: " .. tostring(showExitGreenzone))
	--print("setDrawGreenZoneUI: " .. tostring(setDrawGreenZoneUI))
	--print("setDrawNonRpZoneUI: " .. tostring(setDrawNonRpZoneUI))
	--print("greenzoneTimer: " .. tostring(greenzoneTimer))
	--print("max health: " .. tostring(GetEntityMaxHealth(GetPlayerPed(-1))))
--end)

Citizen.CreateThread(function()
	while true do
		if setDrawGreenZoneUI or setDrawNonRpZoneUI then
			SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),13.0)
			SetEntityInvincible(GetPlayerPed(-1), true)
			SetPlayerInvincible(PlayerId(), true)
			-- SetPedCanRagdoll(GetPlayerPed(-1), false)
			ClearPedBloodDamage(GetPlayerPed(-1))
			SetCurrentPedWeapon(GetPlayerPed(-1),GetHashKey("WEAPON_UNARMED"),true)
			ResetPedVisibleDamage(GetPlayerPed(-1))
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
			SetEntityCanBeDamaged(GetPlayerPed(-1), false)
		else
			if GetVehiclePedIsIn(PlayerPedId(), false) ~= 0 then
				if not inCityZone then
					if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1),true)) ~= 13 then
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),111.5)
					else
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),11001.5)
					end
				else 
					if GetVehicleClass(GetVehiclePedIsIn(GetPlayerPed(-1),true)) ~= 13 then
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),44.6)
					else
						SetEntityMaxSpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false),11001.5)
					end
				end
			end
		end
		Wait(0)
	end
end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		if setDrawGreenZoneUI or setDrawNonRpZoneUI then
-- 			if IsEntityDead(GetPlayerPed(-1)) or GetEntityHealth(GetPlayerPed(-1)) <= 102 then 
-- 				TriggerEvent("CMG:Revive")
-- 			end
-- 			----print("Is this entity ass hole dead?: " .. tostring(IsEntityDead(GetPlayerPed(-1))))
-- 			----print("Is this entity ass hole health?: " .. tostring(GetEntityHealth(GetPlayerPed(-1))))
-- 		end
-- 		Wait(10000)
-- 	end
-- end)

showEnterGreenzone = false
showExitGreenzone = false
greenzoneTimer = 0

Citizen.CreateThread(function()
	while true do
		if showEnterGreenzone and greenzoneTimer > 0 then
			DrawRect(0.901, 0.242, 0.185, 0.063, 0, 0, 0, 150)
			DrawAdvancedText(1.042, 0.234, 0.005, 0.0028, 0.327, "GREEN ZONE", 0, 255, 0, 255, 0, 0)
			DrawAdvancedText(1.076, 0.236, 0.005, 0.0028, 0.327, ",", 0, 197, 255, 255, 0, 0)
			DrawAdvancedText(0.978, 0.26, 0.005, 0.0028, 0.327, "no illegal activity is permitted!", 0, 196, 255, 255, 0, 0)
			DrawAdvancedText(0.958, 0.233, 0.005, 0.0028, 0.327, "You have entered the", 0, 197, 255, 255, 0, 0)
		end
		if showExitGreenzone and greenzoneTimer > 0 then
			DrawRect(0.901, 0.242, 0.185, 0.063, 0, 0, 0, 150)
			DrawAdvancedText(1.02, 0.233, 0.005, 0.0028, 0.327, "GREEN ZONE", 0, 255, 0, 255, 0, 0)
			DrawAdvancedText(1.068, 0.233, 0.005, 0.0028, 0.327, ", illegal", 255, 255, 255, 255, 0, 0)
			DrawAdvancedText(0.966, 0.26, 0.005, 0.0028, 0.327, "activity is now permitted!", 255, 255, 255, 255, 0, 0)
			DrawAdvancedText(0.946, 0.233, 0.005, 0.0028, 0.327, "You have left the", 255, 255, 255, 255, 0, 0)
		end
		Wait(0)
	end
end)

Citizen.CreateThread(function()
	while true do
		greenzoneTimer = greenzoneTimer - 1
		----print("greenzoneTimer: " .. tostring(greenzoneTimer))
		Wait(1000)
	end
end)

function bank_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawAdvancedText(x,y ,w,h,sc, text, r,g,b,a,font,jus)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(sc, sc)
	N_0x4e096588b13ffeca(jus)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
	DrawText(x - 0.1+w, y - 0.02+h)
end















