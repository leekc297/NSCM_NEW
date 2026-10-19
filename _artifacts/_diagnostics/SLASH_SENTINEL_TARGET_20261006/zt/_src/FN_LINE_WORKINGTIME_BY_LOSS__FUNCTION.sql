FUNCTION FN_LINE_WORKINGTIME_BY_LOSS
(
    P_DIVISION_ID       IN  VARCHAR2
   ,P_FROM_YYYYMMDD     IN  VARCHAR2
   ,P_TO_YYYYMMDD       IN  VARCHAR2
   ,P_LINE_ID           IN  VARCHAR2
)
RETURN T_FN_LINE_WORKTIME_TAB PIPELINED
IS
/*
 * Program ID   : FN_LINE_WORKINGTIME_BY_LOSS
 * Description  : 라인 별 Working Time (Loss Time 감안)
 * 실행 예제    : SELECT * FROM TABLE(FN_LINE_WORKINGTIME_BY_LOSS('40','20190603','20200531',''))
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019.06.04	YHW				[CSR ID:4023208] GSCM 시스템 개선 요청 - 라인가동율 산출로직 변경
 * 2019.10.16	YHW				전극 'EE'일 시 조회 안되는 오류 수정
 * 2020.02.06	YHW				ESS 외주 Pakcer Line 생산 Target 적용
 * 2021.03.15   KSG             PJ20209642 Digital SCM Level.3 달성을 위한 개선 : Work Time 변경
 * 2022-03-23   KSG             PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
 * 2022.04.29   sclee           PJ20216891 LGES Digital SCM 3 Level 가속화를 위한 개선 - 새사업부 추가관련 @p_division_id NVARCHAR(2) -> NVARCHAR(10)으로 변경
 * 2023.03.23	hrkim			[PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영
 * 2026.09.11   [MSSQL -> Oracle 전환]
 * 2026.10.06   AJS            Loss Time Except 조인 성능 개선 : 해시 조인 + 조회 기간 사전 필터 (결과 동일)
 */
