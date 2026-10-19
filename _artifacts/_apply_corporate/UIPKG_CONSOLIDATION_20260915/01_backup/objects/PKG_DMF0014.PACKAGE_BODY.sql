-- SOURCE-FRESH: SCM_MGR.PKG_DMF0014 PACKAGE BODY LAST_DDL=2026-09-15 17:21:26 FETCHED=2026-09-15 18:50 DB=ZIOUI1
-- STEP 1 BACKUP (원복용 원문 · STATUS=VALID)
SET DEFINE OFF
CREATE OR REPLACE PACKAGE BODY SCM_MGR."PKG_DMF0014" IS

    PROCEDURE P_DMF0014_GET_SPREAD_TITLE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_GET_SPREAD_TITLE
        * Description  :
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2017/12/22  SongDH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022/10/26  KDW2819        [C20221024-000507]CUST FCST Upload 오류 수정
        * 2026/03/15  김준규        [PJ20264226] NextSCM Pilot 설계 및 개발
        *
        */
     AS

        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD, 'p_end_yyyymmdd' VALUE P_END_YYYYMMDD, 'p_bucket_type' VALUE P_BUCKET_TYPE);

        IF P_BUCKET_TYPE = 'DAILY' THEN
            OPEN O_RC1 FOR
                SELECT 'D_' || BASIS_YYYYMMDD AS COLUMN_NAME, BASIS_YYYYMMDD COLUMN_LABEL, A.DAYOFWEEK SMALL_LABEL_NAME, 'Y' AS EDIT_YN
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD; --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
        ELSIF P_BUCKET_TYPE = 'WEEKLY' THEN
            OPEN O_RC1 FOR
                SELECT 'D_' || MIN(A.BASIS_START_DATE) COLUMN_NAME, MIN(A.BASIS_START_DATE) COLUMN_LABEL, A.WEEK_NAME SMALL_LABEL_NAME, 'Y' AS EDIT_YN
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                GROUP  BY A.ISO_YYYYWW, A.WEEK_NAME
                ORDER  BY COLUMN_LABEL;
        ELSIF P_BUCKET_TYPE = 'MONTHLY' THEN
            OPEN O_RC1 FOR
                SELECT 'D_' || MIN(A.BASIS_YYYYMM) || '01' AS COLUMN_NAME
                      ,MIN(A.BASIS_YYYYMM) || '01' AS COLUMN_LABEL
                      ,A.MONTH_NAME SMALL_LABEL_NAME
                      ,'Y' AS EDIT_YN
                FROM   SCM_SYS_CALENDAR_M A
                WHERE  A.BASIS_YYYYMMDD >= P_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                GROUP  BY A.MONTH_NAME;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_GET_SPREAD_TITLE;

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,P_PROGRAM_ID    IN VARCHAR2
       ,P_SHEET_NAME    IN VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD
        * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD
        * Program History
        *===========================================================================================================
        *   Date       In Charge      Description
        *===========================================================================================================
        * 2018. 01. 02   SongDH     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022. 10. 26   KDW2819    [C20221024-000507]CUST FCST Upload 오류 수정
        * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
        * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
        * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
         * 2026.07.08 Claude          [DEDUP/NORMALIZE FIX] 잔존배치 정리 + 같은 초 이중 스테이징 dedup + 일자행 숫자표기 정규화
        */
        --DMF0014_CUST_FCST_EXCEL_UPLOAD('1', 'hwayoung.lim');
     AS

        V_IN_PARA_DATA   VARCHAR2(4000);
        V_PROGRAM_ID     VARCHAR2(40 CHAR) := P_PROGRAM_ID; --'DMF0014';
        V_SHEET_NAME     VARCHAR2(40 CHAR) := P_SHEET_NAME; --'FCST Upload';
        V_SQL_TEXT       VARCHAR2(4000 CHAR);
        V_CREATION_DATE  VARCHAR2(40 CHAR);
        V_COUNT          INTEGER;
        V_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_END_YYYYMMDD   VARCHAR2(8 CHAR);
        V_DIVISION       VARCHAR2(10 CHAR);
        V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
        V_LOG_TYPE       VARCHAR2(30 CHAR);
        N_LOG_COUNT      INTEGER := 0;
        V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
        V_DESCRIPTION    VARCHAR2(500 CHAR);
        D_EVENT_DATE     DATE;
        V_PROC_INPUT     CLOB := NULL;
        V_SQL_CODE       VARCHAR2(100) := NULL;
        V_SQL_ERRMSG     VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE      VARCHAR2(4000 CHAR) := NULL;
        V_STEP           VARCHAR2(4000 CHAR) := NULL;
        v_err_cnt        NUMBER;
        /* ⭐ [2026-08-14 허위성공 차단] 적재 실적 추적용 */
        v_ins_cnt        NUMBER := 0;   /* INSERT 가 반환한 행수 */
        v_live_cnt       NUMBER := 0;   /* 적재 후 원장에 **실제로 남아있는** 행수 */
        d_ins_from       DATE;          /* 적재 시작 시각 — 재확인 범위 기준 */
        /* 양식(헤더) 검증용 — E20260911-DMF0014FORM */
        v_hdr_meta       VARCHAR2(4000 CHAR);   /* SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT */
        v_hdr_expect     VARCHAR2(4000 CHAR);   /* 기대 헤더 = 앞 13토큰(식별 컬럼) */
        v_hdr_file       VARCHAR2(4000 CHAR);   /* 업로드 파일의 헤더 행 */
        /* 복수 오류 집계용 — E20260911-DMF0014MULTI */
        v_err_summary    VARCHAR2(4000 CHAR);
        v_err_kinds      NUMBER := 0;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_mode' VALUE P_MODE
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_program_id' VALUE P_PROGRAM_ID
                                     ,'p_sheet_name' VALUE P_SHEET_NAME);

        -- LOG 용 변수 설정
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO   V_CREATION_DATE
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY;
        --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
        IF V_CREATION_DATE IS NULL THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Data Not Found [' || TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') || ']';
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

        --DBMS_OUTPUT.put_line('V_CREATION_DATE:'||V_CREATION_DATE||',');
        --DMF0014_CUST_FCST_EXCEL_UPLOAD('1', 'hwayoung.lim');
        IF P_MODE = 0 THEN
            -- [DEDUP FIX 07-08] (1) 잔존 배치 정리 — 현재 배치(V_CREATION_DATE) 외 본인 이전 업로드 행 제거
            BEGIN
                DELETE FROM SCM_ADM_EXCEL_UPLOAD
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') != V_CREATION_DATE;
            END;

            -- [DEDUP FIX 07-08] (2) 같은 초 이중 스테이징 dedup — 동일 배치에 타이틀행(Division*)이
            --   2개 이상이면 두 번째 타이틀부터 전부 삭제 (10행이 20행 Duplication Key 오탐 차단)
            BEGIN
                DELETE FROM SCM_ADM_EXCEL_UPLOAD
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                /* [E20260818-BATCHKEEP] 같은 초 재업로드 시 배치가 병합된다(CREATION_DATE 초 단위).
                   종전 조건(UPLOAD_ID >= 2번째 타이틀행)은 **먼저 올린 행을 남기고 새 행을 지워서**
                   ①남은 행 상태가 'UPLOAD' 가 아니라 L208 SELECT INTO 가 ORA-01403 → HTTP 500
                   ②또는 병합 잔존분이 'Duplication Key.' 로 잡히는 증상을 만들었다.
                   ⇒ **마지막 타이틀행 앞을 지워 최신 업로드분만 남긴다.** */
                AND    UPLOAD_ID < (SELECT MAX(UPLOAD_ID)
                                     FROM   SCM_ADM_EXCEL_UPLOAD
                                     WHERE  PROGRAM_ID = V_PROGRAM_ID
                                     AND    SHEET_NAME = V_SHEET_NAME
                                     AND    CREATED_BY = P_CREATED_BY
                                     AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                     AND    UPPER(ATTRIBUTE1) = 'DIVISION*');
            END;

        BEGIN
            SELECT ATTRIBUTE1
            INTO   V_DIVISION
            FROM   SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = V_PROGRAM_ID
            AND    SHEET_NAME = V_SHEET_NAME
            AND    CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
                  --AND    UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            FETCH  FIRST 1 ROWS ONLY;
        END;
        ELSE
        BEGIN
            SELECT ATTRIBUTE1
            INTO   V_DIVISION
            FROM   SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = V_PROGRAM_ID
            AND    SHEET_NAME = V_SHEET_NAME
            AND    CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
                  --AND    UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    UPLOAD_STATUS_CODE IN ( 'SUCCESS')
            FETCH  FIRST 1 ROWS ONLY;
        END;
        END IF;

        -- p_mode = 0 이면 Validation
        IF NVL(P_MODE, 0) = 0 THEN
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD T
                SET    UPLOAD_STATUS_CODE = 'UPLOAD', MESSAGE_TEXT = NULL
                WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                AND    T.SHEET_NAME = V_SHEET_NAME
                AND    T.CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    NVL(T.UPLOAD_STATUS_CODE, 'X') != 'UPLOAD';
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
                V_LOG_TYPE    := '10';
                V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
                V_DESCRIPTION := P_MODE;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SKIP'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    (ATTRIBUTE1 IS NULL OR LENGTH(ATTRIBUTE1) = 0 OR UPPER(ATTRIBUTE1) = 'TOTAL');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
                V_LOG_TYPE    := '20';
                V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'V_TITLE'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
            END;

            -- [NORMALIZE 07-08] 일자-tier 행(ATTRIBUTE1 NULL) 숫자표기 정규화 — Excel 숫자셀 유입분
            --   (과학표기 2.0260706E7 / 소수점 20260706.0)을 'YYYYMMDD' 문자로 환원 (ORA-01841 차단).
            --   8자리/비숫자/NULL 은 불변. 데이터행(ATTRIBUTE1 존재)은 미대상.
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE14 = CASE WHEN ATTRIBUTE14 IS NULL OR REGEXP_LIKE(ATTRIBUTE14, '^[0-9]{8}$') THEN ATTRIBUTE14
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE14), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE14), 'FM99999999')
                                  ELSE ATTRIBUTE14 END,
                       ATTRIBUTE15 = CASE WHEN ATTRIBUTE15 IS NULL OR REGEXP_LIKE(ATTRIBUTE15, '^[0-9]{8}$') THEN ATTRIBUTE15
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE15), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE15), 'FM99999999')
                                  ELSE ATTRIBUTE15 END,
                       ATTRIBUTE16 = CASE WHEN ATTRIBUTE16 IS NULL OR REGEXP_LIKE(ATTRIBUTE16, '^[0-9]{8}$') THEN ATTRIBUTE16
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE16), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE16), 'FM99999999')
                                  ELSE ATTRIBUTE16 END,
                       ATTRIBUTE17 = CASE WHEN ATTRIBUTE17 IS NULL OR REGEXP_LIKE(ATTRIBUTE17, '^[0-9]{8}$') THEN ATTRIBUTE17
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE17), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE17), 'FM99999999')
                                  ELSE ATTRIBUTE17 END,
                       ATTRIBUTE18 = CASE WHEN ATTRIBUTE18 IS NULL OR REGEXP_LIKE(ATTRIBUTE18, '^[0-9]{8}$') THEN ATTRIBUTE18
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE18), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE18), 'FM99999999')
                                  ELSE ATTRIBUTE18 END,
                       ATTRIBUTE19 = CASE WHEN ATTRIBUTE19 IS NULL OR REGEXP_LIKE(ATTRIBUTE19, '^[0-9]{8}$') THEN ATTRIBUTE19
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE19), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE19), 'FM99999999')
                                  ELSE ATTRIBUTE19 END,
                       ATTRIBUTE20 = CASE WHEN ATTRIBUTE20 IS NULL OR REGEXP_LIKE(ATTRIBUTE20, '^[0-9]{8}$') THEN ATTRIBUTE20
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE20), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE20), 'FM99999999')
                                  ELSE ATTRIBUTE20 END,
                       ATTRIBUTE21 = CASE WHEN ATTRIBUTE21 IS NULL OR REGEXP_LIKE(ATTRIBUTE21, '^[0-9]{8}$') THEN ATTRIBUTE21
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE21), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE21), 'FM99999999')
                                  ELSE ATTRIBUTE21 END,
                       ATTRIBUTE22 = CASE WHEN ATTRIBUTE22 IS NULL OR REGEXP_LIKE(ATTRIBUTE22, '^[0-9]{8}$') THEN ATTRIBUTE22
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE22), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE22), 'FM99999999')
                                  ELSE ATTRIBUTE22 END,
                       ATTRIBUTE23 = CASE WHEN ATTRIBUTE23 IS NULL OR REGEXP_LIKE(ATTRIBUTE23, '^[0-9]{8}$') THEN ATTRIBUTE23
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE23), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE23), 'FM99999999')
                                  ELSE ATTRIBUTE23 END,
                       ATTRIBUTE24 = CASE WHEN ATTRIBUTE24 IS NULL OR REGEXP_LIKE(ATTRIBUTE24, '^[0-9]{8}$') THEN ATTRIBUTE24
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE24), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE24), 'FM99999999')
                                  ELSE ATTRIBUTE24 END,
                       ATTRIBUTE25 = CASE WHEN ATTRIBUTE25 IS NULL OR REGEXP_LIKE(ATTRIBUTE25, '^[0-9]{8}$') THEN ATTRIBUTE25
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE25), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE25), 'FM99999999')
                                  ELSE ATTRIBUTE25 END,
                       ATTRIBUTE26 = CASE WHEN ATTRIBUTE26 IS NULL OR REGEXP_LIKE(ATTRIBUTE26, '^[0-9]{8}$') THEN ATTRIBUTE26
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE26), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE26), 'FM99999999')
                                  ELSE ATTRIBUTE26 END,
                       ATTRIBUTE27 = CASE WHEN ATTRIBUTE27 IS NULL OR REGEXP_LIKE(ATTRIBUTE27, '^[0-9]{8}$') THEN ATTRIBUTE27
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE27), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE27), 'FM99999999')
                                  ELSE ATTRIBUTE27 END,
                       ATTRIBUTE28 = CASE WHEN ATTRIBUTE28 IS NULL OR REGEXP_LIKE(ATTRIBUTE28, '^[0-9]{8}$') THEN ATTRIBUTE28
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE28), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE28), 'FM99999999')
                                  ELSE ATTRIBUTE28 END,
                       ATTRIBUTE29 = CASE WHEN ATTRIBUTE29 IS NULL OR REGEXP_LIKE(ATTRIBUTE29, '^[0-9]{8}$') THEN ATTRIBUTE29
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE29), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE29), 'FM99999999')
                                  ELSE ATTRIBUTE29 END,
                       ATTRIBUTE30 = CASE WHEN ATTRIBUTE30 IS NULL OR REGEXP_LIKE(ATTRIBUTE30, '^[0-9]{8}$') THEN ATTRIBUTE30
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE30), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE30), 'FM99999999')
                                  ELSE ATTRIBUTE30 END,
                       ATTRIBUTE31 = CASE WHEN ATTRIBUTE31 IS NULL OR REGEXP_LIKE(ATTRIBUTE31, '^[0-9]{8}$') THEN ATTRIBUTE31
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE31), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE31), 'FM99999999')
                                  ELSE ATTRIBUTE31 END,
                       ATTRIBUTE32 = CASE WHEN ATTRIBUTE32 IS NULL OR REGEXP_LIKE(ATTRIBUTE32, '^[0-9]{8}$') THEN ATTRIBUTE32
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE32), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE32), 'FM99999999')
                                  ELSE ATTRIBUTE32 END,
                       ATTRIBUTE33 = CASE WHEN ATTRIBUTE33 IS NULL OR REGEXP_LIKE(ATTRIBUTE33, '^[0-9]{8}$') THEN ATTRIBUTE33
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE33), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE33), 'FM99999999')
                                  ELSE ATTRIBUTE33 END,
                       ATTRIBUTE34 = CASE WHEN ATTRIBUTE34 IS NULL OR REGEXP_LIKE(ATTRIBUTE34, '^[0-9]{8}$') THEN ATTRIBUTE34
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE34), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE34), 'FM99999999')
                                  ELSE ATTRIBUTE34 END,
                       ATTRIBUTE35 = CASE WHEN ATTRIBUTE35 IS NULL OR REGEXP_LIKE(ATTRIBUTE35, '^[0-9]{8}$') THEN ATTRIBUTE35
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE35), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE35), 'FM99999999')
                                  ELSE ATTRIBUTE35 END,
                       ATTRIBUTE36 = CASE WHEN ATTRIBUTE36 IS NULL OR REGEXP_LIKE(ATTRIBUTE36, '^[0-9]{8}$') THEN ATTRIBUTE36
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE36), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE36), 'FM99999999')
                                  ELSE ATTRIBUTE36 END,
                       ATTRIBUTE37 = CASE WHEN ATTRIBUTE37 IS NULL OR REGEXP_LIKE(ATTRIBUTE37, '^[0-9]{8}$') THEN ATTRIBUTE37
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE37), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE37), 'FM99999999')
                                  ELSE ATTRIBUTE37 END,
                       ATTRIBUTE38 = CASE WHEN ATTRIBUTE38 IS NULL OR REGEXP_LIKE(ATTRIBUTE38, '^[0-9]{8}$') THEN ATTRIBUTE38
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE38), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE38), 'FM99999999')
                                  ELSE ATTRIBUTE38 END,
                       ATTRIBUTE39 = CASE WHEN ATTRIBUTE39 IS NULL OR REGEXP_LIKE(ATTRIBUTE39, '^[0-9]{8}$') THEN ATTRIBUTE39
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE39), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE39), 'FM99999999')
                                  ELSE ATTRIBUTE39 END,
                       ATTRIBUTE40 = CASE WHEN ATTRIBUTE40 IS NULL OR REGEXP_LIKE(ATTRIBUTE40, '^[0-9]{8}$') THEN ATTRIBUTE40
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE40), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE40), 'FM99999999')
                                  ELSE ATTRIBUTE40 END,
                       ATTRIBUTE41 = CASE WHEN ATTRIBUTE41 IS NULL OR REGEXP_LIKE(ATTRIBUTE41, '^[0-9]{8}$') THEN ATTRIBUTE41
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE41), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE41), 'FM99999999')
                                  ELSE ATTRIBUTE41 END,
                       ATTRIBUTE42 = CASE WHEN ATTRIBUTE42 IS NULL OR REGEXP_LIKE(ATTRIBUTE42, '^[0-9]{8}$') THEN ATTRIBUTE42
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE42), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE42), 'FM99999999')
                                  ELSE ATTRIBUTE42 END,
                       ATTRIBUTE43 = CASE WHEN ATTRIBUTE43 IS NULL OR REGEXP_LIKE(ATTRIBUTE43, '^[0-9]{8}$') THEN ATTRIBUTE43
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE43), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE43), 'FM99999999')
                                  ELSE ATTRIBUTE43 END,
                       ATTRIBUTE44 = CASE WHEN ATTRIBUTE44 IS NULL OR REGEXP_LIKE(ATTRIBUTE44, '^[0-9]{8}$') THEN ATTRIBUTE44
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE44), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE44), 'FM99999999')
                                  ELSE ATTRIBUTE44 END,
                       ATTRIBUTE45 = CASE WHEN ATTRIBUTE45 IS NULL OR REGEXP_LIKE(ATTRIBUTE45, '^[0-9]{8}$') THEN ATTRIBUTE45
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE45), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE45), 'FM99999999')
                                  ELSE ATTRIBUTE45 END,
                       ATTRIBUTE46 = CASE WHEN ATTRIBUTE46 IS NULL OR REGEXP_LIKE(ATTRIBUTE46, '^[0-9]{8}$') THEN ATTRIBUTE46
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE46), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE46), 'FM99999999')
                                  ELSE ATTRIBUTE46 END,
                       ATTRIBUTE47 = CASE WHEN ATTRIBUTE47 IS NULL OR REGEXP_LIKE(ATTRIBUTE47, '^[0-9]{8}$') THEN ATTRIBUTE47
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE47), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE47), 'FM99999999')
                                  ELSE ATTRIBUTE47 END,
                       ATTRIBUTE48 = CASE WHEN ATTRIBUTE48 IS NULL OR REGEXP_LIKE(ATTRIBUTE48, '^[0-9]{8}$') THEN ATTRIBUTE48
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE48), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE48), 'FM99999999')
                                  ELSE ATTRIBUTE48 END,
                       ATTRIBUTE49 = CASE WHEN ATTRIBUTE49 IS NULL OR REGEXP_LIKE(ATTRIBUTE49, '^[0-9]{8}$') THEN ATTRIBUTE49
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE49), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE49), 'FM99999999')
                                  ELSE ATTRIBUTE49 END,
                       ATTRIBUTE50 = CASE WHEN ATTRIBUTE50 IS NULL OR REGEXP_LIKE(ATTRIBUTE50, '^[0-9]{8}$') THEN ATTRIBUTE50
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE50), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE50), 'FM99999999')
                                  ELSE ATTRIBUTE50 END,
                       ATTRIBUTE51 = CASE WHEN ATTRIBUTE51 IS NULL OR REGEXP_LIKE(ATTRIBUTE51, '^[0-9]{8}$') THEN ATTRIBUTE51
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE51), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE51), 'FM99999999')
                                  ELSE ATTRIBUTE51 END,
                       ATTRIBUTE52 = CASE WHEN ATTRIBUTE52 IS NULL OR REGEXP_LIKE(ATTRIBUTE52, '^[0-9]{8}$') THEN ATTRIBUTE52
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE52), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE52), 'FM99999999')
                                  ELSE ATTRIBUTE52 END,
                       ATTRIBUTE53 = CASE WHEN ATTRIBUTE53 IS NULL OR REGEXP_LIKE(ATTRIBUTE53, '^[0-9]{8}$') THEN ATTRIBUTE53
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE53), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE53), 'FM99999999')
                                  ELSE ATTRIBUTE53 END,
                       ATTRIBUTE54 = CASE WHEN ATTRIBUTE54 IS NULL OR REGEXP_LIKE(ATTRIBUTE54, '^[0-9]{8}$') THEN ATTRIBUTE54
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE54), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE54), 'FM99999999')
                                  ELSE ATTRIBUTE54 END,
                       ATTRIBUTE55 = CASE WHEN ATTRIBUTE55 IS NULL OR REGEXP_LIKE(ATTRIBUTE55, '^[0-9]{8}$') THEN ATTRIBUTE55
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE55), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE55), 'FM99999999')
                                  ELSE ATTRIBUTE55 END,
                       ATTRIBUTE56 = CASE WHEN ATTRIBUTE56 IS NULL OR REGEXP_LIKE(ATTRIBUTE56, '^[0-9]{8}$') THEN ATTRIBUTE56
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE56), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE56), 'FM99999999')
                                  ELSE ATTRIBUTE56 END,
                       ATTRIBUTE57 = CASE WHEN ATTRIBUTE57 IS NULL OR REGEXP_LIKE(ATTRIBUTE57, '^[0-9]{8}$') THEN ATTRIBUTE57
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE57), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE57), 'FM99999999')
                                  ELSE ATTRIBUTE57 END,
                       ATTRIBUTE58 = CASE WHEN ATTRIBUTE58 IS NULL OR REGEXP_LIKE(ATTRIBUTE58, '^[0-9]{8}$') THEN ATTRIBUTE58
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE58), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE58), 'FM99999999')
                                  ELSE ATTRIBUTE58 END,
                       ATTRIBUTE59 = CASE WHEN ATTRIBUTE59 IS NULL OR REGEXP_LIKE(ATTRIBUTE59, '^[0-9]{8}$') THEN ATTRIBUTE59
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE59), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE59), 'FM99999999')
                                  ELSE ATTRIBUTE59 END,
                       ATTRIBUTE60 = CASE WHEN ATTRIBUTE60 IS NULL OR REGEXP_LIKE(ATTRIBUTE60, '^[0-9]{8}$') THEN ATTRIBUTE60
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE60), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE60), 'FM99999999')
                                  ELSE ATTRIBUTE60 END,
                       ATTRIBUTE61 = CASE WHEN ATTRIBUTE61 IS NULL OR REGEXP_LIKE(ATTRIBUTE61, '^[0-9]{8}$') THEN ATTRIBUTE61
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE61), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE61), 'FM99999999')
                                  ELSE ATTRIBUTE61 END,
                       ATTRIBUTE62 = CASE WHEN ATTRIBUTE62 IS NULL OR REGEXP_LIKE(ATTRIBUTE62, '^[0-9]{8}$') THEN ATTRIBUTE62
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE62), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE62), 'FM99999999')
                                  ELSE ATTRIBUTE62 END,
                       ATTRIBUTE63 = CASE WHEN ATTRIBUTE63 IS NULL OR REGEXP_LIKE(ATTRIBUTE63, '^[0-9]{8}$') THEN ATTRIBUTE63
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE63), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE63), 'FM99999999')
                                  ELSE ATTRIBUTE63 END,
                       ATTRIBUTE64 = CASE WHEN ATTRIBUTE64 IS NULL OR REGEXP_LIKE(ATTRIBUTE64, '^[0-9]{8}$') THEN ATTRIBUTE64
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE64), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE64), 'FM99999999')
                                  ELSE ATTRIBUTE64 END,
                       ATTRIBUTE65 = CASE WHEN ATTRIBUTE65 IS NULL OR REGEXP_LIKE(ATTRIBUTE65, '^[0-9]{8}$') THEN ATTRIBUTE65
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE65), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE65), 'FM99999999')
                                  ELSE ATTRIBUTE65 END,
                       ATTRIBUTE66 = CASE WHEN ATTRIBUTE66 IS NULL OR REGEXP_LIKE(ATTRIBUTE66, '^[0-9]{8}$') THEN ATTRIBUTE66
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE66), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE66), 'FM99999999')
                                  ELSE ATTRIBUTE66 END,
                       ATTRIBUTE67 = CASE WHEN ATTRIBUTE67 IS NULL OR REGEXP_LIKE(ATTRIBUTE67, '^[0-9]{8}$') THEN ATTRIBUTE67
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE67), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE67), 'FM99999999')
                                  ELSE ATTRIBUTE67 END,
                       ATTRIBUTE68 = CASE WHEN ATTRIBUTE68 IS NULL OR REGEXP_LIKE(ATTRIBUTE68, '^[0-9]{8}$') THEN ATTRIBUTE68
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE68), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE68), 'FM99999999')
                                  ELSE ATTRIBUTE68 END,
                       ATTRIBUTE69 = CASE WHEN ATTRIBUTE69 IS NULL OR REGEXP_LIKE(ATTRIBUTE69, '^[0-9]{8}$') THEN ATTRIBUTE69
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE69), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE69), 'FM99999999')
                                  ELSE ATTRIBUTE69 END,
                       ATTRIBUTE70 = CASE WHEN ATTRIBUTE70 IS NULL OR REGEXP_LIKE(ATTRIBUTE70, '^[0-9]{8}$') THEN ATTRIBUTE70
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE70), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE70), 'FM99999999')
                                  ELSE ATTRIBUTE70 END,
                       ATTRIBUTE71 = CASE WHEN ATTRIBUTE71 IS NULL OR REGEXP_LIKE(ATTRIBUTE71, '^[0-9]{8}$') THEN ATTRIBUTE71
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE71), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE71), 'FM99999999')
                                  ELSE ATTRIBUTE71 END,
                       ATTRIBUTE72 = CASE WHEN ATTRIBUTE72 IS NULL OR REGEXP_LIKE(ATTRIBUTE72, '^[0-9]{8}$') THEN ATTRIBUTE72
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE72), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE72), 'FM99999999')
                                  ELSE ATTRIBUTE72 END,
                       ATTRIBUTE73 = CASE WHEN ATTRIBUTE73 IS NULL OR REGEXP_LIKE(ATTRIBUTE73, '^[0-9]{8}$') THEN ATTRIBUTE73
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE73), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE73), 'FM99999999')
                                  ELSE ATTRIBUTE73 END,
                       ATTRIBUTE74 = CASE WHEN ATTRIBUTE74 IS NULL OR REGEXP_LIKE(ATTRIBUTE74, '^[0-9]{8}$') THEN ATTRIBUTE74
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE74), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE74), 'FM99999999')
                                  ELSE ATTRIBUTE74 END,
                       ATTRIBUTE75 = CASE WHEN ATTRIBUTE75 IS NULL OR REGEXP_LIKE(ATTRIBUTE75, '^[0-9]{8}$') THEN ATTRIBUTE75
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE75), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE75), 'FM99999999')
                                  ELSE ATTRIBUTE75 END,
                       ATTRIBUTE76 = CASE WHEN ATTRIBUTE76 IS NULL OR REGEXP_LIKE(ATTRIBUTE76, '^[0-9]{8}$') THEN ATTRIBUTE76
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE76), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE76), 'FM99999999')
                                  ELSE ATTRIBUTE76 END,
                       ATTRIBUTE77 = CASE WHEN ATTRIBUTE77 IS NULL OR REGEXP_LIKE(ATTRIBUTE77, '^[0-9]{8}$') THEN ATTRIBUTE77
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE77), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE77), 'FM99999999')
                                  ELSE ATTRIBUTE77 END,
                       ATTRIBUTE78 = CASE WHEN ATTRIBUTE78 IS NULL OR REGEXP_LIKE(ATTRIBUTE78, '^[0-9]{8}$') THEN ATTRIBUTE78
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE78), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE78), 'FM99999999')
                                  ELSE ATTRIBUTE78 END,
                       ATTRIBUTE79 = CASE WHEN ATTRIBUTE79 IS NULL OR REGEXP_LIKE(ATTRIBUTE79, '^[0-9]{8}$') THEN ATTRIBUTE79
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE79), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE79), 'FM99999999')
                                  ELSE ATTRIBUTE79 END,
                       ATTRIBUTE80 = CASE WHEN ATTRIBUTE80 IS NULL OR REGEXP_LIKE(ATTRIBUTE80, '^[0-9]{8}$') THEN ATTRIBUTE80
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE80), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE80), 'FM99999999')
                                  ELSE ATTRIBUTE80 END,
                       ATTRIBUTE81 = CASE WHEN ATTRIBUTE81 IS NULL OR REGEXP_LIKE(ATTRIBUTE81, '^[0-9]{8}$') THEN ATTRIBUTE81
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE81), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE81), 'FM99999999')
                                  ELSE ATTRIBUTE81 END,
                       ATTRIBUTE82 = CASE WHEN ATTRIBUTE82 IS NULL OR REGEXP_LIKE(ATTRIBUTE82, '^[0-9]{8}$') THEN ATTRIBUTE82
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE82), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE82), 'FM99999999')
                                  ELSE ATTRIBUTE82 END,
                       ATTRIBUTE83 = CASE WHEN ATTRIBUTE83 IS NULL OR REGEXP_LIKE(ATTRIBUTE83, '^[0-9]{8}$') THEN ATTRIBUTE83
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE83), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE83), 'FM99999999')
                                  ELSE ATTRIBUTE83 END,
                       ATTRIBUTE84 = CASE WHEN ATTRIBUTE84 IS NULL OR REGEXP_LIKE(ATTRIBUTE84, '^[0-9]{8}$') THEN ATTRIBUTE84
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE84), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE84), 'FM99999999')
                                  ELSE ATTRIBUTE84 END,
                       ATTRIBUTE85 = CASE WHEN ATTRIBUTE85 IS NULL OR REGEXP_LIKE(ATTRIBUTE85, '^[0-9]{8}$') THEN ATTRIBUTE85
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE85), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE85), 'FM99999999')
                                  ELSE ATTRIBUTE85 END,
                       ATTRIBUTE86 = CASE WHEN ATTRIBUTE86 IS NULL OR REGEXP_LIKE(ATTRIBUTE86, '^[0-9]{8}$') THEN ATTRIBUTE86
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE86), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE86), 'FM99999999')
                                  ELSE ATTRIBUTE86 END,
                       ATTRIBUTE87 = CASE WHEN ATTRIBUTE87 IS NULL OR REGEXP_LIKE(ATTRIBUTE87, '^[0-9]{8}$') THEN ATTRIBUTE87
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE87), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE87), 'FM99999999')
                                  ELSE ATTRIBUTE87 END,
                       ATTRIBUTE88 = CASE WHEN ATTRIBUTE88 IS NULL OR REGEXP_LIKE(ATTRIBUTE88, '^[0-9]{8}$') THEN ATTRIBUTE88
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE88), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE88), 'FM99999999')
                                  ELSE ATTRIBUTE88 END,
                       ATTRIBUTE89 = CASE WHEN ATTRIBUTE89 IS NULL OR REGEXP_LIKE(ATTRIBUTE89, '^[0-9]{8}$') THEN ATTRIBUTE89
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE89), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE89), 'FM99999999')
                                  ELSE ATTRIBUTE89 END,
                       ATTRIBUTE90 = CASE WHEN ATTRIBUTE90 IS NULL OR REGEXP_LIKE(ATTRIBUTE90, '^[0-9]{8}$') THEN ATTRIBUTE90
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE90), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE90), 'FM99999999')
                                  ELSE ATTRIBUTE90 END,
                       ATTRIBUTE91 = CASE WHEN ATTRIBUTE91 IS NULL OR REGEXP_LIKE(ATTRIBUTE91, '^[0-9]{8}$') THEN ATTRIBUTE91
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE91), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE91), 'FM99999999')
                                  ELSE ATTRIBUTE91 END,
                       ATTRIBUTE92 = CASE WHEN ATTRIBUTE92 IS NULL OR REGEXP_LIKE(ATTRIBUTE92, '^[0-9]{8}$') THEN ATTRIBUTE92
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE92), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE92), 'FM99999999')
                                  ELSE ATTRIBUTE92 END,
                       ATTRIBUTE93 = CASE WHEN ATTRIBUTE93 IS NULL OR REGEXP_LIKE(ATTRIBUTE93, '^[0-9]{8}$') THEN ATTRIBUTE93
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE93), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE93), 'FM99999999')
                                  ELSE ATTRIBUTE93 END,
                       ATTRIBUTE94 = CASE WHEN ATTRIBUTE94 IS NULL OR REGEXP_LIKE(ATTRIBUTE94, '^[0-9]{8}$') THEN ATTRIBUTE94
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE94), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE94), 'FM99999999')
                                  ELSE ATTRIBUTE94 END,
                       ATTRIBUTE95 = CASE WHEN ATTRIBUTE95 IS NULL OR REGEXP_LIKE(ATTRIBUTE95, '^[0-9]{8}$') THEN ATTRIBUTE95
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE95), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE95), 'FM99999999')
                                  ELSE ATTRIBUTE95 END,
                       ATTRIBUTE96 = CASE WHEN ATTRIBUTE96 IS NULL OR REGEXP_LIKE(ATTRIBUTE96, '^[0-9]{8}$') THEN ATTRIBUTE96
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE96), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE96), 'FM99999999')
                                  ELSE ATTRIBUTE96 END,
                       ATTRIBUTE97 = CASE WHEN ATTRIBUTE97 IS NULL OR REGEXP_LIKE(ATTRIBUTE97, '^[0-9]{8}$') THEN ATTRIBUTE97
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE97), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE97), 'FM99999999')
                                  ELSE ATTRIBUTE97 END,
                       ATTRIBUTE98 = CASE WHEN ATTRIBUTE98 IS NULL OR REGEXP_LIKE(ATTRIBUTE98, '^[0-9]{8}$') THEN ATTRIBUTE98
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE98), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE98), 'FM99999999')
                                  ELSE ATTRIBUTE98 END,
                       ATTRIBUTE99 = CASE WHEN ATTRIBUTE99 IS NULL OR REGEXP_LIKE(ATTRIBUTE99, '^[0-9]{8}$') THEN ATTRIBUTE99
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE99), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE99), 'FM99999999')
                                  ELSE ATTRIBUTE99 END,
                       ATTRIBUTE100 = CASE WHEN ATTRIBUTE100 IS NULL OR REGEXP_LIKE(ATTRIBUTE100, '^[0-9]{8}$') THEN ATTRIBUTE100
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE100), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE100), 'FM99999999')
                                  ELSE ATTRIBUTE100 END,
                       ATTRIBUTE101 = CASE WHEN ATTRIBUTE101 IS NULL OR REGEXP_LIKE(ATTRIBUTE101, '^[0-9]{8}$') THEN ATTRIBUTE101
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE101), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE101), 'FM99999999')
                                  ELSE ATTRIBUTE101 END,
                       ATTRIBUTE102 = CASE WHEN ATTRIBUTE102 IS NULL OR REGEXP_LIKE(ATTRIBUTE102, '^[0-9]{8}$') THEN ATTRIBUTE102
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE102), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE102), 'FM99999999')
                                  ELSE ATTRIBUTE102 END,
                       ATTRIBUTE103 = CASE WHEN ATTRIBUTE103 IS NULL OR REGEXP_LIKE(ATTRIBUTE103, '^[0-9]{8}$') THEN ATTRIBUTE103
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE103), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE103), 'FM99999999')
                                  ELSE ATTRIBUTE103 END,
                       ATTRIBUTE104 = CASE WHEN ATTRIBUTE104 IS NULL OR REGEXP_LIKE(ATTRIBUTE104, '^[0-9]{8}$') THEN ATTRIBUTE104
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE104), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE104), 'FM99999999')
                                  ELSE ATTRIBUTE104 END,
                       ATTRIBUTE105 = CASE WHEN ATTRIBUTE105 IS NULL OR REGEXP_LIKE(ATTRIBUTE105, '^[0-9]{8}$') THEN ATTRIBUTE105
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE105), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE105), 'FM99999999')
                                  ELSE ATTRIBUTE105 END,
                       ATTRIBUTE106 = CASE WHEN ATTRIBUTE106 IS NULL OR REGEXP_LIKE(ATTRIBUTE106, '^[0-9]{8}$') THEN ATTRIBUTE106
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE106), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE106), 'FM99999999')
                                  ELSE ATTRIBUTE106 END,
                       ATTRIBUTE107 = CASE WHEN ATTRIBUTE107 IS NULL OR REGEXP_LIKE(ATTRIBUTE107, '^[0-9]{8}$') THEN ATTRIBUTE107
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE107), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE107), 'FM99999999')
                                  ELSE ATTRIBUTE107 END,
                       ATTRIBUTE108 = CASE WHEN ATTRIBUTE108 IS NULL OR REGEXP_LIKE(ATTRIBUTE108, '^[0-9]{8}$') THEN ATTRIBUTE108
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE108), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE108), 'FM99999999')
                                  ELSE ATTRIBUTE108 END,
                       ATTRIBUTE109 = CASE WHEN ATTRIBUTE109 IS NULL OR REGEXP_LIKE(ATTRIBUTE109, '^[0-9]{8}$') THEN ATTRIBUTE109
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE109), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE109), 'FM99999999')
                                  ELSE ATTRIBUTE109 END,
                       ATTRIBUTE110 = CASE WHEN ATTRIBUTE110 IS NULL OR REGEXP_LIKE(ATTRIBUTE110, '^[0-9]{8}$') THEN ATTRIBUTE110
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE110), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE110), 'FM99999999')
                                  ELSE ATTRIBUTE110 END,
                       ATTRIBUTE111 = CASE WHEN ATTRIBUTE111 IS NULL OR REGEXP_LIKE(ATTRIBUTE111, '^[0-9]{8}$') THEN ATTRIBUTE111
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE111), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE111), 'FM99999999')
                                  ELSE ATTRIBUTE111 END,
                       ATTRIBUTE112 = CASE WHEN ATTRIBUTE112 IS NULL OR REGEXP_LIKE(ATTRIBUTE112, '^[0-9]{8}$') THEN ATTRIBUTE112
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE112), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE112), 'FM99999999')
                                  ELSE ATTRIBUTE112 END,
                       ATTRIBUTE113 = CASE WHEN ATTRIBUTE113 IS NULL OR REGEXP_LIKE(ATTRIBUTE113, '^[0-9]{8}$') THEN ATTRIBUTE113
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE113), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE113), 'FM99999999')
                                  ELSE ATTRIBUTE113 END,
                       ATTRIBUTE114 = CASE WHEN ATTRIBUTE114 IS NULL OR REGEXP_LIKE(ATTRIBUTE114, '^[0-9]{8}$') THEN ATTRIBUTE114
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE114), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE114), 'FM99999999')
                                  ELSE ATTRIBUTE114 END,
                       ATTRIBUTE115 = CASE WHEN ATTRIBUTE115 IS NULL OR REGEXP_LIKE(ATTRIBUTE115, '^[0-9]{8}$') THEN ATTRIBUTE115
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE115), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE115), 'FM99999999')
                                  ELSE ATTRIBUTE115 END,
                       ATTRIBUTE116 = CASE WHEN ATTRIBUTE116 IS NULL OR REGEXP_LIKE(ATTRIBUTE116, '^[0-9]{8}$') THEN ATTRIBUTE116
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE116), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE116), 'FM99999999')
                                  ELSE ATTRIBUTE116 END,
                       ATTRIBUTE117 = CASE WHEN ATTRIBUTE117 IS NULL OR REGEXP_LIKE(ATTRIBUTE117, '^[0-9]{8}$') THEN ATTRIBUTE117
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE117), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE117), 'FM99999999')
                                  ELSE ATTRIBUTE117 END,
                       ATTRIBUTE118 = CASE WHEN ATTRIBUTE118 IS NULL OR REGEXP_LIKE(ATTRIBUTE118, '^[0-9]{8}$') THEN ATTRIBUTE118
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE118), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE118), 'FM99999999')
                                  ELSE ATTRIBUTE118 END,
                       ATTRIBUTE119 = CASE WHEN ATTRIBUTE119 IS NULL OR REGEXP_LIKE(ATTRIBUTE119, '^[0-9]{8}$') THEN ATTRIBUTE119
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE119), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE119), 'FM99999999')
                                  ELSE ATTRIBUTE119 END,
                       ATTRIBUTE120 = CASE WHEN ATTRIBUTE120 IS NULL OR REGEXP_LIKE(ATTRIBUTE120, '^[0-9]{8}$') THEN ATTRIBUTE120
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE120), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE120), 'FM99999999')
                                  ELSE ATTRIBUTE120 END,
                       ATTRIBUTE121 = CASE WHEN ATTRIBUTE121 IS NULL OR REGEXP_LIKE(ATTRIBUTE121, '^[0-9]{8}$') THEN ATTRIBUTE121
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE121), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE121), 'FM99999999')
                                  ELSE ATTRIBUTE121 END,
                       ATTRIBUTE122 = CASE WHEN ATTRIBUTE122 IS NULL OR REGEXP_LIKE(ATTRIBUTE122, '^[0-9]{8}$') THEN ATTRIBUTE122
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE122), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE122), 'FM99999999')
                                  ELSE ATTRIBUTE122 END,
                       ATTRIBUTE123 = CASE WHEN ATTRIBUTE123 IS NULL OR REGEXP_LIKE(ATTRIBUTE123, '^[0-9]{8}$') THEN ATTRIBUTE123
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE123), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE123), 'FM99999999')
                                  ELSE ATTRIBUTE123 END,
                       ATTRIBUTE124 = CASE WHEN ATTRIBUTE124 IS NULL OR REGEXP_LIKE(ATTRIBUTE124, '^[0-9]{8}$') THEN ATTRIBUTE124
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE124), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE124), 'FM99999999')
                                  ELSE ATTRIBUTE124 END,
                       ATTRIBUTE125 = CASE WHEN ATTRIBUTE125 IS NULL OR REGEXP_LIKE(ATTRIBUTE125, '^[0-9]{8}$') THEN ATTRIBUTE125
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE125), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE125), 'FM99999999')
                                  ELSE ATTRIBUTE125 END,
                       ATTRIBUTE126 = CASE WHEN ATTRIBUTE126 IS NULL OR REGEXP_LIKE(ATTRIBUTE126, '^[0-9]{8}$') THEN ATTRIBUTE126
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE126), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE126), 'FM99999999')
                                  ELSE ATTRIBUTE126 END,
                       ATTRIBUTE127 = CASE WHEN ATTRIBUTE127 IS NULL OR REGEXP_LIKE(ATTRIBUTE127, '^[0-9]{8}$') THEN ATTRIBUTE127
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE127), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE127), 'FM99999999')
                                  ELSE ATTRIBUTE127 END,
                       ATTRIBUTE128 = CASE WHEN ATTRIBUTE128 IS NULL OR REGEXP_LIKE(ATTRIBUTE128, '^[0-9]{8}$') THEN ATTRIBUTE128
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE128), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE128), 'FM99999999')
                                  ELSE ATTRIBUTE128 END,
                       ATTRIBUTE129 = CASE WHEN ATTRIBUTE129 IS NULL OR REGEXP_LIKE(ATTRIBUTE129, '^[0-9]{8}$') THEN ATTRIBUTE129
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE129), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE129), 'FM99999999')
                                  ELSE ATTRIBUTE129 END,
                       ATTRIBUTE130 = CASE WHEN ATTRIBUTE130 IS NULL OR REGEXP_LIKE(ATTRIBUTE130, '^[0-9]{8}$') THEN ATTRIBUTE130
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE130), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE130), 'FM99999999')
                                  ELSE ATTRIBUTE130 END,
                       ATTRIBUTE131 = CASE WHEN ATTRIBUTE131 IS NULL OR REGEXP_LIKE(ATTRIBUTE131, '^[0-9]{8}$') THEN ATTRIBUTE131
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE131), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE131), 'FM99999999')
                                  ELSE ATTRIBUTE131 END,
                       ATTRIBUTE132 = CASE WHEN ATTRIBUTE132 IS NULL OR REGEXP_LIKE(ATTRIBUTE132, '^[0-9]{8}$') THEN ATTRIBUTE132
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE132), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE132), 'FM99999999')
                                  ELSE ATTRIBUTE132 END,
                       ATTRIBUTE133 = CASE WHEN ATTRIBUTE133 IS NULL OR REGEXP_LIKE(ATTRIBUTE133, '^[0-9]{8}$') THEN ATTRIBUTE133
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE133), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE133), 'FM99999999')
                                  ELSE ATTRIBUTE133 END,
                       ATTRIBUTE134 = CASE WHEN ATTRIBUTE134 IS NULL OR REGEXP_LIKE(ATTRIBUTE134, '^[0-9]{8}$') THEN ATTRIBUTE134
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE134), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE134), 'FM99999999')
                                  ELSE ATTRIBUTE134 END,
                       ATTRIBUTE135 = CASE WHEN ATTRIBUTE135 IS NULL OR REGEXP_LIKE(ATTRIBUTE135, '^[0-9]{8}$') THEN ATTRIBUTE135
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE135), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE135), 'FM99999999')
                                  ELSE ATTRIBUTE135 END,
                       ATTRIBUTE136 = CASE WHEN ATTRIBUTE136 IS NULL OR REGEXP_LIKE(ATTRIBUTE136, '^[0-9]{8}$') THEN ATTRIBUTE136
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE136), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE136), 'FM99999999')
                                  ELSE ATTRIBUTE136 END,
                       ATTRIBUTE137 = CASE WHEN ATTRIBUTE137 IS NULL OR REGEXP_LIKE(ATTRIBUTE137, '^[0-9]{8}$') THEN ATTRIBUTE137
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE137), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE137), 'FM99999999')
                                  ELSE ATTRIBUTE137 END,
                       ATTRIBUTE138 = CASE WHEN ATTRIBUTE138 IS NULL OR REGEXP_LIKE(ATTRIBUTE138, '^[0-9]{8}$') THEN ATTRIBUTE138
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE138), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE138), 'FM99999999')
                                  ELSE ATTRIBUTE138 END,
                       ATTRIBUTE139 = CASE WHEN ATTRIBUTE139 IS NULL OR REGEXP_LIKE(ATTRIBUTE139, '^[0-9]{8}$') THEN ATTRIBUTE139
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE139), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE139), 'FM99999999')
                                  ELSE ATTRIBUTE139 END,
                       ATTRIBUTE140 = CASE WHEN ATTRIBUTE140 IS NULL OR REGEXP_LIKE(ATTRIBUTE140, '^[0-9]{8}$') THEN ATTRIBUTE140
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE140), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE140), 'FM99999999')
                                  ELSE ATTRIBUTE140 END,
                       ATTRIBUTE141 = CASE WHEN ATTRIBUTE141 IS NULL OR REGEXP_LIKE(ATTRIBUTE141, '^[0-9]{8}$') THEN ATTRIBUTE141
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE141), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE141), 'FM99999999')
                                  ELSE ATTRIBUTE141 END,
                       ATTRIBUTE142 = CASE WHEN ATTRIBUTE142 IS NULL OR REGEXP_LIKE(ATTRIBUTE142, '^[0-9]{8}$') THEN ATTRIBUTE142
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE142), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE142), 'FM99999999')
                                  ELSE ATTRIBUTE142 END,
                       ATTRIBUTE143 = CASE WHEN ATTRIBUTE143 IS NULL OR REGEXP_LIKE(ATTRIBUTE143, '^[0-9]{8}$') THEN ATTRIBUTE143
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE143), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE143), 'FM99999999')
                                  ELSE ATTRIBUTE143 END,
                       ATTRIBUTE144 = CASE WHEN ATTRIBUTE144 IS NULL OR REGEXP_LIKE(ATTRIBUTE144, '^[0-9]{8}$') THEN ATTRIBUTE144
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE144), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE144), 'FM99999999')
                                  ELSE ATTRIBUTE144 END,
                       ATTRIBUTE145 = CASE WHEN ATTRIBUTE145 IS NULL OR REGEXP_LIKE(ATTRIBUTE145, '^[0-9]{8}$') THEN ATTRIBUTE145
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE145), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE145), 'FM99999999')
                                  ELSE ATTRIBUTE145 END,
                       ATTRIBUTE146 = CASE WHEN ATTRIBUTE146 IS NULL OR REGEXP_LIKE(ATTRIBUTE146, '^[0-9]{8}$') THEN ATTRIBUTE146
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE146), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE146), 'FM99999999')
                                  ELSE ATTRIBUTE146 END,
                       ATTRIBUTE147 = CASE WHEN ATTRIBUTE147 IS NULL OR REGEXP_LIKE(ATTRIBUTE147, '^[0-9]{8}$') THEN ATTRIBUTE147
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE147), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE147), 'FM99999999')
                                  ELSE ATTRIBUTE147 END,
                       ATTRIBUTE148 = CASE WHEN ATTRIBUTE148 IS NULL OR REGEXP_LIKE(ATTRIBUTE148, '^[0-9]{8}$') THEN ATTRIBUTE148
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE148), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE148), 'FM99999999')
                                  ELSE ATTRIBUTE148 END,
                       ATTRIBUTE149 = CASE WHEN ATTRIBUTE149 IS NULL OR REGEXP_LIKE(ATTRIBUTE149, '^[0-9]{8}$') THEN ATTRIBUTE149
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE149), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE149), 'FM99999999')
                                  ELSE ATTRIBUTE149 END,
                       ATTRIBUTE150 = CASE WHEN ATTRIBUTE150 IS NULL OR REGEXP_LIKE(ATTRIBUTE150, '^[0-9]{8}$') THEN ATTRIBUTE150
                                  WHEN REGEXP_LIKE(UPPER(ATTRIBUTE150), '^[0-9]+(\.[0-9]+)?(E\+?[0-9]+)?$') THEN TO_CHAR(TO_NUMBER(ATTRIBUTE150), 'FM99999999')
                                  ELSE ATTRIBUTE150 END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    ATTRIBUTE1 IS NULL;
            END;

            -- [2-tier support] 다운로드 원본(주차 상단/일자 하단) 지원: 일자-tier 행(ATTR1 NULL, ATTR14=YYYYMMDD)의
            --   기간칸을 V_TITLE 행으로 복사. 1단(일자가 헤더행) 파일은 EXISTS 가드로 미동작.
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD VT
                   SET (ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150) =
                       (SELECT ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20, ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25, ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30, ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35, ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40, ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45, ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50, ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55, ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60, ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65, ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70, ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75, ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80, ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85, ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90, ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95, ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100, ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105, ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110, ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115, ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120, ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125, ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130, ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135, ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140, ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145, ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                          FROM SCM_ADM_EXCEL_UPLOAD DT
                         WHERE DT.PROGRAM_ID = V_PROGRAM_ID
                           AND DT.SHEET_NAME = V_SHEET_NAME
                           AND DT.CREATED_BY = P_CREATED_BY
                           AND TO_CHAR(DT.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                           AND DT.ATTRIBUTE1 IS NULL
                           AND (REGEXP_LIKE(DT.ATTRIBUTE14, '^[0-9]{8}$') OR REGEXP_LIKE(DT.ATTRIBUTE15, '^[0-9]{8}$'))
                           AND ROWNUM = 1)
                 WHERE VT.PROGRAM_ID = V_PROGRAM_ID
                   AND VT.SHEET_NAME = V_SHEET_NAME
                   AND VT.CREATED_BY = P_CREATED_BY
                   AND TO_CHAR(VT.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                   AND UPPER(VT.ATTRIBUTE1) = 'DIVISION*'
                   AND EXISTS (SELECT 1 FROM SCM_ADM_EXCEL_UPLOAD DT2
                                WHERE DT2.PROGRAM_ID = V_PROGRAM_ID AND DT2.SHEET_NAME = V_SHEET_NAME
                                  AND DT2.CREATED_BY = P_CREATED_BY
                                  AND TO_CHAR(DT2.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                  AND DT2.ATTRIBUTE1 IS NULL AND (REGEXP_LIKE(DT2.ATTRIBUTE14, '^[0-9]{8}$') OR REGEXP_LIKE(DT2.ATTRIBUTE15, '^[0-9]{8}$')));
            END;


            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
                V_LOG_TYPE    := '30';
                V_LOG_MESSAGE := '########## TITLE Header Line ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            /* ==========================================================================
               [E20260911-DMF0014FORM] 양식(헤더) 불일치 = 즉시 반려  (사용자 지시 2026-09-11)
                 종전에는 헤더가 달라도 그 행이 데이터로 흘러 'Invalid Division' 등
                 **엉뚱한 사유**로 반려됐다. 기대 헤더는 SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT
                 앞 13토큰(식별 컬럼) — 메타 단일 원천이라 양식이 바뀌면 자동 추종한다.
                 비교는 UPPER(TRIM) — 대소문자·앞뒤 공백만 관용한다.
               ========================================================================== */
            BEGIN
                BEGIN
                    SELECT HEADER_CONTENT INTO v_hdr_meta
                      FROM   SCM_MGR.SCM_ADM_EXCEL_COLUMNS
                     WHERE  PROGRAM_ID = V_PROGRAM_ID
                     AND    SHEET_NAME = V_SHEET_NAME
                     AND    ROWNUM     = 1;
                EXCEPTION WHEN NO_DATA_FOUND THEN v_hdr_meta := NULL;
                END;

                IF v_hdr_meta IS NOT NULL THEN
                    v_hdr_expect := NULL;
                    FOR i IN 1 .. 13 LOOP
                        v_hdr_expect := v_hdr_expect
                            || CASE WHEN i > 1 THEN '|' END
                            || UPPER(TRIM(REGEXP_SUBSTR(v_hdr_meta, '[^|]+', 1, i)));
                    END LOOP;

                    BEGIN
                        SELECT UPPER(TRIM(ATTRIBUTE1))||'|'||UPPER(TRIM(ATTRIBUTE2))||'|'||UPPER(TRIM(ATTRIBUTE3))||'|'||UPPER(TRIM(ATTRIBUTE4))||'|'||UPPER(TRIM(ATTRIBUTE5))||'|'||UPPER(TRIM(ATTRIBUTE6))||'|'||UPPER(TRIM(ATTRIBUTE7))||'|'||UPPER(TRIM(ATTRIBUTE8))||'|'||UPPER(TRIM(ATTRIBUTE9))||'|'||UPPER(TRIM(ATTRIBUTE10))||'|'||UPPER(TRIM(ATTRIBUTE11))||'|'||UPPER(TRIM(ATTRIBUTE12))||'|'||UPPER(TRIM(ATTRIBUTE13))
                          INTO v_hdr_file
                          FROM SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                         WHERE PROGRAM_ID = V_PROGRAM_ID
                         AND   SHEET_NAME = V_SHEET_NAME
                         AND   CREATED_BY = P_CREATED_BY
                         AND   TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                         AND   UPPER(TRIM(ATTRIBUTE1)) = 'DIVISION*'
                         AND   ROWNUM = 1;
                    EXCEPTION WHEN NO_DATA_FOUND THEN v_hdr_file := NULL;
                    END;

                    IF v_hdr_file IS NULL OR v_hdr_file <> v_hdr_expect THEN
                        UPDATE SCM_MGR.SCM_ADM_EXCEL_UPLOAD
                        SET    UPLOAD_STATUS_CODE = 'ERROR'
                             , MESSAGE_TEXT       = 'Invalid Excel Form.'
                        WHERE  PROGRAM_ID = V_PROGRAM_ID
                        AND    SHEET_NAME = V_SHEET_NAME
                        AND    CREATED_BY = P_CREATED_BY
                        AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                        AND    UPLOAD_STATUS_CODE = 'UPLOAD';

                        V_LOG_TYPE    := '31';
                        V_LOG_MESSAGE := '########## ERROR Invalid Excel Form ##########';
                        V_DESCRIPTION := 'expect=[' || v_hdr_expect || '] file=['
                                      || NVL(v_hdr_file, '(header row not found)') || ']';
                        D_EVENT_DATE  := SYSTIMESTAMP;
                        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                        COMMIT;
                        OPEN O_RESULT_CURSOR FOR
                        SELECT '-1' AS CODE, 'ERR_RTN: Invalid Excel Form — 업로드 양식이 현재 양식과 다릅니다. [Excel Form] 버튼으로 최신 양식을 다시 받아 작성해주세요.' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                        RETURN;
                    END IF;
                END IF;
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Duplication Key - 동일 키 행이 중복되었습니다. 중복 행을 하나로 합쳐주세요.' ELSE MESSAGE_TEXT || ' / ' || 'Duplication Key - 동일 키 행이 중복되었습니다. 중복 행을 하나로 합쳐주세요.' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    EXISTS (SELECT 1
                        FROM   (SELECT X.ATTRIBUTE1  AS COL1
                                      ,X.ATTRIBUTE2  COL2
                                      ,X.ATTRIBUTE3  COL3
                                      ,X.ATTRIBUTE4  COL4
                                      ,X.ATTRIBUTE5  COL5
                                      ,X.ATTRIBUTE6  COL6
                                      ,X.ATTRIBUTE7  COL7
                                      ,X.ATTRIBUTE8  COL8
                                      ,X.ATTRIBUTE9  COL9
                                      ,X.ATTRIBUTE10 COL10
                                --, X.ATTRIBUTE11 COL11
                                --, X.ATTRIBUTE12 COL12
                                FROM   SCM_ADM_EXCEL_UPLOAD X
                                WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                                AND    X.SHEET_NAME = V_SHEET_NAME
                                AND    X.CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    X.UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                                GROUP  BY X.ATTRIBUTE1
                                         ,X.ATTRIBUTE2
                                         ,X.ATTRIBUTE3
                                         ,X.ATTRIBUTE4
                                         ,X.ATTRIBUTE5
                                         ,X.ATTRIBUTE6
                                         ,X.ATTRIBUTE7
                                         ,X.ATTRIBUTE8
                                         ,X.ATTRIBUTE9
                                         ,X.ATTRIBUTE10
                                --, X.ATTRIBUTE11
                                --, X.ATTRIBUTE12
                                HAVING COUNT(*) > 1) T
                        WHERE  1 = 1
                        AND    T.COL1 = ATTRIBUTE1
                        AND    T.COL2 = ATTRIBUTE2
                        AND    T.COL3 = ATTRIBUTE3
                        AND    T.COL4 = ATTRIBUTE4
                        AND    T.COL5 = ATTRIBUTE5
                        AND    T.COL6 = ATTRIBUTE6
                        AND    T.COL7 = ATTRIBUTE7
                        AND    T.COL8 = ATTRIBUTE8
                        AND    T.COL9 = ATTRIBUTE9
                        AND    T.COL10 = ATTRIBUTE10
                        --AND T.COL11 = ATTRIBUTE11
                        --AND T.COL12 = ATTRIBUTE12
                        );

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '40';
                    V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;

            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
                V_LOG_TYPE    := '40';
                V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Division - 유효하지 않은 Division 입니다. [Division*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Division - 유효하지 않은 Division 입니다. [Division*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                        UNION
                        SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '50';
                    V_LOG_MESSAGE := '########## ERROR Invalid Division ##########';  /*[E20260911-DMF0014MSG]*/
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;

            END;

            BEGIN
                -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE1 =
                       (SELECT D.DIVISION_ID
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD AEU
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Measure Upload Bucket - Measure 의 업로드 버킷 설정과 맞지 않습니다. [Measure*]/기간 컬럼 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Measure Upload Bucket - Measure 의 업로드 버킷 설정과 맞지 않습니다. [Measure*]/기간 컬럼 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = AEU.ATTRIBUTE1 OR D2.DIVISION_NAME = AEU.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = AEU.ATTRIBUTE2
                        AND    D.MEASURE = AEU.ATTRIBUTE10
                        AND    D.UPLOAD_BUCKET_TYPE IN (SELECT CASE (NVL(NVL(TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE16),'[^0-9]','')) >= 8 THEN SUBSTR(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE16),'[^0-9]',''),1,8) END,'YYYYMMDD') - TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE15),'[^0-9]','')) >= 8 THEN SUBSTR(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE15),'[^0-9]',''),1,8) END,'YYYYMMDD'), TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE15),'[^0-9]','')) >= 8 THEN SUBSTR(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE15),'[^0-9]',''),1,8) END,'YYYYMMDD') - TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE14),'[^0-9]','')) >= 8 THEN SUBSTR(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE14),'[^0-9]',''),1,8) END,'YYYYMMDD')), TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE17),'[^0-9]','')) >= 8 THEN SUBSTR(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE17),'[^0-9]',''),1,8) END,'YYYYMMDD') - TO_DATE(CASE WHEN LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE16),'[^0-9]','')) >= 8 THEN SUBSTR(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE16),'[^0-9]',''),1,8) END,'YYYYMMDD')))  /* [E20260823-BUCKETNLS] 헤더 일자 = 숫자만 추출한 앞 8자리로 판정. 구식 TO_DATE(TO_CHAR(TO_NUMBER(x))) 는 NLS_NUMERIC_CHARACTERS 에 의존해(엑셀 '20260803.0' → 소수점 문자가 ','인 DB 에서 ORA-01722) 클라우드에서만 깨졌다. 날짜서식('2026-08-10')·과학표기·공백도 같은 값으로 수렴한다. 8자리 미만이면 NULL → 기존 NVL 폴백이 다음 간격을 쓴다(동작 보존). */  /* [BUCKET FIX 07-08] V_TITLE(주차라벨 'W29')는 TO_DATE 불가 → 날짜행(2Row, ATTRIBUTE1 NULL) 의 과학표기 날짜를 TO_NUMBER 정규화하여 간격 산출(월경계 정확 7=WEEKLY) */  /* [BUCKET FIX 07-06] 부분 첫주(월1일)=2~3번째 일자 간격(완전주) 우선 */
                                                                   WHEN 1 THEN
                                                                    'DAILY'
                                                                   WHEN 7 THEN
                                                                    'WEEKLY'
                                                                   ELSE
                                                                    'MONTHLY'
                                                               END
                                                        FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                        WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                        AND    Z.SHEET_NAME = V_SHEET_NAME
                                                        AND    Z.CREATED_BY = P_CREATED_BY
                                                        AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                        AND    (Z.ATTRIBUTE1 IS NULL OR UPPER(Z.ATTRIBUTE1) = 'DIVISION*') AND Z.ATTRIBUTE15 IS NOT NULL AND    LENGTH(REGEXP_REPLACE(TRIM(Z.ATTRIBUTE15),'[^0-9]','')) >= 8  /* [E20260823-BUCKETNLS] 날짜서식 헤더('2026-08-10')도 채택 — 구 정규식은 숫자문자만 허용해     클라우드에서 채택 0건 → 빈 IN 집합 → 전건 'Invalid Measure Upload Bucket' 이 됐다 */));  /* [BUCKET FIX 08-14] ⭐ 1단 헤더 지원 — **헤더행**(일자행 ATTRIBUTE1 NULL 또는 타이틀행 'Division*')만 채택한다. 데이터행까지 열면 값칸('100')이 TO_DATE 되어 ORA-01840 이 난다. 구 조건(ATTRIBUTE1 IS NULL)은 일자행만 인정해, 일자행이 없는 1단 양식에서 서브쿼리가 공집합이 되어 **전건 Invalid Measure Upload Bucket** 이 됐다. 2단 파일의 주차라벨 타이틀행('W29')은 위 숫자 정규식에서 자동 탈락하므로 종전 동작은 그대로다. */

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '60';
                    V_LOG_MESSAGE := '########## ERROR Invalid Measure Upload Bucket. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Measure Upload UOM - Measure 에 허용되지 않은 단위입니다. [Upload UOM*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Measure Upload UOM - Measure 에 허용되지 않은 단위입니다. [Upload UOM*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    D.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    D.UPLOAD_UOM = UPPER(SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11));

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '70';
                    V_LOG_MESSAGE := '########## ERROR Invalid Measure Upload UOM. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;

            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
                V_LOG_TYPE    := '70';
                V_LOG_MESSAGE := '########## Invalid Measure Upload UOM. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Sales Site - 등록되지 않은 Sales Site 입니다. [Sales Site*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Sales Site - 등록되지 않은 Sales Site 입니다. [Sales Site*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '80';
                    V_LOG_MESSAGE := '########## ERROR Invalid Scm Site. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;

            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '80';
                V_LOG_MESSAGE := '########## Invalid Scm Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Plant Site - 등록되지 않은 Plant Site 입니다. [Plant Site*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Plant Site - 등록되지 않은 Plant Site 입니다. [Plant Site*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    (ATTRIBUTE1 = '81' OR ATTRIBUTE1 = 'Automotive Battery') -- ess는 제외
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '90';
                    V_LOG_MESSAGE := '########## ERROR Invalid Plant Site. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '90';
                V_LOG_MESSAGE := '########## Invalid Plant Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customer Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.VALID_YN              = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
            v_log_type := '7';
            v_log_message := '########## Invalid Customer Project ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            IF V_DIVISION != '40' THEN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Customer Model - 등록되지 않은 Customer Model 이거나 [Project]/[Model] 이 품목 마스터(Site Item)에 없습니다. [Customer Model*]/[Project]/[Model] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Customer Model - 등록되지 않은 Customer Model 이거나 [Project]/[Model] 이 품목 마스터(Site Item)에 없습니다. [Customer Model*]/[Project]/[Model] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM, SCM_MST_DIVISION D2
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
                        AND    CM.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CM.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_MST_SITE_ITEM SI, SCM_MST_DIVISION D3
                        WHERE  SI.DIVISION_ID = D3.DIVISION_ID
                        AND    SI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12  /*[E20260915-DMF0014MSTCHK] AS-IS L453 = Project 열(구 ATTRIBUTE4)*/
                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13       /*[E20260915-DMF0014MSTCHK] AS-IS L454 = Model 열(구 ATTRIBUTE5)*/
                        AND    (D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    SI.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '100';
                    V_LOG_MESSAGE := '########## ERROR Invalid Customer Model. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END IF;

            /* [E20260915-DMF0014MSTCHK] ② Model 품목 마스터 — 저장 후 반영(PR_DM_PLN_CUST_FCST_TO_MKT_FCST)이
               품목 분류(SCM_MST_ITEM_SN)를 예외처리 없이 조회하므로(ORA-01403) 업로드 단계에서 오류 행으로 거른다.
               대상 품목 = 반영 프로시저와 동일 규칙: Customer Model 마스터 품목 → 없으면 [Model] 열. */
            IF V_DIVISION != '40' THEN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Model - 품목 마스터(Item)에 없는 Model 입니다. [Model] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Model - 품목 마스터(Item)에 없는 Model 입니다. [Model] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_ITEM_SN S
                        WHERE  S.ITEM_ID = NVL((SELECT MAX(CM.ITEM_ID)
                                                FROM   DM_MST_CUSTOMER_MODEL CM, SCM_MST_DIVISION D2
                                                WHERE  CM.DIVISION_ID = D2.DIVISION_ID
                                                AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                                                AND    CM.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                                                AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                                                AND    CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5), SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13));
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '101';
                    V_LOG_MESSAGE := '########## ERROR Invalid Model. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정 (전 검증 계속 수행 — E20260911-DMF0014MULTI)
                END IF;

                /* [E20260915-DMF0014MSTCHK] ③ Customs Handbook = LOOKUP 'DOM/EXP' (AS-IS 주석 블록의 검증 의도 복원) */
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Customs Handbook - 등록되지 않은 Customs Handbook 입니다(D/E). [Customs Handbook*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Customs Handbook - 등록되지 않은 Customs Handbook 입니다(D/E). [Customs Handbook*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.LOOKUP_TYPE = 'DOM/EXP'
                        AND    L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '102';
                    V_LOG_MESSAGE := '########## ERROR Invalid Customs Handbook. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정 (전 검증 계속 수행 — E20260911-DMF0014MULTI)
                END IF;
            END IF;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
                V_LOG_TYPE    := '100';
                V_LOG_MESSAGE := '########## Invalid Customer Model ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Incoterms - 등록되지 않은 Incoterms 입니다. [Incoterms*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Incoterms - 등록되지 않은 Incoterms 입니다. [Incoterms*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
                        AND    L.LOOKUP_TYPE = 'INCOTERMS'
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '110';
                    V_LOG_MESSAGE := '########## ERROR Invalid Incoterms. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '110';
                V_LOG_MESSAGE := '########## Invalid Incoterms. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid FCST Type - 등록되지 않은 FCST Type 입니다. [FCST Type*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid FCST Type - 등록되지 않은 FCST Type 입니다. [FCST Type*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DESCRIPTION = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7);
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '120';
                    V_LOG_MESSAGE := '########## ERROR Invalid Sales Type. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            BEGIN
                -- validation이 끝났으니 code로 update
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE7 =
                       (SELECT D.SEGMENT1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    D.SEGMENT2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '120';
                V_LOG_MESSAGE := '########## Invalid Sales Type. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customs Handbook'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
                            AND    L.LOOKUP_TYPE = 'DOM/EXP'
                            AND    L.VALID_YN    = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '12';
            v_log_message := '########## Invalid DOM/EXP. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Measure Group - 등록되지 않은 Measure Group 입니다. [Measure Group*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Measure Group - 등록되지 않은 Measure Group 입니다. [Measure Group*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9
                        AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
                        AND    L.SEGMENT1 = 'CUST_FCST'
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '130';
                    V_LOG_MESSAGE := '########## ERROR Invalid Measure Group. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            --20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '130';
                V_LOG_MESSAGE := '########## Invalid Invalid Measure Group. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            --문자열 체크

            UPDATE SCM_ADM_EXCEL_UPLOAD A
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                  ,MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Quantity - 수량 칸에 숫자가 아닌 값이 있습니다. 문자/기호를 지우고 숫자만 입력해주세요.' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Quantity - 수량 칸에 숫자가 아닌 값이 있습니다. 문자/기호를 지우고 숫자만 입력해주세요.' END
            WHERE  A.PROGRAM_ID = V_PROGRAM_ID
            AND    A.SHEET_NAME = V_SHEET_NAME
            AND    A.CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    A.UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
            AND    EXISTS (
                     SELECT 1
                     FROM  (SELECT UPLOAD_ID
                                  ,SUM(CASE WHEN REGEXP_LIKE(VALUE, '^-?[0-9]*\.?[0-9]+$') THEN 0 ELSE 1 END) PRICE
                            FROM  (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                   WHERE  PROGRAM_ID = V_PROGRAM_ID
                                   AND    SHEET_NAME = V_SHEET_NAME
                                   AND    CREATED_BY = P_CREATED_BY
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                   AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR'))
                            UNPIVOT (VALUE FOR COLUMN_NAME IN (ATTRIBUTE14, ATTRIBUTE15, ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200))
                            WHERE  LTRIM(RTRIM(VALUE)) IS NOT NULL
                            AND    VALUE != '0'
                            AND    VALUE IS NOT NULL
                            GROUP BY UPLOAD_ID) B
                     WHERE  B.UPLOAD_ID = A.UPLOAD_ID
                     AND    B.PRICE > 0
                   );

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '140';
                    V_LOG_MESSAGE := '########## ERROR This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;

            --소수점 체크
            BEGIN

            UPDATE SCM_ADM_EXCEL_UPLOAD A
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                  ,MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Quantity - 수량 칸에 숫자가 아닌 값이 있습니다. 문자/기호를 지우고 숫자만 입력해주세요.' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Quantity - 수량 칸에 숫자가 아닌 값이 있습니다. 문자/기호를 지우고 숫자만 입력해주세요.' END
            WHERE  A.PROGRAM_ID = V_PROGRAM_ID
            AND    A.SHEET_NAME = V_SHEET_NAME
            AND    A.CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(A.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    A.UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
            AND    EXISTS (
                     SELECT 1
                     FROM  (SELECT UPLOAD_ID
                                  ,SUM(CASE WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN 1 ELSE 0 END) PRICE
                            FROM  (SELECT UPLOAD_ID, ATTRIBUTE14, ATTRIBUTE15
                                         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200
                                   FROM   SCM_ADM_EXCEL_UPLOAD
                                   WHERE  PROGRAM_ID = V_PROGRAM_ID
                                   AND    SHEET_NAME = V_SHEET_NAME
                                   AND    CREATED_BY = P_CREATED_BY
                                   AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                   AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR'))
                            UNPIVOT (VALUE FOR COLUMN_NAME IN (ATTRIBUTE14, ATTRIBUTE15
                                         , ATTRIBUTE16, ATTRIBUTE17, ATTRIBUTE18, ATTRIBUTE19, ATTRIBUTE20
                                         , ATTRIBUTE21, ATTRIBUTE22, ATTRIBUTE23, ATTRIBUTE24, ATTRIBUTE25
                                         , ATTRIBUTE26, ATTRIBUTE27, ATTRIBUTE28, ATTRIBUTE29, ATTRIBUTE30
                                         , ATTRIBUTE31, ATTRIBUTE32, ATTRIBUTE33, ATTRIBUTE34, ATTRIBUTE35
                                         , ATTRIBUTE36, ATTRIBUTE37, ATTRIBUTE38, ATTRIBUTE39, ATTRIBUTE40
                                         , ATTRIBUTE41, ATTRIBUTE42, ATTRIBUTE43, ATTRIBUTE44, ATTRIBUTE45
                                         , ATTRIBUTE46, ATTRIBUTE47, ATTRIBUTE48, ATTRIBUTE49, ATTRIBUTE50
                                         , ATTRIBUTE51, ATTRIBUTE52, ATTRIBUTE53, ATTRIBUTE54, ATTRIBUTE55
                                         , ATTRIBUTE56, ATTRIBUTE57, ATTRIBUTE58, ATTRIBUTE59, ATTRIBUTE60
                                         , ATTRIBUTE61, ATTRIBUTE62, ATTRIBUTE63, ATTRIBUTE64, ATTRIBUTE65
                                         , ATTRIBUTE66, ATTRIBUTE67, ATTRIBUTE68, ATTRIBUTE69, ATTRIBUTE70
                                         , ATTRIBUTE71, ATTRIBUTE72, ATTRIBUTE73, ATTRIBUTE74, ATTRIBUTE75
                                         , ATTRIBUTE76, ATTRIBUTE77, ATTRIBUTE78, ATTRIBUTE79, ATTRIBUTE80
                                         , ATTRIBUTE81, ATTRIBUTE82, ATTRIBUTE83, ATTRIBUTE84, ATTRIBUTE85
                                         , ATTRIBUTE86, ATTRIBUTE87, ATTRIBUTE88, ATTRIBUTE89, ATTRIBUTE90
                                         , ATTRIBUTE91, ATTRIBUTE92, ATTRIBUTE93, ATTRIBUTE94, ATTRIBUTE95
                                         , ATTRIBUTE96, ATTRIBUTE97, ATTRIBUTE98, ATTRIBUTE99, ATTRIBUTE100
                                         , ATTRIBUTE101, ATTRIBUTE102, ATTRIBUTE103, ATTRIBUTE104, ATTRIBUTE105
                                         , ATTRIBUTE106, ATTRIBUTE107, ATTRIBUTE108, ATTRIBUTE109, ATTRIBUTE110
                                         , ATTRIBUTE111, ATTRIBUTE112, ATTRIBUTE113, ATTRIBUTE114, ATTRIBUTE115
                                         , ATTRIBUTE116, ATTRIBUTE117, ATTRIBUTE118, ATTRIBUTE119, ATTRIBUTE120
                                         , ATTRIBUTE121, ATTRIBUTE122, ATTRIBUTE123, ATTRIBUTE124, ATTRIBUTE125
                                         , ATTRIBUTE126, ATTRIBUTE127, ATTRIBUTE128, ATTRIBUTE129, ATTRIBUTE130
                                         , ATTRIBUTE131, ATTRIBUTE132, ATTRIBUTE133, ATTRIBUTE134, ATTRIBUTE135
                                         , ATTRIBUTE136, ATTRIBUTE137, ATTRIBUTE138, ATTRIBUTE139, ATTRIBUTE140
                                         , ATTRIBUTE141, ATTRIBUTE142, ATTRIBUTE143, ATTRIBUTE144, ATTRIBUTE145
                                         , ATTRIBUTE146, ATTRIBUTE147, ATTRIBUTE148, ATTRIBUTE149, ATTRIBUTE150
                                         , ATTRIBUTE151, ATTRIBUTE152, ATTRIBUTE153, ATTRIBUTE154, ATTRIBUTE155
                                         , ATTRIBUTE156, ATTRIBUTE157, ATTRIBUTE158, ATTRIBUTE159, ATTRIBUTE160
                                         , ATTRIBUTE161, ATTRIBUTE162, ATTRIBUTE163, ATTRIBUTE164, ATTRIBUTE165
                                         , ATTRIBUTE166, ATTRIBUTE167, ATTRIBUTE168, ATTRIBUTE169, ATTRIBUTE170
                                         , ATTRIBUTE171, ATTRIBUTE172, ATTRIBUTE173, ATTRIBUTE174, ATTRIBUTE175
                                         , ATTRIBUTE176, ATTRIBUTE177, ATTRIBUTE178, ATTRIBUTE179, ATTRIBUTE180
                                         , ATTRIBUTE181, ATTRIBUTE182, ATTRIBUTE183, ATTRIBUTE184, ATTRIBUTE185
                                         , ATTRIBUTE186, ATTRIBUTE187, ATTRIBUTE188, ATTRIBUTE189, ATTRIBUTE190
                                         , ATTRIBUTE191, ATTRIBUTE192, ATTRIBUTE193, ATTRIBUTE194, ATTRIBUTE195
                                         , ATTRIBUTE196, ATTRIBUTE197, ATTRIBUTE198, ATTRIBUTE199, ATTRIBUTE200))
                            WHERE  LTRIM(RTRIM(VALUE)) IS NOT NULL
                            AND    VALUE != '0'
                            AND    VALUE IS NOT NULL
                            GROUP BY UPLOAD_ID) B
                     WHERE  B.UPLOAD_ID = A.UPLOAD_ID
                     AND    B.PRICE > 0
                   );

                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '150';
                    V_LOG_MESSAGE := '########## ERROR This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '150';
                V_LOG_MESSAGE := '########## This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Upload UOM - 등록되지 않은 Upload UOM 입니다. [Upload UOM*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Upload UOM - 등록되지 않은 Upload UOM 입니다. [Upload UOM*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = UPPER(SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11)
                        AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '160';
                    V_LOG_MESSAGE := '########## ERROR Invalid Upload UOM. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '160';
                V_LOG_MESSAGE := '########## Invalid Upload UOM. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            -- Upload UOM by Model
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = CASE WHEN MESSAGE_TEXT IS NULL THEN 'Invalid Upload UOM (Customer FCST) - 허용되지 않은 단위입니다. [Upload UOM*] 확인' ELSE MESSAGE_TEXT || ' / ' || 'Invalid Upload UOM (Customer FCST) - 허용되지 않은 단위입니다. [Upload UOM*] 확인' END
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST CF, SCM_MST_DIVISION D2
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
                        AND    CF.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CF.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CF.VALID_YN = 'Y');
                v_err_cnt := SQL%ROWCOUNT;
                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '170';
                    V_LOG_MESSAGE := '########## ERROR Invalid Upload UOM Customer FCST. ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                    COMMIT;   -- ERROR 상태 확정
                    -- [E20260911-DMF0014MULTI] 즉시반환 제거 — 전 검증을 끝까지 수행하고 마지막에 사유를 모아 반환한다.
                    --   (행별 ERROR/MESSAGE_TEXT 마킹은 위에서 이미 끝났다. 적재 게이트 V_COUNT=0 은 그대로라 안전)
                END IF;

            END;

            /* [E20260818-GRAYWEEK → E20260823-GRAYZERO] 회색(입력불가) 주차 정책 전환 ─────
               종전: 회색 주차에 값이 있으면 스테이징 행을 ERROR 로 바꾸고 업로드 전체를 반려했다.
               변경(사용자 지시 2026-08-23): **반려하지 않는다.** 그 칸만 0 으로 적재하고
                 나머지 칸은 정상값 그대로 넣는다 — 적재부 INSTEAD 값 CASE 참조.
               여기서는 몇 칸이 0 처리 대상인지만 세어 로그(175)에 남긴다. 상태 변경·RETURN 없음. */
            BEGIN
                SELECT COUNT(*)
                INTO   v_err_cnt
                FROM   SCM_ADM_EXCEL_UPLOAD AEU
                WHERE  AEU.PROGRAM_ID = V_PROGRAM_ID
                AND    AEU.SHEET_NAME = V_SHEET_NAME
                AND    AEU.CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(AEU.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    AEU.UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    EXISTS (
                        SELECT 1
                        FROM   (SELECT CASE W.IDX
                                         WHEN 14 THEN H.ATTRIBUTE14 WHEN 15 THEN H.ATTRIBUTE15
                                         WHEN 16 THEN H.ATTRIBUTE16 WHEN 17 THEN H.ATTRIBUTE17
                                         ELSE H.ATTRIBUTE18 END AS WK_RAW
                                      ,W.IDX
                                FROM   SCM_ADM_EXCEL_UPLOAD H
                                      ,(SELECT 14 IDX FROM DUAL UNION ALL SELECT 15 FROM DUAL
                                        UNION ALL SELECT 16 FROM DUAL UNION ALL SELECT 17 FROM DUAL
                                        UNION ALL SELECT 18 FROM DUAL) W
                                WHERE  H.PROGRAM_ID = V_PROGRAM_ID
                                AND    H.SHEET_NAME = V_SHEET_NAME
                                AND    H.CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(H.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    (H.ATTRIBUTE1 IS NULL OR UPPER(H.ATTRIBUTE1) = 'DIVISION*')) WK
                        WHERE  WK.WK_RAW IS NOT NULL
                        AND    REGEXP_LIKE(WK.WK_RAW, '^[0-9.eE+-]+$')
                        /* 값이 입력된 주차만 대상 (빈칸은 통과) */
                        AND    (CASE WK.IDX
                                  WHEN 14 THEN AEU.ATTRIBUTE14 WHEN 15 THEN AEU.ATTRIBUTE15
                                  WHEN 16 THEN AEU.ATTRIBUTE16 WHEN 17 THEN AEU.ATTRIBUTE17
                                  ELSE AEU.ATTRIBUTE18 END) IS NOT NULL
                        AND    NOT EXISTS (
                                SELECT 1
                                FROM   DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                                WHERE  M.VALID_YN = 'Y'
                                AND    M.DIVISION_ID = MD.DIVISION_ID
                                AND    (MD.DIVISION_ID = AEU.ATTRIBUTE1 OR MD.DIVISION_NAME = AEU.ATTRIBUTE1)
                                AND    M.SCM_SITE_ID = AEU.ATTRIBUTE2
                                AND    M.MEASURE     = AEU.ATTRIBUTE10
                                AND    M.SUMMARY_BUCKET_VALUE =
                                       TO_CHAR(TO_NUMBER(WK.WK_RAW), 'FM99999999')));

                IF v_err_cnt > 0 THEN
                    V_LOG_TYPE    := '175';
                    V_LOG_MESSAGE := '########## GRAYZERO: non-editable week value -> 0 (rows=' || v_err_cnt || ') ##########';
                    V_DESCRIPTION := NULL;
                    D_EVENT_DATE  := SYSTIMESTAMP;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                END IF;
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '170';
                V_LOG_MESSAGE := '########## Invalid Upload UOM Costpmer FCST. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.VALID_YN              = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '16';
            v_log_message := '########## Invalid Project. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Model.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13
                            AND    CM.VALID_YN              = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '17';
            v_log_message := '########## Invalid Model. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SUCCESS'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD';
            END;

            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '180';
                V_LOG_MESSAGE := '########## SUCCESS ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;

        END IF;

        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '190';
            V_LOG_MESSAGE := '########## INSERT INTO DATA START ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
        END;

        --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
        --//======================================================================================
        SELECT COUNT(1)
        INTO   V_COUNT
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    T.UPLOAD_STATUS_CODE = 'ERROR';

        DBMS_OUTPUT.PUT_LINE(V_COUNT); --20240604 SM

        -- Update Mode and No Errors
        d_ins_from := SYSDATE; /* ⭐ 적재 시작 시각 고정 — 아래 실재 재확인의 하한 */
            -- ==========================================================================
            -- [E20260911-DMF0014ACC] 검증 결과 반환 — 문구는 **원래대로** (사용자 지시 원복).
            --   행별 사유는 SCM_ADM_EXCEL_UPLOAD.MESSAGE_TEXT 에 ' / ' 로 **전부 누적**되므로
            --   Error Detail 에서 그 행의 오류 항목을 한 번에 확인한다.
            --   전제: 각 검증의 즉시 RETURN 제거 + 검증 대상에 기존 ERROR 행 포함
            --         (UPLOAD_STATUS_CODE IN ('UPLOAD','ERROR')) — 둘 다 있어야 누적이 성립한다.
            -- ==========================================================================
            IF V_COUNT > 0 THEN
                V_LOG_TYPE    := '90';
                V_LOG_MESSAGE := '########## ERROR Validation Check ##########';
                V_DESCRIPTION := 'error rows=' || TO_CHAR(V_COUNT);
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                COMMIT;
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, 'ERR_RTN: - Validation Check' AS MSG, V_LOG_TYPE||','||V_LOG_MESSAGE AS EVENT FROM DUAL;
                RETURN;
            END IF;
            
            IF P_MODE > 0 AND V_COUNT = 0 THEN  -- [DMF0014 2-Step] mode=0=검증/분류만(적재 skip) · mode>0=적재 (P_MODE>0 게이트 복원 2026-07-10)
            BEGIN
                V_START_YYYYMMDD := NULL;
                V_END_YYYYMMDD   := NULL;
            END;

            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '200';
                V_LOG_MESSAGE := '########## DELETE FROM DATE START ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;

            DBMS_OUTPUT.PUT_LINE('TTTTTTT1'); --20240604 SM

            BEGIN
                SELECT D.MIN_YYYYMMDD, D.MAX_YYYYMMDD
                INTO   V_START_YYYYMMDD, V_END_YYYYMMDD
                FROM   (SELECT MIN(YYYYMMDD) MIN_YYYYMMDD, MAX(YYYYMMDD) MAX_YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN( --ATTRIBUTE12, ATTRIBUTE13,   20240605 SM임시조치
                                                                                                             ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X
                        WHERE  X.YYYYMMDD IS NOT NULL) D;
            END;

            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '210';
                V_LOG_MESSAGE := '########## DELETE FROM DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;

            -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
            BEGIN

                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '220';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
                DELETE FROM DM_PLN_CUSTOMER_PSI
                WHERE  1 = 1
                AND    MEASURE_GROUP = 'CUST_FCST'
                      -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
                AND    (SELECT COUNT(1)
                        FROM   SCM_ADM_EXCEL_UPLOAD T
                        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                        AND    T.SHEET_NAME = V_SHEET_NAME
                        AND    T.CREATED_BY = P_CREATED_BY
                        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                        AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
                        AND    DM_PLN_CUSTOMER_PSI.DIVISION_ID = T.ATTRIBUTE1
                        AND    DM_PLN_CUSTOMER_PSI.SCM_SITE_ID = T.ATTRIBUTE2
                        AND    DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID = T.ATTRIBUTE3
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE = T.ATTRIBUTE4
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL = T.ATTRIBUTE5
                        AND    DM_PLN_CUSTOMER_PSI.INCOTERMS = T.ATTRIBUTE6
                        AND    DM_PLN_CUSTOMER_PSI.FCST_TYPE = T.ATTRIBUTE7
                        AND    DM_PLN_CUSTOMER_PSI.DOM_EXP = T.ATTRIBUTE8
                        AND    DM_PLN_CUSTOMER_PSI.MEASURE = T.ATTRIBUTE10) > 0
                AND    YYYYMMDD BETWEEN V_START_YYYYMMDD AND V_END_YYYYMMDD;

                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '230';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
            DBMS_OUTPUT.PUT_LINE('230');

            -- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
            UPDATE SCM_ADM_EXCEL_UPLOAD AA
            SET    ATTRIBUTE10 =
                   (SELECT BB.MEASURE
                    FROM   (SELECT DISTINCT A.DIVISION_ID, B.DIVISION_NAME, A.SCM_SITE_ID, A.VALID_YN, A.MEASURE, A.UPLOAD_UOM, A.UPLOAD_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST A
                            INNER  JOIN SCM_MST_DIVISION B
                            ON     A.VALID_YN = 'Y'
                            AND    A.DIVISION_ID = B.DIVISION_ID) BB
                    WHERE  (BB.DIVISION_ID = AA.ATTRIBUTE1 OR BB.DIVISION_NAME = AA.ATTRIBUTE1)
                    AND    BB.SCM_SITE_ID = AA.ATTRIBUTE2
                    AND    BB.MEASURE = AA.ATTRIBUTE10
                    AND    BB.UPLOAD_UOM = UPPER(AA.ATTRIBUTE11)
                    AND    BB.UPLOAD_BUCKET_TYPE IN (

                                                     SELECT CASE (NVL(TO_DATE(Z.ATTRIBUTE16, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD'), TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD')))  /* [BUCKET FIX 07-06] 부분 첫주(월1일)=2~3번째 일자 간격(완전주) 우선 */
                                                                 WHEN 1 THEN
                                                                  'DAILY'
                                                                 WHEN 7 THEN
                                                                  'WEEKLY'
                                                                 ELSE
                                                                  'MONTHLY'
                                                             END
                                                     FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                     WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                     AND    Z.SHEET_NAME = V_SHEET_NAME
                                                     AND    Z.CREATED_BY = P_CREATED_BY
                                                     AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                     AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE')
                    AND    ROWNUM = 1)
            WHERE  AA.PROGRAM_ID = V_PROGRAM_ID
            AND    AA.SHEET_NAME = V_SHEET_NAME
            AND    AA.CREATED_BY = P_CREATED_BY
            AND    AA.UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    TO_CHAR(AA.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE;

            INSERT INTO DM_PLN_CUSTOMER_PSI
                (DIVISION_ID
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,CUSTOMER_PROJECT_CODE
                ,CUSTOMER_MODEL
                ,INCOTERMS
                ,FCST_TYPE
                ,DOM_EXP
                ,MEASURE_GROUP
                ,MEASURE
                ,UPLOAD_UOM
                ,PROJECT_CODE
                ,ITEM_ID
                ,YYYYMMDD
                ,QTY
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,BATCH_RESULT)
                SELECT V.ATTRIBUTE1
                      ,V.ATTRIBUTE2
                      ,V.ATTRIBUTE3
                      ,V.ATTRIBUTE4
                      ,V.ATTRIBUTE5
                      ,V.ATTRIBUTE6
                      ,V.ATTRIBUTE7
                      ,V.ATTRIBUTE8
                      ,V.ATTRIBUTE9
                      ,V.ATTRIBUTE10
                      ,UPPER(V.ATTRIBUTE11)
                      ,V.ATTRIBUTE12
                      ,V.ATTRIBUTE13
                      ,C.YYYYMMDD
                      /* [E20260823-GRAYZERO] Customer Fcst Master 가 VALID_YN='Y' 로 열어둔 주차가
                         아니면(화면 회색 구간) 사용자가 값을 넣었어도 **0 으로 적재**한다.
                         판정식은 위 GRAYZERO 집계와 동일한 술어 — 기준이 갈라지면 화면 색과 적재가 어긋난다. */
                      ,CASE WHEN EXISTS (
                                SELECT 1
                                FROM   DM_MST_CUSTOMER_FCST M, SCM_MST_DIVISION MD
                                WHERE  M.VALID_YN = 'Y'
                                AND    M.DIVISION_ID = MD.DIVISION_ID
                                AND    (MD.DIVISION_ID = V.ATTRIBUTE1 OR MD.DIVISION_NAME = V.ATTRIBUTE1)
                                AND    M.SCM_SITE_ID = V.ATTRIBUTE2
                                AND    M.MEASURE     = V.ATTRIBUTE10
                                /* 헤더 셀이 엑셀 숫자서식으로 '20260803.0' 처럼 들어오는 경우까지 맞춘다
                                   — 종전 검증(TO_CHAR(TO_NUMBER(..),'FM99999999'))과 같은 정규화. */
                                AND    M.SUMMARY_BUCKET_VALUE =
                                       CASE WHEN REGEXP_LIKE(TRIM(C.YYYYMMDD), '^[0-9.eE+-]+$')
                                            THEN TO_CHAR(TO_NUMBER(TRIM(C.YYYYMMDD)), 'FM99999999')
                                            ELSE TRIM(C.YYYYMMDD) END)
                            THEN TO_NUMBER(V.VALUE) ELSE 0 END
                      ,P_CREATED_BY
                      ,SYSDATE--TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,P_CREATED_BY
                      ,SYSDATE--TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,'UI'
                FROM   (SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                      -- modified by ytchoi 180305
                                      -- AND    CREATION_DATE = v_creation_date
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X) C
                      ,(SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,VALUE
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'SUCCESS') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                         ,ATTRIBUTE15
                                                                                                         ,ATTRIBUTE16
                                                                                                         ,ATTRIBUTE17
                                                                                                         ,ATTRIBUTE18
                                                                                                         ,ATTRIBUTE19
                                                                                                         ,ATTRIBUTE20
                                                                                                         ,ATTRIBUTE21
                                                                                                         ,ATTRIBUTE22
                                                                                                         ,ATTRIBUTE23
                                                                                                         ,ATTRIBUTE24
                                                                                                         ,ATTRIBUTE25
                                                                                                         ,ATTRIBUTE26
                                                                                                         ,ATTRIBUTE27
                                                                                                         ,ATTRIBUTE28
                                                                                                         ,ATTRIBUTE29
                                                                                                         ,ATTRIBUTE30
                                                                                                         ,ATTRIBUTE31
                                                                                                         ,ATTRIBUTE32
                                                                                                         ,ATTRIBUTE33
                                                                                                         ,ATTRIBUTE34
                                                                                                         ,ATTRIBUTE35
                                                                                                         ,ATTRIBUTE36
                                                                                                         ,ATTRIBUTE37
                                                                                                         ,ATTRIBUTE38
                                                                                                         ,ATTRIBUTE39
                                                                                                         ,ATTRIBUTE40
                                                                                                         ,ATTRIBUTE41
                                                                                                         ,ATTRIBUTE42
                                                                                                         ,ATTRIBUTE43
                                                                                                         ,ATTRIBUTE44
                                                                                                         ,ATTRIBUTE45
                                                                                                         ,ATTRIBUTE46
                                                                                                         ,ATTRIBUTE47
                                                                                                         ,ATTRIBUTE48
                                                                                                         ,ATTRIBUTE49
                                                                                                         ,ATTRIBUTE50
                                                                                                         ,ATTRIBUTE51
                                                                                                         ,ATTRIBUTE52
                                                                                                         ,ATTRIBUTE53
                                                                                                         ,ATTRIBUTE54
                                                                                                         ,ATTRIBUTE55
                                                                                                         ,ATTRIBUTE56
                                                                                                         ,ATTRIBUTE57
                                                                                                         ,ATTRIBUTE58
                                                                                                         ,ATTRIBUTE59
                                                                                                         ,ATTRIBUTE60
                                                                                                         ,ATTRIBUTE61
                                                                                                         ,ATTRIBUTE62
                                                                                                         ,ATTRIBUTE63
                                                                                                         ,ATTRIBUTE64
                                                                                                         ,ATTRIBUTE65
                                                                                                         ,ATTRIBUTE66
                                                                                                         ,ATTRIBUTE67
                                                                                                         ,ATTRIBUTE68
                                                                                                         ,ATTRIBUTE69
                                                                                                         ,ATTRIBUTE70
                                                                                                         ,ATTRIBUTE71
                                                                                                         ,ATTRIBUTE72
                                                                                                         ,ATTRIBUTE73
                                                                                                         ,ATTRIBUTE74
                                                                                                         ,ATTRIBUTE75
                                                                                                         ,ATTRIBUTE76
                                                                                                         ,ATTRIBUTE77
                                                                                                         ,ATTRIBUTE78
                                                                                                         ,ATTRIBUTE79
                                                                                                         ,ATTRIBUTE80
                                                                                                         ,ATTRIBUTE81
                                                                                                         ,ATTRIBUTE82
                                                                                                         ,ATTRIBUTE83
                                                                                                         ,ATTRIBUTE84
                                                                                                         ,ATTRIBUTE85
                                                                                                         ,ATTRIBUTE86
                                                                                                         ,ATTRIBUTE87
                                                                                                         ,ATTRIBUTE88
                                                                                                         ,ATTRIBUTE89
                                                                                                         ,ATTRIBUTE90
                                                                                                         ,ATTRIBUTE91
                                                                                                         ,ATTRIBUTE92
                                                                                                         ,ATTRIBUTE93
                                                                                                         ,ATTRIBUTE94
                                                                                                         ,ATTRIBUTE95
                                                                                                         ,ATTRIBUTE96
                                                                                                         ,ATTRIBUTE97
                                                                                                         ,ATTRIBUTE98
                                                                                                         ,ATTRIBUTE99
                                                                                                         ,ATTRIBUTE100
                                                                                                         ,ATTRIBUTE101
                                                                                                         ,ATTRIBUTE102
                                                                                                         ,ATTRIBUTE103
                                                                                                         ,ATTRIBUTE104
                                                                                                         ,ATTRIBUTE105
                                                                                                         ,ATTRIBUTE106
                                                                                                         ,ATTRIBUTE107
                                                                                                         ,ATTRIBUTE108
                                                                                                         ,ATTRIBUTE109
                                                                                                         ,ATTRIBUTE110
                                                                                                         ,ATTRIBUTE111
                                                                                                         ,ATTRIBUTE112
                                                                                                         ,ATTRIBUTE113
                                                                                                         ,ATTRIBUTE114
                                                                                                         ,ATTRIBUTE115
                                                                                                         ,ATTRIBUTE116
                                                                                                         ,ATTRIBUTE117
                                                                                                         ,ATTRIBUTE118
                                                                                                         ,ATTRIBUTE119
                                                                                                         ,ATTRIBUTE120
                                                                                                         ,ATTRIBUTE121
                                                                                                         ,ATTRIBUTE122
                                                                                                         ,ATTRIBUTE123
                                                                                                         ,ATTRIBUTE124
                                                                                                         ,ATTRIBUTE125
                                                                                                         ,ATTRIBUTE126
                                                                                                         ,ATTRIBUTE127
                                                                                                         ,ATTRIBUTE128
                                                                                                         ,ATTRIBUTE129
                                                                                                         ,ATTRIBUTE130
                                                                                                         ,ATTRIBUTE131
                                                                                                         ,ATTRIBUTE132
                                                                                                         ,ATTRIBUTE133
                                                                                                         ,ATTRIBUTE134
                                                                                                         ,ATTRIBUTE135
                                                                                                         ,ATTRIBUTE136
                                                                                                         ,ATTRIBUTE137
                                                                                                         ,ATTRIBUTE138
                                                                                                         ,ATTRIBUTE139
                                                                                                         ,ATTRIBUTE140
                                                                                                         ,ATTRIBUTE141
                                                                                                         ,ATTRIBUTE142
                                                                                                         ,ATTRIBUTE143
                                                                                                         ,ATTRIBUTE144
                                                                                                         ,ATTRIBUTE145
                                                                                                         ,ATTRIBUTE146
                                                                                                         ,ATTRIBUTE147
                                                                                                         ,ATTRIBUTE148
                                                                                                         ,ATTRIBUTE149
                                                                                                         ,ATTRIBUTE150
                                                                                                         ,ATTRIBUTE151
                                                                                                         ,ATTRIBUTE152
                                                                                                         ,ATTRIBUTE153
                                                                                                         ,ATTRIBUTE154
                                                                                                         ,ATTRIBUTE155
                                                                                                         ,ATTRIBUTE156
                                                                                                         ,ATTRIBUTE157
                                                                                                         ,ATTRIBUTE158
                                                                                                         ,ATTRIBUTE159
                                                                                                         ,ATTRIBUTE160
                                                                                                         ,ATTRIBUTE161
                                                                                                         ,ATTRIBUTE162
                                                                                                         ,ATTRIBUTE163
                                                                                                         ,ATTRIBUTE164
                                                                                                         ,ATTRIBUTE165
                                                                                                         ,ATTRIBUTE166
                                                                                                         ,ATTRIBUTE167
                                                                                                         ,ATTRIBUTE168
                                                                                                         ,ATTRIBUTE169
                                                                                                         ,ATTRIBUTE170
                                                                                                         ,ATTRIBUTE171
                                                                                                         ,ATTRIBUTE172
                                                                                                         ,ATTRIBUTE173
                                                                                                         ,ATTRIBUTE174
                                                                                                         ,ATTRIBUTE175
                                                                                                         ,ATTRIBUTE176
                                                                                                         ,ATTRIBUTE177
                                                                                                         ,ATTRIBUTE178
                                                                                                         ,ATTRIBUTE179
                                                                                                         ,ATTRIBUTE180
                                                                                                         ,ATTRIBUTE181
                                                                                                         ,ATTRIBUTE182
                                                                                                         ,ATTRIBUTE183
                                                                                                         ,ATTRIBUTE184
                                                                                                         ,ATTRIBUTE185
                                                                                                         ,ATTRIBUTE186
                                                                                                         ,ATTRIBUTE187
                                                                                                         ,ATTRIBUTE188
                                                                                                         ,ATTRIBUTE189
                                                                                                         ,ATTRIBUTE190
                                                                                                         ,ATTRIBUTE191
                                                                                                         ,ATTRIBUTE192
                                                                                                         ,ATTRIBUTE193
                                                                                                         ,ATTRIBUTE194
                                                                                                         ,ATTRIBUTE195
                                                                                                         ,ATTRIBUTE196
                                                                                                         ,ATTRIBUTE197
                                                                                                         ,ATTRIBUTE198
                                                                                                         ,ATTRIBUTE199
                                                                                                         ,ATTRIBUTE200)) X) V
                WHERE  1 = 1
                AND    C.COLUMN_NAME = V.COLUMN_NAME
                AND    C.YYYYMMDD IS NOT NULL
                AND    V.VALUE IS NOT NULL;

                v_ins_cnt := SQL%ROWCOUNT; /* ⭐ [허위성공 차단 ①] 0행이면 조인/필터가 무너진 것 */

            DBMS_OUTPUT.PUT_LINE('240');
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '240';
            V_LOG_MESSAGE := '########## INSERT INTO DM_PLN_CUSTOMER_PSI DATE END ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
            IF (V_DIVISION = '40') THEN
                PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40('40');
            ELSE
                DBMS_OUTPUT.PUT_LINE('20240605-');
                IF to_char(SYSDATE,'yyyymmdd') >= '20260412' THEN -- poc 테스트 위함.
                PR_DM_PLN_CUST_FCST_TO_MKT_FCST;
                END IF;
            END IF;

            COMMIT;
            -- END TRY

            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## INSERT INTO DATA END ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------

        END IF;
        COMMIT;
        /* ⭐ [허위성공 차단 ②] 적재 모드인데 원장에 남은 게 없으면 성공으로 보고하지 않는다.
           v_ins_cnt 만으로는 부족하다 — 하위 프로시저가 ROLLBACK 하면 행은 사라져도 이 변수는
           롤백 이전 값을 그대로 들고 있다(2026-08-14 실사고). 그래서 원장을 다시 센다. */
        IF NVL(P_MODE, 0) > 0 THEN
            SELECT COUNT(*)
            INTO   v_live_cnt
            FROM   DM_PLN_CUSTOMER_PSI
            WHERE  CREATED_BY = P_CREATED_BY
            AND    CREATION_DATE >= d_ins_from;

            IF NVL(v_ins_cnt, 0) = 0 OR NVL(v_live_cnt, 0) = 0 THEN
                BEGIN
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'ERROR', N_LOG_COUNT
                      , '########## SAVE VERIFY FAILED — inserted=' || NVL(v_ins_cnt, 0)
                        || ' / live=' || NVL(v_live_cnt, 0) || ' ##########'
                      , P_MODE, SYSTIMESTAMP);
                EXCEPTION WHEN OTHERS THEN NULL; END;
                OPEN O_RESULT_CURSOR FOR
                    SELECT '-1' AS CODE
                         , 'ERR_RTN: - Save verify failed (inserted=' || NVL(v_ins_cnt, 0)
                           || ', persisted=' || NVL(v_live_cnt, 0) || ')' AS MSG
                         , 'SAVE_VERIFY' AS EVENT
                    FROM   DUAL;
                RETURN;
            END IF;
        END IF;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,'ERROR'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_CUST_FCST_EXCEL_UPLOAD;

    PROCEDURE P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
    (
        P_MODE          INTEGER
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
        * Description  : DMF0014_CUST_FCST_EXCEL_UPLOAD_SM
        * Program History
        *===========================================================================================================
        *   Date       In Charge      Description
        *===========================================================================================================
        * 2018. 01. 02   SongDH     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022. 10. 26     KDW2819    [C20221024-000507]CUST FCST Upload 오류 수정
        * 2023. 01. 25   kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
        * 2023. 02. 28   chano0612 [E20230227-000456]소형사업부 RPA 업로드 시 GSCM Fail 발생 -- EXCEL UPLOAD
        * 2024. 02. 15   kcw3408   [E20240208-001344]고객 수요 분석 시스템_Cust.FCST upload 문의의 건(데이타 없는데 Ctrl + End 키로는 인식되어 Length가 0인 컬럼을 Check 추가)
         * 2026.03.24 김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
        --DMF0014_CUST_FCST_EXCEL_UPLOAD_SM('1', 'hwayoung.lim');
     AS

        V_IN_PARA_DATA   VARCHAR2(4000);
        V_STEP           VARCHAR2(4000 CHAR) := NULL;
        V_PROGRAM_ID     VARCHAR2(40 CHAR) := 'DMF0014';
        V_SHEET_NAME     VARCHAR2(40 CHAR) := 'FCST Upload';
        V_SQL_TEXT       VARCHAR2(4000 CHAR);
        V_CREATION_DATE  VARCHAR2(40 CHAR);
        V_COUNT          INTEGER;
        V_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_END_YYYYMMDD   VARCHAR2(8 CHAR);
        V_DIVISION       VARCHAR2(10 CHAR);
        V_PROGRAM_NAME   VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE       VARCHAR2(30 CHAR);
        N_LOG_COUNT      INTEGER := 0;
        V_LOG_MESSAGE    VARCHAR2(1000 CHAR);
        V_DESCRIPTION    VARCHAR2(500 CHAR);
        D_EVENT_DATE     DATE;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_mode' VALUE P_MODE, 'p_created_by' VALUE P_CREATED_BY);

        -- LOG 용 변수 설정
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        SELECT TO_CHAR(MAX(T.CREATION_DATE), 'YYYY-MM-DD HH24:MI:SS.FF3')
        INTO   V_CREATION_DATE
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY;
        --  AND UPPER(METADATA1_VALUE) != 'BASIS YYYYMM';
        IF V_CREATION_DATE IS NULL THEN
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := 'Data Not Found [' || TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') || ']';
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

        --DMF0014_CUST_FCST_EXCEL_UPLOAD_SM('1', 'hwayoung.lim');
        BEGIN
            SELECT ATTRIBUTE1
            INTO   V_DIVISION
            FROM   SCM_ADM_EXCEL_UPLOAD
            WHERE  PROGRAM_ID = V_PROGRAM_ID
            AND    SHEET_NAME = V_SHEET_NAME
            AND    CREATED_BY = P_CREATED_BY
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    UPPER(ATTRIBUTE1) <> 'DIVISION*'
                  --AND    UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            FETCH  FIRST 1 ROWS ONLY;
        END;

        -- p_mode = 0 이면 Validation
        IF NVL(P_MODE, 0) = 0 THEN
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD T
                SET    UPLOAD_STATUS_CODE = 'UPLOAD', MESSAGE_TEXT = NULL
                WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                AND    T.SHEET_NAME = V_SHEET_NAME
                AND    T.CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    NVL(T.UPLOAD_STATUS_CODE, 'X') != 'UPLOAD';
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('RESET Status = UPLOAD', SQL%ROWCOUNT, 1, TRUE);
                V_LOG_TYPE    := '1';
                V_LOG_MESSAGE := '########## RESET Status = UPLOAD ##########';
                V_DESCRIPTION := P_MODE;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SKIP'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    (ATTRIBUTE1 IS NULL OR LENGTH(ATTRIBUTE1) = 0 OR UPPER(ATTRIBUTE1) = 'TOTAL');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('SKIP EMPTY LINE      ', SQL%ROWCOUNT, 2, TRUE);
                V_LOG_TYPE    := '2';
                V_LOG_MESSAGE := '########## SKIP EMPTY LINE ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'V_TITLE'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPPER(ATTRIBUTE1) = 'DIVISION*';
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('V_TITLE Header Line   ', SQL%ROWCOUNT, 3, TRUE);
                V_LOG_TYPE    := '3';
                V_LOG_MESSAGE := '########## TITLE Header Line ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Duplication Key.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    EXISTS (SELECT 1
                        FROM   (SELECT X.ATTRIBUTE1  AS COL1
                                      ,X.ATTRIBUTE2  COL2
                                      ,X.ATTRIBUTE3  COL3
                                      ,X.ATTRIBUTE4  COL4
                                      ,X.ATTRIBUTE5  COL5
                                      ,X.ATTRIBUTE6  COL6
                                      ,X.ATTRIBUTE7  COL7
                                      ,X.ATTRIBUTE8  COL8
                                      ,X.ATTRIBUTE9  COL9
                                      ,X.ATTRIBUTE10 COL10
                                --, X.ATTRIBUTE11 COL11
                                --, X.ATTRIBUTE12 COL12
                                FROM   SCM_ADM_EXCEL_UPLOAD X
                                WHERE  X.PROGRAM_ID = V_PROGRAM_ID
                                AND    X.SHEET_NAME = V_SHEET_NAME
                                AND    X.CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(X.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                GROUP  BY X.ATTRIBUTE1
                                         ,X.ATTRIBUTE2
                                         ,X.ATTRIBUTE3
                                         ,X.ATTRIBUTE4
                                         ,X.ATTRIBUTE5
                                         ,X.ATTRIBUTE6
                                         ,X.ATTRIBUTE7
                                         ,X.ATTRIBUTE8
                                         ,X.ATTRIBUTE9
                                         ,X.ATTRIBUTE10
                                --, X.ATTRIBUTE11
                                --, X.ATTRIBUTE12
                                HAVING COUNT(*) > 1) T
                        WHERE  1 = 1
                        AND    T.COL1 = ATTRIBUTE1
                        AND    T.COL2 = ATTRIBUTE2
                        AND    T.COL3 = ATTRIBUTE3
                        AND    T.COL4 = ATTRIBUTE4
                        AND    T.COL5 = ATTRIBUTE5
                        AND    T.COL6 = ATTRIBUTE6
                        AND    T.COL7 = ATTRIBUTE7
                        AND    T.COL8 = ATTRIBUTE8
                        AND    T.COL9 = ATTRIBUTE9
                        AND    T.COL10 = ATTRIBUTE10
                        --AND T.COL11 = ATTRIBUTE11
                        --AND T.COL12 = ATTRIBUTE12
                        );
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('ERROR Key Duplication ', SQL%ROWCOUNT, 4, TRUE);
                V_LOG_TYPE    := '4';
                V_LOG_MESSAGE := '########## ERROR Key Duplication ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Division.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                        UNION
                        SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);
            END;

            BEGIN
                -- Division Validation은 끝났으니 코드로 정보를 치환해줌.
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE1 =
                       (SELECT D.DIVISION_ID
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_DIVISION D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1);
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Upload Bucket.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    D.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    D.UPLOAD_BUCKET_TYPE IN (SELECT CASE (NVL(TO_DATE(Z.ATTRIBUTE16, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD'), TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD')))  /* [BUCKET FIX 07-06] 부분 첫주(월1일)=2~3번째 일자 간격(완전주) 우선 */
                                                                   WHEN 1 THEN
                                                                    'DAILY'
                                                                   WHEN 7 THEN
                                                                    'WEEKLY'
                                                                   ELSE
                                                                    'MONTHLY'
                                                               END
                                                        FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                        WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                        AND    Z.SHEET_NAME = V_SHEET_NAME
                                                        AND    Z.CREATED_BY = P_CREATED_BY
                                                        AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                        AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE'));
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Upload UOM.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST D, SCM_MST_DIVISION D2
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DIVISION_ID = D2.DIVISION_ID
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    D.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    D.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    D.UPLOAD_UOM = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11);
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Division ', SQL%ROWCOUNT, 5, TRUE);
                V_LOG_TYPE    := '5';
                V_LOG_MESSAGE := '########## Invalid Division ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Scm Site.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '6';
                V_LOG_MESSAGE := '########## Invalid Scm Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Plant Site.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    (ATTRIBUTE1 = '81' OR ATTRIBUTE1 = 'Automotive Battery') -- ess는 제외
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_MST_SITE S, SCM_MST_DIVISION D2
                        WHERE  S.DIVISION_ID = D2.DIVISION_ID
                        AND    S.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE3
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    S.VALID_YN = 'Y');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Scm Site ', SQL%ROWCOUNT, 8, TRUE);
                V_LOG_TYPE    := '6';
                V_LOG_MESSAGE := '########## Invalid Plant Site. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customer Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.VALID_YN              = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Customer Project ', SQL%ROWCOUNT, 6, TRUE);
            v_log_type := '7';
            v_log_message := '########## Invalid Customer Project ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            IF V_DIVISION != '40' THEN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Customer Model.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_MODEL CM, SCM_MST_DIVISION D2
                        WHERE  CM.DIVISION_ID = D2.DIVISION_ID
                        AND    CM.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    CM.CUSTOMER_MODEL = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CM.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_MST_SITE_ITEM SI, SCM_MST_DIVISION D3
                        WHERE  SI.DIVISION_ID = D3.DIVISION_ID
                        AND    SI.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    SI.PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                        AND    SI.ITEM_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                        AND    (D3.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D3.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    SI.VALID_YN = 'Y');
            END IF;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Customer Model ', SQL%ROWCOUNT, 7, TRUE);
                V_LOG_TYPE    := '8';
                V_LOG_MESSAGE := '########## Invalid Customer Model ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Incoterms.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE6
                        AND    L.LOOKUP_TYPE = 'INCOTERMS'
                        AND    L.VALID_YN = 'Y');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '10';
                V_LOG_MESSAGE := '########## Invalid Incoterms. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Sales Type.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y'
                        UNION
                        SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.DESCRIPTION = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7);
            END;

            BEGIN
                -- validation이 끝났으니 code로 update
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    ATTRIBUTE7 =
                       (SELECT D.SEGMENT1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL D
                        WHERE  D.VALID_YN = 'Y'
                        AND    D.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    D.SEGMENT2 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7)
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE7
                        AND    L.LOOKUP_TYPE = 'SALES_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '11';
                V_LOG_MESSAGE := '########## Invalid Sales Type. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Customs Handbook'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                            WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE8
                            AND    L.LOOKUP_TYPE = 'DOM/EXP'
                            AND    L.VALID_YN    = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '12';
            v_log_message := '########## Invalid DOM/EXP. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Measure Group.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE9
                        AND    L.LOOKUP_TYPE = 'MEASURE_GROUP_CODE'
                        AND    L.SEGMENT1 = 'CUST_FCST'
                        AND    L.VALID_YN = 'Y');
            END;

            --20230125 kdmcc14 [E20230119-000186-RPA 고객 FCST 가 소수점 단위로 Upload 될 경우 Error 팝업 및 사유 알람기능]
            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '12';
                V_LOG_MESSAGE := '########## Invalid Alphabet, NUMBER. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            --문자열 체크
            BEGIN

                MERGE INTO SCM_ADM_EXCEL_UPLOAD A
                USING (SELECT *
                       FROM   (SELECT UPLOAD_ID
                                     ,SUM(CASE
                                              WHEN REGEXP_LIKE(VALUE, '^\s*[+-]?\d*\.?\d+\s*$') THEN
                                               0
                                              ELSE
                                               1
                                          END) PRICE
                               FROM   (SELECT UPLOAD_ID
                                             ,ATTRIBUTE14
                                             ,ATTRIBUTE15
                                             ,ATTRIBUTE16
                                             ,ATTRIBUTE17
                                             ,ATTRIBUTE18
                                             ,ATTRIBUTE19
                                             ,ATTRIBUTE20
                                             ,ATTRIBUTE21
                                             ,ATTRIBUTE22
                                             ,ATTRIBUTE23
                                             ,ATTRIBUTE24
                                             ,ATTRIBUTE25
                                             ,ATTRIBUTE26
                                             ,ATTRIBUTE27
                                             ,ATTRIBUTE28
                                             ,ATTRIBUTE29
                                             ,ATTRIBUTE30
                                             ,ATTRIBUTE31
                                             ,ATTRIBUTE32
                                             ,ATTRIBUTE33
                                             ,ATTRIBUTE34
                                             ,ATTRIBUTE35
                                             ,ATTRIBUTE36
                                             ,ATTRIBUTE37
                                             ,ATTRIBUTE38
                                             ,ATTRIBUTE39
                                             ,ATTRIBUTE40
                                             ,ATTRIBUTE41
                                             ,ATTRIBUTE42
                                             ,ATTRIBUTE43
                                             ,ATTRIBUTE44
                                             ,ATTRIBUTE45
                                             ,ATTRIBUTE46
                                             ,ATTRIBUTE47
                                             ,ATTRIBUTE48
                                             ,ATTRIBUTE49
                                             ,ATTRIBUTE50
                                             ,ATTRIBUTE51
                                             ,ATTRIBUTE52
                                             ,ATTRIBUTE53
                                             ,ATTRIBUTE54
                                             ,ATTRIBUTE55
                                             ,ATTRIBUTE56
                                             ,ATTRIBUTE57
                                             ,ATTRIBUTE58
                                             ,ATTRIBUTE59
                                             ,ATTRIBUTE60
                                             ,ATTRIBUTE61
                                             ,ATTRIBUTE62
                                             ,ATTRIBUTE63
                                             ,ATTRIBUTE64
                                             ,ATTRIBUTE65
                                             ,ATTRIBUTE66
                                             ,ATTRIBUTE67
                                             ,ATTRIBUTE68
                                             ,ATTRIBUTE69
                                             ,ATTRIBUTE70
                                             ,ATTRIBUTE71
                                             ,ATTRIBUTE72
                                             ,ATTRIBUTE73
                                             ,ATTRIBUTE74
                                             ,ATTRIBUTE75
                                             ,ATTRIBUTE76
                                             ,ATTRIBUTE77
                                             ,ATTRIBUTE78
                                             ,ATTRIBUTE79
                                             ,ATTRIBUTE80
                                             ,ATTRIBUTE81
                                             ,ATTRIBUTE82
                                             ,ATTRIBUTE83
                                             ,ATTRIBUTE84
                                             ,ATTRIBUTE85
                                             ,ATTRIBUTE86
                                             ,ATTRIBUTE87
                                             ,ATTRIBUTE88
                                             ,ATTRIBUTE89
                                             ,ATTRIBUTE90
                                             ,ATTRIBUTE91
                                             ,ATTRIBUTE92
                                             ,ATTRIBUTE93
                                             ,ATTRIBUTE94
                                             ,ATTRIBUTE95
                                             ,ATTRIBUTE96
                                             ,ATTRIBUTE97
                                             ,ATTRIBUTE98
                                             ,ATTRIBUTE99
                                             ,ATTRIBUTE100
                                             ,ATTRIBUTE101
                                             ,ATTRIBUTE102
                                             ,ATTRIBUTE103
                                             ,ATTRIBUTE104
                                             ,ATTRIBUTE105
                                             ,ATTRIBUTE106
                                             ,ATTRIBUTE107
                                             ,ATTRIBUTE108
                                             ,ATTRIBUTE109
                                             ,ATTRIBUTE110
                                             ,ATTRIBUTE111
                                             ,ATTRIBUTE112
                                             ,ATTRIBUTE113
                                             ,ATTRIBUTE114
                                             ,ATTRIBUTE115
                                             ,ATTRIBUTE116
                                             ,ATTRIBUTE117
                                             ,ATTRIBUTE118
                                             ,ATTRIBUTE119
                                             ,ATTRIBUTE120
                                             ,ATTRIBUTE121
                                             ,ATTRIBUTE122
                                             ,ATTRIBUTE123
                                             ,ATTRIBUTE124
                                             ,ATTRIBUTE125
                                             ,ATTRIBUTE126
                                             ,ATTRIBUTE127
                                             ,ATTRIBUTE128
                                             ,ATTRIBUTE129
                                             ,ATTRIBUTE130
                                             ,ATTRIBUTE131
                                             ,ATTRIBUTE132
                                             ,ATTRIBUTE133
                                             ,ATTRIBUTE134
                                             ,ATTRIBUTE135
                                             ,ATTRIBUTE136
                                             ,ATTRIBUTE137
                                             ,ATTRIBUTE138
                                             ,ATTRIBUTE139
                                             ,ATTRIBUTE140
                                             ,ATTRIBUTE141
                                             ,ATTRIBUTE142
                                             ,ATTRIBUTE143
                                             ,ATTRIBUTE144
                                             ,ATTRIBUTE145
                                             ,ATTRIBUTE146
                                             ,ATTRIBUTE147
                                             ,ATTRIBUTE148
                                             ,ATTRIBUTE149
                                             ,ATTRIBUTE150
                                             ,ATTRIBUTE151
                                             ,ATTRIBUTE152
                                             ,ATTRIBUTE153
                                             ,ATTRIBUTE154
                                             ,ATTRIBUTE155
                                             ,ATTRIBUTE156
                                             ,ATTRIBUTE157
                                             ,ATTRIBUTE158
                                             ,ATTRIBUTE159
                                             ,ATTRIBUTE160
                                             ,ATTRIBUTE161
                                             ,ATTRIBUTE162
                                             ,ATTRIBUTE163
                                             ,ATTRIBUTE164
                                             ,ATTRIBUTE165
                                             ,ATTRIBUTE166
                                             ,ATTRIBUTE167
                                             ,ATTRIBUTE168
                                             ,ATTRIBUTE169
                                             ,ATTRIBUTE170
                                             ,ATTRIBUTE171
                                             ,ATTRIBUTE172
                                             ,ATTRIBUTE173
                                             ,ATTRIBUTE174
                                             ,ATTRIBUTE175
                                             ,ATTRIBUTE176
                                             ,ATTRIBUTE177
                                             ,ATTRIBUTE178
                                             ,ATTRIBUTE179
                                             ,ATTRIBUTE180
                                             ,ATTRIBUTE181
                                             ,ATTRIBUTE182
                                             ,ATTRIBUTE183
                                             ,ATTRIBUTE184
                                             ,ATTRIBUTE185
                                             ,ATTRIBUTE186
                                             ,ATTRIBUTE187
                                             ,ATTRIBUTE188
                                             ,ATTRIBUTE189
                                             ,ATTRIBUTE190
                                             ,ATTRIBUTE191
                                             ,ATTRIBUTE192
                                             ,ATTRIBUTE193
                                             ,ATTRIBUTE194
                                             ,ATTRIBUTE195
                                             ,ATTRIBUTE196
                                             ,ATTRIBUTE197
                                             ,ATTRIBUTE198
                                             ,ATTRIBUTE199
                                             ,ATTRIBUTE200
                                       FROM   SCM_ADM_EXCEL_UPLOAD
                                       WHERE  1 = 1
                                       AND    PROGRAM_ID = V_PROGRAM_ID
                                       AND    SHEET_NAME = V_SHEET_NAME
                                       AND    CREATED_BY = P_CREATED_BY
                                       AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                       AND    UPLOAD_STATUS_CODE = 'UPLOAD') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                               ,ATTRIBUTE15
                                                                                                               ,ATTRIBUTE16
                                                                                                               ,ATTRIBUTE17
                                                                                                               ,ATTRIBUTE18
                                                                                                               ,ATTRIBUTE19
                                                                                                               ,ATTRIBUTE20
                                                                                                               ,ATTRIBUTE21
                                                                                                               ,ATTRIBUTE22
                                                                                                               ,ATTRIBUTE23
                                                                                                               ,ATTRIBUTE24
                                                                                                               ,ATTRIBUTE25
                                                                                                               ,ATTRIBUTE26
                                                                                                               ,ATTRIBUTE27
                                                                                                               ,ATTRIBUTE28
                                                                                                               ,ATTRIBUTE29
                                                                                                               ,ATTRIBUTE30
                                                                                                               ,ATTRIBUTE31
                                                                                                               ,ATTRIBUTE32
                                                                                                               ,ATTRIBUTE33
                                                                                                               ,ATTRIBUTE34
                                                                                                               ,ATTRIBUTE35
                                                                                                               ,ATTRIBUTE36
                                                                                                               ,ATTRIBUTE37
                                                                                                               ,ATTRIBUTE38
                                                                                                               ,ATTRIBUTE39
                                                                                                               ,ATTRIBUTE40
                                                                                                               ,ATTRIBUTE41
                                                                                                               ,ATTRIBUTE42
                                                                                                               ,ATTRIBUTE43
                                                                                                               ,ATTRIBUTE44
                                                                                                               ,ATTRIBUTE45
                                                                                                               ,ATTRIBUTE46
                                                                                                               ,ATTRIBUTE47
                                                                                                               ,ATTRIBUTE48
                                                                                                               ,ATTRIBUTE49
                                                                                                               ,ATTRIBUTE50
                                                                                                               ,ATTRIBUTE51
                                                                                                               ,ATTRIBUTE52
                                                                                                               ,ATTRIBUTE53
                                                                                                               ,ATTRIBUTE54
                                                                                                               ,ATTRIBUTE55
                                                                                                               ,ATTRIBUTE56
                                                                                                               ,ATTRIBUTE57
                                                                                                               ,ATTRIBUTE58
                                                                                                               ,ATTRIBUTE59
                                                                                                               ,ATTRIBUTE60
                                                                                                               ,ATTRIBUTE61
                                                                                                               ,ATTRIBUTE62
                                                                                                               ,ATTRIBUTE63
                                                                                                               ,ATTRIBUTE64
                                                                                                               ,ATTRIBUTE65
                                                                                                               ,ATTRIBUTE66
                                                                                                               ,ATTRIBUTE67
                                                                                                               ,ATTRIBUTE68
                                                                                                               ,ATTRIBUTE69
                                                                                                               ,ATTRIBUTE70
                                                                                                               ,ATTRIBUTE71
                                                                                                               ,ATTRIBUTE72
                                                                                                               ,ATTRIBUTE73
                                                                                                               ,ATTRIBUTE74
                                                                                                               ,ATTRIBUTE75
                                                                                                               ,ATTRIBUTE76
                                                                                                               ,ATTRIBUTE77
                                                                                                               ,ATTRIBUTE78
                                                                                                               ,ATTRIBUTE79
                                                                                                               ,ATTRIBUTE80
                                                                                                               ,ATTRIBUTE81
                                                                                                               ,ATTRIBUTE82
                                                                                                               ,ATTRIBUTE83
                                                                                                               ,ATTRIBUTE84
                                                                                                               ,ATTRIBUTE85
                                                                                                               ,ATTRIBUTE86
                                                                                                               ,ATTRIBUTE87
                                                                                                               ,ATTRIBUTE88
                                                                                                               ,ATTRIBUTE89
                                                                                                               ,ATTRIBUTE90
                                                                                                               ,ATTRIBUTE91
                                                                                                               ,ATTRIBUTE92
                                                                                                               ,ATTRIBUTE93
                                                                                                               ,ATTRIBUTE94
                                                                                                               ,ATTRIBUTE95
                                                                                                               ,ATTRIBUTE96
                                                                                                               ,ATTRIBUTE97
                                                                                                               ,ATTRIBUTE98
                                                                                                               ,ATTRIBUTE99
                                                                                                               ,ATTRIBUTE100
                                                                                                               ,ATTRIBUTE101
                                                                                                               ,ATTRIBUTE102
                                                                                                               ,ATTRIBUTE103
                                                                                                               ,ATTRIBUTE104
                                                                                                               ,ATTRIBUTE105
                                                                                                               ,ATTRIBUTE106
                                                                                                               ,ATTRIBUTE107
                                                                                                               ,ATTRIBUTE108
                                                                                                               ,ATTRIBUTE109
                                                                                                               ,ATTRIBUTE110
                                                                                                               ,ATTRIBUTE111
                                                                                                               ,ATTRIBUTE112
                                                                                                               ,ATTRIBUTE113
                                                                                                               ,ATTRIBUTE114
                                                                                                               ,ATTRIBUTE115
                                                                                                               ,ATTRIBUTE116
                                                                                                               ,ATTRIBUTE117
                                                                                                               ,ATTRIBUTE118
                                                                                                               ,ATTRIBUTE119
                                                                                                               ,ATTRIBUTE120
                                                                                                               ,ATTRIBUTE121
                                                                                                               ,ATTRIBUTE122
                                                                                                               ,ATTRIBUTE123
                                                                                                               ,ATTRIBUTE124
                                                                                                               ,ATTRIBUTE125
                                                                                                               ,ATTRIBUTE126
                                                                                                               ,ATTRIBUTE127
                                                                                                               ,ATTRIBUTE128
                                                                                                               ,ATTRIBUTE129
                                                                                                               ,ATTRIBUTE130
                                                                                                               ,ATTRIBUTE131
                                                                                                               ,ATTRIBUTE132
                                                                                                               ,ATTRIBUTE133
                                                                                                               ,ATTRIBUTE134
                                                                                                               ,ATTRIBUTE135
                                                                                                               ,ATTRIBUTE136
                                                                                                               ,ATTRIBUTE137
                                                                                                               ,ATTRIBUTE138
                                                                                                               ,ATTRIBUTE139
                                                                                                               ,ATTRIBUTE140
                                                                                                               ,ATTRIBUTE141
                                                                                                               ,ATTRIBUTE142
                                                                                                               ,ATTRIBUTE143
                                                                                                               ,ATTRIBUTE144
                                                                                                               ,ATTRIBUTE145
                                                                                                               ,ATTRIBUTE146
                                                                                                               ,ATTRIBUTE147
                                                                                                               ,ATTRIBUTE148
                                                                                                               ,ATTRIBUTE149
                                                                                                               ,ATTRIBUTE150
                                                                                                               ,ATTRIBUTE151
                                                                                                               ,ATTRIBUTE152
                                                                                                               ,ATTRIBUTE153
                                                                                                               ,ATTRIBUTE154
                                                                                                               ,ATTRIBUTE155
                                                                                                               ,ATTRIBUTE156
                                                                                                               ,ATTRIBUTE157
                                                                                                               ,ATTRIBUTE158
                                                                                                               ,ATTRIBUTE159
                                                                                                               ,ATTRIBUTE160
                                                                                                               ,ATTRIBUTE161
                                                                                                               ,ATTRIBUTE162
                                                                                                               ,ATTRIBUTE163
                                                                                                               ,ATTRIBUTE164
                                                                                                               ,ATTRIBUTE165
                                                                                                               ,ATTRIBUTE166
                                                                                                               ,ATTRIBUTE167
                                                                                                               ,ATTRIBUTE168
                                                                                                               ,ATTRIBUTE169
                                                                                                               ,ATTRIBUTE170
                                                                                                               ,ATTRIBUTE171
                                                                                                               ,ATTRIBUTE172
                                                                                                               ,ATTRIBUTE173
                                                                                                               ,ATTRIBUTE174
                                                                                                               ,ATTRIBUTE175
                                                                                                               ,ATTRIBUTE176
                                                                                                               ,ATTRIBUTE177
                                                                                                               ,ATTRIBUTE178
                                                                                                               ,ATTRIBUTE179
                                                                                                               ,ATTRIBUTE180
                                                                                                               ,ATTRIBUTE181
                                                                                                               ,ATTRIBUTE182
                                                                                                               ,ATTRIBUTE183
                                                                                                               ,ATTRIBUTE184
                                                                                                               ,ATTRIBUTE185
                                                                                                               ,ATTRIBUTE186
                                                                                                               ,ATTRIBUTE187
                                                                                                               ,ATTRIBUTE188
                                                                                                               ,ATTRIBUTE189
                                                                                                               ,ATTRIBUTE190
                                                                                                               ,ATTRIBUTE191
                                                                                                               ,ATTRIBUTE192
                                                                                                               ,ATTRIBUTE193
                                                                                                               ,ATTRIBUTE194
                                                                                                               ,ATTRIBUTE195
                                                                                                               ,ATTRIBUTE196
                                                                                                               ,ATTRIBUTE197
                                                                                                               ,ATTRIBUTE198
                                                                                                               ,ATTRIBUTE199
                                                                                                               ,ATTRIBUTE200)) X
                               WHERE  1 = 1
                               AND    LTRIM(RTRIM(VALUE)) IS NOT NULL
                               AND    VALUE != '0'
                               AND    VALUE IS NOT NULL
                               GROUP  BY UPLOAD_ID) B) SRC_UPD
                ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND SRC_UPD.PRICE > 0)
                WHEN MATCHED THEN
                    UPDATE
                    SET    UPLOAD_STATUS_CODE = 'ERROR'
                          ,MESSAGE_TEXT       = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 …).';

            END;
            --소수점 체크
            BEGIN

                MERGE INTO SCM_ADM_EXCEL_UPLOAD A
                USING (SELECT *
                       FROM   (SELECT UPLOAD_ID
                                     ,SUM(CASE
                                              WHEN ROUND(TO_NUMBER(VALUE), 10) - FLOOR(ROUND(TO_NUMBER(VALUE), 10)) <> 0 THEN
                                               1
                                              ELSE
                                               0
                                          END) PRICE
                               FROM   (SELECT UPLOAD_ID
                                             ,ATTRIBUTE14
                                             ,ATTRIBUTE15
                                             ,ATTRIBUTE16
                                             ,ATTRIBUTE17
                                             ,ATTRIBUTE18
                                             ,ATTRIBUTE19
                                             ,ATTRIBUTE20
                                             ,ATTRIBUTE21
                                             ,ATTRIBUTE22
                                             ,ATTRIBUTE23
                                             ,ATTRIBUTE24
                                             ,ATTRIBUTE25
                                             ,ATTRIBUTE26
                                             ,ATTRIBUTE27
                                             ,ATTRIBUTE28
                                             ,ATTRIBUTE29
                                             ,ATTRIBUTE30
                                             ,ATTRIBUTE31
                                             ,ATTRIBUTE32
                                             ,ATTRIBUTE33
                                             ,ATTRIBUTE34
                                             ,ATTRIBUTE35
                                             ,ATTRIBUTE36
                                             ,ATTRIBUTE37
                                             ,ATTRIBUTE38
                                             ,ATTRIBUTE39
                                             ,ATTRIBUTE40
                                             ,ATTRIBUTE41
                                             ,ATTRIBUTE42
                                             ,ATTRIBUTE43
                                             ,ATTRIBUTE44
                                             ,ATTRIBUTE45
                                             ,ATTRIBUTE46
                                             ,ATTRIBUTE47
                                             ,ATTRIBUTE48
                                             ,ATTRIBUTE49
                                             ,ATTRIBUTE50
                                             ,ATTRIBUTE51
                                             ,ATTRIBUTE52
                                             ,ATTRIBUTE53
                                             ,ATTRIBUTE54
                                             ,ATTRIBUTE55
                                             ,ATTRIBUTE56
                                             ,ATTRIBUTE57
                                             ,ATTRIBUTE58
                                             ,ATTRIBUTE59
                                             ,ATTRIBUTE60
                                             ,ATTRIBUTE61
                                             ,ATTRIBUTE62
                                             ,ATTRIBUTE63
                                             ,ATTRIBUTE64
                                             ,ATTRIBUTE65
                                             ,ATTRIBUTE66
                                             ,ATTRIBUTE67
                                             ,ATTRIBUTE68
                                             ,ATTRIBUTE69
                                             ,ATTRIBUTE70
                                             ,ATTRIBUTE71
                                             ,ATTRIBUTE72
                                             ,ATTRIBUTE73
                                             ,ATTRIBUTE74
                                             ,ATTRIBUTE75
                                             ,ATTRIBUTE76
                                             ,ATTRIBUTE77
                                             ,ATTRIBUTE78
                                             ,ATTRIBUTE79
                                             ,ATTRIBUTE80
                                             ,ATTRIBUTE81
                                             ,ATTRIBUTE82
                                             ,ATTRIBUTE83
                                             ,ATTRIBUTE84
                                             ,ATTRIBUTE85
                                             ,ATTRIBUTE86
                                             ,ATTRIBUTE87
                                             ,ATTRIBUTE88
                                             ,ATTRIBUTE89
                                             ,ATTRIBUTE90
                                             ,ATTRIBUTE91
                                             ,ATTRIBUTE92
                                             ,ATTRIBUTE93
                                             ,ATTRIBUTE94
                                             ,ATTRIBUTE95
                                             ,ATTRIBUTE96
                                             ,ATTRIBUTE97
                                             ,ATTRIBUTE98
                                             ,ATTRIBUTE99
                                             ,ATTRIBUTE100
                                             ,ATTRIBUTE101
                                             ,ATTRIBUTE102
                                             ,ATTRIBUTE103
                                             ,ATTRIBUTE104
                                             ,ATTRIBUTE105
                                             ,ATTRIBUTE106
                                             ,ATTRIBUTE107
                                             ,ATTRIBUTE108
                                             ,ATTRIBUTE109
                                             ,ATTRIBUTE110
                                             ,ATTRIBUTE111
                                             ,ATTRIBUTE112
                                             ,ATTRIBUTE113
                                             ,ATTRIBUTE114
                                             ,ATTRIBUTE115
                                             ,ATTRIBUTE116
                                             ,ATTRIBUTE117
                                             ,ATTRIBUTE118
                                             ,ATTRIBUTE119
                                             ,ATTRIBUTE120
                                             ,ATTRIBUTE121
                                             ,ATTRIBUTE122
                                             ,ATTRIBUTE123
                                             ,ATTRIBUTE124
                                             ,ATTRIBUTE125
                                             ,ATTRIBUTE126
                                             ,ATTRIBUTE127
                                             ,ATTRIBUTE128
                                             ,ATTRIBUTE129
                                             ,ATTRIBUTE130
                                             ,ATTRIBUTE131
                                             ,ATTRIBUTE132
                                             ,ATTRIBUTE133
                                             ,ATTRIBUTE134
                                             ,ATTRIBUTE135
                                             ,ATTRIBUTE136
                                             ,ATTRIBUTE137
                                             ,ATTRIBUTE138
                                             ,ATTRIBUTE139
                                             ,ATTRIBUTE140
                                             ,ATTRIBUTE141
                                             ,ATTRIBUTE142
                                             ,ATTRIBUTE143
                                             ,ATTRIBUTE144
                                             ,ATTRIBUTE145
                                             ,ATTRIBUTE146
                                             ,ATTRIBUTE147
                                             ,ATTRIBUTE148
                                             ,ATTRIBUTE149
                                             ,ATTRIBUTE150
                                             ,ATTRIBUTE151
                                             ,ATTRIBUTE152
                                             ,ATTRIBUTE153
                                             ,ATTRIBUTE154
                                             ,ATTRIBUTE155
                                             ,ATTRIBUTE156
                                             ,ATTRIBUTE157
                                             ,ATTRIBUTE158
                                             ,ATTRIBUTE159
                                             ,ATTRIBUTE160
                                             ,ATTRIBUTE161
                                             ,ATTRIBUTE162
                                             ,ATTRIBUTE163
                                             ,ATTRIBUTE164
                                             ,ATTRIBUTE165
                                             ,ATTRIBUTE166
                                             ,ATTRIBUTE167
                                             ,ATTRIBUTE168
                                             ,ATTRIBUTE169
                                             ,ATTRIBUTE170
                                             ,ATTRIBUTE171
                                             ,ATTRIBUTE172
                                             ,ATTRIBUTE173
                                             ,ATTRIBUTE174
                                             ,ATTRIBUTE175
                                             ,ATTRIBUTE176
                                             ,ATTRIBUTE177
                                             ,ATTRIBUTE178
                                             ,ATTRIBUTE179
                                             ,ATTRIBUTE180
                                             ,ATTRIBUTE181
                                             ,ATTRIBUTE182
                                             ,ATTRIBUTE183
                                             ,ATTRIBUTE184
                                             ,ATTRIBUTE185
                                             ,ATTRIBUTE186
                                             ,ATTRIBUTE187
                                             ,ATTRIBUTE188
                                             ,ATTRIBUTE189
                                             ,ATTRIBUTE190
                                             ,ATTRIBUTE191
                                             ,ATTRIBUTE192
                                             ,ATTRIBUTE193
                                             ,ATTRIBUTE194
                                             ,ATTRIBUTE195
                                             ,ATTRIBUTE196
                                             ,ATTRIBUTE197
                                             ,ATTRIBUTE198
                                             ,ATTRIBUTE199
                                             ,ATTRIBUTE200
                                       FROM   SCM_ADM_EXCEL_UPLOAD
                                       WHERE  1 = 1
                                       AND    PROGRAM_ID = V_PROGRAM_ID
                                       AND    SHEET_NAME = V_SHEET_NAME
                                       AND    CREATED_BY = P_CREATED_BY
                                       AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                       AND    UPLOAD_STATUS_CODE = 'UPLOAD') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                               ,ATTRIBUTE15
                                                                                                               ,ATTRIBUTE16
                                                                                                               ,ATTRIBUTE17
                                                                                                               ,ATTRIBUTE18
                                                                                                               ,ATTRIBUTE19
                                                                                                               ,ATTRIBUTE20
                                                                                                               ,ATTRIBUTE21
                                                                                                               ,ATTRIBUTE22
                                                                                                               ,ATTRIBUTE23
                                                                                                               ,ATTRIBUTE24
                                                                                                               ,ATTRIBUTE25
                                                                                                               ,ATTRIBUTE26
                                                                                                               ,ATTRIBUTE27
                                                                                                               ,ATTRIBUTE28
                                                                                                               ,ATTRIBUTE29
                                                                                                               ,ATTRIBUTE30
                                                                                                               ,ATTRIBUTE31
                                                                                                               ,ATTRIBUTE32
                                                                                                               ,ATTRIBUTE33
                                                                                                               ,ATTRIBUTE34
                                                                                                               ,ATTRIBUTE35
                                                                                                               ,ATTRIBUTE36
                                                                                                               ,ATTRIBUTE37
                                                                                                               ,ATTRIBUTE38
                                                                                                               ,ATTRIBUTE39
                                                                                                               ,ATTRIBUTE40
                                                                                                               ,ATTRIBUTE41
                                                                                                               ,ATTRIBUTE42
                                                                                                               ,ATTRIBUTE43
                                                                                                               ,ATTRIBUTE44
                                                                                                               ,ATTRIBUTE45
                                                                                                               ,ATTRIBUTE46
                                                                                                               ,ATTRIBUTE47
                                                                                                               ,ATTRIBUTE48
                                                                                                               ,ATTRIBUTE49
                                                                                                               ,ATTRIBUTE50
                                                                                                               ,ATTRIBUTE51
                                                                                                               ,ATTRIBUTE52
                                                                                                               ,ATTRIBUTE53
                                                                                                               ,ATTRIBUTE54
                                                                                                               ,ATTRIBUTE55
                                                                                                               ,ATTRIBUTE56
                                                                                                               ,ATTRIBUTE57
                                                                                                               ,ATTRIBUTE58
                                                                                                               ,ATTRIBUTE59
                                                                                                               ,ATTRIBUTE60
                                                                                                               ,ATTRIBUTE61
                                                                                                               ,ATTRIBUTE62
                                                                                                               ,ATTRIBUTE63
                                                                                                               ,ATTRIBUTE64
                                                                                                               ,ATTRIBUTE65
                                                                                                               ,ATTRIBUTE66
                                                                                                               ,ATTRIBUTE67
                                                                                                               ,ATTRIBUTE68
                                                                                                               ,ATTRIBUTE69
                                                                                                               ,ATTRIBUTE70
                                                                                                               ,ATTRIBUTE71
                                                                                                               ,ATTRIBUTE72
                                                                                                               ,ATTRIBUTE73
                                                                                                               ,ATTRIBUTE74
                                                                                                               ,ATTRIBUTE75
                                                                                                               ,ATTRIBUTE76
                                                                                                               ,ATTRIBUTE77
                                                                                                               ,ATTRIBUTE78
                                                                                                               ,ATTRIBUTE79
                                                                                                               ,ATTRIBUTE80
                                                                                                               ,ATTRIBUTE81
                                                                                                               ,ATTRIBUTE82
                                                                                                               ,ATTRIBUTE83
                                                                                                               ,ATTRIBUTE84
                                                                                                               ,ATTRIBUTE85
                                                                                                               ,ATTRIBUTE86
                                                                                                               ,ATTRIBUTE87
                                                                                                               ,ATTRIBUTE88
                                                                                                               ,ATTRIBUTE89
                                                                                                               ,ATTRIBUTE90
                                                                                                               ,ATTRIBUTE91
                                                                                                               ,ATTRIBUTE92
                                                                                                               ,ATTRIBUTE93
                                                                                                               ,ATTRIBUTE94
                                                                                                               ,ATTRIBUTE95
                                                                                                               ,ATTRIBUTE96
                                                                                                               ,ATTRIBUTE97
                                                                                                               ,ATTRIBUTE98
                                                                                                               ,ATTRIBUTE99
                                                                                                               ,ATTRIBUTE100
                                                                                                               ,ATTRIBUTE101
                                                                                                               ,ATTRIBUTE102
                                                                                                               ,ATTRIBUTE103
                                                                                                               ,ATTRIBUTE104
                                                                                                               ,ATTRIBUTE105
                                                                                                               ,ATTRIBUTE106
                                                                                                               ,ATTRIBUTE107
                                                                                                               ,ATTRIBUTE108
                                                                                                               ,ATTRIBUTE109
                                                                                                               ,ATTRIBUTE110
                                                                                                               ,ATTRIBUTE111
                                                                                                               ,ATTRIBUTE112
                                                                                                               ,ATTRIBUTE113
                                                                                                               ,ATTRIBUTE114
                                                                                                               ,ATTRIBUTE115
                                                                                                               ,ATTRIBUTE116
                                                                                                               ,ATTRIBUTE117
                                                                                                               ,ATTRIBUTE118
                                                                                                               ,ATTRIBUTE119
                                                                                                               ,ATTRIBUTE120
                                                                                                               ,ATTRIBUTE121
                                                                                                               ,ATTRIBUTE122
                                                                                                               ,ATTRIBUTE123
                                                                                                               ,ATTRIBUTE124
                                                                                                               ,ATTRIBUTE125
                                                                                                               ,ATTRIBUTE126
                                                                                                               ,ATTRIBUTE127
                                                                                                               ,ATTRIBUTE128
                                                                                                               ,ATTRIBUTE129
                                                                                                               ,ATTRIBUTE130
                                                                                                               ,ATTRIBUTE131
                                                                                                               ,ATTRIBUTE132
                                                                                                               ,ATTRIBUTE133
                                                                                                               ,ATTRIBUTE134
                                                                                                               ,ATTRIBUTE135
                                                                                                               ,ATTRIBUTE136
                                                                                                               ,ATTRIBUTE137
                                                                                                               ,ATTRIBUTE138
                                                                                                               ,ATTRIBUTE139
                                                                                                               ,ATTRIBUTE140
                                                                                                               ,ATTRIBUTE141
                                                                                                               ,ATTRIBUTE142
                                                                                                               ,ATTRIBUTE143
                                                                                                               ,ATTRIBUTE144
                                                                                                               ,ATTRIBUTE145
                                                                                                               ,ATTRIBUTE146
                                                                                                               ,ATTRIBUTE147
                                                                                                               ,ATTRIBUTE148
                                                                                                               ,ATTRIBUTE149
                                                                                                               ,ATTRIBUTE150
                                                                                                               ,ATTRIBUTE151
                                                                                                               ,ATTRIBUTE152
                                                                                                               ,ATTRIBUTE153
                                                                                                               ,ATTRIBUTE154
                                                                                                               ,ATTRIBUTE155
                                                                                                               ,ATTRIBUTE156
                                                                                                               ,ATTRIBUTE157
                                                                                                               ,ATTRIBUTE158
                                                                                                               ,ATTRIBUTE159
                                                                                                               ,ATTRIBUTE160
                                                                                                               ,ATTRIBUTE161
                                                                                                               ,ATTRIBUTE162
                                                                                                               ,ATTRIBUTE163
                                                                                                               ,ATTRIBUTE164
                                                                                                               ,ATTRIBUTE165
                                                                                                               ,ATTRIBUTE166
                                                                                                               ,ATTRIBUTE167
                                                                                                               ,ATTRIBUTE168
                                                                                                               ,ATTRIBUTE169
                                                                                                               ,ATTRIBUTE170
                                                                                                               ,ATTRIBUTE171
                                                                                                               ,ATTRIBUTE172
                                                                                                               ,ATTRIBUTE173
                                                                                                               ,ATTRIBUTE174
                                                                                                               ,ATTRIBUTE175
                                                                                                               ,ATTRIBUTE176
                                                                                                               ,ATTRIBUTE177
                                                                                                               ,ATTRIBUTE178
                                                                                                               ,ATTRIBUTE179
                                                                                                               ,ATTRIBUTE180
                                                                                                               ,ATTRIBUTE181
                                                                                                               ,ATTRIBUTE182
                                                                                                               ,ATTRIBUTE183
                                                                                                               ,ATTRIBUTE184
                                                                                                               ,ATTRIBUTE185
                                                                                                               ,ATTRIBUTE186
                                                                                                               ,ATTRIBUTE187
                                                                                                               ,ATTRIBUTE188
                                                                                                               ,ATTRIBUTE189
                                                                                                               ,ATTRIBUTE190
                                                                                                               ,ATTRIBUTE191
                                                                                                               ,ATTRIBUTE192
                                                                                                               ,ATTRIBUTE193
                                                                                                               ,ATTRIBUTE194
                                                                                                               ,ATTRIBUTE195
                                                                                                               ,ATTRIBUTE196
                                                                                                               ,ATTRIBUTE197
                                                                                                               ,ATTRIBUTE198
                                                                                                               ,ATTRIBUTE199
                                                                                                               ,ATTRIBUTE200)) X
                               WHERE  1 = 1
                               AND    LTRIM(RTRIM(VALUE)) IS NOT NULL
                               AND    VALUE != '0'
                               AND    VALUE IS NOT NULL
                               GROUP  BY UPLOAD_ID) B) SRC_UPD
                ON (A.UPLOAD_ID = SRC_UPD.UPLOAD_ID AND SRC_UPD.PRICE > 0)
                WHEN MATCHED THEN
                    UPDATE
                    SET    UPLOAD_STATUS_CODE = 'ERROR'
                          ,MESSAGE_TEXT       = 'This file contains invalid quantity data such as ''Alphabet'', ''NUMBER'', etc. (e.g. a, b, c, 130.2, 50.4 …).';

            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '13';
                V_LOG_MESSAGE := '########## Invalid Measure Group. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Upload UOM.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
                        WHERE  L.SEGMENT1 = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE11
                        AND    L.LOOKUP_TYPE = 'UPLOAD_UOM_TYPE_CODE'
                        AND    L.VALID_YN = 'Y');
            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '14';
                V_LOG_MESSAGE := '########## Invalid Upload UOM. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            -- Upload UOM by Model
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'ERROR', MESSAGE_TEXT = 'Invalid Upload UOM Costpmer FCST.'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD'
                AND    NOT EXISTS (SELECT 1
                        FROM   DM_MST_CUSTOMER_FCST CF, SCM_MST_DIVISION D2
                        WHERE  CF.DIVISION_ID = D2.DIVISION_ID
                        AND    CF.SCM_SITE_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                        AND    CF.MEASURE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE10
                        AND    (D2.DIVISION_ID = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1 OR D2.DIVISION_NAME = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1)
                        AND    CF.VALID_YN = 'Y');

            END;

            BEGIN
                -- ---------------------------------------------------------------------
                --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
                V_LOG_TYPE    := '15';
                V_LOG_MESSAGE := '########## Invalid Upload UOM Costpmer FCST. ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- ---------------------------------------------------------------------
            END;

            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Project.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.VALID_YN              = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Project ', SQL%ROWCOUNT, 9, TRUE);
            v_log_type := '16';
            v_log_message := '########## Invalid Project. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            /*
            BEGIN
            UPDATE SCM_ADM_EXCEL_UPLOAD
            SET    UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Model.'
            WHERE  PROGRAM_ID         = v_program_id
            AND    SHEET_NAME         = v_sheet_name
            AND    CREATED_BY         = p_created_by
            AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = v_creation_date
            AND    UPLOAD_STATUS_CODE = 'UPLOAD'
            AND NOT EXISTS (SELECT 1
                            FROM   DM_MST_CUSTOMER_MODEL CM
                            WHERE  CM.DIVISION_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE1
                            AND    CM.SCM_SITE_ID           = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE2
                            AND    CM.CUSTOMER_PROJECT_CODE = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE4
                            AND    CM.CUSTOMER_MODEL        = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE5
                            AND    CM.PROJECT_CODE          = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE12
                            AND    CM.ITEM_ID               = SCM_ADM_EXCEL_UPLOAD.ATTRIBUTE13
                            AND    CM.VALID_YN              = 'Y');
            END;

            BEGIN
            -- ---------------------------------------------------------------------
            --scm2_mgr.xLOG('Invalid Model ', SQL%ROWCOUNT, 10, TRUE);
            v_log_type := '17';
            v_log_message := '########## Invalid Model. ##########';
            v_description := NULL;
            d_event_date := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date);
            -- ---------------------------------------------------------------------
            END;
            */
            BEGIN
                UPDATE SCM_ADM_EXCEL_UPLOAD
                SET    UPLOAD_STATUS_CODE = 'SUCCESS'
                WHERE  PROGRAM_ID = V_PROGRAM_ID
                AND    SHEET_NAME = V_SHEET_NAME
                AND    CREATED_BY = P_CREATED_BY
                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                AND    UPLOAD_STATUS_CODE = 'UPLOAD';
            END;

            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '16';
                V_LOG_MESSAGE := '########## SUCCESS ##########';
                V_DESCRIPTION := NULL;
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;

        END IF;

        BEGIN
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '17';
            V_LOG_MESSAGE := '########## INSERT INTO DATA START ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------
        END;

        --// SCM_UI_EXCEL_UPLOAD_T =>  DMR_CAPA_ALLOC_M
        --//======================================================================================
        SELECT COUNT(1)
        INTO   V_COUNT
        FROM   SCM_ADM_EXCEL_UPLOAD T
        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
        AND    T.SHEET_NAME = V_SHEET_NAME
        AND    T.CREATED_BY = P_CREATED_BY
        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
        AND    T.UPLOAD_STATUS_CODE = 'ERROR';

        DBMS_OUTPUT.PUT_LINE('■■■■■ Start1 v_count: ' || TO_CHAR(V_COUNT)); --20240604 SM

        -- Update Mode and No Errors
        IF P_MODE > 0 AND V_COUNT = 0 THEN
            BEGIN
                V_START_YYYYMMDD := NULL;
                V_END_YYYYMMDD   := NULL;
            END;

            BEGIN
                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '18';
                V_LOG_MESSAGE := '########## DELETE FROM DATE START ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;

            BEGIN
                SELECT D.MIN_YYYYMMDD, D.MAX_YYYYMMDD
                INTO   V_START_YYYYMMDD, V_END_YYYYMMDD
                FROM   (SELECT MIN(YYYYMMDD) MIN_YYYYMMDD, MAX(YYYYMMDD) MAX_YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN( --ATTRIBUTE12, ATTRIBUTE13,   --20240605 sm (일자셋팅이 14부터 시작이라 14부터로 처리되도록 수정)
                                                                                                             ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X
                        WHERE  X.YYYYMMDD IS NOT NULL) D;
            END;

            BEGIN

                DBMS_OUTPUT.PUT_LINE('■■■■■v_start_yyyymmdd: ' || V_START_YYYYMMDD);
                DBMS_OUTPUT.PUT_LINE('■■■■■v_end_yyyymmdd:   ' || V_END_YYYYMMDD);

                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '19-1';
                V_LOG_MESSAGE := '########## DELETE FROM DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;

            -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
            BEGIN

                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '20-1';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
                DELETE FROM DM_PLN_CUSTOMER_PSI
                WHERE  1 = 1
                AND    MEASURE_GROUP = 'CUST_FCST'
                      -- modified by ytchoi 180305  incoterms, fcst_type, dom_exp 조건 없어서 추가.
                AND    (SELECT COUNT(1)
                        FROM   SCM_ADM_EXCEL_UPLOAD T
                        WHERE  T.PROGRAM_ID = V_PROGRAM_ID
                        AND    T.SHEET_NAME = V_SHEET_NAME
                        AND    T.CREATED_BY = P_CREATED_BY
                        AND    TO_CHAR(T.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                        AND    T.UPLOAD_STATUS_CODE = 'SUCCESS'
                        AND    DM_PLN_CUSTOMER_PSI.DIVISION_ID = T.ATTRIBUTE1
                        AND    DM_PLN_CUSTOMER_PSI.SCM_SITE_ID = T.ATTRIBUTE2
                        AND    DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID = T.ATTRIBUTE3
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE = T.ATTRIBUTE4
                        AND    DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL = T.ATTRIBUTE5
                        AND    DM_PLN_CUSTOMER_PSI.INCOTERMS = T.ATTRIBUTE6
                        AND    DM_PLN_CUSTOMER_PSI.FCST_TYPE = T.ATTRIBUTE7
                        AND    DM_PLN_CUSTOMER_PSI.DOM_EXP = T.ATTRIBUTE8
                        AND    DM_PLN_CUSTOMER_PSI.MEASURE = T.ATTRIBUTE10) > 0
                AND    YYYYMMDD BETWEEN V_START_YYYYMMDD AND V_END_YYYYMMDD;

                -- -------------------------------------------------------------------------
                --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
                V_LOG_TYPE    := '20';
                V_LOG_MESSAGE := '########## DELETE FROM DM_PLN_CUSTOMER_PSI DATE END ##########';
                V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
                D_EVENT_DATE  := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
                -- -------------------------------------------------------------------------
            END;
            DBMS_OUTPUT.PUT_LINE('20');

            -- 엑셀로 업로드된 MEASURE를 MASTER의 MEASURE로 변경
            UPDATE SCM_ADM_EXCEL_UPLOAD AA
            SET    ATTRIBUTE10 =
                   (SELECT BB.MEASURE
                    FROM   (SELECT DISTINCT A.DIVISION_ID, B.DIVISION_NAME, A.SCM_SITE_ID, A.VALID_YN, A.MEASURE, A.UPLOAD_UOM, A.UPLOAD_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST A
                            INNER  JOIN SCM_MST_DIVISION B
                            ON     A.VALID_YN = 'Y'
                            AND    A.DIVISION_ID = B.DIVISION_ID) BB
                    WHERE  (BB.DIVISION_ID = AA.ATTRIBUTE1 OR BB.DIVISION_NAME = AA.ATTRIBUTE1)
                    AND    BB.SCM_SITE_ID = AA.ATTRIBUTE2
                    AND    BB.MEASURE = AA.ATTRIBUTE10
                    AND    BB.UPLOAD_UOM = AA.ATTRIBUTE11
                    AND    BB.UPLOAD_BUCKET_TYPE IN (SELECT CASE (NVL(TO_DATE(Z.ATTRIBUTE16, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD'), TO_DATE(Z.ATTRIBUTE15, 'YYYYMMDD') - TO_DATE(Z.ATTRIBUTE14, 'YYYYMMDD')))  /* [BUCKET FIX 07-06] 부분 첫주(월1일)=2~3번째 일자 간격(완전주) 우선 */
                                                                WHEN 1 THEN
                                                                 'DAILY'
                                                                WHEN 7 THEN
                                                                 'WEEKLY'
                                                                ELSE
                                                                 'MONTHLY'
                                                            END
                                                     FROM   SCM_ADM_EXCEL_UPLOAD Z
                                                     WHERE  Z.PROGRAM_ID = V_PROGRAM_ID
                                                     AND    Z.SHEET_NAME = V_SHEET_NAME
                                                     AND    Z.CREATED_BY = P_CREATED_BY
                                                     AND    TO_CHAR(Z.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                                     AND    Z.UPLOAD_STATUS_CODE = 'V_TITLE')
                    FETCH  FIRST 1 ROWS ONLY)
            WHERE  AA.PROGRAM_ID = V_PROGRAM_ID
            AND    AA.SHEET_NAME = V_SHEET_NAME
            AND    AA.CREATED_BY = P_CREATED_BY
            AND    AA.UPLOAD_STATUS_CODE = 'SUCCESS'
            AND    TO_CHAR(AA.CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
            AND    EXISTS (SELECT 1
                    FROM   (SELECT DISTINCT A.DIVISION_ID, B.DIVISION_NAME, A.SCM_SITE_ID, A.MEASURE, A.UPLOAD_UOM, A.UPLOAD_BUCKET_TYPE
                            FROM   DM_MST_CUSTOMER_FCST A
                            INNER  JOIN SCM_MST_DIVISION B
                            ON     A.VALID_YN = 'Y'
                            AND    A.DIVISION_ID = B.DIVISION_ID) BB
                    WHERE  (BB.DIVISION_ID = AA.ATTRIBUTE1 OR BB.DIVISION_NAME = AA.ATTRIBUTE1)
                    AND    BB.SCM_SITE_ID = AA.ATTRIBUTE2
                    AND    BB.MEASURE = AA.ATTRIBUTE10
                    AND    BB.UPLOAD_UOM = AA.ATTRIBUTE11);

            DBMS_OUTPUT.PUT_LINE('20240605-21');

            INSERT INTO DM_PLN_CUSTOMER_PSI
                (DIVISION_ID
                ,SCM_SITE_ID
                ,PLANT_SITE_ID
                ,CUSTOMER_PROJECT_CODE
                ,CUSTOMER_MODEL
                ,INCOTERMS
                ,FCST_TYPE
                ,DOM_EXP
                ,MEASURE_GROUP
                ,MEASURE
                ,UPLOAD_UOM
                ,PROJECT_CODE
                ,ITEM_ID
                ,YYYYMMDD
                ,QTY
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,BATCH_RESULT)
                SELECT V.ATTRIBUTE1
                      ,V.ATTRIBUTE2
                      ,V.ATTRIBUTE3
                      ,V.ATTRIBUTE4
                      ,V.ATTRIBUTE5
                      ,V.ATTRIBUTE6
                      ,V.ATTRIBUTE7
                      ,V.ATTRIBUTE8
                      ,V.ATTRIBUTE9
                      ,V.ATTRIBUTE10
                      ,V.ATTRIBUTE11
                      ,V.ATTRIBUTE12
                      ,V.ATTRIBUTE13
                      ,C.YYYYMMDD
                      ,TO_NUMBER(V.VALUE)
                      ,P_CREATED_BY
                      ,TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,P_CREATED_BY
                      ,TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF3')
                      ,'UI'
                FROM   (SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,YYYYMMDD
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                      -- modified by ytchoi 180305
                                      -- AND    CREATION_DATE = v_creation_date
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'V_TITLE') T UNPIVOT(YYYYMMDD FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                            ,ATTRIBUTE15
                                                                                                            ,ATTRIBUTE16
                                                                                                            ,ATTRIBUTE17
                                                                                                            ,ATTRIBUTE18
                                                                                                            ,ATTRIBUTE19
                                                                                                            ,ATTRIBUTE20
                                                                                                            ,ATTRIBUTE21
                                                                                                            ,ATTRIBUTE22
                                                                                                            ,ATTRIBUTE23
                                                                                                            ,ATTRIBUTE24
                                                                                                            ,ATTRIBUTE25
                                                                                                            ,ATTRIBUTE26
                                                                                                            ,ATTRIBUTE27
                                                                                                            ,ATTRIBUTE28
                                                                                                            ,ATTRIBUTE29
                                                                                                            ,ATTRIBUTE30
                                                                                                            ,ATTRIBUTE31
                                                                                                            ,ATTRIBUTE32
                                                                                                            ,ATTRIBUTE33
                                                                                                            ,ATTRIBUTE34
                                                                                                            ,ATTRIBUTE35
                                                                                                            ,ATTRIBUTE36
                                                                                                            ,ATTRIBUTE37
                                                                                                            ,ATTRIBUTE38
                                                                                                            ,ATTRIBUTE39
                                                                                                            ,ATTRIBUTE40
                                                                                                            ,ATTRIBUTE41
                                                                                                            ,ATTRIBUTE42
                                                                                                            ,ATTRIBUTE43
                                                                                                            ,ATTRIBUTE44
                                                                                                            ,ATTRIBUTE45
                                                                                                            ,ATTRIBUTE46
                                                                                                            ,ATTRIBUTE47
                                                                                                            ,ATTRIBUTE48
                                                                                                            ,ATTRIBUTE49
                                                                                                            ,ATTRIBUTE50
                                                                                                            ,ATTRIBUTE51
                                                                                                            ,ATTRIBUTE52
                                                                                                            ,ATTRIBUTE53
                                                                                                            ,ATTRIBUTE54
                                                                                                            ,ATTRIBUTE55
                                                                                                            ,ATTRIBUTE56
                                                                                                            ,ATTRIBUTE57
                                                                                                            ,ATTRIBUTE58
                                                                                                            ,ATTRIBUTE59
                                                                                                            ,ATTRIBUTE60
                                                                                                            ,ATTRIBUTE61
                                                                                                            ,ATTRIBUTE62
                                                                                                            ,ATTRIBUTE63
                                                                                                            ,ATTRIBUTE64
                                                                                                            ,ATTRIBUTE65
                                                                                                            ,ATTRIBUTE66
                                                                                                            ,ATTRIBUTE67
                                                                                                            ,ATTRIBUTE68
                                                                                                            ,ATTRIBUTE69
                                                                                                            ,ATTRIBUTE70
                                                                                                            ,ATTRIBUTE71
                                                                                                            ,ATTRIBUTE72
                                                                                                            ,ATTRIBUTE73
                                                                                                            ,ATTRIBUTE74
                                                                                                            ,ATTRIBUTE75
                                                                                                            ,ATTRIBUTE76
                                                                                                            ,ATTRIBUTE77
                                                                                                            ,ATTRIBUTE78
                                                                                                            ,ATTRIBUTE79
                                                                                                            ,ATTRIBUTE80
                                                                                                            ,ATTRIBUTE81
                                                                                                            ,ATTRIBUTE82
                                                                                                            ,ATTRIBUTE83
                                                                                                            ,ATTRIBUTE84
                                                                                                            ,ATTRIBUTE85
                                                                                                            ,ATTRIBUTE86
                                                                                                            ,ATTRIBUTE87
                                                                                                            ,ATTRIBUTE88
                                                                                                            ,ATTRIBUTE89
                                                                                                            ,ATTRIBUTE90
                                                                                                            ,ATTRIBUTE91
                                                                                                            ,ATTRIBUTE92
                                                                                                            ,ATTRIBUTE93
                                                                                                            ,ATTRIBUTE94
                                                                                                            ,ATTRIBUTE95
                                                                                                            ,ATTRIBUTE96
                                                                                                            ,ATTRIBUTE97
                                                                                                            ,ATTRIBUTE98
                                                                                                            ,ATTRIBUTE99
                                                                                                            ,ATTRIBUTE100
                                                                                                            ,ATTRIBUTE101
                                                                                                            ,ATTRIBUTE102
                                                                                                            ,ATTRIBUTE103
                                                                                                            ,ATTRIBUTE104
                                                                                                            ,ATTRIBUTE105
                                                                                                            ,ATTRIBUTE106
                                                                                                            ,ATTRIBUTE107
                                                                                                            ,ATTRIBUTE108
                                                                                                            ,ATTRIBUTE109
                                                                                                            ,ATTRIBUTE110
                                                                                                            ,ATTRIBUTE111
                                                                                                            ,ATTRIBUTE112
                                                                                                            ,ATTRIBUTE113
                                                                                                            ,ATTRIBUTE114
                                                                                                            ,ATTRIBUTE115
                                                                                                            ,ATTRIBUTE116
                                                                                                            ,ATTRIBUTE117
                                                                                                            ,ATTRIBUTE118
                                                                                                            ,ATTRIBUTE119
                                                                                                            ,ATTRIBUTE120
                                                                                                            ,ATTRIBUTE121
                                                                                                            ,ATTRIBUTE122
                                                                                                            ,ATTRIBUTE123
                                                                                                            ,ATTRIBUTE124
                                                                                                            ,ATTRIBUTE125
                                                                                                            ,ATTRIBUTE126
                                                                                                            ,ATTRIBUTE127
                                                                                                            ,ATTRIBUTE128
                                                                                                            ,ATTRIBUTE129
                                                                                                            ,ATTRIBUTE130
                                                                                                            ,ATTRIBUTE131
                                                                                                            ,ATTRIBUTE132
                                                                                                            ,ATTRIBUTE133
                                                                                                            ,ATTRIBUTE134
                                                                                                            ,ATTRIBUTE135
                                                                                                            ,ATTRIBUTE136
                                                                                                            ,ATTRIBUTE137
                                                                                                            ,ATTRIBUTE138
                                                                                                            ,ATTRIBUTE139
                                                                                                            ,ATTRIBUTE140
                                                                                                            ,ATTRIBUTE141
                                                                                                            ,ATTRIBUTE142
                                                                                                            ,ATTRIBUTE143
                                                                                                            ,ATTRIBUTE144
                                                                                                            ,ATTRIBUTE145
                                                                                                            ,ATTRIBUTE146
                                                                                                            ,ATTRIBUTE147
                                                                                                            ,ATTRIBUTE148
                                                                                                            ,ATTRIBUTE149
                                                                                                            ,ATTRIBUTE150
                                                                                                            ,ATTRIBUTE151
                                                                                                            ,ATTRIBUTE152
                                                                                                            ,ATTRIBUTE153
                                                                                                            ,ATTRIBUTE154
                                                                                                            ,ATTRIBUTE155
                                                                                                            ,ATTRIBUTE156
                                                                                                            ,ATTRIBUTE157
                                                                                                            ,ATTRIBUTE158
                                                                                                            ,ATTRIBUTE159
                                                                                                            ,ATTRIBUTE160
                                                                                                            ,ATTRIBUTE161
                                                                                                            ,ATTRIBUTE162
                                                                                                            ,ATTRIBUTE163
                                                                                                            ,ATTRIBUTE164
                                                                                                            ,ATTRIBUTE165
                                                                                                            ,ATTRIBUTE166
                                                                                                            ,ATTRIBUTE167
                                                                                                            ,ATTRIBUTE168
                                                                                                            ,ATTRIBUTE169
                                                                                                            ,ATTRIBUTE170
                                                                                                            ,ATTRIBUTE171
                                                                                                            ,ATTRIBUTE172
                                                                                                            ,ATTRIBUTE173
                                                                                                            ,ATTRIBUTE174
                                                                                                            ,ATTRIBUTE175
                                                                                                            ,ATTRIBUTE176
                                                                                                            ,ATTRIBUTE177
                                                                                                            ,ATTRIBUTE178
                                                                                                            ,ATTRIBUTE179
                                                                                                            ,ATTRIBUTE180
                                                                                                            ,ATTRIBUTE181
                                                                                                            ,ATTRIBUTE182
                                                                                                            ,ATTRIBUTE183
                                                                                                            ,ATTRIBUTE184
                                                                                                            ,ATTRIBUTE185
                                                                                                            ,ATTRIBUTE186
                                                                                                            ,ATTRIBUTE187
                                                                                                            ,ATTRIBUTE188
                                                                                                            ,ATTRIBUTE189
                                                                                                            ,ATTRIBUTE190
                                                                                                            ,ATTRIBUTE191
                                                                                                            ,ATTRIBUTE192
                                                                                                            ,ATTRIBUTE193
                                                                                                            ,ATTRIBUTE194
                                                                                                            ,ATTRIBUTE195
                                                                                                            ,ATTRIBUTE196
                                                                                                            ,ATTRIBUTE197
                                                                                                            ,ATTRIBUTE198
                                                                                                            ,ATTRIBUTE199
                                                                                                            ,ATTRIBUTE200)) X) C
                      ,(SELECT ATTRIBUTE1
                              ,ATTRIBUTE2
                              ,ATTRIBUTE3
                              ,ATTRIBUTE4
                              ,ATTRIBUTE5
                              ,ATTRIBUTE6
                              ,ATTRIBUTE7
                              ,ATTRIBUTE8
                              ,ATTRIBUTE9
                              ,ATTRIBUTE10
                              ,ATTRIBUTE11
                              ,ATTRIBUTE12
                              ,ATTRIBUTE13
                              ,COLUMN_NAME
                              ,VALUE
                        FROM   (SELECT ATTRIBUTE1
                                      ,ATTRIBUTE2
                                      ,ATTRIBUTE3
                                      ,ATTRIBUTE4
                                      ,ATTRIBUTE5
                                      ,ATTRIBUTE6
                                      ,ATTRIBUTE7
                                      ,ATTRIBUTE8
                                      ,ATTRIBUTE9
                                      ,ATTRIBUTE10
                                      ,ATTRIBUTE11
                                      ,ATTRIBUTE12
                                      ,ATTRIBUTE13
                                      ,ATTRIBUTE14
                                      ,ATTRIBUTE15
                                      ,ATTRIBUTE16
                                      ,ATTRIBUTE17
                                      ,ATTRIBUTE18
                                      ,ATTRIBUTE19
                                      ,ATTRIBUTE20
                                      ,ATTRIBUTE21
                                      ,ATTRIBUTE22
                                      ,ATTRIBUTE23
                                      ,ATTRIBUTE24
                                      ,ATTRIBUTE25
                                      ,ATTRIBUTE26
                                      ,ATTRIBUTE27
                                      ,ATTRIBUTE28
                                      ,ATTRIBUTE29
                                      ,ATTRIBUTE30
                                      ,ATTRIBUTE31
                                      ,ATTRIBUTE32
                                      ,ATTRIBUTE33
                                      ,ATTRIBUTE34
                                      ,ATTRIBUTE35
                                      ,ATTRIBUTE36
                                      ,ATTRIBUTE37
                                      ,ATTRIBUTE38
                                      ,ATTRIBUTE39
                                      ,ATTRIBUTE40
                                      ,ATTRIBUTE41
                                      ,ATTRIBUTE42
                                      ,ATTRIBUTE43
                                      ,ATTRIBUTE44
                                      ,ATTRIBUTE45
                                      ,ATTRIBUTE46
                                      ,ATTRIBUTE47
                                      ,ATTRIBUTE48
                                      ,ATTRIBUTE49
                                      ,ATTRIBUTE50
                                      ,ATTRIBUTE51
                                      ,ATTRIBUTE52
                                      ,ATTRIBUTE53
                                      ,ATTRIBUTE54
                                      ,ATTRIBUTE55
                                      ,ATTRIBUTE56
                                      ,ATTRIBUTE57
                                      ,ATTRIBUTE58
                                      ,ATTRIBUTE59
                                      ,ATTRIBUTE60
                                      ,ATTRIBUTE61
                                      ,ATTRIBUTE62
                                      ,ATTRIBUTE63
                                      ,ATTRIBUTE64
                                      ,ATTRIBUTE65
                                      ,ATTRIBUTE66
                                      ,ATTRIBUTE67
                                      ,ATTRIBUTE68
                                      ,ATTRIBUTE69
                                      ,ATTRIBUTE70
                                      ,ATTRIBUTE71
                                      ,ATTRIBUTE72
                                      ,ATTRIBUTE73
                                      ,ATTRIBUTE74
                                      ,ATTRIBUTE75
                                      ,ATTRIBUTE76
                                      ,ATTRIBUTE77
                                      ,ATTRIBUTE78
                                      ,ATTRIBUTE79
                                      ,ATTRIBUTE80
                                      ,ATTRIBUTE81
                                      ,ATTRIBUTE82
                                      ,ATTRIBUTE83
                                      ,ATTRIBUTE84
                                      ,ATTRIBUTE85
                                      ,ATTRIBUTE86
                                      ,ATTRIBUTE87
                                      ,ATTRIBUTE88
                                      ,ATTRIBUTE89
                                      ,ATTRIBUTE90
                                      ,ATTRIBUTE91
                                      ,ATTRIBUTE92
                                      ,ATTRIBUTE93
                                      ,ATTRIBUTE94
                                      ,ATTRIBUTE95
                                      ,ATTRIBUTE96
                                      ,ATTRIBUTE97
                                      ,ATTRIBUTE98
                                      ,ATTRIBUTE99
                                      ,ATTRIBUTE100
                                      ,ATTRIBUTE101
                                      ,ATTRIBUTE102
                                      ,ATTRIBUTE103
                                      ,ATTRIBUTE104
                                      ,ATTRIBUTE105
                                      ,ATTRIBUTE106
                                      ,ATTRIBUTE107
                                      ,ATTRIBUTE108
                                      ,ATTRIBUTE109
                                      ,ATTRIBUTE110
                                      ,ATTRIBUTE111
                                      ,ATTRIBUTE112
                                      ,ATTRIBUTE113
                                      ,ATTRIBUTE114
                                      ,ATTRIBUTE115
                                      ,ATTRIBUTE116
                                      ,ATTRIBUTE117
                                      ,ATTRIBUTE118
                                      ,ATTRIBUTE119
                                      ,ATTRIBUTE120
                                      ,ATTRIBUTE121
                                      ,ATTRIBUTE122
                                      ,ATTRIBUTE123
                                      ,ATTRIBUTE124
                                      ,ATTRIBUTE125
                                      ,ATTRIBUTE126
                                      ,ATTRIBUTE127
                                      ,ATTRIBUTE128
                                      ,ATTRIBUTE129
                                      ,ATTRIBUTE130
                                      ,ATTRIBUTE131
                                      ,ATTRIBUTE132
                                      ,ATTRIBUTE133
                                      ,ATTRIBUTE134
                                      ,ATTRIBUTE135
                                      ,ATTRIBUTE136
                                      ,ATTRIBUTE137
                                      ,ATTRIBUTE138
                                      ,ATTRIBUTE139
                                      ,ATTRIBUTE140
                                      ,ATTRIBUTE141
                                      ,ATTRIBUTE142
                                      ,ATTRIBUTE143
                                      ,ATTRIBUTE144
                                      ,ATTRIBUTE145
                                      ,ATTRIBUTE146
                                      ,ATTRIBUTE147
                                      ,ATTRIBUTE148
                                      ,ATTRIBUTE149
                                      ,ATTRIBUTE150
                                      ,ATTRIBUTE151
                                      ,ATTRIBUTE152
                                      ,ATTRIBUTE153
                                      ,ATTRIBUTE154
                                      ,ATTRIBUTE155
                                      ,ATTRIBUTE156
                                      ,ATTRIBUTE157
                                      ,ATTRIBUTE158
                                      ,ATTRIBUTE159
                                      ,ATTRIBUTE160
                                      ,ATTRIBUTE161
                                      ,ATTRIBUTE162
                                      ,ATTRIBUTE163
                                      ,ATTRIBUTE164
                                      ,ATTRIBUTE165
                                      ,ATTRIBUTE166
                                      ,ATTRIBUTE167
                                      ,ATTRIBUTE168
                                      ,ATTRIBUTE169
                                      ,ATTRIBUTE170
                                      ,ATTRIBUTE171
                                      ,ATTRIBUTE172
                                      ,ATTRIBUTE173
                                      ,ATTRIBUTE174
                                      ,ATTRIBUTE175
                                      ,ATTRIBUTE176
                                      ,ATTRIBUTE177
                                      ,ATTRIBUTE178
                                      ,ATTRIBUTE179
                                      ,ATTRIBUTE180
                                      ,ATTRIBUTE181
                                      ,ATTRIBUTE182
                                      ,ATTRIBUTE183
                                      ,ATTRIBUTE184
                                      ,ATTRIBUTE185
                                      ,ATTRIBUTE186
                                      ,ATTRIBUTE187
                                      ,ATTRIBUTE188
                                      ,ATTRIBUTE189
                                      ,ATTRIBUTE190
                                      ,ATTRIBUTE191
                                      ,ATTRIBUTE192
                                      ,ATTRIBUTE193
                                      ,ATTRIBUTE194
                                      ,ATTRIBUTE195
                                      ,ATTRIBUTE196
                                      ,ATTRIBUTE197
                                      ,ATTRIBUTE198
                                      ,ATTRIBUTE199
                                      ,ATTRIBUTE200
                                FROM   SCM_ADM_EXCEL_UPLOAD
                                WHERE  1 = 1
                                AND    PROGRAM_ID = V_PROGRAM_ID
                                AND    SHEET_NAME = V_SHEET_NAME
                                AND    CREATED_BY = P_CREATED_BY
                                AND    TO_CHAR(CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS.FF3') = V_CREATION_DATE
                                AND    UPLOAD_STATUS_CODE = 'SUCCESS') T UNPIVOT(VALUE FOR COLUMN_NAME IN(ATTRIBUTE14
                                                                                                         ,ATTRIBUTE15
                                                                                                         ,ATTRIBUTE16
                                                                                                         ,ATTRIBUTE17
                                                                                                         ,ATTRIBUTE18
                                                                                                         ,ATTRIBUTE19
                                                                                                         ,ATTRIBUTE20
                                                                                                         ,ATTRIBUTE21
                                                                                                         ,ATTRIBUTE22
                                                                                                         ,ATTRIBUTE23
                                                                                                         ,ATTRIBUTE24
                                                                                                         ,ATTRIBUTE25
                                                                                                         ,ATTRIBUTE26
                                                                                                         ,ATTRIBUTE27
                                                                                                         ,ATTRIBUTE28
                                                                                                         ,ATTRIBUTE29
                                                                                                         ,ATTRIBUTE30
                                                                                                         ,ATTRIBUTE31
                                                                                                         ,ATTRIBUTE32
                                                                                                         ,ATTRIBUTE33
                                                                                                         ,ATTRIBUTE34
                                                                                                         ,ATTRIBUTE35
                                                                                                         ,ATTRIBUTE36
                                                                                                         ,ATTRIBUTE37
                                                                                                         ,ATTRIBUTE38
                                                                                                         ,ATTRIBUTE39
                                                                                                         ,ATTRIBUTE40
                                                                                                         ,ATTRIBUTE41
                                                                                                         ,ATTRIBUTE42
                                                                                                         ,ATTRIBUTE43
                                                                                                         ,ATTRIBUTE44
                                                                                                         ,ATTRIBUTE45
                                                                                                         ,ATTRIBUTE46
                                                                                                         ,ATTRIBUTE47
                                                                                                         ,ATTRIBUTE48
                                                                                                         ,ATTRIBUTE49
                                                                                                         ,ATTRIBUTE50
                                                                                                         ,ATTRIBUTE51
                                                                                                         ,ATTRIBUTE52
                                                                                                         ,ATTRIBUTE53
                                                                                                         ,ATTRIBUTE54
                                                                                                         ,ATTRIBUTE55
                                                                                                         ,ATTRIBUTE56
                                                                                                         ,ATTRIBUTE57
                                                                                                         ,ATTRIBUTE58
                                                                                                         ,ATTRIBUTE59
                                                                                                         ,ATTRIBUTE60
                                                                                                         ,ATTRIBUTE61
                                                                                                         ,ATTRIBUTE62
                                                                                                         ,ATTRIBUTE63
                                                                                                         ,ATTRIBUTE64
                                                                                                         ,ATTRIBUTE65
                                                                                                         ,ATTRIBUTE66
                                                                                                         ,ATTRIBUTE67
                                                                                                         ,ATTRIBUTE68
                                                                                                         ,ATTRIBUTE69
                                                                                                         ,ATTRIBUTE70
                                                                                                         ,ATTRIBUTE71
                                                                                                         ,ATTRIBUTE72
                                                                                                         ,ATTRIBUTE73
                                                                                                         ,ATTRIBUTE74
                                                                                                         ,ATTRIBUTE75
                                                                                                         ,ATTRIBUTE76
                                                                                                         ,ATTRIBUTE77
                                                                                                         ,ATTRIBUTE78
                                                                                                         ,ATTRIBUTE79
                                                                                                         ,ATTRIBUTE80
                                                                                                         ,ATTRIBUTE81
                                                                                                         ,ATTRIBUTE82
                                                                                                         ,ATTRIBUTE83
                                                                                                         ,ATTRIBUTE84
                                                                                                         ,ATTRIBUTE85
                                                                                                         ,ATTRIBUTE86
                                                                                                         ,ATTRIBUTE87
                                                                                                         ,ATTRIBUTE88
                                                                                                         ,ATTRIBUTE89
                                                                                                         ,ATTRIBUTE90
                                                                                                         ,ATTRIBUTE91
                                                                                                         ,ATTRIBUTE92
                                                                                                         ,ATTRIBUTE93
                                                                                                         ,ATTRIBUTE94
                                                                                                         ,ATTRIBUTE95
                                                                                                         ,ATTRIBUTE96
                                                                                                         ,ATTRIBUTE97
                                                                                                         ,ATTRIBUTE98
                                                                                                         ,ATTRIBUTE99
                                                                                                         ,ATTRIBUTE100
                                                                                                         ,ATTRIBUTE101
                                                                                                         ,ATTRIBUTE102
                                                                                                         ,ATTRIBUTE103
                                                                                                         ,ATTRIBUTE104
                                                                                                         ,ATTRIBUTE105
                                                                                                         ,ATTRIBUTE106
                                                                                                         ,ATTRIBUTE107
                                                                                                         ,ATTRIBUTE108
                                                                                                         ,ATTRIBUTE109
                                                                                                         ,ATTRIBUTE110
                                                                                                         ,ATTRIBUTE111
                                                                                                         ,ATTRIBUTE112
                                                                                                         ,ATTRIBUTE113
                                                                                                         ,ATTRIBUTE114
                                                                                                         ,ATTRIBUTE115
                                                                                                         ,ATTRIBUTE116
                                                                                                         ,ATTRIBUTE117
                                                                                                         ,ATTRIBUTE118
                                                                                                         ,ATTRIBUTE119
                                                                                                         ,ATTRIBUTE120
                                                                                                         ,ATTRIBUTE121
                                                                                                         ,ATTRIBUTE122
                                                                                                         ,ATTRIBUTE123
                                                                                                         ,ATTRIBUTE124
                                                                                                         ,ATTRIBUTE125
                                                                                                         ,ATTRIBUTE126
                                                                                                         ,ATTRIBUTE127
                                                                                                         ,ATTRIBUTE128
                                                                                                         ,ATTRIBUTE129
                                                                                                         ,ATTRIBUTE130
                                                                                                         ,ATTRIBUTE131
                                                                                                         ,ATTRIBUTE132
                                                                                                         ,ATTRIBUTE133
                                                                                                         ,ATTRIBUTE134
                                                                                                         ,ATTRIBUTE135
                                                                                                         ,ATTRIBUTE136
                                                                                                         ,ATTRIBUTE137
                                                                                                         ,ATTRIBUTE138
                                                                                                         ,ATTRIBUTE139
                                                                                                         ,ATTRIBUTE140
                                                                                                         ,ATTRIBUTE141
                                                                                                         ,ATTRIBUTE142
                                                                                                         ,ATTRIBUTE143
                                                                                                         ,ATTRIBUTE144
                                                                                                         ,ATTRIBUTE145
                                                                                                         ,ATTRIBUTE146
                                                                                                         ,ATTRIBUTE147
                                                                                                         ,ATTRIBUTE148
                                                                                                         ,ATTRIBUTE149
                                                                                                         ,ATTRIBUTE150
                                                                                                         ,ATTRIBUTE151
                                                                                                         ,ATTRIBUTE152
                                                                                                         ,ATTRIBUTE153
                                                                                                         ,ATTRIBUTE154
                                                                                                         ,ATTRIBUTE155
                                                                                                         ,ATTRIBUTE156
                                                                                                         ,ATTRIBUTE157
                                                                                                         ,ATTRIBUTE158
                                                                                                         ,ATTRIBUTE159
                                                                                                         ,ATTRIBUTE160
                                                                                                         ,ATTRIBUTE161
                                                                                                         ,ATTRIBUTE162
                                                                                                         ,ATTRIBUTE163
                                                                                                         ,ATTRIBUTE164
                                                                                                         ,ATTRIBUTE165
                                                                                                         ,ATTRIBUTE166
                                                                                                         ,ATTRIBUTE167
                                                                                                         ,ATTRIBUTE168
                                                                                                         ,ATTRIBUTE169
                                                                                                         ,ATTRIBUTE170
                                                                                                         ,ATTRIBUTE171
                                                                                                         ,ATTRIBUTE172
                                                                                                         ,ATTRIBUTE173
                                                                                                         ,ATTRIBUTE174
                                                                                                         ,ATTRIBUTE175
                                                                                                         ,ATTRIBUTE176
                                                                                                         ,ATTRIBUTE177
                                                                                                         ,ATTRIBUTE178
                                                                                                         ,ATTRIBUTE179
                                                                                                         ,ATTRIBUTE180
                                                                                                         ,ATTRIBUTE181
                                                                                                         ,ATTRIBUTE182
                                                                                                         ,ATTRIBUTE183
                                                                                                         ,ATTRIBUTE184
                                                                                                         ,ATTRIBUTE185
                                                                                                         ,ATTRIBUTE186
                                                                                                         ,ATTRIBUTE187
                                                                                                         ,ATTRIBUTE188
                                                                                                         ,ATTRIBUTE189
                                                                                                         ,ATTRIBUTE190
                                                                                                         ,ATTRIBUTE191
                                                                                                         ,ATTRIBUTE192
                                                                                                         ,ATTRIBUTE193
                                                                                                         ,ATTRIBUTE194
                                                                                                         ,ATTRIBUTE195
                                                                                                         ,ATTRIBUTE196
                                                                                                         ,ATTRIBUTE197
                                                                                                         ,ATTRIBUTE198
                                                                                                         ,ATTRIBUTE199
                                                                                                         ,ATTRIBUTE200)) X) V
                WHERE  1 = 1
                AND    C.COLUMN_NAME = V.COLUMN_NAME
                AND    C.YYYYMMDD IS NOT NULL
                AND    V.VALUE IS NOT NULL;

            DBMS_OUTPUT.PUT_LINE('21');
            -- -------------------------------------------------------------------------
            --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
            V_LOG_TYPE    := '21';
            V_LOG_MESSAGE := '########## INSERT INTO DM_PLN_CUSTOMER_PSI DATE END ##########';
            V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
            D_EVENT_DATE  := SYSTIMESTAMP;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
            -- -------------------------------------------------------------------------

            IF V_DIVISION = '40' THEN
                PR_DM_PLN_CUST_FCST_TO_MKT_FCST_40('40');
                --2026-03-30 김준규 아래는 dm 에서 하지 않는 것으로 정리함.
                /*ELSE
                DBMS_OUTPUT.PUT_LINE('20240605-PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM');
                                PR_DM_PLN_CUST_FCST_TO_MKT_FCST_SM;*/
            END IF;

            COMMIT;
            --COMMIT ;
            -- END TRY
        END IF;
        -- -------------------------------------------------------------------------
        --scm2_mgr.xLOG('SUCCESS              ', SQL%ROWCOUNT, 10, TRUE);
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## INSERT INTO DATA END ##########';
        V_DESCRIPTION := P_MODE; --TO_CHAR(v_creation_date, 'YYYY-MM-DD HH24:MI:SS.FF3');
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        -- -------------------------------------------------------------------------

        COMMIT;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,'ERROR'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM;

    PROCEDURE P_DMF0014_GET_CUST_FCST_UPLOAD_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       , --, p_debug OUT VARCHAR2
        P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    /*
         DMF0014_GET_CUST_FCST_UPLOAD_DATA(p_division_id='81', p_dept_id='ALL', p_end_customer='ALL', p_scm_site_id='ALL', p_plant_site_id='ALL', p_project_code = NULL);
         , p_item_id = NULL, p_start_yyyymmdd='20230904', p_end_yyyymmdd='20240310', p_bucket_type='WEEKLY', p_dom_exp='ALL', p_created_by='chano0612', p_userinfo='ADMIN'
        */
     AS

        V_PROGRAM_NAME   VARCHAR2(200) := $$PLSQL_UNIT;
        V_SQL_TEXT       CLOB;  -- [CLOB FIX 07-06] 32767->CLOB (GET DAILY 184col>32767)
        V_ITERATION      CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (GET WEEKLY 27col 누적>4000 ORA-06502)
        V_COLUMN_TEXT    VARCHAR2(200 CHAR);
        V_COLUMN_NAME    VARCHAR2(50 CHAR);
        V_YYYYMMDD       VARCHAR2(8 CHAR);
        V_START_YYYYMMDD VARCHAR2(8 CHAR);
        V_GROUP_ID       VARCHAR2(50 CHAR) := NULL;
        V_CNT_1          INTEGER := 0;
        V_IN_PARA_DATA   VARCHAR2(4000);
        V_STEP           VARCHAR2(4000 CHAR) := NULL;
        V_LOG_TYPE       VARCHAR2(20) := NULL;
        N_LOG_COUNT      NUMBER := 0;
        V_LOG_MESSAGE    VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION    VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE     DATE := SYSDATE;
        V_PROC_INPUT     CLOB := NULL;
        V_SQL_CODE       VARCHAR2(100) := NULL;
        V_SQL_ERRMSG     VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE      VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                     ,'p_dept_id' VALUE P_DEPT_ID
                                     ,'p_end_customer' VALUE P_END_CUSTOMER
                                     ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                     ,'p_plant_site_id' VALUE P_PLANT_SITE_ID
                                     ,'p_project_code' VALUE P_PROJECT_CODE
                                     ,'p_item_id' VALUE P_ITEM_ID
                                     ,'p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_bucket_type' VALUE P_BUCKET_TYPE
                                     ,'p_dom_exp' VALUE P_DOM_EXP
                                     ,'p_created_by' VALUE P_CREATED_BY);

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        --  v_group_id := 'ADMIN'
        -- ------------------------------------------------------------------------------
        --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
        -- ------------------------------------------------------------------------------
        SELECT COUNT(1)
        INTO   V_CNT_1
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN = 'Y'
        AND    SEGMENT2 = 'ALL' -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함
        AND    SEGMENT1 = P_USERINFO;
        IF V_CNT_1 > 0 THEN
            V_GROUP_ID := 'ADMIN';
        END IF;
        -- ------------------------------------------------------------------------------
        --            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
        -- ------------------------------------------------------------------------------
        SELECT A.BASIS_START_DATE INTO V_START_YYYYMMDD FROM SCM_SYS_CALENDAR_M A WHERE A.BASIS_YYYYMMDD = P_START_YYYYMMDD;

        V_ITERATION := NULL;

        IF P_BUCKET_TYPE = 'DAILY' THEN
            -- c_cust_fcst CURSOR FAST_FORWARD FOR
            FOR REC IN (SELECT 'D_' || BASIS_YYYYMMDD AS COLUMN_NAME, BASIS_YYYYMMDD YYYYMMDD
                        FROM   SCM_SYS_CALENDAR_M A
                        WHERE  A.BASIS_YYYYMMDD >= V_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                        AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                        ORDER  BY COLUMN_NAME) LOOP

                V_COLUMN_NAME := REC.COLUMN_NAME;
                V_YYYYMMDD    := REC.YYYYMMDD;
                V_COLUMN_TEXT := ', SUM(CASE WHEN CP.YYYYMMDD = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';

                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_yyyymmdd', V_YYYYMMDD);
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_column_name', V_COLUMN_NAME);

                V_ITERATION := V_ITERATION || V_COLUMN_TEXT;

            END LOOP;

        ELSIF P_BUCKET_TYPE = 'WEEKLY' THEN
            -- c_cust_fcst CURSOR FAST_FORWARD FOR
            FOR REC IN (SELECT 'D_' || MIN(A.BASIS_START_DATE) COLUMN_NAME, A.ISO_YYYYWW --A.BASIS_YYYYMM + MIN(SUBSTR('00' || TO_CHAR(TO_NUMBER(TO_CHAR(A.BASIS_START_DATE, 'IW')), 'YYYY-MM-DD'), -2)) YYYYMMDD
                        FROM   SCM_SYS_CALENDAR_M A
                        WHERE  A.BASIS_YYYYMMDD >= V_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                        AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                        GROUP  BY A.ISO_YYYYWW, A.WEEK_NAME
                        ORDER  BY COLUMN_NAME) LOOP

                V_COLUMN_NAME := REC.COLUMN_NAME;
                V_YYYYMMDD    := REC.ISO_YYYYWW;

                V_COLUMN_TEXT := ', SUM(CASE WHEN SUBSTR(CP.YYYYMMDD, 1, 4) || LPAD(TO_CHAR(TO_DATE(CP.YYYYMMDD, ''YYYYMMDD''), ''IW''), 2, ''0'') = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';

                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_yyyymmdd', V_YYYYMMDD);
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_column_name', V_COLUMN_NAME);

                V_ITERATION := V_ITERATION || V_COLUMN_TEXT;

            END LOOP;

        ELSIF P_BUCKET_TYPE = 'MONTHLY' THEN
            -- c_cust_fcst CURSOR FAST_FORWARD FOR
            FOR REC IN (SELECT 'D_' || MIN(A.BASIS_YYYYMM) || '01' AS COLUMN_NAME, MIN(A.BASIS_YYYYMM) YYYYMMDD
                        FROM   SCM_SYS_CALENDAR_M A
                        WHERE  A.BASIS_YYYYMMDD >= V_START_YYYYMMDD --TO_CHAR(CURRENT_TIMESTAMP, 'YYYYMMDD')
                        AND    A.BASIS_YYYYMMDD <= P_END_YYYYMMDD --TO_CHAR(ADD_MONTHS(CURRENT_TIMESTAMP, 6), 'YYYYMMDD')
                        GROUP  BY A.MONTH_NAME
                        ORDER  BY COLUMN_NAME) LOOP

                V_COLUMN_NAME := REC.COLUMN_NAME;
                V_YYYYMMDD    := REC.YYYYMMDD;
                V_COLUMN_TEXT := ', SUM(CASE WHEN SUBSTR(CP.YYYYMMDD, 1, 6) = ''v_yyyymmdd'' THEN CP.QTY ELSE NULL END) AS v_column_name ';

                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_yyyymmdd', V_YYYYMMDD);
                V_COLUMN_TEXT := REPLACE(V_COLUMN_TEXT, 'v_column_name', V_COLUMN_NAME);

                V_ITERATION := V_ITERATION || V_COLUMN_TEXT;

            END LOOP;
        END IF;

        V_SQL_TEXT := ';
        SELECT CP.DIVISION_ID
             , CP.SCM_SITE_ID
             , CP.PLANT_SITE_ID
             , CP.CUSTOMER_PROJECT_CODE
             , CP.CUSTOMER_MODEL
             , CP.INCOTERMS
             , CP.FCST_TYPE
             , CP.DOM_EXP
             , CP.MEASURE_GROUP
             , CP.MEASURE
             , CP.UPLOAD_UOM
             , CP.PROJECT_CODE
             , CP.ITEM_ID
        --[PJ2024-50461] Team Mapping------------------------------------
             --, CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', S.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
                --THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
             --, CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', TEAM.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
             --   THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
             -- 2026-04-01 김준규 SCM_MST_SITE_ITEM 의 DEPT_ID를 사용 시작
             , CASE WHEN ((FN_GET_DEPT_LIST(''p_created_by'', ITM.DEPT_ID) = ''Y'') OR ''v_group_id'' =''ADMIN'')
                THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
             -- 2026-04-01 김준규 SCM_MST_SITE_ITEM 의 DEPT_ID를 사용 종료
        --[PJ2024-50461] Team Mapping------------------------------------
             v_iteration
             ,MAX(TEI.EDIT_YN) EDIT_YN
        FROM   DM_PLN_CUSTOMER_PSI CP
        INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(''' || P_USER_ID || ''', ''' || P_MENU_ID || ''')) TEI
        ON     TEI.UNIT_ID = CP.DIVISION_ID
           --, SCM_MST_SITE        S
        --[PJ2024-50611] 명시적으로 INNER JOIN 처리 START
        INNER JOIN  SCM_MST_SITE        S
            ON CP.DIVISION_ID   = S.DIVISION_ID
            AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        --[PJ2024-50611] 명시적으로 INNER JOIN 처리 END
--[PJ2024-50461] Team Mapping------------------------------------
            LEFT OUTER JOIN SCM_MST_SITE_ITEM ITM
                ON S.DIVISION_ID = ITM.DIVISION_ID
                AND S.SCM_SITE_ID = ITM.SCM_SITE_ID
                AND CP.PROJECT_CODE = ITM.PROJECT_CODE--[PJ2024-50611] 조인 추가
                AND CP.ITEM_ID = ITM.ITEM_ID--[PJ2024-50611] 조인 추가
         -- 2026-04-01 김준규 팀 변경 필요 없게 됨 시작
         --LEFT JOIN (
         --    SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID
         --    FROM SCM_MST_SSO_USER_INFO B
         --    INNER JOIN SCM_MST_SSO_DEPT_INFO C
         --    ON B.DEPT_ID = C.DEPT_ID
         --) TEAM
         --ON
         --TEAM.USER_ID   IN (SELECT value FROM TABLE(fn_splitstring(ITM.owner, '','')))
         -- 2026-04-01 김준규 팀 변경 필요 없게 됨 종료
--[PJ2024-50461] Team Mapping------------------------------------
        WHERE  1 = 1
        AND    CP.DIVISION_ID   = S.DIVISION_ID
        AND    CP.SCM_SITE_ID   = S.SCM_SITE_ID
        AND    CP.MEASURE_GROUP = ''CUST_FCST''
        p_division_id
        p_dept_id
        p_scm_site_id
        p_plant_site_id
        p_project_code
        p_item_id
        p_dom_exp
        p_end_customer
        AND    CP.YYYYMMDD BETWEEN ''p_start_yyyymmdd'' AND ''p_end_yyyymmdd''
        AND    CP.MEASURE IN (SELECT DISTINCT MEASURE
                              FROM   DM_MST_CUSTOMER_FCST X
                              WHERE  1 = 1
                              AND    X.DIVISION_ID = CP.DIVISION_ID
                              AND    X.SCM_SITE_ID = CP.SCM_SITE_ID -- 해당 SITE에 연결된 Measure만 구함.
                              AND    X.UPLOAD_BUCKET_TYPE = ''p_bucket_type''
                              AND    X.VALID_YN = ''Y''
                            )
        GROUP BY CP.DIVISION_ID
        --[PJ2024-50461] Team Mapping------------------------------------
               --, S.DEPT_ID
               --, TEAM.DEPT_ID
               , ITM.DEPT_ID
        --[PJ2024-50461] Team Mapping------------------------------------
               , CP.SCM_SITE_ID
               , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
               , CP.INCOTERMS
               , CP.FCST_TYPE
               , CP.DOM_EXP
               , CP.MEASURE_GROUP
               , CP.MEASURE
               , CP.UPLOAD_UOM
               , CP.PROJECT_CODE
               , CP.ITEM_ID
        ORDER BY CP.DIVISION_ID
               , CP.SCM_SITE_ID
               , CP.PLANT_SITE_ID
               , CP.CUSTOMER_PROJECT_CODE
               , CP.CUSTOMER_MODEL
       ';

        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_iteration', V_ITERATION);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_division_id', FN_SCM_GET_WHERE_SQL('CP.DIVISION_ID', 'IN', P_DIVISION_ID));
        --[PJ2024-50461] Team Mapping------------------------------------
        --V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id', FN_SCM_GET_WHERE_SQL('TEAM.DEPT_ID', 'IN', P_DEPT_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dept_id', FN_SCM_GET_WHERE_SQL('ITM.DEPT_ID', 'IN', P_DEPT_ID));
        --[PJ2024-50461] Team Mapping------------------------------------
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_customer', FN_SCM_GET_WHERE_SQL('S.END_CUSTOMER', 'IN', P_END_CUSTOMER));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_scm_site_id', FN_SCM_GET_WHERE_SQL('CP.SCM_SITE_ID', 'IN', P_SCM_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_plant_site_id', FN_SCM_GET_WHERE_SQL('CP.PLANT_SITE_ID', 'IN', P_PLANT_SITE_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_project_code', FN_SCM_GET_WHERE_SQL('CP.PROJECT_CODE', 'IN', P_PROJECT_CODE));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_item_id', FN_SCM_GET_WHERE_SQL('CP.ITEM_ID', 'IN', P_ITEM_ID));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_dom_exp', FN_SCM_GET_WHERE_SQL('CP.DOM_EXP', 'IN', P_DOM_EXP));
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_start_yyyymmdd', V_START_YYYYMMDD);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_end_yyyymmdd', P_END_YYYYMMDD);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_bucket_type', P_BUCKET_TYPE);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'p_created_by', P_CREATED_BY);
        V_SQL_TEXT := REPLACE(V_SQL_TEXT, 'v_group_id', V_GROUP_ID);

        --p_debug := v_sql_text;
        --RETURN p_debug;
        --SELECT v_sql_text;

        -- [PJ202650304] 2026-07-04 PTT(ORA$PTT_RESULT) 제거 — definer-rights 롤 비활성 ORA-01031 회피
        --   (SCM_MGR CREATE TABLE 권한은 롤 경유뿐 → CREATE PRIVATE TEMPORARY TABLE 실패. PTT 는
        --    빈 CTAS(WHERE 1=2)→INSERT→'SELECT *' 단순 재방출 구조였으므로 동적 SQL 직접 OPEN 등가 치환
        --    — DMF0048 PTT fix 선례. 본 멤버(L5680~)는 GTT/트랜잭션 미사용 순수 SELECT 실측)
        OPEN O_RC1 FOR REPLACE(V_SQL_TEXT, ';', '');

        --p_plan_week, p_division_code, p_customer_id, p_fcst_sit_id, p_measure, p_edi_fcst_yn, p_valid_yn;
        --xml확인할경우
        --SELECT TO_CLOB(v_sql_text)
        --FROM DUAL;
        COMMIT;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE   := 'ERROR';
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SQLERRM;
            V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,V_PROC_INPUT
                                ,V_SQL_CODE
                                ,V_SQL_ERRMSG
                                ,V_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_GET_CUST_FCST_UPLOAD_DATA;

    PROCEDURE P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
    (
        P_ACTIVE_FLAG           VARCHAR2
       ,P_DIVISION_ID           VARCHAR2
       ,P_SCM_SITE_ID           VARCHAR2
       ,P_CUSTOMER_PROJECT_CODE VARCHAR2
       ,P_CUSTOMER_MODEL        VARCHAR2
       ,P_INCOTERMS             VARCHAR2
       ,P_FCST_TYPE             VARCHAR2
       ,P_DOM_EXP               VARCHAR2
       ,P_MEASURE_GROUP         VARCHAR2
       ,P_MEASURE               VARCHAR2
       ,P_PLANT_SITE_ID         VARCHAR2
       ,P_UPLOAD_UOM            VARCHAR2
       ,P_PROJECT_CODE          VARCHAR2
       ,P_ITEM_ID               VARCHAR2
       ,P_YYYYMMDD              VARCHAR2
       ,P_QTY                   VARCHAR2
       ,P_CREATED_BY            VARCHAR2
       ,O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0014_SAVE_CUST_FCST_UPLOAD_DATA
        * Description  : SAVE CUST FCST UPLOAD DATA
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 2018. 03. 28    KHSONG     Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
        * 2022. 10. 26      KDW2819      [C20221024-000507]CUST FCST Upload 오류 수정
        * 2026.03.24      김준규            [PJ20264226] NextSCM Pilot 설계 및 개발
        */
     AS

        V_IN_PARA_DATA                VARCHAR2(4000);
        V_RECV_ACTIVE_FLAG            CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_ACTIVE_FLAG                 VARCHAR2(4000 CHAR);
        V_DIVISION_ID                 VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID                 VARCHAR2(4000 CHAR);
        V_CUSTOMER_PROJECT_CODE       VARCHAR2(4000 CHAR);
        V_CUSTOMER_MODEL              VARCHAR2(4000 CHAR);
        V_INCOTERMS                   VARCHAR2(4000 CHAR);
        V_FCST_TYPE                   VARCHAR2(4000 CHAR);
        V_DOM_EXP                     VARCHAR2(4000 CHAR);
        V_MEASURE_GROUP               VARCHAR2(4000 CHAR);
        V_MEASURE                     VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID               VARCHAR2(4000 CHAR);
        V_UPLOAD_UOM                  VARCHAR2(4000 CHAR);
        V_PROJECT_CODE                VARCHAR2(4000 CHAR);
        V_ITEM_ID                     VARCHAR2(4000 CHAR);
        V_YYYYMMDD                    VARCHAR2(4000 CHAR);
        V_QTY                         VARCHAR2(4000 CHAR);
        V_CREATED_BY                  VARCHAR2(4000 CHAR);
        V_DELIMITER                   VARCHAR2(1 CHAR);
        V_MAX_LOOP_CNT                INTEGER := 0;
        V_MST_LOOP_CNT                INTEGER := 0;
        V_PROGRAM_NAME                VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE                    VARCHAR2(30 CHAR);
        N_LOG_COUNT                   INTEGER := 0;
        V_LOG_MESSAGE                 VARCHAR2(1000 CHAR);
        V_DESCRIPTION                 VARCHAR2(500 CHAR);
        D_EVENT_DATE                  DATE;
        V_INDEX_ACTIVE_FLAG           INTEGER;
        V_INDEX_DIVISION_ID           INTEGER;
        V_INDEX_SCM_SITE_ID           INTEGER;
        V_INDEX_CUSTOMER_PROJECT_CODE INTEGER;
        V_INDEX_CUSTOMER_MODEL        INTEGER;
        V_INDEX_INCOTERMS             INTEGER;
        V_INDEX_FCST_TYPE             INTEGER;
        V_INDEX_DOM_EXP               INTEGER;
        V_INDEX_MEASURE_GROUP         INTEGER;
        V_INDEX_MEASURE               INTEGER;
        V_INDEX_PLANT_SITE_ID         INTEGER;
        V_INDEX_UPLOAD_UOM            INTEGER;
        V_INDEX_PROJECT_CODE          INTEGER;
        V_INDEX_ITEM_ID               INTEGER;
        V_INDEX_YYYYMMDD              INTEGER;
        V_INDEX_QTY                   INTEGER;
        V_INDEX_CREATED_BY            INTEGER;
        V_P_ACTIVE_FLAG               CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_DIVISION_ID               CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_SCM_SITE_ID               CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_CUSTOMER_PROJECT_CODE     CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_CUSTOMER_MODEL            CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_INCOTERMS                 CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_FCST_TYPE                 CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_DOM_EXP                   CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_MEASURE_GROUP             CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_MEASURE                   CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_PLANT_SITE_ID             CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_UPLOAD_UOM                CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_PROJECT_CODE              CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_ITEM_ID                   CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_YYYYMMDD                  CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_QTY                       CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
        V_P_CREATED_BY                CLOB;  -- [CLOB FIX 07-06] 4000->CLOB (SAVE 다건 ^페이로드 홀더)
    BEGIN

        NULL;

        V_RECV_ACTIVE_FLAG := NULL;
        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

        -- 멀티처리 변수선언
        V_ACTIVE_FLAG           := NULL;
        V_DIVISION_ID           := NULL;
        V_SCM_SITE_ID           := NULL;
        V_CUSTOMER_PROJECT_CODE := NULL;
        V_CUSTOMER_MODEL        := NULL;
        V_INCOTERMS             := NULL;
        V_FCST_TYPE             := NULL;
        V_DOM_EXP               := NULL;
        V_MEASURE_GROUP         := NULL;
        V_MEASURE               := NULL;
        V_PLANT_SITE_ID         := NULL;
        V_UPLOAD_UOM            := NULL;
        V_PROJECT_CODE          := NULL;
        V_ITEM_ID               := NULL;
        V_YYYYMMDD              := NULL;
        V_QTY                   := NULL;
        V_CREATED_BY            := NULL;

        V_DELIMITER := '^';

        V_P_ACTIVE_FLAG           := RTRIM(P_ACTIVE_FLAG) || '^';
        V_P_DIVISION_ID           := RTRIM(P_DIVISION_ID) || '^';
        V_P_SCM_SITE_ID           := RTRIM(P_SCM_SITE_ID) || '^';
        V_P_CUSTOMER_PROJECT_CODE := RTRIM(P_CUSTOMER_PROJECT_CODE) || '^';
        V_P_CUSTOMER_MODEL        := RTRIM(P_CUSTOMER_MODEL) || '^';
        V_P_INCOTERMS             := RTRIM(P_INCOTERMS) || '^';
        V_P_FCST_TYPE             := RTRIM(P_FCST_TYPE) || '^';
        V_P_DOM_EXP               := RTRIM(P_DOM_EXP) || '^';
        V_P_MEASURE_GROUP         := RTRIM(P_MEASURE_GROUP) || '^';
        V_P_MEASURE               := RTRIM(P_MEASURE) || '^';
        V_P_PLANT_SITE_ID         := RTRIM(P_PLANT_SITE_ID) || '^';
        V_P_UPLOAD_UOM            := RTRIM(P_UPLOAD_UOM) || '^';
        V_P_PROJECT_CODE          := RTRIM(P_PROJECT_CODE) || '^';
        V_P_ITEM_ID               := RTRIM(P_ITEM_ID) || '^';
        V_P_YYYYMMDD              := RTRIM(P_YYYYMMDD) || '^';
        V_P_QTY                   := RTRIM(P_QTY) || '^';
        V_P_CREATED_BY            := RTRIM(P_CREATED_BY) || '^';

        -- GT_SCFU_RESULTS TEMP TABLE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SCFU_RESULTS';

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/

        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

        --===================================================================================== GT_SCFU_RESULTS 테이블에 split후 INSERT INTO start
        --###############################################  GT_SCFU_RESULTS 테이블에 split후 insert (START)
        WHILE LENGTH(V_P_DIVISION_ID) > 0 LOOP

            V_INDEX_ACTIVE_FLAG           := INSTR(V_P_ACTIVE_FLAG, '^');
            V_INDEX_DIVISION_ID           := INSTR(V_P_DIVISION_ID, '^');
            V_INDEX_SCM_SITE_ID           := INSTR(V_P_SCM_SITE_ID, '^');
            V_INDEX_CUSTOMER_PROJECT_CODE := INSTR(V_P_CUSTOMER_PROJECT_CODE, '^');
            V_INDEX_CUSTOMER_MODEL        := INSTR(V_P_CUSTOMER_MODEL, '^');
            V_INDEX_INCOTERMS             := INSTR(V_P_INCOTERMS, '^');
            V_INDEX_FCST_TYPE             := INSTR(V_P_FCST_TYPE, '^');
            V_INDEX_DOM_EXP               := INSTR(V_P_DOM_EXP, '^');
            V_INDEX_MEASURE_GROUP         := INSTR(V_P_MEASURE_GROUP, '^');
            V_INDEX_MEASURE               := INSTR(V_P_MEASURE, '^');
            V_INDEX_PLANT_SITE_ID         := INSTR(V_P_PLANT_SITE_ID, '^');
            V_INDEX_UPLOAD_UOM            := INSTR(V_P_UPLOAD_UOM, '^');
            V_INDEX_PROJECT_CODE          := INSTR(V_P_PROJECT_CODE, '^');
            V_INDEX_ITEM_ID               := INSTR(V_P_ITEM_ID, '^');
            V_INDEX_YYYYMMDD              := INSTR(V_P_YYYYMMDD, '^');
            V_INDEX_QTY                   := INSTR(V_P_QTY, '^');
            V_INDEX_CREATED_BY            := INSTR(V_P_CREATED_BY, '^');

            --확인  select v_index_DIVISION_ID as 'v_index_DIVISION_ID';
            IF V_INDEX_DIVISION_ID > 0 THEN
                V_ACTIVE_FLAG           := SUBSTR(V_P_ACTIVE_FLAG, 1, V_INDEX_ACTIVE_FLAG - 1);
                V_DIVISION_ID           := SUBSTR(V_P_DIVISION_ID, 1, V_INDEX_DIVISION_ID - 1);
                V_SCM_SITE_ID           := SUBSTR(V_P_SCM_SITE_ID, 1, V_INDEX_SCM_SITE_ID - 1);
                V_CUSTOMER_PROJECT_CODE := SUBSTR(V_P_CUSTOMER_PROJECT_CODE, 1, V_INDEX_CUSTOMER_PROJECT_CODE - 1);
                V_CUSTOMER_MODEL        := SUBSTR(V_P_CUSTOMER_MODEL, 1, V_INDEX_CUSTOMER_MODEL - 1);
                V_INCOTERMS             := SUBSTR(V_P_INCOTERMS, 1, V_INDEX_INCOTERMS - 1);
                V_FCST_TYPE             := SUBSTR(V_P_FCST_TYPE, 1, V_INDEX_FCST_TYPE - 1);
                V_DOM_EXP               := SUBSTR(V_P_DOM_EXP, 1, V_INDEX_DOM_EXP - 1);
                V_MEASURE_GROUP         := SUBSTR(V_P_MEASURE_GROUP, 1, V_INDEX_MEASURE_GROUP - 1);
                V_MEASURE               := SUBSTR(V_P_MEASURE, 1, V_INDEX_MEASURE - 1);
                V_PLANT_SITE_ID         := SUBSTR(V_P_PLANT_SITE_ID, 1, V_INDEX_PLANT_SITE_ID - 1);
                V_UPLOAD_UOM            := SUBSTR(V_P_UPLOAD_UOM, 1, V_INDEX_UPLOAD_UOM - 1);
                V_PROJECT_CODE          := SUBSTR(V_P_PROJECT_CODE, 1, V_INDEX_PROJECT_CODE - 1);
                V_ITEM_ID               := SUBSTR(V_P_ITEM_ID, 1, V_INDEX_ITEM_ID - 1);
                V_YYYYMMDD              := SUBSTR(V_P_YYYYMMDD, 1, V_INDEX_YYYYMMDD - 1);
                V_QTY                   := SUBSTR(V_P_QTY, 1, V_INDEX_QTY - 1);
                V_CREATED_BY            := SUBSTR(V_P_CREATED_BY, 1, V_INDEX_CREATED_BY - 1);

                V_P_ACTIVE_FLAG           := SUBSTR(V_P_ACTIVE_FLAG, V_INDEX_ACTIVE_FLAG + 1);
                V_P_DIVISION_ID           := SUBSTR(V_P_DIVISION_ID, V_INDEX_DIVISION_ID + 1);
                V_P_SCM_SITE_ID           := SUBSTR(V_P_SCM_SITE_ID, V_INDEX_SCM_SITE_ID + 1);
                V_P_CUSTOMER_PROJECT_CODE := SUBSTR(V_P_CUSTOMER_PROJECT_CODE, V_INDEX_CUSTOMER_PROJECT_CODE + 1);
                V_P_CUSTOMER_MODEL        := SUBSTR(V_P_CUSTOMER_MODEL, V_INDEX_CUSTOMER_MODEL + 1);
                V_P_INCOTERMS             := SUBSTR(V_P_INCOTERMS, V_INDEX_INCOTERMS + 1);
                V_P_FCST_TYPE             := SUBSTR(V_P_FCST_TYPE, V_INDEX_FCST_TYPE + 1);
                V_P_DOM_EXP               := SUBSTR(V_P_DOM_EXP, V_INDEX_DOM_EXP + 1);
                V_P_MEASURE_GROUP         := SUBSTR(V_P_MEASURE_GROUP, V_INDEX_MEASURE_GROUP + 1);
                V_P_MEASURE               := SUBSTR(V_P_MEASURE, V_INDEX_MEASURE + 1);
                V_P_PLANT_SITE_ID         := SUBSTR(V_P_PLANT_SITE_ID, V_INDEX_PLANT_SITE_ID + 1);
                V_P_UPLOAD_UOM            := SUBSTR(V_P_UPLOAD_UOM, V_INDEX_UPLOAD_UOM + 1);
                V_P_PROJECT_CODE          := SUBSTR(V_P_PROJECT_CODE, V_INDEX_PROJECT_CODE + 1);
                V_P_ITEM_ID               := SUBSTR(V_P_ITEM_ID, V_INDEX_ITEM_ID + 1);
                V_P_YYYYMMDD              := SUBSTR(V_P_YYYYMMDD, V_INDEX_YYYYMMDD + 1);
                V_P_QTY                   := SUBSTR(V_P_QTY, V_INDEX_QTY + 1);
                V_P_CREATED_BY            := SUBSTR(V_P_CREATED_BY, V_INDEX_CREATED_BY + 1);

                INSERT /*+ NO_PARALLEL */
                INTO GT_SCFU_RESULTS
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY)
                VALUES
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY);
            ELSE
                V_DIVISION_ID   := V_P_DIVISION_ID;
                V_P_DIVISION_ID := NULL;

                INSERT /*+ NO_PARALLEL */
                INTO GT_SCFU_RESULTS
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY)
                VALUES
                    (V_ACTIVE_FLAG
                    ,V_DIVISION_ID
                    ,V_SCM_SITE_ID
                    ,V_CUSTOMER_PROJECT_CODE
                    ,V_CUSTOMER_MODEL
                    ,V_INCOTERMS
                    ,V_FCST_TYPE
                    ,V_DOM_EXP
                    ,V_MEASURE_GROUP
                    ,V_MEASURE
                    ,V_PLANT_SITE_ID
                    ,V_UPLOAD_UOM
                    ,V_PROJECT_CODE
                    ,V_ITEM_ID
                    ,V_YYYYMMDD
                    ,V_QTY
                    ,V_CREATED_BY);
            END IF;
            -- if end
        END LOOP;
        --###############################################   GT_SCFU_RESULTS 테이블에 split후 insert (END)
        -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 start -----------------------------------------------
        --IF (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from DM_MST_CUSTOMER_MODEL
        --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
        -- AND
        -- (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from SCM_MST_SITE_ITEM
        --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
        --begin
        -- v_log_type := 'INVALID';
        -- SELECT '['|| v_customer_project_code ||']'|| ' Invalid Customer Project !';
        -- goto err_rtn
        --end
        --IF (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from DM_MST_CUSTOMER_MODEL
        --    where DIVISION_ID  = v_DIVISION_ID AND CUSTOMER_PROJECT_CODE = v_CUSTOMER_PROJECT_CODE AND CUSTOMER_MODEL = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) = 0
        -- AND
        -- (select count(1)  from GT_SCFU_RESULTS where ( select count(1) from SCM_MST_SITE_ITEM
        --    where DIVISION_ID  = v_DIVISION_ID AND PROJECT_CODE = v_PROJECT_CODE AND ITEM_ID = v_CUSTOMER_MODEL AND SCM_SITE_ID = v_SCM_SITE_ID ) = 0 ) > 0
        --begin
        -- v_log_type := 'INVALID';
        -- SELECT '['|| v_customer_project_code ||']'|| ' Invalid Customer Model !';
        -- goto err_rtn
        --end
        -- Customer Project,Customer Model  잘못들어왔을때 강제 에러발생시킴 end  -----------------------------------------------
        --SELECT * FROM GT_SCFU_RESULTS
        --===================================================================================== INSERT INTO 전 DELETE FROM start
        BEGIN
            -- 확인  select * from GT_SCFU_RESULTS
            DELETE FROM DM_PLN_CUSTOMER_PSI
            WHERE  (SELECT COUNT(1)
                    FROM   GT_SCFU_RESULTS G
                    WHERE  1 = 1
                    /* [V20260708-4] 치명 결함 수정 — GT_SCFU_RESULTS 컬럼은 V_ prefix.
                       무prefix 는 GT에 없어 외부 DM_PLN_CUSTOMER_PSI 자기참조(항상 참)로 해석
                       → 저장 1건에도 테이블 전체 삭제되던 버그. G.V_* 로 정확 상관. */
                    AND    G.V_DIVISION_ID = DM_PLN_CUSTOMER_PSI.DIVISION_ID
                    AND    G.V_CUSTOMER_PROJECT_CODE = DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE
                    AND    G.V_CUSTOMER_MODEL = DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL
                    AND    G.V_SCM_SITE_ID = DM_PLN_CUSTOMER_PSI.SCM_SITE_ID
                    AND    G.V_DOM_EXP = DM_PLN_CUSTOMER_PSI.DOM_EXP
                    AND    G.V_FCST_TYPE = DM_PLN_CUSTOMER_PSI.FCST_TYPE
                    AND    G.V_MEASURE_GROUP = DM_PLN_CUSTOMER_PSI.MEASURE_GROUP
                    AND    G.V_MEASURE = DM_PLN_CUSTOMER_PSI.MEASURE
                    AND    G.V_YYYYMMDD = DM_PLN_CUSTOMER_PSI.YYYYMMDD
                    AND    G.V_INCOTERMS = DM_PLN_CUSTOMER_PSI.INCOTERMS
                    AND    G.V_PLANT_SITE_ID = DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID) > 0;
        END;

        --===================================================================================== INSERT INTO 전 DELETE FROM end
        --===================================================================================== INSERT INTO start
        BEGIN

            INSERT INTO DM_PLN_CUSTOMER_PSI
                SELECT V_DIVISION_ID
                      ,V_CUSTOMER_PROJECT_CODE
                      ,V_CUSTOMER_MODEL
                      ,V_SCM_SITE_ID
                      ,V_DOM_EXP
                      ,V_FCST_TYPE
                      ,V_MEASURE_GROUP
                      ,V_MEASURE
                      ,V_YYYYMMDD
                      ,V_INCOTERMS
                      ,V_PLANT_SITE_ID
                      ,V_PROJECT_CODE
                      ,V_ITEM_ID
                      ,V_QTY
                      ,V_UPLOAD_UOM
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,'UI' --BATCH_RESULT
                      ,NULL --MST_UPLOAD_UOM
                      ,NULL --MST_UPLOAD_BUCKET_TYPE
                      ,NULL --MST_SUMMARY_BUCKET_TYPE
                      ,NULL --MST_CONVERT_QTY
                      ,NULL --PLAN_WEEK
                      ,NULL --SPLIT_RESULT
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                FROM   GT_SCFU_RESULTS;

        END;

        --===================================================================================== INSERT INTO end
        -- 시작과 종료일자 사이에 정보를 일괄 update 함. added by ytchoi 180314
        UPDATE DM_PLN_CUSTOMER_PSI
        SET    BATCH_RESULT = 'UI'
        WHERE  (SELECT COUNT(1)
                FROM   (SELECT DIVISION_ID
                              ,SCM_SITE_ID
                              ,CUSTOMER_PROJECT_CODE
                              ,CUSTOMER_MODEL
                              ,INCOTERMS
                              ,FCST_TYPE
                              ,DOM_EXP
                              ,MEASURE_GROUP
                              ,MEASURE
                              ,PLANT_SITE_ID
                              ,MIN(YYYYMMDD) MIN_YYYYMMDD
                              ,MAX(YYYYMMDD) MAX_YYYYMMDD
                        FROM   DM_PLN_CUSTOMER_PSI
                        WHERE  BATCH_RESULT = 'UI'
                        GROUP  BY DIVISION_ID
                                 ,SCM_SITE_ID
                                 ,CUSTOMER_PROJECT_CODE
                                 ,CUSTOMER_MODEL
                                 ,INCOTERMS
                                 ,FCST_TYPE
                                 ,DOM_EXP
                                 ,MEASURE_GROUP
                                 ,MEASURE
                                 ,PLANT_SITE_ID) A
                WHERE  A.DIVISION_ID = DM_PLN_CUSTOMER_PSI.DIVISION_ID
                AND    A.SCM_SITE_ID = DM_PLN_CUSTOMER_PSI.SCM_SITE_ID
                AND    A.CUSTOMER_PROJECT_CODE = DM_PLN_CUSTOMER_PSI.CUSTOMER_PROJECT_CODE
                AND    A.CUSTOMER_MODEL = DM_PLN_CUSTOMER_PSI.CUSTOMER_MODEL
                AND    A.INCOTERMS = DM_PLN_CUSTOMER_PSI.INCOTERMS
                AND    A.FCST_TYPE = DM_PLN_CUSTOMER_PSI.FCST_TYPE
                AND    A.DOM_EXP = DM_PLN_CUSTOMER_PSI.DOM_EXP
                AND    A.MEASURE_GROUP = DM_PLN_CUSTOMER_PSI.MEASURE_GROUP
                AND    A.MEASURE = DM_PLN_CUSTOMER_PSI.MEASURE
                AND    A.PLANT_SITE_ID = DM_PLN_CUSTOMER_PSI.PLANT_SITE_ID
                AND    DM_PLN_CUSTOMER_PSI.YYYYMMDD BETWEEN A.MIN_YYYYMMDD AND A.MAX_YYYYMMDD) > 0;

        --===================================================================================== HISTORY INSERT INTO start
        BEGIN

            INSERT INTO DM_PLN_CUSTOMER_PSI_H
                SELECT V_DIVISION_ID
                      ,SEQ1_DM_PLN_CUSTOMER_PSI_H.NEXTVAL
                      ,V_CUSTOMER_PROJECT_CODE
                      ,V_CUSTOMER_MODEL
                      ,V_SCM_SITE_ID
                      ,V_DOM_EXP
                      ,V_FCST_TYPE
                      ,V_MEASURE_GROUP
                      ,V_MEASURE
                      ,V_YYYYMMDD
                      ,V_INCOTERMS
                      ,V_PLANT_SITE_ID
                      ,V_PROJECT_CODE
                      ,V_ITEM_ID
                      ,TO_NUMBER(V_QTY)
                      ,V_UPLOAD_UOM
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,V_CREATED_BY
                      ,SYSDATE
                      ,'UI'
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                FROM   GT_SCFU_RESULTS;

        END;

        --===================================================================================== HISTORY INSERT INTO end
        BEGIN
            PR_DM_PLN_CUST_FCST_TO_MKT_FCST;
        END;

        COMMIT;

        -- END TRY

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            -- ERROR LOG
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
            D_EVENT_DATE  := SYSTIMESTAMP;
            NULL;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            -- END CATCH

            -- 종료 LOG
            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := NULL;
            D_EVENT_DATE  := SYSTIMESTAMP;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || V_PROGRAM_NAME || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA;


    ------------------------------------------------------------------------------------------------
    -- [E20260814-EXCELFORM] DMF0014 Excel Form 조회 (hook #135 — Excel Form/Upload 표준)
    --   요구: "EXCEL UPLOAD 기능이 있는 경우 DMF0082 의 EXCEL FORM/UPLOAD 양식을 기본 RULE 로"
    --   계약:
    --     · IN  = 메인 GET(P_DMF0014_GET_CUST_FCST_UPLOAD_DATA) 과 **동일 축·동일 이름 15개**
    --             → FE 가 store.filters 를 가공 없이 전달하면 그대로 성립한다.
    --     · OUT = 업로드 양식의 **정보 컬럼 13종**(SCM_ADM_EXCEL_COLUMNS.HEADER_CONTENT
    --             ATTRIBUTE1~13 과 1:1). 값 컬럼 W27~W31(ATTRIBUTE14~18)은 **입력 전용**이라
    --             SP 가 내리지 않는다 — FE 가 빈칸으로 채운다(hook #135 §3-4).
    --     · 본문은 메인 GET 의 FROM/WHERE 를 그대로 쓰고 **동적 기간 컬럼(v_iteration)만 제외**한다.
    --       (조회조건에 걸린 데이터 = 양식 대상 이라는 §3-1 정의를 구조적으로 보장)
    ------------------------------------------------------------------------------------------------
    PROCEDURE P_DMF0014_GET_EXCEL_FORM_DATA
    (
        P_DIVISION_ID    VARCHAR2
       ,P_DEPT_ID        VARCHAR2
       ,P_END_CUSTOMER   VARCHAR2
       ,P_SCM_SITE_ID    VARCHAR2
       ,P_PLANT_SITE_ID  VARCHAR2
       ,P_PROJECT_CODE   VARCHAR2
       ,P_ITEM_ID        VARCHAR2
       ,P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_BUCKET_TYPE    VARCHAR2
       ,P_DOM_EXP        VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_USERINFO       VARCHAR2
       ,P_USER_ID        VARCHAR2
       ,P_MENU_ID        VARCHAR2
       ,O_RC1            OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR  OUT SYS_REFCURSOR
    )
    AS
        V_PROGRAM_NAME VARCHAR2(200) := $$PLSQL_UNIT;
        V_SQL_TEXT     CLOB;
        V_GROUP_ID     VARCHAR2(50 CHAR) := NULL;
        V_CNT_1        INTEGER := 0;
        V_DEPT_SQL     VARCHAR2(4000 CHAR) := NULL;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
        V_PROC_INPUT := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID
                                   ,'p_dept_id' VALUE P_DEPT_ID
                                   ,'p_end_customer' VALUE P_END_CUSTOMER
                                   ,'p_scm_site_id' VALUE P_SCM_SITE_ID
                                   ,'p_plant_site_id' VALUE P_PLANT_SITE_ID
                                   ,'p_project_code' VALUE P_PROJECT_CODE
                                   ,'p_item_id' VALUE P_ITEM_ID
                                   ,'p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                   ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                   ,'p_bucket_type' VALUE P_BUCKET_TYPE
                                   ,'p_dom_exp' VALUE P_DOM_EXP
                                   ,'p_created_by' VALUE P_CREATED_BY);

        SELECT COUNT(1)
        INTO   V_CNT_1
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL
        WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
        AND    VALID_YN = 'Y'
        AND    SEGMENT2 = 'ALL'
        AND    SEGMENT1 = P_USERINFO;

        IF NVL(V_CNT_1, 0) > 0 THEN
            V_GROUP_ID := 'ADMIN';
        ELSE
            V_GROUP_ID := P_USERINFO;
        END IF;

        --------------------------------------------------------------------------------------
        --------------------------------------------------------------------------------------
        -- [E20260827-EXCELFORM-HDRONLY] Excel Form = 데이터 없이 **헤더만** (사용자 요청 2026-08-27).
        --   종전 V7(키 조합 실데이터 전량)은 백업에 보존. 커서 컬럼명·시그니처는 FE 계약대로 유지하되
        --   식별 컬럼은 전부 NULL 인 헤더 캐리어 1행만 반환한다:
        --     PERIOD_BUCKETS     = 조회구간(P_START~P_END)·버킷타입의 버킷 일자 전량 → FE 값 컬럼 생성
        --     UPLOAD_VALID_WEEKS = 그중 division 의 DM_MST_CUSTOMER_FCST VALID_YN='Y' 버킷 → 입력가능 표식
        --   FE(CustomerFcstTemplateModal)는 SCM_SITE_ID NULL 행을 헤더 캐리어로 판정해 데이터행 0건으로 내보낸다.
        --------------------------------------------------------------------------------------
        OPEN O_RC1 FOR
            SELECT CAST(NULL AS VARCHAR2(120))  AS DIVISION_ID
                 , CAST(NULL AS VARCHAR2(240))  AS SCM_SITE_ID
                 , CAST(NULL AS VARCHAR2(240))  AS PLANT_SITE_ID
                 , CAST(NULL AS VARCHAR2(200))  AS CUSTOMER_PROJECT_CODE
                 , CAST(NULL AS VARCHAR2(400))  AS CUSTOMER_MODEL
                 , CAST(NULL AS VARCHAR2(40))   AS INCOTERMS
                 , CAST(NULL AS VARCHAR2(40))   AS FCST_TYPE
                 , CAST(NULL AS VARCHAR2(40))   AS DOM_EXP
                 , CAST(NULL AS VARCHAR2(200))  AS MEASURE_GROUP
                 , CAST(NULL AS VARCHAR2(200))  AS MEASURE
                 , CAST(NULL AS VARCHAR2(40))   AS UPLOAD_UOM
                 , CAST(NULL AS VARCHAR2(200))  AS PROJECT_CODE
                 , CAST(NULL AS VARCHAR2(200))  AS ITEM_ID
                 , CAST(NULL AS VARCHAR2(200))  AS CUSTOMER_CODE
                 , (SELECT LISTAGG(V.SBV, ',') WITHIN GROUP (ORDER BY V.SBV)
                      FROM (SELECT DISTINCT MF.SUMMARY_BUCKET_VALUE AS SBV
                              FROM DM_MST_CUSTOMER_FCST MF
                             WHERE MF.VALID_YN = 'Y'
                               AND MF.UPLOAD_BUCKET_TYPE = P_BUCKET_TYPE
                               AND (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL'
                                    OR INSTR(',' || P_DIVISION_ID || ',', ',' || MF.DIVISION_ID || ',') > 0)
                               AND MF.SUMMARY_BUCKET_VALUE BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD) V
                   ) AS UPLOAD_VALID_WEEKS
                 , (SELECT LISTAGG(BK.SBV, ',') WITHIN GROUP (ORDER BY BK.SBV)
                      FROM (SELECT DISTINCT MB.SUMMARY_BUCKET_VALUE AS SBV
                              FROM DM_MST_CUSTOMER_FCST MB
                             WHERE MB.UPLOAD_BUCKET_TYPE = P_BUCKET_TYPE
                               AND MB.SUMMARY_BUCKET_VALUE BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD) BK
                   ) AS PERIOD_BUCKETS
              FROM DUAL;


        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS RESULT_CODE, 'SUCCESS' AS RESULT_MSG, '0' AS EVENT FROM DUAL;

        BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT); EXCEPTION WHEN OTHERS THEN NULL; END;

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN DBMS_LOB.FREETEMPORARY(V_SQL_TEXT); EXCEPTION WHEN OTHERS THEN NULL; END;
            V_SQL_CODE   := TO_CHAR(SQLCODE);
            V_SQL_ERRMSG := SUBSTR(SQLERRM, 1, 4000);
            V_BACKTRACE  := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);
            BEGIN
                SCM_MGR.PR_DM_SYS_LOG_BATCH(
                    V_PROGRAM_NAME, 'ERROR', N_LOG_COUNT
                  , '########## FAIL END of procedure ##########', V_DESCRIPTION
                  , SYSDATE, P_CREATED_BY, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE);
            EXCEPTION WHEN OTHERS THEN NULL; END;
            RAISE_APPLICATION_ERROR(-20001, '[' || V_PROGRAM_NAME || '] ' || V_SQL_ERRMSG || CHR(10) || V_BACKTRACE);
    END P_DMF0014_GET_EXCEL_FORM_DATA;

END PKG_DMF0014;
/
