






/*
 * Program ID   : [PR_SCP_XLS_EXCEL_BODY_XLSPSI02]
 * Description  : SCP SIMULATION EXCEL SHEET BODY QUERY
 * OutTable     :
 * Execute      : 

  EXEC PR_SCP_XLS_EXCEL_BODY_XLSPSI02  
                                                   @p_division_id   = '40'
                                                  ,@p_pgm_code      = 'XLSPSI02'
                                                  ,@p_parameter1    = ''
                                                  ,@p_parameter2    = ''
                                                  ,@p_parameter3    = 'MCCH125020A1'
                                                  ,@p_parameter4    = ''
                                                  ,@p_parameter5    ='20250303'  

												 

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
  * 2019.01.07   YYDOK         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *              KSG           과거 이력 정리
 * 2022.02.21   KSW			  DC link 적용
 * 2022.02.22   KSW           소형 Shipment plan 시뮬레이터 조회기능개선
 * 2022.04.07   KSW           소형 Shipment plan 시뮬레이터 조회기능개선2
 * 2022.05.02   KSW           Daily & Monthly Bucket 개선적용
 * 2022.05.13   KSW			  GM JV 반영
 * 2022.05.23   KSW			  ESS Pack 시뮬레이터 가동율시트 - Cell Total measure 추가
 * 2022.06.22   KSW			  소형 Shipment plan 시뮬레이터 From Site 컬럼추가
 * 2022.07.18   KSW			  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
 * 2022.08.11   KSW           중장기 +1 Year 변경처리
 * 2022.08.30   KSW			  자동차 Cell 재고 개선건
 * 2022.09.21	KSW			  소형SCM개선요청사항 적용
 * 2022.09.30	KSW			  자동차 Load Ratio 조회안되게 변경
 * 2022.12.22   KSW			  XLSPSI21 소형 출하 시뮬레이터 - DEPT_NAME_EN 식별문제로 DEPT_ID 를 붙여서 식별하는 것으로 변경 :: 2022.12.22
 * 2023.02.09   KKH			  XLSPSI01 pack cell 순서로 다시 정렬
 * 2023.03.09   KKH			 소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
 * 2023.07.10   DHJ			  소형 출하시뮬레이터 INVENTORY, PROD_PLAN_ENGINE에 값을 가져올떄 CA모델 수량 합산 AS-IS : ONLY CP QTY, TO-BE : CP + CA QTY 
 * 2023.07.25   DHJ			FIXED FOR BUG --* 2023.07.10   1298
 * 2023.08.04   KSK			PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 (사업계획 수립에 따른 시뮬레이터 생산계획Bucket 확장 적용)
 * 2023.10.06   KHJ			확정구간의 기준을 LOOKUP 테이블을 우선참조하도록 함
 * 2023.10.12   KHJ			ESS-PACK(XLSPSI06). SHIP_REQ가 없는 것에 대해서 조회되지 않도록 기능개선.
 * 2023.12.01   KHJ			소형출하계획 (XLSPSI21). FROM_SITE별 출하계획 조회/할당/저장
 * 2023.12.15   OIJ			QUERY 정리(HAVING 삭제, JOIN 수정, IN구문 JOIN구문으로 일부변경)
 * 2023.12.29   KHJ			공용 Cell의 경우 BOH 로직 개선
 * 2024.03.22   KSK			ESS PROD LOAD조회 관련  SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_V와 SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK_BP_V를
									    FN_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK으로 통합처리
 * 2024.09.25   KSK			팩셀관련메저의 정렬순서 보정(PACK/PACK-CELL/기타순서의 가중치 변경 10000,10010,10020=> 1, 10000, 10000000)

 * 2024.11.11   KSK         PR_SCP_XLS_EXCEL_BODY_QUERY 에서 소형팩 조회부분을 분리함
 * 2025.03.05   KSK         SHIP_REQ를 SHIP_PLAN 바로 위에 배치
 * 2025.03.06   KSK         성능개선위해 FN_SplitString를 시스템함수 String_Split로  대체
*/

CREATE PROCEDURE [dbo].[PR_SCP_XLS_EXCEL_BODY_XLSPSI02]
(
  @p_division_id   VARCHAR(10)	,
  @p_pgm_code      VARCHAR(40),
  @p_parameter1    VARCHAR(MAX)  ='',   --researved
  @p_parameter2    VARCHAR(MAX)  ='',   --researved
  @p_parameter3    VARCHAR(MAX)  ='',   -- CELL_ITEM_ID LIST,  Delimeter는 (,)
  @p_parameter4    VARCHAR(MAX)  ='',   --RESEARVED
  @p_parameter5    VARCHAR(MAX)  =''    -- DAY 구간의 ENDDATE (YYYYMMDD)
    , @p_is_debug		bit = 0	
 )
AS
BEGIN

DECLARE @v_plan_start_yyyymmdd  NVARCHAR(0008) = NULL;
	DECLARE @v_plan_type            NVARCHAR(4000) = 'MA';
	DECLARE @v_seq                  NVARCHAR(0008) = NULL;
	DECLARE @v_create_to_yyyymmdd    NVARCHAR(0008);	
	DECLARE @v_create_from_yyyymmd2  NVARCHAR(0008) = NULL; --2차년도 구간시작일
	DECLARE @v_create_to_yyyymmdd2  NVARCHAR(0008) = NULL;
	DECLARE @SQL                    NVARCHAR(MAX);

	--  Plan End Date
	DECLARE @v_bp_flag		NVARCHAR(8) = '';
	DECLARE @v_bp_days		INT = 0;
	DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

	
--------- 계획관련 변수 초기화 시작 -----------------------------
	SELECT 
		   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
		   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	-- 최근의 플랜정보 조회시 상세정보가 유효한 것을 조건으로 수정함(KSK, 2024/11/11)
	AND    p.plan_id     =  (SELECT max(a.plan_id)
                              FROM dbo.scm_mst_plan a WITH(NOLOCK) 
							  join scm_mst_plan_detail b with(nolock) 
								on a.division_id = b.division_id
								and a.plan_id = b.plan_id
                              WHERE a.division_id = @p_division_id  and a.plan_id < 9999) ;
	 
	  -- 2022.03.24 KSW Daily & Monthly Bucket 개선적용
	SELECT TOP 1 @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
	FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK) ;
		
		-- 1차년도 구간종료일
		SET @v_create_to_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,363,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112) ;
		-- 2차년도 구간시작일
		SET @v_create_from_yyyymmd2 = dbo.FN_XLS_DATE(@v_plan_start_yyyymmdd, 364);	
		-- 2차년도 구간종료일
		SET @v_create_to_yyyymmdd2 = CONVERT(VARCHAR,DATEADD(D,363,CONVERT(DATETIME,(@v_create_from_yyyymmd2),112)),112) ;

		IF @p_is_debug = 1 select @v_plan_start_yyyymmdd as "@v_plan_start_yyyymmdd" , @v_create_to_yyyymmdd AS "@v_create_to_yyyymmdd"
			, @v_create_from_yyyymmd2 "@v_create_from_yyyymmd2", @v_create_to_yyyymmdd2 as "@v_create_to_yyyymmdd2"

		SELECT TOP 1 @v_plan_type = PLAN_TYPE
			   ,@v_seq            = SEQ
		  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
		 WHERE PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		 order by creation_date desc

--------- 계획관련 변수 초기화 완료 -----------------------------

		DECLARE @v_dayend_yyyymmdd		NVARCHAR(20) = @p_parameter5;
		DECLARE @v_day_cols				NVARCHAR(4000) = '';
		DECLARE @v_day_cols_N			NVARCHAR(MAX) = '';
		DECLARE @v_day_cols_O			NVARCHAR(MAX) = '';

		-- Dayily End 일자를 월 말일로 조정한다.
		DECLARE @v_daily_last_yyyymmdd	NVARCHAR(0008) = '';

		-- 지정된 일자의 월말 구하기
		SELECT @v_daily_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,31,CONVERT(DATETIME,(LEFT(@v_dayend_yyyymmdd, 6) + '01'),112)),112)
		SELECT @v_daily_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(LEFT(@v_daily_last_yyyymmdd, 6) + '01'),112)),112)
		IF @P_IS_DEBUG = 1 SELECT @v_daily_last_yyyymmdd AS "지정일자의 말일"

