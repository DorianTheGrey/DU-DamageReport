--[[
    Damage Report 3.13
    A LUA script for Dual Universe

    Created By Dorian Gray
    Ingame: DorianGray
    Discord: Dorian Gray#2623

    You can find/update this script on GitHub. Explanations, installation and usage information as well as screenshots can be found there too.
    GitHub: https://github.com/DorianTheGrey/DU-DamageReport

    GNU Public License 3.0. Use whatever you want, be so kind to leave credit.
    
    Credits & thanks: 
        Thanks to NovaQuark for creating the MMO of the century.
        Thanks to Jericho, Dmentia and Archaegeo for learning a lot from their fine scripts.
        Thanks to TheBlacklist for testing and wonderful suggestions.
        SVG patterns by Hero Patterns.
        DU atlas data from Jayle Break.
        
]]

--[[ 1. USER DEFINED VARIABLES ]]

YourShipsName = "Enter here" --export Enter your ship name here if you want it displayed instead of the ship's ID. YOU NEED TO LEAVE THE QUOTATION MARKS.

SkillRepairToolEfficiency = 0 --export Enter (0-5) your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Efficiency"
SkillRepairToolOptimization = 0 --export Enter your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Optimization"

StatAtmosphericFuelTankHandling = 0 --export (0-5) Enter the LEVEL OF YOUR PLACED ATMOSPHERIC FUEL TANKS (from the builders talent "Piloting -> Atmospheric Flight Technician -> Atmospheric Fuel-Tank Handling")
StatSpaceFuelTankHandling = 0 --export (0-5) Enter the LEVEL OF YOUR PLACED FUEL SPACE TANKS (from the builders talent "Piloting -> Atmospheric Engine Technician -> Space Fuel-Tank Handling")
StatRocketFuelTankHandling = 0 --export (0-5) Enter the LEVEL OF YOUR PLACED FUEL ROCKET TANKS (from the builders talent "Piloting -> Rocket Scientist -> Rocket Booster Fuel Tank Handling")
StatContainerOptimization = 0 --export (0-5) Enter the LEVEL OF YOUR PLACED FUEL TANKS "from the builders talent Mining and Inventory -> Stock Control -> Container Optimization"
StatFuelTankOptimization = 0 --export (0-5) Enter the LEVEL OF YOUR PLACED FUEL TANKS "from the builders talent Mining and Inventory -> Stock Control -> Fuel Tank Optimization"

ShowWelcomeMessage = true --export Do you want the welcome message on the start screen with your name?
DisallowKeyPresses = false --export Need your keys for other scripts/huds and want to prevent Damage Report keypresses to be processed? Then check this. (Usability of the HUD mode will be small.)
AddSummertimeHour = false --export: Is summertime currently enabled in your location? (Adds one hour.)

-- SkillAtmosphericFuelEfficiency = 0 --export Enter (0-5) your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Efficiency"
-- SkillSpaceFuelEfficiency = 0 --export Enter (0-5) your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Efficiency"
-- SkillRocketFuelEfficiency = 0 --export Enter (0-5) your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Efficiency"

--[[ 2. GLOBAL VARIABLES ]]

UpdateDataInterval = 1.0 -- How often shall the data be updated? (Increase if running into CPU issues.)
HighlightBlinkingInterval = 0.5 -- How fast shall highlight arrows of marked elements blink?

ColorPrimary = "FF6700" -- Enter the hexcode of the main color to be used by all views.
ColorSecondary = "FFFFFF" -- Enter the hexcode of the secondary color to be used by all views.
ColorTertiary = "000000" -- Enter the hexcode of the tertiary color to be used by all views.
ColorHealthy = "00FF00" -- Enter the hexcode of the 'healthy' color to be used by all views.
ColorWarning = "FFFF00" -- Enter the hexcode of the 'warning' color to be used by all views.
ColorCritical = "FF0000" -- Enter the hexcode of the 'critical' color to be used by all views.
ColorBackground = "000000" -- Enter the hexcode of the background color to be used by all views.
ColorBackgroundPattern = "4F4F4F" -- Enter the hexcode of the background color to be used by all views.
ColorFuelAtmospheric = "004444" -- Enter the hexcode of the atmospheric fuel color.
ColorFuelSpace = "444400" -- Enter the hexcode of the space fuel color.
ColorFuelRocket = "440044" -- Enter the hexcode of the rocket fuel color.

VERSION = 3.13
DebugMode = false
DebugRenderClickareas = true

DBData = {}

core = nil
db = nil
screens = {}
dscreens = {}

Warnings = {}

screenModes = { 
    ["flight"] = { id="flight" }, 
    ["damage"] = { id="damage" }, 
    ["damageoutline"] = { id="damageoutline" }, 
    ["fuel"] = { id="fuel" }, 
    ["cargo"] = { id="cargo" }, 
    ["agg"] = { id="agg" }, 
    ["map"] = { id="map" }, 
    ["time"] = { id="time", activetoggle="true" }, 
    ["settings1"] = { id="settings1" },
    ["startup"] = { id="startup" } 
}

backgroundModes = { "deathstar", "capsule", "rain", "signal", "hexagon", "diagonal", "diamond", "plus", "dots" }
BackgroundMode ="deathstar"
BackgroundSelected = 1
BackgroundModeOpacity = 0.25

SaveVars = { "dscreens",
                "ColorPrimary", "ColorSecondary", "ColorTertiary",
                "ColorHealthy", "ColorWarning", "ColorCritical",
                "ColorBackground", "ColorBackgroundPattern",
                "ColorFuelAtmospheric", "ColorFuelSpace", "ColorFuelRocket", 
                "ScrapTier", "HUDMode", "SimulationMode", "DMGOStretch",
                "HUDShiftU", "HUDShiftV", "colorIDIndex", "colorIDTable", 
                "BackgroundMode", "BackgroundSelected", "BackgroundModeOpacity" }

HUDMode = false
HUDShiftU = 0
HUDShiftV = 0
hudSelectedIndex = 0
hudStartIndex = 1
hudArrowSticker = {}
highlightOn = false
highlightID = 0
highlightX = 0
highlightY = 0
highlightZ = 0

SimulationMode = false
OkayCenterMessage = "All systems nominal."
CurrentDamagedPage = 1
CurrentBrokenPage = 1
DamagePageSize = 12
ScrapTier = 1
totalScraps = 0
ScrapTierRepairTimes = { 10, 50, 250, 1250 }

coreWorldOffset = 0
totalShipHP = 0
formerTotalShipHP = -1
totalShipMaxHP = 0
totalShipIntegrity = 100
elementsId = {}
elementsIdList = {}
damagedElements = {}
brokenElements = {}
rE = {}
healthyElements = {}
typeElements = {}
ElementCounter = 0
UseMyElementNames = true
dmgoElements = {}
DMGOMaxElements = 250
DMGOStretch = false
ShipXmin = 99999999
ShipXmax = -99999999
ShipYmin = 99999999
ShipYmax = -99999999
ShipZmin = 99999999
ShipZmax = -99999999

totalShipMass = 0
formerTotalShipMass = -1

formerTime = -1

FuelAtmosphericTanks = {}
FuelSpaceTanks = {}
FuelRocketTanks = {}
FuelAtmosphericTotal = 0
FuelSpaceTotal = 0
FuelRocketTotal = 0
FuelAtmosphericCurrent = 0
FuelSpaceTotalCurrent = 0
FuelRocketTotalCurrent = 0
formerFuelAtmosphericTotal = -1
formerFuelSpaceTotal = -1
formerFuelRocketTotal = -1

hexTable = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"}
colorIDIndex = 1
colorIDTable = {
    [1] = {
        id="ColorPrimary",
        desc="Main HUD Color",
        basec = "FF6700", 
        newc = "FF6700"
    },
    [2] = {
        id="ColorSecondary",
        desc="Secondary HUD Color",
        basec = "FFFFFF", 
        newc = "FFFFFF"
    },
    [3] = { 
        id="ColorTertiary",
        desc="Tertiary HUD Color",
        basec = "000000", 
        newc = "000000"
    },
    [4] = { 
        id="ColorHealthy",
        desc="Color code for Healthy/Okay",
        basec = "00FF00", 
        newc = "00FF00"
    },
    [5] = { 
        id="ColorWarning",
        desc="Color code for Damaged/Warning",
        basec = "FFFF00", 
        newc = "FFFF00"
    },
    [6] = { 
        id="ColorCritical",
        desc="Color code for Broken/Critical",
        basec = "FF0000", 
        newc = "FF0000"
    },
    [7] = { 
        id="ColorBackground",
        desc="Background Color",
        basec = "000000", 
        newc = "000000"
    },
    [8] = { 
        id="ColorBackgroundPattern",
        desc="Background Pattern Color",
        basec = "4F4F4F", 
        newc = "4F4F4F"
    },
    [9] = { 
        id="ColorFuelAtmospheric",
        desc="Color for Atmo Fuel/Elements",
        basec = "004444", 
        newc = "004444"
    },
    [10] = { 
        id="ColorFuelSpace",
        desc="Color for Space Fuel/Elements",
        basec = "444400", 
        newc = "444400"
    },
    [11] = { 
        id="ColorFuelRocket",
        desc="Color for Rocket Fuel/Elements",
        basec = "440044", 
        newc = "440044"
    }
}


--[[ 3. PROCESSING FUNCTIONS ]]

function InitiateSlots()
    for slot_name, slot in pairs(unit) do
        if type(slot) == "table" and type(slot.export) == "table" and
            slot.getElementClass then
            local elementClass = slot.getElementClass():lower()
            if elementClass:find("coreunit") then
                core = slot
                local coreHP = core.getMaxHitPoints()
                if coreHP > 10000 then
                    coreWorldOffset = 128
                elseif coreHP > 1000 then
                    coreWorldOffset = 64
                elseif coreHP > 150 then
                    coreWorldOffset = 32
                else
                    coreWorldOffset = 16
                end
            elseif elementClass == 'databankunit' then
                db = slot
            elseif elementClass == "screenunit" then
                local iScreenMode = "startup"
                screens[#screens + 1] = { 
                    element = slot, 
                    id = slot.getId(),
                    mode = iScreenMode,
                    submode = "",
                    ClickAreas = {},
                    refresh = true,
                    active = false,
                    fuelA = true,
                    fuelS = true,
                    fuelR = true,
                    fuelIndex = 1
                }
            end
        end
    end
end

