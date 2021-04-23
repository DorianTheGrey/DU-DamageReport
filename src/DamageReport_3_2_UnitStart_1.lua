--[[
    Damage Report 3.2
    A LUA script for Dual Universe

    Created By Dorian Gray
    Ingame: DorianGray
    Discord: Dorian Gray#2623

    You can find/update this script on GitHub. Explanations, installation and usage information as well as screenshots can be found there too.
    GitHub: https://github.com/DorianTheGrey/DU-DamageReport

    GNU Public License 3.0. Use whatever you want, be so kind to leave credit.
    
    Credits & thanks:
        Thanks to Bayouking1 and kalazzerx for managing their forks of this script during my long absence to support the community. :)
        Thanks to Bayouking1 for fixing rocket fuel calculations.
        Thanks to NovaQuark for creating the MMO of the century.
        Thanks to Jericho, Dmentia and Archaegeo for learning a lot from their fine scripts.
        Thanks to TheBlacklist for testing and wonderful suggestions.
        SVG patterns by Hero Patterns.
        DU atlas data from Jayle Break.
        
]]

 --[[ 1. USER DEFINED VARIABLES ]] YourShipsName = "Enter here" -- export Enter your ship name here if you want it displayed instead of the ship's ID. YOU NEED TO LEAVE THE QUOTATION MARKS.

SkillRepairToolEfficiency = 0 -- export Enter (0-5) your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Efficiency"
SkillRepairToolOptimization = 0 -- export Enter your talent "Mining and Inventory -> Equipment Manager -> Repair Tool Optimization"

StatAtmosphericFuelTankHandling = 0 -- export (0-5) Enter the LEVEL OF YOUR PLACED ATMOSPHERIC FUEL TANKS (from the builders talent "Piloting -> Atmospheric Flight Technician -> Atmospheric Fuel-Tank Handling")
StatSpaceFuelTankHandling = 0 -- export (0-5) Enter the LEVEL OF YOUR PLACED FUEL SPACE TANKS (from the builders talent "Piloting -> Atmospheric Engine Technician -> Space Handling")
StatRocketFuelTankHandling = 0 -- export (0-5) Enter the LEVEL OF YOUR PLACED FUEL ROCKET TANKS (from the builders talent "Piloting -> Rocket Scientist -> Rocket Booster Fuel Tank Handling")
StatContainerOptimization = 0 -- export (0-5) Enter the LEVEL OF YOUR PLACED FUEL TANKS "from the builders talent Mining and Inventory -> Stock Control -> Container Optimization"
StatFuelTankOptimization = 0 -- export (0-5) Enter the LEVEL OF YOUR PLACED FUEL TANKS "from the builders talent Mining and Inventory -> Stock Control -> Fuel Tank Optimization"

ShowWelcomeMessage = true -- export Do you want the welcome message on the start screen with your name?
DisallowKeyPresses = false -- export Need your keys for other scripts/huds and want to prevent Damage Report keypresses to be processed? Then check this. (Usability of the HUD mode will be small.)
AddSummertimeHour = false -- export: Is summertime currently enabled in your location? (Adds one hour.)

