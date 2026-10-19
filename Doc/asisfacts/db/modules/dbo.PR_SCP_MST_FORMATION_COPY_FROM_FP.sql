

/*
 * Program ID   : PR_SCP_MST_FORMATION_COPY_FROM_FP
 * Description  : CREATE DEFAULT FORMATION FROM FP NEXT MONTH DATA
 * OutTable     :
 * Execute      : 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.04.11   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.31   KSG            활성화 LT 처리 수정
 * 2018.06.18   KSG            활성화 LT 처리 수정 : Delete Insert 에서 Update/Insert 로 
 * 2018.06.19   KSG            Default Yield 처리 수정 
 * 2018.07.23   KSG            우선 순위 조정 : Pilot Line 은 후순위로 처리
 * 2018.08.08   yydok          대상item에서 item master미존재 및 모델기준 셀(item id 2번째=C)이 아닌것제외,TCO/DSF/TAPED CELL은 제외
 * 2018.08.22   KSG            Formation L/T 올림 처리
 * 2018.11.13   KSG            공정 수율적용(해당공정 하드코딩을 lookup 테이블조회로 변경)
 * 2019.04.08   KSG            [전지고도화]특성 수율 별도 처리 : 활성화 수율 IF 시 조정 필요
 * 2019.04.23   KSG            [CSR ID:3979414] [요청] Formation L/T Default 값 TCO Cell로 분류된 것은 14일 -> 0일로 변경 요청 : 소형 TCO Model은 DEFALUT 활성화 LT = 0 처리
 * 2021.03.15   KSG            PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Yield Table 변경
 * 2023.06.02   KSG            PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화 대응 
 * 2023.09.11   KSG            E20230908-001596 활성화 코드분기 이후 SCP Formation 수율LT 기준정보 Cell Assembly만 표기 : CA1 만 생성 후 CP 는 CA1 기준으로 Copy
 * 2024.02.22   KSG            E20240214-000646 [공급 SCM PI팀] Formation 화면 데이터 소형사업부 업데이트 중단 요청
 *                               최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
 * 2024.05.10   KSG            E20240509-001232 SCM FORMATION LT 산출기준 변경
 * 2025.05.09   kimcd          PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *                             E20250403-001452 자동차 사업부 실적기반 Formation L/T 정보 업데이트 중지
 *                               - 81, 81_HM, 81_ST 의 경우 Formation L/T 갱신에서 제외 하도록 수정
 *                               - 자동차 변경과 같은 기준으로 소형도 수율은 갱신되도록 수정
 * 2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
 *                               소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
 *                               활성화 관련 반제품은 Cell Assy로 변환
 * 2025.10.28   hrkim		   [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_MST_FORMATION_COPY_FROM_FP]
    ( @p_division_id         NVARCHAR(30)
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET     @v_batch_user = 'SCP'
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_MST_FORMATION_COPY_FROM_FP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_MST_FORMATION'; 
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_MST_FORMATION INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;
       
    BEGIN TRY
      BEGIN
    
        BEGIN TRANSACTION; 

        ----------------------------------------------------------- 
        -- 1. SCP_MST_FORMATION 삭제 : 2018.06.18 Default 만 삭제
        ----------------------------------------------------------- 
        DELETE FROM SCP_MST_FORMATION
        WHERE 1=1
        AND   division_id     = @p_division_id
        AND   last_updated_by = 'DEFAULT';

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'DELETE DEFAULT '+@v_table_id;
        SET @v_description = N'DEFAULT...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        ----------------------------------------------------------- 
        -- * LT 정보 : Pilot 라인용 Temp
        -----------------------------------------------------------   		
		IF OBJECT_ID('tempdb..#scp_mst_formation_pilot') IS NOT NULL
        DROP TABLE #scp_mst_formation_pilot
		
        -- 20240510 E20240509-001232 SCM FORMATION LT 산출기준 변경
        --    소형 - 현행 유지
        --    자동차/ESS - default_route = 'Y' 이고, ROUTE_TYPE 'D'이고, ROUTE_TOTAL_TIME에 값이 있는 것만 조회해서 
        --                 ROUTE_TYPE 'D'인 라우트에서 ROUTE_TOTAL_TIME까지 합산
        SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, a.scm_site_id
             , a.standard_lt_min, a.standard_lt_day
        INTO   #scp_mst_formation_pilot
		FROM (  -- 소형은 기존 로직 유지
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, a.plant_id + '-A' AS scm_site_id
					 , SUM(ISNULL(a.standard_lt, 0))           AS standard_lt_min
					 , SUM(ISNULL(a.standard_lt, 0)) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)   
               
					   -- 20230602  PJ20230691  활성화 대응 
					   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND a.item_id          = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
			   
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id     = '40' -- 소형은 기존 로직 유지
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거

				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id 
				UNION -- 자동차/ESS
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, a.plant_id + '-A' AS scm_site_id				
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0)))           AS standard_lt_min
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0))) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)   
               
					   -- 20230602  PJ20230691  활성화 대응 
					   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND a.item_id          = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
			   
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id    <> '40' -- 소형 외
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거
					   AND  a.route_Type      = 'D'              -- 소형 외 조건 추가
					   AND  ISNULL(a.route_total_time, -99) >= 0 -- 소형 외 조건 추가

				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id 
		
		) a;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'UPDATE '+@v_table_id;
        SET @v_description = N'Temp DB : Pilot...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------- 
        -- * LT 정보 : 정상 라인용 Temp
        -----------------------------------------------------------   		
		IF OBJECT_ID('tempdb..#scp_mst_formation_line') IS NOT NULL
        DROP TABLE #scp_mst_formation_line
		
        -- 20240510 E20240509-001232 SCM FORMATION LT 산출기준 변경
        --    소형 - 현행 유지
        --    자동차/ESS - default_route = 'Y' 이고, ROUTE_TYPE 'D'이고, ROUTE_TOTAL_TIME에 값이 있는 것만 조회해서 
        --                 ROUTE_TYPE 'D'인 라우트에서 ROUTE_TOTAL_TIME까지 합산
        SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, a.scm_site_id
             , a.standard_lt_min, a.standard_lt_day
        INTO   #scp_mst_formation_line
		FROM (  -- 소형은 기존 로직 유지
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, a.plant_id + '-A' AS scm_site_id
					 , SUM(ISNULL(a.standard_lt, 0))           AS standard_lt_min
					 , SUM(ISNULL(a.standard_lt, 0)) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)   
               
					   -- 20230602  PJ20230691  활성화 대응 
					   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND a.item_id          = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
			   
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id     = '40' -- 소형은 기존 로직 유지
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) <> 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거

				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id 
				UNION -- 자동차/ESS
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id, a.plant_id + '-A' AS scm_site_id				
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0)))           AS standard_lt_min
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0))) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)   
               
					   -- 20230602  PJ20230691  활성화 대응 
					   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND a.item_id          = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
			   
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id    <> '40' -- 소형 외
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) <> 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거
					   AND  a.route_Type      = 'D'              -- 소형 외 조건 추가
					   AND  ISNULL(a.route_total_time, -99) >= 0 -- 소형 외 조건 추가

				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, a.item_id, a.line_id 
		
		) a;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'UPDATE '+@v_table_id;
        SET @v_description = N'Temp DB : Line...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 2-1. SCP_MST_FORMATION : UPDATE : Pilot 라인 
        --      동일한 Site/Item 에 대하여 정상 라인 정보가 존재하면 2-2 에서 정상 라인 정보로 Update 됨
	    --      20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
        -----------------------------------------------------------    
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
        FROM       
             (SELECT DISTINCT b.division_id
                   , b.scm_site_id 
                   , b.item_id
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
              FROM  #scp_mst_formation_pilot b
			  -- 20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
			  WHERE  1 = 1  -- b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                                      -- 81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거
              GROUP BY b.division_id, b.scm_site_id, b.item_id
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                                 
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month       
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                                                  
           ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.item_id     = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                      --  , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                --   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.item_id     = ft.item_id

       )
        UPDATE SCP_MST_FORMATION -- attribute1은 설정값 유지 -- 활성화 추가 LT 
           SET lt_formation     = CASE WHEN AA.DIVISION_ID IN ( '81', '81_HM', '81_ST', '40' ) THEN lt_formation ELSE XX.lt END
		                              -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                      -- 81, 81_HM, 81_ST, 40 은 lead time 갱신 제외
		     -- 20190408 특성 수율 별도 처리
             , formation_yield        = ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , char_yield             = ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , formation_total_yield  = ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 
             , last_updated_by  = 'COPY : Pilot'
             , last_update_date = GETDATE()
        FROM   XX,
               SCP_MST_FORMATION AA WITH(NOLOCK)
        WHERE  1=1
        AND    XX.division_id   = AA.division_id
        AND    XX.plant_site_id = AA.plant_site_id
        AND    XX.item_id       = AA.item_id
       ;   

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'UPDATE '+@v_table_id;
        SET @v_description = N'COPY : Pilot...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        ----------------------------------------------------------- 
        -- 2-2. SCP_MST_FORMATION : UPDATE : 정상 라인 - Pilot 라인과 동일한 Site/Item 정보는 정상 라인 정보로 Update 됨
	    --      20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
        -----------------------------------------------------------       		 
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
        FROM       
             (SELECT DISTINCT b.division_id
                   , b.scm_site_id 
                   , b.item_id
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
                   --, FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
              FROM  #scp_mst_formation_line b
			  -- 20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
			  WHERE  1 = 1  -- b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                                      -- 81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거
              GROUP BY b.division_id, b.scm_site_id, b.item_id
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
              --HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month 
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		   ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.item_id     = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                     --   , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                 --  AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.item_id     = ft.item_id

       )
        UPDATE SCP_MST_FORMATION -- attribute1은 설정값 유지 -- 활성화 추가 LT 
           SET lt_formation     = CASE WHEN AA.DIVISION_ID IN ( '81', '81_HM', '81_ST', '40' ) THEN lt_formation ELSE XX.lt END
		                              -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                      -- 81, 81_HM, 81_ST, 40 은 lead time 갱신 제외
		     -- 20190408 특성 수율 별도 처리
             , formation_yield        = ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , char_yield             = ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , formation_total_yield  = ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 
             , last_updated_by  = 'COPY : Line'
             , last_update_date = GETDATE()
        FROM   XX,
               SCP_MST_FORMATION AA WITH(NOLOCK)
        WHERE  1=1
        AND    XX.division_id   = AA.division_id
        AND    XX.plant_site_id = AA.plant_site_id
        AND    XX.item_id       = AA.item_id
       ;   

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'UPDATE '+@v_table_id;
        SET @v_description = N'COPY : Line...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 3-1. SCP_MST_FORMATION : INSERT : 정상 라인 
        -----------------------------------------------------------      
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
                      , 0 AS attribute1 -- 활성화 추가 LT
        FROM       
             (SELECT DISTINCT b.division_id
                   , b.scm_site_id 
                   , b.item_id
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
                   --, FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
              FROM  #scp_mst_formation_line b
              GROUP BY b.division_id, b.scm_site_id, b.item_id
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
              --HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month 
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		   ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.item_id     = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                       -- , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                 --  AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.item_id     = ft.item_id

       )
        INSERT INTO SCP_MST_FORMATION
        (division_id, plant_site_id, item_id
       , lt_formation, formation_yield, char_yield, formation_total_yield, attribute1 -- 20190408 char_yield / formation_total_yield 추가
       , created_by, creation_date, last_updated_by, last_update_date
        )
        SELECT division_id, plant_site_id, item_id, lt
		      -- 20190408 특성 수율 별도 처리
             , ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 
			  
		      , attribute1       
              ,'COPY : Line'    AS created_by           
              ,GETDATE() AS creation_date        
              ,'COPY : Line'    AS last_updated_by      
              ,GETDATE() AS last_update_date
        FROM   XX
        WHERE  1=1
        AND    NOT EXISTS ( SELECT 'X' 
                            FROM   SCP_MST_FORMATION X WITH(NOLOCK)
                            WHERE  X.division_id   = XX.division_id
                            AND    X.plant_site_id = XX.plant_site_id
                            AND    X.item_id       = XX.item_id
                          )
        ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT '+@v_table_id;
        SET @v_description = N'COPY : Line...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        ----------------------------------------------------------- 
        -- 3-2. SCP_MST_FORMATION : INSERT : Pilot 라인 - 정상 라인에 없는 정보만 Insert 됨
        -----------------------------------------------------------    
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
                      , 0 AS attribute1 -- 활성화 추가 LT
        FROM (SELECT DISTINCT b.division_id
                   , b.scm_site_id 
                   , b.item_id
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
                   --, FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
              FROM   #scp_mst_formation_pilot  b  
              GROUP BY b.division_id, b.scm_site_id, b.item_id
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
              --HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month    
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		   ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.item_id     = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                       -- , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                  -- AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.item_id     = ft.item_id

       )
        INSERT INTO SCP_MST_FORMATION
        (division_id, plant_site_id, item_id
       , lt_formation, formation_yield, char_yield, formation_total_yield, attribute1 -- 20190408 char_yield / formation_total_yield 추가
       , created_by, creation_date, last_updated_by, last_update_date
        )
        SELECT division_id, plant_site_id, item_id, lt
		      -- 20190408 특성 수율 별도 처리
             , ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 

		      , attribute1       
              ,'COPY : Pilot'    AS created_by           
              ,GETDATE() AS creation_date        
              ,'COPY : Pilot'    AS last_updated_by      
              ,GETDATE() AS last_update_date
        FROM   XX
        WHERE  1=1
        AND    NOT EXISTS ( SELECT 'X' 
                            FROM   SCP_MST_FORMATION X WITH(NOLOCK)
                            WHERE  X.division_id   = XX.division_id
                            AND    X.plant_site_id = XX.plant_site_id
                            AND    X.item_id       = XX.item_id
                          )
        ;        

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT '+@v_table_id;
        SET @v_description = N'COPY : Pilot...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


		-- 2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
        --                               소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
        --                               활성화 관련 반제품은 Cell Assy로 변환하여 정보 형성
		--                             추가 시작
        ----------------------------------------------------------- 
        -- * BOM 기반 전개 정보 : 활성화 진행 중 Assy를 Cell Assy 연계 Temp
        -----------------------------------------------------------   		
		IF OBJECT_ID('tempdb..#scp_exc_item_assy_map') IS NOT NULL
            DROP TABLE #scp_exc_item_assy_map;

		SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SCP_EXC_ITEM_ID, CELL_ASSY_ITEM_ID
		INTO   #scp_exc_item_assy_map
        FROM   dbo.FN_GET_SCP_EXC_ITEM_ASSY_MAP (@p_division_id);

        ----------------------------------------------------------- 
        -- * 활성화 진행 중 Assy를 Cell Assy 연계 Temp LT 정보 : Pilot 라인용 Temp
        -----------------------------------------------------------   		
		IF OBJECT_ID('tempdb..#scp_mst_exc_formation_pilot') IS NOT NULL
        DROP TABLE #scp_mst_exc_formation_pilot
		
        SELECT a.company_id, a.division_id, a.site_id, a.plant_id, SCP_EXC_ITEM_ID, CELL_ASSY_ITEM_ID, a.line_id, a.scm_site_id
             , a.standard_lt_min, a.standard_lt_day
        INTO   #scp_mst_exc_formation_pilot
		FROM (  -- 소형은 기존 로직 유지
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID, M.CELL_ASSY_ITEM_ID, a.line_id, a.plant_id + '-A' AS scm_site_id
					 , SUM(ISNULL(a.standard_lt, 0))           AS standard_lt_min
					 , SUM(ISNULL(a.standard_lt, 0)) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)
        		       INNER JOIN #scp_exc_item_assy_map M WITH(NOLOCK)   
					   ON  a.company_id  = M.COMPANY_ID
					   AND a.division_id = M.DIVISION_ID
					   AND a.site_id     = M.SITE_ID
					   AND a.plant_id    = M.PLANT_ID
					   AND a.item_id     = M.SCP_EXC_ITEM_ID
					   INNER JOIN scp_mst_final_item i WITH(NOLOCK)
					   ON  a.division_id      = i.division_id
					   AND m.CELL_ASSY_ITEM_ID = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id     = '40' -- 소형은 기존 로직 유지
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, M.CELL_ASSY_ITEM_ID, a.line_id 
				UNION -- 자동차/ESS
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID, M.CELL_ASSY_ITEM_ID, a.line_id, a.plant_id + '-A' AS scm_site_id				
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0)))           AS standard_lt_min
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0))) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)   
        		       INNER JOIN #scp_exc_item_assy_map M WITH(NOLOCK)   
					   ON  a.company_id  = M.COMPANY_ID
					   AND a.division_id = M.DIVISION_ID
					   AND a.site_id     = M.SITE_ID
					   AND a.plant_id    = M.PLANT_ID
					   AND a.item_id     = M.SCP_EXC_ITEM_ID               
					   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND m.CELL_ASSY_ITEM_ID = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id    <> '40' -- 소형 외
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거
					   AND  a.route_Type      = 'D'              -- 소형 외 조건 추가
					   AND  ISNULL(a.route_total_time, -99) >= 0 -- 소형 외 조건 추가
				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, M.CELL_ASSY_ITEM_ID, a.line_id 
		
		) a;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT #scp_mst_exc_formation_pilot';
        SET @v_description = N'Temp DB : EXC Pilot...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------- 
        -- * 활성화 진행 중 Assy를 Cell Assy 연계 Temp LT 정보 : 정상 라인용 Temp
        -----------------------------------------------------------   		
		IF OBJECT_ID('tempdb..#scp_mst_exc_formation_line') IS NOT NULL
        DROP TABLE #scp_mst_exc_formation_line
		
        --    소형 - 현행 유지
        --    자동차/ESS - default_route = 'Y' 이고, ROUTE_TYPE 'D'이고, ROUTE_TOTAL_TIME에 값이 있는 것만 조회해서 
        --                 ROUTE_TYPE 'D'인 라우트에서 ROUTE_TOTAL_TIME까지 합산
        SELECT a.company_id, a.division_id, a.site_id, a.plant_id, a.SCP_EXC_ITEM_ID, a.CELL_ASSY_ITEM_ID, a.line_id, a.scm_site_id
             , a.standard_lt_min, a.standard_lt_day
        INTO   #scp_mst_exc_formation_line
		FROM (  -- 소형은 기존 로직 유지
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID, M.CELL_ASSY_ITEM_ID, a.line_id, a.plant_id + '-A' AS scm_site_id
					 , SUM(ISNULL(a.standard_lt, 0))           AS standard_lt_min
					 , SUM(ISNULL(a.standard_lt, 0)) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)
        		       INNER JOIN #scp_exc_item_assy_map M WITH(NOLOCK)   
					   ON  a.company_id  = M.COMPANY_ID
					   AND a.division_id = M.DIVISION_ID
					   AND a.site_id     = M.SITE_ID
					   AND a.plant_id    = M.PLANT_ID
					   AND a.item_id     = M.SCP_EXC_ITEM_ID
                 	   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND m.CELL_ASSY_ITEM_ID = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id     = '40' -- 소형은 기존 로직 유지
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) <> 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거
				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, M.CELL_ASSY_ITEM_ID, a.line_id 
				UNION -- 자동차/ESS
				SELECT a.company_id, a.division_id, a.site_id, a.plant_id, MAX(M.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID, M.CELL_ASSY_ITEM_ID, a.line_id, a.plant_id + '-A' AS scm_site_id				
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0)))           AS standard_lt_min
					 ,(SUM(ISNULL(a.standard_lt, 0)) + MAX(ISNULL(a.route_total_time, 0))) / 24 / 60 AS standard_lt_day
				FROM   SCM_MST_AGING_ITEM_FLOW_M_SN a WITH(NOLOCK)   
                      INNER JOIN #scp_exc_item_assy_map M WITH(NOLOCK)   
					   ON  a.company_id  = M.COMPANY_ID
					   AND a.division_id = M.DIVISION_ID
					   AND a.site_id     = M.SITE_ID
					   AND a.plant_id    = M.PLANT_ID
					   AND a.item_id     = M.SCP_EXC_ITEM_ID
                	   INNER JOIN scp_mst_final_item i WITH(NOLOCK)  -- 2018.08.08 item조인추가
					   ON  a.division_id      = i.division_id
					   AND M.CELL_ASSY_ITEM_ID = i.item_id
					   AND i.operation_group  = 'A' --cell
					   AND i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy
					   AND  a.division_id     = @p_division_id
					   AND  a.division_id    <> '40' -- 소형 외
					   AND  a.default_route   = 'Y'
					   AND  SUBSTRING(a.line_id, LEN(a.line_id)-1, 1) <> 'P' -- 2018.07.23 Pilot 라인 정보
					   --AND  a.default_flag   IN ('S','F') -- 2018.05.31   KSG : 조건 제거
					   AND  a.route_Type      = 'D'              -- 소형 외 조건 추가
					   AND  ISNULL(a.route_total_time, -99) >= 0 -- 소형 외 조건 추가
				GROUP BY a.company_id, a.division_id, a.site_id, a.plant_id, M.CELL_ASSY_ITEM_ID, a.line_id 
		
		) a;

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT #scp_mst_exc_formation_line';
        SET @v_description = N'Temp DB : EXC Line...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 2-1. EXC SCP_MST_FORMATION : UPDATE : Pilot 라인 
        --      동일한 Site/Item 에 대하여 정상 라인 정보가 존재하면 2-2 에서 정상 라인 정보로 Update 됨
	    --      20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
        -----------------------------------------------------------    
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.CELL_ASSY_ITEM_ID AS item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
        FROM       
             (SELECT b.division_id
                   , b.scm_site_id
				   , MAX(b.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                   , b.CELL_ASSY_ITEM_ID
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
              FROM  #scp_mst_exc_formation_pilot b
			  -- 20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
			  WHERE  1 = 1  -- b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                                      -- 81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거
              GROUP BY b.division_id, b.scm_site_id, b.CELL_ASSY_ITEM_ID
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
			 ) lt
		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                                 
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month       
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                                                  
           ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                      --  , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                --   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = ft.item_id

       )
        UPDATE SCP_MST_FORMATION -- attribute1은 설정값 유지 -- 활성화 추가 LT 
           SET lt_formation     = CASE WHEN AA.DIVISION_ID IN ( '81', '81_HM', '81_ST', '40' ) THEN lt_formation ELSE XX.lt END
		                              -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                      -- 81, 81_HM, 81_ST, 40 은 lead time 갱신 제외
		     -- 20190408 특성 수율 별도 처리
             , formation_yield        = ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , char_yield             = ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , formation_total_yield  = ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 
             , last_updated_by  = 'COPY : Pilot'
             , last_update_date = GETDATE()
        FROM   XX,
               SCP_MST_FORMATION AA WITH(NOLOCK)
        WHERE  1=1
        AND    XX.division_id   = AA.division_id
        AND    XX.plant_site_id = AA.plant_site_id
        AND    XX.item_id       = AA.item_id
       ;   

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'UPDATE EXC '+@v_table_id;
        SET @v_description = N'COPY : Pilot...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        ----------------------------------------------------------- 
        -- 2-2. SCP_MST_FORMATION : UPDATE : 정상 라인 - Pilot 라인과 동일한 Site/Item 정보는 정상 라인 정보로 Update 됨
	    --      20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
        -----------------------------------------------------------       		 
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.CELL_ASSY_ITEM_ID AS item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
        FROM       
             (SELECT b.division_id
                   , b.scm_site_id 
				   , MAX(b.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                   , b.CELL_ASSY_ITEM_ID
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
              FROM  #scp_mst_exc_formation_line b
			  -- 20240222 E20240214-000646 Formation 화면 데이터 소형사업부 업데이트 중단 요청 : 최초 INSERT 는 수행, 이후 Update 는 수행하지 않음
			  WHERE  1 = 1  -- b.division_id <> '40'  -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                                      -- 81, 81_HM, 81_ST, 40 수율 반영하기 위해 조건 제거
              GROUP BY b.division_id, b.scm_site_id, b.CELL_ASSY_ITEM_ID
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
              --HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month 
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		   ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                 --  AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = ft.item_id
       )
        UPDATE SCP_MST_FORMATION -- attribute1은 설정값 유지 -- 활성화 추가 LT 
           SET lt_formation     = CASE WHEN AA.DIVISION_ID IN ( '81', '81_HM', '81_ST', '40' ) THEN lt_formation ELSE XX.lt END
		                              -- 2025.05.09   kimcd PJ2024A332 E20250403-001452
                                      -- 81, 81_HM, 81_ST, 40 은 lead time 갱신 제외
		     -- 20190408 특성 수율 별도 처리
             , formation_yield        = ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , char_yield             = ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , formation_total_yield  = ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 
             , last_updated_by  = 'COPY : Line'
             , last_update_date = GETDATE()
        FROM   XX,
               SCP_MST_FORMATION AA WITH(NOLOCK)
        WHERE  1=1
        AND    XX.division_id   = AA.division_id
        AND    XX.plant_site_id = AA.plant_site_id
        AND    XX.item_id       = AA.item_id
       ;   

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N' UPDATE EXC '+@v_table_id;
        SET @v_description = N'COPY : Line...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ----------------------------------------------------------- 
        -- 3-1. SCP_MST_FORMATION : INSERT : EXC 품목 정상 라인 
        -----------------------------------------------------------      
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.CELL_ASSY_ITEM_ID AS item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
                      , 0 AS attribute1 -- 활성화 추가 LT
        FROM       
             (SELECT b.division_id
                   , b.scm_site_id 
				   , MAX(b.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                   , b.CELL_ASSY_ITEM_ID
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
                   --, FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
              FROM  #scp_mst_exc_formation_line b
              GROUP BY b.division_id, b.scm_site_id, b.CELL_ASSY_ITEM_ID
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
              --HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month 
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		   ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                       -- , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                 --  AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) <> 'P' -- 2018.07.23 정상 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = ft.item_id
       )
        INSERT INTO SCP_MST_FORMATION
        (division_id, plant_site_id, item_id
       , lt_formation, formation_yield, char_yield, formation_total_yield, attribute1 -- 20190408 char_yield / formation_total_yield 추가
       , created_by, creation_date, last_updated_by, last_update_date
        )
        SELECT division_id, plant_site_id, item_id, lt
		      -- 20190408 특성 수율 별도 처리
             , ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 
			  
		      , attribute1       
              ,'COPY : Line'    AS created_by           
              ,GETDATE() AS creation_date        
              ,'COPY : Line'    AS last_updated_by      
              ,GETDATE() AS last_update_date
        FROM   XX
        WHERE  1=1
        AND    NOT EXISTS ( SELECT 'X' 
                            FROM   SCP_MST_FORMATION X WITH(NOLOCK)
                            WHERE  X.division_id   = XX.division_id
                            AND    X.plant_site_id = XX.plant_site_id
                            AND    X.item_id       = XX.item_id
                          )
        ; 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT EXC '+@v_table_id;
        SET @v_description = N'COPY : Line...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
        
        ----------------------------------------------------------- 
        -- 3-2. SCP_MST_FORMATION : INSERT : EXC Pilot 라인 - 정상 라인에 없는 정보만 Insert 됨
        -----------------------------------------------------------    
        WITH XX AS
       (
        SELECT DISTINCT lt.division_id
                      , lt.scm_site_id AS plant_site_id
                      , lt.CELL_ASSY_ITEM_ID AS item_id
                      , lt.lt
                      , ISNULL(ft.yield, 1) AS formation_yield
                      , ISNULL(tt.yield, 1) AS char_yield
                      , 0 AS attribute1 -- 활성화 추가 LT
        FROM (SELECT b.division_id
                   , b.scm_site_id 
				   , MAX(b.SCP_EXC_ITEM_ID) AS SCP_EXC_ITEM_ID
                   , b.CELL_ASSY_ITEM_ID
				   -- 2018.08.22  Formation L/T 올림 처리
                   , CEILING(MIN(b.standard_lt_day)) AS lt -- 올림 처리
                   --, FLOOR(MIN(b.standard_lt_day)) AS lt -- 내림 처리  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
              FROM   #scp_mst_exc_formation_pilot  b  
              GROUP BY b.division_id, b.scm_site_id, b.CELL_ASSY_ITEM_ID
			  -- 2018.08.22  Formation L/T 올림 처리
              HAVING CEILING(MIN(b.standard_lt_day)) > 0  
              --HAVING FLOOR(MIN(b.standard_lt_day)) > 0  -- 2018.05.31   KSG : processing_time_day -> standard_lt_day 사용으로 변경
             ) lt

		   -- 특성 수율
           LEFT OUTER JOIN
           (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month    
                  )  a
		   GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		   ) tt
           on  lt.division_id = tt.division_id
           AND lt.scm_site_id = tt.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = tt.item_id
		   
		   -- 20190408 활성화 수율
           LEFT OUTER JOIN
           (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                       -- , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                  -- AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   AND    SUBSTRING(t.line_id, LEN(t.line_id)-1, 1) = 'P' -- 2018.07.23 Pilot 라인 정보
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
           on  lt.division_id = ft.division_id
           AND lt.scm_site_id = ft.scm_site_id
           AND lt.SCP_EXC_ITEM_ID = ft.item_id

       )
        INSERT INTO SCP_MST_FORMATION
        (division_id, plant_site_id, item_id
       , lt_formation, formation_yield, char_yield, formation_total_yield, attribute1 -- 20190408 char_yield / formation_total_yield 추가
       , created_by, creation_date, last_updated_by, last_update_date
        )
        SELECT division_id, plant_site_id, item_id, lt
		      -- 20190408 특성 수율 별도 처리
             , ISNULL(XX.formation_yield, 1)                            -- 활성화 수율
             , ISNULL(XX.char_yield, 1)                                 -- 특성 수율
             , ISNULL(XX.formation_yield, 1) * ISNULL(XX.char_yield, 1) -- 

		      , attribute1       
              ,'COPY : Pilot'    AS created_by           
              ,GETDATE() AS creation_date        
              ,'COPY : Pilot'    AS last_updated_by      
              ,GETDATE() AS last_update_date
        FROM   XX
        WHERE  1=1
        AND    NOT EXISTS ( SELECT 'X' 
                            FROM   SCP_MST_FORMATION X WITH(NOLOCK)
                            WHERE  X.division_id   = XX.division_id
                            AND    X.plant_site_id = XX.plant_site_id
                            AND    X.item_id       = XX.item_id
                          )
        ;        

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT EXC '+@v_table_id;
        SET @v_description = N'COPY : Pilot...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		-- 2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
        --                               소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
        --                               활성화 관련 반제품은 Cell Assy로 변환하여 정보 형성
		--                             추가 완료
		
        ----------------------------------------------------------- 
        -- 4-1. SCP_MST_FORMATION : Default 입력
        -----------------------------------------------------------
        INSERT INTO SCP_MST_FORMATION
        (division_id, plant_site_id, item_id
       , lt_formation, formation_yield, char_yield, formation_total_yield, attribute1 -- 20190408 char_yield / formation_total_yield 추가
       , created_by, creation_date, last_updated_by, last_update_date
        )
        
        SELECT DISTINCT lt.division_id, lt.scm_site_id, lt.item_id
                      -- 2018.05.31 소형 14일, 나머지 21일로 적용
					  -- 20190423 [CSR ID:3979414] 소형 TCO Model은 DEFALUT 활성화 LT = 0 처리
                      , CASE WHEN lt.division_id = '40' AND tco_cell_yn = 'Y' THEN 0   -- TCO Model은 Default 0
                             WHEN lt.division_id = '40' AND tco_cell_yn = 'N' THEN 14  -- Cell Model은 Default 14
                             ELSE 21
                        END              AS lt
                      --, CASE WHEN lt.division_id = '40' THEN 14
                      --       ELSE 21
                      --  END              AS lt
						
		              -- 20190408 특성 수율 별도 처리
		              , ISNULL(ft.yield, 1) AS formation_yield       -- 활성화 수율
		              , ISNULL(tt.yield, 1) AS char_yield            -- 특성 수율
		              , ISNULL(ft.yield, 1) * ISNULL(tt.yield, 1) AS formation_total_yield 

                     --, ISNULL(tt.yield, 1) AS formation_yield -- 2018.06.19   Default Yield 처리 추가
                     , 0 AS attribute1 -- 활성화 추가 LT
                     , 'DEFAULT'  created_by, GETDATE() creation_date, 'DEFAULT' last_updated_by, GETDATE() last_update_date
        FROM  (                 
               SELECT DISTINCT si.division_id, si.scm_site_id, si.item_id, s.site_id
               FROM   scm_mst_site_item si WITH(NOLOCK)
                    , scm_mst_site      s  WITH(NOLOCK)
                    , scp_mst_final_item i WITH(NOLOCK)
               WHERE  si.valid_yn       = 'Y'
               AND    si.division_id    = @p_division_id
               AND    si.division_id    = s.division_id
               AND    si.scm_site_id    = s.scm_site_id
               AND    si.division_id    = i.division_id
               AND    si.item_id        = i.item_id
               AND    s.site_type       = 'PLANT'
               AND    s.operation_group = 'A'
               AND    s.osp_yn         <> 'Y'
			   AND	  ISNULL(s.attribute9, '') = ''	-- [PJ2025F254][LGES] JV법인 ESS 혼용 생산 시스템 개선 : 가상 사이트는 제외 (copy에서 생성) 
			   -- 20230602  PJ20230691  활성화 대응 
               --AND    SUBSTRING(si.item_id,2,1) = 'C'  --cell biz     
               AND    i.operation_group  = 'A' --cell
               AND    i.attribute8       = 'CA1' -- 20230911 E20230908-001596 Cell Packaging 기준으로 CA1 만 등록 : CP 는 CA1 기준으로 뒤에서 Copy     			   

               EXCEPT
               SELECT f.division_id, f.plant_site_id AS scm_site_id, f.item_id, s.site_id
               FROM   scp_mst_formation f WITH(NOLOCK)
                    , scm_mst_site      s  WITH(NOLOCK)
               WHERE  f.division_id     = @p_division_id
               AND    f.division_id     = s.division_id
               AND    f.plant_site_id   = s.scm_site_id
               AND    s.site_type       = 'PLANT'
               AND    s.operation_group = 'A'
              ) lt

              -- 2018.06.19   Default Yield 처리 추가
		      -- 특성 수율
               LEFT OUTER JOIN
              (SELECT scm_site_id, division_id, plant_id, item_id, month, MAX(yield) yield
		   /* -- PJ20209642 변경
            FROM  (SELECT CASE WHEN SUBSTRING(op.flow_id, 1, 1) = 'E' THEN t.plant_id + '-E'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'S' THEN t.plant_id + '-E' -- SRS => 전극
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'A' THEN t.plant_id + '-A'
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'F' THEN t.plant_id + '-A' -- 활성화 => CELL
                               WHEN SUBSTRING(op.flow_id, 1, 1) = 'P' THEN t.plant_id + '-P'
                          END  AS scm_site_id
				*/
            FROM  (SELECT t.plant_site_id AS scm_site_id
                        , op.flow_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                        , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(t.yield, 1) <= 0 THEN 1
						           WHEN ISNULL(t.yield, 1) >= 1 THEN 1
                                   ELSE ISNULL(t.yield, 1)
                              END
                             ) AS yield -- 누적수율은 곱해야 하나 일단 MAX 값으로 처리함
                                     
                   FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경
                   --FROM   dbo.scm_mst_yield_sn t WITH(NOLOCK)
                        , dbo.scm_mst_operation_flow_v op WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                   AND    t.division_id       = op.division_id
                   AND    t.company_id        = op.company_id
                   AND    t.site_id           = op.site_id
                   AND    t.operation_id      = op.operation_id
                   --AND    t.operation_id      = 'F6000'
                   AND    t.operation_id IN ( SELECT segment1 AS operation_id FROM scm_adm_lookup_master_detail WITH (NOLOCK)
		                                      WHERE lookup_type = 'OPERATION_CHAR'
		                                      AND   segment3    = 'Y'  -- Tact Time / yield 적용 대상 공정
		                                      AND   valid_yn    = 'Y' 
                                            ) -- 20181113 수정
                   AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   GROUP BY t.plant_site_id, op.flow_id, t.division_id, t.plant_id, t.item_id, t.month 
                  )  a
		      GROUP BY scm_site_id, division_id, plant_id, item_id, month                     
		     ) tt
               ON  lt.division_id = tt.division_id
               AND lt.scm_site_id = tt.scm_site_id
               AND lt.item_id     = tt.item_id
		   
		       -- 20190408 활성화 수율
               LEFT OUTER JOIN
               (
                   SELECT t.plant_id + '-A' AS scm_site_id
                        , t.division_id
                        , t.plant_id
                        , t.item_id
                      --  , t.month    -- yield 존재 구간
                        -- 수율 0또는 NULL은 1로 처리함
                        , MAX(CASE WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) <= 0 THEN 1
						           WHEN ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1) >= 1 THEN 1
                                   ELSE ISNULL(ISNULL(t.user_formation_total_yield, t.formation_total_yield), 1)
                              END
                             ) AS yield 
                 --       , MAX(CASE WHEN ISNULL(t.formation_total_yield, 1) <= 0 THEN 1
						           --WHEN ISNULL(t.formation_total_yield, 1) >= 1 THEN 1
                 --                  ELSE ISNULL(t.formation_total_yield, 1)
                 --             END
                 --            ) AS yield 
                                     
                   FROM   dbo.scm_mst_formation_yield_sn t WITH(NOLOCK)
                   WHERE  t.division_id       = @p_division_id
                                 
                  -- AND    t.month             =  SUBSTRING(CONVERT(VARCHAR,GETDATE(),112),1,6)
                   GROUP BY t.division_id, t.plant_id, t.item_id--, t.month                                
                  ) ft
               on  lt.division_id = ft.division_id
               AND lt.scm_site_id = ft.scm_site_id
               AND lt.item_id     = ft.item_id
		   
		       -- 20190423 [CSR ID:3979414] 소형 TCO Model은 DEFALUT 활성화 LT = 0 처리
               LEFT OUTER JOIN
               (
                 SELECT division_id, item_id, MAX(DBO.FN_SCM_SYS_NVL(tco_cell_yn, 'N')) AS tco_cell_yn
                 FROM   scp_mst_final_item fi WITH(NOLOCK)
                 WHERE  fi.division_id = '40' -- 소형만 적용  -- @p_division_id
				 GROUP BY division_id, item_id

			   ) fi
               on  lt.division_id = fi.division_id
               AND lt.item_id     = fi.item_id
        ;           

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'DEFAULT...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
        ----------------------------------------------------------- 
        -- 5-1. SCP_MST_FORMATION : CA1 -> CP Copy
        --  20230911 E20230908-001596  CA1 만 생성 후 CP 는 CA1 기준으로 Copy
        -----------------------------------------------------------
		-- CA1 외 삭제
		DELETE x FROM scp_mst_formation x
        WHERE  1=1
        AND    division_id    = @p_division_id
        AND NOT exists (SELECT TOP 1 1
			            FROM   scp_mst_final_item fi WITH(NOLOCK)
			            WHERE  fi.item_id = x.item_id
			            AND    fi.attribute8 = 'CA1')

		-- CA1 -> CP Copy
		INSERT INTO scp_mst_formation
			(division_id, plant_site_id, item_id
		   , lt_formation, formation_yield, char_yield, formation_total_yield, ssp_modify_yield
		   , created_by, creation_date, last_updated_by, last_update_date
		   , attribute1 , attribute2 , attribute3 , attribute4 , attribute5 
		   , attribute6 , attribute7 , attribute8 , attribute9 , attribute10
			)
		SELECT 
              f.division_id, f.plant_site_id, m.item_id_prod
            , f.lt_formation, f.formation_yield, f.char_yield, f.formation_total_yield,f.ssp_modify_yield
			, created_by, creation_date, last_updated_by, last_update_date
			, f.attribute1 , f.attribute2 , f.attribute3 , f.attribute4 , f.attribute5 
			, f.attribute6 , f.attribute7 , f.attribute8 , f.attribute9 , f.attribute10
		FROM   scp_mst_formation f with(nolock)
		INNER JOIN (SELECT c.division_id, c.item_id_assy, MIN(c.item_id_prod) AS item_id_prod
					FROM   SCP_MST_CELL_PROD_ASSY_MAP c WITH(NOLOCK)
						--INNER JOIN scp_mst_final_item f WITH(NOLOCK)
						--ON  c.division_id  = f.division_id
						--AND c.item_id_prod = f.item_id
						--AND f.ATTRIBUTE8   = 'CP'
					WHERE  c.division_id = @p_division_id
                    AND    c.cell_type   = 'CA1' -- Cell 생산 계획    
					AND    c.valid_yn    = 'Y'
					GROUP BY c.division_id, c.item_id_assy
				 ) m
		ON  f.division_id = m.division_id
		AND f.item_id     = m.item_id_assy

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'CA1 -> CP Copy...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ------------------------------------------------------------------------------------------------------------------------------ 
        -- 6. Start : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
        ------------------------------------------------------------------------------------------------------------------------------

        ----------------------------------------------------- 
        -- 6.1 가상 Plant 사이트 대상 데이터 추출 
        ----------------------------------------------------- 
		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_VIRTUAL_SITE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_VIRTUAL_SITE

		SELECT VS.DIVISION_ID	AS VS_DIVISION_ID
			  ,VS.SCM_SITE_ID	AS VS_PLANT_SITE_ID
			  ,VS.PLANT_ID		AS VS_PLANT_ID
			  ,RS.DIVISION_ID	AS RS_DIVISION_ID
			  ,RS.SCM_SITE_ID	AS RS_PLANT_SITE_ID
			  ,RS.PLANT_ID		AS RS_PLANT_ID
			  ,RF.ITEM_ID
			  ,CAST(RF.LT_FORMATION				AS NUMERIC(20,10))	AS LT_FORMATION			
			  ,CAST(RF.FORMATION_YIELD			AS NUMERIC(20,10))	AS FORMATION_YIELD		
			  ,CAST(RF.CHAR_YIELD				AS NUMERIC(20,10))	AS CHAR_YIELD			
			  ,CAST(RF.FORMATION_TOTAL_YIELD	AS NUMERIC(20,10))	AS FORMATION_TOTAL_YIELD
			  ,CAST(RF.SSP_MODIFY_YIELD			AS NUMERIC(20,10))	AS SSP_MODIFY_YIELD		
			  ,RF.ATTRIBUTE1	
			  ,ROW_NUMBER() OVER (PARTITION BY VS.DIVISION_ID
											  ,VS.SCM_SITE_ID
											  ,RF.ITEM_ID
									  ORDER BY RF.LAST_UPDATE_DATE DESC) AS RN 
		 INTO #SCP_MST_FORMATION_VIRTUAL_SITE
		 FROM SCM_MST_PLANT_SN VP WITH(NOLOCK)
			  INNER JOIN SCM_MST_SITE VS WITH(NOLOCK)
					  ON VS.DIVISION_ID = VP.DIVISION_ID
					 AND VS.PLANT_ID	= VP.PLANT_ID
					 AND VS.SITE_TYPE	= 'PLANT'
					 AND VS.VALID_YN	= 'Y'
			  INNER JOIN SCM_MST_SITE RS WITH(NOLOCK)
					  ON RS.SCM_SITE_ID	= VS.ATTRIBUTE9 
					 AND RS.PLANT_ID	= VP.LINK_PLANT_ID
					 AND RS.SITE_TYPE	= 'PLANT'
					 AND RS.VALID_YN	= 'Y'
			  INNER JOIN SCP_MST_FORMATION RF WITH(NOLOCK) 
					  ON RF.DIVISION_ID		= RS.DIVISION_ID
					 AND RF.PLANT_SITE_ID	= RS.SCM_SITE_ID
		WHERE 1=1
		  AND RS.DIVISION_ID	= @p_division_id	-- Real plant 기준
		  AND VP.PLANT_TYPE		= 'VIRTUAL'

        ----------------------------------------------------- 
        -- 6.2 가상 Plant 사이트 대상 이력 생성 (Update대상) 
        ----------------------------------------------------- 
		INSERT INTO SCP_MST_FORMATION_H
			  (HISTORY_SEQ
			  ,DIVISION_ID
			  ,PLANT_SITE_ID
			  ,ITEM_ID
			  ,LT_FORMATION
			  ,FORMATION_YIELD
			  ,CHAR_YIELD
			  ,FORMATION_TOTAL_YIELD
			  ,SSP_MODIFY_YIELD
			  ,CREATED_BY
			  ,CREATION_DATE
			  ,LAST_UPDATED_BY
			  ,LAST_UPDATE_DATE
			  ,ATTRIBUTE1
			  ,HISTORY_CREATION_DATE)
		SELECT NEXT VALUE FOR SEQ1_SCP_MST_FORMATION_H	AS HISTORY_SEQ
			  ,TG.DIVISION_ID
			  ,TG.PLANT_SITE_ID
			  ,TG.ITEM_ID
			  ,TG.LT_FORMATION
			  ,TG.FORMATION_YIELD
			  ,TG.CHAR_YIELD
			  ,TG.FORMATION_TOTAL_YIELD
			  ,TG.SSP_MODIFY_YIELD
			  ,TG.CREATED_BY
			  ,TG.CREATION_DATE
			  ,TG.LAST_UPDATED_BY
			  ,TG.LAST_UPDATE_DATE
			  ,TG.ATTRIBUTE1
			  ,GETDATE()								AS HISTORY_CREATION_DATE
		 FROM SCP_MST_FORMATION TG WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FORMATION_VIRTUAL_SITE VF
					  ON VF.VS_DIVISION_ID	= TG.DIVISION_ID
					 AND VF.VS_PLANT_SITE_ID= TG.PLANT_SITE_ID
					 AND VF.ITEM_ID			= TG.ITEM_ID 
					 AND VF.RN				= 1 
		WHERE ISNULL(VF.LT_FORMATION, 0)			!= ISNULL(TG.LT_FORMATION, 0)
		   OR ISNULL(VF.FORMATION_YIELD, 0)			!= ISNULL(TG.FORMATION_YIELD, 0)
		   OR ISNULL(VF.CHAR_YIELD, 0)				!= ISNULL(TG.CHAR_YIELD, 0)
		   OR ISNULL(VF.FORMATION_TOTAL_YIELD, 0)	!= ISNULL(TG.FORMATION_TOTAL_YIELD, 0)
		   OR ISNULL(VF.SSP_MODIFY_YIELD, 0)		!= ISNULL(TG.SSP_MODIFY_YIELD, 0)
		   OR ISNULL(VF.ATTRIBUTE1, '')				!= ISNULL(TG.ATTRIBUTE1, '')

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO SCP_MST_FORMATION_H';
        SET @v_description = N'6.2 가상 Plant 대상 데이터 이력 저장 (Update대상) ' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		----------------------------------------------------- 
        -- 6.3 가상 Plant 사이트 대상 데이터 Update 
        ----------------------------------------------------- 
		UPDATE TG
		   SET TG.LT_FORMATION			= VF.LT_FORMATION
			 , TG.FORMATION_YIELD		= VF.FORMATION_YIELD
			 , TG.CHAR_YIELD			= VF.CHAR_YIELD
			 , TG.FORMATION_TOTAL_YIELD	= VF.FORMATION_TOTAL_YIELD
			 , TG.SSP_MODIFY_YIELD		= VF.SSP_MODIFY_YIELD
			 , TG.ATTRIBUTE1			= VF.ATTRIBUTE1
			 , TG.LAST_UPDATE_DATE		= GETDATE()
			 , TG.LAST_UPDATED_BY		= 'COPY : Virtual'
		 FROM SCP_MST_FORMATION TG WITH(NOLOCK)
			  INNER JOIN #SCP_MST_FORMATION_VIRTUAL_SITE VF
					  ON VF.VS_DIVISION_ID	= TG.DIVISION_ID
					 AND VF.VS_PLANT_SITE_ID= TG.PLANT_SITE_ID
					 AND VF.ITEM_ID			= TG.ITEM_ID 
					 AND VF.RN				= 1 
		WHERE ISNULL(VF.LT_FORMATION, 0)			!= ISNULL(TG.LT_FORMATION, 0)
		   OR ISNULL(VF.FORMATION_YIELD, 0)			!= ISNULL(TG.FORMATION_YIELD, 0)
		   OR ISNULL(VF.CHAR_YIELD, 0)				!= ISNULL(TG.CHAR_YIELD, 0)
		   OR ISNULL(VF.FORMATION_TOTAL_YIELD, 0)	!= ISNULL(TG.FORMATION_TOTAL_YIELD, 0)
		   OR ISNULL(VF.SSP_MODIFY_YIELD, 0)		!= ISNULL(TG.SSP_MODIFY_YIELD, 0)
		   OR ISNULL(VF.ATTRIBUTE1, '')				!= ISNULL(TG.ATTRIBUTE1, '')

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'UPDATE SCP_MST_FORMATION';
        SET @v_description = N'6.3 가상 Plant 대상 데이터 Update ' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		----------------------------------------------------- 
        -- 6.4 가상 Plant 사이트 대상 데이터 insert 
        ----------------------------------------------------- 
		INSERT INTO SCP_MST_FORMATION
			  (  DIVISION_ID
				,PLANT_SITE_ID
				,ITEM_ID
				,LT_FORMATION
				,FORMATION_YIELD
				,CHAR_YIELD
				,FORMATION_TOTAL_YIELD
				,SSP_MODIFY_YIELD
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1)
		SELECT VF.VS_DIVISION_ID
			  ,VF.VS_PLANT_SITE_ID
			  ,VF.ITEM_ID
			  ,VF.LT_FORMATION
			  ,VF.FORMATION_YIELD
			  ,VF.CHAR_YIELD
			  ,VF.FORMATION_TOTAL_YIELD
			  ,VF.SSP_MODIFY_YIELD
			  ,'COPY : Virtual'	AS CREATED_BY
			  ,GETDATE()		AS CREATION_DATE
			  ,'COPY : Virtual'	AS LAST_UPDATED_BY
			  ,GETDATE()		AS LAST_UPDATE_DATE
			  ,VF.ATTRIBUTE1
		 FROM #SCP_MST_FORMATION_VIRTUAL_SITE VF
		WHERE 1=1
		  AND VF.RN		=	1
		  AND NOT EXISTS (SELECT 'X'
							FROM SCP_MST_FORMATION TG WITH(NOLOCK)
						   WHERE TG.DIVISION_ID		= VF.VS_DIVISION_ID
							 AND TG.PLANT_SITE_ID	= VF.VS_PLANT_SITE_ID
							 AND TG.ITEM_ID			= VF.ITEM_ID) 

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT SCP_MST_FORMATION';
        SET @v_description = N'6.4 가상 Plant 대상 데이터 insert ' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        ------------------------------------------------------------------------------------------------------------------------------ 
        -- 6. End : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : JV plant site 기준으로 매핑된 ESS 가상 plant 사이트 데이터 동기화
        ------------------------------------------------------------------------------------------------------------------------------

        PRINT N'프로시저 종료'

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        IF @@TRANCOUNT > 0 
          BEGIN
            COMMIT WORK;
          END;
		  
		IF OBJECT_ID('tempdb..#scp_mst_formation_pilot') IS NOT NULL
        DROP TABLE #scp_mst_formation_pilot

		IF OBJECT_ID('tempdb..#scp_mst_formation_line') IS NOT NULL
        DROP TABLE #scp_mst_formation_line

		-- 2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
        --                               소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
		--                               추가된 임시 테이블 삭제 시작
		IF OBJECT_ID('tempdb..#scp_exc_item_assy_map') IS NOT NULL
        DROP TABLE #scp_exc_item_assy_map;

		IF OBJECT_ID('tempdb..#scp_mst_exc_formation_pilot') IS NOT NULL
        DROP TABLE #scp_mst_exc_formation_pilot

		IF OBJECT_ID('tempdb..#scp_mst_exc_formation_line') IS NOT NULL
        DROP TABLE #scp_mst_exc_formation_line
		-- 2025.09.27   kimcd          PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산  : 
        --                               소형 사업부 신규 공정 반영에 따른 Cell 제품, Cell Assy 정보 형성 과정 보완
		--                               추가된 임시 테이블 삭제 종료
		
		IF OBJECT_ID('TEMPDB..#SCP_MST_FORMATION_VIRTUAL_SITE') IS NOT NULL DROP TABLE #SCP_MST_FORMATION_VIRTUAL_SITE -- [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선 : 임시테이블 삭제 

        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_type = N'TXN';    
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112) + ' : ' + @p_division_id;
        SET @d_event_date = SYSDATETIME();

        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                  ,@p_log_type      =@v_log_type
                                  ,@p_log_count     =@n_log_count 
                                  ,@p_log_message   =@v_log_message 
                                  ,@p_description   =@v_description 
                                  ,@p_event_date    =@d_event_date 
                                  ,@p_user_id       =@v_batch_user
                                  ;

      END;

    END TRY

    BEGIN CATCH
        
      IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count 
                                ,@p_log_message   =@v_log_message 
                                ,@p_description   =@v_description 
                                ,@p_event_date    =@d_event_date 
                                ,@p_user_id       =@v_batch_user
                                ;

      return -1 
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1  


  END;
