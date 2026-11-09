/* =====================================================================================================
 * DMF0082_1104 클라우드 이관 · 99_ROLLBACK — PKG_DMF0082_1104 원복 — 적용 전 없었으면 삭제 · 있었으면 백업 원문으로 재생성
 * 마커 [E20261104-DMF0082ONEQUERY] · 생성 2026-11-09 13:09:09 (사내 ZIOUI1) · 실행 계정 = SCM_MGR · 파일 전체 F5 · 값 입력 없음
 * 대상 = 새 객체 PKG_DMF0082_1104 만. 원본 PKG_DMF0082 는 변경하지 않는다.
 * ===================================================================================================== */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

-- 원본 PKG_DMF0082 는 이 패키지가 바꾸지 않으므로 원복 대상이 아니다. 반복 실행 안전(이미 원복이면 SKIP).
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- 리허설용(TRUE = 판정만 · 변경 없음)
    n       PLS_INTEGER;
    v_none  PLS_INTEGER;
    v_obj   PLS_INTEGER;
    v_code  NUMBER;
    v       CLOB;
    v_st    VARCHAR2(30);
BEGIN
    SELECT COUNT(*) INTO v_obj FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082_1104' AND OBJECT_TYPE = 'PACKAGE';
    SELECT COUNT(*) INTO n FROM USER_TABLES WHERE TABLE_NAME = 'ZB_DMF0082_1104_BAK';
    IF n = 0 THEN
        IF v_obj = 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP — PKG_DMF0082_1104 없음 · 백업표 없음 (이미 원복 또는 미적용)');
            RETURN;
        END IF;
        RAISE_APPLICATION_ERROR(-20021, '중단 — 백업표 ZB_DMF0082_1104_BAK 가 없어 적용 전 상태를 모름. PKG_DMF0082_1104 를 그대로 둠 — 회신');
    END IF;
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_DMF0082_1104_BAK WHERE OBJ_TYPE = ''NONE''' INTO v_none;
    IF v_none > 0 THEN
        -- 적용 전에 없던 객체 → 시노님 · 패키지 삭제 (권한은 객체와 함께 사라진다)
        FOR s IN (SELECT OWNER FROM ALL_SYNONYMS WHERE TABLE_OWNER = USER AND TABLE_NAME = 'PKG_DMF0082_1104' AND OWNER <> 'PUBLIC') LOOP
            IF c_dry THEN DBMS_OUTPUT.PUT_LINE('DRY     DROP SYNONYM ' || s.OWNER || '.PKG_DMF0082_1104');
            ELSE
                BEGIN EXECUTE IMMEDIATE 'DROP SYNONYM ' || s.OWNER || '.PKG_DMF0082_1104'; DBMS_OUTPUT.PUT_LINE('DROPPED SYNONYM ' || s.OWNER || '.PKG_DMF0082_1104');
                EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('SYNONYM 삭제 실패 ' || s.OWNER || ' — ' || SQLERRM); END;
            END IF;
        END LOOP;
        IF v_obj = 0 THEN
            DBMS_OUTPUT.PUT_LINE('SKIP — PKG_DMF0082_1104 이미 없음');
        ELSIF c_dry THEN
            DBMS_OUTPUT.PUT_LINE('DRY     DROP PACKAGE PKG_DMF0082_1104');
        ELSE
            EXECUTE IMMEDIATE 'DROP PACKAGE PKG_DMF0082_1104';
            DBMS_OUTPUT.PUT_LINE('ROLLED BACK — DROP PACKAGE PKG_DMF0082_1104 (적용 전 없던 객체)');
        END IF;
    ELSE
        -- 적용 전에 있던 원문으로 재생성 (SPEC → BODY) · 컴파일 오류(ORA-24344)는 계속 진행해 상태로 판정, 그 밖의 오류는 중단
        FOR t IN (SELECT 'PACKAGE' TP, 1 ORD FROM DUAL UNION ALL SELECT 'PACKAGE BODY', 2 FROM DUAL ORDER BY 2) LOOP
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ZB_DMF0082_1104_BAK WHERE OBJ_TYPE = :1' INTO n USING t.TP;
            IF n = 1 THEN
                EXECUTE IMMEDIATE 'SELECT SRC FROM ZB_DMF0082_1104_BAK WHERE OBJ_TYPE = :1' INTO v USING t.TP;
                IF c_dry THEN DBMS_OUTPUT.PUT_LINE('DRY     RECREATE ' || t.TP || ' PKG_DMF0082_1104 (' || DBMS_LOB.GETLENGTH(v) || '자)');
                ELSE
                    v_code := 0;
                    BEGIN EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v; EXCEPTION WHEN OTHERS THEN v_code := SQLCODE; END;
                    IF v_code NOT IN (0, -24344) THEN
                        RAISE_APPLICATION_ERROR(-20022, '중단 — ' || t.TP || ' 재생성 실패 SQLCODE ' || v_code || ' (실행 중 세션 확인 후 재실행)');
                    END IF;
                    SELECT MAX(STATUS) INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082_1104' AND OBJECT_TYPE = t.TP;
                    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — ' || t.TP || ' PKG_DMF0082_1104 백업 원문으로 재생성 · ' || v_st);
                END IF;
            END IF;
        END LOOP;
    END IF;
    IF NOT c_dry THEN
        EXECUTE IMMEDIATE 'DROP TABLE ZB_DMF0082_1104_BAK PURGE';
        DBMS_OUTPUT.PUT_LINE('DROPPED ZB_DMF0082_1104_BAK');
    END IF;
END;
/
SELECT 'R1' CHK, OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME IN ('PKG_DMF0082','PKG_DMF0082_1104') ORDER BY 1, 2;
