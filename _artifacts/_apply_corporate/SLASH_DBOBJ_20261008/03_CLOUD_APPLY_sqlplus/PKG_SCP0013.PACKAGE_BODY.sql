-- [E20261008-SLASHOBJ]+[E20261009-GRPBYFIX] PACKAGE BODY PKG_SCP0013 — 사내 현재 원문(핫픽스 적용본, 사내 LAST_DDL 2026-10-09 14:43:05)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0013
IS

    /* ========================================================================================
       공통 : 이력 저장 - PR_SCP_ANL_PRODUCTION_PLAN_HIST
       ======================================================================================== */
    PROCEDURE P_SCP_PROD_PLAN_HIST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_CREATED_BY            IN  VARCHAR2,
        P_CREATION_DATE         IN  DATE,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2
    )
    IS
    /*
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_HIST
     * Description  : Production Plan History
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018.03.12   byunghunjung    Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018.07.18	YHW				전극용 데이터 저장 추가
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
             (
               HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,HISTORY_CREATION_DATE
             )
        VALUES
             (
               SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
              ,P_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,P_PLAN_TYPE
              ,P_SEQ
              ,P_OPERATION_GROUP
              ,P_SCM_SITE_ID
              ,P_ITEM_ID
              ,P_LINE_ID
              ,P_OPERATION_ID
              ,P_MEASURE
              ,P_YYYYMMDD
              ,P_QTY
              ,P_ORIGIN_DIVISION_ID
              ,P_ELECTRODE_TYPE
              ,P_CREATED_BY
              ,P_CREATION_DATE
              ,P_LAST_UPDATED_BY
              ,SYSDATE
              ,SYSDATE
             );

    END P_SCP_PROD_PLAN_HIST;


    /* ========================================================================================
       공통 : FIX 이력 저장 - PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST
       ======================================================================================== */
    PROCEDURE P_SCP_PROD_PLAN_FIX_HIST
    (
        P_FIX_ID                IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_FIX_REASON            IN  VARCHAR2,
        P_CREATED_BY            IN  VARCHAR2,
        P_CREATION_DATE         IN  DATE,
        P_LAST_UPDATED_BY       IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT ''
    )
    IS
    /*
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST
     * Description  : Production Plan Fix History
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/05/17   PJS             Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/18	YHW				전극용 데이터 저장 추가
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
             (
               HISTORY_SEQ
              ,FIX_ID
              ,DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,QTY
              ,FIX_REASON
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,HISTORY_CREATION_DATE
             )
        VALUES
             (
               SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
              ,P_FIX_ID
              ,P_DIVISION_ID
              ,P_OPERATION_GROUP
              ,P_SCM_SITE_ID
              ,P_ITEM_ID
              ,P_LINE_ID
              ,P_OPERATION_ID
              ,P_YYYYMMDD
              ,P_QTY
              ,P_FIX_REASON
              ,P_ORIGIN_DIVISION_ID
              ,P_ELECTRODE_TYPE
              ,P_CREATED_BY
              ,P_CREATION_DATE
              ,P_LAST_UPDATED_BY
              ,SYSDATE
              ,SYSDATE
             );

    END P_SCP_PROD_PLAN_FIX_HIST;


    /* ========================================================================================
       공통 : 이력 일괄 저장 - PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET
              AS-IS 는 TVP 를 인자로 받는다. TO-BE 는 직전 단계에서 GT_0013_DYN 에 적재된
              같은 행 집합을 그대로 읽는다(인자 전달 왕복 제거, 대상 집합 동일).
       ======================================================================================== */
    PROCEDURE P_SCP_PROD_PLAN_HIST_DS
    IS
    /*
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_HIST_DATASET
     * Description  : Production Plan History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019.01.22   HWYOON			[CSR ID:3913598] GSCM 시스템 속도 향상 요청 건 (production plan line 수정 / 저장 속도)
     * 2019.06.07	HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
             (
               HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , P_OPERATION_GROUP
             , P_SCM_SITE_ID
             , P_ITEM_ID
             , P_LINE_ID
             , P_OPERATION_ID
             , P_MEASURE
             , P_YYYYMMDD
             , P_QTY
             , P_ORIGIN_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_USER_ID
             , SYSDATE
             , P_USER_ID
             , SYSDATE
             , SYSDATE
          FROM GT_0013_DYN;

    END P_SCP_PROD_PLAN_HIST_DS;


    /* ========================================================================================
       공통 : FIX 이력 일괄 저장 - PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET
       ======================================================================================== */
    PROCEDURE P_SCP_PROD_PLAN_FIX_HIST_DS
    IS
    /*
     * Program ID   : PR_SCP_ANL_PRODUCTION_PLAN_FIX_HIST_DATASET
     * Description  : Production Plan History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019.02.21   HWYOON			[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
     * 2019.06.07	HWYOON			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_FIX_H
             (
               HISTORY_SEQ
              ,FIX_ID
              ,DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,QTY
              ,FIX_REASON
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,HISTORY_CREATION_DATE
              ,ATTRIBUTE1
             )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
             , A.FIX_ID
             , B.P_DIVISION_ID
             , B.P_OPERATION_GROUP
             , B.P_SCM_SITE_ID
             , B.P_ITEM_ID
             , B.P_LINE_ID
             , B.P_OPERATION_ID
             , B.P_YYYYMMDD
             , B.P_QTY
             , A.FIX_REASON
             , B.P_ORIGIN_DIVISION_ID
             , B.P_ELECTRODE_TYPE
             , B.P_USER_ID
             , SYSDATE
             , B.P_USER_ID
             , SYSDATE
             , SYSDATE
             , B.P_ACTIVE_FLAG    /* AS-IS ISNULL(p_active_flag,'') - Oracle 은 빈 문자열이 NULL 이라 값 그대로 */
          FROM SCP_ANL_PRODUCTION_PLAN_FIX  A
             , GT_0013_DYN                  B
         WHERE 1 = 1
           AND A.DIVISION_ID     = B.P_DIVISION_ID
           AND A.OPERATION_GROUP = B.P_OPERATION_GROUP
           AND A.SCM_SITE_ID     = B.P_SCM_SITE_ID
           AND A.ITEM_ID         = B.P_ITEM_ID
           AND A.LINE_ID         = B.P_LINE_ID
           AND A.OPERATION_ID    = B.P_OPERATION_ID
           AND A.YYYYMMDD        = B.P_YYYYMMDD
           AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-');

    END P_SCP_PROD_PLAN_FIX_HIST_DS;

    /* ========================================================================================
       1. SCP0013_GET_LINE_LIST
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_LINE_LIST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_PLANT_SITE            IN  VARCHAR2,
        P_CELL_TYPE_GR          IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_LINE_LIST
     * Description  : Combo) Line List
     * Program History
     *===========================================================================================================================
     *   Date       In Charge		Description
     *===========================================================================================================================
     * 2023/12/07   vadabi3			Initial Release		Cell Type 선택 시 Line 필터 적용
     *                                                  UP_FX_GetCommonDataList_SCP) LineProdPlanLine, LineByOperationAddOSP 참조
     * 2026.09.11   [MSSQL -> Oracle 전환]
     ----------------------------------------------------------------------------------------------------------------------------
       EXEC SCP0013_GET_LINE_LIST '40', 'A', 'A010-A,CN003256_40-A,F030-A,G182-A,KR004004_40-A', 'C', '20231218'
     */
    BEGIN

        DELETE GT_0013_TMP_LINE;

        INSERT INTO GT_0013_TMP_LINE
             (
               LINE_ID
             )
        SELECT A.LINE_ID
          FROM SCP_ANL_PRODUCTION_PLAN  A
             , SCP_MST_FINAL_ITEM       B
         WHERE 1 = 1
           AND A.DIVISION_ID     = B.DIVISION_ID
           AND A.ITEM_ID         = B.ITEM_ID
           AND A.OPERATION_GROUP = B.OPERATION_GROUP
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                /* 파티션 프루닝 - 파티션 키는 PLAN_START_YYYYMMDD 와 같은 값이다 */
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
           AND A.SCM_SITE_ID    IN (SELECT COLUMN_VALUE
                                      FROM TABLE(STRING_SPLIT(P_PLANT_SITE, ',')))
           AND B.CELL_TYPE_GROUP_CODE IN (SELECT COLUMN_VALUE
                                            FROM TABLE(STRING_SPLIT(P_CELL_TYPE_GR, ',')))
           AND A.LINE_ID        != '*'
           AND A.LINE_ID        != '-'
         GROUP BY A.LINE_ID;

        OPEN O_RC1 FOR
        SELECT '-'                                                  AS CODE
             , '-'                                                  AS NAME
          FROM DUAL
         UNION
        SELECT A.LINE_ID                                            AS CODE
             , CASE
                   WHEN B.LINE_NAME IS NULL
                   THEN NULL                     /* MSSQL '+' 결합은 한쪽이 NULL 이면 결과가 NULL */
                   ELSE A.LINE_ID||'   '||B.LINE_NAME
               END                                                  AS NAME
          FROM GT_0013_TMP_LINE     A
             , SCM_MST_LINE_SN      B
         WHERE 1 = 1
           AND A.LINE_ID        = B.SCP_LINE_ID(+)
           AND B.DIVISION_ID(+) = P_DIVISION_ID
         ORDER BY CODE;

    END P_SCP0013_GET_LINE_LIST;


    /* ========================================================================================
       2. SCP0013_GET_NEW_POPUP_INFO
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_NEW_POPUP_INFO
    (
        P_CODE                  IN  VARCHAR2,
        P_PARAM1                IN  VARCHAR2,
        P_PARAM2                IN  VARCHAR2,
        P_PARAM3                IN  VARCHAR2,
        P_PARAM4                IN  VARCHAR2,
        P_PARAM5                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_NEW_POPUP_INFO
     * Description  : new - popup 용도 : UP_FX_GetCommonDataList_SCP -> SCP0013_GET_NEW_POPUP_INFO
     * Program History
     *  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = Plan Date, @PARAM4 = Plan Type, @PARAM5 = Seq
    ================================================================================
       Date       In Charge      Description
    ================================================================================
     2022/11/03   lwy           PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Initial Release
                                - 개체참조 오류 지속 발생으로 sp 생성
     2026.09.11   [MSSQL -> Oracle 전환]
    */
    BEGIN

        /*===============================================
        용		 도:  Item List 조회
        사 용 화 면:  Production Plan Line Insert Popup - 조회조건
        변       수:  @PARAM1 = DIVISION, @PARAM2 = OPERATION_GROUP, @PARAM3 = Plan Date, @PARAM4 = Plan Type, @PARAM5 = Seq
        최 초 작 성:
        개  발  자 :
        최 종 작 성:  2021. 05. 24
        수  정  자 :  ygkim,khj79
        수 정 사 항:  scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , TACT TIME 계획 종료구간 추가
        ===============================================*/
        IF P_CODE = 'ItemProdPlanLinePopup' THEN

            IF P_PARAM1 LIKE 'EE%' THEN

                DELETE GT_0013_TT;

                INSERT INTO GT_0013_TT
                     (
                       DIVISION_ID
                      ,ITEM_ID
                      ,PLANT_ID
                     )
                SELECT DISTINCT
                       X.DIVISION_ID
                     , X.ITEM_ID
                     , X.PLANT_ID
                  FROM SCM_MST_TACT_TIME_SN X
                 WHERE 1 = 1
                   AND (   P_PARAM3 IS NULL
                        OR X.DIVISION_ID = P_PARAM3)
                   AND X.MONTH    >= TO_CHAR(SYSDATE, 'YYYYMM')
                   AND X.TACT_TIME > 0
                        /* 계획 종료 구간 추가 */
                   AND X.MONTH    <= (SELECT MAX(P.HORIZON_END_DATE)
                                        FROM SCM_MST_PLAN P
                                       WHERE 1 = 1
                                         AND (   P_PARAM3 IS NULL
                                              OR P.DIVISION_ID = P_PARAM3)
                                         AND P.PLAN_ID = (SELECT MAX(SA.PLAN_ID)
                                                            FROM SCM_MST_PLAN SA
                                                           WHERE 1 = 1
                                                             AND (   P_PARAM3 IS NULL
                                                                  OR X.DIVISION_ID = P_PARAM3)
                                                             AND SA.PLAN_ID < 9999));

                OPEN O_RC1 FOR
                SELECT A.ITEM_ID                                    AS CODE
                     , A.ITEM_ID                                    AS NAME
                     , A.PLANT_SITE_ID
                     , B.SITE_DESCRIPTION
                     , (SELECT NICK_NAME
                          FROM (SELECT SA.NICK_NAME
                                  FROM SCM_MST_ITEM_SN SA
                                 WHERE SA.ITEM_ID = A.ITEM_ID)
                         WHERE ROWNUM = 1)                          AS NICK_NAME
                     , CASE
                           WHEN B.OSP_YN = 'Y'
                           THEN (SELECT ITEM_TYPE
                                   FROM (SELECT SA.ITEM_TYPE
                                           FROM SCM_MST_ITEM_SN SA
                                          WHERE SA.ITEM_ID = A.ITEM_ID
                                            AND (   SA.ITEM_TYPE = 'P'
                                                 OR SA.ITEM_TYPE = 'H'))
                                  WHERE ROWNUM = 1)
                           ELSE (SELECT MIN(NVL(SA.ITEM_TYPE, 'Z'))
                                   FROM SCM_MST_ITEM_SN SA
                                  WHERE SA.ITEM_ID = A.ITEM_ID
                                    AND SA.SITE_ID = B.SITE_ID)
                       END                                          AS ITEM_TYPE
                     , A.OPERATION_ID
                     , A.DIVISION_ID
                     , B.OSP_YN
                  FROM (SELECT DISTINCT
                               IA.ITEM_ID
                             , IA.PLANT_SITE_ID
                             , SUBSTR(XA.FLOW_ID, 1, 5)             AS OPERATION_ID
                             , IA.DIVISION_ID
                          FROM SCM_MST_SITE_ITEM_PRIORITY   IA
                             , SCM_MST_SITE                 SA
                             , SCP_MST_FINAL_ITEM           XA
                             , GT_0013_TT                   TA
                             , SCP_MST_OUTSOURCING_CAPA     PA
                         WHERE 1 = 1
                           AND SA.SCM_SITE_ID       = IA.PLANT_SITE_ID
                           AND XA.DIVISION_ID(+)    = IA.DIVISION_ID
                           AND XA.ITEM_ID(+)        = IA.ITEM_ID
                           AND TA.DIVISION_ID(+)    = IA.DIVISION_ID
                           AND TA.ITEM_ID(+)        = IA.ITEM_ID
                           AND TA.PLANT_ID(+)       = SA.PLANT_ID
                           AND PA.DIVISION_ID(+)    = IA.DIVISION_ID
                           AND PA.PLANT_SITE_ID(+)  = IA.PLANT_SITE_ID
                           AND PA.ITEM_ID(+)        = IA.ITEM_ID
                           AND IA.VALID_YN          = 'Y'
                           AND (   SA.OSP_YN = 'N'    /* 테이블 변경 */
                                OR SA.OSP_YN = 'Y')
                           AND (   P_PARAM2 IS NULL
                                OR XA.OPERATION_GROUP = P_PARAM2)
                           AND (   (    SA.OSP_YN = 'N'
                                    AND TA.DIVISION_ID IS NOT NULL)     /* 테이블 변경 */
                                OR (    SA.OSP_YN = 'Y'
                                    AND PA.DAILY_CAPA_QTY IS NOT NULL))
                           AND (   P_PARAM3 IS NULL
                                OR IA.DIVISION_ID = P_PARAM3)) A
                     , SCM_MST_SITE B
                 WHERE 1 = 1
                   AND A.PLANT_SITE_ID = B.SCM_SITE_ID(+)
                   AND B.VALID_YN(+)   = 'Y'
                   AND A.DIVISION_ID  IN (SELECT DIVISION_ID
                                            FROM SCM_MST_DIVISION
                                           WHERE ATTRIBUTE4 IN (SELECT ATTRIBUTE4
                                                                  FROM SCM_MST_DIVISION
                                                                 WHERE DIVISION_ID = P_PARAM1))
                 ORDER BY A.ITEM_ID;

            ELSE

                OPEN O_RC1 FOR
                SELECT A.ITEM_ID                                    AS CODE
                     , A.ITEM_ID                                    AS NAME
                     , A.PLANT_SITE_ID
                     , B.SITE_DESCRIPTION
                     , (SELECT NICK_NAME
                          FROM (SELECT SA.NICK_NAME
                                  FROM SCM_MST_ITEM_SN SA
                                 WHERE SA.ITEM_ID = A.ITEM_ID)
                         WHERE ROWNUM = 1)                          AS NICK_NAME
                     , CASE
                           WHEN B.OSP_YN = 'Y'
                           THEN (SELECT ITEM_TYPE
                                   FROM (SELECT SA.ITEM_TYPE
                                           FROM SCM_MST_ITEM_SN SA
                                          WHERE SA.ITEM_ID = A.ITEM_ID
                                            AND (   SA.ITEM_TYPE = 'P'
                                                 OR SA.ITEM_TYPE = 'H'))
                                  WHERE ROWNUM = 1)
                           ELSE (SELECT MIN(NVL(SA.ITEM_TYPE, 'Z'))
                                   FROM SCM_MST_ITEM_SN SA
                                  WHERE SA.ITEM_ID = A.ITEM_ID
                                    AND SA.SITE_ID = B.SITE_ID)
                       END                                          AS ITEM_TYPE
                     , A.OPERATION_ID
                     , A.DIVISION_ID
                     , B.OSP_YN
                  FROM (SELECT DISTINCT
                               IA.ITEM_ID
                             , IA.PLANT_SITE_ID
                             , SUBSTR(XA.FLOW_ID, 1, 5)             AS OPERATION_ID
                             , IA.DIVISION_ID
                          FROM SCM_MST_SITE_ITEM_PRIORITY   IA
                             , SCP_MST_FINAL_ITEM           XA
                             , SCM_MST_SITE                 SA
                             , (SELECT DISTINCT
                                       XB.DIVISION_ID
                                     , XB.ITEM_ID
                                     , XB.PLANT_ID
                                  FROM SCM_MST_TACT_TIME_SN XB
                                 WHERE 1 = 1
                                   AND XB.DIVISION_ID = P_PARAM1
                                   AND XB.MONTH      >= TO_CHAR(SYSDATE, 'YYYYMM')
                                   AND XB.TACT_TIME   > 0
                                        /* 계획 종료 구간 추가 */
                                   AND XB.MONTH      <= (SELECT P.HORIZON_END_DATE
                                                           FROM SCM_MST_PLAN P
                                                          WHERE 1 = 1
                                                            AND (   P_PARAM1 IS NULL
                                                                 OR P.DIVISION_ID = P_PARAM1)
                                                            AND P.PLAN_ID = (SELECT MAX(SB.PLAN_ID)
                                                                               FROM SCM_MST_PLAN SB
                                                                              WHERE 1 = 1
                                                                                AND (   P_PARAM1 IS NULL
                                                                                     OR XB.DIVISION_ID = P_PARAM1)
                                                                                AND SB.PLAN_ID < 9999))) TA
                             , SCP_MST_OUTSOURCING_CAPA     PA
                         WHERE 1 = 1
                           AND XA.DIVISION_ID(+)    = IA.DIVISION_ID
                           AND XA.ITEM_ID(+)        = IA.ITEM_ID
                           AND SA.SCM_SITE_ID       = IA.PLANT_SITE_ID
                           AND TA.DIVISION_ID(+)    = IA.DIVISION_ID
                           AND TA.ITEM_ID(+)        = IA.ITEM_ID
                           AND TA.PLANT_ID(+)       = SA.PLANT_ID
                           AND PA.DIVISION_ID(+)    = IA.DIVISION_ID
                           AND PA.PLANT_SITE_ID(+)  = IA.PLANT_SITE_ID
                           AND PA.ITEM_ID(+)        = IA.ITEM_ID
                           AND IA.VALID_YN          = 'Y'
                           AND (   SA.OSP_YN = 'N'    /* 테이블 변경 */
                                     /* ESS 외주 Pakcer Line 생산 Target 적용 */
                                OR (    SA.OSP_YN = 'Y'
                                    AND NVL(SA.ATTRIBUTE1, 'N') = 'N'))
                           AND IA.DIVISION_ID       = P_PARAM1
                           AND (   P_PARAM2 IS NULL
                                OR XA.OPERATION_GROUP = P_PARAM2)
                           AND (   (    SA.OSP_YN = 'N'
                                    AND TA.DIVISION_ID IS NOT NULL)     /* 테이블 변경 */
                                     /* ESS 외주 Pakcer Line 생산 Target 적용 */
                                OR (    SA.OSP_YN = 'Y'
                                    AND PA.DAILY_CAPA_QTY IS NOT NULL
                                    AND NVL(SA.ATTRIBUTE1, 'N') = 'N'))
                         UNION ALL
                            /* ESS 외주 Pakcer Line 생산 Target 적용 */
                        SELECT DISTINCT
                               IB.ITEM_ID
                             , IB.PLANT_SITE_ID
                             , SUBSTR(XC.FLOW_ID, 1, 5)             AS OPERATION_ID
                             , IB.DIVISION_ID
                          FROM SCM_MST_SITE_ITEM_PRIORITY   IB
                             , SCP_MST_TACT_TIME_OSP        TB
                             , SCP_MST_FINAL_ITEM           XC
                             , SCM_MST_SITE                 SC
                         WHERE 1 = 1
                           AND TB.DIVISION_ID       = IB.DIVISION_ID
                           AND TB.ITEM_ID           = IB.ITEM_ID
                           AND TB.PLANT_SITE_ID     = IB.PLANT_SITE_ID
                           AND TB.VALID_YN          = 'Y'
                           AND XC.DIVISION_ID(+)    = IB.DIVISION_ID
                           AND XC.ITEM_ID(+)        = IB.ITEM_ID
                           AND SC.SCM_SITE_ID       = IB.PLANT_SITE_ID
                           AND SC.OSP_YN            = 'Y'
                           AND NVL(SC.ATTRIBUTE1, 'N') = 'Y'
                           AND IB.VALID_YN          = 'Y'
                           AND IB.DIVISION_ID       = P_PARAM1
                           AND (   P_PARAM2 IS NULL
                                OR XC.OPERATION_GROUP = P_PARAM2)) A
                     , SCM_MST_SITE B
                 WHERE 1 = 1
                   AND A.PLANT_SITE_ID = B.SCM_SITE_ID(+)
                   AND B.VALID_YN(+)   = 'Y'
                 ORDER BY A.ITEM_ID;

            END IF;

        /*===============================================
        	용		 도:  LineProdPlanLinePopupAll
        	사 용 화 면:  Production Plan Line New 입력 팝업에서 사용
        	변       수:  @PARAM1=OPERATION_GROUP
        	최 초 작 성:  2019. 03. 22
        	개  발  자 :  YWHOON
        	최 종 작 성:  2019. 03. 22
        	수  정  자 :
        	수 정 사 항:  [CSR ID:3962713]  Production Plan Line 신규 다건입력 로직 개선의 건
        	2020.02.27		ESS 외주 Pakcer Line 생산 Target 적용
        	2021.05.24		scp_mst_tact_time => SCM_MST_TACT_TIME_SN 변경 , khj79
        	2022.07.22        ISUZU 관련 수정 , lwy
        ===============================================*/
        ELSIF P_CODE = 'LineProdPlanLinePopupAll' THEN

            OPEN O_RC1 FOR
            SELECT DISTINCT
                   A.LINE_ID                                        AS CODE
                 , CASE
                       WHEN A.LINE_NAME IS NULL
                       THEN NULL
                       ELSE A.LINE_ID||'   '||A.LINE_NAME
                   END                                              AS NAME
                 , B.SCM_SITE_ID                                    AS PLANT_SITE_ID
                 , C.ITEM_ID
                 , C.OPERATION_ID
                 , A.DIVISION_ID
              FROM SCM_MST_LINE_SN  A
                 , SCM_MST_SITE     B
                 , (SELECT DISTINCT
                           IA.SEGMENT4
                         , IA.SEGMENT1
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL IA
                     WHERE 1 = 1
                       AND IA.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                       AND IA.VALID_YN    = 'Y'
                       AND IA.SEGMENT3    = 'Y'  /* Capa 세부 공정 여부 */) F
                 , (SELECT DISTINCT
                           XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.PLANT_ID
                         , XA.LINE_ID
                         , XA.OPERATION_ID
                      FROM SCM_MST_TACT_TIME_SN XA
                     WHERE 1 = 1
                       AND XA.MONTH    >= TO_CHAR(SYSDATE, 'YYYYMM')
                       AND XA.TACT_TIME > 0) C
             WHERE 1 = 1
               AND A.COMPANY_ID   = B.COMPANY_ID
               AND A.SITE_ID      = B.SITE_ID
               AND A.PLANT_ID     = B.PLANT_ID
               AND A.DIVISION_ID  = B.DIVISION_ID
               AND A.OPERATION_ID = F.SEGMENT4
               AND C.DIVISION_ID  = A.DIVISION_ID
               AND C.PLANT_ID     = B.PLANT_ID
               AND C.OPERATION_ID = A.OPERATION_ID
               AND C.LINE_ID      = A.LINE_ID
               AND A.ACTIVE_FLAG  = 'Y'
               AND (   P_PARAM1 IS NULL
                    OR B.OPERATION_GROUP = P_PARAM1)
             UNION
            SELECT DISTINCT
                   A.LINE_ID                                        AS CODE
                 , CASE
                       WHEN A.LINE_NAME IS NULL
                       THEN NULL
                       ELSE A.LINE_ID||'   '||A.LINE_NAME
                   END                                              AS NAME
                 , B.PLANT_SITE_ID
                 , B.ITEM_ID
                 , B.OPERATION_ID
                 , A.DIVISION_ID
              FROM SCM_MST_LINE_OSP         A
                 , SCM_MST_SITE             S
                 , SCP_MST_TACT_TIME_OSP    B
             WHERE 1 = 1
               AND S.DIVISION_ID    = A.DIVISION_ID
               AND S.SCM_SITE_ID    = A.SCM_SITE_ID
               AND S.OSP_YN         = 'Y'
               AND NVL(S.ATTRIBUTE1, 'N') = 'Y'
               AND B.DIVISION_ID    = A.DIVISION_ID
               AND B.PLANT_SITE_ID  = A.SCM_SITE_ID
               AND B.VALID_YN       = 'Y'
               AND B.LINE_ID        = A.LINE_ID
               AND A.VALID_YN       = 'Y'
               AND (   P_PARAM1 IS NULL
                    OR S.OPERATION_GROUP = P_PARAM1)
                 /* 2022.07.22 Begin */
             UNION
            SELECT DISTINCT
                   A.LINE_ID                                        AS CODE
                 , CASE
                       WHEN A.LINE_NAME IS NULL
                       THEN NULL
                       ELSE A.LINE_ID||'   '||A.LINE_NAME
                   END                                              AS NAME
                 , B.SCM_SITE_ID                                    AS PLANT_SITE_ID
                 , C.ITEM_ID
                 , C.OPERATION_ID
                 , A.DIVISION_ID
              FROM SCM_MST_LINE_SN  A
                 , SCM_MST_SITE     B
                 , (SELECT DISTINCT
                           XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.PLANT_ID
                         , XA.LINE_ID
                         , XA.OPERATION_ID
                      FROM SCM_MST_TACT_TIME_SN XA
                         , SCM_MST_FINAL_ITEM_V IA
                     WHERE 1 = 1
                       AND XA.ITEM_ID     = IA.ITEM_ID
                       AND XA.DIVISION_ID = IA.DIVISION_ID
                       AND XA.MONTH      >= TO_CHAR(SYSDATE, 'YYYYMM')
                       AND XA.TACT_TIME   > 0) C
             WHERE 1 = 1
               AND A.COMPANY_ID   = B.COMPANY_ID
               AND A.SITE_ID      = B.SITE_ID
               AND A.PLANT_ID     = B.PLANT_ID
               AND A.DIVISION_ID  = B.DIVISION_ID
               AND C.DIVISION_ID  = A.DIVISION_ID
               AND C.PLANT_ID     = B.PLANT_ID
               AND C.OPERATION_ID = A.OPERATION_ID
               AND C.LINE_ID      = A.LINE_ID
               AND A.ACTIVE_FLAG  = 'Y'
               AND (   P_PARAM1 IS NULL
                    OR B.OPERATION_GROUP = P_PARAM1);
                 /* 2022.07.22 End */

        END IF;

    END P_SCP0013_GET_NEW_POPUP_INFO;


    /* ========================================================================================
       3. SCP0013_GET_PLAN_EDIT_INFO
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_PLAN_EDIT_INFO
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_PLAN_EDIT_INFO
     * Description  : PLAN 별 편집가능 여부 정보 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/05/14   PJS    			Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/21   PJS             PR 수정모드 조건 변경
     * 2018/06/01   PJS             PLAN 시작일 가져오는 조건 변경
     * 2018/06/07   PJS             MA일 경우 FP운용기간-7일 처리
     * 2018/07/16   YHW				ITEM_TYPE 조회조건 추가, 에디트 모드 조회
     * 2019/01/25   YHW				[PS02199094B] [전지 GSCM 대응 및 고도화] Split 함수 변경, WITH(NOLOCK) 추가
     * 2019/04/17   YHW				[CSR ID:3976849] Production Plan Line 조회 내부로직 개선
     * 2019/06/27	YHW				[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
     * 2019/07/18	YHW				오류 선조치 - Item 조회 시 공백 제거함수 사용
     * 2019/08/16	YHW				[CSR ID:4065777] Production Plan Line 개선 - 과거실적 구간 Fix/Unfix 방지
     * 2020/10/28   khj79           [C20201019-000175] 자동차(81) 사업부의 경우 Final Plan 제외하고 전 구간 생산계획 수정 가능
     * 2021/10/13   khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - 82(ESS) 'MA' 플랜 전 구간 수정 가능
     * 2022/05/11   chaan			site 서브쿼리에 EE_UC 추가
     * 2023/03/10   LWY             PJ20230691R - 생산계획 업무이관 연계 시스템 변경 대응 (특정구간 Locking 해제)
     * 2023/04/10   LWY				PJ20230691R - DIVISION_ID 공통화 작업(div_commonization)
     * 2023/05/03   LWY			    PJ20230691R - 81 / SE : PROD_FROZEN 구간 EDIT 불가 적용
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
    BEGIN

        OPEN O_RC1 FOR
        SELECT DISTINCT
               DIVISION_ID||SCM_SITE_ID||PLAN_NAME||PLAN_TYPE||TO_CHAR(PLAN_SEQ)  AS CP_KEY
             , DIVISION_ID
             , SCM_SITE_ID
             , PLAN_VERSION_ID
             , PLAN_NAME                                            AS PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , PLAN_SEQ
             , OSP_YN
             , FP_PLAN_PERIOD
             , OFFSET
             , TO_CHAR(TO_DATE(PLAN_NAME, 'YYYYMMDD') + OFFSET, 'YYYYMMDD')       AS EDIT_START_DATE
             , CASE PLAN_TYPE
                   WHEN 'PR' THEN 0
                   WHEN 'MA' THEN 1
                   WHEN 'SE' THEN 3
                   WHEN 'FI' THEN 4
                   ELSE 9
               END                                                  AS PLAN_TYPE_ORDER
             , CONFIRM_YN
             , CASE
                   WHEN PLAN_NAME < BASIS_START_DATE
                   THEN 'N'
                   ELSE 'Y'
               END                                                  AS DATE_CHK
             , CASE
                   WHEN     PLAN_TYPE  = 'MA'
                        AND CONFIRM_YN = 'Y'
                        AND PLAN_NAME >= BASIS_START_DATE   THEN 'Y'
                   WHEN     PLAN_TYPE  = 'SE'
                        AND PLAN_NAME >= BASIS_START_DATE   THEN 'Y'
                   WHEN     PLAN_TYPE  = 'PR'
                        AND PLAN_NAME >= BASIS_START_DATE   THEN 'Y'
                   ELSE 'N'
               END                                                  AS IS_EDITABLE
             , 'Y'                                                  AS NEW_EDIT_MODE
          FROM (SELECT A.DIVISION_ID
                     , A.PLAN_VERSION_ID
                     , A.PLAN_NAME
                     , A.PLAN_SEQ
                     , A.PLAN_TYPE
                     , A.CONFIRM_YN
                     , B.SCM_SITE_ID
                     , C.OSP_YN
                     , C.FP_PLAN_PERIOD
                          /* 2023/05/03 , 2023/03/10 : 전구간 Locking 해제 */
                     , CASE
                           WHEN     A.DIVISION_ID = '81'
                                AND A.PLAN_TYPE   = 'SE'
                           THEN C.PROD_FROZEN
                           ELSE 0
                       END                                          AS OFFSET
                     , A.BASIS_START_DATE
                     , CASE
                           WHEN     Q.TYPE_SORT   = Q.SEARCH_TYPE_SORT
                                AND Q.PLAN_STATUS = -1
                           THEN 'Y'
                           ELSE 'N'
                       END                                          AS NEW_EDIT_MODE
                  FROM (SELECT IA.DIVISION_ID
                             , IA.PLAN_VERSION_ID
                             , IA.PLAN_NAME
                             , IA.PLAN_SEQ
                             , IA.PLAN_TYPE
                             , IA.CONFIRM_YN
                             , XA.BASIS_START_DATE
                          FROM (SELECT SD.DIVISION_ID
                                     , SP.PLAN_NAME||'-'||SD.PLAN_TYPE||'-'||FN_ZERO_LPAD(TO_CHAR(SD.PLAN_SEQ), 2)  AS PLAN_VERSION_ID
                                     , SP.PLAN_NAME
                                     , SD.PLAN_SEQ
                                     , SD.PLAN_TYPE
                                     , NVL(SD.CONFIRM_FLAG, 'N')    AS CONFIRM_YN
                                  FROM SCM_MST_PLAN_DETAIL  SD
                                     , SCM_MST_PLAN         SP
                                     , SCM_MST_MODELING     SM
                                 WHERE 1 = 1
                                   AND SM.MODELING_ID = SD.MODELING_ID
                                   AND SM.DIVISION_ID = SD.DIVISION_ID
                                   AND SP.DIVISION_ID = SD.DIVISION_ID
                                   AND SP.PLAN_CYCLE  = SM.PLAN_CYCLE
                                   AND SP.PLAN_ID     = SD.PLAN_ID
                                   AND SM.PLAN_CYCLE  = 'WEEKLY'
                                   AND SP.PLAN_NAME  >= FN_GET_BUCKET_YYYYMMDD(-10)  /* 10주전 */
                                   AND SD.DIVISION_ID = P_DIVISION_ID
                                   AND SD.PLAN_TYPE   = P_PLAN_TYPE
                                   AND SD.PLAN_SEQ    = P_SEQ
                                   AND SP.PLAN_NAME   = P_PLAN_START_YYYYMMDD) IA
                             , (SELECT TO_CHAR(TO_DATE(SA.BASIS_YYYYMMDD, 'YYYYMMDD') - (SA.DAYOFWEEK_NO2 - 1), 'YYYYMMDD') AS BASIS_START_DATE
                                  FROM (SELECT CASE
                                                   WHEN CM.DAYOFWEEK_NO - 1 = 0
                                                   THEN 7
                                                   ELSE CM.DAYOFWEEK_NO - 1
                                               END                  AS DAYOFWEEK_NO2
                                             , CM.BASIS_YYYYMMDD
                                          FROM SCM_SYS_CALENDAR_M CM
                                         WHERE CM.BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')) SA) XA) A
                     , SCM_MST_SITE B
                     , (SELECT SA.DIVISION_ID
                             , SA.SCM_SITE_ID
                             , SA.OSP_YN
                             , SA.FP_PLAN_PERIOD
                             , CASE
                                   WHEN SA.OSP_YN = 'Y'
                                   THEN 0
                                   ELSE SA.FP_PLAN_PERIOD
                               END                                  AS OFFSET
                             , SA.PROD_FROZEN   /* 2023/05/03 */
                          FROM SCM_MST_SITE SA) C
                     , (SELECT *
                          FROM (SELECT SP.PLAN_NAME
                                     , SD.PLAN_SEQ
                                     , SD.PLAN_TYPE
                                     , SD.PLAN_STATUS
                                     , CASE SD.PLAN_TYPE
                                           WHEN 'PR' THEN 1
                                           WHEN 'MA' THEN 2
                                           WHEN 'SE' THEN 3
                                           WHEN 'FN' THEN 4
                                       END                          AS TYPE_SORT
                                     , CASE P_PLAN_TYPE
                                           WHEN 'PR' THEN 2
                                           WHEN 'MA' THEN 3
                                           WHEN 'SE' THEN 4
                                           WHEN 'FN' THEN 5
                                       END                          AS SEARCH_TYPE_SORT
                                  FROM SCM_MST_PLAN_DETAIL  SD
                                     , SCM_MST_PLAN         SP
                                 WHERE 1 = 1
                                   AND SP.DIVISION_ID = SD.DIVISION_ID
                                   AND SP.PLAN_ID     = SD.PLAN_ID
                                   AND SP.PLAN_CYCLE  = 'WEEKLY'
                                   AND SD.DIVISION_ID = P_DIVISION_ID
                                   AND SP.PLAN_NAME   = P_PLAN_START_YYYYMMDD
                                 ORDER BY TYPE_SORT DESC, PLAN_SEQ DESC)
                         WHERE ROWNUM = 1) Q
                 WHERE 1 = 1
                   AND B.SITE_TYPE       = 'PLANT'
                   AND B.OPERATION_GROUP = P_OPERATION_GROUP
                   AND B.VALID_YN        = 'Y'
                        /* div_commonization */
                   AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                               FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                        OR B.DIVISION_ID  = P_DIVISION_ID)
                   AND (   P_SCM_SITE_ID IS NULL
                        OR B.SCM_SITE_ID IN (SELECT VALUE
                                               FROM TABLE(FN_SPLITSTRING(P_SCM_SITE_ID, ','))))
                   AND C.DIVISION_ID(+)  = B.DIVISION_ID
                   AND C.SCM_SITE_ID(+)  = B.SCM_SITE_ID);

    END P_SCP0013_GET_PLAN_EDIT_INFO;


    /* ========================================================================================
       4. SCP0013_GET_PLAN_TYPE_SAVE_YN
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_PLAN_SAVE_YN
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_START_YYYYMMDD        IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_PLAN_TYPE_SAVE_YN
     * Description  : PLAN 별 저장가능 여부 정보 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2018/10/15   YHW				Initial Release  전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/10/31	YHW				ORDER BY 조건 수정
     * 2019/01/18	YHW				상위 플랜 갯수와 상관없이 최상위 플랜이 -1이면 수정 가능
     * 2019/07/24	YHW				최종 FN플랜 수정불가
     * 2019/07/29	YHW				[CSR ID:4043582] GSCM - Shipment Plan FG / SEMI "New" 버튼 생성 요청 건
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2026.09.11   [MSSQL -> Oracle 전환]
     *
       EXEC SCP0013_GET_PLAN_TYPE_SAVE_YN @p_division_id='81', @p_start_yyyymmdd='20181008', @p_plan_type='PR'
     */
        V_EDIT_YN   VARCHAR2(1 CHAR);
    BEGIN

        BEGIN
            SELECT SAVE_YN
              INTO V_EDIT_YN
              FROM (SELECT CASE
                               WHEN     A.DISPLAY_SEQ = B.DISPLAY_SEQ
                                    AND P_PLAN_TYPE   = 'FN'    THEN 'N'
                               WHEN     A.DISPLAY_SEQ = B.DISPLAY_SEQ
                                    AND P_PLAN_TYPE  != 'FN'    THEN 'Y'
                               WHEN     A.DISPLAY_SEQ >= B.DISPLAY_SEQ + 10
                                    AND D.PLAN_STATUS = -1      THEN 'Y'
                               ELSE 'N'
                           END                                      AS SAVE_YN
                      FROM SCM_MST_MODELING                 M
                         , SCM_MST_PLAN_DETAIL              D
                         , SCM_MST_PLAN                     P
                         , SCM_ADM_LOOKUP_MASTER_DETAIL     A
                         , SCM_ADM_LOOKUP_MASTER_DETAIL     B
                     WHERE 1 = 1
                       AND M.MODELING_ID = D.MODELING_ID
                       AND M.DIVISION_ID = D.DIVISION_ID
                       AND P.DIVISION_ID = D.DIVISION_ID
                       AND P.PLAN_CYCLE  = M.PLAN_CYCLE
                       AND P.PLAN_ID     = D.PLAN_ID
                       AND A.SEGMENT1    = D.PLAN_TYPE
                       AND M.PLAN_CYCLE  = 'WEEKLY'
                       AND A.LOOKUP_TYPE = 'PLAN_TYPE'
                       AND A.VALID_YN    = 'Y'
                       AND B.LOOKUP_TYPE = 'PLAN_TYPE'
                       AND B.VALID_YN    = 'Y'
                       AND B.SEGMENT1    = P_PLAN_TYPE
                       AND D.DIVISION_ID = P_DIVISION_ID
                       AND P.PLAN_NAME   = P_START_YYYYMMDD
                     ORDER BY A.DISPLAY_SEQ DESC, D.PLAN_SEQ DESC)
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_EDIT_YN := NULL;
        END;

        V_EDIT_YN := NVL(V_EDIT_YN, 'N');

        OPEN O_RC1 FOR
        SELECT V_EDIT_YN                                            AS EDIT_YN
          FROM DUAL;

    END P_SCP0013_GET_PLAN_SAVE_YN;


    /* ========================================================================================
       5. SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_LINE_NEW_CHECK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_DATE             IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK
     * Description  : Production Plan Line New 입력 Validation 체크
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/02/27	YHW				[CSR ID:3936008] Production Plan Line, 신규Line 추가 시 수정 요청
     * 2020/02/07	YHW				ESS 외주 Pakcer Line 생산 Target 적용
     * 2021/05/25   khj79           [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - TACT TIME 테이블 변경
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := '[SCP0013_GET_PRODUCTION_PLAN_LINE_NEW_CHECK]';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         NUMBER             := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        V_CHK_PLAN_LINE     NUMBER             := 0;
        V_CHK_TACT_LINE     NUMBER             := 0;

        V_MSG_LINE          VARCHAR2(4000 CHAR);
        V_MSG_TACT          VARCHAR2(4000 CHAR);

        V_DELIMITER         VARCHAR2(1 CHAR)   := ',';
        V_MAX_LOOP_CNT      NUMBER             := 0;
        V_MST_LOOP_CNT      NUMBER             := 0;

        V_SCM_SITE_ID       VARCHAR2(4000 CHAR);
        V_LINE_ID           VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);

        V_PK_CNT            NUMBER             := 0;

        /* 예외처리 변수 설정 */
        V_ERR_CODE          NUMBER;
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_ERR_TRACE         VARCHAR2(4000 CHAR);
    BEGIN

        /* 임시테이블 초기화 */
        DELETE GT_0013_CHECKLINE;
        DELETE GT_0013_CHECKTT;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        INSERT INTO GT_0013_CHECKLINE
             (
               SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
             )
        SELECT DISTINCT
               SCM_SITE_ID
             , ITEM_ID
             , LINE_ID
          FROM SCP_ANL_PRODUCTION_PLAN
         WHERE 1 = 1
           AND DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_DATE
                /* 파티션 프루닝 */
           AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_DATE, 'YYYYMMDD')
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = P_SEQ
           AND OPERATION_GROUP     = P_OPERATION_GROUP
           AND SCM_SITE_ID        IN (SELECT TOKEN
                                        FROM TABLE(UF_FX_STRING_SPLIT(P_SCM_SITE_ID, ',')))
           AND ITEM_ID            IN (SELECT TOKEN
                                        FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ',')))
           AND LINE_ID            IN (SELECT TOKEN
                                        FROM TABLE(UF_FX_STRING_SPLIT(P_LINE_ID, ',')));

        /* [PJ20209642] : TACT TIME 테이블 변경 */
        INSERT INTO GT_0013_CHECKTT
             (
               ITEM_ID
              ,PLANT_SITE_ID
              ,LINE_ID
             )
        SELECT DISTINCT
               A.ITEM_ID
             , B.SCM_SITE_ID                                        AS PLANT_SITE_ID
             , A.LINE_ID
          FROM (SELECT DISTINCT
                       XA.DIVISION_ID
                     , XA.PLANT_ID
                     , XA.LINE_ID
                     , XA.ITEM_ID
                  FROM SCM_MST_TACT_TIME_SN XA
                 WHERE XA.MONTH >= TO_CHAR(SYSDATE, 'YYYYMM')) A
             , SCM_MST_SITE B
         WHERE 1 = 1
           AND A.DIVISION_ID = B.DIVISION_ID
           AND A.PLANT_ID    = B.PLANT_ID
           AND A.DIVISION_ID IN (SELECT TOKEN
                                   FROM TABLE(UF_FX_STRING_SPLIT(P_ORIGIN_DIVISION_ID, ',')));

        /* ESS 외주 Pakcer Line 생산 Target 적용 : OSP T/T 추가 */
        INSERT INTO GT_0013_CHECKTT
             (
               ITEM_ID
              ,PLANT_SITE_ID
              ,LINE_ID
             )
        SELECT DISTINCT
               ITEM_ID
             , PLANT_SITE_ID
             , LINE_ID
          FROM SCP_MST_TACT_TIME_OSP
         WHERE 1 = 1
           AND VALID_YN = 'Y';

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ITEM_ID, V_DELIMITER));

        WHILE     LENGTH(RTRIM(P_ITEM_ID)) > 0
              AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_SCM_SITE_ID := SCM_ARR_SPL_VAL(P_SCM_SITE_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_LINE_ID     := SCM_ARR_SPL_VAL(P_LINE_ID    , V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID     := SCM_ARR_SPL_VAL(P_ITEM_ID    , V_DELIMITER, V_MST_LOOP_CNT);

            /* 1.기존 PLAN 라인 확인 */
            SELECT COUNT(*)
              INTO V_PK_CNT
              FROM GT_0013_CHECKLINE
             WHERE 1 = 1
               AND SCM_SITE_ID = V_SCM_SITE_ID
               AND ITEM_ID     = V_ITEM_ID
               AND LINE_ID     = V_LINE_ID;

            IF V_PK_CNT > 0 THEN
                IF V_MSG_LINE IS NOT NULL THEN
                    V_MSG_LINE := V_MSG_LINE||', ';
                END IF;

                V_MSG_LINE      := V_MSG_LINE||V_SCM_SITE_ID||'/'||V_LINE_ID||'/'||V_ITEM_ID;
                V_CHK_PLAN_LINE := V_CHK_PLAN_LINE + 1;
            END IF;

            /* 2.Tact Time 확인 - 외주일 시 LINE 값이 '-'로 들어옴 */
            IF V_LINE_ID != '-' THEN
                SELECT COUNT(*)
                  INTO V_PK_CNT
                  FROM GT_0013_CHECKTT
                 WHERE 1 = 1
                   AND PLANT_SITE_ID = V_SCM_SITE_ID
                   AND ITEM_ID       = V_ITEM_ID
                   AND LINE_ID       = V_LINE_ID;

                IF V_PK_CNT = 0 THEN
                    IF V_MSG_TACT IS NOT NULL THEN
                        V_MSG_TACT := V_MSG_TACT||', ';
                    END IF;

                    V_MSG_TACT      := V_MSG_TACT||V_SCM_SITE_ID||'/'||V_LINE_ID||'/'||V_ITEM_ID;
                    V_CHK_TACT_LINE := V_CHK_TACT_LINE + 1;
                END IF;
            END IF;

        END LOOP;

        /* 결과 */
        IF V_CHK_PLAN_LINE > 0 THEN
            OPEN O_RC1 FOR
            SELECT 'L'          AS RESULT_CODE
                 , V_MSG_LINE   AS MSG
              FROM DUAL;
        ELSIF V_CHK_TACT_LINE > 0 THEN
            OPEN O_RC1 FOR
            SELECT 'T'          AS RESULT_CODE
                 , V_MSG_TACT   AS MSG
              FROM DUAL;
        ELSE
            OPEN O_RC1 FOR
            SELECT 'S'          AS RESULT_CODE
                 , NULL         AS MSG
              FROM DUAL;
        END IF;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;
            V_ERR_TRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            INSERT INTO SCM_SYS_LOG_BATCH
                 (
                   PROGRAM_NAME
                  ,LOG_TYPE
                  ,LOG_COUNT
                  ,LOG_MESSAGE
                  ,DESCRIPTION
                  ,EVENT_DATE
                  ,CREATION_DATE
                  ,CREATED_BY
                  ,LAST_UPDATE_DATE
                  ,LAST_UPDATED_BY
                 )
            VALUES
                 (
                   V_PROGRAM_NAME
                  ,'ERROR'
                  ,NULL
                  ,V_ERR_MESSAGE
                  ,V_ERR_TRACE
                  ,SYSDATE
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                 );

            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                COMMIT;
            END IF;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
            SELECT 'F'                                          AS RESULT_CODE
                 , '['||TO_CHAR(V_ERR_CODE)||']'||V_ERR_MESSAGE  AS ERR_MESSAGE
              FROM DUAL;

    END P_SCP0013_GET_LINE_NEW_CHECK;

    /* ========================================================================================
       6. SCP0013_GET_PRODUCTION_PLAN_LINEBY
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_PROD_PLAN_LINEBY
    (
        P_DIVISION_ID           IN  VARCHAR2 DEFAULT '',
        P_OPERATION_GROUP       IN  VARCHAR2 DEFAULT '',
        P_SCM_SITE_ID           IN  VARCHAR2 DEFAULT '',
        P_LINE_ID               IN  VARCHAR2 DEFAULT '',
        P_MODEL_ID              IN  VARCHAR2 DEFAULT '',
        P_ITEM_ID               IN  VARCHAR2 DEFAULT '',
        P_FROM_YYYYMMDD         IN  VARCHAR2 DEFAULT '',
        P_TO_YYYYMMDD           IN  VARCHAR2 DEFAULT '',
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2 DEFAULT '',
        P_PLAN_TYPE             IN  VARCHAR2 DEFAULT '',
        P_SEQ                   IN  VARCHAR2 DEFAULT '',
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0013',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'LINE',
        P_USER_ID               IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE        IN  VARCHAR2 DEFAULT '',
        P_NICK_NAME             IN  VARCHAR2 DEFAULT '',
        P_CELL_TYPE_GR          IN  VARCHAR2 DEFAULT '',
        P_LINE_ASSIGN           IN  VARCHAR2 DEFAULT 'N',
        P_BUCKET                IN  VARCHAR2 DEFAULT '',
        P_CHK_ALL               IN  VARCHAR2 DEFAULT '',
        P_EXTRA_SPEC            IN  VARCHAR2 DEFAULT '',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR,
        O_RC4                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_PRODUCTION_PLAN_LINEBY
     * Description  : Production Plan Line 별 조회
     * Program History
     *===================================================================================================
     * Date         In Charge                 Description
     *===================================================================================================
     * 2018/04/19   byunghunjung	          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     *   (중략 - AS-IS 이력 주석 원문 유지)
     * 2024/01/08   E20240104-001182          EE JV 를 위한 Division Group 처리 / STD JR Measure 처리
     * 2025/09/01   PJ20257329                SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용
     * 2026/02/26   E20260226-001691          82 Div Virtual Plant 실적 구간 데이터 조회 기능
     * 2026/04/15   E20260415-000894          타 DIVISION 에서 ESS 실적 안나오게 수정
     * 2026.09.11   [MSSQL -> Oracle 전환]
     * 2026.10.07   AJS                       조회 속도 개선 - ISUZU 품목 적재를 실적 구간 분기 안으로 이동 · 라인 작업시간 적재를 계획 행 열쇠로 한정 · 부하율 합계 조인 순서 · 단위 조회 품목 한정 · 가동일수 집계를 부하율 대상 라인으로 한정 (결과 동일)
     *
     * 결과셋 : O_RC1 = 계획/실적 피벗 , O_RC2 = FIX 정보 , O_RC3 = 주 부하율 피벗 , O_RC4 = 월 부하율 피벗
     */
        /* 20240108  E20240104-001182 EE JV 를 위한 Division Group 처리 */
        V_DIVISION_GROUP        VARCHAR2(30 CHAR);
        V_DIVISION_COMP         VARCHAR2(30 CHAR);

        V_CNT_USR_MEASURE       NUMBER            := 0;
        V_ITEM_INPUT            VARCHAR2(1 CHAR)  := 'N';
        V_MIN_YYYYMMDD          VARCHAR2(8 CHAR);

        V_PLAN_MONTH            VARCHAR2(6 CHAR);
        V_FROM_YYYYMMDD         VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD           VARCHAR2(8 CHAR);
        V_FROM_RESULT           VARCHAR2(8 CHAR);
        V_TO_RESULT             VARCHAR2(8 CHAR);
        V_RESULT_ONLY           VARCHAR2(1 CHAR)  := 'N';
        V_BUCKET                VARCHAR2(10 CHAR) := P_BUCKET;
        V_PLAN_END_YYYYMMDD     VARCHAR2(8 CHAR);   /* AS-IS 에서도 대입 후 사용하지 않는다 */
        V_DOW_NO                NUMBER;

        /* 결과셋마다 변수를 따로 둔다 - 하나를 돌려 쓰면 뒤에서 덮어쓴 내용이                */
        /* 앞서 OPEN 한 REF CURSOR 에까지 반영되어(CLOB 로케이터 재사용) 결과가 비어 버린다.  */
        V_COL_PIVOT1            CLOB;
        V_COL_PIVOT3            CLOB;
        V_COL_PIVOT4            CLOB;
        V_SQL1                  CLOB;
        V_SQL3                  CLOB;
        V_SQL4                  CLOB;
    BEGIN

        /*------------------------------------------------------------------
         * Division Group 정의  (Joint Venture 사업부 추가)
           - JV사업부 코드(81_UC, EE_UC)추가되면서 division_id만으로는 사업부별 로직분개시 구분값으로 활용 불가.
           - 40, 81, 82, EE 등 사업부별 로직전개에 사용할 기준값을 (attribute3)컬럼에 정의하고 변수로 처리
        ----------------------------------------------------------------------*/
        SELECT MAX(DI.ATTRIBUTE3)
             , MAX(DI.ATTRIBUTE4)
          INTO V_DIVISION_GROUP
             , V_DIVISION_COMP
          FROM SCM_MST_DIVISION DI
         WHERE 1 = 1
           AND DI.VALID_YN    = 'Y'
           AND DI.DIVISION_ID = P_DIVISION_ID;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        /* 20240108  E20240104-001182 STD 처리용 Plan 주차 월 정보 - 당주 월요일이 속한 월 기준 */
        SELECT MAX(C.BASIS_YYYYMM)
          INTO V_PLAN_MONTH
          FROM SCM_SYS_CALENDAR_M C
         WHERE 1 = 1
           AND C.BASIS_YYYYMMDD = TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

        SELECT MAX(C.BASIS_START_DATE)
          INTO V_FROM_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M C
         WHERE 1 = 1
           AND C.BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;

        SELECT MAX(C.BASIS_START_DATE)
          INTO V_FROM_RESULT
          FROM SCM_SYS_CALENDAR_M C
         WHERE 1 = 1
           AND C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

        SELECT MAX(C.BASIS_START_DATE)
          INTO V_TO_RESULT
          FROM SCM_SYS_CALENDAR_M C
         WHERE 1 = 1
           AND C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;

        IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
            /* 실적 보여줌 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_TO_RESULT   := V_FROM_YYYYMMDD;
        ELSIF V_FROM_YYYYMMDD <= V_FROM_RESULT THEN
            /* 실적 없음 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_FROM_RESULT := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'),  6), 'YYYYMMDD');
            V_TO_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        ELSIF V_FROM_YYYYMMDD > V_TO_RESULT THEN
            V_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_FROM_RESULT   := P_FROM_YYYYMMDD;
            V_TO_RESULT     := P_TO_YYYYMMDD;
        ELSIF V_FROM_YYYYMMDD = V_TO_RESULT THEN
            V_TO_YYYYMMDD := V_FROM_YYYYMMDD;
            V_FROM_RESULT := P_FROM_YYYYMMDD;
            V_TO_RESULT   := P_TO_YYYYMMDD;
        END IF;

        /* 실적용 */
        IF V_FROM_YYYYMMDD > V_TO_YYYYMMDD THEN
            V_RESULT_ONLY := 'Y';
        END IF;

        /* AS-IS 는 대입만 하고 이후 사용하지 않는다. 원문 계산을 유지한다. */
        SELECT MAX(TO_CHAR(TO_DATE(U.MAX_BASIS_YYYYMMDD, 'YYYYMMDD')
                           - (MOD(TO_DATE(U.MAX_BASIS_YYYYMMDD, 'YYYYMMDD') - TO_DATE('19000107', 'YYYYMMDD'), 7) + 1)
                           + 1, 'YYYYMMDD'))
          INTO V_PLAN_END_YYYYMMDD
          FROM (SELECT MIN(A.BASIS_YYYYMMDD)                        AS MIN_BASIS_YYYYMMDD
                     , MAX(A.BASIS_YYYYMMDD)                        AS MAX_BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMMDD >= P_PLAN_START_YYYYMMDD
                        /* 2021-05-27 : 중장기(12=>18로 변경) */
                   AND A.BASIS_YYYYMMDD <= TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 18), 'YYYYMMDD')) U;

        /* 2021.11.24 : 체크 시 bucket='daily' 조회 */
        IF P_CHK_ALL = 'Y' THEN
            V_BUCKET := 'DAILY';
        END IF;

        /* 2023.01.02 previous monday - MSSQL DATEPART(dw) 는 일요일이 1 이다 */
        V_DOW_NO       := MOD(TRUNC(SYSDATE) - TO_DATE('19000107', 'YYYYMMDD'), 7) + 1;
        V_MIN_YYYYMMDD := TO_CHAR(TRUNC(SYSDATE) - V_DOW_NO - 5, 'YYYYMMDD');

        /********************************************************************************
        * 임시테이블 초기화
        ********************************************************************************/
        DELETE GT_0013_JV_ESS_MAP;
        DELETE GT_0013_PL_BY_SEARCH;
        DELETE GT_0013_PL_BY_TT;
        DELETE GT_0013_TMP;
        DELETE GT_0013_KEY;
        DELETE GT_0013_WORKING_DATA;
        DELETE GT_0013_LOAD;
        DELETE GT_0013_ISUZU;
        DELETE GT_0013_PERFOR;
        DELETE GT_0013_PERFOR_ESS_JV;
        DELETE GT_0013_PLAN;
        DELETE GT_0013_PIVOT;
        DELETE GT_0013_LOOKUP;
        DELETE GT_0013_BUCKET_SUM;
        DELETE GT_0013_BUCKET_CNT;
        DELETE GT_0013_BUCKET_RATIO;

        /* E20260226-001691 82 Div Virtual Plant 실적 구간 데이터 조회 기능 */
        /* ESS 혼용생산 로직 처리를 위해 혼용생산MAP정보 임시테이블 추가. */
        INSERT INTO GT_0013_JV_ESS_MAP
             (
               COMPANY_ID
              ,DIVISION_ID
              ,PLANT_ID
              ,LINE_ID
              ,SCM_SITE_ID
              ,LINK_COMPANY_ID
              ,LINK_DIVISION_ID
              ,LINK_PLANT_ID
              ,LINK_LINE_ID
              ,LINK_SCM_SITE_ID
             )
        SELECT A.COMPANY_ID
             , A.DIVISION_ID
             , A.PLANT_ID
             , B.LINE_ID
             , C.SCM_SITE_ID
             , D.COMPANY_ID                                         AS LINK_COMPANY_ID
             , D.DIVISION_ID                                        AS LINK_DIVISION_ID
             , A.LINK_PLANT_ID
             , B.LINK_LINE_ID
             , C.ATTRIBUTE9                                         AS LINK_SCM_SITE_ID
          FROM (SELECT IA.COMPANY_ID
                     , IA.DIVISION_ID
                     , IA.PLANT_ID
                     , IA.LINK_PLANT_ID
                  FROM SCM_MST_PLANT_SN IA
                 WHERE IA.PLANT_TYPE = 'VIRTUAL') A
             , (SELECT DISTINCT
                       XA.COMPANY_ID
                     , XA.DIVISION_ID
                     , XA.PLANT_ID
                     , XA.LINE_ID
                     , XA.LINK_LINE_ID
                     , SUBSTR(XA.OPERATION_ID, 1, 1)                AS SCP_OPERATION_GROUP
                  FROM SCM_MST_LINE_SN XA
                 WHERE 1 = 1
                   AND XA.VIRTUAL_LINE_YN = 'Y'
                   AND XA.ACTIVE_FLAG     = 'Y'
                   AND SUBSTR(XA.OPERATION_ID, 1, 1) IN ('A', 'E', 'P')) B
             , (SELECT SA.COMPANY_ID
                     , SA.DIVISION_ID
                     , SA.PLANT_ID
                     , SA.SCM_SITE_ID
                     , SA.OPERATION_GROUP
                     , SA.ATTRIBUTE9
                  FROM SCM_MST_SITE SA
                 WHERE 1 = 1
                   AND SA.SITE_TYPE  = 'PLANT'
                   AND SA.VALID_YN   = 'Y'
                   AND SA.ATTRIBUTE9 != '-') C
             , (SELECT SB.COMPANY_ID
                     , SB.DIVISION_ID
                     , SB.SCM_SITE_ID
                  FROM SCM_MST_SITE SB
                 WHERE 1 = 1
                   AND SB.SITE_TYPE = 'PLANT'
                   AND SB.VALID_YN  = 'Y') D
         WHERE 1 = 1
           AND A.COMPANY_ID           = B.COMPANY_ID
           AND A.DIVISION_ID          = B.DIVISION_ID
           AND A.PLANT_ID             = B.PLANT_ID
           AND A.COMPANY_ID           = C.COMPANY_ID
           AND A.DIVISION_ID          = C.DIVISION_ID
           AND A.PLANT_ID             = C.PLANT_ID
           AND B.SCP_OPERATION_GROUP  = C.OPERATION_GROUP
           AND C.ATTRIBUTE9           = D.SCM_SITE_ID;

        /* Model/NickName 조회여부 및 Plant, Line 추출 */
        IF    P_NICK_NAME IS NOT NULL
           OR P_ITEM_ID   IS NOT NULL THEN

            V_ITEM_INPUT := 'Y';

            IF P_PLAN_START_YYYYMMDD >= V_MIN_YYYYMMDD THEN

                INSERT INTO GT_0013_PL_BY_SEARCH
                     (
                       SCM_SITE_ID
                      ,LINE_ID
                     )
                SELECT DISTINCT
                       A.SCM_SITE_ID
                     , A.LINE_ID
                  FROM SCP_ANL_PRODUCTION_PLAN A
                 WHERE 1 = 1
                   AND A.DIVISION_ID         = P_DIVISION_ID
                   AND A.OPERATION_GROUP     = P_OPERATION_GROUP
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                        /* 파티션 프루닝 */
                   AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                   AND A.PLAN_TYPE           = P_PLAN_TYPE
                   AND A.SEQ                 = P_SEQ
                   AND A.LINE_ID            != '*'
                   AND A.ITEM_ID            IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME)))
                 UNION
                    /* 2021/07/06 LWY */
                SELECT DISTINCT
                       A.SCM_SITE_ID
                     , A.LINE_ID
                  FROM SCM_DNM_PRODUCT_RESULT_V A
                 WHERE 1 = 1
                   AND A.DIVISION_ID        = P_DIVISION_ID
                   AND A.COMPANY_ID        IN (SELECT DISTINCT
                                                      IA.COMPANY_ID
                                                 FROM SCM_MST_SITE IA
                                                WHERE 1 = 1
                                                  AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                                                              FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                                                       OR IA.DIVISION_ID = P_DIVISION_ID)
                                                  AND IA.SITE_TYPE = 'PLANT'
                                                  AND IA.VALID_YN  = 'Y')
                   AND A.SCP_OPERATION_GROUP = P_OPERATION_GROUP
                   AND A.PLAN_DATE          >= V_FROM_RESULT
                   AND A.PLAN_DATE          <  V_TO_RESULT
                   AND A.LINE_ID            != '*'
                   AND A.ITEM_ID            IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME)))
                 UNION
                    /* E20260226-001691 YMH 82 Div Virtual Plant 실적 구간 데이터 조회 기능 */
                    /* 실적은 UI에서 보여지는 기준의 VP 정보로 반영되니 VP정보로 입력함. */
                SELECT SCM_SITE_ID
                     , LINE_ID
                  FROM GT_0013_JV_ESS_MAP
                 WHERE DIVISION_ID = P_DIVISION_ID;

            ELSE

                INSERT INTO GT_0013_PL_BY_SEARCH
                     (
                       SCM_SITE_ID
                      ,LINE_ID
                     )
                SELECT DISTINCT
                       A.SCM_SITE_ID
                     , A.LINE_ID
                  FROM HIST_SCP_ANL_PRODUCTION_PLAN A
                 WHERE 1 = 1
                   AND A.DIVISION_ID         = P_DIVISION_ID
                   AND A.OPERATION_GROUP     = P_OPERATION_GROUP
                   AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE           = P_PLAN_TYPE
                   AND A.SEQ                 = P_SEQ
                   AND A.LINE_ID            != '*'
                   AND A.ITEM_ID            IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME)))
                 UNION
                SELECT DISTINCT
                       A.SCM_SITE_ID
                     , A.LINE_ID
                  FROM SCM_DNM_PRODUCT_RESULT_V A
                 WHERE 1 = 1
                   AND A.DIVISION_ID        = P_DIVISION_ID
                   AND A.COMPANY_ID        IN (SELECT DISTINCT
                                                      IA.COMPANY_ID
                                                 FROM SCM_MST_SITE IA
                                                WHERE 1 = 1
                                                  AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                                                              FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                                                       OR IA.DIVISION_ID = P_DIVISION_ID)
                                                  AND IA.SITE_TYPE = 'PLANT'
                                                  AND IA.VALID_YN  = 'Y')
                   AND A.SCP_OPERATION_GROUP = P_OPERATION_GROUP
                   AND A.PLAN_DATE          >= V_FROM_RESULT
                   AND A.PLAN_DATE          <  V_TO_RESULT
                   AND A.LINE_ID            != '*'
                   AND A.ITEM_ID            IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, P_NICK_NAME)))
                 UNION
                SELECT SCM_SITE_ID
                     , LINE_ID
                  FROM GT_0013_JV_ESS_MAP
                 WHERE DIVISION_ID = P_DIVISION_ID;

            END IF;

        END IF;

        /* Line Assign용 Plant, Line 추출 */
        IF P_LINE_ASSIGN = 'Y' THEN

            INSERT INTO GT_0013_PL_BY_TT
                 (
                   SCM_SITE_ID
                  ,LINE_ID
                  ,LINE_ASSIGN_KEY
                 )
            SELECT DISTINCT
                   A.PLANT_SITE_ID                                  AS SCM_SITE_ID
                 , A.LINE_ID
                 , A.PLANT_SITE_ID||A.LINE_ID||A.OPERATION_ID       AS LINE_ASSIGN_KEY
              FROM SCP_MST_TACT_TIME        A
                 , SCM_MST_SITE             B
                 , SCM_MST_LINE_SN          C
                 , SCP_MST_FINAL_ITEM_V     D
             WHERE 1 = 1
               AND A.DIVISION_ID   = B.DIVISION_ID
               AND A.PLANT_SITE_ID = B.SCM_SITE_ID
               AND B.OSP_YN        = 'N'    /* 외주 제외 */
               AND C.COMPANY_ID    = B.COMPANY_ID
               AND C.DIVISION_ID   = B.DIVISION_ID
               AND C.SITE_ID       = B.SITE_ID
               AND C.PLANT_ID      = B.PLANT_ID
               AND C.OPERATION_ID  = A.OPERATION_ID
               AND C.LINE_ID       = A.LINE_ID
               AND C.ACTIVE_FLAG   = 'Y'    /* 활성화 된 라인 */
               AND D.ITEM_ID       = A.ITEM_ID
               AND NVL(D.TCO_CELL_YN, '-') = 'N'    /* TCO Cell 제외 */
               AND A.VALID_YN      = 'Y'
                    /* div_commonization */
               AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                    OR A.DIVISION_ID  = P_DIVISION_ID)
               AND A.OPERATION_ID != 'P5000'    /* P5000공정 제외 */
               AND (   P_ITEM_ID IS NULL
                    OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
             UNION ALL
                /* 외주 */
            SELECT DISTINCT
                   A.SCM_SITE_ID
                 , '-'                                              AS LINE_ID
                 , A.SCM_SITE_ID||'-'||B.VENDOR_CODE                AS LINE_ASSIGN_KEY
              FROM SCM_MST_SITE                 A
                 , SCM_MST_VENDOR               B
                 , SCM_MST_SITE_ITEM_PRIORITY   C
                 , SCP_MST_OUTSOURCING_CAPA     D
             WHERE 1 = 1
               AND A.PLANT_ID    = B.VENDOR_CODE
               AND A.DIVISION_ID = C.DIVISION_ID
               AND A.SCM_SITE_ID = C.PLANT_SITE_ID
               AND A.DIVISION_ID = D.DIVISION_ID
               AND A.SCM_SITE_ID = D.PLANT_SITE_ID
               AND C.ITEM_ID     = D.ITEM_ID
               AND (   P_DIVISION_ID = 'EE'
                    OR A.DIVISION_ID = P_DIVISION_ID)
               AND A.OSP_YN      = 'Y'      /* 외주 */
                    /* ESS 외주 Pakcer Line 생산 Target 적용 */
               AND NVL(A.ATTRIBUTE1, 'N') = 'N'
               AND A.VALID_YN    = 'Y'
               AND C.VALID_YN    = 'Y'      /* Project Route */
               AND (   P_ITEM_ID IS NULL
                    OR D.ITEM_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))))
             UNION ALL
                /* ESS 외주 Pakcer Line 생산 Target 적용 */
            SELECT DISTINCT
                   A.PLANT_SITE_ID                                  AS SCM_SITE_ID
                 , A.LINE_ID
                 , A.PLANT_SITE_ID||A.LINE_ID||C.VENDOR_CODE        AS LINE_ASSIGN_KEY
              FROM SCP_MST_TACT_TIME_OSP   A
                 , SCM_MST_SITE            B
                 , SCM_MST_VENDOR          C
                 , SCM_MST_LINE_OSP        D
             WHERE 1 = 1
               AND A.DIVISION_ID   = B.DIVISION_ID
               AND A.PLANT_SITE_ID = B.SCM_SITE_ID
               AND B.OSP_YN        = 'Y'
               AND NVL(B.ATTRIBUTE1, 'N') = 'Y'
               AND B.VALID_YN      = 'Y'
               AND B.PLANT_ID      = C.VENDOR_CODE
               AND D.DIVISION_ID   = B.DIVISION_ID
               AND D.SCM_SITE_ID   = B.SCM_SITE_ID
               AND D.VALID_YN      = 'Y'
               AND A.LINE_ID       = D.LINE_ID
               AND A.VALID_YN      = 'Y'
                    /* div_commonization */
               AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                    OR A.DIVISION_ID  = P_DIVISION_ID)
               AND (   P_ITEM_ID IS NULL
                    OR A.ITEM_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))));

        END IF;

        /********************************************************************************
        * Base Row - qty > 0 추출
        ********************************************************************************/
        IF P_PLAN_START_YYYYMMDD >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0013_TMP
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,OPERATION_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,CELL_QTY
                  ,SCM_SITE_ID2
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                 )
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.QTY
                 , A.CELL_QTY
                 , CASE
                       WHEN SUBSTR(A.SCM_SITE_ID, -2) = '-S'
                       THEN SUBSTR(A.SCM_SITE_ID, 1, LENGTH(RTRIM(A.SCM_SITE_ID)) - 2)
                       ELSE A.SCM_SITE_ID
                   END                                              AS SCM_SITE_ID2
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , B.CELL_TYPE_GROUP_CODE
              FROM SCP_ANL_PRODUCTION_PLAN  A
                 , SCP_MST_FINAL_ITEM       B
             WHERE 1 = 1
               AND A.DIVISION_ID     = B.DIVISION_ID(+)
               AND A.ITEM_ID         = B.ITEM_ID(+)
               AND A.OPERATION_GROUP = B.OPERATION_GROUP(+)
               AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD       <= P_TO_YYYYMMDD
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    /* 파티션 프루닝 */
               AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND A.PLAN_TYPE       = P_PLAN_TYPE
               AND A.SEQ             = P_SEQ
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
               AND (   P_CELL_TYPE_GR IS NULL
                    OR B.CELL_TYPE_GROUP_CODE IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_CELL_TYPE_GR, ','))))
               AND NVL(A.QTY, 0) > 0;

        ELSE

            INSERT INTO GT_0013_TMP
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,OPERATION_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,CELL_QTY
                  ,SCM_SITE_ID2
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                 )
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.QTY
                 , A.CELL_QTY
                 , CASE
                       WHEN SUBSTR(A.SCM_SITE_ID, -2) = '-S'
                       THEN SUBSTR(A.SCM_SITE_ID, 1, LENGTH(RTRIM(A.SCM_SITE_ID)) - 2)
                       ELSE A.SCM_SITE_ID
                   END                                              AS SCM_SITE_ID2
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , B.CELL_TYPE_GROUP_CODE
              FROM HIST_SCP_ANL_PRODUCTION_PLAN  A
                 , SCP_MST_FINAL_ITEM            B
             WHERE 1 = 1
               AND A.DIVISION_ID     = B.DIVISION_ID(+)
               AND A.ITEM_ID         = B.ITEM_ID(+)
               AND A.OPERATION_GROUP = B.OPERATION_GROUP(+)
               AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD       <= P_TO_YYYYMMDD
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    /* 파티션 프루닝 */
               AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND A.PLAN_TYPE       = P_PLAN_TYPE
               AND A.SEQ             = P_SEQ
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
               AND (   P_CELL_TYPE_GR IS NULL
                    OR B.CELL_TYPE_GROUP_CODE IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_CELL_TYPE_GR, ','))))
               AND NVL(A.QTY, 0) > 0;

        END IF;

        /* 20240108  E20240104-001182 PROD_PLAN_ENGINE 기준으로 전극단위 추가 및 계산          */
        /* 전극 단위 가 M 일때 QTY / LANE , EA 일때 QTY / (LANE * CELL_CF)                     */
        IF     V_DIVISION_GROUP  = 'EE'
           AND P_OPERATION_GROUP = 'E' THEN

            INSERT INTO GT_0013_TMP
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,OPERATION_ID
                  ,MEASURE
                  ,YYYYMMDD
                  ,QTY
                  ,CELL_QTY
                  ,SCM_SITE_ID2
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                 )
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , 'PROD_PLAN_ENGINE_STD_JR'                        AS MEASURE
                 , A.YYYYMMDD
                 , CASE
                       WHEN X.ITEM_UOM = 'M'
                       THEN CASE
                                WHEN B.LANE_QTY = 0
                                THEN A.QTY / 1.0
                                ELSE A.QTY / NULLIF(B.LANE_QTY / NVL(TO_NUMBER(F.ATTRIBUTE1), 1.0), 0)
                            END
                       WHEN X.ITEM_UOM = 'EA'
                       THEN CASE
                                WHEN F.ATTRIBUTE1 = '1'
                                THEN A.QTY / NULLIF(NVL(FG.JOMBO_ROLL, NVL(FW.JOMBO_ROLL, 1.0)), 0)
                                         / NULLIF(1.0 / NVL(TO_NUMBER(F.ATTRIBUTE1), 1.0), 0)
                                WHEN     F.ATTRIBUTE1 = '2'
                                     AND FW.JOMBO_ROLL IS NULL
                                THEN A.QTY / NULLIF(NVL(FG.JOMBO_ROLL, 1.0), 0)
                            END
                       ELSE A.QTY
                   END                                              AS QTY
                 , 0                                                AS CELL_QTY
                 , A.SCM_SITE_ID2
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.CELL_TYPE_GROUP_CODE
              FROM GT_0013_TMP                  A
                 , SCM_MST_ITEM_LINE_ASSIGN_SN  B
                 , (SELECT DISTINCT
                           IA.ITEM_ID
                         , IA.ITEM_UOM
                         , MIN(IA.DIVISION_ID)                      AS DIVISION_ID
                      FROM SCM_MST_ITEM_SN IA
                     WHERE 1 = 1
                     GROUP BY IA.ITEM_ID, IA.ITEM_UOM) X
                 , SCP_MST_ITEM_CELL_CF          H
                 , (SELECT IA.SCM_SITE_ID
                         , IA.LINE_ID
                         , IA.ITEM_ID
                         , IA.ATTRIBUTE1
                         , IA.JOMBO_ROLL
                      FROM (SELECT C.ITEM_ID
                                 , C.VALUE                          AS JOMBO_ROLL
                                 , F.SEGMENT1                       AS SCM_SITE_ID
                                 , F.SEGMENT4                       AS LINE_ID
                                 , F.ATTRIBUTE1
                                 , ROW_NUMBER() OVER (PARTITION BY C.SITE_ID
                                                                 , F.SEGMENT4
                                                                 , C.ITEM_ID
                                                          ORDER BY C.APPLY_DATE DESC) AS RN
                              FROM SCM_MST_ITEM_CONV_CALC_SN    C
                                 , (SELECT SA.SEGMENT1
                                         , SA.SEGMENT3
                                         , SA.SEGMENT4
                                         , SA.ATTRIBUTE1
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                     WHERE 1 = 1
                                       AND SA.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%') F
                             WHERE 1 = 1
                               AND C.FACTORY_ID     = F.SEGMENT3
                               AND C.CATEGORY       = 'Jumbo Roll (cell/m)'
                               AND C.VERSION_TYPE   = 'MASS'
                               AND C.MAX_VER_FLAG   = 'Y') IA
                     WHERE IA.RN = 1) F
                 , (SELECT IA.SCM_SITE_ID
                         , IA.LINE_ID
                         , IA.ITEM_ID
                         , IA.ATTRIBUTE1
                         , IA.JOMBO_ROLL
                      FROM (SELECT C.ITEM_ID
                                 , C.VALUE                          AS JOMBO_ROLL
                                 , F.SEGMENT1                       AS SCM_SITE_ID
                                 , F.SEGMENT4                       AS LINE_ID
                                 , F.ATTRIBUTE1
                                 , ROW_NUMBER() OVER (PARTITION BY C.SITE_ID
                                                                 , F.SEGMENT4
                                                                 , C.ITEM_ID
                                                          ORDER BY C.APPLY_DATE DESC) AS RN
                              FROM SCM_MST_ITEM_CONV_CALC_SN    C
                                 , (SELECT SA.SEGMENT1
                                         , SA.SEGMENT3
                                         , SA.SEGMENT4
                                         , SA.ATTRIBUTE1
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                     WHERE 1 = 1
                                       AND SA.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%') F
                             WHERE 1 = 1
                               AND C.FACTORY_ID       = F.SEGMENT3
                               AND C.CATEGORY         = 'Jumbo Roll (cell/m)'
                               AND C.VERSION_TYPE     = 'MASS'
                               AND C.MAX_VER_FLAG     = 'Y'
                               AND C.PROD_VERSION_TYPE = 'GENERAL') IA
                     WHERE IA.RN = 1) FG
                 , (SELECT IA.SCM_SITE_ID
                         , IA.LINE_ID
                         , IA.ITEM_ID
                         , IA.ATTRIBUTE1
                         , IA.JOMBO_ROLL
                      FROM (SELECT C.ITEM_ID
                                 , C.VALUE                          AS JOMBO_ROLL
                                 , F.SEGMENT1                       AS SCM_SITE_ID
                                 , F.SEGMENT4                       AS LINE_ID
                                 , F.ATTRIBUTE1
                                 , ROW_NUMBER() OVER (PARTITION BY C.SITE_ID
                                                                 , F.SEGMENT4
                                                                 , C.ITEM_ID
                                                          ORDER BY C.APPLY_DATE DESC) AS RN
                              FROM SCM_MST_ITEM_CONV_CALC_SN    C
                                 , (SELECT SA.SEGMENT1
                                         , SA.SEGMENT3
                                         , SA.SEGMENT4
                                         , SA.ATTRIBUTE1
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                     WHERE 1 = 1
                                       AND SA.LOOKUP_TYPE LIKE '%ELECTRODE_LINE_WIDE_RATE%') F
                             WHERE 1 = 1
                               AND C.FACTORY_ID       = F.SEGMENT3
                               AND C.CATEGORY         = 'Jumbo Roll (cell/m)'
                               AND C.VERSION_TYPE     = 'MASS'
                               AND C.MAX_VER_FLAG     = 'Y'
                               AND C.PROD_VERSION_TYPE = 'WIDE') IA
                     WHERE IA.RN = 1) FW
             WHERE 1 = 1
               AND A.ITEM_ID       = B.ITEM_ID(+)
               AND B.LANE_QTY(+)  != 0
               AND B.MONTH(+)      = V_PLAN_MONTH   /* 20240108 당주가 속한 월 조건으로 변경 */
               AND A.LINE_ID       = B.LINE_ID(+)
               AND A.ITEM_ID       = X.ITEM_ID(+)
               AND A.ITEM_ID       = H.ITEM_ID(+)   /* CELL */
               AND A.SCM_SITE_ID   = F.SCM_SITE_ID(+)
               AND A.LINE_ID       = F.LINE_ID(+)
               AND A.ITEM_ID       = F.ITEM_ID(+)
               AND A.SCM_SITE_ID   = FG.SCM_SITE_ID(+)
               AND A.LINE_ID       = FG.LINE_ID(+)
               AND A.ITEM_ID       = FG.ITEM_ID(+)
               AND A.SCM_SITE_ID   = FW.SCM_SITE_ID(+)
               AND A.LINE_ID       = FW.LINE_ID(+)
               AND A.ITEM_ID       = FW.ITEM_ID(+)
               AND A.MEASURE       = 'PROD_PLAN_ENGINE';

        END IF;

        /* 1.1 Base Row Key Find */
        IF P_PLAN_START_YYYYMMDD >= V_MIN_YYYYMMDD THEN

            INSERT INTO GT_0013_KEY
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,OPERATION_ID
                  ,MEASURE
                  ,SCM_SITE_ID2
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                 )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.MEASURE
                 , CASE
                       WHEN SUBSTR(A.SCM_SITE_ID, -2) = '-S'
                       THEN SUBSTR(A.SCM_SITE_ID, 1, LENGTH(RTRIM(A.SCM_SITE_ID)) - 2)
                       ELSE A.SCM_SITE_ID
                   END
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , B.CELL_TYPE_GROUP_CODE
              FROM SCP_ANL_PRODUCTION_PLAN  A
                 , SCP_MST_FINAL_ITEM       B
             WHERE 1 = 1
               AND A.DIVISION_ID     = B.DIVISION_ID(+)
               AND A.ITEM_ID         = B.ITEM_ID(+)
               AND A.OPERATION_GROUP = B.OPERATION_GROUP(+)
               AND A.YYYYMMDD        = P_PLAN_START_YYYYMMDD
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    /* 파티션 프루닝 */
               AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND A.PLAN_TYPE       = P_PLAN_TYPE
               AND A.SEQ             = P_SEQ
               AND A.LINE_ID        != '*'
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
               AND (   P_CELL_TYPE_GR IS NULL
                    OR B.CELL_TYPE_GROUP_CODE IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_CELL_TYPE_GR, ','))));

        ELSE

            INSERT INTO GT_0013_KEY
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,LINE_ID
                  ,OPERATION_ID
                  ,MEASURE
                  ,SCM_SITE_ID2
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                 )
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , A.MEASURE
                 , CASE
                       WHEN SUBSTR(A.SCM_SITE_ID, -2) = '-S'
                       THEN SUBSTR(A.SCM_SITE_ID, 1, LENGTH(RTRIM(A.SCM_SITE_ID)) - 2)
                       ELSE A.SCM_SITE_ID
                   END
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , B.CELL_TYPE_GROUP_CODE
              FROM HIST_SCP_ANL_PRODUCTION_PLAN  A
                 , SCP_MST_FINAL_ITEM            B
             WHERE 1 = 1
               AND A.DIVISION_ID     = B.DIVISION_ID(+)
               AND A.ITEM_ID         = B.ITEM_ID(+)
               AND A.OPERATION_GROUP = B.OPERATION_GROUP(+)
               AND A.YYYYMMDD        = P_PLAN_START_YYYYMMDD
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    /* 파티션 프루닝 */
               AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND A.PLAN_TYPE       = P_PLAN_TYPE
               AND A.SEQ             = P_SEQ
               AND A.LINE_ID        != '*'
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
               AND (   P_CELL_TYPE_GR IS NULL
                    OR B.CELL_TYPE_GROUP_CODE IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(P_CELL_TYPE_GR, ','))));

        END IF;

        /* 1.2 Key Row Insert */
        INSERT INTO GT_0013_TMP
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,CELL_QTY
              ,SCM_SITE_ID2
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CELL_TYPE_GROUP_CODE
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.MEASURE
             , O.BASIS_YYYYMMDD                                     AS YYYYMMDD
             , 0                                                    AS QTY
             , 0                                                    AS CELL_QTY
             , A.SCM_SITE_ID2
             , A.ORIGIN_DIVISION_ID
             , A.ELECTRODE_TYPE
             , A.CELL_TYPE_GROUP_CODE
          FROM GT_0013_KEY          A
             , SCM_SYS_CALENDAR_M   O
         WHERE 1 = 1
           AND O.BASIS_YYYYMMDD = V_TO_YYYYMMDD
           AND V_RESULT_ONLY    = 'N'
           AND NOT EXISTS (SELECT 1
                             FROM GT_0013_TMP B
                            WHERE B.SCM_SITE_ID  = A.SCM_SITE_ID
                              AND B.ITEM_ID      = A.ITEM_ID
                              AND B.LINE_ID      = A.LINE_ID
                              AND B.OPERATION_ID = A.OPERATION_ID
                              AND B.MEASURE      = A.MEASURE
                              AND B.YYYYMMDD     = O.BASIS_YYYYMMDD);

        DELETE GT_0013_KEY;

        /* 2. Working Time Base */
        INSERT INTO GT_0013_WORKING_DATA
             (
               DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,YYYYMMDD
              ,WORKING_TIME
             )
        SELECT DIVISION_ID
             , PLANT_SITE_ID                                        AS SCM_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
