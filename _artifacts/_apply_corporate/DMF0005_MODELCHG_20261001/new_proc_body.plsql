/*
 * ==========================================================================================================
 * P_DMF0005_SAVE_MODEL_CHANGE_POPUP — Model Code Change 팝업 저장 (40 사업부 ITEM_ID 일괄 변경)
 * ----------------------------------------------------------------------------------------------------------
 * AS-IS : LGCE_SCMDEV dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP (1,502줄, modify 2023-08-23)
 *         호출 = GSCM.DM.Plan.UIL.POPUP.DMF0005_ModelCodeChange.SaveData
 *         [C20220103-000584] 소형 패커 코드 변경 관리 / [C20220121-000372] 소형사업부 Model Code Change
 * 입력  : P_DATA = JSON 배열 [{ "ITEM_ID_BEFORE": "...", "ITEM_ID_AFTER": "..." }, ...]
 *         (AS-IS '^' 구분 3배열 → PKG 형제 SAVE SP 의 JSON CLOB 관례로 통일. 키 = AS-IS 컬럼명)
 *         P_USER_ID = LAST_UPDATED_BY / CREATED_BY
 * 출력  : O_RESULT_CURSOR (CODE, MSG, EVENT)
 *           성공   '0'  / 'SUCCESS' / 처리한 변경쌍 수 (AS-IS 화면 "{0}개의 데이터가 저장되었습니다" 의 {0})
 *           검증   '-1' / AS-IS 검증 문구 원문 / '0'
 *           예외   RAISE_APPLICATION_ERROR(-20001) — 전체 ROLLBACK
 * 변환 메모
 *   1) 검증 7종은 AS-IS 순서·문구 그대로 (검증 종류 순서대로, 종류 안에서는 입력 순서 첫 위반 1건)
 *      - MSSQL LEN('')=0 → Oracle ''=NULL 이므로 NVL(LENGTH(x),0) 로 동등 처리
 *      - MSSQL CI 비교 동등 — 입력값 UPPER(TRIM()) (DM_MST_ITEM_SINGLE_V 40 사업부 소문자 ITEM_ID 0건 실측 2026-10-01)
 *   2) 38 테이블 갱신 = 테이블별 대상 ROWID 선수집 → ROWID UPDATE (AS-IS UPDATE..FROM JOIN 동시 평가와 동등 —
 *      A→B, B→C 가 같은 배치여도 연쇄 변환되지 않음). 같은 BEFORE 가 여러 AFTER 면 MAX(AFTER) 로 결정화.
 *      DIVISION_ID='40' 필터 = 37 테이블 / DM_MST_EDI_CUST_MATERIAL_INFO 1 테이블은 AS-IS 대로 필터 없음
 *   3) 이력 DM_DNM_ITEM_CODE_CHANGE_HISTORY — (BEFORE,AFTER) 별 DATA_SEQ = 갱신 전 기존 MAX+1 (전 테이블 공통),
 *      갱신 건수 > 0 인 (쌍, 테이블) 만 1행
 *   4) 입력 중복 쌍은 DISTINCT (AS-IS 는 중복 쌍이 COUNT 를 배로 집계해 이력 건수가 부풀었다)
 * 2026.10.01   Claude(Code)   [DMF0005] AS-IS DMF0005_SAVE_MODEL_CHANGE_POPUP 변환 신규
 * ==========================================================================================================
 */
