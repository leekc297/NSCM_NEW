-- =============================================================================
-- V03_LOC_FINAL_CURSOR.sql — DMF0082 LOC 미표시 3차: 조회 SP 가 화면에 실제로 돌려주는 결과(1번 커서)를 그대로 읽는다 (전체 F5)
--   계정: SCM_MGR · BE 가 붙은 클라우드 DB · V02 판정 F(출력 직전 자료에 LOC 존재) 다음 단계
--   무엇을 하나:
--     [X1] 사용자(&P_USER)의 가장 최근 화면 조회 인자를 BE 로그에서 읽어 같은 인자로 SP 1회 실행 (V02 와 동일)
--     [X2] 화면이 받는 결과 커서(fcstNPrice)를 끝까지 읽어 전체 행수 · 메저별 행수 출력
--     [X3] 대상 Site-Item 의 결과 행을 한 줄씩 출력 — 메저 · 키 값 · 값이 든 일/주/월 칸 수 · 첫 값
--     [X4] 판정
--   변경: 영구 테이블 변경 없음 (세션 전용 작업 테이블만, 끝에 ROLLBACK). 전체 F5 · 값 입력 없음.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET TRIMSPOOL ON
SET VERIFY OFF
SET FEEDBACK OFF
SET DEFINE ON
DEFINE P_DIV  = '40'
DEFINE P_SITE = 'AJ상사_AB_TES'
DEFINE P_ITEM = 'MCCM356015A2'
DEFINE P_USER = 'k0101'
SPOOL V03_LOC_FINAL_CURSOR_OUT.txt

