
![Standard View](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/DR_Logo1.png)

# Damage Report v1.52 (DU-DamageReport)

### A multi-screen capable, touch enabled, easy to install ship damage reporting script for **Dual Universe**.

**Find that one damaged element faster. Have an eye on the elements of your ship which are hidden by honeycomb. Always know what has been damaged after hitting that tower due to lag near a marketplace. Don't get off your pilot seat to determine whether you need to land and repair immediatelly or have time until you arrived home at your base. Always have an overview during pvp which systems have been hit and have all the data to decide when it's time to run.**

*Created By Dorian Gray*

*Discord: Dorian Gray#2623 - InGame: DorianGray - GitHub: https://github.com/DorianTheGrey/DU-DamageReport*

*Thanks to Jericho, Dmentia and Archaegeo for learning a lot from their fine scripts.*

**Installation and usage description as well as the roadmap are below the images.**

![Standard View](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/StandardView.png)
![Cockpit](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/InstalledToShip2.png)
![All systems nominal](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/AllSystemsNominal2.png)
![Change Sorting](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/ChangeSorting.png)
![Simulation Mode](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/SimulatedView.png)
![Up to 9 monitors](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/UpTo9Monitors2.png)


### Installation

1. Place a Progamming Board on your ship as well as one (or two, or three, ...) monitors you want the Damage Report to be displayed.
2. Link your ships core to the Programming Board (you do not need to rename any slots).
3. Link all monitors to the board you want to use with Damage Report (you do not need to rename any slots).
4. Copy the latest JSON file of https://github.com/DorianTheGrey/DU-DamageReport, it's called "DamageReport_X_X.json". Click on the file, click on "Raw", copy everything.
5. Rightclick on your Programming Board -> Advanced -> Paste LUA configuation from clipboard
6. Activate Programming Board.

### Usage

1. The script simply displays your damage data of your ship onto 1 to X screens, separated by damaged modules as well as broken modules. You can click on the captions of any screen to change the sorting (by damage, by health or by id). If you click on the title ("Damage Report"), you can enter Simulation Mode (see 3.)
2. Rightclicking on your Programming Board -> Advanced -> Edit LUA parameters allows you to change four values:
* [Optional] If you enable UseMyElementNames the display on the screens will not label damaged/broken elements by their type but by the name you gave them (truncated to 25 characters). Please note you can also click on the "Element Type" label on any connected screen to switch the mode.
* [Optional] You can change the update interval in which the damage data of your ship will be scanned and processed. By default, this is 1 second. Please note that your screens will only refresh if your data changed.
* [Optional] You can check "SimulationMode" to start the Programming Board in Simulation Mode by default (see 3.)
* [Optional] If you enter your shipname into the variable "YourShipName" the display uses this name instead of the ship id at the top. Don't forget the quotation marks, otherwise it will not work (and you will have to reinstall the script).
3. The script can either display the current damage data of your ship, or it can simulate random damage to your elements, should you want to test the views. No, your elements won't take any harm in the process. :)

### Roadmap

Currently the following additions are on the roadmap (unordered list):

1. Add scraps display needed to repair it all
2. Tracking of damaged/broken elements in 3D space to easier find them
3. Pop-out HUD functionality to have a mobile display while repairing 

*GNU Public License 3.0. Use whatever you want, be so kind to leave credit.*
