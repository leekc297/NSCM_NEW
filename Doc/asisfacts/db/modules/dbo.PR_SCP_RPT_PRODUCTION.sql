

/*      
 * Program ID   : PR_SCP_RPT_PRODUCTION
 * Description  : PR_SCP_RPT_PRODUCTION
 * OutTable     :      
 * Execute      : 

 
    SELECT * FROM SCM_SYS_LOG_BATCH with (nolock)  where [PROGRAM_NAME] ='PR_SCP_RPT_PRODUCTION' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2021.11.23   sclee.lee      PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : Report
 * 2021.12.23   sclee.lee      PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : 외주 생산물량 추가
 * 2022.01.04   sclee.lee      ESS 관련 외주 operation_id 사용하도록 변경
 * 2022.03.25   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.06.27   sclee.lee      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2022.12.13   hrkim		   PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 
 *								1. 자동차 PROD_RESULT 집계 기준 변경 
 *								   - 변경전 : FP Plan과 FP 실적 비교 적용
 *								   - 변경후 : SCP Plan과 FP 실적 비교 적용 (소형과 동일)
 *								2. FP Plan 집계 참조 테이블 변경 
 *								   - 변경전 : SCM_DNM_FP_RELEASE_PROD_PLAN_SN  (plan_type : WPP) 
 *								   - 변경후 : SCM_DNM_FP_RELEASE_PROD_PLAN_C 
 * 2023.03.31   hrkim		   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.05.10	hrkim		   E20230503-000475 [소형SCM] GSCM Production Result Check 기능 개선 요청
 *									- 전 사업부 외주 packer 실적 적재 (변경전 : 82 ESS만 적재함)
 * 2023.05.23   hrkim		   PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Reason 정보 유지 기능 추가
 * 2023.07.18   hrkim		   PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : #tmp_ISUZU item 중복 참조 오류 수정 (SCM_MST_FINAL_ITEM_V 참조 제외)
*/    


