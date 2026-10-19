

/*
 * Program ID   : PR_SCP_IF_GCS_MOVE_PROD_PLAN 

 ***************** => 2025.01.20 주차부터 BPS 사용 안 함으로 수행 중지함 

 * Description  : GCS 생산계획 전송
 *                매주 특정 시점에 일괄 생성
 *                동일 work_yyyymmdd 존재 시 work_yyyymmdd = MAX(work_yyyymmdd) + 1 로 생성 : 중복 방지
 *                각 사업부별 Final Plan 완료 시 생성된 정보로 생성
 *
 *                0. 기본 전제
 *                  - MKT FCST 기준 유상 매출만 대상으로 함.	FCST_TYPE 중 ('ASF','ETC','RMA','TST','SDF','SMF') 은 제외 함
 *                  - Unpegging된 확정 생산 계획	계획 전송 제외
 *                
 *                1. Pack 생산 : OSP 포함하여 계획 전체 전송
 *                2. Cell 생산
 *                  - Cell Demand
 *                   . 자동차/ESS - 전체 조립 계획 전송
 *                   . 소형 - 전체 조립 계획 전송 : TCO Demand 인 경우 TCO 계획 전송
 *                  - Pack Demand
 *                   . 자동차 : 조립 Company와 Pack Company가 다른 경우에만 전송
 *                   . 소형 : Nexcon Packer로 출하되는 조립 계획만 전송 : TCO Item 없음
 *                3. 전극 생산
 *                  - 전극 Demand : 전극 Demand에 Pegging 된 계획 전체 전송
 *                  - Cell Demand : 전극과 조립의 Company 가 다른 경우 전송
 *
 * OutTable     :
 * Execute      : EXEC PR_SCP_IF_GCS_MOVE_PROD_PLAN
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2020.09.02   KSG            Initial Release C20200901-000244 [경영관리PI]전지 GSCM.SCP 생산계획 → ChemPION 이동계획 I/F 요청 
 * 2020.12.08   KSG            C20201203-000215 SCP → Chempion 생산 계획 I/F 개발 건 : 전체 로직 재구축
 * 2021.02.25   HJS            전극 계획 Plant 정보 → 조립 Plant로 변경하는 로직 추가. 
 * 2021.04.21   HJS            재고 정보 I/F 로직 추가.
 * 2022.04.18   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응

 *
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_IF_GCS_MOVE_PROD_PLAN]
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
    DECLARE @v_program_name  NVARCHAR(150) = N'PR_SCP_IF_GCS_MOVE_PROD_PLAN';
    DECLARE @v_log_type      NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count_t   INTEGER = 0;
    DECLARE @n_log_count     INTEGER = 0;
    DECLARE @v_log_message   NVARCHAR(1000);
    DECLARE @v_description   NVARCHAR(500);      
    DECLARE @v_table_id      NVARCHAR(150) = N'XIF_GCS_MOVE_PROD_PLAN_S_SN'; 
    DECLARE @d_event_date    DATETIME;
   
    DECLARE @v_plan_start_yyyymmdd  NVARCHAR(8);
    DECLARE @v_plan_delete_yyyymmdd NVARCHAR(8);
    DECLARE @d_gcs_trans_date       DATETIME;
	
    -- PJ20216891
    DECLARE @v_tb_target_division TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division
	-- 2023.03.30 HM JV 가상 사업부 추가 대응
	SELECT DIVISION_ID
	  FROM SCM_MST_DIVISION WITH(NOLOCK)
	 WHERE ATTRIBUTE3 = '81' 
	   AND VALID_YN	  = 'Y'
    -- 2023.03.30 SELECT '81' DIVISION_ID UNION ALL
    -- 2023.03.30 SELECT '81_UC' DIVISION_ID;
	
    DECLARE @v_tb_target_division1 TABLE
    (
       DIVISION_ID NVARCHAR(30)
    );

    INSERT INTO @v_tb_target_division1
	-- 2023.03.30 HM JV 가상 사업부 추가 대응
	SELECT DIVISION_ID
	  FROM SCM_MST_DIVISION WITH(NOLOCK)
	 WHERE ATTRIBUTE3 = 'EE' 
	   AND VALID_YN	  = 'Y'
	-- 2023.03.30 SELECT 'EE' DIVISION_ID UNION ALL
    -- 2023.03.30 SELECT 'EE_UC' DIVISION_ID;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH    @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    
    BEGIN TRY
      BEGIN
    
     --   BEGIN TRANSACTION; 
	    SET @v_plan_start_yyyymmdd  = ISNULL(@p_start_yyyymmdd, CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) ;
	    SET @v_plan_delete_yyyymmdd = CONVERT(CHAR(8), DATEADD(DD, -7*8, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) ; -- 8주 지난 정보 삭제
		SET @d_gcs_trans_date       = GETDATE();

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
          FROM XIF_GCS_MOVE_PROD_PLAN_S_SN WITH(NOLOCK)
         WHERE work_yyyymmdd = @v_work_yyyymmdd ;

		-- 동일 work_yyyymmdd 존재 시 work_yyyymmdd = MAX(work_yyyymmdd) + 1 로 생성 : 중복 방지
        IF @v_work_yyyymmdd = @v_work_yyyymmdd_e
        BEGIN
          SELECT TOP 1 @v_work_yyyymmdd_t = CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT(DATE, MAX(work_yyyymmdd))), 112)  
            FROM XIF_GCS_MOVE_PROD_PLAN_S_SN WITH(NOLOCK)
           WHERE work_yyyymmdd >= @v_work_yyyymmdd ;

		  SET @v_work_yyyymmdd = @v_work_yyyymmdd_t;

        END -- IF @v_work_yyyymmdd = @v_work_yyyymmdd_e

        ----------------------------------------------------------- 
        -- 0. 최종 IF 대상 정보 저장용 Temp Table
        ----------------------------------------------------------- 
        IF OBJECT_ID('tempdb..#PROD_PLAN_INFO') IS NOT NULL
        DROP TABLE #PROD_PLAN_INFO
		
        ----------------------------------------------------------- 
        -- 1. 사업부 기초 SQL : Temp Table 생성 후 처리
        ----------------------------------------------------------- 		
        IF OBJECT_ID('tempdb..#PEGGING_INFO') IS NOT NULL
        DROP TABLE #PEGGING_INFO
		
        ----------------------------------------------------------- 
		-- 1.1 사업부용 전체 Temp 정보 생성
        ----------------------------------------------------------- 
        SELECT division_id, plan_start_yyyymmdd, plan_type, seq
             , demand_operation_group, pegging_operation_code, origin_division_id
             , eng_demand_id, fcst_type, demand_item_id
             , item_id, site_id, company_id
             , yyyymmdd, qty
           
        INTO   #PEGGING_INFO
        FROM   SCP_PLN_PEGGING_GCS pe with(nolock) -- Pegging된 생산 계획 대상

        -- PJ20216891
        WHERE  (pe.division_id         IN ( '40', '82' ) OR pe.division_id IN ( SELECT DIVISION_ID FROM @v_tb_target_division ))
        -- WHERE  pe.division_id         IN ( '40', '81', '82' )
        AND    pe.plan_start_yyyymmdd = @v_plan_start_yyyymmdd
        AND    pe.plan_type           = 'FN'
        --AND    pe.seq = '1' -- 주별 최종 FN 기준으로 생성되어 있으므로 조건 제외
        AND    pe.fcst_type IN (SELECT segment1
                                FROM   scm_adm_lookup_master_detail md WITH(NOLOCK)
                                WHERE  md.lookup_type = 'SALES_TYPE_CODE'
                                AND    md.valid_yn    = 'Y'  
                                AND    md.segment1    NOT IN ('ASF','ETC','RMA','TST','SDF','SMF') -- MKT FCST 기준 유상 매출만 대상으로 함
                               )

        ----------------------------------------------------------- 
		-- 1.2 Pack 생산 : OSP 포함하여 계획 전체 전송
        ----------------------------------------------------------- 
        SELECT *
             , '1.2 Pack..................' AS prod_type -- 최초 생성 시 Size 때문에 '..' 추가
        INTO   #PROD_PLAN_INFO
        FROM   #PEGGING_INFO
        WHERE  1=1
        AND    demand_operation_group = 'P'       -- Pack Demand
        AND    pegging_operation_code IN ('PACK') -- Pack 생산계획
        AND    demand_item_id         = item_id   -- Demand Item과 생산 Item이 동일한 경우 - 82 Rack에 연결된 Pack은 제외됨

        SET @n_log_count_t = @@ROWCOUNT;
				
        ----------------------------------------------------------- 
		-- 1.3 Cell 생산 : Cell Demand : 자동차/ESS : 전체 조립 계획 전송
        ----------------------------------------------------------- 
        INSERT INTO #PROD_PLAN_INFO
        SELECT *
             , '1.3 Cell' AS prod_type
        FROM   #PEGGING_INFO
        WHERE  1=1
		
        -- PJ20216891
        AND    (division_id            IN ('82') OR division_id IN ( SELECT DIVISION_ID FROM @v_tb_target_division ))
        -- AND    division_id            IN ('81', '82')
        AND    demand_operation_group = 'A'                -- Cell Demand
        AND    pegging_operation_code IN ('CELL', 'TCELL') -- Cell/TCO Cell 생산계획 - 81/82 TCO Cell 없음
        AND    demand_item_id         = item_id            -- Demand Item과 생산 Item이 동일한 경우

        SET @n_log_count_t = @n_log_count_t + @@ROWCOUNT;
				
        ----------------------------------------------------------- 
		-- 1.4 Cell 생산 : Cell Demand : 소형 : 전체 조립 계획 전송 : TCO Demand 인 경우 TCO 계획 전송
        ----------------------------------------------------------- 
        INSERT INTO #PROD_PLAN_INFO
        SELECT *
             , '1.4 Cell' AS prod_type
        FROM   #PEGGING_INFO
        WHERE  1=1
        AND    division_id            = '40'
        AND    demand_operation_group = 'A'                -- Cell Demand
        AND    pegging_operation_code IN ('CELL', 'TCELL') -- Cell/TCO Cell 생산계획
        AND    demand_item_id         = item_id            -- Demand Item과 생산 Item이 동일한 경우 - 40 TCO Cell에 연결된 Cell은 제외됨

        SET @n_log_count_t = @n_log_count_t + @@ROWCOUNT;
				
        ----------------------------------------------------------- 
		-- 1.5 Cell 생산 : Pack Demand : 자동차 : 조립 Company와 Pack Company가 다른 경우에만 전송
        ----------------------------------------------------------- 
        INSERT INTO #PROD_PLAN_INFO
        SELECT *
             , '1.5 Cell Diff Com' AS prod_type
        FROM   #PEGGING_INFO
        WHERE  1=1
		
        -- PJ20216891
        AND    division_id            IN ( SELECT DIVISION_ID FROM @v_tb_target_division )
        -- AND    division_id            = '81'
        AND    demand_operation_group = 'P'       -- Pack Demand
        AND    pegging_operation_code IN ('CELL') -- Cell 생산계획
        AND    eng_demand_id + company_id
              IN 
              (
               SELECT a.eng_demand_id + a.company_id
               FROM  (
                      SELECT eng_demand_id, company_id
                      FROM   #PEGGING_INFO
                      WHERE  1=1
					  
                      -- PJ20216891
                      AND    division_id            IN ( SELECT DIVISION_ID FROM @v_tb_target_division )
                      -- AND    division_id            = '81'
                      AND    demand_operation_group = 'P'       -- Pack Demand
                      AND    pegging_operation_code IN ('CELL') -- Cell 생산계획

			          EXCEPT

                      SELECT eng_demand_id, company_id
                      FROM   #PEGGING_INFO
                      WHERE  1=1
					  
                      -- PJ20216891
                      AND    division_id            IN ( SELECT DIVISION_ID FROM @v_tb_target_division )
                      -- AND    division_id            = '81'
                      AND    demand_operation_group = 'P'       -- Pack Demand
                      AND    pegging_operation_code IN ('PACK') -- Pack 생산계획
                     ) a
              )

        SET @n_log_count_t = @n_log_count_t + @@ROWCOUNT;
				
        ----------------------------------------------------------- 
		-- 1.6 Cell 생산 : Pack Demand : 소형 : Nexcon Packer로 출하되는 조립 계획만 전송 : TCO Item 없음
        ----------------------------------------------------------- 
        INSERT INTO #PROD_PLAN_INFO
        SELECT *
             , '1.6 Cell Nexcon' AS prod_type
        FROM   #PEGGING_INFO
        WHERE  1=1
        AND    division_id            = '40'
        AND    demand_operation_group = 'P'       -- Pack Demand
        AND    pegging_operation_code IN ('CELL') -- Cell 생산계획
        AND    eng_demand_id
              IN 
              (
               SELECT eng_demand_id
               FROM   #PEGGING_INFO
               WHERE  1=1
               AND    division_id            = '40'
               AND    demand_operation_group = 'P'                -- Pack Demand
               AND    pegging_operation_code IN ('Pack')          -- Pack 생산계획
               AND    site_id                IN ('CN000998_40-P') -- Nexcon
              )

        SET @n_log_count_t = @n_log_count_t + @@ROWCOUNT;

        ----------------------------------------------------------------------------------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @n_log_count_t;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO 사업부';
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------- 
        -- 2. 전극 기초 SQL : Temp Table 생성 후 처리
        ----------------------------------------------------------- 	
		
        IF OBJECT_ID('tempdb..#PEGGING_INFO_EE') IS NOT NULL
        DROP TABLE #PEGGING_INFO_EE
		
        ----------------------------------------------------------- 
		-- 2.1 전극용 전체 Temp 정보 생성
        ----------------------------------------------------------- 
        SELECT division_id, plan_start_yyyymmdd, plan_type, seq
             , demand_operation_group, pegging_operation_code, origin_division_id
             , eng_demand_id, fcst_type, demand_item_id
             , item_id, site_id, company_id
             , yyyymmdd, qty
           
        INTO   #PEGGING_INFO_EE
        FROM   SCP_PLN_PEGGING_GCS pe with(nolock) -- Pegging된 생산 계획 대상
		
        -- PJ20216891
        WHERE  pe.division_id         IN ( SELECT DIVISION_ID FROM @v_tb_target_division1 )
        -- WHERE  pe.division_id         = 'EE'
        AND    pe.plan_start_yyyymmdd = @v_plan_start_yyyymmdd
        AND    pe.plan_type           = 'FN'
        --AND    pe.seq = '1' -- 주별 최종 FN 기준으로 생성되어 있으므로 조건 제외
        AND    pe.pegging_operation_code IN ('ELEC', 'CELL')
        AND    pe.fcst_type IN (SELECT segment1
                                FROM   scm_adm_lookup_master_detail md WITH(NOLOCK)
                                WHERE  md.lookup_type = 'SALES_TYPE_CODE'
                                AND    md.valid_yn    = 'Y'  
                                AND    md.segment1    NOT IN ('ASF','ETC','RMA','TST','SDF','SMF') -- MKT FCST 기준 유상 매출만 대상으로 함
                               )
		
        ----------------------------------------------------------- 
        -- 2.2 전극 생산 : 전극 Demand : 전극 Demand에 Pegging 된 계획 전체 전송
        ----------------------------------------------------------- 
        INSERT INTO #PROD_PLAN_INFO
        SELECT division_id, plan_start_yyyymmdd, plan_type, seq
             , demand_operation_group, pegging_operation_code, origin_division_id
             , eng_demand_id, fcst_type, demand_item_id
             , item_id
			 --, site_id
			 -- 전극 계획 Plant 정보 → 조립 Plant로 변경하는 로직 추가. - 2021.02.25
			 ,  (SELECT TOP 1 SCM_SITE_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
				  WHERE SITE.DIVISION_ID = P.ORIGIN_DIVISION_ID 
				    AND SITE.COMPANY_ID  = ( SELECT TOP 1 company_id 
					   					       FROM SCM_MST_SITE WITH(NOLOCK)
											  WHERE  DIVISION_ID = P.ORIGIN_DIVISION_ID
												AND  scm_site_id = p.SITE_ID )
					AND SITE.SITE_TYPE       = 'PLANT'
					AND SITE.OPERATION_GROUP = 'A'
					AND SITE.OSP_YN         <> 'Y'
					AND SITE.VALID_YN        = 'Y')  AS SITE_ID
			 , company_id
             , yyyymmdd, qty
             , '2.2 Elec' AS prod_type
        FROM   #PEGGING_INFO_EE P
        WHERE  1=1
        AND    demand_operation_group = 'E'       -- Elec Demand
        AND    pegging_operation_code IN ('ELEC') -- ELEC 생산계획

        SET @n_log_count_t = @@ROWCOUNT;

        ----------------------------------------------------------- 
       -- 2.3 전극 생산 : Cell Demand : 전극과 조립의 Company 가 다른 경우 전송
        ----------------------------------------------------------- 
        INSERT INTO #PROD_PLAN_INFO
        SELECT division_id, plan_start_yyyymmdd, plan_type, seq
             , demand_operation_group, pegging_operation_code, origin_division_id
             , eng_demand_id, fcst_type, demand_item_id
             , item_id
			 --, site_id
			 -- 전극 계획 Plant 정보 → 조립 Plant로 변경하는 로직 추가. - 2021.02.25
			 ,  (SELECT TOP 1 SCM_SITE_ID FROM SCM_MST_SITE SITE WITH(NOLOCK)
				  WHERE SITE.DIVISION_ID = P.ORIGIN_DIVISION_ID 
				    AND SITE.COMPANY_ID  = ( SELECT TOP 1 company_id 
					   					       FROM SCM_MST_SITE WITH(NOLOCK)
											  WHERE  DIVISION_ID = P.ORIGIN_DIVISION_ID
												AND  scm_site_id = p.SITE_ID )
					AND SITE.SITE_TYPE       = 'PLANT'
					AND SITE.OPERATION_GROUP = 'A'
					AND SITE.OSP_YN         <> 'Y'
					AND SITE.VALID_YN        = 'Y')  AS SITE_ID
			 , company_id
             , yyyymmdd, qty
             , '2.3 Elec Diff Com' AS prod_type
        FROM   #PEGGING_INFO_EE P
        WHERE  1=1
        AND    demand_operation_group = 'A'       -- Cell Demand
        AND    pegging_operation_code IN ('ELEC') -- ELEC 생산계획
        AND    eng_demand_id + company_id
              IN 
              (
               SELECT a.eng_demand_id + a.company_id
               FROM  (
                      SELECT eng_demand_id, company_id
                      FROM   #PEGGING_INFO_EE
                      WHERE  1=1
                      AND    demand_operation_group = 'A'       -- Cell Demand
                      AND    pegging_operation_code IN ('ELEC') -- ELEC 생산계획

			          EXCEPT

                      SELECT eng_demand_id, company_id
                      FROM   #PEGGING_INFO_EE
                      WHERE  1=1
                      AND    demand_operation_group = 'A'       -- Cell Demand
                      AND    pegging_operation_code IN ('CELL') -- Cell 생산계획
                     ) a
              )

        SET @n_log_count_t = @n_log_count_t + @@ROWCOUNT;

        ----------------------------------------------------------------------------------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @n_log_count_t;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO : 전극';
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- * interface data creation : 위 로직 확정 후 아래 최종 Insert 변경할 것
        -----------------------------------------------------------        

        INSERT INTO XIF_GCS_MOVE_PROD_PLAN_S_SN
                ( WORK_YYYYMMDD, PLN_PERIOD_YYYYMM, OVSENTT_CD, DIV_ID, PLN_YYYYMM, PLNT_CD
                , MDL_CD, VLTN_CLSS_CD, PARENT_MTL_NO, PARENT_PRD_QTY, PARENT_UNIT_CD
				, CREATION_DATE, LAST_UPD_DATE, ETL_LOAD_DATE, GCS_TRANSF_FLAG, GCS_TRANSF_DATE
				, ATTRIBUTE1_VALUE -- 송신시스템 코드
				, ATTRIBUTE20_VALUE -- SCP 내부 참고용
                )
        SELECT @v_work_yyyymmdd                  AS WORK_YYYYMMDD
			 , SUBSTRING(@v_work_yyyymmdd, 1, 6) AS PLN_PERIOD_YYYYMM -- 실행일자 기준 : PI 요청
			 , s.company_id                      AS OVSENTT_CD
			 , p.division_id                     AS DIV_ID -- Plan 기준 사업부 : EE 포함
			 , SUBSTRING(p.yyyymmdd, 1, 6)       AS PLN_YYYYMM

			 -- OSP 여부에 따라 선택
			 , ISNULL(CASE WHEN s.osp_yn = 'Y' THEN s.logistic_plant_id
                           ELSE s.plant_id 
                      END
                    , s.plant_id
                     )                          AS PLNT_CD

             , p.item_id                        AS MDL_CD
			 , NULL                             AS VLTN_CLSS_CD
			 , p.item_id                        AS PARENT_MTL_NO
			 , SUM(ISNULL(p.qty, 0))            AS PARENT_PRD_QTY
			 , MAX(i.item_uom)                  AS PARENT_UNIT_CD

			 , GETDATE()   AS CREATION_DATE
			 , GETDATE()   AS LAST_UPD_DATE
			 , GETDATE()   AS ETL_LOAD_DATE
			 , 'N'         AS GCS_TRANSF_FLAG
			 , GETDATE()   AS GCS_TRANSF_DATE
			 , 'GSCM_T4'   AS ATTRIBUTE1_VALUE -- 송신시스템 코드
			 , prod_type   AS ATTRIBUTE20_VALUE -- SCP 내부 참고용
         FROM #PROD_PLAN_INFO p

			LEFT OUTER JOIN SCM_MST_SITE s WITH(NOLOCK)
			ON  p.origin_division_id = s.division_id -- EE 가 아닌 원래 사업부
			AND p.site_id            = s.scm_site_id
			AND s.site_type          = 'PLANT'
			AND s.valid_yn           = 'Y'
			--AND s.osp_yn             = 'N'
			
			-- Temp Table의 company ID는 변형 것이므로 SCM_MST_SITE 정보로 Join
			LEFT OUTER JOIN SCM_MST_ITEM_SN i WITH(NOLOCK)
			ON  p.origin_division_id = i.division_id -- EE 가 아닌 원래 사업부
			AND s.company_id         = i.company_id
			AND p.item_id            = i.item_id

         WHERE 1=1
		 GROUP BY s.company_id, p.division_id, SUBSTRING(p.yyyymmdd, 1, 6)
                , s.plant_id, s.osp_yn, s.logistic_plant_id, p.item_id
                , prod_type
       ;


        ----------------------------------------------------------- 
        -- * 재고 정보 생성
        -----------------------------------------------------------        
	
        INSERT INTO XIF_GCS_MOVE_PROD_PLAN_S_SN
                ( WORK_YYYYMMDD, PLN_PERIOD_YYYYMM, OVSENTT_CD, DIV_ID, PLN_YYYYMM, PLNT_CD
                , MDL_CD, VLTN_CLSS_CD, PARENT_MTL_NO, PARENT_PRD_QTY, PARENT_UNIT_CD
				, CREATION_DATE, LAST_UPD_DATE, ETL_LOAD_DATE, GCS_TRANSF_FLAG, GCS_TRANSF_DATE
				, ATTRIBUTE1_VALUE -- 송신시스템 코드
				, ATTRIBUTE20_VALUE -- SCP 내부 참고용
				, BOM_LVL_CD        -- 재고 구분자
                )

	   
		-- 공장별 재고
		SELECT @v_work_yyyymmdd                  AS WORK_YYYYMMDD
			 , SUBSTRING(@v_work_yyyymmdd, 1, 6) AS PLN_PERIOD_YYYYMM -- 실행일자 기준 : PI 요청
			 , A.company_id                      AS OVSENTT_CD
			 , A.division_id                     AS DIV_ID -- Plan 기준 사업부 : EE 포함
			 , SUBSTRING(@v_work_yyyymmdd, 1, 6) AS PLN_YYYYMM

			 -- OSP 여부에 따라 선택
			 , A.PLANT_ID                       AS PLNT_CD

			 , A.item_id                        AS MDL_CD
			 , NULL                             AS VLTN_CLSS_CD
			 , A.item_id                        AS PARENT_MTL_NO
			 , SUM(ISNULL(A.QTY, 0))            AS PARENT_PRD_QTY
			 , MAX(A.QTY_UOM)                   AS PARENT_UNIT_CD
			 , GETDATE()                        AS CREATION_DATE
			 , GETDATE()                        AS LAST_UPD_DATE
			 , GETDATE()                        AS ETL_LOAD_DATE
			 , 'N'                              AS GCS_TRANSF_FLAG
			 , GETDATE()                        AS GCS_TRANSF_DATE
			 , 'GSCM_T4'                        AS ATTRIBUTE1_VALUE -- 송신시스템 코드
			 , '2.1 Stock'                      AS ATTRIBUTE20_VALUE -- SCP 내부 참고용
			 , 'INV'                            AS BOM_LVL_CD
		FROM   (
				SELECT A.company_id , A.division_id , A.PLANT_ID, A.item_id, A.SCM_QTY AS QTY, A.QTY_UOM
				FROM   SCM_DNM_STOCK A WITH(NOLOCK)
				WHERE  A.CUTOFF_DATE = CONVERT(NVARCHAR(8), CONVERT(DATETIME, @v_plan_start_yyyymmdd) - 1, 112)
				AND    A.SCM_SITE_ID IS NOT NULL
				AND    A.STOCK_TYPE <> 'SUPPLY'
				AND    A.SCM_QTY     > 0
				UNION  ALL
				SELECT A.company_id , A.division_id , A.PLANT_ID, A.item_id, A.QTY, A.QTY_UOM
				FROM   SCM_DNM_STOCK_AGING_V A WITH(NOLOCK)
				WHERE  A.CUTOFF_DATE = CONVERT(NVARCHAR(8), CONVERT(DATETIME, @v_plan_start_yyyymmdd) - 1, 112)
			   ) A
			 , (
				SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID
				FROM   SCM_MST_FINAL_ITEM_V WITH(NOLOCK)
			   ) B
			 , (
				SELECT DISTINCT DIVISION_ID, PLANT_ID
				FROM   SCM_MST_SITE
				WHERE  SITE_TYPE = 'PLANT'
				AND    OPERATION_GROUP IN ('A', 'P', 'E')
				AND    OSP_YN = 'N'
			   ) C
		WHERE  A.DIVISION_ID = B.DIVISION_ID
		AND    A.ITEM_ID     = B.ITEM_ID
		AND    A.DIVISION_ID = C.DIVISION_ID
		AND    A.PLANT_ID    = C.PLANT_ID
		GROUP  BY A.company_id , A.division_id , A.PLANT_ID, A.item_id ;


        SET @n_log_count = @@ROWCOUNT;
	   
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------
        IF OBJECT_ID('tempdb..#PROD_PLAN_INFO') IS NOT NULL
        DROP TABLE #PROD_PLAN_INFO

        IF OBJECT_ID('tempdb..#PEGGING_INFO') IS NOT NULL
        DROP TABLE #PEGGING_INFO
		
        IF OBJECT_ID('tempdb..#PEGGING_INFO_EE') IS NOT NULL
        DROP TABLE #PEGGING_INFO_EE

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------
        -- TXN LOG
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        -----------------------------------------------------------
        -- 과거 정보 삭제
        -----------------------------------------------------------
		DELETE XIF_GCS_MOVE_PROD_PLAN_S_SN 
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
