

/*      
 * Program ID   : PR_SCP_RPT_SHIPMENT
 * Description  : PR_SCP_RPT_SHIPMENT
 * OutTable     :      
 * Execute      : 

 
    SELECT * FROM SCM_SYS_LOG_BATCH with (nolock)  where [PROGRAM_NAME] ='PR_SCP_RPT_SHIPMENT' order by CREATION_DATE desc

 * Program History      
 *===================================================================================================      
 *   Date       In Charge      Description      
 *===================================================================================================      
 * 2021.11.24   sclee.lee      PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 : Report
 * 2022.01.04   sclee.lee      외주물량은 ESS만 (division_id = 82) 포함하도록 변경
 * 2022.03.25   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.06.08   KSG            PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - AS Plant 출하 제외
 * 2022.07.05   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 법인간 실적, PJT Code 추가 (ESS만 적용)
 * 2022.08.11   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - to_site가 loockup : AS_SITE_PLANT segment2에 등록된 site면 segment1로 치환, 그외 사이트는 그대로 표시목적
 * 2022.09.05   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 일별데이터 생성구문 추가
 * 2022.11.01   hrkim		   PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 소형 외주 Packer 물량 추가(계획/실적)
 * 2022.12.12   hrkim		   PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS) 
 * 2023.03.31   hrkim		   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */    


