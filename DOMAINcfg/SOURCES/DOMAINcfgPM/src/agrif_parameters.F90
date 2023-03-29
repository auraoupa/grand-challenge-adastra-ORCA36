MODULE agrif_parameters
	
   USE par_kind

   PUBLIC 

#if defined key_agrif

	INTEGER :: nn_cln_update
	LOGICAL :: ln_spc_dyn
	REAL(wp) :: rn_sponge_tra
	REAL(wp) :: rn_sponge_dyn
	LOGICAL :: ln_chk_bathy
	INTEGER :: npt_copy
	INTEGER :: npt_connect
	REAL(wp), PUBLIC, ALLOCATABLE, SAVE        , DIMENSION(:,:) ::   ztabramp
	REAL(wp), PUBLIC, ALLOCATABLE, SAVE        , DIMENSION(:,:,:) ::   e3t_interp

#endif

END MODULE agrif_parameters
