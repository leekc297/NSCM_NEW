-- =============================================================================
-- V04_LOC_USER_COMPARE.sql — DMF0082 LOC 미표시 4차: 안 보이는 사용자(&P_USER) vs 보이는 사용자(&P_USER_OK) 비교 (전체 F5)
--   계정: SCM_MGR · BE 가 붙은 클라우드 DB
--   무엇을 하나:
--     [Y1] 두 사용자의 화면 설정 차이 — 메저 선택(M) · 표시 컬럼(C)
--     [Y2] 두 사용자의 최근 화면 조회 인자 (BE 로그)
--     [Y3] 각 사용자 본인의 최근 조회 인자로 SP 를 실행해, 화면이 받는 결과에서 대상 Site-Item 행을 메저별로 출력
--     [Y4] 판정 — 두 사용자의 SP 최종 결과에 LOC 가 있는지
--   변경: 영구 테이블 변경 없음 (세션 전용 작업 테이블만, 끝에 ROLLBACK). 전체 F5 · 값 입력 없음.
-- =============================================================================
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET LINESIZE 400
SET PAGESIZE 500
SET TRIMSPOOL ON
SET VERIFY OFF
SET FEEDBACK OFF
SET DEFINE ON
DEFINE P_DIV     = '40'
DEFINE P_SITE    = 'AJ상사_AB_TES'
DEFINE P_ITEM    = 'MCCM356015A2'
DEFINE P_USER    = 'k0101'
DEFINE P_USER_OK = 'minyonglee1'
COLUMN COLUMN_NAME FORMAT A32
COLUMN DIFF FORMAT A30
SPOOL V04_LOC_USER_COMPARE_OUT.txt

