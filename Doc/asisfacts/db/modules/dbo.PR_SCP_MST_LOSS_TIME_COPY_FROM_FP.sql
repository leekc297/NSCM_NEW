

/*
 * Program ID   : PR_SCP_MST_LOSS_TIME_COPY_FROM_FP
 * Description  : Loss time 생성 프로시져. 
				: 기존에 데이터가 있으면 Update함
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.01.25   KSG            Initial Release PJ20209642 LGES 전지GSCM 상반기 프로젝트
 * 2021.05.28   KSG            PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 중장기 대응
 * 2021.07.27   sclee          PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화
 * 2022.03.25   sclee          PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가
 * 2022.06.27   sclee.lee      PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - isuzu관련 조회구문 변경
 * 2023.03.30	HRK			   PJ20230691R LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 대응
 * 2025.03.05   kimcd          정보 중복 오류 조치
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_LOSS_TIME_COPY_FROM_FP]
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
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_LOSS_TIME_COPY_FROM_FP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno      NVARCHAR(30); 
	DECLARE @v_instanceid   NVARCHAR(40); 
	DECLARE @n_mq_seq	    BIGINT;
	DECLARE @n_dayofweek    INT = 1;
	DECLARE @n_period       INT = 450; -- Loss Time 생성 구간

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN  
	  	  
		-- 20210528 PJ20209642 : Loss Time 생성 구간
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
		
        -------------------------------------------
        -- 최신 Version Check
        -------------------------------------------
        SELECT division_id, MAX(version_id) AS version_id
        INTO   #master_version
        FROM   scm_master_version_info_h_sn WITH(NOLOCK)
        WHERE  division_id  = ISNULL(@p_division_id, division_id)
        AND    scp_use_flag = 'Y'
        GROUP BY division_id;

		-------------------------------------------
	    -- 2. Loss Time Except 생성 : 전극 외
		-------------------------------------------
		-- PJ20216891
        -- IF ISNULL(@p_division_id, 'ALL') <> 'EE'
        -- 2023.03.30 IF ISNULL(@p_division_id, 'ALL') NOT LIKE N'EE%'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF @p_division_id IS NULL
		   OR
		   EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3 != 'EE'
					 AND VALID_YN	 = 'Y') 
        BEGIN

	      MERGE INTO scp_mst_loss_time_except a
		  USING ( SELECT  a.division_id
					   ,a.scm_site_id
					   ,a.factory_id
					   ,a.operation_id
					   ,a.line_id
					   ,c.basis_yyyymmdd AS start_date
					   ,c.basis_yyyymmdd AS end_date

					   --, w.working_time AS working_time
					   --,ISNULL(o.loss_rate, 0) AS loss_rate
					   ,ISNULL(w.working_time, 0) * ISNULL(o.loss_rate, 0)       AS loss_time_min
					   -- ,ISNULL(w.working_time, 0) * ISNULL(o.setup_loss_rate, 0) AS setup_loss_time_min
                       --PJ20214907 자동차사업부(81)인 경우 setup_loss_time_min를 0으로 처리
                       ,CASE WHEN a.division_id = '81' THEN 0 ELSE ISNULL(w.working_time, 0) * ISNULL(o.setup_loss_rate, 0) END AS setup_loss_time_min
				FROM   (-- 전지본부 Plant
				        SELECT  DISTINCT 
								a.division_id
							   ,ISNULL(dbo.FN_GET_SCM_SITE_ID_PLANT(a.plant_id,b.shop_group_id),'-') scm_site_id
							   ,b.factory_id
							   ,a.operation_id
							   ,a.line_id
						FROM   scm_mst_line_sn a WITH(NOLOCK)

						INNER JOIN scm_mst_factory_sn b WITH(NOLOCK)
						ON     a.company_id  = b.company_id
						AND    a.division_id = b.division_id
						AND    a.site_id	 = b.site_id
						AND    a.plant_id	 = b.plant_id
						AND    a.factory_id  = b.factory_id
						AND    a.division_id = ISNULL(@p_division_id, a.division_id)
						AND    b.shop_group_id IS NOT NULL
/*
						AND    a.operation_id IN (SELECT DISTINCT b.segment4
												  FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
												  WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
												  AND    b.valid_yn = 'Y'
												  AND    b.segment3 = 'Y'
												  AND    SUBSTRING(b.segment4, 1, 1) <> 'E') -- 전극 외 Operation 
*/
                        -- PJ20216891	
                        -- ISUZU item
                        AND    (
                                a.operation_id IN (
                                                   SELECT DISTINCT b.segment4
                                                   FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)
                                                   WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'
                                                   AND    b.valid_yn    = 'Y'
                                                   AND    b.segment3    = 'Y' -- Capa 세부 공정 여부
                                                   AND    SUBSTRING(b.segment4, 1, 1) <> 'E' -- 전극 외 Operation
                                                  )
                                OR (
                                    a.operation_id = 'P5000'
/*
                                    AND EXISTS (
                                                SELECT 1
                                                FROM   dbo.SCM_MST_FINAL_ITEM_V A1 WITH(NOLOCK)
                                                INNER JOIN dbo.SCP_MST_FINAL_ITEM_V B1 WITH(NOLOCK) ON A1.ITEM_ID = B1.ITEM_ID
                                                WHERE  A1.ITEM_ID = a.ITEM_ID
                                                AND    A1.IS_YN = 'Y'
                                               )
*/
                                   )
                               )
					   ) a

				LEFT OUTER JOIN scm_sys_calendar_m c WITH(NOLOCK)
				ON     c.basis_yyyymmdd >= CONVERT(CHAR(8), GETDATE(), 112)
				AND    c.basis_yyyymmdd <  CONVERT(CHAR(8), GETDATE() + @n_period, 112)

                LEFT OUTER JOIN (
                                 SELECT a.division_id, a.factory_id, a.operation_id, a.line_id, a.work_month
                                       , SUM(ISNULL(a.loss_rate, 0))       AS loss_rate
                                       , SUM(ISNULL(a.setup_loss_rate, 0)) AS setup_loss_rate
                                 FROM (
                                       SELECT l.division_id, l.factory_id, l.operation_id, l.line_id, l.work_month, lo.segment1
	                                        , CASE WHEN ISNULL(lo.attribute2, '') <> 'Model Change' THEN SUM(l.loss_rate) END AS loss_rate
	                                        , CASE WHEN ISNULL(lo.attribute2, '')  = 'Model Change' THEN SUM(l.loss_rate) END AS setup_loss_rate
                                       FROM   scm_loss_ver_h_sn l WITH(NOLOCK)

                                       INNER JOIN #master_version   v
                                       ON     l.division_id = v.division_id  -- v 에 전극은 'EE' 로 되어 있으므로 자연스럽게 제외됨
                                       AND    l.version_id  = v.version_id

                                       INNER JOIN      (SELECT *
                                                        FROM   scm_sys_lookup_value_sn
                                                        WHERE  1=1
                                                        AND    lookup_type_code = 'CAPA_UI_LOSS_TYPE_DEFINIT'
                                                        AND    attribute6       = 'Y'
                                                       )  lo
                                       ON  l.loss_code = lo.segment1
								 
                                       WHERE  1=1
                                       GROUP BY l.division_id, l.factory_id, l.operation_id, l.line_id, l.work_month, lo.segment1, lo.attribute2
                                      ) a
                                 GROUP BY a.division_id, a.factory_id, a.operation_id, a.line_id, a.work_month
                                ) o
				ON     a.division_id    = o.division_id
				AND    a.factory_id     = o.factory_id
				AND    a.operation_id   = o.operation_id
				AND    a.line_id        = o.line_id
				AND    c.basis_yyyymm   = o.work_month

				LEFT OUTER JOIN scp_mst_working_time w with(nolock)
				ON     a.division_id    = w.division_id
				AND    a.scm_site_id    = w.plant_site_id   -- 2025.03.05   kimcd    정보 중복 오류 조치
				AND    a.factory_id     = w.factory_id
				AND    a.operation_id   = w.operation_id
				AND    a.line_id        = w.line_id
				AND    c.basis_yyyymmdd = w.yyyymmdd

				WHERE  1=1
				AND    c.basis_yyyymm IS NOT NULL
			  ) B

		  ON (       
				    A.division_id	  = B.division_id
				AND A.plant_site_id	  = B.scm_site_id
				AND A.factory_id	  = B.factory_id
				AND A.operation_id	  = B.operation_id
				AND A.line_id		  = B.line_id
				AND A.loss_start_date = B.start_date
				AND A.loss_end_date	  = B.end_date
		  )
		  WHEN MATCHED THEN
		  UPDATE SET 
					 A.loss_time_min				=  B.loss_time_min
					,A.setup_loss_time_min			=  B.setup_loss_time_min
					,A.last_updated_by				=  @v_batch_user
					,A.last_update_date				=  GETDATE()
					                
		  WHEN NOT MATCHED THEN
		  INSERT (
		          division_id
			     ,plant_site_id
			     ,factory_id
			     ,operation_id
			     ,line_id
			     ,loss_start_date
			     ,loss_end_date
			     ,loss_time_min
			     ,setup_loss_time_min
				 ,except_comment
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
				 ,B.start_date
				 ,B.end_date
				 ,B.loss_time_min
				 ,B.setup_loss_time_min
				 ,'Copy From FP'
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
	    -- 3. Loss Time Except 생성 : 전극 : 수정할 것
		-------------------------------------------
		-- PJ20216891
        -- IF ISNULL(@p_division_id, 'EE') = 'EE'
		-- 2023.03.30 IF ISNULL(@p_division_id, 'EE') LIKE 'EE%'
		-- 2023.03.30 HM JV 가상 사업부 추가 대응
		IF @p_division_id IS NULL
		   OR
		   EXISTS(SELECT 1
					FROM SCM_MST_DIVISION WITH(NOLOCK)
				   WHERE DIVISION_ID = @p_division_id
				     AND ATTRIBUTE3  = 'EE'
					 AND VALID_YN	 = 'Y') 
        BEGIN

	      MERGE INTO scp_mst_loss_time_except a
		  USING ( SELECT  a.division_id
					   ,a.scm_site_id
					   ,a.factory_id
					   ,a.operation_id
					   ,a.line_id
					   ,c.basis_yyyymmdd AS start_date
					   ,c.basis_yyyymmdd AS end_date

					   --, w.working_time AS working_time
					   --,ISNULL(o.loss_rate, 0) AS loss_rate
					   ,ISNULL(w.working_time, 0) * ISNULL(o.loss_rate, 0)       AS loss_time_min
					   ,ISNULL(w.working_time, 0) * ISNULL(o.setup_loss_rate, 0) AS setup_loss_time_min
				FROM   (-- 전지본부 Plant
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
						-- 2023.03.30 HM JV AND    a.division_id IN ('40', '81', '82', '81_UC') -- 전지본부
						
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
                                 SELECT a.division_id, a.factory_id, a.operation_id, a.line_id, a.work_month
                                      , SUM(ISNULL(a.loss_rate, 0))       AS loss_rate
                                      , SUM(ISNULL(a.setup_loss_rate, 0)) AS setup_loss_rate
                                 FROM (

                                       SELECT l.division_id, l.factory_id, l.operation_id, l.line_id, l.work_month, lo.segment1
	                                        , CASE WHEN ISNULL(lo.attribute2, '') <> 'Model Change' THEN SUM(l.loss_rate) END AS loss_rate
	                                        , CASE WHEN ISNULL(lo.attribute2, '')  = 'Model Change' THEN SUM(l.loss_rate) END AS setup_loss_rate
                                       FROM   scm_loss_ver_h_sn l WITH(NOLOCK)

                                       INNER JOIN #master_version   v
                                       --ON     l.division_id = v.division_id  -- v 에 전극은 'EE' 로 되어 있으므로 조건 제외됨
                                       ON    l.version_id  = v.version_id
									   
                                       INNER JOIN      (SELECT *
                                                        FROM   scm_sys_lookup_value_sn
                                                        WHERE  1=1
                                                        AND    lookup_type_code = 'CAPA_UI_LOSS_TYPE_DEFINIT'
                                                        AND    attribute6       = 'Y'
                                                       )  lo
                                       ON  l.loss_code = lo.segment1
								 
                                       WHERE  1=1
                                       GROUP BY l.division_id, l.factory_id, l.operation_id, l.line_id, l.work_month, lo.segment1, lo.attribute2
                                      ) a
                                 GROUP BY a.division_id, a.factory_id, a.operation_id, a.line_id, a.work_month
                                ) o
				ON     a.division_id    = o.division_id
				AND    a.factory_id     = o.factory_id
				AND    a.operation_id   = o.operation_id
				AND    a.line_id        = o.line_id
				AND    c.basis_yyyymm   = o.work_month

				LEFT OUTER JOIN scp_mst_working_time w with(nolock)
				ON     a.division_id    = w.division_id
				AND    a.scm_site_id    = w.plant_site_id   -- 2025.03.05   kimcd    정보 중복 오류 조치
				AND    a.factory_id     = w.factory_id
				AND    a.operation_id   = w.operation_id
				AND    a.line_id        = w.line_id
				AND    c.basis_yyyymmdd = w.yyyymmdd

				WHERE  1=1
				AND    c.basis_yyyymm IS NOT NULL
			  ) B

		  ON (       
				    A.division_id	  = B.division_id
				AND A.plant_site_id	  = B.scm_site_id
				AND A.factory_id	  = B.factory_id
				AND A.operation_id	  = B.operation_id
				AND A.line_id		  = B.line_id
				AND A.loss_start_date = B.start_date
				AND A.loss_end_date	  = B.end_date
		    )
		  WHEN MATCHED THEN
		  UPDATE SET 
					 A.loss_time_min				=  B.loss_time_min
					,A.setup_loss_time_min			=  B.setup_loss_time_min
					,A.last_updated_by				=  @v_batch_user
					,A.last_update_date				=  GETDATE()
					                
		  WHEN NOT MATCHED THEN
		  INSERT (
		          division_id
			     ,plant_site_id
			     ,factory_id
			     ,operation_id
			     ,line_id
			     ,loss_start_date
			     ,loss_end_date
			     ,loss_time_min
			     ,setup_loss_time_min
				 ,except_comment
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
				 ,B.start_date
				 ,B.end_date
				 ,B.loss_time_min
				 ,B.setup_loss_time_min
				 ,'Copy From FP'
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
