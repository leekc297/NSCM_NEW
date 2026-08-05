PROCEDURE         PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST

(

	P_DIVISION_ID				VARCHAR2,
	P_CUSTOMER_PROJECT_CODE	VARCHAR2,
	P_CUSTOMER_MODEL			VARCHAR2,
	P_SCM_SITE_ID				VARCHAR2,
	P_PROJECT_CODE				VARCHAR2,
	P_ITEM_ID					VARCHAR2,
	P_VALID_YN					VARCHAR2,
	P_CUSTOMER_MODEL_TYPE		VARCHAR2,
	P_CONVERT_QTY_PACK			VARCHAR2,
	P_CONVERT_QTY_MODULE		VARCHAR2,
	P_CONVERT_QTY_CELL			VARCHAR2,
	P_CREATED_BY				VARCHAR2
)
/*
 * Program ID   : PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST
 * Description  : DM MST CUSTOMER MODEL MAPPING HISTORYT
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017. 11. 27    DWOK/DWPARK      Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
AS

    V_DIVISION_ID VARCHAR2(4000 CHAR);
    V_CUSTOMER_PROJECT_CODE VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID VARCHAR2(4000 CHAR);
    V_PROJECT_CODE VARCHAR2(4000 CHAR);
    V_ITEM_ID VARCHAR2(4000 CHAR);
    V_VALID_YN VARCHAR2(4000 CHAR);
    V_CUSTOMER_MODEL_TYPE VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_PACK VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_MODULE VARCHAR2(4000 CHAR);
    V_CONVERT_QTY_CELL VARCHAR2(4000 CHAR);
    V_CREATED_BY VARCHAR2(4000 CHAR);
    N_HISTORY_SEQ INTEGER;
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    V_LOG_TYPE VARCHAR2(30 CHAR);
    N_LOG_COUNT INTEGER := 0;
    V_LOG_MESSAGE VARCHAR2(1000 CHAR);
    V_DESCRIPTION VARCHAR2(500 CHAR);
    D_EVENT_DATE DATE;
    V_IN_PARA_DATA CLOB;
    V_STEP         VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    V_IN_PARA_DATA := JSON_OBJECT(
        'p_division_id' VALUE P_DIVISION_ID,
        'p_customer_project_code' VALUE P_CUSTOMER_PROJECT_CODE,
        'p_customer_model' VALUE P_CUSTOMER_MODEL,
        'p_scm_site_id' VALUE P_SCM_SITE_ID,
        'p_project_code' VALUE P_PROJECT_CODE,
        'p_item_id' VALUE P_ITEM_ID,
        'p_valid_yn' VALUE P_VALID_YN,
        'p_customer_model_type' VALUE P_CUSTOMER_MODEL_TYPE,
        'p_convert_qty_pack' VALUE P_CONVERT_QTY_PACK,
        'p_convert_qty_module' VALUE P_CONVERT_QTY_MODULE,
        'p_convert_qty_cell' VALUE P_CONVERT_QTY_CELL,
        'p_created_by' VALUE P_CREATED_BY
    );

	-- 시작 LOG  (START)
	V_LOG_TYPE := 'START';
	V_LOG_MESSAGE := '########## Start of procedure ##########';
	V_DESCRIPTION := NULL;
	D_EVENT_DATE := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
	V_LOG_MESSAGE := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
		-- 트랜잭션 (START)
		-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

			BEGIN
				N_HISTORY_SEQ := SEQ1_DM_MST_CUSTOMER_MODEL_H.NEXTVAL;
				   BEGIN

						--[2018-03-19]수정
						--MERGE INTO DM_MST_CUSTOMER_MODEL_H A
						--USING (
						--		SELECT
						--			 p_division_id				AS DIVISION_ID
						--			,p_customer_project_code CUSTOMER_PROJECT_CODE
						--			,p_customer_model CUSTOMER_MODEL
						--			,p_scm_site_id SCM_SITE_ID
						--			,p_project_code PROJECT_CODE
						--			,p_item_id ITEM_ID
						--			,p_valid_yn VALID_YN
						--			,p_customer_model_type CUSTOMER_MODEL_TYPE
						--			,p_convert_qty_pack CONVERT_QTY_PACK
						--			,p_convert_qty_module CONVERT_QTY_MODULE
						--			,p_convert_qty_cell CONVERT_QTY_CELL
						--	  ) B
						--ON (
						--			A.DIVISION_ID				= B.DIVISION_ID
						--		AND A.CUSTOMER_PROJECT_CODE		= B.CUSTOMER_PROJECT_CODE
						--		AND A.CUSTOMER_MODEL			= B.CUSTOMER_MODEL
						--		AND A.SCM_SITE_ID				= B.SCM_SITE_ID
						--		AND A.PROJECT_CODE				= B.PROJECT_CODE
						--		AND A.ITEM_ID					= B.ITEM_ID
						--		AND A.VALID_YN					= B.VALID_YN
						--		AND A.CUSTOMER_MODEL_TYPE		= B.CUSTOMER_MODEL_TYPE
						--		AND A.CONVERT_QTY_PACK			= B.CONVERT_QTY_PACK
						--		AND A.CONVERT_QTY_MODULE		= B.CONVERT_QTY_MODULE
						--		AND A.CONVERT_QTY_CELL			= B.CONVERT_QTY_CELL
						--   )
						----WHEN MATCHED THEN
						--	--UPDATE SET
						--	--			 last_updated_by = p_created_by
						--	--			,last_update_date = SYSTIMESTAMP
						--WHEN NOT MATCHED THEN
						--	INSERT	  (
						--			   DIVISION_ID ,HISTORY_SEQ, CUSTOMER_PROJECT_CODE ,CUSTOMER_MODEL
						--			  ,SCM_SITE_ID ,PROJECT_CODE ,ITEM_ID ,VALID_YN ,CUSTOMER_MODEL_TYPE
						--			  ,CONVERT_QTY_PACK ,CONVERT_QTY_MODULE ,CONVERT_QTY_CELL
						--			  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE)
						--	VALUES
						--			  (
						--			   p_division_id , n_history_seq ,p_customer_project_code, p_customer_model
						--			  ,p_scm_site_id ,p_project_code ,p_item_id ,p_valid_yn ,p_customer_model_type
						--			  ,p_convert_qty_pack ,p_convert_qty_module ,p_convert_qty_cell
						--			  ,p_created_by ,SYSTIMESTAMP ,p_created_by ,SYSTIMESTAMP
						--			  );
							INSERT	INTO  DM_MST_CUSTOMER_MODEL_H
							(
									   DIVISION_ID ,HISTORY_SEQ, CUSTOMER_PROJECT_CODE ,CUSTOMER_MODEL
									  ,SCM_SITE_ID ,PROJECT_CODE ,ITEM_ID ,VALID_YN ,CUSTOMER_MODEL_TYPE
									  ,CONVERT_QTY_PACK ,CONVERT_QTY_MODULE ,CONVERT_QTY_CELL
									  ,CREATED_BY ,CREATION_DATE ,LAST_UPDATED_BY ,LAST_UPDATE_DATE
							)
							VALUES
							(
									   P_DIVISION_ID , N_HISTORY_SEQ ,P_CUSTOMER_PROJECT_CODE, P_CUSTOMER_MODEL
									  ,P_SCM_SITE_ID ,P_PROJECT_CODE ,P_ITEM_ID ,P_VALID_YN ,P_CUSTOMER_MODEL_TYPE
									  ,P_CONVERT_QTY_PACK ,P_CONVERT_QTY_MODULE ,P_CONVERT_QTY_CELL
									  ,P_CREATED_BY ,SYSTIMESTAMP ,P_CREATED_BY ,SYSTIMESTAMP
						   );

				   END;

			END;

		COMMIT ;

		-- END TRY

     EXCEPTION
         WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(
            V_PROGRAM_NAME, 'ERROR', 0, SQLERRM, NULL, SYSDATE,
            P_IN_PARA_DATA => V_IN_PARA_DATA,
            P_SQL_ERR_CODE => SQLCODE,
            P_SQL_ERR_MSG  => SQLERRM,
            P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || V_IN_PARA_DATA
        );
  END;