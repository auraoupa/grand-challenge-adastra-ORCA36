# XIOS3 sur Adastra

Adastra : Cray HPE machine 

cf [build instructions](https://github.com/hpc-uk/build-instructions/tree/main/apps/NEMO) for ARCHER machine in UK

Modules : 
```
        module purge
        module load craype-x86-genoa
        module load PrgEnv-cray
        module load cpe/23.02
        module load cray-hdf5-parallel/1.12.2.1
        module load cray-netcdf-hdf5parallel/4.9.0.1
```

Results :
```
Currently Loaded Modules:
  1) craype-x86-trento    4) DCM/4.2             7) cray-dsmml/0.2.2       10) craype/2.7.19           13) cray-hdf5-parallel/1.12.2.1
  2) libfabric/1.15.2.0   5) PrgEnv-cray/8.3.3   8) cray-libsci/22.11.1.2  11) perftools-base/22.09.0  14) cray-netcdf-hdf5parallel/4.9.0.1
  3) craype-network-ofi   6) cce/15.0.0          9) cray-mpich/8.1.21      12) cpe/22.11
```

XIOS : ``` svn co https://forge.ipsl.jussieu.fr/ioserver/svn/XIOS3/branches/xios-3.0-beta``` (Revision: 2512)
  - [arch.env](arch-Adastra_Cray.env)
  - [arch.path](arch-Adastra_Cray.path)
  - [arch.fcm](arch-Adastra_Cray.fcm)

NEMO : ```git clone https://forge.nemo-ocean.eu/nemo/nemo.git ``` (commit 389a917643f84804f6c7c6cb61c33007bc9a7b20)
  - [arch](arch-Adastra_Cray_xios3.fcm)
  - [cpp keys](cpp_WED025_TEST.fcm)

Simulation :
 - [WED025](https://zenodo.org/record/6817000#.Y065iOxBztE) test case 
 - [job](job_launch_NEMO.ksh), [mpmd](mpmd.conf), [script_nemo](exec_nemo.sh), [script_xios](exec_xios.sh)
 - fichiers xml : [context_nemo.xml], domain_def_nemo.xml, field_def_nemo-ice.xml, field_def_nemo-oce.xml, file_def_nemo-ice.xml, file_def_nemo-oce.xml, grid_def_nemo.xml, iodef.xml, 
 - outputs : [nemo error file](nemo_.err)
