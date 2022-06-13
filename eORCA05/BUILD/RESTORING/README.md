# Building the restoring file
## Context
In order to correct permanent and robust flaws in the ocean simulation, we decided to use
3D temperature and salinity restoring toward some T/S climatology.  This was the paradgm used
in DRAKKAR and for a long time, the restoring coefficient was computed within NEMO. Since NEMO_4.0.x
we decided to use an external 3D file holding the restoring coefficient (units s^-1), instead
of code modifications.  In order to build this file CDFTOOLS were developped, namely `cdfmaskdmp` 
and `cdfmkresto`.

## Restoring below a given isopycnal:
In DRAKKAR we also implemented a deep restoring corresponding to AABW in the southern ocean, in
order to prevent the erosion of this water mass, hence preventing the colapse of the ACC. (cf
Carolina Dufour Phd.).  

## Restoring in semi-enclosed Seas
At low resolution, restoring is done in semi-enclosed seas such as Med Sea, Black Sea, Red Sea and Persian Gulf.
Those region act a reservoirs of relatively high density waters (in particular very high salinity). 

## Restoring in overflow areas :
Dense waters overflow among the many bathymetric sills is not well represented in the code, in
particular at low resolution. Although not satisfactory, we implement some T/S restoring downstream
of some topographic sills in order to limit entrainement and to keep reasonable water mass properties
there. This was done for Gibraltar, Bab-el-Mandeb and Ormuz straits.   

Restoring of all types (below isopycnal, in semi enclosed seas and  downstream overflows) are implemented in a single restoring file.

## Making the restoring file :
All the procedure is gathered into [mkresto.sh](./mkresto.sh). An annual cllimatology is used for defining the deep isopycnal.

```
#!/bin/bash

CONFIG=eORCA05.L121

# Start by creating the restoring coef (and mask for control)  corresponding to AABW in the southern ocean
#eORCA05.L121_81B0_WOA18_1m_vosaline.nc0
./cdfmaskdmp -t  ${CONFIG}_81B0_WOA18_1y_votemper.nc -s ${CONFIG}_81B0_WOA18_1y_vosaline.nc -refdep 2000 -dens 37.16 0.025 -dep 1000 100 -lat -25 2 -nc4 -o ${CONFIG}_AABW_dmpmsk.nc
./cdfmaskdmp -t  ${CONFIG}_81B0_WOA18_1y_votemper.nc -s ${CONFIG}_81B0_WOA18_1y_vosaline.nc -refdep 2000 -dens 37.16 0.025 -dep 1000 100 -lat -25 2 -nc4  \
             -tau 720 -o ${CONFIG}_AABW_resto.nc

# Then add restoring zone (drakkar like)
cat << eof > drakkar_restoring.txt
# DRAKKAR restoring configuration file
# Black Sea
# type lon1  lon2 lat1 lat2 rim_width tresto   z1   z2
     R   27.4 42.0 41.0 47.5   0.       180.     0    0
# Red Sea
     R   20.4 43.6 12.9 30.3   0.       180.     0    0
# Persian Gulf
     R   46.5 57.0 23.0 31.5   1.       180.     0    0
# Restoring in the overflow regions
# Gulf of Cadix (Gibraltar overflow)
# type lon1  lat1 radius tresto  z1    z2
     C  -7.0  36.0  80.      6.  600. 1300.
# Gulf of Aden (Bab-el-Mandeb overflow)
     C  44.75 11.5 100.      6.  0.   0.
# Arabian Gulf  (Ormuz Strait  overflow)
     C  57.75 25.0 100.      6.  0.   0.
eof

./cdfmkresto -c mesh_hgr.nc -i drakkar_restoring.txt -o  ${CONFIG}_resto.nc -ov resto -prev ${CONFIG}_AABW_resto.nc resto -nc4 

```

