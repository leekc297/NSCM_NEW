/****************************************************************************************************
* Program ID  : SCP0049_GET_SHEET_CALENDAR                                                       
* Description : SCP0049 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0049_GET_SHEET_CALENDAR													
* Parameter   : @p_today_yyyymmdd='201712'                                                     
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2020/05/20  khj79	       [PJ20199555] 공급 대응력 향상을 위한 자재재공 수급 점검 체계 개선 - 기준정보
* 2021/07/08   khj79       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 2년 조회 변경 (24+5)
* 2021/07/22   khj79       [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 3년 조회 변경 (36+5)
* ex)
* EXEC SCP0049_GET_SHEET_CALENDAR @p_today_yyyymm ='20180122'
****************************************************************************************************/



CREATE PROCEDURE [dbo].[SCP0049_GET_SHEET_CALENDAR]
	@p_today_yyyymmdd  NVARCHAR(8)
	, @p_from_yyyymm NVARCHAR(6)
	, @p_to_yyyymm NVARCHAR(6)
	, @p_bucket		NVARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_check_daily		CHAR(1) = 'N'; 

	DECLARE @v_start_day NVARCHAR(8);
	DECLARE @v_end_day NVARCHAR(8);

	DECLARE @v_start_month NVARCHAR(6);
	DECLARE @v_end_month NVARCHAR(6);

	DECLARE @v_start_year NVARCHAR(4);
	DECLARE @v_end_year NVARCHAR(4);

	DECLARE @v_max_day NVARCHAR(8) ; -- 기준일 Y+1 까지만 조회 가능
	SET @v_max_day = CONVERT(NVARCHAR(4),DATEADD(YY,3, @p_today_yyyymmdd ),112) + '1231';  -- 3(36+5)년 조회 변경 ( 2 => 3)
	SET @v_max_day = CONVERT(NVARCHAR(4),DATEADD(MM,5, @v_max_day ),112) + '1231';		   -- 3(36+5)년 조회 변경 ( 1 => 2)

	DECLARE @v_max_year  NVARCHAR(8) ; -- 기준일 Y+5 까지만 조회 가능
	SET @v_max_year = CONVERT(NVARCHAR(4),DATEADD(YY,5, @p_today_yyyymmdd ),112) + '1231';

	IF ( CHARINDEX( 'D' , @p_bucket) >0 ) 	BEGIN SET @v_check_daily = 'Y'; END;

	-- Daily 체크 시 일별 조회 안되도록 수정
	IF @v_check_daily = 'Y'
	BEGIN
		-- 기준일 Y+1 년 과 조회 마지막 일자를 비교하여 조회일 설정
		IF  DATEDIFF(MM , @v_max_day , @p_to_yyyymm + '01')   > 0
		BEGIN
			SET @v_start_day = CONVERT(CHAR(6) , @p_today_yyyymmdd) + '01';
			SET @v_end_day = CONVERT(NVARCHAR(6),@v_max_day,112) + '31';  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회
			SET @v_start_month = CONVERT(CHAR(6) , @p_today_yyyymmdd);
			SET @v_end_month = CONVERT(NVARCHAR(6),@v_max_day,112);  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회
		END
		ELSE
		BEGIN
			-- 조회일자가 기준을 넘지 않을 경우 파라미터로 설정
			SET @v_start_day = CONVERT(CHAR(6) , @p_today_yyyymmdd) + '01';
			SET @v_end_day = @p_to_yyyymm + '31';
			SET @v_start_month = CONVERT(CHAR(6) , @p_today_yyyymmdd);
			SET @v_end_month= @p_to_yyyymm;
		END
	END
	ELSE
	BEGIN
		SET @v_start_day = '999999' ;  -- 일자 조회 않되도록 설정
		SET @v_end_day = '999999' ;    -- 일자 조회 않되도록 설정
		-- 기준일 Y+1 년 과 조회 마지막 일자를 비교하여 조회일 설정
		IF  DATEDIFF(MM , @v_max_day , @p_to_yyyymm + '01')   > 0
		BEGIN
			SET @v_start_month = CONVERT(CHAR(6) , @p_today_yyyymmdd);
			SET @v_end_month = CONVERT(NVARCHAR(6),@v_max_day,112);  -- 조회일자가 기준을 넘을 경우 Y+1 으로 조회
		END
		ELSE
		BEGIN
			SET @v_start_month = CONVERT(CHAR(6) , @p_today_yyyymmdd);
			SET @v_end_month= @p_to_yyyymm;
		END
	END
	
	IF  DATEDIFF(MM , @v_max_day , @p_to_yyyymm + '01')   > 0
	BEGIN
		SET @v_start_year  = '9999';
		SET @v_end_year   ='9999';
	END
	BEGIN
		SET @v_start_year  = CONVERT(NVARCHAR(4), DATEADD(YY,4, @p_today_yyyymmdd) , 112) ;   -- 3년 조회 변경 ( 3 => 4)
		SET @v_end_year   = CONVERT(NVARCHAR(4), @p_to_yyyymm) ;
	END

	SELECT 'D_' + A.BASIS_YYYYMMDD		AS COLUMN_NAME
		  , A.CALENDAR_DAY				AS COLUMN_LABEL_NAME
		  , A.WEEK_NAME					AS SMALL_CLASS_LABEL_NAME
		  , A.MONTH_NAME				AS LARGE_CLASS_LABEL_NAME
		  , A.DAYOFWEEK					AS DAY_CODE
		  , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
	   FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	  WHERE A.BASIS_YYYYMMDD >= @v_start_day
		AND A.BASIS_YYYYMMDD <= @v_end_day

	  UNION ALL

	 SELECT 'M_' + A.BASIS_YYYYMM	AS COLUMN_NAME
		  , A.MONTH_NAME			AS COLUMN_LABEL_NAME
		  , A.MONTH_NAME			AS SMALL_CLASS_LABEL_NAME
		  , A.MONTH_NAME			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
	   FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	  WHERE A.BASIS_YYYYMM >= @v_start_month
		AND A.BASIS_YYYYMM <= @v_end_month
	  GROUP BY A.BASIS_YYYYMM
			 , A.MONTH_NAME

	  UNION ALL

	 SELECT 'Y_'+ A.CALENDAR_YYYY	AS COLUMN_NAME
		  , A.CALENDAR_YYYY			AS COLUMN_LABEL_NAME
		  , A.CALENDAR_YYYY			AS SMALL_CLASS_LABEL_NAME
		  , A.CALENDAR_YYYY			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , CALENDAR_YYYY + CONVERT(CHAR(6), '123132') AS SORT_ORDER_NO
	  FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	 WHERE A.CALENDAR_YYYY >= @v_start_year
	   AND A.CALENDAR_YYYY <= @v_end_year
	 GROUP BY A.CALENDAR_YYYY
	ORDER BY sort_order_no

END


