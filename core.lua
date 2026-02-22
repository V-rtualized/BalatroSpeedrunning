SPDRN = SMODS.current_mod

sendDebugMessage(SPDRN.id, SPDRN.id)

MPAPI.on_loaded(function()
    MPAPI.connect({
        api_url = "http://localhost:8788",
        mqtt_broker = "localhost",
        mqtt_port = 1883,
        mqtt_secure = false,
    })
end)