UpdateDataInterval = 1.0;
HighlightBlinkingInterval = 0.5;
ColorPrimary = "FF6700"
ColorSecondary = "FFFFFF"
ColorTertiary = "000000"
ColorHealthy = "00FF00"
ColorWarning = "FFFF00"
ColorCritical = "FF0000"
ColorBackground = "000000"
ColorBackgroundPattern = "4F4F4F"
ColorFuelAtmospheric = "004444"
ColorFuelSpace = "444400"
ColorFuelRocket = "440044"
VERSION = 3.2;
DebugMode = false;
DebugRenderClickareas = true;
DBData = {}
core = nil;
db = nil;
screens = {}
dscreens = {}
Warnings = {}
screenModes = {
    ["flight"] = {id = "flight"},
    ["damage"] = {id = "damage"},
    ["damageoutline"] = {id = "damageoutline"},
    ["fuel"] = {id = "fuel"},
    ["cargo"] = {id = "cargo"},
    ["agg"] = {id = "agg"},
    ["map"] = {id = "map"},
    ["time"] = {id = "time", activetoggle = "true"},
    ["settings1"] = {id = "settings1"},
    ["startup"] = {id = "startup"}
}
backgroundModes = {
    "deathstar", "capsule", "rain", "signal", "hexagon", "diagonal", "diamond",
    "plus", "dots"
}
BackgroundMode = "deathstar"
BackgroundSelected = 1;
BackgroundModeOpacity = 0.25;
SaveVars = {
    "dscreens", "ColorPrimary", "ColorSecondary", "ColorTertiary",
    "ColorHealthy", "ColorWarning", "ColorCritical", "ColorBackground",
    "ColorBackgroundPattern", "ColorFuelAtmospheric", "ColorFuelSpace",
    "ColorFuelRocket", "ScrapTier", "HUDMode", "SimulationMode", "DMGOStretch",
    "HUDShiftU", "HUDShiftV", "colorIDIndex", "colorIDTable", "BackgroundMode",
    "BackgroundSelected", "BackgroundModeOpacity"
}
HUDMode = false;
HUDShiftU = 0;
HUDShiftV = 0;
hudSelectedIndex = 0;
hudStartIndex = 1;
hudArrowSticker = {}
highlightOn = false;
highlightID = 0;
highlightX = 0;
highlightY = 0;
highlightZ = 0;
SimulationMode = false;
OkayCenterMessage = "All systems nominal."
CurrentDamagedPage = 1;
CurrentBrokenPage = 1;
DamagePageSize = 12;
ScrapTier = 1;
totalScraps = 0;
ScrapTierRepairTimes = {10, 50, 250, 1250}
coreWorldOffset = 0;
totalShipHP = 0;
formerTotalShipHP = -1;
totalShipMaxHP = 0;
totalShipIntegrity = 100;
elementsId = {}
elementsIdList = {}
damagedElements = {}
brokenElements = {}
rE = {}
healthyElements = {}
typeElements = {}
ElementCounter = 0;
UseMyElementNames = true;
dmgoElements = {}
DMGOMaxElements = 250;
DMGOStretch = false;
ShipXmin = 99999999;
ShipXmax = -99999999;
ShipYmin = 99999999;
ShipYmax = -99999999;
ShipZmin = 99999999;
ShipZmax = -99999999;
totalShipMass = 0;
formerTotalShipMass = -1;
formerTime = -1;
FuelAtmosphericTanks = {}
FuelSpaceTanks = {}
FuelRocketTanks = {}
FuelAtmosphericTotal = 0;
FuelSpaceTotal = 0;
FuelRocketTotal = 0;
FuelAtmosphericCurrent = 0;
FuelSpaceTotalCurrent = 0;
FuelRocketTotalCurrent = 0;
formerFuelAtmosphericTotal = -1;
formerFuelSpaceTotal = -1;
formerFuelRocketTotal = -1;
hexTable = {
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E",
    "F"
}
colorIDIndex = 1;
colorIDTable = {
    [1] = {
        id = "ColorPrimary",
        desc = "Main HUD Color",
        basec = "FF6700",
        newc = "FF6700"
    },
    [2] = {
        id = "ColorSecondary",
        desc = "Secondary HUD Color",
        basec = "FFFFFF",
        newc = "FFFFFF"
    },
    [3] = {
        id = "ColorTertiary",
        desc = "Tertiary HUD Color",
        basec = "000000",
        newc = "000000"
    },
    [4] = {
        id = "ColorHealthy",
        desc = "Color code for Healthy/Okay",
        basec = "00FF00",
        newc = "00FF00"
    },
    [5] = {
        id = "ColorWarning",
        desc = "Color code for Damaged/Warning",
        basec = "FFFF00",
        newc = "FFFF00"
    },
    [6] = {
        id = "ColorCritical",
        desc = "Color code for Broken/Critical",
        basec = "FF0000",
        newc = "FF0000"
    },
    [7] = {
        id = "ColorBackground",
        desc = "Background Color",
        basec = "000000",
        newc = "000000"
    },
    [8] = {
        id = "ColorBackgroundPattern",
        desc = "Background Pattern Color",
        basec = "4F4F4F",
        newc = "4F4F4F"
    },
    [9] = {
        id = "ColorFuelAtmospheric",
        desc = "Color for Atmo Fuel/Elements",
        basec = "004444",
        newc = "004444"
    },
    [10] = {
        id = "ColorFuelSpace",
        desc = "Color for Space Fuel/Elements",
        basec = "444400",
        newc = "444400"
    },
    [11] = {
        id = "ColorFuelRocket",
        desc = "Color for Rocket Fuel/Elements",
        basec = "440044",
        newc = "440044"
    }
}
function InitiateSlots()
    for a, b in pairs(unit) do
        if type(b) == "table" and type(b.export) == "table" and
            b.getElementClass then
            local c = b.getElementClass():lower()
            if c:find("coreunit") then
                core = b;
                local d = core.getMaxHitPoints()
                if d > 10000 then
                    coreWorldOffset = 128
                elseif d > 1000 then
                    coreWorldOffset = 64
                elseif d > 150 then
                    coreWorldOffset = 32
                else
                    coreWorldOffset = 16
                end
            elseif c == 'databankunit' then
                db = b
            elseif c == "screenunit" then
                local e = "startup"
                screens[#screens + 1] = {
                    element = b,
                    id = b.getId(),
                    mode = e,
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
        for f, g in pairs(SaveVars) do
            if db.hasKey(g) then
                local h = json.decode(db.getStringValue(g))
                if h ~= nil then
                    if g == "YourShipsName" or g == "AddSummertimeHour" or g ==
                        "UpdateDataInterval" or g == "HighlightBlinkingInterval" or
                        g == "SkillRepairToolEfficiency" or g ==
                        "SkillRepairToolOptimization" or g ==
                        "SkillAtmosphericFuelEfficiency" or g ==
                        "SkillSpaceFuelEfficiency" or g ==
                        "SkillRocketFuelEfficiency" or g ==
                        "StatAtmosphericFuelTankHandling" or g ==
                        "StatSpaceFuelTankHandling" or g ==
                        "StatRocketFuelTankHandling" then
                    else
                        _G[g] = h
                    end
                end
            end
        end
        for i, j in ipairs(screens) do
            for k, l in ipairs(dscreens) do
                if screens[i].id == dscreens[k].id then
                    screens[i].mode = dscreens[k].mode;
                    screens[i].submode = dscreens[k].submode;
                    screens[i].active = dscreens[k].active;
                    screens[i].refresh = true;
                    screens[i].fuelA = dscreens[k].fuelA;
                    screens[i].fuelS = dscreens[k].fuelS;
                    screens[i].fuelR = dscreens[k].fuelR;
                    screens[i].fuelIndex = dscreens[k].fuelIndex
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
        for i, m in ipairs(screens) do
            dscreens[i] = {}
            dscreens[i].id = m.id;
            dscreens[i].mode = m.mode;
            dscreens[i].submode = m.submode;
            dscreens[i].active = m.active;
            dscreens[i].fuelA = m.fuelA;
            dscreens[i].fuelS = m.fuelS;
            dscreens[i].fuelR = m.fuelR;
            dscreens[i].fuelIndex = m.fuelIndex
        end
        db.clear()
        for f, g in pairs(SaveVars) do
            db.setStringValue(g, json.encode(_G[g]))
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
    FuelAtmosphericTotal = 0;
    FuelAtmosphericCurrent = 0;
    FuelSpaceTotal = 0;
    FuelSpaceCurrent = 0;
    FuelRocketCurrent = 0;
    FuelRocketTotal = 0;
    local n = 4;
    local o = 6;
    local p = 0.8;
    if StatContainerOptimization > 0 then
        n = n - 0.05 * StatContainerOptimization * n;
        o = o - 0.05 * StatContainerOptimization * o;
        p = p - 0.05 * StatContainerOptimization * p
    end
    if StatFuelTankOptimization > 0 then
        n = n - 0.05 * StatFuelTankOptimization * n;
        o = o - 0.05 * StatFuelTankOptimization * o;
        p = p - 0.05 * StatFuelTankOptimization * p
    end
    for i, q in ipairs(typeElements) do
        local r = core.getElementNameById(q) or ""
        local s = core.getElementTypeById(q) or ""
        local t = core.getElementPositionById(q) or 0;
        local u = core.getElementHitPointsById(q) or 0;
        local v = core.getElementMaxHitPointsById(q) or 0;
        local w = core.getElementMassById(q) or 0;
        local x = ""
        local y = 0;
        local z = 0;
        local A = 0;
        local B = 0;
        if s == "Atmospheric Fuel Tank" then
            if v > 10000 then
                x = "L"
                z = 5480;
                y = 12800
            elseif v > 1300 then
                x = "M"
                z = 988.67;
                y = 1600
            elseif v > 150 then
                x = "S"
                z = 182.67;
                y = 400
            else
                x = "XS"
                z = 35.03;
                y = 100
            end
            if StatAtmosphericFuelTankHandling > 0 then
                y = 0.2 * StatAtmosphericFuelTankHandling * y + y
            end
            A = w - z;
            if A <= 10 then A = 0 end
            B = string.format("%.0f", A / n)
            cPercent = string.format("%.1f", math.floor(100 / y * tonumber(B)))
            table.insert(FuelAtmosphericTanks, {
                type = 1,
                id = q,
                name = r,
                maxhp = v,
                hp = GetHPforElement(q),
                pos = t,
                size = x,
                mass = z,
                vol = y,
                cvol = B,
                percent = cPercent
            })
            if u > 0 then
                FuelAtmosphericCurrent = FuelAtmosphericCurrent + B
            end
            FuelAtmosphericTotal = FuelAtmosphericTotal + y
        elseif s == "Space Fuel Tank" then
            if v > 10000 then
                x = "L"
                z = 5480;
                y = 12800
            elseif v > 1300 then
                x = "M"
                z = 988.67;
                y = 1600
            else
                x = "S"
                z = 182.67;
                y = 400
            end
            if StatSpaceFuelTankHandling > 0 then
                y = 0.2 * StatSpaceFuelTankHandling * y + y
            end
            A = w - z;
            if A <= 10 then A = 0 end
            B = string.format("%.0f", A / o)
            cPercent = string.format("%.1f", 100 / y * tonumber(B))
            table.insert(FuelSpaceTanks, {
                type = 2,
                id = q,
                name = r,
                maxhp = v,
                hp = GetHPforElement(q),
                pos = t,
                size = x,
                mass = z,
                vol = y,
                cvol = B,
                percent = cPercent
            })
            if u > 0 then FuelSpaceCurrent = FuelSpaceCurrent + B end
            FuelSpaceTotal = FuelSpaceTotal + y
        elseif s == "Rocket Fuel Tank" then
            if v > 65000 then
                x = "L"
                z = 25740;
                y = 50000
            elseif v > 6000 then
                x = "M"
                z = 4720;
                y = 6400
            elseif v > 700 then
                x = "S"
                z = 886.72;
                y = 800
            else
                x = "XS"
                z = 173.42;
                y = 400
            end
            if StatRocketFuelTankHandling > 0 then
                y = 0.1 * StatRocketFuelTankHandling * y + y
            end
            A = w - z;
            if A <= 10 then A = 0 end
            B = string.format("%.0f", A / p)
            cPercent = string.format("%.1f", 100 / y * tonumber(B))
            table.insert(FuelRocketTanks, {
                type = 3,
                id = q,
                name = r,
                maxhp = v,
                hp = GetHPforElement(q),
                pos = t,
                size = x,
                mass = z,
                vol = y,
                cvol = B,
                percent = cPercent
            })
            if u > 0 then FuelRocketCurrent = FuelRocketCurrent + B end
            FuelRocketTotal = FuelRocketTotal + y
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
function UpdateDamageData(C)
    C = C or false;
    if SimulationActive == true then return end
    local formerTotalShipHP = totalShipHP;
    totalShipHP = 0;
    totalShipMaxHP = 0;
    totalShipIntegrity = 100;
    damagedElements = {}
    brokenElements = {}
    healthyElements = {}
    if C == true then typeElements = {} end
    ElementCounter = 0;
    elementsIdList = core.getElementIdList()
    for i, q in pairs(elementsIdList) do
        ElementCounter = ElementCounter + 1;
        local r = core.getElementNameById(q)
        local s = core.getElementTypeById(q)
        local t = core.getElementPositionById(q)
        local u = core.getElementHitPointsById(q)
        local v = core.getElementMaxHitPointsById(q)
        if SimulationMode == true then
            SimulationActive = true;
            local D = math.random(0, 10)
            if D < 2 and #brokenElements < 30 then
                u = 0
            elseif D >= 2 and D < 4 and #damagedElements < 30 then
                u = math.random(1, math.ceil(v))
            else
                u = v
            end
        end
        totalShipHP = totalShipHP + u;
        totalShipMaxHP = totalShipMaxHP + v;
        if v - u > constants.epsilon then
            if u > 0 then
                table.insert(damagedElements, {
                    id = q,
                    name = r,
                    type = s,
                    counter = ElementCounter,
                    hp = u,
                    maxhp = v,
                    missinghp = v - u,
                    percent = math.ceil(100 / v * u),
                    pos = t
                })
            else
                table.insert(brokenElements, {
                    id = q,
                    name = r,
                    type = s,
                    counter = ElementCounter,
                    hp = u,
                    maxhp = v,
                    missinghp = v - u,
                    percent = 0,
                    pos = t
                })
            end
        else
            table.insert(healthyElements, {
                id = q,
                name = r,
                type = s,
                counter = ElementCounter,
                hp = u,
                maxhp = v,
                pos = t
            })
            if q == highlightID then
                highlightID = 0;
                highlightOn = false;
                HideHighlight()
                hudSelectedIndex = 0
            end
        end
        if C == true then
            if s == "Atmospheric Fuel Tank" or s == "Space Fuel Tank" or s ==
                "Rocket Fuel Tank" then table.insert(typeElements, q) end
        end
    end
    SortDamageTables()
    rE = {}
    if #brokenElements > 0 then
        for f, j in ipairs(brokenElements) do
            table.insert(rE, {
                id = j.id,
                missinghp = j.missinghp,
                hp = j.hp,
                name = j.name,
                type = j.type,
                pos = j.pos
            })
        end
    end
    if #damagedElements > 0 then
        for f, j in ipairs(damagedElements) do
            table.insert(rE, {
                id = j.id,
                missinghp = j.missinghp,
                hp = j.hp,
                name = j.name,
                type = j.type,
                pos = j.pos
            })
        end
    end
    if #rE > 0 then
        table.sort(rE, function(E, F) return E.missinghp > F.missinghp end)
    end
    totalShipIntegrity = string.format("%2.0f",
                                       100 / totalShipMaxHP * totalShipHP)
    if formerTotalShipHP ~= totalShipHP then
        forceDamageRedraw = true;
        formerTotalShipHP = totalShipHP
    else
        forceDamageRedraw = false
    end
end
function GetHPforElement(q)
    for i, j in ipairs(brokenElements) do if j.id == q then return 0 end end
    for i, j in ipairs(damagedElements) do if j.id == q then return j.hp end end
    for i, j in ipairs(healthyElements) do
        if j.id == q then return j.maxhp end
    end
end
function UpdateClickArea(G, H, I)
    for i, m in ipairs(screens) do
        for J, j in pairs(screens[i].ClickAreas) do
            if j.id == G and j.mode == I then
                screens[i].ClickAreas[J] = H
            end
        end
    end
end
function AddClickArea(I, H)
    for i, m in ipairs(screens) do
        if screens[i].mode == I then
            table.insert(screens[i].ClickAreas, H)
        end
    end
end
function AddClickAreaForScreenID(K, H)
    for i, m in ipairs(screens) do
        if screens[i].id == K then table.insert(screens[i].ClickAreas, H) end
    end
end
function DisableClickArea(G, I)
    UpdateClickArea(G, {id = G, mode = I, x1 = -1, x2 = -1, y1 = -1, y2 = -1})
end
function SetRefresh(I, L)
    I = I or "all"
    L = L or "all"
    if screens ~= nil and #screens > 0 then
        for i = 1, #screens, 1 do
            if screens[i].mode == I or I == "all" then
                if screens[i].submode == L or L == "all" then
                    screens[i].refresh = true
                end
            end
        end
    end
end
function WipeClickAreasForScreen(m)
    m.ClickAreas = {}
    return m
end
function CreateBaseClickAreas(m)
    table.insert(m.ClickAreas, {
        mode = "all",
        id = "ToggleHudMode",
        x1 = 1537,
        x2 = 1728,
        y1 = 1015,
        y2 = 1075
    })
    table.insert(m.ClickAreas, {
        mode = "all",
        id = "ButtonPress",
        param = "damage",
        x1 = 193,
        x2 = 384,
        y1 = 1015,
        y2 = 1075
    })
    table.insert(m.ClickAreas, {
        mode = "all",
        id = "ButtonPress",
        param = "damageoutline",
        x1 = 385,
        x2 = 576,
        y1 = 1015,
        y2 = 1075
    })
    table.insert(m.ClickAreas, {
        mode = "all",
        id = "ButtonPress",
        param = "fuel",
        x1 = 577,
        x2 = 768,
        y1 = 1015,
        y2 = 1075
    })
    table.insert(m.ClickAreas, {
        mode = "all",
        id = "ButtonPress",
        param = "time",
        x1 = 0,
        x2 = 192,
        y1 = 1015,
        y2 = 1075
    })
    table.insert(m.ClickAreas, {
        mode = "all",
        id = "ButtonPress",
        param = "settings1",
        x1 = 1729,
        x2 = 1920,
        y1 = 1015,
        y2 = 1075
    })
    return m
end
function CreateClickAreasForScreen(m)
    if m == nil then return {} end
    if m.mode == "flight" then
    elseif m.mode == "damage" then
        table.insert(m.ClickAreas, {
            mode = "damage",
            id = "ToggleElementLabel",
            x1 = 70,
            x2 = 425,
            y1 = 325,
            y2 = 355
        })
        table.insert(m.ClickAreas, {
            mode = "damage",
            id = "ToggleElementLabel2",
            x1 = 980,
            x2 = 1400,
            y1 = 325,
            y2 = 355
        })
    elseif m.mode == "damageoutline" then
        table.insert(m.ClickAreas, {
            mode = "damageoutline",
            id = "DMGOChangeView",
            param = "top",
            x1 = 60,
            x2 = 439,
            y1 = 150,
            y2 = 200
        })
        table.insert(m.ClickAreas, {
            mode = "damageoutline",
            id = "DMGOChangeView",
            param = "side",
            x1 = 440,
            x2 = 824,
            y1 = 150,
            y2 = 200
        })
        table.insert(m.ClickAreas, {
            mode = "damageoutline",
            id = "DMGOChangeView",
            param = "front",
            x1 = 825,
            x2 = 1215,
            y1 = 150,
            y2 = 200
        })
        table.insert(m.ClickAreas, {
            mode = "damageoutline",
            id = "DMGOChangeStretch",
            x1 = 1530,
            x2 = 1580,
            y1 = 150,
            y2 = 200
        })
    elseif m.mode == "fuel" then
    elseif m.mode == "cargo" then
    elseif m.mode == "agg" then
    elseif m.mode == "map" then
    elseif m.mode == "time" then
    elseif m.mode == "settings1" then
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ToggleBackground",
            x1 = 75,
            x2 = 860,
            y1 = 170,
            y2 = 215
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "PreviousBackground",
            x1 = 75,
            x2 = 460,
            y1 = 235,
            y2 = 285
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "NextBackground",
            x1 = 480,
            x2 = 860,
            y1 = 235,
            y2 = 285
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "DecreaseOpacity",
            x1 = 75,
            x2 = 460,
            y1 = 300,
            y2 = 350
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "IncreaseOpacity",
            x1 = 480,
            x2 = 860,
            y1 = 300,
            y2 = 350
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ResetColors",
            x1 = 75,
            x2 = 860,
            y1 = 370,
            y2 = 415
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "PreviousColorID",
            x1 = 90,
            x2 = 140,
            y1 = 500,
            y2 = 550
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "NextColorID",
            x1 = 795,
            x2 = 845,
            y1 = 500,
            y2 = 550
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosUp",
            param = "1",
            x1 = 210,
            x2 = 290,
            y1 = 655,
            y2 = 700
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosUp",
            param = "2",
            x1 = 300,
            x2 = 380,
            y1 = 655,
            y2 = 700
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosUp",
            param = "3",
            x1 = 385,
            x2 = 465,
            y1 = 655,
            y2 = 700
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosUp",
            param = "4",
            x1 = 470,
            x2 = 550,
            y1 = 655,
            y2 = 700
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosUp",
            param = "5",
            x1 = 560,
            x2 = 640,
            y1 = 655,
            y2 = 700
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosUp",
            param = "6",
            x1 = 645,
            x2 = 725,
            y1 = 655,
            y2 = 700
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosDown",
            param = "1",
            x1 = 210,
            x2 = 290,
            y1 = 740,
            y2 = 780
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosDown",
            param = "2",
            x1 = 300,
            x2 = 380,
            y1 = 740,
            y2 = 780
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosDown",
            param = "3",
            x1 = 385,
            x2 = 465,
            y1 = 740,
            y2 = 780
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosDown",
            param = "4",
            x1 = 470,
            x2 = 550,
            y1 = 740,
            y2 = 780
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosDown",
            param = "5",
            x1 = 560,
            x2 = 640,
            y1 = 740,
            y2 = 780
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ColorPosDown",
            param = "6",
            x1 = 645,
            x2 = 725,
            y1 = 740,
            y2 = 780
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ResetPosColor",
            x1 = 160,
            x2 = 340,
            y1 = 885,
            y2 = 935
        })
        table.insert(m.ClickAreas, {
            mode = "settings1",
            id = "ApplyPosColor",
            x1 = 355,
            x2 = 780,
            y1 = 885,
            y2 = 935
        })
    elseif m.mode == "startup" then
    end
    m = CreateBaseClickAreas(m)
    return m
