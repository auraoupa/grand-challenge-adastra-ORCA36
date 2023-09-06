# Reboot de la production sur Adastra

## Compilation

### Modules

- dans le .bashrc :

```bash
module load PrgEnv-intel
module unload cray-libsci
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lus/home/softs/intel/oneapi/mpi/2021.6.0/libfabric/lib:/lus/home/softs/intel/oneapi/mpi/2021.6.0/lib/:/lus/home/softs/intel/oneapi/mpi/2021.6.0/lib/release/
source /lus/home/NAT/gda2307/aalbert/source.me```
```

- dans le source.me :

``` bash
 
#!/bin/bash
MY_LIB_PATH=/lus/home/NAT/gda2307/SHARED/intel-nicole

#hdf5-hdf5-1_14_0  netcdf-c-4.9.1  netcdf-fortran-4.6.0  PnetCDF-checkpoint.1.12.3

#- Setting env for HDF5
export PATH=$MY_LIB_PATH/hdf5-1.14.0/bin:$PATH
export LD_LIBRARY_PATH=$MY_LIB_PATH/hdf5-1.14.0/lib:$LD_LIBRARY_PATH
export HDF5_DIR=$MY_LIB_PATH/hdf5-1.14.0

#- Setting env for PnetCDF
export PATH=$MY_LIB_PATH/pnetcdf-1.12.3/bin:$PATH
export LD_LIBRARY_PATH=$MY_LIB_PATH/pnetcdf-1.12.3/lib:$LD_LIBRARY_PATH

##- Setting env for netCDF-C
export PATH=$MY_LIB_PATH/netcdf-c-4.9.0_parallel/bin:$PATH
export LD_LIBRARY_PATH=$MY_LIB_PATH/netcdf-c-4.9.0_parallel/lib:$LD_LIBRARY_PATH
export NETCDF_DIR=$MY_LIB_PATH/netcdf-c-4.9.0_parallel
#
##- Setting env for netCDF-Fortran
export PATH=$MY_LIB_PATH/netcdf-fortran-4.6.0_parallel/bin:$PATH
export NETCDFF_DIR=$MY_LIB_PATH/netcdf-fortran-4.6.0_parallel/
export LD_LIBRARY_PATH=$MY_LIB_PATH/netcdf-fortran-4.6.0_parallel/lib:$LD_LIBRARY_PATH
```
#### Xios

  - ```svn co http://forge.ipsl.jussieu.fr/ioserver/svn/XIOS/trunk@2430 xios-trunk-2430```
  - arch.env :  
```
module load PrgEnv-intel
module unload cray-libsci
source /lus/home/NAT/gda2307/aalbert/source.me
```
  - arch.path :
```
NETCDF_INCDIR="-I$NETCDF_DIR/include -I$NETCDFF_DIR/include"
NETCDF_LIBDIR="-L$NETCDF_DIR/lib -L$NETCDFF_DIR/lib"
NETCDF_LIB="-lnetcdf -lnetcdff"

MPI_INCDIR="-I/lus/home/softs/intel/oneapi/mpi/2021.6.0/include/"
MPI_LIBDIR="-L/lus/home/softs/intel/oneapi/mpi/2021.6.0/lib/ -L/lus/home/softs/intel/oneapi/mpi/2021.6.0/lib/release/"
MPI_LIB=""

HDF5_INCDIR="-I/lus/home/NAT/gda2307/SHARED/intel-nicole/hdf5-1.14.0/include"
HDF5_LIBDIR="-L/lus/home/NAT/gda2307/SHARED/intel-nicole/hdf5-1.14.0/lib"
HDF5_LIB="-lhdf5_hl -lhdf5 -lz"

OASIS_INCDIR=""
OASIS_LIBDIR=""
OASIS_LIB=""
```
  - arch.fcm :
```

%CCOMPILER      cc
%FCOMPILER      ftn
%LINKER         ftn

%BASE_CFLAGS    -diag-disable 1125 -diag-disable 279 -std=c++11
%PROD_CFLAGS    -O3 -D BOOST_DISABLE_ASSERTS
%DEV_CFLAGS     -g -traceback
%DEBUG_CFLAGS   -DBZ_DEBUG -g -traceback -fno-inline

%BASE_FFLAGS    -D__NONE__
%PROD_FFLAGS    -O3
%DEV_FFLAGS     -g -O2 -traceback
%DEBUG_FFLAGS   -g -traceback

%BASE_INC       -D__NONE__
%BASE_LD        -lstdc++

%CPP            cc -O0
%FPP            cpp -P
%MAKE           gmake
```

#### NEMO

  - ```git clone --branch 4.2.1 https://forge.nemo-ocean.eu/nemo/nemo.git NEMO4```
  - arch-Adastra_Intel-HPE-xios.fcm :

