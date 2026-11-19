-- SOURCE-FRESH: SCM_MGR 화면 SCP0111 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-19 13:38:37
/* 20_PKG PKG_SCP0111 — 수정분만 적용(클라우드 원문이 사내와 다른 SPEC/BODY 만 CREATE OR REPLACE · 같으면 SKIP)
 * 패키지 SCP0111_CLOUD_DB_MOD_20261119_1338 · 생성 tools/CloudPkg/cloud_pkg.py 1.4.1 · 2026-11-19 13:38
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 결과 = DBMS_OUTPUT(DBeaver Output 창) 의 SKIP(같음·미적용) / APPLY(교체) / ERROR 줄로 확인
 * 되돌리기 = 05_BACKUP 을 먼저 실행해 두면 99_ROLLBACK 이 이 객체를 실행 전 원문으로 복원
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

/* PACKAGE PKG_SCP0111 — 수정분 패치를 만들 수 없어 전체 원문(지문 다를 때만 적용) · 사유: 기준본(이관 완료 원문·사내 적용 백업) 없음 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_h     NUMBER;
    v_n     NUMBER;
    v_src   CLOB;
BEGIN
    SELECT NVL(SUM(ORA_HASH(LINE || '~' || TEXT)), 0), COUNT(*) INTO v_h, v_n
      FROM USER_SOURCE WHERE NAME = 'PKG_SCP0111' AND TYPE = 'PACKAGE';
    IF v_h = 155565088572 AND v_n = 79 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE PKG_SCP0111 — 클라우드 원문이 사내와 같음(79줄) · 적용 안 함');
    ELSIF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE PKG_SCP0111 — 적용 대상(클라우드 ' || v_n || '줄 · 사내 79줄)');
    ELSE

        v_src := NULL;
        v_src := v_src || q'~PACKAGE PKG_SCP0111
IS

    /* ESS 팩 Prod Plan 입력용 Line 정보 조회 */
    PROCEDURE P_SCP0111_GET_ESS_PACK_LINE
    (
        O_RC                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* Integration PSI 조회 (월별 PIVOT) */
    PROCEDURE P_SCP0111_GET_INTEGRATION_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROM_YYYYMM           IN  VARCHAR2,
        P_TO_YYYYMM             IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_CELLITEM_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_QTY_YN                IN  VARCHAR2,
        O_RC                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 통합 PSI 월별 수량 수정 (일반 사용자) */
    PROCEDURE P_SCP0111_SAVE_INTEGRATION_PSI
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_COMPANY_ID            IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_OPERATION_GROUP       IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_SEQ_FLAG              IN  CLOB,
        P_CELLITEM_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_TO_SITE               IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_VALUATION_TYPE        IN  CLOB,
        P_TO_PRODUCT            IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_YYYYMM                IN  CLOB,
        P_MODIQTY               IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

    /* 통합 PSI Admin 사용자 수정/저장 */
    PROCEDURE P_SCP0111_SAVE_PSI_ADMIN
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_COMPANY_ID            IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  CLOB,
        P_CELLITEM_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_VALUATION_TYPE        IN  CLOB,
        P_TO_PRODUCT            IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_TO_SITE               IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_BOH_QTY               IN  CLOB,
        P_SEQ_FLAG              IN  CLOB,
        P_YYYYMM                IN  CLOB,
        P_MODIQTY               IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    );

END PKG_SCP0111;~';
        BEGIN
            EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_src;
            DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE PKG_SCP0111 — 사내 원문으로 교체(이전 클라우드 ' || v_n || '줄 → 79줄)');
        EXCEPTION WHEN OTHERS THEN
            -- ORA-24344(컴파일 오류 동반 생성) 포함 — 파일 끝 확인 SELECT 로 오류 확인
            DBMS_OUTPUT.PUT_LINE('> ERROR PACKAGE PKG_SCP0111 — ' || SQLERRM);
        END;
    END IF;
END;
/

