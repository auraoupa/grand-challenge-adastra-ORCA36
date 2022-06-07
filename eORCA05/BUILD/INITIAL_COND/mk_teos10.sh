#!/bin/bash

CONFIG=eORCA05.L121

# make links to GSW tools in JMMTOOLS
 ln -sf /gpfswork/rech/cli/rcli002/DEVGIT/JMMTOOLS/DATA_TOOLS/LEVITUS-WOA/gsw_data_v3_0.dat .
 ln -sf /gpfswork/rech/cli/rcli002/DEVGIT/JMMTOOLS/DATA_TOOLS/LEVITUS-WOA/pt_sp_to_ct_sa ./


for sp in ${CONFIG}_*_vosaline*.nc ; do
   pt=$( echo $sp | sed -e 's/vosaline/votemper/')
   ct=$( echo $sp | sed -e 's/vosaline/CT/')
   sa=$( echo $sp | sed -e 's/vosaline/SA/')

   ./pt_sp_to_ct_sa -pt $pt -vpt votemper -sp $sp -vsp vosaline \
     -ct $ct -vct CT -sa $sa -vsa SA -x x -y y -z deptht -t time_counter \
     -lon nav_lon -lat nav_lat  -dep deptht -tim time_counter -2D

done
