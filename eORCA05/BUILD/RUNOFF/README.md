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
###  2.1 Building the runoff mask
###  2.2 Computing the runoff


## 3. Gridded runoff dataset
### 3.1 Runoff mask
### 3.2 Computing runoff
### 3.3 Tools
#### 3.3.1 Python tool
#### 3.3.2 Fortran tool in CDFTOOLS : cdfrunoff
