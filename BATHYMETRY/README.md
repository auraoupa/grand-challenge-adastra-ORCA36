# eORCA36 bathymetry
## 1. Introduction
  Bathymetry is a fundamental input data for ocean modelling. After the grid definition, it is the first data to 
set up. It gives the depth of the ocean at each grid point, and defines the model coast-line.  Many other input data
lays on the bathymetry and coast line.  Because of this dependency, it is of primarily importance to set up the most
accurate bathymetry. For high resolution model it is quite a bit of challenge.  
In this repository, the procedure for  building a high resolution bathymetry is described.
## 2. Available dataset at high resolution
There are many available dataset for bathymetry. Year after year  dataset are improved and corrected. For eORCA36
bathymetry, we choose to use GEBCO_2022 ([GEBCO]( https://www.gebco.net/data_and_products/gridded_bathymetry_data/))
for the ocean, except for Antartica and Greenland where the Bedmachine-antarctica version3 
([Morlighem, M. et al 2022a](https://doi.org/10.5067/FPSU0V1MWUB6)) and 
Bedmachine-greenland version 5 ([Morlighem, M. et al 2022b](https://doi.org/10.5067/GMEVBWFLWA7X))
are prefered, allowing a consistent ice draft for under ice-shelf cavities.  
High resolution coastline definition is also needed to setup an accurate land-sea mask. Coastline from Open Street Map are
available as shapefile. This kind of file can be processed by Geographic Information System (for exampke QGIS program, 
see below). 
### 2.1  Construction of the icedraft field
Ice draft is the depth of the iceshelf ice-ocean interface, relative to the sea surface. In BedMachine product, available fields are : surface ( the height of the surface at atmosphere limit), bed ( the deptht of the  bed *ie* the bathymetry in the ocean, the depth of the 'bedrock' where the area in ice covered, and ice thickness (ie the tickness of the iceshelf).  Ice draft can therefore be computed from these fields. : 

icedraft =  (surface - thickness ) on the ocean  
icedraft =  bed  elsewhere  

A dedicated BATHY_TOOL program ( [bedmachine_idraft](https://github.com/molines/BATHY_TOOLS/blob/master/bedmachine_idraft.f90) was written for this purpose.
### 2.2. Suspected flaws in GEBCO_2022
  Two major flaws are observed on GEBCO_2022 dataset, when comparing with accurate coastline
  *  Some areas considered as ocean in the dataset are  in fact on land.
  *  Some areas considered as land in the dataset are in fact in the ocean.

  (give examples)
### 2.3 Proposed procedure for dataset correction (GEBCO_2022)
#### 2.3.1 Use of QGIS 
At this step, a geotiff GEBCO_2022 can be loaded in QGIS. The OSM coastline is loaded as a shape file and  it is easy to understand or to vizualize the flaws mentioned above. QGIS also offer the possibility to create a coastline mask at the resolution of the background
geotiff file (GEBCO_2022, 15" resolution), from the OSM coastline considered as a series of polygons which are filled. 
The resulting file is a netcdf file (`OSM_land_to_gebco.nc`. For reference I copy-paste the gdal command that was issued for the
creation of the mask file:

```
OSM_DIR=<YOUR_DIRECTORY_WITH_OSM_FILE> 
gdal_rasterize -l land_polygons -burn 1.0 -ts 86400.0 43200.0 -init -1.0 -a_nodata 1.0 -te -180.0 -90.0 180.0 90.0 -ot Int32 -of GTiff $OSM_DIR/land_polygons.shp $OSM_DIR/OSM_land_to_gebco.tif
gdal_translate -of NetCDF $OSM_DIR/OSM_land_to_gebco.tif $OSM_DIR/OSM_land_to_gebco.nc

```

#### 2.3.2 Masking original dataset with coastline mask
Dedicated programs were created for managing GEBCO type grids [BATHY-TOOLS on github](https://github.com/molines/BATHY_TOOLS). This huge grid (86400 x 43200) is not easy to vizualise with standard tools like `ncview`, and  the BATHY_TOOLS [gebco_xtrac](https://github.com/molines/BATHY_TOOLS/blob/master/gebco_xtrac.f90) program allows to work with smaller subset, as well as global. In addition, this program has many other funcionalities, in particular the capability  
to apply a mask on the original data. This was done for GEBCO_2022 file using the coastline mask. At this step, the resulting file
is in agreement with the OSM coastlines, but still some inland lakes of marsh zones of any kind remain, in general not connected with
the open ocean.
#### 2.3.3 Building a mask for suspicious land points
The masked GEBCO file also exibit suspicious features such as positive elevation (land) where OSM indicates oceanic waters. Many of these suspicious points were verified, having a look at google-earth images: the OSM mask was never faulty. Therefore we create a mask 
file in order to keep a map of these abnormal points.  Trying to understand why those points appears, it seems that these features comes from the mapping algorithm used in GEBCO that may produce local extrema where there is a lack of data, in region of strong gradients. It is very likely that the abnormal points detected at this step are only a fraction of all the anomalies (most of them staying in the ocean). In addition, we also visually detected suspicious very deep points close to shallow areas, which probably come from the same local extrema problem. Unfortunatly, we did not find a solution for correcting these.
#### 2.3.4 Drowning suspicious land points 
Using the mask for suspicious points, as decribed in the previous paragraph, we decided to  replace the suspicious points with an extension of the neighbouring oceanic points. This procedure (internaly called 'drowning') was achieved with `mask_drown.x` program, from the [SOSIE package](https://github.com/brodeau/sosie). Keeping in mind the comments of the previous paragraph, after this step, the resulting file is corrected from the visible anomalies, in quite an acceptable way.
#### 2.3.5 Apply flood filling algorithm for keeping only ocean points
Last step in the preparation of a corrected GEBCO_2022 file is  to eliminate  points that are not connected to the world ocean. This is another capability of the  [gebco_xtrac](https://github.com/molines/BATHY_TOOLS/blob/master/gebco_xtrac.f90) program. An initial seed is given in the ocean and all points that can be reached by a direct pathway (*ie* with grid cell side connexion) are kept, the other are transformed to land point ( bathymetry = 0 ). Note that this procedure eliminate in land closed seas or large lake (*ie* Caspian Sea, Great US lakes etc...) that in fact are of interest for coupled simulation with the atmosphere. For the purpose of eORCA36 great challenge, it is not an issue. Resulting corrected file is called `GEBCO_JM_2022_flooded.nc` and is available on `cal1:/mnt/meom/DATA_SET/BATHYMETRY/`.

## 3. Building the eORCA36 bathymetry
At this level we started from the modified  `GEBCO_JM_2022_flooded.nc` file. Use of data from BedMachine will come later.  
### 3.1 First guess of eORCA36 bathymetry:
#### 3.1.1 : interpolation with baty_interp
The main tool for bathymetric projection on the eORCA36 grid is the [NEMOBAT](https://github.com/molines/NEMOBAT) package that should
be installed and compiled before use. In particular [bathy_interp](https://github.com/molines/NEMOBAT/blob/master/INTERP0/batinterp.F90) will produce a first guess of the bathymetry, taking its parameters from an [input namelist](NAMELIST/namelist_gebco). The main algorithm of `bathy_interp` is as follows: for each eORCA36 grid cell (as described in the coordinates file passed in the namelist, the GEBCO points falling into the grid cell are identified, and sorted. The median value or the mean value is kept as the bathymetry for this grid cell. We traditionally keep the median (although the rationale is unclear with recent data bases). At this level, grid cell for which no GEBCO data were available are marked with a flag value (-9999.99). This procedure is very cpu-time consuming (about 40 hours on jean-zay) and memory consuming (a full node of 40 cores was used on jean-Zay).

Important to note that in the actual building of eORCA36 bathymetry, we performed this step using the eORCA36 coordinate file ready for NEMO 4.2 (with no halos). The output fro; NEMOBAT is masked on the rim, thus there were missing data on the E-W periodic line and at the north-fold area of the ORCA grid. Some additional tasked were necessary to fix this point (see later).
#### 3.1.2 : dealing with missing values
Indeed, due to the very hig resolution of the eORCA36 grid at southern most latitudes, there are many grid cells with flag values. Therefore, at this level the model bathymetry 
presents 3 kind of values : 0 on land, -9999.99 on missing points and positive values corresponding to depth in meters at ocean grid points.  Note that for Bathymetry, we set
the `missing_value` netcdf attribute to -9999.99 in order to ease the drowning task.

Fixing the missing points was performed using again the `mask_drown` tool of [SOSIE package](https://github.com/brodeau/sosie). It gaves satisfactory results.

```
mask_drown -D -i bathy_in.nc -m 0 -x nav_lon -y nav_lev -v Bathymetry -o bathy_out.nc
```
#### 3.1.3 : manual checking  of the first guess
This step is based on [BMGTOOLS](https://archimer.ifremer.fr/doc/00195/30646/) that allows an easy comparision of the data in the bathymetry with a very high resolution of the coast line. It is easy, but very time consuming task (manual). In particular, resolving small features such as fjords along the coast of Nordic countries or Patagonia is critical.

The global file is too big to be easily managed by BMGtools. Therefore, the global file is splitted into 100 (10x 10) subdomains (as weel as the corresponding coordinate file), and each of the 100 files is visited for control. Once each subdomain is checked, a global corrected file is produced. (The tool for splitting and merging is [splitfile2](https://github.com/molines/JMMTOOLS/blob/master/TOOLS/splitfile2.f90) )

At this stage we correct almost all the coastline except for Antarctica and Greenland that will be processed with BedMachine data.

Result of this step is the bathymetric file called: `eORCA36_GEBCO_2022_PM-JMM_bathy_v2_4.2.nc` (note: on NEMO_4.2 type of coordinate file !!! )

### 3.2 Adding Antarctica Bathymetry, under iceshelf bathymetry and icedraft
### 3.3 Adding Greenland  Bathymetry, under iceshelf bathymetry and icedraft
### 3.4 Dealing with E-W periodicity 
### 3.5 Dealing with north fold region
### 3.6 Building the final bathymetry
#### 3.6.1 solving the puzzle !
#### 3.6.2 Manual check of the greenland coastline
#### 3.6.3 Manual check of critical depth : *eg:* Romanche Fracture zone, Gibbs Fracture zone, Vema Channel, etc...
#### 3.6.4 Elimination of too small iceshelves
#### 3.6.5 Final build !


## ANNEX : 
  * [BATHYTOOLS](https://github.com/molines/BATHY_TOOLS)
  * ncdump of coasline mask file:


```
ncdump -h OSM_land_to_gebco.nc
netcdf OSM_land_to_gebco {
dimensions:
	lon = 86400 ;
	lat = 43200 ;
variables:
	char crs ;
		crs:grid_mapping_name = "latitude_longitude" ;
		crs:long_name = "CRS definition" ;
		crs:longitude_of_prime_meridian = 0. ;
		crs:semi_major_axis = 6378137. ;
		crs:inverse_flattening = 298.257223563 ;
		crs:spatial_ref = "GEOGCS[\"WGS 84\",DATUM[\"WGS_1984\",SPHEROID[\"WGS 84\",6378137,298.257223563,AUTHORITY[\"EPSG\",\"7030\"]],AUTHORITY[\"EPSG\",\"6326\"]],PRIMEM[\"Greenwich\",0],UNIT[\"degree\",0.0174532925199433,AUTHORITY[\"EPSG\",\"9122\"]],AXIS[\"Latitude\",NORTH],AXIS[\"Longitude\",EAST],AUTHORITY[\"EPSG\",\"4326\"]]" ;
		crs:GeoTransform = "-180 0.004166666666666667 0 90 0 -0.004166666666666667 " ;
	double lat(lat) ;
		lat:standard_name = "latitude" ;
		lat:long_name = "latitude" ;
		lat:units = "degrees_north" ;
	double lon(lon) ;
		lon:standard_name = "longitude" ;
		lon:long_name = "longitude" ;
		lon:units = "degrees_east" ;
	int Band1(lat, lon) ;
		Band1:long_name = "GDAL Band Number 1" ;
		Band1:_FillValue = 1 ;
		Band1:grid_mapping = "crs" ;

// global attributes:
		:GDAL_AREA_OR_POINT = "Area" ;
		:Conventions = "CF-1.5" ;
		:GDAL = "GDAL 3.3.2, released 2021/09/01" ;
		:history = "Wed Jan 11 21:58:08 2023: GDAL CreateCopy( OSM_land_to_gebco.nc, ... )" ;
```

## REFERENCES:
Morlighem, M. (2022a). MEaSUREs BedMachine Antarctica, Version 3 [Data Set]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. https://doi.org/10.5067/FPSU0V1MWUB6. Date Accessed 01-11-2023.

Morlighem, M., E. Rignot, T. Binder, D. D. Blankenship, R. Drews, G. Eagles, O. Eisen, F. Ferraccioli, R. Forsberg, P. Fretwell, V. Goel, J. S. Greenbaum, H. Gudmundsson, J. Guo, V. Helm, C. Hofstede, I. Howat, A. Humbert, W. Jokat, N. B. Karlsson, W. Lee, K. Matsuoka, R. Millan, J. Mouginot, J. Paden, F. Pattyn, J. L. Roberts, S. Rosier, A. Ruppel, H. Seroussi, E. C. Smith, D. Steinhage, B. Sun, M. R. van den Broeke, T. van Ommen, M. van Wessem, and D. A. Young. 2020. Deep glacial troughs and stabilizing ridges unveiled beneath the margins of the Antarctic ice sheet. Nature Geoscience. 13. DOI: 10.1038/s41561-019-0510-8.

Morlighem, M. et al. (2022b). IceBridge BedMachine Greenland, Version 5 [Data Set]. Boulder, Colorado USA. NASA National Snow and Ice Data Center Distributed Active Archive Center. https://doi.org/10.5067/GMEVBWFLWA7X. Date Accessed 01-11-2023.

Morlighem, M., C. Williams, E. Rignot, L. An, J. E. Arndt, J. Bamber, G. Catania, N. Chauché, J. A. Dowdeswell, B. Dorscheel, I. Fenty, K. Hogan, I. Howat, A. Hubbard, M. Jakobsson, T. M. Jordan, K. K. Kjeldsen, R. Millan, L. Mayer, J. Mouginot, B. Noel, C. O Cofaigh, S. J. Palmer, S. Rysgaard, H. Seroussi, M. J. Siegert, P. Slabon, F. Straneo, M. R. van den Broeke, W. Weinrebe, M. Wood, and K. Zinglersen. 2017. BedMachine v3: Complete bed topography and ocean bathymetry mapping of Greenland from multi-beam echo sounding combined with mass conservation. Geophysical Research Letters. 44. DOI: 10.1002/2017GL074954.

GEBCO Compilation Group (2022) GEBCO 2022 Grid (doi:1:0.5285/e0f0bb80-ab44-2739-e053-6c86abc0289c)
