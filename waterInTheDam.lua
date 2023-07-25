Dam = Model{
    innit_year = 1950, -- When stated to mensuare
    inhabitants = 100000, -- Total of inhabitants
    volum_dam = 5000000000, -- m3
    firstRainySeason = 2000000000, -- m3
    secondRainySeason = 1500000000, -- m3
    inhabitant_consume = 10, -- kWh per month
    m3 = 100, -- Required cubic meters (m^3)
    increse_consumption = 0.05, -- Increases average per inhabitant per year
    outflow = 0.45, -- % of outflow control per year
    rationing = 0.30, -- % of rationing
    consumption = 0, -- Start in 0
    finalTime = 30, -- Years
    init = function(model)
        model.chart = Chart{target = model,
            select = {"volum_dam", "consumption"},
            color = {"blue", "orange"}
            }

        model.timer = Timer{
            Event{action = model.chart},
            -- Inflow: Rainy season 1
            -- Each month of the year mean 0.083333, i.e., 1/12
            Event{start = 0.083333333333333, action = function()
                    print("- First Rainy season")
                    -- Volume of the dam added to the increment periods
                    model.volum_dam = model.volum_dam + model.firstRainySeason
            end},

            -- Inflow: Rainy season 2
            Event{start = 0.5, action = function()
                    print("- Second Rainy season")
                    -- Volume of the dam added to the increment periods
                    model.volum_dam = model.volum_dam + model.secondRainySeason
            end},

            -- Outflow: water consumption and or control
            Event{action = function()
                    print("- Dam capacity Status: "..model.volum_dam)

                    -- Annual consumption of m3 for energy production
                    model.consumption = model.m3 * model.inhabitant_consume * model.inhabitants

                    --print("Consumption: ".. model.inhabitant_consume)
                    print("- Annual consumption: "..model.consumption)


                    -- If the capacity of the dam is greater than 5e+9 release water
                    if model.volum_dam >= 5e+9 then
                        print("- Over capacity: ")
                        model.volum_dam = model.volum_dam - (model.volum_dam * model.outflow)
                        print("-- Current Volume: ".. model.volum_dam)

                    end

                    -- If the volume of water is greater than necessary to produce
                    -- energy for the entire population: produces energy
                    if model.volum_dam >= model.consumption then
                        model.volum_dam = model.volum_dam - model.consumption
                        print("- Adequate volume as needed: ".. model.volum_dam)

                        -- Annual increase in energy consumption per inhabitant
                        model.inhabitant_consume = model.inhabitant_consume + (model.inhabitant_consume*model.increse_consumption)
                        print("-- Annual Consumption increase: ".. model.inhabitant_consume)

                    else
                        -- Preserve the volume of the dam
                        model.volum_dam = model.volum_dam
                        print("- Low volume as needed: ".. model.volum_dam)

                        -- Get low m3 consumption
                        model.consumption = model.consumption - ( model.consumption * model.rationing)


                    end

            end},

        }
    end
}

simulation = Dam{finalTime = 100}
simulation:run()

simulation1 = Dam{finalTime = 100, m3 = 80}
simulation1:run()

simulation2 = Dam{finalTime = 100, inhabitant_consume = 5}
simulation2:run()

simulation3 = Dam{finalTime=20} -- segue até o tempo 50
simulation3:run()
simulation3.firstRainySeason=1e+9 -- a partir do tempo 50
simulation3.secondRainySeason=75e+7 -- a partir do tempo 50
simulation3.finalTime = 100 -- tempo final
simulation3:run()

simulation4 = Dam{finalTime=20} -- segue até o tempo 50
simulation4:run()
simulation4.firstRainySeason=1e+9 -- a partir do tempo 50
simulation4.secondRainySeason=75e+7 -- a partir do tempo 50
simulation4.m3 = 80
simulation4.inhabitant_consume = 5
simulation4.finalTime = 100 -- tempo final
simulation4:run()




--[[
env = Environment{
    simulation1 = Dam{m3 = 80},
    simulation2 = Dam{inhabitant_consume = 5},
    simulation3 = Dam{firstRainySeason=1e+9, secondRainySeason=75e+7},
    simulation4 = Dam{m3 = 80, inhabitant_consume = 5, firstRainySeason=1e+9, secondRainySeason=75e+7}


}

chart1 = Chart{target = env, select = "volum_dam"}
chart2 = Chart{target = env, select = "consumption"}
env:add(Event{action = chart1})
env:add(Event{action = chart2})
env:run() --]]



