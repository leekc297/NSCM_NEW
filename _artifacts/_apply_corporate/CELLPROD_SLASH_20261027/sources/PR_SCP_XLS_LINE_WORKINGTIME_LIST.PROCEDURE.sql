PROCEDURE PR_SCP_XLS_LINE_WORKINGTIME_LIST
(
      P_DIVISION_ID           IN  VARCHAR2
    , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
    , P_CELL_ITEM_LIST        IN  VARCHAR2        /* NVARCHAR(MAX). 소비처가 STRING_SPLIT(P_STR VARCHAR2) 하나뿐이고 */

    , O_RESULT_CURSOR         OUT SYS_REFCURSOR
)
/*
 * Program ID   : PR_SCP_XLS_LINE_WORKINGTIME_LIST
 * Description  : 시뮬레이터의 DAILY PSI 조회시 생산계획의 일분배를 위한 기준정보로 활용
 * OutTable     :
 * Execute      :

    EXEC PR_SCP_XLS_LINE_WORKINGTIME_LIST @p_division_id                     = '81'
                               ,  @p_plan_start_yyyymmdd = '20240819'
                               , @P_CELL_ITEM_LIST                = 'ACHP2005I-A1,ACHP2005I-A1-100'

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.08.22   KSK         시뮬레이터의  로컬환경에서 생산계획을 일배분하기 위한 CAPA 워킹타임 Available 을 List형태로 반환
 * 2026.08.07   ZIONEX      [PJ202650304] NextSCM Migration
 */
AS
    /* MSSQL 의 DECLARE @v ... 는 전부 선언부로 올린다(CV-011). 계산이 앞선 문장의 결과에 의존하는 변수 */

    V_P_TO_YYYYMMDD           VARCHAR2(8 CHAR)   := '';
    V_BP_FLAG                 VARCHAR2(8 CHAR)   := '';
    V_P_TODAY_YYYYMMDD        VARCHAR2(8 CHAR)   := P_PLAN_START_YYYYMMDD;
    V_P_CHECK_LOSS            CHAR(1 CHAR)       := 'Y';
    V_P_FROM_YYYYMM           VARCHAR2(6 CHAR)   := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 6);
    V_P_TO_YYYYMM             VARCHAR2(6 CHAR);
    V_P_VERSION_ID            VARCHAR2(20 CHAR)  := 'Current';
    V_P_USER_AUTH             VARCHAR2(30 CHAR)  := 'Admin';
    /* DECLARE @v_company_id   NVARCHAR(100) = N''; */
    /* declare @p_line_id				NVARCHAR(MAX) = 'A1A02'; */
    /* declare @p_operation_id			NVARCHAR(MAX) = 'A9000'; */

    /* 쿼리 실행용 변수; */
    /* NVARCHAR(MAX) -> CLOB. 원본에서도 선언만 있고 참조 0건이나 1:1 로 남긴다. */
    V_MEXEC                   CLOB;
    V_MQRY_SUM                CLOB;
    V_DYNAMIC_PIVOT_COL_PARENT CLOB;                      /* 2021-10-12 ParkSungchool 부모쿼리 만들기 부분 */

    /* 날짜 조건용 변수 설정 */
    V_START_DAY               VARCHAR2(8 CHAR);   /* 시작 일자(현재 달) */
    V_END_DAY                 VARCHAR2(8 CHAR);   /* 마지막 일자 */
    V_START_MONTH             VARCHAR2(6 CHAR);   /* 시작 월(현재월 +1 년) */
    V_END_MONTH               VARCHAR2(6 CHAR);   /* 마지막 월 */

    V_START_AVG               VARCHAR2(6 CHAR);   /* 과거 시작 월 */
    V_END_AVG                 VARCHAR2(6 CHAR);   /* 과거 마지막 월 */
    V_START_RESULT_AVG        VARCHAR2(6 CHAR);   /* 과거 시작 월(과거 테이블 조회) */
    V_END_RESULT_AVG          VARCHAR2(6 CHAR);   /* 과거 마지막 월(과거 테이블 조회) */
    V_RESULT_MONTH            NUMBER(10)         := 2;   /* 과거 데이터 조회 월 */

    /* 이력 테이블 조회 기준 월. CONVERT(VARCHAR(8), DATEADD(MM,-n,d), 112) -> TO_CHAR(ADD_MONTHS(..),'YYYYMMDD') */
    V_RESULT_TABLE_MONTH      VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -2), 'YYYYMMDD');

    V_START_YEAR              VARCHAR2(4 CHAR);   /* 시작 연도(현재년 +1) */
    V_END_YEAR                VARCHAR2(4 CHAR);   /* 마지막 년도(현재년+3) */

    /* 월 조회 개월 수 */
    V_MONTH_CNT               NUMBER(10);

    V_CHECK_DAILY             CHAR(1 CHAR)       := 'N';

    /* 평균 계산용 변수 설정 */
    V_BEF_M6_COUNT            NUMBER(10);   /* 현재월 -6 해당월의 날짜 수 */
    V_BEF_M5_COUNT            NUMBER(10);   /* 현재월 -5 해당월의 날짜 수 */
    V_BEF_M4_COUNT            NUMBER(10);   /* 현재월 -4 해당월의 날짜 수 */
    V_BEF_M3_COUNT            NUMBER(10);   /* 현재월 -3 해당월의 날짜 수 */
    V_BEF_M2_COUNT            NUMBER(10);   /* 현재월 -2 해당월의 날짜 수 */
    V_BEF_M1_COUNT            NUMBER(10);   /* 현재월 -1 해당월의 날짜 수 */
    V_BEF_MAX_COUNT           NUMBER(10);   /* 현재월 -1 ~ 현재월 - 6 개월의 날짜 수 중 가장 큰 값(BEST,WORST) */
    V_BEF_MIN_COUNT           NUMBER(10);   /* 현재월 -1 ~ 현재월 - 6 개월의 날짜 수 중 가장 작은 값(BEST,WORST) */

    /* CONVERT(VARCHAR(6), DATEADD(MM,-n,d), 112) 는 'YYYYMMDD' 를 6자리로 자른 'YYYYMM' 이다 -> TO_CHAR(..,'YYYYMM') */
    V_BEF_M6_YYYYMM           VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMM');
    V_BEF_M5_YYYYMM           VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -5), 'YYYYMM');
    V_BEF_M4_YYYYMM           VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -4), 'YYYYMM');
    V_BEF_M3_YYYYMM           VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -3), 'YYYYMM');
    V_BEF_M2_YYYYMM           VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -2), 'YYYYMM');
    V_BEF_M1_YYYYMM           VARCHAR2(6 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM');

    /* 3년 조회 변경 ( 2 => 3). CONVERT(NVARCHAR(4), DATEADD(YY,3,d), 112) = 'YYYYMMDD' 앞 4자리 = 연도 */
    V_MAX_DAY                 VARCHAR2(8 CHAR)   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 36), 'YYYY') || '1231';

    /* 버전별 division, op group 설정 */
    V_VER_DIVISION_ID         VARCHAR2(20 CHAR);
    V_VER_GROUP               VARCHAR2(4000 CHAR);   /* NVARCHAR(MAX) 이나 원천이 SCM_SYS_LOOKUP_VALUE.ATTRIBUTE2 */
                                                     /* (VARCHAR2(4000 CHAR)) 이고 소비처가 STRING_SPLIT 이라 VARCHAR2(H-14) */
