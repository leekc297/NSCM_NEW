-- DMF0043 — 사내 → 클라우드 patch (2026-06-11 09:56 ~ 14:28 changes)
-- 9 objects (PKG_DMF0043 PACKAGE/BODY + 7 standalone PROCEDURE)
-- 적용 후 컴파일 확인: SELECT OBJECT_NAME, STATUS FROM USER_OBJECTS WHERE OBJECT_NAME LIKE 'DMF0043%' OR OBJECT_NAME='PKG_DMF0043';

-- ===== 1: PKG_DMF0043 (PACKAGE) =====
CREATE OR REPLACE PACKAGE           "PKG_DMF0043" IS
    /*
    * Program ID   : PKG_DMF0043
    * Description  : PKG_DMF0043
    * Program History
    *===========================================================================================================
    *   Date       In Charge      Description
    *===========================================================================================================
    * 2026.03.15   김준규       [PJ20264226] NextSCM Pilot 설계 및 개발
    */

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_RATE_POPUP
    (
        P_YYYY          VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP
    (
        P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
        --,p_created_by       VARCHAR2,
       ,P_DIVISION_ID  VARCHAR2
       ,P_VERSION_TYPE VARCHAR2
        --,p_version_no       VARCHAR2,
       ,P_DESCRIPTION   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RC3           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_MAIN_VARSION_DATA
    (
        P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_GET_SALES_LIST_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
    (
        P_ACTIVE_FLAG        VARCHAR2
       ,P_VER_SEQ            VARCHAR2
       ,P_DEPARTMENT_ID      VARCHAR2
       ,P_DEPT_ID            VARCHAR2
       ,P_END_CUST_REPORT    VARCHAR2
       ,P_SOLDTO_CUST_REPORT VARCHAR2
       ,P_PRODUCT_GROUP      VARCHAR2
       ,P_DM_BIZ_TYPE        VARCHAR2
       ,P_YYYYMM             VARCHAR2
       ,P_OS_CORP_CD         VARCHAR2
       ,P_CONTRIBUTION_TYPE  VARCHAR2
       ,P_CONTRIBUTION_RATIO VARCHAR2
       ,P_CREATED_BY         VARCHAR2
       ,O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
    (
        P_ACTIVE_FLAG   VARCHAR2
       ,P_VER_SEQ       VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_VERSION_NM    VARCHAR2
       ,P_DESCRIPTION   VARCHAR2
       ,P_VALID_YN      VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

END PKG_DMF0043;/

-- ===== 2: PKG_DMF0043 (PACKAGE BODY) =====
CREATE OR REPLACE PACKAGE BODY           "PKG_DMF0043" IS

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_RATE_POPUP
    (
        P_YYYY          VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
         **************************************************************************************************
         * Program ID  :  DMF0043_GET_CONTRIBUTE_RATE_POPUP
         * Description : DMF0043 > 기여율 관리 팝업
         * Usage       : Procedure 작성 시 참조하세요!
         * Parameter   :
         *
         *--------------------------------------------------------------------------------------------------
         * Date        In Charge    Description
         *--------------------------------------------------------------------------------------------------
         * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
         * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발
         **************************************************************************************************
        */
     AS

        V_IN_PARA_DATA VARCHAR2(4000);
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(30 CHAR);
        N_LOG_COUNT    INTEGER := 0;
        V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
        V_DESCRIPTION  VARCHAR2(500 CHAR);
        D_EVENT_DATE   DATE;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_yyyy' VALUE P_YYYY);
        OPEN O_RC1 FOR
            SELECT VER_SEQ, YYYY, VERSION_NM, DESCRIPTION, VALID_YN
            FROM   DM_MST_CONTRIBUTE_VER
            WHERE  YYYY = CASE
                       WHEN P_YYYY IS NULL OR P_YYYY = 'ALL' THEN
                        YYYY
                       ELSE
                        P_YYYY
                   END
            ORDER  BY YYYY DESC;
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA  => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE  => SQLCODE
                                ,P_SQL_ERR_MSG   => SQLERRM
                                ,P_SQL_BACKTRACE => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0043_GET_CONTRIBUTE_RATE_POPUP;

    PROCEDURE P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP

    (
        P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    ) /*
                     **************************************************************************************************
                     * Program ID  :  DMF0043_GET_CONTRIBUTE_YEAR_POPUP
                     * Description : DMF0043 > 검색 연도
                     * Usage       : Procedure 작성 시 참조하세요!
                     * Parameter   :
                     *
                     *--------------------------------------------------------------------------------------------------
                     * Date        In Charge    Description
                     *--------------------------------------------------------------------------------------------------
                     * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
                     * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발
                     **************************************************************************************************
                    */
     AS
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
        V_IN_PARA_DATA VARCHAR2(4000) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        OPEN O_RC1 FOR
            SELECT CODE, NAME, 'Y' AS EDIT_YN
            FROM   (SELECT 'ALL' AS CODE, 'ALL' AS NAME, 0 SORTORDER
                    FROM   DUAL
                    UNION ALL

                    SELECT YYYY AS CODE, YYYY NAME, ROW_NUMBER() OVER(ORDER BY YYYY) SORTORDER
                    FROM   DM_MST_CONTRIBUTE_VER
                    GROUP  BY YYYY) MA
            ORDER  BY SORTORDER;

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
    END P_DMF0043_GET_CONTRIBUTE_YEAR_POPUP;

    PROCEDURE P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP
    (
        P_START_YYYYMMDD VARCHAR2
       ,P_END_YYYYMMDD   VARCHAR2
        --,p_created_by       VARCHAR2,
       ,P_DIVISION_ID  VARCHAR2
       ,P_VERSION_TYPE VARCHAR2
        --,p_version_no       VARCHAR2,
       ,P_DESCRIPTION   VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /***************************************************************************************************
         Program ID  : DMF0043_GET_CONT_VIEW_VERSIONPOPUP
         Description : Procedure 작성 가이드
         Usage       : Procedure 작성 시 참조하세요!
         Parameter   :

        -- -----------------------------------------------------------------------------------------------
         Date        In Charge    Description
        -- -----------------------------------------------------------------------------------------------
         2019/08/19  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
         2020/01/28  P.C.I     [CSR ID:prepare] Report Plan List 조회로 변경
         2020/06/12  HWI1993    [C20200605-000077] GSCM 해외법인 기여율 매출 버전 리스트 정리 요청의 건
         2021/07/03   HWI1993   하반기과제 속도개선 - 데이터 이동보관 처리
        **************************************************************************************************/
     AS

        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_start_yyyymmdd' VALUE P_START_YYYYMMDD
                                     ,'p_end_yyyymmdd' VALUE P_END_YYYYMMDD
                                     ,
                                      /*'p_created_by' VALUE p_created_by,*/'p_division_id' VALUE P_DIVISION_ID
                                     ,'p_version_type' VALUE P_VERSION_TYPE
                                     ,
                                      /*'p_version_no' VALUE p_version_no,*/'p_description' VALUE P_DESCRIPTION);

        /*
        OPEN O_RC1 FOR
        SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
          FROM DM_MST_VERSION
        WHERE (YYYYMMDD >= p_start_yyyymmdd and YYYYMMDD <= p_end_yyyymmdd)
           AND DIVISION_ID IN (SELECT value FROM TABLE(fn_splitstring(p_division_id  ,',')))
           AND VERSION_TYPE IN (SELECT value FROM TABLE(fn_splitstring(p_version_type    ,',')))
           AND Exists (SELECT value FROM TABLE(fn_splitstring(p_version_no,',')) P Where VERSION_NO LIKE P.value ||'%')
        GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
        ORDER BY CODE DESC, VERSION_NO DESC*/
        OPEN O_RC1 FOR
            SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE), TEI.EDIT_YN
            FROM   DM_MDF_VERSION A
            INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
            ON     TEI.UNIT_ID = A.DIVISION_ID
            WHERE  A.DIVISION_ID = P_DIVISION_ID
            AND    A.YYYYMMDD BETWEEN P_START_YYYYMMDD AND P_END_YYYYMMDD
            AND    A.VERSION_TYPE = P_VERSION_TYPE
            AND    A.VERSION_DESCRIPTION LIKE '%' || P_DESCRIPTION || '%'
            AND    A.SEND_YN <> 'D'
            AND    NVL(A.ATTRIBUTE1, NULL) <> 'MOVE'
            GROUP  BY VERSION_NO, VERSION_NO, A.VERSION_DESCRIPTION, A.VERSION_TYPE, A.VER_CRE_SEQ, A.YYYYMMDD, TEI.EDIT_YN
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
    END P_DMF0043_GET_CONT_VIEW_VERSIONPOPUP;

    PROCEDURE P_DMF0043_GET_MAIN_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RC2           OUT SYS_REFCURSOR
       ,O_RC3           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /****************************************************************************************************/
        /* Program ID  : DMF0043_GET_SPREAD_TITLE                                                             */
        /* Description : Procedure 작성 가이드                                                              */
        /* Usage       : Procedure 작성 시 참조하세요!                                                      */
        /* Parameter   :                                                                                    */
        /*                                                                                                  */
        /*--------------------------------------------------------------------------------------------------*/
        /* Date        In Charge    Description                                                             */
        /*--------------------------------------------------------------------------------------------------*/
        /* 2019/06/20     JYE   기여율 해더                    */
        /****************************************************************************************************/
     AS

        V_PROGRAM_ID   VARCHAR2(4000 CHAR) := 'DMF0043';
        V_SHEET_NAME   VARCHAR2(4000 CHAR) := 'ContributeMain';
        V_CODELIST     VARCHAR2(1000 CHAR) := NULL;
        V_NAMELIST     VARCHAR2(1000 CHAR) := NULL;
        V_NSQL         VARCHAR2(4000 CHAR) := NULL;
        V_I            INTEGER := 0;
        V_USER_COL_CNT INTEGER := 0;
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_yyyy' VALUE P_YYYY, 'p_created_by' VALUE P_CREATED_BY);

        INSERT /*+ NO_PARALLEL */
        INTO GT_GMST_TEMP_2
            SELECT L.SEGMENT1 AS CODE, L.SEGMENT2 NAME, DISPLAY_SEQ DISPLAY_SEQ
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
            WHERE  1 = 1
            AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
            AND    L.VALID_YN = 'Y'
            AND    L.SEGMENT4 = 'N'
            ORDER  BY DISPLAY_SEQ;

        --INSERT /*+ NO_PARALLEL */ INTO GT_GMST_TEMP_2 VALUES ('RBU_0099', '구분', 99)
        INSERT /*+ NO_PARALLEL */
        INTO GT_GMST_TEMP2_2
            SELECT -- 연도만
             P_YYYY || '  ' AS YYYYMM, 'Y' AS FLAG, CODE, NAME, DISPLAY_SEQ
            FROM   GT_GMST_TEMP_2;
        --ORDER BY DISPLAY_SEQ;

        WHILE (V_I < 12) LOOP
            V_I := V_I + 1;
            IF (LENGTH(TO_CHAR(V_I)) >= 2) THEN
                INSERT /*+ NO_PARALLEL */
                INTO GT_GMST_TEMP2_2
                --SELECT p_yyyy || '-' || CAST(v_i AS VARCHAR) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ
                    SELECT P_YYYY || TO_CHAR(V_I) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ FROM GT_GMST_TEMP_2;
            ELSE
                INSERT /*+ NO_PARALLEL */
                INTO GT_GMST_TEMP2_2
                    SELECT P_YYYY || '0' || TO_CHAR(V_I) YYYYMM, 'M' AS FLAG, CODE, NAME, DISPLAY_SEQ FROM GT_GMST_TEMP_2;
            END IF;
        END LOOP;

        -- ############### OS_CORP 반복 end ###############
        SELECT COUNT(*)
        INTO   V_USER_COL_CNT
        FROM   SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND    U.PROGRAM_ID = V_PROGRAM_ID
        AND    U.SHEET_NAME = V_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY;

        --select v_user_col_cnt
        IF V_USER_COL_CNT = 0 THEN
            OPEN O_RC3 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,TEI.EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = C.DIVISION_ID
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = 'N'
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,T.FLAG || '#' || T.YYYYMM || '#' || CODE AS COLUMN_NAME
                      ,T.NAME COLUMN_LABEL_NAME
                      ,TO_NUMBER(DISPLAY_SEQ) SORT_ORDER_NO
                      ,'' AS DATA_SORT_METHOD_CODE
                       --, T.YYYYMM SMALL_CLASS_LABEL_NAME
                      ,T.NAME SMALL_CLASS_LABEL_NAME
                      ,CASE
                           WHEN LENGTH(T.YYYYMM) = 4 THEN
                            T.YYYYMM
                           ELSE
                            SUBSTR(T.YYYYMM, 1, 4) || '-' || SUBSTR(T.YYYYMM, 5, 2)
                       END AS LARGE_CLASS_LABEL_NAME
                       --, p_yyyy LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,'' AS FIXED_FLAG
                      ,80 COLUMN_WIDTH
                      ,'' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,'' AS CELL_COMBO_DATA_TYPE
                      ,2 AS DATA_SCALE_NUMBER
                      ,NULL AS DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
                      ,'Y' AS VISIBLE_FLAG
                      ,'' AS DEFAULT_FLAG
                      ,'' AS USER_SELECTABLE_FLAG
                      ,'' AS VALID_YN
                      ,'' AS DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   (SELECT REPLACE(YYYYMM, ' ', '') YYYYMM
                              ,FLAG
                              ,CODE
                              ,NAME
                              ,TO_CHAR(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', '')) || TO_CHAR(DISPLAY_SEQ) DISPLAY_SEQ
                        FROM   GT_GMST_TEMP2_2) T
                ORDER  BY SORT_ORDER_NO;
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
    END P_DMF0043_GET_MAIN_SPREAD_TITLE;

    PROCEDURE P_DMF0043_GET_MAIN_VARSION_DATA
    (
        P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    ) AS

        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        OPEN O_RC1 FOR
            SELECT VER_SEQ AS CODE, VERSION_NM NAME, VER_SEQ, YYYY, VERSION_NM, DESCRIPTION, YYYY || '(' || VERSION_NM || ')' AS NAME2, 'Y' AS EDIT_YN
            FROM   DM_MST_CONTRIBUTE_VER
            WHERE  VALID_YN = 'Y'
            ORDER  BY YYYY DESC;

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
    END P_DMF0043_GET_MAIN_VARSION_DATA;

    PROCEDURE P_DMF0043_GET_SALES_LIST_SPREAD_TITLE
    (
        P_DIVISION_ID   VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,P_USER_ID       VARCHAR2
       ,P_MENU_ID       VARCHAR2
       ,O_RC1           OUT SYS_REFCURSOR
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /****************************************************************************************************/
        /* Program ID  : DMF0043_GET_SALES_LIST_SPREAD_TITLE                                                */
        /* Description : 해외법인 기여매출 헤더                                                             */
        /* Usage       : Procedure 작성 시 참조하세요!                                                      */
        /* Parameter   :                                                                                    */
        /*                                                                                                  */
        /*--------------------------------------------------------------------------------------------------*/
        /* Date        In Charge    Description                                                             */
        /*--------------------------------------------------------------------------------------------------*/
        /* 2019/06/20     JSYOUN    [CSR ID:3948994] GSCM 해외법인기여율 화면 개발 요청의 건 - 기여매출 해더 */
        /* 2019/12/12     HWI1993 합계컬럼 로직 추가 */
        /* 2019/12/12     HWI1993 합계컬럼 로직 추가 */
        /****************************************************************************************************/
     AS

        V_PROGRAM_ID   VARCHAR2(4000 CHAR) := 'DMF0043';
        V_SHEET_NAME   VARCHAR2(4000 CHAR) := 'ContributeSalesList';
        V_CODELIST     VARCHAR2(1000 CHAR) := NULL;
        V_NAMELIST     VARCHAR2(1000 CHAR) := NULL;
        V_NSQL         VARCHAR2(4000 CHAR) := NULL;
        V_I            INTEGER := 0;
        V_USER_COL_CNT INTEGER := 0;
        V_IN_PARA_DATA VARCHAR2(4000);
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        V_PROGRAM_NAME VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_created_by' VALUE P_CREATED_BY);

        /*
        INSERT + NO_PARALLEL  INTO GT_GSLS1_temp
        SELECT
              L.SEGMENT1 || '#'  ||  M.SEGMENT1  AS CODE
            , L.SEGMENT2 NAME
            , L.SEGMENT2 LARGE_NAME
            , M.SEGMENT2 SMALL_NAME
            , 1000+L.DISPLAY_SEQ+M.DISPLAY_SEQ AS DISPLAY_SEQ
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
            ,  SCM_ADM_LOOKUP_MASTER_DETAIL M
        WHERE  1 = 1
        AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
        AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
        AND    L.VALID_YN    = 'Y'
        AND    L.SEGMENT3    = 'Y'
        AND    M.VALID_YN    = 'Y'
        ORDER BY L.DISPLAY_SEQ, M.DISPLAY_SEQ;
        */
        INSERT INTO GT_GSLS1_TEMP
            SELECT DISTINCT L.SEGMENT1 || '#' || CASE
                                WHEN L.SEGMENT4 = 'Y' THEN
                                 ''
                                ELSE
                                 M.SEGMENT1
                            END AS CODE
                           ,L.SEGMENT2 NAME
                           ,L.SEGMENT2 LARGE_NAME
                           ,CASE
                                WHEN L.SEGMENT4 = 'Y' THEN
                                 L.SEGMENT1
                                ELSE
                                 M.SEGMENT2
                            END AS SMALL_NAME
                           ,1000 + L.DISPLAY_SEQ + CASE
                                WHEN L.SEGMENT4 = 'Y' THEN
                                 0
                                ELSE
                                 M.DISPLAY_SEQ
                            END AS DISPLAY_SEQ
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L, SCM_ADM_LOOKUP_MASTER_DETAIL M
            WHERE  1 = 1
            AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
            AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
            AND    L.VALID_YN = 'Y'
            AND    L.SEGMENT3 = 'Y'
            AND    M.VALID_YN = 'Y';
        --AND     L.SEGMENT4  = 'N'

        -- ############### OS_CORP 반복 end ###############
        SELECT COUNT(*)
        INTO   V_USER_COL_CNT
        FROM   SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND    U.PROGRAM_ID = V_PROGRAM_ID
        AND    U.SHEET_NAME = V_SHEET_NAME
        AND    U.USER_ID = P_CREATED_BY;

        --select v_user_col_cnt
        IF V_USER_COL_CNT > 0 THEN
            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,TEI.EDIT_YN
                FROM   SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = C.DIVISION_ID
                WHERE  1 = 1
                AND    U.PROGRAM_ID = C.PROGRAM_ID
                AND    U.SHEET_NAME = C.SHEET_NAME
                AND    U.COLUMN_NAME = C.COLUMN_NAME
                AND    U.PROGRAM_ID = V_PROGRAM_ID
                AND    U.SHEET_NAME = V_SHEET_NAME
                AND    U.USER_ID = P_CREATED_BY
                AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = 'N'
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,CODE COLUMN_NAME
                      ,T.NAME COLUMN_LABEL_NAME
                      ,DISPLAY_SEQ SORT_ORDER_NO
                      ,CAST(NULL AS VARCHAR2(1)) AS DATA_SORT_METHOD_CODE
                       --, T.YYYYMM SMALL_CLASS_LABEL_NAME
                      ,T.SMALL_NAME SMALL_CLASS_LABEL_NAME
                      ,T.LARGE_NAME LARGE_CLASS_LABEL_NAME
                       --, p_yyyy LARGE_CLASS_LABEL_NAME
                      ,CAST(NULL AS VARCHAR2(1)) AS DAY_CODE
                      ,CAST(NULL AS VARCHAR2(1)) AS FIXED_FLAG
                      ,80 COLUMN_WIDTH
                      ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,CAST(NULL AS VARCHAR2(1)) AS CELL_COMBO_DATA_TYPE
                      ,TO_NUMBER(NULL) AS DATA_SCALE_NUMBER
                      ,TO_NUMBER(NULL) AS DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
                      ,'Y' AS VISIBLE_FLAG
                      ,CAST(NULL AS VARCHAR2(1)) AS DEFAULT_FLAG
                      ,CAST(NULL AS VARCHAR2(1)) AS USER_SELECTABLE_FLAG
                      ,CAST(NULL AS VARCHAR2(1)) AS VALID_YN
                      ,CAST(NULL AS VARCHAR2(1)) AS DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   (SELECT CODE, NAME, LARGE_NAME, SMALL_NAME, DISPLAY_SEQ FROM GT_GSLS1_TEMP) T
                ORDER  BY SORT_ORDER_NO;

        ELSE

            OPEN O_RC1 FOR
                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,TEI.EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                INNER  JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(P_USER_ID, P_MENU_ID)) TEI
                ON     TEI.UNIT_ID = C.DIVISION_ID
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.DEFAULT_FLAG = 'Y'
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT C.PROGRAM_ID
                      ,C.SHEET_NAME
                      ,C.COLUMN_NAME
                      ,C.COLUMN_LABEL_NAME
                      ,C.SORT_ORDER_NO
                      ,C.DATA_SORT_METHOD_CODE
                      ,C.SMALL_CLASS_LABEL_NAME
                      ,C.LARGE_CLASS_LABEL_NAME
                      ,'' AS DAY_CODE
                      ,C.FIXED_FLAG
                      ,C.COLUMN_WIDTH
                      ,C.CELL_CONTROL_OBJECT_TYPE_CODE
                      ,C.CELL_COMBO_DATA_TYPE
                      ,C.DATA_SCALE_NUMBER
                      ,C.DATA_MAX_LENGTH
                      ,C.HORIZONTAL_ALIGN_CODE
                      ,C.UPPERCASE_APPLY_FLAG
                      ,C.VISIBLE_FLAG
                      ,C.DEFAULT_FLAG
                      ,C.USER_SELECTABLE_FLAG
                      ,C.VALID_YN
                      ,C.DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = 'N'
                AND    C.DEFAULT_FLAG IS NULL
                AND    C.VALID_YN = 'Y'
                AND    P_DIVISION_ID IN (SELECT VALUE FROM TABLE(FN_SPLITSTRING(C.DIVISION_ID, ',')))

                UNION ALL

                SELECT V_PROGRAM_ID AS PROGRAM_ID
                      ,V_SHEET_NAME SHEET_NAME
                      ,CODE COLUMN_NAME
                      ,T.NAME COLUMN_LABEL_NAME
                      ,DISPLAY_SEQ SORT_ORDER_NO
                      ,CAST(NULL AS VARCHAR2(1)) AS DATA_SORT_METHOD_CODE
                       --, T.YYYYMM SMALL_CLASS_LABEL_NAME
                      ,T.SMALL_NAME SMALL_CLASS_LABEL_NAME
                      ,T.LARGE_NAME LARGE_CLASS_LABEL_NAME
                       --, p_yyyy LARGE_CLASS_LABEL_NAME
                      ,CAST(NULL AS VARCHAR2(1)) AS DAY_CODE
                      ,CAST(NULL AS VARCHAR2(1)) AS FIXED_FLAG
                      ,80 COLUMN_WIDTH
                      ,'FPNumber' AS CELL_CONTROL_OBJECT_TYPE_CODE
                      ,CAST(NULL AS VARCHAR2(1)) AS CELL_COMBO_DATA_TYPE
                      ,TO_NUMBER(NULL) AS DATA_SCALE_NUMBER
                      ,TO_NUMBER(NULL) AS DATA_MAX_LENGTH
                      ,'R' AS HORIZONTAL_ALIGN_CODE
                      ,'Y' AS UPPERCASE_APPLY_FLAG
                      ,'Y' AS VISIBLE_FLAG
                      ,CAST(NULL AS VARCHAR2(1)) AS DEFAULT_FLAG
                      ,CAST(NULL AS VARCHAR2(1)) AS USER_SELECTABLE_FLAG
                      ,CAST(NULL AS VARCHAR2(1)) AS VALID_YN
                      ,CAST(NULL AS VARCHAR2(1)) AS DIVISION_ID
                      ,'N' AS EDIT_YN
                FROM   (SELECT CODE, NAME, LARGE_NAME, SMALL_NAME, DISPLAY_SEQ FROM GT_GSLS1_TEMP) T
                ORDER  BY SORT_ORDER_NO;
            -- END;

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
    END P_DMF0043_GET_SALES_LIST_SPREAD_TITLE;

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
    (
        P_ACTIVE_FLAG        VARCHAR2
       ,P_VER_SEQ            VARCHAR2
       ,P_DEPARTMENT_ID      VARCHAR2
       ,P_DEPT_ID            VARCHAR2
       ,P_END_CUST_REPORT    VARCHAR2
       ,P_SOLDTO_CUST_REPORT VARCHAR2
       ,P_PRODUCT_GROUP      VARCHAR2
       ,P_DM_BIZ_TYPE        VARCHAR2
       ,P_YYYYMM             VARCHAR2
       ,P_OS_CORP_CD         VARCHAR2
       ,P_CONTRIBUTION_TYPE  VARCHAR2
       ,P_CONTRIBUTION_RATIO VARCHAR2
       ,P_CREATED_BY         VARCHAR2
       ,O_RESULT_CURSOR      OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
        * Description  : 'DM_MST_CONTRIBUTE_RATIO' TABLE INSERT/UPDATE/DELETE
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 20190730  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
          2020/09/09     P.C.I     [C20200909-000203] LOG 표준화 적용
        * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발
        *
        */
     AS

        V_ACTIVE_FLAG              VARCHAR2(4000 CHAR);
        V_VER_SEQ                  NUMBER;
        V_DEPARTMENT_ID            VARCHAR2(4000 CHAR);
        V_DEPT_ID                  VARCHAR2(4000 CHAR);
        V_END_CUST_REPORT          VARCHAR2(4000 CHAR);
        V_SOLDTO_CUST_REPORT       VARCHAR2(4000 CHAR);
        V_PRODUCT_GROUP            VARCHAR2(4000 CHAR);
        V_DM_BIZ_TYPE              VARCHAR2(4000 CHAR);
        V_YYYYMM                   VARCHAR2(4000 CHAR);
        V_OS_CORP_CD               VARCHAR2(4000 CHAR);
        V_CONTRIBUTION_TYPE        VARCHAR2(4000 CHAR);
        V_CONTRIBUTION_RATIO       VARCHAR2(4000 CHAR);
        V_CREATED_BY               VARCHAR2(4000 CHAR);
        V_DELIMITER                VARCHAR2(1 CHAR);
        V_MAX_LOOP_CNT             INTEGER := 0;
        V_MST_LOOP_CNT             INTEGER := 0;
        V_MAX_VER_SEQ              VARCHAR2(4000 CHAR);
        V_PROGRAM_NAME             VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE                 VARCHAR2(30 CHAR);
        N_LOG_COUNT                INTEGER := 0;
        V_LOG_MESSAGE              VARCHAR2(1000 CHAR);
        V_LOG_DESCRIPTION          VARCHAR2(500 CHAR);
        D_EVENT_DATE               DATE;
        N_DELETE_COUNT             INTEGER := 0;
        N_INSERT_COUNT             INTEGER := 0;
        N_INPUT_COUNT              INTEGER := 0;
        N_LOGO_COUNT               INTEGER := 0;
        V_INDEX_ACTIVE_FLAG        INTEGER;
        V_INDEX_VER_SEQ            INTEGER;
        V_INDEX_DEPARTMENT_ID      INTEGER;
        V_INDEX_DEPT_ID            INTEGER;
        V_INDEX_END_CUST_REPORT    INTEGER;
        V_INDEX_SOLDTO_CUST_REPORT INTEGER;
        V_INDEX_PRODUCT_GROUP      INTEGER;
        V_INDEX_DM_BIZ_TYPE        INTEGER;
        V_INDEX_YYYYMM             INTEGER;
        V_INDEX_OS_CORP_CD         INTEGER;
        V_INDEX_CONTRIBUTION_TYPE  INTEGER;
        V_INDEX_CONTRIBUTION_RATIO INTEGER;
        V_INDEX_CREATED_BY         INTEGER;
        V_IN_PARA_DATA             VARCHAR2(4000);
        VP_ACTIVE_FLAG             VARCHAR2(4000 CHAR);
        VP_VER_SEQ                 VARCHAR2(4000 CHAR);
        VP_DEPARTMENT_ID           VARCHAR2(4000 CHAR);
        VP_DEPT_ID                 VARCHAR2(4000 CHAR);
        VP_END_CUST_REPORT         VARCHAR2(4000 CHAR);
        VP_SOLDTO_CUST_REPORT      VARCHAR2(4000 CHAR);
        VP_PRODUCT_GROUP           VARCHAR2(4000 CHAR);
        VP_DM_BIZ_TYPE             VARCHAR2(4000 CHAR);
        VP_YYYYMM                  VARCHAR2(4000 CHAR);
        VP_OS_CORP_CD              VARCHAR2(4000 CHAR);
        VP_CONTRIBUTION_TYPE       VARCHAR2(4000 CHAR);
        VP_CONTRIBUTION_RATIO      VARCHAR2(4000 CHAR);
        VP_CREATED_BY              VARCHAR2(4000 CHAR);
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_active_flag' VALUE P_ACTIVE_FLAG
                                     ,'p_ver_seq' VALUE P_VER_SEQ
                                     ,'p_department_id' VALUE P_DEPARTMENT_ID
                                     ,'p_dept_id' VALUE P_DEPT_ID
                                     ,'p_end_cust_report' VALUE P_END_CUST_REPORT
                                     ,'p_soldto_cust_report' VALUE P_SOLDTO_CUST_REPORT
                                     ,'p_product_group' VALUE P_PRODUCT_GROUP
                                     ,'p_dm_biz_type' VALUE P_DM_BIZ_TYPE
                                     ,'p_yyyymm' VALUE P_YYYYMM
                                     ,'p_os_corp_cd' VALUE P_OS_CORP_CD
                                     ,'p_contribution_type' VALUE P_CONTRIBUTION_TYPE
                                     ,'p_contribution_ratio' VALUE P_CONTRIBUTION_RATIO
                                     ,'p_created_by' VALUE P_CREATED_BY);

        -- 스플릿관련 변수
        V_DELIMITER := '^'; -- 데이터 구분자

        VP_ACTIVE_FLAG        := RTRIM(P_ACTIVE_FLAG) || '^';
        VP_VER_SEQ            := RTRIM(P_VER_SEQ) || '^';
        VP_DEPARTMENT_ID      := RTRIM(P_DEPARTMENT_ID) || '^';
        VP_DEPT_ID            := RTRIM(P_DEPT_ID) || '^';
        VP_END_CUST_REPORT    := RTRIM(P_END_CUST_REPORT) || '^';
        VP_SOLDTO_CUST_REPORT := RTRIM(P_SOLDTO_CUST_REPORT) || '^';
        VP_PRODUCT_GROUP      := RTRIM(P_PRODUCT_GROUP) || '^';
        VP_DM_BIZ_TYPE        := RTRIM(P_DM_BIZ_TYPE) || '^';
        VP_YYYYMM             := RTRIM(P_YYYYMM) || '^';
        VP_OS_CORP_CD         := RTRIM(P_OS_CORP_CD) || '^';
        VP_CONTRIBUTION_TYPE  := RTRIM(P_CONTRIBUTION_TYPE) || '^';
        VP_CONTRIBUTION_RATIO := RTRIM(P_CONTRIBUTION_RATIO) || '^';
        VP_CREATED_BY         := RTRIM(P_CREATED_BY) || '^';

        -- GT_SDMCR_RESULTS_MST_2 TEMP TABLE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDMCR_RESULTS_MST_2';

        -- 시작 LOG  (START)
        V_LOG_TYPE        := 'START';
        V_LOG_MESSAGE     := '########## Start of procedure @@@##########';
        V_LOG_DESCRIPTION := NULL;
        D_EVENT_DATE      := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
        V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
        -- 시작 LOG  (END)
        -- 트랜잭션 (START)
        -- -----------------------------------------------------------------------------------------
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
        -- -----------------------------------------------------------------------------------------
        --===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO start
        --###############################################  GT_SDMCR_RESULTS_MST_2 테이블에 split후 insert (START)
        WHILE LENGTH(VP_VER_SEQ) > 0 LOOP

            V_INDEX_ACTIVE_FLAG        := INSTR(VP_ACTIVE_FLAG, '^');
            V_INDEX_VER_SEQ            := INSTR(VP_VER_SEQ, '^');
            V_INDEX_DEPARTMENT_ID      := INSTR(VP_DEPARTMENT_ID, '^');
            V_INDEX_DEPT_ID            := INSTR(VP_DEPT_ID, '^');
            V_INDEX_END_CUST_REPORT    := INSTR(VP_END_CUST_REPORT, '^');
            V_INDEX_SOLDTO_CUST_REPORT := INSTR(VP_SOLDTO_CUST_REPORT, '^');
            V_INDEX_PRODUCT_GROUP      := INSTR(VP_PRODUCT_GROUP, '^');
            V_INDEX_DM_BIZ_TYPE        := INSTR(VP_DM_BIZ_TYPE, '^');
            V_INDEX_YYYYMM             := INSTR(VP_YYYYMM, '^');
            V_INDEX_OS_CORP_CD         := INSTR(VP_OS_CORP_CD, '^');
            V_INDEX_CONTRIBUTION_TYPE  := INSTR(VP_CONTRIBUTION_TYPE, '^');
            V_INDEX_CONTRIBUTION_RATIO := INSTR(VP_CONTRIBUTION_RATIO, '^');
            V_INDEX_CREATED_BY         := INSTR(VP_CREATED_BY, '^');

            IF VP_VER_SEQ IS NOT NULL THEN

                V_ACTIVE_FLAG        := SUBSTR(VP_ACTIVE_FLAG, 0, V_INDEX_ACTIVE_FLAG - 1);
                V_VER_SEQ            := TO_NUMBER(SUBSTR(VP_VER_SEQ, 0, V_INDEX_VER_SEQ - 1));
                V_DEPARTMENT_ID      := SUBSTR(VP_DEPARTMENT_ID, 0, V_INDEX_DEPARTMENT_ID - 1);
                V_DEPT_ID            := SUBSTR(VP_DEPT_ID, 0, V_INDEX_DEPT_ID - 1);
                V_END_CUST_REPORT    := SUBSTR(VP_END_CUST_REPORT, 0, V_INDEX_END_CUST_REPORT - 1);
                V_SOLDTO_CUST_REPORT := SUBSTR(VP_SOLDTO_CUST_REPORT, 0, V_INDEX_SOLDTO_CUST_REPORT - 1);
                V_PRODUCT_GROUP      := SUBSTR(VP_PRODUCT_GROUP, 0, V_INDEX_PRODUCT_GROUP - 1);
                V_DM_BIZ_TYPE        := SUBSTR(VP_DM_BIZ_TYPE, 0, V_INDEX_DM_BIZ_TYPE - 1);
                V_YYYYMM             := SUBSTR(VP_YYYYMM, 0, V_INDEX_YYYYMM - 1);
                V_OS_CORP_CD         := SUBSTR(VP_OS_CORP_CD, 0, V_INDEX_OS_CORP_CD - 1);
                V_CONTRIBUTION_TYPE  := SUBSTR(VP_CONTRIBUTION_TYPE, 0, V_INDEX_CONTRIBUTION_TYPE - 1);
                V_CONTRIBUTION_RATIO := SUBSTR(VP_CONTRIBUTION_RATIO, 0, V_INDEX_CONTRIBUTION_RATIO - 1);
                V_CREATED_BY         := SUBSTR(VP_CREATED_BY, 0, V_INDEX_CREATED_BY - 1);

                VP_ACTIVE_FLAG        := SUBSTR(VP_ACTIVE_FLAG, LENGTH(V_ACTIVE_FLAG || '^') + 1, LENGTH(VP_ACTIVE_FLAG));
                VP_VER_SEQ            := SUBSTR(VP_VER_SEQ, LENGTH(V_VER_SEQ || '^') + 1, LENGTH(VP_VER_SEQ));
                VP_DEPARTMENT_ID      := SUBSTR(VP_DEPARTMENT_ID, LENGTH(V_DEPARTMENT_ID || '^') + 1, LENGTH(VP_DEPARTMENT_ID));
                VP_DEPT_ID            := SUBSTR(VP_DEPT_ID, LENGTH(V_DEPT_ID || '^') + 1, LENGTH(VP_DEPT_ID));
                VP_END_CUST_REPORT    := SUBSTR(VP_END_CUST_REPORT, LENGTH(V_END_CUST_REPORT || '^') + 1, LENGTH(VP_END_CUST_REPORT));
                VP_SOLDTO_CUST_REPORT := SUBSTR(VP_SOLDTO_CUST_REPORT, LENGTH(V_SOLDTO_CUST_REPORT || '^') + 1, LENGTH(VP_SOLDTO_CUST_REPORT));
                VP_PRODUCT_GROUP      := SUBSTR(VP_PRODUCT_GROUP, LENGTH(V_PRODUCT_GROUP || '^') + 1, LENGTH(VP_PRODUCT_GROUP));
                VP_DM_BIZ_TYPE        := SUBSTR(VP_DM_BIZ_TYPE, LENGTH(V_DM_BIZ_TYPE || '^') + 1, LENGTH(VP_DM_BIZ_TYPE));
                VP_YYYYMM             := SUBSTR(VP_YYYYMM, LENGTH(V_YYYYMM || '^') + 1, LENGTH(VP_YYYYMM));
                VP_OS_CORP_CD         := SUBSTR(VP_OS_CORP_CD, LENGTH(V_OS_CORP_CD || '^') + 1, LENGTH(VP_OS_CORP_CD));
                VP_CONTRIBUTION_TYPE  := SUBSTR(VP_CONTRIBUTION_TYPE, LENGTH(V_CONTRIBUTION_TYPE || '^') + 1, LENGTH(VP_CONTRIBUTION_TYPE));
                VP_CONTRIBUTION_RATIO := SUBSTR(VP_CONTRIBUTION_RATIO, LENGTH(V_CONTRIBUTION_RATIO || '^') + 1, LENGTH(VP_CONTRIBUTION_RATIO));
                VP_CREATED_BY         := SUBSTR(VP_CREATED_BY, LENGTH(V_CREATED_BY || '^') + 1, LENGTH(VP_CREATED_BY));

                --공백제거
                V_ACTIVE_FLAG        := RTRIM(LTRIM(V_ACTIVE_FLAG));
                V_VER_SEQ            := RTRIM(LTRIM(V_VER_SEQ));
                V_DEPARTMENT_ID      := RTRIM(LTRIM(V_DEPARTMENT_ID));
                V_DEPT_ID            := RTRIM(LTRIM(V_DEPT_ID));
                V_END_CUST_REPORT    := RTRIM(LTRIM(V_END_CUST_REPORT));
                V_SOLDTO_CUST_REPORT := RTRIM(LTRIM(V_SOLDTO_CUST_REPORT));
                V_PRODUCT_GROUP      := RTRIM(LTRIM(V_PRODUCT_GROUP));
                V_DM_BIZ_TYPE        := RTRIM(LTRIM(V_DM_BIZ_TYPE));
                V_YYYYMM             := RTRIM(LTRIM(V_YYYYMM));
                V_OS_CORP_CD         := RTRIM(LTRIM(V_OS_CORP_CD));
                V_CONTRIBUTION_TYPE  := RTRIM(LTRIM(V_CONTRIBUTION_TYPE));
                V_CONTRIBUTION_RATIO := RTRIM(LTRIM(V_CONTRIBUTION_RATIO));
                V_CREATED_BY         := RTRIM(LTRIM(V_CREATED_BY));
                --공백제거
                -------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
                IF LENGTH(V_YYYYMM) > 4 THEN
                    INSERT /*+ NO_PARALLEL */
                    INTO GT_SDMCR_RESULTS_MST_2
                        (ACTIVE_FLAG
                        ,VER_SEQ
                        ,DEPARTMENT_ID
                        ,DEPT_ID
                        ,END_CUST_REPORT
                        ,SOLDTO_CUST_REPORT
                        ,PRODUCT_GROUP
                        ,DM_BIZ_TYPE
                        ,YYYYMM
                        ,OS_CORP_CD
                        ,CONTRIBUTION_TYPE
                        ,CONTRIBUTION_RATIO
                        ,CREATED_BY)
                    VALUES
                        (V_ACTIVE_FLAG
                        ,V_VER_SEQ
                        ,V_DEPARTMENT_ID
                        ,V_DEPT_ID
                        ,V_END_CUST_REPORT
                        ,V_SOLDTO_CUST_REPORT
                        ,V_PRODUCT_GROUP
                        ,V_DM_BIZ_TYPE
                        ,V_YYYYMM
                        ,V_OS_CORP_CD
                        ,V_CONTRIBUTION_TYPE
                        ,V_CONTRIBUTION_RATIO
                        ,V_CREATED_BY);
                ELSE
                    -- 년모드인 경우 (12개월을 INSERT함)
                    BEGIN
                        INSERT /*+ NO_PARALLEL */
                        INTO GT_SDMCR_RESULTS_MST_2
                            (ACTIVE_FLAG
                            ,VER_SEQ
                            ,DEPARTMENT_ID
                            ,DEPT_ID
                            ,END_CUST_REPORT
                            ,SOLDTO_CUST_REPORT
                            ,PRODUCT_GROUP
                            ,DM_BIZ_TYPE
                            ,YYYYMM
                            ,OS_CORP_CD
                            ,CONTRIBUTION_TYPE
                            ,CONTRIBUTION_RATIO
                            ,CREATED_BY)
                            SELECT V_ACTIVE_FLAG
                                  ,V_VER_SEQ
                                  ,V_DEPARTMENT_ID
                                  ,V_DEPT_ID
                                  ,V_END_CUST_REPORT
                                  ,V_SOLDTO_CUST_REPORT
                                  ,V_PRODUCT_GROUP
                                  ,V_DM_BIZ_TYPE
                                  ,BASIS_YYYYMM
                                  ,V_OS_CORP_CD
                                  ,V_CONTRIBUTION_TYPE
                                  ,V_CONTRIBUTION_RATIO
                                  ,V_CREATED_BY
                            FROM   SCM_SYS_CALENDAR_M
                            WHERE  SUBSTR(BASIS_YYYYMM, 1, 4) = V_YYYYMM
                            GROUP  BY BASIS_YYYYMM;
                    END;
                END IF;
                -------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
            ELSE
                V_VER_SEQ  := VP_VER_SEQ;
                VP_VER_SEQ := NULL;

                --공백제거
                V_ACTIVE_FLAG        := RTRIM(LTRIM(V_ACTIVE_FLAG));
                V_VER_SEQ            := RTRIM(LTRIM(V_VER_SEQ));
                V_DEPARTMENT_ID      := RTRIM(LTRIM(V_DEPARTMENT_ID));
                V_DEPT_ID            := RTRIM(LTRIM(V_DEPT_ID));
                V_END_CUST_REPORT    := RTRIM(LTRIM(V_END_CUST_REPORT));
                V_SOLDTO_CUST_REPORT := RTRIM(LTRIM(V_SOLDTO_CUST_REPORT));
                V_PRODUCT_GROUP      := RTRIM(LTRIM(V_PRODUCT_GROUP));
                V_DM_BIZ_TYPE        := RTRIM(LTRIM(V_DM_BIZ_TYPE));
                V_YYYYMM             := RTRIM(LTRIM(V_YYYYMM));
                V_OS_CORP_CD         := RTRIM(LTRIM(V_OS_CORP_CD));
                V_CONTRIBUTION_TYPE  := RTRIM(LTRIM(V_CONTRIBUTION_TYPE));
                V_CONTRIBUTION_RATIO := RTRIM(LTRIM(V_CONTRIBUTION_RATIO));
                V_CREATED_BY         := RTRIM(LTRIM(V_CREATED_BY));
                --공백제거
                -------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
                IF LENGTH(V_YYYYMM) > 4 THEN
                    INSERT /*+ NO_PARALLEL */
                    INTO GT_SDMCR_RESULTS_MST_2
                        (ACTIVE_FLAG
                        ,VER_SEQ
                        ,DEPARTMENT_ID
                        ,DEPT_ID
                        ,END_CUST_REPORT
                        ,SOLDTO_CUST_REPORT
                        ,PRODUCT_GROUP
                        ,DM_BIZ_TYPE
                        ,YYYYMM
                        ,OS_CORP_CD
                        ,CONTRIBUTION_TYPE
                        ,CONTRIBUTION_RATIO
                        ,CREATED_BY)
                    VALUES
                        (V_ACTIVE_FLAG
                        ,V_VER_SEQ
                        ,V_DEPARTMENT_ID
                        ,V_DEPT_ID
                        ,V_END_CUST_REPORT
                        ,V_SOLDTO_CUST_REPORT
                        ,V_PRODUCT_GROUP
                        ,V_DM_BIZ_TYPE
                        ,V_YYYYMM
                        ,V_OS_CORP_CD
                        ,V_CONTRIBUTION_TYPE
                        ,V_CONTRIBUTION_RATIO
                        ,V_CREATED_BY);
                ELSE
                    -- 년모드인 경우 (12개월을 INSERT함)
                    BEGIN
                        INSERT /*+ NO_PARALLEL */
                        INTO GT_SDMCR_RESULTS_MST_2
                            (ACTIVE_FLAG
                            ,VER_SEQ
                            ,DEPARTMENT_ID
                            ,DEPT_ID
                            ,END_CUST_REPORT
                            ,SOLDTO_CUST_REPORT
                            ,PRODUCT_GROUP
                            ,DM_BIZ_TYPE
                            ,YYYYMM
                            ,OS_CORP_CD
                            ,CONTRIBUTION_TYPE
                            ,CONTRIBUTION_RATIO
                            ,CREATED_BY)
                            SELECT V_ACTIVE_FLAG
                                  ,V_VER_SEQ
                                  ,V_DEPARTMENT_ID
                                  ,V_DEPT_ID
                                  ,V_END_CUST_REPORT
                                  ,V_SOLDTO_CUST_REPORT
                                  ,V_PRODUCT_GROUP
                                  ,V_DM_BIZ_TYPE
                                  ,BASIS_YYYYMM
                                  ,V_OS_CORP_CD
                                  ,V_CONTRIBUTION_TYPE
                                  ,V_CONTRIBUTION_RATIO
                                  ,V_CREATED_BY
                            FROM   SCM_SYS_CALENDAR_M
                            WHERE  SUBSTR(BASIS_YYYYMM, 1, 4) = V_YYYYMM
                            GROUP  BY BASIS_YYYYMM;
                    END;
                END IF;
                -------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
            END IF;
        END LOOP;

        --===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO end
        --select department_id
        --      ,dept_id
        --      ,end_cust_report
        --      ,soldto_cust_report
        --      ,product_group
        --      ,dm_biz_type
        --      , Contribution_Type
        --      , SUM(CAST (Contribution_Ratio AS NUMBER(5,2)))
        --from GT_SDMCR_RESULTS_MST_2
        --GROUP BY department_id
        --      ,dept_id
        --      ,end_cust_report
        --      ,soldto_cust_report
        --      ,product_group
        --      ,dm_biz_type
        --      , Contribution_Type
        --RAISE_APPLICATION_ERROR(-20001, 'sdf')
        -- INPUT COUNT 확인
        SELECT COUNT(VER_SEQ) INTO N_INPUT_COUNT FROM GT_SDMCR_RESULTS_MST_2;

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (START)
        --------------------------------------------------------------------------------------------◇◇◇◇
        BEGIN
            -- INSERT INTO COUNT 확인
            SELECT COUNT(M.VER_SEQ) INTO N_LOGO_COUNT FROM GT_SDMCR_RESULTS_MST_2 M WHERE 1 = 1;

            -- MST INSERT전 DELETE수행 (BEGIN)
            DELETE FROM DM_MST_CONTRIBUTE_RATIO_MST
            WHERE  EXISTS (SELECT 1
                    FROM   GT_SDMCR_RESULTS_MST_2 M
                    WHERE  1 = 1
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.VER_SEQ = M.VER_SEQ
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.DEPARTMENT_ID = M.DEPARTMENT_ID
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.DEPT_ID = M.DEPT_ID
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.END_CUST_REPORT = M.END_CUST_REPORT
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.SOLDTO_CUST_REPORT = M.SOLDTO_CUST_REPORT
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.PRODUCT_GROUP = M.PRODUCT_GROUP
                    AND    DM_MST_CONTRIBUTE_RATIO_MST.DM_BIZ_TYPE = M.DM_BIZ_TYPE);
            -- MST INSERT전 DELETE수행 (END)
            -- MST INSERT수행 (BEGIN)
            INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
                (VER_SEQ
                ,DEPARTMENT_ID
                ,DEPT_ID
                ,END_CUST_REPORT
                ,SOLDTO_CUST_REPORT
                ,PRODUCT_GROUP
                ,DM_BIZ_TYPE
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE)
                SELECT TO_NUMBER(VER_SEQ)
                      ,DEPARTMENT_ID
                      ,DEPT_ID
                      ,END_CUST_REPORT
                      ,SOLDTO_CUST_REPORT
                      ,PRODUCT_GROUP
                      ,DM_BIZ_TYPE
                      ,MAX(CREATED_BY)
                      ,SYSDATE
                      ,MAX(CREATED_BY) LAST_UPDATED_BY
                      ,SYSDATE
                FROM   GT_SDMCR_RESULTS_MST_2
                WHERE  1 = 1
                GROUP  BY TO_NUMBER(VER_SEQ), DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE;
            -- MST INSERT수행 (END)
        END;
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (END)
        --------------------------------------------------------------------------------------------◇◇◇◇
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (START)
        --------------------------------------------------------------------------------------------◇◇◇◇

        -- DTL INSERT전 DELETE수행 (BEGIN)
        DELETE FROM DM_MST_CONTRIBUTE_RATIO_DTL
        WHERE  EXISTS (SELECT 1
                FROM   GT_SDMCR_RESULTS_MST_2 M
                WHERE  1 = 1
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.VER_SEQ = M.VER_SEQ
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.DEPARTMENT_ID = M.DEPARTMENT_ID
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.DEPT_ID = M.DEPT_ID
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.END_CUST_REPORT = M.END_CUST_REPORT
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.SOLDTO_CUST_REPORT = M.SOLDTO_CUST_REPORT
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.PRODUCT_GROUP = M.PRODUCT_GROUP
                AND    DM_MST_CONTRIBUTE_RATIO_DTL.DM_BIZ_TYPE = M.DM_BIZ_TYPE);
        -- DTL INSERT전 DELETE수행 (END)
        -- DTL INSERT수행 (BEGIN)
        INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
            (VER_SEQ
            ,DEPARTMENT_ID
            ,DEPT_ID
            ,END_CUST_REPORT
            ,SOLDTO_CUST_REPORT
            ,PRODUCT_GROUP
            ,DM_BIZ_TYPE
            ,YYYYMM
            ,OS_CORP_CD
            ,CONTRIBUTION_TYPE
            ,CONTRIBUTION_RATIO
            ,CREATED_BY
            ,CREATION_DATE
            ,LAST_UPDATED_BY
            ,LAST_UPDATE_DATE)
            SELECT VER_SEQ
                  ,DEPARTMENT_ID
                  ,DEPT_ID
                  ,END_CUST_REPORT
                  ,SOLDTO_CUST_REPORT
                  ,PRODUCT_GROUP
                  ,DM_BIZ_TYPE
                  ,YYYYMM
                  ,OS_CORP_CD
                  ,CONTRIBUTION_TYPE
                  ,CONTRIBUTION_RATIO
                  ,CREATED_BY
                  ,SYSDATE
                  ,CREATED_BY LAST_UPDATED_BY
                  ,SYSDATE
            FROM   GT_SDMCR_RESULTS_MST_2
            WHERE  1 = 1;
        -- DTL INSERT수행 (END)

        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (END)
        --------------------------------------------------------------------------------------------◇◇◇◇
        -- 트랜잭션 (COMMIT)
        -- -----------------------------------------------------------------------------------------
        -- END TRY
        -- -----------------------------------------------------------------------------------------
        COMMIT;
        -- -----------------------------------------------------------
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            -- -----------------------------------------------------------
            --[C20200909-000203] LOG 표준화 적용
            -- 트랜잭션 (END)
            V_LOG_TYPE        := 'ERROR';
            V_LOG_MESSAGE     := SUBSTR(SQLERRM, 1, 1000);
            V_LOG_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
            D_EVENT_DATE      := SYSTIMESTAMP;

            V_LOG_MESSAGE := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM; /*-- 에러메시지 DISPLAY --*/

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_LOG_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA    => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE    => SQLCODE
                                ,P_SQL_ERR_MSG     => SQLERRM
                                ,P_SQL_BACKTRACE   => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            -- -----------------------------------------------------------
            -- END CATCH
            -- -----------------------------------------------------------
            -- 수행결과 성공여부 DISPLAY
            ROLLBACK;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_LOG_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA    => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE    => SQLCODE
                                ,P_SQL_ERR_MSG     => SQLERRM
                                ,P_SQL_BACKTRACE   => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE_APPLICATION_ERROR(-20001
                                   ,'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE || ' / SQLERRM=' || SQLERRM || ' / BACKTRACE=' ||
                                    DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' / PARAMS=' || V_IN_PARA_DATA);
    END P_DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO;

    PROCEDURE P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
    (
        P_ACTIVE_FLAG   VARCHAR2
       ,P_VER_SEQ       VARCHAR2
       ,P_YYYY          VARCHAR2
       ,P_VERSION_NM    VARCHAR2
       ,P_DESCRIPTION   VARCHAR2
       ,P_VALID_YN      VARCHAR2
       ,P_CREATED_BY    VARCHAR2
       ,O_RESULT_CURSOR OUT SYS_REFCURSOR
    )
    /*
        * Program ID   : DMF0043_SAVE_DM_MST_CONTRIBUTE_VER
        * Description  : 'DM_MST_CONTRIBUTE_VER' TABLE INSERT/UPDATE/DELETE
        * Program History
        *===================================================================================================
        *   Date       In Charge      Description
        *===================================================================================================
        * 20190508  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
        2020/09/09     P.C.I   [C20200909-000203] LOG 표준화 적용
        * 2026/03/15 김준규 [PJ20264226] NextSCM Pilot 설계 및 개발
        *
        */
     AS

        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_VER_SEQ           VARCHAR2(4000 CHAR);
        V_YYYY              VARCHAR2(4000 CHAR);
        V_VERSION_NM        VARCHAR2(4000 CHAR);
        V_DESCRIPTION       VARCHAR2(4000 CHAR);
        V_VALID_YN          VARCHAR2(4000 CHAR);
        V_CREATED_BY        VARCHAR2(4000 CHAR);
        V_DELIMITER         VARCHAR2(1 CHAR);
        V_MAX_LOOP_CNT      INTEGER := 0;
        V_MST_LOOP_CNT      INTEGER := 0;
        V_MAX_VER_SEQ       VARCHAR2(4000 CHAR);
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         INTEGER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_LOG_DESCRIPTION   VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;
        N_DELETE_COUNT      INTEGER := 0;
        N_INSERT_COUNT      INTEGER := 0;
        N_INPUT_COUNT       INTEGER := 0;
        N_LOGO_COUNT        INTEGER := 0;
        V_INDEX_ACTIVE_FLAG INTEGER;
        V_INDEX_VER_SEQ     INTEGER;
        V_INDEX_YYYY        INTEGER;
        V_INDEX_VERSION_NM  INTEGER;
        V_INDEX_DESCRIPTION INTEGER;
        V_INDEX_VALID_YN    INTEGER;
        V_INDEX_CREATED_BY  INTEGER;
        V_IN_PARA_DATA      VARCHAR2(4000);
        V_W_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
        V_W_VER_SEQ         VARCHAR2(4000 CHAR);
        V_W_YYYY            VARCHAR2(4000 CHAR);
        V_W_VERSION_NM      VARCHAR2(4000 CHAR);
        V_W_DESCRIPTION     VARCHAR2(4000 CHAR);
        V_W_VALID_YN        VARCHAR2(4000 CHAR);
        V_W_CREATED_BY      VARCHAR2(4000 CHAR);
    BEGIN

        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            V_PROGRAM_NAME := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;

        V_IN_PARA_DATA := JSON_OBJECT('p_active_flag' VALUE P_ACTIVE_FLAG
                                     ,'p_ver_seq' VALUE P_VER_SEQ
                                     ,'p_yyyy' VALUE P_YYYY
                                     ,'p_version_nm' VALUE P_VERSION_NM
                                     ,'p_description' VALUE P_DESCRIPTION
                                     ,'p_valid_yn' VALUE P_VALID_YN
                                     ,'p_created_by' VALUE P_CREATED_BY);

        -- 스플릿관련 변수
        V_DELIMITER := '^'; -- 데이터 구분자

        V_W_ACTIVE_FLAG := RTRIM(P_ACTIVE_FLAG) || '^';
        V_W_VER_SEQ     := RTRIM(P_VER_SEQ) || '^';
        V_W_YYYY        := RTRIM(P_YYYY) || '^';
        V_W_VERSION_NM  := RTRIM(P_VERSION_NM) || '^';
        V_W_DESCRIPTION := RTRIM(P_DESCRIPTION) || '^';
        V_W_VALID_YN    := RTRIM(P_VALID_YN) || '^';
        V_W_CREATED_BY  := RTRIM(P_CREATED_BY) || '^';

        -- GT_SDMCV_RESULTS_MST_2 TEMP TABLE
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_SDMCV_RESULTS_MST_2';

        -- 시작 LOG  (START)
        V_LOG_TYPE        := 'START';
        V_LOG_MESSAGE     := '########## Start of procedure @@@##########';
        V_LOG_DESCRIPTION := NULL;
        D_EVENT_DATE      := SYSTIMESTAMP;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
        V_LOG_MESSAGE := NULL; /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
        -- 시작 LOG  (END)
        -- 트랜잭션 (START)
        -- -----------------------------------------------------------------------------------------
        -- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
        -- -----------------------------------------------------------------------------------------
        --===================================================================================== GT_SDMCV_RESULTS_MST_2 테이블에 split후 INSERT INTO start
        --###############################################  GT_SDMCV_RESULTS_MST_2 테이블에 split후 insert (START)
        WHILE LENGTH(V_W_YYYY) > 0 LOOP

            V_INDEX_ACTIVE_FLAG := INSTR(V_W_ACTIVE_FLAG, '^');
            V_INDEX_VER_SEQ     := INSTR(V_W_VER_SEQ, '^');
            V_INDEX_YYYY        := INSTR(V_W_YYYY, '^');
            V_INDEX_VERSION_NM  := INSTR(V_W_VERSION_NM, '^');
            V_INDEX_DESCRIPTION := INSTR(V_W_DESCRIPTION, '^');
            V_INDEX_VALID_YN    := INSTR(V_W_VALID_YN, '^');
            V_INDEX_CREATED_BY  := INSTR(V_W_CREATED_BY, '^');

            IF V_INDEX_YYYY > 0 THEN

                V_ACTIVE_FLAG   := SUBSTR(V_W_ACTIVE_FLAG, 0, V_INDEX_ACTIVE_FLAG - 1);
                V_W_ACTIVE_FLAG := SUBSTR(V_W_ACTIVE_FLAG, LENGTH(V_ACTIVE_FLAG || '^') + 1, LENGTH(V_W_ACTIVE_FLAG));

                V_VER_SEQ   := SUBSTR(V_W_VER_SEQ, 0, V_INDEX_VER_SEQ - 1);
                V_W_VER_SEQ := SUBSTR(V_W_VER_SEQ, LENGTH(V_VER_SEQ || '^') + 1, LENGTH(V_W_VER_SEQ));

                V_YYYY   := SUBSTR(V_W_YYYY, 0, V_INDEX_YYYY - 1);
                V_W_YYYY := SUBSTR(V_W_YYYY, LENGTH(V_YYYY || '^') + 1, LENGTH(V_W_YYYY));

                V_VERSION_NM   := SUBSTR(V_W_VERSION_NM, 0, V_INDEX_VERSION_NM - 1);
                V_W_VERSION_NM := SUBSTR(V_W_VERSION_NM, LENGTH(V_VERSION_NM || '^') + 1, LENGTH(V_W_VERSION_NM));

                V_DESCRIPTION   := SUBSTR(V_W_DESCRIPTION, 0, V_INDEX_DESCRIPTION - 1);
                V_W_DESCRIPTION := SUBSTR(V_W_DESCRIPTION, LENGTH(V_DESCRIPTION || '^') + 1, LENGTH(V_W_DESCRIPTION));

                V_VALID_YN   := SUBSTR(V_W_VALID_YN, 0, V_INDEX_VALID_YN - 1);
                V_W_VALID_YN := SUBSTR(V_W_VALID_YN, LENGTH(V_VALID_YN || '^') + 1, LENGTH(V_W_VALID_YN));

                V_CREATED_BY   := SUBSTR(V_W_CREATED_BY, 0, V_INDEX_CREATED_BY - 1);
                V_W_CREATED_BY := SUBSTR(V_W_CREATED_BY, LENGTH(V_CREATED_BY || '^') + 1, LENGTH(V_W_CREATED_BY));

                --공백제거
                V_ACTIVE_FLAG := RTRIM(LTRIM(V_ACTIVE_FLAG));
                V_VER_SEQ     := RTRIM(LTRIM(V_VER_SEQ));
                V_YYYY        := RTRIM(LTRIM(V_YYYY));
                V_VERSION_NM  := RTRIM(LTRIM(V_VERSION_NM));
                V_DESCRIPTION := RTRIM(LTRIM(V_DESCRIPTION));
                V_VALID_YN    := RTRIM(LTRIM(V_VALID_YN));
                V_CREATED_BY  := RTRIM(LTRIM(V_CREATED_BY));
                --공백제거
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDMCV_RESULTS_MST_2
                    (ACTIVE_FLAG, VER_SEQ, YYYY, VERSION_NM, DESCRIPTION, VALID_YN, CREATED_BY)
                VALUES
                    (V_ACTIVE_FLAG, V_VER_SEQ, V_YYYY, V_VERSION_NM, V_DESCRIPTION, V_VALID_YN, V_CREATED_BY);

            ELSE
                V_YYYY   := V_W_YYYY;
                V_W_YYYY := NULL;

                --공백제거
                V_ACTIVE_FLAG := RTRIM(LTRIM(V_ACTIVE_FLAG));
                V_VER_SEQ     := RTRIM(LTRIM(V_VER_SEQ));
                V_YYYY        := RTRIM(LTRIM(V_YYYY));
                V_VERSION_NM  := RTRIM(LTRIM(V_VERSION_NM));
                V_DESCRIPTION := RTRIM(LTRIM(V_DESCRIPTION));
                V_VALID_YN    := RTRIM(LTRIM(V_VALID_YN));
                V_CREATED_BY  := RTRIM(LTRIM(V_CREATED_BY));
                --공백제거
                INSERT /*+ NO_PARALLEL */
                INTO GT_SDMCV_RESULTS_MST_2
                    (ACTIVE_FLAG, VER_SEQ, YYYY, VERSION_NM, DESCRIPTION, VALID_YN, CREATED_BY)
                VALUES
                    (V_ACTIVE_FLAG, V_VER_SEQ, V_YYYY, V_VERSION_NM, V_DESCRIPTION, V_VALID_YN, V_CREATED_BY);
            END IF;
        END LOOP;

        --===================================================================================== GT_SDMCV_RESULTS_MST_2 테이블에 split후 INSERT INTO end
        -- INPUT COUNT 확인
        SELECT COUNT(YYYY) INTO N_INPUT_COUNT FROM GT_SDMCV_RESULTS_MST_2;
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (START)
        --------------------------------------------------------------------------------------------◇◇◇◇
        BEGIN

            -- DELETE FROM COUNT 확인
            SELECT COUNT(YYYY)
            INTO   N_DELETE_COUNT
            FROM   DM_MST_CONTRIBUTE_VER A
            WHERE  (SELECT COUNT(1)
                    FROM   GT_SDMCV_RESULTS_MST_2 M
                    WHERE  M.ACTIVE_FLAG = 'D'
                    AND    A.VER_SEQ = M.VER_SEQ) > 0;

            --  select * from GT_SDMCV_RESULTS_MST_2
            DELETE FROM DM_MST_CONTRIBUTE_VER
            WHERE  (SELECT COUNT(1)
                    FROM   GT_SDMCV_RESULTS_MST_2 M
                    WHERE  M.ACTIVE_FLAG = 'D'
                    AND    DM_MST_CONTRIBUTE_VER.VER_SEQ = M.VER_SEQ) > 0;
        END;
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                                  DM_MST_CONTRIBUTE_VER 테이블 DELETE (END)
        --------------------------------------------------------------------------------------------◇◇◇◇
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (START)
        --------------------------------------------------------------------------------------------◇◇◇◇

        -- INSERT INTO COUNT 확인
        SELECT COUNT(M.YYYY) INTO N_INSERT_COUNT FROM GT_SDMCV_RESULTS_MST_2 M WHERE M.ACTIVE_FLAG <> 'D';

        MERGE INTO DM_MST_CONTRIBUTE_VER A
        USING (SELECT * FROM GT_SDMCV_RESULTS_MST_2 M WHERE M.ACTIVE_FLAG <> 'D') B
        ON (A.VER_SEQ = B.VER_SEQ)
        WHEN MATCHED THEN
            UPDATE
            SET    A.YYYY             = B.YYYY
                  ,A.VERSION_NM       = B.VERSION_NM
                  ,A.DESCRIPTION      = B.DESCRIPTION
                  ,A.VALID_YN         = B.VALID_YN
                  ,A.LAST_UPDATED_BY  = B.CREATED_BY
                  ,A.LAST_UPDATE_DATE = SYSDATE


        WHEN NOT MATCHED THEN

            INSERT
                ( -- VER_SEQ
                 YYYY
                ,VERSION_NM
                ,DESCRIPTION
                ,VALID_YN
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5)
            VALUES
                (B.YYYY, B.VERSION_NM, B.DESCRIPTION, B.VALID_YN, B.CREATED_BY, SYSDATE, B.CREATED_BY, SYSDATE, NULL, NULL, NULL, NULL, NULL);

        -- 기여율 copy
        SELECT MAX(VER_SEQ) INTO V_MAX_VER_SEQ FROM DM_MST_CONTRIBUTE_VER;
        IF SQL%ROWCOUNT >= 0 THEN
            SELECT COUNT(1) INTO N_LOGO_COUNT FROM DM_MST_CONTRIBUTE_RATIO_MST WHERE VER_SEQ = V_MAX_VER_SEQ;
        END IF;
        IF N_LOGO_COUNT = 0 THEN
            INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
                (VER_SEQ
                ,DEPARTMENT_ID
                ,DEPT_ID
                ,END_CUST_REPORT
                ,SOLDTO_CUST_REPORT
                ,PRODUCT_GROUP
                ,DM_BIZ_TYPE
                ,YYYYMM
                ,OS_CORP_CD
                ,CONTRIBUTION_TYPE
                ,CONTRIBUTION_RATIO
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5)
                SELECT V_MAX_VER_SEQ AS VER_SEQ
                      ,DEPARTMENT_ID
                      ,DEPT_ID
                      ,END_CUST_REPORT
                      ,SOLDTO_CUST_REPORT
                      ,PRODUCT_GROUP
                      ,DM_BIZ_TYPE
                      ,(SELECT YYYY FROM DM_MST_CONTRIBUTE_VER WHERE VER_SEQ = V_MAX_VER_SEQ) || SUBSTR(YYYYMM, 5, 2)
                      ,OS_CORP_CD
                      ,CONTRIBUTION_TYPE
                      ,CONTRIBUTION_RATIO
                      ,P_CREATED_BY
                      ,SYSDATE
                      ,P_CREATED_BY
                      ,SYSDATE
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                FROM   DM_MST_CONTRIBUTE_RATIO_DTL
                WHERE  VER_SEQ = (SELECT MAX(VER_SEQ) FROM DM_MST_CONTRIBUTE_RATIO_MST);

            INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
                (VER_SEQ
                ,DEPARTMENT_ID
                ,DEPT_ID
                ,END_CUST_REPORT
                ,SOLDTO_CUST_REPORT
                ,PRODUCT_GROUP
                ,DM_BIZ_TYPE
                ,CREATED_BY
                ,CREATION_DATE
                ,LAST_UPDATED_BY
                ,LAST_UPDATE_DATE
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5)
                SELECT V_MAX_VER_SEQ AS VER_SEQ
                      ,DEPARTMENT_ID
                      ,DEPT_ID
                      ,END_CUST_REPORT
                      ,SOLDTO_CUST_REPORT
                      ,PRODUCT_GROUP
                      ,DM_BIZ_TYPE
                      ,P_CREATED_BY
                      ,SYSDATE
                      ,P_CREATED_BY
                      ,SYSDATE
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                      ,NULL
                FROM   DM_MST_CONTRIBUTE_RATIO_MST
                WHERE  VER_SEQ = (SELECT MAX(VER_SEQ) FROM DM_MST_CONTRIBUTE_RATIO_MST);

        END IF;
        --------------------------------------------------------------------------------------------◇◇◇◇
        --                                          DM_MST_CONTRIBUTE_VER 테이블 UPDATE, INSERT (END)
        --------------------------------------------------------------------------------------------◇◇◇◇
        -- 트랜잭션 (COMMIT)
        -- -----------------------------------------------------------------------------------------
        -- END TRY
        -- -----------------------------------------------------------------------------------------
        -- -----------------------------------------------------------
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            -- -----------------------------------------------------------
            --[C20200909-000203] LOG 표준화 적용
            -- 트랜잭션 (END)
            V_LOG_TYPE        := 'ERROR';
            V_LOG_MESSAGE     := SUBSTR(SQLERRM, 1, 1000);
            V_LOG_DESCRIPTION := 'ERROR_LINE : ' || TO_CHAR(NULL);
            D_EVENT_DATE      := SYSTIMESTAMP;

            V_LOG_MESSAGE := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM; /*-- 에러메시지 DISPLAY --*/

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME
                                ,V_LOG_TYPE
                                ,N_LOG_COUNT
                                ,V_LOG_MESSAGE
                                ,V_LOG_DESCRIPTION
                                ,D_EVENT_DATE
                                ,P_IN_PARA_DATA    => V_IN_PARA_DATA
                                ,P_SQL_ERR_CODE    => SQLCODE
                                ,P_SQL_ERR_MSG     => SQLERRM
                                ,P_SQL_BACKTRACE   => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            -- -----------------------------------------------------------
            -- END CATCH
            -- -----------------------------------------------------------
            -- 수행결과 성공여부 DISPLAY
            IF V_LOG_MESSAGE IS NULL THEN
                V_LOG_MESSAGE := 'success';

                -- 종료 LOG
                V_LOG_TYPE        := 'END';
                V_LOG_MESSAGE     := '########## END of procedure @@@##########';
                V_LOG_DESCRIPTION := 'input_count: ' || TO_CHAR(N_INPUT_COUNT);
                D_EVENT_DATE      := SYSTIMESTAMP;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);

            END IF;

    END P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER;

END PKG_DMF0043;/

-- ===== 3: DMF0043_GET_CONTRIBUTE_MAIN_DATA (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE           "DMF0043_GET_CONTRIBUTE_MAIN_DATA"
(
    p_yyyy	       IN  VARCHAR2,
    p_ver_seq	       IN  VARCHAR2,
    p_dis	       IN  VARCHAR2,
    p_his	       IN  VARCHAR2,
    p_created_by       IN  VARCHAR2,
    p_user_group       IN  VARCHAR2,
    O_RC1	       OUT SYS_REFCURSOR
)
/* 2026.05.20  ZIONEX	     [PJ202650304]  NextSCM Migration */
IS

    v_sdt	   VARCHAR2(10 CHAR) := p_yyyy || '01';
    v_edt	   VARCHAR2(10 CHAR) := p_yyyy || '12';
    v_thismm	   VARCHAR2(10 CHAR);
    v_ColumnData       CLOB := '';
    v_ColumnDataPivot  CLOB := '';
    v_ColumnData2      CLOB := '';
    v_Query	       CLOB := '';

    /* DMF0043_GET_MAIN_SPREAD_TITLE OUT 커서 수신용 */
    v_rc1	   SYS_REFCURSOR;
    v_rc2	   SYS_REFCURSOR;
    v_rc3	   SYS_REFCURSOR;

    /* #Title FETCH 작업변수 */
    v_PROGRAM_ID		       VARCHAR2(100 CHAR);
    v_SHEET_NAME		       VARCHAR2(100 CHAR);
    v_COLUMN_NAME		       VARCHAR2(100 CHAR);
    v_COLUMN_LABEL_NAME 	       VARCHAR2(100 CHAR);
    v_SORT_ORDER_NO		       VARCHAR2(100 CHAR);
    v_DATA_SORT_METHOD_CODE	       VARCHAR2(100 CHAR);
    v_SMALL_CLASS_LABEL_NAME	       VARCHAR2(100 CHAR);
    v_LARGE_CLASS_LABEL_NAME	       VARCHAR2(100 CHAR);
    v_DAY_CODE			       VARCHAR2(100 CHAR);
    v_FIXED_FLAG		       VARCHAR2(100 CHAR);
    v_COLUMN_WIDTH		       VARCHAR2(100 CHAR);
    v_CELL_CONTROL_OBJECT_TYPE_CODE    VARCHAR2(100 CHAR);
    v_CELL_COMBO_DATA_TYPE	       VARCHAR2(100 CHAR);
    v_DATA_SCALE_NUMBER 	       VARCHAR2(100 CHAR);
    v_DATA_MAX_LENGTH		       VARCHAR2(100 CHAR);
    v_HORIZONTAL_ALIGN_CODE	       VARCHAR2(100 CHAR);
    v_UPPERCASE_APPLY_FLAG	       VARCHAR2(100 CHAR);
    v_VISIBLE_FLAG		       VARCHAR2(100 CHAR);
    v_DEFAULT_FLAG		       VARCHAR2(100 CHAR);
    v_USER_SELECTABLE_FLAG	       VARCHAR2(100 CHAR);
    v_VALID_YN			       VARCHAR2(100 CHAR);
    v_DIVISION_ID		       VARCHAR2(100 CHAR);

BEGIN

    -- SET NOCOUNT ON; (Oracle: 불필요)

    IF (EXTRACT(MONTH FROM SYSDATE) < 10) THEN
	v_thismm := p_yyyy || '0' || TO_CHAR(EXTRACT(MONTH FROM SYSDATE));
    ELSE
	v_thismm := p_yyyy || TO_CHAR(EXTRACT(MONTH FROM SYSDATE));
    END IF;

    /* GTT 사전 정리 (세션 잔존 행 제거) — #temp/#temp2/#temp3/#Title DROP 대응 */
    DELETE FROM GT_DMF0043_TEMP;
    DELETE FROM GT_DMF0043_TEMP2;
    DELETE FROM GT_DMF0043_TEMP3;
    DELETE FROM GT_DMF0043_TITLE;
    DELETE FROM GT_DMF0043_MASTER_LIST;
    DELETE FROM GT_DMF0043_TEMP_LIST;
    DELETE FROM GT_DMF0043_DATA_TABLE;

    -- ######################## 해더 칼럼 데이터 ########################

    /* insert #Title exec DMF0043_GET_MAIN_SPREAD_TITLE '40',@p_yyyy,@p_created_by
       Oracle: OUT SYS_REFCURSOR 호출 후 FETCH 하여 GT_DMF0043_TITLE 적재 */
    DMF0043_GET_MAIN_SPREAD_TITLE
    (
	p_division_id => '40',
	p_yyyy	      => p_yyyy,
	p_created_by  => p_created_by,
	p_user_id     => p_created_by,
	p_menu_id     => 'DMF0043',
	O_RC1	      => v_rc1,
	O_RC2	      => v_rc2,
	O_RC3	      => v_rc3
    );

    LOOP
	FETCH v_rc1 INTO
	    v_PROGRAM_ID, v_SHEET_NAME, v_COLUMN_NAME, v_COLUMN_LABEL_NAME,
	    v_SORT_ORDER_NO, v_DATA_SORT_METHOD_CODE, v_SMALL_CLASS_LABEL_NAME,
	    v_LARGE_CLASS_LABEL_NAME, v_DAY_CODE, v_FIXED_FLAG, v_COLUMN_WIDTH,
	    v_CELL_CONTROL_OBJECT_TYPE_CODE, v_CELL_COMBO_DATA_TYPE,
	    v_DATA_SCALE_NUMBER, v_DATA_MAX_LENGTH, v_HORIZONTAL_ALIGN_CODE,
	    v_UPPERCASE_APPLY_FLAG, v_VISIBLE_FLAG, v_DEFAULT_FLAG,
	    v_USER_SELECTABLE_FLAG, v_VALID_YN, v_DIVISION_ID;
	EXIT WHEN v_rc1%NOTFOUND;

	INSERT INTO GT_DMF0043_TITLE
	(PROGRAM_ID, SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME,
	 SORT_ORDER_NO, DATA_SORT_METHOD_CODE, SMALL_CLASS_LABEL_NAME,
	 LARGE_CLASS_LABEL_NAME, DAY_CODE, FIXED_FLAG, COLUMN_WIDTH,
	 CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
	 DATA_SCALE_NUMBER, DATA_MAX_LENGTH, HORIZONTAL_ALIGN_CODE,
	 UPPERCASE_APPLY_FLAG, VISIBLE_FLAG, DEFAULT_FLAG,
	 USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID)
	VALUES
	(v_PROGRAM_ID, v_SHEET_NAME, v_COLUMN_NAME, v_COLUMN_LABEL_NAME,
	 v_SORT_ORDER_NO, v_DATA_SORT_METHOD_CODE, v_SMALL_CLASS_LABEL_NAME,
	 v_LARGE_CLASS_LABEL_NAME, v_DAY_CODE, v_FIXED_FLAG, v_COLUMN_WIDTH,
	 v_CELL_CONTROL_OBJECT_TYPE_CODE, v_CELL_COMBO_DATA_TYPE,
	 v_DATA_SCALE_NUMBER, v_DATA_MAX_LENGTH, v_HORIZONTAL_ALIGN_CODE,
	 v_UPPERCASE_APPLY_FLAG, v_VISIBLE_FLAG, v_DEFAULT_FLAG,
	 v_USER_SELECTABLE_FLAG, v_VALID_YN, v_DIVISION_ID);
    END LOOP;
    CLOSE v_rc1;
    BEGIN CLOSE v_rc2; EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_rc3; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- [Fix v2] LISTAGG -> CLOB cursor loop. MSSQL [col] -> Oracle "col" (delimited identifier).
    -- v_ColumnData	 = "col1","col2",...			   (SELECT column ref list)
    -- v_ColumnDataPivot = 'col1' AS "col1",...  (PIVOT IN list, Oracle syntax)
    v_ColumnData      := '';
    v_ColumnDataPivot := '';
    DECLARE v_first BOOLEAN := TRUE; BEGIN
      FOR r IN (SELECT COLUMN_NAME FROM GT_DMF0043_TITLE
		 WHERE TO_NUMBER(SORT_ORDER_NO) > (SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG')
		 ORDER BY TO_NUMBER(SORT_ORDER_NO)) LOOP
	IF v_first THEN
	  v_ColumnData	    := '"' || r.COLUMN_NAME || '"';
	  v_ColumnDataPivot := '''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"';
	  v_first := FALSE;
	ELSE
	  v_ColumnData	    := v_ColumnData	 || ',"' || r.COLUMN_NAME || '"';
	  v_ColumnDataPivot := v_ColumnDataPivot || ',''' || r.COLUMN_NAME || ''' AS "' || r.COLUMN_NAME || '"';
	END IF;
      END LOOP;
    END;
    --select @ColumnData

    -- [Fix v2] LISTAGG #2 -> CLOB cursor loop with Oracle CAST + delimited identifier.
    -- Format: CAST("col" AS NUMBER(5,2)) AS "col"  ( contains 999 -> just "col" — contribution_type passthrough)
    v_ColumnData2 := '';
    DECLARE v_first BOOLEAN := TRUE; v_seg VARCHAR2(4000); BEGIN
      FOR r IN (SELECT COLUMN_NAME FROM GT_DMF0043_TITLE
		 WHERE TO_NUMBER(SORT_ORDER_NO) > (SELECT TO_NUMBER(SORT_ORDER_NO) FROM GT_DMF0043_TITLE WHERE COLUMN_NAME = 'EDIT_FLAG')
		 ORDER BY TO_NUMBER(SORT_ORDER_NO)) LOOP
	IF INSTR(r.COLUMN_NAME, '999') <> 0 THEN
	  v_seg := '"' || r.COLUMN_NAME || '"';
	ELSE
	  v_seg := 'CAST("' || r.COLUMN_NAME || '" AS NUMBER(5,2)) AS "' || r.COLUMN_NAME || '"';
	END IF;
	IF v_first THEN v_ColumnData2 := v_seg; v_first := FALSE;
	ELSE v_ColumnData2 := v_ColumnData2 || ',' || v_seg; END IF;
      END LOOP;
    END;
    --select @ColumnData2
    -- ######################## 해더 칼럼 데이터 ########################

    IF (p_his = 'N') THEN
        -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################
        -- 연도 데이터
	INSERT INTO GT_DMF0043_TEMP
	(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
	 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME)
	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_RATIO) AS RATIO
	     , 'Y#' || p_yyyy || '#' || OS_CORP_CD AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM = v_thismm
	   AND VER_SEQ = p_ver_seq

	UNION ALL

	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_TYPE) AS RATIO
	     , 'Y#' || p_yyyy || '#RBU_0999' AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM  = v_thismm
	   AND VER_SEQ = p_ver_seq

	UNION ALL

        -- 월 데이터
	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_RATIO) AS RATIO
	     , 'M#' || YYYYMM || '#' || OS_CORP_CD AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND VER_SEQ = p_ver_seq

	UNION ALL

	SELECT VER_SEQ
	     , DEPARTMENT_ID
	     , DEPT_ID
	     , END_CUST_REPORT
	     , SOLDTO_CUST_REPORT
	     , PRODUCT_GROUP
	     , DM_BIZ_TYPE
	     , TO_CHAR(CONTRIBUTION_TYPE) AS RATIO
	     , 'M#' || YYYYMM || '#RBU_0999' AS COLUMN_NAME
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		     , DT.YYYYMM
		     , DT.OS_CORP_CD
		     , DT.CONTRIBUTION_TYPE
		     , DT.CONTRIBUTION_RATIO
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
		       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
			  ON MA.VER_SEQ = DT.VER_SEQ
			 AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
			 AND MA.DEPT_ID = DT.DEPT_ID
			 AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
			 AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
			 AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
			 AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
	       ) MA
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND VER_SEQ = p_ver_seq;

	IF (p_dis = 'ALL') THEN --2019/08/27
                -- 불일치 조회 관련 칼럼 추가
		INSERT INTO GT_DMF0043_TEMP2
		(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
		 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME, DISCARD)
		SELECT MAIN.VER_SEQ
		     , MAIN.DEPARTMENT_ID
		     , MAIN.DEPT_ID
		     , MAIN.END_CUST_REPORT
		     , MAIN.SOLDTO_CUST_REPORT
		     , MAIN.PRODUCT_GROUP
		     , MAIN.DM_BIZ_TYPE
		     , MAIN.RATIO
		     , MAIN.COLUMN_NAME
		     , DISCARD.DISCARD
		  FROM GT_DMF0043_TEMP MAIN
		       INNER JOIN (SELECT VER_SEQ
					, DEPARTMENT_ID
					, DEPT_ID
					, END_CUST_REPORT
					, SOLDTO_CUST_REPORT
					, PRODUCT_GROUP
					, DM_BIZ_TYPE
					, CASE WHEN SUM(CONTRIBUTION_RATIO) = 1200 THEN 'Y' ELSE 'N' END AS DISCARD
				     FROM (SELECT MA.VER_SEQ
						, MA.DEPARTMENT_ID
						, MA.DEPT_ID
						, MA.END_CUST_REPORT
						, MA.SOLDTO_CUST_REPORT
						, MA.PRODUCT_GROUP
						, MA.DM_BIZ_TYPE
						, DT.YYYYMM
						, DT.OS_CORP_CD
						, DT.CONTRIBUTION_TYPE
						, DT.CONTRIBUTION_RATIO
					     FROM DM_MST_CONTRIBUTE_RATIO_MST MA
						  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
						     ON MA.VER_SEQ = DT.VER_SEQ
						    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
						    AND MA.DEPT_ID = DT.DEPT_ID
						    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
						    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
						    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
						    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
					  ) MA
				    WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
				      AND VER_SEQ = p_ver_seq
				    GROUP BY VER_SEQ
					, DEPARTMENT_ID
					, DEPT_ID
					, END_CUST_REPORT
					, SOLDTO_CUST_REPORT
					, PRODUCT_GROUP
					, DM_BIZ_TYPE
				  ) DISCARD
			  ON MAIN.VER_SEQ = DISCARD.VER_SEQ
			 AND MAIN.DEPARTMENT_ID = DISCARD.DEPARTMENT_ID
			 AND MAIN.DEPT_ID = DISCARD.DEPT_ID
			 AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
			 AND MAIN.SOLDTO_CUST_REPORT = DISCARD.SOLDTO_CUST_REPORT
			 AND MAIN.PRODUCT_GROUP = DISCARD.PRODUCT_GROUP
			 AND MAIN.DM_BIZ_TYPE = DISCARD.DM_BIZ_TYPE;
                -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################


		v_Query := '
SELECT *
  FROM (SELECT SITE_ITEM.*
	     , RATIO.VER_SEQ
	     , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE ''N'' END DISCARD
	     , CASE WHEN ((SITE_ITEM.department_id != '''')
			   AND (SITE_ITEM.dept_id != '''')
			   AND (SITE_ITEM.end_cust_report != '''')
			   AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
			   AND (SITE_ITEM.dm_biz_type != ''''))
			  THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	     , ' || v_ColumnData2 || '
	  FROM (SELECT DISTINCT A.DIVISION_ID
		     , TEAM.DEPARTMENT_ID
		     , TEAM.DEPARTMENT_NAME
		     , TEAM.DEPT_ID AS DEPT_ID
		     , TEAM.DEPT_NAME_KO AS DEPT_NAME
		     , NVL(A.ATTRIBUTE2,'''') AS END_CUST_REPORT
		     , NVL(A.ATTRIBUTE1,'''') AS SOLDTO_CUST_REPORT
		     , ''N'' AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
		     , NVL(C.FORECAST_INFO_BIZ_TYPE,'''') AS DM_BIZ_TYPE
		  FROM SCM_MST_SITE_ITEM A
		       INNER JOIN SCM_MST_SITE B
			  ON A.DIVISION_ID = B.DIVISION_ID
			 AND A.SCM_SITE_ID = B.SCM_SITE_ID
			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM
			  ON SAM.SEGMENT1 = B.COMPANY_ID
			 AND SAM.LOOKUP_TYPE = ''INTERNAL_TXN''
		       INNER JOIN DM_MST_ITEM_SINGLE_V C
			  ON A.DIVISION_ID = C.DIVISION_ID
			 AND A.ITEM_ID = C.ITEM_ID
			LEFT OUTER JOIN (SELECT B.USER_ID
					      , B.USER_NAME
					      , B.USER_NAME_EN
					      , B.DEPT_ID
					      , C.DEPT_NAME_KO
					      , D.DEPT_ID AS DEPARTMENT_ID
					      , D.DEPT_NAME_KO AS DEPARTMENT_NAME
					   FROM SCM_MST_SSO_USER_INFO B
						INNER JOIN SCM_MST_SSO_DEPT_INFO C
						   ON B.DEPT_ID = C.DEPT_ID
						INNER JOIN SCM_MST_SSO_DEPT_INFO D
						   ON C.UPPER_DEPT_ID = D.DEPT_ID
					) TEAM
			  ON TEAM.USER_ID = REGEXP_SUBSTR(A.OWNER, ''[^,]+'', 1, 1)
		 WHERE A.DIVISION_ID = ''40''
		   AND B.SITE_TYPE = ''SALES''
		   --AND NVL(C.FORECAST_INFO_BIZ_TYPE,'''') <> ''''
		   --AND NVL(A.ATTRIBUTE2,'''') <> ''''
		   --AND NVL(A.ATTRIBUTE1,'''') <> ''''
		   --AND '''' <> ''''
		 GROUP BY A.DIVISION_ID
		     , TEAM.DEPARTMENT_ID
		     , TEAM.DEPARTMENT_NAME
		     , TEAM.DEPT_ID
		     , TEAM.DEPT_NAME_KO
		     , NVL(SAM.SEGMENT3,'''')
		     , NVL(A.ATTRIBUTE2,'''')
		     , NVL(A.ATTRIBUTE1,'''')
		     , ''N''
		     , NVL(C.FORECAST_INFO_BIZ_TYPE,'''')

	       ) SITE_ITEM
	       LEFT JOIN (SELECT * FROM (SELECT VER_SEQ
			       , DEPARTMENT_ID
			       , DEPT_ID
			       , END_CUST_REPORT
			       , SOLDTO_CUST_REPORT
			       , PRODUCT_GROUP
			       , DM_BIZ_TYPE
			       , DISCARD
			       , RATIO
			       , COLUMN_NAME
			    FROM GT_DMF0043_TEMP2) MA
				 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
			  ) RATIO
		 ON SITE_ITEM.DEPARTMENT_ID   = RATIO.DEPARTMENT_ID
		AND SITE_ITEM.DEPT_ID	      = RATIO.DEPT_ID
		AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
		AND SITE_ITEM.SOLDTO_CUST_REPORT  = RATIO.SOLDTO_CUST_REPORT
		AND SITE_ITEM.PRODUCT_GROUP   = RATIO.PRODUCT_GROUP
		AND SITE_ITEM.DM_BIZ_TYPE     = RATIO.DM_BIZ_TYPE
       ) MA
 WHERE DISCARD = CASE WHEN ''' || p_dis || ''' = ''ALL'' THEN DISCARD ELSE ''' || p_dis || ''' END
';

        ELSE  -- 2019/08/27 (@p_dis = 'Y') 추가
                /* #master_list / #temp_list 사전 정리 (DROP 대응) */
		DELETE FROM GT_DMF0043_MASTER_LIST;
		DELETE FROM GT_DMF0043_TEMP_LIST;

		INSERT INTO GT_DMF0043_MASTER_LIST
		(DIVISION_ID, DEPARTMENT_ID, DEPARTMENT_NAME, DEPT_ID, DEPT_NAME,
		 END_CUST_REPORT, SOLDTO_CUST_REPORT
		 , PRODUCT_GROUP --(As-Is parity, 2026-06-01)
		 , DM_BIZ_TYPE)
		SELECT A.DIVISION_ID
		     , TEAM.DEPARTMENT_ID
		     , TEAM.DEPARTMENT_NAME
		     , TEAM.DEPT_ID AS DEPT_ID
		     , TEAM.DEPT_NAME_KO AS DEPT_NAME
		     , NVL(A.ATTRIBUTE2,'') AS END_CUST_REPORT
		     , NVL(A.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
		     , 'N' AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
		     , NVL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
		  FROM SCM_MST_SITE_ITEM A
		       INNER JOIN SCM_MST_SITE B
			  ON A.DIVISION_ID = B.DIVISION_ID
			 AND A.SCM_SITE_ID = B.SCM_SITE_ID
		       INNER JOIN DM_MST_ITEM_SINGLE_V C
			  ON A.DIVISION_ID = C.DIVISION_ID
			 AND A.ITEM_ID = C.ITEM_ID
			LEFT JOIN (SELECT B.USER_ID
					, B.USER_NAME
					, B.USER_NAME_EN
					, B.DEPT_ID
					, C.DEPT_NAME_KO
					, D.DEPT_ID AS DEPARTMENT_ID
					, D.DEPT_NAME_KO AS DEPARTMENT_NAME
				     FROM SCM_MST_SSO_USER_INFO B
					  INNER JOIN SCM_MST_SSO_DEPT_INFO C
					     ON B.DEPT_ID = C.DEPT_ID
					  INNER JOIN SCM_MST_SSO_DEPT_INFO D
					     ON C.UPPER_DEPT_ID = D.DEPT_ID
				   ) TEAM
			  ON TEAM.USER_ID = REGEXP_SUBSTR(A.OWNER, '[^,]+', 1, 1)
		 WHERE A.DIVISION_ID = '40'
		   AND B.SITE_TYPE = 'SALES'
		 GROUP BY A.DIVISION_ID
		     , TEAM.DEPARTMENT_ID
		     , TEAM.DEPARTMENT_NAME
		     , TEAM.DEPT_ID
		     , TEAM.DEPT_NAME_KO
		     , NVL(A.ATTRIBUTE2,'')
		     , NVL(A.ATTRIBUTE1,'')
		     , 'N'
		     , NVL(C.FORECAST_INFO_BIZ_TYPE,'')
		;

		INSERT INTO GT_DMF0043_TEMP_LIST
		(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
		 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME, DISCARD)
		SELECT MAIN.VER_SEQ
		     , MAIN.DEPARTMENT_ID
		     , MAIN.DEPT_ID
		     , MAIN.END_CUST_REPORT
		     , MAIN.SOLDTO_CUST_REPORT
		     , MAIN.PRODUCT_GROUP
		     , MAIN.DM_BIZ_TYPE
		     , MAIN.RATIO
		     , MAIN.COLUMN_NAME
		     , DISCARD.DISCARD
		  FROM GT_DMF0043_TEMP MAIN
		       INNER JOIN (SELECT VER_SEQ
					, DEPARTMENT_ID
					, DEPT_ID
					, END_CUST_REPORT
					, SOLDTO_CUST_REPORT
					, PRODUCT_GROUP
					, DM_BIZ_TYPE
					, CASE WHEN SUM(CASE WHEN RATIO = 100 THEN 0 ELSE 1 END) > 0 THEN 'Y' ELSE 'N' END AS DISCARD
				     FROM (SELECT MA.VER_SEQ
						, MA.DEPARTMENT_ID
						, MA.DEPT_ID
						, MA.END_CUST_REPORT
						, MA.SOLDTO_CUST_REPORT
						, MA.PRODUCT_GROUP
						, MA.DM_BIZ_TYPE
						, DT.YYYYMM
						, DT.OS_CORP_CD
						, DT.CONTRIBUTION_TYPE
						, DT.CONTRIBUTION_RATIO
						, SUM(CONTRIBUTION_RATIO) OVER(PARTITION BY MA.VER_SEQ
											  , MA.DEPARTMENT_ID
											  , MA.DEPT_ID
											  , MA.END_CUST_REPORT
											  , MA.SOLDTO_CUST_REPORT
											  , MA.PRODUCT_GROUP
											  , MA.DM_BIZ_TYPE
											  , DT.YYYYMM) AS RATIO
					     FROM DM_MST_CONTRIBUTE_RATIO_MST MA
						  INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DT
						     ON MA.VER_SEQ = DT.VER_SEQ
						    AND MA.DEPARTMENT_ID = DT.DEPARTMENT_ID
						    AND MA.DEPT_ID = DT.DEPT_ID
						    AND MA.END_CUST_REPORT= DT.END_CUST_REPORT
						    AND MA.SOLDTO_CUST_REPORT = DT.SOLDTO_CUST_REPORT
						    AND MA.PRODUCT_GROUP = DT.PRODUCT_GROUP
						    AND MA.DM_BIZ_TYPE = DT.DM_BIZ_TYPE
					    WHERE MA.VER_SEQ = p_ver_seq
					      AND DT.YYYYMM >= v_sdt
					      AND DT.YYYYMM <= v_edt
					  ) MA
				    GROUP BY VER_SEQ
					   , DEPARTMENT_ID
					   , DEPT_ID
					   , END_CUST_REPORT
					   , SOLDTO_CUST_REPORT
					   , PRODUCT_GROUP
					   , DM_BIZ_TYPE
				  ) DISCARD
			  ON MAIN.VER_SEQ	  = DISCARD.VER_SEQ
			 AND MAIN.DEPARTMENT_ID   = DISCARD.DEPARTMENT_ID
			 AND MAIN.DEPT_ID	  = DISCARD.DEPT_ID
			 AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
			 AND MAIN.SOLDTO_CUST_REPORT  = DISCARD.SOLDTO_CUST_REPORT
			 AND MAIN.PRODUCT_GROUP   = DISCARD.PRODUCT_GROUP
			 AND MAIN.DM_BIZ_TYPE	  = DISCARD.DM_BIZ_TYPE
		 WHERE DISCARD.DISCARD = 'Y';

		v_Query := '
SELECT *
  FROM (SELECT SITE_ITEM.*
	     , RATIO.VER_SEQ
	     , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE ''N'' END DISCARD
	     , CASE WHEN ((SITE_ITEM.department_id != '''')
			   AND (SITE_ITEM.dept_id != '''')
			   AND (SITE_ITEM.end_cust_report != '''')
			   AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
			   AND (SITE_ITEM.dm_biz_type != ''''))
			 THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	     ,' || v_ColumnData2 || '
	  FROM GT_DMF0043_MASTER_LIST SITE_ITEM
	       INNER JOIN (SELECT * FROM (SELECT VER_SEQ
				, DEPARTMENT_ID
				, DEPT_ID
				, END_CUST_REPORT
				, SOLDTO_CUST_REPORT
				, PRODUCT_GROUP
				, DM_BIZ_TYPE
				, DISCARD
				, RATIO
				, COLUMN_NAME

			     FROM GT_DMF0043_TEMP_LIST
				    WHERE DISCARD = ''Y'') MA
			    PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
			  ) RATIO
		  ON  SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
		 AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
		 AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
		 AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
		 AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE

	UNION ALL
	SELECT SITE_ITEM.*
	     , RATIO.VER_SEQ
	     , ''Y'' AS DISCARD
	     , CASE WHEN ((SITE_ITEM.department_id != '''')
			   AND (SITE_ITEM.dept_id != '''')
			   AND (SITE_ITEM.end_cust_report != '''')
			   AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
			   AND (SITE_ITEM.dm_biz_type != ''''))
			 THEN ''Y'' ELSE ''N'' END AS EDIT_FLAG
	     , ' || v_ColumnData2 || '
	  FROM GT_DMF0043_MASTER_LIST SITE_ITEM
	       LEFT OUTER JOIN (SELECT * FROM (SELECT VER_SEQ
				     , DEPARTMENT_ID
				     , DEPT_ID
				     , END_CUST_REPORT
				     , SOLDTO_CUST_REPORT
				     , PRODUCT_GROUP
				     , DM_BIZ_TYPE
				     , RATIO
				     , COLUMN_NAME

				  FROM GT_DMF0043_TEMP) MA
				 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
			       ) RATIO
		 ON SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
		AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
		AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
		AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
		AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
		AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
	 WHERE RATIO.VER_SEQ IS NULL
       ) MA
';

	END IF;

    ELSE   -- (@p_his = 'Y')
        -- ######################## 데이터 ########################
	INSERT INTO GT_DMF0043_DATA_TABLE
	(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
	 PRODUCT_GROUP, DM_BIZ_TYPE, DIVISION_ID)
	SELECT CONTRIBUTE.VER_SEQ
	     , CONTRIBUTE.DEPARTMENT_ID
	     , CONTRIBUTE.DEPT_ID
	     , CONTRIBUTE.END_CUST_REPORT
	     , CONTRIBUTE.SOLDTO_CUST_REPORT
	     , CONTRIBUTE.PRODUCT_GROUP
	     , CONTRIBUTE.DM_BIZ_TYPE
	     , SITE_ITEM.DIVISION_ID
	  FROM (SELECT MA.VER_SEQ
		     , MA.DEPARTMENT_ID
		     , MA.DEPT_ID
		     , MA.END_CUST_REPORT
		     , MA.SOLDTO_CUST_REPORT
		     , MA.PRODUCT_GROUP
		     , MA.DM_BIZ_TYPE
		  FROM DM_MST_CONTRIBUTE_RATIO_MST MA
	       ) CONTRIBUTE
	       LEFT OUTER JOIN (
		    SELECT DISTINCT
			   A.DIVISION_ID
			 , TEAM.DEPARTMENT_ID
			 , TEAM.DEPARTMENT_NAME
			 , TEAM.DEPT_ID AS DEPT_ID
			 , TEAM.DEPT_NAME_KO AS DEPT_NAME
			 , NVL(A.ATTRIBUTE2,'') AS END_CUST_REPORT
			 , NVL(A.ATTRIBUTE1,'') AS SOLDTO_CUST_REPORT
			 , 'N' AS PRODUCT_GROUP --PRODUCT_GR (As-Is parity, 2026-06-01)
			 , NVL(C.FORECAST_INFO_BIZ_TYPE,'') AS DM_BIZ_TYPE
		      FROM SCM_MST_SITE_ITEM A
			   INNER JOIN SCM_MST_SITE B
			      ON A.DIVISION_ID = B.DIVISION_ID
			     AND A.SCM_SITE_ID = B.SCM_SITE_ID
			    LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL SAM
			      ON SAM.SEGMENT1 = B.COMPANY_ID
			     AND SAM.LOOKUP_TYPE = 'INTERNAL_TXN'
			   INNER JOIN DM_MST_ITEM_SINGLE_V C
			      ON A.DIVISION_ID = C.DIVISION_ID
			     AND A.ITEM_ID = C.ITEM_ID
			    LEFT JOIN (SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN
					    , B.DEPT_ID, C.DEPT_NAME_KO, D.DEPT_ID AS DEPARTMENT_ID
					    , D.DEPT_NAME_KO AS DEPARTMENT_NAME
					 FROM SCM_MST_SSO_USER_INFO B
					      INNER JOIN SCM_MST_SSO_DEPT_INFO C
						 ON B.DEPT_ID = C.DEPT_ID
					      INNER JOIN SCM_MST_SSO_DEPT_INFO D
						 ON C.UPPER_DEPT_ID = D.DEPT_ID
				      ) TEAM
			      ON TEAM.USER_ID = REGEXP_SUBSTR(A.OWNER, '[^,]+', 1, 1)
		     WHERE A.DIVISION_ID = '40'
		       AND B.SITE_TYPE = 'SALES'
		       AND NVL(C.FORECAST_INFO_BIZ_TYPE,'') <> ''
		       AND NVL(A.ATTRIBUTE2,'') <> ''
		       AND NVL(A.ATTRIBUTE1,'') <> ''
                       -- AND '' <> '' -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거 (Oracle 마이그레이션 2026.05.22)
		     GROUP BY A.DIVISION_ID
			 , TEAM.DEPARTMENT_ID
			 , TEAM.DEPARTMENT_NAME
			 , TEAM.DEPT_ID
			 , TEAM.DEPT_NAME_KO
			 , NVL(SAM.SEGMENT3,'')
			 , NVL(A.ATTRIBUTE2,'')
			 , NVL(A.ATTRIBUTE1,'')
			 , 'N'
			 , NVL(C.FORECAST_INFO_BIZ_TYPE,'')
		   ) SITE_ITEM
		 ON SITE_ITEM.DEPARTMENT_ID = CONTRIBUTE.DEPARTMENT_ID
		AND SITE_ITEM.DEPT_ID = CONTRIBUTE.DEPT_ID
		AND SITE_ITEM.END_CUST_REPORT = CONTRIBUTE.END_CUST_REPORT
		AND SITE_ITEM.SOLDTO_CUST_REPORT = CONTRIBUTE.SOLDTO_CUST_REPORT
                -- AND SITE_ITEM.PRODUCT_GROUP = CONTRIBUTE.PRODUCT_GROUP -- [컬럼삭제] SCM_MST_SITE_ITEM.REPORT_GROUP3 제거로 조인키 제외 (Oracle 마이그레이션 2026.05.22)
		AND SITE_ITEM.DM_BIZ_TYPE = CONTRIBUTE.DM_BIZ_TYPE
	 WHERE SITE_ITEM.DIVISION_ID IS NULL;

        -- 연도 데이터
	INSERT INTO GT_DMF0043_TEMP3
	(VER_SEQ, DEPARTMENT_ID, DEPT_ID, END_CUST_REPORT, SOLDTO_CUST_REPORT,
	 PRODUCT_GROUP, DM_BIZ_TYPE, RATIO, COLUMN_NAME)
	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_RATIO) AS RATIO
	     , 'Y#' || p_yyyy || '#' || DTL.OS_CORP_CD AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM = v_thismm
	   AND MA.VER_SEQ = p_ver_seq

	UNION ALL

	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_TYPE) AS RATIO
	     , 'Y#' || p_yyyy || '#RBU_0999' AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM = v_thismm
	   AND MA.VER_SEQ = p_ver_seq

	UNION ALL

        -- 월 데이터
	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_RATIO) AS RATIO
	     , 'M#' || YYYYMM || '#' || OS_CORP_CD AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND MA.VER_SEQ = p_ver_seq

	UNION ALL

	SELECT MA.VER_SEQ
	     , MA.DEPARTMENT_ID
	     , MA.DEPT_ID
	     , MA.END_CUST_REPORT
	     , MA.SOLDTO_CUST_REPORT
	     , MA.PRODUCT_GROUP
	     , MA.DM_BIZ_TYPE
	     , TO_CHAR(DTL.CONTRIBUTION_TYPE) AS RATIO
	     , 'M#' || YYYYMM || '#RBU_0999' AS COLUMN_NAME
	  FROM GT_DMF0043_DATA_TABLE MA
	       INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
		  ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
		 AND MA.DEPT_ID = DTL.DEPT_ID
		 AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
		 AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
		 AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
		 AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
	 WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
	   AND MA.VER_SEQ = p_ver_seq;
	-- select * from #temp
        -- ######################## 데이터 ########################

	v_Query := '
SELECT VER_SEQ
     , DEPARTMENT_ID
     , DEPT_ID
     , END_CUST_REPORT
     , SOLDTO_CUST_REPORT
     , PRODUCT_GROUP
     , DM_BIZ_TYPE
     , ''N'' AS EDIT_FLAG
     , ' || v_ColumnData || '
  FROM (SELECT *
	  FROM GT_DMF0043_TEMP3) MA
 PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' || v_ColumnDataPivot || ')) PVT
';
    END IF;

    --SELECT CONVERT(TEXT, @Query)
    --FOR XML PATH('')--,ROOT('x')

    /* EXECUTE dbo.SP_EXECUTESQL @Query
       Oracle: SYS_REFCURSOR OUT 으로 결과셋 반환 */
    OPEN O_RC1 FOR v_Query || ' ORDER BY DEPARTMENT_NAME, DEPT_NAME, END_CUST_REPORT, SOLDTO_CUST_REPORT, PRODUCT_GROUP, DM_BIZ_TYPE';

EXCEPTION
    WHEN OTHERS THEN
	RAISE_APPLICATION_ERROR(-20001, $$PLSQL_UNIT || ' Error: ' || SQLERRM);
END;/

-- ===== 4: DMF0043_GET_MAIN_SPREAD_TITLE (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE         DMF0043_GET_MAIN_SPREAD_TITLE
(
    p_division_id  IN  VARCHAR2,
    p_yyyy         IN  VARCHAR2,
    p_created_by   IN  VARCHAR2,
    p_user_id      IN  VARCHAR2,
    p_menu_id      IN  VARCHAR2,
    O_RC1          OUT SYS_REFCURSOR,
    O_RC2          OUT SYS_REFCURSOR,
    O_RC3          OUT SYS_REFCURSOR
) AS
    v_pkg_rc1    SYS_REFCURSOR;
    v_pkg_rc2    SYS_REFCURSOR;
    v_pkg_rc3    SYS_REFCURSOR;
    v_pkg_result SYS_REFCURSOR;
    v_program_id VARCHAR2(100) := 'DMF0043';
    v_sheet_name VARCHAR2(100) := 'ContributeMain';
BEGIN
    -- ────────────────────────────────────────────────────────────────────
    -- STEP 0 : GT_GMST GTT 사전 정리 (PKG INSERT 누적 방지)
    --   PKG body 의 INSERT INTO GT_GMST_TEMP_2 / GT_GMST_TEMP2_2 는
    --   DELETE 없이 누적. 같은 session 안에서 wrapper 가 N번 호출되면 117 × N row.
    --   wrapper 가 자체 책임으로 정리 — caller 빌드 시 중복 alias (ORA-00918) 방지.
    -- ────────────────────────────────────────────────────────────────────
    BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP_2;  EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN DELETE FROM SCM_MGR.GT_GMST_TEMP2_2; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 1 : PKG.P_DMF0043_GET_MAIN_SPREAD_TITLE 호출
    --   → GT_GMST_TEMP_2 (9 row) + GT_GMST_TEMP2_2 (117 row) 적재 (매 호출 117 보장)
    -- ────────────────────────────────────────────────────────────────────
    PKG_DMF0043.P_DMF0043_GET_MAIN_SPREAD_TITLE(
        P_DIVISION_ID   => p_division_id,
        P_YYYY          => p_yyyy,
        P_CREATED_BY    => p_created_by,
        P_USER_ID       => p_user_id,
        P_MENU_ID       => p_menu_id,
        O_RC1           => v_pkg_rc1,
        O_RC2           => v_pkg_rc2,
        O_RC3           => v_pkg_rc3,
        O_RESULT_CURSOR => v_pkg_result
    );

    -- PKG OUT cursor 4개 모두 close (wrapper 가 자체 cursor 사용)
    BEGIN CLOSE v_pkg_rc1;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_rc2;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_rc3;    EXCEPTION WHEN OTHERS THEN NULL; END;
    BEGIN CLOSE v_pkg_result; EXCEPTION WHEN OTHERS THEN NULL; END;

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 2 : caller fetch 용 22 컬럼 cursor 를 O_RC1 에 OPEN
    --   PKG SPREAD_TITLE 의 3 UNION SELECT 와 동일 구조 + EDIT_YN 컬럼 제거
    -- ────────────────────────────────────────────────────────────────────
    OPEN O_RC1 FOR
        -- 1st UNION : SCM_MST_SHEET_COLUMNS DEFAULT_FLAG='Y' + PR_SCM_EDIT_YN 권한 필터
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
          INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) TEI
             ON TEI.UNIT_ID = C.DIVISION_ID
         WHERE 1 = 1
           AND C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.DEFAULT_FLAG = 'Y'
           AND C.VALID_YN    = 'Y'
           AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C.DIVISION_ID, ',')))

        UNION ALL

        -- 2nd UNION : VISIBLE_FLAG='N' hidden cols (PKG line 401 동일 — Oracle 'N' 사용)
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE 1 = 1
           AND C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.VISIBLE_FLAG = 'N'
           AND C.DEFAULT_FLAG IS NULL
           AND C.VALID_YN = 'Y'
           AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C.DIVISION_ID, ',')))

        UNION ALL

        -- 3rd UNION : dynamic 컬럼 (FLAG#YYYYMM#CODE) — GT_GMST_TEMP2_2 117 row
        SELECT v_program_id AS PROGRAM_ID
             , v_sheet_name AS SHEET_NAME
             , T.FLAG || '#' || T.YYYYMM || '#' || CODE AS COLUMN_NAME
             , T.NAME AS COLUMN_LABEL_NAME
             , TO_NUMBER(DISPLAY_SEQ) AS SORT_ORDER_NO
             , '' AS DATA_SORT_METHOD_CODE
             , T.NAME AS SMALL_CLASS_LABEL_NAME
             , CASE WHEN LENGTH(T.YYYYMM) = 4 THEN T.YYYYMM
                    ELSE SUBSTR(T.YYYYMM, 1, 4) || '-' || SUBSTR(T.YYYYMM, 5, 2) END AS LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , '' AS FIXED_FLAG
             , 80 AS COLUMN_WIDTH
             , '' AS CELL_CONTROL_OBJECT_TYPE_CODE
             , '' AS CELL_COMBO_DATA_TYPE
             , 2 AS DATA_SCALE_NUMBER
             , NULL AS DATA_MAX_LENGTH
             , 'R' AS HORIZONTAL_ALIGN_CODE
             , 'Y' AS UPPERCASE_APPLY_FLAG
             , 'Y' AS VISIBLE_FLAG
             , '' AS DEFAULT_FLAG
             , '' AS USER_SELECTABLE_FLAG
             , '' AS VALID_YN
             , '' AS DIVISION_ID
          FROM (SELECT REPLACE(YYYYMM, ' ', '') AS YYYYMM
                     , FLAG
                     , CODE
                     , NAME
                     , TO_CHAR(REPLACE(REPLACE(YYYYMM, ' ', ''), '-', '')) || TO_CHAR(DISPLAY_SEQ) AS DISPLAY_SEQ
                  FROM SCM_MGR.GT_GMST_TEMP2_2) T

        UNION ALL

        -- 4th UNION : EDIT_FLAG row 강제 포함 (caller v_ColumnData 빌드 logic 의 EDIT_FLAG SORT 기준점 보장)
        --   PKG 1st UNION 의 INNER JOIN PR_SCM_EDIT_YN 권한 / DEFAULT_FLAG 필터 등으로 EDIT_FLAG 제외 시
        --   caller WHERE SORT > EDIT_FLAG SORT NULL → 0 row → v_Query invalid → ORA-00936 사고 방지
        SELECT C.PROGRAM_ID
             , C.SHEET_NAME
             , C.COLUMN_NAME
             , C.COLUMN_LABEL_NAME
             , C.SORT_ORDER_NO
             , C.DATA_SORT_METHOD_CODE
             , C.SMALL_CLASS_LABEL_NAME
             , C.LARGE_CLASS_LABEL_NAME
             , '' AS DAY_CODE
             , C.FIXED_FLAG
             , C.COLUMN_WIDTH
             , C.CELL_CONTROL_OBJECT_TYPE_CODE
             , C.CELL_COMBO_DATA_TYPE
             , C.DATA_SCALE_NUMBER
             , C.DATA_MAX_LENGTH
             , C.HORIZONTAL_ALIGN_CODE
             , C.UPPERCASE_APPLY_FLAG
             , C.VISIBLE_FLAG
             , C.DEFAULT_FLAG
             , C.USER_SELECTABLE_FLAG
             , C.VALID_YN
             , C.DIVISION_ID
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID = v_program_id
           AND C.SHEET_NAME = v_sheet_name
           AND C.COLUMN_NAME = 'EDIT_FLAG'
           -- 다른 필터 없음: DEFAULT_FLAG / VALID_YN / VISIBLE_FLAG 무관 — 강제 포함
           AND NOT EXISTS (
             -- 1st UNION 이 이미 EDIT_FLAG 반환했으면 중복 회피
             SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C2
              INNER JOIN TABLE(SCM_MGR.PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) TEI2
                 ON TEI2.UNIT_ID = C2.DIVISION_ID
              WHERE C2.PROGRAM_ID = v_program_id
                AND C2.SHEET_NAME = v_sheet_name
                AND C2.COLUMN_NAME = 'EDIT_FLAG'
                AND C2.DEFAULT_FLAG = 'Y'
                AND C2.VALID_YN = 'Y'
                AND p_division_id IN (SELECT VALUE FROM TABLE(SCM_MGR.FN_SPLITSTRING(C2.DIVISION_ID, ',')))
           )

        ORDER BY 5;  -- SORT_ORDER_NO

    -- ────────────────────────────────────────────────────────────────────
    -- STEP 3 : O_RC2 / O_RC3 = empty cursor (caller close 안전)
    -- ────────────────────────────────────────────────────────────────────
    OPEN O_RC2 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
    OPEN O_RC3 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
            '[DMF0043_GET_MAIN_SPREAD_TITLE wrapper] SQLCODE=' || SQLCODE ||
            ' / SQLERRM=' || SQLERRM);
END;/

-- ===== 5: DMF0043_GET_CONTRIBUTE_RATE_POPUP (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE           "DMF0043_GET_CONTRIBUTE_RATE_POPUP"
(
	p_yyyy		    VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
    , O_RESULT_CURSOR OUT SYS_REFCURSOR
)
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_RATE_POPUP
 * Description : DMF0043 > 기여율 관리 팝업
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 **************************************************************************************************
*/
AS
    v_in_para_data VARCHAR2(4000);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_description VARCHAR2(500 CHAR);
    d_event_date DATE;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_yyyy' VALUE p_yyyy
	  );
	OPEN O_RC1 FOR
	SELECT
		VER_SEQ
		,YYYY
		,VERSION_NM
		,DESCRIPTION
		,VALID_YN
	FROM DM_MST_CONTRIBUTE_VER
	WHERE YYYY = CASE WHEN p_yyyy IS NULL OR p_yyyy = 'ALL' THEN YYYY ELSE p_yyyy END
    ORDER BY YYYY DESC;
    OPEN O_RESULT_CURSOR FOR
    SELECT '1' AS RESULT_CODE, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS RESULT_MSG, 'SUCCESS' AS ERR_EVENT FROM DUAL;
EXCEPTION
    WHEN OTHERS THEN
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_description, d_event_date,
	    p_in_para_data  => v_in_para_data,
	    p_sql_err_code  => SQLCODE,
	    p_sql_err_msg   => SQLERRM,
	    p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
	);
	RAISE_APPLICATION_ERROR(-20001,
	    '[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	    ' / SQLERRM=' || SQLERRM ||
	    ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	    ' / PARAMS=' || v_in_para_data
	);
END;
/

-- ===== 6: DMF0043_GET_CONTRIBUTE_YEAR_POPUP (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE           "DMF0043_GET_CONTRIBUTE_YEAR_POPUP"
/*
 **************************************************************************************************
 * Program ID  :  DMF0043_GET_CONTRIBUTE_YEAR_POPUP
 * Description : DMF0043 > 검색 연도
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2019/05/09  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 **************************************************************************************************
*/
(
    p_user_id VARCHAR2
  , p_menu_id VARCHAR2
  , O_RC1  OUT	SYS_REFCURSOR
)
AS
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
    v_in_para_data VARCHAR2(4000) := NULL;
BEGIN

	/* TODO:EDIT_YN:수동확인필요 */
	OPEN O_RC1 FOR
	SELECT CODE, NAME
	     , 'Y' AS EDIT_YN
	FROM
	(
		SELECT
			'ALL' AS CODE
			,'ALL' AS NAME
			,0 SORTORDER
		FROM DUAL
		UNION ALL

		SELECT
			YYYY AS CODE
			,YYYY NAME
			,ROW_NUMBER() OVER (ORDER BY YYYY) SORTORDER
		FROM DM_MST_CONTRIBUTE_VER
		GROUP BY YYYY
	) MA
	ORDER BY SORTORDER;

EXCEPTION
    WHEN OTHERS THEN
	V_LOG_TYPE   := 'ERROR';
	V_SQL_CODE   := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG := SQLERRM;
	V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
			    V_LOG_TYPE,
			    N_LOG_COUNT,
			    V_LOG_MESSAGE,
			    V_DESCRIPTION,
			    D_EVENT_DATE,
			    V_PROC_INPUT,
			    V_SQL_CODE,
			    V_SQL_ERRMSG,
			    V_BACKTRACE
			    );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END;
/

-- ===== 7: DMF0043_GET_CONT_VIEW_VERSIONPOPUP (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE           "DMF0043_GET_CONT_VIEW_VERSIONPOPUP"
(
    p_start_yyyymmdd  VARCHAR2,
    p_end_yyyymmdd    VARCHAR2,
	--p_created_by	   VARCHAR2,
	p_division_id	   VARCHAR2,
	p_version_type	   VARCHAR2,
	--p_version_no	   VARCHAR2,
	p_description	   VARCHAR2
    , p_user_id VARCHAR2
    , p_menu_id VARCHAR2
    , O_RC1  OUT  SYS_REFCURSOR
)
/***************************************************************************************************
 Program ID  : DMF0043_GET_CONT_VIEW_VERSIONPOPUP
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-- -----------------------------------------------------------------------------------------------
 Date	     In Charge	  Description
-- -----------------------------------------------------------------------------------------------
 2019/08/19  JYE       Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 2020/01/28  P.C.I     [CSR ID:prepare] Report Plan List 조회로 변경
 2020/06/12  HWI1993	[C20200605-000077] GSCM 해외법인 기여율 매출 버전 리스트 정리 요청의 건
 2021/07/03	HWI1993		하반기과제 속도개선 - 데이터 이동보관 처리
**************************************************************************************************/
AS
    v_in_para_data VARCHAR2(4000);
    V_LOG_TYPE	  VARCHAR2(20) := NULL;
    N_LOG_COUNT   NUMBER := 0;
    V_LOG_MESSAGE VARCHAR2(4000 CHAR) := NULL;
    V_DESCRIPTION VARCHAR2(4000 CHAR) := NULL;
    D_EVENT_DATE  DATE := SYSDATE;
    V_PROC_INPUT  CLOB := NULL;
    V_SQL_CODE	  VARCHAR2(100) := NULL;
    V_SQL_ERRMSG  VARCHAR2(4000 CHAR) := NULL;
    V_BACKTRACE   VARCHAR2(4000 CHAR) := NULL;
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_start_yyyymmdd' VALUE p_start_yyyymmdd,
	    'p_end_yyyymmdd' VALUE p_end_yyyymmdd,
	    /*'p_created_by' VALUE p_created_by,*/
	    'p_division_id' VALUE p_division_id,
	    'p_version_type' VALUE p_version_type,
	    /*'p_version_no' VALUE p_version_no,*/
	    'p_description' VALUE p_description
	  );

	/*
	   OPEN O_RC1 FOR
	   SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		 FROM DM_MST_VERSION
	   WHERE (YYYYMMDD >= p_start_yyyymmdd and YYYYMMDD <= p_end_yyyymmdd)
		  AND DIVISION_ID IN (SELECT token FROM TABLE(fn_string_split(p_division_id	,',')))
		  AND VERSION_TYPE IN (SELECT token FROM TABLE(fn_string_split(p_version_type	,',')))
		  AND Exists (Select * from TABLE(fn_string_split(p_version_no,',')) P Where VERSION_NO LIKE P.token ||'%')
	   GROUP BY VERSION_NO , VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD
	   ORDER BY CODE DESC, VERSION_NO DESC*/
		OPEN O_RC1 FOR
		SELECT VERSION_NO AS CODE, VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, MAX(CREATED_BY), MAX(CREATION_DATE)
		     , tei.EDIT_YN
		FROM DM_MDF_VERSION A
		INNER JOIN TABLE(PKG_SCM_USER_MNU.PR_SCM_EDIT_YN(p_user_id, p_menu_id)) tei
		   ON tei.UNIT_ID = A.DIVISION_ID
		WHERE
			A.DIVISION_ID = p_division_id
			AND A.YYYYMMDD BETWEEN p_start_yyyymmdd AND p_end_yyyymmdd
			AND A.VERSION_TYPE = p_version_type
			AND A.VERSION_DESCRIPTION LIKE '%'  ||	p_description  ||  '%'
			AND A.SEND_YN <> 'D'
			AND NVL(A.ATTRIBUTE1, NULL) <> 'MOVE'
	   GROUP BY VERSION_NO , VERSION_NO, A.VERSION_DESCRIPTION, A.VERSION_TYPE, A.VER_CRE_SEQ, A.YYYYMMDD, tei.EDIT_YN
	   ORDER BY CODE DESC, VERSION_NO DESC;

EXCEPTION
    WHEN OTHERS THEN
	V_LOG_TYPE   := 'ERROR';
	V_SQL_CODE   := TO_CHAR(SQLCODE);
	V_SQL_ERRMSG := SQLERRM;
	V_BACKTRACE  := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
	PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT,
			    V_LOG_TYPE,
			    N_LOG_COUNT,
			    V_LOG_MESSAGE,
			    V_DESCRIPTION,
			    D_EVENT_DATE,
			    V_PROC_INPUT,
			    V_SQL_CODE,
			    V_SQL_ERRMSG,
			    V_BACKTRACE
			    );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END;
/

-- ===== 8: DMF0043_GET_SALES_LIST_SPREAD_TITLE (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE           "DMF0043_GET_SALES_LIST_SPREAD_TITLE" (
    p_division_id VARCHAR2,
    p_created_by  VARCHAR2,
    p_menu_id	  VARCHAR2,
    O_RC1	  OUT SYS_REFCURSOR
) AS
BEGIN
    OPEN O_RC1 FOR
	SELECT
	    'DMF0043'		  AS PROGRAM_ID,
	    'ContributeSalesList' AS SHEET_NAME,
	    X.COLUMN_NAME,
	    X.COLUMN_LABEL_NAME,
	    X.SORT_ORDER_NO,
	    CAST(NULL AS VARCHAR2(10)) AS DATA_SORT_METHOD_CODE,
	    X.SMALL_CLASS_LABEL_NAME,
	    X.LARGE_CLASS_LABEL_NAME,
	    ''			   AS DAY_CODE,
	    CAST(NULL AS VARCHAR2(1))  AS FIXED_FLAG,
	    X.COLUMN_WIDTH,
	    X.CELL_CONTROL_OBJECT_TYPE_CODE,
	    CAST(NULL AS VARCHAR2(10)) AS CELL_COMBO_DATA_TYPE,
	    TO_NUMBER(NULL) AS DATA_SCALE_NUMBER,
	    TO_NUMBER(NULL) AS DATA_MAX_LENGTH,
	    X.HORIZONTAL_ALIGN_CODE,
	    'Y' AS UPPERCASE_APPLY_FLAG,
	    'Y' AS VISIBLE_FLAG,
	    'Y' AS DEFAULT_FLAG,
	    'Y' AS USER_SELECTABLE_FLAG,
	    'Y' AS VALID_YN,
	    p_division_id AS DIVISION_ID,
	    'Y' AS EDIT_YN
	FROM (
	    SELECT DISTINCT
		C.COLUMN_NAME,
		C.COLUMN_LABEL_NAME,
		C.SORT_ORDER_NO,
		C.COLUMN_LABEL_NAME AS SMALL_CLASS_LABEL_NAME,
		C.COLUMN_LABEL_NAME AS LARGE_CLASS_LABEL_NAME,
		C.COLUMN_WIDTH,
		C.CELL_CONTROL_OBJECT_TYPE_CODE,
		C.HORIZONTAL_ALIGN_CODE
	    FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
	    WHERE C.PROGRAM_ID = 'DMF0043'
	      AND C.SHEET_NAME = 'ContributeSalesList'
	      AND C.DEFAULT_FLAG = 'Y'
	      AND C.VALID_YN = 'Y'
	    UNION ALL
	    SELECT
		L.SEGMENT1 || '#' || M.SEGMENT1 AS COLUMN_NAME,
		M.SEGMENT2			 AS COLUMN_LABEL_NAME,
		1000 + L.DISPLAY_SEQ + M.DISPLAY_SEQ AS SORT_ORDER_NO,
		M.SEGMENT2			 AS SMALL_CLASS_LABEL_NAME,
		L.SEGMENT2			 AS LARGE_CLASS_LABEL_NAME,
		80				 AS COLUMN_WIDTH,
		'FPNumber'			 AS CELL_CONTROL_OBJECT_TYPE_CODE,
		'R'				 AS HORIZONTAL_ALIGN_CODE
	    FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
	    CROSS JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL M
	    WHERE L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
	      AND L.VALID_YN = 'Y'
	      AND L.SEGMENT3 = 'Y'
	      AND M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
	      AND M.VALID_YN = 'Y'
	) X
	ORDER BY X.SORT_ORDER_NO, X.COLUMN_NAME;
END DMF0043_GET_SALES_LIST_SPREAD_TITLE;
/

-- ===== 9: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO (PROCEDURE) =====
CREATE OR REPLACE PROCEDURE           "DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO"
(

	-- Add the parameters for the stored procedure here
     p_active_flag				VARCHAR2
    ,p_ver_seq					VARCHAR2
    ,p_department_id			VARCHAR2
    ,p_dept_id					VARCHAR2
    ,p_end_cust_report			VARCHAR2
    ,p_soldto_cust_report		VARCHAR2
    ,p_product_group			VARCHAR2
    ,p_dm_biz_type				VARCHAR2
    ,p_yyyymm					VARCHAR2
    ,p_os_corp_cd				VARCHAR2
    ,p_contribution_type		VARCHAR2
    ,p_contribution_ratio		VARCHAR2
    ,p_created_by				VARCHAR2

    , O_RC1  OUT  SYS_REFCURSOR
)
/*
 * Program ID	: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO
 * Description	: 'DM_MST_CONTRIBUTE_RATIO' TABLE INSERT/UPDATE/DELETE
 * Program History
 *===================================================================================================
 *   Date	In Charge      Description
 *===================================================================================================
 * 20190730  KHSONG  Initial Release PJ20189106 전지.GSCM 고도화 이행, DM 시스템
 * 2026/03/15	김준규	[PJ20264226] NextSCM Pilot 설계 및 개발
 2020/09/09     P.C.I		[C20200909-000203] LOG 표준화 적용
 *
 */
AS

/*
 * ========================================
 * [변환검증] 2026-03-13 12:16:41
 * 파일: DMF0043_SAVE_DM_MST_CONTRIBUTE_RATIO.sql
 * ----------------------------------------
 * ⚠ IF: IF:4  END IF:3  차이:+1
 * ⚠ LOOP: LOOP:1  END LOOP:0  차이:+1
 * ⚠ BEGIN: BEGIN:4  END:5  차이:-1
 * ----------------------------------------
 * IF 위치:     L147, L193, L278, L470
 * END IF 위치: L343, L344, L483
 * BEGIN 위치:  L77, L225, L310, L371
 * END;  위치:  L256, L341, L402, L437, L485
 * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
 * LOOP 위치:     L131
 * END LOOP 위치:
 * ----------------------------------------
 * 수정 완료 후 이 주석 블록을 삭제하세요.
 * ========================================
 */


    v_active_flag VARCHAR2(4000 CHAR);
    v_ver_seq VARCHAR2(4000 CHAR);
    v_department_id VARCHAR2(4000 CHAR);
    v_dept_id VARCHAR2(4000 CHAR);
    v_end_cust_report VARCHAR2(4000 CHAR);
    v_soldto_cust_report VARCHAR2(4000 CHAR);
    v_product_group VARCHAR2(4000 CHAR);
    v_dm_biz_type VARCHAR2(4000 CHAR);
    v_yyyymm VARCHAR2(4000 CHAR);
    v_os_corp_cd VARCHAR2(4000 CHAR);
    v_contribution_type VARCHAR2(4000 CHAR);
    v_contribution_ratio VARCHAR2(4000 CHAR);
    v_created_by VARCHAR2(4000 CHAR);
    v_delimiter VARCHAR2(1 CHAR);
    v_max_loop_cnt INTEGER := 0;
    v_mst_loop_cnt INTEGER := 0;
    v_max_ver_seq VARCHAR2(4000 CHAR);
    v_program_name VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
    v_log_type VARCHAR2(30 CHAR);
    n_log_count INTEGER := 0;
    v_log_message VARCHAR2(1000 CHAR);
    v_log_description VARCHAR2(500 CHAR);
    d_event_date DATE;
    n_delete_count INTEGER := 0;
    n_insert_count INTEGER := 0;
    n_input_count INTEGER := 0;
    n_logo_count INTEGER := 0;
    v_index_active_flag INTEGER;
    v_index_ver_seq INTEGER;
    v_index_department_id INTEGER;
    v_index_dept_id INTEGER;
    v_index_end_cust_report INTEGER;
    v_index_soldto_cust_report INTEGER;
    v_index_product_group INTEGER;
    v_index_dm_biz_type INTEGER;
    v_index_yyyymm INTEGER;
    v_index_os_corp_cd INTEGER;
    v_index_contribution_type INTEGER;
    v_index_contribution_ratio INTEGER;
    v_index_created_by INTEGER;
    v_in_para_data CLOB;
    vp_active_flag VARCHAR2(4000 CHAR);
    vp_ver_seq VARCHAR2(4000 CHAR);
    vp_department_id VARCHAR2(4000 CHAR);
    vp_dept_id VARCHAR2(4000 CHAR);
    vp_end_cust_report VARCHAR2(4000 CHAR);
    vp_soldto_cust_report VARCHAR2(4000 CHAR);
    vp_product_group VARCHAR2(4000 CHAR);
    vp_dm_biz_type VARCHAR2(4000 CHAR);
    vp_yyyymm VARCHAR2(4000 CHAR);
    vp_os_corp_cd VARCHAR2(4000 CHAR);
    vp_contribution_type VARCHAR2(4000 CHAR);
    vp_contribution_ratio VARCHAR2(4000 CHAR);
    vp_created_by VARCHAR2(4000 CHAR);
BEGIN

    v_in_para_data := JSON_OBJECT(
	    'p_active_flag' VALUE p_active_flag,
	    'p_ver_seq' VALUE p_ver_seq,
	    'p_department_id' VALUE p_department_id,
	    'p_dept_id' VALUE p_dept_id,
	    'p_end_cust_report' VALUE p_end_cust_report,
	    'p_soldto_cust_report' VALUE p_soldto_cust_report,
	    'p_product_group' VALUE p_product_group,
	    'p_dm_biz_type' VALUE p_dm_biz_type,
	    'p_yyyymm' VALUE p_yyyymm,
	    'p_os_corp_cd' VALUE p_os_corp_cd,
	    'p_contribution_type' VALUE p_contribution_type,
	    'p_contribution_ratio' VALUE p_contribution_ratio,
	    'p_created_by' VALUE p_created_by
	  );

	-- 스플릿관련 변수
	v_delimiter := '^'; -- 데이터 구분자

	vp_active_flag := RTRIM(p_active_flag				    )  ||  '^';
	vp_ver_seq := RTRIM(p_ver_seq					    )  ||  '^';
	vp_department_id := RTRIM(p_department_id			    )  ||  '^';
	vp_dept_id := RTRIM(p_dept_id					    )  ||  '^';
	vp_end_cust_report := RTRIM(p_end_cust_report			    )  ||  '^';
	vp_soldto_cust_report := RTRIM(p_soldto_cust_report			)  ||  '^';
	vp_product_group := RTRIM(p_product_group			    )  ||  '^';
	vp_dm_biz_type := RTRIM(p_dm_biz_type				    )  ||  '^';
	vp_yyyymm := RTRIM(p_yyyymm					    )  ||  '^';
	vp_os_corp_cd := RTRIM(p_os_corp_cd				    )  ||  '^';
	vp_contribution_type := RTRIM(p_contribution_type		    )  ||  '^';
	vp_contribution_ratio := RTRIM(p_contribution_ratio		    )  ||  '^';
	vp_created_by := RTRIM(p_created_by				    )  ||  '^';

	-- GT_SDMCR_RESULTS_MST_2 TEMP TABLE
	DELETE FROM GT_SDMCR_RESULTS_MST_2;

	-- 시작 LOG  (START)
	v_log_type := 'START';
	v_log_message := '########## Start of procedure @@@##########';
	v_log_description := NULL;
	d_event_date := SYSTIMESTAMP;
	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data => v_in_para_data
      );
	v_log_message := NULL;  /*-- <- 변수 재사용을 위하여 초기화해야함 --*/
	-- 시작 LOG  (END)
	-- 트랜잭션 (START)
	-- -----------------------------------------------------------------------------------------
	-- BEGIN TRY (Oracle: EXCEPTION 블록으로 대체)
	-- -----------------------------------------------------------------------------------------
	--===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO start
	--###############################################  GT_SDMCR_RESULTS_MST_2 테이블에 split후 insert (START)
	WHILE LENGTH(vp_ver_seq) > 0 LOOP

		v_index_active_flag := INSTR(vp_active_flag, '^');
		v_index_ver_seq := INSTR(vp_ver_seq, '^');
		v_index_department_id := INSTR(vp_department_id, '^');
		v_index_dept_id := INSTR(vp_dept_id, '^');
		v_index_end_cust_report := INSTR(vp_end_cust_report, '^');
		v_index_soldto_cust_report := INSTR(vp_soldto_cust_report, '^');
		v_index_product_group := INSTR(vp_product_group, '^');
		v_index_dm_biz_type := INSTR(vp_dm_biz_type, '^');
		v_index_yyyymm := INSTR(vp_yyyymm, '^');
		v_index_os_corp_cd := INSTR(vp_os_corp_cd, '^');
		v_index_contribution_type := INSTR(vp_contribution_type, '^');
		v_index_contribution_ratio := INSTR(vp_contribution_ratio, '^');
		v_index_created_by := INSTR(vp_created_by, '^');

		IF vp_ver_seq is not null THEN

				v_active_flag := SUBSTR(vp_active_flag			, 1, v_index_active_flag - 1			);
				v_ver_seq := SUBSTR(vp_ver_seq				, 1, v_index_ver_seq - 1				);
				v_department_id := SUBSTR(vp_department_id		, 1, v_index_department_id - 1		);
				v_dept_id := SUBSTR(vp_dept_id				, 1, v_index_dept_id - 1				);
				v_end_cust_report := SUBSTR(vp_end_cust_report		, 1, v_index_end_cust_report - 1		);
				v_soldto_cust_report := SUBSTR(vp_soldto_cust_report	, 1, v_index_soldto_cust_report - 1	);
				v_product_group := SUBSTR(vp_product_group		, 1, v_index_product_group - 1		);
				v_dm_biz_type := SUBSTR(vp_dm_biz_type			, 1, v_index_dm_biz_type - 1			);
				v_yyyymm := SUBSTR(vp_yyyymm				, 1, v_index_yyyymm - 1				);
				v_os_corp_cd := SUBSTR(vp_os_corp_cd			, 1, v_index_os_corp_cd - 1			);
				v_contribution_type := SUBSTR(vp_contribution_type	, 1, v_index_contribution_type - 1	);
				v_contribution_ratio := SUBSTR(vp_contribution_ratio	, 1, v_index_contribution_ratio - 1	);
				v_created_by := SUBSTR(vp_created_by			, 1, v_index_created_by - 1			);

				vp_active_flag := SUBSTR(vp_active_flag			, LENGTH(v_active_flag			 ||  '^') + 1, LENGTH(vp_active_flag			));
				vp_ver_seq := SUBSTR(vp_ver_seq				, LENGTH(v_ver_seq				|| '^') + 1, LENGTH(vp_ver_seq				));
				vp_department_id := SUBSTR(vp_department_id		, LENGTH(v_department_id			 ||  '^') + 1, LENGTH(vp_department_id		));
				vp_dept_id := SUBSTR(vp_dept_id				, LENGTH(v_dept_id				 ||  '^') + 1, LENGTH(vp_dept_id				));
				vp_end_cust_report := SUBSTR(vp_end_cust_report		, LENGTH(v_end_cust_report		 ||  '^') + 1, LENGTH(vp_end_cust_report		));
				vp_soldto_cust_report := SUBSTR(vp_soldto_cust_report	, LENGTH(v_soldto_cust_report		 ||  '^') + 1, LENGTH(vp_soldto_cust_report	));
				vp_product_group := SUBSTR(vp_product_group		, LENGTH(v_product_group			 ||  '^') + 1, LENGTH(vp_product_group		));
				vp_dm_biz_type := SUBSTR(vp_dm_biz_type			, LENGTH(v_dm_biz_type			 ||  '^') + 1, LENGTH(vp_dm_biz_type			));
				vp_yyyymm := SUBSTR(vp_yyyymm				, LENGTH(v_yyyymm					 ||  '^') + 1, LENGTH(vp_yyyymm				));
				vp_os_corp_cd := SUBSTR(vp_os_corp_cd			, LENGTH(v_os_corp_cd				 ||  '^') + 1, LENGTH(vp_os_corp_cd			));
				vp_contribution_type := SUBSTR(vp_contribution_type	, LENGTH(v_contribution_type		 ||  '^') + 1, LENGTH(vp_contribution_type	));
				vp_contribution_ratio := SUBSTR(vp_contribution_ratio	, LENGTH(v_contribution_ratio		|| '^') + 1, LENGTH(vp_contribution_ratio	));
				vp_created_by := SUBSTR(vp_created_by			, LENGTH(v_created_by				 ||  '^') + 1, LENGTH(vp_created_by			));

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag					));
				v_ver_seq := rtrim(ltrim(v_ver_seq						));
				v_department_id := rtrim(ltrim(v_department_id					));
				v_dept_id := rtrim(ltrim(v_dept_id						));
				v_end_cust_report := rtrim(ltrim(v_end_cust_report				));
				v_soldto_cust_report := rtrim(ltrim(v_soldto_cust_report				));
				v_product_group := rtrim(ltrim(v_product_group					));
				v_dm_biz_type := rtrim(ltrim(v_dm_biz_type					));
				v_yyyymm := rtrim(ltrim(v_yyyymm							));
				v_os_corp_cd := rtrim(ltrim(v_os_corp_cd						));
				v_contribution_type := rtrim(ltrim(v_contribution_type				));
				v_contribution_ratio := rtrim(ltrim(v_contribution_ratio				));
				v_created_by := rtrim(ltrim(v_created_by						));
				--공백제거
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LENGTH(v_yyyymm) > 4 THEN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							) VALUES (
													 v_active_flag
													,v_ver_seq
													,v_department_id
													,v_dept_id
													,v_end_cust_report
													,v_soldto_cust_report
													,v_product_group
													,v_dm_biz_type
													,v_yyyymm
													,v_os_corp_cd
													,v_contribution_type
													,v_contribution_ratio
													,v_created_by
							);
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							)
							select
									 v_active_flag
									,v_ver_seq
									,v_department_id
									,v_dept_id
									,v_end_cust_report
									,v_soldto_cust_report
									,v_product_group
									,v_dm_biz_type
									,basis_yyyymm
									,v_os_corp_cd
									,v_contribution_type
									,v_contribution_ratio
									,v_created_by
							from SCM_SYS_CALENDAR_M  where SUBSTR(basis_yyyymm,1,4) = v_yyyymm GROUP BY basis_yyyymm;
					END;
				END IF;
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
		ELSE
				v_ver_seq := vp_ver_seq;
				vp_ver_seq := NULL;

				--공백제거
				v_active_flag := rtrim(ltrim(v_active_flag					));
				v_ver_seq := rtrim(ltrim(v_ver_seq						));
				v_department_id := rtrim(ltrim(v_department_id					));
				v_dept_id := rtrim(ltrim(v_dept_id						));
				v_end_cust_report := rtrim(ltrim(v_end_cust_report				));
				v_soldto_cust_report := rtrim(ltrim(v_soldto_cust_report				));
				v_product_group := rtrim(ltrim(v_product_group					));
				v_dm_biz_type := rtrim(ltrim(v_dm_biz_type					));
				v_yyyymm := rtrim(ltrim(v_yyyymm							));
				v_os_corp_cd := rtrim(ltrim(v_os_corp_cd						));
				v_contribution_type := rtrim(ltrim(v_contribution_type				));
				v_contribution_ratio := rtrim(ltrim(v_contribution_ratio				));
				v_created_by := rtrim(ltrim(v_created_by						));
				--공백제거
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (BEGIN)
				IF LENGTH(v_yyyymm) > 4 THEN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							) VALUES (
													 v_active_flag
													,v_ver_seq
													,v_department_id
													,v_dept_id
													,v_end_cust_report
													,v_soldto_cust_report
													,v_product_group
													,v_dm_biz_type
													,v_yyyymm
													,v_os_corp_cd
													,v_contribution_type
													,v_contribution_ratio
													,v_created_by
							);
				ELSE
					-- 년모드인 경우 (12개월을 INSERT함)
					BEGIN
							INSERT INTO GT_SDMCR_RESULTS_MST_2 (
													 active_flag
													,ver_seq
													,department_id
													,dept_id
													,end_cust_report
													,soldto_cust_report
													,product_group
													,dm_biz_type
													,yyyymm
													,os_corp_cd
													,contribution_type
													,contribution_ratio
													,created_by
							)
							select
									 v_active_flag
									,v_ver_seq
									,v_department_id
									,v_dept_id
									,v_end_cust_report
									,v_soldto_cust_report
									,v_product_group
									,v_dm_biz_type
									,basis_yyyymm
									,v_os_corp_cd
									,v_contribution_type
									,v_contribution_ratio
									,v_created_by
							from SCM_SYS_CALENDAR_M  where SUBSTR(basis_yyyymm,1,4) = v_yyyymm GROUP BY basis_yyyymm;
					END;
				END IF;
				-------------------------------------- 월모드인경우 INPUT 값을 그대로 INSERT하고 년모드 인경우 12개월로 늘려서 INSERT함 (END)
		END IF;
	END LOOP;

	--===================================================================================== GT_SDMCR_RESULTS_MST_2 테이블에 split후 INSERT INTO end
--select department_id
--		,dept_id
--		,end_cust_report
--		,soldto_cust_report
--		,product_group
--		,dm_biz_type
--		, Contribution_Type
--		, SUM(CAST (Contribution_Ratio AS NUMBER(5,2)))
--from GT_SDMCR_RESULTS_MST_2
--GROUP BY department_id
--		,dept_id
--		,end_cust_report
--		,soldto_cust_report
--		,product_group
--		,dm_biz_type
--		, Contribution_Type
--RAISE_APPLICATION_ERROR(-20001, 'sdf')
	-- INPUT COUNT 확인
	SELECT count(ver_seq) INTO n_input_count
								FROM GT_SDMCR_RESULTS_MST_2;

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇
	BEGIN
		-- INSERT INTO COUNT 확인
		SELECT count(M.ver_seq) INTO n_logo_count
									FROM GT_SDMCR_RESULTS_MST_2 M
										where 1=1;

		-- MST INSERT전 DELETE수행 (BEGIN)
		DELETE
		FROM DM_MST_CONTRIBUTE_RATIO_MST
		WHERE EXISTS (
				SELECT 1
					FROM GT_SDMCR_RESULTS_MST_2 M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_MST.ver_seq				= M.ver_seq
						and DM_MST_CONTRIBUTE_RATIO_MST.department_id		= M.department_id
						and DM_MST_CONTRIBUTE_RATIO_MST.dept_id				= M.dept_id
						and DM_MST_CONTRIBUTE_RATIO_MST.end_cust_report		= M.end_cust_report
						and DM_MST_CONTRIBUTE_RATIO_MST.soldto_cust_report	= M.soldto_cust_report
						and DM_MST_CONTRIBUTE_RATIO_MST.product_group		= M.product_group
						and DM_MST_CONTRIBUTE_RATIO_MST.dm_biz_type			= M.dm_biz_type
				);
		-- MST INSERT전 DELETE수행 (END)
		-- MST INSERT수행 (BEGIN)
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_MST
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE,MAX(CREATED_BY),SYSDATE,MAX(CREATED_BY) LAST_UPDATED_BY,SYSDATE
			FROM GT_SDMCR_RESULTS_MST_2
				WHERE 1=1
		GROUP BY VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE;
		-- MST INSERT수행 (END)
	END;
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_MST 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (START)
	--------------------------------------------------------------------------------------------◇◇◇◇

		-- DTL INSERT전 DELETE수행 (BEGIN)
		DELETE
		FROM DM_MST_CONTRIBUTE_RATIO_DTL
		WHERE EXISTS (
				SELECT 1
					FROM GT_SDMCR_RESULTS_MST_2 M
					where 1=1
						and DM_MST_CONTRIBUTE_RATIO_DTL.ver_seq				= M.ver_seq
						and DM_MST_CONTRIBUTE_RATIO_DTL.department_id		= M.department_id
						and DM_MST_CONTRIBUTE_RATIO_DTL.dept_id				= M.dept_id
						and DM_MST_CONTRIBUTE_RATIO_DTL.end_cust_report		= M.end_cust_report
						and DM_MST_CONTRIBUTE_RATIO_DTL.soldto_cust_report	= M.soldto_cust_report
						and DM_MST_CONTRIBUTE_RATIO_DTL.product_group		= M.product_group
						and DM_MST_CONTRIBUTE_RATIO_DTL.dm_biz_type			= M.dm_biz_type
				);
		-- DTL INSERT전 DELETE수행 (END)
		-- DTL INSERT수행 (BEGIN)
		INSERT INTO DM_MST_CONTRIBUTE_RATIO_DTL
			(VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE)
		SELECT VER_SEQ,DEPARTMENT_ID,DEPT_ID,END_CUST_REPORT,SOLDTO_CUST_REPORT,PRODUCT_GROUP,DM_BIZ_TYPE
			,YYYYMM,OS_CORP_CD,CONTRIBUTION_TYPE,CONTRIBUTION_RATIO
			,CREATED_BY,SYSDATE,CREATED_BY LAST_UPDATED_BY,SYSDATE
			FROM GT_SDMCR_RESULTS_MST_2
				WHERE 1=1;
		-- DTL INSERT수행 (END)

	--------------------------------------------------------------------------------------------◇◇◇◇
	--                                          DM_MST_CONTRIBUTE_RATIO_DTL 테이블 DELETE,INSERT (END)
	--------------------------------------------------------------------------------------------◇◇◇◇
  	-- 트랜잭션 (COMMIT)
		-- -----------------------------------------------------------------------------------------
		-- END TRY
	-- -----------------------------------------------------------------------------------------
    COMMIT;
	-- -----------------------------------------------------------
    EXCEPTION
	WHEN OTHERS THEN
	-- -----------------------------------------------------------
		--[C20200909-000203] LOG 표준화 적용
		-- 트랜잭션 (END)
		v_log_type := 'ERROR';
		v_log_message := SUBSTR(SQLERRM, 1, 1000);
		v_log_description := 'ERROR_LINE : '  ||  TO_CHAR(NULL);
		d_event_date := SYSTIMESTAMP;

		v_log_message := '['  ||  TO_CHAR(SQLCODE)  ||  ']'  ||  SQLERRM;  /*-- 에러메시지 DISPLAY --*/

		PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	p_in_para_data	=> v_in_para_data,
	p_sql_err_code	=> SQLCODE,
	p_sql_err_msg	=> SQLERRM,
	p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
      );

	-- -----------------------------------------------------------
    -- END CATCH
	-- -----------------------------------------------------------
	-- 수행결과 성공여부 DISPLAY
	ROLLBACK;

	PR_SCM_SYS_LOG_BATCH(v_program_name, v_log_type, n_log_count, v_log_message, v_log_description, d_event_date,
	    p_in_para_data  => v_in_para_data,
	    p_sql_err_code  => SQLCODE,
	    p_sql_err_msg   => SQLERRM,
	    p_sql_backtrace => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE
	  );
    RAISE_APPLICATION_ERROR(-20001,
	'[' || $$PLSQL_UNIT || '] SQLCODE=' || SQLCODE ||
	' / SQLERRM=' || SQLERRM ||
	' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
	' / PARAMS=' || v_in_para_data
    );
END;/

-- ===================================================================================================
-- FALLBACK: 의존 객체 순서로 인한 INVALID 잔존 시 강제 재컴파일
-- 사고 사례 (2026-06-17): DMF0043_GET_CONTRIBUTE_MAIN_DATA (객체 3) 가 line 74 에서
--                        DMF0043_GET_MAIN_SPREAD_TITLE (객체 4) 호출 → CREATE 시점 INVALID 의존
--                        → PLS-00905 → 본 객체 INVALID 잔존. 객체 4 컴파일 후 재컴파일 필요.
-- ===================================================================================================
ALTER PROCEDURE SCM_MGR.DMF0043_GET_CONTRIBUTE_MAIN_DATA COMPILE;
/
ALTER PROCEDURE SCM_MGR.DMF0043_GET_MAIN_SPREAD_TITLE COMPILE;
/

