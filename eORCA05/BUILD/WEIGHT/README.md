# Computing weight files :

## Context:
In NEMO, 'Interpolation On the Fly (IOF)' is implemented. It allows a direct interpolation of regular input files to the
NEMO grid.  Interpolation can be either bilinear or bicubic. In order to make IOF work, weight files are required and their name
is indicated in the namelist as a field of the sw_xxx structures. This small note indicates how to build the weight files.

## Installing WEIGHT_TOOLS
When using DCM this is a very easy task. I assume that eORCA05.L121-GD2022 is an installed existing configuration, under DCM/4.0.6.  
The procedure for installing the tools is then :

  ```
  cd $UDIR/CONFIG_eORCA05.L121/eORCA05.L121-GD2022
  dcm_mktools -n WEIGHTS -m X64_JEANZAY_jm -c eORCA05.L121-GD2022
  
  ```

`dcm_mktools -h` will give you all explanations on the use of dcm_mktools. At the end of this procedure the tool is available in
$WORK/WeORCA05.L121-GD2022/tools/WEIGHTS directory.


## Computing the weight files:
In the WEIGHTS directory, `mkweight.sh` is used for that, together with a skeleton of namelist (`namelist.skel`).   
In order to make the weight files you need to have a description of the input regular grid and out the output NEMO grid. The best way is to have in WEIGHTS, a link to one regular file and a link to either a mesh_mask file or a domain_cfg file.  
### atmospheric forcing:
For the example I have :

   ```
   cd $WORK/WeORCA05.L121-GD2022/tools/WEIGHTS
   # link to regular file
   ln -sf $WORK/../commun/DATA_FORCING/JRA55/drowned/drowned_tprecip_JRA55_y1958.nc ./
   # link to NEMO grid
   ln -sf $WORK/eORCA05.L121/eORCA05.L121-I/eORCA05.L121_domain_cfg.nc ./
   ```

You need to check the name of longitudes  and latitudes in the regular file: If not `lon` and `lat`,
you must correct input_lon and input_lat in the namelist.skel. When this is fixed, running the
following script will create the weight files:

   ```
   # for bilinear weight files:
   ./mkweight.sh -c eORCA05.L121_domain_cfg.nc -M drowned_tprecip_JRA55_y1958.nc -m bilinear
   # for bicubic weight files:
   ./mkweight.sh -c eORCA05.L121_domain_cfg.nc -M drowned_tprecip_JRA55_y1958.nc -m bicubic
   ```

This will produce respectively `wght_bilinear_eORCA05.L121_domain_cfg.nc` and `wght_bicubic_eORCA05.L121_domain_cfg.nc`.  It is likely a good idea to rename this file like `wght_JRA55-eORCA05_bilin.nc` and
`wght_JRA55-eORCA05_bicub.nc`, in order to keep track of the 2 grids.

### Geothermal heating
  The same procedure is used with input data file `ghflux_v2.0.nc`. (lon lat are OK).

  ```
   ./mkweight.sh -c eORCA05.L121_domain_cfg.nc -M ghflux_v2.0.nc  -m bilinear 
   mv wght_bilinear_eORCA05.L121_domain_cfg.nc wght_ghflux_eORCA05_bilin.nc
  ```

### Chlorophyl concentration
  The same procedure is used with input data file `chlorophyl_v0.0.nc`. (lon lat are OK).

  ```
   ./mkweight.sh -c eORCA05.L121_domain_cfg.nc -M  chlorophyl_v0.0.nc -m bilinear 
   mv wght_bilinear_eORCA05.L121_domain_cfg.nc wght_chlorophyl_eORCA05_bilin.nc
  ```