BEGIN


    /* MSSQL 테이블 변수 @TB_LINE / @TB_OPERATION -> GTT(CV-035). 호출마다 새로 채우므로 먼저 비운다. */
    DELETE
      FROM GT_XPGT_TB_LINE;

    DELETE
      FROM GT_XPGT_TB_OPERATION;

    INSERT
      INTO GT_XPGT_TB_LINE
         ( LINE_ID )
    SELECT PROD_LINE
      FROM SCP_XLS_PSI_GLOBAL
     WHERE DIVISION_ID = P_DIVISION_ID
       AND MEASURE IN ('CELL_PROD', 'PACK_PROD')
       AND CELL_ITEM_ID IN (SELECT COLUMN_VALUE
                              FROM TABLE(STRING_SPLIT(P_CELL_ITEM_LIST, ',')));

    INSERT
      INTO GT_XPGT_TB_OPERATION
         ( OPERATION_ID )
    SELECT ATTRIBUTE9
      FROM SCP_XLS_PSI_GLOBAL
     WHERE DIVISION_ID = P_DIVISION_ID
       AND MEASURE IN ('CELL_PROD', 'PACK_PROD')
       AND CELL_ITEM_ID IN (SELECT COLUMN_VALUE
                              FROM TABLE(STRING_SPLIT(P_CELL_ITEM_LIST, ',')));

    /* ------------------------------------------------------------------------------------------------------- */
    /* PLAN 기간설정 - 2021.11.19 */
    /* ------------------------------------------------------------------------------------------------------- */
    /* MSSQL : SELECT @p_to_yyyymmdd = .., @v_bp_flag = .. FROM scm_mst_plan p WHERE ..
               SELECT INTO(NO_DATA_FOUND/TOO_MANY_ROWS) 가 아니라 커서 FOR 루프로 1:1 재현한다. */
    FOR R IN (SELECT P.HORIZON_END_DATE
                   , (CASE WHEN TRUNC(TO_DATE(P.HORIZON_END_DATE, 'YYYYMMDD')) - TRUNC(TO_DATE(P.PLAN_NAME, 'YYYYMMDD')) > 364 THEN 'Y'
                           ELSE 'N'
                      END) AS BP_FLAG
                FROM SCM_MST_PLAN P
               WHERE P.DIVISION_ID = P_DIVISION_ID
                 AND P.PLAN_ID     = (SELECT MAX(PLAN_ID)
                                        FROM SCM_MST_PLAN P
                                       WHERE DIVISION_ID = P_DIVISION_ID
                                         AND PLAN_ID < 9999)
                 AND P.PLAN_CYCLE  = 'WEEKLY')
    LOOP
        V_P_TO_YYYYMMDD := R.HORIZON_END_DATE;
        V_BP_FLAG       := R.BP_FLAG;
    END LOOP;

    IF V_BP_FLAG = 'Y' THEN
        /* 중장기일 경우 104주차로 변경 */
        V_P_TO_YYYYMMDD := TO_CHAR(TO_DATE(TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 364, 'YYYYMMDD'), 'YYYYMMDD') + 363, 'YYYYMMDD');
    END IF;

    /* 원본 L79 : declare @p_to_yyyymm NVARCHAR(6) = LEFT(@p_to_yyyymmdd, 6); */
    V_P_TO_YYYYMM := SUBSTR(V_P_TO_YYYYMMDD, 1, 6);

    /* 해당 월에 마지막일자(날짜 수 )를 구한다(평균데이터를 구하는 곳 사용) */

    SELECT TO_NUMBER(MAX(CALENDAR_DAY))
      INTO V_BEF_M6_COUNT
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM = V_BEF_M6_YYYYMM;

    SELECT TO_NUMBER(MAX(CALENDAR_DAY))
      INTO V_BEF_M5_COUNT
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM = V_BEF_M5_YYYYMM;

    SELECT TO_NUMBER(MAX(CALENDAR_DAY))
      INTO V_BEF_M4_COUNT
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM = V_BEF_M4_YYYYMM;

    SELECT TO_NUMBER(MAX(CALENDAR_DAY))
      INTO V_BEF_M3_COUNT
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM = V_BEF_M3_YYYYMM;

    SELECT TO_NUMBER(MAX(CALENDAR_DAY))
      INTO V_BEF_M2_COUNT
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM = V_BEF_M2_YYYYMM;

    SELECT TO_NUMBER(MAX(CALENDAR_DAY))
      INTO V_BEF_M1_COUNT
      FROM SCM_SYS_CALENDAR_M
     WHERE BASIS_YYYYMM = V_BEF_M1_YYYYMM;

    /* //////////////////////////////////////////////////////////////// */
    /* 조회 날짜 설정 */
    /* //////////////////////////////////////////////////////////////// */
    /* 기준일 Y+1 까지만 월 조회 가능 그후는 년도 조회 */
    /* 기준일 Y+1 년 과 조회 마지막 일자를 비교하여 조회일 설정 */

    IF MONTHS_BETWEEN(TRUNC(TO_DATE(V_P_TO_YYYYMM || '01', 'YYYYMMDD'), 'MM'), TRUNC(TO_DATE(V_MAX_DAY, 'YYYYMMDD'), 'MM')) > 0 THEN
        V_START_DAY   := SUBSTR(V_P_TODAY_YYYYMMDD, 1, 6) || '01';   /* 조회 Period 시작 일 */
        V_END_DAY     := SUBSTR(V_MAX_DAY, 1, 6) || '31';            /* 조회일자가 기준을 넘을 경우 Y+1 으로 조회 */
        V_START_MONTH := SUBSTR(V_P_TODAY_YYYYMMDD, 1, 6);           /* 현재일 */
        V_END_MONTH   := SUBSTR(V_MAX_DAY, 1, 6);                    /* 조회일자가 기준을 넘을 경우 Y+1 으로 조회 */
    ELSE
        /* 조회일자가 기준을 넘지 않을 경우 파라미터로 설정 */
        V_START_DAY   := SUBSTR(V_P_TODAY_YYYYMMDD, 1, 6) || '01';   /* 현재 일자 */
        V_END_DAY     := V_P_TO_YYYYMM || '31';                      /* 조회 Period 마지막 일 */
        V_START_MONTH := SUBSTR(V_P_TODAY_YYYYMMDD, 1, 6);
        V_END_MONTH   := V_P_TO_YYYYMM;
    END IF;

    /* 기준일 Y+1 까지만 월 조회 가능 그후는 년도 조회 */
    IF MONTHS_BETWEEN(TRUNC(TO_DATE(V_P_TO_YYYYMM || '01', 'YYYYMMDD'), 'MM'), TRUNC(TO_DATE(V_MAX_DAY, 'YYYYMMDD'), 'MM')) > 0 THEN
        V_START_YEAR := TO_CHAR(ADD_MONTHS(TO_DATE(V_P_TODAY_YYYYMMDD, 'YYYYMMDD'), 36), 'YYYY');   /* 3년 조회 변경 ( 3 => 4) */
        V_END_YEAR   := SUBSTR(V_P_TO_YYYYMM, 1, 4);
    ELSE
        V_START_YEAR := '9999';
        V_END_YEAR   := '9999';
    END IF;

    /* 과거 조회 일자 설정 */
    IF V_P_FROM_YYYYMM < V_RESULT_TABLE_MONTH THEN
        /* 이력 테이블 조회 */
        V_START_RESULT_AVG := V_P_FROM_YYYYMM;

        V_END_RESULT_AVG   := SUBSTR(V_RESULT_TABLE_MONTH, 1, 6);

        V_START_AVG        := TO_CHAR(ADD_MONTHS(TO_DATE(V_RESULT_TABLE_MONTH, 'YYYYMMDD'), 1), 'YYYYMM');    /* 현재월 -1@v_result_table_month */
        V_END_AVG          := TO_CHAR(ADD_MONTHS(TO_DATE(V_P_TODAY_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM');     /* 현재월 -1 */
    ELSE
        /* 이력 테이블 조회 하지 않는다. */
        V_START_RESULT_AVG := V_P_TO_YYYYMM;
        V_END_RESULT_AVG   := V_P_FROM_YYYYMM;
        V_START_AVG        := V_P_FROM_YYYYMM;   /* 조회 시작 월 */
        V_END_AVG          := TO_CHAR(ADD_MONTHS(TO_DATE(V_P_TODAY_YYYYMMDD, 'YYYYMMDD'), -1), 'YYYYMM');     /* 현재월 -1 */
    END IF;

    /* 버전별 division, op group 설정 */


    FOR R IN (SELECT CASE WHEN V_P_VERSION_ID = 'Current' THEN NULL
                          ELSE B.ATTRIBUTE1
                     END AS VER_DIVISION_ID
                   , CASE WHEN V_P_VERSION_ID = 'Current' THEN NULL
                          ELSE B.ATTRIBUTE2
                     END AS VER_GROUP
                FROM SCM_MASTER_VERSION_INFO_H_SN A
                   , SCM_SYS_LOOKUP_VALUE_SN B
               WHERE 1 = 1
                 AND A.DIVISION_ID    = B.SEGMENT2
                 AND LOOKUP_TYPE_CODE = 'MASTER_DATA_DIVISION_SYSTEM'
                 AND A.VERSION_ID     = V_P_VERSION_ID)
    LOOP
        V_VER_DIVISION_ID := R.VER_DIVISION_ID;
        V_VER_GROUP       := R.VER_GROUP;
    END LOOP;

    /* LOSS LOOKUP 정보 조회 */


    DELETE
      FROM GT_XPGT_SCP0049_LOOKUP;

    INSERT
      INTO GT_XPGT_SCP0049_LOOKUP
         ( LOSS_CODE
         , CATEGORY_ID
         , KEY_ID
         , DATA_TABLE
         , CATEGORY_ORDER
         , UOM
         , EDITORBLE_YN
         , SORT_ORDER )
    SELECT SEGMENT1                     AS LOSS_CODE
         , ATTRIBUTE1                   AS CATEGORY_ID
         , ATTRIBUTE2                   AS KEY_ID
         , ATTRIBUTE3                   AS DATA_TABLE
         , TO_NUMBER(ATTRIBUTE8)        AS CATEGORY_ORDER
         , ATTRIBUTE9                   AS UOM
         , NVL(ATTRIBUTE7, 'N')         AS EDITORBLE_YN
         , SORT_ORDER
      FROM SCM_SYS_LOOKUP_VALUE_SN LV
     WHERE 1 = 1
       AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'
       AND ACTIVE_FLAG = 'Y'
       /* AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('Admin','SCP Planner','SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- [PJ20214907] : 권한 사용자만 조회 */
       AND SEGMENT1 NOT IN (CASE WHEN V_P_USER_AUTH NOT IN ('Admin', 'SCP Planner', 'CAPA Planner', 'SCM PI Admin') THEN 'XC031'
                                 ELSE '-'
                            END)   /* [PJ20214907] : 권한 사용자만 조회 */
       /* AND SEGMENT1 NOT IN ( CASE WHEN  @p_user_auth NOT IN ('SCP Planner','SCM PI Admin')  THEN 'XC031' ELSE '-' END ) -- [PJ20214907] : 권한 사용자만 조회 */
    ;

    SELECT MAX(A.CALENDAR_DAY)
         , MIN(A.CALENDAR_DAY)
      INTO V_BEF_MAX_COUNT
         , V_BEF_MIN_COUNT
      FROM (SELECT BASIS_YYYYMM
                 , TO_NUMBER(MAX(CALENDAR_DAY)) AS CALENDAR_DAY
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMM >= V_P_FROM_YYYYMM   /* 조회 시작 월 */
               AND BASIS_YYYYMM <= V_END_AVG
             GROUP BY BASIS_YYYYMM) A;

    /* COMPANY정보 추출
       SELECT @v_company_id = COMPANY_ID
         FROM SCM_LINE_HIERARCHY_V_SN A
        WHERE 1=1
          AND  A.DIVISION_ID  = @p_division_id
          AND A.LINE_ID   IN (SELECT LINE_ID FROM @TB_LINE)
          AND A.OPERATION_ID   IN (SELECT OPERATION_ID FROM @TB_OPERATION)
          AND (( @v_ver_division_id	IS NULL OR @v_ver_division_id	='') OR A.DIVISION_ID  			IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_ver_division_id	, ',')))
          AND (( @v_ver_group			IS NULL OR @v_ver_group			='') OR A.OPERATION_GROUP_ID    IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@v_ver_group			, ','))) */

    /* Empty Value 용 변수 설정(조회 시작월 ~ 종료월의 개수) */
    V_MONTH_CNT := MONTHS_BETWEEN(TRUNC(TO_DATE(V_END_MONTH || '01', 'YYYYMMDD'), 'MM'), TRUNC(TO_DATE(V_START_MONTH || '01', 'YYYYMMDD'), 'MM')) + 1;


    DELETE
      FROM GT_XPGT_SCP0049_STD;

    INSERT
      INTO GT_XPGT_SCP0049_STD
         ( DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , SITE_NAME
         , PLANT_ID
         , OPERATION_GROUP_ID
         , OPERATION_GROUP_NAME
         , FACTORY_ID
         , FACTORY_NAME
         , OPERATION_ID
         , OPERATION_NAME
         , LINE_ID
         , LINE_NAME
         , ELECTRODE_TYPE )
    SELECT DISTINCT
           DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , SITE_NAME
         , PLANT_ID
         , OPERATION_GROUP_ID
         , OPERATION_GROUP AS OPERATION_GROUP_NAME
         , FACTORY_ID
         , FACTORY_NAME
         , OPERATION_ID
         , OPERATION_NAME
         , LINE_ID
         , LINE_NAME
         , ELECTRODE_TYPE
      FROM SCM_LINE_HIERARCHY_V_SN A
     WHERE 1 = 1
       AND A.LINE_ID      IN (SELECT LINE_ID
                                FROM GT_XPGT_TB_LINE)
       AND A.OPERATION_ID IN (SELECT OPERATION_ID
                                FROM GT_XPGT_TB_OPERATION)
       /* MSSQL (( @v IS NULL OR @v ='') OR ..) 에서 Oracle 은 ''=NULL 이라 IS NULL 하나로 동치(CV-030 / EP-016) */
       AND (V_VER_DIVISION_ID IS NULL OR A.DIVISION_ID        IN (SELECT COLUMN_VALUE
                                                                    FROM TABLE(STRING_SPLIT(V_VER_DIVISION_ID, ','))))
       AND (V_VER_GROUP       IS NULL OR A.OPERATION_GROUP_ID IN (SELECT COLUMN_VALUE
                                                                    FROM TABLE(STRING_SPLIT(V_VER_GROUP, ','))))
       AND A.DIVISION_ID  = P_DIVISION_ID
    ;

    /* /////////////////////////////////////////////////////////////////////////////////// */
    /* 테이블 생성 */
    /* /////////////////////////////////////////////////////////////////////////////////// */
    /* 과거 데이터를 저장하는 테이블 / 현재월 기준 - 6 개월 저장 */
    /* IF OBJECT_ID('TEMPDB..#TMP_SCP0049_AVG_DATA') IS NOT NULL DROP TABLE #TMP_SCP0049_AVG_DATA;  (CREATE TABLE -> GTT) */
    DELETE
      FROM GT_XPGT_SCP0049_AVG_DATA;

    /* 과거 데이터를 월별(컬럼)로 저장하는 테이블 */
    DELETE
      FROM GT_XPGT_SCP0049_AVG;

    /* //////////////////////////////////////// */
    /* 과거 테이블 중 최대값 최소 값을 저장한다 */
    /* LOSS 는 최소값이 BEST */
    /* DAILY CAPA , YIELD 는 최대값이 BEST */
    /* //////////////////////////////////////// */
    DELETE
      FROM GT_XPGT_SCP0049_AVG_MIN_MAX;

    /* LOSS 정보의 일별, 월별 , 년별 나눠진 데이터를 저장하는 테이블 */
    DELETE
      FROM GT_XPGT_SCP0049_DMY;

    /* 조회된 결과 데이터에서 기준정보에서 누락된 데이터를 생성후 저저장되는 테이블 */
    DELETE
      FROM GT_XPGT_SCP0049_ADD_STD;

    /* LINE ASSIGN , TACT TIME(DAILY_CAPA) , YIELD 의 일별, 월별 ,년도별 저장하는 테이블 */
    DELETE
      FROM GT_XPGT_SCP0049_LTY;

    /*      -- 2021-09-39
       CREATE NONCLUSTERED INDEX TempTalbeIndex_LTY ON [dbo].[#TMP_SCP0049_LTY] ([LOSS_CODE], [DIVISION_ID],[COMPANY_ID],[SITE_ID],[PLANT_ID],[FACTORY_ID],[LINE_ID],[ELECTRODE_TYPE],[OPERATION_ID],[ITEM_ID]); */

    /* LINE, TACT , YIELD 최종 결과 테이블 / Empty Value 설정 반영되는 테이블 */
    DELETE
      FROM GT_XPGT_SCP0049_LTY_RESULT;

    /* LOSS , LINE ,TACT , YEILD 가 합쳐진 테이블 */
    DELETE
      FROM GT_XPGT_SCP0049_ALL;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* 과거 현재 - 3개월 데이터 및 평균 */
    /* /////////////////////////////////////////////////////////////////////////////// */
    IF V_P_CHECK_LOSS = 'Y' THEN
        /* SCM_WORK_CALENDAR_M_SN 은 일별로 저정되는 테이블 */
        /* 월별로 SUM 해서 저장한다. */
        INSERT
          INTO GT_XPGT_SCP0049_AVG_DATA
             ( COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , LOSS_CODE
             , ITEM_ID
             , LANE_QTY
             , YYYYMM
             , ITEM_VALUE
             , ITEM_VALUE_RESULT )
        SELECT CM.COMPANY_ID
             , CM.DIVISION_ID
             , CM.SITE_ID
             , CM.PLANT_ID
             , CM.FACTORY_ID
             , CM.OPERATION_ID
             , CM.LINE_ID
             , CM.ELECTRODE_TYPE
             , CM.LOSS_CODE
             , TO_CHAR(NULL)                             AS ITEM_ID
             , 0                                         AS LANE_QTY
             , TO_CHAR(CM.WORK_DATE, 'YYYYMM')           AS YYYYMM
             , NVL(SUM(CM.TIME_TERM), 0)                 AS ITEM_VALUE
             , NVL(SUM(CM.TIME_TERM_RESULT), 0)          AS ITEM_VALUE_RESULT
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_WORK_CALENDAR_M_SN CM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND CM.LOSS_CODE      = LU.LOSS_CODE
           AND CM.DIVISION_ID    = L.DIVISION_ID
           AND CM.COMPANY_ID     = L.COMPANY_ID
           AND CM.SITE_ID        = L.SITE_ID
           AND CM.PLANT_ID       = L.PLANT_ID
           AND CM.FACTORY_ID     = L.FACTORY_ID
           AND CM.OPERATION_ID   = L.OPERATION_ID
           AND CM.LINE_ID        = L.LINE_ID
           AND CM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.DATA_TABLE     = 'SCM_WORK_CALENDAR_M'
             /* AND CM.COMPANY_ID  = @v_company_id */
           AND CM.DIVISION_ID    = P_DIVISION_ID
           AND TO_CHAR(CM.WORK_DATE, 'YYYYMM') >= V_START_AVG   /* '202004' */
           AND TO_CHAR(CM.WORK_DATE, 'YYYYMM') <= V_END_AVG     /* '202006' */
         GROUP BY CM.COMPANY_ID
             , CM.DIVISION_ID
             , CM.SITE_ID
             , CM.PLANT_ID
             , CM.FACTORY_ID
             , CM.OPERATION_ID
             , CM.LINE_ID
             , CM.ELECTRODE_TYPE
             , CM.LOSS_CODE
             , TO_CHAR(CM.WORK_DATE, 'YYYYMM')

         UNION ALL

        /* SCM_LOSS_M_SN (월별 데이터) */
        /* 비율로 저장되고 (%) 값으로 표시하기 위해서 (값 * 100) 을 해서 저장한다 */
        SELECT LM.COMPANY_ID
             , LM.DIVISION_ID
             , LM.SITE_ID
             , LM.PLANT_ID
             , LM.FACTORY_ID
             , LM.OPERATION_ID
             , LM.LINE_ID
             , LM.ELECTRODE_TYPE
             , LM.LOSS_CODE
             , TO_CHAR(NULL)                             AS ITEM_ID
             , 0                                         AS LANE_QTY
             , LM.WORK_MONTH                             AS YYYYMM
             , NVL(LM.LOSS_RATE        * 100, 0)         AS ITEM_VALUE
             , NVL(LM.LOSS_RATE_RESULT * 100, 0)         AS ITEM_VALUE_RESULT
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_LOSS_M_SN LM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND LM.LOSS_CODE      = LU.LOSS_CODE
           AND LM.DIVISION_ID    = L.DIVISION_ID
           AND LM.COMPANY_ID     = L.COMPANY_ID
           AND LM.SITE_ID        = L.SITE_ID
           AND LM.PLANT_ID       = L.PLANT_ID
           AND LM.FACTORY_ID     = L.FACTORY_ID
           AND LM.OPERATION_ID   = L.OPERATION_ID
           AND LM.LINE_ID        = L.LINE_ID
           AND LM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.DATA_TABLE     = 'SCM_LOSS_M'
             /* AND LM.COMPANY_ID  = @v_company_id */
           AND LM.DIVISION_ID    = P_DIVISION_ID
           AND LM.WORK_MONTH >= V_START_AVG
           AND LM.WORK_MONTH <= V_END_AVG
        ;

        /* 이력 테이블 조회 */
        IF V_END_RESULT_AVG > V_START_RESULT_AVG THEN
            INSERT
              INTO GT_XPGT_SCP0049_AVG_DATA
                 ( COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , OPERATION_ID
                 , LINE_ID
                 , ELECTRODE_TYPE
                 , LOSS_CODE
                 , ITEM_ID
                 , LANE_QTY
                 , YYYYMM
                 , ITEM_VALUE
                 , ITEM_VALUE_RESULT )
            SELECT CM.COMPANY_ID
                 , CM.DIVISION_ID
                 , CM.SITE_ID
                 , CM.PLANT_ID
                 , CM.FACTORY_ID
                 , CM.OPERATION_ID
                 , CM.LINE_ID
                 , CM.ELECTRODE_TYPE
                 , CM.LOSS_CODE
                 , TO_CHAR(NULL)                         AS ITEM_ID
                 , 0                                     AS LANE_QTY
                 , TO_CHAR(CM.WORK_DATE, 'YYYYMM')       AS YYYYMM
                 , NVL(SUM(CM.TIME_TERM), 0)             AS ITEM_VALUE
                 , NVL(SUM(CM.TIME_TERM_RESULT), 0)      AS ITEM_VALUE_RESULT
              FROM GT_XPGT_SCP0049_LOOKUP LU
                 , HIST_SCM_WORK_CALENDAR_M_SN CM   /* 이력 테이블(HIST) 조회 */
                 , GT_XPGT_SCP0049_STD L
             WHERE CM.LOSS_CODE      = LU.LOSS_CODE
               AND CM.DIVISION_ID    = L.DIVISION_ID
               AND CM.COMPANY_ID     = L.COMPANY_ID
               AND CM.SITE_ID        = L.SITE_ID
               AND CM.PLANT_ID       = L.PLANT_ID
               AND CM.FACTORY_ID     = L.FACTORY_ID
               AND CM.OPERATION_ID   = L.OPERATION_ID
               AND CM.LINE_ID        = L.LINE_ID
               AND CM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
               AND LU.DATA_TABLE     = 'SCM_WORK_CALENDAR_M'
                 /* AND CM.COMPANY_ID = @v_company_id */
               AND CM.DIVISION_ID    = P_DIVISION_ID
               AND TO_CHAR(CM.WORK_DATE, 'YYYYMM') >= V_START_RESULT_AVG
               AND TO_CHAR(CM.WORK_DATE, 'YYYYMM') <= V_END_RESULT_AVG
             GROUP BY CM.COMPANY_ID
                 , CM.DIVISION_ID
                 , CM.SITE_ID
                 , CM.PLANT_ID
                 , CM.FACTORY_ID
                 , CM.OPERATION_ID
                 , CM.LINE_ID
                 , CM.ELECTRODE_TYPE
                 , CM.LOSS_CODE
                 , TO_CHAR(CM.WORK_DATE, 'YYYYMM')

             UNION ALL

            /* SCM_LOSS_M_SN (월별 데이터) */
            /* 비율로 저장되고 (%) 값으로 표시하기 위해서 (값 * 100) 을 해서 저장한다 */
            SELECT LM.COMPANY_ID
                 , LM.DIVISION_ID
                 , LM.SITE_ID
                 , LM.PLANT_ID
                 , LM.FACTORY_ID
                 , LM.OPERATION_ID
                 , LM.LINE_ID
                 , LM.ELECTRODE_TYPE
                 , LM.LOSS_CODE
                 , TO_CHAR(NULL)                         AS ITEM_ID
                 , 0                                     AS LANE_QTY
                 , LM.WORK_MONTH                         AS YYYYMM
                 , NVL(LM.LOSS_RATE        * 100, 0)     AS ITEM_VALUE
                 , NVL(LM.LOSS_RATE_RESULT * 100, 0)     AS ITEM_VALUE_RESULT
              FROM GT_XPGT_SCP0049_LOOKUP LU
                 , HIST_SCM_LOSS_M_SN LM            /* 이력 테이블(HIST) 조회 */
                 , GT_XPGT_SCP0049_STD L
             WHERE LM.LOSS_CODE      = LU.LOSS_CODE
               AND LM.DIVISION_ID    = L.DIVISION_ID
               AND LM.COMPANY_ID     = L.COMPANY_ID
               AND LM.SITE_ID        = L.SITE_ID
               AND LM.PLANT_ID       = L.PLANT_ID
               AND LM.FACTORY_ID     = L.FACTORY_ID
               AND LM.OPERATION_ID   = L.OPERATION_ID
               AND LM.LINE_ID        = L.LINE_ID
               AND LM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
               AND LU.DATA_TABLE     = 'SCM_LOSS_M'
                 /* AND LM.COMPANY_ID = @v_company_id */
               AND LM.DIVISION_ID    = P_DIVISION_ID
               AND LM.WORK_MONTH >= V_START_RESULT_AVG
               AND LM.WORK_MONTH <= V_END_RESULT_AVG
            ;
        END IF;   /* 이력 테이블(HIST) 조회 */
    END IF;

    /* ///////////////////////////////////////////////////////////////////////// */
    /* 조회된 과거 데이터를 날짜별(컬럼)로 저장한다. */
    /* ///////////////////////////////////////////////////////////////////////// */
    INSERT
      INTO GT_XPGT_SCP0049_AVG
         ( COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
         , BEF_M6
         , BEF_M5
         , BEF_M4
         , BEF_M3
         , BEF_M2
         , BEF_M1
         , BEF_M6_RESULT
         , BEF_M5_RESULT
         , BEF_M4_RESULT
         , BEF_M3_RESULT
         , BEF_M2_RESULT
         , BEF_M1_RESULT )
    SELECT COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M6_YYYYMM THEN ITEM_VALUE ELSE 0 END), 0)          AS BEF_M6
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M5_YYYYMM THEN ITEM_VALUE ELSE 0 END), 0)          AS BEF_M5
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M4_YYYYMM THEN ITEM_VALUE ELSE 0 END), 0)          AS BEF_M4
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M3_YYYYMM THEN ITEM_VALUE ELSE 0 END), 0)          AS BEF_M3
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M2_YYYYMM THEN ITEM_VALUE ELSE 0 END), 0)          AS BEF_M2
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M1_YYYYMM THEN ITEM_VALUE ELSE 0 END), 0)          AS BEF_M1
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M6_YYYYMM THEN ITEM_VALUE_RESULT ELSE 0 END), 0)   AS BEF_M6_RESULT
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M5_YYYYMM THEN ITEM_VALUE_RESULT ELSE 0 END), 0)   AS BEF_M5_RESULT
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M4_YYYYMM THEN ITEM_VALUE_RESULT ELSE 0 END), 0)   AS BEF_M4_RESULT
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M3_YYYYMM THEN ITEM_VALUE_RESULT ELSE 0 END), 0)   AS BEF_M3_RESULT
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M2_YYYYMM THEN ITEM_VALUE_RESULT ELSE 0 END), 0)   AS BEF_M2_RESULT
         , NVL(SUM(CASE WHEN YYYYMM = V_BEF_M1_YYYYMM THEN ITEM_VALUE_RESULT ELSE 0 END), 0)   AS BEF_M1_RESULT
      FROM GT_XPGT_SCP0049_AVG_DATA
     GROUP BY COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
    ;

    /* ///////////////////////////////////////////////////////////////////////// */
    /* 조회된 과거 데이터를 BEST , WORST 를 저장한다. */
    /* LOSS, TACT TIME 는 작은값이 BEST */
    /* DAILY CPAP(LA002), YIELD(LA003) 는 큰값이 BEST */
    /* 죄회된 데이터에 해당 월 값이 없을 경우 0 값으로 설정해서 MIN, MAX 값을 구한다 */
    /* ///////////////////////////////////////////////////////////////////////// */
    INSERT
      INTO GT_XPGT_SCP0049_AVG_MIN_MAX
         ( COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
         , BEF_BEST
         , BEF_WORST
         , BEF_BEST_RESULT
         , BEF_WORST_RESULT )
    SELECT T.COMPANY_ID
         , T.DIVISION_ID
         , T.SITE_ID
         , T.PLANT_ID
         , T.FACTORY_ID
         , T.OPERATION_ID
         , T.LINE_ID
         , T.ELECTRODE_TYPE
         , T.LOSS_CODE
         , T.ITEM_ID
         , T.LANE_QTY
         , CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND LV.ATTRIBUTE1 = 'DAILY CAPA') THEN MAX(NVL(X.ITEM_VALUE, T.ITEM_VALUE))
                ELSE MIN(NVL(X.ITEM_VALUE, T.ITEM_VALUE))
           END                                                                   AS BEF_BEST
         , CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND LV.ATTRIBUTE1 = 'DAILY CAPA') THEN MIN(X.ITEM_VALUE)
                ELSE MAX(X.ITEM_VALUE)
           END                                                                   AS BEF_WORST
         , CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND LV.ATTRIBUTE1 = 'DAILY CAPA') THEN MAX(NVL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT))
                ELSE MIN(NVL(X.ITEM_VALUE_RESULT, T.ITEM_VALUE_RESULT))
           END                                                                   AS BEF_BEST_RESULT
         , CASE WHEN T.LOSS_CODE = 'LA003' OR (T.LOSS_CODE = 'LA002' AND LV.ATTRIBUTE1 = 'DAILY CAPA') THEN MIN(X.ITEM_VALUE_RESULT)
                ELSE MAX(X.ITEM_VALUE_RESULT)
           END                                                                   AS BEF_WORST_RESULT
      FROM (SELECT A.COMPANY_ID
                 , A.DIVISION_ID
                 , A.SITE_ID
                 , A.PLANT_ID
                 , A.FACTORY_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.ELECTRODE_TYPE
                 , A.LOSS_CODE
                 , A.ITEM_ID
                 , A.LANE_QTY
                 , C.BASIS_YYYYMM AS YYYYMM
                 , 0              AS ITEM_VALUE
                 , 0              AS ITEM_VALUE_RESULT
              FROM GT_XPGT_SCP0049_AVG_DATA A
                 , (SELECT DISTINCT BASIS_YYYYMM
                      FROM SCM_SYS_CALENDAR_M C
                     WHERE BASIS_YYYYMM >= V_P_FROM_YYYYMM   /* 조회 시작 월 */
                       AND BASIS_YYYYMM <= V_END_AVG) C) T
         , GT_XPGT_SCP0049_AVG_DATA X
         , SCM_SYS_LOOKUP_VALUE_SN LV                        /* 2020/11/18, khj79 */
     WHERE T.LINE_ID                  = X.LINE_ID(+)
       AND T.OPERATION_ID             = X.OPERATION_ID(+)
       AND NVL(T.ELECTRODE_TYPE, '-') = NVL(X.ELECTRODE_TYPE(+), '-')
       AND T.LOSS_CODE                = X.LOSS_CODE(+)
       AND NVL(T.ITEM_ID, '-')        = NVL(X.ITEM_ID(+), '-')
       AND T.YYYYMM                   = X.YYYYMM(+)
       AND T.PLANT_ID                 = LV.SEGMENT2
       AND T.OPERATION_ID             = LV.SEGMENT3
       AND LV.LOOKUP_TYPE_CODE        = 'CAPA_UI_CAPA_DEFINIT'
       AND LV.SEGMENT1                = 'LA002'
       AND LV.ACTIVE_FLAG             = 'Y'
     GROUP BY T.COMPANY_ID
         , T.DIVISION_ID
         , T.SITE_ID
         , T.PLANT_ID
         , T.FACTORY_ID
         , T.OPERATION_ID
         , T.LINE_ID
         , T.ELECTRODE_TYPE
         , T.LOSS_CODE
         , T.ITEM_ID
         , T.LANE_QTY
         , LV.ATTRIBUTE1
    ;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* LOSS 일별 데이터 */
    /* /////////////////////////////////////////////////////////////////////////////// */

    DELETE
      FROM GT_XPGT_SCP0049_DAILY;

    IF V_P_CHECK_LOSS = 'Y' THEN
        INSERT
          INTO GT_XPGT_SCP0049_DAILY
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , OPERATION_ID
             , LOSS_CODE
             , YYYYMMDD
             , YYYYMM
             , YYYY
             , ITEM_VALUE )
        SELECT CM.DIVISION_ID
             , CM.COMPANY_ID                          AS COMPANY_ID
             , CM.SITE_ID                             AS SITE_ID
             , CM.PLANT_ID                            AS PLANT_ID
             , CM.FACTORY_ID                          AS FACTORY_ID
             , CM.LINE_ID                             AS LINE_ID
             , CM.ELECTRODE_TYPE                      AS ELECTRODE_TYPE
             , CM.OPERATION_ID                        AS OPERATION_ID
             , LU.LOSS_CODE                           AS LOSS_CODE
             , TO_CHAR(CM.WORK_DATE, 'YYYYMMDD')      AS YYYYMMDD
             , NULL                                   AS YYYYMM
             , NULL                                   AS YYYY
             , NVL(TIME_TERM, 0)                      AS ITEM_VALUE
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_WORK_CALENDAR_M_SN CM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND CM.LOSS_CODE      = LU.LOSS_CODE
           AND CM.DIVISION_ID    = L.DIVISION_ID
           AND CM.COMPANY_ID     = L.COMPANY_ID
           AND CM.SITE_ID        = L.SITE_ID
           AND CM.PLANT_ID       = L.PLANT_ID
           AND CM.FACTORY_ID     = L.FACTORY_ID
           AND CM.OPERATION_ID   = L.OPERATION_ID
           AND CM.LINE_ID        = L.LINE_ID
           AND CM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.DATA_TABLE     = 'SCM_WORK_CALENDAR_M'
             /* AND CM.COMPANY_ID = @v_company_id */
           AND CM.DIVISION_ID    = P_DIVISION_ID
           AND TO_CHAR(CM.WORK_DATE, 'YYYYMMDD') >= V_START_DAY
           AND TO_CHAR(CM.WORK_DATE, 'YYYYMMDD') <= V_END_DAY
        ;
    END IF;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* LOSS 월별 데이터(CALENDAR, LOSS ) */
    /* /////////////////////////////////////////////////////////////////////////////// */

    DELETE
      FROM GT_XPGT_SCP0049_MM;

    IF V_P_CHECK_LOSS = 'Y' THEN
        INSERT
          INTO GT_XPGT_SCP0049_MM
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , OPERATION_ID
             , LOSS_CODE
             , YYYYMMDD
             , YYYYMM
             , YYYY
             , ITEM_VALUE )
        SELECT CM.DIVISION_ID
             , CM.COMPANY_ID
             , CM.SITE_ID
             , CM.PLANT_ID
             , CM.FACTORY_ID
             , CM.LINE_ID
             , CM.ELECTRODE_TYPE
             , CM.OPERATION_ID
             , CM.LOSS_CODE
             , TO_CHAR(NULL)                          AS YYYYMMDD
             , TO_CHAR(CM.WORK_DATE, 'YYYYMM')        AS YYYYMM
             , TO_CHAR(NULL)                          AS YYYY
             , SUM(CM.TIME_TERM)                      AS ITEM_VALUE
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_WORK_CALENDAR_M_SN CM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND CM.LOSS_CODE      = LU.LOSS_CODE
           AND CM.DIVISION_ID    = L.DIVISION_ID
           AND CM.COMPANY_ID     = L.COMPANY_ID
           AND CM.SITE_ID        = L.SITE_ID
           AND CM.PLANT_ID       = L.PLANT_ID
           AND CM.FACTORY_ID     = L.FACTORY_ID
           AND CM.OPERATION_ID   = L.OPERATION_ID
           AND CM.LINE_ID        = L.LINE_ID
           AND CM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.DATA_TABLE     = 'SCM_WORK_CALENDAR_M'
             /* AND CM.COMPANY_ID = @v_company_id */
           AND CM.DIVISION_ID    = P_DIVISION_ID
           AND TO_CHAR(CM.WORK_DATE, 'YYYYMM') >= V_START_MONTH   /* '202008' */
           AND TO_CHAR(CM.WORK_DATE, 'YYYYMM') <= V_END_MONTH     /* '202106' */
         GROUP BY CM.COMPANY_ID
             , CM.DIVISION_ID
             , CM.SITE_ID
             , CM.PLANT_ID
             , CM.FACTORY_ID
             , CM.OPERATION_ID
             , CM.LINE_ID
             , CM.ELECTRODE_TYPE
             , CM.LOSS_CODE
             , TO_CHAR(CM.WORK_DATE, 'YYYYMM')

         UNION ALL

        /* SCM_LOSS_M_SN */
        SELECT LM.DIVISION_ID
             , LM.COMPANY_ID                          AS COMPANY_ID
             , LM.SITE_ID                             AS SITE_ID
             , LM.PLANT_ID                            AS PLANT_ID
             , LM.FACTORY_ID                          AS FACTORY_ID
             , LM.LINE_ID                             AS LINE_ID
             , LM.ELECTRODE_TYPE                      AS ELECTRODE_TYPE
             , LM.OPERATION_ID                        AS OPERATION_ID
             , LU.LOSS_CODE                           AS LOSS_CODE
             , TO_CHAR(NULL)                          AS YYYYMMDD
             , WORK_MONTH                             AS YYYYMM
             , TO_CHAR(NULL)                          AS YYYY
             , NVL(ROUND(LOSS_RATE * 100, 2), 0)      AS ITEM_VALUE
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_LOSS_M_SN LM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND LM.LOSS_CODE      = LU.LOSS_CODE
           AND LM.DIVISION_ID    = L.DIVISION_ID
           AND LM.COMPANY_ID     = L.COMPANY_ID
           AND LM.SITE_ID        = L.SITE_ID
           AND LM.PLANT_ID       = L.PLANT_ID
           AND LM.FACTORY_ID     = L.FACTORY_ID
           AND LM.OPERATION_ID   = L.OPERATION_ID
           AND LM.LINE_ID        = L.LINE_ID
           AND LM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.LOSS_CODE     <> 'M08'
           AND LU.DATA_TABLE     = 'SCM_LOSS_M'
             /* AND LM.COMPANY_ID = @v_company_id */
           AND LM.DIVISION_ID    = P_DIVISION_ID
           AND WORK_MONTH >= V_START_MONTH
           AND WORK_MONTH <= V_END_MONTH
        ;
    END IF;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* LOSS 연도 데이터(CALENDAR, LOSS ) */
    /* /////////////////////////////////////////////////////////////////////////////// */

    DELETE
      FROM GT_XPGT_SCP0049_YEAR;

    IF V_P_CHECK_LOSS = 'Y' THEN
        INSERT
          INTO GT_XPGT_SCP0049_YEAR
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , OPERATION_ID
             , LOSS_CODE
             , YYYYMMDD
             , YYYYMM
             , YYYY
             , ITEM_VALUE )
        SELECT CM.DIVISION_ID
             , CM.COMPANY_ID
             , CM.SITE_ID
             , CM.PLANT_ID
             , CM.FACTORY_ID
             , CM.LINE_ID
             , CM.ELECTRODE_TYPE
             , CM.OPERATION_ID
             , CM.LOSS_CODE
             , TO_CHAR(NULL)                          AS YYYYMMDD
             , TO_CHAR(NULL)                          AS YYYYMM
             , TO_CHAR(CM.WORK_DATE, 'YYYY')          AS YYYY
             , SUM(CM.TIME_TERM)                      AS ITEM_VALUE
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_WORK_CALENDAR_M_SN CM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND CM.LOSS_CODE      = LU.LOSS_CODE
           AND CM.DIVISION_ID    = L.DIVISION_ID
           AND CM.COMPANY_ID     = L.COMPANY_ID
           AND CM.SITE_ID        = L.SITE_ID
           AND CM.PLANT_ID       = L.PLANT_ID
           AND CM.FACTORY_ID     = L.FACTORY_ID
           AND CM.OPERATION_ID   = L.OPERATION_ID
           AND CM.LINE_ID        = L.LINE_ID
           AND CM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.DATA_TABLE     = 'SCM_WORK_CALENDAR_M'
             /* AND CM.COMPANY_ID = @v_company_id */
           AND CM.DIVISION_ID    = P_DIVISION_ID
           AND TO_CHAR(CM.WORK_DATE, 'YYYY') >= V_START_YEAR   /* '2021' */
           AND TO_CHAR(CM.WORK_DATE, 'YYYY') <= V_END_YEAR     /* '2023' */
         GROUP BY CM.COMPANY_ID
             , CM.DIVISION_ID
             , CM.SITE_ID
             , CM.PLANT_ID
             , CM.FACTORY_ID
             , CM.OPERATION_ID
             , CM.LINE_ID
             , CM.ELECTRODE_TYPE
             , CM.LOSS_CODE
             , TO_CHAR(CM.WORK_DATE, 'YYYY')

         UNION ALL

        SELECT LM.DIVISION_ID
             , LM.COMPANY_ID                          AS COMPANY_ID
             , LM.SITE_ID                             AS SITE_ID
             , LM.PLANT_ID                            AS PLANT_ID
             , LM.FACTORY_ID                          AS FACTORY_ID
             , LM.LINE_ID                             AS LINE_ID
             , LM.ELECTRODE_TYPE                      AS ELECTRODE_TYPE
             , LM.OPERATION_ID                        AS OPERATION_ID
             , LM.LOSS_CODE                           AS LOSS_CODE
             , TO_CHAR(NULL)                          AS YYYYMMDD
             , TO_CHAR(NULL)                          AS YYYYMM
             , SUBSTR(WORK_MONTH, 1, 4)               AS YYYY
             , SUM(LOSS_RATE)                         AS ITEM_VALUE
          FROM GT_XPGT_SCP0049_LOOKUP LU
             , SCM_LOSS_M_SN LM
             , GT_XPGT_SCP0049_STD L
         WHERE 1 = 1
           AND LM.LOSS_CODE      = LU.LOSS_CODE
           AND LM.DIVISION_ID    = L.DIVISION_ID
           AND LM.COMPANY_ID     = L.COMPANY_ID
           AND LM.SITE_ID        = L.SITE_ID
           AND LM.PLANT_ID       = L.PLANT_ID
           AND LM.FACTORY_ID     = L.FACTORY_ID
           AND LM.OPERATION_ID   = L.OPERATION_ID
           AND LM.LINE_ID        = L.LINE_ID
           AND LM.ELECTRODE_TYPE = L.ELECTRODE_TYPE
           AND LU.DATA_TABLE     = 'SCM_LOSS_M'
             /* AND LM.COMPANY_ID = @v_company_id */
           AND LM.DIVISION_ID    = P_DIVISION_ID
           AND SUBSTR(WORK_MONTH, 1, 4) >= V_START_YEAR
           AND SUBSTR(WORK_MONTH, 1, 4) <= V_END_YEAR
         GROUP BY LM.COMPANY_ID
             , LM.DIVISION_ID
             , LM.SITE_ID
             , LM.PLANT_ID
             , LM.FACTORY_ID
             , LM.OPERATION_ID
             , LM.LINE_ID
             , LM.ELECTRODE_TYPE
             , LM.LOSS_CODE
             , SUBSTR(LM.WORK_MONTH, 1, 4)
        ;
    END IF;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* LOSS 의 DAILY , MM ,YEAR */
    /* /////////////////////////////////////////////////////////////////////////////// */
    IF V_P_CHECK_LOSS = 'Y' THEN
        /* 임시 테이블 삭제 */
        INSERT
          INTO GT_XPGT_SCP0049_DMY
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , OPERATION_ID
             , LOSS_CODE
             , YYYYMMDD
             , YYYYMM
             , YYYY
             , ITEM_VALUE )
        SELECT *
          FROM GT_XPGT_SCP0049_DAILY
         UNION ALL
        SELECT *
          FROM GT_XPGT_SCP0049_MM
         UNION ALL
        SELECT *
          FROM GT_XPGT_SCP0049_YEAR
        ;
    END IF;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* 기준테이블(STD) 를 기준으로 정보 조회 */
    /* /////////////////////////////////////////////////////////////////////////////// */
    IF V_P_CHECK_LOSS = 'Y' THEN
        INSERT
          INTO GT_XPGT_SCP0049_ADD_STD
             ( DIVISION_ID
             , COMPANY_ID
             , SITE_ID
             , PLANT_ID
             , FACTORY_ID
             , LINE_ID
             , ELECTRODE_TYPE
             , OPERATION_ID
             , LOSS_CODE
             , YYYYMMDD
             , YYYYMM
             , YYYY
             , ITEM_VALUE )
        SELECT DISTINCT X1.DIVISION_ID
             , X1.COMPANY_ID
             , X1.SITE_ID
             , X1.PLANT_ID
             , X1.FACTORY_ID
             , X1.LINE_ID
             , X1.ELECTRODE_TYPE
             , X1.OPERATION_ID
             , X1.LOSS_CODE
             , X1.YYYYMMDD
             , X1.YYYYMM
             , X1.YYYY
             , R.ITEM_VALUE
          FROM (/* 중복 제거를 위해 DISTINCT 처리 */


                SELECT DISTINCT
                       R.DIVISION_ID
                     , R.COMPANY_ID
                     , R.SITE_ID
                     , R.PLANT_ID
                     , R.FACTORY_ID
                     , R.LINE_ID
                     , R.ELECTRODE_TYPE
                     , R.OPERATION_ID
                     , LU.LOSS_CODE
                     , R.YYYYMMDD
                     , R.YYYYMM
                     , R.YYYY
                  FROM (SELECT DISTINCT
                               A.DIVISION_ID
                             , A.COMPANY_ID
                             , A.SITE_ID
                             , A.PLANT_ID
                             , A.FACTORY_ID
                             , A.LINE_ID
                             , A.ELECTRODE_TYPE
                             , A.OPERATION_ID
                             , B.YYYYMMDD
                             , B.YYYYMM
                             , B.YYYY
                          FROM GT_XPGT_SCP0049_STD A
                             , GT_XPGT_SCP0049_DMY B
                         WHERE A.DIVISION_ID    = B.DIVISION_ID(+)
                           AND A.COMPANY_ID     = B.COMPANY_ID(+)
                           AND A.SITE_ID        = B.SITE_ID(+)
                           AND A.PLANT_ID       = B.PLANT_ID(+)
                           AND A.FACTORY_ID     = B.FACTORY_ID(+)
                           AND A.LINE_ID        = B.LINE_ID(+)
                           AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE(+)
                           AND A.OPERATION_ID   = B.OPERATION_ID(+)) R
                     , GT_XPGT_SCP0049_LOOKUP LU
                 WHERE 1 = 1
                   AND LU.DATA_TABLE IN ('SCM_WORK_CALENDAR_M', 'SCM_LOSS_M')) X1   /* LOOKUP 정보 추가 */
             , GT_XPGT_SCP0049_DMY R
         WHERE R.DIVISION_ID(+)           = X1.DIVISION_ID
           AND R.COMPANY_ID(+)            = X1.COMPANY_ID
           AND R.SITE_ID(+)               = X1.SITE_ID
           AND R.PLANT_ID(+)              = X1.PLANT_ID
           AND R.FACTORY_ID(+)            = X1.FACTORY_ID
           AND R.LINE_ID(+)               = X1.LINE_ID
           AND R.ELECTRODE_TYPE(+)        = X1.ELECTRODE_TYPE
           AND R.OPERATION_ID(+)          = X1.OPERATION_ID
           AND R.LOSS_CODE(+)             = X1.LOSS_CODE
           AND NVL(R.YYYYMMDD(+), '-')    = NVL(X1.YYYYMMDD, '-')
           AND NVL(R.YYYYMM(+), '-')      = NVL(X1.YYYYMM, '-')
           AND NVL(R.YYYY(+), '-')        = NVL(X1.YYYY, '-')
        ;
    END IF;

    INSERT
      INTO GT_XPGT_SCP0049_LTY_RESULT
         ( DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , OPERATION_ID
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
         , YYYYMMDD
         , YYYYMM
         , YYYY
         , ITEM_VALUE )
    SELECT DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , OPERATION_ID
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
         , YYYYMMDD
         , YYYYMM
         , YYYY
         , ITEM_VALUE
      FROM GT_XPGT_SCP0049_LTY
    ;

    /* /////////////////////////////////////////////////////////////////////////////// */
    /* 데이터 합치기 */
    /* /////////////////////////////////////////////////////////////////////////////// */
    INSERT
      INTO GT_XPGT_SCP0049_ALL
         ( DIVISION_ID
         , COMPANY_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , OPERATION_ID
         , LOSS_CODE
         , ITEM_ID
         , LANE_QTY
         , YYYYMMDD
         , YYYYMM
         , YYYY
         , ITEM_VALUE
         , BEF_M6
         , BEF_M5
         , BEF_M4
         , BEF_M3
         , BEF_M2
         , BEF_M1
         , BEF_M6_RESULT
         , BEF_M5_RESULT
         , BEF_M4_RESULT
         , BEF_M3_RESULT
         , BEF_M2_RESULT
         , BEF_M1_RESULT )
    SELECT LK.DIVISION_ID
         , LK.COMPANY_ID
         , LK.SITE_ID
         , LK.PLANT_ID
         , LK.FACTORY_ID
         , LK.LINE_ID
         , LK.ELECTRODE_TYPE
         , LK.OPERATION_ID
         , LK.LOSS_CODE
         , '-'                AS ITEM_ID
         , TO_NUMBER(NULL)    AS LANE_QTY
         , LK.YYYYMMDD
         , LK.YYYYMM          AS YYYYMM
         , LK.YYYY            AS YYYY
         , LK.ITEM_VALUE
         , 0                  AS BEF_M6
         , 0                  AS BEF_M5
         , 0                  AS BEF_M4
         , 0                  AS BEF_M3
         , 0                  AS BEF_M2
         , 0                  AS BEF_M1
         , 0                  AS BEF_M6_RESULT
         , 0                  AS BEF_M5_RESULT
         , 0                  AS BEF_M4_RESULT
         , 0                  AS BEF_M3_RESULT
         , 0                  AS BEF_M2_RESULT
         , 0                  AS BEF_M1_RESULT
      FROM GT_XPGT_SCP0049_ADD_STD LK

     UNION ALL

    SELECT LTY.DIVISION_ID
         , LTY.COMPANY_ID
         , LTY.SITE_ID
         , LTY.PLANT_ID
         , LTY.FACTORY_ID
         , LTY.LINE_ID
         , LTY.ELECTRODE_TYPE
         , LTY.OPERATION_ID
         , LTY.LOSS_CODE
         , LTY.ITEM_ID
         , LTY.LANE_QTY
         , LTY.YYYYMMDD
         , LTY.YYYYMM
         , LTY.YYYY
         , LTY.ITEM_VALUE
         , 0                  AS BEF_M6
         , 0                  AS BEF_M5
         , 0                  AS BEF_M4
         , 0                  AS BEF_M3
         , 0                  AS BEF_M2
         , 0                  AS BEF_M1
         , 0                  AS BEF_M6_RESULT
         , 0                  AS BEF_M5_RESULT
         , 0                  AS BEF_M4_RESULT
         , 0                  AS BEF_M3_RESULT
         , 0                  AS BEF_M2_RESULT
         , 0                  AS BEF_M1_RESULT
      FROM GT_XPGT_SCP0049_LTY_RESULT LTY
    ;

    /* ///////////////////////////////// XA001 데이터 넣기 날짜별 생성 //////////////// */


    INSERT
      INTO GT_XPGT_SCP0049_ALL
         ( COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LOSS_CODE
         , ITEM_ID
         , YYYYMMDD
         , YYYYMM
         , YYYY
         , ITEM_VALUE
         , BEF_M6
         , BEF_M5
         , BEF_M4
         , BEF_M3
         , BEF_M2
         , BEF_M1
         , BEF_M6_RESULT
         , BEF_M5_RESULT
         , BEF_M4_RESULT
         , BEF_M3_RESULT
         , BEF_M2_RESULT
         , BEF_M1_RESULT )
    SELECT COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , 'XA001'
         , '-'
         , C1.BASIS_YYYYMMDD
         , TO_CHAR(NULL)
         , TO_CHAR(NULL)
         , 1440
         , 0, 0, 0, 0, 0, 0
         , 0, 0, 0, 0, 0, 0
      FROM (SELECT DISTINCT
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , OPERATION_ID
                 , LINE_ID
                 , ELECTRODE_TYPE
                 , ITEM_ID
              FROM GT_XPGT_SCP0049_ALL A
                 , GT_XPGT_SCP0049_LOOKUP L
             WHERE A.LOSS_CODE = L.LOSS_CODE
               AND L.DATA_TABLE IN ('SCM_WORK_CALENDAR_M', 'SCM_LOSS_M')) X
      LEFT JOIN SCM_SYS_CALENDAR_M C1
        ON C1.BASIS_YYYYMMDD >= V_START_DAY
       AND C1.BASIS_YYYYMMDD <= V_END_DAY

     UNION ALL

    SELECT COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , 'XA001'
         , '-'
         , TO_CHAR(NULL)
         , C1.BASIS_YYYYMM
         , TO_CHAR(NULL)
         , TO_NUMBER(C1.CALENDAR_DAY)
         , 0, 0, 0, 0, 0, 0
         , 0, 0, 0, 0, 0, 0
      FROM (SELECT DISTINCT
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , OPERATION_ID
                 , LINE_ID
                 , ELECTRODE_TYPE
                 , ITEM_ID
              FROM GT_XPGT_SCP0049_ALL A
                 , GT_XPGT_SCP0049_LOOKUP L
             WHERE A.LOSS_CODE = L.LOSS_CODE
               AND L.DATA_TABLE IN ('SCM_WORK_CALENDAR_M', 'SCM_LOSS_M')) X
      LEFT JOIN (SELECT BASIS_YYYYMM
                      , MAX(CALENDAR_DAY) AS CALENDAR_DAY
                   FROM SCM_SYS_CALENDAR_M
                  WHERE BASIS_YYYYMM >= V_START_MONTH
                    AND BASIS_YYYYMM <= V_END_MONTH
                  GROUP BY BASIS_YYYYMM) C1
        ON 1 = 1

     UNION ALL

    SELECT COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , 'XA001'
         , '-'
         , TO_CHAR(NULL)
         , TO_CHAR(NULL)
         , C1.CALENDAR_YYYY
         , C1.YEAR_CNT
         , 0, 0, 0, 0, 0, 0
         , 0, 0, 0, 0, 0, 0
      FROM (SELECT DISTINCT
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , OPERATION_ID
                 , LINE_ID
                 , ELECTRODE_TYPE
                 , ITEM_ID
              FROM GT_XPGT_SCP0049_ALL A
                 , GT_XPGT_SCP0049_LOOKUP L
             WHERE A.LOSS_CODE = L.LOSS_CODE
               AND L.DATA_TABLE IN ('SCM_WORK_CALENDAR_M', 'SCM_LOSS_M')) X
      LEFT JOIN (SELECT CALENDAR_YYYY
                      , COUNT(1) AS YEAR_CNT
                   FROM SCM_SYS_CALENDAR_M A
                  WHERE A.CALENDAR_YYYY >= V_START_YEAR
                    AND A.CALENDAR_YYYY <= V_END_YEAR
                  GROUP BY CALENDAR_YYYY) C1
        ON 1 = 1
    ;

    /* ///////////////////////////////// CACULATOR 날짜별 생성 //////////////// */


    INSERT
      INTO GT_XPGT_SCP0049_ALL
         ( COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LOSS_CODE
         , ITEM_ID
         , YYYYMMDD
         , YYYYMM
         , YYYY
         , ITEM_VALUE
         , BEF_M6
         , BEF_M5
         , BEF_M4
         , BEF_M3
         , BEF_M2
         , BEF_M1
         , BEF_M6_RESULT
         , BEF_M5_RESULT
         , BEF_M4_RESULT
         , BEF_M3_RESULT
         , BEF_M2_RESULT
         , BEF_M1_RESULT )
    SELECT COMPANY_ID
         , DIVISION_ID
         , SITE_ID
         , PLANT_ID
         , FACTORY_ID
         , OPERATION_ID
         , LINE_ID
         , ELECTRODE_TYPE
         , LK.LOSS_CODE
         , '-'
         , YYYYMMDD
         , YYYYMM
         , YYYY
         , 0
         , 0, 0, 0, 0, 0, 0
         , 0, 0, 0, 0, 0, 0
      FROM (SELECT DISTINCT
                   COMPANY_ID
                 , DIVISION_ID
                 , SITE_ID
                 , PLANT_ID
                 , FACTORY_ID
                 , OPERATION_ID
                 , LINE_ID
                 , ELECTRODE_TYPE
                 , ITEM_ID
                 , YYYYMMDD
                 , YYYYMM
                 , YYYY
              FROM GT_XPGT_SCP0049_ALL A
             WHERE LOSS_CODE = 'XA001'
               AND YYYYMM = V_START_MONTH) A
      LEFT JOIN GT_XPGT_SCP0049_LOOKUP LK
        ON LK.DATA_TABLE = 'CAL'
       AND LK.LOSS_CODE <> 'XA001'
    ;


    MERGE
      INTO GT_XPGT_SCP0049_ALL X
     USING GT_XPGT_SCP0049_AVG A
        ON ( A.DIVISION_ID  = X.DIVISION_ID
         AND A.COMPANY_ID   = X.COMPANY_ID
         AND A.SITE_ID      = X.SITE_ID
         AND A.PLANT_ID     = X.PLANT_ID
         AND A.FACTORY_ID   = X.FACTORY_ID
         AND A.LINE_ID      = X.LINE_ID
         AND NVL(A.ELECTRODE_TYPE, '-') = NVL(X.ELECTRODE_TYPE, '-')
         AND A.OPERATION_ID = X.OPERATION_ID
         AND A.LOSS_CODE    = X.LOSS_CODE
         AND NVL(A.ITEM_ID, '-') = NVL(X.ITEM_ID, '-') )
      WHEN MATCHED THEN
    UPDATE
       SET X.BEF_M6         = NVL(A.BEF_M6, 0)
         , X.BEF_M5         = NVL(A.BEF_M5, 0)
         , X.BEF_M4         = NVL(A.BEF_M4, 0)
         , X.BEF_M3         = NVL(A.BEF_M3, 0)
         , X.BEF_M2         = NVL(A.BEF_M2, 0)
         , X.BEF_M1         = NVL(A.BEF_M1, 0)
         , X.BEF_M6_RESULT  = NVL(A.BEF_M6_RESULT, 0)
         , X.BEF_M5_RESULT  = NVL(A.BEF_M5_RESULT, 0)
         , X.BEF_M4_RESULT  = NVL(A.BEF_M4_RESULT, 0)
         , X.BEF_M3_RESULT  = NVL(A.BEF_M3_RESULT, 0)
         , X.BEF_M2_RESULT  = NVL(A.BEF_M2_RESULT, 0)
         , X.BEF_M1_RESULT  = NVL(A.BEF_M1_RESULT, 0)
    ;

    UPDATE GT_XPGT_SCP0049_ALL X
       SET X.BEF_M6           = V_BEF_M6_COUNT
         , X.BEF_M5           = V_BEF_M5_COUNT
         , X.BEF_M4           = V_BEF_M4_COUNT
         , X.BEF_M3           = V_BEF_M3_COUNT
         , X.BEF_M2           = V_BEF_M2_COUNT
         , X.BEF_M1           = V_BEF_M1_COUNT
         , X.BEF_M6_RESULT    = V_BEF_M6_COUNT
         , X.BEF_M5_RESULT    = V_BEF_M5_COUNT
         , X.BEF_M4_RESULT    = V_BEF_M4_COUNT
         , X.BEF_M3_RESULT    = V_BEF_M3_COUNT
         , X.BEF_M2_RESULT    = V_BEF_M2_COUNT
         , X.BEF_M1_RESULT    = V_BEF_M1_COUNT
         , X.BEF_BEST         = V_BEF_MAX_COUNT
         , X.BEF_WORST        = V_BEF_MIN_COUNT
         , X.BEF_BEST_RESULT  = V_BEF_MAX_COUNT
         , X.BEF_WORST_RESULT = V_BEF_MIN_COUNT
     WHERE X.LOSS_CODE = 'XA001'
    ;


    MERGE
      INTO GT_XPGT_SCP0049_ALL X
     USING GT_XPGT_SCP0049_AVG_MIN_MAX A
        ON ( A.DIVISION_ID  = X.DIVISION_ID
         AND A.COMPANY_ID   = X.COMPANY_ID
         AND A.SITE_ID      = X.SITE_ID
         AND A.PLANT_ID     = X.PLANT_ID
         AND A.FACTORY_ID   = X.FACTORY_ID
         AND A.LINE_ID      = X.LINE_ID
         AND NVL(A.ELECTRODE_TYPE, '-') = NVL(X.ELECTRODE_TYPE, '-')
         AND A.OPERATION_ID = X.OPERATION_ID
         AND A.LOSS_CODE    = X.LOSS_CODE
         AND NVL(A.ITEM_ID, '-') = NVL(X.ITEM_ID, '-') )
      WHEN MATCHED THEN
    UPDATE
       SET X.BEF_BEST         = NVL(A.BEF_BEST, 0)
         , X.BEF_WORST        = NVL(A.BEF_WORST, 0)
         , X.BEF_BEST_RESULT  = NVL(A.BEF_BEST_RESULT, 0)
         , X.BEF_WORST_RESULT = NVL(A.BEF_WORST_RESULT, 0)
    ;

    /* [TEST] */
    /* SELECT * FROM #TMP_SCP0049_ALL */

    /* 요청기간(플랜구간)에 따른 CAPA Available working time */

    OPEN O_RESULT_CURSOR FOR
    SELECT LINE_ID AS LINE
         , OPERATION_ID AS OPERATION
         , A.YYYYMMDD
         , TRUNC(A.A_VALUE - (A.B_VALUE + A.C_VALUE)) AS TIME
      FROM (SELECT X.LINE_ID
                 , X.OPERATION_ID
                 , X.YYYYMMDD
                 , SUM((CASE WHEN X.LOSS_CODE = 'XA001' THEN X.ITEM_VALUE ELSE 0 END)) AS A_VALUE
                 , SUM((CASE WHEN X.LOSS_CODE = 'EL001' THEN X.ITEM_VALUE ELSE 0 END)) AS B_VALUE
                 , SUM((CASE WHEN X.LOSS_CODE = 'EL002' THEN X.ITEM_VALUE ELSE 0 END)) AS C_VALUE
              FROM GT_XPGT_SCP0049_ALL X
                 , GT_XPGT_SCP0049_LOOKUP L
             WHERE 1 = 1
               AND X.LOSS_CODE = L.LOSS_CODE
               AND X.LOSS_CODE IN ('XA001', 'EL001', 'EL002')
               AND X.YYYYMMDD IS NOT NULL
               AND X.LINE_ID      IN (SELECT LINE_ID
                                        FROM GT_XPGT_TB_LINE)
               AND X.OPERATION_ID IN (SELECT OPERATION_ID
                                        FROM GT_XPGT_TB_OPERATION)
             GROUP BY X.LINE_ID
                 , X.OPERATION_ID
                 , X.YYYYMMDD) A
     WHERE A.YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND V_P_TO_YYYYMMDD;

    /*       IF OBJECT_ID('TEMPDB..#TMP_SCP0049_LTY')         IS NOT NULL DROP TABLE #TMP_SCP0049_LTY;
       IF OBJECT_ID('TEMPDB..#TMP_SCP0049_ALL')         IS NOT NULL DROP TABLE #TMP_SCP0049_ALL; */
END;