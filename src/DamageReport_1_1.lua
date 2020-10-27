--[[
    DamageReport v1.1

    Created By Dorian Gray

    Discord: Dorian Gray#2623
    InGame: DorianGray
    GitHub: https://github.com/DorianTheGrey/DU-DamageReport

    GNU Public License 3.0. Use whatever you want, be so kind to leave credit.

    Thanks to Jericho, Dmentia and Archaegeo for learning from their fine scripts.
]]

-----------------------------------------------
-- CONFIG
-----------------------------------------------

UpdateInterval = 1 --export: Interval in seconds between updates of the calculations and (if anything changed) redrawing to the screen(s). You need to restart the script after changing this value.
SimulationMode = false --export Randomize simluated damage on elements to check out the functionality of this script. And, no, your elements won't be harmed in the process :) You need to restart the script after changing this value.

DebugMode = false -- Activate if you want some console messages
VersionNumber = 1.1 -- Version number

core = nil 
screens = {}

shipID = 0
forceRedraw = false
SimulationActive=false

clickAreas = {}
DamagedSortingMode = 1 -- Define default sorting mode for damaged elements. 1 to sort by damage amount, 2 to sort by element id, 3 to sort by damage percent, 
BrokenSortingMode = 1 -- Define default sorting mode for broken elements. 1 to sort by damage amount, 2 to sort by element id

CurrentDamagedPage = 1
CurrentBrokenPage = 1

totalShipHP = 0
totalShipMaxHP = 0
totalShipIntegrity = 100
elementsId = {}
damagedElements = {}
brokenElements = {}
ElementCounter = 0
healthyElements = 0

-----------------------------------------------
-- FUNCTIONS
-----------------------------------------------


function GenerateCommaValue(amount)
    local formatted = amount
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then break end
    end
    return formatted
end

function PrintDebug(output, highlight) 
    highlight = highlight or false
    if DebugMode then
        if highlight then system.print("------------------------------------------------------------------------") end
        system.print(output)
        if highlight then system.print("------------------------------------------------------------------------") end
    end
end

function PrintError(output) 
    system.print(output)
end

function DrawCenteredText(output)
    for i=1,#screens,1 do
         screens[i].setCenteredText(output)
    end
end

function DrawSVG(output)
    for i=1,#screens,1 do
         screens[i].setSVG(output)
    end
end

function ClearConsole()
    for i=1,10,1 do
        PrintDebug()
    end
end

function SwitchScreens(state)
    state = state or true
    if #screens > 0 then
        for i=1,#screens,1 do
            if state then
                screens[i].clear()
                screens[i].activate()
            else
                screens[i].deactivate()
                screens[i].clear()
            end
        end
    end
end

