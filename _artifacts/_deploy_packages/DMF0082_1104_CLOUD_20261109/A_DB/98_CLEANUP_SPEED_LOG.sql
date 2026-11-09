/* =====================================================================================================
 * DMF0082_1104 클라우드 이관 · 98_CLEANUP_SPEED_LOG — 측정 기록표 삭제 (40 결과를 보관한 뒤 실행)
 * 마커 [E20261104-DMF0082ONEQUERY] · 생성 2026-11-09 13:09:09 (사내 ZIOUI1) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 대상 = 새 객체 PKG_DMF0082_1104 만. 원본 PKG_DMF0082 는 변경하지 않는다.
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

DECLARE
    n PLS_INTEGER;
BEGIN
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_SPEED';
    IF n = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — ZB_DMF0082_1104_SPEED 없음');
    ELSE
        EXECUTE IMMEDIATE 'DROP TABLE ZB_DMF0082_1104_SPEED PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED ZB_DMF0082_1104_SPEED');
    END IF;
END;
/
