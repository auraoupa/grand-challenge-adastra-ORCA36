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
We start from eORCA025 grid and figure out how ORCA05 points matches  eORCA025  points.  We found that T point ORCA05(3,256) is located as T points eORCA025(5,697).
In the same manner, for instance, we found that U point ORCA05(3,256) = T points eORCA025(6,297), etc ..
The program [mkorca05.f90](BUILD/HGR/mkorca05.f90) was written in order to create the eORCA05 grid, and in particular its southern extension, using  the matching points.
After determining the location of T U V F points in the eORCA05 grid, e1 and e2 metrics was calculated using orthodromic distance between *ad hoc* points. Finally, we 
patch the eORCA05 grid with original ORCA05 grid north of J=79.  This program ends up creating the file `eORCA05_coordinates.nc`.

### Creating the eORCA05 bathymetry.
Here again we use the eORCA025 bathymetry to infer eORCA05 bathymetry, ice-shelf bathymetry and ice-shelf draft.  eORCA05 bathymetry is a weighted average of
9 eORCA025 neigbour points of the matching T points.  The program [mkbathy05.f90](BUILD/HGR/mkbathy05.f90) was build for this purpose. As for the coordinates,
the eORCA05 bathymetry coming out from this process, was patched with the original ORCA05 bathymetry, north of J=79. This program ends up creating the `eORCA05_bathymetry_b0.2_closed_seas.nc`

### Creating the domain_cfg file.
In this file, the vertical grid is defined. The two actual candidates for vertical grid are either the standard DRAKKAR 75-levels grid or the 121-levels grid  developped and tested by Pierre Mathiot in an eORCA025 configuration.  
As an exercize (?) both vertical grid will be prepared.  
Having now both the coordinates, and the bathymetry for the eORCA05 horizontal grid, we were able to compute the `domain_cfg.nc` file using exactly the same
settings that were used for eORCA025.L75 (see the procedure in [this document](BUILD/DOMAIN_cfg/README.md) ).  We end up with the file `eORCA05.L75_domain_cfg.nc`.  
For the 121-levels grid, namdom namelist should be changed for the new coeffcients.

### Creating the mesh_mask file. 
It is convenient to have the configuration mesh_mask file early in the configuration building process. 
The easiest way to have it is to run nemo for the initialisation part using domain_cfg file,
some namelists and xml files. The job will failed, for sure for missing initial conditions, 
but the fail arrives after the mesh_mask file is written ! A good practice for this creation is to
use a domain decomposition of 1 x jpni so that no land processors are eliminated, hence producing a 
mesh_mask file without holes.  `rebuild_nemo` program is used to recombine the global mesh_mask file.  
the [mk_mesh_mask.sh](BUILD/MESH_MASK/mk_mesh_mask.sh) script was used for this creation. 

### Creating Initial conditions for T and S, as well as the restoring T and S: (Potential temperature and Relative salinity).
We choose the same WOA18 data set that was used for eORCA025.L75 (30 yrs climatology, 1980-2010), and the same `SOSIE` procedure. So, all the sosie namelist used with eORCA025.L75 were adapted to eORCA05.L75.  
The adaptation only consists in changing the name of the mesh_mask.nc file. The output files produced by SOSIE were reformatted to a NEMO standard, using the 
[mknemolike.sh](BUILD/INITIAL_COND/mknemolike.sh) script. This latter operation is basically  dedicated to renaming the netcdf file dimensions, and coordinates 
variables. The process ends up producing  `eORCA05.L75_81B0_WOA18_1m_votemper.nc` and `eORCA05.L75_81B0_WOA18_1m_vosaline.nc`.  
As we will use TEOS10 equation of state, potential temperatures should be transformed to conservative temperature (CT) and relative salinity should be transformed to absolute salinity (SA). 
This last point is achieved using [mk_teos10.sh](BUILD/INITIAL_COND/mk_teos10.sh)  script. Finally, Sea Surface Salinity fields are extacted from the 3D files, using [mk_sss.sh](BUILD/INITIAL_COND/mk_sss.sh)