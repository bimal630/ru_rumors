local valentineCenter = vector3(-280.0, 804.0, 119.4)
local voiceNpcList = {}

-- RedM-compatible native wrappers
function RequestModel(model)
    Citizen.InvokeNative(0xFA28FE3A6246FC30, model, true) -- Request model
end

function HasModelLoaded(model)
    return Citizen.InvokeNative(0x1283B8B89DD5D1B6, model)
end

-- Get random allowed ped model
local function GetRandomPedModel()
    local keys = {}
    for model, _ in pairs(Config.AllowedModels) do
        keys[#keys + 1] = model
    end
    return keys[math.random(#keys)]
end

-- Create ped safely
local function CreatePedSafe(model, coords, heading)
    return Citizen.InvokeNative(0xD49F9B0955C367DE, model, coords.x, coords.y, coords.z, heading, true, true, false, false)
end

-- Spawn voice peds around Valentine
function SpawnVoiceNpcNearby()
    if #voiceNpcList > 0 then
        print("[Voice NPC Spawner] NPCs already spawned.")
        return
    end

    for i = 1, 4 do
        local model = GetRandomPedModel()
        RequestModel(model)
        while not HasModelLoaded(model) do Wait(10) end

        local offsetX = math.random(-80, 80)
        local offsetY = math.random(-80, 80)
        local spawnPos = vector3(valentineCenter.x + offsetX, valentineCenter.y + offsetY, valentineCenter.z)

        -- Adjust to ground height
        local found, groundZ = GetGroundZFor_3dCoord(spawnPos.x, spawnPos.y, spawnPos.z, 0)
        if found then
            spawnPos = vector3(spawnPos.x, spawnPos.y, groundZ)
        end

        local heading = math.random(0, 360) * 1.0
        local npc = CreatePedSafe(model, spawnPos, heading)

        if npc and npc ~= 0 then
            FreezeEntityPosition(npc, true)
            SetEntityInvincible(npc, true)
            SetBlockingOfNonTemporaryEvents(npc, true)
            table.insert(voiceNpcList, npc)

            print(string.format("[Voice NPC Spawner] ✅ Spawned ped: %s at (%.1f, %.1f, %.1f)", model, spawnPos.x, spawnPos.y, spawnPos.z))
        else
            print("[Voice NPC Spawner] ❌ Failed to spawn ped")
        end
    end
end

-- Manual spawn command
RegisterCommand("spawnrumornpcs", function()
    SpawnVoiceNpcNearby()
end)

-- Auto spawn on resource start
Citizen.CreateThread(function()
    Wait(3000)
    SpawnVoiceNpcNearby()
end)
