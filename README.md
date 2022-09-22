(DEVELOPMENT ENDED)

![Standard View](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/DR_Logo1.png)

# Damage Report v3.31 (DU-DamageReport)

### A multi-screen (and HUD) capable, touch enabled, easy to install ship damage reporting script for **Dual Universe**.

**Find that one damaged element faster. Have an eye on the elements of your ship which are hidden by honeycomb. Always know what has been damaged after hitting that tower due to lag near a marketplace. Know your fuel situation. Highlight damaged or broken elements in 3D space or find them in ship outline views. Customize all colors and background to fit your bridge colors and style.**

**Note: the linking order is important, or your touchscreen will not work (see installation instructions below). Recommendation: run it with only one screen or two, because otherwise you will likely run into script CPU usage problems before optimizations are done.**

Very soon we will be linking a YouTube video here explaning the installation and usage of the script in detail. For now please see the installation and usage description below the following screenshots, as well as a note about the roadmap and known issues.

*Created By Dorian Gray*

*Thanks to Bayouking1 and kalazzerx for managing their forks of this script during my long absence to support the community, also thanks to Bayouking1 for fixing rocket fuel calculations. :)Thanks to NovaQuark for creating the best MMO of the century. Thanks to Jericho, Dmentia and Archaegeo from DU Open Source Initiative for learning a lot about DU LUA from their fine scripts. Thanks to TheBlacklist for his testing and his many wonderful suggestions. SVG patterns by Hero Patterns. DU atlas data from Jayle Break.*

![1a](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/1a.png)
![1](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/1.png)
![2](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/2.png)
![3](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/3.png)
![4](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/4.png)
![5](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/5.png)
![6](https://github.com/DorianTheGrey/DU-DamageReport/blob/main/img/6.png)

### Important Notes

This script is comparably intense in regards to DU CPU resources required. Using many screens, using it on a ship with many (1000+) elements, clicking rapidly on the settings page, and/or having many damaged elements will most likely cause a script shutdown due to the limited CPU time we get. Using less screens and clicking a tiny bit slower during color selection will help. For now, I am not limiting the number of screens you can use (up to 8), but you will see that 1-3 screens works a lot smoother than more. - Finally, all scripts you run in parallel share one CPU limit, so I advise to switch this script off while you are using e.g. a heavy flight hud script. You have been warned. :)

Having said all of this, I successfully used the script on a 1100 element L core ship (on one screen) without problems.

### Installation

1. You need a ship (aka a dynamic core), a databank and a screen (or two, three, ...).
2. Place a Progamming Board and a databank on your ship.
3. Link the Programming Board to your ships core, then link the Programming Board to the databank, then link the Programming Board to your screen. You can link it to more than one screens, but I highly recommend you start with 1-3 screens only as adding more screens will most probably will make you run into script shutdowns due to the CPU limit.
4. [Optionally] You can run the script without connecting any screens at all, but you will only be able to use the "HUD Mode" and will miss out on most features of the script.
5. Copy the latest config file of https://github.com/DorianTheGrey/DU-DamageReport, it's called "DamageReport_X_XX.conf". Click on the file, click on "Raw", copy everything. (This is the latest file: https://raw.githubusercontent.com/DorianTheGrey/DU-DamageReport/main/DamageReport_3_31.conf)
6. Rightclick on your Programming Board -> Advanced -> Paste LUA configuation from clipboard.
7. Activate Programming Board.
8. Rightclick on your programming board -> advanced -> edit lua parameters. Here you can enter the name of your ship. **Do not remove the quotation marks.**
9. Still in the Edit Lua Parameters (see 8.), please set your talents according to the name/description of the talents. You see the description if you hover with your mouse over the name. Please note that any line item marked as "Skill" requires you to enter your own level of that type, while "Stat" requires you to enter the level of the specific item that has been placed on your ship (either by you or the builder). **If you do not set up your talents/stats or don't set them up correctly, the fuel mode will not show you correct data, likewise the scrap calculations will not be correct.**

