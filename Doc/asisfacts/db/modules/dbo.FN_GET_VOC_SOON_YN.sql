CREATE FUNCTION [dbo].[FN_GET_VOC_SOON_YN](
		@P_VALUE_STATUS NVARCHAR(max)
	  , @P_VALUE_DATE NVARCHAR(max)
	)
      RETURNS NVARCHAR(30)
AS
/****************************************************************************
  * PROJECT       : LG CHEM SCM REPORT.
  * FUNCTION NAME : FN_GET_VOC_SOON_YN
  * DESCRIPTION   : SOON YN : 완료 일주일전 체크
  *
  * INPUT         : @strValue : 입력값
					@splitChar :구분자
  * PROGRAM HISTORY
  *--------------------------------------------------------------
  *  DATE      IN CHARGE           DESCRIPTION
  *--------------------------------------------------------------
  * 2022-02-21   vadabi3		INITIAL
  *--------------------------------------------------------------
  SELECT dbo.FN_GET_VOC_SOON_YN(CLASSIFY_STATUS,CLASSIFY_DATE) FROM SCM_ADM_SYS_VOC
  ****************************************************************************/

BEGIN
  
  DECLARE @CHECK_DATE NVARCHAR(20);
  DECLARE @SOON_YN  NVARCHAR(20);
  DECLARE @CONVERT_DATE DATETIME;
  DECLARE @SOON_DATE DATETIME;
  DECLARE @NOW_DATE DATETIME;
  DECLARE @V_VALUE_STATUS NVARCHAR(max);

  SET @CHECK_DATE = @P_VALUE_DATE;
  SET @SOON_YN = 'N';
  SET @V_VALUE_STATUS = @P_VALUE_STATUS;

  IF @V_VALUE_STATUS = ''
  begin
  SET @V_VALUE_STATUS = 'RN'
  end



		------------------------------------------------------------------
		-- 진행중인 경우만 체크 대상
		------------------------------------------------------------------
		IF @P_VALUE_DATE IS NULL
		BEGIN
			RETURN 'NO DATE';
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
		

					SET @SOON_YN = 'DATE ERROR';
					IF LEN(@CHECK_DATE) = 8
					BEGIN
					------------------------------------------------------------------
					-- 현재시간과 비교 
					------------------------------------------------------------------
					
					SELECT @CONVERT_DATE =  convert(datetime, @CHECK_DATE, 112);
					SELECT @SOON_DATE = convert(datetime, CONVERT(CHAR(8),GETDATE() + 7,112), 112);
					SELECT @NOW_DATE = convert(datetime, CONVERT(CHAR(8),GETDATE(),112), 112);
					SET @SOON_YN = 'OK'

						IF @CONVERT_DATE < @SOON_DATE AND @CHECK_DATE >= @NOW_DATE
						BEGIN
						SET @SOON_YN = 'Y'
						END
					END

			END

		RETURN @SOON_YN;

END
;