BEGIN

    FOR C1 IN (
        /* PJ20209642 전 공정 View에서 Daily Capa 사용하여 Tact Time 으로 전환 / Loss Time Except 생성 시 비율 적용되어 있음 */
        /*   Daily Capa 사용 시 : 형교환 Loss만 반영 */
        /*   Tact Time 사용 시 : 전체 Loss 반영 */
--        SELECT A.DIVISION_ID                                                                       --  2026.10.06 AJS
        SELECT /*+ LEADING(B S A) USE_HASH(A) USE_HASH(C) USE_HASH(D) */ A.DIVISION_ID      --  2026.10.06 AJS
             , A.PLANT_SITE_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.YYYYMMDD
             , CASE
                   WHEN D.LOSS_START_DATE IS NOT NULL
                   THEN A.WORKING_TIME - TRUNC(NVL(D.SETUP_LOSS_TIME_MIN, 0), 0)
                   ELSE A.WORKING_TIME - TRUNC(A.WORKING_TIME_RATE * NVL(C.SETUP_LOSS_TIME_MIN, 0), 0)
               END                                                  AS WORKING_TIME
          FROM (SELECT W.DIVISION_ID
                     , W.PLANT_SITE_ID
                     , W.FACTORY_ID
                     , W.OPERATION_ID
                     , W.LINE_ID
                     , W.YYYYMMDD
                     , W.WORKING_TIME
                     , W.WORKING_TIME / 1440.0                      AS WORKING_TIME_RATE
                  FROM SCP_MST_WORKING_TIME W) A
             , /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 : HM JV 가상 사업부 추가 반영 */
               (SELECT DISTINCT
                       DT.DIVISION_ID
                  FROM SCM_MST_DIVISION DM
                     , SCM_MST_DIVISION DT
                 WHERE 1 = 1
                   AND DT.ATTRIBUTE4  = DM.ATTRIBUTE4
                   AND DT.DIVISION_ID = CASE
                                            WHEN DM.ATTRIBUTE3 = 'EE'
                                            THEN DT.DIVISION_ID
                                            ELSE DM.DIVISION_ID
                                        END
                   AND DT.ATTRIBUTE3 != 'EE'
                   AND DT.VALID_YN    = 'Y'
                   AND DM.VALID_YN    = 'Y'
                   AND DM.DIVISION_ID = P_DIVISION_ID) B
             , SCM_MST_SITE                 S
             , SCP_MST_LOSS_TIME            C
             , SCP_MST_LOSS_TIME_EXCEPT     D
         WHERE 1 = 1
           AND B.DIVISION_ID     = A.DIVISION_ID
           AND S.DIVISION_ID     = A.DIVISION_ID
           AND S.SCM_SITE_ID     = A.PLANT_SITE_ID
           AND C.DIVISION_ID(+)  = A.DIVISION_ID
           AND C.PLANT_SITE_ID(+)= A.PLANT_SITE_ID
           AND C.FACTORY_ID(+)   = A.FACTORY_ID
           AND C.OPERATION_ID(+) = A.OPERATION_ID
           AND C.LINE_ID(+)      = A.LINE_ID
           AND D.DIVISION_ID(+)  = A.DIVISION_ID
           AND D.PLANT_SITE_ID(+)= A.PLANT_SITE_ID
           AND D.FACTORY_ID(+)   = A.FACTORY_ID
           AND D.OPERATION_ID(+) = A.OPERATION_ID
           AND D.LINE_ID(+)      = A.LINE_ID
           AND A.YYYYMMDD       >= D.LOSS_START_DATE(+)
           AND A.YYYYMMDD       <= D.LOSS_END_DATE(+)
           /* 2026.10.06 AJS Loss Time Except 조회 기간 사전 필터 (START) */
           AND D.LOSS_END_DATE(+)   >= P_FROM_YYYYMMDD
           AND D.LOSS_START_DATE(+) <= P_TO_YYYYMMDD
           /* 2026.10.06 AJS Loss Time Except 조회 기간 사전 필터 (END) */
                /* ESS 외주 Pakcer Line 생산 Target 적용 : 외주가 아니거나 외주이면서 Line Capa 대상인 것 */
           AND (   S.OSP_YN = 'N'
                OR (    S.OSP_YN         = 'Y'
                    AND NVL(S.ATTRIBUTE1, 'N') = 'Y'
                    AND A.LINE_ID       != '-'))
           AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD       <= P_TO_YYYYMMDD
           AND (   P_LINE_ID IS NULL
                OR A.LINE_ID IN (SELECT COLUMN_VALUE
                                   FROM TABLE(STRING_SPLIT(P_LINE_ID, ','))))
        UNION
        SELECT A.DIVISION_ID
             , A.PLANT_SITE_ID
             , A.OPERATION_ID
             , A.LINE_ID
             , A.YYYYMMDD
             , (SELECT NVL(SUM(NVL(SA.DAILY_CAPA_QTY, 0)), 0)
                  FROM SCP_MST_OUTSOURCING_CAPA SA
                 WHERE SA.DIVISION_ID   = A.DIVISION_ID
                   AND SA.PLANT_SITE_ID = A.PLANT_SITE_ID
                   AND SA.ITEM_ID       = '-')                      AS WORKING_TIME
          FROM (SELECT W.DIVISION_ID
                     , W.PLANT_SITE_ID
                     , W.OPERATION_ID
                     , W.LINE_ID
                     , W.YYYYMMDD
                  FROM SCP_MST_WORKING_TIME  W
                     , SCM_MST_SITE          S
                     , /* [PJ20230691R] HM JV 가상 사업부 추가 반영 */
                       (SELECT DISTINCT
                               DT.DIVISION_ID
                          FROM SCM_MST_DIVISION DM
                             , SCM_MST_DIVISION DT
                         WHERE 1 = 1
                           AND DT.ATTRIBUTE4  = DM.ATTRIBUTE4
                           AND DT.DIVISION_ID = CASE
                                                    WHEN DM.ATTRIBUTE3 = 'EE'
                                                    THEN DT.DIVISION_ID
                                                    ELSE DM.DIVISION_ID
                                                END
                           AND DT.ATTRIBUTE3 != 'EE'
                           AND DT.VALID_YN    = 'Y'
                           AND DM.VALID_YN    = 'Y'
                           AND DM.DIVISION_ID = P_DIVISION_ID) T
                 WHERE 1 = 1
                   AND T.DIVISION_ID = W.DIVISION_ID
                   AND W.DIVISION_ID = S.DIVISION_ID
                   AND W.PLANT_SITE_ID = S.SCM_SITE_ID
                        /* ESS 외주 Pakcer Line 생산 Target 적용 : 외주이면서 Line Capa 대상이 아닌 것 + Line명이 '-' 인 것 */
                   AND S.OSP_YN      = 'Y'
                   AND (   NVL(S.ATTRIBUTE1, 'N') = 'N'
                        OR W.LINE_ID = '-')) A
         WHERE 1 = 1
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD)
    LOOP
        PIPE ROW (T_FN_LINE_WORKTIME_ROW(C1.DIVISION_ID
                                        ,C1.PLANT_SITE_ID
                                        ,C1.OPERATION_ID
                                        ,C1.LINE_ID
                                        ,C1.YYYYMMDD
                                        ,C1.WORKING_TIME));
    END LOOP;

    RETURN;

END FN_LINE_WORKINGTIME_BY_LOSS;