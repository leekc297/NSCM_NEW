/*=============================================================================================================
 * DMF0082 저장(P_DMF0082_SAVE_MAIN_DATA) — 클라우드 최근 실행 기준 재실행(REPLAY) 쿼리 세트
 * 작성 2026-10-21 · 대상 = 클라우드 Oracle(SCM_MGR) · 실행 도구 = Oracle SQL Developer
 *
 * 로그 3곳과 보존 범위 (BE/SP 원문 실측)
 *   ① SCM_MGR.SCM_COM_SQL_LOG   : BE QueryLogInterceptor. SQL_ID='com.lgcns.nscm.callProc',
 *                                 PARAMS = MyBatis 파라미터 맵 JSON (17 IN 파라미터 원문) — 단, 4,000자 초과분은 절단
 *                                 ("...(truncated, total=N)" 꼬리표가 붙음)
 *   ② SCM_MGR.SCM_COM_SYS_LOG   : BE SystemLogAspect. SYS_LOG_MSG_CTN = 컨트롤러 인자 JSON 4,000B 절단, 버튼/메뉴/소요시간
 *   ③ SCM_MGR.SCM_SYS_LOG_BATCH : SP 내부 PR_DM_SYS_LOG_BATCH. PROGRAM_NAME='PKG_DMF0082',
 *                                 IN_PARA_DATA = 파라미터별 앞 50자 + rows 건수 (재실행 원문으로는 부족)
 *   → 재실행 원문은 ① 에서만 복원 가능. ① 이 절단(truncated)된 저장은 어떤 로그로도 전체 페이로드 복원 불가(§4 참조).
 *
 * ⚠ §3 재실행 블록은 실제 저장 SP 를 다시 호출한다(SP 내부 COMMIT · DM_PLN_MKT_FCST / DM_PLN_CFM_* / SCM_MST_FUTURE_PRICE
 *   갱신 + _H 이력 행 추가). 동일 페이로드 재실행이라 본표 값은 동일하게 수렴하지만 이력 행은 한 번 더 쌓인다.
 *=============================================================================================================*/

--------------------------------------------------------------------------------------------------------------
-- §1. 최근 DMF0082 저장 호출 찾기 (BE SQL 로그) — 어느 건을 재실행할지 RID 로 특정
--------------------------------------------------------------------------------------------------------------
SELECT  L.ROWID                                    AS RID
      , TO_CHAR(L.EXECUTE_TIME,'YYYY-MM-DD HH24:MI:SS') AS EXECUTE_TIME
      , L.ELAPSED_MS
      , L.CREATED_BY
      , L.RESULT_COUNT
      , L.EXCEPTION
      , DBMS_LOB.GETLENGTH(L.PARAMS)               AS PARAMS_LEN
      , CASE WHEN DBMS_LOB.INSTR(L.PARAMS, '(truncated') > 0 THEN 'Y' ELSE 'N' END AS TRUNCATED_YN
      , DBMS_LOB.SUBSTR(L.PARAMS, 300, 1)          AS PARAMS_HEAD