/* PACKAGE BODY PKG_SCP0111 — 수정분만 패치 · 기준본 = 사내 적용 백업 _artifacts\_apply_corporate\SCP0111_YIELDP_ITEM_20261112\PKG_SCP0111_BODY.ASIS.sql
 * 변경 14개 구간: 기준본 L1~4 → 사내 L1~4 (삭제 1줄 · 추가 1줄) / 기준본 L8~16 → 사내 L8~13 (삭제 3줄 · 추가 0줄) / 기준본 L209~218 → 사내 L206~213 (삭제 2줄 · 추가 0줄) / 기준본 L315~321 → 사내 L310~315 (삭제 1줄 · 추가 0줄) / 기준본 L1747~1753 → 사내 L1741~1748 (삭제 1줄 · 추가 2줄) / 기준본 L2023~2029 → 사내 L2018~2024 (삭제 1줄 · 추가 1줄) / 기준본 L2750~2759 → 사내 L2745~2752 (삭제 2줄 · 추가 0줄) / 기준본 L2804~2810 → 사내 L2797~2803 (삭제 1줄 · 추가 1줄) / 기준본 L2913~2919 → 사내 L2906~2912 (삭제 1줄 · 추가 1줄) / 기준본 L2948~2960 → 사내 L2941~2953 (삭제 1줄 · 추가 1줄) / 기준본 L3040~3052 → 사내 L3033~3045 (삭제 1줄 · 추가 1줄) / 기준본 L3208~3214 → 사내 L3201~3207 (삭제 1줄 · 추가 1줄) / 기준본 L3354~3410 → 사내 L3347~3376 (삭제 51줄 · 추가 24줄) / 기준본 L3489~3495 → 사내 L3455~3461 (삭제 1줄 · 추가 1줄)
 * 가드: 이미 사내와 같으면 SKIP · 구간 기준 문구가 1건이 아니면 중단(원문 무변경) · 조립 결과 ≠ 사내 원문이면 중단 · 컴파일 오류면 원문 자동 복원 */
DECLARE
    c_dry   CONSTANT BOOLEAN := FALSE;
    v_raw   CLOB;
    v_src   CLOB;
    v_new   CLOB;
    v_o     CLOB;
    v_n     CLOB;
    v_cnt   PLS_INTEGER;
    v_pos   PLS_INTEGER;
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
    PROCEDURE hunk(k PLS_INTEGER) IS
    BEGIN
        v_cnt := cnt(v_new, v_o);
        IF v_cnt <> 1 THEN
            RAISE_APPLICATION_ERROR(-20011, '중단 — PACKAGE BODY PKG_SCP0111 변경 ' || k || ' 기준 문구 ' || v_cnt || '건(1 기대) · 클라우드 원문이 기준본과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
        END IF;
        v_pos := DBMS_LOB.INSTR(v_new, v_o);
        v_new := SUBSTR(v_new, 1, v_pos - 1) || v_n || SUBSTR(v_new, v_pos + DBMS_LOB.GETLENGTH(v_o));
    END;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_raw, TRUE);
    FOR r IN (SELECT TEXT FROM USER_SOURCE WHERE NAME = 'PKG_SCP0111' AND TYPE = 'PACKAGE BODY' ORDER BY LINE) LOOP
        DBMS_LOB.WRITEAPPEND(v_raw, LENGTH(r.TEXT), r.TEXT);
    END LOOP;
    IF NVL(DBMS_LOB.GETLENGTH(v_raw), 0) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, '중단 — 클라우드에 PACKAGE BODY PKG_SCP0111 없음 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    v_src := REPLACE(v_raw, CHR(13) || CHR(10), CHR(10));   -- CRLF 정규화(패치 문구는 LF 기준)
    IF hv(v_src) = 119480052862 AND DBMS_LOB.GETLENGTH(v_src) = 216446 THEN
        DBMS_OUTPUT.PUT_LINE('> SKIP  PACKAGE BODY PKG_SCP0111 — 이미 사내와 같음 · 원문 무변경');
        RETURN;
    END IF;
    v_new := v_src;

    -- 변경 1: 기준본 L1~4 → 사내 L1~4 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~PACKAGE BODY PKG_SCP0111
