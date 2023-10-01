function zr_identity_show_public()
	-- Trigger Custom Functions/Events when display menu.
	DisplayRadar(false)
end

function zr_identity_hide_public()
	-- Trigger Custom Functions/Events when hide menu.
end

if (zr_config.framework=='ESX') then

    RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function(zr_playerdata, zr_isnew, zr_skin)
		local zr_spawn = zr_playerdata.coords or zr_config.DefaultSpawn
		if zr_isnew or not zr_skin or #zr_skin == 1 then
			local done = false
			local zr_gender = zr_playerdata.sex -- local zr_gender = 'm' (https://github.com/zaphosting/esx_12)
			zr_skin = zr_config.DefaultSkins[zr_gender]
			zr_skin.sex = zr_gender == "m" and 0 or 1 
			if zr_skin.sex == 0 then zr_model = zr_config.DefaultModels[1] else zr_model = zr_config.DefaultModels[2] end
			zr_identity_loadModel(zr_model)
			SetPlayerModel(PlayerId(), zr_model)
			SetModelAsNoLongerNeeded(zr_model)
			TriggerEvent('skinchanger:loadSkin', zr_skin, function()
                TriggerEvent('esx_skin:openSaveableMenu', function()
                    done = true end, function() done = true
                end)
			end)
			repeat Wait(200) until done
		end
		DoScreenFadeOut(100)
		SetEntityCoordsNoOffset(PlayerPedId(), zr_spawn.x, zr_spawn.y, zr_spawn.z, false, false, false, true)
		SetEntityHeading(PlayerPedId(), zr_spawn.heading)
		if not zr_isnew then TriggerEvent('skinchanger:loadSkin', zr_skin) end
		Wait(400)
		DoScreenFadeIn(400)
		repeat Wait(200) until not IsScreenFadedOut()
		TriggerServerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:onPlayerSpawn')
		TriggerEvent('playerSpawned')
		TriggerEvent('esx:restoreLoadout')
        FreezeEntityPosition(PlayerPedId(), false)
	end)
end

RegisterNetEvent('zr-identity:hide', function()
    zr_identity_hide()
    if (zr_config.framework=='QB') then
        DoScreenFadeOut(500)
        Wait(2000)
        SetEntityCoords(PlayerPedId(), zr_config.DefaultSpawn.x, zr_config.DefaultSpawn.y, zr_config.DefaultSpawn.z)
        TriggerServerEvent('QBCore:Server:OnPlayerLoaded')
        TriggerEvent('QBCore:Client:OnPlayerLoaded')
        TriggerServerEvent('qb-houses:server:SetInsideMeta', 0, false)
        TriggerServerEvent('qb-apartments:server:SetInsideMeta', 0, 0, false)
        Wait(500)
        SetEntityVisible(PlayerPedId(), true)
        Wait(500)
        DoScreenFadeIn(250)
        TriggerEvent('qb-weathersync:client:EnableSync')
        if not zr_config.StartingAppartment then
            TriggerEvent('qb-clothes:client:CreateFirstCharacter')
        end
    end
end)

function zr_player_created()
    -- If you want to trigger a custom event or funtion after the character is created
end

function zr_identity_notify(zr_msg)
    if (zr_config.zr_notify) then
        exports['zr-notify']:zr_notify('info', zr_msg, 5000, 'info', 'left')
    else
        if (zr_config.framework=='QB') then
            QBcore.Functions.Notify(zr_msg, "info")
        else
            ESX.ShowNotification(zr_msg, "info", 3000)
        end
    end
end