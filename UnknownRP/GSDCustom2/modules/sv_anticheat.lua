local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')

vRP = Proxy.getInterface('vRP')

RegisterServerEvent('vRP:BanPlayer')
AddEventHandler('vRP:BanPlayer', function(Reason)
    local source = source
    local user_id = vRP.getUserId({source})
    if not vRP.hasGroup({user_id, "superadmin"}) then
    	vRP.setBanned({user_id, true, 10444633200, Reason, "Cyber [Anticheat]"})
    	DropPlayer(source, "You have been banned.")
    end
end)

local crashes = {
    "GTA5.exe!sub_14145A40C (0x34)",
    "gta-streaming-five.dll!std::basic_string<char,std::char_traits<char>,std::allocator<char> >::_Reallocate_for (0x265)",
    "scripthookv.dll!nativeCall (0x379)",
    "0xf2afb40b",
    "GTA5.exe!sub_1405DB148 (0xfe)",
    "ros-patches-five.dll!SetLauncherWaitCB::__l2::<lambda>::operator() (0x126)",
    "d3d11.dll!??0?$C10and11View@UID3D11RenderTargetView1@@UID3D10RenderTargetView@@@@QEAA@AEBUSD3D11LayeredViewCreationArgs@@AEBVCSubresourceSubset@@W4ED3D11DeviceChildType@@@Z (0xec)",
    "0xf1d93de2",
    "dxgi.dll!?CreateProxyWindowImpl@ProxyWindow@@AEAAJAEBUCreationParams@1@@Z (0x25c)",
    "citizen-resources-client.dll!Concurrency::details::_ExceptionHolder::~_ExceptionHolder (0x1d)"
}

AddEventHandler("playerDropped", function(reason)
    local source = source
    for k,v in pairs(crashes) do
        if string.match(reason, v) then
            TriggerEvent('vRP:BanPlayer', 'Bad Crash Message')
        end
    end
end)

AddEventHandler("explosionEvent", function(source, ev)
    ev.damageScale = 0.0
    CancelEvent()
end)

AddEventHandler("weaponDamageEvent",  function(source, weapondamage)
    local damageType = weapondamage["damageType"]
    local weaponType = weapondamage["weaponType"]
    if tonumber(weaponDamage) > 525 then
        if weaponType == 539292904 then return end
        if damageType == 5 then return end
        TriggerEvent('vRP:BanPlayer', 'Damage Modifier')
    end
end)