--        FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(P_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD, P_LINE_ID));
          FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS(P_DIVISION_ID, V_FROM_YYYYMMDD, V_TO_YYYYMMDD, P_LINE_ID)) W   /* AJS 20261007 속도 */
         WHERE (W.DIVISION_ID, W.OPERATION_ID, W.PLANT_SITE_ID, W.LINE_ID, W.YYYYMMDD)   /* AJS 20261007 속도 */
               IN (SELECT XA.ORIGIN_DIVISION_ID   /* AJS 20261007 속도 */
                        , XA.OPERATION_ID   /* AJS 20261007 속도 */
                        , XA.SCM_SITE_ID2   /* AJS 20261007 속도 */
                        , XA.LINE_ID   /* AJS 20261007 속도 */
                        , XA.YYYYMMDD   /* AJS 20261007 속도 */
                     FROM GT_0013_TMP XA);   /* AJS 20261007 속도 */

        /* 3. Line Load Base - LINE 로드율 추출 */
        INSERT INTO GT_0013_LOAD
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,OPERATION_ID
              ,LINE_ID
              ,MEASURE
              ,QTY
              ,CAPA_TACT
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CELL_TYPE_GROUP_CODE
             )
            /* LINE_TOTAL_LOAD_AMEND 추가 */
        SELECT DISTINCT
               A.DIVISION_ID
             , P_PLAN_START_YYYYMMDD                                AS PLAN_START_YYYYMMDD
             , P_PLAN_TYPE                                          AS PLAN_TYPE
             , P_SEQ                                                AS PLAN_SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , '/'                                                  AS ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , 'LINE_TOTAL_LOAD_AMEND'                              AS MEASURE
             , CASE
                   WHEN D.WORKING_TIME <= 0.0
                   THEN 0
                   ELSE NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / NULLIF(D.WORKING_TIME, 0), 0) * 100
               END                                                  AS QTY
             , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)    AS CAPA_TACT
             , P_FROM_YYYYMMDD                                      AS FROM_YYYYMMDD
             , 'D_'||A.YYYYMMDD                                     AS YYYYMMDD
             , NVL(NULLIF(RTRIM(A.ORIGIN_DIVISION_ID),''), '/')                       AS ORIGIN_DIVISION_ID
             , '/'                                                  AS ELECTRODE_TYPE
             , 'L'                                                  AS CELL_TYPE_GROUP_CODE
          FROM GT_0013_TMP              A
             , GT_0013_WORKING_DATA     D
             , SCP_ANL_TACT_TIME        E
         WHERE 1 = 1
           AND A.ORIGIN_DIVISION_ID = D.DIVISION_ID(+)
           AND A.OPERATION_ID       = D.OPERATION_ID(+)
           AND A.SCM_SITE_ID2       = D.SCM_SITE_ID(+)
           AND A.LINE_ID            = D.LINE_ID(+)
           AND A.YYYYMMDD           = D.YYYYMMDD(+)
           AND A.ORIGIN_DIVISION_ID = E.DIVISION_ID(+)
           AND A.OPERATION_ID       = E.OPERATION_ID(+)
           AND A.SCM_SITE_ID2       = E.SCM_SITE_ID(+)
           AND A.LINE_ID            = E.LINE_ID(+)
           AND A.ITEM_ID            = E.ITEM_ID(+)
           AND A.YYYYMMDD           = E.YYYYMMDD(+)
           AND A.LINE_ID           != '*'
           AND A.MEASURE            = UPPER('PROD_PLAN_AMEND')
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , D.WORKING_TIME
                , A.ORIGIN_DIVISION_ID
         UNION
            /* LINE_TOTAL_LOAD_ENGINE 추가 */
        SELECT DISTINCT
               A.DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , '/'
             , A.OPERATION_ID
             , A.LINE_ID
             , 'LINE_TOTAL_LOAD_ENGINE'
             , CASE
                   WHEN D.WORKING_TIME <= 0.0
                   THEN 0
                   ELSE NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / NULLIF(D.WORKING_TIME, 0), 0) * 100
               END
             , NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0), 0)
             , P_FROM_YYYYMMDD
             , 'D_'||A.YYYYMMDD
             , NVL(NULLIF(RTRIM(A.ORIGIN_DIVISION_ID),''), '/')
             , '/'
             , 'L'
          FROM GT_0013_TMP              A
             , SCP_ANL_WORKING_TIME     D
             , SCP_ANL_TACT_TIME        E
         WHERE 1 = 1
           AND A.ORIGIN_DIVISION_ID = D.DIVISION_ID(+)
           AND A.OPERATION_ID       = D.OPERATION_ID(+)
           AND A.SCM_SITE_ID2       = D.SCM_SITE_ID(+)
           AND A.LINE_ID            = D.LINE_ID(+)
           AND A.YYYYMMDD           = D.YYYYMMDD(+)
           AND A.ORIGIN_DIVISION_ID = E.DIVISION_ID(+)
           AND A.OPERATION_ID       = E.OPERATION_ID(+)
           AND A.SCM_SITE_ID2       = E.SCM_SITE_ID(+)
           AND A.LINE_ID            = E.LINE_ID(+)
           AND A.ITEM_ID            = E.ITEM_ID(+)
           AND A.YYYYMMDD           = E.YYYYMMDD(+)
           AND A.LINE_ID           != '*'
           AND A.MEASURE            = UPPER('PROD_PLAN_ENGINE')
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , D.WORKING_TIME
                , A.ORIGIN_DIVISION_ID;

