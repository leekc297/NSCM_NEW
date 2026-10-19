-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0010 — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:50:53, 3026줄)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0010
IS
/*
 * Program ID   : PKG_SCP0010
 * Description  : Shipment Plan SEMI (SCP0010)
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2026.09.17   AJS            MSSQL -> Oracle 전환
 *                             - 입력 테이블 형식 dbo.SCP0010 은 JSON 배열(CLOB) + GT_SCP0010_INPUT 으로 받는다
 *                             - 미이관 프로시저 PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET ·
 *                               PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET 은 내부 프로시저로 흡수
 */

    /* ==============================================================================================
       [내부] 입력 JSON 적재
       AS-IS : @SCP0010 (READONLY 테이블 형식 dbo.SCP0010)
       칸 이름은 AS-IS 입력 테이블 형식 이름(소문자)과 대문자 둘 다 받는다.
       칸 폭은 AS-IS 테이블 형식 폭을 따르므로 넘치면 AS-IS 와 같이 오류가 난다.
       생성자·수정자 칸이 비어 있으면 호출 사용자로 채운다.
       ============================================================================================== */
    PROCEDURE P_LOAD_INPUT
    (
        P_DATA      IN CLOB,
        P_USER_ID   IN VARCHAR2
    )
    IS
    BEGIN

        INSERT INTO GT_SCP0010_INPUT
        (
            ROW_NO
          , A
          , P_ACTIVE_FLAG
          , P_DIVISION_ID
          , P_PLAN_START_YYYYMMDD
          , P_PLAN_TYPE
          , P_SEQ
          , P_BIZ_TYPE
          , P_OPERATION_GROUP
          , P_ITEM_ID
          , P_FROM_SITE
          , P_BOD_ID
          , P_MEASURE
          , P_YYYYMMDD
          , P_TO_SITE
          , P_QTY
          , P_ORIGIN_FROM_DIVISION_ID
          , P_ORIGIN_TO_DIVISION_ID
          , P_ELECTRODE_TYPE
          , P_FIX_REASON
          , P_CREATED_BY
          , P_LAST_UPDATED_BY
          , P_TIME_ZONE
          , P_BUCKET_TYPE
          , P_TRANS_MODE
          , DEBUG_MODE
        )
        SELECT JT.RN
             , NVL(JT.A1, JT.A2)
/* , NVL(JT.ACT1, JT.ACT2) */
             , NVL(NVL(JT.ACT1, JT.ACT2), JT.ACT3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.DIV1, JT.DIV2) */
             , NVL(NVL(JT.DIV1, JT.DIV2), JT.DIV3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.PSD1, JT.PSD2) */
             , NVL(NVL(JT.PSD1, JT.PSD2), JT.PSD3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.PTP1, JT.PTP2) */
             , NVL(NVL(JT.PTP1, JT.PTP2), JT.PTP3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.SEQ1, JT.SEQ2) */
             , NVL(NVL(JT.SEQ1, JT.SEQ2), JT.SEQ3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.BIZ1, JT.BIZ2) */
             , NVL(NVL(JT.BIZ1, JT.BIZ2), JT.BIZ3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.OPG1, JT.OPG2) */
             , NVL(NVL(JT.OPG1, JT.OPG2), JT.OPG3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.ITM1, JT.ITM2) */
             , NVL(NVL(JT.ITM1, JT.ITM2), JT.ITM3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.FRS1, JT.FRS2) */
             , NVL(NVL(JT.FRS1, JT.FRS2), JT.FRS3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.BOD1, JT.BOD2) */
             , NVL(NVL(JT.BOD1, JT.BOD2), JT.BOD3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.MSR1, JT.MSR2) */
             , NVL(NVL(JT.MSR1, JT.MSR2), JT.MSR3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.YMD1, JT.YMD2) */
             , NVL(NVL(JT.YMD1, JT.YMD2), JT.YMD3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.TOS1, JT.TOS2) */
             , NVL(NVL(JT.TOS1, JT.TOS2), JT.TOS3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.QTY1, JT.QTY2) */
             , NVL(NVL(JT.QTY1, JT.QTY2), JT.QTY3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.OFD1, JT.OFD2) */
             , NVL(NVL(JT.OFD1, JT.OFD2), JT.OFD3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.OTD1, JT.OTD2) */
             , NVL(NVL(JT.OTD1, JT.OTD2), JT.OTD3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.ELC1, JT.ELC2) */
             , NVL(NVL(JT.ELC1, JT.ELC2), JT.ELC3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.FXR1, JT.FXR2) */
             , NVL(NVL(JT.FXR1, JT.FXR2), JT.FXR3)   /* AJS 20261007 화면검증 */
/* , NVL(NVL(JT.CRB1, JT.CRB2), P_USER_ID) */
             , NVL(NVL(NVL(JT.CRB1, JT.CRB2), JT.CRB3), P_USER_ID)   /* AJS 20261007 화면검증 */
/* , NVL(NVL(JT.LUB1, JT.LUB2), P_USER_ID) */
             , NVL(NVL(NVL(JT.LUB1, JT.LUB2), JT.LUB3), P_USER_ID)   /* AJS 20261007 화면검증 */
/* , NVL(JT.TMZ1, JT.TMZ2) */
             , NVL(NVL(JT.TMZ1, JT.TMZ2), JT.TMZ3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.BKT1, JT.BKT2) */
             , NVL(NVL(JT.BKT1, JT.BKT2), JT.BKT3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.TRM1, JT.TRM2) */
             , NVL(NVL(JT.TRM1, JT.TRM2), JT.TRM3)   /* AJS 20261007 화면검증 */
