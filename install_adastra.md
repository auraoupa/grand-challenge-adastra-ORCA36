# Installation sur Adastra

Avec les compilateurs natifs Cray et en s'inpirant du travail de Adam Blaker et Andrew Coward : https://github.com/hpc-uk/build-instructions/blob/main/apps/NEMO/

## Les modules

```bash
module load cpe/22.11
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1
```

### Compilation xios

#### Download xios

```bash
svn co https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/branches/xios-3.0-beta 
```

#### Arch files

- arch-Cray_Adastra.env :

```bash
module load cpe/22.11
module load cray-hdf5-parallel/1.12.2.1
module load cray-netcdf-hdf5parallel/4.9.0.1
```

- arch-Cray_Adastra.fcm :

```bash
%CCOMPILER      CC
%FCOMPILER      ftn
%LINKER         ftn

%BASE_CFLAGS
%PROD_CFLAGS    -O3 -D BOOST_DISABLE_ASSERTS
%DEV_CFLAGS     -g -traceback
%DEBUG_CFLAGS   -DBZ_DEBUG -g -traceback -fno-inline

%BASE_FFLAGS    -D__NONE__
%PROD_FFLAGS    -O3
%DEV_FFLAGS     -g -O2 -traceback
%DEBUG_FFLAGS   -g -traceback

%BASE_INC       -D__NONE__
%BASE_LD        -lstdc++

%CPP            cpp -EP
%FPP            cpp -P
%MAKE           gmake
```

- arch-Cray_Adastra.path :

```bash
NETCDF_INCDIR="-I${NETCDF_DIR}/include"
NETCDF_LIBDIR="-L${NETCDF_DIR}/lib"
NETCDF_LIB="-lnetcdf -lnetcdff"

MPI_INCDIR=""
MPI_LIBDIR=""
MPI_LIB=""

HDF5_INCDIR="-I${HDF5_DIR}/include"
HDF5_LIBDIR="-L${HDF5_DIR}/lib"
HDF5_LIB="-lhdf5_hl -lhdf5 -lz -lcurl"

OASIS_INCDIR=""
OASIS_LIBDIR=""
OASIS_LIB=""
```

#### Compile

```bash
./make_xios --full --arch Cray_Adastra
```