### Usage

Very soon we will be linking a YouTube video here explaning the installation and usage of the script in detail.

Activate the script at the Programming Board, not through a detection zone or a switch. DU prevents HUDs to be drawn to players that haven't activated a script through either a Programming Board or a Control Seat. (The script will work, you will just not be able to use the HUD-mode.) Also, please rememeber to set your talents correctly in the "Edit LUA Parameters" (Rightclick Programming Board -> Advanced -> Edit LUA Parameters). Also check "DisallowKeyPresses" if you want Damage Report to process any keypresses. This will limit the usability of your HUD mode significantly, but if you prever to use the keys for other scripts, this is a solution. (You can always toggle it back on if you have a bigger repair task ahead of you.)

The bottom row shows several modes you can switch the screen into:

1. TIME - Will display the time on this screen as long as the script runs.

2. DMG - This mode displays the damaged and broken elements of your ship (should there be any). Clicking on the Scrap-Tier in the header switches through Scrap-Tiers 1 to 4 to calculate your repair time and amount of specific scraps needed. (Please set your skills in the Settings, or it will not show correct data.) Clicking on "Damage Name" or "Broken Name" will turn the display to use element types instead of names, should you prefer that. Clicking on "Damage Type" or "Broken Type" will then turn the display back again to use names instead.

3. DMGO - This will draw a ship outline based on the position of the elements of your ship. You can switch the screen into top, side or front views.

4. FUEL - This will show the fuel tank situation on your ship. (Please set your skills in the Settings, or it will not show correct data.)

On the right side, there's two additional buttons:

5. SETS - This is the settings page of the script. Via touchscreen you are able to change all colors and the background as well as background opacity (left side). Lastly, you can also activate "Simulate Damage to Elements" so the script assumes certain damage on your ship's elements. That way you can look at all the displays and the HUD how they look like when your ship took damage without having to crash your ship. - Please note that all settings you change will be saved in the databank.

6. HUD - This activates the HUD mode. The HUD mode is an overlay on your UI displaying certain damage data. The HUD mode is not connected to any of the 4 main modes (1. to 4.) but is always the same. While using the HUD you will also see certain buttons you can use to control the script:

* Left arrow will toggle the HUD display (that's the same than you clicking the HUD-button on a screen).
* Up/down arrows will select a damaged/broken element from your list (should you have broken elements). Selected elements will be highlighted in 3D space with arrows, so you can easier find them.
* Right arrow will deselect the selected element.
* CTRL + arrows will move the HUD on your screen so you can place it whereever you want.
* ALT+8 will reset the HUD back to it's original position.
* ALT+1, ALT+2, ALT+3, and ALT+4 will select the corresponding scrap tier level for the repair time and needed scrap calculations.
* ALT+9 will shutdown the script. This is useful if e.g. you still had your script running because you repaired the ship and then want to move away. It's always better to manually shut it off than simply running out of range (as the screens will be cleared).

In general: just play around with the script a bit, you'll get the hang of it quickly.

### Roadmap

There's plenty of bullet points on the roadmap, but as of now I am only focusing on optimizing the code, so you will run into less CPU shutdown issues and/or will be able to run more screens in parallel. So, I am working on integrating coroutines.

3D projection system? :)

### Known Issues

1. You will run into script shutdowns due to the CPU usage. Use less screens to have a higher chance of not running into this problem. Optimizations are being worked on, but you can only go so far with the limited processing time we get. If this is too much of a problem for you at the current stage, please use version 2.33 instead (in "versions").

2. More time & date formats are coming soon.

3. Your touchscreen is not working? - First make sure you are not holding a tool in your hand when trying to click (don't laugh, it happened to all of us). If that is not the problem, you most probably linked the elements in a wrong order. As in the installation: 1. Programming Board to Core, 2. Programming Board to Databank, 3. Programming Board to Screen, 4. Paste conf into Programming Board.

*Under GNU Public License 3.0.*
