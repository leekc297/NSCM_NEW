-- ============================================================
-- PKG_DMF0043 (spec + body) — dev/local DDL extract
-- 실행 계정: SCM_MGR
-- ============================================================

-- ===== SPEC =====
CREATE OR REPLACE EDITIONABLE PACKAGE "SCM_MGR"."PKG_DMF0043" IS
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

END PKG_DMF0043;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_DMF0043" IS

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

END PKG_DMF0043;
/
/

-- ===== BODY =====
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_DMF0043" IS

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

END PKG_DMF0043;
/
/