DECLARE
    v_msg   VARCHAR2(4000);
    v_st    VARCHAR2(30);
    v_div   VARCHAR2(100);  v_team  VARCHAR2(4000); v_cust  VARCHAR2(4000); v_biz   VARCHAR2(4000);
    v_from  VARCHAR2(20);   v_to    VARCHAR2(20);   v_site  VARCHAR2(4000); v_item  VARCHAR2(4000);
    v_ver   VARCHAR2(200);  v_qty   VARCHAR2(10);   v_user  VARCHAR2(100);  v_grp   VARCHAR2(200);
    v_plant VARCHAR2(4000); v_prj   VARCHAR2(4000); v_owner VARCHAR2(4000); v_send  VARCHAR2(4000);
    rc1 SYS_REFCURSOR; rc2 SYS_REFCURSOR; rc3 SYS_REFCURSOR; rc4 SYS_REFCURSOR; rc5 SYS_REFCURSOR; rcr SYS_REFCURSOR;

    c       INTEGER;
    n       INTEGER;
    dt      DBMS_SQL.DESC_TAB;
    v       VARCHAR2(4000);
    i_site  PLS_INTEGER := 0; i_item PLS_INTEGER := 0; i_meas PLS_INTEGER := 0;
    TYPE t_cnt IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(200);
    m_all   t_cnt;
    k       VARCHAR2(200);
    v_total PLS_INTEGER := 0;
    v_hit   PLS_INTEGER := 0;
    v_loc   PLS_INTEGER := 0;
    v_rsite VARCHAR2(4000); v_ritem VARCHAR2(4000); v_rmeas VARCHAR2(4000);
    v_keys  VARCHAR2(4000);
    v_nd PLS_INTEGER; v_nw PLS_INTEGER; v_nm PLS_INTEGER;
    v_first VARCHAR2(200);
    v_dcols PLS_INTEGER := 0; v_wcols PLS_INTEGER := 0; v_mcols PLS_INTEGER := 0;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;
    FUNCTION jv(k VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN REGEXP_SUBSTR(v_msg, '"' || k || '":"([^"]*)"', 1, 1, NULL, 1);
    END;
BEGIN
    p('################ [X0] ' || SYS_CONTEXT('USERENV','DB_NAME') || ' · ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') || ' ################');
    BEGIN
        SELECT ST, MSG INTO v_st, v_msg
          FROM (SELECT TO_CHAR(TRNM_ST_DTM,'YYYY-MM-DD HH24:MI:SS') ST, SYS_LOG_MSG_CTN MSG
                  FROM SCM_COM_SYS_LOG
                 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'FcstNPrice'
                   AND CREATION_DATE >= SYSDATE - 1
                   AND UPPER(CREATED_BY) = UPPER('&P_USER')
                   AND SYS_LOG_MSG_CTN LIKE '%P_DMF0082_GET_MAIN_DATA(%'
                 ORDER BY TRNM_ST_DTM DESC)
         WHERE ROWNUM = 1;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        v_msg := NULL;
    END;

    IF v_msg IS NULL THEN
        p('!! 최근 24시간 &P_USER 의 화면 조회 로그 없음 → 기본 인자로 실행 (division &P_DIV · 당월 1일~+6개월 · Current · 그룹 ADMIN)');
        v_div := '&P_DIV'; v_team := 'ALL'; v_cust := 'ALL'; v_biz := 'ALL';
        v_from := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
        v_site := 'ALL'; v_item := NULL; v_ver := 'Current'; v_qty := 'N'; v_user := '&P_USER'; v_grp := 'ADMIN';
        v_plant := 'ALL'; v_prj := 'ALL'; v_owner := 'ALL'; v_send := 'ALL';
    ELSE
        v_div  := jv('divisionId');  v_team := jv('deptId');      v_cust  := jv('endCustomer'); v_biz   := jv('bizType');
        v_from := jv('fromYyyymmdd'); v_to  := jv('toYyyymmdd');   v_site  := jv('salesSite');   v_item  := jv('itemId');
        v_ver  := jv('versionType'); v_qty  := jv('qtyYn');       v_user  := jv('sesUserId');   v_grp   := jv('userGroup');
        v_plant := jv('plantSiteId'); v_prj := jv('projectCode');  v_owner := jv('owner');       v_send  := jv('senderCode');
    END IF;
    p('[X1] 기준 화면 조회 시각 = ' || NVL(v_st,'(없음)') || ' · div[' || v_div || '] ' || v_from || '~' || v_to
      || ' · site[' || v_site || '] item[' || v_item || '] ver[' || v_ver || '] qty[' || v_qty || '] user[' || v_user || '] group[' || v_grp || ']');

    SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
        p_division_id => v_div,   p_team_id => v_team,       p_customer => v_cust,     p_biz_type => v_biz,
        p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to,    p_scm_site_id => v_site,  p_item_id => v_item,
        p_version_type => v_ver,  p_qty_yn => v_qty,         p_created_by => v_user,   p_user_group => v_grp,
        p_plant_site_id => v_plant, p_project_code => v_prj, p_owner => v_owner,       p_sender_code => v_send,
        O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);

    -- 결과 커서 1번(화면 그리드 행)을 컬럼 구성과 무관하게 문자열로 읽는다
    c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
    DBMS_SQL.DESCRIBE_COLUMNS(c, n, dt);
    FOR i IN 1 .. n LOOP
        DBMS_SQL.DEFINE_COLUMN(c, i, v, 4000);
        IF    dt(i).col_name = 'SCM_SITE_ID' THEN i_site := i;
        ELSIF dt(i).col_name = 'ITEM_ID'     THEN i_item := i;
        ELSIF dt(i).col_name = 'MEASURE'     THEN i_meas := i;
        ELSIF dt(i).col_name LIKE 'D\_%' ESCAPE '\' THEN v_dcols := v_dcols + 1;
        ELSIF dt(i).col_name LIKE 'W\_%' ESCAPE '\' THEN v_wcols := v_wcols + 1;
        ELSIF dt(i).col_name LIKE 'M\_%' ESCAPE '\' THEN v_mcols := v_mcols + 1;
        END IF;
    END LOOP;
    p('[X2] 결과 커서 컬럼 ' || n || '개 (일 ' || v_dcols || ' · 주 ' || v_wcols || ' · 월 ' || v_mcols || ')'
      || CASE WHEN i_site = 0 OR i_item = 0 OR i_meas = 0 THEN '  !! SCM_SITE_ID/ITEM_ID/MEASURE 컬럼을 찾지 못함' END);
    p('[X3] 대상 Site-Item 결과 행 (화면이 받는 그대로) — 값칸 = 0 이 아닌 값이 든 칸 수');

    WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
        v_total := v_total + 1;
        v_rsite := NULL; v_ritem := NULL; v_rmeas := NULL;
        IF i_site > 0 THEN DBMS_SQL.COLUMN_VALUE(c, i_site, v_rsite); END IF;
        IF i_item > 0 THEN DBMS_SQL.COLUMN_VALUE(c, i_item, v_ritem); END IF;
        IF i_meas > 0 THEN DBMS_SQL.COLUMN_VALUE(c, i_meas, v_rmeas); END IF;
        k := NVL(v_rmeas, '(null)');
        IF m_all.EXISTS(k) THEN m_all(k) := m_all(k) + 1; ELSE m_all(k) := 1; END IF;

        IF v_rsite = '&P_SITE' AND v_ritem = '&P_ITEM' THEN
            v_hit := v_hit + 1;
            IF v_rmeas = 'LOC' THEN v_loc := v_loc + 1; END IF;
            v_keys := NULL; v_nd := 0; v_nw := 0; v_nm := 0; v_first := NULL;
            FOR i IN 1 .. n LOOP
                DBMS_SQL.COLUMN_VALUE(c, i, v);
                IF dt(i).col_name IN ('PROJECT_CODE','END_CUSTOMER','DOM_EXP','FCST_TYPE','INCOTERMS','PLANT_SITE_ID','CELL_PROD_SITE_ID','CURRENCY','EDIT_FLAG','NOTATION') THEN
                    v_keys := v_keys || ' ' || dt(i).col_name || '[' || v || ']';
                ELSIF dt(i).col_name LIKE 'D\_%' ESCAPE '\' OR dt(i).col_name LIKE 'W\_%' ESCAPE '\' OR dt(i).col_name LIKE 'M\_%' ESCAPE '\' THEN
                    IF v IS NOT NULL AND v <> '0' THEN
                        IF    SUBSTR(dt(i).col_name,1,1) = 'D' THEN v_nd := v_nd + 1;
                        ELSIF SUBSTR(dt(i).col_name,1,1) = 'W' THEN v_nw := v_nw + 1;
                        ELSE  v_nm := v_nm + 1; END IF;
                        IF v_first IS NULL THEN v_first := dt(i).col_name || '=' || SUBSTR(v,1,30); END IF;
                    END IF;
                END IF;
            END LOOP;
            p('   ' || RPAD(NVL(v_rmeas,'(null)'), 14) || ' 값칸 일' || v_nd || '/주' || v_nw || '/월' || v_nm
              || ' 첫값 ' || NVL(v_first,'(없음)') || ' |' || v_keys);
        END IF;
    END LOOP;
    DBMS_SQL.CLOSE_CURSOR(c);
    IF rc2%ISOPEN THEN CLOSE rc2; END IF;
    IF rc3%ISOPEN THEN CLOSE rc3; END IF;
    IF rc4%ISOPEN THEN CLOSE rc4; END IF;
    IF rc5%ISOPEN THEN CLOSE rc5; END IF;
    IF rcr%ISOPEN THEN CLOSE rcr; END IF;

    IF v_hit = 0 THEN p('   (대상 Site-Item 행 없음)'); END IF;
    p('[X2] 전체 결과 ' || v_total || ' 행 — 메저별:');
    k := m_all.FIRST;
    WHILE k IS NOT NULL LOOP
        p('   ' || RPAD(k, 30) || m_all(k));
        k := m_all.NEXT(k);
    END LOOP;

    p('[X4] 판정: ' ||
      CASE WHEN v_total = 0 THEN 'ERROR — 결과 0 행 (인자 확인)'
           WHEN v_hit = 0   THEN 'B — 화면 결과에 이 Site-Item 자체가 없음'
           WHEN v_loc = 0   THEN 'G — 출력 직전 자료에는 LOC 가 있었으나 최종 결과에서 빠짐 (최종 집계 단계 탈락)'
           ELSE 'F — SP 최종 결과에 LOC ' || v_loc || ' 행 포함. DB 는 LOC 를 화면에 돌려준다 → 화면(FE) 쪽 확인 필요' END);
EXCEPTION WHEN OTHERS THEN
    p('!!! 실행 오류: ' || SQLERRM);
    p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    IF c IS NOT NULL AND DBMS_SQL.IS_OPEN(c) THEN DBMS_SQL.CLOSE_CURSOR(c); END IF;
END;
/

ROLLBACK;
SPOOL OFF
PROMPT =============================================================================
PROMPT  V03 완료 → V03_LOC_FINAL_CURSOR_OUT.txt 회신
PROMPT =============================================================================
