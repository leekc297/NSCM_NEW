

/*
 * Program ID   : PR_SCM_PLN_MKT_FCST_ESS_ELEC_TRAN
 * Description  : ESS 전극소요관련 매출 INSERT UI 용
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018. 4. 30    Kim Jaejung      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 
 */

CREATE PROCEDURE [dbo].[PR_SCM_PLN_MKT_FCST_ESS_ELEC_TRAN]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_batch_user   NVARCHAR(150) = 'scm_batch';
	DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_PLN_MKT_FCST_ESS_ELEC_TRAN';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
	DECLARE @n_history_seq	BIGINT;
	DECLARE @v_ifseqno      NVARCHAR(50);
	DECLARE @now            datetime;
	DECLARE @next_week_monday_00 datetime
	DECLARE @this_week_monday_00 datetime
	DECLARE @v_count		BIGINT;

	-- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY
      BEGIN
	   
		 SET @now = GETDATE();
		 IF 1 = DATEPART(WEEKDAY, @now)
		   SET @this_week_monday_00 = DATEADD(DAY, DATEDIFF(DAY, 0, DATEADD(DAY, -6, @now)), 0)
		 ELSE
		   SET @this_week_monday_00 = DATEADD(DAY, DATEDIFF(DAY, 0, DATEADD(DAY, DATEPART(WEEKDAY, @now) * -1 + 2, @now)), 0)
		 SET @next_week_monday_00 = DATEADD(DAY, 7, @this_week_monday_00)

		 SET @this_week_monday_00 = CONVERT(CHAR(8),@this_week_monday_00,112) -- 오늘 기준으로 그 주차 월요일
		 SET @next_week_monday_00 = CONVERT(CHAR(8),@next_week_monday_00,112) -- 오늘 기준으로 다음주 월요일

		-- TEMP table 삭제
		IF OBJECT_ID('dbo.dm_pln_mkt_fcst_temp$') IS NOT NULL DROP TABLE dm_pln_mkt_fcst_temp$

		-- TEMP table 생성
		SELECT  si.division_id
			   ,si.project_code
			   ,si.scm_site_id
			   ,si.item_id
			   ,'E' dom_exp
			   ,'MPS' fcst_type
			   ,md2.segment4 incoterms
			   ,'MKT_FCST' measure
			   ,md2.segment3 plant_site_id
			   ,rv.yyyymmdd
			   ,rv.dm_fcst_qty
		INTO   dm_pln_mkt_fcst_temp$
		FROM   scp_pln_ess_elec_req_v rv       WITH (NOLOCK)
		JOIN   scm_mst_site ms                 WITH (NOLOCK)
		ON     rv.division_id         = ms.division_id
		AND    rv.to_site             = ms.scm_site_id
		JOIN   scm_adm_lookup_master_detail md1 
		ON     ms.company_id          = md1.segment2				
		JOIN   scm_mst_site_item si             WITH (NOLOCK)
		ON     md1.segment1           = si.division_id
		AND    md1.segment3           = si.scm_site_id  
		AND    rv.item_id             = si.item_id				
		JOIN   scm_adm_lookup_master_detail md2 WITH (NOLOCK)
		ON     rv.nick_name           = md2.segment1
		AND    si.scm_site_id         = md2.segment2
		WHERE  rv.division_id         = '82'
		AND    rv.plan_start_yyyymmdd = @this_week_monday_00
		AND    rv.yyyymmdd            >= @next_week_monday_00
		AND    rv.plan_type           = 'FN'
		AND    md1.lookup_type        = 'INTERNAL_BIZ_SITE'
		AND    md1.segment1           = '81'
		AND    md1.valid_yn           = 'Y'
		AND    si.division_id         = '81'
		AND    si.valid_yn            = 'Y'
		AND    ms.valid_yn            = 'Y'
		AND    md2.lookup_type        = 'ESS_ELECTRODE_SITE'
		AND    md2.valid_yn           = 'Y';

		/*
		SELECT @v_count = COUNT(*) FROM dm_pln_mkt_fcst_temp$;

		IF (@v_count > 0)
			BEGIN*/

			INSERT INTO dm_pln_mkt_fcst_h (
						 division_id
						,project_code
						,scm_site_id
						,item_id
						,dom_exp
						,fcst_type
						,incoterms
						,measure
						,plant_site_id
						,yyyymmdd
						,qty
						,created_by
						,creation_date
						,last_updated_by
						,last_update_date
						,history_seq	
				)
				SELECT A.*
				      ,NEXT VALUE FOR SEQ1_DM_PLN_MKT_FCST_H
				FROM (
					SELECT A.*,B.created_by,B.creation_date,B.last_updated_by,B.last_update_date 
					FROM (
						SELECT   division_id
								,project_code
								,scm_site_id
								,item_id
								,dom_exp
								,fcst_type
								,incoterms
								,measure
								,plant_site_id
								,yyyymmdd
								,qty
						FROM dm_pln_mkt_fcst
						WHERE  division_id = '81'
						AND    measure = 'MKT_FCST'
						AND    scm_site_id IN (SELECT DISTINCT segment2 
											   FROM scm_adm_lookup_master_detail WITH(NOLOCK)
											   WHERE lookup_type = 'ESS_ELECTRODE_SITE'
											   AND   valid_yn    = 'Y')
						AND   dbo.FN_GET_ITEM_OPERATION_GROUP(DIVISION_ID,ITEM_ID) = 'E'
						AND   yyyymmdd >= @next_week_monday_00
						EXCEPT
						SELECT * 
						FROM   dm_pln_mkt_fcst_temp$ WITH(NOLOCK)) A
					    INNER JOIN dm_pln_mkt_fcst B WITH(NOLOCK) 
				        ON     A.division_id       =  B.division_id
				        AND    A.project_code	    =  B.project_code
				        AND    A.scm_site_id		=  B.scm_site_id
					    AND    A.item_id		    =  B.item_id
				        AND    A.dom_exp			=  B.dom_exp
					    AND    A.fcst_type			=  B.fcst_type
				        AND    A.incoterms			=  B.incoterms
					    AND    A.measure			=  B.measure
					    AND    A.plant_site_id		=  B.plant_site_id
				        AND    A.qty				=  B.qty
					) A;

				DELETE FROM dm_pln_mkt_fcst
				WHERE  division_id = '81'
				AND    measure = 'MKT_FCST'
				AND    scm_site_id IN (SELECT DISTINCT segment2 
				                       FROM   scm_adm_lookup_master_detail WITH(NOLOCK)
									   WHERE  lookup_type = 'ESS_ELECTRODE_SITE'
									   AND    valid_yn    = 'Y')
				AND   dbo.FN_GET_ITEM_OPERATION_GROUP(DIVISION_ID,ITEM_ID) = 'E'
				AND   yyyymmdd >= @next_week_monday_00
				;
				
				INSERT INTO dm_pln_mkt_fcst (
						 division_id
						,project_code
						,scm_site_id
						,item_id
						,dom_exp
						,fcst_type
						,incoterms
						,measure
						,plant_site_id
						,yyyymmdd
						,qty
						,created_by
						,creation_date
						,last_updated_by
						,last_update_date
				)
				SELECT  division_id
				       ,project_code
					   ,scm_site_id
					   ,item_id
					   ,dom_exp
					   ,fcst_type
					   ,incoterms
					   ,measure
					   ,plant_site_id
					   ,yyyymmdd
					   ,dm_fcst_qty
					   ,@v_batch_user
					   ,GETDATE()
					   ,@v_batch_user
					   ,GETDATE()
				FROM   dm_pln_mkt_fcst_temp$ WITH(NOLOCK)
				;

			--END;

			DROP TABLE dm_pln_mkt_fcst_temp$;

      END;
    END TRY

    BEGIN CATCH
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

