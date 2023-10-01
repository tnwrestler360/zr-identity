if (zr_config.framework=='QB') then
    function zr_identity_givestartingitems(source)
        local zr_source = source
        local zr_player = QBcore.Functions.GetPlayer(zr_source)
        for _, v in pairs(QBcore.Shared.StarterItems) do
            local info = {}
            if v.item == "id_card" then
                info.citizenid = zr_player.PlayerData.citizenid
                info.firstname = zr_player.PlayerData.charinfo.firstname
                info.lastname = zr_player.PlayerData.charinfo.lastname
                info.birthdate = zr_player.PlayerData.charinfo.birthdate
                info.gender = zr_player.PlayerData.charinfo.gender
                info.nationality = zr_player.PlayerData.charinfo.nationality
            elseif v.item == "driver_license" then
                info.firstname = zr_player.PlayerData.charinfo.firstname
                info.lastname = zr_player.PlayerData.charinfo.lastname
                info.birthdate = zr_player.PlayerData.charinfo.birthdate
                info.type = "Class C Driver License"
            end
            zr_player.Functions.AddItem(v.item, v.amount, false, info)
        end
    end
end