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





exit
 cdfmaskdmp -t T-file [-s S-file] [-refdep REF-depth] [-tau TIME-scale]
              ... [-dens smin width] [-dep hmin width] [-lat latmax width] ...
              ... [-o OUT-file] [-nc4] [-zdim zdimnm]

  usage :  cdfmkresto -c COORD-file -i CFG-file [-d DEP-file] [-o DMP-file]...
                      ...[-ov VAR-out] [-2d] [-prev RESTO-file RESTO-var ] ...
                      ...[-val VALUE] [-nc4] [-h]


