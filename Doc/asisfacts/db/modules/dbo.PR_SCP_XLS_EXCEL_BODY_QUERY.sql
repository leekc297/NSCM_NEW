





/*
 * Program ID   : PR_SCP_XLS_EXCEL_BODY_QUERY
 * Description  : SCP SIMULATION EXCEL SHEET BODY QUERY
 * OutTable     :
 * Execute      : 
                 
  EXEC PR_SCP_XLS_EXCEL_BODY_QUERY  
                                                   @p_division_id   = 'EE'
                                                  ,@p_pgm_code      = 'XLSPSI05'
                                                  ,@p_parameter1    = ''--ACPN1034U-A1'  -- PLAN_START_YYYYMMDD
                                                  ,@p_parameter2    =''
                                                  ,@p_parameter3    =''
                                                  ,@p_parameter4    ='day'
                                                  ,@p_parameter5    =''  

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
 */

CREATE PROCEDURE [dbo].[PR_SCP_XLS_EXCEL_BODY_QUERY]
(
  @p_division_id   VARCHAR(10),
  @p_pgm_code      VARCHAR(40),
  @p_parameter1    VARCHAR(MAX)  ='',   -- CELL_ITEM_ID, ITEM_ID
  @p_parameter2    VARCHAR(MAX)  ='',   -- CELL_TYPE_GROUP_CODE
  @p_parameter3    VARCHAR(MAX)  ='',   -- PLANNER ID (AAAA,BCCC,CDDD,....) Delimeter는 (,)
  @p_parameter4    VARCHAR(MAX)  ='',   -- @p_day_week_flag(day/week)
  @p_parameter5    VARCHAR(MAX)  =''  
 )
AS
BEGIN

  -----------------------------------------------------------------------------
  -- ESS 외주 Line별 생산 Target 관련 OSP_YN로직 수정
  -- LINE NAME 조회시 SCM_MST_LINE_OSP의 정보도 가져오기 위해서.
  -- SCM_MST_LINE_SN_V로 대체 
  -----------------------------------------------------------------------------
  /*
        IF OBJECT_ID('tempdb..#tmp_SCM_MST_LINE_SN') IS NOT NULL	
          DROP TABLE #tmp_SCM_MST_LINE_SN

          SELECT *
            INTO #tmp_SCM_MST_LINE_SN
            FROM (
                  SELECT DIVISION_ID,LINE_ID,LINE_NAME,OPERATION_ID
                    FROM SCM_MST_LINE_SN Y WITH (NOLOCK) 
                  UNION ALL
                  SELECT DIVISION_ID,LINE_ID,LINE_NAME,OPERATION_ID
                    FROM SCM_MST_LINE_OSP  Y WITH (NOLOCK) 
                  ) X

  */
  	--PRINT @P_PGM_CODE + '--. ' +CONVERT(CHAR(23), GETDATE(), 21);
	--  * 2021.03.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가 - START
	DECLARE @p_plan_start_yyyymmdd  NVARCHAR(0008) = NULL;
	DECLARE @p_plan_type            NVARCHAR(4000) = 'MA';
	DECLARE @p_seq                  NVARCHAR(0008) = NULL;
	DECLARE @v_plan_id				NVARCHAR(0008) = NULL;
	DECLARE @eng_plan_id			NVARCHAR(0015) = NULL;

	DECLARE @v_plan_start_yyyymmdd  NVARCHAR(0008);
	DECLARE @v_plan_end_yyyymmdd    NVARCHAR(0008);
	DECLARE @v_plan_end_yyyymmdd_2    NVARCHAR(0008);
	
	DECLARE @v_seq                  NVARCHAR(0008)
	DECLARE @v_cols                 NVARCHAR(MAX);
	DECLARE @v_cols2                NVARCHAR(MAX);
	DECLARE @v_cols3                NVARCHAR(MAX);
	DECLARE @SQL                    NVARCHAR(MAX);

	DECLARE @v_frozen_end_yyyymmdd  NVARCHAR(0008);
	DECLARE @v_frozen_days          integer = 21;
	DECLARE @v_wcols                NVARCHAR(MAX);
	DECLARE @v_wcols2               NVARCHAR(MAX);
	DECLARE @v_wcols3               NVARCHAR(MAX);

	DECLARE @v_frozen_area_last_yyyymmdd NVARCHAR(0008) = '';
	--  * 2021.03.23   KSW           'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION 추가 - END

	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start
	DECLARE @p_create_to_yyyymmdd_1 NVARCHAR(0008);
	DECLARE @p_create_to_yyyymmdd_2 NVARCHAR(0008);

	--  Plan End Date
	DECLARE @v_pet_date		NVARCHAR(12) = '';
	DECLARE @v_bp_flag		NVARCHAR(8) = '';
	DECLARE @v_bp_days		INT = 0;
	DECLARE @v_bp_plan_end_yyyymmdd NVARCHAR(0008) = '';

	SELECT @v_pet_date = p.horizon_end_date,
		   @v_bp_flag  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then 'Y' else 'N' end),
		   @v_bp_days  = (case when DATEDIFF(DAY, p.plan_name, p.horizon_end_date) > 364 then DATEDIFF(DAY, p.plan_name, p.horizon_end_date) - 363 else 0 end)
	FROM   dbo.scm_mst_plan p WITH(NOLOCK)
	WHERE  p.division_id = @p_division_id
	AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
	;
	-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end

  -----------------------------------------
  -- XLSPSI01: 자동차 GLOBAL PSI SIMULATION
  -----------------------------------------
  IF @P_PGM_CODE = 'XLSPSI01' 
     BEGIN

	 -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start
	 SET @v_plan_start_yyyymmdd    = '';

	 SELECT  DISTINCT 
	          @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
		     ,@v_seq = SEQ
	   FROM DBO.SCP_XLS_PSI_GLOBAL WITH (NOLOCK)
	  WHERE DIVISION_ID = @p_division_id		-- 2022.03.21   KSW			  GM JV 반영
	  ;
	 

	 SET @p_create_to_yyyymmdd_1   = @v_plan_start_yyyymmdd;
	 SET @p_create_to_yyyymmdd_2 = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_to_yyyymmdd_1), 112);
	 -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end

      IF @p_parameter1 <> ''
        SET @p_parameter3 = @p_parameter1

	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - start
	  DECLARE @v_2year_cnt		INT = 0;
	  SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2;

	  IF @v_bp_flag = 'Y' AND @v_2year_cnt = 0
	  BEGIN
		 SET @v_bp_flag = 'N'
	  END
	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - end
      

      IF @v_bp_flag = 'N'
	  BEGIN
		  SELECT 
				 y.DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,y.OPERATION_GROUP
				,OPERATION_GROUP_NAME
				,y.CELL_ITEM_ID
				,y.ITEM_ID
				,y.NICK_NAME
				,CELL_QTY_PACK
				,TO_SITE
				,TO_SITE_DESCRIPTION
				,PROJECT_CODE
				,FROM_BOH_QTY
				,TO_BOH_QTY
				,INCOTERMS
				,FROM_SITE
				,FROM_SITE_DESCRIPTION
				,TRANSPORT_MODE
				,LT_DAY
				,YIELD
				,PROD_LINE
				,BOD_ID
				,GRO_STD_DIO 
				,MIN_STD_DIO 
				,MEASURE
				,MEASURE_LABEL
				,XLS_KEY1
				,XLS_KEY2
				,XLS_KEY3
				,XLS_KEY4
				,XLS_KEY5
				,XLS_ATTRIBUTE1
				,XLS_ATTRIBUTE2
				,XLS_ATTRIBUTE3
				,XLS_ATTRIBUTE4
				,XLS_ATTRIBUTE5
				,SORT_ORDER_NO
            
				,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
				,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
				,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
				,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
				,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
				,WQTY51,WQTY52            

				,y.CREATED_BY
				,y.CREATION_DATE
				,y.LAST_UPDATED_BY
				,y.LAST_UPDATE_DATE
				,y.ATTRIBUTE1
				,'''' + y.ATTRIBUTE3 AS ATTRIBUTE3		--ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			FROM (
				  SELECT DIVISION_ID
						,PLAN_START_YYYYMMDD
						,PLAN_TYPE
						,SEQ
						,OPERATION_GROUP
						,OPERATION_GROUP_NAME
						,CELL_ITEM_ID
						,ITEM_ID
						,NICK_NAME
						,CELL_QTY_PACK
						,TO_SITE
						,TO_SITE_DESCRIPTION
						,PROJECT_CODE
						,FROM_BOH_QTY
						,TO_BOH_QTY
						,INCOTERMS
						,FROM_SITE
						,FROM_SITE_DESCRIPTION
						,TRANSPORT_MODE
						-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 추가
						-- 변경전
						--,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
						,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN CONVERT(NVARCHAR,LT_DAY) ELSE '-' END) ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
							  ,YIELD
						,PROD_LINE
						,BOD_ID
						,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
						,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
						,MEASURE
						,MEASURE_LABEL
						,XLS_KEY1
						,XLS_KEY2
						,XLS_KEY3
						,XLS_KEY4
						,XLS_KEY5
						,XLS_ATTRIBUTE1
						,XLS_ATTRIBUTE2
						,XLS_ATTRIBUTE3
						,XLS_ATTRIBUTE4
						,XLS_ATTRIBUTE5
						,SORT_ORDER_NO
            
						,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
						,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
						,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
						,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
						,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
						,WQTY51,WQTY52
            

						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1
						,ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						,ATTRIBUTE10
						-- 정렬 가중치 조정(10000, 10010, 100020=> 1, 10000, 10000000, 240925)
						,(CASE WHEN Y.MEASURE IN ( 'PACK_CELL_BOH', 'PACK_CELL_EOH', 'PACK_CELL_BOH_HOLD') THEN 
								(SELECT CONVERT(BIGINT, MAX(X.XLS_KEY1)) * 10000 - 
									(CASE WHEN Y.MEASURE = 'PACK_CELL_BOH' THEN 15 
												WHEN Y.MEASURE = 'PACK_CELL_BOH_HOLD' THEN 10 ELSE 0 END) -- 2022.08.30   KSW	Cell 재고 개선건 - PACK_CELL_BOH_HOLD 추가
																								FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) 
																								WHERE X.DIVISION_ID = Y.DIVISION_ID	-- 2022.03.21 GM JV 반영	'81' --> @p_division_id
																								AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
																								AND X.OPERATION_GROUP = 'P' 
																								AND X.CELL_ITEM_ID    = Y.CELL_ITEM_ID
																								AND X.FROM_SITE       = Y.FROM_SITE
																								AND X.MEASURE         = 'PACK_CELL_EOH'
																								AND X.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
																								AND X.DIVISION_ID = @p_division_id  )
								ELSE (CASE WHEN Y.OPERATION_GROUP = 'P' THEN CONVERT(INT, XLS_KEY1) * 1
													ELSE CONVERT(BIGINT, XLS_KEY1) * 1000000 END) END) AS SORT_KEY

					FROM SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK)
					INNER JOIN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,',')) X
					ON Y.CELL_ITEM_ID = X.Value
				   WHERE 0 = 0 
					  AND DIVISION_ID   = @p_division_id
					  AND CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
					  --AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))		--INNER JOIN으로 변경 - 20231221
					  AND NOT MEASURE IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD', 'PACK_PROD_TOTAL')		-- Load Ratio 조회안되게 변경 - 2022.09.30										
					  AND NOT (OPERATION_GROUP = 'A' AND TO_SITE = '-' --AND FROM_SITE = 'A040-A' 					  
									  AND (SELECT  DBO.FN_GET_FINAL_ITEM('81', ITEM_ID, 'CELL_TYPE')) ='CP'
									) --... 1298 06/22/2023
					  /*
  					  Operation Cell
						Item ID : Prod
						To site : Null
						From Site : LGESOC Cell A0... (Company C100)
						인 Row를 삭제한다
					  */
				 ) Y
				 --2023.02.09   KKH			  XLSPSI01 pack cell 순서로 다시 정렬
				 LEFT JOIN DBO.SCP_MST_FINAL_ITEM B WITH (NOLOCK)
				 ON Y.ITEM_ID = B.ITEM_ID
				 AND Y.DIVISION_ID = B.DIVISION_ID				
				--WHERE  Y.CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))			--필요없는 구문으로 삭제 - 20231221
				ORDER BY  CELL_ITEM_ID, SORT_KEY, B.OPERATION_GROUP DESC
		  --ORDER BY  CELL_ITEM_ID,  SORT_KEY
		  ;
	  END

	  IF @v_bp_flag = 'Y'
	  BEGIN
		  SELECT DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				,OPERATION_GROUP
				,OPERATION_GROUP_NAME
				,CELL_ITEM_ID
				,ITEM_ID
				,NICK_NAME
				,CELL_QTY_PACK
				,TO_SITE
				,TO_SITE_DESCRIPTION
				,PROJECT_CODE
				,FROM_BOH_QTY
				,TO_BOH_QTY
				,INCOTERMS
				,FROM_SITE
				,FROM_SITE_DESCRIPTION
				,TRANSPORT_MODE
				,LT_DAY
				,YIELD
				,PROD_LINE
				,BOD_ID
				,GRO_STD_DIO 
				,MIN_STD_DIO 
				,MEASURE
				,MEASURE_LABEL
				,XLS_KEY1
				,XLS_KEY2
				,XLS_KEY3
				,XLS_KEY4
				,XLS_KEY5
				,XLS_ATTRIBUTE1
				,XLS_ATTRIBUTE2
				,XLS_ATTRIBUTE3
				,XLS_ATTRIBUTE4
				,XLS_ATTRIBUTE5
				,SORT_ORDER_NO
            
				,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
				,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
				,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
				,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
				,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
				,WQTY51,WQTY52        
			
				,WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
				,WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
				,WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82 
				,WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
				,WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
				,WQTY103,WQTY104 

				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,'''' + ATTRIBUTE3 AS ATTRIBUTE3		--ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			FROM (
				  SELECT 
						 Y1.DIVISION_ID
						,Y1.PLAN_START_YYYYMMDD
						,Y1.PLAN_TYPE
						,Y1.SEQ
						,Y1.OPERATION_GROUP
						,Y1.OPERATION_GROUP_NAME
						,Y1.CELL_ITEM_ID
						,Y1.ITEM_ID
						,Y1.NICK_NAME
						,Y1.CELL_QTY_PACK
						,Y1.TO_SITE
						,Y1.TO_SITE_DESCRIPTION
						,Y1.PROJECT_CODE
						,(CASE WHEN Y1.MEASURE = 'CELL_FORM_HOLD_AFTER' THEN Y1.FROM_BOH_QTY - Y2.FROM_BOH_QTY ELSE Y1.FROM_BOH_QTY END) AS FROM_BOH_QTY		-- KSE 2021.08.27 CELL_FORM_HOLD_AFTER MEASURE 일 경우 52주 이후 30주 SUM 값을 차감
						,Y1.TO_BOH_QTY
						,Y1.INCOTERMS
						,Y1.FROM_SITE
						,Y1.FROM_SITE_DESCRIPTION
						,Y1.TRANSPORT_MODE
						,Y1.LT_DAY
						,Y1.YIELD
						,Y1.PROD_LINE
						,Y1.BOD_ID
						,Y1.GRO_STD_DIO 
						,Y1.MIN_STD_DIO 
						,Y1.MEASURE
						,Y1.MEASURE_LABEL
						,Y1.XLS_KEY1
						,Y1.XLS_KEY2
						,Y1.XLS_KEY3
						,Y1.XLS_KEY4
						,Y1.XLS_KEY5
						,Y1.XLS_ATTRIBUTE1
						,Y1.XLS_ATTRIBUTE2
						,Y1.XLS_ATTRIBUTE3
						,Y1.XLS_ATTRIBUTE4
						,Y1.XLS_ATTRIBUTE5
						,Y1.SORT_ORDER_NO
            
						,Y1.WQTY01,Y1.WQTY02,Y1.WQTY03,Y1.WQTY04,Y1.WQTY05,Y1.WQTY06,Y1.WQTY07,Y1.WQTY08,Y1.WQTY09,Y1.WQTY10
						,Y1.WQTY11,Y1.WQTY12,Y1.WQTY13,Y1.WQTY14,Y1.WQTY15,Y1.WQTY16,Y1.WQTY17,Y1.WQTY18,Y1.WQTY19,Y1.WQTY20
						,Y1.WQTY21,Y1.WQTY22,Y1.WQTY23,Y1.WQTY24,Y1.WQTY25,Y1.WQTY26,Y1.WQTY27,Y1.WQTY28,Y1.WQTY29,Y1.WQTY30
						,Y1.WQTY31,Y1.WQTY32,Y1.WQTY33,Y1.WQTY34,Y1.WQTY35,Y1.WQTY36,Y1.WQTY37,Y1.WQTY38,Y1.WQTY39,Y1.WQTY40
						,Y1.WQTY41,Y1.WQTY42,Y1.WQTY43,Y1.WQTY44,Y1.WQTY45,Y1.WQTY46,Y1.WQTY47,Y1.WQTY48,Y1.WQTY49,Y1.WQTY50
						,Y1.WQTY51,Y1.WQTY52
			
						,Y2.WQTY01 AS WQTY53, Y2.WQTY02 AS WQTY54, Y2.WQTY03 AS WQTY55, Y2.WQTY04 AS WQTY56, Y2.WQTY05 AS WQTY57, Y2.WQTY06 AS WQTY58, Y2.WQTY07 AS WQTY59, Y2.WQTY08 AS WQTY60, Y2.WQTY09 AS WQTY61, Y2.WQTY10 AS WQTY62
						,Y2.WQTY11 AS WQTY63, Y2.WQTY12 AS WQTY64, Y2.WQTY13 AS WQTY65, Y2.WQTY14 AS WQTY66, Y2.WQTY15 AS WQTY67, Y2.WQTY16 AS WQTY68, Y2.WQTY17 AS WQTY69, Y2.WQTY18 AS WQTY70, Y2.WQTY19 AS WQTY71, Y2.WQTY20 AS WQTY72
						,Y2.WQTY21 AS WQTY73, Y2.WQTY22 AS WQTY74, Y2.WQTY23 AS WQTY75, Y2.WQTY24 AS WQTY76, Y2.WQTY25 AS WQTY77, Y2.WQTY26 AS WQTY78, Y2.WQTY27 AS WQTY79, Y2.WQTY28 AS WQTY80, Y2.WQTY29 AS WQTY81, Y2.WQTY30 AS WQTY82
						,Y2.WQTY31 AS WQTY83, Y2.WQTY32 AS WQTY84, Y2.WQTY33 AS WQTY85, Y2.WQTY34 AS WQTY86, Y2.WQTY35 AS WQTY87, Y2.WQTY36 AS WQTY88, Y2.WQTY37 AS WQTY89, Y2.WQTY38 AS WQTY90, Y2.WQTY39 AS WQTY91, Y2.WQTY40 AS WQTY92
						,Y2.WQTY41 AS WQTY93, Y2.WQTY42 AS WQTY94, Y2.WQTY43 AS WQTY95, Y2.WQTY44 AS WQTY96, Y2.WQTY45 AS WQTY97, Y2.WQTY46 AS WQTY98, Y2.WQTY47 AS WQTY99, Y2.WQTY48 AS WQTY100,Y2.WQTY49 AS WQTY101,Y2.WQTY50 AS WQTY102
						,Y2.WQTY51 AS WQTY103,Y2.WQTY52 AS WQTY104

						,Y1.CREATED_BY
						,Y1.CREATION_DATE
						,Y1.LAST_UPDATED_BY
						,Y1.LAST_UPDATE_DATE
						,Y1.ATTRIBUTE1
						,Y1.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						,Y1.ATTRIBUTE10
						,Y1.SORT_KEY

						,Y2.SORT_ORDER_NO AS SORT_ORDER_NO_2
						,Y2.XLS_KEY1      AS XLS_KEY1_2
					FROM (SELECT DIVISION_ID
								,PLAN_START_YYYYMMDD
								,PLAN_TYPE
								,SEQ
								,OPERATION_GROUP
								,OPERATION_GROUP_NAME
								,ISNULL(CELL_ITEM_ID, '-') AS CELL_ITEM_ID
								,ISNULL(ITEM_ID, '-') AS ITEM_ID
								,NICK_NAME
								,CELL_QTY_PACK
								,TO_SITE
								,TO_SITE_DESCRIPTION
								,PROJECT_CODE
								,FROM_BOH_QTY
								,TO_BOH_QTY
								,INCOTERMS
								,FROM_SITE
								,FROM_SITE_DESCRIPTION
								,TRANSPORT_MODE
								-- PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사 LT 추가
								-- 변경전
								--,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
								,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN CONVERT(NVARCHAR,LT_DAY) ELSE '-' END) ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
									  ,YIELD
								,PROD_LINE
								,BOD_ID
								,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
								,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
								,MEASURE
								,MEASURE_LABEL
								,XLS_KEY1
								,XLS_KEY2
								,XLS_KEY3
								,XLS_KEY4
								,XLS_KEY5
								,XLS_ATTRIBUTE1
								,XLS_ATTRIBUTE2
								,XLS_ATTRIBUTE3
								,XLS_ATTRIBUTE4
								,XLS_ATTRIBUTE5
								,SORT_ORDER_NO
            
								,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
								,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
								,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
								,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
								,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
								,WQTY51,WQTY52
            

								,CREATED_BY
								,CREATION_DATE
								,LAST_UPDATED_BY
								,LAST_UPDATE_DATE
								,ATTRIBUTE1
								,ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								,ATTRIBUTE10

								-- 정렬 가중치 조정(10000, 10010, 100020=> 1, 10000, 10000000, 240925)
								,(CASE WHEN Y.MEASURE IN ( 'PACK_CELL_BOH', 'PACK_CELL_EOH', 'PACK_CELL_BOH_HOLD') THEN 
									   (SELECT CONVERT(BIGINT, MAX(X.XLS_KEY1)) * 10000 - 
											(CASE WHEN Y.MEASURE = 'PACK_CELL_BOH' THEN 15 
														WHEN Y.MEASURE = 'PACK_CELL_BOH_HOLD' THEN 10 ELSE 0 END) -- 2022.08.30   KSW	Cell 재고 개선건 - PACK_CELL_BOH_HOLD 추가
										FROM SCP_XLS_PSI_GLOBAL X  WITH (NOLOCK) 
										WHERE X.DIVISION_ID = Y.DIVISION_ID	-- 2022.03.21 GM JV 반영	'81' --> @p_division_id
										AND X.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD
										AND X.OPERATION_GROUP = 'P' 
										AND X.CELL_ITEM_ID    = Y.CELL_ITEM_ID
										AND X.FROM_SITE       = Y.FROM_SITE
										AND X.MEASURE         = 'PACK_CELL_EOH'
										AND X.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
										AND X.DIVISION_ID = @p_division_id  )
										ELSE (CASE WHEN Y.OPERATION_GROUP = 'P' THEN CONVERT(INT, XLS_KEY1) * 1
															ELSE CONVERT(BIGINT, XLS_KEY1) * 1000000 END) END) AS SORT_KEY

							FROM SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK)
						   WHERE 0 = 0 
							  AND DIVISION_ID = @p_division_id	-- 2022.03.21 GM JV 반영	'81' --> @p_division_id
							  AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							  AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))
							  AND CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1							  
						 ) Y1
					INNER JOIN 
						 (SELECT DIVISION_ID
								,PLAN_START_YYYYMMDD
								,PLAN_TYPE
								,SEQ
								,OPERATION_GROUP
								,OPERATION_GROUP_NAME
								,ISNULL(CELL_ITEM_ID, '-') AS CELL_ITEM_ID
								,ISNULL(ITEM_ID, '-') AS ITEM_ID
								,NICK_NAME
								,CELL_QTY_PACK
								,TO_SITE
								,TO_SITE_DESCRIPTION
								,PROJECT_CODE
								,FROM_BOH_QTY
								,TO_BOH_QTY
								,INCOTERMS
								,FROM_SITE
								,FROM_SITE_DESCRIPTION
								,TRANSPORT_MODE
								,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
									  ,YIELD
								,PROD_LINE
								,BOD_ID
								,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
								,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
								,MEASURE
								,MEASURE_LABEL
								,XLS_KEY1
								,XLS_KEY2
								,XLS_KEY3
								,XLS_KEY4
								,XLS_KEY5
								,XLS_ATTRIBUTE1
								,XLS_ATTRIBUTE2
								,XLS_ATTRIBUTE3
								,XLS_ATTRIBUTE4
								,XLS_ATTRIBUTE5
								,SORT_ORDER_NO
            
								,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
								,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
								,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
								,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
								,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
								,WQTY51,WQTY52
            

								--,CREATED_BY
								--,CREATION_DATE
								--,LAST_UPDATED_BY
								--,LAST_UPDATE_DATE
								--,ATTRIBUTE1
								--,ATTRIBUTE10
							FROM SCP_XLS_PSI_GLOBAL Y WITH (NOLOCK)
						   WHERE 0 = 0 
							  AND DIVISION_ID = @p_division_id	-- 2022.03.21 GM JV 반영	'81' --> @p_division_id
							  AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
							  AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))
							  AND CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2
						 ) Y2
					ON Y1.DIVISION_ID         = Y2.DIVISION_ID
				   AND Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
				 --WHERE Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
				   AND Y1.PLAN_TYPE           = Y2.PLAN_TYPE
				   AND Y1.SEQ                 = Y2.SEQ
				   AND Y1.OPERATION_GROUP     = Y2.OPERATION_GROUP
				   AND Y1.CELL_ITEM_ID        = Y2.CELL_ITEM_ID
				   AND Y1.ITEM_ID             = Y2.ITEM_ID
				   AND Y1.TO_SITE             = Y2.TO_SITE
				   AND Y1.PROJECT_CODE        = Y2.PROJECT_CODE
				   AND Y1.INCOTERMS           = Y2.INCOTERMS
				   AND Y1.FROM_SITE           = Y2.FROM_SITE
				   AND Y1.TRANSPORT_MODE      = Y2.TRANSPORT_MODE
				   AND Y1.PROD_LINE           = Y2.PROD_LINE
				   AND Y1.BOD_ID              = Y2.BOD_ID
				   AND Y1.MEASURE             = Y2.MEASURE
				   AND Y1.SORT_ORDER_NO       = Y2.SORT_ORDER_NO
				   AND NOT Y1.MEASURE IN ('PACK_PROD_LOAD', 'CELL_PROD_LOAD', 'PACK_PROD_TOTAL')		-- Load Ratio 조회안되게 변경 - 2022.09.30				   
				   AND NOT (Y1.OPERATION_GROUP = 'A' AND Y1.TO_SITE = '-'  -- 사업계획 수립에 따른 시뮬레이터 생산계획Bucket 확장 적용::2023-08-03(KSK)	  
								   AND (SELECT  DBO.FN_GET_FINAL_ITEM('81', Y1.ITEM_ID, 'CELL_TYPE')) ='CP'
								   )
			   ) X
		  ORDER BY CELL_ITEM_ID ASC, SORT_KEY ASC, SORT_ORDER_NO ASC
		  ;
	  END
	  -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end

     END

  -----------------------------------------
  -- XLSPSI02:소형 PACK PSI SIMULATION
  -----------------------------------------  
  IF @P_PGM_CODE = 'XLSPSI02' 
	BEGIN

		DECLARE @p_create_from_yyyymmdd  NVARCHAR(0008) = NULL;
		DECLARE @p_create_to_yyyymmdd  NVARCHAR(0008) = NULL;
	
	  -- 2022.03.24 KSW Daily & Monthly Bucket 개선적용
	    SELECT TOP 1 @p_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
		  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
		;
		
		--SELECT TOP 1 @p_create_from_yyyymmdd = MAX(CREATE_FROM_YYYYMMDD)
		--  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)		;
		-- 20231030 강현준. 계획이 돌지 않음에도 현재 날짜 기준으로 조회될 수 있도록 조치함.  
		SET @p_create_from_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112);	


		SELECT TOP 1 @p_plan_type = PLAN_TYPE
			   ,@p_seq            = SEQ
		  FROM SCP_XLS_PSI_GLOBAL_SMALL_PACK WITH (NOLOCK)
		 WHERE PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		 ;

		DECLARE @v_dayend_yyyymmdd		NVARCHAR(20) = @p_parameter5;
		DECLARE @v_day_cols				NVARCHAR(4000) = '';
		DECLARE @v_day_cols_N			NVARCHAR(MAX) = '';
		DECLARE @v_day_cols_O			NVARCHAR(MAX) = '';

		-- Dayily End 일자를 월 말일로 조정한다.
		DECLARE @v_daily_last_yyyymmdd	NVARCHAR(0008) = '';

		-- 다음일자가 1일 아니면
		SELECT @v_daily_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,31,CONVERT(DATETIME,(LEFT(@v_dayend_yyyymmdd, 6) + '01'),112)),112)
		SELECT @v_daily_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(LEFT(@v_daily_last_yyyymmdd, 6) + '01'),112)),112)

	--	select @v_daily_last_yyyymmdd		;-----------이달 말..일...

		-- Daily 컬럼
		SELECT @v_day_cols = @v_day_cols + 'QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3) + ', '
			, @v_day_cols_N = @v_day_cols_N + 'BB.QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3) + ' AS '+'QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3)+'N, '
			, @v_day_cols_O = @v_day_cols_O + 'AA.QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3) + ' AS '+'QTY' + RIGHT('00' + CONVERT(VARCHAR, X.R_NUM), 3)+'O, '
		FROM (
				SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
						,C.BASIS_YYYYMMDD AS E_YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
					AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
					--AND C.BASIS_YYYYMMDD <=  @v_daily_last_yyyymmdd
					AND C.BASIS_YYYYMMDD < CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)		-- 52주 전체로 변경 :: 2022.05.03
			) X		;
					
--SELECT @v_day_cols --QTY001, QTY002, QTY003,~~~ , QTY363, QTY364, 

--	SELECT  @v_day_cols_N; --QTY001 AS QTY001N, QTY002 AS QTY002N, ~~ , QTY363 AS QTY363N, QTY364 AS QTY364N, 
--------------------------------------------------------------------------------------------------------------------------	
--------------------------------------------------------------------------------------------------------------------------


		-- Monthly 컬럼
		--DECLARE @v_plan_end_yyyymmdd	NVARCHAR(8) = '';
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
		
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;
		SELECT @p_create_to_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_create_from_yyyymmdd),112)),112) ;


		IF @v_bp_flag = 'N'
		BEGIN

			INSERT @v_tbl_month
			SELECT *
				FROM (
					SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS E_YYYYMMDD, CONVERT(INT, C.CALENDAR_YYYY) AS C_YEAR, CONVERT(INT, C.CALENDAR_MONTH) AS C_MONTH
					FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
					WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd--------------------
						AND C.BASIS_YYYYMMDD <  @v_plan_end_yyyymmdd
--							AND C.BASIS_YYYYMMDD <  @p_create_to_yyyymmdd
					) X
				WHERE X.E_YYYYMMDD > @v_daily_last_yyyymmdd------------다음달 1일 부터 364일 후 까지...
			;

			SELECT @v_tbl_cnt = COUNT(*) FROM (SELECT DISTINCT C_YEAR, C_MONTH FROM @v_tbl_month WHERE YYYYMMDD <  @v_plan_end_yyyymmdd) X;
			SELECT TOP 1 @v_curr_year = C_YEAR, @v_curr_month = C_MONTH FROM @v_tbl_month  WHERE YYYYMMDD <  @v_plan_end_yyyymmdd;

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
			SET @SQL = @SQL + '																													WHERE A.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.PLAN_TYPE           = ''' + @p_plan_type + '''';
			SET @SQL = @SQL + '																													  AND A.SEQ                 = ''' + @p_seq + '''';
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
			SET @SQL = @SQL + '            AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND PLAN_TYPE           = ''' + @p_plan_type + '''';
			SET @SQL = @SQL + '            AND SEQ                 = ''' + @p_seq + '''';
			SET @SQL = @SQL + '            AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(''' + @p_parameter3 + ''','',''))';
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

			--SET @SQL = @SQL + 'ORDER BY CELL_ITEM_ID, ORDNO, CONVERT(INT, XLS_KEY1)';            
			SET @SQL = @SQL + 'ORDER BY CELL_ITEM_ID, OPERATION_GROUP DESC, ORDNO, ITEM_ID, (CASE WHEN (FROM_SITE = ''-''  AND MEASURE LIKE ''CELL%'' ) THEN ''-'' ELSE FROM_SITE END), TO_SITE DESC, PROJECT_CODE, INCOTERMS, SORT_ORDER_NO';
		END

		IF @v_bp_flag = 'Y'
		BEGIN

			INSERT @v_tbl_month
			SELECT *
				FROM (
					SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS E_YYYYMMDD, CONVERT(INT, C.CALENDAR_YYYY) AS C_YEAR, CONVERT(INT, C.CALENDAR_MONTH) AS C_MONTH
					FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
					WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd--------------------
						--AND C.BASIS_YYYYMMDD <  @v_plan_end_yyyymmdd
						AND C.BASIS_YYYYMMDD <  @p_create_to_yyyymmdd
					) X
				WHERE X.E_YYYYMMDD > @v_daily_last_yyyymmdd------------다음달 1일 부터 364일 후 까지...
			;

			SELECT @v_tbl_cnt = COUNT(*) FROM (SELECT DISTINCT C_YEAR, C_MONTH FROM @v_tbl_month WHERE YYYYMMDD <  @p_create_to_yyyymmdd) X;
			SELECT TOP 1 @v_curr_year = C_YEAR, @v_curr_month = C_MONTH FROM @v_tbl_month  WHERE YYYYMMDD <  @p_create_to_yyyymmdd;

			WHILE (@v_lp < 12)------@v_tbl_cnt
			BEGIN
				SET @v_month_tmp = '';

				SELECT @v_month_tmp = @v_month_tmp + 'QTY' + RIGHT('00' + CONVERT(VARCHAR, DAY_NUM), 3) + '+' 
					FROM @v_tbl_month 
					WHERE C_YEAR  = @v_curr_year
					AND C_MONTH = @v_curr_month AND YYYYMMDD <  @v_plan_end_yyyymmdd
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
				AND C_MONTH = @v_curr_month and  YYYYMMDD <  @p_create_to_yyyymmdd AND @p_create_from_yyyymmdd <= YYYYMMDD;
				
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
--			IF @v_bp_flag = 'Y'
--			BEGIN	
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
					,AA.SORT_ORDER_NO         ,AA.LAST_QTY ';
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
			SET @SQL = @SQL + '																													WHERE A.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.CREATE_FROM_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.PLAN_TYPE           = ''' + @p_plan_type + '''';
			SET @SQL = @SQL + '																													  AND A.SEQ                 = ''' + @p_seq + '''';
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
			SET @SQL = @SQL + '            AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND CREATE_FROM_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND PLAN_TYPE           = ''' + @p_plan_type + '''';
			SET @SQL = @SQL + '            AND SEQ                 = ''' + @p_seq + '''';
			SET @SQL = @SQL + '            AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(''' + @p_parameter3 + ''','',''))';
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
--			IF @v_bp_flag = 'Y'
--			BEGIN
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
			SET @SQL = @SQL + '																													WHERE A.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + '''';
			SET @SQL = @SQL + '																													  AND A.PLAN_TYPE           = ''' + @p_plan_type + '''';
			SET @SQL = @SQL + '																													  AND A.SEQ                 = ''' + @p_seq + '''';
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
			SET @SQL = @SQL + '            AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND CREATE_FROM_YYYYMMDD = ''' + @p_create_from_yyyymmdd + '''';
			SET @SQL = @SQL + '            AND PLAN_TYPE           = ''' + @p_plan_type + '''';
			SET @SQL = @SQL + '            AND SEQ                 = ''' + @p_seq + '''';
			SET @SQL = @SQL + '            AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(''' + @p_parameter3 + ''','',''))';
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

			SET @SQL = @SQL + 'ORDER BY AA.CELL_ITEM_ID, AA.OPERATION_GROUP DESC, /*AA.ORDNO,*/ AA.ITEM_ID, (CASE WHEN (AA.FROM_SITE = ''-''  AND AA.MEASURE LIKE ''CELL%'' ) THEN ''-'' ELSE AA.FROM_SITE END), AA.TO_SITE DESC, AA.PROJECT_CODE, AA.INCOTERMS, AA.SORT_ORDER_NO';
--			END
		END

		EXEC(@SQL);

    END

  -----------------------------------------    
  -- XLSPSI03:소형 CELL PSI SIMULATION
  -----------------------------------------  
  IF @P_PGM_CODE = 'XLSPSI03' 
    BEGIN

      -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start
	 SET @v_plan_start_yyyymmdd    = '';

	 SELECT  DISTINCT 
	          @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
		     ,@v_seq = SEQ
	   FROM DBO.SCP_XLS_PSI_GLOBAL_SMALL_CELL WITH (NOLOCK)
	  ;
	


	 SET @p_create_to_yyyymmdd_1   = @v_plan_start_yyyymmdd;
	 SET @p_create_to_yyyymmdd_2 = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_to_yyyymmdd_1), 112);
	 -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end

	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - start
	  SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2;

	  IF @v_bp_flag = 'Y' AND @v_2year_cnt = 0
	  BEGIN
		 SET @v_bp_flag = 'N'
	  END
	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - end


      IF @v_bp_flag = 'N'
	  BEGIN
		  SELECT X.DIVISION_ID
				,X.PLAN_START_YYYYMMDD
				,X.PLAN_TYPE
				,X.SEQ
				,(SELECT TOP 1 Y.SEGMENT2 
					FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL Y WITH (NOLOCK)  
				   WHERE Y.LOOKUP_TYPE  = 'CELL_TYPE_GROUP_CODE'   
					  AND Y.VALID_YN    = 'Y'  
					  AND Y.SEGMENT1    = X.CELL_TYPE_GROUP_CODE
				  ) AS CELL_TYPE_GROUP_CODE
				,X.CELL_ITEM_ID
				,X.NICK_NAME
				,X.MEASURE
				,X.MEASURE_LABEL
				,X.SITE_ID
				,X.SITE_DESCRIPTION
				,X.PROD_LINE
				 ,(SELECT TOP 1  Y.LINE_NAME 
					FROM SCM_MST_LINE_V Y WITH (NOLOCK) 
				   WHERE Y.LINE_ID    = X.PROD_LINE 
					 AND Y.DIVISION_ID= X.DIVISION_ID
					 AND Y.OPERATION_ID IN ('A3000','A9000')
             
				  ) AS PROD_LINE_NAME
				,X.YIELD
				,X.LT_WEEK
				,X.ATTRIBUTE3 AS LT_DAY
				,X.ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
				,X.ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
				,X.BOH
				,X.XLS_KEY1
				,X.SORT_ORDER_NO

            
				,X.WQTY01 ,X.WQTY02 ,X.WQTY03 ,X.WQTY04 ,X.WQTY05 ,X.WQTY06 ,X.WQTY07 ,X.WQTY08 ,X.WQTY09 ,X.WQTY10
				,X.WQTY11 ,X.WQTY12 ,X.WQTY13 ,X.WQTY14 ,X.WQTY15 ,X.WQTY16 ,X.WQTY17 ,X.WQTY18 ,X.WQTY19 ,X.WQTY20
				,X.WQTY21 ,X.WQTY22 ,X.WQTY23 ,X.WQTY24 ,X.WQTY25 ,X.WQTY26 ,X.WQTY27 ,X.WQTY28 ,X.WQTY29 ,X.WQTY30
				,X.WQTY31 ,X.WQTY32 ,X.WQTY33 ,X.WQTY34 ,X.WQTY35 ,X.WQTY36 ,X.WQTY37 ,X.WQTY38 ,X.WQTY39 ,X.WQTY40
				,X.WQTY41 ,X.WQTY42 ,X.WQTY43 ,X.WQTY44 ,X.WQTY45 ,X.WQTY46 ,X.WQTY47 ,X.WQTY48 ,X.WQTY49 ,X.WQTY50
				,X.WQTY51 ,X.WQTY52
				,X.CREATED_BY
				,X.CREATION_DATE
				,X.LAST_UPDATED_BY
				,X.LAST_UPDATE_DATE
				--,ATTRIBUTE1
				--,ATTRIBUTE10
			FROM DBO.SCP_XLS_PSI_GLOBAL_SMALL_CELL  X WITH (NOLOCK)
		   WHERE 0 = 0 
			  AND X.DIVISION_ID           = @p_division_id
			  AND X.CREATE_FROM_YYYYMMDD  = @p_create_to_yyyymmdd_1
			  AND (X.CELL_TYPE_GROUP_CODE = @p_parameter2 OR X.CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,',')))
		  ORDER BY CONVERT(INT, XLS_KEY1)
		  ;
	  END

      IF @v_bp_flag = 'Y'
	  BEGIN
		  SELECT X.DIVISION_ID
				,X.PLAN_START_YYYYMMDD
				,X.PLAN_TYPE
				,X.SEQ
				,X.CELL_TYPE_GROUP_CODE
				,X.CELL_ITEM_ID
				,X.NICK_NAME
				,X.MEASURE
				,X.MEASURE_LABEL
				,X.SITE_ID
				,X.SITE_DESCRIPTION
				,X.PROD_LINE
				,X.PROD_LINE_NAME
				,X.YIELD
				,X.LT_WEEK
				,X.LT_DAY
				,X.GRO_STD_DIO
				,X.MIN_STD_DIO
				,X.BOH
				,X.XLS_KEY1
				,X.SORT_ORDER_NO
            
				,X.WQTY01 ,X.WQTY02 ,X.WQTY03 ,X.WQTY04 ,X.WQTY05 ,X.WQTY06 ,X.WQTY07 ,X.WQTY08 ,X.WQTY09 ,X.WQTY10
				,X.WQTY11 ,X.WQTY12 ,X.WQTY13 ,X.WQTY14 ,X.WQTY15 ,X.WQTY16 ,X.WQTY17 ,X.WQTY18 ,X.WQTY19 ,X.WQTY20
				,X.WQTY21 ,X.WQTY22 ,X.WQTY23 ,X.WQTY24 ,X.WQTY25 ,X.WQTY26 ,X.WQTY27 ,X.WQTY28 ,X.WQTY29 ,X.WQTY30
				,X.WQTY31 ,X.WQTY32 ,X.WQTY33 ,X.WQTY34 ,X.WQTY35 ,X.WQTY36 ,X.WQTY37 ,X.WQTY38 ,X.WQTY39 ,X.WQTY40
				,X.WQTY41 ,X.WQTY42 ,X.WQTY43 ,X.WQTY44 ,X.WQTY45 ,X.WQTY46 ,X.WQTY47 ,X.WQTY48 ,X.WQTY49 ,X.WQTY50
				,X.WQTY51 ,X.WQTY52

				,X.WQTY53, X.WQTY54, X.WQTY55, X.WQTY56, X.WQTY57, X.WQTY58, X.WQTY59, X.WQTY60, X.WQTY61, X.WQTY62 
				,X.WQTY63, X.WQTY64, X.WQTY65, X.WQTY66, X.WQTY67, X.WQTY68, X.WQTY69, X.WQTY70, X.WQTY71, X.WQTY72 
				,X.WQTY73, X.WQTY74, X.WQTY75, X.WQTY76, X.WQTY77, X.WQTY78, X.WQTY79, X.WQTY80, X.WQTY81, X.WQTY82 
				,X.WQTY83, X.WQTY84, X.WQTY85, X.WQTY86, X.WQTY87, X.WQTY88, X.WQTY89, X.WQTY90, X.WQTY91, X.WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
				,X.WQTY93, X.WQTY94, X.WQTY95, X.WQTY96, X.WQTY97, X.WQTY98, X.WQTY99, X.WQTY100, X.WQTY101,X.WQTY102
				,X.WQTY103, X.WQTY104 

				,X.CREATED_BY
				,X.CREATION_DATE
				,X.LAST_UPDATED_BY
				,X.LAST_UPDATE_DATE
			FROM (
				  SELECT Y1.DIVISION_ID
						,Y1.PLAN_START_YYYYMMDD
						,Y1.PLAN_TYPE
						,Y1.SEQ
						,Y1.CELL_TYPE_GROUP_CODE
						,Y1.CELL_ITEM_ID
						,Y1.NICK_NAME
						,Y1.MEASURE
						,Y1.MEASURE_LABEL
						,Y1.SITE_ID
						,Y1.SITE_DESCRIPTION
						,Y1.PROD_LINE
						,Y1.PROD_LINE_NAME
						,Y1.YIELD
						,Y1.LT_WEEK
						,Y1.LT_DAY
						,Y1.GRO_STD_DIO
						,Y1.MIN_STD_DIO
						,Y1.BOH
						,Y1.XLS_KEY1
						,Y1.SORT_ORDER_NO
            
						,Y1.WQTY01,Y1.WQTY02,Y1.WQTY03,Y1.WQTY04,Y1.WQTY05,Y1.WQTY06,Y1.WQTY07,Y1.WQTY08,Y1.WQTY09,Y1.WQTY10
						,Y1.WQTY11,Y1.WQTY12,Y1.WQTY13,Y1.WQTY14,Y1.WQTY15,Y1.WQTY16,Y1.WQTY17,Y1.WQTY18,Y1.WQTY19,Y1.WQTY20
						,Y1.WQTY21,Y1.WQTY22,Y1.WQTY23,Y1.WQTY24,Y1.WQTY25,Y1.WQTY26,Y1.WQTY27,Y1.WQTY28,Y1.WQTY29,Y1.WQTY30
						,Y1.WQTY31,Y1.WQTY32,Y1.WQTY33,Y1.WQTY34,Y1.WQTY35,Y1.WQTY36,Y1.WQTY37,Y1.WQTY38,Y1.WQTY39,Y1.WQTY40
						,Y1.WQTY41,Y1.WQTY42,Y1.WQTY43,Y1.WQTY44,Y1.WQTY45,Y1.WQTY46,Y1.WQTY47,Y1.WQTY48,Y1.WQTY49,Y1.WQTY50
						,Y1.WQTY51,Y1.WQTY52

						,Y2.WQTY01 AS WQTY53, Y2.WQTY02 AS WQTY54, Y2.WQTY03 AS WQTY55, Y2.WQTY04 AS WQTY56, Y2.WQTY05 AS WQTY57, Y2.WQTY06 AS WQTY58, Y2.WQTY07 AS WQTY59, Y2.WQTY08 AS WQTY60, Y2.WQTY09 AS WQTY61, Y2.WQTY10 AS WQTY62
						,Y2.WQTY11 AS WQTY63, Y2.WQTY12 AS WQTY64, Y2.WQTY13 AS WQTY65, Y2.WQTY14 AS WQTY66, Y2.WQTY15 AS WQTY67, Y2.WQTY16 AS WQTY68, Y2.WQTY17 AS WQTY69, Y2.WQTY18 AS WQTY70, Y2.WQTY19 AS WQTY71, Y2.WQTY20 AS WQTY72
						,Y2.WQTY21 AS WQTY73, Y2.WQTY22 AS WQTY74, Y2.WQTY23 AS WQTY75, Y2.WQTY24 AS WQTY76, Y2.WQTY25 AS WQTY77, Y2.WQTY26 AS WQTY78, Y2.WQTY27 AS WQTY79, Y2.WQTY28 AS WQTY80, Y2.WQTY29 AS WQTY81, Y2.WQTY30 AS WQTY82
						,Y2.WQTY31 AS WQTY83, Y2.WQTY32 AS WQTY84, Y2.WQTY33 AS WQTY85, Y2.WQTY34 AS WQTY86, Y2.WQTY35 AS WQTY87, Y2.WQTY36 AS WQTY88, Y2.WQTY37 AS WQTY89, Y2.WQTY38 AS WQTY90, Y2.WQTY39 AS WQTY91, Y2.WQTY40 AS WQTY92
						,Y2.WQTY41 AS WQTY93, Y2.WQTY42 AS WQTY94, Y2.WQTY43 AS WQTY95, Y2.WQTY44 AS WQTY96, Y2.WQTY45 AS WQTY97, Y2.WQTY46 AS WQTY98, Y2.WQTY47 AS WQTY99, Y2.WQTY48 AS WQTY100,Y2.WQTY49 AS WQTY101,Y2.WQTY50 AS WQTY102
						,Y2.WQTY51 AS WQTY103,Y2.WQTY52 AS WQTY104

						,Y1.CREATED_BY
						,Y1.CREATION_DATE
						,Y1.LAST_UPDATED_BY
						,Y1.LAST_UPDATE_DATE

						,Y2.SORT_ORDER_NO AS SORT_ORDER_NO_2
						,Y2.XLS_KEY1      AS XLS_KEY1_2
					FROM (
						  SELECT X.DIVISION_ID
								,X.PLAN_START_YYYYMMDD
								,X.PLAN_TYPE
								,X.SEQ
								,(SELECT TOP 1 Y.SEGMENT2 
									FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL Y WITH (NOLOCK)  
								   WHERE Y.LOOKUP_TYPE  = 'CELL_TYPE_GROUP_CODE'   
									  AND Y.VALID_YN    = 'Y'  
									  AND Y.SEGMENT1    = X.CELL_TYPE_GROUP_CODE
								  ) AS CELL_TYPE_GROUP_CODE
								,X.CELL_ITEM_ID
								,X.NICK_NAME
								,X.MEASURE
								,X.MEASURE_LABEL
								,X.SITE_ID
								,X.SITE_DESCRIPTION
								,X.PROD_LINE
								 ,(SELECT TOP 1  Y.LINE_NAME 
									FROM SCM_MST_LINE_V Y WITH (NOLOCK) 
								   WHERE Y.LINE_ID    = X.PROD_LINE 
									 AND Y.DIVISION_ID= X.DIVISION_ID
									 AND Y.OPERATION_ID IN ('A3000','A9000')
             
								  ) AS PROD_LINE_NAME
								,X.YIELD
								,X.LT_WEEK
								,X.ATTRIBUTE3 AS LT_DAY
								,X.ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
								,X.ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
								,X.BOH
								,X.XLS_KEY1
								,X.SORT_ORDER_NO

            
								,X.WQTY01 ,X.WQTY02 ,X.WQTY03 ,X.WQTY04 ,X.WQTY05 ,X.WQTY06 ,X.WQTY07 ,X.WQTY08 ,X.WQTY09 ,X.WQTY10
								,X.WQTY11 ,X.WQTY12 ,X.WQTY13 ,X.WQTY14 ,X.WQTY15 ,X.WQTY16 ,X.WQTY17 ,X.WQTY18 ,X.WQTY19 ,X.WQTY20
								,X.WQTY21 ,X.WQTY22 ,X.WQTY23 ,X.WQTY24 ,X.WQTY25 ,X.WQTY26 ,X.WQTY27 ,X.WQTY28 ,X.WQTY29 ,X.WQTY30
								,X.WQTY31 ,X.WQTY32 ,X.WQTY33 ,X.WQTY34 ,X.WQTY35 ,X.WQTY36 ,X.WQTY37 ,X.WQTY38 ,X.WQTY39 ,X.WQTY40
								,X.WQTY41 ,X.WQTY42 ,X.WQTY43 ,X.WQTY44 ,X.WQTY45 ,X.WQTY46 ,X.WQTY47 ,X.WQTY48 ,X.WQTY49 ,X.WQTY50
								,X.WQTY51 ,X.WQTY52
								,X.CREATED_BY
								,X.CREATION_DATE
								,X.LAST_UPDATED_BY
								,X.LAST_UPDATE_DATE
								--,ATTRIBUTE1
								--,ATTRIBUTE10
							FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL  X WITH (NOLOCK)
						   WHERE 0 = 0 
							  AND X.DIVISION_ID           = @p_division_id
							  AND X.PLAN_START_YYYYMMDD     = @v_plan_start_yyyymmdd
							  AND X.CREATE_FROM_YYYYMMDD    = @p_create_to_yyyymmdd_1
							  AND (X.CELL_TYPE_GROUP_CODE = @p_parameter2 OR X.CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,',')))
						 ) Y1
					INNER JOIN 
						 (SELECT X.DIVISION_ID
								,X.PLAN_START_YYYYMMDD
								,X.PLAN_TYPE
								,X.SEQ
								,(SELECT TOP 1 Y.SEGMENT2 
									FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL Y WITH (NOLOCK)  
								   WHERE Y.LOOKUP_TYPE  = 'CELL_TYPE_GROUP_CODE'   
									  AND Y.VALID_YN    = 'Y'  
									  AND Y.SEGMENT1    = X.CELL_TYPE_GROUP_CODE
								  ) AS CELL_TYPE_GROUP_CODE
								,X.CELL_ITEM_ID
								,X.NICK_NAME
								,X.MEASURE
								,X.MEASURE_LABEL
								,X.SITE_ID
								,X.SITE_DESCRIPTION
								,X.PROD_LINE
								 ,(SELECT TOP 1  Y.LINE_NAME 
									FROM SCM_MST_LINE_V Y WITH (NOLOCK) 
								   WHERE Y.LINE_ID    = X.PROD_LINE 
									 AND Y.DIVISION_ID= X.DIVISION_ID
									 AND Y.OPERATION_ID IN ('A3000','A9000')
             
								  ) AS PROD_LINE_NAME
								,X.YIELD
								,X.LT_WEEK
								,X.ATTRIBUTE3 AS LT_DAY
								,X.ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
								,X.ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
								,X.BOH
								,X.XLS_KEY1
								,X.SORT_ORDER_NO

            
								,X.WQTY01 ,X.WQTY02 ,X.WQTY03 ,X.WQTY04 ,X.WQTY05 ,X.WQTY06 ,X.WQTY07 ,X.WQTY08 ,X.WQTY09 ,X.WQTY10
								,X.WQTY11 ,X.WQTY12 ,X.WQTY13 ,X.WQTY14 ,X.WQTY15 ,X.WQTY16 ,X.WQTY17 ,X.WQTY18 ,X.WQTY19 ,X.WQTY20
								,X.WQTY21 ,X.WQTY22 ,X.WQTY23 ,X.WQTY24 ,X.WQTY25 ,X.WQTY26 ,X.WQTY27 ,X.WQTY28 ,X.WQTY29 ,X.WQTY30
								,X.WQTY31 ,X.WQTY32 ,X.WQTY33 ,X.WQTY34 ,X.WQTY35 ,X.WQTY36 ,X.WQTY37 ,X.WQTY38 ,X.WQTY39 ,X.WQTY40
								,X.WQTY41 ,X.WQTY42 ,X.WQTY43 ,X.WQTY44 ,X.WQTY45 ,X.WQTY46 ,X.WQTY47 ,X.WQTY48 ,X.WQTY49 ,X.WQTY50
								,X.WQTY51 ,X.WQTY52
								,X.CREATED_BY
								,X.CREATION_DATE
								,X.LAST_UPDATED_BY
								,X.LAST_UPDATE_DATE
								--,ATTRIBUTE1
								--,ATTRIBUTE10
							FROM SCP_XLS_PSI_GLOBAL_SMALL_CELL  X WITH (NOLOCK)
						   WHERE 0 = 0 
							  AND X.DIVISION_ID           = @p_division_id
							  AND X.PLAN_START_YYYYMMDD     = @v_plan_start_yyyymmdd
							  AND X.CREATE_FROM_YYYYMMDD    = @p_create_to_yyyymmdd_2
							  AND (X.CELL_TYPE_GROUP_CODE = @p_parameter2 OR X.CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,',')))
						 ) Y2
					ON Y1.DIVISION_ID         = Y2.DIVISION_ID
				   AND Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
				 --WHERE Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
				   AND Y1.PLAN_TYPE           = Y2.PLAN_TYPE
				   AND Y1.SEQ                 = Y2.SEQ
				   AND Y1.CELL_TYPE_GROUP_CODE = Y2.CELL_TYPE_GROUP_CODE
				   AND Y1.CELL_ITEM_ID        = Y2.CELL_ITEM_ID
				   AND Y1.MEASURE             = Y2.MEASURE
				   AND Y1.SITE_ID             = Y2.SITE_ID
				   AND Y1.PROD_LINE           = Y2.PROD_LINE			   
				   AND Y1.SORT_ORDER_NO       = Y2.SORT_ORDER_NO
			   ) X
		  ORDER BY CONVERT(INT, XLS_KEY1)
		  ;
	  END
	  -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - 2021.05.27 - end

     END

  -----------------------------------------
  -- XLSPSI04: ESS GLOBAL PSI SIMULATION
  -----------------------------------------
  IF @P_PGM_CODE = 'XLSPSI04' 
     BEGIN

      IF @p_parameter1 <> ''
        SET @p_parameter3 = @p_parameter1;
     
	 --조건 추가
	 SELECT TOP 1 @p_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
		  FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)

     IF @p_parameter4 ='week_cell'
      BEGIN 
      SELECT DIVISION_ID
            ,PLAN_START_YYYYMMDD
            ,PLAN_TYPE
            ,SEQ
            ,OPERATION_GROUP
            ,OPERATION_GROUP_NAME
            ,CELL_ITEM_ID
            ,ITEM_ID
            ,NICK_NAME
            ,CELL_QTY_PACK
            ,TO_SITE
            ,TO_SITE_DESCRIPTION
            ,PROJECT_CODE
            ,ATTRIBUTE8 AS PROJECT_NAME
            ,FROM_BOH_QTY
            ,TO_BOH_QTY
            ,INCOTERMS
            ,FROM_SITE
            ,FROM_SITE_DESCRIPTION
            ,TRANSPORT_MODE
            ,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
			      ,YIELD
            ,PROD_LINE
            ,BOD_ID
            ,MEASURE
            ,MEASURE_LABEL
            ,XLS_KEY1
            ,XLS_KEY2
            ,XLS_KEY3
            ,XLS_KEY4
            ,XLS_KEY5
            ,XLS_ATTRIBUTE1
            ,XLS_ATTRIBUTE2
            ,XLS_ATTRIBUTE3
            ,XLS_ATTRIBUTE4
            ,XLS_ATTRIBUTE5
            ,SORT_ORDER_NO

            
           
            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16
            ,WQTY17,WQTY18,WQTY19,WQTY20
            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
            ,WQTY51,WQTY52
            

            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            ,ATTRIBUTE1
            ,ATTRIBUTE10
        FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
       WHERE 0 = 0 
          AND SORT_ORDER_NO NOT IN ('135','136','161','162','165','172','173','185','365','430','492','495')  -- PACK 로드율 계산을 위해 추가 된 MEASURE
          AND DIVISION_ID   = @p_division_id -- 20231315 추가
		  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
          AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))
      ORDER BY CONVERT(INT, XLS_KEY1)
      ;
      END 


      IF @p_parameter4 ='prod_load_cell'
      BEGIN 
        SELECT    DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , OPERATION_GROUP
                , OPERATION_GROUP_NAME
                , FROM_SITE
                , FROM_SITE_DESCRIPTION
                , OPERATION_ID
                , ITEM_ID
                , NICK_NAME
                , PROD_LINE
                , DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
                , TACT_TIME
                , MEASURE
                , MEASURE_LABEL
                , SORT_ORDER_NO
                , XLS_KEY1
                
                , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                , WQTY51, WQTY52
      
        FROM SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V WITH (NOLOCK)
		WHERE 0=0
		  AND DIVISION_ID   = @p_division_id -- 20231315 추가
		  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
        ORDER BY  OPERATION_GROUP DESC
                , FROM_SITE,OPERATION_ID
                , PROD_LINE
                , SORT_ORDER_NO
                , XLS_KEY1
      ;
      END 

      IF @p_parameter4 ='week_pack'
      BEGIN 
      SELECT DIVISION_ID
            ,PLAN_START_YYYYMMDD
            ,PLAN_TYPE
            ,SEQ
            ,OPERATION_GROUP
            ,OPERATION_GROUP_NAME
            ,FROM_SITE
            ,FROM_SITE_DESCRIPTION
            ,CELL_ITEM_ID
            ,ITEM_ID
            ,NICK_NAME
            ,PROD_LINE
         ,CELL_QTY_PACK
            ,PROJECT_CODE
            ,ATTRIBUTE8 AS PROJECT_NAME
            ,FROM_BOH_QTY
            ,TO_BOH_QTY
            ,INCOTERMS
            ,TO_SITE
            ,TO_SITE_DESCRIPTION
            ,TRANSPORT_MODE
            ,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
			      ,YIELD
            ,BOD_ID
            ,MEASURE
            ,MEASURE_LABEL
            ,XLS_KEY1
            ,XLS_KEY2
            ,XLS_KEY3
            ,XLS_KEY4
            ,XLS_KEY5
            ,XLS_ATTRIBUTE1
            ,XLS_ATTRIBUTE2
            ,XLS_ATTRIBUTE3
            ,XLS_ATTRIBUTE4
            ,XLS_ATTRIBUTE5
            ,SORT_ORDER_NO

           
            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16
            ,WQTY17,WQTY18,WQTY19,WQTY20
            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
            ,WQTY51,WQTY52
            

            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE
            ,ATTRIBUTE1
            ,ATTRIBUTE10
        FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
       WHERE 0 = 0 
          AND MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN','PACK_SHIP_PLAN_TOTAL','CELL_SHIP_PLAN_TOTAL','PACK_EOH' ) 
		  AND DIVISION_ID   = @p_division_id 
		  AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd -- 20231315 추가-
          --AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))
      ORDER BY CONVERT(INT, XLS_KEY1)
      ;
      END 


	  --호출 대상 없음(대상 테이블(뷰)오류 수정) 20231215
      IF @p_parameter4 ='prod_load_pack'
      BEGIN 
        SELECT    DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , OPERATION_GROUP
                , OPERATION_GROUP_NAME
                , FROM_SITE
                , FROM_SITE_DESCRIPTION
                , OPERATION_ID
                , PROD_LINE
                , ITEM_ID
                , NICK_NAME
                , DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
                , MEASURE
                , MEASURE_LABEL
                , SORT_ORDER_NO
                , XLS_KEY1
                , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
                , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
                , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
                , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
                , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
                , WQTY51, WQTY52
      
        FROM SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_V WITH (NOLOCK)  --대상 테이블 오류로 수정 20231215
        WHERE 0 = 0
       
        ORDER BY  OPERATION_GROUP DESC
                , FROM_SITE
                , (CASE WHEN OPERATION_ID ='-' THEN 'ZZZ' ELSE OPERATION_ID END ) 
                , PROD_LINE
                --, SORT_ORDER_NO
                , XLS_KEY1
                , SORT_ORDER_NO
      ;
      END 

     END

  -----------------------------------------
  -- XLSPSI05: 전극 PSI SIMULATION
  -----------------------------------------  
    IF @P_PGM_CODE = 'XLSPSI05' 
    BEGIN
	--PRINT @P_PGM_CODE + '00. ' +CONVERT(CHAR(23), GETDATE(), 21);

	 -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
	 SET @v_plan_start_yyyymmdd    = '';

	 SELECT  DISTINCT 
	          @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
		     ,@v_seq = SEQ
	   FROM DBO.SCP_XLS_PSI_GLOBAL_ELECTRODE WITH (NOLOCK)
	  WHERE DIVISION_ID = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
	  ;


	 SET @p_create_to_yyyymmdd_1   = @v_plan_start_yyyymmdd;
	 SET @p_create_to_yyyymmdd_2 = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_to_yyyymmdd_1), 112);

	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - start
	  SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_ELECTRODE Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2;

	  IF @v_bp_flag = 'Y' AND @v_2year_cnt = 0
	  BEGIN
		 SET @v_bp_flag = 'N'
	  END
	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - end


	 IF @v_bp_flag = 'N'
	 BEGIN

		 SET @SQL = '';
		 SET @SQL = @SQL + ' SELECT  A.DIVISION_ID																 ';
		 SET @SQL = @SQL + '        ,A.PLAN_START_YYYYMMDD														 ';
		 SET @SQL = @SQL + '        ,A.PLAN_TYPE																 ';
		 SET @SQL = @SQL + '        ,A.SEQ																		 ';
		 SET @SQL = @SQL + '        ,A.FROM_SITE_ID           AS [SUPPLY_SITE]									 ';
		 SET @SQL = @SQL + '        ,A.FROM_SITE_DESCRIPTION  AS [SUPPLY_SITE_DESC]								 ';
		 SET @SQL = @SQL + '        ,A.NICK_NAME																 ';
		 SET @SQL = @SQL + '        ,A.ITEM_ID																	 ';
		 SET @SQL = @SQL + '        ,A.ELECTRODE_TYPE															 ';
		 SET @SQL = @SQL + '        ,A.CONVERT_QTY_CELL															 ';
		 SET @SQL = @SQL + '        ,A.PROD_LINE																 ';
		 SET @SQL = @SQL + '        ,A.PSI_TYPE																	 ';
		 SET @SQL = @SQL + '	 	,A.ATTRIBUTE4 AS GRO_STD_DIO  													 ';
		 SET @SQL = @SQL + '	 	,A.ATTRIBUTE5 AS MIN_STD_DIO  													 ';
		 SET @SQL = @SQL + '        ,A.MEASURE																	 ';
		 SET @SQL = @SQL + '        ,A.MEASURE_LABEL															 ';
		 SET @SQL = @SQL + '        ,A.MEASURE_VALUE1															 ';
		 SET @SQL = @SQL + '        ,A.MEASURE_VALUE1_LABEL														 ';
		 SET @SQL = @SQL + '        ,A.MEASURE_VALUE2															 ';
		 SET @SQL = @SQL + '        ,A.MEASURE_VALUE2_LABEL														 ';
		 SET @SQL = @SQL + '        ,A.CELL_ITEM_ID																 ';
		 SET @SQL = @SQL + '        ,A.UNIT																		 ';
		 SET @SQL = @SQL + '        ,A.XLS_KEY1																	 ';
		 SET @SQL = @SQL + '        ,A.XLS_ATTRIBUTE1															 ';
		 SET @SQL = @SQL + '        ,A.SORT_ORDER_NO															 ';
		 SET @SQL = @SQL + '        ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10		 ';
		 SET @SQL = @SQL + '        ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20		 ';
		 SET @SQL = @SQL + '        ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30		 ';
		 SET @SQL = @SQL + '        ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40		 ';
		 SET @SQL = @SQL + '        ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50		 ';
		 SET @SQL = @SQL + '        ,WQTY51,WQTY52																 ';
		 SET @SQL = @SQL + '        ,A.CREATED_BY																 ';
		 SET @SQL = @SQL + '        ,A.CREATION_DATE															 ';
		 SET @SQL = @SQL + '        ,A.LAST_UPDATED_BY															 ';
		 SET @SQL = @SQL + '        ,A.LAST_UPDATE_DATE															 ';
		 SET @SQL = @SQL + '        ,A.ATTRIBUTE1     															 ';
		 SET @SQL = @SQL + '        ,A.ATTRIBUTE3     															 ';
		 SET @SQL = @SQL + '        ,A.ATTRIBUTE8     															 ';
		 SET @SQL = @SQL + '        ,A.ATTRIBUTE9     															 ';
		 SET @SQL = @SQL + '        ,A.CELL_TYPE_GROUP_CODE														 ';
		 SET @SQL = @SQL + '        ,A.TO_SITE_ID																 ';
		 SET @SQL = @SQL + '        ,A.TO_SITE_DESCRIPTION														 ';
		 SET @SQL = @SQL + '    FROM SCP_XLS_PSI_GLOBAL_ELECTRODE A WITH (NOLOCK)								 ';

		IF LEN(@p_parameter1) > 0
		BEGIN
		SET @SQL = @SQL + 'INNER JOIN (SELECT DISTINCT value AS FROM_SITE_ID FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','','')) B  	';
		SET @SQL = @SQL + ' ON A.FROM_SITE_ID = B.FROM_SITE_ID															';
		END

		IF LEN(@p_parameter2) > 0
		BEGIN
		SET @SQL = @SQL + 'INNER JOIN (SELECT DISTINCT value AS ITEM_ID FROM dbo.FN_SplitString(''' + @p_parameter2 + ''','','')) C	 ';
		SET @SQL = @SQL + ' ON A.ITEM_ID = C.ITEM_ID																																								 ';
		END 

		IF LEN(@p_parameter3) > 0
		BEGIN
		SET @SQL = @SQL + 'INNER JOIN (SELECT DISTINCT value AS NICK_NAME FROM dbo.FN_SplitString(''' + @p_parameter3 + ''','','')) D	';
		SET @SQL = @SQL + ' ON A.NICK_NAME = D.NICK_NAME															';
		END

      SET @SQL = @SQL + ' WHERE A.CREATE_FROM_YYYYMMDD = '''+@p_create_to_yyyymmdd_1+''' 		 ';
	  SET @SQL = @SQL + '   AND A.DIVISION_ID          = '''+@p_division_id+'''					 ';
      SET @SQL = @SQL + 'ORDER BY CONVERT(INT, XLS_KEY1)											 ';
      SET @SQL = @SQL + 'OPTION (MAXRECURSION 10000);									 ';

	  EXEC(@SQL);

--      SELECT DIVISION_ID
--            ,PLAN_START_YYYYMMDD
--            ,PLAN_TYPE
--            ,SEQ
--            ,FROM_SITE_ID           AS [SUPPLY_SITE]
--            ,FROM_SITE_DESCRIPTION  AS [SUPPLY_SITE_DESC]
--            ,NICK_NAME
--            ,ITEM_ID
--            ,ELECTRODE_TYPE
--            ,CONVERT_QTY_CELL
--            ,PROD_LINE
--            ,PSI_TYPE
--			,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
--			,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
--            ,MEASURE
--            ,MEASURE_LABEL
--            ,MEASURE_VALUE1
--            ,MEASURE_VALUE1_LABEL
--            ,MEASURE_VALUE2
--            ,MEASURE_VALUE2_LABEL
--            ,CELL_ITEM_ID
--            ,UNIT
--            ,XLS_KEY1
--            ,XLS_ATTRIBUTE1
--            ,SORT_ORDER_NO
--            ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
--            ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
--            ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
--            ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
--            ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
--            ,WQTY51,WQTY52

--            ,CREATED_BY
--            ,CREATION_DATE
--            ,LAST_UPDATED_BY
--            ,LAST_UPDATE_DATE
--            ,ATTRIBUTE1     -- 'P'
--            ,ATTRIBUTE3     -- ORIGINAL DIVISION ID
--            ,ATTRIBUTE8     --'4'
--            ,ATTRIBUTE9     -- OPERATION_ID
--            ,CELL_TYPE_GROUP_CODE
--            ,TO_SITE_ID
--            ,TO_SITE_DESCRIPTION
--        FROM SCP_XLS_PSI_GLOBAL_ELECTRODE A WITH (NOLOCK)
--       WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1 
--	     AND DIVISION_ID          = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
--         AND (
--              ((CASE WHEN len(@p_parameter1) = 0 THEN '1' ELSE FROM_SITE_ID END) = '1')
--                OR 
--              ((CASE WHEN len(@p_parameter1) > 0 THEN FROM_SITE_ID  END)  = @p_parameter1 )
--             )
---- ITEM_ID 
--        AND (  
--              ((CASE WHEN len(@p_parameter2) = 0 THEN '1' ELSE ITEM_ID END) = '1')
--                OR 
--              ((CASE WHEN len(@p_parameter2) > 0 THEN ITEM_ID  END)  IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter2,',')) )
--             )
---- NICK_NAME
--        AND (  
--              ((CASE WHEN len(@p_parameter3) = 0 THEN '1' ELSE NICK_NAME END) = '1')
--                OR 
--              ((CASE WHEN len(@p_parameter3) > 0 THEN NICK_NAME  END)  IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter3,',')) )
--             )
--      ORDER BY CONVERT(INT, XLS_KEY1)
--      OPTION (MAXRECURSION 10000);
	 END

	 IF @v_bp_flag = 'Y'
	 BEGIN
		SELECT Y1.DIVISION_ID
			,Y1.PLAN_START_YYYYMMDD
			,Y1.PLAN_TYPE
			,Y1.SEQ
			,Y1.SUPPLY_SITE
			,Y1.SUPPLY_SITE_DESC
			,Y1.NICK_NAME
			,Y1.ITEM_ID
			,Y1.ELECTRODE_TYPE
			,Y1.CONVERT_QTY_CELL
			,Y1.PROD_LINE
			,Y1.PSI_TYPE
			,Y1.GRO_STD_DIO
			,Y1.MIN_STD_DIO
			,Y1.MEASURE
			,Y1.MEASURE_LABEL
			,Y1.MEASURE_VALUE1
			,Y1.MEASURE_VALUE1_LABEL
			,Y1.MEASURE_VALUE2
			,Y1.MEASURE_VALUE2_LABEL
			,Y1.CELL_ITEM_ID
			,Y1.UNIT
			,Y1.XLS_KEY1
			,Y1.XLS_ATTRIBUTE1
			,Y1.SORT_ORDER_NO            

			,Y1.WQTY01,Y1.WQTY02,Y1.WQTY03,Y1.WQTY04,Y1.WQTY05,Y1.WQTY06,Y1.WQTY07,Y1.WQTY08,Y1.WQTY09,Y1.WQTY10
			,Y1.WQTY11,Y1.WQTY12,Y1.WQTY13,Y1.WQTY14,Y1.WQTY15,Y1.WQTY16,Y1.WQTY17,Y1.WQTY18,Y1.WQTY19,Y1.WQTY20
			,Y1.WQTY21,Y1.WQTY22,Y1.WQTY23,Y1.WQTY24,Y1.WQTY25,Y1.WQTY26,Y1.WQTY27,Y1.WQTY28,Y1.WQTY29,Y1.WQTY30
			,Y1.WQTY31,Y1.WQTY32,Y1.WQTY33,Y1.WQTY34,Y1.WQTY35,Y1.WQTY36,Y1.WQTY37,Y1.WQTY38,Y1.WQTY39,Y1.WQTY40
			,Y1.WQTY41,Y1.WQTY42,Y1.WQTY43,Y1.WQTY44,Y1.WQTY45,Y1.WQTY46,Y1.WQTY47,Y1.WQTY48,Y1.WQTY49,Y1.WQTY50
			,Y1.WQTY51,Y1.WQTY52

			,Y2.WQTY01 AS WQTY53, Y2.WQTY02 AS WQTY54, Y2.WQTY03 AS WQTY55, Y2.WQTY04 AS WQTY56, Y2.WQTY05 AS WQTY57, Y2.WQTY06 AS WQTY58, Y2.WQTY07 AS WQTY59, Y2.WQTY08 AS WQTY60, Y2.WQTY09 AS WQTY61, Y2.WQTY10 AS WQTY62
			,Y2.WQTY11 AS WQTY63, Y2.WQTY12 AS WQTY64, Y2.WQTY13 AS WQTY65, Y2.WQTY14 AS WQTY66, Y2.WQTY15 AS WQTY67, Y2.WQTY16 AS WQTY68, Y2.WQTY17 AS WQTY69, Y2.WQTY18 AS WQTY70, Y2.WQTY19 AS WQTY71, Y2.WQTY20 AS WQTY72
			,Y2.WQTY21 AS WQTY73, Y2.WQTY22 AS WQTY74, Y2.WQTY23 AS WQTY75, Y2.WQTY24 AS WQTY76, Y2.WQTY25 AS WQTY77, Y2.WQTY26 AS WQTY78, Y2.WQTY27 AS WQTY79, Y2.WQTY28 AS WQTY80, Y2.WQTY29 AS WQTY81, Y2.WQTY30 AS WQTY82
			,Y2.WQTY31 AS WQTY83, Y2.WQTY32 AS WQTY84, Y2.WQTY33 AS WQTY85, Y2.WQTY34 AS WQTY86, Y2.WQTY35 AS WQTY87, Y2.WQTY36 AS WQTY88, Y2.WQTY37 AS WQTY89, Y2.WQTY38 AS WQTY90, Y2.WQTY39 AS WQTY91, Y2.WQTY40 AS WQTY92
			,Y2.WQTY41 AS WQTY93, Y2.WQTY42 AS WQTY94, Y2.WQTY43 AS WQTY95, Y2.WQTY44 AS WQTY96, Y2.WQTY45 AS WQTY97, Y2.WQTY46 AS WQTY98, Y2.WQTY47 AS WQTY99, Y2.WQTY48 AS WQTY100,Y2.WQTY49 AS WQTY101,Y2.WQTY50 AS WQTY102
			,Y2.WQTY51 AS WQTY103,Y2.WQTY52 AS WQTY104		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화

			,Y1.CREATED_BY
			,Y1.CREATION_DATE
			,Y1.LAST_UPDATED_BY
			,Y1.LAST_UPDATE_DATE
			,Y1.ATTRIBUTE1
			,Y1.ATTRIBUTE3     -- ORIGINAL DIVISION ID
			,Y1.ATTRIBUTE8     --'4'
			,Y1.ATTRIBUTE9     -- OPERATION_ID 
			,Y1.CELL_TYPE_GROUP_CODE
			,Y1.TO_SITE_ID
			,Y1.TO_SITE_DESCRIPTION
	    FROM (SELECT DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,FROM_SITE_ID           AS [SUPPLY_SITE]
					,FROM_SITE_DESCRIPTION  AS [SUPPLY_SITE_DESC]
					,NICK_NAME
					,ITEM_ID
					,ELECTRODE_TYPE
					,CONVERT_QTY_CELL
					,PROD_LINE
					,PSI_TYPE
					,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
					,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
					,MEASURE
					,MEASURE_LABEL
					,MEASURE_VALUE1
					,MEASURE_VALUE1_LABEL
					,MEASURE_VALUE2
					,MEASURE_VALUE2_LABEL
					,CELL_ITEM_ID
					,UNIT
					,XLS_KEY1
					,XLS_ATTRIBUTE1
					,SORT_ORDER_NO            

					,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
					,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
					,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
					,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
					,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
					,WQTY51,WQTY52

					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,ATTRIBUTE1
					,ATTRIBUTE3     -- ORIGINAL DIVISION ID
					,ATTRIBUTE8     --'4'
					,ATTRIBUTE9     -- OPERATION_ID 
					,CELL_TYPE_GROUP_CODE
					,TO_SITE_ID
					,TO_SITE_DESCRIPTION
            
				FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
			   WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
			     AND DIVISION_ID          = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
				 AND (
					  ((CASE WHEN len(@p_parameter1) = 0 THEN '1' ELSE FROM_SITE_ID END) = '1')
						OR 
					  ((CASE WHEN len(@p_parameter1) > 0 THEN FROM_SITE_ID  END)  = @p_parameter1 )
					 )
		-- ITEM_ID 
				AND (  
					  ((CASE WHEN len(@p_parameter2) = 0 THEN '1' ELSE ITEM_ID END) = '1')
						OR 
					  ((CASE WHEN len(@p_parameter2) > 0 THEN ITEM_ID  END)  IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter2,',')) )
					 )
		-- NICK_NAME
				AND (  
					  ((CASE WHEN len(@p_parameter3) = 0 THEN '1' ELSE NICK_NAME END) = '1')
						OR 
					  ((CASE WHEN len(@p_parameter3) > 0 THEN NICK_NAME  END)  IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter3,',')) )
					 )
	         ) Y1
		 INNER JOIN
			 (SELECT DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,FROM_SITE_ID           AS [SUPPLY_SITE]
					,FROM_SITE_DESCRIPTION  AS [SUPPLY_SITE_DESC]
					,NICK_NAME
					,ITEM_ID
					,ELECTRODE_TYPE
					,CONVERT_QTY_CELL
					,PROD_LINE
					,PSI_TYPE
					,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
					,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
					,MEASURE
					,MEASURE_LABEL
					,MEASURE_VALUE1
					,MEASURE_VALUE1_LABEL
					,MEASURE_VALUE2
					,MEASURE_VALUE2_LABEL
					,CELL_ITEM_ID
					,UNIT
					,XLS_KEY1
					,XLS_ATTRIBUTE1
					,SORT_ORDER_NO            

					,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
					,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
					,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
					,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
					,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
					,WQTY51,WQTY52

					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,ATTRIBUTE1
					,ATTRIBUTE3     -- ORIGINAL DIVISION ID
					,ATTRIBUTE8     --'4'
					,ATTRIBUTE9     -- OPERATION_ID 
					,CELL_TYPE_GROUP_CODE
					,TO_SITE_ID
					,TO_SITE_DESCRIPTION
            
				FROM SCP_XLS_PSI_GLOBAL_ELECTRODE  WITH (NOLOCK)
			   WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2
			     AND DIVISION_ID          = @p_division_id		-- 2022.03.23	KSW	GM JV 반영
				 AND (
					  ((CASE WHEN len(@p_parameter1) = 0 THEN '1' ELSE FROM_SITE_ID END) = '1')
						OR 
					  ((CASE WHEN len(@p_parameter1) > 0 THEN FROM_SITE_ID  END)  = @p_parameter1 )
					 )
		-- ITEM_ID 
				AND (  
					  ((CASE WHEN len(@p_parameter2) = 0 THEN '1' ELSE ITEM_ID END) = '1')
						OR 
					  ((CASE WHEN len(@p_parameter2) > 0 THEN ITEM_ID  END)  IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter2,',')) )
					 )
		-- NICK_NAME
				AND (  
					  ((CASE WHEN len(@p_parameter3) = 0 THEN '1' ELSE NICK_NAME END) = '1')
						OR 
					  ((CASE WHEN len(@p_parameter3) > 0 THEN NICK_NAME  END)  IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter3,',')) )
					 )
	         ) Y2
	      --ON Y1.XLS_KEY1         = Y2.XLS_KEY1	-- 조건절 변경 : 2021.08.13 일부 XLS_KEY 값 상이로 누락되는 정보가 있음
   		  ON Y1.DIVISION_ID         = Y2.DIVISION_ID
		AND Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
		--WHERE Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
		AND Y1.PLAN_TYPE           = Y2.PLAN_TYPE
		AND Y1.SEQ                 = Y2.SEQ
		AND Y1.NICK_NAME           = Y2.NICK_NAME
		AND Y1.ELECTRODE_TYPE      = Y2.ELECTRODE_TYPE
		AND Y1.ITEM_ID             = Y2.ITEM_ID
		AND Y1.SUPPLY_SITE         = Y2.SUPPLY_SITE
		AND Y1.TO_SITE_ID          = Y2.TO_SITE_ID
		AND Y1.PROD_LINE           = Y2.PROD_LINE
		AND Y1.MEASURE             = Y2.MEASURE
		AND Y1.MEASURE_VALUE1      = Y2.MEASURE_VALUE1
		AND ISNULL(Y1.MEASURE_VALUE2, '-')      = ISNULL(Y2.MEASURE_VALUE2, '-')
		AND ISNULL(Y1.CELL_ITEM_ID, '-')        = ISNULL(Y2.CELL_ITEM_ID, '-')
		AND Y1.SORT_ORDER_NO       = Y2.SORT_ORDER_NO
      ORDER BY CONVERT(INT, Y1.XLS_KEY1)
      OPTION (MAXRECURSION 10000);
	 END
		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end
    END

  -----------------------------------------
  -- XLSPSI06: ESS GLOBAL PACK PSI SIMULATION
  -----------------------------------------
  IF @P_PGM_CODE = 'XLSPSI06' 
     BEGIN

	  -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - start
	 SET @v_plan_start_yyyymmdd    = '';

	 SELECT  DISTINCT 
	          @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
		     ,@p_plan_type = PLAN_TYPE
			 ,@v_seq = SEQ
	   FROM DBO.SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK)
	  ;
	

	 SET @p_create_to_yyyymmdd_1   = @v_plan_start_yyyymmdd;
	 SET @p_create_to_yyyymmdd_2 = CONVERT(VARCHAR(8), DATEADD(day, 364, @p_create_to_yyyymmdd_1), 112);

		 -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end

	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - start
	  SELECT @v_2year_cnt = COUNT(*) FROM SCP_XLS_PSI_GLOBAL_ESS Y WITH (NOLOCK) WHERE CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2;

	  IF @v_bp_flag = 'Y' AND @v_2year_cnt = 0
	  BEGIN
		 SET @v_bp_flag = 'N'
	  END
	  -- 중장기 data 존재여부 (단기 --> 중장기로 전환시 조회안되는 문제방지 :: 2022.08.22 - end


      IF @p_parameter1 <> ''
        SET @p_parameter3 = @p_parameter1
         
      IF @p_parameter4 =''
      BEGIN 
		IF @v_bp_flag = 'N'
		BEGIN 

		  SELECT DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				--,OPERATION_GROUP
				,(CASE WHEN GROUP_SEQ = 1 THEN 'R' WHEN GROUP_SEQ = '2' THEN 'P' ELSE 'A' END) AS OPERATION_GROUP
				--,OPERATION_GROUP_NAME
				,(CASE WHEN GROUP_SEQ = 1 THEN 'Rack' WHEN GROUP_SEQ = '2' THEN 'Pack' ELSE 'Cell' END) AS OPERATION_GROUP_NAME
				,FROM_SITE
				,FROM_SITE_DESCRIPTION
				,CELL_ITEM_ID
				,ITEM_ID
				,NICK_NAME
				,PROD_LINE
				,CELL_QTY_PACK
				,PROJECT_CODE
				,PROJECT_NAME
				,FROM_BOH_QTY
				,TO_BOH_QTY
				,INCOTERMS
				,TO_SITE
				,TO_SITE_DESCRIPTION
				,TRANSPORT_MODE
				,LT_DAY
				,YIELD
				,BOD_ID
				,MEASURE
				--,MEASURE_LABEL
				,(CASE WHEN MEASURE = 'PACK_EOH' AND LEFT(ATTRIBUTE6, 1) = 1 THEN 'DC Link Inventory' ELSE MEASURE_LABEL END) AS MEASURE_LABEL	-- DC LINK 2022.02,14
				,XLS_KEY1
				,XLS_KEY2
				,XLS_KEY3
				,XLS_KEY4
				,XLS_KEY5
				,XLS_ATTRIBUTE1
				,XLS_ATTRIBUTE2
				,XLS_ATTRIBUTE3
				,XLS_ATTRIBUTE4
				,XLS_ATTRIBUTE5
				,SORT_ORDER_NO
				,WQTY01
				,WQTY02
				,WQTY03
				,WQTY04
				,WQTY05
				,WQTY06
				,WQTY07
				,WQTY08
				,WQTY09
				,WQTY10
				,WQTY11
				,WQTY12
				,WQTY13
				,WQTY14
				,WQTY15
				,WQTY16
				,WQTY17
				,WQTY18
				,WQTY19
				,WQTY20
				,WQTY21
				,WQTY22
				,WQTY23
				,WQTY24
				,WQTY25
				,WQTY26
				,WQTY27
				,WQTY28
				,WQTY29
				,WQTY30
				,WQTY31
				,WQTY32
				,WQTY33
				,WQTY34
				,WQTY35
				,WQTY36
				,WQTY37
				,WQTY38
				,WQTY39
				,WQTY40
				,WQTY41
				,WQTY42
				,WQTY43
				,WQTY44
				,WQTY45
				,WQTY46
				,WQTY47
				,WQTY48
				,WQTY49
				,WQTY50
				,WQTY51
				,WQTY52
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,'''' + ATTRIBUTE3 AS ATTRIBUTE3		--ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
				,ATTRIBUTE6     -- DC_LINK 참조열
			FROM (
				  SELECT DIVISION_ID
						,PLAN_START_YYYYMMDD
						,PLAN_TYPE
						,SEQ
						,OPERATION_GROUP
						,OPERATION_GROUP_NAME
						,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 1
							   WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
							   ELSE 3 END) GROUP_SEQ
						,FROM_SITE
						,FROM_SITE_DESCRIPTION
						,CELL_ITEM_ID
						,ITEM_ID
						,NICK_NAME
						,PROD_LINE
						,CELL_QTY_PACK
						,PROJECT_CODE
						,PROJECT_NAME
						,FROM_BOH_QTY
						,TO_BOH_QTY
						,INCOTERMS
						,TO_SITE
						,TO_SITE_DESCRIPTION
						,TRANSPORT_MODE
						,LT_DAY
						,YIELD
						,BOD_ID
						,MEASURE
						--,MEASURE_LABEL
						,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN (CASE WHEN MEASURE = 'PACK_EOH' THEN 'Rack Inventory' ELSE MEASURE_LABEL END) ELSE MEASURE_LABEL END) AS MEASURE_LABEL
						,(CASE WHEN MEASURE = 'PACK_SHIP_PLAN_TOTAL' THEN (SELECT ISNULL(MAX(CASE WHEN F.measure = 'PACK_EOH' THEN  XLS_KEY1 ELSE NULL END)
																					    ,MAX(CASE WHEN F.measure = 'PACK_SHIP_PLAN_TOTAL'  THEN  XLS_KEY1 ELSE NULL END)) - 10
																						FROM SCP_XLS_PSI_GLOBAL_ESS F WITH (NOLOCK)
																						where F.division_id = @p_division_id
																						and F.plan_start_yyyymmdd = @p_create_to_yyyymmdd_1
																						and F.item_id = X.ITEM_ID -- 'EH051226PCS1' -- 'ETD1525BCB33'
																						AND F.CELL_ITEM_ID         = X.CELL_ITEM_ID
																						and F.measure in ('PACK_EOH', 'PACK_SHIP_PLAN_TOTAL')
																						and F.from_site = X.FROM_SITE) ELSE XLS_KEY1 END) AS XLS_KEY1
						,XLS_KEY2
						,XLS_KEY3
						,XLS_KEY4
						,XLS_KEY5
						,XLS_ATTRIBUTE1
						,XLS_ATTRIBUTE2
						,XLS_ATTRIBUTE3
						,XLS_ATTRIBUTE4
						,XLS_ATTRIBUTE5
						,SORT_ORDER_NO
						,WQTY01
						,WQTY02
						,WQTY03
						,WQTY04
						,WQTY05
						,WQTY06
						,WQTY07
						,WQTY08
						,WQTY09
						,WQTY10
						,WQTY11
						,WQTY12
						,WQTY13
						,WQTY14
						,WQTY15
						,WQTY16
						,WQTY17
						,WQTY18
						,WQTY19
						,WQTY20
						,WQTY21
						,WQTY22
						,WQTY23
						,WQTY24
						,WQTY25
						,WQTY26
						,WQTY27
						,WQTY28
						,WQTY29
						,WQTY30
						,WQTY31
						,WQTY32
						,WQTY33
						,WQTY34
						,WQTY35
						,WQTY36
						,WQTY37
						,WQTY38
						,WQTY39
						,WQTY40
						,WQTY41
						,WQTY42
						,WQTY43
						,WQTY44
						,WQTY45
						,WQTY46
						,WQTY47
						,WQTY48
						,WQTY49
						,WQTY50
						,WQTY51
						,WQTY52
						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1
						,ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						,ATTRIBUTE6     -- DC_LINK 참조열
						,(CASE WHEN MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN '9' ELSE LEFT(ATTRIBUTE6, 1) END) AS DC_LINKORDER                           -- DC_LINK 참조열
					FROM (
						  SELECT AA.DIVISION_ID
								,AA.PLAN_START_YYYYMMDD
								,AA.PLAN_TYPE
								,AA.SEQ
								,AA.OPERATION_GROUP
								,AA.OPERATION_GROUP_NAME
								,(SELECT DISTINCT (CASE WHEN AA.ATTRIBUTE3 = 'Y' THEN 'R' ELSE AA.OPERATION_GROUP END) AS CK_GROUP_ID
									FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
									WHERE F.DIVISION_ID = AA.DIVISION_ID
										AND F.ITEM_ID = AA.ITEM_ID
									) AS CK_GROUP_ID
								,AA.FROM_SITE
								,AA.FROM_SITE_DESCRIPTION
								,AA.CELL_ITEM_ID
								,AA.ITEM_ID
								,AA.NICK_NAME
								,AA.PROD_LINE
								,AA.CELL_QTY_PACK
								,AA.PROJECT_CODE
								,AA.ATTRIBUTE8 AS PROJECT_NAME
								,AA.FROM_BOH_QTY
								,AA.TO_BOH_QTY
								,AA.INCOTERMS
								,AA.TO_SITE
								,AA.TO_SITE_DESCRIPTION
								,AA.TRANSPORT_MODE
								,(CASE WHEN   (AA.TRANSPORT_MODE ='-')  AND (AA.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,AA.LT_DAY) END ) AS LT_DAY
								,AA.YIELD
								,AA.BOD_ID
								,AA.MEASURE
								,AA.MEASURE_LABEL
								,AA.XLS_KEY1
								,AA.XLS_KEY2
								,AA.XLS_KEY3
								,AA.XLS_KEY4
								,AA.XLS_KEY5
								,AA.XLS_ATTRIBUTE1
								,AA.XLS_ATTRIBUTE2
								,AA.XLS_ATTRIBUTE3
								,AA.XLS_ATTRIBUTE4
								,AA.XLS_ATTRIBUTE5
								,AA.SORT_ORDER_NO
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY01)) ELSE AA.WQTY01 END) AS WQTY01
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY02)) ELSE AA.WQTY02 END) AS WQTY02
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY03)) ELSE AA.WQTY03 END) AS WQTY03
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY04)) ELSE AA.WQTY04 END) AS WQTY04
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY05)) ELSE AA.WQTY05 END) AS WQTY05
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY06)) ELSE AA.WQTY06 END) AS WQTY06
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY07)) ELSE AA.WQTY07 END) AS WQTY07
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY08)) ELSE AA.WQTY08 END) AS WQTY08
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY09)) ELSE AA.WQTY09 END) AS WQTY09
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY10)) ELSE AA.WQTY10 END) AS WQTY10

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY11)) ELSE AA.WQTY11 END) AS WQTY11
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY12)) ELSE AA.WQTY12 END) AS WQTY12
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY13)) ELSE AA.WQTY13 END) AS WQTY13
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY14)) ELSE AA.WQTY14 END) AS WQTY14
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY15)) ELSE AA.WQTY15 END) AS WQTY15
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY16)) ELSE AA.WQTY16 END) AS WQTY16
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY17)) ELSE AA.WQTY17 END) AS WQTY17
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY18)) ELSE AA.WQTY18 END) AS WQTY18
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY19)) ELSE AA.WQTY19 END) AS WQTY19
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY20)) ELSE AA.WQTY20 END) AS WQTY20

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY21)) ELSE AA.WQTY21 END) AS WQTY21
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY22)) ELSE AA.WQTY22 END) AS WQTY22
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY23)) ELSE AA.WQTY23 END) AS WQTY23
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY24)) ELSE AA.WQTY24 END) AS WQTY24
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY25)) ELSE AA.WQTY25 END) AS WQTY25
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY26)) ELSE AA.WQTY26 END) AS WQTY26
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY27)) ELSE AA.WQTY27 END) AS WQTY27
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY28)) ELSE AA.WQTY28 END) AS WQTY28
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY29)) ELSE AA.WQTY29 END) AS WQTY29
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY30)) ELSE AA.WQTY30 END) AS WQTY30

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY31)) ELSE AA.WQTY31 END) AS WQTY31
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY32)) ELSE AA.WQTY32 END) AS WQTY32
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY33)) ELSE AA.WQTY33 END) AS WQTY33
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY34)) ELSE AA.WQTY34 END) AS WQTY34
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY35)) ELSE AA.WQTY35 END) AS WQTY35
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY36)) ELSE AA.WQTY36 END) AS WQTY36
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY37)) ELSE AA.WQTY37 END) AS WQTY37
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY38)) ELSE AA.WQTY38 END) AS WQTY38
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY39)) ELSE AA.WQTY39 END) AS WQTY39
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY40)) ELSE AA.WQTY40 END) AS WQTY40

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY41)) ELSE AA.WQTY41 END) AS WQTY41
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY42)) ELSE AA.WQTY42 END) AS WQTY42
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY43)) ELSE AA.WQTY43 END) AS WQTY43
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY44)) ELSE AA.WQTY44 END) AS WQTY44
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY45)) ELSE AA.WQTY45 END) AS WQTY45
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY46)) ELSE AA.WQTY46 END) AS WQTY46
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY47)) ELSE AA.WQTY47 END) AS WQTY47
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY48)) ELSE AA.WQTY48 END) AS WQTY48
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY49)) ELSE AA.WQTY49 END) AS WQTY49
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY50)) ELSE AA.WQTY50 END) AS WQTY50

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY51)) ELSE AA.WQTY51 END) AS WQTY51
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY52)) ELSE AA.WQTY52 END) AS WQTY52
								,AA.CREATED_BY
								,AA.CREATION_DATE
								,AA.LAST_UPDATED_BY
								,AA.LAST_UPDATE_DATE
								,AA.ATTRIBUTE1
								,AA.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								,AA.ATTRIBUTE6     -- DC_YN DC_LINK_YN Flag 참조열
							FROM SCP_XLS_PSI_GLOBAL_ESS AA WITH (NOLOCK)
							INNER JOIN (
								SELECT	  A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
										, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
										, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
										, SUM(CNT) AS SUM_CNT
								FROM(
									SELECT	  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP
											, CELL_ITEM_ID, ITEM_ID, NICK_NAME
											, FROM_SITE, TO_SITE, PROD_LINE, PROJECT_CODE, INCOTERMS
											, (CASE WHEN MEASURE = 'SHIP_REQ' THEN 1 ELSE 0 END) AS CNT		-- SHIP_REQ가 있으면 1 이상임.
									FROM SCP_XLS_PSI_GLOBAL_ESS	WITH (NOLOCK)
									WHERE DIVISION_ID = @p_division_id
									AND   PLAN_START_YYYYMMDD = @p_create_to_yyyymmdd_1
									AND   PLAN_TYPE = @p_plan_type
									AND   SEQ = @v_seq
									AND   MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN')
								) A
								WHERE CNT > 0
								GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
										, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
										, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
								--HAVING SUM(CNT) > 0 --20231218 WHERE 절로 대체 - OIJ	 
							) AB
							ON	AA.DIVISION_ID			= AB.DIVISION_ID
							AND AA.PLAN_START_YYYYMMDD	= AB.PLAN_START_YYYYMMDD
							AND	AA.PLAN_TYPE			= AB.PLAN_TYPE
							AND AA.SEQ					= AB.SEQ
							AND AA.OPERATION_GROUP		= AB.OPERATION_GROUP
							AND	ISNULL(AA.CELL_ITEM_ID,'Z') = ISNULL(AB.CELL_ITEM_ID,'Z')
							AND AA.ITEM_ID				= AB.ITEM_ID
							AND AA.NICK_NAME			= AB.NICK_NAME
							AND AA.FROM_SITE			= AB.FROM_SITE
							AND	AA.TO_SITE				= AB.TO_SITE
							AND	AA.PROD_LINE			= AB.PROD_LINE
							AND AA.PROJECT_CODE			= AB.PROJECT_CODE
							AND AA.INCOTERMS			= AB.INCOTERMS
						   WHERE 0 = 0 
							AND AA.DIVISION_ID          = @p_division_id
							AND AA.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
							AND AA.MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN' )		
						  UNION ALL
						  SELECT AA.DIVISION_ID
								,AA.PLAN_START_YYYYMMDD
								,AA.PLAN_TYPE
								,AA.SEQ
								,AA.OPERATION_GROUP
								,AA.OPERATION_GROUP_NAME
								,(SELECT DISTINCT (CASE WHEN AA.ATTRIBUTE3 = 'Y' THEN 'R' ELSE AA.OPERATION_GROUP END) AS CK_GROUP_ID
									FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
									WHERE F.DIVISION_ID = AA.DIVISION_ID
										AND F.ITEM_ID = AA.ITEM_ID
									) AS CK_GROUP_ID
								,AA.FROM_SITE
								,AA.FROM_SITE_DESCRIPTION
								,AA.CELL_ITEM_ID
								,AA.ITEM_ID
								,AA.NICK_NAME
								,AA.PROD_LINE
								,AA.CELL_QTY_PACK
								,AA.PROJECT_CODE
								,AA.ATTRIBUTE8 AS PROJECT_NAME
								,AA.FROM_BOH_QTY
								,AA.TO_BOH_QTY
								,AA.INCOTERMS
								,AA.TO_SITE
								,AA.TO_SITE_DESCRIPTION
								,AA.TRANSPORT_MODE
								,(CASE WHEN   (AA.TRANSPORT_MODE ='-')  AND (AA.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,AA.LT_DAY) END ) AS LT_DAY
								,AA.YIELD
								,AA.BOD_ID
								,AA.MEASURE
								,AA.MEASURE_LABEL
								,AA.XLS_KEY1
								,AA.XLS_KEY2
								,AA.XLS_KEY3
								,AA.XLS_KEY4
								,AA.XLS_KEY5
								,AA.XLS_ATTRIBUTE1
								,AA.XLS_ATTRIBUTE2
								,AA.XLS_ATTRIBUTE3
								,AA.XLS_ATTRIBUTE4
								,AA.XLS_ATTRIBUTE5
								,AA.SORT_ORDER_NO
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY01)) ELSE AA.WQTY01 END) AS WQTY01
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY02)) ELSE AA.WQTY02 END) AS WQTY02
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY03)) ELSE AA.WQTY03 END) AS WQTY03
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY04)) ELSE AA.WQTY04 END) AS WQTY04
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY05)) ELSE AA.WQTY05 END) AS WQTY05
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY06)) ELSE AA.WQTY06 END) AS WQTY06
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY07)) ELSE AA.WQTY07 END) AS WQTY07
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY08)) ELSE AA.WQTY08 END) AS WQTY08
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY09)) ELSE AA.WQTY09 END) AS WQTY09
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY10)) ELSE AA.WQTY10 END) AS WQTY10

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY11)) ELSE AA.WQTY11 END) AS WQTY11
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY12)) ELSE AA.WQTY12 END) AS WQTY12
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY13)) ELSE AA.WQTY13 END) AS WQTY13
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY14)) ELSE AA.WQTY14 END) AS WQTY14
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY15)) ELSE AA.WQTY15 END) AS WQTY15
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY16)) ELSE AA.WQTY16 END) AS WQTY16
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY17)) ELSE AA.WQTY17 END) AS WQTY17
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY18)) ELSE AA.WQTY18 END) AS WQTY18
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY19)) ELSE AA.WQTY19 END) AS WQTY19
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY20)) ELSE AA.WQTY20 END) AS WQTY20

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY21)) ELSE AA.WQTY21 END) AS WQTY21
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY22)) ELSE AA.WQTY22 END) AS WQTY22
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY23)) ELSE AA.WQTY23 END) AS WQTY23
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY24)) ELSE AA.WQTY24 END) AS WQTY24
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY25)) ELSE AA.WQTY25 END) AS WQTY25
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY26)) ELSE AA.WQTY26 END) AS WQTY26
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY27)) ELSE AA.WQTY27 END) AS WQTY27
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY28)) ELSE AA.WQTY28 END) AS WQTY28
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY29)) ELSE AA.WQTY29 END) AS WQTY29
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY30)) ELSE AA.WQTY30 END) AS WQTY30

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY31)) ELSE AA.WQTY31 END) AS WQTY31
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY32)) ELSE AA.WQTY32 END) AS WQTY32
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY33)) ELSE AA.WQTY33 END) AS WQTY33
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY34)) ELSE AA.WQTY34 END) AS WQTY34
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY35)) ELSE AA.WQTY35 END) AS WQTY35
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY36)) ELSE AA.WQTY36 END) AS WQTY36
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY37)) ELSE AA.WQTY37 END) AS WQTY37
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY38)) ELSE AA.WQTY38 END) AS WQTY38
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY39)) ELSE AA.WQTY39 END) AS WQTY39
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY40)) ELSE AA.WQTY40 END) AS WQTY40

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY41)) ELSE AA.WQTY41 END) AS WQTY41
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY42)) ELSE AA.WQTY42 END) AS WQTY42
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY43)) ELSE AA.WQTY43 END) AS WQTY43
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY44)) ELSE AA.WQTY44 END) AS WQTY44
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY45)) ELSE AA.WQTY45 END) AS WQTY45
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY46)) ELSE AA.WQTY46 END) AS WQTY46
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY47)) ELSE AA.WQTY47 END) AS WQTY47
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY48)) ELSE AA.WQTY48 END) AS WQTY48
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY49)) ELSE AA.WQTY49 END) AS WQTY49
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY50)) ELSE AA.WQTY50 END) AS WQTY50

								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY51)) ELSE AA.WQTY51 END) AS WQTY51
								, (CASE WHEN AA.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(AA.WQTY52)) ELSE AA.WQTY52 END) AS WQTY52
								,AA.CREATED_BY
								,AA.CREATION_DATE
								,AA.LAST_UPDATED_BY
								,AA.LAST_UPDATE_DATE
								,AA.ATTRIBUTE1
								,AA.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								,AA.ATTRIBUTE6     -- DC_YN DC_LINK_YN Flag 참조열
							FROM SCP_XLS_PSI_GLOBAL_ESS AA WITH (NOLOCK)
							INNER JOIN (
										SELECT	DISTINCT  B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.NICK_NAME, B.FROM_SITE
										FROM (
												SELECT	  A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
														, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
														, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
														, SUM(CNT) AS SUM_CNT
												FROM(
													SELECT	  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP
															, CELL_ITEM_ID, ITEM_ID, NICK_NAME
															, FROM_SITE, TO_SITE, PROD_LINE, PROJECT_CODE, INCOTERMS
															, (CASE WHEN MEASURE = 'SHIP_REQ' THEN 1 ELSE 0 END) AS CNT		-- SHIP_REQ가 있으면 1 이상임.
													FROM SCP_XLS_PSI_GLOBAL_ESS	WITH (NOLOCK)
													WHERE DIVISION_ID = @p_division_id
													AND   PLAN_START_YYYYMMDD = @p_create_to_yyyymmdd_1
													AND   PLAN_TYPE = @p_plan_type
													AND   SEQ = @v_seq
													AND   MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN')
												) A
												WHERE CNT > 0
												GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
														, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
														, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
												--HAVING SUM(CNT) > 0		--20231218 WHERE 절로 대체 - OIJ	 
										)	B	
										GROUP BY B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.NICK_NAME, B.FROM_SITE
							) AB
							ON	AA.DIVISION_ID			= AB.DIVISION_ID
							AND AA.PLAN_START_YYYYMMDD	= AB.PLAN_START_YYYYMMDD
							AND	AA.PLAN_TYPE			= AB.PLAN_TYPE
							AND AA.SEQ					= AB.SEQ
							AND AA.OPERATION_GROUP		= AB.OPERATION_GROUP
							AND	ISNULL(AA.CELL_ITEM_ID,'Z') = ISNULL(AB.CELL_ITEM_ID,'Z')
							AND AA.ITEM_ID				= AB.ITEM_ID
							AND AA.NICK_NAME			= AB.NICK_NAME
							AND AA.FROM_SITE			= AB.FROM_SITE
						   WHERE 0 = 0 
							AND AA.DIVISION_ID          = @p_division_id
							AND AA.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
							AND AA.MEASURE IN ('PACK_SHIP_PLAN_TOTAL','CELL_SHIP_PLAN_TOTAL','PACK_EOH' )	
						 ) X
				 ) XX
		   ORDER BY CELL_ITEM_ID,GROUP_SEQ, DC_LINKORDER, XLS_KEY1
		  ;
	  END
	  --'XLSPSI06' 
      IF @v_bp_flag = 'Y'
	  BEGIN 
		  SELECT DIVISION_ID
				,PLAN_START_YYYYMMDD
				,PLAN_TYPE
				,SEQ
				--,OPERATION_GROUP
				,(CASE WHEN GROUP_SEQ = 1 THEN 'R' WHEN GROUP_SEQ = '2' THEN 'P' ELSE 'A' END) AS OPERATION_GROUP
				--,OPERATION_GROUP_NAME
				,(CASE WHEN GROUP_SEQ = 1 THEN 'Rack' WHEN GROUP_SEQ = '2' THEN 'Pack' ELSE 'Cell' END) AS OPERATION_GROUP_NAME
				,FROM_SITE
				,FROM_SITE_DESCRIPTION
				,CELL_ITEM_ID
				,ITEM_ID
				,NICK_NAME
				,PROD_LINE
				,CELL_QTY_PACK
				,PROJECT_CODE
				,PROJECT_NAME
				,FROM_BOH_QTY
				,TO_BOH_QTY
				,INCOTERMS
				,TO_SITE
				,TO_SITE_DESCRIPTION
				,TRANSPORT_MODE
				,LT_DAY
				,YIELD
				,BOD_ID
				,MEASURE
				--,MEASURE_LABEL
				,(CASE WHEN MEASURE = 'PACK_EOH' AND LEFT(ATTRIBUTE6, 1) = 1 THEN 'DC Link Inventory' ELSE MEASURE_LABEL END) AS MEASURE_LABEL	-- DC LINK 2022.02,14
				,XLS_KEY1
				,XLS_KEY2
				,XLS_KEY3
				,XLS_KEY4
				,XLS_KEY5
				,XLS_ATTRIBUTE1
				,XLS_ATTRIBUTE2
				,XLS_ATTRIBUTE3
				,XLS_ATTRIBUTE4
				,XLS_ATTRIBUTE5
				,SORT_ORDER_NO
				, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
				, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
				, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
				, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
				, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
				, WQTY51, WQTY52

				, WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
				, WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
				, WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
				, WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
				, WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
				, WQTY103,WQTY104

				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,'''' + ATTRIBUTE3 AS ATTRIBUTE3		--ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
				,ATTRIBUTE6     -- DC_LINK 참조열
			FROM (
				  SELECT DIVISION_ID
						,PLAN_START_YYYYMMDD
						,PLAN_TYPE
						,SEQ
						,OPERATION_GROUP
						,OPERATION_GROUP_NAME
						,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 1
							   WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
							   ELSE 3 END) GROUP_SEQ
						,FROM_SITE
						,FROM_SITE_DESCRIPTION
						,CELL_ITEM_ID
						,ITEM_ID
						,NICK_NAME
						,PROD_LINE
						,CELL_QTY_PACK
						,PROJECT_CODE
						,PROJECT_NAME
						,FROM_BOH_QTY
						,TO_BOH_QTY
						,INCOTERMS
						,TO_SITE
						,TO_SITE_DESCRIPTION
						,TRANSPORT_MODE
						,LT_DAY
						,YIELD
						,BOD_ID
						,MEASURE
						--,MEASURE_LABEL
						,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN (CASE WHEN MEASURE = 'PACK_EOH' THEN 'Rack Inventory' 
																							  ELSE MEASURE_LABEL END)
							   ELSE MEASURE_LABEL END) AS MEASURE_LABEL
						,(CASE WHEN MEASURE = 'PACK_SHIP_PLAN_TOTAL' THEN (SELECT XLS_KEY1 - 10
						                                                     FROM SCP_XLS_PSI_GLOBAL_ESS F WITH (NOLOCK)
																		    WHERE F.DIVISION_ID          = @p_division_id
																			  AND F.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
																			  AND F.ITEM_ID              = X.ITEM_ID
																			  AND F.FROM_SITE            = X.FROM_SITE
																			  AND F.CELL_ITEM_ID         = X.CELL_ITEM_ID
																			  AND F.MEASURE = 'PACK_EOH')
						       ELSE XLS_KEY1 END) AS XLS_KEY1
						,XLS_KEY2
						,XLS_KEY3
						,XLS_KEY4
						,XLS_KEY5
						,XLS_ATTRIBUTE1
						,XLS_ATTRIBUTE2
						,XLS_ATTRIBUTE3
						,XLS_ATTRIBUTE4
						,XLS_ATTRIBUTE5
						,SORT_ORDER_NO
						, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
						, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
						, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
						, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
						, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
						, WQTY51, WQTY52

						, WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
						, WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
						, WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
						, WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
						, WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
						, WQTY103,WQTY104

						,CREATED_BY
						,CREATION_DATE
						,LAST_UPDATED_BY
						,LAST_UPDATE_DATE
						,ATTRIBUTE1
						,ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						,ATTRIBUTE6     -- DC_LINK 참조열
						,(CASE WHEN MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN '9' ELSE LEFT(ATTRIBUTE6, 1) END) AS DC_LINKORDER                           -- DC_YN DC_LINK_YN Flag 참조열
					FROM (
						  SELECT Y1.DIVISION_ID
								,Y1.PLAN_START_YYYYMMDD
								,Y1.PLAN_TYPE
								,Y1.SEQ
								,Y1.OPERATION_GROUP
								,Y1.OPERATION_GROUP_NAME
								,(SELECT DISTINCT (CASE WHEN ATTRIBUTE3 = 'Y' THEN 'R' ELSE Y1.OPERATION_GROUP END) AS CK_GROUP_ID
									FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
									WHERE F.DIVISION_ID = Y1.DIVISION_ID
										AND F.ITEM_ID = Y1.ITEM_ID
									) AS CK_GROUP_ID
								,Y1.FROM_SITE
								,Y1.FROM_SITE_DESCRIPTION
								,Y1.CELL_ITEM_ID
								,Y1.ITEM_ID
								,Y1.NICK_NAME
								,Y1.PROD_LINE
								,Y1.CELL_QTY_PACK
								,Y1.PROJECT_CODE
								,Y1.ATTRIBUTE8 AS PROJECT_NAME
								,Y1.FROM_BOH_QTY
								,Y1.TO_BOH_QTY
								,Y1.INCOTERMS
								,Y1.TO_SITE
								,Y1.TO_SITE_DESCRIPTION
								,Y1.TRANSPORT_MODE
								,(CASE WHEN   (Y1.TRANSPORT_MODE ='-')  AND (Y1.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,Y1.LT_DAY) END ) AS LT_DAY
								,Y1.YIELD
								,Y1.BOD_ID
								,Y1.MEASURE
								,Y1.MEASURE_LABEL
								,Y1.XLS_KEY1
								,Y1.XLS_KEY2
								,Y1.XLS_KEY3
								,Y1.XLS_KEY4
								,Y1.XLS_KEY5
								,Y1.XLS_ATTRIBUTE1
								,Y1.XLS_ATTRIBUTE2
								,Y1.XLS_ATTRIBUTE3
								,Y1.XLS_ATTRIBUTE4
								,Y1.XLS_ATTRIBUTE5
								,Y1.SORT_ORDER_NO

								--  [C20200513-000193] ESS SCP 팩 시뮬레이터 내 Ship Req 소수점 반영 수정요청
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY01)) ELSE Y1.WQTY01 END) AS WQTY01
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY02)) ELSE Y1.WQTY02 END) AS WQTY02
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY03)) ELSE Y1.WQTY03 END) AS WQTY03
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY04)) ELSE Y1.WQTY04 END) AS WQTY04
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY05)) ELSE Y1.WQTY05 END) AS WQTY05
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY06)) ELSE Y1.WQTY06 END) AS WQTY06
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY07)) ELSE Y1.WQTY07 END) AS WQTY07
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY08)) ELSE Y1.WQTY08 END) AS WQTY08
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY09)) ELSE Y1.WQTY09 END) AS WQTY09
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY10)) ELSE Y1.WQTY10 END) AS WQTY10

								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY11)) ELSE Y1.WQTY11 END) AS WQTY11
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY12)) ELSE Y1.WQTY12 END) AS WQTY12
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY13)) ELSE Y1.WQTY13 END) AS WQTY13
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY14)) ELSE Y1.WQTY14 END) AS WQTY14
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY15)) ELSE Y1.WQTY15 END) AS WQTY15
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY16)) ELSE Y1.WQTY16 END) AS WQTY16
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY17)) ELSE Y1.WQTY17 END) AS WQTY17
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY18)) ELSE Y1.WQTY18 END) AS WQTY18
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY19)) ELSE Y1.WQTY19 END) AS WQTY19
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY20)) ELSE Y1.WQTY20 END) AS WQTY20

								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY21)) ELSE Y1.WQTY21 END) AS WQTY21
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY22)) ELSE Y1.WQTY22 END) AS WQTY22
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY23)) ELSE Y1.WQTY23 END) AS WQTY23
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY24)) ELSE Y1.WQTY24 END) AS WQTY24
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY25)) ELSE Y1.WQTY25 END) AS WQTY25
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY26)) ELSE Y1.WQTY26 END) AS WQTY26
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY27)) ELSE Y1.WQTY27 END) AS WQTY27
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY28)) ELSE Y1.WQTY28 END) AS WQTY28
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY29)) ELSE Y1.WQTY29 END) AS WQTY29
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY30)) ELSE Y1.WQTY30 END) AS WQTY30

								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY31)) ELSE Y1.WQTY31 END) AS WQTY31
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY32)) ELSE Y1.WQTY32 END) AS WQTY32
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY33)) ELSE Y1.WQTY33 END) AS WQTY33
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY34)) ELSE Y1.WQTY34 END) AS WQTY34
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY35)) ELSE Y1.WQTY35 END) AS WQTY35
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY36)) ELSE Y1.WQTY36 END) AS WQTY36
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY37)) ELSE Y1.WQTY37 END) AS WQTY37
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY38)) ELSE Y1.WQTY38 END) AS WQTY38
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY39)) ELSE Y1.WQTY39 END) AS WQTY39
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY40)) ELSE Y1.WQTY40 END) AS WQTY40

								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY41)) ELSE Y1.WQTY41 END) AS WQTY41
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY42)) ELSE Y1.WQTY42 END) AS WQTY42
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY43)) ELSE Y1.WQTY43 END) AS WQTY43
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY44)) ELSE Y1.WQTY44 END) AS WQTY44
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY45)) ELSE Y1.WQTY45 END) AS WQTY45
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY46)) ELSE Y1.WQTY46 END) AS WQTY46
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY47)) ELSE Y1.WQTY47 END) AS WQTY47
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY48)) ELSE Y1.WQTY48 END) AS WQTY48
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY49)) ELSE Y1.WQTY49 END) AS WQTY49
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY50)) ELSE Y1.WQTY50 END) AS WQTY50

								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY51)) ELSE Y1.WQTY51 END) AS WQTY51
								, (CASE WHEN Y1.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y1.WQTY52)) ELSE Y1.WQTY52 END) AS WQTY52

								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY01)) ELSE Y2.WQTY01 END) AS WQTY53
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY02)) ELSE Y2.WQTY02 END) AS WQTY54
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY03)) ELSE Y2.WQTY03 END) AS WQTY55
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY04)) ELSE Y2.WQTY04 END) AS WQTY56
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY05)) ELSE Y2.WQTY05 END) AS WQTY57
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY06)) ELSE Y2.WQTY06 END) AS WQTY58
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY07)) ELSE Y2.WQTY07 END) AS WQTY59
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY08)) ELSE Y2.WQTY08 END) AS WQTY60
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY09)) ELSE Y2.WQTY09 END) AS WQTY61
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY10)) ELSE Y2.WQTY10 END) AS WQTY62

								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY11)) ELSE Y2.WQTY11 END) AS WQTY63
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY12)) ELSE Y2.WQTY12 END) AS WQTY64
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY13)) ELSE Y2.WQTY13 END) AS WQTY65
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY14)) ELSE Y2.WQTY14 END) AS WQTY66
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY15)) ELSE Y2.WQTY15 END) AS WQTY67
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY16)) ELSE Y2.WQTY16 END) AS WQTY68
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY17)) ELSE Y2.WQTY17 END) AS WQTY69
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY18)) ELSE Y2.WQTY18 END) AS WQTY70
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY19)) ELSE Y2.WQTY19 END) AS WQTY71
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY20)) ELSE Y2.WQTY20 END) AS WQTY72

								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY21)) ELSE Y2.WQTY21 END) AS WQTY73
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY22)) ELSE Y2.WQTY22 END) AS WQTY74
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY23)) ELSE Y2.WQTY23 END) AS WQTY75
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY24)) ELSE Y2.WQTY24 END) AS WQTY76
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY25)) ELSE Y2.WQTY25 END) AS WQTY77
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY26)) ELSE Y2.WQTY26 END) AS WQTY78

								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY27)) ELSE Y2.WQTY27 END) AS WQTY79
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY28)) ELSE Y2.WQTY28 END) AS WQTY80
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY29)) ELSE Y2.WQTY29 END) AS WQTY81
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY30)) ELSE Y2.WQTY30 END) AS WQTY82

								-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY31)) ELSE Y2.WQTY31 END) AS WQTY83
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY32)) ELSE Y2.WQTY32 END) AS WQTY84
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY33)) ELSE Y2.WQTY33 END) AS WQTY85
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY34)) ELSE Y2.WQTY34 END) AS WQTY86
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY35)) ELSE Y2.WQTY35 END) AS WQTY87
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY36)) ELSE Y2.WQTY36 END) AS WQTY88
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY37)) ELSE Y2.WQTY37 END) AS WQTY89
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY38)) ELSE Y2.WQTY38 END) AS WQTY90
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY39)) ELSE Y2.WQTY39 END) AS WQTY91
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY40)) ELSE Y2.WQTY40 END) AS WQTY92
                                                                                                                                    
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY41)) ELSE Y2.WQTY41 END) AS WQTY93
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY42)) ELSE Y2.WQTY42 END) AS WQTY94
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY43)) ELSE Y2.WQTY43 END) AS WQTY95
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY44)) ELSE Y2.WQTY44 END) AS WQTY96
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY45)) ELSE Y2.WQTY45 END) AS WQTY97
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY46)) ELSE Y2.WQTY46 END) AS WQTY98
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY47)) ELSE Y2.WQTY47 END) AS WQTY99
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY48)) ELSE Y2.WQTY48 END) AS WQTY100
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY49)) ELSE Y2.WQTY49 END) AS WQTY101
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY50)) ELSE Y2.WQTY50 END) AS WQTY102
                                                                                                                                    
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY51)) ELSE Y2.WQTY51 END) AS WQTY103
								, (CASE WHEN Y2.MEASURE = 'SHIP_REQ' THEN CONVERT(DECIMAL,(Y2.WQTY52)) ELSE Y2.WQTY52 END) AS WQTY104

								,Y1.CREATED_BY
								,Y1.CREATION_DATE
								,Y1.LAST_UPDATED_BY
								,Y1.LAST_UPDATE_DATE
								,Y1.ATTRIBUTE1
								,Y1.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								,Y1.ATTRIBUTE6      -- DC_LINK 참조열
							FROM (
								  SELECT AA.DIVISION_ID
										,AA.PLAN_START_YYYYMMDD
										,AA.PLAN_TYPE
										,AA.SEQ
										,AA.OPERATION_GROUP
										,AA.OPERATION_GROUP_NAME
										,AA.FROM_SITE
										,AA.FROM_SITE_DESCRIPTION
										,AA.CELL_ITEM_ID
										,AA.ITEM_ID
										,AA.NICK_NAME
										,AA.PROD_LINE
										,AA.CELL_QTY_PACK
										,AA.PROJECT_CODE
										,AA.ATTRIBUTE8 AS PROJECT_NAME
										,AA.FROM_BOH_QTY
										,AA.TO_BOH_QTY
										,AA.INCOTERMS
										,AA.TO_SITE
										,AA.TO_SITE_DESCRIPTION
										,AA.TRANSPORT_MODE
										,(CASE WHEN   (AA.TRANSPORT_MODE ='-')  AND (AA.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,AA.LT_DAY) END ) AS LT_DAY
										,AA.YIELD
										,AA.BOD_ID
										,AA.MEASURE
										,AA.MEASURE_LABEL
										,AA.XLS_KEY1
										,AA.XLS_KEY2
										,AA.XLS_KEY3
										,AA.XLS_KEY4
										,AA.XLS_KEY5
										,AA.XLS_ATTRIBUTE1
										,AA.XLS_ATTRIBUTE2
										,AA.XLS_ATTRIBUTE3
										,AA.XLS_ATTRIBUTE4
										,AA.XLS_ATTRIBUTE5
										,AA.SORT_ORDER_NO

										,AA.WQTY01,AA.WQTY02,AA.WQTY03,AA.WQTY04,AA.WQTY05,AA.WQTY06,AA.WQTY07,AA.WQTY08,AA.WQTY09,AA.WQTY10
										,AA.WQTY11,AA.WQTY12,AA.WQTY13,AA.WQTY14,AA.WQTY15,AA.WQTY16,AA.WQTY17,AA.WQTY18,AA.WQTY19,AA.WQTY20
										,AA.WQTY21,AA.WQTY22,AA.WQTY23,AA.WQTY24,AA.WQTY25,AA.WQTY26,AA.WQTY27,AA.WQTY28,AA.WQTY29,AA.WQTY30
										,AA.WQTY31,AA.WQTY32,AA.WQTY33,AA.WQTY34,AA.WQTY35,AA.WQTY36,AA.WQTY37,AA.WQTY38,AA.WQTY39,AA.WQTY40
										,AA.WQTY41,AA.WQTY42,AA.WQTY43,AA.WQTY44,AA.WQTY45,AA.WQTY46,AA.WQTY47,AA.WQTY48,AA.WQTY49,AA.WQTY50
										,AA.WQTY51,AA.WQTY52

										,AA.CREATED_BY
										,AA.CREATION_DATE
										,AA.LAST_UPDATED_BY
										,AA.LAST_UPDATE_DATE
										,AA.ATTRIBUTE1
										,AA.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										,AA.ATTRIBUTE8
										,AA.ATTRIBUTE10
										,AA.ATTRIBUTE6    -- DC_LINK 참조열
									FROM SCP_XLS_PSI_GLOBAL_ESS AA WITH (NOLOCK)
									INNER JOIN (
										SELECT	  A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
												, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
												, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
												, SUM(CNT) AS SUM_CNT
										FROM(
											SELECT	  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP
													, CELL_ITEM_ID, ITEM_ID, NICK_NAME
													, FROM_SITE, TO_SITE, PROD_LINE, PROJECT_CODE, INCOTERMS
													, (CASE WHEN MEASURE = 'SHIP_REQ' THEN 1 ELSE 0 END) AS CNT		-- SHIP_REQ가 있으면 1 이상임.
											FROM SCP_XLS_PSI_GLOBAL_ESS	WITH (NOLOCK)
											WHERE DIVISION_ID = @p_division_id
											AND   PLAN_START_YYYYMMDD = @p_create_to_yyyymmdd_1
											AND   PLAN_TYPE = @p_plan_type
											AND   SEQ = @v_seq
											AND   MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN')
										) A
										WHERE CNT > 0
										GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
												, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
												, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
										--HAVING SUM(CNT) > 0 --20231218 WHERE 절로 대체 - OIJ	 
									) AB
									ON	AA.DIVISION_ID			= AB.DIVISION_ID
									AND AA.PLAN_START_YYYYMMDD	= AB.PLAN_START_YYYYMMDD
									AND	AA.PLAN_TYPE			= AB.PLAN_TYPE
									AND AA.SEQ					= AB.SEQ
									AND AA.OPERATION_GROUP		= AB.OPERATION_GROUP
									AND	ISNULL(AA.CELL_ITEM_ID,'Z') = ISNULL(AB.CELL_ITEM_ID,'Z')
									AND AA.ITEM_ID				= AB.ITEM_ID
									AND AA.NICK_NAME			= AB.NICK_NAME
									AND AA.FROM_SITE			= AB.FROM_SITE
									AND	AA.TO_SITE				= AB.TO_SITE
									AND	AA.PROD_LINE			= AB.PROD_LINE
									AND AA.PROJECT_CODE			= AB.PROJECT_CODE
									AND AA.INCOTERMS			= AB.INCOTERMS
								   WHERE AA.DIVISION_ID   = @p_division_id
									 AND AA.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
									 AND AA.MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN','PACK_SHIP_PLAN_TOTAL')
								   UNION ALL
								   SELECT AA.DIVISION_ID
										,AA.PLAN_START_YYYYMMDD
										,AA.PLAN_TYPE
										,AA.SEQ
										,AA.OPERATION_GROUP
										,AA.OPERATION_GROUP_NAME
										,AA.FROM_SITE
										,AA.FROM_SITE_DESCRIPTION
										,AA.CELL_ITEM_ID
										,AA.ITEM_ID
										,AA.NICK_NAME
										,AA.PROD_LINE
										,AA.CELL_QTY_PACK
										,AA.PROJECT_CODE
										,AA.ATTRIBUTE8 AS PROJECT_NAME
										,AA.FROM_BOH_QTY
										,AA.TO_BOH_QTY
										,AA.INCOTERMS
										,AA.TO_SITE
										,AA.TO_SITE_DESCRIPTION
										,AA.TRANSPORT_MODE
										,(CASE WHEN   (AA.TRANSPORT_MODE ='-')  AND (AA.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,AA.LT_DAY) END ) AS LT_DAY
										,AA.YIELD
										,AA.BOD_ID
										,AA.MEASURE
										,AA.MEASURE_LABEL
										,AA.XLS_KEY1
										,AA.XLS_KEY2
										,AA.XLS_KEY3
										,AA.XLS_KEY4
										,AA.XLS_KEY5
										,AA.XLS_ATTRIBUTE1
										,AA.XLS_ATTRIBUTE2
										,AA.XLS_ATTRIBUTE3
										,AA.XLS_ATTRIBUTE4
										,AA.XLS_ATTRIBUTE5
										,AA.SORT_ORDER_NO

										,AA.WQTY01,AA.WQTY02,AA.WQTY03,AA.WQTY04,AA.WQTY05,AA.WQTY06,AA.WQTY07,AA.WQTY08,AA.WQTY09,AA.WQTY10
										,AA.WQTY11,AA.WQTY12,AA.WQTY13,AA.WQTY14,AA.WQTY15,AA.WQTY16,AA.WQTY17,AA.WQTY18,AA.WQTY19,AA.WQTY20
										,AA.WQTY21,AA.WQTY22,AA.WQTY23,AA.WQTY24,AA.WQTY25,AA.WQTY26,AA.WQTY27,AA.WQTY28,AA.WQTY29,AA.WQTY30
										,AA.WQTY31,AA.WQTY32,AA.WQTY33,AA.WQTY34,AA.WQTY35,AA.WQTY36,AA.WQTY37,AA.WQTY38,AA.WQTY39,AA.WQTY40
										,AA.WQTY41,AA.WQTY42,AA.WQTY43,AA.WQTY44,AA.WQTY45,AA.WQTY46,AA.WQTY47,AA.WQTY48,AA.WQTY49,AA.WQTY50
										,AA.WQTY51,AA.WQTY52

										,AA.CREATED_BY
										,AA.CREATION_DATE
										,AA.LAST_UPDATED_BY
										,AA.LAST_UPDATE_DATE
										,AA.ATTRIBUTE1
										,AA.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										,AA.ATTRIBUTE8
										,AA.ATTRIBUTE10
										,AA.ATTRIBUTE6    -- DC_LINK 참조열
									FROM SCP_XLS_PSI_GLOBAL_ESS AA WITH (NOLOCK)
									INNER JOIN (
												SELECT	DISTINCT  B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.NICK_NAME, B.FROM_SITE
												FROM (
														SELECT	  A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
																, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
																, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
																, SUM(CNT) AS SUM_CNT
														FROM(
															SELECT	  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP
																	, CELL_ITEM_ID, ITEM_ID, NICK_NAME
																	, FROM_SITE, TO_SITE, PROD_LINE, PROJECT_CODE, INCOTERMS
																	, (CASE WHEN MEASURE = 'SHIP_REQ' THEN 1 ELSE 0 END) AS CNT		-- SHIP_REQ가 있으면 1 이상임.
															FROM SCP_XLS_PSI_GLOBAL_ESS	WITH (NOLOCK)
															WHERE DIVISION_ID = @p_division_id
															AND   PLAN_START_YYYYMMDD = @p_create_to_yyyymmdd_1
															AND   PLAN_TYPE = @p_plan_type
															AND   SEQ = @v_seq
															AND   MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN')
														) A
														WHERE CNT > 0
														GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
																, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
																, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
														--HAVING SUM(CNT) > 0			 --20231218 WHERE 절로 대체 - OIJ	 
												)	B	
												GROUP BY B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.NICK_NAME, B.FROM_SITE
									) AB
									ON	AA.DIVISION_ID			= AB.DIVISION_ID
									AND AA.PLAN_START_YYYYMMDD	= AB.PLAN_START_YYYYMMDD
									AND	AA.PLAN_TYPE			= AB.PLAN_TYPE
									AND AA.SEQ					= AB.SEQ
									AND AA.OPERATION_GROUP		= AB.OPERATION_GROUP
									AND	ISNULL(AA.CELL_ITEM_ID,'Z') = ISNULL(AB.CELL_ITEM_ID,'Z')
									AND AA.ITEM_ID				= AB.ITEM_ID
									AND AA.NICK_NAME			= AB.NICK_NAME
									AND AA.FROM_SITE			= AB.FROM_SITE
								   WHERE AA.DIVISION_ID   = @p_division_id
									 AND AA.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_1
									 AND AA.MEASURE IN ('PACK_SHIP_PLAN_TOTAL','CELL_SHIP_PLAN_TOTAL','PACK_EOH' )
								 ) Y1
						  INNER JOIN
								 (
								  SELECT AA.DIVISION_ID
										,AA.PLAN_START_YYYYMMDD
										,AA.PLAN_TYPE
										,AA.SEQ
										,AA.OPERATION_GROUP
										,AA.OPERATION_GROUP_NAME
										,AA.FROM_SITE
										,AA.FROM_SITE_DESCRIPTION
										,AA.CELL_ITEM_ID
										,AA.ITEM_ID
										,AA.NICK_NAME
										,AA.PROD_LINE
										,AA.CELL_QTY_PACK
										,AA.PROJECT_CODE
										,AA.ATTRIBUTE8 AS PROJECT_NAME
										,AA.FROM_BOH_QTY
										,AA.TO_BOH_QTY
										,AA.INCOTERMS
										,AA.TO_SITE
										,AA.TO_SITE_DESCRIPTION
										,AA.TRANSPORT_MODE
										,(CASE WHEN   (AA.TRANSPORT_MODE ='-')  AND (AA.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,AA.LT_DAY) END ) AS LT_DAY
										,AA.YIELD
										,AA.BOD_ID
										,AA.MEASURE
										,AA.MEASURE_LABEL
										,AA.XLS_KEY1
										,AA.XLS_KEY2
										,AA.XLS_KEY3
										,AA.XLS_KEY4
										,AA.XLS_KEY5
										,AA.XLS_ATTRIBUTE1
										,AA.XLS_ATTRIBUTE2
										,AA.XLS_ATTRIBUTE3
										,AA.XLS_ATTRIBUTE4
										,AA.XLS_ATTRIBUTE5
										,AA.SORT_ORDER_NO

										,AA.WQTY01,AA.WQTY02,AA.WQTY03,AA.WQTY04,AA.WQTY05,AA.WQTY06,AA.WQTY07,AA.WQTY08,AA.WQTY09,AA.WQTY10
										,AA.WQTY11,AA.WQTY12,AA.WQTY13,AA.WQTY14,AA.WQTY15,AA.WQTY16,AA.WQTY17,AA.WQTY18,AA.WQTY19,AA.WQTY20
										,AA.WQTY21,AA.WQTY22,AA.WQTY23,AA.WQTY24,AA.WQTY25,AA.WQTY26,AA.WQTY27,AA.WQTY28,AA.WQTY29,AA.WQTY30
										,AA.WQTY31,AA.WQTY32,AA.WQTY33,AA.WQTY34,AA.WQTY35,AA.WQTY36,AA.WQTY37,AA.WQTY38,AA.WQTY39,AA.WQTY40
										,AA.WQTY41,AA.WQTY42,AA.WQTY43,AA.WQTY44,AA.WQTY45,AA.WQTY46,AA.WQTY47,AA.WQTY48,AA.WQTY49,AA.WQTY50
										,AA.WQTY51,AA.WQTY52

										,AA.CREATED_BY
										,AA.CREATION_DATE
										,AA.LAST_UPDATED_BY
										,AA.LAST_UPDATE_DATE
										,AA.ATTRIBUTE1
										,AA.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										,AA.ATTRIBUTE8
										,AA.ATTRIBUTE10
										,AA.ATTRIBUTE6    -- DC_LINK 참조열
									FROM SCP_XLS_PSI_GLOBAL_ESS AA WITH (NOLOCK)
									INNER JOIN (
										SELECT	  A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
												, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
												, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
												, SUM(CNT) AS SUM_CNT
										FROM(
											SELECT	  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP
													, CELL_ITEM_ID, ITEM_ID, NICK_NAME
													, FROM_SITE, TO_SITE, PROD_LINE, PROJECT_CODE, INCOTERMS
													, (CASE WHEN MEASURE = 'SHIP_REQ' THEN 1 ELSE 0 END) AS CNT		-- SHIP_REQ가 있으면 1 이상임.
											FROM SCP_XLS_PSI_GLOBAL_ESS	WITH (NOLOCK)
											WHERE DIVISION_ID = @p_division_id
											AND   PLAN_START_YYYYMMDD = @p_create_to_yyyymmdd_1
											AND   PLAN_TYPE = @p_plan_type
											AND   SEQ = @v_seq
											AND   MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN')
										) A
										WHERE CNT > 0
										GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
												, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
												, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
										--HAVING SUM(CNT) > 0  --20231218 WHERE 절로 대체 - OIJ	 
									) AB									
									ON	AA.DIVISION_ID			= AB.DIVISION_ID
									AND AA.PLAN_START_YYYYMMDD	= AB.PLAN_START_YYYYMMDD
									AND	AA.PLAN_TYPE			= AB.PLAN_TYPE
									AND AA.SEQ					= AB.SEQ
									AND AA.OPERATION_GROUP		= AB.OPERATION_GROUP
									AND	ISNULL(AA.CELL_ITEM_ID,'Z') = ISNULL(AB.CELL_ITEM_ID,'Z')
									AND AA.ITEM_ID				= AB.ITEM_ID
									AND AA.NICK_NAME			= AB.NICK_NAME
									AND AA.FROM_SITE			= AB.FROM_SITE
									AND	AA.TO_SITE				= AB.TO_SITE
									AND	AA.PROD_LINE			= AB.PROD_LINE
									AND AA.PROJECT_CODE			= AB.PROJECT_CODE
									AND AA.INCOTERMS			= AB.INCOTERMS
								   WHERE AA.DIVISION_ID   = @p_division_id
									 AND AA.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2
									 AND AA.MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN' )
								  UNION ALL
								  SELECT AA.DIVISION_ID
										,AA.PLAN_START_YYYYMMDD
										,AA.PLAN_TYPE
										,AA.SEQ
										,AA.OPERATION_GROUP
										,AA.OPERATION_GROUP_NAME
										,AA.FROM_SITE
										,AA.FROM_SITE_DESCRIPTION
										,AA.CELL_ITEM_ID
										,AA.ITEM_ID
										,AA.NICK_NAME
										,AA.PROD_LINE
										,AA.CELL_QTY_PACK
										,AA.PROJECT_CODE
										,AA.ATTRIBUTE8 AS PROJECT_NAME
										,AA.FROM_BOH_QTY
										,AA.TO_BOH_QTY
										,AA.INCOTERMS
										,AA.TO_SITE
										,AA.TO_SITE_DESCRIPTION
										,AA.TRANSPORT_MODE
										,(CASE WHEN   (AA.TRANSPORT_MODE ='-')  AND (AA.MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,AA.LT_DAY) END ) AS LT_DAY
										,AA.YIELD
										,AA.BOD_ID
										,AA.MEASURE
										,AA.MEASURE_LABEL
										,AA.XLS_KEY1
										,AA.XLS_KEY2
										,AA.XLS_KEY3
										,AA.XLS_KEY4
										,AA.XLS_KEY5
										,AA.XLS_ATTRIBUTE1
										,AA.XLS_ATTRIBUTE2
										,AA.XLS_ATTRIBUTE3
										,AA.XLS_ATTRIBUTE4
										,AA.XLS_ATTRIBUTE5
										,AA.SORT_ORDER_NO

										,AA.WQTY01,AA.WQTY02,AA.WQTY03,AA.WQTY04,AA.WQTY05,AA.WQTY06,AA.WQTY07,AA.WQTY08,AA.WQTY09,AA.WQTY10
										,AA.WQTY11,AA.WQTY12,AA.WQTY13,AA.WQTY14,AA.WQTY15,AA.WQTY16,AA.WQTY17,AA.WQTY18,AA.WQTY19,AA.WQTY20
										,AA.WQTY21,AA.WQTY22,AA.WQTY23,AA.WQTY24,AA.WQTY25,AA.WQTY26,AA.WQTY27,AA.WQTY28,AA.WQTY29,AA.WQTY30
										,AA.WQTY31,AA.WQTY32,AA.WQTY33,AA.WQTY34,AA.WQTY35,AA.WQTY36,AA.WQTY37,AA.WQTY38,AA.WQTY39,AA.WQTY40
										,AA.WQTY41,AA.WQTY42,AA.WQTY43,AA.WQTY44,AA.WQTY45,AA.WQTY46,AA.WQTY47,AA.WQTY48,AA.WQTY49,AA.WQTY50
										,AA.WQTY51,AA.WQTY52

										,AA.CREATED_BY
										,AA.CREATION_DATE
										,AA.LAST_UPDATED_BY
										,AA.LAST_UPDATE_DATE
										,AA.ATTRIBUTE1
										,AA.ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										,AA.ATTRIBUTE8
										,AA.ATTRIBUTE10
										,AA.ATTRIBUTE6    -- DC_LINK 참조열
									FROM SCP_XLS_PSI_GLOBAL_ESS AA WITH (NOLOCK)
									INNER JOIN (
												SELECT	DISTINCT  B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.NICK_NAME, B.FROM_SITE
												FROM (
														SELECT	  A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
																, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
																, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
																, SUM(CNT) AS SUM_CNT
														FROM(
															SELECT	  DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP
																	, CELL_ITEM_ID, ITEM_ID, NICK_NAME
																	, FROM_SITE, TO_SITE, PROD_LINE, PROJECT_CODE, INCOTERMS
																	, (CASE WHEN MEASURE = 'SHIP_REQ' THEN 1 ELSE 0 END) AS CNT		-- SHIP_REQ가 있으면 1 이상임.
															FROM SCP_XLS_PSI_GLOBAL_ESS	WITH (NOLOCK)
															WHERE DIVISION_ID = @p_division_id
															AND   PLAN_START_YYYYMMDD = @p_create_to_yyyymmdd_1
															AND   PLAN_TYPE = @p_plan_type
															AND   SEQ = @v_seq
															AND   MEASURE IN ('PLAN_REQ_GAP','SHIP_REQ','SHIP_PLAN')
														) A
														WHERE CNT > 0
														GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.OPERATION_GROUP
																, A.CELL_ITEM_ID, A.ITEM_ID, A.NICK_NAME
																, A.FROM_SITE, A.TO_SITE, A.PROD_LINE, A.PROJECT_CODE, A.INCOTERMS
														--HAVING SUM(CNT) > 0			  --20231218 WHERE 절로 대체 - OIJ	 
												)	B	
												GROUP BY B.DIVISION_ID, B.PLAN_START_YYYYMMDD, B.PLAN_TYPE, B.SEQ, B.OPERATION_GROUP, B.CELL_ITEM_ID, B.ITEM_ID, B.NICK_NAME, B.FROM_SITE
									) AB
									ON	AA.DIVISION_ID			= AB.DIVISION_ID
									AND AA.PLAN_START_YYYYMMDD	= AB.PLAN_START_YYYYMMDD
									AND	AA.PLAN_TYPE			= AB.PLAN_TYPE
									AND AA.SEQ					= AB.SEQ
									AND AA.OPERATION_GROUP		= AB.OPERATION_GROUP
									AND	ISNULL(AA.CELL_ITEM_ID,'Z') = ISNULL(AB.CELL_ITEM_ID,'Z')
									AND AA.ITEM_ID				= AB.ITEM_ID
									AND AA.NICK_NAME			= AB.NICK_NAME
									AND AA.FROM_SITE			= AB.FROM_SITE
								   WHERE AA.DIVISION_ID   = @p_division_id
									 AND AA.CREATE_FROM_YYYYMMDD = @p_create_to_yyyymmdd_2
									 AND AA.MEASURE IN ('PACK_SHIP_PLAN_TOTAL','CELL_SHIP_PLAN_TOTAL','PACK_EOH' )
								 ) Y2
							  ON Y1.DIVISION_ID         = Y2.DIVISION_ID
						   WHERE Y1.PLAN_START_YYYYMMDD = Y2.PLAN_START_YYYYMMDD
							 --AND Y1.XLS_KEY1            = Y2.XLS_KEY1		-- 2022.08.18 :: 중장기 플랜에서 52주 및 +52주 사이에 XLS_KEY1 값이 상이할 수 있음
							 AND Y1.CELL_ITEM_ID = Y2.CELL_ITEM_ID
							 AND Y1.ITEM_ID      = Y2.ITEM_ID
							 AND Y1.MEASURE      = Y2.MEASURE
							 AND Y1.FROM_SITE    = Y2.FROM_SITE
							 AND Y1.TO_SITE      = Y2.TO_SITE
							 AND Y1.BOD_ID       = Y2.BOD_ID
							 AND Y1.PROD_LINE    = Y2.PROD_LINE
							 AND Y1.PROJECT_CODE = Y2.PROJECT_CODE
							 AND Y1.INCOTERMS    = Y2.INCOTERMS
						 ) X
				 ) XX
		   ORDER BY CELL_ITEM_ID, GROUP_SEQ, DC_LINKORDER, XLS_KEY1
		   ;

	  END
      -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 - end

      END 


      IF @p_parameter4 ='prod_load' --LOAD RATIO SHEET 데이터
      BEGIN 
      IF @v_bp_flag = 'N'
	  BEGIN
        SELECT  DIVISION_ID
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              --, OPERATION_GROUP
              ,(CASE WHEN GROUP_SEQ = 1 THEN 'R' WHEN GROUP_SEQ = '2' THEN 'P' ELSE 'A' END) AS OPERATION_GROUP
              --, OPERATION_GROUP_NAME
              --,(CASE WHEN GROUP_SEQ2 = 1 THEN 'Rack' WHEN GROUP_SEQ2 = '2' THEN 'Pack' ELSE 'Cell' END) AS OPERATION_GROUP_NAME
			  ,(CASE WHEN GROUP_SEQ2 = 1 THEN 'Rack' ELSE OPERATION_GROUP_NAME END) AS OPERATION_GROUP_NAME
              , FROM_SITE
              , FROM_SITE_DESCRIPTION
              , OPERATION_ID
              , PROD_LINE
              , CELL_ITEM_ID
              , ITEM_ID
              , NICK_NAME
              , WEEKLY_CAPA_QTY
              , FROM_BOH_QTY
              , YIELD
              , LT_DAY
              , CELL_QTY_PACK
              , TO_SITE
              , TO_SITE_DESCRIPTION
			  , BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
              , MEASURE
              , MEASURE_LABEL
              , SORT_ORDER_NO
              , XLS_KEY1      
              , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
              , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
              , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
              , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
              , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
              , WQTY51, WQTY52

              , ORD2
              , ORD3
              , ORD1
			  ,'''' + ATTRIBUTE3 AS ATTRIBUTE3		--ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			  , ATTRIBUTE6
		  FROM (
				SELECT  DIVISION_ID
					  , PLAN_START_YYYYMMDD
					  , PLAN_TYPE
					  , SEQ
					  , OPERATION_GROUP
					  , OPERATION_GROUP_NAME
					  , (CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 2
							  WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
							  ELSE 3 END) GROUP_SEQ
					  , (CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 1
							  WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
							  ELSE 3 END) GROUP_SEQ2
					  , FROM_SITE
					  , FROM_SITE_DESCRIPTION
					  , OPERATION_ID
					  , PROD_LINE
					  , CELL_ITEM_ID
					  , ITEM_ID
					  , NICK_NAME
					  , WEEKLY_CAPA_QTY
					  , FROM_BOH_QTY
					  , YIELD
					  , LT_DAY
					  , CELL_QTY_PACK
					  , TO_SITE
					  , TO_SITE_DESCRIPTION
					  , BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					  , MEASURE
					  --, MEASURE_LABEL
					  ,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN 'Rack BOH' 
					                                                                        WHEN MEASURE = 'PACK_EOH' THEN 'Rack Inventory' 
																						    ELSE MEASURE_LABEL END)
                             ELSE MEASURE_LABEL END) AS MEASURE_LABEL
					  , SORT_ORDER_NO
					  , XLS_KEY1    
					  , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
					  , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
					  , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
					  , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
					  , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
					  , WQTY51, WQTY52

					  , (CASE  WHEN OPERATION_ID ='-'                THEN 'ZZZ' ELSE OPERATION_ID END ) AS ORD2
					  , ORD3
					  , ORD1
					  , ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					  , ATTRIBUTE6
				  FROM (
						SELECT  DISTINCT   DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, OPERATION_GROUP
								, OPERATION_GROUP_NAME
								, (CASE WHEN ITEM_ID <> '-' THEN (CASE WHEN OPERATION_GROUP = 'P' AND CELL_ITEM_ID <> ITEM_ID THEN (SELECT DISTINCT (CASE WHEN ATTRIBUTE3 = 'Y' THEN 'R' ELSE P.OPERATION_GROUP END) AS CK_GROUP_ID
																																	   FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
																																	  WHERE F.DIVISION_ID = P.DIVISION_ID
																									  									AND F.ITEM_ID = P.ITEM_ID
																																	) 
																	   WHEN OPERATION_GROUP = 'P' AND CELL_ITEM_ID = ITEM_ID THEN OPERATION_GROUP
																	   WHEN OPERATION_GROUP = 'A' THEN OPERATION_GROUP
																  END)
										WHEN SUBSTRING(PROD_LINE,3,1) = 'R' THEN 'R'
										ELSE OPERATION_GROUP
									END
								  ) AS CK_GROUP_ID
								, FROM_SITE
								, FROM_SITE_DESCRIPTION
								, (CASE WHEN CHARINDEX('_', OPERATION_ID, 1) > 0 THEN LEFT(OPERATION_ID, CHARINDEX('_', OPERATION_ID, 1)-1)
								        ELSE OPERATION_ID END) AS OPERATION_ID
								, PROD_LINE

								--2021.03.26  KSW      C20210323-000513 - GSCM 시뮬레이터의 라인 가동율 정확도 향상을 위한 로직 변경 건 - Model Change Measure 추가 - start
								--, CELL_ITEM_ID
								--
								, (CASE WHEN MEASURE IN ('PACK_WORKING_TIME', 'PACK_TOTAL_TIME', 'CELL_WORKING_TIME', 'CELL_TOTAL_TIME', 'CELL_MODEL_CHANGE') THEN '-' ELSE CELL_ITEM_ID END) AS CELL_ITEM_ID
								--2021.03.26  KSW      C20210323-000513 - GSCM 시뮬레이터의 라인 가동율 정확도 향상을 위한 로직 변경 건 - Model Change Measure 추가 - end

								, ITEM_ID
								, NICK_NAME
								, DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
								, FROM_BOH_QTY
								, YIELD
								, LT_DAY
								, CELL_QTY_PACK
								, TO_SITE
								, TO_SITE_DESCRIPTION
								, BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								, MEASURE
								, MEASURE_LABEL
								, SORT_ORDER_NO
								, XLS_KEY1     
								, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
								, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
								, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
								, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
								, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
								, WQTY51, WQTY52

								--,(CASE  WHEN OPERATION_ID ='-'                THEN 'ZZZ' ELSE OPERATION_ID END ) AS ORD2
								,(CASE  WHEN MEASURE = 'PACK_CELL_BOH'        THEN ITEM_ID
										WHEN MEASURE = 'PACK_CELL_EOH'        THEN ITEM_ID
										WHEN MEASURE = 'PACK_CELL_EOH_TOTAL'  THEN ITEM_ID
										WHEN MEASURE = 'PACK_CELL_EOH_TOTAL_SUM'  THEN 'ZZZ'		-- 2022.05.23   KSW			  ESS Pack 시뮬레이터 가동율시트 - Cell Total measure 추가
								  ELSE NULL END ) AS ORD3
								 ,(CASE  WHEN MEASURE = 'SEMI_PACK_PROD_CELL' THEN '-' ELSE FROM_SITE END) AS ORD1
								 , ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								 , ATTRIBUTE6
						FROM FN_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK(@p_create_to_yyyymmdd_1, @p_create_to_yyyymmdd_2, @v_bp_flag)  P 							
						WHERE 0 = 0
						
				--        ORDER BY  OPERATION_GROUP DESC
				----                , FROM_SITE
				--                , (CASE  WHEN MEASURE = 'SEMI_PACK_PROD_CELL' THEN '-' ELSE FROM_SITE END)
				--                , (CASE WHEN OPERATION_ID ='-' THEN 'ZZZ' ELSE OPERATION_ID END ) 
				--                , PROD_LINE
				--                --, SORT_ORDER_NO
				--                ,(CASE  WHEN MEASURE = 'PACK_CELL_BOH'        THEN ITEM_ID
				--                        WHEN MEASURE = 'PACK_CELL_EOH'        THEN ITEM_ID
				--                        WHEN MEASURE = 'PACK_CELL_EOH_TOTAL'  THEN ITEM_ID
				--                  ELSE NULL END )
				--                , XLS_KEY1
				--                , SORT_ORDER_NO
						UNION ALL
						SELECT DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, OPERATION_GROUP
								, OPERATION_GROUP_NAME
								, CK_GROUP_ID
								, FROM_SITE
								, FROM_SITE_DESCRIPTION
								, OPERATION_ID
								, PROD_LINE
								, LEFT(X0.CELL_ITEM_ID, CHARINDEX('|', X0.CELL_ITEM_ID)-1) AS CELL_ITEM_ID
								, ITEM_ID
								, NICK_NAME
								, WEEKLY_CAPA_QTY
								, FROM_BOH_QTY
								, YIELD
								, LT_DAY
								, CONVERT(NUMERIC, SUBSTRING(X0.CELL_ITEM_ID, CHARINDEX('|', X0.CELL_ITEM_ID) + 1, LEN(X0.CELL_ITEM_ID)-CHARINDEX('|', X0.CELL_ITEM_ID))) AS CELL_QTY_PACK
								, TO_SITE
								, TO_SITE_DESCRIPTION
								, BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								, MEASURE
								, MEASURE_LABEL
								, SORT_ORDER_NO
								, XLS_KEY1   
								, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
								, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
								, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
								, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
								, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
								, WQTY51, WQTY52

								, ORD3
								, ORD1
								, ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								, ATTRIBUTE6
						  FROM (
								SELECT  DISTINCT   DIVISION_ID
										, PLAN_START_YYYYMMDD
										, PLAN_TYPE
										, SEQ
										, 'A'    AS OPERATION_GROUP
										, 'Rack' AS OPERATION_GROUP_NAME
										, 'A'    AS CK_GROUP_ID
										, FROM_SITE
										, FROM_SITE_DESCRIPTION
										, NULL   AS OPERATION_ID
										, '-'    AS PROD_LINE
										--, CELL_ITEM_ID
										, (SELECT distinct 
													 a.child_item_id + '|' + CONVERT(NVARCHAR, a.accumulated_child_qty) AS BOM_INFO
											 FROM    dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK)

													 --LEFT JOIN dbo.scm_mst_final_item_v b WITH (NOLOCK)
													 LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn FROM scm_mst_final_item_v WITH (NOLOCK)) b
													 ON   a.division_id = b.division_id
													 AND  a.child_item_id = b.item_id 

													 -- 20201102 PJ20202001 :  Rack Item 제외 조건 추가
													 LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn FROM scm_mst_final_item_v WITH (NOLOCK)) c
													 ON   a.division_id = c.division_id
													 AND  a.model_id    = c.item_id 

											 WHERE   a.division_id          = '82'
											 AND     a.model_id            < > a.child_item_id
											 AND     a.model_id             = P.ITEM_ID
											 AND     a.operation_group_id   = 'P'  -- Child가 Pack
											 AND     ISNULL(c.rack_yn, 'N') = 'Y'  -- 20201102 PJ20202001 :  Rack Item
											 AND     a.child_item_id IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK) WHERE DIVISION_ID = '82' AND CELL_ITEM_ID = P.CELL_ITEM_ID AND OPERATION_GROUP = 'P')
										  ) AS CELL_ITEM_ID
										, ITEM_ID
										, NICK_NAME
										, DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
										, FROM_BOH_QTY
										, YIELD
										, LT_DAY
										, CELL_QTY_PACK
										, NULL AS TO_SITE
										, NULL AS TO_SITE_DESCRIPTION
										, '-'  AS BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										, 'SEMI_PACK_PROD_CELL'   AS MEASURE
										, 'Production(Pack)'      AS MEASURE_LABEL
										, '310'                   AS SORT_ORDER_NO
										, '9999999'               AS XLS_KEY1    
		
										, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
										, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
										, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
										, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
										, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
										, WQTY51, WQTY52

										--,(CASE  WHEN OPERATION_ID ='-'                THEN 'ZZZ' ELSE OPERATION_ID END ) AS ORD2
										,(CASE  WHEN MEASURE = 'PACK_CELL_BOH'        THEN ITEM_ID
												WHEN MEASURE = 'PACK_CELL_EOH'        THEN ITEM_ID
												WHEN MEASURE = 'PACK_CELL_EOH_TOTAL'  THEN ITEM_ID
												WHEN MEASURE = 'PACK_CELL_EOH_TOTAL_SUM'  THEN 'ZZZ'		-- 2022.05.23   KSW			  ESS Pack 시뮬레이터 가동율시트 - Cell Total measure 추가
										  ELSE NULL END ) AS ORD3
										 ,'-'   AS ORD1
										 , ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										 , ATTRIBUTE6
								FROM FN_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK(@p_create_to_yyyymmdd_1, @p_create_to_yyyymmdd_2, @v_bp_flag)  P
								WHERE 0 = 0
								  AND MEASURE = 'PACK_PROD'
								  AND (SELECT DISTINCT ATTRIBUTE3
										 FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
										WHERE F.DIVISION_ID = P.DIVISION_ID
										AND F.ITEM_ID = P.ITEM_ID
									  ) = 'Y' 
						       ) X0 
					   ) X
		       ) XX
		WHERE FROM_SITE IS NOT NULL
		AND (CASE WHEN @P_PARAMETER1 = '' or @P_PARAMETER1 is null THEN CELL_ITEM_ID 
				ELSE @P_PARAMETER1 END) = CELL_ITEM_ID -- 파라미터 입력테스트 지원::2023.07.02, KSK
		 AND  (
			NOT ((OPERATION_GROUP = 'A' AND ISNULL(TO_SITE, '-') = '-' ) --- ADD DHJ		  
		          AND (SELECT  DBO.FN_GET_FINAL_ITEM('82', ITEM_ID, 'CELL_TYPE')) ='CP'			
				 )
            OR (MEASURE = 'SEMI_PACK_PROD_CELL') -- NOT 조건에 포함되나 표시되어야 함
		  /* 집계메저(CELL_LOAD_RATIO 및 CELL_MODEL_CHANGE)의 경우 
		   셀품목이 없고 제품라인은 있으므로 화면출력을 추가제공함, KSK, 2023-07-10 */
			OR ( CELL_ITEM_ID = '-' AND PROD_LINE != '-' )	--- 운영에서 저장 이슈 계속 관찰요망
		  )

	   ORDER BY  GROUP_SEQ
			   , ORD1
			   , ORD2
			   , PROD_LINE
			   , ORD3
			   , XLS_KEY1
			   , SORT_ORDER_NO
			   ;
	  END
	  --'XLSPSI06' 
      IF @v_bp_flag = 'Y'
	  BEGIN 
	  -- new version
        SELECT  DIVISION_ID
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              --, OPERATION_GROUP
              ,(CASE WHEN GROUP_SEQ = 1 THEN 'R' WHEN GROUP_SEQ = '2' THEN 'P' ELSE 'A' END) AS OPERATION_GROUP
              --, OPERATION_GROUP_NAME
              --,(CASE WHEN GROUP_SEQ2 = 1 THEN 'Rack' WHEN GROUP_SEQ2 = '2' THEN 'Pack' ELSE 'Cell' END) AS OPERATION_GROUP_NAME
			  ,(CASE WHEN GROUP_SEQ2 = 1 THEN 'Rack' ELSE OPERATION_GROUP_NAME END) AS OPERATION_GROUP_NAME
              , FROM_SITE
              , FROM_SITE_DESCRIPTION
              , OPERATION_ID
              , PROD_LINE
              , CELL_ITEM_ID
              , ITEM_ID
              , NICK_NAME
              , WEEKLY_CAPA_QTY
              , FROM_BOH_QTY
              , YIELD
              , LT_DAY
              , CELL_QTY_PACK
              , TO_SITE
              , TO_SITE_DESCRIPTION
			  , BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
              , MEASURE
              , MEASURE_LABEL
              , SORT_ORDER_NO
              , XLS_KEY1     
              , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
              , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
              , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
              , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
              , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
              , WQTY51, WQTY52

			  -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
			  , WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
			  , WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
		      , WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
			  , WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
			  , WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
			  , WQTY103,WQTY104

              , ORD2
              , ORD3
              , ORD1
			  ,'''' + ATTRIBUTE3 AS ATTRIBUTE3		--ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			  , ATTRIBUTE6
		  FROM (
				SELECT  DIVISION_ID
					  , PLAN_START_YYYYMMDD
					  , PLAN_TYPE
					  , SEQ
					  , OPERATION_GROUP
					  , OPERATION_GROUP_NAME
					  , (CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 2
							  WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
							  ELSE 3 END) GROUP_SEQ
					  , (CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 1
							  WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
							  ELSE 3 END) GROUP_SEQ2
					  , FROM_SITE
					  , FROM_SITE_DESCRIPTION
					  , OPERATION_ID
					  , PROD_LINE
					  , CELL_ITEM_ID
					  , ITEM_ID
					  , NICK_NAME
					  , WEEKLY_CAPA_QTY
					  , FROM_BOH_QTY
					  , YIELD
					  , LT_DAY
					  , CELL_QTY_PACK
					  , TO_SITE
					  , TO_SITE_DESCRIPTION
					  , BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					  , MEASURE
					  --, MEASURE_LABEL
					  ,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN 'Rack BOH' 
					                                                                        WHEN MEASURE = 'PACK_EOH' THEN 'Rack Inventory' 
																						    ELSE MEASURE_LABEL END)
                             ELSE MEASURE_LABEL END) AS MEASURE_LABEL
					  , SORT_ORDER_NO
					  , XLS_KEY1
					  , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
					  , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
					  , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
					  , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
					  , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
					  , WQTY51, WQTY52

					  -- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
					  , WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
					  , WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
					  , WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
					  , WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
					  , WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
					  , WQTY103,WQTY104

					  , (CASE  WHEN OPERATION_ID ='-'                THEN 'ZZZ' ELSE OPERATION_ID END ) AS ORD2
					  , ORD3
					  , ORD1
					  , ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					  , ATTRIBUTE6
				  FROM (
						SELECT  DISTINCT   DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, OPERATION_GROUP
								, OPERATION_GROUP_NAME
								, (CASE WHEN ITEM_ID <> '-' THEN (CASE WHEN OPERATION_GROUP = 'P' AND CELL_ITEM_ID <> ITEM_ID THEN (SELECT DISTINCT (CASE WHEN ATTRIBUTE3 = 'Y' THEN 'R' ELSE P.OPERATION_GROUP END) AS CK_GROUP_ID
																																	   FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
																																	  WHERE F.DIVISION_ID = P.DIVISION_ID
																									  									AND F.ITEM_ID = P.ITEM_ID
																																	) 
																	   WHEN OPERATION_GROUP = 'P' AND CELL_ITEM_ID = ITEM_ID THEN OPERATION_GROUP
																	   WHEN OPERATION_GROUP = 'A' THEN OPERATION_GROUP
																  END)
										WHEN SUBSTRING(PROD_LINE,3,1) = 'R' THEN 'R'
										ELSE OPERATION_GROUP
									END
								  ) AS CK_GROUP_ID
								, FROM_SITE
								, FROM_SITE_DESCRIPTION
								, (CASE WHEN CHARINDEX('_', OPERATION_ID, 1) > 0 THEN LEFT(OPERATION_ID, CHARINDEX('_', OPERATION_ID, 1)-1)
								        ELSE OPERATION_ID END) AS OPERATION_ID
								, PROD_LINE

								--2021.03.26  KSW      C20210323-000513 - GSCM 시뮬레이터의 라인 가동율 정확도 향상을 위한 로직 변경 건 - Model Change Measure 추가 - start
								--, CELL_ITEM_ID
								--
								, (CASE WHEN MEASURE IN ('PACK_WORKING_TIME', 'PACK_TOTAL_TIME', 'CELL_WORKING_TIME', 'CELL_TOTAL_TIME', 'CELL_MODEL_CHANGE') THEN '-' ELSE CELL_ITEM_ID END) AS CELL_ITEM_ID
								--2021.03.26  KSW      C20210323-000513 - GSCM 시뮬레이터의 라인 가동율 정확도 향상을 위한 로직 변경 건 - Model Change Measure 추가 - end

								, ITEM_ID
								, NICK_NAME
								, DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
								, FROM_BOH_QTY
								, YIELD
								, LT_DAY
								, CELL_QTY_PACK
								, TO_SITE
								, TO_SITE_DESCRIPTION
								, BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								, MEASURE
								, MEASURE_LABEL
								, SORT_ORDER_NO
								, XLS_KEY1 						
								, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
								, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
								, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
								, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
								, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
								, WQTY51, WQTY52

								-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
								, WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
								, WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
								, WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
								, WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
							    , WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
							    , WQTY103,WQTY104

								--,(CASE  WHEN OPERATION_ID ='-'                THEN 'ZZZ' ELSE OPERATION_ID END ) AS ORD2
								,(CASE  WHEN MEASURE = 'PACK_CELL_BOH'        THEN ITEM_ID
										WHEN MEASURE = 'PACK_CELL_EOH'        THEN ITEM_ID
										WHEN MEASURE = 'PACK_CELL_EOH_TOTAL'  THEN ITEM_ID
										WHEN MEASURE = 'PACK_CELL_EOH_TOTAL_SUM'  THEN 'ZZZ'		-- 2022.05.23   KSW			  ESS Pack 시뮬레이터 가동율시트 - Cell Total measure 추가
								  ELSE NULL END ) AS ORD3
								 ,(CASE  WHEN MEASURE = 'SEMI_PACK_PROD_CELL' THEN '-' ELSE FROM_SITE END) AS ORD1
								 , ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								 , ATTRIBUTE6
						FROM  FN_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK(@p_create_to_yyyymmdd_1, @p_create_to_yyyymmdd_2, @v_bp_flag)  P 
						WHERE 0 = 0
						 
				--        ORDER BY  OPERATION_GROUP DESC
				----                , FROM_SITE
				--                , (CASE  WHEN MEASURE = 'SEMI_PACK_PROD_CELL' THEN '-' ELSE FROM_SITE END)
				--                , (CASE WHEN OPERATION_ID ='-' THEN 'ZZZ' ELSE OPERATION_ID END ) 
				--                , PROD_LINE
				--                --, SORT_ORDER_NO
				--                ,(CASE  WHEN MEASURE = 'PACK_CELL_BOH'        THEN ITEM_ID
				--                        WHEN MEASURE = 'PACK_CELL_EOH'        THEN ITEM_ID
				--                        WHEN MEASURE = 'PACK_CELL_EOH_TOTAL'  THEN ITEM_ID
				--                  ELSE NULL END )
				--                , XLS_KEY1
				--                , SORT_ORDER_NO
						UNION ALL
						SELECT DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, OPERATION_GROUP
								, OPERATION_GROUP_NAME
								, CK_GROUP_ID
								, FROM_SITE
								, FROM_SITE_DESCRIPTION
								, OPERATION_ID
								, PROD_LINE
								, LEFT(X0.CELL_ITEM_ID, CHARINDEX('|', X0.CELL_ITEM_ID)-1) AS CELL_ITEM_ID
								, ITEM_ID
								, NICK_NAME
								, WEEKLY_CAPA_QTY
								, FROM_BOH_QTY
								, YIELD
								, LT_DAY
								, CONVERT(NUMERIC, SUBSTRING(X0.CELL_ITEM_ID, CHARINDEX('|', X0.CELL_ITEM_ID) + 1, LEN(X0.CELL_ITEM_ID)-CHARINDEX('|', X0.CELL_ITEM_ID))) AS CELL_QTY_PACK
								, TO_SITE
								, TO_SITE_DESCRIPTION
								, BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
								, MEASURE
								, MEASURE_LABEL
								, SORT_ORDER_NO
								, XLS_KEY1    
								, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
								, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
								, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
								, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
								, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
								, WQTY51, WQTY52

								-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
							    , WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
							    , WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
							    , WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
								, WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
							    , WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
							    , WQTY103,WQTY104

								, ORD3
								, ORD1
								, ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
						        , ATTRIBUTE6
						  FROM (
								SELECT  DISTINCT   DIVISION_ID
										, PLAN_START_YYYYMMDD
										, PLAN_TYPE
										, SEQ
										, 'A'    AS OPERATION_GROUP
										, 'Rack' AS OPERATION_GROUP_NAME
										, 'A'    AS CK_GROUP_ID
										, FROM_SITE
										, FROM_SITE_DESCRIPTION
										, NULL   AS OPERATION_ID
										, '-'    AS PROD_LINE
										--, CELL_ITEM_ID
										, (SELECT distinct 
													 a.child_item_id + '|' + CONVERT(NVARCHAR, a.accumulated_child_qty) AS BOM_INFO
											 FROM    dbo.scm_mst_model_final_item_bom_v a WITH(NOLOCK)

													 --LEFT JOIN dbo.scm_mst_final_item_v b WITH (NOLOCK)
													 LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn FROM scm_mst_final_item_v WITH (NOLOCK)) b
													 ON   a.division_id = b.division_id
													 AND  a.child_item_id = b.item_id 

													 -- 20201102 PJ20202001 :  Rack Item 제외 조건 추가
													 LEFT JOIN (SELECT DISTINCT division_id, item_id, operation_group_id, tco_cell_yn, rack_yn FROM scm_mst_final_item_v WITH (NOLOCK)) c
													 ON   a.division_id = c.division_id
													 AND  a.model_id    = c.item_id 

											 WHERE   a.division_id          = '82'
											 AND     a.model_id            < > a.child_item_id
											 AND     a.model_id             = P.ITEM_ID
											 AND     a.operation_group_id   = 'P'  -- Child가 Pack
											 AND     ISNULL(c.rack_yn, 'N') = 'Y'  -- 20201102 PJ20202001 :  Rack Item
											 AND     a.child_item_id IN (SELECT DISTINCT ITEM_ID FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK) WHERE DIVISION_ID = '82' AND CELL_ITEM_ID = P.CELL_ITEM_ID AND OPERATION_GROUP = 'P')
										  ) AS CELL_ITEM_ID
										, ITEM_ID
										, NICK_NAME
										, DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
										, FROM_BOH_QTY
										, YIELD
										, LT_DAY
										, CELL_QTY_PACK
										, NULL AS TO_SITE
										, NULL AS TO_SITE_DESCRIPTION
										, '-'  AS BOD_ID			-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										, 'SEMI_PACK_PROD_CELL'   AS MEASURE
										, 'Production(Pack)'      AS MEASURE_LABEL
										, '310'                   AS SORT_ORDER_NO
										, '9999999'               AS XLS_KEY1  
										, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
										, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
										, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
										, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
										, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
										, WQTY51, WQTY52

										-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
									    , WQTY53, WQTY54, WQTY55, WQTY56, WQTY57, WQTY58, WQTY59, WQTY60, WQTY61, WQTY62 
									    , WQTY63, WQTY64, WQTY65, WQTY66, WQTY67, WQTY68, WQTY69, WQTY70, WQTY71, WQTY72 
									    , WQTY73, WQTY74, WQTY75, WQTY76, WQTY77, WQTY78, WQTY79, WQTY80, WQTY81, WQTY82
									    , WQTY83, WQTY84, WQTY85, WQTY86, WQTY87, WQTY88, WQTY89, WQTY90, WQTY91, WQTY92		-- 중장기 +1 Year 변경처리 :: 2022.08.11 컬럼활성화
									    , WQTY93, WQTY94, WQTY95, WQTY96, WQTY97, WQTY98, WQTY99, WQTY100,WQTY101,WQTY102
									    , WQTY103,WQTY104

										--,(CASE  WHEN OPERATION_ID ='-'                THEN 'ZZZ' ELSE OPERATION_ID END ) AS ORD2
										,(CASE  WHEN MEASURE = 'PACK_CELL_BOH'        THEN ITEM_ID
												WHEN MEASURE = 'PACK_CELL_EOH'        THEN ITEM_ID
												WHEN MEASURE = 'PACK_CELL_EOH_TOTAL'  THEN ITEM_ID
												WHEN MEASURE = 'PACK_CELL_EOH_TOTAL_SUM'  THEN 'ZZZ'		-- 2022.05.23   KSW			  ESS Pack 시뮬레이터 가동율시트 - Cell Total measure 추가
										  ELSE NULL END ) AS ORD3
										 ,'-'   AS ORD1
										 , ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
										 , ATTRIBUTE6
								FROM FN_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_PACK(@p_create_to_yyyymmdd_1, @p_create_to_yyyymmdd_2, @v_bp_flag)  P 							
								WHERE 0 = 0
								  AND MEASURE = 'PACK_PROD'
								  AND (SELECT DISTINCT ATTRIBUTE3
										 FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
										WHERE F.DIVISION_ID = P.DIVISION_ID
										AND F.ITEM_ID = P.ITEM_ID
									  ) = 'Y' 
						       ) X0 
					   ) X
		       ) XX
		WHERE FROM_SITE IS NOT NULL
		AND (CASE WHEN @P_PARAMETER1 = '' or @P_PARAMETER1 is null THEN CELL_ITEM_ID 
				ELSE @P_PARAMETER1 END) = CELL_ITEM_ID -- 파라미터 입력테스트 지원::2023.07.02, KSK
		 AND  (
			NOT ((OPERATION_GROUP = 'A' AND ISNULL(TO_SITE, '-') = '-' ) --- ADD DHJ		  
		          AND (SELECT  DBO.FN_GET_FINAL_ITEM('82', ITEM_ID, 'CELL_TYPE')) ='CP'			
				 )
            OR (MEASURE = 'SEMI_PACK_PROD_CELL') -- NOT 조건에 포함되나 표시되어야 함
		  /* 집계메저(CELL_LOAD_RATIO 및 CELL_MODEL_CHANGE)의 경우 
		   셀품목이 없고 제품라인은 있으므로 화면출력을 추가제공함, KSK, 2023-07-10 */
			OR ( CELL_ITEM_ID = '-' AND PROD_LINE != '-' )	--- 운영에서 저장 이슈 계속 관찰요망
		  )

	   ORDER BY  GROUP_SEQ
			   , ORD1
			   , ORD2
			   , PROD_LINE
			   , ORD3
			   , XLS_KEY1
			   , SORT_ORDER_NO  --
		;
	  END
	  -- 2020.10.29   KSW           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ESS RACK biz. 대응 - end

      END 

     END

  -----------------------------------------
  -- XLSPSI07: ESS GLOBAL PSI SIMULATION CELL
  -----------------------------------------
  IF @P_PGM_CODE = 'XLSPSI07' 
     BEGIN

     IF @p_parameter1 <> ''
     SET @p_parameter3 = @p_parameter1
         
     IF @p_parameter4 =''
      BEGIN 

	  -- 2020.10.29   KSW           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ESS RACK biz. 대응 - start
	  -- old version
	  --
   --   SELECT DIVISION_ID
   --         ,PLAN_START_YYYYMMDD
   --         ,PLAN_TYPE
   --         ,SEQ
   --         ,OPERATION_GROUP
   --         ,OPERATION_GROUP_NAME
   --         ,CELL_ITEM_ID
   --         ,ITEM_ID
   --         ,NICK_NAME
   --         ,CELL_QTY_PACK
   --         ,TO_SITE
   --         ,TO_SITE_DESCRIPTION
   --         ,PROJECT_CODE
   --         ,ATTRIBUTE8 AS PROJECT_NAME
   --         ,FROM_BOH_QTY
   --         ,TO_BOH_QTY
   --         ,INCOTERMS
   --         ,FROM_SITE
   --         ,FROM_SITE_DESCRIPTION
   --         ,TRANSPORT_MODE
   --         ,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
			--      ,YIELD
   --         ,PROD_LINE
   --         ,BOD_ID
			--,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
			--,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
   --         ,MEASURE
   --         ,MEASURE_LABEL
   --         ,XLS_KEY1
   --         ,XLS_KEY2
   --         ,XLS_KEY3
   --         ,XLS_KEY4
   --         ,XLS_KEY5
   --         ,XLS_ATTRIBUTE1
   --         ,XLS_ATTRIBUTE2
   --         ,XLS_ATTRIBUTE3
   --         ,XLS_ATTRIBUTE4
   --         ,XLS_ATTRIBUTE5
   --         ,SORT_ORDER_NO

            
           
   --         ,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
   --         ,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16
   --         ,WQTY17,WQTY18,WQTY19,WQTY20
   --         ,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
   --         ,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
   --         ,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
   --         ,WQTY51,WQTY52
            

   --         ,CREATED_BY
   --         ,CREATION_DATE
   --         ,LAST_UPDATED_BY
   --         ,LAST_UPDATE_DATE
   --         ,ATTRIBUTE1
   --         ,ATTRIBUTE10
   --     FROM SCP_XLS_PSI_GLOBAL_ESS  WITH (NOLOCK)
   --    WHERE 0 = 0 
   --       AND SORT_ORDER_NO NOT IN ('135','136','161','162','165','172','173','185','430','492','495')  -- PACK 로드율 계산을 위해 추가 된 MEASURE
   --       AND DIVISION_ID   = @p_division_id
   --       AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))
   --   ORDER BY CONVERT(INT, XLS_KEY1)
   --   ;

   -- rack biz. new version
     
      SELECT DIVISION_ID
			,PLAN_START_YYYYMMDD
			,PLAN_TYPE
			,SEQ
			,(CASE WHEN GROUP_SEQ = 1 THEN 'R' WHEN GROUP_SEQ = '2' THEN 'P' ELSE 'A' END) AS OPERATION_GROUP
			,(CASE WHEN GROUP_SEQ = 1 THEN 'Rack' WHEN GROUP_SEQ = '2' THEN 'Pack' ELSE 'Cell' END) AS OPERATION_GROUP_NAME
			,CELL_ITEM_ID
			,ITEM_ID
			,NICK_NAME
			,CELL_QTY_PACK
			,TO_SITE
			,TO_SITE_DESCRIPTION
			,PROJECT_CODE
			,PROJECT_NAME
			,FROM_BOH_QTY
			,TO_BOH_QTY
			,INCOTERMS
			,FROM_SITE
			,FROM_SITE_DESCRIPTION
			,TRANSPORT_MODE
			,LT_DAY
			,YIELD
			,PROD_LINE
			,BOD_ID
			,GRO_STD_DIO
			,MIN_STD_DIO
			,MEASURE
			,MEASURE_LABEL
			,XLS_KEY1
			,XLS_KEY2
			,XLS_KEY3
			,XLS_KEY4
			,XLS_KEY5
			,XLS_ATTRIBUTE1
			,XLS_ATTRIBUTE2
			,XLS_ATTRIBUTE3
			,XLS_ATTRIBUTE4
			,XLS_ATTRIBUTE5
			,SORT_ORDER_NO
			,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
			,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16
			,WQTY17,WQTY18,WQTY19,WQTY20
			,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
			,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
			,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
			,WQTY51,WQTY52
			,CREATED_BY
			,CREATION_DATE
			,LAST_UPDATED_BY
			,LAST_UPDATE_DATE
			,ATTRIBUTE1
			,'''' + ATTRIBUTE3 AS ATTRIBUTE3			--,ATTRIBUTE10		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
			, ATTRIBUTE6
	    FROM (
			  SELECT DIVISION_ID
					,PLAN_START_YYYYMMDD
					,PLAN_TYPE
					,SEQ
					,OPERATION_GROUP
					,OPERATION_GROUP_NAME
					--,(CASE WHEN CK_GROUP_ID IS NULL THEN X.OPERATION_GROUP ELSE CK_GROUP_ID END) AS CK_GROUP
					,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 1
						   WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
						   ELSE 3 END) GROUP_SEQ
					,CELL_ITEM_ID
					,ITEM_ID
					,NICK_NAME
					,CELL_QTY_PACK
					,TO_SITE
					,TO_SITE_DESCRIPTION
					,PROJECT_CODE
					,PROJECT_NAME
					,FROM_BOH_QTY
					,TO_BOH_QTY
					,INCOTERMS
					,FROM_SITE
					,FROM_SITE_DESCRIPTION
					,TRANSPORT_MODE
					,LT_DAY
					,YIELD
					,PROD_LINE
					,BOD_ID
					,GRO_STD_DIO
					,MIN_STD_DIO
					,MEASURE
					,(CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN (CASE WHEN MEASURE = 'PACK_BOH' THEN 'Rack BOH' 
					                                                                      WHEN MEASURE = 'PACK_EOH' THEN 'Rack Inventory' 
																						  ELSE MEASURE_LABEL END)
                           ELSE MEASURE_LABEL END) AS MEASURE_LABEL
					,XLS_KEY1
					,XLS_KEY2
					,XLS_KEY3
					,XLS_KEY4
					,XLS_KEY5
					,XLS_ATTRIBUTE1
					,XLS_ATTRIBUTE2
					,XLS_ATTRIBUTE3
					,XLS_ATTRIBUTE4
					,XLS_ATTRIBUTE5
					,SORT_ORDER_NO
					,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
					,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
					,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
					,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
					,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
					,WQTY51,WQTY52
					,CREATED_BY
					,CREATION_DATE
					,LAST_UPDATED_BY
					,LAST_UPDATE_DATE
					,ATTRIBUTE1
					,ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
					,ATTRIBUTE10   
					,ATTRIBUTE6   
					, (CASE WHEN MEASURE IN ('PACK_CELL_BOH', 'PACK_CELL_EOH') THEN '9' ELSE LEFT(ATTRIBUTE6, 1) END) AS DC_LINKORDER
				FROM (
					  SELECT DIVISION_ID
							,PLAN_START_YYYYMMDD
							,PLAN_TYPE
							,SEQ
							,OPERATION_GROUP
							,OPERATION_GROUP_NAME
							,(SELECT DISTINCT (CASE WHEN ATTRIBUTE3 = 'Y' THEN 'R' ELSE P.OPERATION_GROUP END) AS CK_GROUP_ID
								FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
							   WHERE F.DIVISION_ID = P.DIVISION_ID
								 AND F.ITEM_ID = P.ITEM_ID
							 ) AS CK_GROUP_ID
							,CELL_ITEM_ID
							,ITEM_ID
							,NICK_NAME
							,CELL_QTY_PACK
							,TO_SITE
							,TO_SITE_DESCRIPTION
							,PROJECT_CODE
							,ATTRIBUTE8 AS PROJECT_NAME
							,FROM_BOH_QTY
							,TO_BOH_QTY
							,INCOTERMS
							,FROM_SITE
							,FROM_SITE_DESCRIPTION
							,TRANSPORT_MODE
							,(CASE WHEN   (TRANSPORT_MODE ='-')  AND (MEASURE <> 'CELL_PROD') THEN '-' ELSE CONVERT(NVARCHAR,LT_DAY) END ) AS LT_DAY
							,YIELD
							,PROD_LINE
							,BOD_ID
							,ATTRIBUTE4 AS GRO_STD_DIO  -- DIO 수정 관련 (기준 컬럼추가)
							,ATTRIBUTE5 AS MIN_STD_DIO  -- DIO 수정 관련 (최소 컬럼추가)
							,MEASURE
							,MEASURE_LABEL
							,XLS_KEY1
							,XLS_KEY2
							,XLS_KEY3
							,XLS_KEY4
							,XLS_KEY5
							,XLS_ATTRIBUTE1
							,XLS_ATTRIBUTE2
							,XLS_ATTRIBUTE3
							,XLS_ATTRIBUTE4
							,XLS_ATTRIBUTE5
							,SORT_ORDER_NO
							,WQTY01,WQTY02,WQTY03,WQTY04,WQTY05,WQTY06,WQTY07,WQTY08,WQTY09,WQTY10
							,WQTY11,WQTY12,WQTY13,WQTY14,WQTY15,WQTY16,WQTY17,WQTY18,WQTY19,WQTY20
							,WQTY21,WQTY22,WQTY23,WQTY24,WQTY25,WQTY26,WQTY27,WQTY28,WQTY29,WQTY30
							,WQTY31,WQTY32,WQTY33,WQTY34,WQTY35,WQTY36,WQTY37,WQTY38,WQTY39,WQTY40
							,WQTY41,WQTY42,WQTY43,WQTY44,WQTY45,WQTY46,WQTY47,WQTY48,WQTY49,WQTY50
							,WQTY51,WQTY52
							,CREATED_BY
							,CREATION_DATE
							,LAST_UPDATED_BY
							,LAST_UPDATE_DATE
							,ATTRIBUTE1
							,ATTRIBUTE3		-- PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD L/T 2단계
							,ATTRIBUTE10  
							,ATTRIBUTE6     -- DC_LINK 참조열
						FROM SCP_XLS_PSI_GLOBAL_ESS P WITH (NOLOCK)
					   WHERE 0 = 0 
						  AND CREATE_FROM_YYYYMMDD = (SELECT DISTINCT PLAN_START_YYYYMMDD FROM SCP_XLS_PSI_GLOBAL_ESS WITH (NOLOCK))			-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응
						  AND SORT_ORDER_NO NOT IN ('135','136','161','162','165','172','173','185','430','492','495')  -- PACK 로드율 계산을 위해 추가 된 MEASURE
						  AND DIVISION_ID   = @p_division_id
						  AND CELL_ITEM_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_parameter3,','))
					  --ORDER BY CONVERT(INT, XLS_KEY1)
					 ) X
	         ) XX
	   ORDER BY CELL_ITEM_ID
	          , GROUP_SEQ
			  , DC_LINKORDER 
			  , XLS_KEY1
			  --, SORT_ORDER_NO  --원본 소스에 빠져 있음
      ;
	  -- 2020.10.29   KSW           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ESS RACK biz. 대응 - end
      END 


      IF @p_parameter4 ='prod_load'
      BEGIN 

	  -- 2020.10.29   KSW           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ESS RACK biz. 대응 - start
	  -- old version
	  --
      --  SELECT    DIVISION_ID
      --          , PLAN_START_YYYYMMDD
      --          , PLAN_TYPE
      --          , SEQ
      --          , OPERATION_GROUP
      --          , OPERATION_GROUP_NAME
      --          , FROM_SITE
      --          , FROM_SITE_DESCRIPTION
      --          , OPERATION_ID
      --          , ITEM_ID
      --          , NICK_NAME
      --          , PROD_LINE
      --          , DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
      --          , TACT_TIME
      --          , MEASURE
      --          , MEASURE_LABEL
      --          , SORT_ORDER_NO
      --          , XLS_KEY1
                
      --          , WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
      --          , WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
      --          , WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
      --          , WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
      --          , WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
      --          , WQTY51, WQTY52
      
      --  FROM SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_CELL_V WITH (NOLOCK)
      --  ORDER BY  OPERATION_GROUP DESC
      --          , FROM_SITE,OPERATION_ID
      --          , PROD_LINE
      --          , SORT_ORDER_NO
      --          , XLS_KEY1
      --;
	  -- rack biz. new version
        SELECT    DIVISION_ID
				, PLAN_START_YYYYMMDD
				, PLAN_TYPE
				, SEQ
				--, OPERATION_GROUP
				, (CASE WHEN GROUP_SEQ = 1 THEN 'R' WHEN GROUP_SEQ = '2' THEN 'P' ELSE 'A' END) AS OPERATION_GROUP
				--, OPERATION_GROUP_NAME
			    , (CASE WHEN GROUP_SEQ = 1 THEN 'Rack' WHEN GROUP_SEQ = '2' THEN 'Pack' ELSE 'Cell' END) AS OPERATION_GROUP_NAME
				, FROM_SITE
				, FROM_SITE_DESCRIPTION
				, OPERATION_ID
				, ITEM_ID
				, NICK_NAME
				, PROD_LINE
				, WEEKLY_CAPA_QTY
				, TACT_TIME
				, MEASURE
				, MEASURE_LABEL
				, SORT_ORDER_NO
				, XLS_KEY1
				, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
				, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
				, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
				, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
				, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
				, WQTY51, WQTY52
		  FROM (
				SELECT    DIVISION_ID
						, PLAN_START_YYYYMMDD
						, PLAN_TYPE
						, SEQ
						, OPERATION_GROUP
						, OPERATION_GROUP_NAME
						, (CASE WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'R' THEN 1
								WHEN ISNULL(X.CK_GROUP_ID, X.OPERATION_GROUP) = 'P' THEN 2
								ELSE 3 END) GROUP_SEQ
						, FROM_SITE
						, FROM_SITE_DESCRIPTION
						, OPERATION_ID
						, ITEM_ID
						, NICK_NAME
						, PROD_LINE
						, WEEKLY_CAPA_QTY
						, TACT_TIME
						, MEASURE
						, MEASURE_LABEL
						, SORT_ORDER_NO
						, XLS_KEY1
						, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
						, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
						, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
						, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
						, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
						, WQTY51, WQTY52
				  FROM (
						SELECT    DIVISION_ID
								, PLAN_START_YYYYMMDD
								, PLAN_TYPE
								, SEQ
								, OPERATION_GROUP
								, OPERATION_GROUP_NAME
								, (CASE WHEN P.ITEM_ID <> '-' THEN (SELECT DISTINCT (CASE WHEN ATTRIBUTE3 = 'Y' THEN 'R' ELSE P.OPERATION_GROUP END) AS CK_GROUP_ID
																	  FROM SCP_MST_FINAL_ITEM F WITH (NOLOCK)
																     WHERE F.DIVISION_ID = P.DIVISION_ID
																	   AND F.ITEM_ID = P.ITEM_ID)
										WHEN SUBSTRING(P.PROD_LINE, 3, 1) = 'R' THEN 'R' 
										ELSE OPERATION_GROUP
								   END) AS CK_GROUP_ID
								, FROM_SITE
								, FROM_SITE_DESCRIPTION
								, OPERATION_ID
								, ITEM_ID
								, NICK_NAME
								, PROD_LINE
								, DAILY_CAPA_QTY * 7 AS WEEKLY_CAPA_QTY
								, TACT_TIME
								, MEASURE
								, MEASURE_LABEL
								, SORT_ORDER_NO
								, XLS_KEY1
								, WQTY01, WQTY02, WQTY03, WQTY04, WQTY05, WQTY06, WQTY07, WQTY08, WQTY09, WQTY10
								, WQTY11, WQTY12, WQTY13, WQTY14, WQTY15, WQTY16, WQTY17, WQTY18, WQTY19, WQTY20
								, WQTY21, WQTY22, WQTY23, WQTY24, WQTY25, WQTY26, WQTY27, WQTY28, WQTY29, WQTY30
								, WQTY31, WQTY32, WQTY33, WQTY34, WQTY35, WQTY36, WQTY37, WQTY38, WQTY39, WQTY40
								, WQTY41, WQTY42, WQTY43, WQTY44, WQTY45, WQTY46, WQTY47, WQTY48, WQTY49, WQTY50
								, WQTY51, WQTY52
								, '' AS CREATE_BY
								, '' AS CREATION_DATE
								, '' AS LAST_UPDATED_BY
								, '' AS LAST_UPDATE_DATE
								,(SELECT DISTINCT Y.ATTRIBUTE6
									FROM SCP_XLS_PSI_GLOBAL_ESS Y WITH (NOLOCK)
									WHERE P.DIVISION_ID = Y.DIVISION_ID
										AND P.ITEM_ID = Y.ITEM_ID
									) AS ATTRIBUTE6
						FROM SCP_XLS_PSI_GLOBAL_ESS_LOAD_RATIO_CELL_V P WITH (NOLOCK)					
						--AND P.CELL_ITEM_ID=B.CELL_ITEM_ID   
						--ORDER BY  OPERATION_GROUP DESC
						--        , FROM_SITE,OPERATION_ID
						--        , PROD_LINE
						--        , SORT_ORDER_NO
						--        , XLS_KEY1
					   ) X
		       ) XX
	   ORDER BY   GROUP_SEQ
				, FROM_SITE,OPERATION_ID
				, PROD_LINE 
				, SORT_ORDER_NO
				, XLS_KEY1
				
		 ;
	  -- 2020.10.29   KSW           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : ESS RACK biz. 대응 - end

      END 

      

     END

  -----------------------------------------
  -- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선'
  -- XLSPSI21: 소형 SHIPMENT PLAN 입력 SIMULATION
  -----------------------------------------  
    IF @P_PGM_CODE = 'XLSPSI21' 
    BEGIN

	SET @p_plan_start_yyyymmdd  = NULL;  --'20210510';

	SET @p_plan_type            = 'MA';
	SET @p_seq                  = NULL;  --'3';
	SET @eng_plan_id            = NULL; 

	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_plan_end_yyyymmdd    = NULL;
	SET @v_seq                  = NULL;
	SET @v_cols                 = NULL;
	SET @v_cols2                = NULL;
	SET @SQL                    = NULL;

	SET @v_plan_start_yyyymmdd = '';
	SET @v_seq = '';
	SET @v_cols = '';
	SET @v_cols2 = '';

	-- 파라미터 확인 
	SELECT    @v_plan_start_yyyymmdd = MAX(PLAN_START_YYYYMMDD)
			, @v_seq = SUBSTRING(MAX(ENG_PLAN_ID), CHARINDEX( @p_plan_Type +  '::', MAX(ENG_PLAN_ID)) + 4, 1)
			, @eng_plan_id = MAX(ENG_PLAN_ID)
		FROM DBO.SCP_PLAN_PARAMETER_V WITH (NOLOCK)
		WHERE MASTER_ID = '40::WEEKLY'
		AND ENG_PLAN_ID LIKE '%' + @p_plan_Type + '%'
	;

	IF @p_plan_start_yyyymmdd IS NULL
		SET @p_plan_start_yyyymmdd = @v_plan_start_yyyymmdd ;

	IF @p_seq IS NULL
		SET @p_seq = @v_seq ;


	IF @p_parameter2 = ''		-- SHIP REQ Sheet
		BEGIN

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 -> 364+182
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		-----------------
		-- Frozen 구간
		-----------------
		-- 2020.02.03 :: 소형 SHIPMENT PLAN 입력 SIMULATION 추가 - ship frozen 구간을 week plan 으로 변경 
		-- Frozen 구간을 위한 변수추가
		SET @v_frozen_end_yyyymmdd  = '';
		-- 20230429  KSK, 동결구간이 없을 경우, 기본값은 7일이 유리함
		SET @v_frozen_days          = 7;
		SET @v_wcols                = '';
		SET @v_wcols2               = '';

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
									 AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
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
										AND PLAN_TYPE = @p_plan_type
										AND SEQ = @p_seq
										AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
										AND BIZ_TYPE = 'A'
										AND MEASURE = 'SHIP_PLAN_AMEND')
			AND A.OPERATION_GROUP = 'A'
			AND A.SITE_TYPE = 'PLANT'
			AND A.VALID_YN = 'Y'
			AND A.OSP_YN = 'N'
			;
		END

		--SELECT 1, @p_plan_start_yyyymmdd "@p_plan_start_yyyymmdd", @v_frozen_days "@v_frozen_days", @scp_simulator_ship_fixed_term_flag "@scp_simulator_ship_fixed_term_flag"

		SELECT @v_frozen_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,@v_frozen_days-1,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
		;

		SET @v_frozen_area_last_yyyymmdd = @v_frozen_end_yyyymmdd;
		--SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_frozen_end_yyyymmdd, 6) + '01'),112)),112);
		--SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)),112);


		SET @v_wcols = '';
		SET @v_wcols2 = '';
		SELECT @v_wcols = @v_wcols + '[' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],', @v_wcols2 = @v_wcols2 + 'ISNULL([' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],0) AS [' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],'
		  FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM
				FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
								,C.BASIS_YYYYMMDD AS E_YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
							AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
						) S1,
						(SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS S_YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
							AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2
						) S2
				WHERE S1.R_NUM = S2.R_NUM
				--UNION ALL
				--SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_frozen_end_yyyymmdd ),112)),112) AS S_YYYYMMDD
				--	,@v_frozen_area_last_yyyymmdd  AS E_YYYYMMDD, 99 AS R_NUM
    --             WHERE CONVERT(DATETIME,(@v_frozen_end_yyyymmdd),112) < CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)
			   ) AS A
		 ORDER BY A.E_YYYYMMDD
		 ;

		--SET @v_wcols = SUBSTRING(@v_wcols, 1, LEN(@v_wcols) - 1);
		--SET @v_wcols2 = SUBSTRING(@v_wcols2, 1, LEN(@v_wcols2) - 1);

		-- 2021.03.08   KSW           소형 SHIPMENT PLAN 입력 SIMULATION - 일부 모델에서 MKT FCST Measure 가 조회되지 않는 오류수정
		-- 전체쿼리 수정
		declare @v_plan_end_yyyymmdd22	nvarchar(20) = '';
		SELECT @v_plan_end_yyyymmdd22 = CONVERT(VARCHAR,DATEADD(D,49,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 -> 364+182
		SELECT @v_plan_end_yyyymmdd22 = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd22, 6) + '01'),112)),112)),112)),112) ;

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

		SET @v_weekplan_last_yyyymmdd = @v_weekplan_end_yyyymmdd
		--SELECT @v_weekplan_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_weekplan_end_yyyymmdd, 6) + '01'),112)),112);
		--SELECT @v_weekplan_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)),112);

		DECLARE @v_wpcols				NVARCHAR(MAX) = '';
		DECLARE @v_wpcols2				NVARCHAR(MAX) = '';

		SELECT @v_wpcols = @v_wpcols + '[' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],', @v_wpcols2 = @v_wpcols2 + 'ISNULL([' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],0) AS [' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],'
		  FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM
				FROM (SELECT  ROW_NUMBER() OVER(ORDER BY MAX(C.BASIS_YYYYMMDD) ASC) AS R_NUM
								,MAX(C.BASIS_YYYYMMDD) AS E_YYYYMMDD
								,C.PARTIAL_WEEK_NAME
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @v_weekplan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <= @v_weekplan_last_yyyymmdd
						GROUP BY C.PARTIAL_WEEK_NAME
						) S1,
						(SELECT ROW_NUMBER() OVER(ORDER BY MIN(C.BASIS_YYYYMMDD) ASC) AS R_NUM
							,MIN(C.BASIS_YYYYMMDD) AS S_YYYYMMDD
							,C.PARTIAL_WEEK_NAME
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @v_weekplan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <= @v_weekplan_last_yyyymmdd
						GROUP BY C.PARTIAL_WEEK_NAME
						) S2
				WHERE S1.R_NUM = S2.R_NUM
				--UNION ALL
				--SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_end_yyyymmdd ),112)),112) AS S_YYYYMMDD
				--	,@v_weekplan_last_yyyymmdd  AS E_YYYYMMDD, 99 AS R_NUM
    --             WHERE CONVERT(DATETIME,(@v_weekplan_end_yyyymmdd),112) < CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)
			   ) AS A
		 ORDER BY A.E_YYYYMMDD
		 ;

		 if ( len(@v_wpcols) > 0  )  SET @v_wpcols = SUBSTRING(@v_wpcols, 1, LEN(@v_wpcols) - 1);

		 if ( len(@v_wpcols2) > 0  ) SET @v_wpcols2 = SUBSTRING(@v_wpcols2, 1, LEN(@v_wpcols2) - 1);

		SET @v_wcols = @v_wcols + @v_wpcols;
		SET @v_wcols2 = @v_wcols2 + @v_wpcols2;

		-----------------
		-- Month 단위 Plan 기간
		-----------------
		DECLARE @v_month_plan_start_yyyymmdd NVARCHAR(8) = CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_weekplan_last_yyyymmdd),112)),112);

		SELECT @v_cols = @v_cols + '[' + YYYYMM + '],', @v_cols2 = @v_cols2 + 'ISNULL([' + YYYYMM + '],0) AS [' + YYYYMM + '],'
		  FROM (
				 SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 6) AS YYYYMM
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
						AND C.BASIS_YYYYMMDD > @v_weekplan_last_yyyymmdd
					AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,366+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 366 -> 366+182
			   ) AS days
		 ORDER BY YYYYMM
		 ;

		 if ( len(@v_cols) > 0) SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);

		 if ( len(@v_cols2) > 0)  SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);


        IF OBJECT_ID('tempdb..#tmp_SCM_MST_SSO_DEPT_USER_INFO') IS NOT NULL
			DROP TABLE #tmp_SCM_MST_SSO_DEPT_USER_INFO
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIP_DEPT') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIP_DEPT
		;
		
		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_PLN_STOCK_PLAN') IS NOT NULL
			DROP TABLE #tmp_PLN_STOCK_PLAN
		;
		
		  SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_ID + '|' + C.DEPT_NAME_EN AS DEPT_NAME_EN			-- DEPT_NAME_EN 식별문제로 DEPT_ID 를 붙여서 식별하는 것으로 변경 :: 2022.12.22
		  INTO #tmp_SCM_MST_SSO_DEPT_USER_INFO
			FROM [SCM_MST_SSO_USER_INFO] AS B WITH(NOLOCK)
			INNER JOIN SCM_MST_SSO_DEPT_INFO AS C WITH(NOLOCK)
				ON B.DEPT_ID = C.DEPT_ID
				AND B.ACTIVE_FLAG <> 'D'
			AND C.VALID_YN = 'Y'
			AND LEN(C.DEPT_ID) = 8
			AND USER_ID IN (SELECT OWNER FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK) WHERE DIVISION_ID = @p_division_id AND VALID_YN = 'Y' AND PROJECT_CODE <> '-')
			;

		  SELECT      AA.DIVISION_ID
					, AA.PLAN_START_YYYYMMDD
					, AA.PLAN_TYPE
					, AA.SEQ
    				, AA.ITEM_ID
					, CC.DEPT_ID
					, CC.DEPT_NAME_EN
					, CC.DEPT_NAME_KO
					, AA.MEASURE
					, AA.FROM_SITE
					--, 10	AS DEPT_ORD
					, (CASE WHEN AA.MEASURE = 'MKT_FCST'  THEN 100
							WHEN AA.MEASURE = 'SHIP_REQ_TOTAL'  THEN 200			-- 추가
							WHEN AA.MEASURE = 'SHIP_REQ'  THEN 300					-- 변경
							WHEN AA.MEASURE = 'SHIP_PLAN' THEN 400					-- 변경
							WHEN AA.MEASURE = 'SHIP_PLAN_AMEND' THEN 500 END) AS XLS_ORD  -- 변경
					, AA.YYYYMMDD
					, AA.QTY
					--, 1 AS MST_SEQ
			   INTO #tmp_SCP_ANL_SHIPMENT_PLAN_FG 
			   FROM (
						SELECT    DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, BIZ_TYPE, PROJECT_CODE, ITEM_ID, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID
								, MEASURE, YYYYMMDD, QTY
						FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] WITH(NOLOCK)
						WHERE DIVISION_ID = @p_division_id
						AND   PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   PLAN_TYPE = @p_plan_type
						AND   SEQ = @p_seq
						AND   BIZ_TYPE = 'A'
						AND   ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
						AND   MEASURE IN ('MKT_FCST','SHIP_REQ','SHIP_PLAN','SHIP_PLAN_AMEND') 
						UNION ALL
						SELECT    A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.BIZ_TYPE, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS, '-' AS FROM_SITE, '-' AS BOD_ID
								, 'SHIP_REQ_TOTAL' AS MEASURE, A.YYYYMMDD, SUM(ISNULL(A.QTY,0)) AS SUM_SHIP_REQ_TOTAL
						FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] A WITH(NOLOCK)
						--LEFT OUTER JOIN (
						--					SELECT DISTINCT PLANT_SITE_ID, ITEM_ID, PRIORITY
						--					FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) 
						--					WHERE DIVISION_ID = @p_division_id
						--					AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd 
						--					AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
						--					AND   VALID_YN = 'Y'
						--) B
						--ON A.FROM_SITE = B.PLANT_SITE_ID AND A.ITEM_ID = B.ITEM_ID
						WHERE A.DIVISION_ID = @p_division_id
						AND   A.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   A.PLAN_TYPE = @p_plan_type
						AND   A.SEQ = @p_seq
						AND   A.BIZ_TYPE = 'A'
						AND   A.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
						AND   A.MEASURE IN ('SHIP_REQ') 
						GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.BIZ_TYPE, A.PROJECT_CODE, A.ITEM_ID, A.TO_SITE, A.INCOTERMS
								,A.MEASURE, A.YYYYMMDD
					) AA
			   LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)
				 ON AA.DIVISION_ID = BB.DIVISION_ID
				AND AA.PROJECT_CODE = BB.PROJECT_CODE
				AND AA.TO_SITE = BB.SCM_SITE_ID
				AND AA.ITEM_ID = BB.ITEM_ID
			   LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH(NOLOCK)
				 ON BB.OWNER = CC.USER_ID
			  WHERE 1 = 1
				AND BB.DIVISION_ID = @p_division_id
				AND BB.VALID_YN = 'Y'
				AND BB.PROJECT_CODE <> '-'
				AND AA.DIVISION_ID = BB.DIVISION_ID
				AND AA.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND AA.PLAN_TYPE = @p_plan_type
				AND AA.SEQ       = @p_seq
				AND AA.MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL', 'SHIP_REQ', 'SHIP_PLAN','SHIP_PLAN_AMEND') 
				AND AA.QTY <> 0 
				AND AA.BIZ_TYPE = 'A'
				AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
				;


		/* #tmp_SCP_ANL_SHIPMENT_PLAN_FG상 MKT_FCST, SHIP_REQ 이것이 없는 조직에 대해서는 삭제하여 조회 되도록 함. 강현준 20231110*/ 
		DELETE FROM #tmp_SCM_MST_SSO_DEPT_USER_INFO 
		WHERE DEPT_ID IN (
							SELECT DISTINCT DEPT_ID
							FROM #tmp_SCM_MST_SSO_DEPT_USER_INFO A WITH(NOLOCK)
							WHERE NOT EXISTS (
												SELECT DISTINCT DEPT_ID
												FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG  B WITH(NOLOCK)
												WHERE MEASURE IN ('MKT_FCST','SHIP_REQ')
												AND   A.DEPT_ID = B.DEPT_ID
											)
		) ;

		/* ITEM_ID별 DEPT_ID 정의. 강현준 20231110*/ 
		SELECT DISTINCT A.ITEM_ID, B.DEPT_ID 
		INTO #tmp_SCP_ANL_SHIP_DEPT
		FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK)
		   , #tmp_SCM_MST_SSO_DEPT_USER_INFO B WITH(NOLOCK)
		WHERE A.MEASURE IN ('MKT_FCST','SHIP_REQ')
		AND   A.DEPT_ID = B.DEPT_ID


		-- 20231005. 강현준 (개발서버에서 iN을 활용한 ITEM 처리시 속도 저하 ==> item을 미리 변수화하여 처리)
		DECLARE @v_items                 NVARCHAR(MAX);
		SET @v_items  = '';
		SELECT @v_items = @v_items  + '''' + A.ITEM_ID_ASSY + ''','
		FROM (
				SELECT DISTINCT value AS ITEM_ID_ASSY FROM dbo.FN_SplitString(@p_parameter1,',')
				UNION ALL
				select DISTINCT ITEM_ID_ASSY 
				from SCP_MST_CELL_PROD_ASSY_MAP with(nolock)
				where item_id_prod IN ( SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
		)A;


		SET @v_items = SUBSTRING(@v_items, 1, LEN(@v_items)-1);		-- ==> @v_items는 아래 쿼리에서 적용


		SELECT AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
			 , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM, ROUND(AA.QTY, 0) AS QTY, 1 AS MST_SEQ              
		INTO #tmp_MONTH_SHIPMENT_PLAN_FG_1
		FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)                
		WHERE AA.MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL','SHIP_REQ','SHIP_PLAN','SHIP_PLAN_AMEND')
		AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_plan_end_yyyymmdd
		UNION ALL
		SELECT  N1.DIVISION_ID, N1.PLAN_START_YYYYMMDD, N1.PLAN_TYPE,N1. SEQ,N1.ITEM_ID, N1.DEPT_ID, N1.DEPT_NAME_EN, N1.DEPT_NAME_KO
				,(CASE WHEN MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_PLAN_AMEND_TOTAL') THEN '-'
					   WHEN MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
				   ELSE '-'
				  END )    AS  FROM_SITE
				,N2.MEASURE, 10 AS DEPT_ORD, N2.XLS_ORD, SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM, 0 AS QTY, 1 AS MST_SEQ
		FROM (
				SELECT DISTINCT BB.DIVISION_ID
							  , @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
							  , @p_plan_type AS PLAN_TYPE
							  , @p_seq AS SEQ
							  , BB.ITEM_ID
							  , CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
				FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
				LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
				ON BB.OWNER = CC.USER_ID
				INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH (NOLOCK)
				ON BB.ITEM_ID = DD.ITEM_ID
				AND CC.DEPT_ID = DD.DEPT_ID
				INNER JOIN (
							SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
							FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
							WHERE DIVISION_ID = @p_division_id 
							AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
							AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd 
							AND   VALID_YN = 'Y' 
							) EE
				ON BB.ITEM_ID = EE.ITEM_ID
				WHERE BB.DIVISION_ID = @p_division_id
				AND BB.VALID_YN = 'Y'
				AND BB.PROJECT_CODE <> '-'
				AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
			) N1,
			(
				SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
			) N2,
			(
				SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
				AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
				AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd22
				AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
			) N3
		UNION ALL
		SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE
			   , G1.MEASURE, G2.DEPT_ORD, G1.XLS_ORD, G2.YYYYMM, (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY ELSE G2.CNT END) AS QTY
			   , 1 AS MST_SEQ
		FROM (
				SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD
			 ) G1
			,(
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
						, 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, AA.QTY, 1 AS CNT
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				LEFT OUTER JOIN (
									SELECT  SMS.SCM_SITE_ID
											, (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1 
												ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) END
											  ) AS SHIP_FROZEN
									FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
									LEFT OUTER JOIN (
														SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
														FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
														INNER JOIN
														[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
														ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														AND   A.VALID_YN = 'Y'
														AND   B.SEGMENT1 = @p_division_id
														AND   B.VALID_YN = 'Y'
													) SALM
									ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
									WHERE  1 = 1
									AND DIVISION_ID = @p_division_id
									AND OPERATION_GROUP = 'A' AND SITE_TYPE = 'PLANT' AND VALID_YN = 'Y' AND OSP_YN = 'N'
								) SF
				ON AA.FROM_SITE = SF.SCM_SITE_ID
				WHERE 1 = 1 AND AA.MEASURE IN ('SHIP_PLAN') 
				AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112) 
			 ) G2              
		UNION ALL
		SELECT DIVISION_ID ,PLAN_START_YYYYMMDD ,PLAN_TYPE ,SEQ ,ITEM_ID ,DEPT_ID ,DEPT_NAME_EN ,DEPT_NAME_KO ,FROM_SITE ,MEASURE ,DEPT_ORD ,XLS_ORD ,YYYYMM
			  ,ROUND(QTY, 0) AS QTY ,2 AS MST_SEQ 
		FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID = @p_division_id 
		AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		AND PLAN_TYPE = @p_plan_type
		AND SEQ  = @p_seq
		AND MEASURE = 'SHIP_PLAN_AMEND'
		AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
		AND LAST_UPDATED_BY = @p_parameter3      



		SELECT MAX(RR.MST_SEQ) AS MST_SEQ, RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE ,RR.SEQ, RR.ITEM_ID, RR.FROM_SITE, RR.MEASURE, RR.YYYYMM              
		INTO #tmp_MONTH_SHIPMENT_PLAN_FG_2
 		FROM (
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
					  , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, ROUND(AA.QTY, 0) AS QTY, 1 AS MST_SEQ
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				WHERE AA.MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND')
				AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_plan_end_yyyymmdd
				UNION ALL
				SELECT  N1.DIVISION_ID, N1.PLAN_START_YYYYMMDD, N1.PLAN_TYPE, N1.SEQ,N1.ITEM_ID, N1.DEPT_ID, N1.DEPT_NAME_EN, N1.DEPT_NAME_KO
				     , (CASE WHEN MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_PLAN_AMEND_TOTAL') THEN '-'
					         WHEN MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
						ELSE '-'
						END )    AS  FROM_SITE
					 , N2.MEASURE, 10 AS DEPT_ORD, N2.XLS_ORD, SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM, 0 AS QTY, 1 AS MST_SEQ
				FROM (
						SELECT   DISTINCT BB.DIVISION_ID
							  , @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
							  , @p_plan_type AS PLAN_TYPE
							  , @p_seq AS SEQ
							  , BB.ITEM_ID, CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
						FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
						LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
						ON BB.OWNER = CC.USER_ID
						INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH (NOLOCK)
						ON BB.ITEM_ID = DD.ITEM_ID
						AND CC.DEPT_ID = DD.DEPT_ID
						INNER JOIN (
										SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
										FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
										WHERE DIVISION_ID = @p_division_id
										AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
										AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
										AND   VALID_YN = 'Y'
									) EE
						ON BB.ITEM_ID = EE.ITEM_ID
						WHERE BB.DIVISION_ID = @p_division_id
						AND BB.VALID_YN = 'Y'
						AND BB.PROJECT_CODE <> '-'
						AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
					) N1,
					(
						SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
					) N2,
					(
						SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @v_plan_start_yyyymmdd
						AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd22
						AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
					) N3
					UNION ALL
					SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE
						   , G1.MEASURE, G2.DEPT_ORD, G1.XLS_ORD, G2.YYYYMM, (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY ELSE G2.CNT END) AS QTY, 1 AS MST_SEQ
					FROM (
							SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD
						) G1,
						(
							SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
								  , 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, AA.QTY, 1 AS CNT
							FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
							LEFT OUTER JOIN (
												SELECT  SMS.SCM_SITE_ID
													  , (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1 
															  ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) 
														END) AS SHIP_FROZEN
												FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
												LEFT OUTER JOIN (
																	SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
																	FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
																	INNER JOIN
																	[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
																	ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
																	WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
																	AND   A.VALID_YN = 'Y'
																	AND   B.SEGMENT1 = @p_division_id
																	AND   B.VALID_YN = 'Y'
																) SALM
												ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
												WHERE  1 = 1
												AND DIVISION_ID = @p_division_id
												AND OPERATION_GROUP = 'A'
												AND SITE_TYPE = 'PLANT'
												AND VALID_YN = 'Y'
												AND OSP_YN = 'N'
											) SF
							ON AA.FROM_SITE = SF.SCM_SITE_ID
							WHERE 1 = 1
							AND AA.MEASURE IN ('SHIP_PLAN')
							AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112)
					) G2
				UNION ALL
				SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE,SEQ, ITEM_ID,DEPT_ID, DEPT_NAME_EN, DEPT_NAME_KO, FROM_SITE, MEASURE, DEPT_ORD, XLS_ORD, YYYYMM, ROUND(QTY, 0) AS QTY, 2 AS MST_SEQ
				FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
				WHERE 1 = 1
				AND DIVISION_ID = @p_division_id
				AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				AND PLAN_TYPE = @p_plan_type
				AND SEQ       = @p_seq
				AND MEASURE = 'SHIP_PLAN_AMEND'
				AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
				AND LAST_UPDATED_BY = @p_parameter3
			) RR
		GROUP BY RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE, RR.SEQ, RR.ITEM_ID, RR.FROM_SITE, RR.MEASURE, RR.YYYYMM           


		SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
			   , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM, AA.YYYYMMDD
			   , (CASE WHEN AA.MEASURE = 'SHIP_PLAN_AMEND' AND AA.YYYYMMDD BETWEEN @v_plan_start_yyyymmdd AND @v_frozen_end_yyyymmdd THEN 0
				  ELSE ROUND(AA.QTY, 0) 
				  END) AS QTY
			   , 1 AS MST_SEQ                      
		INTO #tmp_WEEK_SHIPMENT_PLAN_FG_1
		FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
		WHERE AA.MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL','SHIP_REQ','SHIP_PLAN_AMEND')
		AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
		UNION ALL
		SELECT  N1.DIVISION_ID,N1.PLAN_START_YYYYMMDD,N1.PLAN_TYPE,N1.SEQ,N1.ITEM_ID,N1.DEPT_ID,N1.DEPT_NAME_EN,N1.DEPT_NAME_KO
			  ,(CASE WHEN MEASURE IN ('MKT_FCST','SHIP_REQ_TOTAL','SHIP_PLAN_AMEND_TOTAL') THEN '-'
					 WHEN MEASURE IN ('SHIP_REQ','SHIP_PLAN','SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
				ELSE '-'
				END )    AS  FROM_SITE
			  ,N2.MEASURE,10 AS DEPT_ORD,N2.XLS_ORD,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM,N3.YYYYMMDD,0 AS QTY,1 AS MST_SEQ      
		FROM (
				SELECT   DISTINCT BB.DIVISION_ID
						, @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
						, @p_plan_type AS PLAN_TYPE
						, @p_seq AS SEQ
						, BB.ITEM_ID, CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
				FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
				LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
				ON BB.OWNER = CC.USER_ID
				INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH (NOLOCK)
				ON BB.ITEM_ID = DD.ITEM_ID
				AND CC.DEPT_ID = DD.DEPT_ID
				INNER JOIN (
							SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
							FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
							WHERE DIVISION_ID = @p_division_id
							AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
							AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
							AND   VALID_YN = 'Y'
							) EE
				ON BB.ITEM_ID = EE.ITEM_ID
				WHERE BB.DIVISION_ID = @p_division_id
				AND BB.VALID_YN = 'Y'
				AND BB.PROJECT_CODE <> '-'
				AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
			) N1,
			(
				SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
				UNION ALL
				SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
			) N2,
			(
				SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
				AND C.BASIS_YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
				AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
			) N3
		UNION ALL
		SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE, G1.MEASURE, G2.DEPT_ORD
			  , G1.XLS_ORD, G2.YYYYMM, G2.YYYYMMDD
			  , (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY
					  ELSE G2.CNT END
				) AS QTY
			  , 1 AS MST_SEQ
		FROM (
				SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD
			) G1,
			(
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
					   , 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM, AA.YYYYMMDD, AA.QTY, 1 AS CNT
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				LEFT OUTER JOIN (
									SELECT  SMS.SCM_SITE_ID
										  , (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1 
												ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) 
												END) AS SHIP_FROZEN
									FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
									LEFT OUTER JOIN (
														SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
														FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
														INNER JOIN
														[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
														ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
														AND   A.VALID_YN = 'Y'
														AND   B.SEGMENT1 = @p_division_id
														AND   B.VALID_YN = 'Y'
													) SALM
									ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
									WHERE  1 = 1
									AND DIVISION_ID = @p_division_id
									AND OPERATION_GROUP = 'A'
									AND SITE_TYPE = 'PLANT'
									AND VALID_YN = 'Y'
									AND OSP_YN = 'N'
								) SF
				ON AA.FROM_SITE = SF.SCM_SITE_ID
				WHERE 1 = 1
				AND AA.MEASURE IN ('SHIP_PLAN')
				AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
			) G2
		UNION ALL
		SELECT DIVISION_ID, PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,ITEM_ID,DEPT_ID,DEPT_NAME_EN,DEPT_NAME_KO,FROM_SITE,MEASURE,DEPT_ORD,XLS_ORD,SUBSTRING(YYYYMM, 1, 6) AS YYYYMM,YYYYMM AS YYYYMMDD
		      ,ROUND(QTY, 0) AS QTY,2 AS MST_SEQ
		FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
		WHERE 1 = 1
		AND DIVISION_ID = @p_division_id
		AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
		AND PLAN_TYPE = @p_plan_type
		AND SEQ       = @p_seq
		AND MEASURE = 'SHIP_PLAN_AMEND'
		AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
		AND LAST_UPDATED_BY = @p_parameter3                  



		SELECT MAX(RR.MST_SEQ) AS MST_SEQ,RR.DIVISION_ID,RR.PLAN_START_YYYYMMDD,RR.PLAN_TYPE,RR.SEQ,RR.ITEM_ID,RR.FROM_SITE,RR.MEASURE,RR.YYYYMM,RR.YYYYMMDD
		INTO #tmp_WEEK_SHIPMENT_PLAN_FG_2
		FROM (
				SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
					   , 10 AS DEPT_ORD, AA.XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, YYYYMMDD, ROUND(AA.QTY, 0) AS QTY, 1 AS MST_SEQ
				FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
				WHERE AA.MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_REQ', 'SHIP_PLAN_AMEND')
				AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
				UNION ALL
				SELECT  N1.DIVISION_ID,N1.PLAN_START_YYYYMMDD,N1.PLAN_TYPE,N1.SEQ,N1.ITEM_ID,N1.DEPT_ID,N1.DEPT_NAME_EN,N1.DEPT_NAME_KO
					   ,(CASE WHEN MEASURE IN ('MKT_FCST', 'SHIP_REQ_TOTAL', 'SHIP_PLAN_AMEND_TOTAL') THEN '-'
							  WHEN MEASURE IN ('SHIP_REQ', 'SHIP_PLAN', 'SHIP_PLAN_AMEND') THEN N1.PLANT_SITE_ID
							  ELSE '-'             
						 END )    AS  FROM_SITE
					   ,N2.MEASURE,10 AS DEPT_ORD,N2.XLS_ORD,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM,N3.YYYYMMDD,0 AS QTY,1 AS MST_SEQ
				FROM (
						SELECT   DISTINCT BB.DIVISION_ID
								, @v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
								, @p_plan_type AS PLAN_TYPE
								, @p_seq AS SEQ
								, BB.ITEM_ID, CC.DEPT_ID, CC.DEPT_NAME_EN, CC.DEPT_NAME_KO, EE.PLANT_SITE_ID, EE.PRIORITY
						FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)
						LEFT JOIN #tmp_SCM_MST_SSO_DEPT_USER_INFO CC WITH (NOLOCK)
						ON BB.OWNER = CC.USER_ID
						INNER JOIN #tmp_SCP_ANL_SHIP_DEPT DD WITH(NOLOCK)
						ON BB.ITEM_ID = DD.ITEM_ID
						AND CC.DEPT_ID = DD.DEPT_ID
						INNER JOIN (
										SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY
										FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK)
										WHERE DIVISION_ID = @p_division_id
										AND   FROM_YYYYMMDD <= @v_plan_end_yyyymmdd
										AND   TO_YYYYMMDD >= @v_plan_start_yyyymmdd
										AND   VALID_YN = 'Y'
									) EE
						ON BB.ITEM_ID = EE.ITEM_ID
						WHERE BB.DIVISION_ID = @p_division_id
						AND BB.VALID_YN = 'Y'
						AND BB.PROJECT_CODE <> '-'
						AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
					) N1,
					(
						SELECT 'MKT_FCST' AS MEASURE, 100 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ_TOTAL' AS MEASURE, 200 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND_TOTAL' AS MEASURE, 250 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_REQ' AS MEASURE, 300 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN' AS MEASURE, 400 AS XLS_ORD
						UNION ALL
						SELECT 'SHIP_PLAN_AMEND' AS MEASURE, 500 AS XLS_ORD
					) N2,
					(
						SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
						AND C.BASIS_YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
						AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
					) N3
			UNION ALL
			SELECT   G2.DIVISION_ID, G2.PLAN_START_YYYYMMDD, G2.PLAN_TYPE, G2.SEQ, G2.ITEM_ID, G2.DEPT_ID, G2.DEPT_NAME_EN, G2.DEPT_NAME_KO, G2.FROM_SITE
			       , G1.MEASURE, G2.DEPT_ORD, G1.XLS_ORD, G2.YYYYMM, G2.YYYYMMDD, (CASE WHEN G1.MEASURE = 'SHIP_PLAN' THEN G2.QTY ELSE G2.CNT END) AS QTY, 1 AS MST_SEQ
			FROM (
					SELECT 'SHIP_PLAN'    AS MEASURE, 400 AS XLS_ORD 
				) G1,
				(
					SELECT   AA.DIVISION_ID, AA.PLAN_START_YYYYMMDD, AA.PLAN_TYPE, AA.SEQ, AA.ITEM_ID, AA.DEPT_ID, AA.DEPT_NAME_EN, AA.DEPT_NAME_KO, AA.FROM_SITE, AA.MEASURE
						   , 10 AS DEPT_ORD, 400   AS XLS_ORD, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM, YYYYMMDD, AA.QTY, 1 AS CNT
					FROM #tmp_SCP_ANL_SHIPMENT_PLAN_FG AA WITH(NOLOCK)
					LEFT OUTER JOIN (
										SELECT  SMS.SCM_SITE_ID
											  , (CASE WHEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) > 0 THEN ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) - 1
												 ELSE ISNULL(SALM.SHIP_FROZEN, SMS.SHIP_FROZEN) 
												 END) AS SHIP_FROZEN
										FROM [DBO].[SCM_MST_SITE] SMS WITH(NOLOCK)
										LEFT OUTER JOIN (
															SELECT B.SEGMENT2 AS SCM_SITE_ID, B.SEGMENT3 AS SHIP_FROZEN
															FROM [DBO].[SCM_ADM_LOOKUP_MASTER] A WITH (NOLOCK)
															INNER JOIN
															[DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] B WITH (NOLOCK)
															ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
															WHERE A.LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
															AND   A.VALID_YN = 'Y'
															AND   B.SEGMENT1 = @p_division_id
															AND   B.VALID_YN = 'Y'
														) SALM
										ON SMS.SCM_SITE_ID = SALM.SCM_SITE_ID
										WHERE  1 = 1
										AND DIVISION_ID = @p_division_id
										AND OPERATION_GROUP = 'A'
										AND SITE_TYPE = 'PLANT'
										AND VALID_YN = 'Y'
										AND OSP_YN = 'N'
									) SF
					ON AA.FROM_SITE = SF.SCM_SITE_ID
					WHERE 1 = 1
					AND AA.MEASURE IN ('SHIP_PLAN')
					AND AA.YYYYMMDD between @v_plan_start_yyyymmdd and @v_weekplan_last_yyyymmdd
				) G2
			UNION ALL
			SELECT DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,ITEM_ID,DEPT_ID,DEPT_NAME_EN,DEPT_NAME_KO,FROM_SITE,MEASURE,DEPT_ORD,XLS_ORD
				  ,LEFT(YYYYMM, 6) AS YYYYMM,YYYYMM AS YYYYMMDD,ROUND(QTY, 0) AS QTY,2 AS MST_SEQ
			FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)
			WHERE 1 = 1
			AND DIVISION_ID = @p_division_id
			AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
			AND PLAN_TYPE = @p_plan_type
			AND SEQ       = @p_seq
			AND MEASURE = 'SHIP_PLAN_AMEND'
			AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
			AND LAST_UPDATED_BY = @p_parameter3
		) RR
		GROUP BY RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE, RR.SEQ, RR.ITEM_ID, RR.FROM_SITE, RR.MEASURE, RR.YYYYMM, RR.YYYYMMDD                     


		SELECT ITEM_ID AS ITEM_ID_PROD, 
				ITEM_ID_ASSY, SUM(QTY) AS QTY, YYYYMMDD, '-' AS FROM_SITE 
		INTO  #tmp_PLN_STOCK_PLAN
		FROM  ( 
				SELECT AAA.*, BBB.ITEM_ID_ASSY AS ASSY_ORG, CASE WHEN BBB.ITEM_ID_ASSY IS NULL THEN AAA.ITEM_ID  ELSE BBB.ITEM_ID_ASSY END AS ITEM_ID_ASSY  
				FROM ( 
						SELECT CELL_ITEM_ID AS ITEM_ID, YYYYMMDD, QTY, FROM_SITE 
						FROM    ( 
									SELECT X.CELL_ITEM_ID, X.FROM_SITE,             CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD,             SUM(X.AFTER_QTY) AS QTY       
									FROM (
											SELECT    CELL_ITEM_ID, SCM_SITE_ID AS FROM_SITE
													, ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY
													, ( CASE WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'FOR%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='001' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='N' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'INT%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='N' AND DESCR LIKE 'WH%' AND TCO_EXIST_YN ='Y' ) THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='Y' AND LOC='***' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM)
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'INT%' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='002' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) THEN RECEIVING_DTTM
																WHEN (OSP_YN='N' AND LOC='003' AND  TCO_CELL_YN='Y' AND DESCR LIKE 'WH%' ) THEN RECEIVING_DTTM
																ELSE RECEIVING_DTTM
														END
														) AS AFTER_DTTM
											FROM   (
													SELECT A.ITEM_ID,A.SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~') AS SCM_SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,2,'~') AS LOC
															,( SELECT ISNULL(S.OSP_YN,'N') FROM SCM_MST_SITE S WITH(NOLOCK) WHERE S.DIVISION_ID='40' AND S.SCM_SITE_ID =[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,'~') ) AS OSP_YN
															, A.RECEIVING_DTTM,A.QTY,A.LOT_ID,A.DESCR,Y.TCO_CELL_YN
															,(CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID
															,( SELECT CASE WHEN MAX(TCO_CELL_ITEM_ID) IS NULL THEN 'N' ELSE 'Y' END
																FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK)
																WHERE 1=1
																AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )
																) AS TCO_EXIST_YN
															, ( SELECT MAX(CELL_TO_TCO_BOD_LT) FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK) WHERE 1=1 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS CELL_TO_TCO_BOD_LT
															, ( SELECT MAX(TCO_TO_CELL_BOD_LT) FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK) WHERE 1=1 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS TCO_TO_CELL_BOD_LT
															, ( SELECT MAX(CELL_TO_TCO_TOTAL_BOD_LT) FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK) WHERE 1=1 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS CELL_TO_TCO_TOTAL_BOD_LT
															, ( SELECT ISNULL(MAX(V.FORMATION_TOTAL_YIELD),1) FROM [dbo].[SCP_MST_FORMATION_V] V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS FORMATION_TOTAL_YIELD
															, ( SELECT ISNULL(MAX(V.TOTAL_LT_FORMATION),0) FROM [dbo].[SCP_MST_FORMATION_V] V WITH(NOLOCK) WHERE V.DIVISION_ID = '40' AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = 'Y' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) ) AS TOTAL_LT_FORMATION
													FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  A WITH(NOLOCK)
													INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)
													ON 0 = 0 
													and a.master_id = '40::WEEKLY'
													and a.plan_id = @eng_plan_id
													AND Y.DIVISION_ID = @p_division_id
													AND A.ITEM_ID     = Y.ITEM_ID
													AND Y.OPERATION_GROUP='A'
											) XLS_BOH       
										) X 
									where CONVERT(VARCHAR,X.AFTER_DTTM,112) < @v_plan_start_yyyymmdd
									GROUP BY X.CELL_ITEM_ID, X.FROM_SITE, CONVERT(VARCHAR,X.AFTER_DTTM,112)
								) X 
								where YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_plan_start_yyyymmdd),112)),112)  
						) AS AAA 
				LEFT OUTER JOIN  (
									SELECT DISTINCT PLANT_ID, ITEM_ID_ASSY, ITEM_ID_PROD, CELL_TYPE FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock)  
								) BBB
				ON AAA.ITEM_ID = BBB.ITEM_ID_PROD 
				AND SUBSTRING(AAA.FROM_SITE,1,4) = BBB.PLANT_ID  
		) CCC  
		-- CELL_ASSY(CELL의 시작공정)에 CELL_PROD(CELL의 끝공정)의 데이터는 외주 데이터이므로 제외함.
		WHERE ITEM_ID_ASSY IN ( SELECT DISTINCT ITEM_ID_ASSY FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE DIVISION_ID = @p_division_id)
		GROUP BY ITEM_ID_ASSY,YYYYMMDD, ITEM_ID


		SET @SQL = '';
		SET @SQL = @SQL + 'SELECT PV1.DIVISION_ID';
		SET @SQL = @SQL + '      ,PV1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '      ,PV1.PLAN_TYPE';
		SET @SQL = @SQL + '      ,PV1.SEQ';
		SET @SQL = @SQL + '      ,PV1.CELL_TYPE';
		SET @SQL = @SQL + '      ,PV1.ITEM_ID';
		SET @SQL = @SQL + '      ,PV1.NICK_NAME';
		SET @SQL = @SQL + '      ,PV1.DEPT_ID';
		SET @SQL = @SQL + '      ,PV1.DEPT_NAME_EN';
		SET @SQL = @SQL + '      ,PV1.DEPT_NAME_KO';
		SET @SQL = @SQL + '      ,PV1.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '      ,PV1.MEASURE';
		SET @SQL = @SQL + '      ,PV1.MEASURE_DESC';
		SET @SQL = @SQL + '      ,PV1.BOH';
		SET @SQL = @SQL + '      ,PV1.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_wcols2;
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '      ,PV1.TOTAL_QTY';
		SET @SQL = @SQL + '      ,PV1.CONFIRM_QTY';
		SET @SQL = @SQL + '      ,PV1.CONFIRM_QTY2';
		SET @SQL = @SQL + '      ,PV1.PLAN_END_YYYYMMDD';
		SET @SQL = @SQL + '      ,PV1.FROZEN';
		SET @SQL = @SQL + '  FROM (';

		-- PIVOT1 : Month Plan
		SET @SQL = @SQL + 'SELECT   P.DIVISION_ID';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE';
		SET @SQL = @SQL + '        ,P.SEQ';
		SET @SQL = @SQL + '        ,(SELECT SEGMENT2 FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)';
		SET @SQL = @SQL + '			  WHERE LOOKUP_TYPE = ''CELL_TYPE_GROUP_CODE''';
		SET @SQL = @SQL + '			    AND VALID_YN =''Y''';
		SET @SQL = @SQL + '			    AND SEGMENT1 = P.CELL_TYPE_GROUP_CODE) AS CELL_TYPE';
		SET @SQL = @SQL + '        ,P.ITEM_ID';
		SET @SQL = @SQL + '        ,P.NICK_NAME';
		SET @SQL = @SQL + '        ,P.DEPT_ID';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE <> ''INVENTORY'' THEN P.FROM_SITE	ELSE ''-''	END) AS FROM_SITE';				-- 추가
		SET @SQL = @SQL + '        ,P.MEASURE';
		SET @SQL = @SQL + '        ,P.DEPT_ORD';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''MKT_FCST'' THEN ''Forecast''  ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ'' THEN ''Ship Req.'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ_TOTAL'' THEN ''Ship Req.Total'' ';		--추가
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN_AMEND_TOTAL'' THEN ''Ship plan .Total'' ';		--추가
        SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN''        THEN ''Ship Plan (SSP)'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN_AMEND''  THEN ''Ship Plan'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''PROD_PLAN_ENGINE'' THEN ''Available(Production+L/T)'' ';
		SET @SQL = @SQL + '			      ELSE ''Inventory'' END) AS MEASURE_DESC ';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE <> ''INVENTORY'' THEN 0'
		SET @SQL = @SQL + '               ELSE ISNULL(B.QTY, 0)'
		SET @SQL = @SQL + '           END) AS BOH';
		SET @SQL = @SQL + '        ,P.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '        ,0 AS TOTAL_QTY ';
		SET @SQL = @SQL + '        ,0 AS CONFIRM_QTY ';
		SET @SQL = @SQL + '        ,0 AS CONFIRM_QTY2 ';
		SET @SQL = @SQL + '        ,''' + @v_plan_end_yyyymmdd + ''' AS PLAN_END_YYYYMMDD';

		SET @SQL = @SQL + '        ,(CASE WHEN ' + CONVERT(VARCHAR, @v_frozen_days) + ' > 0 THEN ' + CONVERT(VARCHAR, @v_frozen_days) + ' - 1 ELSE ' + CONVERT(VARCHAR, @v_frozen_days) + ' END) AS FROZEN';
		SET @SQL = @SQL + '  FROM (';
		SET @SQL = @SQL + '		SELECT P_RST.*, F.NICK_NAME, F.CELL_TYPE_GROUP_CODE';
		SET @SQL = @SQL + '		  FROM (';

		SET @SQL = @SQL + '			 SELECT  R.DIVISION_ID';
		SET @SQL = @SQL + '			        ,R.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,R.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,R.SEQ';
		SET @SQL = @SQL + '			        ,R.ITEM_ID';
		SET @SQL = @SQL + '	        		,R.DEPT_ID';
		SET @SQL = @SQL + '	        		,R.DEPT_NAME_EN';
		SET @SQL = @SQL + '	        		,R.DEPT_NAME_KO';
		SET @SQL = @SQL + '	        		,R.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '			        ,R.MEASURE';
		SET @SQL = @SQL + '	        		,R.DEPT_ORD';
		SET @SQL = @SQL + '	        		,R.XLS_ORD';
		SET @SQL = @SQL + '			        ,R.YYYYMM';
		SET @SQL = @SQL + '			        ,(CASE WHEN R.MEASURE = ''SHIP_PLAN'' THEN 0 ELSE R.QTY END) AS QTY '

		SET @SQL = @SQL + '			 FROM #tmp_MONTH_SHIPMENT_PLAN_FG_1 R WITH(NOLOCK) ,    #tmp_MONTH_SHIPMENT_PLAN_FG_2 Q WITH(NOLOCK)     ';

		SET @SQL = @SQL + '			  WHERE R.MST_SEQ             = Q.MST_SEQ';
		SET @SQL = @SQL + '			    AND R.DIVISION_ID         = Q.DIVISION_ID';
		SET @SQL = @SQL + '			    AND R.PLAN_START_YYYYMMDD = Q.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			    AND R.PLAN_TYPE = Q.PLAN_TYPE';
		SET @SQL = @SQL + '			    AND R.SEQ       = Q.SEQ';
		SET @SQL = @SQL + '			    AND R.ITEM_ID   = Q.ITEM_ID';
		SET @SQL = @SQL + '			    AND R.FROM_SITE = Q.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '			    AND R.MEASURE   = Q.MEASURE';
		SET @SQL = @SQL + '			    AND R.YYYYMM    = Q.YYYYMM';
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  P.DIVISION_ID';
		SET @SQL = @SQL + '					,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '					,P.PLAN_TYPE';
		SET @SQL = @SQL + '					,P.SEQ';
		SET @SQL = @SQL + '		, (	';
	  	SET @SQL = @SQL + '			CASE (SELECT COUNT(DISTINCT( ITEM_ID_PROD)) from SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID	) ';
	 	SET @SQL = @SQL + '			WHEN  0 THEN P.ITEM_ID	';
	 	SET @SQL = @SQL + '			WHEN 1 THEN (SELECT DISTINCT ITEM_ID_PROD from SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID ) ';
	 	SET @SQL = @SQL + '			END ';
	 	SET @SQL = @SQL + '		) AS ITEM_ID ';

		SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '					, P.SCM_SITE_ID';				-- 추가
		SET @SQL = @SQL + '					,P.MEASURE'
		SET @SQL = @SQL + '					,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '					,900  AS XLS_ORD';
		SET @SQL = @SQL + '					,SUBSTRING(CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '	            ,SUM(ROUND(P.QTY * ISNULL(F.SSP_MODIFY_YIELD, 1), 0)) AS QTY';------EDIT BY DHJ 07/10/2023		
		SET @SQL = @SQL + '				FROM [DBO].[SCP_ANL_PRODUCTION_PLAN] P WITH (NOLOCK)';
		SET @SQL = @SQL + '				LEFT JOIN [dbo].[SCP_MST_FORMATION] F WITH (NOLOCK)';
		SET @SQL = @SQL + '				ON P.SCM_SITE_ID = F.PLANT_SITE_ID';
		SET @SQL = @SQL + '				AND P.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '				WHERE 1 = 1';
		SET @SQL = @SQL + '				AND P.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '				AND P.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '				AND P.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '				AND P.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '				AND P.OPERATION_GROUP = ''A''';
		SET @SQL = @SQL + '				AND P.MEASURE = ''PROD_PLAN_ENGINE''';

		SET @SQL = @SQL + '	 AND (P.ITEM_ID IN  ';
		SET @SQL = @SQL + '					( ';
		SET @SQL = @SQL + @v_items;			-- 20231005 강현준

		SET @SQL = @SQL + '					) ';	
		SET @SQL = @SQL + '	  )';


		SET @SQL = @SQL + '	 AND CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + 'GROUP BY P.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, P.SCM_SITE_ID, MEASURE ,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), P.ITEM_ID ';			-- 변경

		----------------------
		-- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		----------------------
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  ''' + @p_division_id + ''' AS DIVISION_ID';
		SET @SQL = @SQL + '			        ,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '			        ,''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '			        ,E1.value AS ITEM_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            ,E4.PLANT_SITE_ID AS FROM_SITE';		-- 추가
		SET @SQL = @SQL + '			        ,E2.MEASURE';
		SET @SQL = @SQL + '                 ,99	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,E2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(E3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '			   FROM (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','','')) E1,';
		SET @SQL = @SQL + '			        (SELECT ''PROD_PLAN_ENGINE'' AS MEASURE, 900 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) E2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) E3 , ';		-- 변경

		SET @SQL = @SQL + '			        ( ';		
		SET @SQL = @SQL + '						SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY ';		
		SET @SQL = @SQL + '						FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) ';		
		SET @SQL = @SQL + '						WHERE DIVISION_ID = ''' + @p_division_id + ''' ';		
		SET @SQL = @SQL + '		        		AND   FROM_YYYYMMDD <= ''' + @v_plan_end_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   TO_YYYYMMDD >= ''' + @v_plan_start_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   VALID_YN = ''Y'' ';
		SET @SQL = @SQL + '		        	) E4 ';
		SET @SQL = @SQL + '			        WHERE E1.value = E4.ITEM_ID ';	

		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT ''' + @p_division_id + ''' AS DIVISION_ID ';
		SET @SQL = @SQL + '					,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '					,''' + @p_plan_type + ''' AS PLAN_TYPE ';
		SET @SQL = @SQL + '					,''' + @p_seq + ''' AS SEQ ';
		SET @SQL = @SQL + '					,ITEM_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '					, ''-'' AS FROM_SITE ';				-- 추가
		SET @SQL = @SQL + '					,''INVENTORY'' AS MEASURE';
		SET @SQL = @SQL + '					,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '					,800  AS XLS_ORD';
		SET @SQL = @SQL + '					,''' + @p_plan_start_yyyymmdd + ''' AS YYYYMMDD ';
		SET @SQL = @SQL + '					,0    AS QTY';
		SET @SQL = @SQL + '			   FROM SCP_MST_FINAL_ITEM WITH (NOLOCK)';
		SET @SQL = @SQL + '			  WHERE DIVISION_ID = ''40'' AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '             AND OPERATION_GROUP = ''A''';


		SET @SQL = @SQL + '			  ) AS M';
		SET @SQL = @SQL + '		 PIVOT (';
		SET @SQL = @SQL + '				SUM(QTY) FOR YYYYMM IN (' + @v_cols + ')';
		SET @SQL = @SQL + '			   ) AS P_RST,';
		SET @SQL = @SQL + '            (SELECT ITEM_ID, NICK_NAME, CELL_TYPE_GROUP_CODE ';
		SET @SQL = @SQL + '               FROM DBO.SCP_MST_FINAL_ITEM F WITH (NOLOCK) ';
		SET @SQL = @SQL + '              WHERE DIVISION_ID = ''40'' AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString( ''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '                AND OPERATION_GROUP = ''A'' ) AS F ';

		SET @SQL = @SQL + '		  WHERE 0 = 0';
		SET @SQL = @SQL + '			AND P_RST.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN ( ';
		--SET @SQL = @SQL + ' SELECT DISTINCT EEE.ITEM_ID_ASSY, QTY, YYYYMMDD, EEE.item_id_prod AS ITEM_ID , FROM_SITE  FROM ';		-- 변경
		--SET @SQL = @SQL + ' ( SELECT ITEM_ID_ASSY, SUM(QTY) AS QTY, YYYYMMDD, ''-'' AS FROM_SITE FROM ';								-- 변경
		--SET @SQL = @SQL + ' ( SELECT AAA.*, CASE WHEN BBB.ITEM_ID_ASSY IS NULL THEN AAA.ITEM_ID ';
		--SET @SQL = @SQL + ' ELSE BBB.ITEM_ID_ASSY END AS ITEM_ID_ASSY  FROM (';

		--SET @SQL = @SQL + ' SELECT CELL_ITEM_ID AS ITEM_ID, YYYYMMDD, QTY, FROM_SITE FROM'					--변경
		--SET @SQL = @SQL + '    ( SELECT X.CELL_ITEM_ID, X.FROM_SITE,'										-- 변경
		--SET @SQL = @SQL + '             CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD,'
		--SET @SQL = @SQL + '             SUM(X.AFTER_QTY) AS QTY'
		--SET @SQL = @SQL + '       FROM '
		--SET @SQL = @SQL + '       ('
		--SET @SQL = @SQL + '       SELECT  distinct'
		--SET @SQL = @SQL + '               CELL_ITEM_ID, SCM_SITE_ID AS FROM_SITE, '								-- 변경
		--SET @SQL = @SQL + '              ( CASE WHEN (OSP_YN=''N'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY,'
		--SET @SQL = @SQL + '              ( CASE WHEN (OSP_YN=''N'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''FOR%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)  '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''FOR%'' AND TCO_EXIST_YN =''N'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''003'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM'
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''003'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM'
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''Y'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''INT%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''Y'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		--SET @SQL = @SQL + '                     THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''Y'' AND LOC=''***'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''WH%'' )'
		--SET @SQL = @SQL + '                     THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''INT%'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''WH%'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		--SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''003'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''WH%'' ) '
		--SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		--SET @SQL = @SQL + '                ELSE RECEIVING_DTTM'
		--SET @SQL = @SQL + '                END '
		--SET @SQL = @SQL + '              ) AS AFTER_DTTM'
		--SET @SQL = @SQL + '         FROM'
		--SET @SQL = @SQL + '	  ('
		--SET @SQL = @SQL + '           SELECT A.ITEM_ID,A.SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,''~'') AS SCM_SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,2,''~'') AS LOC,'
		--SET @SQL = @SQL + '            ( SELECT ISNULL(S.OSP_YN,''N'')'
		--SET @SQL = @SQL + '                FROM SCM_MST_SITE S WITH(NOLOCK)'
		--SET @SQL = @SQL + '               WHERE S.DIVISION_ID=''' + @p_division_id + '''';
		--SET @SQL = @SQL + '                 AND S.SCM_SITE_ID =[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,''~'')'
		--SET @SQL = @SQL + '             ) AS OSP_YN,'
		--SET @SQL = @SQL + '            A.RECEIVING_DTTM,A.QTY,A.LOT_ID,A.DESCR,'
		--SET @SQL = @SQL + '            Y.TCO_CELL_YN,'
		--SET @SQL = @SQL + '            (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID,'
		--SET @SQL = @SQL + '            ( SELECT CASE WHEN MAX(TCO_CELL_ITEM_ID) IS NULL THEN ''N'' ELSE ''Y'' END'
		--SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK)'
		--SET @SQL = @SQL + '               WHERE 1=1'
		--SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		--SET @SQL = @SQL + '             ) AS TCO_EXIST_YN,'
		--SET @SQL = @SQL + '            ( SELECT MAX(CELL_TO_TCO_BOD_LT)'
		--SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK)'
		--SET @SQL = @SQL + '               WHERE 1=1'
		--SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		--SET @SQL = @SQL + '             ) AS CELL_TO_TCO_BOD_LT,'
		--SET @SQL = @SQL + '             ( SELECT MAX(TCO_TO_CELL_BOD_LT)'
		--SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK)'
		--SET @SQL = @SQL + '               WHERE 1=1'
		--SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		--SET @SQL = @SQL + '             ) AS TCO_TO_CELL_BOD_LT,'
		--SET @SQL = @SQL + '             ( SELECT MAX(CELL_TO_TCO_TOTAL_BOD_LT)'
		--SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V WITH(NOLOCK)'
		--SET @SQL = @SQL + '               WHERE 1=1'
		--SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		--SET @SQL = @SQL + '             ) AS CELL_TO_TCO_TOTAL_BOD_LT,'
		--SET @SQL = @SQL + '             ( SELECT ISNULL(MAX(V.FORMATION_TOTAL_YIELD),1)'
		--SET @SQL = @SQL + '                 FROM [dbo].[SCP_MST_FORMATION_V] V WITH(NOLOCK)'
		--SET @SQL = @SQL + '                WHERE V.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '                  AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		--SET @SQL = @SQL + '              ) AS FORMATION_TOTAL_YIELD,'
		--SET @SQL = @SQL + '             ( SELECT ISNULL(MAX(V.TOTAL_LT_FORMATION),0)'
		--SET @SQL = @SQL + '                 FROM [dbo].[SCP_MST_FORMATION_V] V WITH(NOLOCK)'
		--SET @SQL = @SQL + '                WHERE V.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '                  AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		--SET @SQL = @SQL + '              ) AS TOTAL_LT_FORMATION'
		--SET @SQL = @SQL + '       FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  A WITH(NOLOCK)'
		--SET @SQL = @SQL + '       INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)'
		--SET @SQL = @SQL + '               ON 0 = 0'
		--SET @SQL = @SQL + '             AND A.MASTER_ID = ''40::WEEKLY''';
		--SET @SQL = @SQL + '             AND A.PLAN_ID = ''' + @eng_plan_id + '''';
		--SET @SQL = @SQL + '             AND Y.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '             AND A.ITEM_ID     = Y.ITEM_ID'
		--SET @SQL = @SQL + '             AND Y.OPERATION_GROUP=''A'''
		--SET @SQL = @SQL + '	         ) XLS_BOH'
		--SET @SQL = @SQL + '       ) X'
		--SET @SQL = @SQL + '	where CONVERT(VARCHAR,X.AFTER_DTTM,112) < ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '       GROUP BY X.CELL_ITEM_ID, X.FROM_SITE,'						-- 변경
		--SET @SQL = @SQL + '               CONVERT(VARCHAR,X.AFTER_DTTM,112)'
		--SET @SQL = @SQL + ') X where YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)'

		--SET @SQL = @SQL + '		) AS AAA LEFT OUTER JOIN	'
		--SET @SQL = @SQL + ' ( SELECT DISTINCT PLANT_ID, ITEM_ID_ASSY, ITEM_ID_PROD FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) '		-- 변경
		--SET @SQL = @SQL + ' ) BBB '
		--SET @SQL = @SQL + ' ON AAA.ITEM_ID = BBB.ITEM_ID_PROD AND	SUBSTRING(AAA.FROM_SITE,1,4) = BBB.PLANT_ID	'						-- 변경
		--SET @SQL = @SQL + ' ) CCC '
		--SET @SQL = @SQL + ' GROUP BY ITEM_ID_ASSY,YYYYMMDD  '						
		--SET @SQL = @SQL + ' ) DDD LEFT OUTER JOIN '
		--SET @SQL = @SQL + ' ( SELECT DISTINCT ITEM_ID_ASSY, ITEM_ID_PROD FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) 	WHERE CELL_TYPE = ''CA1''	'		-- 변경 (plant별로 관리되므로, 중복 제거함)
		--SET @SQL = @SQL + ' ) EEE ON DDD.ITEM_ID_ASSY = EEE.ITEM_ID_ASSY  '			

		-- 각 아이템별 BOH 계산
		SET @SQL = @SQL + ' SELECT DISTINCT EEE.ITEM_ID_ASSY, SUM_QTY AS QTY, YYYYMMDD, EEE.ITEM_ID_PROD AS ITEM_ID, FROM_SITE  ';
		SET @SQL = @SQL + ' FROM  (  ';
		-- (PROD / ASSY), (ASSY / ASSY) 인 것   
		SET @SQL = @SQL + ' 		SELECT A.ITEM_ID_PROD, A.ITEM_ID_ASSY, A.QTY+B.QTY AS SUM_QTY, A.YYYYMMDD, A.FROM_SITE ';
		SET @SQL = @SQL + ' 		FROM  #tmp_PLN_STOCK_PLAN A WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		INNER JOIN #tmp_PLN_STOCK_PLAN B WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		ON A.ITEM_ID_ASSY = B.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' 		WHERE A.ITEM_ID_PROD <> B.ITEM_ID_ASSY '; 
		SET @SQL = @SQL + ' ) DDD  ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN  (  ';
		SET @SQL = @SQL + ' 					SELECT DISTINCT ITEM_ID_ASSY, ITEM_ID_PROD  ';
		SET @SQL = @SQL + ' 					FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock)   ';
		SET @SQL = @SQL + ' 					WHERE CELL_TYPE = ''CA1'' ';
		SET @SQL = @SQL + ' 				) EEE  ';
		SET @SQL = @SQL + ' ON DDD.ITEM_ID_ASSY = EEE.ITEM_ID_ASSY  ';
		SET @SQL = @SQL + ' AND  DDD.ITEM_ID_PROD = EEE.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' UNION ALL ';
		SET @SQL = @SQL + ' SELECT DISTINCT EEE.ITEM_ID_ASSY, SUM_QTY, YYYYMMDD, EEE.ITEM_ID_PROD AS ITEM_ID, FROM_SITE   ';
		SET @SQL = @SQL + ' FROM  (  ';
		-- (PROD / ASSY), (ASSY / ASSY) 인데 이 중 (ASSY / ASSY) 수량은 중복되므로 삭제
		SET @SQL = @SQL + ' 		SELECT A.ITEM_ID_PROD, A.ITEM_ID_ASSY, A.QTY AS SUM_QTY, A.YYYYMMDD, A.FROM_SITE ';
		SET @SQL = @SQL + ' 		FROM  #tmp_PLN_STOCK_PLAN A WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		WHERE A.ITEM_ID_PROD = A.ITEM_ID_ASSY   ';
		SET @SQL = @SQL + ' 		AND	  NOT EXISTS ( ';
		SET @SQL = @SQL + ' 							SELECT B.ITEM_ID_PROD, B.ITEM_ID_ASSY, B.QTY AS SUM_QTY, B.YYYYMMDD, B.FROM_SITE ';
		SET @SQL = @SQL + ' 							FROM  #tmp_PLN_STOCK_PLAN B WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 							WHERE B.ITEM_ID_PROD <> B.ITEM_ID_ASSY  ';
		SET @SQL = @SQL + ' 							AND   B.ITEM_ID_ASSY = A.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' 						 ) ';
		SET @SQL = @SQL + ' 		UNION ALL  ';
		--  ( PROD / ASSY ) 1개만 있는 것
		SET @SQL = @SQL + ' 		SELECT A.ITEM_ID_PROD, A.ITEM_ID_ASSY, ISNULL(A.QTY,0) + ISNULL(B.QTY,0) AS SUM_QTY, A.YYYYMMDD, A.FROM_SITE ';
		SET @SQL = @SQL + ' 		FROM  #tmp_PLN_STOCK_PLAN A WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		LEFT OUTER JOIN #tmp_PLN_STOCK_PLAN B WITH(NOLOCK) ';
		SET @SQL = @SQL + ' 		ON A.ITEM_ID_ASSY = B.ITEM_ID_PROD ';
		SET @SQL = @SQL + ' 		WHERE B.ITEM_ID_PROD IS NULL ';
		SET @SQL = @SQL + ' ) DDD  ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN  (  ';
		SET @SQL = @SQL + ' 					SELECT DISTINCT ITEM_ID_ASSY, ITEM_ID_PROD  ';
		SET @SQL = @SQL + ' 					FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock)   ';
		SET @SQL = @SQL + ' 					WHERE CELL_TYPE = ''CA1'' ';
		SET @SQL = @SQL + ' 				) EEE  ';
		SET @SQL = @SQL + ' ON DDD.ITEM_ID_ASSY = EEE.ITEM_ID_ASSY  ';

		SET @SQL = @SQL + '	   ) B';
		SET @SQL = @SQL + '	ON P.ITEM_ID = B.ITEM_ID '		
		SET @SQL = @SQL + ') PV1,';

		-----------------------
		-- PIVOT2 : Frozen 구간
		-----------------------
		SET @SQL = @SQL + '(';
		SET @SQL = @SQL + 'SELECT   P.DIVISION_ID';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE';
		SET @SQL = @SQL + '        ,P.SEQ';
		SET @SQL = @SQL + '        ,P.ITEM_ID';
		SET @SQL = @SQL + '        ,P.DEPT_ID';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO';
		SET @SQL = @SQL + '        ,P.FROM_SITE';					-- 추가
		SET @SQL = @SQL + '        ,P.MEASURE';
		SET @SQL = @SQL + '        ,P.DEPT_ORD';
		SET @SQL = @SQL + '        ,P.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_wcols2;
		SET @SQL = @SQL + '  FROM (';

		SET @SQL = @SQL + '  SELECT P_RST.*';
		SET @SQL = @SQL + '    FROM (';
		SET @SQL = @SQL + '          SELECT W2.DIVISION_ID';
		SET @SQL = @SQL + '                ,W2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '                ,W2.PLAN_TYPE';
		SET @SQL = @SQL + '                ,W2.SEQ';
		SET @SQL = @SQL + '                ,W2.ITEM_ID';
		SET @SQL = @SQL + '                ,W2.DEPT_ID';
		SET @SQL = @SQL + '                ,W2.DEPT_NAME_EN';
		SET @SQL = @SQL + '                ,W2.DEPT_NAME_KO';
		SET @SQL = @SQL + '                ,W2.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '                ,W2.MEASURE';
		SET @SQL = @SQL + '                ,W2.DEPT_ORD';
		SET @SQL = @SQL + '                ,W2.XLS_ORD';
		--SET @SQL = @SQL + '                ,W2.QTY';
		SET @SQL = @SQL + '                ,(CASE WHEN W2.MEASURE = ''SHIP_PLAN'' THEN (CASE WHEN W1.S_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + ''' OR W1.E_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + ''' THEN 0 ELSE W2.QTY END) ELSE W2.QTY END) AS QTY';
		SET @SQL = @SQL + '                ,W1.S_YYYYMMDD + ''~'' + W1.E_YYYYMMDD AS W_DAY';
		SET @SQL = @SQL + '            FROM ';
		-- 이하 WEEK 플랜구분 (1 ~ 3 주, 4~마지막)
		SET @SQL = @SQL + '                 (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM';
        SET @SQL = @SQL + '                    FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM';
        SET @SQL = @SQL + '                                 ,C.BASIS_YYYYMMDD AS E_YYYYMMDD';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,' + CONVERT(VARCHAR, @v_frozen_days) + ',CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)';
		SET @SQL = @SQL + '                             AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
        SET @SQL = @SQL + '                         ) S1,';
		SET @SQL = @SQL + '                         (SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM';
		SET @SQL = @SQL + '                                ,C.BASIS_YYYYMMDD AS S_YYYYMMDD';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,' + CONVERT(VARCHAR, @v_frozen_days) + ',CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)';
		SET @SQL = @SQL + '                             AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2';
        SET @SQL = @SQL + '                         ) S2';
        SET @SQL = @SQL + '                   WHERE S1.R_NUM = S2.R_NUM';

		-- Week Plan 
        SET @SQL = @SQL + '                   UNION ALL';
		SET @SQL = @SQL + '                  SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM';
        SET @SQL = @SQL + '                    FROM (SELECT  ROW_NUMBER() OVER(ORDER BY MAX(C.BASIS_YYYYMMDD) ASC) AS R_NUM';
        SET @SQL = @SQL + '                                 ,MAX(C.BASIS_YYYYMMDD) AS E_YYYYMMDD';
		SET @SQL = @SQL + '                                 ,C.PARTIAL_WEEK_NAME';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <= ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + '                           GROUP BY C.PARTIAL_WEEK_NAME ';
        SET @SQL = @SQL + '                         ) S1,';
		SET @SQL = @SQL + '                         (SELECT ROW_NUMBER() OVER(ORDER BY MIN(C.BASIS_YYYYMMDD) ASC) AS R_NUM';
		SET @SQL = @SQL + '                                ,MIN(C.BASIS_YYYYMMDD) AS S_YYYYMMDD';
		SET @SQL = @SQL + '                                ,C.PARTIAL_WEEK_NAME';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @v_weekplan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <= ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + '                           GROUP BY C.PARTIAL_WEEK_NAME ';
        SET @SQL = @SQL + '                         ) S2';
        SET @SQL = @SQL + '                   WHERE S1.R_NUM = S2.R_NUM';

		SET @SQL = @SQL + '                 ) W1,';
		-- 이하 WEEK 구간 Measure 별 data
		SET @SQL = @SQL + '			        (SELECT R.DIVISION_ID';
		SET @SQL = @SQL + '			               ,R.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			               ,R.PLAN_TYPE';
		SET @SQL = @SQL + '			               ,R.SEQ';
		SET @SQL = @SQL + '			               ,R.ITEM_ID';
		SET @SQL = @SQL + '			               ,R.DEPT_ID';
		SET @SQL = @SQL + '			               ,R.DEPT_NAME_EN';
		SET @SQL = @SQL + '			               ,R.DEPT_NAME_KO';
		SET @SQL = @SQL + '			               ,R.FROM_SITE';			-- 추가
		SET @SQL = @SQL + '			               ,R.MEASURE';
		SET @SQL = @SQL + '			               ,R.DEPT_ORD';
		SET @SQL = @SQL + '			               ,R.XLS_ORD';
		SET @SQL = @SQL + '			               ,R.YYYYMM';
		SET @SQL = @SQL + '			               ,R.YYYYMMDD';
		SET @SQL = @SQL + '			               ,R.QTY';
		SET @SQL = @SQL + '			               ,R.MST_SEQ';
		-- -- SCP_ANL_SHIPMENT_PLAN_FG (MKT_FCST, SHIP_REQ, SHIP_PLAN, SHIP_PLAN_AMEND)

		SET @SQL = @SQL + '			 FROM #tmp_WEEK_SHIPMENT_PLAN_FG_1 R WITH(NOLOCK) ,    #tmp_WEEK_SHIPMENT_PLAN_FG_2 Q WITH(NOLOCK)     ';

		SET @SQL = @SQL + '	            		  WHERE R.MST_SEQ             = Q.MST_SEQ';
		SET @SQL = @SQL + '	            		    AND R.DIVISION_ID         = Q.DIVISION_ID';
		SET @SQL = @SQL + '	            		    AND R.PLAN_START_YYYYMMDD = Q.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            		    AND R.PLAN_TYPE = Q.PLAN_TYPE';
		SET @SQL = @SQL + '	            		    AND R.SEQ       = Q.SEQ';
		SET @SQL = @SQL + '	            		    AND R.ITEM_ID   = Q.ITEM_ID';
		SET @SQL = @SQL + '	            		    AND R.FROM_SITE = Q.FROM_SITE';				-- 추가
		SET @SQL = @SQL + '	            		    AND R.MEASURE   = Q.MEASURE';
		SET @SQL = @SQL + '	            		    AND R.YYYYMM    = Q.YYYYMM';
		SET @SQL = @SQL + '	            		    AND R.YYYYMMDD    = Q.YYYYMMDD';		-->>>
		SET @SQL = @SQL + '	            		  UNION ALL';
		SET @SQL = @SQL + '	            		 SELECT  P.DIVISION_ID';
		SET @SQL = @SQL + '	            				,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            				,P.PLAN_TYPE';
		SET @SQL = @SQL + '	            				,P.SEQ';
		
		SET @SQL = @SQL + '		, (	';
	  	SET @SQL = @SQL + '			CASE (SELECT COUNT(DISTINCT( ITEM_ID_PROD)) FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID	) ';
	 	SET @SQL = @SQL + '			WHEN  0 THEN P.ITEM_ID	';
	 	SET @SQL = @SQL + '			WHEN 1 THEN (  SELECT DISTINCT ITEM_ID_PROD FROM SCP_MST_CELL_PROD_ASSY_MAP with(nolock) WHERE ITEM_ID_ASSY = P.ITEM_ID ) ';
	 	SET @SQL = @SQL + '			END ';
	 	SET @SQL = @SQL + '		) AS ITEM_ID ';
		

		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '	            				, P.SCM_SITE_ID';			-- 추가
		SET @SQL = @SQL + '	            				,P.MEASURE'
		SET @SQL = @SQL + '	            				,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '	            				,900  AS XLS_ORD';
		SET @SQL = @SQL + '	            				,SUBSTRING(CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), 1, 6) AS YYYYMM';     --SUBSTRING(P.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '	            				,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) AS YYYYMMDD';   --P.YYYYMMDD';
		SET @SQL = @SQL + '	            				,SUM(ROUND(P.QTY * ISNULL(F.SSP_MODIFY_YIELD, 1), 0)) AS QTY';------EDIT BY DHJ 07/10/2023
		SET @SQL = @SQL + '		        	            , 1 AS MST_SEQ';
		SET @SQL = @SQL + '	            			FROM [DBO].[SCP_ANL_PRODUCTION_PLAN] P WITH (NOLOCK)';
		SET @SQL = @SQL + '	            			LEFT JOIN [dbo].[SCP_MST_FORMATION] F WITH (NOLOCK)';
		SET @SQL = @SQL + '	            			ON P.SCM_SITE_ID = F.PLANT_SITE_ID';
		SET @SQL = @SQL + '	            			AND P.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '	            			WHERE 1 = 1';
		SET @SQL = @SQL + '	            			AND P.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '	            			AND P.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	            			AND P.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	            			AND P.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '	            			AND P.OPERATION_GROUP = ''A''';
		SET @SQL = @SQL + '	            			AND P.MEASURE = ''PROD_PLAN_ENGINE''';

		SET @SQL = @SQL + '	 AND (P.ITEM_ID IN  ';
		SET @SQL = @SQL + '					( ';
		SET @SQL = @SQL + @v_items;			-- 20231005 강현준

		SET @SQL = @SQL + '					) ';
		SET @SQL = @SQL + '	  )';

		SET @SQL = @SQL + '	 AND CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + 'GROUP BY P.DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, P.SCM_SITE_ID, MEASURE ,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) , P.ITEM_ID';	-- 변경

		----------------------
		-- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		----------------------
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  ''' + @p_division_id + ''' AS DIVISION_ID';
		SET @SQL = @SQL + '			        ,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '			        ,''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '			        ,E1.value AS ITEM_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            ,E4.PLANT_SITE_ID	AS FROM_SITE';			-- 추가
		SET @SQL = @SQL + '			        ,E2.MEASURE';
		SET @SQL = @SQL + '                 ,99	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,E2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(E3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,E3.YYYYMMDD';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','','')) E1,';
		SET @SQL = @SQL + '			        (SELECT ''PROD_PLAN_ENGINE'' AS MEASURE, 900 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) E2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_weekplan_last_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) E3 , ';		-- 변경
		SET @SQL = @SQL + '			        ( ';		
		SET @SQL = @SQL + '						SELECT PLANT_SITE_ID, ITEM_ID, PRIORITY ';		
		SET @SQL = @SQL + '						FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) ';		
		SET @SQL = @SQL + '						WHERE DIVISION_ID = ''' + @p_division_id + ''' ';		
		SET @SQL = @SQL + '		        		AND   FROM_YYYYMMDD <= ''' + @v_plan_end_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   TO_YYYYMMDD >= ''' + @v_plan_start_yyyymmdd + ''' ';
		SET @SQL = @SQL + '		        		AND   VALID_YN = ''Y'' ';
		SET @SQL = @SQL + '		        	) E4 ';
		SET @SQL = @SQL + '			        WHERE E1.value = E4.ITEM_ID ';	

		SET @SQL = @SQL + '		            	  UNION ALL';
		SET @SQL = @SQL + '		            	 SELECT ''' + @p_division_id + ''' AS DIVISION_ID ';
		SET @SQL = @SQL + '		            			,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '		            			,''' + @p_plan_type + ''' AS PLAN_TYPE ';
		SET @SQL = @SQL + '		            			,''' + @p_seq + ''' AS SEQ ';
		SET @SQL = @SQL + '		            			,ITEM_ID';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            			, ''-'' AS FROM_SITE ';		-- 임시추가
		SET @SQL = @SQL + '		            			,''INVENTORY'' AS MEASURE';
		SET @SQL = @SQL + '		            			,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '		            			,800  AS XLS_ORD';
		SET @SQL = @SQL + '		                    	, SUBSTRING(''' + @p_plan_start_yyyymmdd + ''', 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		            			,''' + @p_plan_start_yyyymmdd + ''' AS YYYYMMDD ';
		SET @SQL = @SQL + '		            			,0    AS QTY';
		SET @SQL = @SQL + '		        	            ,1 AS MST_SEQ';
		SET @SQL = @SQL + '		            	   FROM SCP_MST_FINAL_ITEM WITH (NOLOCK)';
		SET @SQL = @SQL + '		                	  WHERE DIVISION_ID = ''40'' AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '                             AND OPERATION_GROUP = ''A''';
		SET @SQL = @SQL + '                 ) W2';
		SET @SQL = @SQL + '           WHERE W2.YYYYMMDD >= W1.S_YYYYMMDD AND W2.YYYYMMDD <= W1.E_YYYYMMDD';
        SET @SQL = @SQL + '			) AS M';
		SET @SQL = @SQL + '   PIVOT (';
		SET @SQL = @SQL + '          SUM(QTY) FOR W_DAY IN (' + @v_wcols + ')';
		SET @SQL = @SQL + '         ) AS P_RST';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ') PV2';
		SET @SQL = @SQL + ' WHERE PV1.DIVISION_ID         = PV2.DIVISION_ID';
		SET @SQL = @SQL + '   AND PV1.PLAN_START_YYYYMMDD = PV2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '   AND PV1.PLAN_TYPE = PV2.PLAN_TYPE';
		SET @SQL = @SQL + '   AND PV1.SEQ       = PV2.SEQ';
		SET @SQL = @SQL + '   AND PV1.ITEM_ID   = PV2.ITEM_ID';
		SET @SQL = @SQL + '   AND PV1.DEPT_ID   = PV2.DEPT_ID';
		SET @SQL = @SQL + '   AND PV1.FROM_SITE = PV2.FROM_SITE';			-- 추가
		SET @SQL = @SQL + '   AND PV1.MEASURE   = PV2.MEASURE';
		SET @SQL = @SQL + '   AND PV1.XLS_ORD   = PV2.XLS_ORD';
		SET @SQL = @SQL + ' ORDER BY PV1.ITEM_ID, PV1.DEPT_ORD, PV1.DEPT_NAME_KO, PV1.FROM_SITE, PV1.XLS_ORD;';		-- 변경

		--select @sql;
		EXEC(@SQL);


        IF OBJECT_ID('tempdb..#tmp_SCM_MST_SSO_DEPT_USER_INFO') IS NOT NULL
			DROP TABLE #tmp_SCM_MST_SSO_DEPT_USER_INFO
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIPMENT_PLAN_FG') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIPMENT_PLAN_FG
		;

        IF OBJECT_ID('tempdb..#tmp_SCP_ANL_SHIP_DEPT') IS NOT NULL
			DROP TABLE #tmp_SCP_ANL_SHIP_DEPT
		;

		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_MONTH_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_MONTH_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_1') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_1
		;

		IF OBJECT_ID('tempdb..#tmp_WEEK_SHIPMENT_PLAN_FG_2') IS NOT NULL
			DROP TABLE #tmp_WEEK_SHIPMENT_PLAN_FG_2
		;

		IF OBJECT_ID('tempdb..#tmp_PLN_STOCK_PLAN') IS NOT NULL
			DROP TABLE #tmp_PLN_STOCK_PLAN
		;

	END

	 IF @p_parameter2 = 'day_result'		-- RAW 차감후 결과 Sheet
		BEGIN

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364+182,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;		-- PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선' - 중장기 대응 364 -> 364+182
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		SELECT @v_cols = @v_cols + '[' + YYYYMMDD + '],', @v_cols2 = @v_cols2 + 'ISNULL([' + YYYYMMDD + '],0) AS [' + YYYYMMDD + '],'
		  FROM (
			   SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
					AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd
			   ) AS days
		 ORDER BY YYYYMMDD
		 ;		

		 
		SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);
		SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);



		SET @SQL = 'SELECT P.DIVISION_ID ';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN ';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO ';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE ';
		SET @SQL = @SQL + '        ,P.SEQ ';
		SET @SQL = @SQL + '        ,P.PROJECT_CODE ';
		SET @SQL = @SQL + '        ,P.ITEM_ID ';
		SET @SQL = @SQL + '        ,P.NICK_NAME ';
		SET @SQL = @SQL + '        ,P.FROM_SITE ';			-- 추가
		SET @SQL = @SQL + '        ,P.TO_SITE ';
		SET @SQL = @SQL + '        ,P.MEASURE ';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''MKT_FCST'' THEN ''Forcast''  ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ'' THEN ''Ship Req.'' ';
		SET @SQL = @SQL + '			      ELSE ''Ship Plan'' END) AS MEASURE_DESC ';
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '  FROM ( ';
		SET @SQL = @SQL + 'SELECT P_RST.*, F.NICK_NAME ';
		SET @SQL = @SQL + '  FROM ( ';
		SET @SQL = @SQL + '     SELECT   AA.DIVISION_ID ';
		SET @SQL = @SQL + '	        , CC.DEPT_NAME_EN ';
		SET @SQL = @SQL + '	        , CC.DEPT_NAME_KO ';
		SET @SQL = @SQL + '			, AA.PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '			, AA.PLAN_TYPE ';
		SET @SQL = @SQL + '			, AA.SEQ ';
		SET @SQL = @SQL + '			, AA.PROJECT_CODE ';
		SET @SQL = @SQL + '			, AA.ITEM_ID ';
		SET @SQL = @SQL + '			, AA.TO_SITE ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN DD.PLANT_SITE_ID ELSE AA.FROM_SITE END )	AS FROM_SITE  ';		-- 추가
		SET @SQL = @SQL + '			, AA.MEASURE  ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.MEASURE = ''MKT_FCST'' THEN 100 ';
		SET @SQL = @SQL + '			        WHEN AA.MEASURE = ''SHIP_REQ'' THEN 200 ELSE 300 END) AS XLS_ORD ';
		SET @SQL = @SQL + '			, AA.YYYYMMDD ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.FROM_SITE = DD.PLANT_SITE_ID THEN AA.QTY ELSE 0 END )	AS QTY ';		-- 변경
		SET @SQL = @SQL + '       FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK) ';
		SET @SQL = @SQL + '       LEFT  ';
		SET @SQL = @SQL + '       JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK) ';
		SET @SQL = @SQL + '         ON AA.DIVISION_ID = BB.DIVISION_ID ';
		SET @SQL = @SQL + '        AND AA.PROJECT_CODE = BB.PROJECT_CODE ';
		SET @SQL = @SQL + '        AND AA.TO_SITE = BB.SCM_SITE_ID ';
		SET @SQL = @SQL + '        AND AA.ITEM_ID = BB.ITEM_ID ';
		SET @SQL = @SQL + '       LEFT ';
		SET @SQL = @SQL + '       JOIN (SELECT distinct B.USER_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN ';
		SET @SQL = @SQL + '               FROM [SCM_MST_SSO_USER_INFO] AS B ';
		SET @SQL = @SQL + '              INNER  ';
		SET @SQL = @SQL + '                                    JOIN SCM_MST_SSO_DEPT_INFO AS C ';
		SET @SQL = @SQL + '                 ON B.DEPT_ID = C.DEPT_ID) CC ';
		SET @SQL = @SQL + '         ON BB.OWNER = CC.USER_ID ';
		SET @SQL = @SQL + '       LEFT JOIN ( ';
		SET @SQL = @SQL + '       			SELECT DISTINCT DIVISION_ID, PLANT_SITE_ID, ITEM_ID ';
		SET @SQL = @SQL + '       			FROM SCM_MST_SITE_ITEM_PRIORITY WITH(NOLOCK) ';
		SET @SQL = @SQL + '      			WHERE DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '      			AND   FROM_YYYYMMDD <= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '       			AND   TO_YYYYMMDD >= ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '       			AND   VALID_YN = ''Y'' ';
		SET @SQL = @SQL + '      		   ) DD ';
		SET @SQL = @SQL + '       ON AA.DIVISION_ID	= DD.DIVISION_ID ';
		SET @SQL = @SQL + '       AND AA.ITEM_ID = DD.ITEM_ID ';		
		SET @SQL = @SQL + '      WHERE 1 = 1   ';
		SET @SQL = @SQL + '        AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '        AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '        AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '        AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '        AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '        AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '        AND AA.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '        AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'')';
		--SET @SQL = @SQL + '        AND AA.QTY <> 0 ';		-- 2022.11.04 주석처리 :: 저장대상건이 조회되지 않는 오류수정
		SET @SQL = @SQL + '        AND AA.BIZ_TYPE = ''A''';
		SET @SQL = @SQL + '        AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '        AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' 
		SET @SQL = @SQL + '      ) AS M ';
		SET @SQL = @SQL + ' PIVOT ( ';
		SET @SQL = @SQL + '		SUM(QTY) FOR YYYYMMDD IN (' + @v_cols + ')';
		SET @SQL = @SQL + '	   ) AS P_RST, ';
		SET @SQL = @SQL + '    SCP_MST_FINAL_ITEM F WITH (NOLOCK) ';
		SET @SQL = @SQL + '  WHERE 0 = 0 ';
		SET @SQL = @SQL + '    AND P_RST.ITEM_ID = F.ITEM_ID ';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ' ORDER BY P.DEPT_NAME_KO, P.ITEM_ID, P.PROJECT_CODE, P.TO_SITE, P.XLS_ORD, P.FROM_SITE '	

		--select @SQL;
		EXEC(@SQL);
		END

    END

  -----------------------------------------
  -- 'PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선'
  -- XLSPSI22: ESS SHIPMENT PLAN 입력 SIMULATION
  -----------------------------------------  
    IF @P_PGM_CODE = 'XLSPSI22'  --호출시뮬레이터 없음(20231215)
    BEGIN

	SET @p_plan_start_yyyymmdd  = NULL;
	SET @p_plan_type            = 'MA';
	SET @p_seq                  = NULL;

	SET @v_plan_start_yyyymmdd  = NULL;
	SET @v_plan_end_yyyymmdd    = NULL;
	SET @v_seq                  = NULL;
	SET @v_cols                 = NULL;
	SET @v_cols2                = NULL;
	SET @SQL                    = NULL;

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

	 IF @p_parameter2 = ''		-- SHIP REQ Sheet
		BEGIN

		SELECT @v_cols = @v_cols + '[' + YYYYMM + '],', @v_cols2 = @v_cols2 + 'ISNULL([' + YYYYMM + '],0) AS [' + YYYYMM + '],'
		  FROM (
				 SELECT DISTINCT SUBSTRING(C.BASIS_YYYYMMDD, 1, 6) AS YYYYMM
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
					AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,366,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
			   ) AS days
		 ORDER BY YYYYMM
		 ;

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;

		SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);
		SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		-- 2020.02.03 :: 소형 SHIPMENT PLAN 입력 SIMULATION 추가 - ship frozen 구간을 week plan 으로 변경 
		-- Frozen 구간을 위한 변수추가
		SET @v_frozen_end_yyyymmdd  = '';
		SET @v_frozen_days          = 21;
		SET @v_wcols                = '';
		SET @v_wcols2               = '';

		SELECT @v_frozen_days = A.SHIP_FROZEN
		  FROM [DBO].[SCM_MST_SITE] A WITH (NOLOCK)
		 WHERE DIVISION_ID = @p_division_id
		   AND SCM_SITE_ID = (SELECT TOP 1 FROM_SITE
								FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)
							   WHERE DIVISION_ID = @p_division_id
								 AND PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
								 AND PLAN_TYPE = 'MA'
								 AND SEQ = @p_seq
								 AND ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(@p_parameter1,','))
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
		SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_frozen_end_yyyymmdd, 6) + '01'),112)),112);
		SELECT @v_frozen_area_last_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)),112);


		SET @v_wcols = '';
		SET @v_wcols2 = '';
		SELECT @v_wcols = @v_wcols + '[' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],', @v_wcols2 = @v_wcols2 + 'ISNULL([' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],0) AS [' + A.S_YYYYMMDD + '~' + A.E_YYYYMMDD + '],'
		  FROM (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM
				FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
								,C.BASIS_YYYYMMDD AS E_YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
							AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1
						) S1,
						(SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM
							,C.BASIS_YYYYMMDD AS S_YYYYMMDD
						FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
						WHERE 0 = 0
							AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
							AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D, @v_frozen_days,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112)
							AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2
						) S2
				WHERE S1.R_NUM = S2.R_NUM
				UNION ALL
				SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(@v_frozen_end_yyyymmdd ),112)),112) AS S_YYYYMMDD
					,@v_frozen_area_last_yyyymmdd  AS E_YYYYMMDD, 99 AS R_NUM
                 WHERE CONVERT(DATETIME,(@v_frozen_end_yyyymmdd),112) < CONVERT(DATETIME,(@v_frozen_area_last_yyyymmdd),112)
			   ) AS A
		 ORDER BY A.E_YYYYMMDD
		 ;

		SET @v_wcols = SUBSTRING(@v_wcols, 1, LEN(@v_wcols) - 1);
		SET @v_wcols2 = SUBSTRING(@v_wcols2, 1, LEN(@v_wcols2) - 1);

		-- 2021.03.08   KSW           소형 SHIPMENT PLAN 입력 SIMULATION - 일부 모델에서 MKT FCST Measure 가 조회되지 않는 오류수정
		-- 전체쿼리 수정


		SET @SQL = '';
		SET @SQL = @SQL + 'SELECT PV1.DIVISION_ID';
		SET @SQL = @SQL + '      ,PV1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '      ,PV1.PLAN_TYPE';
		SET @SQL = @SQL + '      ,PV1.SEQ';
		SET @SQL = @SQL + '      ,''-'' AS CELL_TYPE';
		SET @SQL = @SQL + '      ,PV1.ITEM_ID';
		SET @SQL = @SQL + '      ,PV1.NICK_NAME';
		SET @SQL = @SQL + '      ,PV1.DEPT_ID';
		SET @SQL = @SQL + '      ,PV1.DEPT_NAME_EN';
		SET @SQL = @SQL + '      ,PV1.DEPT_NAME_KO';
		SET @SQL = @SQL + '      ,PV1.MEASURE';
		SET @SQL = @SQL + '      ,PV1.MEASURE_DESC';
		SET @SQL = @SQL + '      ,PV1.BOH';
		SET @SQL = @SQL + '      ,PV1.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_wcols2;
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '      ,PV1.TOTAL_QTY';
		SET @SQL = @SQL + '      ,PV1.CONFIRM_QTY';
		SET @SQL = @SQL + '      ,PV1.CONFIRM_QTY2';
		SET @SQL = @SQL + '      ,PV1.PLAN_END_YYYYMMDD';
		SET @SQL = @SQL + '      ,PV1.FROZEN';
		SET @SQL = @SQL + '  FROM (';

		-- PIVOT1 : Month Plan
		SET @SQL = @SQL + 'SELECT   P.DIVISION_ID';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE';
		SET @SQL = @SQL + '        ,P.SEQ';
		--SET @SQL = @SQL + '        ,(SELECT SEGMENT2 FROM DBO.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)';
		--SET @SQL = @SQL + '			  WHERE LOOKUP_TYPE = ''CELL_TYPE_GROUP_CODE''';
		--SET @SQL = @SQL + '			    AND VALID_YN =''Y''';
		--SET @SQL = @SQL + '			    AND SEGMENT1 = P.CELL_TYPE_GROUP_CODE) AS CELL_TYPE';
		SET @SQL = @SQL + '        ,P.ITEM_ID';
		SET @SQL = @SQL + '        ,P.NICK_NAME';
		SET @SQL = @SQL + '        ,P.DEPT_ID';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO';
		SET @SQL = @SQL + '        ,P.MEASURE';
		SET @SQL = @SQL + '        ,P.DEPT_ORD';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''MKT_FCST'' THEN ''Forcast''  ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ'' THEN ''Ship Req.'' ';
        SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN''        THEN ''Ship Plan (SSP)'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_PLAN_AMEND''  THEN ''Ship Plan'' ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''PROD_PLAN_ENGINE'' THEN ''Available(Production+L/T)'' ';
		SET @SQL = @SQL + '			      ELSE ''Inventory'' END) AS MEASURE_DESC ';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE <> ''INVENTORY'' THEN 0'
		SET @SQL = @SQL + '               ELSE ISNULL(B.QTY, 0)'
		SET @SQL = @SQL + '           END) AS BOH';
		SET @SQL = @SQL + '        ,P.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '        ,0 AS TOTAL_QTY ';
		SET @SQL = @SQL + '        ,0 AS CONFIRM_QTY ';
		SET @SQL = @SQL + '        ,0 AS CONFIRM_QTY2 ';
		SET @SQL = @SQL + '        ,''' + @v_plan_end_yyyymmdd + ''' AS PLAN_END_YYYYMMDD';
		--SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''SHIP_PLAN_AMEND'' THEN';
		--SET @SQL = @SQL + '                    (SELECT (CASE WHEN SHIP_FROZEN > 0 THEN SHIP_FROZEN - 1 ELSE SHIP_FROZEN END) AS FROZEN';
		--SET @SQL = @SQL + '                       FROM [DBO].[SCM_MST_SITE] A WITH (NOLOCK)';
		--SET @SQL = @SQL + '                      WHERE DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '                        AND SCM_SITE_ID = (SELECT TOP 1 FROM_SITE';
		--SET @SQL = @SQL + '                                             FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] B WITH(NOLOCK)';
		--SET @SQL = @SQL + '                                            WHERE DIVISION_ID = P.DIVISION_ID';
		--SET @SQL = @SQL + '                                              AND PLAN_START_YYYYMMDD = P.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '                                              AND PLAN_TYPE = P.PLAN_TYPE';
		--SET @SQL = @SQL + '                                              AND SEQ = P.SEQ';
		--SET @SQL = @SQL + '                                              AND ITEM_ID = P.ITEM_ID';
		--SET @SQL = @SQL + '                                              AND BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '                                              AND MEASURE = P.MEASURE)';
		--SET @SQL = @SQL + '                        AND OPERATION_GROUP = ''P''';
		--SET @SQL = @SQL + '                        AND SITE_TYPE = ''PLANT''';
		--SET @SQL = @SQL + '                        AND VALID_YN = ''Y''';
		--SET @SQL = @SQL + '                        AND OSP_YN = ''Y'')';
		--SET @SQL = @SQL + '               ELSE 0 END) AS FROZEN';

		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''SHIP_PLAN_AMEND'' THEN';
		SET @SQL = @SQL + '                    (CASE WHEN ' + CONVERT(VARCHAR, @v_frozen_days) + ' > 0 THEN ' + CONVERT(VARCHAR, @v_frozen_days) + ' - 1 ELSE ' + CONVERT(VARCHAR, @v_frozen_days) + ' END)';
		SET @SQL = @SQL + '               ELSE 0 END) AS FROZEN';
		SET @SQL = @SQL + '  FROM (';
		SET @SQL = @SQL + '		SELECT P_RST.*, F.NICK_NAME, F.CELL_TYPE_GROUP_CODE';
		SET @SQL = @SQL + '		  FROM (';
		SET @SQL = @SQL + '			 SELECT  R.DIVISION_ID';
		SET @SQL = @SQL + '			        ,R.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,R.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,R.SEQ';
		SET @SQL = @SQL + '			        ,R.ITEM_ID';
		SET @SQL = @SQL + '	        		,R.DEPT_ID';
		SET @SQL = @SQL + '	        		,R.DEPT_NAME_EN';
		SET @SQL = @SQL + '	        		,R.DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,R.MEASURE';
		SET @SQL = @SQL + '	        		,R.DEPT_ORD';
		SET @SQL = @SQL + '	        		,R.XLS_ORD';
		SET @SQL = @SQL + '			        ,R.YYYYMM';
		SET @SQL = @SQL + '			        ,R.QTY';
		SET @SQL = @SQL + '			   FROM (';
		SET @SQL = @SQL + '			         SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '		        			, AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        			, AA.PLAN_TYPE';
		SET @SQL = @SQL + '		        			, AA.SEQ';
		SET @SQL = @SQL + '				        	, AA.ITEM_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			, CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        			, AA.MEASURE';
		SET @SQL = @SQL + '		        			, 10	AS DEPT_ORD';
		SET @SQL = @SQL + '		        			, (CASE WHEN AA.MEASURE = ''MKT_FCST''  THEN 100';
        SET @SQL = @SQL + '			        				WHEN AA.MEASURE = ''SHIP_REQ''  THEN 200';
        SET @SQL = @SQL + '			        				WHEN AA.MEASURE = ''SHIP_PLAN'' THEN 300';
        SET @SQL = @SQL + '			        				WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN 400 END) AS XLS_ORD';
		SET @SQL = @SQL + '		        			, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		        			, ROUND(AA.QTY, 0) AS QTY';
		SET @SQL = @SQL + '		        			, 1 AS MST_SEQ';
		SET @SQL = @SQL + '		        	   FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	   LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        		 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '		        		AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '		        		AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '			        	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '		        	   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			       FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        			      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        				     ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        		 ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	  WHERE 1 = 1';
		SET @SQL = @SQL + '		        		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		        		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '		        		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	        			AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	        			AND AA.SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	        			AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'') ';
		SET @SQL = @SQL + '		        		AND AA.QTY <> 0 ';
		SET @SQL = @SQL + '		        		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '		        		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '		        		AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' ;

		--------------------
		-- 0값 measure 생성
		--------------------
		SET @SQL = @SQL + '		        	  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  N1.DIVISION_ID';
		SET @SQL = @SQL + '			        ,N1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,N1.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,N1.SEQ';
		SET @SQL = @SQL + '			        ,N1.ITEM_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_EN';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,N2.MEASURE';
		SET @SQL = @SQL + '                 ,10	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,N2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (';
		SET @SQL = @SQL + '			         SELECT   BB.DIVISION_ID';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '		        			, ''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '				        	, BB.ITEM_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			, CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	   FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			       FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        			      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        				     ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        		 ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	  WHERE BB.DIVISION_ID = ''' + @p_division_id + '''';
        SET @SQL = @SQL + '		        		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		        		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '			        	AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '			        ) N1,';
		SET @SQL = @SQL + '			        (SELECT ''MKT_FCST'' AS MEASURE, 100 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_REQ'' AS MEASURE, 200 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN'' AS MEASURE, 300 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN_AMEND'' AS MEASURE, 400 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) N2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) N3'

		------ SHIP_PLAN_AMEND 가 없을 경우 SHIP_REQ 를 이용해서 0 값 생성
		--SET @SQL = @SQL + '		        	  UNION ALL';
		--SET @SQL = @SQL + '			         SELECT   AA.DIVISION_ID';
		--SET @SQL = @SQL + '		        			, AA.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '		        			, AA.PLAN_TYPE';
		--SET @SQL = @SQL + '		        			, AA.SEQ';
		--SET @SQL = @SQL + '				        	, AA.ITEM_ID';
		--SET @SQL = @SQL + '	        				, CC.DEPT_ID';
		--SET @SQL = @SQL + '	        				, CC.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		        			, CC.DEPT_NAME_KO';
		--SET @SQL = @SQL + '		        			, ''SHIP_PLAN_AMEND'' AS MEASURE';
		--SET @SQL = @SQL + '		        			, 10	AS DEPT_ORD';
		--SET @SQL = @SQL + '		        			, 400   AS XLS_ORD';
		--SET @SQL = @SQL + '		        			, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '		        			, 0 AS QTY';
		--SET @SQL = @SQL + '		        			, 1 AS MST_SEQ';
		--SET @SQL = @SQL + '		        	   FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		--SET @SQL = @SQL + '		        	   LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		--SET @SQL = @SQL + '		        		 ON AA.DIVISION_ID = BB.DIVISION_ID';
		--SET @SQL = @SQL + '		        		AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		--SET @SQL = @SQL + '		        		AND AA.TO_SITE = BB.SCM_SITE_ID';
		--SET @SQL = @SQL + '			        	AND AA.ITEM_ID = BB.ITEM_ID';
		--SET @SQL = @SQL + '		        	   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		        			       FROM [SCM_MST_SSO_USER_INFO] AS B';
		--SET @SQL = @SQL + '		        			      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		--SET @SQL = @SQL + '		        				     ON B.DEPT_ID = C.DEPT_ID) CC';
		--SET @SQL = @SQL + '		        		 ON BB.OWNER = CC.USER_ID';
		--SET @SQL = @SQL + '		        	  WHERE 1 = 1';
		--SET @SQL = @SQL + '		        		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		        		AND BB.VALID_YN = ''Y''';
		--SET @SQL = @SQL + '		        		AND BB.PROJECT_CODE <> ''-''';
		--SET @SQL = @SQL + '		        		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		        		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '	        			AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		--SET @SQL = @SQL + '	        			AND AA.SEQ       = ''' + @p_seq + '''' ;
		--SET @SQL = @SQL + '	        			AND AA.MEASURE = ''SHIP_REQ''';
		--SET @SQL = @SQL + '		        		AND AA.QTY <> 0 ';
		--SET @SQL = @SQL + '		        		AND AA.BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '		        		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '		        		AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' ;

		-- SHIP_PLAN (SSP), FROZEN COUNT
		SET @SQL = @SQL + '		        	  UNION ALL';
		SET @SQL = @SQL + '                  SELECT   G2.DIVISION_ID';
		SET @SQL = @SQL + '	    			        , G2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	    			        , G2.PLAN_TYPE';
		SET @SQL = @SQL + '	    			        , G2.SEQ';
		SET @SQL = @SQL + '		        	        , G2.ITEM_ID';
		SET @SQL = @SQL + '					        , G2.DEPT_ID';
		SET @SQL = @SQL + '					        , G2.DEPT_NAME_EN';
		SET @SQL = @SQL + '	    			        , G2.DEPT_NAME_KO';
		SET @SQL = @SQL + '	    			        , G1.MEASURE';
		SET @SQL = @SQL + '	    			        , G2.DEPT_ORD';
		SET @SQL = @SQL + '	    			        , G1.XLS_ORD';
		SET @SQL = @SQL + '	    			        , G2.YYYYMM';
		SET @SQL = @SQL + '	    			        , (CASE WHEN G1.MEASURE = ''SHIP_PLAN'' THEN G2.QTY ELSE G2.CNT END) AS QTY';
		SET @SQL = @SQL + '	    			        , 1 AS MST_SEQ';
		SET @SQL = @SQL + '                    FROM (SELECT ''SHIP_PLAN''    AS MEASURE, 300 AS XLS_ORD) G1,';
		--SET @SQL = @SQL + '                           UNION ALL';
		--SET @SQL = @SQL + '                          SELECT ''FROZEN_COUNT'' AS MEASURE, 310 AS XLS_ORD) G1,';
		SET @SQL = @SQL + '     	    	        (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '     	    			        , AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '     	    			        , AA.PLAN_TYPE';
		SET @SQL = @SQL + '     	    			        , AA.SEQ';
		SET @SQL = @SQL + '     		        	        , AA.ITEM_ID';
		SET @SQL = @SQL + '     					        , CC.DEPT_ID';
		SET @SQL = @SQL + '     					        , CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '     	    			        , CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '     	    			        , AA.MEASURE';
		SET @SQL = @SQL + '     	    			        , 10	AS DEPT_ORD';
		SET @SQL = @SQL + '     	    			        , 300   AS XLS_ORD';
		SET @SQL = @SQL + '     	    			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '     	    			        , AA.QTY';
		SET @SQL = @SQL + '     	    			        , 1 AS CNT';
		SET @SQL = @SQL + '     	    	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '     	    	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '     	    	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '     	    		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '     	    		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '     	                	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '     	    	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '     	    		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '     	    		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '     	    			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '     	    		         ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '     					   LEFT OUTER JOIN (SELECT  SCM_SITE_ID';
		SET @SQL = @SQL + '     					                    , (CASE WHEN SHIP_FROZEN > 0 THEN SHIP_FROZEN - 1 ELSE SHIP_FROZEN END) AS SHIP_FROZEN';
		SET @SQL = @SQL + '     					                FROM [DBO].[SCM_MST_SITE] WITH(NOLOCK)';
		SET @SQL = @SQL + '     					               WHERE  1 = 1 ';
		SET @SQL = @SQL + '     					                 AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '     					                 AND OPERATION_GROUP = ''P''';
		SET @SQL = @SQL + '     					                 AND SITE_TYPE = ''PLANT''';
		SET @SQL = @SQL + '      					                 AND VALID_YN = ''Y''';
		SET @SQL = @SQL + '                                          AND OSP_YN = ''Y'') SF';
		SET @SQL = @SQL + '     						 ON AA.FROM_SITE = SF.SCM_SITE_ID';
		SET @SQL = @SQL + '     	    	          WHERE 1 = 1';
		SET @SQL = @SQL + '     	            		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '     	            		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '     	            		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '     	            		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '     	            		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '     		        		AND AA.PLAN_TYPE = ''MA''';
		SET @SQL = @SQL + '     		        		AND AA.SEQ       = ''1''';
		SET @SQL = @SQL + '     		        		AND AA.MEASURE IN (''SHIP_PLAN'')';
		SET @SQL = @SQL + '     	            		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '     	            		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '     	    	        	AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112)';
		SET @SQL = @SQL + '                         ) G2 ';

		-- SHIP_PLAN_AMEND 사용자 입력수량
		SET @SQL = @SQL + '		        	  UNION ALL';
		SET @SQL = @SQL + '		        	 SELECT DIVISION_ID';
		SET @SQL = @SQL + '		        		   ,PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        		   ,PLAN_TYPE';
		SET @SQL = @SQL + '		        		   ,SEQ';
		SET @SQL = @SQL + '		        		   ,ITEM_ID';
		SET @SQL = @SQL + '		        		   ,DEPT_ID';
		SET @SQL = @SQL + '		        		   ,DEPT_NAME_EN';
		SET @SQL = @SQL + '		        		   ,DEPT_NAME_KO';
		SET @SQL = @SQL + '		        		   ,MEASURE';
		SET @SQL = @SQL + '		        		   ,DEPT_ORD';
		SET @SQL = @SQL + '		        		   ,XLS_ORD';
		SET @SQL = @SQL + '		        		   ,YYYYMM';
		SET @SQL = @SQL + '		        		   ,ROUND(QTY, 0) AS QTY';
		SET @SQL = @SQL + '		        		   ,2 AS MST_SEQ';
		SET @SQL = @SQL + '		        	   FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)'
		SET @SQL = @SQL + '		        	  WHERE 1 = 1';
		SET @SQL = @SQL + '		        		AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        		AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	        			AND PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	        			AND SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	        			AND MEASURE = ''SHIP_PLAN_AMEND''';
		SET @SQL = @SQL + '	        			AND LAST_UPDATED_BY = ''' + @p_parameter3 + '''';
		SET @SQL = @SQL + '			        ) R,';
		SET @SQL = @SQL + '			        (SELECT MAX(RR.MST_SEQ) AS MST_SEQ';
		SET @SQL = @SQL + '			               ,RR.DIVISION_ID';
		SET @SQL = @SQL + '			               ,RR.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			               ,RR.PLAN_TYPE';
		SET @SQL = @SQL + '			               ,RR.SEQ';
		SET @SQL = @SQL + '				           ,RR.ITEM_ID';
		SET @SQL = @SQL + '				           ,RR.MEASURE';
		SET @SQL = @SQL + '				           ,RR.YYYYMM';
		SET @SQL = @SQL + '		        	   FROM (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '		        			        , AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        			        , AA.PLAN_TYPE';
		SET @SQL = @SQL + '		        			        , AA.SEQ';
		SET @SQL = @SQL + '				        	        , AA.ITEM_ID';
		SET @SQL = @SQL + '	        				        , CC.DEPT_ID';
		SET @SQL = @SQL + '	        				        , CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			        , CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        			        , AA.MEASURE';
		SET @SQL = @SQL + '		        			        , 10	AS DEPT_ORD';
		SET @SQL = @SQL + '		        			        , (CASE WHEN AA.MEASURE = ''MKT_FCST''  THEN 100';
        SET @SQL = @SQL + '			        		        		WHEN AA.MEASURE = ''SHIP_REQ''  THEN 200';
        SET @SQL = @SQL + '			        		        		WHEN AA.MEASURE = ''SHIP_PLAN'' THEN 300';
        SET @SQL = @SQL + '                                         WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN 400 END) AS XLS_ORD';
		SET @SQL = @SQL + '		        			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		        			        , ROUND(AA.QTY, 0) AS QTY';
		SET @SQL = @SQL + '		        			        , 1 AS MST_SEQ';
		SET @SQL = @SQL + '		        	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '		        		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '		        		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '			                	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '		        	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        		         ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	          WHERE 1 = 1';
		SET @SQL = @SQL + '		                		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		                		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		                		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '		                		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		                		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	        	        		AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	        	        		AND AA.SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	        	        		AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'') ';
		SET @SQL = @SQL + '		                		AND AA.QTY <> 0 ';
		SET @SQL = @SQL + '		                		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '		                		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '		        	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' ;

		--------------------
		-- 0값 measure 생성
		--------------------
		SET @SQL = @SQL + '		        	  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  N1.DIVISION_ID';
		SET @SQL = @SQL + '			        ,N1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,N1.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,N1.SEQ';
		SET @SQL = @SQL + '			        ,N1.ITEM_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_EN';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,N2.MEASURE';
		SET @SQL = @SQL + '                 ,10	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,N2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (';
		SET @SQL = @SQL + '			         SELECT   BB.DIVISION_ID';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '		        			, ''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '				        	, BB.ITEM_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			, CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	   FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			       FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        			      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        				     ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        		 ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	  WHERE BB.DIVISION_ID = ''' + @p_division_id + '''';
        SET @SQL = @SQL + '		        		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		        		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '			        	AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '			        ) N1,';
		SET @SQL = @SQL + '			        (SELECT ''MKT_FCST'' AS MEASURE, 100 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_REQ'' AS MEASURE, 200 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN'' AS MEASURE, 300 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN_AMEND'' AS MEASURE, 400 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) N2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) N3'

		-------- SHIP_PLAN_AMEND 가 없을 경우 SHIP_REQ 를 이용해서 0 값 생성
		--SET @SQL = @SQL + '		                	  UNION ALL';
		--SET @SQL = @SQL + '			                 SELECT   AA.DIVISION_ID';
		--SET @SQL = @SQL + '		        			        , AA.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '		        			        , AA.PLAN_TYPE';
		--SET @SQL = @SQL + '		        			        , AA.SEQ';
		--SET @SQL = @SQL + '				        	        , AA.ITEM_ID';
		--SET @SQL = @SQL + '	        				        , CC.DEPT_ID';
		--SET @SQL = @SQL + '	        				        , CC.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		        			        , CC.DEPT_NAME_KO';
		--SET @SQL = @SQL + '		        			        , ''SHIP_PLAN_AMEND'' AS MEASURE';
		--SET @SQL = @SQL + '		        			        , 10	AS DEPT_ORD';
		--SET @SQL = @SQL + '		        			        , 400   AS XLS_ORD';
		--SET @SQL = @SQL + '		        			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '		        			        , 0 AS QTY';
		--SET @SQL = @SQL + '		        			        , 1 AS MST_SEQ';
		--SET @SQL = @SQL + '		        	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		--SET @SQL = @SQL + '		        	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		--SET @SQL = @SQL + '		        	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		--SET @SQL = @SQL + '		        		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		--SET @SQL = @SQL + '		        		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		--SET @SQL = @SQL + '			                	AND AA.ITEM_ID = BB.ITEM_ID';
		--SET @SQL = @SQL + '		        	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		        		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		--SET @SQL = @SQL + '		        		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		--SET @SQL = @SQL + '		        			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		--SET @SQL = @SQL + '		        		         ON BB.OWNER = CC.USER_ID';
		--SET @SQL = @SQL + '		        	          WHERE 1 = 1';
		--SET @SQL = @SQL + '		                		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		                		AND BB.VALID_YN = ''Y''';
		--SET @SQL = @SQL + '		                		AND BB.PROJECT_CODE <> ''-''';
		--SET @SQL = @SQL + '		                		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		                		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '	        	        		AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		--SET @SQL = @SQL + '	        	        		AND AA.SEQ       = ''' + @p_seq + '''' ;
		--SET @SQL = @SQL + '	        	        		AND AA.MEASURE = ''SHIP_REQ''';
		--SET @SQL = @SQL + '		                		AND AA.QTY <> 0 ';
		--SET @SQL = @SQL + '		                		AND AA.BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '		                		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '		        	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' ;

        -- SHIP_PLAN (SSP), FROZEN COUNT 사용자입력확인
		SET @SQL = @SQL + '		                	  UNION ALL';
		SET @SQL = @SQL + '                          SELECT   G2.DIVISION_ID';
		SET @SQL = @SQL + '	            			        , G2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            			        , G2.PLAN_TYPE';
		SET @SQL = @SQL + '	            			        , G2.SEQ';
		SET @SQL = @SQL + '		                	        , G2.ITEM_ID';
		SET @SQL = @SQL + '		        			        , G2.DEPT_ID';
		SET @SQL = @SQL + '		        			        , G2.DEPT_NAME_EN';
		SET @SQL = @SQL + '	            			        , G2.DEPT_NAME_KO';
		SET @SQL = @SQL + '	            			        , G1.MEASURE';
		SET @SQL = @SQL + '	            			        , G2.DEPT_ORD';
		SET @SQL = @SQL + '	            			        , G1.XLS_ORD';
		SET @SQL = @SQL + '	            			        , G2.YYYYMM';
		SET @SQL = @SQL + '	            			        , (CASE WHEN G1.MEASURE = ''SHIP_PLAN'' THEN G2.QTY ELSE G2.CNT END) AS QTY';
		SET @SQL = @SQL + '	            			        , 1 AS MST_SEQ';
		SET @SQL = @SQL + '                            FROM (SELECT ''SHIP_PLAN''    AS MEASURE, 300 AS XLS_ORD) G1,';
		--SET @SQL = @SQL + '                                   UNION ALL';
		--SET @SQL = @SQL + '                                  SELECT ''FROZEN_COUNT'' AS MEASURE, 310 AS XLS_ORD) G1,';
		SET @SQL = @SQL + '             	    	        (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '             	    			        , AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '             	    			        , AA.PLAN_TYPE';
		SET @SQL = @SQL + '             	    			        , AA.SEQ';
		SET @SQL = @SQL + '             		        	        , AA.ITEM_ID';
		SET @SQL = @SQL + '             					        , CC.DEPT_ID';
		SET @SQL = @SQL + '             					        , CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '             	    			        , CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '             	    			        , AA.MEASURE';
		SET @SQL = @SQL + '             	    			        , 10	AS DEPT_ORD';
		SET @SQL = @SQL + '             	    			        , 300   AS XLS_ORD';
		SET @SQL = @SQL + '             	    			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '             	    			        , AA.QTY';
		SET @SQL = @SQL + '             	    			        , 1 AS CNT';
		SET @SQL = @SQL + '             	    	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '             	    	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '             	    	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '             	    		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '             	    		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '             	                	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '             	    	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '             	    		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '             	    		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '             	    			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '             	    		         ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '             					   LEFT OUTER JOIN (SELECT  SCM_SITE_ID';
		SET @SQL = @SQL + '             					                    , (CASE WHEN SHIP_FROZEN > 0 THEN SHIP_FROZEN - 1 ELSE SHIP_FROZEN END) AS SHIP_FROZEN';
		SET @SQL = @SQL + '             					                FROM [DBO].[SCM_MST_SITE] WITH(NOLOCK)';
		SET @SQL = @SQL + '             					               WHERE  1 = 1 ';
		SET @SQL = @SQL + '             					                 AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             					                 AND OPERATION_GROUP = ''P''';
		SET @SQL = @SQL + '             					                 AND SITE_TYPE = ''PLANT''';
		SET @SQL = @SQL + '              					                 AND VALID_YN = ''Y''';
		SET @SQL = @SQL + '                                                  AND OSP_YN = ''Y'') SF';
		SET @SQL = @SQL + '             						 ON AA.FROM_SITE = SF.SCM_SITE_ID';
		SET @SQL = @SQL + '             	    	          WHERE 1 = 1';
		SET @SQL = @SQL + '             	            		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             	            		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '             	            		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '             	            		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             	            		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '             		        		AND AA.PLAN_TYPE = ''MA''';
		SET @SQL = @SQL + '             		        		AND AA.SEQ       = ''1''';
		SET @SQL = @SQL + '             		        		AND AA.MEASURE IN (''SHIP_PLAN'')';
		SET @SQL = @SQL + '             	            		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '             	            		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '             	    	        	AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112)';
		SET @SQL = @SQL + '                                 ) G2 ';
		SET @SQL = @SQL + '		        	          UNION ALL';
		SET @SQL = @SQL + '		                	 SELECT DIVISION_ID';
		SET @SQL = @SQL + '		                		   ,PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        	        	   ,PLAN_TYPE';
		SET @SQL = @SQL + '		        	        	   ,SEQ';
		SET @SQL = @SQL + '		        	        	   ,ITEM_ID';
		SET @SQL = @SQL + '		        	        	   ,DEPT_ID';
		SET @SQL = @SQL + '		        	        	   ,DEPT_NAME_EN';
		SET @SQL = @SQL + '		        	        	   ,DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	        	   ,MEASURE';
		SET @SQL = @SQL + '		        	        	   ,DEPT_ORD';
		SET @SQL = @SQL + '		        	        	   ,XLS_ORD';
		SET @SQL = @SQL + '		        	        	   ,YYYYMM';
		SET @SQL = @SQL + '		        	        	   ,ROUND(QTY, 0) AS QTY ';
		SET @SQL = @SQL + '		        	        	   ,2 AS MST_SEQ';
		SET @SQL = @SQL + '		        	           FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK) '
		SET @SQL = @SQL + '		        	          WHERE 1 = 1';
		SET @SQL = @SQL + '		        	        	AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        	        	AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	        		        	AND PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	        		        	AND SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	        		        	AND MEASURE = ''SHIP_PLAN_AMEND''';
		SET @SQL = @SQL + '	        			        AND LAST_UPDATED_BY = ''' + @p_parameter3 + '''';
		SET @SQL = @SQL + '			                ) RR';
		SET @SQL = @SQL + '			          GROUP BY RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE, RR.SEQ, RR.ITEM_ID, RR.MEASURE, RR.YYYYMM';
		SET @SQL = @SQL + '			        ) Q';
		SET @SQL = @SQL + '			  WHERE R.MST_SEQ             = Q.MST_SEQ';
		SET @SQL = @SQL + '			    AND R.DIVISION_ID         = Q.DIVISION_ID';
		SET @SQL = @SQL + '			    AND R.PLAN_START_YYYYMMDD = Q.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			    AND R.PLAN_TYPE = Q.PLAN_TYPE';
		SET @SQL = @SQL + '			    AND R.SEQ       = Q.SEQ';
		SET @SQL = @SQL + '			    AND R.ITEM_ID   = Q.ITEM_ID';
		SET @SQL = @SQL + '			    AND R.MEASURE   = Q.MEASURE';
		SET @SQL = @SQL + '			    AND R.YYYYMM    = Q.YYYYMM';
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  P.DIVISION_ID';
		SET @SQL = @SQL + '					,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '					,P.PLAN_TYPE';
		SET @SQL = @SQL + '					,P.SEQ';
		SET @SQL = @SQL + '					,P.ITEM_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '					,P.MEASURE'
		SET @SQL = @SQL + '					,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '					,900  AS XLS_ORD';
		SET @SQL = @SQL + '					,SUBSTRING(CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '					,SUBSTRING(P.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '					,ROUND(P.QTY * ISNULL(F.SSP_MODIFY_YIELD, 1), 0) AS QTY';
		SET @SQL = @SQL + '				FROM [DBO].[SCP_ANL_PRODUCTION_PLAN] P WITH (NOLOCK)';
		SET @SQL = @SQL + '				LEFT JOIN [dbo].[SCP_MST_FORMATION] F WITH (NOLOCK)';
		SET @SQL = @SQL + '				ON P.SCM_SITE_ID = F.PLANT_SITE_ID';
		SET @SQL = @SQL + '				AND P.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '				WHERE 1 = 1';
		SET @SQL = @SQL + '				AND P.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '				AND P.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '				AND P.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '				AND P.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '				AND P.OPERATION_GROUP = ''P''';
		SET @SQL = @SQL + '				AND P.MEASURE = ''PROD_PLAN_ENGINE''';
		SET @SQL = @SQL + '				AND P.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '				AND CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''';

		---- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		--SET @SQL = @SQL + '			  UNION ALL';
		--SET @SQL = @SQL + '			 SELECT   AA.DIVISION_ID';
		--SET @SQL = @SQL + '		        	, AA.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '		        	, AA.PLAN_TYPE';
		--SET @SQL = @SQL + '		        	, AA.SEQ';
		--SET @SQL = @SQL + '				    , AA.ITEM_ID';
		--SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		--SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		--SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		--SET @SQL = @SQL + '		        	, ''PROD_PLAN_ENGINE'' AS MEASURE';
		--SET @SQL = @SQL + '					, 99	AS DEPT_ORD';
		--SET @SQL = @SQL + '					, 900   AS XLS_ORD';
		--SET @SQL = @SQL + '		        	, SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '		        	, 0     AS QTY';
		--SET @SQL = @SQL + '		       FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		--SET @SQL = @SQL + '		      WHERE 1 = 1';
		--SET @SQL = @SQL + '		        AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		        AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '	        	AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		--SET @SQL = @SQL + '	        	AND AA.SEQ       = ''' + @p_seq + '''' ;
		--SET @SQL = @SQL + '	        	AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'') ';
		--SET @SQL = @SQL + '		        AND AA.QTY <> 0 ';
		--SET @SQL = @SQL + '		        AND AA.BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '		        AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '		        AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' ;

		----------------------
		-- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		----------------------
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  ''' + @p_division_id + ''' AS DIVISION_ID';
		SET @SQL = @SQL + '			        ,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '			        ,''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '			        ,E1.value AS ITEM_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,E2.MEASURE';
		SET @SQL = @SQL + '                 ,99	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,E2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(E3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		--SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','','')) E1,';
		SET @SQL = @SQL + '			        (SELECT ''PROD_PLAN_ENGINE'' AS MEASURE, 900 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) E2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_plan_end_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) E3';

		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT ''' + @p_division_id + ''' AS DIVISION_ID ';
		SET @SQL = @SQL + '					,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '					,''' + @p_plan_type + ''' AS PLAN_TYPE ';
		SET @SQL = @SQL + '					,''' + @p_seq + ''' AS SEQ ';
		SET @SQL = @SQL + '					,ITEM_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '					, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '					,''INVENTORY'' AS MEASURE';
		SET @SQL = @SQL + '					,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '					,800  AS XLS_ORD';
		SET @SQL = @SQL + '					,''' + @p_plan_start_yyyymmdd + ''' AS YYYYMMDD ';
		SET @SQL = @SQL + '					,0    AS QTY';
		SET @SQL = @SQL + '			   FROM SCP_MST_FINAL_ITEM WITH (NOLOCK)';
		SET @SQL = @SQL + '			  WHERE ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '			  ) AS M';
		SET @SQL = @SQL + '		 PIVOT (';
		SET @SQL = @SQL + '				SUM(QTY) FOR YYYYMM IN (' + @v_cols + ')';
		SET @SQL = @SQL + '			   ) AS P_RST,';
		SET @SQL = @SQL + '				DBO.SCP_MST_FINAL_ITEM F WITH (NOLOCK)';
		SET @SQL = @SQL + '		  WHERE 0 = 0';
		SET @SQL = @SQL + '			AND P_RST.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ' LEFT OUTER JOIN (SELECT CELL_ITEM_ID AS ITEM_ID, YYYYMMDD, QTY FROM'
		SET @SQL = @SQL + '    ( SELECT X.CELL_ITEM_ID,'
		SET @SQL = @SQL + '             CONVERT(VARCHAR,X.AFTER_DTTM,112) AS YYYYMMDD,'
		SET @SQL = @SQL + '             SUM(X.AFTER_QTY) AS QTY'
		SET @SQL = @SQL + '       FROM '
		SET @SQL = @SQL + '       ('
		SET @SQL = @SQL + '       SELECT  distinct'
		SET @SQL = @SQL + '               CELL_ITEM_ID,'
		SET @SQL = @SQL + '              ( CASE WHEN (OSP_YN=''N'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'') THEN QTY * FORMATION_TOTAL_YIELD ELSE QTY END) AS AFTER_QTY,'
		SET @SQL = @SQL + '              ( CASE WHEN (OSP_YN=''N'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,TOTAL_LT_FORMATION+CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,TOTAL_LT_FORMATION,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''FOR%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM)  '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''FOR%'' AND TCO_EXIST_YN =''N'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''001'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,CELL_TO_TCO_TOTAL_BOD_LT,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''003'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM'
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''003'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''N'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM'
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''Y'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''INT%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''Y'' AND LOC=''***'' AND  TCO_CELL_YN=''N'' AND DESCR LIKE ''WH%'' AND TCO_EXIST_YN =''Y'' ) '
		SET @SQL = @SQL + '                     THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''Y'' AND LOC=''***'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''WH%'' )'
		SET @SQL = @SQL + '                     THEN DATEADD(D,TCO_TO_CELL_BOD_LT,RECEIVING_DTTM) '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''INT%'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''002'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''WH%'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		SET @SQL = @SQL + '                     WHEN (OSP_YN=''N'' AND LOC=''003'' AND  TCO_CELL_YN=''Y'' AND DESCR LIKE ''WH%'' ) '
		SET @SQL = @SQL + '                     THEN RECEIVING_DTTM '
		SET @SQL = @SQL + '                ELSE RECEIVING_DTTM'
		SET @SQL = @SQL + '                END '
		SET @SQL = @SQL + '              ) AS AFTER_DTTM'
		SET @SQL = @SQL + '         FROM'
		SET @SQL = @SQL + '	  ('
		SET @SQL = @SQL + '           SELECT A.ITEM_ID,A.SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,''~'') AS SCM_SITE_ID,[dbo].[FN_SCM_SPLIT](A.SITE_ID,2,''~'') AS LOC,'
		SET @SQL = @SQL + '            ( SELECT ISNULL(S.OSP_YN,''Y'')'
		SET @SQL = @SQL + '                FROM SCM_MST_SITE S WITH(NOLOCK)'
		SET @SQL = @SQL + '               WHERE S.DIVISION_ID=''' + @p_division_id + '''';
		SET @SQL = @SQL + '                 AND S.SCM_SITE_ID =[dbo].[FN_SCM_SPLIT](A.SITE_ID,1,''~'')'
		SET @SQL = @SQL + '             ) AS OSP_YN,'
		SET @SQL = @SQL + '            A.RECEIVING_DTTM,A.QTY,A.LOT_ID,A.DESCR,'
		SET @SQL = @SQL + '            Y.TCO_CELL_YN,'
		SET @SQL = @SQL + '            (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END ) AS CELL_ITEM_ID,'
		SET @SQL = @SQL + '            ( SELECT CASE WHEN MAX(TCO_CELL_ITEM_ID) IS NULL THEN ''N'' ELSE ''Y'' END'
		SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V'
		SET @SQL = @SQL + '               WHERE 1=1'
		SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		SET @SQL = @SQL + '             ) AS TCO_EXIST_YN,'
		SET @SQL = @SQL + '            ( SELECT MAX(CELL_TO_TCO_BOD_LT)'
		SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V'
		SET @SQL = @SQL + '               WHERE 1=1'
		SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		SET @SQL = @SQL + '             ) AS CELL_TO_TCO_BOD_LT,'
		SET @SQL = @SQL + '             ( SELECT MAX(TCO_TO_CELL_BOD_LT)'
		SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V'
		SET @SQL = @SQL + '               WHERE 1=1'
		SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		SET @SQL = @SQL + '             ) AS TCO_TO_CELL_BOD_LT,'
		SET @SQL = @SQL + '             ( SELECT MAX(CELL_TO_TCO_TOTAL_BOD_LT)'
		SET @SQL = @SQL + '                FROM SCP_MST_CELL_TCO_RELATION_V V'
		SET @SQL = @SQL + '               WHERE 1=1'
		SET @SQL = @SQL + '                 AND V.CELL_ITEM_ID = (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		SET @SQL = @SQL + '             ) AS CELL_TO_TCO_TOTAL_BOD_LT,'
		SET @SQL = @SQL + '             ( SELECT ISNULL(MAX(V.FORMATION_TOTAL_YIELD),1)'
		SET @SQL = @SQL + '                 FROM [dbo].[SCP_MST_FORMATION_V] V'
		SET @SQL = @SQL + '                WHERE V.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '                  AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		SET @SQL = @SQL + '              ) AS FORMATION_TOTAL_YIELD,'
		SET @SQL = @SQL + '             ( SELECT ISNULL(MAX(V.TOTAL_LT_FORMATION),0)'
		SET @SQL = @SQL + '                 FROM [dbo].[SCP_MST_FORMATION_V] V'
		SET @SQL = @SQL + '                WHERE V.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '                  AND ITEM_ID= (CASE WHEN Y.TCO_CELL_YN = ''Y'' THEN Y.ATTRIBUTE1 ELSE A.ITEM_ID END )'
		SET @SQL = @SQL + '              ) AS TOTAL_LT_FORMATION'
		SET @SQL = @SQL + '       FROM dbo.SCP_PLN_TH_ENG_STOCK_PLAN  A WITH(NOLOCK)'
		SET @SQL = @SQL + '       INNER JOIN SCP_MST_FINAL_ITEM Y WITH(NOLOCK)'
		SET @SQL = @SQL + '               ON 0 = 0'
		SET @SQL = @SQL + '             AND Y.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             AND A.ITEM_ID     = Y.ITEM_ID'
		SET @SQL = @SQL + '             AND Y.OPERATION_GROUP=''P'''
		SET @SQL = @SQL + '	         ) XLS_BOH'
		SET @SQL = @SQL + '       ) X'
		SET @SQL = @SQL + '	where CONVERT(VARCHAR,X.AFTER_DTTM,112) < ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '       GROUP BY X.CELL_ITEM_ID,'
		SET @SQL = @SQL + '               CONVERT(VARCHAR,X.AFTER_DTTM,112)'
		SET @SQL = @SQL + ') X where YYYYMMDD = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)'
		SET @SQL = @SQL + '	   ) B';
		SET @SQL = @SQL + '	ON P.ITEM_ID = B.ITEM_ID'
		SET @SQL = @SQL + ') PV1,';

		-----------------------
		-- PIVOT2 : Frozen 구간
		-----------------------
		SET @SQL = @SQL + '(';
		SET @SQL = @SQL + 'SELECT   P.DIVISION_ID';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE';
		SET @SQL = @SQL + '        ,P.SEQ';
		SET @SQL = @SQL + '        ,P.ITEM_ID';
		SET @SQL = @SQL + '        ,P.DEPT_ID';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO';
		SET @SQL = @SQL + '        ,P.MEASURE';
		SET @SQL = @SQL + '        ,P.DEPT_ORD';
		SET @SQL = @SQL + '        ,P.XLS_ORD';
		SET @SQL = @SQL + '        ,' + @v_wcols2;
		SET @SQL = @SQL + '  FROM (';

		SET @SQL = @SQL + '  SELECT P_RST.*';
		SET @SQL = @SQL + '    FROM (';
		SET @SQL = @SQL + '          SELECT W2.DIVISION_ID';
		SET @SQL = @SQL + '                ,W2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '                ,W2.PLAN_TYPE';
		SET @SQL = @SQL + '                ,W2.SEQ';
		SET @SQL = @SQL + '                ,W2.ITEM_ID';
		SET @SQL = @SQL + '                ,W2.DEPT_ID';
		SET @SQL = @SQL + '                ,W2.DEPT_NAME_EN';
		SET @SQL = @SQL + '                ,W2.DEPT_NAME_KO';
		SET @SQL = @SQL + '                ,W2.MEASURE';
		SET @SQL = @SQL + '                ,W2.DEPT_ORD';
		SET @SQL = @SQL + '                ,W2.XLS_ORD';
		SET @SQL = @SQL + '                ,W2.QTY';
		SET @SQL = @SQL + '                ,W1.S_YYYYMMDD + ''~'' + W1.E_YYYYMMDD AS W_DAY';
		SET @SQL = @SQL + '            FROM ';
		-- 이하 WEEK 플랜구분 (1 ~ 3 주, 4~마지막)
		SET @SQL = @SQL + '                 (SELECT S2.S_YYYYMMDD, S1.E_YYYYMMDD, S1.R_NUM';
        SET @SQL = @SQL + '                    FROM (SELECT  ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM';
        SET @SQL = @SQL + '                                 ,C.BASIS_YYYYMMDD AS E_YYYYMMDD';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,' + CONVERT(VARCHAR, @v_frozen_days) + ',CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)';
		SET @SQL = @SQL + '                             AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
        SET @SQL = @SQL + '                         ) S1,';
		SET @SQL = @SQL + '                         (SELECT ROW_NUMBER() OVER(ORDER BY C.BASIS_YYYYMMDD ASC) AS R_NUM';
		SET @SQL = @SQL + '                                ,C.BASIS_YYYYMMDD AS S_YYYYMMDD';
        SET @SQL = @SQL + '                            FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
        SET @SQL = @SQL + '                           WHERE 0 = 0';
		SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
        SET @SQL = @SQL + '                             AND C.BASIS_YYYYMMDD <  CONVERT(VARCHAR,DATEADD(D,' + CONVERT(VARCHAR, @v_frozen_days) + ',CONVERT(DATETIME,(''' + @p_plan_start_yyyymmdd + '''),112)),112)';
		SET @SQL = @SQL + '                             AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 2';
        SET @SQL = @SQL + '                         ) S2';
        SET @SQL = @SQL + '                   WHERE S1.R_NUM = S2.R_NUM';
        SET @SQL = @SQL + '                   UNION ALL';
        SET @SQL = @SQL + '                  SELECT CONVERT(VARCHAR,DATEADD(D,1,CONVERT(DATETIME,(''' + @v_frozen_end_yyyymmdd + '''),112)),112) AS S_YYYYMMDD';
        SET @SQL = @SQL + '                        ,''' + @v_frozen_area_last_yyyymmdd + ''' AS E_YYYYMMDD, 99 AS R_NUM';
		SET @SQL = @SQL + '                 ) W1,';
		-- 이하 WEEK 구간 Measure 별 data
		SET @SQL = @SQL + '			        (SELECT R.DIVISION_ID';
		SET @SQL = @SQL + '			               ,R.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			               ,R.PLAN_TYPE';
		SET @SQL = @SQL + '			               ,R.SEQ';
		SET @SQL = @SQL + '			               ,R.ITEM_ID';
		SET @SQL = @SQL + '			               ,R.DEPT_ID';
		SET @SQL = @SQL + '			               ,R.DEPT_NAME_EN';
		SET @SQL = @SQL + '			               ,R.DEPT_NAME_KO';
		SET @SQL = @SQL + '			               ,R.MEASURE';
		SET @SQL = @SQL + '			               ,R.DEPT_ORD';
		SET @SQL = @SQL + '			               ,R.XLS_ORD';
		SET @SQL = @SQL + '			               ,R.YYYYMM';
		SET @SQL = @SQL + '			               ,R.YYYYMMDD';
		SET @SQL = @SQL + '			               ,R.QTY';
		SET @SQL = @SQL + '			               ,R.MST_SEQ';
		-- -- SCP_ANL_SHIPMENT_PLAN_FG (MKT_FCST, SHIP_REQ, SHIP_PLAN, SHIP_PLAN_AMEND)
		SET @SQL = @SQL + '                    FROM (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '		        	        		, AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        	        		, AA.PLAN_TYPE';
		SET @SQL = @SQL + '		        	        		, AA.SEQ';
		SET @SQL = @SQL + '				                	, AA.ITEM_ID';
		SET @SQL = @SQL + '	        		        		, CC.DEPT_ID';
		SET @SQL = @SQL + '	        		        		, CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        	        		, CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	        		, AA.MEASURE';
		SET @SQL = @SQL + '		        	        		, 10	AS DEPT_ORD';
		SET @SQL = @SQL + '		        	        		, (CASE WHEN AA.MEASURE = ''MKT_FCST''  THEN 100';
        SET @SQL = @SQL + '			                				WHEN AA.MEASURE = ''SHIP_REQ''  THEN 200';
        SET @SQL = @SQL + '			                				WHEN AA.MEASURE = ''SHIP_PLAN'' THEN 300';
        SET @SQL = @SQL + '			                				WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN 400 END) AS XLS_ORD';
		SET @SQL = @SQL + '		        	        		, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		        	        		, AA.YYYYMMDD';
		SET @SQL = @SQL + '		        	        		, (CASE WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN 0 ELSE ROUND(AA.QTY, 0) END) AS QTY';  -- Frozen 구간은 사용자가 입력한 수량만 표시
		SET @SQL = @SQL + '		        	        		, 1 AS MST_SEQ';
		SET @SQL = @SQL + '		        	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '		        	        	AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '		        	        	AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '			                	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '		        	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        	        		       FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        	        		      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        	        			     ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        	        	 ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	          WHERE 1 = 1';
		SET @SQL = @SQL + '		        	        	AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        	        	AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		        	        	AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '		        	        	AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        	        	AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	        		        	AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	        		        	AND AA.SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	        		        	AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'') ';
		SET @SQL = @SQL + '		        	        	AND AA.QTY <> 0 ';
		SET @SQL = @SQL + '		        	        	AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '		        	        	AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '		        	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;

		--------------------
		-- 0값 measure 생성 - Frozen 구간
		--------------------
		SET @SQL = @SQL + '		        	  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  N1.DIVISION_ID';
		SET @SQL = @SQL + '			        ,N1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,N1.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,N1.SEQ';
		SET @SQL = @SQL + '			        ,N1.ITEM_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_EN';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,N2.MEASURE';
		SET @SQL = @SQL + '                 ,10	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,N2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,N3.YYYYMMDD';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (';
		SET @SQL = @SQL + '			         SELECT   BB.DIVISION_ID';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '		        			, ''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '				        	, BB.ITEM_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			, CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	   FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			       FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        			      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        				     ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        		 ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	  WHERE BB.DIVISION_ID = ''' + @p_division_id + '''';
        SET @SQL = @SQL + '		        		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		        		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '			        	AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '			        ) N1,';
		SET @SQL = @SQL + '			        (SELECT ''MKT_FCST'' AS MEASURE, 100 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_REQ'' AS MEASURE, 200 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN'' AS MEASURE, 300 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN_AMEND'' AS MEASURE, 400 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) N2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) N3'

		------ SHIP_PLAN_AMEND 가 없을 경우 SHIP_REQ 를 이용해서 0 값 생성
		--SET @SQL = @SQL + '		        	          UNION ALL';
		--SET @SQL = @SQL + '                          SELECT   AA.DIVISION_ID';
		--SET @SQL = @SQL + '		        	        		, AA.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '		        	        		, AA.PLAN_TYPE';
		--SET @SQL = @SQL + '		        	        		, AA.SEQ';
		--SET @SQL = @SQL + '				                	, AA.ITEM_ID';
		--SET @SQL = @SQL + '	        		        		, CC.DEPT_ID';
		--SET @SQL = @SQL + '	        		        		, CC.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		        	        		, CC.DEPT_NAME_KO';
		--SET @SQL = @SQL + '		        	        		, ''SHIP_PLAN_AMEND'' AS MEASURE';
		--SET @SQL = @SQL + '		        	        		, 10	AS DEPT_ORD';
		--SET @SQL = @SQL + '		        	        		, 400   AS XLS_ORD';
		--SET @SQL = @SQL + '		        	        		, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '		        	        		, AA.YYYYMMDD';
		--SET @SQL = @SQL + '		        	        		, 0 AS QTY'; 
		--SET @SQL = @SQL + '		        	        		, 1 AS MST_SEQ';
		--SET @SQL = @SQL + '		        	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		--SET @SQL = @SQL + '		        	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		--SET @SQL = @SQL + '		        	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		--SET @SQL = @SQL + '		        	        	AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		--SET @SQL = @SQL + '		        	        	AND AA.TO_SITE = BB.SCM_SITE_ID';
		--SET @SQL = @SQL + '			                	AND AA.ITEM_ID = BB.ITEM_ID';
		--SET @SQL = @SQL + '		        	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		        	        		       FROM [SCM_MST_SSO_USER_INFO] AS B';
		--SET @SQL = @SQL + '		        	        		      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		--SET @SQL = @SQL + '		        	        			     ON B.DEPT_ID = C.DEPT_ID) CC';
		--SET @SQL = @SQL + '		        	        	 ON BB.OWNER = CC.USER_ID';
		--SET @SQL = @SQL + '		        	          WHERE 1 = 1';
		--SET @SQL = @SQL + '		        	        	AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		        	        	AND BB.VALID_YN = ''Y''';
		--SET @SQL = @SQL + '		        	        	AND BB.PROJECT_CODE <> ''-''';
		--SET @SQL = @SQL + '		        	        	AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		        	        	AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '	        		        	AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		--SET @SQL = @SQL + '	        		        	AND AA.SEQ       = ''' + @p_seq + '''' ;
		--SET @SQL = @SQL + '	        		        	AND AA.MEASURE = ''SHIP_REQ''';
		--SET @SQL = @SQL + '		        	        	AND AA.QTY <> 0 ';
		--SET @SQL = @SQL + '		        	        	AND AA.BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '		        	        	AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '		        	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;

		-- -- SHIP_PLAN (SSP), FROZEN COUNT
		SET @SQL = @SQL + '		        	          UNION ALL';
		SET @SQL = @SQL + '                          SELECT   G2.DIVISION_ID';
		SET @SQL = @SQL + '	    			                , G2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	    			                , G2.PLAN_TYPE';
		SET @SQL = @SQL + '	    			                , G2.SEQ';
		SET @SQL = @SQL + '		        	                , G2.ITEM_ID';
		SET @SQL = @SQL + '					                , G2.DEPT_ID';
		SET @SQL = @SQL + '					                , G2.DEPT_NAME_EN';
		SET @SQL = @SQL + '	    			                , G2.DEPT_NAME_KO';
		SET @SQL = @SQL + '	    			                , G1.MEASURE';
		SET @SQL = @SQL + '	    			                , G2.DEPT_ORD';
		SET @SQL = @SQL + '	    			                , G1.XLS_ORD';
		SET @SQL = @SQL + '	    			                , G2.YYYYMM';
		SET @SQL = @SQL + '		        	        		, G2.YYYYMMDD';
		SET @SQL = @SQL + '	    			                , (CASE WHEN G1.MEASURE = ''SHIP_PLAN'' THEN G2.QTY ELSE G2.CNT END) AS QTY';
		SET @SQL = @SQL + '	    			                , 1 AS MST_SEQ';
		SET @SQL = @SQL + '                            FROM (SELECT ''SHIP_PLAN''    AS MEASURE, 300 AS XLS_ORD) G1,';
		SET @SQL = @SQL + '     	    	                (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '     	    	        		        , AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '     	    	        		        , AA.PLAN_TYPE';
		SET @SQL = @SQL + '     	    	        		        , AA.SEQ';
		SET @SQL = @SQL + '     		                	        , AA.ITEM_ID';
		SET @SQL = @SQL + '     			        		        , CC.DEPT_ID';
		SET @SQL = @SQL + '     			        		        , CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '     	    	        		        , CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '     	    	        		        , AA.MEASURE';
		SET @SQL = @SQL + '     	    	        		        , 10	AS DEPT_ORD';
		SET @SQL = @SQL + '     	    	        		        , 300   AS XLS_ORD';
		SET @SQL = @SQL + '     	    	        		        , SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '     	    	        		        , AA.YYYYMMDD';
		SET @SQL = @SQL + '     	    	        		        , AA.QTY';
		SET @SQL = @SQL + '     	    	        		        , 1 AS CNT';
		SET @SQL = @SQL + '     	    	                   FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '     	    	                   LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '     	    	                	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '     	    	        	        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '     	    	        	        AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '     	                        	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '     	    	                   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '     	    	        	        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '     	    	        	        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '     	    	        		        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '     	    	        	         ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '     			        		   LEFT OUTER JOIN (SELECT  SCM_SITE_ID';
		SET @SQL = @SQL + '     			        		                    , (CASE WHEN SHIP_FROZEN > 0 THEN SHIP_FROZEN - 1 ELSE SHIP_FROZEN END) AS SHIP_FROZEN';
		SET @SQL = @SQL + '     			        		                FROM [DBO].[SCM_MST_SITE] WITH(NOLOCK)';
		SET @SQL = @SQL + '     			        		               WHERE  1 = 1 ';
		SET @SQL = @SQL + '     			        		                 AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '     			        		                 AND OPERATION_GROUP = ''P''';
		SET @SQL = @SQL + '     			        		                 AND SITE_TYPE = ''PLANT''';
		SET @SQL = @SQL + '      			        		                 AND VALID_YN = ''Y''';
		SET @SQL = @SQL + '                                                  AND OSP_YN = ''Y'') SF';
		SET @SQL = @SQL + '     			        			 ON AA.FROM_SITE = SF.SCM_SITE_ID';
		SET @SQL = @SQL + '     	    	                  WHERE 1 = 1';
		SET @SQL = @SQL + '     	                    		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '     	                    		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '     	                    		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '     	                    		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '     	                    		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '     		                		AND AA.PLAN_TYPE = ''MA''';
		SET @SQL = @SQL + '     		                		AND AA.SEQ       = ''1''';
		SET @SQL = @SQL + '     		                		AND AA.MEASURE IN (''SHIP_PLAN'')';
		SET @SQL = @SQL + '     	                    		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '     	                    		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '     	    	                	AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112)';
		SET @SQL = @SQL + '		                	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;
		SET @SQL = @SQL + '                                 ) G2 ';
                                                    
		-- -- SHIP_PLAN_AMEND 사용자 입력수량          
		SET @SQL = @SQL + '		        	          UNION ALL';
		SET @SQL = @SQL + '		        	         SELECT DIVISION_ID';
		SET @SQL = @SQL + '		        	        	   ,PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        	        	   ,PLAN_TYPE';
		SET @SQL = @SQL + '		        	        	   ,SEQ';
		SET @SQL = @SQL + '		        	        	   ,ITEM_ID';
		SET @SQL = @SQL + '		        	        	   ,DEPT_ID';
		SET @SQL = @SQL + '		        	        	   ,DEPT_NAME_EN';
		SET @SQL = @SQL + '		        	        	   ,DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	        	   ,MEASURE';
		SET @SQL = @SQL + '		        	        	   ,DEPT_ORD';
		SET @SQL = @SQL + '		        	        	   ,XLS_ORD';
		SET @SQL = @SQL + '		        	        	   ,SUBSTRING(YYYYMM, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		        	        	   ,YYYYMM        AS YYYYMMDD';
		SET @SQL = @SQL + '		        	        	   ,ROUND(QTY, 0) AS QTY';
		SET @SQL = @SQL + '		        	        	   ,2 AS MST_SEQ';
		SET @SQL = @SQL + '		        	           FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK)'
		SET @SQL = @SQL + '		        	          WHERE 1 = 1';
		SET @SQL = @SQL + '		        	        	AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		        	        	AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	        		        	AND PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	        		        	AND SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	        		        	AND MEASURE = ''SHIP_PLAN_AMEND''';
		SET @SQL = @SQL + '	        		        	AND LAST_UPDATED_BY = ''' + @p_parameter3 + '''';
		SET @SQL = @SQL + '                         ) R,';

		SET @SQL = @SQL + '			                (SELECT MAX(RR.MST_SEQ) AS MST_SEQ';
		SET @SQL = @SQL + '			                       ,RR.DIVISION_ID';
		SET @SQL = @SQL + '			                       ,RR.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			                       ,RR.PLAN_TYPE';
		SET @SQL = @SQL + '			                       ,RR.SEQ';
		SET @SQL = @SQL + '			        	           ,RR.ITEM_ID';
		SET @SQL = @SQL + '			        	           ,RR.MEASURE';
		SET @SQL = @SQL + '			        	           ,RR.YYYYMM';
		SET @SQL = @SQL + '		                	   FROM (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '		                			        , AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		                			        , AA.PLAN_TYPE';
		SET @SQL = @SQL + '		                			        , AA.SEQ';
		SET @SQL = @SQL + '			        	        	        , AA.ITEM_ID';
		SET @SQL = @SQL + '	                				        , CC.DEPT_ID';
		SET @SQL = @SQL + '	                				        , CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		                			        , CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		                			        , AA.MEASURE';
		SET @SQL = @SQL + '		                			        , 10	AS DEPT_ORD';
		SET @SQL = @SQL + '		                			        , (CASE WHEN AA.MEASURE = ''MKT_FCST''  THEN 100';
        SET @SQL = @SQL + '			                		        		WHEN AA.MEASURE = ''SHIP_REQ''  THEN 200';
        SET @SQL = @SQL + '			                		        		WHEN AA.MEASURE = ''SHIP_PLAN'' THEN 300';
        SET @SQL = @SQL + '                                                 WHEN AA.MEASURE = ''SHIP_PLAN_AMEND'' THEN 400 END) AS XLS_ORD';
		SET @SQL = @SQL + '		                			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		                			        , ROUND(AA.QTY, 0) AS QTY';
		SET @SQL = @SQL + '		                			        , 1 AS MST_SEQ';
		SET @SQL = @SQL + '		                	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '		                	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		                	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '		                		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '		                		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '			                        	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '		                	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		                		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		                		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		                			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		                		         ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		                	          WHERE 1 = 1';
		SET @SQL = @SQL + '		                        		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		                        		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		                        		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '		                        		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '		                        		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	                	        		AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	                	        		AND AA.SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '	                	        		AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'') ';
		SET @SQL = @SQL + '		                        		AND AA.QTY <> 0 ';
		SET @SQL = @SQL + '		                        		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '		                        		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '		                	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;

		-------- SHIP_PLAN_AMEND 가 없을 경우 SHIP_REQ 를 이용해서 0 값 생성
		--SET @SQL = @SQL + '		                          	  UNION ALL';
		--SET @SQL = @SQL + '		                	         SELECT   DISTINCT AA.DIVISION_ID';
		--SET @SQL = @SQL + '		                			        , AA.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '		                			        , AA.PLAN_TYPE';
		--SET @SQL = @SQL + '		                			        , AA.SEQ';
		--SET @SQL = @SQL + '			        	        	        , AA.ITEM_ID';
		--SET @SQL = @SQL + '	                				        , CC.DEPT_ID';
		--SET @SQL = @SQL + '	                				        , CC.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		                			        , CC.DEPT_NAME_KO';
		--SET @SQL = @SQL + '		                			        , ''SHIP_PLAN_AMEND'' AS MEASURE';
		--SET @SQL = @SQL + '		                			        , 10	AS DEPT_ORD';
		--SET @SQL = @SQL + '		                			        , 400   AS XLS_ORD';
		--SET @SQL = @SQL + '		                			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '		                			        , 0 AS QTY';
		--SET @SQL = @SQL + '		                			        , 1 AS MST_SEQ';
		--SET @SQL = @SQL + '		                	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		--SET @SQL = @SQL + '		                	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		--SET @SQL = @SQL + '		                	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		--SET @SQL = @SQL + '		                		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		--SET @SQL = @SQL + '		                		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		--SET @SQL = @SQL + '			                        	AND AA.ITEM_ID = BB.ITEM_ID';
		--SET @SQL = @SQL + '		                	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		--SET @SQL = @SQL + '		                		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		--SET @SQL = @SQL + '		                		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		--SET @SQL = @SQL + '		                			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		--SET @SQL = @SQL + '		                		         ON BB.OWNER = CC.USER_ID';
		--SET @SQL = @SQL + '		                	          WHERE 1 = 1';
		--SET @SQL = @SQL + '		                        		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		                        		AND BB.VALID_YN = ''Y''';
		--SET @SQL = @SQL + '		                        		AND BB.PROJECT_CODE <> ''-''';
		--SET @SQL = @SQL + '		                        		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		                        		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '	                	        		AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		--SET @SQL = @SQL + '	                	        		AND AA.SEQ       = ''' + @p_seq + '''' ;
		--SET @SQL = @SQL + '	                	        		AND AA.MEASURE = ''SHIP_REQ''';
		--SET @SQL = @SQL + '		                        		AND AA.QTY <> 0 ';
		--SET @SQL = @SQL + '		                        		AND AA.BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '		                        		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '		                	        	AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;

		--------------------
		-- 0값 measure 생성 - Frozen 구간
		--------------------
		SET @SQL = @SQL + '		        	  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  N1.DIVISION_ID';
		SET @SQL = @SQL + '			        ,N1.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,N1.PLAN_TYPE';
		SET @SQL = @SQL + '			        ,N1.SEQ';
		SET @SQL = @SQL + '			        ,N1.ITEM_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_ID';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_EN';
		SET @SQL = @SQL + '			        ,N1.DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,N2.MEASURE';
		SET @SQL = @SQL + '                 ,10	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,N2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(N3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (';
		SET @SQL = @SQL + '			         SELECT   BB.DIVISION_ID';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '		        			, ''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '		        			, ''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '				        	, BB.ITEM_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_ID';
		SET @SQL = @SQL + '	        				, CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			, CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '		        	   FROM SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '		        	   LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '		        			       FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '		        			      INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '		        				     ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '		        		 ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '		        	  WHERE BB.DIVISION_ID = ''' + @p_division_id + '''';
        SET @SQL = @SQL + '		        		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '		        		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '			        	AND BB.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '			        ) N1,';
		SET @SQL = @SQL + '			        (SELECT ''MKT_FCST'' AS MEASURE, 100 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_REQ'' AS MEASURE, 200 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN'' AS MEASURE, 300 AS XLS_ORD';
		SET @SQL = @SQL + '			      UNION ALL';
		SET @SQL = @SQL + '			         SELECT ''SHIP_PLAN_AMEND'' AS MEASURE, 400 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) N2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) N3'

        -- SHIP_PLAN (SSP), FROZEN COUNT 사용자입력확인
		SET @SQL = @SQL + '		                          	  UNION ALL';
		SET @SQL = @SQL + '                                  SELECT   G2.DIVISION_ID';
		SET @SQL = @SQL + '	            	          		        , G2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            	          		        , G2.PLAN_TYPE';
		SET @SQL = @SQL + '	            	          		        , G2.SEQ';
		SET @SQL = @SQL + '		                          	        , G2.ITEM_ID';
		SET @SQL = @SQL + '		        	          		        , G2.DEPT_ID';
		SET @SQL = @SQL + '		        	          		        , G2.DEPT_NAME_EN';
		SET @SQL = @SQL + '	            	          		        , G2.DEPT_NAME_KO';
		SET @SQL = @SQL + '	            	          		        , G1.MEASURE';
		SET @SQL = @SQL + '	            	          		        , G2.DEPT_ORD';
		SET @SQL = @SQL + '	            	          		        , G1.XLS_ORD';
		SET @SQL = @SQL + '	            	          		        , G2.YYYYMM';
		SET @SQL = @SQL + '	            	          		        , (CASE WHEN G1.MEASURE = ''SHIP_PLAN'' THEN G2.QTY ELSE G2.CNT END) AS QTY';
		SET @SQL = @SQL + '	            	          		        , 1 AS MST_SEQ';
		SET @SQL = @SQL + '                                      FROM (SELECT ''SHIP_PLAN''    AS MEASURE, 300 AS XLS_ORD) G1,';
		--SET @SQL = @SQL + '                                             UNION ALL';
		--SET @SQL = @SQL + '                                            SELECT ''FROZEN_COUNT'' AS MEASURE, 310 AS XLS_ORD) G1,';
		SET @SQL = @SQL + '             	              	        (SELECT   AA.DIVISION_ID';
		SET @SQL = @SQL + '             	              			        , AA.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '             	              			        , AA.PLAN_TYPE';
		SET @SQL = @SQL + '             	              			        , AA.SEQ';
		SET @SQL = @SQL + '             	          	        	        , AA.ITEM_ID';
		SET @SQL = @SQL + '             	          				        , CC.DEPT_ID';
		SET @SQL = @SQL + '             	          				        , CC.DEPT_NAME_EN';
		SET @SQL = @SQL + '             	              			        , CC.DEPT_NAME_KO';
		SET @SQL = @SQL + '             	              			        , AA.MEASURE';
		SET @SQL = @SQL + '             	              			        , 10	AS DEPT_ORD';
		SET @SQL = @SQL + '             	              			        , 300   AS XLS_ORD';
		SET @SQL = @SQL + '             	              			        , SUBSTRING(YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '             	              			        , AA.QTY';
		SET @SQL = @SQL + '             	              			        , 1 AS CNT';
		SET @SQL = @SQL + '             	              	           FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		SET @SQL = @SQL + '             	              	           LEFT JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK)';
		SET @SQL = @SQL + '             	              	        	 ON AA.DIVISION_ID = BB.DIVISION_ID';
		SET @SQL = @SQL + '             	              		        AND AA.PROJECT_CODE = BB.PROJECT_CODE';
		SET @SQL = @SQL + '             	              		        AND AA.TO_SITE = BB.SCM_SITE_ID';
		SET @SQL = @SQL + '             	                          	AND AA.ITEM_ID = BB.ITEM_ID';
		SET @SQL = @SQL + '             	              	           LEFT JOIN (SELECT distinct B.USER_ID, C.DEPT_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN';
		SET @SQL = @SQL + '             	              		        	        FROM [SCM_MST_SSO_USER_INFO] AS B';
		SET @SQL = @SQL + '             	              		        	       INNER JOIN SCM_MST_SSO_DEPT_INFO AS C';
		SET @SQL = @SQL + '             	              			        	      ON B.DEPT_ID = C.DEPT_ID) CC';
		SET @SQL = @SQL + '             	              		         ON BB.OWNER = CC.USER_ID';
		SET @SQL = @SQL + '             	          				   LEFT OUTER JOIN (SELECT  SCM_SITE_ID';
		SET @SQL = @SQL + '             	          				                    , (CASE WHEN SHIP_FROZEN > 0 THEN SHIP_FROZEN - 1 ELSE SHIP_FROZEN END) AS SHIP_FROZEN';
		SET @SQL = @SQL + '             	          				                FROM [DBO].[SCM_MST_SITE] WITH(NOLOCK)';
		SET @SQL = @SQL + '             	          				               WHERE  1 = 1 ';
		SET @SQL = @SQL + '             	          				                 AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             	          				                 AND OPERATION_GROUP = ''P''';
		SET @SQL = @SQL + '             	          				                 AND SITE_TYPE = ''PLANT''';
		SET @SQL = @SQL + '              	          				                 AND VALID_YN = ''Y''';
		SET @SQL = @SQL + '                                                            AND OSP_YN = ''Y'') SF';
		SET @SQL = @SQL + '             	          					 ON AA.FROM_SITE = SF.SCM_SITE_ID';
		SET @SQL = @SQL + '             	              	          WHERE 1 = 1';
		SET @SQL = @SQL + '             	                      		AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             	                      		AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '             	                      		AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '             	                      		AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '             	                      		AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '             	          	        		AND AA.PLAN_TYPE = ''MA''';
		SET @SQL = @SQL + '             	          	        		AND AA.SEQ       = ''1''';
		SET @SQL = @SQL + '             	          	        		AND AA.MEASURE IN (''SHIP_PLAN'')';
		SET @SQL = @SQL + '             	                      		AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '             	                      		AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '             	              	        	AND AA.YYYYMMDD between AA.PLAN_START_YYYYMMDD AND CONVERT(VARCHAR,DATEADD(D,ISNULL(SF.SHIP_FROZEN, 0),CONVERT(DATETIME,(AA.PLAN_START_YYYYMMDD),112)),112)';
		SET @SQL = @SQL + '		                	        	        AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;
		SET @SQL = @SQL + '                                           ) G2 ';
		SET @SQL = @SQL + '           	        	          UNION ALL';
		SET @SQL = @SQL + '           	                	 SELECT DIVISION_ID';
		SET @SQL = @SQL + '           	                		   ,PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '           	        	        	   ,PLAN_TYPE';
		SET @SQL = @SQL + '           	        	        	   ,SEQ';
		SET @SQL = @SQL + '           	        	        	   ,ITEM_ID';
		SET @SQL = @SQL + '           	        	        	   ,DEPT_ID';
		SET @SQL = @SQL + '           	        	        	   ,DEPT_NAME_EN';
		SET @SQL = @SQL + '           	        	        	   ,DEPT_NAME_KO';
		SET @SQL = @SQL + '           	        	        	   ,MEASURE';
		SET @SQL = @SQL + '           	        	        	   ,DEPT_ORD';
		SET @SQL = @SQL + '           	        	        	   ,XLS_ORD';
		SET @SQL = @SQL + '           	        	        	   ,YYYYMM';
		SET @SQL = @SQL + '           	        	        	   ,ROUND(QTY, 0) AS QTY ';
		SET @SQL = @SQL + '           	        	        	   ,2 AS MST_SEQ';
		SET @SQL = @SQL + '           	        	           FROM DBO.SCP_XLS_SHIPMENT_PLAN WITH (NOLOCK) '
		SET @SQL = @SQL + '           	        	          WHERE 1 = 1';
		SET @SQL = @SQL + '           	        	        	AND DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '           	        	        	AND PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '                   		        	AND PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '                   		        	AND SEQ       = ''' + @p_seq + '''' ;
		SET @SQL = @SQL + '                   		        	AND MEASURE = ''SHIP_PLAN_AMEND''';
		SET @SQL = @SQL + '                   			        AND LAST_UPDATED_BY = ''' + @p_parameter3 + '''';
		SET @SQL = @SQL + '           		                ) RR';
		SET @SQL = @SQL + '	            		          GROUP BY RR.DIVISION_ID, RR.PLAN_START_YYYYMMDD, RR.PLAN_TYPE, RR.SEQ, RR.ITEM_ID, RR.MEASURE, RR.YYYYMM';
		SET @SQL = @SQL + '	            		      ) Q'; 
		
		SET @SQL = @SQL + '	            		  WHERE R.MST_SEQ             = Q.MST_SEQ';
		SET @SQL = @SQL + '	            		    AND R.DIVISION_ID         = Q.DIVISION_ID';
		SET @SQL = @SQL + '	            		    AND R.PLAN_START_YYYYMMDD = Q.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            		    AND R.PLAN_TYPE = Q.PLAN_TYPE';
		SET @SQL = @SQL + '	            		    AND R.SEQ       = Q.SEQ';
		SET @SQL = @SQL + '	            		    AND R.ITEM_ID   = Q.ITEM_ID';
		SET @SQL = @SQL + '	            		    AND R.MEASURE   = Q.MEASURE';
		SET @SQL = @SQL + '	            		    AND R.YYYYMM    = Q.YYYYMM';
		SET @SQL = @SQL + '	            		  UNION ALL';
		SET @SQL = @SQL + '	            		 SELECT  P.DIVISION_ID';
		SET @SQL = @SQL + '	            				,P.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '	            				,P.PLAN_TYPE';
		SET @SQL = @SQL + '	            				,P.SEQ';
		SET @SQL = @SQL + '	            				,P.ITEM_ID';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '	            				, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '	            				,P.MEASURE'
		SET @SQL = @SQL + '	            				,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '	            				,900  AS XLS_ORD';
		SET @SQL = @SQL + '	            				,SUBSTRING(CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112), 1, 6) AS YYYYMM';     --SUBSTRING(P.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '	            				,CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) AS YYYYMMDD';   --P.YYYYMMDD';
		SET @SQL = @SQL + '	            				,ROUND(P.QTY * ISNULL(F.SSP_MODIFY_YIELD, 1), 0) AS QTY';
		SET @SQL = @SQL + '		        	            , 1 AS MST_SEQ';
		SET @SQL = @SQL + '	            			FROM [DBO].[SCP_ANL_PRODUCTION_PLAN] P WITH (NOLOCK)';
		SET @SQL = @SQL + '	            			LEFT JOIN [dbo].[SCP_MST_FORMATION] F WITH (NOLOCK)';
		SET @SQL = @SQL + '	            			ON P.SCM_SITE_ID = F.PLANT_SITE_ID';
		SET @SQL = @SQL + '	            			AND P.ITEM_ID = F.ITEM_ID';
		SET @SQL = @SQL + '	            			WHERE 1 = 1';
		SET @SQL = @SQL + '	            			AND P.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '	            			AND P.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '	            			AND P.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '	            			AND P.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '	            			AND P.OPERATION_GROUP = ''P''';
		SET @SQL = @SQL + '	            			AND P.MEASURE = ''PROD_PLAN_ENGINE''';
		SET @SQL = @SQL + '	            			AND P.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '	            			AND CONVERT(VARCHAR,DATEADD(D,(F.LT_FORMATION + F.ATTRIBUTE1),CONVERT(DATETIME,(P.YYYYMMDD),112)),112) between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''';

		---- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		--SET @SQL = @SQL + '		            	  UNION ALL';
		--SET @SQL = @SQL + '		            	 SELECT   AA.DIVISION_ID';
		--SET @SQL = @SQL + '		                    	, AA.PLAN_START_YYYYMMDD';
		--SET @SQL = @SQL + '		                    	, AA.PLAN_TYPE';
		--SET @SQL = @SQL + '		                    	, AA.SEQ';
		--SET @SQL = @SQL + '		            		    , AA.ITEM_ID';
		--SET @SQL = @SQL + '		            			, ''-'' AS DEPT_ID';
		--SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_EN';
		--SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_KO';
		--SET @SQL = @SQL + '		                    	, ''PROD_PLAN_ENGINE'' AS MEASURE';
		--SET @SQL = @SQL + '		            			, 99	AS DEPT_ORD';
		--SET @SQL = @SQL + '		            			, 900   AS XLS_ORD';
		--SET @SQL = @SQL + '		                    	, SUBSTRING(AA.YYYYMMDD, 1, 6) AS YYYYMM';
		--SET @SQL = @SQL + '	            				, AA.YYYYMMDD';
		--SET @SQL = @SQL + '		                    	, 0     AS QTY';
		--SET @SQL = @SQL + '		        	            , 1     AS MST_SEQ';
		--SET @SQL = @SQL + '		                   FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK)';
		--SET @SQL = @SQL + '		                  WHERE 1 = 1';
		--SET @SQL = @SQL + '		                    AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		--SET @SQL = @SQL + '		                    AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		--SET @SQL = @SQL + '	                    	AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		--SET @SQL = @SQL + '	                    	AND AA.SEQ       = ''' + @p_seq + '''' ;
		--SET @SQL = @SQL + '	                    	AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'') ';
		--SET @SQL = @SQL + '		                    AND AA.QTY <> 0 ';
		--SET @SQL = @SQL + '		                    AND AA.BIZ_TYPE = ''P''';
		--SET @SQL = @SQL + '		                    AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		--SET @SQL = @SQL + '		                    AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_frozen_area_last_yyyymmdd + '''' ;

		----------------------
		-- PROD_PLAN_ENGINE 정보가 없을 경우 0 값 MEASURE 생성
		----------------------
		SET @SQL = @SQL + '			  UNION ALL';
		SET @SQL = @SQL + '			 SELECT  ''' + @p_division_id + ''' AS DIVISION_ID';
		SET @SQL = @SQL + '			        ,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '			        ,''' + @p_plan_type + ''' AS PLAN_TYPE';
		SET @SQL = @SQL + '			        ,''' + @p_seq + ''' AS SEQ';
		SET @SQL = @SQL + '			        ,E1.value AS ITEM_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            , ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '			        ,E2.MEASURE';
		SET @SQL = @SQL + '                 ,99	AS DEPT_ORD';
		SET @SQL = @SQL + '			        ,E2.XLS_ORD';
		SET @SQL = @SQL + '                 ,SUBSTRING(E3.YYYYMMDD, 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '                 ,E3.YYYYMMDD';
		SET @SQL = @SQL + '                 ,0 AS QTY';
		SET @SQL = @SQL + '                 ,1 AS MST_SEQ';
		SET @SQL = @SQL + '			   FROM (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','','')) E1,';
		SET @SQL = @SQL + '			        (SELECT ''PROD_PLAN_ENGINE'' AS MEASURE, 900 AS XLS_ORD';
		SET @SQL = @SQL + '			        ) E2,';
		SET @SQL = @SQL + '			        (SELECT  C.BASIS_YYYYMMDD AS YYYYMMDD';
		SET @SQL = @SQL + '			           FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)';
		SET @SQL = @SQL + '			          WHERE 0 = 0';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD >= ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND C.BASIS_YYYYMMDD <=  ''' + @v_frozen_area_last_yyyymmdd + '''';
		SET @SQL = @SQL + '			            AND DATEPART(WEEKDAY,CONVERT(DATETIME,C.BASIS_YYYYMMDD,112)) = 1';
		SET @SQL = @SQL + '			        ) E3';
                                            
		SET @SQL = @SQL + '		            	  UNION ALL';
		SET @SQL = @SQL + '		            	 SELECT ''' + @p_division_id + ''' AS DIVISION_ID ';
		SET @SQL = @SQL + '		            			,''' + @p_plan_start_yyyymmdd + ''' AS PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '		            			,''' + @p_plan_type + ''' AS PLAN_TYPE ';
		SET @SQL = @SQL + '		            			,''' + @p_seq + ''' AS SEQ ';
		SET @SQL = @SQL + '		            			,ITEM_ID';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_ID';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_EN';
		SET @SQL = @SQL + '		            			, ''-'' AS DEPT_NAME_KO';
		SET @SQL = @SQL + '		            			,''INVENTORY'' AS MEASURE';
		SET @SQL = @SQL + '		            			,99	  AS DEPT_ORD';
		SET @SQL = @SQL + '		            			,800  AS XLS_ORD';
		SET @SQL = @SQL + '		                    	, SUBSTRING(''' + @p_plan_start_yyyymmdd + ''', 1, 6) AS YYYYMM';
		SET @SQL = @SQL + '		            			,''' + @p_plan_start_yyyymmdd + ''' AS YYYYMMDD ';
		SET @SQL = @SQL + '		            			,0    AS QTY';
		SET @SQL = @SQL + '		        	            ,1 AS MST_SEQ';
		SET @SQL = @SQL + '		            	   FROM SCP_MST_FINAL_ITEM WITH (NOLOCK)';
		SET @SQL = @SQL + '		            	  WHERE ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '                 ) W2';
		SET @SQL = @SQL + '           WHERE W2.YYYYMMDD >= W1.S_YYYYMMDD AND W2.YYYYMMDD <= W1.E_YYYYMMDD';
        SET @SQL = @SQL + '			) AS M';
		SET @SQL = @SQL + '   PIVOT (';
		SET @SQL = @SQL + '          SUM(QTY) FOR W_DAY IN (' + @v_wcols + ')';
		SET @SQL = @SQL + '         ) AS P_RST';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ') PV2';
		SET @SQL = @SQL + ' WHERE PV1.DIVISION_ID         = PV2.DIVISION_ID';
		SET @SQL = @SQL + '   AND PV1.PLAN_START_YYYYMMDD = PV2.PLAN_START_YYYYMMDD';
		SET @SQL = @SQL + '   AND PV1.PLAN_TYPE = PV2.PLAN_TYPE';
		SET @SQL = @SQL + '   AND PV1.SEQ       = PV2.SEQ';
		SET @SQL = @SQL + '   AND PV1.ITEM_ID   = PV2.ITEM_ID';
		SET @SQL = @SQL + '   AND PV1.DEPT_ID   = PV2.DEPT_ID';
		SET @SQL = @SQL + '   AND PV1.MEASURE   = PV2.MEASURE';
		SET @SQL = @SQL + '   AND PV1.XLS_ORD   = PV2.XLS_ORD';
		SET @SQL = @SQL + ' ORDER BY PV1.ITEM_ID, PV1.DEPT_ORD, PV1.DEPT_NAME_KO, PV1.XLS_ORD';

		SELECT @SQL;
		RETURN;
		EXEC(@SQL);
		END

	 IF @p_parameter2 = 'day_result'		-- RAW 차감후 결과 Sheet
		BEGIN

		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,364,CONVERT(DATETIME,(@p_plan_start_yyyymmdd),112)),112) ;
		SELECT @v_plan_end_yyyymmdd = CONVERT(VARCHAR,DATEADD(D,-1,CONVERT(DATETIME,(CONVERT(VARCHAR,DATEADD(M,1,CONVERT(DATETIME,(LEFT(@v_plan_end_yyyymmdd, 6) + '01'),112)),112)),112)),112) ;

		SELECT @v_cols = @v_cols + '[' + YYYYMMDD + '],', @v_cols2 = @v_cols2 + 'ISNULL([' + YYYYMMDD + '],0) AS [' + YYYYMMDD + '],'
		  FROM (
			   SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
				FROM DBO.SCM_SYS_CALENDAR_M C WITH (NOLOCK)
				WHERE 0 = 0
						AND C.BASIS_YYYYMMDD >= @p_plan_start_yyyymmdd
					AND C.BASIS_YYYYMMDD <=  @v_plan_end_yyyymmdd
			   ) AS days
		 ORDER BY YYYYMMDD
		 ;		

		SET @v_cols = LEFT(@v_cols, LEN(@v_cols) - 1);
		SET @v_cols2 = LEFT(@v_cols2, LEN(@v_cols2) - 1);

		SET @SQL = 'SELECT P.DIVISION_ID ';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_EN ';
		SET @SQL = @SQL + '        ,P.DEPT_NAME_KO ';
		SET @SQL = @SQL + '        ,P.PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '        ,P.PLAN_TYPE ';
		SET @SQL = @SQL + '        ,P.SEQ ';
		SET @SQL = @SQL + '        ,P.PROJECT_CODE ';
		SET @SQL = @SQL + '        ,P.ITEM_ID ';
		SET @SQL = @SQL + '        ,P.NICK_NAME ';
		SET @SQL = @SQL + '        ,P.TO_SITE ';
		SET @SQL = @SQL + '        ,P.MEASURE ';
		SET @SQL = @SQL + '        ,(CASE WHEN P.MEASURE = ''MKT_FCST'' THEN ''Forcast''  ';
		SET @SQL = @SQL + '			      WHEN P.MEASURE = ''SHIP_REQ'' THEN ''Ship Req.'' ';
		SET @SQL = @SQL + '			      ELSE ''Ship Plan'' END) AS MEASURE_DESC ';
		SET @SQL = @SQL + '        ,' + @v_cols2;
		SET @SQL = @SQL + '  FROM ( ';
		SET @SQL = @SQL + 'SELECT P_RST.*, F.NICK_NAME ';
		SET @SQL = @SQL + '  FROM ( ';
		SET @SQL = @SQL + '     SELECT   AA.DIVISION_ID ';
		SET @SQL = @SQL + '	        , CC.DEPT_NAME_EN ';
		SET @SQL = @SQL + '	        , CC.DEPT_NAME_KO ';
		SET @SQL = @SQL + '			, AA.PLAN_START_YYYYMMDD ';
		SET @SQL = @SQL + '			, AA.PLAN_TYPE ';
		SET @SQL = @SQL + '			, AA.SEQ ';
		SET @SQL = @SQL + '			, AA.PROJECT_CODE ';
		SET @SQL = @SQL + '			, AA.ITEM_ID ';
		SET @SQL = @SQL + '			, AA.TO_SITE ';
		SET @SQL = @SQL + '			, AA.MEASURE  ';
		SET @SQL = @SQL + '			, (CASE WHEN AA.MEASURE = ''MKT_FCST'' THEN 100 ';
		SET @SQL = @SQL + '			        WHEN AA.MEASURE = ''SHIP_REQ'' THEN 200 ELSE 300 END) AS XLS_ORD ';
		SET @SQL = @SQL + '			, AA.YYYYMMDD ';
		SET @SQL = @SQL + '			, AA.QTY ';
		SET @SQL = @SQL + '       FROM [DBO].[SCP_ANL_SHIPMENT_PLAN_FG] AA WITH(NOLOCK) ';
		SET @SQL = @SQL + '       LEFT  ';
		SET @SQL = @SQL + '       JOIN SCM_MST_SITE_ITEM BB WITH(NOLOCK) ';
		SET @SQL = @SQL + '         ON AA.DIVISION_ID = BB.DIVISION_ID ';
		SET @SQL = @SQL + '        AND AA.PROJECT_CODE = BB.PROJECT_CODE ';
		SET @SQL = @SQL + '        AND AA.TO_SITE = BB.SCM_SITE_ID ';
		SET @SQL = @SQL + '        AND AA.ITEM_ID = BB.ITEM_ID ';
		SET @SQL = @SQL + '       LEFT ';
		SET @SQL = @SQL + '       JOIN (SELECT distinct B.USER_ID, C.DEPT_NAME_KO, C.DEPT_NAME_EN ';
		SET @SQL = @SQL + '               FROM [SCM_MST_SSO_USER_INFO] AS B ';
		SET @SQL = @SQL + '              INNER  ';
		SET @SQL = @SQL + '                                    JOIN SCM_MST_SSO_DEPT_INFO AS C ';
		SET @SQL = @SQL + '                 ON B.DEPT_ID = C.DEPT_ID) CC ';
		SET @SQL = @SQL + '         ON BB.OWNER = CC.USER_ID ';
		SET @SQL = @SQL + '      WHERE 1 = 1   ';
		SET @SQL = @SQL + '        AND BB.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '        AND BB.VALID_YN = ''Y''';
		SET @SQL = @SQL + '        AND BB.PROJECT_CODE <> ''-''';
		SET @SQL = @SQL + '        AND AA.DIVISION_ID = ''' + @p_division_id + '''';
		SET @SQL = @SQL + '        AND AA.PLAN_START_YYYYMMDD = ''' + @p_plan_start_yyyymmdd + '''';
		SET @SQL = @SQL + '        AND AA.PLAN_TYPE = ''' + @p_plan_type + '''';
		SET @SQL = @SQL + '        AND AA.SEQ       = ''' + @p_seq + '''';
		SET @SQL = @SQL + '        AND AA.MEASURE IN (''MKT_FCST'',''SHIP_REQ'',''SHIP_PLAN_AMEND'')';
		SET @SQL = @SQL + '        AND AA.QTY <> 0 ';
		SET @SQL = @SQL + '        AND AA.BIZ_TYPE = ''P''';
		SET @SQL = @SQL + '        AND AA.ITEM_ID IN (SELECT DISTINCT value FROM dbo.FN_SplitString(''' + @p_parameter1 + ''','',''))';
		SET @SQL = @SQL + '        AND AA.YYYYMMDD between ''' + @p_plan_start_yyyymmdd + ''' and ''' + @v_plan_end_yyyymmdd + '''' 
		SET @SQL = @SQL + '      ) AS M ';
		SET @SQL = @SQL + ' PIVOT ( ';
		SET @SQL = @SQL + '		SUM(QTY) FOR YYYYMMDD IN (' + @v_cols + ')';
		SET @SQL = @SQL + '	   ) AS P_RST, ';
		SET @SQL = @SQL + '    SCP_MST_FINAL_ITEM F WITH (NOLOCK) ';
		SET @SQL = @SQL + '  WHERE 0 = 0 ';
		SET @SQL = @SQL + '    AND P_RST.ITEM_ID = F.ITEM_ID ';
		SET @SQL = @SQL + '	   ) P ';
		SET @SQL = @SQL + ' ORDER BY P.DEPT_NAME_KO, P.ITEM_ID, P.PROJECT_CODE, P.TO_SITE, P.XLS_ORD '

		EXEC(@SQL);
		END

     END
END
