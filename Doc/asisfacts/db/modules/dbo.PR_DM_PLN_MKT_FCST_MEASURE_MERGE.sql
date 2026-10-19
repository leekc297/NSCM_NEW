
/*
 * Program ID   : PR_DM_PLN_MKT_FCST_MEASURE_MERGE
 * Description  : MKT FCST Result Mapping 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 02. 02    DWOK/KHSONG      Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 *
*/


CREATE PROCEDURE [dbo].[PR_DM_PLN_MKT_FCST_MEASURE_MERGE]
AS

BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

	DECLARE @n_history_seq		INTEGER;
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_DM_PLN_MKT_FCST_MEASURE_MERGE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		-- 시작 LOG  (START)
		SET @v_log_type = 'START';
		SET @v_log_message = '########## Start of procedure ##########';
		SET @v_description = '';
		SET @d_event_date = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		SET @v_log_message = NULL      /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
		-- 시작 LOG  (END)

		-- 트랜잭션 (START)
		BEGIN TRANSACTION;

	--------------------------------------------------------------------------------------------	
		BEGIN TRY
	--------------------------------------------------------------------------------------------	

           BEGIN 
				DELETE
					FROM  dbo.DM_PLN_MKT_FCST
				WHERE 1=1
					AND DIVISION_ID IN (SELECT DIVISION_ID FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND PROJECT_CODE IN (SELECT PROJECT_CODE FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND ITEM_ID IN (SELECT ITEM_ID FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND DOM_EXP IN (SELECT DOM_EXP FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND FCST_TYPE IN (SELECT FCST_TYPE FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND INCOTERMS IN (SELECT INCOTERMS FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND MEASURE = 'F_new_edi_fcst_temp'
					AND PLANT_SITE_ID IN (SELECT PLANT_SITE_ID FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
					AND YYYYMMDD IN (SELECT YYYYMMDD FROM dbo.DM_PLN_MKT_FCST WITH(NOLOCK) WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'  )
           END

		BEGIN
		    INSERT  dbo.DM_PLN_MKT_FCST  
			SELECT 
					 DIVISION_ID
					,PROJECT_CODE
					,SCM_SITE_ID
					,ITEM_ID
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,'F_new_edi_fcst' AS MEASURE
					,PLANT_SITE_ID
					,YYYYMMDD
					,SUM(QTY) AS QTY
					,'20140001' as CREATED_BYCREATED_BY
					,sysdatetime() as CREATION_DATE
					,'20140001' as LAST_UPDATED_BY
					,sysdatetime() as LAST_UPDATE_DATE
					,null as ATTRIBUTE1
					,null as ATTRIBUTE2
					,null as ATTRIBUTE3
					,null as ATTRIBUTE4
					,null as ATTRIBUTE5
					,null as ATTRIBUTE6
					,null as ATTRIBUTE7
					,null as ATTRIBUTE8
					,null as ATTRIBUTE9
					,null as ATTRIBUTE10
			 FROM dbo.DM_PLN_MKT_FCST WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'
			 GROUP BY 		 
					 DIVISION_ID
					,PROJECT_CODE
					,SCM_SITE_ID
					,ITEM_ID
					,DOM_EXP
					,FCST_TYPE
					,INCOTERMS
					,MEASURE
					,PLANT_SITE_ID
					,YYYYMMDD 
		END

		BEGIN
			UPDATE dbo.DM_PLN_MKT_FCST  SET ATTRIBUTE1 = 'MERGE_COMPLETED'
			   WHERE ATTRIBUTE1 = 'UPLOAD_COMPLETED'
		END

    -- IF @@TRANCOUNT > 0 
  	-- 트랜잭션 (COMMIT)
        COMMIT WORK;

	--------------------------------------------------------------------------------------------	
		END TRY
	--------------------------------------------------------------------------------------------	

	--------------------------------------------------------------	
    BEGIN CATCH
	--------------------------------------------------------------	
	--[C20200909-000203] LOG 표준화 적용
	-- 트랜잭션 (END)
	ROLLBACK TRANSACTION;
      -- ROLLBACK
      -- ERROR LOG VALUE SAVE
      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();

	  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();  /*-- 에러메시지 DISPLAY --*/
	  
		--[C20200909-000203] LOG 표준화 적용
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		

	--------------------------------------------------------------	
    END CATCH;
	--------------------------------------------------------------	

	-- 수행결과 성공여부 DISPLAY
     IF @v_log_message IS NULL
	  SELECT 'success'
	;

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();

	-- ERROR LOG DB INSERT (로직의 TRANSACTION 종료이후수행 : 충돌방지)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

  END;
