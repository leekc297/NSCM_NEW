






/*
 * Program ID   : PR_SCP_XLS_EXCEL_TITLE_QUERY
 * Description  : SCP SIMULATION EXCEL SHEET TITLE QUERY
 * OutTable     :  
 * Execute      :  
                  EXEC PR_SCP_XLS_EXCEL_TITLE_QUERY  
                                                     @P_DIVISION_ID   = '81'
                                                    ,@P_PGM_CODE      = 'XLSPSI01'
                                                    ,@P_PARAMETER1    = '20260112' -- PLAN_DATE
                                                    ,@P_PARAMETER2    =''
                                                    ,@P_PARAMETER3    =''
                                                    ,@P_PARAMETER4    =''
                                                    ,@P_PARAMETER5    =''  
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.01.07   YYDOK         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *              KSG           과거 이력 정리
 * 2022.02.21   KSW			  DC link 적용
 * 2022.05.02   KSW           소형 PACK 시뮬레이터 :: Daily & Monthly Bucket 개선적용
 * 2022.06.22   KSW			  소형 Shipment plan 시뮬레이터 From Site 컬럼추가
 * 2022.07.18   KSW			  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
 * 2022.08.11   KSW			  중장기 +1 Year 변경처리
 * 2022.09.21	KSW			  소형SCM개선요청사항 적용
 * 2023.03.09   KKH			 소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
 * 2023.08.04   KSK			 PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase.2 (사업계획 수립에 따른 시뮬레이터 생산계획Bucket 확장 적용)
 * 2023.10.06   KHJ			확정구간의 기준을 LOOKUP 테이블을 우선참조하도록 함
 * 2023.12.01   KHJ			소형출하계획 (XLSPSI21). FROM_SITE별 출하계획 조회/할당/저장
 * 2024.04.08   KSK			XLSPSI21의    플랜타입을 @P_Plan_Type로 간소화
 * 2024.08.22   KSK			DAILY PSI 실시간 생산계획 일분배관련 참조필드인 ATTRBUTE9 필드 추가조회
 * 2024.11.1  	KSK          최근의 플랜정보 조회시 플랜상세정보가 유효한 것을 조건으로 추가함(KSK, 2024/11/11)
 * 2025.01.16  	KSK          최근의 플랜정보 조회로직 보완(KSK, 2024/11/11)

 */

CREATE PROCEDURE [dbo].[PR_SCP_XLS_EXCEL_TITLE_QUERY](
  @p_division_id   VARCHAR(10),
  @p_pgm_code      VARCHAR(40),
  @p_parameter1    VARCHAR(MAX)  ='',   -- @p_plan_start_yyyymmdd
  @p_parameter2    VARCHAR(MAX)  ='',
  @p_parameter3    VARCHAR(MAX)  ='',
  @p_parameter4    VARCHAR(MAX)  ='',
  @p_parameter5    VARCHAR(MAX)  =''  
 )
AS

BEGIN

    DECLARE @p_plan_start_yyyymmdd VARCHAR(8) = @p_parameter1  

	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - start
	-- 소형(40), ESS(82) Shipment plan 입력 시뮬레이터를 위한 변수선언
	DECLARE @p_plan_type            NVARCHAR(4000) = 'MA';
	DECLARE @p_seq                  NVARCHAR(0008) = NULL;

	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(0008);
	DECLARE @v_plan_end_yyyymmdd    NVARCHAR(0008);
	DECLARE @v_seq                  NVARCHAR(0008)
	DECLARE @v_cols                 NVARCHAR(MAX);
	DECLARE @v_cols2                NVARCHAR(MAX);
	DECLARE @SQL                    NVARCHAR(MAX);

	DECLARE @v_frozen_end_yyyymmdd  NVARCHAR(0008);
	DECLARE @v_frozen_days          integer = 21;
	DECLARE @v_frozen_area_last_yyyymmdd NVARCHAR(0008);

	-- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 플랜 대응
	--  Plan End Date
	DECLARE @v_pet_date		NVARCHAR(12) = '';
	DECLARE @v_bp_flag		NVARCHAR(8) = '';
	DECLARE @v_YearCnt		INT = 1;
	DECLARE @v_bp_days		INT = 0;
	DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

	--단위테스트시 오류발생하여 보완(2025.01.16, KSK)
	SELECT top 1 @v_pet_date = p.horizon_end_date,
		   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
		   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	inner join scm_mst_plan_detail b with(nolock) 
		on p.division_id = b.division_id
		and p.plan_id = b.plan_id
		and b.active_flag = 'Y'
		AND B.PLAN_STATUS = '1'
where p.plan_cycle = 'WEEKLY'
and p.division_id =  @p_division_id
order by plan_name desc ,   b.creation_date  desc,   PLAN_TYPE,  plan_seq desc
	;

	--PRINT '@v_bp_flag : ' + @v_bp_flag '해제하면 레코드셋이 닫혀서 시뮬에러 날수 있다(KSK, 260130)


	SET @v_bp_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364+364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112);	-- 중장기 +1 Year 변경처리 :: 2022.08.11

	-- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - start
	DECLARE @v_2year_cnt		INT = 0;
	SET @v_plan_start_yyyymmdd = '';

	IF @p_pgm_code = 'XLSPSI01'
	BEGIN
		SELECT  DISTINCT 
	            @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
	     FROM DBO.SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
	    WHERE DIVISION_ID = @p_division_id
	  ;

		SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112);
	END

	IF @p_pgm_code = 'XLSPSI02'
	BEGIN
		SELECT  DISTINCT 
	            @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
	     FROM DBO.SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
	    WHERE DIVISION_ID = @p_division_id
	  ;

		SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112);

	END

	IF @p_pgm_code = 'XLSPSI03'
	BEGIN
		SELECT  DISTINCT 
	            @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
	     FROM DBO.SCP_XLS_PSI_GLOBAL_SMALL_CELL WITH (NOLOCK)
	    WHERE DIVISION_ID = @p_division_id
	  ;

		SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112);
	END

	IF @p_pgm_code = 'XLSPSI05'
	BEGIN
		SELECT  DISTINCT 
	            @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
	     FROM DBO.SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)
	    WHERE DIVISION_ID = @p_division_id
	  ;

		SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_ELECTRODE Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112);
	END

	IF @p_pgm_code = 'XLSPSI06'
	BEGIN
		SELECT  DISTINCT 
	            @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
	     FROM DBO.SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)
	    WHERE DIVISION_ID = @p_division_id
	  ;

		SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_ESS Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112);
	END

	IF @v_bp_flag = 'Y' AND @v_2year_cnt = 0
	BEGIN
		SET @v_bp_flag = 'N'
	END
	-- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - end


	IF @v_bp_flag = 'N'
	BEGIN
		-- 중장기 아닌 경우
		SET @v_bp_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112);
	END

	--DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = CONVERT(VARCHAR,DATEADD(D,364+210,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112);
	--DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112);
	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - end

     IF @p_parameter1 = ''
      BEGIN 
        SELECT @p_plan_start_yyyymmdd = dbo.FN_GET_BUCKET_YYYYMMDD(-1)    -- 날짜에 상관없이 첫주로 변경함.
      END


  -----------------------------------------
  -- XLSPSI01: 자동차 GLOBAL PSI SIMULATION
  -----------------------------------------

  IF @p_pgm_code = 'XLSPSI01' 
     BEGIN

     

      SELECT T,Sub
          FROM (
                          SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
                UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
                UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
                UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB  
                UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
                UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
                UNION ALL SELECT 7  AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
                UNION ALL SELECT 8  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
                UNION ALL SELECT 9  AS SEQ,'NICK'                   AS T ,'' AS SUB
                UNION ALL SELECT 10 AS SEQ,'CELL QTY'               AS T ,'' AS SUB
                UNION ALL SELECT 11 AS SEQ,'TO_SITE'                AS T ,'' AS SUB
                UNION ALL SELECT 12 AS SEQ,'TO SITE'                AS T ,'' AS SUB
                UNION ALL SELECT 13 AS SEQ,'PROJECT'                AS T ,'' AS SUB
                UNION ALL SELECT 14 AS SEQ,'FROM BOH QTY'           AS T ,'' AS SUB
                UNION ALL SELECT 15 AS SEQ,'TO BOH QTY'             AS T ,'' AS SUB
                UNION ALL SELECT 16 AS SEQ,'INCOTERMS'              AS T ,'' AS SUB
                UNION ALL SELECT 17 AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
                UNION ALL SELECT 18 AS SEQ,'FROM SITE'              AS T ,'' AS SUB
                UNION ALL SELECT 19 AS SEQ,'TRANS'                  AS T ,'' AS SUB
                UNION ALL SELECT 20 AS SEQ,'LT'                     AS T ,'' AS SUB
				UNION ALL SELECT 21 AS SEQ,'YIELD'                  AS T ,'' AS SUB
                UNION ALL SELECT 22 AS SEQ,'LINE'                   AS T ,'' AS SUB
                UNION ALL SELECT 23 AS SEQ,'BOD ID'                 AS T ,'' AS SUB                
				UNION ALL SELECT 24 AS SEQ,'GRO STD DIO'            AS T ,'' AS SUB
				UNION ALL SELECT 25 AS SEQ,'MIN STD DIO'            AS T ,'' AS SUB
                UNION ALL SELECT 26 AS SEQ,'MEASURE'                AS T ,'' AS SUB
                UNION ALL SELECT 27 AS SEQ,'MEASURE'                AS T ,'' AS SUB
                UNION ALL SELECT 28 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
                UNION ALL SELECT 29 AS SEQ,'XLS_KEY2'               AS T ,'' AS SUB
                UNION ALL SELECT 30 AS SEQ,'XLS_KEY3'               AS T ,'' AS SUB
                UNION ALL SELECT 31 AS SEQ,'XLS_KEY4'               AS T ,'' AS SUB
                UNION ALL SELECT 32 AS SEQ,'XLS_KEY5'               AS T ,'' AS SUB
                UNION ALL SELECT 33 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
                UNION ALL SELECT 34 AS SEQ,'XLS_KEY_ATTRIBUTE2'     AS T ,'' AS SUB
                UNION ALL SELECT 35 AS SEQ,'XLS_KEY_ATTRIBUTE3'     AS T ,'' AS SUB
                UNION ALL SELECT 36 AS SEQ,'XLS_KEY_ATTRIBUTE4'     AS T ,'' AS SUB
                UNION ALL SELECT 37 AS SEQ,'XLS_KEY_ATTRIBUTE5'     AS T ,'' AS SUB
                --UNION ALL SELECT 35 AS SEQ,'CALC_YN'                AS T ,'' AS SUB
                --UNION ALL SELECT 36 AS SEQ,'DISPLAY_YN'             AS T ,'' AS SUB 
                UNION ALL SELECT 38 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
                UNION ALL SELECT 39 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
                           WHERE 0 = 0
			                       AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
                             AND C.BASIS_YYYYMMDD <  @v_bp_plan_end_yyyymmdd                -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 플랜 대응      
                UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
			          UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
			          UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
			          UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
			          UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
                --UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE10'            AS T ,'' AS SUB		--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
				UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE3'             AS T ,'' AS SUB
				UNION ALL SELECT 95 AS SEQ,'ATTRIBUTE9'             AS T ,'' AS SUB -- DAILY PSI  참조필드 ATTRBUTE(KSK, 20241121)
                )   M
            ORDER BY SEQ
                    ,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
                    ,SUB  
      ;
     END

  -----------------------------------------
  -- XLSPSI02:소형 PACK PSI SIMULATION
  -----------------------------------------  

  IF @P_PGM_CODE = 'XLSPSI02' 
     BEGIN

     
		-- 2022.03.24 KSW 소형 PACK 시뮬레이터 :: Daily & Monthly Bucket 개선적용
		DECLARE @v_dayend_yyyymmdd		NVARCHAR(20) = @p_parameter5;	-- Daily 플랜 마지막일자
		DECLARE @v_day_cols				NVARCHAR(4000) = '';

		-- Dayily End 일자를 월 말일로 조정한다.
		DECLARE @v_daily_last_yyyymmdd	NVARCHAR(0008) = '';

		-- 다음일자가 1일 아니면
		SELECT @v_daily_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,31,CONVERT(DATETIME,(LEFT(@v_dayend_yyyymmdd, 6) + '01'),112)),112)
		SELECT @v_daily_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(LEFT(@v_daily_last_yyyymmdd, 6) + '01'),112)),112)

		--select @v_daily_last_yyyymmdd;
