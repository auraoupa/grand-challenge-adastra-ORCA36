# Iceshelve melting

## 1. Context:
Ice shelve are formed by continental glaciers ending on the ocean, floating on the ocean.
Hence sea water circulates below this floating part and produces melting at the interface
between the iceshelf and the water.  This fresh melted water (low density) tends to move up 
to the surface and resurgence to the open sea occur at the iceshelf front.  There are many
tricky things related to this physical process of deep melting, but we are not aiming at
discussing those things here.  
In NEMO this melting can be basically reprensented in 2 ways :
  * Parameterization of the melting by adding a fresh water flux at the iceshelf front, at
depths ranging from the depths of the grounding line and the deptht of the iceshelf at the
iceshelf front. This parameterization also introduce heat fluxes associated with the melting.  
This parameterization uses iceshelf basal melting rate estimates, coming from observation of
mass balance model of the continental ice sheet. 
  * Explicit representation of ocean circulation into the ice cavity, below the iceshelf. In
this case, the model evolved freely and melting basically depends on the water temperature and
salinity in the cavity, the velocity of the flow in the cavity etc.. In this case, no specific
data are used about the melting rate, and no extra file are necessary. Of course, the 
geometry of the cavity (fixed in time) should be documented. It is done in the domain_cfg file
with `icedraft` variable.

## 2. Iceshelf file
This iceshelf file define the horizontal extend of the different iceshelve. It is used for
iceberg calving file preparation, and also when iceshelf melt parameterization is used.


## 3. Iceshelf melting:
This file is used only when the iceshelf melting is parameterized. It provides gridded 
variables for the melting rate and the mininmum/maximum depths where the melting freshwater
flux is applied.
