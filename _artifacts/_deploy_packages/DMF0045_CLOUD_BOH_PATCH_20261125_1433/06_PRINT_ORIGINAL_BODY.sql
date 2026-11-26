-- SOURCE-FRESH: SCM_MGR.PKG_DMF0045 PACKAGE BODY LAST_DDL=2026-11-25 14:27:06 FETCHED=2026-11-25 15:10 DB=ZIOUI1
/* DMF0045 PKG_DMF0045 BODY 현재 원문(원복용) 생성 문장 출력 (DDL 실행 없음 · 조회만)
 * 1) 이 파일 전체 실행(F5)
 * 2) 출력(Dbms Output 또는 Script Output)에서 'CREATE OR REPLACE PACKAGE BODY' 줄부터 마지막 '/' 줄까지 복사
 * 3) 새 워크시트에 붙여 전체 실행(F5) 또는 DBA 에게 전달 (SCM_MGR 소유 PKG 생성 권한 필요) */
SET SERVEROUTPUT ON SIZE UNLIMITED FORMAT WRAPPED
SET FEEDBACK OFF
DECLARE
    TYPE t_txt IS TABLE OF VARCHAR2(32767) INDEX BY PLS_INTEGER;
    v_src  t_txt;
    v_old  t_txt;
    v_blk  t_txt;
    v_n    PLS_INTEGER := 0;
    v_hit  PLS_INTEGER := 0;
    v_at   PLS_INTEGER := 0;
    v_ok   BOOLEAN;
    c_patch CONSTANT BOOLEAN := FALSE;
    FUNCTION nz(p VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN TRIM(REGEXP_REPLACE(REGEXP_REPLACE(REPLACE(REPLACE(p, CHR(13)), CHR(10)), '/\*.*?\*/', ''), '\s+', ' '));
    END;
    PROCEDURE pl(p VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(RTRIM(REPLACE(REPLACE(p, CHR(13)), CHR(10))));
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
    v_blk(1) := q'~              /* [E20261125-BOHONCE] 재고 뷰를 1번만 읽고 사이트별 최근 재고 일자는 같은 읽기에서 구함 */~';
    v_blk(2) := q'~              /* (종전 : 같은 뷰를 2번 읽어 클라우드 1회 960초)                                         */~';
    v_blk(3) := q'~              FROM (SELECT V.DIVISION_ID~';
    v_blk(4) := q'~                         , V.SITE_ID~';
    v_blk(5) := q'~                         , V.SCM_SITE_ID~';
    v_blk(6) := q'~                         , V.ITEM_ID~';
    v_blk(7) := q'~                         , V.SSP_QTY~';
    v_blk(8) := q'~                         , V.CUTOFF_DATE~';
    v_blk(9) := q'~                         , MAX(V.CUTOFF_DATE) OVER (PARTITION BY V.DIVISION_ID, V.SITE_ID) AS MAX_CUTOFF_DATE~';
    v_blk(10) := q'~                      FROM SSP_DNM_ESS_PACKER_STOCK_V V~';
    v_blk(11) := q'~                     WHERE V.DIVISION_ID  = V_DIVISION_ID~';
    v_blk(12) := q'~                       AND V.CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')     /* 현재일 - 3 */~';
    v_blk(13) := q'~                       AND V.CUTOFF_DATE <= TO_DATE(V_FROM_YYYYMMDD, 'YYYYMMDD')      /* 변수 : 현재일 */~';
    v_blk(14) := q'~                       AND V_DIVISION_ID  = '82'~';
    v_blk(15) := q'~                   ) A~';
    v_blk(16) := q'~                 , SCM_MST_SITE B~';
    v_blk(17) := q'~                 , SCP_MST_FINAL_ITEM C~';
    v_blk(18) := q'~             WHERE A.CUTOFF_DATE      = A.MAX_CUTOFF_DATE~';
    FOR r IN (SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER = 'SCM_MGR' AND NAME = 'PKG_DMF0045' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        v_n := v_n + 1;
        v_src(v_n) := r.TEXT;
        IF c_patch AND INSTR(r.TEXT, 'E20261125-BOHONCE') > 0 THEN
            DBMS_OUTPUT.PUT_LINE('-- SKIP 이미 보완됨(' || r.LINE || '줄). 실행할 문장 없음');
            RETURN;
        END IF;
    END LOOP;
    IF v_n = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 - SCM_MGR.PKG_DMF0045 PACKAGE BODY 없음');
    END IF;
    IF c_patch THEN
        FOR i IN 1 .. v_n - v_old.COUNT + 1 LOOP
            v_ok := TRUE;
            FOR j IN 1 .. v_old.COUNT LOOP
                IF NVL(nz(v_src(i + j - 1)), '~') <> v_old(j) THEN v_ok := FALSE; EXIT; END IF;
            END LOOP;
            IF v_ok THEN v_hit := v_hit + 1; v_at := i; END IF;
        END LOOP;
        IF v_hit <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 - 보완 대상 17줄 구간 ' || v_hit || '건(1 기대)');
        END IF;
    END IF;
    FOR i IN 1 .. v_n LOOP
        IF i = 1 THEN
            pl(REGEXP_REPLACE(v_src(1), '^\s*PACKAGE\s+BODY\s+"?PKG_DMF0045"?', 'CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0045', 1, 1, 'i'));
        ELSIF c_patch AND i = v_at THEN
            FOR k IN 1 .. v_blk.COUNT LOOP pl(v_blk(k)); END LOOP;
        ELSIF c_patch AND i > v_at AND i < v_at + v_old.COUNT THEN
            NULL;
        ELSE
            pl(v_src(i));
        END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('/');
END;
/
