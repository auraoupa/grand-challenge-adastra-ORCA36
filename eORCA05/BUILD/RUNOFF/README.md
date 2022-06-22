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
### 2.0 Dai & Trenberth data set
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

Netcdf files give the time series of the river discharche for each station whose ID is given in the table.

###  2.1 Building the runoff mask
 This is a manual approach.  The idea is to build a file representing a map of the domain, in which each area corresponding 
to a river mouth is indexed with the station ID.  The best approach is to use BMGTOOLS, starting from tmaskutil field.  
The main problem with this approach is that most of the stations are not located at the river mouth but km upstream. The 
location given in the file is very likely on land in the model domain. I develop a tool that produce a KML file with the 
position of the station, so that it can be vizualized on google-earth, for instance.  Then with BMGTOOLS on one side and 
google-earth on the other, we manually set an area where runoff will be applied, for each river.  This is a long process 
that makes you visit the world ;).  
Once this runoff mask is built (a map on the model grid, with position of each rivermouth indicated with the corresponding
index), it is possible to proceed to the computation of the runoff (in kg/m2/s). Note that this process can be interactive
as rivermouth area can be increased or reduced according to the value of the runoff (very strong value over a single 
grod point, for instance may lead to unstabilities (in particular with linear free surface !). 

###  2.2 Computing the runoff
  This part is automatic. It makes the correspondance between the runoff mask designed in 2.1 and the database, taking 
into consideration the area over which the river discharge is spread. 


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
A coastal point is an ocean point (tmask(i,j)=1) where summ (tmask(i-1:i+1,j)i) + sum ( tmask(i,j-1:j+1) ) = 5. A specific
cdftools (cdfcoast) have been written for this purpose, although the algorithm is used directly in the computing tool.  
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
   A python tool, written by Julien Jouano performs the described algorithm and was used for IMHOTEP preparation. However
this tool is quite slow as it takes a couple of  hours for producing 1 year of daily runoff. The tool was ported to
fortran for optimization. See below.
#### 3.3.2 Fortran tool in CDFTOOLS : cdfrunoff
   `cdfrunoff` was developped in the frame of CDFTOOLS. It just implement the computing algorithm. Optimisation was done
in order to compute NEMO runoff points position only once. Using a 1d vector for these points, considerably reduced the
memory imprint.  `cdfrunoff` proceed with 1 year of daily runoff in 15 seconds (instead of more than 2h... with the 
python tool); of course same optimisation can probably back ported to the python tool.
