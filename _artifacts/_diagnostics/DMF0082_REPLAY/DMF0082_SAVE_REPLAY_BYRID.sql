/*=============================================================================================================
 * DMF0082 저장 재실행 — 로그 행 직접 참조형 (Oracle SQL Developer · 전체 선택 후 F5)
 *   파일에 값을 담지 않는다. SCM_MGR.SCM_COM_SQL_LOG.PARAMS(BE call-proc 파라미터 JSON) 를 실행 시점에 읽어
 *   17 CLOB 로 꺼내 SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA 를 호출한다.
 *   → 생성 파일 크기 한계(SQL Developer DBMS_OUTPUT/SPOOL 약 1MB 절단, 2026-10-21) 와 무관. 대용량 저장 재현의 1순위 경로.
 *
 * 사용 순서
 *   1) 그대로 F5 (GO='N')  → 대상 건(RID · 실행시각 · 실행자 · 파라미터별 길이)만 출력. SP 는 호출하지 않는다.
 *   2) 출력된 대상이 맞으면  DEFINE GO = 'Y'  로 바꿔 다시 F5 → 실제 저장 SP 호출(내부 COMMIT · _H 이력 추가). QA 에서만.
 *   · RID 빈값 = 직전 저장 1건 자동 탐지 (SP 로그 START/END 시각 → BE 로그 PK 범위 이진 탐색 · 테이블 크기 무관 수 초)
 *   · 다른 건 = DEFINE RID 에 SCM_COM_SQL_LOG 의 ROWID
 *   · PARAMS 가 4,000자에서 절단된 건('(truncated' 포함)은 실행 불가 → DevTools Payload + Make-Dmf0082ReplaySql.ps1
 *   · 로그 행이 지워지면 재실행할 수 없다. 보존이 필요하면 Make-Dmf0082Replay-FromLog.sql 로 값 포함 파일을 따로 생성.
 *=============================================================================================================*/
