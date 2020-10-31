
![Standard View](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/DR_Logo1.png)

# Damage Report v2.31 (DU-DamageReport)

### A multi-screen (and HUD) capable, touch enabled, easy to install ship damage reporting script for **Dual Universe**.

**Find that one damaged element faster. Have an eye on the elements of your ship which are hidden by honeycomb. Always know what has been damaged after hitting that tower due to lag near a marketplace. Don't get off your pilot seat to determine whether you need to land and repair immediatelly or have time until you arrived home at your base. Always have an overview during pvp which systems have been hit and have all the data to decide when it's time to run. Highlight damaged or broken elements in 3D space through the HUD Mode to find what you want to repair much faster.**

*Created By Dorian Gray*

*Discord: Dorian Gray#2623 - InGame: DorianGray - GitHub: https://github.com/DorianTheGrey/DU-DamageReport*

*Thanks to Jericho, Dmentia and Archaegeo for learning a lot from their fine scripts.*

**Installation and usage description as well as the roadmap and known issues are below the images.**

![Activate HUD Mode Standard View](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/ActivateHUDMode.png)
![Standard View](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/StandardView.png)
![Cockpit](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/InstalledToShip2.png)
![HUD Mode](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/DamageReportHUD.png)
![All systems nominal](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/AllSystemsNominal2.png)
![Change Sorting](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/ChangeSorting.png)
![Simulation Mode](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/SimulatedView.png)
![Up to 9 monitors](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/UpTo9Monitors2.png)


### Installation

1. Place a Progamming Board on your ship as well as one (or two, or three, ...) monitors you want the Damage Report to be displayed.
2. Link your ships core to the Programming Board (you do not need to rename any slots). **Make sure you link the core first, before you link screens!**
3. Link all monitors to the board you want to use with Damage Report (you do not need to rename any slots).
4. Copy the latest config file of https://github.com/DorianTheGrey/DU-DamageReport, it's called "DamageReport_X_X.json". Click on the file, click on "Raw", copy everything.
5. Rightclick on your Programming Board -> Advanced -> Paste LUA configuation from clipboard
6. Activate Programming Board.

### Usage

1. **Activate the script at the Programming Board, not through a detection zone or a switch. DU prevents HUDs to be drawn to players that haven't activated a script through either a Programming Board or a Control Seat.** (The script will work, you will just not be able to use the HUD-mode.)
2. The script simply displays your damage data of your ship onto 1 to X screens, separated by damaged modules as well as broken modules. You can click on the captions of any screen to change the sorting (by damage, by health or by id). If you click on the title ("Damage Report"), you can enter Simulation Mode (see 3.). If you activate HUD mode (click on the screen), you can use the arrow-up and arrow-down keys to highlight elements, so that blinking markers in 3D space help you find it. Arrow-left toggles the HUD Mode, arrow-right deselects the selected element.
3. Rightclicking on your Programming Board -> Advanced -> Edit LUA parameters allows you to change several values:
* [Optional] If you enable UseMyElementNames the display on the screens will not label damaged/broken elements by their type but by the name you gave them (truncated to 25 characters). Please note you can also click on the "Element Type" label on any connected screen to switch the mode.
* [Optional] You can change the update interval in which the damage data of your ship will be scanned and processed. By default, this is 1 second. Please note that your screens will only refresh if your data changed.
* [Optional] You can change the blinking frequency of a highlighted element.
* [Optional] You can check "SimulationMode" to start the Programming Board in Simulation Mode by default (see 3.)
* [Optional] If you enter your shipname into the variable "YourShipName" the display uses this name instead of the ship id at the top. Don't forget the quotation marks, otherwise it will not work (and you will have to reinstall the script).
4. The script can either display the current damage data of your ship, or it can simulate random damage to your elements, should you want to test the views. No, your elements won't take any harm in the process. :)

### Roadmap

Currently the following additions are on the roadmap (unordered list):

1. Add filters, so it's possible to monitor only specific element categories (flight systems, combat systems, etc.)
2. Implement 3D to 2D projection, so damaged elements can be seen in the HUD mode as if you were using an ESP
3. Beef up visuals and offer some visual options

### Known Issues

1. HUD-mode will not work if you didn't activate the script at the Programming Board. If you activate it via a switch, a detection zone or similar, DU prevents the script from accessing the HUD. You need to start the script at the Programming Board if you want to use the HUD.


*GNU Public License 3.0. Use whatever you want, be so kind to leave credit.*