--------------------------------------------------------------------DHJ 1,2년 기준......확실히
		DECLARE @v_yearsFlag		INT = 1;

	--	SET @v_bp_flag = '';--------------------------------DHJ

	IF @v_bp_flag = 'Y'
	BEGIN
	SET @v_yearsFlag = 2;
	END

	-------------------------------------------------------------------------		
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364*@v_yearsFlag,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;
		 --PRINT  '@v_plan_end_yyyymmdd : ' + STR(@v_plan_end_yyyymmdd)


      SELECT T,Sub
          FROM (
                          SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
                UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
                UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
                UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB  
                UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
                UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
                UNION ALL SELECT 7  AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
                UNION ALL SELECT 8  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
                UNION ALL SELECT 9  AS SEQ,'CHILD ITEM ID'          AS T ,'' AS SUB
                UNION ALL SELECT 10 AS SEQ,'NICK'                   AS T ,'' AS SUB
                UNION ALL SELECT 11 AS SEQ,'CELL QTY'               AS T ,'' AS SUB
                UNION ALL SELECT 12 AS SEQ,'TO_SITE'                AS T ,'' AS SUB
                UNION ALL SELECT 13 AS SEQ,'TO SITE'                AS T ,'' AS SUB
                UNION ALL SELECT 14 AS SEQ,'PROJECT'                AS T ,'' AS SUB
                UNION ALL SELECT 15 AS SEQ,'FROM BOH QTY'           AS T ,'' AS SUB
                UNION ALL SELECT 16 AS SEQ,'TO BOH QTY'             AS T ,'' AS SUB
                UNION ALL SELECT 17 AS SEQ,'INCOTERMS'              AS T ,'' AS SUB
                UNION ALL SELECT 18 AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
                UNION ALL SELECT 19 AS SEQ,'FROM SITE'              AS T ,'' AS SUB
                UNION ALL SELECT 20 AS SEQ,'TRANS'                  AS T ,'' AS SUB
                UNION ALL SELECT 21 AS SEQ,'LT'                     AS T ,'' AS SUB
                UNION ALL SELECT 22 AS SEQ,'LINE'                   AS T ,'' AS SUB
                UNION ALL SELECT 23 AS SEQ,'YIELD'                  AS T ,'' AS SUB
                UNION ALL SELECT 24 AS SEQ,'END CUSTOMER'           AS T ,'' AS SUB                
                UNION ALL SELECT 25 AS SEQ,'BOD ID'                 AS T ,'' AS SUB                
                UNION ALL SELECT 26 AS SEQ,'MEASURE'                AS T ,'' AS SUB
                UNION ALL SELECT 27 AS SEQ,'MEASURE'                AS T ,'' AS SUB
                UNION ALL SELECT 28 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
                UNION ALL SELECT 29 AS SEQ,'XLS_KEY2'               AS T ,'' AS SUB
                UNION ALL SELECT 30 AS SEQ,'XLS_KEY3'               AS T ,'' AS SUB
                UNION ALL SELECT 31 AS SEQ,'XLS_KEY4'               AS T ,'' AS SUB
                UNION ALL SELECT 32 AS SEQ,'XLS_KEY5'               AS T ,'' AS SUB
                UNION ALL SELECT 33 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
                UNION ALL SELECT 34 AS SEQ,'XLS_KEY_ATTRIBUTE2'     AS T ,'' AS SUB
                UNION ALL SELECT 35 AS SEQ,'XLS_KEY_ATTRIBUTE3'     AS T ,'' AS SUB
                UNION ALL SELECT 36 AS SEQ,'XLS_KEY_ATTRIBUTE4'     AS T ,'' AS SUB
                UNION ALL SELECT 37 AS SEQ,'XLS_KEY_ATTRIBUTE5'     AS T ,'' AS SUB
                UNION ALL SELECT 38 AS SEQ,'CALC_YN'                AS T ,'' AS SUB
                UNION ALL SELECT 39 AS SEQ,'DISPLAY_YN'             AS T ,'' AS SUB 
                UNION ALL SELECT 40 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
				UNION ALL SELECT 41 AS SEQ,'RESULT'                 AS T ,(SELECT LEFT(@p_plan_start_yyyymmdd, 6) + '01 ~ ' + RIGHT(CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112), 2)) AS SUB		-- PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: 2022.08.10 컬럼추가
                UNION ALL SELECT 50 AS SEQ, C.BASIS_YYYYMMDD		AS T, C.WEEK_NAME
							FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							WHERE 0 = 0
								AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								AND C.BASIS_YYYYMMDD <  @v_plan_end_yyyymmdd        
                UNION ALL SELECT 60 AS SEQ, MONTH_TLT.T, MONTH_TLT.SUB
				            FROM (
				                  SELECT RIGHT(CONVERT(VARCHAR, MIN(E_YYYYMMDD)), 6) + '~' + RIGHT(CONVERT(VARCHAR, MAX(E_YYYYMMDD)), 6) AS T
											, CONVERT(VARCHAR, C_YEAR) + '.' + RIGHT('0' + CONVERT(VARCHAR, C_MONTH), 2) + '|' + CONVERT(VARCHAR, COUNT(E_YYYYMMDD))  AS SUB
									FROM (
										SELECT C.BASIS_YYYYMMDD AS E_YYYYMMDD, CONVERT(INT, C.CALENDAR_YYYY) AS C_YEAR, CONVERT(INT, C.CALENDAR_MONTH) AS C_MONTH
										FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
										WHERE 0 = 0
											AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
											AND C.BASIS_YYYYMMDD <  @v_plan_end_yyyymmdd
										) X
									WHERE X.E_YYYYMMDD > @v_daily_last_yyyymmdd 
								GROUP BY C_MONTH, C_YEAR
								) MONTH_TLT
                UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
			    UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
			    UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
			    UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
			    UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
                UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE10'            AS T ,'' AS SUB
				UNION ALL SELECT 95 AS SEQ,'ATTRIBUTE3'             AS T ,'' AS SUB			--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
				UNION ALL SELECT 96 AS SEQ,'ATTRIBUTE9'             AS T ,'' AS SUB			--PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 :: ISUZU 적용
				UNION ALL SELECT 97 AS SEQ,'Flow_Id'				AS T ,'' AS SUB			--2023.03.09 KKH 소형 ISUZU 모델 제외 ( Flow Id  ‘P5500’ 또는 ‘P9500’ 인 Item 만 제외)
                )  M
            ORDER BY SEQ
                    ,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
                    ,SUB    
      ;
     END
    
  -----------------------------------------
  -- XLSPSI03:소형 CELL PSI SIMULATION
  -----------------------------------------  

  IF @P_PGM_CODE = 'XLSPSI03' 
     BEGIN

      SELECT T,Sub
          FROM (
                          SELECT  1 AS SEQ,'DIVISION'               AS T ,'' AS SUB
                UNION ALL SELECT  2 AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
                UNION ALL SELECT  3 AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
                UNION ALL SELECT  4 AS SEQ,'SEQ'                    AS T ,'' AS SUB  
                UNION ALL SELECT  5 AS SEQ,'CELL TYPE'              AS T ,'' AS SUB
                UNION ALL SELECT  6 AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
                UNION ALL SELECT  7 AS SEQ,'NICK'                   AS T ,'' AS SUB
                UNION ALL SELECT  8 AS SEQ,'MEASURE'                AS T ,'' AS SUB
                UNION ALL SELECT  9 AS SEQ,'MEASURE'                AS T ,'' AS SUB
                UNION ALL SELECT 10 AS SEQ,'SITE ID'                AS T ,'' AS SUB
                UNION ALL SELECT 11 AS SEQ,'SITE'                   AS T ,'' AS SUB
                UNION ALL SELECT 12 AS SEQ,'LINE'                   AS T ,'' AS SUB
                UNION ALL SELECT 13 AS SEQ,'LINE NAME'              AS T ,'' AS SUB
                UNION ALL SELECT 14 AS SEQ,'YIELD'                  AS T ,'' AS SUB
                UNION ALL SELECT 15 AS SEQ,'LT'                     AS T ,'' AS SUB
				UNION ALL SELECT 16 AS SEQ,'LT DAY'                 AS T ,'' AS SUB              
                UNION ALL SELECT 17 AS SEQ,'GRO STD DIO'            AS T ,'' AS SUB
				UNION ALL SELECT 18 AS SEQ,'MIN STD DIO'            AS T ,'' AS SUB
                UNION ALL SELECT 19 AS SEQ,'BOH'                    AS T ,'' AS SUB
--              UNION ALL SELECT 17 AS SEQ,'BOD ID'                 AS T ,'' AS SUB  
                UNION ALL SELECT 20 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
                --UNION ALL SELECT 19 AS SEQ,'XLS_KEY2'               AS T ,'' AS SUB
                --UNION ALL SELECT 20 AS SEQ,'XLS_KEY3'               AS T ,'' AS SUB
                --UNION ALL SELECT 21 AS SEQ,'XLS_KEY4'               AS T ,'' AS SUB
                --UNION ALL SELECT 22 AS SEQ,'XLS_KEY5'               AS T ,'' AS SUB
                --UNION ALL SELECT 23 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
                --UNION ALL SELECT 24 AS SEQ,'XLS_KEY_ATTRIBUTE2'     AS T ,'' AS SUB
                --UNION ALL SELECT 25 AS SEQ,'XLS_KEY_ATTRIBUTE3'     AS T ,'' AS SUB
                --UNION ALL SELECT 26 AS SEQ,'XLS_KEY_ATTRIBUTE4'     AS T ,'' AS SUB
                --UNION ALL SELECT 27 AS SEQ,'XLS_KEY_ATTRIBUTE5'     AS T ,'' AS SUB
                --UNION ALL SELECT 28 AS SEQ,'CALC_YN'                AS T ,'' AS SUB
                --UNION ALL SELECT 29 AS SEQ,'DISPLAY_YN'             AS T ,'' AS SUB 
                UNION ALL SELECT 21 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
                UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
                           WHERE 0 = 0
			                       AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
                             AND C.BASIS_YYYYMMDD <  @v_bp_plan_end_yyyymmdd                -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 플랜 대응              
                UNION ALL SELECT 89 AS SEQ,'CREATE_BY'          AS T ,'' AS SUB
			          UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
			          UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
			          UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
			          --UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
             --   UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE10'            AS T ,'' AS SUB
                )   M
            ORDER BY SEQ
                    ,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
                    ,SUB  
      ;
     END

