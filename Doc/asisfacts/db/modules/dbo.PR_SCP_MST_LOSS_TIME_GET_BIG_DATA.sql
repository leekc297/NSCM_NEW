
/*
 * Program ID   : PR_SCP_MST_LOSS_TIME_GET_BIG_DATA
 * Description  : Loss Time Big Data 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/30   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/11/12	hwyoon			BIG Data 갱신기준 - 전날 들어온 것
 *
 * EXEC PR_SCP_MST_LOSS_TIME_GET_BIG_DATA @yyyymm='201809'
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_LOSS_TIME_GET_BIG_DATA]
	@yyyymm			NVARCHAR(6)=NULL
AS

BEGIN

	SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	DECLARE @v_cnt_big	INT =0;
		SET @v_cnt_big = ISNULL((
								SELECT COUNT(*)
								FROM SCP_MST_LOSS_TIME_BIG_DAP WITH(NOLOCK)
								WHERE convert(varchar, CREATION_DATE ,112)=convert(varchar, dateadd(DAY, -1, GETDATE()) ,112)
							  ),0);
	
	PRINT @v_cnt_big;

	IF @v_cnt_big = 0
		return;

	IF(ISNULL(@yyyymm,'')='') SET @yyyymm=( SELECT 
											ISNULL(
												(SELECT MAX(YYYYMM)
												FROM SCP_MST_LOSS_TIME_BIG_DAP WITH(NOLOCK)
												WHERE convert(varchar, CREATION_DATE ,112)=convert(varchar, dateadd(DAY, -1, GETDATE()) ,112))
													, substring(convert(varchar, dateadd(month, -1, GETDATE()) ,112),1,6) ) )

	PRINT @yyyymm;


	
	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_LOSS_TIME_GET_BIG_DATA';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

		BEGIN TRY

			-- 시작 LOG
			SET @v_log_type = 'START';
			SET @v_log_message = '########## Start of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--HISTORY(TEMP) TABLE 데이터 삭제
			DELETE FROM SCP_MST_LOSS_TIME_BIG_TRANSFER_H
			WHERE YYYYMM=@yyyymm

			--HISTORY(TEMP) TABLE 데이터 삽입
			INSERT INTO SCP_MST_LOSS_TIME_BIG_TRANSFER_H
			(
				YYYYMM
				,DIVISION_ID
				,PLANT_SITE_ID
				,FACTORY_ID
				,OPERATION_ID
				,LINE_ID
				,LOSS_TIME_MIN
				,SETUP_LOSS_TIME_MIN
				,CREATED_BY		
				,CREATION_DATE
				,LAST_UPDATED_BY	
				,LAST_UPDATE_DATE
				,TRANSFER_FLAG
				,BIG_CREATION_DATE
			)
			SELECT A.YYYYMM
					,A.DIVISION_ID
					, S.SCM_SITE_ID AS PLANT_SITE_ID
					, A.FACTORY_ID
					, A.OPERATION_ID
					, A.LINE_ID
					, A.EQP_AVG_LOSS_MIN AS LOSS_TIME_MIN
					, A.MODELCHANGE_TIME_DAILY_TOTAL_MIN AS SETUP_LOSS_TIME_MIN
					, 'Admin' AS CREATED_BY
					, GETDATE() AS CREATION_DATE
					, 'Admin' AS LAST_UPDATED_BY
					, GETDATE() AS LAST_UPDATE_DATE
					, 'N' AS TRANSFER_FLAG
					, A.CREATION_DATE
			FROM SCP_MST_LOSS_TIME_BIG_DAP A WITH(NOLOCK)
			JOIN SCM_MST_LINE_SN B WITH(NOLOCK) ON B.DIVISION_ID = A.DIVISION_ID
												AND B.SITE_ID = A.SITE_ID
												AND B.PLANT_ID = A.PLANT_ID
												AND B.FACTORY_ID = A.FACTORY_ID
												AND B.OPERATION_ID = A.OPERATION_ID
												AND B.LINE_ID = A.LINE_ID
												AND B.ACTIVE_FLAG='Y'
			JOIN SCM_MST_SITE S(NOLOCK) ON B.COMPANY_ID = S.COMPANY_ID 
														AND B.DIVISION_ID = S.DIVISION_ID 
														AND B.PLANT_ID = S.PLANT_ID 
														AND B.SITE_ID = S.SITE_ID
														AND S.VALID_YN='Y'
			WHERE A.YYYYMM=@yyyymm


			-- LOSS TIME BIG 데이터 UPDATE
			UPDATE A
			SET A.LOSS_TIME_MIN=B.LOSS_TIME_MIN
				, A.SETUP_LOSS_TIME_MIN=B.SETUP_LOSS_TIME_MIN
				, A.LAST_UPDATED_BY='Admin'
				, A.LAST_UPDATE_DATE=GETDATE()
				, A.BIG_CREATION_DATE=B.BIG_CREATION_DATE
			FROM SCP_MST_LOSS_TIME_BIG A WITH(NOLOCK)
			JOIN SCP_MST_LOSS_TIME_BIG_TRANSFER_H B WITH(NOLOCK)
				ON B.YYYYMM = @yyyymm
				AND A.DIVISION_ID = B.DIVISION_ID
				AND A.PLANT_SITE_ID= B.PLANT_SITE_ID
				AND A.FACTORY_ID = B.FACTORY_ID
				AND A.OPERATION_ID = B.OPERATION_ID
				AND A.LINE_ID = B.LINE_ID
			;

			-- LOSS TIME BIG 데이터 INSERT
			INSERT INTO SCP_MST_LOSS_TIME_BIG
			(
				DIVISION_ID
				,PLANT_SITE_ID
				,FACTORY_ID
				,OPERATION_ID
				,LINE_ID
				,LOSS_TIME_MIN
				,SETUP_LOSS_TIME_MIN
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,BIG_CREATION_DATE
			)
			SELECT 
				A.DIVISION_ID
				, A.PLANT_SITE_ID
				, A.FACTORY_ID
				, A.OPERATION_ID
				, A.LINE_ID
				, A.LOSS_TIME_MIN
				, A.SETUP_LOSS_TIME_MIN
				, 'Admin'
				, GETDATE()
				, 'Admin'
				, GETDATE()
				, A.BIG_CREATION_DATE
			FROM SCP_MST_LOSS_TIME_BIG_TRANSFER_H A WITH(NOLOCK)
			WHERE A.YYYYMM=@yyyymm
			AND NOT EXISTS(
				SELECT 'Y' FROM SCP_MST_LOSS_TIME_BIG B
				WHERE B.DIVISION_ID=A.DIVISION_ID
				AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
				AND B.FACTORY_ID = A.FACTORY_ID
				AND B.OPERATION_ID = A.OPERATION_ID
				AND B.LINE_ID = A.LINE_ID
			)
			;

			-- HISTORY(TEMP) TABLE 전송플래그 Y 처리
			UPDATE SCP_MST_LOSS_TIME_BIG_TRANSFER_H
			SET TRANSFER_FLAG='Y'
			WHERE YYYYMM=@yyyymm
			AND TRANSFER_FLAG='N'
			;

			-- HISTORY(TEMP) TABLE 3개월전 데이터 삭제
			DELETE FROM SCP_MST_LOSS_TIME_BIG_TRANSFER_H
			WHERE YYYYMM<(SUBSTRING(CONVERT(CHAR(8), DATEADD(MM, -3, getdate()), 112),1,6))
			;

			SET @v_log_type = 'END';
			SET @v_log_message = '########## END of procedure ##########';
			SET @v_description = '';
			SET @d_event_date = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
		END TRY

		BEGIN CATCH
		  BEGIN
			INSERT INTO scm_sys_log_batch (program_name
										  ,log_type
										  ,log_count
										  ,log_message
										  ,description
										  ,event_date
										  ,creation_date
										  ,created_by
										  ,last_update_date
										  ,last_updated_by)
			VALUES (ERROR_PROCEDURE()
				   ,'ERROR'
				   ,NULL
				   ,ERROR_MESSAGE()
				   ,NULL
				   ,SYSDATETIME()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE()
				   ,SYSDATETIME()
				   ,ERROR_PROCEDURE());

			IF @@TRANCOUNT > 0
			  COMMIT WORK;
		  END;

		  -- error코드, errror 메시지 반환
		  SELECT 'F' AS result_code;
		  SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
		END CATCH;
	END