/* , NVL(JT.DBG1, JT.DBG2) */
             , NVL(NVL(JT.DBG1, JT.DBG2), JT.DBG3)   /* AJS 20261007 화면검증 */
          FROM JSON_TABLE(P_DATA, '$[*]'
                   COLUMNS ( RN    FOR ORDINALITY
                           , A1    VARCHAR2(4000) PATH '$.A'
                           , A2    VARCHAR2(4000) PATH '$.a'
                           , ACT1  VARCHAR2(4000) PATH '$.p_active_flag'
                           , ACT2  VARCHAR2(4000) PATH '$.P_ACTIVE_FLAG'
                           , ACT3  VARCHAR2(4000) PATH '$.activeFlag'   /* AJS 20261007 화면검증 */
                           , DIV1  VARCHAR2(4000) PATH '$.p_division_id'
                           , DIV2  VARCHAR2(4000) PATH '$.P_DIVISION_ID'
                           , DIV3  VARCHAR2(4000) PATH '$.divisionId'   /* AJS 20261007 화면검증 */
                           , PSD1  VARCHAR2(4000) PATH '$.p_plan_start_yyyymmdd'
                           , PSD2  VARCHAR2(4000) PATH '$.P_PLAN_START_YYYYMMDD'
                           , PSD3  VARCHAR2(4000) PATH '$.planStartYyyymmdd'   /* AJS 20261007 화면검증 */
                           , PTP1  VARCHAR2(4000) PATH '$.p_plan_type'
                           , PTP2  VARCHAR2(4000) PATH '$.P_PLAN_TYPE'
                           , PTP3  VARCHAR2(4000) PATH '$.planType'   /* AJS 20261007 화면검증 */
                           , SEQ1  VARCHAR2(4000) PATH '$.p_seq'
                           , SEQ2  VARCHAR2(4000) PATH '$.P_SEQ'
                           , SEQ3  VARCHAR2(4000) PATH '$.seq'   /* AJS 20261007 화면검증 */
                           , BIZ1  VARCHAR2(4000) PATH '$.p_biz_type'
                           , BIZ2  VARCHAR2(4000) PATH '$.P_BIZ_TYPE'
                           , BIZ3  VARCHAR2(4000) PATH '$.bizType'   /* AJS 20261007 화면검증 */
                           , OPG1  VARCHAR2(4000) PATH '$.p_operation_group'
                           , OPG2  VARCHAR2(4000) PATH '$.P_OPERATION_GROUP'
                           , OPG3  VARCHAR2(4000) PATH '$.operationGroup'   /* AJS 20261007 화면검증 */
                           , ITM1  VARCHAR2(4000) PATH '$.p_item_id'
                           , ITM2  VARCHAR2(4000) PATH '$.P_ITEM_ID'
                           , ITM3  VARCHAR2(4000) PATH '$.itemId'   /* AJS 20261007 화면검증 */
                           , FRS1  VARCHAR2(4000) PATH '$.p_from_site'
                           , FRS2  VARCHAR2(4000) PATH '$.P_FROM_SITE'
                           , FRS3  VARCHAR2(4000) PATH '$.fromSite'   /* AJS 20261007 화면검증 */
                           , BOD1  VARCHAR2(4000) PATH '$.p_bod_id'
                           , BOD2  VARCHAR2(4000) PATH '$.P_BOD_ID'
                           , BOD3  VARCHAR2(4000) PATH '$.bodId'   /* AJS 20261007 화면검증 */
                           , MSR1  VARCHAR2(4000) PATH '$.p_measure'
                           , MSR2  VARCHAR2(4000) PATH '$.P_MEASURE'
                           , MSR3  VARCHAR2(4000) PATH '$.measure'   /* AJS 20261007 화면검증 */
                           , YMD1  VARCHAR2(4000) PATH '$.p_yyyymmdd'
                           , YMD2  VARCHAR2(4000) PATH '$.P_YYYYMMDD'
                           , YMD3  VARCHAR2(4000) PATH '$.yyyymmdd'   /* AJS 20261007 화면검증 */
                           , TOS1  VARCHAR2(4000) PATH '$.p_to_site'
                           , TOS2  VARCHAR2(4000) PATH '$.P_TO_SITE'
                           , TOS3  VARCHAR2(4000) PATH '$.toSite'   /* AJS 20261007 화면검증 */
                           , QTY1  VARCHAR2(4000) PATH '$.p_qty'
                           , QTY2  VARCHAR2(4000) PATH '$.P_QTY'
                           , QTY3  VARCHAR2(4000) PATH '$.qty'   /* AJS 20261007 화면검증 */
                           , OFD1  VARCHAR2(4000) PATH '$.p_origin_from_division_id'
                           , OFD2  VARCHAR2(4000) PATH '$.P_ORIGIN_FROM_DIVISION_ID'
                           , OFD3  VARCHAR2(4000) PATH '$.originFromDivisionId'   /* AJS 20261007 화면검증 */
                           , OTD1  VARCHAR2(4000) PATH '$.p_origin_to_division_id'
                           , OTD2  VARCHAR2(4000) PATH '$.P_ORIGIN_TO_DIVISION_ID'
                           , OTD3  VARCHAR2(4000) PATH '$.originToDivisionId'   /* AJS 20261007 화면검증 */
                           , ELC1  VARCHAR2(4000) PATH '$.p_electrode_type'
                           , ELC2  VARCHAR2(4000) PATH '$.P_ELECTRODE_TYPE'
                           , ELC3  VARCHAR2(4000) PATH '$.electrodeType'   /* AJS 20261007 화면검증 */
                           , FXR1  VARCHAR2(4000) PATH '$.p_fix_reason'
                           , FXR2  VARCHAR2(4000) PATH '$.P_FIX_REASON'
                           , FXR3  VARCHAR2(4000) PATH '$.fixReason'   /* AJS 20261007 화면검증 */
                           , CRB1  VARCHAR2(4000) PATH '$.p_created_by'
                           , CRB2  VARCHAR2(4000) PATH '$.P_CREATED_BY'
                           , CRB3  VARCHAR2(4000) PATH '$.createdBy'   /* AJS 20261007 화면검증 */
                           , LUB1  VARCHAR2(4000) PATH '$.p_last_updated_by'
                           , LUB2  VARCHAR2(4000) PATH '$.P_LAST_UPDATED_BY'
                           , LUB3  VARCHAR2(4000) PATH '$.lastUpdatedBy'   /* AJS 20261007 화면검증 */
                           , TMZ1  VARCHAR2(4000) PATH '$.p_time_zone'
                           , TMZ2  VARCHAR2(4000) PATH '$.P_TIME_ZONE'
                           , TMZ3  VARCHAR2(4000) PATH '$.timeZone'   /* AJS 20261007 화면검증 */
                           , BKT1  VARCHAR2(4000) PATH '$.p_bucket_type'
                           , BKT2  VARCHAR2(4000) PATH '$.P_BUCKET_TYPE'
                           , BKT3  VARCHAR2(4000) PATH '$.bucketType'   /* AJS 20261007 화면검증 */
                           , TRM1  VARCHAR2(4000) PATH '$.p_trans_mode'
                           , TRM2  VARCHAR2(4000) PATH '$.P_TRANS_MODE'
                           , TRM3  VARCHAR2(4000) PATH '$.transMode'   /* AJS 20261007 화면검증 */
                           , DBG1  VARCHAR2(4000) PATH '$.debug_mode'
                           , DBG2  VARCHAR2(4000) PATH '$.DEBUG_MODE'
                           , DBG3  VARCHAR2(4000) PATH '$.debugMode'   /* AJS 20261007 화면검증 */
                           )) JT;

    END P_LOAD_INPUT;


    /* ==============================================================================================
       [내부] JV 동기화 대상 행 추가
       AS-IS : [PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
               ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
               #JV_ESS_SCM_SITE_MAP · #DIVISION_LAST_PLAN_INFO · #BOD_ITEM · @SCP0010_WITH_JV
       P_LAST_MONDAY_YN = 'Y' : FIX 저장(플랜 시작일이 비어 있으면 지난 월요일 기준 버전을 찾는다)
       MSSQL 은 오름차순 정렬에서 NULL 을 앞에, 내림차순에서 뒤에 두므로 NULLS FIRST / NULLS LAST 를 명시한다.
       ============================================================================================== */
    PROCEDURE P_ADD_JV_INPUT
    (
        P_LAST_MONDAY_YN    IN VARCHAR2
    )
    IS
        V_BASE_CNT          NUMBER;
        V_LAST_MONDAY       VARCHAR2(8 CHAR);
    BEGIN

        DELETE FROM GT_SCP0010_JV_MAP;
        DELETE FROM GT_SCP0010_LAST_PLAN;
        DELETE FROM GT_SCP0010_BOD_ITEM;

        -- JV/ESS scm site 매핑 정보 추출
        INSERT INTO GT_SCP0010_JV_MAP
        (
            VP_COMPANY_ID
          , VP_DIVISION_ID
          , VP_SITE_ID
          , VP_PLANT_ID
          , VP_SCM_SITE_ID
          , RP_COMPANY_ID
          , RP_DIVISION_ID
          , RP_SITE_ID
          , RP_PLANT_ID
          , RP_SCM_SITE_ID
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

        -- DIVISION 주차별 최종 수행 Plan 버전 정보
        -- ESS 가상 라인 매핑 JV division의 동기화 대상 버전 정보 확인을 위한 데이터
        -- Final Plan은 수정 대상에서 제외 ?
        INSERT INTO GT_SCP0010_LAST_PLAN
        (
            DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , PLAN_SEQ
          , HORIZON_END_DATE
          , PLAN_STATUS
          , INPUT_START_DATE
          , RN
        )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , IA.PLAN_SEQ
             , IA.HORIZON_END_DATE
             , IA.PLAN_STATUS
             , IA.INPUT_START_DATE
             , IA.RN
          FROM (SELECT B.DIVISION_ID
                     , A.PLAN_NAME          AS PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.PLAN_SEQ
                     , A.HORIZON_END_DATE
                     , B.PLAN_STATUS
                     , B.INPUT_START_DATE
                     , ROW_NUMBER() OVER (PARTITION BY B.DIVISION_ID
                                                     , A.PLAN_NAME
                                              ORDER BY CASE WHEN B.PLAN_TYPE = 'PR' THEN 4
                                                            WHEN B.PLAN_TYPE = 'MA' THEN 3
                                                            WHEN B.PLAN_TYPE = 'SE' THEN 2
                                                            WHEN B.PLAN_TYPE = 'FN' THEN 1
                                                            ELSE 0
                                                       END
                                                     , B.PLAN_SEQ DESC NULLS LAST
                                                     , B.INPUT_START_DATE DESC NULLS LAST) AS RN
                  FROM SCM_MST_PLAN A
                     , SCM_MST_PLAN_DETAIL B
                     , SCM_MST_DIVISION C
                 WHERE B.DIVISION_ID = A.DIVISION_ID
                   AND B.PLAN_ID     = A.PLAN_ID
                   AND C.DIVISION_ID = A.DIVISION_ID
                   AND B.PLAN_STATUS = '1'
                   AND C.ATTRIBUTE3  <> 'EE'
                   AND A.PLAN_CYCLE  = 'WEEKLY'
                   AND A.PLAN_NAME   >= TO_CHAR(SYSDATE - 20, 'YYYYMMDD')
               ) IA
         WHERE IA.RN        = 1
           AND IA.PLAN_TYPE <> 'FN';   -- Final plan 대상에서 제외

        -- BOD 및 BOD ITEM 정보
        INSERT INTO GT_SCP0010_BOD_ITEM
        (
            DIVISION_ID
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , ITEM_ID
          , BOD_ID
          , RN
        )
        SELECT IA.DIVISION_ID
             , IA.FROM_SITE
             , IA.TO_SITE
             , IA.INCOTERMS
             , IA.ITEM_ID
             , IA.BOD_ID
             , IA.RN
          FROM (SELECT A.DIVISION_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , A.INCOTERMS
                     , B.ITEM_ID
                     , A.BOD_ID
                     , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                     , A.FROM_SITE
                                                     , A.TO_SITE
                                                     , A.INCOTERMS
                                                     , B.ITEM_ID
                                              ORDER BY A.PRIORITY NULLS FIRST
                                                     , B.PRIORITY NULLS FIRST
                                                     , A.ATTRIBUTE3 DESC NULLS LAST
                                                     , A.LAST_UPDATE_DATE DESC NULLS LAST) AS RN
                  FROM SCP_MST_BOD A
                     , SCP_MST_BOD_ITEM B
                 WHERE B.BOD_ID      = A.BOD_ID
                   AND EXISTS (SELECT 1
                                 FROM GT_SCP0010_JV_MAP XA
                                WHERE XA.RP_DIVISION_ID = A.DIVISION_ID
                                  AND XA.RP_SCM_SITE_ID = A.FROM_SITE)
                   AND B.VALID_YN    = 'Y'
                   AND A.VALID_YN    = 'Y'
                   AND B.TO_YYYYMMDD >= TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
                   AND A.ATTRIBUTE3  > TO_CHAR(SYSDATE - 7, 'YYYYMMDD')
               ) IA
         WHERE IA.RN = 1;

        -- 가상 사이트에 매핑된 JV 사이트 데이터 @SCP0010_WITH_JV 변수에 추가
        -- ESS MI법인 -> JV 동기화 저장 (단방향 저장으로 가상 사이트에 매핑된 JV 사이트 데이터는 제외)
        SELECT COUNT(*)
          INTO V_BASE_CNT
          FROM GT_SCP0010_INPUT;

        IF P_LAST_MONDAY_YN = 'Y' THEN
            SELECT MAX(YYYYMMDD)
              INTO V_LAST_MONDAY
              FROM SCM_MST_BUCKET
             WHERE YYYYMMDD  <= TO_CHAR(SYSDATE, 'YYYYMMDD')
               AND DAYOFWEEK = 'MON';
        END IF;

        INSERT INTO GT_SCP0010_INPUT
        (
            ROW_NO
          , A
          , P_ACTIVE_FLAG
          , P_DIVISION_ID
          , P_PLAN_START_YYYYMMDD
          , P_PLAN_TYPE
          , P_SEQ
          , P_BIZ_TYPE
          , P_OPERATION_GROUP
          , P_ITEM_ID
          , P_FROM_SITE
          , P_BOD_ID
          , P_MEASURE
          , P_YYYYMMDD
          , P_TO_SITE
          , P_QTY
          , P_ORIGIN_FROM_DIVISION_ID
          , P_ORIGIN_TO_DIVISION_ID
          , P_ELECTRODE_TYPE
          , P_FIX_REASON
          , P_CREATED_BY
          , P_LAST_UPDATED_BY
          , P_TIME_ZONE
          , P_BUCKET_TYPE
          , P_TRANS_MODE
          , DEBUG_MODE
        )
        SELECT V_BASE_CNT + ROW_NUMBER() OVER (ORDER BY A.ROW_NO)
             , A.A
             , A.P_ACTIVE_FLAG
             , B.RP_DIVISION_ID                                 AS P_DIVISION_ID
             , A.P_PLAN_START_YYYYMMDD
             , C.PLAN_TYPE                                      AS P_PLAN_TYPE
             , TO_CHAR(C.PLAN_SEQ)                              AS P_SEQ
             , A.P_BIZ_TYPE
             , A.P_OPERATION_GROUP
             , A.P_ITEM_ID
             , B.RP_SCM_SITE_ID                                 AS P_FROM_SITE
             , NVL(NVL(E.BOD_ID, A.P_BOD_ID), '/')              AS P_BOD_ID     -- 2025.12.23 bod_id 매핑이 안되는 경우 ESS가상 사이트 기준 BOD_ID 유지
             , A.P_MEASURE
             , A.P_YYYYMMDD
             , A.P_TO_SITE
             , A.P_QTY
             , B.RP_DIVISION_ID                                 AS P_ORIGIN_FROM_DIVISION_ID
             , B.RP_DIVISION_ID                                 AS P_ORIGIN_TO_DIVISION_ID      -- 2025.12.16 division_id와 같은 값으로
             , A.P_ELECTRODE_TYPE
             , A.P_FIX_REASON
             , A.P_CREATED_BY
             , A.P_LAST_UPDATED_BY
             , A.P_TIME_ZONE
             , A.P_BUCKET_TYPE
             , A.P_TRANS_MODE
             , A.DEBUG_MODE
          FROM GT_SCP0010_INPUT A
             , GT_SCP0010_JV_MAP B
             , GT_SCP0010_LAST_PLAN C       -- 수정할 대상 버전이 있어야 수정 (FN 까지 완료된 경우 수정하지 않음)
             , SCP_MST_BOD D
             , GT_SCP0010_BOD_ITEM E
         WHERE B.VP_DIVISION_ID      = A.P_DIVISION_ID
           AND B.VP_SCM_SITE_ID      = A.P_FROM_SITE
           AND C.DIVISION_ID         = B.RP_DIVISION_ID
           AND C.PLAN_START_YYYYMMDD = CASE WHEN P_LAST_MONDAY_YN = 'Y' THEN NVL(A.P_PLAN_START_YYYYMMDD, V_LAST_MONDAY)
                                            ELSE A.P_PLAN_START_YYYYMMDD
                                       END
           AND D.BOD_ID(+)           = A.P_BOD_ID
           AND E.DIVISION_ID(+)      = B.RP_DIVISION_ID
           AND E.FROM_SITE(+)        = B.RP_SCM_SITE_ID
           AND E.TO_SITE(+)          = A.P_TO_SITE
           AND E.INCOTERMS(+)        = D.INCOTERMS
           AND E.ITEM_ID(+)          = A.P_ITEM_ID;

    END P_ADD_JV_INPUT;


    /* ==============================================================================================
       [내부] SHIPMENT PLAN SEMI FIX 이력 저장
       AS-IS : PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET (미이관)
       ============================================================================================== */
    PROCEDURE P_SEMI_FIX_HIST_DS
    IS
    /*
     * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_SEMI_FIX_HIST_DATASET
     * Description  : SHIPMENT PLAN SEMI FIX History
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019/05/27   YHW             [CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019.09.03	HWYOON			[CSR ID:4071705] Production Plan Fix에서 Unfix 기능 추가 - I/M/D FLAG 추가
     * 2026.09.17   AJS             MSSQL -> Oracle 전환 (패키지 내부 프로시저로 흡수)
     */
    BEGIN

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX_H
        (
            HISTORY_SEQ
          , FIX_ID
          , DIVISION_ID
          , BIZ_TYPE
          , ITEM_ID
          , TO_SITE
          , FROM_SITE
          , PROJECT_CODE
          , INCOTERMS
          , BOD_ID
          , YYYYMMDD
          , QTY
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , FIX_REASON
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          , HISTORY_CREATION_DATE
          , ATTRIBUTE1
        )
        SELECT SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H.NEXTVAL
             , A.FIX_ID
             , B.P_DIVISION_ID
             , B.P_BIZ_TYPE
             , B.P_ITEM_ID
             , B.P_TO_SITE
             , B.P_FROM_SITE
             , NULL
             , NULL
             , B.P_BOD_ID
             , B.P_YYYYMMDD
             , TO_NUMBER(B.P_QTY)
             , B.P_ORIGIN_FROM_DIVISION_ID
             , B.P_ORIGIN_TO_DIVISION_ID
             , B.P_ELECTRODE_TYPE
             , A.FIX_REASON
             , B.P_CREATED_BY
             , SYSDATE
             , B.P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             , B.P_ACTIVE_FLAG
          FROM SCP_ANL_SHIPMENT_PLAN_FIX A
             , GT_SCP0010_INPUT B
         WHERE A.DIVISION_ID                 = B.P_DIVISION_ID
           AND A.BIZ_TYPE                    = B.P_BIZ_TYPE
           AND A.ITEM_ID                     = B.P_ITEM_ID
           AND A.TO_SITE                     = B.P_TO_SITE
           AND A.FROM_SITE                   = B.P_FROM_SITE
           AND A.BOD_ID                      = B.P_BOD_ID
           AND A.YYYYMMDD                    = B.P_YYYYMMDD
           AND DECODE(A.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1   /* 빈 문자끼리 같음(AS-IS) */
           AND DECODE(A.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
           AND NVL(A.ELECTRODE_TYPE, '-')    = NVL(B.P_ELECTRODE_TYPE, '-');

    END P_SEMI_FIX_HIST_DS;


    /* ==============================================================================================
       [내부] SHIPMENT PLAN SEMI 이력 저장
       AS-IS : PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET (미이관)
       ============================================================================================== */
    PROCEDURE P_SEMI_HIST_DS
    IS
    /*
     * Program ID   : PR_SCP_ANL_SHIPMENT_PLAN_SEMI_HIST_DATASET
     * Description  : Shipment Plan SEMI History 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2019.05.27	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019.07.22	YHW				[CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
     *                              -> 오류선조치 - qty INT 캐스팅 오류 수정
     * 2026.09.17   AJS             MSSQL -> Oracle 전환 (패키지 내부 프로시저로 흡수)
     */
    BEGIN

        INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI_H
        (
            HISTORY_SEQ
          , DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , OPERATION_GROUP
          , ITEM_ID
          , FROM_SITE
          , TO_SITE
          , BOD_ID
          , MEASURE
          , YYYYMMDD
          , QTY
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          , HISTORY_CREATION_DATE
        )
        SELECT SEQ1_SCP_ANL_SHIPMENT_PLAN_SEMI_H.NEXTVAL
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , TO_NUMBER(P_SEQ)
             , P_OPERATION_GROUP
             , P_ITEM_ID
             , P_FROM_SITE
             , P_TO_SITE
             , P_BOD_ID
             , P_MEASURE
             , P_YYYYMMDD
             , TRUNC(TO_NUMBER(P_QTY))   /* cast(round (cast(p_qty as numeric(20,10)), 0 ,1) as int) - 세 번째 인자 1 은 절삭 */
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             , SYSDATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
          FROM GT_SCP0010_INPUT;

    END P_SEMI_HIST_DS;


    /* ==============================================================================================
       [내부] 저장 오류 기록 (자율 트랜잭션 로그 프로시저 사용)
       AS-IS : INSERT INTO scm_sys_log_batch (ERROR_PROCEDURE(), 'ERROR', NULL, ERROR_MESSAGE(), ...)
       ============================================================================================== */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN VARCHAR2,
        P_USER_ID       IN VARCHAR2,
        P_ERR_CODE      IN VARCHAR2,
        P_ERR_MESSAGE   IN VARCHAR2,
        P_BACKTRACE     IN VARCHAR2
    )
    IS
        V_IN_PARA       VARCHAR2(2000 CHAR);
        V_ROW_CNT       NUMBER;
    BEGIN

        SELECT COUNT(*)
          INTO V_ROW_CNT
          FROM GT_SCP0010_INPUT;

        V_IN_PARA := JSON_OBJECT('p_user_id' VALUE P_USER_ID, 'row_cnt' VALUE V_ROW_CNT);

        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , 'ERROR'
                           , NULL
                           , P_ERR_MESSAGE
                           , NULL
                           , SYSDATE
                           , V_IN_PARA
                           , P_ERR_CODE
                           , P_ERR_MESSAGE
                           , P_BACKTRACE);

    END P_LOG_ERROR;


    /* ==============================================================================================
       일괄 저장
       AS-IS : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET
       ============================================================================================== */
    PROCEDURE P_SCP0010_SAVE_SEMI_DATASET
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET
     * Description  : shipment plan semi 등록, 수정
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2018/05/27	YHW				[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2019/07/22	YHW				[CSR ID:4053788] 자체개선 - Tact TIme Except 입력 날짜 Validation 추가 외 3건
     *                              -> 오류선조치 - qty INT 캐스팅 오류 수정
     * 2022/04/29   chaan			81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *								  : ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     *									- @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용
     *									- TO Site 정보는 그대로 가져간다. (BOD_ID는 매핑이 안되면 '-')
     *								    - 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님
     *								    - 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지
     * 2026.09.17   AJS             MSSQL -> Oracle 전환
     *                              - 빈 값 칸(ORIGIN_FROM/TO_DIVISION_ID · ELECTRODE_TYPE) 비교는 빈 값끼리 같게 본다(AS-IS 빈 문자 비교)
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_DATASET';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR);
        V_TIME_ZONE         VARCHAR2(100 CHAR);
        V_CREATION_DATE     DATE;               -- timezone에 따른 저장위해서
        V_MAX_LOOP_CNT      VARCHAR2(50 CHAR);
        V_ERR_CODE          VARCHAR2(20 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_BACKTRACE         VARCHAR2(4000 CHAR);
    BEGIN

        /* 되돌리기 기준점 (AS-IS : BEGIN TRAN) */
        SAVEPOINT SP_SCP0010_DATASET;

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0010_INPUT;
        DELETE FROM GT_SCP0010_DYNAMIC;

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        /* 입력 적재 + JV 동기화 대상 추가 (@SCP0010_WITH_JV) */
        P_LOAD_INPUT(P_DATA, P_USER_ID);
        P_ADD_JV_INPUT('N');

        --TimeZone set
        SELECT MAX(P_TIME_ZONE) KEEP (DENSE_RANK FIRST ORDER BY ROW_NO)
          INTO V_TIME_ZONE
          FROM GT_SCP0010_INPUT;

        IF V_TIME_ZONE IS NULL THEN
            V_TIME_ZONE := 'AS054';
        END IF;

        V_CREATION_DATE := FN_MULTY_TIME(V_TIME_ZONE);

        -- 임시테이블 데이타 생성
        INSERT INTO GT_SCP0010_DYNAMIC
        (
            A
          , P_ACTIVE_FLAG
          , P_DIVISION_ID
          , P_PLAN_START_YYYYMMDD
          , P_PLAN_TYPE
          , P_SEQ
          , P_OPERATION_GROUP
          , P_ITEM_ID
          , P_FROM_SITE
          , P_BOD_ID
          , P_MEASURE
          , P_YYYYMMDD
          , P_TO_SITE
          , P_QTY
          , P_ORIGIN_FROM_DIVISION_ID
          , P_ORIGIN_TO_DIVISION_ID
          , P_ELECTRODE_TYPE
          , P_CREATED_BY
          , P_LAST_UPDATED_BY
          , P_TIME_ZONE
          , P_CPLT_FLAG
        )
        SELECT A
             , P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , P_SEQ
             , P_OPERATION_GROUP
             , P_ITEM_ID
             , P_FROM_SITE
             , P_BOD_ID
             , P_MEASURE
             , P_YYYYMMDD
             , P_TO_SITE
             , P_QTY
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             , P_LAST_UPDATED_BY
             , P_TIME_ZONE
             , NULL
          FROM GT_SCP0010_INPUT;

        --수정 Row
        SELECT TO_CHAR(COUNT(*))
          INTO V_MAX_LOOP_CNT
          FROM GT_SCP0010_DYNAMIC;

        /* 1. 수정수량 UPDATE (+ 반영 여부 표시)
           입력은 화면에서 고친 몇 건이므로 행마다 파티션 프루닝 + 기본키로 찾아 고친다.
           AS-IS 는 수정 뒤 원장에 열쇠가 있는 입력 행을 반영 완료로 표시한다 - 수정은 열쇠를 바꾸지 않으므로 수정된 행과 같다. */
        FOR R IN (SELECT ROWID AS RID
                       , P_DIVISION_ID
                       , P_PLAN_START_YYYYMMDD
                       , P_PLAN_TYPE
                       , P_SEQ
                       , P_OPERATION_GROUP
                       , P_ITEM_ID
                       , P_FROM_SITE
                       , P_BOD_ID
                       , P_MEASURE
                       , P_YYYYMMDD
                       , P_TO_SITE
                       , P_QTY
                       , P_ORIGIN_FROM_DIVISION_ID
                       , P_ORIGIN_TO_DIVISION_ID
                       , P_ELECTRODE_TYPE
                       , P_LAST_UPDATED_BY
                    FROM GT_SCP0010_DYNAMIC
                  WHERE P_ACTIVE_FLAG IN ('M', 'I'))
        LOOP

            -- 1. 수정수량 UPDATE
            UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI A
               SET A.TO_SITE          = R.P_TO_SITE
                 , A.QTY              = TRUNC(TO_NUMBER(R.P_QTY))   /* cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int) - 세 번째 인자 1 은 절삭 */
                 , A.LAST_UPDATED_BY  = R.P_LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE = V_CREATION_DATE
             WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(R.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
               AND A.DIVISION_ID             = R.P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD     = R.P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE               = R.P_PLAN_TYPE
               AND A.SEQ                     = TO_NUMBER(R.P_SEQ)
               AND A.OPERATION_GROUP         = R.P_OPERATION_GROUP
               AND A.ITEM_ID                 = R.P_ITEM_ID
               AND A.FROM_SITE               = R.P_FROM_SITE
               AND A.BOD_ID                  = R.P_BOD_ID
               AND A.MEASURE                 = R.P_MEASURE
               AND A.YYYYMMDD                = R.P_YYYYMMDD
               AND DECODE(A.ORIGIN_FROM_DIVISION_ID, R.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1   /* 빈 값끼리 같음(AS-IS 빈 문자 비교) */
               AND DECODE(A.ORIGIN_TO_DIVISION_ID, R.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
               AND DECODE(A.ELECTRODE_TYPE, R.P_ELECTRODE_TYPE, 1, 0)                   = 1;

            IF SQL%ROWCOUNT > 0 THEN
                UPDATE GT_SCP0010_DYNAMIC
                   SET P_CPLT_FLAG = 'Y'
                 WHERE ROWID = R.RID;
            END IF;

        END LOOP;

        -- 2. 신규수량 INSERT
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI
        (
            DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , OPERATION_GROUP
          , ITEM_ID
          , FROM_SITE
          , BOD_ID
          , MEASURE
          , YYYYMMDD
          , TO_SITE
          , QTY
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
          /* PLAN_START_YYYYMMDD_DATE 는 가상 컬럼이라 INSERT 대상이 아니다 */
        )
        SELECT P_DIVISION_ID
             , P_PLAN_START_YYYYMMDD
             , P_PLAN_TYPE
             , TO_NUMBER(P_SEQ)
             , P_OPERATION_GROUP
             , P_ITEM_ID
             , P_FROM_SITE
             , P_BOD_ID
             , P_MEASURE
             , P_YYYYMMDD
             , P_TO_SITE
             , TRUNC(TO_NUMBER(P_QTY))
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_CREATED_BY
             , V_CREATION_DATE
             , P_LAST_UPDATED_BY
             , V_CREATION_DATE
          FROM GT_SCP0010_DYNAMIC
         WHERE P_ACTIVE_FLAG IN ('M', 'I')
           AND P_CPLT_FLAG IS NULL;

        -- 3. 삭제수량 DELETE
        FOR R IN (SELECT ROWID AS RID
                       , P_DIVISION_ID
                       , P_PLAN_START_YYYYMMDD
                       , P_PLAN_TYPE
                       , P_SEQ
                       , P_OPERATION_GROUP
                       , P_ITEM_ID
                       , P_FROM_SITE
                       , P_BOD_ID
                       , P_MEASURE
                       , P_YYYYMMDD
                       , P_TO_SITE
                       , P_QTY
                       , P_ORIGIN_FROM_DIVISION_ID
                       , P_ORIGIN_TO_DIVISION_ID
                       , P_ELECTRODE_TYPE
                       , P_LAST_UPDATED_BY
                    FROM GT_SCP0010_DYNAMIC
                  WHERE P_ACTIVE_FLAG = 'D')
        LOOP

            DELETE FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
             WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(R.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
               AND A.DIVISION_ID             = R.P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD     = R.P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE               = R.P_PLAN_TYPE
               AND A.SEQ                     = TO_NUMBER(R.P_SEQ)
               AND A.OPERATION_GROUP         = R.P_OPERATION_GROUP
               AND A.ITEM_ID                 = R.P_ITEM_ID
               AND A.FROM_SITE               = R.P_FROM_SITE
               AND A.BOD_ID                  = R.P_BOD_ID
               AND A.MEASURE                 = R.P_MEASURE
               AND A.YYYYMMDD                = R.P_YYYYMMDD
               AND DECODE(A.ORIGIN_FROM_DIVISION_ID, R.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1   /* 빈 값끼리 같음(AS-IS 빈 문자 비교) */
               AND DECODE(A.ORIGIN_TO_DIVISION_ID, R.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
               AND DECODE(A.ELECTRODE_TYPE, R.P_ELECTRODE_TYPE, 1, 0)                   = 1;

        END LOOP;

        -- 4. FIX수량 UPDATE
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
           SET (A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
             = (SELECT TRUNC(TO_NUMBER(B.P_QTY))
                     , B.P_LAST_UPDATED_BY
                     , V_CREATION_DATE
                  FROM GT_SCP0010_DYNAMIC B
                 WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                   AND A.BIZ_TYPE                = B.P_OPERATION_GROUP
                   AND A.ITEM_ID                 = B.P_ITEM_ID
                   AND A.TO_SITE                 = B.P_TO_SITE
                   AND A.FROM_SITE               = B.P_FROM_SITE
                   AND A.BOD_ID                  = B.P_BOD_ID
                   AND A.YYYYMMDD                = B.P_YYYYMMDD
                   AND DECODE(A.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                   AND DECODE(A.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                   AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                   AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0010_DYNAMIC XA
                        WHERE A.DIVISION_ID             = XA.P_DIVISION_ID
                          AND A.BIZ_TYPE                = XA.P_OPERATION_GROUP
                          AND A.ITEM_ID                 = XA.P_ITEM_ID
                          AND A.TO_SITE                 = XA.P_TO_SITE
                          AND A.FROM_SITE               = XA.P_FROM_SITE
                          AND A.BOD_ID                  = XA.P_BOD_ID
                          AND A.YYYYMMDD                = XA.P_YYYYMMDD
                          AND DECODE(A.ORIGIN_FROM_DIVISION_ID, XA.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                          AND DECODE(A.ORIGIN_TO_DIVISION_ID, XA.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                          AND NVL(A.ELECTRODE_TYPE, '-') = NVL(XA.P_ELECTRODE_TYPE, '-'));

        -- 5. FIX이력저장
        P_SEMI_FIX_HIST_DS;

        -- 6. 이력저장
        P_SEMI_HIST_DS;

        COMMIT;

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        COMMIT;

        -- 결과코드, 결과 카운트 반환
        OPEN O_RC1 FOR
            SELECT 'S'              AS RESULT_CODE
                 , V_MAX_LOOP_CNT   AS RESULT_CNT
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'              AS CODE
                 , 'SUCCESS'        AS MSG
                 , V_MAX_LOOP_CNT   AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SQLERRM;
            V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            /* 입력 데이타 롤백 처리 (커서를 열기 전에 되돌린다) */
            BEGIN
                ROLLBACK TO SAVEPOINT SP_SCP0010_DATASET;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;   /* 커밋 뒤 오류로 기준점이 없는 경우 */
            END;

            P_LOG_ERROR(V_PROGRAM_NAME, P_USER_ID, V_ERR_CODE, V_ERR_MESSAGE, V_BACKTRACE);

            -- error코드, errror 메시지 반환
            OPEN O_RC1 FOR
                SELECT 'F'                                          AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE    AS ERR_MESSAGE
                  FROM DUAL;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'                                         AS CODE
                     , V_ERR_MESSAGE                                AS MSG
                     , '0'                                          AS EVENT
                  FROM DUAL;

    END P_SCP0010_SAVE_SEMI_DATASET;


    /* ==============================================================================================
       FIX 일괄 저장
       AS-IS : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET
       ============================================================================================== */
    PROCEDURE P_SCP0010_SAVE_SEMI_FIX_DS
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET
     * Description  : SHIPMENT PLAN SEMI FIX 등록,수정
     * Program History
     *===================================================================================================
     *   Date       In Charge	Description
     *===================================================================================================
     * 2019/05/27   YHW			[CSR ID:4010290] SCP UI 생산/출하 계획 저장속도 개선
     * 2022/04/29   chaan		81_UC, EE_UC 추가로 DIVSION 크기 확장
     * 2025/11/11   hrkim		[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *							  : ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     *								- @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용
     *								- TO Site 정보는 그대로 가져간다. (BOD_ID는 매핑이 안되면 '-')
     *								- 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님
     *								- 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지
     * 2026.09.17   AJS         MSSQL -> Oracle 전환
     *                          - 오류 시 이 호출에서 바뀐 것 전부를 되돌린다(AS-IS 는 트랜잭션 없이 문장별 반영이라 앞 문장 결과가 남았다)
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_FIX_DATASET';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        V_EVENT_DATE        DATE;
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR);
        V_MAX_LOOP_CNT      VARCHAR2(50 CHAR);
        V_ERR_CODE          VARCHAR2(20 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_BACKTRACE         VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SCP0010_FIX_DS;

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0010_INPUT;
        DELETE FROM GT_SCP0010_FIX;

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        V_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, V_EVENT_DATE);

        /* 입력 적재 + JV 동기화 대상 추가 (@SCP0010_WITH_JV) */
        P_LOAD_INPUT(P_DATA, P_USER_ID);
        P_ADD_JV_INPUT('Y');

        INSERT INTO GT_SCP0010_FIX
        (
            P_ACTIVE_FLAG
          , P_DIVISION_ID
          , P_BIZ_TYPE
          , P_ITEM_ID
          , P_TO_SITE
          , P_FROM_SITE
          , P_BOD_ID
          , P_YYYYMMDD
          , P_QTY
          , P_ORIGIN_FROM_DIVISION_ID
          , P_ORIGIN_TO_DIVISION_ID
          , P_ELECTRODE_TYPE
          , P_FIX_REASON
          , P_USER_ID
          , DEBUG_MODE
          , FIX_ID
        )
        SELECT P_ACTIVE_FLAG
             , P_DIVISION_ID
             , P_BIZ_TYPE
             , P_ITEM_ID
             , P_TO_SITE
             , P_FROM_SITE
             , P_BOD_ID
             , P_YYYYMMDD
             , P_QTY
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_FIX_REASON
             , P_LAST_UPDATED_BY
             , DEBUG_MODE
             , NULL
          FROM GT_SCP0010_INPUT;

        --수정 Row
        SELECT TO_CHAR(COUNT(*))
          INTO V_MAX_LOOP_CNT
          FROM GT_SCP0010_FIX;

        -- 입력,수정모드 결정
        /* AS-IS 는 'D' 가 아닌 행을 빈 문자로 바꾼 뒤 수정/입력으로 가른다(원래 NULL 인 행은 대상 아님).
           Oracle 은 빈 문자가 NULL 이므로 '*' 로 표시한다. */
        UPDATE GT_SCP0010_FIX
           SET P_ACTIVE_FLAG = '*'
         WHERE P_ACTIVE_FLAG <> 'D';

        -- 수정모드
        UPDATE GT_SCP0010_FIX B
           SET (B.P_ACTIVE_FLAG, B.FIX_ID)
             = (SELECT 'M'
                     , A.FIX_ID
                  FROM SCP_ANL_SHIPMENT_PLAN_FIX A
                 WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                   AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                   AND A.ITEM_ID                 = B.P_ITEM_ID
                   AND A.TO_SITE                 = B.P_TO_SITE
                   AND A.FROM_SITE               = B.P_FROM_SITE
                   AND A.BOD_ID                  = B.P_BOD_ID
                   AND A.YYYYMMDD                = B.P_YYYYMMDD
                   AND DECODE(A.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                   AND DECODE(A.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                   AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                   AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1
                         FROM SCP_ANL_SHIPMENT_PLAN_FIX XA
                        WHERE XA.DIVISION_ID             = B.P_DIVISION_ID
                          AND XA.BIZ_TYPE                = B.P_BIZ_TYPE
                          AND XA.ITEM_ID                 = B.P_ITEM_ID
                          AND XA.TO_SITE                 = B.P_TO_SITE
                          AND XA.FROM_SITE               = B.P_FROM_SITE
                          AND XA.BOD_ID                  = B.P_BOD_ID
                          AND XA.YYYYMMDD                = B.P_YYYYMMDD
                          AND DECODE(XA.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                          AND DECODE(XA.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                          AND NVL(XA.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-'))
           AND B.P_ACTIVE_FLAG = '*';

        --입력모드
        UPDATE GT_SCP0010_FIX
           SET P_ACTIVE_FLAG = 'I'
         WHERE P_ACTIVE_FLAG = '*';

        --입력대상 데이타 FIX_ID 채번
        UPDATE GT_SCP0010_FIX
           SET FIX_ID = 'F' || P_YYYYMMDD || LPAD(TO_CHAR(SEQ1_SCP_ANL_SHIPMENT_PLAN_FIX.NEXTVAL), 11, '0')
         WHERE P_ACTIVE_FLAG = 'I';

        --수량 Null 처리
        /* AS-IS : UPDATE ... SET p_qty = NULL WHERE ISNULL(p_qty,'') = '' - Oracle 은 빈 문자가 곧 NULL 이라 생략 */

        --1. 입력
        INSERT INTO SCP_ANL_SHIPMENT_PLAN_FIX
        (
            FIX_ID
          , DIVISION_ID
          , BIZ_TYPE
          , ITEM_ID
          , TO_SITE
          , FROM_SITE
          , PROJECT_CODE
          , INCOTERMS
          , BOD_ID
          , YYYYMMDD
          , QTY
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , FIX_REASON
          , CREATED_BY
          , CREATION_DATE
          , LAST_UPDATED_BY
          , LAST_UPDATE_DATE
        )
        SELECT FIX_ID
             , P_DIVISION_ID
             , P_BIZ_TYPE
             , P_ITEM_ID
             , P_TO_SITE
             , P_FROM_SITE
             , NULL
             , NULL
             , P_BOD_ID
             , P_YYYYMMDD
             , TO_NUMBER(P_QTY)
             , P_ORIGIN_FROM_DIVISION_ID
             , P_ORIGIN_TO_DIVISION_ID
             , P_ELECTRODE_TYPE
             , P_FIX_REASON
             , P_USER_ID
             , V_EVENT_DATE
             , P_USER_ID
             , V_EVENT_DATE
          FROM GT_SCP0010_FIX
         WHERE P_ACTIVE_FLAG = 'I';

        --2. 수정
        UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
           SET (A.QTY, A.FIX_REASON, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
             = (SELECT TO_NUMBER(B.P_QTY)
                     , B.P_FIX_REASON
                     , B.P_USER_ID
                     , V_EVENT_DATE
                  FROM GT_SCP0010_FIX B
                 WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                   AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                   AND A.ITEM_ID                 = B.P_ITEM_ID
                   AND A.TO_SITE                 = B.P_TO_SITE
                   AND A.FROM_SITE               = B.P_FROM_SITE
                   AND A.BOD_ID                  = B.P_BOD_ID
                   AND A.YYYYMMDD                = B.P_YYYYMMDD
                   AND DECODE(A.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                   AND DECODE(A.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                   AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                   AND B.P_ACTIVE_FLAG           = 'M'
                   AND ROWNUM = 1)
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0010_FIX XA
                        WHERE A.DIVISION_ID             = XA.P_DIVISION_ID
                          AND A.BIZ_TYPE                = XA.P_BIZ_TYPE
                          AND A.ITEM_ID                 = XA.P_ITEM_ID
                          AND A.TO_SITE                 = XA.P_TO_SITE
                          AND A.FROM_SITE               = XA.P_FROM_SITE
                          AND A.BOD_ID                  = XA.P_BOD_ID
                          AND A.YYYYMMDD                = XA.P_YYYYMMDD
                          AND DECODE(A.ORIGIN_FROM_DIVISION_ID, XA.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                          AND DECODE(A.ORIGIN_TO_DIVISION_ID, XA.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                          AND NVL(A.ELECTRODE_TYPE, '-') = NVL(XA.P_ELECTRODE_TYPE, '-')
                          AND XA.P_ACTIVE_FLAG          = 'M');

        --3. Fix History
        P_SEMI_FIX_HIST_DS;

        --4. 삭제
        DELETE FROM SCP_ANL_SHIPMENT_PLAN_FIX A
         WHERE EXISTS (SELECT 1
                         FROM GT_SCP0010_FIX B
                        WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                          AND A.BIZ_TYPE                = B.P_BIZ_TYPE
                          AND A.ITEM_ID                 = B.P_ITEM_ID
                          AND A.TO_SITE                 = B.P_TO_SITE
                          AND A.FROM_SITE               = B.P_FROM_SITE
                          AND A.BOD_ID                  = B.P_BOD_ID
                          AND A.YYYYMMDD                = B.P_YYYYMMDD
                          AND DECODE(A.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                          AND DECODE(A.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                          AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                          AND B.P_ACTIVE_FLAG           = 'D');

        COMMIT;

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        -- 결과코드, 결과 카운트 반환
        OPEN O_RC1 FOR
            SELECT 'S'              AS RESULT_CODE
                 , V_MAX_LOOP_CNT   AS RESULT_CNT
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'              AS CODE
                 , 'SUCCESS'        AS MSG
                 , V_MAX_LOOP_CNT   AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SQLERRM;
            V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            BEGIN
                ROLLBACK TO SAVEPOINT SP_SCP0010_FIX_DS;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            P_LOG_ERROR(V_PROGRAM_NAME, P_USER_ID, V_ERR_CODE, V_ERR_MESSAGE, V_BACKTRACE);

            -- error코드, errror 메시지 반환
            OPEN O_RC1 FOR
                SELECT 'F'                                          AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE    AS ERR_MESSAGE
                  FROM DUAL;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'                                         AS CODE
                     , V_ERR_MESSAGE                                AS MSG
                     , '0'                                          AS EVENT
                  FROM DUAL;

    END P_SCP0010_SAVE_SEMI_FIX_DS;


    /* ==============================================================================================
       주차 저장
       AS-IS : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY
       ============================================================================================== */
    PROCEDURE P_SCP0010_SAVE_SEMI_WEEKLY
    (
        P_DATA                  IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY
     * Description  : ANL SHIPMENT PLAN SEMI save
     * Program History
     *===================================================================================================
     *   Date       In Charge		Description
     *===================================================================================================
     * 2022/09/07	jahn1501		PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 - 주차별 수량 입력
     * 2022/12/05   jahn1501        PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - Parial Weekly 수량 입력 가능하도록 변경
     * 2025/11/11   hrkim			[PJ2025F254] [LGES] JV법인 ESS 혼용 생산 시스템 개선
     *								  : ESS 가상 사이트 계획을 매핑된 JV 사이트 계획으로 동기화 저장 (ESS 가상 -> JV Real 단방향 저장)
     *									- @SCP0010를 @SCP0010_WITH_JV 변수로 대체하여 사용
     *									- TO Site 정보는 그대로 가져간다. (BOD_ID는 매핑이 안되면 '-')
     *								    - 2025.12.16 동기화 대상 데이터 from/to 사이트와 무관하게 origin from/to division_id 컬럼 division_id와 같은 값으로 저장(81_ST) : 김춘동 책임님
     *								    - 2025.12.23 동기화 데이터 생성시 BOD_ID 매핑이 안되는 경우 ESS 가상 사이트 BOD_ID 유지
     * 2026.09.17   AJS             MSSQL -> Oracle 전환
     *                              - 항차 분배 동적 SQL(EXEC) 은 분배횟수 갈래별 정적 SQL 로 옮긴다
     *                              - WEEKLY 이력 저장은 행마다 입력 전체를 반복 기록하던 것을 반복 뒤 한 번 기록으로 바꾼다
     *                              - 분배표는 반복마다 쌓이므로(AS-IS 동일) 같은 열쇠가 여러 번 나오면 마지막 반복 값을 쓴다
     *                              - 순번(SEQ = 1) 요일은 BOD 요일 칸 순서(월~일)로 정한다
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SCP0010_SAVE_ANL_SHIPMENT_PLAN_SEMI_WEEKLY';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        V_START_TIME        DATE := SYSDATE;
        V_EXEC_TIME         VARCHAR2(10 CHAR);
        V_TIME_ZONE         VARCHAR2(100 CHAR);
        V_CREATION_DATE     DATE;               -- timezone에 따른 저장위해서
        V_BUCKET            VARCHAR2(50 CHAR);
        V_MAX_LOOP_CNT      VARCHAR2(50 CHAR);
        V_LOOP_NO           PLS_INTEGER := 0;
        V_LAST_USER         VARCHAR2(150 CHAR);
        /* 항차별 LOT SIZE 분배 */
        V_MM                VARCHAR2(10 CHAR);
        V_YYYYWW            VARCHAR2(10 CHAR);
        V_QTY               NUMBER;
        V_LOTSIZE           NUMBER;
        V_LOT_FOUND         PLS_INTEGER;
        V_SHIP_DAYS         NUMBER;
        V_SHIP_COUNT        NUMBER;
        V_A                 NUMBER;             --나머지
        V_C                 NUMBER;             --몫
        V_SUM               NUMBER;
        V_MO                NUMBER;             --몫
        V_CNT               PLS_INTEGER;
        V_ROW_CNT           PLS_INTEGER;
        V_ALL_CNT           NUMBER;
        V_ERR_CODE          VARCHAR2(20 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_BACKTRACE         VARCHAR2(4000 CHAR);
    BEGIN

        /* 되돌리기 기준점 (AS-IS : BEGIN TRAN) */
        SAVEPOINT SP_SCP0010_WEEKLY;

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0010_INPUT;
        DELETE FROM GT_SCP0010_DYNAMIC;
        DELETE FROM GT_SCP0010_LAST_INFO;
        DELETE FROM GT_SCP0010_SHIP_EXIST_INFO;

        -- 시작 LOG
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        /* 입력 적재 + JV 동기화 대상 추가 (@SCP0010_WITH_JV) */
        P_LOAD_INPUT(P_DATA, P_USER_ID);
        P_ADD_JV_INPUT('N');

        SELECT MAX(P_BUCKET_TYPE) KEEP (DENSE_RANK FIRST ORDER BY ROW_NO)
             , MAX(P_TIME_ZONE) KEEP (DENSE_RANK FIRST ORDER BY ROW_NO)
          INTO V_BUCKET
             , V_TIME_ZONE
          FROM GT_SCP0010_INPUT;

        --TimeZone set
        IF V_TIME_ZONE IS NULL THEN
            V_TIME_ZONE := 'AS054';
        END IF;

        V_CREATION_DATE := FN_MULTY_TIME(V_TIME_ZONE);

        IF V_BUCKET = 'DAILY' THEN

            -- 임시테이블 데이타 생성
            INSERT INTO GT_SCP0010_DYNAMIC
            (
                A
              , P_ACTIVE_FLAG
              , P_DIVISION_ID
              , P_PLAN_START_YYYYMMDD
              , P_PLAN_TYPE
              , P_SEQ
              , P_OPERATION_GROUP
              , P_ITEM_ID
              , P_FROM_SITE
              , P_BOD_ID
              , P_MEASURE
              , P_YYYYMMDD
              , P_TO_SITE
              , P_QTY
              , P_ORIGIN_FROM_DIVISION_ID
              , P_ORIGIN_TO_DIVISION_ID
              , P_ELECTRODE_TYPE
              , P_CREATED_BY
              , P_LAST_UPDATED_BY
              , P_TIME_ZONE
              , P_CPLT_FLAG
            )
            SELECT A
                 , P_ACTIVE_FLAG
                 , P_DIVISION_ID
                 , P_PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE
                 , P_SEQ
                 , P_OPERATION_GROUP
                 , P_ITEM_ID
                 , P_FROM_SITE
                 , P_BOD_ID
                 , P_MEASURE
                 , P_YYYYMMDD
                 , P_TO_SITE
                 , P_QTY
                 , P_ORIGIN_FROM_DIVISION_ID
                 , P_ORIGIN_TO_DIVISION_ID
                 , P_ELECTRODE_TYPE
                 , P_CREATED_BY
                 , P_LAST_UPDATED_BY
                 , P_TIME_ZONE
                 , NULL
              FROM GT_SCP0010_INPUT;

            --수정 Row
            SELECT TO_CHAR(COUNT(*))
              INTO V_MAX_LOOP_CNT
              FROM GT_SCP0010_DYNAMIC;

            /* 1. 수정수량 UPDATE (+ 반영 여부 표시)
               입력은 화면에서 고친 몇 건이므로 행마다 파티션 프루닝 + 기본키로 찾아 고친다.
               AS-IS 는 수정 뒤 원장에 열쇠가 있는 입력 행을 반영 완료로 표시한다 - 수정은 열쇠를 바꾸지 않으므로 수정된 행과 같다. */
            FOR R IN (SELECT ROWID AS RID
                           , P_DIVISION_ID
                           , P_PLAN_START_YYYYMMDD
                           , P_PLAN_TYPE
                           , P_SEQ
                           , P_OPERATION_GROUP
                           , P_ITEM_ID
                           , P_FROM_SITE
                           , P_BOD_ID
                           , P_MEASURE
                           , P_YYYYMMDD
                           , P_TO_SITE
                           , P_QTY
                           , P_ORIGIN_FROM_DIVISION_ID
                           , P_ORIGIN_TO_DIVISION_ID
                           , P_ELECTRODE_TYPE
                           , P_LAST_UPDATED_BY
                        FROM GT_SCP0010_DYNAMIC
                      WHERE P_ACTIVE_FLAG IN ('M', 'I'))
            LOOP

                -- 1. 수정수량 UPDATE
                UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI A
                   SET A.TO_SITE          = R.P_TO_SITE
                     , A.QTY              = TRUNC(TO_NUMBER(R.P_QTY))   /* cast(round (cast(B.p_qty as numeric(20,10)), 0 ,1) as int) - 세 번째 인자 1 은 절삭 */
                     , A.LAST_UPDATED_BY  = R.P_LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE = V_CREATION_DATE
                 WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(R.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                   AND A.DIVISION_ID             = R.P_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD     = R.P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE               = R.P_PLAN_TYPE
                   AND A.SEQ                     = TO_NUMBER(R.P_SEQ)
                   AND A.OPERATION_GROUP         = R.P_OPERATION_GROUP
                   AND A.ITEM_ID                 = R.P_ITEM_ID
                   AND A.FROM_SITE               = R.P_FROM_SITE
                   AND A.BOD_ID                  = R.P_BOD_ID
                   AND A.MEASURE                 = R.P_MEASURE
                   AND A.YYYYMMDD                = R.P_YYYYMMDD
                   AND DECODE(A.ORIGIN_FROM_DIVISION_ID, R.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1   /* 빈 값끼리 같음(AS-IS 빈 문자 비교) */
                   AND DECODE(A.ORIGIN_TO_DIVISION_ID, R.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                   AND DECODE(A.ELECTRODE_TYPE, R.P_ELECTRODE_TYPE, 1, 0)                   = 1;

                IF SQL%ROWCOUNT > 0 THEN
                    UPDATE GT_SCP0010_DYNAMIC
                       SET P_CPLT_FLAG = 'Y'
                     WHERE ROWID = R.RID;
                END IF;

            END LOOP;

            -- 2. 신규수량 INSERT]
            INSERT INTO SCP_ANL_SHIPMENT_PLAN_SEMI
            (
                DIVISION_ID
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , OPERATION_GROUP
              , ITEM_ID
              , FROM_SITE
              , BOD_ID
              , MEASURE
              , YYYYMMDD
              , TO_SITE
              , QTY
              , ORIGIN_FROM_DIVISION_ID
              , ORIGIN_TO_DIVISION_ID
              , ELECTRODE_TYPE
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
            )
            SELECT P_DIVISION_ID
                 , P_PLAN_START_YYYYMMDD
                 , P_PLAN_TYPE
                 , TO_NUMBER(P_SEQ)
                 , P_OPERATION_GROUP
                 , P_ITEM_ID
                 , P_FROM_SITE
                 , P_BOD_ID
                 , P_MEASURE
                 , P_YYYYMMDD
                 , P_TO_SITE
                 , TRUNC(TO_NUMBER(P_QTY))
                 , P_ORIGIN_FROM_DIVISION_ID
                 , P_ORIGIN_TO_DIVISION_ID
                 , P_ELECTRODE_TYPE
                 , P_CREATED_BY
                 , V_CREATION_DATE
                 , P_LAST_UPDATED_BY
                 , V_CREATION_DATE
              FROM GT_SCP0010_DYNAMIC
             WHERE P_ACTIVE_FLAG IN ('M', 'I')
               AND P_CPLT_FLAG IS NULL;

            -- 3. 삭제수량 DELETE
            FOR R IN (SELECT ROWID AS RID
                           , P_DIVISION_ID
                           , P_PLAN_START_YYYYMMDD
                           , P_PLAN_TYPE
                           , P_SEQ
                           , P_OPERATION_GROUP
                           , P_ITEM_ID
                           , P_FROM_SITE
                           , P_BOD_ID
                           , P_MEASURE
                           , P_YYYYMMDD
                           , P_TO_SITE
                           , P_QTY
                           , P_ORIGIN_FROM_DIVISION_ID
                           , P_ORIGIN_TO_DIVISION_ID
                           , P_ELECTRODE_TYPE
                           , P_LAST_UPDATED_BY
                        FROM GT_SCP0010_DYNAMIC
                      WHERE P_ACTIVE_FLAG = 'D')
            LOOP

                DELETE FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(R.P_PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                   AND A.DIVISION_ID             = R.P_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD     = R.P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE               = R.P_PLAN_TYPE
                   AND A.SEQ                     = TO_NUMBER(R.P_SEQ)
                   AND A.OPERATION_GROUP         = R.P_OPERATION_GROUP
                   AND A.ITEM_ID                 = R.P_ITEM_ID
                   AND A.FROM_SITE               = R.P_FROM_SITE
                   AND A.BOD_ID                  = R.P_BOD_ID
                   AND A.MEASURE                 = R.P_MEASURE
                   AND A.YYYYMMDD                = R.P_YYYYMMDD
                   AND DECODE(A.ORIGIN_FROM_DIVISION_ID, R.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1   /* 빈 값끼리 같음(AS-IS 빈 문자 비교) */
                   AND DECODE(A.ORIGIN_TO_DIVISION_ID, R.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                   AND DECODE(A.ELECTRODE_TYPE, R.P_ELECTRODE_TYPE, 1, 0)                   = 1;

            END LOOP;

            -- 4. FIX수량 UPDATE
            UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
               SET (A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
                 = (SELECT TO_NUMBER(B.P_QTY)   /* A.qty = B.p_qty (절삭 없음) */
                         , B.P_LAST_UPDATED_BY
                         , V_CREATION_DATE
                      FROM GT_SCP0010_DYNAMIC B
                     WHERE A.DIVISION_ID             = B.P_DIVISION_ID
                       AND A.BIZ_TYPE                = B.P_OPERATION_GROUP
                       AND A.ITEM_ID                 = B.P_ITEM_ID
                       AND A.TO_SITE                 = B.P_TO_SITE
                       AND A.FROM_SITE               = B.P_FROM_SITE
                       AND A.BOD_ID                  = B.P_BOD_ID
                       AND A.YYYYMMDD                = B.P_YYYYMMDD
                       AND DECODE(A.ORIGIN_FROM_DIVISION_ID, B.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                       AND DECODE(A.ORIGIN_TO_DIVISION_ID, B.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                       AND NVL(A.ELECTRODE_TYPE, '-') = NVL(B.P_ELECTRODE_TYPE, '-')
                       AND ROWNUM = 1)
             WHERE EXISTS (SELECT 1
                             FROM GT_SCP0010_DYNAMIC XA
                            WHERE A.DIVISION_ID             = XA.P_DIVISION_ID
                              AND A.BIZ_TYPE                = XA.P_OPERATION_GROUP
                              AND A.ITEM_ID                 = XA.P_ITEM_ID
                              AND A.TO_SITE                 = XA.P_TO_SITE
                              AND A.FROM_SITE               = XA.P_FROM_SITE
                              AND A.BOD_ID                  = XA.P_BOD_ID
                              AND A.YYYYMMDD                = XA.P_YYYYMMDD
                              AND DECODE(A.ORIGIN_FROM_DIVISION_ID, XA.P_ORIGIN_FROM_DIVISION_ID, 1, 0) = 1
                              AND DECODE(A.ORIGIN_TO_DIVISION_ID, XA.P_ORIGIN_TO_DIVISION_ID, 1, 0)     = 1
                              AND NVL(A.ELECTRODE_TYPE, '-') = NVL(XA.P_ELECTRODE_TYPE, '-'));

            -- 5. FIX이력저장
            P_SEMI_FIX_HIST_DS;

            -- 6. 이력저장
            P_SEMI_HIST_DS;

            COMMIT;

        ELSE --WEEKLY

            --수정 Row
            SELECT TO_CHAR(COUNT(*))
              INTO V_MAX_LOOP_CNT
              FROM GT_SCP0010_INPUT;

            FOR CUR IN (SELECT P_DIVISION_ID
                             , P_ITEM_ID
                             , P_FROM_SITE
                             , P_TO_SITE
                             , P_QTY
                             , P_PLAN_TYPE
                             , P_BOD_ID
                             , P_PLAN_START_YYYYMMDD
                             , P_SEQ
                             , P_YYYYMMDD
                             , P_TRANS_MODE
                             , P_LAST_UPDATED_BY
                          FROM GT_SCP0010_INPUT
                         ORDER BY ROW_NO)
            LOOP

                V_LOOP_NO   := V_LOOP_NO + 1;
                V_LAST_USER := CUR.P_LAST_UPDATED_BY;

                DELETE FROM GT_SCP0010_SHIP_EXIST_INFO;

                V_MM     := SUBSTR(CUR.P_YYYYMMDD, 5, 2);
                V_YYYYWW := SUBSTR(CUR.P_YYYYMMDD, 1, 4) || SUBSTR(CUR.P_YYYYMMDD, 7, 2);

                /* AS-IS 수량은 정수 변환(빈 값은 0, 소수는 변환 오류) */
                IF CUR.P_QTY IS NULL THEN
                    V_QTY := 0;
                ELSIF REGEXP_LIKE(CUR.P_QTY, '^ *[+-]?[0-9]+ *$') THEN
                    V_QTY := TO_NUMBER(TRIM(CUR.P_QTY));
                ELSE
                    RAISE_APPLICATION_ERROR(-20001, 'Conversion failed when converting the value ''' || CUR.P_QTY || ''' to data type int.');
                END IF;

                -- 주차 정보 조회
                /* #SHIPMENT_EXIST_DATA + 달력 = #SHIPMENT_EXIST_INFO */
                INSERT INTO GT_SCP0010_SHIP_EXIST_INFO
                (
                    UNPVT_NO
                  , DIVISION_ID
                  , BOD_ID
                  , FROM_SITE
                  , TO_SITE
                  , SHIP_LT_TOTAL
                  , DAYOFWEEK_NM
                  , DAYOFWEEK_CD
                  , EXIST_YN
                  , TRANSPORT_MODE
                  , REMARK
                  , CALENDAR_MONTH
                )
                SELECT IA.UNPVT_NO
                     , IA.DIVISION_ID
                     , IA.BOD_ID
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.SHIP_LT_TOTAL
                     , IA.DAYOFWEEK
                     , IA.DAYOFWEEK_CD
                     , IA.EXIST_YN
                     , IA.TRANSPORT_MODE
                     , NULL                 --lotsize가 입력 수량보다 클때 분배요일 재지정
                     , B.CALENDAR_MONTH
                  FROM (SELECT XA.DIVISION_ID
                             , XA.BOD_ID
                             , XA.FROM_SITE
                             , XA.TO_SITE
                             , XA.SHIP_LT_TOTAL
                             , XA.TRANSPORT_MODE
                             , XA.DAYOFWEEK
                             , XA.EXIST_YN
                             , DECODE(XA.DAYOFWEEK, 'DAYS_MON', 1, 'DAYS_TUE', 2, 'DAYS_WED', 3, 'DAYS_THU', 4
                                                  , 'DAYS_FRI', 5, 'DAYS_SAT', 6, 'DAYS_SUN', 7)                 AS UNPVT_NO
                             , DECODE(XA.DAYOFWEEK, 'DAYS_MON', '2', 'DAYS_TUE', '3', 'DAYS_WED', '4', 'DAYS_THU', '5'
                                                  , 'DAYS_FRI', '6', 'DAYS_SAT', '7', 'DAYS_SUN', '1')           AS DAYOFWEEK_CD
                          FROM (SELECT DIVISION_ID
                                     , BOD_ID
                                     , FROM_SITE
                                     , TO_SITE
                                     , SHIP_LT_TOTAL
                                     , TRANSPORT_MODE
                                     , DAYS_MON
                                     , DAYS_TUE
                                     , DAYS_WED
                                     , DAYS_THU
                                     , DAYS_FRI
                                     , DAYS_SAT
                                     , DAYS_SUN
                                  FROM SCP_MST_BOD_N_V
                                 WHERE DIVISION_ID = CUR.P_DIVISION_ID
                                   AND BOD_ID      = CUR.P_BOD_ID)
                         UNPIVOT (EXIST_YN FOR DAYOFWEEK
                                  IN (DAYS_MON AS 'DAYS_MON', DAYS_TUE AS 'DAYS_TUE', DAYS_WED AS 'DAYS_WED', DAYS_THU AS 'DAYS_THU'
                                    , DAYS_FRI AS 'DAYS_FRI', DAYS_SAT AS 'DAYS_SAT', DAYS_SUN AS 'DAYS_SUN')) XA
                       ) IA
                     , SCM_SYS_CALENDAR_M B
                 WHERE B.DAYOFWEEK_NO = TO_NUMBER(IA.DAYOFWEEK_CD)
                   AND B.ISO_YYYYWW   = V_YYYYWW;

                -- 분배횟수
                SELECT COUNT(*)
                  INTO V_SHIP_COUNT
                  FROM GT_SCP0010_SHIP_EXIST_INFO A
                     , SCM_SYS_CALENDAR_M B
                 WHERE B.DAYOFWEEK_NO   = TO_NUMBER(A.DAYOFWEEK_CD)
                   AND A.EXIST_YN       = 'Y'
                   AND B.ISO_YYYYWW     = V_YYYYWW
                   AND B.CALENDAR_MONTH = V_MM;

                -- 출하 Lot Size
                /* AS-IS 변수는 반복마다 빈 문자로 다시 초기화된다 */
                SELECT COUNT(*)
                     , MAX(LOT_SIZE)
                  INTO V_LOT_FOUND
                     , V_LOTSIZE
                  FROM SCP_MST_SHIPMENT_LOT_SIZE
                 WHERE DIVISION_ID    = CUR.P_DIVISION_ID
                   AND ITEM_ID        = CUR.P_ITEM_ID
                   AND FROM_SITE      = CUR.P_FROM_SITE
                   AND TO_SITE        = CUR.P_TO_SITE
                   AND TRANSPORT_MODE = CUR.P_TRANS_MODE
                   AND VALID_YN       = 'Y';

                IF V_LOT_FOUND = 0 THEN
                    V_LOTSIZE := 0;     /* 빈 문자 = 0 */
                END IF;

                IF V_LOTSIZE = 0 THEN
                    V_LOTSIZE := 1;
                END IF;

                V_SHIP_DAYS := CASE WHEN V_SHIP_COUNT = 0 THEN 1 ELSE V_SHIP_COUNT END;

                -- 항차분배 계산
                /* MSSQL 정수 나눗셈이므로 TRUNC */
                V_A := CASE WHEN MOD(V_QTY, V_LOTSIZE * V_SHIP_DAYS) = 0 THEN 0 ELSE MOD(V_QTY, V_LOTSIZE * V_SHIP_DAYS) END;     --나머지
                V_C := 1;

                --입력수량보다 @v_a 같은 경우 (몫이 lotsize보다 작을수없다.)
                IF V_A = V_QTY THEN

                    V_A         := CASE WHEN V_QTY < V_LOTSIZE THEN 0 ELSE MOD(V_QTY, V_LOTSIZE) END;
                    V_C         := CASE WHEN V_QTY < V_LOTSIZE OR V_SHIP_DAYS = 1 THEN V_QTY
                                        ELSE TRUNC((V_QTY - V_A) / TRUNC(V_QTY / V_LOTSIZE)) END;
                    V_SHIP_DAYS := CASE WHEN V_QTY < V_LOTSIZE THEN 1 ELSE TRUNC(V_QTY / V_LOTSIZE) END;
                    V_ROW_CNT   := 2;
                    V_ALL_CNT   := 0;
                    V_CNT       := 0;

                    WHILE 7 > V_CNT
                    LOOP

                        V_CNT := V_CNT + 1;

                        UPDATE GT_SCP0010_SHIP_EXIST_INFO
                           SET REMARK = 'Y'
                         WHERE DAYOFWEEK_CD   = TO_CHAR(V_ROW_CNT)
                           AND EXIST_YN       = 'Y'
                           AND CALENDAR_MONTH = V_MM;

                        V_ROW_CNT := V_ROW_CNT + 1;

                        IF V_ROW_CNT = 7 THEN
                            V_ROW_CNT := 1;
                        END IF;

                        SELECT COUNT(*)
                          INTO V_ALL_CNT
                          FROM GT_SCP0010_SHIP_EXIST_INFO
                         WHERE REMARK = 'Y';

                        IF V_ALL_CNT = V_SHIP_DAYS THEN

                            UPDATE GT_SCP0010_SHIP_EXIST_INFO
                               SET REMARK = 'N'
                             WHERE REMARK IS NULL;

                            EXIT;

                        END IF;

                    END LOOP;

                ELSE

                    V_C := CASE WHEN V_A = 0 THEN TRUNC(V_QTY / V_SHIP_DAYS) ELSE TRUNC((V_QTY - V_A) / V_SHIP_DAYS) END;

                END IF;

                V_SUM := V_A + V_C;
                V_MO  := V_C;

                /* AS-IS 는 LOT_SIZE 가 NULL 이면 조립 문자열이 NULL 이 되어 분배 적재를 건너뛴다 */
                IF V_SUM IS NOT NULL THEN

                    INSERT INTO GT_SCP0010_LAST_INFO
                    (
                        LOOP_NO
                      , LT_WEEK
                      , EXIST_YN
                      , BASIS_YYYYMMDD
                      , QTY
                      , DIVISION_ID
                      , BOD_ID
                      , ITEM_ID
                      , PLAN_TYPE
                      , PLAN_START_YYYYMMDD
                    )
                    SELECT V_LOOP_NO
                         , TO_CHAR(CASE WHEN IA.TRANSPORT_MODE = 'TRK' THEN TO_NUMBER(IA.DAYOFWEEK_CD) ELSE IA.LT_WEEK END)   AS LT_WEEK
                         , IA.EXIST_YN
                         , IA.BASIS_YYYYMMDD
                         , CASE WHEN V_SHIP_COUNT = 1                   /* 분배 1회 */
                                THEN CASE WHEN IA.DAYOFWEEK_CD IS NOT NULL AND IA.EXIST_YN = 'Y' AND IA.CALENDAR_MONTH = V_MM THEN V_SUM ELSE 0 END
                                WHEN V_SHIP_COUNT = 0                   /* 분배 없음 */
                                THEN CASE WHEN IA.DAYOFWEEK_CD IS NOT NULL AND IA.CALENDAR_MONTH = V_MM AND IA.SEQ = 1 THEN V_SUM ELSE 0 END
                                WHEN V_SHIP_COUNT <> V_SHIP_DAYS        /* lotsize 가 입력 수량보다 큰 경우 Remark = 'Y' 로 분배 */
                                THEN CASE WHEN IA.DAYOFWEEK_CD IS NULL OR IA.REMARK <> 'Y' OR IA.REMARK IS NULL THEN 0
                                          WHEN IA.CALENDAR_MONTH = V_MM THEN CASE WHEN IA.SEQ = 1 THEN V_SUM ELSE V_MO END
                                          WHEN IA.DAYOFWEEK_CD = '2' THEN V_SUM
                                          ELSE 0
                                     END
                                ELSE CASE WHEN IA.DAYOFWEEK_CD IS NULL OR IA.EXIST_YN <> 'Y' OR IA.EXIST_YN IS NULL THEN 0
                                          WHEN IA.CALENDAR_MONTH = V_MM THEN CASE WHEN IA.SEQ = 1 THEN V_SUM ELSE V_MO END
                                          WHEN IA.DAYOFWEEK_CD = '2' THEN V_SUM
                                          ELSE 0
                                     END
                           END                                                                                  AS QTY
                         , IA.DIVISION_ID
                         , IA.BOD_ID
                         , IA.ITEM_ID
                         , IA.PLAN_TYPE
                         , IA.PLAN_START_YYYYMMDD
                      FROM (SELECT A.EXIST_YN
                                 , A.REMARK
                                 , A.DAYOFWEEK_CD
                                 , A.SHIP_LT_TOTAL
                                 , CASE WHEN TO_NUMBER(A.DAYOFWEEK_CD) <= MOD(A.SHIP_LT_TOTAL, 7)
                                        THEN (7 + TO_NUMBER(A.DAYOFWEEK_CD)) - MOD(A.SHIP_LT_TOTAL, 7)
                                        ELSE TO_NUMBER(A.DAYOFWEEK_CD) - MOD(A.SHIP_LT_TOTAL, 7)
                                   END                                  AS LT_WEEK
                                 , A.TRANSPORT_MODE
                                 , A.DIVISION_ID
                                 , A.BOD_ID
                                 , A.FROM_SITE
                                 , A.TO_SITE
                                 , B.BASIS_YYYYMMDD
                                 , B.CALENDAR_MONTH
                                 , CUR.P_ITEM_ID                        AS ITEM_ID
                                 , CUR.P_PLAN_TYPE                      AS PLAN_TYPE
                                 , CUR.P_PLAN_START_YYYYMMDD            AS PLAN_START_YYYYMMDD
                                 , ROW_NUMBER() OVER (PARTITION BY A.CALENDAR_MONTH
                                                          ORDER BY A.UNPVT_NO)  AS SEQ
                              FROM GT_SCP0010_SHIP_EXIST_INFO A
                                 , SCM_SYS_CALENDAR_M B
                             WHERE B.DAYOFWEEK_NO   = TO_NUMBER(A.DAYOFWEEK_CD)
                               AND B.ISO_YYYYWW     = V_YYYYWW
                               AND A.CALENDAR_MONTH = V_MM
                           ) IA;

                END IF;

            END LOOP;

            /* 분배표 적용
               AS-IS 는 반복마다 누적된 분배표 전체로 일자 수량과 FIX 수량을 다시 고친다(행마다 반복).
               반복 중에는 원장을 읽지 않으므로, 반복이 끝난 뒤 열쇠별 마지막 반복 값으로 한 번 고친 결과와 같다. */
            FOR L IN (SELECT PLAN_START_YYYYMMDD
                           , BASIS_YYYYMMDD
                           , DIVISION_ID
                           , BOD_ID
                           , PLAN_TYPE
                           , ITEM_ID
                           , MAX(QTY) KEEP (DENSE_RANK LAST ORDER BY LOOP_NO) AS QTY
                           , MAX(LOOP_NO)                                     AS LOOP_NO
                        FROM GT_SCP0010_LAST_INFO
                       GROUP BY PLAN_START_YYYYMMDD
                              , BASIS_YYYYMMDD
                              , DIVISION_ID
                              , BOD_ID
                              , PLAN_TYPE
                              , ITEM_ID
                       ORDER BY LOOP_NO)
            LOOP

                /* Daily Update. */
                UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI A
                   SET A.QTY              = L.QTY
                     , A.LAST_UPDATE_DATE = NVL(V_CREATION_DATE, SYSDATE)
                     , A.LAST_UPDATED_BY  = V_LAST_USER
                 WHERE A.PLAN_START_YYYYMMDD_DATE = TO_DATE(L.PLAN_START_YYYYMMDD, 'YYYYMMDD')   /* 파티션 프루닝 */
                   AND A.YYYYMMDD            = L.BASIS_YYYYMMDD
                   AND A.DIVISION_ID         = L.DIVISION_ID
                   AND A.BOD_ID              = L.BOD_ID
                   AND A.PLAN_TYPE           = L.PLAN_TYPE
                   AND A.PLAN_START_YYYYMMDD = L.PLAN_START_YYYYMMDD
                   AND A.ITEM_ID             = L.ITEM_ID
                   AND A.MEASURE             = 'SHIP_PLAN_AMEND';

                --  FIX수량 UPDATE
                UPDATE SCP_ANL_SHIPMENT_PLAN_FIX A
                   SET A.QTY              = L.QTY
                     , A.LAST_UPDATED_BY  = V_LAST_USER
                     , A.LAST_UPDATE_DATE = NVL(V_CREATION_DATE, SYSDATE)
                 WHERE A.DIVISION_ID = L.DIVISION_ID
                   AND A.ITEM_ID     = L.ITEM_ID
                   AND A.BOD_ID      = L.BOD_ID
                   AND A.YYYYMMDD    = L.BASIS_YYYYMMDD;

            END LOOP;

            -- 5. FIX이력저장
            P_SEMI_FIX_HIST_DS;

            -- 6. 이력저장
            P_SEMI_HIST_DS;

            COMMIT;

        END IF;

        V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0')
                    || ':'
                    || LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0');

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '[' || V_EXEC_TIME || ']';
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, SYSDATE);

        COMMIT;

        -- 결과코드, 결과 카운트 반환
        OPEN O_RC1 FOR
            SELECT 'S'              AS RESULT_CODE
                 , V_MAX_LOOP_CNT   AS RESULT_CNT
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'              AS CODE
                 , 'SUCCESS'        AS MSG
                 , V_MAX_LOOP_CNT   AS EVENT
              FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := TO_CHAR(SQLCODE);
            V_ERR_MESSAGE := SQLERRM;
            V_BACKTRACE   := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            BEGIN
                ROLLBACK TO SAVEPOINT SP_SCP0010_WEEKLY;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            P_LOG_ERROR(V_PROGRAM_NAME, P_USER_ID, V_ERR_CODE, V_ERR_MESSAGE, V_BACKTRACE);

            OPEN O_RC1 FOR
                SELECT 'F'                                          AS RESULT_CODE
                     , '[' || V_ERR_CODE || ']' || V_ERR_MESSAGE    AS ERR_MESSAGE
                  FROM DUAL;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1'                                         AS CODE
                     , V_ERR_MESSAGE                                AS MSG
                     , '0'                                          AS EVENT
                  FROM DUAL;

    END P_SCP0010_SAVE_SEMI_WEEKLY;


    /* ==============================================================================================
       [내부] MSSQL DATEADD(MONTH) 와 같은 월 더하기
       Oracle ADD_MONTHS 는 말일이면 대상 월의 말일로 옮기므로 일자를 원래 일자로 되돌린다.
       ============================================================================================== */
    FUNCTION F_ADD_MONTHS_MS
    (
        P_YYYYMMDD      IN VARCHAR2,
        P_MONTHS        IN NUMBER
    )
    RETURN VARCHAR2
    IS
        V_BASE          DATE := TO_DATE(P_YYYYMMDD, 'YYYYMMDD');
        V_RESULT        DATE;
    BEGIN

        V_RESULT := ADD_MONTHS(V_BASE, P_MONTHS);

        IF TO_NUMBER(TO_CHAR(V_RESULT, 'DD')) > TO_NUMBER(TO_CHAR(V_BASE, 'DD')) THEN
            V_RESULT := TRUNC(V_RESULT, 'MM') + TO_NUMBER(TO_CHAR(V_BASE, 'DD')) - 1;
        END IF;

        RETURN TO_CHAR(V_RESULT, 'YYYYMMDD');

    END F_ADD_MONTHS_MS;


    /* ==============================================================================================
       [내부] 긴 문자열을 4,000 자씩 출력 (AS-IS : PRINT SUBSTRING(@mEXEC,@POS,4000))
       ============================================================================================== */
    PROCEDURE P_PRINT_CLOB
    (
        P_TEXT          IN CLOB
    )
    IS
        V_POS           PLS_INTEGER := 1;
        V_LEN           PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_TEXT), 0);
    BEGIN

        WHILE V_POS <= V_LEN
        LOOP
            DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(P_TEXT, 4000, V_POS));
            V_POS := V_POS + 4000;
        END LOOP;

    END P_PRINT_CLOB;


    /* ==============================================================================================
       Shipment Plan SEMI 조회
       AS-IS : SCP0010_GET_SHIPMENT_PLAN_SEMI
       ============================================================================================== */
    PROCEDURE P_SCP0010_GET_SHIP_PLAN_SEMI
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_OPERATION_GROUP       IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_ELECTYPE              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROMSITE              IN  VARCHAR2,
        P_TOSITE                IN  VARCHAR2,
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SCP0010',
        P_SHEET_NAME            IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SCP0010_GET_SHIPMENT_PLAN_SEMI
     * Description  : Shipment Plan 조회
     * Program History
     *===================================================================================================
     * Date         In Charge		Description
     *===================================================================================================
     * 2018/01/29   byunghunjung	          Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018-05-16	KYH				          PR 수정 못하도록
     * 2018/05/22	byunghunjung	          order by 순서 변경
     * 2018/05/29	KYH				          fix정보 조회
     * 2018/05/31	KYH				          fix history저장 부분 수정 & 1년조회시 년도가 다른 같은 월 조회시 sum이 표시되는 문제 ex) 2018.0528 ~ 2019.0527 조회시 2019.5월 (마지막 주)에 2018.5월 sum값 표시
     * 2018/07/03	KYH				          fix정보 관련 날짜 추가
     * 2018/07/02	KYH				          신규 컬럼 추가 조회. (ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, ELECTRODE_TYPE)
     * 2018/08/13	YHW				          #TblDynamicPivot_SCP0009_02 measure_order_no 데이터 타입 INT로 변경
     * 2018/09/14   ygkim			          속도 개선(함수제거)
     * 2018/10/04   ygkim                     SCP_MST_SHIPMENT_SEMI_DEPT_DAY 조인 추가, Dept_Day 컬럼 추가
     * 2018/11/30	YHW				          SHIP FROZEN 일수 조정
     * 2019/03/08	YHW				          [CSR:]실적구간 조회쿼리 수정
     * 2019/05/15	YHW				          [CSR ID:3992947] 사용자 PC환경에 따른 SHIP FROZEN 구간 미지정 현상 사전조치(Shipment Plan FG, SEMI)
     * 2019/10/21	YHW				          오류수정 - 출하실적 조회 시 "삭제"수량 제외 r.EXFACTORY_STATUS IN ('D20','D30','D40')
     * 2020/03/12	YHW				          긴급수정 - Ship Frozen 전일기준->플랜일자 기준으로 변경
     * 2020/07/27	khj79			          [CSR ID :C20200716-000315] GSCM - Shipment plan semi에서 From site 추가 요청의건
     * 2021/07/12	kmj				          PJ20209643 LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - UI 속도 개선
     * 2021/07/22   khj79			          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - 중장기 프로젝트(기간82주로 연장)
     * 2021/07/20   khj79			          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - BOD 2단계 개발 : FROM,TO 추가 , scp_mst_bod_v=> scp_mst_bod_n_v
     * 2022/01/26   khj79			          [PJ20216891] LGES Digital SCM 3 Level 가속화를 위한 개선 - DC LINK 수정(PACK -> PACK)
     * 2022.05.13   LSC                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : GM JV 추가
     * 2022.05.26   LWY                       PJ20216891 Digital SCM 3 Level 가속화를 위한 개선 : Shiment Plan SEMI 출하실적 개선 (Copy : SHIP_PLAN -> SHIP_PLAN_AMEND)
     * 2022/06/27   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - BOD L/T History 변경 (SCP_MST_BOD_N_V => SCP_ANL_BOD_N_V_PLAN_H)
     * 2022/09/15   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 속도개선 작업
     * 2022-12-05   jahn1501                  PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - ESS 출하확정구간 변경
     * 2023/04/10   LWY				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
     * 2023.06.23   KJJ				          PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Like 검색기능
     * 2023.12.05   KSG                       E20231128-000517 Display the passed performance for Isuzu modue (AMDMO0001A) : 실적 조회 수정
     * 2024-01-08   chaan                     PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선
     * 2024-01-19   chaan           V1.1.1    PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - UI성능개선 - 조회조건 속도 개선 - 2차 튜닝
     * 2026.09.17   AJS                       MSSQL -> Oracle 전환
     *                                        - 피벗 컬럼(D_·W_·M_)이 조회 기간에 따라 달라지므로 본문 조회만 동적 SQL(바인드 사용)로 둔다
     *                                        - FIX 정보 조회는 동적 SQL 을 정적 SQL 로 옮긴다
     *                                        - AS-IS 는 정렬을 화면에서 하므로(ORDER BY 없음) 화면 정렬 순서를 ORDER BY 로 넣는다
     *                                        - GTT 통계수집(DBMS_STATS)은 호출자 트랜잭션을 커밋하므로 넣지 않는다
     * 2026.10.06   AJS                       조회 속도 개선 - 계획 원장은 계획 열쇠(PK) 인덱스로 읽고, 별칭 하위질의는 행별 조회 유지(결과 동일)
     * 2026.10.08   AJS                       조회 결함 조치 - 기간 칸 목록(V_QRY_COL)을 바깥 SELECT 의 ORIGIN_TO_DIVISION_ID 다음으로 이동 (ORA-00904)
     */
        V_PROGRAM_ID        VARCHAR2(100 CHAR) := NVL(P_PROGRAM_ID, 'SCP0010');   /* 화면이 값을 넘기지 않으면 AS-IS 기본값 */
        V_CNT_USR_MEASURE   NUMBER;             /* AS-IS nvarchar(1) - 10 이상이면 오버플로 오류 */
        V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
        V_FROM_RESULT       VARCHAR2(8 CHAR);
        V_TO_RESULT         VARCHAR2(8 CHAR);
        V_PLAN_START_DATE   DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');
        V_SEQ               NUMBER := TO_NUMBER(P_SEQ);
        V_EE_YN             VARCHAR2(1 CHAR);
        V_LAST_MONDAY       VARCHAR2(10 CHAR);
        V_IS_EDITABLE       VARCHAR2(1 CHAR);
        V_QRY_SUM           CLOB;
        V_EXEC              CLOB;
        V_QRY_COL           CLOB;   /* AJS 20261007 화면검증 */
        /* 조회 조건 목록 - 행마다 함수를 다시 부르지 않도록 한 번만 담는다 */
        V_ITEM_TAB          T_STR_TAB := T_STR_TAB();
        V_FROMSITE_TAB      T_STR_TAB := T_STR_TAB();
        V_TOSITE_TAB        T_STR_TAB := T_STR_TAB();
        V_ELECTYPE_TAB      T_STR_TAB := T_STR_TAB();
        /* AS-IS 는 (@p IS NULL OR @p = '') 로 선택 조건을 끄고, = 비교는 뒤 공백을 무시한다 - 공백만 넣어도 조건 없음 */
/* V_ITEM_ID           VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_ITEM_ID) IS NOT NULL THEN P_ITEM_ID END; */
        V_ITEM_ID           VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN P_ITEM_ID END;   /* AJS 20261007 화면검증 */
/* V_FROMSITE          VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_FROMSITE) IS NOT NULL THEN P_FROMSITE END; */
        V_FROMSITE          VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_FROMSITE) IS NOT NULL AND UPPER(TRIM(P_FROMSITE)) <> 'ALL' THEN P_FROMSITE END;   /* AJS 20261007 화면검증 */
/* V_TOSITE            VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_TOSITE) IS NOT NULL THEN P_TOSITE END; */
        V_TOSITE            VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_TOSITE) IS NOT NULL AND UPPER(TRIM(P_TOSITE)) <> 'ALL' THEN P_TOSITE END;   /* AJS 20261007 화면검증 */
/* V_ELECTYPE          VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_ELECTYPE) IS NOT NULL THEN P_ELECTYPE END; */
        V_ELECTYPE          VARCHAR2(4000 CHAR) := CASE WHEN TRIM(P_ELECTYPE) IS NOT NULL AND UPPER(TRIM(P_ELECTYPE)) <> 'ALL' THEN P_ELECTYPE END;   /* AJS 20261007 화면검증 */
    BEGIN

        /* GTT 초기화 (TRUNCATE 금지) */
        DELETE FROM GT_SCP0010_MEASURE;
        DELETE FROM GT_SCP0010_STD;
        DELETE FROM GT_SCP0010_VALUE;
        DELETE FROM GT_SCP0010_DATA;
        DELETE FROM GT_SCP0010_MAIN;
        DELETE FROM GT_SCP0010_BOH;
        DELETE FROM GT_SCP0010_ESS_TYPE_INFO;
        DELETE FROM GT_SCP0010_BOD_PLAN;

        IF V_ITEM_ID IS NOT NULL THEN
            SELECT COLUMN_VALUE
              BULK COLLECT INTO V_ITEM_TAB
              FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''));
        END IF;

        IF V_FROMSITE IS NOT NULL THEN
            SELECT UPPER(COLUMN_VALUE)          /* MSSQL 대소문자 무시 비교 - 원장 소문자 0건 */
              BULK COLLECT INTO V_FROMSITE_TAB
              FROM TABLE(STRING_SPLIT(V_FROMSITE, ','));
        END IF;

        IF V_TOSITE IS NOT NULL THEN
            SELECT UPPER(COLUMN_VALUE)          /* MSSQL 대소문자 무시 비교 - 원장에 소문자 행 있음(칸도 대문자로 비교) */
              BULK COLLECT INTO V_TOSITE_TAB
              FROM TABLE(STRING_SPLIT(V_TOSITE, ','));
        END IF;

        IF V_ELECTYPE IS NOT NULL THEN
            SELECT UPPER(COLUMN_VALUE)          /* MSSQL 대소문자 무시 비교 - 원장 소문자 0건 */
              BULK COLLECT INTO V_ELECTYPE_TAB
              FROM TABLE(STRING_SPLIT(V_ELECTYPE, ','));
        END IF;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE UPPER(PROGRAM_ID) = UPPER(V_PROGRAM_ID)      /* MSSQL 대소문자 무시 비교 - 원장에 소문자 섞임 */
           AND UPPER(SHEET_NAME) = UPPER(P_SHEET_NAME)
           AND UPPER(USER_ID)    = UPPER(P_USER_ID);

        /* 사업부 EE 계열 여부 (div_commonization) */
        SELECT NVL(MAX('Y'), 'N')
          INTO V_EE_YN
          FROM TABLE(FN_GET_DIVISION_DIV('EE'))
         WHERE COLUMN_VALUE = P_DIVISION_ID;

        SELECT MAX(BASIS_START_DATE)
          INTO V_FROM_YYYYMMDD
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;

        SELECT MAX(BASIS_START_DATE)
          INTO V_FROM_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = P_FROM_YYYYMMDD;

        SELECT MAX(BASIS_START_DATE)
          INTO V_TO_RESULT
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD = P_TO_YYYYMMDD;

        /* AS-IS 의 빈 문자('')는 어떤 값보다 작다. Oracle 에서는 NULL 이므로 그 순서로 판정한다.
           AS-IS 세 번째·네 번째 분기(@v_from_yyyymmdd > @v_to_result, = @v_to_result)는
           앞 두 분기가 모든 경우를 덮어 실행되지 않으므로 옮기지 않는다. */
        IF V_FROM_YYYYMMDD IS NOT NULL AND (V_FROM_RESULT IS NULL OR V_FROM_YYYYMMDD > V_FROM_RESULT) THEN
            -- 실적 보여줌
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_TO_RESULT   := V_FROM_YYYYMMDD;
        ELSE
            -- 실적 없음
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_FROM_RESULT := F_ADD_MONTHS_MS(P_PLAN_START_YYYYMMDD, 6);
            V_TO_RESULT   := F_ADD_MONTHS_MS(P_PLAN_START_YYYYMMDD, -6);
        END IF;

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
            DBMS_OUTPUT.PUT_LINE('v_from_yyyymmdd =' || V_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_to_yyyymmdd =' || V_TO_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('v_from_result =' || V_FROM_RESULT);
            DBMS_OUTPUT.PUT_LINE('v_to_result =' || V_TO_RESULT);
            DBMS_OUTPUT.PUT_LINE('----------------------------------');
        END IF;

        /********************************************************************************
        * 임시테이블만들기 - measure
        ********************************************************************************/
        INSERT INTO GT_SCP0010_MEASURE
        (
            MEASURE
          , MEASURE_NAME
          , USER_SORT_ORDER_NO
        )
        SELECT A.COLUMN_NAME
             , A.COLUMN_LABEL_NAME
             , NVL(B.SORT_ORDER_NO, A.SORT_ORDER_NO)
          FROM SCM_MST_SHEET_MEASURE A
             , SCM_MST_TITLESET_USER B
         WHERE UPPER(B.PROGRAM_ID(+))  = UPPER(A.PROGRAM_ID)      /* MSSQL 대소문자 무시 비교 */
           AND UPPER(B.SHEET_NAME(+))  = UPPER(A.SHEET_NAME)
           AND UPPER(B.COLUMN_NAME(+)) = UPPER(A.COLUMN_NAME)
           AND (V_CNT_USR_MEASURE = 0
                OR EXISTS (SELECT 1
                             FROM SCM_MST_TITLESET_USER XA
                            WHERE UPPER(XA.COLUMN_NAME) = UPPER(A.COLUMN_NAME)
                              AND UPPER(XA.PROGRAM_ID)  = UPPER(V_PROGRAM_ID)
                              AND UPPER(XA.SHEET_NAME)  = UPPER(P_SHEET_NAME)
                              AND UPPER(XA.USER_ID)     = UPPER(P_USER_ID)))
           AND A.VALID_YN       = 'Y'
           AND UPPER(B.USER_ID(+))    = UPPER(P_USER_ID)
           AND UPPER(A.PROGRAM_ID)    = UPPER(V_PROGRAM_ID)
           AND UPPER(A.SHEET_NAME)    = UPPER(P_SHEET_NAME);

        /* BOD L/T History (SCP_ANL_BOD_N_V_PLAN_H) - 이 호출의 계획 버전·사업부 행만 한 번 적재
           세 자리(기준정보 · 실적 · 본문 BOD 기간)가 모두 같은 계획 버전과 조회 사업부로 조인한다 */
        INSERT INTO GT_SCP0010_BOD_PLAN
        (
            DIVISION_ID
          , BOD_ID
          , FROM_SITE
          , TO_SITE
          , TRANSPORT_MODE
          , LT_TOTAL
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        SELECT DIVISION_ID
             , BOD_ID
             , FROM_SITE
             , TO_SITE
             , TRANSPORT_MODE
             , LT_TOTAL
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
          FROM SCP_ANL_BOD_N_V_PLAN_H
         WHERE DIVISION_ID = P_DIVISION_ID
           AND PLAN_SEQ    = V_SEQ
           AND PLAN_TYPE   = P_PLAN_TYPE
           AND PLAN_NAME   = P_PLAN_START_YYYYMMDD;

        /********************************************************************************
        * 임시테이블만들기 - 기준정보 생성, 0 포함
        ********************************************************************************/
        INSERT INTO GT_SCP0010_STD
        (
            DIVISION_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , OPERATION_GROUP
          , ITEM_ID
          , FROM_SITE
          , BOD_ID
          , MEASURE
          , TO_SITE
          , ORIGIN_FROM_DIVISION_ID
          , ORIGIN_TO_DIVISION_ID
          , ELECTRODE_TYPE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , TRANSPORT_MODE
          , LT_DAY
        )
        SELECT IA.DIVISION_ID
             , IA.PLAN_START_YYYYMMDD
             , IA.PLAN_TYPE
             , TO_CHAR(IA.SEQ)
             , IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.FROM_SITE
             , IA.BOD_ID
             , IA.MEASURE
             , IA.TO_SITE
             , IA.ORIGIN_FROM_DIVISION_ID
             , NVL(IA.ORIGIN_TO_DIVISION_ID, '-')       AS ORIGIN_TO_DIVISION_ID
             , NVL(NULLIF(RTRIM(IA.ELECTRODE_TYPE),''), '/')              AS ELECTRODE_TYPE
             , B.MEASURE_NAME                           AS MEASURE_LABEL
             , B.USER_SORT_ORDER_NO                     AS MEASURE_ORDER_NO
             , NVL(NULLIF(RTRIM(IB.TRANSPORT_MODE),''), '/')              AS TRANSPORT_MODE
             , TO_CHAR(IB.LT_TOTAL)                     AS LT_DAY
--        FROM (SELECT DISTINCT                                                                         --  2026.10.06 AJS
          FROM (SELECT /*+ INDEX(A PK_SCP_ANL_SHIPMENT_PLAN_SEMI) */ DISTINCT                          --  2026.10.06 AJS
                       A.DIVISION_ID
                     , A.PLAN_START_YYYYMMDD
                     , A.PLAN_TYPE
                     , A.SEQ
                     , A.OPERATION_GROUP
                     , A.ITEM_ID
                     , A.FROM_SITE
                     , A.BOD_ID
                     , A.MEASURE
                     , A.TO_SITE
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , A.ELECTRODE_TYPE
                  FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                 WHERE (V_ITEM_ID IS NULL OR A.ITEM_ID MEMBER OF V_ITEM_TAB)
                   AND (V_FROMSITE IS NULL OR A.FROM_SITE MEMBER OF V_FROMSITE_TAB)
                   AND (V_TOSITE IS NULL OR UPPER(A.TO_SITE) MEMBER OF V_TOSITE_TAB)
                   AND (V_ELECTYPE IS NULL OR A.ELECTRODE_TYPE MEMBER OF V_ELECTYPE_TAB)
                   AND A.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
                   AND A.DIVISION_ID              = P_DIVISION_ID
                   AND A.PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
                   AND A.PLAN_TYPE                = P_PLAN_TYPE
                   AND A.SEQ                      = V_SEQ
                   AND A.OPERATION_GROUP          = P_OPERATION_GROUP
                   AND A.YYYYMMDD                 >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD                 <= P_TO_YYYYMMDD
               ) IA
             , GT_SCP0010_MEASURE B
             -- BOD 2단계 : SCP_MST_BOD_V -> SCP_MST_BOD_N_V
             , (SELECT C.DIVISION_ID
                     , C.BOD_ID
                     , C.FROM_SITE
                     , C.TRANSPORT_MODE
                     , C.LT_TOTAL
                  FROM GT_SCP0010_BOD_PLAN C          /* SCP_ANL_BOD_N_V_PLAN_H */ --SCP_MST_BOD_N_V C WITH(NOLOCK)
                 WHERE (V_FROMSITE IS NULL OR C.FROM_SITE = UPPER(RTRIM(V_FROMSITE)))
               ) IB
         WHERE B.MEASURE         = IA.MEASURE
           AND IB.DIVISION_ID(+) = IA.DIVISION_ID
           AND IB.BOD_ID(+)      = IA.BOD_ID
           AND IB.FROM_SITE(+)   = IA.FROM_SITE;

        /********************************************************************************
        * 임시테이블만들기 - 계획 생성, 0 제외
        ********************************************************************************/
        INSERT INTO GT_SCP0010_VALUE
        (
            VALUE_GB
          , DIVISION_ID
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , BOD_ID
          , MEASURE
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , YYYYMMDD
          , QTY
        )
        SELECT '1'
             , A.DIVISION_ID
             , A.ITEM_ID
             , A.ELECTRODE_TYPE
             , A.ORIGIN_FROM_DIVISION_ID
             , A.FROM_SITE
             , A.TRANSPORT_MODE
             , A.BOD_ID          -- BOD 2단계 개발
             , A.MEASURE
             , A.ORIGIN_TO_DIVISION_ID
             , A.TO_SITE
             , B.YYYYMMDD
             , B.QTY
          FROM GT_SCP0010_STD A
             , SCP_ANL_SHIPMENT_PLAN_SEMI B
         WHERE B.DIVISION_ID              = A.DIVISION_ID
           AND B.PLAN_START_YYYYMMDD      = A.PLAN_START_YYYYMMDD
           AND B.PLAN_TYPE                = A.PLAN_TYPE
           AND B.SEQ                      = TO_NUMBER(A.SEQ)
           AND B.OPERATION_GROUP          = A.OPERATION_GROUP
           AND B.ITEM_ID                  = A.ITEM_ID
           AND B.FROM_SITE                = A.FROM_SITE
           AND B.BOD_ID                   = A.BOD_ID
           AND B.MEASURE                  = A.MEASURE
           AND B.PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
           AND B.QTY                      <> 0
           AND B.YYYYMMDD                 >= P_FROM_YYYYMMDD
           AND B.YYYYMMDD                 <= P_TO_YYYYMMDD;

        /********************************************************************************
        * 임시테이블만들기 - 실적 생성, 0 제외
        ********************************************************************************/
        INSERT INTO GT_SCP0010_VALUE
        (
            VALUE_GB
          , DIVISION_ID
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , MEASURE
          , BOD_ID
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , YYYYMMDD
          , QTY
        )
        SELECT '2'
             , IA.DIVISION_ID
             , IA.ITEM_ID
             , IA.ELECTRODE_TYPE
             , IA.ORIGIN_FROM_DIVISION_ID
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE
             , IA.MEASURE
             , NVL(NULLIF(RTRIM(IB.BOD_ID),''), '/')              AS BOD_ID      -- BOD 2단계
             , IA.ORIGIN_TO_DIVISION_ID
             , IA.TO_SITE
             , B.EXFACTORY_DATE                 AS YYYYMMDD
             , SUM(B.EXFACTORY_QTY)             AS QTY
          FROM (SELECT DISTINCT
                       DIVISION_ID
                     , ITEM_ID
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , FROM_SITE
                     , TRANSPORT_MODE
                     , MEASURE
                     , ORIGIN_TO_DIVISION_ID
                     , TO_SITE
                  FROM GT_SCP0010_STD
               ) IA
             , SCM_DNM_EXFACTORY_RESULT B
             -- BOD 2단계
             , (SELECT C.DIVISION_ID
                     , C.BOD_ID
                     , C.FROM_SITE
                     , C.TO_SITE
                     , C.TRANSPORT_MODE
                     , C.FROM_YYYYMMDD
                     , C.TO_YYYYMMDD
                  FROM GT_SCP0010_BOD_PLAN C          /* SCP_ANL_BOD_N_V_PLAN_H */ --SCP_MST_BOD_N_V C WITH(NOLOCK)
                 WHERE (V_FROMSITE IS NULL OR C.FROM_SITE = UPPER(RTRIM(V_FROMSITE)))
               ) IB
             -- 20231205 E20231128-000517 실적 조회 수정 : SSP 가이드
             , SCM_ADM_LOOKUP_MASTER_DETAIL D
         WHERE B.DIVISION_ID         = DECODE(V_EE_YN, 'Y', B.DIVISION_ID, IA.DIVISION_ID)      --div_commonization
           AND B.ITEM_ID             = IA.ITEM_ID
           AND B.FROM_SCM_SITE_ID    = IA.FROM_SITE
           AND B.TO_SCM_SITE_ID      = IA.TO_SITE
           AND B.TRANSPORT_MODE      = IA.TRANSPORT_MODE
           AND IB.DIVISION_ID        = IA.DIVISION_ID
           AND IB.FROM_SITE          = B.FROM_SCM_SITE_ID
           AND IB.TO_SITE            = B.TO_SCM_SITE_ID
           --AND R.INCOTERMS		= C.INCOTERMS -- 20231205 E20231128-000517 조건 삭제 : Semi BOD 는 전부 DAP 이므로 실적과 다르기 때문임
           AND IB.TRANSPORT_MODE     = B.TRANSPORT_MODE
           AND IB.FROM_YYYYMMDD      <= B.EXFACTORY_DATE
           AND IB.TO_YYYYMMDD        >= B.EXFACTORY_DATE
           AND D.SEGMENT1            = B.SSP_TYPE
           AND IA.MEASURE            = 'SHIP_PLAN'
           AND D.LOOKUP_TYPE         = 'ERP_SSP_TYPE'     -- LOOKUP에 등록된 공정만
           AND D.VALID_YN            = 'Y'
           AND B.EXFACTORY_QTY       > 0
           AND NVL(B.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')   -- 20231205 E20231128-000517 조건 변경
           AND B.EXFACTORY_DATE      >= V_FROM_RESULT
           AND B.EXFACTORY_DATE      <  V_TO_RESULT
         GROUP BY IA.DIVISION_ID
                , IA.ITEM_ID
                , IA.ELECTRODE_TYPE
                , IA.ORIGIN_FROM_DIVISION_ID
                , IA.FROM_SITE
                , IA.TRANSPORT_MODE
                , IA.MEASURE
                , IA.ORIGIN_TO_DIVISION_ID
                , IA.TO_SITE
                , B.EXFACTORY_DATE
                , IB.BOD_ID;   -- BOD 2단계 개발

        -------------------------------------------------
        -- 2022.05.26
        -- SHIP_PLAN -> SHIP_PLAN_AMEND Copy...
        -------------------------------------------------
        INSERT INTO GT_SCP0010_VALUE
        (
            VALUE_GB
          , DIVISION_ID
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , MEASURE
          , BOD_ID
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , YYYYMMDD
          , QTY
        )
        SELECT '2'
             , DIVISION_ID
             , ITEM_ID
             , ELECTRODE_TYPE
             , ORIGIN_FROM_DIVISION_ID
             , FROM_SITE
             , TRANSPORT_MODE
             , 'SHIP_PLAN_AMEND'                AS MEASURE     --X.MEASURE
             , BOD_ID
             , ORIGIN_TO_DIVISION_ID
             , TO_SITE
             , YYYYMMDD
             , QTY
          FROM GT_SCP0010_VALUE
         WHERE VALUE_GB = '2'
           AND MEASURE  = 'SHIP_PLAN';

        /********************************************************************************
        * 임시테이블만들기 - 계획 + 실적
        ********************************************************************************/
        INSERT INTO GT_SCP0010_DATA
        (
            DIVISION_ID
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , BOD_ID
          , MEASURE
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , YYYYMMDD
          , QTY
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , ELECTRODE_TYPE
             , ORIGIN_FROM_DIVISION_ID
             , FROM_SITE
             , TRANSPORT_MODE
             , BOD_ID            -- BOD 2단계 개발
             , MEASURE
             , ORIGIN_TO_DIVISION_ID
             , TO_SITE
             , YYYYMMDD
             , QTY
          FROM GT_SCP0010_VALUE;

        /********************************************************************************
        * 임시테이블만들기- Main 조회 테이블
        ********************************************************************************/
        INSERT INTO GT_SCP0010_MAIN
        (
            KEY_IDX
          , DIVISION_ID
          , OPERATION_GROUP
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , LT_DAY
          , MEASURE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , BOD_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , YYYYMMDD
          , YYYYMM
          , ISO_WEEK
          , QTY
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        SELECT CASE WHEN IA.DIVISION_ID IS NOT NULL AND IA.OPERATION_GROUP IS NOT NULL
                     AND IA.ITEM_ID IS NOT NULL AND IA.FROM_SITE IS NOT NULL
                    THEN IA.DIVISION_ID || IA.OPERATION_GROUP || IA.ITEM_ID || IA.FROM_SITE
               END                                              AS KEY_IDX
             , IA.DIVISION_ID
             , IA.OPERATION_GROUP
             , IA.ITEM_ID
             , IA.ELECTRODE_TYPE
             , IA.ORIGIN_FROM_DIVISION_ID
             , IA.FROM_SITE
             , IA.TRANSPORT_MODE
             , NVL(IA.LT_DAY, '0')                              AS LT_DAY
             , IA.MEASURE
             , IA.MEASURE_LABEL
             , IA.MEASURE_ORDER_NO
             , IA.ORIGIN_TO_DIVISION_ID
             , IA.TO_SITE
             , IA.BOD_ID
             , P_PLAN_START_YYYYMMDD                            AS PLAN_START_YYYYMMDD
             , P_PLAN_TYPE                                      AS PLAN_TYPE
             , P_SEQ                                            AS SEQ
             , 'D_' || NVL(B.YYYYMMDD, V_FROM_YYYYMMDD)         AS YYYYMMDD
             , C.BASIS_YYYYMM                                   AS YYYYMM
             , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK         AS ISO_WEEK
             , NVL(B.QTY, 0)                                    AS QTY
             , P_FROM_YYYYMMDD                                  AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                                    AS TO_YYYYMMDD
          FROM (SELECT XA.DIVISION_ID
                     , XA.PLAN_START_YYYYMMDD
                     , XA.PLAN_TYPE
                     , XA.SEQ
                     , XA.OPERATION_GROUP
                     , XA.ITEM_ID
                     , XA.FROM_SITE
                     , XA.BOD_ID
                     , XB.MEASURE
                     , XA.TO_SITE
                     , XA.ORIGIN_FROM_DIVISION_ID
                     , XA.ORIGIN_TO_DIVISION_ID
                     , XA.ELECTRODE_TYPE
                     , XA.MEASURE_LABEL
                     , XA.MEASURE_ORDER_NO
                     , XA.TRANSPORT_MODE
                     , XA.LT_DAY
                  FROM GT_SCP0010_STD XA
                     , GT_SCP0010_MEASURE XB
                 WHERE XB.MEASURE(+) = XA.MEASURE
               ) IA
             , GT_SCP0010_DATA B
             , SCM_SYS_CALENDAR_M C
         WHERE B.DIVISION_ID(+)                                  = IA.DIVISION_ID
           AND B.ITEM_ID(+)                                      = IA.ITEM_ID
           AND B.ELECTRODE_TYPE(+)                               = IA.ELECTRODE_TYPE
           AND NVL(B.ORIGIN_FROM_DIVISION_ID(+), CHR(1))         = NVL(IA.ORIGIN_FROM_DIVISION_ID, CHR(1))   /* 빈 문자끼리 같음(AS-IS) */
           AND B.FROM_SITE(+)                                    = IA.FROM_SITE
           AND B.TRANSPORT_MODE(+)                               = IA.TRANSPORT_MODE
           AND B.MEASURE(+)                                      = IA.MEASURE
           AND B.ORIGIN_TO_DIVISION_ID(+)                        = IA.ORIGIN_TO_DIVISION_ID
           AND NVL(B.TO_SITE(+), CHR(1))                         = NVL(IA.TO_SITE, CHR(1))
           AND B.BOD_ID(+)                                       = IA.BOD_ID       -- BOD 2단계 개발
           AND C.BASIS_YYYYMMDD                                  = NVL(B.YYYYMMDD, V_FROM_YYYYMMDD);

        /********************************************************************************
         * BOH temp 테이블 생성
         ********************************************************************************/
        --dbo.FN_GET_SCP_ANL_BOH_QTY
        --dbo.FN_GET_SCP_ANL_CHAR_BOH_QTY
        IF P_OPERATION_GROUP = 'E' THEN

            INSERT INTO GT_SCP0010_BOH
            (
                OPERATION_GROUP
              , SITE_ID
              , ITEM_ID
              , PSI_BOH_QTY
            )
            SELECT 'E'                                          AS OPERATION_GROUP
                 , SITE_ID
                 , ITEM_ID
                 , TRUNC(ROUND(SUM(NVL(PSI_BOH_QTY, 0)), 1))   AS PSI_BOH_QTY
              FROM SCP_PLN_PLANT_ONHAND
             WHERE PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE     /* 파티션 프루닝 */
               AND DIVISION_ID              = P_DIVISION_ID
               AND STOCK_TYPE NOT IN ('FOR_STOCKPLAN', 'FORMING', 'FORMED', 'CHARING', 'CHAR', 'A_MOVE_WH', 'A_OUT_WH')   --셀 활성화진행중 이후 특성,창고재고 제외
               AND PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND PLAN_TYPE                = P_PLAN_TYPE
               AND SEQ                      = V_SEQ
               AND YYYYMMDD                 = P_PLAN_START_YYYYMMDD
             GROUP BY SITE_ID
                    , ITEM_ID;

        ELSE

            INSERT INTO GT_SCP0010_BOH
            (
                OPERATION_GROUP
              , SITE_ID
              , ITEM_ID
              , PSI_BOH_QTY
            )
            SELECT 'A'                                          AS OPERATION_GROUP
                 , SITE_ID
                 , ITEM_ID
                 , TRUNC(ROUND(SUM(NVL(PSI_BOH_QTY, 0)), 1))   AS PSI_BOH_QTY
              FROM SCP_PLN_PLANT_ONHAND
             WHERE PLAN_START_YYYYMMDD_DATE = V_PLAN_START_DATE
               AND DIVISION_ID              = P_DIVISION_ID
               AND STOCK_TYPE IN ('CHAR', 'A_MOVE_WH', 'A_OUT_WH')  --특성완료재고
               AND PLAN_START_YYYYMMDD      = P_PLAN_START_YYYYMMDD
               AND PLAN_TYPE                = P_PLAN_TYPE
               AND SEQ                      = V_SEQ
               AND YYYYMMDD                 = P_PLAN_START_YYYYMMDD
             GROUP BY SITE_ID
                    , ITEM_ID;

        END IF;

        /********************************************************************************
         * ESS 출하확정구간 임시테이블 생성 (82 사업부 조인에만 쓰인다)
         ********************************************************************************/
        IF P_DIVISION_ID = '82' THEN

            INSERT INTO GT_SCP0010_ESS_TYPE_INFO
            (
                DIVISION_ID
              , SCM_SITE_ID
              , PLANT_ID
              , OPERATION_GROUP
              , SITE_DESCRIPTION
              , SITE_TYPE
              , SITE_ID
              , CITY
              , COUNTRY
              , VMI_YN
              , VALID_YN
              , NEW_YN
              , OSP_YN
              , SHIP_FROZEN
            )
            SELECT A.DIVISION_ID
                 , A.SCM_SITE_ID
                 , A.PLANT_ID
                 , A.OPERATION_GROUP
                 , A.SITE_DESCRIPTION
                 , A.SITE_TYPE
                 , A.SITE_ID
                 , A.CITY
                 , A.COUNTRY
                 , A.VMI_YN
                 , A.VALID_YN
                 , A.NEW_YN
                 , A.OSP_YN
                 , CASE WHEN NVL(A.SHIP_FROZEN, 0) > NVL(TO_NUMBER(B.SEGMENT3), 0) THEN A.SHIP_FROZEN
                        ELSE TO_NUMBER(B.SEGMENT3)
                   END                                  AS SHIP_FROZEN
              FROM SCM_MST_SITE A
                 , (SELECT SEGMENT1
                         , SEGMENT2
                         , SEGMENT3
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE = 'ESS_SHIP_PLAN_SITE'
                   ) B
             WHERE B.SEGMENT1(+) = A.SCM_SITE_ID
               AND B.SEGMENT2(+) = A.SITE_DESCRIPTION;

        END IF;

        /********************************************************************************
        * PIVOIT처리
        ********************************************************************************/
        -- PIVOIT 대상 날짜문자열 생성
        DBMS_LOB.CREATETEMPORARY(V_QRY_SUM, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_QRY_COL, TRUE);   /* AJS 20261007 화면검증 */

        FOR R IN (SELECT IA.YYYYMMDD
                    FROM (SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK      AS YYYYMMDD
                               , A.BASIS_START_DATE || '21'                AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM
                                  , A.ISO_WEEK
                                  , A.BASIS_START_DATE
                          UNION ALL
                          SELECT 'M_' || A.BASIS_YYYYMM                    AS YYYYMMDD
                               , MIN(A.BASIS_START_DATE) || '01'           AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM
                                  , A.MONTH_NAME
                          UNION ALL
                          SELECT 'D_' || A.BASIS_YYYYMMDD                  AS YYYYMMDD
                               , A.BASIS_YYYYMMDD || '31'                  AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD
                         ) IA
                   ORDER BY IA.SORT_ORDER_NO
                          , IA.YYYYMMDD)
        LOOP
            -- 중장기 수정 : NULL 값 처리
            IF SUBSTR(R.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(', NVL(SUM(CASE WHEN YYYYMM = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN QTY END), 0) AS ' || R.YYYYMMDD || CHR(10)));
                DBMS_LOB.APPEND(V_QRY_COL, TO_CLOB('     , A.' || R.YYYYMMDD || CHR(10)));   /* AJS 20261007 화면검증 */
            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(', NVL(SUM(CASE WHEN ISO_WEEK = ''' || SUBSTR(R.YYYYMMDD, -6) || ''' THEN QTY END), 0) AS ' || R.YYYYMMDD || CHR(10)));
                DBMS_LOB.APPEND(V_QRY_COL, TO_CLOB('     , A.' || R.YYYYMMDD || CHR(10)));   /* AJS 20261007 화면검증 */
            ELSE
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(', NVL(SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN QTY END), 0) AS ' || R.YYYYMMDD || CHR(10)));
                DBMS_LOB.APPEND(V_QRY_COL, TO_CLOB('     , A.' || R.YYYYMMDD || CHR(10)));   /* AJS 20261007 화면검증 */
            END IF;
        END LOOP;

        /* 지난주 월요일 (AS-IS : DATEADD(dd, @@DATEFIRST - DATEPART(dw, GETDATE()) - 5, GETDATE()), @@DATEFIRST = 7)
           일요일이면 다음날 월요일이 된다 - 원문 식 그대로 */
        V_LAST_MONDAY := TO_CHAR(TRUNC(SYSDATE) + 1 - MOD(TRUNC(SYSDATE) - DATE '1900-01-07', 7), 'YYYY-MM-DD');

        -- 중장기 프로젝트(기간 82주로 연장) : MSSQL 오류로 GROUPPING SUB QUERY 로 변경
        V_EXEC := TO_CLOB(
/* 'SELECT A.*' || CHR(10) */
--                   'SELECT A.KEY_IDX AS "key_idx"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                   'SELECT A.KEY_IDX AS "KEY_IDX"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.DIVISION_ID AS "division_id"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.DIVISION_ID AS "DIVISION_ID"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.OPERATION_GROUP AS "operation_group"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.OPERATION_GROUP AS "OPERATION_GROUP"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.ITEM_ID AS "item_id"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.ITEM_ID AS "ITEM_ID"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.FROM_SITE AS "from_site"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.FROM_SITE AS "FROM_SITE"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.ELECTRODE_TYPE' || CHR(10)   /* AJS 20261007 화면검증 */
--                || '     , A.TO_SITE AS "to_site"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.TO_SITE AS "TO_SITE"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.BOD_ID AS "bod_id"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.BOD_ID AS "BOD_ID"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.TRANSPORT_MODE AS "transport_mode"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.TRANSPORT_MODE AS "TRANSPORT_MODE"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.LT_DAY AS "lt_day"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.LT_DAY AS "LT_DAY"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.MEASURE AS "measure"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.MEASURE AS "MEASURE"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.MEASURE_ORDER_NO AS "measure_order_no"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.MEASURE_ORDER_NO AS "MEASURE_ORDER_NO"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.MEASURE_LABEL AS "measure_label"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.MEASURE_LABEL AS "MEASURE_LABEL"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.PLAN_START_YYYYMMDD' || CHR(10)   /* AJS 20261007 화면검증 */
                || '     , A.PLAN_TYPE' || CHR(10)   /* AJS 20261007 화면검증 */
                || '     , A.SEQ' || CHR(10)   /* AJS 20261007 화면검증 */
--                || '     , A.FROM_YYYYMMDD AS "from_yyyymmdd"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.FROM_YYYYMMDD AS "FROM_YYYYMMDD"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
--                || '     , A.TO_YYYYMMDD AS "to_yyyymmdd"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.TO_YYYYMMDD AS "TO_YYYYMMDD"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , A.ORIGIN_FROM_DIVISION_ID' || CHR(10)   /* AJS 20261007 화면검증 */
--              || '     , A.ORIGIN_TO_DIVISION_ID' || CHR(10)   /* AJS 20261007 화면검증 */
                || '     , A.ORIGIN_TO_DIVISION_ID' || CHR(10));   /* AJS 20261008 결함 */
        DBMS_LOB.APPEND(V_EXEC, V_QRY_COL);   /* AJS 20261008 결함 */
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(''   /* AJS 20261008 결함 */
/* || '     , (SELECT MIN(SA.DIVISION_NAME) FROM SCM_MST_DIVISION SA WHERE SA.DIVISION_ID = A.DIVISION_ID) AS DIVISION_NAME' || CHR(10) */
--                || '     , (SELECT MIN(SA.DIVISION_NAME) FROM SCM_MST_DIVISION SA WHERE SA.DIVISION_ID = A.DIVISION_ID) AS "division_name"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , (SELECT MIN(SA.DIVISION_NAME) FROM SCM_MST_DIVISION SA WHERE SA.DIVISION_ID = A.DIVISION_ID) AS "DIVISION_NAME"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                -- 20220126 : DC LINK 수정 (PACK -> PACK)
                || '     , (CASE WHEN A.OPERATION_GROUP = ''A'' THEN ''Cell'' WHEN A.OPERATION_GROUP = ''P'' THEN ''Pack'' ELSE ''Electrode'' END) AS OPERATION_GROUP_DESC' || CHR(10)
--              || '     , (SELECT MIN(SB.NICK_NAME) FROM SCM_MST_ITEM_SN SB WHERE SB.ITEM_ID = A.ITEM_ID) AS NICK_NAME' || CHR(10)  --  2026.10.06 AJS
/* || '     , (SELECT (*+ NO_UNNEST *) MIN(SB.NICK_NAME) FROM SCM_MST_ITEM_SN SB WHERE SB.ITEM_ID = A.ITEM_ID) AS NICK_NAME' || CHR(10)  --  2026.10.06 AJS */
--                || '     , (SELECT /*+ NO_UNNEST */ MIN(SB.NICK_NAME) FROM SCM_MST_ITEM_SN SB WHERE SB.ITEM_ID = A.ITEM_ID) AS "nick_name"' || CHR(10)   /* 2026.10.06 AJS */   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , (SELECT /*+ NO_UNNEST */ MIN(SB.NICK_NAME) FROM SCM_MST_ITEM_SN SB WHERE SB.ITEM_ID = A.ITEM_ID) AS "NICK_NAME"' || CHR(10)   /* 2026.10.06 AJS */   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , (SELECT MIN(SC.SITE_DESCRIPTION) FROM SCM_MST_SITE SC WHERE SC.SCM_SITE_ID = A.FROM_SITE) AS FROM_SITE_DESCRIPTION' || CHR(10)
                || '     , NVL((SELECT MIN(SD.SITE_DESCRIPTION) FROM SCM_MST_SITE SD WHERE SD.SCM_SITE_ID = A.TO_SITE), ''/'') AS T0_SITE_DESCRIPTION' || CHR(10)
/* || '     , (SELECT SE.PSI_BOH_QTY FROM GT_SCP0010_BOH SE WHERE SE.ITEM_ID = A.ITEM_ID AND SE.SITE_ID = A.FROM_SITE AND SE.OPERATION_GROUP = A.OPERATION_GROUP) AS BOH' || CHR(10) */
--                || '     , (SELECT SE.PSI_BOH_QTY FROM GT_SCP0010_BOH SE WHERE SE.ITEM_ID = A.ITEM_ID AND SE.SITE_ID = A.FROM_SITE AND SE.OPERATION_GROUP = A.OPERATION_GROUP) AS "boh"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , (SELECT SE.PSI_BOH_QTY FROM GT_SCP0010_BOH SE WHERE SE.ITEM_ID = A.ITEM_ID AND SE.SITE_ID = A.FROM_SITE AND SE.OPERATION_GROUP = A.OPERATION_GROUP) AS "BOH"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                -- 1. 전극 계열인 경우 전 구간 수정 가능 : 20230310 추가
                -- 2. 동일 지역 법인 내 이동인 경우 전 구간 수정 가능
                -- 3. Ship Frozen 구간 : UI 수정 불가 구간 처리 : From Site 기준
                || '     , CASE WHEN A.DIVISION_ID IN (SELECT SF.COLUMN_VALUE FROM TABLE(FN_GET_DIVISION_DIV(''EE'')) SF) THEN :B_LAST_MONDAY1' || CHR(10)
                || '            WHEN F.SITE_ID = T.SITE_ID AND F.OSP_YN = ''N'' AND T.OSP_YN = ''N'' THEN :B_LAST_MONDAY2' || CHR(10)
                || '            ELSE TO_CHAR(TO_DATE(:B_PLAN_START1, ''YYYYMMDD'') + NVL(F.SHIP_FROZEN, 0), ''YYYY-MM-DD'')' || CHR(10)
                || '       END AS SHIP_FROZEN' || CHR(10)
                || '     , G.FROM_YYYYMMDD AS BOD_FROM_YYYYMMDD' || CHR(10)     -- BOD 2단계 개발
                || '     , G.TO_YYYYMMDD AS BOD_TO_YYYYMMDD' || CHR(10)         -- BOD 2단계 개발
/* || '     , NVL(B.DEPARTURE_DAY, ''X'') AS DEPT_DAY' || CHR(10) */
--                || '     , NVL(B.DEPARTURE_DAY, ''X'') AS "Dept_Day"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '     , NVL(B.DEPARTURE_DAY, ''X'') AS "DEPT_DAY"' || CHR(10)   /* AJS 20261007 화면검증 */   --  2026.10.08 AJS
                || '  FROM (SELECT A.KEY_IDX' || CHR(10)
                || '             , A.DIVISION_ID' || CHR(10)
                || '             , A.OPERATION_GROUP' || CHR(10)
                || '             , A.ITEM_ID' || CHR(10)
                || '             , A.FROM_SITE' || CHR(10)
                || '             , A.ELECTRODE_TYPE' || CHR(10)
                || '             , A.TO_SITE' || CHR(10)
                || '             , A.BOD_ID' || CHR(10)
                || '             , NVL(A.TRANSPORT_MODE, ''/'') AS TRANSPORT_MODE' || CHR(10)
                || '             , NVL(A.LT_DAY, ''0'') AS LT_DAY' || CHR(10)
                || '             , A.MEASURE' || CHR(10)
                || '             , A.MEASURE_ORDER_NO' || CHR(10)
                || '             , A.MEASURE_LABEL' || CHR(10)
                || '             , A.PLAN_START_YYYYMMDD' || CHR(10)
                || '             , A.PLAN_TYPE' || CHR(10)
                || '             , A.SEQ' || CHR(10)
                || '             , A.FROM_YYYYMMDD' || CHR(10)
                || '             , A.TO_YYYYMMDD' || CHR(10)
                || '             , A.ORIGIN_FROM_DIVISION_ID' || CHR(10)
--              || '             , A.ORIGIN_TO_DIVISION_ID' || CHR(10));
                || '             , A.ORIGIN_TO_DIVISION_ID' || CHR(10)));   /* AJS 20261008 결함 */

--      DBMS_LOB.APPEND(V_EXEC, V_QRY_COL);   /* AJS 20261007 화면검증 */   /* AJS 20261008 결함 */
        DBMS_LOB.APPEND(V_EXEC, V_QRY_SUM);

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                   '          FROM GT_SCP0010_MAIN A' || CHR(10)
                || '         GROUP BY A.KEY_IDX, A.DIVISION_ID, A.OPERATION_GROUP, A.ITEM_ID, A.FROM_SITE, A.ELECTRODE_TYPE, A.TO_SITE, A.BOD_ID' || CHR(10)
                || '                , A.TRANSPORT_MODE, A.LT_DAY, A.MEASURE, A.MEASURE_ORDER_NO, A.MEASURE_LABEL, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ' || CHR(10)
                || '                , A.FROM_YYYYMMDD, A.TO_YYYYMMDD, A.ORIGIN_FROM_DIVISION_ID, A.ORIGIN_TO_DIVISION_ID' || CHR(10)
                || '       ) A' || CHR(10)
                || '     , SCP_MST_SHIPMENT_SEMI_DEPT_DAY B' || CHR(10)
                -- BOD 2단계 개발 : 추가 FROM , TO
                || '     , GT_SCP0010_BOD_PLAN G' || CHR(10)     /* SCP_ANL_BOD_N_V_PLAN_H (같은 계획 버전·사업부) */
                || CASE WHEN V_EE_YN = 'Y'  THEN '     , SCM_MST_SITE F' || CHR(10) || '     , SCM_MST_SITE T' || CHR(10)
                        WHEN P_DIVISION_ID = '82' THEN '     , GT_SCP0010_ESS_TYPE_INFO F' || CHR(10) || '     , GT_SCP0010_ESS_TYPE_INFO T' || CHR(10)   --ESS 출하구간 수정
                        ELSE '     , SCM_MST_SITE F' || CHR(10) || '     , SCM_MST_SITE T' || CHR(10)
                   END
                || ' WHERE B.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
                || '   AND B.ITEM_ID(+) = A.ITEM_ID' || CHR(10)
                || '   AND B.VALID_YN(+) = ''Y''' || CHR(10)
                || '   AND G.BOD_ID(+) = A.BOD_ID' || CHR(10)
                || '   AND G.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
                || '   AND G.FROM_SITE(+) = A.FROM_SITE' || CHR(10)
                || CASE WHEN V_EE_YN = 'Y'
                        THEN '   AND F.DIVISION_ID(+) = A.ORIGIN_FROM_DIVISION_ID' || CHR(10)
                          || '   AND T.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
                        ELSE '   AND F.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
                          || '   AND T.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
                   END
                || '   AND F.SCM_SITE_ID(+) = A.FROM_SITE' || CHR(10)
                || '   AND F.VALID_YN(+) = ''Y''' || CHR(10)
                || '   AND T.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)
                || '   AND T.VALID_YN(+) = ''Y''' || CHR(10)
                -- byte 오류로 order by 를 UI 에서 함
                || ' ORDER BY A.DIVISION_ID, A.OPERATION_GROUP, A.ITEM_ID, A.FROM_SITE, A.TO_SITE DESC, A.BOD_ID, A.MEASURE_ORDER_NO' || CHR(10)));

        IF P_DEBUG_MODE = 'T' THEN
            P_PRINT_CLOB(V_EXEC);
        END IF;

        OPEN O_RC1 FOR V_EXEC
            USING V_LAST_MONDAY
                , V_LAST_MONDAY
                , P_PLAN_START_YYYYMMDD;

        /* 수정가능여부 구간 조회
           AS-IS : DATEDIFF(week, 오늘, 플랜시작일) < 0 - 일요일 기준 주 경계를 센다 */
        V_IS_EDITABLE := CASE WHEN V_PLAN_START_DATE - MOD(V_PLAN_START_DATE - DATE '1900-01-07', 7)
                                 < TRUNC(SYSDATE) - MOD(TRUNC(SYSDATE) - DATE '1900-01-07', 7)
                              THEN 'N'
                              ELSE 'Y'
                         END;

        OPEN O_RC2 FOR
            SELECT V_IS_EDITABLE                        AS IS_EDITABLE
                 , IA.PLAN_NAME
                 , IA.PLAN_SEQ
                 , IA.PLAN_TYPE
                 , IA.CONFIRM_FLAG
                 , IA.PLAN_START_YYYYMMDD
                 , IA.PLAN_STATUS
                 , IA.CONFIRM_YN
                 , IA.PLAN_TYPE_SEQ
                 , IB.BASIS_START_DATE
                 , V_PLAN_START_DATE                    AS PLAN_START_DATE
              FROM (SELECT C.PLAN_NAME
                         , A.PLAN_SEQ
                         , A.PLAN_TYPE
                         , D.CONFIRM_FLAG
                         , C.PLAN_NAME                  AS PLAN_START_YYYYMMDD
                         , A.PLAN_STATUS
                         , NVL(A.CONFIRM_FLAG, 'N')     AS CONFIRM_YN
                         , CASE A.PLAN_TYPE WHEN 'PR' THEN 0 WHEN 'MA' THEN 1 WHEN 'SE' THEN 2 WHEN 'FN' THEN 3 END AS PLAN_TYPE_SEQ
                      FROM SCM_MST_PLAN_DETAIL A
                         , SCM_MST_MODELING B
                         , SCM_MST_PLAN C
                         , SCP_PLAN_VERSION_V D
                     WHERE B.MODELING_ID         = A.MODELING_ID
                       AND B.DIVISION_ID         = A.DIVISION_ID
                       AND C.DIVISION_ID         = A.DIVISION_ID
                       AND C.PLAN_CYCLE          = B.PLAN_CYCLE
                       AND C.PLAN_ID             = A.PLAN_ID
                       AND D.DIVISION_ID         = A.DIVISION_ID
                       AND D.PLAN_TYPE           = A.PLAN_TYPE
                       AND D.PLAN_SEQ            = A.PLAN_SEQ
                       AND D.PLAN_START_YYYYMMDD = C.PLAN_NAME
                       AND B.PLAN_CYCLE          = 'WEEKLY'
                       AND A.PLAN_TYPE IN ('PR', 'MA', 'SE', 'FN', 'TE')
                       AND A.DISPLAY_YN          = 'Y'
                       AND A.DIVISION_ID         = P_DIVISION_ID
                       AND C.PLAN_NAME           = P_PLAN_START_YYYYMMDD
                   ) IA
                 , (SELECT BASIS_START_DATE
                      FROM SCM_SYS_CALENDAR_M
                     WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
                   ) IB;

        -- 05/25
        -- FIX 추가관련
        OPEN O_RC3 FOR
            SELECT P_DIVISION_ID || P_OPERATION_GROUP || A.ITEM_ID || A.FROM_SITE     AS KEY_IDX
                 , A.FIX_ID
                 , A.TO_SITE
                 , A.BOD_ID
                 , 'D_' || A.YYYYMMDD                                                 AS YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_FIX A
             WHERE (V_ITEM_ID IS NULL OR A.ITEM_ID MEMBER OF V_ITEM_TAB)
               AND (V_ELECTYPE IS NULL OR A.ELECTRODE_TYPE MEMBER OF V_ELECTYPE_TAB)
               AND A.DIVISION_ID = P_DIVISION_ID
               AND A.BIZ_TYPE    = P_OPERATION_GROUP
               AND A.YYYYMMDD    >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD    <= P_TO_YYYYMMDD;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0'          AS CODE
                 , 'SUCCESS'    AS MSG
                 , '0'          AS EVENT
              FROM DUAL;

    END P_SCP0010_GET_SHIP_PLAN_SEMI;


END PKG_SCP0010;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0010
