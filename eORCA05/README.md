# eORCA05: a toy configuration for Grand Challenge on ADASTRA
## Foreword
We decided to set up a very light configuration based on eORCA05, aimimg at testing all the ingredients of the foreseen eORCA36 simulation.  
In particular, this configuration will share the exact same version of NEMO. Basically, only the namelist will differ and as far as possible xml files for XIOS should be the same, with likely an exception  if we decided to include specific sections in the output data set (sections are defined with  true model index).   
In the world of NEMO, the 1/2 degree global configuration is ORCA05.L31. For the actual purpose, we will setup eORCA05.L75 or eORCA05.L121 according to the choices retained for eORCA36. eORCA05 will have a southward extended grid just as eORCA025, eORCA12 or eORCA36.


## Building eORCA05
> **IMPORTANT:** Note that files will be created with NEMO_4.0.x paradigm (overlapping halo at E-W limit and north pole), in order to use the work 
> already done in IMHOTEP for the creation of this configuration. When files are ready, they will be retailed  to make them suitable for
> NEMO_4.2.0.

### Horizontal grid : from ORCA05 to eORCA05
We start from eORCA025 grid and figure out how ORCA05 points matches  eORCA025  points.  
We found that T point ORCA05(3,256) is located as T points eORCA025(5,697).
In the same manner, for instance, we found that U point ORCA05(3,256) = T points eORCA025(6,297), etc ..
The program [mkorca05.f90](BUILD/HGR/mkorca05.f90) was written in order to create the eORCA05 grid, 
and in particular its southern extension, using  the matching points.
After determining the location of T U V F points in the eORCA05 grid, e1 and e2 metrics was 
calculated using orthodromic distance between *ad hoc* points. Finally, we 
patch the eORCA05 grid with original ORCA05 grid north of J=79.  This program ends up creating 
the file `eORCA05_coordinates.nc`.

### Creating the eORCA05 bathymetry.
Here again we use the eORCA025 bathymetry to infer eORCA05 bathymetry, ice-shelf bathymetry and ice-shelf 
draft.  eORCA05 bathymetry is a weighted average of 9 eORCA025 neigbour points of the matching T points.  
The program [mkbathy05.f90](BUILD/HGR/mkbathy05.f90) was build for this purpose. As for the coordinates,
the eORCA05 bathymetry coming out from this process, was patched with the original ORCA05 bathymetry, 
north of J=79. This program ends up creating the `eORCA05_bathymetry_b0.2_closed_seas.nc`

### [Creating the domain_cfg file.](BUILD/DOMAIN_cfg/README.md)
In this file, the vertical grid is defined. The two actual candidates for vertical grid are either 
the standard DRAKKAR 75-levels grid or the 121-levels grid  developped and tested by Pierre Mathiot 
in an eORCA025 configuration.  As an exercize  both vertical grid will be prepared.  
Having now both the coordinates, and the bathymetry for the eORCA05 horizontal grid, we were able 
to compute the `domain_cfg.nc` file using exactly the same settings that were used for eORCA025.L75 
(see the procedure in [this document](BUILD/DOMAIN_cfg/README.md) ).  We end up with the file `eORCA05.L75_domain_cfg.nc`.  
For the 121-levels grid, namdom namelist should be changed for the new coeffcients.

### Creating the mesh_mask file. 
It is convenient to have the configuration mesh_mask file early in the configuration building process. 
The easiest way to have it is to run nemo for the initialisation part using domain_cfg file,
some namelists and xml files. The job will failed, for sure for missing initial conditions, 
but the fail arrives after the mesh_mask file is written ! A good practice for this creation is to
use a domain decomposition of 1 x jpni so that no land processors are eliminated, hence producing a 
mesh_mask file without holes.  `rebuild_nemo` program is used to recombine the global mesh_mask file.  
the [mk_mesh_mask.sh](BUILD/MESH_MASK/mk_mesh_mask.sh) script was used for this creation. 

### [Creating Initial conditions for T and S, as well as the restoring T and S and SSS restoring files.](BUILD/INITIAL_COND/README.md)
We choose the same WOA18 data set that was used for eORCA025.L75 (30 yrs climatology, 1980-2010), and 
the same `SOSIE` procedure. So, all the sosie namelist used with eORCA025.L75 were adapted to eORCA05.L75.  
The adaptation only consists in changing the name of the mesh_mask.nc file. The output files produced 
by SOSIE were reformatted to a NEMO standard, using the [mknemolike.sh](BUILD/INITIAL_COND/mknemolike.sh) 
script. This latter operation is basically  dedicated to renaming the netcdf file dimensions, and coordinates 
variables. The process ends up producing  `eORCA05.L75_81B0_WOA18_1m_votemper.nc` and `eORCA05.L75_81B0_WOA18_1m_vosaline.nc`.  
As we will use TEOS10 equation of state, potential temperatures should be transformed to conservative 
temperature (CT) and relative salinity should be transformed to absolute salinity (SA).   
This last point is achieved using [mk_teos10.sh](BUILD/INITIAL_COND/mk_teos10.sh)  script.    
Finally, Sea Surface Salinity fields are extacted from the 3D files, using [mk_sss.sh](BUILD/INITIAL_COND/mk_sss.sh)

