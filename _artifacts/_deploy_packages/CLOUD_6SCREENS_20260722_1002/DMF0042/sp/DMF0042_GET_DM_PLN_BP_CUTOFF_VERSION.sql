CREATE OR REPLACE EDITIONABLE PROCEDURE "SCM_MGR"."DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION" 
(
				p_division_id                VARCHAR2,   -- 부서코드
				p_yyyyMM_from                VARCHAR2,    -- 조회(데이터)시작구간
				p_yyyyMM_to                  VARCHAR2,    -- 조회(데이터)끝구간
				p_version_type               VARCHAR2    -- 버전유형
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 * Program ID   : DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION
 * Description  : Business Plan ('DM_PLN_BP_FCST' TABLE SELECT)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2022/11/08  chano0612   [C20221025-000029] Business Plan Current버전 특정 컷오프 버전으로 덮어쓰기 기능 구현 요청의 건
 * 2026/03/15  김준규   [PJ20264226] NextSCM Pilot 설계 및 개발
 */
AS

--DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION('40', '20220501', '20231101', 'BP_M');
--DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION('40', '20211101', '20211231', 'BP_M');

/*
 * ========================================
 * [변환검증] 2026-03-08 20:46:04
 * 파일: dbo.DMF0042_GET_DM_PLN_BP_CUTOFF_VERSION.sql
 * ----------------------------------------
 * ⚠ BEGIN: BEGIN:1  END:2  차이:-1
 * ----------------------------------------
 * BEGIN 위치:  L23
 * END;  위치:  L49, L59
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */

    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE    VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE    VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
BEGIN

    v_in_para_data := JSON_OBJECT(
            'p_division_id' VALUE p_division_id,
            'p_yyyyMM_from' VALUE p_yyyyMM_from
          );

 OPEN O_RC1 FOR
 SELECT
  	   A.DIVISION_ID
      ,A.VERSION_NO
      ,A.VERSION_DESCRIPTION
      ,A.VERSION_TYPE
      ,A.YYYYMMDD
      ,A.VER_CRE_SEQ
      ,A.CREATED_BY
      ,A.CREATION_DATE
      ,A.LAST_UPDATED_BY
      ,A.LAST_UPDATE_DATE
      ,tei.EDIT_YN
  FROM DM_MST_VERSION A
 INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
    ON tei.UNIT_ID = A.DIVISION_ID
  WHERE A.DIVISION_ID = p_division_id
		AND A.VERSION_NO IN (SELECT VERSION_NO FROM DM_PLN_BP_FCST_C
		WHERE DIVISION_ID = p_division_id AND CUTOFF_TYPE LIKE p_version_type  ||  '%' AND YYYYMM BETWEEN p_yyyyMM_from AND p_yyyyMM_to GROUP BY VERSION_NO )
		AND NVL(A.ATTRIBUTE1, CHR(0)) <> 'MOVE'
  ORDER BY A.DIVISION_ID, A.VERSION_NO DESC, A.CREATION_DATE DESC;

DBMS_OUTPUT.PUT_LINE(p_division_id  ||  ' _ '  ||  p_version_type  ||  ' _ '  ||  p_yyyyMM_from || ' _ '  ||  p_yyyyMM_to);

  --SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  --WHERE TABLE_NAME = 'DM_PLN_BP_FCST_C'
  --SELECT * FROM INFORMATION_SCHEMA.COLUMNS
  --WHERE TABLE_NAME = 'DM_MST_VERSION'
  --SELECT * FROM DM_MST_VERSION WHERE CREATED_BY = 'CHANO0612'

    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE   := 'ERROR';
        V_SQL_CODE   := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
                            V_LOG_TYPE,
                            N_LOG_COUNT,
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
END;
/
