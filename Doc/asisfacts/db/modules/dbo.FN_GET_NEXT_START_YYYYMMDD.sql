CREATE FUNCTION [dbo].[FN_GET_NEXT_START_YYYYMMDD]
( @P_START_YYYYMMDD  VARCHAR(8),
  @P_BUCKET_NO INT)
      RETURNS VARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM RCCP PRJ.
  * FUNCTION NAME : FN_GET_NEXT_START_YYYYMMDD
  * DESCRIPTION   : 특정일자(월요일) 기준으로 버킷번호숫자만큼의 주차이후의 일자
  *
  * INPUT         : @P_START_YYYYMMDD,@P_BUCKET_NO : 버킷번호
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-16   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @X_NEXT_START_YYYYMMDD VARCHAR(8)
   
  SELECT  @X_NEXT_START_YYYYMMDD =
          DBO.FN_DATE_TO_CHAR(DATEADD(D,0+7*@P_BUCKET_NO,CONVERT(DATETIME,@P_START_YYYYMMDD,112)));  
	
  RETURN @X_NEXT_START_YYYYMMDD;

END
;
