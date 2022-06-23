#!/bin/bash


isf_file=eORCA025_mskisf_c3.0_v0.0.txt
msh_hgr=eORCA025.L75_mesh_mask_closed_seas_greenland_4.2.0.nc

# get info for each line and print like a section file


 cat  $isf_file | awk '{if ( $1 < 99 ) {print $2 ; \
   system("cdfwhereij -w "$5" " $5" " $6" " $6 " -p T -c $msh_hgr \
           | grep -v Type | grep -v I ") } }' > ztmp
 cat ztmp  | awk 'BEGIN{n=1} {if ( NR%2 == 0 ) print " " $5 " " $7 ; else {printf "%d %s",n, $1; n=n+1} }' > ztmp2

 nl=$( wc -l ztmp2 | awk '{print $1}')

 filisf=($( head -$nl $isf_file) )
 fillonlat=( $(cat ztmp2) )


for i in $(seq 1 $nl) ; do
  ilon=$(( ( i - 1 ) * 4 + 2 ))
  ilat=$(( ( i - 1 ) * 4 + 3 ))
  i1=$(( (i - 1 ) * 11 ))
  i2=$(( (i - 1 ) * 11 + 6 ))
  
  rlon[$i]=${fillonlat[$ilon]}
  rlat[$i]=${fillonlat[$ilat]}

   deblin[$i]=${filisf[@]:$i1:2}
   endlin[$i]=${filisf[@]:$i2:5}

   printf "%2s %4s %8s %8s %4s %4s %5s %6s %6s %7s\n" ${deblin[$i]} ${rlon[$i]} ${rlat[$i]} ${endlin[$i]}

done


exit
1  AMER  0.0 0.0  2   293  200 1900   35.5   50.4  .FALSE. 
2  PUBL  0.0 0.0  10  289  100  300    1.5    5.2  .FALSE.
3  WEST  0.0 0.0  52  321  140  600   27.2   32.6  .TRUE.
4  SHAC  0.0 0.0 100  326   50  650   75.6   30.5  .FALSE.
5  CONG  0.0 0.0 124  331   20  100    3.6    1.1  .FALSE.


