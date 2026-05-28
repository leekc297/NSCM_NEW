/*=============================================================================================
 * File         : 05_Standalone_SP_MISC.sql
 * Description  : Standalone Procedures — MISC 화면 (1개)
 *              : 향후 PKG_MISC로 통합 권장 (사내 표준 §6 UI별 패키지 그룹화)
 * Author       : 마리소프트 이규철
 * Created      : 2026-05-13
 *
 * 실행 순서   : 07_Standalone_SP 단계
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/


CREATE OR REPLACE PROCEDURE SCM_MGR.CHECK_NEW_CAPA_VERSION
(
	  p_division_id		VARCHAR2
	, p_yyyymm				VARCHAR2
    , p_return_result_code VARCHAR2
/*
 * Program ID   : CHECK_NEW_CAPA_VERSION
 * Description  : CAPA_VERSION 하나도 없으면 추가
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2024/02/19   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 */
)
AS

    v_test_mode VARCHAR2(20 CHAR) := 'F';
    v_program_name VARCHAR2(150 CHAR) := 'CHECK_NEW_CAPA_VERSION';
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_version_cnt INTEGER := 0;
    v_last_version VARCHAR2(10 CHAR) := NULL;
    v_last_version_seq INTEGER := NULL;
    v_last_version_prog_stat VARCHAR2(2 CHAR) := NULL;
BEGIN
    	--    p_division_id VARCHAR2(30 CHAR) := '81';;
	--    p_yyyymm VARCHAR2(10 CHAR) := '202405';;
	--    p_return_result_code VARCHAR2(1 CHAR) := 'F';;










	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
		-- 시작 LOG
		v_log_type := 'START';
		v_log_message := '########## Start of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;

        IF v_test_mode <> 'T' THEN
		    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        END IF;





		SELECT	COUNT(*)
  INTO v_version_cnt
		FROM	FN_SCP0104_GET_CAPA_VERSION(p_division_id, p_yyyymm);

        DBMS_OUTPUT.PUT_LINE('v_version_cnt : ' || v_version_cnt);
        --
		--사업부/연월에 해당하는 버전이 하나도 없으면 버전 마스터(SCP_MST_CAPA_VERSION) 추가
		IF v_version_cnt = 0 THEN
			v_version_cnt := 1;
            --DIVISION_ID
            --VER_ID
            --VER_SEQ
            --PROG_STAT
            --SCP_FIN_PLAN_ID
            --SCP_PRDN_PLAN_REF_ST_YM
            --SCP_PRDN_PLAN_REF_END_YM
            --BIZ_PLAN_USE_YN
            --ATTRIBUTE1	ATTRIBUTE2	ATTRIBUTE3	ATTRIBUTE4	ATTRIBUTE5	ATTRIBUTE6	ATTRIBUTE7	ATTRIBUTE8	ATTRIBUTE9	ATTRIBUTE10	CREATED_BY	CREATION_DATE	LAST_UPDATED_BY	LAST_UPDATE_DATE
			INSERT INTO SCP_MST_CAPA_VERSION
            (
                  DIVISION_ID
                , VER_ID
                , VER_SEQ
                , PROG_STAT
				, CREATED_BY
				, CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
            )
			SELECT	  p_division_id
					, p_yyyymm
					, 1
					, 0
				    , 'iamarock'
				    , SYSTIMESTAMP
				    , 'iamarock'
                    , SYSTIMESTAMP
		END IF;


        -- LOG end
		v_log_type := 'END';
		v_log_message := '########## END of procedure ##########';
		v_description := NULL;
		d_event_date := SYSTIMESTAMP;

        IF v_test_mode <> 'T' THEN
            DBMS_OUTPUT.PUT_LINE(v_log_message);

		    PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
        END IF;


		-- 결과코드, 결과 카운트 반환 => UI 에서 체크할 경우만 p_return_result_code = 'T' 로 줘서 에러 체크 가능하도록 한다
        IF p_return_result_code = 'T' THEN
		    SELECT  'S' AS result_code,  1 AS result_cnt
		    FROM DUAL;
        END IF;
	-- END TRY
	EXCEPTION
	    WHEN OTHERS THEN
		  -- [XACT_STATE 제거] IF (XACT_STATE() <> 0) THEN
-- 			INSERT INTO SCM_SYS_LOG_BATCH
-- 			(
-- 				  PROGRAM_NAME
-- 				, LOG_TYPE
-- 				, LOG_COUNT
-- 				, LOG_MESSAGE
-- 				, DESCRIPTION
-- 				, EVENT_DATE
-- 				, CREATION_DATE
-- 				, CREATED_BY
-- 				, LAST_UPDATE_DATE
-- 				, LAST_UPDATED_BY
-- 			)
-- 			VALUES
-- 			(
-- 				  NVL($$PLSQL_UNIT, 'SCP0006_SAVE_PROJECT_ROUTE_PLANT')
-- 	 			, 'ERROR'
-- 	 			, NULL
-- 	 			, SQLERRM
-- 	 			, NULL
-- 	 			, SYSTIMESTAMP
-- 	 			, SYSTIMESTAMP
-- 	 			, $$PLSQL_UNIT
-- 	 			, SYSTIMESTAMP
-- 				, $$PLSQL_UNIT
-- 			)
-- 
-- 			--IF @V_TRANCOUNT > 0
-- 			--  COMMIT WORK;
		  -- [XACT_STATE 제거] END IF


		-- 결과코드, 결과 카운트 반환 => UI 에서 체크할 경우만 p_return_result_code = 'T' 로 줘서 에러 체크 가능하도록 한다
        IF p_return_result_code = 'T' THEN
            -- error코드, errror 메시지 반환
            SELECT 'F' AS result_code
            FROM DUAL;

            SELECT '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM
            FROM DUAL;
        END IF;
	-- END CATCH
        RAISE_APPLICATION_ERROR(-20001, '오류가 발생했습니다.');
END;
/
