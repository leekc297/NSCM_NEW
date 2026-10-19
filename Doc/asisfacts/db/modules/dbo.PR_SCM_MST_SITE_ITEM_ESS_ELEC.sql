

/*
 * Program ID   : PR_SCM_MST_SITE_ITEM_ESS_ELEC
 * Description  : ESS 전극소요관련 site_item mapping 후 INSERT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 4. 27    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_SITE_ITEM_ESS_ELEC]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_MST_SITE_ITEM_ESS_ELEC';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	BIGINT;
	DECLARE @v_ifseqno      NVARCHAR(50);


	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
	--BEGIN TRANSACTION
      BEGIN

			 MERGE INTO scm_mst_site_item A
			 USING (SELECT DISTINCT 
						   81 division_id
						  ,'E17XXX001' project_code
						  ,md.segment3 scm_site_id
						  ,bv.child_item_id item_id
					FROM   scm_mst_model_one_level_bom_v bv WITH(NOLOCK)
					JOIN   scm_mst_plant_sn ps WITH(NOLOCK)
					ON     bv.division_id           = ps.division_id
					AND    bv.plant_id              = ps.plant_id
					JOIN   scm_adm_lookup_master_detail md WITH(NOLOCK)
					ON     ps.company_id            = md.segment2
					WHERE  bv.division_id           ='82'
					AND    bv.operation_group       ='E'
					AND    LEFT(bv.child_item_id,5) IN ('APCCA','APCAN','APCCS')
					AND    md.lookup_type           = 'INTERNAL_BIZ_SITE'
					AND    md.valid_yn              = 'Y'
				) B
			ON (          A.division_id				=  B.division_id
				      AND A.project_code			=  B.project_code
					  AND A.scm_site_id				=  B.scm_site_id
					  AND A.item_id					=  B.item_id

			   )		

		    WHEN NOT MATCHED THEN
				 INSERT (  
					   division_id
					  ,project_code
					  ,scm_site_id
					  ,item_id
					  ,valid_yn	
					  ,bpms_exist
					  ,created_by			
					  ,creation_date		
					  ,last_updated_by		
					  ,last_update_date
					 )
				 VALUES (
				       B.division_id
					  ,B.project_code
					  ,B.scm_site_id
					  ,B.item_id
					  ,'Y'
					  ,'N'
					  ,@v_batch_user
					  ,GETDATE()
					  ,@v_batch_user
					  ,GETDATE()
					   )
					  ;

			  -----------------------------------------------------------
              -- insert LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_mst_site_item';
              SET @v_description = '' + @v_ifseqno;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END;
    --COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + CAST(ERROR_LINE() AS nvarchar(10));
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