------- 1차년도 Daily 컬럼---------------------------------------------------------------------------------------------------------------------
		SELECT @v_day_cols = @v_day_cols + 'QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3) + ', '
			, @v_day_cols_N = @v_day_cols_N + 'BB.QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3) + ' AS '+'QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3)+'N, '
			, @v_day_cols_O = @v_day_cols_O + 'AA.QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3) + ' AS '+'QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3)+'O, '
		FROM (
				SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
						,C.BASIS_YYYYMMDD AS E_YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE C.BASIS_YYYYMMDD BETWEEN  @v_plan_start_yyyymmdd AND @v_create_to_yyyymmdd
			) X		;
					
		IF @P_IS_DEBUG = 1  SELECT @v_day_cols "@v_day_cols", @v_day_cols_N "@v_day_cols_N", @v_day_cols_O "@v_day_cols_O"


------- Monthly 컬럼---------------------------------------------------------------------------------------------------------------------		
		DECLARE @v_tbl_month TABLE (DAY_NUM INT, YYYYMMDD NVARCHAR(8), C_YEAR INT, C_MONTH INT);
		
		DECLARE @v_tbl_cnt	INT = 0;		
		DECLARE	@v_lp		INT = 0;
		DECLARE	@v_lp_2		INT = 0;
		DECLARE @v_month_tmp			NVARCHAR(MAX) = '';
		DECLARE @v_month_cols			NVARCHAR(MAX) = '';
		DECLARE @v_curr_year			INT = 0;
		DECLARE @v_curr_month			INT = 0;
		DECLARE @v_month_tmp_2			NVARCHAR(MAX) = '';
		DECLARE @v_month_cols_2			NVARCHAR(MAX) = '';
		DECLARE @v_month_cols_O			NVARCHAR(MAX) = '';
		DECLARE @v_month_cols_N			NVARCHAR(MAX) = '';
		DECLARE @v_New_month_cols			NVARCHAR(MAX) = '';		
		DECLARE @v_curr_year_2			INT = 0;
		DECLARE @v_curr_month_2			INT = 0;
		

		IF @v_bp_flag = 'N'
		BEGIN

			INSERT @v_tbl_month
			SELECT *
				FROM (
					SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS E_YYYYMMDD, CONVERT(INT, C.CALENDAR_YYYY) AS C_YEAR, CONVERT(INT, C.CALENDAR_MONTH) AS C_MONTH
					FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
					WHERE C.BASIS_YYYYMMDD between  @v_plan_start_yyyymmdd  AND  @v_create_to_yyyymmdd
					) X
				WHERE X.E_YYYYMMDD > @v_daily_last_yyyymmdd------------다음달 1일 부터 364일 후 까지...
			;

			SELECT @v_tbl_cnt = COUNT(*) 
			FROM (SELECT DISTINCT C_YEAR, C_MONTH 
					 FROM @v_tbl_month 
					 WHERE YYYYMMDD <=  @v_create_to_yyyymmdd) X;

			SELECT TOP 1 @v_curr_year = C_YEAR, @v_curr_month = C_MONTH 
			FROM @v_tbl_month  WHERE YYYYMMDD <=  @v_create_to_yyyymmdd;

			WHILE (@v_lp < @v_tbl_cnt)
			BEGIN
				SET @v_month_tmp = '';

				SELECT @v_month_tmp = @v_month_tmp + 'QTY' + RIGHT('00' + CONVERT(VARCHAR, DAY_NUM), 3) + '+' 
				  FROM @v_tbl_month 
				 WHERE C_YEAR  = @v_curr_year
				   AND C_MONTH = @v_curr_month
				;

				SET @v_month_cols = @v_month_cols + '(' + SUBSTRING(@v_month_tmp, 1, LEN(@v_month_tmp) - 1) + ') AS MQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_curr_month), 2) + ',';

				SET @v_curr_month = @v_curr_month + 1;

				IF (@v_curr_month = 13)
				BEGIN
					SET @v_curr_month = 1;
					SET @v_curr_year = @v_curr_year + 1;
				END

				SET @v_lp = @v_lp + 1;
			END


			IF @P_IS_DEBUG = 1 SELECT @v_month_cols "@v_month_cols"

			SET @SQL = '';
			SET @SQL = @SQL + 'SELECT XX.DIVISION_ID';
			SET @SQL = @SQL + '      ,XX.PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '      ,PLAN_TYPE';
			SET @SQL = @SQL + '      ,SEQ';
			SET @SQL = @SQL + '      ,XX.OPERATION_GROUP';
			SET @SQL = @SQL + '      ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '      ,XX.CELL_ITEM_ID';
			SET @SQL = @SQL + '      ,XX.ITEM_ID';
			SET @SQL = @SQL + '      ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '      ,XX.NICK_NAME';
			SET @SQL = @SQL + '      ,CELL_QTY_PACK';
			SET @SQL = @SQL + '      ,TO_SITE';
			SET @SQL = @SQL + '      ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,PROJECT_CODE';
			SET @SQL = @SQL + '      ,FROM_BOH_QTY';
			SET @SQL = @SQL + '      ,TO_BOH_QTY';
			SET @SQL = @SQL + '      ,INCOTERMS';
			SET @SQL = @SQL + '      ,FROM_SITE';
			SET @SQL = @SQL + '      ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,TRANSPORT_MODE';
			SET @SQL = @SQL + '      ,LT_DAY';         
			SET @SQL = @SQL + '      ,PROD_LINE';                                        
			SET @SQL = @SQL + '      ,YIELD';                                        
			SET @SQL = @SQL + '      ,XX.END_CUSTOMER';                                        
			SET @SQL = @SQL + '      ,BOD_ID';                                        
			SET @SQL = @SQL + '      ,MEASURE';                                        
			SET @SQL = @SQL + '      ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '      ,XLS_KEY1';                                        
			SET @SQL = @SQL + '      ,XLS_KEY2';                                        
			SET @SQL = @SQL + '      ,XLS_KEY3';                                        
			SET @SQL = @SQL + '      ,XLS_KEY4';                                        
			SET @SQL = @SQL + '      ,XLS_KEY5';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '      ,CALC_YN';                                        
			SET @SQL = @SQL + '      ,DISPLAY_YN';                                        
			SET @SQL = @SQL + '      ,SORT_ORDER_NO';        
			SET @SQL = @SQL + '      ,LAST_QTY';
			SET @SQL = @SQL + '      ,' + @v_day_cols;
			SET @SQL = @SQL + '       ' + @v_month_cols;
                                                                             
			SET @SQL = @SQL + '       XX.CREATED_BY';                                        
			SET @SQL = @SQL + '      ,XX.CREATION_DATE';                                        
			SET @SQL = @SQL + '      ,XX.LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,XX.LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE3';
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE9';
			SET @SQL = @SQL + '      ,SX.flow_id';
			SET @SQL = @SQL + '  FROM (';
			SET @SQL = @SQL + 'SELECT DIVISION_ID';
			SET @SQL = @SQL + '      ,PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '      ,PLAN_TYPE';
			SET @SQL = @SQL + '      ,SEQ';
			SET @SQL = @SQL + '      ,OPERATION_GROUP';
			SET @SQL = @SQL + '      ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '      ,CELL_ITEM_ID';
			SET @SQL = @SQL + '      ,ITEM_ID';
			SET @SQL = @SQL + '      ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '      ,NICK_NAME';
			SET @SQL = @SQL + '      ,CELL_QTY_PACK';
			SET @SQL = @SQL + '      ,TO_SITE';
			SET @SQL = @SQL + '      ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,PROJECT_CODE';
			SET @SQL = @SQL + '      ,FROM_BOH_QTY';
			SET @SQL = @SQL + '      ,TO_BOH_QTY';
			SET @SQL = @SQL + '      ,INCOTERMS';
			SET @SQL = @SQL + '      ,FROM_SITE';
			SET @SQL = @SQL + '      ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,TRANSPORT_MODE';
			SET @SQL = @SQL + '      ,LT_DAY';         
			SET @SQL = @SQL + '      ,PROD_LINE';                                        
			SET @SQL = @SQL + '      ,YIELD';                                        
			SET @SQL = @SQL + '      ,END_CUSTOMER';                                        
			SET @SQL = @SQL + '      ,BOD_ID';                                        
			SET @SQL = @SQL + '      ,MEASURE';                                        
			SET @SQL = @SQL + '      ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '      ,XLS_KEY1';                                        
			SET @SQL = @SQL + '      ,XLS_KEY2';                                        
			SET @SQL = @SQL + '      ,XLS_KEY3';                                        
			SET @SQL = @SQL + '      ,XLS_KEY4';                                        
			SET @SQL = @SQL + '      ,XLS_KEY5';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '      ,CALC_YN';                                        
			SET @SQL = @SQL + '      ,DISPLAY_YN';                                        
			SET @SQL = @SQL + '      ,SORT_ORDER_NO';        
			SET @SQL = @SQL + '      ,LAST_QTY';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
		
			SET @SQL = @SQL + '      ,' + @v_day_cols;
			SET @SQL = @SQL + '       ' + @v_month_cols;
                                                                             
			SET @SQL = @SQL + '       CREATED_BY';                                        
			SET @SQL = @SQL + '      ,CREATION_DATE';                                        
			SET @SQL = @SQL + '      ,LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE3';
			SET @SQL = @SQL + '      ,ATTRIBUTE9';
			SET @SQL = @SQL + '              ,(CASE WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9  = ''P5000'' THEN 2100';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9 <> ''P5000'' AND (SELECT TOP 1 FLOW_ID';
			SET @SQL = @SQL + '              				                                                        FROM SCM_MST_ITEM_SN M WITH (NOLOCK)';
			SET @SQL = @SQL + '              				                                                       WHERE M.DIVISION_ID = X.DIVISION_ID';
			SET @SQL = @SQL + '              				                                                         AND M.ITEM_ID     = (SELECT TOP 1 CHILD_ITEM_ID';
			SET @SQL = @SQL + '              								   	                                                            FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK)';
			SET @SQL = @SQL + '              									                                                           WHERE A.DIVISION_ID = X.DIVISION_ID';
			SET @SQL = @SQL + '              									                                                             AND A.MODEL_ID    = X.ITEM_ID)) = ''P5000'' THEN 2000 ';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9 <> ''P5000'' THEN 1000';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''A'' AND ATTRIBUTE9  = ''P5000'' THEN 3000';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''A'' AND ATTRIBUTE9 <> ''P5000'' THEN 4000 ELSE 5000 END) AS ORDNO';
			SET @SQL = @SQL + '  FROM (';
			SET @SQL = @SQL + '        SELECT DIVISION_ID';
			SET @SQL = @SQL + '              ,PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '              ,PLAN_TYPE';
			SET @SQL = @SQL + '              ,SEQ';
			SET @SQL = @SQL + '              ,OPERATION_GROUP';
			SET @SQL = @SQL + '              ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '              ,CELL_ITEM_ID';
			SET @SQL = @SQL + '              ,ITEM_ID';
			SET @SQL = @SQL + '              ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '              ,NICK_NAME';
			SET @SQL = @SQL + '              ,CELL_QTY_PACK';
			SET @SQL = @SQL + '              ,TO_SITE';
			SET @SQL = @SQL + '              ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '              ,PROJECT_CODE';
			SET @SQL = @SQL + '              ,FROM_BOH_QTY';
			SET @SQL = @SQL + '              ,TO_BOH_QTY';
			SET @SQL = @SQL + '              ,INCOTERMS';
			SET @SQL = @SQL + '              ,FROM_SITE';
			SET @SQL = @SQL + '              ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '              ,TRANSPORT_MODE';
			SET @SQL = @SQL + '              ,LT_DAY';         
			SET @SQL = @SQL + '              ,PROD_LINE';                                        
			SET @SQL = @SQL + '              ,YIELD';                                        
			SET @SQL = @SQL + '              ,END_CUSTOMER';                                        
			SET @SQL = @SQL + '              ,BOD_ID';                                        
			SET @SQL = @SQL + '              ,MEASURE';                                        
			SET @SQL = @SQL + '              ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '              ,XLS_KEY1';		
			SET @SQL = @SQL + '              ,XLS_KEY2';                                        
			SET @SQL = @SQL + '              ,XLS_KEY3';                                        
			SET @SQL = @SQL + '              ,XLS_KEY4';                                        
			SET @SQL = @SQL + '              ,XLS_KEY5';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '              ,'''' AS CALC_YN';                                        
			SET @SQL = @SQL + '              ,'''' AS DISPLAY_YN';                                        
			-- 정렬순서 변경 (KSK, 2025.03.05)
			SET @SQL = @SQL + '              ,CASE MEASURE WHEN ''SHIP_REQ'' THEN 30 WHEN ''WHIN_TOTAL'' THEN 20 ELSE  SORT_ORDER_NO END AS SORT_ORDER_NO'; 
			SET @SQL = @SQL + '              ,LAST_QTY';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
		                           
			SET @SQL = @SQL + '              ,' + @v_day_cols;
			SET @SQL = @SQL + '               ' + @v_month_cols;
                                                                                     
			SET @SQL = @SQL + '               CREATED_BY';                                        
			SET @SQL = @SQL + '              ,CREATION_DATE';                                        
			SET @SQL = @SQL + '              ,LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '              ,LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '              ,ATTRIBUTE1';                                        
			SET @SQL = @SQL + '              ,ATTRIBUTE10';                                        
			SET @SQL = @SQL + '              ,REPLACE(ATTRIBUTE3, '','', ''|'') AS ATTRIBUTE3';			--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			SET @SQL = @SQL + '              ,(CASE WHEN MEASURE IN (''PREV_PACK_PROD'', ''PREV_PACK_SHIP_PLAN'') AND ATTRIBUTE9 IS NULL THEN (SELECT TOP 1 A.ATTRIBUTE9';
			SET @SQL = @SQL + '																													 FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK A WITH (NOLOCK)';
			SET @SQL = @SQL + '																													WHERE A.PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.PLAN_TYPE           = ''' + @v_plan_type + '''';
			SET @SQL = @SQL + '																													  AND A.SEQ                 = ''' + @v_seq + '''';
			SET @SQL = @SQL + '																													  AND A.CELL_ITEM_ID		= X.CELL_ITEM_ID';
			SET @SQL = @SQL + '																													  AND A.ITEM_ID				= X.ITEM_ID';
			SET @SQL = @SQL + '																													  AND A.FROM_SITE			= X.FROM_SITE';
			SET @SQL = @SQL + '																													  AND A.TO_SITE				= X.TO_SITE';
			SET @SQL = @SQL + '																													  AND A.MEASURE				IN (''PACK_PROD'', ''PACK_SHIP_PLAN'')';
			SET @SQL = @SQL + '                                                                                                               )';
			SET @SQL = @SQL + '                     ELSE ATTRIBUTE9 END) AS ATTRIBUTE9';
			SET @SQL = @SQL + '          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)';                    
			SET @SQL = @SQL + '         WHERE 0 = 0';                                         
			SET @SQL = @SQL + '            AND DIVISION_ID         = ''' + @p_division_id + '''';       
			SET @SQL = @SQL + '            AND PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND PLAN_TYPE           = ''' + @v_plan_type + '''';
			SET @SQL = @SQL + '            AND SEQ                 = ''' + @v_seq + '''';
			SET @SQL = @SQL + '            AND CELL_ITEM_ID IN (SELECT Token from String_Split(''' + @p_parameter3 + ''','',''))';
			SET @SQL = @SQL + '            AND NOT MEASURE = ''OLD_CELL_SHIP_PLAN''';
			SET @SQL = @SQL + '       ) X ';
			SET @SQL = @SQL + '       ) XX ';
			--2023.03.09   KKH			 소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
			SET @SQL = @SQL + '   LEFT JOIN   ';
			SET @SQL = @SQL + '   (   ';
			SET @SQL = @SQL + '   SELECT A.DIVISION_ID, A.ITEM_ID,B.FLOW_ID     ';
			SET @SQL = @SQL + '   FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V A WITH(NOLOCK)   ';
			SET @SQL = @SQL + '   , SCP_MST_FINAL_ITEM B WITH(NOLOCK)   ';
			SET @SQL = @SQL + '   WHERE 1=1   ';
			SET @SQL = @SQL + '   AND A.DIVISION_ID = B.DIVISION_ID   ';
			SET @SQL = @SQL + '   AND A.ITEM_ID = B.ITEM_ID   ';
			SET @SQL = @SQL + '   AND A.IS_YN = ''Y''   ';
			SET @SQL = @SQL + '   ) SX   ';
			SET @SQL = @SQL + '   on SX.DIVISION_ID = XX.DIVISION_ID  ';
			SET @SQL = @SQL + '   and SX.ITEM_ID = XX.ITEM_ID   ';

			SET @SQL = @SQL + 'ORDER BY CELL_ITEM_ID, OPERATION_GROUP DESC, /*, ORDNO*/ ITEM_ID										
										, CASE WHEN TO_SITE = ''-'' THEN ''ZZZ'' ELSE TO_SITE END 
										, CASE WHEN (FROM_SITE = ''-''  AND MEASURE LIKE ''CELL%'' ) THEN ''-'' ELSE FROM_SITE END
										, PROJECT_CODE
										, INCOTERMS
										, SORT_ORDER_NO
																	';
		END

		IF @v_bp_flag = 'Y'
		BEGIN

			INSERT @v_tbl_month
			SELECT *
				FROM (
					SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS E_YYYYMMDD, CONVERT(INT, C.CALENDAR_YYYY) AS C_YEAR, CONVERT(INT, C.CALENDAR_MONTH) AS C_MONTH
					FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
					WHERE C.BASIS_YYYYMMDD between @v_plan_start_yyyymmdd and @v_create_to_yyyymmdd2
					) X
				WHERE X.E_YYYYMMDD > @v_daily_last_yyyymmdd------------다음달 1일 부터 364일 후 까지...
			;

			SELECT @v_tbl_cnt = COUNT(*) 
					FROM (SELECT DISTINCT C_YEAR, C_MONTH 
							FROM @v_tbl_month 
							WHERE YYYYMMDD <=  @v_create_to_yyyymmdd2) X;

			SELECT TOP 1 @v_curr_year = C_YEAR, @v_curr_month = C_MONTH 
			FROM @v_tbl_month  
			WHERE YYYYMMDD <=  @v_create_to_yyyymmdd2;

			WHILE (@v_lp < 12)------@v_tbl_cnt
			BEGIN
				SET @v_month_tmp = '';

				SELECT @v_month_tmp = @v_month_tmp + 'QTY' + RIGHT('00' + CONVERT(VARCHAR, DAY_NUM), 3) + '+' 
					FROM @v_tbl_month 
					WHERE C_YEAR  = @v_curr_year
					AND C_MONTH = @v_curr_month AND YYYYMMDD <=  @v_create_to_yyyymmdd
				;
				IF (LEN(@v_month_tmp) > 1)
				BEGIN
					--SELECT @v_month_tmp;
					SET @v_month_cols = @v_month_cols + '(' + SUBSTRING(@v_month_tmp, 1, LEN(@v_month_tmp) - 1) + ') AS MQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_curr_month), 2) + ',';

					SET @v_month_cols_O = @v_month_cols_O + 'AA.MQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_curr_month), 2) + ',';
			--		PRINT @v_month_cols---------------------------------------------------------------------------DHJ
					SET @v_curr_month = @v_curr_month + 1;

					IF (@v_curr_month = 13)
					BEGIN
						SET @v_curr_month = 1;
						SET @v_curr_year = @v_curr_year + 1;
					END
				END

				SET @v_lp = @v_lp + 1;
			END;
			--select @v_month_cols;

			SET @v_lp = 0;
			SET @v_curr_month = @v_curr_month - 1;

			IF (@v_curr_month = 0)
			BEGIN
				SET @v_curr_month = 12;
				SET @v_curr_year = @v_curr_year - 1;
			END


			WHILE (@v_lp < 13)------@v_tbl_cnt  12
			BEGIN
				SET @v_month_tmp = '';

				SELECT @v_month_tmp = @v_month_tmp + 'QTY' + RIGHT('00' + CONVERT(VARCHAR, DAY_NUM - 364), 3) + '+' 
				FROM @v_tbl_month 
				WHERE C_YEAR  = @v_curr_year
				AND C_MONTH = @v_curr_month and  YYYYMMDD <=  @v_create_to_yyyymmdd2 
				AND @v_create_from_yyyymmd2 <= YYYYMMDD;
				
				IF (LEN(@v_month_tmp) > 1)
				BEGIN

					SET @v_month_cols_2 = @v_month_cols_2 + '(' + SUBSTRING(@v_month_tmp, 1, LEN(@v_month_tmp) - 1) + ') AS MQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_curr_month), 2) + ',';
					SET @v_month_cols_N = @v_month_cols_N + 'BB.MQTY' + RIGHT('0' + CONVERT(VARCHAR, @v_curr_month), 2) + ',';
				END
		
				SET @v_curr_month = @v_curr_month + 1;
				IF (@v_curr_month = 13)
				BEGIN
					SET @v_curr_month = 1;
					SET @v_curr_year = @v_curr_year + 1;
				END
				SET @v_lp = @v_lp + 1;
			END;

			IF (SELECT SUBSTRING(@v_month_cols_2, LEN(@v_month_cols_2) - 6, 4)) = (SELECT SUBSTRING('MQTY', 0, 5))
			BEGIN
				SET @v_month_cols_2 = stuff(@v_month_cols_2, len(@v_month_cols_2) - 4, 4, 'MMQTY')
			END

			IF ((SELECT SUBSTRING(@v_month_cols_O, LEN(@v_month_cols_O) - 2, LEN(@v_month_cols_O) - 2)) = (SELECT SUBSTRING(@v_month_cols_N, 8, 3)))
			BEGIN
				SET @v_New_month_cols = (SELECT SUBSTRING(@v_month_cols_O, 0, LEN(@v_month_cols_O))) +'+'+@v_month_cols_N;
			END
			ELSE 
			BEGIN
				SET @v_New_month_cols = (SELECT SUBSTRING(@v_month_cols_O, 0, LEN(@v_month_cols_O))) +','+@v_month_cols_N;
			END

			BEGIN
				SET @v_New_month_cols = stuff(@v_New_month_cols, len(@v_New_month_cols) - 6, 6, 'MQMMQTY')
			END

			SET @SQL = '';
			SET @SQL = @SQL + 'SELECT AA.DIVISION_ID 
					, AA.PLAN_START_YYYYMMDD 		       ,AA.PLAN_TYPE 
					,AA.SEQ 		       ,AA. OPERATION_GROUP 
					,AA.OPERATION_GROUP_NAME 		       ,AA. CELL_ITEM_ID 
					,AA. ITEM_ID 		       ,AA.CHILD_ITEM_ID 
					,AA. NICK_NAME 		       ,AA.CELL_QTY_PACK 
					,AA.TO_SITE 		       ,AA.TO_SITE_DESCRIPTION 
					,AA.PROJECT_CODE 		       ,AA.FROM_BOH_QTY 
					,AA.TO_BOH_QTY 		       ,AA.INCOTERMS 
					,AA.FROM_SITE 		       ,AA.FROM_SITE_DESCRIPTION 
					,AA.TRANSPORT_MODE 		       ,AA.LT_DAY          
					,AA.PROD_LINE      		       ,AA.YIELD                                         
					,AA. END_CUSTOMER                            		       ,AA.BOD_ID                                         
					,AA.MEASURE                                  		       ,AA.MEASURE_LABEL                                         
					,AA.XLS_KEY1                                 		       ,AA.XLS_KEY2                                         
					,AA.XLS_KEY3                                 		       ,AA.XLS_KEY4                                         
					,AA.XLS_KEY5                                 		       ,AA.XLS_ATTRIBUTE1                                         
					,AA.XLS_ATTRIBUTE2                           		       ,AA.XLS_ATTRIBUTE3                                         
					,AA.XLS_ATTRIBUTE4                           		       ,AA.XLS_ATTRIBUTE5                                         
					,AA.CALC_YN                                  		       ,AA.DISPLAY_YN                                         
					, AA.SORT_ORDER_NO					
					,AA.LAST_QTY ';
			SET @SQL = @SQL + '    ,   ' + @v_day_cols_O;			   
			SET @SQL = @SQL + '       ' + @v_day_cols_N;---------------------------------------

			SET @SQL = @SQL + '       ' + @v_New_month_cols;

			SET @SQL = @SQL + '       AA.CREATED_BY';                                        
			SET @SQL = @SQL + '      ,AA.CREATION_DATE';                                        ----------------DHJ
			SET @SQL = @SQL + '      ,AA.LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,AA.LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,AA.ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,AA.ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,AA.ATTRIBUTE3';
			SET @SQL = @SQL + '      ,AA.ATTRIBUTE9';
			SET @SQL = @SQL + '      ,AA.flow_id';
			SET @SQL = @SQL + '	FROM (';