-----------------------------------------
  -- XLSPSI04: ESS GLOBAL PSI SIMULATION - 사용하지 않음
  -----------------------------------------

  IF @p_pgm_code = 'XLSPSI04' 
     BEGIN

     
	 IF @p_parameter2 = ''		-- MAIN, WEEK PLAN Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							  SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
		            UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
					      UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
					      UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB  
					      UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
					      UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
					      UNION ALL SELECT 7  AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
					      UNION ALL SELECT 8  AS SEQ,'FROM SITE'              AS T ,'' AS SUB
					      UNION ALL SELECT 9  AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
					      UNION ALL SELECT 10 AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					      UNION ALL SELECT 11 AS SEQ,'NICK'                   AS T ,'' AS SUB
					      UNION ALL SELECT 12 AS SEQ,'LINE'                   AS T ,'' AS SUB
					      UNION ALL SELECT 13 AS SEQ,'CELL QTY'               AS T ,'' AS SUB
					      UNION ALL SELECT 14 AS SEQ,'PROJECT'                AS T ,'' AS SUB
                UNION ALL SELECT 15 AS SEQ,'PROJECT NAME'           AS T ,'' AS SUB
					      UNION ALL SELECT 16 AS SEQ,'FROM BOH QTY'           AS T ,'' AS SUB
					      UNION ALL SELECT 17 AS SEQ,'TO BOH QTY'             AS T ,'' AS SUB
					      UNION ALL SELECT 18 AS SEQ,'INCOTERMS'              AS T ,'' AS SUB
					      UNION ALL SELECT 19 AS SEQ,'TO_SITE'                AS T ,'' AS SUB
					      UNION ALL SELECT 20 AS SEQ,'TO SITE'                AS T ,'' AS SUB
					      UNION ALL SELECT 21 AS SEQ,'TRANS'                  AS T ,'' AS SUB
					      UNION ALL SELECT 22 AS SEQ,'LT'                     AS T ,'' AS SUB
				        UNION ALL SELECT 23 AS SEQ,'YIELD'                  AS T ,'' AS SUB
					      UNION ALL SELECT 24 AS SEQ,'BOD ID'                 AS T ,'' AS SUB                
					      UNION ALL SELECT 25 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 26 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 27 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
					      UNION ALL SELECT 28 AS SEQ,'XLS_KEY2'               AS T ,'' AS SUB
					      UNION ALL SELECT 29 AS SEQ,'XLS_KEY3'               AS T ,'' AS SUB
					      UNION ALL SELECT 30 AS SEQ,'XLS_KEY4'               AS T ,'' AS SUB
					      UNION ALL SELECT 31 AS SEQ,'XLS_KEY5'               AS T ,'' AS SUB
					      UNION ALL SELECT 32 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
					      UNION ALL SELECT 33 AS SEQ,'XLS_KEY_ATTRIBUTE2'     AS T ,'' AS SUB
					      UNION ALL SELECT 34 AS SEQ,'XLS_KEY_ATTRIBUTE3'     AS T ,'' AS SUB
					      UNION ALL SELECT 35 AS SEQ,'XLS_KEY_ATTRIBUTE4'     AS T ,'' AS SUB
					      UNION ALL SELECT 36 AS SEQ,'XLS_KEY_ATTRIBUTE5'     AS T ,'' AS SUB
					      --UNION ALL SELECT 35 AS SEQ,'CALC_YN'                AS T ,'' AS SUB
					      --UNION ALL SELECT 36 AS SEQ,'DISPLAY_YN'             AS T ,'' AS SUB 
					      UNION ALL SELECT 37 AS SEQ,'SORT_ORDER_NO'         AS T ,'' AS SUB 
					      UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
								          FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							             WHERE 0 = 0
									             AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								       AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)                      
					      UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
						    UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
						    UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
						    UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
						    UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
					      UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE10'         AS T ,'' AS SUB
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END

	 IF @p_parameter2 = 'prod_load'		-- LOAD RATIO Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							          SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB 
					    UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
					    UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB
					    UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB
					    UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
					    UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
					    UNION ALL SELECT 7  AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
					    UNION ALL SELECT 8  AS SEQ,'FROM SITE'              AS T ,'' AS SUB
					    UNION ALL SELECT 9  AS SEQ,'OPERATION ID'           AS T ,'' AS SUB
					    UNION ALL SELECT 10 AS SEQ,'LINE'                   AS T ,'' AS SUB
					    UNION ALL SELECT 11 AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					    UNION ALL SELECT 12 AS SEQ,'NICK NAME'              AS T ,'' AS SUB
					    UNION ALL SELECT 13 AS SEQ,'WEEKLY CAPA QTY'        AS T ,'' AS SUB		
					    UNION ALL SELECT 14 AS SEQ,'FROM_BOH_QTY'           AS T ,'' AS SUB		
              UNION ALL SELECT 15 AS SEQ,'YIELD'                  AS T ,'' AS SUB
              UNION ALL SELECT 16 AS SEQ,'LT_DAY'                 AS T ,'' AS SUB	
					    UNION ALL SELECT 17 AS SEQ,'CELL_QTY_PACK'          AS T ,'' AS SUB		              
					    UNION ALL SELECT 18 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					    UNION ALL SELECT 19 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					    UNION ALL SELECT 20 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
					    UNION ALL SELECT 21 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
					    UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
								    FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							       WHERE 0 = 0
									       AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								     AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)                      
					    UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
					    UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
					    UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
					    UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END
     END

