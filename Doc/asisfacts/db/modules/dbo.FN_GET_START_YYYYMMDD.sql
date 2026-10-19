CREATE FUNCTION [dbo].[FN_GET_START_YYYYMMDD](@P_YYYYWW VARCHAR(8))
      RETURNS VARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_START_YYYYMMDD
  * DESCRIPTION   : 특정년주차(YYYYWW)의 시작일자YYYYMMDD한다. 
  *
  * INPUT         : @P_YYYYWW : 년주차YYYYWW
  * OUTPUT        : 해당주차의 시작일자 YYYYMMDD
  * USAGE         : 
  *                SELECT DBO.FN_GET_START_YYYYMMDD('201622');
  *
  *                SELECT DBO.FN_GET_START_YYYYMMDD(NULL);
  *
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-16   YYDOK        INITIAL
  * 2017-05-01   YYDOK        BASIS START DATE가 PARTIAL WEEK기준이라,FULL WEEK기준으로 변경함
  *                           ( MIN(BASIS_YYYYMMDD ) )
  ****************************************************************************/
BEGIN
  
   DECLARE @X_YYYYMMDD CHAR(8)

   IF @P_YYYYWW IS NULL

      SELECT @X_YYYYMMDD = MIN(B.BASIS_YYYYMMDD)
       FROM DBO.SCM_SYS_CALENDAR_M B WITH(NOLOCK)
	   WHERE B.ISO_YYYYWW = ( SELECT TOP 1 X.ISO_YYYYWW 
                              FROM DBO.SCM_SYS_CALENDAR_M X WITH(NOLOCK)
                             WHERE X.BASIS_YYYYMMDD = CONVERT(CHAR(8),GETDATE(),112))
         ;

   ELSE

     SELECT TOP 1 @X_YYYYMMDD = MIN(B.BASIS_YYYYMMDD)
       FROM DBO.SCM_SYS_CALENDAR_M B  WITH(NOLOCK)
	   WHERE B.ISO_YYYYWW = @P_YYYYWW;
    
	
  RETURN @X_YYYYMMDD;

END
;
