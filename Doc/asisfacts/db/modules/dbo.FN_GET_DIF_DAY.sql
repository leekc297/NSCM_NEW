
CREATE FUNCTION [dbo].[FN_GET_DIF_DAY](
	@P_POSTING_DATE	NCHAR(8),
	 @P_INPUT_DATE	NCHAR(8)
	)
      RETURNS NVARCHAR(8)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCM PRJ.
  * FUNCTION NAME : FN_GET_DIF_DAY
  * DESCRIPTION   : @P_INPUT_DATE 에 @P_POSTING_DATE를 뺀 날짜차이를 리턴함.
  *
  * INPUT         : @P_POSTING_DATE : 매출 발생 일자
					@P_INPUT_DATE : 입력 일자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2021-12-24   ROSIA27		INITIAL
  ****************************************************************************/
BEGIN

	DECLARE @MIN_DATE NCHAR(8)

	SELECT @MIN_DATE = MIN(BASIS_YYYYMMDD)
	FROM SCM_SYS_CALENDAR_M
	WHERE BASIS_YYYYMMDD > @P_POSTING_DATE
		AND DAYOFWEEK NOT IN ( 'SAT', 'SUN')

	RETURN (SELECT CASE WHEN @P_INPUT_DATE <= @MIN_DATE THEN 'TRUE' ELSE 'FALSE' END)

END
;