-----------------------------------------
  -- XLSPSI05: 전극(EE) GLOBAL PSI SIMULATION
  -----------------------------------------

  IF @p_pgm_code = 'XLSPSI05' 
     BEGIN

     

      SELECT T,Sub
       FROM (
                          SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
                UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
                UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
                UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB  
                UNION ALL SELECT 5  AS SEQ,'SUPPLY SITE'            AS T ,'' AS SUB
				UNION ALL SELECT 6  AS SEQ,'SUPPLY SITE DESC'       AS T ,'' AS SUB
                UNION ALL SELECT 7  AS SEQ,'NICK NAME'              AS T ,'' AS SUB
				UNION ALL SELECT 8  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
                UNION ALL SELECT 9  AS SEQ,'ELECTRODE TYPE'         AS T ,'' AS SUB
                UNION ALL SELECT 10 AS SEQ,'CONVERT QTY CELL'       AS T ,'' AS SUB
				UNION ALL SELECT 11 AS SEQ,'PROD LINE'              AS T ,'' AS SUB
				UNION ALL SELECT 12 AS SEQ,'PSI TYPE'               AS T ,'' AS SUB
				UNION ALL SELECT 13 AS SEQ,'GRO STD DIO'            AS T ,'' AS SUB
				UNION ALL SELECT 14 AS SEQ,'MIN STD DIO'            AS T ,'' AS SUB
			    UNION ALL SELECT 15 AS SEQ,'MEASURE'                AS T ,'' AS SUB
				UNION ALL SELECT 16 AS SEQ,'MEASURE LABEL'          AS T ,'' AS SUB
                UNION ALL SELECT 17 AS SEQ,'MEASURE VALUE1'         AS T ,'' AS SUB
                UNION ALL SELECT 18 AS SEQ,'MEASURE VALUE1 LABEL'   AS T ,'' AS SUB
				UNION ALL SELECT 19 AS SEQ,'MEASURE VALUE2'         AS T ,'' AS SUB
                UNION ALL SELECT 20 AS SEQ,'MEASURE VALUE2 LABEL'   AS T ,'' AS SUB
				UNION ALL SELECT 21 AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
                UNION ALL SELECT 22 AS SEQ,'UNIT'                   AS T ,'' AS SUB
                UNION ALL SELECT 23 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
                UNION ALL SELECT 24 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
                UNION ALL SELECT 25 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
                UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
                           WHERE 0 = 0
			                 AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
                             AND C.BASIS_YYYYMMDD <  @v_bp_plan_end_yyyymmdd                -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 플랜 대응
                UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
			          UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
			          UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
			          UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
			          UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
                UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE3'            AS T ,'' AS SUB
				UNION ALL SELECT 95 AS SEQ,'ATTRIBUTE8'            AS T ,'' AS SUB
				UNION ALL SELECT 96 AS SEQ,'ATTRIBUTE9'            AS T ,'' AS SUB
				UNION ALL SELECT 97 AS SEQ,'CELL_TYPE_GROUP_CODE'  AS T ,'' AS SUB
				UNION ALL SELECT 98 AS SEQ,'TO_SITE_ID'            AS T ,'' AS SUB
				UNION ALL SELECT 99 AS SEQ,'TO_SITE_DESCRIPTION'   AS T ,'' AS SUB
                )   M
            ORDER BY SEQ
                    ,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
                    ,SUB  
      ;
     END


