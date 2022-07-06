# How to make eORCA05 run on jean zay following [JMM tuto](https://github.com/auraoupa/grand-challenge-adastra-ORCA36/tree/main/eORCA05)

## Installation on jean-zay

  - on my local machine : ```sshfs rote001@jean-zay.idris.fr:/gpfswork/rech/eee/rote001/git ssh-jean-zay-git``` (failed to make git work on jean zay, pb of ssh keys ...; assumes that ssh-jean-zay-git exists)
  - create a personnal branch : ```git checkout -b AAjeanzay main```
  - add some content on the github repo :

```
git add *
git commit -m 'add to my branch'
git push --set-upstream origin AAjeanzay
```

## Grid and bathymetry
### Compile the tools

```
cp -r /gpfswork/rech/eee/rote001/git/grand-challenge-adastra-ORCA36/eORCA05/BUILD /gpfswork/rech/cli/rote001/DEV/.
cd BUILD/HGR/
make all #Makefile already adapted to jean-zay
```

### Create the grid

```
ln -sf /gpfswork/rech/cli/rcli002/eORCA025.L75/eORCA025.L75-I/eORCA025.L75_domain_cfg_closed_seas_greenland.nc eORCA025.L75_domain_cfg.nc
ln -sf /gpfswork/rech/cli/rcli002/ORCA05/ORCA05-I/ORCA05_domain_cfg.nc .
mkorca05
```

This will produce eORCA05 coordinates, with the southern extension already present in eORCA025.

### Create the bathy

Get the eORCA025 from cal1:/mnt/meom/MODEL_SET : ```scp eORCA025.L75/eORCA025.L75-I/eORCA025_bathymetry_b0.2_closed_seas.nc rote001@jean-zay.idris.fr:/gpfswork/rech/eee/rote001/git/grand-challenge-adastra-ORCA36/eORCA05/BUILD/HGR/.```

Then on jean-zay :
```
ln -sf /gpfswork/rech/cli/rcli002/ORCA05/ORCA05-I-original/ORCA05_bathy_meter_v2.nc .
./mkbathy05
```
### Get NEMO4.2 version

 - We are downloading the latest release :
```git clone --branch 4.2.0 https://forge.nemo-ocean.eu/nemo/nemo.git nemo_4.2.0```
 - For later compilation of the tools : we add the arch_X64_JEANZAY_jm to the arch repo : ```cp /linkhome/rech/genlgg01/rcli002/CONFIGS/CONFIG_eORCA05.L121/eORCA05.L121-GD2022/arch/arch-X64_JEANZAY_jm.fcm /gpfswork/rech/cli/rote001/nemo_4.2.0/arch/CNRS/.``` and modify it so it points to JM's xios in his workdir/DEV (also be sure to have loaded hdf5/1.10.5-mpi before compiling)

### Compile REBUILD_NEMO

Will be useful for multiple things, must be accessible from anywhere :
  - compile the nemo tool : ```./maketools -m X64_JEANZAY_jm -n REBUILD_NEMO```
  - put the repo in the PATH so that executables can be accessed from anywhere : ```export PATH=/gpfswork/rech/cli/rote001/nemo_4.2.0/tools/REBUILD_NEMO:$PATH```
  - 
### Create the domain_cfg

 - We compile the domain tool in /gpfswork/rech/cli/rote001/nemo_4.2.0/tools : ```./maketools -m X64_JEANZAY_jm -n DOMAINcfg```
 - In /gpfswork/rech/cli/rote001/DEV/, I create a MAKE_DOMAIN_CFG repo and link the executables, files, namelist and script :
```
ln -sf /gpfswork/rech/cli/rote001/nemo_4.2.0/tools/DOMAINcfg/make_domain_cfg.exe .
ln -sf /gpfswork/rech/cli/rote001/DEV/BUILD/HGR/eORCA05_bathymetry_b0.2_closed_seas.nc bathy_meter.nc
ln -sf /gpfswork/rech/cli/rote001/DEV/BUILD/HGR/eORCA05_coordinates.nc coordinates.nc
cp /gpfswork/rech/eee/rote001/git/grand-challenge-adastra-ORCA36/eORCA05/BUILD/DOMAIN_cfg/jobdomaincfg .
```
 - I modify the default namelist_ref from /gpfswork/rech/cli/rote001/nemo_4.2.0/tools/DOMAINcfg with values from JMM's namelist that fits the tool from version 4.0.6 : /gpfswork/rech/eee/rote001/git/grand-challenge-adastra-ORCA36/eORCA05/BUILD/DOMAIN_cfg/namelist_cfg.L121 : it gives namelist_cfg_eORCA05.L121_v4.2
 - make a link between namelist_ref and namelist_cfg
 - I modify jobdomaincdf according to my set_up and run it : ```sbatch jobdomaincfg ```, it will produce domain_cfg_????.nc and mesh_mask_????.nc
 - Rebuild and document the domcfg file, compress and move to input :
```
rebuild_nemo -d 1 domain_cfg 20
ln -sf /gpfswork/rech/cli/rote001/nemo_4.2.0/tools/DOMAINcfg/BLD/bin/dom_doc.exe .
./dom_doc.exe -n namelist_ref -d domain_cfg.nc 
ncks -4 -L 1 --cnk_dmn nav_lev,1 domain_cfg.nc domain_cfg.nc4 (make sure to load nco :module load nco)
mv domain_cfg.nc4 /gpfswork/rech/cli/rote001/eORCA05.L121/eORCA05.L121-I/eORCA025.L121_domain_cfg_v4.2.nc
```
  - same for mesh_mask :
```
rebuild_nemo -d 1 mesh_mask 20
ncks -4 -L 1 --cnk_dmn nav_lev,1 mesh_mask.nc mesh_mask.nc4 (make sure to load nco :module load nco)
mv mesh_mask.nc4 /gpfswork/rech/cli/rote001/eORCA05.L121/eORCA05.L121-I/eORCA025.L121_mesh_mask_v4.2.nc
```