IS
/*
 * Program ID   : PKG_SCP0111
~';
    v_n := NULL;
    v_n := v_n || q'~PACKAGE BODY         PKG_SCP0111
IS
/*
 * Program ID   : PKG_SCP0111
~';
    hunk(1);
    -- 변경 2: 기준본 L8~16 → 사내 L8~13 (삭제 3줄 · 추가 0줄)
    v_o := NULL;
    v_o := v_o || q'~ *   Date       Description
 *===========================================================================================================
 * 2026.09.23   MSSQL(SCP0111_* 4개) -> Oracle 패키지 전환
 * 2026.10.06   AJS          P_SCP0111_GET_INTEGRATION_PSI 조회 속도 개선(UOM 하위질의 IA 통합 · 복수조건 INSTR 비교 · 해시 조인 고정)
 * 2026.10.19   AJS          조회조건 Model/Nickname : 쉼표 여러 값 중 하나라도 코드 또는 닉네임 부분일치 · 대소문자 무시 · ALL 은 조건 없음
 * 2026.11.04   AJS          동적 SQL 문자열 안의 주석 제거(변경 표시 · 옛 문장). 실행 문장 동일
 */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;
~';
    v_n := NULL;
    v_n := v_n || q'~ *   Date       Description
 *===========================================================================================================
 * 2026.09.23   MSSQL(SCP0111_* 4개) -> Oracle 패키지 전환
 */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;
~';
    hunk(2);
    -- 변경 3: 기준본 L209~218 → 사내 L206~213 (삭제 2줄 · 추가 0줄)
    v_o := NULL;
    v_o := v_o || q'~        V_ITEM_ID       VARCHAR2(4000 CHAR)  := UPPER(P_ITEM_ID);
        V_NICK_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_NICK_NAME)   IS NULL THEN 'N' ELSE 'Y' END;
        V_CELL_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_CELLITEM_ID) IS NULL THEN 'N' ELSE 'Y' END;
        /* 2026.10.19 AJS Model/Nickname ALL 은 조건 없음 (START) */
/*        V_ITEM_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_ITEM_ID)     IS NULL THEN 'N' ELSE 'Y' END; */
        V_ITEM_YN       VARCHAR2(1 CHAR)     := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'N' ELSE 'Y' END;
        /* 2026.10.19 AJS Model/Nickname ALL 은 조건 없음 (END) */
        V_QTY_YN        VARCHAR2(1 CHAR)     := UPPER(RTRIM(P_QTY_YN));
        V_COLUMNS       VARCHAR2(32767 CHAR) := '';
        V_SQL           CLOB;
~';
    v_n := NULL;
    v_n := v_n || q'~        V_ITEM_ID       VARCHAR2(4000 CHAR)  := UPPER(P_ITEM_ID);
        V_NICK_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_NICK_NAME)   IS NULL THEN 'N' ELSE 'Y' END;
        V_CELL_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_CELLITEM_ID) IS NULL THEN 'N' ELSE 'Y' END;
/*        V_ITEM_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_ITEM_ID)     IS NULL THEN 'N' ELSE 'Y' END; */
        V_ITEM_YN       VARCHAR2(1 CHAR)     := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'N' ELSE 'Y' END;
        V_QTY_YN        VARCHAR2(1 CHAR)     := UPPER(RTRIM(P_QTY_YN));
        V_COLUMNS       VARCHAR2(32767 CHAR) := '';
        V_SQL           CLOB;
~';
    hunk(3);
    -- 변경 4: 기준본 L315~321 → 사내 L310~315 (삭제 1줄 · 추가 0줄)
    v_o := NULL;
    v_o := v_o || q'~--               AND (:B_ITEM_YN = ''N''
