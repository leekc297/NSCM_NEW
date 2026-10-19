

/*
 * Program ID   : PR_SCP_MST_WORKING_TIME_COPY_FROM_FP
 * Description  : Working time 생성 프로시져. 
				: 금일 기준 + 380일치 working time 을 생성한다.
				: 기존에 데이터가 있으면 Update함
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.01.25   KSG            Initial Release PJ20209642 LGES 전지GSCM 상반기 프로젝트
 * 2021.05.28   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2021.07.27   sclee.lee      PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화
 * 2022.03.25   sclee.lee      PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.06.27   sclee.lee      PJ20216994 LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - isuzu관련 조회구문 변경
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_WORKING_TIME_COPY_FROM_FP]
( @p_division_id         NVARCHAR(30) = NULL
) 
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;
    SET ANSI_WARNINGS ON;
    SET ANSI_NULLS ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_WORKING_TIME_COPY_FROM_FP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @v_instanceid   NVARCHAR(40); 
	DECLARE @n_mq_seq	    BIGINT;
	DECLARE @n_dayofweek    INT = 1;
	DECLARE @n_period       INT = 380; -- Work Time 생성 구간

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN  
	  	  
		-- 20210528 PJ20209642 : Working Time 생성 구간
		SELECT @n_period = DATEDIFF(D,  CONVERT(DATE, plan_name), CONVERT(DATE, horizon_end_date) ) + 1
		FROM   dbo.scm_mst_plan p WITH(NOLOCK)
		WHERE  p.division_id = ISNULL(@p_division_id, '81')
        AND    p.plan_cycle  = 'WEEKLY'
		AND    p.plan_name   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112) -- 당주 월요일 YYYYMMDD
	  
		-------------------------------------------
	    -- 1. Division별 MAX(version_id)
		-------------------------------------------
        IF OBJECT_ID('tempdb..#master_version') IS NOT NULL
        BEGIN 
            DROP TABLE #master_version          
        END 

        SELECT division_id, MAX(version_id) AS version_id
        INTO   #master_version
        FROM   scm_master_version_info_h_sn WITH(NOLOCK)
        WHERE  division_id  = ISNULL(@p_division_id, division_id)
        AND    scp_use_flag = 'Y'
        GROUP BY division_id;

        -------------------------------------------
        -- 2. Working Time 생성 : 전극 외
        -------------------------------------------
		-- PJ20216891
        -- IF ISNULL(@p_division_id, 'ALL') <> 'EE'
        -- 2023.03.30 HM JV IF ISNULL(@p_division_id, 'ALL') NOT LIKE N'EE%'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF @p_division_id IS NULL
		   OR
		   EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3 != 'EE'
					 AND VALID_YN	 = 'Y') 
        BEGIN
        
          MERGE INTO scp_mst_working_time a
          USING (SELECT a.division_id
					  , a.scm_site_id
					  , a.factory_id
					  , a.operation_id
					  , a.line_id
					  , c.basis_yyyymmdd
					   , CASE WHEN (1440 - ISNULL(o.off_time, 0)) <= 0 THEN 0
                              ELSE (1440 - ISNULL(o.off_time, 0)) 
                         END AS working_time
                      --PJ20214907 자동차사업부(81)인 경우 형교환 정보(o1.time_term)를 가져와서 working_time 에서 차감함
					  --, CASE WHEN a.division_id = '81' AND ((1440 - ISNULL(o.off_time, 0)) - ISNULL(o1.time_term, 0)) <= 0 THEN 0
       --                      WHEN a.division_id = '81' THEN ((1440 - ISNULL(o.off_time, 0)) - ISNULL(o1.time_term, 0))
       --                      WHEN (1440 - ISNULL(o.off_time, 0)) <= 0 THEN 0
       --                      ELSE (1440 - ISNULL(o.off_time, 0))
       --                 END AS working_time
				 FROM  (-- 전지본부 Plant
				        SELECT  DISTINCT 
								a.division_id
							  , ISNULL(dbo.FN_GET_SCM_SITE_ID_PLANT(a.plant_id,b.shop_group_id),'-') scm_site_id
							  , b.factory_id
							  , a.operation_id
							  , a.line_id
						FROM   scm_mst_line_sn a WITH(NOLOCK)

						INNER JOIN scm_mst_factory_sn b WITH(NOLOCK)
						ON     a.company_id  = b.company_id
						AND    a.division_id = b.division_id
						AND    a.site_id	 = b.site_id
						AND    a.plant_id	 = b.plant_id
						AND    a.factory_id  = b.factory_id
						AND    a.division_id = ISNULL(@p_division_id, a.division_id)
						AND    b.shop_group_id IS NOT NULL
						AND    a.operation_id IN (SELECT DISTINCT b.segment4
												  FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
												  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
												  AND    b.valid_yn = 'Y'
												  AND    b.segment3 = 'Y'
												  AND    SUBSTRING(b.segment4, 1, 1) <> 'E'  -- 전극 외 Operation

                                                  -- PJ20216994	
                                                  -- ISUZU item
                                                  UNION ALL
                                                  
                                                  SELECT 'P5000' segment4 ) 
					   ) a

				        LEFT OUTER JOIN scm_sys_calendar_m c WITH(NOLOCK)
				        ON     c.basis_yyyymmdd >= CONVERT(CHAR(8), GETDATE(), 112)
				        AND    c.basis_yyyymmdd <  CONVERT(CHAR(8), GETDATE() + @n_period, 112)

                        LEFT OUTER JOIN (
                                 SELECT w.division_id, w.factory_id, w.operation_id, w.line_id
                                      , CONVERT(CHAR(8), w.work_date, 112) AS yyyymmdd
	                                  , SUM(w.time_term)                   AS off_time
                                 FROM   scm_work_cal_ver_h_sn w WITH(NOLOCK)

                                 INNER JOIN #master_version   v
                                 ON     w.division_id = v.division_id  -- v 에 전극은 'EE' 로 되어 있으므로 자연스럽게 제외됨
                                 AND    w.version_id  = v.version_id
								 
                                 WHERE  1=1
                                 GROUP BY w.division_id, w.factory_id, w.operation_id, w.line_id, CONVERT(CHAR(8), w.work_date, 112)
                                ) o
				        ON     a.division_id    = o.division_id
				        AND    a.factory_id     = o.factory_id
				        AND    a.operation_id   = o.operation_id
				        AND    a.line_id        = o.line_id
				        AND    c.basis_yyyymmdd = o.yyyymmdd
						
            --            --PJ20214907 자동차사업부(81)인 경우 형교환 정보(o1.time_term)가 필요하므로 SCM_WORK_CALENDAR_M_sn 테이블을 추가로 조인
            --            LEFT OUTER JOIN (
            --                     SELECT w.division_id, w.factory_id, w.operation_id, w.line_id
            --                          , CONVERT(CHAR(8), w.work_date, 112) AS yyyymmdd
	           --                       , SUM(w.time_term)                   AS time_term
            --                     FROM   SCM_WORK_CALENDAR_M_sn w WITH(NOLOCK)								 
            --                     WHERE  1=1
            --                     AND    w.loss_code = 'XC031'
            --                     GROUP BY w.division_id, w.factory_id, w.operation_id, w.line_id, CONVERT(CHAR(8), w.work_date, 112)
            --                    ) o1
				        --ON     a.division_id    = o1.division_id
				        --AND    a.factory_id     = o1.factory_id
				        --AND    a.operation_id   = o1.operation_id
				        --AND    a.line_id        = o1.line_id
				        --AND    c.basis_yyyymmdd = o1.yyyymmdd

				 WHERE  1=1
				 AND    c.basis_yyyymmdd IS NOT NULL
			    ) B

		   ON (       
				    A.division_id	= B.division_id
				AND A.plant_site_id	= B.scm_site_id
				AND A.factory_id	= B.factory_id
				AND A.operation_id	= B.operation_id
				AND A.line_id		= B.line_id
				AND A.yyyymmdd		= B.basis_yyyymmdd
		      )
		  WHEN MATCHED THEN
		  UPDATE SET 
					 A.working_time					=  B.working_time
					,A.last_updated_by				=  @v_batch_user
					,A.last_update_date				=  GETDATE()
					                
		  WHEN NOT MATCHED THEN
		  INSERT (
		          division_id
			     ,plant_site_id
			     ,factory_id
			     ,operation_id
			     ,line_id
			     ,yyyymmdd
			     ,working_time
				 ,created_by
				 ,creation_date
				 ,last_updated_by
				 ,last_update_date
				 )
		  VALUES (
		          B.division_id
			 	 ,B.scm_site_id
				 ,B.factory_id
				 ,B.operation_id
				 ,B.line_id
				 ,B.basis_yyyymmdd
				 ,B.working_time
			     ,@v_batch_user
			     ,GETDATE()
			     ,@v_batch_user
			     ,GETDATE() 
			     )
		  ;

          -- TXN LOG
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = N'TXN';    
          SET @v_log_message = N'INSERT INTO 전극 외 : ' + ISNULL(@p_division_id, 'ALL')
          SET @v_description = N'Process Complete...' 
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END; -- IF ISNULL(@p_division_id, 'A') <> 'EE'

        -------------------------------------------
        -- 3. Working Time 생성 : 전극
        -------------------------------------------
		-- PJ20216891
        -- IF ISNULL(@p_division_id, 'EE') = 'EE'
		-- 2023.03.30 HM JV IF ISNULL(@p_division_id, 'EE') LIKE 'EE%'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF @p_division_id IS NULL
		   OR
		   EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3  = 'EE'
					 AND VALID_YN	 = 'Y') 
        BEGIN

	      MERGE INTO scp_mst_working_time a
		  USING (SELECT a.division_id
	  				   ,a.scm_site_id
					   ,a.factory_id
					   ,a.operation_id
					   ,a.line_id
					   ,c.basis_yyyymmdd
					  , CASE WHEN (1440 - ISNULL(o.off_time, 0)) <= 0 THEN 0
                             ELSE (1440 - ISNULL(o.off_time, 0)) 
                        END AS working_time
				 FROM  (-- 전지본부 Plant
				        SELECT  DISTINCT 
								a.division_id
							   ,ISNULL(dbo.FN_GET_SCM_SITE_ID_PLANT(a.plant_id,b.shop_group_id),'-') scm_site_id
							   ,b.factory_id
							   ,a.operation_id
							   ,a.line_id
						FROM   scm_mst_line_sn a WITH(NOLOCK)
							   INNER JOIN SCM_MST_DIVISION DM WITH(NOLOCK) -- 2023.03.30 HM JV 가상 사업부 추가 대응
									   ON DM.DIVISION_ID = A.DIVISION_ID
									  AND DM.ATTRIBUTE3 != 'EE'
									  AND DM.VALID_YN	 = 'Y'

						INNER JOIN scm_mst_factory_sn b WITH(NOLOCK)
						ON     a.company_id  = b.company_id
						AND    a.division_id = b.division_id
						AND    a.site_id	 = b.site_id
						AND    a.plant_id	 = b.plant_id
						AND    a.factory_id  = b.factory_id
						
						-- PJ20216891
						-- AND    a.division_id IN ('40', '81', '82') -- 전지본부
						-- 2023.03.30 HM JV  AND    a.division_id IN ('40', '81', '82', '81_UC') -- 전지본부
						AND    b.shop_group_id IS NOT NULL
						AND    a.operation_id IN (SELECT DISTINCT b.segment4
												  FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
												  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
												  AND    b.valid_yn = 'Y'
												  AND    b.segment3 = 'Y'
												  AND    SUBSTRING(b.segment4, 1, 1) = 'E') -- 전극 Operation
 
					   ) a

				        LEFT OUTER JOIN scm_sys_calendar_m c WITH(NOLOCK)
				        ON     c.basis_yyyymmdd >= CONVERT(CHAR(8), GETDATE(), 112)
				        AND    c.basis_yyyymmdd <  CONVERT(CHAR(8), GETDATE() + @n_period, 112)

                        LEFT OUTER JOIN (
                                 SELECT w.division_id, w.factory_id, w.operation_id, w.line_id
                                      , CONVERT(CHAR(8), w.work_date, 112) AS yyyymmdd
	                                  , SUM(w.time_term)                   AS off_time
                                 FROM   scm_work_cal_ver_h_sn w WITH(NOLOCK)

                                 INNER JOIN #master_version   v
                                 --ON     w.division_id = v.division_id  -- v 에 전극은 'EE' 로 되어 있으므로 조건 제외됨
                                 ON     w.version_id  = v.version_id
								 
								 -- PJ20216891
								 -- AND    v.division_id = 'EE' 
								 AND    v.division_id LIKE 'EE%'
								 
                                 WHERE  1=1
                                 GROUP BY w.division_id, w.factory_id, w.operation_id, w.line_id, CONVERT(CHAR(8), w.work_date, 112)
                                ) o
				        ON     a.division_id    = o.division_id 
				        AND    a.factory_id     = o.factory_id
				        AND    a.operation_id   = o.operation_id  -- o 에서 EE와 Version_id가 같은 A/P 정보가 나와도 Operation에서 걸러짐
				        AND    a.line_id        = o.line_id
				        AND    c.basis_yyyymmdd = o.yyyymmdd

				 WHERE  1=1
				 AND    c.basis_yyyymmdd IS NOT NULL
			    ) B

		  ON (       
				    A.division_id	= B.division_id
				AND A.plant_site_id	= B.scm_site_id
				AND A.factory_id	= B.factory_id
				AND A.operation_id	= B.operation_id
				AND A.line_id		= B.line_id
				AND A.yyyymmdd		= B.basis_yyyymmdd
		    )
		  WHEN MATCHED THEN
		  UPDATE SET 
					 A.working_time					=  B.working_time
					,A.last_updated_by				=  @v_batch_user
					,A.last_update_date				=  GETDATE()
					                
		  WHEN NOT MATCHED THEN
		  INSERT (
		          division_id
			     ,plant_site_id
			     ,factory_id
			     ,operation_id
			     ,line_id
			     ,yyyymmdd
			     ,working_time
				 ,created_by
				 ,creation_date
				 ,last_updated_by
				 ,last_update_date
				 )
		  VALUES (
		          B.division_id
			 	 ,B.scm_site_id
				 ,B.factory_id
				 ,B.operation_id
				 ,B.line_id
				 ,B.basis_yyyymmdd
				 ,B.working_time
			     ,@v_batch_user
			     ,GETDATE()
			     ,@v_batch_user
			     ,GETDATE() 
			     )
		  ;

          -- TXN LOG
          SET @n_log_count = @@ROWCOUNT;
          SET @v_log_type = N'TXN';    
          SET @v_log_message = N'INSERT INTO 전극 : ' + ISNULL(@p_division_id, 'ALL')
          SET @v_description = N'Process Complete...' 
          SET @d_event_date = SYSDATETIME();
          EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        END; -- IF ISNULL(@p_division_id, 'EE') <> 'EE'
		
		-------------------------------------------
		-- 4. 임시 테이블 Drop
		-------------------------------------------
        IF OBJECT_ID('tempdb..#master_version') IS NOT NULL
        BEGIN 
            DROP TABLE #master_version          
        END 

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END
    END TRY

    BEGIN CATCH
	  IF @@TRANCOUNT > 0 
        BEGIN
          ROLLBACK;
        END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : '+ CAST(ERROR_LINE() AS nvarchar(10));;
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