```
%NCDF_HOME           $NETCDF_DIR
%NCDFF_HOME           $NETCDFF_DIR
%HDF5_HOME           $HDF5_DIR
%XIOS_HOME           /lus/work/NAT/gda2307/aalbert/DEV/xios-trunk-2430-intel-hpe
%OASIS_HOME          /not/defined

%NCDF_INC            -I%NCDFF_HOME/include -I%NCDF_HOME/include -I%HDF5_HOME/include
%NCDF_LIB            -L%NCDF_HOME/lib -L%NCDFF_HOME/lib -lnetcdff -lnetcdf -L%HDF5_HOME/lib -lhdf5_hl -lhdf5
%XIOS_INC            -I%XIOS_HOME/inc
%XIOS_LIB            -L%XIOS_HOME/lib -lxios -lstdc++
%OASIS_INC
%OASIS_LIB

%CPP                 cpp
%FC                  ftn -c -cpp
%FCFLAGS             -i4 -r8 -O2 -fp-model strict -fno-alias -xHOST
%FFLAGS              %FCFLAGS
%LD                  ftn
%LDFLAGS
%FPPFLAGS            -P -traditional
%AR                  ar
%ARFLAGS             rs
%MK                  gmake
%USER_INC            %XIOS_INC %NCDF_INC
%USER_LIB            %XIOS_LIB %NCDF_LIB

%CC                  cc
%CFLAGS              -O0
```
## Run

### Maquette eORCA05

 - in ```/lus/work/NAT/gda2307/aalbert/DEV/DCM_4.2.1/DCMTOOLS/NEMOREF/NEMO4/cfgs/eORCA05.L121_AAAi001/EXP00``` : test avec état initial MP026, fichiers 4.2, forçages ERA5
 - fichiers in ```/lus/work/NAT/gda2307/aalbert/eORCA05.L121/eORCA05.L121-I``` et ```/lus/work/NAT/gda2307/aalbert/DATA_FORCING/ERA5/```
 - état initial 0MP026 construit sur Jean-Zay : ```/gpfswork/rech/cli/rote001/eORCA05.L121/eORCA05.L121-I/MKINIT-OMP026```, plots : http://ige-meom-drakkar.univ-grenoble-alpes.fr/DRAKKAR/eORCA36.L121/all_plots_init_eORCA36-MP026.png
 - fichier domain construit sur jean-zay : ```/gpfswork/rech/cli/rote001/eORCA05.L121/eORCA05.L121-I/MK_DOMAIN```
 - résumé des expériences :


| Conf | Exp | Init | Forcing | Dt | Ice cavities | Vertical levels | Ice init | Runoffs | Debug options | Result |
| -----|-----|------|---------|----|--------------|-----------------|----------|---------|---------------|--------|
|AAi001  | EXP00| MP026        | ERA5      | 1200 | Yes | 121    | from SST | ISBA AA  | None                    | ssh/sal/u -1.7977+308 at 0,0 & 193,39,38, kt=1 |
|AAi001  |EXP00b| MP026        | ERA5      | 60   | Yes | 121    | from SST | ISBA AA  | None                    |sal e+308 at 0,0 & 193,39,38, kt=1 (ssh,u ok)|
|AAi001  |EXP01 | MP026 nomask | ERA5      | 1200 | Yes | 121    | from SST | ISBA AA  | None                    | segmentation fault at kt=2 |
|AAi001d |EXP00 | MP026 nomask | ERA5      | 1200 | Yes | 121    | from SST | ISBA AA  | -g -fpe0 -CB -traceback | floating invalid in icevar.f90 |
|AAi001d |EXP01 | MP026 nomask | ERA5      | 1200 | Yes | 121    | None     | ISBA AA  | -g -fpe0 -CB -traceback | floating invalid in iceistate.f90 |
|AAi001d |EXP01 | MP026 nomask | ERA5      | 1200 | Yes | 121    | None     | ISBA AA  | -g -CB -traceback       | Subscript #3 of the array PE3 has value 0 which is less than the lower bound of 1 in isftbl.f90 |
|AAi001  |EXP02 | MP026        | ERA5      | 1200 | No  | 121    | from SST |  ISBA AA |None                     | ssh/sal/u -1.7977+308 at 0,0 & 187,79,1, kt=1 |
|AAi001  |EXP03 | WOA          | JRA55     | 1200 | Yes | 75     | from SST | ISBA AA  | None                    | kt 4 U   max   10.72     at i j k 493 487  1 MPI rank 150 |
|AAi001  |EXP03b| WOA          | JRA55     | 600  | No  | 75     | from SST | ISBA JMM | None                    | OK |
|AAi001  |EXP03c| WOA_4.2      | JRA55_4.2 | 600  | No  | 75_4.2 | from SST | ISBA JMM | None                    | OK |
|AAi001  |EXP04 | WOA_4.2      | ERA5_4.2  | 600  | No  | 75_4.2 | from SST | ISBA JMM | None                    | OK |
|AAi001  |EXP05 | WOA_4.2      | ERA5_4.2  | 600  | No  | 75_4.2 | from SST | ISBA AA  | None                    | OK |
|AAi001  |EXP06 | MP026_4.2    | ERA5_4.2  | 600  | No  | 75_4.2 | from SST | ISBA AA  | None                    | segmentation fault at kt=2 |
|AAi001d |EXP06 | MP026_4.2    | ERA5_4.2  | 600  | No  | 75_4.2 | from SST | ISBA AA  | -g  -CB -traceback      | Subscript #2 of the array RKRGB has value -2147483648 which is less than the lower bound of 1 in traqsr.f90 |
|AAi001  |EXP07 | WOA_4.2      | ERA5_4.2  | 600  | No  | 121_4.2| from SST | ISBA AA  | None                    |  |



   
   