--      /* 2022.08.31 Isuzu Item */
--      INSERT INTO GT_0013_ISUZU
--           (
--             ITEM_ID
--           )
--      SELECT A.ITEM_ID
--        FROM SCM_MST_FINAL_ITEM_V     A
--           , SCP_MST_FINAL_ITEM_V     B
--       WHERE 1 = 1
--         AND A.ITEM_ID = B.ITEM_ID
--         AND A.IS_YN   = 'Y';   /* AJS 20261007 속도 */

        /* 4. Prod Performance - 생산실적 추출 */
        IF V_FROM_YYYYMMDD > V_FROM_RESULT THEN
            /* 실적 보여줌 */

            /* 2022.08.31 Isuzu Item - 실적 구간 분기에서만 쓰므로 분기 안에서 적재 */   /* AJS 20261007 속도 */
            INSERT INTO GT_0013_ISUZU   /* AJS 20261007 속도 */
                 (   /* AJS 20261007 속도 */
                   ITEM_ID   /* AJS 20261007 속도 */
                 )   /* AJS 20261007 속도 */
            SELECT A.ITEM_ID   /* AJS 20261007 속도 */
              FROM SCM_MST_FINAL_ITEM_V     A   /* AJS 20261007 속도 */
                 , SCP_MST_FINAL_ITEM_V     B   /* AJS 20261007 속도 */
             WHERE 1 = 1   /* AJS 20261007 속도 */
               AND A.ITEM_ID = B.ITEM_ID   /* AJS 20261007 속도 */
               AND A.IS_YN   = 'Y';   /* AJS 20261007 속도 */

            INSERT INTO GT_0013_PERFOR
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,PLAN_SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,QTY
                  ,FROM_YYYYMMDD
                  ,YYYYMMDD
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                  ,LINE_ASSIGN_KEY
                 )
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.PLAN_SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.QTY
                 , A.FROM_YYYYMMDD
                 , A.YYYYMMDD
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.CELL_TYPE_GROUP_CODE
                 , A.LINE_ASSIGN_KEY
              FROM (SELECT /* 20260126 E20260123-001747 YMH 하드코딩 제거를 위한 로직 추가 */
                           P_DIVISION_ID                            AS DIVISION_ID
                         , P_PLAN_START_YYYYMMDD                    AS PLAN_START_YYYYMMDD
                         , P_PLAN_TYPE                              AS PLAN_TYPE
                         , P_SEQ                                    AS PLAN_SEQ
                         , R.SCP_OPERATION_GROUP                    AS OPERATION_GROUP
                         , R.SCM_SITE_ID
                         , R.ITEM_ID
                         , R.OPERATION_ID
                         , CASE
                               WHEN     R.DIVISION_ID         = '40'
                                    AND R.SCP_OPERATION_GROUP = 'A'
                                    AND (   SUBSTR(R.ITEM_ID, 2, 1) = 'T'
                                         OR SUBSTR(R.ITEM_ID, 2, 1) = 'I'
                                         OR SUBSTR(R.ITEM_ID, 2, 1) = 'D')
                               THEN '-'
                               ELSE R.LINE_ID
                           END                                      AS LINE_ID
                         , 'PROD_PLAN_ENGINE'                       AS MEASURE
                         , NVL(SUM(R.ACTUAL_GOOD_QTY), 0)           AS QTY
                         , P_FROM_YYYYMMDD                          AS FROM_YYYYMMDD
                         , 'D_'||TO_CHAR(R.PLAN_DATE, 'YYYYMMDD')   AS YYYYMMDD
                         , R.DIVISION_ID                            AS ORIGIN_DIVISION_ID
                         , NVL(R.ELECTRODE_TYPE, '-')               AS ELECTRODE_TYPE
                         , B.CELL_TYPE_GROUP_CODE
                         , NULL                                     AS LINE_ASSIGN_KEY
                      FROM SCM_DNM_PRODUCT_RESULT_V R
                         , SCP_MST_FINAL_ITEM       B
                     WHERE 1 = 1
                       AND R.DIVISION_ID         = B.DIVISION_ID(+)
                       AND R.ITEM_ID             = B.ITEM_ID(+)
                       AND R.SCP_OPERATION_GROUP = B.OPERATION_GROUP(+)
                       AND R.PLAN_DATE          >= TO_DATE(V_FROM_RESULT, 'YYYYMMDD')
                       AND R.PLAN_DATE          <  TO_DATE(V_TO_RESULT, 'YYYYMMDD')
                            /* div_commonization */
                       AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                            OR R.DIVISION_ID  = P_DIVISION_ID)
                       AND R.COMPANY_ID         IN (SELECT DISTINCT
                                                           IA.COMPANY_ID
                                                      FROM SCM_MST_SITE IA
                                                     WHERE 1 = 1
                                                       AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                                                                   FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                                                            OR IA.DIVISION_ID = P_DIVISION_ID)
                                                       AND IA.SITE_TYPE = 'PLANT'
                                                       AND IA.VALID_YN  = 'Y')
                       AND R.SCP_OPERATION_GROUP = P_OPERATION_GROUP
                       AND (      /* LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회 */
                               SUBSTR(R.OPERATION_ID, 1, 5) IN (SELECT XA.SEGMENT1
                                                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                                                 WHERE XA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                                   AND XA.SEGMENT1   != 'F6000'
                                                                   AND XA.VALID_YN    = 'Y')
                                 /* 2022.08.31 start */
                            OR (    SUBSTR(R.OPERATION_ID, 1, 5) = 'P5000'
                                AND EXISTS (SELECT 1
                                              FROM GT_0013_ISUZU SA
                                             WHERE SA.ITEM_ID = R.ITEM_ID))
                                 /* 2022.08.31 end */
                                 /* 외주PACKER의 업체코드 */
                            OR R.OPERATION_ID IN (SELECT XB.PLANT_ID
                                                    FROM SCM_MST_SITE XB
                                                   WHERE 1 = 1
                                                     AND (   P_DIVISION_ID IN (SELECT DIVISION_ID
                                                                                 FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                                                          OR XB.DIVISION_ID = P_DIVISION_ID)
                                                     AND XB.SITE_TYPE = 'PLANT'
                                                     AND XB.OSP_YN    = 'Y'
                                                     AND XB.VALID_YN  = 'Y'))
                       AND (   P_SCM_SITE_ID IS NULL
                            OR R.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                                   FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
                       AND (   P_ELECTRODE_TYPE IS NULL
                            OR R.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))))
                     GROUP BY R.SCP_OPERATION_GROUP
                            , R.SCM_SITE_ID
                            , R.ITEM_ID
                            , R.OPERATION_ID
                            , CASE
                                  WHEN     R.DIVISION_ID         = '40'
                                       AND R.SCP_OPERATION_GROUP = 'A'
                                       AND (   SUBSTR(R.ITEM_ID, 2, 1) = 'T'
                                            OR SUBSTR(R.ITEM_ID, 2, 1) = 'I'
                                            OR SUBSTR(R.ITEM_ID, 2, 1) = 'D')
                                  THEN '-'
                                  ELSE R.LINE_ID
                              END
                            , 'D_'||TO_CHAR(R.PLAN_DATE, 'YYYYMMDD')
                            , R.DIVISION_ID
                            , NVL(R.ELECTRODE_TYPE, '-')
                            , B.CELL_TYPE_GROUP_CODE) A
             WHERE 1 = 1
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
                    /* div_commonization */
               AND A.ORIGIN_DIVISION_ID IN (SELECT IA.DIVISION_ID
                                              FROM SCM_MST_DIVISION IA
                                             WHERE IA.ATTRIBUTE4 IN (SELECT XA.ATTRIBUTE4
                                                                       FROM SCM_MST_DIVISION XA
                                                                      WHERE XA.DIVISION_ID = P_DIVISION_ID)
                                               AND IA.ATTRIBUTE3 != 'EE');

            /* E20260226-001691 YMH 82 Div Virtual Plant 실적 구간 데이터 조회 기능 */
            /* ESS 혼용생산 로직 처리를 위해 혼용생산 실적 정보 임시테이블 추가. */
            INSERT INTO GT_0013_PERFOR_ESS_JV
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,PLAN_SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,QTY
                  ,FROM_YYYYMMDD
                  ,YYYYMMDD
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                  ,LINE_ASSIGN_KEY
                 )
            SELECT R.DIVISION_ID
                 , P_PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE
                 , P_SEQ
                 , R.SCP_OPERATION_GROUP
                 , R.SCM_SITE_ID
                 , R.ITEM_ID
                 , R.OPERATION_ID
                 , CASE
                       WHEN     R.DIVISION_ID         = '40'
                            AND R.SCP_OPERATION_GROUP = 'A'
                            AND (   SUBSTR(R.ITEM_ID, 2, 1) = 'T'
                                 OR SUBSTR(R.ITEM_ID, 2, 1) = 'I'
                                 OR SUBSTR(R.ITEM_ID, 2, 1) = 'D')
                       THEN '-'
                       ELSE R.LINE_ID
                   END
                 , 'PROD_PLAN_ENGINE'
                 , NVL(SUM(R.ACTUAL_GOOD_QTY), 0)
                 , P_FROM_YYYYMMDD
                 , 'D_'||TO_CHAR(R.PLAN_DATE, 'YYYYMMDD')
                 , R.DIVISION_ID
                 , NVL(NULLIF(RTRIM(R.ELECTRODE_TYPE),''), '/')
                 , B.CELL_TYPE_GROUP_CODE
                 , NULL
              FROM SCM_DNM_PRODUCT_RESULT_V R
                 , SCP_MST_FINAL_ITEM       B
             WHERE 1 = 1
               AND R.DIVISION_ID         = B.DIVISION_ID(+)
               AND R.ITEM_ID             = B.ITEM_ID(+)
               AND R.SCP_OPERATION_GROUP = B.OPERATION_GROUP(+)
               AND R.PLAN_DATE          >= TO_DATE(V_FROM_RESULT, 'YYYYMMDD')
               AND R.PLAN_DATE          <  TO_DATE(V_TO_RESULT, 'YYYYMMDD')
               AND EXISTS (SELECT 1
                             FROM GT_0013_JV_ESS_MAP SA
                            WHERE SA.LINK_DIVISION_ID = R.DIVISION_ID
                              AND SA.LINK_COMPANY_ID  = R.COMPANY_ID
                              AND SA.LINK_PLANT_ID    = R.PLANT_ID
                              AND SA.LINK_SCM_SITE_ID = R.SCM_SITE_ID
                                   /* E20260415-000894 타 DIVISION에서 ESS 실적 안나오게 수정. */
                              AND SA.DIVISION_ID      = P_DIVISION_ID)
               AND R.SCP_OPERATION_GROUP = P_OPERATION_GROUP
               AND (   SUBSTR(R.OPERATION_ID, 1, 5) IN (SELECT XA.SEGMENT1
                                                          FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                                                         WHERE XA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                           AND XA.SEGMENT1   != 'F6000'
                                                           AND XA.VALID_YN    = 'Y')
                    OR (    SUBSTR(R.OPERATION_ID, 1, 5) = 'P5000'
                        AND EXISTS (SELECT 1
                                      FROM GT_0013_ISUZU SB
                                     WHERE SB.ITEM_ID = R.ITEM_ID))
                    OR R.OPERATION_ID IN (SELECT XB.PLANT_ID
                                            FROM SCM_MST_SITE XB
                                           WHERE 1 = 1
                                             AND (   P_DIVISION_ID IN (SELECT COLUMN_VALUE
                                                                         FROM TABLE(FN_GET_DIVISION_DIV('EE')))
                                                  OR XB.DIVISION_ID = P_DIVISION_ID)
                                             AND XB.SITE_TYPE = 'PLANT'
                                             AND XB.OSP_YN    = 'Y'
                                             AND XB.VALID_YN  = 'Y'))
               AND (   P_ELECTRODE_TYPE IS NULL
                    OR R.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))))
             GROUP BY R.SCP_OPERATION_GROUP
                    , R.SCM_SITE_ID
                    , R.ITEM_ID
                    , R.OPERATION_ID
                    , CASE
                          WHEN     R.DIVISION_ID         = '40'
                               AND R.SCP_OPERATION_GROUP = 'A'
                               AND (   SUBSTR(R.ITEM_ID, 2, 1) = 'T'
                                    OR SUBSTR(R.ITEM_ID, 2, 1) = 'I'
                                    OR SUBSTR(R.ITEM_ID, 2, 1) = 'D')
                          THEN '-'
                          ELSE R.LINE_ID
                      END
                    , 'D_'||TO_CHAR(R.PLAN_DATE, 'YYYYMMDD')
                    , R.DIVISION_ID
                    , NVL(NULLIF(RTRIM(R.ELECTRODE_TYPE),''), '/') /* [E20261009-GRPBYFIX] GROUP BY 식 = SELECT 식 */
                    , B.CELL_TYPE_GROUP_CODE;

            /* 화면에 보이는 가상라인으로 JV혼용실적임시테이블 데이터 업데이트. */
            UPDATE GT_0013_PERFOR_ESS_JV A
               SET (A.DIVISION_ID
                   ,A.SCM_SITE_ID
                   ,A.ORIGIN_DIVISION_ID
                   ,A.LINE_ID) = (SELECT B.DIVISION_ID
                                       , B.SCM_SITE_ID
                                       , B.DIVISION_ID
                                       , B.LINE_ID
                                    FROM GT_0013_JV_ESS_MAP B
                                   WHERE B.LINK_DIVISION_ID  = A.DIVISION_ID
                                     AND B.LINK_SCM_SITE_ID  = A.SCM_SITE_ID
                                     AND B.LINK_LINE_ID      = A.LINE_ID
                                     AND ROWNUM = 1)
             WHERE EXISTS (SELECT 1
                             FROM GT_0013_JV_ESS_MAP B
                            WHERE B.LINK_DIVISION_ID = A.DIVISION_ID
                              AND B.LINK_SCM_SITE_ID = A.SCM_SITE_ID
                              AND B.LINK_LINE_ID     = A.LINE_ID);

            INSERT INTO GT_0013_PERFOR
                 (
                   DIVISION_ID
                  ,PLAN_START_YYYYMMDD
                  ,PLAN_TYPE
                  ,PLAN_SEQ
                  ,OPERATION_GROUP
                  ,SCM_SITE_ID
                  ,ITEM_ID
                  ,OPERATION_ID
                  ,LINE_ID
                  ,MEASURE
                  ,QTY
                  ,FROM_YYYYMMDD
                  ,YYYYMMDD
                  ,ORIGIN_DIVISION_ID
                  ,ELECTRODE_TYPE
                  ,CELL_TYPE_GROUP_CODE
                  ,LINE_ASSIGN_KEY
                 )
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.PLAN_SEQ
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.OPERATION_ID
                 , A.LINE_ID
                 , A.MEASURE
                 , A.QTY
                 , A.FROM_YYYYMMDD
                 , A.YYYYMMDD
                 , A.ORIGIN_DIVISION_ID
                 , A.ELECTRODE_TYPE
                 , A.CELL_TYPE_GROUP_CODE
                 , A.LINE_ASSIGN_KEY
              FROM GT_0013_PERFOR_ESS_JV A
             WHERE 1 = 1
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
                    /* E20260415-000894 scm_site_id 변경후 조회 */
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
                    /* E20260415-000894 타 DIVISION에서 ESS 실적 안나오게 수정. */
               AND A.DIVISION_ID = P_DIVISION_ID;

            DELETE GT_0013_ISUZU;

        END IF;

        /* 4.1 Prod Plan - 생산계획 추출 */
        INSERT INTO GT_0013_PLAN
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,OPERATION_ID
              ,LINE_ID
              ,MEASURE
              ,QTY
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CELL_TYPE_GROUP_CODE
              ,LINE_ASSIGN_KEY
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.MEASURE
             , A.QTY
             , P_FROM_YYYYMMDD
             , 'D_'||A.YYYYMMDD
             , NVL(NULLIF(RTRIM(A.ORIGIN_DIVISION_ID),''), '/')
             , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')
             , A.CELL_TYPE_GROUP_CODE
             , NULL
          FROM GT_0013_TMP              A
             , SCM_MST_SHEET_MEASURE    B
         WHERE 1 = 1
           AND A.MEASURE     = B.COLUMN_NAME
           AND B.PROGRAM_ID  = P_PROGRAM_ID
           AND B.SHEET_NAME  = P_SHEET_NAME
           AND B.VALID_YN    = 'Y'
           AND A.MEASURE    IN ('PROD_PLAN_AMEND', 'PROD_PLAN_ENGINE', 'ELEC_RTF', 'PROD_PLAN_ENGINE_STD_JR')
           AND (   P_OPERATION_GROUP = 'A'
                OR NVL(B.ATTRIBUTE1, '-') != 'A')
           AND (   P_ELECTRODE_TYPE IS NULL
                OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                          FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))));

        /********************************************************************************
        * 5. OutDataSet - 데이타조회, 임시테이블에 저장
        ********************************************************************************/
        INSERT INTO GT_0013_PIVOT
             (
               CP_KEY
              ,FIX_KEY
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,PARENT_ITEM_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,ITEM_ID
              ,MEASURE
              ,MEASURE_NAME
              ,SORT_ORDER_NO
              ,QTY
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,YYYYMM
              ,ISO_WEEK
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CELL_TYPE_GROUP_CODE
              ,UNIT
             )
        SELECT T.DIVISION_ID||T.SCM_SITE_ID||T.PLAN_START_YYYYMMDD||T.PLAN_TYPE||T.PLAN_SEQ   AS CP_KEY
             , T.DIVISION_ID||T.OPERATION_GROUP||T.SCM_SITE_ID||T.ITEM_ID||T.LINE_ID||T.OPERATION_ID||T.ORIGIN_DIVISION_ID||T.ELECTRODE_TYPE  AS FIX_KEY
             , T.DIVISION_ID
             , T.PLAN_START_YYYYMMDD
             , T.PLAN_TYPE
             , T.PLAN_SEQ
        ------------------------------------------------------------------------------------------------------------
        /* Start  : PJ20257329 2025.09.01 SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용 */
        /*          UI에서 많은 양의 데이터를 조회하지 않기 때문에 기존 스칼라 서브 쿼리 형태 유지     */
        ------------------------------------------------------------------------------------------------------------
             , (SELECT PARENT_ITEM_ID
                  FROM (SELECT CASE
                                   WHEN    BOM.PARENT_ITEM_ID = '*'
                                        OR CM.SCP_EXC_YN      = 'Y'
                                   THEN BOM.MODEL_ID
                                   ELSE BOM.PARENT_ITEM_ID
                               END                                  AS PARENT_ITEM_ID
                          FROM SCM_MST_BOM_SN           BOM
                             , SCM_MST_ITEM_SN          MM      /* model */
                             , SCM_MST_ITEM_SN          IM      /* parent가 '*'인 경우가 있음 */
                             , SCM_MST_ITEM_CLASS_M     CM      /* parent item class */
                         WHERE 1 = 1
                           AND MM.COMPANY_ID     = BOM.COMPANY_ID
                           AND MM.DIVISION_ID    = BOM.DIVISION_ID
                           AND MM.SITE_ID        = BOM.SITE_ID
                           AND MM.ITEM_ID        = BOM.MODEL_ID
                           AND IM.COMPANY_ID(+)  = BOM.COMPANY_ID
                           AND IM.DIVISION_ID(+) = BOM.DIVISION_ID
                           AND IM.SITE_ID(+)     = BOM.SITE_ID
                           AND IM.ITEM_ID(+)     = BOM.PARENT_ITEM_ID
                           AND CM.CLASS_ID(+)    = IM.ITEM_CLASS
                           AND BOM.CHILD_ITEM_ID = T.ITEM_ID
                         ORDER BY CASE
                                      WHEN MM.SCP_OPERATION_GROUP = 'E' THEN 1
                                      WHEN MM.SCP_OPERATION_GROUP = 'A' THEN 2
                                      ELSE 9
                                  END)
                 WHERE ROWNUM = 1)                                  AS PARENT_ITEM_ID
        ------------------------------------------------------------------------------------------------------------
        /* End  : PJ20257329 2025.09.01 SCP Exclude class Parent 품목 정보를 Model로 대체 조회 적용 */
        ------------------------------------------------------------------------------------------------------------
             , T.OPERATION_GROUP
             , T.SCM_SITE_ID
             , T.OPERATION_ID
             , T.LINE_ID
             , T.ITEM_ID
             , T.MEASURE
             , M.COLUMN_LABEL_NAME                                  AS MEASURE_NAME
             , NVL(N.SORT_ORDER_NO, M.SORT_ORDER_NO)                AS SORT_ORDER_NO
             , T.QTY
             , T.FROM_YYYYMMDD
             , T.YYYYMMDD
             , C.BASIS_YYYYMM                                       AS YYYYMM
             , SUBSTR(C.BASIS_YYYYMM, -4)||C.ISO_WEEK               AS ISO_WEEK
             , T.ORIGIN_DIVISION_ID
             , T.ELECTRODE_TYPE
             , T.CELL_TYPE_GROUP_CODE
             , CASE X.ITEM_UOM
                   WHEN 'EA'
                   THEN CASE T.MEASURE
                            WHEN 'PROD_PLAN_AMEND'              THEN 'EA'
                            WHEN 'PROD_PLAN_ENGINE'             THEN 'EA'
                            WHEN 'PROD_PLAN_ENGINE_CELL_QTY'    THEN 'EA'
                            WHEN 'PROD_PLAN_ENGINE_STD_JR'      THEN 'M'
                            ELSE NULL
                        END
                   WHEN 'M'
                   THEN CASE T.MEASURE
                            WHEN 'PROD_PLAN_AMEND'              THEN 'M'
                            WHEN 'PROD_PLAN_ENGINE'             THEN 'M'
                            WHEN 'PROD_PLAN_ENGINE_CELL_QTY'    THEN 'EA'
                            WHEN 'PROD_PLAN_ENGINE_STD_JR'      THEN 'M'
                            ELSE NULL
                        END
                   ELSE X.ITEM_UOM
               END                                                  AS UNIT
          FROM (   /* 생산계획 */
                SELECT DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , PLAN_SEQ
                     , OPERATION_GROUP
                     , SCM_SITE_ID
                     , ITEM_ID
                     , OPERATION_ID
                     , LINE_ID
                     , MEASURE
                     , QTY
                     , FROM_YYYYMMDD
                     , YYYYMMDD
                     , ORIGIN_DIVISION_ID
                     , ELECTRODE_TYPE
                     , CELL_TYPE_GROUP_CODE
                     , LINE_ASSIGN_KEY
                  FROM GT_0013_PLAN
                 UNION
                    /* CELL 환산수량 */
                SELECT DISTINCT
                       A.DIVISION_ID
                     , P_PLAN_START_YYYYMMDD
                     , P_PLAN_TYPE
                     , P_SEQ
                     , A.OPERATION_GROUP
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , 'PROD_PLAN_ENGINE_CELL_QTY'
                     , A.CELL_QTY
                     , P_FROM_YYYYMMDD
                     , 'D_'||A.YYYYMMDD
                     , NVL(A.ORIGIN_DIVISION_ID, '/')
                     , NVL(A.ELECTRODE_TYPE, '/')
                     , A.CELL_TYPE_GROUP_CODE
                     , NULL
                  FROM GT_0013_TMP              A
                     , SCM_MST_SHEET_MEASURE    B
                 WHERE 1 = 1
                   AND A.MEASURE     = B.COLUMN_NAME
                   AND B.PROGRAM_ID  = P_PROGRAM_ID
                   AND B.SHEET_NAME  = P_SHEET_NAME
                   AND B.VALID_YN    = 'Y'
                   AND A.MEASURE     = 'PROD_PLAN_ENGINE'
                   AND (   P_OPERATION_GROUP = 'A'
                        OR NVL(B.ATTRIBUTE1, '-') != 'A')
                   AND (   P_ELECTRODE_TYPE IS NULL
                        OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                                  FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))))
                   AND P_OPERATION_GROUP = 'E'
                 UNION
                    /* 생산 실적 (PROD_PLAN_ENGINE) */
                SELECT DIVISION_ID
                     , PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , PLAN_SEQ
                     , OPERATION_GROUP
                     , SCM_SITE_ID
                     , ITEM_ID
                     , OPERATION_ID
                     , LINE_ID
                     , 'PROD_PLAN_ENGINE'
                     , QTY
                     , FROM_YYYYMMDD
                     , YYYYMMDD
                     , ORIGIN_DIVISION_ID
                     , ELECTRODE_TYPE
                     , CELL_TYPE_GROUP_CODE
                     , LINE_ASSIGN_KEY
                  FROM GT_0013_PERFOR
                 UNION
                    /* 생산 실적 (PROD_PLAN_ENGINE_CELL_QTY) 셀 환산수량 */
                SELECT A.DIVISION_ID
                     , A.PLAN_START_YYYYMMDD
                     , A.PLAN_TYPE
                     , A.PLAN_SEQ
                     , A.OPERATION_GROUP
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , 'PROD_PLAN_ENGINE_CELL_QTY'
                     , NVL(A.QTY, 0.00) * (SELECT NVL(MIN(Y.CONVERT_QTY_CELL), 1)
                                             FROM SCP_MST_FINAL_ITEM Y
                                            WHERE Y.ITEM_ID = A.ITEM_ID
                                              AND Y.CONVERT_QTY_CELL IS NOT NULL)
                     , A.FROM_YYYYMMDD
                     , A.YYYYMMDD
                     , A.ORIGIN_DIVISION_ID
                     , A.ELECTRODE_TYPE
                     , A.CELL_TYPE_GROUP_CODE
                     , A.LINE_ASSIGN_KEY
                  FROM GT_0013_PERFOR A
                 WHERE P_OPERATION_GROUP = 'E'
                 UNION
                    /* 생산 실적 (PROD_PLAN_AMEND) */
                SELECT A.DIVISION_ID
                     , A.PLAN_START_YYYYMMDD
                     , A.PLAN_TYPE
                     , A.PLAN_SEQ
                     , A.OPERATION_GROUP
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , 'PROD_PLAN_AMEND'
                     , A.QTY
                     , A.FROM_YYYYMMDD
                     , A.YYYYMMDD
                     , A.ORIGIN_DIVISION_ID
                     , A.ELECTRODE_TYPE
                     , A.CELL_TYPE_GROUP_CODE
                     , A.LINE_ASSIGN_KEY
                  FROM GT_0013_PERFOR A
                 UNION
                    /* 라인 부하율 */
                SELECT A.DIVISION_ID
                     , A.PLAN_START_YYYYMMDD
                     , A.PLAN_TYPE
                     , A.PLAN_SEQ
                     , A.OPERATION_GROUP
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , A.MEASURE
                     , A.QTY
                     , A.FROM_YYYYMMDD
                     , A.YYYYMMDD
                     , A.ORIGIN_DIVISION_ID
                     , A.ELECTRODE_TYPE
                     , A.CELL_TYPE_GROUP_CODE
                     , A.SCM_SITE_ID||A.LINE_ID||A.OPERATION_ID     AS LINE_ASSIGN_KEY
                  FROM GT_0013_LOAD A) T
             , SCM_SYS_CALENDAR_M       C
             , SCM_MST_SHEET_MEASURE    M
             , SCM_MST_TITLESET_USER    N