-----------------------------------------
  -- XLSPSI06: ESS GLOBAL PSI SIMULATION - PACK
  -----------------------------------------

  IF @p_pgm_code = 'XLSPSI06' 
     BEGIN

     
	 IF @p_parameter2 = ''		-- MAIN, WEEK PLAN Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							  SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
		            UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
					      UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
					      UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB  
					      UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
					      UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
					      UNION ALL SELECT 7  AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
					      UNION ALL SELECT 8  AS SEQ,'FROM SITE'              AS T ,'' AS SUB
					      UNION ALL SELECT 9  AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
					      UNION ALL SELECT 10 AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					      UNION ALL SELECT 11 AS SEQ,'NICK'                   AS T ,'' AS SUB
					      UNION ALL SELECT 12 AS SEQ,'LINE'                AS T ,'' AS SUB
					      UNION ALL SELECT 13 AS SEQ,'CELL QTY'               AS T ,'' AS SUB
					      UNION ALL SELECT 14 AS SEQ,'PROJECT'                AS T ,'' AS SUB
					      UNION ALL SELECT 15 AS SEQ,'PROJECT NAME'           AS T ,'' AS SUB
					      UNION ALL SELECT 16 AS SEQ,'FROM BOH QTY'           AS T ,'' AS SUB
					      UNION ALL SELECT 17 AS SEQ,'TO BOH QTY'             AS T ,'' AS SUB
					      UNION ALL SELECT 18 AS SEQ,'INCOTERMS'              AS T ,'' AS SUB
					      UNION ALL SELECT 19 AS SEQ,'TO_SITE'                AS T ,'' AS SUB
					      UNION ALL SELECT 20 AS SEQ,'TO SITE'                AS T ,'' AS SUB
					      UNION ALL SELECT 21 AS SEQ,'TRANS'                  AS T ,'' AS SUB
					      UNION ALL SELECT 22 AS SEQ,'LT'                     AS T ,'' AS SUB
					      UNION ALL SELECT 23 AS SEQ,'YIELD'                  AS T ,'' AS SUB
					      UNION ALL SELECT 24 AS SEQ,'BOD ID'                 AS T ,'' AS SUB                
					      UNION ALL SELECT 25 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 26 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 27 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
					      UNION ALL SELECT 28 AS SEQ,'XLS_KEY2'               AS T ,'' AS SUB
					      UNION ALL SELECT 29 AS SEQ,'XLS_KEY3'               AS T ,'' AS SUB
					      UNION ALL SELECT 30 AS SEQ,'XLS_KEY4'               AS T ,'' AS SUB
					      UNION ALL SELECT 31 AS SEQ,'XLS_KEY5'               AS T ,'' AS SUB
					      UNION ALL SELECT 32 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
					      UNION ALL SELECT 33 AS SEQ,'XLS_KEY_ATTRIBUTE2'     AS T ,'' AS SUB
					      UNION ALL SELECT 34 AS SEQ,'XLS_KEY_ATTRIBUTE3'     AS T ,'' AS SUB
					      UNION ALL SELECT 35 AS SEQ,'XLS_KEY_ATTRIBUTE4'     AS T ,'' AS SUB
					      UNION ALL SELECT 36 AS SEQ,'XLS_KEY_ATTRIBUTE5'     AS T ,'' AS SUB
					      --UNION ALL SELECT 35 AS SEQ,'CALC_YN'                AS T ,'' AS SUB
					      --UNION ALL SELECT 36 AS SEQ,'DISPLAY_YN'             AS T ,'' AS SUB 
					      UNION ALL SELECT 37 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
					      UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
								          FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							             WHERE 0 = 0
									             AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								       AND C.BASIS_YYYYMMDD <  @v_bp_plan_end_yyyymmdd                -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 플랜 대응                        
					      UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
						    UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
						    UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
						    UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
						    UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
					      --UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE10'         AS T ,'' AS SUB		--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						  UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE3'             AS T ,'' AS SUB
						  UNION ALL SELECT 95 AS SEQ,'ATTRIBUTE6'             AS T ,'' AS SUB      --DC_YN DC_LINK 참조열
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END

	 IF @p_parameter2 = 'prod_load'		-- LOAD RATIO Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							          SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB 
					    UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
					    UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB
					    UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB
					    UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
					    UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
					    UNION ALL SELECT 7  AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
					    UNION ALL SELECT 8  AS SEQ,'FROM SITE'              AS T ,'' AS SUB
					    UNION ALL SELECT 9  AS SEQ,'OPERATION ID'           AS T ,'' AS SUB
					    UNION ALL SELECT 10 AS SEQ,'LINE'                   AS T ,'' AS SUB
						  UNION ALL SELECT 11 AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
					    UNION ALL SELECT 12 AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					    UNION ALL SELECT 13 AS SEQ,'NICK NAME'              AS T ,'' AS SUB
					    UNION ALL SELECT 14 AS SEQ,'WEEKLY CAPA QTY'        AS T ,'' AS SUB		
					    UNION ALL SELECT 15 AS SEQ,'FROM_BOH_QTY'           AS T ,'' AS SUB		
					    UNION ALL SELECT 16 AS SEQ,'YIELD'                  AS T ,'' AS SUB
					    UNION ALL SELECT 17 AS SEQ,'LT'                     AS T ,'' AS SUB	
					    UNION ALL SELECT 18 AS SEQ,'CELL_QTY_PACK'          AS T ,'' AS SUB	
						  UNION ALL SELECT 19 AS SEQ,'TO_SITE'                AS T ,'' AS SUB	 
						  UNION ALL SELECT 20 AS SEQ,'TO SITE'                AS T ,'' AS SUB      
						  UNION ALL SELECT 21 AS SEQ,'BOD ID'                 AS T ,'' AS SUB		--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					    UNION ALL SELECT 22 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					    UNION ALL SELECT 23 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					    UNION ALL SELECT 24 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
					    UNION ALL SELECT 25 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
					    UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
								    FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							       WHERE 0 = 0
									       AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								     AND C.BASIS_YYYYMMDD <  @v_bp_plan_end_yyyymmdd                -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 플랜 대응                      
					    UNION ALL SELECT 89 AS SEQ,'ORD2'              AS T ,'' AS SUB
					    UNION ALL SELECT 90 AS SEQ,'ORD3'              AS T ,'' AS SUB
					    UNION ALL SELECT 91 AS SEQ,'ORD1'              AS T ,'' AS SUB
						UNION ALL SELECT 92 AS SEQ,'ATTRIBUTE3'        AS T ,'' AS SUB		--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					    UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE6'        AS T ,'' AS SUB      --DC_YN DC_LINK 참조열
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END
     END


  -----------------------------------------
  -- XLSPSI07: ESS GLOBAL PSI SIMULATION - CELL
  -----------------------------------------

  IF @p_pgm_code = 'XLSPSI07' 
     BEGIN

     
	 IF @p_parameter2 = ''		-- PSI PLAN Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							  SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
		            UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
					      UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB 
					      UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB  
					      UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
					      UNION ALL SELECT 6  AS SEQ,'OPERATION'              AS T ,'' AS SUB
					      UNION ALL SELECT 7  AS SEQ,'CELL ITEM ID'           AS T ,'' AS SUB
					      UNION ALL SELECT 8  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					      UNION ALL SELECT 9  AS SEQ,'NICK'                   AS T ,'' AS SUB
					      UNION ALL SELECT 10 AS SEQ,'CELL QTY'               AS T ,'' AS SUB
					      UNION ALL SELECT 11 AS SEQ,'TO_SITE'                AS T ,'' AS SUB
					      UNION ALL SELECT 12 AS SEQ,'TO SITE'                AS T ,'' AS SUB
					      UNION ALL SELECT 13 AS SEQ,'PROJECT'                AS T ,'' AS SUB
					      UNION ALL SELECT 14 AS SEQ,'PROJECT NAME'           AS T ,'' AS SUB
					      UNION ALL SELECT 15 AS SEQ,'FROM BOH QTY'    AS T ,'' AS SUB
					      UNION ALL SELECT 16 AS SEQ,'TO BOH QTY'             AS T ,'' AS SUB
					      UNION ALL SELECT 17 AS SEQ,'INCOTERMS'              AS T ,'' AS SUB
					      UNION ALL SELECT 18 AS SEQ,'FROM_SITE'              AS T ,'' AS SUB
					      UNION ALL SELECT 19 AS SEQ,'FROM SITE'              AS T ,'' AS SUB
					      UNION ALL SELECT 20 AS SEQ,'TRANS'                  AS T ,'' AS SUB
					      UNION ALL SELECT 21 AS SEQ,'LT'                     AS T ,'' AS SUB
					      UNION ALL SELECT 22 AS SEQ,'YIELD'                  AS T ,'' AS SUB
					      UNION ALL SELECT 23 AS SEQ,'LINE'                   AS T ,'' AS SUB
					      UNION ALL SELECT 24 AS SEQ,'BOD ID'                 AS T ,'' AS SUB   
				          UNION ALL SELECT 25 AS SEQ,'GRO STD DIO'            AS T ,'' AS SUB
				          UNION ALL SELECT 26 AS SEQ,'MIN STD DIO'            AS T ,'' AS SUB
					      UNION ALL SELECT 27 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 28 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 29 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
					      UNION ALL SELECT 30 AS SEQ,'XLS_KEY2'               AS T ,'' AS SUB
					      UNION ALL SELECT 31 AS SEQ,'XLS_KEY3'               AS T ,'' AS SUB
					      UNION ALL SELECT 32 AS SEQ,'XLS_KEY4'               AS T ,'' AS SUB
					      UNION ALL SELECT 33 AS SEQ,'XLS_KEY5'               AS T ,'' AS SUB
					      UNION ALL SELECT 34 AS SEQ,'XLS_KEY_ATTRIBUTE1'     AS T ,'' AS SUB
					      UNION ALL SELECT 35 AS SEQ,'XLS_KEY_ATTRIBUTE2'     AS T ,'' AS SUB
					      UNION ALL SELECT 36 AS SEQ,'XLS_KEY_ATTRIBUTE3'     AS T ,'' AS SUB
					      UNION ALL SELECT 37 AS SEQ,'XLS_KEY_ATTRIBUTE4'     AS T ,'' AS SUB
					      UNION ALL SELECT 38 AS SEQ,'XLS_KEY_ATTRIBUTE5'     AS T ,'' AS SUB
					      --UNION ALL SELECT 35 AS SEQ,'CALC_YN'                AS T ,'' AS SUB
					      --UNION ALL SELECT 36 AS SEQ,'DISPLAY_YN'             AS T ,'' AS SUB 
					      UNION ALL SELECT 39 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
					      UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
								          FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							             WHERE 0 = 0
									             AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								       AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)                      
					      UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
						    UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
						    UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
						    UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
						    UNION ALL SELECT 93 AS SEQ,'ATTRIBUTE1'             AS T ,'' AS SUB
					      --UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE10'         AS T ,'' AS SUB			--PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						    UNION ALL SELECT 94 AS SEQ,'ATTRIBUTE3'             AS T ,'' AS SUB
							UNION ALL SELECT 95 AS SEQ,'ATTRIBUTE6'             AS T ,'' AS SUB      --DC_YN DC_LINK 참조열
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END

	 IF @p_parameter2 = 'prod_load'		-- LOAD RATIO Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							          SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB 
					    UNION ALL SELECT 2  AS SEQ,'PLAN START YYYYMMDD'    AS T ,'' AS SUB
					    UNION ALL SELECT 3  AS SEQ,'PLAN TYPE'              AS T ,'' AS SUB
					    UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB
					    UNION ALL SELECT 5  AS SEQ,'OPERATION_GROUP'        AS T ,'' AS SUB
					    UNION ALL SELECT 6  AS SEQ,'OPERATION GROUP NAME'   AS T ,'' AS SUB
					    UNION ALL SELECT 7  AS SEQ,'FROM SITE'              AS T ,'' AS SUB
					    UNION ALL SELECT 8  AS SEQ,'FROM SITE DESCRIPTION'  AS T ,'' AS SUB
					    UNION ALL SELECT 9  AS SEQ,'OPERATION ID'           AS T ,'' AS SUB
					    UNION ALL SELECT 10 AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					    UNION ALL SELECT 11 AS SEQ,'NICK NAME'              AS T ,'' AS SUB
						  UNION ALL SELECT 12 AS SEQ,'LINE'                   AS T ,'' AS SUB
					    UNION ALL SELECT 13 AS SEQ,'WEEKLY CAPA QTY'        AS T ,'' AS SUB	
						  UNION ALL SELECT 14 AS SEQ,'TACT TIME'              AS T ,'' AS SUB	              
					    UNION ALL SELECT 15 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					    UNION ALL SELECT 16 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					    UNION ALL SELECT 17 AS SEQ,'SORT_ORDER_NO'          AS T ,'' AS SUB 
					    UNION ALL SELECT 18 AS SEQ,'XLS_KEY1'               AS T ,'' AS SUB
					    UNION ALL SELECT 88 AS SEQ, C.BASIS_YYYYMMDD        AS T , WEEK_NAME
								    FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
							       WHERE 0 = 0
									       AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								     AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)                      
					    UNION ALL SELECT 89 AS SEQ,'CREATE_BY'              AS T ,'' AS SUB
					    UNION ALL SELECT 90 AS SEQ,'CREATION_DATE'          AS T ,'' AS SUB
					    UNION ALL SELECT 91 AS SEQ,'LAST_UPDATED_BY'        AS T ,'' AS SUB
					    UNION ALL SELECT 92 AS SEQ,'LAST_UPDATE_DATE'       AS T ,'' AS SUB
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END
     END

 -----------------------------------------
 -- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선'
 -- XLSPSI21: 소형 SHIPMENT PLAN 입력 SIMULATION
 -----------------------------------------

  IF @p_pgm_code = 'XLSPSI21' 
  BEGIN
	
	SET @p_plan_type            = 'MA';
	SET @p_seq                  = NULL;  --'3';

	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_plan_end_yyyymmdd    = NULL;
	SET @v_seq                  = NULL;
	SET @v_cols                 = NULL;
	SET @v_cols2                = NULL;
	SET @SQL                    = NULL;

	SET @p_plan_start_yyyymmdd  = NULL;  --'20210510';

	SET @v_plan_start_yyyymmdd  = '';
	SET @v_seq = '';
	SET @v_cols = '';
	SET @v_cols2 = '';

	-- 파라미터 확인 
	SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			,@v_seq = SUBSTRING(MAX(ENG_PLAN_ID), CHARINDEX(@p_plan_type + '::', MAX(ENG_PLAN_ID)) + 4, 1)
		FROM DBO.SCP_PLAN_PARAMETER_V WITH (NOLOCK)
		WHERE MASTER_ID = '40::WEEKLY'
		AND ENG_PLAN_ID LIKE '%' + @p_plan_type + '%'
	;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @p_plan_start_yyyymmdd = @v_plan_start_yyyymmdd ;

	IF @p_seq IS NULL
		SET @p_seq = @v_seq ;

	-----------------
	-- Frozen 구간
	-----------------
	-- 2020.02.03 :: 소형 SHIPMENT PLAN 입력 SIMULATION 추가 - ship frozen 구간을 week plan 으로 변경 
	-- Frozen 구간을 위한 변수추가
	SET @v_frozen_end_yyyymmdd  = '';
	SET @v_frozen_days          = 7;

