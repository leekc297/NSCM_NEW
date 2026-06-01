/*=============================================================================================
 * File         : 04_Package_PKG_DMF0073.sql
 * Description  : Package — PKG_DMF0073
 *              : 안전 정제만 적용 (N' 접두사 제거).
 *              : Standalone SP와 화면 단위로 PKG 통합은 별도 후속 작업.
 *
 * 실행 순서   : 06_Packages 단계 (Foundation + Tables + GTT + Views 이후)
 * 실행 계정   : SCM_MGR
 *
 * TODO (수동 보정 필요):
 *   - LEFT/RIGHT OUTER JOIN → (+) 변환 (사내 표준 §7.1.6)
 *   - @변수 잔존 시 검토
 *   - DATEADD/CHARINDEX/STRING_SPLIT (Oracle 비존재 함수) 수동 변환
 *   - $$PLSQL_UNIT 하드코딩 → $$PLSQL_UNIT 치환
 *===========================================================================================*/


-- ====== PACKAGE SPEC ======

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0073 IS
    /*
    * Program ID   : PKG_DMF0073
    * Description  : PKG_DMF0073
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0073_GET_VERSION_SALESPRICE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_VERSION_TYPE   VARCHAR2
       ,P_DESCRIPTION    VARCHAR2
        -- DMF0073_GET_VERSION_SALESPRICE(p_start_yyyymmdd DEFAULT '20240401', p_end_yyyymmdd DEFAULT '20240601', p_created_by DEFAULT '20140001', p_division_id DEFAULT '82', p_version_type DEFAULT 'SP_W', p_description DEFAULT '');
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0073_SAVE_VERSION_SALESPRICE
    (
        P_DIVISION_ID          VARCHAR2
       ,P_VERSION_NO           VARCHAR2
       ,P_MONTHLY_ROLLING_FCST VARCHAR2
       ,P_USER_ID              VARCHAR2
       ,O_RC1                  OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR        OUT SYS_REFCURSOR
    );

END PKG_DMF0073;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0073 IS

    PROCEDURE P_DMF0073_GET_VERSION_SALESPRICE
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
       ,P_CREATED_BY     VARCHAR2
       ,P_DIVISION_ID    VARCHAR2
       ,P_VERSION_TYPE   VARCHAR2
       ,P_DESCRIPTION    VARCHAR2
        -- DMF0073_GET_VERSION_SALESPRICE(p_start_yyyymmdd DEFAULT '20240401', p_end_yyyymmdd DEFAULT '20240601', p_created_by DEFAULT '20140001', p_division_id DEFAULT '82', p_version_type DEFAULT 'SP_W', p_description DEFAULT '');
       ,O_RC1 OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /************************************************************************************************
         Program ID  : DMF0073_GET_VERSION_SALESPRICE
         Description : Procedure 작성 가이드
         Usage       : Procedure 작성 시 참조하세요!
         Parameter   :

        -- ----------------------------------------------------------------------------------------------
         Date        In Charge    Description
        -- ----------------------------------------------------------------------------------------------
         2024/05/13  KJJ       신규생성
         * 2025.01.01 P.C.I         PJ20228272 NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경
         * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발

        ******************************************************************************************************/
     AS

        V_IN_PARA_DATA CLOB;
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

        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_division_id' VALUE P_DIVISION_ID
                                     ,'p_version_type' VALUE P_VERSION_TYPE
                                     ,'p_description' VALUE P_DESCRIPTION
                                     ,'p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,'p_created_by' VALUE P_CREATED_BY
                                     ,'p_division_id' VALUE P_DIVISION_ID
                                     ,'p_version_type' VALUE P_VERSION_TYPE
                                     ,'P_W' VALUE P_VERSION_TYPE
                                     ,'p_description' VALUE P_DESCRIPTION);

        OPEN O_RC1 FOR
            SELECT 'SP_Z_CURRENT' AS CODE
                  ,'Current' AS VERSION_NO
                  ,'Current' VERSION_DESCRIPTION
                  ,TO_CHAR(NULL) VERSION_TYPE
                  ,TO_CHAR(NULL) EDI_APPLY
                  ,TO_NUMBER(NULL) VER_CRE_SEQ
                  ,TO_CHAR(NULL) YYYYMMDD
                  ,TO_CHAR(NULL) CREATED_BY
                  ,SYSDATE CREATION_DATE
                  ,TO_CHAR(NULL) MONTHLY_ROLLING_FCST
                  ,'' EDITABLE
            FROM   DUAL
            UNION ALL
            --P_DESCRIPTIONIS 값이 NULL 일때
            SELECT VERSION_NO AS CODE
                  ,CASE
                       WHEN C.DM_RTF_YN = '' THEN
                        (VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)')
                       ELSE
                        (VERSION_NO || '(' || B.WEEK_NAME || ')')
                   END AS VERSION_NO
                  ,VERSION_DESCRIPTION
                  ,VERSION_TYPE
                  ,(CASE
                       WHEN VERSION_TYPE = 'ME_S' THEN
                        'Y'
                       ELSE
                        ''
                   END) EDI_APPLY
                  ,VER_CRE_SEQ
                  ,YYYYMMDD
                  ,MAX(CREATED_BY)
                  ,MAX(CREATION_DATE)
                  ,NVL(A.ATTRIBUTE7, '') MONTHLY_ROLLING_FCST
                  ,CASE
                       WHEN B.ISO_WEEK = TO_NUMBER(TO_CHAR(SYSDATE, 'IW')) THEN
                        'Y'
                       ELSE
                        ''
                   END EDITABLE --현재 주차만 수정가능
            FROM   DM_MST_VERSION A
            INNER  JOIN SCM_SYS_CALENDAR_M B
            ON     A.YYYYMMDD = B.BASIS_YYYYMMDD
            LEFT   JOIN SCP_PLN_INTERFACE_YN C
            ON     A.DIVISION_ID = C.DIVISION_ID
                  --AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD --PJ20228272 NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경
            AND    (SELECT MIN(BASIS_YYYYMMDD) FROM SCM_SYS_CALENDAR_M WHERE ISO_YYYYWW = B.ISO_YYYYWW) = C.PLAN_START_YYYYMMDD
            WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
            AND    A.DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')))
            AND    VERSION_TYPE IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VERSION_TYPE, ',')))
                  --AND Exists (SELECT value FROM TABLE(fn_splitstring(p_version_no,',')) P Where VERSION_NO LIKE P.value ||'%')
            AND    VERSION_DESCRIPTION IS NULL
            AND    NVL(ATTRIBUTE1, NULL) <> 'MOVE'
            GROUP  BY VERSION_NO
                     ,VERSION_NO
                     ,VERSION_DESCRIPTION
                     ,VERSION_TYPE
                     ,VER_CRE_SEQ
                     ,YYYYMMDD
                     ,B.WEEK_NAME
                     ,C.DM_RTF_YN
                     ,NVL(A.ATTRIBUTE7, '')
                     ,B.ISO_WEEK
            UNION ALL
            --P_DESCRIPTIONIS 값이 NOT NULL 일때
            SELECT VERSION_NO AS CODE
                  ,CASE
                       WHEN C.DM_RTF_YN = '' THEN
                        (VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)')
                       ELSE
                        (VERSION_NO || '(' || B.WEEK_NAME || ')')
                   END AS VERSION_NO
                  ,VERSION_DESCRIPTION
                  ,VERSION_TYPE
                  ,(CASE
                       WHEN VERSION_TYPE = 'ME_S' THEN
                        'Y'
                       ELSE
                        ''
                   END) EDI_APPLY
                  ,VER_CRE_SEQ
                  ,YYYYMMDD
                  ,MAX(CREATED_BY)
                  ,MAX(CREATION_DATE)
                  ,NVL(A.ATTRIBUTE7, '') MONTHLY_ROLLING_FCST
                  ,CASE
                       WHEN B.ISO_WEEK = TO_NUMBER(TO_CHAR(SYSDATE, 'IW')) THEN
                        'Y'
                       ELSE
                        ''
                   END EDITABLE --현재 주차만 수정가능
            FROM   DM_MST_VERSION A
            INNER  JOIN SCM_SYS_CALENDAR_M B
            ON     A.YYYYMMDD = B.BASIS_YYYYMMDD
            LEFT   JOIN SCP_PLN_INTERFACE_YN C
            ON     A.DIVISION_ID = C.DIVISION_ID
                  --AND B.BASIS_START_DATE = C.PLAN_START_YYYYMMDD --PJ20228272 NERP 대응. No Plan 날짜 Start_date를 ISO_YYYYWW 기준으로 변경
            AND    (SELECT MIN(BASIS_YYYYMMDD) FROM SCM_SYS_CALENDAR_M WHERE ISO_YYYYWW = B.ISO_YYYYWW) = C.PLAN_START_YYYYMMDD
            WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
            AND    A.DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')))
            AND    VERSION_TYPE IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VERSION_TYPE, ',')))
                  --AND Exists (SELECT value FROM TABLE(fn_splitstring(p_version_no,',')) P Where VERSION_NO LIKE P.value ||'%')
            AND    VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'
            AND    NVL(ATTRIBUTE1, NULL) <> 'MOVE'
            GROUP  BY VERSION_NO
                     ,VERSION_NO
                     ,VERSION_DESCRIPTION
                     ,VERSION_TYPE
                     ,VER_CRE_SEQ
                     ,YYYYMMDD
                     ,B.WEEK_NAME
                     ,C.DM_RTF_YN
                     ,NVL(A.ATTRIBUTE7, '')
                     ,B.ISO_WEEK
            ORDER  BY CODE DESC, VERSION_NO DESC;

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
    END P_DMF0073_GET_VERSION_SALESPRICE;

    PROCEDURE P_DMF0073_SAVE_VERSION_SALESPRICE
    (
        P_DIVISION_ID          VARCHAR2
       ,P_VERSION_NO           VARCHAR2
       ,P_MONTHLY_ROLLING_FCST VARCHAR2
       ,P_USER_ID              VARCHAR2
       ,O_RC1                  OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR        OUT SYS_REFCURSOR
    )
    /*
         * Program ID   : DMF0073_SAVE_VERSION_SALESPRICE
         * Description  : VERSION_SALESPRICE 수정
         * Program History
         *===================================================================================================
         *   Date       In Charge   Description
         *===================================================================================================
         * 2024. 05. 13   KJJ       최초 작성
         * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발

         DMF0073_SAVE_VERSION_SALESPRICE(P_DIVISION_ID='81');
        ,P_VERSION_NO='I'
        ,P_MONTHLY_ROLLING_FCST='Y'
        ,P_USER_ID='kjj0070'

         */
     AS

        V_CREATION_DATE DATE;
        $$PLSQL_UNIT  VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE      VARCHAR2(30 CHAR);
        N_LOG_COUNT     INTEGER := 0;
        V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
        V_DESCRIPTION   VARCHAR2(500 CHAR);
        D_EVENT_DATE    DATE;
        V_ERR_CODE      INTEGER;
        V_ERR_MESSAGE   VARCHAR2(4000 CHAR) := NULL;
        V_ROWCNT        INTEGER;
        V_IN_PARA_DATA  CLOB;
    BEGIN

        V_IN_PARA_DATA := JSON_OBJECT('P_DIVISION_ID' VALUE P_DIVISION_ID
                                     ,'P_VERSION_NO' VALUE P_VERSION_NO
                                     ,'P_MONTHLY_ROLLING_FCST' VALUE P_MONTHLY_ROLLING_FCST
                                     ,'P_USER_ID' VALUE P_USER_ID);

        -- LOG 용 변수 설정
        V_CREATION_DATE := SYSTIMESTAMP;

        -- LOG 용 변수 설정
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)

        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);

        MERGE INTO DM_MST_VERSION M_VER
        USING (SELECT B1.VALUE AS VERSION_NO, B2.VALUE MONTHLY_ROLLING_FCST
               FROM   (SELECT VALUE, ROWNUM NR FROM (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VERSION_NO, '^')))) B1
               LEFT   OUTER JOIN (SELECT VALUE, ROWNUM NR FROM (SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_MONTHLY_ROLLING_FCST, '^')))) B2
               ON     B1.NR = B2.NR) T_LIST -- FIXED
        ON (M_VER.DIVISION_ID = P_DIVISION_ID -- FIXED
        AND M_VER.VERSION_NO = T_LIST.VERSION_NO) -- FIXED
        WHEN MATCHED THEN -- FIXED
            UPDATE
            SET    -- FIXED
                   M_VER.ATTRIBUTE7 = T_LIST.MONTHLY_ROLLING_FCST
                  ,LAST_UPDATED_BY  = P_USER_ID
                  ,LAST_UPDATE_DATE = SYSDATE;

        V_ROWCNT := SQL%ROWCOUNT;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);

        -- 결과코드, 결과 카운트 반환
        -- END TRY

        COMMIT;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;

            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
                                ,'E'
                                ,0
                                ,SQLERRM
                                ,NULL
                                ,SYSDATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '.' || 'P_DMF0073_SAVE_VERSION_SALESPRICE' || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM ||
                                    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);

        -- END CATCH

    END P_DMF0073_SAVE_VERSION_SALESPRICE;

END PKG_DMF0073;
/