--                    OR UPPER(A.ITEM_ID) IN (SELECT UPPER(SC.COLUMN_VALUE)
--                                              FROM TABLE(STRING_SPLIT(:B_ITEM_ID, '','')) SC))';
               -- 2026.10.06 AJS 품목 복수조건 STRING_SPLIT 하위질의를 INSTR 비교로 변경 (END)

            /* 자동차 사업부(81)에 대해서 MKT FCST Measure 는 조회 안되도록 */
            IF V_DIVISION_ID = '81'
~';
    v_n := NULL;
    v_n := v_n || q'~--               AND (:B_ITEM_YN = ''N''
--                    OR UPPER(A.ITEM_ID) IN (SELECT UPPER(SC.COLUMN_VALUE)
--                                              FROM TABLE(STRING_SPLIT(:B_ITEM_ID, '','')) SC))';

            /* 자동차 사업부(81)에 대해서 MKT FCST Measure 는 조회 안되도록 */
            IF V_DIVISION_ID = '81'
~';
    hunk(4);
    -- 변경 5: 기준본 L1747~1753 → 사내 L1741~1748 (삭제 1줄 · 추가 2줄)
    v_o := NULL;
    v_o := v_o || q'~                                       AND SEGMENT3    = 'Y'
                                       AND SEGMENT5    = 'P') IA
                             WHERE IA.OPERATION_ID = A.OPERATION_ID
                               AND A.DIVISION_ID   = UPPER(V_DIVISION_ID);

                            /* 3. 팩/모듈 제품의 셀 제품을 찾아서 (변경수량 X 팩당 Cell 소요량 / 수율) 가감
                                  (음수로 떨어지지 않도록) */
~';
    v_n := NULL;
    v_n := v_n || q'~                                       AND SEGMENT3    = 'Y'
                                       AND SEGMENT5    = 'P') IA
                             WHERE IA.OPERATION_ID = A.OPERATION_ID
                               AND A.DIVISION_ID   = UPPER(V_DIVISION_ID)
                               AND A.ITEM_ID       = UPPER(V_ITEM_ID);  -- [E20261112-YIELDP] 2026-11-12 저장 품목만 적재(읽는 3곳이 모두 ITEM_ID(+) = UPPER(V_ITEM_ID)) — Division 전체 적재는 SCM_YIELD_VER_H 전체 읽기로 끝나지 않음

                            /* 3. 팩/모듈 제품의 셀 제품을 찾아서 (변경수량 X 팩당 Cell 소요량 / 수율) 가감
                                  (음수로 떨어지지 않도록) */
~';
    hunk(5);
    -- 변경 6: 기준본 L2023~2029 → 사내 L2018~2024 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~
                            /* 전극 소요량을 GTT 에 적재
                               ★ AS-IS 의 SITE_TYPE = 'plant' 는 MSSQL 대소문자 무시 비교라 'PLANT' 행에 걸린다.
                                  Oracle 은 구분하므로 칸 값(전건 'PLANT') 에 맞춰 대문자로 바꾼다 - 2026.09.23 AJS */
                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
~';
    v_n := NULL;
    v_n := v_n || q'~
                            /* 전극 소요량을 GTT 에 적재
                               ★ AS-IS 의 SITE_TYPE = 'plant' 는 MSSQL 대소문자 무시 비교라 'PLANT' 행에 걸린다.
                                  Oracle 은 구분하므로 칸 값(전건 'PLANT') 에 맞춰 대문자로 바꾼다 */
                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
~';
    hunk(6);
    -- 변경 7: 기준본 L2750~2759 → 사내 L2745~2752 (삭제 2줄 · 추가 0줄)
    v_o := NULL;
    v_o := v_o || q'~                                                                 AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM               = A.YYYYMM), 0)
                                     /* 2026.10.23 AJS 최종 변경자·일시 기록 - CNS 8항 (START) */
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                     /* 2026.10.23 AJS 최종 변경자·일시 기록 - CNS 8항 (END) */
                                 WHERE A.MEASURE = 'PROD_PLAN'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
