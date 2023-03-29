#if defined key_agrif
   SUBROUTINE agrif_user()
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE agrif_user ***
      !!----------------------------------------------------------------------
   END SUBROUTINE agrif_user

   SUBROUTINE agrif_initworkspace()
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE Agrif_InitWorkspace ***
      !!----------------------------------------------------------------------
   END SUBROUTINE agrif_initworkspace

   SUBROUTINE Agrif_InitValues
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE Agrif_InitValues ***
      !!
      !! ** Purpose :: Declaration of variables to be interpolated
      !!----------------------------------------------------------------------
      USE Agrif_Util
      USE dom_oce
      USE nemogcm
      USE domain
      !!
      IMPLICIT NONE

      ! No temporal refinement
      CALL Agrif_Set_coeffreft(1)

      CALL nemo_init       !* Initializations of each fine grid

      CALL dom_nam

   END SUBROUTINE Agrif_InitValues

   SUBROUTINE Agrif_InitValues_cont
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE Agrif_InitValues_cont ***
      !!
      !! ** Purpose :: Initialisation of variables to be interpolated
      !!----------------------------------------------------------------------
      USE dom_oce
      USE lbclnk
      !!
      IMPLICIT NONE
      !
      INTEGER :: nx, ny
      INTEGER :: irafx, irafy
      LOGICAL :: ln_perio
      !
      irafx = agrif_irhox()
      irafy = agrif_irhoy()

      nx = nlci ; ny = nlcj

   !       IF(jperio /=1 .AND. jperio/=4 .AND. jperio/=6 ) THEN
   !          nx = (nbcellsx)+2*nbghostcellsfine+2
   !          ny = (nbcellsy)+2*nbghostcellsfine+2
   !          nbghostcellsfine_tot_x= nbghostcellsfine_x +1
   !          nbghostcellsfine_tot_y= nbghostcellsfine_y +1
   !       ELSE
   !         nx = (nbcellsx)+2*nbghostcellsfine_x
   !         ny = (nbcellsy)+2*nbghostcellsfine+2
   !         nbghostcellsfine_tot_x= 1
   !         nbghostcellsfine_tot_y= nbghostcellsfine_y +1
   !      ENDIF
   !    ELSE
   !       nbghostcellsfine = 0
   !       nx = nbcellsx+irafx
   !       ny = nbcellsy+irafy

      WRITE(*,*) ' '
      WRITE(*,*)'Size of the High resolution grid: ',nx,' x ',ny
      WRITE(*,*) ' '

      CALL agrif_init_lonlat()
      ln_perio = .FALSE.
      IF( jperio == 1 .OR. jperio == 2 .OR. jperio == 4 ) ln_perio=.TRUE.

      WHERE (glamt < -180) glamt = glamt +360.
      WHERE (glamt > +180) glamt = glamt -360.

      CALL lbc_lnk( 'glamt', glamt, 'T', 1._wp)
      CALL lbc_lnk( 'gphit', gphit, 'T', 1._wp)

      WHERE (glamu < -180) glamu = glamu +360.
      WHERE (glamu > +180) glamu = glamu -360.
      CALL lbc_lnk( 'glamu', glamu, 'U', 1._wp)
      CALL lbc_lnk( 'gphiu', gphiu, 'U', 1._wp)

      WHERE (glamv < -180) glamv = glamv +360.
      WHERE (glamv > +180) glamv = glamv -360.
      CALL lbc_lnk( 'glamv', glamv, 'V', 1._wp)
      CALL lbc_lnk( 'gphiv', gphiv, 'V', 1._wp)

      WHERE (glamf < -180) glamf = glamf +360.
      WHERE (glamf > +180) glamf = glamf -360.
      CALL lbc_lnk( 'glamf', glamf, 'F', 1._wp)
      CALL lbc_lnk( 'gphif', gphif, 'F', 1._wp)

      ! Correct South and North
      IF ((nbondj == -1).OR.(nbondj == 2)) THEN
         glamt(:,1) = glamt(:,2)
         gphit(:,1) = gphit(:,2)
         glamu(:,1) = glamu(:,2)
         gphiu(:,1) = gphiu(:,2)
         glamv(:,1) = glamv(:,2)
         gphiv(:,1) = gphiv(:,2)
      ENDIF
      IF ((nbondj == 1).OR.(nbondj == 2)) THEN
         glamt(:,jpj) = glamt(:,jpj-1)
         gphit(:,jpj) = gphit(:,jpj-1)
         glamu(:,jpj) = glamu(:,jpj-1)
         gphiu(:,jpj) = gphiu(:,jpj-1)
         glamv(:,jpj) = glamv(:,jpj-1)
         gphiv(:,jpj) = gphiv(:,jpj-1)
         glamf(:,jpj) = glamf(:,jpj-1)
         gphif(:,jpj) = gphif(:,jpj-1)
      ENDIF

      ! Correct West and East
      IF( jperio /= 1 ) THEN
         IF((nbondi == -1) .OR. (nbondi == 2) ) THEN
            glamt(1,:) = glamt(2,:)
            gphit(1,:) = gphit(2,:)
            glamu(1,:) = glamu(2,:)
            gphiu(1,:) = gphiu(2,:)
            glamv(1,:) = glamv(2,:)
            gphiv(1,:) = gphiv(2,:)
         ENDIF
         IF( (nbondi == 1) .OR. (nbondi == 2) ) THEN
            glamt(jpi,:) = glamt(jpi-1,:)
            gphit(jpi,:) = gphit(jpi-1,:)
            glamu(jpi,:) = glamu(jpi-1,:)
            gphiu(jpi,:) = gphiu(jpi-1,:)
            glamv(jpi,:) = glamv(jpi-1,:)
            gphiv(jpi,:) = gphiv(jpi-1,:)
            glamf(jpi,:) = glamf(jpi-1,:)
            gphif(jpi,:) = gphif(jpi-1,:)
         ENDIF
      ENDIF

      CALL agrif_init_scales()

      ! Correct South and North
      IF( (nbondj == -1) .OR. (nbondj == 2) ) THEN
         e1t(:,1) = e1t(:,2)
         e2t(:,1) = e2t(:,2)
         e1u(:,1) = e1u(:,2)
         e2u(:,1) = e2u(:,2)
         e1v(:,1) = e1v(:,2)
         e2v(:,1) = e2v(:,2)
      ENDIF
      IF( (nbondj == 1) .OR. (nbondj == 2) ) THEN
         e1t(:,jpj) = e1t(:,jpj-1)
         e2t(:,jpj) = e2t(:,jpj-1)
         e1u(:,jpj) = e1u(:,jpj-1)
         e2u(:,jpj) = e2u(:,jpj-1)
         e1v(:,jpj) = e1v(:,jpj-1)
         e2v(:,jpj) = e2v(:,jpj-1)
         e1f(:,jpj) = e1f(:,jpj-1)
         e2f(:,jpj) = e2f(:,jpj-1)
      ENDIF

      ! Correct West and East
      IF( jperio /= 1 ) THEN
         IF( (nbondj == -1) .OR. (nbondj == 2) ) THEN
            e1t(1,:) = e1t(2,:)
            e2t(1,:) = e2t(2,:)
            e1u(1,:) = e1u(2,:)
            e2u(1,:) = e2u(2,:)
            e1v(1,:) = e1v(2,:)
            e2v(1,:) = e2v(2,:)
         ENDIF
         IF( (nbondj == 1) .OR. (nbondj == 2) ) THEN
            e1t(jpi,:) = e1t(jpi-1,:)
            e2t(jpi,:) = e2t(jpi-1,:)
            e1u(jpi,:) = e1u(jpi-1,:)
            e2u(jpi,:) = e2u(jpi-1,:)
            e1v(jpi,:) = e1v(jpi-1,:)
            e2v(jpi,:) = e2v(jpi-1,:)
            e1f(jpi,:) = e1f(jpi-1,:)
            e2f(jpi,:) = e2f(jpi-1,:)
         ENDIF
      ENDIF

   END SUBROUTINE Agrif_InitValues_cont


   SUBROUTINE agrif_declare_var()
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE Agrif_InitValues_cont ***
      !!
      !! ** Purpose :: Declaration of variables to be interpolated
      !!----------------------------------------------------------------------
      USE par_oce
      USE dom_oce
      USE agrif_profiles
      USE agrif_parameters

      IMPLICIT NONE

      INTEGER :: ind1, ind2, ind3
      INTEGER :: nx, ny
      INTEGER ::nbghostcellsfine_tot_x, nbghostcellsfine_tot_y
      INTEGER :: irafx

      EXTERNAL :: nemo_mapping

      ! 1. Declaration of the type of variable which have to be interpolated
      !---------------------------------------------------------------------

      nx=nlci ; ny=nlcj

      ind2 = 2 + nbghostcells_x
      ind3 = 2 + nbghostcells_y_s
      nbghostcellsfine_tot_x=nbghostcells_x+1
      nbghostcellsfine_tot_y=max(nbghostcells_y_s,nbghostcells_y_n)+1

      irafx = Agrif_irhox()

      ! In case of East-West periodicity, prevent AGRIF interpolation at east and west boundaries
      ! The procnames will not be CALLed at these boundaries
      if (jperio == 1) THEN
        CALL Agrif_Set_NearCommonBorderX(.TRUE.)
        CALL Agrif_Set_DistantCommonBorderX(.TRUE.)
      endif
      if (.not.lk_south) THEN
        CALL Agrif_Set_NearCommonBorderY(.TRUE.)
      endif

      CALL agrif_declare_variable((/2,2/),(/ind2,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),glamt_id)
      CALL agrif_declare_variable((/1,2/),(/ind2-1,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),glamu_id)
      CALL agrif_declare_variable((/2,1/),(/ind2,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),glamv_id)
      CALL agrif_declare_variable((/1,1/),(/ind2-1,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),glamf_id)

      CALL agrif_declare_variable((/2,2/),(/ind2,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),gphit_id)
      CALL agrif_declare_variable((/1,2/),(/ind2-1,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),gphiu_id)
      CALL agrif_declare_variable((/2,1/),(/ind2,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),gphiv_id)
      CALL agrif_declare_variable((/1,1/),(/ind2-1,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),gphif_id)

      ! Horizontal scale factors

      CALL agrif_declare_variable((/2,2/),(/ind2,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),e1t_id)
      CALL agrif_declare_variable((/1,2/),(/ind2-1,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),e1u_id)
      CALL agrif_declare_variable((/2,1/),(/ind2,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),e1v_id)
      CALL agrif_declare_variable((/1,1/),(/ind2-1,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),e1f_id)

      CALL agrif_declare_variable((/2,2/),(/ind2,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),e2t_id)
      CALL agrif_declare_variable((/1,2/),(/ind2-1,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),e2u_id)
      CALL agrif_declare_variable((/2,1/),(/ind2,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),e2v_id)
      CALL agrif_declare_variable((/1,1/),(/ind2-1,ind3-1/),(/'x','y'/),(/1,1/),(/nx,ny/),e2f_id)

      ! Bathymetry

      CALL agrif_declare_variable((/2,2/),(/ind2,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),bathy_id)

      ! Vertical scale factors
      CALL agrif_declare_variable((/2,2,0/),(/ind2,ind3,0/),(/'x','y','N'/),(/1,1,1/),(/nx,ny,jpk/),e3t_id)
      CALL agrif_declare_variable((/2,2,0/),(/ind2,ind3,0/),(/'x','y','N'/),(/1,1,1/),(/nx,ny,jpk/),e3t_copy_id)
      CALL agrif_declare_variable((/2,2,0/),(/ind2,ind3,0/),(/'x','y','N'/),(/1,1,1/),(/nx,ny,jpk+1/),e3t_connect_id)

      CALL agrif_declare_variable((/1,2,0/),(/ind2-1,ind3,0/),(/'x','y','N'/),(/1,1,1/),(/nx,ny,jpk/),e3u_id)
      CALL agrif_declare_variable((/2,1,0/),(/ind2,ind3-1,0/),(/'x','y','N'/),(/1,1,1/),(/nx,ny,jpk/),e3v_id)

      ! Bottom level

      CALL agrif_declare_variable((/2,2/),(/ind2,ind3/),(/'x','y'/),(/1,1/),(/nx,ny/),bottom_level_id)

      CALL Agrif_Set_bcinterp(glamt_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(glamt_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( glamt_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )

      CALL Agrif_Set_bcinterp(glamu_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(glamu_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( glamu_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(glamv_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(glamv_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( glamv_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(glamf_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(glamf_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( glamf_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(gphit_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(gphit_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( gphit_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )

      CALL Agrif_Set_bcinterp(gphiu_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(gphiu_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( gphiu_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(gphiv_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(gphiv_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( gphiv_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(gphif_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(gphif_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( gphif_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      !

      CALL Agrif_Set_bcinterp(e1t_id,interp=AGRIF_ppm)
      CALL Agrif_Set_interp(e1t_id,interp=AGRIF_ppm)
      CALL Agrif_Set_bc( e1t_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )

      CALL Agrif_Set_bcinterp(e1u_id, interp1=Agrif_linear, interp2=AGRIF_ppm)
      CALL Agrif_Set_interp(e1u_id, interp1=Agrif_linear, interp2=AGRIF_ppm)
      CALL Agrif_Set_bc( e1u_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(e1v_id,interp1=AGRIF_ppm, interp2=Agrif_linear)
      CALL Agrif_Set_interp(e1v_id, interp1=AGRIF_ppm, interp2=Agrif_linear)
      CALL Agrif_Set_bc( e1v_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(e1f_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(e1f_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( e1f_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(e2t_id,interp=AGRIF_ppm)
      CALL Agrif_Set_interp(e2t_id,interp=AGRIF_ppm)
      CALL Agrif_Set_bc( e2t_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )

      CALL Agrif_Set_bcinterp(e2u_id,interp1=Agrif_linear, interp2=AGRIF_ppm)
      CALL Agrif_Set_interp(e2u_id,interp1=Agrif_linear, interp2=AGRIF_ppm)
      CALL Agrif_Set_bc( e2u_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(e2v_id,interp1=AGRIF_ppm, interp2=Agrif_linear)
      CALL Agrif_Set_interp(e2v_id,interp1=AGRIF_ppm, interp2=Agrif_linear)
      CALL Agrif_Set_bc( e2v_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(e2f_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(e2f_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( e2f_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)/) )

      CALL Agrif_Set_bcinterp(bathy_id,interp=AGRIF_linear)
      CALL Agrif_Set_interp(bathy_id,interp=AGRIF_linear)
      CALL Agrif_Set_bc( bathy_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )

      ! Vertical scale factors
      CALL Agrif_Set_bcinterp(e3t_id,interp=AGRIF_ppm)
      CALL Agrif_Set_interp(e3t_id,interp=AGRIF_ppm)
      CALL Agrif_Set_bc( e3t_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )
      CALL Agrif_Set_Updatetype( e3t_id, update = AGRIF_Update_Average)

      CALL Agrif_Set_bcinterp(e3t_copy_id,interp=AGRIF_constant)
      CALL Agrif_Set_interp(e3t_copy_id,interp=AGRIF_constant)
      CALL Agrif_Set_bc( e3t_copy_id, (/-npt_copy*irafx,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/))

      CALL Agrif_Set_bcinterp(e3t_connect_id,interp=AGRIF_ppm)
      CALL Agrif_Set_interp(e3t_connect_id,interp=AGRIF_ppm)
      CALL Agrif_Set_bc( e3t_connect_id, (/-(npt_copy+npt_connect)*irafx-1,-npt_copy*irafx/))

      CALL Agrif_Set_bcinterp(e3u_id, interp1=Agrif_linear, interp2=AGRIF_ppm)
      CALL Agrif_Set_interp(e3u_id, interp1=Agrif_linear, interp2=AGRIF_ppm)
      CALL Agrif_Set_bc( e3u_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )
      CALL Agrif_Set_Updatetype(e3u_id,update1 = Agrif_Update_Copy, update2 = Agrif_Update_Average)

      CALL Agrif_Set_bcinterp(e3v_id,interp1=AGRIF_ppm, interp2=Agrif_linear)
      CALL Agrif_Set_interp(e3v_id, interp1=AGRIF_ppm, interp2=Agrif_linear)
      CALL Agrif_Set_bc( e3v_id, (/0,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/) )
      CALL Agrif_Set_Updatetype(e3v_id,update1 = Agrif_Update_Average, update2 = Agrif_Update_Copy)

      ! Bottom level
      CALL Agrif_Set_bcinterp(bottom_level_id,interp=AGRIF_constant)
      CALL Agrif_Set_interp(bottom_level_id,interp=AGRIF_constant)
      CALL Agrif_Set_bc( bottom_level_id, (/-npt_copy*irafx,max(nbghostcellsfine_tot_x,nbghostcellsfine_tot_y)-1/))
      CALL Agrif_Set_Updatetype( bottom_level_id, update = AGRIF_Update_Max)

      CALL Agrif_Set_ExternalMapping(nemo_mapping)

   END SUBROUTINE agrif_declare_var

   SUBROUTINE nemo_mapping(ndim,ptx,pty,bounds,bounds_chunks,correction_required,nb_chunks)
      USE dom_oce
      INTEGER :: ndim
      INTEGER :: ptx, pty
      INTEGER,DIMENSION(ndim,2,2) :: bounds
      INTEGER,DIMENSION(:,:,:,:),allocatable :: bounds_chunks
      LOGICAL,DIMENSION(:),allocatable :: correction_required
      INTEGER :: nb_chunks
      INTEGER :: i

      IF (agrif_debug_interp) THEN
         DO i = 1, ndim
             print *,'direction = ',i,bounds(i,1,2),bounds(i,2,2)
         END DO
      ENDIF

      IF( bounds(2,2,2) > jpjglo ) THEN
         IF( bounds(2,1,2) <= jpjglo ) THEN
            nb_chunks = 2
            ALLOCATE(bounds_chunks(nb_chunks,ndim,2,2))
            ALLOCATE(correction_required(nb_chunks))
            DO i = 1, nb_chunks
               bounds_chunks(i,:,:,:) = bounds
            END DO

         ! FIRST CHUNCK (for j<=jpjglo)

            ! Original indices
            bounds_chunks(1,1,1,1) = bounds(1,1,2)
            bounds_chunks(1,1,2,1) = bounds(1,2,2)
            bounds_chunks(1,2,1,1) = bounds(2,1,2)
            bounds_chunks(1,2,2,1) = jpjglo

            bounds_chunks(1,1,1,2) = bounds(1,1,2)
            bounds_chunks(1,1,2,2) = bounds(1,2,2)
            bounds_chunks(1,2,1,2) = bounds(2,1,2)
            bounds_chunks(1,2,2,2) = jpjglo

            ! Correction required or not
            correction_required(1)=.FALSE.

         ! SECOND CHUNCK (for j>jpjglo)

            !Original indices
            bounds_chunks(2,1,1,1) = bounds(1,1,2)
            bounds_chunks(2,1,2,1) = bounds(1,2,2)
            bounds_chunks(2,2,1,1) = jpjglo-2
            bounds_chunks(2,2,2,1) = bounds(2,2,2)

           ! Where to find them
           ! We use the relation TAB(ji,jj)=TAB(jpiglo-ji+2,jpjglo-2-(jj-jpjglo))

            IF (ptx == 2) THEN ! T, V points
               bounds_chunks(2,1,1,2) = jpiglo-bounds(1,2,2)+2
               bounds_chunks(2,1,2,2) = jpiglo-bounds(1,1,2)+2
            ELSE ! U, F points
               bounds_chunks(2,1,1,2) = jpiglo-bounds(1,2,2)+1
               bounds_chunks(2,1,2,2) = jpiglo-bounds(1,1,2)+1
            ENDIF

            IF (pty == 2) THEN ! T, U points
               bounds_chunks(2,2,1,2) = jpjglo-2-(bounds(2,2,2) -jpjglo)
               bounds_chunks(2,2,2,2) = jpjglo-2-(jpjglo-2      -jpjglo)
            ELSE ! V, F points
               bounds_chunks(2,2,1,2) = jpjglo-3-(bounds(2,2,2) -jpjglo)
               bounds_chunks(2,2,2,2) = jpjglo-3-(jpjglo-2      -jpjglo)
            ENDIF
      
            ! Correction required or not
            correction_required(2)=.TRUE.

         ELSE
           
            nb_chunks = 1
            ALLOCATE(bounds_chunks(nb_chunks,ndim,2,2))
            ALLOCATE(correction_required(nb_chunks))
            DO i=1,nb_chunks
                bounds_chunks(i,:,:,:) = bounds
            END DO

            bounds_chunks(1,1,1,1) = bounds(1,1,2)
            bounds_chunks(1,1,2,1) = bounds(1,2,2)
            bounds_chunks(1,2,1,1) = bounds(2,1,2)
            bounds_chunks(1,2,2,1) = bounds(2,2,2)

            bounds_chunks(1,1,1,2) = jpiglo-bounds(1,2,2)+2
            bounds_chunks(1,1,2,2) = jpiglo-bounds(1,1,2)+2

            bounds_chunks(1,2,1,2) = jpjglo-2-(bounds(2,2,2)-jpjglo)
            bounds_chunks(1,2,2,2) = jpjglo-2-(bounds(2,1,2)-jpjglo)

            IF (ptx == 2) THEN ! T, V points
               bounds_chunks(1,1,1,2) = jpiglo-bounds(1,2,2)+2
               bounds_chunks(1,1,2,2) = jpiglo-bounds(1,1,2)+2
            ELSE ! U, F points
               bounds_chunks(1,1,1,2) = jpiglo-bounds(1,2,2)+1
               bounds_chunks(1,1,2,2) = jpiglo-bounds(1,1,2)+1
            ENDIF

            IF (pty == 2) THEN ! T, U points
               bounds_chunks(1,2,1,2) = jpjglo-2-(bounds(2,2,2) -jpjglo)
               bounds_chunks(1,2,2,2) = jpjglo-2-(bounds(2,1,2) -jpjglo)
            ELSE ! V, F points
               bounds_chunks(1,2,1,2) = jpjglo-3-(bounds(2,2,2) -jpjglo)
               bounds_chunks(1,2,2,2) = jpjglo-3-(bounds(2,1,2) -jpjglo)
            ENDIF

            correction_required(1)=.TRUE.

         ENDIF  ! bounds(2,1,2) <= jpjglo

      ELSE IF (bounds(1,1,2) < 1) THEN
         
         IF (bounds(1,2,2) > 0) THEN
            nb_chunks = 2
            ALLOCATE(correction_required(nb_chunks))
            correction_required=.FALSE.
            ALLOCATE(bounds_chunks(nb_chunks,ndim,2,2))
            DO i=1,nb_chunks
               bounds_chunks(i,:,:,:) = bounds
            END DO

            bounds_chunks(1,1,1,2) = bounds(1,1,2)+jpiglo-2
            bounds_chunks(1,1,2,2) = 1+jpiglo-2

            bounds_chunks(1,1,1,1) = bounds(1,1,2)
            bounds_chunks(1,1,2,1) = 1

            bounds_chunks(2,1,1,2) = 2
            bounds_chunks(2,1,2,2) = bounds(1,2,2)

            bounds_chunks(2,1,1,1) = 2
            bounds_chunks(2,1,2,1) = bounds(1,2,2)
         ELSE
            nb_chunks = 1
            ALLOCATE(correction_required(nb_chunks))
            correction_required=.FALSE.
            ALLOCATE(bounds_chunks(nb_chunks,ndim,2,2))
            DO i=1,nb_chunks
               bounds_chunks(i,:,:,:) = bounds
            END DO
            bounds_chunks(1,1,1,2) = bounds(1,1,2)+jpiglo-2
            bounds_chunks(1,1,2,2) = bounds(1,2,2)+jpiglo-2

            bounds_chunks(1,1,1,1) = bounds(1,1,2)
            bounds_chunks(1,1,2,1) = bounds(1,2,2)
         ENDIF
      
      ELSE
      
         nb_chunks=1
         ALLOCATE(correction_required(nb_chunks))
         correction_required=.FALSE.
         ALLOCATE(bounds_chunks(nb_chunks,ndim,2,2))
         DO i=1,nb_chunks
            bounds_chunks(i,:,:,:) = bounds
         END DO
         bounds_chunks(1,1,1,2) = bounds(1,1,2)
         bounds_chunks(1,1,2,2) = bounds(1,2,2)
         bounds_chunks(1,2,1,2) = bounds(2,1,2)
         bounds_chunks(1,2,2,2) = bounds(2,2,2)

         bounds_chunks(1,1,1,1) = bounds(1,1,2)
         bounds_chunks(1,1,2,1) = bounds(1,2,2)
         bounds_chunks(1,2,1,1) = bounds(2,1,2)
         bounds_chunks(1,2,2,1) = bounds(2,2,2)

      ENDIF

   END SUBROUTINE nemo_mapping

   FUNCTION agrif_external_switch_index(ptx,pty,i1,isens)
      USE dom_oce
      INTEGER :: ptx, pty, i1, isens
      INTEGER :: agrif_external_switch_index

      IF( isens == 1 )  THEN
         IF( ptx == 2 ) THEN ! T, V points
            agrif_external_switch_index = jpiglo-i1+2
         ELSE ! U, F points
            agrif_external_switch_index = jpiglo-i1+1
         ENDIF
      ELSE IF (isens ==2) THEN
         IF (pty == 2) THEN ! T, U points
            agrif_external_switch_index = jpjglo-2-(i1 -jpjglo)
         ELSE ! V, F points
            agrif_external_switch_index = jpjglo-3-(i1 -jpjglo)
         ENDIF
      ENDIF

   END FUNCTION agrif_external_switch_index

   SUBROUTINE correct_field(tab2d,i1,i2,j1,j2)
      USE dom_oce
      INTEGER :: i1,i2,j1,j2
      REAL,DIMENSION(i1:i2,j1:j2) :: tab2d

      INTEGER :: i,j
      REAL,DIMENSION(i1:i2,j1:j2) :: tab2dtemp

      tab2dtemp = tab2d

      DO j=j1,j2
         DO i=i1,i2
        tab2d(i,j)=tab2dtemp(i2-(i-i1),j2-(j-j1))
         END DO
      ENDDO

   END SUBROUTINE correct_field

   SUBROUTINE agrif_init_lonlat()
      USE agrif_profiles
      USE agrif_util
      USE dom_oce
     
      EXTERNAL :: init_glamt, init_glamu, init_glamv, init_glamf
      EXTERNAL :: init_gphit, init_gphiu, init_gphiv, init_gphif
      REAL, EXTERNAL :: longitude_linear_interp

      INTEGER :: ji,jj,i1,i2,j1,j2
      REAL, DIMENSION(jpi,jpj) :: tab2dtemp
      INTEGER :: ind2,ind3
      INTEGER :: irhox, irhoy

      irhox = agrif_irhox()
      irhoy = agrif_irhoy()
      CALL Agrif_Set_external_linear_interp(longitude_linear_interp)

      CALL Agrif_Init_variable(glamt_id, procname = init_glamt)
      CALL Agrif_Init_variable(glamu_id, procname = init_glamu)
      CALL Agrif_Init_variable(glamv_id, procname = init_glamv)
      CALL Agrif_Init_variable(glamf_id, procname = init_glamf)
      CALL Agrif_UnSet_external_linear_interp()

      CALL Agrif_Init_variable(gphit_id, procname = init_gphit)
      CALL Agrif_Init_variable(gphiu_id, procname = init_gphiu)
      CALL Agrif_Init_variable(gphiv_id, procname = init_gphiv)
      CALL Agrif_Init_variable(gphif_id, procname = init_gphif)

   END SUBROUTINE agrif_init_lonlat

   REAL FUNCTION longitude_linear_interp(x1,x2,coeff)
      REAL :: x1, x2, coeff
      REAL :: val_interp

      IF( (x1*x2 <= -50*50) ) THEN
      	IF( x1 < 0 ) THEN
      		val_interp = coeff *(x1+360.) + (1.-coeff) *x2
      	ELSE
      		val_interp = coeff *x1 + (1.-coeff) *(x2+360.)
      	ENDIF
      	IF ((val_interp) >=180.) val_interp = val_interp - 360.
      ELSE
      	val_interp = coeff * x1 + (1.-coeff) * x2
      ENDIF
      longitude_linear_interp = val_interp

   END FUNCTION longitude_linear_interp

   SUBROUTINE agrif_init_scales()
      USE agrif_profiles
      USE agrif_util
      USE dom_oce
      USE lbclnk
      LOGICAL :: ln_perio
      INTEGER nx,ny

      EXTERNAL :: init_e1t, init_e1u, init_e1v, init_e1f
      EXTERNAL :: init_e2t, init_e2u, init_e2v, init_e2f

      nx = nlci ; ny = nlcj

      ln_perio=.FALSE.
      if( jperio ==1 .OR. jperio==2 .OR. jperio==4) ln_perio=.TRUE.

      CALL Agrif_Init_variable(e1t_id, procname = init_e1t)
      CALL Agrif_Init_variable(e1u_id, procname = init_e1u)
      CALL Agrif_Init_variable(e1v_id, procname = init_e1v)
      CALL Agrif_Init_variable(e1f_id, procname = init_e1f)

      CALL Agrif_Init_variable(e2t_id, procname = init_e2t)
      CALL Agrif_Init_variable(e2u_id, procname = init_e2u)
      CALL Agrif_Init_variable(e2v_id, procname = init_e2v)
      CALL Agrif_Init_variable(e2f_id, procname = init_e2f)

      CALL lbc_lnk( 'e1t', e1t, 'T', 1._wp)
      CALL lbc_lnk( 'e2t', e2t, 'T', 1._wp)
      CALL lbc_lnk( 'e1u', e1u, 'U', 1._wp)
      CALL lbc_lnk( 'e2u', e2u, 'U', 1._wp)
      CALL lbc_lnk( 'e1v', e1v, 'V', 1._wp)
      CALL lbc_lnk( 'e2v', e2v, 'V', 1._wp)
      CALL lbc_lnk( 'e1f', e1f, 'F', 1._wp)
      CALL lbc_lnk( 'e2f', e2f, 'F', 1._wp)

   END SUBROUTINE agrif_init_scales

   SUBROUTINE init_glamt( ptab, i1, i2, j1, j2,  before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir

      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = glamt(i1:i2,j1:j2)
      ELSE
      	 glamt(i1:i2,j1:j2) = ptab(i1:i2,j1:j2)
      ENDIF
      !
   END SUBROUTINE init_glamt

   SUBROUTINE init_glamu( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      LOGICAL  ::   western_side, eastern_side,northern_side,southern_side
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = glamu(i1:i2,j1:j2)
      ELSE
      	 glamu(i1:i2,j1:j2) = ptab(i1:i2,j1:j2)
      ENDIF
      !
   END SUBROUTINE init_glamu

   SUBROUTINE init_glamv( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = glamv(i1:i2,j1:j2)
      ELSE
      	 glamv(i1:i2,j1:j2) = ptab(i1:i2,j1:j2)
      ENDIF
      !
   END SUBROUTINE init_glamv

   SUBROUTINE init_glamf( ptab, i1, i2, j1, j2,  before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_glamf  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = glamf(i1:i2,j1:j2)
      ELSE
      	 glamf(i1:i2,j1:j2) = ptab(i1:i2,j1:j2)
      ENDIF
      !
   END SUBROUTINE init_glamf

   SUBROUTINE init_gphit( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_gphit  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = gphit(i1:i2,j1:j2)
      ELSE
         gphit(i1:i2,j1:j2)=ptab
      ENDIF
      !
   END SUBROUTINE init_gphit

   SUBROUTINE init_gphiu( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_gphiu  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = gphiu(i1:i2,j1:j2)
      ELSE
         gphiu(i1:i2,j1:j2)=ptab
      ENDIF
      !
   END SUBROUTINE init_gphiu

   SUBROUTINE init_gphiv( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_gphiv  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------

      IF( before) THEN
         ptab(i1:i2,j1:j2) = gphiv(i1:i2,j1:j2)
      ELSE
         gphiv(i1:i2,j1:j2)=ptab
      ENDIF
      !
   END SUBROUTINE init_gphiv


   SUBROUTINE init_gphif( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_gphif  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = gphif(i1:i2,j1:j2)
      ELSE
         gphif(i1:i2,j1:j2)=ptab
      ENDIF
      !
   END SUBROUTINE init_gphif


   SUBROUTINE init_e1t( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      USE agrif_parameters
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_e1t  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      INTEGER :: jj

      IF( before) THEN
        ! May need to extend at south boundary
          IF (j1<1) THEN
            IF (.NOT.agrif_child(lk_south)) THEN
              IF ((nbondj == -1).OR.(nbondj == 2)) THEN
                DO jj=1,j2
                  ptab(i1:i2,jj)=e1t(i1:i2,jj)
                ENDDO
                DO jj=j1,0
                  ptab(i1:i2,jj)=e1t(i1:i2,1)
                ENDDO
              ENDIF
            ELSE
              stop "OUT OF BOUNDS"
            ENDIF
          ELSE
             ptab(i1:i2,j1:j2) = e1t(i1:i2,j1:j2)
          ENDIF
      ELSE
         e1t(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e1t

   SUBROUTINE init_e1u( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      USE agrif_parameters
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_e1u  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      INTEGER :: jj

      IF( before) THEN
          IF (j1<1) THEN
            IF (.NOT.agrif_child(lk_south)) THEN
              IF ((nbondj == -1).OR.(nbondj == 2)) THEN
                DO jj=1,j2
                  ptab(i1:i2,jj)=e1u(i1:i2,jj)
                ENDDO
                DO jj=j1,0
                  ptab(i1:i2,jj)=e1u(i1:i2,1)
                ENDDO
              ENDIF
            ELSE
              stop "OUT OF BOUNDS"
            ENDIF
          ELSE
             ptab(i1:i2,j1:j2) = e1u(i1:i2,j1:j2)
          ENDIF
      ELSE
         e1u(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e1u

   SUBROUTINE init_e1v( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_e1v  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = e1v(i1:i2,j1:j2)
      ELSE
         e1v(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e1v

   SUBROUTINE init_e1f( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_e1f  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = e1f(i1:i2,j1:j2)
      ELSE
         e1f(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e1f

   SUBROUTINE init_e2t( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      USE agrif_parameters
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE init_e2t  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      INTEGER :: jj

      IF( before) THEN
          IF (j1<1) THEN
            IF (.NOT.agrif_child(lk_south)) THEN
              IF ((nbondj == -1).OR.(nbondj == 2)) THEN
                DO jj=1,j2
                  ptab(i1:i2,jj)=e2t(i1:i2,jj)
                ENDDO
                DO jj=j1,0
                  ptab(i1:i2,jj)=e2t(i1:i2,1)
                ENDDO
              ENDIF
            ELSE
              stop "OUT OF BOUNDS"
            ENDIF
          ELSE
             ptab(i1:i2,j1:j2) = e2t(i1:i2,j1:j2)
          ENDIF
      ELSE
         e2t(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e2t

   SUBROUTINE init_e2u( ptab, i1, i2, j1, j2, before, nb,ndir)
   USE dom_oce
   USE agrif_parameters
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      INTEGER :: jj

      IF( before) THEN
          IF (j1<1) THEN
            IF (.NOT.agrif_child(lk_south)) THEN
              IF ((nbondj == -1).OR.(nbondj == 2)) THEN
                DO jj=1,j2
                  ptab(i1:i2,jj)=e2u(i1:i2,jj)
                ENDDO
                DO jj=j1,0
                  ptab(i1:i2,jj)=e2u(i1:i2,1)
                ENDDO
              ENDIF
            ELSE
              stop "OUT OF BOUNDS"
            ENDIF
          ELSE
             ptab(i1:i2,j1:j2) = e2u(i1:i2,j1:j2)
          ENDIF
      ELSE
         e2u(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e2u

   SUBROUTINE init_e2v( ptab, i1, i2, j1, j2, before, nb,ndir)
      USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      IF( before) THEN
         ptab(i1:i2,j1:j2) = e2v(i1:i2,j1:j2)
      ELSE
         e2v(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e2v

   SUBROUTINE init_e2f( ptab, i1, i2, j1, j2, before, nb,ndir)
   USE dom_oce
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!----------------------------------------------------------------------
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = e2f(i1:i2,j1:j2)
      ELSE
         e2f(i1:i2,j1:j2)=ptab/Agrif_rhoy()
      ENDIF
      !
   END SUBROUTINE init_e2f


   SUBROUTINE agrif_nemo_init
      USE agrif_parameters
      USE dom_oce
      USE in_out_manager
      USE lib_mpp
      !!
      IMPLICIT NONE

      INTEGER ::   ios

      NAMELIST/namagrif/ nn_cln_update,ln_spc_dyn,rn_sponge_tra,rn_sponge_dyn,ln_chk_bathy,npt_connect,   &
      &  npt_copy

      REWIND( numnam_ref )              ! Namelist namagrif in reference namelist : nesting parameters
      READ  ( numnam_ref, namagrif, IOSTAT = ios, ERR = 901 )
901   IF( ios /= 0 ) CALL ctl_nam ( ios , 'namagrif in reference namelist', lwp )

      REWIND( numnam_cfg )              ! Namelist namzgr in configuration namelist : nesting parameters
      READ  ( numnam_cfg, namagrif, IOSTAT = ios, ERR = 902 )
902   IF( ios /= 0 ) CALL ctl_nam ( ios , 'namagrif in configuration namelist', lwp )
      IF(lwm) WRITE ( numond, namagrif )

      IF(lwp) THEN                     ! Control print
         WRITE(numout,*)
         WRITE(numout,*) 'agrif_nemo_init : nesting'
         WRITE(numout,*) '~~~~~~~'
         WRITE(numout,*) '   Namelist namagrif : set nesting parameters'
         WRITE(numout,*) '      npt_copy             = ', npt_copy
         WRITE(numout,*) '      npt_connect          = ', npt_connect
      ENDIF

   ! Set the number of ghost cells according to periodicity

      nbghostcells_x = nbghostcells
      nbghostcells_y_s = nbghostcells
      nbghostcells_y_n = nbghostcells

      lk_west  = .NOT. ( Agrif_Ix() == 1 )
      lk_east  = .NOT. ( Agrif_Ix() + nbcellsx/AGRIF_Irhox() == Agrif_Parent(jpiglo) -1 )
      lk_south = .NOT. ( Agrif_Iy() == 1 )
      lk_north = .NOT. ( Agrif_Iy() + nbcellsy/AGRIF_Irhoy() == Agrif_Parent(jpjglo) -1 )

      IF (.not.agrif_root()) THEN
        IF (jperio == 1) THEN
          nbghostcells_x = 0
        ENDIF
        IF (.NOT.lk_south) THEN
          nbghostcells_y_s = 0
        ENDIF
      ENDIF

   END SUBROUTINE agrif_nemo_init

   SUBROUTINE Agrif_detect( kg, ksizex )
      !!----------------------------------------------------------------------
      !!                      *** ROUTINE Agrif_detect ***
      !!----------------------------------------------------------------------
      INTEGER, DIMENSION(2) :: ksizex
      INTEGER, DIMENSION(ksizex(1),ksizex(2)) :: kg
      !!----------------------------------------------------------------------
      !
      RETURN
      !
   END SUBROUTINE Agrif_detect

   SUBROUTINE agrif_before_regridding
   END SUBROUTINE agrif_before_regridding

# if defined  key_mpp_mpi
   SUBROUTINE Agrif_InvLoc( indloc, nprocloc, i, indglob )
         !!----------------------------------------------------------------------
         !!                     *** ROUTINE Agrif_InvLoc ***
         !!----------------------------------------------------------------------
      USE dom_oce
      !!
      IMPLICIT NONE
      !
      INTEGER :: indglob, indloc, nprocloc, i
         !!----------------------------------------------------------------------
      !
      SELECT CASE( i )
      CASE(1)   ;   indglob = indloc + nimppt(nprocloc+1) - 1
      CASE(2)   ;   indglob = indloc + njmppt(nprocloc+1) - 1
      CASE DEFAULT
         indglob = indloc
      END SELECT
      !
   END SUBROUTINE Agrif_InvLoc

   SUBROUTINE Agrif_get_proc_info( imin, imax, jmin, jmax )
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE Agrif_get_proc_info ***
      !!----------------------------------------------------------------------
      USE par_oce
      USE dom_oce
      !!
      IMPLICIT NONE
      !
      INTEGER, INTENT(out) :: imin, imax
      INTEGER, INTENT(out) :: jmin, jmax
         !!----------------------------------------------------------------------
      !
      imin = nimppt(Agrif_Procrank+1)  ! ?????
      jmin = njmppt(Agrif_Procrank+1)  ! ?????
      imax = imin + jpi - 1
      jmax = jmin + jpj - 1
      !
   END SUBROUTINE Agrif_get_proc_info

   SUBROUTINE Agrif_estimate_parallel_cost(imin, imax,jmin, jmax, nbprocs, grid_cost)
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE Agrif_estimate_parallel_cost ***
      !!----------------------------------------------------------------------
      USE par_oce
      !!
      IMPLICIT NONE
      !
      INTEGER,  INTENT(in)  :: imin, imax
      INTEGER,  INTENT(in)  :: jmin, jmax
      INTEGER,  INTENT(in)  :: nbprocs
      REAL(wp), INTENT(out) :: grid_cost
         !!----------------------------------------------------------------------
      !
      grid_cost = REAL(imax-imin+1,wp)*REAL(jmax-jmin+1,wp) / REAL(nbprocs,wp)
      !
   END SUBROUTINE Agrif_estimate_parallel_cost
# endif
#endif
