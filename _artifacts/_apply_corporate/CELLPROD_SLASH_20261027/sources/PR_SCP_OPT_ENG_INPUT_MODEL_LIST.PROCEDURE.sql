PROCEDURE         PR_SCP_OPT_ENG_INPUT_MODEL_LIST
(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD  VARCHAR2
    ,V_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_INPUT_MODEL_LIST
 * Description  : Optimization Engine 입력용 Model List 생성
 *                (LOOKUP 등록 Model -> SUBMDLE -> CHAR -> ASY_AGING 단계 취합 후
 *                 SCP_OPT_ENG_MODEL_LIST_N_SN 에 UNION 적재)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.05    Y.S.H          Initial Release
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_PROGRAM_NAME  VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_INPUT_MODEL_LIST';
    V_PLAN_ID       VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT  VARCHAR2(1000 CHAR);
    V_DETAIL_DATE   DATE;
BEGIN

    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    BEGIN

        DELETE
          FROM GT_OPT_ENG_MDL_LIST;
        DELETE
          FROM GT_OPT_ENG_SUBMDLE;
        DELETE
          FROM GT_OPT_ENG_CHAR;
        DELETE
          FROM GT_OPT_ENG_ASYAGING;

        /* 1. LOOKUP 등록 Model */
        INSERT
          INTO GT_OPT_ENG_MDL_LIST
             ( PLAN_ID
             , DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , GROUP_ID
             , STAGE
             , ITEM_STAGE
             , PLANT_ID )
        SELECT P_PLAN_ID
             , LV.SEGMENT1
             , LV.SEGMENT2
             , LV.SEGMENT3
             , LV.SEGMENT4
             , LV.SEGMENT5
             , CASE WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'                THEN 'PACK'
                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'                THEN 'MDLE'
                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500','P9500') THEN 'SUBMDLE'
                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 =  'CP'               THEN 'CHAR'
                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP'               THEN 'ASY_AGING'
                    ELSE '-'
               END
             , NVL(S.PLANT_ID, LV.ATTRIBUTE2)
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LV

          LEFT JOIN ( SELECT DISTINCT DIVISION_ID
                                    , ITEM_ID
                                    , OPERATION_GROUP
                                    , FLOW_ID
                                    , ATTRIBUTE8
                        FROM SCP_MST_FINAL_ITEM
                       WHERE DIVISION_ID = V_DIVISION_ID
                         AND ( ( DIVISION_ID =  '40' AND OPERATION_GROUP IN ('A') )
                            OR ( DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A','P') ) ) ) B
            ON LV.SEGMENT1 = B.DIVISION_ID
           AND LV.SEGMENT3 = B.ITEM_ID
          LEFT JOIN SCM_MST_SITE S
            ON S.DIVISION_ID = LV.SEGMENT1
           AND S.SCM_SITE_ID = LV.SEGMENT2
           AND S.SITE_TYPE   = 'PLANT'
           AND S.VALID_YN    = 'Y'
           AND ( ( S.DIVISION_ID =  '40' AND S.OPERATION_GROUP IN ('A') )
              OR ( S.DIVISION_ID <> '40' AND S.OPERATION_GROUP IN ('A','P') ) )
         WHERE LV.LOOKUP_TYPE = 'SCP_OPT_ENG_MODEL_TEMP'
           AND LV.VALID_YN    = 'Y'
           AND LV.SEGMENT1    = V_DIVISION_ID
           AND LV.SEGMENT4    = V_GROUP_ID;

        /* 2-1. PACK/MDLE 하위의 SUBMDLE (대치 BOM) */
        INSERT
          INTO GT_OPT_ENG_SUBMDLE
             ( PLAN_ID
             , DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , GROUP_ID
             , STAGE
             , ITEM_STAGE
             , PLANT_ID )
        SELECT P_PLAN_ID
             , A.DIVISION_ID
             , M.SCM_SITE_ID
             , A.CHILD_ITEM_ID
             , M.GROUP_ID
             , 'SUBMDLE'
             , 'SUBMDLE'
             , A.PLANT_ID
          FROM SCM_MST_ALTER_BOM_V A
             , ( SELECT *
                   FROM GT_OPT_ENG_MDL_LIST
                  WHERE ITEM_STAGE IN ('MDLE','PACK') ) M
         WHERE A.DIVISION_ID    = M.DIVISION_ID
           AND A.PLANT_ID       = M.PLANT_ID
           AND A.PARENT_ITEM_ID = M.ITEM_ID
           AND A.SCP_PLAN_YN    = 'Y';

        /* 2-2. 대치 없는 경우(일반 BOM) — 원본 NOT EXISTS 구조 그대로 보존 */
        INSERT
          INTO GT_OPT_ENG_SUBMDLE
             ( PLAN_ID
             , DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , GROUP_ID
             , STAGE
             , ITEM_STAGE
             , PLANT_ID )
        SELECT P_PLAN_ID
             , A.DIVISION_ID
             , M.SCM_SITE_ID
             , A.CHILD_ITEM_ID
             , M.GROUP_ID
             , 'SUBMDLE'
             , 'SUBMDLE'
             , A.PLANT_ID
          FROM SCM_MST_BOM_SN_V A
             , ( SELECT *
                   FROM GT_OPT_ENG_MDL_LIST
                  WHERE ITEM_STAGE IN ('MDLE','PACK') ) M
         WHERE A.DIVISION_ID    = M.DIVISION_ID
           AND A.PLANT_ID       = M.PLANT_ID
           AND A.PARENT_ITEM_ID = M.ITEM_ID
           AND NOT EXISTS ( SELECT 1
                              FROM GT_OPT_ENG_SUBMDLE
                             WHERE A.DIVISION_ID    = M.DIVISION_ID
                               AND A.PLANT_ID       = M.PLANT_ID
                               AND A.PARENT_ITEM_ID = M.ITEM_ID
                               AND A.SCP_PLAN_YN    = 'Y' )
         GROUP BY A.DIVISION_ID
                , M.SCM_SITE_ID
                , A.CHILD_ITEM_ID
                , M.GROUP_ID
                , A.PLANT_ID;

        /* 3. PACK/MDLE 기준 CHAR Model */
        INSERT
          INTO GT_OPT_ENG_CHAR
             ( PLAN_ID
             , DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , GROUP_ID
             , STAGE
             , ITEM_STAGE
             , PLANT_ID )
        SELECT P_PLAN_ID
             , A.DIVISION_ID
             , M.SCM_SITE_ID
             , A.CHILD_ITEM_ID
             , M.GROUP_ID
             , 'CHAR'
             , 'CHAR'
             , A.PLANT_ID
          FROM SCM_MST_ALTER_BOM_V A
             , GT_OPT_ENG_SUBMDLE M
         WHERE A.DIVISION_ID    = M.DIVISION_ID
           AND A.PLANT_ID       = M.PLANT_ID
           AND A.PARENT_ITEM_ID = M.ITEM_ID
           AND A.SCP_PLAN_YN    = 'Y';

        /* 4. CHAR 하위의 ASY_AGING Model */
        INSERT
          INTO GT_OPT_ENG_ASYAGING
             ( PLAN_ID
             , DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , GROUP_ID
             , STAGE
             , ITEM_STAGE
             , PLANT_ID )
        SELECT P_PLAN_ID
             , A.DIVISION_ID
             , M.SCM_SITE_ID
             , A.ITEM_ID_ASSY
             , M.GROUP_ID
             , 'ASY_AGING'
             , 'ASY_AGING'
             , A.PLANT_ID
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
             , ( SELECT *
                   FROM GT_OPT_ENG_MDL_LIST
                  WHERE ITEM_STAGE IN ('CHAR') ) M
         WHERE A.DIVISION_ID  = M.DIVISION_ID
           AND A.PLANT_ID     = M.PLANT_ID
           AND A.ITEM_ID_PROD = M.ITEM_ID
           AND A.VALID_YN     = 'Y'
           AND A.CELL_TYPE    = 'CA1';

        /* 5. 최종 Model List INSERT (UNION = 중복 제외) */
        INSERT
          INTO SCP_OPT_ENG_MODEL_LIST_N_SN
             ( PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE )
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPT_ENG_MDL_LIST
         UNION
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPT_ENG_SUBMDLE
         UNION
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPT_ENG_CHAR
         UNION
        SELECT PLAN_ID
             , SCM_SITE_ID
             , ITEM_ID
             , STAGE
          FROM GT_OPT_ENG_ASYAGING;


        DELETE
          FROM GT_OPT_ENG_MDL_LIST;
        DELETE
          FROM GT_OPT_ENG_SUBMDLE;
        DELETE
          FROM GT_OPT_ENG_CHAR;
        DELETE
          FROM GT_OPT_ENG_ASYAGING;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE  := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;


    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;

END PR_SCP_OPT_ENG_INPUT_MODEL_LIST;