function InitiateSlots()
    for slot_name, slot in pairs(unit) do
        if
            type(slot) == "table"
            and type(slot.export) == "table"
            and slot.getElementClass
        then
            if slot.getElementClass():lower():find("coreunit") then
                core = slot
            end
            if slot.getElementClass():lower():find("screenunit") then
                screens[#screens + 1] = slot
            end
        end
    end
end

function AddClickArea(newEntry)
    table.insert(clickAreas, newEntry)
end

function RemoveFromClickAreas(candidate)
    for k, v in pairs(clickAreas) do
        if v.id==candidate then
                clickAreas[k]=nil
            break
        end
    end
end

function UpdateClickArea(candidate, newEntry)
    for k, v in pairs(clickAreas) do
        if v.id==candidate then
                clickAreas[k]=newEntry
            break
        end
    end
end

function DisableClickArea(candidate)
    for k, v in pairs(clickAreas) do
        if v.id==candidate then
                UpdateClickArea(candidate, { id = candidate, x1 = -1, x2 = -1, y1 = -1, y2 = -1 } )
            break
        end
    end
end

function InitiateClickAreas()
    clickAreas = {}
    AddClickArea( { id = "DamagedDamage", x1 = 725, x2 = 870, y1 = 380, y2 = 415 } )
    AddClickArea( { id = "DamagedHealth", x1 = 520, x2 = 655, y1 = 380, y2 = 415 } )
    AddClickArea( { id = "DamagedID", x1 = 90, x2 = 150, y1 = 380, y2 = 415 } )
    AddClickArea( { id = "BrokenDamage", x1 = 1675, x2 = 1835, y1 = 380, y2 = 415 } )
    AddClickArea( { id = "BrokenID", x1 = 1050, x2 = 1110, y1 = 380, y2 = 415 } )
    AddClickArea( { id = "ToggleSimulation", x1 = 65, x2 = 660, y1 = 100, y2 = 145 } )
    AddClickArea( { id = "DamagedPageDown", x1 = -1, x2 = -1, y1 = -1, y2 = -1 } )
    AddClickArea( { id = "DamagedPageUp", x1 = -1, x2 = -1, y1 = -1, y2 = -1 } )
    AddClickArea( { id = "BrokenPageDown", x1 = -1, x2 = -1, y1 = -1, y2 = -1 } )
    AddClickArea( { id = "BrokenPageUp", x1 = -1, x2 = -1, y1 = -1, y2 = -1 } )
end

function CheckClick(x, y)
    PrintDebug("Clicked at "..x.." / "..y)
    local HitTarget=""
    for k, v in pairs(clickAreas) do
        if v and x>=v.x1 and x<=v.x2 and y>=v.y1 and y<=v.y2 then
            HitTarget=v.id
            break
        end
    end
    if HitTarget=="DamagedDamage" then
        DamagedSortingMode=1
        CurrentDamagedPage=1
        SortTables()
        DrawScreens()
    elseif HitTarget=="DamagedHealth" then
        DamagedSortingMode=3
        CurrentDamagedPage=1
        SortTables()
        DrawScreens()
    elseif HitTarget=="DamagedID" then
        DamagedSortingMode=2
        CurrentDamagedPage=1
        SortTables()
        DrawScreens()
    elseif HitTarget=="BrokenDamage" then
        BrokenSortingMode=1
        CurrentBrokenPage=1
        SortTables()
        DrawScreens()
    elseif HitTarget=="BrokenID" then
        BrokenSortingMode=2
        CurrentBrokenPage=1
        SortTables()
        DrawScreens()
    elseif HitTarget=="DamagedPageDown" then
        CurrentDamagedPage = CurrentDamagedPage + 1
        if CurrentDamagedPage > math.ceil(#damagedElements/12) then CurrentDamagedPage = math.ceil(#damagedElements/12) end
        DrawScreens()
    elseif HitTarget=="DamagedPageUp" then
        CurrentDamagedPage = CurrentDamagedPage - 1
        if CurrentDamagedPage < 1 then CurrentDamagedPage = 1 end
        DrawScreens()
    elseif HitTarget=="BrokenPageDown" then
        CurrentBrokenPage = CurrentBrokenPage + 1
        if CurrentBrokenPage > math.ceil(#brokenElements/12) then CurrentBrokenPage = math.ceil(#brokenElements/12) end
        DrawScreens()
    elseif HitTarget=="BrokenPageUp" then
        CurrentBrokenPage = CurrentBrokenPage - 1
        if CurrentBrokenPage < 1 then CurrentBrokenPage = 1 end
        DrawScreens()
    elseif HitTarget=="ToggleSimulation" then
        CurrentDamagedPage=1
        CurrentBrokenPage=1
        if SimulationMode == true then
            SimulationMode = false
            SimulationActive = false
            GenerateDamageData()
            forceRedraw = true
            DrawScreens()
        else
            SimulationMode = true
            SimulationActive = false
            GenerateDamageData()
            forceRedraw = true
            DrawScreens()
        end

    end
end

function SortTables()
    -- Sort damaged elements descending by percent damaged according to setting
    if DamagedSortingMode==1 then table.sort(damagedElements, function(a,b) return a.missinghp > b.missinghp end)
    elseif DamagedSortingMode==2 then table.sort(damagedElements, function(a,b) return a.id < b.id end)
    else table.sort(damagedElements, function(a,b) return a.percent < b.percent end)
    end

    -- Sort broken elements descending according to setting
    if BrokenSortingMode==1 then table.sort(brokenElements, function(a,b) return a.maxhp > b.maxhp end)
    else table.sort(brokenElements, function(a,b) return a.id < b.id end)
    end
end

function GenerateDamageData()
    if SimulationActive==true then
        return
    end

    local formerTotalShipHP = totalShipHP
    totalShipHP = 0
    totalShipMaxHP = 0
    totalShipIntegrity = 100
    elementsId = {}
    damagedElements = {}
    brokenElements = {}
    ElementCounter = 0
    healthyElements = 0

    elementsIdList = core.getElementIdList()

    for _,id in pairs(elementsIdList) do
        ElementCounter = ElementCounter + 1
        idHP = core.getElementHitPointsById(id) or 0
        idMaxHP = core.getElementMaxHitPointsById(id) or 0

        if SimulationMode then
            SimulationActive=true
            local dice =math.random(0,10)
            if dice < 2 then idHP = 0
            elseif dice >=2 and dice < 5 then idHP = idMaxHP
            else 
                idHP = math.random(1, math.ceil(idMaxHP))
            end
        end

        totalShipHP = totalShipHP+idHP
        totalShipMaxHP = totalShipMaxHP+idMaxHP

        -- Is element damaged?
        if idMaxHP > idHP then
            idPos = core.getElementPositionById(id)
            idName = core.getElementNameById(id)
            idType = core.getElementTypeById(id)
            if idHP>0 then
                table.insert(damagedElements,
                    {
                        id = id,
                        name = idName,
                        type = idType,
                        counter = ElementCounter,
                        hp = idHP,
                        maxhp = idMaxHP,
                        missinghp = idMaxHP-idHP,
                        percent = math.ceil(100/idMaxHP*idHP),
                        pos =idPos
                    }
                )
                if DebugMode then PrintDebug("Damaged: "..idName.." --- Type: "..idType.."") end
            -- Is element broken?
            else
                table.insert(brokenElements,
                    {
                        id = id,
                        name = idName,
                        type = idType,
                        counter = ElementCounter,
                        hp = idHP,
                        maxhp = idMaxHP,
                        missinghp = idMaxHP-idHP,
                        percent = 0,
                        pos =idPos
                    }
                )
                if DebugMode then PrintDebug("Broken: "..idName.." --- Type: "..idType.."") end
            end
        else
            healthyElements = healthyElements + 1
        end
     end

    -- Sort tables by current settings    
    SortTables()

    -- Update clickAreas


    -- Determine total ship integrity
    totalShipIntegrity = string.format("%2.0f", 100/totalShipMaxHP*totalShipHP)

    -- Has anything changes since last check? If yes, force redrawing the screens
    if formerTotalShipHP ~= totalShipHP then
        forceRedraw=true
        formerTotalShipHP = totalShipHP
    else forceRedraw=false
    end  
end

function DrawScreens()
    if #screens > 0 then

        local healthyColor = "#00aa00"
        local brokenColor = "#aa0000"
        local damagedColor = "#aaaa00"
        local integrityColor = "#aaaaaa"
        local healthyTextColor = "white"
        local brokenTextColor = "#ff4444"
        local damagedTextColor = "#ffff44"
        local integrityTextColor = "white"

        if #damagedElements ==0 then
            damagedColor = "#aaaaaa"
            damagedTextColor = "white"
        end
        if #brokenElements == 0 then 
            brokenColor = "#aaaaaa"
            brokenTextColor = "white"
        end
        
        -- Draw Header
        screenOutput = [[<svg class="bootstrap" viewBox="0 0 1920 1120" width="1920" height="1120">
                            <defs><style>
                                  .ftitle { font-size: 60px; text-anchor: start;fill: white; }
                                  .ftitlew { font-size: 60px; text-anchor: start;fill: red; }
                                  .ftitle2 { font-size: 60px; text-anchor: start;fill: #565656; }
                                  .ftopmiddle { font-size: 40px; text-anchor: middle;}
                                  .ftopend { font-size: 40px; text-anchor: end;}
                                  .fcapstart { font-size: 30px; text-anchor: start; fill: white;}
                                  .fcapstarthy { font-size: 30px; text-anchor: start; fill: yellow;}
                                  .fcapstarthr { font-size: 30px; text-anchor: start; fill: red;}
                                  .fcapmiddle { font-size: 30px; text-anchor: middle; fill: white;}
                                  .fcapend { font-size: 30px; text-anchor: end; fill: white;}
                                  .fmstart { font-size: 25px; text-anchor: start; fill: white;}
                                  .fmstartg { font-size: 25px; text-anchor: start; fill: #1e1e1e;}
                                  .fmstarty { font-size: 25px; text-anchor: start; fill: #aaaa00;}
                                  .fmstartr { font-size: 25px; text-anchor: end; fill: #ff0000;}
                                  .fmmiddle { font-size: 25px; text-anchor: middle; fill: white;}
                                  .fmend { font-size: 25px; text-anchor: end; fill: white;}
                                </style></defs>]]
        
        -- Draw main background
        screenOutput = screenOutput..
            [[<rect width="1920" height="1120" style="fill: #1e1e1e"/>
              <g>
                <path d="M1839.05,206.36H1396.29a10.3,10.3,0,0,1,.34,2.48,9.84,9.84,0,0,1-.29,2.09h442.71c14.15,0,25.67,8.36,25.67,18.65v40.64c0,10.29-11.52,18.65-25.67,18.65H81.41c-14.16,0-25.68-8.36-25.68-18.65V229.58c0-10.29,11.52-18.65,25.68-18.65H1359.35a10.51,10.51,0,0,1-.28-2.09,10.3,10.3,0,0,1,.34-2.48H81.41c-17.65,0-32,10.4-32,23.22v40.64c0,12.82,14.31,23.22,32,23.22H1839.05c17.65,0,32-10.4,32-23.22V229.58C1871,216.76,1856.7,206.36,1839.05,206.36Z" style="fill: #fff"/>
                <path d="M1377.86,202.29a11.78,11.78,0,0,0-3.88.66l-11-8c-83.9-61-83.9-61-202.71-61H73.25v4.57h1087c116.21,0,116.21,0,198.27,59.62l11.06,8a5.07,5.07,0,0,0-.77,2.64c0,3.62,4,6.56,9,6.56s9-2.94,9-6.56S1382.83,202.29,1377.86,202.29Z" style="fill: #fff"/>
                <path d="M1349.79,224H1230.18a4.56,4.56,0,0,0-4.56,4.56V271.2a4.56,4.56,0,0,0,4.56,4.56h119.61a4.56,4.56,0,0,0,4.56-4.56V228.59A4.56,4.56,0,0,0,1349.79,224Zm2.28,47.17a2.28,2.28,0,0,1-2.28,2.28H1230.18a2.28,2.28,0,0,1-2.28-2.28V228.59a2.29,2.29,0,0,1,2.28-2.28h119.61a2.29,2.29,0,0,1,2.28,2.28Z" style="fill: #fff"/>
                <rect x="966.95" y="224.03" width="232.81" height="51.73" rx="4.56" style="fill: ]]..brokenColor..[["/>
                <path d="M900.33,224H779.44a4.56,4.56,0,0,0-4.57,4.56V271.2a4.56,4.56,0,0,0,4.57,4.56H900.33a4.56,4.56,0,0,0,4.56-4.56V228.59A4.56,4.56,0,0,0,900.33,224Zm2.28,47.17a2.28,2.28,0,0,1-2.28,2.28H779.44a2.29,2.29,0,0,1-2.29-2.28V228.59a2.29,2.29,0,0,1,2.29-2.28H900.33a2.29,2.29,0,0,1,2.28,2.28Z" style="fill: #fff"/>
                <rect x="516.2" y="224.03" width="232.81" height="51.73" rx="4.56" style="fill: ]]..damagedColor..[["/>
                <path d="M449.59,224H330a4.56,4.56,0,0,0-4.56,4.56V271.2a4.56,4.56,0,0,0,4.56,4.56H449.59a4.56,4.56,0,0,0,4.56-4.56V228.59A4.56,4.56,0,0,0,449.59,224Zm2.28,47.17a2.28,2.28,0,0,1-2.28,2.28H330a2.28,2.28,0,0,1-2.28-2.28V228.59a2.29,2.29,0,0,1,2.28-2.28H449.59a2.29,2.29,0,0,1,2.28,2.28Z" style="fill: #fff"/>
                <rect x="66.74" y="224.03" width="232.81" height="51.73" rx="4.56" style="fill: ]]..healthyColor..[["/>
                <path d="M1833.79,224H1714.18a4.57,4.57,0,0,0-4.57,4.57v42.6a4.56,4.56,0,0,0,4.57,4.57h119.61a4.56,4.56,0,0,0,4.56-4.57v-42.6A4.57,4.57,0,0,0,1833.79,224Zm2.28,47.17a2.29,2.29,0,0,1-2.28,2.29H1714.18a2.29,2.29,0,0,1-2.28-2.29v-42.6a2.28,2.28,0,0,1,2.28-2.28h119.61a2.29,2.29,0,0,1,2.28,2.28Z" style="fill: #fff"/>
                <path d="M1683.75,271.17c0,2.53-2.51,4.57-5.62,4.57H1402.62c-3.11,0-5.62-2-5.62-4.57v-42.6c0-2.52,2.51-4.57,5.62-4.57h275.51c3.11,0,5.62,2.05,5.62,4.57Z" style="fill: ]]..integrityColor..[["/>
              </g>]]

        -- Draw Title and summary
        if SimulationActive==true then
            screenOutput = screenOutput..[[<text x="70" y="120" class="ftitlew">Simulated Report</text>]]
        else
            screenOutput = screenOutput..[[<text x="70" y="120" class="ftitle">Damage Report</text>]]
        end
        screenOutput = screenOutput..
                 [[<text x="690" y="120" class="ftitle2">SHIP ID ]]..shipID..[[</text>

                 <text x="185" y="263" class="ftopmiddle" fill="black">Healthy</text>
                 <text x="435" y="263" class="ftopend" fill="]]..healthyTextColor..[[">]]..healthyElements..[[</text>

                 <text x="635" y="263" class="ftopmiddle" fill="black">Damaged</text>
                 <text x="885" y="263" class="ftopend" fill="]]..damagedTextColor..[[">]]..#damagedElements..[[</text>

                 <text x="1085" y="263" class="ftopmiddle" fill="black">Broken</text>
                 <text x="1335" y="263" class="ftopend" fill="]]..brokenTextColor..[[">]]..#brokenElements..[[</text>

                 <text x="1545" y="263" class="ftopmiddle" fill="black">Integrity</text>
                 <text x="1825" y="263" class="ftopend" fill="]]..integrityTextColor..[[">]]..totalShipIntegrity..[[%</text>]]

        -- Draw damage elements
        if #damagedElements > 0 then
            local damagedElementsToDraw = #damagedElements
            if damagedElementsToDraw>12 then damagedElementsToDraw=12 end
            if CurrentDamagedPage==math.ceil(#damagedElements/12) then damagedElementsToDraw = #damagedElements%12 end
            screenOutput = screenOutput..
                         [[<rect x="70" y="350" rx="10" ry="10" width="820" height="]]..((damagedElementsToDraw+1)*50)..[[" style="fill:#66663f;stroke:#ffff00;stroke-width:3;" />]]
            screenOutput = screenOutput .. [[<rect x="80" y="360" rx="5" ry="5" width="800" height="40" style="fill:#33331a;" />]]
            if (DamagedSortingMode==2) then 
                screenOutput = screenOutput ..[[<text x="100" y="391" class="fcapstarthy">ID</text>]]
            else
                screenOutput = screenOutput ..[[<text x="100" y="391" class="fcapstart">ID</text>]]
            end
            screenOutput = screenOutput ..[[<text x="230" y="391" class="fcapstart">Element Type</text>]]
            if (DamagedSortingMode==3) then 
                screenOutput = screenOutput ..[[<text x="525" y="391" class="fcapstarthy">Health</text>]]
            else
                screenOutput = screenOutput ..[[<text x="525" y="391" class="fcapstart">Health</text>]]
            end
            if (DamagedSortingMode==1) then 
                screenOutput = screenOutput ..[[<text x="730" y="391" class="fcapstarthy">Damage</text>]]
            else
                screenOutput = screenOutput ..[[<text x="730" y="391" class="fcapstart">Damage</text>]]
            end

            local i=0
            for j=1+(CurrentDamagedPage-1)*12,damagedElementsToDraw+(CurrentDamagedPage-1)*12,1 do
                i = i + 1
                local DP = damagedElements[j]
                screenOutput = screenOutput ..
                        [[<text x="90" y="]]..(380+i*50)..[[" class="fmstartg">]]..string.format("%03.0f",DP.id)..[[</text>]]..
                        [[<text x="160" y="]]..(380+i*50)..[[" class="fmstart">]]..string.format("%.25s", DP.type)..[[</text>]]..
                        [[<text x="605" y="]]..(380+i*50)..[[" class="fmend">]]..DP.percent..[[%</text>]]..
                        [[<text x="835" y="]]..(380+i*50)..[[" class="fmend">]]..GenerateCommaValue(string.format("%.0f", DP.missinghp))..[[</text>]]..
                        [[<line x1="160" x2="834" y1="]]..(386+i*50)..[[" y2="]]..(386+i*50)..[[" style="stroke:#797953;" />]]
            end
            screenOutput = screenOutput ..
                    [[<line x1="640" x2="480" y1="290" y2="350" style="stroke:#ffff00;" stroke-dasharray="2 5" />
                        <circle cx="640" cy="290" r="10" stroke="#ffff00" stroke-width="3" fill="#66663f" />
                        <circle cx="480" cy="350" r="10" stroke="#ffff00" stroke-width="3" fill="#66663f" />]]

            if #damagedElements>12 then
                screenOutput = screenOutput ..
                    [[<text x="70" y="343" class="fmstarty">Page ]]..CurrentDamagedPage.." of "..math.ceil(#damagedElements/12)..[[</text>]]

                if CurrentDamagedPage < math.ceil(#damagedElements/12) then
                    screenOutput = screenOutput ..
                            [[<svg x="70" y="]]..(350+11+(damagedElementsToDraw+1)*50)..[[">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#aaaa00;" />
                                <svg x="80" y="15"><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
                    UpdateClickArea( "DamagedPageDown", { id = "DamagedPageDown", x1 = 70, x2 = 270, y1 = 350+11+(damagedElementsToDraw+1)*50, y2 = 350+11+50+(damagedElementsToDraw+1)*50 } )
                else
                    DisableClickArea( "DamagedPageDown" )
                end
           
                if CurrentDamagedPage > 1 then
                    screenOutput = screenOutput ..
                            [[<svg x="280" y="]]..(350+11+(damagedElementsToDraw+1)*50)..[[">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#aaaa00;" />
                                <svg x="80" y="15"><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
                    UpdateClickArea( "DamagedPageUp", { id = "DamagedPageUp", x1 = 280, x2 = 480, y1 = 350+11+(damagedElementsToDraw+1)*50, y2 = 350+11+50+(damagedElementsToDraw+1)*50 } )
                else
                    DisableClickArea( "DamagedPageUp" )
                end
            end




        end

        -- Draw broken elements
        if #brokenElements > 0 then
            local brokenElementsToDraw = #brokenElements
            if brokenElementsToDraw>12 then brokenElementsToDraw=12 end
            if CurrentBrokenPage==math.ceil(#brokenElements/12) then brokenElementsToDraw = #brokenElements%12 end
            screenOutput = screenOutput..
                         [[<rect x="1030" y="350" rx="10" ry="10" width="820" height="]]..((brokenElementsToDraw+1)*50)..[[" style="fill:#663f3f;stroke:#ff0000;stroke-width:3;" />]]
            screenOutput = screenOutput .. [[<rect x="1040" y="360" rx="5" ry="5" width="800" height="40" style="fill:#331a1a;" />]]
            if (BrokenSortingMode==2) then 
                screenOutput = screenOutput ..[[<text x="1060" y="391" class="fcapstarthr">ID</text>]]
            else
                screenOutput = screenOutput ..[[<text x="1060" y="391" class="fcapstart">ID</text>]]
            end
            screenOutput = screenOutput .. [[<text x="1190" y="391" class="fcapstart">Element Type</text>]]
            if (BrokenSortingMode==1) then 
                screenOutput = screenOutput ..[[<text x="1690" y="391" class="fcapstarthr">Damage</text>]]
            else
                screenOutput = screenOutput ..[[<text x="1690" y="391" class="fcapstart">Damage</text>]]
            end

            local i=0
            for j=1+(CurrentBrokenPage-1)*12,brokenElementsToDraw+(CurrentBrokenPage-1)*12,1 do
                i = i + 1
                local DP = brokenElements[j]
                screenOutput = screenOutput ..
                        [[<text x="1050" y="]]..(380+i*50)..[[" class="fmstartg">]]..string.format("%03.0f",DP.id)..[[</text>]]..
                        [[<text x="1120" y="]]..(380+i*50)..[[" class="fmstart">]]..string.format("%.25s", DP.type)..[[</text>]]..
                        [[<text x="1795" y="]]..(380+i*50)..[[" class="fmend">]]..GenerateCommaValue(string.format("%.0f", DP.missinghp))..[[</text>]]..
                        [[<line x1="1120" x2="1794" y1="]]..(386+i*50)..[[" y2="]]..(386+i*50)..[[" style="stroke:#795353;" />]]
            end

            screenOutput = screenOutput..             
                        [[<line x1="1085" x2="1440" y1="290" y2="350" style="stroke:#ff0000;" stroke-dasharray="2 5" />
                            <circle cx="1085" cy="290" r="10" stroke="#ff0000" stroke-width="3" fill="#663f3f" />
                            <circle cx="1440" cy="350" r="10" stroke="#ff0000" stroke-width="3" fill="#663f3f" />]]


            if #brokenElements>12 then
                screenOutput = screenOutput ..
                    [[<text x="1854" y="343" class="fmstartr">Page ]]..CurrentBrokenPage.." of "..math.ceil(#brokenElements/12)..[[</text>]]

                if CurrentBrokenPage > 1 then
                    screenOutput = screenOutput ..
                            [[<svg x="1442" y="]]..(350+11+(brokenElementsToDraw+1)*50)..[[">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#aa0000;" />
                                <svg x="80" y="15"><path d="M47.52,14.77,30.4,30.6a3.23,3.23,0,0,0,2.19,5.6H67.41a3.23,3.23,0,0,0,2.19-5.6L52.48,14.77A3.66,3.66,0,0,0,47.52,14.77Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
                    UpdateClickArea( "BrokenPageUp", { id = "BrokenPageUp", x1 = 1442, x2 = 1642, y1 = 350+11+(brokenElementsToDraw+1)*50, y2 = 350+11+50+(brokenElementsToDraw+1)*50 } )
                else
                    DisableClickArea( "BrokenPageUp" )
                end
            
                if CurrentBrokenPage < math.ceil(#brokenElements/12) then
                    screenOutput = screenOutput ..
                            [[<svg x="1652" y="]]..(350+11+(brokenElementsToDraw+1)*50)..[[">
                                <rect x="0" y="0" rx="10" ry="10" width="200" height="50" style="fill:#aa0000;" />
                                <svg x="80" y="15"><path d="M52.48,35.23,69.6,19.4a3.23,3.23,0,0,0-2.19-5.6H32.59a3.23,3.23,0,0,0-2.19,5.6L47.52,35.23A3.66,3.66,0,0,0,52.48,35.23Z" transform="translate(-29.36 -13.8)"/></svg>
                            </svg>]]
                    UpdateClickArea( "BrokenPageDown", { id = "BrokenPageDown", x1 = 1652, x2 = 1852, y1 = 350+11+(brokenElementsToDraw+1)*50, y2 = 350+11+50+(brokenElementsToDraw+1)*50 } )
                else
                    DisableClickArea( "BrokenPageDown" )
                end
            end



        end

        -- Draw damage summary
        if #damagedElements>0 or #brokenElements > 0 then
            screenOutput = screenOutput..
                         [[<text x="960" y="1070" class="ftopmiddle" fill="white">]]..GenerateCommaValue(string.format("%.0f", totalShipMaxHP-totalShipHP))..[[ HP damage in total</text>]]

        end

        screenOutput = screenOutput..[[</svg>]]

        DrawSVG(screenOutput)

        forceRedraw=false
    end
end

-----------------------------------------------
-- Execute
-----------------------------------------------

unit.hide()
ClearConsole()
PrintDebug("SCRIPT STARTED", true)

InitiateSlots()
SwitchScreens(true)
InitiateClickAreas()

if core == nil then
    DrawCenteredText("ERROR: No core connected.")
    PrintError("ERROR: No core connected.")
    goto exit
else
    shipID = core.getConstructId()
end

GenerateDamageData()
if forceRedraw then
    DrawScreens()
end

unit.setTimer('UpdateData', UpdateInterval)

::exit::