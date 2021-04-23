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

function GenerateCommaValue(a, b, c)
    b = b or false;
    c = c or 1;
    local d = a;
    if b == true then
        if string.len(a) >= 4 then
            d = string.format("%." .. c .. "fk", a / 1000)
        else
            d = string.format("%." .. c .. "f", a)
        end
    else
        while true do
            d, k = string.gsub(d, "^(-?%d+)(%d%d%d)", '%1,%2')
            if k == 0 then break end
        end
    end
    return d
end
function PrintConsole(e, f)
    f = f or false;
    if f then
        system.print(
            "------------------------------------------------------------------------")
    end
    system.print(e)
    if f then
        system.print(
            "------------------------------------------------------------------------")
    end
end
function DrawCenteredText(e)
    if screens ~= nil and #screens > 0 then
        for g = 1, #screens, 1 do screens[g].element.setCenteredText(e) end
    end
end
function ClearConsole() for g = 1, 10, 1 do PrintConsole() end end
function SwitchScreens(h)
    h = h or "on"
    if screens ~= nil and #screens > 0 then
        for g = 1, #screens, 1 do
            if h == "on" then
                screens[g].element.clear()
                screens[g].element.activate()
                screens[g].active = true
            else
                screens[g].element.clear()
                screens[g].element.deactivate()
                screens[g].active = false
            end
        end
    end
end
function GetSecondsString(i)
    local i = tonumber(i)
    if i == nil or i <= 0 then
        return "-"
    else
        days = string.format("%2.f", math.floor(i / (3600 * 24)))
        hours = string.format("%2.f", math.floor(i / 3600 - days * 24))
        mins = string.format("%2.f",
                             math.floor(i / 60 - hours * 60 - days * 24 * 60))
        secs = string.format("%2.f", math.floor(
                                 i - hours * 3600 - days * 24 * 60 * 60 - mins *
                                     60))
        str = ""
        if tonumber(days) > 0 then str = str .. days .. "d " end
        if tonumber(hours) > 0 then str = str .. hours .. "h " end
        if tonumber(mins) > 0 then str = str .. mins .. "m " end
        if tonumber(secs) > 0 then str = str .. secs .. "s" end
        return str
    end
end
function replace_char(j, str, l) return str:sub(1, j - 1) .. l .. str:sub(j + 1) end
function epochTime()
    function rZ(m)
        if string.len(m) <= 1 then
            return "0" .. m
        else
            return m
        end
    end
    function dPoint(n)
        if not (n == math.floor(n)) then
            return true
        else
            return false
        end
    end
    function lYear(year)
        if not dPoint(year / 4) then
            if dPoint(year / 100) then
                return true
            else
                if not dPoint(year / 400) then
                    return true
                else
                    return false
                end
            end
        else
            return false
        end
    end
    local o = 5;
    local p = 3600;
    local q = 86400;
    local r = 31536000;
    local s = 31622400;
    local t = 2419200;
    local g = 2505600;
    local u = 2592000;
    local k = 2678400;
    local w = {4, 6, 9, 11}
    local x = {1, 3, 5, 7, 8, 10, 12}
    local y = 0;
    local z = 1506816000;
    local A = system.getTime()
    _G["formerTime"] = A;
    if AddSummertimeHour == true then A = A + 3600 end
    now = math.floor(A + z)
    year = 1970;
    secs = 0;
    y = 0;
    while secs + s < now or secs + r < now do
        if lYear(year + 1) then
            if secs + s < now then
                secs = secs + s;
                year = year + 1;
                y = y + 366
            end
        else
            if secs + r < now then
                secs = secs + r;
                year = year + 1;
                y = y + 365
            end
        end
    end
    secondsRemaining = now - secs;
    monthSecs = 0;
    yearlYear = lYear(year)
    month = 1;
    while monthSecs + t < secondsRemaining or monthSecs + u < secondsRemaining or
        monthSecs + k < secondsRemaining do
        if month == 1 then
            if monthSecs + k < secondsRemaining then
                month = 2;
                monthSecs = monthSecs + k;
                y = y + 31
            else
                break
            end
        end
        if month == 2 then
            if not yearlYear then
                if monthSecs + t < secondsRemaining then
                    month = 3;
                    monthSecs = monthSecs + t;
                    y = y + 28
                else
                    break
                end
            else
                if monthSecs + g < secondsRemaining then
                    month = 3;
                    monthSecs = monthSecs + g;
                    y = y + 29
                else
                    break
                end
            end
        end
        if month == 3 then
            if monthSecs + k < secondsRemaining then
                month = 4;
                monthSecs = monthSecs + k;
                y = y + 31
            else
                break
            end
        end
        if month == 4 then
            if monthSecs + u < secondsRemaining then
                month = 5;
                monthSecs = monthSecs + u;
                y = y + 30
            else
                break
            end
        end
        if month == 5 then
            if monthSecs + k < secondsRemaining then
                month = 6;
                monthSecs = monthSecs + k;
                y = y + 31
            else
                break
            end
        end
        if month == 6 then
            if monthSecs + u < secondsRemaining then
                month = 7;
                monthSecs = monthSecs + u;
                y = y + 30
            else
                break
            end
        end
        if month == 7 then
            if monthSecs + k < secondsRemaining then
                month = 8;
                monthSecs = monthSecs + k;
                y = y + 31
            else
                break
            end
        end
        if month == 8 then
            if monthSecs + k < secondsRemaining then
                month = 9;
                monthSecs = monthSecs + k;
                y = y + 31
            else
                break
            end
        end
        if month == 9 then
            if monthSecs + u < secondsRemaining then
                month = 10;
                monthSecs = monthSecs + u;
                y = y + 30
            else
                break
            end
        end
        if month == 10 then
            if monthSecs + k < secondsRemaining then
                month = 11;
                monthSecs = monthSecs + k;
                y = y + 31
            else
                break
            end
        end
        if month == 11 then
            if monthSecs + u < secondsRemaining then
                month = 12;
                monthSecs = monthSecs + u;
                y = y + 30
            else
                break
            end
        end
    end
    day = 1;
    daySecs = 0;
    daySecsRemaining = secondsRemaining - monthSecs;
    while daySecs + q < daySecsRemaining do
        day = day + 1;
        daySecs = daySecs + q;
        y = y + 1
    end
    hour = 0;
    hourSecs = 0;
    hourSecsRemaining = daySecsRemaining - daySecs;
    while hourSecs + p < hourSecsRemaining do
        hour = hour + 1;
        hourSecs = hourSecs + p
    end
    minute = 0;
    minuteSecs = 0;
    minuteSecsRemaining = hourSecsRemaining - hourSecs;
    while minuteSecs + 60 < minuteSecsRemaining do
        minute = minute + 1;
        minuteSecs = minuteSecs + 60
    end
    second = math.floor(now % 60)
    year = rZ(year)
    month = rZ(month)
    day = rZ(day)
    hour = rZ(hour)
    minute = rZ(minute)
    second = rZ(second)
    return [[<text class="f250mx" x="960" y="540">]] .. hour .. ":" .. minute ..
               [[</text>]] .. [[<text class="f100mx" x="960" y="660">]] .. year ..
               "/" .. month .. "/" .. day .. [[</text>]]
end
function ToggleHUD()
    if HUDMode == true then
        HUDMode = false;
        forceDamageRedraw = true;
        hudSelectedIndex = 0;
        highlightID = 0;
        HideHighlight()
        SetRefresh()
        RenderScreens()
    else
        HUDMode = true;
        forceDamageRedraw = true;
        hudSelectedIndex = 0;
        highlightID = 0;
        HideHighlight()
        SetRefresh()
        RenderScreens()
    end
end
function HudDeselectElement()
    hudSelectedIndex = 0;
    hudStartIndex = 1;
    highlightID = 0;
    HideHighlight()
    if HUDMode == true then
        SetRefresh("damage")
        SetRefresh("damageoutline")
        RenderScreens()
    end
end
function ChangeHudSelectedElement(B)
    if HUDMode == true and #rE > 0 then
        hudSelectedIndex = hudSelectedIndex + B;
        if hudSelectedIndex < 1 then
            hudSelectedIndex = 1
        elseif hudSelectedIndex > #rE then
            hudSelectedIndex = #rE
        end
        if hudSelectedIndex > 9 then hudStartIndex = hudSelectedIndex - 9 end
        if hudSelectedIndex ~= 0 then
            highlightID = rE[hudSelectedIndex].id;
            if highlightID ~= nil and highlightID ~= 0 then
                HideHighlight()
                elementPosition = vec3(rE[hudSelectedIndex].pos)
                highlightX = elementPosition.x - coreWorldOffset;
                highlightY = elementPosition.y - coreWorldOffset;
                highlightZ = elementPosition.z - coreWorldOffset;
                highlightOn = true;
                ShowHighlight()
            end
        end
        SetRefresh("damage")
        SetRefresh("damageoutline")
        RenderScreens()
    end
end
function HideHighlight()
    if #hudArrowSticker > 0 then
        for g in pairs(hudArrowSticker) do
            core.deleteSticker(hudArrowSticker[g])
        end
        hudArrowSticker = {}
    end
end
function ShowHighlight()
    if highlightOn == true and highlightID > 0 then
        table.insert(hudArrowSticker, core.spawnArrowSticker(highlightX + 2,
                                                             highlightY,
                                                             highlightZ, "north"))
        table.insert(hudArrowSticker, core.spawnArrowSticker(highlightX,
                                                             highlightY - 2,
                                                             highlightZ, "east"))
        table.insert(hudArrowSticker, core.spawnArrowSticker(highlightX - 2,
                                                             highlightY,
                                                             highlightZ, "south"))
        table.insert(hudArrowSticker, core.spawnArrowSticker(highlightX,
                                                             highlightY + 2,
                                                             highlightZ, "west"))
        table.insert(hudArrowSticker, core.spawnArrowSticker(highlightX,
                                                             highlightY,
                                                             highlightZ - 2,
                                                             "up"))
        table.insert(hudArrowSticker, core.spawnArrowSticker(highlightX,
                                                             highlightY,
                                                             highlightZ + 2,
                                                             "down"))
    end
