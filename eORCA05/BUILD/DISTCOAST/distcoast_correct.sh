#!/bin/bash

rm eORCA05_disrunoff_v1.nc.01* eORCA05_disrunoff_v1.nc.02* eORCA05_disrunoff_v1.nc.03*


# Med Sea Black Sea Red Sea
cdfvar -f eORCA05_disrunoff_v1.nc -v Tcoast -zoom 574 665 370 459 -sz 5000000 
cdfvar -f eORCA05_disrunoff_v1.nc.01 -v Tcoast -zoom 564 582 412 438  -sz 5000000 
# Persian Gulf
cdfvar -f eORCA05_disrunoff_v1.nc.02 -v Tcoast -zoom 666 689 388 413  -sz 5000000 
cdfmltmask -f eORCA05_disrunoff_v1.nc.03 -v Tcoast -p T -m eORCA05.L121_mesh_mask.nc

