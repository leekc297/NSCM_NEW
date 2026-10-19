
/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN  
 * Description  :
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PRODUCTION_PLAN N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.01   LTW         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.03.29   yydok       scp_pln_production_plan_v 적용
 * 2018.06.15   LTW         트랙잭션 제거
 * 2018.06.22   LTW         SCP 52주 제한 로직 추가
 * 2018.07.03   LTW         전극 SCP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
 * 2018.12.26   KTH         CELL_QTY 반영(DIVISION_ID ='EE' AND OPERATION_GROUP ='E') 인경우
 * 2019.02.19   YYDOK       CELL_QTY 반영로직 변경
 *                          82사업부의 전극을 81 OR 40사업부라인에서 생산하는 경우때문에
 *                          X.ORIGIN_DIVISION_ID    = Y.DIVISION_ID 조인조건 제거후 MIN값 사용. 
 * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.23	KSW			GM JV 반영 :: 81_UC, EE_UC  추가
 * 2023.03.28	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2023.07.03	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 대응 CP 생산계획 삭제(7월은 국내만, 8월은 해외까지) 
 * 2023.07.05	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 대응 CP 생산계획 삭제(전극 고려하여 추가 수정) 
 * 2023/07/17	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : 활성화코드 분리 대응 (8월 해외 오픈 대응) 
 * 2023/08/03	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : PJ20230692 SCM 역량 강화 위한 SCP 개선과제 이행 Phase2 : 전주FN plan 참조시 CP 제외  
 * 2025.11.14   kimcd       [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
 *                          JV ESS 생산에 따른 가상 Plant 계획 정보 복사
 * 2026.04.23   YMH         E20260331-000738 82사업부 MA Plan 수행 시 속도지연
*/
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_YMH_20260507]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PRODUCTION_PLAN';
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
    
    
        -- 임시 실행시간 확인용                
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();                
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';     

    BEGIN TRY
      BEGIN
    
        /*
        Program ID   : PR_SCP_ANL_PRODUCTION_PLAN
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
        -- 1. SCP_ANL_PRODUCTION_PLAN 삭제
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type 과 같은 데이터가 있으면 삭제한다.
        -- 1.2. 임시테이블 생성
        ----------------------------------------------------------- 
        DELETE SCP_ANL_PRODUCTION_PLAN 
        WHERE division_id = @p_division_id 
          AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
          AND plan_type = @p_plan_type 
          AND seq = @p_seq 
          AND measure IN (N'PROD_PLAN_BEFORE',N'PROD_PLAN_ENGINE',N'PROD_PLAN_AMEND')
          ;

        -- 지난주차 승인 계획 임시테이블 생성
        IF OBJECT_ID('tempdb..#Tbl_PREV_PLAN_ITEM') IS NOT NULL
          DROP TABLE #Tbl_PREV_PLAN_ITEM
        CREATE TABLE #Tbl_PREV_PLAN_ITEM (
           division_id        nvarchar(30)
          ,operation_group    nvarchar(10)
          ,site_id            nvarchar(30)
          ,item_id            nvarchar(50)
          ,line_id            nvarchar(50)
          ,operation_id       nvarchar(30)
          ,yyyymmdd           nvarchar(8)
          ,qty                numeric(20,10)
          ,origin_division_id nvarchar(30)      --전극 작업 추가
          ,electrode_type     nvarchar(30)      --전극 작업 추가
          ,measure            nvarchar(50)
        );

        --작업용 임시테이블 생성
        IF OBJECT_ID('tempdb..#Tbl_PLAN_WORK') IS NOT NULL
          DROP TABLE #Tbl_PLAN_WORK
        CREATE TABLE #Tbl_PLAN_WORK (
           plan_type	          nvarchar(50)	
          ,plan_start_yyyymmdd	nvarchar(8)	
          ,seq	                bigint	
          
          ,division_id	        nvarchar(30)	
          ,operation_group	    nvarchar(10)	
          ,scm_site_id    	    nvarchar(30)	
          ,item_id	            nvarchar(50)	
          ,line_id	            nvarchar(50)	
          ,operation_id	        nvarchar(30)	
          ,measure	            nvarchar(50)	          
          ,yyyymmdd	            nvarchar(8)	
          ,qty	                numeric(20,10)	          
          ,origin_division_id   nvarchar(30)    --전극 작업 추가
          ,electrode_type       nvarchar(30)    --전극 작업 추가

          ,created_by           nvarchar(150)
          ,last_updated_by      nvarchar(150)
          ,creation_date        datetime
          ,last_update_date     datetime

        );

        --지난주차 일자/PLAN 변수
        DECLARE @v_prev_basis_start NVARCHAR(8)
        DECLARE @v_prev_basis_end   NVARCHAR(8)
        DECLARE @v_prev_plan_id     NVARCHAR(30)
        DECLARE @v_prev_plan_name   NVARCHAR(100)
        DECLARE @v_prev_seq         INT

        --지난주차 일자 구하기
        SELECT @v_prev_basis_start = a.basis_start_date 
              ,@v_prev_basis_end   = a.basis_end_date
          FROM SCM_SYS_CALENDAR_M AS a WITH(NOLOCK) 
         WHERE 1=1
           AND a.basis_date IN ( SELECT dbo.fn_get_bucket_yyyymmdd(-1)); 
        
        
        --지난주차 컨펌된 플랜
        SELECT @v_prev_plan_id   = p.plan_id 
              ,@v_prev_plan_name = p.plan_name 
              ,@v_prev_seq       = d.plan_seq
          FROM SCM_MST_PLAN             AS p WITH(NOLOCK) 
         INNER JOIN SCM_MST_PLAN_DETAIL AS d with(nolock) 
                ON p.division_id = d.division_id 
               AND p.plan_id     = d.plan_id 
         WHERE 1=1 
          --AND p.plan_cycle       = @p_plan_cycle
           AND p.division_id      = @p_division_id
           AND p.plan_name        = @v_prev_basis_start
           AND d.plan_type        = N'FN'
           AND d.active_flag      = N'Y'
           AND d.confirm_flag     = N'Y'    -- 담당자가 CONFIRM한 플랜
           ;

        ----------------------------------------------------------- 
        --지난주 일자로 CONFIRM된 정보가 있으면 지난주차 계획 데이터 조회
        ----------------------------------------------------------- 
        IF(@v_prev_plan_id is not null AND @v_prev_plan_name is not null and @v_prev_seq is not null)
        BEGIN
          
          ----------------------------------------------------------- 
          --2.지난주차 계획(PROD_PLAN_BEFORE) 데이터 조회
          ----------------------------------------------------------- 
          INSERT #Tbl_PREV_PLAN_ITEM
          SELECT 
                wo.division_id 
               ,wo.operation_group 
               ,wo.site_id    
               ,wo.item_id 
               ,wo.resource_id    
               ,wo.operation_id 
               ,wo.yyyymmdd 
               ,wo.qty 
               ,wo.origin_division_id 
               ,wo.electrode_type 

               ,'PROD_PLAN_BEFORE' as measure 
            FROM SCP_PLN_PRODUCTION_PLAN_V AS wo
				 left join SCP_MST_FINAL_ITEM fi WITH(NOLOCK)	-- 2023.08.03 CP데이터 확인을 위한 조인
						on fi.division_id = wo.division_id
					   and fi.ITEM_ID	  = wo.item_id
					   and fi.attribute8  = 'CP'  
           WHERE 1=1
            --AND wo.master_id           = @p_master_id      --  진행 PLAN master_id 
             AND wo.division_id         = @p_division_id    --  진행 PLAN division_id 
             
             AND wo.plan_id             = @v_prev_plan_id   --지난주 PLAN plan_id 
             AND wo.plan_start_yyyymmdd = @v_prev_plan_name --지난주 PLAN plan_name 
             AND wo.plan_type           = N'FN'             --지난주 PLAN plan_type 
             AND wo.seq                 = @v_prev_seq       --지난주 PLAN seq 
			 AND fi.item_id is null		-- 2023.08.03 CP제외 
             ;
        END


        ----------------------------------------------------------- 
        --3. 생산계획(PROD_PLAN_ENGINE ,PROD_PLAN_BEFORE) 데이터 임시테이블에 적재
        ----------------------------------------------------------- 
        INSERT #Tbl_PLAN_WORK 
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
                  ,measure 
                  ,yyyymmdd 
                  ,qty 
                  ,origin_division_id 
                  ,electrode_type 
                                
                  ,created_by 
                  ,last_updated_by
                  ,creation_date
                  ,last_update_date
               )
                SELECT
                      @p_plan_type 
                     ,@p_plan_start_yyyymmdd 
                     ,@p_seq 
                     ,@p_division_id 
                     ,a.operation_group 
                     ,a.scm_site_id    
                     ,a.item_id
                     ,a.line_id 
                     ,a.operation_id          
                     ,a.measure 
                     ,a.yyyymmdd    
                     ,SUM(a.qty)                  AS qty 
                     ,a.origin_division_id
                     ,a.electrode_type

                     ,@p_user_id 
                     ,@p_user_id
                     ,getdate()
                     ,getdate()
                FROM (
          
                       --생산계획
                       SELECT 
                              wo.division_id
                             ,wo.operation_group
                             ,wo.site_id                AS scm_site_id    
                             ,wo.item_id 
                             ,wo.resource_id            AS  line_id     --엔진에서 line 공정 없는값은 '-'로 들어옴
                             ,wo.operation_id
                             ,wo.yyyymmdd               --View에서 적용
                             ,wo.qty                    --View에서 적용
                             ,wo.origin_division_id
                             ,wo.electrode_type

                             ,'PROD_PLAN_ENGINE'        AS measure
                        FROM SCP_PLN_PRODUCTION_PLAN_V  AS wo 
                       WHERE 1=1
                         AND wo.division_id             = @p_division_id 
                         AND wo.plan_start_yyyymmdd     = @p_plan_start_yyyymmdd 
                         AND wo.plan_type               = @p_plan_type 
                         AND wo.seq                     = @p_seq
                       
                       --지난주차 승인 계획
                       UNION ALL
                      SELECT 
                             pr.division_id
                            ,pr.operation_group
                            ,pr.site_id                 AS scm_site_id    
                            ,pr.item_id
                            ,pr.line_id        
                            ,pr.operation_id   
                            ,pr.yyyymmdd    
                            ,pr.qty 
                            ,pr.origin_division_id 
                            ,pr.electrode_type 
                               
                            ,pr.measure                 -- 'PROD_PLAN_BEFORE'
                        FROM #Tbl_PREV_PLAN_ITEM        AS pr

                    ) AS a 
                GROUP BY 
                      a.measure
                     ,a.division_id
                     ,a.operation_group 
                     ,a.scm_site_id     
                     ,a.item_id 
                     ,a.line_id 
                     ,a.operation_id 
                     ,a.yyyymmdd
                     ,a.origin_division_id
                     ,a.electrode_type
                     ;  

        
        ----------------------------------------------------------- 
        --4. 생산계획(PROD_PLAN_AMEND) 데이터 임시테이블에 적재
        ----------------------------------------------------------- 
        INSERT #Tbl_PLAN_WORK 
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
                  ,measure 
                  ,yyyymmdd 
                  ,qty 
                  ,origin_division_id 
                  ,electrode_type 

                  ,created_by 
                  ,last_updated_by
                  ,creation_date
                  ,last_update_date
               )
               SELECT 
                      a.plan_type 
                     ,a.plan_start_yyyymmdd 
                     ,a.seq 
                     ,a.division_id 
                     ,a.operation_group 
                     ,a.scm_site_id    
                     ,a.item_id
                     ,a.line_id 
                     ,a.operation_id          
                     ,'PROD_PLAN_AMEND'  
                     ,a.yyyymmdd    
                     ,a.qty
                     ,a.origin_division_id 
                     ,a.electrode_type 

                     ,a.created_by 
                     ,a.last_updated_by
                     ,a.creation_date
                     ,a.last_update_date
                 FROM #Tbl_PLAN_WORK AS a WITH(NOLOCK)
                WHERE 1=1
                  AND a.measure = 'PROD_PLAN_ENGINE'
                  ;

                
        ----------------------------------------------------------- 
        --5. 생산계획 데이터 ANL 적재
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
                  ,measure 
                  ,yyyymmdd 
                  ,qty 
                  ,origin_division_id 
                  ,electrode_type

                  ,created_by 
                  ,last_updated_by
                  ,creation_date
                  ,last_update_date
               )
               SELECT 
                      a.plan_type 
                     ,a.plan_start_yyyymmdd 
                     ,a.seq 
                     ,a.division_id 
                     ,a.operation_group 
                     ,a.scm_site_id    
                     ,a.item_id
                     ,a.line_id 
                     ,a.operation_id          
                     ,a.measure
                     ,a.yyyymmdd    
                     ,a.qty
                     ,a.origin_division_id 
                     ,a.electrode_type 

                     ,a.created_by 
                     ,a.last_updated_by
                     ,a.creation_date
                     ,a.last_update_date
                 FROM #Tbl_PLAN_WORK AS a WITH(NOLOCK)
                 ;


        ----------------------------------------------------------- 
        --6. 만들어진 'PROD_PLAN_ENGINE','PROD_PLAN_AMEND','PROD_PLAN_BEFORE' MEASURE의 빈날짜 채우기
        ----------------------------------------------------------- 
        INSERT INTO SCP_ANL_PRODUCTION_PLAN
        (  division_id
          ,plan_start_yyyymmdd
          ,plan_type
          ,seq
          ,operation_group
          ,scm_site_id
          ,item_id
          ,line_id
          ,operation_id
          ,measure
          ,yyyymmdd
          ,qty
          ,origin_division_id 
          ,electrode_type 

          ,created_by
          ,creation_date
          ,last_updated_by
          ,last_update_date
          )
          SELECT  sub.division_id
                 ,sub.plan_start_yyyymmdd
                 ,sub.plan_type
                 ,sub.seq
                 ,sub.operation_group
                 ,sub.scm_site_id
                 ,sub.item_id
                 ,sub.line_id
                 ,sub.operation_id
                 ,ms.measure
                 ,sub.yyyymmdd
                 ,0 AS qty
                 ,sub.origin_division_id 
                 ,sub.electrode_type 

                 ,@p_user_id
                 ,GETDATE()
                 ,@p_user_id
                 ,GETDATE()
            FROM 
                (
                  SELECT  division_id
                         ,plan_start_yyyymmdd
                         ,plan_type
                         ,seq
                         ,operation_group
                         ,scm_site_id
                         ,item_id
                         ,line_id
                         ,operation_id
                         ,basis_yyyymmdd AS yyyymmdd                         
                         ,origin_division_id 
                         ,electrode_type 

                  FROM
                        (
                         SELECT basis_yyyymmdd
                           FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                          WHERE basis_yyyymmdd  >= @p_plan_start_yyyymmdd
                            AND basis_yyyymmdd  <  @v_scp_end_date --SCP 52주 계획
                        ) AS a,
                        (
                        SELECT  division_id
                               ,plan_start_yyyymmdd
                               ,plan_type
                               ,seq
                               ,operation_group
                               ,scm_site_id
                               ,item_id
                               ,line_id
                               ,operation_id                               
                               ,MAX(origin_division_id )  AS origin_division_id
                               ,MAX(electrode_type )      AS electrode_type

                          FROM SCP_ANL_PRODUCTION_PLAN AS x WITH(NOLOCK)
                         WHERE 1=1
                           AND division_id         = @p_division_id
                           AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd
                           AND plan_type           = @p_plan_type
                           AND seq                 = @p_seq
                           AND measure             IN( 'PROD_PLAN_ENGINE','PROD_PLAN_BEFORE')
                        GROUP BY division_id
                               ,plan_start_yyyymmdd
                               ,plan_type
                               ,seq
                               ,operation_group
                               ,scm_site_id
                               ,item_id
                               ,line_id
                               ,operation_id
                        ) AS b
                ) AS sub,
                ( SELECT 'PROD_PLAN_ENGINE' AS measure
                  UNION ALL
                  SELECT 'PROD_PLAN_AMEND'  AS measure
                  UNION ALL
                  SELECT 'PROD_PLAN_BEFORE' AS measure 
                  ) AS ms
                WHERE 1=1
                  AND NOT EXISTS (
                                    SELECT 'X'
                                      FROM SCP_ANL_PRODUCTION_PLAN AS z WITH(NOLOCK)
                                     WHERE 1=1
                                       AND z.division_id           = sub.division_id         
                                       AND z.plan_start_yyyymmdd   = sub.plan_start_yyyymmdd 
                                       AND z.plan_type             = sub.plan_type           
                                       AND z.seq                   = sub.seq                 
                                       AND z.operation_group       = sub.operation_group     
                                       AND z.scm_site_id           = sub.scm_site_id         
                                       AND z.item_id               = sub.item_id             
                                       AND z.line_id               = sub.line_id             
                                       AND z.operation_id          = sub.operation_id        
                                       AND z.measure               = ms.measure             
                                       AND z.yyyymmdd              = sub.yyyymmdd            
                                     --  AND z.origin_division_id    = sub.origin_division_id            
                                     --  AND z.electrode_type        = sub.electrode_type     
                                  )
                                  ;

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
                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
                -- 기존 로직 주석처리.
                /*
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
						INNER JOIN ( SELECT LM.OPERATION_ID, LM.ELECTRODE_TYPE, LM.LINK_LINE_ID AS LINE_ID, MS2.DIVISION_ID, MS2.SCM_SITE_ID
									 FROM   SCM_MST_SITE MS WITH(NOLOCK)
											INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
												ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
                                            INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
											    ON  LM.PLANT_ID = MS.PLANT_ID
												AND LM.LINK_LINE_ID > ''
									WHERE   MS.DIVISION_ID = @p_division_id
									AND     MS.SITE_TYPE   = 'PLANT'
									AND     MS.VALID_YN    = 'Y'
									) MS2
							ON  SAP.DIVISION_ID  = MS2.DIVISION_ID
							AND SAP.SCM_SITE_ID  = MS2.SCM_SITE_ID
							AND SAP.OPERATION_ID = MS2.OPERATION_ID
							AND SAP.LINE_ID      = MS2.LINE_ID
				WHERE SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
				AND   SAP.MEASURE IN ( 'PROD_PLAN_AMEND', 'PROD_PLAN_ENGINE' ); 
				-- REQUIREMENT는 계획에 존재하는 품목 기준으로 삭제. ESS를 생산 지원해서 자동차와 중복 생산하는 제품이 없어야 함. 자동차와 중복되는 품목이 있다면 해당 계획도 삭제됨
				-- 계획은 라인 기준으로 삭제 - 로직 불일치로 인한 부작용 가능성.. 존재
                */
                -- E20260331-000738 82사업부 MA Plan 수행 시 속도지연
                -- 신규로직 시작
                SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
                    INTO #PLAN_SEQ
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
				WHERE NUM = 1 

                SELECT LM.OPERATION_ID, LM.ELECTRODE_TYPE, LM.LINK_LINE_ID AS LINE_ID, MS2.DIVISION_ID, MS2.SCM_SITE_ID
                    INTO #LINE_SITE
                FROM   SCM_MST_SITE MS WITH(NOLOCK)
				    INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
					    ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
                    INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
					    ON  LM.PLANT_ID = MS.PLANT_ID
					    AND LM.LINK_LINE_ID > ''
				WHERE   MS.DIVISION_ID = @p_division_id
				AND     MS.SITE_TYPE   = 'PLANT'
				AND     MS.VALID_YN    = 'Y'

                CREATE INDEX IX_TMP_PLAN_SEQ
                ON #PLAN_SEQ
                (
                    DIVISION_ID,
                    PLAN_TYPE,
                    PLAN_SEQ
                )
                ;

                CREATE INDEX IX_TMP_LINE_SITE
                ON #LINE_SITE
                (
                    DIVISION_ID,
                    SCM_SITE_ID,
                    OPERATION_ID,
                    LINE_ID
                )
                ;

                DELETE SAP
                FROM SCP_ANL_PRODUCTION_PLAN SAP
                    JOIN #PLAN_SEQ PS
                    ON  SAP.PLAN_TYPE       = PS.PLAN_TYPE
                    AND SAP.SEQ             = PS.PLAN_SEQ
                    AND SAP.DIVISION_ID     = PS.DIVISION_ID
                    JOIN #LINE_SITE LS
                    ON  SAP.DIVISION_ID     = LS.DIVISION_ID
                    AND SAP.SCM_SITE_ID     = LS.SCM_SITE_ID
                    AND SAP.OPERATION_ID    = LS.OPERATION_ID
                    AND SAP.LINE_ID         = LS.LINE_ID
                 WHERE SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
                 AND SAP.MEASURE IN ('PROD_PLAN_AMEND','PROD_PLAN_ENGINE')
                -- 신규로직 끝

                ;
			    WITH PLAN_SEQ AS 
                (
                                    SELECT MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
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
									WHERE NUM = 1 
                )
				INSERT INTO SCP_ANL_PRODUCTION_PLAN
					(  division_id
					  ,plan_start_yyyymmdd
					  ,plan_type
					  ,seq
					  ,operation_group
					  ,scm_site_id
					  ,item_id
					  ,line_id
					  ,operation_id
					  ,measure
					  ,yyyymmdd
					  ,qty
					  ,origin_division_id 
					  ,electrode_type
					  ,created_by
					  ,creation_date
					  ,last_updated_by
					  ,last_update_date
					  )
			  SELECT  PS.DIVISION_ID
					 ,sub.plan_start_yyyymmdd
					 ,PS.PLAN_TYPE
					 ,PS.PLAN_SEQ
					 ,sub.operation_group
					 ,MS2.LINK_SCM_SITE_ID AS scm_site_id
					 ,sub.item_id
					 ,MS2.LINK_LINE_ID     AS line_id
					 ,sub.operation_id
					 ,sub.measure
					 ,sub.yyyymmdd
					 ,sub.qty
					 ,PS.DIVISION_ID       AS origin_division_id 
					 ,sub.electrode_type 
					 ,@p_user_id
					 ,GETDATE()
					 ,@p_user_id
					 ,GETDATE()
				FROM ( SELECT x.DIVISION_ID
							 ,x.plan_start_yyyymmdd
							 ,x.PLAN_TYPE
							 ,x.SEQ
							 ,x.operation_group
							 ,x.scm_site_id
							 ,x.item_id
							 ,x.line_id
							 ,x.operation_id
							 ,x.measure
							 ,x.yyyymmdd
							 ,x.qty
							 ,x.origin_division_id 
							 ,x.electrode_type 
					   FROM   SCP_ANL_PRODUCTION_PLAN AS x WITH(NOLOCK)
					   WHERE  1=1
					   AND    division_id         = @p_division_id
					   AND    plan_start_yyyymmdd = @p_plan_start_yyyymmdd
					   AND    plan_type           = @p_plan_type
					   AND    seq                 = @p_seq
					   AND    measure             IN ( 'PROD_PLAN_AMEND', 'PROD_PLAN_ENGINE' )
					  ) AS SUB
					  INNER JOIN ( SELECT LM.OPERATION_ID, LM.ELECTRODE_TYPE, MS.DIVISION_ID, MS.SCM_SITE_ID, LM.LINE_ID
										 ,MS2.DIVISION_ID AS LINK_DIVISION_ID, MS2.SCM_SITE_ID AS LINK_SCM_SITE_ID, LM.LINK_LINE_ID
										 FROM   SCM_MST_SITE MS WITH(NOLOCK)
												INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
													ON MS.ATTRIBUTE9 = MS2.SCM_SITE_ID  -- 실제 생산 Site가 Attribute9에 관리됨
												INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
													ON  LM.PLANT_ID = MS.PLANT_ID
													AND LM.LINK_LINE_ID > ''
										WHERE   MS.DIVISION_ID = @p_division_id
										AND     MS.SITE_TYPE   = 'PLANT'
										AND     MS.VALID_YN    = 'Y'
										) MS2
								ON  SUB.DIVISION_ID  = MS2.DIVISION_ID
								AND SUB.SCM_SITE_ID  = MS2.SCM_SITE_ID
								AND SUB.OPERATION_ID = MS2.OPERATION_ID
								AND SUB.LINE_ID      = MS2.LINE_ID
					 INNER JOIN PLAN_SEQ  PS
						 ON PS.DIVISION_ID = MS2.LINK_DIVISION_ID;

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
								INNER JOIN ( SELECT MS2.DIVISION_ID, MS2.SCM_SITE_ID, LM.LINK_LINE_ID
											 FROM   SCP_ANL_PRODUCTION_PLAN    AS WO WITH(NOLOCK)
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
													INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
														ON  LM.PLANT_ID = MS.PLANT_ID
														AND LM.LINK_LINE_ID > ''
														AND WO.DIVISION_ID  = LM.DIVISION_ID
														AND WO.OPERATION_ID = LM.OPERATION_ID
														AND WO.LINE_ID      = LM.LINE_ID
											WHERE   MS2.DIVISION_ID = @p_division_id
											AND     MS.SITE_TYPE   = 'PLANT'
											AND     MS.VALID_YN    = 'Y'
											AND     MS2.SITE_TYPE  = 'PLANT'
											AND     MS2.VALID_YN   = 'Y'
											AND     WO.MEASURE    IN ( 'PROD_PLAN_AMEND', 'PROD_PLAN_ENGINE' )
											--AND     WO.QTY         > 0 -- 20260127 ymh 긴급수정 아래 insert시 dup
											GROUP   BY MS2.DIVISION_ID, MS2.SCM_SITE_ID, LM.LINK_LINE_ID
											) MS
									ON  SAP.DIVISION_ID = MS.DIVISION_ID
									AND SAP.SCM_SITE_ID = MS.SCM_SITE_ID
									AND SAP.LINE_ID     = MS.LINK_LINE_ID
						WHERE SAP.PLAN_TYPE   = @p_plan_type
						AND   SAP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
						AND   SAP.SEQ         = @p_seq
						AND   SAP.DIVISION_ID = @p_division_id
						AND   SAP.MEASURE    IN ( 'PROD_PLAN_AMEND', 'PROD_PLAN_ENGINE' );

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
							INSERT INTO SCP_ANL_PRODUCTION_PLAN
								(  division_id
								  ,plan_start_yyyymmdd
								  ,plan_type
								  ,seq
								  ,operation_group
								  ,scm_site_id
								  ,item_id
								  ,line_id
								  ,operation_id
								  ,measure
								  ,yyyymmdd
								  ,qty
								  ,origin_division_id 
								  ,electrode_type
								  ,created_by
								  ,creation_date
								  ,last_updated_by
								  ,last_update_date
								  )
						  SELECT  MS2.DIVISION_ID
								 ,sub.plan_start_yyyymmdd
								 ,@p_plan_type
								 ,@p_seq
								 ,sub.operation_group
								 ,MS2.SCM_SITE_ID AS scm_site_id
								 ,sub.item_id
								 ,MS2.LINE_ID     AS line_id
								 ,sub.operation_id
								 ,sub.measure
								 ,sub.yyyymmdd
								 ,sub.qty
								 ,MS2.DIVISION_ID AS origin_division_id 
								 ,sub.electrode_type 
								 ,@p_user_id
								 ,GETDATE()
								 ,@p_user_id
								 ,GETDATE()
						  FROM (
                      
								SELECT x.division_id
									  ,x.plan_start_yyyymmdd
									  ,x.plan_type
									  ,x.seq
									  ,x.operation_group
									  ,x.scm_site_id
									  ,x.item_id
									  ,x.line_id
									  ,x.operation_id
									  ,x.measure
									  ,x.yyyymmdd
									  ,x.qty
									  ,x.origin_division_id 
									  ,x.electrode_type
								  FROM SCP_ANL_PRODUCTION_PLAN AS x WITH(NOLOCK)
									   INNER JOIN PLAN_SEQ  PS --MODELING_ID, PLAN_SEQ, PLAN_TYPE, MASTER_ID, ENGINE_PLAN_ID, DIVISION_ID
										   ON     X.division_id         = PS.DIVISION_ID
										   AND    X.plan_start_yyyymmdd = @p_plan_start_yyyymmdd
										   AND    X.plan_type           = PS.PLAN_TYPE
										   AND    X.seq                 = PS.PLAN_SEQ
								  WHERE 1=1
								  AND   X.measure             IN ( 'PROD_PLAN_AMEND', 'PROD_PLAN_ENGINE' )
								) AS sub
					  INNER JOIN ( SELECT LM.OPERATION_ID, LM.ELECTRODE_TYPE, MS.DIVISION_ID, MS.SCM_SITE_ID, LM.LINE_ID
										 ,MS2.DIVISION_ID AS LINK_DIVISION_ID, MS2.SCM_SITE_ID AS LINK_SCM_SITE_ID, LM.LINK_LINE_ID
										 FROM   SCM_MST_SITE MS WITH(NOLOCK)
												INNER JOIN SCM_MST_SITE MS2 WITH(NOLOCK)
													ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9  -- 실제 생산 Site가 Attribute9에 관리됨
												INNER JOIN SCM_MST_LINE_SN LM WITH(NOLOCK)
													ON  LM.PLANT_ID = MS.PLANT_ID
													AND LM.LINK_LINE_ID > ''
										WHERE   MS.DIVISION_ID = @p_division_id
										AND     MS.SITE_TYPE   = 'PLANT'
										AND     MS.VALID_YN    = 'Y'
										) MS2
								ON  SUB.DIVISION_ID  = MS2.LINK_DIVISION_ID
								AND SUB.SCM_SITE_ID  = MS2.LINK_SCM_SITE_ID
								AND SUB.OPERATION_ID = MS2.OPERATION_ID
								AND SUB.LINE_ID      = MS2.LINK_LINE_ID
								;
					END; -- IF @v_from_division_id > ''
			END; -- IF @v_to_division_id > ''
		-- 2025.11.14   kimcd       [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선 끝

        ----------------------------------------------------------- 
        --7. 만들어진 'REQUIREMENT' MEASURE 빈날짜 채우기
        ----------------------------------------------------------- 
        INSERT INTO SCP_ANL_PRODUCTION_PLAN
        (  division_id
          ,plan_start_yyyymmdd
          ,plan_type
          ,seq
          ,operation_group
          ,scm_site_id
          ,item_id
          ,line_id
          ,operation_id
          ,measure
          ,yyyymmdd
          ,qty
          ,origin_division_id 
          ,electrode_type 

          ,created_by
          ,creation_date
          ,last_updated_by
          ,last_update_date
          )
          SELECT  sub.division_id
                 ,sub.plan_start_yyyymmdd
                 ,sub.plan_type
                 ,sub.seq
                 ,sub.operation_group
                 ,sub.scm_site_id
                 ,sub.item_id
                 ,'*'  AS line_id
                 ,sub.operation_id
                 ,ms.measure
                 ,sub.yyyymmdd
                 ,0 as qty 
                 ,sub.origin_division_id 
                 ,sub.electrode_type 

                 ,@p_user_id
                 ,GETDATE()
                 ,@p_user_id
                 ,GETDATE()
            FROM 
                (
                     SELECT  division_id
                            ,plan_start_yyyymmdd
                            ,plan_type
                            ,seq
                            ,operation_group
                            ,scm_site_id
                            ,item_id
                            ,line_id
                            ,operation_id
                            ,basis_yyyymmdd AS yyyymmdd                            
                            ,origin_division_id 
                            ,electrode_type 

                     FROM
                           (
                            SELECT basis_yyyymmdd
                              FROM SCM_SYS_CALENDAR_M WITH(NOLOCK)
                             WHERE basis_yyyymmdd  >= @p_plan_start_yyyymmdd
                               AND basis_yyyymmdd  <  @v_scp_end_date --SCP 52주 계획
                           ) AS a,
                           (
                            SELECT division_id
                                  ,plan_start_yyyymmdd
                                  ,plan_type
                                  ,seq
                                  ,operation_group
                                  ,scm_site_id
                                  ,item_id
                                  ,'-'                   AS  line_id  --REQUIREMENT는 라인별이 아님.
                                  ,operation_id
                                  ,MAX(origin_division_id ) AS origin_division_id
                                  ,MAX(electrode_type )     AS electrode_type

                              FROM SCP_ANL_PRODUCTION_PLAN AS x WITH(NOLOCK)
                             WHERE 1=1
                               AND division_id         = @p_division_id
                               AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd
                               AND plan_type           = @p_plan_type
                               AND seq                 = @p_seq
                               AND measure             IN ('REQUIREMENT','PROD_PLAN_ENGINE')
                             GROUP BY division_id
                                  ,plan_start_yyyymmdd
                                  ,plan_type
                                  ,seq
                                  ,operation_group
                                  ,scm_site_id
                                  ,item_id
                                  ,operation_id
                            ) AS b
                ) AS sub,
                ( SELECT 'REQUIREMENT' AS measure
                 ) AS ms
                WHERE 1=1
                  AND NOT EXISTS (
                                   SELECT 'X'
                                     FROM SCP_ANL_PRODUCTION_PLAN AS z WITH(NOLOCK)
                                    WHERE 1=1
                                      AND z.division_id           = sub.division_id         
                                      AND z.plan_start_yyyymmdd   = sub.plan_start_yyyymmdd 
                                      AND z.plan_type             = sub.plan_type           
                                      AND z.seq                   = sub.seq                 
                                      AND z.operation_group       = sub.operation_group     
                                      AND z.scm_site_id           = sub.scm_site_id         
                                      AND z.item_id               = sub.item_id             
                                      --AND z.line_id               = sub.line_id             
                                      --AND z.operation_id          = sub.operation_id        
                                      AND z.measure               = ms.measure             
                                      AND z.yyyymmdd              = sub.yyyymmdd  
                                      --AND z.origin_division_id    = sub.origin_division_id            
                                      --AND z.electrode_type        = sub.electrode_type             
                                 );

        
		--- 2028.07.03 7/8월 활성화코드 분리 대응 임시   
		--- Production Plan CP 생산계획 삭제 (생산계획은 CA 기준 생성)
		--- 전구간 0인 데이터만 -- DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD  
		;WITH TARGET_TO_DELETE AS (
			SELECT		    SUM(PP.QTY)							AS TOTAL_QTY 
						   ,COUNT(DISTINCT ISNULL(PP.QTY,0))	AS QTY_CNT 
						   ,PP.DIVISION_ID
						  , PP.PLAN_START_YYYYMMDD
						  , PP.PLAN_TYPE
						  , PP.SEQ
						  , PP.OPERATION_GROUP
						  , PP.SCM_SITE_ID
						  , PP.ITEM_ID
						  , PP.LINE_ID
						  , PP.OPERATION_ID
						  , PP.MEASURE
			  FROM SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK)  
				   INNER JOIN SCM_MST_DIVISION MD WITH(NOLOCK)
						   ON MD.DIVISION_ID = PP.DIVISION_ID
				   INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
						   ON MS.DIVISION_ID = CASE WHEN MD.ATTRIBUTE3 = 'EE' 
													THEN MS.DIVISION_ID
													ELSE PP.DIVISION_ID
												END 
						  AND MS.SCM_SITE_ID = PP.SCM_SITE_ID 
						  AND MS.SITE_TYPE   = 'PLANT'
						  AND MS.OSP_YN		 = 'N' -- OSP외주 제외 
				   INNER JOIN SCP_MST_FINAL_ITEM_V FI WITH(NOLOCK)
						   ON FI.ITEM_ID	 = PP.ITEM_ID
						  AND FI.CELL_TYPE   = 'CP'		-- Cell Type : Cell Product  --- 생산은 CA기준  
			 WHERE 1=1
			   AND PP.DIVISION_ID         = @p_division_id
			   AND PP.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
			   AND PP.PLAN_TYPE           = @p_plan_type
			   AND PP.SEQ                 = @p_seq
			   AND PP.OPERATION_GROUP	  =	'A'			-- CELL 에 대해서만 
			   AND PP.MEASURE LIKE 'PROD_PLAN%'
			GROUP BY 	    PP.DIVISION_ID
						  , PP.PLAN_START_YYYYMMDD
						  , PP.PLAN_TYPE
						  , PP.SEQ
						  , PP.OPERATION_GROUP
						  , PP.SCM_SITE_ID
						  , PP.ITEM_ID
						  , PP.LINE_ID
						  , PP.OPERATION_ID
						  , PP.MEASURE

		)
		DELETE PP
		 FROM SCP_ANL_PRODUCTION_PLAN PP WITH(NOLOCK)
			  INNER JOIN TARGET_TO_DELETE TGT 
					  ON TGT.DIVISION_ID			 = PP.DIVISION_ID
					 AND TGT.PLAN_START_YYYYMMDD	 = PP.PLAN_START_YYYYMMDD
					 AND TGT.PLAN_TYPE				 = PP.PLAN_TYPE
					 AND TGT.SEQ					 = PP.SEQ
					 AND TGT.OPERATION_GROUP		 = PP.OPERATION_GROUP
					 AND TGT.SCM_SITE_ID			 = PP.SCM_SITE_ID
					 AND TGT.ITEM_ID				 = PP.ITEM_ID
					 AND TGT.LINE_ID				 = PP.LINE_ID
					 AND TGT.OPERATION_ID			 = PP.OPERATION_ID
					 AND TGT.MEASURE				 = PP.MEASURE
		WHERE 1=1		
		  AND TGT.TOTAL_QTY = 0 --  전구간 수량 0 
		  AND TGT.QTY_CNT   = 1


        ----------------------------------------------------------- 
        --7. PROD_PLAN_ENGINE_CELL_QTY  추가 (전극,셀)    
        ----------------------------------------------------------- 
        --ALTER TABLE SCP_ANL_PRODUCTION_PLAN
        ----DROP COLUMN  CELL_QTY
        --ADD CELL_QTY    numeric(20, 10) default 0

        -- IF @p_division_id IN ('EE', 'EE_UC')		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가
		-- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
		IF EXISTS (SELECT *
					FROM SCM_MST_DIVISION DM WITH(NOLOCK)
				   WHERE DM.DIVISION_ID = @p_division_id
				     AND DM.ATTRIBUTE3  = 'EE' 
					 AND DM.VALID_YN	= 'Y' )

        BEGIN
