CREATE FUNCTION [dbo].[FN_GET_VOC_RUN_YN](
		@P_VALUE_STATUS NVARCHAR(max)
	)
      RETURNS NVARCHAR(30)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCM REPORT.
  * FUNCTION NAME : FN_GET_VOC_RUN_YN
  * DESCRIPTION   : DELAY YN
  *
  * INPUT         : @@P_VALUE_STATUS : 입력값
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2022-03-29   vadabi3		INITIAL
  *--------------------------------------------------------------
  SELECT dbo.FN_GET_VOC_RUN_YN(CLASSIFY_STATUS) FROM SCM_ADM_SYS_VOC
  ****************************************************************************/
BEGIN
  DECLARE @RUN_YN  NVARCHAR(20);
  SET @RUN_YN = 'N';
		------------------------------------------------------------------
		-- 체크 데이트 값이 의미 있는 값인지 확인
		------------------------------------------------------------------
		SELECT @RUN_YN = CASE 
						 WHEN @P_VALUE_STATUS = 'FH' THEN 'N'
						 WHEN @P_VALUE_STATUS = 'DR' THEN 'N'
						 WHEN @P_VALUE_STATUS = 'HD' THEN 'N'
						 ELSE 'Y'
						 END

		RETURN @RUN_YN;
END
;