~';
    v_n := NULL;
    v_n := v_n || q'~                                                                 AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM               = A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE = 'PROD_PLAN'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
~';
    hunk(7);
    -- 변경 8: 기준본 L2804~2810 → 사내 L2797~2803 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                                 , REAL_MODI_QTY )
                            /* AS-IS 는 SITE 를 LEFT JOIN 한 뒤 그 OSP_YN 을 BOM 조인 조건의 분기에 쓴다.
                               Oracle 은 (+) 테이블의 칸이 다른 조건에 (+) 없이 나오면 그 조인을 내부조인으로
                               바꾸어 매칭 없는 행을 지우므로, 원장과 SITE 의 외부조인을 인라인 뷰로 분리한다 - 2026.09.23 AJS */
                            SELECT IA.DIVISION_ID
                                 , IA.PLANT_ID
                                 , IA.PLAN_START_YYYYMMDD
~';
    v_n := NULL;
    v_n := v_n || q'~                                 , REAL_MODI_QTY )
                            /* AS-IS 는 SITE 를 LEFT JOIN 한 뒤 그 OSP_YN 을 BOM 조인 조건의 분기에 쓴다.
                               Oracle 은 (+) 테이블의 칸이 다른 조건에 (+) 없이 나오면 그 조인을 내부조인으로
                               바꾸어 매칭 없는 행을 지우므로, 원장과 SITE 의 외부조인을 인라인 뷰로 분리한다 */
                            SELECT IA.DIVISION_ID
                                 , IA.PLANT_ID
                                 , IA.PLAN_START_YYYYMMDD
~';
    hunk(8);
    -- 변경 9: 기준본 L2913~2919 → 사내 L2906~2912 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                        THEN

                            /* 모듈 반제품이 있는 모델인지 확인 */
                            /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 - 2026.09.23 AJS
                               AS-IS 와 같이 사업부 · 계획일자 제한 없이 품목만으로 확인한다 */
                            SELECT COUNT(DISTINCT IA.ITEM_ID)
                              INTO V_CNT
~';
    v_n := NULL;
    v_n := v_n || q'~                        THEN

                            /* 모듈 반제품이 있는 모델인지 확인 */
                            /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리
                               AS-IS 와 같이 사업부 · 계획일자 제한 없이 품목만으로 확인한다 */
                            SELECT COUNT(DISTINCT IA.ITEM_ID)
                              INTO V_CNT
~';
    hunk(9);
    -- 변경 10: 기준본 L2948~2960 → 사내 L2941~2953 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , CHILD_ITEM_ID
                                     , REAL_MODI_QTY )
                                /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 - 2026.09.23 AJS */
                                SELECT IA.DIVISION_ID
                                     , IA.PLANT_ID
                                     , IA.PLAN_START_YYYYMMDD
                                     , IA.YYYYMM
                                     , C.CHILD_ITEM_ID
                                     , V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1)
~';
    v_n := NULL;
    v_n := v_n || q'~                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , CHILD_ITEM_ID
                                     , REAL_MODI_QTY )
                                /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 */
                                SELECT IA.DIVISION_ID
                                     , IA.PLANT_ID
                                     , IA.PLAN_START_YYYYMMDD
                                     , IA.YYYYMM
                                     , C.CHILD_ITEM_ID
                                     , V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1)
~';
    hunk(10);
    -- 변경 11: 기준본 L3040~3052 → 사내 L3033~3045 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , CHILD_ITEM_ID
                                     , REAL_MODI_QTY )
                                /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 - 2026.09.23 AJS */
                                SELECT IA.DIVISION_ID
                                     , IA.PLANT_ID
                                     , IA.PLAN_START_YYYYMMDD
                                     , IA.YYYYMM
                                     , C.CHILD_ITEM_ID
                                     , NVL(V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1), 0)
