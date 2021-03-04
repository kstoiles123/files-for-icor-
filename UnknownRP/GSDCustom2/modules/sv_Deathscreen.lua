-- vRP TUNNEL/PROXY
Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","Custom3")

-- RESOURCE TUNNEL/PROXY
vRPServer = {}
Tunnel.bindInterface("Custom3",vRPServer)
Proxy.addInterface("Custom3",vRPServer)
vRPClient = Tunnel.getInterface("Custom3", "Custom3")

function vRPServer.nhsOnline()
  local nhs = vRP.getUsersByGroup({"nhsonduty"})
  return #nhs
end
