
/*
 * PROJECT       : LG CHEM SCP PRJ.
 * FUNCTION NAME : FN_GET_SCM_SITE_TO_PLANT
 * DESCRIPTION   : PLANT  RETURN
 * INPUT         : SITE_ID
 * OUTPUT        : UOM
 * PROGRAM HISTORY
 *----------------------------------------------------------------------------
   DATE      IN CHARGE           DESCRIPTION
 *----------------------------------------------------------------------------
 * 2022-07-21   vadabi3        INITIAL
 * 2024-06-09   vadabi5        NERP) SCM Site 로 Plant ID 찾는 로직 정의
 * 2024-12-14   vadabi5        NERP) 복합 구분자 개선	
 -----------------------------------------------------------------------------	
  select dbo.FN_GET_SCM_SITE_TO_PLANT('A010-A')
  select dbo.FN_GET_SCM_SITE_TO_PLANT('IM_Re-CN_NGG')
  select dbo.FN_GET_SCM_SITE_TO_PLANT('IM-Re_CN_NGG')
  --select dbo.NERP_FN_GET_SCM_SITE_TO_PLANT('A010-A')
 */

CREATE FUNCTION [dbo].[FN_GET_SCM_SITE_TO_PLANT]
      (
       @P_SITE_ID      NVARCHAR(30)                   
      )
       RETURNS NVARCHAR(100)
       WITH EXEC AS CALLER       
AS


 
BEGIN
    DECLARE @X_PLANT            NVARCHAR(100)= NULL;
 ------------------------------------------------------------------------- 
 -- 2차 변경소스
 ------------------------------------------------------------------------- 
    SELECT @X_PLANT =      CASE WHEN charindex( '-', @P_SITE_ID) > 0 AND charindex( '_', @P_SITE_ID) > 0 and charindex( '-', @P_SITE_ID) > charindex( '_', @P_SITE_ID)    
								THEN dbo.FN_SCM_SPLIT(@P_SITE_ID,0,'-')
								WHEN charindex( '-', @P_SITE_ID) > 0 AND charindex( '_', @P_SITE_ID) > 0 and charindex( '-', @P_SITE_ID) < charindex( '_', @P_SITE_ID)  
								THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(@P_SITE_ID,0,'_'),0,'-')
								WHEN charindex( '-', @P_SITE_ID) > 0 
								THEN dbo.FN_SCM_SPLIT(@P_SITE_ID,0,'-')
								WHEN charindex( '_', @P_SITE_ID) > 0
								THEN dbo.FN_SCM_SPLIT(@P_SITE_ID,0,'_')
								ELSE @P_SITE_ID
								END



 ------------------------------------------------------------------------- 
 -- 1차 변경소스 : 함수 호출로 속도 문제 고려
 ------------------------------------------------------------------------- 
    -- SELECT @X_PLANT = [dbo].[FN_SCM_SPLIT](@P_SITE_ID,1,'-')

 ------------------------------------------------------------------------- 
 -- ASIS 소스
 ------------------------------------------------------------------------- 
 /*
   DECLARE @X_PLANT            NVARCHAR(100)= NULL;
   DECLARE @X_POSITION         INT = 0;
   DECLARE @X_CHAR             NVARCHAR(2)= NULL;

   SET @X_CHAR = '_';
   SELECT @X_POSITION = CHARINDEX( @X_CHAR, @X_PLANT);
   IF(@X_POSITION > 0 )
	SELECT @X_PLANT = LEFT(@X_PLANT, CHARINDEX( @X_CHAR, @X_PLANT)-1)  


   SET @X_CHAR = '-';
   SELECT @X_POSITION = CHARINDEX( @X_CHAR, @X_PLANT);
   IF(@X_POSITION > 0 )
    SELECT @X_PLANT = LEFT(@X_PLANT, CHARINDEX( @X_CHAR, @X_PLANT)-1)  
 */



   RETURN  @X_PLANT;

END
;
