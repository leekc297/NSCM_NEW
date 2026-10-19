---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : PR_SCM_MST_PROJECT_DV_MASTER
 * Description  : Project(BPMS) DV Master 정보 I/F 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 1. 10    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 수정 필요 로 주석 달아 놓은 것 정상 Data I/F 되면 수정해야 함
 * 2021.10.05     SJHAN		   속도 개선을 위해 CURSOR, MERGE INTO -> INSERT, UPDATE문으로 변경
 */
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_SCM_MST_PROJECT_DV_MASTER]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_PROJECT_DV_MASTER';
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
	  UPDATE [dbo].[xif_plm_pjt_dv_master_r_sn]
	  SET    attr_15 = 'P'
	  WHERE  ISNULL(attr_15,'N') = 'N';
	  
	  -- History 데이터 처리를 위한 TEMP Table 삭제 및 생성
	  IF OBJECT_ID('#scm_mst_project_mapping_temp') IS NOT NULL 
		DROP TABLE #scm_mst_project_mapping_temp
	  
	  SELECT * 
	  INTO   #scm_mst_project_mapping_temp
	  FROM   dbo.scm_mst_project_mapping WITH(NOLOCK);
	  
		---------------------------------------------
		-- UPDATE
		---------------------------------------------
		UPDATE SCM_MST_PROJECT_MAPPING SET 
			project_owner = B.pm_id,
			last_updated_by = @v_batch_user,
			last_update_date = GETDATE()
		FROM 
			(SELECT DISTINCT 
				--dbo.[FN_GET_LOOKUP_CODE_DESC]('BUSINESS_UNIT_CODE', A.business_unit_code) AS biz_unit_code
				B.SEGMENT2 AS biz_unit_code
				,attr_01,project_id,attr_03,attr_04,MAX(pm_id) pm_id 
				FROM [dbo].[xif_plm_pjt_dv_master_r_sn] A WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.BUSINESS_UNIT_CODE = B.SEGMENT1 AND B.VALID_YN = 'Y'
				WHERE 1=1
					AND if_seq IN (SELECT if_seq FROM [dbo].[xif_plm_pjt_dv_master_r_sn] WITH(NOLOCK) WHERE  attr_15 = 'P' GROUP BY if_seq)
					AND   attr_15 = 'P'
					AND   attr_01 > char(0)
				GROUP BY project_id,B.SEGMENT2,attr_01,attr_02,attr_03,attr_04,if_type) B
		WHERE 1 = 1 
			AND division_id = B.biz_unit_code
			AND project_code = B.attr_01
			AND gplm_project_code = B.project_id
			AND gplm_system_project_code = B.attr_03
			AND gplm_dev_project_code = B.attr_04

		---------------------------------------------
		-- INSERT
		---------------------------------------------
		INSERT INTO SCM_MST_PROJECT_MAPPING
			(division_id
			, project_code 
			, gplm_project_code
			, gplm_system_project_code
			, gplm_dev_project_code
			, project_owner
			, valid_yn
			, created_by, creation_date, last_updated_by, last_update_date)
		SELECT DISTINCT/* PR_SCM_MST_PROJECT_DV_MASTER */ 
			B.SEGMENT2 AS biz_unit_code
			, A.attr_01
			, A.project_id
			, A.attr_03
			, A.attr_04
			, MAX(A.pm_id) pm_id
			, 'Y'
			, @v_batch_user, GETDATE(), @v_batch_user,GETDATE()
		FROM [dbo].[xif_plm_pjt_dv_master_r_sn] A WITH(NOLOCK)
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B (NOLOCK) ON A.BUSINESS_UNIT_CODE = B.SEGMENT1 AND B.VALID_YN = 'Y'
		LEFT OUTER JOIN SCM_MST_PROJECT_MAPPING C WITH(NOLOCK)  
			ON (B.SEGMENT2 = C.division_id
				AND A.attr_01 = C.project_code
				AND A.project_id = C.gplm_project_code
				AND A.attr_03 = C.gplm_system_project_code
				AND A.attr_04 = C.gplm_dev_project_code)	 
		WHERE 1=1
			AND C.project_code IS NULL
			AND A.if_seq IN (SELECT if_seq FROM [dbo].[xif_plm_pjt_dv_master_r_sn] WITH(NOLOCK) WHERE  attr_15 = 'P' GROUP BY if_seq)
			AND  A.attr_15 = 'P'
			AND  A.attr_01 > char(0)
		GROUP BY A.project_id, B.SEGMENT2, A.attr_01, A.attr_02, A.attr_03, A.attr_04, A.if_type



		-- scm_mst_project.gplm_mapping_yn update

		UPDATE scm_mst_project
		SET gplm_mapping_yn = 'Y' ,last_update_date = getdate()
		FROM scm_mst_project A WITH(NOLOCK) 
		INNER JOIN scm_mst_project_mapping B WITH(NOLOCK) 
		ON  A.division_id		=  B.division_id
		AND A.gplm_project_code =  B.gplm_project_code-- , project_ver_seq 수정 필요

		/*
		-- scm_mst_project.gplm_mapping_yn 및 project_owner update
		UPDATE scm_mst_project
		SET    project_owner = pm.project_owner ,last_update_date = getdate()
		FROM   scm_mst_project mp WITH(NOLOCK)
		JOIN  (SELECT division_id
					 ,project_code
					 --,project_ver_seq 수정 필요
					 ,max(project_owner) project_owner
			   FROM   scm_mst_project_mapping WITH(NOLOCK)
			   WHERE  valid_yn = 'Y'
			   GROUP BY division_id, project_code) pm -- , project_ver_seq 수정 필요
		ON     mp.division_id = pm.division_id
		AND    mp.project_code = pm.project_code
		--AND    mp.project_ver_seq = pm.project_ver_seq 수정 필요
	;*/


		-- 처리가 된 row update
		UPDATE xif_plm_pjt_dv_master_r_sn
		SET attr_15 = 'Y' 
		WHERE attr_15 = 'P';
		-- History 저장, history 생성 날짜와 기존 데이터 insert 날짜를 다르게 하기 위해 조인해서 처리
		 SET @n_history_seq = NEXT VALUE FOR seq1_scm_mst_project_mapping_h
		 INSERT INTO [dbo].[scm_mst_project_mapping_h] (
						     history_seq
						    ,division_id
							,project_code
							,project_ver_seq
							,gplm_project_code
							,gplm_system_project_code
							,gplm_dev_project_code
							,project_owner
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
					SELECT A.*,B.creation_date,B.last_update_date FROM (SELECT /* scm_mst_project_mapping_h */
						     division_id
							,project_code
							,project_ver_seq
							,gplm_project_code
							,gplm_system_project_code
							,gplm_dev_project_code
							,project_owner
							,valid_yn
					FROM #scm_mst_project_mapping_temp WITH(NOLOCK)
					EXCEPT
					SELECT /* scm_mst_project_mapping_h */
						     division_id
							,project_code
							,project_ver_seq
							,gplm_project_code
							,gplm_system_project_code
							,gplm_dev_project_code
							,project_owner
							,valid_yn
				    FROM [dbo].[scm_mst_project_mapping] WITH(NOLOCK)) A 
					INNER JOIN #scm_mst_project_mapping_temp B WITH(NOLOCK)
				   ON	   A.division_id			 =  B.division_id
					   AND A.project_code			 =  B.project_code
					   AND A.project_ver_seq		 =  B.project_ver_seq
					   AND A.gplm_project_code		 =  B.gplm_project_code
					   AND A.gplm_system_project_code=  B.gplm_system_project_code
					   AND A.gplm_dev_project_code	 =  B.gplm_dev_project_code ) A
		
		-- 처리 한 row 마킹
		
		IF OBJECT_ID('#scm_mst_project_mapping_temp') IS NOT NULL 
			DROP TABLE #scm_mst_project_mapping_temp
		
        -- HISTORY LOG
		
        SET @v_log_type = 'HISTORY';
        SET @n_log_count = @@ROWCOUNT;
        SET @v_log_message = 'INSERT INTO scm_mst_project_mapping_h';
        SET @v_description = '@n_history_seq' +':'+ CAST(@n_history_seq AS nvarchar(100));
        SET @d_event_date = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-- 순차적 호출을 위함
		EXEC PR_SCM_MST_PROJECT_ITEM;
		
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

