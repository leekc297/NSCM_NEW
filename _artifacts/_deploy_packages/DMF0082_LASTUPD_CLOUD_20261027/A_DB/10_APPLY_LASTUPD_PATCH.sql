-- 10_APPLY — [E20261027-DMF0082LASTUPD] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: DMF0082 조회 프로시저 2종(P_DMF0082_GET_MAIN_DATA · P_DMF0082_GET_MAIN_DATA_CURRENT)에서
--       Column Set 에 LAST UPDATED BY / LAST UPDATE DATE 를 넣어도 줄이 갈리지 않게 한다.
--       두 컬럼은 행 키가 아닌 참고값 — 선택한 컬럼의 키마다 수정일이 가장 큰 행의 수정자 · 수정일 한 쌍만 표시,
--       줄 수 · 메저 값은 두 컬럼을 선택하지 않았을 때와 같다. 두 컬럼을 선택하지 않으면 추가 로직은 실행되지 않는다.
-- 배경: 최종 피벗이 결과 컬럼 전체로 묶어, 두 컬럼을 고르면 같은 키가 수정일 · 수정자 조합 수만큼 여러 줄로 나뉘었다 (사용자 요청 2026-10-27).
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어 ASCII 앵커 2곳에 블록을 끼워 넣은 뒤 CREATE OR REPLACE (사내 전체본 복사 아님 — 기존 문장 무변경).
-- 가드: 마커 존재 시 무동작 · 앵커가 각 1건이 아니거나 해당 프로시저 범위 밖이면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 적용 완료 2026-10-27 13:33:46 (같은 블록 · 전후 비교 40케이스 통과). 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_pg    PLS_INTEGER;
    v_pc    PLS_INTEGER;
    v_get_e PLS_INTEGER;
    v_cur_s PLS_INTEGER;
    v_cur_e PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261027-DMF0082LASTUPD';
    c_ag    CONSTANT VARCHAR2(32767) :=   -- 앵커 1: GET_MAIN_DATA 의 숨긴 PLANT_SITE_ID 대표값 MERGE 끝 3줄 (이 뒤에 삽입)
        '        WHEN MATCHED THEN UPDATE SET T.PLANT_SITE_ID = S.REP_PLANT_SITE' || CHR(10) ||
        '        WHERE  NVL(T.PLANT_SITE_ID, ''~'') <> S.REP_PLANT_SITE;' || CHR(10) ||
        '    END IF;' || CHR(10);
    c_ac    CONSTANT VARCHAR2(32767) :=   -- 앵커 2: GET_MAIN_DATA_CURRENT 의 피벗 IN 리스트 빈값 방어 IF 4줄 (이 앞에 삽입)
        '    IF DBMS_LOB.GETLENGTH(V_PV_LIST) = 0 THEN' || CHR(10) ||
        '        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_LIST);     EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
        '        BEGIN DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST); EXCEPTION WHEN OTHERS THEN NULL; END;' || CHR(10) ||
        '        OPEN O_RC1 FOR SELECT NULL AS COL1 FROM DUAL WHERE 1 = 0;' || CHR(10);
    c_bg    CONSTANT VARCHAR2(32767) :=   -- 삽입 1: P_DMF0082_GET_MAIN_DATA (피벗 원천 GT_DMF0082_MF_SP)
        '' || CHR(10) ||
        '    /* [E20261027-DMF0082LASTUPD] Last Updated By · Last Update Date 는 행을 가르는 키가 아니라 참고값 (사용자 요청 2026-10-27).' || CHR(10) ||
        '       Column Set 에서 두 컬럼을 고르면 최종 피벗이 이 값까지 묶어, 수정일 · 수정자가 다른 일자 행이 별도 줄로 갈라졌다' || CHR(10) ||
        '       (두 컬럼 선택 여부에 따라 줄 수 · 메저 값이 달라짐).' || CHR(10) ||
        '       보완: 두 컬럼 중 하나라도 결과 컬럼에 있을 때만, 행 키(최종 피벗이 묶는 컬럼 = V_COLUMN + SORT_ORDER_NO 에서 두 컬럼 제외)마다' || CHR(10) ||
        '       수정일이 가장 큰 행의 수정일 · 수정자 한 쌍으로 그 키의 모든 행을 맞춘다 → 줄 수 · 메저 값은 선택하지 않았을 때와 같다.' || CHR(10) ||
        '       대상 행 = 최종 피벗에 실제로 들어가는 행(아래 동적 SQL 의 WHERE 와 같은 조건). 수정일이 같은 행이 여럿이면 수정자 MAX.' || CHR(10) ||
        '       두 컬럼을 고르지 않으면 실행하지 않는다. 조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */' || CHR(10) ||
        '    IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '',LAST_UPDATED_BY,'') > 0' || CHR(10) ||
        '    OR INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '',LAST_UPDATE_DATE,'') > 0 THEN' || CHR(10) ||
        '        DECLARE' || CHR(10) ||
        '            V_LU_SRC  VARCHAR2(4100 CHAR) := REPLACE(V_COLUMN, '' '', '''') || '',SORT_ORDER_NO'';' || CHR(10) ||
        '            V_LU_COL  VARCHAR2(200 CHAR);' || CHR(10) ||
        '            V_LU_KEYS VARCHAR2(4100 CHAR);' || CHR(10) ||
        '        BEGIN' || CHR(10) ||
        '            FOR I IN 1 .. REGEXP_COUNT(V_LU_SRC, ''[^,]+'') LOOP' || CHR(10) ||
        '                V_LU_COL := REGEXP_SUBSTR(V_LU_SRC, ''[^,]+'', 1, I);' || CHR(10) ||
        '                IF V_LU_COL NOT IN (''LAST_UPDATED_BY'', ''LAST_UPDATE_DATE'', ''CREATE_DATE'')' || CHR(10) ||
        '                AND INSTR('','' || V_LU_KEYS || '','', '','' || V_LU_COL || '','') = 0 THEN' || CHR(10) ||
        '                    V_LU_KEYS := CASE WHEN V_LU_KEYS IS NULL THEN V_LU_COL ELSE V_LU_KEYS || '', '' || V_LU_COL END;' || CHR(10) ||
        '                END IF;' || CHR(10) ||
        '            END LOOP;' || CHR(10) ||
        '            EXECUTE IMMEDIATE' || CHR(10) ||
        '               ''MERGE INTO SCM_MGR.GT_DMF0082_MF_SP T' || CHR(10) ||
        '                USING ( SELECT RID_' || CHR(10) ||
        '                             , MAX(CREATE_DATE) OVER (PARTITION BY '' || V_LU_KEYS || '') AS LU_DATE' || CHR(10) ||
        '                             , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE NULLS FIRST) OVER (PARTITION BY '' || V_LU_KEYS || '') AS LU_BY' || CHR(10) ||
        '                        FROM ( SELECT MSP.ROWID AS RID_, MSP.*, MSP.DEPT_ID AS TEAM_ID, MSP.DEPT_NAME_KO AS TEAM_NAME_KO, MSP.CELL_MODEL AS FORECAST_INFO_CELL_MODEL' || CHR(10) ||
        '                                    , NVL(TO_CHAR(MSP.SUN),''''0'''')||NVL(TO_CHAR(MSP.MON),''''0'''')||NVL(TO_CHAR(MSP.TUE),''''0'''')||NVL(TO_CHAR(MSP.WED),''''0'''')||NVL(TO_CHAR(MSP.THU),''''0'''')||NVL(TO_CHAR(MSP.FRI),''''0'''')||NVL(TO_CHAR(MSP.SAT),''''0'''') AS BUCKET' || CHR(10) ||
        '                               FROM SCM_MGR.GT_DMF0082_MF_SP MSP ) F' || CHR(10) ||
        '                        WHERE ((MEASURE NOT IN (''''SCM_FCST'''',''''FCST_GAP'''') AND QTY <> 0) OR MEASURE IN (''''SCM_FCST'''',''''FCST_GAP'''')) ) S' || CHR(10) ||
        '                ON (T.ROWID = S.RID_)' || CHR(10) ||
        '                WHEN MATCHED THEN UPDATE SET T.CREATE_DATE = S.LU_DATE, T.LAST_UPDATED_BY = S.LU_BY' || CHR(10) ||
        '                WHERE DECODE(T.CREATE_DATE, S.LU_DATE, 0, 1) = 1 OR DECODE(T.LAST_UPDATED_BY, S.LU_BY, 0, 1) = 1'';' || CHR(10) ||
        '        END;' || CHR(10) ||
        '    END IF;' || CHR(10);
    c_bc    CONSTANT VARCHAR2(32767) :=   -- 삽입 2: P_DMF0082_GET_MAIN_DATA_CURRENT (피벗 원천 GTT_MF_SP)
        '' || CHR(10) ||
        '    /* [E20261027-DMF0082LASTUPD] Last Updated By · Last Update Date 는 행을 가르는 키가 아니라 참고값 (사용자 요청 2026-10-27).' || CHR(10) ||
        '       Column Set 에서 두 컬럼을 고르면 최종 피벗이 이 값까지 묶어, 수정일 · 수정자가 다른 일자 행이 별도 줄로 갈라졌다' || CHR(10) ||
        '       (두 컬럼 선택 여부에 따라 줄 수 · 메저 값이 달라짐).' || CHR(10) ||
        '       보완: 두 컬럼 중 하나라도 결과 컬럼에 있을 때만, 행 키(최종 피벗이 묶는 컬럼 = V_COLUMN + SORT_ORDER_NO 에서 두 컬럼 제외)마다' || CHR(10) ||
        '       수정일이 가장 큰 행의 수정일 · 수정자 한 쌍으로 그 키의 모든 행을 맞춘다 → 줄 수 · 메저 값은 선택하지 않았을 때와 같다.' || CHR(10) ||
        '       대상 행 = 최종 피벗에 실제로 들어가는 행(아래 동적 SQL 의 WHERE 와 같은 조건). 수정일이 같은 행이 여럿이면 수정자 MAX.' || CHR(10) ||
        '       두 컬럼을 고르지 않으면 실행하지 않는다. 조회용 임시 테이블의 표시값만 바꾼다 — 원장 · 저장 무변경. */' || CHR(10) ||
        '    IF INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '',LAST_UPDATED_BY,'') > 0' || CHR(10) ||
        '    OR INSTR('','' || REPLACE(V_COLUMN, '' '', '''') || '','', '',LAST_UPDATE_DATE,'') > 0 THEN' || CHR(10) ||
        '        DECLARE' || CHR(10) ||
        '            V_LU_SRC  VARCHAR2(4100 CHAR) := REPLACE(V_COLUMN, '' '', '''') || '',SORT_ORDER_NO'';' || CHR(10) ||
        '            V_LU_COL  VARCHAR2(200 CHAR);' || CHR(10) ||
        '            V_LU_KEYS VARCHAR2(4100 CHAR);' || CHR(10) ||
        '        BEGIN' || CHR(10) ||
        '            FOR I IN 1 .. REGEXP_COUNT(V_LU_SRC, ''[^,]+'') LOOP' || CHR(10) ||
        '                V_LU_COL := REGEXP_SUBSTR(V_LU_SRC, ''[^,]+'', 1, I);' || CHR(10) ||
        '                IF V_LU_COL NOT IN (''LAST_UPDATED_BY'', ''LAST_UPDATE_DATE'', ''CREATE_DATE'')' || CHR(10) ||
        '                AND INSTR('','' || V_LU_KEYS || '','', '','' || V_LU_COL || '','') = 0 THEN' || CHR(10) ||
        '                    V_LU_KEYS := CASE WHEN V_LU_KEYS IS NULL THEN V_LU_COL ELSE V_LU_KEYS || '', '' || V_LU_COL END;' || CHR(10) ||
        '                END IF;' || CHR(10) ||
        '            END LOOP;' || CHR(10) ||
        '            EXECUTE IMMEDIATE' || CHR(10) ||
        '               ''MERGE INTO SCM_MGR.GTT_MF_SP T' || CHR(10) ||
        '                USING ( SELECT F.ROWID AS RID_' || CHR(10) ||
        '                             , MAX(LAST_UPDATE_DATE) KEEP (DENSE_RANK LAST ORDER BY TRIM(LAST_UPDATE_DATE) NULLS FIRST) OVER (PARTITION BY '' || V_LU_KEYS || '') AS LU_DATE' || CHR(10) ||
        '                             , MAX(LAST_UPDATED_BY)  KEEP (DENSE_RANK LAST ORDER BY TRIM(LAST_UPDATE_DATE) NULLS FIRST) OVER (PARTITION BY '' || V_LU_KEYS || '') AS LU_BY' || CHR(10) ||
        '                        FROM SCM_MGR.GTT_MF_SP F' || CHR(10) ||
        '                        WHERE (   (F.MEASURE NOT IN (''''SCM_FCST'''',''''FCST_GAP'''') AND F.QTY <> 0)' || CHR(10) ||
        '                               OR F.MEASURE IN (''''SCM_FCST'''',''''FCST_GAP'''')' || CHR(10) ||
        '                               OR F.MEASURE IN (''''KRW'''',''''USD'''',''''LOC'''') ) ) S' || CHR(10) ||
        '                ON (T.ROWID = S.RID_)' || CHR(10) ||
        '                WHEN MATCHED THEN UPDATE SET T.LAST_UPDATE_DATE = S.LU_DATE, T.LAST_UPDATED_BY = S.LU_BY' || CHR(10) ||
        '                WHERE DECODE(T.LAST_UPDATE_DATE, S.LU_DATE, 0, 1) = 1 OR DECODE(T.LAST_UPDATED_BY, S.LU_BY, 0, 1) = 1'';' || CHR(10) ||
        '        END;' || CHR(10) ||
        '    END IF;' || CHR(10);
    FUNCTION cnt(p_src CLOB, p_tok VARCHAR2) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; pos PLS_INTEGER := 1;
    BEGIN
        LOOP
            pos := DBMS_LOB.INSTR(p_src, p_tok, pos);
            EXIT WHEN pos = 0 OR pos IS NULL;
            n := n + 1; pos := pos + LENGTH(p_tok);
        END LOOP;
        RETURN n;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_src, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_src, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_ag) <> 1 OR cnt(v_src, c_ac) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — 앵커 매칭 GET ' || cnt(v_src, c_ag) || ' · CURRENT ' || cnt(v_src, c_ac) || '건 (각 1 기대). 00_PRECHECK L1 확인. 원문 무변경');
    END IF;
    v_pg    := DBMS_LOB.INSTR(v_src, c_ag);
    v_pc    := DBMS_LOB.INSTR(v_src, c_ac);
    v_get_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO');
    v_cur_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_MAIN_DATA_CURRENT');
    v_cur_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_SPREAD_TITLE');
    IF NOT (v_get_e > 0 AND v_cur_s > 0 AND v_cur_e > 0 AND v_pg < v_get_e AND v_cur_s < v_pc AND v_pc < v_cur_e) THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 앵커 위치가 GET_MAIN_DATA / GET_MAIN_DATA_CURRENT 범위와 다름. 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_pg + LENGTH(c_ag) - 1) || c_bg
          || SUBSTR(v_src, v_pg + LENGTH(c_ag), v_pc - v_pg - LENGTH(c_ag))
          || c_bc || CHR(10)
          || SUBSTR(v_src, v_pc);
    IF cnt(v_new, c_mark) <> 2 OR cnt(v_new, c_ag || c_bg) <> 1 OR cnt(v_new, c_bc || CHR(10) || c_ac) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 불일치 (마커 ' || cnt(v_new, c_mark) || '곳, 2 기대). 원문 무변경');
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20005, '컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함. 90_VERIFY 로 STATUS 확인');
    END IF;
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 마커 ' || cnt(v_new, c_mark) || '곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
