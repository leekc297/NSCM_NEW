/* SCP0104 사용자의견 DB 보완 : 클라우드 이관(수정 구간만)
 * 생성 2026-11-17 10:15:27 · 사내 DB=ZIOUI1 기준 · 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 객체마다 독립 블록 — 한 객체가 중단돼도 그 객체 원문은 무변경이고 나머지는 계속 진행된다.
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED


-- SOURCE-FRESH: SCM_MGR.PKG_SCP0104 PACKAGE BODY LAST_DDL=2026-11-17 09:47:01 FETCHED=2026-11-17 10:15:27 DB=ZIOUI1
/* PACKAGE BODY PKG_SCP0104 — SCP0104 사용자의견 보완 · 수정 구간만 패치 (사내 적용본 LAST_DDL 2026-11-17 09:47:01)
 * 변경 10개 구간. 클라우드 원문의 다른 부분은 건드리지 않는다.
 * 가드: 이미 사내와 같으면 SKIP · 구간별 기준 문구 1건이면 치환, 0건+수정 후 문구 존재면 반영된 구간으로 건너뜀, 그 밖은 중단(원문 무변경) · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;   -- TRUE 로 바꾸면 적용하지 않고 가능 여부만 출력
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_co    PLS_INTEGER;
    v_cn    PLS_INTEGER;
    v_pos   PLS_INTEGER;
    v_done  PLS_INTEGER := 0;
    v_skip  PLS_INTEGER := 0;
    v_st    VARCHAR2(30);
    v_err   PLS_INTEGER;
    FUNCTION hv(c CLOB) RETURN NUMBER IS
        n NUMBER := 0; p INTEGER := 1; i INTEGER := 0; l INTEGER := NVL(DBMS_LOB.GETLENGTH(c), 0);
    BEGIN
        WHILE p <= l LOOP
            i := i + 1;
            n := n + DBMS_UTILITY.GET_HASH_VALUE(i || '~' || DBMS_LOB.SUBSTR(c, 1000, p), 1, 1073741824);
            p := p + 1000;
        END LOOP;
        RETURN n;
    END;
    FUNCTION cnt(c CLOB, t CLOB) RETURN PLS_INTEGER IS
        n PLS_INTEGER := 0; p PLS_INTEGER := 1;
    BEGIN
        LOOP
            p := DBMS_LOB.INSTR(c, t, p);
            EXIT WHEN NVL(p, 0) = 0;
            n := n + 1; p := p + DBMS_LOB.GETLENGTH(t);
        END LOOP;
        RETURN n;
    END;
    PROCEDURE hunk(k PLS_INTEGER, e PLS_INTEGER DEFAULT 1) IS
    BEGIN
        v_co := cnt(v_new, v_o);
        v_cn := cnt(v_new, v_n);
        IF v_co = e AND e = 1 THEN
            v_pos := DBMS_LOB.INSTR(v_new, v_o);
            v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
            v_done := v_done + 1;
        ELSIF v_co = e THEN
            v_new := REPLACE(v_new, v_o, v_n);   -- 같은 줄 e건 모두 치환
            v_done := v_done + 1;
        ELSIF v_co = 0 AND v_cn >= 1 THEN
            v_skip := v_skip + 1;   -- 이미 반영된 구간
        ELSE
            RAISE_APPLICATION_ERROR(-20011, '중단 — PKG_SCP0104 변경 ' || k || ' 기준 문구 ' || v_co || '건 · 수정 후 문구 ' || v_cn || '건. 클라우드 원문의 이 구간이 사내 수정 전과 다름 → 이 객체는 수동 확인. 원문 무변경');
        END IF;
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_SCP0104' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_SCP0104 없음. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));
    IF hv(v_src) = 205698020007 AND DBMS_LOB.GETLENGTH(v_src) = 372560 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PKG_SCP0104 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L23~28 → 사내 L23~30 (삭제 0줄 · 추가 2줄)
    v_o := NULL;
    v_o := v_o || q'~BEGIN

    IF V_LEN = 0 THEN
        RETURN;
    END IF;

~';
    v_n := NULL;
    v_n := v_n || q'~BEGIN

    IF V_LEN = 0 THEN
        /* 2026.11.17 SCP0104 보완: 빈 값도 1행(AS-IS dbo.String_Split 등가) */
        INSERT INTO GT_SCP0104_ASGN_TOKEN ( SLOT_NO, NR, TOKEN ) VALUES ( P_SLOT_NO, 1, NULL );
        RETURN;
    END IF;

