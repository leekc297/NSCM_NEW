-- [E20261020-USERIDLIST] SCP0096 · SCP0019 저장 ORA-01407(LAST_UPDATED_BY NULL) 보완 — 2026-10-20
--   원인: FE(ShipmentWorkingDayOsp.tsx · WorkingTime.tsx)는 사용자 파라미터를 'userIdList'('^' 다건) 로 보내는데 사내 SCM_ADM_PROC_M 에는 'userId' 로 등록(ZIONEX 9/23~24)
--         → BE 가 이름으로 바인딩하지 못해 P_USER_ID = NULL → UPDATE … LAST_UPDATED_BY = NULL → ORA-01407. (E2E crud 실측 2026-10-20)
--   보완(DB 객체만): ① PROC_M COL_NM userId → userIdList(두 SAVE 프로시저)  ② 패키지 본문에서 P_USER_ID 의 첫 '^' 토큰을 V_USER_ID 로 채택(단일값이면 그대로)
--   멱등: UPDATE 는 COL_NM='userId' 행만 · 패키지는 CREATE OR REPLACE(사내 live 원문 2026-10-20 기준 + 마커 줄만 추가)
UPDATE SCM_MGR.SCM_ADM_PROC_M SET COL_NM = 'userIdList', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP' AND COL_NM = 'userId' AND COL_TP_CD = 'IN';
UPDATE SCM_MGR.SCM_ADM_PROC_M SET COL_NM = 'userIdList', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM = 'PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW' AND COL_NM = 'userId' AND COL_TP_CD = 'IN';

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0096
AS
    /*
     * Program ID   : PKG_SCP0096
     * Description  : 출하일 관리 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.24   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.19   harness      [TobeGen] P_DM0003_GET_BUCKET_TYPE_CODE · P_SCP0009_GET_SHEET_CALENDAR_3SPAN 추가 (기존 본문 무변경)
     */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    V_DELIMITER  CONSTANT VARCHAR2(1 CHAR) := '^';


    /*==================================================================================================*
     * 내부 : 구분자로 묶여 온 값을 토막낸다
     *        AS-IS SCM_ARR_SPL_VAL(토큰 앞뒤 공백 제거) 과 같은 결과
     *==================================================================================================*/
    PROCEDURE P_SPLIT
    (
        P_TEXT   IN  CLOB,
        P_DELIM  IN  VARCHAR2,
        O_TAB    OUT T_TOKEN_TAB,
        O_CNT    OUT PLS_INTEGER
    )
    IS
        V_LEN   PLS_INTEGER;
        V_POS   PLS_INTEGER := 1;
        V_NEXT  PLS_INTEGER;
    BEGIN
        O_CNT := 0;

        IF P_TEXT IS NULL OR DBMS_LOB.GETLENGTH(P_TEXT) = 0 THEN
            O_CNT    := 1;
            O_TAB(1) := NULL;
            RETURN;
        END IF;

        V_LEN := DBMS_LOB.GETLENGTH(P_TEXT);

        LOOP
            V_NEXT := DBMS_LOB.INSTR(P_TEXT, P_DELIM, V_POS, 1);
            O_CNT  := O_CNT + 1;

            IF V_NEXT = 0 THEN
                IF V_POS <= V_LEN THEN
                    O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_LEN - V_POS + 1, V_POS));
                ELSE
                    O_TAB(O_CNT) := NULL;
                END IF;
                EXIT;
            END IF;

            IF V_NEXT > V_POS THEN
                O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_NEXT - V_POS, V_POS));
            ELSE
                O_TAB(O_CNT) := NULL;
            END IF;

            V_POS := V_NEXT + 1;
        END LOOP;
    END P_SPLIT;


    /* 내부 : 토막 꺼내기 (범위 밖이면 NULL) */
    FUNCTION F_TK
    (
        P_TAB  IN  T_TOKEN_TAB,
        P_IDX  IN  PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX) THEN
            RETURN P_TAB(P_IDX);
        END IF;
        RETURN NULL;
    END F_TK;


    /* 내부 : AS-IS nvarchar -> numeric 암시 변환
     *        AS-IS 는 빈 값 · 공백을 0 으로 바꾸어 넣는다. 숫자로 읽을 수 없는 값은 변환 오류. */
    FUNCTION F_TO_NUM
    (
        P_VALUE  IN  VARCHAR2
    )
    RETURN NUMBER
    IS
        V_TXT  VARCHAR2(4000 CHAR) := TRIM(P_VALUE);
    BEGIN
        IF V_TXT IS NULL THEN
            RETURN 0;
        END IF;

        IF NOT REGEXP_LIKE(V_TXT, '^[+-]?([0-9]+)(\.[0-9]*)?$') THEN
            RAISE_APPLICATION_ERROR(-20245, 'Conversion failed when converting the nvarchar value '''
                                            || SUBSTR(P_VALUE, 1, 200) || ''' to data type numeric.');
        END IF;

        RETURN TO_NUMBER(V_TXT);
    END F_TO_NUM;


/*
 * Program ID   : P_DM0003_GET_BUCKET_TYPE_CODE
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is DM0003_GET_BUCKET_TYPE_CODE 이식 (GET, 시트 'Shipment Working Day OSP' / 화면 Load)
 *                As-is 원문: [dbo].[DM0003_GET_BUCKET_TYPE_CODE] 2017/10/24 SongDH Initial Release [PJ20170278]
 *                (As-is 선언만 하고 쓰지 않는 @p_end_week 는 옮기지 않는다 · WITH(NOLOCK) 제거)
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.19   harness        [TobeGen] As-is DM0003_GET_BUCKET_TYPE_CODE 이식 (결과셋 CODE, NAME)
 */
PROCEDURE P_DM0003_GET_BUCKET_TYPE_CODE (
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    OPEN O_RC1 FOR
        SELECT L.SEGMENT1  AS CODE
             , L.SEGMENT2  AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
         WHERE L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'
           AND L.VALID_YN    = 'Y'
         ORDER BY L.DISPLAY_SEQ;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_DM0003_GET_BUCKET_TYPE_CODE] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || '-');
END P_DM0003_GET_BUCKET_TYPE_CODE;


    /*==================================================================================================*
     * 출하일 관리 조회 (AS-IS SCP0096_GET_SHIPMENT_WORKING_DAY_OSP)
     *
     * 갈래 둘 모두 사이트 단위다(라인 칸이 없다).
     *   갈래 1 : 라인을 등록하지 않은 외주사  (SCM_MST_SITE.ATTRIBUTE1 <> 'Y')
     *   갈래 2 : 라인을 등록한 외주사        (SCM_MST_SITE.ATTRIBUTE1  = 'Y' + SCM_MST_LINE_OSP)
     *
     * AS-IS 는 대문자와 소문자를 가리지 않고 견주므로 조회조건 입력값을 대문자로 맞춘다.
     * 조회조건 목록에서 'ALL' 을 고르면 그 조건을 걸지 않는다(대문자 · 소문자 가리지 않음).
     *==================================================================================================*/
    PROCEDURE P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_PLANT_SITE_ID   IN  VARCHAR2,
        P_FROM_YYYYMMDD   IN  VARCHAR2,
        P_TO_YYYYMMDD     IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_COL_SQL   CLOB := EMPTY_CLOB();
        V_SQL       CLOB := EMPTY_CLOB();
        V_ERR_CODE  NUMBER;
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN
        /* 임시 적재분 비우기 — 같은 접속에서 다시 조회할 때 앞 결과가 남지 않게 한다 */
        DELETE
          FROM GT_SCP0096_PIVOT;

        INSERT INTO GT_SCP0096_PIVOT
             ( DIVISION_ID
             , PLANT_SITE_ID
             , WORKING_TIME_DEFAULT
             , LAST_INPUT_DATE
             , MEASURE
             , YYYYMMDD
             , YYYYMM
             , ISO_WEEK
             , SHIPMENT_YN
             )
        SELECT IA.DIVISION_ID
             , IA.PLANT_SITE_ID
             , C.WORKING_TIME_DEFAULT                        AS WORKING_TIME_DEFAULT
             , (SELECT MAX(SA.YYYYMMDD)
                  FROM SCP_MST_SHIPMENT_WORKING_DAY_OSP SA
                 WHERE SA.DIVISION_ID   = IA.DIVISION_ID
                   AND SA.PLANT_SITE_ID = IA.PLANT_SITE_ID
                   AND SA.SHIPMENT_YN  IS NOT NULL)          AS LAST_INPUT_DATE
             , IA.MEASURE
             , 'D_' || IA.YYYYMMDD                           AS YYYYMMDD
             , IA.YYYYMM                                     AS YYYYMM
             , IA.ISO_WEEK
             , B.SHIPMENT_YN                                 AS SHIPMENT_YN
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.SCM_SITE_ID                         AS PLANT_SITE_ID
                     , 'SHIPMENT WORKING DAY'                AS MEASURE
                     , B.BASIS_YYYYMMDD                      AS YYYYMMDD
                     , B.BASIS_YYYYMM                        AS YYYYMM
                     , SUBSTR(B.BASIS_YYYYMM, -2) || B.ISO_WEEK  AS ISO_WEEK
                     , 'VENDOR'                              AS OPERATION
                     , A.OSP_YN
                  FROM SCM_MST_SITE A
                     , SCM_SYS_CALENDAR_M B
                 WHERE B.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND B.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.SITE_TYPE       = 'PLANT'
                   AND A.VALID_YN        = 'Y'
                   AND A.OSP_YN          = 'Y'
                   AND NVL(A.ATTRIBUTE1, 'N') <> 'Y'         /* LINE 등록 외주사 제외 */
                   AND ( UPPER(P_DIVISION_ID) = 'ALL'
                         OR A.DIVISION_ID = UPPER(P_DIVISION_ID) )
                   AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                         OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                         OR A.SCM_SITE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL)
                                                FROM DUAL
                                             CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                 UNION
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID                         AS PLANT_SITE_ID
                     , 'SHIPMENT WORKING DAY'                AS MEASURE
                     , C.BASIS_YYYYMMDD                      AS YYYYMMDD
                     , C.BASIS_YYYYMM                        AS YYYYMM
                     , SUBSTR(C.BASIS_YYYYMM, -2) || C.ISO_WEEK  AS ISO_WEEK
                     , B.OPERATION_ID                        AS OPERATION
                     , A.OSP_YN
                  FROM SCM_MST_SITE A
                     , SCM_MST_LINE_OSP B
                     , SCM_SYS_CALENDAR_M C
                 WHERE B.DIVISION_ID     = A.DIVISION_ID
                   AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                   AND C.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND C.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.SITE_TYPE       = 'PLANT'
                   AND A.VALID_YN        = 'Y'
                   AND A.OSP_YN          = 'Y'
                   AND NVL(A.ATTRIBUTE1, 'N') = 'Y'
                   AND ( UPPER(P_DIVISION_ID) = 'ALL'
                         OR A.DIVISION_ID = UPPER(P_DIVISION_ID) )
                   AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                         OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                         OR A.SCM_SITE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL)
                                                FROM DUAL
                                             CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
               ) IA
             , SCP_MST_SHIPMENT_WORKING_DAY_OSP B
             , SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT C
         WHERE B.DIVISION_ID(+)   = IA.DIVISION_ID
           AND B.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
           AND B.YYYYMMDD(+)      = IA.YYYYMMDD
           AND C.DIVISION_ID(+)   = IA.DIVISION_ID
           AND C.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID;

        /*==============================================================================================*
         * 칸 펼치기
         * 기간 안의 일자마다 칸이 하나씩 생기므로 칸 구성을 실행 시점에 만든다.
         * (AS-IS 도 같은 이유로 조회문을 실행 시점에 조립한다)
         *==============================================================================================*/
        FOR C1 IN (SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                     FROM SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                    GROUP BY A.BASIS_YYYYMMDD
                    ORDER BY A.BASIS_YYYYMMDD)
        LOOP
            V_COL_SQL := V_COL_SQL || '     , MAX(CASE WHEN YYYYMMDD = ''' || C1.YYYYMMDD
                                   || ''' THEN SHIPMENT_YN END) AS ' || C1.YYYYMMDD || CHR(10);
        END LOOP;

        V_SQL := 'SELECT IA.*' || CHR(10)
              || '  FROM (' || CHR(10)
              || 'SELECT DIVISION_ID' || CHR(10)
              || '     , PLANT_SITE_ID' || CHR(10)
              || '     , (SELECT MAX(SA.SITE_DESCRIPTION) FROM SCM_MST_SITE SA'
              || ' WHERE SA.SCM_SITE_ID = A.PLANT_SITE_ID) AS PLANT_SITE_NAME' || CHR(10)
              || '     , WORKING_TIME_DEFAULT' || CHR(10)
              || '     , LAST_INPUT_DATE' || CHR(10)
              || '     , MEASURE' || CHR(10)
              || V_COL_SQL
              || '  FROM GT_SCP0096_PIVOT A' || CHR(10)
              || ' GROUP BY DIVISION_ID' || CHR(10)
              || '        , PLANT_SITE_ID' || CHR(10)
              || '        , WORKING_TIME_DEFAULT' || CHR(10)
              || '        , LAST_INPUT_DATE' || CHR(10)
              || '        , MEASURE' || CHR(10)
              || '       ) IA' || CHR(10)
              /* 정렬 : AS-IS(MSSQL)와 줄 세우는 방식을 맞춘다.
               *        1) 오름차순에서 빈 값이 앞 (Oracle 기본은 뒤)
               *        2) 대문자와 소문자를 가리지 않는다
               *        3) 하이픈 · 밑줄 같은 기호를 빼고(띄어쓰기는 남긴다) 먼저 견준 뒤,
               *           같으면 원래 값으로 다시 견준다 */
              || ' ORDER BY IA.LAST_INPUT_DATE NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.DIVISION_ID, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.DIVISION_ID, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.PLANT_SITE_ID, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.PLANT_SITE_ID, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.MEASURE, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10);

        OPEN O_RC1 FOR V_SQL;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'        AS CODE
             , 'SUCCESS'  AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := SQLCODE;
            V_ERR_MSG  := SQLERRM;

            OPEN O_RESULT_CURSOR FOR
            SELECT TO_CHAR(V_ERR_CODE)  AS CODE
                 , V_ERR_MSG            AS MSG
              FROM DUAL;
    END P_SCP0096_GET_SHIPMENT_WORKING_DAY_OSP;


    /*==================================================================================================*
     * 출하일 관리 저장 (AS-IS SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP)
     *
     *   P_IS_SAVE_DEFAULT = 'N' : SCP_MST_SHIPMENT_WORKING_DAY_OSP
     *   P_IS_SAVE_DEFAULT = 'Y' : SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT
     *   AS-IS 에 지우는 갈래와 이력 기록은 없다.
     *==================================================================================================*/
    PROCEDURE P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP
    (
        P_DIVISION_ID            IN  CLOB,
        P_PLANT_SITE_ID          IN  CLOB,
        P_YYYYMMDD               IN  CLOB,
        P_MEASURE                IN  CLOB,
        P_SHIPMENT_YN            IN  CLOB,
        P_WORKING_TIME_DEFAULT   IN  CLOB,
        P_IS_SAVE_DEFAULT        IN  CLOB,
        P_USER_ID                IN  VARCHAR2,
        O_RESULT_CURSOR          OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP';

        T_DIVISION_ID          T_TOKEN_TAB;
        T_PLANT_SITE_ID        T_TOKEN_TAB;
        T_YYYYMMDD             T_TOKEN_TAB;
        T_MEASURE              T_TOKEN_TAB;
        T_SHIPMENT_YN          T_TOKEN_TAB;
        T_WORKING_TIME_DEFAULT T_TOKEN_TAB;
        T_IS_SAVE_DEFAULT      T_TOKEN_TAB;

        V_MAX_LOOP_CNT  PLS_INTEGER := 0;
        V_CNT           PLS_INTEGER;

        V_DIVISION_ID          VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID        VARCHAR2(4000 CHAR);
        V_YYYYMMDD             VARCHAR2(4000 CHAR);
        V_MEASURE              VARCHAR2(4000 CHAR);
        V_SHIPMENT_YN          VARCHAR2(4000 CHAR);
        V_WORKING_TIME_DEFAULT VARCHAR2(4000 CHAR);
        V_IS_SAVE_DEFAULT      VARCHAR2(4000 CHAR);

        V_WTD_NUM       NUMBER;
        V_ROW_CNT       PLS_INTEGER := 0;
        V_ERR_CODE      NUMBER;
        V_ERR_MESSAGE   VARCHAR2(4000 CHAR);
        V_USER_ID       VARCHAR2(100 CHAR);  -- [E20261020-USERIDLIST] FE 는 '^' 다건 배열(userIdList)로 보내므로 첫 토큰을 사용자로 채택
    BEGIN
        SAVEPOINT SP_SCP0096_SAVE;
        V_USER_ID := NVL(REGEXP_SUBSTR(P_USER_ID, '[^^]+', 1, 1), P_USER_ID);  -- [E20261020-USERIDLIST] 'u^u^u' → 'u' (단일값이면 그대로)

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0,
                             '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT(P_DIVISION_ID,          V_DELIMITER, T_DIVISION_ID,          V_CNT);
        V_MAX_LOOP_CNT := GREATEST(V_MAX_LOOP_CNT, V_CNT);
        P_SPLIT(P_PLANT_SITE_ID,        V_DELIMITER, T_PLANT_SITE_ID,        V_CNT);
        P_SPLIT(P_YYYYMMDD,             V_DELIMITER, T_YYYYMMDD,             V_CNT);
        P_SPLIT(P_MEASURE,              V_DELIMITER, T_MEASURE,              V_CNT);
        P_SPLIT(P_SHIPMENT_YN,          V_DELIMITER, T_SHIPMENT_YN,          V_CNT);
        P_SPLIT(P_WORKING_TIME_DEFAULT, V_DELIMITER, T_WORKING_TIME_DEFAULT, V_CNT);
        P_SPLIT(P_IS_SAVE_DEFAULT,      V_DELIMITER, T_IS_SAVE_DEFAULT,      V_CNT);

        FOR I IN 1 .. V_MAX_LOOP_CNT
        LOOP
            V_DIVISION_ID := F_TK(T_DIVISION_ID, I);

            IF TRIM(V_DIVISION_ID) IS NULL THEN
                CONTINUE;
            END IF;

            V_PLANT_SITE_ID        := F_TK(T_PLANT_SITE_ID,        I);
            V_YYYYMMDD             := F_TK(T_YYYYMMDD,             I);
            V_MEASURE              := F_TK(T_MEASURE,              I);
            V_SHIPMENT_YN          := F_TK(T_SHIPMENT_YN,          I);
            V_WORKING_TIME_DEFAULT := F_TK(T_WORKING_TIME_DEFAULT, I);
            V_IS_SAVE_DEFAULT      := F_TK(T_IS_SAVE_DEFAULT,      I);

            V_WTD_NUM := F_TO_NUM(V_WORKING_TIME_DEFAULT);

            /* 출하일 저장 */
            IF NVL(V_IS_SAVE_DEFAULT, 'N') = 'N' THEN

                UPDATE SCP_MST_SHIPMENT_WORKING_DAY_OSP
                   SET SHIPMENT_YN      = V_SHIPMENT_YN
                     , LAST_UPDATED_BY  = V_USER_ID
                     , LAST_UPDATE_DATE = SYSDATE
                 WHERE DIVISION_ID   = V_DIVISION_ID
                   AND PLANT_SITE_ID = V_PLANT_SITE_ID
                   AND YYYYMMDD      = V_YYYYMMDD
                   AND MEASURE       = V_MEASURE;

                IF SQL%ROWCOUNT = 0 THEN
                    INSERT INTO SCP_MST_SHIPMENT_WORKING_DAY_OSP
                         ( DIVISION_ID
                         , PLANT_SITE_ID
                         , YYYYMMDD
                         , MEASURE
                         , SHIPMENT_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         )
                    VALUES
                         ( V_DIVISION_ID
                         , V_PLANT_SITE_ID
                         , V_YYYYMMDD
                         , V_MEASURE
                         , V_SHIPMENT_YN
                         , V_USER_ID
                         , SYSDATE
                         , V_USER_ID
                         , SYSDATE
                         );
                END IF;

            /* 기본값 저장 */
            ELSE

                UPDATE SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT
                   SET WORKING_TIME_DEFAULT = V_WTD_NUM
                     , LAST_UPDATED_BY      = V_USER_ID
                     , LAST_UPDATE_DATE     = SYSDATE
                 WHERE DIVISION_ID   = V_DIVISION_ID
                   AND PLANT_SITE_ID = V_PLANT_SITE_ID;

                IF SQL%ROWCOUNT = 0 THEN
                    INSERT INTO SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT
                         ( DIVISION_ID
                         , PLANT_SITE_ID
                         , WORKING_TIME_DEFAULT
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         )
                    VALUES
                         ( V_DIVISION_ID
                         , V_PLANT_SITE_ID
                         , V_WTD_NUM
                         , V_USER_ID
                         , SYSDATE
                         , V_USER_ID
                         , SYSDATE
                         );
                END IF;

            END IF;

            V_ROW_CNT := V_ROW_CNT + 1;

        END LOOP;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', V_ROW_CNT,
                             '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT 'S'        AS RESULT_CODE
             , V_ROW_CNT  AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SCP0096_SAVE;

            INSERT INTO SCM_SYS_LOG_BATCH
                 ( PROGRAM_NAME
                 , LOG_TYPE
                 , LOG_COUNT
                 , LOG_MESSAGE
                 , DESCRIPTION
                 , EVENT_DATE
                 , CREATION_DATE
                 , CREATED_BY
                 , LAST_UPDATE_DATE
                 , LAST_UPDATED_BY
                 )
            VALUES
                 ( V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , V_ERR_MESSAGE
                 , NULL
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME
                 );

            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
            SELECT 'F'            AS RESULT_CODE
                 , V_ERR_CODE     AS ERR_CODE
                 , V_ERR_MESSAGE  AS ERR_MESSAGE
              FROM DUAL;
    END P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP;


/*
 * Program ID   : P_SCP0009_GET_SHEET_CALENDAR_3SPAN
 * Description  : SCP0096 Shipment_Working_Day_OSP — As-is SCP0009_GET_SHEET_CALENDAR_3SPAN 이식 (GET, 시트 'Shipment Working Day OSP' / 화면 Load·조회·저장 후 머리글)
 *                As-is 원문: [dbo].[SCP0009_GET_SHEET_CALENDAR_3SPAN] 2018/11/20 KYH Initial Release — SCP 칼렌더 생성위한 프로시저
 *                변환: 'D_'+x → 'D_'||x · x + CONVERT(CHAR(2),31) → x||'31' · WITH(NOLOCK) 제거 · '' AS DAY_CODE → NULL(Oracle 빈문자=NULL, 표시 위치 — 부록 C-7)
 *                결과셋 6컬럼 As-is 동일: COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME, DAY_CODE, SORT_ORDER_NO
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.10.19   harness        [TobeGen] As-is SCP0009_GET_SHEET_CALENDAR_3SPAN 이식 (일 D_ / 주 W_ / 월 M_ 3단)
 */
PROCEDURE P_SCP0009_GET_SHEET_CALENDAR_3SPAN (
        P_START_YYYYMMDD IN  VARCHAR2,  -- As-is @p_start_yyyymmdd nvarchar(16)
        P_END_YYYYMMDD   IN  VARCHAR2,  -- As-is @p_end_yyyymmdd nvarchar(16)
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
) IS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_SQL_CODE      VARCHAR2(100 CHAR);
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS BEGIN V_ERR_MSG := P_MSG; RAISE EX_BIZ_EX; END;
BEGIN
    /* As-is 는 파라미터 필수 검사가 없다(NULL 이면 0건) — 골격의 필수값 검사는 두지 않는다 */
    OPEN O_RC1 FOR
        SELECT 'D_' || A.BASIS_YYYYMMDD     AS COLUMN_NAME
             , A.CALENDAR_DAY               AS COLUMN_LABEL_NAME
             , A.WEEK_NAME                  AS SMALL_CLASS_LABEL_NAME
             , A.MONTH_NAME                 AS LARGE_CLASS_LABEL_NAME
             , A.DAYOFWEEK                  AS DAY_CODE
             , A.BASIS_YYYYMMDD || '31'     AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
        UNION ALL
        SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK  AS COLUMN_NAME
             , A.WEEK_NAME                  AS COLUMN_LABEL_NAME
             , A.WEEK_NAME                  AS SMALL_CLASS_LABEL_NAME
             , A.MONTH_NAME                 AS LARGE_CLASS_LABEL_NAME
             , NULL                         AS DAY_CODE
             , A.BASIS_START_DATE || '21'   AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
         GROUP BY A.BASIS_YYYYMM
                , A.ISO_WEEK
                , A.WEEK_NAME
                , A.MONTH_NAME
                , A.BASIS_START_DATE
        UNION ALL
        SELECT 'M_' || A.BASIS_YYYYMM       AS COLUMN_NAME
             , A.MONTH_NAME                 AS COLUMN_LABEL_NAME
             , A.MONTH_NAME                 AS SMALL_CLASS_LABEL_NAME
             , A.MONTH_NAME                 AS LARGE_CLASS_LABEL_NAME
             , NULL                         AS DAY_CODE
             , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M A
         WHERE A.BASIS_YYYYMMDD >= P_START_YYYYMMDD
           AND A.BASIS_YYYYMMDD <= P_END_YYYYMMDD
         GROUP BY A.BASIS_YYYYMM
                , A.MONTH_NAME
         ORDER BY SORT_ORDER_NO;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR SELECT '1' AS CODE, V_ERR_MSG AS MSG, '' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE); V_ERR_MSG := SQLERRM;
        RAISE_APPLICATION_ERROR(-20001, '[' || $$PLSQL_UNIT || '.P_SCP0009_GET_SHEET_CALENDAR_3SPAN] SQLCODE=' || V_SQL_CODE || ' / SQLERRM=' || V_ERR_MSG || ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || 'P_START_YYYYMMDD='||P_START_YYYYMMDD||','||'P_END_YYYYMMDD='||P_END_YYYYMMDD);
END P_SCP0009_GET_SHEET_CALENDAR_3SPAN;

END PKG_SCP0096;
/

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCP0019 IS

    /*
     * Program ID   : PKG_SCP0019
     * Description  : Working Time 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS          P_SCP0019_GET_WORKING_TIME 조회 속도 개선(최종 입력일 하위질의를 키 단위 인덱스 조회로 고정)
     */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    V_DELIMITER  CONSTANT VARCHAR2(1 CHAR) := '^';


    /*==================================================================================================*
     * 내부 : 구분자로 묶여 온 값을 토막낸다
     *        AS-IS SCM_ARR_SPL_VAL(토큰 앞뒤 공백 제거) 과 같은 결과
     *==================================================================================================*/
    PROCEDURE P_SPLIT
    (
        P_TEXT   IN  CLOB,
        P_DELIM  IN  VARCHAR2,
        O_TAB    OUT T_TOKEN_TAB,
        O_CNT    OUT PLS_INTEGER
    )
    IS
        V_LEN   PLS_INTEGER;
        V_POS   PLS_INTEGER := 1;
        V_NEXT  PLS_INTEGER;
    BEGIN
        O_CNT := 0;

        IF P_TEXT IS NULL OR DBMS_LOB.GETLENGTH(P_TEXT) = 0 THEN
            O_CNT    := 1;
            O_TAB(1) := NULL;
            RETURN;
        END IF;

        V_LEN := DBMS_LOB.GETLENGTH(P_TEXT);

        LOOP
            V_NEXT := DBMS_LOB.INSTR(P_TEXT, P_DELIM, V_POS, 1);
            O_CNT  := O_CNT + 1;

            IF V_NEXT = 0 THEN
                IF V_POS <= V_LEN THEN
                    O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_LEN - V_POS + 1, V_POS));
                ELSE
                    O_TAB(O_CNT) := NULL;
                END IF;
                EXIT;
            END IF;

            IF V_NEXT > V_POS THEN
                O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_NEXT - V_POS, V_POS));
            ELSE
                O_TAB(O_CNT) := NULL;
            END IF;

            V_POS := V_NEXT + 1;
        END LOOP;
    END P_SPLIT;


    /* 내부 : 토막 꺼내기 (범위 밖이면 NULL) */
    FUNCTION F_TK
    (
        P_TAB  IN  T_TOKEN_TAB,
        P_IDX  IN  PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX) THEN
            RETURN P_TAB(P_IDX);
        END IF;
        RETURN NULL;
    END F_TK;


    /* 내부 : AS-IS nvarchar -> numeric 암시 변환
     *        AS-IS 는 빈 값 · 공백을 0 으로 바꾸어 넣는다(문자를 숫자 칸에 넣을 때의 암시 변환).
     *        숫자로 읽을 수 없는 값은 변환 오류. */
    FUNCTION F_TO_NUM
    (
        P_VALUE  IN  VARCHAR2
    )
    RETURN NUMBER
    IS
        V_TXT  VARCHAR2(4000 CHAR) := TRIM(P_VALUE);
    BEGIN
        IF V_TXT IS NULL THEN
            RETURN 0;
        END IF;

        IF NOT REGEXP_LIKE(V_TXT, '^[+-]?([0-9]+)(\.[0-9]*)?$') THEN
            RAISE_APPLICATION_ERROR(-20245, 'Conversion failed when converting the nvarchar value '''
                                            || SUBSTR(P_VALUE, 1, 200) || ''' to data type numeric.');
        END IF;

        RETURN TO_NUMBER(V_TXT);
    END F_TO_NUM;


    /*==================================================================================================*
     * 내부 : Working Time 이력 기록 (AS-IS PR_SCP_MST_WORKING_TIME_HIST)
     *        AS-IS 에서 이 화면의 저장만 부르는 프로시저라 패키지 안으로 들인다.
     *==================================================================================================*/
    PROCEDURE P_WORKING_TIME_HIST
    (
        P_DIVISION_ID      IN  VARCHAR2,
        P_PLANT_SITE_ID    IN  VARCHAR2,
        P_FACTORY_ID       IN  VARCHAR2,
        P_OPERATION_ID     IN  VARCHAR2,
        P_LINE_ID          IN  VARCHAR2,
        P_YYYYMMDD         IN  VARCHAR2,
        P_WORKING_TIME     IN  VARCHAR2,
        P_CREATED_BY       IN  VARCHAR2,
        P_CREATION_DATE    IN  DATE,
        P_LAST_UPDATED_BY  IN  VARCHAR2
    )
    IS
        V_HISTORY_SEQ   NUMBER;
        V_WORKING_TIME  NUMBER := F_TO_NUM(P_WORKING_TIME);
    BEGIN
        SELECT SEQ1_SCP_MST_WORKING_TIME_H.NEXTVAL
          INTO V_HISTORY_SEQ
          FROM DUAL;

        INSERT INTO SCP_MST_WORKING_TIME_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        VALUES
             ( V_HISTORY_SEQ
             , P_DIVISION_ID
             , P_PLANT_SITE_ID
             , P_FACTORY_ID
             , P_OPERATION_ID
             , P_LINE_ID
             , P_YYYYMMDD
             , V_WORKING_TIME
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             );
    END P_WORKING_TIME_HIST;


    /*==================================================================================================*
     * Working Time 조회 (AS-IS SCP0019_GET_WORKING_TIME)
     *
     * AS-IS 2021.09.14 [PJ20209643] 로 「외주만 조회/수정 가능하도록 변경」되어
     * 자사 라인 갈래(SCM_MST_LINE_SN 기준)는 주석 처리되어 있다. 살아 있는 갈래는 둘이다.
     *   갈래 1 : 라인을 등록하지 않은 외주사        (SCM_MST_SITE.ATTRIBUTE1 <> 'Y')
     *   갈래 2 : 라인을 등록한 외주사              (SCM_MST_SITE.ATTRIBUTE1  = 'Y' + SCM_MST_LINE_OSP)
     *
     * AS-IS 는 대문자와 소문자를 가리지 않고 견주므로 조회조건 입력값을 대문자로 맞춘다.
     * 조회조건 목록에서 'ALL' 을 고르면 그 조건을 걸지 않는다(대문자 · 소문자 가리지 않음).
     * 원장 칸에는 소문자가 한 건도 없어(사이트 · 라인 · 공정 · 사업부 전건 실측) 칸 쪽은 그대로 둔다.
     *==================================================================================================*/
    PROCEDURE P_SCP0019_GET_WORKING_TIME
    (
        P_FROM_YYYYMMDD   IN  VARCHAR2,
        P_TO_YYYYMMDD     IN  VARCHAR2,
        P_DIVISION_ID     IN  VARCHAR2,
        P_PLANT_SITE_ID   IN  VARCHAR2,
        P_FACTORY_ID      IN  VARCHAR2,
        P_OPERATION_ID    IN  VARCHAR2,
        P_LINE_ID         IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_COL_SQL   CLOB := EMPTY_CLOB();
        V_SQL       CLOB := EMPTY_CLOB();
        V_ERR_CODE  NUMBER;
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN
        /* 임시 적재분 비우기 — 같은 접속에서 다시 조회할 때 앞 결과가 남지 않게 한다 */
        DELETE
          FROM GT_SCP0019_PIVOT;

        INSERT INTO GT_SCP0019_PIVOT
             ( DIVISION_ID
             , PLANT_SITE_ID
             , FACTORY_ID
             , FACTORY_NAME
             , OPERATION_ID
             , OPERATION_NAME
             , LINE_ID
             , LINE_NAME
             , WORKING_TIME_DEFAULT
             , LAST_INPUT_DATE
             , MEASURE
             , YYYYMMDD
             , YYYYMM
             , ISO_WEEK
             , QTY
             , OSP_YN
             )
        SELECT IA.DIVISION_ID
             , IA.PLANT_SITE_ID
             , IA.FACTORY_ID
             , IA.FACTORY_NAME
             , IA.OPERATION_ID
             , IA.OPERATION_NAME
             , IA.LINE_ID
             , IA.LINE_NAME
             , C.WORKING_TIME_DEFAULT
--             , (SELECT MAX(SA.YYYYMMDD)   --  2026.10.06 AJS
             , (SELECT /*+ NO_UNNEST INDEX(SA PK_SCP_MST_WORKING_TIME) */ MAX(SA.YYYYMMDD)   --  2026.10.06 AJS
                  FROM SCP_MST_WORKING_TIME SA
                 WHERE SA.DIVISION_ID   = IA.DIVISION_ID
                   AND SA.PLANT_SITE_ID = IA.PLANT_SITE_ID
                   AND SA.FACTORY_ID    = IA.FACTORY_ID
                   AND SA.OPERATION_ID  = IA.OPERATION_ID
                   AND SA.LINE_ID       = IA.LINE_ID
                   AND SA.WORKING_TIME IS NOT NULL)          AS LAST_INPUT_DATE
             , IA.MEASURE
             , 'D_' || IA.YYYYMMDD                           AS YYYYMMDD
             , IA.YYYYMM
             , IA.ISO_WEEK
             , B.WORKING_TIME                                AS QTY
             , IA.OSP_YN
          FROM (
                /* 외주 packer 추가 (2018.04.19) */
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.SCM_SITE_ID                         AS PLANT_SITE_ID
                     , '-'                                   AS FACTORY_ID
                     , A.PLANT_ID                            AS OPERATION_ID
                     , '-'                                   AS LINE_ID
                     , '-'                                   AS LINE_NAME
                     , '-'                                   AS FACTORY_NAME
                     , A.PLANT_ID                            AS OPERATION_NAME
                     , 'Working Time(Min)'                   AS MEASURE
                     , B.BASIS_YYYYMMDD                      AS YYYYMMDD
                     , B.BASIS_YYYYMM                        AS YYYYMM
                     , SUBSTR(B.BASIS_YYYYMM, -2) || B.ISO_WEEK  AS ISO_WEEK
                     , 'VENDOR'                              AS OPERATION
                     , A.OSP_YN
                  FROM SCM_MST_SITE A
                     , SCM_SYS_CALENDAR_M B
                 WHERE B.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND B.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.SITE_TYPE       = 'PLANT'
                   AND A.VALID_YN        = 'Y'
                   AND A.OSP_YN          = 'Y'
                   AND NVL(A.ATTRIBUTE1, 'N') <> 'Y'         /* line 등록 외주사 제외 */
                   AND ( UPPER(P_DIVISION_ID) = 'ALL'
                         OR A.DIVISION_ID = UPPER(P_DIVISION_ID) )
                   AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                         OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                         OR A.SCM_SITE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL)
                                                FROM DUAL
                                             CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                 UNION
                /* line 등록 외주 추가 (2020.02.06) */
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID                         AS PLANT_SITE_ID
                     , '-'                                   AS FACTORY_ID
                     , B.OPERATION_ID                        AS OPERATION_ID
                     , B.LINE_ID
                     , B.LINE_NAME
                     , '-'                                   AS FACTORY_NAME
                     , B.OPERATION_ID                        AS OPERATION_NAME
                     , 'Working Time(Min)'                   AS MEASURE
                     , C.BASIS_YYYYMMDD                      AS YYYYMMDD
                     , C.BASIS_YYYYMM                        AS YYYYMM
                     , SUBSTR(C.BASIS_YYYYMM, -2) || C.ISO_WEEK  AS ISO_WEEK
                     , B.OPERATION_ID                        AS OPERATION
                     , A.OSP_YN
                  FROM SCM_MST_SITE A
                     , SCM_MST_LINE_OSP B
                     , SCM_SYS_CALENDAR_M C
                 WHERE B.DIVISION_ID     = A.DIVISION_ID
                   AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                   AND C.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND C.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.SITE_TYPE       = 'PLANT'
                   AND A.VALID_YN        = 'Y'
                   AND A.OSP_YN          = 'Y'
                   AND NVL(A.ATTRIBUTE1, 'N') = 'Y'
                   AND ( UPPER(P_DIVISION_ID) = 'ALL'
                         OR A.DIVISION_ID = UPPER(P_DIVISION_ID) )
                   AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                         OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                         OR A.SCM_SITE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL)
                                                FROM DUAL
                                             CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                   AND ( TRIM(P_LINE_ID) IS NULL
                         OR UPPER(P_LINE_ID) = 'ALL'
                         OR B.LINE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_LINE_ID), '[^,]+', 1, LEVEL)
                                            FROM DUAL
                                         CONNECT BY REGEXP_SUBSTR(UPPER(P_LINE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
               ) IA
             , SCP_MST_WORKING_TIME B
             , SCP_MST_WORKING_TIME_DEFAULT C
         WHERE B.DIVISION_ID(+)   = IA.DIVISION_ID
           AND B.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
           AND B.FACTORY_ID(+)    = IA.FACTORY_ID
           AND B.OPERATION_ID(+)  = IA.OPERATION_ID
           AND B.LINE_ID(+)       = IA.LINE_ID
           AND B.YYYYMMDD(+)      = IA.YYYYMMDD
           AND C.DIVISION_ID(+)   = IA.DIVISION_ID
           AND C.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
           AND C.FACTORY_ID(+)    = IA.FACTORY_ID
           AND C.OPERATION_ID(+)  = IA.OPERATION_ID
           AND C.LINE_ID(+)       = IA.LINE_ID
           AND ( TRIM(P_OPERATION_ID) IS NULL
                 OR UPPER(P_OPERATION_ID) = 'ALL'
                 OR IA.OPERATION IN (SELECT REGEXP_SUBSTR(UPPER(P_OPERATION_ID), '[^,]+', 1, LEVEL)
                                       FROM DUAL
                                    CONNECT BY REGEXP_SUBSTR(UPPER(P_OPERATION_ID), '[^,]+', 1, LEVEL) IS NOT NULL) );

        /*==============================================================================================*
         * 칸 펼치기
         * 기간 안의 일자마다 칸이 하나씩 생기므로 칸 구성을 실행 시점에 만든다.
         * (AS-IS 도 같은 이유로 조회문을 실행 시점에 조립한다)
         *==============================================================================================*/
        FOR C1 IN (SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                     FROM SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                    GROUP BY A.BASIS_YYYYMMDD
                    ORDER BY A.BASIS_YYYYMMDD)
        LOOP
            V_COL_SQL := V_COL_SQL || '     , SUM(CASE WHEN YYYYMMDD = ''' || C1.YYYYMMDD
                                   || ''' THEN QTY END) AS ' || C1.YYYYMMDD || CHR(10);
        END LOOP;

        V_SQL := 'SELECT IA.*' || CHR(10)
              || '  FROM (' || CHR(10)
              || 'SELECT DIVISION_ID' || CHR(10)
              || '     , PLANT_SITE_ID' || CHR(10)
              || '     , FACTORY_ID' || CHR(10)
              || '     , FACTORY_NAME' || CHR(10)
              || '     , OPERATION_ID' || CHR(10)
              || '     , OPERATION_NAME' || CHR(10)
              || '     , LINE_ID' || CHR(10)
              || '     , LINE_NAME' || CHR(10)
              || '     , MEASURE' || CHR(10)
              || '     , OSP_YN' || CHR(10)
              || '     , (SELECT SA.DIVISION_NAME FROM SCM_MST_DIVISION SA'
              || ' WHERE SA.DIVISION_ID = A.DIVISION_ID AND ROWNUM = 1) AS DIVISION_NAME' || CHR(10)
              || '     , (SELECT MAX(SA.SITE_DESCRIPTION) FROM SCM_MST_SITE SA'
              || ' WHERE SA.SCM_SITE_ID = A.PLANT_SITE_ID) AS PLANT_SITE_NAME' || CHR(10)
              || '     , WORKING_TIME_DEFAULT' || CHR(10)
              || '     , LAST_INPUT_DATE' || CHR(10)
              || V_COL_SQL
              || '  FROM GT_SCP0019_PIVOT A' || CHR(10)
              || ' GROUP BY DIVISION_ID' || CHR(10)
              || '        , PLANT_SITE_ID' || CHR(10)
              || '        , FACTORY_ID' || CHR(10)
              || '        , FACTORY_NAME' || CHR(10)
              || '        , OPERATION_ID' || CHR(10)
              || '        , OPERATION_NAME' || CHR(10)
              || '        , WORKING_TIME_DEFAULT' || CHR(10)
              || '        , LINE_ID' || CHR(10)
              || '        , LINE_NAME' || CHR(10)
              || '        , LAST_INPUT_DATE' || CHR(10)
              || '        , MEASURE' || CHR(10)
              || '        , OSP_YN' || CHR(10)
              || '       ) IA' || CHR(10)
              /* 정렬 : AS-IS(MSSQL)와 줄 세우는 방식을 맞춘다.
               *        1) 오름차순에서 빈 값이 앞, 내림차순에서 뒤 (Oracle 기본은 반대)
               *        2) 대문자와 소문자를 가리지 않는다
               *        3) 하이픈 · 밑줄 같은 기호를 빼고(띄어쓰기는 남긴다) 먼저 견준 뒤, 같으면 원래 값으로 다시 견준다
               *           (그렇게 하지 않으면 Peopleworks_CN 과 PeopleWorks-KR-1,
               *            PeopleWorks-US CHI 와 PeopleWorks-US-AZ 의 앞뒤가 뒤바뀐다) */
              || ' ORDER BY IA.LAST_INPUT_DATE NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.DIVISION_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.DIVISION_NAME, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.PLANT_SITE_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.PLANT_SITE_NAME, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.FACTORY_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.FACTORY_NAME, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.OPERATION_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)   /* PJ20202001 : operation_name asc => desc 수정 */
              || '        , NLSSORT(IA.OPERATION_NAME, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.LINE_ID, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.LINE_ID, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.MEASURE, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.OSP_YN, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10);

        OPEN O_RC1 FOR V_SQL;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'        AS CODE
             , 'SUCCESS'  AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := SQLCODE;
            V_ERR_MSG  := SQLERRM;

            OPEN O_RESULT_CURSOR FOR
            SELECT TO_CHAR(V_ERR_CODE)  AS CODE
                 , V_ERR_MSG            AS MSG
              FROM DUAL;
    END P_SCP0019_GET_WORKING_TIME;


    /*==================================================================================================*
     * Working Time 등록 · 수정 · 삭제 (AS-IS SCP0019_SAVE_WORKING_TIME_ROW)
     *
     *   P_IS_SAVE_DEFAULT = 'N' : SCP_MST_WORKING_TIME        (이력도 함께 기록)
     *   P_IS_SAVE_DEFAULT = 'Y' : SCP_MST_WORKING_TIME_DEFAULT (이력 없음 — AS-IS 와 같다)
     *   P_ACTIVE_FLAG     = 'M' 또는 'I' : 있으면 고치고 없으면 넣는다 / 'D' : 지운다
     *==================================================================================================*/
    PROCEDURE P_SCP0019_SAVE_WORKING_TIME_ROW
    (
        P_ACTIVE_FLAG            IN  CLOB,
        P_DIVISION_ID            IN  CLOB,
        P_PLANT_SITE_ID          IN  CLOB,
        P_FACTORY_ID             IN  CLOB,
        P_OPERATION_ID           IN  CLOB,
        P_LINE_ID                IN  CLOB,
        P_YYYYMMDD               IN  CLOB,
        P_WORKING_TIME           IN  CLOB,
        P_IS_SAVE_DEFAULT        IN  CLOB,
        P_WORKING_TIME_DEFAULT   IN  CLOB,
        P_USER_ID                IN  VARCHAR2,
        O_RESULT_CURSOR          OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW';

        T_ACTIVE_FLAG          T_TOKEN_TAB;
        T_DIVISION_ID          T_TOKEN_TAB;
        T_PLANT_SITE_ID        T_TOKEN_TAB;
        T_FACTORY_ID           T_TOKEN_TAB;
        T_OPERATION_ID         T_TOKEN_TAB;
        T_LINE_ID              T_TOKEN_TAB;
        T_YYYYMMDD             T_TOKEN_TAB;
        T_WORKING_TIME         T_TOKEN_TAB;
        T_IS_SAVE_DEFAULT      T_TOKEN_TAB;
        T_WORKING_TIME_DEFAULT T_TOKEN_TAB;

        V_MAX_LOOP_CNT  PLS_INTEGER := 0;
        V_CNT           PLS_INTEGER;

        V_ACTIVE_FLAG          VARCHAR2(4000 CHAR);
        V_DIVISION_ID          VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID        VARCHAR2(4000 CHAR);
        V_FACTORY_ID           VARCHAR2(4000 CHAR);
        V_OPERATION_ID         VARCHAR2(4000 CHAR);
        V_LINE_ID              VARCHAR2(4000 CHAR);
        V_YYYYMMDD             VARCHAR2(4000 CHAR);
        V_WORKING_TIME         VARCHAR2(4000 CHAR);
        V_IS_SAVE_DEFAULT      VARCHAR2(4000 CHAR);
        V_WORKING_TIME_DEFAULT VARCHAR2(4000 CHAR);

        V_WT_NUM               NUMBER;
        V_WTD_NUM              NUMBER;

        V_CREATION_DATE  DATE := SYSDATE;
        V_ROW_CNT        PLS_INTEGER := 0;
        V_ERR_CODE       NUMBER;
        V_ERR_MESSAGE    VARCHAR2(4000 CHAR);
        V_USER_ID        VARCHAR2(100 CHAR);  -- [E20261020-USERIDLIST] FE 는 '^' 다건 배열(userIdList)로 보내므로 첫 토큰을 사용자로 채택
    BEGIN
        SAVEPOINT SP_SCP0019_SAVE;
        V_USER_ID := NVL(REGEXP_SUBSTR(P_USER_ID, '[^^]+', 1, 1), P_USER_ID);  -- [E20261020-USERIDLIST]

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0,
                                       '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT(P_ACTIVE_FLAG,          V_DELIMITER, T_ACTIVE_FLAG,          V_CNT);
        V_MAX_LOOP_CNT := GREATEST(V_MAX_LOOP_CNT, V_CNT);
        P_SPLIT(P_DIVISION_ID,          V_DELIMITER, T_DIVISION_ID,          V_CNT);
        P_SPLIT(P_PLANT_SITE_ID,        V_DELIMITER, T_PLANT_SITE_ID,        V_CNT);
        P_SPLIT(P_FACTORY_ID,           V_DELIMITER, T_FACTORY_ID,           V_CNT);
        P_SPLIT(P_OPERATION_ID,         V_DELIMITER, T_OPERATION_ID,         V_CNT);
        P_SPLIT(P_LINE_ID,              V_DELIMITER, T_LINE_ID,              V_CNT);
        P_SPLIT(P_YYYYMMDD,             V_DELIMITER, T_YYYYMMDD,             V_CNT);
        P_SPLIT(P_WORKING_TIME,         V_DELIMITER, T_WORKING_TIME,         V_CNT);
        P_SPLIT(P_IS_SAVE_DEFAULT,      V_DELIMITER, T_IS_SAVE_DEFAULT,      V_CNT);
        P_SPLIT(P_WORKING_TIME_DEFAULT, V_DELIMITER, T_WORKING_TIME_DEFAULT, V_CNT);

        FOR I IN 1 .. V_MAX_LOOP_CNT
        LOOP
            V_ACTIVE_FLAG          := F_TK(T_ACTIVE_FLAG,          I);

            IF TRIM(V_ACTIVE_FLAG) IS NULL THEN
                CONTINUE;
            END IF;

            V_DIVISION_ID          := F_TK(T_DIVISION_ID,          I);
            V_PLANT_SITE_ID        := F_TK(T_PLANT_SITE_ID,        I);
            V_FACTORY_ID           := F_TK(T_FACTORY_ID,           I);
            V_OPERATION_ID         := F_TK(T_OPERATION_ID,         I);
            V_LINE_ID              := F_TK(T_LINE_ID,              I);
            V_YYYYMMDD             := F_TK(T_YYYYMMDD,             I);
            V_WORKING_TIME         := F_TK(T_WORKING_TIME,         I);
            V_IS_SAVE_DEFAULT      := F_TK(T_IS_SAVE_DEFAULT,      I);
            V_WORKING_TIME_DEFAULT := F_TK(T_WORKING_TIME_DEFAULT, I);

            V_WT_NUM  := F_TO_NUM(V_WORKING_TIME);
            V_WTD_NUM := F_TO_NUM(V_WORKING_TIME_DEFAULT);

            /* WORKING TIME 저장 */
            IF NVL(V_IS_SAVE_DEFAULT, 'N') = 'N' THEN

                /* 이력저장 */
                P_WORKING_TIME_HIST(V_DIVISION_ID, V_PLANT_SITE_ID, V_FACTORY_ID, V_OPERATION_ID,
                                    V_LINE_ID, V_YYYYMMDD, V_WORKING_TIME, V_USER_ID,
                                    V_CREATION_DATE, V_USER_ID);

                IF UPPER(V_ACTIVE_FLAG) IN ('M', 'I') THEN

                    UPDATE SCP_MST_WORKING_TIME
                       SET WORKING_TIME     = V_WT_NUM
                         , LAST_UPDATED_BY  = V_USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID
                       AND YYYYMMDD      = V_YYYYMMDD;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_MST_WORKING_TIME
                             ( DIVISION_ID
                             , PLANT_SITE_ID
                             , FACTORY_ID
                             , OPERATION_ID
                             , LINE_ID
                             , YYYYMMDD
                             , WORKING_TIME
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             )
                        VALUES
                             ( V_DIVISION_ID
                             , V_PLANT_SITE_ID
                             , V_FACTORY_ID
                             , V_OPERATION_ID
                             , V_LINE_ID
                             , V_YYYYMMDD
                             , V_WT_NUM
                             , V_USER_ID
                             , SYSDATE
                             , V_USER_ID
                             , SYSDATE
                             );
                    END IF;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_MST_WORKING_TIME
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID
                       AND YYYYMMDD      = V_YYYYMMDD;

                END IF;

            /* WORKING TIME DEFAULT 저장 */
            ELSE

                IF UPPER(V_ACTIVE_FLAG) IN ('M', 'I') THEN

                    UPDATE SCP_MST_WORKING_TIME_DEFAULT
                       SET WORKING_TIME_DEFAULT = V_WTD_NUM
                         , LAST_UPDATED_BY      = V_USER_ID
                         , LAST_UPDATE_DATE     = SYSDATE
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_MST_WORKING_TIME_DEFAULT
                             ( DIVISION_ID
                             , PLANT_SITE_ID
                             , FACTORY_ID
                             , OPERATION_ID
                             , LINE_ID
                             , WORKING_TIME_DEFAULT
                             , VALID_YN
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             )
                        VALUES
                             ( V_DIVISION_ID
                             , V_PLANT_SITE_ID
                             , V_FACTORY_ID
                             , V_OPERATION_ID
                             , V_LINE_ID
                             , V_WTD_NUM
                             , 'Y'
                             , V_USER_ID
                             , SYSDATE
                             , V_USER_ID
                             , SYSDATE
                             );
                    END IF;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_MST_WORKING_TIME_DEFAULT
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID;

                END IF;

            END IF;

            V_ROW_CNT := V_ROW_CNT + 1;

        END LOOP;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', V_ROW_CNT,
                                       '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT 'S'        AS RESULT_CODE
             , V_ROW_CNT  AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SCP0019_SAVE;

            INSERT INTO SCM_SYS_LOG_BATCH
                 ( PROGRAM_NAME
                 , LOG_TYPE
                 , LOG_COUNT
                 , LOG_MESSAGE
                 , DESCRIPTION
                 , EVENT_DATE
                 , CREATION_DATE
                 , CREATED_BY
                 , LAST_UPDATE_DATE
                 , LAST_UPDATED_BY
                 )
            VALUES
                 ( V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , V_ERR_MESSAGE
                 , NULL
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME
                 );

            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
            SELECT 'F'            AS RESULT_CODE
                 , V_ERR_CODE     AS ERR_CODE
                 , V_ERR_MESSAGE  AS ERR_MESSAGE
              FROM DUAL;
    END P_SCP0019_SAVE_WORKING_TIME_ROW;

END PKG_SCP0019;
/

-- 검증
SELECT PROC_NM, COL_NM, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ('PKG_SCP0096.P_SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP','PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW') AND UPPER(COL_NM) LIKE 'USERID%' ORDER BY 1;
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_SCP0096','PKG_SCP0019') ORDER BY 1,2;
