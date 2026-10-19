
/*
 * Program ID   : PR_SCP_ANL_PROBLEM_REPORT_DEMAND  
 * Description  : PROBLEM_REPORT_DEMAND
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PROBLEM_REPORT_DEMAND N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.27   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.15   LTW         트랙잭션 제거
 * 2018.06.22   LTW         SCP 52주 제한 로직 추가
 * 2018.07.02   LTW         전극 SCP 작업(ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID ,ELECTRODE_TYPE) 추가
 * 2018.08.14   LTW         DEMAND_ID 의 PLANT_SITE_ID 가 NOPLANT 일경우 작업 사업부(DIVISION_ID)로 ORIGIN_FROM_DIVISION_ID 값 설정
 * 2018.08.21   LTW         ELECTRODE_TYPE 이 NULL 값이 나올경우 처리 로직 추가
 * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.22   KSW         JV GM 반영
 * 2023.03.29	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 *
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PROBLEM_REPORT_DEMAND]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PROBLEM_REPORT_DEMAND';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);      --상세설명 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PROBLEM_REPORT_DEMAND'; --테이블 필수
    DECLARE @d_event_date   DATETIME;

  -- 시작 LOG
    SET @v_log_type = N'START';
    SET @v_log_message = N'########## Start of procedure ##########';
    SET @v_description = @v_program_name + ':' + N' SCP_ANL_PROBLEM_REPORT_DEMAND INSERT LOGIC';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  = @v_program_name
                              ,@p_log_type      = @v_log_type
                              ,@p_log_count     = @n_log_count 
                              ,@p_log_message   = @v_log_message 
                              ,@p_description   = @v_description 
                              ,@p_event_date    = @d_event_date 
                              ,@p_user_id       = @v_batch_user
                              ;   
    -- 임시 실행시간 확인용            
    DECLARE @v_start_time   DATETIME     = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';
      
    BEGIN TRY
      BEGIN
    
        /*
        Program ID   : PR_SCP_ANL_PROBLEM_REPORT_DEMAND
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
        -- 1. SCP_ANL_PROBLEM_REPORT_DEMAND 삭제
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type 과 같은 데이터가 있으면 삭제한다.
        ----------------------------------------------------------- 
          
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type 과 같은 데이터가 있으면 삭제한다.
        DELETE SCP_ANL_PROBLEM_REPORT_DEMAND 
        WHERE 1=1
          AND division_id           = @p_division_id 
          AND plan_start_yyyymmdd   = @p_plan_start_yyyymmdd 
          AND plan_type             = @p_plan_type 
          AND seq                   = @p_seq 
          ;

        --작업용 임시테이블 생성        
        IF OBJECT_ID(N'tempdb..#tbl_SCP_ANL_PROBLEM_REPORT_DEMAND') is not null
          DROP TABLE #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND
          ;
        CREATE TABLE #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND (
           division_id              nvarchar(30)
          ,plan_start_yyyymmdd      nvarchar(8) 
          ,plan_type                nvarchar(8) 
          ,seq                      bigint 
          ,eng_demand_id            nvarchar(1000) 

          ,plant_site_id            nvarchar(30)
          ,sales_site_id            nvarchar(30)
          ,project_code             nvarchar(50)
          ,model_id                 nvarchar(50)
          ,dom_exp                  nvarchar(3)
          ,fcst_type                nvarchar(20)
          ,yyyymmdd                 nvarchar(8)
          ,qty                      numeric(20,10)
          ,problem_type             nvarchar(10)
          
          ,origin_from_division_id  nvarchar(30) --전극 작업 추가
          ,origin_to_division_id    nvarchar(30) --전극 작업 추가
          ,electrode_type           nvarchar(30) --전극 작업 추가

        );


        ----------------------------------------------------------- 
        -- 2. 엔진 INPUT 기준으로 FCST 정보 생성
        ----------------------------------------------------------- 
        INSERT INTO #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND
        ( 
          division_id
          ,plan_start_yyyymmdd
          ,plan_type
          ,seq
          ,eng_demand_id 
          ,plant_site_id
          ,sales_site_id
          ,project_code
          ,model_id
          ,dom_exp
          ,fcst_type
          ,yyyymmdd
          ,qty
                               
        )
        SELECT a.division_id
              ,a.plan_start_yyyymmdd
              ,a.plan_type
              ,a.seq
              ,a.item_id+N'::'+ project_code+N'::'+sales_site_id+N'::'+ dom_exp+N'::'+ fcst_type+N'::'+yyyymmdd+N'::'+plant_site_id AS eng_demand_id
              ,a.plant_site_id
              ,a.sales_site_id
              ,a.project_code
              ,a.item_id                     
              ,a.dom_exp
              ,a.fcst_type
              ,a.yyyymmdd
              ,SUM(a.split_qty) AS qty
                   
          FROM SCP_PLN_NET_DEMAND_V AS a WITH(NOLOCK)
         WHERE 1=1
           AND a.master_id           = @p_master_id            --N'EE::WEEKLY'           --
           AND a.eng_plan_id         = @p_engine_plan_id       --N'1033::PR::11'         --
           AND a.out_version_id      = @p_engine_plan_id       --N'1033::PR::11'         --
           AND a.plan_id             = @p_plan_id              --N'1033'                 --
           AND a.seq                 = @p_seq                  --N'11'                   --
           AND a.plan_start_yyyymmdd = @p_plan_start_yyyymmdd  --N'20180702'             --
           AND a.plan_type           = @p_plan_type            --N'PR'                   --
           AND a.division_id         = @p_division_id          --N'EE'                   --
           AND a.yyyymmdd            < @v_scp_end_date         --SCP 52주 계획
         GROUP BY
               a.division_id
              ,a.plan_start_yyyymmdd
              ,a.plan_type
              ,a.seq
              ,a.plant_site_id
              ,a.sales_site_id
              ,a.project_code
              ,a.item_id
              ,a.dom_exp
              ,a.fcst_type
              ,a.yyyymmdd
              ; 
        
        
        ----------------------------------------------------------- 
        -- 3. (ORIGIN_FROM_DIVISION_ID ,ORIGIN_TO_DIVISION_ID ,ELECTRODE_TYPE) 추가
        ----------------------------------------------------------- 
        UPDATE x
           SET x.origin_from_division_id =  (CASE WHEN DM.ATTRIBUTE3 != 'EE' AND ISNULL(fs.division_id,'') = '' THEN X.DIVISION_ID ELSE ISNULL(fs.division_id,'') END)		-- 2023.03.29 HM JV 가상 사업부 추가 대응
										  -- (CASE WHEN x.division_id NOT IN ('EE', 'EE_UC') AND ISNULL(fs.division_id,'') = '' THEN X.DIVISION_ID ELSE ISNULL(fs.division_id,'') END)		-- 2022.03.22 KSW JV GM 반영 EE_UC 추가 <-- x.division_id <> 'EE'
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND   AS  x WITH (NOLOCK)
			   -- 2023.03.29 HM JV 가상 사업부 추가 대응
			   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					   ON DM.DIVISION_ID = X.DIVISION_ID 
					  AND DM.VALID_YN	 = 'Y'
               LEFT OUTER JOIN SCM_MST_SITE         AS fs WITH (NOLOCK) 
                 ON 1=1 
                -- 2023.03.29 AND (CASE WHEN x.division_id IN ('EE', 'EE_UC') THEN '0' ELSE x.division_id END ) = (CASE WHEN x.division_id IN ('EE', 'EE_UC') THEN '0' ELSE fs.division_id END )	-- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
                AND fs.division_id  = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응
										   THEN fs.division_id 
										   else x.division_id
									  END 
                AND fs.valid_yn = N'Y'   
                AND fs.scm_site_id = REPLACE(x.plant_site_id ,'-S' ,'') 
         WHERE 1=1
          AND x.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd   --'20180702'        --
          AND x.plan_type            = @p_plan_type             --'PR'              --
          AND x.seq                  = @p_seq                   --'11'              --
          AND x.division_id          = @p_division_id           --'EE'              --
          ;

        UPDATE x
           SET x.origin_to_division_id = ISNULL(ts.division_id,'')
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND   AS  x WITH (NOLOCK)
			   -- 2023.03.29 HM JV 가상 사업부 추가 대응
			   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK)
					   ON DM.DIVISION_ID = X.DIVISION_ID 
					  AND DM.VALID_YN	 = 'Y'
               --LEFT OUTER JOIN SCM_MST_SITE         AS ts WITH (NOLOCK) 
                   LEFT OUTER JOIN (SELECT MIN(DIVISION_ID) DIVISION_ID, SCM_SITE_ID, VALID_YN
				                    FROM   DBO.SCM_MST_SITE  WITH (NOLOCK)       -- to   SITE_ID
									WHERE  valid_yn = 'Y'
									GROUP BY SCM_SITE_ID, VALID_YN
								   ) ts
                 ON 1=1   
                -- 2023.03.29 AND (CASE WHEN x.division_id IN ('EE', 'EE_UC') THEN '0' ELSE x.division_id END ) = (CASE WHEN x.division_id IN ('EE', 'EE_UC') THEN '0' ELSE ts.division_id END )		-- 2022.03.22 KSW JV GM 반영 EE_UC 추가 - 0 --> '0' 변경
                AND ts.division_id = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- 2023.03.29 HM JV 가상 사업부 추가 대응 
										  THEN ts.division_id
										  ELSE x.division_id
									  END
                AND ts.valid_yn = N'Y'   
                AND ts.scm_site_id = REPLACE(x.sales_site_id ,'-S' ,'') 
         WHERE 1=1
          AND x.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd   --'20180702'        --
          AND x.plan_type            = @p_plan_type             --'PR'              --
          AND x.seq                  = @p_seq                   --'11'              --
          AND x.division_id          = @p_division_id           --'EE'              --
          ;

        UPDATE x
           SET x.electrode_type = ISNULL(fi.electrode_type,'')
          FROM #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND   AS  x WITH (NOLOCK)
               LEFT OUTER JOIN SCP_MST_FINAL_ITEM_V AS fi WITH (NOLOCK) 
                 ON 1=1
                AND x.model_id    = fi.item_id
          WHERE 1=1
           AND x.plan_start_yyyymmdd   = @p_plan_start_yyyymmdd   --'20180702'        --
           AND x.plan_type             = @p_plan_type             --'PR'              --
           AND x.seq                   = @p_seq                   --'11'              --
           AND x.division_id           = @p_division_id           --'EE'              --
           AND x.model_id              = fi.item_id    
           ;



        ----------------------------------------------------------- 
        -- 4. 실제 인서트 작업
        ----------------------------------------------------------- 
        INSERT INTO SCP_ANL_PROBLEM_REPORT_DEMAND
              ( 
                division_id
               ,plan_start_yyyymmdd
               ,plan_type
               ,seq
               ,eng_demand_id 
               ,plant_site_id
               ,sales_site_id
               ,project_code
               ,model_id
               ,dom_exp
               ,fcst_type
               ,yyyymmdd
               ,qty
               ,problem_type
               ,origin_from_division_id 
               ,origin_to_division_id 
               ,electrode_type 
               
               ,created_by
               ,creation_date
               ,last_updated_by
               ,last_update_date                     
              )
             SELECT division_id
                   ,plan_start_yyyymmdd
                   ,plan_type
                   ,seq
                   ,eng_demand_id
                   ,plant_site_id
                   ,sales_site_id
                   ,project_code
                   ,model_id                     
                   ,dom_exp
                   ,fcst_type
                   ,yyyymmdd
                   ,qty
                   ,NULL                      AS problem_type
                   ,origin_from_division_id 
                   ,origin_to_division_id 
                   ,electrode_type 
                   
                   ,@p_user_id                AS created_by
                   ,GETDATE()                 AS creation_date
                   ,@p_user_id                AS last_updated_by
                   ,GETDATE()                 AS last_update_date

               FROM #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND AS x WITH(NOLOCK)
               ;

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
        IF OBJECT_ID(N'tempdb..#tbl_SCP_ANL_PROBLEM_REPORT_DEMAND') is not null
          DROP TABLE #tbl_SCP_ANL_PROBLEM_REPORT_DEMAND
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN';    --로그타입
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
    SET @v_description = N'[' + @p_master_id + ']['+@p_engine_plan_id+'][' + @v_exec_time + ']';    
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