~';
    hunk(1, 1);
    -- 변경 2: 기준본 L64~69 → 사내 L66~73 (삭제 0줄 · 추가 2줄)
    v_o := NULL;
    v_o := v_o || q'~        V_FROM := V_POS + LENGTH(P_DELIM);

        IF V_FROM > V_LEN THEN
            EXIT;
        END IF;

~';
    v_n := NULL;
    v_n := v_n || q'~        V_FROM := V_POS + LENGTH(P_DELIM);

        IF V_FROM > V_LEN THEN
            /* 2026.11.17 SCP0104 보완: 끝 구분자 뒤 빈 토큰 1행(AS-IS dbo.String_Split 등가) */
            INSERT INTO GT_SCP0104_ASGN_TOKEN ( SLOT_NO, NR, TOKEN ) VALUES ( P_SLOT_NO, V_NR + 1, NULL );
            EXIT;
        END IF;

~';
    hunk(2, 1);
    -- 변경 3: 기준본 L1793~1800 → 사내 L1797~1807 (삭제 2줄 · 추가 5줄)
    v_o := NULL;
    v_o := v_o || q'~         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');
    V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');

    /* 최근 3개월 평균 일수 */
    SELECT NVL(AVG(DAY_CNT), 1.0)
~';
    v_n := NULL;
    v_n := v_n || q'~         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    /* 2026.11.17 SCP0104 보완: 변경 행이 없으면 V_VERSION 이 NULL, AS-IS 처럼 NULL 로 두고 계속(ORA-01840 방지) */
    IF V_VERSION IS NOT NULL THEN
        V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');
        V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');
    END IF;

    /* 최근 3개월 평균 일수 */
    SELECT NVL(AVG(DAY_CNT), 1.0)
~';
    hunk(3, 1);
    -- 변경 4: 기준본 L3116~3123 → 사내 L3123~3133 (삭제 2줄 · 추가 5줄)
    v_o := NULL;
    v_o := v_o || q'~         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');
    V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');

    SELECT NVL(AVG(DAY_CNT), 1.0)
      INTO V_RESULT_DAY_CNT
~';
    v_n := NULL;
    v_n := v_n || q'~         , V_VERSION_SEQ
      FROM GT_SCP_CAPA_LINE_ASSIGN_KEYS;

    /* 2026.11.17 SCP0104 보완: 변경 행이 없으면 V_VERSION 이 NULL, AS-IS 처럼 NULL 로 두고 계속(ORA-01840 방지) */
    IF V_VERSION IS NOT NULL THEN
        V_RESULT_TO_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -1), 'YYYYMM');
        V_RESULT_FR_YYYYMM := TO_CHAR(ADD_MONTHS(TO_DATE(V_VERSION || '01', 'YYYYMMDD'), -3), 'YYYYMM');
    END IF;

    SELECT NVL(AVG(DAY_CNT), 1.0)
      INTO V_RESULT_DAY_CNT
~';
    hunk(4, 1);
    -- 변경 5: 기준본 L4515~4529 → 사내 L4525~4541 (삭제 1줄 · 추가 3줄)
    v_o := NULL;
    v_o := v_o || q'~            OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN = V_VALID_FLAG)
         ORDER BY A.DIVISION_ID
                , IA.SITE_ID
                , IB.COMPANY_ID
                , IC.PLANT_ID
                , ID.FACTORY_ID
                , IE.LINE_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY;
~';
    v_n := NULL;
    v_n := v_n || q'~            OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN = V_VALID_FLAG)
         ORDER BY A.DIVISION_ID
                , IA.SITE_ID
                , IB.COMPANY_ID
                , IC.PLANT_ID
                , ID.FACTORY_ID
                , IE.LINE_ID
                , A.OPERATION_ID      /* 2026.11.17 SCP0104 보완: AS-IS ORDER BY 등가 */
                , A.ELTR_LN_TP_CD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_SOP_ASSEMBLY;
~';
    hunk(5, 1);
    -- 변경 6: 기준본 L4664~4678 → 사내 L4676~4692 (삭제 1줄 · 추가 3줄)
    v_o := NULL;
    v_o := v_o || q'~            OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN = V_VALID_FLAG)
         ORDER BY A.DIVISION_ID
                , IA.SITE_ID
                , IB.COMPANY_ID
                , IC.PLANT_ID
                , ID.FACTORY_ID
                , IE.LINE_ID;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_SOP_ELTR;
