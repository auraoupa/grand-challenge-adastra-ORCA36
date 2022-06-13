# building bfr2d file
## Context:
 Bottom friction can be localy boosted. The intensity of the boost is a namelist parameter but
the spatial pattern is given by a mask-like file [0-1], whose construction is treated here.

## Where ?
  Bottom friction is boosted mainly in some narrow straits, where we want to reduce the flow.
It can be used (or not) in conjunction with lateral friction boost too. The actual regions
where bottom friction boost is applied are :
  * Torres Strait
  * Bering Strait
  * Denmark Strait
  * Bab-el-Mandeb


## How ?
  `cdfkresto` is used to create the bfr2d file.  In order to have a value in the range [0-1], we
use -val option.  [mkbfr2d.sh](./mkbfr2d.sh) script summarize the values
used in the production of this file :

```
#!/bin/bash
CONFIG=eORCA05.L121

# use cdfmkresto build the 2D map of bfr2d coef.
cat << eof > drakkar_bfr.txt
# Construction of bfr2d file for enhanced bottom friction
# Torres strait
# type lon      lat radius rim tau z1 z2
   D    142.5  -10.1  85    15  1   0  0
# Berring strait
# type lon1      lon2   lat1   lat2   rim   tau  z1  z2
   R    -172.3  -166.0  64.7   66.5   1      1   0   0
# Bab El Mandeb
# type lon      lat radius  tau z1 z2
   C    43.4   12.6   30     1  0  0
# Denmark strait
# type lon      lat radius  tau z1 z2
   C   -27.3   65.9   40     1  0   0
eof

./cdfmkresto -c mesh_hgr.nc -i drakkar_bfr.txt -o  ${CONFIG}_bfr2d.nc -ov bfr_coef -2d  -val 1 -nc4

```
