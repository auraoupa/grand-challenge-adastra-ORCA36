MODULE in_out_manager   
   !!======================================================================
   !!                       ***  MODULE  in_out_manager  ***
   !! I/O manager utilities : Defines run parameters together with logical units
   !!=====================================================================
   !! History :   1.0  !  2002-06  (G. Madec)   original code
   !!             2.0  !  2006-07  (S. Masson)  iom, add ctl_stop, ctl_warn
   !!             3.0  !  2008-06  (G. Madec)   add ctmp4 to ctmp10
   !!             3.2  !  2009-08  (S. MAsson)  add new ctl_opn
   !!             3.3  !  2010-10  (A. Coward)  add NetCDF4 usage
   !!----------------------------------------------------------------------

   !!----------------------------------------------------------------------
   USE par_oce       ! ocean parameter
   USE nc4interface  ! NetCDF4 interface

   IMPLICIT NONE
   PUBLIC

   !!----------------------------------------------------------------------
   !!                   namrun namelist parameters
   !!----------------------------------------------------------------------
   CHARACTER(lc) ::   cn_exp           !: experiment name used for output filename
   INTEGER       ::   nn_it000         !: index of the first time step
   INTEGER       ::   nn_itend         !: index of the last time step
   INTEGER       ::   nn_date0         !: initial calendar date aammjj
   INTEGER       ::   nn_time0         !: initial time of day in hhmm
   INTEGER       ::   nn_leapy         !: Leap year calendar flag (0/1 or 30)
   LOGICAL       ::   ln_mskland       !: mask land points in NetCDF outputs (costly: + ~15%)
   LOGICAL       ::   ln_cfmeta        !: output additional data to netCDF files required for compliance with the CF metadata standard
   LOGICAL       ::   ln_clobber       !: clobber (overwrite) an existing file
   INTEGER       ::   nn_chunksz       !: chunksize (bytes) for NetCDF file (works only with iom_nf90 routines)
   LOGICAL       ::   ln_xios_read     !: use xios to read single file restart
   INTEGER       ::   nn_wxios         !: write resart using xios 0 - no, 1 - single, 2 - multiple file output

#if defined key_netcdf4
   !!----------------------------------------------------------------------
   !!                   namnc4 namelist parameters                         (key_netcdf4)
   !!----------------------------------------------------------------------
   ! The following four values determine the partitioning of the output fields
   ! into netcdf4 chunks. They are unrelated to the nn_chunk_sz setting which is
   ! for runtime optimisation. The individual netcdf4 chunks can be optionally 
   ! gzipped (recommended) leading to significant reductions in I/O volumes 
   !                         !!!**  variables only used with iom_nf90 routines and key_netcdf4 **
   INTEGER ::   nn_nchunks_i   !: number of chunks required in the i-dimension 
   INTEGER ::   nn_nchunks_j   !: number of chunks required in the j-dimension 
   INTEGER ::   nn_nchunks_k   !: number of chunks required in the k-dimension 
   INTEGER ::   nn_nchunks_t   !: number of chunks required in the t-dimension 
   LOGICAL ::   ln_nc4zip      !: netcdf4 usage: (T) chunk and compress output using the HDF5 sublayers of netcdf4
   !                           !                 (F) ignore chunking request and use the netcdf4 library 
   !                           !                     to produce netcdf3-compatible files 
#endif

!$AGRIF_DO_NOT_TREAT
   TYPE(snc4_ctl)     :: snc4set        !: netcdf4 chunking control structure (always needed for decision making)
!$AGRIF_END_DO_NOT_TREAT


   !! conversion of DOCTOR norm namelist name into model name
   !! (this should disappear in a near futur)

   CHARACTER(lc) ::   cexper                      !: experiment name used for output filename
   INTEGER       ::   nit000                      !: index of the first time step
   INTEGER       ::   nitend                      !: index of the last time step
   INTEGER       ::   ndate0                      !: initial calendar date aammjj
   INTEGER       ::   nleapy                      !: Leap year calendar flag (0/1 or 30)

   !!----------------------------------------------------------------------
   !!                        logical units
   !!----------------------------------------------------------------------
   INTEGER ::   numstp          =   -1      !: logical unit for time step
   INTEGER ::   numtime         =   -1      !: logical unit for timing
   INTEGER ::   numout          =    6      !: logical unit for output print; Set to stdout to ensure any
   INTEGER ::   numnul          =   -1      !: logical unit for /dev/null
      !                                     !  early output can be collected; do not change
   INTEGER ::   numnam_ref      =   -1      !: logical unit for reference namelist
   INTEGER ::   numnam_cfg      =   -1      !: logical unit for configuration specific namelist
   INTEGER ::   numond          =   -1      !: logical unit for Output Namelist Dynamics
   INTEGER ::   numoni          =   -1      !: logical unit for Output Namelist Ice
   INTEGER ::   numrun          =   -1      !: logical unit for run statistics

   !!----------------------------------------------------------------------
   !!                          Run control  
   !!----------------------------------------------------------------------
   INTEGER       ::   no_print = 0          !: optional argument of fld_fill (if present, suppress some control print)
   INTEGER       ::   nstop = 0             !: error flag (=number of reason for a premature stop run)
   INTEGER       ::   nwarn = 0             !: warning flag (=number of warning found during the run)
   CHARACTER(lc) ::   ctmp1, ctmp2, ctmp3   !: temporary characters 1 to 3
   CHARACTER(lc) ::   ctmp4, ctmp5, ctmp6   !: temporary characters 4 to 6
   CHARACTER(lc) ::   ctmp7, ctmp8, ctmp9   !: temporary characters 7 to 9
   CHARACTER(lc) ::   ctmp10                !: temporary character 10
   CHARACTER(lc) ::   cform_err = "(/,' ===>>> : E R R O R',     /,'         ===========',/)"       !:
   CHARACTER(lc) ::   cform_war = "(/,' ===>>> : W A R N I N G', /,'         ===============',/)"   !:
   LOGICAL       ::   lwm      = .FALSE.    !: boolean : true on the 1st processor only (always)
   LOGICAL       ::   lwp      = .FALSE.    !: boolean : true on the 1st processor only .OR. ln_ctl
   CHARACTER(lc) ::   cxios_context         !: context name used in xios
   CHARACTER(lc) ::   crxios_context         !: context name used in xios to read restart
   CHARACTER(lc) ::   cwxios_context        !: context name used in xios to write restart file

   !!----------------------------------------------------------------------
   !! NEMO/OCE 4.0 , NEMO Consortium (2018)
   !! $Id: in_out_manager.F90 10570 2019-01-24 15:14:49Z acc $
   !! Software governed by the CeCILL license (see ./LICENSE)
   !!=====================================================================
END MODULE in_out_manager
