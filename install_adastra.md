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
backup : ```svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk@2430 xios-trunk-2430```

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

### Compilation NEMO

#### Download

```bash
commit=389a917643f84804f6c7c6cb61c33007bc9a7b20
git clone https://forge.nemo-ocean.eu/nemo/nemo.git NEMO4
cd NEMO4
git checkout $commit
```

#### Arch file

  - arch-X64_ADASTRA-Cray_xios3.fcm :
 
```bash
%NCDF_HOME           $NETCDF_DIR
%HDF5_HOME           $HDF5_DIR
%XIOS_HOME           /lus/work/CT1/ige2071/aalbert/DEV/xios-3.0-beta

%NCDF_INC            -I%NCDF_HOME/include -I%HDF5_HOME/include
%NCDF_LIB            -L%HDF5_HOME/lib -L%NCDF_HOME/lib -lnetcdff -lnetcdf -lhdf5_hl -lhdf5 -lz
%XIOS_INC            -I%XIOS_HOME/inc
%XIOS_LIB            -L%XIOS_HOME/lib -lxios

%CPP                 cpp -Dkey_nosignedzero
%FC                  ftn
%FCFLAGS             -em -s integer32 -s real64 -O0 -hflex_mp=intolerant -N1023
%FFLAGS              -em -s integer32 -s real64 -O0 -hflex_mp=intolerant -N1023
%LD                  CC -Wl,"--allow-multiple-definition"
%FPPFLAGS            -P -traditional
%LDFLAGS             -lmpifort_cray
%AR                  ar
%ARFLAGS             -r
%MK                  gmake
%USER_INC            %XIOS_INC %NCDF_INC
%USER_LIB            %XIOS_LIB %NCDF_LIB

%CC                  cc -Wl,"--allow-multiple-definition"
%CFLAGS              -O0 -Wl,"--allow-multiple-definition"
bld::tool::fc_modsearch -J

```

#### Compile

 - add ```key_xios3``` and ```key_vco_1d3d``` in CPP.keys of WED025_TEST test case 

```bash
./makenemo -n WED025_TEST -r WED025 -m X64_ADASTRA-Cray-xios3 -j 1 
```
