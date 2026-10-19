-- 10_APPLY — [E20261012-DMF0082LATFIX] PKG_DMF0082 BODY 외과 치환 패치 (전체 F5, 값 입력 없음, 멱등)
-- 방식: 이 DB 의 USER_SOURCE 를 그대로 읽어(클라우드 현재 원문 기준 — 사내 전체본 복사 아님) 앵커 1곳만 치환 후 CREATE OR REPLACE.
--       클라우드 BODY 에는 사내 AJS 10-08/10-11/10-12 수정이 없으므로 전체본 교체 대신 패치형으로 그 차이를 건드리지 않는다.
-- 변경 1곳: GET_MAIN_DATA MF_SP INSERT 의 VD 인라인뷰(SCM_MST_SITE 82 VMI_STD_DIO 선집계) ON 절 `AND p_division_id = '82'` → 뷰 WHERE 안으로 이동
--   등가: 비82 → 뷰 0행 → LEFT JOIN 미매칭 → VD.VMI_STD_DIO NULL (기존 ON 거짓과 동일) / 82 → 동일. 사내 6커서 전행 동등성 검증(40/81/82 × 2사용자).
--   효과: 집계 뷰의 lateral(VW_LAT) 전개 → F 행마다 MERGE JOIN OUTER+BUFFER SORT 재평가 제거 (hook #129 1순위)
-- 가드: 마커 존재 시 무동작 · 앵커 1건 아니면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 실행 뒤 90_VERIFY 로 마커 2·VALID·계획 확인. 원복 = 99_ROLLBACK
-- 사내 ZIOUI1 적용 완료 2026-10-12 10:31:26 (같은 치환, apply_latfix.py · 6커서 동등성 PASS 40/81/82 × minyonglee1/k0101)
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    v_src   CLOB;
    v_new   CLOB;
    v_cnt   PLS_INTEGER := 0;
    v_pos   PLS_INTEGER := 1;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261012-DMF0082LATFIX';
    c_old   CONSTANT VARCHAR2(32767) :=
        '        FROM   SCM_MGR.SCM_MST_SITE S' || CHR(10) ||
        '        WHERE  S.DIVISION_ID = ''82''' || CHR(10) ||
        '        GROUP BY S.SCM_SITE_ID' || CHR(10) ||
        '    ) VD ON  VD.SCM_SITE_ID = F.SCM_SITE_ID' || CHR(10) ||
        '         AND p_division_id  = ''82''' || CHR(10);
    c_new   CONSTANT VARCHAR2(32767) :=   -- 한글 주석 포함(UTF8 3바이트) → 바이트 한도 여유
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
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (앵커는 LF 기준)
    IF cnt(v_src, c_mark) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (마커 ' || cnt(v_src, c_mark) || '곳). 원문 무변경');
        RETURN;
    END IF;
    v_cnt := cnt(v_src, c_old);
    IF v_cnt <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — VD 앵커 매칭 ' || v_cnt || '건 (1 기대). 원문이 사내 기준과 다름 → 00_PRECHECK L1 문맥 확인');
    END IF;
    IF cnt(v_src, c_hist) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — History 앵커 매칭 ' || cnt(v_src, c_hist) || '건 (1 기대)');
    END IF;
    -- GET_MAIN_DATA 헤더의 History 앵커만 바꾸기 위해 첫 출현(=GET_MAIN_DATA, BODY 최상단 프로시저) 위치 확인
    v_pos := DBMS_LOB.INSTR(v_src, c_hist, 1);
    IF v_pos > DBMS_LOB.INSTR(v_src, 'PROCEDURE P_DMF0082_POPUP_GET_FUTUREPRICE_INFO', 1) THEN
        RAISE_APPLICATION_ERROR(-20003, '중단 — History 앵커가 GET_MAIN_DATA 구간 밖');
    END IF;
    v_new := REPLACE(REPLACE(v_src, c_old, c_new), c_hist, c_hist2);
    IF cnt(v_new, c_mark) <> 2 THEN   -- VD 1줄 + History 첫 줄 (History 둘째 줄은 마커 없음)
        RAISE_APPLICATION_ERROR(-20004, '중단 — 치환 결과 마커 ' || cnt(v_new, c_mark) || '곳 (2 기대)');
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
