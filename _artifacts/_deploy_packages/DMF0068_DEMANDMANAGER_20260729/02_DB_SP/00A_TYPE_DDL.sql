-- ============================================================================================
-- 00A_TYPE_DDL.sql — DMF0068 필수 스키마 TYPE 2종 자급 (2026-08-06 신설)
--   사유: 클라우드 01_PKG_DMF0068_SPEC.sql 실행 시 PLS-00201 'T_DMF0068_TAB' — 패키지에 TYPE DDL 미동봉.
--   원문 = 사내 OCGSCMD_P01 ALL_SOURCE 실측 1:1. 멱등: 기존재 시 skip (CREATE OR REPLACE 는 의존 PKG
--   존재 시 ORA-02303 이므로 존재 가드 방식). 실행 순서: 00A → (00B) → 01_SPEC → 02_BODY.
--   ⚠ ROW → TAB 순서 의무 (TAB 이 ROW 를 참조).
-- ============================================================================================
DECLARE
    v_cnt PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM ALL_OBJECTS
     WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'TYPE' AND OBJECT_NAME = 'T_DMF0068_ROW';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TYPE           SCM_MGR."T_DMF0068_ROW" AS OBJECT (
    DIVISION_ID       VARCHAR2(10 CHAR),
    PROJECT_CODE      VARCHAR2(200 CHAR),
    YYYYMM_FROM       VARCHAR2(6 CHAR),
    YYYYMM_TO         VARCHAR2(6 CHAR),
    MEASURE           VARCHAR2(100 CHAR),
    ORDER_APPROVAL    NUMBER,
    ORDER_NOW         NUMBER,
    ATTRIBUTE1        VARCHAR2(100 CHAR),
    ATTRIBUTE2        VARCHAR2(100 CHAR)
)';
        DBMS_OUTPUT.PUT_LINE('T_DMF0068_ROW created');
    ELSE
        DBMS_OUTPUT.PUT_LINE('T_DMF0068_ROW exists - skip');
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM ALL_OBJECTS
     WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'TYPE' AND OBJECT_NAME = 'T_DMF0068_TAB';
    IF v_cnt = 0 THEN
        EXECUTE IMMEDIATE 'CREATE TYPE           SCM_MGR."T_DMF0068_TAB" AS TABLE OF SCM_MGR.T_DMF0068_ROW';
        DBMS_OUTPUT.PUT_LINE('T_DMF0068_TAB created');
    ELSE
        DBMS_OUTPUT.PUT_LINE('T_DMF0068_TAB exists - skip');
    END IF;
END;
/
-- 검증
SELECT OBJECT_NAME, STATUS FROM ALL_OBJECTS
 WHERE OWNER = 'SCM_MGR' AND OBJECT_TYPE = 'TYPE'
   AND OBJECT_NAME IN ('T_DMF0068_ROW', 'T_DMF0068_TAB') ORDER BY 1;
