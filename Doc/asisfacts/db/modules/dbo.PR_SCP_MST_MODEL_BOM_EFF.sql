/*
 * Program ID   : PR_SCP_MST_MODEL_BOM_EFF
 * Description  : 대체 MODEL BOM 생성 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.04.01   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
 *							- SCP 대치BOM 정보를 적용한 MODEL BOM 생성
 * 2021.04.30   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 상위 정보를 찾을 때 날짜를 고려하도록 수정
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_MODEL_BOM_EFF]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_MODEL_BOM_EFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_division_id  NVARCHAR(30);
	DECLARE @v_history_seq	BIGINT;

	DECLARE @N_LOOP_COUNT    INTEGER = 0;
	DECLARE @N_MAX_LEVEL     INTEGER = 0;

    -- 시작 LOG
    SET @v_log_type    = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '[PR_SCP_MST_MODEL_BOM_EFF]';
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY

		/******************************************************************
		* 모델 BOM 동기화
		******************************************************************/
		BEGIN
			BEGIN TRAN		--Transaction 시작

			--인덱스 Rebuild 수행
			ALTER INDEX ALL ON DBO.SCM_MST_MODEL_BOM_EFFECTIVE REBUILD WITH (PAD_INDEX = ON, FILLFACTOR = 90);

			--DELETE(사라진 BOM 삭제)
			DELETE DBO.SCM_MST_MODEL_BOM_EFFECTIVE
			FROM DBO.SCM_MST_MODEL_BOM_EFFECTIVE AS A
			WHERE 1=1
			AND NOT EXISTS (
					SELECT 1
					FROM DBO.SCM_MST_BOM_EFFECTIVE_SN AS B WITH(NOLOCK)
					WHERE 1=1
					AND A.COMPANY_ID = B.COMPANY_ID
					AND A.DIVISION_ID = B.DIVISION_ID
					AND A.SITE_ID = B.SITE_ID
					AND A.PLANT_ID = B.PLANT_ID
					AND A.MODEL_ID = B.MODEL_ID 
					AND A.CONCATENATE_ITEM = B.CONCATENATE_ITEM
					AND A.EFF_START_DATE = B.EFF_START_DATE
				);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_MODEL_BOM_EFFECTIVE'
			SET @v_description = 'DELETE('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--DELETE(최신BOM 모델 삭제)
			DELETE DBO.SCM_MST_MODEL_BOM_EFFECTIVE
			FROM DBO.SCM_MST_MODEL_BOM_EFFECTIVE AS A
			WHERE 1=1
			AND EXISTS (
					SELECT 1
					FROM (
					SELECT DISTINCT A.MODEL_ID
					FROM DBO.SCM_MST_BOM_EFFECTIVE_SN AS A WITH(NOLOCK)
					WHERE 1=1
					AND EXISTS (
							SELECT 1
							FROM DBO.SCM_MST_BOM_ENG_SN AS B WITH(NOLOCK)
							WHERE 1=1
							--AND A.COMPANY_ID = B.COMPANY_ID
							--AND A.DIVISION_ID = B.DIVISION_ID
							--AND A.SITE_ID = B.SITE_ID
							--AND A.PLANT_ID = B.PLANT_ID
							AND A.CHILD_COMPANY_ID = B.COMPANY_ID
							AND A.CHILD_DIVISION_ID = B.DIVISION_ID
							AND A.CHILD_SITE_ID = B.SITE_ID
							AND A.CHILD_PLANT_ID = B.PLANT_ID
							AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
							AND B.KEY_DATE >= CONVERT(CHAR(8),DATEADD(DAY,-1,GETDATE()),112)
						)
					) AS B
					WHERE 1=1
					AND B.MODEL_ID = A.MODEL_ID
				);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_MODEL_BOM_EFFECTIVE'
			SET @v_description = @v_description + '/DELETE('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
							   
			--INSERT(신규 및 최신BOM 추가)
			INSERT DBO.SCM_MST_MODEL_BOM_EFFECTIVE (
				COMPANY_ID,
				DIVISION_ID,
				SITE_ID,
				PLANT_ID,
				MODEL_ID,
				PARENT_ITEM_ID,
				CHILD_ITEM_ID,
				CHILD_QTY,
				CHILD_UOM,
				ACCUMULATED_CHILD_QTY,
				CONCATENATE_ITEM,
				SORT_ORDER,
				LEAF_LEVEL,
				NLEVEL,
				CHILD_COMPANY_ID,
				CHILD_DIVISION_ID,
				CHILD_SITE_ID,
				CHILD_PLANT_ID,
				ALT_ID,
				ALT_PRIORITY,
				ALT_RATE,
				EFF_START_DATE,
				EFF_END_DATE,
				INSERT_ID,
				INSERT_TIME,
				UPDATE_ID,
				UPDATE_TIME,
				ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,
				CONCAT_ALT_PRIORITY,
				COPY_ALT_PRIORITY)
			SELECT 
				COMPANY_ID,
				DIVISION_ID,
				SITE_ID,
				PLANT_ID,
				MODEL_ID,
				PARENT_ITEM_ID,
				CHILD_ITEM_ID,
				CHILD_QTY,
				CHILD_UOM,
				ACCUMULATED_CHILD_QTY,
				CONCATENATE_ITEM,
				SORT_ORDER,
				LEAF_LEVEL,
				NLEVEL,
				CHILD_COMPANY_ID,
				CHILD_DIVISION_ID,
				CHILD_SITE_ID,
				CHILD_PLANT_ID,
				ALT_ID,
				ALT_PRIORITY,
				ALT_RATE,
				EFF_START_DATE,
				EFF_END_DATE,
				INSERT_ID,
				INSERT_TIME,
				UPDATE_ID,
				UPDATE_TIME,
				ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,
				CONCAT_ALT_PRIORITY,
				ALT_PRIORITY AS COPY_ALT_PRIORITY
			FROM DBO.SCM_MST_BOM_EFFECTIVE_SN A WITH(NOLOCK)
			WHERE 1=1
			--AND A.EFF_END_DATE > GETDATE()	--과거데이터 관리대상에서 제외
			AND CAST(A.EFF_END_DATE AS DATE) > DATEADD(dd, -7, CAST(dbo.fn_next_day(GETDATE(), 'MON') AS DATE)) --월요일 기준
			AND NOT EXISTS (	--신규 생성된 경우
					SELECT 1
					FROM DBO.SCM_MST_MODEL_BOM_EFFECTIVE AS X WITH(NOLOCK)
					WHERE 1=1
					AND X.COMPANY_ID = A.COMPANY_ID
					AND X.DIVISION_ID = A.DIVISION_ID
					AND X.SITE_ID = A.SITE_ID
					AND X.PLANT_ID = A.PLANT_ID
					AND X.MODEL_ID = A.MODEL_ID
					AND X.CONCATENATE_ITEM = A.CONCATENATE_ITEM
					AND X.EFF_START_DATE = A.EFF_START_DATE
				)
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_MODEL_BOM_EFFECTIVE'
			SET @v_description = @v_description + '/INSERT('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			COMMIT TRAN		--Transaction 종료

			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_MODEL_BOM_EFFECTIVE'
			SET @v_description = N'STEP_1:모델 BOM 동기화:'+@v_description;
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

		END;
			
		/******************************************************************
		* 대치BOM 모델별 ALT_PRIORITY 생성
		******************************************************************/
		BEGIN

			IF OBJECT_ID('tempdb..#SCM_MST_MODEL_BOM_EFFECTIVE') IS NOT NULL
			BEGIN 
				DROP TABLE  #SCM_MST_MODEL_BOM_EFFECTIVE;
			END;
	  
			--대치 BOM 관리 대상 모델만 생성
			SELECT 
				A.COMPANY_ID,
				A.DIVISION_ID,
				A.SITE_ID,
				A.PLANT_ID,
				A.MODEL_ID,
				A.PARENT_ITEM_ID,
				A.CHILD_ITEM_ID,
				A.CHILD_QTY,
				A.CHILD_UOM,
				A.ACCUMULATED_CHILD_QTY,
				A.CONCATENATE_ITEM,
				A.SORT_ORDER,
				A.LEAF_LEVEL,
				A.NLEVEL,
				A.CHILD_COMPANY_ID,
				A.CHILD_DIVISION_ID,
				A.CHILD_SITE_ID,
				A.CHILD_PLANT_ID,
				A.ALT_ID,
				A.ALT_PRIORITY,
				A.ALT_RATE,
				A.EFF_START_DATE,
				A.EFF_END_DATE,
				A.INSERT_ID,
				A.INSERT_TIME,
				A.UPDATE_ID,
				A.UPDATE_TIME,
				A.ATTRIBUTE1,A.ATTRIBUTE2,A.ATTRIBUTE3,A.ATTRIBUTE4,A.ATTRIBUTE5,A.ATTRIBUTE6,A.ATTRIBUTE7,A.ATTRIBUTE8,A.ATTRIBUTE9,A.ATTRIBUTE10,A.ATTRIBUTE11,A.ATTRIBUTE12,A.ATTRIBUTE13,A.ATTRIBUTE14,A.ATTRIBUTE15,
				A.CONCAT_ALT_PRIORITY,
				A.ALT_PRIORITY AS COPY_ALT_PRIORITY,	--Y or NULL
				C.SCP_PLAN_YN,		--하위 레벨까지 생성하면 안됨...!!!, SCP_PLAN_YN IS NULL일 때 관리대상 아님으로 판단함
				CAST(NULL AS VARCHAR(30)) AS ENG_ALT_ID,
				CAST(NULL AS INT) AS ENG_ALT_PRIORITY,

				IIF(CAST(SUBSTRING(A.CONCAT_ALT_PRIORITY,LEN(A.CONCAT_ALT_PRIORITY)-1,100) AS INT)=0,CAST(NULL AS VARCHAR(30)),A.ALT_ID) AS ORG_ALT_ID,


				IIF(CAST(SUBSTRING(A.CONCAT_ALT_PRIORITY,LEN(A.CONCAT_ALT_PRIORITY)-1,100) AS INT)=0,
				    CAST(NULL AS INT),
					CAST(SUBSTRING(A.CONCAT_ALT_PRIORITY,LEN(A.CONCAT_ALT_PRIORITY)-1,100) AS INT)) 
				AS ORG_ALT_PRIORITY,

				CAST(NULL AS INT) AS CHILD_SEQ
			INTO #SCM_MST_MODEL_BOM_EFFECTIVE
			FROM DBO.SCM_MST_MODEL_BOM_EFFECTIVE AS A WITH(NOLOCK)
					LEFT OUTER JOIN DBO.SCM_MST_ALTER_BOM_V AS C WITH(NOLOCK)
						--ON  A.DIVISION_ID = C.DIVISION_ID 
						--AND A.SITE_ID = C.SITE_ID
						--AND A.PLANT_ID = C.PLANT_ID
						ON  A.CHILD_DIVISION_ID = C.DIVISION_ID 
						AND A.CHILD_SITE_ID = C.SITE_ID
						AND A.CHILD_PLANT_ID = C.PLANT_ID
						AND A.PARENT_ITEM_ID = C.PARENT_ITEM_ID
						AND A.CHILD_ITEM_ID = C.CHILD_ITEM_ID
			WHERE 1=1
			--AND A.EFF_END_DATE > GETDATE()	--과거데이터 관리대상에서 제외, 주석처리하면 안됨..........!!!!!!!
			AND CAST(A.EFF_END_DATE AS DATE) > DATEADD(dd, -7, CAST(dbo.fn_next_day(GETDATE(), 'MON') AS DATE)) --월요일 기준
			--AND A.MODEL_ID = 'AMJLRX590-B1'
			AND EXISTS (
					SELECT 1
					FROM SCM_MST_ALTER_BOM_MODEL AS X WITH(NOLOCK)
					WHERE 1=1
					AND X.DIVISION_ID = A.DIVISION_ID
					AND X.SITE_ID = A.SITE_ID
					AND X.PLANT_ID = A.PLANT_ID
					AND X.MODEL_ID = A.MODEL_ID
				)
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = '#SCM_MST_MODEL_BOM_EFFECTIVE';
			SET @v_description = 'STEP_2_1:CREATE';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


			--대치BOM 판단 기준으로 사용할 대치BOM 정보 생성(SCM_MST_ALTER_BOM_ALL_V에서는 판단할 수 없음...!!!)
			UPDATE A
			SET ENG_ALT_ID = B.ALT_ID
			  , ENG_ALT_PRIORITY = B.ALT_PRIORITY
			FROM #SCM_MST_MODEL_BOM_EFFECTIVE A WITH(NOLOCK)
					INNER JOIN (
								SELECT *
								FROM
								(
									SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID, B.CHILD_ITEM_ID, B.ALT_ID, B.ALT_PRIORITY
										 , ROW_NUMBER() OVER(PARTITION BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID, B.CHILD_ITEM_ID 
															 ORDER BY B.BOM_VERSION_ID DESC, B.KEY_DATE DESC) 
										   AS MAX_KEY_DATE
									FROM DBO.SCM_MST_BOM_ENG_SN AS B WITH(NOLOCK)
									WHERE 1=1
									--AND B.EFF_END_DATE > GETDATE()	--과거데이터 관리대상에서 제외, 주석처리하면 안됨..........!!!!!!!
									AND CAST(B.EFF_END_DATE AS DATE) > DATEADD(dd, -7, CAST(dbo.fn_next_day(GETDATE(), 'MON') AS DATE)) --월요일 기준
								) AS A
								WHERE MAX_KEY_DATE = 1) AS B
					--ON  B.COMPANY_ID = A.COMPANY_ID
					--AND B.DIVISION_ID = A.DIVISION_ID
					--AND B.SITE_ID = A.SITE_ID
					--AND B.PLANT_ID = A.PLANT_ID
					ON  B.COMPANY_ID = A.CHILD_COMPANY_ID
					AND B.DIVISION_ID = A.CHILD_DIVISION_ID
					AND B.SITE_ID = A.CHILD_SITE_ID
					AND B.PLANT_ID = A.CHILD_PLANT_ID
					AND B.PARENT_ITEM_ID = A.PARENT_ITEM_ID
					AND B.CHILD_ITEM_ID = A.CHILD_ITEM_ID
			WHERE 1=1
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = '#SCM_MST_MODEL_BOM_EFFECTIVE';
			SET @v_description = 'STEP_2_2:UPDATE:ENG_ALT_ID';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--CHILD_SEQ는 BOM_ENG/BOE_SN 모두를 감안하여 생성해야 한다. 예외적인 상황을 개선하기 위해서
			UPDATE A
			SET CHILD_SEQ = B.CHILD_SEQ
			FROM #SCM_MST_MODEL_BOM_EFFECTIVE A WITH(NOLOCK)
					INNER JOIN (
							SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE
								, ROW_NUMBER() OVER(PARTITION BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, SUBSTRING(SORT_ORDER,1,LEN(SORT_ORDER)-4), EFF_START_DATE, ALT_ID
								                        ORDER BY IIF(ALT_PRIORITY='Y',1,2), ENG_ALT_PRIORITY, CONCAT_ALT_PRIORITY) AS CHILD_SEQ
							FROM #SCM_MST_MODEL_BOM_EFFECTIVE WITH(NOLOCK)
							WHERE 1=1
							AND (ENG_ALT_ID IS NOT NULL OR ORG_ALT_PRIORITY IS NOT NULL)
							) AS B
					ON  B.COMPANY_ID = A.COMPANY_ID
					AND B.DIVISION_ID = A.DIVISION_ID
					AND B.SITE_ID = A.SITE_ID
					AND B.PLANT_ID = A.PLANT_ID
					AND B.MODEL_ID = A.MODEL_ID
					AND B.CONCATENATE_ITEM = A.CONCATENATE_ITEM
					AND B.EFF_START_DATE = A.EFF_START_DATE
			WHERE 1=1
			AND (A.ENG_ALT_ID IS NOT NULL OR A.ORG_ALT_PRIORITY IS NOT NULL)
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = '#SCM_MST_MODEL_BOM_EFFECTIVE';
			SET @v_description = 'STEP_2_3:UPDATE:CHILD_SEQ';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		/*
			대치BOM의 생산계획 대상 여부는 SCM_MST_ALTER_BOM_V을 참조한다.
			상위레벨의 생산계획 여부는 유효날짜와 무관하다.(SCM_MST_ALTER_BOM이 KEY_DATE는 PK가 아님)
		*/
		BEGIN
			SET @N_LOOP_COUNT = 1;
			SET @N_MAX_LEVEL = 0;

			--LOOP 횟수 
			SELECT @N_MAX_LEVEL = ISNULL(MAX(NLEVEL),0)
			FROM #SCM_MST_MODEL_BOM_EFFECTIVE AS A WITH(NOLOCK)
			WHERE 1=1
			;

			/*
			상위레벨이 N이면 하위레벨은 N				
			상위레벨이 Y이면
				대치BOM이 아니면 Y(상위레벨 상속)
				대치BOM이면
					관리대상이면 SCP_PLAN_YN
					관리대상이 아니면
						CHILD_ITEM_ID 1순위      Y
						CHILD_ITEM_ID 2순위 이상 N
			*/
			WHILE @N_LOOP_COUNT <= @N_MAX_LEVEL
			BEGIN
				UPDATE A 
				SET ALT_PRIORITY =  
							CASE
								WHEN ISNULL(B.ALT_PRIORITY,'N') = 'N' THEN NULL	--상위 레벨이 N이면 하위레벨은 N
								ELSE												--상위레벨이 Y이면
									CASE
										WHEN A.ENG_ALT_ID IS NULL AND A.ORG_ALT_ID IS NULL THEN 'Y'	--대치BOM이 아니면(BOM_ENG/BOM_EFF 기준)
										ELSE														--대치BOM이면
											CASE
												WHEN A.SCP_PLAN_YN IS NOT NULL THEN					--대치BOM 관리대상이면 
													IIF(A.SCP_PLAN_YN='N',NULL,A.SCP_PLAN_YN)	
												ELSE IIF(A.CHILD_SEQ=1,'Y',NULL)			        --대치BOM 관리대상이 아니면
											END
									END
							END
				FROM #SCM_MST_MODEL_BOM_EFFECTIVE AS A WITH(NOLOCK)
						--LEFT OUTER JOIN (
						--					 SELECT *
						--					 FROM
						--					 (
						--						 SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.MODEL_ID, B.CONCATENATE_ITEM, B.ALT_PRIORITY, B.NLEVEL
						--								, ROW_NUMBER() OVER(PARTITION BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.MODEL_ID, B.CONCATENATE_ITEM ORDER BY B.EFF_START_DATE DESC) AS MAX_KEY_DATE
						--						 FROM #SCM_MST_MODEL_BOM_EFFECTIVE B WITH(NOLOCK)
						--						 WHERE 1=1
						--					 ) AS B
						--					 WHERE MAX_KEY_DATE = 1		--EFF_START_DATE와 상관없이 ALT_PRIORITY가 동일하다는 전제로
						--				) AS B 	--상위 레벨
						LEFT OUTER JOIN #SCM_MST_MODEL_BOM_EFFECTIVE B WITH(NOLOCK)	--상위 레벨
						ON A.COMPANY_ID = B.COMPANY_ID 
						AND A.DIVISION_ID = B.DIVISION_ID 
						AND A.SITE_ID = B.SITE_ID 
						AND A.PLANT_ID = B.PLANT_ID 
						AND A.MODEL_ID = B.MODEL_ID 
						AND A.CONCATENATE_ITEM LIKE B.CONCATENATE_ITEM+'^%' 
						AND A.EFF_START_DATE >= B.EFF_START_DATE		--2021.04.30 상위레벨을 찾을 때 날짜 고려
						AND A.EFF_START_DATE < B.EFF_END_DATE			--2021.04.30 상위레벨을 찾을 때 날짜 고려
						AND B.NLEVEL = @N_LOOP_COUNT-1	
				WHERE 1 = 1
				AND A.NLEVEL = @N_LOOP_COUNT
				;
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = '';
				SET @v_log_message = 'LOOP='+ CAST(@N_LOOP_COUNT AS VARCHAR)+'/'+CAST(@N_MAX_LEVEL AS VARCHAR);
				SET @v_description = '';
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				SET @N_LOOP_COUNT = @N_LOOP_COUNT + 1;
			END;

		END;

		/******************************************************************
		* 대치BOM 모델별 ALT_PRIORITY UPDATE
		******************************************************************/
		BEGIN
			--UPDATE(대치BOM 모델)
			UPDATE DBO.SCM_MST_MODEL_BOM_EFFECTIVE
			SET 
				ALT_PRIORITY = B.ALT_PRIORITY,	
				SCP_PLAN_YN = B.SCP_PLAN_YN,
				ENG_ALT_ID = B.ENG_ALT_ID,
				ENG_ALT_PRIORITY = B.ENG_ALT_PRIORITY,
				ORG_ALT_PRIORITY = B.ORG_ALT_PRIORITY,
				CHILD_SEQ = B.CHILD_SEQ
			FROM DBO.SCM_MST_MODEL_BOM_EFFECTIVE AS A WITH(NOLOCK)
					INNER JOIN #SCM_MST_MODEL_BOM_EFFECTIVE AS B WITH(NOLOCK)
					ON A.COMPANY_ID = B.COMPANY_ID AND A.DIVISION_ID = B.DIVISION_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.MODEL_ID = B.MODEL_ID AND A.CONCATENATE_ITEM = B.CONCATENATE_ITEM AND A.EFF_START_DATE = B.EFF_START_DATE
			WHERE 1=1
			AND EXISTS (		--대치BOM 관리대상 모델
					SELECT 1
					FROM SCM_MST_ALTER_BOM_MODEL AS X WITH(NOLOCK)
					WHERE 1=1
					AND X.DIVISION_ID = A.DIVISION_ID
					AND X.SITE_ID = A.SITE_ID
					AND X.PLANT_ID = A.PLANT_ID
					AND X.MODEL_ID = A.MODEL_ID
				)
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_MODEL_BOM_EFFECTIVE'
			SET @v_description = N'STEP_3:UPDATE:대치BOM 모델 ALT_PRIORITY Update';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		END;

		--임시 테이블 삭제
		BEGIN
			IF OBJECT_ID('tempdb..#SCM_MST_MODEL_BOM_EFFECTIVE') IS NOT NULL
			BEGIN 
				DROP TABLE  #SCM_MST_MODEL_BOM_EFFECTIVE;
			END;
		END;

    END TRY

    BEGIN CATCH
	  
	  IF @@TRANCOUNT > 0 ROLLBACK TRAN;	--Transaction 종료

      SET @v_log_type = 'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR LINE ' + CAST(ERROR_LINE() AS nvarchar(10));
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;
    END CATCH;

	IF @@TRANCOUNT > 0 COMMIT TRAN;	--Transaction 종료

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '[PR_SCP_MST_MODEL_BOM_EFF]' ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

  END;
