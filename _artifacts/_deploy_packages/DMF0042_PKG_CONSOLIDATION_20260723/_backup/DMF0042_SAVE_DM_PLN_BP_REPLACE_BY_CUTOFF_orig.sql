
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF" 
(
				p_division_id                VARCHAR2,   -- 부서코드
				p_version_type               VARCHAR2,   -- 버전유형
				p_yyyyMM_from                VARCHAR2,    -- 시작구간
				p_yyyyMM_to                  VARCHAR2,    -- 끝구간
				p_created_by                 VARCHAR2,   -- 작성자
				p_version_no                 VARCHAR2    -- 버전번호 (BP_M_20220822_V002)

    , O_RC1  OUT  SYS_REFCURSOR
    , O_RC2  OUT  SYS_REFCURSOR
)
/*
 * Program ID	: DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF
 * Description	: Business Plan ('DM_PLN_BP_FCST' TABLE INSERT/UPDATE/DELETE)
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 * 2026/03/15	ZIONEX	[PJ20264226] NextSCM Pilot 프로시저 변환 적용
 * 2026.06.02	ZIONEX	[PJ202650304] NextSCM Migration
 */
AS

/*
 * ========================================
 * [자동변환] 2026-03-08 20:46:07
 * 원본: dbo.DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF.sql
 * ----------------------------------------
 * 짝 BEGIN: BEGIN:8  END:9  차이:-1
 * ----------------------------------------
 * IF 시작:	  L263
 * END IF 시작: L273
 * BEGIN 시작:  L33, L58, L60, L67, L79, L164, L219, L242
 * END;  시작:  L64, L71, L74, L161, L211, L221, L246, L259, L275
 * 비고: END가 1개 더 많으므로 자동 변환 시 END; 짝을 확인하세요.
 * ----------------------------------------
 * 자동 변환 결과이므로 반드시 검토 후 사용하세요.
 * ========================================
 */

    p_count			 INTEGER; -- 적용데이터 수량

--DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF('40', 'BP_M', '202401', '202401', 'chano0612', 'BP_M_20221115_V001');
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    v_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    v_in_para_data VARCHAR2(4000);
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    -- N_LOG_COUNT   NUMBER := 0;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_division_id' VALUE p_division_id,
	    'p_version_type' VALUE p_version_type,
	    'p_yyyyMM_from' VALUE p_yyyyMM_from,
	    'p_yyyyMM_to' VALUE p_yyyyMM_to,
	    'p_created_by' VALUE p_created_by,
	    'p_version_no' VALUE p_version_no
	    --'P_M_20220822_V002' VALUE P_M_20220822_V002
	  );

	-- LOG 용 변수 설정
	v_log_type := 'START';
	v_log_message := '########## Start of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, v_log_count, v_log_message, v_description, d_event_date,
	p_in_para_data => v_in_para_data
      );

	-- 시작 LOG  (END)
	v_log_message := NULL;	/*-- <- 변수 재사용을 위하여 초기화해야함 --*/

	-------------------------------------- 설정된 기간에서 기존 데이터 삭제 START
	BEGIN

		BEGIN
		  DELETE FROM DM_PLN_BP_FCST
		  WHERE DIVISION_ID = p_division_id AND YYYYMM BETWEEN p_yyyyMM_from AND p_yyyyMM_to;
		  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
		END;

		--PRINT 'DM_PLN_BP_FCST' || '_' || 'DELETE' || SQL%ROWCOUNT
		BEGIN
		  DELETE FROM DM_BP_EXCHANGE_RATE
		  WHERE DIVISION_ID = p_division_id AND SUBSTR(YYYYMMDD, 1, 6) BETWEEN p_yyyyMM_from AND p_yyyyMM_to;
		  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
		END;

		--PRINT 'DM_BP_EXCHANGE_RATE' || '_' || 'DELETE' || SQL%ROWCOUNT
	END;
	-------------------------------------- 설정된 기간에서 기존 데이터 삭제 END
	-------------------------------------- 컷오프데이터를 데이터를 삽입 START
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 변환)

	  BEGIN
		  INSERT INTO DM_PLN_BP_FCST(
			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			ITEM_ID,
			FCST_TYPE,
			MEASURE,
			PLANT_SITE_ID,
			DEPT_ID,
			END_CUSTOMER,
			BIZ_TYPE,
			YYYYMM,
			CURRENCY,
			ITEM_USE,
			UNIT_ENERGY,
			INCOTERMS,
			CELL_PROD_SITE,
			DOM_EXP,
			QTY,
			CREATED_BY,
			CREATION_DATE,
			LAST_UPDATED_BY,
			LAST_UPDATE_DATE,
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
			CELL_PER_MODULE,
			CELL_PER_PACK,
			PROJECT_NAME,
			MODULE_PER_PACK)
		  SELECT
  			DIVISION_ID,
			PROJECT_CODE,
			SCM_SITE_ID,
			ITEM_ID,
			FCST_TYPE,
			MEASURE,
			PLANT_SITE_ID,
			DEPT_ID,
			END_CUSTOMER,
			BIZ_TYPE,
			YYYYMM,
			CURRENCY,
			ITEM_USE,
			UNIT_ENERGY,
			INCOTERMS,
			CELL_PROD_SITE,
			DOM_EXP,
			QTY,
			CREATED_BY,
			CREATION_DATE,
			p_created_by, --LAST_UPDATED_BY,
			SYSDATE, --LAST_UPDATE_DATE,
			p_version_no, --ATTRIBUTE1,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10,
			CELL_PER_MODULE,
			CELL_PER_PACK,
			PROJECT_NAME,
			MODULE_PER_PACK

		  FROM DM_PLN_BP_FCST_C
		  WHERE VERSION_NO = p_version_no AND DIVISION_ID = p_division_id AND YYYYMM BETWEEN p_yyyyMM_from AND p_yyyyMM_to;

		  p_count := SQL%ROWCOUNT;
		  DBMS_OUTPUT.PUT_LINE(p_count);

	  END;

	  --PRINT 'DM_PLN_BP_FCST' || '_' || 'INSERT' || SQL%ROWCOUNT
	  BEGIN
		  INSERT INTO DM_BP_EXCHANGE_RATE(
					  DIVISION_ID,
					  YYYYMMDD,
					  CURRENCY,
					  UNIT_CURRENCY,
					  EXCHANGE_PRICE,
					  CREATED_BY,
					  CREATION_DATE,
					  LAST_UPDATED_BY,
					  LAST_UPDATE_DATE,
					  ATTRIBUTE1,
					  ATTRIBUTE2,
					  ATTRIBUTE3,
					  ATTRIBUTE4,
					  ATTRIBUTE5,
					  ATTRIBUTE6,
					  ATTRIBUTE7,
					  ATTRIBUTE8,
					  ATTRIBUTE9,
					  ATTRIBUTE10
					  )
		  SELECT
			DIVISION_ID,
			YYYYMMDD,
			CURRENCY,
			UNIT_CURRENCY,
			EXCHANGE_PRICE,
			CREATED_BY,
			CREATION_DATE,
			p_created_by,
			SYSDATE,
			p_version_no,
			ATTRIBUTE2,
			ATTRIBUTE3,
			ATTRIBUTE4,
			ATTRIBUTE5,
			ATTRIBUTE6,
			ATTRIBUTE7,
			ATTRIBUTE8,
			ATTRIBUTE9,
			ATTRIBUTE10
		  FROM DM_BP_EXCHANGE_RATE_C
		  WHERE VERSION_NO = p_version_no AND DIVISION_ID = p_division_id AND SUBSTR(YYYYMMDD, 1, 6) BETWEEN p_yyyyMM_from AND p_yyyyMM_to;

		  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);

	  END;
	  --PRINT 'DM_BP_EXCHANGE_RATE' || '_' || 'INSERT' || SQL%ROWCOUNT
	-------------------------------------- 컷오프데이터를 데이터를 삽입 END

	-- 종료 LOG
	v_log_type := 'END';
	v_log_count := p_count;
	v_log_message := '########## End of procedure ##########';
	v_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, v_log_count, v_log_message, v_description, d_event_date,
	p_in_para_data => v_in_para_data
      );

	OPEN O_RC1 FOR SELECT 'OK' RESULT, p_count CNT FROM DUAL;
	OPEN O_RC2 FOR SELECT 'OK' RESULT FROM DUAL;


EXCEPTION
    WHEN OTHERS THEN
	V_LOG_TYPE   := 'ERROR';
	V_SQL_CODE   := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG := SQLERRM;
	V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
			    V_LOG_TYPE,
			    v_log_count,
			    V_LOG_MESSAGE,
			    V_DESCRIPTION,
			    D_EVENT_DATE,
			    V_PROC_INPUT,
			    V_SQL_CODE,
			    V_SQL_ERRMSG,
			    V_BACKTRACE
			    );
	RAISE_APPLICATION_ERROR(-20001,
	    '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	    ' / SQLERRM=' || SQLERRM ||
	    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	    ' / PARAMS=' || v_in_para_data
	);
END DMF0042_SAVE_DM_PLN_BP_REPLACE_BY_CUTOFF;
/