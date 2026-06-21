-- ============================================================
-- DMF0043_GET_CONTRIBUTE_MAIN_DATA — EDIT_FLAG NVL fix
-- ============================================================
-- ROOT CAUSE:
--   GT_DMF0043_TITLE 의 'EDIT_FLAG' row 가 TITLE SP 결과에 없을 때
--   subquery `(SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG')` = NULL
--   → `TO_NUMBER(SORT_ORDER_NO) > NULL` = 항상 FALSE → 0 row → v_ColumnData / v_ColumnDataPivot 빈
--   → 동적 SQL `PIVOT (... IN ())` → ORA-00936 누락된 표현식
--
-- FIX: NVL(subquery, 0) 으로 가드 → EDIT_FLAG row 없으면 0 fallback → 모든 row 통과
-- 두 곳 patch:
--   L124-125 (첫 cursor — v_ColumnData / v_ColumnDataPivot 빌드)
--   L143-144 (둘째 cursor — v_ColumnData2 빌드)
--
-- 메모리 룰 `feedback_sp_body_no_rewrite` 준수 — 2 라인만 변경 (NVL wrap)
-- 실행 계정: SCM_MGR
-- ============================================================

DECLARE
    V_OK1 NUMBER;
    V_OK2 NUMBER;
    V_PATCHED_DDL CLOB;
BEGIN
    -- 원본 DDL 가져오기
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'STORAGE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'TABLESPACE', FALSE);
    DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM, 'SQLTERMINATOR', FALSE);
    SELECT DBMS_METADATA.GET_DDL('PROCEDURE', 'DMF0043_GET_CONTRIBUTE_MAIN_DATA', USER)
      INTO V_PATCHED_DDL FROM DUAL;

    -- Patch 1: NULL → NVL(..., 0) — 같은 SUBQUERY 가 2회 등장 (L124-125 + L143-144)
    -- 단순 string REPLACE — 전체 occurrence 모두 patch
    V_PATCHED_DDL := REPLACE(V_PATCHED_DDL,
        '(SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG'')',
        'NVL((SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG''), 0)');

    -- 검증 — patch 적용 확인 (NVL 패턴 2회 등장)
    V_OK1 := REGEXP_COUNT(V_PATCHED_DDL,
        'NVL\(\(SELECT TO_NUMBER\(SORT_ORDER_NO\) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG''\), 0\)');
    -- 원본 패턴 (NVL 없는) 잔존 0 확인
    V_OK2 := REGEXP_COUNT(V_PATCHED_DDL,
        '> \(SELECT TO_NUMBER\(SORT_ORDER_NO\) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = ''EDIT_FLAG''\)');

    DBMS_OUTPUT.PUT_LINE('Patch applied: NVL count = ' || V_OK1 || ' (기대 2), raw count = ' || V_OK2 || ' (기대 0)');

    IF V_OK1 <> 2 OR V_OK2 <> 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Patch verification failed. Manual review required.');
    END IF;

    -- CREATE OR REPLACE
    EXECUTE IMMEDIATE V_PATCHED_DDL;
    DBMS_OUTPUT.PUT_LINE('DMF0043_GET_CONTRIBUTE_MAIN_DATA — NVL EDIT_FLAG fix 적용 완료');
END;
/

-- 검증
SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME = 'DMF0043_GET_CONTRIBUTE_MAIN_DATA';
