/*
 * Program ID   : PR_SCP_MST_TACT_TIME_GET_BIG_DATA
 * Description  : Tact Time Big Data 생성
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/10/30   hwyoon			Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/10/31	hwyoon			Actual Output외 4개 항목 계산식 수정
 * 2018/11/09	hwyoon			EFFECTIVE_DATA_COUNT(유효데이터 수)의 경우 실적과 무관하므로 계산식 제외
 * 2018/11/12	hwyoon			BIG Data 갱신기준 - 전날 들어온 것
 * 2018/11/16	hwyoon			TACT_TIME_EXCEPT_LOSS 필드 추가
 * 2019/03/06	hwyoon			[CSR:] I/F 데이타 중 ANAL_TYPE이 SUCCESS, CHECK만 필터링
 *
 * EXEC PR_SCP_MST_TACT_TIME_GET_BIG_DATA @yyyymm='201809'
 */
CREATE PROCEDURE [dbo].[PR_SCP_MST_TACT_TIME_GET_BIG_DATA]
	@yyyymm			NVARCHAR(6)=NULL
AS

BEGIN

	SET NOCOUNT ON;
	--SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


	DECLARE @v_cnt_big	INT =0;
		SET @v_cnt_big = ISNULL((
								SELECT COUNT(*)
								FROM SCP_MST_TACT_TIME_BIG_DAP WITH(NOLOCK)
								WHERE convert(varchar, CREATION_DATE ,112)=convert(varchar, dateadd(DAY, -1, GETDATE()) ,112)
							  ),0);
	
	PRINT @v_cnt_big;

	IF @v_cnt_big = 0
		return;

	IF(ISNULL(@yyyymm,'')='') SET @yyyymm=( SELECT 
											ISNULL(
												(SELECT MAX(YYYYMM)
												FROM SCP_MST_TACT_TIME_BIG_DAP WITH(NOLOCK)
												WHERE convert(varchar, CREATION_DATE ,112)=convert(varchar, dateadd(DAY, -1, GETDATE()) ,112))
													, substring(convert(varchar, dateadd(month, -1, GETDATE()) ,112),1,6) ) )

	PRINT @yyyymm;

	-- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_TACT_TIME_GET_BIG_DATA';
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
			DELETE FROM SCP_MST_TACT_TIME_BIG_TRANSFER_H
			WHERE YYYYMM=@yyyymm

			--HISTORY(TEMP) TABLE 데이터 삽입
			INSERT INTO SCP_MST_TACT_TIME_BIG_TRANSFER_H
			(
				 YYYYMM
				,DIVISION_ID		,PLANT_ID
				,PLANT_SITE_ID		,ITEM_ID
				,OPERATION_ID		,LINE_ID
				,TACT_TIME			,ACTUAL_OUTPUT
				,ACTUAL_CAPACITY	,FROM_ACTUAL_CAPACITY
				,TO_ACTUAL_CAPACITY	,EFFECTIVE_DATA_COUNT
				,CREATED_BY			,CREATION_DATE
				,LAST_UPDATED_BY	,LAST_UPDATE_DATE
				,ATTRIBUTE1			,PLANT_MST_YN
				,TRANSFER_FLAG		,BIG_CREATION_DATE
				,TACT_TIME_EXCEPT_LOSS
			)
			SELECT  @yyyymm AS YYYYMM
					, A.DIVISION_ID
					, A.PLANT_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID
					, CASE WHEN A.OPERATION_GROUP<>'E' THEN convert(numeric(20,10), (1440*60)/ convert(numeric(20,10), ACT_CAPA)) 
						   WHEN A.lane_qty=0 THEN 0
						   ELSE convert(numeric(20,10), (1440*60) / convert(numeric(20,10), ACT_CAPA) / convert(numeric(20,10), lane_qty)) 
					  END TACT_TIME
					, CASE WHEN A.OPERATION_GROUP<>'E' THEN A.PROD_QTY
						   WHEN A.lane_qty=0 THEN 0
						   ELSE convert(numeric(20,10), convert(numeric(20,10), A.PROD_QTY) * convert(numeric(20,10), A.lane_qty)) 
					  END ACTUAL_OUTPUT
					, CASE WHEN A.OPERATION_GROUP<>'E' THEN A.ACT_CAPA
						   WHEN A.lane_qty=0 THEN 0
						   ELSE convert(numeric(20,10), convert(numeric(20,10), A.ACT_CAPA) * convert(numeric(20,10), A.lane_qty)) 
					  END ACTUAL_CAPACITY
					, CASE WHEN A.OPERATION_GROUP<>'E' THEN A.ACT_CAPA_LOWER
						   WHEN A.lane_qty=0 THEN 0
						   ELSE convert(numeric(20,10), convert(numeric(20,10), A.ACT_CAPA_LOWER) * convert(numeric(20,10), A.lane_qty)) 
					  END FROM_ACTUAL_CAPACITY
					, CASE WHEN A.OPERATION_GROUP<>'E' THEN A.ACT_CAPA_UPPER
						   WHEN A.lane_qty=0 THEN 0
						   ELSE convert(numeric(20,10), convert(numeric(20,10), A.ACT_CAPA_UPPER) * convert(numeric(20,10), A.lane_qty)) 
					  END TO_ACTUAL_CAPACITY
					, A.EFF_ANAL_DATA_COUNT AS EFFECTIVE_DATA_COUNT
					--, A.PROD_QTY AS ACTUAL_OUTPUT
					--, A.ACT_CAPA AS ACTUAL_CAPACITY
					--, A.ACT_CAPA_LOWER AS FROM_ACTUAL_CAPACITY
					--, A.ACT_CAPA_UPPER AS TO_ACTUAL_CAPACITY
					--, A.EFF_ANAL_DATA_COUNT AS EFFECTIVE_DATA_COUNT
					, 'Admin' AS CREATED_BY
					, GETDATE() AS CREATION_DATE
					, 'Admin' AS LAST_UPDATED_BY
					, GETDATE() AS LAST_UPDATE_DATE
					, CASE WHEN A.OPERATION_GROUP<>'E' THEN NULL
						   WHEN A.lane_qty<>0 THEN NULL
						   ELSE lane_qty_E
					  END ATTRIBUTE1
					, ISNULL((SELECT 'Y' FROM SCM_MST_SITE B WITH(NOLOCK) WHERE B.DIVISION_ID = A.DIVISION_ID AND B.SCM_SITE_ID = A.PLANT_SITE_ID AND B.VALID_YN='Y' AND B.SITE_TYPE='PLANT'),'N') AS PLANT_MST_YN
					--, A.lane_qty
					--, A.lane_qty_E
					,'N' AS TRANSFER_FLAG
					, A.CREATION_DATE AS BIG_CREATION_DATE
					, A.TACT_TIME AS TACT_TIME_EXCEPT_LOSS
			FROM (
			SELECT A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.OPERATION_GROUP
					, SUM(A.PROD_QTY) PROD_QTY
					, SUM(A.ACT_CAPA) ACT_CAPA
					, SUM(A.ACT_CAPA_LOWER) ACT_CAPA_LOWER
					, SUM(A.ACT_CAPA_UPPER) ACT_CAPA_UPPER
					, SUM(A.EFF_ANAL_DATA_COUNT) EFF_ANAL_DATA_COUNT
					, ISNULL(( SELECT MAX(ISNULL(B.lane_qty, 0))
						   FROM SCM_MST_ITEM_LINE_ASSIGN_SN B WITH(NOLOCK)
						   WHERE B.DIVISION_ID = A.DIVISION_ID
							AND B.OPERATION_ID = A.OPERATION_ID
							AND B.ITEM_ID = A.ITEM_ID
							AND B.LINE_ID = A.LINE_ID
							AND B.MONTH = @yyyymm
							AND B.ACTIVE_FLAG    ='Y'
							AND B.PRIORITY       NOT IN ( 0, 9 )
					   ),0) lane_qty
					 , ISNULL(( SELECT MAX(ISNULL(B.lane_qty, 0))
						   FROM SCM_MST_ITEM_LINE_ASSIGN_SN B WITH(NOLOCK)
						   WHERE B.DIVISION_ID = A.DIVISION_ID
							AND B.OPERATION_ID = A.OPERATION_ID
							AND B.ITEM_ID = A.ITEM_ID
							AND B.LINE_ID = A.LINE_ID
							AND B.MONTH = @yyyymm
							AND B.ACTIVE_FLAG    ='Y'
							AND B.PRIORITY       NOT IN ( 0, 9 )
					   ),1) lane_qty_E
					 ,  MAX(A.CREATION_DATE) AS CREATION_DATE
					 , SUM(A.TACT_TIME) TACT_TIME
			FROM (
			  SELECT A.DIVISION_ID
					 , A.SITE_ID
					 , A.PLANT_ID
					 , A.ITEM_ID
					 , A.OPERATION_ID
					 , A.LINE_ID
					 , A.EQUIPMENT_ID
					 , ISNULL(A.PROD_QTY,0) PROD_QTY
					 , ISNULL(A.ACT_CAPA,0) ACT_CAPA
					 , ISNULL(A.ACT_CAPA_LOWER,0) ACT_CAPA_LOWER
					 , ISNULL(A.ACT_CAPA_UPPER,0) ACT_CAPA_UPPER
					 , ISNULL(A.EFF_ANAL_DATA_COUNT,0) EFF_ANAL_DATA_COUNT
					 , (SELECT TOP 1 B.SCP_OPERATION_GROUP 
						FROM SCM_MST_ITEM_SN B
						WHERE B.DIVISION_ID=A.DIVISION_ID
						AND B.ITEM_ID=A.ITEM_ID) OPERATION_GROUP
					 , A.PLANT_ID + '-'+(SELECT TOP 1 B.SCP_OPERATION_GROUP 
						FROM SCM_MST_ITEM_SN B
						WHERE B.DIVISION_ID=A.DIVISION_ID
						AND B.ITEM_ID=A.ITEM_ID) PLANT_SITE_ID
					 , A.CREATION_DATE
					 , A.TACT_TIME
			  --FROM [10.34.221.78,7433].[LGCE_SCMDEV].[dbo].[SCP_MST_TACT_TIME_BIG_DAP] A WITH(NOLOCK) -- 운영
			  FROM SCP_MST_TACT_TIME_BIG_DAP A WITH(NOLOCK) -- 개발
			  WHERE A.YYYYMM=@yyyymm
			  AND ISNULL(ANAL_TYPE, '') IN ('SUCCESS','CHECK') 
			) A 
			WHERE 1=1
			AND A.ACT_CAPA>0
			GROUP BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.OPERATION_GROUP
			) A

			-- TACT TIME BIG 데이터 UPDATE
			UPDATE A
			SET A.TACT_TIME=B.TACT_TIME
				, A.ACTUAL_OUTPUT=B.ACTUAL_OUTPUT
				, A.ACTUAL_CAPACITY=B.ACTUAL_CAPACITY
				, A.FROM_ACTUAL_CAPACITY=B.FROM_ACTUAL_CAPACITY
				, A.TO_ACTUAL_CAPACITY=B.TO_ACTUAL_CAPACITY
				, A.EFFECTIVE_DATA_COUNT=B.EFFECTIVE_DATA_COUNT
				, A.LAST_UPDATED_BY='Admin'
				, A.LAST_UPDATE_DATE=GETDATE()
				, A.ATTRIBUTE1=B.ATTRIBUTE1 
				, A.BIG_CREATION_DATE=B.BIG_CREATION_DATE
				, A.TACT_TIME_EXCEPT_LOSS=B.TACT_TIME_EXCEPT_LOSS
			FROM SCP_MST_TACT_TIME_BIG A WITH(NOLOCK)
			JOIN SCP_MST_TACT_TIME_BIG_TRANSFER_H B WITH(NOLOCK)
			  ON B.YYYYMM = @yyyymm
			  AND A.DIVISION_ID = B.DIVISION_ID
			  AND A.PLANT_ID = B.PLANT_ID
			  AND A.PLANT_SITE_ID= B.PLANT_SITE_ID
			  AND A.ITEM_ID = B.ITEM_ID
			  AND A.OPERATION_ID = B.OPERATION_ID
			  AND A.LINE_ID = B.LINE_ID
			;

			-- TACT TIME BIG 데이터 INSERT
			INSERT INTO SCP_MST_TACT_TIME_BIG
			(
				DIVISION_ID
				,PLANT_ID
				,PLANT_SITE_ID
				,ITEM_ID
				,OPERATION_ID
				,LINE_ID
				,TACT_TIME
				,ACTUAL_OUTPUT
				,ACTUAL_CAPACITY
				,FROM_ACTUAL_CAPACITY
				,TO_ACTUAL_CAPACITY
				,EFFECTIVE_DATA_COUNT
				,CREATED_BY
				,CREATION_DATE
				,LAST_UPDATED_BY
				,LAST_UPDATE_DATE
				,ATTRIBUTE1
				,BIG_CREATION_DATE
				,TACT_TIME_EXCEPT_LOSS
			)
			SELECT 
				A.DIVISION_ID
				, A.PLANT_ID
				, A.PLANT_SITE_ID
				, A.ITEM_ID
				, A.OPERATION_ID
				, A.LINE_ID
				, A.TACT_TIME
				, A.ACTUAL_OUTPUT
				, A.ACTUAL_CAPACITY
				, A.FROM_ACTUAL_CAPACITY
				, A.TO_ACTUAL_CAPACITY
				, A.EFFECTIVE_DATA_COUNT
				, 'Admin'
				, GETDATE()
				, 'Admin'
				, GETDATE()
				, A.ATTRIBUTE1 
				, A.BIG_CREATION_DATE
				, A.TACT_TIME_EXCEPT_LOSS
			FROM SCP_MST_TACT_TIME_BIG_TRANSFER_H A WITH(NOLOCK)
			WHERE A.YYYYMM=@yyyymm
			AND NOT EXISTS(
				SELECT 'Y' FROM SCP_MST_TACT_TIME_BIG B
				WHERE B.DIVISION_ID=A.DIVISION_ID
				AND B.PLANT_ID = A.PLANT_ID
				AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
				AND B.ITEM_ID = A.ITEM_ID
				AND B.OPERATION_ID = A.OPERATION_ID
				AND B.LINE_ID = A.LINE_ID
			)
			;

			-- HISTORY(TEMP) TABLE 전송플래그 Y 처리
			UPDATE SCP_MST_TACT_TIME_BIG_TRANSFER_H
			SET TRANSFER_FLAG='Y'
			WHERE YYYYMM=@yyyymm
			AND TRANSFER_FLAG='N'
			;

			-- HISTORY(TEMP) TABLE 3개월전 데이터 삭제
			DELETE FROM SCP_MST_TACT_TIME_BIG_TRANSFER_H
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






