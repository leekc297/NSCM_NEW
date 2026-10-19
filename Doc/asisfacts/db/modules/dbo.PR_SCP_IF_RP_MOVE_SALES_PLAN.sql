


/*
 * Program ID   : PR_SCP_IF_RP_MOVE_SALES_PLAN 

 ***************** => 2025.01.20 주차부터 BPS 사용 안 함으로 수행 중지함 

 * Description  : RP 매출계획 전송
 *                매주 특정 시점에 일괄 생성
 *                동일 work_yyyymmdd 존재 시 work_yyyymmdd = MAX(work_yyyymmdd) + 1 로 생성 : 중복 방지
 *                각 Plan 사업부별 현재 최종 Plan Type/Seq 정보로 생성
 *                   1순위) FN / Confirm_flag = 'Y'
 *                   2순위) FN / MAX(seq)
 *                   3순위) SE / MA / PR 순 MAX(seq)
 *                
 *                SCP 출하계획 유형 : RP에서 유형별로 대상여부 확정하여 사용함
 *                 1) 전극 Plant Site -> Sales Site : LGC Out
 *                 2) 전극 Plant Site -> 동일 지역 Cell Plant Site :  From 과 To 의 Division 이 같은 경우 : LGC 내부
 *                 3) 전극 Plant Site -> 동일 지역 Cell Plant Site :  From 과 To 의 Division 이 다른 경우 : LGC 내부
 *                 4) 전극 Plant Site -> 다른 지역 Cell Plant Site :  From 과 To 의 Division 이 같은 경우 : LGC 내부
 *                 5) 전극 Plant Site -> 다른 지역 Cell Plant Site :  From 과 To 의 Division 이 다른 경우 : LGC 내부 
 *                14) 외주 전극 Plant Site -> Cell Plant Site                                             : LGC 아님
 *                
 *                 6) Cell Plant Site -> Sales Site                            : LGC Out
 *                 7) Cell Plant Site -> 외주 Cell Plant Site : 소형 TCO 경우  : LGC Out
 *                 8) 외주 Cell Plant Site  -> Cell Plant Site : 소형 TCO 경우 : LGC 아님
 *                 9) Cell Plant Site -> 외주 Pack Plant Site                  : LGC Out
 *                10) Cell Plant Site -> 동일 지역 Pack Plant Site             : LGC 내부
 *                11) Cell Plant Site -> 다른 지역 Pack Plant Site             : LGC 내부 
 *                
 *                12) Pack Plant Site -> Sales Site      : LGC Out
 *                13) 외주 Pack Plant Site -> Sales Site : LGC 아님
 *
 * OutTable     :
 * Execute      : EXEC PR_SCP_IF_RP_MOVE_SALES_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019.07.24    KSG           Initial Release 전지 GSCM 고도화 프로젝트
 * 2020.05.08    JIC           PI 자체 수정하여 반영 요청함
 *                               - 법인간 거래 매출 : shp_pln_type_cd 지정
 *                               - 연결 거래 매출 : 신규 추가
 * 2020.07.20    JIC           판매법인향(CEG,CAU 등) 개별 거래 추가함
 * 2020.08.26    JIC           전극 → 조립 Plant 로 변환, 외주 패커는 자사 Plant 로 변환
 * 2020.09.28    JIC           매출지 누락시 보완하는 로직 제거(매출지는 DM Sales Site Project Model 기준정보로만 관리함)
 *                             법인간 거래 컬럼을 RECEIVE_YYYYMMDD_SSP 로 변경함(법인간 거래 실 INCOTERMS 반영 컬럼)
 * 2020.12.21    HJS           개별 출하계획 로직 추가 (3자간 거래 등)
 * 2020.12.23    HJS           개별 출하계획에 운송중 재고 포함.
 * 2021.01.06    HJS           속도개선을 위한 버전 처리
 * 2021.01.18    HJS           개별매출 - 운송중 재고 추가
 * 2021.01.19    HJS           개별매출 - Ship-To 정보 수정
 * 2021.03.24    HJS           개별매출 - 오창발 추가.
 * 2021.07.07    KSG           PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2021.04.18    sclee.lee     PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023.03.30	 HRK		   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2024.01.25    vadabi3       NERP - 특정 Company 별도 처리 개선
 * 2024.05.27	 vadabi5	   NERP) QA, 개발 DB 적용
 * 2024.07.25	 vadabi5	   NERP) Mapping code 변환
								- ovsentt_cd, 				COMPANY_ID
								- billto_cust_cd			COMPANY_ID, END_CUSTOMER_ID
								- shipto_cust_cd			COMPANY_ID, END_CUSTOMER_ID
								- cust_cd					COMPANY_ID, END_CUSTOMER_ID
								- attribute19_value			COMPANY_ID, END_CUSTOMER_ID
								- plnt_cd 					PLANT_ID
								- to_plnt_cd				PLANT_ID
								- gscm_to_site_name			SITE_DESCRIPTION
 * 2024.07.26	 vadabi5	   NERP) billto_cust_cd, shipto_cust_cd	, cust_cd	, attribute19_value					
                                - TODO : scm_mst_customer 에서 참조 1ST 아닌 값 사용 중 이슈 해결 필요
								-        scm_mst_customer 에서도 해당 데이터 삭제 시 이슈여부 체크 필요				
 ----------------------------------------------------------------------------------------------------

 exec NERP_PR_SCP_IF_RP_MOVE_SALES_PLAN @p_start_yyyymmdd = '20240101'
 exec PR_SCP_IF_RP_MOVE_SALES_PLAN @p_start_yyyymmdd = '20240101'
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_IF_RP_MOVE_SALES_PLAN]
-- 특정 시점에 일괄 생성
    ( 
	  @p_start_yyyymmdd       NVARCHAR(8)
   ) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user    NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'scp_batch'
    DECLARE @v_program_name  NVARCHAR(150) = N'PR_SCP_IF_RP_MOVE_SALES_PLAN';
    DECLARE @v_log_type      NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count     INTEGER = 0;
    DECLARE @v_log_message   NVARCHAR(1000);
    DECLARE @v_description   NVARCHAR(500);      
    DECLARE @v_table_id      NVARCHAR(150) = N'XIF_SCP_MOVE_SALES_PLAN_RP_SN'; 
    DECLARE @d_event_date    DATETIME;
   
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8);
    DECLARE @v_plan_start_week_day  NVARCHAR(8);
    DECLARE @v_plan_delete_yyyymmdd NVARCHAR(8);
    DECLARE @d_gcs_trans_date       DATETIME;

	-- 계획 시작, 종료 구간
    DECLARE @v_period_start_date NVARCHAR(8);
    DECLARE @v_period_end_date   NVARCHAR(8);

	-- NERP 매핑코드
    DECLARE @v_COMPANY_SALES NVARCHAR(8);
    DECLARE @v_ESOC NVARCHAR(8);
	SELECT @v_COMPANY_SALES = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_IF_RP_MOVE_SALES_PLAN', 'COMPANY_SALES')  
	SELECT @v_ESOC = dbo.FN_GET_LOOKUP_VALUE('PR_SCP_IF_RP_MOVE_SALES_PLAN', 'ESOC')  

  -- 시작 LOG
    SET @v_log_type    = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name;
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH    @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    
    BEGIN TRY
      BEGIN
    
     --   BEGIN TRANSACTION; 
	    SET @v_plan_start_yyyymmdd  = ISNULL(@p_start_yyyymmdd, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) ;
	    SET @v_plan_start_week_day  = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) ;   -- 매출 실적 I/F 일자
	    SET @v_plan_delete_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7*8, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) ; -- 8주 지난 정보 삭제
		SET @d_gcs_trans_date       = GETDATE();

		-- Default
		SET @v_period_start_date    = CONVERT(NVARCHAR(6), GETDATE()+10, 112) + '01' ; --계획 시작 구간.
		SET @v_period_end_date      = CONVERT(NVARCHAR(8), DATEADD(DD,7*30, @v_period_start_date),112) ; --계획 시작 구간.

		-- 8개월 시점.
		--SET @v_period_start_date    = CONVERT(NVARCHAR(6), GETDATE()+10, 112) + '01' ; --계획 시작 구간.
		--SET @v_period_end_date      = CONVERT(NVARCHAR(8), DATEADD(DD,7*41, @v_period_start_date),112) ; --계획 시작 구간.

	    ----------------------------------------------------------
        -- Work_yyyymmdd 설정
		-- 동일 work_yyyymmdd 존재 시 MAX(work_yyyymmdd) + 1 로 생성
        ----------------------------------------------------------
        DECLARE @v_work_yyyymmdd    NVARCHAR(8);
        DECLARE @v_work_yyyymmdd_e  NVARCHAR(8);
        DECLARE @v_work_yyyymmdd_t  NVARCHAR(8);

        SET @v_work_yyyymmdd   = CONVERT(CHAR(8), GETDATE(), 112);
        SET @v_work_yyyymmdd_e = NULL;
        SET @v_work_yyyymmdd_t = NULL;
				
        SELECT TOP 1 @v_work_yyyymmdd_e = work_yyyymmdd
          FROM XIF_SCP_MOVE_SALES_PLAN_RP_SN WITH(NOLOCK)
         WHERE work_yyyymmdd = @v_work_yyyymmdd ;

		-- 동일 work_yyyymmdd 존재 시 work_yyyymmdd = MAX(work_yyyymmdd) + 1 로 생성 : 중복 방지
        IF @v_work_yyyymmdd = @v_work_yyyymmdd_e
        BEGIN
          SELECT TOP 1 @v_work_yyyymmdd_t = CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT(DATE, MAX(work_yyyymmdd))), 112)  
            FROM XIF_SCP_MOVE_SALES_PLAN_RP_SN WITH(NOLOCK)
           WHERE work_yyyymmdd >= @v_work_yyyymmdd ;

		  SET @v_work_yyyymmdd = @v_work_yyyymmdd_t;

        END -- IF @v_work_yyyymmdd = @v_work_yyyymmdd_e

        ----------------------------------------------------------- 
        -- 1. interface data creation
        -----------------------------------------------------------        
		
        /** 법인간 거래 매출 START **/

		/* 출하 뷰 데이터가 많아서 TEMP 테이블 활용 */
		IF(OBJECT_ID('tempdb.dbo.#tmp_version') IS NOT NULL)
			DROP TABLE #tmp_version

			
		IF(OBJECT_ID('tempdb.dbo.#tmp_ship_plan') IS NOT NULL)
			DROP TABLE #tmp_ship_plan

		/* Version 정보 추출 */
		SELECT division_id, plan_start_yyyymmdd, plan_type, plan_seq
				INTO #tmp_version
			FROM  (SELECT division_id, plan_start_yyyymmdd, plan_type, plan_seq
						, ROW_NUMBER() OVER (PARTITION BY division_id ORDER BY PLAN_START_YYYYMMDD DESC, PLAN_SEQ DESC ) seq
					FROM   scp_plan_version_v
					WHERE  plan_type = 'FN'
					-- 임시 테스트
					--AND    PLAN_START_YYYYMMDD = '20210301'
				) a
		WHERE  a.seq = 1 -- 최종 Plan 으로 처리

		/* 출하계획 추출 */
		/*
		SELECT P.* 
		       INTO #tmp_ship_plan
		  FROM scp_pln_ship_plan_target_v p WITH(NOLOCK)
		 WHERE EXISTS (
			          SELECT 1
					  FROM   #tmp_version V
					  WHERE  p.division_id         = v.division_id
		              AND    p.plan_start_yyyymmdd = v.plan_start_yyyymmdd
		              AND    p.plan_type           = V.PLAN_TYPE
		              AND    p.seq                 = v.plan_seq
			      )
		   AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*22, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
		*/

		SELECT P.*
		       INTO #tmp_ship_plan
		  FROM (
		        -- 1. 출하계획
		        SELECT P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP, P.FROM_SITE
		             , P.PLANT_ID, P.CUSTOMER_CODE, P.CUSTOMER_NAME, P.SHIP_TO_CODE, P.SHIP_TO_PARTY, P.TO_SITE, P.TO_PLANT_ID, P.TO_SITE_TYPE
			         , P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.RECEIVE_YYYYMMDD, P.RECEIVE_YYYYMMDD_SSP, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE
			         , P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID, P.ORIGIN_TO_DIVISION_ID, P.CREATE_USER_ID, P.CREATE_DATE, P.MODIFY_USER_ID, P.MODIFY_DATE
					 , P.PROJECT_CODE
		          FROM scp_pln_ship_plan_target_v p WITH(NOLOCK)
		         WHERE EXISTS (
			                   SELECT 1
					           FROM   #tmp_version V
					           WHERE  p.division_id         = v.division_id
		                       AND    p.plan_start_yyyymmdd = v.plan_start_yyyymmdd
		                       AND    p.plan_type           = V.PLAN_TYPE
		                       AND    p.seq                 = v.plan_seq
			           )
		           --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*22, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
				   AND (P.SHIP_YYYYMMDD >= @v_period_start_date  and P.SHIP_YYYYMMDD <= @v_period_end_date)
				   AND P.FCST_TYPE NOT IN ('ASF','ETC','RMA','TST','SDF','SMF') -- 'A/S(Free), 기타매출, RMA, Interal Test, Sample(Dev/Free), Sample(Mass/Free) 는 매출 대상 아니므로 제외
				   AND P.SHIP_TO_CODE NOT LIKE 'ST%'
				-----------
		         UNION ALL
				-----------
		        -- 2. 운송중 재고
		        SELECT P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP, P.FROM_SITE
		             , P.PLANT_ID, P.CUSTOMER_CODE, P.CUSTOMER_NAME, P.SHIP_TO_CODE, P.SHIP_TO_PARTY, P.TO_SITE, P.TO_PLANT_ID, P.TO_SITE_TYPE
			         , P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.RECEIVE_YYYYMMDD, P.RECEIVE_YYYYMMDD_SSP, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE
			         , P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID, P.ORIGIN_TO_DIVISION_ID, P.CREATE_USER_ID, P.CREATE_DATE, P.MODIFY_USER_ID, P.MODIFY_DATE
					 , P.PROJECT_CODE
		          FROM (
				        /*
		                SELECT IT.DIVISION_ID, V.PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD, 'FN' AS PLAN_TYPE, '1' AS SEQ, '' AS SHIP_ID
					         , IT.ITEM_ID, dbo.fn_get_item_operation_group(IT.division_id, IT.item_id) OPERATION_GROUP
					         , IT.FROM_SCM_SITE_ID AS FROM_SITE, IT.PLANT_ID
					         , CASE WHEN IT.FINAL_SOLDTO_CODE = @v_C100 THEN @v_B100 ELSE IT.FINAL_SOLDTO_CODE END AS CUSTOMER_CODE
					         , IT.FINAL_SOLDTO_NAME AS CUSTOMER_NAME
					         , CASE WHEN IT.SHIPTO_CODE = @v_C100 THEN @v_B100 ELSE IT.SHIPTO_CODE END AS SHIP_TO_CODE
					         , '' AS SHIP_TO_PARTY
					         , IT.TO_SCM_SITE_ID AS TO_SITE, B.PLANT_ID AS TO_PLANT_ID, B.SITE_TYPE AS TO_SITE_TYPE
						     , ( SELECT basis_yyyymmdd
							       FROM scm_sys_calendar_m cm WITH(NOLOCK)
							      WHERE iso_yyyyww IN (SELECT iso_yyyyww
									     				 FROM scm_sys_calendar_m WITH(NOLOCK)
												        WHERE basis_yyyymmdd = IT.PLANT_ISSUE_DATE )
							        AND dayofweek = 'MON'             
						       )    AS SHIP_WEEK
					         , IT.PLANT_ISSUE_DATE AS SHIP_YYYYMMDD
	 
					         , dbo.FN_SCM_SYS_NVL( IT.f_dest_eta_date
												  , IIF( bod.lt_total IS NULL
														, IIF( bod2.lt_total IS NULL
															 , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, IT.result_date)), 112)
															 , CONVERT(NVARCHAR(8), DATEADD(d, bod2.lt_total, IT.plant_issue_date), 112)
															)
														, CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, IT.plant_issue_date), 112)
													   )
												 )  AS RECEIVE_YYYYMMDD
		
					         , dbo.FN_SCM_SYS_NVL( IT.f_dest_eta_date
												  , IIF( bod.lt_total IS NULL
														, IIF( bod2.lt_total IS NULL
															 , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, IT.result_date)), 112)
															 , CONVERT(NVARCHAR(8), DATEADD(d, bod2.lt_total, IT.plant_issue_date), 112)
															)
														, CONVERT(NVARCHAR(8), DATEADD(d, bod.lt_total, IT.plant_issue_date), 112)
													   )
												 )  AS RECEIVE_YYYYMMDD_SSP
					         , IT.DELIVERY_QTY AS SHIP_QTY, 'MPS' AS FCST_TYPE, IT.TRANSPORT_MODE, '' PRIORITY, 'E' AS DOM_EXP
					         , IT.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID, B.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
					         , '' AS CREATE_USER_ID, '' AS CREATE_DATE, '' AS MODIFY_USER_ID, '' AS MODIFY_DATE
				          FROM SCM_DNM_INTRANSIT_C IT WITH(NOLOCK)
					           INNER JOIN ( SELECT division_id, scm_site_id, site_type, PLANT_ID
											FROM   dbo.scm_mst_site WITH (NOLOCK) 
											WHERE  site_type  IN ('PLANT', 'SALES') -- To가 PLANT/SALES 인 경우 동시 반영
											AND    valid_yn    = 'Y') B
							   ON   IT.division_id             = B.division_id
							   AND  IT.to_scm_site_id          = B.scm_site_id
			
							   LEFT JOIN  scp_mst_bod_v bod WITH (NOLOCK)
							   ON    bod.division_id    = IT.division_id
							   AND   bod.from_site      = IT.from_scm_site_id
							   AND   bod.to_site        = IT.to_scm_site_id
							   AND   bod.incoterms      = IT.final_incoterms -- a.incoterms  20201006 PJ20202001 변경
							   AND   bod.transport_mode = IT.transport_mode
							   AND   bod.bod_valid_yn   = 'Y'

							   -- From/To/Tr Mode 가 맞는 경우의 MAX(LT)
							   LEFT JOIN (SELECT A.division_id, A.from_site, A.to_site, A.transport_mode, MAX(lt_total) lt_total
										  FROM   scp_mst_bod_v A WITH (NOLOCK)
										  WHERE  A.bod_valid_yn    = 'Y'
										  GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode
										 ) bod2 
							   ON    bod2.division_id    = IT.division_id
							   AND   bod2.from_site      = IT.from_scm_site_id
							   AND   bod2.to_site        = IT.to_scm_site_id
							   AND   bod2.transport_mode = IT.transport_mode

					           INNER JOIN (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, CONVERT(NVARCHAR(8), DATEADD(DAY, -1, PLAN_START_YYYYMMDD),112) AS PLAN_YYYYMMDD
									       FROM  #tmp_version V ) V
						       ON  IT.DIVISION_ID = V.DIVISION_ID
						       AND IT.RESULT_DATE = V.PLAN_YYYYMMDD
				         WHERE IT.RESULT_TYPE IN ('I', 'C')
				           AND IT.FROM_SCM_SITE_ID IS NOT NULL
						*/
						SELECT IT.DIVISION_ID, V.PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD, 'FN' AS PLAN_TYPE, '1' AS SEQ, '' AS SHIP_ID
					         , IT.ITEM_ID, dbo.fn_get_item_operation_group(IT.division_id, IT.item_id) OPERATION_GROUP
					         , IT.FROM_SCM_SITE_ID AS FROM_SITE, IT.PLANT_ID
					         , CASE WHEN IT.FINAL_SOLDTO_CODE = @v_ESOC THEN @v_COMPANY_SALES ELSE IT.FINAL_SOLDTO_CODE END AS CUSTOMER_CODE
					         , IT.FINAL_SOLDTO_NAME AS CUSTOMER_NAME
					         , CASE WHEN IT.SHIPTO_CODE = @v_ESOC THEN @v_COMPANY_SALES ELSE IT.SHIPTO_CODE END AS SHIP_TO_CODE
					         , '' AS SHIP_TO_PARTY
					         , IT.TO_SCM_SITE_ID AS TO_SITE, B.PLANT_ID AS TO_PLANT_ID, B.SITE_TYPE AS TO_SITE_TYPE
						     , ( SELECT basis_yyyymmdd
							       FROM scm_sys_calendar_m cm WITH(NOLOCK)
							      WHERE iso_yyyyww IN (SELECT iso_yyyyww
									     				 FROM scm_sys_calendar_m WITH(NOLOCK)
												        WHERE basis_yyyymmdd = IT.PLANT_ISSUE_DATE )
							        AND dayofweek = 'MON'             
						       )    AS SHIP_WEEK
					         , IT.PLANT_ISSUE_DATE AS SHIP_YYYYMMDD
	 
					         , dbo.FN_SCM_SYS_NVL( IT.f_dest_eta_date
												  , IIF( bod.LT_TOTAL_SSP IS NULL
														, IIF( bod2.LT_TOTAL_SSP IS NULL
															 , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, IT.result_date)), 112)
															 , CONVERT(NVARCHAR(8), DATEADD(d, bod2.LT_TOTAL_SSP, IT.plant_issue_date), 112)
															)
														, CONVERT(NVARCHAR(8), DATEADD(d, bod.LT_TOTAL_SSP, IT.plant_issue_date), 112)
													   )
												 )  AS RECEIVE_YYYYMMDD
		
					         , dbo.FN_SCM_SYS_NVL( IT.f_dest_eta_date
												  , IIF( bod.LT_TOTAL_SSP IS NULL
														, IIF( bod2.LT_TOTAL_SSP IS NULL
															 , CONVERT(NVARCHAR(8), DATEADD(d, 1, CONVERT(DATETIME, IT.result_date)), 112)
															 , CONVERT(NVARCHAR(8), DATEADD(d, bod2.LT_TOTAL_SSP, IT.plant_issue_date), 112)
															)
														, CONVERT(NVARCHAR(8), DATEADD(d, bod.LT_TOTAL_SSP, IT.plant_issue_date), 112)
													   )
												 )  AS RECEIVE_YYYYMMDD_SSP
					         , IT.DELIVERY_QTY AS SHIP_QTY, 'MPS' AS FCST_TYPE, IT.TRANSPORT_MODE, '' PRIORITY, 'E' AS DOM_EXP
					         , IT.DIVISION_ID AS ORIGIN_FROM_DIVISION_ID, B.DIVISION_ID AS ORIGIN_TO_DIVISION_ID
					         , '' AS CREATE_USER_ID, '' AS CREATE_DATE, '' AS MODIFY_USER_ID, '' AS MODIFY_DATE
							 , IT.PROJECT_CODE
				          FROM SCM_DNM_INTRANSIT_C IT WITH(NOLOCK)
					           INNER JOIN ( SELECT division_id, scm_site_id, site_type, PLANT_ID
											FROM   dbo.scm_mst_site WITH (NOLOCK) 
											WHERE  site_type  IN ('PLANT', 'SALES') -- To가 PLANT/SALES 인 경우 동시 반영
											AND    valid_yn    = 'Y') B
							   ON   IT.division_id             = B.division_id
							   AND  IT.to_scm_site_id          = B.scm_site_id
			
							   LEFT JOIN  scp_mst_bod_n_v bod WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
							   --LEFT JOIN  scp_mst_bod_v bod WITH (NOLOCK)
							   ON    bod.division_id    = IT.division_id
							   AND   bod.from_site      = IT.from_scm_site_id
							   AND   bod.to_site        = IT.to_scm_site_id
							   AND   bod.SSP_incoterms      = IT.final_incoterms -- a.incoterms  20201006 PJ20202001 변경
							   AND   bod.transport_mode = IT.transport_mode
							   AND   bod.bod_valid_yn   = 'Y'

							   AND   bod.from_yyyymmdd <= IT.plant_issue_date -- 20210707 PJ20209643 추가
							   AND   bod.to_yyyymmdd   >= IT.plant_issue_date -- 20210707 PJ20209643 추가

							   -- From/To/Tr Mode 가 맞는 경우의 MAX(LT)
							   LEFT JOIN (SELECT A.division_id, A.from_site, A.to_site, A.transport_mode, MAX(LT_TOTAL_SSP) LT_TOTAL_SSP
										  FROM   scp_mst_bod_n_v A WITH (NOLOCK) -- 20210707 PJ20209643 scp_mst_bod_v 에서 scp_mst_bod_n_v로 변경
										  --FROM   scp_mst_bod_v A WITH (NOLOCK)
										  WHERE  A.bod_valid_yn    = 'Y'
										  GROUP BY A.division_id, A.from_site,A.to_site, A.transport_mode
										 ) bod2 
							   ON    bod2.division_id    = IT.division_id
							   AND   bod2.from_site      = IT.from_scm_site_id
							   AND   bod2.to_site        = IT.to_scm_site_id
							   AND   bod2.transport_mode = IT.transport_mode

					           INNER JOIN (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, CONVERT(NVARCHAR(8), DATEADD(DAY, -1, PLAN_START_YYYYMMDD),112) AS PLAN_YYYYMMDD
									       FROM  #tmp_version V ) V
						       ON  IT.DIVISION_ID = V.DIVISION_ID
						       AND IT.RESULT_DATE = V.PLAN_YYYYMMDD
				         WHERE IT.RESULT_TYPE IN ('I', 'C')
				           AND IT.FROM_SCM_SITE_ID IS NOT NULL
						   AND ISNULL(IT.FINAL_SOLDTO_CODE,'') <> @v_COMPANY_SALES
						   AND ISNULL(IT.SHIPTO_CODE,'')       <> @v_COMPANY_SALES
                           AND IT.RESULT_TYPE = 'I'
		                ) P
		          WHERE 1 = 1
		            --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*22, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
		            AND (P.SHIP_YYYYMMDD >= @v_period_start_date and P.SHIP_YYYYMMDD <= @v_period_end_date)
		         ) P
		   WHERE 1 = 1
					  


        INSERT INTO XIF_SCP_MOVE_SALES_PLAN_RP_SN
        ( ovsentt_cd       , pctr_cd          , gscm_site_name   , bkt_week         , bkt_type         , work_yyyymmdd    , pln_period_yyyymm, pln_yyyymm       ,
          billto_cust_cd   , shipto_cust_cd   , cust_cd          , endusr_cd        , plnt_cd          , vltn_type_cd     , mdl_cd           , pjt_cd           ,
          distrb_chnl_cd   , currency_cd      , unit_cd          , sales_qty        , sales_unit_price , txn_amt          , usd_amt          , krw_amt          ,
          fcst_qty         , dest_biz_unit_cd , shp_pln_type_cd  , vmi_shp_flag     , osp_shp_flag     , orig_from_div_id , orig_to_div_id   , to_plnt_cd       ,
          gscm_to_site_name, shp_yyyymmdd     , rcv_yyyymmdd     , src_sys_cd       , gcs_transf_flag  , gcs_transf_date  , creation_date    , last_upd_date    ,
          attribute1_value , attribute2_value , attribute3_value , attribute4_value , attribute5_value ,
          attribute6_value , attribute7_value , attribute8_value , attribute9_value , attribute10_value,
          attribute11_value, attribute12_value, attribute13_value, attribute14_value, attribute15_value,
          attribute16_value, attribute17_value, attribute18_value, attribute19_value, attribute20_value
        )
		
        SELECT ovsentt_cd       , pctr_cd          , gscm_site_name   , bkt_week         , bkt_type         , work_yyyymmdd    , pln_period_yyyymm, pln_yyyymm       ,
               billto_cust_cd   , shipto_cust_cd   , cust_cd          , endusr_cd        , plnt_cd          , vltn_type_cd     , mdl_cd           , 
			   CASE WHEN ISNULL(pjt_cd, '') = '' THEN '*'
			        ELSE pjt_cd
			   END AS pjt_cd           ,
               distrb_chnl_cd   , currency_cd      , unit_cd          , sales_qty        , sales_unit_price , txn_amt          , usd_amt          , krw_amt          ,
               fcst_qty         , dest_biz_unit_cd , 
		       'E'  AS shp_pln_type_cd  , -- 법인간 : E, 연결 : C , 개별: 법인간(E) + 연결(C)
		       vmi_shp_flag     , osp_shp_flag     , orig_from_div_id , orig_to_div_id   , to_plnt_cd       ,
               gscm_to_site_name, shp_yyyymmdd     , rcv_yyyymmdd     , src_sys_cd       , gcs_transf_flag  , gcs_transf_date  , creation_date    , last_upd_date    ,
               attribute1_value , attribute2_value , attribute3_value , attribute4_value , attribute5_value ,
               attribute6_value , attribute7_value , attribute8_value , attribute9_value , attribute10_value,
               attribute11_value, attribute12_value, attribute13_value, attribute14_value, attribute15_value,
               attribute16_value, attribute17_value, attribute18_value, attribute19_value, attribute20_value
        FROM  (

               SELECT [dbo].[FN_SCM_SYS_NVL](( SELECT TOP 1 company_id 
                                               FROM   SCM_MST_SITE WITH(NOLOCK)
                                               WHERE  division_id = p.origin_from_division_id
                                               AND    scm_site_id = p.from_site 
                                             )
                                           , '*')            AS ovsentt_cd
                    , '*'                                    AS pctr_cd
                    , '*'                                    AS gscm_site_name   
                    , SUBSTRING(buc.yyyyww, 5, 2)            AS bkt_week          --receive_yyyymmdd 기준 주차
                    , 'W'                                    AS bkt_type   
                    , @v_work_yyyymmdd                       AS work_yyyymmdd     -- Proc 에서는 변수로 시작일자 지정후 Insert 할 것
                    , CONVERT(CHAR(6), GETDATE(), 112)       AS pln_period_yyyymm -- 전송 기준 YYYYMM, 경영관리 PI 이현석 책임 요청으로 기존 start date 기준에서 전송 일자 기준으로 변경함 by chaosjung 2020.08.26
                    , SUBSTRING(p.RECEIVE_YYYYMMDD_SSP, 1, 6)  AS pln_yyyymm        -- RECEIVE_YYYYMMDD_SSP 기준 YYYYMM
					
                    , CASE WHEN P.PLAN_GB IN ('SP3','SP4') THEN P.CUSTOMER_CODE 
					       ELSE [dbo].[FN_SCM_SYS_NVL]( [dbo].[FN_GET_SITE_CUSTOMER_INFO](p.origin_to_division_id, p.to_site, 'SOLDTO_CODE'), '*') END AS billto_cust_cd  --To Site 기준 Sold To 정보 생성
                    , CASE WHEN P.PLAN_GB IN ('SP3','SP4') THEN P.SHIP_TO_CODE
					       ELSE [dbo].[FN_SCM_SYS_NVL]( [dbo].[FN_GET_SITE_CUSTOMER_INFO](p.origin_to_division_id, p.to_site, 'SHIPTO_CODE'), '*') END AS shipto_cust_cd  --To Site 기준 Ship To 정보 생성
                    , CASE WHEN P.PLAN_GB IN ('SP3','SP4') THEN P.CUSTOMER_CODE
					       ELSE [dbo].[FN_SCM_SYS_NVL]( [dbo].[FN_GET_SITE_CUSTOMER_INFO](p.origin_to_division_id, p.to_site, 'SOLDTO_CODE'), '*') END AS cust_cd         --To Site 기준 Sold To 정보 생성

                    , '*'                       AS endusr_cd   
                    /********************************************************************/
					/* 1. 전극은 조립 Plant 로 변환하여 전송                            */
					/* 2. 외주 패커의 경우 패커가 귀속되는 자사 Plant 로 변환하여 전송  */
					/********************************************************************/
                    , ISNULL(CASE WHEN FS.OPERATION_GROUP = 'E' 
								  THEN (SELECT TOP 1 PLANT_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
					    				WHERE SITE.DIVISION_ID = P.ORIGIN_FROM_DIVISION_ID 
										  AND SITE.COMPANY_ID  = ( SELECT TOP 1 company_id 
									  									FROM SCM_MST_SITE WITH(NOLOCK)
																	  WHERE  DIVISION_ID = P.ORIGIN_FROM_DIVISION_ID
																		AND  scm_site_id = p.from_site )
										    AND SITE.SITE_TYPE       = 'PLANT'
											AND SITE.OPERATION_GROUP = 'A'
											AND SITE.OSP_YN         <> 'Y'
											AND SITE.VALID_YN        = 'Y')
								  ELSE 
										CASE WHEN FS.OSP_YN = 'Y' 
											THEN ( SELECT TOP 1 SITE.LOGISTIC_PLANT_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
													WHERE SITE_TYPE          = 'PLANT' 
														AND OSP_YN           = 'Y' 
														AND VALID_YN         = 'Y'
														AND SITE.DIVISION_ID = P.ORIGIN_FROM_DIVISION_ID 
														AND SITE.PLANT_ID    = P.PLANT_ID )
											ELSE P.PLANT_ID 
										END
					         END, P.PLANT_ID)   AS PLNT_CD
                    , '*'                       AS vltn_type_cd   
                    ,  p.item_id                AS mdl_cd                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                    , P.PROJECT_CODE            AS pjt_cd    
                    , '*'                       AS distrb_chnl_cd
			 
                    , '*'                       AS currency_cd   
                    , i.item_uom                AS unit_cd   --scm_mst_item_sn 기준 ITEM_UOM
                    , p.ship_qty                AS sales_qty   
                    , 0                         AS sales_unit_price     
                    , 0                         AS txn_amt
                    , 0                         AS usd_amt 
                    , 0                         AS krw_amt
                    , 0                         AS fcst_qty
                    , '*'                       AS dest_biz_unit_cd
                    -- SCP에서 나오는 출하계획 유형 : 이동계획 대상 => 01,03,04,05,06,12,13 
                    ,CASE WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'SALES'                                                                                       THEN '1'
                          
                          WHEN P.PLAN_GB = 'SP3'                                                                                                                                             THEN '14' -- 삼국간 거래 건
                          WHEN P.PLAN_GB = 'SP4'                                                                                                                                             THEN '17' -- ESS 삼국간 거래 건
						  WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND fs.company_id <> ts.company_id and fs.site_id  = ts.site_id AND p.origin_from_division_id   = p.origin_to_division_id THEN '15'
						  WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND fs.company_id  = ts.company_id and fs.site_id  = ts.site_id AND p.origin_from_division_id  <> p.origin_to_division_id THEN '16'

						  WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND fs.site_id  = ts.site_id AND p.origin_from_division_id  = p.origin_to_division_id THEN '2'
                          WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND fs.site_id  = ts.site_id AND p.origin_from_division_id <> p.origin_to_division_id THEN '3'
                          WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND fs.site_id <> ts.site_id AND p.origin_from_division_id  = p.origin_to_division_id THEN '4'
                          WHEN fs.operation_group = 'E' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND fs.site_id <> ts.site_id AND p.origin_from_division_id <> p.origin_to_division_id THEN '5'
                          WHEN fs.operation_group = 'E' AND fs.osp_yn = 'Y' AND ts.site_type = 'PLANT'                                                                                       THEN '14'
        
                          WHEN fs.operation_group = 'A' AND fs.osp_yn = 'N' AND ts.site_type = 'SALES' THEN '6'
                          WHEN fs.operation_group = 'A' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND ts.operation_group = 'A' AND ts.osp_yn = 'Y' THEN '7'
                          WHEN fs.operation_group = 'A' AND fs.osp_yn = 'Y' AND ts.site_type = 'PLANT' AND ts.operation_group = 'A' AND ts.osp_yn = 'N' THEN '8'
                          WHEN fs.operation_group = 'A' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND ts.operation_group = 'P' AND ts.osp_yn = 'Y' THEN '9'
                          WHEN fs.operation_group = 'A' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND ts.operation_group = 'P' AND ts.osp_yn = 'N' AND fs.site_id  = ts.site_id THEN '10'
                          WHEN fs.operation_group = 'A' AND fs.osp_yn = 'N' AND ts.site_type = 'PLANT' AND ts.operation_group = 'P' AND ts.osp_yn = 'N' AND fs.site_id <> ts.site_id THEN '11'
        			
                          WHEN fs.operation_group = 'P' AND fs.osp_yn = 'N' AND ts.site_type = 'SALES' THEN '12'
                          WHEN fs.operation_group = 'P' AND fs.osp_yn = 'Y' AND ts.site_type = 'SALES' THEN '13'
                          ELSE '*'
                     END                                     AS shp_pln_type_cd

                    , [dbo].[FN_SCM_SYS_NVL](ts.vmi_yn, 'N') AS vmi_shp_flag
                    , fs.osp_yn                              AS osp_shp_flag
                    , p.origin_from_division_id              AS orig_from_div_id
                    , p.origin_to_division_id                AS orig_to_div_id
                    , ts.plant_id                            AS to_plnt_cd
                    , p.to_site                              AS gscm_to_site_name
                    , p.ship_yyyymmdd                        AS shp_yyyymmdd
                    , p.RECEIVE_YYYYMMDD_SSP                 AS rcv_yyyymmdd

                    , 'GSCM_T4'                              AS src_sys_cd   -- 사업부마스터상 전지사업본부코드가 'T4'로 관리됨
                    , 'N'                                    AS gcs_transf_flag   
                    , @d_gcs_trans_date                      AS gcs_transf_date 
                    , GETDATE()                              AS creation_date 
                    , GETDATE()                              AS last_upd_date
                    , NULL AS ATTRIBUTE1_VALUE , NULL AS attribute2_value , NULL AS attribute3_value , NULL AS attribute4_value , NULL AS attribute5_value 
                    , NULL AS attribute6_value , NULL AS attribute7_value , NULL AS attribute8_value , NULL AS attribute9_value , NULL AS attribute10_value
                    , NULL AS attribute11_value, NULL AS attribute12_value, NULL AS attribute13_value, NULL AS attribute14_value, NULL AS attribute15_value
                    , NULL AS attribute16_value, NULL AS attribute17_value, NULL AS attribute18_value
					, CASE WHEN P.PLAN_GB = 'SP3' THEN P.SOLDTO_CODE ELSE NULL END AS attribute19_value
					, CASE WHEN P.PLAN_GB = 'SP3' THEN 'THRID_PARTY' ELSE NULL END AS attribute20_value
                    
               FROM (
			           /* 사내 거래*/
					   SELECT 'SP1' AS PLAN_GB, P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP
							, P.FROM_SITE, P.PLANT_ID
							, P.CUSTOMER_CODE, P.CUSTOMER_NAME, P.SHIP_TO_CODE, P.SHIP_TO_PARTY, P.TO_SITE
							, P.TO_PLANT_ID, P.TO_SITE_TYPE, P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.RECEIVE_YYYYMMDD, P.RECEIVE_YYYYMMDD_SSP
							, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE, P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID
							, P.ORIGIN_TO_DIVISION_ID 
							, P.CUSTOMER_CODE AS SOLDTO_CODE
							, '*'             AS PROJECT_CODE
					     FROM #tmp_ship_plan P
						WHERE 1 = 1
						 AND P.TO_SITE_TYPE = 'PLANT' -- 사내 거래만 대상으로 함
						 --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*22, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
						 AND (P.RECEIVE_YYYYMMDD_SSP >= @v_period_start_date and P.RECEIVE_YYYYMMDD_SSP <= @v_period_end_date)
		           
					   UNION ALL
					   /* 판매 법인향 거래 */
					   /* add by chaosjung 20200720 */
					   SELECT 'SP2' AS PLAN_GB, P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP
							, P.FROM_SITE, P.PLANT_ID
							, P.CUSTOMER_CODE, P.CUSTOMER_NAME, P.SHIP_TO_CODE, P.SHIP_TO_PARTY, P.TO_SITE
							, P.TO_PLANT_ID, P.TO_SITE_TYPE, P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.RECEIVE_YYYYMMDD, P.RECEIVE_YYYYMMDD_SSP
							, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE, P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID
							, P.ORIGIN_TO_DIVISION_ID 
							, P.CUSTOMER_CODE AS SOLDTO_CODE
							, '*'             AS PROJECT_CODE
					     FROM #tmp_ship_plan P
					   INNER JOIN (	/* 매출지가 판매법인향인 SITE와 아이템 축출 */
					                   SELECT DISTINCT A.SCM_SITE_ID, A.ITEM_ID 
											  FROM SCM_MST_SITE_ITEM A WITH(NOLOCK)
											  INNER JOIN SCM_MST_SITE B WITH(NOLOCK)                     
											ON A.DIVISION_ID = B.DIVISION_ID
											AND A.SALES_COMPANY = B.SCM_SITE_ID
											AND B.SITE_TYPE = 'CORP'
											AND A.VALID_YN = 'Y'
											AND B.VALID_YN = 'Y'
											AND (CASE WHEN ISNULL(A.BPMS_EXIST,'Y') = 'N' THEN 'N' ELSE 'Y' END) = 'Y'
										  ) SITE
							   ON P.TO_SITE  = SITE.SCM_SITE_ID
							   AND P.ITEM_ID = SITE.ITEM_ID
					   WHERE 1=1
						 AND p.TO_SITE_TYPE      = 'SALES' -- 판매 중 판매법인 대상 추가 
						 --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*27, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
						 AND (P.RECEIVE_YYYYMMDD_SSP >= @v_period_start_date and P.RECEIVE_YYYYMMDD_SSP <= @v_period_end_date)

			           UNION ALL
					   
					  /* 3.1 ESS CNJ Cell → 구미 피플웍스로 출하되는 경우 (3국간 거래)
					    *    ESS ESNB Cell → 오창 → ESNJ → 남경 피플웍스 출하되는 경우 (3국간 거래)
					   */
					    SELECT 'SP4' AS PLAN_GB, P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP
							, P.FROM_SITE, P.PLANT_ID
							, @v_COMPANY_SALES AS CUSTOMER_CODE, P.CUSTOMER_NAME
							, P.CUSTOMER_CODE AS SHIP_TO_CODE, P.SHIP_TO_PARTY, P.TO_SITE
							, P.TO_PLANT_ID, P.TO_SITE_TYPE, P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.RECEIVE_YYYYMMDD, P.RECEIVE_YYYYMMDD_SSP
							, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE, P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID
							, P.ORIGIN_TO_DIVISION_ID 
							, P.CUSTOMER_CODE AS SOLDTO_CODE
							, '*'             AS PROJECT_CODE
					     FROM #tmp_ship_plan P
						WHERE 1 = 1
						 AND P.TO_SITE_TYPE = 'PLANT' -- 사내 거래만 대상으로 함
						 --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*22, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
						 AND (P.RECEIVE_YYYYMMDD_SSP >= @v_period_start_date and P.RECEIVE_YYYYMMDD_SSP <= @v_period_end_date)
						 AND P.FROM_SITE + '^' + P.CUSTOMER_CODE IN ('G184-A^KR008072', 'G634-A^G180')

			           UNION ALL

					  /* 3.2 삼국간 거래인 경우. (Customer_code, Ship_to_code, To_site)  */
					  SELECT 'SP3' AS PLAN_GB, P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP
							, P.FROM_SITE, P.PLANT_ID
							-- Customer_code, Ship_to_code, To_site, to_plant_id, to_site_type 변경
							, CASE WHEN TS.COMPANY_ID = @v_ESOC THEN @v_COMPANY_SALES ELSE TS.COMPANY_ID END AS CUSTOMER_CODE, P.CUSTOMER_NAME
							, P.SHIP_TO_CODE, P.SHIP_TO_PARTY
							, ISNULL(PT.SCM_SITE_ID, ST.SCM_SITE_ID) AS TO_SITE, ISNULL(PT.PLANT_ID, ST.PLANT_ID) AS TO_PLANT_ID, 'PLANT' AS TO_SITE_TYPE
							------------------------------------------------------------------------------------
							, P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.SHIP_YYYYMMDD AS RECEIVE_YYYYMMDD, P.SHIP_YYYYMMDD AS RECEIVE_YYYYMMDD_SSP
							, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE, P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID
							, P.ORIGIN_TO_DIVISION_ID
							, P.CUSTOMER_CODE AS SOLDTO_CODE
							, CASE WHEN P.DIVISION_ID <> '40' THEN P.PROJECT_CODE ELSE '*' END AS PROJECT_CODE
							/*
							, TS.COMPANY_ID AS SALES_COMPANY_ID 
					        , FS.COMPANY_ID AS PLANT_COMPANY_ID
							, PT.SCM_SITE_ID
							, PT.PLANT_ID
							*/
					     FROM #tmp_ship_plan P
						   /*
						   INNER JOIN scm_mst_site ts WITH(NOLOCK)
						   ON  p.origin_from_division_id = ts.division_id
						   AND p.TO_SITE                 = ts.scm_site_id
						   */
						   INNER JOIN (
								   SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, MAX(SALES_COMPANY) AS COMPANY_ID
								   FROM   scm_mst_site_ITEM WITH(NOLOCK)
								   WHERE  SALES_COMPANY IS NOT NULL
								   GROUP  BY DIVISION_ID, SCM_SITE_ID, ITEM_ID
						       ) ts 
						   ON  p.origin_from_division_id = ts.division_id
						   AND p.TO_SITE                 = ts.scm_site_id
						   AND P.ITEM_ID                 = TS.ITEM_ID
						   INNER JOIN scm_mst_site fs WITH(NOLOCK)
						   ON  p.origin_from_division_id = fs.division_id
						   AND p.FROM_SITE               = fs.scm_site_id
						   LEFT OUTER JOIN scm_mst_site PT WITH(NOLOCK)
						   ON  ts.division_id            = PT.division_id
						   AND TS.COMPANY_ID             = PT.COMPANY_ID
						   AND PT.OPERATION_GROUP         = 'A'
						   AND PT.OSP_YN                 = 'N'
						   LEFT OUTER JOIN scm_mst_site ST WITH(NOLOCK)
						   ON  ts.division_id            = ST.division_id
						   AND TS.COMPANY_ID             = ST.SCM_SITE_ID
						   AND ST.DEPT_ID                = 'CORP'
						 WHERE p.TO_SITE_TYPE      = 'SALES' -- 판매 중 판매법인 대상 추가 
						   --AND P.TO_SITE LIKE 'HLGP%'
						   AND (CASE WHEN ISNULL(TS.COMPANY_ID,'') ='' THEN FS.COMPANY_ID ELSE TS.COMPANY_ID END) <> FS.COMPANY_ID
						   --AND P.ITEM_ID = 'EM048063P3N3'
						   --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*27, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
						   AND (P.SHIP_YYYYMMDD >= @v_period_start_date and P.SHIP_YYYYMMDD <= @v_period_end_date)
						   AND P.SHIP_TO_CODE <> ''

						   UNION ALL

					  /* 3.3 삼국간 거래인 경우. (Customer_code, Ship_to_code, To_site,  */
					  SELECT 'SP3' AS PLAN_GB, P.DIVISION_ID, P.PLAN_START_YYYYMMDD, P.PLAN_TYPE, P.SEQ, P.SHIP_ID, P.ITEM_ID, P.OPERATION_GROUP
							, P.FROM_SITE, P.PLANT_ID
							-- Customer_code, Ship_to_code, To_site, to_plant_id, to_site_type 변경
							, CASE WHEN TS.COMPANY_ID = @v_ESOC THEN @v_COMPANY_SALES ELSE TS.COMPANY_ID END AS CUSTOMER_CODE, P.CUSTOMER_NAME
							, P.SHIP_TO_CODE, P.SHIP_TO_PARTY
							, ISNULL(PT.SCM_SITE_ID, ST.SCM_SITE_ID) AS TO_SITE, ISNULL(PT.PLANT_ID, ST.PLANT_ID) AS TO_PLANT_ID, 'PLANT' AS TO_SITE_TYPE
							------------------------------------------------------------------------------------
							, P.SHIP_WEEK, P.SHIP_YYYYMMDD, P.RECEIVE_YYYYMMDD, P.RECEIVE_YYYYMMDD_SSP
							, P.SHIP_QTY, P.FCST_TYPE, P.TRANSPORT_MODE, P.PRIORITY, P.DOM_EXP, P.ORIGIN_FROM_DIVISION_ID
							, P.ORIGIN_TO_DIVISION_ID
							, P.CUSTOMER_CODE AS SOLDTO_CODE
							, '*'             AS PROJECT_CODE
							/*
							, TS.COMPANY_ID AS SALES_COMPANY_ID 
					        , FS.COMPANY_ID AS PLANT_COMPANY_ID
							, PT.SCM_SITE_ID
							, PT.PLANT_ID
							*/
					     FROM #tmp_ship_plan P
						   INNER JOIN scm_mst_site ts WITH(NOLOCK)
						   ON  p.origin_from_division_id = ts.division_id
						   AND p.TO_SITE                 = ts.scm_site_id
						   INNER JOIN scm_mst_site fs WITH(NOLOCK)
						   ON  p.origin_from_division_id = fs.division_id
						   AND p.FROM_SITE               = fs.scm_site_id
						   LEFT OUTER JOIN scm_mst_site PT WITH(NOLOCK)
						   ON  ts.division_id            = PT.division_id
						   AND TS.COMPANY_ID             = PT.COMPANY_ID
						   AND PT.OPERATION_GROUP         = 'A'
						   AND PT.OSP_YN                 = 'N'
						   LEFT OUTER JOIN scm_mst_site ST WITH(NOLOCK)
						   ON  ts.division_id            = ST.division_id
						   AND TS.COMPANY_ID             = ST.SCM_SITE_ID
						   AND ST.DEPT_ID                = 'CORP'
						 WHERE p.TO_SITE_TYPE      = 'PLANT' -- 판매 중 판매법인 대상 추가 
						   AND P.DIVISION_ID       = '40'
						   --AND P.TO_SITE LIKE 'HLGP%'
						   AND (CASE WHEN ISNULL(TS.COMPANY_ID,'') ='' THEN FS.COMPANY_ID ELSE TS.COMPANY_ID END) <> FS.COMPANY_ID
						   --AND P.ITEM_ID = 'EM048063P3N3'
						   --AND (P.RECEIVE_YYYYMMDD_SSP >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and P.RECEIVE_YYYYMMDD_SSP <= CONVERT(CHAR(8), DATEADD(DD,7*27, CONVERT(CHAR(6), GETDATE(), 112) + '01'),112))
						   AND (P.RECEIVE_YYYYMMDD_SSP >= @v_period_start_date and P.RECEIVE_YYYYMMDD_SSP <= @v_period_end_date)
						   AND P.SHIP_TO_CODE <> ''
						      
			   ) P
        
               INNER JOIN scm_mst_site fs WITH(NOLOCK)
               ON  p.origin_from_division_id = fs.division_id
               AND p.from_site               = fs.scm_site_id
        
               INNER JOIN scm_mst_site ts WITH(NOLOCK)
               ON  p.origin_to_division_id = ts.division_id
               AND p.to_site               = ts.scm_site_id
        
               INNER JOIN scm_mst_bucket buc WITH(NOLOCK)
               ON  buc.yyyymmdd = p.RECEIVE_YYYYMMDD_SSP --  p.plan_start_yyyymmdd
        
               INNER JOIN (
                           SELECT a.division_id, a.item_id, MAX(a.item_uom) AS item_uom, MAX(ITEM_TYPE) AS ITEM_TYPE
                           FROM   scm_mst_item_sn a WITH(NOLOCK)
                           GROUP BY a.division_id, a.item_id
                          ) i
               ON  p.origin_from_division_id = i.division_id
               AND p.item_id                 = i.item_id

               WHERE 1=1
              ) a

               WHERE 1=1
               AND   a.shp_pln_type_cd IN ('1','6','12','13','3', '4', '5', '11', '14', '15','17')   -- 1, 6, 12, 13 은 판매법인향(SALES 타입)

		/* 법인간 삼국간 거래건에 대한 CUST_CD Update */
		UPDATE A
		SET    A.BILLTO_CUST_CD = B.SOLDTO_CD
			 , A.CUST_CD        = B.SOLDTO_CD
			 , A.ATTRIBUTE19_VALUE = A.BILLTO_CUST_CD
			 , A.ATTRIBUTE20_VALUE = 'THRID_PARTY'
		FROM   XIF_SCP_MOVE_SALES_PLAN_RP_SN A
			 , (
				SELECT DISTINCT SEGMENT2 AS DIVISION_ID, SEGMENT1 AS FROM_COMPANY_ID, SEGMENT4 AS TO_COMPANY_ID, @v_COMPANY_SALES AS SOLDTO_CD
				FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
				WHERE  LOOKUP_TYPE IN ('ELECTRODE_SHIP_FROM_TO', 'CELL_SHIP_FROM_TO' )
				AND    ISNULL(ATTRIBUTE2, '') <> ''
			   ) B
		WHERE  A.WORK_YYYYMMDD   = @v_work_yyyymmdd
		AND    A.SHP_PLN_TYPE_CD = 'E'
		AND    A.OVSENTT_CD     = B.FROM_COMPANY_ID
		AND    A.BILLTO_CUST_CD = B.TO_COMPANY_ID
		AND    ISNULL(A.ATTRIBUTE20_VALUE,'') <> 'THRID_PARTY'

		
		/* 
		   개별 매출 - 남경 → 오창 → 고객 중 (오창 →고객) 
		   오창 기준 삼국간 거래에 대항 Data 생성.
		*/
		INSERT INTO XIF_SCP_MOVE_SALES_PLAN_RP_SN
				(ovsentt_cd, pctr_cd, gscm_site_name, bkt_week, bkt_type, work_yyyymmdd, pln_period_yyyymm, pln_yyyymm, billto_cust_cd,
				 shipto_cust_cd, cust_cd, endusr_cd, plnt_cd, vltn_type_cd, mdl_cd, pjt_cd, distrb_chnl_cd, currency_cd, unit_cd, sales_qty,
				 sales_unit_price, txn_amt, usd_amt, krw_amt, fcst_qty, dest_biz_unit_cd, shp_pln_type_cd, vmi_shp_flag, osp_shp_flag,
				 orig_from_div_id, orig_to_div_id, to_plnt_cd, gscm_to_site_name, shp_yyyymmdd, rcv_yyyymmdd, src_sys_cd, gcs_transf_flag,
				 gcs_transf_date, attribute1_value, attribute2_value, attribute3_value, attribute4_value, attribute5_value, attribute6_value,
				 attribute7_value, attribute8_value, attribute9_value, attribute10_value, attribute11_value, attribute12_value, attribute13_value,
				 attribute14_value, attribute15_value, attribute16_value, attribute17_value, attribute18_value, attribute19_value, attribute20_value, creation_date, last_upd_date)

		SELECT @v_ESOC AS ovsentt_cd, pctr_cd, gscm_site_name, bkt_week, bkt_type, work_yyyymmdd, pln_period_yyyymm, pln_yyyymm, attribute19_value AS billto_cust_cd,
			   shipto_cust_cd, attribute19_value AS cust_cd, endusr_cd,
			   (SELECT TOP 1 PLANT_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
				WHERE SITE.DIVISION_ID   = P.ORIG_FROM_DIV_ID 
				AND SITE.COMPANY_ID      = @v_ESOC
				AND SITE.SITE_TYPE       = 'PLANT'
				AND SITE.OPERATION_GROUP = 'A'
				AND SITE.OSP_YN         <> 'Y'
				AND SITE.VALID_YN        = 'Y')  AS plnt_cd, 
				vltn_type_cd, mdl_cd, pjt_cd, distrb_chnl_cd, currency_cd, unit_cd, sales_qty,
			   sales_unit_price, txn_amt, usd_amt, krw_amt, fcst_qty, dest_biz_unit_cd, shp_pln_type_cd, vmi_shp_flag, osp_shp_flag,
			   orig_from_div_id, orig_to_div_id, to_plnt_cd, gscm_to_site_name, shp_yyyymmdd, rcv_yyyymmdd, src_sys_cd, gcs_transf_flag,
			   gcs_transf_date, attribute1_value, attribute2_value, attribute3_value, attribute4_value, attribute5_value, attribute6_value,
			   attribute7_value, attribute8_value, attribute9_value, 
			   'Y' as attribute10_value,  -- 연결 매출 여부 설정
			   attribute11_value, attribute12_value, attribute13_value,
			   attribute14_value, attribute15_value, attribute16_value, attribute17_value, attribute18_value, attribute19_value, attribute20_value, creation_date, last_upd_date
		FROM   XIF_SCP_MOVE_SALES_PLAN_RP_SN P WITH(NOLOCK)
		WHERE  WORK_YYYYMMDD     = @v_work_yyyymmdd
		AND    ATTRIBUTE20_VALUE = 'THRID_PARTY'
		AND    BILLTO_CUST_CD    = @v_COMPANY_SALES
		AND    orig_from_div_id  <> '40'
		AND    attribute19_value IN (
		
		        SELECT DISTINCT COMPANY_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
				WHERE SITE.SITE_TYPE       = 'PLANT'
				AND SITE.OPERATION_GROUP = 'A'
				AND SITE.OSP_YN         <> 'Y'
				AND SITE.VALID_YN        = 'Y'
		       )

		UNION  ALL
		-- 소형 외주 Packer : Nexcon만 유상으로 오창 매출 처리.
		SELECT @v_ESOC AS ovsentt_cd, pctr_cd, gscm_site_name, bkt_week, bkt_type, work_yyyymmdd, pln_period_yyyymm, pln_yyyymm, attribute19_value AS billto_cust_cd,
			   shipto_cust_cd, attribute19_value AS cust_cd, endusr_cd,
			   (SELECT TOP 1 PLANT_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
				WHERE SITE.DIVISION_ID   = P.ORIG_FROM_DIV_ID 
				AND SITE.COMPANY_ID      =  @v_ESOC
				AND SITE.SITE_TYPE       = 'PLANT'
				AND SITE.OPERATION_GROUP = 'A'
				AND SITE.OSP_YN         <> 'Y'
				AND SITE.VALID_YN        = 'Y')  AS plnt_cd, 
				vltn_type_cd, mdl_cd, pjt_cd, distrb_chnl_cd, currency_cd, unit_cd, sales_qty,
			   sales_unit_price, txn_amt, usd_amt, krw_amt, fcst_qty, dest_biz_unit_cd, shp_pln_type_cd, vmi_shp_flag, osp_shp_flag,
			   orig_from_div_id, orig_to_div_id, to_plnt_cd, gscm_to_site_name, shp_yyyymmdd, rcv_yyyymmdd, src_sys_cd, gcs_transf_flag,
			   gcs_transf_date, attribute1_value, attribute2_value, attribute3_value, attribute4_value, attribute5_value, attribute6_value,
			   attribute7_value, attribute8_value, attribute9_value, 
			   'Y' as attribute10_value,  -- 연결 매출 여부 설정
			   attribute11_value, attribute12_value, attribute13_value,
			   attribute14_value, attribute15_value, attribute16_value, attribute17_value, attribute18_value, attribute19_value, attribute20_value, creation_date, last_upd_date
		FROM   XIF_SCP_MOVE_SALES_PLAN_RP_SN P WITH(NOLOCK)
		WHERE  WORK_YYYYMMDD     = @v_work_yyyymmdd
		AND    ATTRIBUTE20_VALUE = 'THRID_PARTY'
		AND    BILLTO_CUST_CD    = @v_COMPANY_SALES
		AND    orig_from_div_id  = '40'
		AND    shipto_cust_cd    = 'CNH008254'


		/*
		UPDATE XIF_SCP_MOVE_SALES_PLAN_RP_SN
		   SET gcs_transf_flag = 'Y'
		 WHERE WORK_YYYYMMDD = @v_work_yyyymmdd
		 */
        

    /** 법인간 거래 매출 END **/

        -- TXN LOG
        SET @n_log_count   = @@ROWCOUNT;
        SET @v_log_type    = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'법인간 거래 매출 Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date  = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
	
	/** 연결 거래 매출 START **/	    

        INSERT INTO XIF_SCP_MOVE_SALES_PLAN_RP_SN
        ( ovsentt_cd       , pctr_cd          , gscm_site_name   , bkt_week         , bkt_type         , work_yyyymmdd    , pln_period_yyyymm, pln_yyyymm       ,
          billto_cust_cd   , shipto_cust_cd   , cust_cd          , endusr_cd        , plnt_cd          , vltn_type_cd     , mdl_cd           , pjt_cd           ,
          distrb_chnl_cd   , currency_cd      , unit_cd          , sales_qty        , sales_unit_price , txn_amt          , usd_amt          , krw_amt          ,
          fcst_qty         , dest_biz_unit_cd , shp_pln_type_cd  , vmi_shp_flag     , osp_shp_flag     , orig_from_div_id , orig_to_div_id   , to_plnt_cd       ,
          gscm_to_site_name, shp_yyyymmdd     , rcv_yyyymmdd     , src_sys_cd       , gcs_transf_flag  , gcs_transf_date  , creation_date    , last_upd_date    ,
          attribute1_value , attribute2_value , attribute3_value , attribute4_value , attribute5_value ,
          attribute6_value , attribute7_value , attribute8_value , attribute9_value , attribute10_value,
          attribute11_value, attribute12_value, attribute13_value, attribute14_value, attribute15_value,
          attribute16_value, attribute17_value, attribute18_value, attribute19_value, attribute20_value
        )

		SELECT A.COMPANY_ID		AS OVSENTT_CD
			  ,'*'              AS PCTR_CD
			  ,'*'              AS GSCM_SITE_NAME
			  ,CASE WHEN A.RESULT_TYPE = 'RESULT' THEN '*' ELSE A.WK END AS BKT_WEEK
			  ,'W'              AS BKT_TYPE
			  ,@v_work_yyyymmdd AS WORK_YYYYMMDD
			  ,CONVERT(CHAR(6), GETDATE(), 112)       AS pln_period_yyyymm -- 전송 기준 YYYYMM, 경영관리 PI 이현석 책임 요청으로 기존 start date 기준에서 전송 일자 기준으로 변경함 by chaosjung 2020.08.26
			  ,A.YYYYMM         AS PLN_YYYYMM
			  /* ESS 판매법인(CEG,CAU) Sell-Out 매출은 관리하지 않고, 영업은 Sell-In 기준으로 관리하기로 함. 그러므로 전송 시 연결 매출에 포함하기 위해서 대표 고객으로 변환 전송 함 20200618 chaosjung */
			  ,dbo.FN_SCM_SYS_NVL(CASE WHEN ( SELECT DISTINCT SITE.COMPANY_ID  FROM SCM_MST_SITE SITE WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND A.DIVISION_ID = '82' AND SITE.COMPANY_ID = A.SOLDTO_CODE ) IS NOT NULL 
									   THEN ( SELECT ATTRIBUTE1 FROM SCM_MST_SITE SD WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND SD.DIVISION_ID = A.DIVISION_ID AND SD.SCM_SITE_ID = A.SOLDTO_CODE ) 
									   ELSE A.SOLDTO_CODE 
								  END, '*')	AS BILLTO_CUST
			  ,dbo.FN_SCM_SYS_NVL(CASE WHEN ( SELECT DISTINCT SITE.COMPANY_ID  FROM SCM_MST_SITE SITE WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND A.DIVISION_ID = '82' AND SITE.COMPANY_ID = A.SOLDTO_CODE ) IS NOT NULL 
									   THEN ( SELECT ATTRIBUTE3 FROM SCM_MST_SITE SD WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND SD.DIVISION_ID = A.DIVISION_ID AND SD.SCM_SITE_ID = A.SOLDTO_CODE ) 
									   ELSE A.SHIPTO_CODE 
								  END, '*')	AS SHIPTO_CUST
			  ,dbo.FN_SCM_SYS_NVL(CASE WHEN ( SELECT DISTINCT SITE.COMPANY_ID  FROM SCM_MST_SITE SITE WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND A.DIVISION_ID = '82' AND SITE.COMPANY_ID = A.SOLDTO_CODE ) IS NOT NULL 
									   THEN ( SELECT ATTRIBUTE1 FROM SCM_MST_SITE SD WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND SD.DIVISION_ID = A.DIVISION_ID AND SD.SCM_SITE_ID = A.SOLDTO_CODE ) 
									   ELSE A.SOLDTO_CODE 
								  END, '*')	AS CUST_CD
			  --,A.FCST_TYPE
			  --,A.INCOTERMS
			  --,A.PLANT_SITE_ID
			  --,A.PROJECT_CODE
			  ,'*'              AS ENDUSR_CD
			  ,A.PLANT_ID       AS PLNT_CD
			  ,'*'              AS VLTN_TYPE_CD
			  ,A.ITEM_ID        AS MDL_CD
			  ,dbo.FN_SCM_SYS_NVL(CASE WHEN A.division_id = '40' THEN '*' 
			                           WHEN ISNULL(A.Project_Code, '') = '' THEN '*'
			                           ELSE A.Project_Code 
			                      END, '*') AS PJT_CD
			  ,'*'              AS DISTRB_CHNL_CD
			  ,dbo.FN_SCM_SYS_NVL(PRI.CURRENCY, '*')   AS currency_cd     
			  ,IT.ITEM_UOM      AS UNIT_CD
			  ,A.SALES_QTY      AS SALES_QTY
			  ,PRI.PRICE        AS SALES_UNIT_PRICE
			  ,0                AS TXN_AMT
			  ,0                AS usd_amt 
			  ,0                AS krw_amt
			  ,0                AS fcst_qty
			  ,'*'              AS dest_biz_unit_cd
			  /* 법인간 : E, 연결 : C , 개별: 법인간(E) + 연결(C) */
			  /* 판매 법인향이 연결 매출에 존재하는 경우 법인간 거래로 변경함 
				 ESS 판매법인도 거래선 강제 변환하여, 연결 매출로 전송 함 20200618 chaosjung
			  */
			  --,CASE WHEN ( SELECT DISTINCT SITE.COMPANY_ID  FROM SCM_MST_SITE SITE WITH(NOLOCK) WHERE SITE_TYPE = 'CORP' AND VALID_YN = 'Y' AND SITE.COMPANY_ID = A.SOLDTO_CODE ) IS NOT NULL THEN 'E' ELSE 'C' END AS SHP_PLA_TYPE
			  ,'C'              AS SHP_PLA_TYPE 
			  ,'N'              AS VMI_SHIP_FLAG
			  ,'N'              AS OSP_SHIP_FLAG
			  ,A.DIVISION_ID    AS ORIG_FROM_DIV_ID
			  ,A.DIVISION_ID    AS ORIG_TO_DIV_ID
			  ,NULL				AS TO_PLNT_CD
			  ,A.SCM_SITE_ID    AS GSCM_TO_SITE_NAME
			  ,NULL             AS SHP_YYYYMMDD           
			  ,A.YYYYMMDD       AS RCV_YYYYMMDD
			  ,'GSCM_T4'        AS SRC_SYS_CD
			  ,'N'              AS GCS_TRANSF_FLAG
			  ,@d_gcs_trans_date  AS GCS_TRANSF_DATE
			  ,GETDATE()        AS CREATION_DATE
			  ,GETDATE()        AS LAST_UPD_DATE
			  /*,CASE WHEN IT.ITEM_TYPE = 'R' THEN '3000' 
					WHEN IT.ITEM_TYPE = 'H' THEN '7900'
					WHEN IT.ITEM_TYPE = 'P' THEN '7920'
					WHEN IT.ITEM_TYPE = 'Q' THEN '3100'
					ELSE '7920'             END              AS ATTRIBUTE1_VALUE */
			  ,NULL             AS ATTRIBUTE1_VALUE
			  ,NULL             AS ATTRIBUTE2_VALUE,  NULL   AS ATTRIBUTE3_VALUE,  NULL    AS ATTRIBUTE4_VALUE,  NULL    AS ATTRIBUTE5_VALUE
			  ,NULL             AS ATTRIBUTE6_VALUE,  NULL   AS ATTRIBUTE7_VALUE,  NULL    AS ATTRIBUTE8_VALUE,  NULL    AS ATTRIBUTE9_VALUE,  NULL    AS ATTRIBUTE10_VALUE
			  ,NULL             AS ATTRIBUTE11_VALUE, NULL   AS ATTRIBUTE12_VALUE, NULL    AS ATTRIBUTE13_VALUE, NULL    AS ATTRIBUTE14_VALUE, NULL    AS ATTRIBUTE15_VALUE
			  ,NULL             AS ATTRIBUTE16_VALUE, NULL   AS ATTRIBUTE17_VALUE, NULL    AS ATTRIBUTE18_VALUE, NULL    AS ATTRIBUTE19_VALUE, NULL    AS ATTRIBUTE20_VALUE
		FROM (
		SELECT A.DIVISION_ID
			  ,A.PROJECT_CODE
			  ,A.ITEM_ID
			  --,ISNULL(ISNULL(ISNULL(ISNULL(A.COMPANY_ID,PRI1.COMPANY_ID),PRI2.COMPANY_ID),PRI3.COMPANY_ID),PRI4.COMPANY_ID)		AS COMPANY_ID
			  --,ISNULL(ISNULL(ISNULL(ISNULL(A.PLANT_ID,PRI1.PLANT_ID),PRI2.PLANT_ID),PRI3.PLANT_ID),PRI4.PLANT_ID)   AS PLANT_ID
			  ,A.COMPANY_ID
			  ,A.PLANT_ID
			  --,ISNULL(ISNULL(ISNULL(ISNULL(ISNULL(A.COMPANY_ID,PRI1.COMPANY_ID),PRI2.COMPANY_ID),PRI3.COMPANY_ID),PRI4.COMPANY_ID),@v_ESOC)		AS COMPANY_ID
			  --,ISNULL(ISNULL(ISNULL(ISNULL(ISNULL(A.PLANT_ID,PRI1.PLANT_ID),PRI2.PLANT_ID),PRI3.PLANT_ID),PRI4.PLANT_ID), CASE WHEN A.DIVISION_ID = '40' THEN 'A010' WHEN A.DIVISION_ID = '81' THEN 'A040' WHEN A.DIVISION_ID = '82' THEN 'A050' END) AS PLANT_ID
			  ,A.SCM_SITE_ID
			  ,A.PLANT_SITE_ID
			  ,A.SOLDTO_CODE
			  ,A.SHIPTO_CODE
			  ,A.YYYYPW
			  ,MAX(A.YYYYWW)           AS YYYYWW
			  ,A.FCST_TYPE
			  ,A.INCOTERMS
			  ,A.DOM_EXP
			  ,MAX(WK)                  AS WK
			  ,A.YYYYMM
			  --,SUBSTRING(YYYYMMDD,1,6)  AS YYYYMM
			  ,SUM(SALES_QTY)           AS SALES_QTY
			--  ,SUM(SALES_KRW)         AS SALES_KRW
			  ,YYYYMMDD                 AS YYYYMMDD
			  ,A.RESULT_TYPE
			FROM(       
				SELECT  A.DIVISION_ID
					   ,A.PROJECT_CODE 
					   ,A.ITEM_ID
					   ,S2.SALES_COMPANY		AS COMPANY_ID
					   ,S2.SALES_PLANT   		AS PLANT_ID
					   ,A.SCM_SITE_ID
					   ,A.PLANT_SITE_ID
					   ,S3.SOLDTO_CODE
					   ,S3.SHIPTO_CODE
					   ,CA.ISO_YYYYPW			AS YYYYPW
					   ,MAX(CA.ISO_YYYYWW)		AS YYYYWW
					   ,MAX(ISO_WEEK)			AS WK
					   ,MAX(YYYYMM)				AS YYYYMM
					   ,A.YYYYMMDD				AS YYYYMMDD
					   ,A.FCST_TYPE
					   ,A.INCOTERMS
					   ,A.DOM_EXP
					   ,ISNULL(CASE WHEN ( A.MEASURE = 'RTF' OR A.MEASURE = 'RTF_SYS_RP') THEN SUM(A.QTY) END,0) AS SALES_QTY  
					   --,ISNULL(CASE WHEN A.MEASURE = 'SalesAmt_KRW' THEN SUM(A.QTY)                       END,0) AS SALES_KRW
					   --,MAX(IT.ITEM_UOM) AS ITEM_UOM
					   ,A.RESULT_TYPE
				  FROM (
							/* 매출 계획 */
							SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, A.YYYYMMDD, CURRENCY, QTY 
							     , 'PLAN' AS RESULT_TYPE -- 선행추정 실적/계획 구분자. (2021.01.13)
							  FROM DM_PLN_SALES_PLAN_C A WITH(NOLOCK)
							 WHERE 1 = 1
							   AND EXISTS (
							       SELECT *
								   FROM   (
							                SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
											FROM (
												   SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
													  	  ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
												   WHERE VERSION_TYPE = 'SP_W'
												   --AND  YYYYMMDD IN ('20210304','20210305')
												   --AND DIVISION_ID IN ('81')
											     ) VER
											WHERE VER.SEQ = 1
											/*
											--AND 1=0 
											UNION ALL 
											SELECT '40', 'SP_W_20201127_V001' AS VERSION_NO, 'SP_W' AS VERSION_TYPE, '20201127' AS YYYYMMDD
											--UNION ALL 
											--SELECT '81', 'SP_W_20201008_V001' AS VERSION_NO, 'SP_W' AS VERSION_TYPE, '20201008' AS YYYYMMDD
											UNION ALL 
											SELECT '82', 'SP_M_20201204_V001' AS VERSION_NO, 'SP_M' AS VERSION_TYPE, '20201204' AS YYYYMMDD
											*/
										  ) VER
									WHERE A.DIVISION_ID      = VER.DIVISION_ID
									AND   A.VERSION_NO       = VER.VERSION_NO
									AND   A.CUTOFF_TYPE      = VER.VERSION_TYPE
									AND   A.CUTOFF_YYYYMMDD  = VER.YYYYMMDD

							       )
							       /* 속도개선을 위한 버전 처리.
							       INNER JOIN ( SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
													FROM (
															SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
																	ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
															WHERE VERSION_TYPE = 'SP_W'
																AND DIVISION_ID IN ('81')
													) VER
													WHERE VER.SEQ = 1
												  --AND 1=0 
												UNION ALL 
												SELECT '40', 'SP_W_20201127_V001' AS VERSION_NO, 'SP_W' AS VERSION_TYPE, '20201127' AS YYYYMMDD
												--UNION ALL 
												--SELECT '81', 'SP_W_20201008_V001' AS VERSION_NO, 'SP_W' AS VERSION_TYPE, '20201008' AS YYYYMMDD
												UNION ALL 
												SELECT '82', 'SP_M_20201204_V001' AS VERSION_NO, 'SP_M' AS VERSION_TYPE, '20201204' AS YYYYMMDD
										) VER
									ON A.DIVISION_ID      = VER.DIVISION_ID
									AND A.VERSION_NO      = VER.VERSION_NO
									AND A.CUTOFF_TYPE     = VER.VERSION_TYPE
									AND A.CUTOFF_YYYYMMDD = VER.YYYYMMDD
									*/
									AND A.FCST_TYPE NOT IN ('ASF','ETC','RMA','TST','SDF','SMF') -- 'A/S(Free), 기타매출, RMA, Interal Test, Sample(Dev/Free), Sample(Mass/Free) 는 매출 대상 아니므로 제외 
									AND A.MEASURE IN  ('RTF_SYS_RP')
									--AND ( ( A.DIVISION_ID <> '82' AND  A.MEASURE IN  ('RTF_SYS_RP') ) OR ( A.DIVISION_ID = '82' AND A.MEASURE IN ('RTF') ) )
									--AND ( ( A.DIVISION_ID <> '82' AND  A.MEASURE IN  ('RTF_SYS_RP','SalesAmt_KRW') ) OR ( A.DIVISION_ID = '82' AND A.MEASURE IN ('RTF','SalesAmt_KRW') ) )
									--AND (A.YYYYMMDD >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,7*27, CONVERT(DATE, CONVERT(CHAR(6), GETDATE(), 112) + '01')),112))
									AND (A.YYYYMMDD >= @v_period_start_date and A.YYYYMMDD <= @v_period_end_date)
									--AND A.YYYYMMDD >= @v_plan_start_week_day
									AND A.QTY <> 0
							/* 
							UNION ALL
							/* 매출 실적 */
							SELECT A.DIVISION_ID, A.VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, A.YYYYMMDD, CURRENCY, QTY 
							     , 'RESULT' AS RESULT_TYPE -- 선행추정 실적/계획 구분자. (2021.01.13)
							  FROM DM_PLN_SALES_PLAN_RESULT_C A WITH(NOLOCK) 
							 WHERE 1 = 1
							   AND EXISTS (
							       SELECT *
								   FROM   (
							                SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
											FROM (
												   SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
													  	  ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
												   WHERE VERSION_TYPE = 'SP_W'
												   --AND DIVISION_ID IN ('81')
											     ) VER
											WHERE VER.SEQ = 1
										  ) VER
									WHERE A.DIVISION_ID      = VER.DIVISION_ID
									AND   A.VERSION_NO       = VER.VERSION_NO
									AND   A.CUTOFF_TYPE      = VER.VERSION_TYPE
									AND   A.CUTOFF_YYYYMMDD  = VER.YYYYMMDD
							       )
									AND A.FCST_TYPE NOT IN ('ASF','ETC','RMA','TST','SDF','SMF') -- 'A/S(Free), 기타매출, RMA, Interal Test, Sample(Dev/Free), Sample(Mass/Free) 는 매출 대상 아니므로 제외 
									AND A.MEASURE IN  ('RTF_SYS_RP')
									--AND ( ( A.DIVISION_ID <> '82' AND  A.MEASURE IN  ('RTF_SYS_RP') ) OR ( A.DIVISION_ID = '82' AND A.MEASURE IN ('RTF') ) )
									--AND ( ( A.DIVISION_ID <> '82' AND  A.MEASURE IN  ('RTF_SYS_RP','SalesAmt_KRW') ) OR ( A.DIVISION_ID = '82' AND A.MEASURE IN ('RTF','SalesAmt_KRW') ) )
									AND (A.YYYYMMDD >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,7*27, CONVERT(DATE, CONVERT(CHAR(6), GETDATE(), 112) + '01')),112))
									AND A.YYYYMMDD < @v_plan_start_week_day
									AND LEN(A.SCM_SITE_ID) > 4
									--AND (A.YYYYMMDD >= SUBSTRING(@p_start_yyyymmdd,1,6) + '01' and A.YYYYMMDD <= CONVERT(CHAR(8), DATEADD(DD,30, CONVERT(DATE, SUBSTRING(@p_start_yyyymmdd,1,6) + '01')),112))
									AND A.QTY <> 0 
									*/
									
						) A
				
						LEFT JOIN SCM_MST_SITE_ITEM S2 WITH(NOLOCK)
						ON  A.DIVISION_ID		= S2.DIVISION_ID
						AND A.PROJECT_CODE		= S2.PROJECT_CODE
						AND A.SCM_SITE_ID		= S2.SCM_SITE_ID
						AND A.ITEM_ID			= S2.ITEM_ID
						AND LEN(S2.SALES_COMPANY) > 0 AND LEN(S2.SALES_PLANT) > 0
						AND S2.VALID_YN			= 'Y'
				
						INNER JOIN TH_UIS_CAL_SN CA WITH(NOLOCK)
						ON A.YYYYMMDD           = CA.YYYYMMDD

						LEFT JOIN SCM_MST_SITE_CUSTOMER S3 WITH(NOLOCK)
						ON  A.DIVISION_ID		= S3.DIVISION_ID
						AND A.SCM_SITE_ID		= S3.SCM_SITE_ID
						AND S3.REP_YN           = 'Y'
						AND S3.VALID_YN			= 'Y'
				--WHERE A.ITEM_ID = 'MCF544079A10'
				WHERE  0=0
				  --AND A.scm_site_id = 'Audi_BE_BRU'
				  --and A.item_id = 'AMVAGBEVM-A4-D08'
	            AND   S2.SALES_COMPANY IS NOT NULL -- 13875
	
				GROUP BY A.DIVISION_ID
						,A.PROJECT_CODE
						,A.ITEM_ID
						,A.MEASURE
						,S2.SALES_COMPANY
						,S2.SALES_PLANT
						,A.SCM_SITE_ID
						,A.PLANT_SITE_ID
						,S3.SOLDTO_CODE
						,S3.SHIPTO_CODE
						,CA.ISO_YYYYPW
						,A.YYYYMMDD		
						,A.FCST_TYPE
						,A.INCOTERMS
						,A.DOM_EXP
						,A.RESULT_TYPE
			) A
			/* 1순위 출하 계획 & 출하 실적 기준 */
			/*LEFT HASH JOIN ( SELECT A.DIVISION_ID, A.TO_SITE, A.ITEM_ID, A.COMPANY_ID, SS.LOGISTIC_PLANT_ID AS PLANT_ID
								FROM 
								(
									SELECT A.DIVISION_ID, A.TO_SITE, A.ITEM_ID, CASE WHEN S7.COMPANY_ID IS NOT NULL AND LEN(S7.COMPANY_ID) > 0  THEN S7.COMPANY_ID ELSE NULL END AS COMPANY_ID, A.OPERATION_ID
									FROM (
									SELECT S4.DIVISION_ID, S4.TO_SITE, S4.ITEM_ID, S1.COMPANY_ID, S1.PLANT_ID, S4.BIZ_TYPE AS OPERATION_ID
										FROM [dbo].[SCP_ANL_SHIPMENT_PLAN_FG] S4 WITH(NOLOCK)
										INNER JOIN SCM_MST_SITE S1 WITH(NOLOCK)
										ON (S4.DIVISION_ID		= S1.DIVISION_ID
										AND S4.FROM_SITE		= S1.SCM_SITE_ID
										AND S1.SITE_TYPE        = 'PLANT')
									WHERE S4.DIVISION_ID IN ('40','81','82')
										AND S4.PLAN_TYPE = 'FN'
										AND S4.MEASURE   = 'SHIP_PLAN'
										AND S4.PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd -- 월요일
										--AND S4.TO_SITE = 'Audi_DE_KAS'
										--AND S4.ITEM_ID = 'APAAGIHEV-B4'
									GROUP BY S4.DIVISION_ID, S4.TO_SITE, S4.ITEM_ID, S1.COMPANY_ID, S1.PLANT_ID,  S4.BIZ_TYPE
									UNION ALL
									SELECT DIVISION_ID, TO_SITE, ITEM_ID, COMPANY_ID, PLANT_ID, SUBSTRING(FROM_SITE,CHARINDEX('-',FROM_SITE)+1,1) AS OPERATION_ID 
										FROM [dbo].[SSP_DNM_SHIP_RESULT_ERP_V]
									WHERE DIVISION_ID IN ('40','81','82')
										AND YYYYMMDD BETWEEN CONVERT(VARCHAR, DATEADD(DD,-120,CONVERT(DATE,@v_plan_start_yyyymmdd)),112) -- 과거 4개월 실적
														 AND CONVERT(VARCHAR, DATEADD(DD,-1,CONVERT(DATE,@v_plan_start_yyyymmdd)),112)
										--  AND TO_SITE = 'Audi_DE_KAS'
										--AND ITEM_ID = 'APAAGIHEV-B4'
									GROUP BY DIVISION_ID, TO_SITE, ITEM_ID, COMPANY_ID, PLANT_ID, SUBSTRING(FROM_SITE,CHARINDEX('-',FROM_SITE)+1,1) 
									) A
									INNER JOIN SCM_MST_SITE S7 WITH(NOLOCK)
														ON (A.DIVISION_ID   = S7.DIVISION_ID
														AND A.TO_SITE		= S7.SCM_SITE_ID
														AND S7.SITE_TYPE    = 'SALES'
														AND S7.VALID_YN	    = 'Y'
														)
									GROUP BY A.DIVISION_ID, A.TO_SITE, A.ITEM_ID, CASE WHEN S7.COMPANY_ID IS NOT NULL AND LEN(S7.COMPANY_ID) > 0  THEN S7.COMPANY_ID ELSE NULL END, A.OPERATION_ID
								) A
								LEFT JOIN ( /* 생산 법인 */
											SELECT DIVISION_ID, COMPANY_ID, OPERATION_GROUP,LOGISTIC_PLANT_ID FROM SCM_MST_SITE WITH(NOLOCK)
												WHERE SITE_TYPE = 'PLANT'
												  AND VALID_YN  = 'Y'
												  AND PLANT_ID  <> 'KR001641'
											GROUP BY DIVISION_ID, COMPANY_ID, OPERATION_GROUP,LOGISTIC_PLANT_ID 
											UNION ALL
											/* 판매 법인 */
											SELECT SITE.DIVISION_ID, SITE.COMPANY_ID, OP.OPERATION_GROUP, SITE.PLANT_ID  FROM SCM_MST_SITE SITE (NOLOCK),
											( SELECT 'E' AS OPERATION_GROUP 
											  UNION ALL 
											  SELECT 'A' AS OPERATION_GROUP 
											  UNION ALL
											  SELECT 'P' AS OPERATION_GROUP 
											) OP
											WHERE SITE.SITE_TYPE = 'CORP'
										) SS 
								ON A.DIVISION_ID   = SS.DIVISION_ID
								AND A.COMPANY_ID   = SS.COMPANY_ID
								AND A.OPERATION_ID = SS.OPERATION_GROUP
				) PRI1
			ON   A.DIVISION_ID	= PRI1.DIVISION_ID
			AND  A.ITEM_ID		= PRI1.ITEM_ID
			AND  A.SCM_SITE_ID	= PRI1.TO_SITE
	        */
			/* 2순위 생산 계획 & 실적 기준 */
			/*LEFT HASH JOIN ( 
							SELECT A.DIVISION_ID, A.TOP_ITEM_ID AS ITEM_ID, A.PLANT_ID, SS.COMPANY_ID
							FROM (
									SELECT DIVISION_ID, TOP_ITEM_ID, MAX(PLANT_ID) AS PLANT_ID
									FROM(
											SELECT DIVISION_ID, TOP_ITEM_ID , MAX(PLANT_ID) AS PLANT_ID FROM LGCE_FP_TR.DBO.fp_daily_productioin_plan_h WITH(NOLOCK)
											WHERE PLAN_TYPE = 'RELEASE'
											  AND PLAN_DATE >= CONVERT(DATE,@v_plan_start_yyyymmdd)
											GROUP BY DIVISION_ID, TOP_ITEM_ID
											UNION ALL
											SELECT DIVISION_ID, TOP_ITEM_ID, MAX(PLANT_ID) AS PLANT_ID  from  LGCE_FP_TR.DBO.scm_daily_product_result_h WITH(NOLOCK)
											WHERE PLAN_DATE BETWEEN DATEADD(DD,-120,CONVERT(DATE,@v_plan_start_yyyymmdd)) -- 과거 4개월 실적
																AND DATEADD(DD,-1,CONVERT(DATE,@v_plan_start_yyyymmdd))
											GROUP BY DIVISION_ID, TOP_ITEM_ID 
										) A
										GROUP BY DIVISION_ID, TOP_ITEM_ID
									) A
									LEFT JOIN ( SELECT DIVISION_ID,LOGISTIC_PLANT_ID, COMPANY_ID FROM SCM_MST_SITE WITH(NOLOCK)
												WHERE SITE_TYPE = 'PLANT'
												  AND VALID_YN  = 'Y'
												  AND PLANT_ID <> 'KR001641'
												GROUP BY DIVISION_ID, LOGISTIC_PLANT_ID, COMPANY_ID 
											) SS 
									ON  A.DIVISION_ID    = SS.DIVISION_ID
									AND A.PLANT_ID       = SS.LOGISTIC_PLANT_ID
							) PRI2
			ON  A.DIVISION_ID = PRI2.DIVISION_ID
			AND A.ITEM_ID     = PRI2.ITEM_ID
			*/
			/* 3순위 PROJECT ROUTE 기준 */
			/*LEFT JOIN ( SELECT A.DIVISION_ID, A.SALES_SITE_ID, A.ITEM_ID, SS.COMPANY_ID, SS.LOGISTIC_PLANT_ID AS PLANT_ID
						FROM 
						(
							SELECT DIVISION_ID, SALES_SITE_ID, ITEM_ID, MAX(PLANT_SITE_ID) AS PLANT_SITE_ID FROM SCM_MST_SITE_ITEM_PRIORITY (NOLOCK)
								WHERE DIVISION_ID IN ('81')
								--AND VALID_YN = 'Y'
								AND PRIORITY = '1'
								AND SALES_SITE_ID <> '-'
								GROUP BY DIVISION_ID, SALES_SITE_ID, ITEM_ID   -- 자동차만 SALES SITE ID 관리를 해서 UNION 절로 구분해 준다.
								UNION ALL
								SELECT DIVISION_ID, NULL SALES_SITE_ID, ITEM_ID, MAX(PLANT_SITE_ID) AS PLANT_SITE_ID FROM SCM_MST_SITE_ITEM_PRIORITY (NOLOCK)
								WHERE DIVISION_ID IN ('40','82')
								-- AND VALID_YN = 'Y'
								AND PRIORITY = '1'
							GROUP BY DIVISION_ID, ITEM_ID 
						) A
						LEFT JOIN ( SELECT * FROM SCM_MST_SITE WITH(NOLOCK)
									WHERE SITE_TYPE =  'PLANT'
									  AND VALID_YN  =  'Y'
									  AND PLANT_ID  <> 'KR001641'
								  ) SS 
						ON  A.DIVISION_ID    = SS.DIVISION_ID
						AND A.PLANT_SITE_ID  = SS.SCM_SITE_ID
					) PRI3
			ON  A.DIVISION_ID   = PRI3.DIVISION_ID
			AND A.SCM_SITE_ID   = CASE WHEN A.DIVISION_ID = '81' THEN PRI3.SALES_SITE_ID ELSE A.SCM_SITE_ID END 
			AND A.ITEM_ID       = PRI3.ITEM_ID
	        */
			/* 4순위 매출의 생산 SITE 기준(자동차만 해당 됨) */
			/*LEFT JOIN ( SELECT * FROM SCM_MST_SITE WITH(NOLOCK)
						WHERE SITE_TYPE = 'PLANT'
						  AND VALID_YN  = 'Y'
						  AND PLANT_ID <> 'KR001641'
					  ) PRI4
			ON  A.DIVISION_ID    = PRI4.DIVISION_ID
			AND A.PLANT_SITE_ID  = PRI4.SCM_SITE_ID
			*/
		GROUP BY A.DIVISION_ID
			  ,A.PROJECT_CODE
			  ,A.ITEM_ID
			  ,A.COMPANY_ID
			  ,A.PLANT_ID
			  --,ISNULL(ISNULL(ISNULL(ISNULL(A.COMPANY_ID,PRI1.COMPANY_ID),PRI2.COMPANY_ID),PRI3.COMPANY_ID),PRI4.COMPANY_ID)	
			  --,ISNULL(ISNULL(ISNULL(ISNULL(A.PLANT_ID,PRI1.PLANT_ID),PRI2.PLANT_ID),PRI3.PLANT_ID),PRI4.PLANT_ID)
			  ,A.SCM_SITE_ID
			  ,A.PLANT_SITE_ID
			  ,A.SOLDTO_CODE
			  ,A.SHIPTO_CODE
			  ,A.YYYYPW
			  ,A.FCST_TYPE
			  ,A.INCOTERMS
			  ,A.DOM_EXP
			  ,A.YYYYMM
			  ,A.YYYYMMDD
			  ,A.RESULT_TYPE
		) A
		/* 평가 클래스 JOIN 을 위함 */
		INNER HASH JOIN ( SELECT DIVISION_ID, ITEM_ID, MAX(ITEM_TYPE) AS ITEM_TYPE, MAX(ITEM_UOM) AS ITEM_UOM 
						FROM SCM_MST_ITEM_SN B WITH(NOLOCK)
					WHERE ITEM_TYPE  IN ('R','H','P','Q')
					  AND ACTIVE_FLAG = 'Y'
					GROUP BY DIVISION_ID, ITEM_ID ) IT
			ON A.DIVISION_ID        = IT.DIVISION_ID
			AND A.ITEM_ID           = IT.ITEM_ID
		LEFT OUTER HASH JOIN (  
							SELECT a.division_id, A.PROJECT_CODE, a.scm_site_id, A.PLANT_SITE_ID, 
								   a.item_id, A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, CA.ISO_YYYYPW YYYYPW, a.currency, a.measure
								  ,MAX(a.price) AS price
							FROM SCM_MST_FUTURE_PRICE_C A WITH(NOLOCK)
								 INNER JOIN ( SELECT DIVISION_ID, VERSION_NO, VERSION_TYPE, YYYYMMDD
													FROM (
															SELECT DIVISION_ID, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, YYYYMMDD, VER_CRE_SEQ, 
																	ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY YYYYMMDD DESC, VER_CRE_SEQ DESC) SEQ FROM DM_MST_VERSION
															WHERE VERSION_TYPE = 'SP_W'
															 --AND  YYYYMMDD IN ('20210304','20210305')
																--AND DIVISION_ID IN ('81')
													) VER
													WHERE VER.SEQ = 1
													/*
												  --AND 1=0 
												UNION ALL 
												SELECT '40', 'SP_W_20201127_V001' AS VERSION_NO, 'SP_W' AS VERSION_TYPE, '20201127' AS YYYYMMDD
												--UNION ALL 
												--SELECT '81', 'SP_W_20201008_V001' AS VERSION_NO, 'SP_W' AS VERSION_TYPE, '20201008' AS YYYYMMDD
												UNION ALL 
												SELECT '82', 'SP_M_20201204_V001' AS VERSION_NO, 'SP_M' AS VERSION_TYPE, '20201204' AS YYYYMMDD
												*/
											) VER
									ON A.DIVISION_ID      = VER.DIVISION_ID
									AND A.VERSION_NO      = VER.VERSION_NO
									AND A.CUTOFF_TYPE     = VER.VERSION_TYPE
									AND A.CUTOFF_YYYYMMDD = VER.YYYYMMDD
								INNER JOIN (						 
											SELECT p.division_id, p.PROJECT_CODE, p.scm_site_id,p.PLANT_SITE_ID, p.item_id, p.FCST_TYPE, p.INCOTERMS, p.DOM_EXP, p.yyyymmdd , p.measure
												  ,MAX(p.currency) AS currency
											FROM   scm_mst_future_price P WITH(NOLOCK)
												   inner join scm_mst_division dm with(nolock) -- 2023.03.30 HM JV 가상 사업부 추가 대응
														   on dm.division_id = p.division_id 
														  and dm.attribute3 != 'EE' 
														  and dm.valid_yn	 = 'Y'

                                            -- PJ20216891
											WHERE  1=1 -- 2023.03.30 p.DIVISION_ID IN ('40', '81', '81_UC', '82')
											-- WHERE  DIVISION_ID IN ('40', '81', '82')
											--AND    PRI.yyyymmdd >=  @v_plan_start_yyyymmdd -- 월요일
											/* 실적 구간 존재가능하므로 과거 3주 판가를 본다 */
											AND    p.YYYYMMDD BETWEEN CONVERT(VARCHAR, DATEADD(DD,-7*2,CONVERT(DATE,@v_plan_start_yyyymmdd)),112)    
																--AND CONVERT(VARCHAR, DATEADD(DD, 7*27,CONVERT(DATE,@v_plan_start_yyyymmdd)),112) 
																AND CONVERT(VARCHAR, DATEADD(DD, 7*43,CONVERT(DATE,@v_plan_start_yyyymmdd)),112) 
											AND    p.measure      = 'LOC'
											--and    division_id = '40'
											--and    scm_site_id = 'Audi_BE_BRU'
											--and item_id = 'AMVAGBEVM-A4-D08'
											--and pri.yyyymmdd between '20200727' and '20200802'
											GROUP BY p.division_id, p.PROJECT_CODE, p.scm_site_id,p.PLANT_SITE_ID, p.item_id, p.FCST_TYPE, p.INCOTERMS, p.DOM_EXP, p.yyyymmdd , p.measure
											) b
								ON  a.division_id  = b.division_id
								AND A.PROJECT_CODE = B.PROJECT_CODE
								AND a.scm_site_id  = b.scm_site_id
								AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
								AND a.item_id      = b.item_id
								AND A.FCST_TYPE    = B.FCST_TYPE
								AND A.INCOTERMS    = B.INCOTERMS
								AND A.DOM_EXP      = B.DOM_EXP
								AND a.yyyymmdd     = b.yyyymmdd
								AND a.currency     = b.currency
								AND a.measure      = b.measure

								INNER JOIN TH_UIS_CAL_SN CA WITH(NOLOCK)
								ON a.YYYYMMDD           = CA.YYYYMMDD
							-- 판가 일자 중복 방지
							/*
                            WHERE  A.YYYYMMDD >= @v_plan_start_week_day     
							*/          
							--
							GROUP BY a.division_id, A.PROJECT_CODE, a.scm_site_id, A.PLANT_SITE_ID,  
									 a.item_id, A.FCST_TYPE, A.INCOTERMS, A.DOM_EXP, CA.ISO_YYYYPW, a.currency, a.measure
                            /*
							UNION ALL
							-- 과거 매출 실적 구간 판가
							SELECT division_id, PROJECT_CODE, scm_site_id, PLANT_SITE_ID, item_id, FCST_TYPE, INCOTERMS, DOM_EXP,  CA.ISO_YYYYPW YYYYPW , measure
								  ,currency AS currency
								  ,MAX(PRI.price) AS price
							FROM   scm_mst_future_price PRI WITH(NOLOCK)
											INNER JOIN TH_UIS_CAL_SN CA WITH(NOLOCK)
											ON PRI.YYYYMMDD           = CA.YYYYMMDD
							WHERE  DIVISION_ID IN ('40', '81', '82')
							--AND    PRI.yyyymmdd >=  @v_plan_start_yyyymmdd -- 월요일
							AND    measure      = 'LOC'
							--and    division_id = '40'
							--and    scm_site_id = 'Audi_BE_BRU'
							--and item_id = 'AMVAGBEVM-A4-D08'
							--and pri.yyyymmdd between '20200727' and '20200802'
								AND PRI.YYYYMMDD >= CONVERT(CHAR(6), GETDATE(), 112) + '01' and PRI.YYYYMMDD  < @v_plan_start_week_day
							GROUP BY division_id, PROJECT_CODE, scm_site_id, PLANT_SITE_ID , item_id, FCST_TYPE, INCOTERMS, DOM_EXP, CA.ISO_YYYYPW, measure, CURRENCY
							*/
						) PRI
				ON  A.DIVISION_ID    = PRI.DIVISION_ID
				AND A.PROJECT_CODE   = PRI.PROJECT_CODE
				--AND A.PROJECT_CODE = CASE WHEN A.DIVISION_ID <> '40' THEN PRI.PROJECT_CODE ELSE A.PROJECT_CODE END
				AND A.SCM_SITE_ID    = PRI.SCM_SITE_ID
				
                -- PJ20216891
				-- 2023.03.30 AND A.PLANT_SITE_ID  = CASE WHEN A.DIVISION_ID IN ('81', '81_UC')  -- 자동차만 FCST 부터 PLANT_SITE_ID 포함하여 관리됨
				AND A.PLANT_SITE_ID  = CASE WHEN EXISTS (SELECT 1  
														  FROM SCM_MST_DIVISION DM WITH(NOLOCK)  -- 2023.03.30 HM JV 가상 사업부 추가 대응
														 WHERE DM.DIVISION_ID = A.DIVISION_ID 
														   AND DM.ATTRIBUTE3  = '81' -- 자동차만 FCST 부터 PLANT_SITE_ID 포함하여 관리됨
														   AND DM.VALID_YN	  = 'Y'
														  )
										    THEN PRI.PLANT_SITE_ID 
											ELSE A.PLANT_SITE_ID 
									   END 
				-- AND A.PLANT_SITE_ID  = CASE WHEN A.DIVISION_ID = '81' THEN PRI.PLANT_SITE_ID ELSE A.PLANT_SITE_ID END -- 자동차만 FCST 부터 PLANT_SITE_ID 포함하여 관리됨
				AND A.YYYYPW         = PRI.YYYYPW
				AND A.FCST_TYPE      = PRI.FCST_TYPE
				AND A.INCOTERMS      = PRI.INCOTERMS
				AND A.ITEM_ID        = PRI.ITEM_ID
				AND A.DOM_EXP        = PRI.DOM_EXP 


	    /*
		UPDATE XIF_SCP_MOVE_SALES_PLAN_RP_SN
		   SET gcs_transf_flag = 'Y'
		 WHERE WORK_YYYYMMDD = @v_work_yyyymmdd
        */

    /** 연결 거래 매출 END **/
	   ;

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'연결 거래 매출 Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 과거 정보 삭제
        -----------------------------------------------------------
		DELETE XIF_SCP_MOVE_SALES_PLAN_RP_SN 
         WHERE work_yyyymmdd < @v_plan_delete_yyyymmdd ;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'DELETE '+ @v_table_id ;
        SET @v_description = N'Delete Complete...' + ':' + @v_plan_delete_yyyymmdd;
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      END;

    END TRY

    BEGIN CATCH
        
   --   IF @@TRANCOUNT > 0 
   --     BEGIN
   --       ROLLBACK;
   --     END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH  @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    return 1  


  END;