--           , (SELECT DISTINCT
             , (SELECT /*+ LEADING(XA IA) USE_NL(IA) INDEX(IA PK_SCM_ITEM_M) */ DISTINCT   /* AJS 20261007 속도 */
                       IA.ITEM_ID
                     , IA.ITEM_UOM
                     , MIN(IA.DIVISION_ID)                          AS DIVISION_ID
--                FROM SCM_MST_ITEM_SN IA
                  FROM (SELECT XB.ITEM_ID FROM GT_0013_PLAN   XB   /* AJS 20261007 속도 */
                        UNION   /* AJS 20261007 속도 */
                        SELECT XC.ITEM_ID FROM GT_0013_TMP    XC   /* AJS 20261007 속도 */
                        UNION   /* AJS 20261007 속도 */
                        SELECT XD.ITEM_ID FROM GT_0013_PERFOR XD   /* AJS 20261007 속도 */
                        UNION   /* AJS 20261007 속도 */
                        SELECT XE.ITEM_ID FROM GT_0013_LOAD   XE) XA   /* AJS 20261007 속도 */
                     , SCM_MST_ITEM_SN IA   /* AJS 20261007 속도 */
                 WHERE 1 = 1
                   AND IA.ITEM_ID = XA.ITEM_ID   /* AJS 20261007 속도 */
                 GROUP BY IA.ITEM_ID, IA.ITEM_UOM) X
         WHERE 1 = 1
           AND SUBSTR(T.YYYYMMDD, -8) = C.BASIS_YYYYMMDD
           AND T.MEASURE       = M.COLUMN_NAME(+)
           AND N.PROGRAM_ID(+) = M.PROGRAM_ID
           AND N.SHEET_NAME(+) = M.SHEET_NAME
           AND N.COLUMN_NAME(+)= M.COLUMN_NAME
           AND N.USER_ID(+)    = P_USER_ID
           AND T.ITEM_ID       = X.ITEM_ID(+)
           AND M.VALID_YN      = 'Y'
           AND M.PROGRAM_ID    = P_PROGRAM_ID
           AND M.SHEET_NAME    = P_SHEET_NAME
           AND (   P_OPERATION_GROUP = 'A'
                OR NVL(M.ATTRIBUTE1, '-') != 'A')
           AND (   V_CNT_USR_MEASURE = 0
                OR EXISTS (SELECT 1
                             FROM SCM_MST_TITLESET_USER SA
                            WHERE SA.PROGRAM_ID  = P_PROGRAM_ID
                              AND SA.SHEET_NAME  = P_SHEET_NAME
                              AND SA.USER_ID     = P_USER_ID
                              AND SA.COLUMN_NAME = M.COLUMN_NAME))
           AND (   P_LINE_ID IS NULL
                OR T.LINE_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
           AND (   V_ITEM_INPUT = 'N'
                OR T.SCM_SITE_ID||T.LINE_ID IN (SELECT SA.SCM_SITE_ID||SA.LINE_ID
                                                  FROM GT_0013_PL_BY_SEARCH SA)
                OR (    T.LINE_ASSIGN_KEY IN (SELECT SB.LINE_ASSIGN_KEY
                                                FROM GT_0013_PL_BY_TT SB)
                    AND T.MEASURE IN ('LINE_TOTAL_LOAD_ENGINE', 'LINE_TOTAL_LOAD_AMEND')));

        DELETE GT_0013_PL_BY_SEARCH;
        DELETE GT_0013_PL_BY_TT;
        DELETE GT_0013_LOAD;
        DELETE GT_0013_PERFOR;
        DELETE GT_0013_PLAN;

        /********************************************************************************
        * 6. OutDataSet Pivot - PIVOIT처리
        ********************************************************************************/
        INSERT INTO GT_0013_LOOKUP
             (
               LOOKUP_TYPE
              ,SEGMENT1
              ,SEGMENT2
             )
        SELECT LOOKUP_TYPE
             , SEGMENT1
             , SEGMENT2
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE 1 = 1
           AND LOOKUP_TYPE IN ('CELL_TYPE_GROUP_CODE', 'OPERATION_GROUP');

        /* 피벗 컬럼 목록 조립 - 조회 기간에 따라 컬럼 개수가 달라지므로 동적 SQL 을 쓴다 */
        V_COL_PIVOT1 := NULL;

        FOR C1 IN (SELECT YYYYMMDD
                        , CNT
                     FROM (SELECT 'W_'||A.BASIS_YYYYMM||A.ISO_WEEK   AS YYYYMMDD
                                , A.BASIS_START_DATE||'21'           AS SORT_ORDER_NO
                                , TO_CHAR(COUNT(1))                  AS CNT
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                              AND (   V_BUCKET = 'DAILY'
                                   OR V_BUCKET = 'WEEKLY')
                            GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                            UNION ALL
                           SELECT 'M_'||A.BASIS_YYYYMM
                                , MIN(A.BASIS_START_DATE)||'01'
                                , TO_CHAR(COUNT(1))
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                            GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                            UNION ALL
                           SELECT 'D_'||A.BASIS_YYYYMMDD
                                , A.BASIS_YYYYMMDD||'31'
                                , TO_CHAR(COUNT(1))
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                              AND V_BUCKET = 'DAILY'
                            GROUP BY A.BASIS_YYYYMMDD)
                    ORDER BY SORT_ORDER_NO)
        LOOP
            IF SUBSTR(C1.YYYYMMDD, 1, 2) = 'M_' THEN
                V_COL_PIVOT1 := V_COL_PIVOT1
                            || ', SUM(CASE WHEN YYYYMM = SUBSTR('''||C1.YYYYMMDD||''', -6) THEN QTY ELSE 0 END)'
                            || ' / CASE WHEN MEASURE LIKE ''LINE_TOTAL%'' THEN '||C1.CNT||' ELSE 1 END AS '||C1.YYYYMMDD||CHR(10);
            ELSIF SUBSTR(C1.YYYYMMDD, 1, 2) = 'W_' THEN
                V_COL_PIVOT1 := V_COL_PIVOT1
                            || ', SUM(CASE WHEN ISO_WEEK = SUBSTR('''||C1.YYYYMMDD||''', -6) THEN QTY ELSE 0 END)'
                            || ' / CASE WHEN MEASURE LIKE ''LINE_TOTAL%'' THEN '||C1.CNT||' ELSE 1 END AS '||C1.YYYYMMDD||CHR(10);
            ELSE
                V_COL_PIVOT1 := V_COL_PIVOT1
                            || ', SUM(CASE WHEN YYYYMMDD = '''||C1.YYYYMMDD||''' THEN QTY ELSE 0 END) AS '||C1.YYYYMMDD||CHR(10);
            END IF;
        END LOOP;

        ----------------------------------------------------------------------
        -- RESULT 1
        ----------------------------------------------------------------------
        V_SQL1 := 'SELECT NVL(B.SEGMENT2, ''/'')                     AS CELL_TYPE_GROUP_CODE'||CHR(10)
              || '     , NVL(C.SEGMENT2, ''/'')                     AS OPERATION_GROUP_NAME'||CHR(10)
              || '     , T.*'||CHR(10)
              || '  FROM (SELECT (SELECT SITE_DESCRIPTION'||CHR(10)
              || '                  FROM (SELECT X.SITE_DESCRIPTION'||CHR(10)
              || '                          FROM SCM_MST_SITE X'||CHR(10)
              || '                         WHERE X.SCM_SITE_ID = IA.SCM_SITE_ID)'||CHR(10)
              || '                 WHERE ROWNUM = 1)                AS SCM_SITE_DESCRIPTION'||CHR(10)
              || '             , (SELECT DIVISION_NAME'||CHR(10)
              || '                  FROM (SELECT X.DIVISION_NAME'||CHR(10)
              || '                          FROM SCM_MST_DIVISION X'||CHR(10)
              || '                         WHERE X.DIVISION_ID = IA.DIVISION_ID)'||CHR(10)
              || '                 WHERE ROWNUM = 1)                AS DIVISION_NAME'||CHR(10)
              || '             , (SELECT NICK_NAME'||CHR(10)
              || '                  FROM (SELECT X.NICK_NAME'||CHR(10)
              || '                          FROM SCM_MST_ITEM_SN X'||CHR(10)
              || '                         WHERE X.ITEM_ID = IA.ITEM_ID'||CHR(10)
              || '                           AND X.NICK_NAME IS NOT NULL)'||CHR(10)
              || '                 WHERE ROWNUM = 1)                AS NICK_NAME'||CHR(10)
              || '             , (SELECT CELL_ITEM_ID'||CHR(10)
              || '                  FROM (SELECT X.CELL_ITEM_ID'||CHR(10)
              || '                          FROM SCP_MST_FINAL_ITEM X'||CHR(10)
              || '                         WHERE X.DIVISION_ID = IA.ORIGIN_DIVISION_ID'||CHR(10)
              || '                           AND X.ITEM_ID     = IA.ITEM_ID)'||CHR(10)
              || '                 WHERE ROWNUM = 1)                AS CELL_ID'||CHR(10)
              || '             , (SELECT SCP_EXTRA_SPEC'||CHR(10)
              || '                  FROM (SELECT NVL(X.SCP_EXTRA_SPEC, ''-'') AS SCP_EXTRA_SPEC'||CHR(10)
              || '                          FROM SCM_MST_ITEM_SN X'||CHR(10)
              || '                         WHERE X.DIVISION_ID = ''40'''||CHR(10)
              || '                           AND X.DIVISION_ID = IA.DIVISION_ID'||CHR(10)
              || '                           AND X.ITEM_ID     = IA.ITEM_ID)'||CHR(10)
              || '                 WHERE ROWNUM = 1)                AS EXTRA_SPEC'||CHR(10)
              || '             , IA.*'||CHR(10)
              || '          FROM (SELECT A.CP_KEY'||CHR(10)
              || '                     , A.FIX_KEY'||CHR(10)
              || '                     , A.DIVISION_ID'||CHR(10)
              || '                     , A.OPERATION_GROUP'||CHR(10)
              || '                     , A.SCM_SITE_ID'||CHR(10)
              || '                     , A.LINE_ID'||CHR(10)
              || '                     , A.PARENT_ITEM_ID'||CHR(10)
              || '                     , FN_GET_ITEM_PROD_OP(A.DIVISION_ID, A.OPERATION_GROUP, A.ITEM_ID) AS MODEL_ID'||CHR(10)
              || '                     , A.ITEM_ID'||CHR(10)
              || '                     , A.MEASURE'||CHR(10)
              || '                     , A.MEASURE_NAME'||CHR(10)
              || '                     , A.OPERATION_ID'||CHR(10)
              || '                     , A.PLAN_TYPE'||CHR(10)
              || '                     , A.PLAN_SEQ'||CHR(10)
              || '                     , A.PLAN_START_YYYYMMDD'||CHR(10)
              || '                     , A.FROM_YYYYMMDD'||CHR(10)
              || '                     , A.SORT_ORDER_NO'||CHR(10)
              || '                     , A.ORIGIN_DIVISION_ID'||CHR(10)
              || '                     , A.ELECTRODE_TYPE'||CHR(10)
--              || '                     , A.CELL_TYPE_GROUP_CODE'||CHR(10)
              -- 2026.09.17 AJS 코드 칸 이름 분리 - 1번째 칸(이름)과 같은 이름이라 서버 결과에서 하나가 사라짐 (START)
              || '                     , A.CELL_TYPE_GROUP_CODE                     AS CELL_TYPE_GROUP_CD'||CHR(10)
              -- 2026.09.17 AJS 코드 칸 이름 분리 - 1번째 칸(이름)과 같은 이름이라 서버 결과에서 하나가 사라짐 (END)
              || '                     , A.UNIT'||CHR(10)
              || V_COL_PIVOT1
              || '                  FROM GT_0013_PIVOT A'||CHR(10)
              || '                 WHERE 1 = 1'||CHR(10)
              || '                   AND A.ORIGIN_DIVISION_ID NOT IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_DIVISION_DIV(''EE'')))'||CHR(10)
              || '                 GROUP BY A.CP_KEY'||CHR(10)
              || '                        , A.FIX_KEY'||CHR(10)
              || '                        , A.DIVISION_ID'||CHR(10)
              || '                        , A.OPERATION_GROUP'||CHR(10)
              || '                        , A.SCM_SITE_ID'||CHR(10)
              || '                        , A.LINE_ID'||CHR(10)
              || '                        , A.PARENT_ITEM_ID'||CHR(10)
              || '                        , A.ITEM_ID'||CHR(10)
              || '                        , A.MEASURE'||CHR(10)
              || '                        , A.MEASURE_NAME'||CHR(10)
              || '                        , A.OPERATION_ID'||CHR(10)
              || '                        , A.PLAN_TYPE'||CHR(10)
              || '                        , A.PLAN_SEQ'||CHR(10)
              || '                        , A.PLAN_START_YYYYMMDD'||CHR(10)
              || '                        , A.FROM_YYYYMMDD'||CHR(10)
              || '                        , A.SORT_ORDER_NO'||CHR(10)
              || '                        , A.ORIGIN_DIVISION_ID'||CHR(10)
              || '                        , A.ELECTRODE_TYPE'||CHR(10)
              || '                        , A.CELL_TYPE_GROUP_CODE'||CHR(10)
              || '                        , A.UNIT) IA) T'||CHR(10)
              || '     , GT_0013_LOOKUP B'||CHR(10)
              || '     , GT_0013_LOOKUP C'||CHR(10)
              || ' WHERE 1 = 1'||CHR(10)
              || '   AND B.LOOKUP_TYPE(+) = ''CELL_TYPE_GROUP_CODE'''||CHR(10)
--              || '   AND B.SEGMENT1(+)    = T.CELL_TYPE_GROUP_CODE'||CHR(10)
              -- 2026.09.17 AJS 코드 칸 이름 분리 (START)
              || '   AND B.SEGMENT1(+)    = T.CELL_TYPE_GROUP_CD'||CHR(10)
              -- 2026.09.17 AJS 코드 칸 이름 분리 (END)
              || '   AND C.LOOKUP_TYPE(+) = ''OPERATION_GROUP'''||CHR(10)
              || '   AND C.SEGMENT1(+)    = T.OPERATION_GROUP'||CHR(10);

        IF P_CELL_TYPE_GR IS NOT NULL THEN
            /* AS-IS 는 선택한 Cell Type 목록에 'L'(라인 부하율 행) 을 항상 보탠다 */
            V_SQL1 := V_SQL1
--                  || '   AND NVL(T.CELL_TYPE_GROUP_CODE, ''L'') IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(:B_CELL_TYPE_GR||'',L'', '','')))'||CHR(10);
                  -- 2026.09.17 AJS 코드 칸 이름 분리 (START)
                  || '   AND NVL(T.CELL_TYPE_GROUP_CD, ''L'') IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(:B_CELL_TYPE_GR||'',L'', '','')))'||CHR(10);
                  -- 2026.09.17 AJS 코드 칸 이름 분리 (END)
        END IF;

        IF P_MODEL_ID IS NOT NULL THEN
            V_SQL1 := V_SQL1
                  || '   AND T.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(:B_MODEL_ID, '','')))'||CHR(10);
        END IF;

        /* Extra Spec 조회조건 추가 2025-04-02 mrchois */
        IF P_EXTRA_SPEC IS NOT NULL THEN
            V_SQL1 := V_SQL1
                  || '   AND T.EXTRA_SPEC IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(:B_EXTRA_SPEC, '','')))'||CHR(10);
        END IF;

        V_SQL1 := V_SQL1
              || ' ORDER BY T.DIVISION_ID'||CHR(10)
              || '        , T.OPERATION_GROUP'||CHR(10)
              || '        , T.SCM_SITE_ID'||CHR(10)
              || '        , T.LINE_ID'||CHR(10)
              || '        , T.OPERATION_ID'||CHR(10)
              || '        , T.PARENT_ITEM_ID DESC'||CHR(10)
              || '        , T.ITEM_ID DESC'||CHR(10)
              || '        , T.SORT_ORDER_NO ASC';

        /* RESULT 1 커서는 임시테이블 정리가 모두 끝난 뒤 마지막에 연다 */

        ----------------------------------------------------------------------
        -- RESULT 2 - Fix Data
        ----------------------------------------------------------------------
        IF V_BUCKET = 'DAILY' THEN

            OPEN O_RC2 FOR
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , NULL                                             AS FIX_KEY
                 , A.YYYYMMDD
                 , B.BASIS_YYYYMM                                   AS BASIS_YYYYMM
                 , B.ISO_WEEK
                 , NVL(A.ORIGIN_DIVISION_ID, '-')                   AS ORIGIN_DIVISION_ID
                 , NVL(A.ELECTRODE_TYPE, '-')                       AS ELECTRODE_TYPE
              FROM SCP_ANL_PRODUCTION_PLAN_FIX   A
                 , SCM_SYS_CALENDAR_M            B
             WHERE 1 = 1
               AND A.YYYYMMDD        = B.BASIS_YYYYMMDD
               AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD       <= P_TO_YYYYMMDD
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
               AND (   P_ELECTRODE_TYPE IS NULL
                    OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))));

        ELSE

            OPEN O_RC2 FOR
            SELECT DISTINCT
                   A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.SCM_SITE_ID
                 , A.ITEM_ID
                 , A.LINE_ID
                 , A.OPERATION_ID
                 , NULL                                             AS FIX_KEY
                 , B.BASIS_YYYYMM                                   AS BASIS_YYYYMM
                 , B.ISO_WEEK
                 , NVL(A.ORIGIN_DIVISION_ID, '-')                   AS ORIGIN_DIVISION_ID
                 , NVL(A.ELECTRODE_TYPE, '-')                       AS ELECTRODE_TYPE
              FROM SCP_ANL_PRODUCTION_PLAN_FIX   A
                 , SCM_SYS_CALENDAR_M            B
             WHERE 1 = 1
               AND A.YYYYMMDD        = B.BASIS_YYYYMMDD
               AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD       <= P_TO_YYYYMMDD
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND (   P_SCM_SITE_ID IS NULL
                    OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
               AND (   P_LINE_ID IS NULL
                    OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
               AND (   P_ELECTRODE_TYPE IS NULL
                    OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(P_ELECTRODE_TYPE, ','))));

        END IF;

        ------------------------------------------------------
        -- 2023/06/12 주/월 :: working_time = 0 제외 cnt
        ------------------------------------------------------
        INSERT INTO GT_0013_BUCKET_SUM
             (
               BUCKET_TYPE
              ,DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,MEASURE
              ,YYYYMMDD
              ,SUM_QTY
             )
        SELECT IA.BUCKET_TYPE
             , IA.DIVISION_ID
             , IA.SCM_SITE_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , IA.MEASURE
             , IA.YYYYMMDD
             , SUM(NVL(IA.QTY, 0))                                  AS SUM_QTY
          FROM (SELECT BT.BUCKET_TYPE
                     , A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.OPERATION_ID
                     , A.LINE_ID
                     , A.MEASURE
                     , CASE
                           WHEN BT.BUCKET_TYPE = 'W'
                           THEN 'W_'||B.BASIS_YYYYMM||B.ISO_WEEK
                           ELSE 'M_'||B.BASIS_YYYYMM
                       END                                          AS YYYYMMDD
                     , A.QTY
                  FROM (   /* LINE_TOTAL_LOAD_ENGINE */
                        SELECT DISTINCT
                               XA.DIVISION_ID
                             , XA.SCM_SITE_ID
                             , XA.OPERATION_ID
                             , XA.LINE_ID
                             , 'LINE_TOTAL_LOAD_ENGINE'             AS MEASURE
                             , XA.YYYYMMDD
                             , CASE
                                   WHEN D.WORKING_TIME <= 0.0
                                   THEN 0
                                   ELSE NVL(ROUND(SUM(XA.QTY * (E.TACT_TIME / 60)), 0) / NULLIF(D.WORKING_TIME, 0), 0) * 100
                               END                                  AS QTY
                          FROM GT_0013_TMP          XA
                             , SCP_ANL_WORKING_TIME D
                             , SCP_ANL_TACT_TIME    E
                         WHERE 1 = 1
                           AND XA.ORIGIN_DIVISION_ID = D.DIVISION_ID(+)
                           AND XA.OPERATION_ID       = D.OPERATION_ID(+)
                           AND XA.SCM_SITE_ID2       = D.SCM_SITE_ID(+)
                           AND XA.LINE_ID            = D.LINE_ID(+)
                           AND XA.YYYYMMDD           = D.YYYYMMDD(+)
                           AND XA.ORIGIN_DIVISION_ID = E.DIVISION_ID(+)
                           AND XA.OPERATION_ID       = E.OPERATION_ID(+)
                           AND XA.SCM_SITE_ID2       = E.SCM_SITE_ID(+)
                           AND XA.LINE_ID            = E.LINE_ID(+)
                           AND XA.ITEM_ID            = E.ITEM_ID(+)
                           AND XA.YYYYMMDD           = E.YYYYMMDD(+)
                           AND XA.LINE_ID           != '*'
                           AND XA.MEASURE            = UPPER('PROD_PLAN_ENGINE')
                         GROUP BY XA.DIVISION_ID
                                , XA.OPERATION_GROUP
                                , XA.SCM_SITE_ID
                                , XA.OPERATION_ID
                                , XA.LINE_ID
                                , XA.YYYYMMDD
                                , D.WORKING_TIME
                                , XA.ORIGIN_DIVISION_ID
                         UNION ALL
                            /* LINE_TOTAL_LOAD_AMEND */
--                      SELECT DISTINCT
                        SELECT /*+ LEADING(XB D E F) */ DISTINCT   /* AJS 20261007 속도 */
                               XB.DIVISION_ID
                             , XB.SCM_SITE_ID
                             , XB.OPERATION_ID
                             , XB.LINE_ID
                             , 'LINE_TOTAL_LOAD_AMEND'
                             , XB.YYYYMMDD
                             , CASE
                                   WHEN D.WORKING_TIME <= 0.0
                                   THEN 0
                                   ELSE NVL(ROUND(SUM(XB.QTY * (E.TACT_TIME / 60)), 0) / NULLIF(D.WORKING_TIME, 0), 0) * 100
                               END
                          FROM GT_0013_TMP           XB
                             , GT_0013_WORKING_DATA  D
                             , SCP_ANL_TACT_TIME     E
                             , SCP_ANL_WORKING_TIME  F
                         WHERE 1 = 1
                           AND XB.ORIGIN_DIVISION_ID = D.DIVISION_ID(+)
                           AND XB.OPERATION_ID       = D.OPERATION_ID(+)
                           AND XB.SCM_SITE_ID2       = D.SCM_SITE_ID(+)
                           AND XB.LINE_ID            = D.LINE_ID(+)
                           AND XB.YYYYMMDD           = D.YYYYMMDD(+)
                           AND XB.ORIGIN_DIVISION_ID = E.DIVISION_ID(+)
                           AND XB.OPERATION_ID       = E.OPERATION_ID(+)
                           AND XB.SCM_SITE_ID2       = E.SCM_SITE_ID(+)
                           AND XB.LINE_ID            = E.LINE_ID(+)
                           AND XB.ITEM_ID            = E.ITEM_ID(+)
                           AND XB.YYYYMMDD           = E.YYYYMMDD(+)
                           AND XB.SCM_SITE_ID2       = F.SCM_SITE_ID(+)
                           AND XB.LINE_ID            = F.LINE_ID(+)
                           AND XB.YYYYMMDD           = F.YYYYMMDD(+)
                           AND XB.LINE_ID           != '*'
                           AND XB.MEASURE            = UPPER('PROD_PLAN_AMEND')
                         GROUP BY XB.DIVISION_ID
                                , XB.OPERATION_GROUP
                                , XB.SCM_SITE_ID
                                , XB.OPERATION_ID
                                , XB.LINE_ID
                                , XB.YYYYMMDD
                                , D.WORKING_TIME
                                , XB.ORIGIN_DIVISION_ID
                                , F.WORKING_TIME) A
                     , SCM_SYS_CALENDAR_M B
                     , (SELECT 'W' AS BUCKET_TYPE FROM DUAL
                        UNION ALL
                        SELECT 'M' FROM DUAL) BT
                 WHERE A.YYYYMMDD = B.BASIS_YYYYMMDD(+)) IA
         GROUP BY IA.BUCKET_TYPE
                , IA.DIVISION_ID
                , IA.SCM_SITE_ID
                , IA.OPERATION_ID
                , IA.LINE_ID
                , IA.MEASURE
                , IA.YYYYMMDD;

        DELETE GT_0013_TMP;
        DELETE GT_0013_WORKING_DATA;

        INSERT INTO GT_0013_BUCKET_CNT
             (
               BUCKET_TYPE
              ,DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,YYYYMMDD
              ,CNT
             )
        SELECT IA.BUCKET_TYPE
             , IA.DIVISION_ID
             , IA.SCM_SITE_ID
             , IA.OPERATION_ID
             , IA.LINE_ID
             , IA.YYYYMMDD
             , SUM(NVL(IA.CNT, 0))                                  AS CNT
          FROM (SELECT BT.BUCKET_TYPE
                     , B.DIVISION_ID
                     , B.SCM_SITE_ID
                     , B.OPERATION_ID
                     , B.LINE_ID
                     , CASE
                           WHEN BT.BUCKET_TYPE = 'W'
                           THEN 'W_'||A.BASIS_YYYYMM||A.ISO_WEEK
                           ELSE 'M_'||A.BASIS_YYYYMM
                       END                                          AS YYYYMMDD
                     , CASE
                           WHEN NVL(B.WORKING_TIME, 0) > 0
                           THEN 1
                           ELSE 0
                       END                                          AS CNT
                  FROM SCM_SYS_CALENDAR_M       A
                     , SCP_ANL_WORKING_TIME     B
                     , (SELECT 'W' AS BUCKET_TYPE FROM DUAL
                        UNION ALL
                        SELECT 'M' FROM DUAL) BT
                 WHERE 1 = 1
                   AND A.BASIS_YYYYMMDD = B.YYYYMMDD
                   AND B.DIVISION_ID    = P_DIVISION_ID
                   AND (   P_SCM_SITE_ID IS NULL
                        OR B.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                               FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
                   AND (   P_LINE_ID IS NULL
                        OR B.LINE_ID IN (SELECT COLUMN_VALUE
                                           FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
                   AND (B.SCM_SITE_ID, B.OPERATION_ID, B.LINE_ID) IN (SELECT SA.SCM_SITE_ID   /* AJS 20261007 속도 */
                                                                     , SA.OPERATION_ID   /* AJS 20261007 속도 */
                                                                     , SA.LINE_ID   /* AJS 20261007 속도 */
                                                                  FROM GT_0013_BUCKET_SUM SA)   /* AJS 20261007 속도 */
                   AND A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD) IA
         GROUP BY IA.BUCKET_TYPE
                , IA.DIVISION_ID
                , IA.SCM_SITE_ID
                , IA.OPERATION_ID
                , IA.LINE_ID
                , IA.YYYYMMDD;

        INSERT INTO GT_0013_BUCKET_RATIO
             (
               BUCKET_TYPE
              ,DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,YYYYMMDD
              ,MEASURE
              ,RATIO
             )
        SELECT A.BUCKET_TYPE
             , A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.YYYYMMDD
             , A.MEASURE
             , NVL(A.SUM_QTY / NULLIF(B.CNT, 0), 0)                 AS RATIO
          FROM GT_0013_BUCKET_SUM   A
             , GT_0013_BUCKET_CNT   B
         WHERE 1 = 1
           AND A.BUCKET_TYPE  = B.BUCKET_TYPE
           AND A.DIVISION_ID  = B.DIVISION_ID
           AND A.SCM_SITE_ID  = B.SCM_SITE_ID
           AND A.OPERATION_ID = B.OPERATION_ID
           AND A.LINE_ID      = B.LINE_ID
           AND A.YYYYMMDD     = B.YYYYMMDD;

        DELETE GT_0013_BUCKET_SUM;
        DELETE GT_0013_BUCKET_CNT;

        ----------------------------------------------------------------------
        -- RESULT 3, WEEKLY PIVOT
        ----------------------------------------------------------------------
        V_COL_PIVOT3 := NULL;

        FOR C1 IN (SELECT DISTINCT
                          YYYYMMDD
                     FROM GT_0013_BUCKET_RATIO
                    WHERE BUCKET_TYPE = 'W')
        LOOP
            V_COL_PIVOT3 := V_COL_PIVOT3
                        || ', MAX(CASE WHEN YYYYMMDD = '''||C1.YYYYMMDD||''' THEN NVL(RATIO, 0) END) AS '||C1.YYYYMMDD||CHR(10);
        END LOOP;

        V_SQL3 := 'SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, MEASURE'||CHR(10)
              || V_COL_PIVOT3
              || '  FROM GT_0013_BUCKET_RATIO'||CHR(10)
              || ' WHERE BUCKET_TYPE = ''W'''||CHR(10)
              || ' GROUP BY DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, MEASURE';

        OPEN O_RC3 FOR V_SQL3;

        ----------------------------------------------------------------------
        -- RESULT 4, MONTHLY PIVOT
        ----------------------------------------------------------------------
        V_COL_PIVOT4 := NULL;

        FOR C1 IN (SELECT DISTINCT
                          YYYYMMDD
                     FROM GT_0013_BUCKET_RATIO
                    WHERE BUCKET_TYPE = 'M')
        LOOP
            V_COL_PIVOT4 := V_COL_PIVOT4
                        || ', MAX(CASE WHEN YYYYMMDD = '''||C1.YYYYMMDD||''' THEN NVL(RATIO, 0) END) AS '||C1.YYYYMMDD||CHR(10);
        END LOOP;

        V_SQL4 := 'SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, MEASURE'||CHR(10)
              || V_COL_PIVOT4
              || '  FROM GT_0013_BUCKET_RATIO'||CHR(10)
              || ' WHERE BUCKET_TYPE = ''M'''||CHR(10)
              || ' GROUP BY DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, MEASURE';

        OPEN O_RC4 FOR V_SQL4;

        ----------------------------------------------------------------------
        -- RESULT 1 (커서 OPEN)
        ----------------------------------------------------------------------
        IF P_DEBUG_MODE = 'T' THEN
            /* AS-IS 의 debug_mode 출력에 대응한다(조립된 조회문 확인용) */
            FOR I IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(V_SQL1) - 1) / 3000)
            LOOP
                DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL1, 3000, I * 3000 + 1));
            END LOOP;
        END IF;

        IF     P_CELL_TYPE_GR IS NOT NULL
           AND P_MODEL_ID     IS NOT NULL
           AND P_EXTRA_SPEC   IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_CELL_TYPE_GR, P_MODEL_ID, P_EXTRA_SPEC;
        ELSIF     P_CELL_TYPE_GR IS NOT NULL
              AND P_MODEL_ID     IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_CELL_TYPE_GR, P_MODEL_ID;
        ELSIF     P_CELL_TYPE_GR IS NOT NULL
              AND P_EXTRA_SPEC   IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_CELL_TYPE_GR, P_EXTRA_SPEC;
        ELSIF     P_MODEL_ID   IS NOT NULL
              AND P_EXTRA_SPEC IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_MODEL_ID, P_EXTRA_SPEC;
        ELSIF P_CELL_TYPE_GR IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_CELL_TYPE_GR;
        ELSIF P_MODEL_ID IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_MODEL_ID;
        ELSIF P_EXTRA_SPEC IS NOT NULL THEN
            OPEN O_RC1 FOR V_SQL1 USING P_EXTRA_SPEC;
        ELSE
            OPEN O_RC1 FOR V_SQL1;
        END IF;

    END P_SCP0013_GET_PROD_PLAN_LINEBY;


    /* ========================================================================================
       7. SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP
       ======================================================================================== */
    PROCEDURE P_SCP0013_LINE_LOAD_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_PRODUCTION_PLAN_LINE_LOAD_POPUP
     * Description  : Production Plan Line 별 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/02/22	hwyoon			[CSR ID:3929975] 각 라인/동별 부하율 팝업 창 설계 관련 사항의 건
     * 2019/06/07	hwyoon			[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
     * 2021.10.14   KMJ			    PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 평균 소숫점 2자리
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_COL_PIVOT     CLOB;
        V_SQL           CLOB;
    BEGIN

        /********************************************************************************
        * 임시테이블 초기화
        ********************************************************************************/
        DELETE GT_0013_POPUP_BASE;
        DELETE GT_0013_POPUP_QTY;
        DELETE GT_0013_POPUP_SUM;

        INSERT INTO GT_0013_POPUP_BASE
             (
               DIVISION_ID
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,QTY
              ,SCM_SITE_ID2
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
             )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.LINE_ID
             , A.OPERATION_ID
             , A.YYYYMMDD
             , A.QTY
             , CASE
                   WHEN SUBSTR(A.SCM_SITE_ID, -2) = '-S'
                   THEN SUBSTR(A.SCM_SITE_ID, 1, LENGTH(RTRIM(A.SCM_SITE_ID)) - 2)
                   ELSE A.SCM_SITE_ID
               END                                                  AS SCM_SITE_ID2
             , A.ORIGIN_DIVISION_ID
             , NVL(NULLIF(RTRIM(A.ELECTRODE_TYPE),''), '/')                           AS ELECTRODE_TYPE
          FROM SCP_ANL_PRODUCTION_PLAN A
         WHERE 1 = 1
           AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD       <= P_TO_YYYYMMDD
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.OPERATION_GROUP = P_OPERATION_GROUP
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                /* 파티션 프루닝 */
           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
           AND A.PLAN_TYPE       = P_PLAN_TYPE
           AND A.SEQ             = P_SEQ
           AND (   P_SCM_SITE_ID IS NULL
                OR A.SCM_SITE_ID IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))))
           AND (   P_LINE_ID IS NULL
                OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
           AND A.LINE_ID        != '*'
           AND A.MEASURE         = UPPER('PROD_PLAN_AMEND');

        /* 라인별 부하율 */
        INSERT INTO GT_0013_POPUP_QTY
             (
               DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,QTY
              ,WORKING_TIME
              ,LOAD_QTY
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,LINE_NAME
              ,FACTORY_ID
              ,FACTORY_NAME
              ,TYPE
              ,TYPE2
              ,OSP_YN
             )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , SUM(A.QTY * (E.TACT_TIME / 60))                      AS QTY
             , D.WORKING_TIME
             , CASE
                   WHEN D.WORKING_TIME <= 0.0
                   THEN 0
                   ELSE NVL(ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / NULLIF(D.WORKING_TIME, 0), 0) * 100
               END                                                  AS LOAD_QTY
             , P_FROM_YYYYMMDD                                      AS FROM_YYYYMMDD
             , 'D_'||A.YYYYMMDD                                     AS YYYYMMDD
             , NVL(NULLIF(RTRIM(A.ORIGIN_DIVISION_ID),''), '/')                       AS ORIGIN_DIVISION_ID
             , L.ELECTRODE_TYPE
             , A.LINE_ID                                            AS LINE_NAME
             , L.FACTORY_ID
             , NVL(F.FACTORY_NAME, L.FACTORY_ID)                    AS FACTORY_NAME
             , 3                                                    AS TYPE
             , 3                                                    AS TYPE2
             , S.OSP_YN
          FROM GT_0013_POPUP_BASE       A
             , SCM_MST_SITE             S
             , SCM_MST_LINE_SN          L
             , SCM_MST_FACTORY_SN       F
             , SCP_ANL_WORKING_TIME     D
             , SCP_ANL_TACT_TIME        E
         WHERE 1 = 1
           AND S.SCM_SITE_ID        = A.SCM_SITE_ID2
           AND L.COMPANY_ID(+)      = S.COMPANY_ID
           AND L.DIVISION_ID(+)     = S.DIVISION_ID
           AND L.SITE_ID(+)         = S.SITE_ID
           AND L.PLANT_ID(+)        = S.PLANT_ID
           AND L.OPERATION_ID(+)    = A.OPERATION_ID
           AND L.LINE_ID(+)         = A.LINE_ID
           AND L.ACTIVE_FLAG(+)     = 'Y'
           AND F.COMPANY_ID(+)      = S.COMPANY_ID
           AND F.DIVISION_ID(+)     = S.DIVISION_ID
           AND F.SITE_ID(+)         = S.SITE_ID
           AND F.PLANT_ID(+)        = S.PLANT_ID
           AND F.FACTORY_ID(+)      = L.FACTORY_ID
           AND A.ORIGIN_DIVISION_ID = D.DIVISION_ID(+)
           AND A.OPERATION_ID       = D.OPERATION_ID(+)
           AND A.SCM_SITE_ID2       = D.SCM_SITE_ID(+)
           AND A.LINE_ID            = D.LINE_ID(+)
           AND A.YYYYMMDD           = D.YYYYMMDD(+)
           AND A.ORIGIN_DIVISION_ID = E.DIVISION_ID(+)
           AND A.OPERATION_ID       = E.OPERATION_ID(+)
           AND A.SCM_SITE_ID2       = E.SCM_SITE_ID(+)
           AND A.LINE_ID            = E.LINE_ID(+)
           AND A.ITEM_ID            = E.ITEM_ID(+)
           AND A.YYYYMMDD           = E.YYYYMMDD(+)
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.SCM_SITE_ID
                , A.OPERATION_ID
                , A.LINE_ID
                , A.YYYYMMDD
                , D.WORKING_TIME
                , S.OSP_YN
                , A.ORIGIN_DIVISION_ID
                , L.ELECTRODE_TYPE
                , L.LINE_NAME
                , L.FACTORY_ID
                , F.FACTORY_NAME;

        /* 동별 부하율 */
        INSERT INTO GT_0013_POPUP_QTY
             (
               DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,QTY
              ,WORKING_TIME
              ,LOAD_QTY
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,LINE_NAME
              ,FACTORY_ID
              ,FACTORY_NAME
              ,TYPE
              ,TYPE2
              ,OSP_YN
             )
        SELECT DIVISION_ID
             , SCM_SITE_ID
             , OPERATION_ID
             , '-'                                                  AS LINE_ID
             , SUM(QTY)                                             AS QTY
             , SUM(WORKING_TIME)                                    AS WORKING_TIME
             , CASE
                   WHEN SUM(WORKING_TIME) <= 0.0
                   THEN 0
                   ELSE NVL(ROUND(SUM(QTY), 0) / NULLIF(SUM(WORKING_TIME), 0), 0) * 100
               END                                                  AS LOAD_QTY
             , FROM_YYYYMMDD
             , YYYYMMDD
             , ORIGIN_DIVISION_ID
             , ELECTRODE_TYPE
             , ELECTRODE_TYPE                                       AS LINE_NAME
             , FACTORY_ID
             , FACTORY_NAME
             , 3                                                    AS TYPE
             , 2                                                    AS TYPE2
             , 'N'                                                  AS OSP_YN
          FROM GT_0013_POPUP_QTY
         WHERE 1 = 1
           AND TYPE   = 3
           AND OSP_YN = 'N'
         GROUP BY DIVISION_ID
                , SCM_SITE_ID
                , OPERATION_ID
                , FROM_YYYYMMDD
                , YYYYMMDD
                , ORIGIN_DIVISION_ID
                , ELECTRODE_TYPE
                , FACTORY_ID
                , FACTORY_NAME;

        /* Plant별 부하율 */
        INSERT INTO GT_0013_POPUP_QTY
             (
               DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,QTY
              ,WORKING_TIME
              ,LOAD_QTY
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,LINE_NAME
              ,FACTORY_ID
              ,FACTORY_NAME
              ,TYPE
              ,TYPE2
              ,OSP_YN
             )
        SELECT DIVISION_ID
             , SCM_SITE_ID
             , '-'                                                  AS OPERATION_ID
             , '-'                                                  AS LINE_ID
             , SUM(QTY)                                             AS QTY
             , SUM(WORKING_TIME)                                    AS WORKING_TIME
             , CASE
                   WHEN SUM(WORKING_TIME) <= 0.0
                   THEN 0
                   ELSE NVL(ROUND(SUM(QTY), 0) / NULLIF(SUM(WORKING_TIME), 0), 0) * 100
               END                                                  AS LOAD_QTY
             , FROM_YYYYMMDD
             , YYYYMMDD
             , ORIGIN_DIVISION_ID
             , ELECTRODE_TYPE
             , '-'                                                  AS LINE_NAME
             , ELECTRODE_TYPE                                       AS FACTORY_ID
             , ELECTRODE_TYPE                                       AS FACTORY_NAME
             , 1                                                    AS TYPE
             , 1                                                    AS TYPE2
             , 'N'                                                  AS OSP_YN
          FROM GT_0013_POPUP_QTY
         WHERE 1 = 1
           AND TYPE   = 3
           AND TYPE2  = 3
           AND OSP_YN = 'N'
         GROUP BY DIVISION_ID
                , SCM_SITE_ID
                , FROM_YYYYMMDD
                , YYYYMMDD
                , ORIGIN_DIVISION_ID
                , ELECTRODE_TYPE;

        /********************************************************************************
        * 임시테이블 처리
        ********************************************************************************/
        INSERT INTO GT_0013_POPUP_SUM
             (
               DIVISION_ID
              ,SCM_SITE_ID
              ,OPERATION_ID
              ,LINE_ID
              ,QTY
              ,WORKING_TIME
              ,LOAD_QTY
              ,FROM_YYYYMMDD
              ,YYYYMMDD
              ,YYYYMM
              ,ISO_WEEK
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,LINE_NAME
              ,FACTORY_ID
              ,FACTORY_NAME
              ,TYPE
              ,TYPE2
              ,OSP_YN
             )
        SELECT M.DIVISION_ID
             , M.SCM_SITE_ID
             , M.OPERATION_ID
             , M.LINE_ID
             , M.QTY
             , M.WORKING_TIME
             , M.LOAD_QTY
             , M.FROM_YYYYMMDD
             , M.YYYYMMDD
             , O.BASIS_YYYYMM                                       AS YYYYMM
             , SUBSTR(O.BASIS_YYYYMM, -4)||O.ISO_WEEK               AS ISO_WEEK
             , M.ORIGIN_DIVISION_ID
             , M.ELECTRODE_TYPE
             , M.LINE_NAME
             , M.FACTORY_ID
             , M.FACTORY_NAME
             , M.TYPE
             , M.TYPE2
             , M.OSP_YN
          FROM GT_0013_POPUP_QTY    M
             , SCM_SYS_CALENDAR_M   O
         WHERE SUBSTR(M.YYYYMMDD, -8) = O.BASIS_YYYYMMDD;

        /********************************************************************************
        * PIVOIT처리
        ********************************************************************************/
        V_COL_PIVOT := NULL;

        FOR C1 IN (SELECT YYYYMMDD
                        , CNT
                     FROM (SELECT 'W_'||A.BASIS_YYYYMM||A.ISO_WEEK   AS YYYYMMDD
                                , A.BASIS_START_DATE||'21'           AS SORT_ORDER_NO
                                , TO_CHAR(COUNT(1))                  AS CNT
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                            GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                            UNION ALL
                           SELECT 'D_'||A.BASIS_YYYYMMDD
                                , A.BASIS_YYYYMMDD||'31'
                                , TO_CHAR(COUNT(1))
                             FROM SCM_SYS_CALENDAR_M A
                            WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                            GROUP BY A.BASIS_YYYYMMDD)
                    ORDER BY SORT_ORDER_NO)
        LOOP
            IF SUBSTR(C1.YYYYMMDD, 1, 2) = 'W_' THEN
                V_COL_PIVOT := V_COL_PIVOT
                            || ', CAST(SUM(CASE WHEN ISO_WEEK = SUBSTR('''||C1.YYYYMMDD||''', -6) THEN LOAD_QTY ELSE 0 END)'
                            || ' / '||C1.CNT||' AS NUMBER(15,2)) AS '||C1.YYYYMMDD||CHR(10);
            ELSE
                V_COL_PIVOT := V_COL_PIVOT
                            || ', CAST(SUM(CASE WHEN YYYYMMDD = '''||C1.YYYYMMDD||''' THEN LOAD_QTY ELSE 0 END)'
                            || ' AS NUMBER(15,2)) AS '||C1.YYYYMMDD||CHR(10);
            END IF;
        END LOOP;

        V_SQL := 'SELECT A.DIVISION_ID'||CHR(10)                    /* division */
              || '     , A.SCM_SITE_ID'||CHR(10)                    /* plant site */
              || '     , A.OPERATION_ID'||CHR(10)                   /* operation id */
              || '     , A.LINE_ID'||CHR(10)
              || '     , A.ORIGIN_DIVISION_ID'||CHR(10)
              || '     , A.ELECTRODE_TYPE'||CHR(10)
              || '     , A.LINE_NAME'||CHR(10)                      /* line */
              || '     , A.FACTORY_ID'||CHR(10)
              || '     , A.FACTORY_NAME'||CHR(10)                   /* Building */
              || '     , A.TYPE'||CHR(10)
              || V_COL_PIVOT
              || '  FROM GT_0013_POPUP_SUM A'||CHR(10)
              || ' GROUP BY A.DIVISION_ID'||CHR(10)
              || '        , A.SCM_SITE_ID'||CHR(10)
              || '        , A.OPERATION_ID'||CHR(10)
              || '        , A.LINE_ID'||CHR(10)
              || '        , A.ORIGIN_DIVISION_ID'||CHR(10)
              || '        , A.ELECTRODE_TYPE'||CHR(10)
              || '        , A.LINE_NAME'||CHR(10)
              || '        , A.FACTORY_ID'||CHR(10)
              || '        , A.FACTORY_NAME'||CHR(10)
              || '        , A.TYPE'||CHR(10)
              || '        , A.TYPE2'||CHR(10)
              || '        , A.OSP_YN'||CHR(10)
              || ' ORDER BY A.DIVISION_ID, A.SCM_SITE_ID, A.TYPE DESC, A.FACTORY_ID, A.OPERATION_ID DESC, A.ELECTRODE_TYPE, A.TYPE2 DESC, A.LINE_ID';

        OPEN O_RC1 FOR V_SQL;

    END P_SCP0013_LINE_LOAD_POPUP;

    /* ========================================================================================
       8. SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP
       ======================================================================================== */
    PROCEDURE P_SCP0013_SAVE_LINE_POPUP
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_DATE             IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2 DEFAULT '',
        P_SCM_SITE_ID           IN  VARCHAR2 DEFAULT '',
        P_USER_ID               IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP
     * Description  : PRODUCTION PLAN LINE 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2018/08/22	ygkim   		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/08/31	hwyoon			validation 체크 추가(동일plan, tact time)
     * 2018/08/31	hwyoon			ORIGIN_DIVISION_ID 수정(EE일때만 SCP_MST_FINAL_ITEM 적용)
     * 2018/09/04   hwyoon			EE 일 경우 SCM_ADM_LOOKUP_MASTER_DETAIL에 Plant Site, Line 정보 넣는 로직 추가
     * 2018/12/06	hwyoon			plant site id 입력 시 파라미터 값 그대로 입력 (top1 제거)
     * 2018/12/13	hwyoon			외주 packer 입력 시 T/T 체크 제거. 공정ID 변경
     * 2020/02/07	hwyoon			ESS 외주 Pakcer Line 생산 Target 적용
     * 2020/10/28   khj79           PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
       2022/05/10   chaan           [] V1.1 DIvision 필터링 추가(lookup->ATTRIBUTE2) EE_PRODUCTION_PLAN
     * 2023/04/10   LWY				PJ20230691R - DIVISION_ID 공통화 작업(div_commonization)
     * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *									- ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0013_SAVE_PRODUCTION_PLAN_LINE_POPUP';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         NUMBER             := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        /* plan 일짜 까지 만듬 */
        V_PET_DATE          VARCHAR2(8 CHAR);

        /* 예외처리 변수 설정 */
        V_ERR_CODE          NUMBER;
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_ERR_TRACE         VARCHAR2(4000 CHAR);

        V_EE_CNT            NUMBER := 0;
    BEGIN

        DELETE GT_0013_TARGET_SUB;
        DELETE GT_0013_DIV_LAST_PLAN;
        DELETE GT_0013_ADM_LOOKUP;

        SELECT MAX(P.HORIZON_END_DATE)
          INTO V_PET_DATE
          FROM SCM_MST_PLAN P
         WHERE 1 = 1
           AND P.DIVISION_ID = P_DIVISION_ID
           AND P.PLAN_ID     = (SELECT MAX(SA.PLAN_ID)
                                  FROM SCM_MST_PLAN SA
                                 WHERE SA.DIVISION_ID = P_DIVISION_ID
                                   AND SA.PLAN_ID     < 9999);

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        -------------------------------------------------------------------------------------------------------------------------------------------------------
        --### Start : [PJ2025F254] ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
        --            ASIS 기존 SUB 서브 쿼리 결과 데이터 임시테이블에 저장
        -------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_TARGET_SUB
             (
               DIVISION_ID
              ,ORIGIN_DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,ELECTRODE_TYPE
             )
        SELECT B.DIVISION_ID
             , B.ORIGIN_DIVISION_ID
             , B.PLAN_START_YYYYMMDD
             , B.PLAN_TYPE
             , TO_NUMBER(B.SEQ)
             , B.OPERATION_GROUP
             , B.SCM_SITE_ID
             , B.ITEM_ID
             , B.LINE_ID
             , B.OPERATION_ID
             , A.BASIS_YYYYMMDD                                     AS YYYYMMDD
             , B.ELECTRODE_TYPE
          FROM (SELECT IA.BASIS_YYYYMMDD
                  FROM SCM_SYS_CALENDAR_M IA
                 WHERE IA.BASIS_YYYYMMDD >= P_PLAN_DATE
                   AND IA.BASIS_YYYYMMDD <= V_PET_DATE) A
             , (SELECT *
                  FROM (SELECT P_DIVISION_ID                        AS DIVISION_ID
                             , P_ORIGIN_DIVISION_ID                 AS ORIGIN_DIVISION_ID
                             , P_PLAN_DATE                          AS PLAN_START_YYYYMMDD
                             , P_PLAN_TYPE                          AS PLAN_TYPE
                             , P_SEQ                                AS SEQ
                             , F.OPERATION_GROUP
                             , P_SCM_SITE_ID                        AS SCM_SITE_ID
                             , F.ITEM_ID
                             , P_LINE_ID                            AS LINE_ID
                                  /* PJ20202001 :  Rack item '_R1' 추가 */
                             , CASE
                                   WHEN NVL(F.ATTRIBUTE3, 'N') = 'Y'
                                   THEN (SELECT PLANT_ID
                                           FROM (SELECT X.PLANT_ID||'_R1' AS PLANT_ID
                                                   FROM SCM_MST_SITE X
                                                  WHERE X.SCM_SITE_ID = P_SCM_SITE_ID
                                                    AND X.OSP_YN      = 'Y')
                                          WHERE ROWNUM = 1)
                                   WHEN (   P_LINE_ID = '-'
                                         OR NVL(S.ATTRIBUTE1, 'N') = 'Y')
                                   THEN (SELECT PLANT_ID
                                           FROM (SELECT X.PLANT_ID
                                                   FROM SCM_MST_SITE X
                                                  WHERE X.SCM_SITE_ID = P_SCM_SITE_ID
                                                    AND X.OSP_YN      = 'Y')
                                          WHERE ROWNUM = 1)
                                   ELSE SUBSTR(F.FLOW_ID, 1, 5)
                               END                                  AS OPERATION_ID
                             , F.ELECTRODE_TYPE
                          FROM SCP_MST_FINAL_ITEM   F
                             , SCM_MST_SITE         S
                         WHERE 1 = 1
                           AND S.SCM_SITE_ID = P_SCM_SITE_ID
                           AND F.ITEM_ID     = P_ITEM_ID)
                 WHERE ROWNUM = 1) B;

        ------------------------------------------------------------------------------------------------------------
        /* DIVISION 주차별 최종 수행 Plan 버전 정보                                          */
        /* ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터          */
        /* Final Plan은 수정 대상에서 제외 ?                                                 */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_DIV_LAST_PLAN
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,HORIZON_END_DATE
              ,PLAN_STATUS
              ,INPUT_START_DATE
              ,RN
             )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , PLAN_SEQ
             , HORIZON_END_DATE
             , PLAN_STATUS
             , INPUT_START_DATE
             , RN
          FROM (SELECT PD.DIVISION_ID
                     , PM.PLAN_NAME                                 AS PLAN_START_YYYYMMDD
                     , PD.PLAN_TYPE
                     , PD.PLAN_SEQ
                     , PM.HORIZON_END_DATE
                     , PD.PLAN_STATUS
                     , PD.INPUT_START_DATE
                     , ROW_NUMBER() OVER (PARTITION BY PD.DIVISION_ID
                                                     , PM.PLAN_NAME
                                              ORDER BY CASE PD.PLAN_TYPE
                                                           WHEN 'PR' THEN 4
                                                           WHEN 'MA' THEN 3
                                                           WHEN 'SE' THEN 2
                                                           WHEN 'FN' THEN 1
                                                           ELSE 0
                                                       END
                                                     , PD.PLAN_SEQ DESC
                                                     , PD.INPUT_START_DATE DESC) AS RN
                  FROM SCM_MST_PLAN         PM
                     , SCM_MST_PLAN_DETAIL  PD
                     , SCM_MST_DIVISION     DM
                 WHERE 1 = 1
                   AND PD.DIVISION_ID  = PM.DIVISION_ID
                   AND PD.PLAN_ID      = PM.PLAN_ID
                   AND PD.PLAN_STATUS  = 1
                   AND DM.DIVISION_ID  = PM.DIVISION_ID
                   AND DM.ATTRIBUTE3  != 'EE'
                   AND PM.PLAN_CYCLE   = 'WEEKLY'
                   AND PM.PLAN_NAME   >= TO_CHAR(SYSDATE - 20, 'YYYYMMDD'))
         WHERE 1 = 1
           AND RN        = 1
           AND PLAN_TYPE != 'FN';   /* Final plan 대상에서 제외 */

        -------------------------------------------------------------------------------------------------------------------------------------------------------
        /* 처리 대상에 ESS 가상 라인에 매핑된 JV 라인 정보 추가 */
        -------------------------------------------------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_TARGET_SUB
             (
               DIVISION_ID
              ,ORIGIN_DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,YYYYMMDD
              ,ELECTRODE_TYPE
             )
        SELECT TG.DIVISION_ID
             , TG.ORIGIN_DIVISION_ID
             , TG.PLAN_START_YYYYMMDD
             , PV.PLAN_TYPE                                         AS PLAN_TYPE
             , PV.PLAN_SEQ                                          AS SEQ
             , TG.OPERATION_GROUP
             , TG.SCM_SITE_ID
             , TG.ITEM_ID
             , TG.LINE_ID
             , TG.OPERATION_ID
             , CM.BASIS_YYYYMMDD                                    AS YYYYMMDD
             , TG.ELECTRODE_TYPE
          FROM (SELECT DISTINCT
                       LM.RL_DIVISION_ID                            AS DIVISION_ID
                     , LM.RL_DIVISION_ID                            AS ORIGIN_DIVISION_ID
                     , TA.PLAN_START_YYYYMMDD
                     , TA.OPERATION_GROUP
                     , SM.RP_SCM_SITE_ID                            AS SCM_SITE_ID
                     , TA.ITEM_ID
                     , LM.RL_LINE_ID                                AS LINE_ID
                     , TA.OPERATION_ID
                     , TA.ELECTRODE_TYPE
                  FROM GT_0013_TARGET_SUB TA
                     , TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP()) SM
                     , TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP()) LM
                 WHERE 1 = 1
                   AND SM.VP_DIVISION_ID = TA.DIVISION_ID
                   AND SM.VP_SCM_SITE_ID = TA.SCM_SITE_ID
                   AND LM.VL_DIVISION_ID = TA.DIVISION_ID
                   AND LM.VL_LINE_ID     = TA.LINE_ID
                   AND LM.VL_COMPANY_ID  = SM.VP_COMPANY_ID
                   AND LM.VL_DIVISION_ID = SM.VP_DIVISION_ID
                   AND LM.VL_SITE_ID     = SM.VP_SITE_ID
                   AND LM.VL_PLANT_ID    = SM.VP_PLANT_ID
                   AND TA.OPERATION_GROUP = 'A') TG
             , GT_0013_DIV_LAST_PLAN PV
             , SCM_SYS_CALENDAR_M    CM
         WHERE 1 = 1
           AND PV.DIVISION_ID         = TG.DIVISION_ID
           AND PV.PLAN_START_YYYYMMDD = TG.PLAN_START_YYYYMMDD
           AND CM.BASIS_YYYYMMDD BETWEEN PV.PLAN_START_YYYYMMDD AND PV.HORIZON_END_DATE;
        -------------------------------------------------------------------------------------------------------------------------------------------------------
        --### End : [PJ2025F254]
        -------------------------------------------------------------------------------------------------------------------------------------------------------

        INSERT INTO SCP_ANL_PRODUCTION_PLAN
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
             )
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.SCM_SITE_ID
             , SUB.ITEM_ID
             , SUB.LINE_ID
             , SUB.OPERATION_ID
             , MS.MEASURE
             , SUB.YYYYMMDD
             , 0                                                    AS QTY
             , SUB.ORIGIN_DIVISION_ID
             , SUB.ELECTRODE_TYPE
             , P_USER_ID                                            AS CREATED_BY
             , SYSDATE                                              AS CREATION_DATE
             , P_USER_ID                                            AS LAST_UPDATED_BY
             , SYSDATE                                              AS LAST_UPDATE_DATE
          FROM GT_0013_TARGET_SUB   SUB
             , (SELECT 'PROD_PLAN_ENGINE' AS MEASURE FROM DUAL
                UNION ALL
                SELECT 'PROD_PLAN_AMEND'            FROM DUAL) MS
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM SCP_ANL_PRODUCTION_PLAN Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID         = SUB.DIVISION_ID
                              AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                                   /* 파티션 프루닝 - 대상 주차는 P_PLAN_DATE 하나이므로 상수로 준다 */
                              AND Z.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_DATE, 'YYYYMMDD')
                              AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                              AND Z.SEQ                 = SUB.SEQ
                              AND Z.OPERATION_GROUP     = SUB.OPERATION_GROUP
                              AND Z.SCM_SITE_ID         = SUB.SCM_SITE_ID
                              AND Z.ITEM_ID             = SUB.ITEM_ID
                              AND Z.LINE_ID             = SUB.LINE_ID
                              AND Z.OPERATION_ID        = SUB.OPERATION_ID
                              AND Z.MEASURE             = MS.MEASURE
                              AND Z.YYYYMMDD            = SUB.YYYYMMDD);

        INSERT INTO SCP_ANL_PRODUCTION_PLAN_H
             (
               HISTORY_SEQ
              ,DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,SEQ
              ,OPERATION_GROUP
              ,SCM_SITE_ID
              ,ITEM_ID
              ,LINE_ID
              ,OPERATION_ID
              ,MEASURE
              ,YYYYMMDD
              ,QTY
              ,ORIGIN_DIVISION_ID
              ,ELECTRODE_TYPE
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,HISTORY_CREATION_DATE
             )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_H.NEXTVAL
             , SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.OPERATION_GROUP
             , SUB.SCM_SITE_ID
             , SUB.ITEM_ID
             , SUB.LINE_ID
             , SUB.OPERATION_ID
             , MS.MEASURE
             , SUB.YYYYMMDD
             , 0                                                    AS QTY
             , SUB.ORIGIN_DIVISION_ID
             , SUB.ELECTRODE_TYPE
             , P_USER_ID
             , SYSDATE
             , P_USER_ID
             , SYSDATE
             , SYSDATE
          FROM GT_0013_TARGET_SUB   SUB
             , (SELECT 'PROD_PLAN_ENGINE' AS MEASURE FROM DUAL
                UNION ALL
                SELECT 'PROD_PLAN_AMEND'            FROM DUAL) MS
         WHERE 1 = 1;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* EE일 경우 Lookup 테이블에 Plant Site, Line 조회조건 정보 추가해준다. */
        SELECT COUNT(*)
          INTO V_EE_CNT
          FROM TABLE(FN_GET_DIVISION_DIV('EE'))
         WHERE COLUMN_VALUE = P_DIVISION_ID
           AND ROWNUM      = 1;

        IF V_EE_CNT > 0 THEN

            INSERT INTO GT_0013_ADM_LOOKUP
                 (
                   LOOKUP_TYPE
                  ,SEGMENT1
                  ,SEGMENT2
                  ,SEGMENT3
                  ,SEGMENT4
                  ,SEGMENT5
                  ,DISPLAY_SEQ
                  ,ATTRIBUTE1
                 )
            SELECT 'EE_PRODUCTION_PLAN'                             AS LOOKUP_TYPE
                 , 'SCP'                                            AS SEGMENT1
                 , A.OPERATION_GROUP                                AS SEGMENT2
                 , A.SCM_SITE_ID                                    AS SEGMENT3
                 , A.LINE_ID                                        AS SEGMENT4
                 , A.OPERATION_ID                                   AS SEGMENT5
                 , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                          ORDER BY A.DIVISION_ID)   AS DISPLAY_SEQ
                 , A.ORIGIN_DIVISION_ID                             AS ATTRIBUTE1
              FROM (SELECT DISTINCT
                           DIVISION_ID
                         , OPERATION_GROUP
                         , SCM_SITE_ID
                         , ORIGIN_DIVISION_ID
                         , LINE_ID
                         , OPERATION_ID
                      FROM SCP_ANL_PRODUCTION_PLAN
                     WHERE 1 = 1
                       AND DIVISION_ID         = P_DIVISION_ID
                       AND PLAN_START_YYYYMMDD = P_PLAN_DATE
                            /* 파티션 프루닝 */
                       AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_DATE, 'YYYYMMDD')
                       AND PLAN_TYPE           = P_PLAN_TYPE
                       AND SEQ                 = P_SEQ
                       AND OPERATION_GROUP     = P_OPERATION_GROUP
                       AND SCM_SITE_ID         = P_SCM_SITE_ID
                       AND ITEM_ID             = P_ITEM_ID
                       AND LINE_ID             = P_LINE_ID) A
             WHERE NOT EXISTS (SELECT 1
                                 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                                WHERE B.LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
                                  AND B.SEGMENT1    = 'SCP'
                                  AND B.SEGMENT2    = A.OPERATION_GROUP
                                  AND B.SEGMENT3    = A.SCM_SITE_ID
                                  AND B.SEGMENT4    = A.LINE_ID
                                  AND B.SEGMENT5    = A.OPERATION_ID
                                  AND B.ATTRIBUTE2  = A.DIVISION_ID);

            INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                 (
                   LOOKUP_TYPE
                  ,SEGMENT1
                  ,SEGMENT2
                  ,SEGMENT3
                  ,SEGMENT4
                  ,SEGMENT5
                  ,DISPLAY_SEQ
                  ,ATTRIBUTE1
                  ,VALID_YN
                  ,DESCRIPTION
                  ,CREATED_BY
                  ,CREATION_DATE
                  ,LAST_UPDATED_BY
                  ,LAST_UPDATE_DATE
                 )
            SELECT LOOKUP_TYPE
                 , SEGMENT1
                 , SEGMENT2
                 , SEGMENT3
                 , SEGMENT4
                 , SEGMENT5
                 , DISPLAY_SEQ
                 , ATTRIBUTE1
                 , 'Y'                                              AS VALID_YN
                 , LOOKUP_TYPE                                      AS DESCRIPTION
                 , P_USER_ID                                        AS CREATED_BY
                 , SYSDATE                                          AS CREATION_DATE
                 , P_USER_ID                                        AS LAST_UPDATED_BY
                 , SYSDATE                                          AS LAST_UPDATE_DATE
              FROM GT_0013_ADM_LOOKUP;

            INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
                 (
                   HISTORY_SEQ
                  ,LOOKUP_TYPE
                  ,SEGMENT1
                  ,SEGMENT2
                  ,SEGMENT3
                  ,SEGMENT4
                  ,SEGMENT5
                  ,DISPLAY_SEQ
                  ,ATTRIBUTE1
                  ,VALID_YN
                  ,DESCRIPTION
                  ,CREATED_BY
                  ,CREATION_DATE
                  ,LAST_UPDATED_BY
                  ,LAST_UPDATE_DATE
                  ,HISTORY_CREATION_DATE
                 )
            SELECT SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H.NEXTVAL
                 , LOOKUP_TYPE
                 , SEGMENT1
                 , SEGMENT2
                 , SEGMENT3
                 , SEGMENT4
                 , SEGMENT5
                 , DISPLAY_SEQ
                 , ATTRIBUTE1
                 , 'Y'
                 , LOOKUP_TYPE
                 , P_USER_ID
                 , SYSDATE
                 , P_USER_ID
                 , SYSDATE
                 , SYSDATE
              FROM GT_0013_ADM_LOOKUP;

        END IF;

        DELETE GT_0013_TARGET_SUB;

        OPEN O_RC1 FOR
        SELECT 'S'  AS RESULT_CODE
             , 1    AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;
            V_ERR_TRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            ROLLBACK;   /* 입력 데이타 롤백 처리 */

            INSERT INTO SCM_SYS_LOG_BATCH
                 (
                   PROGRAM_NAME
                  ,LOG_TYPE
                  ,LOG_COUNT
                  ,LOG_MESSAGE
                  ,DESCRIPTION
                  ,EVENT_DATE
                  ,CREATION_DATE
                  ,CREATED_BY
                  ,LAST_UPDATE_DATE
                  ,LAST_UPDATED_BY
                 )
            VALUES
                 (
                   V_PROGRAM_NAME
                  ,'ERROR'
                  ,NULL
                  ,V_ERR_MESSAGE
                  ,V_ERR_TRACE
                  ,SYSDATE
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                 );
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR
            SELECT 'F'  AS RESULT_CODE
                 , 0    AS RESULT_CNT
              FROM DUAL;

    END P_SCP0013_SAVE_LINE_POPUP;


    /* ========================================================================================
       9. SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW
       ======================================================================================== */
    PROCEDURE P_SCP0013_SAVE_LINE_ROW
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_SCM_SITE_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_LINE_ID               IN  VARCHAR2,
        P_OPERATION_ID          IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_ORIGIN_DIVISION_ID    IN  VARCHAR2,
        P_ELECTRODE_TYPE        IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_FIX                   IN  VARCHAR2,
        P_LOC_FLAG              IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0013',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : [SCP0011_SAVE_PRODUCTION_PLAN_LINE]
     * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장(ROW단위 저장방식으로 변경)
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/06/05   PJS		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/07/18	YHW		전극용 저장항목 추가
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        V_CREATED_BY        VARCHAR2(600 CHAR) := P_USER_ID;
        V_CREATION_DATE     DATE               := SYSDATE;
        V_LAST_UPDATED_BY   VARCHAR2(600 CHAR) := P_USER_ID;

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := '[SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW]';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         NUMBER             := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        V_FIX_ID            VARCHAR2(80 CHAR);

        /* 예외처리 변수 설정 */
        V_ERR_CODE          NUMBER;
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_ERR_TRACE         VARCHAR2(4000 CHAR);
    BEGIN

        /* SCP0011, SCP0013에서 공용으로 사용하는 프로시져 이기 때문에 SCP0013에서 호출되었을 경우 program_name 변경 */
        IF P_PROGRAM_ID = 'SCP0013' THEN
            V_PROGRAM_NAME := 'SCP0013';
        END IF;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;

        IF P_LOC_FLAG = 'F' THEN
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

        /* 이력저장 */
        P_SCP_PROD_PLAN_HIST(P_DIVISION_ID
                            ,P_PLAN_START_YYYYMMDD
                            ,P_PLAN_TYPE
                            ,P_SEQ
                            ,P_OPERATION_GROUP
                            ,P_SCM_SITE_ID
                            ,P_ITEM_ID
                            ,P_LINE_ID
                            ,P_OPERATION_ID
                            ,P_MEASURE
                            ,P_YYYYMMDD
                            ,P_QTY
                            ,V_CREATED_BY
                            ,V_CREATION_DATE
                            ,V_LAST_UPDATED_BY
                            ,P_ORIGIN_DIVISION_ID
                            ,P_ELECTRODE_TYPE);

        /* 수정 - AS-IS 는 MERGE 문이나 온라인 SQL 에서 MERGE 를 쓰지 않는다(전환가이드 8항).  */
        /*        UPDATE 후 처리 건수가 0 이면 INSERT 하는 형태로 옮긴다(결과 동일).           */
        IF    P_ACTIVE_FLAG = 'M'
           OR P_ACTIVE_FLAG = 'I' THEN

            UPDATE SCP_ANL_PRODUCTION_PLAN
               SET QTY              = P_QTY
                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_CREATION_DATE
             WHERE 1 = 1
               AND DIVISION_ID         = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    /* 파티션 프루닝 */
               AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND PLAN_TYPE           = P_PLAN_TYPE
               AND SEQ                 = P_SEQ
               AND OPERATION_GROUP     = P_OPERATION_GROUP
               AND SCM_SITE_ID         = P_SCM_SITE_ID
               AND ITEM_ID             = P_ITEM_ID
               AND LINE_ID             = P_LINE_ID
               AND OPERATION_ID        = P_OPERATION_ID
               AND MEASURE             = P_MEASURE
               AND YYYYMMDD            = P_YYYYMMDD
               AND NVL(ELECTRODE_TYPE, '-') = NVL(P_ELECTRODE_TYPE, '-');

            IF SQL%ROWCOUNT = 0 THEN
                INSERT INTO SCP_ANL_PRODUCTION_PLAN
                     (
                       DIVISION_ID
                      ,PLAN_START_YYYYMMDD
                      ,PLAN_TYPE
                      ,SEQ
                      ,OPERATION_GROUP
                      ,SCM_SITE_ID
                      ,ITEM_ID
                      ,LINE_ID
                      ,OPERATION_ID
                      ,MEASURE
                      ,ORIGIN_DIVISION_ID
                      ,ELECTRODE_TYPE
                      ,YYYYMMDD
                      ,QTY
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY
                      ,LAST_UPDATE_DATE
                     )
                VALUES
                     (
                       P_DIVISION_ID
                      ,P_PLAN_START_YYYYMMDD
                      ,P_PLAN_TYPE
                      ,P_SEQ
                      ,P_OPERATION_GROUP
                      ,P_SCM_SITE_ID
                      ,P_ITEM_ID
                      ,P_LINE_ID
                      ,P_OPERATION_ID
                      ,P_MEASURE
                      ,P_ORIGIN_DIVISION_ID
                      ,P_ELECTRODE_TYPE
                      ,P_YYYYMMDD
                      ,P_QTY
                      ,V_CREATED_BY
                      ,V_CREATION_DATE
                      ,V_LAST_UPDATED_BY
                      ,V_CREATION_DATE
                     );
            END IF;

        ELSIF P_ACTIVE_FLAG = 'D' THEN

            DELETE FROM SCP_ANL_PRODUCTION_PLAN
             WHERE 1 = 1
               AND DIVISION_ID         = P_DIVISION_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                    /* 파티션 프루닝 */
               AND PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
               AND PLAN_TYPE           = P_PLAN_TYPE
               AND SEQ                 = P_SEQ
               AND OPERATION_GROUP     = P_OPERATION_GROUP
               AND SCM_SITE_ID         = P_SCM_SITE_ID
               AND ITEM_ID             = P_ITEM_ID
               AND LINE_ID             = P_LINE_ID
               AND OPERATION_ID        = P_OPERATION_ID
               AND MEASURE             = P_MEASURE
               AND YYYYMMDD            = P_YYYYMMDD
               AND NVL(ELECTRODE_TYPE, '-') = NVL(P_ELECTRODE_TYPE, '-');

        END IF;

        IF P_FIX = 'Y' THEN

            /* FIX데이타 수정 */
            UPDATE SCP_ANL_PRODUCTION_PLAN_FIX
               SET QTY              = P_QTY
                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_CREATION_DATE
             WHERE 1 = 1
               AND DIVISION_ID     = P_DIVISION_ID
               AND OPERATION_GROUP = P_OPERATION_GROUP
               AND SCM_SITE_ID     = P_SCM_SITE_ID
               AND ITEM_ID         = P_ITEM_ID
               AND LINE_ID         = P_LINE_ID
               AND OPERATION_ID    = P_OPERATION_ID
               AND YYYYMMDD        = P_YYYYMMDD
               AND NVL(ELECTRODE_TYPE, '-') = NVL(P_ELECTRODE_TYPE, '-');

            /* FIX_ID조회 */
            SELECT MAX(A.FIX_ID)
              INTO V_FIX_ID
              FROM SCP_ANL_PRODUCTION_PLAN_FIX A
             WHERE 1 = 1
               AND A.DIVISION_ID     = P_DIVISION_ID
               AND A.OPERATION_GROUP = P_OPERATION_GROUP
               AND A.SCM_SITE_ID     = P_SCM_SITE_ID
               AND A.ITEM_ID         = P_ITEM_ID
               AND A.LINE_ID         = P_LINE_ID
               AND A.OPERATION_ID    = P_OPERATION_ID
               AND A.YYYYMMDD        = P_YYYYMMDD
               AND NVL(A.ELECTRODE_TYPE, '-') = NVL(P_ELECTRODE_TYPE, '-');

            /* 이력저장 */
            P_SCP_PROD_PLAN_FIX_HIST(V_FIX_ID
                                    ,P_DIVISION_ID
                                    ,P_OPERATION_GROUP
                                    ,P_SCM_SITE_ID
                                    ,P_ITEM_ID
                                    ,P_LINE_ID
                                    ,P_OPERATION_ID
                                    ,P_YYYYMMDD
                                    ,P_QTY
                                    ,NULL
                                    ,V_LAST_UPDATED_BY
                                    ,D_EVENT_DATE
                                    ,V_LAST_UPDATED_BY
                                    ,P_ORIGIN_DIVISION_ID
                                    ,P_ELECTRODE_TYPE);

        END IF;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;

        IF P_LOC_FLAG = 'L' THEN
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        END IF;

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
        SELECT 'S'  AS RESULT_CODE
             , 1    AS RESULT_CNT
          FROM DUAL;

        OPEN O_RC2 FOR
        SELECT NULL AS ERR_CODE
             , NULL AS ERR_MESSAGE
          FROM DUAL
         WHERE 1 = 2;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;
            V_ERR_TRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            ROLLBACK;   /* 입력 데이타 롤백 처리 */

            INSERT INTO SCM_SYS_LOG_BATCH
                 (
                   PROGRAM_NAME
                  ,LOG_TYPE
                  ,LOG_COUNT
                  ,LOG_MESSAGE
                  ,DESCRIPTION
                  ,EVENT_DATE
                  ,CREATION_DATE
                  ,CREATED_BY
                  ,LAST_UPDATE_DATE
                  ,LAST_UPDATED_BY
                 )
            VALUES
                 (
                   V_PROGRAM_NAME
                  ,'ERROR'
                  ,NULL
                  ,V_ERR_MESSAGE
                  ,V_ERR_TRACE
                  ,SYSDATE
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                 );
            COMMIT;

            OPEN O_RC1 FOR
            SELECT 'F'  AS RESULT_CODE
                 , 0    AS RESULT_CNT
              FROM DUAL;

            /* 에러 메시지, 에러 데이터  반환 */
            OPEN O_RC2 FOR
            SELECT TO_CHAR(V_ERR_CODE)  AS ERR_CODE
                 , V_ERR_MESSAGE        AS ERR_MESSAGE
              FROM DUAL;

    END P_SCP0013_SAVE_LINE_ROW;


    /* ========================================================================================
       10. SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET
       ======================================================================================== */
    PROCEDURE P_SCP0013_SAVE_LINE_ROW_DS
    (
        P_SCP0013               IN  T_SCP0013_TAB,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : [SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET]
     * Description  : Production Plan의 Line "Prod. Plan(Amend)" Measure저장(Type Table 저장방식)
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/01/22	YHW				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2019/02/21	YHW				[CSR ID:3929450] Supply(Plan Line, FG, SEMI) 수정 시 Fix 데이터 저장로직 개선
     * 2019/06/07	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2020/02/18	hwyoon			OUTPUT 수량 0 삭제 후 처리로직 추가
     * 2021/10/20   KMJ			    PJ2020964 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선, 주 SUM 대응
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *									- ESS 가상 라인 계획으로 매핑된 JV 라인 계획 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     *									- @SCP0013 파라미터를 @SCP0013_WITH_JV_LINE로 대체 생성 사용
     * 2026.09.11   [MSSQL -> Oracle 전환]
     */
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         NUMBER             := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;

        /* 실행시간 확인용 */
        V_START_TIME        DATE               := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR);

        /* BUCKET 확인 */
        V_BUCKET_TYPE       VARCHAR2(10 CHAR);
        V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
        V_MIN_PLAN_START    VARCHAR2(8 CHAR);
        V_MAX_PLAN_START    VARCHAR2(8 CHAR);

        /* 예외처리 변수 설정 */
        V_ERR_CODE          NUMBER;
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_ERR_TRACE         VARCHAR2(4000 CHAR);
    BEGIN

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        DELETE GT_0013_DYN;
        DELETE GT_0013_DYN_TEMP;
        DELETE GT_0013_WITH_JV;
        DELETE GT_0013_JV_LINE_MAP;
        DELETE GT_0013_JV_SITE_MAP;
        DELETE GT_0013_DIV_LAST_PLAN;

        ------------------------------------------------------------------------------------------------------------
        /* [PJ2025F254] JV/ESS 라인 및 scm site 매핑 정보 추출 */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_JV_LINE_MAP
             (
               VL_COMPANY_ID
              ,VL_DIVISION_ID
              ,VL_SITE_ID
              ,VL_PLANT_ID
              ,VL_FACTORY_ID
              ,VL_LINE_ID
              ,RL_COMPANY_ID
              ,RL_DIVISION_ID
              ,RL_SITE_ID
              ,RL_PLANT_ID
              ,RL_FACTORY_ID
              ,RL_LINE_ID
             )
        SELECT VL_COMPANY_ID
             , VL_DIVISION_ID
             , VL_SITE_ID
             , VL_PLANT_ID
             , VL_FACTORY_ID
             , VL_LINE_ID
             , RL_COMPANY_ID
             , RL_DIVISION_ID
             , RL_SITE_ID
             , RL_PLANT_ID
             , RL_FACTORY_ID
             , RL_LINE_ID
          FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_LINE_MAP());

        INSERT INTO GT_0013_JV_SITE_MAP
             (
               VP_COMPANY_ID
              ,VP_DIVISION_ID
              ,VP_SITE_ID
              ,VP_PLANT_ID
              ,VP_SCM_SITE_ID
              ,RP_COMPANY_ID
              ,RP_DIVISION_ID
              ,RP_SITE_ID
              ,RP_PLANT_ID
              ,RP_SCM_SITE_ID
             )
        SELECT VP_COMPANY_ID
             , VP_DIVISION_ID
             , VP_SITE_ID
             , VP_PLANT_ID
             , VP_SCM_SITE_ID
             , RP_COMPANY_ID
             , RP_DIVISION_ID
             , RP_SITE_ID
             , RP_PLANT_ID
             , RP_SCM_SITE_ID
          FROM TABLE(FN_GET_JV_REAL_ESS_VIRTUAL_SITE_MAP());

        ------------------------------------------------------------------------------------------------------------
        /* DIVISION 주차별 최종 수행 Plan 버전 정보 - Final Plan은 수정 대상에서 제외 */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_DIV_LAST_PLAN
             (
               DIVISION_ID
              ,PLAN_START_YYYYMMDD
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,HORIZON_END_DATE
              ,PLAN_STATUS
              ,INPUT_START_DATE
              ,RN
             )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD
             , PLAN_TYPE
             , PLAN_SEQ
             , HORIZON_END_DATE
             , PLAN_STATUS
             , INPUT_START_DATE
             , RN
          FROM (SELECT PD.DIVISION_ID
                     , PM.PLAN_NAME                                 AS PLAN_START_YYYYMMDD
                     , PD.PLAN_TYPE
                     , PD.PLAN_SEQ
                     , PM.HORIZON_END_DATE
                     , PD.PLAN_STATUS
                     , PD.INPUT_START_DATE
                     , ROW_NUMBER() OVER (PARTITION BY PD.DIVISION_ID
                                                     , PM.PLAN_NAME
                                              ORDER BY CASE PD.PLAN_TYPE
                                                           WHEN 'PR' THEN 4
                                                           WHEN 'MA' THEN 3
                                                           WHEN 'SE' THEN 2
                                                           WHEN 'FN' THEN 1
                                                           ELSE 0
                                                       END
                                                     , PD.PLAN_SEQ DESC
                                                     , PD.INPUT_START_DATE DESC) AS RN
                  FROM SCM_MST_PLAN         PM
                     , SCM_MST_PLAN_DETAIL  PD
                     , SCM_MST_DIVISION     DM
                 WHERE 1 = 1
                   AND PD.DIVISION_ID  = PM.DIVISION_ID
                   AND PD.PLAN_ID      = PM.PLAN_ID
                   AND PD.PLAN_STATUS  = 1
                   AND DM.DIVISION_ID  = PM.DIVISION_ID
                   AND DM.ATTRIBUTE3  != 'EE'
                   AND PM.PLAN_CYCLE   = 'WEEKLY'
                   AND PM.PLAN_NAME   >= TO_CHAR(SYSDATE - 20, 'YYYYMMDD'))
         WHERE 1 = 1
           AND RN        = 1
           AND PLAN_TYPE != 'FN';

        ------------------------------------------------------------------------------------------------------------
        /* 파라미터로 받은 값에서 ESS 가상 라인에 매핑된 JV 라인은 제외함 (단방향 수정 : ESS 가상 -> JV Real 라인) */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_WITH_JV
             (
               A
              ,P_ACTIVE_FLAG
              ,P_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,P_PLAN_TYPE
              ,P_SEQ
              ,P_OPERATION_GROUP
              ,P_SCM_SITE_ID
              ,P_ITEM_ID
              ,P_LINE_ID
              ,P_OPERATION_ID
              ,P_MEASURE
              ,P_YYYYMMDD
              ,P_QTY
              ,P_FIX_REASON
              ,P_USER_ID
              ,P_FIX
              ,P_LOC_FLAG
              ,P_PROGRAM_ID
              ,DEBUG_MODE
              ,P_ORIGIN_DIVISION_ID
              ,P_ELECTRODE_TYPE
              ,P_BUCKET_TYPE
              ,P_FROM_YYYYMMDD
              ,P_TO_YYYYMMDD
             )
        SELECT PR.A
             , PR.P_ACTIVE_FLAG
             , PR.P_DIVISION_ID
             , PR.P_PLAN_START_YYYYMMDD
             , PR.P_PLAN_TYPE
             , PR.P_SEQ
             , PR.P_OPERATION_GROUP
             , PR.P_SCM_SITE_ID
             , PR.P_ITEM_ID
             , PR.P_LINE_ID
             , PR.P_OPERATION_ID
             , PR.P_MEASURE
             , PR.P_YYYYMMDD
             , PR.P_QTY
             , PR.P_FIX_REASON
             , PR.P_USER_ID
             , PR.P_FIX
             , PR.P_LOC_FLAG
             , PR.P_PROGRAM_ID
             , PR.DEBUG_MODE
             , PR.P_ORIGIN_DIVISION_ID
             , PR.P_ELECTRODE_TYPE
             , PR.P_BUCKET_TYPE
             , PR.P_FROM_YYYYMMDD
             , PR.P_TO_YYYYMMDD
          FROM TABLE(P_SCP0013)     PR
             , GT_0013_JV_SITE_MAP  SM
             , GT_0013_JV_LINE_MAP  LM
         WHERE 1 = 1
           AND SM.RP_DIVISION_ID(+) = PR.P_DIVISION_ID
           AND SM.RP_SCM_SITE_ID(+) = PR.P_SCM_SITE_ID
           AND LM.RL_DIVISION_ID(+) = PR.P_DIVISION_ID
           AND LM.RL_LINE_ID(+)     = PR.P_LINE_ID
           AND LM.RL_COMPANY_ID(+)  = SM.RP_COMPANY_ID
           AND LM.RL_SITE_ID(+)     = SM.RP_SITE_ID
           AND LM.RL_PLANT_ID(+)    = SM.RP_PLANT_ID
                /* ESS 가상 line에 매핑된 JV Real Line은 제외  (단방향 수정 ESS가상 -> JV) */
           AND LM.RL_DIVISION_ID IS NULL;

        ------------------------------------------------------------------------------------------------------------
        /* ESS 가상 line에 매핑된 JV Real Line 정보 추가 */
        ------------------------------------------------------------------------------------------------------------
        INSERT INTO GT_0013_WITH_JV
             (
               A
              ,P_ACTIVE_FLAG
              ,P_DIVISION_ID
              ,P_PLAN_START_YYYYMMDD
              ,P_PLAN_TYPE
              ,P_SEQ
              ,P_OPERATION_GROUP
              ,P_SCM_SITE_ID
              ,P_ITEM_ID
              ,P_LINE_ID
              ,P_OPERATION_ID
              ,P_MEASURE
              ,P_YYYYMMDD
              ,P_QTY
              ,P_FIX_REASON
              ,P_USER_ID
              ,P_FIX
              ,P_LOC_FLAG
              ,P_PROGRAM_ID
              ,DEBUG_MODE
              ,P_ORIGIN_DIVISION_ID
              ,P_ELECTRODE_TYPE
              ,P_BUCKET_TYPE
              ,P_FROM_YYYYMMDD
              ,P_TO_YYYYMMDD
             )
        SELECT PR.A
             , PR.P_ACTIVE_FLAG
             , LM.RL_DIVISION_ID                                    AS P_DIVISION_ID
             , PR.P_PLAN_START_YYYYMMDD
             , PV.PLAN_TYPE                                         AS P_PLAN_TYPE
             , PV.PLAN_SEQ                                          AS P_SEQ
             , PR.P_OPERATION_GROUP
             , SM.RP_SCM_SITE_ID                                    AS P_SCM_SITE_ID
             , PR.P_ITEM_ID
             , LM.RL_LINE_ID                                        AS P_LINE_ID
             , PR.P_OPERATION_ID
             , PR.P_MEASURE
             , PR.P_YYYYMMDD
             , PR.P_QTY
             , PR.P_FIX_REASON
             , PR.P_USER_ID
             , PR.P_FIX
             , PR.P_LOC_FLAG
             , PR.P_PROGRAM_ID
             , PR.DEBUG_MODE
             , LM.RL_DIVISION_ID                                    AS P_ORIGIN_DIVISION_ID
             , PR.P_ELECTRODE_TYPE
             , PR.P_BUCKET_TYPE
             , PR.P_FROM_YYYYMMDD
             , PR.P_TO_YYYYMMDD
          FROM TABLE(P_SCP0013)         PR
             , GT_0013_JV_SITE_MAP      SM
             , GT_0013_JV_LINE_MAP      LM
             , GT_0013_DIV_LAST_PLAN    PV
         WHERE 1 = 1
           AND SM.VP_DIVISION_ID      = PR.P_DIVISION_ID
           AND SM.VP_SCM_SITE_ID      = PR.P_SCM_SITE_ID
           AND LM.VL_DIVISION_ID      = PR.P_DIVISION_ID
           AND LM.VL_LINE_ID          = PR.P_LINE_ID
           AND LM.VL_COMPANY_ID       = SM.VP_COMPANY_ID
           AND LM.VL_DIVISION_ID      = SM.VP_DIVISION_ID
           AND LM.VL_SITE_ID          = SM.VP_SITE_ID
           AND LM.VL_PLANT_ID         = SM.VP_PLANT_ID
           AND PV.DIVISION_ID         = LM.RL_DIVISION_ID
           AND PV.PLAN_START_YYYYMMDD = PR.P_PLAN_START_YYYYMMDD;

        /* BUCKET TYPE에 따라 분기 */
        SELECT MAX(P_FROM_YYYYMMDD)
             , MAX(P_TO_YYYYMMDD)
             , MAX(P_BUCKET_TYPE)
             , MIN(P_PLAN_START_YYYYMMDD)
             , MAX(P_PLAN_START_YYYYMMDD)
          INTO V_FROM_YYYYMMDD
             , V_TO_YYYYMMDD
             , V_BUCKET_TYPE
             , V_MIN_PLAN_START
             , V_MAX_PLAN_START
          FROM GT_0013_WITH_JV;

        IF V_BUCKET_TYPE = 'WEEKLY' THEN

            /* 주 SUM QTY -> DAY QTY 변환 */
            INSERT INTO GT_0013_DYN_TEMP
                 (
                   P_DIVISION_ID
                  ,P_PLAN_START_YYYYMMDD
                  ,P_PLAN_TYPE
                  ,P_SEQ
                  ,P_OPERATION_GROUP
                  ,P_SCM_SITE_ID
                  ,P_ITEM_ID
                  ,P_LINE_ID
                  ,P_OPERATION_ID
                  ,P_MEASURE
                  ,WEEK_NAME
                  ,DAY_NAME
                  ,QTY
                 )
            SELECT CC.P_DIVISION_ID
                 , CC.P_PLAN_START_YYYYMMDD
                 , CC.P_PLAN_TYPE
                 , CC.P_SEQ
                 , CC.P_OPERATION_GROUP
                 , CC.P_SCM_SITE_ID
                 , CC.P_ITEM_ID
                 , CC.P_LINE_ID
                 , CC.P_OPERATION_ID
                 , CC.P_MEASURE
                 , DD.WEEK_NAME
                 , DD.DAY_NAME
                 , CASE
                       WHEN NVL(BB.DAY_CNT, 0) = 0
                       THEN CC.DAY_QTY
                       ELSE CC.DAY_QTY + CC.DAY_EX
                   END                                              AS QTY
              FROM (SELECT A.P_DIVISION_ID
                         , A.P_PLAN_START_YYYYMMDD
                         , A.P_PLAN_TYPE
                         , A.P_SEQ
                         , A.P_OPERATION_GROUP
                         , A.P_SCM_SITE_ID
                         , A.P_ITEM_ID
                         , A.P_LINE_ID
                         , A.P_OPERATION_ID
                         , A.P_MEASURE
                         , A.P_YYYYMMDD                             AS WEEK_NAME
                         , TRUNC(TO_NUMBER(A.P_QTY) / B.DAY_CNT)    AS DAY_QTY
                         , MOD(TO_NUMBER(A.P_QTY), B.DAY_CNT)       AS DAY_EX
                      FROM GT_0013_WITH_JV A
                         , (SELECT IA.BASIS_YYYYMM||IA.ISO_WEEK     AS WEEK_NAME
                                 , COUNT(IA.BASIS_YYYYMM)           AS DAY_CNT
                              FROM SCM_SYS_CALENDAR_M IA
                             WHERE 1 = 1
                               AND IA.BASIS_YYYYMM||IA.ISO_WEEK IN (SELECT XA.P_YYYYMMDD
                                                                      FROM GT_0013_WITH_JV XA)
                               AND IA.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                             GROUP BY IA.BASIS_YYYYMM, IA.ISO_WEEK) B
                     WHERE A.P_YYYYMMDD = B.WEEK_NAME) CC
                 , (SELECT IA.BASIS_YYYYMM||IA.ISO_WEEK             AS WEEK_NAME
                         , IA.BASIS_YYYYMMDD                        AS DAY_NAME
                         , RANK() OVER (PARTITION BY IA.BASIS_YYYYMM||IA.ISO_WEEK
                                            ORDER BY IA.BASIS_YYYYMMDD) AS DAY_CNT
                      FROM SCM_SYS_CALENDAR_M IA
                     WHERE 1 = 1
                       AND IA.BASIS_YYYYMM||IA.ISO_WEEK IN (SELECT XA.P_YYYYMMDD
                                                              FROM GT_0013_WITH_JV XA)
                       AND IA.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                     GROUP BY IA.BASIS_YYYYMM, IA.ISO_WEEK, IA.BASIS_YYYYMMDD) DD
                 , (SELECT IA.BASIS_YYYYMM||IA.ISO_WEEK             AS WEEK_NAME
                         , COUNT(IA.BASIS_YYYYMM)                   AS DAY_CNT
                      FROM SCM_SYS_CALENDAR_M IA
                     WHERE 1 = 1
                       AND IA.BASIS_YYYYMM||IA.ISO_WEEK IN (SELECT XA.P_YYYYMMDD
                                                              FROM GT_0013_WITH_JV XA)
                       AND IA.BASIS_YYYYMMDD BETWEEN V_FROM_YYYYMMDD AND V_TO_YYYYMMDD
                     GROUP BY IA.BASIS_YYYYMM, IA.ISO_WEEK) BB
             WHERE 1 = 1
               AND CC.WEEK_NAME   = DD.WEEK_NAME
               AND DD.WEEK_NAME   = BB.WEEK_NAME(+)
               AND DD.DAY_CNT     = BB.DAY_CNT(+);

            INSERT INTO GT_0013_DYN
                 (
                   A
                  ,P_ACTIVE_FLAG
                  ,P_DIVISION_ID
                  ,P_PLAN_START_YYYYMMDD
                  ,P_PLAN_TYPE
                  ,P_SEQ
                  ,P_OPERATION_GROUP
                  ,P_SCM_SITE_ID
                  ,P_ITEM_ID
                  ,P_LINE_ID
                  ,P_OPERATION_ID
                  ,P_MEASURE
                  ,P_YYYYMMDD
                  ,P_QTY
                  ,P_USER_ID
                  ,P_FIX
                  ,P_LOC_FLAG
                  ,P_PROGRAM_ID
                  ,P_ORIGIN_DIVISION_ID
                  ,P_ELECTRODE_TYPE
                  ,P_BUCKET_TYPE
                  ,P_FIX_REASON
                 )
            SELECT DISTINCT
                   A.A
                 , A.P_ACTIVE_FLAG
                 , A.P_DIVISION_ID
                 , A.P_PLAN_START_YYYYMMDD
                 , A.P_PLAN_TYPE
                 , A.P_SEQ
                 , A.P_OPERATION_GROUP
                 , A.P_SCM_SITE_ID
                 , A.P_ITEM_ID
                 , A.P_LINE_ID
                 , A.P_OPERATION_ID
                 , A.P_MEASURE
                 , B.DAY_NAME                                       AS P_YYYYMMDD
                 , TO_CHAR(B.QTY)                                   AS P_QTY
                 , A.P_USER_ID
                 , A.P_FIX
                 , A.P_LOC_FLAG
                 , A.P_PROGRAM_ID
                 , A.P_ORIGIN_DIVISION_ID
                 , A.P_ELECTRODE_TYPE
                 , A.P_BUCKET_TYPE
                 , A.P_FIX_REASON
              FROM GT_0013_WITH_JV      A
                 , GT_0013_DYN_TEMP     B
             WHERE 1 = 1
               AND A.P_DIVISION_ID         = B.P_DIVISION_ID
               AND A.P_PLAN_START_YYYYMMDD = B.P_PLAN_START_YYYYMMDD
               AND A.P_PLAN_TYPE           = B.P_PLAN_TYPE
               AND A.P_SEQ                 = B.P_SEQ
               AND A.P_OPERATION_GROUP     = B.P_OPERATION_GROUP
               AND A.P_SCM_SITE_ID         = B.P_SCM_SITE_ID
               AND A.P_ITEM_ID             = B.P_ITEM_ID
               AND A.P_LINE_ID             = B.P_LINE_ID
               AND A.P_OPERATION_ID        = B.P_OPERATION_ID
               AND A.P_MEASURE             = B.P_MEASURE
               AND A.P_YYYYMMDD            = B.WEEK_NAME;

        ELSE    /* DAILY */

            INSERT INTO GT_0013_DYN
                 (
                   A
                  ,P_ACTIVE_FLAG
                  ,P_DIVISION_ID
                  ,P_PLAN_START_YYYYMMDD
                  ,P_PLAN_TYPE
                  ,P_SEQ
                  ,P_OPERATION_GROUP
                  ,P_SCM_SITE_ID
                  ,P_ITEM_ID
                  ,P_LINE_ID
                  ,P_OPERATION_ID
                  ,P_MEASURE
                  ,P_YYYYMMDD
                  ,P_QTY
                  ,P_USER_ID
                  ,P_FIX
                  ,P_LOC_FLAG
                  ,P_PROGRAM_ID
                  ,P_ORIGIN_DIVISION_ID
                  ,P_ELECTRODE_TYPE
                  ,P_BUCKET_TYPE
                  ,P_FIX_REASON
                 )
            SELECT A.A
                 , A.P_ACTIVE_FLAG
                 , A.P_DIVISION_ID
                 , A.P_PLAN_START_YYYYMMDD
                 , A.P_PLAN_TYPE
                 , A.P_SEQ
                 , A.P_OPERATION_GROUP
                 , A.P_SCM_SITE_ID
                 , A.P_ITEM_ID
                 , A.P_LINE_ID
                 , A.P_OPERATION_ID
                 , A.P_MEASURE
                 , A.P_YYYYMMDD
                 , A.P_QTY
                 , A.P_USER_ID
                 , A.P_FIX
                 , A.P_LOC_FLAG
                 , A.P_PROGRAM_ID
                 , A.P_ORIGIN_DIVISION_ID
                 , A.P_ELECTRODE_TYPE
                 , A.P_BUCKET_TYPE
                 , A.P_FIX_REASON
              FROM GT_0013_WITH_JV A;

        END IF;

        /* 수정 */
        UPDATE SCP_ANL_PRODUCTION_PLAN A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY) = (SELECT B.P_QTY
                                           , SYSDATE
                                           , B.P_USER_ID
                                        FROM GT_0013_DYN B
                                       WHERE B.P_DIVISION_ID         = A.DIVISION_ID
                                         AND B.P_PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                         AND B.P_PLAN_TYPE           = A.PLAN_TYPE
                                         AND B.P_SEQ                 = A.SEQ
                                         AND B.P_OPERATION_GROUP     = A.OPERATION_GROUP
                                         AND B.P_SCM_SITE_ID         = A.SCM_SITE_ID
                                         AND B.P_ITEM_ID             = A.ITEM_ID
                                         AND B.P_LINE_ID             = A.LINE_ID
                                         AND B.P_OPERATION_ID        = A.OPERATION_ID
                                         AND B.P_MEASURE             = A.MEASURE
                                         AND B.P_YYYYMMDD            = A.YYYYMMDD
                                         AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-')
                                         AND ROWNUM = 1)
              /* 파티션 프루닝 - 저장 대상 주차 범위를 상수로 준다(서브쿼리 IN 은 프루닝되지 않는다) */
         WHERE A.PLAN_START_YYYYMMDD_DATE BETWEEN TO_DATE(V_MIN_PLAN_START, 'YYYYMMDD')
                                              AND TO_DATE(V_MAX_PLAN_START, 'YYYYMMDD')
           AND EXISTS (SELECT 1
                         FROM GT_0013_DYN B
                        WHERE B.P_DIVISION_ID         = A.DIVISION_ID
                          AND B.P_PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                          AND B.P_PLAN_TYPE           = A.PLAN_TYPE
                          AND B.P_SEQ                 = A.SEQ
                          AND B.P_OPERATION_GROUP     = A.OPERATION_GROUP
                          AND B.P_SCM_SITE_ID         = A.SCM_SITE_ID
                          AND B.P_ITEM_ID             = A.ITEM_ID
                          AND B.P_LINE_ID             = A.LINE_ID
                          AND B.P_OPERATION_ID        = A.OPERATION_ID
                          AND B.P_MEASURE             = A.MEASURE
                          AND B.P_YYYYMMDD            = A.YYYYMMDD
                          AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-'));

        /* 이력저장 */
        P_SCP_PROD_PLAN_HIST_DS;

        /* Fix Data 수정 */
        UPDATE SCP_ANL_PRODUCTION_PLAN_FIX A
           SET (A.QTY
               ,A.LAST_UPDATE_DATE
               ,A.LAST_UPDATED_BY) = (SELECT B.P_QTY
                                           , SYSDATE
                                           , B.P_USER_ID
                                        FROM GT_0013_DYN B
                                       WHERE B.P_DIVISION_ID     = A.DIVISION_ID
                                         AND B.P_OPERATION_GROUP = A.OPERATION_GROUP
                                         AND B.P_SCM_SITE_ID     = A.SCM_SITE_ID
                                         AND B.P_ITEM_ID         = A.ITEM_ID
                                         AND B.P_LINE_ID         = A.LINE_ID
                                         AND B.P_OPERATION_ID    = A.OPERATION_ID
                                         AND B.P_YYYYMMDD        = A.YYYYMMDD
                                         AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-')
                                         AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_0013_DYN B
                        WHERE B.P_DIVISION_ID     = A.DIVISION_ID
                          AND B.P_OPERATION_GROUP = A.OPERATION_GROUP
                          AND B.P_SCM_SITE_ID     = A.SCM_SITE_ID
                          AND B.P_ITEM_ID         = A.ITEM_ID
                          AND B.P_LINE_ID         = A.LINE_ID
                          AND B.P_OPERATION_ID    = A.OPERATION_ID
                          AND B.P_YYYYMMDD        = A.YYYYMMDD
                          AND NVL(B.P_ELECTRODE_TYPE, '-') = NVL(A.ELECTRODE_TYPE, '-'));

        /* Fix 이력저장 */
        P_SCP_PROD_PLAN_FIX_HIST_DS;

        /* 임시 운영반영시에 주석처리 할것. */
        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC((SYSDATE - V_START_TIME) * 86400 / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '['||V_EXEC_TIME||']';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        DELETE GT_0013_JV_LINE_MAP;
        DELETE GT_0013_JV_SITE_MAP;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR
        SELECT 'S'  AS RESULT_CODE
             , 1    AS RESULT_CNT
          FROM DUAL;

        OPEN O_RC2 FOR
        SELECT NULL AS ERR_CODE
             , NULL AS ERR_MESSAGE
          FROM DUAL
         WHERE 1 = 2;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;
            V_ERR_TRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            ROLLBACK;

            INSERT INTO SCM_SYS_LOG_BATCH
                 (
                   PROGRAM_NAME
                  ,LOG_TYPE
                  ,LOG_COUNT
                  ,LOG_MESSAGE
                  ,DESCRIPTION
                  ,EVENT_DATE
                  ,CREATION_DATE
                  ,CREATED_BY
                  ,LAST_UPDATE_DATE
                  ,LAST_UPDATED_BY
                 )
            VALUES
                 (
                   V_PROGRAM_NAME
                  ,'ERROR'
                  ,NULL
                  ,V_ERR_MESSAGE
                  ,V_ERR_TRACE
                  ,SYSDATE
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                  ,SYSDATE
                  ,V_PROGRAM_NAME
                 );
            COMMIT;

            OPEN O_RC1 FOR
            SELECT 'F'  AS RESULT_CODE
                 , 0    AS RESULT_CNT
              FROM DUAL;

            /* 에러 메시지, 에러 데이터  반환 */
            OPEN O_RC2 FOR
            SELECT TO_CHAR(V_ERR_CODE)  AS ERR_CODE
                 , V_ERR_MESSAGE        AS ERR_MESSAGE
              FROM DUAL;

    END P_SCP0013_SAVE_LINE_ROW_DS;


    /* ========================================================================================
       11. SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET - JSON 입력 (2026.09.17 AJS)
           입력 P_DATA : JSON 배열. 행마다 아래 키(대문자)를 싣는다. 형식 테이블 T_SCP0013_ROW 칸과 같다.
           -- 2026.09.17 AJS AS-IS 형식 테이블 이름(p_active_flag · P_ACTIVE_FLAG 등, A 는 A · a)도 받는다 (START/END)
             A · ACTIVE_FLAG · DIVISION_ID · PLAN_START_YYYYMMDD · PLAN_TYPE · SEQ · OPERATION_GROUP ·
             SCM_SITE_ID · ITEM_ID · LINE_ID · OPERATION_ID · MEASURE · YYYYMMDD · QTY · FIX_REASON ·
             FIX · LOC_FLAG · PROGRAM_ID · ORIGIN_DIVISION_ID · ELECTRODE_TYPE · BUCKET_TYPE ·
             FROM_YYYYMMDD · TO_YYYYMMDD
           등록자 : P_USER_ID (AS-IS 행별 p_user_id - 화면이 모든 행에 로그인 사용자를 싣는다)
       ======================================================================================== */
    PROCEDURE P_SCP0013_SAVE_LINE_ROW_JSON
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    /*
     * Program ID   : SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_DATASET (JSON 입력)
     * Description  : JSON 배열을 T_SCP0013_TAB 로 바꿔 P_SCP0013_SAVE_LINE_ROW_DS 호출
     *                화면 서버 프로시저 호출은 VARCHAR · NUMBER · CLOB · DATE 인자만 넘기므로 입력 창구를 둔다
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.17   AJS            신규 - 결과는 PKG_SCP0024.P_SCP0024_SAVE_PLAN_FIX_DS 와 같은 형식
     *                              (O_RESULT_CODE S/F · O_RESULT_CNT · O_RESULT_MSG)
     * 2026.10.07   AJS            화면 줄(피벗) 형식 입력 수용 - D_ · W_ 기간 칸을 칸 단위로 풀어 원장과 다른 칸만 저장 (화면검증)
     */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0013_SAVE_PRODUCTION_PLAN_LINE_ROW_JSON';

        V_SCP0013           T_SCP0013_TAB;
        C_RC1               SYS_REFCURSOR;
        C_RC2               SYS_REFCURSOR;
        V_RESULT_CODE       VARCHAR2(10 CHAR);
        N_RESULT_CNT        NUMBER;
        V_ERR_CODE          VARCHAR2(100 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        /* 2026.10.07 AJS 화면검증 - 화면 줄(피벗) 형식 입력 변수 (START) */
        L_ARR               JSON_ARRAY_T;
        L_ELEM              JSON_ELEMENT_T;
        L_OBJ               JSON_OBJECT_T;
        L_KEYS              JSON_KEY_LIST;
        V_KEY               VARCHAR2(4000 CHAR);
        V_TPL               T_SCP0013_ROW;
        V_CELL              T_SCP0013_TAB      := T_SCP0013_TAB();
        V_IS_PIVOT          VARCHAR2(1 CHAR)   := 'N';
        V_FIX_MODE          VARCHAR2(1 CHAR);
        V_PV_BUCKET         VARCHAR2(10 CHAR);
        V_PV_FROM_ROW       VARCHAR2(8 CHAR);
        V_PV_TO_ROW         VARCHAR2(8 CHAR);
        V_PV_FROM           VARCHAR2(8 CHAR);
        V_PV_TO             VARCHAR2(8 CHAR);
        V_PV_MIN_PS         VARCHAR2(8 CHAR);
        V_PV_MAX_PS         VARCHAR2(8 CHAR);

        /* JSON 객체 값 읽기 - 키는 대문자 우선, 없으면 소문자 · 숫자 값은 문자로 */
        FUNCTION F_JSON_VAL
        (
            P_OBJ               IN  JSON_OBJECT_T,
            P_KEY               IN  VARCHAR2
        )
        RETURN VARCHAR2
        IS
            V_JKEY              VARCHAR2(4000 CHAR);
            V_ELEM              JSON_ELEMENT_T;
        BEGIN

            IF P_OBJ.HAS(P_KEY) THEN
                V_JKEY := P_KEY;
            ELSIF P_OBJ.HAS(LOWER(P_KEY)) THEN
                V_JKEY := LOWER(P_KEY);
            ELSE
                RETURN NULL;
            END IF;

            V_ELEM := P_OBJ.GET(V_JKEY);

            IF V_ELEM IS NULL THEN
                RETURN NULL;
            ELSIF V_ELEM.IS_NULL() THEN
                RETURN NULL;
            ELSIF V_ELEM.IS_STRING() THEN
                RETURN P_OBJ.GET_STRING(V_JKEY);
            ELSIF V_ELEM.IS_SCALAR() THEN
                RETURN V_ELEM.TO_STRING();
            END IF;

            RETURN NULL;

        END F_JSON_VAL;
        /* 2026.10.07 AJS 화면검증 - 화면 줄(피벗) 형식 입력 변수 (END) */
    BEGIN

        O_RESULT_CODE := 'F';
        O_RESULT_CNT  := 0;
        O_RESULT_MSG  := NULL;

        /* 2026.10.07 AJS 화면검증 - 화면 줄(피벗) 형식을 칸 단위로 풀기 (START) */
        /* 화면은 그리드 줄을 그대로 보낸다 : 줄 구분 CRUD_TYPE(I/M/D) · 기간 칸 D_YYYYMMDD(일) · W_YYYYMMWW(주) · M_YYYYMM(월)
           칸 단위 키(YYYYMMDD · p_yyyymmdd · P_YYYYMMDD)가 있는 줄이 하나라도 있으면 기존 칸 단위 형식으로 처리한다
           AS-IS 화면 저장 규칙 : Daily(또는 ALL 체크) 는 일 칸, 그 외는 주 칸만 · 바뀐 칸만(빈 칸은 0) · 편집 시작일 이후 칸만 */
        IF     P_DATA IS NOT NULL
           AND DBMS_LOB.GETLENGTH(P_DATA) > 0 THEN

            V_IS_PIVOT := 'Y';
            L_ARR      := JSON_ARRAY_T.PARSE(P_DATA);

            FOR I IN 0 .. L_ARR.GET_SIZE() - 1 LOOP

                L_ELEM := L_ARR.GET(I);

                IF L_ELEM.IS_OBJECT() THEN

                    L_OBJ := TREAT(L_ELEM AS JSON_OBJECT_T);

                    IF    L_OBJ.HAS('YYYYMMDD')
                       OR L_OBJ.HAS('p_yyyymmdd')
                       OR L_OBJ.HAS('P_YYYYMMDD') THEN

                        V_IS_PIVOT := 'N';

                    ELSE

                        /* Fix/Unfix 표시 */
                        IF UPPER(F_JSON_VAL(L_OBJ, 'FIX')) IN ('F', 'U') THEN
                            V_FIX_MODE := UPPER(F_JSON_VAL(L_OBJ, 'FIX'));
                        END IF;

                        /* 줄 공통 값 - 계획 버전은 줄의 PLAN_START_YYYYMMDD · PLAN_TYPE · PLAN_SEQ(조회 결과 칸 이름) */
                        V_TPL := T_SCP0013_ROW(SUBSTR(F_JSON_VAL(L_OBJ, 'CRUD_TYPE'), 1, 1)        /* A */
                                             , SUBSTR(F_JSON_VAL(L_OBJ, 'CRUD_TYPE'), 1, 1)        /* ACTIVE_FLAG */
                                             , F_JSON_VAL(L_OBJ, 'DIVISION_ID')
                                             , F_JSON_VAL(L_OBJ, 'PLAN_START_YYYYMMDD')
                                             , F_JSON_VAL(L_OBJ, 'PLAN_TYPE')
                                             , NVL(F_JSON_VAL(L_OBJ, 'SEQ'), F_JSON_VAL(L_OBJ, 'PLAN_SEQ'))
                                             , F_JSON_VAL(L_OBJ, 'OPERATION_GROUP')
                                             , F_JSON_VAL(L_OBJ, 'SCM_SITE_ID')
                                             , F_JSON_VAL(L_OBJ, 'ITEM_ID')
                                             , F_JSON_VAL(L_OBJ, 'LINE_ID')
                                             , F_JSON_VAL(L_OBJ, 'OPERATION_ID')
                                             , F_JSON_VAL(L_OBJ, 'MEASURE')
                                             , NULL                                                /* YYYYMMDD - 칸마다 */
                                             , NULL                                                /* QTY - 칸마다 */
                                             , SUBSTR(F_JSON_VAL(L_OBJ, 'FIX_REASON'), 1, 100)
                                             , P_USER_ID
                                             , SUBSTR(F_JSON_VAL(L_OBJ, 'FIX'), 1, 1)
                                             , NULL                                                /* LOC_FLAG */
                                             , 'SCP0013'                                           /* PROGRAM_ID */
                                             , 'F'                                                 /* DEBUG_MODE */
                                             , F_JSON_VAL(L_OBJ, 'ORIGIN_DIVISION_ID')
                                             , F_JSON_VAL(L_OBJ, 'ELECTRODE_TYPE')
                                             , NULL                                                /* BUCKET_TYPE - 칸마다 */
                                             , SUBSTR(F_JSON_VAL(L_OBJ, 'FROM_YYYYMMDD'), 1, 8)
                                             , SUBSTR(F_JSON_VAL(L_OBJ, 'TO_YYYYMMDD'), 1, 8));

                        /* 기간 칸(D_ · W_)을 한 칸씩 풀기 - M_(월 합계)은 AS-IS 저장 대상이 아니다 */
                        L_KEYS := L_OBJ.GET_KEYS();

                        IF L_KEYS IS NOT NULL THEN
                            FOR J IN 1 .. L_KEYS.COUNT LOOP

                                V_KEY := L_KEYS(J);

                                IF REGEXP_LIKE(V_KEY, '^[DdWw]_[0-9]{8}$') THEN
                                    V_TPL.P_YYYYMMDD    := SUBSTR(V_KEY, 3, 8);
                                    V_TPL.P_QTY         := SUBSTR(F_JSON_VAL(L_OBJ, V_KEY), 1, 200);
                                    V_TPL.P_BUCKET_TYPE := CASE UPPER(SUBSTR(V_KEY, 1, 1))
                                                               WHEN 'D' THEN 'DAILY'
                                                               ELSE 'WEEKLY'
                                                           END;
                                    V_CELL.EXTEND;
                                    V_CELL(V_CELL.COUNT) := V_TPL;
                                END IF;

                            END LOOP;
                        END IF;

                    END IF;

                END IF;

            END LOOP;

        END IF;

        IF V_IS_PIVOT = 'Y' THEN

            /* Fix/Unfix 는 AS-IS 가 화면에서 선택한 저장된 칸 단위로 처리한다(SCP0024_SAVE_PRODUCTION_PLAN_FIX_DATASET).
               저장하지 않은 칸은 Fix 불가 · 줄 단위 입력에는 선택 칸 정보가 없어 처리하지 않는다 */
            IF V_FIX_MODE IS NOT NULL THEN
                O_RESULT_CODE := 'F';
                O_RESULT_CNT  := 0;
                O_RESULT_MSG  := 'Fix/Unfix : 저장된 칸을 선택해 처리합니다. 수정 내용을 먼저 저장하십시오. (Save changes first, then select saved cells.)';
                RETURN;
            END IF;

            /* 버킷 판정 - 일 칸(D_)이 있으면 DAILY(AS-IS : Daily 또는 ALL 체크 시 일 칸 저장), 없으면 WEEKLY(주 칸 저장) */
            SELECT CASE
                       WHEN COUNT(CASE WHEN P_BUCKET_TYPE = 'DAILY' THEN 1 END) > 0
                       THEN 'DAILY'
                       ELSE 'WEEKLY'
                   END
                 , MAX(P_FROM_YYYYMMDD)
                 , MAX(P_TO_YYYYMMDD)
                 , MIN(P_PLAN_START_YYYYMMDD)
                 , MAX(P_PLAN_START_YYYYMMDD)
              INTO V_PV_BUCKET
                 , V_PV_FROM_ROW
                 , V_PV_TO_ROW
                 , V_PV_MIN_PS
                 , V_PV_MAX_PS
              FROM TABLE(V_CELL);

            /* 조회 기간 - 줄의 FROM_YYYYMMDD 우선. 종료일은 줄에 없으면 칸에서 구한다(주 칸은 마지막 주 구간의 끝 날짜) */
            IF V_PV_BUCKET = 'DAILY' THEN

                SELECT MIN(P_YYYYMMDD)
                     , MAX(P_YYYYMMDD)
                  INTO V_PV_FROM
                     , V_PV_TO
                  FROM TABLE(V_CELL)
                 WHERE P_BUCKET_TYPE = 'DAILY';

            ELSE

                SELECT MIN(A.BASIS_YYYYMMDD)
                     , MAX(A.BASIS_YYYYMMDD)
                  INTO V_PV_FROM
                     , V_PV_TO
                  FROM SCM_SYS_CALENDAR_M A
                 WHERE A.BASIS_YYYYMM||A.ISO_WEEK IN (SELECT XA.P_YYYYMMDD
                                                        FROM TABLE(V_CELL) XA
                                                       WHERE XA.P_BUCKET_TYPE = 'WEEKLY');

            END IF;

            V_PV_FROM := NVL(V_PV_FROM_ROW, V_PV_FROM);
            V_PV_TO   := NVL(V_PV_TO_ROW, V_PV_TO);

            /* 저장 대상 칸 - 원장 값과 다른 칸만(바뀌지 않은 칸 제외)
               편집 시작일 = MAX(조회 시작일, 계획 시작일 + OFFSET) · OFFSET 은 81 사업부 SE 계획만 사이트 PROD_FROZEN (P_SCP0013_GET_PLAN_EDIT_INFO 와 같은 식)
               주 칸은 그 주 구간(BASIS_YYYYMM + ISO_WEEK, 조회 기간 안)의 첫 날짜가 편집 시작일 이후여야 한다 */
            SELECT T_SCP0013_ROW(A.A
                               , A.P_ACTIVE_FLAG
                               , A.P_DIVISION_ID
                               , A.P_PLAN_START_YYYYMMDD
                               , A.P_PLAN_TYPE
                               , A.P_SEQ
                               , A.P_OPERATION_GROUP
                               , A.P_SCM_SITE_ID
                               , A.P_ITEM_ID
                               , A.P_LINE_ID
                               , A.P_OPERATION_ID
                               , A.P_MEASURE
                               , A.P_YYYYMMDD
                               , TO_CHAR(A.QTY_NUM)
                               , A.P_FIX_REASON
                               , A.P_USER_ID
                               , NULL
                               , NULL
                               , A.P_PROGRAM_ID
                               , A.DEBUG_MODE
                               , A.P_ORIGIN_DIVISION_ID
                               , A.P_ELECTRODE_TYPE
                               , V_PV_BUCKET
                               , V_PV_FROM
                               , V_PV_TO)
              BULK COLLECT INTO V_SCP0013
              FROM (SELECT IA.A
                         , IA.P_ACTIVE_FLAG
                         , IA.P_DIVISION_ID
                         , IA.P_PLAN_START_YYYYMMDD
                         , IA.P_PLAN_TYPE
                         , IA.P_SEQ
                         , IA.P_OPERATION_GROUP
                         , IA.P_SCM_SITE_ID
                         , IA.P_ITEM_ID
                         , IA.P_LINE_ID
                         , IA.P_OPERATION_ID
                         , IA.P_MEASURE
                         , IA.P_YYYYMMDD
                         , NVL(TO_NUMBER(REPLACE(IA.P_QTY, ',', '')), 0)                          AS QTY_NUM          /* 빈 칸은 0 (AS-IS) */
                         , IA.P_FIX_REASON
                         , IA.P_USER_ID
                         , IA.P_PROGRAM_ID
                         , IA.DEBUG_MODE
                         , IA.P_ORIGIN_DIVISION_ID
                         , IA.P_ELECTRODE_TYPE
                         , CASE
                               WHEN V_PV_BUCKET = 'DAILY'
                               THEN IA.P_YYYYMMDD
                               ELSE (SELECT MIN(SA.BASIS_YYYYMMDD)
                                       FROM SCM_SYS_CALENDAR_M SA
                                      WHERE SA.BASIS_YYYYMM||SA.ISO_WEEK = IA.P_YYYYMMDD
                                        AND SA.BASIS_YYYYMMDD BETWEEN V_PV_FROM AND V_PV_TO)
                           END                                                                    AS CELL_FROM        /* 칸 첫 날짜 */
                         , CASE
                               WHEN V_PV_BUCKET = 'DAILY'
                               THEN IA.P_YYYYMMDD
                               ELSE (SELECT MAX(SC.BASIS_YYYYMMDD)
                                       FROM SCM_SYS_CALENDAR_M SC
                                      WHERE SC.BASIS_YYYYMM||SC.ISO_WEEK = IA.P_YYYYMMDD
                                        AND SC.BASIS_YYYYMMDD BETWEEN V_PV_FROM AND V_PV_TO)
                           END                                                                    AS CELL_TO          /* 칸 끝 날짜 */
                         , TO_CHAR(TO_DATE(IA.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                                   + CASE
                                         WHEN     IA.P_DIVISION_ID = '81'
                                              AND IA.P_PLAN_TYPE   = 'SE'
                                         THEN NVL((SELECT MAX(SD.PROD_FROZEN)
                                                     FROM SCM_MST_SITE SD
                                                    WHERE SD.DIVISION_ID = IA.P_DIVISION_ID
                                                      AND SD.SCM_SITE_ID = IA.P_SCM_SITE_ID), 0)
                                         ELSE 0
                                     END, 'YYYYMMDD')                                             AS EDIT_START_DATE  /* 계획 편집 시작일 */
                      FROM TABLE(V_CELL) IA
                     WHERE 1 = 1
                       AND IA.P_BUCKET_TYPE = V_PV_BUCKET
                       AND IA.A            IN ('I', 'M', 'D')
                       AND IA.P_MEASURE     = 'PROD_PLAN_AMEND') A
             WHERE 1 = 1
               AND A.QTY_NUM != NVL((SELECT SUM(SB.QTY)
                                       FROM SCP_ANL_PRODUCTION_PLAN SB
                                      WHERE SB.DIVISION_ID          = A.P_DIVISION_ID
                                        AND SB.PLAN_START_YYYYMMDD  = A.P_PLAN_START_YYYYMMDD
                                        AND SB.PLAN_TYPE            = A.P_PLAN_TYPE
                                        AND SB.SEQ                  = TO_NUMBER(A.P_SEQ)
                                        AND SB.OPERATION_GROUP      = A.P_OPERATION_GROUP
                                        AND SB.SCM_SITE_ID          = A.P_SCM_SITE_ID
                                        AND SB.ITEM_ID              = A.P_ITEM_ID
                                        AND SB.LINE_ID              = A.P_LINE_ID
                                        AND SB.OPERATION_ID         = A.P_OPERATION_ID
                                        AND SB.MEASURE              = A.P_MEASURE
                                        AND SB.YYYYMMDD       BETWEEN A.CELL_FROM AND A.CELL_TO
                                        AND NVL(SB.ORIGIN_DIVISION_ID, '-') = NVL(A.P_ORIGIN_DIVISION_ID, '-')
                                        AND NVL(SB.ELECTRODE_TYPE, '-')     = NVL(A.P_ELECTRODE_TYPE, '-')
                                            /* 파티션 프루닝 - 저장 대상 주차 범위를 상수로 준다 */
                                        AND SB.PLAN_START_YYYYMMDD_DATE BETWEEN TO_DATE(V_PV_MIN_PS, 'YYYYMMDD')
                                                                            AND TO_DATE(V_PV_MAX_PS, 'YYYYMMDD')), 0)
               AND A.CELL_FROM >= GREATEST(NVL(V_PV_FROM_ROW, '00000000'), A.EDIT_START_DATE)
             ORDER BY A.P_SCM_SITE_ID
                    , A.P_LINE_ID
                    , A.P_OPERATION_ID
                    , A.P_ITEM_ID
                    , A.P_YYYYMMDD;

            /* 이력 저장 처음 · 마지막 표시 (AS-IS p_loc_flag F/L) */
            IF V_SCP0013.COUNT > 0 THEN
                V_SCP0013(1).P_LOC_FLAG                := 'F';
                V_SCP0013(V_SCP0013.COUNT).P_LOC_FLAG  := 'L';
            END IF;

            /* 바뀐 칸이 없으면 저장하지 않는다 (AS-IS : 저장 대상 0건이면 저장 프로시저를 부르지 않음) */
            IF V_SCP0013.COUNT = 0 THEN
                O_RESULT_CODE := 'S';
                O_RESULT_CNT  := 0;
                O_RESULT_MSG  := NULL;
                RETURN;
            END IF;

        ELSE
        /* 2026.10.07 AJS 화면검증 - 화면 줄(피벗) 형식을 칸 단위로 풀기 (END) */

        /* JSON 배열 -> 형식 테이블 (길이 초과 · 형식 오류는 오류 처리) */
--        SELECT T_SCP0013_ROW(JT.A
--                           , JT.ACTIVE_FLAG
--                           , JT.DIVISION_ID
--                           , JT.PLAN_START_YYYYMMDD
--                           , JT.PLAN_TYPE
--                           , JT.SEQ
--                           , JT.OPERATION_GROUP
--                           , JT.SCM_SITE_ID
--                           , JT.ITEM_ID
--                           , JT.LINE_ID
--                           , JT.OPERATION_ID
--                           , JT.MEASURE
--                           , JT.YYYYMMDD
--                           , JT.QTY
--                           , JT.FIX_REASON
--                           , P_USER_ID
--                           , JT.FIX
--                           , JT.LOC_FLAG
--                           , JT.PROGRAM_ID
--                           , 'F'
--                           , JT.ORIGIN_DIVISION_ID
--                           , JT.ELECTRODE_TYPE
--                           , JT.BUCKET_TYPE
--                           , JT.FROM_YYYYMMDD
--                           , JT.TO_YYYYMMDD)
--          BULK COLLECT INTO V_SCP0013
--          FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR
--                   COLUMNS (
--                       A                    VARCHAR2(1 CHAR)    PATH '$.A'                   NULL ON EMPTY ERROR ON ERROR
--                     , ACTIVE_FLAG          VARCHAR2(1 CHAR)    PATH '$.ACTIVE_FLAG'         NULL ON EMPTY ERROR ON ERROR
--                     , DIVISION_ID          VARCHAR2(30 CHAR)   PATH '$.DIVISION_ID'         NULL ON EMPTY ERROR ON ERROR
--                     , PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)    PATH '$.PLAN_START_YYYYMMDD' NULL ON EMPTY ERROR ON ERROR
--                     , PLAN_TYPE            VARCHAR2(2 CHAR)    PATH '$.PLAN_TYPE'           NULL ON EMPTY ERROR ON ERROR
--                     , SEQ                  VARCHAR2(10 CHAR)   PATH '$.SEQ'                 NULL ON EMPTY ERROR ON ERROR
--                     , OPERATION_GROUP      VARCHAR2(1 CHAR)    PATH '$.OPERATION_GROUP'     NULL ON EMPTY ERROR ON ERROR
--                     , SCM_SITE_ID          VARCHAR2(100 CHAR)  PATH '$.SCM_SITE_ID'         NULL ON EMPTY ERROR ON ERROR
--                     , ITEM_ID              VARCHAR2(100 CHAR)  PATH '$.ITEM_ID'             NULL ON EMPTY ERROR ON ERROR
--                     , LINE_ID              VARCHAR2(50 CHAR)   PATH '$.LINE_ID'             NULL ON EMPTY ERROR ON ERROR
--                     , OPERATION_ID         VARCHAR2(100 CHAR)  PATH '$.OPERATION_ID'        NULL ON EMPTY ERROR ON ERROR
--                     , MEASURE              VARCHAR2(100 CHAR)  PATH '$.MEASURE'             NULL ON EMPTY ERROR ON ERROR
--                     , YYYYMMDD             VARCHAR2(8 CHAR)    PATH '$.YYYYMMDD'            NULL ON EMPTY ERROR ON ERROR
--                     , QTY                  VARCHAR2(200 CHAR)  PATH '$.QTY'                 NULL ON EMPTY ERROR ON ERROR
--                     , FIX_REASON           VARCHAR2(100 CHAR)  PATH '$.FIX_REASON'          NULL ON EMPTY ERROR ON ERROR
--                     , FIX                  VARCHAR2(1 CHAR)    PATH '$.FIX'                 NULL ON EMPTY ERROR ON ERROR
--                     , LOC_FLAG             VARCHAR2(1 CHAR)    PATH '$.LOC_FLAG'            NULL ON EMPTY ERROR ON ERROR
--                     , PROGRAM_ID           VARCHAR2(200 CHAR)  PATH '$.PROGRAM_ID'          NULL ON EMPTY ERROR ON ERROR
--                     , ORIGIN_DIVISION_ID   VARCHAR2(30 CHAR)   PATH '$.ORIGIN_DIVISION_ID'  NULL ON EMPTY ERROR ON ERROR
--                     , ELECTRODE_TYPE       VARCHAR2(50 CHAR)   PATH '$.ELECTRODE_TYPE'      NULL ON EMPTY ERROR ON ERROR
--                     , BUCKET_TYPE          VARCHAR2(10 CHAR)   PATH '$.BUCKET_TYPE'         NULL ON EMPTY ERROR ON ERROR
--                     , FROM_YYYYMMDD        VARCHAR2(8 CHAR)    PATH '$.FROM_YYYYMMDD'       NULL ON EMPTY ERROR ON ERROR
--                     , TO_YYYYMMDD          VARCHAR2(8 CHAR)    PATH '$.TO_YYYYMMDD'         NULL ON EMPTY ERROR ON ERROR
--                   )) JT;
        -- 2026.09.17 AJS JSON 키 - AS-IS 형식 테이블 이름(p_xxx · P_XXX)도 받음 (START)
        /* 키 우선순위 : XXX > p_xxx > P_XXX , 등록자는 P_USER_ID 우선 */
        SELECT T_SCP0013_ROW(NVL(JT.A1, JT.A2)
                           , COALESCE(JT.ACTIVE_FLAG_1, JT.ACTIVE_FLAG_2, JT.ACTIVE_FLAG_3)
                           , COALESCE(JT.DIVISION_ID_1, JT.DIVISION_ID_2, JT.DIVISION_ID_3)
                           , COALESCE(JT.PLAN_START_YYYYMMDD_1, JT.PLAN_START_YYYYMMDD_2, JT.PLAN_START_YYYYMMDD_3)
                           , COALESCE(JT.PLAN_TYPE_1, JT.PLAN_TYPE_2, JT.PLAN_TYPE_3)
                           , COALESCE(JT.SEQ_1, JT.SEQ_2, JT.SEQ_3)
                           , COALESCE(JT.OPERATION_GROUP_1, JT.OPERATION_GROUP_2, JT.OPERATION_GROUP_3)
                           , COALESCE(JT.SCM_SITE_ID_1, JT.SCM_SITE_ID_2, JT.SCM_SITE_ID_3)
                           , COALESCE(JT.ITEM_ID_1, JT.ITEM_ID_2, JT.ITEM_ID_3)
                           , COALESCE(JT.LINE_ID_1, JT.LINE_ID_2, JT.LINE_ID_3)
                           , COALESCE(JT.OPERATION_ID_1, JT.OPERATION_ID_2, JT.OPERATION_ID_3)
                           , COALESCE(JT.MEASURE_1, JT.MEASURE_2, JT.MEASURE_3)
                           , COALESCE(JT.YYYYMMDD_1, JT.YYYYMMDD_2, JT.YYYYMMDD_3)
                           , COALESCE(JT.QTY_1, JT.QTY_2, JT.QTY_3)
                           , COALESCE(JT.FIX_REASON_1, JT.FIX_REASON_2, JT.FIX_REASON_3)
                           , NVL(P_USER_ID, COALESCE(JT.USER_ID_2, JT.USER_ID_3))
                           , COALESCE(JT.FIX_1, JT.FIX_2, JT.FIX_3)
                           , COALESCE(JT.LOC_FLAG_1, JT.LOC_FLAG_2, JT.LOC_FLAG_3)
                           , COALESCE(JT.PROGRAM_ID_1, JT.PROGRAM_ID_2, JT.PROGRAM_ID_3)
                           , 'F'
                           , COALESCE(JT.ORIGIN_DIVISION_ID_1, JT.ORIGIN_DIVISION_ID_2, JT.ORIGIN_DIVISION_ID_3)
                           , COALESCE(JT.ELECTRODE_TYPE_1, JT.ELECTRODE_TYPE_2, JT.ELECTRODE_TYPE_3)
                           , COALESCE(JT.BUCKET_TYPE_1, JT.BUCKET_TYPE_2, JT.BUCKET_TYPE_3)
                           , COALESCE(JT.FROM_YYYYMMDD_1, JT.FROM_YYYYMMDD_2, JT.FROM_YYYYMMDD_3)
                           , COALESCE(JT.TO_YYYYMMDD_1, JT.TO_YYYYMMDD_2, JT.TO_YYYYMMDD_3))
          BULK COLLECT INTO V_SCP0013
          FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR
                   COLUMNS (
                       A1                     VARCHAR2(1 CHAR)        PATH '$.A'                          NULL ON EMPTY ERROR ON ERROR
                     , A2                     VARCHAR2(1 CHAR)        PATH '$.a'                          NULL ON EMPTY ERROR ON ERROR
                     , ACTIVE_FLAG_1          VARCHAR2(1 CHAR)        PATH '$.ACTIVE_FLAG'                NULL ON EMPTY ERROR ON ERROR
                     , ACTIVE_FLAG_2          VARCHAR2(1 CHAR)        PATH '$.p_active_flag'              NULL ON EMPTY ERROR ON ERROR
                     , ACTIVE_FLAG_3          VARCHAR2(1 CHAR)        PATH '$.P_ACTIVE_FLAG'              NULL ON EMPTY ERROR ON ERROR
                     , DIVISION_ID_1          VARCHAR2(30 CHAR)       PATH '$.DIVISION_ID'                NULL ON EMPTY ERROR ON ERROR
                     , DIVISION_ID_2          VARCHAR2(30 CHAR)       PATH '$.p_division_id'              NULL ON EMPTY ERROR ON ERROR
                     , DIVISION_ID_3          VARCHAR2(30 CHAR)       PATH '$.P_DIVISION_ID'              NULL ON EMPTY ERROR ON ERROR
                     , PLAN_START_YYYYMMDD_1  VARCHAR2(8 CHAR)        PATH '$.PLAN_START_YYYYMMDD'        NULL ON EMPTY ERROR ON ERROR
                     , PLAN_START_YYYYMMDD_2  VARCHAR2(8 CHAR)        PATH '$.p_plan_start_yyyymmdd'      NULL ON EMPTY ERROR ON ERROR
                     , PLAN_START_YYYYMMDD_3  VARCHAR2(8 CHAR)        PATH '$.P_PLAN_START_YYYYMMDD'      NULL ON EMPTY ERROR ON ERROR
                     , PLAN_TYPE_1            VARCHAR2(2 CHAR)        PATH '$.PLAN_TYPE'                  NULL ON EMPTY ERROR ON ERROR
                     , PLAN_TYPE_2            VARCHAR2(2 CHAR)        PATH '$.p_plan_type'                NULL ON EMPTY ERROR ON ERROR
                     , PLAN_TYPE_3            VARCHAR2(2 CHAR)        PATH '$.P_PLAN_TYPE'                NULL ON EMPTY ERROR ON ERROR
                     , SEQ_1                  VARCHAR2(10 CHAR)       PATH '$.SEQ'                        NULL ON EMPTY ERROR ON ERROR
                     , SEQ_2                  VARCHAR2(10 CHAR)       PATH '$.p_seq'                      NULL ON EMPTY ERROR ON ERROR
                     , SEQ_3                  VARCHAR2(10 CHAR)       PATH '$.P_SEQ'                      NULL ON EMPTY ERROR ON ERROR
                     , OPERATION_GROUP_1      VARCHAR2(1 CHAR)        PATH '$.OPERATION_GROUP'            NULL ON EMPTY ERROR ON ERROR
                     , OPERATION_GROUP_2      VARCHAR2(1 CHAR)        PATH '$.p_operation_group'          NULL ON EMPTY ERROR ON ERROR
                     , OPERATION_GROUP_3      VARCHAR2(1 CHAR)        PATH '$.P_OPERATION_GROUP'          NULL ON EMPTY ERROR ON ERROR
                     , SCM_SITE_ID_1          VARCHAR2(100 CHAR)      PATH '$.SCM_SITE_ID'                NULL ON EMPTY ERROR ON ERROR
                     , SCM_SITE_ID_2          VARCHAR2(100 CHAR)      PATH '$.p_scm_site_id'              NULL ON EMPTY ERROR ON ERROR
                     , SCM_SITE_ID_3          VARCHAR2(100 CHAR)      PATH '$.P_SCM_SITE_ID'              NULL ON EMPTY ERROR ON ERROR
                     , ITEM_ID_1              VARCHAR2(100 CHAR)      PATH '$.ITEM_ID'                    NULL ON EMPTY ERROR ON ERROR
                     , ITEM_ID_2              VARCHAR2(100 CHAR)      PATH '$.p_item_id'                  NULL ON EMPTY ERROR ON ERROR
                     , ITEM_ID_3              VARCHAR2(100 CHAR)      PATH '$.P_ITEM_ID'                  NULL ON EMPTY ERROR ON ERROR
                     , LINE_ID_1              VARCHAR2(50 CHAR)       PATH '$.LINE_ID'                    NULL ON EMPTY ERROR ON ERROR
                     , LINE_ID_2              VARCHAR2(50 CHAR)       PATH '$.p_line_id'                  NULL ON EMPTY ERROR ON ERROR
                     , LINE_ID_3              VARCHAR2(50 CHAR)       PATH '$.P_LINE_ID'                  NULL ON EMPTY ERROR ON ERROR
                     , OPERATION_ID_1         VARCHAR2(100 CHAR)      PATH '$.OPERATION_ID'               NULL ON EMPTY ERROR ON ERROR
                     , OPERATION_ID_2         VARCHAR2(100 CHAR)      PATH '$.p_operation_id'             NULL ON EMPTY ERROR ON ERROR
                     , OPERATION_ID_3         VARCHAR2(100 CHAR)      PATH '$.P_OPERATION_ID'             NULL ON EMPTY ERROR ON ERROR
                     , MEASURE_1              VARCHAR2(100 CHAR)      PATH '$.MEASURE'                    NULL ON EMPTY ERROR ON ERROR
                     , MEASURE_2              VARCHAR2(100 CHAR)      PATH '$.p_measure'                  NULL ON EMPTY ERROR ON ERROR
                     , MEASURE_3              VARCHAR2(100 CHAR)      PATH '$.P_MEASURE'                  NULL ON EMPTY ERROR ON ERROR
                     , YYYYMMDD_1             VARCHAR2(8 CHAR)        PATH '$.YYYYMMDD'                   NULL ON EMPTY ERROR ON ERROR
                     , YYYYMMDD_2             VARCHAR2(8 CHAR)        PATH '$.p_yyyymmdd'                 NULL ON EMPTY ERROR ON ERROR
                     , YYYYMMDD_3             VARCHAR2(8 CHAR)        PATH '$.P_YYYYMMDD'                 NULL ON EMPTY ERROR ON ERROR
                     , QTY_1                  VARCHAR2(200 CHAR)      PATH '$.QTY'                        NULL ON EMPTY ERROR ON ERROR
                     , QTY_2                  VARCHAR2(200 CHAR)      PATH '$.p_qty'                      NULL ON EMPTY ERROR ON ERROR
                     , QTY_3                  VARCHAR2(200 CHAR)      PATH '$.P_QTY'                      NULL ON EMPTY ERROR ON ERROR
                     , FIX_REASON_1           VARCHAR2(100 CHAR)      PATH '$.FIX_REASON'                 NULL ON EMPTY ERROR ON ERROR
                     , FIX_REASON_2           VARCHAR2(100 CHAR)      PATH '$.p_fix_reason'               NULL ON EMPTY ERROR ON ERROR
                     , FIX_REASON_3           VARCHAR2(100 CHAR)      PATH '$.P_FIX_REASON'               NULL ON EMPTY ERROR ON ERROR
                     , USER_ID_2              VARCHAR2(100 CHAR)      PATH '$.p_user_id'                  NULL ON EMPTY ERROR ON ERROR
                     , USER_ID_3              VARCHAR2(100 CHAR)      PATH '$.P_USER_ID'                  NULL ON EMPTY ERROR ON ERROR
                     , FIX_1                  VARCHAR2(1 CHAR)        PATH '$.FIX'                        NULL ON EMPTY ERROR ON ERROR
                     , FIX_2                  VARCHAR2(1 CHAR)        PATH '$.p_fix'                      NULL ON EMPTY ERROR ON ERROR
                     , FIX_3                  VARCHAR2(1 CHAR)        PATH '$.P_FIX'                      NULL ON EMPTY ERROR ON ERROR
                     , LOC_FLAG_1             VARCHAR2(1 CHAR)        PATH '$.LOC_FLAG'                   NULL ON EMPTY ERROR ON ERROR
                     , LOC_FLAG_2             VARCHAR2(1 CHAR)        PATH '$.p_loc_flag'                 NULL ON EMPTY ERROR ON ERROR
                     , LOC_FLAG_3             VARCHAR2(1 CHAR)        PATH '$.P_LOC_FLAG'                 NULL ON EMPTY ERROR ON ERROR
                     , PROGRAM_ID_1           VARCHAR2(200 CHAR)      PATH '$.PROGRAM_ID'                 NULL ON EMPTY ERROR ON ERROR
                     , PROGRAM_ID_2           VARCHAR2(200 CHAR)      PATH '$.p_program_id'               NULL ON EMPTY ERROR ON ERROR
                     , PROGRAM_ID_3           VARCHAR2(200 CHAR)      PATH '$.P_PROGRAM_ID'               NULL ON EMPTY ERROR ON ERROR
                     , ORIGIN_DIVISION_ID_1   VARCHAR2(30 CHAR)       PATH '$.ORIGIN_DIVISION_ID'         NULL ON EMPTY ERROR ON ERROR
                     , ORIGIN_DIVISION_ID_2   VARCHAR2(30 CHAR)       PATH '$.p_origin_division_id'       NULL ON EMPTY ERROR ON ERROR
                     , ORIGIN_DIVISION_ID_3   VARCHAR2(30 CHAR)       PATH '$.P_ORIGIN_DIVISION_ID'       NULL ON EMPTY ERROR ON ERROR
                     , ELECTRODE_TYPE_1       VARCHAR2(50 CHAR)       PATH '$.ELECTRODE_TYPE'             NULL ON EMPTY ERROR ON ERROR
                     , ELECTRODE_TYPE_2       VARCHAR2(50 CHAR)       PATH '$.p_electrode_type'           NULL ON EMPTY ERROR ON ERROR
                     , ELECTRODE_TYPE_3       VARCHAR2(50 CHAR)       PATH '$.P_ELECTRODE_TYPE'           NULL ON EMPTY ERROR ON ERROR
                     , BUCKET_TYPE_1          VARCHAR2(10 CHAR)       PATH '$.BUCKET_TYPE'                NULL ON EMPTY ERROR ON ERROR
                     , BUCKET_TYPE_2          VARCHAR2(10 CHAR)       PATH '$.p_bucket_type'              NULL ON EMPTY ERROR ON ERROR
                     , BUCKET_TYPE_3          VARCHAR2(10 CHAR)       PATH '$.P_BUCKET_TYPE'              NULL ON EMPTY ERROR ON ERROR
                     , FROM_YYYYMMDD_1        VARCHAR2(8 CHAR)        PATH '$.FROM_YYYYMMDD'              NULL ON EMPTY ERROR ON ERROR
                     , FROM_YYYYMMDD_2        VARCHAR2(8 CHAR)        PATH '$.p_from_yyyymmdd'            NULL ON EMPTY ERROR ON ERROR
                     , FROM_YYYYMMDD_3        VARCHAR2(8 CHAR)        PATH '$.P_FROM_YYYYMMDD'            NULL ON EMPTY ERROR ON ERROR
                     , TO_YYYYMMDD_1          VARCHAR2(8 CHAR)        PATH '$.TO_YYYYMMDD'                NULL ON EMPTY ERROR ON ERROR
                     , TO_YYYYMMDD_2          VARCHAR2(8 CHAR)        PATH '$.p_to_yyyymmdd'              NULL ON EMPTY ERROR ON ERROR
                     , TO_YYYYMMDD_3          VARCHAR2(8 CHAR)        PATH '$.P_TO_YYYYMMDD'              NULL ON EMPTY ERROR ON ERROR
                   )) JT;
        -- 2026.09.17 AJS JSON 키 - AS-IS 형식 테이블 이름(p_xxx · P_XXX)도 받음 (END)
        END IF;                                                 /* AJS 20261007 화면검증 */

        /* 저장 - 확정 · 오류 시 되돌림 · 오류 로그는 호출 프로시저가 처리 */
        P_SCP0013_SAVE_LINE_ROW_DS(V_SCP0013, C_RC1, C_RC2);

        FETCH C_RC1 INTO V_RESULT_CODE, N_RESULT_CNT;
        CLOSE C_RC1;

        FETCH C_RC2 INTO V_ERR_CODE, V_ERR_MESSAGE;
        CLOSE C_RC2;

        O_RESULT_CODE := V_RESULT_CODE;
        O_RESULT_CNT  := N_RESULT_CNT;
        O_RESULT_MSG  := CASE
                             WHEN V_ERR_CODE IS NOT NULL
                             THEN '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE
                         END;

        /* 화면 줄 형식은 저장한 칸 수를 돌려준다 (AS-IS 저장 결과 메시지 건수) */                 /* AJS 20261007 화면검증 */
        IF     V_IS_PIVOT    = 'Y'                                  /* AJS 20261007 화면검증 */
           AND O_RESULT_CODE = 'S' THEN                             /* AJS 20261007 화면검증 */
            O_RESULT_CNT := V_SCP0013.COUNT;                      /* AJS 20261007 화면검증 */
        END IF;                                                 /* AJS 20261007 화면검증 */

    EXCEPTION
        WHEN OTHERS THEN
            /* 저장 호출 전 단계(JSON 변환) 오류 - 원장 변경 없음 */
            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := 0;
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME
                                         , 'ERROR'
                                         , NULL
                                         , SUBSTR(O_RESULT_MSG, 1, 1000)
                                         , SUBSTR('P_USER_ID=' || P_USER_ID || ', P_DATA=' || DBMS_LOB.SUBSTR(P_DATA, 400, 1), 1, 500)
                                         , SYSDATE);

    END P_SCP0013_SAVE_LINE_ROW_JSON;

    -- 2026.09.17 AJS Extra Spec 조회조건 목록 추가 (START)
    /* ========================================================================================
       12. SCP0013_GET_EXTRA_SPEC - Extra Spec 조회조건 목록
       ======================================================================================== */
    PROCEDURE P_SCP0013_GET_EXTRA_SPEC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0013_GET_EXTRA_SPEC
     * Description  : Extra Spec 조회조건 정보 표시용
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2025/04/02   mrchois        PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - Extra Spec 조회조건 추가 표시
     * 2026.09.17   AJS            [MSSQL -> Oracle 전환]
     *                              - 사업부 비교 : AS-IS 대소문자 · 뒤 공백 무시 비교 재현 (UPPER · RTRIM)
     *                              - 정렬 : AS-IS 정렬 규칙(대소문자 무시 · 하이픈 무시) 재현
     */
    BEGIN

        OPEN O_RC1 FOR
        SELECT SCP_OPERATION_GROUP                          AS OPERATION_GROUP
             , NVL(SCP_EXTRA_SPEC, '-')                     AS CODE
             , NVL(SCP_EXTRA_SPEC, '-')                     AS NAME
          FROM SCM_MST_ITEM_SN
         WHERE 1 = 1
           AND DIVISION_ID = UPPER(RTRIM(P_DIVISION_ID))
         GROUP BY SCP_OPERATION_GROUP
                , SCP_EXTRA_SPEC
         ORDER BY UPPER(TRANSLATE(NVL(SCP_EXTRA_SPEC, '-'), '_-', '/')) NULLS FIRST
                , CODE;

    END P_SCP0013_GET_EXTRA_SPEC;
    -- 2026.09.17 AJS Extra Spec 조회조건 목록 추가 (END)

END PKG_SCP0013;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0013