--		20231006 강현준. SHIP FROZEN 구간을 LOOKUP 테이블에 없으면 MST_SITE 기준으로 정의함.
	DECLARE @scp_simulator_ship_fixed_term_flag                  NVARCHAR(0001) = 'N';

	SELECT @scp_simulator_ship_fixed_term_flag = MAX(VALID_YN) 
	FROM [DBO].[SCM_ADM_LOOKUP_MASTER] WITH (NOLOCK) 
	WHERE LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM';
		
	IF ( @scp_simulator_ship_fixed_term_flag = 'Y') 
	BEGIN
		SELECT @v_frozen_days = ISNULL(MAX(CONVERT(INT, ISNULL(B.SEGMENT3, A.SHIP_FROZEN))), @v_frozen_days)
			FROM  [DBO].[SCM_MST_SITE] A WITH (NOLOCK)
				LEFT OUTER JOIN
				[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
				ON B.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM' AND A.DIVISION_ID = B.SEGMENT1 AND A.SCM_SITE_ID = B.SEGMENT2 AND B.VALID_YN = 'Y'
			WHERE A.DIVISION_ID = @p_division_id
			AND A.SCM_SITE_ID IN (SELECT DISTINCT FROM_SITE
								FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)
								WHERE DIVISION_ID = @p_division_id
									AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									AND PLAN_TYPE = @p_plan_type
									AND SEQ = @p_seq
									AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter3,','))
									AND BIZ_TYPE = 'A'
									AND MEASURE = 'SHIP_PLAN_AMEND')
			AND A.OPERATION_GROUP = 'A'
			AND A.SITE_TYPE = 'PLANT'
			AND A.VALID_YN = 'Y'
			AND A.OSP_YN = 'N'
		;
	END

	IF ( @scp_simulator_ship_fixed_term_flag = 'N') 
	BEGIN
		SELECT @v_frozen_days = ISNULL(MAX(CONVERT(INT, A.SHIP_FROZEN)), @v_frozen_days)
		FROM  [DBO].[SCM_MST_SITE] A WITH (NOLOCK)
		WHERE A.DIVISION_ID = @p_division_id
		AND A.SCM_SITE_ID IN (	SELECT DISTINCT FROM_SITE
								FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)
								WHERE DIVISION_ID = @p_division_id
									AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									AND PLAN_TYPE = 'MA'
									AND SEQ = @p_seq
									AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter3,','))
									AND BIZ_TYPE = 'A'
									AND MEASURE = 'SHIP_PLAN_AMEND')
		AND A.OPERATION_GROUP = 'A'
		AND A.SITE_TYPE = 'PLANT'
		AND A.VALID_YN = 'Y'
		AND A.OSP_YN = 'N'
		;
	END

	--SELECT 1, @p_plan_start_yyyymmdd "@p_plan_start_yyyymmdd", @v_frozen_days "@v_frozen_days", @scp_simulator_ship_fixed_term_flag "@scp_simulator_ship_fixed_term_flag"

	SELECT @v_frozen_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,@v_frozen_days-1,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112);
	SET @v_frozen_area_last_yyyymmdd = @v_frozen_end_yyyymmdd;

	-----------------
	-- Week Plan 기간
	-----------------
	DECLARE @v_weekplan_days integer = 7 * 8;
	DECLARE @v_weekplan_start_yyyymmdd	NVARCHAR(0008) = '';
	DECLARE @v_weekplan_end_yyyymmdd	NVARCHAR(0008) = '';

	SELECT @v_weekplan_start_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)),112) 
	SELECT @v_weekplan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,@v_weekplan_days-1,CONVERT(DATETIME,(@v_weekplan_start_yyyymmdd),112)),112)

	-- Week End 일자를 월 말일로 조정한다.
	DECLARE @v_weekplan_last_yyyymmdd	NVARCHAR(0008) = '';

	-- 다음일자가 1일 아니면
	IF (CONVERT(INTEGER, RIGHT(CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_end_yyyymmdd),112)),112), 2)) <> 1)
	BEGIN
		SELECT @v_weekplan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(LEFT(@v_weekplan_end_yyyymmdd, 6) + '01'),112)),112)
	END

	SET @v_weekplan_last_yyyymmdd = @v_weekplan_end_yyyymmdd;

	-----------------
	-- Month 단위 Plan 기간
	-----------------
	DECLARE @v_month_plan_start_yyyymmdd NVARCHAR(8) = CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)),112);

	IF @p_parameter2 = ''		-- SHIP REQ Sheet
	BEGIN
	SELECT T,Sub
		FROM (
							SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
					UNION ALL SELECT 2  AS SEQ,'PLAN_START_YYYYMMDD'    AS T ,'' AS SUB 
					UNION ALL SELECT 3  AS SEQ,'PLAN_TYPE'              AS T ,'' AS SUB  
					UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB
					UNION ALL SELECT 5  AS SEQ,'CELL TYPE'              AS T ,'' AS SUB
					UNION ALL SELECT 6  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					UNION ALL SELECT 7  AS SEQ,'NICK'                   AS T ,'' AS SUB
					UNION ALL SELECT 8  AS SEQ,'DEPT_ID'                AS T ,'' AS SUB
		            UNION ALL SELECT 9  AS SEQ,'DEPT'                   AS T ,'' AS SUB
		            UNION ALL SELECT 10 AS SEQ,'DEPT NAME'              AS T ,'' AS SUB
					UNION ALL SELECT 11 AS SEQ,'FROM_SITE'              AS T ,'' AS SUB	
					UNION ALL SELECT 12 AS SEQ,'MEASURE_CD'             AS T ,'' AS SUB	
					UNION ALL SELECT 13 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					UNION ALL SELECT 14 AS SEQ,'BOH'                    AS T ,'' AS SUB
					UNION ALL SELECT 15 AS SEQ,'XLS_ORD'                AS T ,'' AS SUB
					UNION ALL SELECT 16 + A.R_NUM AS SEQ, A.S_YYYYMMDD + '~' + A.E_YYYYMMDD AS T, WEEK_NAME AS SUB
							FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM, S1.WEEK_NAME
								FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
												,C.BASIS_YYYYMMDD AS E_YYYYMMDD
												,C.WEEK_NAME
										FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
										WHERE 0 = 0
											AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
											AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days, CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
											AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
										) S1,
										(SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
											,C.BASIS_YYYYMMDD AS S_YYYYMMDD
										FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
										WHERE 0 = 0
											AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
											AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days, CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
											AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2
										) S2
								WHERE S1.R_NUM = S2.R_NUM
								UNION ALL
								SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM + 10, S1.WEEK_NAME
								FROM (SELECT  ROW_NUMBER() OVER(ORDER BY MAX(C.BASIS_YYYYMMDD) ASC) AS R_NUM
												,MAX(C.BASIS_YYYYMMDD) AS E_YYYYMMDD
												,C.PARTIAL_WEEK_NAME AS WEEK_NAME
										FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
										WHERE 0 = 0
											AND C.BASIS_YYYYMMDD >= @v_weekplan_start_yyyymmdd
											AND C.BASIS_YYYYMMDD <= @v_weekplan_last_yyyymmdd
										GROUP BY C.PARTIAL_WEEK_NAME
										) S1,
										(SELECT ROW_NUMBER() OVER(ORDER BY MIN(C.BASIS_YYYYMMDD) ASC) AS R_NUM
											,MIN(C.BASIS_YYYYMMDD) AS S_YYYYMMDD
											,C.PARTIAL_WEEK_NAME AS WEEK_NAME
										FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
										WHERE 0 = 0
											AND C.BASIS_YYYYMMDD >= @v_weekplan_start_yyyymmdd
											AND C.BASIS_YYYYMMDD <= @v_weekplan_last_yyyymmdd
										GROUP BY C.PARTIAL_WEEK_NAME
										) S2
								WHERE S1.R_NUM = S2.R_NUM
								) AS A
					UNION ALL SELECT 40 + ROW_NUMBER() OVER(ORDER BY YYYYMM ASC) AS SEQ, YYYYMM                  AS T ,'' AS SUB
								FROM (
										SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 4) + '.' + SUBSTRING(C.BASIS_YYYYMMDD, 5, 2) AS YYYYMM
									FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
									WHERE 0 = 0
											AND C.BASIS_YYYYMMDD >= @v_month_plan_start_yyyymmdd
										AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,366+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 366 --> 366+182
									) AS days
					UNION ALL SELECT 61 AS SEQ,'TOTAL_QTY'              AS T ,'' AS SUB
					UNION ALL SELECT 62 AS SEQ,'CONFIRM_QTY'            AS T ,'Forecast-Ship Plan' AS SUB
					UNION ALL SELECT 63 AS SEQ,'CONFIRM_QTY2'           AS T ,'Ship Req.-Ship Plan' AS SUB
					UNION ALL SELECT 64 AS SEQ,'PLAN_END_YYYYMMDD'      AS T ,'' AS SUB
					UNION ALL SELECT 65 AS SEQ,'FROZEN'                 AS T ,'' AS SUB
			)   M
	ORDER BY SEQ, SUB  
	;
	END
	
		IF @p_parameter2 = 'day_result'		-- RAW 차감후 결과
		BEGIN

			SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 --> 364+182

			SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

			  SELECT T,Sub
				  FROM (
										SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
							  UNION ALL SELECT 2  AS SEQ,'DEPT'                   AS T ,'' AS SUB
							  UNION ALL SELECT 3  AS SEQ,'DEPT NAME'              AS T ,'' AS SUB
							  UNION ALL SELECT 4  AS SEQ,'PLAN_START_YYYYMMDD'    AS T ,'' AS SUB 
							  UNION ALL SELECT 5  AS SEQ,'PLAN_TYPE'              AS T ,'' AS SUB  
							  UNION ALL SELECT 6  AS SEQ,'SEQ'                    AS T ,'' AS SUB
							  UNION ALL SELECT 7  AS SEQ,'PROJECT CODE'           AS T ,'' AS SUB
							  UNION ALL SELECT 8  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
							  UNION ALL SELECT 9  AS SEQ,'NICK'                   AS T ,'' AS SUB
							  UNION ALL SELECT 10 AS SEQ,'FROM SITE'                AS T ,'' AS SUB
							  UNION ALL SELECT 11 AS SEQ,'TO SITE'                AS T ,'' AS SUB
							  UNION ALL SELECT 12 AS SEQ,'MEASURE_CD'             AS T ,'' AS SUB
							  UNION ALL SELECT 13 AS SEQ,'MEASURE'                AS T ,'' AS SUB
							  UNION ALL SELECT 14 AS SEQ, YYYYMMDD                AS T ,'' AS SUB
										  FROM (
												 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
												FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
												WHERE 0 = 0
														AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
													AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd
											   ) AS days
						)   M
					ORDER BY SEQ
							,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
							,SUB  
			  ;
		END



     END