function LoadFromDatabank()
    if db == nil then
        return
    else
        for _, data in pairs(SaveVars) do
            if db.hasKey(data) then
                local jData = json.decode( db.getStringValue(data) )
                if jData ~= nil then
                    if data == "YourShipsName" or data == "AddSummertimeHour" or data == "UpdateDataInterval" or data == "HighlightBlinkingInterval" or
                        data == "SkillRepairToolEfficiency" or data == "SkillRepairToolOptimization" or data == "SkillAtmosphericFuelEfficiency" or
                        data == "SkillSpaceFuelEfficiency" or data == "SkillRocketFuelEfficiency" or data == "StatAtmosphericFuelTankHandling" or
                        data == "StatSpaceFuelTankHandling" or data ==  "StatRocketFuelTankHandling" 
                    then
                        -- Nada
                    else
                        _G[data] = jData
                    end
                end
            end
        end
            
        for i,v in ipairs(screens) do
            for j,dv in ipairs(dscreens) do
                if screens[i].id == dscreens[j].id then
                    screens[i].mode = dscreens[j].mode
                    screens[i].submode = dscreens[j].submode
                    screens[i].active = dscreens[j].active
                    screens[i].refresh = true
                    screens[i].fuelA = dscreens[j].fuelA
                    screens[i].fuelS = dscreens[j].fuelS
                    screens[i].fuelR = dscreens[j].fuelR
                    screens[i].fuelIndex = dscreens[j].fuelIndex
                end
            end
        end
    end    
end

function SaveToDatabank()
    if db == nil then
        return
    else
        dscreens = {}
        for i,screen in ipairs(screens) do
            dscreens[i] = {}
            dscreens[i].id = screen.id
            dscreens[i].mode = screen.mode
            dscreens[i].submode = screen.submode
            dscreens[i].active = screen.active
            dscreens[i].fuelA = screen.fuelA
            dscreens[i].fuelS = screen.fuelS
            dscreens[i].fuelR = screen.fuelR
            dscreens[i].fuelIndex = screen.fuelIndex
        end

        db.clear()

        for _, data in pairs(SaveVars) do
            db.setStringValue(data, json.encode(_G[data]))
        end

    end
end

function InitiateScreens()
    if screens ~= nil and #screens > 0 then
        for i = 1, #screens, 1 do
            screens[i] = CreateClickAreasForScreen(screens[i])
        end
    end
end

function UpdateTypeData()
    FuelAtmosphericTanks = {}
    FuelSpaceTanks = {}
    FuelRocketTanks = {}

    FuelAtmosphericTotal = 0
    FuelAtmosphericCurrent = 0
    FuelSpaceTotal = 0
    FuelSpaceCurrent = 0
    FuelRocketCurrent = 0
    FuelRocketTotal = 0

    local weightAtmosphericFuel = 4
    local weightSpaceFuel = 6
    local weightRocketFuel = 0.8

    --[[
    (FuelMass * (1-.05 * <Container Optimization Talent Level>) * (1-.05 * <Fuel Tank Optimization Talent Level>)
    It just seems to be that the Container Optimization and Fuel Tank Optimization are not added together so the max is not -50% (25% from each skill from the base mass) but 43.75% So the Fuel Tank Optimization uses the container optimization result as it's base value
    ]]

    if StatContainerOptimization > 0 then
        weightAtmosphericFuel = weightAtmosphericFuel - 0.05 * StatContainerOptimization * weightAtmosphericFuel
        weightSpaceFuel = weightSpaceFuel - 0.05 * StatContainerOptimization * weightSpaceFuel
        weightRocketFuel = weightRocketFuel - 0.05 * StatContainerOptimization * weightRocketFuel
    end
    if StatFuelTankOptimization > 0 then
        weightAtmosphericFuel = weightAtmosphericFuel - 0.05 * StatFuelTankOptimization * weightAtmosphericFuel
        weightSpaceFuel = weightSpaceFuel - 0.05 * StatFuelTankOptimization * weightSpaceFuel
        weightRocketFuel = weightRocketFuel - 0.05 * StatFuelTankOptimization * weightRocketFuel
    end

    for i, id in ipairs(typeElements) do
        local idName = core.getElementNameById(id) or ""
        local idType = core.getElementTypeById(id) or ""
        -- local idTypeClean = idType:gsub("[%s%-]+", ""):lower()
        local idPos = core.getElementPositionById(id) or 0
        local idHP = core.getElementHitPointsById(id) or 0
        local idMaxHP = core.getElementMaxHitPointsById(id) or 0
        local idMass = core.getElementMassById(id) or 0

        local baseSize = ""
        local baseVol = 0
        local baseMass = 0
        local cMass = 0
        local cVol = 0

        if idType == "atmospheric fuel-tank" then
            if idMaxHP > 10000 then 
                baseSize = "L"
                baseMass = 5480
                baseVol = 12800
            elseif idMaxHP > 1300 then
                baseSize = "M"
                baseMass = 988.67
                baseVol = 1600
            elseif idMaxHP > 150 then
                baseSize = "S"
                baseMass = 182.67
                baseVol = 400
            else
                baseSize = "XS"
                baseMass = 35.03
                baseVol = 100
            end
            if StatAtmosphericFuelTankHandling > 0 then
                baseVol = 0.2 * StatAtmosphericFuelTankHandling * baseVol + baseVol
            end
            cMass = idMass - baseMass
            if cMass <=10 then cMass = 0 end
            cVol = string.format("%.0f", cMass / weightAtmosphericFuel)
            cPercent = string.format("%.1f", math.floor(100/baseVol * tonumber(cVol)))
            table.insert(FuelAtmosphericTanks, {
                type = 1,
                id = id,
                name = idName,
                maxhp = idMaxHP,
                hp = GetHPforElement(id),
                pos = idPos,
                size = baseSize,
                mass = baseMass,
                vol = baseVol,
                cvol = cVol,
                percent = cPercent
            })
            if idHP > 0 then
                FuelAtmosphericCurrent = FuelAtmosphericCurrent + cVol
            end
            FuelAtmosphericTotal = FuelAtmosphericTotal + baseVol
        elseif idType == "space fuel-tank" then
            if idMaxHP > 10000 then
                baseSize = "L"
                baseMass = 5480
                baseVol = 12800
            elseif idMaxHP > 1300 then
                baseSize = "M"
                baseMass = 988.67
                baseVol = 1600
            else
                baseSize = "S"
                baseMass = 182.67
                baseVol = 400
            end
            if StatSpaceFuelTankHandling > 0 then
                baseVol = 0.2 * StatSpaceFuelTankHandling * baseVol + baseVol
            end
            cMass = idMass - baseMass
            if cMass <=10 then cMass = 0 end
            cVol = string.format("%.0f", cMass / weightSpaceFuel)
            cPercent = string.format("%.1f", (100/baseVol * tonumber(cVol)))
            table.insert(FuelSpaceTanks, {
                type = 2,
                id = id,
                name = idName,
                maxhp = idMaxHP,
                hp = GetHPforElement(id),
                pos = idPos,
                size = baseSize,
                mass = baseMass,
                vol = baseVol,
                cvol = cVol,
                percent = cPercent
            })
            if idHP > 0 then
                FuelSpaceCurrent = FuelSpaceCurrent + cVol
            end
            FuelSpaceTotal = FuelSpaceTotal + baseVol
        elseif idType == "rocket fuel-tank" then
            if idMaxHP > 65000 then 
                baseSize = "L"
                baseMass = 25740
                baseVol = 50000
            elseif idMaxHP > 6000 then
                baseSize = "M"
                baseMass = 4720
                baseVol = 6400
            elseif idMaxHP > 700 then
                baseSize = "S"
                baseMass = 886.72
                baseVol = 800
            else
                baseSize = "XS"
                baseMass = 173.42
                baseVol = 400
            end
            if StatRocketFuelTankHandling > 0 then
                baseVol = 0.2 * StatRocketFuelTankHandling * baseVol + baseVol
            end
            cMass = idMass - baseMass
            if cMass <=10 then cMass = 0 end
            cVol = string.format("%.0f", cMass / weightRocketFuel)
            cPercent = string.format("%.1f", (100/baseVol * tonumber(cVol)))
            table.insert(FuelRocketTanks, {
                type = 3,
                id = id,
                name = idName,
                maxhp = idMaxHP,
                hp = GetHPforElement(id),
                pos = idPos,
                size = baseSize,
                mass = baseMass,
                vol = baseVol,
                cvol = cVol,
                percent = cPercent
            })
            if idHP > 0 then
                FuelRocketCurrent = FuelRocketCurrent + cVol
            end
            FuelRocketTotal = FuelRocketTotal + baseVol
        end

    end

    if FuelAtmosphericCurrent ~= formerFuelAtmosphericCurrent then
        SetRefresh("fuel")
        formerFuelAtmosphericCurrent = FuelAtmosphericCurrent
    end
    if FuelSpaceCurrent ~= formerFuelSpaceCurrent then
        SetRefresh("fuel")
        formerFuelSpaceCurrent = FuelSpaceCurrent
    end
    if FuelRocketCurrent ~= formerFuelRocketCurrent then
        SetRefresh("fuel")
        formerFuelRocketCurrent = FuelRocketCurrent
    end



end

function UpdateDamageData(initial)

    initial = initial or false

    if SimulationActive == true then return end

    local formerTotalShipHP = totalShipHP
    totalShipHP = 0
    totalShipMaxHP = 0
    totalShipIntegrity = 100
    damagedElements = {}
    brokenElements = {}
    healthyElements = {}
    if initial == true then
        typeElements = {}
    end

    ElementCounter = 0

    elementsIdList = core.getElementIdList()

    for i, id in pairs(elementsIdList) do
 
        ElementCounter = ElementCounter + 1

        local idName = core.getElementNameById(id)

        local idType = core.getElementTypeById(id)
        -- local idTypeClean = idType:gsub("[%s%-]+", ""):lower()
        local idPos = core.getElementPositionById(id)
        local idHP = core.getElementHitPointsById(id)
        local idMaxHP = core.getElementMaxHitPointsById(id)
        -- local idMass = core.getElementMassById(id)

        if SimulationMode == true then
            SimulationActive = true
            local dice = math.random(0, 10)
            if dice < 2 and #brokenElements < 30 then
                idHP = 0
            elseif dice >= 2 and dice < 4 and #damagedElements < 30 then
                idHP = math.random(1, math.ceil(idMaxHP))
            else
                idHP = idMaxHP
            end
        end

        totalShipHP = totalShipHP + idHP
        totalShipMaxHP = totalShipMaxHP + idMaxHP

        if idMaxHP - idHP > constants.epsilon then
            
            if idHP > 0 then
                table.insert(damagedElements, {
                    id = id,
                    name = idName,
                    type = idType,
                    counter = ElementCounter,
                    hp = idHP,
                    maxhp = idMaxHP,
                    missinghp = idMaxHP - idHP,
                    percent = math.ceil(100 / idMaxHP * idHP),
                    pos = idPos
                })
            else
                table.insert(brokenElements, {
                    id = id,
                    name = idName,
                    type = idType,
                    counter = ElementCounter,
                    hp = idHP,
                    maxhp = idMaxHP,
                    missinghp = idMaxHP - idHP,
                    percent = 0,
                    pos = idPos
                })
            end
        else
            table.insert(healthyElements, {
                    id = id,
                    name = idName,
                    type = idType,
                    counter = ElementCounter,
                    hp = idHP,
                    maxhp = idMaxHP,
                    pos = idPos
                })
            if id == highlightID then
                highlightID = 0
                highlightOn = false
                HideHighlight()
                hudSelectedIndex = 0
            end
        end

        if initial == true then
            if
                idType == "atmospheric fuel-tank" or
                idType == "space fuel-tank" or
                idType == "rocket fuel-tank" 
            then
               table.insert(typeElements, id)
            end
        end
    end

    SortDamageTables()

    rE = {}

    if #brokenElements > 0 then
        for _,v in ipairs(brokenElements) do
            table.insert(rE, {id=v.id, missinghp=v.missinghp, hp=v.hp, name=v.name, type=v.type, pos=v.pos})
        end
    end
    if #damagedElements > 0 then
        for _,v in ipairs(damagedElements) do
            table.insert(rE, {id=v.id, missinghp=v.missinghp, hp=v.hp, name=v.name, type=v.type, pos=v.pos})
        end
    end
    if #rE > 0 then
        table.sort(rE, function(a,b) return a.missinghp>b.missinghp end)
    end

    totalShipIntegrity = string.format("%2.0f", 100 / totalShipMaxHP * totalShipHP)

    if formerTotalShipHP ~= totalShipHP then
        forceDamageRedraw = true
        formerTotalShipHP = totalShipHP
    else
        forceDamageRedraw = false
    end
end

function GetHPforElement(id)
    for i,v in ipairs(brokenElements) do
        if v.id == id then
            return 0
        end
    end
    for i,v in ipairs(damagedElements) do
        if v.id == id then
            return v.hp
        end 
    end
    for i,v in ipairs(healthyElements) do
        if v.id == id then
            return v.maxhp
        end 
    end
end

function UpdateClickArea(candidate, newEntry, mode)
    for i, screen in ipairs(screens) do
        for k, v in pairs(screens[i].ClickAreas) do
            if v.id == candidate and v.mode == mode then
                screens[i].ClickAreas[k] = newEntry
            end
        end
    end
end

function AddClickArea(mode, newEntry)
    for i, screen in ipairs(screens) do
        if screens[i].mode == mode then
            table.insert(screens[i].ClickAreas, newEntry)
        end
    end
end

function AddClickAreaForScreenID(screenid, newEntry)
    for i, screen in ipairs(screens) do
        if screens[i].id == screenid then
            table.insert(screens[i].ClickAreas, newEntry)
        end
    end
end

function DisableClickArea(candidate, mode)
    UpdateClickArea(candidate, {
        id = candidate,
        mode = mode,
        x1 = -1,
        x2 = -1,
        y1 = -1,
        y2 = -1
    })
end

function SetRefresh(mode, submode)
    mode = mode or "all"
    submode = submode or "all"
    if screens ~= nil and #screens > 0 then
        for i = 1, #screens, 1 do
            if screens[i].mode == mode or mode == "all" then
                if screens[i].submode == submode or submode =="all" then
                    screens[i].refresh = true
                end
            end
        end
    end
end

function WipeClickAreasForScreen(screen)
    screen.ClickAreas = {}
    return screen
end

function CreateBaseClickAreas(screen)
    table.insert(screen.ClickAreas, {mode = "all", id = "ToggleHudMode", x1 = 1537, x2 = 1728, y1 = 1015, y2 = 1075} )
    table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "damage", x1 = 193, x2 = 384, y1 = 1015, y2 = 1075} )
    table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "damageoutline", x1 = 385, x2 = 576, y1 = 1015, y2 = 1075} )
    table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "fuel", x1 = 577, x2 = 768, y1 = 1015, y2 = 1075} )
    -- table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "flight", x1 = 769, x2 = 960, y1 = 1015, y2 = 1075} )
    -- table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "cargo", x1 = 961, x2 = 1152, y1 = 1015, y2 = 1075} )
    -- table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "agg", x1 = 1153, x2 = 1344, y1 = 1015, y2 = 1075} )
    -- table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "map", x1 = 1345, x2 = 1536, y1 = 1015, y2 = 1075} )
    table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "time", x1 = 0, x2 = 192, y1 = 1015, y2 = 1075} )
    table.insert(screen.ClickAreas, {mode = "all", id = "ButtonPress", param = "settings1", x1 = 1729, x2 = 1920, y1 = 1015, y2 = 1075} )
    return screen
