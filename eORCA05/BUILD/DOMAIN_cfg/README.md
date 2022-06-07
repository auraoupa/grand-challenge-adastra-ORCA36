# Building domain_cfg file

## 1. Context
Since NEMO4, all the parameters concerning the computational grid of a configuration (horizontal **and** vertical) are read from a `domain_cfg`file. In previous
NEMO version, only the horizontal part was externalized (in coordinates.nc file). The bathymetry was read from a file, and the vertical grid was built during
NEMO initialisation, taking relevant information from the namelist.  In NEMO4, the construction of the vertical grid is done off-line with the help of a NEMO tool
called DOMAIN_cfg, taking the grid information from a NEMO_3.6 like namelist. In particular, the coefficient for the vertical grid (in namdom) should be carefully set,
including parameters for the partial cells definition.  The drawback of this new procedure is that any change in bathymetry implies a rebuild of the domain_cfg file.
The advantage is in the simplification of the NEMO code where configuration related information is read in an input file.  Therefore, this file hold key information
for a configuration, and the building of this file must be carefully documented, for tracability.  A DRAKKAR improvement, is the inclusion of the used namelist, 
together with the name of all input files (bathymetry, coordinates) in the domain_cfg file.

I assume that a eORCA05.L121-GD2022 is already installed **(NEMO 4.0.6)**.  Documentation is done here for the 121 level configuration. For L75, it is already done
and it is exactly the same processus, taking care of the namelist for 75 levels.

## 2. Step by step
  1. Getting the DOMAIN_cfg tool ready

  ```
  cd $UDIR/CONFIG_eORCA05.L121/eORCA05.L121-GD2022/
  dcm_mktools -n DOMAIN_cfg -m X64_JEANZAY_jm  -c eORCA05.L121-GD2022
  ```
 
 The tool is ready to be used in `$WORKDIR/WORCA05.L121-GD2022/tools/DOMAIN_cfg` directory.  
For easy use I create a copy of this directory on $WORK/DOMAINcfg-eORCA05.L121

 2. Work in `$WORK/DOMAINcfg-eORCA05.L121`  
   2.1 get usefull files

    ```
    cd $WORK/DOMAINcfg-eORCA05.L121
    cp $WORK/eORCA05.L75/eORCA05.L75-I/eORCA05_bathymetry_b0.2_closed_seas.nc ./
    cp $WORK/eORCA05.L75/eORCA05.L75-I/eORCA05_coordinates.nc ./

    # file name for bathy and coordinates are hard coded in make_domain_cfg.exe...
    ln -sf eORCA05_bathymetry_b0.2_closed_seas.nc bathy_meter.nc
    ln -sf eORCA05_coordinates.nc coordinates.nc

    # get the namelists
    cp $DEVGIT/grand-challenge-adastra-ORCA36/eORCA05/BUILD/DOMAIN_cfg/namelist_cfg.L121 ./
    ln -sf namelist_cfg.L121 namelist_cfg

    # get the template of the job
    cp  $DEVGIT/grand-challenge-adastra-ORCA36/eORCA05/BUILD/DOMAIN_cfg/jobdomaincfg ./
    ```

 3. Edit the `jobdomaincfg` file to the machine you are using
  This concerns the header of the batch script, and the number of core you are using.
  Note that the `nammpp` block of the `namelist_cfg` should be coherent with the number of core asked for,
adjusting `jpni, jpnj` and `jpnij`.
> Tip : it is a good practice at this step to use jpni=1 in order to use zonal stripes. The output of the
> tool will be a bunch of jpnj files without missing land proc, hence the rebuild file will be continuous.  

   Submit the batch.  
    
 4. Rebuild the domain_cfg file in a single piece using rebuild_nemo tool.

   ```
   rebuild_nemo -d 1 domain_cfg <jpnj>
   ```

 5. Document the new domain_cfg file :

   ```
   ./dcmtk_dom_doc.exe  -b eORCA05_bathymetry_b0.2_closed_seas.n -c eORCA05_coordinates.nc  -n namelist_cfg -d domain_cfg.nc
   ```

 7. Move the final file to the `eORCA025.L121-I` directory:

   ```
   mv domain_cfg.nc $WORK/eORCA05.L121/eORCA05.L121-I/eORCA025.L121_domain_cfg.nc
   ```

 8. **YOU ARE DONE !**

