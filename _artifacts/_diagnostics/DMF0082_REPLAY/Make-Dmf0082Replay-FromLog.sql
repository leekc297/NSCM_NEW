/*=============================================================================================================
 * DMF0082 저장 로그 → 실행용 재실행 .sql 파일 직접 생성 (Oracle SQL Developer · [생성] 부터 끝까지 선택 후 F5)
 *   원천 = SCM_MGR.SCM_COM_SQL_LOG.PARAMS (BE call-proc 파라미터 JSON) → 17 CLOB 파라미터 → SP 호출 블록을 CLOB 로 조립 → SPOOL 파일
 *   결과 = D:\Downloads\Source\DMF0082_REPLAY\DMF0082_SAVE_REPLAY_fromlog.sql  (SQL Developer 에서 열어 F5 로 실행)
 *
 *   · 기본 = 직전 저장 1건 자동 탐지(SP 로그 START/END 시각 → BE 로그 PK 범위 이진 탐색, 테이블 크기 무관 수 초).
 *   · 다른 건을 원하면 DEFINE RID 에 SCM_COM_SQL_LOG 의 ROWID 를 넣는다.
 *   · PARAMS 가 4,000자에서 절단된 건은 파일에 안내 1줄만 남고 생성되지 않는다
 *     → 그 건은 저장 당시 DevTools Payload 로만 복원 가능 (Make-Dmf0082ReplaySql.ps1).
 *   · 생성된 파일은 실제 저장 SP 를 호출한다(내부 COMMIT · _H 이력 추가). QA 에서만 실행.
 *   · 출력 방식 = DBMS_OUTPUT 을 쓰지 않는다. (SQL Developer 의 DBMS_OUTPUT 버퍼 한계 1,000,000 바이트에서 파일이 잘리던 사고
 *     2026-10-21) 결과 전체를 바인드 변수 CLOB 에 담아 SELECT 로 SPOOL 하므로 크기 제한 없이 끝까지 기록된다.
 *   · 완전성: 생성 파일의 마지막 줄 = '-- EOF 줄수=N'. 그 줄이 있으면 완전한 파일이다.
 *=============================================================================================================*/