SET DEFINE ON
DEFINE RID = ''        -- 예: DEFINE RID = 'AAAbCdAAEAAAAgvAAB'   (빈값 = 최근 1건)
DEFINE GO  = 'N'       -- 'Y' 로 바꾸면 실제 저장 SP 호출
SET VERIFY OFF
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_rid       VARCHAR2(40) := NULLIF('&&RID', '');
    v_go        VARCHAR2(1)  := UPPER(SUBSTR(NVL('&&GO', 'N'), 1, 1));
    v_json      CLOB;
    v_exec_time DATE;
    v_user      VARCHAR2(100);
    v_obj       JSON_OBJECT_T;
    v_sp_start  DATE;
    v_sp_end    DATE;
    v_sp_user   VARCHAR2(100);
    v_win_st    DATE;
    v_win_en    DATE;
    v_seq_lo    NUMBER;
    v_seq_hi    NUMBER;
    v_sel_rid   VARCHAR2(40);
    v_tried     PLS_INTEGER := 0;   -- 훑은 SP 저장 START 건수
    v_t0        TIMESTAMP;
    o_rc        SYS_REFCURSOR;
    v_code      VARCHAR2(10);
    v_msg       VARCHAR2(4000);
    v_evt       VARCHAR2(4000);

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

    -- PK(LOG_SEQ) 이진 탐색: p_dt 이후 첫 LOG_SEQ (EXECUTE_TIME 인덱스 없음 → 시간 조건 전체 스캔 회피)
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
    -- 값 추출 = JSON_OBJECT_T.get_Clob (JSON_VALUE VARCHAR2(4000) 은 4,000자 초과 값을 NULL 로 돌림)
    FUNCTION jv(p_k1 IN VARCHAR2, p_k2 IN VARCHAR2) RETURN CLOB IS
    BEGIN
        IF v_obj.has(p_k1) THEN RETURN v_obj.get_Clob(p_k1); END IF;
        IF v_obj.has(p_k2) THEN RETURN v_obj.get_Clob(p_k2); END IF;
        RETURN NULL;
    END jv;
    FUNCTION jlen(p_k1 IN VARCHAR2, p_k2 IN VARCHAR2) RETURN VARCHAR2 IS
        c CLOB;
    BEGIN
        IF NOT (v_obj.has(p_k1) OR v_obj.has(p_k2)) THEN RETURN '없음→NULL'; END IF;
        c := jv(p_k1, p_k2);
        RETURN 'len=' || NVL(DBMS_LOB.GETLENGTH(c), 0) || ' / 앞 60자 [' || DBMS_LOB.SUBSTR(c, 60, 1) || ']';
    END jlen;
    PROCEDURE o(s IN VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END o;
BEGIN
    IF v_rid IS NULL THEN
        -- (1) SP 내부 로그의 저장 START 를 최신순으로 20건까지 훑으며, BE 로그(call-proc 저장 행)가 실재하는 첫 건을 고른다.
        --     SQL Developer 직접 호출(이 파일의 GO=Y 실행 포함)·배치 호출은 SP 로그만 있고 BE 로그가 없어 건너뛴다.
        FOR r IN ( SELECT * FROM ( SELECT B.CREATION_DATE AS SP_START, B.CREATED_BY
                                   FROM   SCM_MGR.SCM_SYS_LOG_BATCH B
                                   WHERE  B.PROGRAM_NAME = 'PKG_DMF0082' AND B.LOG_TYPE = 'START'
                                   AND    B.IN_PARA_DATA LIKE '%p_active_flag%' AND B.CREATION_DATE >= SYSDATE - 60
                                   ORDER BY B.CREATION_DATE DESC )
                   WHERE ROWNUM <= 20 ) LOOP
            v_tried    := v_tried + 1;
            v_sp_start := r.SP_START;
            v_sp_user  := r.CREATED_BY;
            -- (2) END/ERROR 시각 → BE 로그는 종료 시각에 기록되므로 그 주변이 탐색창
            SELECT MIN(E.CREATION_DATE) INTO v_sp_end
            FROM   SCM_MGR.SCM_SYS_LOG_BATCH E
            WHERE  E.PROGRAM_NAME = 'PKG_DMF0082' AND E.LOG_TYPE IN ('END','ERROR')
            AND    E.CREATED_BY = v_sp_user AND E.CREATION_DATE >= v_sp_start AND E.CREATION_DATE < v_sp_start + 1;
            IF v_sp_end IS NULL THEN v_win_st := v_sp_start - 1/1440; v_win_en := v_sp_start + 3/24;
            ELSE                     v_win_st := v_sp_end - 1/1440;   v_win_en := v_sp_end + 5/1440;   END IF;
            -- (3) PK 범위
            v_seq_lo := f_seq_at(v_win_st - 10/1440);
            v_seq_hi := f_seq_at(v_win_en + 10/1440);
            -- (4) 범위 안의 callProc 행 중 DMF0082 저장 — 저장 SP 이름 또는 저장 키(activeFlag)가 있는 행만 인정
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
        o('-- !! 탐색창 안에 DMF0082 저장 call-proc 로그가 없습니다. RID 를 직접 DEFINE RID 에 지정하세요.');
        RETURN;
    END IF;
    IF DBMS_LOB.INSTR(v_json, '(truncated') > 0 THEN
        o('-- !! PARAMS 가 4,000자에서 절단된 저장입니다. 재실행 불가 → DevTools Payload + Make-Dmf0082ReplaySql.ps1');
        RETURN;
    END IF;
    BEGIN
        v_obj := JSON_OBJECT_T.parse(v_json);
    EXCEPTION WHEN OTHERS THEN
        o('-- !! PARAMS 가 올바른 JSON 이 아닙니다(' || SUBSTR(SQLERRM, 1, 200) || '). 길이 ' || DBMS_LOB.GETLENGTH(v_json));
        RETURN;
    END;

    o('-- 대상: 로그 RID ' || v_sel_rid || ' / 원본 실행시각 ' || TO_CHAR(v_exec_time, 'YYYY-MM-DD HH24:MI:SS')
      || ' / 실행자 ' || v_user || ' / PARAMS ' || DBMS_LOB.GETLENGTH(v_json) || '자');
    FOR i IN 1 .. v_map.COUNT LOOP
        o('--   ' || RPAD(v_map(i).sp, 22) || ' ' || jlen(v_map(i).k1, v_map(i).k2));
    END LOOP;

    IF v_go <> 'Y' THEN
        o('-- GO=N : SP 를 호출하지 않았습니다. 위 대상이 맞으면 DEFINE GO = ''Y'' 로 바꿔 다시 실행하세요.');
        RETURN;
    END IF;

    o('-- GO=Y : SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA 호출 시작 ' || TO_CHAR(SYSDATE, 'HH24:MI:SS'));
    v_t0 := SYSTIMESTAMP;
    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(
          p_active_flag       => jv('activeFlag',     'p_active_flag')
        , p_division_id       => jv('divisionId',     'p_division_id')
        , p_project_code      => jv('projectCode',    'p_project_code')
        , p_end_customer      => jv('endCustomer',    'p_end_customer')
        , p_scm_site_id       => jv('scmSiteId',      'p_scm_site_id')
        , p_item_id           => jv('itemId',         'p_item_id')
        , p_dom_exp           => jv('domExp',         'p_dom_exp')
        , p_fcst_type         => jv('fcstType',       'p_fcst_type')
        , p_incoterms         => jv('incoterms',      'p_incoterms')
        , p_measure           => jv('measure',        'p_measure')
        , p_plant_site_id     => jv('plantSite',      'p_plant_site_id')
        , p_cell_prod_site_id => jv('cellProdSiteId', 'p_cell_prod_site_id')
        , p_yyyymmdd          => jv('yyyymmdd',       'p_yyyymmdd')
        , p_currency          => jv('currency',       'p_currency')
        , p_qty               => jv('qty',            'p_qty')
        , p_created_by        => jv('createdBy',      'p_created_by')
        , p_as_from_site      => jv('asFromSite',     'p_as_from_site')
        , O_RESULT_CURSOR     => o_rc
    );
    FETCH o_rc INTO v_code, v_msg, v_evt;
    CLOSE o_rc;
    o('RESULT_CODE=' || v_code || ' / RESULT_MSG=' || v_msg || ' / EVENT=' || v_evt
      || ' / 소요 ' || TO_CHAR(SYSTIMESTAMP - v_t0));
END;
/
UNDEFINE RID
UNDEFINE GO
SET DEFINE OFF
