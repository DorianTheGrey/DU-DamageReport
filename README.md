# DU-DamageReport
	DamageReport v1.0

	A multi-screen ship damage reporting script for Dual Universe

    Created By Dorian Gray

    Discord: Dorian Gray#2623
    InGame: DorianGray
    GitHub: https://github.com/DorianTheGrey/DU-DamageReport

    GNU Public License 3.0. Use whatever you want, be so kind to leave credit.

    Thanks to Jericho, Dmentia and Archaegeo for learning from their fine scripts.

    INSTALLATION:

    1. Place a Progamming Board on your ship as well as one (or two, or three, ...) monitors you want the Damage Report to be displayed.
    2. Link your ships core to the Programming Board
    3. Link all monitors to the board you want to use with Damage Report
    4. Copy the latest JSON file of https://github.com/DorianTheGrey/DU-DamageReport
    5. Rightclick on your Programming Board -> Advanced -> Paste LUA configuation from clipboard
    6. Activate Programming Board.

    USAGE:

    1. The script simply displays your damage data of your ship onto 1 to X screens, separated by damaged modules as well as broken modules. You can click on the captions of any screen to change the sorting (by damage, by health or by id). If you click on the title ("Damage Report"), you can enter Simulation Mode (see 3.)
    2. Rightclicking on your Programming Board -> Advanced -> Edit LUA parameters allows you to change two values:
    	- You can change the update interval in which the damage data of your ship will be scanned and processed. By default, this is 1 second. Please note that your screens will only refresh if your data changed.
    	- You can check "SimulationMode" to start the Programming Board in Simulation Mode by default (see 3.)
    3. The script can either display the current damage data of your ship, or it can simulate random damage to your elements, should you want to test the views. No, your elements won't take any harm in the process. :)