# Installation sur Adastra

Avec les compilateurs natifs Cray et en s'inpirant du travail de Adam Blaker et Andrew Coward : https://github.com/hpc-uk/build-instructions/blob/main/apps/NEMO/

## Les modules

```bash
module load cpe/22.11
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1
```

### Compilation xios

```bash
svn co https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/branches/xios-3.0-beta 
```
