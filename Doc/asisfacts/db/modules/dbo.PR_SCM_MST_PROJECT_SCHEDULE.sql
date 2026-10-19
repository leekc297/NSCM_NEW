/*
 * Program ID   : PR_SCM_MST_PROJECT_SCHEDULE
 * Description  : GPLM Project Schedule I/F
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 10    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE   PROCEDURE [dbo].[PR_SCM_MST_PROJECT_SCHEDULE]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PROJECT_SCHEDULE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @v_ifseqno     NVARCHAR(30); 
	DECLARE @n_history_seq	BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	  -- 인터페이스 테이블 처리 ROW UPDATE
			UPDATE [dbo].[xif_plm_pjt_schedule_r_sn]
			SET attr_10 = 'P'
			WHERE ISNULL(attr_10,'N') = 'N';
	  
	  -- 지나간 배치까지 적용하기 위해 Cursor 로 처리
	  DECLARE CUR_PROJECT CURSOR FOR
	  SELECT if_seq 
	  FROM  [dbo].[xif_plm_pjt_schedule_r_sn] WITH(NOLOCK)
	  WHERE attr_10 = 'P'
	  GROUP BY if_seq
	  ORDER BY if_seq ASC;

	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('dbo.scm_mst_project_schedule_temp$') IS NOT NULL DROP TABLE scm_mst_project_schedule_temp$
	  
	  SELECT * INTO dbo.scm_mst_project_schedule_temp$
	  FROM dbo.scm_mst_project_schedule WITH(NOLOCK);

		 OPEN CUR_PROJECT;
		 FETCH NEXT FROM CUR_PROJECT INTO @v_ifseqno ;
		 
		 WHILE (@@FETCH_STATUS = 0)
		 BEGIN
		   
			 MERGE INTO [dbo].[scm_mst_project_schedule] A
			 USING ( 
					SELECT DISTINCT/* PR_SCM_MST_PROJECT_SCHEDULE */ 
						 	   project_id
							  ,b.division_id AS division_id
							  ,ISNULL(b.project_ver_seq,'') AS project_ver_seq
							  ,CASE if_type WHEN 'D' THEN 'N' ELSE 'Y' END AS valid_yn
							  ,cv_app_plan_start_date
							  ,cv_app_plan_end_date
							  ,cv_plan_start_date
							  ,cv_plan_end_date
							  ,cv_actual_start_date
							  ,cv_actual_end_date
							  ,dv_app_plan_start_date
							  ,dv_app_plan_end_date
							  ,dv_plan_start_date
							  ,dv_plan_end_date
							  ,dv_actual_start_date
							  ,dv_actual_end_date
							  ,pd_app_plan_start_date
							  ,pd_app_plan_end_date
							  ,pd_plan_start_date
							  ,pd_plan_end_date
							  ,pd_actual_start_date
							  ,pd_actual_end_date
							  ,pv_app_plan_start_date
							  ,pv_app_plan_end_date
							  ,pv_plan_start_date
							  ,pv_plan_end_date
							  ,pv_actual_start_date
							  ,pv_actual_end_date
					  FROM [dbo].[xif_plm_pjt_schedule_r_sn] A WITH(NOLOCK)
					  INNER JOIN (SELECT * FROM scm_mst_project_mapping WITH(NOLOCK)) B 
					  ON A.project_id = B.gplm_project_code
					  WHERE if_seq = @v_ifseqno
					  AND attr_10 = 'P'
					  AND CV_APP_PLAN_START_DATE  IS NOT NULL  -- 김춘동 임시 처리 2025-11-30

					) B
			ON (       A.division_id	   =  B.division_id
				   AND A.project_code	   =  B.project_id
				   --AND A.project_ver_seq   =  B.project_ver_seq 수정 필요

			   )
			WHEN MATCHED THEN
				 UPDATE SET 
							 
							 A.cv_app_plan_start_date    =   B.cv_app_plan_start_date
							,A.cv_app_plan_end_date      =   B.cv_app_plan_end_date
							,A.cv_plan_start_date        =   B.cv_plan_start_date
							,A.cv_plan_end_date          =   B.cv_plan_end_date
							,A.cv_actual_start_date      =   B.cv_actual_start_date
							,A.cv_actual_end_date        =   B.cv_actual_end_date
							,A.dv_app_plan_start_date    =   B.dv_app_plan_start_date
							,A.dv_app_plan_end_date      =   B.dv_app_plan_end_date
							,A.dv_plan_start_date        =   B.dv_plan_start_date
							,A.dv_plan_end_date          =   B.dv_plan_end_date
							,A.dv_actual_start_date      =   B.dv_actual_start_date
							,A.dv_actual_end_date        =   B.dv_actual_end_date
							,A.pd_app_plan_start_date    =   B.pd_app_plan_start_date
							,A.pd_app_plan_end_date      =   B.pd_app_plan_end_date
							,A.pd_plan_start_date        =   B.pd_plan_start_date
							,A.pd_plan_end_date          =   B.pd_plan_end_date
							,A.pd_actual_start_date      =   B.pd_actual_start_date
							,A.pd_actual_end_date        =   B.pd_actual_end_date
							,A.pv_app_plan_start_date    =   B.pv_app_plan_start_date
							,A.pv_app_plan_end_date      =   B.pv_app_plan_end_date
							,A.pv_plan_start_date        =   B.pv_plan_start_date
							,A.pv_plan_end_date          =   B.pv_plan_end_date
							,A.pv_actual_start_date      =   B.pv_actual_start_date
							,A.pv_actual_end_date        =   B.pv_actual_end_date
							,A.valid_yn			         =   B.valid_yn
							,A.last_updated_by           =   @v_batch_user
							,A.last_update_date          =   GETDATE()


					                
			WHEN NOT MATCHED THEN
				 INSERT (  
				             division_id
							,project_code
							,project_ver_seq
						    ,cv_app_plan_start_date
						    ,cv_app_plan_end_date
						    ,cv_plan_start_date
						    ,cv_plan_end_date
						    ,cv_actual_start_date
						    ,cv_actual_end_date
						    ,dv_app_plan_start_date
						    ,dv_app_plan_end_date
						    ,dv_plan_start_date
						    ,dv_plan_end_date
						    ,dv_actual_start_date
						    ,dv_actual_end_date
						    ,pd_app_plan_start_date
						    ,pd_app_plan_end_date
						    ,pd_plan_start_date
						    ,pd_plan_end_date
						    ,pd_actual_start_date
						    ,pd_actual_end_date
						    ,pv_app_plan_start_date
						    ,pv_app_plan_end_date
						    ,pv_plan_start_date
						    ,pv_plan_end_date
						    ,pv_actual_start_date
						    ,pv_actual_end_date
							,valid_yn
					        ,created_by
						    ,creation_date
						    ,last_updated_by
						    ,last_update_date						  								
						)
				 VALUES (   
							 B.division_id
							,B.project_id
							,B.project_ver_seq
							,B.cv_app_plan_start_date
							,B.cv_app_plan_end_date
							,B.cv_plan_start_date
							,B.cv_plan_end_date
							,B.cv_actual_start_date
							,B.cv_actual_end_date
							,B.dv_app_plan_start_date
							,B.dv_app_plan_end_date
							,B.dv_plan_start_date
							,B.dv_plan_end_date
							,B.dv_actual_start_date
							,B.dv_actual_end_date
							,B.pd_app_plan_start_date
							,B.pd_app_plan_end_date
							,B.pd_plan_start_date
							,B.pd_plan_end_date
							,B.pd_actual_start_date
							,B.pd_actual_end_date
							,B.pv_app_plan_start_date
							,B.pv_app_plan_end_date
							,B.pv_plan_start_date
							,B.pv_plan_end_date
							,B.pv_actual_start_date
							,B.pv_actual_end_date
							,B.valid_yn
						    ,@v_batch_user
						    ,GETDATE()
						    ,@v_batch_user
						    ,GETDATE() 
						)
			;

			-- 처리 row 마킹
			UPDATE [dbo].[xif_plm_pjt_schedule_r_sn]
			SET attr_10 = 'Y'
			WHERE if_seq	   =  @v_ifseqno
			AND   attr_10	   = 'P'
			AND   project_id IN(SELECT gplm_project_code FROM scm_mst_project_mapping WITH(NOLOCK) );

			 -----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_mst_project_schedule';
              SET @v_description = 'if_seq = ' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

			FETCH NEXT FROM CUR_PROJECT INTO  @v_ifseqno
			END
		
		CLOSE CUR_PROJECT;
		DEALLOCATE CUR_PROJECT; 
		
		
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_mst_project_schedule_h
		 INSERT INTO [dbo].[scm_mst_project_schedule_h] (
							 history_seq
						    ,division_id
							,project_code
							,project_ver_seq
						    ,cv_app_plan_start_date
						    ,cv_app_plan_end_date
						    ,cv_plan_start_date
						    ,cv_plan_end_date
						    ,cv_actual_start_date
						    ,cv_actual_end_date
						    ,dv_app_plan_start_date
						    ,dv_app_plan_end_date
						    ,dv_plan_start_date
						    ,dv_plan_end_date
						    ,dv_actual_start_date
						    ,dv_actual_end_date
						    ,pd_app_plan_start_date
						    ,pd_app_plan_end_date
						    ,pd_plan_start_date
						    ,pd_plan_end_date
						    ,pd_actual_start_date
						    ,pd_actual_end_date
						    ,pv_app_plan_start_date
						    ,pv_app_plan_end_date
						    ,pv_plan_start_date
						    ,pv_plan_end_date
						    ,pv_actual_start_date
						    ,pv_actual_end_date
							,valid_yn	
						    ,creation_date
						    ,last_update_date
						    ,created_by					
						    ,last_updated_by	
						    ,history_creation_date
					  )
				 SELECT @n_history_seq
			       ,A.*
				   ,@v_batch_user
				   ,@v_batch_user
				   ,GETDATE()
	        FROM (
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_mst_project_schedule_h */
						     division_id
							,project_code
							,project_ver_seq
						    ,cv_app_plan_start_date
						    ,cv_app_plan_end_date
						    ,cv_plan_start_date
						    ,cv_plan_end_date
						    ,cv_actual_start_date
						    ,cv_actual_end_date
						    ,dv_app_plan_start_date
						    ,dv_app_plan_end_date
						    ,dv_plan_start_date
						    ,dv_plan_end_date
						    ,dv_actual_start_date
						    ,dv_actual_end_date
						    ,pd_app_plan_start_date
						    ,pd_app_plan_end_date
						    ,pd_plan_start_date
						    ,pd_plan_end_date
						    ,pd_actual_start_date
						    ,pd_actual_end_date
						    ,pv_app_plan_start_date
						    ,pv_app_plan_end_date
						    ,pv_plan_start_date
						    ,pv_plan_end_date
						    ,pv_actual_start_date
						    ,pv_actual_end_date
							,valid_yn
					FROM [dbo].[scm_mst_project_schedule_temp$] WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_mst_project_schedule_h */
						     division_id
							,project_code
							,project_ver_seq
						    ,cv_app_plan_start_date
						    ,cv_app_plan_end_date
						    ,cv_plan_start_date
						    ,cv_plan_end_date
						    ,cv_actual_start_date
						    ,cv_actual_end_date
						    ,dv_app_plan_start_date
						    ,dv_app_plan_end_date
						    ,dv_plan_start_date
						    ,dv_plan_end_date
						    ,dv_actual_start_date
						    ,dv_actual_end_date
						    ,pd_app_plan_start_date
						    ,pd_app_plan_end_date
						    ,pd_plan_start_date
						    ,pd_plan_end_date
						    ,pd_actual_start_date
						    ,pd_actual_end_date
						    ,pv_app_plan_start_date
						    ,pv_app_plan_end_date
						    ,pv_plan_start_date
						    ,pv_plan_end_date
						    ,pv_actual_start_date
						    ,pv_actual_end_date
							,valid_yn
				    FROM [dbo].[scm_mst_project_schedule] WITH(NOLOCK)) A 
					INNER JOIN [dbo].[scm_mst_project_schedule_temp$] B WITH(NOLOCK)
				   ON  A.division_id       =  B.division_id
				   AND A.project_code	   =  B.project_code
				   AND A.project_ver_seq   =  B.project_ver_seq ) A
		
		-- 처리 안된 row 마킹
		UPDATE [dbo].[xif_plm_pjt_schedule_r_sn]
		SET attr_10   = 'X' 
		WHERE attr_10 = 'P'
		
		DROP TABLE dbo.scm_mst_project_schedule_temp$;
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_project_schedule_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		
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
