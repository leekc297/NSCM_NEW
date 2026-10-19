
/*
 * Program ID   : PR_SCP_MST_ALTER_BOM
 * Description  : 대체 BOM 생성 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.02.25   SEO			PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선
 *							- PACK/MODULE/CELL의 대체 BOM 생성
 * 2022.11.03   jahn1501    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ATTRIBUTE11, ATTRIBUTE12 추가
 *							- 신규 BOM 추가 시 ALT_PRIORITY, SCP_PLAN_YN 정보를 가져와서 ATTRIBUTE11, ATTRIBUTE12 저장
 */

CREATE PROCEDURE [dbo].[PR_SCP_MST_ALTER_BOM_0728_ORG]
AS
  BEGIN
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_MST_ALTER_BOM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    DECLARE @v_division_id  NVARCHAR(30);
	DECLARE @v_history_seq	BIGINT;
	DECLARE @n_cnt			INT;
	DECLARE @n_model_cnt    INT;

    -- 시작 LOG
    SET @v_log_type    = 'START';
	SET @n_log_count   = 0;
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '[PR_SCP_MST_ALTER_BOM]';
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

    BEGIN TRY

	  BEGIN
		-----------------------------------------------------------
		-- 2021.02.25 변경 여부를 체크하기 위한 임시테이블
		-----------------------------------------------------------
		IF OBJECT_ID('tempdb..#SCM_MST_ALTER_BOM_ORG') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCM_MST_ALTER_BOM_ORG;
        END;

		SELECT *
		INTO #SCM_MST_ALTER_BOM_ORG
		FROM DBO.SCM_MST_ALTER_BOM WITH(NOLOCK)
		WHERE 1=1
		;

		-----------------------------------------------------------
		-- 2021.02.25 ERP(SCM_MST_BOM_ENG_SN) 기준으로 대체 BOM 생성
		--	:신규 PARENT ITEM에 대해서는 ERP_PLAN_YN 적용
		--  :신규 PARENT ITEM가 아닌 경우는 CUR_SCP_PLAN_YN를 적용하고 신규 CHILD ITEM에 대해서는 'N'으로 설정, 뒷단에서 재조정
        -----------------------------------------------------------
		IF OBJECT_ID('tempdb..#SCM_MST_ALTER_BOM') IS NOT NULL
        BEGIN 
            DROP TABLE  #SCM_MST_ALTER_BOM;
        END;

		--KEY_DATE 기준 PARENT/CHILD 정보 생성
		WITH TEMP AS (
			SELECT A.*
			FROM
			(
				SELECT A.*
						, ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.CHILD_ITEM_ID ORDER BY KEY_DATE DESC) AS MAX_KEY_DATE	--최신 KEY_DATE
						, B.ITEM_TYPE AS CHILD_ITEM_TYPE
						, NULL AS PARENT_ITEM_TYPE					--C.ITEM_TYPE
						, B.SCP_OPERATION_GROUP AS CHILD_OPERATION_GROUP
						, NULL AS PARENT_OPERATION_GROUP			--C.SCP_OPERATION_GROUP
						, B.SCP_FLOW_ID AS CHILD_SCP_FLOW_ID
						, NULL AS PARENT_SCP_FLOW_ID				--C.SCP_FLOW_ID
				FROM DBO.SCM_MST_BOM_ENG_SN A WITH(NOLOCK)
				
						INNER JOIN DBO.SCM_MST_ITEM_SN B WITH(NOLOCK)
						ON    B.ITEM_ID = A.CHILD_ITEM_ID
						AND   B.COMPANY_ID = A.COMPANY_ID
						AND   B.DIVISION_ID = A.DIVISION_ID
						AND   B.SITE_ID = A.SITE_ID
						AND   B.ACTIVE_FLAG = 'Y'

						INNER JOIN DBO.SCM_MST_ITEM_SN C WITH(NOLOCK)
						ON    C.ITEM_ID = A.PARENT_ITEM_ID
						AND   C.COMPANY_ID = A.COMPANY_ID
						AND   C.DIVISION_ID = A.DIVISION_ID
						AND   C.SITE_ID = A.SITE_ID
						AND   C.ACTIVE_FLAG = 'Y'

				WHERE 1=1
				AND   A.ALT_ID IS NOT NULL	--대체 관계
				AND   A.ACTIVE_FLAG = 'Y'
				--AND   A.EFF_END_DATE > DATEADD(dd, -7, dbo.fn_next_day(GETDATE(), 'MON'))	--월요일 기준
				AND   CAST(A.EFF_END_DATE AS DATE) > DATEADD(dd, -7, CAST(dbo.fn_next_day(GETDATE(), 'MON') AS DATE)) --월요일 기준
			) AS A
			WHERE MAX_KEY_DATE = 1	--BOM_VERSION_ID를 무시하고 유효한 날짜 범위에서 최신 KEY_DATE를 기준으로 한다.
		)
		SELECT A.DIVISION_ID
			 , A.SITE_ID
			 , A.PLANT_ID
			 , A.PARENT_ITEM_ID
			 , A.CHILD_ITEM_ID
			 , A.BOM_VERSION_ID
			 , A.KEY_DATE
			 , A.PARENT_QTY
			 , A.PARENT_UOM
			 , A.CHILD_QTY
			 , A.CHILD_UOM
			 , A.ALT_ID
			 , A.ALT_PRIORITY
			 , A.ALT_RATE
			 , A.EFF_START_DATE
			 , A.EFF_END_DATE
			 , A.ECO_CODE
			 , B.SCP_PLAN_YN AS OLD_SCP_PLAN_YN
			 , CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.ALT_ID ORDER BY A.ALT_PRIORITY) = 1 THEN 'Y' ELSE 'N' END AS ERP_SCP_PLAN_YN
			 , CASE 
					WHEN C.PARENT_ITEM_ID IS NULL THEN	--신규 PARENT ITEM에 대해서는 ERP_PLAN_YN 적용
						CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.ALT_ID ORDER BY A.ALT_PRIORITY) = 1 THEN 'Y' ELSE 'N' END 
					ELSE								--신규 PARENT ITEM가 아닌 경우는 CUR_SCP_PLAN_YN를 적용하고 신규 CHILD ITEM에 대해서는 'N'으로 설정, 뒷단에서 재조정
						ISNULL(B.SCP_PLAN_YN,'N')
			   END AS NEW_ITEM_SCP_PLAN_YN
			 , A.ALT_CNT
			 , CASE WHEN B.CHILD_ITEM_ID IS NULL THEN 'NEW_CHILD_ITEM_ID' ELSE NULL END AS CUR_CHILD_ITEM_ID
			 , CASE WHEN C.PARENT_ITEM_ID IS NULL THEN 'NEW_PARENT_ITEM_ID' ELSE NULL END AS CUR_PARENT_ITEM_ID
			 , CASE WHEN A.COMMON_CELL_CNT > 1 THEN 'Y' ELSE 'N' END AS COMMON_CELL_YN	--CELL 공용 여부
			 , A.CHILD_ITEM_TYPE
			 , A.PARENT_ITEM_TYPE
			 , A.CHILD_OPERATION_GROUP
			 , A.PARENT_OPERATION_GROUP
			 , A.CHILD_SCP_FLOW_ID
			 , A.PARENT_SCP_FLOW_ID
			 , GETDATE() AS CREATION_DATE
			 , @V_PROGRAM_NAME AS CREATION_BY
			 , GETDATE() AS LAST_UPDATED_DATE
			 , @V_PROGRAM_NAME AS LAST_UPDATED_BY
		INTO #SCM_MST_ALTER_BOM
		FROM
		(
			SELECT A.*
				 , COUNT(*) OVER(PARTITION BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.PARENT_ITEM_ID, A.ALT_ID) AS ALT_CNT	--대체 ITEM 수
				 , COUNT(*) OVER(PARTITION BY A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.CHILD_ITEM_ID) AS COMMON_CELL_CNT
			FROM TEMP AS A
			WHERE 1=1
			AND EXISTS (	
					SELECT 1
					FROM  TEMP AS B WITH(NOLOCK)
					WHERE 1=1
					AND   B.DIVISION_ID = A.DIVISION_ID
					AND   B.SITE_ID = A.SITE_ID
					AND   B.PLANT_ID = A.PLANT_ID
					AND   B.PARENT_ITEM_ID = A.PARENT_ITEM_ID
					--AND   B.CHILD_ITEM_ID = A.CHILD_ITEM_ID	--주석 처리(PARENT가 대치BOM일 경우 CHILD 일부가 누락되는 것 방지하기 위해서)
					AND   B.ALT_ID = A.ALT_ID
					AND   (B.CHILD_OPERATION_GROUP = 'P' OR (B.CHILD_OPERATION_GROUP = 'A' AND B.CHILD_SCP_FLOW_ID IN ('A3000', 'A9000')))
					--AND   B.CHILD_ITEM_TYPE <> 'R'  -- 
				)
		) A 

			LEFT OUTER JOIN DBO.SCM_MST_ALTER_BOM AS B WITH(NOLOCK)
			ON  B.DIVISION_ID = A.DIVISION_ID 
			AND B.SITE_ID = A.SITE_ID
			AND B.PLANT_ID = A.PLANT_ID
			AND B.PARENT_ITEM_ID = A.PARENT_ITEM_ID
			AND B.CHILD_ITEM_ID = A.CHILD_ITEM_ID

			LEFT OUTER JOIN (	SELECT DISTINCT 
									   DIVISION_ID
									 , SITE_ID
									 , PLANT_ID
									 , PARENT_ITEM_ID 
								FROM  DBO.SCM_MST_ALTER_BOM A WITH(NOLOCK)
								WHERE 1=1
							) AS C
			ON  C.DIVISION_ID = A.DIVISION_ID 
			AND C.SITE_ID = A.SITE_ID
			AND C.PLANT_ID = A.PLANT_ID
			AND C.PARENT_ITEM_ID = A.PARENT_ITEM_ID
		WHERE 1=1
		--AND A.ALT_CNT > 1				--주석처리(단독 대치BOM도 포함)
		;
		SET @n_log_count   = @@ROWCOUNT;
		SET @v_log_type    = '';
		SET @v_log_message = '#SCM_MST_ALTER_BOM';
		SET @v_description = 'CREATE';
		SET @d_event_date  = SYSDATETIME();
		EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

		-----------------------------------------------------------
		-- 2021.02.25 SCM_MST_ALTER_BOM 초기화 및 생성
		-----------------------------------------------------------

		SET @N_CNT = 0;
		SELECT @N_CNT = COUNT(*) 
		FROM
		(
			SELECT TOP(1) *
			FROM #SCM_MST_ALTER_BOM
		) AS A
		WHERE 1=1
		;

		IF @N_CNT > 0	--#SCM_MST_ALTER_BOM 데이터가 생성되지 않았을 경우 원본을 유지
		BEGIN
			BEGIN TRAN		--Transaction 시작

			-----------------------------------------------------------
			--	2021.02.25 #SCM_MST_ALTER_BOM 기준으로 PARENT_ITEM_ID/CHILD_ITEM_ID 생성
			-----------------------------------------------------------
			--DELETE
			DELETE SCM_MST_ALTER_BOM
			FROM DBO.SCM_MST_ALTER_BOM AS A
			WHERE 1=1
			AND NOT EXISTS (	--
					SELECT 1
					FROM #SCM_MST_ALTER_BOM AS B WITH(NOLOCK)
					WHERE 1=1
					AND A.DIVISION_ID = B.DIVISION_ID
					AND A.SITE_ID = B.SITE_ID
					AND A.PLANT_ID = B.PLANT_ID
					AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
					AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
				);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM';
			SET @v_description = 'DELETE('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			
			--UPDATE
			UPDATE SCM_MST_ALTER_BOM
			SET BOM_VERSION_ID = B.BOM_VERSION_ID
			  , KEY_DATE = B.KEY_DATE
			  , PARENT_QTY = B.PARENT_QTY
			  , PARENT_UOM = B.PARENT_UOM
			  , CHILD_QTY = B.CHILD_QTY
			  , CHILD_UOM = B.CHILD_UOM
			  , ALT_ID = B.ALT_ID
			  , ALT_PRIORITY = B.ALT_PRIORITY
			  , ALT_RATE = B.ALT_RATE
			  , EFF_START_DATE = B.EFF_START_DATE
			  , EFF_END_DATE = B.EFF_END_DATE
			  , ECO_CODE = B.ECO_CODE
			  , SCP_PLAN_YN = B.NEW_ITEM_SCP_PLAN_YN
			  , COMMON_CELL_YN = B.COMMON_CELL_YN
			  , CHILD_ITEM_TYPE = B.CHILD_ITEM_TYPE
			  , ATTRIBUTE1 = B.OLD_SCP_PLAN_YN
			  , ATTRIBUTE2 = B.ERP_SCP_PLAN_YN
			  , ATTRIBUTE3 = B.CUR_PARENT_ITEM_ID
			  , ATTRIBUTE4 = B.CUR_CHILD_ITEM_ID
			  , ATTRIBUTE5 = B.CHILD_ITEM_TYPE
			  , ATTRIBUTE6 = B.PARENT_ITEM_TYPE
			  , ATTRIBUTE7 = B.CHILD_OPERATION_GROUP
			  , ATTRIBUTE8 = B.PARENT_OPERATION_GROUP
			  , ATTRIBUTE9 = B.CHILD_SCP_FLOW_ID
			  , ATTRIBUTE10 = B.PARENT_SCP_FLOW_ID
			  , LAST_UPDATED_BY = B.LAST_UPDATED_BY
			  , LAST_UPDATED_DATE = B.LAST_UPDATED_DATE
			FROM DBO.SCM_MST_ALTER_BOM AS A WITH(NOLOCK)
					INNER JOIN #SCM_MST_ALTER_BOM AS B WITH(NOLOCK)
					ON A.DIVISION_ID = B.DIVISION_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
			WHERE 1=1
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM';
			SET @v_description = @v_description + '/UPDATE('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			--INSERT
			INSERT DBO.SCM_MST_ALTER_BOM(
				DIVISION_ID,
				SITE_ID,
				PLANT_ID,
				PARENT_ITEM_ID,
				CHILD_ITEM_ID,
				BOM_VERSION_ID,
				KEY_DATE,
				PARENT_QTY,
				PARENT_UOM,
				CHILD_QTY,
				CHILD_UOM,
				ALT_ID,
				ALT_PRIORITY,
				ALT_RATE,
				EFF_START_DATE,
				EFF_END_DATE,
				ECO_CODE,
				SCP_PLAN_YN,
				COMMON_CELL_YN,
				CHILD_ITEM_TYPE,
				ATTRIBUTE1,
				ATTRIBUTE2,
				ATTRIBUTE3,
				ATTRIBUTE4,
				ATTRIBUTE5,
				ATTRIBUTE6,
				ATTRIBUTE7,
				ATTRIBUTE8,
				ATTRIBUTE9,
				ATTRIBUTE10,
				ATTRIBUTE11,
				ATTRIBUTE12,
				CREATION_BY,
				CREATION_DATE,
				LAST_UPDATED_BY,
				LAST_UPDATED_DATE
			)
			SELECT 
				A.DIVISION_ID,
				A.SITE_ID,
				A.PLANT_ID,
				A.PARENT_ITEM_ID,
				A.CHILD_ITEM_ID,
				A.BOM_VERSION_ID,
				A.KEY_DATE,
				A.PARENT_QTY,
				A.PARENT_UOM,
				A.CHILD_QTY,
				A.CHILD_UOM,
				A.ALT_ID,
				A.ALT_PRIORITY,
				A.ALT_RATE,
				A.EFF_START_DATE,
				A.EFF_END_DATE,
				A.ECO_CODE,
				A.NEW_ITEM_SCP_PLAN_YN AS SCP_PLAN_YN, 
				A.COMMON_CELL_YN,
				A.CHILD_ITEM_TYPE,
				A.OLD_SCP_PLAN_YN AS ATTRIBUTE1,
				A.ERP_SCP_PLAN_YN AS ATTRIBUTE2,
				A.CUR_PARENT_ITEM_ID AS ATTRIBUTE3,
				A.CUR_CHILD_ITEM_ID AS ATTRIBUTE4,
				A.CHILD_ITEM_TYPE AS ATTRIBUTE5,
				A.PARENT_ITEM_TYPE AS ATTRIBUTE6,
				A.CHILD_OPERATION_GROUP AS ATTRIBUTE7,
				A.PARENT_OPERATION_GROUP AS ATTRIBUTE8,
				A.CHILD_SCP_FLOW_ID AS ATTRIBUTE9,
				A.PARENT_SCP_FLOW_ID AS ATTRIBUTE10,
				A.ALT_PRIORITY AS ATTRIBUTE11,
				A.NEW_ITEM_SCP_PLAN_YN AS ATTRIBUTE12,
				A.CREATION_BY,
				A.CREATION_DATE,
				A.LAST_UPDATED_BY,
				A.LAST_UPDATED_DATE
			FROM #SCM_MST_ALTER_BOM AS A WITH(NOLOCK)
			WHERE 1=1
			AND NOT EXISTS(
					SELECT 1
					FROM DBO.SCM_MST_ALTER_BOM AS B WITH(NOLOCK)
					WHERE 1=1
					AND A.DIVISION_ID = B.DIVISION_ID
					AND A.SITE_ID = B.SITE_ID
					AND A.PLANT_ID = B.PLANT_ID
					AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
					AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
				);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM';
			SET @v_description = @v_description + '/INSERT('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			/*
			-----------------------------------------------------------
			-- 2021.02.25 SCP PLAN 여부 업데이트
			--	:SCP_PLAN_YN = 'Y'가 없는 PARENT_ITEM_ID는 우선순위가 가장 빠른 것을 'Y'로 설정
			-----------------------------------------------------------
			UPDATE A
			SET SCP_PLAN_YN = B.ERP_SCP_PLAN_YN	
			FROM SCM_MST_ALTER_BOM AS A WITH(NOLOCK)
					INNER JOIN #SCM_MST_ALTER_BOM AS B WITH(NOLOCK)
					ON B.DIVISION_ID = A.DIVISION_ID AND B.SITE_ID = A.SITE_ID AND B.PLANT_ID = A.PLANT_ID AND B.PARENT_ITEM_ID = A.PARENT_ITEM_ID AND B.CHILD_ITEM_ID = A.CHILD_ITEM_ID
			WHERE NOT EXISTS (	--SCP_PLAN_YN = 'Y'가 있는 PARENT_ITEM_ID 제외
						SELECT 1
						FROM SCM_MST_ALTER_BOM AS X WITH(NOLOCK)
						WHERE 1=1
						AND X.DIVISION_ID = A.DIVISION_ID
						AND X.SITE_ID = A.SITE_ID
						AND X.PLANT_ID = A.PLANT_ID
						AND X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
						AND X.SCP_PLAN_YN = 'Y'
					)
					;
			*/

			-----------------------------------------------------------
			-- 2021.02.25 SCP PLAN 여부 업데이트
			--	:SCP_PLAN_YN = 'Y'가 없는 PARENT_ITEM_ID 중에서 신규 추가된 CHILD ITEM이 있을 경우
			-----------------------------------------------------------
			UPDATE A
			SET SCP_PLAN_YN = B.SCP_PLAN_YN
			  , ATTRIBUTE10 = ISNULL(ATTRIBUTE10,'-')+N'^NEW_CHILD_ITEM_ID가 있을 경우'
			FROM DBO.SCM_MST_ALTER_BOM AS A WITH(NOLOCK)
					INNER JOIN (
						SELECT DIVISION_ID
							 , SITE_ID
							 , PLANT_ID
							 , PARENT_ITEM_ID
							 , CHILD_ITEM_ID 
							 , CASE WHEN ROW_NUMBER() OVER(PARTITION BY DIVISION_ID, SITE_ID, PLANT_ID, PARENT_ITEM_ID, ALT_ID ORDER BY ALT_PRIORITY) = 1 THEN 'Y' ELSE 'N' END AS SCP_PLAN_YN
						FROM DBO.SCM_MST_ALTER_BOM WITH(NOLOCK) 
						WHERE ATTRIBUTE4 = 'NEW_CHILD_ITEM_ID'
					) AS B 
					ON B.DIVISION_ID = A.DIVISION_ID AND B.SITE_ID = A.SITE_ID AND B.PLANT_ID = A.PLANT_ID AND B.PARENT_ITEM_ID = A.PARENT_ITEM_ID AND B.CHILD_ITEM_ID = A.CHILD_ITEM_ID
			WHERE 1=1
			AND A.ATTRIBUTE4 = 'NEW_CHILD_ITEM_ID'	--신규로 추가된 ITEM
			AND NOT EXISTS (	--SCP_PLAN_YN = 'Y'가 있는 PARENT_ITEM_ID 제외
						SELECT 1
						FROM DBO.SCM_MST_ALTER_BOM AS X WITH(NOLOCK)
						WHERE 1=1
						AND X.DIVISION_ID = A.DIVISION_ID
						AND X.SITE_ID = A.SITE_ID
						AND X.PLANT_ID = A.PLANT_ID
						AND X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
						AND X.ALT_ID = A.ALT_ID
						AND X.SCP_PLAN_YN = 'Y'
					);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM';
			SET @v_description = @v_description + '/UPDATE('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			-----------------------------------------------------------
			-- 2021.02.25 SCP PLAN 여부 업데이트
			--	:SCP_PLAN_YN = 'Y'가 없는 PARENT_ITEM_ID 중에서 신규 추가된 CHILD ITEM이 없을 경우
			-----------------------------------------------------------
			UPDATE A
			SET SCP_PLAN_YN = A.ATTRIBUTE2 --ERP_SCP_PLAN_YN
		      , ATTRIBUTE10 = ISNULL(ATTRIBUTE10,'-')+N'^NEW_CHILD_ITEM_ID가 없을 경우'
			FROM DBO.SCM_MST_ALTER_BOM AS A WITH(NOLOCK)
			WHERE 1=1
			AND A.ATTRIBUTE4 <> 'NEW_CHILD_ITEM_ID'	--신규로 추가된 ITEM이 없는 경우
			AND NOT EXISTS (	--SCP_PLAN_YN = 'Y'가 있는 PARENT_ITEM_ID 제외
						SELECT 1
						FROM DBO.SCM_MST_ALTER_BOM AS X WITH(NOLOCK)
						WHERE 1=1
						AND X.DIVISION_ID = A.DIVISION_ID
						AND X.SITE_ID = A.SITE_ID
						AND X.PLANT_ID = A.PLANT_ID
						AND X.PARENT_ITEM_ID = A.PARENT_ITEM_ID
						AND X.ALT_ID = A.ALT_ID
						AND X.SCP_PLAN_YN = 'Y'
					);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM';
			SET @v_description = @v_description + '/UPDATE('+CAST(@n_log_count AS VARCHAR)+')';
			SET @d_event_date  = SYSDATETIME();
			--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			COMMIT TRAN		--Transaction 종료

			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM'
			SET @v_description = N'대치BOM 동기화:'+@v_description;
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;
		
		/**************************************************************
		* 대치BOM 관련 MODEL 정보 생성
		**************************************************************/
		IF @N_CNT > 0	--#SCM_MST_ALTER_BOM 데이터가 생성되지 않았을 경우 원본을 유지
		BEGIN
			IF OBJECT_ID('tempdb..#SCM_MST_ALTER_BOM_MODEL') IS NOT NULL
			BEGIN 
				DROP TABLE  #SCM_MST_ALTER_BOM_MODEL;
			END;

			SELECT  A.DIVISION_ID,
					A.SITE_ID,
					A.PLANT_ID,
					A.MODEL_ID,
					A.PARENT_ITEM_ID,
					A.CHILD_ITEM_ID,
					B.BOM_VERSION_ID,
					B.KEY_DATE,
					B.PARENT_QTY,
					B.PARENT_UOM,
					B.CHILD_QTY,
					B.CHILD_UOM,
					B.ALT_ID,
					B.ALT_PRIORITY,
					B.ALT_RATE,
					B.EFF_START_DATE,
					B.EFF_END_DATE,
					B.ECO_CODE,
					A.NLEVEL,
					A.SORT_ORDER,
					B.ATTRIBUTE1,
					B.ATTRIBUTE2,
					B.ATTRIBUTE3,
					B.ATTRIBUTE4,
					B.ATTRIBUTE5,
					B.ATTRIBUTE6,
					B.ATTRIBUTE7,
					B.ATTRIBUTE8,
					B.ATTRIBUTE9,
					B.ATTRIBUTE10,
					B.CREATION_BY,
					B.CREATION_DATE,
					B.LAST_UPDATED_BY,
					B.LAST_UPDATED_DATE	
			INTO #SCM_MST_ALTER_BOM_MODEL
			FROM
			(
				SELECT  
						A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						A.MODEL_ID,
						A.PARENT_ITEM_ID,
						A.CHILD_ITEM_ID,
						A.CHILD_DIVISION_ID,
						A.CHILD_SITE_ID,
						A.CHILD_PLANT_ID,
						MIN(A.NLEVEL) AS NLEVEL,
						MIN(A.SORT_ORDER) AS SORT_ORDER
				FROM DBO.SCM_MST_BOM_SN AS A WITH(NOLOCK)	--[LGCE_FPDEV_TR].[dbo].[SCM_MODEL_COMP_TEMP]
				WHERE 1=1
				GROUP BY A.DIVISION_ID,
						A.SITE_ID,
						A.PLANT_ID,
						A.MODEL_ID,
						A.PARENT_ITEM_ID,
						A.CHILD_ITEM_ID,
						A.CHILD_DIVISION_ID,
						A.CHILD_SITE_ID,
						A.CHILD_PLANT_ID
			) A
			INNER JOIN DBO.SCM_MST_ALTER_BOM B WITH(NOLOCK)	
			ON A.CHILD_DIVISION_ID = B.DIVISION_ID AND A.CHILD_SITE_ID = B.SITE_ID AND A.CHILD_PLANT_ID = B.PLANT_ID AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
			WHERE 1=1
			;
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = '#SCM_MST_ALTER_BOM_MODEL';
			SET @v_description = 'CREATE';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

			SET @N_MODEL_CNT = 0;

			SELECT @N_MODEL_CNT = COUNT(*) 
			FROM
			(
				SELECT TOP(1) *
				FROM #SCM_MST_ALTER_BOM_MODEL
			) AS A
			WHERE 1=1
			;

			IF @N_MODEL_CNT > 0	--#SCM_MST_ALTER_BOM_MODEL 데이터가 생성되지 않았을 경우 원본을 유지
			BEGIN
				BEGIN TRAN		--Transaction 시작

				--DELETE
				DELETE DBO.SCM_MST_ALTER_BOM_MODEL
				FROM DBO.SCM_MST_ALTER_BOM_MODEL AS A
				WHERE 1=1
				AND NOT EXISTS (
						SELECT 1
						FROM #SCM_MST_ALTER_BOM_MODEL AS B WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.SITE_ID = B.SITE_ID
						AND A.PLANT_ID = B.PLANT_ID
						AND A.MODEL_ID = B.MODEL_ID 
						AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
						AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
					);
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = '';
				SET @v_log_message = 'SCM_MST_ALTER_BOM_MODEL';
				SET @v_description = 'DELETE('+CAST(@n_log_count AS VARCHAR)+')';
				SET @d_event_date  = SYSDATETIME();
				--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				--UPDATE
				UPDATE DBO.SCM_MST_ALTER_BOM_MODEL
				SET BOM_VERSION_ID = B.BOM_VERSION_ID,
					KEY_DATE = B.KEY_DATE,
					PARENT_QTY = B.PARENT_QTY,
					PARENT_UOM = B.PARENT_UOM,
					CHILD_QTY = B.CHILD_QTY,
					CHILD_UOM = B.CHILD_UOM,
					ALT_ID = B.ALT_ID,
					ALT_PRIORITY = B.ALT_PRIORITY,
					ALT_RATE = B.ALT_RATE,
					EFF_START_DATE = B.EFF_START_DATE,
					EFF_END_DATE = B.EFF_END_DATE,
					ECO_CODE = B.ECO_CODE,
					NLEVEL = B.NLEVEL,
					SORT_ORDER = B.SORT_ORDER,
					ATTRIBUTE1 = B.ATTRIBUTE1,
					ATTRIBUTE2 = B.ATTRIBUTE2,
					ATTRIBUTE3 = B.ATTRIBUTE3,
					ATTRIBUTE4 = B.ATTRIBUTE4,
					ATTRIBUTE5 = B.ATTRIBUTE5,
					ATTRIBUTE6 = B.ATTRIBUTE6,
					ATTRIBUTE7 = B.ATTRIBUTE7,
					ATTRIBUTE8 = B.ATTRIBUTE8,
					ATTRIBUTE9 = B.ATTRIBUTE9,
					ATTRIBUTE10 = B.ATTRIBUTE10,
					LAST_UPDATED_BY = B.LAST_UPDATED_BY,
					LAST_UPDATED_DATE = B.LAST_UPDATED_DATE		--MODEL BOM 생성 시 변경점 판단 시 사용됨...!!! 현재시간으로 변경하면 안됨
				FROM DBO.SCM_MST_ALTER_BOM_MODEL AS A WITH(NOLOCK)
						INNER JOIN #SCM_MST_ALTER_BOM_MODEL AS B WITH(NOLOCK)
						ON A.DIVISION_ID = B.DIVISION_ID AND A.SITE_ID = B.SITE_ID AND A.PLANT_ID = B.PLANT_ID AND A.MODEL_ID = B.MODEL_ID AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
				WHERE 1=1
				;
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = '';
				SET @v_log_message = 'SCM_MST_ALTER_BOM_MODEL';
				SET @v_description = @v_description + '/UPDATE('+CAST(@n_log_count AS VARCHAR)+')';
				SET @d_event_date  = SYSDATETIME();
				--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

				--INSERT
				INSERT DBO.SCM_MST_ALTER_BOM_MODEL
				SELECT *
				FROM #SCM_MST_ALTER_BOM_MODEL AS A WITH(NOLOCK)
				WHERE 1=1
				AND NOT EXISTS (
						SELECT 1
						FROM DBO.SCM_MST_ALTER_BOM_MODEL AS B WITH(NOLOCK)
						WHERE 1=1
						AND A.DIVISION_ID = B.DIVISION_ID
						AND A.SITE_ID = B.SITE_ID
						AND A.PLANT_ID = B.PLANT_ID
						AND A.MODEL_ID = B.MODEL_ID
						AND A.PARENT_ITEM_ID = B.PARENT_ITEM_ID
						AND A.CHILD_ITEM_ID = B.CHILD_ITEM_ID
					);
				SET @n_log_count   = @@ROWCOUNT;
				SET @v_log_type    = '';
				SET @v_log_message = 'SCM_MST_ALTER_BOM_MODEL';
				SET @v_description = @v_description + '/INSERT('+CAST(@n_log_count AS VARCHAR)+')';
				SET @d_event_date  = SYSDATETIME();
				--EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
				
				COMMIT TRAN		--Transaction 종료

				SET @v_log_type    = '';
				SET @v_log_message = 'SCM_MST_ALTER_BOM_MODEL'
				SET @v_description = N'대치BOM 모델 동기화:'+@v_description;
				SET @d_event_date  = SYSDATETIME();
				EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
			END;
		END;

		/**************************************************************
		* PK 기준 신규 생성 데이터를 이력으로 생성
		**************************************************************/
		BEGIN
			SET @v_history_seq = NEXT VALUE FOR SEQ1_SCP_MST_ALTER_BOM_H

			INSERT DBO.SCM_MST_ALTER_BOM_H(
					HISTORY_SEQ,
					DIVISION_ID,
					SITE_ID,
					PLANT_ID,
					PARENT_ITEM_ID,
					CHILD_ITEM_ID,
					BOM_VERSION_ID,
					KEY_DATE,
					PARENT_QTY,
					PARENT_UOM,
					CHILD_QTY,
					CHILD_UOM,
					ALT_ID,
					ALT_PRIORITY,
					ALT_RATE,
					EFF_START_DATE,
					EFF_END_DATE,
					ECO_CODE,
					SCP_PLAN_YN,
					OLD_SCP_PLAN_YN,
					COMMON_CELL_YN,
					CHILD_ITEM_TYPE,
					ATTRIBUTE1,
					ATTRIBUTE2,
					ATTRIBUTE3,
					ATTRIBUTE4,
					ATTRIBUTE5,
					ATTRIBUTE6,
					ATTRIBUTE7,
					ATTRIBUTE8,
					ATTRIBUTE9,
					ATTRIBUTE10,
					ATTRIBUTE11,
					ATTRIBUTE12,
					CREATION_BY,
					CREATION_DATE,
					LAST_UPDATED_BY,
					LAST_UPDATED_DATE
				)
			SELECT  @v_history_seq,
					A.DIVISION_ID,
					A.SITE_ID,
					A.PLANT_ID,
					A.PARENT_ITEM_ID,
					A.CHILD_ITEM_ID,
					A.BOM_VERSION_ID,
					A.KEY_DATE,
					A.PARENT_QTY,
					A.PARENT_UOM,
					A.CHILD_QTY,
					A.CHILD_UOM,
					A.ALT_ID,
					A.ALT_PRIORITY,
					A.ALT_RATE,
					A.EFF_START_DATE,
					A.EFF_END_DATE,
					A.ECO_CODE,
					A.SCP_PLAN_YN,
					A.ATTRIBUTE1 AS OLD_SCP_PLAN_YN,
					A.COMMON_CELL_YN,
					A.CHILD_ITEM_TYPE,
					A.ATTRIBUTE1,
					A.ATTRIBUTE2,
					A.ATTRIBUTE3,
					A.ATTRIBUTE4,
					A.ATTRIBUTE5,
					A.ATTRIBUTE6,
					A.ATTRIBUTE7,
					A.ATTRIBUTE8,
					A.ATTRIBUTE9,
					A.ATTRIBUTE10,
					A.ATTRIBUTE11,
					A.ATTRIBUTE12,
					A.CREATION_BY,
					A.CREATION_DATE,
					A.LAST_UPDATED_BY,
					A.LAST_UPDATED_DATE
			FROM DBO.SCM_MST_ALTER_BOM A WITH(NOLOCK)
			WHERE 1=1
			AND NOT EXISTS (
					SELECT 1
					FROM #SCM_MST_ALTER_BOM_ORG B WITH(NOLOCK)
					WHERE B.DIVISION_ID = A.DIVISION_ID
					AND B.SITE_ID = A.SITE_ID
					AND B.PLANT_ID = A.PLANT_ID
					AND B.PARENT_ITEM_ID = A.PARENT_ITEM_ID 
					AND B.CHILD_ITEM_ID = A.CHILD_ITEM_ID
				);
			SET @n_log_count   = @@ROWCOUNT;
			SET @v_log_type    = '';
			SET @v_log_message = 'SCM_MST_ALTER_BOM_H';
			SET @v_description = 'INSERT';
			SET @d_event_date  = SYSDATETIME();
			EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
		END;

		/**************************************************************
		* 임시 테이블 삭제
		**************************************************************/
		BEGIN
			IF OBJECT_ID('tempdb..#SCM_MST_ALTER_BOM_ORG') IS NOT NULL
			BEGIN 
				DROP TABLE  #SCM_MST_ALTER_BOM_ORG;
			END;

			IF OBJECT_ID('tempdb..#SCM_MST_ALTER_BOM') IS NOT NULL
			BEGIN 
				DROP TABLE  #SCM_MST_ALTER_BOM;
			END;

			IF OBJECT_ID('tempdb..#SCM_MST_ALTER_BOM_MODEL') IS NOT NULL
			BEGIN 
				DROP TABLE  #SCM_MST_ALTER_BOM_MODEL;
			END;
		END;

        -- TXN LOG
        SET @v_log_type    = 'TXN';
        SET @n_log_count   = 0;
        SET @v_log_message = @v_program_name;
        SET @v_description = 'Process Complete.' ;
        SET @d_event_date  = SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

      END;
    
    END TRY

    BEGIN CATCH
      
	  IF @@TRANCOUNT > 0 ROLLBACK TRAN;	--Transaction 종료

      -- ERROR LOG
      SET @v_log_type    = 'ERROR';
	  SET @n_log_count   = 0;
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = 'ERROR LINE ' + CAST(ERROR_LINE() AS NVARCHAR(10));
      SET @d_event_date  = SYSDATETIME();
      EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;
    END CATCH;

	IF @@TRANCOUNT > 0 COMMIT TRAN;	--Transaction 종료

    -- 종료 LOG
    SET @v_log_type    = 'END';
	SET @n_log_count   = 0;
	SET @v_log_message = '########## END of procedure ##########';
    SET @v_description = '[PR_SCP_MST_ALTER_BOM]' ;
    SET @d_event_date  = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, NULL, @v_log_message, @v_description, @d_event_date;

  END;