~';
    v_n := NULL;
    v_n := v_n || q'~                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , CHILD_ITEM_ID
                                     , REAL_MODI_QTY )
                                /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 */
                                SELECT IA.DIVISION_ID
                                     , IA.PLANT_ID
                                     , IA.PLAN_START_YYYYMMDD
                                     , IA.YYYYMM
                                     , C.CHILD_ITEM_ID
                                     , NVL(V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1), 0)
~';
    hunk(11);
    -- 변경 12: 기준본 L3208~3214 → 사내 L3201~3207 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~    )
    IS
        C_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'SCP0111_SAVE_INTEGRATION_PSI_ADMIN';
        C_MSG_DUP       CONSTANT VARCHAR2(200 CHAR) := '[99010]동일한 데이터가 존재합니다.';

        T_ACTIVE_FLAG       T_TOKEN_TAB;
        T_PLAN_TYPE         T_TOKEN_TAB;
~';
    v_n := NULL;
    v_n := v_n || q'~    )
    IS
        C_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'SCP0111_SAVE_INTEGRATION_PSI_ADMIN';
        C_MSG_DUP       CONSTANT VARCHAR2(200 CHAR) := 'MSG00428';  /* 2026-11-19 MS1 CR-008: AS-IS 99010 한글 문구 -> 등록 코드 MSG00428(KO EN CN) */

        T_ACTIVE_FLAG       T_TOKEN_TAB;
        T_PLAN_TYPE         T_TOKEN_TAB;
~';
    hunk(12);
    -- 변경 13: 기준본 L3354~3410 → 사내 L3347~3376 (삭제 51줄 · 추가 24줄)
    v_o := NULL;
    v_o := v_o || q'~                IF V_ACTIVE_FLAG = 'M'
                THEN

                    /* 2026.11.03 SCP0111 BOH DB-ONLY (START)
                       INV 행 = BOH 셀 : 같은 KEY 전체 월의 BOH 를 맞추고(월마다 다르면 조회 PIVOT 이 2행으로 갈라짐) QTY 도 BOH 변경량만큼 가감
                       그 외 = 월 수량 셀 : V_MODIQTY(가감값) 를 해당 월 QTY 에 더한다 - BOH 는 건드리지 않음 */
                    IF UPPER(V_MEASURE) = 'INV'
                    THEN

                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET BOH_QTY          = ROUND(V_BOH_QTY_N, 0)
                             , QTY              = QTY + (ROUND(V_BOH_QTY_N, 0) - NVL(TRUNC(BOH_QTY), 0))   /* 2026.11.03 SCP0111 BOH INV-QTY : AS-IS BOH 변경량만큼 INV QTY 가감 */
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = UPPER(V_MEASURE)
                           AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                           AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                           AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                           AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                           AND INCOTERMS           = UPPER(V_INCOTERMS)
                           AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE)
                           AND LNNVL(TRUNC(BOH_QTY) = ROUND(V_BOH_QTY_N, 0));

                    ELSE

                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(NVL(QTY, 0) + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = UPPER(V_MEASURE)
                           AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                           AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                           AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                           AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                           AND INCOTERMS           = UPPER(V_INCOTERMS)
                           AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE)
                           AND YYYYMM              = UPPER(V_YYYYMM);

                    END IF;
                    /* 2026.11.03 SCP0111 BOH DB-ONLY (END) */

                ELSIF V_ACTIVE_FLAG = 'I'
                THEN
