local npcCooldowns = {}

local function debugPrint(...)
    if Config.Debug then
        print("[Rumors Debug]", ...)
    end
end

function IsValidNpc(ped)
    if not DoesEntityExist(ped) or IsPedAPlayer(ped) or IsPedInAnyVehicle(ped, true) or not IsPedHuman(ped) then
        return false
    end

    local model = GetEntityModel(ped)
    if Config.AllowedModels[model] then
        debugPrint("✅ Valid NPC:", ped, "Model Hash:", model)
        return true
    end

    debugPrint("❌ Skipped NPC (no voice support):", model)
    return false
end

function CanSpeakToNpc(ped)
    local lastSpoken = npcCooldowns[ped] or 0
    local canSpeak = (GetGameTimer() - lastSpoken) >= (Config.NPCCooldown * 1000)
    if not canSpeak then
        debugPrint("⏳ NPC", ped, "is on cooldown.")
    end
    return canSpeak
end

function MarkNpcCooldown(ped)
    npcCooldowns[ped] = GetGameTimer()
    debugPrint("✅ Cooldown set for NPC:", ped)
end

Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local peds = GetGamePool("CPed")

        for i = 1, #peds do
            local ped = peds[i]

            if IsValidNpc(ped) then
                local dist = #(playerCoords - GetEntityCoords(ped))
                if dist < Config.DetectRange then
                    debugPrint("📏 NPC", ped, "within range:", dist)

                    if CanSpeakToNpc(ped) then
                        local rumor = Config.RumorVoices[math.random(#Config.RumorVoices)]
                        debugPrint("🗣️ NPC", ped, "saying:", rumor.text, "   Speech Line:", rumor.line)

                        TaskTurnPedToFaceEntity(ped, playerPed, 1000)
                        Wait(800)

                        -- Safe speech trigger
                        if DoesEntityExist(ped) and type(ped) == "number" then
                            local success, err = pcall(function()
                                PlayAmbientSpeech1(ped, rumor.line, rumor.param)
                            end)
                        
                            if not success then
                                debugPrint("❌ Failed to play speech:", err)
                            end
                        else
                            debugPrint("❌ Invalid PED passed to speech:", ped, "Type:", type(ped))
                        end
                        

                        TriggerEvent("vorp:TipBottom", "🗣️ Stranger says: " .. rumor.text, 7000)

                        MarkNpcCooldown(ped)

                        Wait(10000)
                        break
                    end
                end
            end
        end

        Wait(Config.CheckInterval)
    end
end)
