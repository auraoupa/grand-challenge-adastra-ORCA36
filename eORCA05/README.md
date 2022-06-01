#eORCA05
## Foreword
We decided to set up a very light configuration based on eORCA05, aimimg at testing all the ingredients of the foreseen eORCA36 simulation.  
In particular, this configuration will share the exact same version of NEMO. Basically, only the namelist will differ and as far as possible xml files for XIOS should be the same, with likely an exception  if we decided to include specific sections in the output data set (sections are defined with  true model index).   
In the world of NEMO, the 1/2 degree global configuration is ORCA05.L31. For the actual purpose, we will setup eORCA05.L75 or eORCA05.L121 according to the choices retained for eORCA36. eORCA05 will have a southward extended grid just as eORCA025, eORCA12 or eORCA36.


## Building eORCA05
### Horizontal grid : from ORCA05 to eORCA05
We start from eORCA025 grid and figure out how ORCA05 points matches  eORCA025  points.  We found that T point ORCA05(3,256) is located as T points eORCA025(5,697).
In the same manner, for instance, we found that U point ORCA05(3,256) = T points eORCA025(6,297), etc ..
The program [mkorca05.f90](BUILD/HGR/mkorca05.f90) was written in order to create the eORCA05 grid, and in particular its southern extension, using  the matching points.
After determining the location of T U V F points in the eORCA05 grid, e1 and e2 metrics was calculated using orthodromic distance between *ad hoc* points. Finally, we 
patch the eORCA05 grid with original ORCA05 grid north of J=79.  This program ends up creating the file `eORCA05_coordinates.nc`.
