local GoodWeather = {}

function GoodWeather.post_init()
    for _, proto in pairs(db:objects()) do
        local planet = StaticPlanet.cast(proto)
        if planet ~= nil then
            planet.weather_severity_max = 0.35
            print(string.format('GoodWeather: %s weather from %.2f to %.2f', proto.name, planet.weather_severity_min, planet.weather_severity_max))
        end
    end
end

db:mod(GoodWeather)