/*          
          UPDATE X
            SET X.CELL_QTY    =  ISNULL(X.QTY,0.00) * ISNULL(Y.CONVERT_QTY_CELL,1) 
            FROM SCP_ANL_PRODUCTION_PLAN AS X WITH(NOLOCK)
            INNER JOIN  SCP_MST_FINAL_ITEM Y WITH (NOLOCK)   
            ON 0 = 0
            AND Y.ITEM_ID               = X.ITEM_ID 
            AND X.ORIGIN_DIVISION_ID    = Y.DIVISION_ID
            WHERE 1=1
              AND X.DIVISION_ID         = @p_division_id
              AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
              AND X.PLAN_TYPE           = @p_plan_type
              AND X.SEQ                 = @p_seq
              AND X.MEASURE             = 'PROD_PLAN_ENGINE'
              ;
*/
          -- 82사업부의 전극을 81 OR 40사업부라인에서 생산하는 경우때문에
          -- X.ORIGIN_DIVISION_ID    = Y.DIVISION_ID 조인조건 제거후 MIN값 사용. 2019.02.19 YYDOK
          UPDATE X
            SET X.CELL_QTY    =  ISNULL(X.QTY,0.00)
                                * ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1) 
                                      FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)   
                                     WHERE Y.ITEM_ID    = X.ITEM_ID 
                                       AND Y.CONVERT_QTY_CELL IS NOT NULL )
            FROM SCP_ANL_PRODUCTION_PLAN AS X WITH(NOLOCK)
            WHERE 1=1
              AND X.DIVISION_ID         = @p_division_id
              AND X.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
              AND X.PLAN_TYPE           = @p_plan_type
              AND X.SEQ                 = @p_seq
              AND X.MEASURE             = 'PROD_PLAN_ENGINE'
              ;              
        END

        --PRINT N'프로시저 종료'

        ----------------------------------------------------------- 
        -- 9. 종료 처리
        -----------------------------------------------------------

        --IF @@TRANCOUNT > 0 
        --  BEGIN
        --    COMMIT WORK;
        --  END;
        
        -----------------------------------------------------------
        -- 임시테이블 삭제
        -----------------------------------------------------------  
        IF OBJECT_ID('tempdb..#Tbl_PREV_PLAN_ITEM') IS NOT NULL
          DROP TABLE #Tbl_PREV_PLAN_ITEM
          
        IF OBJECT_ID('tempdb..#Tbl_PLAN_WORK') IS NOT NULL
          DROP TABLE #Tbl_PLAN_WORK
        
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

    --     임시 운영반영시에 주석처리 할것.                
     SET @v_exec_time  =  REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME())/ 60))) + ':' +                 
                          REPLICATE('0',2 - LEN((convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60)) )) + (convert(varchar, (DATEDIFF(second,       @v_start_time, SYSDATETIME()))% 60))                 


    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = N'########## END of procedure ##########';
    SET @v_description = N'['+@p_master_id+']['+@p_engine_plan_id+'][' + @v_exec_time + ']';         
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

