#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=32
#SBATCH -J weights_era5
#SBATCH -e weights_era5.e%j
#SBATCH -o weights_era5.o%j
#SBATCH -A gda2307
#SBATCH --time=0:10:00
#SBATCH --constraint=GENOA
#SBATCH --exclusive

EXE_PATH=/lus/work/NAT/gda2307/aalbert/DEV/NEMO4_trunkXIOS3/tools/WEIGHTS

rm -f remap_*.nc data_nemo_*.nc weight_*.nc weight*.nc

${EXE_PATH}/scripgrid.exe namelist_bilin
${EXE_PATH}/scrip.exe namelist_bilin
${EXE_PATH}/scripshape.exe namelist_bilin

${EXE_PATH}/scripgrid.exe namelist_bicub
${EXE_PATH}/scrip.exe namelist_bicub
${EXE_PATH}/scripshape.exe namelist_bicub