PROMPT ################ [Y1] 화면 설정 차이 — M = 메저 선택 · C = 표시 컬럼 (숫자 = 순번, 빈칸 = 미선택) ################
SELECT NVL(A.TP, B.TP) TP, NVL(A.COLUMN_NAME, B.COLUMN_NAME) COLUMN_NAME,
       A.SORT_ORDER_NO "&P_USER", B.SORT_ORDER_NO "&P_USER_OK",
       CASE WHEN A.COLUMN_NAME IS NULL THEN '<< &P_USER 에 없음'
            WHEN B.COLUMN_NAME IS NULL THEN '<< &P_USER_OK 에 없음' END DIFF
  FROM (SELECT USER_INQUIRY_COLUMN_TYPE_CODE TP, COLUMN_NAME, SORT_ORDER_NO FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' AND USER_ID = '&P_USER') A
  FULL OUTER JOIN
       (SELECT USER_INQUIRY_COLUMN_TYPE_CODE TP, COLUMN_NAME, SORT_ORDER_NO FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = 'DMF0082' AND SHEET_NAME = 'FcstNPrice' AND USER_ID = '&P_USER_OK') B
    ON B.TP = A.TP AND B.COLUMN_NAME = A.COLUMN_NAME
 ORDER BY 1 DESC, NVL(A.SORT_ORDER_NO, B.SORT_ORDER_NO), 2;

PROMPT ################ [Y2][Y3][Y4] 사용자별 최근 조회 인자 → SP 실행 → 화면이 받는 결과의 대상 Site-Item 행 ################
DECLARE
    TYPE t_cnt IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(200);
    v_loc_ng PLS_INTEGER; v_loc_ok PLS_INTEGER; v_hit_ng PLS_INTEGER; v_hit_ok PLS_INTEGER;

    PROCEDURE p(s VARCHAR2) IS BEGIN DBMS_OUTPUT.PUT_LINE(s); END;

    PROCEDURE run_for(p_user VARCHAR2, o_hit OUT PLS_INTEGER, o_loc OUT PLS_INTEGER) IS
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
        m_all   t_cnt;
        k       VARCHAR2(200);
        v_total PLS_INTEGER := 0;
        v_rsite VARCHAR2(4000); v_ritem VARCHAR2(4000); v_rmeas VARCHAR2(4000);
        v_keys  VARCHAR2(4000);
        v_nd PLS_INTEGER; v_nw PLS_INTEGER; v_nm PLS_INTEGER;
        v_first VARCHAR2(200);
        v_line  VARCHAR2(4000);
        FUNCTION jv(k VARCHAR2) RETURN VARCHAR2 IS
        BEGIN
            RETURN REGEXP_SUBSTR(v_msg, '"' || k || '":"([^"]*)"', 1, 1, NULL, 1);
        END;
    BEGIN
        o_hit := 0; o_loc := 0;
        p('================ 사용자 ' || p_user || ' ================');
        BEGIN
            SELECT ST, MSG INTO v_st, v_msg
              FROM (SELECT TO_CHAR(TRNM_ST_DTM,'YYYY-MM-DD HH24:MI:SS') ST, SYS_LOG_MSG_CTN MSG
                      FROM SCM_COM_SYS_LOG
                     WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'FcstNPrice'
                       AND CREATION_DATE >= SYSDATE - 1
                       AND UPPER(CREATED_BY) = UPPER(p_user)
                       AND SYS_LOG_MSG_CTN LIKE '%P_DMF0082_GET_MAIN_DATA(%'
                     ORDER BY TRNM_ST_DTM DESC)
             WHERE ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_msg := NULL;
        END;
        IF v_msg IS NULL THEN
            p('!! 최근 24시간 화면 조회 로그 없음 → 기본 인자 (division &P_DIV · 당월 1일~+6개월 · Current · 그룹 ADMIN)');
            v_div := '&P_DIV'; v_team := 'ALL'; v_cust := 'ALL'; v_biz := 'ALL';
            v_from := TO_CHAR(TRUNC(SYSDATE,'MM'),'YYYYMMDD'); v_to := TO_CHAR(ADD_MONTHS(TRUNC(SYSDATE,'MM'),6) - 1,'YYYYMMDD');
            v_site := 'ALL'; v_item := NULL; v_ver := 'Current'; v_qty := 'N'; v_user := p_user; v_grp := 'ADMIN';
            v_plant := 'ALL'; v_prj := 'ALL'; v_owner := 'ALL'; v_send := 'ALL';
        ELSE
            v_div  := jv('divisionId');  v_team := jv('deptId');      v_cust  := jv('endCustomer'); v_biz   := jv('bizType');
            v_from := jv('fromYyyymmdd'); v_to  := jv('toYyyymmdd');   v_site  := jv('salesSite');   v_item  := jv('itemId');
            v_ver  := jv('versionType'); v_qty  := jv('qtyYn');       v_user  := jv('sesUserId');   v_grp   := jv('userGroup');
            v_plant := jv('plantSiteId'); v_prj := jv('projectCode');  v_owner := jv('owner');       v_send  := jv('senderCode');
        END IF;
        p('[Y2] 조회 시각 ' || NVL(v_st,'(없음)') || ' · div[' || v_div || '] ' || v_from || '~' || v_to
          || ' team[' || v_team || '] cust[' || v_cust || '] biz[' || v_biz || '] site[' || v_site || '] item[' || v_item || ']');
        p('     ver[' || v_ver || '] qty[' || v_qty || '] user[' || v_user || '] group[' || v_grp || '] plant[' || v_plant
          || '] project[' || v_prj || '] owner[' || v_owner || '] sender[' || v_send || ']');

        SCM_MGR.PKG_DMF0082.P_DMF0082_GET_MAIN_DATA(
            p_division_id => v_div,   p_team_id => v_team,       p_customer => v_cust,     p_biz_type => v_biz,
            p_from_yyyymmdd => v_from, p_to_yyyymmdd => v_to,    p_scm_site_id => v_site,  p_item_id => v_item,
            p_version_type => v_ver,  p_qty_yn => v_qty,         p_created_by => v_user,   p_user_group => v_grp,
            p_plant_site_id => v_plant, p_project_code => v_prj, p_owner => v_owner,       p_sender_code => v_send,
            O_RC1 => rc1, O_RC2 => rc2, O_RC3 => rc3, O_RC4 => rc4, O_RC5 => rc5, O_RESULT_CURSOR => rcr);

        c := DBMS_SQL.TO_CURSOR_NUMBER(rc1);
        DBMS_SQL.DESCRIBE_COLUMNS(c, n, dt);
        v_line := NULL;
        FOR i IN 1 .. n LOOP
            DBMS_SQL.DEFINE_COLUMN(c, i, v, 4000);
            IF    dt(i).col_name = 'SCM_SITE_ID' THEN i_site := i;
            ELSIF dt(i).col_name = 'ITEM_ID'     THEN i_item := i;
            ELSIF dt(i).col_name = 'MEASURE'     THEN i_meas := i;
            END IF;
            IF NOT REGEXP_LIKE(dt(i).col_name, '^[DWM]_[0-9]') AND LENGTH(v_line) < 3800 OR v_line IS NULL THEN
                v_line := v_line || CASE WHEN v_line IS NOT NULL THEN ',' END || dt(i).col_name;
            END IF;
        END LOOP;
        p('[Y3] 결과 컬럼 ' || n || '개 · 고정 컬럼 순서: ' || v_line);

        WHILE DBMS_SQL.FETCH_ROWS(c) > 0 LOOP
            v_total := v_total + 1;
            v_rsite := NULL; v_ritem := NULL; v_rmeas := NULL;
            IF i_site > 0 THEN DBMS_SQL.COLUMN_VALUE(c, i_site, v_rsite); END IF;
            IF i_item > 0 THEN DBMS_SQL.COLUMN_VALUE(c, i_item, v_ritem); END IF;
            IF i_meas > 0 THEN DBMS_SQL.COLUMN_VALUE(c, i_meas, v_rmeas); END IF;
            k := NVL(v_rmeas, '(null)');
            IF m_all.EXISTS(k) THEN m_all(k) := m_all(k) + 1; ELSE m_all(k) := 1; END IF;
            IF v_rsite = '&P_SITE' AND v_ritem = '&P_ITEM' THEN
                o_hit := o_hit + 1;
                IF v_rmeas = 'LOC' THEN o_loc := o_loc + 1; END IF;
                v_keys := NULL; v_nd := 0; v_nw := 0; v_nm := 0; v_first := NULL;
                FOR i IN 1 .. n LOOP
                    DBMS_SQL.COLUMN_VALUE(c, i, v);
                    IF dt(i).col_name IN ('PROJECT_CODE','END_CUSTOMER','DOM_EXP','FCST_TYPE','INCOTERMS','PLANT_SITE_ID','CELL_PROD_SITE_ID','CURRENCY','EDIT_FLAG','NOTATION','SORT_KEY') THEN
                        v_keys := v_keys || ' ' || dt(i).col_name || '[' || v || ']';
                    ELSIF REGEXP_LIKE(dt(i).col_name, '^[DWM]_[0-9]') THEN
                        IF v IS NOT NULL AND v <> '0' THEN
                            IF    SUBSTR(dt(i).col_name,1,1) = 'D' THEN v_nd := v_nd + 1;
                            ELSIF SUBSTR(dt(i).col_name,1,1) = 'W' THEN v_nw := v_nw + 1;
                            ELSE  v_nm := v_nm + 1; END IF;
                            IF v_first IS NULL THEN v_first := dt(i).col_name || '=' || SUBSTR(v,1,30); END IF;
                        END IF;
                    END IF;
                END LOOP;
                p('   행#' || v_total || ' ' || RPAD(NVL(v_rmeas,'(null)'), 14) || ' 값칸 일' || v_nd || '/주' || v_nw || '/월' || v_nm
                  || ' 첫값 ' || NVL(v_first,'(없음)') || ' |' || v_keys);
            END IF;
        END LOOP;
        DBMS_SQL.CLOSE_CURSOR(c);
        IF rc2%ISOPEN THEN CLOSE rc2; END IF;
        IF rc3%ISOPEN THEN CLOSE rc3; END IF;
        IF rc4%ISOPEN THEN CLOSE rc4; END IF;
        IF rc5%ISOPEN THEN CLOSE rc5; END IF;
        IF rcr%ISOPEN THEN CLOSE rcr; END IF;
        IF o_hit = 0 THEN p('   (대상 Site-Item 행 없음)'); END IF;
        v_line := NULL;
        k := m_all.FIRST;
        WHILE k IS NOT NULL LOOP
            v_line := v_line || ' ' || k || '=' || m_all(k);
            k := m_all.NEXT(k);
        END LOOP;
        p('     전체 결과 ' || v_total || ' 행 · 메저별:' || SUBSTR(v_line, 1, 3000));
    EXCEPTION WHEN OTHERS THEN
        p('!!! ' || p_user || ' 실행 오류: ' || SQLERRM);
        p(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        IF c IS NOT NULL AND DBMS_SQL.IS_OPEN(c) THEN DBMS_SQL.CLOSE_CURSOR(c); END IF;
    END;
BEGIN
    p('[Y0] ' || SYS_CONTEXT('USERENV','DB_NAME') || ' · ' || TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS'));
    run_for('&P_USER',    v_hit_ng, v_loc_ng);
    run_for('&P_USER_OK', v_hit_ok, v_loc_ok);
    p('================ [Y4] 판정 ================');
    p('   &P_USER    : 대상 행 ' || v_hit_ng || ' · LOC 행 ' || v_loc_ng);
    p('   &P_USER_OK : 대상 행 ' || v_hit_ok || ' · LOC 행 ' || v_loc_ok);
    p('   ' || CASE WHEN v_loc_ng > 0 AND v_loc_ok > 0 THEN '둘 다 SP 결과에 LOC 포함 → DB 는 두 사용자 모두에게 LOC 를 돌려준다. 차이는 화면(FE) 쪽 — [Y1] 설정 차이와 [Y3] 키 값 차이를 대조'
                    WHEN v_loc_ng = 0 AND v_loc_ok > 0 THEN '&P_USER 만 SP 결과에 LOC 없음 → DB(SP) 쪽 원인. [Y1] 설정 차이 · [Y2] 인자 차이가 탈락 조건'
                    WHEN v_loc_ng = 0 AND v_loc_ok = 0 THEN '두 사용자 모두 SP 결과에 LOC 없음 → [Y2] 인자(기간·버전) 확인'
                    ELSE '&P_USER 에만 LOC 있음 — 신고 내용과 반대, [Y2] 인자 확인' END);
END;
/

ROLLBACK;
SPOOL OFF
PROMPT =============================================================================
PROMPT  V04 완료 → V04_LOC_USER_COMPARE_OUT.txt 회신
PROMPT =============================================================================
