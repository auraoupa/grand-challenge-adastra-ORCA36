MODULE agrif_connect

   USE dom_oce
   USE domzgr
   USE agrif_parameters
   USE agrif_profiles

   IMPLICIT NONE
   PRIVATE

   PUBLIC agrif_boundary_connections 

CONTAINS

#if defined key_agrif

   SUBROUTINE agrif_boundary_connections
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE agrif_boundary_connections  ***
      !!----------------------------------------------------------------------  
      IF( Agrif_Root() ) return

      CALL agrif_connection()
      !
      CALL Agrif_Bc_variable(bottom_level_id, procname = connect_bottom_level)
      ! 
      CALL Agrif_Bc_variable(e3t_copy_id, procname = connect_e3t_copy)

      ALLOCATE(e3t_interp(jpi,jpj,jpk))
      e3t_interp = -10.
      Agrif_UseSpecialValue = .FALSE.
      Agrif_SpecialValue = 0.
      CALL Agrif_Bc_variable(e3t_connect_id, procname = connect_e3t_connect)
      Agrif_UseSpecialValue = .FALSE.
      !    
   END SUBROUTINE agrif_boundary_connections

   SUBROUTINE connect_e3t_copy( ptab, i1, i2, j1, j2, k1, k2, before, nb,ndir)
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE connect_e3t_copy  ***
      !!----------------------------------------------------------------------  
      INTEGER                               , INTENT(in   ) ::   i1, i2, j1, j2, k1, k2
      REAL(wp), DIMENSION(i1:i2,j1:j2,k1:k2), INTENT(inout) ::   ptab
      LOGICAL                               , INTENT(in   ) ::   before
      INTEGER                               , INTENT(in   ) ::   nb , ndir
      !
      !!---------------------------------------------------------------------- 
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2,k1:k2) = e3t_0(i1:i2,j1:j2,k1:k2)
      ELSE
         e3t_0(i1:i2,j1:j2,k1:k2) = ptab(i1:i2,j1:j2,k1:k2)
      ENDIF
      !
   END SUBROUTINE connect_e3t_copy
   
   SUBROUTINE connect_bottom_level( ptab, i1, i2, j1, j2, before, nb,ndir)
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE connect_bottom_level  ***
      !!----------------------------------------------------------------------  
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL(wp), DIMENSION(i1:i2,j1:j2), INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!---------------------------------------------------------------------- 
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = mbkt(i1:i2,j1:j2)*ssmask(i1:i2,j1:j2)
      ELSE
         mbkt(i1:i2,j1:j2) = nint(ptab(i1:i2,j1:j2))
         WHERE (mbkt(i1:i2,j1:j2)==0)
           ssmask(i1:i2,j1:j2) = 0.
         ELSEWHERE
           ssmask(i1:i2,j1:j2) = 1.
         END WHERE           
      ENDIF
      !
   END SUBROUTINE connect_bottom_level
   
   SUBROUTINE connect_e3t_connect( ptab, i1, i2, j1, j2, k1, k2, before, nb,ndir)
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE connect_e3t_connect  ***
      !!----------------------------------------------------------------------  
      INTEGER                               , INTENT(in   ) ::   i1, i2, j1, j2, k1, k2
      REAL(wp), DIMENSION(i1:i2,j1:j2,k1:k2), INTENT(inout) ::   ptab
      LOGICAL                               , INTENT(in   ) ::   before
      INTEGER                               , INTENT(in   ) ::   nb , ndir
      !
      !!---------------------------------------------------------------------- 
      INTEGER :: ji, jj, jk 
      REAL(wp), DIMENSION(i1:i2,j1:j2) :: bathy_local, bathy_interp
      REAL(wp) :: zdepth, zmax 
      !
      IF( before) THEN
         DO jk=1,jpk
            DO jj=j1,j2
               DO ji=i1,i2
                  IF( mbkt(ji,jj) .GE. jk ) THEN
                     ptab(ji,jj,jk) = e3t_0(ji,jj,jk)
                  ELSE
                     ptab(ji,jj,jk) = 0.
                  ENDIF
               END DO
            END DO
         END DO
         !
         DO jj=j1,j2
            DO ji=i1,i2
               ptab(ji,jj,jpk+1) = SUM ( e3t_0(ji,jj, 1:mbkt(ji,jj) ) ) * ssmask(ji,jj)
            END DO
         END DO
      ELSE
         DO jj=j1,j2
            DO ji=i1,i2
               bathy_local (ji,jj) = SUM ( e3t_0(ji,jj, 1:mbkt(ji,jj) ) ) * ssmask(ji,jj)
               bathy_interp (ji,jj) = ptab(ji,jj,jpk+1)

        ! Connected bathymetry
               bathy_local(ji,jj)=(1.-ztabramp(ji,jj))*bathy_local(ji,jj)+ztabramp(ji,jj)*bathy_interp(ji,jj)
            END DO
         END DO

        ! Update mbkt and ssmask
         zmax = gdepw_1d(jpk) + e3t_1d(jpk)
         bathy_local(:,:) = MAX(MIN(zmax,bathy_local(:,:)),0._wp)
         WHERE( bathy_local(i1:i2,j1:j2) == 0._wp); mbathy(i1:i2,j1:j2) = 0
         ELSE WHERE                       ; mbathy(i1:i2,j1:j2) = jpkm1
         END WHERE

         DO jk=jpkm1,1,-1
           zdepth = gdepw_1d(jk)+MIN(e3zps_min,e3t_1d(jk)*e3zps_rat)
           WHERE( 0._wp < bathy_local(:,:) .AND. bathy_local(:,:) <= zdepth ) mbathy(i1:i2,j1:j2) = jk-1
         ENDDO

         WHERE (mbathy(i1:i2,j1:j2) == 0); ssmask(i1:i2,j1:j2) = 0
         ELSE WHERE                      ; ssmask(i1:i2,j1:j2) = 1.
         END WHERE
         
         mbkt(i1:i2,j1:j2) = MAX( mbathy(i1:i2,j1:j2), 1 )

         !
         DO jk=1,jpk
            DO jj=j1,j2
               DO ji=i1,i2
                  IF( e3t_interp(ji,jj,jk) == -10 ) THEN ! the connection has not yet been done
                     e3t_interp(ji,jj,jk) = MAX( ptab(ji,jj,jk),MIN(e3zps_min, e3t_1d(jk)*e3zps_rat) )
                     e3t_interp(ji,jj,jk) = MIN( e3t_interp(ji,jj,jk),e3t_1d(jk) )
                     e3t_0(ji,jj,jk) = ( 1. - ztabramp(ji,jj) )*e3t_0(ji,jj,jk) + ztabramp(ji,jj)*e3t_interp(ji,jj,jk)
                  ENDIF
                  IF( jk > mbkt(ji,jj)) THEN
                    e3t_0(ji,jj,jk) = e3t_1d(jk)
                  ENDIF
             END DO
           END DO
         END DO
      ENDIF
      !
   END SUBROUTINE connect_e3t_connect
   
   SUBROUTINE agrif_connection
      !!----------------------------------------------------------------------
      !!                 *** ROUTINE  Agrif_connection ***
      !!----------------------------------------------------------------------
      INTEGER  ::   ji, jj, ind1, ind2
      INTEGER  ::   ispongearea, istart
      REAL(wp) ::   z1_spongearea
      !!----------------------------------------------------------------------
      !
      ! Define ramp from boundaries towards domain interior at T-points
      ! Store it in ztabramp

      ALLOCATE(ztabramp(jpi,jpj))
      ispongearea = 1 + npt_connect * Agrif_irhox()
      istart = npt_copy * Agrif_irhox()
      z1_spongearea = 1._wp / REAL( ispongearea, wp )
      
      ztabramp(:,:) = 0._wp

      ! --- West --- !
      IF( ((nbondi == -1) .OR. (nbondi == 2) ).AND. .NOT. (jperio == 1 .OR. jperio == 4 .OR. jperio == 6)) THEN
         ind1 = 1+nbghostcells + istart
         ind2 = ind1 + ispongearea 
         DO jj = 1, jpj
            DO ji = ind1, ind2                
               ztabramp(ji,jj) = REAL( ind2 - ji ) * z1_spongearea * umask(ind1,jj,1)
            END DO
         ENDDO
      ENDIF

      ! --- East --- !
      IF( ((nbondi == 1) .OR. (nbondi == 2) ).AND. .NOT. (jperio == 1 .OR. jperio == 4 .OR. jperio == 6)) THEN
         ind2 = nlci - nbghostcells - istart
         ind1 = ind2 -ispongearea       
         DO jj = 1, jpj
            DO ji = ind1, ind2
               ztabramp(ji,jj) = MAX( ztabramp(ji,jj), REAL( ji - ind1 ) * z1_spongearea * umask(ind2-1,jj,1) )
            ENDDO
         ENDDO
      ENDIF

      ! --- South --- !
      IF(( (nbondj == -1) .OR. (nbondj == 2) ).AND.(lk_south)) THEN
         ind1 = 1+nbghostcells + istart
         ind2 = ind1 + ispongearea 
         DO jj = ind1, ind2 
            DO ji = 1, jpi
               ztabramp(ji,jj) = MAX( ztabramp(ji,jj), REAL( ind2 - jj ) * z1_spongearea * vmask(ji,ind1,1) )
            END DO
         ENDDO
      ENDIF

      ! --- North --- !
      IF( (nbondj == 1) .OR. (nbondj == 2) ) THEN
         ind2 = nlcj - nbghostcells - istart
         ind1 = ind2 -ispongearea         
         DO jj = ind1, ind2
            DO ji = 1, jpi
               ztabramp(ji,jj) = MAX( ztabramp(ji,jj), REAL( jj - ind1 ) * z1_spongearea * vmask(ji,ind2-1,1) )
            END DO
         ENDDO
      ENDIF
      !
   END SUBROUTINE agrif_connection

#else
   SUBROUTINE agrif_boundary_connections
   END SUBROUTINE agrif_boundary_connections
#endif

END MODULE agrif_connect