CREATE PROCEDURE [dbo].[PR_SCP_RPT_PRODUCTION]
(           
  @p_plan_start_yyyymmdd           NVARCHAR(150) = NULL
)
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;      
    SET XACT_ABORT ON;      
    SET ANSI_WARNINGS OFF;      
      
    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';        
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_RPT_PRODUCTION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_RPT_PRODUCTION';   
    DECLARE @d_event_date   DATETIME;      
    DECLARE @v_plan_start_yyyymmdd VARCHAR(8);     -- Data 생성 주차
    DECLARE @v_pre_plan_start_yyyymmdd VARCHAR(8); -- SCP Plan 정보 주차
	
    --새 실적 입력 전에 해당 삭제대상서 제외 DIVISION_ID목록
    DECLARE @v_tb_except_division_from_delete TABLE
    (
     DIVISION_ID            NVARCHAR(30)
    );
    
    INSERT INTO @v_tb_except_division_from_delete
	-- 2023.03.31 HM JV 가상 사업부 추가 대응
	SELECT DM.DIVISION_ID
	  FROM SCM_MST_DIVISION AS DM WITH(NOLOCK)
	 WHERE DM.ATTRIBUTE3 = 'EE'
	   AND DM.VALID_YN	 = 'Y'
    -- 2023.03.31 HM JV SELECT 'EE' UNION ALL
    -- 2023.03.31 HM JV SELECT 'EE_UC';

    -- 로직 실행관련 변수 설정
	IF ISNULL(@p_plan_start_yyyymmdd, '') = ''  -- 당주 정보 생성
        SET @v_plan_start_yyyymmdd      = CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일
	ELSE
        SET @v_plan_start_yyyymmdd      = @p_plan_start_yyyymmdd
	
    SET @v_pre_plan_start_yyyymmdd  = CONVERT(CHAR(8), DATEADD(DD, -7, CONVERT(DATETIME, @v_plan_start_yyyymmdd)), 112); -- 전주 월요일

    DECLARE @v_start_yyyymmdd      VARCHAR(8)     = @v_plan_start_yyyymmdd;                                                  -- 실적 시작 월요일
    DECLARE @v_end_yyyymmdd        VARCHAR(8)     = FORMAT(DATEADD(dd, 6, CAST(@v_start_yyyymmdd AS DATETIME)), 'yyyyMMdd'); -- 실적 종료 일요일
    DECLARE @v_yyyyww              VARCHAR(6);
    DECLARE @v_plan_week           VARCHAR(8);
    DECLARE @v_pre_plan_week       VARCHAR(8);
    DECLARE @v_division_id         NVARCHAR(30);
    DECLARE @v_total_loop_cnt      INT;
    DECLARE @v_cur_loop_cnt        INT = 0;

    -- 시작 LOG      
    SET @v_log_type     = N'START';      
    SET @v_log_message  = N'########## Start of procedure ##########';      
    SET @v_description  = @v_program_name + ':' + N'INSERT LOGIC';      
    SET @d_event_date   = SYSDATETIME();      
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;  
   
        -- 실행시간 확인용    
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();    
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'00:00';

    --DECLARE @debug_mode            NVARCHAR(30) = 'T'
        BEGIN TRY        
          BEGIN        

            -------------------------------------------------------------------------------------------------------------------------         
            -- 임시테이블 확인 후 제거
            -------------------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#tmp_BASE_1') IS NOT NULL
                 DROP TABLE #tmp_BASE_1;
   
             IF OBJECT_ID('tempdb..#tmp_BASE_2') IS NOT NULL
                 DROP TABLE #tmp_BASE_2;
   
             IF OBJECT_ID('tempdb..#tmp_BASE_3') IS NOT NULL
                 DROP TABLE #tmp_BASE_3;
   
             IF OBJECT_ID('tempdb..#tmp_OPERATION_ID') IS NOT NULL
                 DROP TABLE #tmp_OPERATION_ID;

             IF OBJECT_ID('tempdb..#tmp_OPERATION_GROUP') IS NOT NULL
                 DROP TABLE #tmp_OPERATION_GROUP;
   
             IF OBJECT_ID('tempdb..#tmp_CELL_TYPE_GROUP') IS NOT NULL
                 DROP TABLE #tmp_CELL_TYPE_GROUP;

             IF OBJECT_ID('tempdb..#tmp_DIVISION_ID') IS NOT NULL
                 DROP TABLE #tmp_DIVISION_ID;

             IF OBJECT_ID('tempdb..#tmp_MST_FINAL_ITEM') IS NOT NULL
                 DROP TABLE #tmp_MST_FINAL_ITEM;

             IF OBJECT_ID('tempdb..#tmp_SCM_DNM_SCS_PROD_RESULT') IS NOT NULL
                 DROP TABLE #tmp_SCM_DNM_SCS_PROD_RESULT;

             IF OBJECT_ID('tempdb..#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V') IS NOT NULL
                 DROP TABLE #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V;

             -- PJ20216891
             -- ISUZU item				 
             IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
                 DROP TABLE #tmp_ISUZU;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 값 할당 / 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------------------
			 -- 대상 Operation 확인
             SELECT DISTINCT operation_id
                   ,operation_type
             INTO   #tmp_OPERATION_ID
			 FROM (
					 SELECT DISTINCT B.segment4 operation_id
                           ,'A' operation_type
					 FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
					 INNER JOIN dbo.SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)
					 ON  A.segment1    = B.segment1
					 AND A.lookup_type = 'LOCATION_GROUP'
					 AND A.segment4    = 'Y' -- Capa 공정 여부 
					 AND A.segment5    = 'Y' -- Line 별 Capa 적용 공정( Capa공정여부가 'N'이면  Line 별 Capa 적용 공정이 'Y'가 될수없음)
					 AND A.valid_yn    = 'Y'
					 AND B.lookup_type = 'LOCATION_GROUP_ROUTE'
					 AND B.valid_yn    = 'Y'
					 AND B.segment3    = 'Y' -- Capa 세부 공정 여부 
					 AND A.segment3    IN ('A', 'P') -- Cell / Pack

					 -- 외주 
					 UNION ALL
					 (					 
						 SELECT DISTINCT plant_id AS operation_id
							   ,'B' operation_type
						 FROM   dbo.SCM_MST_SITE WITH (NOLOCK)
						 WHERE  valid_yn        = 'Y'
						 AND    site_type       = 'PLANT'
						 AND    osp_yn          = 'Y'
						 AND    operation_group IN ('A', 'P') -- Cell / Pack
						 -- 2023.05.10 전사업부 packer 실적 적재 AND    division_id     = '82' -- 외주 중 ESS만 연관있는 것만 사용

						 -- 외주 : ESS Rack용
						 UNION  -- 중복 방지를 위해 UNUION ALL 하지 않음		 
						 SELECT DISTINCT operation_id AS operation_id
							   ,'B' operation_type
						 FROM   dbo.SCM_MST_LINE_OSP WITH (NOLOCK)
						 WHERE  valid_yn        = 'Y'
						 -- 2023.05.10 전사업부 packer 실적 적재 AND    division_id     = '82' -- 외주 중 ESS만 연관있는 것만 사용
					 )
					 
                     -- PJ20216891
					 -- ISUZU ITEM (현재는 operation_id가 P5000중 일부가 해당됨)
					 UNION ALL
					 
					 SELECT 'P5000' operation_id
                           ,'A' operation_type
			      ) A
             ;

             SELECT B.SEGMENT1
                   ,B.SEGMENT2
             INTO   #tmp_OPERATION_GROUP
             FROM   dbo.SCM_ADM_LOOKUP_MASTER A WITH (NOLOCK)
             INNER JOIN dbo.SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
             ON  A.LOOKUP_TYPE = B.LOOKUP_TYPE
             WHERE  A.LOOKUP_TYPE = 'OPERATION_GROUP'
             AND A.VALID_YN = 'Y'
             AND B.VALID_YN = 'Y'
             ;

			 -- 계획/실적 생성 일자 : 당주
             SELECT @v_plan_week = calendar_yyyy + '-' + week_name
             FROM   dbo.SCM_SYS_CALENDAR_M WITH (NOLOCK)
             WHERE  basis_yyyymmdd = @v_plan_start_yyyymmdd -- 당주 월요일
			 ;

			 -- week : 지난 주
             SELECT @v_pre_plan_week = calendar_yyyy + '-' + week_name
             FROM   dbo.SCM_SYS_CALENDAR_M WITH (NOLOCK)
             WHERE  basis_yyyymmdd = @v_pre_plan_start_yyyymmdd -- 당주 월요일
			 ;

             SELECT division_id
                   ,item_id
                   ,cell_type_group_code
                   ,nick_name
                   ,group_code2
             INTO   #tmp_MST_FINAL_ITEM
             FROM   dbo.SCP_MST_FINAL_ITEM WITH (NOLOCK)
             ;
             
             SELECT B2.segment2
                   ,B1.division_id
                   ,B1.item_id
             INTO   #tmp_CELL_TYPE_GROUP
             FROM   #tmp_MST_FINAL_ITEM B1 WITH (NOLOCK)
             INNER JOIN dbo.SCM_ADM_LOOKUP_MASTER_DETAIL B2 WITH (NOLOCK)
             ON  B1.cell_type_group_code = B2.segment1
             AND B2.lookup_type          = 'CELL_TYPE_GROUP_CODE'
             AND B2.valid_yn             = 'Y'
             ;

             SELECT division_id
                   ,model_id
                   ,plant_id
                   ,accumulated_child_qty
             INTO   #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V
             FROM   dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH (NOLOCK)
             WHERE  operation_group_id = 'A'
             ;

             -- 외주 생산 실적 (실적 : data_type = A, 계획 : data_type = B)
             ;WITH sub AS
             (
              SELECT B.plant_id operation_id
                    ,B.operation_group
                    ,A.division_id
                    ,A.cutoff_date
                    ,A.scm_site_id
                    ,A.item_id
                    ,A.packer_code
                    ,A.pack_model_code
                    ,A.line_id
                    ,A.prod_date
                    ,A.prod_qty
                    ,A.defect_qty
                    ,ISNULL(C.accumulated_child_qty, 1) accumulated_child_qty
              FROM dbo.SCM_DNM_SCS_PROD_RESULT A WITH (NOLOCK)
              INNER JOIN dbo.SCM_MST_SITE B WITH (NOLOCK)
              ON  A.division_id = B.division_id
              AND A.scm_site_id = B.scm_site_id
              LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V C
              ON  A.division_id = C.division_id
              AND A.item_id     = C.model_id
              AND B.plant_id    = C.plant_id
              AND B.operation_group = 'P'
              WHERE A.prod_date BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
			  -- 2023.05.10 전사업부 packer 실적 적재 AND   A.division_id = '82'
             ),
             sub1 AS
             (
              SELECT operation_id
                    ,CASE WHEN MAX(prod_date) > GETDATE() - 2 THEN MAX(prod_date) ELSE FORMAT(GETDATE() - 2, 'yyyyMMdd') END prod_date
              FROM sub
              GROUP BY operation_id
             ),
             sub2 AS
             (
              SELECT A.*
                    ,CASE WHEN A.prod_date <= B.prod_date THEN 'A'  --*
                          ELSE 'B' END data_type
              FROM sub A
              LEFT JOIN sub1 B
              ON A.operation_id = B.operation_id
             )
             SELECT *
             INTO #tmp_SCM_DNM_SCS_PROD_RESULT
             FROM sub2
             ;

			 -- 전주 최종 Plan
             SELECT D.division_id
                   ,P.plan_name
                   ,D.plan_id
                   ,D.plan_type
                   ,MAX(D.plan_seq) AS plan_seq
                   ,ROW_NUMBER() OVER (PARTITION BY D.division_id ORDER BY D.plan_id DESC) AS RN
                   ,DENSE_RANK() OVER (ORDER BY D.division_id ASC) AS RowIdx
             INTO   #tmp_DIVISION_ID
             FROM   dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
             INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK)
             ON  D.division_id  = P.division_id
             AND D.plan_id      = P.plan_id
             AND D.plan_status  = '1'
             AND D.confirm_flag = 'Y'
             AND D.plan_type    = 'FN'
			 
             -- PJ20216891
             -- AND D.division_id  <> 'EE'
             AND D.division_id  NOT IN (SELECT DIVISION_ID FROM @v_tb_except_division_from_delete)
			 AND p.plan_name    = @v_pre_plan_start_yyyymmdd -- 전주 월요일
             GROUP BY D.division_id, P.plan_name, D.plan_id, D.plan_type
			 
             SET @v_total_loop_cnt = @@ROWCOUNT;

			 /* 2023.07.18 변경전 쿼리 -- SCM_MSP_FINAL_ITEM_V 참조로 인한 중복 item 
             -- PJ20216891
             -- ISUZU item
             SELECT A.item_id
             INTO   #tmp_ISUZU
             FROM   dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
             INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.item_id = B.item_id
             WHERE  A.IS_YN = 'Y'
             ;
			 */

			 -- 2023.07.18 #tmp_ISUZU item 중복 오류 수정 
             SELECT A.item_id
              INTO  #tmp_ISUZU
              FROM  dbo.SCP_MST_FINAL_ITEM_V A WITH(NOLOCK)
             WHERE  A.IS_YN = 'Y'
			 ;
			 
            -------------------------------------------------------------------------------------------------------------------------         
            -- 2023.05.23 PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Reason 정보 유지 기능 추가
            -------------------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#tmp_SCP_RPT_PRODUCTION_BEFORE') IS NOT NULL
                 DROP TABLE #tmp_SCP_RPT_PRODUCTION_BEFORE;

			 SELECT *
			   INTO #tmp_SCP_RPT_PRODUCTION_BEFORE
			   FROM dbo.SCP_RPT_PRODUCTION  WITH(NOLOCK)
			  WHERE 1=1 
			    AND PLAN_START_YYYYMMDD = @v_plan_start_yyyymmdd
				AND (REASON_CODE IS NOT NULL OR REASON_DESCRIPTION IS NOT NULL) 

            -------------------------------------------------------------------------------------------------------------------------         
            -- 사업부별 임시데이터(실적 & 계획) 생성
            -------------------------------------------------------------------------------------------------------------------------

             IF(@v_total_loop_cnt > 0)
             BEGIN
                 BEGIN TRAN

                 -- 기존내역부터 지우고 시작
                 -- DELETE dbo.SCP_RPT_PRODUCTION WHERE division_id = @v_division_id AND plan_start_yyyymmdd = @v_plan_start_yyyymmdd;					 
                 WHILE(1 = 1)
                 BEGIN
                     DELETE TOP (10000) A
                     FROM dbo.SCP_RPT_PRODUCTION A
                     WHERE division_id NOT IN (SELECT DIVISION_ID FROM @v_tb_except_division_from_delete)
                     AND plan_start_yyyymmdd = @v_plan_start_yyyymmdd
           
                     IF(@@ROWCOUNT = 0)
                     BEGIN
                         BREAK;
                     END
                 END

                 COMMIT
			 
				 WHILE(@v_cur_loop_cnt < @v_total_loop_cnt)
				 BEGIN
					 SET @v_cur_loop_cnt = @v_cur_loop_cnt + 1;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 사업부별 임시데이터(실적 & 계획) 생성 - SCP_ANL_PRODUCTION_PLAN
            -------------------------------------------------------------------------------------------------------------------------

					 SELECT @v_division_id = division_id
					 FROM   #tmp_DIVISION_ID
					 WHERE  RowIdx = @v_cur_loop_cnt
					 ;

                     ;WITH sub AS
                     (
                      SELECT @v_plan_start_yyyymmdd AS plan_start_yyyymmdd
                            ,@v_plan_week plan_week
                            ,A.operation_group
                            ,A.scm_site_id
                            ,A.item_id
                            ,ISNULL(D.plant_id, '-') plant_id
                            ,A.yyyymmdd
                            ,B.yyyyww
							,A.operation_id
                            ,SUM(ISNULL(A.qty, 0)) qty
                            ,A.division_id
                      FROM   dbo.SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)

                      INNER JOIN dbo.SCM_MST_BUCKET B WITH (NOLOCK)
                      ON  A.yyyymmdd = B.yyyymmdd

                      INNER JOIN #tmp_DIVISION_ID C -- 지난 주 최종 plan
                      ON  A.division_id         = C.division_id
                      AND A.plan_start_yyyymmdd = C.plan_name
                      AND A.plan_type           = C.plan_type
                      AND A.seq                 = C.plan_seq

                      LEFT JOIN dbo.SCM_MST_SITE D WITH (NOLOCK)
                      ON  A.division_id = D.division_id
                      AND A.scm_site_id = D.scm_site_id

                      WHERE   1 = 1
                      AND A.division_id = @v_division_id
                      AND A.measure     = 'PROD_PLAN_AMEND'
					  AND A.qty         > 0
                      AND A.yyyymmdd    BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd  -- 당주 일자
					  -- 2023.05.10 전사업부 packer 실적 적재 -- 외주는 ESS 만 생성
					  -- 2023.05.10 전사업부 packer 실적 적재 AND CASE WHEN A.division_id         = '82' THEN 'Y'
					  -- 2023.05.10 전사업부 packer 실적 적재          WHEN ISNULL(d.osp_yn, 'N') = 'Y'  THEN 'N' 
					  -- 2023.05.10 전사업부 packer 실적 적재 	   ELSE 'Y'
					  -- 2023.05.10 전사업부 packer 실적 적재     END  = 'Y'
                      GROUP BY A.plan_start_yyyymmdd, A.operation_group, A.scm_site_id, A.item_id, ISNULL(D.plant_id, '-'), A.yyyymmdd, B.yyyyww, A.division_id, A.operation_id
                     ),
                     sub1 AS
                     (
                      SELECT *
                      FROM   sub
                      
                      UNION ALL

                      SELECT @v_plan_start_yyyymmdd AS plan_start_yyyymmdd
                            ,@v_plan_week plan_week
                            ,A.operation_group
                            ,A.scm_site_id
                            ,A.item_id
                            ,ISNULL(C.plant_id, '-') plant_id
                            ,A.prod_date
                            ,B.yyyyww
                            ,A.operation_id
                            ,0 qty
                            ,A.division_id
                      FROM  #tmp_SCM_DNM_SCS_PROD_RESULT A
                      LEFT JOIN sub B
                      ON  A.division_id = B.division_id
                      AND A.scm_site_id = B.scm_site_id
                      AND A.operation_group = B.operation_group
                      AND A.item_id = B.item_id
                      LEFT JOIN dbo.SCM_MST_SITE C WITH(NOLOCK)
                      ON  A.division_id = C.division_id
                      AND A.scm_site_id = C.scm_site_id
                      WHERE 1 = 1
                      AND A.data_type = 'B'  -- 계획
                     ),
                     sub2 AS
                     (
                      SELECT A.*
					  
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE') -- 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  WHEN A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1

                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 202.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE') -- 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                            ,D.operation_type

                            -- PJ20216891
                            -- P5000인 경우 ISUZU item(E.item_id not null)이면 Y 처리 아니면 N, 그 외 Y
                            ,CASE WHEN A.operation_id = 'P5000' AND E.item_id IS NOT NULL THEN 'Y'
                                  WHEN A.operation_id = 'P5000' AND E.item_id IS NULL THEN 'N'
                                  ELSE 'Y' END target_yn
                      FROM   sub A
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK) -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID 
									AND DM.VALID_YN	   = 'Y'

                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id      = B.item_id
                      AND A.division_id  = B.division_id

                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id  = C.division_id
                      AND A.item_id      = C.item_id

                      INNER JOIN #tmp_OPERATION_ID D
                      ON  A.operation_id = D.operation_id
					  
                      LEFT JOIN #tmp_ISUZU E
                      ON  A.item_id      = E.item_id
                     ),
                     sub3 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.operation_group
                            ,A.item_id
                            ,SUM(ISNULL(A.qty, 0)) plan_qty_1
							,SUM(ISNULL(A.qty, 0) * ISNULL(B.accumulated_child_qty, 1)) plan_cell_1
                            ,A.division_id
                            ,A.segment2
                            ,A.operation_group1
                            ,A.group_code2
                            ,A.plant_id
                            ,ISNULL(C.segment2, '') operation_group_name
                            ,A.operation_type
                            ,A.target_yn
                      FROM   sub2 A
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND A.operation_group = 'P'
                      LEFT JOIN #tmp_OPERATION_GROUP C
                      ON  A.operation_group = C.segment1
					  
                      -- PJ20216891
                      -- P5000인 경우 ISUZU item이 아니면 제외
                      WHERE A.target_yn = 'Y'
                      GROUP BY A.plan_week, A.plan_start_yyyymmdd, A.operation_group, A.item_id, A.division_id, A.segment2, A.operation_group1, A.group_code2, A.plant_id, ISNULL(C.segment2, ''), A.operation_type, A.target_yn
                     ),
                     sub4 AS
                     (
                      SELECT A.plan_week --기준주차
                            ,A.plan_start_yyyymmdd
                            ,A.division_id -- 사업부
                            ,A.segment2 -- 소형제품구분
                            ,A.operation_group -- operation_group
                            ,A.operation_group1 -- 셀/팩구분
                            ,A.plant_id -- 생산지
                            ,A.group_code2 -- 모델
                            ,A.item_id
                            ,A.operation_group_name
                            ,A.operation_type -- A : 외주아님, B : 외주
                            ,A.plan_qty_1 -- SCP(계획)
                            ,0 plan_qty_2
                            ,0 plan_qty_3
                            ,A.plan_cell_1
                            ,0 plan_cell_2
                            ,0 plan_cell_3
                            ,A.target_yn
                      FROM   sub3 A
                     )
                     SELECT *
                     INTO   #tmp_BASE_1
                     FROM   sub4
                     ;

                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;
					 SET @v_description  = N'Process Complete... division_id (' + @v_division_id + '), plan_start_yyyymmdd (' + @v_plan_start_yyyymmdd + ') : #tmp_BASE_1';
                     SET @d_event_date   = SYSDATETIME();
              	     
                     EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                               ,@p_log_type      = @v_log_type      
                                               ,@p_log_count     = @n_log_count       
                                               ,@p_log_message   = @v_log_message       
                                               ,@p_description   = @v_description       
                                               ,@p_event_date    = @d_event_date       
                                               ,@p_user_id       = @v_batch_user      
                                               ;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 사업부별 임시데이터(실적 & 계획) 생성 - SCM_DNM_FP_RELEASE_PROD_PLAN_SN
            -------------------------------------------------------------------------------------------------------------------------
			
                     ;WITH sub AS
                     (
					  /* 2022.12.13 주석처리 FP Plan 참조 변경  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2   
                      SELECT @v_plan_week plan_week
                            ,@v_plan_start_yyyymmdd plan_start_yyyymmdd
                            ,A.division_id
                            ,A.plant_id
                            ,A.item_id
                            ,LEFT(A.operation_id, 1) operation_group
                            ,A.operation_id
                            ,SUM(ISNULL(A.plan_qty, 0)) plan_qty
							,SUM(ISNULL(A.plan_qty, 0) * ISNULL(B.accumulated_child_qty, 1)) plan_cell
                      FROM   SCM_DNM_FP_RELEASE_PROD_PLAN_DW_SN A WITH (NOLOCK) -- dbo.SCM_DNM_FP_RELEASE_PROD_PLAN_SN
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND LEFT(A.operation_id, 1) = 'P'
                      WHERE  1 = 1
                      AND A.division_id = @v_division_id					  
                      AND A.plan_type   = 'WPP'
                      AND A.yyyyww      = REPLACE(@v_pre_plan_week, '-W', '') -- 지난 주 월요일 기준 Week값
                      AND A.plan_date   BETWEEN CAST(@v_start_yyyymmdd AS DATETIME) AND CAST(@v_end_yyyymmdd AS DATETIME)
					  AND A.plan_qty    > 0
                      GROUP BY A.division_id, A.plant_id, A.item_id, LEFT(A.operation_id, 1), A.operation_id, B.accumulated_child_qty
					  */
					  --  2022.12.13  FP Plan 참조 변경  - PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  
						SELECT @v_plan_week				AS PLAN_WEEK
							  ,@v_plan_start_yyyymmdd	AS PLAN_START_YYYYMMDD
							  ,A.DIVISION_ID
							  ,A.PLANT_ID
							  ,A.ITEM_ID
							  ,LEFT(A.OPERATION_ID, 1)	AS OPERATION_GROUP
							  ,A.OPERATION_ID
							  ,SUM(A.PLAN_QTY)										AS PLAN_QTY
							  ,SUM(A.PLAN_QTY * ISNULL(B.ACCUMULATED_CHILD_QTY,1))	AS PLAN_CELL 
						 FROM SCM_DNM_FP_RELEASE_PROD_PLAN_C A WITH(NOLOCK)
							  LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
									 ON A.DIVISION_ID	= B.DIVISION_ID
									AND A.ITEM_ID		= B.MODEL_ID
									AND A.PLANT_ID		= B.PLANT_ID
									AND A.OPERATION_ID LIKE  'P%'
						WHERE 1=1
						  AND A.YYYYMMDD	= @v_pre_plan_start_yyyymmdd -- 전주 
						  AND A.DIVISION_ID = @v_division_id
						  AND A.PLAN_DATE BETWEEN CAST(@v_start_yyyymmdd AS DATETIME) 
											  AND CAST(@v_end_yyyymmdd AS DATETIME)
						  AND A.PLAN_QTY    > 0 
						GROUP BY A.DIVISION_ID
								,A.PLANT_ID
								,A.ITEM_ID
								,A.OPERATION_ID
                     ),
                     sub1 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.division_id
							
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id in ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id in ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE') -- 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,A.operation_group
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  when A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1
                            ,A.plant_id

                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE') -- 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                            ,A.item_id
                            ,ISNULL(E.segment2, '') operation_group_name
                            ,D.operation_type
                            ,0 plan_qty_1
                            ,A.plan_qty plan_qty_2
                            ,0 plan_qty_3
                            ,0 plan_cell_1
                            ,A.plan_cell plan_cell_2
                            ,0 plan_cell_3

                            -- PJ20216891
                            -- P5000인 경우 ISUZU item(F.item_id not null)이면 Y 처리 아니면 N, 그 외 Y
                            ,CASE WHEN A.operation_id = 'P5000' AND F.item_id IS NOT NULL THEN 'Y'
                                  WHEN A.operation_id = 'P5000' AND F.item_id IS NULL THEN 'N'
                                  ELSE 'Y' END target_yn
                      FROM   sub A
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK) -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'

                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id     = B.item_id
                      AND A.division_id = B.division_id

                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id = C.division_id
                      AND A.item_id     = C.item_id

                      INNER JOIN #tmp_OPERATION_ID D
                      ON  A.operation_id = D.operation_id

                      LEFT JOIN #tmp_OPERATION_GROUP E
                      ON  A.operation_group = E.segment1

                      LEFT JOIN #tmp_ISUZU F
                      ON  A.item_id = F.item_id
                     )
                     SELECT *
                     INTO   #tmp_BASE_2
                     FROM   sub1
                     WHERE  target_yn = 'Y'
                     ;

                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;
					 SET @v_description  = N'Process Complete... division_id (' + @v_division_id + '), plan_start_yyyymmdd (' + @v_plan_start_yyyymmdd + ') : #tmp_BASE_2';
                     SET @d_event_date   = SYSDATETIME();
              	     
                     EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                               ,@p_log_type      = @v_log_type      
                                               ,@p_log_count     = @n_log_count       
                                               ,@p_log_message   = @v_log_message       
                                               ,@p_description   = @v_description       
                                               ,@p_event_date    = @d_event_date       
                                               ,@p_user_id       = @v_batch_user      
                                               ;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 사업부별 임시데이터(실적 & 계획) 생성 - SCM_DNM_PLAN_FROZEN_V
            -------------------------------------------------------------------------------------------------------------------------

                     ;WITH sub AS
                     (
                      SELECT @v_plan_week plan_week
                            ,@v_plan_start_yyyymmdd plan_start_yyyymmdd
                            ,A.division_id
                            ,A.plant_id
                            ,A.item_id
                            ,LEFT(A.operation_id, 1) operation_group
                            ,A.operation_id
                            ,SUM(ISNULL(A.plan_qty, 0)) plan_qty
							,SUM(ISNULL(A.plan_qty, 0) * ISNULL(B.accumulated_child_qty, 1)) plan_cell
                      FROM   dbo.SCM_DNM_PLAN_FROZEN_V A
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND LEFT(A.operation_id, 1) = 'P'
                      WHERE 1 = 1
                      AND A.division_id = @v_division_id
                      AND A.plan_date   BETWEEN CAST(@v_start_yyyymmdd AS DATETIME) AND CAST(@v_end_yyyymmdd AS DATETIME)
					  AND A.plan_qty    > 0
                      GROUP BY A.division_id, A.plant_id, A.item_id, LEFT(A.operation_id, 1), A.operation_id

                      UNION ALL

                      SELECT @v_plan_week plan_week
                            ,@v_plan_start_yyyymmdd plan_start_yyyymmdd
                            ,A.division_id
                            ,A.operation_id plant_id
                            ,A.item_id
                            ,A.operation_group
                            ,A.operation_id
                            ,SUM(ISNULL(A.prod_qty, 0)) plan_qty
							,SUM(ISNULL(A.prod_qty, 0) * A.accumulated_child_qty) plan_cell
                      FROM #tmp_SCM_DNM_SCS_PROD_RESULT A
                      WHERE  1 = 1
                      AND A.division_id = @v_division_id
                      AND A.data_type = 'A'
                      GROUP BY A.division_id, A.operation_id, A.item_id, A.operation_group, A.accumulated_child_qty
                     ),
                     sub1 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.division_id
							
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id in ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id in ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE') -- 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,A.operation_group
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  WHEN A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1
                            ,A.plant_id

                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE') -- 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                            ,A.item_id
                            ,ISNULL(E.segment2, '') operation_group_name
                            ,D.operation_type
                            ,0 plan_qty_1
                            ,0 plan_qty_2
                            ,A.plan_qty plan_qty_3
                            ,0 plan_cell_1
                            ,0 plan_cell_2
                            ,A.plan_cell plan_cell_3
							
                            -- PJ20216891
                            -- P5000인 경우 ISUZU item(F.item_id not null)이면 Y 처리 아니면 N, 그 외 Y
                            ,CASE WHEN A.operation_id = 'P5000' AND F.item_id IS NOT NULL THEN 'Y'
                                  WHEN A.operation_id = 'P5000' AND F.item_id IS NULL THEN 'N'
                                  ELSE 'Y' END target_yn
                      FROM   sub A
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK) -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'

                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id     = B.item_id
                      AND A.division_id = B.division_id

                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id = C.division_id
                      AND A.item_id     = C.item_id

                      INNER JOIN #tmp_OPERATION_ID D
                      ON  A.operation_id = D.operation_id

                      LEFT JOIN #tmp_OPERATION_GROUP E
                      ON  A.operation_group = E.segment1
					  
                      LEFT JOIN #tmp_ISUZU F
                      ON  A.item_id = F.item_id
                     )
                     SELECT *
                     INTO #tmp_BASE_3
                     FROM  sub1
                     WHERE target_yn = 'Y'
                     ;

                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;
					 SET @v_description  = N'Process Complete... division_id (' + @v_division_id + '), plan_start_yyyymmdd (' + @v_plan_start_yyyymmdd + ') : #tmp_BASE_3';
                     SET @d_event_date   = SYSDATETIME();
              	     
                     EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                               ,@p_log_type      = @v_log_type      
                                               ,@p_log_count     = @n_log_count       
                                               ,@p_log_message   = @v_log_message       
                                               ,@p_description   = @v_description       
                                               ,@p_event_date    = @d_event_date       
                                               ,@p_user_id       = @v_batch_user      
                                               ;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 실테이블(SCP_RPT_PRODUCTION_TEST)에 저장
            -------------------------------------------------------------------------------------------------------------------------
                     ;WITH sub AS
                     (
						 -- 2023.03.31 HM JV 가상 사업부 추가 대응
						 SELECT PP.*
							   ,CASE WHEN DM.ATTRIBUTE3 = '81'  
									 THEN 'A'
									 ELSE 'B' 
								 END AS DIVISION_TYPE 
						   FROM (SELECT *
								   FROM #tmp_BASE_1
								  UNION ALL
								 SELECT *
								   FROM #tmp_BASE_2
								  UNION ALL
								 SELECT *
								   FROM #tmp_BASE_3
								) PP INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)
											 ON DM.DIVISION_ID = PP.DIVISION_ID
											AND DM.VALID_YN	   = 'Y'
                     ),
                     sub1 AS
                     (
					 /*-----  2022.12.13 begin  자동차 case 처리 쿼리 주석처리 
					   --- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2  -> 소형과 동일하게 scp plan과 실적 비교 적용
                      -- 자동차(division_type = A)인 경우 fp(plan_qty_2)와 실적(plan_qty_3)을 비교함
                      SELECT plan_start_yyyymmdd
                            ,plan_week
                            ,division_id
                            ,ISNULL(segment2, '-') cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ESS는 비워 둠)
                            ,operation_group
                            ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                            ,operation_group_name
                            ,ISNULL(group_code2, item_id) model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대 표모델 Nickname)
                            ,SUM(ISNULL(plan_qty_1, 0)) prod_plan_scp -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(ISNULL(plan_qty_2, 0)) prod_plan_fp -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 

                            --,CASE WHEN SUM(ISNULL(plan_qty_2, 0)) >= SUM(ISNULL(plan_qty_3, 0)) THEN SUM(ISNULL (plan_qty_3, 0))
                            --      ELSE SUM(ISNULL(plan_qty_2, 0)) END prod_result
                           -- 외주물량이면(operation_type = 'B') plan_qty_1와 plan_qty_3을 비교 아니면 plan_qty_2와 plan_qty_3을 비교
                            ,CASE WHEN operation_type = 'A' THEN CASE WHEN SUM(ISNULL(plan_qty_2, 0)) >= SUM(ISNULL(plan_qty_3, 0)) THEN SUM(ISNULL(plan_qty_3, 0))
                                                                      ELSE SUM(ISNULL(plan_qty_2, 0)) END
                                  ELSE CASE WHEN SUM(ISNULL(plan_qty_1, 0)) >= SUM(ISNULL(plan_qty_3, 0)) THEN SUM(ISNULL(plan_qty_3, 0))
                                            ELSE SUM(ISNULL(plan_qty_1, 0)) END END prod_result

                            ,SUM(ISNULL(plan_qty_3, 0)) prod_result_tot -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                            ,SUM(ISNULL(plan_cell_1, 0)) prod_plan_scp_cell -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(ISNULL(plan_cell_2, 0)) prod_plan_fp_cell -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 

                            --,CASE WHEN SUM(ISNULL(plan_cell_2, 0)) >= SUM(ISNULL(plan_cell_3, 0)) THEN SUM(ISNULL (plan_cell_3, 0))
                            --      ELSE SUM(ISNULL(plan_cell_2, 0)) END prod_result_cell
                           -- 외주물량이면(operation_type = 'B') plan_cell_1와 plan_cell_3을 비교 아니면 plan_cell_2와 plan_cell_3을 비교
                            ,CASE WHEN operation_type = 'A' THEN CASE WHEN SUM(ISNULL(plan_cell_2, 0)) >= SUM(ISNULL(plan_cell_3, 0)) THEN SUM(ISNULL(plan_qty_3, 0))
                                                                      ELSE SUM(ISNULL(plan_cell_2, 0)) END
                                  ELSE CASE WHEN SUM(ISNULL(plan_cell_1, 0)) >= SUM(ISNULL(plan_cell_3, 0)) THEN SUM(ISNULL(plan_cell_3, 0))
                                            ELSE SUM(ISNULL(plan_cell_1, 0)) END END prod_result_cell
                            ,SUM(ISNULL(plan_cell_3, 0)) prod_result_tot_cell -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                      FROM   sub
					  WHERE  operation_group IN ('A', 'P')
                      AND    division_type = 'A'
                      GROUP BY plan_week, plan_start_yyyymmdd, division_id, ISNULL(segment2, '-'), operation_group,  plant_id, operation_group_name, ISNULL(group_code2, item_id), operation_type
					  
                      UNION ALL
					 ------------------------------------- 2022.12.13 end */

                      -- 나머지(division_type = B)인 경우 scp(plan_qty_1)와 실적(plan_qty_3)을 비교함
                      SELECT plan_start_yyyymmdd
                            ,plan_week
                            ,division_id
                            ,ISNULL(segment2, '-') cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ESS는 비워 둠)
                            ,operation_group
                            ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                            ,operation_group_name
                            ,ISNULL(group_code2, item_id) model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대 표모델 Nickname)
                            ,SUM(ISNULL(plan_qty_1, 0)) prod_plan_scp -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(ISNULL(plan_qty_2, 0)) prod_plan_fp -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(ISNULL(plan_qty_1, 0)) >= SUM(ISNULL(plan_qty_3, 0)) THEN SUM(ISNULL (plan_qty_3, 0))
                                  ELSE SUM(ISNULL(plan_qty_1, 0)) END prod_result
                            ,SUM(ISNULL(plan_qty_3, 0)) prod_result_tot -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                            ,SUM(ISNULL(plan_cell_1, 0)) prod_plan_scp_cell -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(ISNULL(plan_cell_2, 0)) prod_plan_fp_cell -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(ISNULL(plan_cell_1, 0)) >= SUM(ISNULL(plan_cell_3, 0)) THEN SUM(ISNULL (plan_cell_3, 0))
                                  ELSE SUM(ISNULL(plan_cell_1, 0)) END prod_result_cell
                            ,SUM(ISNULL(plan_cell_3, 0)) prod_result_tot_cell -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                      FROM   sub
					  WHERE  operation_group IN ('A', 'P')
                      -- 2022.12.13 주석처리 :  전사업부 모두 scp plan과 실적 비교적용  AND    division_type = 'B'
                      GROUP BY plan_week, plan_start_yyyymmdd, division_id, ISNULL(segment2, '-'), operation_group, plant_id, operation_group_name, ISNULL(group_code2, item_id), operation_type
                     )
                     INSERT INTO dbo.SCP_RPT_PRODUCTION WITH (TABLOCK)
                     (
                       plan_start_yyyymmdd
                      ,plan_week
                      ,division_id
                      ,cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ess는 비워둠)
                      ,operation_group
                      ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                      ,operation_group_name
                      ,model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대표모델 Nickname)                      
                      ,prod_plan_scp
                      ,prod_plan_fp
                      ,prod_result
                      ,prod_result_tot
                      ,prod_plan_scp_cell
                      ,prod_plan_fp_cell
                      ,prod_result_cell
                      ,prod_result_tot_cell
                      ,created_by
                      ,creation_date
                      ,last_updated_by
                      ,last_update_date
					  ,reason_code			-- 2023.05.23 ui 입력 reason code 
					  ,reason_description	-- 2023.05.23 ui 입력 reason description 
					  ,attribute9			-- (ui)last_update_date
					  ,attribute10			-- (ui)last_updated_by 
                     )
                     SELECT B.plan_start_yyyymmdd
                           ,B.plan_week
                           ,B.division_id
                           ,B.cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ess는 비워둠)
                           ,B.operation_group
                           ,B.plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                           ,B.operation_group_name
                           ,B.model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대표모델 Nickname)
                           ,B.prod_plan_scp
                           ,B.prod_plan_fp
                           ,B.prod_result
                           ,B.prod_result_tot
                           ,B.prod_plan_scp_cell
                           ,B.prod_plan_fp_cell
                           ,B.prod_result_cell
                           ,B.prod_result_tot_cell
                           ,@v_batch_user
                           ,GETDATE()
                           ,@v_batch_user
                           ,GETDATE()
						   -- begin  2023.05.23 PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Reason 정보 유지 기능 추가
						   ,BF.REASON_CODE
						   ,BF.REASON_DESCRIPTION
						   ,CASE WHEN BF.PLAN_START_YYYYMMDD IS NOT NULL AND BF.CREATION_DATE != BF.LAST_UPDATE_DATE
								 THEN CONVERT(NVARCHAR(20), BF.LAST_UPDATE_DATE, 120) 
								 ELSE BF.ATTRIBUTE9
							END	  AS ATTRIBUTE9 
						   ,CASE WHEN BF.PLAN_START_YYYYMMDD IS NOT NULL AND BF.CREATION_DATE != BF.LAST_UPDATE_DATE
								 THEN BF.LAST_UPDATED_BY 
								 ELSE BF.ATTRIBUTE10
							END	  AS ATTRIBUTE10 
						   -- end  2023.05.23 PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Reason 정보 유지 기능 추가
                     FROM   sub1 B
							LEFT JOIN #tmp_SCP_RPT_PRODUCTION_BEFORE BF  -- 2023.05.23 PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Reason 정보 유지 기능 추가 
								   ON BF.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
								  AND BF.PLAN_WEEK			 = B.PLAN_WEEK			
								  AND BF.DIVISION_ID		 = B.DIVISION_ID		
								  AND BF.CELL_TYPE_GR		 = B.CELL_TYPE_GR		
								  AND BF.OPERATION_GROUP	 = B.OPERATION_GROUP	
								  AND BF.PLANT_ID			 = B.PLANT_ID			
								  AND BF.MODEL_TYPE_GR		 = B.MODEL_TYPE_GR		
                     ;

                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;
					 SET @v_description  = N'Process Complete... division_id (' + @v_division_id + '), plan_start_yyyymmdd (' + @v_plan_start_yyyymmdd + ') : SCP_RPT_PRODUCTION';
                     SET @d_event_date   = SYSDATETIME();
              	     
                     EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                               ,@p_log_type      = @v_log_type      
                                               ,@p_log_count     = @n_log_count       
                                               ,@p_log_message   = @v_log_message       
                                               ,@p_description   = @v_description       
                                               ,@p_event_date    = @d_event_date       
                                               ,@p_user_id       = @v_batch_user      
                                               ;

                     IF OBJECT_ID('tempdb..#tmp_BASE_1') IS NOT NULL
                         DROP TABLE #tmp_BASE_1;
   			         
                     IF OBJECT_ID('tempdb..#tmp_BASE_2') IS NOT NULL
                         DROP TABLE #tmp_BASE_2;
   			         
                     IF OBJECT_ID('tempdb..#tmp_BASE_3') IS NOT NULL
                         DROP TABLE #tmp_BASE_3;


				 END
             END

            -------------------------------------------------------------------------------------------------------------         
            -- 임시테이블 제거
            -------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#tmp_BASE_1') IS NOT NULL
                 DROP TABLE #tmp_BASE_1;
   
             IF OBJECT_ID('tempdb..#tmp_BASE_2') IS NOT NULL
                 DROP TABLE #tmp_BASE_2;
   
             IF OBJECT_ID('tempdb..#tmp_BASE_3') IS NOT NULL
                 DROP TABLE #tmp_BASE_3;
   
             IF OBJECT_ID('tempdb..#tmp_OPERATION_ID') IS NOT NULL
                 DROP TABLE #tmp_OPERATION_ID;

             IF OBJECT_ID('tempdb..#tmp_OPERATION_GROUP') IS NOT NULL
                 DROP TABLE #tmp_OPERATION_GROUP;
   
             IF OBJECT_ID('tempdb..#tmp_CELL_TYPE_GROUP') IS NOT NULL
                 DROP TABLE #tmp_CELL_TYPE_GROUP;

             IF OBJECT_ID('tempdb..#tmp_DIVISION_ID') IS NOT NULL
                 DROP TABLE #tmp_DIVISION_ID;

             IF OBJECT_ID('tempdb..#tmp_MST_FINAL_ITEM') IS NOT NULL
                 DROP TABLE #tmp_MST_FINAL_ITEM;

             IF OBJECT_ID('tempdb..#tmp_SCM_DNM_SCS_PROD_RESULT') IS NOT NULL
                 DROP TABLE #tmp_SCM_DNM_SCS_PROD_RESULT;

             IF OBJECT_ID('tempdb..#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V') IS NOT NULL
                 DROP TABLE #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V;

             IF OBJECT_ID('tempdb..#tmp_ISUZU') IS NOT NULL
                 DROP TABLE #tmp_ISUZU;
				 
             IF OBJECT_ID('tempdb..#tmp_SCP_RPT_PRODUCTION_BEFORE') IS NOT NULL  -- 2023.05.23 PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Reason 정보 유지 기능 추가 
                 DROP TABLE #tmp_SCP_RPT_PRODUCTION_BEFORE;

        --IF @@TRANCOUNT > 0      
        --  BEGIN      
        --    COMMIT TRAN T1;      
        --  END;             
      
      
        -- TXN LOG      
        SET @v_log_type     = N'TXN';        
        SET @n_log_count    = @@ROWCOUNT;      
        SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
        SET @v_description  = N'Process Complete...' + ':' + CONVERT(CHAR(8), @d_event_date, 112);      
        SET @d_event_date   = SYSDATETIME();      
      
        EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                  ,@p_log_type      = @v_log_type      
                                  ,@p_log_count     = @n_log_count       
                                  ,@p_log_message   = @v_log_message       
                                  ,@p_description   = @v_description       
                                  ,@p_event_date    = @d_event_date       
                                  ,@p_user_id       = @v_batch_user      
                                  ;            
      
    END      
    END TRY      
      
    BEGIN CATCH      
      --IF @@TRANCOUNT > 0      
      --  BEGIN      
      --    ROLLBACK TRAN T1      
      --  END;      
            
      -- ERROR LOG      
      SET @v_log_type     = N'ERROR';      
      SET @v_log_message  = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));      
      SET @v_description  = @v_program_name + N'ERROR_LINE : ' + STR(ERROR_LINE());      
      SET @d_event_date   = SYSDATETIME();      
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                                ,@p_log_type      = @v_log_type      
                                ,@p_log_count     = @n_log_count       
                                ,@p_log_message   = @v_log_message       
                                ,@p_description   = @v_description       
                                ,@p_event_date    = @d_event_date       
                                ,@p_user_id       = @v_batch_user      
                                ;      
--      PRINT @@ERROR      
      return -1      
    END CATCH;      
      
  
  
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +     
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))     
       
    -- 종료 LOG          
    SET @v_log_type     = N'END';          
    SET @v_log_message  = N'########## END of procedure ##########';          
    SET @v_description  = N'[' + @v_program_name + '][' + @v_exec_time + '], division_id (' + @v_division_id + '), plan_start_yyyymmdd (' + @v_plan_start_yyyymmdd + ')';
    SET @d_event_date   = SYSDATETIME()  ;     
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name      
                              ,@p_log_type      = @v_log_type      
                              ,@p_log_count     = @n_log_count       
                              ,@p_log_message   = @v_log_message       
                              ,@p_description   = @v_description       
                              ,@p_event_date    = @d_event_date       
                              ,@p_user_id       = @v_batch_user      
                              ;      
    return 1   
	
    _RETURN_ERR_CODE:                  
        BEGIN                  
             RETURN -1                  
        END; 
		
  END;       
  
  


