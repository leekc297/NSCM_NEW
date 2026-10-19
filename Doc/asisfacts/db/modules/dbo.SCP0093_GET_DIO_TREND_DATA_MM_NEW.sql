
/*
 * Program ID   : SCP0093_GET_DIO_TREND_DATA_MM
 * Description  : SCP0093 DIO TREND Report 화면의 월별 조회
 * Program History
 *========================================================================================================
 *   Date       In Charge		Description
 *========================================================================================================
 * 2022/09/26   hrkim			Query
 * 2022/09/26   vadabi3			최초생성
 * 2022/10/04   vadabi3			조회조건 추가 및 수정
 * 2022/10/21   hrkim			양품 및 OP L/T Except measure 계산 로직 추가
 * 2022/10/28   hrkim			당월포함~미래 조회기간 PROD 수량에 대한 수율 정보 추가
 * 2022/11/02   hrkim		    model/nick_name 다중 필터링 적용
 * 2022/11/10   hrkim			수율 참조 변경
 *						         - 변경전 : 미래구간(조회기간) 재고 생성시 적용된 수율
 *							     - 변경후 : 모델별/셀그룹별 수율 master정보의 max값
 * 2022/11/16	hrkim			합계 및 기타충당금 추가
 * 2022/11/18   hrkim			Category별 합계 - GAP Measure 추가 (기타충당금 반영된 값으로 계산 필요)
 * 2022/11/21   hrkim			UI 기타충당금 수정시 필요한 SCP_RPT_DIO_TREND_MM테이블 pk컬럼 정보 값 추가 조회
 * 2022/11/23	hrkim			테이블 컬럼 변경 (CATEGORY_DV)
 * 2022/11/30	hrkim			모델별 조회 양품 Nick Name/모델 필터링 위치 변경 (셀환산 데이터 추가 이후 필터링)
 * 2022/12/05   hrkim			Category 순서 변경 (Cell Convert, Cell, Pack 순서로)
 * 2023/01/04	hrkim			Cell Convert 미래구간 양품수량 계산 로직 변경
 * 2023/01/05	hrkim			월별 DIO 초과 사유 유무 항목 추가
 * 2023/01/11	hrkim			미래구간 Pack 모델 수율 적용 전 생산 계획 수량 (Pack 생산계획은 수율이 적용된 수량임) measure 추가
 *								미래구간 Cell 모델 Pack 생산에 소요된 수량 measure 추가
 * 2023/02/01	hrkim			품질이슈 수량 반영시 셀환산수량 적용 로직 보완 및 cell_group_target 항목 추가
 * 2023/02/06   hrkim			SCP_RPT_DIO_TREND_MM_REASON 테이블 참조 조건 추가
 * 2023/03/21   hrkim			양품재고 - DIO 초과 사유 품질이슈 수량 (셀환산)Cell Group 기준 적용
 * 2023.04.27   hrkim			PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Cell Group 기준 변경
 *													- 변경전 : SCP_MST_FINAL_ITEM.GROUP_CODE5 (Product Level4 - Group Code Management - 81)
 *													- 변경후 : SCP_MST_FINAL_ITEM.GROUP_CODE1 (Product Level1 - Group Code Management - 81)
----------------------------------------------------------------------------------------------------------
-- 재고 Trend Measure 정의
-- db measure에 '_' 포함되지 않도록 한다.
-- ui measure는 = db measure + '_' + 컬럼구분값 (QTY : QUANTITY, AMT : AMOUNT, DIO : DIO)
----------------------------------------------------------------------------------------------------------
*/
CREATE PROCEDURE [dbo].[SCP0093_GET_DIO_TREND_DATA_MM_NEW]
  @p_division_id            NVARCHAR(30)	-- division