--			END
			SET @SQL = @SQL + ' SELECT XX.DIVISION_ID';
			SET @SQL = @SQL + '      ,XX.PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '      ,PLAN_TYPE';
			SET @SQL = @SQL + '      ,SEQ';
			SET @SQL = @SQL + '      ,XX.OPERATION_GROUP';
			SET @SQL = @SQL + '      ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '      ,XX.CELL_ITEM_ID';
			SET @SQL = @SQL + '      ,XX.ITEM_ID';
			SET @SQL = @SQL + '      ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '      ,XX.NICK_NAME';
			SET @SQL = @SQL + '      ,CELL_QTY_PACK';
			SET @SQL = @SQL + '      ,TO_SITE';
			SET @SQL = @SQL + '      ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,PROJECT_CODE';
			SET @SQL = @SQL + '      ,FROM_BOH_QTY';
			SET @SQL = @SQL + '      ,TO_BOH_QTY';
			SET @SQL = @SQL + '      ,INCOTERMS';
			SET @SQL = @SQL + '      ,FROM_SITE';
			SET @SQL = @SQL + '      ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,TRANSPORT_MODE';
			SET @SQL = @SQL + '      ,LT_DAY';         
			SET @SQL = @SQL + '      ,PROD_LINE';                                        
			SET @SQL = @SQL + '      ,YIELD';                                        
			SET @SQL = @SQL + '      ,XX.END_CUSTOMER';                                        
			SET @SQL = @SQL + '      ,BOD_ID';                                        
			SET @SQL = @SQL + '      ,MEASURE';                                        
			SET @SQL = @SQL + '      ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '      ,XLS_KEY1';                                        
			SET @SQL = @SQL + '      ,XLS_KEY2';                                        
			SET @SQL = @SQL + '      ,XLS_KEY3';                                        
			SET @SQL = @SQL + '      ,XLS_KEY4';                                        
			SET @SQL = @SQL + '      ,XLS_KEY5';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '      ,CALC_YN';                                        
			SET @SQL = @SQL + '      ,DISPLAY_YN';                                        
			SET @SQL = @SQL + '      ,SORT_ORDER_NO';        
			SET @SQL = @SQL + '      ,LAST_QTY';
			SET @SQL = @SQL + '      ,' + @v_day_cols;
			SET @SQL = @SQL + '       ' + @v_month_cols;
                                                                             
			SET @SQL = @SQL + '       XX.CREATED_BY';                                        
			SET @SQL = @SQL + '      ,XX.CREATION_DATE';                                        
			SET @SQL = @SQL + '      ,XX.LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,XX.LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE3';
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE9';
			SET @SQL = @SQL + '      ,SX.flow_id';
			SET @SQL = @SQL + '  FROM (';
			SET @SQL = @SQL + 'SELECT DIVISION_ID';
			SET @SQL = @SQL + '      ,PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '      ,PLAN_TYPE';
			SET @SQL = @SQL + '      ,SEQ';
			SET @SQL = @SQL + '      ,OPERATION_GROUP';
			SET @SQL = @SQL + '      ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '      ,CELL_ITEM_ID';
			SET @SQL = @SQL + '      ,ITEM_ID';
			SET @SQL = @SQL + '      ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '      ,NICK_NAME';
			SET @SQL = @SQL + '      ,CELL_QTY_PACK';
			SET @SQL = @SQL + '      ,TO_SITE';
			SET @SQL = @SQL + '      ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,PROJECT_CODE';
			SET @SQL = @SQL + '      ,FROM_BOH_QTY';
			SET @SQL = @SQL + '      ,TO_BOH_QTY';
			SET @SQL = @SQL + '      ,INCOTERMS';
			SET @SQL = @SQL + '      ,FROM_SITE';
			SET @SQL = @SQL + '      ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,TRANSPORT_MODE';
			SET @SQL = @SQL + '      ,LT_DAY';         
			SET @SQL = @SQL + '      ,PROD_LINE';                                        
			SET @SQL = @SQL + '      ,YIELD';                                        
			SET @SQL = @SQL + '      ,END_CUSTOMER';                                        
			SET @SQL = @SQL + '      ,BOD_ID';                                        
			SET @SQL = @SQL + '      ,MEASURE';                                        
			SET @SQL = @SQL + '      ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '      ,XLS_KEY1';                                        
			SET @SQL = @SQL + '      ,XLS_KEY2';                                        
			SET @SQL = @SQL + '      ,XLS_KEY3';                                        
			SET @SQL = @SQL + '      ,XLS_KEY4';                                        
			SET @SQL = @SQL + '      ,XLS_KEY5';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '      ,CALC_YN';                                        
			SET @SQL = @SQL + '      ,DISPLAY_YN';                                        
			SET @SQL = @SQL + '      ,SORT_ORDER_NO';        
			SET @SQL = @SQL + '      ,LAST_QTY';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
		
			SET @SQL = @SQL + '      ,' + @v_day_cols;
			SET @SQL = @SQL + '       ' + @v_month_cols;
                                                                             
			SET @SQL = @SQL + '       CREATED_BY';                                        
			SET @SQL = @SQL + '      ,CREATION_DATE';                                        
			SET @SQL = @SQL + '      ,LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE3';
			SET @SQL = @SQL + '      ,ATTRIBUTE9';
			SET @SQL = @SQL + '              ,(CASE WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9  = ''P5000'' THEN 2100';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9 <> ''P5000'' AND (SELECT TOP 1 FLOW_ID';
			SET @SQL = @SQL + '              				                                                        FROM SCM_MST_ITEM_SN M WITH (NOLOCK)';
			SET @SQL = @SQL + '              				                                                       WHERE M.DIVISION_ID = X.DIVISION_ID';
			SET @SQL = @SQL + '              				                                                         AND M.ITEM_ID     = (SELECT TOP 1 CHILD_ITEM_ID';
			SET @SQL = @SQL + '              								   	                                                            FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK)';
			SET @SQL = @SQL + '              									                                                           WHERE A.DIVISION_ID = X.DIVISION_ID';
			SET @SQL = @SQL + '              									                                                             AND A.MODEL_ID    = X.ITEM_ID)) = ''P5000'' THEN 2000 ';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9 <> ''P5000'' THEN 1000';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''A'' AND ATTRIBUTE9  = ''P5000'' THEN 3000';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''A'' AND ATTRIBUTE9 <> ''P5000'' THEN 4000 ELSE 5000 END) AS ORDNO';
			SET @SQL = @SQL + '  FROM (';
			SET @SQL = @SQL + '        SELECT DIVISION_ID';
			SET @SQL = @SQL + '              ,PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '              ,PLAN_TYPE';
			SET @SQL = @SQL + '              ,SEQ';
			SET @SQL = @SQL + '              ,OPERATION_GROUP';
			SET @SQL = @SQL + '              ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '              ,CELL_ITEM_ID';
			SET @SQL = @SQL + '              ,ITEM_ID';
			SET @SQL = @SQL + '              ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '              ,NICK_NAME';
			SET @SQL = @SQL + '              ,CELL_QTY_PACK';
			SET @SQL = @SQL + '              ,TO_SITE';
			SET @SQL = @SQL + '              ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '              ,PROJECT_CODE';
			SET @SQL = @SQL + '              ,FROM_BOH_QTY';
			SET @SQL = @SQL + '              ,TO_BOH_QTY';
			SET @SQL = @SQL + '              ,INCOTERMS';
			SET @SQL = @SQL + '              ,FROM_SITE';
			SET @SQL = @SQL + '              ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '              ,TRANSPORT_MODE';
			SET @SQL = @SQL + '              ,LT_DAY';         
			SET @SQL = @SQL + '              ,PROD_LINE';                                        
			SET @SQL = @SQL + '              ,YIELD';                                        
			SET @SQL = @SQL + '              ,END_CUSTOMER';                                        
			SET @SQL = @SQL + '              ,BOD_ID';                                        
			--SET @SQL = @SQL + '              ,(CASE WHEN MEASURE       = ''OLD_CELL_SHIP_PLAN'' THEN ''CELL_SHIP_PLAN'' ELSE MEASURE END)       AS MEASURE';                                        
			--SET @SQL = @SQL + '              ,(CASE WHEN MEASURE_LABEL = ''Old Ship Plan(SCP)'' THEN ''Ship Plan(SCP)'' ELSE MEASURE_LABEL END) AS MEASURE_LABEL';                                        
			--SET @SQL = @SQL + '              ,(CASE WHEN MEASURE       = ''OLD_CELL_SHIP_PLAN'' THEN XLS_KEY1 / 100 ELSE XLS_KEY1 END) AS XLS_KEY1';      
			SET @SQL = @SQL + '              ,MEASURE';                                        
			SET @SQL = @SQL + '              ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '              ,XLS_KEY1';		
			SET @SQL = @SQL + '              ,XLS_KEY2';                                        
			SET @SQL = @SQL + '              ,XLS_KEY3';                                        
			SET @SQL = @SQL + '              ,XLS_KEY4';                                        
			SET @SQL = @SQL + '              ,XLS_KEY5';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '              ,'''' AS CALC_YN';                                        
			SET @SQL = @SQL + '              ,'''' AS DISPLAY_YN';                                        
			SET @SQL = @SQL + '              ,SORT_ORDER_NO'; 
			SET @SQL = @SQL + '              ,LAST_QTY';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
		                           
			SET @SQL = @SQL + '              ,' + @v_day_cols;
			SET @SQL = @SQL + '               ' + @v_month_cols;
                                                                                     
			SET @SQL = @SQL + '               CREATED_BY';                                        
			SET @SQL = @SQL + '              ,CREATION_DATE';                                        
			SET @SQL = @SQL + '              ,LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '              ,LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '              ,ATTRIBUTE1';                                        
			SET @SQL = @SQL + '              ,ATTRIBUTE10';                                        
			SET @SQL = @SQL + '              ,REPLACE(ATTRIBUTE3, '','', ''|'') AS ATTRIBUTE3';			--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			SET @SQL = @SQL + '              ,(CASE WHEN MEASURE IN (''PREV_PACK_PROD'', ''PREV_PACK_SHIP_PLAN'') AND ATTRIBUTE9 IS NULL THEN (SELECT TOP 1 A.ATTRIBUTE9';
			SET @SQL = @SQL + '																													 FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK A WITH (NOLOCK)';
			SET @SQL = @SQL + '																													WHERE A.PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.CREATE_FROM_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.PLAN_TYPE           = ''' + @v_plan_type + '''';
			SET @SQL = @SQL + '																													  AND A.SEQ                 = ''' + @v_seq + '''';
			SET @SQL = @SQL + '																													  AND A.CELL_ITEM_ID		= X.CELL_ITEM_ID';
			SET @SQL = @SQL + '																													  AND A.ITEM_ID				= X.ITEM_ID';
			SET @SQL = @SQL + '																													  AND A.FROM_SITE			= X.FROM_SITE';
			SET @SQL = @SQL + '																													  AND A.TO_SITE				= X.TO_SITE';
			SET @SQL = @SQL + '																													  AND A.MEASURE				IN (''PACK_PROD'', ''PACK_SHIP_PLAN'')';
			SET @SQL = @SQL + '                                                                                                               )';
			SET @SQL = @SQL + '                     ELSE ATTRIBUTE9 END) AS ATTRIBUTE9';
			SET @SQL = @SQL + '          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)';                    
			SET @SQL = @SQL + '         WHERE 0 = 0';                                         
			SET @SQL = @SQL + '            AND DIVISION_ID         = ''' + @p_division_id + '''';       
			SET @SQL = @SQL + '            AND PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND CREATE_FROM_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND PLAN_TYPE           = ''' + @v_plan_type + '''';
			SET @SQL = @SQL + '            AND SEQ                 = ''' + @v_seq + '''';
			SET @SQL = @SQL + '            AND CELL_ITEM_ID IN (SELECT Token from String_Split(''' + @p_parameter3 + ''','',''))';
			SET @SQL = @SQL + '            AND NOT MEASURE = ''OLD_CELL_SHIP_PLAN''';
			SET @SQL = @SQL + '       ) X ';
			SET @SQL = @SQL + '       ) XX ';
			--2023.03.09   KKH			 소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
			SET @SQL = @SQL + '   LEFT JOIN   ';
			SET @SQL = @SQL + '   (   ';
			SET @SQL = @SQL + '   SELECT A.DIVISION_ID, A.ITEM_ID, B.FLOW_ID    ';
			SET @SQL = @SQL + '   FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V A WITH(NOLOCK)   ';
			SET @SQL = @SQL + '   , SCP_MST_FINAL_ITEM B WITH(NOLOCK)   ';
			SET @SQL = @SQL + '   WHERE 1=1   ';
			SET @SQL = @SQL + '   AND A.DIVISION_ID = B.DIVISION_ID   ';
			SET @SQL = @SQL + '   AND A.ITEM_ID = B.ITEM_ID   ';
			SET @SQL = @SQL + '   AND A.IS_YN = ''Y''   ';
			SET @SQL = @SQL + '   ) SX   ';
			SET @SQL = @SQL + '   ON SX.DIVISION_ID = XX.DIVISION_ID  ';
			SET @SQL = @SQL + '   AND SX.ITEM_ID = XX.ITEM_ID   ';
			-------------------------------------------------------------------------------------
			SET @SQL = @SQL + '   ) AA   ';
			SET @SQL = @SQL + '  LEFT OUTER JOIN ';
			SET @SQL = @SQL + '   (  ';
			SET @SQL = @SQL + 'SELECT XX.DIVISION_ID';
			SET @SQL = @SQL + '      ,XX.PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '      ,PLAN_TYPE';
			SET @SQL = @SQL + '      ,SEQ';
			SET @SQL = @SQL + '      ,XX.OPERATION_GROUP';
			SET @SQL = @SQL + '      ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '      ,XX.CELL_ITEM_ID';
			SET @SQL = @SQL + '      ,XX.ITEM_ID';
			SET @SQL = @SQL + '      ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '      ,XX.NICK_NAME';
			SET @SQL = @SQL + '      ,CELL_QTY_PACK';
			SET @SQL = @SQL + '      ,TO_SITE';
			SET @SQL = @SQL + '      ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,PROJECT_CODE';
			SET @SQL = @SQL + '      ,FROM_BOH_QTY';
			SET @SQL = @SQL + '      ,TO_BOH_QTY';
			SET @SQL = @SQL + '      ,INCOTERMS';
			SET @SQL = @SQL + '      ,FROM_SITE';
			SET @SQL = @SQL + '      ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,TRANSPORT_MODE';
			SET @SQL = @SQL + '      ,LT_DAY';         
			SET @SQL = @SQL + '      ,PROD_LINE';                                        
			SET @SQL = @SQL + '      ,YIELD';                                        
			SET @SQL = @SQL + '      ,XX.END_CUSTOMER';                                        
			SET @SQL = @SQL + '      ,BOD_ID';                                        
			SET @SQL = @SQL + '      ,MEASURE';                                        
			SET @SQL = @SQL + '      ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '      ,XLS_KEY1';                                        
			SET @SQL = @SQL + '      ,XLS_KEY2';                                        
			SET @SQL = @SQL + '      ,XLS_KEY3';                                        
			SET @SQL = @SQL + '      ,XLS_KEY4';                                        
			SET @SQL = @SQL + '      ,XLS_KEY5';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '      ,CALC_YN';                                        
			SET @SQL = @SQL + '      ,DISPLAY_YN';                                        
			SET @SQL = @SQL + '      ,SORT_ORDER_NO';        
			SET @SQL = @SQL + '      ,LAST_QTY';
			SET @SQL = @SQL + '      ,' + @v_day_cols;
			SET @SQL = @SQL + '       ' + @v_month_cols_2;
                                                                             
			SET @SQL = @SQL + '       XX.CREATED_BY';                                        
			SET @SQL = @SQL + '      ,XX.CREATION_DATE';                                        
			SET @SQL = @SQL + '      ,XX.LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,XX.LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE3';
			SET @SQL = @SQL + '      ,XX.ATTRIBUTE9';
			SET @SQL = @SQL + '      ,SX.flow_id';
			SET @SQL = @SQL + '  FROM (';
			SET @SQL = @SQL + 'SELECT DIVISION_ID';
			SET @SQL = @SQL + '      ,PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '      ,PLAN_TYPE';
			SET @SQL = @SQL + '      ,SEQ';
			SET @SQL = @SQL + '      ,OPERATION_GROUP';
			SET @SQL = @SQL + '      ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '      ,CELL_ITEM_ID';
			SET @SQL = @SQL + '      ,ITEM_ID';
			SET @SQL = @SQL + '      ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '      ,NICK_NAME';
			SET @SQL = @SQL + '      ,CELL_QTY_PACK';
			SET @SQL = @SQL + '      ,TO_SITE';
			SET @SQL = @SQL + '      ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,PROJECT_CODE';
			SET @SQL = @SQL + '      ,FROM_BOH_QTY';
			SET @SQL = @SQL + '      ,TO_BOH_QTY';
			SET @SQL = @SQL + '      ,INCOTERMS';
			SET @SQL = @SQL + '      ,FROM_SITE';
			SET @SQL = @SQL + '      ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '      ,TRANSPORT_MODE';
			SET @SQL = @SQL + '      ,LT_DAY';         
			SET @SQL = @SQL + '      ,PROD_LINE';                                        
			SET @SQL = @SQL + '      ,YIELD';                                        
			SET @SQL = @SQL + '      ,END_CUSTOMER';                                        
			SET @SQL = @SQL + '      ,BOD_ID';                                        
			SET @SQL = @SQL + '      ,MEASURE';                                        
			SET @SQL = @SQL + '      ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '      ,XLS_KEY1';                                        
			SET @SQL = @SQL + '      ,XLS_KEY2';                                        
			SET @SQL = @SQL + '      ,XLS_KEY3';                                        
			SET @SQL = @SQL + '      ,XLS_KEY4';                                        
			SET @SQL = @SQL + '      ,XLS_KEY5';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '      ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '      ,CALC_YN';                                        
			SET @SQL = @SQL + '      ,DISPLAY_YN';                                        
			SET @SQL = @SQL + '      ,SORT_ORDER_NO';        
			SET @SQL = @SQL + '      ,LAST_QTY';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
		
			SET @SQL = @SQL + '      ,' + @v_day_cols;
			SET @SQL = @SQL + '       ' + @v_month_cols_2;
                                                                             
			SET @SQL = @SQL + '       CREATED_BY';                                        
			SET @SQL = @SQL + '      ,CREATION_DATE';                                        
			SET @SQL = @SQL + '      ,LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '      ,LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE1';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE10';                                        
			SET @SQL = @SQL + '      ,ATTRIBUTE3';
			SET @SQL = @SQL + '      ,ATTRIBUTE9';
			SET @SQL = @SQL + '              ,(CASE WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9  = ''P5000'' THEN 2100';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9 <> ''P5000'' AND (SELECT TOP 1 FLOW_ID';
			SET @SQL = @SQL + '              				                                                        FROM SCM_MST_ITEM_SN M WITH (NOLOCK)';
			SET @SQL = @SQL + '              				                                                       WHERE M.DIVISION_ID = X.DIVISION_ID';
			SET @SQL = @SQL + '              				                                                         AND M.ITEM_ID     = (SELECT TOP 1 CHILD_ITEM_ID';
			SET @SQL = @SQL + '              								   	                                                            FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A WITH (NOLOCK)';
			SET @SQL = @SQL + '              									                                                           WHERE A.DIVISION_ID = X.DIVISION_ID';
			SET @SQL = @SQL + '              									                                                             AND A.MODEL_ID    = X.ITEM_ID)) = ''P5000'' THEN 2000 ';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''P'' AND ATTRIBUTE9 <> ''P5000'' THEN 1000';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''A'' AND ATTRIBUTE9  = ''P5000'' THEN 3000';
			SET @SQL = @SQL + '                     WHEN OPERATION_GROUP = ''A'' AND ATTRIBUTE9 <> ''P5000'' THEN 4000 ELSE 5000 END) AS ORDNO';
			SET @SQL = @SQL + '  FROM (';
			SET @SQL = @SQL + '        SELECT DIVISION_ID';
			SET @SQL = @SQL + '              ,PLAN_START_YYYYMMDD';
			SET @SQL = @SQL + '              ,PLAN_TYPE';
			SET @SQL = @SQL + '              ,SEQ';
			SET @SQL = @SQL + '              ,OPERATION_GROUP';
			SET @SQL = @SQL + '              ,OPERATION_GROUP_NAME';
			SET @SQL = @SQL + '              ,CELL_ITEM_ID';
			SET @SQL = @SQL + '              ,ITEM_ID';
			SET @SQL = @SQL + '              ,CHILD_ITEM_ID';
			SET @SQL = @SQL + '              ,NICK_NAME';
			SET @SQL = @SQL + '              ,CELL_QTY_PACK';
			SET @SQL = @SQL + '              ,TO_SITE';
			SET @SQL = @SQL + '              ,TO_SITE_DESCRIPTION';
			SET @SQL = @SQL + '              ,PROJECT_CODE';
			SET @SQL = @SQL + '              ,FROM_BOH_QTY';
			SET @SQL = @SQL + '              ,TO_BOH_QTY';
			SET @SQL = @SQL + '              ,INCOTERMS';
			SET @SQL = @SQL + '              ,FROM_SITE';
			SET @SQL = @SQL + '              ,FROM_SITE_DESCRIPTION';
			SET @SQL = @SQL + '              ,TRANSPORT_MODE';
			SET @SQL = @SQL + '              ,LT_DAY';         
			SET @SQL = @SQL + '              ,PROD_LINE';                                        
			SET @SQL = @SQL + '              ,YIELD';                                        
			SET @SQL = @SQL + '              ,END_CUSTOMER';                                        
			SET @SQL = @SQL + '              ,BOD_ID';                                        
			SET @SQL = @SQL + '              ,MEASURE';                                        
			SET @SQL = @SQL + '              ,MEASURE_LABEL';                                        
			SET @SQL = @SQL + '              ,XLS_KEY1';		
			SET @SQL = @SQL + '              ,XLS_KEY2';                                        
			SET @SQL = @SQL + '              ,XLS_KEY3';                                        
			SET @SQL = @SQL + '              ,XLS_KEY4';                                        
			SET @SQL = @SQL + '              ,XLS_KEY5';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE1';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE2';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE3';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE4';                                        
			SET @SQL = @SQL + '              ,XLS_ATTRIBUTE5';                                        
			SET @SQL = @SQL + '              ,'''' AS CALC_YN';                                        
			SET @SQL = @SQL + '              ,'''' AS DISPLAY_YN';                                        
			SET @SQL = @SQL + '              , CASE MEASURE WHEN ''SHIP_REQ'' THEN 30 WHEN ''WHIN_TOTAL'' THEN 20 ELSE  SORT_ORDER_NO END AS SORT_ORDER_NO  '  ; 
			SET @SQL = @SQL + '              ,LAST_QTY';			-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
		                           
			SET @SQL = @SQL + '              ,' + @v_day_cols;
			SET @SQL = @SQL + '               ' + @v_month_cols_2;
                                                                                     
			SET @SQL = @SQL + '               CREATED_BY';                                        
			SET @SQL = @SQL + '              ,CREATION_DATE';                                        
			SET @SQL = @SQL + '              ,LAST_UPDATED_BY';                                        
			SET @SQL = @SQL + '              ,LAST_UPDATE_DATE';                                        
			SET @SQL = @SQL + '              ,ATTRIBUTE1';                                        
			SET @SQL = @SQL + '              ,ATTRIBUTE10';                                        
			SET @SQL = @SQL + '              ,REPLACE(ATTRIBUTE3, '','', ''|'') AS ATTRIBUTE3';			--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			SET @SQL = @SQL + '              ,(CASE WHEN MEASURE IN (''PREV_PACK_PROD'', ''PREV_PACK_SHIP_PLAN'') AND ATTRIBUTE9 IS NULL THEN (SELECT TOP 1 A.ATTRIBUTE9';
			SET @SQL = @SQL + '																													 FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK A WITH (NOLOCK)';
			SET @SQL = @SQL + '																													WHERE A.PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.CREATE_FROM_YYYYMMDD = ''' + @v_create_from_yyyymmd2 + '''';
			SET @SQL = @SQL + '																													  AND A.PLAN_TYPE           = ''' + @v_plan_type + '''';
			SET @SQL = @SQL + '																													  AND A.SEQ                 = ''' + @v_seq + '''';
			SET @SQL = @SQL + '																													  AND A.CELL_ITEM_ID		= X.CELL_ITEM_ID';
			SET @SQL = @SQL + '																													  AND A.ITEM_ID				= X.ITEM_ID';
			SET @SQL = @SQL + '																													  AND A.FROM_SITE			= X.FROM_SITE';
			SET @SQL = @SQL + '																													  AND A.TO_SITE				= X.TO_SITE';
			SET @SQL = @SQL + '																													  AND A.MEASURE				IN (''PACK_PROD'', ''PACK_SHIP_PLAN'')';
			SET @SQL = @SQL + '                                                                                                               )';
			SET @SQL = @SQL + '                     ELSE ATTRIBUTE9 END) AS ATTRIBUTE9';
			SET @SQL = @SQL + '          FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK X WITH (NOLOCK)';                    
			SET @SQL = @SQL + '         WHERE 0 = 0';                                         
			SET @SQL = @SQL + '            AND DIVISION_ID         = ''' + @p_division_id + '''';       
			SET @SQL = @SQL + '            AND PLAN_START_YYYYMMDD = ''' + @v_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND CREATE_FROM_YYYYMMDD = ''' + @v_create_from_yyyymmd2 + '''';
			SET @SQL = @SQL + '            AND PLAN_TYPE           = ''' + @v_plan_type + '''';
			SET @SQL = @SQL + '            AND SEQ                 = ''' + @v_seq + '''';
			SET @SQL = @SQL + '            AND CELL_ITEM_ID IN (SELECT Token from String_Split(''' + @p_parameter3 + ''','',''))';
			SET @SQL = @SQL + '            AND NOT MEASURE = ''OLD_CELL_SHIP_PLAN''';
			SET @SQL = @SQL + '       ) X ';
			SET @SQL = @SQL + '       ) XX ';
			--2023.03.09   KKH			 소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
			SET @SQL = @SQL + '   LEFT JOIN   ';
			SET @SQL = @SQL + '   (   ';
			SET @SQL = @SQL + '   SELECT A.DIVISION_ID, A.ITEM_ID, B.FLOW_ID   ';
			SET @SQL = @SQL + '   FROM SCM_MST_FINAL_ITEM_ORIGIN_DIV_V A WITH(NOLOCK)   ';
			SET @SQL = @SQL + '   , SCP_MST_FINAL_ITEM B WITH(NOLOCK)   ';
			SET @SQL = @SQL + '   WHERE 1=1   ';
			SET @SQL = @SQL + '   AND A.DIVISION_ID = B.DIVISION_ID   ';
			SET @SQL = @SQL + '   AND A.ITEM_ID = B.ITEM_ID   ';
			SET @SQL = @SQL + '   AND A.IS_YN = ''Y''   ';
			SET @SQL = @SQL + '   ) SX   ';
			SET @SQL = @SQL + '   ON SX.DIVISION_ID = XX.DIVISION_ID  ';
			SET @SQL = @SQL + '   AND SX.ITEM_ID = XX.ITEM_ID   ';
			SET @SQL = @SQL + '   ) BB   ';

			SET @SQL = @SQL + '   on AA.DIVISION_ID  = BB.DIVISION_ID   ';
			SET @SQL = @SQL + '   AND AA.PLAN_START_YYYYMMDD = BB.PLAN_START_YYYYMMDD    ';
			SET @SQL = @SQL + '   AND AA.PLAN_TYPE =  BB.PLAN_TYPE   ';
			SET @SQL = @SQL + '   AND AA.SEQ =  BB.SEQ			   ';
			SET @SQL = @SQL + '   AND AA.OPERATION_GROUP = BB.OPERATION_GROUP   ';
			SET @SQL = @SQL + '   AND AA.ITEM_ID = BB.ITEM_ID    ';
			SET @SQL = @SQL + '   AND AA.CELL_ITEM_ID = BB.CELL_ITEM_ID    ';
			SET @SQL = @SQL + '   AND AA.TO_SITE = BB.TO_SITE   ';
			SET @SQL = @SQL + '   AND AA.FROM_SITE = BB.FROM_SITE   ';
			SET @SQL = @SQL + '   AND AA.MEASURE = BB.MEASURE   ';
			SET @SQL = @SQL + '   AND AA.XLS_KEY1 = BB.XLS_KEY1   ';						

			SET @SQL = @SQL + 'ORDER BY AA.CELL_ITEM_ID, AA.OPERATION_GROUP DESC, /*AA.ORDNO,*/ AA.ITEM_ID
											, CASE WHEN AA.TO_SITE = ''-'' THEN ''ZZZ'' ELSE AA.TO_SITE END 
											, (CASE WHEN (AA.FROM_SITE = ''-''  AND AA.MEASURE LIKE ''CELL%'' ) THEN ''-'' ELSE AA.FROM_SITE END)
											, AA.PROJECT_CODE
											, AA.INCOTERMS
											, AA.SORT_ORDER_NO';
--			END
		END

		EXEC(@SQL);


END