> Many additional files are required for running a realistic simulation: Forcing files of various type, including 
> atmospheric files and associated weight files, continental fresh water input files such as  runoff files, calving 
> and iceshelves melting files. If we use geothermal heating we also need data file and respective weight file 
> for that.  Information of the chlorophyl concentration is also used for light penetration scheme associated 
> with solar radiative flux. In addition, the simulation requires specific setting files  for defining T/S 
> restoring, enhanced bottom friction, enhanced lateral friction as well as files giving an appropriate 
> information about the distance to the coast used in the SSS restoring procedure.  Following paragraphs 
> are dedicated to the building of these files.

### [Weight files:](BUILD/WEIGHT/README.md)
Weight files are used in NEMO as far as the 'interpolation on the fly (IOF)' is concerned. This procedure can be
used when input files correspond to a regular geographic grid. Resulting interpolation can be either bilinear or
bicubic. In general, bilinear interpolation is used, except for wind components where bicubic interpolation is 
preferred. If fact, the curl of the wind stress is a relevant variable in the wind forcing; using bicubic interpolation
allows to have continuous first derivative (hence the curl).   
Weight files are computed with the `WEIGHT TOOL` following [this procedure](BUILD/WEIGHT/README.md).  
This tool is using only grid information: input regular grid and output NEMO grid (likely irregular).  
The weights are used for atmospheric forcing, geothermal forcing and chlorophyl concentration used in for the light 
penetration scheme.  

### Runoff file

### Calving file

### Ice shelve melting file

### [Restoring file](BUILD/RESTORING/README.md)
Restoring file is used for 3D T/S restoring. This file gives a restoring coefficient (s-1) which is read
in the tradmp_init procedure.  
In order to create this file, see this corresponding [document](BUILD/RESTORING/README.md).

### [Bottom friction file](BUILD/BFR2D/README.md)
Bottom friction is locally boosted for limiting the flow through narrow straits, not correctly resolved by the
model grid. Bottom friction file is a mask-like file defining the places where bottom friction is boosted.  
In order to create this file, see this corresponding [document](BUILD/BFR2D/README.md).


### [Lateral friction file (AKA shlat2d files)](BUILD/SHLAT2D/README.md)
Lateral boundary conditions(typically free-slip or no-slip) are set in standard NEMO as a unique coefficient (`shlat`).
`shlat=0` define a free-slip condition (tangent velocity to the coast line doest not feel the coast), wether `shlat=2` define
a non-slip condition (tangent velocity is 0 at the coast line). In fact, `shlat` can be in the range [0-2] for partial slip
condition, and even > 2 for strong slip condition.  
DCM allows for a spatially variable `shlat`, defined in an external file, whose construction is the topic of this paragraph.  
In order to create this file, see this corresponding [document](BUILD/SHLAT2D/README.md).

### [Distance to coast file.](BUILD/DISTCOAST/README.md)
Distance to the coast file is used for SSS restoring, when using DCM and `ln_sssr_msk =.true.` in the NEMO namelist.
It is used in conjonction with namelist parameter `rn_dist` which fix the width of a stripe along the coast where the SSS
restoring will be faded out. This idea came out from the fact that SSS climatology used for restoring is a very smoothed field
where coastal current are not resolved and even less, fresh water plumes formed by river runoff. Therefore, using this feature
allows the model to build its own (narrow) coastal currents driving eventually fresher waters.   
Once said that, the building of the distcoast file should be handle with care, in particular with regard to the 
islands (small) that may be not taken into account when building the discoast file, as they may prevent SSS 
restoring in large areas of the ocean, in key regions such as the indonesian through flow (where the SSS restoring 
is crucial to balance the uncertainties on the precip in this region).   
The building of discoast file is likely an iterative process, using 
[cdfcofdis](https://github.com:meom-group/CDFTOOLS/src/cdfcofdis.f90) CDFTOOLS.  A recent improvement in this tools, allows the use of a runoff file as input file.


