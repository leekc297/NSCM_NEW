CREATE FUNCTION [dbo].[FN_GET_BUCKET_NO](@P_YYYYMMDD VARCHAR(8))
      RETURNS INT
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_BUCKET_NO
  * DESCRIPTION   : 특정일자의 WEEKLY 버킷번호를 반환한다. 
  *                 엔진은 현재계획수립주차가 0이다.
  *
  * INPUT         : @P_YYYYMMDD : 년월일
  * OUTPUT        : 계획BUCKET번호
  * USAGE         : SELECT DBO.FN_GET_BUCKET_NO('20160530')
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-16   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @X_BUCKET_NO INT 
   
  SELECT  @X_BUCKET_NO =
          DATEDIFF(DAY,DATEADD(D,0,CONVERT(DATETIME,DBO.FN_GET_START_YYYYMMDD(NULL),112))
                     ,CONVERT(DATETIME,@P_YYYYMMDD,112)
  			           )/7;  

  IF @X_BUCKET_NO < 0 
     SET @X_BUCKET_NO = 0
	
  RETURN @X_BUCKET_NO;

END
;