, @p_plan_start_yyyymmdd	NVARCHAR(8)		-- Plan Date
, @p_item_id				NVARCHAR(150)	-- 모델
, @p_from_yyyymm			NVARCHAR(6)		-- Monthly bucket 조회 기간
, @p_to_yyyymm		        NVARCHAR(6)		-- Monthly bucket 조회 기간
, @P_AGGR_DV				NVARCHAR(10)	-- 집계구분 [MD : 모델(Item), CG: 셀그룹(Level4)]
, @P_CATEGORY				NVARCHAR(50)    -- Category 조건  = [Pack, Cell, Cell Convert]
, @P_UNIT_QTY				NUMERIC(20,10)  -- 수량 단위
, @P_UNIT_AMOUNT			NUMERIC(20,10)  -- 금액 단위
, @p_cell_group				NVARCHAR(30)    -- 셀그룹(닉네임.Level4)
, @p_graph_type				NVARCHAR(30)    -- 수량 /금액 선택
, @p_bucket_type		    NVARCHAR(30)    -- MONTHLY (WEEKLY는 프로시저 분리 필요)
, @p_user_id				NVARCHAR(30)    -- MEASURE 개인별 선택
, @debug_mode				NVARCHAR(1) = 'T'
AS
BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

	DECLARE @v_program_id		NVARCHAR(10) = 'SCP0093';
	DECLARE @v_sheet_name		NVARCHAR(20) = 'MAIN';

	-- Plan date 기준 전월
	DECLARE @V_LAST_YYYYMM NVARCHAR(6) = CONVERT(NVARCHAR(6), DATEADD(MONTH, -1, CONVERT(DATE, @p_plan_start_yyyymmdd, 112)), 112)

	-- 행으로 되어 있는 월을 조회기간 만큼 가변적으로 열로 만들기 위한 다이나믹 쿼리 변수
	DECLARE @v_query			NVARCHAR(MAX) = '';
	DECLARE @v_query_mm_case	NVARCHAR(MAX) = '';

	IF ISNULL(@P_UNIT_QTY, 0) = 0
	   SET @P_UNIT_QTY = 1;

	IF ISNULL(@P_UNIT_AMOUNT, 0) = 0
	   SET @P_UNIT_AMOUNT = 1;

	-----------------------------------------------------------------------------------------------------------
	-- 0. category 조건
	-----------------------------------------------------------------------------------------------------------
	IF ISNULL(@P_CATEGORY, '') = ''
		SET @P_CATEGORY = 'C, P, A'  -- C:Cell Convert, P:Pack, C:Cell

	IF OBJECT_ID('tempdb..#TARGET_CATEGORY') IS NOT NULL
		DROP TABLE #TARGET_CATEGORY;

	SELECT CASE WHEN TOKEN = 'C' THEN 'Cell Convert'
		        WHEN TOKEN = 'P' THEN 'Pack'
		   		WHEN TOKEN = 'A' THEN 'Cell'
		   		ELSE ''
		   END		AS CATEGORY
		  ,TOKEN	AS CATEGORY_DV
	INTO #TARGET_CATEGORY
	FROM String_split( @P_CATEGORY, ',')


	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'1.1 #TARGET_MEASURES 조회 대상 Measure 정보 (사용자 설정 Measures)'
	-----------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#TARGET_MEASURES') IS NOT NULL
		DROP TABLE #TARGET_MEASURES;

	;WITH USER_MEASURES AS (
			--- user별 설정한 조회 대상 measure
			SELECT UM.COLUMN_NAME		AS MEASURE_UI
				  ,M.COLUMN_LABEL_NAME	AS MEASURE_NAME
				  ,UM.SORT_ORDER_NO
			 FROM SCM_MST_TITLESET_USER UM WITH(NOLOCK)
				  INNER JOIN SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
						  ON M.PROGRAM_ID = @v_program_id
						 AND M.SHEET_NAME =@v_sheet_name
						 AND M.VALID_YN = 'Y'
						 AND M.COLUMN_NAME = UM.COLUMN_NAME
			WHERE 1=1
			  AND UM.USER_ID = @P_USER_ID
			  AND UM.PROGRAM_ID = @v_program_id
			  AND UM.SHEET_NAME = @v_sheet_name
	)
	,TARGET_MEASURES AS (
			--- user별 설정한 조회 대상 measure
			SELECT UM.MEASURE_UI
				  ,UM.MEASURE_NAME
				  ,UM.SORT_ORDER_NO
			  FROM USER_MEASURES UM
			UNION ALL
			--- user별 설정한 measure정보가 없을 경우 default measure를 보여준다.
			SELECT M.COLUMN_NAME		AS MEASURE_UI
				  ,M.COLUMN_LABEL_NAME	AS MEASURE_NAME
				  ,M.SORT_ORDER_NO
			 FROM SCM_MST_SHEET_MEASURE M WITH(NOLOCK)
			WHERE 1=1
			  AND M.PROGRAM_ID = @v_program_id
			  AND M.SHEET_NAME = @v_sheet_name
			  AND M.VALID_YN   = 'Y'
			  AND M.DEFAULT_FLAG = 'Y'
			  AND NOT EXISTS (SELECT 1
							   FROM USER_MEASURES
							  WHERE 1=1
							  )
	)
	SELECT TM.MEASURE_UI
		  ,TM.MEASURE_NAME
		  ,SUBSTRING(TM.MEASURE_UI, 1, CHARINDEX('_', TM.MEASURE_UI)-1)						AS MEASURE_DB
		  ,SUBSTRING(TM.MEASURE_UI, CHARINDEX('_', TM.MEASURE_UI)+1, LEN(TM.MEASURE_UI) )	AS COL_DIV
		  ,TM.SORT_ORDER_NO
	 INTO #TARGET_MEASURES
	 FROM TARGET_MEASURES TM

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'1.2  #ITEM NICK_NAME INFO 모델 닉네임 정보'
	-----------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#ITEM_NICK_NAME_INFO') IS NOT NULL
		DROP TABLE #ITEM_NICK_NAME_INFO;

	SELECT IM.DIVISION_ID
		  ,IM.ITEM_ID
		  ,MAX(IM.NICK_NAME)	AS NICK_NAME
	  INTO #ITEM_NICK_NAME_INFO
	  FROM SCM_MST_ITEM_SN IM WITH(NOLOCK)
	 WHERE IM.DIVISION_ID = @p_division_id
	GROUP BY IM.DIVISION_ID
			,IM.ITEM_ID

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'1.3 Insert #YIELD_INFO 수율'
	-----------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#YIELD_INFO') IS NOT NULL
		DROP TABLE #YIELD_INFO;

	;WITH CELL_GROUP_INFO AS (
			SELECT I.DIVISION_ID
				  ,I.ITEM_ID
				  ,CASE -- 2023.04.27 Cell Group 기준 변경 WHEN ISNULL(MAX(FI.GROUP_CODE5),'') != '' THEN MAX(FI.GROUP_CODE5) -- 1순위 Level4
						WHEN ISNULL(MAX(FI.GROUP_CODE1),'') != '' THEN MAX(FI.GROUP_CODE1) -- 2순위 Cell Group
						WHEN ISNULL(MAX(BC.NICK_NAME)  ,'') != '' THEN MAX(BC.NICK_NAME)   -- 3순위 Basic Cell의 NickName
						WHEN ISNULL(MAX(FI.NICK_NAME)  ,'') != '' THEN MAX(FI.NICK_NAME)   -- 4순위 Nick_name
						ELSE I.ITEM_ID
					END							AS CELL_GROUP
			 FROM SCM_MST_ITEM_SN I WITH(NOLOCK)
				  LEFT JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						 ON FI.DIVISION_ID = I.DIVISION_ID
						AND FI.ITEM_ID	   = I.ITEM_ID
				  LEFT JOIN SCM_MST_ITEM_SN C WITH(NOLOCK)
						 ON C.DIVISION_ID = FI.DIVISION_ID
						AND C.ITEM_ID     = CASE WHEN FI.OPERATION_GROUP = 'P'
												 THEN FI.ATTRIBUTE1
												 ELSE FI.ITEM_ID
											END
						AND C.DOE IS NOT NULL
				  LEFT JOIN SCP_MST_FINAL_ITEM BC WITH(NOLOCK)
						 ON BC.DIVISION_ID = C.DIVISION_ID
						AND BC.ITEM_ID	   = C.DOE
			WHERE 1=1
			  AND I.DIVISION_ID			= @P_DIVISION_ID
			  AND I.SCP_OPERATION_GROUP IN ('A', 'P')
			GROUP BY I.DIVISION_ID
					,I.ITEM_ID
	)
	SELECT CASE WHEN @P_AGGR_DV = 'MD'
				THEN Y.ITEM_ID
				ELSE ISNULL(C.CELL_GROUP, Y.ITEM_ID)
			END					AS ITEM_ID
		  ,MAX(YIELD) AS YIELD
	  INTO #YIELD_INFO
	  FROM SCM_MST_YIELD_SN Y WITH(NOLOCK)
		   LEFT JOIN CELL_GROUP_INFO C
				  ON C.DIVISION_ID = Y.DIVISION_ID
				 AND C.ITEM_ID	   = Y.ITEM_ID
	WHERE 1=1
	  AND Y.DIVISION_ID = @P_DIVISION_ID
	  AND Y.MONTH = SUBSTRING(@P_PLAN_START_YYYYMMDD, 1, 6)
	  AND Y.YIELD > 0
	GROUP BY CASE WHEN @P_AGGR_DV = 'MD'
				  THEN Y.ITEM_ID
				  ELSE ISNULL(C.CELL_GROUP, Y.ITEM_ID)
			 END


	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'1.4 월별 일수 정보'
	-----------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#TMP_MM_DAYS_INFO') IS NOT NULL
		DROP TABLE #TMP_MM_DAYS_INFO;

	;WITH DAYS_INFO AS (
		SELECT YYYYMM
			 , MIN(YYYYMMDD) AS FIRST_YMD
			 , MAX(YYYYMMDD) AS LAST_YMD
			 , COUNT(*)		 AS MM_DAYS
		 FROM SCM_MST_BUCKET B WITH(NOLOCK)
		WHERE 1=1
		  AND YYYYMM  BETWEEN CONVERT(NVARCHAR(6), DATEADD(MONTH, -5, CONVERT(DATE, @p_from_yyyymm+'01', 112)), 112)
						  AND CONVERT(NVARCHAR(6), DATEADD(MONTH, +5, CONVERT(DATE, @p_to_yyyymm+'01'  , 112)), 112)
		GROUP BY YYYYMM
	)
	SELECT DI.YYYYMM
		  ,DI.FIRST_YMD
		  ,DI.LAST_YMD
		  ,DI.MM_DAYS
		  ,CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, DI.FIRST_YMD, 112)), 112) AS FROM_MONTH
		  ,CONVERT(NVARCHAR(6), DATEADD(MONTH, 5, CONVERT(DATE, DI.FIRST_YMD, 112)), 112) AS TO_MONTH
		  ,MAX(CASE WHEN DATEADD(MONTH, 1, CONVERT(DATE, DI.FIRST_YMD,112)) = AD.FIRST_YMD THEN AD.MM_DAYS ELSE 0 END) AS DAYS_NEXT_1
		  ,MAX(CASE WHEN DATEADD(MONTH, 2, CONVERT(DATE, DI.FIRST_YMD,112)) = AD.FIRST_YMD THEN AD.MM_DAYS ELSE 0 END) AS DAYS_NEXT_2
		  ,MAX(CASE WHEN DATEADD(MONTH, 3, CONVERT(DATE, DI.FIRST_YMD,112)) = AD.FIRST_YMD THEN AD.MM_DAYS ELSE 0 END) AS DAYS_NEXT_3
		  ,MAX(CASE WHEN DATEADD(MONTH, 4, CONVERT(DATE, DI.FIRST_YMD,112)) = AD.FIRST_YMD THEN AD.MM_DAYS ELSE 0 END) AS DAYS_NEXT_4
		  ,MAX(CASE WHEN DATEADD(MONTH, 5, CONVERT(DATE, DI.FIRST_YMD,112)) = AD.FIRST_YMD THEN AD.MM_DAYS ELSE 0 END) AS DAYS_NEXT_5
		  ,SUM(CASE WHEN DATEDIFF(MONTH, CONVERT(DATE, DI.FIRST_YMD,112), CONVERT(DATE, AD.FIRST_YMD,112)) <= 1 THEN AD.MM_DAYS ELSE 0 END) AS ACC_DAYS_1
		  ,SUM(CASE WHEN DATEDIFF(MONTH, CONVERT(DATE, DI.FIRST_YMD,112), CONVERT(DATE, AD.FIRST_YMD,112)) <= 2 THEN AD.MM_DAYS ELSE 0 END) AS ACC_DAYS_2
		  ,SUM(CASE WHEN DATEDIFF(MONTH, CONVERT(DATE, DI.FIRST_YMD,112), CONVERT(DATE, AD.FIRST_YMD,112)) <= 3 THEN AD.MM_DAYS ELSE 0 END) AS ACC_DAYS_3
		  ,SUM(CASE WHEN DATEDIFF(MONTH, CONVERT(DATE, DI.FIRST_YMD,112), CONVERT(DATE, AD.FIRST_YMD,112)) <= 4 THEN AD.MM_DAYS ELSE 0 END) AS ACC_DAYS_4
		  ,SUM(CASE WHEN DATEDIFF(MONTH, CONVERT(DATE, DI.FIRST_YMD,112), CONVERT(DATE, AD.FIRST_YMD,112)) <= 5 THEN AD.MM_DAYS ELSE 0 END) AS ACC_DAYS_5
	 INTO #TMP_MM_DAYS_INFO
	 FROM DAYS_INFO DI
		  LEFT JOIN DAYS_INFO AD
				 ON AD.YYYYMM BETWEEN CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, DI.FIRST_YMD, 112)), 112)
								  AND CONVERT(NVARCHAR(6), DATEADD(MONTH, 5, CONVERT(DATE, DI.FIRST_YMD, 112)), 112)
	WHERE 1=1
	GROUP BY
		   DI.YYYYMM
		  ,DI.FIRST_YMD
		  ,DI.LAST_YMD
		  ,DI.MM_DAYS
		  ,CONVERT(NVARCHAR(6), DATEADD(MONTH, 1, CONVERT(DATE, DI.FIRST_YMD, 112)), 112)
		  ,CONVERT(NVARCHAR(6), DATEADD(MONTH, 5, CONVERT(DATE, DI.FIRST_YMD, 112)), 112)
	;

	--------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N' 1.5 품질 이슈 수량'
	--------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#QUALITY_ISSUES') IS NOT NULL
		DROP TABLE #QUALITY_ISSUES;

	SELECT R.YYYYMM
		  ,R.CELL_GROUP
		  ,R.CATEGORY_DV
		  ,R.AGGR_DV
		  ,SUM(R.QUANTITY)		AS ISSUE_QTY
	 INTO #QUALITY_ISSUES
	 FROM SCP_RPT_DIO_TREND_MM_REASON R WITH(NOLOCK) -- DIO 초과 사유   --- YYYYMM, CATEGORY_DV, DIO_REASON, AGGR_DV, DIVISION_ID, ITEM_ID, CELL_GROUP
	WHERE R.YYYYMM BETWEEN CASE WHEN @p_from_yyyymm > SUBSTRING(@P_PLAN_START_YYYYMMDD, 1, 6)
							  THEN SUBSTRING(@P_PLAN_START_YYYYMMDD, 1, 6)
							  ELSE @p_from_yyyymm
						 END
					 AND @p_to_yyyymm
	  AND R.CATEGORY_DV = 'C'								-- 셀환산
	  AND R.DIO_REASON IN ('QUALITY_ISSUES_REPORT'		    -- 품질 이슈(보고)
					     , 'QUALITY_ISSUES_REPORT_OTHER')   -- 품질 이슈(보고 외)
	  AND R.AGGR_DV		= 'CG'								-- 셀그룹별 집계
	  AND R.ITEM_ID		= '*'
	  AND R.DIVISION_ID = @p_division_id
	  AND R.QUANTITY IS NOT NULL
	  AND R.QUANTITY   != 0
	GROUP BY
		   R.YYYYMM
		  ,R.CELL_GROUP
		  ,R.CATEGORY_DV
		  ,R.AGGR_DV

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'2.1 #SCP_RPT_DIO_TREND_MM 조회 대상 데이터'
	-----------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#SCP_RPT_DIO_TREND_MM') IS NOT NULL
		DROP TABLE #SCP_RPT_DIO_TREND_MM;

	SELECT DT.*
		  ,TC.CATEGORY
		  ,ISNULL(NI.NICK_NAME,'') AS NICK_NAME
	INTO #SCP_RPT_DIO_TREND_MM
	FROM SCP_RPT_DIO_TREND_MM DT WITH(NOLOCK)
		 INNER JOIN #TARGET_CATEGORY TC
				 ON TC.CATEGORY_DV = DT.CATEGORY_DV
		 LEFT  JOIN #ITEM_NICK_NAME_INFO NI
				 ON NI.DIVISION_ID = DT.DIVISION_ID
				AND NI.ITEM_ID     = DT.ITEM_ID
	WHERE 1=1
	  AND DT.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
	  AND DT.DIVISION_ID		 = @P_DIVISION_ID
	  AND DT.AGGR_DV			 = @P_AGGR_DV
	  AND DT.YYYYMM		BETWEEN @P_FROM_YYYYMM
							AND @P_TO_YYYYMM
	  AND DT.MEASURE NOT IN ('AVAILABLE', 'OP-LT-EXCPT')
	  AND DT.CELL_GROUP			 = CASE WHEN ISNULL(@P_CELL_GROUP,'') = ''	THEN DT.CELL_GROUP	ELSE  @P_CELL_GROUP END

	-----------------------------------------------------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'2.2 #SCP_RPT_DIO_TREND_MM 조회 대상 데이터 - Model/Nick_name 필터링 (MKT FCST Waterfall 참조)'
	-----------------------------------------------------------------------------------------------------------------------------------------------------
	IF ( @P_AGGR_DV = 'MD' AND ISNULL(@p_item_id, '')  <> '')
		BEGIN
			DELETE A
			FROM #SCP_RPT_DIO_TREND_MM A
			LEFT OUTER JOIN (	SELECT DISTINCT token
								FROM dbo.String_Split(@p_item_id,',')
							) C	ON A.ITEM_ID LIKE '%' + C.TOKEN + '%'
			LEFT OUTER JOIN (	SELECT DISTINCT token
								FROM dbo.String_Split(@p_item_id,',')
							) D	ON A.NICK_NAME LIKE '%' + D.TOKEN + '%'
			WHERE C.TOKEN IS NULL  AND D.TOKEN IS NULL
		END


	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'3. 양품 및 OP L/T Except'
	-----------------------------------------------------------------------------------------------------------
	IF EXISTS (SELECT TOP 1 *
				FROM #TARGET_MEASURES
			   WHERE 1=1
				 AND MEASURE_DB IN ('AVAILABLE', 'OP-LT-EXCPT'))
	BEGIN

			----------------------------------------------------------
			print convert(varchar(30), getdate(), 121) + N'3.1 RTF'
			----------------------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_RTF') IS NOT NULL
				DROP TABLE #TMP_RTF;

			SELECT DT.CATEGORY
				  ,DT.AGGR_DV
				  ,DT.YYYYMM
				  ,DT.ITEM_ID
				  ,DT.CATEGORY_DV
				  ,DT.QUANTITY										 AS RTF
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE1,0))  AS RTF_NEXT_1
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE2,0))  AS RTF_NEXT_2
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE3,0))  AS RTF_NEXT_3
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE4,0))  AS RTF_NEXT_4
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE5,0))  AS RTF_NEXT_5
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE6,0))  AS ACC_RTF_1
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE7,0))  AS ACC_RTF_2
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE8,0))  AS ACC_RTF_3
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE9,0))  AS ACC_RTF_4
				  ,CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE10,0)) AS ACC_RTF_5
			 INTO #TMP_RTF
			 FROM #SCP_RPT_DIO_TREND_MM DT
			WHERE 1=1
			  AND DT.MEASURE = 'RTF'

			------------------------------------------------------------------------
			print convert(varchar(30), getdate(), 121) + N'3.2 양품 재고 수량'
			------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_AVAILABLE_QTY') IS NOT NULL
				DROP TABLE #TMP_AVAILABLE_QTY;

			SELECT I.CATEGORY_DV
				  ,I.CATEGORY
				  ,I.YYYYMM
				  ,I.AGGR_DV
				  ,I.ITEM_ID
				  ,I.NICK_NAME
				  ,I.CELL_GROUP
				  , I.QUANTITY - ISNULL(Q.ISSUE_QTY, 0) 				AS AVAILABLE_QTY
				  ,(I.QUANTITY - ISNULL(Q.ISSUE_QTY, 0)) * I.UNIT_PRICE	AS AVAILABLE_AMT
				  ,I.PIC_ID
				  ,I.DEPT_ID
				  ,I.PROJECT_CODE
				  ,I.UNIT_PRICE
				  ,I.TARGET_CELL
				  ,I.CELL_CF
				  ,I.PRODUCTION_CYCLE
				  ,I.SAFETY_STOCK
				  ,I.PRE_INSPECTION
			  INTO #TMP_AVAILABLE_QTY
			  FROM #SCP_RPT_DIO_TREND_MM I
				   LEFT JOIN #QUALITY_ISSUES Q
						  ON Q.YYYYMM		=  CASE WHEN I.YYYYMM  >= SUBSTRING(@P_PLAN_START_YYYYMMDD, 1,6)
													THEN SUBSTRING(@P_PLAN_START_YYYYMMDD, 1, 6) -- 당월 포함 미래구간은 모두 당월(Plan 해당월) 품질이슈 수량 반영
													ELSE I.YYYYMM
												END
						 AND Q.CATEGORY_DV	= I.CATEGORY_DV
						 AND Q.AGGR_DV		= I.AGGR_DV
						 AND Q.CELL_GROUP	= I.CELL_GROUP
		     WHERE 1=1
			   AND I.MEASURE = 'INV'

			--------------------------------------------------------------------------------
			print convert(varchar(30), getdate(), 121) + N'3.3 양품 재고 DIO'
			--------------------------------------------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_AVAILABLE_DIO') IS NOT NULL
				DROP TABLE #TMP_AVAILABLE_DIO;

			SELECT I.CATEGORY
				  ,I.AGGR_DV
				  ,I.YYYYMM
				  ,I.ITEM_ID
				  ,I.NICK_NAME
				  ,I.CATEGORY_DV
				  ,I.AVAILABLE_QTY
				  ,I.AVAILABLE_AMT
				  ,CASE WHEN I.AVAILABLE_QTY <= 0 THEN
							 0
						WHEN R.ITEM_ID IS NULL THEN
							 180
						WHEN I.AVAILABLE_QTY - R.RTF_NEXT_1 < 0 THEN
							 ISNULL(CONVERT(NUMERIC(20,10), I.AVAILABLE_QTY)				 / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1   END, 0) * D.DAYS_NEXT_1
						WHEN I.AVAILABLE_QTY	 - R.RTF_NEXT_1 = 0 THEN
							 D.ACC_DAYS_1
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_2 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_1)) / CASE WHEN R.RTF_NEXT_2 = 0  THEN NULL ELSE R.RTF_NEXT_2  END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_2 = 0  THEN
							 D.ACC_DAYS_2
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_3 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_2)) / CASE WHEN R.RTF_NEXT_3 = 0  THEN NULL ELSE R.RTF_NEXT_3  END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_3 = 0  THEN
							 D.ACC_DAYS_3
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_4 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_3)) / CASE WHEN R.RTF_NEXT_4 = 0  THEN NULL ELSE R.RTF_NEXT_4  END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_4 = 0  THEN
							 D.ACC_DAYS_4
						WHEN I.AVAILABLE_QTY - R.ACC_RTF_5 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_4)) / CASE WHEN R.RTF_NEXT_5 = 0  THEN NULL ELSE R.RTF_NEXT_5  END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_5 = 0  THEN
							 D.ACC_DAYS_5
						ELSE 180
					END	AS AVAILABLE_DIO
				  ,I.CELL_GROUP
				  ,I.PIC_ID
				  ,I.DEPT_ID
				  ,I.PROJECT_CODE
				  ,I.UNIT_PRICE
				  ,I.TARGET_CELL
				  ,I.CELL_CF
				  ,I.PRODUCTION_CYCLE
				  ,I.SAFETY_STOCK
				  ,I.PRE_INSPECTION
			 INTO #TMP_AVAILABLE_DIO
			 FROM #TMP_AVAILABLE_QTY I
				   INNER JOIN #TMP_MM_DAYS_INFO D
						  ON D.YYYYMM			 = I.YYYYMM
				   LEFT JOIN #TMP_RTF R
						  ON R.AGGR_DV			 = I.AGGR_DV
						 AND R.YYYYMM			 = I.YYYYMM
						 AND R.ITEM_ID			 = I.ITEM_ID
						 AND R.CATEGORY_DV		 = I.CATEGORY_DV
						 AND R.CATEGORY          = I.CATEGORY
			WHERE 1=1

			------------------------------------------------------------------------------------------------
			print convert(varchar(30), getdate(), 121) + N'3.4 #SCP_RPT_DIO_TREND_MM - 양품 MEASURE 추가'
			------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,AMOUNT
						,DIO
						,CELL_GROUP
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,UNIT_PRICE
						,UNIT_PRICE_LAST
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
			SELECT @P_PLAN_START_YYYYMMDD
				  ,@P_DIVISION_ID
				  ,@P_AGGR_DV
				  ,CASE WHEN I.CATEGORY_DV = 'C'
						THEN 'Cell Convert'
						WHEN I.CATEGORY_DV = 'P'
						THEN 'Pack'
						WHEN I.CATEGORY_DV = 'A'
						THEN 'Cell'
						ELSE ''
				   END			AS CATEGORY
				  ,I.YYYYMM
				  ,I.ITEM_ID
				  ,I.NICK_NAME
				  ,I.CATEGORY_DV
				  ,'AVAILABLE'	AS MEASURE
				  ,I.AVAILABLE_QTY
				  ,I.AVAILABLE_AMT
				  ,I.AVAILABLE_DIO
				  ,I.CELL_GROUP
				  ,I.PIC_ID
				  ,I.DEPT_ID
				  ,I.PROJECT_CODE
				  ,I.UNIT_PRICE
				  ,DT.UNIT_PRICE_LAST
				  ,I.TARGET_CELL
				  ,I.CELL_CF
				  ,I.PRODUCTION_CYCLE
				  ,I.SAFETY_STOCK
				  ,I.PRE_INSPECTION
				  ,@P_USER_ID	AS CREATED_BY
				  ,GETDATE()	AS CREATION_DATE
				  ,@P_USER_ID	AS LAST_UPDATED_BY
				  ,GETDATE()	AS LAST_UPDATE_DATE
			 FROM #TMP_AVAILABLE_DIO I
				  LEFT JOIN #SCP_RPT_DIO_TREND_MM DT
						 ON DT.YYYYMM		= I.YYYYMM
						AND DT.ITEM_ID		= I.ITEM_ID
						AND DT.CATEGORY_DV	= I.CATEGORY_DV
						AND DT.MEASURE		= 'INV'
						AND DT.AGGR_DV		= I.AGGR_DV

			--------------------------------------------------------------------------------------------------------------
			print convert(varchar(30), getdate(), 121) + N'3.5 #SCP_RPT_DIO_TREND_MM - OP L/T Except Measure'
			--------------------------------------------------------------------------------------------------------------
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,DIO
						,CELL_GROUP
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,UNIT_PRICE
						,UNIT_PRICE_LAST
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
			SELECT @P_PLAN_START_YYYYMMDD
				  ,@P_DIVISION_ID
				  ,@P_AGGR_DV
				  ,CASE WHEN ISNULL(I.CATEGORY_DV, DT.CATEGORY_DV)  = 'C'
						THEN 'Cell Convert'
						WHEN ISNULL(I.CATEGORY_DV, DT.CATEGORY_DV) = 'P'
						THEN 'Pack'
						WHEN ISNULL(I.CATEGORY_DV, DT.CATEGORY_DV) = 'A'
						THEN 'Cell'
						ELSE ''
				   END			AS CATEGORY
				  ,ISNULL(I.YYYYMM				  ,DT.YYYYMM			) AS YYYYMM
				  ,ISNULL(I.ITEM_ID				  ,DT.ITEM_ID			) AS ITEM_ID
				  ,ISNULL(I.NICK_NAME			  ,DT.NICK_NAME			) AS NICK_NAME
				  ,ISNULL(I.CATEGORY_DV			  ,DT.CATEGORY_DV		) AS CATEGORY_DV
				  ,'OP-LT-EXCPT'											AS MEASURE
				  ,ISNULL(I.AVAILABLE_QTY, 0.0) - ISNULL(DT.QUANTITY, 0.0)	AS QUANTITY 	-- 양품 수량  - OP L/T 수량
				  ,ISNULL(I.AVAILABLE_DIO, 0.0) - ISNULL(DT.DIO     , 0.0) 	AS DIO 			-- 양품 DIO   - OP L/T DIO
				  ,ISNULL(I.CELL_GROUP			  ,DT.CELL_GROUP		) AS CELL_GROUP
				  ,ISNULL(I.PIC_ID				  ,DT.PIC_ID			) AS PIC_ID
				  ,ISNULL(I.DEPT_ID				  ,DT.DEPT_ID			) AS DEPT_ID
				  ,ISNULL(I.PROJECT_CODE		  ,DT.PROJECT_CODE		) AS PROJECT_CODE
				  ,ISNULL(I.UNIT_PRICE			  ,DT.UNIT_PRICE		) AS UNIT_PRICE
				  ,DT.UNIT_PRICE_LAST									  AS UNIT_PRICE_LAST
				  ,ISNULL(I.TARGET_CELL			  ,DT.TARGET_CELL		) AS TARGET_CELL
				  ,ISNULL(I.CELL_CF				  ,DT.CELL_CF			) AS CELL_CF
				  ,ISNULL(I.PRODUCTION_CYCLE	  ,DT.PRODUCTION_CYCLE	) AS PRODUCTION_CYCLE
				  ,ISNULL(I.SAFETY_STOCK		  ,DT.SAFETY_STOCK		) AS SAFETY_STOCK
				  ,ISNULL(I.PRE_INSPECTION		  ,DT.PRE_INSPECTION	) AS PRE_INSPECTION
				  ,@P_USER_ID	AS CREATED_BY
				  ,GETDATE()	AS CREATION_DATE
				  ,@P_USER_ID	AS LAST_UPDATED_BY
				  ,GETDATE()	AS LAST_UPDATE_DATE
			 FROM #TMP_AVAILABLE_DIO I
				  FULL OUTER JOIN #SCP_RPT_DIO_TREND_MM DT
						 ON DT.YYYYMM		= I.YYYYMM
						AND DT.ITEM_ID		= I.ITEM_ID
						AND DT.CATEGORY_DV	= I.CATEGORY_DV
						AND DT.AGGR_DV		= I.AGGR_DV
			WHERE 1=1
			  AND DT.MEASURE = 'OP-LT'
	END;

	--------------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'4. Category별 기타충당금 추가 (#SCP_RPT_DIO_TREND_MM)'
	--------------------------------------------------------------------------------------------------------------
	INSERT INTO #SCP_RPT_DIO_TREND_MM (
				 PLAN_START_YYYYMMDD
				,DIVISION_ID
				,AGGR_DV
				,CATEGORY
				,YYYYMM
				,ITEM_ID
				,NICK_NAME
				,CELL_GROUP
				,CATEGORY_DV
				,MEASURE
				,QUANTITY
				,AMOUNT
				,DIO
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
	SELECT DT.PLAN_START_YYYYMMDD
		  ,DT.DIVISION_ID
		  ,DT.AGGR_DV
		  ,TC.CATEGORY
		  ,DT.YYYYMM
		  ,DT.ITEM_ID
		  ,N'기타충당금' AS NICK_NAME
		  ,DT.CELL_GROUP
		  ,DT.CATEGORY_DV
		  ,DT.MEASURE
		  ,DT.QUANTITY
		  ,DT.AMOUNT
		  ,DT.DIO
		  ,@P_USER_ID	AS CREATED_BY
		  ,GETDATE()	AS CREATION_DATE
		  ,@P_USER_ID	AS LAST_UPDATED_BY
		  ,GETDATE()	AS LAST_UPDATE_DATE
	 FROM SCP_RPT_DIO_TREND_MM DT WITH(NOLOCK)
		  INNER JOIN #TARGET_CATEGORY TC
				  ON TC.CATEGORY_DV = DT.CATEGORY_DV
	WHERE 1=1
	  AND DT.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
	  AND DT.DIVISION_ID		 = @P_DIVISION_ID
	  AND DT.AGGR_DV			 = 'ET'
	  AND DT.YYYYMM		BETWEEN @P_FROM_YYYYMM
							AND @P_TO_YYYYMM

	-----------------------------------------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'5.1. Category별 MEASURE 합계 추가 (조회 조건에 대한 합계가 아님) - #SCP_RPT_DIO_TREND_MM'
	-----------------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO #SCP_RPT_DIO_TREND_MM (
				 PLAN_START_YYYYMMDD
				,DIVISION_ID
				,AGGR_DV
				,CATEGORY
				,YYYYMM
				,ITEM_ID
				,NICK_NAME
				,CELL_GROUP
				,CATEGORY_DV
				,MEASURE
				,QUANTITY
				,AMOUNT
				,DIO
				,UNIT_PRICE_LAST
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
	SELECT DT.PLAN_START_YYYYMMDD
		  ,DT.DIVISION_ID
		  ,'TT'				AS AGGR_DV
		  ,TC.CATEGORY
		  ,DT.YYYYMM
		  ,N'합계'			AS ITEM_ID
		  ,N'합계'			AS NICK_NAME
		  ,N'합계'			AS CELL_GROUP
		  ,DT.CATEGORY_DV
		  ,DT.MEASURE
		  ,SUM(DT.QUANTITY)	AS QUANTITY
		  ,CASE WHEN DT.MEASURE != 'STANDARD'
				THEN SUM(DT.AMOUNT)
				ELSE SUM(DT.QUANTITY) -- 기준수량 * 최종단가 (기타충당금 반영된 금액의 단가)
					*
					MAX(CASE WHEN DT.YYYYMM = @V_LAST_YYYYMM AND DT.MEASURE = 'INV'  AND SUM(DT.QUANTITY) != 0
							 THEN CONVERT(NUMERIC(20,0), SUM(DT.AMOUNT) / SUM(DT.QUANTITY))
							 ELSE NULL
						END)	OVER	(PARTITION BY DT.PLAN_START_YYYYMMDD
												 ,DT.DIVISION_ID
												 ,DT.CATEGORY_DV)
		   END AS AMOUNT
		  ,MAX(DT.DIO)		AS DIO
		  ,MAX(CASE WHEN DT.YYYYMM = @V_LAST_YYYYMM AND DT.MEASURE = 'INV'  AND SUM(DT.QUANTITY) != 0
					THEN CONVERT(NUMERIC(20,0), SUM(DT.AMOUNT) / SUM(DT.QUANTITY))
					ELSE NULL
			   END)	OVER	(PARTITION BY DT.PLAN_START_YYYYMMDD
										 ,DT.DIVISION_ID
										 ,DT.CATEGORY_DV)
							AS UNIT_PRICE_LAST
		  ,@P_USER_ID		AS CREATED_BY
		  ,GETDATE()		AS CREATION_DATE
		  ,@P_USER_ID		AS LAST_UPDATED_BY
		  ,GETDATE()		AS LAST_UPDATE_DATE
	 FROM SCP_RPT_DIO_TREND_MM DT WITH(NOLOCK)
		  INNER JOIN #TARGET_CATEGORY TC
				  ON TC.CATEGORY_DV = DT.CATEGORY_DV
	WHERE 1=1
	  AND DT.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
	  AND DT.DIVISION_ID		 = @P_DIVISION_ID
	  AND DT.AGGR_DV			 IN ('TT', 'ET')
	  AND DT.YYYYMM		BETWEEN @P_FROM_YYYYMM
							AND @P_TO_YYYYMM
	  AND DT.MEASURE            != 'GAP'   -- 기타충당금(TT) 반영 재고 및 기준재고 정보로 재계산 필요
	GROUP BY DT.PLAN_START_YYYYMMDD
			,DT.DIVISION_ID
			,DT.YYYYMM
			,DT.CATEGORY_DV
			,TC.CATEGORY
			,DT.MEASURE

	--------------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'5.2. Category별 합계 - GAP Measure 추가'
	--------------------------------------------------------------------------------------------------------------
	INSERT INTO #SCP_RPT_DIO_TREND_MM (
				 PLAN_START_YYYYMMDD
				,DIVISION_ID
				,AGGR_DV
				,CATEGORY
				,YYYYMM
				,ITEM_ID
				,NICK_NAME
				,CELL_GROUP
				,CATEGORY_DV
				,MEASURE
				,QUANTITY
				,AMOUNT
				,DIO
				,UNIT_PRICE_LAST
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				)
	SELECT D.PLAN_START_YYYYMMDD
		  ,D.DIVISION_ID
		  ,D.AGGR_DV
		  ,D.CATEGORY
		  ,D.YYYYMM
		  ,MAX(D.ITEM_ID	 )		AS ITEM_ID
		  ,MAX(D.NICK_NAME	 )		AS NICK_NAME
		  ,MAX(D.CELL_GROUP	 )		AS CELL_GROUP
		  ,D.CATEGORY_DV
		  ,'GAP'																		 AS MEASURE
		  ,SUM(CASE WHEN D.MEASURE = 'INV' THEN D.QUANTITY	ELSE (-1) * D.QUANTITY	END) AS QUANTITY
		  ,SUM(CASE WHEN D.MEASURE = 'INV' THEN D.AMOUNT	ELSE (-1) * D.AMOUNT	END) AS AMOUNT
		  ,SUM(CASE WHEN D.MEASURE = 'INV' THEN D.DIO		ELSE (-1) * D.DIO		END) AS DIO
		  ,MAX(D.UNIT_PRICE_LAST)	AS UNIT_PRICE_LAST
		  ,@P_USER_ID				AS CREATED_BY
		  ,GETDATE()				AS CREATION_DATE
		  ,@P_USER_ID				AS LAST_UPDATED_BY
		  ,GETDATE()				AS LAST_UPDATE_DATE
	 FROM #SCP_RPT_DIO_TREND_MM D
	WHERE 1=1
	  AND AGGR_DV = 'TT'
	  AND MEASURE IN ('INV', 'STANDARD')
	GROUP BY D.PLAN_START_YYYYMMDD
			,D.DIVISION_ID
			,D.AGGR_DV
			,D.CATEGORY
			,D.YYYYMM
			,D.CATEGORY_DV


	--------------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'6. 합계 - 양품/OP L/T Except measure  추가 - #SCP_RPT_DIO_TREND_MM'
	--------------------------------------------------------------------------------------------------------------
	IF EXISTS (SELECT TOP 1 *
				FROM #TARGET_MEASURES
			   WHERE 1=1
				 AND MEASURE_DB IN ('AVAILABLE', 'OP-LT-EXCPT'))
	BEGIN

			print convert(varchar(30), getdate(), 121) + N'6.1 합계 RTF '
			------------------------------------------
			-- 6.1 합계 RTF
			------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_TOT_RTF') IS NOT NULL
				DROP TABLE #TMP_TOT_RTF;

			SELECT DT.AGGR_DV
				  ,DT.YYYYMM
				  ,DT.CATEGORY_DV
				  ,SUM(DT.QUANTITY										 ) AS RTF
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE1,0))  ) AS RTF_NEXT_1
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE2,0))  ) AS RTF_NEXT_2
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE3,0))  ) AS RTF_NEXT_3
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE4,0))  ) AS RTF_NEXT_4
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE5,0))  ) AS RTF_NEXT_5
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE6,0))  ) AS ACC_RTF_1
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE7,0))  ) AS ACC_RTF_2
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE8,0))  ) AS ACC_RTF_3
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE9,0))  ) AS ACC_RTF_4
				  ,SUM(CONVERT(NUMERIC(30,10), ISNULL(DT.ATTRIBUTE10,0)) ) AS ACC_RTF_5
			 INTO #TMP_TOT_RTF
			 FROM SCP_RPT_DIO_TREND_MM DT WITH(NOLOCK)
			WHERE 1=1
			  AND DT.PLAN_START_YYYYMMDD = @P_PLAN_START_YYYYMMDD
			  AND DT.DIVISION_ID		 = @P_DIVISION_ID
			  AND DT.AGGR_DV			 = 'TT'
			  AND DT.YYYYMM	BETWEEN @P_FROM_YYYYMM AND @P_TO_YYYYMM
			  AND DT.MEASURE			 = 'RTF'
			GROUP BY DT.AGGR_DV
					,DT.YYYYMM
					,DT.CATEGORY_DV

			print convert(varchar(30), getdate(), 121) + N'6.2 합계 양품재고 '
			------------------------------------------
			-- 6.2 합계 양품재고
			------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_TOT_AVAILABLE_QTY') IS NOT NULL
				DROP TABLE #TMP_TOT_AVAILABLE_QTY;

			;WITH QUALITY_ISSUES AS (
				SELECT QI.CATEGORY_DV
					  ,QI.YYYYMM
					  ,SUM(QI.ISSUE_QTY) AS ISSUE_QTY
				 FROM #QUALITY_ISSUES QI
				WHERE 1=1
				GROUP BY QI.CATEGORY_DV
					    ,QI.YYYYMM
			)
			SELECT DT.AGGR_DV
				  ,DT.CATEGORY
				  ,DT.YYYYMM
				  ,DT.ITEM_ID
				  ,DT.NICK_NAME
				  ,DT.CELL_GROUP
				  ,DT.CATEGORY_DV
				  ,DT.QUANTITY - ISNULL(QI.ISSUE_QTY, 0)	AS AVAILABLE_QTY  -- 양품수량
				  ,DT.UNIT_PRICE_LAST -- 11/21
			 INTO #TMP_TOT_AVAILABLE_QTY
			 FROM #SCP_RPT_DIO_TREND_MM  DT
				  LEFT JOIN QUALITY_ISSUES QI
						 ON QI.YYYYMM   = CASE WHEN DT.YYYYMM  >= SUBSTRING(@P_PLAN_START_YYYYMMDD, 1,6)
											   THEN SUBSTRING(@P_PLAN_START_YYYYMMDD, 1,6) -- 당월 포함 미래구간은 모두 당월(Plan 해당월) 품질이슈 수량 반영
											   ELSE DT.YYYYMM
										  END
						AND QI.CATEGORY_DV = DT.CATEGORY_DV
			WHERE 1=1
			  AND AGGR_DV = 'TT'	-- TOTAL
			  AND MEASURE = 'INV'	-- 재고

			print convert(varchar(30), getdate(), 121) + N'6.3 합계 양품재고 DIO '
			------------------------------------------
			-- 6.3 합계 양품재고 DIO
			------------------------------------------
			IF OBJECT_ID('tempdb..#TMP_TOT_AVAILABLE_DIO') IS NOT NULL
				DROP TABLE #TMP_TOT_AVAILABLE_DIO;

			SELECT I.CATEGORY
				  ,I.AGGR_DV
				  ,I.YYYYMM
				  ,I.ITEM_ID
				  ,I.NICK_NAME
				  ,I.CELL_GROUP
				  ,I.CATEGORY_DV
				  ,I.AVAILABLE_QTY
				  ,CASE WHEN I.AVAILABLE_QTY <= 0 THEN
							 0
						WHEN R.YYYYMM IS NULL THEN
							 180
						WHEN I.AVAILABLE_QTY - R.RTF_NEXT_1 < 0 THEN
							 ISNULL(CONVERT(NUMERIC(20,10), I.AVAILABLE_QTY)				 / CASE WHEN R.RTF_NEXT_1 = 0  THEN NULL ELSE R.RTF_NEXT_1  END, 0) * D.DAYS_NEXT_1
						WHEN I.AVAILABLE_QTY	 - R.RTF_NEXT_1 = 0 THEN
							 D.ACC_DAYS_1
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_2 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_1)) / CASE WHEN R.RTF_NEXT_2 = 0  THEN NULL ELSE R.RTF_NEXT_2  END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_2 = 0  THEN
							 D.ACC_DAYS_2
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_3 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_2)) / CASE WHEN R.RTF_NEXT_3 = 0  THEN NULL ELSE R.RTF_NEXT_3  END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_3 = 0  THEN
							 D.ACC_DAYS_3
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_4 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_3)) / CASE WHEN R.RTF_NEXT_4 = 0  THEN NULL ELSE R.RTF_NEXT_4  END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_4 = 0  THEN
							 D.ACC_DAYS_4
						WHEN I.AVAILABLE_QTY - R.ACC_RTF_5 < 0  THEN
							 ISNULL(CONVERT(NUMERIC(20,10), (I.AVAILABLE_QTY - R.ACC_RTF_4)) / CASE WHEN R.RTF_NEXT_5 = 0  THEN NULL ELSE R.RTF_NEXT_5  END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
						WHEN I.AVAILABLE_QTY	 - R.ACC_RTF_5 = 0  THEN
							 D.ACC_DAYS_5
						ELSE 180
					END	AS AVAILABLE_DIO
				  ,I.UNIT_PRICE_LAST -- 11/21
			 INTO #TMP_TOT_AVAILABLE_DIO
			 FROM #TMP_TOT_AVAILABLE_QTY I
				   INNER JOIN #TMP_MM_DAYS_INFO D
						  ON D.YYYYMM			 = I.YYYYMM
				   LEFT JOIN #TMP_TOT_RTF R
						  ON R.AGGR_DV			 = I.AGGR_DV
						 AND R.YYYYMM			 = I.YYYYMM
						 AND R.CATEGORY_DV		 = I.CATEGORY_DV
			WHERE 1=1

			print convert(varchar(30), getdate(), 121) + N'6.4 합계 양품 수량/DIO  MEASURE 추가 '
			------------------------------------------
			-- 6.4 합계 양품 수량/DIO  MEASURE 추가
			------------------------------------------
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,AMOUNT
						,DIO
						,UNIT_PRICE_LAST
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
			SELECT @P_PLAN_START_YYYYMMDD
				  ,@P_DIVISION_ID
				  ,I.AGGR_DV
				  ,CASE WHEN I.CATEGORY_DV = 'C'
						THEN 'Cell Convert'
						WHEN I.CATEGORY_DV = 'P'
						THEN 'Pack'
						WHEN I.CATEGORY_DV = 'A'
						THEN 'Cell'
						ELSE ''
				   END			AS CATEGORY
				  ,I.YYYYMM
				  ,I.ITEM_ID
				  ,I.NICK_NAME
				  ,I.CELL_GROUP
				  ,I.CATEGORY_DV
				  ,'AVAILABLE'	AS MEASURE
				  ,I.AVAILABLE_QTY
				  ,0.0			AS AVAILABLE_AMT
				  ,AVAILABLE_DIO
				  ,UNIT_PRICE_LAST
				  ,@P_USER_ID	AS CREATED_BY
				  ,GETDATE()	AS CREATION_DATE
				  ,@P_USER_ID	AS LAST_UPDATED_BY
				  ,GETDATE()	AS LAST_UPDATE_DATE
			 FROM #TMP_TOT_AVAILABLE_DIO I

			print convert(varchar(30), getdate(), 121) + N'6.5 합계 OP L/T Except Measure  '
			------------------------------------------
			-- 6.5 합계 OP L/T Except Measure
			------------------------------------------
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,DIO
						,UNIT_PRICE_LAST
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
			SELECT @P_PLAN_START_YYYYMMDD
				  ,@P_DIVISION_ID
				  ,ISNULL(I.AGGR_DV				  ,DT.AGGR_DV			)  AS AGGR_DV
				  ,CASE WHEN ISNULL(I.CATEGORY_DV, DT.CATEGORY_DV)  = 'C'
						THEN 'Cell Convert'
						WHEN ISNULL(I.CATEGORY_DV, DT.CATEGORY_DV) = 'P'
						THEN 'Pack'
						WHEN ISNULL(I.CATEGORY_DV, DT.CATEGORY_DV) = 'A'
						THEN 'Cell'
						ELSE ''
				   END													  AS CATEGORY
				  ,ISNULL(I.YYYYMM				  ,DT.YYYYMM			) AS YYYYMM
				  ,ISNULL(I.ITEM_ID				  ,DT.ITEM_ID			) AS ITEM_ID
				  ,ISNULL(I.NICK_NAME			  ,DT.NICK_NAME			) AS NICK_NAME
				  ,ISNULL(I.CELL_GROUP			  ,DT.CELL_GROUP		) AS CELL_GROUP
				  ,ISNULL(I.CATEGORY_DV			  ,DT.CATEGORY_DV		) AS CATEGORY_DV
				  ,'OP-LT-EXCPT'											AS MEASURE
				  ,ISNULL(I.AVAILABLE_QTY, 0.0) - ISNULL(DT.QUANTITY, 0.0)	AS QUANTITY 	-- 양품 수량  - OP L/T 수량
				  ,ISNULL(I.AVAILABLE_DIO, 0.0) - ISNULL(DT.DIO     , 0.0) 	AS DIO 			-- 양품 DIO   - OP L/T DIO
				  ,ISNULL(I.UNIT_PRICE_LAST		  ,DT.UNIT_PRICE_LAST	)   AS UNIT_PRICE_LAST
				  ,@P_USER_ID	AS CREATED_BY
				  ,GETDATE()	AS CREATION_DATE
				  ,@P_USER_ID	AS LAST_UPDATED_BY
				  ,GETDATE()	AS LAST_UPDATE_DATE
			 FROM #TMP_TOT_AVAILABLE_DIO I
				  FULL OUTER JOIN #SCP_RPT_DIO_TREND_MM DT
						 ON DT.YYYYMM			= I.YYYYMM
						AND DT.CATEGORY_DV		= I.CATEGORY_DV
						AND DT.AGGR_DV			= 'TT'
			WHERE 1=1
			  AND DT.MEASURE = 'OP-LT'

	END


	------------------------------------------------------------------------------------------
	-- 2023.01.11
	-- 당월 포함 미래 구간
	-- 모델별(Aggr_dv='MD') Pack 수율 반영 전 생산 계획 수량 measure 추가
	------------------------------------------------------------------------------------------
	IF @p_aggr_dv = 'MD' AND @P_CATEGORY LIKE '%P%' -- 모델별 Pack 조회시
		AND  EXISTS (SELECT TOP 1 *
				  	  FROM #TARGET_MEASURES
				     WHERE 1=1
				  	   AND MEASURE_DB = 'PROD-BEFORE-PACK')
	BEGIN
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,AMOUNT
						,DIO
						,UNIT_PRICE_LAST
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
				SELECT
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,'PROD-BEFORE-PACK'									AS MEASURE
						,CONVERT(NUMERIC(20,10), ISNULL(ATTRIBUTE1, '0'))	AS QUANTITY
						,0
						,0
						,UNIT_PRICE_LAST
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
				 FROM #SCP_RPT_DIO_TREND_MM
				WHERE AGGR_DV		= 'MD'
				  AND CATEGORY_DV	= 'P'
				  AND MEASURE		= 'PROD'
				  AND YYYYMM		>= SUBSTRING(@p_plan_start_yyyymmdd, 1, 6)

	END

	------------------------------------------------------------------------------------------
	-- 2023.01.11
	-- 당월 포함 미래 구간
	-- 모델별(Aggr_dv='MD') 팩 생산에 소요된 셀수량  및 수율 반영 후 셀수량 measure 추가
	------------------------------------------------------------------------------------------
	IF @p_aggr_dv = 'MD' AND @P_CATEGORY LIKE '%A%' -- 모델별 Cell 조회시
	BEGIN
			 -- Pack 생산에 소요된 셀 수량
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,AMOUNT
						,DIO
						,UNIT_PRICE_LAST
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
				SELECT
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,'CELL-USED'										AS MEASURE
						,CONVERT(NUMERIC(20,10), ISNULL(ATTRIBUTE1, '0'))	AS QUANTITY
						,0
						,0
						,UNIT_PRICE_LAST
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
				 FROM #SCP_RPT_DIO_TREND_MM
				WHERE AGGR_DV		= 'MD'
				  AND CATEGORY_DV	= 'A'
				  AND MEASURE		= 'PROD'
				  AND YYYYMM		>= SUBSTRING(@p_plan_start_yyyymmdd, 1, 6)
				  AND EXISTS (SELECT TOP 1 *
				  			  FROM #TARGET_MEASURES
							 WHERE 1=1
				  			   AND MEASURE_DB = 'CELL-USED')


			 -- 수율 반영 후 셀 생산 계획 수량
			INSERT INTO #SCP_RPT_DIO_TREND_MM (
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,MEASURE
						,QUANTITY
						,AMOUNT
						,DIO
						,UNIT_PRICE_LAST
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						)
				SELECT
						 PLAN_START_YYYYMMDD
						,DIVISION_ID
						,AGGR_DV
						,CATEGORY
						,YYYYMM
						,ITEM_ID
						,NICK_NAME
						,CELL_GROUP
						,CATEGORY_DV
						,'PROD-AFTER-CELL'	AS MEASURE
						,DIO				AS QUANTITY
						,0
						,0
						,UNIT_PRICE_LAST
						,PIC_ID
						,DEPT_ID
						,PROJECT_CODE
						,TARGET_CELL
						,CELL_CF
						,PRODUCTION_CYCLE
						,SAFETY_STOCK
						,PRE_INSPECTION
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
				 FROM #SCP_RPT_DIO_TREND_MM
				WHERE AGGR_DV		= 'MD'
				  AND CATEGORY_DV	= 'A'
				  AND MEASURE		= 'PROD'
				  AND YYYYMM		>= SUBSTRING(@p_plan_start_yyyymmdd, 1, 6)
				  AND EXISTS (SELECT TOP 1 *
				  			  FROM #TARGET_MEASURES
							 WHERE 1=1
				  			   AND MEASURE_DB = 'PROD-AFTER-CELL')

	END

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'7.1 Insert #fdata 최종 조회 대상 데이터'
	-----------------------------------------------------------------------------------------------------------
	IF OBJECT_ID('tempdb..#fdata') IS NOT NULL
		DROP TABLE #fdata;

	;WITH DIO_REASON AS (
		SELECT DISTINCT
		       R.YYYYMM
			  ,CELL_GROUP
			  ,'Y' AS EXISTS_REASON
		FROM SCP_RPT_DIO_TREND_MM_REASON R WITH(NOLOCK) -- DIO 초과 사유
	   WHERE R.DIVISION_ID = @p_division_id
	     AND R.AGGR_DV	   = 'CG'
		 AND R.CATEGORY_DV = 'C'
		 AND R.ITEM_ID     = '*'
	     AND R.YYYYMM BETWEEN @p_from_yyyymm
						  AND @p_to_yyyymm
		 AND R.QUANTITY IS NOT NULL
		 AND R.QUANTITY != 0
	)
	select dt.plan_start_yyyymmdd
		  ,dt.division_id
		  ,dt.aggr_dv
		  ,dt.yyyymm
		  ,dt.item_id
		  ,dt.nick_name
		  ,dt.CATEGORY_DV
		  ,dt.cell_cf
		  ,case when dt.CATEGORY_DV = 'C' AND AGGR_DV != 'MD'
				then '-'
				else dt.target_cell
			end as target_cell
		  ,max(case when dt.CATEGORY_DV = 'C' AND AGGR_DV != 'MD'
					then '-'
					else dt.cell_group_target
				end)	over (partition by case when dt.CATEGORY_DV = 'C' AND AGGR_DV != 'MD'
												then '-'
												else dt.target_cell
											end)	as cell_group_target
		  ,dt.cell_group
		  ,dt.dept_id
		  ,di.dept_name_ko
		  ,dt.pic_id
		  ,ui.user_name as pic_name
		  ,dt.project_code
		  ,pj.project_name
		  ,dt.unit_price_last
		  ,dt.PRODUCTION_CYCLE
		  ,dt.SAFETY_STOCK
		  ,dt.PRE_INSPECTION
		  ,ti.measure_db
		  ,ti.measure_ui
		  ,ti.measure_name
		  ,ti.sort_order_no
		  ,dt.category
		  ,case when ti.col_div = 'QTY' then dt.quantity / @P_UNIT_QTY
				when ti.col_div = 'DIO' then dt.dio
				when ti.col_div = 'AMT' then dt.amount  / @P_UNIT_AMOUNT
				else null   -- else case는 있을 수 없음 !!!  (있으면 안됨!!)
			end as value
		  ,y.yield
		  ,dr.EXISTS_REASON
	into #fdata
	from #SCP_RPT_DIO_TREND_MM dt
		 inner join #TARGET_MEASURES TI   --- select * from #TARGET_MEASURES
				 on dt.measure = TI.MEASURE_DB
		 left join scm_mst_sso_dept_info di with(nolock)
				on di.dept_id = dt.dept_id
		 left join scm_mst_sso_user_info ui with(nolock)
				on ui.user_id = dt.pic_id
		 left join scm_mst_project pj with(nolock)
				on pj.division_id = dt.division_id
			   and pj.project_code = dt.project_code
		 left join #YIELD_INFO Y
				on Y.item_id = dt.item_id
	     left join DIO_REASON dr
				on dr.yyyymm	 = dt.yyyymm
			   and dr.cell_group = dt.cell_group
	WHERE 1=1


	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'7.2 delete #fdata (기타충당금 수량/DIO)'
	-----------------------------------------------------------------------------------------------------------
	DELETE FROM #fdata
	 WHERE AGGR_DV		= 'ET'
	   AND MEASURE_UI IN ('INV_QTY', 'INV_DIO')


	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'8.1. Select @v_query_mm_case 쿼리 조합'
	-----------------------------------------------------------------------------------------------------------
	;with mm_list as (
		SELECT DISTINCT ' CASE WHEN  FD.MEASURE_UI LIKE ''%DIO'' THEN  FORMAT( ISNULL(MAX(CASE WHEN FD.YYYYMM = '''+ B.YYYYMM   + ''' THEN value ELSE NUll END), 0) , ''##0.0'')    ELSE   FORMAT( ISNULL(MAX(CASE WHEN FD.YYYYMM = '''+ B.YYYYMM   + ''' THEN value ELSE NUll END), 0) , ''##0'')        END  AS "'+  concat('M_',B.YYYYMM) + '" ' + CHAR(10)
					   +',ISNULL(MAX(MAX(CASE WHEN FD.YYYYMM = '''   + B.YYYYMM   + ''' THEN FD.EXISTS_REASON ELSE NULL END)) OVER (PARTITION BY FD.PLAN_START_YYYYMMDD),''N'')   AS "'  +  concat('EXISTS_REASON_',B.YYYYMM) + '" '
					   as col
		  FROM SCM_MST_BUCKET B WITH(NOLOCK)
		 WHERE B.YYYYMM BETWEEN @P_FROM_YYYYMM
							AND @P_TO_YYYYMM
	 )
	select @v_query_mm_case = STUFF(( SELECT ',' +  col
										FROM MM_LIST
									   WHERE 1=1
										FOR XML PATH('')), 1, 1,'')
	;

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'8.2. Select #fdata 쿼리 조합'
	-----------------------------------------------------------------------------------------------------------
	set @v_query = N'select
						   PLAN_START_YYYYMMDD
						  ,DIVISION_ID
						  ,AGGR_DV
						  ,Category					AS CATEGORY
						  ,CATEGORY_DV
						  ,item_id					as MODEL
						  ,max(nick_name)			as NICK_NAME
						  ,max(cell_group)			as CELL_GROUP
						  ,measure_db				as MEASURE_DB   -- db테이블 measure 컬럼값
						  ,measure_ui				as MEASURE_UI	--구분코드
						  ,measure_name				as MEASURE_NAME	--구분
						  '
		  +',' + @v_query_mm_case

		  +N'			  ,max(cell_cf		)		as	CELL_CF				-- CELL환산계수
						  ,max(target_cell  )		as	TARGET_CELL			-- TARGET_CELL (환산된 경우 SRC ITEM 중 택1)
						  ,max(cell_group_target  )	as	CELL_GROUP_TARGET	-- TARGET_CELL CELL GROUP
						  ,max(pic_name		)		as	PIC_NAME			-- 담당자
						  ,max(dept_name_ko	)		as	DEPT_NAME_KO		-- 팀
						  ,max(project_name	)		as	PROJECT_NAME		-- 프로젝트
						  ,FORMAT(max(unit_price_last)		, ''##0''			) AS UNIT_PRICE_LAST	-- 단가
						  ,FORMAT(max(production_cycle)		, ''##0.0''			) AS PRODUCTION_CYCLE	-- 주기재고
						  ,FORMAT(max(safety_stock)			, ''##0.0''			) AS SAFETY_STOCK		-- 안전재고
						  ,FORMAT(max(pre_inspection)		, ''##0.0''			) AS PRE_INSPECTION		-- 전진검사
						  ,FORMAT(max(yield)				, ''##0.00000000''	) AS YIELD				-- 수율
		   from #fdata fd
		  where 1=1
			 group by PLAN_START_YYYYMMDD
					 ,DIVISION_ID
					 ,AGGR_DV
					 ,category
					 ,CATEGORY_DV
					 ,item_id
					 ,measure_db
					 ,measure_ui
					 ,measure_name
					 ,sort_order_no
			order by case when category = ''Cell Convert''	then 1
						  when category = ''Cell''			then 2
						  when category = ''Pack''			then 3
						  else 9
					 end
					,case when aggr_dv = ''CG'' then 1
						  when aggr_dv = ''MD'' then 2
						  when aggr_dv = ''ET'' then 7
						  when aggr_dv = ''TT'' then 8
						  else 9
					 end
					,item_id
				    ,sort_order_no
			'

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'8.3, 최종 결과 조회 쿼리 실행 '
	-----------------------------------------------------------------------------------------------------------

	--PRINT @v_query;
	
	exec sp_executesql @v_query;

	-----------------------------------------------------------------------------------------------------------
	print convert(varchar(30), getdate(), 121) + N'8.3, 최종 결과 조회 쿼리 실행 end'
	-----------------------------------------------------------------------------------------------------------


END
