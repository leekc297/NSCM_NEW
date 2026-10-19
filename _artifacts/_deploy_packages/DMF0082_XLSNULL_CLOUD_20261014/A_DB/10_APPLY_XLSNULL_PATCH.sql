-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL=2026-10-14 13:38:12 FETCHED=2026-10-14 13:38:40 DB=ZIOUI1(localhost)
-- 10_APPLY — [E20261014-DMF0082XLSNULL] PKG_DMF0082 BODY 패치 (전체 F5, 값 입력 없음, 멱등)
-- 내용: Excel Upload SP P_DMF0082_EXCEL_UPLOAD 의 빈값 판정 정정 — NVL(x,'') = '' / NVL(x,'') <> '' / CASE WHEN x = ''
--       (Oracle 에서 항상 거짓) → IS NULL / IS NOT NULL. AS-IS 이식본 PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD 와 같은 판정.
-- 효과: ① Model 빈칸 행 = 같은 Div/Team/End Customer/Project 의 Model 전체에 단가 반영(기존 LOC 단가 또는 RTF_SYS_RP 가 있는 Model)
--       ② 필수값 NULL · Invalid MODEL · 음수 · 0 · 통화 중복 검사가 실제로 동작 ③ 빈 월 = '0'(기존 단가 유지)
-- 방식: 이 DB 의 USER_SOURCE 를 읽어 P_DMF0082_EXCEL_UPLOAD 구간 안의 토큰 48종 80곳만 바꾼 뒤 CREATE OR REPLACE
--       (사내 전체본 복사 아님 — 다른 프로시저·다른 줄 무변경). 바꾼 자리마다 /*XLSNULL*/ 표식.
-- 가드: 표식 존재 시 무동작 · 토큰 개수가 사내와 하나라도 다르면 중단(원문 무변경) · 컴파일 오류 시 원문 자동 복원
-- 사내 ZIOUI1 기준 원문 LAST_DDL 2026-10-14 13:38:12. 실행 뒤 90_VERIFY. 원복 = 99_ROLLBACK
SET SERVEROUTPUT ON SIZE UNLIMITED
SET DEFINE OFF
DECLARE
    TYPE t_s IS TABLE OF VARCHAR2(200);
    TYPE t_n IS TABLE OF PLS_INTEGER;
    c_mark  CONSTANT VARCHAR2(40) := 'E20261014-DMF0082XLSNULL';
    c_tag   CONSTANT VARCHAR2(20) := '/*XLSNULL';   -- 치환 표식(/*XLSNULL*/) 전용 — 마커 문자열 E20261014-DMF0082XLSNULL 와 겹치지 않게
    c_old   t_s := t_s(
        'CASE WHEN ATTRIBUTE7  = '''' THEN',
        'CASE WHEN ATTRIBUTE8  = '''' THEN',
        'CASE WHEN ATTRIBUTE9  = '''' THEN',
        'CASE WHEN ATTRIBUTE10 = '''' THEN',
        'CASE WHEN ATTRIBUTE11 = '''' THEN',
        'CASE WHEN ATTRIBUTE12 = '''' THEN',
        'CASE WHEN ATTRIBUTE13 = '''' THEN',
        'CASE WHEN ATTRIBUTE14 = '''' THEN',
        'CASE WHEN ATTRIBUTE15 = '''' THEN',
        'CASE WHEN ATTRIBUTE16 = '''' THEN',
        'CASE WHEN ATTRIBUTE17 = '''' THEN',
        'CASE WHEN ATTRIBUTE18 = '''' THEN',
        'CASE WHEN ATTRIBUTE19 = '''' THEN',
        'NVL(EU.ATTRIBUTE7,  '''') <> ''''',
        'NVL(EU.ATTRIBUTE8,  '''') <> ''''',
        'NVL(EU.ATTRIBUTE9,  '''') <> ''''',
        'NVL(EU.ATTRIBUTE10, '''') <> ''''',
        'NVL(EU.ATTRIBUTE11, '''') <> ''''',
        'NVL(EU.ATTRIBUTE12, '''') <> ''''',
        'NVL(EU.ATTRIBUTE13, '''') <> ''''',
        'NVL(EU.ATTRIBUTE14, '''') <> ''''',
        'NVL(EU.ATTRIBUTE15, '''') <> ''''',
        'NVL(EU.ATTRIBUTE16, '''') <> ''''',
        'NVL(EU.ATTRIBUTE17, '''') <> ''''',
        'NVL(EU.ATTRIBUTE18, '''') <> ''''',
        'NVL(EU.ATTRIBUTE19, '''') <> ''''',
        'NVL(EU.ATTRIBUTE6, '''') <> ''''',
        'NVL(EU.ATTRIBUTE6, '''') = ''''',
        'NVL(ATTRIBUTE7,  '''') <> ''''',
        'NVL(ATTRIBUTE8,  '''') <> ''''',
        'NVL(ATTRIBUTE9,  '''') <> ''''',
        'NVL(ATTRIBUTE10, '''') <> ''''',
        'NVL(ATTRIBUTE11, '''') <> ''''',
        'NVL(ATTRIBUTE12, '''') <> ''''',
        'NVL(ATTRIBUTE13, '''') <> ''''',
        'NVL(ATTRIBUTE14, '''') <> ''''',
        'NVL(ATTRIBUTE15, '''') <> ''''',
        'NVL(ATTRIBUTE16, '''') <> ''''',
        'NVL(ATTRIBUTE17, '''') <> ''''',
        'NVL(ATTRIBUTE18, '''') <> ''''',
        'NVL(ATTRIBUTE19, '''') <> ''''',
        'NVL(ATTRIBUTE6, '''') <> ''''',
        'NVL(ATTRIBUTE1, '''') = ''''',
        'NVL(ATTRIBUTE2, '''') = ''''',
        'NVL(ATTRIBUTE3, '''') = ''''',
        'NVL(ATTRIBUTE4, '''') = ''''',
        'NVL(ATTRIBUTE5, '''') = ''''',
        'NVL(TMP.MODEL, '''') = ''''');
    c_new   t_s := t_s(
        'CASE WHEN ATTRIBUTE7 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE8 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE9 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE10 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE11 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE12 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE13 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE14 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE15 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE16 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE17 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE18 IS NULL /*XLSNULL*/ THEN',
        'CASE WHEN ATTRIBUTE19 IS NULL /*XLSNULL*/ THEN',
        'EU.ATTRIBUTE7 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE8 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE9 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE10 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE11 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE12 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE13 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE14 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE15 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE16 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE17 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE18 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE19 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE6 IS NOT NULL /*XLSNULL.EU*/',
        'EU.ATTRIBUTE6 IS NULL /*XLSNULL.EU*/',
        'ATTRIBUTE7 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE8 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE9 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE10 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE11 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE12 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE13 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE14 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE15 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE16 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE17 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE18 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE19 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE6 IS NOT NULL /*XLSNULL*/',
        'ATTRIBUTE1 IS NULL /*XLSNULL*/',
        'ATTRIBUTE2 IS NULL /*XLSNULL*/',
        'ATTRIBUTE3 IS NULL /*XLSNULL*/',
        'ATTRIBUTE4 IS NULL /*XLSNULL*/',
        'ATTRIBUTE5 IS NULL /*XLSNULL*/',
        'TMP.MODEL IS NULL /*XLSNULL.TMP*/');
    c_cnt   t_n := t_n(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2);
    c_anc   CONSTANT VARCHAR2(400) := '    -- @p_mode = 0 이면 Validation' || CHR(10);
    c_note  CONSTANT VARCHAR2(4000) :=
        '    --[E20261014-DMF0082XLSNULL] 빈값 판정 정정 (사용자 신고 2026-10-14 — Model 빈칸 업로드가 저장 0건).' || CHR(10) ||
        '    --  구 판정 NVL(x,'''') = '''' / NVL(x,'''') <> '''' / CASE WHEN x = '''' 는 Oracle 에서 '''' = NULL 이라 항상 거짓이었다.' || CHR(10) ||
        '    --  → Model 빈칸 행이 저장 대상에서 빠지고, 필수값·Invalid MODEL·음수·0·통화중복 검사가 1행도 잡지 못했으며,' || CHR(10) ||
        '    --    빈 월이 ''0'' 으로 바뀌지 않았다. AS-IS 이식본 PKG_DMF0020.P_DMF0020_EXCEL_UPLOAD 와 같이 IS NULL / IS NOT NULL 로 정정.' || CHR(10) ||
        '    --  바꾼 자리마다 /*XLSNULL*/ 표식 (원복 = 표식 자리를 원문으로 되돌림).' || CHR(10);
    v_src   CLOB;
    v_span  CLOB;
    v_new   CLOB;
    v_s     PLS_INTEGER;
    v_e     PLS_INTEGER;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
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
    v_src := REPLACE(v_src, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화 (토큰은 LF 기준)
    IF cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10)) <> 1
       OR cnt(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA') <> 1 THEN
        RAISE_APPLICATION_ERROR(-20001, '중단 — P_DMF0082_EXCEL_UPLOAD 구간 경계를 찾지 못함. 원문 무변경');
    END IF;
    v_s := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_EXCEL_UPLOAD' || CHR(10));
    v_e := DBMS_LOB.INSTR(v_src, CHR(10) || 'PROCEDURE P_DMF0082_GET_EXCEL_UPLOAD_DATA');
    v_span := SUBSTR(v_src, v_s, v_e - v_s);
    IF cnt(v_span, c_tag) > 0 THEN
        DBMS_OUTPUT.PUT_LINE('SKIP — 이미 적용됨 (표식 ' || cnt(v_span, c_tag) || '곳). 원문 무변경');
        RETURN;
    END IF;
    IF cnt(v_span, c_anc) <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, '중단 — 설명 주석 앵커 매칭 ' || cnt(v_span, c_anc) || '건 (1 기대). 원문 무변경');
    END IF;
    FOR i IN 1 .. c_old.COUNT LOOP
        IF cnt(v_span, c_old(i)) <> c_cnt(i) THEN
            RAISE_APPLICATION_ERROR(-20003, '중단 — 토큰 [' || c_old(i) || '] ' || cnt(v_span, c_old(i)) || '곳 (사내 ' || c_cnt(i) || '곳). 00_PRECHECK 결과 회신. 원문 무변경');
        END IF;
    END LOOP;
    FOR i IN 1 .. c_old.COUNT LOOP
        v_span := REPLACE(v_span, c_old(i), c_new(i));
    END LOOP;
    v_span := REPLACE(v_span, c_anc, c_note || c_anc);
    IF cnt(v_span, c_tag) <> 80 + 1 THEN
        RAISE_APPLICATION_ERROR(-20004, '중단 — 조립 결과 표식 ' || cnt(v_span, c_tag) || '곳 (81 기대). 원문 무변경');
    END IF;
    v_new := SUBSTR(v_src, 1, v_s - 1) || v_span || SUBSTR(v_src, v_e);
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
    DBMS_OUTPUT.PUT_LINE('APPLIED — PKG_DMF0082 BODY ' || v_st || ' · 표식 80곳 · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/
SELECT 'POST' CHK, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') LAST_DDL FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' ORDER BY OBJECT_TYPE;