~';
    v_n := NULL;
    v_n := v_n || q'~                IF V_ACTIVE_FLAG = 'M'
                THEN

                    /* 2026.11.17 SCP0111 ADMIN-M ASIS (START) AS-IS SCP0111_SAVE_INTEGRATION_PSI_ADMIN 과 같은 UPDATE 1문 - MEASURE 구분 없음
                       FE 가 월별 BOH_QTY·QTY 절대값을 보내는 전제(2026.11.03 BOH DB-ONLY 분기 대체) */
                    /* 변경된 수량으로 BOH_QTY, QTY 를 수정 */
                    UPDATE SCP_ANL_PSI_INTEGRATION
                       SET BOH_QTY          = ROUND(V_BOH_QTY_N, 0)
                         , QTY              = ROUND(V_MODI_QTY, 0)
                         , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                       AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                       AND PLANT_ID            = UPPER(V_PLANT_ID)
                       AND PLAN_START_YYYYMMDD = V_PLAN_START
                       AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                       AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                       AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                       AND MEASURE             = UPPER(V_MEASURE)
                       AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                       AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                       AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                       AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                       AND INCOTERMS           = UPPER(V_INCOTERMS)
                       AND YYYYMM              = UPPER(V_YYYYMM)
                       AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE);
                    /* 2026.11.17 SCP0111 ADMIN-M ASIS (END) */

                ELSIF V_ACTIVE_FLAG = 'I'
                THEN
~';
    hunk(13);
    -- 변경 14: 기준본 L3489~3495 → 사내 L3455~3461 (삭제 1줄 · 추가 1줄)
    v_o := NULL;
    v_o := v_o || q'~
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1'                                      AS CODE
                 , V_ERR_MSG                                 AS MSG
                 , 0                                         AS EVENT
                 , 'F'                                       AS RESULT_CODE
                 , 0                                         AS RESULT_CNT
~';
    v_n := NULL;
    v_n := v_n || q'~
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1'                                      AS CODE
                 , CASE WHEN V_ERR_MSG LIKE '[-20010]%' THEN C_MSG_DUP ELSE V_ERR_MSG END AS MSG  /* 2026-11-19 MS1: 중복 = 등록 코드만 */
                 , 0                                         AS EVENT
                 , 'F'                                       AS RESULT_CODE
                 , 0                                         AS RESULT_CNT
~';
    hunk(14);
    IF hv(v_new) <> 119480052862 OR DBMS_LOB.GETLENGTH(v_new) <> 216446 THEN
        RAISE_APPLICATION_ERROR(-20012, '중단 — PACKAGE BODY PKG_SCP0111 조립 결과가 사내 원문과 다름 → 전체 메뉴 패키지 사용. 원문 무변경');
    END IF;
    IF c_dry THEN
        DBMS_OUTPUT.PUT_LINE('> DRY   PACKAGE BODY PKG_SCP0111 — 패치 14개 구간 적용 가능(조립 결과 = 사내 원문)');
        RETURN;
    END IF;
    BEGIN
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_new;
    EXCEPTION WHEN OTHERS THEN
        NULL;   -- 컴파일 오류 동반 생성(ORA-24344)도 예외로 온다 → 아래 STATUS 검사에서 판정·원문 복원
    END;
    SELECT STATUS INTO v_st FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SCP0111' AND OBJECT_TYPE = 'PACKAGE BODY';
    SELECT COUNT(*) INTO v_err FROM USER_ERRORS WHERE NAME = 'PKG_SCP0111' AND TYPE = 'PACKAGE BODY';
    IF v_st <> 'VALID' OR v_err > 0 THEN
        FOR e IN (SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0111' AND TYPE = 'PACKAGE BODY' ORDER BY SEQUENCE FETCH FIRST 10 ROWS ONLY) LOOP
            DBMS_OUTPUT.PUT_LINE('  ERR L' || e.LINE || ':' || e.POSITION || ' ' || e.TEXT);
        END LOOP;
        EXECUTE IMMEDIATE 'CREATE OR REPLACE ' || v_raw;   -- 원문 자동 복원
        RAISE_APPLICATION_ERROR(-20013, 'PACKAGE BODY PKG_SCP0111 컴파일 실패(' || v_st || ', 오류 ' || v_err || ') → 원문 복원함');
    END IF;
    DBMS_OUTPUT.PUT_LINE('> APPLY PACKAGE BODY PKG_SCP0111 — 패치 14개 구간 적용 · ' || v_st || ' · ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
END;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SCP0111' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0111' ORDER BY TYPE, SEQUENCE;