-- [확인] 직전 저장 1건 (SP 내부 로그 · 작은 테이블 · 즉시) — 생성 전 "이 건이 맞는지" 눈으로 확인용. 생략 가능
SELECT  TO_CHAR(B.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS SP_START, B.CREATED_BY, B.LOG_COUNT
      , REGEXP_SUBSTR(B.IN_PARA_DATA, '"rows":(\d+)', 1, 1, NULL, 1) AS ROWS_SENT
      , SUBSTR(B.IN_PARA_DATA, 1, 300) AS IN_PARA_HEAD
FROM    SCM_MGR.SCM_SYS_LOG_BATCH B
WHERE   B.PROGRAM_NAME = 'PKG_DMF0082' AND B.LOG_TYPE = 'START'
AND     B.IN_PARA_DATA LIKE '%p_active_flag%' AND B.CREATION_DATE >= SYSDATE - 60
ORDER BY B.CREATION_DATE DESC
FETCH FIRST 1 ROWS ONLY;

-- [생성] 여기부터 끝까지 선택 후 F5
SET DEFINE ON
DEFINE RID = ''        -- 예: DEFINE RID = 'AAAbCdAAEAAAAgvAAB'   (빈값 = 최근 1건)
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT OFF
VARIABLE out CLOB
DECLARE
    v_rid       VARCHAR2(40) := NULLIF('&&RID', '');   -- 빈값 = 최근 1건
    v_out       CLOB;                                   -- 생성 결과 전체 (DBMS_OUTPUT 대신)
    v_json      CLOB;
    v_exec_time DATE;
    v_user      VARCHAR2(100);
    c_chunk     CONSTANT PLS_INTEGER := 2000;
    v_val       CLOB;
    v_obj       JSON_OBJECT_T;
    v_pos       PLS_INTEGER;
    v_sp_start  DATE;
    v_sp_end    DATE;
    v_sp_user   VARCHAR2(100);
    v_win_st    DATE;
    v_win_en    DATE;
    v_seq_lo    NUMBER;
    v_seq_hi    NUMBER;
    v_sel_rid   VARCHAR2(40);
    v_lines     PLS_INTEGER := 0;   -- 출력 줄수(완전성 확인용 · 마지막 줄 '-- EOF 줄수=N' 에 기록)
    v_tried     PLS_INTEGER := 0;   -- 훑은 SP 저장 START 건수
    e_stop      EXCEPTION;          -- 생성 중단(안내 1줄만 출력)

    TYPE t_pair IS RECORD (sp VARCHAR2(30), k1 VARCHAR2(30), k2 VARCHAR2(30));
    TYPE t_pairs IS TABLE OF t_pair;
    v_map t_pairs := t_pairs(
        t_pair('p_active_flag',       'activeFlag',     'p_active_flag'),
        t_pair('p_division_id',       'divisionId',     'p_division_id'),
        t_pair('p_project_code',      'projectCode',    'p_project_code'),
        t_pair('p_end_customer',      'endCustomer',    'p_end_customer'),
        t_pair('p_scm_site_id',       'scmSiteId',      'p_scm_site_id'),
        t_pair('p_item_id',           'itemId',         'p_item_id'),
        t_pair('p_dom_exp',           'domExp',         'p_dom_exp'),
        t_pair('p_fcst_type',         'fcstType',       'p_fcst_type'),
        t_pair('p_incoterms',         'incoterms',      'p_incoterms'),
        t_pair('p_measure',           'measure',        'p_measure'),
        t_pair('p_plant_site_id',     'plantSite',      'p_plant_site_id'),
        t_pair('p_cell_prod_site_id', 'cellProdSiteId', 'p_cell_prod_site_id'),
        t_pair('p_yyyymmdd',          'yyyymmdd',       'p_yyyymmdd'),
        t_pair('p_currency',          'currency',       'p_currency'),
        t_pair('p_qty',               'qty',            'p_qty'),
        t_pair('p_created_by',        'createdBy',      'p_created_by'),
        t_pair('p_as_from_site',      'asFromSite',     'p_as_from_site'));


    -- PK(LOG_SEQ) 이진 탐색: p_dt 이후 첫 LOG_SEQ. SCM_COM_SQL_LOG 는 EXECUTE_TIME 인덱스가 없어(PK 만) 시간 조건 전체 스캔이
    -- 클라우드에서 끝나지 않던 문제를 피한다. EXECUTE_TIME ≈ LOG_SEQ 단조 증가 전제 · 호출측에서 ±10분 여유.
    FUNCTION f_seq_at(p_dt IN DATE) RETURN NUMBER IS
        lo NUMBER; hi NUMBER; mid NUMBER; s NUMBER; d DATE; n PLS_INTEGER := 0;
    BEGIN
        SELECT MIN(LOG_SEQ), MAX(LOG_SEQ) INTO lo, hi FROM SCM_MGR.SCM_COM_SQL_LOG;
        IF lo IS NULL THEN RETURN NULL; END IF;
        WHILE lo < hi AND n < 60 LOOP
            n := n + 1;
            mid := TRUNC((lo + hi) / 2);
            BEGIN
                SELECT LOG_SEQ, CAST(EXECUTE_TIME AS DATE) INTO s, d
                FROM ( SELECT LOG_SEQ, EXECUTE_TIME FROM SCM_MGR.SCM_COM_SQL_LOG
                       WHERE LOG_SEQ >= mid ORDER BY LOG_SEQ )
                WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN hi := mid - 1; CONTINUE;
            END;
            IF d < p_dt THEN lo := s + 1; ELSE hi := s; END IF;
        END LOOP;
        RETURN lo;
    END f_seq_at;
    -- 값 추출 = JSON_OBJECT_T.get_Clob (JSON_VALUE RETURNING VARCHAR2(4000) 은 4,000자 초과 값을 NULL 로 돌려 빈 파일이 되던 사고 2026-10-21)
    FUNCTION has_key(p_k1 IN VARCHAR2, p_k2 IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN
        RETURN v_obj.has(p_k1) OR v_obj.has(p_k2);
    END has_key;
    FUNCTION jv(p_k1 IN VARCHAR2, p_k2 IN VARCHAR2) RETURN CLOB IS
    BEGIN
        IF v_obj.has(p_k1) THEN RETURN v_obj.get_Clob(p_k1); END IF;
        IF v_obj.has(p_k2) THEN RETURN v_obj.get_Clob(p_k2); END IF;
        RETURN NULL;
    END jv;
    -- 한 줄 출력 = 결과 CLOB 에 덧붙임 (DBMS_OUTPUT 미사용)
    PROCEDURE o(s IN VARCHAR2) IS
    BEGIN
        v_lines := v_lines + 1;
        DBMS_LOB.WRITEAPPEND(v_out, LENGTH(s) + 1, s || CHR(10));
    END o;
    FUNCTION esc(s IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REPLACE(REPLACE(REPLACE(s, '''', ''''''), CHR(13), '''||CHR(13)||'''), CHR(10), '''||CHR(10)||''');
    END esc;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_out, TRUE);
    IF v_rid IS NULL THEN
        -- (1) SP 내부 로그의 저장 START 를 최신순으로 20건까지 훑으며, BE 로그(call-proc 저장 행)가 실재하는 첫 건을 고른다.
        --     SQL Developer 직접 호출(BYRID 등)·배치 호출은 SP 로그만 있고 BE 로그가 없어 건너뛴다.
        --     (10-21 사고: 직접 호출 건의 창에서 "가장 가까운 같은 사용자 행" 으로 물러서다 조회 call-proc 을 잡아 파라미터 전부 '없음')
        FOR r IN ( SELECT * FROM ( SELECT B.CREATION_DATE AS SP_START, B.CREATED_BY
                                   FROM   SCM_MGR.SCM_SYS_LOG_BATCH B
                                   WHERE  B.PROGRAM_NAME = 'PKG_DMF0082' AND B.LOG_TYPE = 'START'
                                   AND    B.IN_PARA_DATA LIKE '%p_active_flag%' AND B.CREATION_DATE >= SYSDATE - 60
                                   ORDER BY B.CREATION_DATE DESC )
                   WHERE ROWNUM <= 20 ) LOOP
            v_tried    := v_tried + 1;
            v_sp_start := r.SP_START;
            v_sp_user  := r.CREATED_BY;
            -- (2) 그 저장의 END/ERROR 시각 → BE 로그는 종료 시각에 기록되므로 그 주변 몇 분이 탐색창
            SELECT MIN(E.CREATION_DATE) INTO v_sp_end
            FROM   SCM_MGR.SCM_SYS_LOG_BATCH E
            WHERE  E.PROGRAM_NAME = 'PKG_DMF0082' AND E.LOG_TYPE IN ('END','ERROR')
            AND    E.CREATED_BY = v_sp_user AND E.CREATION_DATE >= v_sp_start AND E.CREATION_DATE < v_sp_start + 1;
            IF v_sp_end IS NULL THEN v_win_st := v_sp_start - 1/1440; v_win_en := v_sp_start + 3/24;   -- END 없음(타임아웃 등) = 3시간
            ELSE                     v_win_st := v_sp_end - 1/1440;   v_win_en := v_sp_end + 5/1440;   END IF;
            -- (3) PK 범위 (이진 탐색 · 테이블 크기 무관 수십 회 인덱스 조회)
            v_seq_lo := f_seq_at(v_win_st - 10/1440);
            v_seq_hi := f_seq_at(v_win_en + 10/1440);
            -- (4) 그 범위의 callProc 행 중 DMF0082 저장 — 저장 SP 이름 또는 저장 키(activeFlag)가 있는 행만 인정
            BEGIN
                SELECT RID, PARAMS, EXECUTE_TIME, CREATED_BY INTO v_sel_rid, v_json, v_exec_time, v_user
                FROM  ( SELECT ROWIDTOCHAR(L.ROWID) AS RID, L.PARAMS, L.EXECUTE_TIME, L.CREATED_BY
                        FROM   SCM_MGR.SCM_COM_SQL_LOG L
                        WHERE  L.LOG_SEQ BETWEEN v_seq_lo AND v_seq_hi
                        AND    L.SQL_ID = 'com.lgcns.nscm.callProc'
                        AND    L.EXECUTE_TIME BETWEEN v_win_st AND v_win_en
                        AND    L.CREATED_BY = v_sp_user
                        AND    (   DBMS_LOB.INSTR(UPPER(L.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0
                                OR DBMS_LOB.INSTR(L.PARAMS, '"activeFlag"') > 0
                                OR DBMS_LOB.INSTR(L.PARAMS, '"p_active_flag"') > 0 )
                        ORDER BY ABS(CAST(L.EXECUTE_TIME AS DATE) - NVL(v_sp_end, v_sp_start)), L.EXECUTE_TIME DESC )
                WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN v_json := NULL;
            END;
            EXIT WHEN v_json IS NOT NULL;
        END LOOP;
        o('-- 탐색: SP START ' || NVL(TO_CHAR(v_sp_start,'YYYY-MM-DD HH24:MI:SS'),'없음') || ' / END ' || NVL(TO_CHAR(v_sp_end,'HH24:MI:SS'),'없음')
          || ' / user ' || NVL(v_sp_user,'-') || ' / 창 ' || TO_CHAR(v_win_st,'MM-DD HH24:MI') || '~' || TO_CHAR(v_win_en,'MM-DD HH24:MI')
          || ' / LOG_SEQ ' || v_seq_lo || '..' || v_seq_hi
          || CASE WHEN v_json IS NOT NULL AND v_tried > 1 THEN ' / BE 로그 없는 SP 저장 ' || (v_tried - 1) || '건 건너뜀(직접 호출·배치)' END);
    ELSE
        SELECT ROWIDTOCHAR(ROWID), PARAMS, EXECUTE_TIME, CREATED_BY INTO v_sel_rid, v_json, v_exec_time, v_user
        FROM   SCM_MGR.SCM_COM_SQL_LOG WHERE ROWID = CHARTOROWID(v_rid);
    END IF;

    IF v_json IS NULL THEN
        o('-- !! 탐색창 안에 DMF0082 저장 call-proc 로그가 없습니다. BE 로그(SCM_COM_SQL_LOG) 미기록 건이거나 SP 로그 시각과 어긋난 경우 — RID 를 직접 DEFINE RID 에 지정하세요.');
        RAISE e_stop;
    END IF;
    IF DBMS_LOB.INSTR(v_json, '(truncated') > 0 THEN
        o('-- !! PARAMS 가 4,000자에서 절단된 저장입니다. 이 파일은 사용할 수 없습니다. DevTools Payload + Make-Dmf0082ReplaySql.ps1 로 생성하세요.');
        RAISE e_stop;
    END IF;
    BEGIN
        v_obj := JSON_OBJECT_T.parse(v_json);
    EXCEPTION WHEN OTHERS THEN
        o('-- !! PARAMS 가 올바른 JSON 이 아닙니다(' || SUBSTR(SQLERRM, 1, 200) || '). 길이 ' || DBMS_LOB.GETLENGTH(v_json) || ' — 절단/손상 건은 DevTools Payload 로 생성하세요.');
        RAISE e_stop;
    END;

    o('/*==============================================================================================');
    o(' * DMF0082 저장 재실행 스크립트 (SCM_COM_SQL_LOG 에서 자동 생성)');
    o(' * 원본 실행시각 : ' || TO_CHAR(v_exec_time, 'YYYY-MM-DD HH24:MI:SS') || ' / 실행자 ' || v_user || ' / 로그 RID ' || v_sel_rid);
    o(' * 생성시각      : ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    o(' * ⚠ 실제 저장 SP 호출(내부 COMMIT · _H 이력 추가)');
    o(' *==============================================================================================*/');
    o('SET DEFINE OFF');
    o('SET SERVEROUTPUT ON SIZE UNLIMITED');
    o('DECLARE');
    FOR i IN 1 .. v_map.COUNT LOOP o('    ' || RPAD(v_map(i).sp, 22) || ' CLOB;'); END LOOP;
    o('    o_rc                   SYS_REFCURSOR;');
    o('    v_code                 VARCHAR2(10);');
    o('    v_msg                  VARCHAR2(4000);');
    o('    v_evt                  VARCHAR2(4000);');
    o('    v_t0                   TIMESTAMP;');
    o('    PROCEDURE ap(c IN OUT NOCOPY CLOB, s IN VARCHAR2) IS');
    o('    BEGIN IF s IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(s), s); END IF; END ap;');
    o('BEGIN');
    FOR i IN 1 .. v_map.COUNT LOOP
        IF NOT has_key(v_map(i).k1, v_map(i).k2) THEN
            o('    -- ' || v_map(i).sp || ' : 페이로드에 없음 → NULL');
        ELSE
            v_val := jv(v_map(i).k1, v_map(i).k2);
            o('    DBMS_LOB.CREATETEMPORARY(' || v_map(i).sp || ', TRUE);');
            v_pos := 1;
            WHILE v_pos <= NVL(DBMS_LOB.GETLENGTH(v_val), 0) LOOP
                o('    ap(' || v_map(i).sp || ', ''' || esc(DBMS_LOB.SUBSTR(v_val, c_chunk, v_pos)) || ''');');
                v_pos := v_pos + c_chunk;
            END LOOP;
            o('    -- ' || v_map(i).sp || ' len=' || NVL(DBMS_LOB.GETLENGTH(v_val), 0));
        END IF;
    END LOOP;
    o('    v_t0 := SYSTIMESTAMP;');
    o('    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(');
    FOR i IN 1 .. v_map.COUNT LOOP
        o('        ' || CASE WHEN i = 1 THEN '  ' ELSE ', ' END || RPAD(v_map(i).sp, 22) || ' => ' || v_map(i).sp);
    END LOOP;
    o('        , O_RESULT_CURSOR        => o_rc');
    o('    );');
    o('    FETCH o_rc INTO v_code, v_msg, v_evt;');
    o('    CLOSE o_rc;');
    o('    DBMS_OUTPUT.PUT_LINE(''RESULT_CODE='' || v_code || '' / RESULT_MSG='' || v_msg || '' / EVENT='' || v_evt || '' / 소요 '' || TO_CHAR(SYSTIMESTAMP - v_t0));');
    o('END;');
    o('/');
    o('-- EOF 줄수=' || (v_lines + 1) || ' (이 줄 포함) · 이 줄이 파일 끝에 있으면 완전한 파일');
    :out := v_out;
EXCEPTION
    WHEN e_stop THEN :out := v_out;
END;
/
SET HEADING OFF
SET PAGESIZE 0
SET LINESIZE 32767
SET LONG 2000000000
SET LONGCHUNKSIZE 32767
SET TRIMSPOOL ON
SET TRIMOUT ON
SPOOL D:\Downloads\Source\DMF0082_REPLAY\DMF0082_SAVE_REPLAY_fromlog.sql
SELECT :out FROM DUAL;
SPOOL OFF
SET HEADING ON
SET FEEDBACK ON
SET PAGESIZE 50
UNDEFINE RID
SET DEFINE OFF
PROMPT 생성 완료: D:\Downloads\Source\DMF0082_REPLAY\DMF0082_SAVE_REPLAY_fromlog.sql
PROMPT   · 첫 줄이 '-- !!' = 절단/미기록 건(사용 불가)   · 마지막 줄이 '-- EOF 줄수=N' 이면 완전한 파일
