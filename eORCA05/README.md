#eORCA05
## Foreword
We decided to set up a very light configuration based on eORCA05, aimimg at testing all the ingredients of the foreseen eORCA36 simulation.  
In particular, this configuration will share the exact same version of NEMO. Basically, only the namelist will differ and as far as possible xml files for XIOS should be the same, with likely an exception  if we decided to include specific sections in the output data set (sections are defined with  true model index).   
In the world of NEMO, the 1/2 degree global configuration is ORCA05.L31. For the actual purpose, we will setup eORCA05.L75 or eORCA05.L121 according to the choices retained for eORCA36. eORCA05 will have a southward extended grid just as eORCA025, eORCA12 or eORCA36.


## Building eORCA05
### Horizontal grid : from ORCA05 to eORCA05
