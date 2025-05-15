RegisterNetEvent('weatherMenu:setWeather', function(weatherType)
    TriggerClientEvent('weatherMenu:applyWeather', -1, weatherType)
end)
