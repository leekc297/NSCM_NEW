FUNCTION FN_SCP_ITEM_PROD_PLAN_LINE_POPUP
(
    P_PARAM1                IN  VARCHAR2,    /* Division        */
    P_PARAM2                IN  VARCHAR2,    /* Operation Group */
    P_PARAM3                IN  VARCHAR2     /* Origin Division (EE 계열) */
)
RETURN T_SCP_ITEM_POPUP_TAB PIPELINED
IS
/*
 * Program ID   : FN_SCP_ITEM_PROD_PLAN_LINE_POPUP
 * Description  : AS-IS UP_FX_GetCommonDataList_SCP @Code = 'ItemProdPlanLinePopup' (콤보 ItemProdPlanLinePopup_SCP)
 *                PKG_SCP0013.P_SCP0013_GET_NEW_POPUP_INFO 의 같은 분기와 동일 SQL (임시 테이블 #TT 는 인라인 뷰로)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021.05.24   ygkim,khj79    scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경, TACT TIME 계획 종료구간 추가
 * 2026.09.17                  [MSSQL -> Oracle 전환] 콤보 본문 4,000바이트 초과로 함수 이관
 */
    V_THIS_MONTH            VARCHAR2(6 CHAR)    := TO_CHAR(SYSDATE, 'YYYYMM');
