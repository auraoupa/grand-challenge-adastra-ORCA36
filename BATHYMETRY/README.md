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
for the ocean, except for Antartica and Greenland where the Bedmachine-antartica (             ) and Bedmachine-greenland
are prefered, allowing a consistent ice draft for under ice-shelf cavities.  
High resolution coastline definition is also needed to setup an accurate land-sea mask. Coastline from Open Street Map are
available as shapefile. This kind of file can be processed by Geographic Information Sytem (for exampke QGIS program, 
see below). 
## 3. Suspected flaws 
  Two major flaws are observed on GEBCO_2022 dataset, when comparing with accurate coastline
  *  Some areas considered as ocean in the dataset are  in fact on land.
  *  Some areas considered as land in the dataset are in fact in the ocean.

  (give examples)
## 4. Proposed procedure for dataset correction.
### 4.1 Use of QGIS 
### 4.2 Masking original dataset with coastline mask
### 4.3 Building a mask for suspicious land points
### 4.4 Drowning suspicious land points 
### 4.5 Apply flood filling algorithm for keeping only ocean points

## ANNEX : [BATHYTOOLS](https://github.com/molines/BATHY_TOOLS)