end

function CreateClickAreasForScreen(screen)
    
    if screen == nil then return {} end

    if screen.mode == "flight" then
    elseif screen.mode == "damage" then        
        table.insert( screen.ClickAreas, {mode = "damage", id = "ToggleElementLabel", x1 = 70, x2 = 425, y1 = 325, y2 = 355} )
        table.insert( screen.ClickAreas, {mode = "damage", id = "ToggleElementLabel2", x1 = 980, x2 = 1400, y1 = 325, y2 = 355} )
    elseif screen.mode == "damageoutline" then
        table.insert(screen.ClickAreas, {mode = "damageoutline", id = "DMGOChangeView", param = "top", x1 = 60, x2 = 439, y1 = 150, y2 = 200} )
        table.insert(screen.ClickAreas, {mode = "damageoutline", id = "DMGOChangeView", param = "side", x1 = 440, x2 = 824, y1 = 150, y2 = 200} )
        table.insert(screen.ClickAreas, {mode = "damageoutline", id = "DMGOChangeView", param = "front", x1 = 825, x2 = 1215, y1 = 150, y2 = 200} )
        table.insert(screen.ClickAreas, {mode = "damageoutline", id = "DMGOChangeStretch", x1 = 1530, x2 = 1580, y1 = 150, y2 = 200} )
    elseif screen.mode == "fuel" then
    elseif screen.mode == "cargo" then
    elseif screen.mode == "agg" then
    elseif screen.mode == "map" then
    elseif screen.mode == "time" then
    elseif screen.mode == "settings1" then
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ToggleBackground", x1 = 75, x2 = 860, y1 = 170, y2 = 215} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "PreviousBackground", x1 = 75, x2 = 460, y1 = 235, y2 = 285} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "NextBackground", x1 = 480, x2 = 860, y1 = 235, y2 = 285} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "DecreaseOpacity", x1 = 75, x2 = 460, y1 = 300, y2 = 350} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "IncreaseOpacity", x1 = 480, x2 = 860, y1 = 300, y2 = 350} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ResetColors", x1 = 75, x2 = 860, y1 = 370, y2 = 415} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "PreviousColorID", x1 = 90, x2 = 140, y1 = 500, y2 = 550} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "NextColorID", x1 = 795, x2 = 845, y1 = 500, y2 = 550} )

        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosUp", param="1", x1 = 210, x2 = 290, y1 = 655, y2 = 700} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosUp", param="2", x1 = 300, x2 = 380, y1 = 655, y2 = 700} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosUp", param="3", x1 = 385, x2 = 465, y1 = 655, y2 = 700} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosUp", param="4", x1 = 470, x2 = 550, y1 = 655, y2 = 700} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosUp", param="5", x1 = 560, x2 = 640, y1 = 655, y2 = 700} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosUp", param="6", x1 = 645, x2 = 725, y1 = 655, y2 = 700} )

        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosDown", param="1", x1 = 210, x2 = 290, y1 = 740, y2 = 780} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosDown", param="2", x1 = 300, x2 = 380, y1 = 740, y2 = 780} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosDown", param="3", x1 = 385, x2 = 465, y1 = 740, y2 = 780} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosDown", param="4", x1 = 470, x2 = 550, y1 = 740, y2 = 780} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosDown", param="5", x1 = 560, x2 = 640, y1 = 740, y2 = 780} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ColorPosDown", param="6", x1 = 645, x2 = 725, y1 = 740, y2 = 780} )

        table.insert( screen.ClickAreas, {mode = "settings1", id = "ResetPosColor", x1 = 160, x2 = 340, y1 = 885, y2 = 935} )
        table.insert( screen.ClickAreas, {mode = "settings1", id = "ApplyPosColor", x1 = 355, x2 = 780, y1 = 885, y2 = 935} )

    elseif screen.mode == "startup" then
    end

    screen = CreateBaseClickAreas(screen)

    return screen
end

