#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --ntasks-per-node=40
#SBATCH --threads-per-core=1
#SBATCH -A cli@cpu
#SBATCH --hint=nomultithread
#SBATCH -J mk_meshmask
#SBATCH -e zjob.e%j
#SBATCH -o zjob.o%j
#SBATCH --time=0:30:00
#SBATCH --exclusive

CONFIG=eORCA05.L121
CASE=GD2022
CONFCASE=${CONFIG}-${CASE}

refconfcase=eORCA05.L75-JZ406
refconf=${refconfcase%-*}
refcase=${refconfcase#*-}


mkdir -p $DDIR/TMPDIR_${CONFCASE}

tmpdir=$DDIR/TMPDIR_${CONFCASE}
idir=$WORK/$CONFIG/${CONFIG}-I

cp $idir/${CONFIG}_domain_cfg.nc $tmpdir
cp $PDIR/RUN_${CONFIG}/${CONFCASE}/EXE/nemo4.exe $tmpdir

cp $PDIR/RUN_${refconf}/${refconfcase}/CTL/*xml $tmpdir
cp $PDIR/RUN_${refconf}/${refconfcase}/CTL/namelist* $tmpdir

cd $tmpdir
# some editing of the xml files :
  for xml in *.xml ; do
    cat $xml | sed -e "s/<OUTDIR>/./" -e "s/<NDATE0>/01012000/" -e "s/<CONFIG>/${CONFIG}/" -e "s/<CASE>/$CASE/" > tmp
    mv tmp $xml
  done
  

# some editing of the namelist :
  for namlist in namelist* ; do
    cat $namlist | sed -e "s/<NN_NO>/1/" -e "s/<NITOOO>/1/" -e "s/<NITEND>/20/" -e "s/<RESTART>/.false./" -e "s@<CN_DIRRST>@./@" \
        -e "s@<CN_DIRICB>@./@" -e "s/$refconfcase/$CONFCASE/"  -e "s/$refconf/$CONFIG/" >  tmp
    mv tmp $namlist
  done
  mv namelist.$refconfcase namelist_ref
  cp namelist_ref namelist_cfg

  mv namelist_ice.$refconfcase  namelist_ice_ref
  cp namelist_ice_ref namelist_ice_cfg


srun -n 40 ./nemo4.exe

ln -sf ${CONFIG}_domain_cfg.nc coordinates.nc
rebuild_nemo  mesh_mask 40

ncks -4 -L1 --cnk_dmn nav_lev,1 mesh_mask.nc ${CONFCASE}_mesh_mask.nc

rm mesh_mask_*nc