end
function ToggleHighlight()
    if highlightOn == true then
        highlightOn = false;
        HideHighlight()
    else
        highlightOn = true;
        ShowHighlight()
    end
end
function SortDamageTables()
    table.sort(damagedElements,
               function(m, n) return m.missinghp > n.missinghp end)
    table.sort(brokenElements, function(m, n) return m.maxhp > n.maxhp end)
end
function getScraps(C, D)
    D = D or false;
    C = C - SkillRepairToolOptimization * 0.05 * C;
    local E = math.ceil(C / (10 * 5 ^ (ScrapTier - 1)))
    if D == true then
        return GenerateCommaValue(string.format("%.0f", E), false)
    else
        return E
    end
end
function getRepairTime(C, F)
    F = F or false;
    C = C - SkillRepairToolOptimization * 0.05 * C;
    local E = math.ceil(C / ScrapTierRepairTimes[ScrapTier])
    E = E - SkillRepairToolEfficiency * 0.1 * E;
    if F == true then
        return GetSecondsString(string.format("%.0f", E))
    else
        return E
    end
end
function UpdateDataDamageoutline()
    dmgoElements = {}
    for g, G in ipairs(brokenElements) do
        if #dmgoElements < DMGOMaxElements then
            local elementPosition = vec3(G.pos)
            local H = elementPosition.x - coreWorldOffset;
            local I = elementPosition.y - coreWorldOffset;
            local J = elementPosition.z - coreWorldOffset;
            if H < ShipXmin then ShipXmin = H end
            if I < ShipYmin then ShipYmin = I end
            if J < ShipZmin then ShipZmin = J end
            if H > ShipXmax then ShipXmax = H end
            if I > ShipYmax then ShipYmax = I end
            if J > ShipZmax then ShipZmax = J end
            table.insert(dmgoElements, {
                id = G.id,
                type = "b",
                size = G.maxhp,
                x = H,
                y = I,
                z = J,
                xp = 0,
                yp = 0,
                zp = 0,
                u = 0,
                v = 0
            })
        end
    end
    if #dmgoElements < DMGOMaxElements then
        for g, G in ipairs(damagedElements) do
            if #dmgoElements < DMGOMaxElements then
                local elementPosition = vec3(G.pos)
                local H = elementPosition.x - coreWorldOffset;
                local I = elementPosition.y - coreWorldOffset;
                local J = elementPosition.z - coreWorldOffset;
                if H < ShipXmin then ShipXmin = H end
                if I < ShipYmin then ShipYmin = I end
                if J < ShipZmin then ShipZmin = J end
                if H > ShipXmax then ShipXmax = H end
                if I > ShipYmax then ShipYmax = I end
                if J > ShipZmax then ShipZmax = J end
                table.insert(dmgoElements, {
                    id = G.id,
                    type = "d",
                    size = G.maxhp,
                    x = H,
                    y = I,
                    z = J,
                    xp = 0,
                    yp = 0,
                    zp = 0,
                    u = 0,
                    v = 0
                })
            end
        end
    end
    if #dmgoElements < DMGOMaxElements then
        for g, G in ipairs(healthyElements) do
            if #dmgoElements < DMGOMaxElements then
                local elementPosition = vec3(G.pos)
                local H = elementPosition.x - coreWorldOffset;
                local I = elementPosition.y - coreWorldOffset;
                local J = elementPosition.z - coreWorldOffset;
                if H < ShipXmin then ShipXmin = H end
                if I < ShipYmin then ShipYmin = I end
                if J < ShipZmin then ShipZmin = J end
                if H > ShipXmax then ShipXmax = H end
                if I > ShipYmax then ShipYmax = I end
                if J > ShipZmax then ShipZmax = J end
                table.insert(dmgoElements, {
                    id = G.id,
                    type = "h",
                    size = G.maxhp,
                    x = H,
                    y = I,
                    z = J,
                    xp = 0,
                    yp = 0,
                    zp = 0,
                    u = 0,
                    v = 0
                })
            end
        end
    end
    ShipX = math.abs(ShipXmax - ShipXmin)
    ShipY = math.abs(ShipYmax - ShipYmin)
    ShipZ = math.abs(ShipZmax - ShipZmin)
    for g, G in ipairs(dmgoElements) do
        dmgoElements[g].xp = math.abs(100 / (ShipXmax - ShipXmin) *
                                          (G.x - ShipXmin))
        dmgoElements[g].yp = math.abs(100 / (ShipYmax - ShipYmin) *
                                          (G.y - ShipYmin))
        dmgoElements[g].zp = math.abs(100 / (ShipZmax - ShipZmin) *
                                          (G.z - ShipZmin))
    end
end
function UpdateViewDamageoutline(K)
    UFrame = 40;
    VFrame = 40;
    UStart = 20 + UFrame;
    VStart = 180 + VFrame;
    UDim = 1880 - 2 * UFrame;
    VDim = 840 - 2 * VFrame;
    if K.submode == "top" then
        if DMGOStretch == false then
            local L = UDim / (ShipYmax - ShipYmin)
            local M = VDim / (ShipXmax - ShipXmin)
            if L >= M then
                local N = L / M;
                local O = math.floor(UDim / N)
                UStart = UStart + (UDim - O) / 2;
                for g, G in ipairs(dmgoElements) do
                    dmgoElements[g].u = math.floor(
                                            UDim / 100 / N * G.yp + UStart)
                    dmgoElements[g].v = math.floor(VDim / 100 * G.xp + VStart)
                end
            else
                local N = M / L;
                local P = math.floor(VDim / N)
                VStart = VStart + (VDim - P) / 2;
                for g, G in ipairs(dmgoElements) do
                    dmgoElements[g].u = math.floor(UDim / 100 * G.yp + UStart)
                    dmgoElements[g].v = math.floor(
                                            VDim / 100 / N * G.xp + VStart)
                end
            end
        else
            for g, G in ipairs(dmgoElements) do
                dmgoElements[g].u = math.floor(UDim / 100 * G.yp + UStart)
                dmgoElements[g].v = math.floor(VDim / 100 * G.xp + VStart)
            end
        end
    elseif K.submode == "front" then
        if DMGOStretch == false then
            local L = UDim / (ShipXmax - ShipXmin)
            local M = VDim / (ShipZmax - ShipZmin)
            if L >= M then
                local N = L / M;
                local O = math.floor(UDim / N)
                UStart = UStart + (UDim - O) / 2;
                for g, G in ipairs(dmgoElements) do
                    dmgoElements[g].u = math.floor(
                                            UDim / 100 / N * G.xp + UStart)
                    dmgoElements[g].v = math.floor(
                                            VDim / 100 * (100 - G.zp) + VStart)
                end
            else
                local N = M / L;
                local P = math.floor(VDim / N)
                VStart = VStart + (VDim - P) / 2;
                for g, G in ipairs(dmgoElements) do
                    dmgoElements[g].u = math.floor(UDim / 100 * G.xp + UStart)
                    dmgoElements[g].v = math.floor(
                                            VDim / 100 / N * (100 - G.zp) +
                                                VStart)
                end
            end
        else
            for g, G in ipairs(dmgoElements) do
                dmgoElements[g].u = math.floor(UDim / 100 * G.xp + UStart)
                dmgoElements[g].v = math.floor(
                                        VDim / 100 * (100 - G.zp) + VStart)
            end
        end
    elseif K.submode == "side" then
        if DMGOStretch == false then
            local L = UDim / (ShipYmax - ShipYmin)
            local M = VDim / (ShipXmax - ShipZmin)
            if L >= M then
                local N = L / M;
                local O = math.floor(UDim / N)
                UStart = UStart + (UDim - O) / 2;
                for g, G in ipairs(dmgoElements) do
                    dmgoElements[g].u = math.floor(
                                            UDim / 100 / N * G.yp + UStart)
                    dmgoElements[g].v = math.floor(
                                            VDim / 100 * (100 - G.zp) + VStart)
                end
            else
                local N = M / L;
                local P = math.floor(VDim / N)
                VStart = VStart + (VDim - P) / 2;
                for g, G in ipairs(dmgoElements) do
                    dmgoElements[g].u = math.floor(UDim / 100 * G.yp + UStart)
                    dmgoElements[g].v = math.floor(
                                            VDim / 100 / N * (100 - G.zp) +
                                                VStart)
                end
            end
        else
            for g, G in ipairs(dmgoElements) do
                dmgoElements[g].u = math.floor(UDim / 100 * G.yp + UStart)
                dmgoElements[g].v = math.floor(
                                        VDim / 100 * (100 - G.zp) + VStart)
            end
        end
    else
        DrawCenteredText("ERROR: non-existing DMGO mode set.")
        PrintConsole("ERROR: non-existing DMGO mode set.")
        unit.exit()
    end
end
function GetDamageoutlineShip()
    local e = ""
    for g, G in ipairs(dmgoElements) do
        local Q = ""
        local R = 1;
        if G.type == "h" then
            Q = "ch"
        elseif G.type == "d" then
            Q = "cw"
        else
            Q = "cc"
        end
        if G.id == highlightID then Q = "f2" end
        if G.size > 0 and G.size < 1000 then
            R = 5
        elseif G.size >= 1000 and G.size < 2000 then
            R = 8
        elseif G.size >= 2000 and G.size < 5000 then
            R = 12
        elseif G.size >= 5000 and G.size < 10000 then
            R = 15
        elseif G.size >= 10000 and G.size < 20000 then
            R = 20
        elseif G.size >= 20000 then
            R = 30
        end
        e = e .. [[<circle cx=]] .. G.u .. [[ cy=]] .. G.v .. [[ r=]] .. R ..
                [[ class=]] .. Q .. [[ />]]
        if G.id == highlightID then
            e =
                e .. [[<line class=daline x1=20 y1=]] .. G.v .. [[ x2=1900 y2=]] ..
                    G.v .. [[ />]]
            e =
                e .. [[<line class=daline x1=]] .. G.u .. [[ y1=180 x2=]] .. G.u ..
                    [[ y2=1020 />]]
        end
    end
    return e
