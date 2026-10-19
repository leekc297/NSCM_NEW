CREATE FUNCTION [dbo].[FN_GET_BUCKET_YYYYMMDD](@P_BUCKET_NO INT)
      RETURNS VARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_BUCKET_YYYYMMDD
  * DESCRIPTION   : 금주를 버킷번호0로 했을때, 입력버킷번호에 해당하는 시작일자
  *
  * INPUT         : @P_BUCKET_NO : 버킷번호
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2017-01-16   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @X_BUCKET_YYYYMMDD VARCHAR(8)
   
  SELECT  @X_BUCKET_YYYYMMDD =
          DBO.FN_DATE_TO_CHAR(DATEADD(D,0+7*@P_BUCKET_NO,CONVERT(DATETIME,DBO.FN_GET_START_YYYYMMDD(NULL),112)));  
	
  RETURN @X_BUCKET_YYYYMMDD;

END
;
