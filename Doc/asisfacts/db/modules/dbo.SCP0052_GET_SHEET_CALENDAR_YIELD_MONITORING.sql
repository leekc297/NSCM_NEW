/****************************************************************************************************
* Program ID  : SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING                                                       
* Description : SCP0052 YIELD MONITORING TAB 달력 생성위한 프로시저                                                       
* Usage       : exec SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING													
* Parameter   : @p_from_yyyymm='202101',@p_to_yyyymm='202108'                                                     
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2021/09/02  kmj	      [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - initial release
* 2021/11/16  KMJ         [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GREEN -> YELLOW -> RED 순서로 변경
* ex)
* EXEC SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING @p_from_yyyymm='202101', @p_to_yyyymm='202108', @p_check_accuracy='N';
****************************************************************************************************/



CREATE PROCEDURE [dbo].[SCP0052_GET_SHEET_CALENDAR_YIELD_MONITORING]
	@p_from_yyyymm		NVARCHAR(6)
	, @p_to_yyyymm		NVARCHAR(6)
	, @p_check_accuracy NVARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @v_start_month		NVARCHAR(6);
	DECLARE @v_end_month		NVARCHAR(6);
	DECLARE @v_check_accuracy	NVARCHAR(1);

	SET @v_start_month		= @p_from_yyyymm ;
	SET @v_end_month		= @p_to_yyyymm;
	SET @v_check_accuracy	= @p_check_accuracy;

	IF @v_check_accuracy = 'N'
	BEGIN
	
		WITH AA AS (
			SELECT
				A.COLUMN_NAME								AS COL
				, A.COLUMN_LABEL_NAME						AS COL_NAME
			FROM SCM_MST_SHEET_COLUMNS A WITH(NOLOCK) 
			WHERE 1=1
			AND A.PROGRAM_ID  = 'SCP0052'
			AND A.SHEET_NAME  = 'Yield Monitoring'
			AND A.COLUMN_NAME IN  ('GREEN', 'YELLOW', 'RED', 'GAP')
	
		)
		SELECT 'M_' + A.BASIS_YYYYMM	AS COLUMN_NAME
		  , A.MONTH_NAME			AS COLUMN_LABEL_NAME
		  , A.MONTH_NAME			AS SMALL_CLASS_LABEL_NAME
		  , A.MONTH_NAME			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
		  , 'G_' + A.BASIS_YYYYMM AS G_COL
		  , (SELECT COL_NAME FROM AA WHERE COL = 'GREEN') AS G_COLNAME
		  , 'Y_' + A.BASIS_YYYYMM AS Y_COL
		  , (SELECT COL_NAME FROM AA WHERE COL = 'YELLOW') AS Y_COLNAME
		  , 'R_' + A.BASIS_YYYYMM AS R_COL
		  , (SELECT COL_NAME FROM AA WHERE COL = 'RED') AS R_COLNAME
		  , 'A_' + A.BASIS_YYYYMM AS A_COL
		  , (SELECT COL_NAME FROM AA WHERE COL = 'GAP') AS A_COLNAME

		  FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
		 WHERE A.BASIS_YYYYMM >= @v_start_month
		   AND A.BASIS_YYYYMM <= @v_end_month
		 GROUP BY A.BASIS_YYYYMM
			 , A.MONTH_NAME
		;
	
	END

	ELSE
	BEGIN

		WITH AA AS (
			SELECT
				A.COLUMN_NAME								AS COL
				, A.COLUMN_LABEL_NAME						AS COL_NAME
			FROM SCM_MST_SHEET_COLUMNS A WITH(NOLOCK) 
			WHERE 1=1
			AND A.PROGRAM_ID  = 'SCP0052'
			AND A.SHEET_NAME  = 'Yield Monitoring'
			AND A.COLUMN_NAME = 'GAP'
		)
		SELECT 'M_' + A.BASIS_YYYYMM	AS COLUMN_NAME
		  , A.MONTH_NAME			AS COLUMN_LABEL_NAME
		  , A.MONTH_NAME			AS SMALL_CLASS_LABEL_NAME
		  , A.MONTH_NAME			AS LARGE_CLASS_LABEL_NAME
		  , ''						AS DAY_CODE
		  , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
		  , 'A_' + A.BASIS_YYYYMM AS A_COL
		  , (SELECT COL_NAME FROM AA WHERE COL = 'GAP') AS A_COLNAME

		  FROM [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
		 WHERE A.BASIS_YYYYMM >= @v_start_month
		   AND A.BASIS_YYYYMM <= @v_end_month
		 GROUP BY A.BASIS_YYYYMM
			 , A.MONTH_NAME
		;


	END

END
