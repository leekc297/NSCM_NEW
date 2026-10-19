-- PKG_DMF0006 — standalone 복원 (DROP 직전 원문 = 생성 시점 DB 재조회본 · SCM_MGR 로 실행)
-- ⚠ STEP 1 백업이 아니라 현재 원문을 쓴다: STEP 2 에서 바뀐 standalone(예: DMF0043_GET_MAIN_SPREAD_TITLE → _CORE 호출)을 옛 본문으로 되돌리면 INVALID
SET DEFINE OFF
-- SOURCE-FRESH: SCM_MGR.PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST PROCEDURE LAST_DDL=2026-09-02 17:30:30 FETCHED=2026-09-15 19:16 DB=ZIOUI1
CREATE OR REPLACE PROCEDURE SCM_MGR."PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST" 
(

	p_division_id				VARCHAR2,
	p_customer_project_code	VARCHAR2,
	p_customer_model			VARCHAR2,
	p_scm_site_id				VARCHAR2,
	p_project_code				VARCHAR2,
	p_item_id					VARCHAR2,
	p_valid_yn					VARCHAR2,
	p_customer_model_type		VARCHAR2,
	p_convert_qty_pack			VARCHAR2,
	p_convert_qty_module		VARCHAR2,
	p_convert_qty_cell			VARCHAR2,
	p_created_by				VARCHAR2
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

    v_division_id VARCHAR2(4000 CHAR);
    v_customer_project_code VARCHAR2(4000 CHAR);
    v_customer_model VARCHAR2(4000 CHAR);
    v_scm_site_id VARCHAR2(4000 CHAR);
    v_project_code VARCHAR2(4000 CHAR);
    v_item_id VARCHAR2(4000 CHAR);
    v_valid_yn VARCHAR2(4000 CHAR);
    v_customer_model_type VARCHAR2(4000 CHAR);
    v_convert_qty_pack VARCHAR2(4000 CHAR);
    v_convert_qty_module VARCHAR2(4000 CHAR);
    v_convert_qty_cell VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    n_history_seq INTEGER;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data CLOB;
    v_step         VARCHAR2(4000 CHAR) := NULL;
BEGIN

    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        v_program_name := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    END IF;

    v_in_para_data := JSON_OBJECT(
        'p_division_id' VALUE p_division_id,
        'p_customer_project_code' VALUE p_customer_project_code,
        'p_customer_model' VALUE p_customer_model,
        'p_scm_site_id' VALUE p_scm_site_id,
        'p_project_code' VALUE p_project_code,
        'p_item_id' VALUE p_item_id,
        'p_valid_yn' VALUE p_valid_yn,
        'p_customer_model_type' VALUE p_customer_model_type,
        'p_convert_qty_pack' VALUE p_convert_qty_pack,
        'p_convert_qty_module' VALUE p_convert_qty_module,
        'p_convert_qty_cell' VALUE p_convert_qty_cell,
        'p_created_by' VALUE p_created_by
    );

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
		-- 트랜잭션 (START)
		-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

			BEGIN
				n_history_seq := SEQ1_DM_MST_CUSTOMER_MODEL_H.NEXTVAL;
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
									   p_division_id , n_history_seq ,p_customer_project_code, p_customer_model
									  ,p_scm_site_id ,p_project_code ,p_item_id ,p_valid_yn ,p_customer_model_type
									  ,p_convert_qty_pack ,p_convert_qty_module ,p_convert_qty_cell
									  ,p_created_by ,SYSTIMESTAMP ,p_created_by ,SYSTIMESTAMP
						   );

				   END;

			END;

		COMMIT ;

		-- END TRY

     EXCEPTION
         WHEN OTHERS THEN
        ROLLBACK;
        PR_SCM_SYS_LOG_BATCH(
            v_program_name, 'ERROR', 0, SQLERRM, NULL, SYSDATE,
            p_in_para_data => v_in_para_data,
            p_sql_err_code => SQLCODE,
            p_sql_err_msg  => SQLERRM,
            p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
        );
        RAISE_APPLICATION_ERROR(-20001,
            '[' || v_program_name || '] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || v_in_para_data
        );
  END;
/
-- 권한 (SCM_MGR)
GRANT EXECUTE ON SCM_MGR.PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST TO SCMP_APP;
-- 시노님 (SCMP_APP 로 실행할 것)
-- CREATE OR REPLACE SYNONYM SCMP_APP.PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST FOR SCM_MGR.PR_DM_MST_CUSTOMER_MODEL_MAPPING_HIST;
-- PROC_M (standalone PROC_NM · 멱등 MERGE)
COMMIT;