BEGIN

    IF P_PARAM1 LIKE 'EE%' THEN

        FOR R IN (SELECT A.ITEM_ID                                  AS CODE
                       , A.ITEM_ID                                  AS NAME
                       , A.PLANT_SITE_ID
                       , B.SITE_DESCRIPTION
                       , (SELECT NICK_NAME
                            FROM (SELECT SA.NICK_NAME
                                    FROM SCM_MST_ITEM_SN SA
                                   WHERE SA.ITEM_ID = A.ITEM_ID)
                           WHERE ROWNUM = 1)                        AS NICK_NAME
                       , CASE
                             WHEN B.OSP_YN = 'Y'
                             THEN (SELECT ITEM_TYPE
                                     FROM (SELECT SB.ITEM_TYPE
                                             FROM SCM_MST_ITEM_SN SB
                                            WHERE SB.ITEM_ID = A.ITEM_ID
                                              AND (   SB.ITEM_TYPE = 'P'
                                                   OR SB.ITEM_TYPE = 'H'))
                                    WHERE ROWNUM = 1)
                             ELSE (SELECT MIN(NVL(SC.ITEM_TYPE, 'Z'))
                                     FROM SCM_MST_ITEM_SN SC
                                    WHERE SC.ITEM_ID = A.ITEM_ID
                                      AND SC.SITE_ID = B.SITE_ID)
                         END                                        AS ITEM_TYPE
                       , A.OPERATION_ID
                       , A.DIVISION_ID
                       , B.OSP_YN
                    FROM (SELECT DISTINCT
                                 IB.ITEM_ID
                               , IB.PLANT_SITE_ID
                               , SUBSTR(XB.FLOW_ID, 1, 5)           AS OPERATION_ID
                               , IB.DIVISION_ID
                            FROM SCM_MST_SITE_ITEM_PRIORITY   IB
                               , SCM_MST_SITE                 SD
                               , SCP_MST_FINAL_ITEM           XB
                               , (SELECT DISTINCT    /* AS-IS 임시 테이블 #TT */
                                         XC.DIVISION_ID
                                       , XC.ITEM_ID
                                       , XC.PLANT_ID
                                    FROM SCM_MST_TACT_TIME_SN XC
                                   WHERE XC.MONTH    <= (SELECT MAX(SE.HORIZON_END_DATE)    /* 계획 종료 구간 추가 */
                                                           FROM SCM_MST_PLAN SE
                                                          WHERE SE.PLAN_ID = (SELECT MAX(SF.PLAN_ID)
                                                                                FROM SCM_MST_PLAN SF
                                                                               WHERE SF.PLAN_ID < 9999
                                                                                 AND (   P_PARAM3 IS NULL
                                                                                      OR XC.DIVISION_ID = P_PARAM3))
                                                            AND (   P_PARAM3 IS NULL
                                                                 OR SE.DIVISION_ID = P_PARAM3))
                                     AND XC.MONTH    >= V_THIS_MONTH
                                     AND XC.TACT_TIME > 0
                                     AND (   P_PARAM3 IS NULL
                                          OR XC.DIVISION_ID = P_PARAM3)) TA
                               , SCP_MST_OUTSOURCING_CAPA     PA
                           WHERE SD.SCM_SITE_ID       = IB.PLANT_SITE_ID
                             AND XB.DIVISION_ID(+)    = IB.DIVISION_ID
                             AND XB.ITEM_ID(+)        = IB.ITEM_ID
                             AND TA.DIVISION_ID(+)    = IB.DIVISION_ID
                             AND TA.ITEM_ID(+)        = IB.ITEM_ID
                             AND TA.PLANT_ID(+)       = SD.PLANT_ID
                             AND PA.DIVISION_ID(+)    = IB.DIVISION_ID
                             AND PA.PLANT_SITE_ID(+)  = IB.PLANT_SITE_ID
                             AND PA.ITEM_ID(+)        = IB.ITEM_ID
                             AND IB.VALID_YN          = 'Y'
                             AND (   SD.OSP_YN = 'N'    /* 테이블 변경 */
                                  OR SD.OSP_YN = 'Y')
                             AND (   (    SD.OSP_YN = 'N'
                                      AND TA.DIVISION_ID IS NOT NULL)    /* 테이블 변경 */
                                  OR (    SD.OSP_YN = 'Y'
                                      AND PA.DAILY_CAPA_QTY IS NOT NULL))
                             AND (   P_PARAM2 IS NULL
                                  OR XB.OPERATION_GROUP = P_PARAM2)
                             AND (   P_PARAM3 IS NULL
                                  OR IB.DIVISION_ID = P_PARAM3)) A
                       , SCM_MST_SITE B
                   WHERE B.SCM_SITE_ID(+) = A.PLANT_SITE_ID
                     AND A.DIVISION_ID IN (SELECT SG.DIVISION_ID
                                             FROM SCM_MST_DIVISION SG
                                            WHERE SG.ATTRIBUTE4 IN (SELECT SH.ATTRIBUTE4
                                                                      FROM SCM_MST_DIVISION SH
                                                                     WHERE SH.DIVISION_ID = P_PARAM1))
                     AND B.VALID_YN(+)    = 'Y'
                   ORDER BY A.ITEM_ID)
        LOOP
            PIPE ROW (T_SCP_ITEM_POPUP_ROW(R.CODE, R.NAME, R.PLANT_SITE_ID, R.SITE_DESCRIPTION, R.NICK_NAME
                                         , R.ITEM_TYPE, R.OPERATION_ID, R.DIVISION_ID, R.OSP_YN));
        END LOOP;

    ELSE

        FOR R IN (SELECT A.ITEM_ID                                  AS CODE
                       , A.ITEM_ID                                  AS NAME
                       , A.PLANT_SITE_ID
                       , B.SITE_DESCRIPTION
                       , (SELECT NICK_NAME
                            FROM (SELECT SA.NICK_NAME
                                    FROM SCM_MST_ITEM_SN SA
                                   WHERE SA.ITEM_ID = A.ITEM_ID)
                           WHERE ROWNUM = 1)                        AS NICK_NAME
                       , CASE
                             WHEN B.OSP_YN = 'Y'
                             THEN (SELECT ITEM_TYPE
                                     FROM (SELECT SB.ITEM_TYPE
                                             FROM SCM_MST_ITEM_SN SB
                                            WHERE SB.ITEM_ID = A.ITEM_ID
                                              AND (   SB.ITEM_TYPE = 'P'
                                                   OR SB.ITEM_TYPE = 'H'))
                                    WHERE ROWNUM = 1)
                             ELSE (SELECT MIN(NVL(SC.ITEM_TYPE, 'Z'))
                                     FROM SCM_MST_ITEM_SN SC
                                    WHERE SC.ITEM_ID = A.ITEM_ID
                                      AND SC.SITE_ID = B.SITE_ID)
                         END                                        AS ITEM_TYPE
                       , A.OPERATION_ID
                       , A.DIVISION_ID
                       , B.OSP_YN
                    FROM (SELECT DISTINCT
                                 IB.ITEM_ID
                               , IB.PLANT_SITE_ID
                               , SUBSTR(XB.FLOW_ID, 1, 5)           AS OPERATION_ID
                               , IB.DIVISION_ID
                            FROM SCM_MST_SITE_ITEM_PRIORITY   IB
                               , SCP_MST_FINAL_ITEM           XB
                               , SCM_MST_SITE                 SD
                               , (SELECT DISTINCT
                                         XC.DIVISION_ID
                                       , XC.ITEM_ID
                                       , XC.PLANT_ID
                                    FROM SCM_MST_TACT_TIME_SN XC
                                   WHERE XC.MONTH      <= (SELECT SE.HORIZON_END_DATE    /* 계획 종료 구간 추가 */
                                                             FROM SCM_MST_PLAN SE
                                                            WHERE SE.PLAN_ID = (SELECT MAX(SF.PLAN_ID)
                                                                                  FROM SCM_MST_PLAN SF
                                                                                 WHERE SF.PLAN_ID < 9999
                                                                                   AND (   P_PARAM1 IS NULL
                                                                                        OR XC.DIVISION_ID = P_PARAM1))
                                                              AND (   P_PARAM1 IS NULL
                                                                   OR SE.DIVISION_ID = P_PARAM1))
                                     AND XC.MONTH      >= V_THIS_MONTH
                                     AND XC.TACT_TIME   > 0
                                     AND XC.DIVISION_ID = P_PARAM1) TA
                               , SCP_MST_OUTSOURCING_CAPA     PA
                           WHERE XB.DIVISION_ID(+)    = IB.DIVISION_ID
                             AND XB.ITEM_ID(+)        = IB.ITEM_ID
                             AND SD.SCM_SITE_ID       = IB.PLANT_SITE_ID
                             AND TA.DIVISION_ID(+)    = IB.DIVISION_ID
                             AND TA.ITEM_ID(+)        = IB.ITEM_ID
                             AND TA.PLANT_ID(+)       = SD.PLANT_ID
                             AND PA.DIVISION_ID(+)    = IB.DIVISION_ID
                             AND PA.PLANT_SITE_ID(+)  = IB.PLANT_SITE_ID
                             AND PA.ITEM_ID(+)        = IB.ITEM_ID
                             AND IB.VALID_YN          = 'Y'
                             AND (   SD.OSP_YN = 'N'    /* 테이블 변경 */
                                       /* ESS 외주 Pakcer Line 생산 Target 적용 */
                                  OR (    SD.OSP_YN = 'Y'
                                      AND NVL(SD.ATTRIBUTE1, 'N') = 'N'))
                             AND (   (    SD.OSP_YN = 'N'
                                      AND TA.DIVISION_ID IS NOT NULL)    /* 테이블 변경 */
                                       /* ESS 외주 Pakcer Line 생산 Target 적용 */
                                  OR (    SD.OSP_YN = 'Y'
                                      AND PA.DAILY_CAPA_QTY IS NOT NULL
                                      AND NVL(SD.ATTRIBUTE1, 'N') = 'N'))
                             AND IB.DIVISION_ID       = P_PARAM1
                             AND (   P_PARAM2 IS NULL
                                  OR XB.OPERATION_GROUP = P_PARAM2)
                           UNION ALL
                          /* ESS 외주 Pakcer Line 생산 Target 적용 */
                          SELECT DISTINCT
                                 IC.ITEM_ID
                               , IC.PLANT_SITE_ID
                               , SUBSTR(XD.FLOW_ID, 1, 5)           AS OPERATION_ID
                               , IC.DIVISION_ID
                            FROM SCM_MST_SITE_ITEM_PRIORITY   IC
                               , SCP_MST_TACT_TIME_OSP        TB
                               , SCP_MST_FINAL_ITEM           XD
                               , SCM_MST_SITE                 SI
                           WHERE TB.DIVISION_ID       = IC.DIVISION_ID
                             AND TB.ITEM_ID           = IC.ITEM_ID
                             AND TB.PLANT_SITE_ID     = IC.PLANT_SITE_ID
                             AND XD.DIVISION_ID(+)    = IC.DIVISION_ID
                             AND XD.ITEM_ID(+)        = IC.ITEM_ID
                             AND SI.SCM_SITE_ID       = IC.PLANT_SITE_ID
                             AND TB.VALID_YN          = 'Y'
                             AND SI.OSP_YN            = 'Y'
                             AND NVL(SI.ATTRIBUTE1, 'N') = 'Y'
                             AND IC.VALID_YN          = 'Y'
                             AND IC.DIVISION_ID       = P_PARAM1
                             AND (   P_PARAM2 IS NULL
                                  OR XD.OPERATION_GROUP = P_PARAM2)) A
                       , SCM_MST_SITE B
                   WHERE B.SCM_SITE_ID(+) = A.PLANT_SITE_ID
                     AND B.VALID_YN(+)    = 'Y'
                   ORDER BY A.ITEM_ID)
        LOOP
            PIPE ROW (T_SCP_ITEM_POPUP_ROW(R.CODE, R.NAME, R.PLANT_SITE_ID, R.SITE_DESCRIPTION, R.NICK_NAME
                                         , R.ITEM_TYPE, R.OPERATION_ID, R.DIVISION_ID, R.OSP_YN));
        END LOOP;

    END IF;

    RETURN;

END FN_SCP_ITEM_PROD_PLAN_LINE_POPUP;