function CheckClick(x, y, HitTarget)
    x = x*1920
    y = y*1120
    HitTarget = HitTarget or ""
    HitPayload = {}
    -- PrintConsole("Clicked: "..x.." / "..y)
    if screens ~= nil and #screens > 0 then
        for i = 1, #screens, 1 do
            if screens[i].active == true and screens[i].element.getMouseX() ~= -1 and screens[i].element.getMouseY() ~= -1 then
               if HitTarget == "" then
                    for k, v in pairs(screens[i].ClickAreas) do
                        if v ~=nil and x >= v.x1 and x <= v.x2 and y >= v.y1 and y <= v.y2 then
                            HitTarget = v.id
                            HitPayload = v
                            break
                        end
                    end
                end
                if HitTarget == "ButtonPress" then
                    if screens[i].mode == HitPayload.param then
                        screens[i].mode = "startup"
                    else
                        screens[i].mode = HitPayload.param
                    end

                    if screens[i].mode == "damageoutline" then
                        if screens[i].submode == "" then
                            screens[i].submode = "top"
                        end
                    end
                    screens[i].refresh = true
                    screens[i].ClickAreas = {}
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "ToggleBackground" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if BackgroundMode == "" then
                        BackgroundSelected = 1
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    else
                        BackgroundSelected = 1
                        BackgroundMode = ""
                    end
                    for k, screen in pairs(screens) do
                        screens[k].refresh = true
                    end
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "PreviousBackground" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if BackgroundMode == "" then
                        BackgroundSelected = 1
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    else
                        if BackgroundSelected <= 1 then
                            BackgroundSelected = #backgroundModes
                        else
                            BackgroundSelected = BackgroundSelected - 1
                        end
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    end
                    for k, screen in pairs(screens) do
                        screens[k].refresh = true
                    end
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "NextBackground" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                     if BackgroundMode == "" then
                        BackgroundSelected = 1
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    else
                        if BackgroundSelected >= #backgroundModes then
                            BackgroundSelected = 1
                        else
                            BackgroundSelected = BackgroundSelected + 1
                        end
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    end
                    for k, screen in pairs(screens) do
                        screens[k].refresh = true
                    end
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "DecreaseOpacity" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if BackgroundModeOpacity>0.1 then
                        BackgroundModeOpacity = BackgroundModeOpacity - 0.05
                        for k, screen in pairs(screens) do
                            screens[k].refresh = true
                        end
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    end
                elseif HitTarget == "IncreaseOpacity" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if BackgroundModeOpacity<1.0 then
                        BackgroundModeOpacity = BackgroundModeOpacity + 0.05
                        for k, screen in pairs(screens) do
                            screens[k].refresh = true
                        end
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    end
                elseif HitTarget == "ResetColors" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then                
                    db.clear()
                    ColorPrimary = "FF6700"
                    ColorSecondary = "FFFFFF"
                    ColorTertiary = "000000"
                    ColorHealthy = "00FF00"
                    ColorWarning = "FFFF00"
                    ColorCritical = "FF0000"
                    ColorBackground = "000000"
                    ColorBackgroundPattern = "4f4f4f"
                    ColorFuelAtmospheric = "004444"
                    ColorFuelSpace = "444400"
                    ColorFuelRocket = "440044"
                    BackgroundMode = "deathstar"
                    BackgroundSelected = 1
                    BackgroundModeOpacity = 0.25
                    colorIDTable = {
                        [1] = {
                            id="ColorPrimary",
                            desc="Main HUD Color",
                            basec = "FF6700", 
                            newc = "FF6700"
                        },
                        [2] = {
                            id="ColorSecondary",
                            desc="Secondary HUD Color",
                            basec = "FFFFFF", 
                            newc = "FFFFFF"
                        },
                        [3] = { 
                            id="ColorTertiary",
                            desc="Tertiary HUD Color",
                            basec = "000000", 
                            newc = "000000"
                        },
                        [4] = { 
                            id="ColorHealthy",
                            desc="Color code for Healthy/Okay",
                            basec = "00FF00", 
                            newc = "00FF00"
                        },
                        [5] = { 
                            id="ColorWarning",
                            desc="Color code for Damaged/Warning",
                            basec = "FFFF00", 
                            newc = "FFFF00"
                        },
                        [6] = { 
                            id="ColorCritical",
                            desc="Color code for Broken/Critical",
                            basec = "FF0000", 
                            newc = "FF0000"
                        },
                        [7] = { 
                            id="ColorBackground",
                            desc="Background Color",
                            basec = "000000", 
                            newc = "000000"
                        },
                        [8] = { 
                            id="ColorBackgroundPattern",
                            desc="Background Pattern Color",
                            basec = "4F4F4F", 
                            newc = "4F4F4F"
                        },
                        [9] = { 
                            id="ColorFuelAtmospheric",
                            desc="Color for Atmo Fuel/Elements",
                            basec = "004444", 
                            newc = "004444"
                        },
                        [10] = { 
                            id="ColorFuelSpace",
                            desc="Color for Space Fuel/Elements",
                            basec = "444400", 
                            newc = "444400"
                        },
                        [11] = { 
                            id="ColorFuelRocket",
                            desc="Color for Rocket Fuel/Elements",
                            basec = "440044", 
                            newc = "440044"
                        }
                    }
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "PreviousColorID" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    colorIDIndex = colorIDIndex - 1
                    if colorIDIndex < 1 then colorIDIndex = #colorIDTable end
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif HitTarget == "NextColorID" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    colorIDIndex = colorIDIndex + 1
                    if colorIDIndex > #colorIDTable then colorIDIndex = 1 end
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif HitTarget == "ColorPosUp" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    local s = tonumber(string.sub(colorIDTable[colorIDIndex].newc, HitPayload.param, HitPayload.param),16)
                    s = s + 1
                    if s > 15 then s = 0 end
                    colorIDTable[colorIDIndex].newc = replace_char(HitPayload.param, colorIDTable[colorIDIndex].newc, hexTable[s+1])
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif HitTarget == "ColorPosDown" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    local s = tonumber(string.sub(colorIDTable[colorIDIndex].newc, HitPayload.param, HitPayload.param),16)
                    s = s - 1
                    if s < 0 then s = 15 end
                    colorIDTable[colorIDIndex].newc = replace_char(HitPayload.param, colorIDTable[colorIDIndex].newc, hexTable[s+1])
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif HitTarget == "ResetPosColor" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    colorIDTable[colorIDIndex].newc = colorIDTable[colorIDIndex].basec
                    _G[colorIDTable[colorIDIndex].id] = colorIDTable[colorIDIndex].basec
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "ApplyPosColor" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    _G[colorIDTable[colorIDIndex].id] = colorIDTable[colorIDIndex].newc
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif HitTarget == "DamagedPageDown" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    CurrentDamagedPage = CurrentDamagedPage + 1
                    if CurrentDamagedPage > math.ceil(#damagedElements / DamagePageSize) then
                        CurrentDamagedPage = math.ceil(#damagedElements / DamagePageSize)
                    end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif HitTarget == "DamagedPageUp" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    CurrentDamagedPage = CurrentDamagedPage - 1
                    if CurrentDamagedPage < 1 then CurrentDamagedPage = 1 end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif HitTarget == "BrokenPageDown" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    CurrentBrokenPage = CurrentBrokenPage + 1
                    if CurrentBrokenPage > math.ceil(#brokenElements / DamagePageSize) then
                        CurrentBrokenPage = math.ceil(#brokenElements / DamagePageSize)
                    end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif HitTarget == "BrokenPageUp" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    CurrentBrokenPage = CurrentBrokenPage - 1
                    if CurrentBrokenPage < 1 then CurrentBrokenPage = 1 end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif HitTarget == "DMGOChangeView" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    screens[i].submode = HitPayload.param
                    UpdateViewDamageoutline(screens[i])
                    SaveToDatabank()
                    SetRefresh("damageoutline", screens[i].submode)
                    RenderScreens("damageoutline", screens[i].submode)
                elseif HitTarget == "DMGOChangeStretch" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if DMGOStretch == true then
                        DMGOStretch = false
                    else
                        DMGOStretch = true
                    end
                    UpdateViewDamageoutline(screens[i])
                    SaveToDatabank()
                    SetRefresh("damageoutline")
                    RenderScreens("damageoutline")
                elseif HitTarget == "ToggleDisplayAtmosphere" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if screens[i].fuelA == true then
                        screens[i].fuelA = false
                    else
                        screens[i].fuelA = true
                    end
                    screens[i].fuelIndex = 1
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif HitTarget == "ToggleDisplaySpace" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if screens[i].fuelS == true then
                        screens[i].fuelS = false
                    else
                        screens[i].fuelS = true
                    end
                    screens[i].fuelIndex = 1
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif HitTarget == "ToggleDisplayRocket" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if screens[i].fuelR == true then
                        screens[i].fuelR = false
                    else
                        screens[i].fuelR = true
                    end
                    screens[i].fuelIndex = 1
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif HitTarget == "DecreaseFuelIndex" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    screens[i].fuelIndex = screens[i].fuelIndex - 1
                    if screens[i].fuelIndex < 1 then screens[i].fuelIndex = 1 end
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif HitTarget == "IncreaseFuelIndex" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    screens[i].fuelIndex = screens[i].fuelIndex + 1
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif HitTarget == "ToggleHudMode" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if HUDMode == true then
                        HUDMode = false
                        forceDamageRedraw = true
                        HudDeselectElement()
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    else
                        HUDMode = true
                        forceDamageRedraw = true
                        HudDeselectElement()
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    end
                elseif HitTarget == "ToggleSimulation" and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    CurrentDamagedPage = 1
                    CurrentBrokenPage = 1
                    if SimulationMode == true then
                        SimulationMode = false
                        SimulationActive = false
                        UpdateDamageData()
                        UpdateTypeData()
                        forceDamageRedraw = true
                        HudDeselectElement()
                        SetRefresh("damage")
                        SetRefresh("damageoutline")
                        SetRefresh("settings1")
                        SetRefresh("fuel")
                        SaveToDatabank()
                        RenderScreens()
                    else
                        SimulationMode = true
                        SimulationActive = false
                        UpdateDamageData()
                        UpdateTypeData()
                        forceDamageRedraw = true
                        HudDeselectElement()
                        SetRefresh("damage")
                        SetRefresh("damageoutline")
                        SetRefresh("settings1")
                        SetRefresh("fuel")
                        SaveToDatabank()
                        RenderScreens()
                    end
                elseif (HitTarget == "ToggleElementLabel" or HitTarget == "ToggleElementLabel2") and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    if UseMyElementNames == true then
                        UseMyElementNames = false
                        SetRefresh("damage")
                        RenderScreens("damage")
                    else
                        UseMyElementNames = true
                        SetRefresh("damage")
                        RenderScreens("damage")
                    end
                elseif (HitTarget == "SwitchScrapTier" or HitTarget == "SwitchScrapTier2") and (HitPayload.mode == screens[i].mode or HitPayload.mode == "all") then
                    ScrapTier = ScrapTier + 1
                    if ScrapTier > 4 then ScrapTier = 1 end
                    SetRefresh("damage")
                    RenderScreens("damage")
                end


            end
        end
    end
end

--[[ 4. RENDERING FUNCTIONS ]]

function GetContentFlight()
    local output = ""
    output = output .. GetHeader("Flight Data Report") ..
    [[
        
    ]]
    return output
end

function GetContentDamage()
    local output = ""
    if SimulationMode == true then 
        output = output .. GetHeader("Damage Report (Simulated damage)") .. [[]]
    else 
        output = output .. GetHeader("Damage Report") .. [[]]
    end
    output = output .. GetContentDamageScreen()
    return output
end

function GetContentDamageoutline(screen)
    UpdateDataDamageoutline()
    UpdateViewDamageoutline(screen)
    local output = ""
    output = output .. GetHeader("Damage Ship Outline Report") ..
    GetDamageoutlineShip() .. 
    [[<rect x=20 y=180 rx=5 ry=5 width=1880 height=840 fill=#000000 fill-opacity=0.5 style="stroke:#]]..ColorPrimary..[[;stroke-width:3;" />]]

    if screen.submode=="top" then
        output = output ..
            [[
              <rect class=xfill x=20 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mxx x=220 y=165>Top View</text>
              <rect class=xborder x=420 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=620 y=165>Side View</text>
              <rect class=xborder x=820 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=1020 y=165>Front View</text>
            ]]
    elseif screen.submode=="side" then
        output = output ..
            [[
              <rect class=xborder x=20 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=220 y=165>Top View</text>
              <rect class=xfill x=420 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mxx x=620 y=165>Side View</text>
              <rect class=xborder x=820 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=1020 y=165>Front View</text>
            ]]
    elseif screen.submode=="front" then
        output = output ..
            [[
              <rect class=xborder x=20 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=220 y=165>Top View</text>
              <rect class=xborder x=420 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=620 y=165>Side View</text>
              <rect class=xfill x=820 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mxx x=1020 y=165>Front View</text>
            ]]
    else
    end
    output = output .. [[<text class=f30exx x=1900 y=120>]]..#dmgoElements..[[ of ]]..ElementCounter..[[ shown</text>]]
    output = output .. [[<rect class=xborder x=1550 y=130 rx=5 ry=5 width=50 height=50 />]]
    if DMGOStretch == true then
        output = output .. [[<rect class=xfill x=1558 y=138 rx=5 ry=5 width=34 height=34 />]]
    end
    output = output .. [[<text class=f30exx x=1900 y=165>Stretch both axis</text>]]
    return output
end

function GetContentFuel(screen)

    if #FuelAtmosphericTanks < 1 and #FuelSpaceTanks < 1 and #FuelRocketTanks < 1 then return "" end

    local FuelTypes = 0
    local output = ""
    local addHeadline = {}

    FuelDisplay = { screen.fuelA, screen.fuelS, screen.fuelR }

    if FuelDisplay[1] == true and #FuelAtmosphericTanks > 0 then 
        table.insert(addHeadline, "Atmospheric")
        FuelTypes = FuelTypes + 1
    end
    if FuelDisplay[2] == true and #FuelSpaceTanks > 0 then 
        table.insert(addHeadline, "Space")
        FuelTypes = FuelTypes + 1
    end
    if FuelDisplay[3] == true and #FuelRocketTanks > 0 then 
        table.insert(addHeadline, "Rocket")
        FuelTypes = FuelTypes + 1
    end

    output = output .. GetHeader("Fuel Report ("..table.concat(addHeadline, ", ")..")") ..
    [[
    <style>
        .fuele{fill:#]]..ColorBackground..[[;}
        .fuela{fill:#]]..ColorFuelAtmospheric..[[;fill-opacity:1;}
        .fuels{fill:#]]..ColorFuelSpace..[[;fill-opacity:1;}
        .fuelr{fill:#]]..ColorFuelRocket..[[;fill-opacity:1;}

        .fuela2{fill:none;stroke:#]]..ColorFuelAtmospheric..[[;stroke-width:3px;opacity:1;}
        .fuels2{fill:none;stroke:#]]..ColorFuelSpace..[[;stroke-width:3px;opacity:1;}
        .fuelr2{fill:none;stroke:#]]..ColorFuelRocket..[[;stroke-width:3px;opacity:1;}

        .fuela3{fill:#]]..ColorFuelAtmospheric..[[;fill-opacity:0.1;}
        .fuels3{fill:#]]..ColorFuelSpace..[[;fill-opacity:0.1;}
        .fuelr3{fill:#]]..ColorFuelRocket..[[;fill-opacity:0.1;}

        .fuela4{fill:#]]..ColorFuelAtmospheric..[[;fill-opacity:1;}
        .fuels4{fill:#]]..ColorFuelSpace..[[;fill-opacity:1;}
        .fuelr4{fill:#]]..ColorFuelRocket..[[;fill-opacity:1;}
    </style> ]]

    local totalH = 150
    local counter = 0
    local tOffset = 0

    if FuelDisplay[1] == true and #FuelAtmosphericTanks > 0 then

        if FuelTypes == 1 then tOffset = 50
        elseif FuelTypes == 2 then tOffset = 6
        elseif FuelTypes == 3 then tOffset = 0
        end

        output = output .. [[
        <svg x=20 y=]]..(95+totalH/FuelTypes*counter)..[[ width=1880 height=]]..totalH/FuelTypes..[[>
            <rect class="fuele" width="100%" height="100%"/>
            <rect class="fuela" width="]]..math.floor(100/FuelAtmosphericTotal*FuelAtmosphericCurrent)..[[%" height="100%"/>
        </svg>]]

        output = output ..
        [[<text class=f25sxx x=40 y=]]..(130+totalH/FuelTypes*counter+tOffset)..[[>]]..
        GenerateCommaValue(FuelAtmosphericCurrent, true)..
        [[ of ]]..GenerateCommaValue(FuelAtmosphericTotal, true)..
        [[ | Total Atmospheric Fuel in ]]..#FuelAtmosphericTanks..[[ tank]]..(#FuelAtmosphericTanks==1 and "" or "s")..[[ (]]..math.floor(100/FuelAtmosphericTotal*FuelAtmosphericCurrent)..[[%)</text>]]
        counter = counter + 1
    end

    if FuelDisplay[2] == true and #FuelSpaceTanks > 0 then

        if FuelTypes == 1 then tOffset = 50
        elseif FuelTypes == 2 then tOffset = 6
        elseif FuelTypes == 3 then tOffset = 0
        end

        output = output .. [[
        <svg x=20 y=]]..(95+totalH/FuelTypes*counter)..[[ width=1880 height=]]..totalH/FuelTypes..[[>
            <rect class="fuele" width="100%" height="100%"/>
            <rect class="fuels" width="]]..math.floor(100/FuelSpaceTotal*FuelSpaceCurrent)..[[%" height="100%"/>
        </svg>]]

        output = output ..
        [[<text class=f25sxx x=40 y=]]..(130+totalH/FuelTypes*counter+tOffset)..[[>]]..
        GenerateCommaValue(FuelSpaceCurrent, true)..
        [[ of ]]..GenerateCommaValue(FuelSpaceTotal, true)..
        [[ | Total Space Fuel in ]]..#FuelSpaceTanks..[[ tank]]..(#FuelSpaceTanks==1 and "" or "s")..[[ (]]..math.floor(100/FuelSpaceTotal*FuelSpaceCurrent)..[[%)</text>]]
        counter = counter + 1
    end

    if FuelDisplay[3] == true and #FuelRocketTanks > 0 then

        if FuelTypes == 1 then tOffset = 50
        elseif FuelTypes == 2 then tOffset = 6
        elseif FuelTypes == 3 then tOffset = 0
        end

        output = output .. [[
        <svg x=20 y=]]..(95+totalH/FuelTypes*counter)..[[ width=1880 height=]]..totalH/FuelTypes..[[>
            <rect class="fuele" width="100%" height="100%"/>
            <rect class="fuelr" width="]]..math.floor(100/FuelRocketTotal*FuelRocketCurrent)..[[%" height="100%"/>
        </svg> ]]

        output = output ..
        [[<text class=f25sxx x=40 y=]]..(130+totalH/FuelTypes*counter+tOffset)..[[>]]..
        GenerateCommaValue(FuelRocketCurrent, true)..
        [[ of ]]..GenerateCommaValue(FuelRocketTotal, true)..
        [[ | Total Rocket Fuel in ]]..#FuelRocketTanks..[[ tank]]..(#FuelRocketTanks==1 and "" or "s")..[[ (]]..math.floor(100/FuelRocketTotal*FuelRocketCurrent)..[[%)</text>]]
    end

    output = output .. [[
    <svg x=20 y=95 width=1880 height=]]..totalH..[[>
        <rect class="xborder" width="100%" height="100%"/>
    </svg>
    ]]

    local DisplayTable = {}
    if screen.fuelIndex == nil or screen.fuelIndex < 1 then
        screen.fuelIndex = 1
    end

    if FuelDisplay[1] == true then
        for _,v in ipairs(FuelAtmosphericTanks) do
            table.insert(DisplayTable, v)
        end
    end
    if FuelDisplay[2] == true then
        for _,v in ipairs(FuelSpaceTanks) do
            table.insert(DisplayTable, v)
        end
    end
    if FuelDisplay[3] == true then
        for _,v in ipairs(FuelRocketTanks) do
            table.insert(DisplayTable, v)
        end
    end

    table.sort(DisplayTable, function(a,b) return a.type<b.type or (a.type == b.type and a.id<b.id) end)

    local cCounter = 0
    for i=screen.fuelIndex, screen.fuelIndex+6, 1 do
        if DisplayTable[i] ~= nil then
            local tank = DisplayTable[i]
            cCounter = cCounter + 1
            local colorChar = ""
            if tank.type == 1 then
                colorChar = "a"
            elseif tank.type == 2 then
                colorChar = "s"
            elseif tank.type == 3 then
                colorChar = "r"
            end
            

            local twidth = 1853/100
            if tank.percent == nil or tank.percent==0 then
                twidth = 0
            else
                twidth = twidth * tank.percent
            end
            if tank.cvol == nil then tank.cvol = 0 end
            if tank.name == nil then tank.name = "" end

            

            output = output .. [[
                <svg x=20 y=]]..(cCounter*100+220)..[[ width=1880 height=100 viewBox="0 0 1880 100">
                    <rect class="fuel]]..colorChar..[[3" x="13.5" y="9.5" width="1853" height="81"/>
                    <rect class="fuel]]..colorChar..[[4" x="13.5" y="9.5" width="]]..twidth..[[" height="81"/>
                    <rect class="fuel]]..colorChar..[[2" x="13.5" y="9.5" width="1853" height="81"/>]]
            if tank.hp == 0 then
                output = output .. [[<polygon class="cc" points="7 3 7 97 15 97 15 100 4 100 4 74.9 0 71.32 0 18.7 4 14.4 4 0 15 0 15 3 7 3"/><polygon class="cc" points="1873 3 1873 97 1865 97 1865 100 1876 100 1876 74.9 1880 71.32 1880 18.7 1876 14.4 1876 0 1865 0 1865 3 1873 3"/>]]
            elseif tank.maxhp - tank.hp > constants.epsilon then
                output = output .. [[<polygon class="cw" points="7 3 7 97 15 97 15 100 4 100 4 74.9 0 71.32 0 18.7 4 14.4 4 0 15 0 15 3 7 3"/><polygon class="cw" points="1873 3 1873 97 1865 97 1865 100 1876 100 1876 74.9 1880 71.32 1880 18.7 1876 14.4 1876 0 1865 0 1865 3 1873 3"/>]]
            else 
                output = output .. [[<polygon class="ch" points="7 3 7 97 15 97 15 100 4 100 4 74.9 0 71.32 0 18.7 4 14.4 4 0 15 0 15 3 7 3"/><polygon class="ch" points="1873 3 1873 97 1865 97 1865 100 1876 100 1876 74.9 1880 71.32 1880 18.7 1876 14.4 1876 0 1865 0 1865 3 1873 3"/>]]
            end
            if tank.hp == 0 then output = output .. [[<text class=f80mc x=60 y=82>]]..tank.size..[[</text>]]
            else output = output .. [[<text class=f80mxx07 x=60 y=82>]]..tank.size..[[</text>]]
            end

            if tank.hp == 0 then 
                output = output .. [[<text class=f60mc x=940 y=74>Broken</text>]] ..
                                   [[<text class=f25ec x=1860 y=60>0 of ]]..GenerateCommaValue(tank.vol)..[[</text>]]
            elseif tonumber(tank.percent) < 10 then 
                output = output .. [[<text class=f60mc x=940 y=74>]]..tank.percent..[[%</text>]] ..
                                   [[<text class=f25ec x=1860 y=60>]]..GenerateCommaValue(tank.cvol)..[[ of ]]..GenerateCommaValue(tank.vol)..[[</text>]]
            elseif tonumber(tank.percent) < 30 then 
                output = output .. [[<text class=f60mw x=940 y=74>]]..tank.percent..[[%</text>]] ..
                                   [[<text class=f25ew x=1860 y=60>]]..GenerateCommaValue(tank.cvol)..[[ of ]]..GenerateCommaValue(tank.vol)..[[</text>]]
            else output = 
                output .. [[<text class=f60mxx x=940 y=74>]]..tank.percent..[[%</text>]] ..
                          [[<text class=f25exx x=1860 y=60>]]..GenerateCommaValue(tank.cvol)..[[ of ]]..GenerateCommaValue(tank.vol)..[[</text>]]
            end

            output = output ..[[<text class=f25sxx x=140 y=60>]]..tank.name..[[</text>]]

            output = output .. [[</svg>]]

        end
    end



    if #FuelAtmosphericTanks > 0 then
        output = output .. [[<rect class=xborder x=20 y=260 rx=5 ry=5 width=50 height=50 />]]
        if FuelDisplay[1] == true then
            output = output .. [[<rect class=xfill x=28 y=268 rx=5 ry=5 width=34 height=34 />]]
        end
        output = output .. [[<text class=f25sx x=80 y=290>ATM</text>]]
        AddClickAreaForScreenID(screen.id, {mode = "fuel", id = "ToggleDisplayAtmosphere", x1 = 50, x2 = 100, y1 = 270, y2 = 320} )
    end

    if #FuelSpaceTanks > 0 then
        output = output .. [[<rect class=xborder x=170 y=260 rx=5 ry=5 width=50 height=50 />]]
        if FuelDisplay[2] == true then
            output = output .. [[<rect class=xfill x=178 y=268 rx=5 ry=5 width=34 height=34 />]]
        end
        output = output .. [[<text class=f25sx x=230 y=290>SPC</text>]]
        AddClickAreaForScreenID(screen.id, {mode = "fuel", id = "ToggleDisplaySpace", x1 = 200, x2 = 250, y1 = 270, y2 = 320} )
    end

    if #FuelRocketTanks > 0 then
        output = output .. [[<rect class=xborder x=320 y=260 rx=5 ry=5 width=50 height=50 />]]
        if FuelDisplay[3] == true then
            output = output .. [[<rect class=xfill x=328 y=268 rx=5 ry=5 width=34 height=34 />]]
        end
        output = output .. [[<text class=f25sx x=380 y=290>RKT</text>]]
        AddClickAreaForScreenID(screen.id, {mode = "fuel", id = "ToggleDisplayRocket", x1 = 350, x2 = 400, y1 = 270, y2 = 320} )
    end

    if screen.fuelIndex > 1 then
        output = output .. [[<svg x="1490" y="260">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]]..ColorPrimary..[[;" />
                                <svg x="80" y="15"><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
        AddClickAreaForScreenID(screen.id, {mode = "fuel", id = "DecreaseFuelIndex", x1 = 1470, x2 = 1670, y1 = 270, y2 = 320} )
    end

    if screen.fuelIndex+cCounter-1 < #DisplayTable then
        output = output .. [[<svg x="1700" y="260">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]]..ColorPrimary..[[;" />
                                <svg x="80" y="15"><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
        AddClickAreaForScreenID(screen.id, {mode = "fuel", id = "IncreaseFuelIndex", x1 = 1680, x2 = 1880, y1 = 270, y2 = 320} )
    end

    if cCounter > 0 then
        output = output .. [[<text class=f30mx x=960 y=300>]]..
                           #DisplayTable..
                           [[ Tank]]..(#DisplayTable == 1 and "" or "s")..
                           [[ (Showing ]]..screen.fuelIndex..[[ to ]]..(screen.fuelIndex+cCounter-1)..[[)</text>]]
    end

    return output
end

function GetContentCargo()
    local output = ""
    output = output .. GetHeader("Cargo Report") ..
    [[
        
    ]]
    return output
end

function GetContentAGG()
    local output = ""
    output = output .. GetHeader("Anti-Grav Control") ..
    [[
        
    ]]
    return output
end

function GetContentMap()
    local output = ""
    output = output .. GetHeader("Map Overview") ..
    [[
        
    ]]
    return output
end

function GetContentTime()
    local output = ""
    output = output .. GetHeader("Time") .. epochTime()
    output = output ..
                [[<svg x=460 y=370 width=120 height=150 viewBox="0 0 24 30">
                    <rect x=0 y=13 width=4 height=5 fill=#]]..ColorPrimary..[[>
                      <animate attributeName="height" attributeType="XML"
                        values="5;21;5" 
                        begin="0s" dur="1s" repeatCount="indefinite" />
                      <animate attributeName="y" attributeType="XML"
                        values="13; 5; 13"
                        begin="0s" dur="1s" repeatCount="indefinite" />
                    </rect>
                    <rect x=10 y=13 width=4 height=5 fill=#]]..ColorPrimary..[[>
                      <animate attributeName="height" attributeType="XML"
                        values="5;21;5" 
                        begin="0.15s" dur="1s" repeatCount="indefinite" />
                      <animate attributeName="y" attributeType="XML"
                        values="13; 5; 13"
                        begin="0.15s" dur="1s" repeatCount="indefinite" />
                    </rect>
                    <rect x=20 y=13 width=4 height=5 fill=#]]..ColorPrimary..[[>
                      <animate attributeName="height" attributeType="XML"
                        values="5;21;5" 
                        begin="0.3s" dur="1s" repeatCount="indefinite" />
                      <animate attributeName="y" attributeType="XML"
                        values="13; 5; 13"
                        begin="0.3s" dur="1s" repeatCount="indefinite" />
                    </rect>
                  </svg>]]
    return output
end

function GetContentSettings1()
    local output = ""
    output = output .. GetHeader("Settings") .. [[<rect class="xfill" x="40" y="150" rx="5" ry="5" width="820" height="50" />]]
    if BackgroundMode=="" then
        output = output ..[[<text class="f30mxxx" x="440" y="185">Activate background</text>]]
    else
        output = output ..[[<text class="f30mxxx" x="440" y="185">Deactivate background (']]..BackgroundMode..[[', ]]..string.format("%.0f",BackgroundModeOpacity*100)..[[%)</text>]]
    end
    output = output ..[[
        <rect class="xfill" x="40" y="220" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="240" y="255">Previous background</text>
        <rect class="xfill" x="460" y="220" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="660" y="255">Next background</text>

        <rect class="xfill" x="40" y="290" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="240" y="325">Decrease Opacity</text>
        <rect class="xfill" x="460" y="290" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="660" y="325">Increase Opacity</text>
    ]]

    output = output ..
        [[<rect class="xfill" x="40" y="360" rx="5" ry="5" width="820" height="50" />]] ..
        [[<text class="f30mxxx" x="440" y="395">Reset background and all colors</text>]]

    output = output ..
        [[<svg x=40 y=430 width=820 height=574>]] ..
            [[<rect class="xborder" x="0" y="0" rx="5" ry="5" width="820" height="574" stroke-dasharray="2 5" />]] ..
            [[<rect class="xborder" x="0" y="0" rx="5" ry="5" width="820" height="50" />]] ..
            [[<text class="f30mxx" x="410" y="35">Select and change any of the ]]..#colorIDTable..[[ HUD colors</text>]] ..
            [[<rect class="xfill" x="20" y="70" rx="5" ry="5" width="50" height="50" />]] ..
                [[<svg x=32 y=74><path d="M1,23.13,16.79,40.25a3.23,3.23,0,0,0,5.6-2.19V3.24a3.23,3.23,0,0,0-5.6-2.19L1,18.17A3.66,3.66,0,0,0,1,23.13Z" transform="translate(0.01 -0.01)"/></svg>]] ..
            [[<rect class="xfill" x="750" y="70" rx="5" ry="5" width="50" height="50" />]] ..
                [[<svg x=764 y=74><path d="M21.42,18.17,5.59,1.05A3.23,3.23,0,0,0,0,3.24V38.06a3.23,3.23,0,0,0,5.6,2.19L21.42,23.13A3.66,3.66,0,0,0,21.42,18.17Z" transform="translate(0.01 -0.01)"/></svg>]] ..
            [[<rect class="xborder" x="90" y="70" rx="5" ry="5" width="640" height="50" />]] ..
            [[<text class="f30mxx" x="410" y="105">]]..colorIDTable[colorIDIndex].desc..[[</text>]] ..
            [[<rect style="fill: #]].._G[colorIDTable[colorIDIndex].id]..[[; fill-opacity: 1; stroke: #]]..ColorPrimary..[[; stroke-width:3;" x="90" y="140" rx="5" ry="5" width="640" height="70" />]] ..
            [[<text class="f20sxx" x="100" y="160">Current color</text>]] ..
            [[<svg x=90 y=230 width=640 height=140>]] ..

                [[<rect class=xbfill x=55 y=5 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=75 y=15><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=145 y=5 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=165 y=15><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=235 y=5 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=255 y=15><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=325 y=5 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=345 y=15><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=415 y=5 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=435 y=15><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=505 y=5 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=525 y=15><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>]] ..

                [[<text class=f60mx x=27 y=92>#</text>]] ..

                [[<rect class=xborder x=55 y=50 rx=5 ry=5 width=80 height=40 />]] ..
                [[<text class=f30mxx x=95 y=80>]]..string.sub(colorIDTable[colorIDIndex].newc,1,1)..[[</text>]] ..
                [[<rect class=xborder x=145 y=50 rx=5 ry=5 width=80 height=40 />]] ..
                [[<text class=f30mxx x=185 y=80>]]..string.sub(colorIDTable[colorIDIndex].newc,2,2)..[[</text>]] ..
                [[<rect class=xborder x=235 y=50 rx=5 ry=5 width=80 height=40 />]] ..
                [[<text class=f30mxx x=275 y=80>]]..string.sub(colorIDTable[colorIDIndex].newc,3,3)..[[</text>]] ..
                [[<rect class=xborder x=325 y=50 rx=5 ry=5 width=80 height=40 />]] ..
                [[<text class=f30mxx x=365 y=80>]]..string.sub(colorIDTable[colorIDIndex].newc,4,4)..[[</text>]] ..
                [[<rect class=xborder x=415 y=50 rx=5 ry=5 width=80 height=40 />]] ..
                [[<text class=f30mxx x=455 y=80>]]..string.sub(colorIDTable[colorIDIndex].newc,5,5)..[[</text>]] ..
                [[<rect class=xborder x=505 y=50 rx=5 ry=5 width=80 height=40 />]] ..
                [[<text class=f30mxx x=545 y=80>]]..string.sub(colorIDTable[colorIDIndex].newc,6,6)..[[</text>]] ..

                [[<rect class=xbfill x=55 y=95 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=75 y=105><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=145 y=95 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=165 y=105><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=235 y=95 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=255 y=105><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=325 y=95 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=345 y=105><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=415 y=95 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=435 y=105><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>]] ..
                [[<rect class=xbfill x=505 y=95 rx=5 ry=5 width=80 height=40 />]] ..
                    [[<svg x=525 y=105><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>]] ..

            [[</svg>]] ..
            [[<rect style="fill: #]]..colorIDTable[colorIDIndex].newc..[[; fill-opacity: 1; stroke: #]]..ColorPrimary..[[; stroke-width:3;" x="90" y="390" rx="5" ry="5" width="640" height="70" />]] ..
            [[<text class=f20sxx x=100 y=410>New color</text>]] ..
            [[<rect class=xfill x=290 y=480 rx=5 ry=5 width=440 height=50 />]] ..
            [[<text class=f30mxxx x=510 y=515>Apply new color</text>]] ..
            [[<rect class=xfill x=90 y=480 rx=5 ry=5 width=185 height=50 />]] ..
            [[<text class=f30mxxx x=182 y=515>Reset</text>]] ..
        [[</svg>]]

    output = output ..
            [[<svg x=940 y=150 width=936 height=774>]] ..
                [[<rect class=xborder x=0 y=0 rx=5 ry=5 width=936 height=774 stroke-dasharray="2 5" />]] ..
                [[<rect class=xborder x=0 y=0 rx=5 ry=5 width=936 height=50 />]] ..
                [[<text class=f30mxx x=468 y=35>Explanation / Hints</text>]] ..
                [[<text class=f30mxx x=468 y=400>Coming soon.</text>]]


    output = output .. [[</svg>]]

    if SimulationMode == true then
        output = output .. [[<rect class="cfill" x="940" y="954" rx="5" ry="5" width="936" height="50" /><text class="f30mxxx" x="1408" y="989">Simulating Damage to elements</text>]]
        AddClickArea("settings1", { id = "ToggleSimulation", mode ="settings1", x1 = 940, x2 = 1850, y1 = 919, y2 = 969 })
    else
        output = output .. [[<rect class="xfill" x="940" y="954" rx="5" ry="5" width="936" height="50" /><text class="f30mxxx" x="1408" y="989">Simulate Damage to elements</text>]]
        AddClickArea("settings1", { id = "ToggleSimulation", mode ="settings1", x1 = 940, x2 = 1850, y1 = 919, y2 = 969 })
    end

    return output
end

function GetContentStartup()
    local output = ""
    output = output .. GetElementLogo(812, 380, "f", "f", "f")
    if YourShipsName == "Enter here" then
        output = output .. [[<g><text class="f160m" x="960" y="330">Spaceship ID ]]..ShipID..[[</text><animate attributeName="fill" values="#]]..ColorPrimary..[[;#]]..ColorSecondary..[[;#]]..ColorPrimary..[[" dur="30s" repeatCount="indefinite" /></g>]]
    else
        output = output .. [[<g><text class="f160m" x="960" y="330">]]..YourShipsName..[[</text><animate attributeName="fill" values="#]]..ColorPrimary..[[;#]]..ColorSecondary..[[;#]]..ColorPrimary..[[" dur="30s" repeatCount="indefinite" /></g>]]
    end
    if ShowWelcomeMessage == true then output = output .. [[<text class="f50mx" x="960" y="750">Greetings, Commander ]]..PlayerName..[[.</text>]] end
    if #Warnings > 0 then
        output = output .. [[<text class="f25mc" x="960" y="880">Warning: ]]..(table.concat(Warnings, " "))..[[</text>]]
    end
    output = output .. [[<text class="f30mxx" style="fill-opacity:0.2" x="960" y="1000">Damage Report v]]..VERSION..[[, by Scion Interstellar, DorianGray - Discord: Dorian Gray#2623. Under GNU Public License 3.0.</text>]]
    return output
end

function RenderScreen(screen, contentToRender)
    if contentToRender == nil then
        PrintConsole("ERROR: contentToRender is nil.")
        unit.exit()
    end
 
    CreateClickAreasForScreen(screen)

    local output =""
    output = output .. [[
    <style>
      body{
        background-color: #]]..ColorBackground..[[; ]]..GetContentBackground(BackgroundMode)..[[
      }
      .screen { width: 1920px; height: 1120px; }
      .main { width: 1920px; height: 1040px; }
      .menu { width: 1920px; height: 70px; stroke: #]]..ColorPrimary..[[; stroke-width: 3; }

      .xline { stroke: #]]..ColorPrimary..[[; stroke-width: 3;}
      .daline { stroke: #]]..ColorSecondary..[[; stroke-dasharray: 2 5; }
      .ll { fill: #FF55FF; stroke: #FF0000}
      .xborder { fill:#]]..ColorPrimary..[[; fill-opacity:0.05; stroke: #]]..ColorPrimary..[[; stroke-width:3; }
      .xfill { fill:#]]..ColorPrimary..[[; fill-opacity:1; }
      .xbfill { fill:#]]..ColorPrimary..[[; fill-opacity:1; stroke: #]]..ColorPrimary..[[; stroke-width:3; }
      .cfill { fill:#]]..ColorCritical..[[; fill-opacity:1; }

      .hlrect { fill: #]]..ColorPrimary..[[; }
      .cx { fill: #]]..ColorPrimary..[[; }
      .ch { fill: #]]..ColorHealthy..[[; }
      .cw { fill: #]]..ColorWarning..[[; } 
      .cc { fill: #]]..ColorCritical..[[; }

      .f { fill:#]]..ColorPrimary..[[; }
      .f2 { fill:#]]..ColorSecondary..[[; }
      .f3 { fill:#]]..ColorTertiary..[[; }
      .f250mx { font-size: 250px; text-anchor: middle; fill: #]]..ColorPrimary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f160m { font-size: 160px; text-anchor: middle; font-family: Impact, Charcoal, sans-serif; }
      .f160mx { font-size: 160px; text-anchor: middle; fill: #]]..ColorPrimary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f100mx { font-size: 100px; text-anchor: middle; fill: #]]..ColorPrimary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f80mxx07 { opacity:0.7; font-size: 80px; text-anchor: middle; fill: #]]..ColorSecondary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f80mc { opacity:1; font-size: 80px; text-anchor: middle; fill: #]]..ColorCritical..[[; font-family: Impact, Charcoal, sans-serif; }
      .f60s { font-size: 60px; text-anchor: start; }
      .f60m { font-size: 60px; text-anchor: middle; }
      .f60e { font-size: 60px; text-anchor: end; }
      .f60mx { font-size: 60px; text-anchor: middle; fill: #]]..ColorPrimary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f60mxx { font-size: 60px; text-anchor: middle; fill: #]]..ColorSecondary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f60mxx07 { opacity:0.7; font-size: 60px; text-anchor: middle; fill: #]]..ColorSecondary..[[; font-family: Impact, Charcoal, sans-serif; }
      .f60mc { opacity:1; font-size: 60px; text-anchor: middle; fill: #]]..ColorCritical..[[; font-family: Impact, Charcoal, sans-serif; }
      .f60mw { opacity:1; font-size: 60px; text-anchor: middle; fill: #]]..ColorWarning..[[; font-family: Impact, Charcoal, sans-serif; }
      .f50m { font-size: 50px; text-anchor: middle; }
      .f50sxx { font-size: 50px; text-anchor: start; fill: #]]..ColorSecondary..[[; }
      .f50mx { font-size: 50px; fill: #]]..ColorPrimary..[[; fill-opacity: 1; text-anchor: middle; }
      .f50mx02 { font-size: 50px; fill: #]]..ColorPrimary..[[; fill-opacity: 0.2; text-anchor: middle; }
      .f50mxx { font-size: 50px; fill: #]]..ColorSecondary..[[; fill-opacity: 1; text-anchor: middle }
      .f36mxx { font-size: 36px; fill: #]]..ColorSecondary..[[; fill-opacity: 1; text-anchor: middle }
      .f30mx { font-size: 30px; fill: #]]..ColorPrimary..[[; fill-opacity: 1; text-anchor: middle; }
      .f30sxx { font-size: 30px; fill: #]]..ColorSecondary..[[; fill-opacity: 1; text-anchor: start; }
      .f30exx { font-size: 30px; fill: #]]..ColorSecondary..[[; fill-opacity: 1; text-anchor: end; }
      .f30mxx { font-size: 30px; fill: #]]..ColorSecondary..[[; fill-opacity: 1; text-anchor: middle; }
      .f30mxxx { font-size: 30px; fill: #]]..ColorTertiary..[[; fill-opacity: 1; text-anchor: middle; }
      .f25sx { font-size: 25px; text-anchor: start; fill: #]]..ColorPrimary..[[; }
      .f25exx { font-size: 25px; text-anchor: end; fill: #]]..ColorSecondary..[[; }
      .f25sxx { font-size: 25px; text-anchor: start; fill: #]]..ColorSecondary..[[; }
      .f25mw { font-size: 25px; text-anchor: middle; fill: #]]..ColorWarning..[[; }
      .f25mr { font-size: 25px; text-anchor: middle; fill: #]]..ColorCritical..[[; }
      .f25ew { font-size: 25px; text-anchor: end; fill: #]]..ColorWarning..[[; }
      .f25ec { font-size: 25px; text-anchor: end; fill: #]]..ColorCritical..[[; }
      .f25mc { font-size: 25px; text-anchor: middle; fill: #]]..ColorCritical..[[; }
      .f20sxx { font-size: 20px; text-anchor: start; fill: #]]..ColorSecondary..[[; }
      .f20mxx { font-size: 20px; text-anchor: middle; fill: #]]..ColorSecondary..[[; }
    </style>
    <svg class=screen viewBox="0 0 1920 1120">
      <svg class=main x=0 y=0>]]
        
        output = output .. contentToRender

        if screen.mode == "startup" then
            output = output .. [[<rect class=xborder x=0 y=0 rx=5 ry=5 width=1920 height=1040 />]]
        else
            output = output .. [[<rect class=xborder x=0 y=70 rx=5 ry=5 width=1920 height=970 />]]
        end

        output = output .. [[
      </svg>
      <svg class=menu x=0 y=1050>
        <rect class=xline x=0 y=0 rx=5 ry=5 width=1920 height=70 fill=#]]..ColorBackground..[[ />
        <text class=f50mx x=96 y=50>TIME</text>
        <text class=f50mx x=288 y=50>DMG</text>
        <text class=f50mx x=480 y=50>DMGO</text>
        <text class=f50mx x=672 y=50>FUEL</text>]]

        --[[
        <text class=f50mx x=672 y=50>FUEL</text>
        <text class=f50mx x=864 y=50>FLGT</text>
        <text class=f50mx x=1056 y=50>CRGO</text>
        <text class=f50mx x=1248 y=50>AGG</text>
        <text class=f50mx x=1440 y=50>MAP</text>
        ]]

        output = output .. [[
        <text class=f50mx x=1632 y=50>HUD</text>
        <text class=f50mx x=1824 y=50>SETS</text>
        <line class=xline x1=192 y1=10 x2=192 y2=60 />
        <line class=xline x1=384 y1=10 x2=384 y2=60 />
        <line class=xline x1=576 y1=10 x2=576 y2=60 />
        <line class=xline x1=768 y1=10 x2=768 y2=60 />]] ..
        -- [[<line class=xline x1=960 y1=10 x2=960 y2=60 />
        -- <line class=xline x1=1152 y1=10 x2=1152 y2=60 />
        ---<line class=xline x1=1344 y1=10 x2=1344 y2=60 />]] ..
        [[<line class=xline x1=1536 y1=10 x2=1536 y2=60 />
        <line class=xline x1=1728 y1=10 x2=1728 y2=60 />]]
        if HUDMode == true then
            output = output .. [[
            <rect class=hlrect x=1544 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1632 y=50>HUD</text>
            ]]
        end
        if screen.mode == "damage" then
            output = output .. [[
            <rect class=hlrect x=200 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=288 y=50>DMG</text>
            ]]
        elseif screen.mode == "damageoutline" then
            output = output .. [[
            <rect class=hlrect x=392 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=480 y=50>DMGO</text>
            ]]
        elseif screen.mode == "fuel" then
            output = output .. [[
            <rect class=hlrect x=584 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=672 y=50>FUEL</text>
            ]]
        elseif screen.mode == "flight" then
            output = output .. [[
            <rect class=hlrect x=776 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=864 y=50>FLGT</text>
            ]]
        elseif screen.mode == "cargo" then
            output = output .. [[
            <rect class=hlrect x=968 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1056 y=50>CRGO</text>
            ]]
        elseif screen.mode == "agg" then
            output = output .. [[
            <rect class=hlrect x=1160 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1248 y=50>AGG</text>
            ]]
        elseif screen.mode == "map" then
            output = output .. [[
            <rect class=hlrect x=1352 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1440 y=50>MAP</text>
            ]]
        elseif screen.mode == "time" then
            output = output .. [[
            <rect class=hlrect x=8 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=96 y=50>TIME</text>
            ]]
        elseif screen.mode == "settings1" then
            output = output .. [[
            <rect class=hlrect x=1736 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1824 y=50>SETS</text>
            ]]
        end
      output = output .. [[</svg>]]
    output = output .. [[</svg>]]
     
    -- Center:

    -- <line style="stroke: white;" class="xline" x1="960" y1="0" x2="960" y2="1040" />
    -- <line style="stroke: white;" class="xline" x1="0" y1="520" x2="1920" y2="520" />
    -- <line style="stroke: white;" class="xline" x1="960" y1="0" x2="960" y2="1120" />
    -- <line style="stroke: white;" class="xline" x1="0" y1="560" x2="1920" y2="560" />

    local outputLength = string.len(output)
    -- PrintConsole("Render: "..screen.mode.." ("..outputLength.." chars)")
    screen.element.setSVG(output)
end

function RenderScreens(onlymode, onlysubmode)

    onlymode = onlymode or "all"
    onlysubmode = onlysubmode or "all"

    if screens ~= nil and #screens > 0 then

        local contentFlight = ""
        local contentDamage = ""
        local contentDamageoutlineTop = ""
        local contentDamageoutlineSide = ""
        local contentDamageoutlineFront = ""
        local contentFuel = ""
        local contentCargo = ""
        local contentAGG = ""
        local contentMap = ""
        local contentTime = ""
        local contentSettings1 = ""
        local contentStartup = ""

        for k,screen in pairs(screens) do
            if screen.refresh == true then
                local contentToRender = ""

                if screen.mode == "flight" and (onlymode =="flight" or onlymode =="all") then
                    if contentFlight == "" then contentFlight = GetContentFlight() end
                    contentToRender = contentFlight
                elseif screen.mode == "damage" and (onlymode =="damage" or onlymode =="all") then
                    if contentDamage == "" then contentDamage = GetContentDamage() end
                    contentToRender = contentDamage
                elseif screen.mode == "damageoutline" and (onlymode =="damageoutline" or onlymode =="all") then
                    if screen.submode == "" then
                        screen.submode = "top"
                        screens[k].submode = "top"
                    end
                    if screen.submode == "top" and (onlysubmode == "top" or onlysubmode == "all") then
                        if contentDamageoutlineTop == "" then contentDamageoutlineTop = GetContentDamageoutline(screen) end
                        contentToRender = contentDamageoutlineTop
                    end
                    if screen.submode == "side" and (onlysubmode == "side" or onlysubmode == "all") then
                        if contentDamageoutlineSide == "" then contentDamageoutlineSide = GetContentDamageoutline(screen) end
                        contentToRender = contentDamageoutlineSide
                    end
                    if screen.submode == "front" and (onlysubmode == "front" or onlysubmode == "all") then 
                        if contentDamageoutlineFront == "" then contentDamageoutlineFront = GetContentDamageoutline(screen) end
                        contentToRender = contentDamageoutlineFront
                    end
                elseif screen.mode == "fuel" and (onlymode =="fuel" or onlymode =="all") then
                    screen = WipeClickAreasForScreen(screens[k])
                    contentToRender = GetContentFuel(screen)
                elseif screen.mode == "cargo" and (onlymode =="cargo" or onlymode =="all") then
                    if contentCargo == "" then contentCargo = GetContentCargo() end
                    contentToRender = contentCargo
                elseif screen.mode == "agg" and (onlymode =="agg" or onlymode =="all") then
                    if contentAGG == "" then contentAGG = GetContentAGG() end
                    contentToRender = contentAGG
                elseif screen.mode == "map" and (onlymode =="map" or onlymode =="all") then
                    if contentMap == "" then contentMap = GetContentMap() end
                    contentToRender = contentMap
                elseif screen.mode == "time" and (onlymode =="time" or onlymode =="all") then
                    if contentTime == "" then contentTime = GetContentTime() end
                    contentToRender = contentTime
                elseif screen.mode == "settings1" and (onlymode =="settings1" or onlymode =="all") then
                    if contentSettings1 == "" then contentSettings1 = GetContentSettings1() end
                    contentToRender = contentSettings1
                elseif screen.mode == "startup" and (onlymode =="startup" or onlymode =="all") then
                    if contentStartup == "" then contentStartup = GetContentStartup() end
                    contentToRender = contentStartup
                else
                    contentToRender = "Invalid screen mode. ('"..screen.mode.."')"
                end

                if contentToRender ~= "" then
                    RenderScreen(screen, contentToRender)
                else
                    DrawCenteredText("ERROR: No contentToRender delivered for "..screen.mode)
                    PrintConsole("ERROR: No contentToRender delivered for "..screen.mode)
                    unit.exit()
                end
                screens[k].refresh = false
            end
        end
    end

    if HUDMode == true then
         system.setScreen(GetContentDamageHUDOutput())
         system.showScreen(1)
    else
         system.showScreen(0)
    end

end

function OnTickData(initial)
    if formerTime + 60 < system.getTime() then
        SetRefresh("time")
    end
    totalShipMass = core.getConstructMass()
    if formerTotalShipMass ~= totalShipMass then
        UpdateDamageData(true)
        UpdateTypeData()
        SetRefresh()
        formerTotalShipMass = totalShipMass
    else
        UpdateDamageData(initial)
        UpdateTypeData()
    end
    RenderScreens()
end

--[[ 5. EXECUTION ]]

unit.hide()
ClearConsole()
PrintConsole("DAMAGE REPORT v"..VERSION.." STARTED", true)
InitiateSlots()
LoadFromDatabank()
SwitchScreens("on")
InitiateScreens()

if core == nil then
    PrintConsole("ERROR: Connect the core to the programming board.")
    unit.exit()
else
    OperatorID = unit.getMasterPlayerId()
    OperatorData = database.getPlayer(OperatorID)
    PlayerName = OperatorData["name"]
    ShipID = core.getConstructId()
end

if db == nil then
    table.insert(Warnings, "No databank connected, won't save/load settings.")
end

if YourShipsName == "Enter here" then
    table.insert(Warnings, "No ship name set in LUA settings.")
end

if SkillRepairToolEfficiency == 0 and SkillRepairToolOptimization == 0 and StatFuelTankOptimization == 0 and StatContainerOptimization ==0 and 
    StatAtmosphericFuelTankHandling == 0 and StatSpaceFuelTankHandling == 0 and StatRocketFuelTankHandling ==0 then
    table.insert(Warnings, "No talents/stats set in LUA settings.")
end

if SkillRepairToolEfficiency < 0 or SkillRepairToolOptimization < 0 or StatFuelTankOptimization < 0 or StatContainerOptimization < 0 or 
    StatAtmosphericFuelTankHandling < 0 or StatSpaceFuelTankHandling < 0 or StatRocketFuelTankHandling < 0 or 
    SkillRepairToolEfficiency > 5 or SkillRepairToolOptimization > 5 or StatFuelTankOptimization > 5 or StatContainerOptimization > 5 or
    StatAtmosphericFuelTankHandling > 5 or StatSpaceFuelTankHandling > 5 or StatRocketFuelTankHandling > 5 then
        PrintConsole("ERROR: Talents/stats can only range from 0 to 5. Please set correctly in LUA settings and reactivate script.")
        unit.exit()
end

if screens == nil or #screens == 0 then
    HUDMode = true
    PrintConsole("Warning: No screens connected. Entering HUD mode only.")
end

OnTickData(true)

unit.setTimer('UpdateData', UpdateDataInterval)
unit.setTimer('UpdateHighlight', HighlightBlinkingInterval)