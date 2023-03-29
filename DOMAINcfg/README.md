# DOMAINcfg file
## 1. Context
For NEMO, this file defines all the relevant parameters of the horizontal and vertical computing grid. It is also used for the preparation of input data such as initial conditions, runoff etc... Building this file is therefore the first step to proceed for setting up a configuration. In particular, choices about the vertical coordinates ( z, s, partial steps), must be done previous to the building of this file. 
## 2. DOMAINcfg tool
For this project, including the modelisation of under iceshelf circulation, we pay a particular
attention to the definition of the vertical grid below the iceshelf.  We use a
[specific version](SOURCES/DOMAINcfgPM)  of the DOMAINcfg tools (developped by Pierre Mathiot),
which is not yet publicly released.  
For the compilation of the tools, it is recommended to use the `maketools` available for NEMO 4.2.0 release, otherwise compilation may fails, with unclear problems in Fcm.
## 3. Making DOMAINcfg for eORCA36-L121
### 3.1 required files
Once DOMAINcfgPM tool is compiled (*ie* `make_domain_cfg.exe` available), the required files are:
  * a coordinate file for the horizontal grid : `eORCA_R36_coordinates_v3.3_nemo4.0.x.noz.nc`
  * a bathymetric file created in the BUILD_BATHY (long) process : `eORCA_R36_Bathymetry_v4.0.3_40km.nc`
  * a namelist for the input parameters of `make_domain_cfg.exe` : [namelist_dom.eORCA36.L121-MAA2023](NAMELIST/namelist_dom.eORCA36.L121-MAA2023). Note that this namelist should be thoroughly edited to fit the wishes decided for the model grid.
### 3.2 Running  `make_domain_cfg.exe`
 This program is a parallel program that should be run acordingly. For eORCA36, on Jean-Zay, we made a first try with 400 cores and we had an `out of memory` error. Going to 800 cores was OK. For reference we use the following script, in a directory where required files are available:

```
#!/bin/bash
#SBATCH --nodes=20
#SBATCH --ntasks=800
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --hint=nomultithread
#SBATCH -J JOB_DOMAIN
#SBATCH -e zjobdomain.e%j
#SBATCH -o zjobdomain.o%j
#SBATCH --time=2:00:00
#SBATCH --exclusive
```

cd /gpfswork/rech/cli/rcli002/eORCA36-L121/eORCA36-L121-I/BUILD_DOMAIN_cfg

srun -n 800 ./make_domain_cfg.exe

### 3.3 Recombining a global file
The previous step produces 800 subdomain file that should be recombined to form the final domain_cfg
file. Note that in order to avoid "holes" in the recombined file, we choose a domain decomposition of 2x400, so that no land only domain were detected.  
The recombination is achieved with the standard NEMO tool `REBUILD_NEMO`, submitted with the following batch file :

```
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH -A cli@cpu
#SBATCH -J JOB_
#SBATCH -e zjob.e%j
#SBATCH -o zjob.o%j
#SBATCH --time=2:00:00
#SBATCH --exclusive

cd /gpfswork/rech/cli/rcli002/eORCA36-L121/eORCA36-L121-I/BUILD_DOMAIN_cfg

rebuild_nemo -d 1 -x 2000 -y 2000 -z 1 -t 1   domain_cfg 800

```
 Note that it is necessary to compile the rebuild tool with key_netcdf4 defined. And we took this
opportunity to force deflation and chunking for the output file (which at the end weights 21Gb).