FROM    SCM_MGR.SCM_COM_SQL_LOG L
WHERE   L.EXECUTE_TIME >= SYSDATE - 1
AND     L.SQL_ID = 'com.lgcns.nscm.callProc'
AND     L.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 500000   -- PK 범위 선필터(EXECUTE_TIME 인덱스 없음 · 1.2M행 전수 CLOB 검사 회피)
AND     DBMS_LOB.INSTR(UPPER(L.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0
ORDER BY L.EXECUTE_TIME DESC;

--------------------------------------------------------------------------------------------------------------
-- §2. 같은 시각 SP 내부 로그 (START/ING/END/ERROR · rows 건수 · 검증 실패 메시지)
--------------------------------------------------------------------------------------------------------------
SELECT  B.LOG_TYPE, B.LOG_COUNT, B.LOG_MESSAGE, B.DESCRIPTION
      , B.SQL_ERR_CODE, B.SQL_ERR_MSG, B.SQL_BACKTRACE
      , B.IN_PARA_DATA                                   -- {"rows":N,"p_active_flag":"앞50자",...}
      , B.CREATED_BY
      , TO_CHAR(B.CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
FROM    SCM_MGR.SCM_SYS_LOG_BATCH B
WHERE   B.CREATION_DATE >= SYSDATE - 1
AND     B.PROGRAM_NAME = 'PKG_DMF0082'
ORDER BY B.CREATION_DATE DESC, B.EVENT_DATE DESC;

-- (선택) BE 시스템 로그: 버튼·메뉴·구간별 소요시간·예외
SELECT  S.MNU_ID, S.SHT_NM, S.MNU_BTN_CD, S.CREATED_BY, S.RQR_CLNT_IP
      , TO_CHAR(S.TRNM_ST_DTM,'HH24:MI:SS.FF3') AS SVR_ST, TO_CHAR(S.TRNM_END_DTM,'HH24:MI:SS.FF3') AS SVR_END
      , TO_CHAR(S.DB_TRNM_ST_DTM,'HH24:MI:SS.FF3') AS DB_ST, TO_CHAR(S.DB_TRNM_END_DTM,'HH24:MI:SS.FF3') AS DB_END
      , S.EXCT_MSG_CTN
      , SUBSTR(S.SYS_LOG_MSG_CTN, 1, 300) AS MSG_HEAD
FROM    SCM_MGR.SCM_COM_SYS_LOG S
WHERE   S.CREATION_DATE >= SYSDATE - 1
AND     S.MNU_ID = 'DMF0082'
ORDER BY S.CREATION_DATE DESC;

--------------------------------------------------------------------------------------------------------------
-- §3. 재실행(REPLAY) — SQL Developer 에서 F5(스크립트 실행) · DBMS Output 창 ON
--     최근 1건(§1 첫 행)의 PARAMS JSON 을 그대로 17개 IN 파라미터로 풀어 SP 를 다시 호출한다.
--     특정 건을 지정하려면 아래 v_rid 에 §1 의 RID 값을 넣는다 (NULL 이면 최근 1건).
--------------------------------------------------------------------------------------------------------------
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_rid            VARCHAR2(40) := NULL;     -- 예: 'AAAbCdAAEAAAAgvAAB'  (§1 RID)
    v_json           CLOB;
    v_exec_time      DATE;
    v_truncated      NUMBER;
    v_obj            JSON_OBJECT_T;

    p_active_flag        CLOB;  p_division_id        CLOB;  p_project_code     CLOB;  p_end_customer  CLOB;
    p_scm_site_id        CLOB;  p_item_id            CLOB;  p_dom_exp          CLOB;  p_fcst_type     CLOB;
    p_incoterms          CLOB;  p_measure            CLOB;  p_plant_site_id    CLOB;  p_cell_prod_site_id CLOB;
    p_yyyymmdd           CLOB;  p_currency           CLOB;  p_qty              CLOB;  p_created_by    CLOB;
    p_as_from_site       CLOB;
    o_rc                 SYS_REFCURSOR;
    v_code               VARCHAR2(10);
    v_msg                VARCHAR2(4000);
    v_evt                VARCHAR2(4000);

    -- PARAMS JSON 키 = SCM_ADM_PROC_M.COL_NM (activeFlag … asFromSite, camelCase · Doc/tobefacts/db/proc_params.csv 실측)
    -- 예비로 SP 파라미터명(p_active_flag) 표기도 수용
    FUNCTION jv(p_key IN VARCHAR2, p_alt IN VARCHAR2) RETURN CLOB IS
    BEGIN
        -- JSON_OBJECT_T.get_Clob = 값 길이 제한 없음 (JSON_VALUE RETURNING VARCHAR2(4000) 은 4,000자 초과 값을 NULL 로 돌림 — 2026-10-21 클라우드 사고)
        IF v_obj.has(p_key) THEN RETURN v_obj.get_Clob(p_key); END IF;
        IF v_obj.has(p_alt) THEN RETURN v_obj.get_Clob(p_alt); END IF;
        RETURN NULL;
    END jv;
BEGIN
    -- 1) 로그 원문 적재
    IF v_rid IS NULL THEN
        SELECT PARAMS, EXECUTE_TIME INTO v_json, v_exec_time
        FROM  ( SELECT L.PARAMS, L.EXECUTE_TIME
                FROM   SCM_MGR.SCM_COM_SQL_LOG L
                WHERE  L.EXECUTE_TIME >= SYSDATE - 7
                AND    L.SQL_ID = 'com.lgcns.nscm.callProc'
                AND    L.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 500000   -- PK 범위 선필터(EXECUTE_TIME 인덱스 없음 · 1.2M행 전수 CLOB 검사 회피)
                AND    DBMS_LOB.INSTR(UPPER(L.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0
                ORDER BY L.EXECUTE_TIME DESC )
        WHERE ROWNUM = 1;
    ELSE
        SELECT PARAMS, EXECUTE_TIME INTO v_json, v_exec_time
        FROM   SCM_MGR.SCM_COM_SQL_LOG
        WHERE  ROWID = CHARTOROWID(v_rid);
    END IF;

    v_truncated := DBMS_LOB.INSTR(v_json, '(truncated');
    DBMS_OUTPUT.PUT_LINE('원본 실행시각 = ' || TO_CHAR(v_exec_time, 'YYYY-MM-DD HH24:MI:SS')
                      || ' / PARAMS 길이 = ' || DBMS_LOB.GETLENGTH(v_json));
    IF v_truncated > 0 THEN
        RAISE_APPLICATION_ERROR(-20099,
            'PARAMS 가 4,000자에서 절단된 저장입니다. 전체 페이로드를 로그로 복원할 수 없어 재실행을 중단합니다. (§4 참조)');
    END IF;
    v_obj := JSON_OBJECT_T.parse(v_json);

    -- 2) 17 파라미터 추출 (SP 시그니처 순서 그대로)
    p_active_flag       := jv('activeFlag',     'p_active_flag');
    p_division_id       := jv('divisionId',     'p_division_id');
    p_project_code      := jv('projectCode',    'p_project_code');
    p_end_customer      := jv('endCustomer',    'p_end_customer');
    p_scm_site_id       := jv('scmSiteId',      'p_scm_site_id');
    p_item_id           := jv('itemId',         'p_item_id');
    p_dom_exp           := jv('domExp',         'p_dom_exp');
    p_fcst_type         := jv('fcstType',       'p_fcst_type');
    p_incoterms         := jv('incoterms',      'p_incoterms');
    p_measure           := jv('measure',        'p_measure');
    p_plant_site_id     := jv('plantSite',      'p_plant_site_id');
    p_cell_prod_site_id := jv('cellProdSiteId', 'p_cell_prod_site_id');
    p_yyyymmdd          := jv('yyyymmdd',       'p_yyyymmdd');
    p_currency          := jv('currency',       'p_currency');
    p_qty               := jv('qty',            'p_qty');
    p_created_by        := jv('createdBy',      'p_created_by');
    p_as_from_site      := jv('asFromSite',     'p_as_from_site');

    DBMS_OUTPUT.PUT_LINE('rows = ' || (REGEXP_COUNT(p_active_flag, '\^') + 1)
                      || ' / created_by = ' || DBMS_LOB.SUBSTR(p_created_by, 100, 1));
    DBMS_OUTPUT.PUT_LINE('p_item_id(앞 200자)  = ' || DBMS_LOB.SUBSTR(p_item_id, 200, 1));
    DBMS_OUTPUT.PUT_LINE('p_yyyymmdd(앞 200자) = ' || DBMS_LOB.SUBSTR(p_yyyymmdd, 200, 1));
    DBMS_OUTPUT.PUT_LINE('p_qty(앞 200자)      = ' || DBMS_LOB.SUBSTR(p_qty, 200, 1));

    -- 3) 재실행 (SP 내부에서 COMMIT 수행)
    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(
          p_active_flag       => p_active_flag
        , p_division_id       => p_division_id
        , p_project_code      => p_project_code
        , p_end_customer      => p_end_customer
        , p_scm_site_id       => p_scm_site_id
        , p_item_id           => p_item_id
        , p_dom_exp           => p_dom_exp
        , p_fcst_type         => p_fcst_type
        , p_incoterms         => p_incoterms
        , p_measure           => p_measure
        , p_plant_site_id     => p_plant_site_id
        , p_cell_prod_site_id => p_cell_prod_site_id
        , p_yyyymmdd          => p_yyyymmdd
        , p_currency          => p_currency
        , p_qty               => p_qty
        , p_created_by        => p_created_by
        , p_as_from_site      => p_as_from_site
        , O_RESULT_CURSOR     => o_rc
    );

    -- 4) 결과 커서: 성공 = ('0','SUCCESS',건수) · 검증실패 = ('F', 메시지, 'Validation Check')
    FETCH o_rc INTO v_code, v_msg, v_evt;
    CLOSE o_rc;
    DBMS_OUTPUT.PUT_LINE('RESULT_CODE = ' || v_code || ' / RESULT_MSG = ' || v_msg || ' / EVENT = ' || v_evt);
END;
/

--------------------------------------------------------------------------------------------------------------
-- §3-b. 재실행 직후 확인 — SP 로그 최신 5행 + 최근 10분 내 갱신된 본표/이력 행
--------------------------------------------------------------------------------------------------------------
SELECT  LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION, SQL_ERR_MSG, CREATED_BY
      , TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
FROM  ( SELECT * FROM SCM_MGR.SCM_SYS_LOG_BATCH
        WHERE PROGRAM_NAME = 'PKG_DMF0082' ORDER BY CREATION_DATE DESC, EVENT_DATE DESC )
WHERE ROWNUM <= 5;

SELECT 'DM_PLN_MKT_FCST' AS TBL, COUNT(*) AS CNT, MAX(LAST_UPDATE_DATE) AS LAST_UPD
FROM   SCM_MGR.DM_PLN_MKT_FCST WHERE LAST_UPDATE_DATE >= SYSDATE - 10/1440
UNION ALL
SELECT 'DM_PLN_MKT_FCST_H', COUNT(*), MAX(CREATION_DATE)
FROM   SCM_MGR.DM_PLN_MKT_FCST_H WHERE CREATION_DATE >= SYSDATE - 10/1440
UNION ALL
SELECT 'DM_PLN_CFM_MKT_DEMAND_PLAN', COUNT(*), MAX(LAST_UPDATE_DATE)
FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN WHERE LAST_UPDATE_DATE >= SYSDATE - 10/1440
UNION ALL
SELECT 'DM_PLN_CFM_SELLING_PRICE', COUNT(*), MAX(LAST_UPDATE_DATE)
FROM   SCM_MGR.DM_PLN_CFM_SELLING_PRICE WHERE LAST_UPDATE_DATE >= SYSDATE - 10/1440
UNION ALL
SELECT 'SCM_MST_FUTURE_PRICE', COUNT(*), MAX(LAST_UPDATE_DATE)
FROM   SCM_MGR.SCM_MST_FUTURE_PRICE WHERE LAST_UPDATE_DATE >= SYSDATE - 10/1440;

--------------------------------------------------------------------------------------------------------------
-- §4. PARAMS 가 절단(TRUNCATED_YN='Y')된 경우
--   · 4,000자 = 대략 20~40 셀 저장분. 그 이상은 ①②③ 어느 로그에도 전체 페이로드가 없다 (SP 로그는 파라미터당 50자).
--   · 이 경우 §3 은 -20099 로 중단된다. 복원 경로는 두 가지뿐:
--       (a) 브라우저 DevTools > Network > call-proc 요청 Payload(JSON) 를 복사해 §3 의 17 변수에 직접 대입
--       (b) BE 로그 상한 상향 — nscm-be QueryLogInterceptor.PARAMS_MAX_LEN(4000) 조정 (BE 수정은 가이드만, 미적용)
--   · 절단된 건이라도 아래로 "무엇이 저장됐는지" 는 확인 가능 (파라미터 앞 50자 + rows 건수)
SELECT  IN_PARA_DATA, LOG_TYPE, LOG_MESSAGE, DESCRIPTION, CREATED_BY
      , TO_CHAR(CREATION_DATE,'YYYY-MM-DD HH24:MI:SS') AS CREATION_DATE
FROM    SCM_MGR.SCM_SYS_LOG_BATCH
WHERE   PROGRAM_NAME = 'PKG_DMF0082'
AND     LOG_TYPE IN ('START','END','ERROR')
AND     CREATION_DATE >= SYSDATE - 1
ORDER BY CREATION_DATE DESC;

--------------------------------------------------------------------------------------------------------------
-- §5. 저장 쿼리를 "파일로" 생성 — SQL Developer 에서 이 블록만 선택해 F5 → SPOOL 경로에 재실행 .sql 이 만들어진다
--     원천 = SCM_COM_SQL_LOG.PARAMS (절단되지 않은 건만). 절단된 대용량 건은 DevTools Payload JSON 을
--     Make-Dmf0082ReplaySql.ps1 에 넣어 생성한다 (출력 형식 동일).
--     ※ SPOOL 경로는 SQL Developer 가 실행되는 PC 의 경로. 폴더가 있어야 한다.
--------------------------------------------------------------------------------------------------------------
SET DEFINE OFF
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET PAGESIZE 0
SET LINESIZE 32767
SET TRIMSPOOL ON
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT TRUNCATED
SPOOL C:\temp\DMF0082_SAVE_REPLAY_fromlog.sql
DECLARE
    v_rid       VARCHAR2(40) := NULL;   -- §1 RID 지정. NULL = 최근 1건
    v_json      CLOB;
    v_exec_time DATE;
    v_user      VARCHAR2(100);
    c_chunk     CONSTANT PLS_INTEGER := 2000;
    v_val       CLOB;
    v_obj       JSON_OBJECT_T;
    v_pos       PLS_INTEGER;

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

    FUNCTION has_key(p_k1 IN VARCHAR2, p_k2 IN VARCHAR2) RETURN BOOLEAN IS
    BEGIN RETURN v_obj.has(p_k1) OR v_obj.has(p_k2); END has_key;
    FUNCTION jv(p_k1 IN VARCHAR2, p_k2 IN VARCHAR2) RETURN CLOB IS
    BEGIN
        IF v_obj.has(p_k1) THEN RETURN v_obj.get_Clob(p_k1); END IF;
        IF v_obj.has(p_k2) THEN RETURN v_obj.get_Clob(p_k2); END IF;
        RETURN NULL;
    END jv;
    PROCEDURE o(s IN VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END o;
    FUNCTION esc(s IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REPLACE(REPLACE(REPLACE(s, '''', ''''''), CHR(13), '''||CHR(13)||'''), CHR(10), '''||CHR(10)||''');
    END esc;
BEGIN
    IF v_rid IS NULL THEN
        SELECT PARAMS, EXECUTE_TIME, CREATED_BY INTO v_json, v_exec_time, v_user
        FROM  ( SELECT L.PARAMS, L.EXECUTE_TIME, L.CREATED_BY
                FROM   SCM_MGR.SCM_COM_SQL_LOG L
                WHERE  L.EXECUTE_TIME >= SYSDATE - 7
                AND    L.SQL_ID = 'com.lgcns.nscm.callProc'
                AND    L.LOG_SEQ >= (SELECT MAX(LOG_SEQ) FROM SCM_MGR.SCM_COM_SQL_LOG) - 500000   -- PK 범위 선필터(EXECUTE_TIME 인덱스 없음 · 1.2M행 전수 CLOB 검사 회피)
                AND    DBMS_LOB.INSTR(UPPER(L.PARAMS), 'P_DMF0082_SAVE_MAIN_DATA') > 0
                ORDER BY L.EXECUTE_TIME DESC )
        WHERE ROWNUM = 1;
    ELSE
        SELECT PARAMS, EXECUTE_TIME, CREATED_BY INTO v_json, v_exec_time, v_user
        FROM   SCM_MGR.SCM_COM_SQL_LOG WHERE ROWID = CHARTOROWID(v_rid);
    END IF;

    IF DBMS_LOB.INSTR(v_json, '(truncated') > 0 THEN
        o('-- !! PARAMS 가 4,000자에서 절단된 저장입니다. 이 파일은 사용할 수 없습니다. DevTools Payload + Make-Dmf0082ReplaySql.ps1 로 생성하세요.');
        RETURN;
    END IF;
    v_obj := JSON_OBJECT_T.parse(v_json);

    o('/*==============================================================================================');
    o(' * DMF0082 저장 재실행 스크립트 (SCM_COM_SQL_LOG 에서 자동 생성)');
    o(' * 원본 실행시각 : ' || TO_CHAR(v_exec_time, 'YYYY-MM-DD HH24:MI:SS') || ' / 실행자 ' || v_user);
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
        END IF;
    END LOOP;
    o('    SCM_MGR.PKG_DMF0082.P_DMF0082_SAVE_MAIN_DATA(');
    FOR i IN 1 .. v_map.COUNT LOOP
        o('        ' || CASE WHEN i = 1 THEN '  ' ELSE ', ' END || RPAD(v_map(i).sp, 22) || ' => ' || v_map(i).sp);
    END LOOP;
    o('        , O_RESULT_CURSOR        => o_rc');
    o('    );');
    o('    FETCH o_rc INTO v_code, v_msg, v_evt;');
    o('    CLOSE o_rc;');
    o('    DBMS_OUTPUT.PUT_LINE(''RESULT_CODE='' || v_code || '' / RESULT_MSG='' || v_msg || '' / EVENT='' || v_evt);');
    o('END;');
    o('/');
END;
/
SPOOL OFF
SET FEEDBACK ON
SET PAGESIZE 50
