
/*
 * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_I  
 * Description  :
 * OutTable     :
 * Execute      : EXEC PR_SCP_ANL_PRODUCTION_PLAN_I N'81',N'20180108',N'MA',N'2',N'LTW'
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018.02.01   LTW         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.23   LTW         EOH(ONHAND_EOH) 계산 로직 추가
 * 2018.05.23   LTW         EOH(ONHAND_EOH) MEASURE LINE_ID ,OPERATION_ID 컬럼값 '*'값으로 수정
 * 2018.06.15   LTW         트랙잭션 제거
 * 2018.06.22   LTW         SCP 52주 제한 로직 추가
 * 2018.07.03   LTW         전극 SCP 작업(ORIGIN_DIVISION_ID ,ELECTRODE_TYPE) 추가
 * 2018.08.21   LTW         ELECTRODE_TYPE 이 NULL 값이 나올경우 처리 로직 추가
 * 2021.03.15   KSG         PJ20209642 Digital SCM Level.3 달성을 위한 개선 : FP Yield Table 변경
 * 2021-05-10   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 플랜 대응
 * 2022.03.23	KSW			GM JV 반영 :: EE_UC  추가
 * 2023.03.28	HRK			PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 *
 */
 
CREATE PROCEDURE [dbo].[PR_SCP_ANL_PRODUCTION_PLAN_I]
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
    DECLARE @v_program_name NVARCHAR(150) = N'PR_SCP_ANL_PRODUCTION_PLAN_I';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500); 
    DECLARE @v_table_id     NVARCHAR(150) = N'SCP_ANL_PRODUCTION_PLAN'; 
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
      
    BEGIN TRY
      BEGIN

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
        -- 1. SCP_ANL_PRODUCTION_PLAN 작업 MEASURE 부분 삭제
        -- 1.1. 현재 작업하는 division_id ,plan_start_yyyymmdd ,plan_type ,measure ,seq 에 해당하는데이터 삭제
        ----------------------------------------------------------- 
        DELETE SCP_ANL_PRODUCTION_PLAN 
        WHERE division_id = @p_division_id 
          AND plan_start_yyyymmdd = @p_plan_start_yyyymmdd 
          AND plan_type = @p_plan_type 
          AND seq = @p_seq 
          AND measure IN (N'FORMATION_YIELD',N'ONHAND_EOH')
          ;
        
        ----------------------------------------------------------- 
        -- 2. 임시테이블 생성
        ----------------------------------------------------------- 
        -- 52주 CALENDAR(WEEKLY) 임시테이블 생성
        IF OBJECT_ID('tempdb..#Tbl_CALENDAR') IS NOT NULL
            DROP TABLE #Tbl_CALENDAR
            ;
        SELECT 
             ROW_NUMBER() OVER(ORDER BY basis_yyyymmdd) AS row_num 
            ,basis_yyyymmdd 
         INTO #Tbl_CALENDAR
         FROM SCM_SYS_CALENDAR_M AS a WITH(NOLOCK) 
        WHERE 1=1
          AND a.basis_start_date >= CONVERT(CHAR(8),@p_plan_start_yyyymmdd ,112)
          AND a.basis_start_date < @v_scp_end_date --SCP 52주 계획
          ;


        --작업 ITEM 임시테이블 생성
        IF OBJECT_ID('tempdb..#Tbl_PLAN_ITEM') IS NOT NULL
            DROP TABLE #Tbl_PLAN_ITEM
            ;
        --작업용 임시테이블 생성
        IF OBJECT_ID('tempdb..#Tbl_PLAN_WORK') IS NOT NULL
            DROP TABLE #Tbl_PLAN_WORK
            ;
        CREATE TABLE #Tbl_PLAN_WORK (
           plan_type	          NVARCHAR(50)	
          ,plan_start_yyyymmdd	NVARCHAR(8)	
          ,seq	                BIGINT	
          ,division_id	        NVARCHAR(30)	
          ,operation_group	    NVARCHAR(10)	
          ,scm_site_id	        NVARCHAR(30)	
          ,item_id	            NVARCHAR(50)	
          ,line_id	            NVARCHAR(50)	
          ,operation_id	        NVARCHAR(30)	
          ,yyyymmdd	            NVARCHAR(8)	
          ,qty	                NUMERIC(20,10)	 
          ,measure	            NVARCHAR(50)	          
          ,origin_division_id   NVARCHAR(30)
          ,electrode_type       NVARCHAR(30)

          ,created_by           NVARCHAR(150)
          ,last_updated_by      NVARCHAR(150)
        );

        ----------------------------------------------------------- 
        -- 3. 작업 ITEM 뽑기(MEASURE : FORMATION_YIELD)
        ----------------------------------------------------------- 
        SELECT 
               a.division_id 
              ,a.operation_group 
              ,a.scm_site_id 
              ,a.item_id
              ,a.origin_division_id
              ,a.electrode_type

        INTO #Tbl_PLAN_ITEM
        FROM (
              SELECT 
                    pp.division_id 
                   ,pp.operation_group 
                   ,pp.scm_site_id 
                   ,pp.item_id
                   ,pp.origin_division_id
                   ,pp.electrode_type
               FROM SCP_ANL_PRODUCTION_PLAN AS pp WITH(NOLOCK)
              WHERE 1=1
                AND pp.division_id         = @p_division_id          --N'EE'         --
                AND pp.plan_start_yyyymmdd = @p_plan_start_yyyymmdd  --N'20180702'   --
                AND pp.plan_type           = @p_plan_type            --N'PR'         --
                AND pp.seq                 = @p_seq                  --N'11'         --
                AND pp.measure             IN (N'REQUIREMENT',N'PROD_PLAN_ENGINE')
                AND pp.operation_group     = N'A'
              GROUP BY 
                    pp.division_id 
                   ,pp.operation_group 
                   ,pp.scm_site_id 
                   ,pp.item_id
                   ,pp.origin_division_id
                   ,pp.electrode_type
            ) AS a
        ;
        
        ----------------------------------------------------------- 
        -- 4. 실제 인서트(MEASURE : FORMATION_YIELD)
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
              )
        SELECT 
               @p_plan_type           AS plan_type          
              ,@p_plan_start_yyyymmdd AS plan_start_yyyymmdd
              ,@p_seq                 AS seq                
              ,a.division_id 
              ,a.operation_group 
              ,a.scm_site_id 
              ,a.item_id 
              ,N'*'                   AS line_id 
              ,N'*'                   AS operation_id
              ,N'FORMATION_YIELD'     AS measure 
              ,a.yyyymmdd             AS yyyymmdd 
              ,ISNULL(y.yield, 1)     AS qty
              ,a.origin_division_id 
              ,a.electrode_type 

              ,@p_user_id             AS created_by 
              ,@p_user_id             AS last_updated_by
        FROM (
                SELECT 
                     item.division_id 
                    ,item.operation_group 
                    ,item.scm_site_id 
                    ,item.item_id 
                    ,cal.basis_yyyymmdd                AS yyyymmdd 
					,SUBSTRING(cal.basis_yyyymmdd,1,6) AS month
                    ,item.origin_division_id 
                    ,item.electrode_type 

                FROM #Tbl_PLAN_ITEM           AS item WITH(NOLOCK) 
                     CROSS JOIN #Tbl_CALENDAR AS cal WITH(NOLOCK) 
               ) a

        LEFT OUTER JOIN (
                           SELECT division_id, plant_site_id, item_id, MONTH
                                , AVG (ISNULL((CASE WHEN yield <= 0 THEN 1  
                                                    WHEN yield > 1  THEN 1  
                                                    ELSE yield  
                                               END),1))    AS yield
                           FROM dbo.scm_mst_yield_ver_h_v t WITH (NOLOCK)    -- PJ20209642 변경 scm_mst_yield_sn
                           WHERE 1=1  
                           AND division_id      = @p_division_id
                           AND operation_id     = N'F6000'  
                           AND MONTH           >= SUBSTRING(@p_plan_start_yyyymmdd,1,6)  
                           GROUP BY division_id, plant_site_id, item_id, MONTH
		                  ) y
        ON  a.division_id = y.division_id
        AND a.scm_site_id = y.plant_site_id
        AND a.item_id     = y.item_id
        AND a.MONTH       = y.MONTH
        ;
        
        ----------------------------------------------------------- 
        -- 5. 생산계획(ONHAND_EOH) : 데이터 적재
        ----------------------------------------------------------- 
        INSERT INTO  SCP_ANL_PRODUCTION_PLAN
            ( division_id
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

             ,created_by
             ,creation_date
             ,last_updated_by
             ,last_update_date
             ) 
        SELECT division_id
              ,plan_start_yyyymmdd
              ,plan_type
              ,seq
              ,operation_group
              ,scm_site_id
              ,item_id
              ,'*' AS line_id
              ,'*' AS operation_id
              ,'ONHAND_EOH' AS measure
              ,yyyymmdd
              --,((dbo.fn_get_scp_anl_boh_qty(x.division_id,x.plan_start_yyyymmdd,x.plan_type,x.seq,x.scm_site_id,x.item_id,plan_start_yyyymmdd)) + p_sum) - s_sum AS qty
              ,p_sum - s_sum AS qty

              ,@p_user_id
              ,GETDATE()
              ,@p_user_id
              ,GETDATE()
          FROM (
                SELECT DISTINCT division_id
                      ,plan_start_yyyymmdd
                      ,plan_type
                      ,seq
                      ,operation_group
                      ,scm_site_id
                      ,item_id
                      ,yyyymmdd
                      ,SUM((CASE WHEN measure = 'REQUIREMENT'     THEN ISNULL(qty,0) ELSE 0 END)) OVER(PARTITION BY scm_site_id,item_id ORDER BY scm_site_id,item_id,yyyymmdd) AS s_sum 
                      ,SUM((CASE WHEN measure = 'PROD_PLAN_AMEND' THEN ISNULL(qty,0) ELSE 0 END)) OVER(PARTITION BY scm_site_id,item_id ORDER BY scm_site_id,item_id,yyyymmdd) AS p_sum
                  FROM SCP_ANL_PRODUCTION_PLAN AS a WITH(NOLOCK) 
                 WHERE 1=1
                   AND plan_start_yyyymmdd       = @p_plan_start_yyyymmdd   --'20180702'        --
                   AND plan_type                 = @p_plan_type             --'PR'              --
                   AND seq                       = @p_seq                   --'11'              --
                   AND division_id               = @p_division_id           --'EE'              --
                   AND measure                   IN ('PROD_PLAN_AMEND','REQUIREMENT') 
               ) AS x
         ORDER BY x.operation_group
                 ,x.scm_site_id
                 ,x.item_id
                 ,x.yyyymmdd
                 ; 
        
        ----------------------------------------------------------- 
        -- 6. 생산계획 origin_division_id ,electrode_type 업데이트
        ----------------------------------------------------------- 
        UPDATE x
           SET x.origin_division_id = ISNULL(ts.division_id,'')
          FROM SCP_ANL_PRODUCTION_PLAN      AS  x WITH (NOLOCK)
			   -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
			   INNER JOIN SCM_MST_DIVISION AS DM WITH(NOLOCK)
					   ON DM.DIVISION_ID = X.DIVISION_ID
					  AND DM.VALID_YN	 = 'Y'
               LEFT OUTER JOIN SCM_MST_SITE AS ts WITH (NOLOCK) 
                 ON 1=1    
				AND TS.DIVISION_ID = CASE WHEN DM.ATTRIBUTE3 = 'EE' -- PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
										  THEN TS.DIVISION_ID
										  ELSE X.DIVISION_ID
									  END 
                -- 2023.03.28 AND (CASE WHEN x.division_id IN ('EE', 'EE_UC') THEN '0' ELSE x.division_id END ) = (CASE WHEN x.division_id IN ('EE', 'EE_UC') THEN '0' ELSE ts.division_id END )		-- 2022.03.23	KSW	GM JV 반영 :: EE_UC  추가, 0 --> '0'
                AND ts.valid_yn = N'Y'   
                AND ts.scm_site_id = REPLACE(x.scm_site_id ,'-S' ,'') 
        WHERE 1=1
          AND x.plan_start_yyyymmdd  = @p_plan_start_yyyymmdd   --'20180702'        --
          AND x.plan_type            = @p_plan_type             --'PR'              --
          AND x.seq                  = @p_seq                   --'11'              --
          AND x.division_id          = @p_division_id           --'EE'              --
          ;

        UPDATE x
           SET x.electrode_type = ISNULL(fi.electrode_type,'')
          FROM SCP_ANL_PRODUCTION_PLAN              AS  x WITH (NOLOCK)
               LEFT OUTER JOIN SCP_MST_FINAL_ITEM_V AS fi WITH (NOLOCK) 
                 ON 1=1
                AND x.item_id = fi.item_id
         WHERE 1=1
           AND x.plan_start_yyyymmdd   = @p_plan_start_yyyymmdd   --'20180702'        --
           AND x.plan_type             = @p_plan_type             --'PR'              --
           AND x.seq                   = @p_seq                   --'11'              --
           AND x.division_id           = @p_division_id           --'EE'              --
           AND x.item_id               = fi.item_id    
           ;

        --PRINT N'프로시저 종료';
        
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
        IF OBJECT_ID('tempdb..#Tbl_CALENDAR') IS NOT NULL
            DROP TABLE #Tbl_CALENDAR
        
        IF OBJECT_ID('tempdb..#Tbl_PLAN_ITEM') IS NOT NULL
            DROP TABLE #Tbl_PLAN_ITEM
            
        IF OBJECT_ID('tempdb..#Tbl_PLAN_WORK') IS NOT NULL
            DROP TABLE #Tbl_PLAN_WORK
        
        -----------------------------------------------------------
        -- 실행 Logic END --
        -----------------------------------------------------------

        -- TXN LOG
        SET @v_log_type = N'TXN'; 
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

