//lock pointers to drill radiator percentage values
set ListDrillRadiators to ship:partsdubbedpattern("drillrad*").
    set moduleDrillRadiator0 to ListDrillRadiators[0]:getmodule("ModuleActiveRadiator").
    lock PctDrillRadiator0 to moduleDrillRadiator0:getfield("cooling").

set ListIsruRadiators to ship:partsdubbedpattern("isrurad*").
    set moduleIsruRadiator0 to ListIsruRadiators[0]:getmodule("ModuleActiveRadiator").
    lock PctIsruRadiator0 to moduleIsruRadiator0:getfield("cooling").

    set moduleIsruRadiator1 to ListIsruRadiators[1]:getmodule("ModuleActiveRadiator").
    lock PctIsruRadiator1 to moduleIsruRadiator1:getfield("cooling").
    
    set moduleIsruRadiator2 to ListIsruRadiators[2]:getmodule("ModuleActiveRadiator").
    lock PctIsruRadiator2 to moduleIsruRadiator2:getfield("cooling").
    

//set max capacity values
set maxLiquidFuel to ship:resources[0]:capacity.
set maxOxidizer to ship:resources[1]:capacity.
set maxElectricity to ship:resources[2]:capacity.
set maxOre to ship:resources[3]:capacity.

//get pointer to the ISRU
set ListISRUs to ship:partsdubbed("Isru0").
    set isrupart to ListISRUs[0].
 
 
    
//get handle to Li+Ox
set LiOxISRU to isrupart:getmoduleByIndex(1).
    
//get handle to monoprop
set monopISRU to isrupart:getmoduleByIndex(2).

//get handle to Li       
set LiISRU to isrupart:getmoduleByIndex(3).

//get handle to Ox
set OxISRU to isrupart:getmoduleByIndex(4).        
   
//outer  loop
if ship:LiquidFuel < maxLiquidFuel OR ship:Oxidizer < maxOxidizer OR ship:monopropellant < 720 or ship:ore < maxOre {

        
        
        //check the power level
        if ship:electriccharge > maxElectricity/10 {
        
                //start mining if ore hold is not full and drill radiator below 50 pct
                if  ship:ore < maxOre AND PctDrillRadiator0:replace("%", ""):ToNumber() < 50 {
                    
                    Drills on.
                }
                else {
                    Drills off.
                    wait until PctDrillRadiator0:replace("%", ""):ToNumber() < 25.
                }
               

                //check to see if ISRU radiators are below 50 pct, if above, shut ISRU down
                if PctIsruRadiator0:replace("%", ""):ToNumber() < 50 AND PctIsruRadiator1:replace("%", ""):ToNumber() < 50 AND PctIsruRadiator2:replace("%", ""):ToNumber() < 50 {
                     //check Li + Ox
                     if ship:LiquidFuel < maxLiquidFuel AND ship:Oxidizer < maxOxidizer {
                         LiOxISRU:DOEVENT("start isru [lf+ox]").
                            }
                     else {
						if LiOxISRU:HASEVENT("stop isru [lf+ox]")
                         LiOxISRU:DOEVENT("stop isru [lf+ox]").
                            }
                     
                     wait 1.
                     
                     //check Monoprop
             
                    if ship:monopropellant < 720 {
						if monopISRU:HASEVENT("start isru [monoprop]")
							monopISRU:DOEVENT("start isru [monoprop]").
							}
					else {
						monopISRU:DOEVENT("stop isru [monoprop]").
							}
						
					 
					 
                     wait 1.
                     
                     //check Li
                     if ship:LiquidFuel < maxLiquidFuel  {
                         LiISRU:DOEVENT("start isru [lqdfuel]").
                          }
                     else {
						if LiISRU:HASEVENT("stop isru [lqdfuel]")
                         LiISRU:DOEVENT("stop isru [lqdfuel]").
                         }
                     
                     wait 1.
                     
                     
                     //check Ox
                     if ship:Oxidizer < maxOxidizer {
                        OxISRU:DOEVENT("start irsu [ox]").
                         }
                     else {
						if OxISRU:HASEVENT("stop irsu [ox]")
                         OxISRU:DOEVENT("stop irsu [ox]").
                        }
                     
                     wait 1.
                     
                }
                else {
                    ISRU off.
                    wait until PctIsruRadiator0:replace("%", ""):ToNumber() < 25 AND PctIsruRadiator1:replace("%", ""):ToNumber() < 25 AND PctIsruRadiator2:replace("%", ""):ToNumber() < 25.  
                     // let the radiators cool down
                }
        
                wait 1.
    }
    
        else {
            //shut down operations because power is too low
            Drills off.
            Isru off.
            wait until ship:electriccharge > maxElectricity * 0.8.
        }
    
 wait 1.   
}   
    
else
	wait 1.
	print("ship:LiquidFuel < maxLiquidFuel").
	print(ship:LiquidFuel < maxLiquidFuel).
	print("").
	print("ship:Oxidizer < maxOxidizer").
	print(ship:Oxidizer < maxOxidizer).
	print("").
	print("ship:monopropellant < 720").
	print(ship:monopropellant < 720).
	print("").
	print("ship:ore < maxOre").
	print(ship:ore < maxOre).
	print("").
	print("Electric Charge").
	print(ship:electriccharge).
