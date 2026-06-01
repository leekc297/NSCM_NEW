/*=============================================================================================
 * File         : 04_Package_PKG_DMF0043.sql
 * Description  : Package — PKG_DMF0043
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_DMF0043 IS
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


    -- ============================================================
    -- 신규 흡수 (2026-05-13 P1-2): standalone SP에서 통합
    -- ============================================================
    PROCEDURE P_DMF0043_GET_CONTRIBUTE_MAIN_DATA (
        p_yyyy             VARCHAR2,
        p_ver_seq          VARCHAR2,
        p_dis              VARCHAR2,
        p_his              VARCHAR2,
        p_created_by       VARCHAR2,
        p_user_group       VARCHAR2
    /****************************************************************************************************/
    );

    PROCEDURE P_DMF0043_GET_CONTRIBUTION_SALES_LIST (
        p_division_id      VARCHAR2,
        p_ver_seq          VARCHAR2,
        p_version_no       VARCHAR2,
        p_end_cust_report  VARCHAR2,
        p_product_group    VARCHAR2,
        p_biz_type         VARCHAR2,
        p_million_yn       VARCHAR2,
        p_compatibility_yn VARCHAR2,
        p_created_by       VARCHAR2
    /****************************************************************************************************/
    );

    END PKG_DMF0043;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_DMF0043 IS

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
    
        V_IN_PARA_DATA CLOB;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_TYPE     VARCHAR2(30 CHAR);
        N_LOG_COUNT    INTEGER := 0;
        V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
        V_DESCRIPTION  VARCHAR2(500 CHAR);
        D_EVENT_DATE   DATE;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
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
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
        V_IN_PARA_DATA CLOB := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
    
        V_IN_PARA_DATA CLOB;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
        V_IN_PARA_DATA CLOB;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
        END IF;
    
        V_IN_PARA_DATA := JSON_OBJECT('p_division_id' VALUE P_DIVISION_ID, 'p_yyyy' VALUE P_YYYY, 'p_created_by' VALUE P_CREATED_BY);
    
        INSERT /*+ NO_PARALLEL */
        INTO GT_GMST_TEMP_2
            SELECT L.SEGMENT1 AS CODE, L.SEGMENT2 NAME, DISPLAY_SEQ DISPLAY_SEQ
            FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
            WHERE  1 = 1
            AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
            AND    L.VALID_YN = 'Y'
            AND    L.SEGMENT4 = ''
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
                      ,'' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
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
                      ,'' AS EDIT_YN
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
    
        V_IN_PARA_DATA CLOB;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
        V_IN_PARA_DATA CLOB;
        V_LOG_TYPE     VARCHAR2(20) := NULL;
        N_LOG_COUNT    NUMBER := 0;
        $$PLSQL_UNIT VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
        V_LOG_MESSAGE  VARCHAR2(4000 CHAR) := NULL;
        V_DESCRIPTION  VARCHAR2(4000 CHAR) := NULL;
        D_EVENT_DATE   DATE := SYSDATE;
        V_PROC_INPUT   CLOB := NULL;
        V_SQL_CODE     VARCHAR2(100) := NULL;
        V_SQL_ERRMSG   VARCHAR2(4000 CHAR) := NULL;
        V_BACKTRACE    VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
        --AND     L.SEGMENT4  = ''
    
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
                      ,'' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
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
                      ,'' AS EDIT_YN
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
                      ,'' AS EDIT_YN
                FROM   SCM_MST_SHEET_COLUMNS C
                WHERE  1 = 1
                AND    C.PROGRAM_ID = V_PROGRAM_ID
                AND    C.SHEET_NAME = V_SHEET_NAME
                AND    C.VISIBLE_FLAG = ''
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
                      ,'' AS EDIT_YN
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
        $$PLSQL_UNIT             VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
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
        V_IN_PARA_DATA             CLOB;
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
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
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
        
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
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
        
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
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
        $$PLSQL_UNIT      VARCHAR2(150 CHAR) := $$PLSQL_UNIT;
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
        V_IN_PARA_DATA      CLOB;
        V_W_ACTIVE_FLAG     VARCHAR2(4000 CHAR);
        V_W_VER_SEQ         VARCHAR2(4000 CHAR);
        V_W_YYYY            VARCHAR2(4000 CHAR);
        V_W_VERSION_NM      VARCHAR2(4000 CHAR);
        V_W_DESCRIPTION     VARCHAR2(4000 CHAR);
        V_W_VALID_YN        VARCHAR2(4000 CHAR);
        V_W_CREATED_BY      VARCHAR2(4000 CHAR);
    BEGIN
    
        IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
            $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1) (2);
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
        PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
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
        
            PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT
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
                PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_LOG_DESCRIPTION, D_EVENT_DATE, P_IN_PARA_DATA => V_IN_PARA_DATA);
            
            END IF;
        
    END P_DMF0043_SAVE_DM_MST_CONTRIBUTE_VER;


    -- ============================================================
    -- 신규 흡수 (2026-05-13 P1-2): standalone SP 본문 통합
    -- ============================================================
    PROCEDURE P_DMF0043_GET_CONTRIBUTE_MAIN_DATA (
        p_yyyy             VARCHAR2,
        p_ver_seq          VARCHAR2,
        p_dis              VARCHAR2,
        p_his              VARCHAR2,
        p_created_by       VARCHAR2,
        p_user_group       VARCHAR2
    /****************************************************************************************************/
    )
        IS
    v_sdt VARCHAR2(10 CHAR) := p_yyyy  ||  '01';
        v_edt VARCHAR2(10 CHAR) := p_yyyy  ||  '12';
        v_thismm VARCHAR2(10 CHAR);
        V_ColumnData VARCHAR2(4000 CHAR) := NULL;
        V_ColumnData2 VARCHAR2(4000 CHAR) := NULL;
        V_Query VARCHAR2(4000 CHAR) := NULL;
    BEGIN
    
    
    
    
    
    
    
        IF (MONTH(SYSDATE) < 10) THEN
            v_thismm := p_yyyy  ||  '0'  ||  CAST(MONTH(SYSDATE) AS VARCHAR2);
        END ELSE BEGIN
            v_thismm := p_yyyy  ||  CAST(MONTH(SYSDATE) AS VARCHAR2);
        END IF;
    
        -- ######################## 해더 칼럼 데이터 ########################
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_itle';
    
        INSERT INTO GT_DMF0_itle DMF0043_GET_MAIN_SPREAD_TITLE '40',p_yyyy,p_created_by
    
        SELECT V_ColumnData  ||  '['  ||  COLUMN_NAME  ||  ']
      INTO V_ColumnData
        FROM GT_DMF0_itle
        WHERE CAST(SORT_ORDER_NO AS INTEGER) > (SELECT CAST(SORT_ORDER_NO AS INTEGER) FROM GT_DMF0_itle WHERE COLUMN_NAME = 'EDIT_FLAG');
        V_ColumnData := SUBSTR(V_ColumnData, 1, LENGTH(V_ColumnData)-1)
        --select V_ColumnData
    
        SELECT V_ColumnData2 = V_ColumnData2 +
            CASE WHEN INSTR(COLUMN_NAME, '999') <> 0 THEN '[' + COLUMN_NAME + '],'
                ELSE 'CAST([' + COLUMN_NAME + '] AS NUMERIC(5,2)) AS [' + COLUMN_NAME + '],' END
        FROM GT_DMF0_itle
        WHERE CAST(SORT_ORDER_NO AS INTEGER) > (SELECT CAST(SORT_ORDER_NO AS INTEGER) FROM GT_DMF0_itle WHERE COLUMN_NAME = 'EDIT_FLAG');
        V_ColumnData2 := SUBSTR(V_ColumnData2, 1, LENGTH(V_ColumnData2)-1);
        --select V_ColumnData2
        -- ######################## 해더 칼럼 데이터 ########################
    
        IF (p_his = '') THEN
            -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################
            -- 연도 데이터
            /* TODO:GTT:GT_DMF0_-->GT_DMF0_ */
            INSERT INTO GT_DMF0_
            SELECT VER_SEQ
                 , DEPARTMENT_ID
                 , DEPT_ID
                 , END_CUST_REPORT
                 , SOLDTO_CUST_REPORT
                 , PRODUCT_GROUP
                 , DM_BIZ_TYPE
                 , CAST(CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
                 , 'Y#' + p_yyyy + '#' + OS_CORP_CD AS COLUMN_NAME
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
                   ) AS MA
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
                 , CAST(CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
                 , 'Y#' + p_yyyy + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
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
                   ) AS MA
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
                 , CAST(CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
                 , 'M#' + YYYYMM + '#' + OS_CORP_CD AS COLUMN_NAME
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
                   ) AS MA
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
                 , CAST(CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
                 , 'M#' + YYYYMM + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
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
                   ) AS MA
             WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
               AND VER_SEQ = p_ver_seq;
    
            IF (p_dis = 'ALL') THEN
                    -- 불일치 조회 관련 칼럼 추가
                    /* TODO:GTT:GT_DMF0_2-->GT_DMF0_2 */
                    INSERT INTO GT_DMF0_2
                    SELECT MAIN.*
                         , DISCARD.DISCARD
                      FROM GT_DMF0_ MAIN
                           INNER JOIN (SELECT VER_SEQ
                                            , DEPARTMENT_ID
                                            , DEPT_ID
                                            , END_CUST_REPORT
                                            , SOLDTO_CUST_REPORT
                                            , PRODUCT_GROUP
                                            , DM_BIZ_TYPE
                                            , CASE WHEN SUM(CONTRIBUTION_RATIO) = 1200 THEN 'Y' ELSE '' END AS DISCARD
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
                                              ) AS MA
                                        WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
                                          AND VER_SEQ = p_ver_seq
                                        GROUP BY VER_SEQ
                                            , DEPARTMENT_ID
                                            , DEPT_ID
                                            , END_CUST_REPORT
                                            , SOLDTO_CUST_REPORT
                                            , PRODUCT_GROUP
                                            , DM_BIZ_TYPE
                                      ) AS DISCARD
                              ON MAIN.VER_SEQ = DISCARD.VER_SEQ
                             AND MAIN.DEPARTMENT_ID = DISCARD.DEPARTMENT_ID
                             AND MAIN.DEPT_ID = DISCARD.DEPT_ID
                             AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
                             AND MAIN.SOLDTO_CUST_REPORT = DISCARD.SOLDTO_CUST_REPORT
                             AND MAIN.PRODUCT_GROUP = DISCARD.PRODUCT_GROUP
                             AND MAIN.DM_BIZ_TYPE = DISCARD.DM_BIZ_TYPE;
                    -- ######################## DM_MST_CONTRIBUTE_RATIO 데이터 ########################
    
    
                    V_Query := '
    SELECT *
      FROM (SELECT SITE_ITEM.*
                 , RATIO.VER_SEQ
                 , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE '''' END DISCARD
                 , CASE WHEN ((SITE_ITEM.department_id != '''')
                               AND (SITE_ITEM.dept_id != '''')
                               AND (SITE_ITEM.end_cust_report != '''')
                               AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                               AND (SITE_ITEM.PRODUCT_GROUP != '''')
                               AND (SITE_ITEM.dm_biz_type != ''''));
                              THEN ''Y'' ELSE '''' END AS EDIT_FLAG
                 , ' + V_ColumnData2 + '
              FROM (SELECT DISTINCT A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID AS DEPT_ID
                         , TEAM.DEPT_NAME_KO AS DEPT_NAME
                         , NVL(A.ATTRIBUTE2,'''') AS END_CUST_REPORT
                         , NVL(A.ATTRIBUTE1,'''') AS SOLDTO_CUST_REPORT
                         , NVL(A.REPORT_GROUP3,'''') AS PRODUCT_GROUP --PRODUCT_GR
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
                                            ) AS TEAM
                              ON TEAM.USER_ID IN (SELECTtoken FROM TABLE(fn_string_split(A.OWNER, '','')))
                     WHERE A.DIVISION_ID = ''40''
                       AND B.SITE_TYPE = ''SALES''
                       --AND NVL(C.FORECAST_INFO_BIZ_TYPE,'''') <> ''''
                       --AND NVL(A.ATTRIBUTE2,'''') <> ''''
                       --AND NVL(A.ATTRIBUTE1,'''') <> ''''
                       --AND NVL(A.REPORT_GROUP3,'''') <> ''''
                     GROUP BY A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID
                         , TEAM.DEPT_NAME_KO
                         , NVL(SAM.SEGMENT3,'''')
                         , NVL(A.ATTRIBUTE2,'''')
                         , NVL(A.ATTRIBUTE1,'''')
                         , NVL(A.REPORT_GROUP3,'''')
                         , NVL(C.FORECAST_INFO_BIZ_TYPE,'''')
    
                   ) AS SITE_ITEM
                   LEFT JOIN (SELECT VER_SEQ
                                   , DEPARTMENT_ID
                                   , DEPT_ID
                                   , END_CUST_REPORT
                                   , SOLDTO_CUST_REPORT
                                   , PRODUCT_GROUP
                                   , DM_BIZ_TYPE
                                   , DISCARD
                                   , ' + V_ColumnData + '
                                FROM (SELECT *
                                        FROM GT_DMF0_2) MA;
                                     PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
                              ) AS RATIO
                     ON SITE_ITEM.DEPARTMENT_ID   = RATIO.DEPARTMENT_ID
                    AND SITE_ITEM.DEPT_ID         = RATIO.DEPT_ID
                    AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                    AND SITE_ITEM.SOLDTO_CUST_REPORT  = RATIO.SOLDTO_CUST_REPORT
                    AND SITE_ITEM.PRODUCT_GROUP   = RATIO.PRODUCT_GROUP
                    AND SITE_ITEM.DM_BIZ_TYPE     = RATIO.DM_BIZ_TYPE
           ) MA;
     WHERE DISCARD = CASE WHEN ''' + p_dis + ''' = ''ALL'' THEN DISCARD ELSE ''' + p_dis + ''' END;
    '
    
    FETCH FIRST 1 ROWS ONLY
            ELSE  -- 2019/08/27 (p_dis = 'Y') 추가
                    /* TODO:GTT:GT_DMF0_master_list-->GT_DMF0_master_list */
                    INSERT INTO GT_DMF0_master_list
                    SELECT A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID AS DEPT_ID
                         , TEAM.DEPT_NAME_KO AS DEPT_NAME
                         , NVL(A.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                         , NVL(A.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                         , NVL(A.REPORT_GROUP3, NULL) AS PRODUCT_GROUP --PRODUCT_GR
                         , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
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
                                       ) AS TEAM
                              ON TEAM.USER_ID IN (SELECTtoken FROM TABLE(fn_string_split(A.OWNER, ',')))
                     WHERE A.DIVISION_ID = '40'
                       AND B.SITE_TYPE = 'SALES'
                     GROUP BY A.DIVISION_ID
                         , TEAM.DEPARTMENT_ID
                         , TEAM.DEPARTMENT_NAME
                         , TEAM.DEPT_ID
                         , TEAM.DEPT_NAME_KO
                         , NVL(A.ATTRIBUTE2, NULL)
                         , NVL(A.ATTRIBUTE1, NULL)
                         , NVL(A.REPORT_GROUP3, NULL)
                         , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
    
    FETCH FIRST 1 ROWS ONLY;
    
                    /* TODO:GTT:GT_DMF0_list-->GT_DMF0_list */
                    INSERT INTO GT_DMF0_list
                    SELECT MAIN.*
                         , DISCARD.DISCARD
                      FROM GT_DMF0_ MAIN
                           INNER JOIN (SELECT VER_SEQ
                                            , DEPARTMENT_ID
                                            , DEPT_ID
                                            , END_CUST_REPORT
                                            , SOLDTO_CUST_REPORT
                                            , PRODUCT_GROUP
                                            , DM_BIZ_TYPE
                                            , CASE WHEN SUM(CASE WHEN RATIO = 100 THEN 0 ELSE 1 END) > 0 THEN 'Y' ELSE '' END AS DISCARD
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
                                              ) AS MA
                                        GROUP BY VER_SEQ
                                               , DEPARTMENT_ID
                                               , DEPT_ID
                                               , END_CUST_REPORT
                                               , SOLDTO_CUST_REPORT
                                               , PRODUCT_GROUP
                                               , DM_BIZ_TYPE
                                      ) AS DISCARD
                              ON MAIN.VER_SEQ         = DISCARD.VER_SEQ
                             AND MAIN.DEPARTMENT_ID   = DISCARD.DEPARTMENT_ID
                             AND MAIN.DEPT_ID         = DISCARD.DEPT_ID
                             AND MAIN.END_CUST_REPORT = DISCARD.END_CUST_REPORT
                             AND MAIN.SOLDTO_CUST_REPORT  = DISCARD.SOLDTO_CUST_REPORT
                             AND MAIN.PRODUCT_GROUP   = DISCARD.PRODUCT_GROUP
                             AND MAIN.DM_BIZ_TYPE     = DISCARD.DM_BIZ_TYPE
                     WHERE DISCARD.DISCARD = 'Y';
    
                    V_Query := '
    SELECT *
      FROM (SELECT SITE_ITEM.*
                 , RATIO.VER_SEQ
                 , CASE WHEN RATIO.DISCARD = ''Y'' THEN RATIO.DISCARD ELSE '''' END DISCARD
                 , CASE WHEN ((SITE_ITEM.department_id != '''')
                               AND (SITE_ITEM.dept_id != '''')
                               AND (SITE_ITEM.end_cust_report != '''')
                               AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                               AND (SITE_ITEM.PRODUCT_GROUP != '''')
                               AND (SITE_ITEM.dm_biz_type != ''''));
                             THEN ''Y'' ELSE '''' END AS EDIT_FLAG
                 ,' + V_ColumnData2 + '
              FROM GT_DMF0_master_list SITE_ITEM
                   INNER JOIN (SELECT VER_SEQ
                                    , DEPARTMENT_ID
                                    , DEPT_ID
                                    , END_CUST_REPORT
                                    , SOLDTO_CUST_REPORT
                                    , PRODUCT_GROUP
                                    , DM_BIZ_TYPE
                                    , DISCARD
                                    , ' + V_ColumnData + '
    
                                 FROM (SELECT *
                                         FROM GT_DMF0_list
                                        WHERE DISCARD = ''Y'') MA;
                                PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
                              ) AS RATIO
                      ON  SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                     AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
                     AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                     AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                     AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                     AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
    
            UNION ALL
            SELECT SITE_ITEM.*
                 , RATIO.VER_SEQ
                 , ''Y'' AS DISCARD
                 , CASE WHEN ((SITE_ITEM.department_id != '''')
                               AND (SITE_ITEM.dept_id != '''')
                               AND (SITE_ITEM.end_cust_report != '''')
                               AND (SITE_ITEM.SOLDTO_CUST_REPORT != '''')
                               AND (SITE_ITEM.PRODUCT_GROUP != '''')
                               AND (SITE_ITEM.dm_biz_type != ''''));
                             THEN ''Y'' ELSE '''' END AS EDIT_FLAG
                 , ' + V_ColumnData2 + '
              FROM GT_DMF0_master_list SITE_ITEM
                   LEFT OUTER JOIN (SELECT VER_SEQ
                                         , DEPARTMENT_ID
                                         , DEPT_ID
                                         , END_CUST_REPORT
                                         , SOLDTO_CUST_REPORT
                                         , PRODUCT_GROUP
                                         , DM_BIZ_TYPE
                                         , ' + V_ColumnData + '
    
                                      FROM (SELECT * FROM GT_DMF0_) MA;
                                     PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
                                   ) AS RATIO
                     ON SITE_ITEM.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                    AND SITE_ITEM.DEPT_ID = RATIO.DEPT_ID
                    AND SITE_ITEM.END_CUST_REPORT = RATIO.END_CUST_REPORT
                    AND SITE_ITEM.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                    AND SITE_ITEM.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                    AND SITE_ITEM.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
             WHERE RATIO.VER_SEQ IS NULL
           ) MA;
    '
    
                END IF;
    
        ELSE  -- (p_his = 'Y')
            -- ######################## 데이터 ########################
            /* TODO:GTT:GT_DMF0_DataTable-->GT_DMF0_DataTable */
            INSERT INTO GT_DMF0_DataTable
            SELECT CONTRIBUTE.*
                 , SITE_ITEM.DIVISION_ID
              FROM (SELECT MA.VER_SEQ
                         , MA.DEPARTMENT_ID
                         , MA.DEPT_ID
                         , MA.END_CUST_REPORT
                         , MA.SOLDTO_CUST_REPORT
                         , MA.PRODUCT_GROUP
                         , MA.DM_BIZ_TYPE
                      FROM DM_MST_CONTRIBUTE_RATIO_MST MA
                   ) AS CONTRIBUTE
                   LEFT OUTER JOIN (
                        SELECT DISTINCT
                               A.DIVISION_ID
                             , TEAM.DEPARTMENT_ID
                             , TEAM.DEPARTMENT_NAME
                             , TEAM.DEPT_ID AS DEPT_ID
                             , TEAM.DEPT_NAME_KO AS DEPT_NAME
                             , NVL(A.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                             , NVL(A.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                             , NVL(A.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
                             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
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
                                          ) AS TEAM
                                  ON TEAM.USER_ID IN (SELECTTOKEN FROM TABLE(fn_string_split(A.OWNER, ',')))
                         WHERE A.DIVISION_ID = '40'
                           AND B.SITE_TYPE = 'SALES'
                           AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                           AND NVL(A.ATTRIBUTE2, NULL) IS NOT NULL
                           AND NVL(A.ATTRIBUTE1, NULL) IS NOT NULL
                           AND NVL(A.REPORT_GROUP3, NULL) IS NOT NULL
                         GROUP BY A.DIVISION_ID
                             , TEAM.DEPARTMENT_ID
                             , TEAM.DEPARTMENT_NAME
                             , TEAM.DEPT_ID
                             , TEAM.DEPT_NAME_KO
                             , NVL(SAM.SEGMENT3, NULL)
                             , NVL(A.ATTRIBUTE2, NULL)
                             , NVL(A.ATTRIBUTE1, NULL)
                             , NVL(A.REPORT_GROUP3, NULL)
                             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
                       ) AS SITE_ITEM
                     ON SITE_ITEM.DEPARTMENT_ID = CONTRIBUTE.DEPARTMENT_ID
                    AND SITE_ITEM.DEPT_ID = CONTRIBUTE.DEPT_ID
                    AND SITE_ITEM.END_CUST_REPORT = CONTRIBUTE.END_CUST_REPORT
                    AND SITE_ITEM.SOLDTO_CUST_REPORT = CONTRIBUTE.SOLDTO_CUST_REPORT
                    AND SITE_ITEM.PRODUCT_GROUP = CONTRIBUTE.PRODUCT_GROUP
                    AND SITE_ITEM.DM_BIZ_TYPE = CONTRIBUTE.DM_BIZ_TYPE
             WHERE SITE_ITEM.DIVISION_ID IS NULL
    
            -- 연도 데이터
    FETCH FIRST 1 ROWS ONLY
            /* TODO:GTT:GT_DMF0_3-->GT_DMF0_3 */
            INSERT INTO GT_DMF0_3
            SELECT MA.VER_SEQ
                 , MA.DEPARTMENT_ID
                 , MA.DEPT_ID
                 , MA.END_CUST_REPORT
                 , MA.SOLDTO_CUST_REPORT
                 , MA.PRODUCT_GROUP
                 , MA.DM_BIZ_TYPE
                 , CAST(DTL.CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
                 , 'Y#' + p_yyyy + '#' + DTL.OS_CORP_CD AS COLUMN_NAME
              FROM GT_DMF0_DataTable MA
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
                 , CAST(DTL.CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
                 , 'Y#' + p_yyyy + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
              FROM GT_DMF0_DataTable MA
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
                 , CAST(DTL.CONTRIBUTION_RATIO AS VARCHAR2) AS RATIO
                 , 'M#' + YYYYMM + '#' + OS_CORP_CD AS COLUMN_NAME
              FROM GT_DMF0_DataTable MA
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
                 , CAST(DTL.CONTRIBUTION_TYPE AS VARCHAR2) AS RATIO
                 , 'M#' + YYYYMM + 'GT_DMF0_RBU_0999' AS COLUMN_NAME
              FROM GT_DMF0_DataTable MA
                   INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL DTL
                      ON MA.DEPARTMENT_ID = DTL.DEPARTMENT_ID
                     AND MA.DEPT_ID = DTL.DEPT_ID
                     AND MA.END_CUST_REPORT = DTL.END_CUST_REPORT
                     AND MA.SOLDTO_CUST_REPORT = DTL.SOLDTO_CUST_REPORT
                     AND MA.PRODUCT_GROUP = DTL.PRODUCT_GROUP
                     AND MA.DM_BIZ_TYPE = DTL.DM_BIZ_TYPE
             WHERE YYYYMM >= v_sdt AND YYYYMM <= v_edt
               AND MA.VER_SEQ = p_ver_seq;
            -- select * from GT_DMF0_
            -- ######################## 데이터 ########################
    
            V_Query := '
    SELECT VER_SEQ
         , DEPARTMENT_ID
         , DEPT_ID
         , END_CUST_REPORT
         , SOLDTO_CUST_REPORT
         , PRODUCT_GROUP
         , DM_BIZ_TYPE
         , '''' AS EDIT_FLAG
         , ' + V_ColumnData + '
      FROM (SELECT *
              FROM GT_DMF0_3) MA;
     PIVOT (MAX(RATIO) FOR COLUMN_NAME IN (' + V_ColumnData + ')) AS PVT
    '
        END IF;
    
        --SELECT CAST(V_Query AS TEXT)
        --FOR XML PATH('')--,ROOT('x')
    
        EXECUTE SP_EXECUTESQL V_Query
    
    END P_DMF0043_GET_CONTRIBUTE_MAIN_DATA;

    PROCEDURE P_DMF0043_GET_CONTRIBUTION_SALES_LIST (
        p_division_id      VARCHAR2,
        p_ver_seq          VARCHAR2,
        p_version_no       VARCHAR2,
        p_end_cust_report  VARCHAR2,
        p_product_group    VARCHAR2,
        p_biz_type         VARCHAR2,
        p_million_yn       VARCHAR2,
        p_compatibility_yn VARCHAR2,
        p_created_by       VARCHAR2
    /****************************************************************************************************/
    )
        IS
    /*
     * ========================================
     * [변환검증] 2026-03-02 20:37:24
     * 파일: dbo.DMF0043_GET_CONTRIBUTION_SALES_LIST.sql
     * ----------------------------------------
     * ⚠ BEGIN: BEGIN:1  END:2  차이:-1
     * ----------------------------------------
     * BEGIN 위치: L40
     * END;  위치: L196, L686
     * ----------------------------------------
     * 힌트: END가 1개 더 많음 → 고아 END; 확인 필요
     * 수정 완료 후 이 주석 블록을 삭제하세요.
     * ========================================
     */
    
    
    
        v_sql_text VARCHAR2(4000 CHAR);
        v_code VARCHAR2(4000 CHAR);
        v_large_code VARCHAR2(4000 CHAR);
        v_small_code VARCHAR2(4000 CHAR);
        v_groupby VARCHAR2(4000 CHAR);
        v_orderby VARCHAR2(4000 CHAR);
        v_col_name VARCHAR2(50 CHAR);
        v_sort_order_no VARCHAR2(50 CHAR);
        v_program_id VARCHAR2(10 CHAR);
        v_sheet_name VARCHAR2(100 CHAR);
        v_user_col_cnt INTEGER;
        v_seq INTEGER;
        v_col VARCHAR2(4000 CHAR);
        v_col_Sum VARCHAR2(4000 CHAR) := NULL;
        v_bottom VARCHAR2(4000 CHAR);
        v_bottom_Sum VARCHAR2(4000 CHAR) := NULL;
        v_col_Total VARCHAR2(4000 CHAR) := NULL;
        v_nsql2 VARCHAR2(4000 CHAR);
        va_program_id VARCHAR2(4000 CHAR);
        va_sheet_name VARCHAR2(4000 CHAR);
    BEGIN
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        va_program_id := 'DMF0043';
        va_sheet_name := 'ContributeSalesList';
    
        v_col_name := NULL;
        v_col := NULL;
        v_groupby := NULL;
        v_user_col_cnt := 0;
    
        SELECT COUNT(*)
      INTO v_user_col_cnt
        FROM   SCM_MST_TITLESET_USER U
        WHERE  1 = 1
        AND  U.PROGRAM_ID = va_program_id
        AND    U.SHEET_NAME = va_sheet_name
        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
        AND    U.USER_ID    = p_created_by;
    
        IF v_user_col_cnt = 0 THEN
            INSERT INTO SCM_MST_TITLESET_USER
            ( USER_ID
            , PROGRAM_ID
            , SHEET_NAME
            , USER_INQUIRY_COLUMN_TYPE_CODE
            , COLUMN_NAME
            , SORT_ORDER_NO
            , SUB_TOTAL_FLAG
            , DATA_SORT_METHOD_CODE
            , CREATED_BY
            , CREATION_DATE
            , LAST_UPDATED_BY
            , LAST_UPDATE_DATE
            )
            SELECT p_created_by
                 , C.PROGRAM_ID
          , C.SHEET_NAME
                 , 'C'
                 , C.COLUMN_NAME
                 , C.SORT_ORDER_NO
                 , ''
                 , ''
                 , p_created_by
                 , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
                 , p_created_by
                 , TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS.FF3')
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = va_program_id
            AND    C.SHEET_NAME  = va_sheet_name
            AND    C.DEFAULT_FLAG = 'Y'
            AND    C.VALID_YN     = 'Y' ;
        END IF;
    
        --정렬 정보 쿼리 add son young suk 20180727
        v_nsql2 := 'SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , U.SORT_ORDER_NO
                 , U.DATA_SORT_METHOD_CODE
            FROM   SCM_MST_TITLESET_USER U
                 , SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    U.PROGRAM_ID  = C.PROGRAM_ID
            AND    U.SHEET_NAME  = C.SHEET_NAME
            AND    U.COLUMN_NAME = C.COLUMN_NAME
            AND    U.PROGRAM_ID  = '''  ||  va_program_id  || '''
            AND    U.SHEET_NAME  = '''  ||  va_sheet_name  || '''
            AND    U.USER_ID     = '''  ||  p_created_by  ||  '''
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = ''C''
            AND    C.VALID_YN = ''Y''
            AND  '''  ||  p_division_id  ||  ''' IN (SELECT token FROM TABLE(fn_string_split(C.DIVISION_ID ,'','')) )  -- 20190214
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.SORT_ORDER_NO
                 , C.DATA_SORT_METHOD_CODE
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = '''  ||  va_program_id  || '''
            AND    C.SHEET_NAME  = '''  ||  va_sheet_name  || '''
            AND    C.DEFAULT_FLAG = ''''
            AND    C.VALID_YN     = ''Y''
            ORDER BY SORT_ORDER_NO';
    
        -- TODO: CURSOR-->BULK COLLECT 변환 필요
        -- c_title CURSOR FAST_FORWARD FOR
            SELECT U.PROGRAM_ID
                 , U.SHEET_NAME
                 , U.COLUMN_NAME
                 , U.SORT_ORDER_NO
            FROM   SCM_MST_TITLESET_USER U
                 , SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    U.PROGRAM_ID  = C.PROGRAM_ID
            AND    U.SHEET_NAME  = C.SHEET_NAME
            AND    U.COLUMN_NAME = C.COLUMN_NAME
            AND    U.PROGRAM_ID  = va_program_id
            AND    U.SHEET_NAME  = va_sheet_name
            AND    U.USER_ID     = p_created_by
            AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
            UNION ALL
            SELECT C.PROGRAM_ID
                 , C.SHEET_NAME
                 , C.COLUMN_NAME
                 , C.SORT_ORDER_NO
            FROM   SCM_MST_SHEET_COLUMNS C
            WHERE  1 = 1
            AND    C.PROGRAM_ID  = va_program_id
            AND    C.SHEET_NAME  = va_sheet_name
            AND    C.DEFAULT_FLAG IS NULL
            AND    C.VALID_YN     = 'Y'
            ORDER BY SORT_ORDER_NO ;
    
        OPEN c_title;
        FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
        WHILE v_fetch_status = 0 LOOP
          IF v_col = '' THEN
    			  v_col := 'A.'  ||  v_col_name;
    			  v_groupby := ' GROUP BY A.'  ||  v_col_name;
    			  v_orderby := ' ORDER BY A.'  ||  v_col_name;
    			  -- 합계로우용
    			  v_bottom := '''Total''';
          ELSE
                  v_col := v_col  ||  ', A.'  ||  v_col_name;
                  v_groupby := v_groupby  ||  ', A.'  ||  v_col_name;
                  v_orderby := v_orderby  ||  ', A.'  ||  v_col_name;
    			  -- 합계 로우 용
    			  v_bottom := v_bottom  ||  ', null';
              END IF;
              END LOOP;
    
          FETCH c_title INTO v_program_id, v_sheet_name, v_col_name, v_sort_order_no;
        END;
    
        CLOSE c_title;
        DEALLOCATE c_title;
    
        /*/*
    
        /* TODO:GTT:GT_DMF0_sales_plan_c-->GT_DMF0_sales_plan_c */
        INSERT INTO GT_DMF0_sales_plan_c
        SELECT DIVISION_ID
             , VERSION_NO
    		 , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , YYYYMMDD
             , QTY
          FROM DM_PLN_SALES_PLAN_C
         WHERE DIVISION_ID = p_division_id
           AND VERSION_NO = p_version_no
           AND MEASURE = 'SalesAmt_USD'
           AND SCM_SITE_ID NOT IN (SELECT SEGMENT1
                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                           WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
           AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%';
    
    
    
    
        /* TODO:GTT:GT_DMF0_sales_result_c-->GT_DMF0_sales_result_c */
        INSERT INTO GT_DMF0_sales_result_c
        SELECT PR.DIVISION_ID
             , PR.VERSION_NO
             , PR.PROJECT_CODE
             , PR.SCM_SITE_ID
             , PR.ITEM_ID
             , PR.YYYYMMDD
             , CASE WHEN NVL(FP.EXCHANGE_PRICE,0) = 0 THEN 0
                    ELSE PR.QTY/NVL(FP.EXCHANGE_PRICE,0)
               END AS QTY
          FROM DM_PLN_SALES_PLAN_RESULT_C PR
               LEFT OUTER JOIN DM_MST_EXCHANGE_RATE_C FP
                 ON PR.DIVISION_ID = FP.DIVISION_ID
                AND PR.VERSION_NO = FP.VERSION_NO
                AND SUBSTR(PR.YYYYMMDD,1,6) || '01' = FP.YYYYMMDD
                AND FP.UNIT_CURRENCY = 'USD'
         WHERE PR.DIVISION_ID = p_division_id
           AND PR.VERSION_NO = p_version_no
           AND PR.MEASURE = 'SalesAmt_KRW'
           AND PR.SCM_SITE_ID NOT IN (SELECT SEGMENT1
                                        FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                       WHERE LOOKUP_TYPE = 'INTERNAL_TXN')  -- 20190906 소거매출 제외
           AND PR.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%';
    	*/
    
    	EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_DMF0_plan_report_c';
    
    	IF ( p_version_no LIKE 'BP%') THEN
    		INSERT INTO GT_DMF0_plan_report_c
    		SELECT DIVISION_ID
    			 , VERSION_NO
    			 , PROJECT_CODE
    			 , SCM_SITE_ID
    			 , ITEM_ID
    			 , YYYYMMDD
    			 , QTY
    		 FROM (
    				   SELECT DIVISION_ID
    					 , VERSION_NO
    					 , PROJECT_CODE
    					 , SCM_SITE_ID
    					 , ITEM_ID
    					 , YYYYMM AS YYYYMMDD
    					 , QTY
    				  FROM DM_PLN_BP_FCST_REPORT_C
    				 WHERE DIVISION_ID = p_division_id
    				   AND VERSION_NO = p_version_no
    				   AND MEASURE = 'SalesAmt_USD'
    				   AND SCM_SITE_ID NOT IN (
    											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
    											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN   -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
    											)
    				   AND YYYYMM LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%'
    				   ) A;
    	ELSE
    		INSERT INTO GT_DMF0_plan_report_c
    		SELECT DIVISION_ID
    			 , VERSION_NO
    			 , PROJECT_CODE
    			 , SCM_SITE_ID
    			 , ITEM_ID
    			 , YYYYMMDD
    			 , QTY
    		 FROM ( SELECT DIVISION_ID
    					 , VERSION_NO
    					 , PROJECT_CODE
    					 , SCM_SITE_ID
    					 , ITEM_ID
    					 , YYYYMMDD
    					 , QTY
    				  FROM DM_PLN_SALES_PLAN_REPORT_C
    				 WHERE DIVISION_ID = p_division_id
    				   AND VERSION_NO = p_version_no
    				   AND MEASURE = 'SalesAmt_USD'
    				   AND SCM_SITE_ID NOT IN (
    											--SELECT SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WHERE LOOKUP_TYPE = 'INTERNAL_TXN'  -- 20190906 소거매출 제외 -- 20200427 KHSONG 주석처리
    											SELECT COMPANY_ID FROM SCM_MST_COMPANY_SN   -- 20200427 KHSONG C20200305-000035 매출 쿼리 수정 요청의 건 (COMPANY정보 실시간 현행화)
    											)
    				   AND YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%'
    				) A;
    	END IF;
    
        /* TODO:GTT:GT_DMF0_sales_list_c-->GT_DMF0_sales_list_c */
        INSERT INTO GT_DMF0_sales_list_c
        SELECT *
          FROM
              (SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , TEAM.DEPARTMENT_ID
                 , TEAM.DEPARTMENT_NAME
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO AS DEPT_NAME
                 , NVL(I.REPORT_GROUP2, NULL) AS CUST_REPORT
                 , NVL(I.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                 , NVL(I.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                 , NVL(SC.SHIPTO_CODE, NULL) AS SHIPTO_CODE
                 , NVL(I.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
                 , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
                 , CASE WHEN NVL(p_million_yn,'') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
    			 , 'Y' AS EDIT_FLAG
              FROM GT_DMF0_plan_report_c A  --Inner join에서 Left join 으로 변경
                    LEFT JOIN SCM_MST_SITE_ITEM I
                      ON A.DIVISION_ID = I.DIVISION_ID
                     AND A.PROJECT_CODE = I.PROJECT_CODE
                     AND A.SCM_SITE_ID = I.SCM_SITE_ID
                     AND A.ITEM_ID = I.ITEM_ID
                    LEFT JOIN SCM_MST_SITE_CUSTOMER SC
                      ON SC.DIVISION_ID = I.DIVISION_ID
                     AND SC.SCM_SITE_ID = I.SCM_SITE_ID
                     AND SC.REP_YN      = 'Y'
                    LEFT JOIN SCM_MST_SITE B
                      ON A.DIVISION_ID = B.DIVISION_ID
    				 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                    LEFT JOIN DM_MST_ITEM_SINGLE_V C
                      ON A.DIVISION_ID = C.DIVISION_ID
                     AND A.ITEM_ID = C.ITEM_ID
                     --AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                    LEFT JOIN (
                            SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
                            FROM SCM_MST_SSO_USER_INFO B
                            INNER JOIN SCM_MST_SSO_DEPT_INFO C
                            ON B.DEPT_ID = C.DEPT_ID
                            INNER JOIN SCM_MST_SSO_DEPT_INFO D
                            ON C.UPPER_DEPT_ID = D.DEPT_ID
                        ) AS TEAM
          ON TEAM.USER_ID IN (SELECT column_value FROM TABLE(SCM_MGR.FN_SPLIT_STR(I.OWNER, ',')))
             WHERE A.DIVISION_ID = p_division_id
               AND A.VERSION_NO = p_version_no
               AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq) || '%'
             GROUP BY SUBSTR(A.YYYYMMDD,1,6)
                 , TEAM.DEPARTMENT_ID
                 , TEAM.DEPARTMENT_NAME
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO
                 , NVL(I.REPORT_GROUP2, NULL)
                 , NVL(I.ATTRIBUTE2, NULL)
                 , NVL(I.ATTRIBUTE1, NULL)
                 , NVL(SC.SHIPTO_CODE, NULL)
                 , NVL(I.REPORT_GROUP3, NULL)
                 , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
    			 /*
            UNION ALL
    
    FETCH FIRST 1 ROWS ONLY
            SELECT SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , TEAM.DEPARTMENT_ID
                 , TEAM.DEPARTMENT_NAME
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO AS DEPT_NAME
                 , NVL(I.REPORT_GROUP2, NULL) AS CUST_REPORT
                 , NVL(I.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                 , NVL(I.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                 , NVL(SC.SHIPTO_CODE, NULL) AS SHIPTO_CODE
                 , NVL(I.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
                 , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
                 , CASE WHEN NVL(p_million_yn,'') = 'Y' THEN SUM(QTY)/1000000 ELSE SUM(QTY) END AS AMT
    			 , 'Y' AS EDIT_FLAG
              FROM GT_DMF0_sales_result_c A
                   INNER JOIN SCM_MST_SITE_ITEM I
    ON A.DIVISION_ID = I.DIVISION_ID
                     AND A.PROJECT_CODE = I.PROJECT_CODE
                     AND A.SCM_SITE_ID = I.SCM_SITE_ID
                     AND A.ITEM_ID = I.ITEM_ID
                   INNER JOIN SCM_MST_SITE_CUSTOMER SC
                      ON SC.DIVISION_ID = I.DIVISION_ID
                AND SC.SCM_SITE_ID = I.SCM_SITE_ID
                     AND SC.REP_YN      = 'Y'
                   INNER JOIN SCM_MST_SITE B
                      ON A.DIVISION_ID = B.DIVISION_ID
                     AND A.SCM_SITE_ID = B.SCM_SITE_ID
                   INNER JOIN DM_MST_ITEM_SINGLE_V C
    ON A.DIVISION_ID = C.DIVISION_ID
                     AND A.ITEM_ID = C.ITEM_ID
                     --AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                   LEFT JOIN (
                            SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
                            FROM SCM_MST_SSO_USER_INFO B
                            INNER JOIN SCM_MST_SSO_DEPT_INFO C
                            ON B.DEPT_ID = C.DEPT_ID
                            INNER JOIN SCM_MST_SSO_DEPT_INFO D
                            ON C.UPPER_DEPT_ID = D.DEPT_ID
                        ) AS TEAM
                        ON TEAM.USER_ID IN (SELECT column_value FROM TABLE(SCM_MGR.FN_SPLIT_STR(I.OWNER, ',')))
             WHERE A.DIVISION_ID = p_division_id
               AND A.VERSION_NO = p_version_no
               AND A.YYYYMMDD LIKE (SELECT YYYY FROM DM_MST_CONTRIBUTE_VER  WHERE VER_SEQ = p_ver_seq)+'%'
             GROUP BY SUBSTR(A.YYYYMMDD,1,6)
                 , TEAM.DEPARTMENT_ID
                 , TEAM.DEPARTMENT_NAME
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO
                 , NVL(I.REPORT_GROUP2, NULL)
                 , NVL(I.ATTRIBUTE2, NULL)
                 , NVL(I.ATTRIBUTE1, NULL)
                 , NVL(SC.SHIPTO_CODE, NULL)
                 , NVL(I.REPORT_GROUP3, NULL)
                 , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)*/
                 ) A;
    
    
        -- TODO: CURSOR-->BULK COLLECT 변환 필요
        -- c_code CURSOR FAST_FORWARD FOR
    FETCH FIRST 1 ROWS ONLY
    	SELECT DISTINCT CODE, LARGE_CODE, SMALL_CODE, SEQ
    	FROM (
    		SELECT
    			  L.SEGMENT1 + '#'  ||  CASE WHEN L.SEGMENT4 = 'Y' THEN '' ELSE M.SEGMENT1 END AS CODE
    			, L.SEGMENT1  AS LARGE_CODE
    			, CASE WHEN L.SEGMENT4 = 'Y' THEN L.SEGMENT1 ELSE M.SEGMENT1 END AS SMALL_CODE
    			, RANK() OVER ( ORDER BY L.DISPLAY_SEQ, CASE WHEN L.SEGMENT4 = 'Y' THEN 0 ELSE M.DISPLAY_SEQ END ) AS SEQ
    		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL L
    			,  SCM_ADM_LOOKUP_MASTER_DETAIL M
    		WHERE  1 = 1
    		AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'
    		AND    M.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'
    		AND    L.VALID_YN    = 'Y'
    		AND    L.SEGMENT3    = 'Y'
    		AND    M.VALID_YN    = 'Y'
    		) A;
        ORDER BY A.SEQ;
    
    
        v_sql_text := ';
    WITH SALES_LIST AS (
        SELECT A.YYYYMM
             , A.DEPARTMENT_NAME
             , A.DEPT_NAME
             , A.DEPARTMENT_ID
             , A.DEPT_ID
           , A.CUST_REPORT
             , A.END_CUST_REPORT
             , A.SOLDTO_CUST_REPORT
             , A.SHIPTO_CODE
             , A.PRODUCT_GROUP
             , A.DM_BIZ_TYPE
    		 , A.EDIT_FLAG '
        FROM DUAL;
    
        OPEN c_code;
        FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq; -- v_seq 는 사용하지 않음. 커서문에서 distinct 를 넣기 위해 사용
        WHILE v_fetch_status = 0 LOOP
            v_sql_text := v_sql_text  ||  '
             , SUM(CASE WHEN NVL(B.CONTRIBUTION_RATIO,0) > 0 AND B.CONTRIBUTION_TYPE = '''  ||  v_small_code  ||  ''' AND B.OS_CORP_CD = '''  ||  v_large_code  ||  '''
                             THEN B.CONTRIBUTION_RATIO/100*A.AMT
                        ELSE 0
                   END) AS '  ||  v_code  ||  ' ';
    
    --select v_code
    
    		-- 행별합계
    		IF v_code NOT LIKE '%Total%' THEN
    			v_col_Sum := v_col_Sum  ||  ', SUM(' || v_code || ') AS '  ||  v_code;
    			v_bottom_Sum := v_bottom_Sum  ||  ', SUM(' || v_code || ') AS '  ||  v_code;
    		END IF;
    		END LOOP;
    
    		---- 컬럼합계 ( Total )
    		IF v_code NOT LIKE '%Total%' THEN
    			v_col_Total := v_col_Total  ||   CASE WHEN v_col_Total = '' THEN '' ELSE ' +' END  ||  'NVL(SUM('  ||  v_code  ||  '), 0)';
    		ELSE  -- Total 컬럼에서는 AS 를 붙여서 마무리
    			v_col_Total := v_col_Total  ||  ' AS '  ||  v_code
    
    -- select v_col_Sum as v_sum_column, v_code as v_code, v_col_Total, v_ttsum_column_com
    
            FETCH c_code INTO v_code, v_large_code, v_small_code, v_seq;
        END IF;
    
        CLOSE c_code;
        DEALLOCATE c_code;
    
    
        v_sql_text := v_sql_text  ||  '
          FROM GT_DMF0_sales_list_c A
    INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
                  ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
                 AND A.DEPT_ID = B.DEPT_ID
                 AND A.END_CUST_REPORT = B.END_CUST_REPORT
                 AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
                 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
                 AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
                 AND A.YYYYMM = B.YYYYMM
         WHERE B.VER_SEQ = '  ||  p_ver_seq  ||  ';
         v_end_cust_report
         v_product_group
         v_biz_type
         ';
    
         v_sql_text := v_sql_text  ||  '
         GROUP BY A.YYYYMM
             , A.DEPARTMENT_NAME
             , A.DEPT_NAME
             , A.DEPARTMENT_ID
             , A.DEPT_ID
             , A.CUST_REPORT
             , A.END_CUST_REPORT
             , A.SOLDTO_CUST_REPORT
             , A.SHIPTO_CODE
             , A.PRODUCT_GROUP
             , A.DM_BIZ_TYPE
    		 , A.EDIT_FLAG
    )
    
    SELECT v_col  v_col_Sum,'  ||  v_col_Total  ||  '
    FROM   SALES_LIST A;
    v_groupby
    UNION ALL	--합계행
    SELECT v_bottom v_bottom_Sum,'  ||  v_col_Total  ||  '
    FROM   SALES_LIST A;
    v_orderby
    ';
    
    
    --    v_sql_text := REPLACE(v_sql_text,'v_end_cust_report'  , FN_SCM_GET_WHERE_SQL('A.END_CUST_REPORT'  , 'IN', p_end_cust_report));
        v_sql_text := REPLACE(v_sql_text,'v_end_cust_report'  , ' AND A.END_CUST_REPORT LIKE ''%'  ||  p_end_cust_report  ||  '%'' ');
        v_sql_text := REPLACE(v_sql_text,'v_product_group'  , FN_SCM_GET_WHERE_SQL('A.PRODUCT_GROUP'  , 'IN', p_product_group));
        v_sql_text := REPLACE(v_sql_text,'v_biz_type'  , FN_SCM_GET_WHERE_SQL('A.DM_BIZ_TYPE'  , 'IN', p_biz_type));
        v_sql_text := REPLACE(v_sql_text,'v_col'  , v_col);
    	v_sql_text := REPLACE(v_sql_text,'v_bottom'  , v_bottom);
        v_sql_text := REPLACE(v_sql_text,'v_col_Sum'  , v_col_Sum);
     --   v_sql_text := REPLACE(v_sql_text,'v_col_Sum'  , v_col_Sum);
     --   v_sql_text := REPLACE(v_sql_text,'v_col_Sum'  , v_col_Sum);
        v_sql_text := REPLACE(v_sql_text,'v_bottom_Sum'  , v_bottom_Sum);
        v_sql_text := REPLACE(v_sql_text,'v_groupby'  , v_groupby);
        v_sql_text := REPLACE(v_sql_text,'v_orderby'  , v_orderby);
    
        --select v_col;
        --select v_sql_text;
        --return;
        SP_EXECUTESQL v_sql_text;
        SP_EXECUTESQL v_nsql2;
    
        IF NVL(p_compatibility_yn,'') = 'Y' THEN
            SELECT
                -- 등록이 안된 건 count
                (SELECT COUNT(*)
                  FROM (SELECT TEAM.DEPARTMENT_ID
                             , TEAM.DEPT_ID AS DEPT_ID
                             , NVL(A.ATTRIBUTE2, NULL) AS END_CUST_REPORT
                             , NVL(A.ATTRIBUTE1, NULL) AS SOLDTO_CUST_REPORT
                             , NVL(A.REPORT_GROUP3, NULL) AS PRODUCT_GROUP
                             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) AS DM_BIZ_TYPE
                          FROM SCM_MST_SITE_ITEM A
                               INNER JOIN SCM_MST_SITE B
                                  ON A.DIVISION_ID = B.DIVISION_ID
                                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
                               INNER JOIN DM_MST_ITEM_SINGLE_V C
                                  ON A.DIVISION_ID = C.DIVISION_ID
                                 AND A.ITEM_ID = C.ITEM_ID
                               LEFT JOIN (
                                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                                             , D.DEPT_ID AS DEPARTMENT_ID, D.DEPT_NAME_KO AS DEPARTMENT_NAME
                                          FROM SCM_MST_SSO_USER_INFO B
                                               INNER JOIN SCM_MST_SSO_DEPT_INFO C
                                                  ON B.DEPT_ID = C.DEPT_ID
                                               INNER JOIN SCM_MST_SSO_DEPT_INFO D
                      ON C.UPPER_DEPT_ID = D.DEPT_ID
                                         ) AS TEAM
                                  ON TEAM.USER_ID IN (SELECT column_value FROM TABLE(SCM_MGR.FN_SPLIT_STR(A.OWNER, ',')))
                         WHERE A.DIVISION_ID = p_division_id
                           AND B.SITE_TYPE = 'SALES'
                           AND NVL(C.FORECAST_INFO_BIZ_TYPE, NULL) IS NOT NULL
                           AND NVL(A.ATTRIBUTE2, NULL) IS NOT NULL
                           AND NVL(A.ATTRIBUTE1, NULL) IS NOT NULL
                           AND NVL(A.REPORT_GROUP3, NULL) IS NOT NULL
                         GROUP BY A.DIVISION_ID
                             , TEAM.DEPARTMENT_ID
                             , TEAM.DEPT_ID
                             , NVL(A.ATTRIBUTE2, NULL)
                             , NVL(A.ATTRIBUTE1, NULL)
                             , NVL(A.REPORT_GROUP3, NULL)
                             , NVL(C.FORECAST_INFO_BIZ_TYPE, NULL)
                       ) LIST;
                      LEFT OUTER JOIN DM_MST_CONTRIBUTE_RATIO_MST RATIO
                        ON LIST.DEPARTMENT_ID = RATIO.DEPARTMENT_ID
                       AND LIST.DEPT_ID = RATIO.DEPT_ID
                       AND LIST.END_CUST_REPORT = RATIO.END_CUST_REPORT
                       AND LIST.SOLDTO_CUST_REPORT = RATIO.SOLDTO_CUST_REPORT
                       AND LIST.PRODUCT_GROUP = RATIO.PRODUCT_GROUP
                       AND LIST.DM_BIZ_TYPE = RATIO.DM_BIZ_TYPE
                 WHERE RATIO.DEPARTMENT_ID IS NULL
                   AND RATIO.VER_SEQ = p_ver_seq)
                    ||
                -- 100%가 안되는 건 COUNT
                (SELECT COUNT(*)
                  FROM (SELECT SUM(A.CONTRIBUTION_RATIO) AS RATIO
                          FROM DM_MST_CONTRIBUTE_RATIO_MST M
                               INNER JOIN DM_MST_CONTRIBUTE_RATIO_DTL A
                                  ON M.VER_SEQ = A.VER_SEQ
                                 AND M.DEPARTMENT_ID = A.DEPARTMENT_ID
                                 AND M.DEPT_ID = A.DEPT_ID
                                 AND M.END_CUST_REPORT = A.END_CUST_REPORT
                                 AND M.SOLDTO_CUST_REPORT = A.SOLDTO_CUST_REPORT
                                 AND M.PRODUCT_GROUP = A.PRODUCT_GROUP
                                 AND M.DM_BIZ_TYPE = A.DM_BIZ_TYPE
                         WHERE A.VER_SEQ = p_ver_seq
                         GROUP BY A.DEPARTMENT_ID
                                , A.DEPT_ID
                                , A.END_CUST_REPORT
                                , A.SOLDTO_CUST_REPORT
                                , A.PRODUCT_GROUP
                                , A.DM_BIZ_TYPE
                                , A.YYYYMM
                       ) R;
                 WHERE R.RATIO <> 100)
    			 ||
    			(
    FETCH FIRST 1 ROWS ONLY
    			 SELECT COUNT(*)
    			  FROM GT_DMF0_sales_list_c A
    			left outer JOIN DM_MST_CONTRIBUTE_RATIO_DTL B
    						  ON A.DEPARTMENT_ID = B.DEPARTMENT_ID
    						 AND A.DEPT_ID = B.DEPT_ID
    						 AND A.END_CUST_REPORT = B.END_CUST_REPORT
    						 AND A.SOLDTO_CUST_REPORT = B.SOLDTO_CUST_REPORT
    						 AND A.PRODUCT_GROUP = B.PRODUCT_GROUP
    						 AND A.DM_BIZ_TYPE = B.DM_BIZ_TYPE
    						 AND A.YYYYMM = B.YYYYMM
    						 and B.VER_SEQ = 2
    				 WHERE A.END_CUST_REPORT LIKE '%%'
    				  and b.dept_id is null
    				) AS CNT;
        ELSE
            SELECT 0 AS CNT
            FROM DUAL;
        END IF;
    
    -- --xml확인할경우
    --SELECT CAST(v_sql_text AS TEXT)
    --FOR XML PATH('')--,ROOT('x')
    
    
     /*
    select max(version_no) from dm_pln_sales_plan_c ;
    
    select * from DM_MST_CONTRIBUTE_VER where version_no = 'SP_W_20190905_V001'
    
    
    DMF0043_GET_CONTRIBUTION_SALES_LIST
    p_division_id='40',
    p_ver_seq='19',
    p_version_no='SP_W_20190905_V001',
    p_end_cust_report='',
    p_product_group='ALL',
    p_biz_type='ALL',
    p_million_yn='',
    p_compatibility_yn='',
    p_created_by='hwi1993'
    
    
    DMF0043_GET_CONTRIBUTION_SALES_LIST
        p_division_id = '40',
        p_ver_seq = 1,
        p_version_no = 'SP_W_20190905_V001',
        p_end_cust_report IS NULL,
        p_product_group   IS NULL,
        p_biz_type         IS NULL,
        p_million_yn       = '',
        p_compatibility_yn = 'Y',
        p_created_by       = 'hwi1993'
    
     */
    
     END P_DMF0043_GET_CONTRIBUTION_SALES_LIST;

    END PKG_DMF0043;
/
