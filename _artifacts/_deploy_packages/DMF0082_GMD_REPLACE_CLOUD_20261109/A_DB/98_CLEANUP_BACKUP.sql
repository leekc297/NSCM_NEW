/* =====================================================================================================
 * DMF0082 GET_MAIN_DATA 교체 · 98_CLEANUP_BACKUP — 백업표 삭제 — 화면 확인까지 끝나고 원복 가능성이 없을 때만
 * 마커 [E20261104-DMF0082ONEQUERY] · 생성 2026-11-09 14:03:13 (사내 ZIOUI1) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 교체 = PKG_DMF0082 의 P_DMF0082_GET_MAIN_DATA 구간 ← PKG_DMF0082_1104 의 같은 구간 (이 DB 의 USER_SOURCE 끼리 · 나머지 프로시저 무변경)
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 이 파일을 실행하면 99 원복을 할 수 없다. 화면 조회·저장 확인 후 실행한다.
DECLARE
    n PLS_INTEGER;
BEGIN
    FOR t IN (SELECT TABLE_NAME FROM USER_TABLES WHERE TABLE_NAME IN ('ZB_DMF0082_GMD_BAK', 'ZB_DMF0082_GMD_FP')) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || t.TABLE_NAME || ' PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED ' || t.TABLE_NAME);
    END LOOP;
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME IN ('ZB_DMF0082_GMD_BAK', 'ZB_DMF0082_GMD_FP');
    IF n = 0 THEN DBMS_OUTPUT.PUT_LINE('백업표 없음'); END IF;
END;
/
