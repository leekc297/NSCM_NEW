-- 99 ROLLBACK — [E20261012-DMF0082LATFIX] 역치환 (이 DB 의 USER_SOURCE 를 읽어 NEW → OLD, History 2줄 제거 후 CREATE OR REPLACE). 전체 F5, 멱등
-- 마커 없으면 무동작. 치환 뒤 마커 0 이어야 실행.
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261012-DMF0082LATFIX';
    c_old   CONSTANT VARCHAR2(32767) :=
        '        FROM   SCM_MGR.SCM_MST_SITE S' || CHR(10) ||
        '        WHERE  S.DIVISION_ID = ''82''' || CHR(10) ||
        '        GROUP BY S.SCM_SITE_ID' || CHR(10) ||
        '    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID' || CHR(10) ||
        '         AND p_division_id  = ''82''' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=
        '        FROM   SCM_MGR.SCM_MST_SITE S' || CHR(10) ||
        '        WHERE  S.DIVISION_ID = ''82''' || CHR(10) ||
        '        AND    p_division_id = ''82''  --[E20261012-DMF0082LATFIX] 구 ON 절 바인드 상수조건 → 뷰 안으로. ON 절에 두면 집계 뷰가 lateral(VW_LAT)로 전개되어 F 행마다 MERGE JOIN OUTER+BUFFER SORT 재평가(hook #129 1순위). 비82 = 뷰 0행 → LEFT JOIN NULL 동일' || CHR(10) ||
        '        GROUP BY S.SCM_SITE_ID' || CHR(10) ||
        '    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID' || CHR(10);
    c_hist  CONSTANT VARCHAR2(32767) :=
        ' * 2026.01.30       jssbae       [E20260130-001907]_FCST&PRICE MGMT Cutoff 버전 조회 대상 테이블 변경' || CHR(10);
    c_hist2 CONSTANT VARCHAR2(32767) := c_hist ||
        ' * 2026.10.12       admin        [E20261012-DMF0082LATFIX] MF_SP INSERT 의 VD(SCM_MST_SITE 82 선집계) 인라인뷰 ON 절 바인드 조건을 뷰 안으로 이동 —' || CHR(10) ||
        ' *                               lateral(VW_LAT) 행별 MERGE JOIN OUTER 제거 (hook #129 1순위 · 6커서 전행 동일 검증)' || CHR(10);
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
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));
    IF cnt(v_src, c_mark) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 마커 없음(미적용 상태). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_src, c_new) <> 1 OR cnt(v_src, c_hist2) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20011, '중단 — 역치환 앵커 매칭 VD ' || cnt(v_src, c_new) || ' / History ' || cnt(v_src, c_hist2) || ' (각 1 기대)');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_new, c_old), c_hist2, c_hist);
    IF cnt(v_new, c_mark) <> 0 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — 역치환 뒤 마커 잔존 ' || cnt(v_new, c_mark));
    END IF;
    EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_DMF0082' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_DMF0082' AND TYPE = 'PACKAGE BODY';
    DBMS_OUTPUT.PUT_LINE('ROLLED BACK — PKG_DMF0082 BODY ' || v_st || ' · 오류 ' || v_err || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL,
       (SELECT COUNT(*) FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20261012-DMF0082LATFIX%') MARKERS
  FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
