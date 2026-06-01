/*=============================================================================================
 * File         : 04_Package_PKG_SCM0002.sql
 * Description  : Package — PKG_SCM0002
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

CREATE OR REPLACE PACKAGE SCM_MGR.PKG_SCM0002 IS
/*
 * Program ID   : PKG_SCM0002
 * Description  : PKG_SCM0002
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.24   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 *                          UI 항목으로 Package로 전환
 */

    PROCEDURE P_SCM0002_GET_BOD_FG_POPUP
    (
        P_DIVISION_ID          IN VARCHAR2,
        P_BOD_ID               IN VARCHAR2,
        P_FROM_SITE            IN VARCHAR2,
        P_TO_SITE              IN VARCHAR2,
        P_PLAN_START_YYYYMMDD  IN DATE,
        P_OPER_GRP             IN VARCHAR2,
        P_ITEM_ID              IN VARCHAR2,
        P_ORIGION_DIVISION_ID  IN VARCHAR2 DEFAULT '',
        DEBUG_MODE             IN VARCHAR2 DEFAULT 'F',
        O_RC1                  OUT SYS_REFCURSOR,
        O_RESULT_CURSOR        OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_BOD_SEMI_POPUP
    (
        P_DIVISION_ID          IN VARCHAR2,
        P_BOD_ID               IN VARCHAR2,
        P_FROM_SITE            IN VARCHAR2,
        P_TO_SITE              IN VARCHAR2,
        P_PLAN_START_YYYYMMDD  IN DATE,
        P_OPER_GRP             IN VARCHAR2,
        P_ITEM_ID              IN VARCHAR2,
        P_ORIGION_DIVISION_ID  IN VARCHAR2 DEFAULT '',
        DEBUG_MODE             IN VARCHAR2 DEFAULT 'F',
        O_RC1                  OUT SYS_REFCURSOR,
        O_RESULT_CURSOR        OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_CAPACITY_ALLOCATION_POPUP
    (
        --chaan	@p_division_id	NVARCHAR(2),
        P_DIVISION_ID   IN VARCHAR2,  --chaan
        P_ACTION_FLAG   IN VARCHAR2 DEFAULT '',
        P_ITEM_ID       IN VARCHAR2 DEFAULT '',
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_CITY_BY_COUNTY_POPUP
    (
        P_COUNTRY       IN VARCHAR2,
        P_CITY          IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SOLDTO_CODE   IN VARCHAR2,
        P_SHIPTO_CODE   IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_DEPARTMENT_POPUP
    (
        P_DEPARTMENT    IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_ITEM_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_SCM_SITE_ID   IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SCM_SITE_ID   IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        P_ASSIGN_YN     IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_ITEM_BY_SITE_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SCM_SITE_ID   IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_ITEM_ELEC
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_COMPANY_ID    IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_LOCATION_BY_DIVISION_POPUP
    (
        P_DIVISION_ID    IN VARCHAR2,
        P_SCM_SITE_ID    IN VARCHAR2,
        P_LOCATION_CODE  IN VARCHAR2,
        O_RC1            OUT SYS_REFCURSOR,
        O_RESULT_CURSOR  OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_MATERIAL_BY_DIVISION
    (
        P_DIVISION_ID        IN VARCHAR2,
        P_OPERATION_GROUP    IN VARCHAR2,
        P_ITEM_ID            IN VARCHAR2,
        P_SCP_MODULE_TYPE    IN VARCHAR2,
        O_RC1                OUT SYS_REFCURSOR,
        O_RESULT_CURSOR      OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_PLANT_CUSTOMER_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SOLDTO_CODE   IN VARCHAR2,
        P_SHIPTO_CODE   IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_DEPT_ID       IN VARCHAR2,   --Department
        P_END_CUSTOMER  IN VARCHAR2,   --Endcustomer
        P_SCM_SITE_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_ETC           IN VARCHAR2 DEFAULT NULL,  -- [PJ20200138] ETC Flag 추가
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK
    (
        P_DIVISION_ID          IN VARCHAR2,
        P_PLAN_START_YYYYMMDD  IN VARCHAR2,
        P_PLAN_TYPE            IN VARCHAR2,
        P_SEQ                  IN VARCHAR2,
        P_OPERATION_GROUP      IN VARCHAR2,
        P_PROJECT_CODE         IN VARCHAR2,
        P_ITEM_ID              IN VARCHAR2,
        P_TO_SITE              IN VARCHAR2,
        P_INCOTERMS            IN VARCHAR2,
        P_FROM_SITE            IN VARCHAR2,
        P_BOD_ID               IN VARCHAR2,
        P_TRANSPORT_MODE       IN VARCHAR2,
        P_PRGRAM_ID            IN VARCHAR2,
        O_RC1                  OUT SYS_REFCURSOR,
        O_RESULT_CURSOR        OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_SITE_ITEM_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_PROJECT_CODE  IN VARCHAR2,
        P_SCM_SITE_ID   IN VARCHAR2,
        P_ITEM_ID       IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_SOLDTO_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_SOLDTO_CODE   IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_STORAGE_BY_DIVISION_POPUP
    (
        P_DIVISION_ID   IN VARCHAR2,
        P_STORAGE_ID    IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_TEAM_POPUP
    (
        P_TEAM_ID     IN VARCHAR2,
        P_TEAM_NAME   IN VARCHAR2,
        P_CREATED_BY  IN VARCHAR2,
        P_USERINFO    IN VARCHAR2,
        O_RC1         OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_VENDOR_POPUP
    (
        P_VENDOR_CODE   IN VARCHAR2,
        P_VENDOR_NAME   IN VARCHAR2,
        P_PAKER         IN VARCHAR2,
        O_RC1           OUT SYS_REFCURSOR,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_GET_VERSIONBYWATERFALLPOPUP
    (
        P_START_YYYYMMDD  IN VARCHAR2,
        P_END_YYYYMMDD    IN VARCHAR2,
        P_CREATED_BY      IN VARCHAR2,
        P_DIVISION_ID     IN VARCHAR2,
        P_VERSION_TYPE    IN VARCHAR2,
        P_VERSION_NO      IN VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_SET_DEFAULT_TITLESET_POPUP
    (
        P_PROGRAM_ID    IN VARCHAR2,
        P_SHEET_NAME    IN VARCHAR2,
        P_COLUMN_TYPE   IN VARCHAR2,
        P_USER_ID       IN VARCHAR2,
        O_RESULT_CURSOR OUT SYS_REFCURSOR
    );

    PROCEDURE P_SCM0002_SET_TITLESET_POPUP
    (
        P_PROGRAM_ID        IN VARCHAR2,
        P_SHEET_NAME        IN VARCHAR2,
        P_COLUMN_TYPE       IN VARCHAR2,
        P_ACTIVE_FLAG       IN VARCHAR2,
        P_COLUMN_NAME       IN VARCHAR2,
        P_SORT_ORDER_NO     IN VARCHAR2,
        P_SUB_TOTAL_FLAG    IN VARCHAR2,
        P_SORT_METHOD_CODE  IN VARCHAR2,
        P_USER_ID           IN VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCM0002;
/


-- ====== PACKAGE BODY ======

CREATE OR REPLACE PACKAGE BODY SCM_MGR.PKG_SCM0002 IS


/* ============================================================
   1. P_SCM0002_GET_BOD_FG_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_BOD_FG_POPUP
(
    P_DIVISION_ID          IN VARCHAR2,
    P_BOD_ID               IN VARCHAR2,
    P_FROM_SITE            IN VARCHAR2,
    P_TO_SITE              IN VARCHAR2,
    P_PLAN_START_YYYYMMDD  IN DATE,
    P_OPER_GRP             IN VARCHAR2,
    P_ITEM_ID              IN VARCHAR2,
    P_ORIGION_DIVISION_ID  IN VARCHAR2 DEFAULT '',
    DEBUG_MODE             IN VARCHAR2 DEFAULT 'F',
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SCM0002_GET_BOD_POPUP
 * Description  : BOD Popup 조회
  * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/15   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/24   KYH            ITEM_ID , OPERATION GROUP 추가
 * 2018/05/29   KYH            중복되는 값 없애기위해 distinct 추가
 * 2018/09/05   ygkim          @p_origion_division_id 추가
 * 2021/07/07   khj79          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022.05.13   LSC            PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2026.03.24   kimcd          [PJ20264226] NextSCM Pilot 설계 및 개발
 */

    -- first : to site
    -- second : from site

    $$PLSQL_UNIT  VARCHAR2(200 CHAR);
    V_PLAN_START_DATE  VARCHAR2(8 CHAR);
    V_MDQRY            VARCHAR2(32767 CHAR) := '';
    V_POS              PLS_INTEGER;
    V_LEN              PLS_INTEGER;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    V_PLAN_START_DATE := TO_CHAR(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');

    V_MDQRY := V_MDQRY || ' SELECT DISTINCT                                                                                                 ' || CHR(10);
    V_MDQRY := V_MDQRY || '     '''' AS CHK                                                                                                 ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , '''' AS IS_LOCK                                                                                           ' || CHR(10);
    --SET @mDQry = @mDQry + '   , (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE + m.transport_mode) as key_idx                               ' + char(10) ;
    IF P_DIVISION_ID = 'EE_UC' THEN
        V_MDQRY := V_MDQRY || '     , (''EE_UC'' || M.FROM_SITE || M.TO_SITE || M.TRANSPORT_MODE || M.BOD_ID) AS KEY_IDX                   ' || CHR(10);
    ELSIF P_DIVISION_ID = 'EE' THEN
        V_MDQRY := V_MDQRY || '     , (''EE'' || M.FROM_SITE || M.TO_SITE || M.TRANSPORT_MODE || M.BOD_ID) AS KEY_IDX                      ' || CHR(10);
    ELSE
        V_MDQRY := V_MDQRY || '     , (M.DIVISION_ID || M.FROM_SITE || M.TO_SITE || M.TRANSPORT_MODE || M.BOD_ID) AS KEY_IDX               ' || CHR(10);
    END IF;

    V_MDQRY := V_MDQRY || '     , M.BOD_ID                                                                                                 ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.TO_SITE   AS FIRST_SITE                                                                                ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , SCM_MGR.FN_GET_SCM_SITE_DESCRIPTION(M.DIVISION_ID, M.TO_SITE)   AS FIRST_SITE_NAME                      ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.FROM_SITE AS SECOND_SITE                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , SCM_MGR.FN_GET_SCM_SITE_DESCRIPTION(M.DIVISION_ID, M.FROM_SITE) AS SECOND_SITE_NAME                     ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.PRIORITY                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.INCOTERMS                                                                                              ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.TRANSPORT_MODE                                                                                         ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_MON                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_TUE                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_WED                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_THU                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_FRI                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_SAT                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_SUN                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.LT_TOTAL                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , TO_DATE(''' || V_PLAN_START_DATE || ''', ''YYYYMMDD'')                                                   ' || CHR(10);
    V_MDQRY := V_MDQRY || '       + NVL((SELECT SHIP_FROZEN FROM SCM_MGR.SCM_MST_SITE                                                      ' || CHR(10);
    V_MDQRY := V_MDQRY || '              WHERE DIVISION_ID = M.DIVISION_ID AND SCM_SITE_ID = FROM_SITE), 0)  AS SHIP_FROZEN                ' || CHR(10);
    --IF @p_division_id != 'EE'
    --  BEGIN SET @mDQry = @mDQry + '       where division_id='''+@p_division_id+''' and scm_site_id= from_site)                            ' + char(10) ; END
    --ELSE
    --  BEGIN SET @mDQry = @mDQry + '       where division_id='''+@p_origion_division_id+''' and scm_site_id= from_site)                    ' + char(10) ; END
    -- BOD 2단계 개발 : 시작
    V_MDQRY := V_MDQRY || '     , TO_DATE(M.FROM_YYYYMMDD, ''YYYYMMDD'') AS FROM_YYYYMMDD                                                  ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , TO_DATE(M.TO_YYYYMMDD,   ''YYYYMMDD'') AS TO_YYYYMMDD                                                    ' || CHR(10);
    --SET @mDQry = @mDQry + ' FROM scp_mst_bod_v m  WITH(NOLOCK)                                                                            ' + char(10) ;
    V_MDQRY := V_MDQRY || ' FROM SCM_MGR.SCP_MST_BOD_N_V M                                                                                 ' || CHR(10);
    -- BOD 2단계 개발 : 끝
    V_MDQRY := V_MDQRY || ' INNER JOIN SCM_MGR.SCM_MST_SITE S                                                                              ' || CHR(10);
    V_MDQRY := V_MDQRY || '     ON M.DIVISION_ID = S.DIVISION_ID AND M.FROM_SITE = S.SCM_SITE_ID                                           ' || CHR(10);
    V_MDQRY := V_MDQRY || ' INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM_PRIORITY P                                                                ' || CHR(10);
    V_MDQRY := V_MDQRY || '     ON M.DIVISION_ID = P.DIVISION_ID AND P.ITEM_ID = ''' || P_ITEM_ID || '''                                   ' || CHR(10);
    V_MDQRY := V_MDQRY || ' WHERE 1 = 1                                                                                                    ' || CHR(10);

    IF P_DIVISION_ID = 'EE' THEN
        V_MDQRY := V_MDQRY || ' AND M.DIVISION_ID IN (''40'',''81'',''82'')                                                                ' || CHR(10);
    ELSIF P_DIVISION_ID = 'EE_UC' THEN
        V_MDQRY := V_MDQRY || ' AND M.DIVISION_ID = ''81_UC''                                                                              ' || CHR(10);
    ELSE
        V_MDQRY := V_MDQRY || ' AND M.DIVISION_ID = ''' || P_DIVISION_ID || '''                                                            ' || CHR(10);
    END IF;

    V_MDQRY := V_MDQRY || ' AND M.TO_SITE = ''' || P_TO_SITE || '''                                                                        ' || CHR(10);
    V_MDQRY := V_MDQRY || ' --and m.bod_id = @p_bod_id                                                                                     ' || CHR(10);
    V_MDQRY := V_MDQRY || ' AND S.OPERATION_GROUP = ''' || P_OPER_GRP || '''                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || ' ORDER BY TO_SITE ASC, FROM_SITE ASC                                                                            ' || CHR(10);

    IF DEBUG_MODE = 'T' THEN
        V_POS := 1;
        V_LEN := LENGTH(V_MDQRY);
        WHILE V_POS <= V_LEN LOOP
            DBMS_OUTPUT.PUT_LINE(SUBSTR(V_MDQRY, V_POS, 4000));
            V_POS := V_POS + 4000;
        END LOOP;
    END IF;

    OPEN O_RC1 FOR V_MDQRY;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE P_DIVISION_ID,
            'P_BOD_ID'              VALUE P_BOD_ID,
            'P_FROM_SITE'           VALUE P_FROM_SITE,
            'P_TO_SITE'             VALUE P_TO_SITE,
            'P_PLAN_START_YYYYMMDD' VALUE TO_CHAR(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'),
            'P_OPER_GRP'            VALUE P_OPER_GRP,
            'P_ITEM_ID'             VALUE P_ITEM_ID,
            'P_ORIGION_DIVISION_ID' VALUE P_ORIGION_DIVISION_ID,
            'DEBUG_MODE'            VALUE DEBUG_MODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_BOD_FG_POPUP;



/* ============================================================
   2. P_SCM0002_GET_BOD_SEMI_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_BOD_SEMI_POPUP
(
    P_DIVISION_ID          IN VARCHAR2,
    P_BOD_ID               IN VARCHAR2,
    P_FROM_SITE            IN VARCHAR2,
    P_TO_SITE              IN VARCHAR2,
    P_PLAN_START_YYYYMMDD  IN DATE,
    P_OPER_GRP             IN VARCHAR2,
    P_ITEM_ID              IN VARCHAR2,
    P_ORIGION_DIVISION_ID  IN VARCHAR2 DEFAULT '',
    DEBUG_MODE             IN VARCHAR2 DEFAULT 'F',
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_BOD_POPUP
 * Description  : BOD Popup 조회
  * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/15   byunghunjung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05      KYH             ITEM_ID , OPERATION GROUP 추가
 * 2018/05/29 KYH           중복되는 값 없애기위해 distinct 추가
 * 2018/09/05   ygkim       @p_origion_division_id 추가, from_site 조건 제거, @p_oper_grp 조건 추가
 * 2021/07/07   khj79       PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
 * 2022.05.13   LSC             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2026.03.24   kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발
 */

    -- first : from site
    -- second : to site

    $$PLSQL_UNIT     VARCHAR2(200 CHAR);
    V_PLAN_START_DATE  VARCHAR2(8 CHAR);
    V_MDQRY            VARCHAR2(32767 CHAR) := '';
    V_POS              PLS_INTEGER;
    V_LEN              PLS_INTEGER;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    V_PLAN_START_DATE := TO_CHAR(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');

    V_MDQRY := V_MDQRY || ' SELECT DISTINCT                                                                                                 ' || CHR(10);
    V_MDQRY := V_MDQRY || '     '''' AS CHK                                                                                                 ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , '''' AS IS_LOCK                                                                                           ' || CHR(10);
    --SET @mDQry = @mDQry + '   , (m.DIVISION_ID + m.FROM_SITE + m.TO_SITE + m.transport_mode) as key_idx                               ' + char(10) ;
    IF P_DIVISION_ID IN ('EE', 'EE_UC') THEN
        V_MDQRY := V_MDQRY || '     , (''' || P_DIVISION_ID || ''' || M.FROM_SITE || M.TO_SITE || M.TRANSPORT_MODE || M.BOD_ID) AS KEY_IDX  ' || CHR(10); -- BOD 2단계 개발 : BOD_ID 추가
    ELSE
        V_MDQRY := V_MDQRY || '     , (M.DIVISION_ID || M.FROM_SITE || M.TO_SITE || M.TRANSPORT_MODE || M.BOD_ID) AS KEY_IDX                ' || CHR(10); -- BOD 2단계 개발 : BOD_ID 추가
    END IF;

    V_MDQRY := V_MDQRY || '     , M.BOD_ID                                                                                                 ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.FROM_SITE AS FIRST_SITE                                                                                ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , SCM_MGR.FN_GET_SCM_SITE_DESCRIPTION(M.DIVISION_ID, M.FROM_SITE) AS FIRST_SITE_NAME                      ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.TO_SITE   AS SECOND_SITE                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , SCM_MGR.FN_GET_SCM_SITE_DESCRIPTION(M.DIVISION_ID, M.TO_SITE)   AS SECOND_SITE_NAME                     ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.PRIORITY                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.INCOTERMS                                                                                              ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.TRANSPORT_MODE                                                                                         ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_MON                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_TUE                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_WED                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_THU                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_FRI                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_SAT                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.DAYS_SUN                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , M.LT_TOTAL                                                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , CASE WHEN SUBSTR(M.FROM_SITE, 1, 4) = SUBSTR(M.TO_SITE, 1, 4) THEN                                       ' || CHR(10);
    V_MDQRY := V_MDQRY || '           TO_DATE(''' || V_PLAN_START_DATE || ''', ''YYYYMMDD'')                                                ' || CHR(10);

    IF P_DIVISION_ID NOT IN ('EE', 'EE_UC') THEN
        V_MDQRY := V_MDQRY || '           + NVL((SELECT NVL(SHIP_FROZEN, 0) FROM SCM_MGR.SCM_MST_SITE WHERE DIVISION_ID = ''' || P_DIVISION_ID || ''' AND SCM_SITE_ID = FROM_SITE), 0)   ' || CHR(10);
    ELSE
        V_MDQRY := V_MDQRY || '           + NVL((SELECT NVL(SHIP_FROZEN, 0) FROM SCM_MGR.SCM_MST_SITE WHERE DIVISION_ID = ''' || P_ORIGION_DIVISION_ID || ''' AND SCM_SITE_ID = FROM_SITE), 0)   ' || CHR(10);
    END IF;

    V_MDQRY := V_MDQRY || '       ELSE                                                                                                     ' || CHR(10);
    -- @@DATEFIRST - DATEPART(dw, GETDATE()) - 5 → Oracle: TRUNC(SYSDATE, 'IW') (직전 월요일)
    V_MDQRY := V_MDQRY || '           (TRUNC(SYSDATE, ''IW'') )                                                                         ' || CHR(10);
    V_MDQRY := V_MDQRY || '       END AS SHIP_FROZEN                                                                                        ' || CHR(10);
    -- BOD 2단계 개발 : 시작
    V_MDQRY := V_MDQRY || '     , TO_DATE(M.FROM_YYYYMMDD, ''YYYYMMDD'') AS FROM_YYYYMMDD                                                  ' || CHR(10);
    V_MDQRY := V_MDQRY || '     , TO_DATE(M.TO_YYYYMMDD,   ''YYYYMMDD'') AS TO_YYYYMMDD                                                    ' || CHR(10);
    --SET @mDQry = @mDQry + ' FROM scp_mst_bod_v m  WITH(NOLOCK)                                                                            ' + char(10) ;
    V_MDQRY := V_MDQRY || ' FROM SCM_MGR.SCP_MST_BOD_N_V M                                                                                 ' || CHR(10);
    -- BOD 2단계 개발 : 끝
    V_MDQRY := V_MDQRY || ' INNER JOIN SCM_MGR.SCM_MST_SITE_ITEM_PRIORITY P                                                                ' || CHR(10);
    V_MDQRY := V_MDQRY || '     ON M.DIVISION_ID = P.DIVISION_ID AND P.ITEM_ID = ''' || P_ITEM_ID || '''                                   ' || CHR(10);
    V_MDQRY := V_MDQRY || ' INNER JOIN SCM_MGR.SCM_MST_SITE S                                                                              ' || CHR(10);
    V_MDQRY := V_MDQRY || '     ON S.DIVISION_ID = M.DIVISION_ID AND S.SCM_SITE_ID = M.FROM_SITE AND S.VALID_YN = ''Y''                    ' || CHR(10);
    V_MDQRY := V_MDQRY || ' WHERE 1 = 1                                                                                                    ' || CHR(10);

    IF P_DIVISION_ID NOT IN ('EE', 'EE_UC') THEN
        V_MDQRY := V_MDQRY || ' AND M.DIVISION_ID = ''' || P_DIVISION_ID || '''                                                            ' || CHR(10);
    ELSE
        V_MDQRY := V_MDQRY || ' AND M.DIVISION_ID = ''' || P_ORIGION_DIVISION_ID || '''                                                    ' || CHR(10);
    END IF;

    --AND m.from_site = @p_from_site
    V_MDQRY := V_MDQRY || ' AND M.BOD_TYPE = ''PLANT''                                                                                     ' || CHR(10);
    V_MDQRY := V_MDQRY || ' AND S.OPERATION_GROUP = ''' || P_OPER_GRP || '''                                                               ' || CHR(10);
    V_MDQRY := V_MDQRY || ' AND M.TO_SITE = ''' || P_TO_SITE || '''                                                                        ' || CHR(10);
    V_MDQRY := V_MDQRY || ' ORDER BY FROM_SITE ASC, TO_SITE ASC                                                                            ' || CHR(10);

    IF DEBUG_MODE = 'T' THEN
        V_POS := 1;
        V_LEN := LENGTH(V_MDQRY);
        WHILE V_POS <= V_LEN LOOP
            DBMS_OUTPUT.PUT_LINE(SUBSTR(V_MDQRY, V_POS, 4000));
            V_POS := V_POS + 4000;
        END LOOP;
    END IF;

    OPEN O_RC1 FOR V_MDQRY;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE P_DIVISION_ID,
            'P_BOD_ID'              VALUE P_BOD_ID,
            'P_FROM_SITE'           VALUE P_FROM_SITE,
            'P_TO_SITE'             VALUE P_TO_SITE,
            'P_PLAN_START_YYYYMMDD' VALUE TO_CHAR(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'),
            'P_OPER_GRP'            VALUE P_OPER_GRP,
            'P_ITEM_ID'             VALUE P_ITEM_ID,
            'P_ORIGION_DIVISION_ID' VALUE P_ORIGION_DIVISION_ID,
            'DEBUG_MODE'            VALUE DEBUG_MODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_BOD_SEMI_POPUP;


/* ============================================================
   3. P_SCM0002_GET_CAPACITY_ALLOCATION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_CAPACITY_ALLOCATION_POPUP
(
    --chaan   @p_division_id    NVARCHAR(2),
    P_DIVISION_ID   IN VARCHAR2,  --chaan
    P_ACTION_FLAG   IN VARCHAR2 DEFAULT '',
    P_ITEM_ID       IN VARCHAR2 DEFAULT '',
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : P_SCM0002_GET_CAPACITY_ALLOCATION_POPUP
 * Description  : Capacity Allocation 입력/삭제 대상목록 조회
 * Program History

 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2018/08/24   YHW             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/09/05   YHW             조회조건 수정
 * 2022/04/29   chaan       81_UC, EE_UC 추가로 DIVSION 크기 확장
 * 2026.03.24   kimcd           [PJ20264226] NextSCM Pilot 설계 및 개발
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    IF P_ACTION_FLAG = 'I' THEN

        OPEN O_RC1 FOR
            SELECT DISTINCT B.DIVISION_ID, B.ITEM_ID, D.NICK_NAME
            FROM   SCM_MGR.SCM_MST_SITE_ITEM      B
            JOIN   SCM_MGR.SCM_MST_SITE            C ON B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.SCM_SITE_ID
            JOIN   SCM_MGR.SCM_MST_ITEM_SN         D ON B.DIVISION_ID = D.DIVISION_ID AND B.ITEM_ID     = D.ITEM_ID
            WHERE  1 = 1
            AND    B.DIVISION_ID = P_DIVISION_ID
            AND    (
                       (P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                       OR B.ITEM_ID  LIKE '%' || P_ITEM_ID || '%'
                       OR D.NICK_NAME LIKE P_ITEM_ID || '%'
                   )
            AND    C.SITE_TYPE            = 'SALES'
            AND    D.SCP_OPERATION_GROUP  = 'A'
            AND    NOT EXISTS (
                       SELECT 'X' FROM SCM_MGR.DM_MST_CAPACITY_ALLOCATION A
                       WHERE  B.DIVISION_ID = A.DIVISION_ID
                       AND    B.ITEM_ID     = A.ITEM_ID
                   )
            AND    B.VALID_YN = 'Y'
            AND    C.VALID_YN = 'Y'
            ORDER BY ITEM_ID;

    ELSIF P_ACTION_FLAG = 'D' THEN

        OPEN O_RC1 FOR
            SELECT DISTINCT DIVISION_ID
                          , ITEM_ID
                          , (SELECT CASE WHEN X.NICK_NAME IS NULL THEN '-'
                                         WHEN X.NICK_NAME = ''   THEN '-'
                                         ELSE X.NICK_NAME
                                    END
                             FROM   SCM_MGR.SCM_MST_ITEM_SN X
                             WHERE  X.ITEM_ID = A.ITEM_ID
                             AND    ROWNUM    = 1
                            ) AS NICK_NAME
            FROM   SCM_MGR.DM_MST_CAPACITY_ALLOCATION A
            WHERE  A.DIVISION_ID = P_DIVISION_ID
            AND    (
                       (P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                       OR A.ITEM_ID LIKE '%' || P_ITEM_ID || '%'
                       OR (SELECT CASE WHEN X.NICK_NAME IS NULL THEN '-'
                                       WHEN X.NICK_NAME = ''   THEN '-'
                                       ELSE X.NICK_NAME
                                  END
                           FROM   SCM_MGR.SCM_MST_ITEM_SN X
                           WHERE  X.ITEM_ID = A.ITEM_ID
                           AND    ROWNUM    = 1
                          ) LIKE P_ITEM_ID || '%'
                   );

    ELSE
        OPEN O_RC1 FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_ACTION_FLAG' VALUE P_ACTION_FLAG,
            'P_ITEM_ID'     VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_CAPACITY_ALLOCATION_POPUP;



/* ============================================================
   4. P_SCM0002_GET_CITY_BY_COUNTY_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_CITY_BY_COUNTY_POPUP
(
    P_COUNTRY       IN VARCHAR2,
    P_CITY          IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : SCM0002_GET_CITY_BY_COUNTY_POPUP                                                   */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/06  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트      */
/* 2026.03.24  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT A.COUNTRY
             , A.COUNTRY_NAME
             , B.CITY
             , B.CITY_NAME
             , B.STATE_NM
        FROM   SCM_MGR.SCM_MST_COUNTRY A
             , SCM_MGR.SCM_MST_CITY    B
        WHERE  A.COUNTRY  = B.COUNTRY
        AND    A.VALID_YN = 'Y'
        AND    B.VALID_YN = 'Y'
        AND    (   A.COUNTRY      LIKE '%' || P_COUNTRY || '%'
                OR A.COUNTRY_NAME LIKE '%' || P_COUNTRY || '%'
               )
        AND    (   B.CITY      LIKE '%' || P_CITY || '%'
                OR B.CITY_NAME LIKE '%' || P_CITY || '%'
               );

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_COUNTRY' VALUE P_COUNTRY,
            'P_CITY'    VALUE P_CITY
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_CITY_BY_COUNTY_POPUP;

/* ============================================================
   5. P_SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_SOLDTO_CODE   IN VARCHAR2,
    P_SHIPTO_CODE   IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/04   songdh         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 20180604 주석제거 modified by khsong
 * 2026.03.24   kimcd          [PJ20264226] NextSCM Pilot 설계 및 개발

 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT C.DIVISION_ID
             , D.DIVISION_NAME
             , C.SOLDTO_CODE
             , C.SOLDTO_DESCRIPTION
             , C.SHIPTO_CODE
             , C.SHIPTO_DESCRIPTION
             , C.SHIPTO_REGION_NAME
             , C.SHIPTO_CITY_NAME
        FROM   SCM_MGR.SCM_MST_CUSTOMER  C
             , SCM_MGR.SCM_MST_DIVISION  D
        WHERE  C.DIVISION_ID = D.DIVISION_ID
        AND    C.VALID_YN    = 'Y'
        -- CASE WHEN ALL → UNION ALL 분해 (Predicate Pushdown 유도)
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR C.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   C.SHIPTO_CODE        LIKE '%' || P_SHIPTO_CODE || '%'
                OR C.SHIPTO_DESCRIPTION LIKE '%' || P_SHIPTO_CODE || '%'
               )
        AND    (   C.SOLDTO_CODE        LIKE '%' || P_SOLDTO_CODE || '%'
                OR C.SOLDTO_DESCRIPTION LIKE '%' || P_SOLDTO_CODE || '%'
               )
        AND    NOT EXISTS (
                   SELECT 1
                   FROM   SCM_MGR.SCM_MST_SITE_CUSTOMER SC
                        , SCM_MGR.SCM_MST_SITE           B  -- added by ytchoi 20180730 plant와 구분 하기 위해서
                   WHERE  1 = 1
                   AND    SC.SOLDTO_CODE  = C.SOLDTO_CODE  -- 20180604 주석제거 modified by khsong
                   AND    SC.SHIPTO_CODE  = C.SHIPTO_CODE
                   AND    SC.DIVISION_ID  = C.DIVISION_ID
                   AND    SC.VALID_YN     = 'Y'
                   -- added by ytchoi 20180730 plant와 구분 하기 위해서
                   AND    SC.DIVISION_ID  = B.DIVISION_ID
                   AND    SC.SCM_SITE_ID  = B.SCM_SITE_ID
                   AND    B.SITE_TYPE     = 'SALES'
               );

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_SOLDTO_CODE' VALUE P_SOLDTO_CODE,
            'P_SHIPTO_CODE' VALUE P_SHIPTO_CODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_CUSTOMER_BY_DIVISION_POPUP;



/* ============================================================
   6. P_SCM0002_GET_DEPARTMENT_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_DEPARTMENT_POPUP
(
    P_DEPARTMENT    IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_DEPARTMENT_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15   Songdh         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.24   kimcd          [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT T.UPPER_DEPT_ID
             , D.DEPT_NAME_KO
             , T.DEPT_ID      AS TEAM_ID
             , T.DEPT_NAME_KO AS TEAM_NAME_KO
        FROM   SCM_MGR.SCM_MST_SSO_DEPT_INFO D
             , SCM_MGR.SCM_MST_SSO_DEPT_INFO T
        WHERE  T.UPPER_DEPT_ID     = D.DEPT_ID
        AND    D.VALID_YN          = 'Y'
        AND    D.DEPT_NAME_KO     <> '_'
        AND    T."2LEVEL_DEPT_ID"  = '58174290'
        AND    D.DEPT_ID          <> T.DEPT_ID
        AND    (   T.DEPT_NAME_KO LIKE '%' || P_DEPARTMENT || '%'
                OR T.DEPT_NAME_EN LIKE '%' || P_DEPARTMENT || '%'
                OR T.DEPT_NAME_CN LIKE '%' || P_DEPARTMENT || '%'
               )
        ORDER BY T.UPPER_DEPT_ID, D.DEPT_NAME_KO, T.DEPT_ID, T.DEPT_NAME_KO;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DEPARTMENT' VALUE P_DEPARTMENT
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_DEPARTMENT_POPUP;

/* ============================================================
   1. SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP
 * Description  : 전극 Model Popup
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2018/06/29   ygkim       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/12/17 hwyoon            복수 division 선택 조회
 * 2026.03.26   kimcd          [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , MIN(C.DIVISION_NAME)  AS DIVISION_NAME
             , A.ITEM_ID
             , B.ITEM_NAME
             , B.ITEM_TYPE
             , B.NICK_NAME
             , B.ITEM_CLASS_NAME
        FROM   SCM_MGR.SCP_MST_FINAL_ITEM  A
        INNER JOIN SCM_MGR.SCM_MST_ITEM_SN    B ON A.DIVISION_ID = B.DIVISION_ID AND A.ITEM_ID    = B.ITEM_ID
        INNER JOIN SCM_MGR.SCM_MST_DIVISION   C ON A.DIVISION_ID = C.DIVISION_ID
        WHERE  A.OPERATION_GROUP = 'E'
        AND    (
                   P_DIVISION_ID IS NULL
                   OR P_DIVISION_ID = ''
                   OR A.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        --AND A.DIVISION_ID = @p_division_id
        AND    (   A.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                OR B.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
                OR B.NICK_NAME LIKE '%' || P_ITEM_ID || '%'
               )
        GROUP BY A.DIVISION_ID
               , A.ITEM_ID
               , B.ITEM_NAME
               , B.ITEM_TYPE
               , B.NICK_NAME
               , B.ITEM_CLASS_NAME
        ORDER BY A.DIVISION_ID
               , A.ITEM_ID
               , B.ITEM_NAME
               , B.ITEM_TYPE
               , B.NICK_NAME
               , B.ITEM_CLASS_NAME;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_ITEM_ID'     VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_ELECTRODE_ITEM_BY_DIVISION_POPUP;



/* ============================================================
   2. SCM0002_GET_ITEM_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_ITEM_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_SCM_SITE_ID   IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_ITEM_BY_DIVISION_POP                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/04/03  박진수       @p_item_id로 NICK NAME 동시에 검색되도록 조회 조건에 추가               */
/* 2018/07/05  byunghunjung 소형사업부는 project 가 없으므로 outer join으로 변경함                  */
/* 2026.03.26  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT DISTINCT
               D.DIVISION_ID
             , D.DIVISION_NAME
             , NVL(P.PROJECT_CODE, '-')  AS PROJECT_CODE
             , NVL(P.PROJECT_NAME, '-')  AS PROJECT_NAME
             , S.SCM_SITE_ID
             , S.SITE_DESCRIPTION
             , I.ITEM_ID
             , T.ITEM_NAME
             , T.ITEM_TYPE
             , T.NICK_NAME
             , T.ITEM_CLASS_NAME
        FROM   SCM_MGR.SCM_MST_SITE_ITEM    I
        JOIN   SCM_MGR.SCM_MST_DIVISION      D ON I.DIVISION_ID  = D.DIVISION_ID
        JOIN   SCM_MGR.SCM_MST_SITE          S ON I.DIVISION_ID  = S.DIVISION_ID  AND I.SCM_SITE_ID  = S.SCM_SITE_ID
        JOIN   SCM_MGR.SCM_MST_ITEM_SN       T ON I.DIVISION_ID  = T.DIVISION_ID  AND I.ITEM_ID      = T.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.SCM_MST_PROJECT P ON I.DIVISION_ID  = P.DIVISION_ID AND I.PROJECT_CODE = P.PROJECT_CODE
        WHERE  1 = 1
        -- CASE WHEN ALL → UNION ALL 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR I.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (
                   P_SCM_SITE_ID = 'ALL'
                   OR I.SCM_SITE_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    I.PROJECT_CODE LIKE '%' || P_PROJECT_CODE || '%'
        AND    (   I.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
                OR T.NICK_NAME LIKE '%' || P_ITEM_ID || '%'
               )
        ORDER BY D.DIVISION_ID, S.SCM_SITE_ID, S.SITE_DESCRIPTION, I.ITEM_ID, T.ITEM_NAME;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_PROJECT_CODE' VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'      VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_ITEM_BY_DIVISION_POPUP;



/* ============================================================
   3. SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_SCM_SITE_ID   IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    P_ASSIGN_YN     IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP                                               */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/11/08  hwyoon   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.26  kimcd    [PJ20264226] NextSCM Pilot 설계 및 개발                                       */
/*                                                                                                  */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT I.DIVISION_ID
             , MIN(D.DIVISION_NAME)  AS DIVISION_NAME
             , S.SCM_SITE_ID
             , S.SITE_DESCRIPTION
             , I.ITEM_ID
             , T.ITEM_NAME
             , T.ITEM_TYPE
             , T.NICK_NAME
             , T.ITEM_CLASS_NAME
        FROM   SCM_MGR.SCM_MST_SITE_ITEM   I
             , SCM_MGR.SCM_MST_DIVISION     D
             , SCM_MGR.SCM_MST_SITE         S
             , SCM_MGR.SCM_MST_ITEM_SN      T
        WHERE  I.DIVISION_ID  = D.DIVISION_ID
        AND    I.SCM_SITE_ID  = S.SCM_SITE_ID
        AND    I.DIVISION_ID  = T.DIVISION_ID
        AND    I.ITEM_ID      = T.ITEM_ID
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR I.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (
                   P_SCM_SITE_ID = 'ALL'
                   OR I.SCM_SITE_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   I.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
               )
        AND    (
                   (P_ASSIGN_YN IS NULL OR P_ASSIGN_YN = '' OR P_ASSIGN_YN = '')
                   OR EXISTS (
                          SELECT 1
                          FROM   SCM_MGR.SCM_MST_SITE_ITEM_PRIORITY P
                          WHERE  P.DIVISION_ID  = I.DIVISION_ID
                          AND    P.PLANT_SITE_ID = S.SCM_SITE_ID
                          AND    P.ITEM_ID       = I.ITEM_ID
                          AND    P.VALID_YN      = 'Y'
                          AND    ROWNUM          = 1
                      )
               )
        GROUP BY I.DIVISION_ID
               , S.SCM_SITE_ID
               , S.SITE_DESCRIPTION
               , I.ITEM_ID
               , T.ITEM_NAME
               , T.ITEM_TYPE
               , T.NICK_NAME
               , T.ITEM_CLASS_NAME
        ORDER BY I.DIVISION_ID
               , S.SCM_SITE_ID
               , S.SITE_DESCRIPTION
               , I.ITEM_ID
               , T.ITEM_NAME;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID' VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'     VALUE P_ITEM_ID,
            'P_ASSIGN_YN'   VALUE P_ASSIGN_YN
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_ITEM_BY_PLANT_SITE_POPUP;



/* ============================================================
   4. SCM0002_GET_ITEM_BY_SITE_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_ITEM_BY_SITE_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_SCM_SITE_ID   IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_ITEM_BY_DIVISION_POP                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.26  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT I.DIVISION_ID
             , MIN(D.DIVISION_NAME)  AS DIVISION_NAME
             , S.SCM_SITE_ID
             , S.SITE_DESCRIPTION
             , I.ITEM_ID
             , T.ITEM_NAME
             , T.ITEM_TYPE
             , T.NICK_NAME
             , T.ITEM_CLASS_NAME
        FROM   SCM_MGR.SCM_MST_SITE_ITEM   I
             , SCM_MGR.SCM_MST_DIVISION     D
             , SCM_MGR.SCM_MST_SITE         S
             , SCM_MGR.SCM_MST_ITEM_SN      T
        WHERE  I.DIVISION_ID  = D.DIVISION_ID
        AND    I.SCM_SITE_ID  = S.SCM_SITE_ID
        AND    I.DIVISION_ID  = T.DIVISION_ID
        AND    I.ITEM_ID      = T.ITEM_ID
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR I.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (
                   P_SCM_SITE_ID = 'ALL'
                   OR I.SCM_SITE_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   I.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
               )
        GROUP BY I.DIVISION_ID
               , S.SCM_SITE_ID
               , S.SITE_DESCRIPTION
               , I.ITEM_ID
               , T.ITEM_NAME
               , T.ITEM_TYPE
               , T.NICK_NAME
               , T.ITEM_CLASS_NAME
        ORDER BY I.DIVISION_ID
               , S.SCM_SITE_ID
               , S.SITE_DESCRIPTION
               , I.ITEM_ID
               , T.ITEM_NAME;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID' VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'     VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_ITEM_BY_SITE_POPUP;



/* ============================================================
   5. SCM0002_GET_ITEM_ELEC
   ============================================================ */
PROCEDURE P_SCM0002_GET_ITEM_ELEC
(
    P_DIVISION_ID   IN VARCHAR2,
    P_COMPANY_ID    IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
* Program ID   : SCM0002_GET_ITEM_ELEC
* Description  : 전극 모델목록 조회
* Program History
*
*===========================================================================================================================================
* Date          In Charge       Description
*===========================================================================================================================================
* 2023.04.24    chaan           PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - V1.1.1   Initial Release
* 2026.03.26    kimcd           [PJ20264226] NextSCM Pilot 설계 및 개발
*/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    --DECLARE @p_division_id   NVARCHAR(MAX)       = 'ALL';
    --DECLARE @p_company_id    NVARCHAR(MAX)       = 'ALL';
    --DECLARE @p_item_id       NVARCHAR(MAX)       = '';

    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT DISTINCT
               D.DIVISION_ID
             , D.DIVISION_NAME
             , NVL(P.PROJECT_CODE, '-')  AS PROJECT_CODE
             , NVL(P.PROJECT_NAME, '-')  AS PROJECT_NAME
             , S.COMPANY_ID
             , I.ITEM_ID
             , T.ITEM_NAME
             , T.NICK_NAME
             , T.ITEM_CLASS_NAME
        FROM   SCM_MGR.SCM_MST_SITE_ITEM   I
        JOIN   SCM_MGR.SCM_MST_DIVISION     D ON I.DIVISION_ID = D.DIVISION_ID
        JOIN   SCM_MGR.SCM_MST_SITE         S ON I.DIVISION_ID = S.DIVISION_ID
                                              AND I.SCM_SITE_ID = S.SCM_SITE_ID
        JOIN   (
                   SELECT *
                   FROM   SCM_MGR.SCM_MST_ITEM_SN A
                   WHERE  1 = 1
                   AND    SCP_OPERATION_GROUP = 'E'
                   AND    CASE
                              WHEN FLOW_ID IS NULL THEN SCP_FLOW_ID
                              ELSE FLOW_ID
                          END LIKE 'E2000%'
               ) T ON I.DIVISION_ID = T.DIVISION_ID
                  AND I.ITEM_ID     = T.ITEM_ID
        LEFT OUTER JOIN SCM_MGR.SCM_MST_PROJECT P ON I.DIVISION_ID  = P.DIVISION_ID
                                                  AND I.PROJECT_CODE = P.PROJECT_CODE
        WHERE  1 = 1
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR I.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (
                   P_COMPANY_ID = 'ALL'
                   OR S.COMPANY_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_COMPANY_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_COMPANY_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   I.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
                OR T.NICK_NAME LIKE '%' || P_ITEM_ID || '%'
                OR I.ITEM_ID   IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
                OR T.ITEM_NAME IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
                OR T.NICK_NAME IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_ITEM_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
               )
        ORDER BY D.DIVISION_ID
               , D.DIVISION_NAME
               , NVL(P.PROJECT_CODE, '-')
               , NVL(P.PROJECT_NAME, '-')
               , S.COMPANY_ID
               , I.ITEM_ID
               , T.ITEM_NAME
               , T.NICK_NAME
               , T.ITEM_CLASS_NAME;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_COMPANY_ID'  VALUE P_COMPANY_ID,
            'P_ITEM_ID'     VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_ITEM_ELEC;



/* ============================================================
   6. SCM0002_GET_LOCATION_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_LOCATION_BY_DIVISION_POPUP
(
    P_DIVISION_ID    IN VARCHAR2,
    P_SCM_SITE_ID    IN VARCHAR2,
    P_LOCATION_CODE  IN VARCHAR2,
    O_RC1            OUT SYS_REFCURSOR,
    O_RESULT_CURSOR  OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : SCM0002_GET_LOCATION_BY_DIVISION_POPUP                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/12/05  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.26  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT L.DIVISION_ID
             , D.DIVISION_NAME
             , L.SCM_SITE_ID
             , L.LOCATION_CODE
             , L.LOCATION_DESCRIPTION
             , L.STORAGE_ID
        FROM   SCM_MGR.SCM_MST_LOCATION  L
             , SCM_MGR.SCM_MST_DIVISION  D
        WHERE  L.DIVISION_ID     = D.DIVISION_ID
        AND    L.LOCATION_CODE   = L.LOCATION_CODE
        AND    L.STORAGE_ID      IS NOT NULL
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR L.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    L.SCM_SITE_ID LIKE '%' || P_SCM_SITE_ID || '%'
        --AND    CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
        --            ELSE L.SCM_SITE_ID
        --       END  IN (SELECT t.c.value('.', 'NVARCHAR(4000)')
        --                FROM   (SELECT x = CAST('<t>' + REPLACE(@p_scm_site_id, ',', '</t><t>') + '</t>' AS xml)) b
        --                CROSS APPLY x.nodes('/t') t(c)
        --               )
        AND    (   L.LOCATION_CODE        LIKE '%' || P_LOCATION_CODE || '%'
                OR L.LOCATION_DESCRIPTION LIKE '%' || P_LOCATION_CODE || '%'
               )
        ORDER BY L.DIVISION_ID
               , L.SCM_SITE_ID
               , L.LOCATION_CODE;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'   VALUE P_DIVISION_ID,
            'P_SCM_SITE_ID'   VALUE P_SCM_SITE_ID,
            'P_LOCATION_CODE' VALUE P_LOCATION_CODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_LOCATION_BY_DIVISION_POPUP;

/* ============================================================
   1. SCM0002_GET_MATERIAL_BY_DIVISION
   ============================================================ */
PROCEDURE P_SCM0002_GET_MATERIAL_BY_DIVISION
(
    P_DIVISION_ID        IN VARCHAR2,
    P_OPERATION_GROUP    IN VARCHAR2,
    P_ITEM_ID            IN VARCHAR2,
    P_SCP_MODULE_TYPE    IN VARCHAR2,
    O_RC1                OUT SYS_REFCURSOR,
    O_RESULT_CURSOR      OUT SYS_REFCURSOR
)
AS
/*================================================================================================================================================================================
 * Program ID   : [SCM0002_GET_MATERIAL_BY_DIVISION]
 * Description  : 기존 Model 조회용 팝업을 Material 조회용으로 변경하면서 분리
 * Program History
 *================================================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================================================
 * 2023/09/05   chaan                               Initial Release                                                    - Model을 Material 로 바꾸면서 SCP 전용으로 분리
 * 2023/09/11   chaan               V1.1.1      PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2            - Operation Group 예외처리
 * 2026.03.27   kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
    $$PLSQL_UNIT      VARCHAR2(200  CHAR);
    V_OPERATION_GROUP   VARCHAR2(4000 CHAR);

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);
    V_LOG_TYPE          VARCHAR2(100  CHAR);
    V_LOG_MESSAGE       VARCHAR2(4000 CHAR);
    V_DESCRIPTION       VARCHAR2(4000 CHAR);
    N_LOG_COUNT         PLS_INTEGER        := 0;
    D_EVENT_DATE        DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    --DECLARE @p_division_id                NVARCHAR(30)      = '81';
    --DECLARE @p_operation_group              NVARCHAR(MAX)     = '';
    --DECLARE @p_item_id                    NVARCHAR(50)      = '';
    --DECLARE @p_scp_module_type            NVARCHAR(50)      = 'SCP0022';

    V_OPERATION_GROUP := P_OPERATION_GROUP;

    IF V_OPERATION_GROUP IS NULL OR V_OPERATION_GROUP = '' THEN
        V_OPERATION_GROUP := 'ALL';
    END IF;

    IF     P_SCP_MODULE_TYPE = 'SCP0022'  --SCP0022_Formation
        OR P_SCP_MODULE_TYPE = 'SCP0040'  --SCP0040_CharacteristicCapacity
        OR P_SCP_MODULE_TYPE = 'SCP0046'  --SCP0046_ModelAllocation
    THEN
        V_OPERATION_GROUP := 'A';
    END IF;

    DBMS_OUTPUT.PUT_LINE('@p_scp_module_type : ' || P_SCP_MODULE_TYPE);

    IF     P_SCP_MODULE_TYPE = 'SCP0011'  --SCP0011_ProductionPlan
        OR P_SCP_MODULE_TYPE = 'SCP0013'  --SCP0013_ProductionPlanLine
        OR P_SCP_MODULE_TYPE = 'SCP0017'  --SCP0017_WaterfallProductionPlan
        OR P_SCP_MODULE_TYPE = 'SCP0022'  --SCP0022_Formation
        OR P_SCP_MODULE_TYPE = 'SCP0024'  --SCP0024_ProductionPlanFix
        OR P_SCP_MODULE_TYPE = 'SCP0040'  --SCP0040_CharacteristicCapacity
        OR P_SCP_MODULE_TYPE = 'SCP0046'  --SCP0046_ModelAllocation
    THEN
        DBMS_OUTPUT.PUT_LINE('--Operation Group = ''A'' 일때 ATTRIBUTE8 가 CA% 만 표시--------------------------------------------------------------------------------');

        OPEN O_RC1 FOR
            SELECT DISTINCT
                   D.DIVISION_ID
                 , D.DIVISION_NAME
                 , I.ITEM_ID
                 , T.ITEM_NAME
                 , T.NICK_NAME
                 , T.ITEM_CLASS_NAME
    --test original columns begin--------------------------------------------------
                 --, I.OPERATION_GROUP
                 --, I.ATTRIBUTE8
    --test original columns end----------------------------------------------------
            FROM   SCM_MGR.SCP_MST_FINAL_ITEM  I
            JOIN   SCM_MGR.SCM_MST_DIVISION     D ON I.DIVISION_ID = D.DIVISION_ID
            JOIN   SCM_MGR.SCM_MST_ITEM_SN      T ON I.DIVISION_ID = T.DIVISION_ID
                                                  AND I.ITEM_ID     = T.ITEM_ID
            WHERE  1 = 1
            AND    (
                       P_DIVISION_ID = 'ALL'
                       OR I.DIVISION_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       V_OPERATION_GROUP = 'ALL'
                       OR I.OPERATION_GROUP IN (
                              SELECT TRIM(REGEXP_SUBSTR(V_OPERATION_GROUP, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(V_OPERATION_GROUP, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    CASE
                       WHEN I.OPERATION_GROUP = 'A' AND I.ATTRIBUTE8 LIKE 'CA%' THEN 1
                       WHEN I.OPERATION_GROUP <> 'A' THEN 1
                       ELSE 0
                   END = 1
            AND    (   I.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                    OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
                    OR T.NICK_NAME LIKE '%' || P_ITEM_ID || '%'
                   )
            ORDER BY D.DIVISION_ID, I.ITEM_ID, T.ITEM_NAME;

    ELSE

        IF     P_SCP_MODULE_TYPE = 'SCP0014'  --SCP0014_Problem_Report
            OR P_SCP_MODULE_TYPE = 'SCP0031'  --SCP0031_GlobalPSI
            OR P_SCP_MODULE_TYPE = 'SCP0037'  --SCP0037_OperationLT
            OR P_SCP_MODULE_TYPE = 'SCP0038'  --SCP0038_GlobalPSI_small
            OR P_SCP_MODULE_TYPE = 'SCP0044'  --SCP0044_GlobalPSI_ESS
            OR P_SCP_MODULE_TYPE = 'SCP0051'  --SCP0051_ProductionPlanTarget
            OR P_SCP_MODULE_TYPE = 'SCP0085'  --SCP0085_EndingInventory
        THEN
            DBMS_OUTPUT.PUT_LINE('--Operation Group 고정(A,P,E)--------------------------------------------------------------------------------');
            V_OPERATION_GROUP := 'A,P,E';
        END IF;

        DBMS_OUTPUT.PUT_LINE('--선택한 Operation Group 기준--------------------------------------------------------------------------------');

        OPEN O_RC1 FOR
            SELECT DISTINCT
                   D.DIVISION_ID
                 , D.DIVISION_NAME
                 , I.ITEM_ID
                 , T.ITEM_NAME
                 , T.NICK_NAME
                 , T.ITEM_CLASS_NAME
    --test original columns begin--------------------------------------------------
                 --, I.OPERATION_GROUP
                 --, I.ATTRIBUTE8
    --test original columns end----------------------------------------------------
            FROM   SCM_MGR.SCP_MST_FINAL_ITEM  I
            JOIN   SCM_MGR.SCM_MST_DIVISION     D ON I.DIVISION_ID = D.DIVISION_ID
            JOIN   SCM_MGR.SCM_MST_ITEM_SN      T ON I.DIVISION_ID = T.DIVISION_ID
                                                  AND I.ITEM_ID     = T.ITEM_ID
            WHERE  1 = 1
            AND    (
                       P_DIVISION_ID = 'ALL'
                       OR I.DIVISION_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       V_OPERATION_GROUP = 'ALL'
                       OR I.OPERATION_GROUP IN (
                              SELECT TRIM(REGEXP_SUBSTR(V_OPERATION_GROUP, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(V_OPERATION_GROUP, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (   I.ITEM_ID   LIKE '%' || P_ITEM_ID || '%'
                    OR T.ITEM_NAME LIKE '%' || P_ITEM_ID || '%'
                    OR T.NICK_NAME LIKE '%' || P_ITEM_ID || '%'
                   )
            ORDER BY D.DIVISION_ID, I.ITEM_ID, T.ITEM_NAME;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'     VALUE P_DIVISION_ID,
            'P_OPERATION_GROUP' VALUE P_OPERATION_GROUP,
            'P_ITEM_ID'         VALUE P_ITEM_ID,
            'P_SCP_MODULE_TYPE' VALUE P_SCP_MODULE_TYPE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_MATERIAL_BY_DIVISION;


/* ============================================================
   2. SCM0002_GET_PLANT_CUSTOMER_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_PLANT_CUSTOMER_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_SOLDTO_CODE   IN VARCHAR2,
    P_SHIPTO_CODE   IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_PLANT_CUSTOMER_BY_DIVISION_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/05/02   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.27  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발
 *
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT C.DIVISION_ID
             , D.DIVISION_NAME
             , C.SOLDTO_CODE
             , C.SOLDTO_DESCRIPTION
             , C.SHIPTO_CODE
             , C.SHIPTO_DESCRIPTION
             , C.SHIPTO_REGION_NAME
             , C.SHIPTO_CITY_NAME
        FROM   SCM_MGR.SCM_MST_CUSTOMER  C
             , SCM_MGR.SCM_MST_DIVISION  D
        WHERE  C.DIVISION_ID = D.DIVISION_ID
        AND    C.VALID_YN    = 'Y'
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR C.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   C.SHIPTO_CODE        LIKE '%' || P_SHIPTO_CODE || '%'
                OR C.SHIPTO_DESCRIPTION LIKE '%' || P_SHIPTO_CODE || '%'
               )
        AND    (   C.SOLDTO_CODE        LIKE '%' || P_SOLDTO_CODE || '%'
                OR C.SOLDTO_DESCRIPTION LIKE '%' || P_SOLDTO_CODE || '%'
               )
        --AND NOT EXISTS (SELECT *
        --                FROM   [dbo].[SCM_MST_SITE_CUSTOMER] SC
        --              WHERE  1 = 1
        --              -- modified by ytchoi 180323
        --          --  AND    SC.SOLDTO_CODE = C.SOLDTO_CODE
        --              AND    SC.SHIPTO_CODE = C.SHIPTO_CODE
        --              AND    sc.division_id = c.DIVISION_ID
        --              and    sc.valid_YN = 'Y'
        --               )
        ;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_SOLDTO_CODE' VALUE P_SOLDTO_CODE,
            'P_SHIPTO_CODE' VALUE P_SHIPTO_CODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_PLANT_CUSTOMER_BY_DIVISION_POPUP;


/* ============================================================
   3. SCM0002_GET_PROJECT_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_PROJECT_BY_DIVISION_POP                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/07/04  YHW          정렬 추가(DIV)                                                          */
/* 2026.03.27  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발                                   */
/*                                                                                                  */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT P.DIVISION_ID
             , MIN(D.DIVISION_NAME)     AS DIVISION_NAME
             , P.PROJECT_CODE
             , P.PROJECT_NAME
             , P.PROJECT_STATUS
             , P.BIZ_TYPE_NAME          AS BIZ_TYPE
             , P.CURRENCY
             , MAX(P.PROJECT_VER_SEQ)   AS PROJECT_VER_SEQ
             , P.PROJECT_OWNER
        FROM   SCM_MGR.SCM_MST_PROJECT   P
             , SCM_MGR.SCM_MST_DIVISION  D
        WHERE  1 = 1
        AND    P.DROP_YN     = ''
        AND    P.DIVISION_ID = D.DIVISION_ID
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR P.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   P.PROJECT_CODE LIKE '%' || P_PROJECT_CODE || '%'
                OR P.PROJECT_NAME LIKE '%' || P_PROJECT_CODE || '%'
               )
        GROUP BY P.DIVISION_ID
               , P.PROJECT_CODE
               , P.PROJECT_NAME
               , P.PROJECT_STATUS
               , P.BIZ_TYPE_NAME
               , P.CURRENCY
               , P.PROJECT_OWNER
        ORDER BY P.DIVISION_ID
               , P.PROJECT_NAME
               , P.PROJECT_CODE;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_PROJECT_CODE' VALUE P_PROJECT_CODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_PROJECT_BY_DIVISION_POPUP;


/* ============================================================
   4. SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX
   ============================================================ */
PROCEDURE P_SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX
(
    P_DIVISION_ID   IN VARCHAR2,
    P_DEPT_ID       IN VARCHAR2,   --Department
    P_END_CUSTOMER  IN VARCHAR2,   --Endcustomer
    P_SCM_SITE_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_ETC           IN VARCHAR2 DEFAULT NULL,  -- [PJ20200138] ETC Flag 추가
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/****************************************************************************************************
 * Program ID  : SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX
 * Description : Sales Price화면에서 Project Code를 가져오는 경우에 사용한다.
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   : division_id, dept_id, end_customer, scm_site_id, project_code
 *--------------------------------------------------------------------------------------------------
 * Date        In Charge    Description
 *--------------------------------------------------------------------------------------------------
 * 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2020/05/04  P.C.I        [PJ20200138] 전지 공급 대응력 향상을 위한 RTF 적확도 개선 - ETC 추가
 * 2024/12/13  jssbae       [PJ2024-50461] Team Mapping
 * 2025/04/16  jssbae   [E20250416-001094]_SSPM Owner 기준 Team정보 Mapping 로직 개선
 * 2026.03.27  kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발. TEAM 정보를 SCM_MST_SITE_ITEM 기준으로 변경
 ****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    -- EXEC SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX @p_division_id='ALL', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code=''

    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    --SELECT A.DIVISION_ID
    --     , MIN(D.DIVISION_NAME)   AS DIVISION_NAME
    --     , A.PROJECT_CODE
    --     , A.PROJECT_NAME
    --     , A.PROJECT_STATUS
    --   , A.BIZ_TYPE
    --   , A.CURRENCY
    --     , MAX(A.PROJECT_VER_SEQ)  AS PROJECT_VER_SEQ
    --   , A.PROJECT_OWNER
    --   , TEAM.DEPT_ID
    --   , TEAM.DEPT_NAME_KO
    --   , C.END_CUSTOMER
    --FROM   [dbo].[SCM_MST_PROJECT]  A WITH(NOLOCK)
    --LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN = 'Y') D
    --ON A.DROP_YN = '' AND A.DIVISION_ID = D.DIVISION_ID
    --LEFT JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, DEPT_ID, END_CUSTOMER FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') AS C
    --ON A.DIVISION_ID = C.DIVISION_ID
    --LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM
    --                     ON C.DEPT_ID = TEAM.DEPT_ID

    IF P_ETC = '' THEN

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.DIVISION_ID                AS DIVISION_NAME
                 , A.PROJECT_CODE
                 , A.PROJECT_NAME
                 , A.PROJECT_STATUS
                 --, A.BIZ_TYPE
                 --, A.BIZ_TYPE
                 , BIZ.CODE                     AS BIZ_TYPE
                 , BIZ.NAME                     AS BIZ_TYPE_NAME
                 , A.CURRENCY
                 , MAX(A.PROJECT_VER_SEQ)       AS PROJECT_VER_SEQ
                 , A.PROJECT_OWNER
                 , TEAM.DEPT_ID
                 , TEAM.DEPT_NAME_KO
                 , C.END_CUSTOMER
            FROM   (SELECT * FROM SCM_MGR.SCM_MST_PROJECT) A
            LEFT JOIN (
                          SELECT * FROM SCM_MGR.SCM_MST_DIVISION WHERE VALID_YN = 'Y'
                      ) D
                ON A.DROP_YN = '' AND A.DIVISION_ID = D.DIVISION_ID
            LEFT JOIN (
                          SELECT * FROM SCM_MGR.SCM_MST_SITE_ITEM WHERE VALID_YN = 'Y'
                      ) B
                ON A.DIVISION_ID = B.DIVISION_ID AND A.PROJECT_CODE = B.PROJECT_CODE
            LEFT JOIN (
                          SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, END_CUSTOMER
                          FROM   SCM_MGR.SCM_MST_SITE
                          WHERE  VALID_YN = 'Y'
                      ) C
                ON B.DIVISION_ID = C.DIVISION_ID AND B.SCM_SITE_ID = C.SCM_SITE_ID
            --[PJ2024-50461] Team Mapping START 주석처리 하고 변경 내역을 적용한다.
            /*
            LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y')  AS TEAM
                            ON C.DEPT_ID = TEAM.DEPT_ID
            */
            LEFT JOIN SCM_MGR.SCM_MST_SSO_USER_INFO SU
            --[E20250416-001094]_SSPM Owner 기준 Team정보 Mapping 로직 개선
            --SCM_MST_SITE_ITEM 해당 테이블은 OWNER가 여러명을 가질수 있는 구조로, 해당조건으로 JOIN하면 데이터가 생성되지 않음
            --SPLIT해서 TOP1만 가지고 오는 구조로 변경
                    --ON SU.USER_ID = B.OWNER
                    ON SU.USER_ID = (
                                        SELECT TRIM(REGEXP_SUBSTR(B.OWNER, '[^,]+', 1, 1))
                                        FROM   DUAL
                                    )
            LEFT JOIN (
                          SELECT * FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO WHERE VALID_YN = 'Y'
                      ) TEAM
                ON B.DEPT_ID = TEAM.DEPT_ID
            --[PJ2024-50461] Team Mapping END
            LEFT JOIN (
                          SELECT SEGMENT1  AS CODE
                               , SEGMENT2  AS NAME
                          FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                          WHERE  LOOKUP_TYPE = 'BIZ_TYPE_BPMS'
                      ) BIZ
                ON BIZ.CODE = A.BIZ_TYPE
            WHERE  TEAM.DEPT_ID IS NOT NULL
            AND    (
                       P_DIVISION_ID = 'ALL'
                       OR A.DIVISION_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       P_DEPT_ID = 'ALL'
                       OR TEAM.DEPT_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_DEPT_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       P_END_CUSTOMER = 'ALL'
                       OR NVL(C.END_CUSTOMER, '') IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_END_CUSTOMER, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            AND    (
                       P_SCM_SITE_ID = 'ALL'
                       OR C.SCM_SITE_ID IN (
                              SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                              FROM   DUAL
                              CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                          )
                   )
            --AND CASE WHEN @p_project_code = '' THEN ''
            --         ELSE A.PROJECT_CODE
            --  END IN (
            --          Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where
            --          (CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_CODE END) = P.data
            --          )
            --AND CASE WHEN @p_project_code = '' THEN ''
            --         ELSE A.PROJECT_NAME
            --  END IN (
            --          Select * from dbo.UF_FX_String_SplitForIN (@p_project_code,',') as P Where
            --          (CASE WHEN @p_project_code = '' THEN '' ELSE A.PROJECT_NAME END) = P.data
            --          )
            AND    (
                       EXISTS (
                           SELECT 1
                           FROM   (
                                      SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                                      FROM   DUAL
                                      CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                                  ) P
                           WHERE  A.PROJECT_CODE LIKE P.TOKEN || '%'
                       )
                       OR EXISTS (
                           SELECT 1
                           FROM   (
                                      SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                                      FROM   DUAL
                                      CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                                  ) P
                           WHERE  A.PROJECT_NAME LIKE P.TOKEN || '%'
                       )
                   )
            --AND    (   A.PROJECT_CODE LIKE '%'+ @p_project_code + '%'
            --   OR A.PROJECT_NAME LIKE '%'+ @p_project_code + '%'
            --)
            GROUP BY A.DIVISION_ID
                   , D.DIVISION_NAME
                   , A.PROJECT_CODE
                   , A.PROJECT_NAME
                   , A.PROJECT_STATUS
                   , A.BIZ_TYPE
                   , A.BIZ_TYPE_NAME
                   , BIZ.CODE
                   , BIZ.NAME
                   , A.CURRENCY
                   , A.PROJECT_OWNER
                   , TEAM.DEPT_ID
                   , TEAM.DEPT_NAME_KO
                   , C.END_CUSTOMER
            ORDER BY A.PROJECT_NAME
                   , A.PROJECT_CODE;

    ELSE  -- [PJ20200138] ETC Only인 경우에 Lookup 에서 Project List 조회

        OPEN O_RC1 FOR
            SELECT A.SEGMENT1   AS DIVISION_ID
                 , A.SEGMENT1   AS DIVISION_NAME
                 , A.SEGMENT2   AS PROJECT_CODE
                 , A.SEGMENT3   AS PROJECT_NAME
                 , ''           AS PROJECT_STATUS
                 , ''           AS BIZ_TYPE
                 , ''           AS BIZ_TYPE_NAME
                 , ''           AS CURRENCY
                 , ''           AS PROJECT_VER_SEQ
                 , ''           AS PROJECT_OWNER
                 , ''           AS DEPT_ID
                 , ''           AS DEPT_NAME_KO
                 , ''           AS END_CUSTOMER
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
            WHERE  A.LOOKUP_TYPE = 'DM_ETC_PROJECT'
            AND    A.VALID_YN    = 'Y'
            AND    A.SEGMENT1    = P_DIVISION_ID
            AND    EXISTS (
                       SELECT 1
                       FROM   (
                                  SELECT TRIM(REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL)) AS TOKEN
                                  FROM   DUAL
                                  CONNECT BY REGEXP_SUBSTR(P_PROJECT_CODE, '[^,]+', 1, LEVEL) IS NOT NULL
                              ) P
                       WHERE  A.SEGMENT2 LIKE P.TOKEN || '%'
                   );

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_DEPT_ID'      VALUE P_DEPT_ID,
            'P_END_CUSTOMER' VALUE P_END_CUSTOMER,
            'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID,
            'P_PROJECT_CODE' VALUE P_PROJECT_CODE,
            'P_ETC'          VALUE P_ETC
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_PROJECT_BY_DIVISION_POPUPEX;

/* ============================================================
   GTT DDL (별도 실행 - SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK 전용)

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SPNC_SHPCHK_NEW (
       DIVISION_ID          VARCHAR2(30  CHAR),
       PLAN_START_YYYYMMDD  VARCHAR2(8   CHAR),
       PLAN_TYPE            VARCHAR2(50  CHAR),
       SEQ                  VARCHAR2(30  CHAR),
       OPERATION_GROUP      VARCHAR2(30  CHAR),
       PROJECT_CODE         VARCHAR2(50  CHAR),
       ITEM_ID              VARCHAR2(50  CHAR),
       TO_SITE              VARCHAR2(30  CHAR),
       INCOTERMS            VARCHAR2(10  CHAR),
       FROM_SITE            VARCHAR2(30  CHAR),
       BOD_ID               VARCHAR2(150 CHAR),
       TRANSPORT_MODE       VARCHAR2(150 CHAR)
   ) ON COMMIT PRESERVE ROWS;
   /

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SPNC_SHPCHK_PLAN (
       DIVISION_ID          VARCHAR2(30  CHAR),
       PLAN_START_YYYYMMDD  VARCHAR2(8   CHAR),
       PLAN_TYPE            VARCHAR2(50  CHAR),
       SEQ                  VARCHAR2(30  CHAR),
       OPERATION_GROUP      VARCHAR2(30  CHAR),
       PROJECT_CODE         VARCHAR2(50  CHAR),
       ITEM_ID              VARCHAR2(50  CHAR),
       TO_SITE              VARCHAR2(30  CHAR),
       INCOTERMS            VARCHAR2(10  CHAR),
       FROM_SITE            VARCHAR2(30  CHAR),
       BOD_ID               VARCHAR2(150 CHAR)
   ) ON COMMIT PRESERVE ROWS;
   /

   CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_SPNC_SHPCHK_DUP (
       DIVISION_ID          VARCHAR2(30  CHAR),
       PLAN_START_YYYYMMDD  VARCHAR2(8   CHAR),
       PLAN_TYPE            VARCHAR2(50  CHAR),
       SEQ                  VARCHAR2(30  CHAR),
       OPERATION_GROUP      VARCHAR2(30  CHAR),
       PROJECT_CODE         VARCHAR2(50  CHAR),
       ITEM_ID              VARCHAR2(50  CHAR),
       TO_SITE              VARCHAR2(30  CHAR),
       INCOTERMS            VARCHAR2(10  CHAR),
       FROM_SITE            VARCHAR2(30  CHAR),
       BOD_ID               VARCHAR2(150 CHAR),
       TRANSPORT_MODE       VARCHAR2(150 CHAR)
   ) ON COMMIT PRESERVE ROWS;
   /
   ============================================================ */


/* ============================================================
   1. SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK
   ============================================================ */
PROCEDURE P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK
(
    P_DIVISION_ID          IN VARCHAR2,
    P_PLAN_START_YYYYMMDD  IN VARCHAR2,
    P_PLAN_TYPE            IN VARCHAR2,
    P_SEQ                  IN VARCHAR2,
    P_OPERATION_GROUP      IN VARCHAR2,
    P_PROJECT_CODE         IN VARCHAR2,
    P_ITEM_ID              IN VARCHAR2,
    P_TO_SITE              IN VARCHAR2,
    P_INCOTERMS            IN VARCHAR2,
    P_FROM_SITE            IN VARCHAR2,
    P_BOD_ID               IN VARCHAR2,
    P_TRANSPORT_MODE       IN VARCHAR2,
    P_PRGRAM_ID            IN VARCHAR2,
    O_RC1                  OUT SYS_REFCURSOR,
    O_RESULT_CURSOR        OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK
 * Description  : Shipment Plan FG/SEMI New 입력 Validation 체크
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/07/10 YHW           [CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
 * 2026.03.29 kimcd         [PJ20264226] NextSCM Pilot 설계 및 개발.
 *
 */
    $$PLSQL_UNIT      VARCHAR2(200  CHAR);
    V_DELIMITER         VARCHAR2(1   CHAR) := '^';
    V_MAX_LOOP_CNT      PLS_INTEGER        := 0;
    V_MST_LOOP_CNT      PLS_INTEGER        := 0;
    V_RESULT_DUP        PLS_INTEGER        := 0;

    V_PROJECT_CODE      VARCHAR2(50  CHAR);
    V_ITEM_ID           VARCHAR2(50  CHAR);
    V_TO_SITE           VARCHAR2(30  CHAR);
    V_INCOTERMS         VARCHAR2(10  CHAR);
    V_FROM_SITE         VARCHAR2(30  CHAR);
    V_BOD_ID            VARCHAR2(150 CHAR);
    V_TRANSPORT_MODE    VARCHAR2(150 CHAR);

    V_LOG_TYPE          VARCHAR2(30  CHAR);
    N_LOG_COUNT         PLS_INTEGER        := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500  CHAR);
    D_EVENT_DATE        DATE;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    /********************************************************************************
    * 임시테이블만들기 - 조회조건 테이블
    ********************************************************************************/
    -- 신규입력(다건)
    DELETE FROM SCM_MGR.GT_SPNC_SHPCHK_NEW;
    -- FG/SEMI 기존입력건
    DELETE FROM SCM_MGR.GT_SPNC_SHPCHK_PLAN;
    -- 중복입력건
    DELETE FROM SCM_MGR.GT_SPNC_SHPCHK_DUP;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    V_DESCRIPTION := 'BEFORE SCM_ARR_SPL_CNT';
    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_MGR.SCM_ARR_SPL_CNT(P_ITEM_ID, V_DELIMITER);

    V_DESCRIPTION := 'BEFORE GT_SPNC_SHPCHK_NEW';
    WHILE LENGTH(P_DIVISION_ID) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP
        -- @mst_loop_cnt 1증가
        V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        V_PROJECT_CODE   := SCM_ARR_SPL_VAL(P_PROJECT_CODE,   V_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID        := SCM_ARR_SPL_VAL(P_ITEM_ID,        V_DELIMITER, V_MST_LOOP_CNT);
        V_TO_SITE        := SCM_ARR_SPL_VAL(P_TO_SITE,        V_DELIMITER, V_MST_LOOP_CNT);
        V_INCOTERMS      := SCM_ARR_SPL_VAL(P_INCOTERMS,      V_DELIMITER, V_MST_LOOP_CNT);
        V_FROM_SITE      := SCM_ARR_SPL_VAL(P_FROM_SITE,      V_DELIMITER, V_MST_LOOP_CNT);
        V_BOD_ID         := SCM_ARR_SPL_VAL(P_BOD_ID,         V_DELIMITER, V_MST_LOOP_CNT);
        V_TRANSPORT_MODE := SCM_ARR_SPL_VAL(P_TRANSPORT_MODE, V_DELIMITER, V_MST_LOOP_CNT);

        INSERT INTO SCM_MGR.GT_SPNC_SHPCHK_NEW
        SELECT P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , P_OPERATION_GROUP
             , V_PROJECT_CODE
             , V_ITEM_ID
             , V_TO_SITE
             , V_INCOTERMS
             , V_FROM_SITE
             , V_BOD_ID
             , V_TRANSPORT_MODE
        FROM   DUAL;

    END LOOP;

    --SELECT * FROM GT_SPNC_SHPCHK_NEW

    IF P_PRGRAM_ID = 'FG' THEN
        V_DESCRIPTION := 'BEFORE FG GT_SPNC_SHPCHK_PLAN';
        INSERT INTO SCM_MGR.GT_SPNC_SHPCHK_PLAN
        SELECT DISTINCT DIVISION_ID
                      , PLAN_START_YYYYMMDD
                      , PLAN_TYPE
                      , SEQ
                      , BIZ_TYPE  AS OPERATION_GROUP
                      , PROJECT_CODE
                      , ITEM_ID
                      , TO_SITE
                      , INCOTERMS
                      , FROM_SITE
                      , BOD_ID
        FROM   SCM_MGR.SCP_ANL_SHIPMENT_PLAN_FG
        WHERE  DIVISION_ID          = P_DIVISION_ID
        AND    PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
        AND    PLAN_TYPE            = P_PLAN_TYPE
        AND    SEQ                  = P_SEQ
        AND    BIZ_TYPE             = P_OPERATION_GROUP
        AND    MEASURE             IN ('SHIP_PLAN_AMEND')
        AND    YYYYMMDD             = P_PLAN_START_YYYYMMDD;

        INSERT INTO SCM_MGR.GT_SPNC_SHPCHK_DUP
        SELECT A.*
        FROM   SCM_MGR.GT_SPNC_SHPCHK_NEW  A
        JOIN   SCM_MGR.GT_SPNC_SHPCHK_PLAN B ON A.PROJECT_CODE = B.PROJECT_CODE
                                            AND A.ITEM_ID      = B.ITEM_ID
                                            AND A.TO_SITE      = B.TO_SITE
                                            AND A.INCOTERMS    = B.INCOTERMS
                                            AND A.FROM_SITE    = B.FROM_SITE
                                            AND A.BOD_ID       = B.BOD_ID;

    ELSE
        V_DESCRIPTION := 'BEFORE SEMI GT_SPNC_SHPCHK_PLAN';

        INSERT INTO SCM_MGR.GT_SPNC_SHPCHK_PLAN
        SELECT DISTINCT DIVISION_ID
                      , PLAN_START_YYYYMMDD
                      , PLAN_TYPE
                      , SEQ
                      , OPERATION_GROUP
                      , '-'  AS PROJECT_CODE
                      , ITEM_ID
                      , '-'  AS TO_SITE
                      , '-'  AS INCOTERMS
                      , FROM_SITE
                      , BOD_ID
        FROM   SCM_MGR.SCP_ANL_SHIPMENT_PLAN_SEMI
        WHERE  DIVISION_ID          = P_DIVISION_ID
        AND    PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
        AND    PLAN_TYPE            = P_PLAN_TYPE
        AND    SEQ                  = P_SEQ
        AND    OPERATION_GROUP      = P_OPERATION_GROUP
        AND    MEASURE             IN ('SHIP_PLAN_AMEND')
        AND    YYYYMMDD             = P_PLAN_START_YYYYMMDD;

        INSERT INTO SCM_MGR.GT_SPNC_SHPCHK_DUP
        SELECT A.*
        FROM   SCM_MGR.GT_SPNC_SHPCHK_NEW  A
        JOIN   SCM_MGR.GT_SPNC_SHPCHK_PLAN B ON A.ITEM_ID   = B.ITEM_ID
                                            AND A.FROM_SITE = B.FROM_SITE
                                            AND A.BOD_ID    = B.BOD_ID;

    END IF;

    --SELECT * FROM GT_SPNC_SHPCHK_PLAN
    V_DESCRIPTION := 'BEFORE FG GT_SPNC_SHPCHK_DUP';

    SELECT COUNT(*) INTO V_RESULT_DUP FROM SCM_MGR.GT_SPNC_SHPCHK_DUP;

    IF V_RESULT_DUP > 0 THEN
        IF P_PRGRAM_ID = 'FG' THEN
            OPEN O_RC1 FOR
                SELECT 'D' AS RESULT_CODE
                     , ITEM_ID || ' / ' || FROM_SITE || ' / ' || TO_SITE || ' / ' || INCOTERMS || ' / ' || TRANSPORT_MODE AS MSG
                FROM   SCM_MGR.GT_SPNC_SHPCHK_DUP
                WHERE  ROWNUM = 1;
        ELSE
            OPEN O_RC1 FOR
                SELECT 'D' AS RESULT_CODE
                     , ITEM_ID || ' / ' || FROM_SITE || ' / ' || TRANSPORT_MODE AS MSG
                FROM   SCM_MGR.GT_SPNC_SHPCHK_DUP
                WHERE  ROWNUM = 1;
        END IF;
    ELSE
        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE, '' AS MSG FROM DUAL;
    END IF;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        -- V_DESCRIPTION := ''; 기존 설정된 값 사용.
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'         VALUE P_DIVISION_ID,
            'P_PLAN_START_YYYYMMDD' VALUE P_PLAN_START_YYYYMMDD,
            'P_PLAN_TYPE'           VALUE P_PLAN_TYPE,
            'P_SEQ'                 VALUE P_SEQ,
            'P_OPERATION_GROUP'     VALUE P_OPERATION_GROUP,
            --'P_PROJECT_CODE'        VALUE P_PROJECT_CODE, 크기 부족으로 제한
            --'P_ITEM_ID'             VALUE P_ITEM_ID,
            --'P_TO_SITE'             VALUE P_TO_SITE,
            --'P_INCOTERMS'           VALUE P_INCOTERMS,
            --'P_FROM_SITE'           VALUE P_FROM_SITE,
            --'P_BOD_ID'              VALUE P_BOD_ID,
            --'P_TRANSPORT_MODE'      VALUE P_TRANSPORT_MODE,
            'P_PRGRAM_ID'           VALUE P_PRGRAM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

        -- error코드, error 메시지 반환
        -- SELECT 'F' AS result_code, '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE() AS ERR_MESSAGE ;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_SHIPMENT_PLAN_NEW_CHECK;



/* ============================================================
   2. SCM0002_GET_SITE_ITEM_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_SITE_ITEM_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_PROJECT_CODE  IN VARCHAR2,
    P_SCM_SITE_ID   IN VARCHAR2,
    P_ITEM_ID       IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/****************************************************************************************************/
/* Program ID  : DM0003_GET_SITE_ITEM_BY_DIVISION_POP                                                 */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/10/24  SongDH       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2026.03.29  kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발.                                   */
/*                         원본 로직도 문제가 있음. 정보 조회되도록 수정 ITEM MASTE JOIN에서 SITE 조건 제외   */
/*                         DIVISION ID 컬럼을 SCM_MST_SITE_ITEM 테이블 정보 사용하도록 수정               */
/****************************************************************************************************/

/*****************************************************************************************************
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
******************************************************************************************************/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT I.DIVISION_ID
             , MIN(D.DIVISION_NAME)  AS DIVISION_NAME
             , P.PROJECT_CODE
             , P.PROJECT_NAME
             , S.SCM_SITE_ID
             , S.SITE_DESCRIPTION
             , I.ITEM_ID
             , T.ITEM_NAME
        FROM   SCM_MGR.SCM_MST_SITE_ITEM    I
             , SCM_MGR.SCM_MST_DIVISION     D
             , SCM_MGR.SCM_MST_PROJECT      P
             , SCM_MGR.SCM_MST_SITE         S
             , SCM_MGR.SCM_MST_ITEM_SN      T
        WHERE  I.DIVISION_ID  = D.DIVISION_ID
        AND    I.PROJECT_CODE = P.PROJECT_CODE
        AND    I.SCM_SITE_ID  = S.SCM_SITE_ID
        AND    I.DIVISION_ID  = T.DIVISION_ID
        -- AND    I.SCM_SITE_ID  = T.SITE_ID  2026.03.29  kimcd       [PJ20264226] NextSCM Pilot 설계 및 개발.
        --                                                            원본 로직도 문제가 있음. 정보 조회되도록 수정 ITEM MASTE JOIN에서 SITE 조건 제외
        AND    I.ITEM_ID      = T.ITEM_ID
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR I.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    I.PROJECT_CODE LIKE '%' || P_PROJECT_CODE || '%'
        AND    (
                   P_SCM_SITE_ID = 'ALL'
                   OR I.SCM_SITE_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_SCM_SITE_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    I.ITEM_ID LIKE '%' || P_ITEM_ID || '%'
        GROUP BY I.DIVISION_ID
               , P.PROJECT_CODE
               , P.PROJECT_NAME
               , S.SCM_SITE_ID
               , S.SITE_DESCRIPTION
               , I.ITEM_ID
               , T.ITEM_NAME
        ORDER BY I.DIVISION_ID
               , P.PROJECT_CODE
               , P.PROJECT_NAME
               , S.SCM_SITE_ID
               , S.SITE_DESCRIPTION
               , I.ITEM_ID
               , T.ITEM_NAME;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID'  VALUE P_DIVISION_ID,
            'P_PROJECT_CODE' VALUE P_PROJECT_CODE,
            'P_SCM_SITE_ID'  VALUE P_SCM_SITE_ID,
            'P_ITEM_ID'      VALUE P_ITEM_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_SITE_ITEM_BY_DIVISION_POPUP;



/* ============================================================
   3. SCM0002_GET_SOLDTO_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_SOLDTO_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_SOLDTO_CODE   IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_SOLDTO_BY_DIVISION_POPUP
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/01/25   songdh         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.29   kimcd          [PJ20264226] NextSCM Pilot 설계 및 개발.
 *
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT DISTINCT
               C.DIVISION_ID
             , D.DIVISION_NAME
             , C.SOLDTO_CODE
             , C.SOLDTO_DESCRIPTION
        FROM   SCM_MGR.SCM_MST_CUSTOMER  C
             , SCM_MGR.SCM_MST_DIVISION  D
        WHERE  C.DIVISION_ID = D.DIVISION_ID
        AND    C.VALID_YN    = 'Y'
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR C.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (   C.SOLDTO_CODE        LIKE '%' || P_SOLDTO_CODE || '%'
                OR C.SOLDTO_DESCRIPTION LIKE '%' || P_SOLDTO_CODE || '%'
               );

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_SOLDTO_CODE' VALUE P_SOLDTO_CODE
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_SOLDTO_BY_DIVISION_POPUP;



/* ============================================================
   4. SCM0002_GET_STORAGE_BY_DIVISION_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_STORAGE_BY_DIVISION_POPUP
(
    P_DIVISION_ID   IN VARCHAR2,
    P_STORAGE_ID    IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*============================================================================================================================
 * Program ID  : SCM0002_GET_STORAGE_BY_DIVISION_POPUP
 * Description : Procedure 작성 가이드
 * Usage       : Procedure 작성 시 참조하세요!
 * Parameter   :
 *
 *============================================================================================================================
 *    Date      In Charge Description
 *============================================================================================================================
 * 2017/12/05 SongDH        Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/20 JYE       STORAGE_DESCRIPTION 추가
 * 2020/02/27 P.C.I     [C20200224-000354] 자동차 사업부 SLOC 조회 시 7990, 7999를 제외한 799*가 조회됨
 * 2021/03/15 KUNIID        [C20210201-000592] Sales Site _ 가상_보류창고 validation 적용 건
 * 2026/01/08 JSSBAE        [E20260107-001541]_Sales Site - Sales Location 로직 개선
 * 2026.03.29 kimcd         [PJ20264226] NextSCM Pilot 설계 및 개발.
============================================================================================================================*/
/*============================================================================================================================
 ※ 작성 Rule
   1. 대문자, 소문자
      - 테이블, 컬럼, 변수는 소문자로 작성하고, 그 이외는 대문자로 통일
   2. Naming Rule - Prefix
      - 파라메터 : @p_
      - 변수 : 데이타 타입에 따라 @v_(문자), @n_(숫자), @d_(날짜)
   3. 들여쓰기 : 2 space
   4. 기타
      - SQL 수직 배치 : SQL 구문의 세로줄(왼쪽)로 맞춤, 컬럼이나 변수도 KEYWORD 이후 왼쪽 정렬
      - 콤마로 분리된 ID 가 여러 줄에 걸쳐 나올 때, 콤마를 라인의 처음에 위치
============================================================================================================================*/
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT S.DIVISION_ID, D.DIVISION_NAME, S.STORAGE_ID, S.PLANT_ID, S.STORAGE_DESCRIPTION  -- 20180620
        FROM   SCM_MGR.SCM_MST_SLOC       S
             , SCM_MGR.SCM_MST_DIVISION   D
        WHERE  S.DIVISION_ID = D.DIVISION_ID
-- Modify by ytchoi 180704 소형 VMI A,B 창고 조회 추가.
--  AND    s.STORAGE_ID like '6%'
--  AND    ( s.STORAGE_ID like '6%' OR s.STORAGE_ID like 'A%' OR s.STORAGE_ID like 'B%' )
-- Modify by jsyoun 799A 추가 (김성은책임요청)
-- [C20200224-000354] 자동차 사업부 SLOC 조회 시 7990, 7999를 제외한 799*가 조회됨
        AND    (   S.STORAGE_ID LIKE '6%'
                OR S.STORAGE_ID LIKE 'A%'
                OR S.STORAGE_ID LIKE 'B%'
                OR S.STORAGE_ID NOT IN ('7990', '7999')
               )
        -- CASE WHEN ALL → OR IN 분해
        AND    (
                   P_DIVISION_ID = 'ALL'
                   OR S.DIVISION_ID IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    S.STORAGE_ID LIKE '%' || P_STORAGE_ID || '%'
-- [C20210201-000592]
        AND    NOT EXISTS (
                   SELECT SEGMENT1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL LOOK
                   WHERE  LOOKUP_TYPE   = 'SALES_SITE_VS_WAREHOUSE'
                   AND    VALID_YN      = 'Y'
                   AND    LOOK.SEGMENT3 = P_DIVISION_ID
                   AND    LOOK.SEGMENT1 = S.STORAGE_ID
               )
        --[E20260107-001541]_GERP에서 NERP로 변경되었으므로, VALID_YN을 추가 (START)
        AND    S.VALID_YN = 'Y';
        --[E20260107-001541]_GERP에서 NERP로 변경되었으므로, VALID_YN을 추가 (END)

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_DIVISION_ID' VALUE P_DIVISION_ID,
            'P_STORAGE_ID'  VALUE P_STORAGE_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_STORAGE_BY_DIVISION_POPUP;



/* ============================================================
   5. SCM0002_GET_TEAM_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_TEAM_POPUP
(
    P_TEAM_ID     IN VARCHAR2,
    P_TEAM_NAME   IN VARCHAR2,
    P_CREATED_BY  IN VARCHAR2,
    P_USERINFO    IN VARCHAR2,
    O_RC1         OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : [SCM0002_GET_TEAM_POPUP]
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/15  Songdh    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/30  JYE       복수 팀 권한 관련  수정
 * 20180628    ytchoi    일반적인 팀 정보 조회 조건 수정 (@v_team_cnt <= 1  ☞ @v_team_cnt < 1)
 * 20200313    KHSONG    C20200103-000586 권한그룹을 LOOKUP관리
 * 20200507    P.C.I     C20200507-000080 W/S 권한으로 등록된 팀 추가
 * 20210107    P.C.I     [C20210104-000823] 자동차 사업부 신규 팀 선택의 건
 * 2026.03.29  kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발.
 */
    $$PLSQL_UNIT       VARCHAR2(200 CHAR);
    V_DEPT_ID            VARCHAR2(50  CHAR) := '';
    V_GROUP_ID           VARCHAR2(50  CHAR) := '';
    V_TEAM_CNT           PLS_INTEGER        := 0;  -- 다수 팀 권한
    V_ORG_DEPT_ID        VARCHAR2(50  CHAR) := '';  --[C20210104-000823] User Dept ID
    V_ORG_UPPER_DEPT_ID  VARCHAR2(50  CHAR) := '';  --[C20210104-000823] User Upper Dept ID(사업부)
    V_ADMIN_CNT          PLS_INTEGER        := 0;
    V_SALES_MGMT_CNT     PLS_INTEGER        := 0;

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    --[C20210104-000823] User Dept ID
    BEGIN
        SELECT DEPT_ID
        INTO   V_ORG_DEPT_ID
        FROM   SCM_MGR.SCM_ADM_USER_M
        WHERE  USER_ID = P_CREATED_BY;
    EXCEPTION WHEN NO_DATA_FOUND THEN V_ORG_DEPT_ID := ''; END;

    SELECT COUNT(SEGMENT3)
    INTO   V_TEAM_CNT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'PM_TEAM_MAPPING'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT1    = (SELECT DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID = P_CREATED_BY);

    --IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
    --  SET @v_group_id = 'ADMIN'

    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    SELECT NVL(COUNT(1), 0)
    INTO   V_ADMIN_CNT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'GET_ADMIN_GROUP'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT2    = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
    AND    SEGMENT1    = P_USERINFO;

    IF V_ADMIN_CNT > 0 THEN
        V_GROUP_ID := 'ADMIN';
    END IF;
    ---------------------------------------------------------------------------------
    --            20200313 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
    ---------------------------------------------------------------------------------

    -- [C20210104-000823] 영업관리팀인지 확인
    SELECT NVL(COUNT(1), 0)
    INTO   V_SALES_MGMT_CNT
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
    WHERE  LOOKUP_TYPE = 'SALES_MGMT_TEAM'
    AND    VALID_YN    = 'Y'
    AND    SEGMENT5    = 'Y'
    AND    SEGMENT1    = V_ORG_DEPT_ID;

    IF (V_TEAM_CNT < 1
        OR (V_SALES_MGMT_CNT > 0 AND V_GROUP_ID = 'ADMIN'))
    -- 일반적인 팀 정보 조회 -- modified by ytchoi 20180628
    THEN
        ---------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------
        BEGIN
            SELECT NVL((SELECT SEGMENT3
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                        AND    VALID_YN    = 'Y'
                        AND    SEGMENT1    = U.DEPT_ID
                        AND    ROWNUM      = 1
                       ), U.DEPT_ID)
            INTO   V_DEPT_ID
            FROM   SCM_MGR.SCM_ADM_USER_M U
            WHERE  U.USER_ID = P_CREATED_BY;
        EXCEPTION WHEN NO_DATA_FOUND THEN V_DEPT_ID := ''; END;

        --[C20210104-000823] 상위 DEPT
        BEGIN
            SELECT SEGMENT3
            INTO   V_ORG_UPPER_DEPT_ID
            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
            WHERE  LOOKUP_TYPE = 'SALES_MGMT_TEAM'
            AND    VALID_YN    = 'Y'
            AND    SEGMENT5    = 'Y'
            AND    SEGMENT1    = V_ORG_DEPT_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN V_ORG_UPPER_DEPT_ID := ''; END;

        OPEN O_RC1 FOR
            SELECT D.DEPT_ID
                 , D.DEPT_NAME_KO
                 , T.DEPT_ID      AS TEAM_ID
                 , T.DEPT_NAME_KO AS TEAM_NAME_KO
            FROM   SCM_MGR.SCM_MST_SSO_DEPT_INFO D
                 , SCM_MGR.SCM_MST_SSO_DEPT_INFO T
            WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
            AND    (   T."2LEVEL_DEPT_ID" IN ('58174290')  -- 전지사업부코드
            --Start C20200507-000080 W/S 권한으로 등록된 팀 추가
                   OR  T.DEPT_ID IN (
                           SELECT DISTINCT B.DEPT_ID
                           FROM   SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                           INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO B ON A.USER_ID = B.USER_ID
                           WHERE  1 = 1
                           AND    A.USER_GR_ID = 'DM Planner (W/S)')
                   AND T."2LEVEL_DEPT_ID" IS NOT NULL)
            --End C20200507-000080 W/S 권한으로 등록된 팀 추가
            AND    D.VALID_YN      = 'Y'
            AND    T.VALID_YN      = 'Y'
            AND    D.DEPT_NAME_KO <> '_'
            --AND    D.DEPT_ID <> T.DEPT_ID
            AND    T.DEPT_ID      LIKE '%' || P_TEAM_ID || '%'
            AND    (   T.DEPT_NAME_KO LIKE '%' || P_TEAM_NAME || '%'
                    OR T.DEPT_NAME_EN LIKE '%' || P_TEAM_NAME || '%'
                    OR T.DEPT_NAME_CN LIKE '%' || P_TEAM_NAME || '%'
                   )
        -- 팀, 권한에 대한 것
            AND    T.DEPT_ID      = CASE WHEN V_GROUP_ID = 'ADMIN' THEN T.DEPT_ID ELSE V_DEPT_ID END
            AND    T.ATTRIBUTE2   LIKE '%' || V_ORG_UPPER_DEPT_ID || '%'  --[C20210104-000823] 상위 DEPT 조건 추가
            /*
            AND    CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN'
                    ELSE T.DEPT_ID END = CASE WHEN @v_group_id = 'ADMIN' THEN 'ADMIN' ELSE @v_dept_id END
            */
            ORDER BY D.DEPT_NAME_KO, D.DEPT_ID;
        ---------------------------------------------------------------------------------
        ---------------------------------------------------------------------------------

    ELSE
        ---------------------------------------------------------------------------------
        -- 복수 팀 권한 조회
        ---------------------------------------------------------------------------------
        OPEN O_RC1 FOR
            SELECT D.DEPT_ID
                 , D.DEPT_NAME_KO
                 , T.DEPT_ID      AS TEAM_ID
                 , T.DEPT_NAME_KO AS TEAM_NAME_KO
            FROM   SCM_MGR.SCM_MST_SSO_DEPT_INFO D
                 , SCM_MGR.SCM_MST_SSO_DEPT_INFO T
            WHERE  T.UPPER_DEPT_ID = D.DEPT_ID
            AND    (   T."2LEVEL_DEPT_ID" IN ('58174290')  -- 전지사업부코드
            --Start C20200507-000080 W/S 권한으로 등록된 팀 추가
                   OR  T.DEPT_ID IN (
                           SELECT DISTINCT B.DEPT_ID
                           FROM   SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                           INNER JOIN SCM_MGR.SCM_MST_SSO_USER_INFO B ON A.USER_ID = B.USER_ID
                           WHERE  1 = 1
                           AND    A.USER_GR_ID = 'DM Planner (W/S)')
                   AND T."2LEVEL_DEPT_ID" IS NOT NULL)
            --End C20200507-000080 W/S 권한으로 등록된 팀 추가
            AND    D.VALID_YN      = 'Y'
            AND    T.VALID_YN      = 'Y'
            AND    D.DEPT_NAME_KO <> '_'
            AND    T.DEPT_ID IN (
                       SELECT SEGMENT3
                       FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                       WHERE  LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                       AND    VALID_YN    = 'Y'
                       AND    SEGMENT1    = (SELECT U.DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M U WHERE U.USER_ID = P_CREATED_BY)
                       --2018/05/30  JYE            복수 팀 권한 관련  수정
                       UNION
                       SELECT U.DEPT_ID
                       FROM   SCM_MGR.SCM_ADM_USER_M U
                       WHERE  U.USER_ID = P_CREATED_BY
                       --2018/05/30  JYE            복수 팀 권한 관련  수정
                   )
            ORDER BY D.DEPT_NAME_KO, D.DEPT_ID;
        ---------------------------------------------------------------------------------

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_TEAM_ID'    VALUE P_TEAM_ID,
            'P_TEAM_NAME'  VALUE P_TEAM_NAME,
            'P_CREATED_BY' VALUE P_CREATED_BY,
            'P_USERINFO'   VALUE P_USERINFO
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_TEAM_POPUP;



/* ============================================================
   6. SCM0002_GET_VENDOR_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_VENDOR_POPUP
(
    P_VENDOR_CODE   IN VARCHAR2,
    P_VENDOR_NAME   IN VARCHAR2,
    P_PAKER         IN VARCHAR2,
    O_RC1           OUT SYS_REFCURSOR,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_GET_VENDOR_POPUP
 * Description  : Vendor 조회 Popup
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/11   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2026.03.29   kimcd          [PJ20264226] NextSCM Pilot 설계 및 개발.
 *
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    OPEN O_RC1 FOR
        SELECT DISTINCT
               T.COMPANY_ID
             , T.VENDOR_CODE
             , T.VENDOR_NAME
             , T.REPRESENTATIVE
             , T.COUNTRY
             , T.VENDOR_ADDRESS
             , T.PACKER_YN
        FROM   SCM_MGR.SCM_MST_VENDOR T
        WHERE  1 = 1
        AND    (
                   P_PAKER IS NULL
                   OR T.PACKER_YN IN (
                          SELECT TRIM(REGEXP_SUBSTR(P_PAKER, '[^,]+', 1, LEVEL))
                          FROM   DUAL
                          CONNECT BY REGEXP_SUBSTR(P_PAKER, '[^,]+', 1, LEVEL) IS NOT NULL
                      )
               )
        AND    (P_VENDOR_CODE IS NULL OR T.VENDOR_CODE LIKE '%' || P_VENDOR_CODE || '%')
        AND    (P_VENDOR_NAME IS NULL OR T.VENDOR_NAME LIKE '%' || P_VENDOR_NAME || '%');

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_VENDOR_CODE' VALUE P_VENDOR_CODE,
            'P_VENDOR_NAME' VALUE P_VENDOR_NAME,
            'P_PAKER'       VALUE P_PAKER
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_VENDOR_POPUP;

/* ============================================================
   1. SCM0002_GET_VERSIONBYWATERFALLPOPUP
   ============================================================ */
PROCEDURE P_SCM0002_GET_VERSIONBYWATERFALLPOPUP
(
    P_START_YYYYMMDD  IN VARCHAR2,
    P_END_YYYYMMDD    IN VARCHAR2,
    P_CREATED_BY      IN VARCHAR2,
    P_DIVISION_ID     IN VARCHAR2,
    P_VERSION_TYPE    IN VARCHAR2,
    P_VERSION_NO      IN VARCHAR2,
    O_RC1             OUT SYS_REFCURSOR,
    O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
/************************************************************************************************
 Program ID  : DM0035_GET_SPREAD_TITLE
 Description : Procedure 작성 가이드
 Usage       : Procedure 작성 시 참조하세요!
 Parameter   :

-------------------------------------------------------------------------------------------------
 Date        In Charge    Description
-------------------------------------------------------------------------------------------------
 2018/03/12  SeungJae.Hwnag       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 20200714     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외(화요일에 Sales Paln Cutoff 제외하고 생성된 SP Version)
 20200722     P.C.I       [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외 원복
 2021/07/03   HWI1993   하반기과제 속도개선 - 데이터 이동보관 처리
 2021/12/13     kdw2819   [과제 ]EDI Waterfall 조회 조건 추가
 2022/02/24   kdw2819   [과제][PJ20216891R] LGES Digital SCM 3 Level 가속화를 위한 개선 - BMW EDI WATERFALL
 2022/06/07     kdw2819   business plan waterfall
 2022/06/22     kdw2819   [C20220620-000557] GSCM DM 영역내, Version에 주차표기
 2022/09/30     rosia27   [C20220929-000333] Plan이 없는 휴무 주차에는 PLAN명 뒤에 (NO PLAN)을 기입
 2023/05/03   kdmcc14 [EDI과제]
 2025/02/20   dsiol     [PJ2025-50017]LGES SCM DM 소형사업부 매출계획 동기화 개선          -- 1. MF_SP 추가
 2025/04/23   dsiol     [PJ2025-50188]소형 매출계획 동기화 개선 고도화 : SCM_FCST - MEASURE 추가 -- 1. MF_SP를 MF_SP_SF으로 변경 / 2. MF_SF 추가
 2026.03.31   kimcd     [PJ20264226] NextSCM Pilot 설계 및 개발.
******************************************************************************************************/
    $$PLSQL_UNIT    VARCHAR2(200  CHAR);
    V_VERSION_TYPE    VARCHAR2(100  CHAR);

    V_PROC_INPUT      VARCHAR2(4000 CHAR);
    V_BACKTRACE       VARCHAR2(4000 CHAR);
    V_SQL_CODE        VARCHAR2(100  CHAR);
    V_SQL_ERRMSG      VARCHAR2(1000 CHAR);
    V_LOG_TYPE        VARCHAR2(100  CHAR);
    V_LOG_MESSAGE     VARCHAR2(4000 CHAR);
    V_DESCRIPTION     VARCHAR2(4000 CHAR);
    N_LOG_COUNT       PLS_INTEGER        := 0;
    D_EVENT_DATE      DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    -- [과제 ]EDI Waterfall 조회 조건 추가 - EDI VERSION 조회시 CURRENT 제외
    IF INSTR(P_VERSION_TYPE, 'EC') != 0 THEN
        V_DESCRIPTION := 'EC IN CASE';

        OPEN O_RC1 FOR
            SELECT VERSION_NO AS CODE
                 , VERSION_NO || '(' || B.WEEK_NAME || ')' AS VERSION_NO
                 , VERSION_DESCRIPTION
                 , VERSION_TYPE
                 , ''  AS EDI_APPLY
                 , VER_CRE_SEQ
                 , YYYYMMDD
                 , MAX(CREATED_BY)      AS CREATED_BY
                 , MAX(CREATION_DATE)   AS CREATION_DATE
            FROM   SCM_MGR.DM_MST_VERSION     A
            INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
            WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
            AND    DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            AND    VERSION_TYPE IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            AND    EXISTS (
                       SELECT 1
                       FROM   (
                                  SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                                  FROM   DUAL
                                  CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
                              ) P
                       WHERE  VERSION_NO LIKE P.TOKEN || '%'
                   )
            AND    ( NVL(ATTRIBUTE1, '') <> 'MOVE' OR ATTRIBUTE1 IS NULL )
            --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
            GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME
            ORDER BY CODE DESC, VERSION_NO DESC;

    ELSIF INSTR(P_VERSION_TYPE, 'BP') != 0 THEN
        V_DESCRIPTION := 'BP IN CASE';

        OPEN O_RC1 FOR
            SELECT 'BP_Z_CURRENT' AS CODE
                 , 'Current'      AS VERSION_NO
                 , 'Current'      AS VERSION_DESCRIPTION
                 , ''             AS VERSION_TYPE
                 , ''             AS EDI_APPLY
                 , CASE WHEN 1 = 2 THEN 1 ELSE NULL END AS VER_CRE_SEQ
                 , ''             AS YYYYMMDD
                 , ''             AS CREATED_BY
                 , SYSDATE        AS CREATION_DATE
            FROM   DUAL
            UNION ALL
            SELECT VERSION_NO AS CODE
                 , VERSION_NO || '(' || B.WEEK_NAME || ')' AS VERSION_NO
                 , VERSION_DESCRIPTION
                 , VERSION_TYPE
                 , ''         AS EDI_APPLY
                 , VER_CRE_SEQ
                 , YYYYMMDD
                 , CREATED_BY
                 , CREATION_DATE
            FROM   SCM_MGR.DM_MST_VERSION     A
            INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
            WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
            AND    DIVISION_ID = P_DIVISION_ID
            AND    VERSION_TYPE IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            AND    VERSION_DESCRIPTION LIKE P_VERSION_NO || '%'
            AND    ( NVL(ATTRIBUTE1, '') <> 'MOVE' OR ATTRIBUTE1 IS NULL )
            ORDER BY CODE DESC, VERSION_NO DESC;

    ELSIF INSTR(P_VERSION_TYPE, 'MF_SP_SF') != 0 THEN  --[PJ2025-50188] MF_SP를 MF_SP_SF으로 변경
                                                         -- 작성기준 DMF0082_FcstNPrice_Mgmt.cs 에서 호출
        V_DESCRIPTION := 'MF_SP_SF IN CASE';

        V_VERSION_TYPE := '';
        --EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP '20250101','20250531','test','40','MF_SP_SF_D,MF_SP_SF_W,MF_SP_SF_M',''
        IF INSTR(P_VERSION_TYPE, 'MF_SP_SF_D') != 0 THEN
            V_VERSION_TYPE := 'SP_D,MF_D,SF_D,';
        END IF;
        IF INSTR(P_VERSION_TYPE, 'MF_SP_SF_W') != 0 THEN
            V_VERSION_TYPE := V_VERSION_TYPE || 'SP_W,MF_W,SF_W,';
        END IF;
        IF INSTR(P_VERSION_TYPE, 'MF_SP_SF_M') != 0 THEN
            V_VERSION_TYPE := V_VERSION_TYPE || 'SP_M,MF_M,SF_M,';
        END IF;

        -- LEFT(@V_VERSION_TYPE, LEN(@V_VERSION_TYPE)-1) → 마지막 쉼표 제거
        V_VERSION_TYPE := SUBSTR(V_VERSION_TYPE, 1, LENGTH(V_VERSION_TYPE) - 1);

        OPEN O_RC1 FOR
            SELECT * FROM (
                SELECT 'CURRENT' AS CODE
                     , 'Current' AS VERSION_NO
                     , 'Current' AS VERSION_DESCRIPTION
                     , ''        AS VERSION_TYPE
                     , ''        AS EDI_APPLY
                     , CASE WHEN 1 = 2 THEN 1 ELSE NULL END AS VER_CRE_SEQ
                     , ''        AS YYYYMMDD
                     , ''        AS CREATED_BY
                     , SYSDATE   AS CREATION_DATE
                FROM   DUAL
                UNION ALL
                SELECT VERSION_NO AS CODE
                     , CASE WHEN C.DM_RTF_YN = ''
                                 THEN VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                                 ELSE VERSION_NO || '(' || B.WEEK_NAME || ')'
                            END AS VERSION_NO
                     , VERSION_DESCRIPTION
                     , VERSION_TYPE
                     , CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y' ELSE '' END AS EDI_APPLY
                     , VER_CRE_SEQ
                     , YYYYMMDD
                     , MAX(CREATED_BY)      AS CREATED_BY
                     , MAX(CREATION_DATE)   AS CREATION_DATE
                FROM   SCM_MGR.DM_MST_VERSION       A
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
                LEFT  JOIN SCM_MGR.SCP_PLN_INTERFACE_YN C
                       ON  A.DIVISION_ID       = C.DIVISION_ID
                       AND B.BASIS_START_DATE  = C.PLAN_START_YYYYMMDD
                WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
                AND    A.DIVISION_ID IN (
                           SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                AND    VERSION_TYPE IN (
                           SELECT TRIM(REGEXP_SUBSTR(V_VERSION_TYPE, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(V_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                AND    EXISTS (
                           SELECT 1
                           FROM   (
                                      SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                                      FROM   DUAL
                                      CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
                                  ) P
                           WHERE  VERSION_NO LIKE P.TOKEN || '%'
                       )
                AND    ( NVL(ATTRIBUTE1, '') <> 'MOVE' OR ATTRIBUTE1 IS NULL )
                --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
                GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN
            ) A
            --팝업에 표시되는 기준 CURRENT가 제일 위, 그 다음은 코드에 상관없이 최근 생성 시간순으로 정렬 (필요시 아래 참고해서 변경바람)
            ORDER BY CASE WHEN CODE = 'CURRENT'          THEN 1  --팝업에 표시되는 순서1
                          --WHEN INSTR(CODE,'SP') <> 0   THEN 2  --팝업에 표시되는 순서2
                          --WHEN INSTR(CODE,'MF') <> 0   THEN 3  --팝업에 표시되는 순서3
                          --WHEN INSTR(CODE,'SF') <> 0   THEN 4  --팝업에 표시되는 순서4
                          ELSE 5
                          --END, VERSION_NO DESC
                     END, CREATION_DATE DESC;

    ELSIF INSTR(P_VERSION_TYPE, 'MF_SF') != 0 THEN  --[PJ2025-50188] 2. MF_SF 추가
                                                      -- 작성기준 DMF0035_MktFcstWaterfall.cs 에서 호출
        V_DESCRIPTION := 'MF_SF IN CASE';

        V_VERSION_TYPE := '';
        --EXEC SCM0002_GET_VERSIONBYWATERFALLPOPUP '20250101','20250531','test','40','MF_SF_D,MF_SF_W,MF_SF_M',''
        IF INSTR(P_VERSION_TYPE, 'MF_SF_D') != 0 THEN
            V_VERSION_TYPE := 'MF_D,SF_D,';
        END IF;
        IF INSTR(P_VERSION_TYPE, 'MF_SF_W') != 0 THEN
            V_VERSION_TYPE := V_VERSION_TYPE || 'MF_W,SF_W,';
        END IF;
        IF INSTR(P_VERSION_TYPE, 'MF_SF_M') != 0 THEN
            V_VERSION_TYPE := V_VERSION_TYPE || 'MF_M,SF_M,';
        END IF;

        V_VERSION_TYPE := SUBSTR(V_VERSION_TYPE, 1, LENGTH(V_VERSION_TYPE) - 1);

        OPEN O_RC1 FOR
            SELECT * FROM (
                SELECT 'CURRENT' AS CODE
                     , 'Current' AS VERSION_NO
                     , 'Current' AS VERSION_DESCRIPTION
                     , ''        AS VERSION_TYPE
                     , ''        AS EDI_APPLY
                     , CASE WHEN 1 = 2 THEN 1 ELSE NULL END AS VER_CRE_SEQ
                     , ''        AS YYYYMMDD
                     , ''        AS CREATED_BY
                     , SYSDATE   AS CREATION_DATE
                FROM   DUAL
                UNION ALL
                SELECT VERSION_NO AS CODE
                     , CASE WHEN C.DM_RTF_YN = ''
                                 THEN VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                                 ELSE VERSION_NO || '(' || B.WEEK_NAME || ')'
                            END AS VERSION_NO
                     , VERSION_DESCRIPTION
                     , VERSION_TYPE
                     , CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y' ELSE '' END AS EDI_APPLY
                     , VER_CRE_SEQ
                     , YYYYMMDD
                     , MAX(CREATED_BY)      AS CREATED_BY
                     , MAX(CREATION_DATE)   AS CREATION_DATE
                FROM   SCM_MGR.DM_MST_VERSION       A
                INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
                LEFT  JOIN SCM_MGR.SCP_PLN_INTERFACE_YN C
                       ON  A.DIVISION_ID       = C.DIVISION_ID
                       AND B.BASIS_START_DATE  = C.PLAN_START_YYYYMMDD
                WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
                AND    A.DIVISION_ID IN (
                           SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                AND    VERSION_TYPE IN (
                           SELECT TRIM(REGEXP_SUBSTR(V_VERSION_TYPE, '[^,]+', 1, LEVEL))
                           FROM   DUAL
                           CONNECT BY REGEXP_SUBSTR(V_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
                       )
                AND    EXISTS (
                           SELECT 1
                           FROM   (
                                      SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                                      FROM   DUAL
                                      CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
                                  ) P
                           WHERE  VERSION_NO LIKE P.TOKEN || '%'
                       )
                AND    ( NVL(ATTRIBUTE1, '') <> 'MOVE' OR ATTRIBUTE1 IS NULL )
                --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
                GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN
            ) A
            --팝업에 표시되는 기준 CURRENT가 제일 위, 그 다음은 코드에 상관없이 최근 생성 시간순으로 정렬 (필요시 아래 참고해서 변경바람)
            ORDER BY CASE WHEN CODE = 'CURRENT'          THEN 1     --팝업에 표시되는 순서1
                          --WHEN INSTR(CODE,'SP') <> 0   THEN 2     --팝업에 표시되는 순서2
                          --WHEN INSTR(CODE,'MF') <> 0   THEN 3     --팝업에 표시되는 순서3
                          --WHEN INSTR(CODE,'SF') <> 0   THEN 4     --팝업에 표시되는 순서4
                          ELSE 5
                          --END, VERSION_NO DESC
                     END, CREATION_DATE DESC;

    ELSE
        V_DESCRIPTION := 'ELSE CASE';

        OPEN O_RC1 FOR
            SELECT 'SP_Z_CURRENT' AS CODE
                 , 'Current'      AS VERSION_NO
                 , 'Current'      AS VERSION_DESCRIPTION
                 , ''             AS VERSION_TYPE
                 , ''             AS EDI_APPLY
                 , CASE WHEN 1 = 2 THEN 1 ELSE NULL END AS VER_CRE_SEQ
                 , ''             AS YYYYMMDD
                 , ''             AS CREATED_BY
                 , SYSDATE        AS CREATION_DATE
            FROM   DUAL
            UNION ALL
            SELECT VERSION_NO AS CODE
                 , CASE WHEN C.DM_RTF_YN = ''
                             THEN VERSION_NO || '(' || B.WEEK_NAME || ') (NO PLAN)'
                             ELSE VERSION_NO || '(' || B.WEEK_NAME || ')'
                        END AS VERSION_NO
                 , VERSION_DESCRIPTION
                 , VERSION_TYPE
                 , CASE WHEN VERSION_TYPE = 'ME_S' THEN 'Y' ELSE '' END AS EDI_APPLY
                 , VER_CRE_SEQ
                 , YYYYMMDD
                 , MAX(CREATED_BY)      AS CREATED_BY
                 , MAX(CREATION_DATE)   AS CREATION_DATE
            FROM   SCM_MGR.DM_MST_VERSION       A
            INNER JOIN SCM_MGR.SCM_SYS_CALENDAR_M B ON A.YYYYMMDD = B.BASIS_YYYYMMDD
            LEFT  JOIN SCM_MGR.SCP_PLN_INTERFACE_YN C
                   ON  A.DIVISION_ID       = C.DIVISION_ID
                   AND B.BASIS_START_DATE  = C.PLAN_START_YYYYMMDD
            WHERE  (YYYYMMDD >= P_START_YYYYMMDD AND YYYYMMDD <= P_END_YYYYMMDD)
            AND    A.DIVISION_ID IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_DIVISION_ID, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            AND    VERSION_TYPE IN (
                       SELECT TRIM(REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL))
                       FROM   DUAL
                       CONNECT BY REGEXP_SUBSTR(P_VERSION_TYPE, '[^,]+', 1, LEVEL) IS NOT NULL
                   )
            AND    EXISTS (
                       SELECT 1
                       FROM   (
                                  SELECT TRIM(REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL)) AS TOKEN
                                  FROM   DUAL
                                  CONNECT BY REGEXP_SUBSTR(P_VERSION_NO, '[^,]+', 1, LEVEL) IS NOT NULL
                              ) P
                       WHERE  VERSION_NO LIKE P.TOKEN || '%'
                   )
            AND    ( NVL(ATTRIBUTE1, '') <> 'MOVE' OR ATTRIBUTE1 IS NULL )
            --AND CREATED_BY <> 'WITHOUT_SP_W' -- [PJ20200138] Created_by 'WITHOUT_SP_W' 는 제외
            GROUP BY VERSION_NO, VERSION_DESCRIPTION, VERSION_TYPE, VER_CRE_SEQ, YYYYMMDD, B.WEEK_NAME, C.DM_RTF_YN
            ORDER BY CODE DESC, VERSION_NO DESC;

    END IF;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, CASE WHEN 1 = 2 THEN '-' ELSE NULL END AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_START_YYYYMMDD' VALUE P_START_YYYYMMDD,
            'P_END_YYYYMMDD'   VALUE P_END_YYYYMMDD,
            'P_CREATED_BY'     VALUE P_CREATED_BY,
            'P_DIVISION_ID'    VALUE P_DIVISION_ID,
            'P_VERSION_TYPE'   VALUE P_VERSION_TYPE,
            'P_VERSION_NO'     VALUE P_VERSION_NO
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_GET_VERSIONBYWATERFALLPOPUP;


/* ============================================================
   2. SCM0002_SET_DEFAULT_TITLESET_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_SET_DEFAULT_TITLESET_POPUP
(
    P_PROGRAM_ID    IN VARCHAR2,
    P_SHEET_NAME    IN VARCHAR2,
    P_COLUMN_TYPE   IN VARCHAR2,
    P_USER_ID       IN VARCHAR2,
    O_RESULT_CURSOR OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_SET_DEFAULT_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018.06.19   윤혜원      유저컬럼 조회 조건 수정
 * 2026.03.31   kimcd        [PJ20264226] NextSCM Pilot 설계 및 개발.
 *
 */
    $$PLSQL_UNIT  VARCHAR2(200 CHAR);

    V_PROC_INPUT    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_SQL_CODE      VARCHAR2(100  CHAR);
    V_SQL_ERRMSG    VARCHAR2(1000 CHAR);
    V_LOG_TYPE      VARCHAR2(100  CHAR);
    V_LOG_MESSAGE   VARCHAR2(4000 CHAR);
    V_DESCRIPTION   VARCHAR2(4000 CHAR);
    N_LOG_COUNT     PLS_INTEGER        := 0;
    D_EVENT_DATE    DATE               := SYSDATE;

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    IF P_COLUMN_TYPE = 'C' THEN
        -- Column
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
              ( USER_ID    , PROGRAM_ID   , SHEET_NAME                   , USER_INQUIRY_COLUMN_TYPE_CODE
              , COLUMN_NAME, SORT_ORDER_NO, DATA_SORT_METHOD_CODE
              , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT P_USER_ID   , B.PROGRAM_ID , B.SHEET_NAME                 , P_COLUMN_TYPE
             , B.COLUMN_NAME
             , RANK() OVER (ORDER BY B.SORT_ORDER_NO)
             , SCM_MGR.FN_SCM_SYS_NVL(B.DATA_SORT_METHOD_CODE, 'ASC')
             , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS B
        WHERE  B.PROGRAM_ID    = P_PROGRAM_ID
        AND    B.SHEET_NAME    = NVL(P_SHEET_NAME, B.SHEET_NAME)
        AND    B.VALID_YN      = 'Y'
        --AND    b.user_selectable_flag = 'Y'
        AND    B.DEFAULT_FLAG  = 'Y'
        AND    NVL(B.ATTRIBUTE6, 'Y') <> ''
        AND    NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER U
                   WHERE  U.USER_ID                      = P_USER_ID
                   AND    U.PROGRAM_ID                   = B.PROGRAM_ID
                   AND    U.SHEET_NAME                   = B.SHEET_NAME
                   AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE
               );
    ELSE
        -- Measure
        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
              ( USER_ID    , PROGRAM_ID   , SHEET_NAME , USER_INQUIRY_COLUMN_TYPE_CODE
              , COLUMN_NAME, SORT_ORDER_NO, DATA_SORT_METHOD_CODE
              , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
        SELECT P_USER_ID   , B.PROGRAM_ID , B.SHEET_NAME, P_COLUMN_TYPE
             , B.COLUMN_NAME, B.SORT_ORDER_NO, NULL
             , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
        FROM   SCM_MGR.SCM_MST_SHEET_MEASURE B
        WHERE  B.PROGRAM_ID   = P_PROGRAM_ID
        AND    B.SHEET_NAME   = NVL(P_SHEET_NAME, B.SHEET_NAME)
        AND    B.DEFAULT_FLAG = 'Y'
        AND    NOT EXISTS (
                   SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER U
                   WHERE  U.USER_ID                      = P_USER_ID
                   AND    U.PROGRAM_ID                   = B.PROGRAM_ID
                   AND    U.SHEET_NAME                   = B.SHEET_NAME
                   AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE
               );
    END IF;

    N_LOG_COUNT := SQL%ROWCOUNT;
    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_PROGRAM_ID'   VALUE P_PROGRAM_ID,
            'P_SHEET_NAME'   VALUE P_SHEET_NAME,
            'P_COLUMN_TYPE'  VALUE P_COLUMN_TYPE,
            'P_USER_ID'      VALUE P_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_SET_DEFAULT_TITLESET_POPUP;


/* ============================================================
   3. SCM0002_SET_TITLESET_POPUP
   ============================================================ */
PROCEDURE P_SCM0002_SET_TITLESET_POPUP
(
    P_PROGRAM_ID        IN VARCHAR2,
    P_SHEET_NAME        IN VARCHAR2,
    P_COLUMN_TYPE       IN VARCHAR2,
    P_ACTIVE_FLAG       IN VARCHAR2,
    P_COLUMN_NAME       IN VARCHAR2,
    P_SORT_ORDER_NO     IN VARCHAR2,
    P_SUB_TOTAL_FLAG    IN VARCHAR2,
    P_SORT_METHOD_CODE  IN VARCHAR2,
    P_USER_ID           IN VARCHAR2,
    O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
AS
/*
 * Program ID   : SCM0002_SET_TITLESET_POPUP
 * Description  : Column Setting, Measure Setting
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017.11.21   정병훈         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2024.11.06   jahn1502       UI 컬럼 0처리로 인해 'SCP0104','SCP0105','SCP0106','SCP0107','SCP0108' 화면 별도 설정
 * 2026.03.31   kimcd         [PJ20264226] NextSCM Pilot 설계 및 개발.
 */
    $$PLSQL_UNIT      VARCHAR2(200  CHAR);

    RECV_ACTIVE_FLAG    VARCHAR2(400 CHAR);
    V_PROGRAM_ID        VARCHAR2(400 CHAR);
    V_SHEET_NAME        VARCHAR2(400 CHAR);
    V_COLUMN_TYPE       VARCHAR2(400 CHAR);
    V_ACTIVE_FLAG       VARCHAR2(400 CHAR);
    V_COLUMN_NAME       VARCHAR2(400 CHAR);
    V_SORT_ORDER_NO     VARCHAR2(400 CHAR);
    V_SUB_TOTAL_FLAG    VARCHAR2(400 CHAR);
    V_SORT_METHOD_CODE  VARCHAR2(400 CHAR);
    V_USER_ID           VARCHAR2(400 CHAR);

    V_DELIMITER         VARCHAR2(10   CHAR) := '^';
    V_MAX_LOOP_CNT      PLS_INTEGER        := 0;
    V_MST_LOOP_CNT      PLS_INTEGER        := 0;

    -- LOG 용 변수 설정
    V_LOG_TYPE          VARCHAR2(300  CHAR);  -- START/END/ERROR/...
    N_LOG_COUNT         PLS_INTEGER        := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(1000 CHAR);
    D_EVENT_DATE        DATE;

    V_PROC_INPUT        VARCHAR2(4000 CHAR);
    V_BACKTRACE         VARCHAR2(4000 CHAR);
    V_SQL_CODE          VARCHAR2(100  CHAR);
    V_SQL_ERRMSG        VARCHAR2(1000 CHAR);

BEGIN
    -- 프로그램명 설정 (패키지 바디 이관 시 패키지명.프로시저명 자동 기록)
    IF UTL_CALL_STACK.SUBPROGRAM(1).COUNT > 1 THEN
        $$PLSQL_UNIT := $$PLSQL_UNIT || '.' || UTL_CALL_STACK.SUBPROGRAM(1)(2);
    ELSE
        $$PLSQL_UNIT := $$PLSQL_UNIT;
    END IF;

    RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;

    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_MGR.SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);
    V_DESCRIPTION := 'BEFORE DELETE';

    DELETE FROM SCM_MGR.SCM_MST_TITLESET_USER
    WHERE  USER_ID                       = P_USER_ID
    AND    PROGRAM_ID                    = P_PROGRAM_ID
    AND    SHEET_NAME                    = P_SHEET_NAME
    AND    USER_INQUIRY_COLUMN_TYPE_CODE = P_COLUMN_TYPE;

    V_DESCRIPTION := 'BEFORE WHILE';

    WHILE LENGTH(RECV_ACTIVE_FLAG) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP
        V_DESCRIPTION := 'IN WHILE : ' || TO_CHAR(V_MST_LOOP_CNT);
        -- @mst_loop_cnt 1증가
        V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        V_ACTIVE_FLAG      := SCM_MGR.SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,      V_DELIMITER, V_MST_LOOP_CNT);
        V_COLUMN_NAME      := SCM_MGR.SCM_ARR_SPL_VAL(P_COLUMN_NAME,      V_DELIMITER, V_MST_LOOP_CNT);
        V_SORT_ORDER_NO    := SCM_MGR.SCM_ARR_SPL_VAL(P_SORT_ORDER_NO,    V_DELIMITER, V_MST_LOOP_CNT);
        V_SUB_TOTAL_FLAG   := SCM_MGR.SCM_ARR_SPL_VAL(P_SUB_TOTAL_FLAG,   V_DELIMITER, V_MST_LOOP_CNT);
        V_SORT_METHOD_CODE := SCM_MGR.SCM_ARR_SPL_VAL(P_SORT_METHOD_CODE, V_DELIMITER, V_MST_LOOP_CNT);

        IF V_MST_LOOP_CNT > 0 THEN  -- 여러개

            IF (P_COLUMN_TYPE = 'C' AND P_PROGRAM_ID NOT IN ('SCP0104','SCP0105','SCP0106','SCP0107','SCP0108')) THEN  --Column
                V_DESCRIPTION := 'IN WHILE NOT IN SCP0104 ETC';

                INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                ( USER_ID    , PROGRAM_ID  , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT P_USER_ID
                     , C.PROGRAM_ID
                     , C.SHEET_NAME
                     , P_COLUMN_TYPE
                     , C.COLUMN_NAME
                     --, p_sort_order_no(i) + c.sort_order_no - TRUNC(c.sort_order_no)
                     , CASE WHEN V_SORT_ORDER_NO IS NULL OR TO_NUMBER(V_SORT_ORDER_NO) = 0
                                 THEN C.SORT_ORDER_NO
                                 ELSE TO_NUMBER(V_SORT_ORDER_NO) + C.SORT_ORDER_NO - TRUNC(C.SORT_ORDER_NO)
                            END
                     , V_SUB_TOTAL_FLAG
                     , V_SORT_METHOD_CODE
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  C.PROGRAM_ID     = P_PROGRAM_ID
                AND    C.SHEET_NAME     = P_SHEET_NAME
                AND    C.SORT_ORDER_NO  = (SELECT SORT_ORDER_NO
                                           FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
                                           WHERE  PROGRAM_ID  = P_PROGRAM_ID
                                           AND    SHEET_NAME  = P_SHEET_NAME
                                           AND    COLUMN_NAME = V_COLUMN_NAME)
                AND    NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER
                                   WHERE  PROGRAM_ID  = C.PROGRAM_ID
                                   AND    SHEET_NAME  = C.SHEET_NAME
                                   AND    COLUMN_NAME = C.COLUMN_NAME
                                   AND    USER_ID     = P_USER_ID);

--------------------------------------------------------------------------------------------------------------
            ELSIF (P_COLUMN_TYPE = 'C' AND P_PROGRAM_ID IN ('SCP0104','SCP0105','SCP0106','SCP0107','SCP0108')) THEN  --Column
                V_DESCRIPTION := 'IN WHILE IN SCP0104 ETC';

                INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                ( USER_ID    , PROGRAM_ID  , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE3)
                SELECT P_USER_ID
                     , C.PROGRAM_ID
                     , C.SHEET_NAME
                     , P_COLUMN_TYPE
                     , C.COLUMN_NAME
                     --, p_sort_order_no(i) + c.sort_order_no - TRUNC(c.sort_order_no)
                     , C.SORT_ORDER_NO
                     , V_SUB_TOTAL_FLAG
                     , V_SORT_METHOD_CODE
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                     , NULL
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  C.PROGRAM_ID     = P_PROGRAM_ID
                AND    C.SHEET_NAME     = P_SHEET_NAME
                AND    C.COLUMN_WIDTH  <> 0
                AND    C.SORT_ORDER_NO  = (SELECT SORT_ORDER_NO
                                           FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
                                           WHERE  PROGRAM_ID  = P_PROGRAM_ID
                                           AND    SHEET_NAME  = P_SHEET_NAME
                                           AND    COLUMN_NAME = V_COLUMN_NAME)
                AND    NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER
                                   WHERE  PROGRAM_ID  = C.PROGRAM_ID
                                   AND    SHEET_NAME  = C.SHEET_NAME
                                   AND    COLUMN_NAME = C.COLUMN_NAME
                                   AND    USER_ID     = P_USER_ID);

                IF V_MST_LOOP_CNT = 0 THEN  --한번만 처리
                    IF P_PROGRAM_ID = 'SCP0104' THEN  --예외 DUMMY_YN 필수 컬럼이지만 0으로 설정되어 있음.
                        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                        ( USER_ID    , PROGRAM_ID  , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                        , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE3)
                        SELECT P_USER_ID
                             , C.PROGRAM_ID
                             , C.SHEET_NAME
                             , P_COLUMN_TYPE
                             , C.COLUMN_NAME
                             , C.SORT_ORDER_NO
                             , V_SUB_TOTAL_FLAG
                             , V_SORT_METHOD_CODE
                             , P_USER_ID
                             , SYSDATE
                             , P_USER_ID
                             , SYSDATE
                             , NULL
                        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                        WHERE  C.PROGRAM_ID   = 'SCP0104'
                        AND    C.SHEET_NAME   = P_SHEET_NAME
                        AND    C.COLUMN_NAME  = 'DUMMY_YN';

                    ELSIF P_PROGRAM_ID = 'SCP0105' THEN
                        INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                        ( USER_ID    , PROGRAM_ID  , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                        , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                        , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ATTRIBUTE3)
                        SELECT P_USER_ID
                             , C.PROGRAM_ID
                             , C.SHEET_NAME
                             , P_COLUMN_TYPE
                             , C.COLUMN_NAME
                             , C.SORT_ORDER_NO
                             , V_SUB_TOTAL_FLAG
                             , V_SORT_METHOD_CODE
                             , P_USER_ID
                             , SYSDATE
                             , P_USER_ID
                             , SYSDATE
                             , NULL
                        FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                        WHERE  C.PROGRAM_ID   = 'SCP0105'
                        AND    C.SHEET_NAME   = P_SHEET_NAME
                        AND    C.COLUMN_NAME  = 'IDX';
                    END IF;
                END IF;

                IF V_ACTIVE_FLAG = 'U' THEN
                    V_DESCRIPTION := 'IN WHILE V_ACTIVE_FLAG = U';

                    UPDATE SCM_MGR.SCM_MST_TITLESET_USER SET ATTRIBUTE3 = ''
                    WHERE  1 = 1
                    AND    PROGRAM_ID  = P_PROGRAM_ID
                    AND    SHEET_NAME  = P_SHEET_NAME
                    AND    COLUMN_NAME = V_COLUMN_NAME
                    AND    USER_ID     = P_USER_ID;
                END IF;

--------------------------------------------------------------------------------------------------------
            ELSIF V_COLUMN_NAME IS NOT NULL OR V_COLUMN_NAME != '' THEN  -- Measure
                V_DESCRIPTION := 'IN WHILE V_COLUMN_NAME : Measure ';

                INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                ( USER_ID    , PROGRAM_ID   , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                VALUES
                ( P_USER_ID       , P_PROGRAM_ID   , P_SHEET_NAME    , P_COLUMN_TYPE
                , V_COLUMN_NAME, TO_NUMBER(V_SORT_ORDER_NO), V_SUB_TOTAL_FLAG, V_SORT_METHOD_CODE
                , P_USER_ID , SYSDATE, P_USER_ID, SYSDATE);

                /*
                INSERT INTO scm_mst_titleset_user
                ( user_id    , program_id   , sheet_name    , user_inquiry_column_type_code
                , column_name, sort_order_no, sub_total_flag, data_sort_method_code
                , created_by , creation_date, last_updated_by, last_update_date )
                SELECT
                 @p_user_id       , @p_program_id   , @p_sheet_name    , @p_column_type
                , m.column_name, @v_sort_order_no, @v_sub_total_flag, @v_sort_method_code
                , @p_user_id , sysdatetime(), @p_user_id, sysdatetime()
                FROM   scm_mst_sheet_measure m
                WHERE  m.program_id = @p_program_id
                AND    m.sheet_name = @p_sheet_name
                AND    m.column_name = @p_column_name
                ;*/

            END IF;

        ELSE  -- V_MST_LOOP_CNT = 0 분기 (단건)

            V_ACTIVE_FLAG      := P_ACTIVE_FLAG;
            V_COLUMN_NAME      := P_COLUMN_NAME;
            V_SORT_ORDER_NO    := P_SORT_ORDER_NO;
            V_SUB_TOTAL_FLAG   := P_SUB_TOTAL_FLAG;
            V_SORT_METHOD_CODE := P_SORT_METHOD_CODE;

            IF P_COLUMN_TYPE = 'C' THEN  --Column

                INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                ( USER_ID    , PROGRAM_ID  , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                SELECT P_USER_ID
                     , C.PROGRAM_ID
                     , C.SHEET_NAME
                     , P_COLUMN_TYPE
                     , C.COLUMN_NAME
                     --, p_sort_order_no(i) + c.sort_order_no - TRUNC(c.sort_order_no)
                     , CASE WHEN V_SORT_ORDER_NO IS NULL OR TO_NUMBER(V_SORT_ORDER_NO) = 0
                                 THEN C.SORT_ORDER_NO
                                 ELSE TO_NUMBER(V_SORT_ORDER_NO) + C.SORT_ORDER_NO - TRUNC(C.SORT_ORDER_NO)
                            END
                     , V_SUB_TOTAL_FLAG
                     , V_SORT_METHOD_CODE
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS C
                WHERE  C.PROGRAM_ID    = P_PROGRAM_ID
                AND    C.SHEET_NAME    = P_SHEET_NAME
                AND    TRUNC(C.SORT_ORDER_NO) = (SELECT TRUNC(SORT_ORDER_NO)
                                                  FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
                                                  WHERE  PROGRAM_ID  = P_PROGRAM_ID
                                                  AND    SHEET_NAME  = P_SHEET_NAME
                                                  AND    COLUMN_NAME = V_COLUMN_NAME)
                AND    NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_TITLESET_USER
                                   WHERE  PROGRAM_ID  = C.PROGRAM_ID
                                   AND    SHEET_NAME  = C.SHEET_NAME
                                   AND    COLUMN_NAME = C.COLUMN_NAME
                                   AND    USER_ID     = P_USER_ID);

            ELSIF V_COLUMN_NAME IS NOT NULL OR V_COLUMN_NAME != '' THEN  -- Measure

                INSERT INTO SCM_MGR.SCM_MST_TITLESET_USER
                ( USER_ID    , PROGRAM_ID   , SHEET_NAME    , USER_INQUIRY_COLUMN_TYPE_CODE
                , COLUMN_NAME, SORT_ORDER_NO, SUB_TOTAL_FLAG, DATA_SORT_METHOD_CODE
                , CREATED_BY , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                VALUES
                ( P_USER_ID       , P_PROGRAM_ID   , P_SHEET_NAME    , P_COLUMN_TYPE
                , V_COLUMN_NAME, TO_NUMBER(V_SORT_ORDER_NO), V_SUB_TOTAL_FLAG, V_SORT_METHOD_CODE
                , P_USER_ID , SYSDATE, P_USER_ID, SYSDATE);

            END IF;

        END IF;

    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;

    N_LOG_COUNT := V_MAX_LOOP_CNT;
    COMMIT;

    OPEN O_RESULT_CURSOR FOR
    SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(N_LOG_COUNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := 'EXCEPTION';
        D_EVENT_DATE  := SYSDATE;
        V_SQL_CODE    := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG  := SQLERRM;
        V_PROC_INPUT  := JSON_OBJECT(
            'P_PROGRAM_ID'       VALUE P_PROGRAM_ID,
            'P_SHEET_NAME'       VALUE P_SHEET_NAME,
            'P_COLUMN_TYPE'      VALUE P_COLUMN_TYPE,
            'P_ACTIVE_FLAG'      VALUE P_ACTIVE_FLAG,
            'P_COLUMN_NAME'      VALUE P_COLUMN_NAME,
            'P_SORT_ORDER_NO'    VALUE P_SORT_ORDER_NO,
            'P_SUB_TOTAL_FLAG'   VALUE P_SUB_TOTAL_FLAG,
            'P_SORT_METHOD_CODE' VALUE P_SORT_METHOD_CODE,
            'P_USER_ID'          VALUE P_USER_ID
        );
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        BEGIN SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT, V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE); END;
        RAISE_APPLICATION_ERROR(-20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || V_SQL_CODE ||
            ' / SQLERRM=' || V_SQL_ERRMSG ||
            ' / BACKTRACE=' || V_BACKTRACE ||
            ' / PARAMS=' || V_PROC_INPUT
        );

END P_SCM0002_SET_TITLESET_POPUP;

END PKG_SCM0002;
/
