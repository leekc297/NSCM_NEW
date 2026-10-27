PROCEDURE PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST
(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD  VARCHAR2
    ,V_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST
 * Description  : EE(전극) Optimization Engine 입력용 Model List(STAGE: COATING/TARGETBIZ/ELECBIZ) 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.09.02    Philsu Park    Initial Release
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    /* 2025.05.28 Philsu Park Initial Release. */
    /* 2025.05.30 Philsu Park: OPT ENG LOOKUP 반영. */
    /* ------------------------------------------------------------------ */
    /* Set Prameter                                                        */
    /* ------------------------------------------------------------------ */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST';
    V_PLAN_ID             VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT        VARCHAR2(1000 CHAR);
    V_DETAIL_DATE         DATE;
    /* ------------------------------------------------------------------ */
    /* Set Param for Biz                                                   */
    /* ------------------------------------------------------------------ */
    V_PLAN_START_YYYYMM   VARCHAR2(6 CHAR)  := SUBSTR(V_PLAN_START_YYYYMMDD, 1, 6);
    V_PLAN_END_YYYYMM     VARCHAR2(6 CHAR)  := SUBSTR(V_PLAN_END_YYYYMMDD, 1, 6);
    V_MAX_TUESDAY         VARCHAR2(8 CHAR);
    D_PLAN_NAME           DATE;
    V_DEMAND_CUTOFF_DAY   VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION      VARCHAR2(50 CHAR);
    V_SINGLE_PLAN_TYPE    VARCHAR2(1 CHAR);
    V_PLAN_GROUP_ORG      VARCHAR2(20 CHAR);
BEGIN
    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    V_SINGLE_PLAN_TYPE := CASE WHEN SUBSTR(V_GROUP_ID, -2) = '_C' THEN 'C'
                               WHEN SUBSTR(V_GROUP_ID, -2) = '_A' THEN 'A'
                               ELSE '-'
                          END;
    V_PLAN_GROUP_ORG   := CASE WHEN SUBSTR(V_GROUP_ID, -2) IN ('_C', '_A') THEN SUBSTR(V_GROUP_ID, 1, LENGTH(V_GROUP_ID) - 2)
                               ELSE V_GROUP_ID
                          END;

    /* ------------------------------------------------------------------ */
    /* Transaction (START)                                                 */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ------------------------------------------------------------------ */
    BEGIN


        DELETE
          FROM GT_OPTENG_EE_DIV;

        DELETE
          FROM GT_OPTENG_EE_ELEC;

        DELETE
          FROM GT_OPTENG_EE_BIZ;

        DELETE
          FROM GT_OPTENG_EE_ELECBIZ;

        DELETE
          FROM GT_OPTENG_EE_DMORD;

        /* ------------------------------------------------------------------ */
        /* Origin Division                                                     */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO GT_OPTENG_EE_DIV
             ( DIVISION_ID )
        SELECT DIVISION_ID
          FROM SCM_MST_DIVISION
         WHERE VALID_YN    = 'Y'
           AND ATTRIBUTE3 <> 'EE'
           AND ATTRIBUTE4  = (SELECT ATTRIBUTE4
                                FROM SCM_MST_DIVISION
                               WHERE DIVISION_ID = V_DIVISION_ID);   /* 전극 Division 변수 */

        /* ------------------------------------------------------------------ */
        /* Set Param For Find latest demand version.                           */
        /* ------------------------------------------------------------------ */
        SELECT MAX(BASIS_YYYYMMDD)
          INTO V_MAX_TUESDAY
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND DAYOFWEEK       = 'TUE';

        D_PLAN_NAME := TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD');

        SELECT NVL(MAX(P.CUTOFF_YYYYMMDD), V_MAX_TUESDAY)
          INTO V_DEMAND_CUTOFF_DAY
          FROM DM_PLN_NET_DEMAND P
             , GT_OPTENG_EE_DIV  DIV
         WHERE DIV.DIVISION_ID     = P.DIVISION_ID
           AND 1=1
           /* AND P.DIVISION_ID    = V_DIVISION_ID */
           AND P.CUTOFF_YYYYMMDD  >= TO_CHAR(D_PLAN_NAME - 3, 'YYYYMMDD')    /* 월요일 기준 최근 3일 이내 */
           AND P.CUTOFF_YYYYMMDD  <= TO_CHAR(D_PLAN_NAME + 6, 'YYYYMMDD');   /* 해당 주차 일요일 이전 */

        /* ------------------------------------------------------------------ */
        /* SELECT  @V_DM_MAX_VERSION = MAX(P.VERSION_NO)
        FROM    DM_PLN_NET_DEMAND P WITH(NOLOCK)
        INNER JOIN #DIVISION DIV
            ON DIV.DIVISION_ID = P.DIVISION_ID
        WHERE   P.CUTOFF_YYYYMMDD  = @V_DEMAND_CUTOFF_DAY
        ; */

        INSERT
          INTO GT_OPTENG_EE_DMORD
             ( DIVISION_ID
             , VERSION_NO
             , CUTOFF_YYYYMMDD
             , R_NUM )
        SELECT DIVISION_ID
             , VERSION_NO
             , CUTOFF_YYYYMMDD
             , R_NUM
          FROM (SELECT P.DIVISION_ID
                     , P.VERSION_NO
                     , P.CUTOFF_YYYYMMDD
                     , ROW_NUMBER() OVER (PARTITION BY P.DIVISION_ID ORDER BY CUTOFF_YYYYMMDD DESC, VERSION_NO DESC) AS R_NUM
                  FROM DM_PLN_NET_DEMAND P
                     , GT_OPTENG_EE_DIV  DIV
                 WHERE DIV.DIVISION_ID    = P.DIVISION_ID
                   AND 1=1
                   /* AND P.DIVISION_ID   = V_DIVISION_ID */
                   AND P.CUTOFF_YYYYMMDD >= TO_CHAR(D_PLAN_NAME - 3, 'YYYYMMDD')    /* 월요일 기준 최근 3일 이내 */
                   AND P.CUTOFF_YYYYMMDD <= TO_CHAR(D_PLAN_NAME + 6, 'YYYYMMDD')) DM   /* 해당 주차 일요일 이전 */
         WHERE DM.R_NUM = 1;

        /* ------------------------------------------------------------------ */
        /* Data Insert Start                                                   */
        /* ------------------------------------------------------------------ */
        /* 1. STAGE: COATING(ELEC_POST는 동일 ITEM 이므로 제외)                */
        /* FLOW_ID 기준으로 LINE_ASSIGN에서 추출.                              */
        /* 1. GROUP에 해당하는 전극 ITEM 추출.                                 */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO GT_OPTENG_EE_ELEC
             ( PLAN_ID
             , SCM_SITE_ID
             , COMPANY_ID
             , DIVISION_ID
             , SITE_ID
             , ITEM_ID
             , STAGE
             , PLANT_ID
             , OPERATION_ID )
        WITH PLAN_GROUP AS (
             SELECT GR.OPMZ_PLAN_GR_NAME AS PLAN_GROUP_NAME
                  , T.OPMZ_PLAN_GR_ID    AS PLAN_GROUP_ID
                  , T.LINE_ID            AS LINE_ID
                  , T.OPERATION_ID       AS OPERATION_ID
                  , T.FACTORY_ID         AS FACTORY_ID
                  , T.PLANT_ID           AS PLANT_ID
                  , T.ITEM_ID            AS ITEM_ID
               FROM SCP_OPMZ_PLAN_GR_LINE_M T
                  , SCP_OPMZ_PLAN_GR_M     GR
                  , SCM_LINE_M_SN          LM
              WHERE T.OPMZ_PLAN_GR_ID   = GR.OPMZ_PLAN_GR_ID
                AND LM.PLANT_ID         = T.PLANT_ID
                AND LM.FACTORY_ID       = T.FACTORY_ID
                AND LM.LINE_ID          = T.LINE_ID
                AND LM.OPERATION_ID     = T.OPERATION_ID
                AND LM.ACTIVE_FLAG      = 'Y'
                /* AND LM.ELECTRODE_TYPE   = CASE WHEN 'Y' = 'Y' THEN  'Cathode' */
                AND T.VALID_YN          = 'Y'
                AND GR.OPMZ_PLAN_GR_NAME = V_PLAN_GROUP_ORG   /* PLAN_GROUP이 양극 또는 음극인 경우 원래 Plan Group으로 찾아와야 함. */
                AND LM.ELECTRODE_TYPE LIKE CASE WHEN V_SINGLE_PLAN_TYPE = '-' THEN '%%' ELSE V_SINGLE_PLAN_TYPE || '%' END   /* 양음극 특정 Type인 경우 해당하는 Line정보만 추출 */
             )
        /* 위 정의된 라인 기준으로 Item List 추출. */
        SELECT V_PLAN_ID          AS PLAN_ID
             , ST.SCM_SITE_ID     AS SCM_SITE_ID
             , ILA.COMPANY_ID     AS COMPANY_ID
             , ILA.DIVISION_ID    AS DIVISION_ID
             , ILA.SITE_ID        AS SITE_ID
             , ILA.ITEM_ID        AS ITEM_ID
             , CASE WHEN ILA.OPERATION_ID = 'E2000' THEN 'COATING'     /* COATING */
                    WHEN ILA.OPERATION_ID = 'A9000' THEN 'TARGETBIZ'   /* LAMI, HALF LAMI */
                    ELSE '-'
               END                AS STAGE
             , ILA.PLANT_ID       AS PLANT_ID
             , ILA.OPERATION_ID   AS OPERATION_ID
          FROM SCM_MST_ITEM_LINE_ASSIGN_SN ILA
             , GT_OPTENG_EE_DIV            DIV
             , PLAN_GROUP                  GRP
             , (SELECT DISTINCT DIVISION_ID
                              , ITEM_ID
                              , OPERATION_GROUP
                              , FLOW_ID
                              , ATTRIBUTE8
                  FROM SCP_MST_FINAL_ITEM
                 WHERE 1=1) FNL
             , SCM_ITEM_M_SN               SIM
             , SCM_MST_SITE                ST
         WHERE ILA.DIVISION_ID       = DIV.DIVISION_ID
           AND ILA.LINE_ID           = GRP.LINE_ID
           AND ILA.OPERATION_ID      = GRP.OPERATION_ID
           AND ILA.FACTORY_ID        = GRP.FACTORY_ID
           AND ILA.PLANT_ID          = GRP.PLANT_ID
           AND ILA.ITEM_ID           = CASE WHEN GRP.ITEM_ID = '-' THEN ILA.ITEM_ID ELSE GRP.ITEM_ID END   /* ITEM 명시 안되어있으면 ASSIGN 전체. */
           AND ILA.DIVISION_ID       = FNL.DIVISION_ID
           AND ILA.ITEM_ID           = FNL.ITEM_ID
           AND 1=1
           AND ILA.COMPANY_ID        = SIM.COMPANY_ID
           AND ILA.DIVISION_ID       = SIM.DIVISION_ID
           AND ILA.SITE_ID           = SIM.SITE_ID
           AND ILA.ITEM_ID           = SIM.ITEM_ID
           AND SIM.ACTIVE_FLAG       = 'Y'
           /* ST 는 As-Is LEFT OUTER JOIN SCM_MST_SITE -> 콤마+(+) 전환(FMT SOP §4.72). */
           AND ILA.DIVISION_ID       = ST.DIVISION_ID(+)
           AND ILA.PLANT_ID          = ST.PLANT_ID(+)
           AND ILA.SITE_ID           = ST.SITE_ID(+)
           AND ST.OPERATION_GROUP(+) = FNL.OPERATION_GROUP
           AND ST.VALID_YN(+)        = 'Y'
           AND 1=1
           AND ILA.ACTIVE_FLAG       = 'Y'
           AND ILA.PRIORITY         <> 9                     /* 신재욱 책임님 요청. 9순위 제외 */
           AND ILA.MONTH        BETWEEN V_PLAN_START_YYYYMM AND V_PLAN_END_YYYYMM
         GROUP BY ST.SCM_SITE_ID
                , ILA.ITEM_ID
                , ILA.OPERATION_ID
                , ILA.PLANT_ID
                , ILA.COMPANY_ID
                , ILA.DIVISION_ID
                , ILA.SITE_ID;

        /* ------------------------------------------------------------------ */
        /* 1. STAGE: TARGETBIZ                                                 */
        /* FLOW_ID 기준으로 LINE_ASSIGN에서 추출.                              */
        /* 2025.09.25 Philsu Park: 조립 - 전극 Site Mapping 정보(SITE_INFO)     */
        /*                         동일 COMPANY 하위 2개 이상의 PLANT 반영되게 수정. */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO GT_OPTENG_EE_BIZ
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE )
        WITH SITE_INFO AS (
             /* SELECT    S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.SCM_SITE_ID, ''))  AS ASY_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'A', S.PLANT_ID, ''))     AS ASY_PLANT_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.SCM_SITE_ID, ''))  AS ELEC_SITE_ID
                        , MAX(IIF(S.OPERATION_GROUP = 'E', S.PLANT_ID, ''))     AS ELEC_PLANT_ID
                FROM    SCM_MST_SITE S WITH(NOLOCK)
                INNER JOIN #DIVISION DIV
                    ON  DIV.DIVISION_ID     = S.DIVISION_ID
                WHERE   S.OPERATION_GROUP  IN ('A', 'E')
                AND     S.VALID_YN          = 'Y'
                GROUP BY S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY */
             SELECT S.DIVISION_ID
                  , S.COMPANY_ID
                  , S.SITE_ID
                  , S.CITY
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'A' THEN S.SCM_SITE_ID ELSE '' END) AS ASY_SITE_ID
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'A' THEN S.PLANT_ID ELSE '' END)    AS ASY_PLANT_ID
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.SCM_SITE_ID ELSE '' END) AS ELEC_SITE_ID
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.PLANT_ID ELSE '' END)    AS ELEC_PLANT_ID
               FROM SCM_MST_SITE     S
                  , GT_OPTENG_EE_DIV DIV
              WHERE DIV.DIVISION_ID    = S.DIVISION_ID
                AND S.OPERATION_GROUP IN ('A', 'E')
                AND S.VALID_YN         = 'Y'
                AND S.SITE_TYPE        = 'PLANT'
                AND S.OSP_YN           = 'N'
              GROUP BY S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY
             HAVING MAX(CASE WHEN S.OPERATION_GROUP = 'A' THEN S.PLANT_ID ELSE '' END) <> MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.PLANT_ID ELSE '' END)
                AND RTRIM(MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.PLANT_ID ELSE '' END)) IS NOT NULL
             UNION
             SELECT S.DIVISION_ID
                  , S.COMPANY_ID
                  , S.SITE_ID
                  , S.CITY
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'A' THEN S.SCM_SITE_ID ELSE '' END) AS ASY_SITE_ID
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'A' THEN S.PLANT_ID ELSE '' END)    AS ASY_PLANT_ID
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.SCM_SITE_ID ELSE '' END) AS ELEC_SITE_ID
                  , MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.PLANT_ID ELSE '' END)    AS ELEC_PLANT_ID
               FROM SCM_MST_SITE     S
                  , GT_OPTENG_EE_DIV DIV
              WHERE DIV.DIVISION_ID    = S.DIVISION_ID
                AND S.OPERATION_GROUP IN ('A', 'E')
                AND S.VALID_YN         = 'Y'
                AND S.SITE_TYPE        = 'PLANT'
                AND S.OSP_YN           = 'N'
              GROUP BY S.DIVISION_ID, S.COMPANY_ID, S.SITE_ID, S.CITY, S.PLANT_ID
             HAVING MAX(CASE WHEN S.OPERATION_GROUP = 'A' THEN S.PLANT_ID ELSE '' END) = MAX(CASE WHEN S.OPERATION_GROUP = 'E' THEN S.PLANT_ID ELSE '' END)
             )
        SELECT V_PLAN_ID           AS PLAN_ID
             , EL.ASY_SITE_ID      AS SCM_SITE_ID
             , BOM.PARENT_ITEM_ID  AS ITEM_ID
             , 'TARGETBIZ'         AS STAGE
          FROM SCP_MST_BOM_ELEC BOM
             , (SELECT LI.COMPANY_ID
                     , LI.DIVISION_ID
                     , LI.SITE_ID
                     , LI.PLANT_ID
                     , LI.ITEM_ID
                     , ST.ASY_SITE_ID
                  FROM GT_OPTENG_EE_ELEC LI
                     , SITE_INFO         ST
                 WHERE LI.COMPANY_ID  = ST.COMPANY_ID
                   AND LI.DIVISION_ID = ST.DIVISION_ID
                   AND LI.SITE_ID     = ST.SITE_ID
                   AND LI.PLANT_ID    = ST.ELEC_PLANT_ID
                   AND LI.SCM_SITE_ID = ST.ELEC_SITE_ID
                   AND 1=1) EL
         WHERE EL.DIVISION_ID = BOM.DIVISION_ID
           AND EL.ITEM_ID     = BOM.CHILD_ITEM_ID
           AND EXISTS (SELECT 1
                         FROM SCM_ITEM_M_SN ITM
                        WHERE ITM.COMPANY_ID = EL.COMPANY_ID
                          AND ITM.SITE_ID    = EL.SITE_ID
                          AND ITM.ITEM_ID    = BOM.PARENT_ITEM_ID
                          AND 1=1
                          /* AND ITM.DIVISION_ID = BOM.DIVISION_ID */
                          AND ITM.ITEM_CLASS = 'ES1901')   /* Cell Assy. */
           AND BOM.SCP_YN     = 'Y'
         GROUP BY EL.ASY_SITE_ID, BOM.PARENT_ITEM_ID
        UNION
        SELECT V_PLAN_ID     AS PLAN_ID
             , SEGMENT2      AS SITE_ID
             , SEGMENT3      AS ITEM_ID
             , 'TARGETBIZ'   AS STAGE
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LK
         WHERE LK.LOOKUP_TYPE = 'SCP_OPT_ELEC_DEMAND_SITE'
           AND LK.VALID_YN    = 'Y'
           AND LK.SEGMENT1    = V_DIVISION_ID
           AND LK.SEGMENT4    = V_GROUP_ID;

        /* ------------------------------------------------------------------ */
        /* 6. STAGE: ELEC_BIZ:                                                 */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO GT_OPTENG_EE_ELECBIZ
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE )
        SELECT DISTINCT
               V_PLAN_ID       AS PLAN_ID
             , A.SCM_SITE_ID   AS SCM_SITE_ID
             , A.ITEM_ID       AS ITEM_ID
             /* , IIF(B.OPERATION_GROUP = 'A', 'ELECBIZ', '-') AS ITEM_STAGE */
             , 'ELECBIZ'       AS STAGE
          FROM DM_PLN_NET_DEMAND  A
             , GT_OPTENG_EE_DMORD DM
             , GT_OPTENG_EE_DIV   DIV
             , (SELECT DISTINCT DIVISION_ID
                              , ITEM_ID
                  FROM GT_OPTENG_EE_ELEC) CM
             /*  UNION
                 SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                 FROM   #ASSY_MODEL_LIST
                 WHERE  ITEM_STAGE IN ('MDLE', 'PACK')
                 AND    DIVISION_ID != '40' */
             , (SELECT DISTINCT DIVISION_ID
                              , ITEM_ID
                              , OPERATION_GROUP
                              , FLOW_ID
                              , ATTRIBUTE8
                  FROM SCP_MST_FINAL_ITEM
                 WHERE 1=1) B
             /* LEFT OUTER JOIN( --TOSITE PRIORITY CONSTRAINT
                             SELECT  SEGMENT3   AS ITEM_ID
                                     ,SEGMENT4   AS TO_SITE
                                     ,SEGMENT5   AS PRIORITY
                                     ,ATTRIBUTE1 AS FROM_DATE
                                     ,ATTRIBUTE2 AS TO_DATE
                             FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                             WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY'
                             AND     SEGMENT2    = @V_DIVISION_ID
                             AND     VALID_YN    = 'Y'
                             ) TP
             ON  A.SCM_SITE_ID = TP.TO_SITE
             AND A.ITEM_ID     = TP.ITEM_ID
             AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE */
             /* ------------------------------------------------------------------ */
             /* DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리        */
             /* 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
             /* ------------------------------------------------------------------ */
             /* SELECT  SEGMENT2   AS DIVISION_ID
                        , SEGMENT3   AS SCM_SITE_ID
                        , SEGMENT4   AS ITEM_ID
                        , SEGMENT5   AS GROUP_ID
                        , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            ELSE ATTRIBUTE2
                        END AS START_DATE  -- PLAN 제외 시작일자
                        , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                            ELSE ATTRIBUTE3
                        END AS END_DATE  -- PLAN 제외 끝일자
                FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                AND    VALID_YN    = 'Y'
                AND    SEGMENT2    = @V_DIVISION_ID
                AND    SEGMENT5    = @V_GROUP_ID */
             /* 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
             , (SELECT D.DIVISION_ID        AS DIVISION_ID
                     , D.SCM_SITE_ID        AS SCM_SITE_ID
                     , D.ITEM_ID            AS ITEM_ID
                     , PG.OPMZ_PLAN_GR_NAME AS GROUP_ID
                     , CASE WHEN D.FROM_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                            ELSE D.FROM_YYYYMMDD
                       END                  AS START_DATE
                     , CASE WHEN D.TO_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                            ELSE D.TO_YYYYMMDD
                       END                  AS END_DATE
                  FROM SCP_OPMZ_DEMAND_EXCEPTION   D
                     , SCP_OPMZ_PLAN_GR_M          PG
                     , SCP_OPT_ENG_MODEL_LIST_N_SN MDL

                 WHERE D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                   AND PG.VALID_YN(+)    = 'Y'
                   /* AND D.SCM_SITE_ID  = MDL.SCM_SITE_ID */
                   AND D.ITEM_ID         = MDL.ITEM_ID
                   AND 1=1
                   AND D.VALID_YN        = 'Y'
                   AND MDL.PLAN_ID       = V_PLAN_ID
                   AND D.DIVISION_ID     = V_DIVISION_ID
                   AND PG.OPMZ_PLAN_GR_NAME = V_PLAN_GROUP_ORG) DE

         WHERE DM.DIVISION_ID     = A.DIVISION_ID
           AND DM.VERSION_NO      = A.VERSION_NO
           AND DM.CUTOFF_YYYYMMDD = A.CUTOFF_YYYYMMDD
           AND A.DIVISION_ID      = DIV.DIVISION_ID
           AND A.DIVISION_ID      = CM.DIVISION_ID
           AND A.ITEM_ID          = CM.ITEM_ID
           /* AND A.CELL_PROD_SITE_ID = IIF(@V_DIVISION_ID = '40', CM.SCM_SITE_ID, A.CELL_PROD_SITE_ID) */
           AND A.DIVISION_ID      = B.DIVISION_ID
           AND A.ITEM_ID          = B.ITEM_ID
           AND A.SCM_SITE_ID      = DE.SCM_SITE_ID(+)
           AND A.ITEM_ID          = DE.ITEM_ID(+)
           AND 1=1
           /* AND A.CUTOFF_YYYYMMDD  =  @V_DEMAND_CUTOFF_DAY */
           /* AND A.VERSION_NO       =  @V_DM_MAX_VERSION */
           AND A.QTY              > 0
           AND A.ATTRIBUTE1      >= V_PLAN_START_YYYYMMDD
           AND A.ATTRIBUTE1       < V_PLAN_END_YYYYMMDD
           AND (DE.ITEM_ID IS NULL   /* LOOKUP 에 등록되어 있지 않은 정보 */
             OR (DE.ITEM_ID IS NOT NULL AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)));   /* LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보 */

        /* ------------------------------------------------------------------ */
        /* 6. 최종 Model List INSERT : 중복 제외를 위해 UNION 적용              */
        /* ------------------------------------------------------------------ */
        INSERT
          INTO SCP_OPT_ENG_MODEL_LIST_N_SN
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE )
        /* COATING */
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPTENG_EE_ELEC
        UNION
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPTENG_EE_BIZ
        UNION
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPTENG_EE_ELECBIZ;

        /* ------------------------------------------------------------------ */
        /* Data Insert End                                                     */
        /* ------------------------------------------------------------------ */

    /* ------------------------------------------------------------------ */
    /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ERROR LOG                                                           */
    /* ------------------------------------------------------------------ */
    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE  := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* ------------------------------------------------------------------ */
    /* 종료 LOG                                                            */
    /* ------------------------------------------------------------------ */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;

END PR_SCP_OPT_ENG_EE_INPUT_ASSIGN_MODEL_LIST;