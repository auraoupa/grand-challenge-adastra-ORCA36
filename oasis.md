# Coupling NEMO and SI3 via OASIS

```git clone https://gitlab.com/cerfacs/oasis3-mct.git``` will give OASIS3 version 5.0

Documentation : https://gitlab.com/cerfacs/oasis3-mct/-/blob/OASIS3-MCT_5.0/doc/oasis3mct_UserGuide.pdf

OASIS Forum :

>The steps I followed to setup, compile and run the spoc_communitcation example on the ARCHER2 HPC are here:
>https://github.com/hpc-uk/build-instructions/blob/main/apps/OASIS/build-OASIS3-mct-ARCHER2-gnu.md

>The make.ARCHER2 file is here:
>https://github.com/hpc-uk/build-instructions/tree/main/apps/OASIS

 - [x] get oasis3 version 4.0 with ```git clone --branch OASIS3-MCT_4.0 https://gitlab.com/cerfacs/oasis3-mct.git```
 - [x] compile oasis : 
   - in util/make_dir, modify make.inc so it includes the make_X64_JEANZAY macro
   - ```make -f TopMakefileOasis3```
   - check BLD/lib for libmct.a libmpeu.a libpsmile.MPI1.a and libscrip.a et BLD/build/lib for psmile.MPI1
 - [x] compile xios with oasis : in arch.path add oasis path, compile with --use_oasis oasis3_mct
 - [x] compile NEMO with oasis and xios : in arch file add the right paths, use key_xios and key_oasis3
