CREATE FUNCTION [dbo].[FN_GET_BUCKET_YYYYMMDD_DW](@P_BUCKET_NO INT)
      RETURNS VARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCP PRJ.
  * FUNCTION NAME : FN_GET_BUCKET_YYYYMMDD_DW
  * DESCRIPTION   : 금주를 버킷번호0로 했을때, 입력버킷번호에 해당하는 시작일자
  *                 단,현재일자의 요일이 월,화이면 이전주 시작일자를 리턴
  *
  * INPUT         : @P_BUCKET_NO : 버킷번호
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2018-01-16   YYDOK        INITIAL
  ****************************************************************************/
BEGIN
  
  DECLARE @X_BUCKET_YYYYMMDD VARCHAR(8)
  DECLARE @X_DW INTEGER

  SELECT @X_DW = DATEPART(DW,GETDATE());

  -- DAY OF WEEK이 월요일(2),화요일(3)이면 일주일을 뺀다
  IF @X_DW=2 OR @X_DW=3 
     SET @P_BUCKET_NO = @P_BUCKET_NO -1;
   
  SELECT  @X_BUCKET_YYYYMMDD =
          DBO.FN_DATE_TO_CHAR(DATEADD(D,0+7*@P_BUCKET_NO,CONVERT(DATETIME,DBO.FN_GET_START_YYYYMMDD(NULL),112)));  
	
  RETURN @X_BUCKET_YYYYMMDD;

END
;
