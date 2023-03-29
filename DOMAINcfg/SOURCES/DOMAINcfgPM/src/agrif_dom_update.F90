MODULE agrif_dom_update

   USE dom_oce
   USE domzgr
   USE agrif_parameters
   USE agrif_profiles
   USE lbclnk
   
   IMPLICIT none
   PRIVATE

   PUBLIC agrif_update_all

CONTAINS 

#if defined key_agrif

   SUBROUTINE agrif_update_all
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE agrif_update_all  ***
      !!----------------------------------------------------------------------  
      !
      IF( Agrif_Root() ) return

      CALL agrif_update_variable(bottom_level_id,procname = update_bottom_level)
      !
      Agrif_UseSpecialValueInUpdate = .TRUE.
      Agrif_SpecialValueFineGrid    = 0._wp         
      CALL agrif_update_variable(e3t_id,procname = update_e3t)
      Agrif_UseSpecialValueInUpdate = .FALSE.
      !    
   END SUBROUTINE agrif_update_all

   SUBROUTINE update_bottom_level( ptab, i1, i2, j1, j2, before, nb,ndir)
      !!----------------------------------------------------------------------
      !!                  ***  ROUTINE interpsshn  ***
      !!----------------------------------------------------------------------  
      INTEGER                         , INTENT(in   ) ::   i1, i2, j1, j2
      REAL, DIMENSION(i1:i2,j1:j2)    , INTENT(inout) ::   ptab
      LOGICAL                         , INTENT(in   ) ::   before
      INTEGER                         , INTENT(in   ) ::   nb , ndir
      !
      !!---------------------------------------------------------------------- 
      REAL(WP),DIMENSION(jpi,jpj) :: zk
      !
      IF( before) THEN
         ptab(i1:i2,j1:j2) = mbkt(i1:i2,j1:j2)*ssmask(i1:i2,j1:j2)
      ELSE
         mbkt(i1:i2,j1:j2) = nint(ptab(i1:i2,j1:j2))
         
         WHERE ( mbkt(i1:i2,j1:j2) .EQ. 0 )
            ssmask(i1:i2,j1:j2) = 0.
            mbkt(i1:i2,j1:j2)   = 1
         ELSEWHERE
            ssmask(i1:i2,j1:j2) = 1.
         END WHERE 
         zk(:,:) = REAL(mbkt(:,:),wp); CALL lbc_lnk('update_bottom',zk,'T',1.); mbkt(:,:) = MAX(NINT(zk(:,:)),1)
         CALL lbc_lnk('update_bottom',ssmask,'T',1.)          
      ENDIF
      !
   END SUBROUTINE update_bottom_level
   
   SUBROUTINE update_e3t( tabres, i1, i2, j1, j2, k1, k2,  before )
      !!---------------------------------------------
      !!           *** update_e3t ***
      !!---------------------------------------------
      INTEGER, INTENT(in) :: i1,i2,j1,j2,k1,k2
      REAL(wp),DIMENSION(i1:i2,j1:j2,k1:k2), INTENT(inout) :: tabres
      LOGICAL, INTENT(in) :: before
      !!
      INTEGER :: ji,jj,jk
      !!---------------------------------------------
      !
      IF (before) THEN
         DO jk=k1,k2
            DO jj=j1,j2
               DO ji=i1,i2
                   IF( mbkt(ji,jj) .GE. jk ) THEN
                      tabres(ji,jj,jk) = e3t_0(ji,jj,jk)
                   ELSE
                      tabres(ji,jj,jk) = 0.
                   endif
               END DO
            END DO
         END DO
      ELSE
         DO jk=k1,k2
            DO jj=j1,j2
               DO ji=i1,i2
                   IF( mbkt(ji,jj) .GE. jk ) THEN
                      e3t_0(ji,jj,jk) = MAX(tabres(ji,jj,jk),MIN(e3zps_min,e3t_1d(jk)*e3zps_rat))
                   ELSE
                      e3t_0(ji,jj,jk) = e3t_1d(jk)
                   ENDIF
               END DO
            END DO
         END DO

         CALL lbc_lnk('update_e3t',e3t_0,'T',1.)
         !
      ENDIF
      ! 
   END SUBROUTINE update_e3t
      
#else
   SUBROUTINE agrif_update_all
   END SUBROUTINE agrif_update_all
#endif

END MODULE agrif_dom_update
