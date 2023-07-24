#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=32
#SBATCH -J interp_era5
#SBATCH -e interp_era5.e%j
#SBATCH -o interp_era5.o%j
#SBATCH -A gda2307
#SBATCH --time=1:10:00
#SBATCH --constraint=GENOA
#SBATCH --exclusive

EXE_PATH=/lus/work/NAT/gda2307/aalbert/DEV/NEMO4_trunkXIOS3/tools/WEIGHTS

for var in d2m msl msr ssrd strd t2m tp; do
	case $var in
		t2m|d2m) unit="K";;
		msl) unit="Pa";;
		msr) unit="kg m**-2 s**-1";;
		ssrd|strd) unit="J m**-2";;
		tp) unit="Pm";;
	esac
	cp namelist_interp_bilin namelist_interp_bilin_${var}
	sed -i "s/VAR/${var}/g" namelist_interp_bilin_${var}
	sed -i "s/UNIT/${unit}/g" namelist_interp_bilin_${var}

	echo namelist_interp_bilin_${var} | ${EXE_PATH}/scripinterp.exe

done

for var in u10 v10; do
        unit="ms-1"
	case $var in
		u10) mask='umaskutil';;
		v10) mask='vmaskutil';;
	esac
        cp namelist_interp_bicub namelist_interp_bicub_${var}
        sed -i "s/VAR/${var}/g" namelist_interp_bicub_${var}
        sed -i "s/UNIT/${unit}/g" namelist_interp_bicub_${var}
        sed -i "s/MASK/${mask}/g" namelist_interp_bicub_${var}

        echo namelist_interp_bicub_${var} | ${EXE_PATH}/scripinterp.exe

done