~';
    v_n := NULL;
    v_n := v_n || q'~            OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN = V_VALID_FLAG)
         ORDER BY A.DIVISION_ID
                , IA.SITE_ID
                , IB.COMPANY_ID
                , IC.PLANT_ID
                , ID.FACTORY_ID
                , IE.LINE_ID
                , A.OPERATION_ID      /* 2026.11.17 SCP0104 보완: AS-IS ORDER BY 등가 */
                , A.ELTR_LN_TP_CD;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0104_GET_CAPA_LINE_SOP_ELTR;
~';
    hunk(6, 1);
    -- 변경 7: 기준본 L4758~4764 → 사내 L4772~4778 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~          WHERE NOT EXISTS (SELECT 1
                              FROM SCP_MST_CAPA_DUMMY_CODE A
                             WHERE A.CODE_TP = V_CODE_TP
                               AND A.NAME    = V_NAME);

    SELECT COUNT(*)
      INTO N_CNT
~';
    v_n := NULL;
    v_n := v_n || q'~          WHERE NOT EXISTS (SELECT 1
                              FROM SCP_MST_CAPA_DUMMY_CODE A
                             WHERE A.CODE_TP = V_CODE_TP
                               AND UPPER(A.NAME) = UPPER(V_NAME));   /* 2026.11.17 SCP0104 보완: AS-IS CI 정렬 등가 */

    SELECT COUNT(*)
      INTO N_CNT
~';
    hunk(7, 1);
    -- 변경 8: 기준본 L4771~4777 → 사내 L4785~4791 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~        OPEN O_RC1 FOR
            SELECT *
              FROM SCP_MST_CAPA_DUMMY_CODE
             WHERE NAME = V_NAME;

    ELSE

~';
    v_n := NULL;
    v_n := v_n || q'~        OPEN O_RC1 FOR
            SELECT *
              FROM SCP_MST_CAPA_DUMMY_CODE
             WHERE UPPER(NAME) = UPPER(V_NAME);   /* 2026.11.17 SCP0104 보완: AS-IS CI 정렬 등가 */

    ELSE

~';
    hunk(8, 1);
    -- 변경 9: 기준본 L6263~6275 → 사내 L6277~6289 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  UPPER(A.NICK_NAME) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    ELSE
~';
    v_n := NULL;
    v_n := v_n || q'~                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */ /* 2026.11.17 SCP0104 보완: AS-IS ITEM_ID 비교 */
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    ELSE
~';
    hunk(9, 1);
    -- 변경 10: 기준본 L6470~6482 → 사내 L6484~6496 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  UPPER(A.NICK_NAME) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    END IF;
~';
    v_n := NULL;
    v_n := v_n || q'~                AND (TRIM(V_ELECTRODE_TYPE) IS NULL
                 OR  UPPER(V_ELECTRODE_TYPE) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.ELTR_LN_TP_CD IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(V_ELECTRODE_TYPE, ','))))
                AND (TRIM(V_ITEM_ID) IS NULL
                 OR  UPPER(V_ITEM_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
                 OR  UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */ /* 2026.11.17 SCP0104 보완: AS-IS ITEM_ID 비교 */
                                       FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                AND (TRIM(V_VALID_FLAG) IS NULL
                 OR  UPPER(V_VALID_FLAG_ALL) = 'ALL'                 /* 조회조건 ALL 은 조건 없음 */
                 OR  A.VALID_YN = V_VALID_FLAG);

    END IF;
~';
    hunk(10, 1);
    IF v_done = 0 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PKG_SCP0104 — 변경 구간 ' || v_skip || '개가 모두 이미 반영됨 · 원문 무변경');
        RETURN;
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PKG_SCP0104 — 적용 가능: 치환 ' || v_done || '개 구간 · 이미 반영 ' || v_skip || '개 구간');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SCP0104' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_SCP0104' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0104' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;
        RAISE_APPLICATION_ERROR(-20013, 'PKG_SCP0104 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PKG_SCP0104 — 치환 ' || v_done || '개 구간 · 이미 반영 ' || v_skip || '개 · ' || v_st
        || CASE WHEN hv(v_new) = 205698020007 AND DBMS_LOB.GETLENGTH(v_new) = 372560 THEN ' · 결과 = 사내 원문' ELSE ' · 수정 구간만 반영(그 밖의 클라우드↔사내 차이는 그대로)' END
        || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