PROCEDURE P_DMF0005_SAVE_MODEL_CHANGE_POPUP (
      P_DATA            IN CLOB
    , P_USER_ID         IN VARCHAR2
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_CNT           NUMBER := 0;
    V_TOT_ROWS      NUMBER := 0;

    TYPE T_VC_TAB   IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
    TYPE T_RID_TAB  IS TABLE OF UROWID        INDEX BY PLS_INTEGER;
    TYPE T_SEQ_MAP  IS TABLE OF NUMBER        INDEX BY VARCHAR2(401);
    TYPE T_STR_MAP  IS TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(200);
    TYPE T_CNT_MAP  IS TABLE OF NUMBER        INDEX BY VARCHAR2(200);
    V_BEFORE        T_VC_TAB;      -- 변경 전 ITEM_ID (입력 순서, 중복 쌍 제거)
    V_AFTER         T_VC_TAB;      -- 변경 후 ITEM_ID
    V_SEQ           T_SEQ_MAP;     -- (BEFORE || CHR(1) || AFTER) → 이력 DATA_SEQ
    V_MAP           T_STR_MAP;     -- BEFORE → AFTER (같은 BEFORE 가 여러 AFTER 면 MAX — AS-IS UPDATE..FROM 비결정 → 결정화)
    V_BEF_LIST      SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();   -- 갱신 대상 BEFORE 목록 (SQL 바인드용)

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG := P_MSG;
        RAISE EX_BIZ_EX;
    END;

    -- 테이블 1개 갱신
    --   ① 대상 ROWID 를 먼저 모두 수집 (BEFORE 목록 IN — 컬렉션 건수 힌트로 ITEM_ID 인덱스 사용 / 무인덱스 테이블은 1회 스캔)
    --   ② 수집한 ROWID 로 UPDATE — 수집 후 갱신이라 AS-IS UPDATE..FROM 동시 평가와 같다 (A→B, B→C 연쇄 없음)
    --   ③ BEFORE 별 건수(= AS-IS #RESULTS_INSERT COUNT) 로 이력 1행씩
    --   [2026-10-01 성능] 1차본은 테이블마다 JSON_TABLE(:P_DATA) 를 조인 원천으로 써서 건수 오추정(8168)
    --   → 대형 테이블에서 문장당 수 분. 변경쌍은 JSON 1회 파싱 후 컬렉션으로만 전달한다.
    PROCEDURE CHANGE_TABLE(P_TABLE IN VARCHAR2, P_DIV40 IN BOOLEAN) IS
        V_FILTER  VARCHAR2(100) := CASE WHEN P_DIV40 THEN ' AND X.DIVISION_ID = ''40''' END;
        V_RIDS    T_RID_TAB;
        V_ITEMS   T_VC_TAB;
        V_NEWS    T_VC_TAB;
        V_N       T_CNT_MAP;
        V_K       VARCHAR2(200);
    BEGIN
        EXECUTE IMMEDIATE
               'SELECT X.ROWID, X.ITEM_ID FROM ' || P_TABLE || ' X'
            || ' WHERE X.ITEM_ID IN (SELECT /*+ CARDINALITY(L 10) */ L.COLUMN_VALUE FROM TABLE(:L) L)' || V_FILTER
            BULK COLLECT INTO V_RIDS, V_ITEMS
            USING V_BEF_LIST;

        IF V_RIDS.COUNT = 0 THEN
            RETURN;
        END IF;

        FOR I IN 1 .. V_RIDS.COUNT LOOP
            V_NEWS(I) := V_MAP(V_ITEMS(I));
            V_N(V_ITEMS(I)) := NVL(CASE WHEN V_N.EXISTS(V_ITEMS(I)) THEN V_N(V_ITEMS(I)) END, 0) + 1;
        END LOOP;

        FORALL I IN 1 .. V_RIDS.COUNT
            EXECUTE IMMEDIATE
                   'UPDATE ' || P_TABLE
                || '   SET ITEM_ID = :A, LAST_UPDATED_BY = :U, LAST_UPDATE_DATE = SYSDATE'
                || ' WHERE ROWID = :R'
                USING V_NEWS(I), P_USER_ID, V_RIDS(I);

        V_K := V_N.FIRST;
        WHILE V_K IS NOT NULL LOOP
            INSERT INTO DM_DNM_ITEM_CODE_CHANGE_HISTORY (
                  BEFORE_CODE, AFTER_CODE, DATA_SEQ, TABLE_NAME, ROW_COUNT
                , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            ) VALUES (
                  V_K, V_MAP(V_K), V_SEQ(V_K || CHR(1) || V_MAP(V_K)), P_TABLE, V_N(V_K)
                , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
            );
            V_TOT_ROWS := V_TOT_ROWS + V_N(V_K);
            V_K := V_N.NEXT(V_K);
        END LOOP;
    END CHANGE_TABLE;

BEGIN
    SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

    /* =========================
       변경쌍 적재 (입력 순서 보존, 중복 쌍 제거)
       ========================= */
    SELECT B, A
      BULK COLLECT INTO V_BEFORE, V_AFTER
      FROM (
            SELECT UPPER(TRIM(J.ITEM_ID_BEFORE)) AS B
                 , UPPER(TRIM(J.ITEM_ID_AFTER))  AS A
                 , MIN(J.RN)                     AS RN
              FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
                         RN             FOR ORDINALITY
                       , ITEM_ID_BEFORE VARCHAR2(200) PATH '$.ITEM_ID_BEFORE'
                       , ITEM_ID_AFTER  VARCHAR2(200) PATH '$.ITEM_ID_AFTER')) J
             GROUP BY UPPER(TRIM(J.ITEM_ID_BEFORE)), UPPER(TRIM(J.ITEM_ID_AFTER))
           )
     ORDER BY RN;

    IF V_BEFORE.COUNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;

    /* =========================
       VALIDATION (AS-IS 순서·문구 원문)
       ========================= */
    -- 문자 길이가 12자리인지 (BEFORE)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF NVL(LENGTH(V_BEFORE(I)), 0) <> 12 THEN
            RAISE_INVALID('Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.' || CHR(10) || 'MODEL : ' || V_BEFORE(I));
        END IF;
    END LOOP;
    -- 문자 길이가 12자리인지 (AFTER)
    FOR I IN 1 .. V_AFTER.COUNT LOOP
        IF NVL(LENGTH(V_AFTER(I)), 0) <> 12 THEN
            RAISE_INVALID('Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.' || CHR(10) || 'MODEL : ' || V_AFTER(I));
        END IF;
    END LOOP;
    -- 앞의 11자리가 같은지
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF SUBSTR(V_BEFORE(I), 1, 11) <> SUBSTR(V_AFTER(I), 1, 11) THEN
            RAISE_INVALID('Model 코드의 앞 11자리가 서로 다르므로 변경할 수 없습니다.' || 'MODEL : ' || V_BEFORE(I) || ', ' || V_AFTER(I));
        END IF;
    END LOOP;
    -- 맨 앞 두 글자가 MP 인지 (BEFORE)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF SUBSTR(V_BEFORE(I), 1, 2) <> 'MP' THEN
            RAISE_INVALID('Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.' || 'MODEL : ' || V_BEFORE(I));
        END IF;
    END LOOP;
    -- 맨 앞 두 글자가 MP 인지 (AFTER)
    FOR I IN 1 .. V_AFTER.COUNT LOOP
        IF SUBSTR(V_AFTER(I), 1, 2) <> 'MP' THEN
            RAISE_INVALID('Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.' || 'MODEL : ' || V_AFTER(I));
        END IF;
    END LOOP;
    -- 변경 전·후 모델코드가 동일한지 (12번째 글자가 다른지)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF V_BEFORE(I) = V_AFTER(I) THEN
            RAISE_INVALID('변경전 후의 모델코드가 동일합니다.' || 'MODEL : ' || V_BEFORE(I));
        END IF;
    END LOOP;
    -- 40 사업부 품목 마스터 존재 여부 (BEFORE 우선 표기)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        SELECT COUNT(*) INTO V_CNT FROM DM_MST_ITEM_SINGLE_V WHERE ITEM_ID = V_BEFORE(I) AND DIVISION_ID = '40';
        IF V_CNT = 0 THEN
            RAISE_INVALID(V_BEFORE(I) || '은 존재하지 않는 코드입니다.');
        END IF;
        SELECT COUNT(*) INTO V_CNT FROM DM_MST_ITEM_SINGLE_V WHERE ITEM_ID = V_AFTER(I) AND DIVISION_ID = '40';
        IF V_CNT = 0 THEN
            RAISE_INVALID(V_AFTER(I) || '은 존재하지 않는 코드입니다.');
        END IF;
    END LOOP;

    /* =========================
       BEFORE → AFTER 매핑 / 갱신 대상 BEFORE 목록 (같은 BEFORE 다중 AFTER = MAX 채택)
       ========================= */
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF NOT V_MAP.EXISTS(V_BEFORE(I)) THEN
            V_MAP(V_BEFORE(I)) := V_AFTER(I);
            V_BEF_LIST.EXTEND;
            V_BEF_LIST(V_BEF_LIST.COUNT) := V_BEFORE(I);
        ELSIF V_AFTER(I) > V_MAP(V_BEFORE(I)) THEN
            V_MAP(V_BEFORE(I)) := V_AFTER(I);
        END IF;
    END LOOP;

    /* =========================
       이력 DATA_SEQ — (BEFORE, AFTER) 별 기존 MAX + 1 (갱신 전 산정, 전 테이블 공통)
       ========================= */
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        SELECT NVL(MAX(DATA_SEQ), 0) + 1
          INTO V_CNT
          FROM DM_DNM_ITEM_CODE_CHANGE_HISTORY
         WHERE BEFORE_CODE = V_BEFORE(I)
           AND AFTER_CODE  = V_AFTER(I);
        V_SEQ(V_BEFORE(I) || CHR(1) || V_AFTER(I)) := V_CNT;
    END LOOP;

    /* =========================
       TABLE UPDATE — AS-IS 38 테이블 (순서 동일)
       ========================= */
    CHANGE_TABLE('DM_ANL_KPI_RTF_DEMAND',            TRUE);
    CHANGE_TABLE('DM_ANL_KPI_RTF_SALES',             TRUE);
    CHANGE_TABLE('DM_ANL_KPI_SALES_ACCURACY',        TRUE);
    CHANGE_TABLE('DM_ANL_KPI_SUMMARY',               TRUE);
    CHANGE_TABLE('DM_DNM_EDI_CALLOFF_ITEM',          TRUE);
    CHANGE_TABLE('DM_DNM_SALES_RESULT_IF',           TRUE);
    CHANGE_TABLE('DM_HI_CUST_FCST_INPUT',            TRUE);
    CHANGE_TABLE('DM_HI_MKT_FCST_CHANGE',            TRUE);
    CHANGE_TABLE('DM_HI_SALES_INPUT',                TRUE);
    CHANGE_TABLE('DM_HI_SITE_ITEM_MAPPING',          TRUE);
    CHANGE_TABLE('DM_HI_SITE_ITEM_MAPPING_ROWDATA',  TRUE);
    CHANGE_TABLE('DM_MST_BUCKET_CONVERSION',         TRUE);
    CHANGE_TABLE('DM_MST_BUCKET_CONVERSION_H',       TRUE);
    CHANGE_TABLE('DM_MST_CAPACITY_ALLOCATION',       TRUE);
    CHANGE_TABLE('DM_MST_CAPACITY_ALLOCATION_H',     TRUE);
    CHANGE_TABLE('DM_MST_CUSTOMER_MODEL',            TRUE);
    CHANGE_TABLE('DM_MST_CUSTOMER_MODEL_H',          TRUE);
    CHANGE_TABLE('DM_MST_EDI_CUST_MATERIAL_INFO',    FALSE);   -- AS-IS: DIVISION_ID 필터 없음 (원문 유지)
    CHANGE_TABLE('DM_PLN_BP_FCST',                   TRUE);
    CHANGE_TABLE('DM_PLN_BP_FCST_H',                 TRUE);
    CHANGE_TABLE('DM_PLN_CUSTOMER_PSI',              TRUE);
    CHANGE_TABLE('DM_PLN_CUSTOMER_PSI_H',            TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST',                  TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_CONFIRM',          TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_H',                TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_PK_DATA_UPDATE_H', TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_RESULT',           TRUE);
    CHANGE_TABLE('DM_PLN_PR_DETAIL',                 TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN',                TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN_H',              TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN_REPORT_H',       TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN_RESULT',         TRUE);
    CHANGE_TABLE('SCM_MST_FUTURE_PRICE',             TRUE);
    CHANGE_TABLE('SCM_MST_FUTURE_PRICE_H',           TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM',                TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM_H',              TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM_PRIORITY',       TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM_PRIORITY_H',     TRUE);

    COMMIT;

    SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', V_TOT_ROWS, '########## END of procedure ##########', NULL, SYSDATE);

    V_CNT := V_BEFORE.COUNT;   -- 컬렉션 속성은 SQL 안에서 직접 참조 불가 (ORA-00904)
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'INVALID', 0, '########## END of procedure ##########', SUBSTR(V_ERR_MSG, 1, 500), SYSDATE);
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '0' AS EVENT FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ERROR', 0, SUBSTR(SQLERRM, 1, 1000)
                                   , SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500), SYSDATE);
        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-'
        );
END P_DMF0005_SAVE_MODEL_CHANGE_POPUP;
