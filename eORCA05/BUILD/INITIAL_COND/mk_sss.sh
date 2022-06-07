#!/bin/bash

CONFIG=eORCA05.L121
TEOS10=1

if [ $TEOS10 = 1 ] ; then
    sal=SA
    tem=CT
    sss=SSSA
else
    sal=vosaline
    tem=votemper
    sss=SSS
fi
   ncks -d deptht,1 ${CONFIG}_81B0_WOA18_1m_${sal}.nc ${CONFIG}_81B0_WOA18_1m_${sss}.nc
   # transform SSS file (with deptht dimension) into netcdf classic format:
   ncks -3 ${CONFIG}_81B0_WOA18_1m_${sss}.nc ${CONFIG}_81B0_WOA18_1m_${sss}.nc3
   # eliminate deptht dimension
   ncwa -a deptht ${CONFIG}_81B0_WOA18_1m_${sss}.nc3 ${CONFIG}_81B0_WOA18_1m_${sss}.nc1
   # transform ${sss} file with no deptht into netcdf4/HDF5 with deflation factor of 1
   ncks -4 -L1 ${CONFIG}_81B0_WOA18_1m_${sss}.nc1 ${CONFIG}_81B0_WOA18_1m_${sss}.nc4
   # Do some cleaning of intermediate files
   rm ${CONFIG}_81B0_WOA18_1m_${sss}.nc3 ${CONFIG}_81B0_WOA18_1m_${sss}.nc1
   # rename final file to its official name :
   mv ${CONFIG}_81B0_WOA18_1m_${sss}.nc4 ${CONFIG}_81B0_WOA18_1m_${sss}.nc