-----------------------------------------
 -- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선'
 -- XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION
 -----------------------------------------

  IF @p_pgm_code = 'XLSPSI22' 
     BEGIN

	SET @p_plan_type = 'MA';
    SET @p_seq       = NULL;

	SET @v_plan_start_yyyymmdd = NULL;
	SET @v_plan_end_yyyymmdd   = NULL;
	SET @v_seq                 = NULL;
	SET @v_cols                = NULL;
	SET @v_cols2               = NULL;
	SET @SQL                   = NULL;

	SET @p_plan_start_yyyymmdd = NULL;

	SET @v_plan_start_yyyymmdd = '';
	SET @v_seq = '';
	SET @v_cols = '';
	SET @v_cols2 = '';

	-- 파라미터 확인 
	SELECT @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			,@v_seq = SUBSTRING(MAX(ENG_PLAN_ID), CHARINDEX('MA::', MAX(ENG_PLAN_ID)) + 4, 1)
		FROM DBO.SCP_PLAN_PARAMETER_V WITH (NOLOCK)
		WHERE MASTER_ID = '82::WEEKLY'
		AND ENG_PLAN_ID LIKE '%MA%'
	;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @p_plan_start_yyyymmdd = @v_plan_start_yyyymmdd ;

	IF @p_seq IS NULL
		SET @p_seq = @v_seq ;

	-- 2020.02.03 :: 소형 SHIPMENT PLAN 입력 SIMULATION 추가 - ship frozen 구간을 week plan 으로 변경
	-- Frozen 구간을 위한 변수추가
	SET @v_frozen_end_yyyymmdd = '';
	SET @v_frozen_days         = 21;

	SELECT @v_frozen_days = A.SHIP_FROZEN
	  FROM [DBO].[SCM_MST_SITE] A WITH (NOLOCK)
	 WHERE DIVISION_ID = '82'
	   AND SCM_SITE_ID = (SELECT TOP 1 FROM_SITE
							FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)
						   WHERE DIVISION_ID = '82'
							 AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							 AND PLAN_TYPE = 'MA'
							 AND SEQ = @p_seq
							 AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter3,','))
							 AND BIZ_TYPE = 'P'
							 AND MEASURE = 'SHIP_PLAN_AMEND')
	   AND OPERATION_GROUP = 'P'
	   AND SITE_TYPE = 'PLANT'
	   AND VALID_YN = 'Y'
	   AND OSP_YN = 'Y'
	   ;

	SELECT @v_frozen_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,@v_frozen_days-1,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
	;

	SET @v_frozen_area_last_yyyymmdd = '';
	SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_frozen_end_yyyymmdd, 6) + '01'),112)),112)
	;
	SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)),112)
	;

	 IF @p_parameter2 = ''		-- SHIP REQ Sheet
		BEGIN
		  SELECT T,Sub
			  FROM (
							 --       SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
					   --   UNION ALL SELECT 2  AS SEQ,'PLAN_START_YYYYMMDD'    AS T ,'' AS SUB 
					   --   UNION ALL SELECT 3  AS SEQ,'PLAN_TYPE'              AS T ,'' AS SUB  
					   --   UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB
					   --   UNION ALL SELECT 5  AS SEQ,'CELL TYPE'              AS T ,'' AS SUB
					   --   UNION ALL SELECT 6  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					   --   UNION ALL SELECT 7  AS SEQ,'NICK'                   AS T ,'' AS SUB
						  --UNION ALL SELECT 8  AS SEQ,'DEPT_ID'                AS T ,'' AS SUB
		      --            UNION ALL SELECT 9  AS SEQ,'DEPT'                   AS T ,'' AS SUB
		      --            UNION ALL SELECT 10 AS SEQ,'DEPT NAME'              AS T ,'' AS SUB
					   --   UNION ALL SELECT 11 AS SEQ,'MEASURE_CD'             AS T ,'' AS SUB	
						  --UNION ALL SELECT 12 AS SEQ,'MEASURE'                AS T ,'' AS SUB
						  --UNION ALL SELECT 13 AS SEQ,'BOH'                    AS T ,'' AS SUB
					   --   UNION ALL SELECT 14 AS SEQ,'XLS_ORD'                AS T ,'' AS SUB
					   --   UNION ALL SELECT 15 AS SEQ, YYYYMM                  AS T ,'' AS SUB
								--	  FROM (
								--			 --SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 6) AS YYYYMM
								--			 SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 4) + '.' + SUBSTRING(C.BASIS_YYYYMMDD, 5, 2) AS YYYYMM
								--			FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
								--			WHERE 0 = 0
								--					AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
								--				AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
								--		   ) AS days
					   --   UNION ALL SELECT 16 AS SEQ,'TOTAL_QTY'              AS T ,'' AS SUB
						  --UNION ALL SELECT 17 AS SEQ,'CONFIRM_QTY'            AS T ,'Forcast-Ship Plan' AS SUB
						  --UNION ALL SELECT 18 AS SEQ,'CONFIRM_QTY2'           AS T ,'Ship Req.-Ship Plan' AS SUB
						  --UNION ALL SELECT 19 AS SEQ,'PLAN_END_YYYYMMDD'      AS T ,'' AS SUB
						  --UNION ALL SELECT 20 AS SEQ,'FROZEN'                 AS T ,'' AS SUB



							        SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
					      UNION ALL SELECT 2  AS SEQ,'PLAN_START_YYYYMMDD'    AS T ,'' AS SUB 
					      UNION ALL SELECT 3  AS SEQ,'PLAN_TYPE'              AS T ,'' AS SUB  
					      UNION ALL SELECT 4  AS SEQ,'SEQ'                    AS T ,'' AS SUB
					      UNION ALL SELECT 5  AS SEQ,'CELL TYPE'              AS T ,'' AS SUB
					      UNION ALL SELECT 6  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					      UNION ALL SELECT 7  AS SEQ,'NICK'                   AS T ,'' AS SUB
						  UNION ALL SELECT 8  AS SEQ,'DEPT_ID'                AS T ,'' AS SUB
		                  UNION ALL SELECT 9  AS SEQ,'DEPT'                   AS T ,'' AS SUB
		                  UNION ALL SELECT 10 AS SEQ,'DEPT NAME'              AS T ,'' AS SUB
					      UNION ALL SELECT 11 AS SEQ,'MEASURE_CD'             AS T ,'' AS SUB	
						  UNION ALL SELECT 12 AS SEQ,'MEASURE'                AS T ,'' AS SUB
						  UNION ALL SELECT 13 AS SEQ,'BOH'                    AS T ,'' AS SUB
					      UNION ALL SELECT 14 AS SEQ,'XLS_ORD'                AS T ,'' AS SUB
						  UNION ALL SELECT 14 + A.R_NUM AS SEQ, A.S_YYYYMMDD + '~' + A.E_YYYYMMDD AS T, WEEK_NAME AS SUB
									FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM, S1.WEEK_NAME
										FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
														,C.BASIS_YYYYMMDD AS E_YYYYMMDD
														,C.WEEK_NAME
												FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
												WHERE 0 = 0
													AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
													AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days, CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
													AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
												) S1,
												(SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
													,C.BASIS_YYYYMMDD AS S_YYYYMMDD
												FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
												WHERE 0 = 0
													AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
													AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days, CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
													AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2
												) S2
										WHERE S1.R_NUM = S2.R_NUM
										UNION ALL
										SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_frozen_end_yyyymmdd ),112)),112) AS S_YYYYMMDD
											,@v_frozen_area_last_yyyymmdd  AS E_YYYYMMDD, 10 AS R_NUM
											,' ' AS WEEK_NAME
                                         WHERE CONVERT(DATETIME,(@v_frozen_end_yyyymmdd),112) < CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)
										) AS A
					      UNION ALL SELECT 30 + ROW_NUMBER() OVER(ORDER BY YYYYMM ASC) AS SEQ, YYYYMM                  AS T ,'' AS SUB
									  FROM (
											 --SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 6) AS YYYYMM
											 SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 4) + '.' + SUBSTRING(C.BASIS_YYYYMMDD, 5, 2) AS YYYYMM
											FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
											WHERE 0 = 0
													AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
												AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,366,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
										   ) AS days
					      UNION ALL SELECT 51 AS SEQ,'TOTAL_QTY'              AS T ,'' AS SUB
						  UNION ALL SELECT 52 AS SEQ,'CONFIRM_QTY'            AS T ,'Forcast-Ship Plan' AS SUB
						  UNION ALL SELECT 53 AS SEQ,'CONFIRM_QTY2'           AS T ,'Ship Req.-Ship Plan' AS SUB
						  UNION ALL SELECT 54 AS SEQ,'PLAN_END_YYYYMMDD'      AS T ,'' AS SUB
						  UNION ALL SELECT 55 AS SEQ,'FROZEN'                 AS T ,'' AS SUB
					)   M
				ORDER BY SEQ
						--,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END

	 IF @p_parameter2 = 'day_result'		-- RAW 차감후 결과
		BEGIN

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		  SELECT T,Sub
			  FROM (
							        SELECT 1  AS SEQ,'DIVISION'               AS T ,'' AS SUB
		                  UNION ALL SELECT 2  AS SEQ,'DEPT'                   AS T ,'' AS SUB
		                  UNION ALL SELECT 3  AS SEQ,'DEPT NAME'              AS T ,'' AS SUB
					      UNION ALL SELECT 4  AS SEQ,'PLAN_START_YYYYMMDD'    AS T ,'' AS SUB 
					      UNION ALL SELECT 5  AS SEQ,'PLAN_TYPE'              AS T ,'' AS SUB  
					      UNION ALL SELECT 6  AS SEQ,'SEQ'                    AS T ,'' AS SUB
						  UNION ALL SELECT 7  AS SEQ,'PROJECT CODE'           AS T ,'' AS SUB
					      UNION ALL SELECT 8  AS SEQ,'ITEM ID'                AS T ,'' AS SUB
					      UNION ALL SELECT 9  AS SEQ,'NICK'                   AS T ,'' AS SUB
						  UNION ALL SELECT 10 AS SEQ,'TO SITE'                AS T ,'' AS SUB
						  UNION ALL SELECT 11 AS SEQ,'MEASURE_CD'             AS T ,'' AS SUB
						  UNION ALL SELECT 12 AS SEQ,'MEASURE'                AS T ,'' AS SUB
					      UNION ALL SELECT 13 AS SEQ, YYYYMMDD                AS T ,'' AS SUB
									  FROM (
											 SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
											FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
											WHERE 0 = 0
													AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
												AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd
										   ) AS days
					)   M
				ORDER BY SEQ
						,T  --WEEK_START_YYYYMMDD 먼저 SORT필요
						,SUB  
		  ;
		END
     END

/*************************************
 *   END OF PROGRAM
 *************************************/    
END
