This is a basic overview of the steps to perform autotune and auto board pitch alignment in INAV 3.0

# Initial Setup  
* Enable "continuous servo trim" in configuration tab
* Modes Tab 
  * Create acro/autotune flight mode. It's recommended to add P,I,FF values on your OSD to see values changing.
  * Create angle mode w/ autolevel.

# Tuning Flight
* Take off
* Fly in acro mode
* Switch on autotune
* Give full roll and pitch inputs
* Turn off autotune
* Switch to angle/autolevel mode
* Switch back to acro
* Land
* Disarm
* Save(stick command)

When satisfied with performance, remove autolevel and autotune modes.  
 
Confirm in modes tab that your servo center positions are within a value of 1450 and 1550. IF outside this range, it is recommended to mechanically trim your control surfaces to 1500 usec. After a good servo center has been attained you can disable "continuous servo trim" 
  
  