end
function GetContentClickareas(K)
    local e = ""
    if K ~= nil and K.ClickAreas ~= nil and #K.ClickAreas > 0 then
        for g, S in ipairs(K.ClickAreas) do
            e =
                e .. [[<rect class=ll x=]] .. S.x1 .. [[ width=]] .. S.x2 - S.x1 ..
                    [[ y=]] .. S.y1 .. [[ height=]] .. S.y2 - S.y1 .. [[ />]]
        end
    end
    return e
end
function GetElement1(H, I, T, U)
    H = H or 0;
    I = I or 0;
    T = T or 600;
    U = U or 600;
    local e = ""
    e = e .. [[<svg x="]] .. H .. [[px" y="]] .. I .. [[px" width="]] .. T ..
            [[px" height="]] .. U .. [[px" viewBox="0 0 200 200">
            <g>
              <path fill="none" stroke="#]] .. ColorTertiary ..
            [[" stroke-width="3" stroke-miterlimit="10" d="M138.768,100c0,21.411-17.356,38.768-38.768,38.768c-21.411,0-38.768-17.356-38.768-38.768c0-21.411,17.357-38.768,38.768-38.768"/>
              <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 100 100" to="360 100 100" dur="8s" repeatCount="indefinite"/>
            </g>
            <g>
              <path fill="none" stroke="#]] .. ColorTertiary ..
            [[" stroke-width="3" stroke-miterlimit="10" d="M132.605,100c0,18.008-14.598,32.605-32.605,32.605c-18.007,0-32.605-14.598-32.605-32.605c0-18.007,14.598-32.605,32.605-32.605"/>
              <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 100 100" to="360 100 100" dur="4s" repeatCount="indefinite"/>
            </g>
            <g>
              <path fill="none" stroke="#]] .. ColorTertiary ..
            [[" stroke-width="3" stroke-miterlimit="10" d="M126.502,100c0,14.638-11.864,26.502-26.502,26.502c-14.636,0-26.501-11.864-26.501-26.502c0-14.636,11.865-26.501,26.501-26.501"/>
              <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 100 100" to="360 100 100" dur="2s" repeatCount="indefinite"/>
            </g>
            <g>
              <path fill="none" stroke="#]] .. ColorTertiary ..
            [[" stroke-width="3" stroke-miterlimit="10" d="M120.494,100c0,11.32-9.174,20.494-20.494,20.494c-11.319,0-20.495-9.174-20.495-20.494c0-11.319,9.176-20.495,20.495-20.495"/>
              <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 100 100" to="360 100 100" dur="1s" repeatCount="indefinite"/>
            </g>
        </svg>]]
    return e
end
function GetElement2(H, I)
    H = H or 0;
    I = I or 0;
    local e = ""
    e = e .. [[<svg x="]] .. H .. [[" y="]] .. I ..
            [["><rect class="f" y="13.25" width="1356.84" height="1.96"/><rect class="f" x="49.27" y="12.27" width="44.12" height="3.93"/><rect class="f" x="142.33" y="10.3" width="109.16" height="7.85"/><rect class="f" x="320.08" y="10.3" width="32.52" height="7.85"/><rect class="f" x="379.01" y="12.27" width="106.26" height="3.93"/><rect class="f" x="565.14" y="12.27" width="15.78" height="3.93"/><rect class="f" x="607.64" y="12.27" width="63.44" height="3.93"/><rect class="f" x="692.98" y="13.25" width="15.14" height="1.96"/><rect class="f" x="743.53" y="12.27" width="68.59" height="3.93"/><rect class="f" x="877.17" y="10.3" width="86.62" height="7.85"/><rect class="f" x="992.13" y="12.27" width="56.35" height="3.93"/><rect class="f" x="1092.6" y="10.3" width="40.9" height="7.85"/><rect class="f" x="1172.14" y="12.27" width="11.59" height="3.93"/><rect class="f" x="1202.08" y="12.27" width="40.25" height="3.93"/><rect class="f" x="1260.69" y="13.25" width="12.83" height="1.96"/><rect class="f" x="1306.74" y="10.3" width="28.98" height="7.85"/><rect class="f" x="16.58" y="1.47" width="122.21" height="1.96"/><rect class="f" x="158.11" y="23.06" width="38.8" height="1.96"/><rect class="f" x="209.79" y="1.47" width="12.56" height="1.96"/><rect class="f" x="251.49" width="66.01" height="1.96"/><rect class="f" x="341.66" width="26.57" height="1.96"/><rect class="f" x="432.14" y="23.06" width="106.91" height="1.96"/><rect class="f" x="584.14" y="23.06" width="23.51" height="1.96"/><rect class="f" x="637.27" y="23.06" width="11.11" height="1.96"/><rect class="f" x="625.69" width="79.68" height="1.96"/><rect class="f" x="732.91" width="38.64" height="1.96"/><rect class="f" x="823.23" y="23.06" width="68.19" height="1.96"/><rect class="f" x="914.76" y="23.06" width="81.03" height="1.96"/><rect class="f" x="1023.69" y="23.06" width="18.35" height="1.96"/><rect class="f" x="1056.05" width="35.32" height="1.96"/><rect class="f" x="1113.05" width="28.98" height="1.96"/><rect class="f" x="1213.09" width="93.65" height="1.96"/><rect class="f" x="1249.26" y="26.5" width="37.19" height="1.96"/></svg>]]
    return e
end
function GetElementLogo(H, I, V, W, X)
    H = H or 812;
    I = I or 380;
    V = V or "f"
    W = W or "f2"
    X = X or "f3"
    local e = ""
    e = e .. [[
        <svg x="]] .. H .. [[" y="]] .. I .. [[">
          <g>
            <g>
                <path class="]] .. X ..
            [[" d="M909.49,556l0,.63a9.39,9.39,0,0,0-.07,1.37c0,1-.07,2-.07,2H813l.14-5.73c0-1.43.12-2.86.21-3.94s.13-1.79.13-1.79Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M910.2,550.62s-.05.24-.11.61-.19.84-.23,1.34c-.11,1-.25,2-.25,2l-95.72-10.2.72-5.71c.18-1.43.47-2.84.65-3.91s.31-1.78.31-1.78Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M911.46,545.36s-.25,1-.54,1.9l-.44,1.93-94.07-20.42s.63-2.82,1.32-5.62,1.57-5.56,1.57-5.56Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M913.28,540.28s-.34.93-.71,1.84a12.07,12.07,0,0,0-.46,1.28l-.2.58L820.6,513.53s.23-.69.58-1.71.8-2.4,1.35-3.74l2.13-5.36Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M1007.3,578.3a18.4,18.4,0,0,0,.67-1.85c.16-.46.32-.93.45-1.28s.16-.59.16-.59l92.23,27.53-.5,1.74c-.35,1-.81,2.39-1.26,3.76-.9,2.75-2,5.43-2,5.43Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M1002.33,587.93s.53-.85,1.08-1.67,1-1.73,1-1.73l84.19,46.67-2.87,5-3.1,4.85Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M999.09,592.32s.62-.78,1.23-1.57a12.58,12.58,0,0,0,.81-1.1l.36-.51,78.71,55.41s-.41.59-1,1.47-1.45,2.05-2.35,3.17-1.78,2.27-2.45,3.11l-1.12,1.41Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M934.59,516.17a19.52,19.52,0,0,0-1.7,1l-1.15.73-.51.36-54.77-79.15,1.47-1,3.33-2.15c2.4-1.58,4.92-3,4.92-3Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M939.41,513.7l-.56.26a12.84,12.84,0,0,0-1.23.58c-.87.46-1.77.89-1.77.89l-46-84.56,5.13-2.64c1.28-.67,2.6-1.25,3.58-1.7l1.65-.75Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M949.68,510.38s-1,.24-1.92.45a13.32,13.32,0,0,0-1.31.35l-.6.17-26.78-92.46,1.73-.49c1.05-.29,2.43-.7,3.84-1l5.63-1.29Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M935.2,604.24l.53.32c.32.19.78.38,1.22.62s.87.46,1.2.62l.57.25-40.51,87.32-1.64-.76c-1-.46-2.26-1.13-3.54-1.78s-2.57-1.31-3.52-1.84L888,688.1Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M930.61,601.32l.51.36a11.48,11.48,0,0,0,1.13.77l1.15.74a6.12,6.12,0,0,0,.52.33L884.26,686s-.62-.36-1.53-1l-3.34-2.13c-1.22-.77-2.4-1.59-3.27-2.22l-1.47-1Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M985,515.92a18,18,0,0,0-1.74-.95l-1.21-.63-.57-.25,40.84-87.17,1.63.76,3.54,1.8c2.58,1.28,5.06,2.74,5.06,2.74Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M989.55,518.85l-.51-.36c-.31-.21-.69-.53-1.12-.77-.85-.53-1.67-1.08-1.67-1.08l50-82.28,4.85,3.1c1.22.76,2.38,1.61,3.27,2.23l1.46,1Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M997.69,526.13a3.89,3.89,0,0,0-.43-.46l-1-1a11,11,0,0,0-1-1l-.45-.43,66.29-69.8,1.3,1.24c.78.74,1.81,1.75,2.79,2.8l2.73,2.86c.74.78,1.21,1.32,1.21,1.32Z" transform="translate(-813.04 -413.09)"/>
                <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 147 147" to="360 147 147" dur="15s" repeatCount="indefinite"/>
            </g>
            <g>
                <path class="]] .. X ..
            [[" d="M985,515.92a18,18,0,0,0-1.74-.95l-1.21-.63-.57-.25,40.84-87.17,1.63.76,3.54,1.8c2.58,1.28,5.06,2.74,5.06,2.74Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M939.41,513.7l-.56.26a12.84,12.84,0,0,0-1.23.58c-.87.46-1.77.89-1.77.89l-46-84.56,5.13-2.64c1.28-.67,2.6-1.25,3.58-1.7l1.65-.75Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M910.2,550.62s-.05.24-.11.61-.19.84-.23,1.34c-.11,1-.25,2-.25,2l-95.72-10.2.72-5.71c.18-1.43.47-2.84.65-3.91s.31-1.78.31-1.78Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. X ..
            [[" d="M930.61,601.32l.51.36a11.48,11.48,0,0,0,1.13.77l1.15.74a6.12,6.12,0,0,0,.52.33L884.26,686s-.62-.36-1.53-1l-3.34-2.13c-1.22-.77-2.4-1.59-3.27-2.22l-1.47-1Z" transform="translate(-813.04 -413.09)"/>
                <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="360 147 147" to="0 147 147" dur="8s" repeatCount="indefinite"/>
            </g>
            <g>
                <path class="]] .. V ..
            [[" d="M873.15,471.64l-.37.36c-.25.22-.6.57-1,1l-3.57,3.76a128.19,128.19,0,0,0-9.79,12.31c-.85,1.16-1.64,2.35-2.39,3.54s-1.52,2.35-2.21,3.5c-1.33,2.34-2.64,4.47-3.59,6.41s-1.82,3.49-2.32,4.65l-.81,1.79-21-9.49s.36-.77,1-2.13,1.6-3.24,2.76-5.51,2.67-4.84,4.26-7.6c.81-1.36,1.72-2.74,2.62-4.15s1.83-2.83,2.82-4.2a153.32,153.32,0,0,1,11.61-14.59c1.74-1.86,3.21-3.39,4.23-4.45.51-.54.93-.95,1.22-1.23l.43-.42Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M985.66,438.77s-.7-.17-1.93-.39-3-.55-5.12-.89a126.07,126.07,0,0,0-15.67-1.33c-2.85-.12-5.71,0-8.38.06s-5.18.36-7.31.52l-5.15.65c-.63.08-1.11.15-1.44.22l-.51.08L936.48,415l.61-.1c.39-.08,1-.16,1.7-.26l6.11-.76c2.53-.21,5.49-.49,8.66-.62s6.54-.22,9.92-.08A149,149,0,0,1,982,414.73c2.52.4,4.61.79,6.07,1.06s2.3.45,2.3.45Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M1077.65,521l-.64-1.87c-.38-1.2-1-2.87-1.82-4.87a122.77,122.77,0,0,0-6.73-14.25,127.15,127.15,0,0,0-8.49-13.26c-1.25-1.75-2.4-3.12-3.16-4.11l-1.22-1.54,17.74-14.66,1.45,1.82c.91,1.18,2.27,2.81,3.75,4.88a149,149,0,0,1,10.06,15.71,144.75,144.75,0,0,1,8,16.91c1,2.37,1.71,4.36,2.16,5.78l.76,2.22Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M1083,574.9s.09-.71.24-1.95.25-3,.41-5.17.18-4.64.26-7.31c0-1.34,0-2.72-.08-4.13s-.06-2.83-.19-4.26-.22-2.85-.33-4.25-.33-2.78-.49-4.11c-.3-2.67-.8-5.14-1.17-7.25s-.84-3.86-1.1-5.08-.45-1.92-.45-1.92l22.31-5.67s.2.83.54,2.28.87,3.52,1.3,6,1,5.44,1.39,8.6c.19,1.58.42,3.21.58,4.87s.26,3.35.39,5,.18,3.38.23,5,.09,3.3.08,4.89c-.08,3.16-.08,6.12-.29,8.65s-.34,4.65-.49,6.13-.28,2.31-.28,2.31Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M1018,669.57l.46-.23c.3-.16.74-.38,1.28-.7l4.5-2.59a128.6,128.6,0,0,0,12.89-9l1.69-1.33,1.61-1.39c1.06-.92,2.12-1.82,3.11-2.72,1.93-1.86,3.8-3.53,5.26-5.11,3-3.07,4.83-5.27,4.83-5.27L1071,656.3s-2.18,2.6-5.73,6.24c-1.73,1.86-3.93,3.86-6.23,6.05-1.18,1.07-2.43,2.14-3.69,3.23l-1.91,1.64-2,1.58a152.35,152.35,0,0,1-15.29,10.69l-5.34,3.07c-.64.38-1.16.65-1.51.83l-.55.28Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M854.89,625.68l1.06,1.66c.34.53.75,1.17,1.23,1.9l1.68,2.4a126.18,126.18,0,0,0,9.88,12.24,130,130,0,0,0,11.36,10.88c1.61,1.41,3.07,2.46,4,3.25l1.55,1.21-13.81,18.42L870,676.21c-1.15-.94-2.86-2.19-4.78-3.87a150.72,150.72,0,0,1-13.45-12.89A145.71,145.71,0,0,1,840.09,645c-.74-1-1.41-2-2-2.84s-1.05-1.63-1.46-2.25c-.8-1.25-1.25-2-1.25-2Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M836.93,574.52l.25,2c.08.62.18,1.38.29,2.24s.32,1.84.5,2.9l.62,3.41c.27,1.2.56,2.47.86,3.78.56,2.63,1.43,5.37,2.21,8.13.93,2.72,1.77,5.47,2.8,8,.5,1.25,1,2.46,1.44,3.6s1,2.19,1.43,3.17c.86,2,1.69,3.56,2.26,4.67s.9,1.76.9,1.76l-20.33,10.79-1.07-2.08c-.68-1.32-1.66-3.21-2.69-5.55l-1.68-3.76c-.57-1.34-1.13-2.78-1.71-4.27-1.22-3-2.24-6.2-3.33-9.43-.93-3.27-1.95-6.53-2.62-9.65-.35-1.56-.7-3.06-1-4.49l-.74-4c-.22-1.26-.42-2.41-.59-3.43s-.25-1.92-.35-2.66c-.19-1.47-.29-2.31-.29-2.31Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M912.27,674.43l1.83.73c1.18.44,2.82,1.16,4.87,1.83s4.4,1.52,7,2.21,5.38,1.42,8.18,2a123,123,0,0,0,15.58,2.27c2.14.16,3.92.32,5.17.33l2,0-.57,23-2.33-.06c-1.47,0-3.59-.2-6.12-.39a146.55,146.55,0,0,1-18.48-2.69c-3.32-.75-6.64-1.51-9.7-2.43s-5.9-1.81-8.31-2.63-4.39-1.65-5.78-2.17l-2.17-.87Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. V ..
            [[" d="M965.68,683.83s.72,0,2-.11l5.17-.41a125.38,125.38,0,0,0,15.53-2.63c2.81-.6,5.55-1.45,8.14-2.18s4.94-1.61,7-2.38l4.84-1.91,1.8-.8,9.31,21.05-2.14.95-5.74,2.27c-2.38.9-5.22,1.84-8.25,2.82s-6.33,1.87-9.66,2.59a151.67,151.67,0,0,1-18.43,3.12c-2.53.23-4.64.38-6.12.49s-2.32.13-2.32.13Z" transform="translate(-813.04 -413.09)"/>
                <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="360 147 147" to="0 147 147" dur="100s" repeatCount="indefinite"/>
            </g>
            <g>
                <path class="]] .. W ..
            [[" d="M930,519.2a3.27,3.27,0,0,0-.5.37l-1.28,1c-1,.85-2.4,2-3.7,3.3-.66.61-1.23,1.31-1.84,1.9s-1.06,1.24-1.52,1.74-.76,1-1,1.27l-.38.49L881.5,500l.74-.95c.49-.59,1.12-1.48,2-2.46s1.84-2.17,2.95-3.37,2.3-2.48,3.57-3.69c2.5-2.45,5.13-4.75,7.17-6.39l2.49-2c.59-.48,1-.72,1-.72Z" transform="translate(-813.04 -413.09)"/>            
                <path class="]] .. W ..
            [[" d="M977.4,512.38s-.85-.25-2.11-.71c-.63-.2-1.39-.38-2.19-.63s-1.68-.37-2.54-.61-1.76-.3-2.58-.47l-2.28-.3c-.66-.12-1.24-.09-1.63-.14l-.61,0,3.18-48,1.2.09c.76.08,1.86.1,3.16.28s2.82.34,4.43.59,3.34.57,5.05.93,3.42.75,5,1.19,3.06.85,4.31,1.25l4.13,1.4Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. W ..
            [[" d="M959.68,509.35l-1.08,0-1.1,0c-.4,0-.83.07-1.25.1a22.56,22.56,0,0,0-2.34.22l-1,.13-6.67-47.67,2-.26c1.23-.18,2.88-.31,4.53-.43.83-.05,1.65-.14,2.43-.17l2.11-.05,2.07,0Z" transform="translate(-813.04 -413.09)"/>            
                <path class="]] .. W ..
            [[" d="M1009.87,551s0-.22-.1-.61a13.68,13.68,0,0,0-.34-1.58c-.16-.65-.28-1.42-.55-2.21s-.43-1.67-.76-2.5c-.14-.42-.28-.85-.41-1.26s-.33-.81-.47-1.2c-.3-.78-.58-1.51-.88-2.11l-.66-1.47-.29-.55L1048.49,516l.55,1.07c.31.7.76,1.69,1.31,2.89s1.13,2.6,1.72,4.13c.29.77.63,1.54.9,2.36s.56,1.64.84,2.47c.6,1.64,1,3.33,1.49,4.91s.77,3.07,1.08,4.34.54,2.34.65,3.1l.22,1.18Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. W ..
            [[" d="M1003.64,534.22a7.16,7.16,0,0,0-.56-.91c-.36-.52-.77-1.27-1.27-1.95s-1-1.41-1.37-1.9l-.67-.84,37.74-29.87,1.28,1.62c.77,1,1.69,2.35,2.66,3.69s1.8,2.77,2.49,3.81,1.07,1.76,1.07,1.76Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. W ..
            [[" d="M1009.26,572s.06-.23.15-.64.27-1,.36-1.69a48.31,48.31,0,0,0,.72-5.21c.06-1,.18-1.92.16-2.84s.08-1.76,0-2.49,0-1.34,0-1.76-.06-.66-.06-.66l48-3.06s0,.47.1,1.28,0,2,.08,3.39,0,3,0,4.78-.18,3.61-.32,5.48a100.31,100.31,0,0,1-1.4,10.17c-.22,1.38-.53,2.51-.7,3.31s-.29,1.25-.29,1.25Z" transform="translate(-813.04 -413.09)"/>            
                <path class="]] .. W ..
            [[" d="M977.17,607.75a55.37,55.37,0,0,0,6.51-2.89c.81-.38,1.55-.89,2.29-1.28s1.37-.89,1.94-1.23,1-.72,1.34-.93l.51-.36L1018.07,640l-1,.7c-.63.43-1.49,1.11-2.6,1.8s-2.38,1.56-3.79,2.39-2.91,1.73-4.47,2.52c-3.09,1.63-6.28,3.08-8.7,4.08l-2.95,1.16a11.58,11.58,0,0,1-1.12.41Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. W ..
            [[" d="M956.34,610.57a21.57,21.57,0,0,0,2.42.12l1.18,0,1.31,0,1.41,0,1.43-.12a52,52,0,0,0,7.56-1.17l11,46.86-1.25.29-1.44.33-1.88.34c-1.38.24-3,.57-4.72.75s-3.59.48-5.45.58l-2.78.21-2.7.07-2.52.06-2.26-.06c-2.81,0-4.67-.22-4.67-.22Z" transform="translate(-813.04 -413.09)"/>            
                <path class="]] .. W ..
            [[" d="M913.63,580.53a50,50,0,0,0,3.35,6.31c.5.74.94,1.53,1.46,2.19s.91,1.35,1.36,1.86.76,1,1,1.29.41.47.41.47l-36.81,31-.78-.92-2-2.49c-.83-1-1.69-2.28-2.65-3.61s-1.88-2.81-2.83-4.28A97.28,97.28,0,0,1,869.63,600Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. W ..
            [[" d="M943.81,608.07l1.1.39c.68.17,1.57.43,2.47.7s1.82.42,2.51.57l1.16.19-8.41,47.39-2.25-.4c-1.35-.28-3.13-.72-4.92-1.12l-4.86-1.37-2.17-.74Z" transform="translate(-813.04 -413.09)"/>
                <path class="]] .. W ..
            [[" d="M909.3,560s.06,1,.07,2.43c0,.72.11,1.57.18,2.47s.25,1.84.33,2.8l.5,2.76c.23.86.39,1.68.56,2.37.41,1.37.64,2.29.64,2.29l-46,14.31L864.35,585c-.33-1.35-.68-3-1.08-4.66s-.66-3.55-1-5.39-.5-3.7-.66-5.45-.27-3.37-.34-4.77l-.12-4.67Z" transform="translate(-813.04 -413.09)"/>
                <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 147 147" to="360 147 147" dur="45s" repeatCount="indefinite"/>
            </g>
            <g>
                <path class="]] .. W ..
            [[" d="M909.3,560s.06,1,.07,2.43c0,.72.11,1.57.18,2.47s.25,1.84.33,2.8l.5,2.76c.23.86.39,1.68.56,2.37.41,1.37.64,2.29.64,2.29l-46,14.31L864.35,585c-.33-1.35-.68-3-1.08-4.66s-.66-3.55-1-5.39-.5-3.7-.66-5.45-.27-3.37-.34-4.77l-.12-4.67Z" transform="translate(-813.04 -413.09)"/>
                <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 147 147" to="360 147 147" dur="4s" repeatCount="indefinite"/>
            </g>
            <g>
                <path class="]] .. W ..
            [[" d="M909.3,560s.06,1,.07,2.43c0,.72.11,1.57.18,2.47s.25,1.84.33,2.8l.5,2.76c.23.86.39,1.68.56,2.37.41,1.37.64,2.29.64,2.29l-46,14.31L864.35,585c-.33-1.35-.68-3-1.08-4.66s-.66-3.55-1-5.39-.5-3.7-.66-5.45-.27-3.37-.34-4.77l-.12-4.67Z" transform="translate(-813.04 -413.09)"/>
                <animateTransform attributeType="xml" attributeName="transform" type="rotate" from="360 147 147" to="0 147 147" dur="12s" repeatCount="indefinite"/>
            </g>
          </g>
        </svg>]]
    return e
end
function GetHeader(Y)
    Y = Y or "ERROR: UNDEFINED"
    local e = ""
    e = e ..
            [[<path class="f" d="M1920,582v-2.42H1820l-3.71,4.66h-49.75l-4.65-4.66H1572.63L1519,526H1462.8l-2.84-6H1154l-6,6H0v74.06H28.43l5.4,5.4H260.42l2.78-5.4H490.58l3.66-4.58H788.61l4.58,4.58h574.75l8.91-11.16h119L1507,600.08h405.19v0l7.77-.1V582.81h-3.22V582Zm-7.77,14.87-.13,0h.13Z" transform="translate(0 -520.01)"/>
            <text class="f50sxx" x="40" y="60">]] .. Y .. [[</text>]]
    return e
end
function GetContentBackground(Z, _)
    bgColor = ColorBackgroundPattern;
    local e = ""
    if Z == "dots" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='4' height='4' viewBox='0 0 4 4'%3E%3Cpath fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [[' d='M1 3h1v1H1V3zm2-2h1v1H3V1z'%3E%3C/path%3E%3C/svg%3E");]]
    elseif Z == "rain" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg width='12' height='16' viewBox='0 0 12 16' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M4 .99C4 .445 4.444 0 5 0c.552 0 1 .45 1 .99v4.02C6 5.555 5.556 6 5 6c-.552 0-1-.45-1-.99V.99zm6 8c0-.546.444-.99 1-.99.552 0 1 .45 1 .99v4.02c0 .546-.444.99-1 .99-.552 0-1-.45-1-.99V8.99z' fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [[' fill-rule='evenodd'/%3E%3C/svg%3E");]]
    elseif Z == "plus" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [['%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");]]
    elseif Z == "signal" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg width='84' height='48' viewBox='0 0 84 48' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M0 0h12v6H0V0zm28 8h12v6H28V8zm14-8h12v6H42V0zm14 0h12v6H56V0zm0 8h12v6H56V8zM42 8h12v6H42V8zm0 16h12v6H42v-6zm14-8h12v6H56v-6zm14 0h12v6H70v-6zm0-16h12v6H70V0zM28 32h12v6H28v-6zM14 16h12v6H14v-6zM0 24h12v6H0v-6zm0 8h12v6H0v-6zm14 0h12v6H14v-6zm14 8h12v6H28v-6zm-14 0h12v6H14v-6zm28 0h12v6H42v-6zm14-8h12v6H56v-6zm0-8h12v6H56v-6zm14 8h12v6H70v-6zm0 8h12v6H70v-6zM14 24h12v6H14v-6zm14-8h12v6H28v-6zM14 8h12v6H14V8zM0 8h12v6H0V8z' fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [[' fill-rule='evenodd'/%3E%3C/svg%3E");]]
    elseif Z == "deathstar" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='80' height='105' viewBox='0 0 80 105'%3E%3Cg fill-rule='evenodd'%3E%3Cg fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [['%3E%3Cpath d='M20 10a5 5 0 0 1 10 0v50a5 5 0 0 1-10 0V10zm15 35a5 5 0 0 1 10 0v50a5 5 0 0 1-10 0V45zM20 75a5 5 0 0 1 10 0v20a5 5 0 0 1-10 0V75zm30-65a5 5 0 0 1 10 0v50a5 5 0 0 1-10 0V10zm0 65a5 5 0 0 1 10 0v20a5 5 0 0 1-10 0V75zM35 10a5 5 0 0 1 10 0v20a5 5 0 0 1-10 0V10zM5 45a5 5 0 0 1 10 0v50a5 5 0 0 1-10 0V45zm0-35a5 5 0 0 1 10 0v20a5 5 0 0 1-10 0V10zm60 35a5 5 0 0 1 10 0v50a5 5 0 0 1-10 0V45zm0-35a5 5 0 0 1 10 0v20a5 5 0 0 1-10 0V10z' /%3E%3C/g%3E%3C/g%3E%3C/svg%3E");]]
    elseif Z == "diamond" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='32' viewBox='0 0 16 32'%3E%3Cg fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [['%3E%3Cpath fill-rule='evenodd' d='M0 24h4v2H0v-2zm0 4h6v2H0v-2zm0-8h2v2H0v-2zM0 0h4v2H0V0zm0 4h2v2H0V4zm16 20h-6v2h6v-2zm0 4H8v2h8v-2zm0-8h-4v2h4v-2zm0-20h-6v2h6V0zm0 4h-4v2h4V4zm-2 12h2v2h-2v-2zm0-8h2v2h-2V8zM2 8h10v2H2V8zm0 8h10v2H2v-2zm-2-4h14v2H0v-2zm4-8h6v2H4V4zm0 16h6v2H4v-2zM6 0h2v2H6V0zm0 24h2v2H6v-2z'/%3E%3C/g%3E%3C/svg%3E");]]
    elseif Z == "hexagon" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='28' height='49' viewBox='0 0 28 49'%3E%3Cg fill-rule='evenodd'%3E%3Cg id='hexagons' fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [[' fill-rule='nonzero'%3E%3Cpath d='M13.99 9.25l13 7.5v15l-13 7.5L1 31.75v-15l12.99-7.5zM3 17.9v12.7l10.99 6.34 11-6.35V17.9l-11-6.34L3 17.9zM0 15l12.98-7.5V0h-2v6.35L0 12.69v2.3zm0 18.5L12.98 41v8h-2v-6.85L0 35.81v-2.3zM15 0v7.5L27.99 15H28v-2.31h-.01L17 6.35V0h-2zm0 49v-8l12.99-7.5H28v2.31h-.01L17 42.15V49h-2z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");]]
    elseif Z == "capsule" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg width='32' height='26' viewBox='0 0 32 26' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M14 0v3.994C14 7.864 10.858 11 7 11c-3.866 0-7-3.138-7-7.006V0h2v4.005C2 6.765 4.24 9 7 9c2.756 0 5-2.236 5-4.995V0h2zm0 26v-5.994C14 16.138 10.866 13 7 13c-3.858 0-7 3.137-7 7.006V26h2v-6.005C2 17.235 4.244 15 7 15c2.76 0 5 2.236 5 4.995V26h2zm2-18.994C16 3.136 19.142 0 23 0c3.866 0 7 3.138 7 7.006v9.988C30 20.864 26.858 24 23 24c-3.866 0-7-3.138-7-7.006V7.006zm2-.01C18 4.235 20.244 2 23 2c2.76 0 5 2.236 5 4.995v10.01C28 19.765 25.756 22 23 22c-2.76 0-5-2.236-5-4.995V6.995z' fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [[' fill-rule='evenodd'/%3E%3C/svg%3E");]]
    elseif Z == "diagonal" then
        e =
            [[background-image: url("data:image/svg+xml,%3Csvg width='6' height='6' viewBox='0 0 6 6' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='%23]] ..
                bgColor .. [[' fill-opacity=']] .. BackgroundModeOpacity ..
                [[' fill-rule='evenodd'%3E%3Cpath d='M5 0h1L0 6V5zM6 5v1H5z'/%3E%3C/g%3E%3C/svg%3E");]]
    end
    return e
end
function GetContentDamageHUDOutput()
    local a0 = 300;
    local a1 = 165;
    if #damagedElements > 0 or #brokenElements > 0 then a1 = 510 end
    local e = ""
    e =
        e .. [[<svg style="position:absolute;top:]] .. HUDShiftV .. [[; left:]] ..
            HUDShiftU .. [[;" viewBox="0 0 ]] .. a0 .. [[ ]] .. a1 ..
            [[" width="]] .. a0 .. [[" height="]] .. a1 .. [[">
            <style>
                .f22mxxxb { font-size: 22px; font-weight: bold; text-anchor: middle; fill: #]] ..
            ColorTertiary .. [[; }
                .f20mxxb { font-size: 20px; font-weight:bold; text-anchor: middle; fill: #]] ..
            ColorSecondary .. [[; }
                .f18sxx { font-size: 18px; text-anchor: start; fill: #]] ..
            ColorSecondary .. [[; }
                .f18exx { font-size: 18px; text-anchor: end; fill: #]] ..
            ColorSecondary .. [[; }
                .f18mh { font-size: 18px; text-anchor: middle; fill: #]] ..
            ColorHealthy .. [[; }
                .f18exxb { font-size: 18px; font-weight: bold; text-anchor: end; fill: #]] ..
            ColorSecondary .. [[; }
                .f15swb { font-size: 15px; font-weight: bold; text-anchor: start; fill:#]] ..
            ColorWarning .. [[; }
                .f15scb { font-size: 15px; font-weight: bold; text-anchor: start; fill:#]] ..
            ColorCritical .. [[; }
                .f15ewb { font-size: 15px; font-weight: bold; text-anchor: end; fill:#]] ..
            ColorWarning .. [[; }
                .f15ecb { font-size: 15px; font-weight: bold; text-anchor: end; fill:#]] ..
            ColorCritical .. [[; }
                .f15sxxxb { font-size: 15px; font-weight: bold; text-anchor: start; fill:#]] ..
            ColorTertiary .. [[; }
                .f15exxxb { font-size: 15px; font-weight: bold; text-anchor: end; fill:#]] ..
            ColorTertiary .. [[; }
                .f12mxx { font-size: 12px; fill: #]] .. ColorSecondary ..
            [[; text-anchor: middle}
                .xfill { fill:#]] .. ColorPrimary .. [[;}
                .xline { stroke: #]] .. ColorPrimary .. [[; stroke-width: 1;}
            </style>
        ]]
    e = e .. [[<rect stroke=#]] .. ColorPrimary ..
            [[ stroke-width=2 x=0 y=0 rx=10 ry=10 width="]] .. a0 ..
            [[" height="]] .. a1 .. [[" fill=#]] .. ColorBackground ..
            [[ fill-opacity=0.6 />]] ..
            [[<rect class=xfill x=0 x=0 y=0 rx=10 ry=10 width=300 height=30 />]] ..
            [[<rect class=xfill x=0 x=0 y=5 rx=0 ry=0 width=300 height=30 />]] ..
            [[<text x=150 y=24 class="f20mxxb">]] ..
            (YourShipsName == "Enter here" and "Ship ID " .. ShipID or
                YourShipsName) .. [[</text>]] ..
            [[<circle cx=17 cy=17 r=10 stroke=#]] .. ColorBackground ..
            [[ stroke-width=2 fill=none />]]
    if #brokenElements > 0 then
        e = e ..
                [[<svg x="2px" y="2px" width="30px" height="30px" viewBox="0 0 50 50"><path fill="#]] ..
                ColorCritical ..
                [[" d="M43.935,25.145c0-10.318-8.364-18.683-18.683-18.683c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615c8.072,0,14.615,6.543,14.615,14.615H43.935z"><animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 25 25" to="360 25 25" dur="1s" repeatCount="indefinite"/></path></svg>]]
    elseif #damagedElements > 0 then
        e = e ..
                [[<svg x="2px" y="2px" width="30px" height="30px" viewBox="0 0 50 50"><path fill="#]] ..
                ColorWarning ..
                [[" d="M43.935,25.145c0-10.318-8.364-18.683-18.683-18.683c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615c8.072,0,14.615,6.543,14.615,14.615H43.935z"><animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 25 25" to="360 25 25" dur="1s" repeatCount="indefinite"/></path></svg>]]
    else
        e = e ..
                [[<svg x="2px" y="2px" width="30px" height="30px" viewBox="0 0 50 50"><path fill="#]] ..
                ColorHealthy ..
                [[" d="M43.935,25.145c0-10.318-8.364-18.683-18.683-18.683c-10.318,0-18.683,8.365-18.683,18.683h4.068c0-8.071,6.543-14.615,14.615-14.615c8.072,0,14.615,6.543,14.615,14.615H43.935z"><animateTransform attributeType="xml" attributeName="transform" type="rotate" from="0 25 25" to="360 25 25" dur="1s" repeatCount="indefinite"/></path></svg>]]
    end
    if #damagedElements > 0 or #brokenElements > 0 then
        e = e .. [[<text x=10 y=55 class="f18sxx">Total Damage</text>]] ..
                [[<text x=290 y=55 class="f18exxb">]] ..
                GenerateCommaValue(string.format("%.0f",
                                                 totalShipMaxHP - totalShipHP)) ..
                [[</text>]]
        e = e .. [[<text x=10 y=75 class="f18sxx">T]] .. ScrapTier ..
                [[ Scrap Needed</text>]] ..
                [[<text x=290 y=75 class="f18exxb">]] ..
                getScraps(totalShipMaxHP - totalShipHP, true) .. [[</text>]]
        e = e .. [[<text x=10 y=95 class="f18sxx">Repair Time</text>]] ..
                [[<text x=290 y=95 class="f18exxb">]] ..
                getRepairTime(totalShipMaxHP - totalShipHP, true) .. [[</text>]]
        e = e ..
                [[<rect class=xfill x=0 y=105 rx=0 ry=0 width=300 height=40 />]] ..
                [[<rect fill=#]] .. ColorHealthy .. [[ stroke=#]] ..
                ColorTertiary ..
                [[ stroke-width=1 x=10 y=110 rx=5 ry=5 width=90 height=30 />]] ..
                [[<text x=55 y=132 class="f22mxxxb">]] .. #healthyElements ..
                [[</text>]] .. [[<rect fill=#]] .. ColorWarning .. [[ stroke=#]] ..
                ColorTertiary ..
                [[ stroke-width=1 x=105 y=110 rx=5 ry=5 width=90 height=30 />]] ..
                [[<text x=150 y=132 class="f22mxxxb">]] .. #damagedElements ..
                [[</text>]] .. [[<rect fill=#]] .. ColorCritical ..
                [[ stroke=#]] .. ColorTertiary ..
                [[ stroke-width=1 x=200 y=110 rx=5 ry=5 width=90 height=30 />]] ..
                [[<text x=245 y=132 class="f22mxxxb">]] .. #brokenElements ..
                [[</text>]]
        local u = 0;
        for a2 = hudStartIndex, hudStartIndex + 9, 1 do
            if rE[a2] ~= nil then
                v = rE[a2]
                if v.hp > 0 then
                    e = e .. [[<rect fill=#]] .. ColorWarning ..
                            [[ fill-opacity=0.2 x=1 y=]] .. 147 + u * 26 ..
                            [[ width=298 height=25 />]] .. [[<text x=10 y=]] ..
                            165 + u * 26 .. [[ class="f15swb">]] ..
                            string.format("%.30s", v.name) .. [[</text>]] ..
                            [[<text x=290 y=]] .. 165 + u * 26 ..
                            [[ class="f15ewb">]] ..
                            GenerateCommaValue(
                                string.format("%.0f", v.missinghp)) ..
                            [[</text>]]
                    if v.id == highlightID then
                        e = e .. [[<rect fill=#]] .. ColorWarning ..
                                [[ fill-opacity=1 x=1 y=]] .. 147 + u * 26 ..
                                [[ width=298 height=25 />]] .. [[<text x=10 y=]] ..
                                165 + u * 26 .. [[ class="f15sxxxb">]] ..
                                string.format("%.30s", v.name) .. [[</text>]] ..
                                [[<text x=290 y=]] .. 165 + u * 26 ..
                                [[ class="f15exxxb">]] ..
                                GenerateCommaValue(
                                    string.format("%.0f", v.missinghp)) ..
                                [[</text>]]
                    end
                else
                    e = e .. [[<rect fill=#]] .. ColorCritical .. [[ x=1 y=]] ..
                            147 + u * 26 ..
                            [[ fill-opacity=0.2 width=298 height=25 />]] ..
                            [[<text x=10 y=]] .. 165 + u * 26 ..
                            [[ class="f15scb">]] ..
                            string.format("%.30s", v.name) .. [[</text>]] ..
                            [[<text x=290 y=]] .. 165 + u * 26 ..
                            [[ class="f15ecb">]] ..
                            GenerateCommaValue(
                                string.format("%.0f", v.missinghp)) ..
                            [[</text>]]
                    if v.id == highlightID then
                        highlightX = elementPosition.x - coreWorldOffset;
                        highlightY = elementPosition.y - coreWorldOffset;
                        highlightZ = elementPosition.z - coreWorldOffset;
                        e = e .. [[<rect fill=#]] .. ColorCritical ..
                                [[ x=1 y=]] .. 147 + u * 26 ..
                                [[ fill-opacity=1 width=298 height=25 />]] ..
                                [[<text x=10 y=]] .. 165 + u * 26 ..
                                [[ class="f15sxxxb">]] ..
                                string.format("%.30s", v.name) .. [[</text>]] ..
                                [[<text x=290 y=]] .. 165 + u * 26 ..
                                [[ class="f15exxxb">]] ..
                                GenerateCommaValue(
                                    string.format("%.0f", v.missinghp)) ..
                                [[</text>]]
                    end
                end
                u = u + 1
            end
        end
        if DisallowKeyPresses == true then
            e = e .. [[<svg x="0" y="408">]] ..
                    [[<rect class=xfill x=0 y=0 rx=0 ry=0 width=300 height=40 />]] ..
                    [[<rect class=xfill x=0 y=22 rx=10 ry=10 width=300 height=80 />]] ..
                    [[<svg x=0 y=3>]] ..
                    [[<text x="150" y="15" class="f12mxx"></text>]] ..
                    [[<text x="150" y="30" class="f12mxx"></text>]] ..
                    [[<text x="150" y="45" class="f12mxx">Keypresses disabled.</text>]] ..
                    [[<text x="150" y="60" class="f12mxx">Change in LUA parameters</text>]] ..
                    [[<text x="150" y="75" class="f12mxx">by unchecking DisallowKeyPresses.</text>]] ..
                    [[<text x="150" y="90" class="f12mxx"></text>]] .. [[<svg>]] ..
                    [[</svg>]]
        else
            e = e .. [[<svg x="0" y="408">]] ..
                    [[<rect class=xfill x=0 y=0 rx=0 ry=0 width=300 height=40 />]] ..
                    [[<rect class=xfill x=0 y=22 rx=10 ry=10 width=300 height=80 />]] ..
                    [[<svg x=0 y=3>]] ..
                    [[<text x="150" y="15" class="f12mxx">Up/down arrows to highlight</text>]] ..
                    [[<text x="150" y="30" class="f12mxx">CTRL + arrows to move HUD</text>]] ..
                    [[<text x="150" y="45" class="f12mxx">Left arrow to toggle HUD Mode</text>]] ..
                    [[<text x="150" y="60" class="f12mxx">ALT+1-4 to set Scrap Tier</text>]] ..
                    [[<text x="150" y="75" class="f12mxx">ALT+8 to reset HUD position</text>]] ..
                    [[<text x="150" y="90" class="f12mxx">ALT+9 to shut script off</text>]] ..
                    [[<svg>]] .. [[</svg>]]
        end
    else
        if DisallowKeyPresses == true then
            e = e .. [[<text x="150" y="60" class="f18mh" fill="#]] ..
                    ColorHealthy .. [[">]] .. OkayCenterMessage .. [[</text>]] ..
                    [[<text x="150" y="88" class="f18mh" fill="#]] ..
                    ColorHealthy .. [[">]] .. #healthyElements ..
                    [[ elements / ]] ..
                    GenerateCommaValue(string.format("%.0f", totalShipMaxHP)) ..
                    [[ HP.</text>]] .. [[<svg x="0" y="100">]] ..
                    [[<rect class=xfill x=0 y=0 rx=0 ry=0 width=300 height=40 />]] ..
                    [[<rect class=xfill x=0 y=35 rx=10 ry=10 width=300 height=30 />]] ..
                    [[<svg x=0 y=3>]] ..
                    [[<text x="150" y="10" class="f12mxx">Keypresses disabled.</text>]] ..
                    [[<text x="150" y="25" class="f12mxx">Change in LUA parameters</text>]] ..
                    [[<text x="150" y="40" class="f12mxx">by unchecking DisallowKeyPresses.</text>]] ..
                    [[<text x="150" y="55" class="f12mxx"></text>]] .. [[<svg>]] ..
                    [[</svg>]]
        else
            e = e .. [[<text x="150" y="60" class="f18mh" fill="#]] ..
                    ColorHealthy .. [[">]] .. OkayCenterMessage .. [[</text>]] ..
                    [[<text x="150" y="88" class="f18mh" fill="#]] ..
                    ColorHealthy .. [[">]] .. #healthyElements ..
                    [[ elements / ]] ..
                    GenerateCommaValue(string.format("%.0f", totalShipMaxHP)) ..
                    [[ HP.</text>]] .. [[<svg x="0" y="100">]] ..
                    [[<rect class=xfill x=0 y=0 rx=0 ry=0 width=300 height=40 />]] ..
                    [[<rect class=xfill x=0 y=35 rx=10 ry=10 width=300 height=30 />]] ..
                    [[<svg x=0 y=3>]] ..
                    [[<text x="150" y="10" class="f12mxx">Left arrow to toggle HUD Mode</text>]] ..
                    [[<text x="150" y="25" class="f12mxx">CTRL + arrows to move HUD</text>]] ..
                    [[<text x="150" y="40" class="f12mxx">ALT+8 to reset HUD position</text>]] ..
                    [[<text x="150" y="55" class="f12mxx">ALT+9 to shut script off</text>]] ..
                    [[<svg>]] .. [[</svg>]]
        end
    end
    e = e .. [[</svg>]]
    return e
end
function GetContentDamageScreen()
    local a3 = ""
    if #damagedElements > 0 then
        local a4 = #damagedElements;
        if a4 > DamagePageSize then a4 = DamagePageSize end
        if CurrentDamagedPage == math.ceil(#damagedElements / DamagePageSize) then
            a4 = #damagedElements % DamagePageSize + 12;
            if a4 > 12 then a4 = a4 - 12 end
        end
        a3 =
            a3 .. [[<rect x="20" y="300" rx="5" ry="5" width="930" height="]] ..
                70 + (a4 + 1) * 50 ..
                [[" fill="#000000" fill-opacity="0.5" style="stroke:#]] ..
                ColorWarning .. [[;stroke-width:3;" />]]
        a3 = a3 ..
                 [[<rect x="30" y="310" rx="5" ry="5" width="910" height="40" fill="#]] ..
                 ColorWarning .. [[" fill-opacity="0.5" />]]
        if UseMyElementNames == true then
            a3 = a3 ..
                     [[<text x="110" y="341" class="f30sxx">Damaged Name</text>]]
        else
            a3 = a3 ..
                     [[<text x="110" y="341" class="f30sxx">Damaged Type</text>]]
        end
        a3 = a3 ..
                 [[<text x="417" y="341" class="f30sxx">HLTH</text><text x="545" y="341" class="f30sxx">DMG</text>]]
        a3 = a3 .. [[<text x="655" y="341" class="f30sxx">T]] .. ScrapTier ..
                 [[ SCR</text><text x="790" y="341" class="f30sxx">REPTIME</text>]]
        AddClickArea("damage", {
            id = "SwitchScrapTier",
            mode = "damage",
            x1 = 650,
            x2 = 775,
            y1 = 315,
            y2 = 360
        })
        local g = 0;
        for u = 1 + (CurrentDamagedPage - 1) * DamagePageSize, a4 +
            (CurrentDamagedPage - 1) * DamagePageSize, 1 do
            g = g + 1;
            local a5 = damagedElements[u]
            if UseMyElementNames == true then
                a3 = a3 .. [[<text x="40" y="]] .. 330 + g * 50 ..
                         [[" class="f25sxx">]] ..
                         string.format("%.23s", a5.name) .. [[</text>]]
            else
                a3 = a3 .. [[<text x="40" y="]] .. 330 + g * 50 ..
                         [[" class="f25sxx">]] ..
                         string.format("%.23s", a5.type) .. [[</text>]]
            end
            a3 = a3 .. [[<text x="485" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] .. a5.percent .. [[%</text>]] ..
                     [[<text x="614" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] ..
                     GenerateCommaValue(string.format("%.0f", a5.missinghp),
                                        true) .. [[</text>]] ..
                     [[<text x="734" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] .. getScraps(a5.missinghp, true) ..
                     [[</text>]] .. [[<text x="908" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] .. getRepairTime(a5.missinghp, true) ..
                     [[</text>]] .. [[<line x1="30" x2="940" y1="]] .. 336 + g *
                     50 .. [[" y2="]] .. 336 + g * 50 .. [[" style="stroke:#]] ..
                     ColorSecondary .. [[;stroke-opacity:0.2" />]]
        end
        if #damagedElements > DamagePageSize then
            a3 = a3 .. [[<text x="485" y="]] .. 30 + 300 + 11 + (a4 + 1) * 50 ..
                     [[" class="f25mw">Page ]] .. CurrentDamagedPage .. " of " ..
                     math.ceil(#damagedElements / DamagePageSize) .. [[</text>]]
            if CurrentDamagedPage < math.ceil(#damagedElements / DamagePageSize) then
                a3 = a3 .. [[<svg x="30" y="]] .. 300 + 11 + (a4 + 1) * 50 ..
                         [[">
                            <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]] ..
                         ColorWarning .. [[;" />
                            <svg x="80" y="15"><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>
                        </svg>]]
                AddClickArea("damage", {
                    id = "DamagedPageDown",
                    mode = "damage",
                    x1 = 65,
                    x2 = 260,
                    y1 = 290 + (a4 + 1) * 50,
                    y2 = 290 + 50 + (a4 + 1) * 50
                })
            else
                DisableClickArea("DamagedPageDown", "damage")
            end
            if CurrentDamagedPage > 1 then
                a3 = a3 .. [[<svg x="740" y="]] .. 300 + 11 + (a4 + 1) * 50 ..
                         [[">
                            <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]] ..
                         ColorWarning .. [[;" />
                            <svg x="80" y="15"><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>
                        </svg>]]
                AddClickArea("damage", {
                    id = "DamagedPageUp",
                    mode = "damage",
                    x1 = 750,
                    x2 = 950,
                    y1 = 290 + (a4 + 1) * 50,
                    y2 = 290 + 50 + (a4 + 1) * 50
                })
            else
                DisableClickArea("DamagedPageUp", "damage")
            end
        end
    end
    if #brokenElements > 0 then
        local a6 = #brokenElements;
        if a6 > DamagePageSize then a6 = DamagePageSize end
        if CurrentBrokenPage == math.ceil(#brokenElements / DamagePageSize) then
            a6 = #brokenElements % DamagePageSize + 12;
            if a6 > 12 then a6 = a6 - 12 end
        end
        a3 =
            a3 .. [[<rect x="970" y="300" rx="5" ry="5" width="930" height="]] ..
                70 + (a6 + 1) * 50 ..
                [[" fill="#000000" fill-opacity="0.5" style="stroke:#]] ..
                ColorCritical .. [[;stroke-width:3;" />]]
        a3 = a3 ..
                 [[<rect x="980" y="310" rx="5" ry="5" width="910" height="40" fill="#]] ..
                 ColorCritical .. [[" fill-opacity="0.5" />]]
        if UseMyElementNames == true then
            a3 = a3 ..
                     [[<text x="1070" y="341" class="f30sxx">Broken Name</text>]]
        else
            a3 = a3 ..
                     [[<text x="1070" y="341" class="f30sxx">Broken Type</text>]]
        end
        a3 = a3 .. [[<text x="1495" y="341" class="f30sxx">DMG</text>]]
        a3 = a3 .. [[<text x="1605" y="341" class="f30sxx">T]] .. ScrapTier ..
                 [[ SCR</text><text x="1740" y="341" class="f30sxx">REPTIME</text>]]
        AddClickArea("damage", {
            id = "SwitchScrapTier2",
            mode = "damage",
            x1 = 1570,
            x2 = 1690,
            y1 = 315,
            y2 = 360
        })
        local g = 0;
        for u = 1 + (CurrentBrokenPage - 1) * DamagePageSize, a6 +
            (CurrentBrokenPage - 1) * DamagePageSize, 1 do
            g = g + 1;
            local a5 = brokenElements[u]
            if UseMyElementNames == true then
                a3 = a3 .. [[<text x="1000" y="]] .. 330 + g * 50 ..
                         [[" class="f25sxx">]] ..
                         string.format("%.30s", a5.name) .. [[</text>]]
            else
                a3 = a3 .. [[<text x="1000" y="]] .. 330 + g * 50 ..
                         [[" class="f25sxx">]] ..
                         string.format("%.30s", a5.type) .. [[</text>]]
            end
            a3 = a3 .. [[<text x="1564" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] ..
                     GenerateCommaValue(string.format("%.0f", a5.missinghp),
                                        true) .. [[</text>]] ..
                     [[<text x="1684" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] .. getScraps(a5.missinghp, true) ..
                     [[</text>]] .. [[<text x="1858" y="]] .. 330 + g * 50 ..
                     [[" class="f25exx">]] .. getRepairTime(a5.missinghp, true) ..
                     [[</text>]] .. [[<line x1="980" x2="1890" y1="]] .. 336 + g *
                     50 .. [[" y2="]] .. 336 + g * 50 .. [[" style="stroke:#]] ..
                     ColorSecondary .. [[;stroke-opacity:0.2" />]]
        end
        if #brokenElements > DamagePageSize then
            a3 =
                a3 .. [[<text x="1435" y="]] .. 30 + 300 + 11 + (a6 + 1) * 50 ..
                    [[" class="f25mr">Page ]] .. CurrentBrokenPage .. " of " ..
                    math.ceil(#brokenElements / DamagePageSize) .. [[</text>]]
            if CurrentBrokenPage > 1 then
                a3 = a3 .. [[<svg x="1690" y="]] .. 300 + 11 + (a6 + 1) * 50 ..
                         [[">
                            <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]] ..
                         ColorCritical .. [[;" />
                            <svg x="80" y="15"><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>
                        </svg>]]
                AddClickArea("damage", {
                    id = "BrokenPageUp",
                    mode = "damage",
                    x1 = 1665,
                    x2 = 1865,
                    y1 = 290 + (a6 + 1) * 50,
                    y2 = 290 + 50 + (a6 + 1) * 50
                })
            else
                DisableClickArea("BrokenPageUp", "damage")
            end
            if CurrentBrokenPage < math.ceil(#brokenElements / DamagePageSize) then
                a3 = a3 .. [[<svg x="980" y="]] .. 300 + 11 + (a6 + 1) * 50 ..
                         [[">
                            <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#]] ..
                         ColorCritical .. [[;" />
                            <svg x="80" y="15"><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>
                        </svg>]]
                AddClickArea("damage", {
                    id = "BrokenPageDown",
                    mode = "damage",
                    x1 = 980,
                    x2 = 1180,
                    y1 = 290 + (a6 + 1) * 50,
                    y2 = 290 + 50 + (a6 + 1) * 50
                })
            else
                DisableClickArea("BrokenPageDown", "damage")
            end
        end
    end
    if #damagedElements > 0 or #brokenElements > 0 then
        local a7 = math.floor(1878 / #elementsIdList * #damagedElements)
        local a8 = math.floor(1878 / #elementsIdList * #brokenElements)
        local a9 = 1878 - a7 - a8 + 1;
        a3 = a3 ..
                 [[<rect x="20" y="180" rx="0" ry="0" width="1880" height="100" fill="#000000" fill-opacity="1.0" style="stroke:#FF6700;stroke-width:0;" />]]
        a3 = a3 .. [[<svg><rect style="stroke: #]] .. ColorWarning ..
                 [[;stroke-width:5px;" x="21" y="180" rx="0" ry="0" width="]] ..
                 a7 .. [[" height="100" fill="#]] .. ColorWarning ..
                 [[" fill-opacity="0.2" /></svg>]]
        a3 = a3 .. [[<rect x="]] .. 21 + a7 ..
                 [[" y="180" rx="0" ry="0" width="]] .. a9 ..
                 [[" height="100" fill="#]] .. ColorHealthy ..
                 [[" fill-opacity="0.2" />]]
        a3 = a3 .. [[<rect style="stroke: #]] .. ColorCritical ..
                 [[;stroke-width:5px;" x="]] .. 21 + a7 + a9 - 1 ..
                 [[" y="180" rx="0" ry="0" width="]] .. a8 ..
                 [[" height="100" fill="#]] .. ColorCritical ..
                 [[" fill-opacity="0.2" />]]
        if #damagedElements > 0 then
            a3 = a3 .. [[<text x="]] .. 21 + a7 / 2 ..
                     [[" y="246" class="f60m" fill="#]] .. ColorWarning ..
                     [[">]] .. #damagedElements .. [[</text>]]
        end
        if #healthyElements > 0 then
            a3 = a3 .. [[<text x="]] .. 21 + a7 + a9 / 2 ..
                     [[" y="246" class="f60m" fill="#]] .. ColorHealthy ..
                     [[">]] .. #healthyElements .. [[</text>]]
        end
        if #brokenElements > 0 then
            a3 = a3 .. [[<text x="]] .. 21 + a7 + a9 - 1 + a8 / 2 ..
                     [[" y="246" class="f60m" fill="#]] .. ColorCritical ..
                     [[">]] .. #brokenElements .. [[</text>]]
        end
        a3 = a3 ..
                 [[<rect x="20" y="180" rx="0" ry="0" width="1880" height="100" fill="#000000" fill-opacity="0" style="stroke:#FF6700;stroke-width:0;" />]]
        a3 = a3 .. [[<text x="960" y="140" class="f36mxx">]] ..
                 GenerateCommaValue(string.format("%.0f",
                                                  totalShipMaxHP - totalShipHP)) ..
                 [[ HP damage in total ]] ..
                 getScraps(totalShipMaxHP - totalShipHP, true) .. [[ T]] ..
                 ScrapTier .. [[ scraps needed. ]] ..
                 getRepairTime(totalShipMaxHP - totalShipHP, true) ..
                 [[ projected repair time.</text>]]
    else
        a3 = a3 .. GetElementLogo(812, 380, "ch", "ch", "ch") ..
                 [[<text x="960" y="320" class="f50m" fill="#]] .. ColorHealthy ..
                 [[">]] .. OkayCenterMessage .. [[</text>]] ..
                 [[<text x="960" y="760" class="f50m" fill="#]] .. ColorHealthy ..
                 [[">]] .. #healthyElements .. [[ elements stand ]] ..
                 GenerateCommaValue(string.format("%.0f", totalShipMaxHP)) ..
                 [[ HP strong.</text>]]
    end
    forceDamageRedraw = false;
    return a3
end
function ActionStopengines()
    if DisallowKeyPresses == true then return end
    ToggleHUD()
end
function ActionStrafeRight()
    if DisallowKeyPresses == true then return end
    if KeyCTRLPressed == true then
        if HUDShiftU < 4000 then
            HUDShiftU = HUDShiftU + 50;
            SaveToDatabank()
            RenderScreens()
        end
    else
        HudDeselectElement()
    end
end
function ActionStrafeLeft()
    if DisallowKeyPresses == true then return end
    if KeyCTRLPressed == true then
        if HUDShiftU >= 50 then
            HUDShiftU = HUDShiftU - 50;
            SaveToDatabank()
            RenderScreens()
        end
    else
        ToggleHUD()
    end
end
function ActionDown()
    if DisallowKeyPresses == true then return end
    if KeyCTRLPressed == true then
        if HUDShiftV < 4000 then
            HUDShiftV = HUDShiftV + 50;
            SaveToDatabank()
            RenderScreens()
        end
    else
        ChangeHudSelectedElement(1)
    end
end
function ActionUp()
    if DisallowKeyPresses == true then return end
    if KeyCTRLPressed == true then
        if HUDShiftV >= 50 then
            HUDShiftV = HUDShiftV - 50;
            SaveToDatabank()
            RenderScreens()
        end
    else
        ChangeHudSelectedElement(-1)
    end
end
function ActionOption1()
    if DisallowKeyPresses == true then return end
    ScrapTier = 1;
    SetRefresh("damage")
    RenderScreens("damage")
end
function ActionOption2()
    if DisallowKeyPresses == true then return end
    ScrapTier = 2;
    SetRefresh("damage")
    RenderScreens("damage")
end
function ActionOption3()
    if DisallowKeyPresses == true then return end
    ScrapTier = 3;
    SetRefresh("damage")
    RenderScreens("damage")
end
function ActionOption4()
    if DisallowKeyPresses == true then return end
    ScrapTier = 4;
    SetRefresh("damage")
    RenderScreens("damage")
end
function ActionOption8()
    if DisallowKeyPresses == true then return end
    HUDShiftU = 0;
    HUDShiftV = 0;
    SetRefresh("damage")
    RenderScreens("damage")
end
function ActionOption9()
    if DisallowKeyPresses == true then return end
    SaveToDatabank()
    SwitchScreens("off")
    unit.exit()
end
