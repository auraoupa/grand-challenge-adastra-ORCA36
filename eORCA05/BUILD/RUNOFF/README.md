# Building RUNOFF for a NEMO simulation

## 1. Context:
Runoff file is used to provide the freshwater input entering the domain due to rivers.  The file
gives the amount of freshwater (kg/m2/s) for each grid cell concerned by river runoff.  In addition,
the file have a specific variable (`socoefr`) used as a mask for the grid cell affected by runoff, 
this variable taking the value 0.5 at runoff points and 0 elsewhere.  
Building this file depends on the kind of used data. Basically, existing dataset corresponds
either to time series of river discharges at rivermouth  (e.g. Dai & Trenberth) or to a gridded
product where river discharges are distributed among coastal points (e.g. ISBA, distributed on
a 1/2 degree grid).  
In both cases, there are 2 steps to perform : (1) define the NEMO points where runoff are applied 
and (2) compute the value of the runoff on selected points, according to local area.   
In the following paragraphs methods and implemetation details are described  according the the 
data set.

## 2. River runoff timeseries data set at river mouth
### 2.0 [Dai & Trenberth data set]((http://www.cgd.ucar.edu/cas/catalog/surface/dai-runoff/)
This data set is available on ige-meom-cal1.u-ga.fr at /mnt/meom/DATA_SET/RUNOFF_DAI_TRENBERTH. There are 925 stations
around the world. A text file (`coastal-stns-byVol-updated-oct2007.txt` -- need probably an update -- ) gives information
about the stations, sorted by decreasing discharge.  This files looks like :

```
  No m2s_ratio lonm   latm   area(km2) Vol(km3/yr)  nyr   yrb yre  elev(m) CT CN River_Name      OCN Station_Name
   1 12462   -51.75  -0.75  4618750.0   5389.537    79.0 1928 2006    37.0 BR SA Amazon          ATL Obidos, Bra
   2 10291    12.75  -5.75  3475000.0   1270.203    97.1 1903 2000   270.0 CD AF Congo           ATL Kinshasa, C
   3 11474   -61.75   9.25   836000.0    980.088    75.8 1923 1999 -9999.0 VE SA Orinoco         ATL Pte Angostu
   4 10374   120.75  32.25  1705383.0    905.141    99.6 1900 2000    19.0 CN AS Changjiang      PAC Datong, Chi
   5 10245    89.75  24.25   554542.0    670.943    44.3 1956 2000    19.0 BD AS Brahmaputra     IND Bahadurabad
   6 11381   -90.25  29.75  2896021.0    537.319    79.0 1928 2006    14.1 US NA Mississippi     ATL Vicksburg, 
   7 10381    83.25  70.75  2440000.0    583.768    69.3 1936 2006     2.0 RU AS Yenisey         ARC Igarka, Rus
...
```

Netcdf files give the time series of the river discharge for each station whose ID is given in the table.

###  2.1 Building the runoff mask
 This is a manual approach.  The idea is to build a file representing a map of the domain, in which each area corresponding
