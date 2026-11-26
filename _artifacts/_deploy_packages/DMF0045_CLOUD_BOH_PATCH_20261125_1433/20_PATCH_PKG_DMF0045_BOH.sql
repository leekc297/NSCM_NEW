-- SOURCE-FRESH: SCM_MGR.PKG_DMF0045 PACKAGE BODY LAST_DDL=2026-11-25 14:27:06 FETCHED=2026-11-25 15:10 DB=ZIOUI1
/* DMF0045 W/H BOH 82 사업부 부분 : 재고 뷰 1회 읽기 (E20261125-BOHONCE)
 * 클라우드 PKG_DMF0045 PACKAGE BODY 에서 아래 17줄(주석·공백 무시 비교) 구간 1건만 바꿈.
 * 이미 바뀌었으면 SKIP · 구간 1건 아니면 중단(원문 무변경) · 컴파일 실패면 원문 복원.
 * SCM_MGR 로 접속해 전체 실행(F5). Output 창에서 SKIP / APPLY / 중단 문구 확인. */
SET SERVEROUTPUT ON SIZE UNLIMITED
ALTER SESSION SET CURRENT_SCHEMA = SCM_MGR;
DECLARE
    TYPE t_txt IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    v_src   t_txt;
    v_old   t_txt;
    v_n     PLS_INTEGER := 0;
    v_hit   PLS_INTEGER := 0;
    v_at    PLS_INTEGER := 0;
    v_ok    BOOLEAN;
    v_orig  CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    v_new_block CONSTANT VARCHAR2(32767) := q'~              /* [E20261125-BOHONCE] 재고 뷰를 1번만 읽고 사이트별 최근 재고 일자는 같은 읽기에서 구함 */
              /* (종전 : 같은 뷰를 2번 읽어 클라우드 1회 960초)                                         */
              FROM (SELECT V.DIVISION_ID
                         , V.SITE_ID
                         , V.SCM_SITE_ID
                         , V.ITEM_ID
                         , V.SSP_QTY
                         , V.CUTOFF_DATE
                         , MAX(V.CUTOFF_DATE) OVER (PARTITION BY V.DIVISION_ID, V.SITE_ID) AS MAX_CUTOFF_DATE
                      FROM SSP_DNM_ESS_PACKER_STOCK_V V
                     WHERE V.DIVISION_ID  = V_DIVISION_ID
                       AND V.CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')     /* 현재일 - 3 */
                       AND V.CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')      /* 변수 : 현재일 */
                       AND V_DIVISION_ID  = '82'
                   ) A
                 , SCM_MST_SITE B
                 , SCP_MST_FINAL_ITEM C
             WHERE A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE~';
    FUNCTION nz(p VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(REPLACE(p, CHR(13)), CHR(10)), '/\*.*?\*/', ''), '\s+', ' '));
    END;
    PROCEDURE ap(c IN OUT NOCOPY CLOB, t VARCHAR2) IS
    BEGIN
        IF t IS NOT NULL THEN DBMS_LOB.WRITEAPPEND(c, LENGTH(t), t); END IF;
    END;
BEGIN
    v_old(1) := q'~FROM SSP_DNM_ESS_PACKER_STOCK_V A~';
    v_old(2) := q'~, SCM_MST_SITE B~';
    v_old(3) := q'~, SCP_MST_FINAL_ITEM C~';
    v_old(4) := q'~, (SELECT DIVISION_ID~';
    v_old(5) := q'~, SITE_ID~';
    v_old(6) := q'~, MAX(CUTOFF_DATE) AS MAX_CUTOFF_DATE~';
    v_old(7) := q'~FROM SSP_DNM_ESS_PACKER_STOCK_V~';
    v_old(8) := q'~WHERE DIVISION_ID = V_DIVISION_ID~';
    v_old(9) := q'~AND CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')~';
    v_old(10) := q'~AND CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')~';
    v_old(11) := q'~GROUP BY DIVISION_ID~';
    v_old(12) := q'~, SITE_ID~';
    v_old(13) := q'~) XA~';
    v_old(14) := q'~WHERE A.DIVISION_ID = XA.DIVISION_ID~';
    v_old(15) := q'~AND A.SITE_ID = XA.SITE_ID~';
    v_old(16) := q'~AND A.CUTOFF_DATE = XA.MAX_CUTOFF_DATE~';
    v_old(17) := q'~AND A.CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')~';

    FOR r IN (SELECT LINE, TEXT FROM USER_SOURCE WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        v_n := v_n + 1;
        v_src(v_n) := r.TEXT;
        IF INSTR(r.TEXT, 'E20261125-BOHONCE') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('> SKIP  PKG_DMF0045 BODY - 이미 보완됨(' || r.LINE || '줄) · 원문 무변경');
            RETURN;
        END IF;
    END LOOP;
    IF v_n = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 - 클라우드에 PKG_DMF0045 PACKAGE BODY 없음');
    END IF;

    FOR i IN 1 .. v_n - v_old.COUNT + 1 LOOP
        v_ok := TRUE;
        FOR j IN 1 .. v_old.COUNT LOOP
            IF NVL(nz(v_src(i + j - 1)), '~') <> v_old(j) THEN v_ok := FALSE; EXIT; END IF;
        END LOOP;
        IF v_ok THEN v_hit := v_hit + 1; v_at := i; END IF;
    END LOOP;
    IF v_hit <> 1 THEN
        RAISE_APPLICATION_ERROR(-20011, '중단 - 보완 대상 17줄 구간 ' || v_hit || '건(1 기대) · 원문 무변경 · 결과 회신 바람');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> FOUND 보완 구간 ' || v_at || '~' || (v_at + v_old.COUNT - 1) || '줄');

    DBMS_LOB.CREATETEMPORARY(v_orig, TRUE);
    DBMS_LOB.CREATETEMPORARY(v_new, TRUE);
    ap(v_orig, 'CREATE OR REPLACE ');
    ap(v_new, 'CREATE OR REPLACE ');
    FOR i IN 1 .. v_n LOOP
        IF i = 1 THEN
            /* 현재 스키마와 관계없이 SCM_MGR 소유 PKG 를 교체 (클라우드 CURRENT_SCHEMA=FP_MGR 에서 ORA-01031) */
            v_src(1) := REGEXP_REPLACE(v_src(1), '^\s*PACKAGE\s+BODY\s+"?PKG_DMF0045"?', 'PACKAGE BODY SCM_MGR.PKG_DMF0045', 1, 1, 'i');
        END IF;
        ap(v_orig, v_src(i));
        IF i = v_at THEN
            ap(v_new, v_new_block || CHR(10));
        ELSIF i > v_at AND i < v_at + v_old.COUNT THEN
            NULL;
        ELSE
            ap(v_new, v_src(i));
        END IF;
    END LOOP;

    EXECUTE IMMEDIATE v_new;

    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0045' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR ' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE v_orig;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
        RAISE_APPLICATION_ERROR(-20013, 'PKG_DMF0045 BODY 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') -> 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PKG_DMF0045 BODY - 보완 구간 교체 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
