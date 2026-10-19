
/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_S  
 * Description  :
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PRODUCTION_PLAN_S N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.01   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.04.04   LTW         CELL계획(활성화)의 operation_qty ,start_time 사용으러 변경
 * 2018.04.12   LTW         출하 데이터가 아닌 생산계획의 LPST기준 데이터로 REQUIREMENT 소스 데이터 변경 하여 데이터 생성
 * 2018.06.15   LTW         트랙잭션 제거
 * 2018.06.22   LTW         SCP 52주 제한 로직 추가
 * 2018.07.03   LTW         전극 SCP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
 * 2018.08.30   LTW         외주 PACKER 데이터 처리를 위한 로직 변경(주석처리 : AND LEFT(wo.operation_id,1)    IN (N'E',N'A',N'P'))
 * 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응
 * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.23	KSW			GM JV 반영 :: 81_UC, EE_UC  추가
 * 2022.06.27   sclee.lee   PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.28   hrkim		PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2025.11.14   kimcd       [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                          JV ESS 생산에 따른 가상 Plant 계획 정보 복사
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_S]
    ( @p_plan_cycle           NVARCHAR(150)          
    , @p_plan_start_yyyymmdd  NVARCHAR(8)     -- plan_name       
    , @p_plan_id              NVARCHAR(4000)          
    , @p_modeling_id          NVARCHAR(4000)          
    , @p_seq                  NVARCHAR(4000)          
    , @p_plan_type            NVARCHAR(4000)          
    , @p_master_id            NVARCHAR(4000)          
    , @p_division_id          NVARCHAR(30)          
    , @p_engine_plan_id       NVARCHAR(4000)          
    , @p_user_id              NVARCHAR(150)  = 'scp_batch' 
    -- , @p_debug       INT OUTPUT
) AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON;
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS OFF;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = N'';  
    SET @v_batch_user = @p_user_id
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PRODUCTION_PLAN_S';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      -- 상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PRODUCTION_PLAN'; -- 테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_PRODUCTION_PLAN INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count 
                              ,@p_log_message   =@v_log_message 
                              ,@p_description   =@v_description 
                              ,@p_event_date    =@d_event_date 
                              ,@p_user_id       =@v_batch_user
                              ;   
                              ;        
    -- 임시 실행시간 확인용            
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';
    
    BEGIN TRY
      BEGIN
    
        /*
        Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_S
        */

        --BEGIN TRANSACTION; 

        --SCP 52주 계획
        DECLARE @v_scp_end_date   datetime;

		-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - start
		-- 변경전
        --SET @v_scp_end_date = DATEADD( WEEK, 52, CONVERT(DATETIME ,@p_plan_start_yyyymmdd,112))--SCP 52주 계획
		--
		DECLARE @v_pet_date		NVARCHAR(12) = '';

		--  Plan End Date
		SELECT @v_pet_date = p.horizon_end_date
		FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		WHERE  p.division_id = @p_division_id
		AND    p.plan_id     = @p_plan_id ;

		SET @v_scp_end_date = DATEADD(DAY, 1, CONVERT(DATETIME, @v_pet_date, 112));
		-- * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응 - end


        ----------------------------------------------------------- 
        -- 1. SCP_ANL_PRODUCTION_PLAN 작업 measure 부분 삭제
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type ,seq ,measure 에 해당하는데이터 삭제
        ----------------------------------------------------------- 
        DELETE SCP_ANL_PRODUCTION_PLAN 
         WHERE 1=1
           AND division_id         = @p_division_id 
           AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
           AND plan_type           = @p_plan_type 
           AND seq                 = @p_seq 
           AND measure            IN (N'REQUIREMENT')
           ;
        

        ----------------------------------------------------------- 
        -- 2. 출하요청(REQUIREMENT) 데이터 ANL 적재
        ----------------------------------------------------------- 
        INSERT SCP_ANL_PRODUCTION_PLAN
        (  
            plan_type 
          ,plan_start_yyyymmdd 
          ,seq
          ,division_id 
          ,operation_group 
          ,scm_site_id 
          ,item_id 
          ,line_id 
          ,operation_id
          ,yyyymmdd 
          ,qty
          ,measure 
          ,origin_division_id   --전극 작업 추가
          ,electrode_type       --전극 작업 추가

          ,created_by 
          ,last_updated_by
          ,creation_date
          ,last_update_date
        )
        SELECT @p_plan_type             AS plan_type          
              ,@p_plan_start_yyyymmdd   AS plan_start_yyyymmdd
              ,@p_seq                   AS seq                
              ,@p_division_id           AS division_id        
              ,x.operation_group
              ,x.scm_site_id
              ,x.item_id
              ,x.line_id
              ,x.operation_id 
              ,x.yyyymmdd
              ,x.qty
              ,N'REQUIREMENT'           AS measure
              ,x.origin_division_id     --전극 작업 추가
              ,x.electrode_type         --전극 작업 추가

              ,@p_user_id               AS created_by
              ,@p_user_id               AS last_updated_by
              ,GETDATE()                AS creation_date
              ,GETDATE()                AS last_update_date
          FROM (
                      
                SELECT 
                       wo.master_id
                      ,wo.plan_id
                      ,wo.out_version_id
                      ,wo.plan_type
                      ,wo.plan_start_yyyymmdd
                      ,wo.seq
                      ,wo.division_id
                      ,wo.operation_group
                      ,wo.site_id                 AS scm_site_id
                      ,wo.item_id
                      ,N'*'                       AS line_id
                      ,wo.operation_id            AS operation_id
                      ,(CASE WHEN (CONVERT(NVARCHAR,wo.lpst,112) > @p_plan_start_yyyymmdd ) THEN CONVERT(NVARCHAR,wo.lpst,112) 
                             ELSE @p_plan_start_yyyymmdd 
                        END)                      AS yyyymmdd
                      ,SUM(wo.complete_qty)       AS qty                             
                      ,wo.origin_division_id    --전극 작업 추가
                      ,wo.electrode_type        --전극 작업 추가

                  FROM SCP_PLN_PRODUCTION_PLAN    AS wo WITH(NOLOCK)
					   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
					   INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)
							   ON dm.DIVISION_ID = wo.DIVISION_ID
							  AND dm.VALID_YN	 = 'Y'
                  WHERE 1=1
                    AND wo.master_id              = @p_master_id              --N'EE::WEEKLY'     --
                    AND wo.plan_id                = @p_plan_id                --N'1033'           --
                    AND wo.out_version_id         = @p_engine_plan_id         --N'1033::PR::11'   --
                    AND wo.plan_type              = @p_plan_type              --N'PR'             --
                    AND wo.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd    --N'20180702'       --
                    AND wo.seq                    = @p_seq                    --N'11'             --
                    AND wo.division_id            = @p_division_id            --N'EE'             --
                         
                    AND wo.pegging_type            = N'WORK_ORDER' 
                    --AND LEFT(wo.operation_id,1)    IN (N'E',N'A',N'P')
                    AND (LEFT(wo.operation_id,5)   IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
                                                        SELECT segment1 AS operation_id
                                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
                                                         WHERE lookup_type = N'SCP_PLAN_OPERATION'
                                                      ) 
                        OR

						-- 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - start
						-- Rack operation_id ?????_R1 case 에 대한 대응
						-- old version
						--
                        --wo.operation_id         IN (--외주PACKER의 업체코드
						(CASE WHEN CHARINDEX('_', wo.operation_id) > 0 THEN (SUBSTRING(wo.operation_id, 1, DBO.FN_CHARINDEX_REV(wo.operation_id, '_', 0)-1)) ELSE wo.operation_id END) IN (--외주PACKER의 업체코드
						-- 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end

                                                        SELECT plant_id  AS operation_id
                                                          FROM SCM_MST_SITE WITH(NOLOCK)      
                                                         WHERE 1=1
                                                           -- 2023.03.28 AND division_id = (CASE WHEN wo.division_id IN ('EE', 'EE_UC') THEN wo.origin_division_id		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
                                                           AND division_id = CASE WHEN dm.attribute3 = 'EE'	-- 2023.03.28 PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
																				  THEN wo.origin_division_id
																				  ELSE wo.division_id
																			END 
                                                           AND site_type   = N'PLANT'
                                                           AND osp_yn      = N'Y' 
                                                           AND valid_yn    = N'Y'
                                                      ) 
                        -- PJ20216891	
                        -- ISUZU item
                        OR (
                            LEFT(wo.operation_id,5) = 'P5000'
                            AND EXISTS (
                                        SELECT 1
                                          FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
                                         INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
                                         WHERE A.ITEM_ID = wo.ITEM_ID
                                           AND A.IS_YN = 'Y'
                                       )
                           )
                        )
                    AND CONVERT(NVARCHAR,wo.lpst,112) < @v_scp_end_date --SCP 52주 계획
                  GROUP BY
                        wo.master_id
                       ,wo.plan_id
                       ,wo.out_version_id
                       ,wo.plan_type
                       ,wo.plan_start_yyyymmdd
                       ,wo.seq
                       ,wo.division_id
                       ,wo.operation_group
                       ,wo.site_id
                       ,wo.item_id
                       ,wo.operation_id
                       ,(CASE WHEN (CONVERT(NVARCHAR,wo.lpst,112) > @p_plan_start_yyyymmdd ) THEN CONVERT(NVARCHAR,wo.lpst,112) 
                              ELSE @p_plan_start_yyyymmdd 
                         END) 
                       ,wo.origin_division_id   --전극 작업 추가
                       ,wo.electrode_type       --전극 작업 추가
                ) AS x
                ;
        
        
        --PRINT N'프로시저 종료'

		-- 2025.11.14   kimcd       [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 시작
        --                          JV ESS 생산에 따른 가상 Plant 계획 정보 복사
        SET @v_log_message = N'########## Copy from Virtual Plant ##########';
        SET @v_description = @v_program_name + ':' + N' Check Plan Copy Division';
        SET @d_event_date = SYSDATETIME();
		EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
								  ,@p_log_type      =@v_log_type
								  ,@p_log_count     =@n_log_count 
								  ,@p_log_message   =@v_log_message 
								  ,@p_description   =@v_description 
								  ,@p_event_date    =@d_event_date 
								  ,@p_user_id       =@v_batch_user
								  ;

		DECLARE @v_to_division_id    NVARCHAR(30);
		DECLARE @v_from_division_id    NVARCHAR(30);

		SELECT  TOP 1 @v_to_division_id = MS2.DIVISION_ID
		FROM    SCM_MST_SITE MS WITH(NOLOCK)
		        INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
				    ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID
		WHERE   MS.DIVISION_ID = @p_division_id
		AND     MS.SITE_TYPE   = 'PLANT'
		AND     MS.VALID_YN    = 'Y';

		IF @v_to_division_id > ''
		    BEGIN
				SET @v_log_message = N'########## copy from Virtual Plant ##########';
				SET @v_description = @v_program_name + ':' + N' copy from current Division';
				SET @d_event_date = SYSDATETIME();
				EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
										  ,@p_log_type      =@v_log_type
										  ,@p_log_count     =@n_log_count 
										  ,@p_log_message   =@v_log_message 
										  ,@p_description   =@v_description 
										  ,@p_event_date    =@d_event_date 
										  ,@p_user_id       =@v_batch_user
										  ;
				DELETE SAP
				FROM   SCP_ANL_PRODUCTION_PLAN SAP
                	   INNER JOIN ( SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
									             ,PM.DIVISION_ID
												 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																	 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																			  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																			  ,PD.PLAN_SEQ DESC) AS NUM
											FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
											       INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
   												       ON  PM.PLAN_ID     = PD.PLAN_ID
													   AND PM.DIVISION_ID = PD.DIVISION_ID
											WHERE  PM.DIVISION_ID        IN (	SELECT DISTINCT MS2.DIVISION_ID
																				FROM    SCM_MST_SITE MS WITH(NOLOCK)
																						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																							ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
																				WHERE   MS.DIVISION_ID = @p_division_id
																				AND     MS.SITE_TYPE   = 'PLANT'
																				AND     MS.VALID_YN    = 'Y')
											AND    PM.PLAN_ID            = @p_plan_id
											AND    PM.PLAN_CYCLE         = @p_plan_cycle
											AND    PD.PLAN_STATUS        = '1'
											AND    PD.DISPLAY_YN         = 'Y'
											AND    PD.UI_DISPLAY_YN      = 'Y'
											AND    PD.NORMAL_COMPLETE_YN = 'Y'
											AND    PD.ACTIVE_FLAG        = 'Y' ) TP
									WHERE NUM = 1 ) PS
							ON  SAP.PLAN_TYPE   = PS.PLAN_TYPE
							AND SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
							AND SAP.SEQ         = PS.PLAN_SEQ
							AND SAP.DIVISION_ID = PS.DIVISION_ID
						INNER JOIN ( SELECT MS2.DIVISION_ID, MS2.SCM_SITE_ID, SAPI.ITEM_ID
									 FROM   SCM_MST_SITE MS WITH(NOLOCK)
											INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
												ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
											INNER JOIN SCP_ANL_PRODUCTION_PLAN SAPI WITH(NOLOCK)
											    ON SAPI.SCM_SITE_ID = MS.SCM_SITE_ID
									WHERE   MS.DIVISION_ID   = @p_division_id
									AND     MS.SITE_TYPE     = 'PLANT'
									AND     MS.VALID_YN      = 'Y'
									AND     SAPI.PLAN_TYPE   = @p_plan_type
									AND     SAPI.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
									AND     SAPI.SEQ         = @p_seq
									AND     SAPI.DIVISION_ID = @p_division_id
									AND     SAPI.MEASURE     = N'REQUIREMENT'
									GROUP   BY SAPI.ITEM_ID, MS2.DIVISION_ID, MS2.SCM_SITE_ID ) MS2  -- ESS를 생산 지원해서 자동차와 중복 생산하는 제품이 없어야 함. 자동차와 중복되는 품목이 있다면 해당 계획도 삭제됨
							ON  SAP.DIVISION_ID = MS2.DIVISION_ID
							AND SAP.SCM_SITE_ID = MS2.SCM_SITE_ID
							AND SAP.ITEM_ID     = MS2.ITEM_ID
				WHERE SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND   SAP.MEASURE = N'REQUIREMENT';

			    WITH PLAN_SEQ AS (  SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
									             ,PM.DIVISION_ID
												 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																	 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																			  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																			  ,PD.PLAN_SEQ DESC) AS NUM
											FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
											       INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
   												       ON  PM.PLAN_ID     = PD.PLAN_ID
													   AND PM.DIVISION_ID = PD.DIVISION_ID
											WHERE  PM.DIVISION_ID        IN (	SELECT DISTINCT MS2.DIVISION_ID
																				FROM    SCM_MST_SITE MS WITH(NOLOCK)
																						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																							ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
																				WHERE   MS.DIVISION_ID = @p_division_id
																				AND     MS.SITE_TYPE   = 'PLANT'
																				AND     MS.VALID_YN    = 'Y')
											AND    PM.PLAN_ID            = @p_plan_id
											AND    PM.PLAN_CYCLE         = @p_plan_cycle
											AND    PD.PLAN_STATUS        = '1'
											AND    PD.DISPLAY_YN         = 'Y'
											AND    PD.UI_DISPLAY_YN      = 'Y'
											AND    PD.NORMAL_COMPLETE_YN = 'Y'
											AND    PD.ACTIVE_FLAG        = 'Y' ) TP
									WHERE NUM = 1 )
				INSERT SCP_ANL_PRODUCTION_PLAN
				(  
				   plan_type 
				  ,plan_start_yyyymmdd 
				  ,seq
				  ,division_id 
				  ,operation_group 
				  ,scm_site_id 
				  ,item_id 
				  ,line_id 
				  ,operation_id
				  ,yyyymmdd 
				  ,qty
				  ,measure 
				  ,origin_division_id   --전극 작업 추가
				  ,electrode_type       --전극 작업 추가

				  ,created_by 
				  ,last_updated_by
				  ,creation_date
				  ,last_update_date
				)
				SELECT PS.PLAN_TYPE             AS plan_type          
					  ,@p_plan_start_yyyymmdd   AS plan_start_yyyymmdd
					  ,PS.PLAN_SEQ              AS seq                
					  ,PS.DIVISION_ID           AS division_id        
					  ,x.operation_group
					  ,MS2.SCM_SITE_ID
					  ,x.item_id
					  ,x.line_id
					  ,x.operation_id 
					  ,x.yyyymmdd
					  ,x.qty
					  ,N'REQUIREMENT'           AS measure
					  ,PS.DIVISION_ID           AS origin_division_id     --전극 작업 추가
					  ,x.electrode_type         --전극 작업 추가
					  ,@p_user_id               AS created_by
					  ,@p_user_id               AS last_updated_by
					  ,GETDATE()                AS creation_date
					  ,GETDATE()                AS last_update_date
				  FROM (
                      
						SELECT 
							   wo.master_id
							  ,wo.plan_id
							  ,wo.out_version_id
							  ,wo.plan_type
							  ,wo.plan_start_yyyymmdd
							  ,wo.seq
							  ,wo.division_id
							  ,wo.operation_group
							  ,wo.site_id                 AS scm_site_id
							  ,wo.item_id
							  ,N'*'                       AS line_id
							  ,wo.operation_id            AS operation_id
							  ,(CASE WHEN (CONVERT(NVARCHAR,wo.lpst,112) > @p_plan_start_yyyymmdd ) THEN CONVERT(NVARCHAR,wo.lpst,112) 
									 ELSE @p_plan_start_yyyymmdd 
								END)                      AS yyyymmdd
							  ,SUM(wo.complete_qty)       AS qty                             
							  ,wo.origin_division_id    --전극 작업 추가
							  ,wo.electrode_type        --전극 작업 추가

						  FROM SCP_PLN_PRODUCTION_PLAN    AS wo WITH(NOLOCK)
							   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
							   INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)
									   ON dm.DIVISION_ID = wo.DIVISION_ID
									  AND dm.VALID_YN	 = 'Y'
						  WHERE 1=1
							AND wo.master_id              = @p_master_id              --N'EE::WEEKLY'     --
							AND wo.plan_id                = @p_plan_id                --N'1033'           --
							AND wo.out_version_id         = @p_engine_plan_id         --N'1033::PR::11'   --
							AND wo.plan_type              = @p_plan_type              --N'PR'             --
							AND wo.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd    --N'20180702'       --
							AND wo.seq                    = @p_seq                    --N'11'             --
							AND wo.division_id            = @p_division_id            --N'EE'             --
                         
							AND wo.pegging_type            = N'WORK_ORDER' 
							--AND LEFT(wo.operation_id,1)    IN (N'E',N'A',N'P')
							AND (LEFT(wo.operation_id,5)   IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
																SELECT segment1 AS operation_id
																  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
																 WHERE lookup_type = N'SCP_PLAN_OPERATION'
															  ) 
								OR

								-- 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - start
								-- Rack operation_id ?????_R1 case 에 대한 대응
								-- old version
								--
								--wo.operation_id         IN (--외주PACKER의 업체코드
								(CASE WHEN CHARINDEX('_', wo.operation_id) > 0 THEN (SUBSTRING(wo.operation_id, 1, DBO.FN_CHARINDEX_REV(wo.operation_id, '_', 0)-1)) ELSE wo.operation_id END) IN (--외주PACKER의 업체코드
								-- 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end

																SELECT plant_id  AS operation_id
																  FROM SCM_MST_SITE WITH(NOLOCK)      
																 WHERE 1=1
																   -- 2023.03.28 AND division_id = (CASE WHEN wo.division_id IN ('EE', 'EE_UC') THEN wo.origin_division_id		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
																   AND division_id = CASE WHEN dm.attribute3 = 'EE'	-- 2023.03.28 PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
																						  THEN wo.origin_division_id
																						  ELSE wo.division_id
																					END 
																   AND site_type   = N'PLANT'
																   AND osp_yn      = N'Y' 
																   AND valid_yn    = N'Y'
															  ) 
								-- PJ20216891	
								-- ISUZU item
								OR (
									LEFT(wo.operation_id,5) = 'P5000'
									AND EXISTS (
												SELECT 1
												  FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
												 INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
												 WHERE A.ITEM_ID = wo.ITEM_ID
												   AND A.IS_YN = 'Y'
											   )
								   )
								)
							AND CONVERT(NVARCHAR,wo.lpst,112) < @v_scp_end_date --SCP 52주 계획
						  GROUP BY
								wo.master_id
							   ,wo.plan_id
							   ,wo.out_version_id
							   ,wo.plan_type
							   ,wo.plan_start_yyyymmdd
							   ,wo.seq
							   ,wo.division_id
							   ,wo.operation_group
							   ,wo.site_id
							   ,wo.item_id
							   ,wo.operation_id
							   ,(CASE WHEN (CONVERT(NVARCHAR,wo.lpst,112) > @p_plan_start_yyyymmdd ) THEN CONVERT(NVARCHAR,wo.lpst,112) 
									  ELSE @p_plan_start_yyyymmdd 
								 END) 
							   ,wo.origin_division_id   --전극 작업 추가
							   ,wo.electrode_type       --전극 작업 추가
						) AS x
					    INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
						    ON  X.DIVISION_ID = MS.division_id
							AND X.SCM_SITE_ID = MS.SCM_SITE_ID
							AND MS.SITE_TYPE   = 'PLANT'
							AND MS.VALID_YN    = 'Y'
		                INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
				            ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID
						INNER JOIN PLAN_SEQ PS
						    ON MS2.DIVISION_ID = PS.DIVISION_ID
						;
			END;
		ELSE -- IF @v_to_division_id > ''
		    BEGIN
				SELECT  TOP 1 @v_from_division_id = MS2.DIVISION_ID
				FROM    SCM_MST_SITE MS WITH(NOLOCK)
						INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
							ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9
				WHERE   MS.DIVISION_ID = @p_division_id
				AND     MS.SITE_TYPE   = 'PLANT'
				AND     MS.VALID_YN    = 'Y';

				IF @v_from_division_id > ''
				    BEGIN
						SET @v_log_message = N'########## copy to Current Division ##########';
						SET @v_description = @v_program_name + ':' + N' copy to current Division';
						SET @d_event_date = SYSDATETIME();
						EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
												  ,@p_log_type      =@v_log_type
												  ,@p_log_count     =@n_log_count 
												  ,@p_log_message   =@v_log_message 
												  ,@p_description   =@v_description 
												  ,@p_event_date    =@d_event_date 
												  ,@p_user_id       =@v_batch_user
												  ;

						WITH PLAN_SEQ AS (  SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
											FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
														 ,PM.DIVISION_ID
														 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																			 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																					  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																					  ,PD.PLAN_SEQ DESC) AS NUM
													FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
														   INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
		   												       ON  PM.PLAN_ID     = PD.PLAN_ID
															   AND PM.DIVISION_ID = PD.DIVISION_ID
													WHERE  PM.DIVISION_ID        IN (	SELECT  MS2.DIVISION_ID
																						FROM    SCM_MST_SITE MS WITH(NOLOCK)
																								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																									ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
																						WHERE   MS.DIVISION_ID = @p_division_id
																						AND     MS.SITE_TYPE   = 'PLANT'
																						AND     MS.VALID_YN    = 'Y')
													AND    PM.PLAN_ID            = @p_plan_id
													AND    PM.PLAN_CYCLE         = @p_plan_cycle
													AND    PD.PLAN_STATUS        = '1'
													AND    PD.DISPLAY_YN         = 'Y'
													AND    PD.UI_DISPLAY_YN      = 'Y'
													AND    PD.NORMAL_COMPLETE_YN = 'Y'
													AND    PD.ACTIVE_FLAG        = 'Y' ) TP
											WHERE NUM = 1 )
						DELETE SAP
						FROM   SCP_ANL_PRODUCTION_PLAN SAP
								INNER JOIN ( SELECT MS2.DIVISION_ID, MS2.SCM_SITE_ID, WO.ITEM_ID
											 FROM   SCP_ANL_PRODUCTION_PLAN    AS wo WITH(NOLOCK)
													INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)
															ON dm.DIVISION_ID = wo.DIVISION_ID
															AND dm.VALID_YN	 = 'Y'
													INNER JOIN PLAN_SEQ  PS --MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									   					ON  wo.plan_type              = PS.PLAN_TYPE              --N'PR'             --
														AND wo.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd    --N'20180702'       --
														AND wo.seq                    = PS.PLAN_SEQ               --N'11'             --
														AND wo.division_id            = PS.DIVISION_ID            --N'EE'             --
													INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
														ON  MS.DIVISION_ID = WO.DIVISION_ID
														AND MS.SCM_SITE_ID = WO.SCM_SITE_ID
													INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
														ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID -- 실제 생산 Site가 Attribute9에 관리됨
											WHERE   MS2.DIVISION_ID = @p_division_id
											AND     MS.SITE_TYPE   = 'PLANT'
											AND     MS.VALID_YN    = 'Y'
											AND     MS2.SITE_TYPE  = 'PLANT'
											AND     MS2.VALID_YN   = 'Y'
											AND     WO.MEASURE     = N'REQUIREMENT'
											AND     WO.QTY         > 0
											GROUP   BY MS2.DIVISION_ID, MS2.SCM_SITE_ID, WO.ITEM_ID
											) MS
									ON  SAP.DIVISION_ID = MS.DIVISION_ID
									AND SAP.SCM_SITE_ID = MS.SCM_SITE_ID
									AND SAP.ITEM_ID     = MS.ITEM_ID
						WHERE SAP.PLAN_TYPE   = @p_plan_type
						AND   SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   SAP.SEQ         = @p_seq
						AND   SAP.DIVISION_ID = @p_division_id
						AND   SAP.MEASURE     = N'REQUIREMENT';

						WITH PLAN_SEQ AS (  SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
											FROM  (SELECT PD.MODELING_ID, PD.PLAN_SEQ, PD.PLAN_TYPE, PM.DIVISION_ID+'::'+ PM.PLAN_CYCLE AS MASTER_ID, PM.PLAN_ID + '::' + PD.PLAN_TYPE + '::' + CONVERT(NVARCHAR(30),PD.PLAN_SEQ)  AS ENGINE_PLAN_ID
														 ,PM.DIVISION_ID
														 ,ROW_NUMBER() OVER (PARTITION BY PM.DIVISION_ID
																			 ORDER BY  CASE PD.PLAN_TYPE WHEN 'FN' THEN 1 WHEN 'SE' THEN 2 WHEN 'MA' THEN 3 WHEN 'PR' THEN 4 ELSE 5 END
																					  ,CASE WHEN PD.CONFIRM_FLAG = 'Y' THEN 1 ELSE 2 END
																					  ,PD.PLAN_SEQ DESC) AS NUM
													FROM   SCM_MST_PLAN        PM WITH(NOLOCK)
														   INNER JOIN SCM_MST_PLAN_DETAIL PD WITH(NOLOCK)
		   												       ON  PM.PLAN_ID     = PD.PLAN_ID
															   AND PM.DIVISION_ID = PD.DIVISION_ID
													WHERE  PM.DIVISION_ID        IN (	SELECT  MS2.DIVISION_ID
																						FROM    SCM_MST_SITE MS WITH(NOLOCK)
																								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
																									ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
																						WHERE   MS.DIVISION_ID = @p_division_id
																						AND     MS.SITE_TYPE   = 'PLANT'
																						AND     MS.VALID_YN    = 'Y')
													AND    PM.PLAN_ID            = @p_plan_id
													AND    PM.PLAN_CYCLE         = @p_plan_cycle
													AND    PD.PLAN_STATUS        = '1'
													AND    PD.DISPLAY_YN         = 'Y'
													AND    PD.UI_DISPLAY_YN      = 'Y'
													AND    PD.NORMAL_COMPLETE_YN = 'Y'
													AND    PD.ACTIVE_FLAG        = 'Y' ) TP
											WHERE NUM = 1 )
						INSERT SCP_ANL_PRODUCTION_PLAN
						(  
						   plan_type 
						  ,plan_start_yyyymmdd 
						  ,seq
						  ,division_id 
						  ,operation_group 
						  ,scm_site_id 
						  ,item_id 
						  ,line_id 
						  ,operation_id
						  ,yyyymmdd 
						  ,qty
						  ,measure 
						  ,origin_division_id   --전극 작업 추가
						  ,electrode_type       --전극 작업 추가

						  ,created_by 
						  ,last_updated_by
						  ,creation_date
						  ,last_update_date
						)
						SELECT @p_plan_type             AS plan_type          
							  ,@p_plan_start_yyyymmdd   AS plan_start_yyyymmdd
							  ,@p_seq                   AS seq                
							  ,@p_division_id           AS division_id        
							  ,x.operation_group
							  ,MS2.SCM_SITE_ID
							  ,x.item_id
							  ,x.line_id
							  ,x.operation_id 
							  ,x.yyyymmdd
							  ,x.qty
							  ,N'REQUIREMENT'           AS measure
							  ,@p_division_id           AS origin_division_id     --전극 작업 추가
							  ,x.electrode_type         --전극 작업 추가
							  ,@p_user_id               AS created_by
							  ,@p_user_id               AS last_updated_by
							  ,GETDATE()                AS creation_date
							  ,GETDATE()                AS last_update_date
						  FROM (
                      
								SELECT 
									   wo.master_id
									  ,wo.plan_id
									  ,wo.out_version_id
									  ,wo.plan_type
									  ,wo.plan_start_yyyymmdd
									  ,wo.seq
									  ,wo.division_id
									  ,wo.operation_group
									  ,wo.site_id                 AS scm_site_id
									  ,wo.item_id
									  ,N'*'                       AS line_id
									  ,wo.operation_id            AS operation_id
									  ,(CASE WHEN (CONVERT(NVARCHAR,wo.lpst,112) > @p_plan_start_yyyymmdd ) THEN CONVERT(NVARCHAR,wo.lpst,112) 
											 ELSE @p_plan_start_yyyymmdd 
										END)                      AS yyyymmdd
									  ,SUM(wo.complete_qty)       AS qty                             
									  ,wo.origin_division_id    --전극 작업 추가
									  ,wo.electrode_type        --전극 작업 추가

								  FROM SCP_PLN_PRODUCTION_PLAN    AS wo WITH(NOLOCK)
									   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
									   INNER JOIN SCM_MST_DIVISION AS dm WITH(NOLOCK)
											   ON dm.DIVISION_ID = wo.DIVISION_ID
											  AND dm.VALID_YN	 = 'Y'
									   INNER JOIN PLAN_SEQ  PS --MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
									   	    ON  wo.master_id              = PS.MASTER_ID              --N'EE::WEEKLY'     --
											AND wo.plan_id                = @p_plan_id                --N'1033'           --
											AND wo.out_version_id         = PS.ENGINE_PLAN_ID         --N'1033::PR::11'   --
											AND wo.plan_type              = PS.PLAN_TYPE              --N'PR'             --
											AND wo.plan_start_yyyymmdd    = @p_plan_start_yyyymmdd    --N'20180702'       --
											AND wo.seq                    = PS.PLAN_SEQ               --N'11'             --
											AND wo.division_id            = PS.DIVISION_ID            --N'EE'             --
								  WHERE 1=1
									AND wo.pegging_type            = N'WORK_ORDER' 
									--AND LEFT(wo.operation_id,1)    IN (N'E',N'A',N'P')
									AND (LEFT(wo.operation_id,5)   IN (--LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회
																		SELECT segment1 AS operation_id
																		  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)   
																		 WHERE lookup_type = N'SCP_PLAN_OPERATION'
																	  ) 
										OR

										-- 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - start
										-- Rack operation_id ?????_R1 case 에 대한 대응
										-- old version
										--
										--wo.operation_id         IN (--외주PACKER의 업체코드
										(CASE WHEN CHARINDEX('_', wo.operation_id) > 0 THEN (SUBSTRING(wo.operation_id, 1, DBO.FN_CHARINDEX_REV(wo.operation_id, '_', 0)-1)) ELSE wo.operation_id END) IN (--외주PACKER의 업체코드
										-- 2020.10.29   KSW         PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK biz. 대응 - end

																		SELECT plant_id  AS operation_id
																		  FROM SCM_MST_SITE WITH(NOLOCK)      
																		 WHERE 1=1
																		   -- 2023.03.28 AND division_id = (CASE WHEN wo.division_id IN ('EE', 'EE_UC') THEN wo.origin_division_id		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
																		   AND division_id = CASE WHEN dm.attribute3 = 'EE'	-- 2023.03.28 PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
																								  THEN wo.origin_division_id
																								  ELSE wo.division_id
																							END 
																		   AND site_type   = N'PLANT'
																		   AND osp_yn      = N'Y' 
																		   AND valid_yn    = N'Y'
																	  ) 
										-- PJ20216891	
										-- ISUZU item
										OR (
											LEFT(wo.operation_id,5) = 'P5000'
											AND EXISTS (
														SELECT 1
														  FROM dbo.SCM_MST_FINAL_ITEM_V A WITH(NOLOCK)
														 INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B WITH(NOLOCK) ON A.ITEM_ID = B.ITEM_ID
														 WHERE A.ITEM_ID = wo.ITEM_ID
														   AND A.IS_YN = 'Y'
													   )
										   )
										)
									AND CONVERT(NVARCHAR,wo.lpst,112) < @v_scp_end_date --SCP 52주 계획
								  GROUP BY
										wo.master_id
									   ,wo.plan_id
									   ,wo.out_version_id
									   ,wo.plan_type
									   ,wo.plan_start_yyyymmdd
									   ,wo.seq
									   ,wo.division_id
									   ,wo.operation_group
									   ,wo.site_id
									   ,wo.item_id
									   ,wo.operation_id
									   ,(CASE WHEN (CONVERT(NVARCHAR,wo.lpst,112) > @p_plan_start_yyyymmdd ) THEN CONVERT(NVARCHAR,wo.lpst,112) 
											  ELSE @p_plan_start_yyyymmdd 
										 END) 
									   ,wo.origin_division_id   --전극 작업 추가
									   ,wo.electrode_type       --전극 작업 추가
								) AS x
								INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
									ON  X.DIVISION_ID = MS.division_id
									AND X.SCM_SITE_ID = MS.SCM_SITE_ID
									AND MS.SITE_TYPE   = 'PLANT'
									AND MS.VALID_YN    = 'Y'
								INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
									ON  MS.ATTRIBUTE9   = MS2.SCM_SITE_ID
								    AND MS2.DIVISION_ID = @p_division_id
								;
					END; -- IF @v_from_division_id > ''
			END; -- IF @v_to_division_id > ''
		-- 2025.11.14   kimcd       [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 끝

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        --IF @@TRANCOUNT > 0 
        --  BEGIN
        --    COMMIT WORK;
        --  END;

        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    -- 로그타입
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = N'INSERT INTO '+@v_table_id;
        SET @v_description = N'Process Complete...' + ':' + CONVERT(CHAR(23) ,@d_event_date ,121);
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
        
      --IF @@TRANCOUNT > 0 
      --  BEGIN
      --    ROLLBACK;
      --  END;
      
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
    
     -- 임시 운영반영시에 주석처리 할것.            
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +             
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))             
        
    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description  = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';
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