to a river mouth is indexed with the station ID.  The best approach is to use 
[BMGTOOLS](http://archimer.ifremer.fr/doc/00195/30646/), starting from tmaskutil field.  
The main problem with this approach is that most of the stations are not located at the river mouth but km upstream. The 
location given in the file is very likely on land in the model domain. I develop a bash script ([rnf_mk_kml.sh](https://github.com/molines/eNATL60/blob/master/TOOLS/rnf_mk_kml.sh)) that produce a KML file with the 
position of the station, so that it can be vizualized on google-earth, for instance.  Then with `BMGTOOLS` on one side and 
google-earth on the other, we manually set an area where runoff will be applied, for each river.  This is a long process 
that makes you visit the world ;). ( [More details can be read here](https://github.com/molines/ENERGETICS/blob/master/DOC/runoff_making.md), in particular for masking the river-mouth file).  
Once this runoff mask is built (a map on the model grid, with position of each rivermouth indicated with the corresponding
index), it is possible to proceed to the computation of the runoff (in kg/m2/s). Note that this process can be interactive
as rivermouth area can be increased or reduced according to the value of the runoff (very strong value over a single 
grid point, for instance may lead to unstabilities (in particular with linear free surface !). 

###  2.2 Computing the runoff
  This part is automatic. It makes the correspondance between the runoff mask designed in 2.1 and the database, taking 
into consideration the area over which the river discharge is spread.   
This is done with [rnf_compute_runoff36](https://github.com/molines/eNATL60/blob/master/TOOLS/rnf_compute_runoff36.f90) program.
   * in its actual shape, the program assume hard coded name for files :
     - river_mouth.nc
     - coastal-stns-Vol-monthly.updated-Aug2014.nc for data file
     - coordinates.nc
   * see the code for details and eventual changes !
   * This procedure produces a runoff.nc file and a screen display of the list of the rivers used in the file. In particular, on the screen output you have access to the runoff value (in mm/day, annual mean) used on each model cell for the rivers (last column): If values are in excess of 150 mm/day, we come back to rivermouth editing in order to better spread the runoff for faulty rivers.


## 3. Gridded runoff dataset
### 3.0  ISBA data set
   ISBA is  an example of gridded dataset. It was used in IMHOTEP. The data set is distributed as a large (25Gb) file,
holding 2D global river discharge (m3/s) on a regular 1/2 degree grid, for all the available years (1979-2019, presently).
This original dataset can be reduded to 1.6Gb just by using Netcdf4/Hdf5 format with chunking and deflation of 1. For
the use in NEMO it is also convenient to have this dataset splitted into yearly files. All preprocessed files are 
available on cal1 in /mnt/meom/DATA_SET/RUNOFF_ISBA/ directory.   
A daily climatology over the years 1979-2018 was built : `sfxcm6_05d_erai_gpcc_daily_rivdis_mouth_ydaymean.nc`
### 3.1 Runoff mask
In this case, all coast points are candidate for receiving runoff. All coastal point can be deternined from surface tmask:
A coastal point is an ocean point (tmask(i,j)=1) where sum (tmask(i-1:i+1,j)i) + sum ( tmask(i,j-1:j+1) ) = 5. A specific
cdftools ([`cdfcoast`](https://github.com/meom-group/CDFTOOLS/blob/master/src/cdfcoast.f90)) have been written for this purpose, although the algorithm is used directly in the computing tool.  
To be noted that at these stage, all coastal point are candidate for receiving runoff, but only those near enough from an
ISBA river discharge cell will be affected.
### 3.2 Computing runoff
The algorithm for mapping ISBA on NEMO is as follow: 
  * Scan all ISBA river discharge points in the ISBA file
  * Look for the nearest NEMO point, belonging to the coastal candidates.
  * If the neareast point is within a threshold distance, then the ISBA river discharge is affected to the NEMO point,
taking the area of the cell into consideration.  Note that in ISBA, there are some runoff going to the Caspian sea or other
inland pieces of water. Choosing a threshold distance of 300 km seems OK for eORCA05, and get rid of the inland points. 
### 3.3 Tools
#### 3.3.1 Python tool
   A [python tool](./build_ORCA05_runoff_fromISBA.py) , written by Julien Jouano performs the described 
algorithm and was used for IMHOTEP preparation. However this tool is quite slow as it takes a couple of
hours for producing 1 year of daily runoff. The tool was ported to fortran for optimization. See below.

#### 3.3.2 Fortran tool in CDFTOOLS : cdfrunoff
   [`cdfrunoff`](https://github.com/meom-group/CDFTOOLS/blob/master/src/cdfrunoff.f90) was developped 
in the frame of CDFTOOLS. It just implements the computing algorithm. Optimisation was done
in order to compute NEMO runoff points position only once. Using a 1d vector for these points, considerably reduced the
memory imprint.  `cdfrunoff` proceed with 1 year of daily runoff in 15 seconds (instead of more than 2h... with the 
python tool); of course same optimisation can probably be back-ported to the python tool.

```text
  usage : cdfrunoff -r RNF-file -f MASK-file [-v MASK-var] [-nc4] 
          [-vr RNF-var] [-radius RADIUS]  [-o OUT-file] 
       
      PURPOSE :
        This program is used to create a NEMO runoff file from a gridded
        runoff data set (such as ISBA). We assume the runoff units in the
        imput file is m3/s (like ISBA).
       
      ARGUMENTS :
        -r RNF-file  : name of the gridded runoff  file 
        -f MASK-file  : name of the mask file 
       
       OPTIONS : 
        -v MASK-var : input netcdf mask variable. [tmask] 
        -vr RNF-var : input netcdf runoff variable.[rivdis] 
        -nc4 : use netcdf4/Hdf5 chunking and deflation.
        -o OUT-file     : name of coastal_mask file.[runoff.nc]
        -radius RADIUS  : Distance threshold for runoff distribution on NEMO
                (km)  [   300.000000000000      ].
       
      REQUIRED FILES :
         mesh_hgr.nc
       
      OUTPUT : 
        runoff.nc file unless -o option is used.
        Variables : sorunoff, socoefr
```