CREATE PROCEDURE [dbo].[PR_SCP_RPT_SHIPMENT]
(           
  @p_plan_start_yyyymmdd           NVARCHAR(150) = NULL
)
AS        
  BEGIN      
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;      
    SET NOCOUNT ON;

      
    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'SCP_batch';
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_RPT_SHIPMENT';      
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...      
    DECLARE @n_log_count    INTEGER = 0;      
    DECLARE @v_log_message  NVARCHAR(1000);      
    DECLARE @v_description  NVARCHAR(500);    
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_RPT_SHIPMENT';
    DECLARE @v_table_id1    NVARCHAR(150) = N'SCP_RPT_SHIPMENT_DETAIL';
    DECLARE @d_event_date   DATETIME;    
    DECLARE @v_plan_start_yyyymmdd VARCHAR(8);     -- Data 생성 주차
    DECLARE @v_pre_plan_start_yyyymmdd VARCHAR(8); -- SCP Plan 정보 주차

    -- 로직 실행관련 변수 설정
	IF ISNULL(@p_plan_start_yyyymmdd, '') = ''  -- 당주 정보 생성
        SET @v_plan_start_yyyymmdd      = CONVERT(CHAR(8), DATEADD(DD, -7*1, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일
	ELSE
        SET @v_plan_start_yyyymmdd      = @p_plan_start_yyyymmdd
	
    SET @v_pre_plan_start_yyyymmdd  = CONVERT(CHAR(8), DATEADD(DD, -7, CONVERT(DATETIME, @v_plan_start_yyyymmdd)), 112); -- 전주 월요일

    DECLARE @v_start_yyyymmdd          VARCHAR(8) = @v_plan_start_yyyymmdd; -- 당주 월요일
    DECLARE @v_end_yyyymmdd            VARCHAR(8) = FORMAT(DATEADD(dd, 6, CAST(@v_start_yyyymmdd AS DATETIME)), 'yyyyMMdd'); -- 당주 일요일
    DECLARE @v_yyyyww                  VARCHAR(6);
    DECLARE @v_plan_week               VARCHAR(8);
    DECLARE @v_division_id             NVARCHAR(30);
    DECLARE @v_total_loop_cnt          INT;
    DECLARE @v_cur_loop_cnt            INT = 0;
    DECLARE @v_day_total_loop_cnt      INT = 7;
    DECLARE @v_day_cur_loop_cnt        INT = 0;
	
    DECLARE @v_tb_daily TABLE
    (
      rowidx                           INT IDENTITY(1,1)
     ,yyyymmdd                         VARCHAR(8)
    );

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

             IF OBJECT_ID('tempdb..#tmp_BASE_4') IS NOT NULL  -- PJ20216994 11/1 소형 외주 Packer SCS 실적 추가 
                 DROP TABLE #tmp_BASE_4;

             IF OBJECT_ID('tempdb..#tmp_OPERATION_GROUP') IS NOT NULL
                 DROP TABLE #tmp_OPERATION_GROUP;
   
             IF OBJECT_ID('tempdb..#tmp_CELL_TYPE_GROUP') IS NOT NULL
                 DROP TABLE #tmp_CELL_TYPE_GROUP;

             IF OBJECT_ID('tempdb..#tmp_SCM_MST_SITE') IS NOT NULL
                 DROP TABLE #tmp_SCM_MST_SITE;

             IF OBJECT_ID('tempdb..#tmp_SSP_KPI_SPA_OTD1_C') IS NOT NULL
                 DROP TABLE #tmp_SSP_KPI_SPA_OTD1_C;

             IF OBJECT_ID('tempdb..#tmp_DIVISION_ID') IS NOT NULL
                 DROP TABLE #tmp_DIVISION_ID;

             IF OBJECT_ID('tempdb..#tmp_MST_FINAL_ITEM') IS NOT NULL
                 DROP TABLE #tmp_MST_FINAL_ITEM;

             IF OBJECT_ID('tempdb..#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V') IS NOT NULL
                 DROP TABLE #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 값 할당 / 임시테이블 생성
            -------------------------------------------------------------------------------------------------------------------------
             WHILE(@v_day_cur_loop_cnt < @v_day_total_loop_cnt)
             BEGIN
                 -- 당주의 일별데이터 생성을 위해 데아터 생성대상일자 지정
                 INSERT INTO @v_tb_daily (yyyymmdd)
                 SELECT FORMAT(DATEADD(dd, @v_day_cur_loop_cnt, CAST(@v_start_yyyymmdd AS DATETIME)), 'yyyyMMdd')
                 
                 SET @v_day_cur_loop_cnt += 1;
             END
			
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
             AND B2.lookup_type = 'CELL_TYPE_GROUP_CODE'
             AND B2.valid_yn = 'Y'
             ;

             SELECT division_id
                   ,model_id
                   ,plant_id
                   ,accumulated_child_qty
             INTO   #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V
             FROM   dbo.SCM_MST_MODEL_FINAL_ITEM_BOM_V WITH (NOLOCK)
             WHERE  operation_group_id = 'A'
             ;

             SELECT division_id
                   ,scm_site_id
                   ,plant_id
                   ,site_type
                   ,operation_group
             INTO   #tmp_SCM_MST_SITE
             FROM   dbo.SCM_MST_SITE WITH (NOLOCK)
             ;

             -- 계획/실적 생성 일자 : 금주
             SELECT @v_plan_week = calendar_yyyy + '-' + week_name
             FROM   dbo.SCM_SYS_CALENDAR_M WITH (NOLOCK)
             WHERE  basis_yyyymmdd = @v_plan_start_yyyymmdd -- 금주 월요일
             ;

             ;WITH sub AS
             (
              SELECT A.division_id
                    ,@v_plan_week plan_week
                    ,@v_plan_start_yyyymmdd plan_start_yyyymmdd
                    ,ISNULL(A.operation_group, '-') operation_group
                    ,ISNULL(B.plant_id, '-') plant_id
                    ,ISNULL(A.from_site, '-') from_scm_site_id

                    -- to_scm_site_id가 loockup : AS_SITE_PLANT.segment2에 등록된 site면 segment1로 치환
                  --   ,A.to_site to_scm_site_id
                    ,ISNULL(E.segment1, A.to_site) to_scm_site_id
                    ,A.item_id
                    ,A.yyyymmdd
                    ,ISNULL(A.plan_qty, 0) plan_qty
                    --,CASE WHEN ISNULL(A.plan_qty, 0) > 0 THEN 'Y'
                    --      ELSE 'N' END targetyn

					-- 외주물량은 ESS만 포함
					-- PJ20216994 11/1 소형 외주 물량 포함
                    ,CASE WHEN A.division_id NOT IN ('82', '40') AND LEN(ISNULL(B.plant_id, '-')) > 4 THEN 'N'
                          WHEN ISNULL(A.plan_qty, 0) <= 0 THEN 'N'
                          ELSE 'Y' END targetyn

                    -- PJ20216994 (2022.07.05)
					-- ESS 만 project_code 추가, (TBD도 project_code로서 의미없는 값이므로 '-'처리)
                    ,IIF(A.DIVISION_ID = '82', IIF(D.project_code IS NULL OR D.project_code = 'TBD', '-', D.project_code), '-') project_code
              FROM dbo.SSP_KPI_SPA_OTD1_C A WITH (NOLOCK)
              LEFT JOIN #tmp_SCM_MST_SITE B
              ON  A.division_id = B.division_id
              AND A.from_site   = B.scm_site_id
              INNER JOIN #tmp_SCM_MST_SITE C
              ON  A.division_id = C.division_id
              AND A.to_site     = C.scm_site_id
			  
              -- PJ20216994 (2022.07.05)
              -- AND C.site_type = 'SALES'
              AND C.site_type   IN ('PLANT', 'SALES')
              LEFT OUTER JOIN dbo.SSP_ANL_SHIP_CONFIRM D WITH (NOLOCK)
              ON  A.division_id = D.division_id
              AND A.confirm_id  = D.confirm_id

              -- PJ20216994 (2022.08.11)
              --  to_site가 loockup : AS_SITE_PLANT segment2에 등록된 site면 segment1로 치환, 그외 사이트는 그대로 표시목적
              LEFT JOIN (
                         SELECT SEGMENT1
                               ,SEGMENT2
                         FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                         WHERE  1 = 1
                           AND  LOOKUP_TYPE = 'AS_SITE_PLANT'
                        ) E
              ON  A.to_site = E.segment2
              WHERE   1 = 1
              AND A.version_type = 'PLAN'
              AND A.yyyymmdd BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
			  AND ISNULL(B.operation_group, '') <> 'W' --  20220608 PJ20216891 AS Plant 출하 제외
			  AND A.CONFIRM_ID NOT LIKE 'R%' -- PJ20216994 11/3 소형 Packer SSP 계획 제외 (현재는 없으나 추후 A에 소형 packer 계획이 추가될 시 아래 union all 결과와 중복 방지를 위해 조건 추가) 

			  -- PJ20216994 11/3 소형 Packer SSP 계획 추가 
			UNION ALL 
			SELECT SC.DIVISION_ID
                    ,@v_plan_week			AS PLAN_WEEK
                    ,@v_plan_start_yyyymmdd AS PLAN_START_YYYYMMDD
				  ,FI.OPERATION_GROUP
				  ,FS.PLANT_ID
				  ,SC.FROM_SITE						AS FROM_SCM_SITE_ID
				  ,ISNULL(ASP.SEGMENT1, SC.TO_SITE)	AS TO_SCM_SITE_ID
				  ,SC.ITEM_ID
				  ,SC.YYYYMMDD
				  ,SC.QTY
				  ,'Y'			AS TARGETYN
				  ,'-'			AS PROJECT_CODE
			 FROM SSP_ANL_SHIP_CONFIRM SC WITH(NOLOCK)
				  INNER JOIN SCP_MST_FINAL_ITEM FI WITH(NOLOCK)
						  ON FI.DIVISION_ID = SC.DIVISION_ID
						 AND FI.ITEM_ID     = SC.ITEM_ID 
				  INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)
						  ON TS.DIVISION_ID = SC.DIVISION_ID
						 AND TS.SCM_SITE_ID = SC.TO_SITE
						 AND TS.SITE_TYPE IN ('SALES', 'PLANT')
				  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK)
						  ON FS.DIVISION_ID = SC.DIVISION_ID
						 AND FS.SCM_SITE_ID = SC.FROM_SITE
						 AND FS.OSP_YN = 'Y'
				  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  ASP WITH(NOLOCK) 
					      ON ASP.LOOKUP_TYPE = 'AS_SITE_PLANT'
						 AND ASP.SEGMENT2    = SC.TO_SITE
						 AND ASP.VALID_YN    = 'Y'
			WHERE 1=1
			  AND SC.DIVISION_ID = '40' 
			  AND SC.YYYYMMDD BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
			  AND SC.CONFIRM_ID LIKE 'R%' -- 소형 Packer 계획 
			  AND SC.CHANGE_TYPE = 'C'
			  AND SC.QTY > 0 
			  AND ISNULL(FS.OPERATION_GROUP, '') != 'W'
             )
             SELECT A.*
             INTO  #tmp_SSP_KPI_SPA_OTD1_C
             FROM   sub A
             WHERE  1 = 1
             AND A.targetyn = 'Y'
             ;

             SELECT D.division_id
                   ,P.plan_name
                   ,D.plan_id
                   ,D.plan_type
                   ,MAX(D.plan_seq) AS plan_seq
                   ,ROW_NUMBER() OVER (PARTITION BY D.division_id ORDER BY D.plan_id DESC) AS RN
                   ,DENSE_RANK() OVER (ORDER BY D.division_id ASC) AS RowIdx
             INTO   #tmp_DIVISION_ID
             FROM   dbo.SCM_MST_PLAN_DETAIL D WITH(NOLOCK)
					INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)  -- 2023.03.31 HM JV 가상 사업부 추가 대응
							ON DM.DIVISION_ID = D.DIVISION_ID
						   AND DM.VALID_YN	  = 'Y'
             INNER JOIN dbo.SCM_MST_PLAN P WITH(NOLOCK)
             ON  D.division_id = P.division_id
             AND D.plan_id = P.plan_id
             AND D.plan_status   = '1'
             AND D.confirm_flag  = 'Y'
             AND D.PLAN_TYPE     = 'FN'

             -- PJ20216891
             -- AND D.division_id  <> 'EE'
             -- 2023.03.31 HM JV AND D.division_id   NOT IN ('EE', 'EE_UC')
			 AND DM.ATTRIBUTE3 != 'EE'  -- 2023.03.31 HM JV 가상 사업부 추가 대응
             AND p.plan_name = @v_pre_plan_start_yyyymmdd  -- 지난 주 Final 기준 SCP 계획
             GROUP BY D.division_id, P.plan_name, D.plan_id, D.plan_type
             ;

             SET @v_total_loop_cnt = @@ROWCOUNT;

            -------------------------------------------------------------------------------------------------------------------------         
            -- 사업부별 임시데이터(실적 & 계획) 생성
            -------------------------------------------------------------------------------------------------------------------------

             IF(@v_total_loop_cnt > 0)
             BEGIN			 
                 BEGIN TRAN

                 -- 기존내역부터 지우고 시작
                 -- DELETE dbo.SCP_RPT_SHIPMENT WHERE division_id = @v_division_id AND plan_start_yyyymmdd = @v_plan_start_yyyymmdd;
                 WHILE(1 = 1)
                 BEGIN
                     DELETE TOP (10000) A
                     FROM dbo.SCP_RPT_SHIPMENT A
                     WHERE plan_start_yyyymmdd = @v_plan_start_yyyymmdd
           
                     IF(@@ROWCOUNT = 0)
                     BEGIN
                         BREAK;
                     END
                 END
				 
                 WHILE(1 = 1)
                 BEGIN
                     DELETE TOP (10000) A
                     FROM dbo.SCP_RPT_SHIPMENT_DETAIL A
                     WHERE plan_start_yyyymmdd = @v_plan_start_yyyymmdd
           
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
            -- 사업부별 임시데이터(실적 & 계획) 생성 - SCP_ANL_SHIPMENT_PLAN_FG
            -------------------------------------------------------------------------------------------------------------------------

					 SELECT @v_division_id = division_id
					 FROM   #tmp_DIVISION_ID
					 WHERE  RowIdx = @v_cur_loop_cnt
					 ;

                     ;WITH sub AS
                     (
                      SELECT A.division_id
                            ,@v_plan_start_yyyymmdd AS plan_start_yyyymmdd
                            ,ISNULL(A.biz_type, '-') operation_group
                            ,ISNULL(B.plant_id, '-') plant_id
                            ,ISNULL(A.from_site, '-') from_scm_site_id
                            ,A.to_site to_scm_site_id
                            ,A.item_id
                            ,A.yyyymmdd
                            ,A.qty
                            ,@v_plan_week plan_week
                            --,CASE WHEN ISNULL(A.qty, 0) > 0 THEN 'Y'
                            --      ELSE 'N' END targetyn

                            -- 외주물량은 ESS만 포함
							-- PJ20216994 11/1 소형 외주 물량 포함 
                            ,CASE WHEN A.division_id NOT IN ('82','40')  AND LEN(ISNULL(B.plant_id, '-')) > 4 THEN 'N'
                                  WHEN ISNULL(A.qty, 0) <= 0 THEN 'N'
                                  ELSE 'Y' END targetyn

                            -- PJ20216994 (2022.07.05)
					        -- ESS 만 project_code 추가, (TBD도 project_code로서 의미없는 값이므로 '-'처리)
                            ,IIF(A.DIVISION_ID = '82', IIF(A.project_code IS NULL OR A.project_code = 'TBD', '-', A.project_code), '-') project_code
                      FROM   dbo.SCP_ANL_SHIPMENT_PLAN_FG A WITH (NOLOCK)
                      LEFT OUTER JOIN #tmp_SCM_MST_SITE B
                      ON  A.division_id = B.division_id
                      AND A.from_site   = B.scm_site_id
                      INNER JOIN #tmp_DIVISION_ID C
                      ON  A.division_id = C.division_id
                      AND A.plan_start_yyyymmdd = C.plan_name
                      AND A.plan_type = C.plan_type
                      AND A.seq = C.plan_seq
                      WHERE   1 = 1
                      AND A.division_id = @v_division_id
                      AND A.measure = 'SHIP_PLAN_AMEND'
                      AND A.yyyymmdd BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
					  AND ISNULL(B.operation_group, '') <> 'W' --  20220608 PJ20216891 AS Plant 출하 제외
					  
                      UNION ALL

                      SELECT A.division_id
                            ,@v_plan_start_yyyymmdd AS plan_start_yyyymmdd
                            ,A.operation_group
                            ,ISNULL(B.plant_id, '-') plant_id
                            ,ISNULL(A.from_site, '-') from_scm_site_id
                            ,A.to_site to_scm_site_id
                            ,A.item_id
                            ,A.yyyymmdd
                            ,A.qty
                            ,@v_plan_week plan_week
                            --,CASE WHEN ISNULL(A.qty, 0) > 0 THEN 'Y'
                            --      ELSE 'N' END targetyn

							-- PJ20216994외주물량은 ESS만 포함
							-- PJ20216994 11/1 소형 외주 물량 포함 
                            ,CASE WHEN A.division_id NOT IN ('82','40')  AND LEN(ISNULL(B.plant_id, '-')) > 4 THEN 'N'
                                  WHEN ISNULL(A.qty, 0) <= 0 THEN 'N'
                                  ELSE 'Y' END targetyn

                            -- PJ20216994 (2022.07.05)
					        -- SCP_ANL_SHIPMENT_PLAN_SEMI는 project_code 컬럼이 없으므로 '-'처리
                            ,'-' project_code
                      FROM   dbo.SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
                      LEFT OUTER JOIN #tmp_SCM_MST_SITE B
                      ON  A.division_id = B.division_id
                      AND A.from_site   = B.scm_site_id
                      INNER JOIN #tmp_DIVISION_ID C
                      ON  A.division_id = C.division_id
                      AND A.plan_start_yyyymmdd = C.plan_name
                      AND A.plan_type = C.plan_type
                      AND A.seq = C.plan_seq
                      WHERE   1 = 1
                      AND A.division_id = @v_division_id
                      AND A.measure = 'SHIP_PLAN_AMEND'
                      AND A.yyyymmdd BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
					  AND ISNULL(B.operation_group, '') <> 'W' --  20220608 PJ20216891 AS Plant 출하 제외
                     ),
                     sub1 AS
                     (
                      SELECT A.*
					  
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')   -- (소형,전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  WHEN A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1

                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')   -- (소형,전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                      FROM   sub A
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)  -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'
                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id = B.item_id
                      AND A.division_id = B.division_id
                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id = C.division_id
                      AND A.ITEM_ID = C.ITEM_ID
					  WHERE   1 = 1
                      AND A.targetyn = 'Y'
                     ),
                     sub2 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.operation_group
                            ,A.item_id
                            ,SUM(A.qty) plan_qty_1
                            ,SUM(ISNULL(A.qty, 0) * ISNULL(B.accumulated_child_qty, 1)) plan_cell_1
                            ,A.division_id
                            ,A.segment2
                            ,A.operation_group1
                            ,ISNULL(A.group_code2, '') group_code2
                            ,A.plant_id
							,A.from_scm_site_id
							,A.to_scm_site_id
                            ,ISNULL(C.segment2, '') operation_group_name
                            ,A.project_code
                            ,A.yyyymmdd
                      FROM   sub1 A
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND A.operation_group = 'P'
                      LEFT JOIN #tmp_OPERATION_GROUP C
                      ON  A.operation_group = C.segment1
                      GROUP BY A.plan_week, A.plan_start_yyyymmdd, A.operation_group, A.item_id, A.division_id, A.segment2, A.operation_group1, ISNULL(A.group_code2, ''), A.plant_id, A.from_scm_site_id, A.to_scm_site_id, ISNULL(C.segment2, ''), A.project_code, A.yyyymmdd
                     )
                     SELECT A.plan_week --기준주차
                           ,A.plan_start_yyyymmdd
                           ,A.division_id -- 사업부
                           ,A.segment2 -- 소형제품구분
                           ,A.operation_group -- operation_group
                           ,A.operation_group1 -- 셀/팩구분
                           ,A.plant_id -- 생산지
						   ,A.from_scm_site_id
						   ,A.to_scm_site_id
                           ,A.group_code2 -- 모델
                           ,A.item_id
                           ,A.operation_group_name
                           ,A.plan_qty_1 -- SCP(계획)
                           ,0 plan_qty_2
                           ,0 plan_qty_3
                           ,A.plan_cell_1 -- SCP(계획)
                           ,0 plan_cell_2
                           ,0 plan_cell_3
                           ,A.project_code
                           ,A.yyyymmdd
                     INTO   #tmp_BASE_1
                     FROM   sub2 A
                     ;
					 
                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
                     SET @v_description  = N'Process Complete... division_id (' + @v_division_id + ') : #tmp_BASE_1';
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
            -- 사업부별 임시데이터(실적 & 계획) 생성 - SSP_KPI_SPA_OTD1_C
            -------------------------------------------------------------------------------------------------------------------------
			
                     ;WITH sub AS
                     (
                      SELECT A.*
					  
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')	-- (소형/전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  when A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1
								  
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')	-- (소형/전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                      FROM   #tmp_SSP_KPI_SPA_OTD1_C A
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)  -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'
                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id = B.item_id
                      AND A.division_id = B.division_id
                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id = C.division_id
                      AND A.item_id = C.item_id
                      WHERE   1 = 1
                      AND A.division_id = @v_division_id
                     ),
                     sub1 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.operation_group
                            ,A.item_id
                            ,SUM(A.plan_qty) plan_qty_2
                            ,SUM(A.plan_qty * ISNULL(B.accumulated_child_qty, 1)) plan_cell_2
                            ,A.division_id
                            ,A.segment2
                            ,A.operation_group1
                            ,ISNULL(A.group_code2, '') group_code2
                            ,A.plant_id
                            ,A.from_scm_site_id
                            ,A.to_scm_site_id
                            ,ISNULL(C.segment2, '') operation_group_name
                            ,A.project_code
                            ,A.yyyymmdd
                      FROM   sub A
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND A.operation_group = 'P'
                      LEFT JOIN #tmp_OPERATION_GROUP C
                      ON  A.operation_group = C.segment1
                      GROUP BY A.plan_week, A.plan_start_yyyymmdd, A.operation_group, A.item_id, A.division_id, A.segment2, A.operation_group1, ISNULL(A.group_code2, ''), A.plant_id, A.from_scm_site_id, A.to_scm_site_id, ISNULL(C.segment2, ''), A.project_code, A.yyyymmdd
                     )
                     SELECT A.plan_week --기준주차
                           ,A.plan_start_yyyymmdd
                           ,A.division_id -- 사업부
                           ,A.segment2 -- 소형제품구분
                           ,A.operation_group -- operation_group
                           ,A.operation_group1 -- 셀/팩구분
                           ,A.plant_id -- 생산지
                           ,A.from_scm_site_id
                           ,A.to_scm_site_id
                           ,A.group_code2 -- 모델
                           ,A.item_id
                           ,A.operation_group_name
                           ,0 plan_qty_1
                           ,A.plan_qty_2
                           ,0 plan_qty_3
                           ,0 plan_cell_1
                           ,A.plan_cell_2
                           ,0 plan_cell_3
                           ,A.project_code
                           ,A.yyyymmdd
                     INTO   #tmp_BASE_2
                     FROM   sub1 A
                     ;

                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
                     SET @v_description  = N'Process Complete... division_id (' + @v_division_id + ') : #tmp_BASE_2';
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
            -- 사업부별 임시데이터(실적 & 계획) 생성 - SCM_DNM_EXFACTORY_RESULT + SCM_DNM_EXFACTORY_RESULT 에는 없는 계획 OR 실적 데이터는 SSP_KPI_SPA_OTD1_C 으로 @v_end_yyyymmdd 까지 생성함
            -------------------------------------------------------------------------------------------------------------------------

                     ;WITH sub AS
                     (
                      SELECT A.division_id
                            ,@v_plan_week plan_week
                            ,@v_plan_start_yyyymmdd plan_start_yyyymmdd
                            ,ISNULL(B.operation_group, '-') operation_group
                            ,ISNULL(B.plant_id, '-') plant_id
                            ,ISNULL(A.from_scm_site_id, '-') from_scm_site_id
                            ,A.to_scm_site_id
                            ,A.item_id
                            ,A.exfactory_date yyyymmdd
                            ,ISNULL(A.exfactory_qty, 0) plan_qty
                            ,CASE WHEN ISNULL(A.exfactory_status, 'D90') NOT IN ('D90', 'D10') THEN 'Y'
                                  ELSE 'N' END targetyn -- D90: DO삭제 , D10:DO생성
                            --,CASE WHEN ISNULL(A.exfactory_qty, 0) > 0 THEN 'Y'
                            --      ELSE 'N' END targetyn1

							-- 외주물량은 ESS만 포함
							-- PJ20216994 11/1 소형 외주 실적은 SCS 테이블 참조 (ERP테이블은 기존과 동일하게 ESS 외주 물량만 참조 - 소스 변경 없음) 
							-- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS) - 20221212
                            -- 20221212 변경전 :  ,CASE WHEN A.division_id <> '82' AND LEN(ISNULL(B.plant_id, '-')) > 4 THEN 'N'
                            ,CASE WHEN LEN(ISNULL(B.plant_id, '-')) > 4 THEN 'N'
                                  WHEN ISNULL(A.exfactory_qty, 0) <= 0 THEN 'N'
                                  ELSE 'Y' END targetyn1

                            -- PJ20216994 (2022.07.05)
					        -- ESS 만 project_code 추가, (TBD도 project_code로서 의미없는 값이므로 '-'처리)
                            ,IIF(A.DIVISION_ID = '82', IIF(A.project_code IS NULL OR A.project_code = 'TBD', '-', A.project_code), '-') project_code
                      FROM   dbo.SCM_DNM_EXFACTORY_RESULT A WITH (NOLOCK)
                      LEFT OUTER JOIN #tmp_SCM_MST_SITE B
                      ON  A.division_id      = B.division_id
                      AND A.from_scm_site_id = B.scm_site_id
                      INNER JOIN #tmp_SCM_MST_SITE C
                      ON  A.division_id    = C.division_id
                      AND A.to_scm_site_id = C.scm_site_id
					  
                      -- PJ20216994 (2022.07.05)
                      -- AND C.site_type = 'SALES'
                      AND C.site_type      IN ('PLANT', 'SALES')
                      WHERE  1 = 1
                      AND A.division_id = @v_division_id
                      AND A.exfactory_date BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
					  AND ISNULL(B.operation_group, '') <> 'W' --  20220608 PJ20216891 AS Plant 출하 제외
					  -- SSP 와 동일 로직 처리
					  AND (ISNULL(a.confirm_id, '') = ''
					    OR ssp_type IN (
                                        SELECT segment1
                                        FROM   dbo.SCM_ADM_LOOKUP_MASTER_DETAIL B2 WITH (NOLOCK)
                                        WHERE  1 = 1
                                        AND    B2.lookup_type = 'ERP_SSP_TYPE'
                                        AND    B2.valid_yn = 'Y'
						               )
					   	  )
                     ),
                     sub1 AS
                     (
                      SELECT A.*
					  
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')	-- (소형/전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  WHEN A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1
							
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')	-- (소형/전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                      FROM   sub A
							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)  -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'
                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id = B.item_id
                      AND A.division_id = B.division_id
                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id = C.division_id
                      AND A.item_id = C.item_id
                      WHERE 1 = 1
                      AND A.targetyn = 'Y'
                      AND A.targetyn1 = 'Y'
                     ),
                     sub2 AS
                     (
                      SELECT division_id
                            ,plant_id
                            --,MAX(yyyymmdd) yyyymmdd
                            ,CASE WHEN FORMAT(GETDATE() - 1, 'yyyyMMdd') > MAX(yyyymmdd) THEN FORMAT(GETDATE() - 1, 'yyyyMMdd')
                                  ELSE MAX(yyyymmdd) END yyyymmdd
                      FROM   sub1
                      GROUP BY division_id, plant_id
                     ),
                     sub3 as
                     (
                      SELECT A.*
					  
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN B.segment2
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')	-- (소형/전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN B.segment2
                                  ELSE NULL END segment2
                            ,CASE WHEN A.operation_group = 'A' THEN 'Cell'
                                  when A.operation_group = 'P' THEN 'Pack'
                                  ELSE '-' END operation_group1
							
                            -- PJ20216891
                            -- ,CASE WHEN A.division_id IN ('40', 'EE') THEN ISNULL(C.nick_name, A.item_id)
                            -- 2023.03.31 HM JV ,CASE WHEN A.division_id IN ('40', 'EE', 'EE_UC') 
							,CASE WHEN DM.ATTRIBUTE3 IN ('40', 'EE')	-- (소형/전극) 2023.03.31 HM JV 가상 사업부 추가 대응
								  THEN ISNULL(C.nick_name, A.item_id)
                                  WHEN A.division_id IN ('82') THEN A.item_id
                                  ELSE ISNULL(C.group_code2, A.item_id) END group_code2
                      FROM   #tmp_SSP_KPI_SPA_OTD1_C A
 							 INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)  -- 2023.03.31 HM JV 가상 사업부 추가 대응
									 ON DM.DIVISION_ID = A.DIVISION_ID
									AND DM.VALID_YN	   = 'Y'
                      LEFT JOIN #tmp_CELL_TYPE_GROUP B
                      ON  A.item_id = B.item_id
                      AND A.division_id = B.division_id
                      INNER JOIN #tmp_MST_FINAL_ITEM C
                      ON  A.division_id = C.division_id
                      AND A.item_id = C.item_id
                      LEFT JOIN sub2 D
                      ON A.division_id = D.division_id
                      AND A.plant_id = D.plant_id
                      WHERE   1 = 1
                      AND A.division_id = @v_division_id
                      AND A.yyyymmdd > D.yyyymmdd  -- 계획은 D.yyyymmdd 이후 일자만을 사용함
					 ),
                     sub4 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.operation_group
                            ,A.item_id
                            ,A.plan_qty
                            ,ISNULL(B.accumulated_child_qty, 1) accumulated_child_qty
                            ,A.division_id
                            ,A.segment2
                            ,A.operation_group1
                            ,ISNULL(A.group_code2, '') group_code2
                            ,A.plant_id
                            ,A.from_scm_site_id
                            ,A.to_scm_site_id
                            ,ISNULL(C.segment2, '') operation_group_name
                            ,A.project_code
                            ,A.yyyymmdd
                      FROM   sub1 A
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND A.operation_group = 'P'
                      LEFT JOIN #tmp_OPERATION_GROUP C
                      ON  A.operation_group = C.segment1

                      LEFT JOIN sub2 D
                      ON A.division_id = D.division_id
                      AND A.plant_id = D.plant_id
					  WHERE 1 = 1
					  AND A.targetyn1 = 'Y'
                      AND A.yyyymmdd <= D.yyyymmdd -- 실적은 D.yyyymmdd 이전 일자만을 사용함

                      UNION ALL

                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.operation_group
                            ,A.item_id
                            ,A.plan_qty
                            ,ISNULL(B.accumulated_child_qty, 1) accumulated_child_qty
                            ,A.division_id
                            ,A.segment2
                            ,A.operation_group1
                            ,ISNULL(A.group_code2, '') group_code2
                            ,A.plant_id
                            ,A.from_scm_site_id
                            ,A.to_scm_site_id
                            ,ISNULL(C.segment2, '') operation_group_name
                            ,A.project_code
                            ,A.yyyymmdd
                      FROM   sub3 A
                      LEFT JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                      ON  A.division_id = B.division_id
                      AND A.item_id = B.model_id
                      AND A.plant_id = B.plant_id
                      AND A.operation_group = 'P'
                      LEFT JOIN #tmp_OPERATION_GROUP C
                      ON  A.operation_group = C.segment1
                      WHERE 1 = 1
              --        AND NOT EXISTS (
              --                        SELECT 1
              --                        FROM sub1
              --                        WHERE 1 = 1
              --                        AND division_id = A.division_id
								      --AND from_scm_site_id = A.from_scm_site_id
								      --AND to_scm_site_id = A.to_scm_site_id
								      --AND item_id = A.item_id
              --                        AND plant_id = A.plant_id
              --                        AND yyyymmdd = A.yyyymmdd
              --                       )
                     ),
                     sub5 AS
                     (
                      SELECT A.plan_week
                            ,A.plan_start_yyyymmdd
                            ,A.operation_group
                            ,A.item_id
                            ,SUM(A.plan_qty) plan_qty_3
							,SUM(A.plan_qty * A.accumulated_child_qty) plan_cell_3
                            ,A.division_id
                            ,A.segment2
                            ,A.operation_group1
                            ,A.group_code2
                            ,A.plant_id
                            ,A.from_scm_site_id
                            ,A.to_scm_site_id
                            ,A.operation_group_name
                            ,A.project_code
                            ,A.yyyymmdd
                      FROM   sub4 A
                      GROUP BY A.plan_week, A.plan_start_yyyymmdd, A.operation_group, A.item_id, A.division_id, A.segment2, A.operation_group1, A.group_code2, A.plant_id, A.from_scm_site_id, A.to_scm_site_id, A.operation_group_name, A.project_code, A.yyyymmdd
					 )
                     SELECT A.plan_week --기준주차
                           ,A.plan_start_yyyymmdd
                           ,A.division_id -- 사업부
                           ,A.segment2 -- 소형제품구분
                           ,A.operation_group -- operation_group
                           ,A.operation_group1 -- 셀/팩구분
                           ,A.plant_id -- 생산지
                           ,A.from_scm_site_id
                           ,A.to_scm_site_id
                           ,A.group_code2 -- 모델
                           ,A.item_id
                           ,A.operation_group_name
                           ,0 plan_qty_1
                           ,0 plan_qty_2
                           ,A.plan_qty_3
                           ,0 plan_cell_1
                           ,0 plan_cell_2
                           ,A.plan_cell_3
                           ,A.project_code
                           ,A.yyyymmdd
                     INTO   #tmp_BASE_3
                     FROM   sub5 A
                     ;

                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
                     SET @v_description  = N'Process Complete... division_id (' + @v_division_id + ') : #tmp_BASE_3';
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
            -- PJ20216994 11/1 소형 외주 Packer 실적 추가 (SCS 테이블) 
			-- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS)
			--                               ESS 외주 Packer 실적 추가 
            -------------------------------------------------------------------------------------------------------------------------
			;WITH SCS_PACKER_SHIP_RESULT_40 AS (
				SELECT SR.DIVISION_ID
					  ,ISNULL(CT.SEGMENT2, '-')	AS CELL_TYPE_GR			-- 소형제품구분   ISNULL(segment2, '-') cell_type_gr
					  ,FI.OPERATION_GROUP 
					  ,OG.SEGMENT2				AS OPERATION_GROUP_NAME
					  ,FS.PLANT_ID
					  ,FS.SCM_SITE_ID								AS FROM_SCM_SITE_ID
					  ,ISNULL(ASP.SEGMENT1, TS.SCM_SITE_ID)			AS TO_SCM_SITE_ID -- 2022.12.14 AS_SITE_PLANT segment2에 등록된 to site면 segment1로 치환, 그외 사이트는 그대로 표시목적  
					  ,CASE WHEN SR.DIVISION_ID = '82'				-- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS) 
						    THEN SR.ITEM_ID	
							ELSE ISNULL(FI.NICK_NAME, SR.ITEM_ID) 
					   END						AS GROUP_CODE2				
					  ,SR.ITEM_ID 
					  ,SR.SHIP_DATE				AS YYYYMMDD
					  ,SR.SHIP_QTY
					  ,SR.SHIP_QTY * ISNULL(BO.ACCUMULATED_CHILD_QTY, 1) AS SHIP_QTY_CELL
					  ,CASE WHEN SR.DIVISION_ID = '82'	-- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS)
							THEN ISNULL(C.PROJECT_CODE, '-') 
							ELSE '-'
						END						AS PROJECT_CODE
				 FROM SCM_DNM_SCS_SHIP_RESULT SR WITH(NOLOCK)
					  INNER JOIN SCM_MST_SITE FS WITH(NOLOCK) 
							  ON FS.DIVISION_ID     = SR.DIVISION_ID
							 AND FS.SCM_SITE_ID     = SR.SCM_SITE_ID
							 AND FS.OSP_YN          = 'Y' -- 외주 Packer 
							 AND FS.OPERATION_GROUP = 'P' -- Pack Plant 
					  INNER JOIN SCM_MST_SITE TS WITH(NOLOCK)
							  ON TS.DIVISION_ID = SR.DIVISION_ID
							 AND TS.SCM_SITE_ID = SR.TO_SITE 
					  INNER JOIN SCP_MST_FINAL_ITEM FI WITH (NOLOCK)
							  ON FI.DIVISION_ID = SR.DIVISION_ID
							 AND FI.ITEM_ID     = SR.ITEM_ID 
					  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL CT WITH(NOLOCK)
							  ON CT.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE'
							 AND CT.SEGMENT1    = FI.CELL_TYPE_GROUP_CODE
							 AND CT.VALID_YN    = 'Y'
					  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL OG WITH(NOLOCK)
							  ON OG.LOOKUP_TYPE = 'OPERATION_GROUP'
							 AND OG.SEGMENT1    = FI.OPERATION_GROUP
							 AND OG.VALID_YN    = 'Y'
					  LEFT  JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V  BO  WITH (NOLOCK)
							  ON BO.DIVISION_ID = SR.DIVISION_ID
							 AND BO.MODEL_ID	= SR.ITEM_ID
							 AND BO.PLANT_ID    = TS.PLANT_ID  
					  LEFT  JOIN SSP_ANL_SHIP_CONFIRM C WITH (NOLOCK)   -- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS) 
							  ON C.CONFIRM_ID = SR.ATTRIBUTE5
					  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL  ASP WITH(NOLOCK) 
						      ON ASP.LOOKUP_TYPE = 'AS_SITE_PLANT'
							 AND ASP.SEGMENT2    = SR.TO_SITE
							 AND ASP.VALID_YN    = 'Y'
				WHERE SR.DIVISION_ID IN ('40', '82')  -- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS)
				  AND SR.DIVISION_ID = @v_division_id
				  AND SR.SHIP_DATE BETWEEN @v_start_yyyymmdd AND @v_end_yyyymmdd
				  AND SR.SHIP_QTY > 0 
			)
			,FINAL_RESULT_DATE AS (
				-- 실적/계획 반영 경계일?  (기존 ERP 실적 반영 로직 참조)  
				SELECT DIVISION_ID
					  ,PLANT_ID
					  ,CASE WHEN FORMAT(GETDATE() - 1, 'yyyyMMdd') > MAX(YYYYMMDD)
							THEN FORMAT(GETDATE() - 1, 'yyyyMMdd')
							ELSE MAX(YYYYMMDD) 
						END				AS FINAL_RESULT_YYYYMMDD
					  ,MAX(YYYYMMDD)	AS MAX_YYYYMMDD
				 FROM SCS_PACKER_SHIP_RESULT_40 SR
				GROUP BY DIVISION_ID
						,PLANT_ID 
			)
			,PLAN_RESULT_OSP_40 AS (
				-- 실적 
				SELECT SR.*
				 FROM SCS_PACKER_SHIP_RESULT_40 SR
					  INNER JOIN FINAL_RESULT_DATE DT
							  ON SR.DIVISION_ID = DT.DIVISION_ID
							 AND SR.PLANT_ID    = DT.PLANT_ID
							 AND SR.YYYYMMDD   <= DT.FINAL_RESULT_YYYYMMDD --### 기존 실적의 계획 반영 로직 참조 반영  !!
				UNION ALL 
				-- 계획 --> 기존 실적의 계획 반영 로직 참조 반영    	 
				SELECT P.DIVISION_ID
					  ,ISNULL(CT.SEGMENT2, '-')	AS CELL_TYPE_GR			-- 소형제품구분
					  ,F.OPERATION_GROUP 
					  ,OG.SEGMENT2				AS OPERATION_GROUP_NAME
					  ,S.PLANT_ID
					  ,P.FROM_SCM_SITE_ID
					  ,P.TO_SCM_SITE_ID
					  ,CASE WHEN P.DIVISION_ID = '82' THEN P.ITEM_ID			-- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS) 
							ELSE ISNULL(F.NICK_NAME, P.ITEM_ID) 
					   END						AS GROUP_CODE2				
					  ,P.ITEM_ID 
					  ,P.YYYYMMDD
					  ,P.PLAN_QTY										AS SHIP_QTY
					  ,P.PLAN_QTY * ISNULL(BO.ACCUMULATED_CHILD_QTY, 1) AS SHIP_QTY_CELL
					  ,IIF(P.DIVISION_ID = '82', IIF(P.PROJECT_CODE IS NULL OR P.PROJECT_CODE = 'TBD', '-', P.PROJECT_CODE), '-') AS PROJECT_CODE  -- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS)
				 FROM #tmp_SSP_KPI_SPA_OTD1_C P
					  INNER JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK)
							  ON F.DIVISION_ID			 = P.DIVISION_ID
							 AND F.ITEM_ID				 = P.ITEM_ID 
					  INNER JOIN FINAL_RESULT_DATE D
							  ON D.DIVISION_ID			 = P.DIVISION_ID 
							 AND D.PLANT_ID				 = P.PLANT_ID
							 AND D.FINAL_RESULT_YYYYMMDD < P.YYYYMMDD --### 기존 실적의 계획 반영 로직 참조 반영  !!
					  INNER JOIN SCM_MST_SITE S WITH(NOLOCK)
							  ON S.DIVISION_ID		= P.DIVISION_ID
							 AND S.SCM_SITE_ID		= P.FROM_SCM_SITE_ID
							 AND S.OSP_YN			= 'Y' -- 외주 Packer 
							 AND S.OPERATION_GROUP	= 'P' -- Pack Plant 
					  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL OG WITH(NOLOCK)
							  ON OG.LOOKUP_TYPE = 'OPERATION_GROUP'
							 AND OG.SEGMENT1    = F.OPERATION_GROUP
							 AND OG.VALID_YN    = 'Y'
					  LEFT  JOIN SCM_ADM_LOOKUP_MASTER_DETAIL CT WITH(NOLOCK)
							  ON CT.LOOKUP_TYPE = 'CELL_TYPE_GROUP_CODE'
							 AND CT.SEGMENT1    = F.CELL_TYPE_GROUP_CODE
							 AND CT.VALID_YN    = 'Y'
					  LEFT  JOIN #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V  BO  WITH (NOLOCK)
							  ON BO.DIVISION_ID = P.DIVISION_ID
							 AND BO.MODEL_ID	= P.ITEM_ID
							 AND BO.PLANT_ID    = P.PLANT_ID  
				WHERE 1=1
				  AND P.DIVISION_ID IN ('40', '82')  -- PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS사업부 외주 Packer 실적 참조 변경 (ERP->SCS)
				  AND P.DIVISION_ID = @v_division_id
			)
			SELECT @v_plan_week				AS plan_week
                  ,@v_plan_start_yyyymmdd	AS plan_start_yyyymmdd
				  ,DIVISION_ID
				  ,CELL_TYPE_GR
				  ,OPERATION_GROUP
				  ,CASE WHEN OPERATION_GROUP = 'A' THEN 'Cell'
						WHEN OPERATION_GROUP = 'P' THEN 'Pack'
						ELSE '-'
					END						AS OPERATION_GROUP1
				  ,PLANT_ID
				  ,FROM_SCM_SITE_ID
				  ,TO_SCM_SITE_ID
				  ,GROUP_CODE2
				  ,ITEM_ID
				  ,OPERATION_GROUP_NAME
				  ,0						AS PLAN_QTY_1
				  ,0						AS PLAN_QTY_2
				  ,SUM(SHIP_QTY)			AS PLAN_QTY_3
				  ,0						AS PLAN_CELL_1
				  ,0						AS PLAN_CELL_2
				  ,SUM(SHIP_QTY_CELL)		AS PLAN_CELL_3
				  ,PROJECT_CODE
				  ,YYYYMMDD
			 INTO #tmp_BASE_4
			 FROM PLAN_RESULT_OSP_40
			GROUP BY 
				   DIVISION_ID
				  ,CELL_TYPE_GR
				  ,OPERATION_GROUP
				  ,CASE WHEN OPERATION_GROUP = 'A' THEN 'Cell'
						WHEN OPERATION_GROUP = 'P' THEN 'Pack'
						ELSE '-'
					END
				  ,PLANT_ID
				  ,FROM_SCM_SITE_ID
				  ,TO_SCM_SITE_ID
				  ,GROUP_CODE2
				  ,ITEM_ID
				  ,OPERATION_GROUP_NAME
				  ,PROJECT_CODE
				  ,YYYYMMDD

                -- TXN LOG      
                SET @n_log_count    = @@ROWCOUNT;
				SET @v_log_type     = N'TXN';
                SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
                SET @v_description  = N'Process Complete... division_id (' + @v_division_id + ') : #tmp_BASE_4';
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
            -- 실테이블(SCP_RPT_SHIPMENT)에 저장 : 주별데이터
            -------------------------------------------------------------------------------------------------------------------------

                     ;WITH sub AS
                     (
						-- 2023.03.31 HM JV 가상 사업부 추가 대응
						SELECT SH.*
							  ,CASE WHEN DM.ATTRIBUTE3 = '81' -- JV 포함 자동차 
									THEN 'A'
									ELSE 'B' 
								END AS DIVISION_TYPE 
						 FROM (
								SELECT *
								 FROM #tmp_BASE_1
								UNION ALL
								SELECT *
								 FROM #tmp_BASE_2
								UNION ALL
								SELECT *
								 FROM #tmp_BASE_3
								UNION ALL
								SELECT *
								 FROM #tmp_BASE_4 -- 소형 외주 Packer 실적
							  ) SH INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)
										   ON DM.DIVISION_ID = SH.DIVISION_ID
										  AND DM.VALID_YN	 = 'Y'
                     ),
                     sub1 AS
                     (
                      -- 자동차(division_type = A)인 경우 ssp(plan_qty_2)와 실적(plan_qty_3)을 비교함
                      SELECT plan_start_yyyymmdd
                            ,plan_week
                            ,division_id
                            ,ISNULL(segment2, '-') cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ESS는 비워 둠)
                            ,operation_group
                            ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                            ,from_scm_site_id
                            ,to_scm_site_id
                            ,operation_group_name
                            ,project_code
                            ,ISNULL(group_code2, item_id) model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대 표모델 Nickname)
                            ,SUM(plan_qty_1) ship_plan_scp -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_qty_2) ship_plan_ssp -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_qty_2) >= SUM(plan_qty_3) THEN SUM(plan_qty_3)
                                  ELSE SUM(plan_qty_2) END ship_result
                            ,SUM(plan_qty_3) ship_result_tot -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                            ,SUM(plan_cell_1) ship_plan_scp_cell -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_cell_2) ship_plan_ssp_cell -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_cell_2) >= SUM(plan_cell_3) THEN SUM(plan_cell_3)
                                  ELSE SUM(plan_cell_2) END ship_result_cell
                            ,SUM(plan_cell_3) ship_result_tot_cell -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                      FROM   sub
					  WHERE  division_type = 'A'
                      GROUP BY plan_week, plan_start_yyyymmdd, division_id, ISNULL(segment2, '-'), operation_group,  plant_id, from_scm_site_id, to_scm_site_id, ISNULL(group_code2, item_id), operation_group_name, project_code
					  
                      UNION ALL
					  
                      -- 나머지(division_type = B)인 경우 scp(plan_qty_1)와 실적(plan_qty_3)을 비교함
                      SELECT plan_start_yyyymmdd
                            ,plan_week
                            ,division_id
                            ,ISNULL(segment2, '-') cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ESS는 비워 둠)
                            ,operation_group
                            ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                            ,from_scm_site_id
                            ,to_scm_site_id
                            ,operation_group_name
                            ,project_code
                            ,ISNULL(group_code2, item_id) model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대 표모델 Nickname)
                            ,SUM(plan_qty_1) ship_plan_scp -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_qty_2) ship_plan_ssp -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_qty_1) >= SUM(plan_qty_3) THEN SUM(plan_qty_3)
                                  ELSE SUM(plan_qty_1) END ship_result
                            ,SUM(plan_qty_3) ship_result_tot -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                            ,SUM(plan_cell_1) ship_plan_scp_cell -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_cell_2) ship_plan_ssp_cell -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_cell_1) >= SUM(plan_cell_3) THEN SUM(plan_cell_3)
                                  ELSE SUM(plan_cell_1) END ship_result_cell
                            ,SUM(plan_cell_3) ship_result_tot_cell -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                      FROM   sub
                      WHERE  division_type = 'B'
                      GROUP BY plan_week, plan_start_yyyymmdd, division_id, ISNULL(segment2, '-'), operation_group, plant_id, from_scm_site_id, to_scm_site_id, ISNULL(group_code2, item_id), operation_group_name, project_code
                     )
                     INSERT INTO dbo.SCP_RPT_SHIPMENT WITH (TABLOCK)
                     (
                       plan_start_yyyymmdd
                      ,plan_week
                      ,division_id
                      ,cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ess는 비워둠)
                      ,operation_group
                      ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
					  ,model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대표모델 Nickname)
					  ,from_scm_site_id
					  ,to_scm_site_id
                      ,project_code
                      ,operation_group_name                      
                      ,ship_plan_scp
                      ,ship_plan_ssp
                      ,ship_result
                      ,ship_result_tot
                      ,ship_plan_scp_cell
                      ,ship_plan_ssp_cell
                      ,ship_result_cell
                      ,ship_result_tot_cell
                      ,created_by
                      ,creation_date
                      ,last_updated_by
                      ,last_update_date
                     )
                     SELECT B.plan_start_yyyymmdd  --*
                           ,B.plan_week  --*
                           ,B.division_id  --*
                           ,B.cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ess는 비워둠)*
                           ,B.operation_group  --*
                           ,B.plant_id -- 생산지	: ESOC / ESMI / ESWA ….*
                           ,B.model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대표모델 Nickname)*
                           ,B.from_scm_site_id  --*
                           ,B.to_scm_site_id  --*
						   ,B.project_code  --*
                           ,B.operation_group_name                           
                           ,B.ship_plan_scp
                           ,B.ship_plan_ssp
                           ,B.ship_result
                           ,B.ship_result_tot
                           ,B.ship_plan_scp_cell
                           ,B.ship_plan_ssp_cell
                           ,B.ship_result_cell
                           ,B.ship_result_tot_cell
                           ,@v_batch_user
                           ,GETDATE()
                           ,@v_batch_user
                           ,GETDATE()
                     FROM   sub1 B
                     ;
					 
                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id;      
                     SET @v_description  = N'Process Complete... division_id (' + @v_division_id + ') : SCP_RPT_SHIPMENT';
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
            -- 실테이블(SCP_RPT_SHIPMENT)에 저장 : 일별데이터
            -------------------------------------------------------------------------------------------------------------------------

                     --PJ20216994 (2022.09.05)
                     ;WITH sub AS
                     (
						-- 2023.03.31 HM JV 가상 사업부 추가 대응
						SELECT SH.*
							  ,CASE WHEN DM.ATTRIBUTE3 = '81' -- JV 포함 자동차 
									THEN 'A'
									ELSE 'B' 
								END AS DIVISION_TYPE 
						 FROM (
								SELECT *
								 FROM #tmp_BASE_1
								UNION ALL
								SELECT *
								 FROM #tmp_BASE_2
								UNION ALL
								SELECT *
								 FROM #tmp_BASE_3
								UNION ALL
								SELECT *
								 FROM #tmp_BASE_4 -- 소형 외주 Packer 실적
							  ) SH INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)
										   ON DM.DIVISION_ID = SH.DIVISION_ID
										  AND DM.VALID_YN	 = 'Y'
                     ),
                     sub1 AS
                     (
                      -- 자동차(division_type = A)인 경우 ssp(plan_qty_2)와 실적(plan_qty_3)을 비교함
                      SELECT plan_start_yyyymmdd
                            ,plan_week
                            ,division_id
                            ,ISNULL(segment2, '-') cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ESS는 비워 둠)
                            ,operation_group
                            ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                            ,from_scm_site_id
                            ,to_scm_site_id
                            ,operation_group_name
                            ,project_code
                            ,yyyymmdd
                            ,ISNULL(group_code2, item_id) model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대 표모델 Nickname)
                            ,SUM(plan_qty_1) ship_plan_scp -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_qty_2) ship_plan_ssp -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_qty_2) >= SUM(plan_qty_3) THEN SUM(plan_qty_3)
                                  ELSE SUM(plan_qty_2) END ship_result
                            ,SUM(plan_qty_3) ship_result_tot -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                            ,SUM(plan_cell_1) ship_plan_scp_cell -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_cell_2) ship_plan_ssp_cell -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_cell_2) >= SUM(plan_cell_3) THEN SUM(plan_cell_3)
                                  ELSE SUM(plan_cell_2) END ship_result_cell
                            ,SUM(plan_cell_3) ship_result_tot_cell -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                      FROM   sub
					  WHERE  division_type = 'A'
                      GROUP BY plan_week, plan_start_yyyymmdd, division_id, ISNULL(segment2, '-'), operation_group,  plant_id, from_scm_site_id, to_scm_site_id, ISNULL(group_code2, item_id), operation_group_name, project_code, yyyymmdd
					  
                      UNION ALL
					  
                      -- 나머지(division_type = B)인 경우 scp(plan_qty_1)와 실적(plan_qty_3)을 비교함
                      SELECT plan_start_yyyymmdd
                            ,plan_week
                            ,division_id
                            ,ISNULL(segment2, '-') cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ESS는 비워 둠)
                            ,operation_group
                            ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
                            ,from_scm_site_id
                            ,to_scm_site_id
                            ,operation_group_name
                            ,project_code
                            ,yyyymmdd
                            ,ISNULL(group_code2, item_id) model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대 표모델 Nickname)
                            ,SUM(plan_qty_1) ship_plan_scp -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_qty_2) ship_plan_ssp -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_qty_1) >= SUM(plan_qty_3) THEN SUM(plan_qty_3)
                                  ELSE SUM(plan_qty_1) END ship_result
                            ,SUM(plan_qty_3) ship_result_tot -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                            ,SUM(plan_cell_1) ship_plan_scp_cell -- SCP_ANL_PRODUCTION_PLAN
                            ,SUM(plan_cell_2) ship_plan_ssp_cell -- FP_DAILY_PRODUCTIOIN_PLAN_H_SN 
                            ,CASE WHEN SUM(plan_cell_1) >= SUM(plan_cell_3) THEN SUM(plan_cell_3)
                                  ELSE SUM(plan_cell_1) END ship_result_cell
                            ,SUM(plan_cell_3) ship_result_tot_cell -- FP_DAILY_PRODUCTION_PLAN_DW_H_SN
                      FROM   sub
                      WHERE  division_type = 'B'
                      GROUP BY plan_week, plan_start_yyyymmdd, division_id, ISNULL(segment2, '-'), operation_group, plant_id, from_scm_site_id, to_scm_site_id, ISNULL(group_code2, item_id), operation_group_name, project_code, yyyymmdd
                     )
                     INSERT INTO dbo.SCP_RPT_SHIPMENT_DETAIL WITH (TABLOCK)
                     (
                       plan_start_yyyymmdd
                      ,plan_week
                      ,plan_day
                      ,division_id
                      ,cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ess는 비워둠)
                      ,operation_group
                      ,plant_id -- 생산지	: ESOC / ESMI / ESWA ….
					  ,model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대표모델 Nickname)
					  ,from_scm_site_id
					  ,to_scm_site_id
                      ,project_code
                      ,operation_group_name                      
                      ,ship_plan_scp
                      ,ship_plan_ssp
                      ,ship_result
                      ,ship_result_tot
                      ,ship_plan_scp_cell
                      ,ship_plan_ssp_cell
                      ,ship_result_cell
                      ,ship_result_tot_cell
                      ,created_by
                      ,creation_date
                      ,last_updated_by
                      ,last_update_date
                     )
                     SELECT B.plan_start_yyyymmdd  --*
                           ,B.plan_week  --*
                           ,B.yyyymmdd
                           ,B.division_id  --*
                           ,B.cell_type_gr -- 소형제품구분 	: 원통형 / 파우치형 ( 자동차 / ess는 비워둠)*
                           ,B.operation_group  --*
                           ,B.plant_id -- 생산지	: ESOC / ESMI / ESWA ….*
                           ,B.model_type_gr -- 모델	: 자동차 (Pack Group 전환), 소형/ESS (대표모델 Nickname)*
                           ,B.from_scm_site_id  --*
                           ,B.to_scm_site_id  --*
						   ,B.project_code  --*
                           ,B.operation_group_name                           
                           ,B.ship_plan_scp
                           ,B.ship_plan_ssp
                           ,B.ship_result
                           ,B.ship_result_tot
                           ,B.ship_plan_scp_cell
                           ,B.ship_plan_ssp_cell
                           ,B.ship_result_cell
                           ,B.ship_result_tot_cell
                           ,@v_batch_user
                           ,GETDATE()
                           ,@v_batch_user
                           ,GETDATE()
                     FROM   sub1 B
                     ;
					 
                     -- TXN LOG      
                     SET @n_log_count    = @@ROWCOUNT;
					 SET @v_log_type     = N'TXN';
                     SET @v_log_message  = N'INSERT INTO ' + @v_table_id1;      
                     SET @v_description  = N'Process Complete... division_id (' + @v_division_id + ') : SCP_RPT_SHIPMENT_DETAIL';
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

                     IF OBJECT_ID('tempdb..#tmp_BASE_4') IS NOT NULL   -- PJ20216994 11/1 소형 외주 Packer SCS 실적 추가 
                         DROP TABLE #tmp_BASE_4;

				 END
             END
			 

			 
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

    END CATCH;      

            -------------------------------------------------------------------------------------------------------------         
            -- 임시테이블 제거
            -------------------------------------------------------------------------------------------------------------
             IF OBJECT_ID('tempdb..#tmp_BASE_1') IS NOT NULL
                 DROP TABLE #tmp_BASE_1;
   
             IF OBJECT_ID('tempdb..#tmp_BASE_2') IS NOT NULL
                 DROP TABLE #tmp_BASE_2;
   
             IF OBJECT_ID('tempdb..#tmp_BASE_3') IS NOT NULL
                 DROP TABLE #tmp_BASE_3;

             IF OBJECT_ID('tempdb..#tmp_BASE_4') IS NOT NULL  -- PJ20216994 11/1 소형 외주 Packer SCS 실적 추가 
                 DROP TABLE #tmp_BASE_4;

             IF OBJECT_ID('tempdb..#tmp_OPERATION_GROUP') IS NOT NULL
                 DROP TABLE #tmp_OPERATION_GROUP;
   
             IF OBJECT_ID('tempdb..#tmp_CELL_TYPE_GROUP') IS NOT NULL
                 DROP TABLE #tmp_CELL_TYPE_GROUP;

             IF OBJECT_ID('tempdb..#tmp_SCM_MST_SITE') IS NOT NULL
                 DROP TABLE #tmp_SCM_MST_SITE;

             IF OBJECT_ID('tempdb..#tmp_SSP_KPI_SPA_OTD1_C') IS NOT NULL
                 DROP TABLE #tmp_SSP_KPI_SPA_OTD1_C;

             IF OBJECT_ID('tempdb..#tmp_DIVISION_ID') IS NOT NULL
                 DROP TABLE #tmp_DIVISION_ID;

             IF OBJECT_ID('tempdb..#tmp_MST_FINAL_ITEM') IS NOT NULL
                 DROP TABLE #tmp_MST_FINAL_ITEM;

             IF OBJECT_ID('tempdb..#tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V') IS NOT NULL
                 DROP TABLE #tmp_SCM_MST_MODEL_FINAL_ITEM_BOM_V;
  
    SET @v_exec_time    =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second, @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second, @v_start_time, SYSDATETIME())/ 60))) + ':' + REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second, @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second, @v_start_time, SYSDATETIME()))% 60))
       
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

		
  END;