end
function CheckClick(M, N, O)
    M = M * 1920;
    N = N * 1120;
    O = O or ""
    HitPayload = {}
    if screens ~= nil and #screens > 0 then
        for i = 1, #screens, 1 do
            if screens[i].active == true and screens[i].element.getMouseX() ~=
                -1 and screens[i].element.getMouseY() ~= -1 then
                if O == "" then
                    for J, j in pairs(screens[i].ClickAreas) do
                        if j ~= nil and M >= j.x1 and M <= j.x2 and N >= j.y1 and
                            N <= j.y2 then
                            O = j.id;
                            HitPayload = j;
                            break
                        end
                    end
                end
                if O == "ButtonPress" then
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
                    screens[i].refresh = true;
                    screens[i].ClickAreas = {}
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "ToggleBackground" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if BackgroundMode == "" then
                        BackgroundSelected = 1;
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    else
                        BackgroundSelected = 1;
                        BackgroundMode = ""
                    end
                    for J, m in pairs(screens) do
                        screens[J].refresh = true
                    end
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "PreviousBackground" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if BackgroundMode == "" then
                        BackgroundSelected = 1;
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    else
                        if BackgroundSelected <= 1 then
                            BackgroundSelected = #backgroundModes
                        else
                            BackgroundSelected = BackgroundSelected - 1
                        end
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    end
                    for J, m in pairs(screens) do
                        screens[J].refresh = true
                    end
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "NextBackground" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if BackgroundMode == "" then
                        BackgroundSelected = 1;
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    else
                        if BackgroundSelected >= #backgroundModes then
                            BackgroundSelected = 1
                        else
                            BackgroundSelected = BackgroundSelected + 1
                        end
                        BackgroundMode = backgroundModes[BackgroundSelected]
                    end
                    for J, m in pairs(screens) do
                        screens[J].refresh = true
                    end
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "DecreaseOpacity" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if BackgroundModeOpacity > 0.1 then
                        BackgroundModeOpacity = BackgroundModeOpacity - 0.05;
                        for J, m in pairs(screens) do
                            screens[J].refresh = true
                        end
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    end
                elseif O == "IncreaseOpacity" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if BackgroundModeOpacity < 1.0 then
                        BackgroundModeOpacity = BackgroundModeOpacity + 0.05;
                        for J, m in pairs(screens) do
                            screens[J].refresh = true
                        end
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    end
                elseif O == "ResetColors" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
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
                    BackgroundSelected = 1;
                    BackgroundModeOpacity = 0.25;
                    colorIDTable = {
                        [1] = {
                            id = "ColorPrimary",
                            desc = "Main HUD Color",
                            basec = "FF6700",
                            newc = "FF6700"
                        },
                        [2] = {
                            id = "ColorSecondary",
                            desc = "Secondary HUD Color",
                            basec = "FFFFFF",
                            newc = "FFFFFF"
                        },
                        [3] = {
                            id = "ColorTertiary",
                            desc = "Tertiary HUD Color",
                            basec = "000000",
                            newc = "000000"
                        },
                        [4] = {
                            id = "ColorHealthy",
                            desc = "Color code for Healthy/Okay",
                            basec = "00FF00",
                            newc = "00FF00"
                        },
                        [5] = {
                            id = "ColorWarning",
                            desc = "Color code for Damaged/Warning",
                            basec = "FFFF00",
                            newc = "FFFF00"
                        },
                        [6] = {
                            id = "ColorCritical",
                            desc = "Color code for Broken/Critical",
                            basec = "FF0000",
                            newc = "FF0000"
                        },
                        [7] = {
                            id = "ColorBackground",
                            desc = "Background Color",
                            basec = "000000",
                            newc = "000000"
                        },
                        [8] = {
                            id = "ColorBackgroundPattern",
                            desc = "Background Pattern Color",
                            basec = "4F4F4F",
                            newc = "4F4F4F"
                        },
                        [9] = {
                            id = "ColorFuelAtmospheric",
                            desc = "Color for Atmo Fuel/Elements",
                            basec = "004444",
                            newc = "004444"
                        },
                        [10] = {
                            id = "ColorFuelSpace",
                            desc = "Color for Space Fuel/Elements",
                            basec = "444400",
                            newc = "444400"
                        },
                        [11] = {
                            id = "ColorFuelRocket",
                            desc = "Color for Rocket Fuel/Elements",
                            basec = "440044",
                            newc = "440044"
                        }
                    }
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "PreviousColorID" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    colorIDIndex = colorIDIndex - 1;
                    if colorIDIndex < 1 then
                        colorIDIndex = #colorIDTable
                    end
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif O == "NextColorID" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    colorIDIndex = colorIDIndex + 1;
                    if colorIDIndex > #colorIDTable then
                        colorIDIndex = 1
                    end
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif O == "ColorPosUp" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    local P = tonumber(string.sub(
                                           colorIDTable[colorIDIndex].newc,
                                           HitPayload.param, HitPayload.param),
                                       16)
                    P = P + 1;
                    if P > 15 then P = 0 end
                    colorIDTable[colorIDIndex].newc =
                        replace_char(HitPayload.param,
                                     colorIDTable[colorIDIndex].newc,
                                     hexTable[P + 1])
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif O == "ColorPosDown" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    local P = tonumber(string.sub(
                                           colorIDTable[colorIDIndex].newc,
                                           HitPayload.param, HitPayload.param),
                                       16)
                    P = P - 1;
                    if P < 0 then P = 15 end
                    colorIDTable[colorIDIndex].newc =
                        replace_char(HitPayload.param,
                                     colorIDTable[colorIDIndex].newc,
                                     hexTable[P + 1])
                    SaveToDatabank()
                    SetRefresh("settings1")
                    RenderScreens("settings1")
                elseif O == "ResetPosColor" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    colorIDTable[colorIDIndex].newc =
                        colorIDTable[colorIDIndex].basec;
                    _G[colorIDTable[colorIDIndex].id] =
                        colorIDTable[colorIDIndex].basec;
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "ApplyPosColor" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    _G[colorIDTable[colorIDIndex].id] =
                        colorIDTable[colorIDIndex].newc;
                    SaveToDatabank()
                    SetRefresh()
                    RenderScreens()
                elseif O == "DamagedPageDown" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    CurrentDamagedPage = CurrentDamagedPage + 1;
                    if CurrentDamagedPage >
                        math.ceil(#damagedElements / DamagePageSize) then
                        CurrentDamagedPage =
                            math.ceil(#damagedElements / DamagePageSize)
                    end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif O == "DamagedPageUp" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    CurrentDamagedPage = CurrentDamagedPage - 1;
                    if CurrentDamagedPage < 1 then
                        CurrentDamagedPage = 1
                    end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif O == "BrokenPageDown" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    CurrentBrokenPage = CurrentBrokenPage + 1;
                    if CurrentBrokenPage >
                        math.ceil(#brokenElements / DamagePageSize) then
                        CurrentBrokenPage =
                            math.ceil(#brokenElements / DamagePageSize)
                    end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif O == "BrokenPageUp" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    CurrentBrokenPage = CurrentBrokenPage - 1;
                    if CurrentBrokenPage < 1 then
                        CurrentBrokenPage = 1
                    end
                    HudDeselectElement()
                    SaveToDatabank()
                    SetRefresh("damage")
                    RenderScreens("damage")
                elseif O == "DMGOChangeView" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    screens[i].submode = HitPayload.param;
                    UpdateViewDamageoutline(screens[i])
                    SaveToDatabank()
                    SetRefresh("damageoutline", screens[i].submode)
                    RenderScreens("damageoutline", screens[i].submode)
                elseif O == "DMGOChangeStretch" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if DMGOStretch == true then
                        DMGOStretch = false
                    else
                        DMGOStretch = true
                    end
                    UpdateViewDamageoutline(screens[i])
                    SaveToDatabank()
                    SetRefresh("damageoutline")
                    RenderScreens("damageoutline")
                elseif O == "ToggleDisplayAtmosphere" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if screens[i].fuelA == true then
                        screens[i].fuelA = false
                    else
                        screens[i].fuelA = true
                    end
                    screens[i].fuelIndex = 1;
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif O == "ToggleDisplaySpace" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if screens[i].fuelS == true then
                        screens[i].fuelS = false
                    else
                        screens[i].fuelS = true
                    end
                    screens[i].fuelIndex = 1;
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif O == "ToggleDisplayRocket" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if screens[i].fuelR == true then
                        screens[i].fuelR = false
                    else
                        screens[i].fuelR = true
                    end
                    screens[i].fuelIndex = 1;
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif O == "DecreaseFuelIndex" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    screens[i].fuelIndex = screens[i].fuelIndex - 1;
                    if screens[i].fuelIndex < 1 then
                        screens[i].fuelIndex = 1
                    end
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif O == "IncreaseFuelIndex" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    screens[i].fuelIndex = screens[i].fuelIndex + 1;
                    SaveToDatabank()
                    SetRefresh("fuel")
                    RenderScreens("fuel")
                elseif O == "ToggleHudMode" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if HUDMode == true then
                        HUDMode = false;
                        forceDamageRedraw = true;
                        HudDeselectElement()
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    else
                        HUDMode = true;
                        forceDamageRedraw = true;
                        HudDeselectElement()
                        SaveToDatabank()
                        SetRefresh()
                        RenderScreens()
                    end
                elseif O == "ToggleSimulation" and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    CurrentDamagedPage = 1;
                    CurrentBrokenPage = 1;
                    if SimulationMode == true then
                        SimulationMode = false;
                        SimulationActive = false;
                        UpdateDamageData()
                        UpdateTypeData()
                        forceDamageRedraw = true;
                        HudDeselectElement()
                        SetRefresh("damage")
                        SetRefresh("damageoutline")
                        SetRefresh("settings1")
                        SetRefresh("fuel")
                        SaveToDatabank()
                        RenderScreens()
                    else
                        SimulationMode = true;
                        SimulationActive = false;
                        UpdateDamageData()
                        UpdateTypeData()
                        forceDamageRedraw = true;
                        HudDeselectElement()
                        SetRefresh("damage")
                        SetRefresh("damageoutline")
                        SetRefresh("settings1")
                        SetRefresh("fuel")
                        SaveToDatabank()
                        RenderScreens()
                    end
                elseif (O == "ToggleElementLabel" or O == "ToggleElementLabel2") and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    if UseMyElementNames == true then
                        UseMyElementNames = false;
                        SetRefresh("damage")
                        RenderScreens("damage")
                    else
                        UseMyElementNames = true;
                        SetRefresh("damage")
                        RenderScreens("damage")
                    end
                elseif (O == "SwitchScrapTier" or O == "SwitchScrapTier2") and
                    (HitPayload.mode == screens[i].mode or HitPayload.mode ==
                        "all") then
                    ScrapTier = ScrapTier + 1;
                    if ScrapTier > 4 then ScrapTier = 1 end
                    SetRefresh("damage")
                    RenderScreens("damage")
                end
            end
        end
    end
end
function GetContentFlight()
    local Q = ""
    Q = Q .. GetHeader("Flight Data Report") .. [[
        
    ]]
    return Q
end
function GetContentDamage()
    local Q = ""
    if SimulationMode == true then
        Q = Q .. GetHeader("Damage Report (Simulated damage)") .. [[]]
    else
        Q = Q .. GetHeader("Damage Report") .. [[]]
    end
    Q = Q .. GetContentDamageScreen()
    return Q
end
function GetContentDamageoutline(m)
    UpdateDataDamageoutline()
    UpdateViewDamageoutline(m)
    local Q = ""
    Q =
        Q .. GetHeader("Damage Ship Outline Report") .. GetDamageoutlineShip() ..
            [[<rect x=20 y=180 rx=5 ry=5 width=1880 height=840 fill=#000000 fill-opacity=0.5 style="stroke:#]] ..
            ColorPrimary .. [[;stroke-width:3;" />]]
    if m.submode == "top" then
        Q = Q .. [[
              <rect class=xfill x=20 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mxx x=220 y=165>Top View</text>
              <rect class=xborder x=420 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=620 y=165>Side View</text>
              <rect class=xborder x=820 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=1020 y=165>Front View</text>
            ]]
    elseif m.submode == "side" then
        Q = Q .. [[
              <rect class=xborder x=20 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=220 y=165>Top View</text>
              <rect class=xfill x=420 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mxx x=620 y=165>Side View</text>
              <rect class=xborder x=820 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=1020 y=165>Front View</text>
            ]]
    elseif m.submode == "front" then
        Q = Q .. [[
              <rect class=xborder x=20 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=220 y=165>Top View</text>
              <rect class=xborder x=420 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mx x=620 y=165>Side View</text>
              <rect class=xfill x=820 y=130 rx=5 ry=5 width=400 height=50 />
              <text class=f30mxx x=1020 y=165>Front View</text>
            ]]
    else
    end
    Q =
        Q .. [[<text class=f30exx x=1900 y=120>]] .. #dmgoElements .. [[ of ]] ..
            ElementCounter .. [[ shown</text>]]
    Q = Q ..
            [[<rect class=xborder x=1550 y=130 rx=5 ry=5 width=50 height=50 />]]
    if DMGOStretch == true then
        Q = Q ..
                [[<rect class=xfill x=1558 y=138 rx=5 ry=5 width=34 height=34 />]]
    end
    Q = Q .. [[<text class=f30exx x=1900 y=165>Stretch both axis</text>]]
    return Q
end
function GetContentFuel(m)
    if #FuelAtmosphericTanks < 1 and #FuelSpaceTanks < 1 and #FuelRocketTanks <
        1 then return "" end
    local R = 0;
    local Q = ""
    local S = {}
    FuelDisplay = {m.fuelA, m.fuelS, m.fuelR}
    if FuelDisplay[1] == true and #FuelAtmosphericTanks > 0 then
        table.insert(S, "Atmospheric")
        R = R + 1
    end
    if FuelDisplay[2] == true and #FuelSpaceTanks > 0 then
        table.insert(S, "Space")
        R = R + 1
    end
    if FuelDisplay[3] == true and #FuelRocketTanks > 0 then
        table.insert(S, "Rocket")
        R = R + 1
    end
    Q = Q .. GetHeader("Fuel Report (" .. table.concat(S, ", ") .. ")") .. [[
    <style>
        .fuele{fill:#]] .. ColorBackground .. [[;}
        .fuela{fill:#]] .. ColorFuelAtmospheric .. [[;fill-opacity:1;}
        .fuels{fill:#]] .. ColorFuelSpace .. [[;fill-opacity:1;}
        .fuelr{fill:#]] .. ColorFuelRocket .. [[;fill-opacity:1;}

        .fuela2{fill:none;stroke:#]] .. ColorFuelAtmospheric ..
            [[;stroke-width:3px;opacity:1;}
        .fuels2{fill:none;stroke:#]] .. ColorFuelSpace ..
            [[;stroke-width:3px;opacity:1;}
        .fuelr2{fill:none;stroke:#]] .. ColorFuelRocket ..
            [[;stroke-width:3px;opacity:1;}

        .fuela3{fill:#]] .. ColorFuelAtmospheric .. [[;fill-opacity:0.1;}
        .fuels3{fill:#]] .. ColorFuelSpace .. [[;fill-opacity:0.1;}
        .fuelr3{fill:#]] .. ColorFuelRocket .. [[;fill-opacity:0.1;}

        .fuela4{fill:#]] .. ColorFuelAtmospheric .. [[;fill-opacity:1;}
        .fuels4{fill:#]] .. ColorFuelSpace .. [[;fill-opacity:1;}
        .fuelr4{fill:#]] .. ColorFuelRocket .. [[;fill-opacity:1;}
    </style> ]]
    local T = 150;
    local U = 0;
    local V = 0;
    if FuelDisplay[1] == true and #FuelAtmosphericTanks > 0 then
        if R == 1 then
            V = 50
        elseif R == 2 then
            V = 6
        elseif R == 3 then
            V = 0
        end
        Q = Q .. [[
        <svg x=20 y=]] .. 95 + T / R * U .. [[ width=1880 height=]] .. T / R ..
                [[>
            <rect class="fuele" width="100%" height="100%"/>
            <rect class="fuela" width="]] ..
                math.floor(100 / FuelAtmosphericTotal * FuelAtmosphericCurrent) ..
                [[%" height="100%"/>
        </svg>]]
        Q =
            Q .. [[<text class=f25sxx x=40 y=]] .. 130 + T / R * U + V .. [[>]] ..
                GenerateCommaValue(FuelAtmosphericCurrent, true) .. [[ of ]] ..
                GenerateCommaValue(FuelAtmosphericTotal, true) ..
                [[ | Total Atmospheric Fuel in ]] .. #FuelAtmosphericTanks ..
                [[ tank]] .. (#FuelAtmosphericTanks == 1 and "" or "s") ..
                [[ (]] ..
                math.floor(100 / FuelAtmosphericTotal * FuelAtmosphericCurrent) ..
                [[%)</text>]]
        U = U + 1
    end
    if FuelDisplay[2] == true and #FuelSpaceTanks > 0 then
        if R == 1 then
            V = 50
        elseif R == 2 then
            V = 6
        elseif R == 3 then
            V = 0
        end
        Q = Q .. [[
        <svg x=20 y=]] .. 95 + T / R * U .. [[ width=1880 height=]] .. T / R ..
                [[>
            <rect class="fuele" width="100%" height="100%"/>
            <rect class="fuels" width="]] ..
                math.floor(100 / FuelSpaceTotal * FuelSpaceCurrent) ..
                [[%" height="100%"/>
        </svg>]]
        Q =
            Q .. [[<text class=f25sxx x=40 y=]] .. 130 + T / R * U + V .. [[>]] ..
                GenerateCommaValue(FuelSpaceCurrent, true) .. [[ of ]] ..
                GenerateCommaValue(FuelSpaceTotal, true) ..
                [[ | Total Space Fuel in ]] .. #FuelSpaceTanks .. [[ tank]] ..
                (#FuelSpaceTanks == 1 and "" or "s") .. [[ (]] ..
                math.floor(100 / FuelSpaceTotal * FuelSpaceCurrent) ..
                [[%)</text>]]
        U = U + 1
    end
    if FuelDisplay[3] == true and #FuelRocketTanks > 0 then
        if R == 1 then
            V = 50
        elseif R == 2 then
            V = 6
        elseif R == 3 then
            V = 0
        end
        Q = Q .. [[
        <svg x=20 y=]] .. 95 + T / R * U .. [[ width=1880 height=]] .. T / R ..
                [[>
            <rect class="fuele" width="100%" height="100%"/>
            <rect class="fuelr" width="]] ..
                math.floor(100 / FuelRocketTotal * FuelRocketCurrent) ..
                [[%" height="100%"/>
        </svg> ]]
        Q =
            Q .. [[<text class=f25sxx x=40 y=]] .. 130 + T / R * U + V .. [[>]] ..
                GenerateCommaValue(FuelRocketCurrent, true) .. [[ of ]] ..
                GenerateCommaValue(FuelRocketTotal, true) ..
                [[ | Total Rocket Fuel in ]] .. #FuelRocketTanks .. [[ tank]] ..
                (#FuelRocketTanks == 1 and "" or "s") .. [[ (]] ..
                math.floor(100 / FuelRocketTotal * FuelRocketCurrent) ..
                [[%)</text>]]
    end
    Q = Q .. [[
    <svg x=20 y=95 width=1880 height=]] .. T .. [[>
        <rect class="xborder" width="100%" height="100%"/>
    </svg>
    ]]
    local W = {}
    if m.fuelIndex == nil or m.fuelIndex < 1 then m.fuelIndex = 1 end
    if FuelDisplay[1] == true then
        for f, j in ipairs(FuelAtmosphericTanks) do table.insert(W, j) end
    end
    if FuelDisplay[2] == true then
        for f, j in ipairs(FuelSpaceTanks) do table.insert(W, j) end
    end
    if FuelDisplay[3] == true then
        for f, j in ipairs(FuelRocketTanks) do table.insert(W, j) end
    end
    table.sort(W, function(E, F)
        return E.type < F.type or E.type == F.type and E.id < F.id
    end)
    local X = 0;
    for i = m.fuelIndex, m.fuelIndex + 6, 1 do
        if W[i] ~= nil then
            local Y = W[i]
            X = X + 1;
            local Z = ""
            if Y.type == 1 then
                Z = "a"
            elseif Y.type == 2 then
                Z = "s"
            elseif Y.type == 3 then
                Z = "r"
            end
            local _ = 1853 / 100;
            if Y.percent == nil or Y.percent == 0 then
                _ = 0
            else
                _ = _ * Y.percent
            end
            if Y.cvol == nil then Y.cvol = 0 end
            if Y.name == nil then Y.name = "" end
            Q = Q .. [[
                <svg x=20 y=]] .. X * 100 + 220 ..
                    [[ width=1880 height=100 viewBox="0 0 1880 100">
                    <rect class="fuel]] .. Z ..
                    [[3" x="13.5" y="9.5" width="1853" height="81"/>
                    <rect class="fuel]] .. Z .. [[4" x="13.5" y="9.5" width="]] ..
                    _ .. [[" height="81"/>
                    <rect class="fuel]] .. Z ..
                    [[2" x="13.5" y="9.5" width="1853" height="81"/>]]
            if Y.hp == 0 then
                Q = Q ..
                        [[<polygon class="cc" points="7 3 7 97 15 97 15 100 4 100 4 74.9 0 71.32 0 18.7 4 14.4 4 0 15 0 15 3 7 3"/><polygon class="cc" points="1873 3 1873 97 1865 97 1865 100 1876 100 1876 74.9 1880 71.32 1880 18.7 1876 14.4 1876 0 1865 0 1865 3 1873 3"/>]]
            elseif Y.maxhp - Y.hp > constants.epsilon then
                Q = Q ..
                        [[<polygon class="cw" points="7 3 7 97 15 97 15 100 4 100 4 74.9 0 71.32 0 18.7 4 14.4 4 0 15 0 15 3 7 3"/><polygon class="cw" points="1873 3 1873 97 1865 97 1865 100 1876 100 1876 74.9 1880 71.32 1880 18.7 1876 14.4 1876 0 1865 0 1865 3 1873 3"/>]]
            else
                Q = Q ..
                        [[<polygon class="ch" points="7 3 7 97 15 97 15 100 4 100 4 74.9 0 71.32 0 18.7 4 14.4 4 0 15 0 15 3 7 3"/><polygon class="ch" points="1873 3 1873 97 1865 97 1865 100 1876 100 1876 74.9 1880 71.32 1880 18.7 1876 14.4 1876 0 1865 0 1865 3 1873 3"/>]]
            end
            if Y.hp == 0 then
                Q = Q .. [[<text class=f80mc x=60 y=82>]] .. Y.size ..
                        [[</text>]]
            else
                Q = Q .. [[<text class=f80mxx07 x=60 y=82>]] .. Y.size ..
                        [[</text>]]
            end
            if Y.hp == 0 then
                Q = Q .. [[<text class=f60mc x=940 y=74>Broken</text>]] ..
                        [[<text class=f25ec x=1860 y=60>0 of ]] ..
                        GenerateCommaValue(Y.vol) .. [[</text>]]
            elseif tonumber(Y.percent) < 10 then
                Q = Q .. [[<text class=f60mc x=940 y=74>]] .. Y.percent ..
                        [[%</text>]] .. [[<text class=f25ec x=1860 y=60>]] ..
                        GenerateCommaValue(Y.cvol) .. [[ of ]] ..
                        GenerateCommaValue(Y.vol) .. [[</text>]]
            elseif tonumber(Y.percent) < 30 then
                Q = Q .. [[<text class=f60mw x=940 y=74>]] .. Y.percent ..
                        [[%</text>]] .. [[<text class=f25ew x=1860 y=60>]] ..
                        GenerateCommaValue(Y.cvol) .. [[ of ]] ..
                        GenerateCommaValue(Y.vol) .. [[</text>]]
            else
                Q = Q .. [[<text class=f60mxx x=940 y=74>]] .. Y.percent ..
                        [[%</text>]] .. [[<text class=f25exx x=1860 y=60>]] ..
                        GenerateCommaValue(Y.cvol) .. [[ of ]] ..
                        GenerateCommaValue(Y.vol) .. [[</text>]]
            end
            Q = Q .. [[<text class=f25sxx x=140 y=60>]] .. Y.name .. [[</text>]]
            Q = Q .. [[</svg>]]
        end
    end
    if #FuelAtmosphericTanks > 0 then
        Q = Q ..
                [[<rect class=xborder x=20 y=260 rx=5 ry=5 width=50 height=50 />]]
        if FuelDisplay[1] == true then
            Q = Q ..
                    [[<rect class=xfill x=28 y=268 rx=5 ry=5 width=34 height=34 />]]
        end
        Q = Q .. [[<text class=f25sx x=80 y=290>ATM</text>]]
        AddClickAreaForScreenID(m.id, {
            mode = "fuel",
            id = "ToggleDisplayAtmosphere",
            x1 = 50,
            x2 = 100,
            y1 = 270,
            y2 = 320
        })
    end
    if #FuelSpaceTanks > 0 then
        Q = Q ..
                [[<rect class=xborder x=170 y=260 rx=5 ry=5 width=50 height=50 />]]
        if FuelDisplay[2] == true then
            Q = Q ..
                    [[<rect class=xfill x=178 y=268 rx=5 ry=5 width=34 height=34 />]]
        end
        Q = Q .. [[<text class=f25sx x=230 y=290>SPC</text>]]
        AddClickAreaForScreenID(m.id, {
            mode = "fuel",
            id = "ToggleDisplaySpace",
            x1 = 200,
            x2 = 250,
            y1 = 270,
            y2 = 320
        })
    end
    if #FuelRocketTanks > 0 then
        Q = Q ..
                [[<rect class=xborder x=320 y=260 rx=5 ry=5 width=50 height=50 />]]
        if FuelDisplay[3] == true then
            Q = Q ..
                    [[<rect class=xfill x=328 y=268 rx=5 ry=5 width=34 height=34 />]]
        end
        Q = Q .. [[<text class=f25sx x=380 y=290>RKT</text>]]
        AddClickAreaForScreenID(m.id, {
            mode = "fuel",
            id = "ToggleDisplayRocket",
            x1 = 350,
            x2 = 400,
            y1 = 270,
            y2 = 320
        })
    end
    if m.fuelIndex > 1 then
        Q = Q .. [[<svg x="1490" y="260">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]] ..
                ColorPrimary .. [[;" />
                                <svg x="80" y="15"><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
        AddClickAreaForScreenID(m.id, {
            mode = "fuel",
            id = "DecreaseFuelIndex",
            x1 = 1470,
            x2 = 1670,
            y1 = 270,
            y2 = 320
        })
    end
    if m.fuelIndex + X - 1 < #W then
        Q = Q .. [[<svg x="1700" y="260">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]] ..
                ColorPrimary .. [[;" />
                                <svg x="80" y="15"><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
        AddClickAreaForScreenID(m.id, {
            mode = "fuel",
            id = "IncreaseFuelIndex",
            x1 = 1680,
            x2 = 1880,
            y1 = 270,
            y2 = 320
        })
    end
    if X > 0 then
        Q = Q .. [[<text class=f30mx x=960 y=300>]] .. #W .. [[ Tank]] ..
                (#W == 1 and "" or "s") .. [[ (Showing ]] .. m.fuelIndex ..
                [[ to ]] .. m.fuelIndex + X - 1 .. [[)</text>]]
    end
    return Q
end
function GetContentCargo()
    local Q = ""
    Q = Q .. GetHeader("Cargo Report") .. [[
        
    ]]
    return Q
end
function GetContentAGG()
    local Q = ""
    Q = Q .. GetHeader("Anti-Grav Control") .. [[
        
    ]]
    return Q
end
function GetContentMap()
    local Q = ""
    Q = Q .. GetHeader("Map Overview") .. [[
        
    ]]
    return Q
end
function GetContentTime()
    local Q = ""
    Q = Q .. GetHeader("Time") .. epochTime()
    Q = Q .. [[<svg x=460 y=370 width=120 height=150 viewBox="0 0 24 30">
                    <rect x=0 y=13 width=4 height=5 fill=#]] .. ColorPrimary ..
            [[>
                      <animate attributeName="height" attributeType="XML"
                        values="5;21;5" 
                        begin="0s" dur="1s" repeatCount="indefinite" />
                      <animate attributeName="y" attributeType="XML"
                        values="13; 5; 13"
                        begin="0s" dur="1s" repeatCount="indefinite" />
                    </rect>
                    <rect x=10 y=13 width=4 height=5 fill=#]] .. ColorPrimary ..
            [[>
                      <animate attributeName="height" attributeType="XML"
                        values="5;21;5" 
                        begin="0.15s" dur="1s" repeatCount="indefinite" />
                      <animate attributeName="y" attributeType="XML"
                        values="13; 5; 13"
                        begin="0.15s" dur="1s" repeatCount="indefinite" />
                    </rect>
                    <rect x=20 y=13 width=4 height=5 fill=#]] .. ColorPrimary ..
            [[>
                      <animate attributeName="height" attributeType="XML"
                        values="5;21;5" 
                        begin="0.3s" dur="1s" repeatCount="indefinite" />
                      <animate attributeName="y" attributeType="XML"
                        values="13; 5; 13"
                        begin="0.3s" dur="1s" repeatCount="indefinite" />
                    </rect>
                  </svg>]]
    return Q
end
function GetContentSettings1()
    local Q = ""
    Q = Q .. GetHeader("Settings") ..
            [[<rect class="xfill" x="40" y="150" rx="5" ry="5" width="820" height="50" />]]
    if BackgroundMode == "" then
        Q = Q ..
                [[<text class="f30mxxx" x="440" y="185">Activate background</text>]]
    else
        Q = Q ..
                [[<text class="f30mxxx" x="440" y="185">Deactivate background (']] ..
                BackgroundMode .. [[', ]] ..
                string.format("%.0f", BackgroundModeOpacity * 100) ..
                [[%)</text>]]
    end
    Q = Q .. [[
        <rect class="xfill" x="40" y="220" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="240" y="255">Previous background</text>
        <rect class="xfill" x="460" y="220" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="660" y="255">Next background</text>

        <rect class="xfill" x="40" y="290" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="240" y="325">Decrease Opacity</text>
        <rect class="xfill" x="460" y="290" rx="5" ry="5" width="400" height="50" />
        <text class="f30mxxx" x="660" y="325">Increase Opacity</text>
    ]]
    Q = Q ..
            [[<rect class="xfill" x="40" y="360" rx="5" ry="5" width="820" height="50" />]] ..
            [[<text class="f30mxxx" x="440" y="395">Reset background and all colors</text>]]
    Q = Q .. [[<svg x=40 y=430 width=820 height=574>]] ..
            [[<rect class="xborder" x="0" y="0" rx="5" ry="5" width="820" height="574" stroke-dasharray="2 5" />]] ..
            [[<rect class="xborder" x="0" y="0" rx="5" ry="5" width="820" height="50" />]] ..
            [[<text class="f30mxx" x="410" y="35">Select and change any of the ]] ..
            #colorIDTable .. [[ HUD colors</text>]] ..
            [[<rect class="xfill" x="20" y="70" rx="5" ry="5" width="50" height="50" />]] ..
            [[<svg x=32 y=74><path d="M1,23.13,16.79,40.25a3.23,3.23,0,0,0,5.6-2.19V3.24a3.23,3.23,0,0,0-5.6-2.19L1,18.17A3.66,3.66,0,0,0,1,23.13Z" transform="translate(0.01 -0.01)"/></svg>]] ..
            [[<rect class="xfill" x="750" y="70" rx="5" ry="5" width="50" height="50" />]] ..
            [[<svg x=764 y=74><path d="M21.42,18.17,5.59,1.05A3.23,3.23,0,0,0,0,3.24V38.06a3.23,3.23,0,0,0,5.6,2.19L21.42,23.13A3.66,3.66,0,0,0,21.42,18.17Z" transform="translate(0.01 -0.01)"/></svg>]] ..
            [[<rect class="xborder" x="90" y="70" rx="5" ry="5" width="640" height="50" />]] ..
            [[<text class="f30mxx" x="410" y="105">]] ..
            colorIDTable[colorIDIndex].desc .. [[</text>]] ..
            [[<rect style="fill: #]] .. _G[colorIDTable[colorIDIndex].id] ..
            [[; fill-opacity: 1; stroke: #]] .. ColorPrimary ..
            [[; stroke-width:3;" x="90" y="140" rx="5" ry="5" width="640" height="70" />]] ..
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
            [[<text class=f30mxx x=95 y=80>]] ..
            string.sub(colorIDTable[colorIDIndex].newc, 1, 1) .. [[</text>]] ..
            [[<rect class=xborder x=145 y=50 rx=5 ry=5 width=80 height=40 />]] ..
            [[<text class=f30mxx x=185 y=80>]] ..
            string.sub(colorIDTable[colorIDIndex].newc, 2, 2) .. [[</text>]] ..
            [[<rect class=xborder x=235 y=50 rx=5 ry=5 width=80 height=40 />]] ..
            [[<text class=f30mxx x=275 y=80>]] ..
            string.sub(colorIDTable[colorIDIndex].newc, 3, 3) .. [[</text>]] ..
            [[<rect class=xborder x=325 y=50 rx=5 ry=5 width=80 height=40 />]] ..
            [[<text class=f30mxx x=365 y=80>]] ..
            string.sub(colorIDTable[colorIDIndex].newc, 4, 4) .. [[</text>]] ..
            [[<rect class=xborder x=415 y=50 rx=5 ry=5 width=80 height=40 />]] ..
            [[<text class=f30mxx x=455 y=80>]] ..
            string.sub(colorIDTable[colorIDIndex].newc, 5, 5) .. [[</text>]] ..
            [[<rect class=xborder x=505 y=50 rx=5 ry=5 width=80 height=40 />]] ..
            [[<text class=f30mxx x=545 y=80>]] ..
            string.sub(colorIDTable[colorIDIndex].newc, 6, 6) .. [[</text>]] ..
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
            [[</svg>]] .. [[<rect style="fill: #]] ..
            colorIDTable[colorIDIndex].newc .. [[; fill-opacity: 1; stroke: #]] ..
            ColorPrimary ..
            [[; stroke-width:3;" x="90" y="390" rx="5" ry="5" width="640" height="70" />]] ..
            [[<text class=f20sxx x=100 y=410>New color</text>]] ..
            [[<rect class=xfill x=290 y=480 rx=5 ry=5 width=440 height=50 />]] ..
            [[<text class=f30mxxx x=510 y=515>Apply new color</text>]] ..
            [[<rect class=xfill x=90 y=480 rx=5 ry=5 width=185 height=50 />]] ..
            [[<text class=f30mxxx x=182 y=515>Reset</text>]] .. [[</svg>]]
    Q = Q .. [[<svg x=940 y=150 width=936 height=774>]] ..
            [[<rect class=xborder x=0 y=0 rx=5 ry=5 width=936 height=774 stroke-dasharray="2 5" />]] ..
            [[<rect class=xborder x=0 y=0 rx=5 ry=5 width=936 height=50 />]] ..
            [[<text class=f30mxx x=468 y=35>Explanation / Hints</text>]] ..
            [[<text class=f30mxx x=468 y=400>Coming soon.</text>]]
    Q = Q .. [[</svg>]]
    if SimulationMode == true then
        Q = Q ..
                [[<rect class="cfill" x="940" y="954" rx="5" ry="5" width="936" height="50" /><text class="f30mxxx" x="1408" y="989">Simulating Damage to elements</text>]]
        AddClickArea("settings1", {
            id = "ToggleSimulation",
            mode = "settings1",
            x1 = 940,
            x2 = 1850,
            y1 = 919,
            y2 = 969
        })
    else
        Q = Q ..
                [[<rect class="xfill" x="940" y="954" rx="5" ry="5" width="936" height="50" /><text class="f30mxxx" x="1408" y="989">Simulate Damage to elements</text>]]
        AddClickArea("settings1", {
            id = "ToggleSimulation",
            mode = "settings1",
            x1 = 940,
            x2 = 1850,
            y1 = 919,
            y2 = 969
        })
    end
    return Q
end
function GetContentStartup()
    local Q = ""
    Q = Q .. GetElementLogo(812, 380, "f", "f", "f")
    if YourShipsName == "Enter here" then
        Q = Q .. [[<g><text class="f160m" x="960" y="330">Spaceship ID ]] ..
                ShipID .. [[</text><animate attributeName="fill" values="#]] ..
                ColorPrimary .. [[;#]] .. ColorSecondary .. [[;#]] ..
                ColorPrimary .. [[" dur="30s" repeatCount="indefinite" /></g>]]
    else
        Q = Q .. [[<g><text class="f160m" x="960" y="330">]] .. YourShipsName ..
                [[</text><animate attributeName="fill" values="#]] ..
                ColorPrimary .. [[;#]] .. ColorSecondary .. [[;#]] ..
                ColorPrimary .. [[" dur="30s" repeatCount="indefinite" /></g>]]
    end
    if ShowWelcomeMessage == true then
        Q =
            Q .. [[<text class="f50mx" x="960" y="750">Greetings, Commander ]] ..
                PlayerName .. [[.</text>]]
    end
    if #Warnings > 0 then
        Q = Q .. [[<text class="f25mc" x="960" y="880">Warning: ]] ..
                table.concat(Warnings, " ") .. [[</text>]]
    end
    Q = Q ..
            [[<text class="f30mxx" style="fill-opacity:0.2" x="960" y="1000">Damage Report v]] ..
            VERSION ..
            [[, by DorianGray - Discord: Dorian Gray#2623. Under GNU Public License 3.0.</text>]]
    return Q
end
function RenderScreen(m, a0)
    if a0 == nil then
        PrintConsole("ERROR: contentToRender is nil.")
        unit.exit()
    end
    CreateClickAreasForScreen(m)
    local Q = ""
    Q = Q .. [[
    <style>
      body{
        background-color: #]] .. ColorBackground .. [[; ]] ..
            GetContentBackground(BackgroundMode) .. [[
      }
      .screen { width: 1920px; height: 1120px; }
      .main { width: 1920px; height: 1040px; }
      .menu { width: 1920px; height: 70px; stroke: #]] .. ColorPrimary ..
            [[; stroke-width: 3; }

      .xline { stroke: #]] .. ColorPrimary .. [[; stroke-width: 3;}
      .daline { stroke: #]] .. ColorSecondary .. [[; stroke-dasharray: 2 5; }
      .ll { fill: #FF55FF; stroke: #FF0000}
      .xborder { fill:#]] .. ColorPrimary .. [[; fill-opacity:0.05; stroke: #]] ..
            ColorPrimary .. [[; stroke-width:3; }
      .xfill { fill:#]] .. ColorPrimary .. [[; fill-opacity:1; }
      .xbfill { fill:#]] .. ColorPrimary .. [[; fill-opacity:1; stroke: #]] ..
            ColorPrimary .. [[; stroke-width:3; }
      .cfill { fill:#]] .. ColorCritical .. [[; fill-opacity:1; }

      .hlrect { fill: #]] .. ColorPrimary .. [[; }
      .cx { fill: #]] .. ColorPrimary .. [[; }
      .ch { fill: #]] .. ColorHealthy .. [[; }
      .cw { fill: #]] .. ColorWarning .. [[; } 
      .cc { fill: #]] .. ColorCritical .. [[; }

      .f { fill:#]] .. ColorPrimary .. [[; }
      .f2 { fill:#]] .. ColorSecondary .. [[; }
      .f3 { fill:#]] .. ColorTertiary .. [[; }
      .f250mx { font-size: 250px; text-anchor: middle; fill: #]] .. ColorPrimary ..
            [[; font-family: Impact, Charcoal, sans-serif; }
      .f160m { font-size: 160px; text-anchor: middle; font-family: Impact, Charcoal, sans-serif; }
      .f160mx { font-size: 160px; text-anchor: middle; fill: #]] .. ColorPrimary ..
            [[; font-family: Impact, Charcoal, sans-serif; }
      .f100mx { font-size: 100px; text-anchor: middle; fill: #]] .. ColorPrimary ..
            [[; font-family: Impact, Charcoal, sans-serif; }
      .f80mxx07 { opacity:0.7; font-size: 80px; text-anchor: middle; fill: #]] ..
            ColorSecondary .. [[; font-family: Impact, Charcoal, sans-serif; }
      .f80mc { opacity:1; font-size: 80px; text-anchor: middle; fill: #]] ..
            ColorCritical .. [[; font-family: Impact, Charcoal, sans-serif; }
      .f60s { font-size: 60px; text-anchor: start; }
      .f60m { font-size: 60px; text-anchor: middle; }
      .f60e { font-size: 60px; text-anchor: end; }
      .f60mx { font-size: 60px; text-anchor: middle; fill: #]] .. ColorPrimary ..
            [[; font-family: Impact, Charcoal, sans-serif; }
      .f60mxx { font-size: 60px; text-anchor: middle; fill: #]] ..
            ColorSecondary .. [[; font-family: Impact, Charcoal, sans-serif; }
      .f60mxx07 { opacity:0.7; font-size: 60px; text-anchor: middle; fill: #]] ..
            ColorSecondary .. [[; font-family: Impact, Charcoal, sans-serif; }
      .f60mc { opacity:1; font-size: 60px; text-anchor: middle; fill: #]] ..
            ColorCritical .. [[; font-family: Impact, Charcoal, sans-serif; }
      .f60mw { opacity:1; font-size: 60px; text-anchor: middle; fill: #]] ..
            ColorWarning .. [[; font-family: Impact, Charcoal, sans-serif; }
      .f50m { font-size: 50px; text-anchor: middle; }
      .f50sxx { font-size: 50px; text-anchor: start; fill: #]] .. ColorSecondary ..
            [[; }
      .f50mx { font-size: 50px; fill: #]] .. ColorPrimary ..
            [[; fill-opacity: 1; text-anchor: middle; }
      .f50mx02 { font-size: 50px; fill: #]] .. ColorPrimary ..
            [[; fill-opacity: 0.2; text-anchor: middle; }
      .f50mxx { font-size: 50px; fill: #]] .. ColorSecondary ..
            [[; fill-opacity: 1; text-anchor: middle }
      .f36mxx { font-size: 36px; fill: #]] .. ColorSecondary ..
            [[; fill-opacity: 1; text-anchor: middle }
      .f30mx { font-size: 30px; fill: #]] .. ColorPrimary ..
            [[; fill-opacity: 1; text-anchor: middle; }
      .f30sxx { font-size: 30px; fill: #]] .. ColorSecondary ..
            [[; fill-opacity: 1; text-anchor: start; }
      .f30exx { font-size: 30px; fill: #]] .. ColorSecondary ..
            [[; fill-opacity: 1; text-anchor: end; }
      .f30mxx { font-size: 30px; fill: #]] .. ColorSecondary ..
            [[; fill-opacity: 1; text-anchor: middle; }
      .f30mxxx { font-size: 30px; fill: #]] .. ColorTertiary ..
            [[; fill-opacity: 1; text-anchor: middle; }
      .f25sx { font-size: 25px; text-anchor: start; fill: #]] .. ColorPrimary ..
            [[; }
      .f25exx { font-size: 25px; text-anchor: end; fill: #]] .. ColorSecondary ..
            [[; }
      .f25sxx { font-size: 25px; text-anchor: start; fill: #]] .. ColorSecondary ..
            [[; }
      .f25mw { font-size: 25px; text-anchor: middle; fill: #]] .. ColorWarning ..
            [[; }
      .f25mr { font-size: 25px; text-anchor: middle; fill: #]] .. ColorCritical ..
            [[; }
      .f25ew { font-size: 25px; text-anchor: end; fill: #]] .. ColorWarning ..
            [[; }
      .f25ec { font-size: 25px; text-anchor: end; fill: #]] .. ColorCritical ..
            [[; }
      .f25mc { font-size: 25px; text-anchor: middle; fill: #]] .. ColorCritical ..
            [[; }
      .f20sxx { font-size: 20px; text-anchor: start; fill: #]] .. ColorSecondary ..
            [[; }
      .f20mxx { font-size: 20px; text-anchor: middle; fill: #]] ..
            ColorSecondary .. [[; }
    </style>
    <svg class=screen viewBox="0 0 1920 1120">
      <svg class=main x=0 y=0>]]
    Q = Q .. a0;
    if m.mode == "startup" then
        Q = Q ..
                [[<rect class=xborder x=0 y=0 rx=5 ry=5 width=1920 height=1040 />]]
    else
        Q = Q ..
                [[<rect class=xborder x=0 y=70 rx=5 ry=5 width=1920 height=970 />]]
    end
    Q = Q .. [[
      </svg>
      <svg class=menu x=0 y=1050>
        <rect class=xline x=0 y=0 rx=5 ry=5 width=1920 height=70 fill=#]] ..
            ColorBackground .. [[ />
        <text class=f50mx x=96 y=50>TIME</text>
        <text class=f50mx x=288 y=50>DMG</text>
        <text class=f50mx x=480 y=50>DMGO</text>
        <text class=f50mx x=672 y=50>FUEL</text>]]
    Q = Q .. [[
        <text class=f50mx x=1632 y=50>HUD</text>
        <text class=f50mx x=1824 y=50>SETS</text>
        <line class=xline x1=192 y1=10 x2=192 y2=60 />
        <line class=xline x1=384 y1=10 x2=384 y2=60 />
        <line class=xline x1=576 y1=10 x2=576 y2=60 />
        <line class=xline x1=768 y1=10 x2=768 y2=60 />]] ..
            [[<line class=xline x1=1536 y1=10 x2=1536 y2=60 />
        <line class=xline x1=1728 y1=10 x2=1728 y2=60 />]]
    if HUDMode == true then
        Q = Q .. [[
            <rect class=hlrect x=1544 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1632 y=50>HUD</text>
            ]]
    end
    if m.mode == "damage" then
        Q = Q .. [[
            <rect class=hlrect x=200 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=288 y=50>DMG</text>
            ]]
    elseif m.mode == "damageoutline" then
        Q = Q .. [[
            <rect class=hlrect x=392 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=480 y=50>DMGO</text>
            ]]
    elseif m.mode == "fuel" then
        Q = Q .. [[
            <rect class=hlrect x=584 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=672 y=50>FUEL</text>
            ]]
    elseif m.mode == "flight" then
        Q = Q .. [[
            <rect class=hlrect x=776 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=864 y=50>FLGT</text>
            ]]
    elseif m.mode == "cargo" then
        Q = Q .. [[
            <rect class=hlrect x=968 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1056 y=50>CRGO</text>
            ]]
    elseif m.mode == "agg" then
        Q = Q .. [[
            <rect class=hlrect x=1160 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1248 y=50>AGG</text>
            ]]
    elseif m.mode == "map" then
        Q = Q .. [[
            <rect class=hlrect x=1352 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1440 y=50>MAP</text>
            ]]
    elseif m.mode == "time" then
        Q = Q .. [[
            <rect class=hlrect x=8 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=96 y=50>TIME</text>
            ]]
    elseif m.mode == "settings1" then
        Q = Q .. [[
            <rect class=hlrect x=1736 y=6 rx=0 ry=0 width=176 height=58 />
            <text class=f50mxx x=1824 y=50>SETS</text>
            ]]
    end
    Q = Q .. [[</svg>]]
    Q = Q .. [[</svg>]]
    local a1 = string.len(Q)
    m.element.setSVG(Q)
end
function RenderScreens(a2, a3)
    a2 = a2 or "all"
    a3 = a3 or "all"
    if screens ~= nil and #screens > 0 then
        local a4 = ""
        local a5 = ""
        local a6 = ""
        local a7 = ""
        local a8 = ""
        local a9 = ""
        local aa = ""
        local ab = ""
        local ac = ""
        local ad = ""
        local ae = ""
        local af = ""
        for J, m in pairs(screens) do
            if m.refresh == true then
                local a0 = ""
                if m.mode == "flight" and (a2 == "flight" or a2 == "all") then
                    if a4 == "" then a4 = GetContentFlight() end
                    a0 = a4
                elseif m.mode == "damage" and (a2 == "damage" or a2 == "all") then
                    if a5 == "" then a5 = GetContentDamage() end
                    a0 = a5
                elseif m.mode == "damageoutline" and
                    (a2 == "damageoutline" or a2 == "all") then
                    if m.submode == "" then
                        m.submode = "top"
                        screens[J].submode = "top"
                    end
                    if m.submode == "top" and (a3 == "top" or a3 == "all") then
                        if a6 == "" then
                            a6 = GetContentDamageoutline(m)
                        end
                        a0 = a6
                    end
                    if m.submode == "side" and (a3 == "side" or a3 == "all") then
                        if a7 == "" then
                            a7 = GetContentDamageoutline(m)
                        end
                        a0 = a7
                    end
                    if m.submode == "front" and (a3 == "front" or a3 == "all") then
                        if a8 == "" then
                            a8 = GetContentDamageoutline(m)
                        end
                        a0 = a8
                    end
                elseif m.mode == "fuel" and (a2 == "fuel" or a2 == "all") then
                    m = WipeClickAreasForScreen(screens[J])
                    a0 = GetContentFuel(m)
                elseif m.mode == "cargo" and (a2 == "cargo" or a2 == "all") then
                    if aa == "" then aa = GetContentCargo() end
                    a0 = aa
                elseif m.mode == "agg" and (a2 == "agg" or a2 == "all") then
                    if ab == "" then ab = GetContentAGG() end
                    a0 = ab
                elseif m.mode == "map" and (a2 == "map" or a2 == "all") then
                    if ac == "" then ac = GetContentMap() end
                    a0 = ac
                elseif m.mode == "time" and (a2 == "time" or a2 == "all") then
                    if ad == "" then ad = GetContentTime() end
                    a0 = ad
                elseif m.mode == "settings1" and
                    (a2 == "settings1" or a2 == "all") then
                    if ae == "" then
                        ae = GetContentSettings1()
                    end
                    a0 = ae
                elseif m.mode == "startup" and (a2 == "startup" or a2 == "all") then
                    if af == "" then af = GetContentStartup() end
                    a0 = af
                else
                    a0 = "Invalid screen mode. ('" .. m.mode .. "')"
                end
                if a0 ~= "" then
                    RenderScreen(m, a0)
                else
                    DrawCenteredText(
                        "ERROR: No contentToRender delivered for " .. m.mode)
                    PrintConsole("ERROR: No contentToRender delivered for " ..
                                     m.mode)
                    unit.exit()
                end
                screens[J].refresh = false
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
function OnTickData(C)
    if formerTime + 60 < system.getTime() then SetRefresh("time") end
    totalShipMass = core.getConstructMass()
    if formerTotalShipMass ~= totalShipMass then
        UpdateDamageData(true)
        UpdateTypeData()
        SetRefresh()
        formerTotalShipMass = totalShipMass
    else
        UpdateDamageData(C)
        UpdateTypeData()
    end
    RenderScreens()
end
unit.hide()
ClearConsole()
PrintConsole("DAMAGE REPORT v" .. VERSION .. " STARTED", true)
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
if SkillRepairToolEfficiency == 0 and SkillRepairToolOptimization == 0 and
    StatFuelTankOptimization == 0 and StatContainerOptimization == 0 and
    StatAtmosphericFuelTankHandling == 0 and StatSpaceFuelTankHandling == 0 and
    StatRocketFuelTankHandling == 0 then
    table.insert(Warnings, "No talents/stats set in LUA settings.")
end
if SkillRepairToolEfficiency < 0 or SkillRepairToolOptimization < 0 or
    StatFuelTankOptimization < 0 or StatContainerOptimization < 0 or
    StatAtmosphericFuelTankHandling < 0 or StatSpaceFuelTankHandling < 0 or
    StatRocketFuelTankHandling < 0 or SkillRepairToolEfficiency > 5 or
    SkillRepairToolOptimization > 5 or StatFuelTankOptimization > 5 or
    StatContainerOptimization > 5 or StatAtmosphericFuelTankHandling > 5 or
    StatSpaceFuelTankHandling > 5 or StatRocketFuelTankHandling > 5 then
    PrintConsole(
        "ERROR: Talents/stats can only range from 0 to 5. Please set correctly in LUA settings and reactivate script.")
    unit.exit()
end
if screens == nil or #screens == 0 then
    HUDMode = true;
    PrintConsole("Warning: No screens connected. Entering HUD mode only.")
end
OnTickData(true)
unit.setTimer('UpdateData', UpdateDataInterval)
unit.setTimer('UpdateHighlight', HighlightBlinkingInterval)
