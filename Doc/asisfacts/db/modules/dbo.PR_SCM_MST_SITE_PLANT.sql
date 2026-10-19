/*
 * Program ID   : PR_SCM_MST_SITE_PLANT
 * Description  : SCM_SITE_ID mapping용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.30   Kim Jaejung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.05.22   Kim Jihye      전극 사이트 자동생성 제외
 */

CREATE PROCEDURE [dbo].[PR_SCM_MST_SITE_PLANT]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user     NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name   NVARCHAR(150) = 'PR_SCM_MST_SITE_PLANT';
    DECLARE @v_log_type       NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count      INTEGER = 0;
    DECLARE @v_log_message    NVARCHAR(1000);
    DECLARE @v_description    NVARCHAR(500);
    DECLARE @d_event_date     DATETIME;
	DECLARE @v_ship_frozen    INT = 0;
	DECLARE @v_prod_frozen    INT = 0;
	DECLARE @v_fp_plan_period INT = 0;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    -- 데이터 변경 없이 일단 INSERT 로만 처리해둠
    BEGIN TRY
      BEGIN
	    SELECT @v_ship_frozen = CAST(segment2 AS INT) 
		FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
		WHERE  lookup_type = 'DEFAULT_PERIOD'
		AND    segment1 = 'SHIP_FROZEN'
		AND    valid_yn = 'Y';

		SELECT @v_prod_frozen = CAST(segment2 AS INT) 
		FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
		WHERE  lookup_type = 'DEFAULT_PERIOD'
		AND    segment1 = 'PROD_FROZEN'
		AND    valid_yn = 'Y';

		SELECT @v_fp_plan_period = CAST(segment2 AS INT) 
		FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
		WHERE  lookup_type = 'DEFAULT_PERIOD'
		AND    segment1 = 'FP_PLAN_PERIOD'
		AND    valid_yn = 'Y';

        MERGE INTO [dbo].[scm_mst_site] A
		USING (SELECT /* PR_SCM_MST_SITE_PLANT */
			          p.company_id
			  	     ,p.division_id
					 ,p.site_id
					 ,p.plant_id
					 ,p.plant_name
					 ,p.plant_id + '-' + f.shop_group_id AS scm_site_id --Plant의 경우 기존 FP의 Plant_id 와 shop_group_id 를 더해서 scm_site_id 로 사용
					 ,p.plant_name+'-'+dbo.FN_GET_LOOKUP_CODE_DESC('OPERATION_GROUP',f.shop_group_id) AS scm_site_description
					 ,f.shop_group_id
					 ,'N' attribute1
					 ,'N' attribute2
			   FROM   scm_mst_plant_sn p WITH(NOLOCK)
			   JOIN   scm_mst_factory_sn f WITH(NOLOCK)
			   ON     p.division_id      = f.division_id
			   AND    p.PLANT_ID         = f.plant_id
			   WHERE  p.outsourcing_flag = 'N'  -- 외주 packer 구분
			   AND    f.active_flag      = 'Y'
			   AND    f.shop_group_id IS NOT NULL
			   AND    f.shop_group_id    != 'E' -- 2018.05.22   Kim Jihye
			   GROUP BY p.company_id
				       ,p.division_id
					   ,p.site_id
					   ,p.plant_id
					   ,f.shop_group_id
					   ,p.plant_name) B
		ON (   A.division_id    =  B.division_id
		-- AND A.plant_id	    =  B.plant_id
		   AND A.scm_site_id    =  B.scm_site_id
	    -- AND A.site_type		=  B.shop_group_id
		   )							                
		WHEN NOT MATCHED THEN
			 INSERT ( 
			           company_id 
					  ,division_id
					  ,site_id
					  ,scm_site_id
					  ,site_description
					  ,site_type
					  ,operation_group
					  ,plant_id
					  ,logistic_plant_id 
					  ,dept_id  -- Site type sales 일때 사용, 일단은 PLANT 로 입력
					  ,vmi_yn
					  ,valid_yn
					  ,new_yn
					  ,osp_yn
					  ,ship_frozen
					  ,prod_frozen
					  ,fp_plan_period
					  ,created_by
					  ,creation_date
					  ,last_updated_by
					  ,last_update_date
					  ,attribute1
					  ,attribute2
					)
			 VALUES (  
						B.company_id
					   ,B.division_id
					   ,b.site_id
			           ,B.scm_site_id
					   ,B.scm_site_description
					   ,'PLANT'
					   ,B.shop_group_id
					   ,B.plant_id 
					   ,B.plant_id  --logistic_plant_id
					   ,'PLANT'
					   ,'N'
					   ,'Y'
					   ,'Y'       
					   ,'N'
					   ,@v_ship_frozen
					   ,@v_prod_frozen
					   ,@v_fp_plan_period
					   ,@v_batch_user  
					   ,GETDATE()
					   ,@v_batch_user
                       ,GETDATE()
					   ,B.attribute1
					   ,B.attribute2
					)
		;
		-----------------------------------------------------------
              -- Merge LOG
              -----------------------------------------------------------
              SET @v_log_type = 'APPEND';
              SET @v_log_message = 'MERGE INTO scm_mst_site';
              SET @v_description = 'insert only ' ;
              SET @d_event_date = SYSDATETIME();
              EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
              -----------------------------------------------------------

        IF @@TRANCOUNT > 0
		  BEGIN
            COMMIT WORK;
		  END;

      END;
    END TRY

    BEGIN CATCH
      IF @@TRANCOUNT > 0
		  BEGIN
            ROLLBACK;
		  END;
      -- ERROR LOG
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR LINE ' + CAST(ERROR_LINE() AS nvarchar(10));
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
