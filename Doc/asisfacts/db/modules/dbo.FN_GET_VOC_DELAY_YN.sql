CREATE FUNCTION [dbo].[FN_GET_VOC_DELAY_YN](
		@P_VALUE_STATUS NVARCHAR(max)
	  , @P_VALUE_DATE NVARCHAR(max)
	)
      RETURNS NVARCHAR(30)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCM REPORT.
  * FUNCTION NAME : FN_GET_VOC_DELAY_YN
  * DESCRIPTION   : DELAY YN
  *
  * INPUT         : @strValue : 입력값
					@splitChar :구분자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2022-02-21   vadabi3		INITIAL
  *--------------------------------------------------------------
  SELECT dbo.FN_GET_VOC_DELAY_YN(CLASSIFY_STATUS,CLASSIFY_DATE) FROM SCM_ADM_SYS_VOC
  ****************************************************************************/

BEGIN
  
  DECLARE @CHECK_DATE NVARCHAR(20);
  DECLARE @DELAY_YN  NVARCHAR(20);
  DECLARE @CONVERT_DATE DATETIME;
  DECLARE @NOW_DATE DATETIME;
  DECLARE @V_VALUE_STATUS NVARCHAR(max);
  SET @V_VALUE_STATUS = @P_VALUE_STATUS;

  IF @V_VALUE_STATUS = '' OR @V_VALUE_STATUS is null
  begin
  SET @V_VALUE_STATUS = 'RN'
  end

  SET @CHECK_DATE = @P_VALUE_DATE;
  SET @DELAY_YN = 'N';

		------------------------------------------------------------------
		-- 진행중인 경우만 체크 대상
		------------------------------------------------------------------
		IF @P_VALUE_DATE IS NULL
		BEGIN
			RETURN 'NULL';
		END

		IF @V_VALUE_STATUS != 'RN'
		BEGIN
			RETURN 'NO RUN';
		END

		------------------------------------------------------------------
		-- 체크 데이트 값이 의미 있는 값인지 확인
		------------------------------------------------------------------
		IF LEN(@P_VALUE_DATE) > 10
			BEGIN
				------------------------------------------------------------------
				-- 완료일 수정 = 2번째 날자값이 대상
				------------------------------------------------------------------
	
				SELECT @CHECK_DATE =  VAL FROM [dbo].[FN_GET_VOC_SPLIT] (@P_VALUE_DATE,char(13) + char(10)) WHERE POS = 2;
				
				SELECT @CHECK_DATE =  LTRIM(@CHECK_DATE);
				SELECT @CHECK_DATE =  RTRIM(@CHECK_DATE);
				SELECT @CHECK_DATE =  REPLACE(@CHECK_DATE,'-','');
		

					SET @DELAY_YN = 'DATE ERROR';
					IF LEN(@CHECK_DATE) = 8
					BEGIN
					------------------------------------------------------------------
					-- 현재시간과 비교 
					------------------------------------------------------------------
					
					SELECT @CONVERT_DATE =  convert(datetime, @CHECK_DATE, 112);
					SELECT @NOW_DATE = convert(datetime, CONVERT(CHAR(8),GETDATE(),112), 112);
					SET @DELAY_YN = 'OK'

						IF @CONVERT_DATE < @NOW_DATE
						BEGIN
						SET @DELAY_YN = 'Y'
						END
					END

			END

		RETURN @DELAY_YN;

END
;
