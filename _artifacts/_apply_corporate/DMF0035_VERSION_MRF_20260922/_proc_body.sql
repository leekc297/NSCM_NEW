
-- [E20260922-VERMRF] Version 팝업(SALES) Monthly Rolling Forecast 저장 — AS-IS DMF0073_SAVE_VERSION_SALESPRICE 1:1 + 서버 검증 보강
PROCEDURE P_DMF0035_SAVE_VERSION_MRF
(
    P_DIVISION_ID           IN VARCHAR2,   -- 팝업 Division (콤마 복수 허용 — 조회 SP 와 동일 규약)
    P_VERSION_NO            IN VARCHAR2,   -- 변경 행 CODE(순수 버전번호) '^' 연결
    P_MONTHLY_ROLLING_FCST  IN VARCHAR2,   -- 변경 값(Y/N) '^' 연결 — P_VERSION_NO 와 같은 순서
    P_USER_ID               IN VARCHAR2,   -- 저장 사용자 (BE 세션값)
    O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************/
/* Program ID  : P_DMF0035_SAVE_VERSION_MRF                                                          */
/* Description : Sales Plan Waterfall Version 팝업 — MONTHLY_ROLLING_FCST(DM_MST_VERSION.ATTRIBUTE7) 저장 */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2024/05/13  KJJ          AS-IS DMF0073_SAVE_VERSION_SALESPRICE 신규 (DMF0073_VersionBySalesPricePopup) */
/* 2026/09/22  NextSCM      [E20260922-VERMRF] DMF0035 통합 Waterfall 로 이식.                        */
/*                          AS-IS 동작(ATTRIBUTE7/LAST_UPDATED_BY/LAST_UPDATE_DATE UPDATE)은 그대로,     */
/*                          AS-IS 에 없던 서버 검증 4종 추가 — 값 Y/N · Sales Plan(SP_) 버전 ·            */
/*                          당주(ISO 주차+연도) 버전 ·                                                   */
/*                          사업부 편집권한(PR_SCM_EDIT_YN). 화면 게이트와 같은 조건이라 정상 경로에선 통과. */
/*                          AS-IS 는 DIVISION_ID = 단일값 비교라 복수 Division 선택 시 0건 갱신 → 분할 IN. */
/****************************************************************************************************/
IS
    V_MENU_ID       VARCHAR2(50 CHAR) := 'DMF0035';
    V_CUR_YYYYWW    VARCHAR2(10 CHAR);
    N_VER_CNT       PLS_INTEGER := 0;
    N_VAL_CNT       PLS_INTEGER := 0;
    N_UPD_CNT       PLS_INTEGER := 0;
    V_INVALID       VARCHAR2(4000 CHAR);

    /* ── EXCEPTION 블록 필수 변수 ── */
    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100 CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100 CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER := 0;
    D_EVENT_DATE    DATE := SYSDATE;

BEGIN

    /* ── 시작 로그 ── */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    /* ── 1. 입력 건수 정합 ── */
    IF TRIM(P_VERSION_NO) IS NULL THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, '저장할 데이터가 없습니다.' AS MSG, CAST(NULL AS VARCHAR2(4000 CHAR)) AS EVENT FROM DUAL;
        RETURN;
    END IF;

    N_VER_CNT := REGEXP_COUNT(P_VERSION_NO || '^', '\^');
    N_VAL_CNT := REGEXP_COUNT(NVL(P_MONTHLY_ROLLING_FCST, '') || '^', '\^');
    IF N_VER_CNT <> N_VAL_CNT THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'Version / Monthly Rolling Forecast 건수가 일치하지 않습니다.' AS MSG
                 , N_VER_CNT || ' / ' || N_VAL_CNT AS EVENT FROM DUAL;
        RETURN;
    END IF;

    /* ── 2. 값 검증 — Y/N 만 (AS-IS MSG00002 필수 입력 + 콤보 Y/N) ── */
    SELECT LISTAGG(VER, ', ') WITHIN GROUP (ORDER BY N)
      INTO V_INVALID
      FROM (SELECT LEVEL AS N
                 , TRIM(REGEXP_SUBSTR(P_VERSION_NO || '^', '(.*?)\^', 1, LEVEL, NULL, 1)) AS VER
                 , TRIM(REGEXP_SUBSTR(P_MONTHLY_ROLLING_FCST || '^', '(.*?)\^', 1, LEVEL, NULL, 1)) AS VAL
              FROM DUAL
           CONNECT BY LEVEL <= N_VER_CNT)
     WHERE NVL(VAL, '-') NOT IN ('Y', 'N');

    IF V_INVALID IS NOT NULL THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, 'Monthly Rolling Forecast 값은 Y 또는 N 이어야 합니다.' AS MSG, V_INVALID AS EVENT FROM DUAL;
        RETURN;
    END IF;

    /* ── 3. 당주 버전 + 사업부 편집권한 검증 (조회 SP 의 EDITABLE / EDIT_YN 과 같은 조건 — 연도 포함) ── */
    SELECT MAX(ISO_YYYYWW)
      INTO V_CUR_YYYYWW
      FROM SCM_MGR.SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');

    SELECT LISTAGG(T.VER, ', ') WITHIN GROUP (ORDER BY T.N)
      INTO V_INVALID
      FROM (SELECT LEVEL AS N
                 , TRIM(REGEXP_SUBSTR(P_VERSION_NO || '^', '(.*?)\^', 1, LEVEL, NULL, 1)) AS VER
              FROM DUAL
           CONNECT BY LEVEL <= N_VER_CNT) T
     WHERE NOT EXISTS (SELECT 1
                         FROM SCM_MGR.DM_MST_VERSION A
                        INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B
                           ON B.BASIS_YYYYMMDD = A.YYYYMMDD
                        INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, V_MENU_ID)) TEI
                           ON TEI.UNIT_ID = A.DIVISION_ID
                          AND TEI.EDIT_YN = 'Y'
                        WHERE A.VERSION_NO  = T.VER
                          AND A.VERSION_TYPE LIKE 'SP\_%' ESCAPE '\'   -- Sales Plan 버전만 (MKT/BIZ 저장 불가 — 사용자 확정 2026-09-22)
                          AND A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(P_DIVISION_ID, ',')))
                          AND B.ISO_YYYYWW  = V_CUR_YYYYWW);

    IF V_INVALID IS NOT NULL THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, '당주 Sales Plan 버전이면서 편집 권한이 있는 사업부의 버전만 수정할 수 있습니다.' AS MSG, V_INVALID AS EVENT FROM DUAL;
        RETURN;
    END IF;

    /* ── 4. 저장 — AS-IS UPDATE 1:1 (ATTRIBUTE7 / LAST_UPDATED_BY / LAST_UPDATE_DATE) ── */
    UPDATE SCM_MGR.DM_MST_VERSION M_VER
       SET M_VER.ATTRIBUTE7       = (SELECT T.VAL
                                       FROM (SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO || '^', '(.*?)\^', 1, LEVEL, NULL, 1)) AS VER
                                                  , TRIM(REGEXP_SUBSTR(P_MONTHLY_ROLLING_FCST || '^', '(.*?)\^', 1, LEVEL, NULL, 1)) AS VAL
                                               FROM DUAL
                                            CONNECT BY LEVEL <= N_VER_CNT) T
                                      WHERE T.VER = M_VER.VERSION_NO
                                      FETCH FIRST 1 ROWS ONLY)
         , M_VER.LAST_UPDATED_BY  = P_USER_ID
         , M_VER.LAST_UPDATE_DATE = SYSDATE
     WHERE M_VER.DIVISION_ID IN (SELECT TOKEN FROM TABLE(SCM_MGR.FN_STRING_SPLIT(P_DIVISION_ID, ',')))
       AND M_VER.VERSION_TYPE LIKE 'SP\_%' ESCAPE '\'
       AND M_VER.VERSION_NO  IN (SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO || '^', '(.*?)\^', 1, LEVEL, NULL, 1))
                                   FROM DUAL
                                CONNECT BY LEVEL <= N_VER_CNT)
       AND EXISTS (SELECT 1
                     FROM TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, V_MENU_ID)) TEI
                    WHERE TEI.UNIT_ID = M_VER.DIVISION_ID
                      AND TEI.EDIT_YN = 'Y');

    N_UPD_CNT := SQL%ROWCOUNT;
    N_LOG_COUNT := N_UPD_CNT;

    COMMIT;

    /* ── 종료 로그 ── */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := 'UPDATED=' || N_UPD_CNT;
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'success' AS MSG, TO_CHAR(N_UPD_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        -- 1) 트랜잭션이 있으면 ROLLBACK
        ROLLBACK;

        -- 2) 에러 정보 캡처
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := SUBSTR(JSON_OBJECT(
            'P_DIVISION_ID'          VALUE P_DIVISION_ID,
            'P_VERSION_NO'           VALUE P_VERSION_NO,
            'P_MONTHLY_ROLLING_FCST' VALUE P_MONTHLY_ROLLING_FCST,
            'P_USER_ID'              VALUE P_USER_ID
        ), 1, 4000);
        V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- 3) 에러 로그 기록
        BEGIN
            SCM_MGR.PR_SCM_SYS_LOG_BATCH(
                $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE,
                V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT,
                V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
            );
        END;

        -- 4) 화면이 원인을 볼 수 있게 결과 커서로 반환 (CODE '9' / EVENT = SQLERRM)
        OPEN O_RESULT_CURSOR FOR
            SELECT '9' AS CODE, 'fail' AS MSG, SUBSTR(V_SQL_ERRMSG, 1, 4000) AS EVENT FROM DUAL;
END P_DMF0035_SAVE_VERSION_MRF;
