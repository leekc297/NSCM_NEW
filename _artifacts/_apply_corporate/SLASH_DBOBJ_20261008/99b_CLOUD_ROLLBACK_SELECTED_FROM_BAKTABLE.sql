-- [E20261008-SLASHOBJ] 99b_CLOUD_ROLLBACK_SELECTED_FROM_BAKTABLE — 지정 객체만 백업 테이블 최신 회차로 원복 · 생성 2026-10-08 18:40 · 대상 96객체(사내 현재 원문 스냅샷 2026-10-08T17:26) · SCM_MGR 접속 후 파일 전체 실행(F5)
--   · 파일 안 v_selected 에 객체명을 기입 후 실행. 기입 전 그대로 실행하면 0건(안전).
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_run   VARCHAR2(14);
    -- ▼ 원복할 객체명을 콤마로 기입 (예: 'PKG_SCP0025,PKG_DMF0003'). 아래 자리표시자는 어떤 객체와도 일치하지 않아 그대로 실행하면 0건 원복(안전).
    v_selected VARCHAR2(4000) := 'OBJECT_NAME_1,OBJECT_NAME_2';
    v_sql   CLOB; v_ok NUMBER := 0; v_fail NUMBER := 0; v_inv NUMBER := 0; v_errs NUMBER; v_st VARCHAR2(10);
BEGIN
    SELECT MAX(bak_run) INTO v_run FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008;   -- 최신 회차. 특정 회차로 원복하려면 아래 한 줄을 주석 해제하고 14자리 회차 기입
    -- v_run := 'YYYYMMDDHH24MISS';
    DBMS_OUTPUT.PUT_LINE('ROLLBACK FROM RUN=' || v_run);
    FOR o IN (SELECT obj_type, obj_name, MAX(src_kind) AS src_kind FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008
               WHERE bak_run = v_run AND obj_type NOT LIKE '#%' AND line > 0 AND INSTR(',' || UPPER(v_selected) || ',', ',' || obj_name || ',') > 0
               GROUP BY obj_type, obj_name ORDER BY CASE obj_type WHEN 'VIEW' THEN 1 WHEN 'FUNCTION' THEN 2 WHEN 'PROCEDURE' THEN 2 ELSE 3 END, obj_name) LOOP
        DBMS_LOB.CREATETEMPORARY(v_sql, TRUE);
        IF o.src_kind = 'source' THEN DBMS_LOB.APPEND(v_sql, TO_CLOB('CREATE OR REPLACE ')); END IF;
        FOR l IN (SELECT line, piece, text, MAX(piece) OVER (PARTITION BY line) AS last_piece
                    FROM SCM_MGR.ZZ_SLASHOBJ_BAK_20261008 WHERE bak_run = v_run AND obj_type = o.obj_type AND obj_name = o.obj_name AND line > 0 ORDER BY line, piece) LOOP
            IF l.text IS NOT NULL THEN DBMS_LOB.APPEND(v_sql, TO_CLOB(l.text)); END IF;              -- 조각(PIECE)은 그대로 이어 붙임
            IF o.src_kind = 'ddl' AND l.piece = l.last_piece THEN DBMS_LOB.APPEND(v_sql, TO_CLOB(CHR(10))); END IF;   -- DDL 은 줄 끝에 개행(ALL_SOURCE 원문은 개행 포함)
        END LOOP;
        IF o.src_kind = 'ddl' THEN v_sql := RTRIM(v_sql, ';' || CHR(10) || CHR(13) || ' '); END IF;
        BEGIN
            EXECUTE IMMEDIATE v_sql;
            SELECT COUNT(*) INTO v_errs FROM all_errors WHERE owner = 'SCM_MGR' AND name = o.obj_name AND type = o.obj_type AND attribute = 'ERROR';
            SELECT MAX(status) INTO v_st FROM all_objects WHERE owner = 'SCM_MGR' AND object_name = o.obj_name AND object_type = o.obj_type;
            IF v_errs = 0 AND v_st = 'VALID' THEN v_ok := v_ok + 1;
            ELSE v_inv := v_inv + 1; DBMS_OUTPUT.PUT_LINE('RESTORED BUT ' || NVL(v_st, '?') || ' errors=' || v_errs || ' : ' || o.obj_type || ' ' || o.obj_name); END IF;
        EXCEPTION WHEN OTHERS THEN
            v_fail := v_fail + 1; DBMS_OUTPUT.PUT_LINE('FAIL ' || o.obj_type || ' ' || o.obj_name || ' : ' || SUBSTR(SQLERRM, 1, 200));
        END;
        DBMS_LOB.FREETEMPORARY(v_sql);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('ROLLBACK run=' || v_run || ' | ok=' || v_ok || ' | restored_but_invalid=' || v_inv || ' | fail=' || v_fail);
END;
/
