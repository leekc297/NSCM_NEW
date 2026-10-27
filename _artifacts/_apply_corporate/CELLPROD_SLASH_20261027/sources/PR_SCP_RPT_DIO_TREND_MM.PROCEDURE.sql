PROCEDURE "PR_SCP_RPT_DIO_TREND_MM"

(
      P_DIVISION_ID          IN VARCHAR2 DEFAULT '81'
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2 DEFAULT NULL
    , P_CREATED_BY           IN VARCHAR2
)
/* ============================================================================================================
 * Program ID  : PR_SCP_RPT_DIO_TREND_MM
 * Description : DIO Trend Report 월별 데이터 생성
 * Execute     : EXEC [dbo].[PR_SCP_RPT_DIO_TREND_MM]
 *                    @P_DIVISION_ID = N'81', @P_PLAN_START_YYYYMMDD = N'20221010', @P_CREATED_BY = 'userId'
 *
 * Program History
 *------------------------------------------------------------------------------------------------------------
 *   Date        In Charge   Description
 *------------------------------------------------------------------------------------------------------------
 * 2022/09/01   hrkim       Initial Release  [PJ20216994] LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2
 * 2022/11/30   hrkim       AMDAU% 모델 재고 추가
 * 2022/12/01   hrkim       전체셀모델 단가 변경 - 전월 전체셀 모델 단가
 * 2022/12/23   hrkim       조립(Prod) Cell Convert 생성시 Pack 제외 및 재고 생성 로직 수정 보완
 * 2023/01/09   hrkim       미래 구간 재고계산을 위한 Cell/Pack 적용수율 변경 및 미래구간 재고 로직 수정 보완
 * 2023/01/27   hrkim       MKT_FCST/RTF 실적데이터 참조시 scm_mst_site_item 테이블에 존재하는 데이터로 필터링 적용
 * 2023/01/31   hrkim       셀환산수량 적용 로직 보완 및 RTF 계획 구간 참조 테이블 변경 (DM_PLN_MKT_FCST_C)
 * 2023/03/08   hrkim       [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 기타충당금 복사 기능 추가
 * 2023/03/16   hrkim       [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 과거 실적 구간 생성 범위 변경 (당해년도 1/1부터 생성)
 * 2023/03/27   hrkim       [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 과거 실적 구간 참조 시작일 변경(FROM_DATE)
 * 2023.04.28   hrkim       PJ20230691 LGES SCM 역량 강화 위한 SCP 개선과제 이행 : Cell Group 기준 변경 및 미래구간 재고금액 산정 로직 변경
 * 2023.07.11   hrkim       PJ20230691 활성화코드 분리 대응 - 모델별 데이터 CP기준 적재 (생산/재고 Cell Assy -> Cell Product 치환)
 * 2023.07.26   hrkim       PJ20230691 SCP_MST_CELL_PROD_ASSY_MAP 참조시 Valid_yn = 'Y' 조건 추가
 * 2026.07.06   ZIONEX      [PJ202650304]  NextSCM Migration
 * ============================================================================================================ */
IS


    V_PLAN_START_SAFE   VARCHAR2(8 CHAR) := CASE
                             WHEN P_PLAN_START_YYYYMMDD IS NOT NULL
                              AND LENGTH(P_PLAN_START_YYYYMMDD) = 8
                              AND REGEXP_LIKE(P_PLAN_START_YYYYMMDD, '^[0-9]{8}$')
                             THEN P_PLAN_START_YYYYMMDD
                             ELSE '20260101'
                         END;

    V_DM_CUTOFF_YYYYMMDD        VARCHAR2(8 CHAR) := NULL;
    V_DM_VERSION_NO             VARCHAR2(50 CHAR) := '';

    V_PLAN_SEQ                  NUMBER(19) := 1;

    V_FROM_DATE                 DATE := TO_DATE(SUBSTR(V_PLAN_START_SAFE, 1, 4)||'0101', 'YYYYMMDD');  /* 과거 실적구간 참조 시작일 (plan date기준 당해년도 1/1일) */


    V_FROM_YYYYMM               VARCHAR2(6 CHAR) := TO_CHAR(TO_DATE(SUBSTR(V_PLAN_START_SAFE, 1, 4)||'0101', 'YYYYMMDD'), 'YYYYMM');
    V_PLAN_START_YYYYMM         VARCHAR2(6 CHAR) := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 6);

    V_LAST_YYYYMM               VARCHAR2(6 CHAR) := TO_CHAR(ADD_MONTHS(TO_DATE(V_PLAN_START_SAFE, 'YYYYMMDD'), -1), 'YYYYMM');  /* 계획 시작일 기준 전월 */

    V_CELL_UNIT_PRICE           NUMBER(20, 10) := 0;  /* 전체 셀모델에 대한 단가 (기말재고 정보가 없거나 금액이 0인 셀모델의 단가로 적용) */

    V_LAST_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR) := NULL;  /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 전월 기타충당금 복사 기능 추가 (최종 생성 DIO Trend 보고서 Plan Date) */

    /* LOG 용 변수 설정 */
    V_LOG_TYPE      VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT     PLS_INTEGER := 0;
    V_LOG_MESSAGE   VARCHAR2(1000 CHAR);
    V_DESCRIPTION   VARCHAR2(500 CHAR);
    D_EVENT_DATE    DATE;
    V_BATCH_USER    VARCHAR2(150 CHAR) := 'scm_batch';

    /* 임시 실행시간 확인용 */
    V_START_TIME    DATE := SYSDATE;
    V_EXEC_TIME     VARCHAR2(10 CHAR) := '';


    V_SQL_CODE      VARCHAR2(20 CHAR);
    V_SQL_ERRMSG    VARCHAR2(4000 CHAR);
    V_BACKTRACE     VARCHAR2(4000 CHAR);
    V_PROC_INPUT    VARCHAR2(4000 CHAR);

    N_INSERT_COUNT  NUMBER := 0;

BEGIN

    /* ------------------------------- */
    /* DM Cutoff YYYYMMDD */
    /* ------------------------------- */

    V_DM_CUTOFF_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_SAFE, 'YYYYMMDD'), 'TUE'), 'YYYYMMDD');

    /* ------------------------------------------------------------------------------------------------- */
    /* SCP PLAN 버전 정보 (PRODUCTION) */
    /* ------------------------------------------------------------------------------------------------- */
    /* Case 69: SELECT INTO 스칼라 할당 → NO_DATA_FOUND / TOO_MANY_ROWS 래핑 */
    BEGIN
        SELECT D.PLAN_SEQ
          INTO V_PLAN_SEQ
          FROM SCM_MST_PLAN P
             , SCM_MST_PLAN_DETAIL D
         WHERE D.DIVISION_ID = P.DIVISION_ID
           AND D.PLAN_ID = P.PLAN_ID
           AND D.PLAN_TYPE = 'FN' /* FN */
           AND D.PLAN_STATUS = '1' /* 정상 완료 */
           AND D.CONFIRM_FLAG = 'Y' /* 최종 Confirm */
           AND P.DIVISION_ID = P_DIVISION_ID /* 변수 처리 */
           AND P.PLAN_NAME = P_PLAN_START_YYYYMMDD /* 변수 처리 : 당주 월요일 */
           AND P.PLAN_CYCLE = 'WEEKLY'
           AND ROWNUM = 1;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_PLAN_SEQ := 1;
        WHEN TOO_MANY_ROWS THEN
            V_PLAN_SEQ := 1;
    END;

    /* ------------------------------------------------------------------------------------------------- */
    /* 참조대상 DM 버전 정보 (FCST 및 RTF) */
    /* ------------------------------------------------------------------------------------------------- */
    /* Case 69: SELECT INTO 스칼라 할당 → NO_DATA_FOUND / TOO_MANY_ROWS 래핑 */
    BEGIN
        SELECT DV.VERSION_NO
          INTO V_DM_VERSION_NO
          FROM DM_MST_VERSION DV
         WHERE DV.DIVISION_ID = P_DIVISION_ID
           AND DV.VERSION_TYPE = 'MF_W'
           AND DV.YYYYMMDD = V_DM_CUTOFF_YYYYMMDD
           AND ROWNUM = 1
          ORDER BY DV.VERSION_NO DESC FETCH FIRST 1 ROWS ONLY;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_DM_VERSION_NO := '';
        WHEN TOO_MANY_ROWS THEN
            V_DM_VERSION_NO := NULL;
    END;

    /* 시작 LOG  (START) */
    V_LOG_TYPE := 'START';
    V_LOG_MESSAGE := '##### Start of procedure #####';
    V_DESCRIPTION := P_DIVISION_ID||' : ' ||P_PLAN_START_YYYYMMDD||' : ' ||V_DM_CUTOFF_YYYYMMDD;
    D_EVENT_DATE := SYSDATE;
    BEGIN PR_SCP_SYS_LOG_BATCH($$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE); END;
    V_LOG_MESSAGE := NULL;  /*-- < - 변수 재사용을 위하여 초기화해야함 --*/
    /* 시작 LOG  (END) */

    /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 과거 실적 구간 참조 시작일 변경 */
    /* plan date가 1월인 경우 전년도 12월1일부터 참조 */
    IF TO_NUMBER(TO_CHAR(TO_DATE(V_PLAN_START_SAFE, 'YYYYMMDD'), 'MM')) = 1 THEN
        V_FROM_DATE := ADD_MONTHS(V_FROM_DATE, -1);
    END IF;

    V_FROM_YYYYMM := TO_CHAR(V_FROM_DATE, 'YYYYMM');

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' P_DIVISION_ID           = ' ||P_DIVISION_ID);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' P_PLAN_START_YYYYMMDD   = ' ||P_PLAN_START_YYYYMMDD);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_PLAN_SEQ              = ' ||TO_CHAR(V_PLAN_SEQ));
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_FROM_DATE             = ' ||TO_CHAR(V_FROM_DATE, 'YYYYMMDD'));
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_FROM_YYYYMM           = ' ||V_FROM_YYYYMM);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_PLAN_START_YYYYMM     = ' ||V_PLAN_START_YYYYMM);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_LAST_YYYYMM           = ' ||V_LAST_YYYYMM);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_DM_CUTOFF_YYYYMMDD    = ' ||V_DM_CUTOFF_YYYYMMDD);
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' V_DM_VERSION_NO         = ' ||V_DM_VERSION_NO);

    /* ------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 0.1 셀/팩 대상 Item master 정보');
    /* ------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_TARGET_ITEMS';

    INSERT INTO GT_PRSCP_TMP_TARGET_ITEMS (
        DIVISION_ID
       , ITEM_ID
       , CELL_CF
       , TARGET_CELL
       , SCP_FLOW_ID
       , OPERATION_GROUP
       , ITEM_CLASS
       , DOE
       , DOE_CELL
       , OPERATION_ID
       , CELL_GROUP
       , PACK_GROUP
       , LEVEL4
       , PIC_ID
       , BASICCELL_NICKNAME
       , NICK_NAME
       , NICKNAME_FOR_DIO
    )
    SELECT I.DIVISION_ID
         , I.ITEM_ID
         , CASE
                WHEN I.SCP_OPERATION_GROUP = 'A' THEN CAST('1.0' AS NUMBER(20, 10))
                WHEN CF.CELL_CF IS NOT NULL THEN CAST(CF.CELL_CF AS NUMBER(20, 10))
                WHEN CF2.CELL_CF IS NOT NULL THEN CAST(CF2.CELL_CF AS NUMBER(20, 10))
                WHEN CF3.CELL_CF IS NOT NULL THEN CAST(CF3.CELL_CF AS NUMBER(20, 10))
                ELSE 1
            END AS CELL_CF
         , CASE
                WHEN I.SCP_OPERATION_GROUP = 'A' THEN I.ITEM_ID
                WHEN CF.CELL_CF IS NOT NULL THEN CF.TARGET_CELL
                WHEN CF2.CELL_CF IS NOT NULL THEN CF2.TARGET_CELL
                WHEN CF3.CELL_CF IS NOT NULL THEN CF3.TARGET_CELL
                ELSE I.ITEM_ID
            END AS TARGET_CELL
         , MAX(I.SCP_FLOW_ID) AS SCP_FLOW_ID
         , MAX(I.SCP_OPERATION_GROUP) AS OPERATION_GROUP
         , MAX(I.ITEM_CLASS) AS ITEM_CLASS
         , MAX(I.DOE) AS DOE
         , MAX(C.DOE) AS DOE_CELL
         , MAX(FI.FLOW_ID) AS OPERATION_ID
         , MAX(FI.GROUP_CODE1) AS CELL_GROUP
         , MAX(FI.GROUP_CODE2) AS PACK_GROUP
         , MAX(FI.GROUP_CODE5) AS LEVEL4
         , MAX(FI.ATTRIBUTE6) AS PIC_ID
         , MAX(BC.NICK_NAME) AS BASICCELL_NICKNAME
         , MAX(FI.NICK_NAME) AS NICK_NAME
         , CASE /* 2023.04.28 Cell Group 기준 변경  WHEN NVL(MAX(FI.GROUP_CODE5),'') IS NOT NULL  THEN MAX(FI.GROUP_CODE5) -- 1순위 Level4 */
                WHEN NVL(MAX(FI.GROUP_CODE1), '') IS NOT NULL THEN MAX(FI.GROUP_CODE1) /* 2순위 Cell Group */
                WHEN NVL(MAX(BC.NICK_NAME), '') IS NOT NULL THEN MAX(BC.NICK_NAME) /* 3순위 Basic Cell의 NickName */
                WHEN NVL(MAX(FI.NICK_NAME), '') IS NOT NULL THEN MAX(FI.NICK_NAME) /* 4순위 Nick_name */
                ELSE I.ITEM_ID
            END AS NICKNAME_FOR_DIO
      FROM SCM_MST_ITEM_SN I /* 2022/9/13 공정 필터링 - production plan line 참조  */
    INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L
      ON L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
       AND L.SEGMENT1 != 'F6000'
       AND L.VALID_YN = 'Y'
       AND L.SEGMENT1 = I.SCP_FLOW_ID
       AND L.SEGMENT4 LIKE '%'||P_DIVISION_ID||'%'
    LEFT JOIN SCP_MST_FINAL_ITEM FI
      ON FI.DIVISION_ID = I.DIVISION_ID
       AND FI.ITEM_ID = I.ITEM_ID
    LEFT JOIN SCM_MST_ITEM_SN C
      ON C.DIVISION_ID = FI.DIVISION_ID
       AND C.ITEM_ID = CASE WHEN FI.OPERATION_GROUP = 'P' THEN FI.ATTRIBUTE1 ELSE FI.ITEM_ID END
       AND C.DOE IS NOT NULL
    LEFT JOIN SCP_MST_FINAL_ITEM BC
      ON BC.DIVISION_ID = C.DIVISION_ID
       AND BC.ITEM_ID = C.DOE
    LEFT JOIN SCP_MST_ITEM_CELL_CF CF
      ON CF.ITEM_ID = I.ITEM_ID
       AND CF.CELL_CF IS NOT NULL
       AND CAST(CF.CELL_CF AS NUMBER(20, 10)) != 0.0
    LEFT JOIN SCP_MST_ITEM_CELL_CF CF2
      ON CF2.ITEM_ID = SUBSTR(I.ITEM_ID, 1, LENGTH(I.ITEM_ID) - 2)
       AND I.ITEM_ID LIKE '%-_'
       AND I.SCP_OPERATION_GROUP = 'P'
       AND CF.CELL_CF IS NULL
       AND CF2.CELL_CF IS NOT NULL
       AND CAST(CF2.CELL_CF AS NUMBER(20, 10)) != 0.0
    LEFT JOIN SCP_MST_ITEM_CELL_CF CF3
      ON CF3.ITEM_ID = SUBSTR(I.ITEM_ID, 1, LENGTH(I.ITEM_ID) - 3)
       AND I.ITEM_ID LIKE '%-__'
       AND I.SCP_OPERATION_GROUP = 'P'
       AND CF.CELL_CF IS NULL
       AND CF2.CELL_CF IS NULL
       AND CF3.CELL_CF IS NOT NULL
       AND CAST(CF3.CELL_CF AS NUMBER(20, 10)) != 0.0
     WHERE I.DIVISION_ID = P_DIVISION_ID
       AND I.SCP_OPERATION_GROUP IN ('A', 'P')
      GROUP BY I.DIVISION_ID
             , I.ITEM_ID
             , CASE WHEN I.SCP_OPERATION_GROUP = 'A' THEN CAST('1.0' AS NUMBER(20, 10)) WHEN CF.CELL_CF IS NOT NULL THEN CAST(CF.CELL_CF AS NUMBER(20, 10)) WHEN CF2.CELL_CF IS NOT NULL THEN CAST(CF2.CELL_CF AS NUMBER(20, 10)) WHEN CF3.CELL_CF IS NOT NULL THEN CAST(CF3.CELL_CF AS NUMBER(20, 10)) ELSE 1.0 END
             , CASE WHEN I.SCP_OPERATION_GROUP = 'A' THEN I.ITEM_ID WHEN CF.CELL_CF IS NOT NULL THEN CF.TARGET_CELL WHEN CF2.CELL_CF IS NOT NULL THEN CF2.TARGET_CELL WHEN CF3.CELL_CF IS NOT NULL THEN CF3.TARGET_CELL ELSE I.ITEM_ID END;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_TARGET_ITEMS'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 0.2 Target Item정보에 없는 AMDAU 모델 정보');
    /* ------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_AMDAU_ITEMS';

    INSERT INTO GT_PRSCP_TMP_AMDAU_ITEMS (
        DIVISION_ID
       , ITEM_ID
       , CELL_CF
       , TARGET_CELL
       , SCP_FLOW_ID
       , OPERATION_GROUP
       , ITEM_CLASS
       , PARENT_DOE
       , CHILD_DOE
       , DOE_CELL
       , FP_CELL_GROUP
       , FP_LEVEL4
       , FP_NICK_NAME
       , FC_CELL_GROUP
       , FC_LEVEL4
       , FC_NICK_NAME
       , BASICCELL_NICKNAME
       , FP_PIC_ID
       , FC_PIC_ID
       , PIC_ID
       , NICKNAME_FOR_DIO
    )
    WITH BOM_INFO AS (
        SELECT DIVISION_ID
              , PARENT_ITEM_ID
              , CHILD_ITEM_ID
              , KEY_DATE
              , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                              , PARENT_ITEM_ID
                                      ORDER BY KEY_DATE DESC) AS RN
          FROM SCM_MST_BOM_ENG_SN
         WHERE DIVISION_ID = P_DIVISION_ID
           AND PARENT_ITEM_ID LIKE 'AMDAU%'
           AND CHILD_ITEM_ID LIKE 'AC%'
    ), AMDAU_ITEM_LIST AS (
        SELECT DIVISION_ID
              , PARENT_ITEM_ID
              , MIN(CHILD_ITEM_ID) AS CHILD_ITEM_ID
              , MIN(KEY_DATE)      AS KEY_DATE_MIN
              , MAX(KEY_DATE)      AS KEY_DATE_MAX
          FROM BOM_INFO
         WHERE RN = 1  /* LAST BOM */
         GROUP BY DIVISION_ID
                 , PARENT_ITEM_ID
    )
    SELECT AI.DIVISION_ID
          , AI.PARENT_ITEM_ID           AS ITEM_ID
          , CASE WHEN II.SCP_OPERATION_GROUP = 'A' THEN CAST('1.0' AS NUMBER(20, 10))
                WHEN CF.CELL_CF     IS NOT NULL   THEN CAST(CF.CELL_CF  AS NUMBER(20, 10))
                WHEN CF2.CELL_CF    IS NOT NULL   THEN CAST(CF2.CELL_CF AS NUMBER(20, 10))
                WHEN CF3.CELL_CF    IS NOT NULL   THEN CAST(CF3.CELL_CF AS NUMBER(20, 10))
                ELSE 1
           END AS CELL_CF
          , CASE WHEN II.SCP_OPERATION_GROUP = 'A' THEN AI.PARENT_ITEM_ID
                WHEN CF.CELL_CF     IS NOT NULL   THEN CF.TARGET_CELL
                WHEN CF2.CELL_CF    IS NOT NULL   THEN CF2.TARGET_CELL
                WHEN CF3.CELL_CF    IS NOT NULL   THEN CF3.TARGET_CELL
                ELSE AI.PARENT_ITEM_ID
           END AS TARGET_CELL
          , MAX(II.SCP_FLOW_ID)         AS SCP_FLOW_ID
          , MAX(II.SCP_OPERATION_GROUP) AS OPERATION_GROUP
          , MAX(II.ITEM_CLASS)          AS ITEM_CLASS
          , MAX(II.DOE)                 AS PARENT_DOE
          , MAX(CI.DOE)                 AS CHILD_DOE
          , MAX(CC.DOE)                 AS DOE_CELL
          , MAX(FP.GROUP_CODE1)         AS FP_CELL_GROUP
          , MAX(FP.GROUP_CODE5)         AS FP_LEVEL4
          , MAX(FP.NICK_NAME)           AS FP_NICK_NAME
          , MAX(FC.GROUP_CODE1)         AS FC_CELL_GROUP
          , MAX(FC.GROUP_CODE5)         AS FC_LEVEL4
          , MAX(FC.NICK_NAME)           AS FC_NICK_NAME
          , MAX(BC.NICK_NAME)           AS BASICCELL_NICKNAME
          , MAX(FP.ATTRIBUTE6)          AS FP_PIC_ID
          , MAX(FC.ATTRIBUTE6)          AS FC_PIC_ID
          , NVL(MAX(FP.ATTRIBUTE6)
              , MAX(FC.ATTRIBUTE6))     AS PIC_ID
          , CASE /* 2023.04.28 Cell Group 기준 변경 WHEN NVL(MAX(FP.GROUP_CODE5),'') IS NOT NULL  THEN MAX(FP.GROUP_CODE5) -- 1순위 Level4		(parent-AMDAU) */
                WHEN NVL(MAX(FP.GROUP_CODE1), '') IS NOT NULL  THEN MAX(FP.GROUP_CODE1) /* 2순위 Cell Group	(parent-AMDAU) */
                /* 2023.04.28 Cell Group 기준 변경 WHEN NVL(MAX(FC.GROUP_CODE5),'') != '' THEN MAX(FC.GROUP_CODE5) -- 3순위 Level4		(child cell) */
                WHEN NVL(MAX(FC.GROUP_CODE1), '') IS NOT NULL  THEN MAX(FC.GROUP_CODE1) /* 4순위 Cell Group	(child cell) */
                WHEN NVL(MAX(BC.NICK_NAME), '') IS NOT NULL  THEN MAX(BC.NICK_NAME)   /* 5순위 Basic Cell의 NickName (child cell) */
                WHEN NVL(MAX(FP.NICK_NAME), '') IS NOT NULL  THEN MAX(FP.NICK_NAME)   /* 6순위 Nick_name (parent-AMDAU) */
                WHEN NVL(MAX(FC.NICK_NAME), '') IS NOT NULL  THEN MAX(FC.NICK_NAME)   /* 7순위 Nick_name (child cell) */
                ELSE AI.PARENT_ITEM_ID
           END AS NICKNAME_FOR_DIO
      FROM AMDAU_ITEM_LIST AI
           INNER JOIN SCM_MST_ITEM_SN II
                   ON II.DIVISION_ID = AI.DIVISION_ID
                  AND II.ITEM_ID     = AI.PARENT_ITEM_ID
           LEFT JOIN SCP_MST_FINAL_ITEM FP
                  ON FP.DIVISION_ID = AI.DIVISION_ID
                 AND FP.ITEM_ID     = AI.PARENT_ITEM_ID
           LEFT JOIN SCM_MST_ITEM_SN CI
                  ON CI.DIVISION_ID = AI.DIVISION_ID
                 AND CI.ITEM_ID     = AI.CHILD_ITEM_ID
           LEFT JOIN SCP_MST_FINAL_ITEM FC
                  ON FC.DIVISION_ID = AI.DIVISION_ID
                 AND FC.ITEM_ID     = AI.CHILD_ITEM_ID
           LEFT JOIN SCM_MST_ITEM_SN CC
                  ON CC.DIVISION_ID = FC.DIVISION_ID
                 AND CC.ITEM_ID     = CASE WHEN FC.OPERATION_GROUP = 'P'
                                           THEN FC.ATTRIBUTE1
                                           ELSE FC.ITEM_ID
                                      END
                 AND CC.DOE IS NOT NULL
           LEFT JOIN SCP_MST_FINAL_ITEM BC
                  ON BC.DIVISION_ID = CC.DIVISION_ID
                 AND BC.ITEM_ID     = CC.DOE
           LEFT JOIN SCP_MST_ITEM_CELL_CF CF
                  ON CF.ITEM_ID    = AI.PARENT_ITEM_ID
                 AND CF.CELL_CF IS NOT NULL
                 AND CAST(CF.CELL_CF AS NUMBER(20, 10)) != 0.0
           LEFT JOIN SCP_MST_ITEM_CELL_CF CF2
                  ON CF2.ITEM_ID   = SUBSTR(AI.PARENT_ITEM_ID, 1, LENGTH(AI.PARENT_ITEM_ID) - 2)
                 AND AI.PARENT_ITEM_ID LIKE '%-_'
                 AND II.SCP_OPERATION_GROUP = 'P'
                 AND CF.CELL_CF IS NULL
                 AND CF2.CELL_CF IS NOT NULL
                 AND CAST(CF2.CELL_CF AS NUMBER(20, 10)) != 0.0
           LEFT JOIN SCP_MST_ITEM_CELL_CF CF3
                  ON CF3.ITEM_ID   = SUBSTR(AI.PARENT_ITEM_ID, 1, LENGTH(AI.PARENT_ITEM_ID) - 3)
                 AND AI.PARENT_ITEM_ID LIKE '%-__'
                 AND II.SCP_OPERATION_GROUP = 'P'
                 AND CF.CELL_CF  IS NULL
                 AND CF2.CELL_CF IS NULL
                 AND CF3.CELL_CF IS NOT NULL
                 AND CAST(CF3.CELL_CF AS NUMBER(20, 10)) != 0.0
     WHERE NOT EXISTS (
               SELECT 1
                 FROM GT_PRSCP_TMP_TARGET_ITEMS TI  /* - Target item에 포함된 모델들 제외 */
                WHERE TI.DIVISION_ID = AI.DIVISION_ID
                  AND TI.ITEM_ID     = AI.PARENT_ITEM_ID
           )
     GROUP BY AI.DIVISION_ID
             , AI.PARENT_ITEM_ID
             , CASE WHEN II.SCP_OPERATION_GROUP = 'A'     THEN CAST('1.0' AS NUMBER(20, 10))
                   WHEN CF.CELL_CF     IS NOT NULL        THEN CAST(CF.CELL_CF  AS NUMBER(20, 10))
                   WHEN CF2.CELL_CF    IS NOT NULL        THEN CAST(CF2.CELL_CF AS NUMBER(20, 10))
                   WHEN CF3.CELL_CF    IS NOT NULL        THEN CAST(CF3.CELL_CF AS NUMBER(20, 10))
                   ELSE 1
              END
             , CASE WHEN II.SCP_OPERATION_GROUP = 'A'     THEN AI.PARENT_ITEM_ID
                   WHEN CF.CELL_CF     IS NOT NULL        THEN CF.TARGET_CELL
                   WHEN CF2.CELL_CF    IS NOT NULL        THEN CF2.TARGET_CELL
                   WHEN CF3.CELL_CF    IS NOT NULL        THEN CF3.TARGET_CELL
                   ELSE AI.PARENT_ITEM_ID
              END;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_AMDAU_ITEMS'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ----------------------------------------------------------------------------------------------------------------- */
    /* Begin 2023.07.11 활성화코드 분리 대응 : CA-CP 치환 적용 */
    /* ----------------------------------------------------------------------------------------------------------------- */

    /* ---------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 0.3 활성화코드 분리 대응 - CA/CP 매핑정보');
    /* ---------------------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_CELLPRODUCT_INFO';

    INSERT INTO GT_PRSCP_TMP_CELLPRODUCT_INFO (
        DIVISION_ID
       , PLANT_ID
       , ITEM_ID_ASSY
       , ITEM_ID_PROD
       , TCO_CELL_YN
       , PRIORITY_1ST
       , PRIORITY_2ND
       , PRIORITY_3RD
    )
    SELECT M.DIVISION_ID
          , M.PLANT_ID
          , M.ITEM_ID_ASSY
          , M.ITEM_ID_PROD
          , FI.TCO_CELL_YN
          , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                          , M.ITEM_ID_ASSY
                                          , M.PLANT_ID
                                  ORDER BY M.VALID_YN    DESC
                                          , FI.TCO_CELL_YN DESC  /* TCO 우선 선택 */
                                          , M.ITEM_ID_PROD) PRIORITY_1ST
          , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                          , M.ITEM_ID_ASSY
                                  ORDER BY M.VALID_YN    DESC
                                          , FI.TCO_CELL_YN DESC  /* TCO 우선 선택 */
                                          , M.ITEM_ID_PROD) PRIORITY_2ND
          , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
                                  ORDER BY M.VALID_YN    DESC
                                          , FI.TCO_CELL_YN DESC  /* TCO 우선 선택 */
                                          , M.ITEM_ID_PROD) PRIORITY_3RD
      FROM SCP_MST_CELL_PROD_ASSY_MAP M
         , SCP_MST_FINAL_ITEM FI
     WHERE FI.DIVISION_ID = M.DIVISION_ID
       AND FI.ITEM_ID     = M.ITEM_ID_PROD
       AND M.VALID_YN     = 'Y'  /* 2023/07/26 추가 */
    ;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_CELLPRODUCT_INFO'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ----------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 1 조립(생산) 데이터 추출');
    /* ----------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.1 조립(생산) 데이터 추출 - 계획/실적 Raw Data (CA->CP 치환)');
    /* ----------------------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_PRODUCTION_RAW';

    INSERT INTO GT_PRSCP_TMP_PRODUCTION_RAW (
        DIVISION_ID
       , COMPANY_ID
       , SITE_ID
       , SCM_SITE_ID
       , PLANT_ID
       , YYYYMM
       , YYYYMMDD
       , LINE_ID
       , OPERATION_ID
       , OPERATION_GROUP
       , ITEM_ID_ORG
       , ITEM_ID
       , QTY
       , RP_DIV
    )
    WITH PROD_RAW_DATA AS (
         /* 계획 */
         SELECT  P.DIVISION_ID
                , S.COMPANY_ID
                , S.SITE_ID
                , P.SCM_SITE_ID
                , S.PLANT_ID
                , B.YYYYMM
                , P.YYYYMMDD
                , P.LINE_ID
                , P.OPERATION_ID
                , P.OPERATION_GROUP
                , P.ITEM_ID
                , P.QTY
                , 'P' AS RP_DIV
           FROM SCP_ANL_PRODUCTION_PLAN P
              , SCM_MST_SITE S
              , SCM_MST_BUCKET B
          WHERE S.DIVISION_ID = P.DIVISION_ID
            AND S.SCM_SITE_ID = P.SCM_SITE_ID
            AND B.YYYYMMDD = P.YYYYMMDD
            AND P.DIVISION_ID          = P_DIVISION_ID
            AND P.PLAN_START_YYYYMMDD  = P_PLAN_START_YYYYMMDD
            AND P.PLAN_TYPE            = 'FN'
            AND P.SEQ                  = V_PLAN_SEQ
            AND P.MEASURE              = 'PROD_PLAN_AMEND'
         UNION ALL
         /* 실적 */
         SELECT  R.DIVISION_ID
                , S.COMPANY_ID
                , S.SITE_ID
                , R.SCM_SITE_ID
                , S.PLANT_ID
                , B.YYYYMM
                , TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                , R.LINE_ID
                , R.OPERATION_ID
                , R.SCP_OPERATION_GROUP
                , R.ITEM_ID
                , R.ACTUAL_GOOD_QTY AS QTY
                , 'R' AS RP_DIV
           FROM SCM_DNM_PRODUCT_RESULT_V R
              , SCM_MST_SITE S
              , SCM_MST_BUCKET B
          WHERE S.DIVISION_ID = R.DIVISION_ID
            AND S.SCM_SITE_ID = R.SCM_SITE_ID
            AND B.YYYYMMDD = TO_CHAR(R.PLAN_DATE, 'YYYYMMDD')
            AND R.DIVISION_ID  = P_DIVISION_ID
            AND R.PLAN_DATE   >= V_FROM_DATE
            AND R.PLAN_DATE    < TO_DATE(V_PLAN_START_SAFE, 'YYYYMMDD')  /* plan start date 이전 */
            AND (R.OPERATION_ID IN (SELECT L.SEGMENT1
                                        FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                                       WHERE L.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                         AND L.SEGMENT1   != 'F6000'
                                         AND L.VALID_YN    = 'Y'
                                     )
                   OR
                   R.OPERATION_ID IN (SELECT PS.PLANT_ID  /* 외주 Packer 실적 */
                                        FROM SCM_MST_SITE PS
                                       WHERE PS.DIVISION_ID = P_DIVISION_ID
                                         AND PS.SITE_TYPE   = 'PLANT'
                                         AND PS.OSP_YN      = 'Y'
                                         AND PS.VALID_YN    = 'Y'
                                     )
                )
    )
    SELECT P.DIVISION_ID
          , P.COMPANY_ID
          , P.SITE_ID
          , P.SCM_SITE_ID
          , P.PLANT_ID
          , P.YYYYMM
          , P.YYYYMMDD
          , P.LINE_ID
          , P.OPERATION_ID
          , P.OPERATION_GROUP
          , P.ITEM_ID AS ITEM_ID_ORG
          , CASE WHEN P.OPERATION_GROUP = 'A'    AND
                     NVL(C1.ITEM_ID_PROD, NVL(C2.ITEM_ID_PROD, NVL(C3.ITEM_ID_PROD, '-'))) != '-'
                THEN NVL(C1.ITEM_ID_PROD, NVL(C2.ITEM_ID_PROD, NVL(C3.ITEM_ID_PROD, '-')))
                ELSE P.ITEM_ID
           END AS ITEM_ID  /* CA인경우 CP로 치환 적용 */
          , P.QTY
          , P.RP_DIV
      FROM PROD_RAW_DATA   P
         , GT_PRSCP_TMP_CELLPRODUCT_INFO C1
         , GT_PRSCP_TMP_CELLPRODUCT_INFO C2
         , GT_PRSCP_TMP_CELLPRODUCT_INFO C3
     WHERE C1.DIVISION_ID(+)  = P.DIVISION_ID
       AND C1.PLANT_ID(+)     = P.PLANT_ID
       AND C1.ITEM_ID_ASSY(+) = P.ITEM_ID
       AND C1.PRIORITY_1ST(+) = 1
       AND C2.DIVISION_ID(+)  = P.DIVISION_ID
       AND C2.ITEM_ID_ASSY(+) = P.ITEM_ID
       AND C2.PRIORITY_2ND(+) = 1
       AND C3.ITEM_ID_ASSY(+) = P.ITEM_ID
       AND C3.PRIORITY_3RD(+) = 1;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_PRODUCTION_RAW'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ----------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.2 조립(생산) 데이터 추출 - 계획/실적 모델별/월별 집계');
    /* ----------------------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_PRODUCTION';

    INSERT INTO GT_PRSCP_TMP_PRODUCTION (
        YYYYMM
       , ITEM_ID
       , CELL_GROUP
       , OPERATION_GROUP
       , CELL_CF
       , TARGET_CELL
       , RP_DIV
       , QTY
       , QTY_YIELD
       , BEFORE_PACK_QTY
    )
    SELECT P.YYYYMM
          , P.ITEM_ID
          , I.CELL_GROUP
          , P.OPERATION_GROUP
          , I.CELL_CF
          , I.TARGET_CELL
          , P.RP_DIV
          , SUM(P.QTY) AS QTY
          , SUM(CASE WHEN RP_DIV = 'P' THEN  /* 계획 */
                         P.QTY * CASE WHEN I.OPERATION_GROUP = 'P'                       THEN 1                        /* Pack의 생산계획은 수율이 반영된 수량 임. */
                                      WHEN NVL(F.SSP_MODIFY_YIELD, 0)        != 0        THEN F.SSP_MODIFY_YIELD        /* (Cell) Formation User Modify Yield  값이 있으면 User Modify Yield 적용 */
                                      WHEN NVL(F.FORMATION_TOTAL_YIELD, 0)   != 0        THEN F.FORMATION_TOTAL_YIELD   /* (Cell) Formation User Modify Yield  값이 없으면 Formation Total Yield 적용 */
                                      ELSE 1
                                 END
                    ELSE P.QTY              /* 실적  (실적 자체가 수율 반영된 수량) */
               END) AS QTY_YIELD
          , CASE WHEN P.RP_DIV = 'P' AND P.OPERATION_GROUP = 'P'  /* 계획(팩) */
                     THEN SUM(P.QTY / CASE WHEN NVL(Y.YIELD, 0) = 0
                                           THEN 1
                                           ELSE Y.YIELD
                                      END)  /* 생산계획은 수율이 적용된 수량임 -> 수율적용 전 계획 수량 */
                WHEN P.RP_DIV = 'R' AND P.OPERATION_GROUP = 'P' AND P.YYYYMM = V_PLAN_START_YYYYMM  /* 당월 Pack 생산 실적 (수율 반영전 생산계획 수량 = 실적/수율) */
                     THEN SUM(P.QTY / NVL(Y.YIELD, 1))
                ELSE 0
           END AS BEFORE_PACK_QTY  /* 당월포함 미래구간 팩 생산에 투입된 셀수량을 계산하기 위한 수율반영전 생산 계획 수량임 (당월은 실적반영) */
      FROM GT_PRSCP_TMP_PRODUCTION_RAW P
         , GT_PRSCP_TMP_TARGET_ITEMS I
         , SCM_MST_YIELD_SN Y
         , SCP_MST_FORMATION F
     WHERE I.DIVISION_ID = P.DIVISION_ID
       AND I.ITEM_ID     = P.ITEM_ID
       AND Y.COMPANY_ID(+)   = P.COMPANY_ID
       AND Y.DIVISION_ID(+)  = P.DIVISION_ID
       AND Y.SITE_ID(+)      = P.SITE_ID
       AND Y.PLANT_ID(+)     = P.PLANT_ID
       AND Y.OPERATION_ID(+) = P.OPERATION_ID
       AND Y.LINE_ID(+)      = P.LINE_ID
       AND Y.ITEM_ID(+)      = P.ITEM_ID
       AND Y.MONTH(+)        = CASE WHEN P.RP_DIV = 'R'  /* 실적 구간은 당월 수율 참조 */
                                    THEN V_PLAN_START_YYYYMM
                                    ELSE P.YYYYMM
                               END
       AND Y.YIELD(+)       != 0
       AND F.DIVISION_ID(+)   = P.DIVISION_ID
       AND F.PLANT_SITE_ID(+) = P.SCM_SITE_ID
       AND F.ITEM_ID(+)       = P.ITEM_ID
     GROUP BY P.YYYYMM
             , P.ITEM_ID
             , I.CELL_GROUP
             , P.OPERATION_GROUP
             , I.CELL_CF
             , I.TARGET_CELL
             , P.RP_DIV;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_PRODUCTION'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ---------------------------------------------------------------------------------------------------------------- */
    /* End 2023.07.11 활성화코드 분리 대응 : CA-CP 치환 적용 조립(생산) 데이터 추출 */
    /* ---------------------------------------------------------------------------------------------------------------- */

    /* ------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.3 조립(생산) 데이터 추출 - 과거 1년전부터 생산계획 최종 년월까지 월 목록 추출');
    /* ------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_MM_LIST';

    INSERT INTO GT_PRSCP_TMP_MM_LIST (
        YYYYMM
       , FIRST_YMD
       , LAST_YMD
       , MM_DAYS
    )
    SELECT B.YYYYMM
          , MIN(B.YYYYMMDD) AS FIRST_YMD
          , MAX(B.YYYYMMDD) AS LAST_YMD
          , CAST(COUNT(*) AS NUMBER(20, 10)) AS MM_DAYS
      FROM SCM_MST_BUCKET B
     WHERE B.YYYYMM BETWEEN V_FROM_YYYYMM
                        AND (SELECT MAX(P2.YYYYMM)
                               FROM GT_PRSCP_TMP_PRODUCTION P2)
     GROUP BY B.YYYYMM;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_MM_LIST'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ---------------------------------------------------------------------------------------------------------------- */
    /* Begin 2023.07.11 활성화코드 분리 대응 : CA-CP 치환 적용 재고 Raw데이터 추출 */
    /* ------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.4.1 재고 데이터 추출 : CA->CP 치환 Raw 데이터');
    /* ------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_SCP_ANL_MES_STOCK_R';

    INSERT INTO GT_PRSCP_TMP_SCP_ANL_MES_STOCK_R (
        YYYYMM
       , DIVISION_ID
       , ITEM_ID
       , QUANTITY
       , AMOUNT_KRW
    )
    SELECT I.YYYYMM
          , I.DIVISION_ID
          , CASE WHEN IM.OPERATION_GROUP = 'A'    AND
                     NVL(C1.ITEM_ID_PROD, NVL(C2.ITEM_ID_PROD, NVL(C3.ITEM_ID_PROD, '-'))) != '-'
                THEN NVL(C1.ITEM_ID_PROD, NVL(C2.ITEM_ID_PROD, NVL(C3.ITEM_ID_PROD, '-')))
                ELSE I.ITEM_ID
           END AS ITEM_ID  /* CA인 경우 CP로 치환 적용 */
          , I.QUANTITY
          , I.AMOUNT_KRW
      FROM SCP_ANL_MONTH_END_STOCK_R I
         , GT_PRSCP_TMP_TARGET_ITEMS IM
         , GT_PRSCP_TMP_CELLPRODUCT_INFO C1
         , GT_PRSCP_TMP_CELLPRODUCT_INFO C2
         , GT_PRSCP_TMP_CELLPRODUCT_INFO C3
     WHERE IM.DIVISION_ID = I.DIVISION_ID
       AND IM.ITEM_ID     = I.ITEM_ID
       AND C1.DIVISION_ID(+)  = I.DIVISION_ID
       AND C1.PLANT_ID(+)     = I.PLANT_ID
       AND C1.ITEM_ID_ASSY(+) = I.ITEM_ID
       AND C1.PRIORITY_1ST(+) = 1
       AND C2.DIVISION_ID(+)  = I.DIVISION_ID
       AND C2.ITEM_ID_ASSY(+) = I.ITEM_ID
       AND C2.PRIORITY_2ND(+) = 1
       AND C3.ITEM_ID_ASSY(+) = I.ITEM_ID
       AND C3.PRIORITY_3RD(+) = 1
       AND I.DIVISION_ID = P_DIVISION_ID
       AND I.YYYYMM     >= V_FROM_YYYYMM
       AND I.YYYYMM     <= V_LAST_YYYYMM;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_SCP_ANL_MES_STOCK_R'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ---------------------------------------------------------------------------------------------------------------- */
    /* End 2023.07.11 활성화코드 분리 대응 : CA-CP 치환 적용 재고 Raw데이터 추출 */
    /* ---------------------------------------------------------------------------------------------------------------- */

    /* ------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.4 재고 데이터 추출 - 과거구간 셀환산전 (0채움)');
    /* ------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_INVENTORY';

    INSERT INTO GT_PRSCP_TMP_INVENTORY (
        YYYYMM
       , ITEM_ID
       , OPERATION_GROUP
       , CELL_CONVERT_YN
       , TARGET_CELL
       , CELL_CF
       , QUANTITY
       , AMOUNT
       , UNIT_PRICE
       , YYYYMM_LAST
       , UNIT_PRICE_LAST
    )
    WITH INVENTORY AS (
        SELECT I.YYYYMM
              , I.ITEM_ID
              , IM.OPERATION_GROUP
              , IM.CELL_CF
              , IM.TARGET_CELL
              , 'N' AS CELL_CONVERT_YN
              , CAST(SUM(I.QUANTITY) AS NUMBER(30, 10))  AS QUANTITY
              , CAST(SUM(I.AMOUNT_KRW) AS NUMBER(30, 10)) AS AMOUNT
              , CASE WHEN SUM(I.QUANTITY) != 0  AND SUM(I.AMOUNT_KRW) != 0
                    THEN ROUND(SUM(I.AMOUNT_KRW) / SUM(I.QUANTITY), 0)
                    ELSE 0
               END AS UNIT_PRICE
              , MAX(CASE WHEN SUM(I.QUANTITY) != 0 AND SUM(I.AMOUNT_KRW) != 0
                         THEN I.YYYYMM
                         ELSE NULL
                    END) OVER (PARTITION BY I.ITEM_ID) AS YYYYMM_LAST
          FROM GT_PRSCP_TMP_SCP_ANL_MES_STOCK_R I  /* 2023.07.11 활성화코드 분리대으로 참조 변경 (CA->CP 치환 데이터) */
             , GT_PRSCP_TMP_TARGET_ITEMS IM
         WHERE IM.DIVISION_ID = I.DIVISION_ID
           AND IM.ITEM_ID     = I.ITEM_ID
         GROUP BY I.YYYYMM
                 , I.ITEM_ID
                 , IM.OPERATION_GROUP
                 , IM.CELL_CF
                 , IM.TARGET_CELL
        /* ---------------------------------- */
        /* AMDAU 모델 재고 추가 11/30 */
        /* ---------------------------------- */
        UNION ALL
        SELECT I.YYYYMM
              , I.ITEM_ID
              , IM.OPERATION_GROUP
              , IM.CELL_CF
              , IM.TARGET_CELL
              , 'N' AS CELL_CONVERT_YN
              , CAST(SUM(I.QUANTITY) AS NUMBER(30, 10))  AS QUANTITY
              , CAST(SUM(I.AMOUNT_KRW) AS NUMBER(30, 10)) AS AMOUNT
              , CASE WHEN SUM(I.QUANTITY) != 0  AND SUM(I.AMOUNT_KRW) != 0
                    THEN ROUND(SUM(I.AMOUNT_KRW) / SUM(I.QUANTITY), 0)
                    ELSE 0
               END AS UNIT_PRICE
              , MAX(CASE WHEN SUM(I.QUANTITY) != 0 AND SUM(I.AMOUNT_KRW) != 0
                         THEN I.YYYYMM
                         ELSE NULL
                    END) OVER (PARTITION BY I.ITEM_ID) AS YYYYMM_LAST
          FROM SCP_ANL_MONTH_END_STOCK_R I
             , GT_PRSCP_TMP_AMDAU_ITEMS IM
         WHERE IM.DIVISION_ID = I.DIVISION_ID
           AND IM.ITEM_ID     = I.ITEM_ID
           AND I.DIVISION_ID = P_DIVISION_ID
           AND I.YYYYMM     >= V_FROM_YYYYMM
           AND I.YYYYMM     <= V_LAST_YYYYMM
         GROUP BY I.YYYYMM
                 , I.ITEM_ID
                 , IM.OPERATION_GROUP
                 , IM.CELL_CF
                 , IM.TARGET_CELL
    )
    SELECT ML.YYYYMM
          , I.ITEM_ID
          , I.OPERATION_GROUP
          , I.CELL_CONVERT_YN
          , I.TARGET_CELL
          , I.CELL_CF
          , CAST(MAX(CASE WHEN ML.YYYYMM = I.YYYYMM THEN I.QUANTITY   ELSE NULL END) AS NUMBER(30, 0)) AS QUANTITY
          , CAST(MAX(CASE WHEN ML.YYYYMM = I.YYYYMM THEN I.AMOUNT     ELSE NULL END) AS NUMBER(30, 0)) AS AMOUNT
          , CAST(MAX(CASE WHEN ML.YYYYMM = I.YYYYMM THEN I.UNIT_PRICE ELSE NULL END) AS NUMBER(30, 0)) AS UNIT_PRICE
          , MAX(I.YYYYMM_LAST) AS YYYYMM_LAST
          , MAX(CAST(MAX(CASE WHEN I.YYYYMM = I.YYYYMM_LAST THEN I.UNIT_PRICE ELSE NULL END) AS NUMBER(30, 0)))
               OVER (PARTITION BY I.ITEM_ID) AS UNIT_PRICE_LAST
      FROM GT_PRSCP_TMP_MM_LIST ML  /* - 월별 데이터 없는 item에 대해 0으로 데이터 생성. */
         , INVENTORY I
     WHERE ML.YYYYMM <= V_LAST_YYYYMM
       AND I.YYYYMM  <= V_LAST_YYYYMM
     GROUP BY ML.YYYYMM
             , I.ITEM_ID
             , I.OPERATION_GROUP
             , I.CELL_CONVERT_YN
             , I.TARGET_CELL
             , I.CELL_CF;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_INVENTORY'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ---------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.5 전체 CELL 단가 - 기말재고가 없거나 금액이 0인 셀모델의 단가로 적용');
    /* ---------------------------------------------------------------------------------------------------------------------- */
    /* Case 69: SELECT INTO 스칼라 할당 → NO_DATA_FOUND / TOO_MANY_ROWS 래핑 */
    BEGIN
        SELECT CAST(CASE WHEN SUM(QUANTITY) != 0 THEN ROUND(SUM(AMOUNT) / SUM(QUANTITY), 0) ELSE 0 END AS NUMBER(20, 0))
          INTO V_CELL_UNIT_PRICE
          FROM GT_PRSCP_TMP_INVENTORY
         WHERE YYYYMM          = V_LAST_YYYYMM
           AND CELL_CONVERT_YN = 'N'
           AND OPERATION_GROUP = 'A'  /* CELL */
           AND AMOUNT > 0
           AND QUANTITY > 0;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_CELL_UNIT_PRICE := 0;
        WHEN TOO_MANY_ROWS THEN
            V_CELL_UNIT_PRICE := 0;
    END;

    UPDATE GT_PRSCP_TMP_INVENTORY
       SET UNIT_PRICE_LAST = V_CELL_UNIT_PRICE
     WHERE CELL_CONVERT_YN = 'N'
       AND OPERATION_GROUP = 'A'  /* CELL */
       AND UNIT_PRICE_LAST = 0;

    /* -------------------------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.6 조립(생산) 데이터 추출 - 최종 (셀환산전 - 0 채움)');
    /* -------------------------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_PRODUCTION_FINAL';

    INSERT INTO GT_PRSCP_TMP_PRODUCTION_FINAL (
        YYYYMM
       , ITEM_ID
       , CELL_CONVERT_YN
       , TARGET_CELL
       , CELL_CF
       , CELL_GROUP
       , OPERATION_GROUP
       , QTY
       , QTY_YIELD
       , BEFORE_PACK_QTY
       , AMT
    )
    WITH PRODUCTION AS (
        SELECT P.YYYYMM
              , P.ITEM_ID
              , P.CELL_GROUP
              , P.OPERATION_GROUP
              , P.TARGET_CELL
              , P.CELL_CF
              , SUM(QTY)            AS QTY
              , SUM(QTY_YIELD)      AS QTY_YIELD
              , SUM(BEFORE_PACK_QTY) AS BEFORE_PACK_QTY
          FROM GT_PRSCP_TMP_PRODUCTION P
         GROUP BY P.YYYYMM
                 , P.ITEM_ID
                 , P.CELL_GROUP
                 , P.OPERATION_GROUP
                 , P.TARGET_CELL
                 , P.CELL_CF
    )
    SELECT ML.YYYYMM
          , P.ITEM_ID
          , 'N' AS CELL_CONVERT_YN
          , MAX(P.TARGET_CELL)                                                                         AS TARGET_CELL    /* cell 환산 target cell item과 1:1관계이나.. */
          , MAX(P.CELL_CF)                                                                             AS CELL_CF        /* cell 환산계수 */
          , MAX(P.CELL_GROUP)                                                                          AS CELL_GROUP
          , MAX(P.OPERATION_GROUP)                                                                     AS OPERATION_GROUP
          , CAST(SUM(CASE WHEN ML.YYYYMM = P.YYYYMM THEN P.QTY            ELSE 0 END) AS NUMBER(30, 0)) AS QTY
          , CAST(SUM(CASE WHEN ML.YYYYMM = P.YYYYMM THEN P.QTY_YIELD      ELSE 0 END) AS NUMBER(30, 0)) AS QTY_YIELD
          , CAST(SUM(CASE WHEN ML.YYYYMM = P.YYYYMM THEN P.BEFORE_PACK_QTY ELSE 0 END) AS NUMBER(30, 0)) AS BEFORE_PACK_QTY
          , CAST(SUM(CASE WHEN ML.YYYYMM = P.YYYYMM THEN P.QTY
                                                         * NVL(I.UNIT_PRICE_LAST
                                                               , CASE WHEN P.OPERATION_GROUP = 'A'
                                                                      THEN V_CELL_UNIT_PRICE
                                                                      ELSE 0
                                                                 END)
                                                    ELSE 0 END) AS NUMBER(30, 0)) AS AMT
      FROM GT_PRSCP_TMP_MM_LIST ML
           INNER JOIN PRODUCTION P
                   ON 1 = 1
           LEFT JOIN GT_PRSCP_TMP_INVENTORY I  /* 재고 최종 단가 */
                  ON I.CELL_CONVERT_YN = 'N'
                 AND I.YYYYMM          = I.YYYYMM_LAST
                 AND I.ITEM_ID         = P.ITEM_ID
     WHERE 1 = 1
     GROUP BY ML.YYYYMM
             , P.ITEM_ID;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_PRODUCTION_FINAL'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* -------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 1.7 조립(생산) 데이터 추출 - 최종 (셀 환산 데이터 추가)');
    /* -------------------------------------------------------------------------- */
    INSERT INTO GT_PRSCP_TMP_PRODUCTION_FINAL (
        YYYYMM
       , ITEM_ID
       , CELL_CONVERT_YN
       , TARGET_CELL
       , CELL_CF
       , CELL_GROUP
       , OPERATION_GROUP
       , QTY
       , QTY_YIELD
       , BEFORE_PACK_QTY
       , AMT
    )
    SELECT P.YYYYMM
         , NVL(P.TARGET_CELL, P.ITEM_ID) AS ITEM_ID
         , 'Y' AS CELL_CONVERT_YN
         , '-' AS TARGET_CELL
         , CAST(NULL AS NUMBER) AS CELL_CF
         , MAX(P.CELL_GROUP) AS CELL_GROUP
         , '-' AS OPERATION_GROUP
         , CAST(SUM(P.QTY * P.CELL_CF) AS NUMBER(30, 0)) AS QTY
         , CAST(SUM(P.QTY_YIELD * P.CELL_CF) AS NUMBER(30, 0)) AS QTY_YIELD
         , CAST(SUM(P.BEFORE_PACK_QTY * P.CELL_CF) AS NUMBER(30, 0)) AS BEFORE_PACK_QTY
         , CAST(SUM(P.AMT) AS NUMBER(30, 0)) AS AMT
      FROM GT_PRSCP_TMP_PRODUCTION_FINAL P
     WHERE P.OPERATION_GROUP = 'A'
     GROUP BY P.YYYYMM
            , NVL(P.TARGET_CELL, P.ITEM_ID);

    /* ------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 2. FCST/RTF 데이터 추출 - 계획/실적');
    /* ------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_MKT_FCST_RTF';

    /* ------------------------------------------------------------------------------------------ */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 2.1 FCST/RTF 데이터 추출 - 계획');
    /* ------------------------------------------------------------------------------------------ */
    INSERT INTO GT_PRSCP_TMP_MKT_FCST_RTF (
        RP_DIV
       , UI_MEASURE
       , MEASURE
       , YYYYMM
       , ITEM_ID
       , OPERATION_GROUP
       , CELL_GROUP
       , TARGET_CELL
       , CELL_CF
       , PROJECT_CODE
       , DEPT_ID
       , QTY
    )
    SELECT 'P' AS RP_DIV
         , CASE WHEN MK.MEASURE = 'MKT_FCST' THEN 'FCST_QTY' ELSE 'RTF_QTY' END AS UI_MEASURE
         , MK.MEASURE AS MEASURE
         , SUBSTR(MK.YYYYMMDD, 1, 6) AS YYYYMM
         , MK.ITEM_ID
         , I.OPERATION_GROUP
         , I.NICKNAME_FOR_DIO AS CELL_GROUP
         , I.TARGET_CELL
         , I.CELL_CF
         , TO_CHAR(NULL) AS PROJECT_CODE
         , TO_CHAR(NULL) AS DEPT_ID
         , SUM(MK.QTY) AS QTY
      FROM DM_PLN_MKT_FCST_C MK
         , GT_PRSCP_TMP_TARGET_ITEMS I
     WHERE I.DIVISION_ID = MK.DIVISION_ID
       AND I.ITEM_ID = MK.ITEM_ID
       AND MK.DIVISION_ID = P_DIVISION_ID
       AND MK.VERSION_NO = V_DM_VERSION_NO
       AND MK.QTY > 0
       AND MK.MEASURE IN ('MKT_FCST', 'RTF_SYS_RP', 'AS_In_Plan')
     GROUP BY MK.MEASURE
            , MK.ITEM_ID
            , SUBSTR(MK.YYYYMMDD, 1, 6)
            , I.OPERATION_GROUP
            , I.NICKNAME_FOR_DIO
            , I.TARGET_CELL
            , I.CELL_CF;

    /* ------------------------------------------------------------------------------------------ */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 2.2 FCST/RTF 데이터 추출 - 실적');
    /* ------------------------------------------------------------------------------------------ */
    INSERT INTO GT_PRSCP_TMP_MKT_FCST_RTF (
        RP_DIV
       , UI_MEASURE
       , MEASURE
       , YYYYMM
       , ITEM_ID
       , OPERATION_GROUP
       , CELL_GROUP
       , TARGET_CELL
       , CELL_CF
       , PROJECT_CODE
       , DEPT_ID
       , QTY
    )
    WITH MEASURE_INFO AS (
        SELECT 'R' AS RP_DIV, 'FCST_QTY' AS UI_MEASURE, 'RTF_SYS_RP' AS MEASURE FROM DUAL  /* MKT FCST[R+P] */
        UNION ALL
        SELECT 'R' AS RP_DIV, 'RTF_QTY'  AS UI_MEASURE, 'RTF_SYS_RP' AS MEASURE FROM DUAL  /* RTF[R+P] */
        UNION ALL
        SELECT 'R' AS RP_DIV, 'RTF_QTY'  AS UI_MEASURE, 'AS_In_Plan' AS MEASURE FROM DUAL  /* AS In Plan[R+P] */
    )
    SELECT MI.RP_DIV
          , MI.UI_MEASURE
          , MI.MEASURE
          , SUBSTR(MK.YYYYMMDD, 1, 6) AS YYYYMM
          , MK.ITEM_ID
          , I.OPERATION_GROUP
          , I.NICKNAME_FOR_DIO        AS CELL_GROUP
          , I.TARGET_CELL
          , I.CELL_CF
          , MAX(MK.PROJECT_CODE)      AS PROJECT_CODE
          , MAX(SI.DEPT_ID)           AS DEPT_ID
          , SUM(QTY)                  AS QTY
      FROM DM_PLN_MKT_FCST_RESULT_C MK
         , GT_PRSCP_TMP_TARGET_ITEMS I
         , MEASURE_INFO MI
         , SCM_MST_SITE MS
         , SCM_MST_SITE_ITEM SI  /* 2023.01.27 조건 추가 (DMF0035_GET_MKT_FCST_WATERFALL 참조) */
     WHERE I.DIVISION_ID  = MK.DIVISION_ID
       AND I.ITEM_ID      = MK.ITEM_ID
       AND MI.MEASURE     = MK.MEASURE
       AND MS.DIVISION_ID = MK.DIVISION_ID
       AND MS.SCM_SITE_ID = MK.SCM_SITE_ID
       AND MS.SITE_TYPE   = 'SALES'
       AND SI.DIVISION_ID = MK.DIVISION_ID
       AND SI.SCM_SITE_ID = MK.SCM_SITE_ID
       AND SI.PROJECT_CODE = MK.PROJECT_CODE
       AND SI.ITEM_ID     = MK.ITEM_ID
       AND MK.DIVISION_ID = P_DIVISION_ID
       AND MK.VERSION_NO  = V_DM_VERSION_NO
       AND MK.QTY != 0
     GROUP BY MI.RP_DIV
             , MI.UI_MEASURE
             , MI.MEASURE
             , MK.ITEM_ID
             , I.OPERATION_GROUP
             , I.NICKNAME_FOR_DIO
             , SUBSTR(MK.YYYYMMDD, 1, 6)
             , I.TARGET_CELL
             , I.CELL_CF;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_MKT_FCST_RTF'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ---------------------------------------------------------------------------------------------------- */
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 2.3 FCST/RTF 데이터 추출 - Project 및 부서 정보');
    /* ---------------------------------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_PROJECT_DEPT_INFO';

    INSERT INTO GT_PRSCP_TMP_PROJECT_DEPT_INFO (
        CELL_GROUP
       , PROJECT_CODE
       , DEPT_ID
    )
    WITH ITEM_PROJECT_DEPT_INFO AS (
        SELECT ITEM_ID
              , CELL_GROUP
              , PROJECT_CODE
              , DEPT_ID
              , ROW_NUMBER() OVER (PARTITION BY ITEM_ID
                                      ORDER BY RP_DIV       DESC  /* 실적 MKT_FCST 정보 우선 */
                                              , YYYYMM       DESC
                                              , QTY          DESC
                                              , PROJECT_CODE DESC) AS RN
          FROM GT_PRSCP_TMP_MKT_FCST_RTF
    )
    SELECT DISTINCT
           CELL_GROUP
          /* ,ITEM_ID */
          , MAX(PROJECT_CODE) OVER (PARTITION BY CELL_GROUP) AS PROJECT_CODE
          , MAX(DEPT_ID)      OVER (PARTITION BY CELL_GROUP) AS DEPT_ID
      FROM ITEM_PROJECT_DEPT_INFO
     WHERE RN = 1;


    DBMS_STATS.GATHER_TABLE_STATS(
        OWNNAME          => 'SCM_MGR'
      , TABNAME          => 'GT_PRSCP_TMP_PROJECT_DEPT_INFO'
      , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
      , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
      , NO_INVALIDATE    => FALSE
    );

    /* ------------------------------------------------------------------------------------------------------------- */
        /* ------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 2.4 FCST/RTF 데이터 추출 최종 - 셀 환산 전  (0채움) ');
        /* ------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_MKT_FCST_RTF_FINAL';

        INSERT INTO GT_PRSCP_TMP_MKT_FCST_RTF_FINAL (
             YYYYMM
            , FIRST_YMD
            , ITEM_ID
            , OPERATION_GROUP
            , TARGET_CELL
            , CELL_CF
            , MEASURE
            , CELL_CONVERT_YN
            , QTY
            , AMT
            , DEPT_ID
            , PROJECT_CODE
        )
        WITH MKT_FCST_RTF AS (
            SELECT MR.YYYYMM
                  , MR.ITEM_ID
                  , MR.OPERATION_GROUP
                  , MR.TARGET_CELL
                  , MR.CELL_CF
                  , MR.CELL_GROUP
                  , MR.UI_MEASURE      AS MEASURE
                  , SUM(MR.QTY)        AS QTY
                  , MAX(MAX(MR.PROJECT_CODE)) OVER (PARTITION BY NVL(MR.CELL_GROUP, MR.ITEM_ID)) AS PROJECT_CODE
                  , MAX(MAX(MR.DEPT_ID))      OVER (PARTITION BY NVL(MR.CELL_GROUP, MR.ITEM_ID)) AS DEPT_ID
              FROM GT_PRSCP_TMP_MKT_FCST_RTF MR
             GROUP BY MR.YYYYMM
                     , MR.ITEM_ID
                     , MR.OPERATION_GROUP
                     , MR.CELL_GROUP
                     , MR.TARGET_CELL
                     , MR.CELL_CF
                     , MR.UI_MEASURE
        )
        SELECT ML.YYYYMM
              , ML.YYYYMM||'01'                                    AS FIRST_YMD
              , R.ITEM_ID
              , R.OPERATION_GROUP
              , R.TARGET_CELL
              , R.CELL_CF
              , R.MEASURE
              , 'N'                                                   AS CELL_CONVERT_YN
              , CAST(SUM(CASE WHEN ML.YYYYMM = R.YYYYMM THEN R.QTY ELSE 0 END) AS NUMBER(30, 0))   AS QTY
              , CAST(SUM(CASE WHEN ML.YYYYMM = R.YYYYMM
                             THEN R.QTY * NVL(I.UNIT_PRICE_LAST
                                            , CASE WHEN R.OPERATION_GROUP = 'A'
                                                   THEN V_CELL_UNIT_PRICE
                                                   ELSE 0
                                               END)
                             ELSE 0 END) AS NUMBER(30, 0))            AS AMT
              , MAX(R.DEPT_ID)                                        AS DEPT_ID
              , MAX(R.PROJECT_CODE)                                   AS PROJECT_CODE
          FROM GT_PRSCP_TMP_MM_LIST ML
               INNER JOIN MKT_FCST_RTF R
                       ON 1 = 1
               LEFT  JOIN GT_PRSCP_TMP_INVENTORY I /* 재고 최종 단가 */
                       ON I.CELL_CONVERT_YN = 'N'
                      AND I.YYYYMM          = I.YYYYMM_LAST
                      AND I.ITEM_ID         = R.ITEM_ID
         WHERE 1 = 1
         GROUP BY ML.YYYYMM
                 , R.ITEM_ID
                 , R.OPERATION_GROUP
                 , R.TARGET_CELL
                 , R.CELL_CF
                 , R.MEASURE;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_MKT_FCST_RTF_FINAL'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* ------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 2.5 FCST/RTF 데이터 추출 최종 - 셀 환산 데이터 추가  ');
        /* ------------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRSCP_TMP_MKT_FCST_RTF_FINAL (
             YYYYMM
            , FIRST_YMD
            , ITEM_ID
            , OPERATION_GROUP
            , TARGET_CELL
            , CELL_CF
            , MEASURE
            , CELL_CONVERT_YN
            , QTY
            , AMT
            , DEPT_ID
            , PROJECT_CODE
        )
        SELECT R.YYYYMM
              , R.FIRST_YMD
              , NVL(R.TARGET_CELL, R.ITEM_ID)                        AS ITEM_ID
              , '-'                                                   AS OPERATION_GROUP
              , '-'                                                   AS TARGET_CELL
              , NULL                                                  AS CELL_CF
              , R.MEASURE
              , 'Y'                                                   AS CELL_CONVERT_YN
              , CAST(SUM(R.QTY   * R.CELL_CF) AS NUMBER(30, 0))       AS QTY
              , CAST(SUM(R.AMT)               AS NUMBER(30, 0))        AS AMT
              , MAX(DEPT_ID)                                          AS DEPT_ID
              , MAX(PROJECT_CODE)                                     AS PROJECT_CODE
          FROM GT_PRSCP_TMP_MKT_FCST_RTF_FINAL R
         WHERE 1 = 1
         GROUP BY R.YYYYMM
                 , R.FIRST_YMD
                 , NVL(R.TARGET_CELL, R.ITEM_ID)
                 , R.MEASURE;
        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_MKT_FCST_RTF_FINAL'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE);

        /* ------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 3 재고 데이터 추출 - 미래구간');
        /* 당월말 재고 = 전월말 재고 + 당월 Production(수율적용) - RTF - Pack생산에 투입된 Cell수량 */
        /* ------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 3.1 재고 데이터 추출 - 미래구간(Production 정보) ');
        /* ------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_PRODUCTION_FOR_INVENTORY';

        INSERT INTO GT_PRSCP_TMP_PRODUCTION_FOR_INVENTORY (
             YYYYMM
            , ITEM_ID
            , OPERATION_GROUP
            , CELL_CONVERT_YN
            , TARGET_CELL
            , CELL_CF
            , QTY
            , QTY_YIELD
            , ACC_QTY
            , ACC_QTY_YIELD
        )
        SELECT P.YYYYMM
              , P.ITEM_ID
              , P.OPERATION_GROUP
              , P.CELL_CONVERT_YN
              , P.TARGET_CELL
              , P.CELL_CF
              , P.QTY
              , P.QTY_YIELD
              , SUM(AP.QTY)  AS ACC_QTY
              , SUM(AP.QTY_YIELD)  AS ACC_QTY_YIELD
          FROM GT_PRSCP_TMP_PRODUCTION_FINAL P
               LEFT JOIN GT_PRSCP_TMP_PRODUCTION_FINAL AP
                      ON AP.ITEM_ID         = P.ITEM_ID
                     AND AP.CELL_CONVERT_YN = P.CELL_CONVERT_YN
                     AND AP.YYYYMM   BETWEEN V_PLAN_START_YYYYMM
                                         AND P.YYYYMM
         WHERE 1 = 1
           AND P.YYYYMM          >= V_PLAN_START_YYYYMM
           AND P.CELL_CONVERT_YN  = 'N' /* Cell  환산전 */
         GROUP BY P.YYYYMM
                 , P.ITEM_ID
                 , P.OPERATION_GROUP
                 , P.CELL_CONVERT_YN
                 , P.TARGET_CELL
                 , P.CELL_CF
                 , P.QTY
                 , P.QTY_YIELD;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_PRODUCTION_FOR_INVENTORY'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* -------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 3.2 재고 데이터 추출 - 미래구간(RTF 정보) ');
        /* -------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_RTF_FOR_INVENTORY';

        INSERT INTO GT_PRSCP_TMP_RTF_FOR_INVENTORY (
             YYYYMM
            , ITEM_ID
            , OPERATION_GROUP
            , CELL_CONVERT_YN
            , TARGET_CELL
            , CELL_CF
            , QTY
            , ACC_QTY
        )
        SELECT R.YYYYMM
              , R.ITEM_ID
              , R.OPERATION_GROUP
              , R.CELL_CONVERT_YN
              , R.TARGET_CELL
              , R.CELL_CF
              , R.QTY
              , SUM(AR.QTY) AS ACC_QTY
          FROM GT_PRSCP_TMP_MKT_FCST_RTF_FINAL R
               LEFT JOIN GT_PRSCP_TMP_MKT_FCST_RTF_FINAL AR
                      ON AR.ITEM_ID         = R.ITEM_ID
                     AND AR.CELL_CONVERT_YN = R.CELL_CONVERT_YN
                     AND AR.MEASURE         = R.MEASURE
                     AND AR.YYYYMM   BETWEEN V_PLAN_START_YYYYMM
                                         AND R.YYYYMM
         WHERE 1 = 1
           AND R.YYYYMM          >= V_PLAN_START_YYYYMM
           AND R.MEASURE           = 'RTF_QTY'
           AND R.CELL_CONVERT_YN  = 'N' /* Cell  환산전 */
         GROUP BY R.YYYYMM
                 , R.ITEM_ID
                 , R.OPERATION_GROUP
                 , R.CELL_CONVERT_YN
                 , R.TARGET_CELL
                 , R.CELL_CF
                 , R.QTY;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_RTF_FOR_INVENTORY'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* ------------------------------------------------------------------------------------------------------------------------------ */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 3.3 재고 데이터 추출 - 당월 포함 미래구간 (Pack 생산에 투입될 Cell 수량 정보  )');
        /* ------------------------------------------------------------------------------------------------------------------------------ */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_CELL_QTY_USED_IN_PACK';

        INSERT INTO GT_PRSCP_TMP_CELL_QTY_USED_IN_PACK (
             YYYYMM
            , ITEM_ID
            , CELL_QTY_IN_PACK
            , ACC_CELL_QTY_IN_PACK
        )
        /* 미래 구간 Cell 재고 계산시 Pack 만드는데 들어가 수량을 제외하기 위함. */
        WITH CELL_QTY_USED_IN_PACK AS (
            SELECT YYYYMM
                  , TARGET_CELL                    AS ITEM_ID
                  , SUM(CELL_CF * BEFORE_PACK_QTY) AS CELL_QTY_IN_PACK
              FROM GT_PRSCP_TMP_PRODUCTION_FINAL
             WHERE OPERATION_GROUP = 'P'
               AND CELL_CONVERT_YN = 'N'
               AND YYYYMM >= V_PLAN_START_YYYYMM
             GROUP BY YYYYMM
                     , TARGET_CELL
        )
        SELECT R.YYYYMM
              , R.ITEM_ID
              , R.CELL_QTY_IN_PACK
              , SUM(AR.CELL_QTY_IN_PACK) AS ACC_CELL_QTY_IN_PACK
          FROM  CELL_QTY_USED_IN_PACK R
                LEFT JOIN CELL_QTY_USED_IN_PACK AR
                       ON AR.ITEM_ID = R.ITEM_ID
                      AND AR.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                        AND R.YYYYMM
         GROUP BY R.YYYYMM
                 , R.ITEM_ID
                 , R.CELL_QTY_IN_PACK;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_CELL_QTY_USED_IN_PACK'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* ------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 3.4 재고 데이터 추출 - 미래구간(환산전) ');
        /* ------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRSCP_TMP_INVENTORY (
             YYYYMM
            , ITEM_ID
            , OPERATION_GROUP
            , CELL_CONVERT_YN
            , TARGET_CELL
            , CELL_CF
            , UNIT_PRICE
            , QUANTITY
            , AMOUNT
            , YYYYMM_LAST
            , UNIT_PRICE_LAST
        )
        WITH SRC_FOR_FUTURE_INVENTORY AS (
            /* 기초재고 */
            SELECT ML.YYYYMM
                  , I.ITEM_ID
                  , I.OPERATION_GROUP
                  , I.CELL_CONVERT_YN
                  , I.TARGET_CELL
                  , I.CELL_CF
                  , I.QUANTITY      AS INVENTORY_QTY
                  , I.AMOUNT        AS INVENTORY_AMOUNT
                  , I.UNIT_PRICE_LAST
                  , 0               AS PROD_QTY
                  , 0               AS PROD_QTY_YIELD
                  , 0               AS PROD_ACC_QTY
                  , 0               AS PROD_ACC_QTY_YIELD
                  , 0               AS RTF_QTY
                  , 0               AS RTF_ACC_QTY
                  , I.YYYYMM_LAST
              FROM GT_PRSCP_TMP_INVENTORY I
                 , GT_PRSCP_TMP_MM_LIST ML
             WHERE 1 = 1
               AND I.YYYYMM   =  V_LAST_YYYYMM
               AND ML.YYYYMM >=  V_PLAN_START_YYYYMM
            UNION ALL
            /* 생산 */
            SELECT P.YYYYMM
                  , P.ITEM_ID
                  , P.OPERATION_GROUP
                  , P.CELL_CONVERT_YN
                  , P.TARGET_CELL
                  , P.CELL_CF
                  , 0               AS INVENTORY_QTY
                  , 0               AS INVENTORY_AMOUNT
                  , 0               AS UNIT_PRICE_LAST
                  , P.QTY           AS PROD_QTY
                  , P.QTY_YIELD     AS PROD_QTY_YIELD
                  , P.ACC_QTY       AS PROD_ACC_QTY
                  , P.ACC_QTY_YIELD AS PROD_ACC_QTY_YIELD
                  , 0               AS RTF_QTY
                  , 0               AS RTF_ACC_QTY
                  , NULL            AS YYYYMM_LAST
              FROM GT_PRSCP_TMP_PRODUCTION_FOR_INVENTORY P
            UNION ALL
            /* 출하(RTF) */
            SELECT R.YYYYMM
                  , R.ITEM_ID
                  , R.OPERATION_GROUP
                  , R.CELL_CONVERT_YN
                  , R.TARGET_CELL
                  , R.CELL_CF
                  , 0               AS INVENTORY_QTY
                  , 0               AS INVENTORY_AMOUNT
                  , 0               AS UNIT_PRICE_LAST
                  , 0               AS PROD_QTY
                  , 0               AS PROD_QTY_YIELD
                  , 0               AS PROD_ACC_QTY
                  , 0               AS PROD_ACC_QTY_YIELD
                  , R.QTY           AS RTF_QTY
                  , R.ACC_QTY       AS RTF_ACC_QTY
                  , NULL            AS YYYYMM_LAST
              FROM GT_PRSCP_TMP_RTF_FOR_INVENTORY R
        )
        SELECT SD.YYYYMM
              , SD.ITEM_ID
              , SD.OPERATION_GROUP
              , SD.CELL_CONVERT_YN
              , MAX(TARGET_CELL)                  AS TARGET_CELL
              , NVL(MAX(CELL_CF), 1)              AS CELL_CF
              , CASE WHEN MAX(SD.UNIT_PRICE_LAST) = 0 AND SD.OPERATION_GROUP = 'A'
                    THEN V_CELL_UNIT_PRICE
                    ELSE MAX(SD.UNIT_PRICE_LAST)
               END                               AS UNIT_PRICE
              , SUM(SD.INVENTORY_QTY) + SUM(SD.PROD_ACC_QTY_YIELD) - SUM(SD.RTF_ACC_QTY) - NVL(CQ.ACC_CELL_QTY_IN_PACK, 0)  AS MM_INVENTORY_QTY
              , (SUM(SD.INVENTORY_QTY) + SUM(SD.PROD_ACC_QTY_YIELD) - SUM(SD.RTF_ACC_QTY) - NVL(CQ.ACC_CELL_QTY_IN_PACK, 0))
               * CASE WHEN MAX(SD.UNIT_PRICE_LAST) = 0 AND SD.OPERATION_GROUP = 'A'
                      THEN V_CELL_UNIT_PRICE
                      ELSE MAX(SD.UNIT_PRICE_LAST)
                 END                             AS MM_INVENTORY_AMOUNT
              /* 2023.03.29 ,MAX(SD.YYYYMM_LAST)            AS YYYYMM_LAST */
              , CASE WHEN MAX(SD.UNIT_PRICE_LAST) = 0 AND SD.OPERATION_GROUP = 'A'
                    THEN
                        MIN(
                            CASE WHEN SUM(SD.INVENTORY_QTY) + SUM(SD.PROD_ACC_QTY_YIELD) - SUM(SD.RTF_ACC_QTY) - NVL(CQ.ACC_CELL_QTY_IN_PACK, 0) != 0
                                 THEN SD.YYYYMM
                                 ELSE NULL
                            END
                           ) OVER (PARTITION BY SD.ITEM_ID
                                               , SD.OPERATION_GROUP
                                               , SD.CELL_CONVERT_YN)
                    ELSE MAX(SD.YYYYMM_LAST)
               END                               AS YYYYMM_LAST
              , CASE WHEN MAX(SD.UNIT_PRICE_LAST) = 0 AND SD.OPERATION_GROUP = 'A'
                    THEN V_CELL_UNIT_PRICE
                    ELSE MAX(SD.UNIT_PRICE_LAST)
               END                               AS UNIT_PRICE_LAST
          FROM SRC_FOR_FUTURE_INVENTORY SD
               LEFT JOIN GT_PRSCP_TMP_CELL_QTY_USED_IN_PACK CQ  /* - 2023/01/09 Cell 재고에서 Pack생산에 소요된 Cell 수량 제외 */
                      ON CQ.YYYYMM           = SD.YYYYMM
                     AND CQ.ITEM_ID          = SD.ITEM_ID
                     AND SD.OPERATION_GROUP  = 'A'
                     AND SD.CELL_CONVERT_YN  = 'N'
         GROUP BY
                SD.YYYYMM
               , SD.ITEM_ID
               , SD.OPERATION_GROUP
               , SD.CELL_CONVERT_YN
               , CQ.ACC_CELL_QTY_IN_PACK;

        /* ------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 3.5  재고 데이터 추출 - 과거/미래 셀 환산 데이터 추가 ');
        /* ------------------------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRSCP_TMP_INVENTORY (
             YYYYMM
            , ITEM_ID
            , OPERATION_GROUP
            , CELL_CONVERT_YN
            , TARGET_CELL
            , CELL_CF
            , QUANTITY
            , AMOUNT
            , UNIT_PRICE
            , YYYYMM_LAST
            , UNIT_PRICE_LAST
        )
        SELECT I.YYYYMM
              , NVL(I.TARGET_CELL, I.ITEM_ID)             AS ITEM_ID
              , '-'                                        AS OPERATION_GROUP
              , 'Y'                                        AS CELL_CONVERT_YN
              , '-'                                        AS TARGET_CELL
              , NULL                                       AS CELL_CF
              , SUM(I.QUANTITY  * I.CELL_CF)               AS QUANTITY
              , SUM(I.AMOUNT)                              AS AMOUNT
              , CASE WHEN SUM(I.QUANTITY  * I.CELL_CF) != 0
                          AND
                          SUM(I.AMOUNT)  != 0
                    THEN ROUND(SUM(I.AMOUNT) / SUM(I.QUANTITY * CELL_CF), 0)
                    ELSE 0
               END                                       AS UNIT_PRICE
              , MAX(YYYYMM_LAST)                           AS YYYYMM_LAST
              , CASE WHEN SUM(SUM(CASE WHEN I.YYYYMM = I.YYYYMM_LAST THEN I.QUANTITY  * I.CELL_CF ELSE 0 END)) OVER (PARTITION BY NVL(I.TARGET_CELL, I.ITEM_ID)) != 0
                          THEN ROUND(SUM(SUM(CASE WHEN I.YYYYMM = I.YYYYMM_LAST THEN I.AMOUNT                ELSE 0 END)) OVER (PARTITION BY NVL(I.TARGET_CELL, I.ITEM_ID)) /
                                     SUM(SUM(CASE WHEN I.YYYYMM = I.YYYYMM_LAST THEN I.QUANTITY  * I.CELL_CF ELSE 0 END)) OVER (PARTITION BY NVL(I.TARGET_CELL, I.ITEM_ID))
                                     , 0)
                          ELSE NULL
               END                                       AS UNIT_PRICE_LAST
          FROM GT_PRSCP_TMP_INVENTORY I
         WHERE 1 = 1
         GROUP BY I.YYYYMM
                 , NVL(I.TARGET_CELL, I.ITEM_ID);

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_INVENTORY'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 3.6 재고 데이터 추출 - Final (미래구간만 예상 재고 존재하고 과거 구간 없는 경우 과거구간 0 채우기) ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_INVENTORY_FINAL';

        INSERT INTO GT_PRSCP_TMP_INVENTORY_FINAL (
             YYYYMM
            , ITEM_ID
            , OPERATION_GROUP
            , CELL_CONVERT_YN
            , TARGET_CELL
            , CELL_CF
            , QUANTITY
            , AMOUNT
            , UNIT_PRICE
            , YYYYMM_LAST
            , UNIT_PRICE_LAST
        )
        SELECT ML.YYYYMM
              , I.ITEM_ID
              , I.OPERATION_GROUP
              , I.CELL_CONVERT_YN
              , MAX(I.TARGET_CELL)                                                                                               AS TARGET_CELL
              , MAX(I.CELL_CF)                                                                                                   AS CELL_CF
              , CAST(NVL(MAX(CASE WHEN ML.YYYYMM = I.YYYYMM THEN I.QUANTITY    ELSE NULL END), 0) AS NUMBER(30, 0))              AS QUANTITY
              , CAST(NVL(MAX(CASE WHEN ML.YYYYMM = I.YYYYMM THEN I.AMOUNT      ELSE NULL END), 0) AS NUMBER(30, 0))              AS AMOUNT
              , CAST(NVL(MAX(CASE WHEN ML.YYYYMM = I.YYYYMM THEN I.UNIT_PRICE  ELSE NULL END), 0) AS NUMBER(30, 0))              AS UNIT_PRICE
              , MAX(I.YYYYMM_LAST)                                                                                               AS YYYYMM_LAST
              , CASE WHEN NVL(MAX(I.UNIT_PRICE_LAST), 0) = 0 AND I.OPERATION_GROUP = 'A'
                    THEN V_CELL_UNIT_PRICE
                    ELSE CAST(NVL(MAX(I.UNIT_PRICE_LAST), 0) AS NUMBER(30, 0))
               END                                                                                                             AS UNIT_PRICE_LAST
          FROM GT_PRSCP_TMP_MM_LIST ML
             , GT_PRSCP_TMP_INVENTORY I
         WHERE 1 = 1
         GROUP BY ML.YYYYMM
                 , I.ITEM_ID
                 , I.OPERATION_GROUP
                 , I.CELL_CONVERT_YN;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_INVENTORY_FINAL'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 4. 5개월 전진법 적용 DIO 산출을 위한 데이터');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 4.1 5개월 전진법 적용 DIO 산출을 위한 데이터 - 월별 누적 일수 정보 ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_MM_DAYS_INFO';

        INSERT INTO GT_PRSCP_TMP_MM_DAYS_INFO (
             YYYYMM
            , FIRST_YMD
            , LAST_YMD
            , MM_DAYS
            , FROM_MONTH
            , TO_MONTH
            , DAYS_NEXT_1
            , DAYS_NEXT_2
            , DAYS_NEXT_3
            , DAYS_NEXT_4
            , DAYS_NEXT_5
            , ACC_DAYS_1
            , ACC_DAYS_2
            , ACC_DAYS_3
            , ACC_DAYS_4
            , ACC_DAYS_5
        )
        SELECT ML.YYYYMM
              , ML.FIRST_YMD
              , ML.LAST_YMD
              , ML.MM_DAYS
              , TO_CHAR(ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 1), 'YYYYMM') AS FROM_MONTH
              , TO_CHAR(ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 5), 'YYYYMM') AS TO_MONTH
              , MAX(CASE WHEN ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 1) = TO_DATE(AM.FIRST_YMD, 'YYYYMMDD') THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_1
              , MAX(CASE WHEN ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 2) = TO_DATE(AM.FIRST_YMD, 'YYYYMMDD') THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_2
              , MAX(CASE WHEN ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 3) = TO_DATE(AM.FIRST_YMD, 'YYYYMMDD') THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_3
              , MAX(CASE WHEN ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 4) = TO_DATE(AM.FIRST_YMD, 'YYYYMMDD') THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_4
              , MAX(CASE WHEN ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 5) = TO_DATE(AM.FIRST_YMD, 'YYYYMMDD') THEN AM.MM_DAYS ELSE 0 END) AS DAYS_NEXT_5
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.FIRST_YMD, 'YYYYMMDD'), TO_DATE(ML.FIRST_YMD, 'YYYYMMDD')) <= 1 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_1
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.FIRST_YMD, 'YYYYMMDD'), TO_DATE(ML.FIRST_YMD, 'YYYYMMDD')) <= 2 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_2
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.FIRST_YMD, 'YYYYMMDD'), TO_DATE(ML.FIRST_YMD, 'YYYYMMDD')) <= 3 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_3
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.FIRST_YMD, 'YYYYMMDD'), TO_DATE(ML.FIRST_YMD, 'YYYYMMDD')) <= 4 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_4
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AM.FIRST_YMD, 'YYYYMMDD'), TO_DATE(ML.FIRST_YMD, 'YYYYMMDD')) <= 5 THEN AM.MM_DAYS ELSE 0 END) AS ACC_DAYS_5
          FROM GT_PRSCP_TMP_MM_LIST ML
               LEFT JOIN GT_PRSCP_TMP_MM_LIST AM
                      ON AM.YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 1), 'YYYYMM')
                                       AND TO_CHAR(ADD_MONTHS(TO_DATE(ML.FIRST_YMD, 'YYYYMMDD'), 5), 'YYYYMM')
         WHERE 1 = 1
         GROUP BY ML.YYYYMM
                 , ML.FIRST_YMD
                 , ML.LAST_YMD
                 , ML.MM_DAYS;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_MM_DAYS_INFO'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 4.2 5개월 전진법 적용 DIO 산출을 위한 데이터 - 월별 누적 RTF정보 ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_RTF_FOR_DIO';

        INSERT INTO GT_PRSCP_TMP_RTF_FOR_DIO (
             YYYYMM
            , ITEM_ID
            , CELL_CONVERT_YN
            , FIRST_YMD
            , RTF
            , FROM_MONTH
            , TO_MONTH
            , RTF_NEXT_1
            , RTF_NEXT_2
            , RTF_NEXT_3
            , RTF_NEXT_4
            , RTF_NEXT_5
            , ACC_RTF_1
            , ACC_RTF_2
            , ACC_RTF_3
            , ACC_RTF_4
            , ACC_RTF_5
        )
        SELECT RI.YYYYMM
              , RI.ITEM_ID
              , RI.CELL_CONVERT_YN
              , RI.FIRST_YMD
              , RI.QTY                                                                    AS RTF
              , TO_CHAR(ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 1), 'YYYYMM')     AS FROM_MONTH
              , TO_CHAR(ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 5), 'YYYYMM')     AS TO_MONTH

              /* RTF 음수가 존재함.. MAX에서 0이 아닌 음수값을 가져오기 위해 ELSE NULL 처리 후 최종 결과 ISNULL처리함. */
              , NVL(MAX(CASE WHEN ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 1) = TO_DATE(AR.FIRST_YMD, 'YYYYMMDD') THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_1
              , NVL(MAX(CASE WHEN ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 2) = TO_DATE(AR.FIRST_YMD, 'YYYYMMDD') THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_2
              , NVL(MAX(CASE WHEN ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 3) = TO_DATE(AR.FIRST_YMD, 'YYYYMMDD') THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_3
              , NVL(MAX(CASE WHEN ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 4) = TO_DATE(AR.FIRST_YMD, 'YYYYMMDD') THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_4
              , NVL(MAX(CASE WHEN ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 5) = TO_DATE(AR.FIRST_YMD, 'YYYYMMDD') THEN AR.QTY ELSE NULL END), 0) AS RTF_NEXT_5

              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.FIRST_YMD, 'YYYYMMDD'), TO_DATE(RI.FIRST_YMD, 'YYYYMMDD')) <= 1 THEN AR.QTY ELSE 0 END) AS ACC_RTF_1
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.FIRST_YMD, 'YYYYMMDD'), TO_DATE(RI.FIRST_YMD, 'YYYYMMDD')) <= 2 THEN AR.QTY ELSE 0 END) AS ACC_RTF_2
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.FIRST_YMD, 'YYYYMMDD'), TO_DATE(RI.FIRST_YMD, 'YYYYMMDD')) <= 3 THEN AR.QTY ELSE 0 END) AS ACC_RTF_3
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.FIRST_YMD, 'YYYYMMDD'), TO_DATE(RI.FIRST_YMD, 'YYYYMMDD')) <= 4 THEN AR.QTY ELSE 0 END) AS ACC_RTF_4
              , SUM(CASE WHEN MONTHS_BETWEEN(TO_DATE(AR.FIRST_YMD, 'YYYYMMDD'), TO_DATE(RI.FIRST_YMD, 'YYYYMMDD')) <= 5 THEN AR.QTY ELSE 0 END) AS ACC_RTF_5
          FROM GT_PRSCP_TMP_MKT_FCST_RTF_FINAL RI
               LEFT JOIN GT_PRSCP_TMP_MKT_FCST_RTF_FINAL AR
                      ON AR.MEASURE         = RI.MEASURE
                     AND AR.ITEM_ID         = RI.ITEM_ID
                     AND AR.CELL_CONVERT_YN = RI.CELL_CONVERT_YN
                     AND AR.YYYYMM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 1), 'YYYYMM')
                                       AND TO_CHAR(ADD_MONTHS(TO_DATE(RI.FIRST_YMD, 'YYYYMMDD'), 5), 'YYYYMM')
         WHERE 1 = 1
           AND RI.MEASURE = 'RTF_QTY'
         GROUP BY RI.YYYYMM
                 , RI.ITEM_ID
                 , RI.CELL_CONVERT_YN
                 , RI.FIRST_YMD
                 , RI.QTY;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_RTF_FOR_DIO'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 5. 재고수량에 대한 DIO 산출  ');
        /* --------------------------------------------------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_INVENTORY_DIO';

        INSERT INTO GT_PRSCP_TMP_INVENTORY_DIO (
             YYYYMM
            , ITEM_ID
            , CELL_CONVERT_YN
            , QUANTITY
            , AMOUNT
            , UNIT_PRICE
            , UNIT_PRICE_LAST
            , YYYYMM_LAST
            , DIO
            , TARGET_CELL
            , CELL_CF
        )
        SELECT I.YYYYMM
              , I.ITEM_ID
              , I.CELL_CONVERT_YN
              , CAST(I.QUANTITY       AS NUMBER(30, 10)) AS QUANTITY
              , CAST(I.AMOUNT         AS NUMBER(30, 10)) AS AMOUNT
              , CAST(I.UNIT_PRICE     AS NUMBER(30, 10)) AS UNIT_PRICE
              , CAST(I.UNIT_PRICE_LAST AS NUMBER(30, 10)) AS UNIT_PRICE_LAST
              , I.YYYYMM_LAST
              , CASE WHEN I.QUANTITY <= 0 THEN
                         0
                    WHEN R.ITEM_ID IS NULL THEN
                         180
                    WHEN I.QUANTITY - R.RTF_NEXT_1 < 0 THEN
                         NVL(CAST(I.QUANTITY AS NUMBER(20, 10))                    / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0) * D.DAYS_NEXT_1
                    WHEN I.QUANTITY - R.RTF_NEXT_1 = 0 THEN
                         D.ACC_DAYS_1
                    WHEN I.QUANTITY - R.ACC_RTF_2 < 0  THEN
                         NVL(CAST((I.QUANTITY - R.ACC_RTF_1) AS NUMBER(20, 10))    / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                    WHEN I.QUANTITY - R.ACC_RTF_2 = 0  THEN
                         D.ACC_DAYS_2
                    WHEN I.QUANTITY - R.ACC_RTF_3 < 0  THEN
                         NVL(CAST((I.QUANTITY - R.ACC_RTF_2) AS NUMBER(20, 10))    / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                    WHEN I.QUANTITY - R.ACC_RTF_3 = 0  THEN
                         D.ACC_DAYS_3
                    WHEN I.QUANTITY - R.ACC_RTF_4 < 0  THEN
                         NVL(CAST((I.QUANTITY - R.ACC_RTF_3) AS NUMBER(20, 10))    / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                    WHEN I.QUANTITY - R.ACC_RTF_4 = 0  THEN
                         D.ACC_DAYS_4
                    WHEN I.QUANTITY - R.ACC_RTF_5 < 0  THEN
                         NVL(CAST((I.QUANTITY - R.ACC_RTF_4) AS NUMBER(20, 10))    / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                    WHEN I.QUANTITY - R.ACC_RTF_5 = 0  THEN
                         D.ACC_DAYS_5
                    ELSE 180
               END                                    AS DIO
              , I.TARGET_CELL
              , I.CELL_CF
          FROM GT_PRSCP_TMP_INVENTORY_FINAL I /* 재고 */
             , GT_PRSCP_TMP_MM_DAYS_INFO D
             , GT_PRSCP_TMP_RTF_FOR_DIO R
         WHERE D.YYYYMM              = I.YYYYMM
           AND R.YYYYMM(+)           = I.YYYYMM
           AND R.ITEM_ID(+)          = I.ITEM_ID
           AND R.CELL_CONVERT_YN(+)  = I.CELL_CONVERT_YN;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_INVENTORY_DIO'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* ------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 6. 기준 DIO/수량 데이터 추출  ');
        /* ------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 6.1 기준 DIO/수량 데이터 추출 - 월별 참조 대상 DIO Report 버전 정보 ');
        /* ------------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_DIO_VERSION';

        INSERT INTO GT_PRSCP_TMP_DIO_VERSION (
             YYYYMM
            , DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , SEQ
            , VER
            , RN
        )
        WITH DIO_VERSION_LIST AS (
            SELECT ML.YYYYMM
                  , DV.DIVISION_ID
                  , DV.PLAN_START_YYYYMMDD
                  , DV.PLAN_TYPE
                  , DV.SEQ
                  , DV.VER
                  , ROW_NUMBER() OVER (PARTITION BY ML.YYYYMM
                                          ORDER BY DV.PLAN_START_YYYYMMDD DESC
                                                  , DV.SEQ DESC
                                                  , DV.VER DESC
                                                  ) AS RN
              FROM GT_PRSCP_TMP_MM_LIST ML
                 , SCP_ANL_DIO_REPORT_VERSION DV
             WHERE DV.DIVISION_ID(+)          =  P_DIVISION_ID /* '81' */
               AND DV.PLAN_START_YYYYMMDD(+) <= ML.LAST_YMD
               AND DV.VER_STATUS(+)           = 'C'
               AND DV.CREATION_DATE(+) >= TO_DATE('20220621', 'YYYYMMDD') /* 6/20일 운영반영전 plant/nick_name 관점 -> 이후 nick_name 관점으로 변경된 이후 생성된 보고서만 참조. */
        )
        SELECT YYYYMM
              , DIVISION_ID
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , VER
              , RN
          FROM DIO_VERSION_LIST
         WHERE 1 = 1
           AND RN = 1;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_DIO_VERSION'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* ------------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' 6.2 기준 DIO/수량 데이터 추출 - DIO Report 데이터 추출');
        /* ------------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_DIO_REPORT';

        INSERT INTO GT_PRSCP_TMP_DIO_REPORT (
             YYYYMM
            , DIVISION_ID
            , PLAN_START_YYYYMMDD
            , PLAN_TYPE
            , SEQ
            , VER
            , NICK_NAME
            , PLANT_ID
            , ITEM_ID
            , CELL_AGING_LT
            , CELL_EOL_SHIPPING_LOT
            , PACK_INCOMMING
            , PACK_OPERATION_LT
            , SAFETY_STOCK_CELL
            , SAFETY_STOCK_PACK
            , ATTRIBUTE1
            , PRODUCTION_CYCLE_CELL
            , PRODUCTION_CYCLE_PACK
            , DNI_CELL_DEPARTURE_DAYS
            , DNI_CELL_DEPARTURE_INLAND
            , DNI_CELL_WAITING_FOR_SHIPPING
            , DNI_CELL_VOYAGE
            , DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
            , DNI_CELL_ARRIVAL_INLAND
            , DNI_PACK_DEPARTURE_DAYS
            , DNI_PACK_DEPARTURE_INLAND
            , DNI_PACK_WAITING_FOR_SHIPPING
            , DNI_PACK_VOYAGE
            , DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
            , DNI_PACK_ARRIVAL_INLAND
            , SHIPMENT_CELL_INSPECTION_LOAD
            , SHIPMENT_CELL_INSPECTION_WAITING
            , SHIPMENT_PACK_INSPECTION_LOAD
            , SHIPMENT_PACK_INSPECTION_WAITING
            , PRE_INSPECTION_CELL
            , PRE_INSPECTION_PACK
            , VMI_CELL
            , VMI_PACK
            , FOREIGN_CORP
            , RACK_BIZ
            , STD_DIO
            , RN
            , RK
        )
        SELECT DV.YYYYMM
              , DR.DIVISION_ID
              , DR.PLAN_START_YYYYMMDD
              , DR.PLAN_TYPE
              , DR.SEQ
              , DR.VER
              , DR.NICK_NAME
              , DR.PLANT_ID
              , DR.ITEM_ID
              , DR.CELL_AGING_LT
              , DR.CELL_EOL_SHIPPING_LOT
              , DR.PACK_INCOMMING
              , DR.PACK_OPERATION_LT
              , DR.SAFETY_STOCK_CELL
              , DR.SAFETY_STOCK_PACK
              , DR.ATTRIBUTE1
              , DR.PRODUCTION_CYCLE_CELL
              , DR.PRODUCTION_CYCLE_PACK
              , DR.DNI_CELL_DEPARTURE_DAYS
              , DR.DNI_CELL_DEPARTURE_INLAND
              , DR.DNI_CELL_WAITING_FOR_SHIPPING
              , DR.DNI_CELL_VOYAGE
              , DR.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
              , DR.DNI_CELL_ARRIVAL_INLAND
              , DR.DNI_PACK_DEPARTURE_DAYS
              , DR.DNI_PACK_DEPARTURE_INLAND
              , DR.DNI_PACK_WAITING_FOR_SHIPPING
              , DR.DNI_PACK_VOYAGE
              , DR.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
              , DR.DNI_PACK_ARRIVAL_INLAND
              , DR.SHIPMENT_CELL_INSPECTION_LOAD
              , DR.SHIPMENT_CELL_INSPECTION_WAITING
              , DR.SHIPMENT_PACK_INSPECTION_LOAD
              , DR.SHIPMENT_PACK_INSPECTION_WAITING
              , DR.PRE_INSPECTION_CELL
              , DR.PRE_INSPECTION_PACK
              , DR.VMI_CELL
              , DR.VMI_PACK
              , DR.FOREIGN_CORP
              , DR.RACK_BIZ
              , CAST(/* - Manufacturing L/T */
                        NVL(DR.CELL_AGING_LT, 0)
                      + NVL(DR.CELL_EOL_SHIPPING_LOT, 0)
                      + NVL(DR.PACK_INCOMMING, 0)
                      + NVL(DR.PACK_OPERATION_LT, 0)
                      /* -  safety stock */
                      + NVL(DR.SAFETY_STOCK_CELL, 0)
                      + NVL(DR.SAFETY_STOCK_PACK, 0)
                      + NVL(TO_NUMBER(DR.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR), 0)
                      /* -  production cycle */
                      + NVL(DR.PRODUCTION_CYCLE_CELL, 0)
                      + NVL(DR.PRODUCTION_CYCLE_PACK, 0)
                      /* - Departure Days + Intransit (SEMI) */
                      + NVL(DR.DNI_CELL_DEPARTURE_DAYS, 0)
                      + NVL(DR.DNI_CELL_DEPARTURE_INLAND, 0)
                      + NVL(DR.DNI_CELL_WAITING_FOR_SHIPPING, 0)
                      + NVL(DR.DNI_CELL_VOYAGE, 0)
                      + NVL(DR.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE, 0)
                      + NVL(DR.DNI_CELL_ARRIVAL_INLAND, 0)
                      /* - Departure Days + Intransit (FG) */
                      + NVL(DR.DNI_PACK_DEPARTURE_DAYS, 0)
                      + NVL(DR.DNI_PACK_DEPARTURE_INLAND, 0)
                      + NVL(DR.DNI_PACK_WAITING_FOR_SHIPPING, 0)
                      + NVL(DR.DNI_PACK_VOYAGE, 0)
                      + NVL(DR.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE, 0)
                      + NVL(DR.DNI_PACK_ARRIVAL_INLAND, 0)

                      /* - Shipment (Waiting) */
                      + NVL(DR.SHIPMENT_CELL_INSPECTION_LOAD, 0)
                      + NVL(DR.SHIPMENT_CELL_INSPECTION_WAITING, 0)
                      + NVL(DR.SHIPMENT_PACK_INSPECTION_LOAD, 0)
                      + NVL(DR.SHIPMENT_PACK_INSPECTION_WAITING, 0)
                      /* - Quality (pre inspection) */
                      + NVL(DR.PRE_INSPECTION_CELL, 0)
                      + NVL(DR.PRE_INSPECTION_PACK, 0)
                      /* - vmi */
                      + NVL(DR.VMI_CELL, 0)
                      + NVL(DR.VMI_PACK, 0)
                      /* - Foreign Corp / Rack Biz */
                      + NVL(TO_NUMBER(DR.FOREIGN_CORP DEFAULT NULL ON CONVERSION ERROR), 0)
                      + NVL(TO_NUMBER(DR.RACK_BIZ      DEFAULT NULL ON CONVERSION ERROR), 0)
                AS NUMBER(20, 10))                                    AS STD_DIO
              , ROW_NUMBER() OVER (PARTITION BY DV.YYYYMM
                                              , DR.DIVISION_ID
                                              , DR.PLAN_START_YYYYMMDD
                                              , DR.PLAN_TYPE
                                              , DR.SEQ
                                              , DR.VER
                                              , DR.NICK_NAME  /* nick_name별 중복? 데이터 제거를 위해.. (6/20일 이전 dio report는 plant/nick_name별 적재 -> 이후는 nick_name별 적재) */
                                      ORDER BY DR.PLANT_ID
                                              , DR.ITEM_ID)   AS RN
              , RANK()       OVER (PARTITION BY DR.DIVISION_ID
                                      ORDER BY DR.PLAN_START_YYYYMMDD DESC
                                               )             AS RK
          FROM SCP_ANL_DIO_REPORT DR
             , GT_PRSCP_TMP_DIO_VERSION DV
         WHERE DR.DIVISION_ID          = DV.DIVISION_ID
           AND DR.PLAN_START_YYYYMMDD  = DV.PLAN_START_YYYYMMDD
           AND DR.PLAN_TYPE            = DV.PLAN_TYPE
           AND DR.SEQ                  = DV.SEQ
           AND DR.VER                  = DV.VER;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_DIO_REPORT'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* ----------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||'  6.3 기준 DIO/수량 데이터 추출 - 기준 DIO 및 기준수량');
        /* ----------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_STANDARD_DIO';

        INSERT INTO GT_PRSCP_TMP_STANDARD_DIO (
             YYYYMM
            , ITEM_ID
            , CELL_CONVERT_YN
            , QUANTITY
            , AMOUNT
            , UNIT_PRICE
            , UNIT_PRICE_LAST
            , YYYYMM_LAST
            , STD_DIO
            , STANDARD_QTY
            , PRODUCTION_CYCLE_CELL
            , PRODUCTION_CYCLE_PACK
            , PRODUCTION_CYCLE
            , SAFETY_STOCK_PIN_HOUSE
            , SAFETY_STOCK_CELL
            , SAFETY_STOCK_PACK
            , SAFETY_STOCK
            , OP_LT
            , DIO_VER
            , DIO_VER_LAST
            , PRE_INSPECTION_CELL
            , PRE_INSPECTION_PACK
            , PRE_INSPECTION
        )
        WITH DIO_REPORT AS (
            SELECT DR.YYYYMM
                  , DR.DIVISION_ID
                  , DR.PLAN_START_YYYYMMDD
                  , DR.PLAN_TYPE
                  , DR.SEQ
                  , DR.VER
                  , DR.NICK_NAME
                  , DR.PLANT_ID
                  , DR.ITEM_ID
                  , DR.CELL_AGING_LT
                  , DR.CELL_EOL_SHIPPING_LOT
                  , DR.PACK_INCOMMING
                  , DR.PACK_OPERATION_LT
                  , DR.SAFETY_STOCK_CELL
                  , DR.SAFETY_STOCK_PACK
                  , DR.ATTRIBUTE1
                  , DR.PRODUCTION_CYCLE_CELL
                  , DR.PRODUCTION_CYCLE_PACK
                  , DR.DNI_CELL_DEPARTURE_DAYS
                  , DR.DNI_CELL_DEPARTURE_INLAND
                  , DR.DNI_CELL_WAITING_FOR_SHIPPING
                  , DR.DNI_CELL_VOYAGE
                  , DR.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE
                  , DR.DNI_CELL_ARRIVAL_INLAND
                  , DR.DNI_PACK_DEPARTURE_DAYS
                  , DR.DNI_PACK_DEPARTURE_INLAND
                  , DR.DNI_PACK_WAITING_FOR_SHIPPING
                  , DR.DNI_PACK_VOYAGE
                  , DR.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE
                  , DR.DNI_PACK_ARRIVAL_INLAND
                  , DR.SHIPMENT_CELL_INSPECTION_LOAD
                  , DR.SHIPMENT_CELL_INSPECTION_WAITING
                  , DR.SHIPMENT_PACK_INSPECTION_LOAD
                  , DR.SHIPMENT_PACK_INSPECTION_WAITING
                  , DR.PRE_INSPECTION_CELL
                  , DR.PRE_INSPECTION_PACK
                  , DR.VMI_CELL
                  , DR.VMI_PACK
                  , DR.FOREIGN_CORP
                  , DR.RACK_BIZ
                  , DR.STD_DIO
                  , DR.RN
                  , DR.RK
                  , CAST(DR.STD_DIO AS NUMBER(20, 1)) AS STD_DIO2
              FROM GT_PRSCP_TMP_DIO_REPORT DR
        )
        SELECT ID.YYYYMM
              , ID.ITEM_ID
              , ID.CELL_CONVERT_YN
              , ID.QUANTITY
              , ID.AMOUNT
              , ID.UNIT_PRICE
              , ID.UNIT_PRICE_LAST
              , ID.YYYYMM_LAST
              /* 기준 DIO 및 기준 수량 */
              , NVL(DR.STD_DIO2, 0)                       AS STD_DIO
              , CASE WHEN NVL(DR.STD_DIO2, 0) <= 0 THEN
                         0
                    WHEN NVL(DR.STD_DIO2, 0) - D.DAYS_NEXT_1 < 0 THEN
                         ROUND(NVL(CAST(NVL(DR.STD_DIO2, 0) AS NUMBER(30, 10))                           / CASE WHEN D.DAYS_NEXT_1 = 0 THEN NULL ELSE D.DAYS_NEXT_1 END, 0.0) * R.RTF_NEXT_1, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.DAYS_NEXT_1 = 0 THEN
                         ROUND(R.ACC_RTF_1, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_2 < 0  THEN
                         ROUND(NVL(CAST((NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_1) AS NUMBER(30, 10))          / CASE WHEN D.DAYS_NEXT_2 = 0 THEN NULL ELSE D.DAYS_NEXT_2 END, 0.0) * R.RTF_NEXT_2 + R.ACC_RTF_1, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_2 = 0  THEN
                         ROUND(R.ACC_RTF_2, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_3 < 0  THEN
                         ROUND(NVL(CAST((NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_2) AS NUMBER(30, 10))          / CASE WHEN D.DAYS_NEXT_3 = 0 THEN NULL ELSE D.DAYS_NEXT_3 END, 0.0) * R.RTF_NEXT_3 + R.ACC_RTF_2, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_3 = 0  THEN
                         ROUND(R.ACC_RTF_3, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_4 < 0  THEN
                         ROUND(NVL(CAST((NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_3) AS NUMBER(30, 10))          / CASE WHEN D.DAYS_NEXT_4 = 0 THEN NULL ELSE D.DAYS_NEXT_4 END, 0.0) * R.RTF_NEXT_4 + R.ACC_RTF_3, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_4 = 0  THEN
                         ROUND(R.ACC_RTF_4, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_5 < 0  THEN
                         ROUND(NVL(CAST((NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_4) AS NUMBER(30, 10))          / CASE WHEN D.DAYS_NEXT_5 = 0 THEN NULL ELSE D.DAYS_NEXT_5 END, 0.0) * R.RTF_NEXT_5 + R.ACC_RTF_4, 0)
                    WHEN NVL(DR.STD_DIO2, 0) - D.ACC_DAYS_5 = 0  THEN
                         ROUND(R.ACC_RTF_5, 0)
                    ELSE 0
               END                                       AS STANDARD_QTY
              /* OP-LT  (기준DIO - 주기재고 - 안전재고) */
              /* 주기재고 */
              , NVL(DR.PRODUCTION_CYCLE_CELL, 0)          AS PRODUCTION_CYCLE_CELL
              , NVL(DR.PRODUCTION_CYCLE_PACK, 0)          AS PRODUCTION_CYCLE_PACK
              , NVL(DR.PRODUCTION_CYCLE_CELL, 0)
               + NVL(DR.PRODUCTION_CYCLE_PACK, 0)        AS PRODUCTION_CYCLE
              /* 안전재고 */
              , NVL(TO_NUMBER(DR.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR), 0)  AS SAFETY_STOCK_PIN_HOUSE
              , NVL(DR.SAFETY_STOCK_CELL, 0)              AS SAFETY_STOCK_CELL
              , NVL(DR.SAFETY_STOCK_PACK, 0)              AS SAFETY_STOCK_PACK
              , NVL(TO_NUMBER(DR.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR), 0)
               + NVL(DR.SAFETY_STOCK_CELL, 0)
               + NVL(DR.SAFETY_STOCK_PACK, 0)            AS SAFETY_STOCK
              /* OP_LT (기준DIO - 주기재고 - 안전재고) */
              , CAST(
                /* Standard DIO */
                NVL(DR.STD_DIO2, 0)
                /* 주기재고 */
                - NVL(DR.PRODUCTION_CYCLE_CELL, 0) - NVL(DR.PRODUCTION_CYCLE_PACK, 0)
                /* 안전재고 */
                - NVL(TO_NUMBER(DR.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR), 0) - NVL(DR.SAFETY_STOCK_CELL, 0) - NVL(DR.SAFETY_STOCK_PACK, 0)
               AS NUMBER(20, 1))                          AS OP_LT
              /* -- Dio Report 참조 버전 정보 */
              , DR.DIVISION_ID||':' ||DR.PLAN_START_YYYYMMDD||':' ||DR.SEQ||':' ||DR.VER  AS DIO_VER
              , CASE WHEN DR.RK = 1
                    THEN DR.DIVISION_ID||':' ||DR.PLAN_START_YYYYMMDD||':' ||DR.SEQ||':' ||DR.VER
                    ELSE NULL
               END                                       AS DIO_VER_LAST
              /* 전진검사 */
              , NVL(DR.PRE_INSPECTION_CELL, 0)            AS PRE_INSPECTION_CELL
              , NVL(DR.PRE_INSPECTION_PACK, 0)            AS PRE_INSPECTION_PACK
              , NVL(DR.PRE_INSPECTION_CELL, 0)
               + NVL(DR.PRE_INSPECTION_PACK, 0)          AS PRE_INSPECTION
          FROM GT_PRSCP_TMP_INVENTORY_DIO ID
               LEFT JOIN GT_PRSCP_TMP_TARGET_ITEMS IM
                      ON IM.DIVISION_ID = P_DIVISION_ID
                     AND IM.ITEM_ID     = ID.ITEM_ID
               LEFT JOIN GT_PRSCP_TMP_AMDAU_ITEMS AI
                      ON AI.DIVISION_ID = P_DIVISION_ID
                     AND AI.ITEM_ID     = ID.ITEM_ID
               LEFT JOIN DIO_REPORT DR
                      ON DR.YYYYMM      = ID.YYYYMM
                     AND DR.NICK_NAME   = NVL(IM.NICKNAME_FOR_DIO, AI.NICKNAME_FOR_DIO)
                     AND DR.RN          = 1  /* 중복 제거를 위해 (6/20일 이전 생성된 버전은 plant/nick_name별 데이터임 -> 이후는 nick_name별임) */
               INNER JOIN GT_PRSCP_TMP_MM_DAYS_INFO D
                       ON D.YYYYMM      = ID.YYYYMM
               LEFT JOIN GT_PRSCP_TMP_RTF_FOR_DIO R
                      ON R.YYYYMM       = ID.YYYYMM
                     AND R.ITEM_ID      = ID.ITEM_ID
                     AND R.CELL_CONVERT_YN = ID.CELL_CONVERT_YN
         WHERE 1 = 1;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_STANDARD_DIO'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

        /* -------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 7. OP L/T  ');
        /* -------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_OP_LT';

        INSERT INTO GT_PRSCP_TMP_OP_LT (
             YYYYMM
            , ITEM_ID
            , CELL_CONVERT_YN
            , QUANTITY
            , AMOUNT
            , UNIT_PRICE
            , UNIT_PRICE_LAST
            , YYYYMM_LAST
            , OP_LT
            , OP_LT_QTY
            , DIO_VER
            , DIO_VER_LAST
        )
        SELECT SD.YYYYMM
              , SD.ITEM_ID
              , SD.CELL_CONVERT_YN
              , SD.QUANTITY
              , SD.AMOUNT
              , SD.UNIT_PRICE
              , SD.UNIT_PRICE_LAST
              , SD.YYYYMM_LAST
              /* 공급 LT (기준DIO - 주기재고 - 안전재고) */
              , SD.OP_LT
              , CASE WHEN SD.OP_LT <= 0 THEN
                         0
                    WHEN SD.OP_LT - D.DAYS_NEXT_1 < 0 THEN
                         ROUND(NVL(CAST(SD.OP_LT AS NUMBER(30, 10))                         / CASE WHEN D.DAYS_NEXT_1 = 0 THEN NULL ELSE D.DAYS_NEXT_1 END, 0.0) * R.RTF_NEXT_1, 0)
                    WHEN SD.OP_LT - D.DAYS_NEXT_1 = 0 THEN
                         ROUND(R.ACC_RTF_1, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_2 < 0  THEN
                         ROUND(NVL(CAST((SD.OP_LT - D.ACC_DAYS_1) AS NUMBER(30, 10))        / CASE WHEN D.DAYS_NEXT_2 = 0 THEN NULL ELSE D.DAYS_NEXT_2 END, 0.0) * R.RTF_NEXT_2 + R.ACC_RTF_1, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_2 = 0  THEN
                         ROUND(R.ACC_RTF_2, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_3 < 0  THEN
                         ROUND(NVL(CAST((SD.OP_LT - D.ACC_DAYS_2) AS NUMBER(30, 10))        / CASE WHEN D.DAYS_NEXT_3 = 0 THEN NULL ELSE D.DAYS_NEXT_3 END, 0.0) * R.RTF_NEXT_3 + R.ACC_RTF_2, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_3 = 0  THEN
                         ROUND(R.ACC_RTF_3, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_4 < 0  THEN
                         ROUND(NVL(CAST((SD.OP_LT - D.ACC_DAYS_3) AS NUMBER(30, 10))        / CASE WHEN D.DAYS_NEXT_4 = 0 THEN NULL ELSE D.DAYS_NEXT_4 END, 0.0) * R.RTF_NEXT_4 + R.ACC_RTF_3, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_4 = 0  THEN
                         ROUND(R.ACC_RTF_4, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_5 < 0  THEN
                         ROUND(NVL(CAST((SD.OP_LT - D.ACC_DAYS_4) AS NUMBER(30, 10))        / CASE WHEN D.DAYS_NEXT_5 = 0 THEN NULL ELSE D.DAYS_NEXT_5 END, 0.0) * R.RTF_NEXT_5 + R.ACC_RTF_4, 0)
                    WHEN SD.OP_LT - D.ACC_DAYS_5 = 0  THEN
                         ROUND(R.ACC_RTF_5, 0)
                    ELSE 0
               END                                       AS OP_LT_QTY
              , SD.DIO_VER
              , MAX(SD.DIO_VER_LAST) OVER (PARTITION BY 'A') AS DIO_VER_LAST
          FROM GT_PRSCP_TMP_STANDARD_DIO SD
             , GT_PRSCP_TMP_MM_DAYS_INFO D
             , GT_PRSCP_TMP_RTF_FOR_DIO R
         WHERE D.YYYYMM              = SD.YYYYMM
           AND R.YYYYMM(+)           = SD.YYYYMM
           AND R.ITEM_ID(+)          = SD.ITEM_ID
           AND R.CELL_CONVERT_YN(+)  = SD.CELL_CONVERT_YN;

        DBMS_STATS.GATHER_TABLE_STATS(
            OWNNAME          => 'SCM_MGR'
          , TABNAME          => 'GT_PRSCP_TMP_OP_LT'
          , ESTIMATE_PERCENT => DBMS_STATS.AUTO_SAMPLE_SIZE
          , METHOD_OPT       => 'FOR ALL COLUMNS SIZE 1'
          , NO_INVALIDATE    => FALSE
        );

/* ---------------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------------- */

        /* ------------------------------------------------------------------------------------------------------------- */
        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 8. Monthly 모델(Item)별 데이터 최종 결과  ');
        /* ------------------------------------------------------------------------------------------------------------- */
        EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_DIO_TREND_FINAL_MODEL';

        INSERT INTO GT_PRSCP_TMP_DIO_TREND_FINAL_MODEL (
             YYYYMM
            , ITEM_ID
            , CELL_CONVERT_YN
            , MEASURE
            , QUANTITY
            , AMOUNT
            , DIO
            , PIC_ID
            , OPERATION_GROUP
            , CELL_GROUP
            , DEPT_ID
            , PROJECT_CODE
            , TARGET_CELL
            , CELL_CF
            , UNIT_PRICE
            , UNIT_PRICE_LAST
            , YYYYMM_LAST
            , DIO_VER
            , PRODUCTION_CYCLE
            , SAFETY_STOCK
            , PRE_INSPECTION
        )
        SELECT
             A.YYYYMM
            , A.ITEM_ID
            , A.CELL_CONVERT_YN
            , A.MEASURE
            , CAST(A.QUANTITY       AS NUMBER(30, 0))  AS QUANTITY
            , CAST(A.AMOUNT         AS NUMBER(30, 0))  AS AMOUNT
            , CAST(A.DIO            AS NUMBER(20, 1))  AS DIO
            /* ----------------------------------- */
            , NVL(IM.PIC_ID, AI.PIC_ID)               AS PIC_ID
            , CASE WHEN A.CELL_CONVERT_YN = 'N'
                  THEN NVL(IM.OPERATION_GROUP, AI.OPERATION_GROUP)
                  ELSE '-'
             END                                     AS OPERATION_GROUP
            , NVL(IM.NICKNAME_FOR_DIO, AI.NICKNAME_FOR_DIO)                                                              AS CELL_GROUP
            , NVL(PD.DEPT_ID, MAX(A.DEPT_ID)     OVER (PARTITION BY NVL(IM.NICKNAME_FOR_DIO, AI.NICKNAME_FOR_DIO))) AS DEPT_ID
            , NVL(PD.PROJECT_CODE, MAX(A.PROJECT_CODE) OVER (PARTITION BY NVL(IM.NICKNAME_FOR_DIO, AI.NICKNAME_FOR_DIO))) AS PROJECT_CODE
            /* ----------------------------------- */
            , MAX(A.TARGET_CELL) OVER (PARTITION BY           A.ITEM_ID, A.CELL_CONVERT_YN)  AS TARGET_CELL          /* 셀 환산 Target Cell or Source Cell Max (환산Item인 경우) */
            , MAX(A.CELL_CF) OVER (PARTITION BY           A.ITEM_ID, A.CELL_CONVERT_YN)  AS CELL_CF              /* 셀 환산계수 */
            , MAX(A.UNIT_PRICE) OVER (PARTITION BY A.YYYYMM, A.ITEM_ID, A.CELL_CONVERT_YN)  AS UNIT_PRICE           /* 단가 (해당월 재고) */
            , MAX(A.UNIT_PRICE_LAST) OVER (PARTITION BY           A.ITEM_ID, A.CELL_CONVERT_YN)  AS UNIT_PRICE_LAST      /* 단가 (전월재고-계획시작일기준) */
            , MAX(A.YYYYMM_LAST) OVER (PARTITION BY           A.ITEM_ID, A.CELL_CONVERT_YN)  AS YYYYMM_LAST          /* 과거구간 재고 최종년월 */
            , MAX(A.DIO_VER) OVER (PARTITION BY A.YYYYMM, A.ITEM_ID, A.CELL_CONVERT_YN)  AS DIO_VER              /* (DIO Report) 버전 */
            , MAX(A.PRODUCTION_CYCLE) OVER (PARTITION BY          A.ITEM_ID, A.CELL_CONVERT_YN)  AS PRODUCTION_CYCLE     /* (DIO Report 최종버전) 주기재고 */
            , MAX(A.SAFETY_STOCK) OVER (PARTITION BY           A.ITEM_ID, A.CELL_CONVERT_YN)  AS SAFETY_STOCK         /* (DIO Report 최종버전) 안전재고 */
            , MAX(A.PRE_INSPECTION) OVER (PARTITION BY           A.ITEM_ID, A.CELL_CONVERT_YN)  AS PRE_INSPECTION       /* (DIO REport 최종버전) 전진검사 */
            /* ----------------------------------- */
          FROM (
                /* 조립 (생산 measure : PROD) */
                SELECT P.YYYYMM
                      , P.ITEM_ID
                      , P.CELL_CONVERT_YN
                      , 'PROD'      AS MEASURE
                      , P.QTY       AS QUANTITY
                      , P.AMT       AS AMOUNT
                      , P.QTY_YIELD AS DIO /* 미래구간 수율 적용 수량 */
                      , 0.0         AS UNIT_PRICE
                      , P.TARGET_CELL
                      , P.CELL_CF
                      , 0.0         AS UNIT_PRICE_LAST  /* 전월재고 단가 (최종월 재고 단가) */
                      , NULL        AS YYYYMM_LAST       /* 과거 구간 재고 존재하는 최종 년월 */
                      , NULL        AS DIO_VER           /* (DIO Report) 버전 */
                      , 0.0         AS PRODUCTION_CYCLE  /* (DIO Report) 주기재고 */
                      , 0.0         AS SAFETY_STOCK      /* (DIO Report) 안전재고 */
                      , 0.0         AS PRE_INSPECTION    /* (DIO Report) 전진검사 */
                      , NULL        AS DEPT_ID           /* FCST/RTF SALES SITE 부서 정보 */
                      , NULL        AS PROJECT_CODE      /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_PRODUCTION_FINAL P
                /* FCST /RTF (FCST, RTF measure : FCST, RTF) */
                UNION ALL
                SELECT R.YYYYMM
                      , R.ITEM_ID
                      , R.CELL_CONVERT_YN
                      , CASE WHEN R.MEASURE = 'RTF_QTY'
                             THEN 'RTF'
                             ELSE 'FCST'
                       END         AS MEASURE
                      , R.QTY       AS QUANTITY
                      , R.AMT       AS AMOUNT
                      , 0.0         AS DIO
                      , 0.0         AS UNIT_PRICE
                      , R.TARGET_CELL
                      , R.CELL_CF
                      , 0.0         AS UNIT_PRICE_LAST  /* 전월재고 단가 */
                      , NULL        AS YYYYMM_LAST       /* 과거 구간 재고 존재하는 최종 년월 */
                      , NULL        AS DIO_VER           /* (DIO Report) 버전 */
                      , 0.0         AS PRODUCTION_CYCLE  /* (DIO Report) 주기재고 */
                      , 0.0         AS SAFETY_STOCK      /* (DIO Report) 안전재고 */
                      , 0.0         AS PRE_INSPECTION    /* (DIO Report) 전진검사 */
                      , R.DEPT_ID                       /* FCST/RTF SALES SITE 부서 정보 */
                      , R.PROJECT_CODE                  /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_MKT_FCST_RTF_FINAL R
                /* RTF-FCST (RTF-FCST measure : RTF-FCST) */
                UNION ALL
                SELECT R.YYYYMM
                      , R.ITEM_ID
                      , R.CELL_CONVERT_YN
                      , 'RTF-FCST'  AS MEASURE
                      , SUM(CASE WHEN R.MEASURE = 'RTF_QTY'
                                THEN R.QTY
                                ELSE R.QTY * (-1)
                           END)    AS QUANTITY
                      , SUM(CASE WHEN R.MEASURE = 'RTF_QTY'
                                THEN R.AMT
                                ELSE R.AMT * (-1)
                           END)    AS AMOUNT
                      , 0.0         AS DIO
                      , 0.0         AS UNIT_PRICE
                      , NULL        AS TARGET_CELL
                      , NULL        AS CELL_CF
                      , 0.0         AS UNIT_PRICE_LAST  /* 전월재고 단가 */
                      , NULL        AS YYYYMM_LAST       /* 과거 구간 재고 존재하는 최종 년월 */
                      , NULL        AS DIO_VER           /* (DIO Report) 버전 */
                      , 0.0         AS PRODUCTION_CYCLE  /* (DIO Report) 주기재고 */
                      , 0.0         AS SAFETY_STOCK      /* (DIO Report) 안전재고 */
                      , 0.0         AS PRE_INSPECTION    /* (DIO Report) 전진검사 */
                      , NULL        AS DEPT_ID           /* FCST/RTF SALES SITE 부서 정보 */
                      , NULL        AS PROJECT_CODE      /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_MKT_FCST_RTF_FINAL R
                 GROUP BY R.YYYYMM
                         , R.ITEM_ID
                         , R.CELL_CONVERT_YN
                /* 재고수량/재고금액/DIO  (measure : INV) */
                UNION ALL
                SELECT I.YYYYMM
                      , I.ITEM_ID
                      , I.CELL_CONVERT_YN
                      , 'INV'       AS MEASURE
                      , I.QUANTITY
                      /* 2023.04.28 미래구간 재고금액 산정 로직 변경 (수량*최종단가) */
                      , CASE WHEN I.YYYYMM >= V_PLAN_START_YYYYMM
                             THEN I.QUANTITY * I.UNIT_PRICE_LAST
                             ELSE I.AMOUNT
                       END         AS AMOUNT
                      , I.DIO
                      , I.UNIT_PRICE
                      , I.TARGET_CELL
                      , I.CELL_CF
                      , I.UNIT_PRICE_LAST  /* 전월재고 단가 */
                      , NULL        AS YYYYMM_LAST       /* 과거 구간 재고 존재하는 최종 년월 */
                      , NULL        AS DIO_VER           /* (DIO Report) 버전 */
                      , 0.0         AS PRODUCTION_CYCLE  /* (DIO Report) 주기재고 */
                      , 0.0         AS SAFETY_STOCK      /* (DIO Report) 안전재고 */
                      , 0.0         AS PRE_INSPECTION    /* (DIO Report) 전진검사 */
                      , NULL        AS DEPT_ID           /* FCST/RTF SALES SITE 부서 정보 */
                      , NULL        AS PROJECT_CODE      /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_INVENTORY_DIO I
                /* 기준 DIO 및 수량/금액 (measure : STANDARD ) */
                UNION ALL
                SELECT I.YYYYMM
                      , I.ITEM_ID
                      , I.CELL_CONVERT_YN
                      , 'STANDARD'                          AS MEASURE
                      , I.STANDARD_QTY
                      , I.STANDARD_QTY * I.UNIT_PRICE_LAST  AS STANDARD_AMOUNT
                      , I.STD_DIO
                      , 0.0                                 AS UNIT_PRICE
                      , NULL                                AS TARGET_CELL
                      , NULL                                AS CELL_CF
                      , 0.0                                 /* 전월재고 단가 */
                      , I.YYYYMM_LAST                       /* 과거 구간 재고 존재하는 최종 년월 */
                      , I.DIO_VER                           /* (DIO Report) 버전 */
                      , CASE WHEN I.DIO_VER = I.DIO_VER_LAST THEN I.PRODUCTION_CYCLE ELSE 0 END AS PRODUCTION_CYCLE  /* (DIO Report 최종버전) 주기재고 */
                      , CASE WHEN I.DIO_VER = I.DIO_VER_LAST THEN I.SAFETY_STOCK     ELSE 0 END AS SAFETY_STOCK      /* (DIO Report 최종버전) 안전재고 */
                      , CASE WHEN I.DIO_VER = I.DIO_VER_LAST THEN I.PRE_INSPECTION   ELSE 0 END AS PRE_INSPECTION    /* (DIO Report 최종버전) 전진검사 */
                      , NULL                                AS DEPT_ID           /* FCST/RTF SALES SITE 부서 정보 */
                      , NULL                                AS PROJECT_CODE      /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_STANDARD_DIO I
                /* GAP 수량/금액/DIO  (measure : GAP = INV - STANDARD) */
                UNION ALL
                SELECT NVL(I.YYYYMM, SD.YYYYMM)        AS YYYYMM
                      , NVL(I.ITEM_ID, SD.ITEM_ID)       AS ITEM_ID
                      , NVL(I.CELL_CONVERT_YN, SD.CELL_CONVERT_YN) AS CELL_CONVERT_YN
                      , 'GAP'                                   AS MEASURE
                      , NVL(I.QUANTITY, 0) - NVL(SD.STANDARD_QTY, 0)  AS QUANTITY
                      /* 2023.04.28 미래구간 재고금액 산정 로직 변경 (수량*최종단가) */
                      , CASE WHEN NVL(I.YYYYMM, SD.YYYYMM) >= V_PLAN_START_YYYYMM
                             THEN NVL(I.QUANTITY * I.UNIT_PRICE_LAST, 0) - NVL(SD.STANDARD_QTY * SD.UNIT_PRICE_LAST, 0)
                             ELSE NVL(I.AMOUNT, 0) - NVL(SD.STANDARD_QTY * SD.UNIT_PRICE_LAST, 0)
                       END                                     AS AMOUNT
                      , NVL(I.DIO, 0) - NVL(SD.STD_DIO, 0)    AS DIO
                      , 0.0                                     AS UNIT_PRICE
                      , NULL                                    AS TARGET_CELL
                      , NULL                                    AS CELL_CF
                      , 0.0                                     AS UNIT_PRICE_LAST  /* 전월재고 단가 */
                      , NULL                                    AS YYYYMM_LAST       /* 과거 구간 재고 존재하는 최종 년월 */
                      , NULL                                    AS DIO_VER           /* (DIO Report) 버전 */
                      , 0.0                                     AS PRODUCTION_CYCLE  /* (DIO Report) 주기재고 */
                      , 0.0                                     AS SAFETY_STOCK      /* (DIO Report) 안전재고 */
                      , 0.0                                     AS PRE_INSPECTION    /* (DIO Report) 전진검사 */
                      , NULL                                    AS DEPT_ID           /* FCST/RTF SALES SITE 부서 정보 */
                      , NULL                                    AS PROJECT_CODE      /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_INVENTORY_DIO I
                       FULL OUTER JOIN GT_PRSCP_TMP_STANDARD_DIO SD
                               ON I.YYYYMM          = SD.YYYYMM
                              AND I.ITEM_ID          = SD.ITEM_ID
                              AND I.CELL_CONVERT_YN  = SD.CELL_CONVERT_YN
                /* 공급 LT (measure : OP_LT ) */
                UNION ALL
                SELECT I.YYYYMM
                      , I.ITEM_ID
                      , I.CELL_CONVERT_YN
                      , 'OP-LT'     AS MEASURE
                      , I.OP_LT_QTY AS QUANTITY
                      , 0.0         AS AMOUNT
                      , I.OP_LT     AS DIO
                      , 0.0         AS UNIT_PRICE
                      , NULL        AS TARGET_CELL
                      , NULL        AS CELL_CF
                      , 0.0         AS UNIT_PRICE_LAST  /* 전월재고 단가 */
                      , NULL        AS YYYYMM_LAST       /* 과거 구간 재고 존재하는 최종 년월 */
                      , NULL        AS DIO_VER           /* (DIO Report) 버전 */
                      , 0.0         AS PRODUCTION_CYCLE  /* (DIO Report) 주기재고 */
                      , 0.0         AS SAFETY_STOCK      /* (DIO Report) 안전재고 */
                      , 0.0         AS PRE_INSPECTION    /* (DIO Report) 전진검사 */
                      , NULL        AS DEPT_ID           /* FCST/RTF SALES SITE 부서 정보 */
                      , NULL        AS PROJECT_CODE      /* FCST/RTF PROJECT_CODE */
                  FROM GT_PRSCP_TMP_OP_LT I
               ) A
               LEFT JOIN GT_PRSCP_TMP_TARGET_ITEMS IM
                      ON IM.DIVISION_ID = P_DIVISION_ID
                     AND IM.ITEM_ID     = A.ITEM_ID
               LEFT JOIN GT_PRSCP_TMP_AMDAU_ITEMS AI
                      ON AI.DIVISION_ID = P_DIVISION_ID
                     AND AI.ITEM_ID     = A.ITEM_ID
               LEFT JOIN GT_PRSCP_TMP_PROJECT_DEPT_INFO PD
                  /* ON PD.ITEM_ID   = A.ITEM_ID */
                      ON PD.CELL_GROUP = NVL(IM.NICKNAME_FOR_DIO, AI.NICKNAME_FOR_DIO); /* -- 11/07 셀그룹별로 부서/프로젝트정보 하나로 통일 */

        DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||' ### 8. Monthly 모델(Item)별 데이터 최종 결과 end ');

        /* ------------------------------------------------------------------------ CELL_GROUP(LEVEL4) 별 데이터 생성 */
        /* ------------------------------------------------------------------------ CELL_GROUP(LEVEL4) 별 데이터 생성 */
        /* ------------------------------------------------------------------------ CELL_GROUP(LEVEL4) 별 데이터 생성 */
        /* ------------------------------------------------------------------------ CELL_GROUP(LEVEL4) 별 데이터 생성 */
    /* ------------------------------------------------------------------------------------------------------ */
    /* @@@ 11. NICKNAME별 DIO 계산을 위한 RTF 정보 */
    /* ------------------------------------------------------------------------------------------------------ */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_RTF_FOR_CG_DIO';

    INSERT INTO GT_PRSCP_TMP_RTF_FOR_CG_DIO
        (YYYYMM
        , FIRST_YMD
        , CELL_CONVERT_YN
        , CELL_GROUP
        , OPERATION_GROUP
        , RTF_NEXT_1
        , RTF_NEXT_2
        , RTF_NEXT_3
        , RTF_NEXT_4
        , RTF_NEXT_5
        , ACC_RTF_1
        , ACC_RTF_2
        , ACC_RTF_3
        , ACC_RTF_4
        , ACC_RTF_5
        )
    SELECT R.YYYYMM
          , R.FIRST_YMD
          , R.CELL_CONVERT_YN
          , I.NICKNAME_FOR_DIO                         AS CELL_GROUP
          , CASE WHEN R.CELL_CONVERT_YN = 'Y'
                THEN '-'
                ELSE I.OPERATION_GROUP
           END                                        AS OPERATION_GROUP
          , SUM(R.RTF_NEXT_1)                          AS RTF_NEXT_1
          , SUM(R.RTF_NEXT_2)                          AS RTF_NEXT_2
          , SUM(R.RTF_NEXT_3)                          AS RTF_NEXT_3
          , SUM(R.RTF_NEXT_4)                          AS RTF_NEXT_4
          , SUM(R.RTF_NEXT_5)                          AS RTF_NEXT_5
          , SUM(R.ACC_RTF_1)                           AS ACC_RTF_1
          , SUM(R.ACC_RTF_2)                           AS ACC_RTF_2
          , SUM(R.ACC_RTF_3)                           AS ACC_RTF_3
          , SUM(R.ACC_RTF_4)                           AS ACC_RTF_4
          , SUM(R.ACC_RTF_5)                           AS ACC_RTF_5
     FROM GT_PRSCP_TMP_RTF_FOR_DIO R
          LEFT JOIN GT_PRSCP_TMP_TARGET_ITEMS I
                  ON I.ITEM_ID = R.ITEM_ID
    WHERE I.NICKNAME_FOR_DIO IS NOT NULL
      AND I.NICKNAME_FOR_DIO IS NOT NULL
    GROUP BY
           R.YYYYMM
          , R.FIRST_YMD
          , R.CELL_CONVERT_YN
          , I.NICKNAME_FOR_DIO
          , CASE WHEN R.CELL_CONVERT_YN = 'Y'
                THEN '-'
                ELSE I.OPERATION_GROUP
           END;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRSCP_TMP_RTF_FOR_CG_DIO', NO_INVALIDATE => FALSE);

    /* ------------------------------------------------------------------------------------------------------ */
    /* @@@ 12. CELL_GROUP별 DIO 산출 */
    /* ------------------------------------------------------------------------------------------------------ */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_CELL_GROUP_DIO';

    INSERT INTO GT_PRSCP_TMP_CELL_GROUP_DIO
        (YYYYMM
        , CELL_CONVERT_YN
        , CELL_GROUP
        , OPERATION_GROUP
        , MEASURE
        , QUANTITY
        , AMOUNT
        , DIO
        , PRODUCTION_CYCLE
        , SAFETY_STOCK
        , PRE_INSPECTION
        , TARGET_CELL
        , CELL_CF
        , DEPT_ID
        , PROJECT_CODE
        , PIC_ID
        , YYYYMM_LAST
        , UNIT_PRICE_LAST
        )
    WITH CELL_GROUP_BASE_DATA AS (
        SELECT R.YYYYMM
              , R.CELL_CONVERT_YN
              , R.CELL_GROUP
              , R.OPERATION_GROUP
              , R.MEASURE
              , SUM(R.QUANTITY)                                                                           AS QUANTITY
              , SUM(R.AMOUNT)                                                                             AS AMOUNT
              , SUM(CASE WHEN R.MEASURE = 'PROD' THEN R.DIO ELSE 0 END)                                  AS QUANTITY_YIELD
              , MAX(MAX(R.DIO))               OVER (PARTITION BY R.YYYYMM, R.CELL_GROUP, R.MEASURE)      AS DIO
              , MAX(MAX(R.PRODUCTION_CYCLE))  OVER (PARTITION BY R.YYYYMM, R.CELL_GROUP, R.MEASURE)      AS PRODUCTION_CYCLE
              , MAX(MAX(R.SAFETY_STOCK))      OVER (PARTITION BY R.YYYYMM, R.CELL_GROUP, R.MEASURE)      AS SAFETY_STOCK
              , MAX(MAX(R.PRE_INSPECTION))    OVER (PARTITION BY R.YYYYMM, R.CELL_GROUP, R.MEASURE)      AS PRE_INSPECTION
              , MAX(R.TARGET_CELL)                                                                        AS TARGET_CELL
              , MAX(R.CELL_CF)                                                                            AS CELL_CF
              , MAX(R.DEPT_ID)                                                                            AS DEPT_ID
              , MAX(R.PROJECT_CODE)                                                                       AS PROJECT_CODE
              , MAX(R.PIC_ID)                                                                             AS PIC_ID
              , V_LAST_YYYYMM                                                                             AS YYYYMM_LAST
              , MAX(CASE WHEN R.MEASURE = 'INV'
                         AND R.YYYYMM = V_LAST_YYYYMM
                         AND SUM(R.QUANTITY) != 0
                        THEN ROUND(SUM(R.AMOUNT) / SUM(R.QUANTITY), 0)
                        ELSE NULL
                   END) OVER (PARTITION BY R.CELL_CONVERT_YN
                                          , R.OPERATION_GROUP
                                          , R.CELL_GROUP)                                                AS UNIT_PRICE_LAST
          FROM GT_PRSCP_TMP_DIO_TREND_FINAL_MODEL R
         WHERE R.MEASURE != 'GAP'
        GROUP BY
               R.YYYYMM
              , R.CELL_CONVERT_YN
              , R.CELL_GROUP
              , R.OPERATION_GROUP
              , R.MEASURE
    )
    SELECT C.YYYYMM
          , C.CELL_CONVERT_YN
          , C.CELL_GROUP
          , C.OPERATION_GROUP
          , TO_CHAR(C.MEASURE)                         AS MEASURE
          , CASE WHEN C.MEASURE NOT IN ('STANDARD', 'OP-LT') THEN
                     C.QUANTITY
                WHEN NVL(C.DIO, 0) <= 0 THEN
                     0
                WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 < 0 THEN
                     ROUND(NVL(CAST(NVL(C.DIO, 0) AS NUMBER(20, 10))                              / CASE WHEN D.DAYS_NEXT_1 = 0 THEN NULL ELSE D.DAYS_NEXT_1 END, 0.0) * R.RTF_NEXT_1, 0)
                WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 = 0 THEN
                     ROUND(R.ACC_RTF_1, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_1) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_2 = 0 THEN NULL ELSE D.DAYS_NEXT_2 END, 0.0) * R.RTF_NEXT_2 + R.ACC_RTF_1, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 = 0 THEN
                     ROUND(R.ACC_RTF_2, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_2) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_3 = 0 THEN NULL ELSE D.DAYS_NEXT_3 END, 0.0) * R.RTF_NEXT_3 + R.ACC_RTF_2, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 = 0 THEN
                     ROUND(R.ACC_RTF_3, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_3) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_4 = 0 THEN NULL ELSE D.DAYS_NEXT_4 END, 0.0) * R.RTF_NEXT_4 + R.ACC_RTF_3, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 = 0 THEN
                     ROUND(R.ACC_RTF_4, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_4) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_5 = 0 THEN NULL ELSE D.DAYS_NEXT_5 END, 0.0) * R.RTF_NEXT_5 + R.ACC_RTF_4, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 = 0 THEN
                     ROUND(R.ACC_RTF_5, 0)
                ELSE 0
           END                                        AS QUANTITY
          , CASE WHEN C.YYYYMM >= V_PLAN_START_YYYYMM AND C.MEASURE = 'INV' THEN  /* 2023.04.28 미래구간 재고금액 산정 로직 변경 (수량*최종단가) */
                     C.QUANTITY * C.UNIT_PRICE_LAST
                WHEN C.MEASURE NOT IN ('STANDARD', 'OP-LT') THEN
                     C.AMOUNT
                ELSE C.UNIT_PRICE_LAST
                     *
                     CASE WHEN NVL(C.DIO, 0) <= 0 THEN
                               0
                          WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 < 0 THEN
                               ROUND(NVL(CAST(NVL(C.DIO, 0) AS NUMBER(20, 10))                    / CASE WHEN D.DAYS_NEXT_1 = 0 THEN NULL ELSE D.DAYS_NEXT_1 END, 0.0) * R.RTF_NEXT_1, 0)
                          WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 = 0 THEN
                               ROUND(R.ACC_RTF_1, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_1) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_2 = 0 THEN NULL ELSE D.DAYS_NEXT_2 END, 0.0) * R.RTF_NEXT_2 + R.ACC_RTF_1, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 = 0 THEN
                               ROUND(R.ACC_RTF_2, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_2) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_3 = 0 THEN NULL ELSE D.DAYS_NEXT_3 END, 0.0) * R.RTF_NEXT_3 + R.ACC_RTF_2, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 = 0 THEN
                               ROUND(R.ACC_RTF_3, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_3) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_4 = 0 THEN NULL ELSE D.DAYS_NEXT_4 END, 0.0) * R.RTF_NEXT_4 + R.ACC_RTF_3, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 = 0 THEN
                               ROUND(R.ACC_RTF_4, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_4) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_5 = 0 THEN NULL ELSE D.DAYS_NEXT_5 END, 0.0) * R.RTF_NEXT_5 + R.ACC_RTF_4, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 = 0 THEN
                               ROUND(R.ACC_RTF_5, 0)
                          ELSE 0
                     END
           END                                        AS AMOUNT
          , CASE WHEN C.MEASURE IN ('RTF', 'FCST', 'RTF-FCST') THEN  /* DIO 관련 없음 MEASURE */
                     0
                WHEN C.MEASURE IN ('STANDARD', 'OP-LT') THEN         /* CELL_GROUP 기준으로 DIO Report 참조하는 measure */
                     C.DIO
                WHEN C.MEASURE = 'PROD' THEN                          /* 생산 수율 반영된 수량 */
                     C.QUANTITY_YIELD
                WHEN C.QUANTITY <= 0 THEN
                     0
                WHEN C.QUANTITY - R.RTF_NEXT_1 < 0 THEN
                     NVL(CAST(C.QUANTITY AS NUMBER(20, 10))                                        / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0.0) * D.DAYS_NEXT_1
                WHEN C.QUANTITY - R.RTF_NEXT_1 = 0 THEN
                     D.ACC_DAYS_1
                WHEN C.QUANTITY - R.ACC_RTF_2 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_1) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0.0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                WHEN C.QUANTITY - R.ACC_RTF_2 = 0 THEN
                     D.ACC_DAYS_2
                WHEN C.QUANTITY - R.ACC_RTF_3 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_2) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0.0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                WHEN C.QUANTITY - R.ACC_RTF_3 = 0 THEN
                     D.ACC_DAYS_3
                WHEN C.QUANTITY - R.ACC_RTF_4 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_3) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0.0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                WHEN C.QUANTITY - R.ACC_RTF_4 = 0 THEN
                     D.ACC_DAYS_4
                WHEN C.QUANTITY - R.ACC_RTF_5 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_4) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0.0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                WHEN C.QUANTITY - R.ACC_RTF_5 = 0 THEN
                     D.ACC_DAYS_5
                ELSE 180
           END                                        AS DIO
          , C.PRODUCTION_CYCLE
          , C.SAFETY_STOCK
          , C.PRE_INSPECTION
          , C.TARGET_CELL
          , C.CELL_CF
          , C.DEPT_ID
          , C.PROJECT_CODE
          , C.PIC_ID
          , C.YYYYMM_LAST
          , C.UNIT_PRICE_LAST
     FROM CELL_GROUP_BASE_DATA C
        , GT_PRSCP_TMP_MM_DAYS_INFO D
        , GT_PRSCP_TMP_RTF_FOR_CG_DIO R
    WHERE D.YYYYMM              = C.YYYYMM
      AND R.YYYYMM(+)          = C.YYYYMM
      AND R.CELL_GROUP(+)      = C.CELL_GROUP
      AND R.CELL_CONVERT_YN(+) = C.CELL_CONVERT_YN
      AND R.OPERATION_GROUP(+) = C.OPERATION_GROUP;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRSCP_TMP_CELL_GROUP_DIO', NO_INVALIDATE => FALSE);

    /* ------------------------------------------------------------------------------------------------------ */
    /* @@@ 13. 셀그룹별 DIO 산정 - GAP 추가 (INV - STANDARD) */
    /* ------------------------------------------------------------------------------------------------------ */
    INSERT INTO GT_PRSCP_TMP_CELL_GROUP_DIO
        (YYYYMM
        , CELL_CONVERT_YN
        , CELL_GROUP
        , OPERATION_GROUP
        , MEASURE
        , QUANTITY
        , AMOUNT
        , DIO
        , PRODUCTION_CYCLE
        , SAFETY_STOCK
        , PRE_INSPECTION
        , TARGET_CELL
        , CELL_CF
        , DEPT_ID
        , PROJECT_CODE
        , PIC_ID
        , YYYYMM_LAST
        , UNIT_PRICE_LAST
        )
    SELECT D.YYYYMM
          , D.CELL_CONVERT_YN
          , D.CELL_GROUP
          , D.OPERATION_GROUP
          , 'GAP'                                                                                          AS MEASURE
          , SUM(CASE WHEN D.MEASURE = 'INV' THEN CAST(D.QUANTITY AS NUMBER(30, 0)) ELSE (-1) * CAST(D.QUANTITY AS NUMBER(30, 0)) END)   AS QUANTITY
          , SUM(CASE WHEN D.MEASURE = 'INV' THEN CAST(D.AMOUNT   AS NUMBER(30, 0)) ELSE (-1) * CAST(D.AMOUNT   AS NUMBER(30, 0)) END)   AS AMOUNT
          , SUM(CASE WHEN D.MEASURE = 'INV' THEN CAST(D.DIO      AS NUMBER(20, 1)) ELSE (-1) * CAST(D.DIO      AS NUMBER(20, 1)) END)   AS DIO
          , MAX(D.PRODUCTION_CYCLE)                                                                        AS PRODUCTION_CYCLE
          , MAX(D.SAFETY_STOCK)                                                                            AS SAFETY_STOCK
          , MAX(D.PRE_INSPECTION)                                                                          AS PRE_INSPECTION
          , MAX(D.TARGET_CELL)                                                                             AS TARGET_CELL
          , MAX(D.CELL_CF)                                                                                 AS CELL_CF
          , MAX(D.DEPT_ID)                                                                                 AS DEPT_ID
          , MAX(D.PROJECT_CODE)                                                                            AS PROJECT_CODE
          , MAX(D.PIC_ID)                                                                                  AS PIC_ID
          , MAX(D.YYYYMM_LAST)                                                                             AS YYYYMM_LAST
          , MAX(D.UNIT_PRICE_LAST)                                                                         AS UNIT_PRICE_LAST
     FROM GT_PRSCP_TMP_CELL_GROUP_DIO D
    WHERE D.MEASURE IN ('INV', 'STANDARD')
    GROUP BY
           D.YYYYMM
          , D.CELL_CONVERT_YN
          , D.CELL_GROUP
          , D.OPERATION_GROUP;

    /* ------------------------------------------------------------------------ Category(Cell Convert/Pack/Cell)별/Measure별 합계 데이터 생성 */
    /* ------------------------------------------------------------------------ Category(Cell Convert/Pack/Cell)별/Measure별 합계 데이터 생성 */
    /* ------------------------------------------------------------------------ Category(Cell Convert/Pack/Cell)별/Measure별 합계 데이터 생성 */
    /* ------------------------------------------------------------------------ Category(Cell Convert/Pack/Cell)별/Measure별 합계 데이터 생성 */

    /* ------------------------------------------------------------------------------------------------------ */

    /* ------------------------------------------------------------------------------------------------------ */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_RTF_FOR_TOTAL_DIO';

    INSERT INTO GT_PRSCP_TMP_RTF_FOR_TOTAL_DIO
        (YYYYMM
        , FIRST_YMD
        , CELL_CONVERT_YN
        , OPERATION_GROUP
        , RTF_NEXT_1
        , RTF_NEXT_2
        , RTF_NEXT_3
        , RTF_NEXT_4
        , RTF_NEXT_5
        , ACC_RTF_1
        , ACC_RTF_2
        , ACC_RTF_3
        , ACC_RTF_4
        , ACC_RTF_5
        )
    SELECT R.YYYYMM
          , R.FIRST_YMD
          , R.CELL_CONVERT_YN
          , CASE WHEN R.CELL_CONVERT_YN = 'Y'
                THEN '-'
                ELSE I.OPERATION_GROUP
           END                                        AS OPERATION_GROUP
          , SUM(R.RTF_NEXT_1)                          AS RTF_NEXT_1
          , SUM(R.RTF_NEXT_2)                          AS RTF_NEXT_2
          , SUM(R.RTF_NEXT_3)                          AS RTF_NEXT_3
          , SUM(R.RTF_NEXT_4)                          AS RTF_NEXT_4
          , SUM(R.RTF_NEXT_5)                          AS RTF_NEXT_5
          , SUM(R.ACC_RTF_1)                           AS ACC_RTF_1
          , SUM(R.ACC_RTF_2)                           AS ACC_RTF_2
          , SUM(R.ACC_RTF_3)                           AS ACC_RTF_3
          , SUM(R.ACC_RTF_4)                           AS ACC_RTF_4
          , SUM(R.ACC_RTF_5)                           AS ACC_RTF_5
     FROM GT_PRSCP_TMP_RTF_FOR_DIO R
        , GT_PRSCP_TMP_TARGET_ITEMS I
    WHERE I.ITEM_ID(+) = R.ITEM_ID
    GROUP BY
           R.YYYYMM
          , R.FIRST_YMD
          , R.CELL_CONVERT_YN
          , CASE WHEN R.CELL_CONVERT_YN = 'Y'
                THEN '-'
                ELSE I.OPERATION_GROUP
           END;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRSCP_TMP_RTF_FOR_TOTAL_DIO', NO_INVALIDATE => FALSE);

    /* ------------------------------------------------------------------------- */

    /* ------------------------------------------------------------------------- */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_TOTAL_STD_DIO';

    INSERT INTO GT_PRSCP_TMP_TOTAL_STD_DIO
        (YYYYMM
        , DIVISION_ID
        , PLAN_START_YYYYMMDD
        , PLAN_TYPE
        , SEQ
        , VER
        , STD_DIO
        , OP_LT
        )
    WITH CYCLE_INVENTORY AS (
        SELECT DV.YYYYMM
              , DV.DIVISION_ID
              , DV.PLAN_START_YYYYMMDD
              , DV.PLAN_TYPE
              , DV.SEQ
              , DV.VER
              , CI.NICK_NAME
              , SUM(M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12)                                            AS ASSEMBLY_QTY
              , SUM(SUM(M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12)) OVER (PARTITION BY DV.YYYYMM
                                                                                    , DV.DIVISION_ID
                                                                                    , DV.PLAN_START_YYYYMMDD
                                                                                    , DV.PLAN_TYPE
                                                                                    , DV.SEQ
                                                                                    , DV.VER)            AS ASSEMBLY_QTY_SUM
              , CAST(SUM(M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12)
                      / SUM(SUM(M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11+M12)) OVER (PARTITION BY DV.YYYYMM
                                                                                              , DV.DIVISION_ID
                                                                                              , DV.PLAN_START_YYYYMMDD
                                                                                              , DV.PLAN_TYPE
                                                                                              , DV.SEQ
                                                                                              , DV.VER) AS NUMBER(20, 4)) AS ASSEMBLY_RATIO
         FROM GT_PRSCP_TMP_DIO_VERSION DV
            , SCP_ANL_DIO_CYCLE_INVENTORY CI
        WHERE CI.DIVISION_ID           = DV.DIVISION_ID
          AND CI.PLAN_START_YYYYMMDD   = DV.PLAN_START_YYYYMMDD
          AND CI.PLAN_TYPE             = DV.PLAN_TYPE
          AND CI.SEQ                   = DV.SEQ
          AND CI.VER                   = DV.VER
          AND CI.OPERATION_GROUP        = 'A'
        GROUP BY DV.YYYYMM
                , DV.DIVISION_ID
                , DV.PLAN_START_YYYYMMDD
                , DV.PLAN_TYPE
                , DV.SEQ
                , DV.VER
                , CI.NICK_NAME
    )
    SELECT CI.YYYYMM
          , CI.DIVISION_ID
          , CI.PLAN_START_YYYYMMDD
          , CI.PLAN_TYPE
          , CI.SEQ
          , CI.VER
          , CAST(SUM(DR.STD_DIO * CI.ASSEMBLY_RATIO) AS NUMBER(20, 1))                                    AS STD_DIO  /* - 기준DIO = sum(WEIGHT_DIO) */
          , CAST(SUM((
                 NVL(DR.STD_DIO, 0)                                                       /* Standard DIO */
               - NVL(DR.PRODUCTION_CYCLE_CELL, 0) - NVL(DR.PRODUCTION_CYCLE_PACK, 0)                   /* 주기재고 */
               - NVL(TO_NUMBER(DR.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR), 0)                                           /* 안전재고 */
               - NVL(DR.SAFETY_STOCK_CELL, 0)
               - NVL(DR.SAFETY_STOCK_PACK, 0)                                                       /* 안전재고 */
               ) * CI.ASSEMBLY_RATIO) AS NUMBER(20, 1))                                                   AS OP_LT    /* OP/LT = SUM((기준DIO-주기재고-안전재고)*Assembly_RATIO) */
     FROM GT_PRSCP_TMP_DIO_REPORT DR
        , CYCLE_INVENTORY CI
    WHERE CI.YYYYMM               = DR.YYYYMM
      AND CI.DIVISION_ID          = DR.DIVISION_ID
      AND CI.PLAN_START_YYYYMMDD  = DR.PLAN_START_YYYYMMDD
      AND CI.PLAN_TYPE            = DR.PLAN_TYPE
      AND CI.SEQ                  = DR.SEQ
      AND CI.VER                  = DR.VER
      AND CI.NICK_NAME            = DR.NICK_NAME
    GROUP BY
           CI.YYYYMM
          , CI.DIVISION_ID
          , CI.PLAN_START_YYYYMMDD
          , CI.PLAN_TYPE
          , CI.SEQ
          , CI.VER;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRSCP_TMP_TOTAL_STD_DIO', NO_INVALIDATE => FALSE);

    /* ------------------------------------------------------------------------ */

    /* ------------------------------------------------------------------------ */
    EXECUTE IMMEDIATE 'TRUNCATE TABLE GT_PRSCP_TMP_TOTAL_DIO';

    INSERT INTO GT_PRSCP_TMP_TOTAL_DIO
        (YYYYMM
        , CELL_CONVERT_YN
        , OPERATION_GROUP
        , MEASURE
        , QUANTITY
        , AMOUNT
        , DIO
        , PRODUCTION_CYCLE
        , SAFETY_STOCK
        , PRE_INSPECTION
        , TARGET_CELL
        , CELL_CF
        , DEPT_ID
        , PROJECT_CODE
        , PIC_ID
        , YYYYMM_LAST
        , UNIT_PRICE
        )
    WITH TOTAL_BASE_DATA AS (
        SELECT R.YYYYMM
              , R.CELL_CONVERT_YN
              , R.OPERATION_GROUP
              , R.MEASURE
              , SUM(R.QUANTITY)                                                                           AS QUANTITY
              , SUM(R.AMOUNT)                                                                             AS AMOUNT
              , SUM(CASE WHEN R.MEASURE = 'PROD' THEN R.DIO ELSE 0 END)                                  AS QUANTITY_YIELD
              , CASE WHEN R.MEASURE = 'STANDARD' THEN NVL(D.STD_DIO, 0)
                    WHEN R.MEASURE = 'OP-LT'    THEN NVL(D.OP_LT, 0)
                    ELSE MAX(MAX(R.DIO)) OVER (PARTITION BY R.YYYYMM, R.MEASURE)
               END                                                                                      AS DIO
              , MAX(MAX(R.PRODUCTION_CYCLE)) OVER (PARTITION BY R.YYYYMM, R.MEASURE)                     AS PRODUCTION_CYCLE
              , MAX(MAX(R.SAFETY_STOCK))     OVER (PARTITION BY R.YYYYMM, R.MEASURE)                     AS SAFETY_STOCK
              , MAX(MAX(R.PRE_INSPECTION))   OVER (PARTITION BY R.YYYYMM, R.MEASURE)                     AS PRE_INSPECTION
              , MAX(R.TARGET_CELL)                                                                        AS TARGET_CELL
              , MAX(R.CELL_CF)                                                                            AS CELL_CF
              , MAX(R.DEPT_ID)                                                                            AS DEPT_ID
              , MAX(R.PROJECT_CODE)                                                                       AS PROJECT_CODE
              , MAX(R.PIC_ID)                                                                             AS PIC_ID
              , V_LAST_YYYYMM                                                                             AS YYYYMM_LAST
              , MAX(CASE WHEN R.MEASURE = 'INV'
                         AND R.YYYYMM = V_LAST_YYYYMM
                         AND SUM(R.QUANTITY) != 0
                        THEN ROUND(SUM(R.AMOUNT) / SUM(R.QUANTITY), 0)
                        ELSE NULL
                   END) OVER (PARTITION BY R.CELL_CONVERT_YN
                                          , R.OPERATION_GROUP)                                           AS UNIT_PRICE
          FROM GT_PRSCP_TMP_DIO_TREND_FINAL_MODEL R
             , GT_PRSCP_TMP_TOTAL_STD_DIO D
         WHERE D.YYYYMM(+) = R.YYYYMM
           AND R.MEASURE != 'GAP'
        GROUP BY
               R.YYYYMM
              , R.CELL_CONVERT_YN
              , R.OPERATION_GROUP
              , R.MEASURE
              , D.STD_DIO
              , D.OP_LT
    )
    SELECT C.YYYYMM
          , C.CELL_CONVERT_YN
          , C.OPERATION_GROUP
          , TO_CHAR(C.MEASURE)                         AS MEASURE
          , CASE WHEN C.MEASURE NOT IN ('STANDARD', 'OP-LT') THEN
                     C.QUANTITY
                WHEN NVL(C.DIO, 0) <= 0 THEN
                     0
                WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 < 0 THEN
                     ROUND(NVL(CAST(NVL(C.DIO, 0) AS NUMBER(20, 10))                              / CASE WHEN D.DAYS_NEXT_1 = 0 THEN NULL ELSE D.DAYS_NEXT_1 END, 0.0) * R.RTF_NEXT_1, 0)
                WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 = 0 THEN
                     ROUND(R.ACC_RTF_1, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_1) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_2 = 0 THEN NULL ELSE D.DAYS_NEXT_2 END, 0.0) * R.RTF_NEXT_2 + R.ACC_RTF_1, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 = 0 THEN
                     ROUND(R.ACC_RTF_2, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_2) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_3 = 0 THEN NULL ELSE D.DAYS_NEXT_3 END, 0.0) * R.RTF_NEXT_3 + R.ACC_RTF_2, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 = 0 THEN
                     ROUND(R.ACC_RTF_3, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_3) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_4 = 0 THEN NULL ELSE D.DAYS_NEXT_4 END, 0.0) * R.RTF_NEXT_4 + R.ACC_RTF_3, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 = 0 THEN
                     ROUND(R.ACC_RTF_4, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 < 0 THEN
                     ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_4) AS NUMBER(20, 10))             / CASE WHEN D.DAYS_NEXT_5 = 0 THEN NULL ELSE D.DAYS_NEXT_5 END, 0.0) * R.RTF_NEXT_5 + R.ACC_RTF_4, 0)
                WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 = 0 THEN
                     ROUND(R.ACC_RTF_5, 0)
                ELSE 0
           END                                        AS QUANTITY
          , CASE WHEN C.YYYYMM >= V_PLAN_START_YYYYMM AND C.MEASURE = 'INV' THEN  /* 2023.04.28 미래구간 재고금액 산정 로직 변경 (수량*최종단가) */
                     C.QUANTITY * C.UNIT_PRICE
                WHEN C.MEASURE NOT IN ('STANDARD', 'OP-LT') THEN
                     C.AMOUNT
                ELSE C.UNIT_PRICE
                     *
                     CASE WHEN NVL(C.DIO, 0) <= 0 THEN
                               0
                          WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 < 0 THEN
                               ROUND(NVL(CAST(NVL(C.DIO, 0) AS NUMBER(20, 10))                    / CASE WHEN D.DAYS_NEXT_1 = 0 THEN NULL ELSE D.DAYS_NEXT_1 END, 0.0) * R.RTF_NEXT_1, 0)
                          WHEN NVL(C.DIO, 0) - D.DAYS_NEXT_1 = 0 THEN
                               ROUND(R.ACC_RTF_1, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_1) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_2 = 0 THEN NULL ELSE D.DAYS_NEXT_2 END, 0.0) * R.RTF_NEXT_2 + R.ACC_RTF_1, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_2 = 0 THEN
                               ROUND(R.ACC_RTF_2, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_2) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_3 = 0 THEN NULL ELSE D.DAYS_NEXT_3 END, 0.0) * R.RTF_NEXT_3 + R.ACC_RTF_2, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_3 = 0 THEN
                               ROUND(R.ACC_RTF_3, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_3) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_4 = 0 THEN NULL ELSE D.DAYS_NEXT_4 END, 0.0) * R.RTF_NEXT_4 + R.ACC_RTF_3, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_4 = 0 THEN
                               ROUND(R.ACC_RTF_4, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 < 0 THEN
                               ROUND(NVL(CAST((NVL(C.DIO, 0) - D.ACC_DAYS_4) AS NUMBER(20, 10))   / CASE WHEN D.DAYS_NEXT_5 = 0 THEN NULL ELSE D.DAYS_NEXT_5 END, 0.0) * R.RTF_NEXT_5 + R.ACC_RTF_4, 0)
                          WHEN NVL(C.DIO, 0) - D.ACC_DAYS_5 = 0 THEN
                               ROUND(R.ACC_RTF_5, 0)
                          ELSE 0
                     END
           END                                        AS AMOUNT
          , CASE WHEN C.MEASURE IN ('RTF', 'FCST', 'RTF-FCST') THEN  /* DIO 관련 없음 MEASURE */
                     0
                WHEN C.MEASURE IN ('STANDARD', 'OP-LT') THEN         /* CELL_GROUP 기준으로 DIO Report 참조하는 measure */
                     C.DIO
                WHEN C.MEASURE = 'PROD' THEN                          /* 생산 수율 반영된 수량 */
                     C.QUANTITY_YIELD
                WHEN C.QUANTITY <= 0 THEN
                     0
                WHEN C.QUANTITY - R.RTF_NEXT_1 < 0 THEN
                     NVL(CAST(C.QUANTITY AS NUMBER(20, 10))                                        / CASE WHEN R.RTF_NEXT_1 = 0 THEN NULL ELSE R.RTF_NEXT_1 END, 0.0) * D.DAYS_NEXT_1
                WHEN C.QUANTITY - R.RTF_NEXT_1 = 0 THEN
                     D.ACC_DAYS_1
                WHEN C.QUANTITY - R.ACC_RTF_2 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_1) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_2 = 0 THEN NULL ELSE R.RTF_NEXT_2 END, 0.0) * D.DAYS_NEXT_2 + D.ACC_DAYS_1
                WHEN C.QUANTITY - R.ACC_RTF_2 = 0 THEN
                     D.ACC_DAYS_2
                WHEN C.QUANTITY - R.ACC_RTF_3 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_2) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_3 = 0 THEN NULL ELSE R.RTF_NEXT_3 END, 0.0) * D.DAYS_NEXT_3 + D.ACC_DAYS_2
                WHEN C.QUANTITY - R.ACC_RTF_3 = 0 THEN
                     D.ACC_DAYS_3
                WHEN C.QUANTITY - R.ACC_RTF_4 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_3) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_4 = 0 THEN NULL ELSE R.RTF_NEXT_4 END, 0.0) * D.DAYS_NEXT_4 + D.ACC_DAYS_3
                WHEN C.QUANTITY - R.ACC_RTF_4 = 0 THEN
                     D.ACC_DAYS_4
                WHEN C.QUANTITY - R.ACC_RTF_5 < 0 THEN
                     NVL(CAST((C.QUANTITY - R.ACC_RTF_4) AS NUMBER(20, 10))                        / CASE WHEN R.RTF_NEXT_5 = 0 THEN NULL ELSE R.RTF_NEXT_5 END, 0.0) * D.DAYS_NEXT_5 + D.ACC_DAYS_4
                WHEN C.QUANTITY - R.ACC_RTF_5 = 0 THEN
                     D.ACC_DAYS_5
                ELSE 180
           END                                        AS DIO
          , C.PRODUCTION_CYCLE
          , C.SAFETY_STOCK
          , C.PRE_INSPECTION
          , C.TARGET_CELL
          , C.CELL_CF
          , C.DEPT_ID
          , C.PROJECT_CODE
          , C.PIC_ID
          , C.YYYYMM_LAST
          , C.UNIT_PRICE
     FROM TOTAL_BASE_DATA C
        , GT_PRSCP_TMP_MM_DAYS_INFO D
        , GT_PRSCP_TMP_RTF_FOR_TOTAL_DIO R
    WHERE D.YYYYMM              = C.YYYYMM
      AND R.YYYYMM(+)          = C.YYYYMM
      AND R.CELL_CONVERT_YN(+) = C.CELL_CONVERT_YN
      AND R.OPERATION_GROUP(+) = C.OPERATION_GROUP;

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME => 'SCM_MGR', TABNAME => 'GT_PRSCP_TMP_TOTAL_DIO', NO_INVALIDATE => FALSE);

    /* ------------------------------------------------------------------------------------- */
    /* @@@ 24. TOTAL GAP 추가 (INV - STANDARD) */
    /* ------------------------------------------------------------------------------------- */
    INSERT INTO GT_PRSCP_TMP_TOTAL_DIO
        (YYYYMM
        , CELL_CONVERT_YN
        , OPERATION_GROUP
        , MEASURE
        , QUANTITY
        , AMOUNT
        , DIO
        , PRODUCTION_CYCLE
        , SAFETY_STOCK
        , PRE_INSPECTION
        , TARGET_CELL
        , CELL_CF
        , DEPT_ID
        , PROJECT_CODE
        , PIC_ID
        , YYYYMM_LAST
        )
    SELECT D.YYYYMM
          , D.CELL_CONVERT_YN
          , D.OPERATION_GROUP
          , 'GAP'                                                                                          AS MEASURE
          , SUM(CASE WHEN D.MEASURE = 'INV' THEN CAST(D.QUANTITY AS NUMBER(30, 0)) ELSE (-1) * CAST(D.QUANTITY AS NUMBER(30, 0)) END)   AS QUANTITY
          , SUM(CASE WHEN D.MEASURE = 'INV' THEN CAST(D.AMOUNT   AS NUMBER(30, 0)) ELSE (-1) * CAST(D.AMOUNT   AS NUMBER(30, 0)) END)   AS AMOUNT
          , SUM(CASE WHEN D.MEASURE = 'INV' THEN CAST(D.DIO      AS NUMBER(20, 1)) ELSE (-1) * CAST(D.DIO      AS NUMBER(20, 1)) END)   AS DIO
          , MAX(D.PRODUCTION_CYCLE)                                                                        AS PRODUCTION_CYCLE
          , MAX(D.SAFETY_STOCK)                                                                            AS SAFETY_STOCK
          , MAX(D.PRE_INSPECTION)                                                                          AS PRE_INSPECTION
          , MAX(D.TARGET_CELL)                                                                             AS TARGET_CELL
          , MAX(D.CELL_CF)                                                                                 AS CELL_CF
          , MAX(D.DEPT_ID)                                                                                 AS DEPT_ID
          , MAX(D.PROJECT_CODE)                                                                            AS PROJECT_CODE
          , MAX(D.PIC_ID)                                                                                  AS PIC_ID
          , MAX(D.YYYYMM_LAST)                                                                             AS YYYYMM_LAST
     FROM GT_PRSCP_TMP_TOTAL_DIO D
    WHERE D.MEASURE IN ('INV', 'STANDARD')
    GROUP BY
           D.YYYYMM
          , D.CELL_CONVERT_YN
          , D.OPERATION_GROUP;

    /* ------------------------------------------------------------------------ 0 채운 데이터 일부 삭제 */
    /* ------------------------------------------------------------------------ 0 채운 데이터 일부 삭제 */
    /* ------------------------------------------------------------------------ 0 채운 데이터 일부 삭제 */
    /* ------------------------------------------------------------------------ 0 채운 데이터 일부 삭제 */

    /* -------------------------------------------------------------------------------------------------------------------- */

    /* -------------------------------------------------------------------------------------------------------------------- */
    DELETE FROM GT_PRSCP_TMP_DIO_TREND_FINAL_MODEL
     WHERE YYYYMM  != SUBSTR(P_PLAN_START_YYYYMMDD, 1, 6)
       AND QUANTITY = 0
       AND AMOUNT   = 0
       AND DIO      = 0
       AND MEASURE NOT IN ('INV', 'RTF', 'PROD', 'OP-LT');  /* 삭제 대상에서 제외  measure */

    DELETE FROM GT_PRSCP_TMP_CELL_GROUP_DIO
     WHERE YYYYMM  != SUBSTR(P_PLAN_START_YYYYMMDD, 1, 6)
       AND QUANTITY = 0
       AND AMOUNT   = 0
       AND DIO      = 0
       AND MEASURE NOT IN ('INV', 'RTF', 'PROD', 'OP-LT');  /* 삭제 대상에서 제외  measure */

    /* ------------------------ */
    /* ------------------------ */
    /* ------------------------ */

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */
    LOOP
        DELETE FROM SCP_RPT_DIO_TREND_MM
         WHERE PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = P_DIVISION_ID
           AND AGGR_DV            != 'ET'  /* UI에서 수정된 기타충당금 유지 */
           AND ROWNUM             <= 1000;

        EXIT WHEN SQL%ROWCOUNT = 0;
    END LOOP;

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */
    INSERT INTO SCP_RPT_DIO_TREND_MM (
               PLAN_START_YYYYMMDD
              , DIVISION_ID
              , AGGR_DV
              , YYYYMM
              , ITEM_ID
              , CATEGORY_DV
              , MEASURE
              , QUANTITY
              , AMOUNT
              , DIO
              , PIC_ID
              , CELL_GROUP
              , DEPT_ID
              , PROJECT_CODE
              , UNIT_PRICE
              , UNIT_PRICE_LAST
              , TARGET_CELL
              , CELL_CF
              , CELL_GROUP_TARGET
              , PRODUCTION_CYCLE
              , SAFETY_STOCK
              , PRE_INSPECTION
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
              , ATTRIBUTE10
              )
    SELECT P_PLAN_START_YYYYMMDD                                AS PLAN_START_YYYYMMDD
          , P_DIVISION_ID                                         AS DIVISION_ID
          , 'MD'                                                  AS AGGR_DV
          , F.YYYYMM
          , F.ITEM_ID
          , CASE WHEN F.CELL_CONVERT_YN = 'Y'
                THEN 'C'
                ELSE F.OPERATION_GROUP
           END                                                   AS CATEGORY_DV
          , TO_CHAR(F.MEASURE)                                    AS MEASURE
          , F.QUANTITY
          , F.AMOUNT
          , F.DIO
          , F.PIC_ID
          , F.CELL_GROUP
          , F.DEPT_ID
          , F.PROJECT_CODE
          , F.UNIT_PRICE
          , F.UNIT_PRICE_LAST
          , F.TARGET_CELL
          , F.CELL_CF
          , CASE WHEN F.CELL_CONVERT_YN = 'Y'
                THEN '-'
                ELSE NVL(NVL(IM_T.NICKNAME_FOR_DIO, AI_T.NICKNAME_FOR_DIO), '-')
           END                                                   AS CELL_GROUP_TARGET
          , F.PRODUCTION_CYCLE
          , F.SAFETY_STOCK
          , F.PRE_INSPECTION
          , P_CREATED_BY                                          AS CREATED_BY
          , SYSDATE                                               AS CREATION_DATE
          , P_CREATED_BY                                          AS LAST_UPDATED_BY
          , SYSDATE                                               AS LAST_UPDATE_DATE
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF'                                          THEN R.RTF_NEXT_1
                        WHEN F.MEASURE = 'PROD' AND F.OPERATION_GROUP = 'P'             THEN P.BEFORE_PACK_QTY  /* Pack 생산 계획 (수율 반영 전 수량 = Production plan 수량(수율적용) / 수율) */
                        WHEN F.MEASURE = 'PROD' AND F.OPERATION_GROUP IN ('A', '-')     THEN C.CELL_QTY_IN_PACK /* Pack 생산에 투입된 Cell 수량 */
                        ELSE NULL
                   END)                                          AS ATTRIBUTE1
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_2 ELSE NULL END)         AS ATTRIBUTE2
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_3 ELSE NULL END)         AS ATTRIBUTE3
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_4 ELSE NULL END)         AS ATTRIBUTE4
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_5 ELSE NULL END)         AS ATTRIBUTE5
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_1  ELSE NULL END)         AS ATTRIBUTE6
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_2  ELSE NULL END)         AS ATTRIBUTE7
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_3  ELSE NULL END)         AS ATTRIBUTE8
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_4  ELSE NULL END)         AS ATTRIBUTE9
          , TO_CHAR(CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_5  ELSE NULL END)         AS ATTRIBUTE10
     FROM GT_PRSCP_TMP_DIO_TREND_FINAL_MODEL F
          LEFT JOIN GT_PRSCP_TMP_RTF_FOR_DIO R
                 ON R.YYYYMM           = F.YYYYMM
                AND R.ITEM_ID          = F.ITEM_ID
                AND R.CELL_CONVERT_YN  = F.CELL_CONVERT_YN
          LEFT JOIN GT_PRSCP_TMP_PRODUCTION_FINAL P
                 ON P.YYYYMM           = F.YYYYMM
                AND P.ITEM_ID          = F.ITEM_ID
                AND P.CELL_CONVERT_YN  = F.CELL_CONVERT_YN
                AND F.OPERATION_GROUP  = 'P'
                AND F.CELL_CONVERT_YN  = 'N'
          LEFT JOIN GT_PRSCP_TMP_CELL_QTY_USED_IN_PACK C
                 ON C.YYYYMM           = F.YYYYMM
                AND C.ITEM_ID          = F.ITEM_ID
                AND F.OPERATION_GROUP  IN ('A', '-')
          LEFT JOIN GT_PRSCP_TMP_TARGET_ITEMS IM_T
                 ON IM_T.DIVISION_ID   = P_DIVISION_ID
                AND IM_T.ITEM_ID       = F.TARGET_CELL
          LEFT JOIN GT_PRSCP_TMP_AMDAU_ITEMS AI_T
                 ON AI_T.DIVISION_ID   = P_DIVISION_ID
                AND AI_T.ITEM_ID       = F.TARGET_CELL
    WHERE F.ITEM_ID IS NOT NULL;  /* Case 78: ITEM_ID NOT NULL guard */

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */
    INSERT INTO SCP_RPT_DIO_TREND_MM (
               PLAN_START_YYYYMMDD
              , DIVISION_ID
              , AGGR_DV
              , YYYYMM
              , ITEM_ID
              , CATEGORY_DV
              , MEASURE
              , QUANTITY
              , AMOUNT
              , DIO
              , PIC_ID
              , CELL_GROUP
              , CELL_GROUP_TARGET
              , DEPT_ID
              , PROJECT_CODE
              , UNIT_PRICE
              , UNIT_PRICE_LAST
              , TARGET_CELL
              , CELL_CF
              , PRODUCTION_CYCLE
              , SAFETY_STOCK
              , PRE_INSPECTION
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
              , ATTRIBUTE10
              )
    SELECT P_PLAN_START_YYYYMMDD                                AS PLAN_START_YYYYMMDD
          , P_DIVISION_ID                                         AS DIVISION_ID
          , 'CG'                                                  AS AGGR_DV
          , F.YYYYMM
          , F.CELL_GROUP                                          AS ITEM_ID
          , CASE WHEN F.CELL_CONVERT_YN = 'Y'
                THEN 'C'
                ELSE F.OPERATION_GROUP
           END                                                   AS CATEGORY_DV
          , F.MEASURE
          , F.QUANTITY
          , F.AMOUNT
          , F.DIO
          , F.PIC_ID
          , F.CELL_GROUP
          , '-'                                                   AS CELL_GROUP_TARGET
          , F.DEPT_ID
          , F.PROJECT_CODE
          , NVL(MAX(CASE WHEN F.MEASURE = 'INV' AND F.QUANTITY != 0 AND F.AMOUNT != 0
                        THEN ROUND(F.AMOUNT / F.QUANTITY, 0)
                        ELSE NULL
                   END) OVER (PARTITION BY F.YYYYMM
                                          , F.CELL_GROUP
                                          , F.CELL_CONVERT_YN
                             ), 0.0)                             AS UNIT_PRICE
          , F.UNIT_PRICE_LAST
          , F.TARGET_CELL
          , F.CELL_CF
          , F.PRODUCTION_CYCLE
          , F.SAFETY_STOCK
          , F.PRE_INSPECTION
          , P_CREATED_BY                                          AS CREATED_BY
          , SYSDATE                                               AS CREATION_DATE
          , P_CREATED_BY                                          AS LAST_UPDATED_BY
          , SYSDATE                                               AS LAST_UPDATE_DATE
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_1 ELSE NULL END   AS ATTRIBUTE1
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_2 ELSE NULL END   AS ATTRIBUTE2
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_3 ELSE NULL END   AS ATTRIBUTE3
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_4 ELSE NULL END   AS ATTRIBUTE4
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_5 ELSE NULL END   AS ATTRIBUTE5
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_1  ELSE NULL END   AS ATTRIBUTE6
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_2  ELSE NULL END   AS ATTRIBUTE7
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_3  ELSE NULL END   AS ATTRIBUTE8
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_4  ELSE NULL END   AS ATTRIBUTE9
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_5  ELSE NULL END   AS ATTRIBUTE10
     FROM GT_PRSCP_TMP_CELL_GROUP_DIO F
        , GT_PRSCP_TMP_RTF_FOR_CG_DIO R
    WHERE R.YYYYMM(+)          = F.YYYYMM
      AND R.CELL_GROUP(+)      = F.CELL_GROUP
      AND R.CELL_CONVERT_YN(+) = F.CELL_CONVERT_YN
      AND R.OPERATION_GROUP(+) = F.OPERATION_GROUP
      AND F.CELL_GROUP IS NOT NULL;  /* Case 78: ITEM_ID (= CELL_GROUP) NOT NULL guard */

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */
    INSERT INTO SCP_RPT_DIO_TREND_MM (
               PLAN_START_YYYYMMDD
              , DIVISION_ID
              , AGGR_DV
              , YYYYMM
              , ITEM_ID
              , CATEGORY_DV
              , MEASURE
              , QUANTITY
              , AMOUNT
              , DIO
              , PIC_ID
              , CELL_GROUP
              , CELL_GROUP_TARGET
              , DEPT_ID
              , PROJECT_CODE
              , UNIT_PRICE
              , UNIT_PRICE_LAST
              , TARGET_CELL
              , CELL_CF
              , PRODUCTION_CYCLE
              , SAFETY_STOCK
              , PRE_INSPECTION
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE6
              , ATTRIBUTE7
              , ATTRIBUTE8
              , ATTRIBUTE9
              , ATTRIBUTE10
              )
    SELECT P_PLAN_START_YYYYMMDD                                AS PLAN_START_YYYYMMDD
          , P_DIVISION_ID                                         AS DIVISION_ID
          , 'TT'                                                  AS AGGR_DV
          , F.YYYYMM
          , '합계'                                               AS ITEM_ID
          , CASE WHEN F.CELL_CONVERT_YN = 'Y'
                THEN 'C'
                ELSE F.OPERATION_GROUP
           END                                                   AS CATEGORY_DV
          , F.MEASURE
          , F.QUANTITY
          , F.AMOUNT
          , F.DIO
          , '합계'                                               AS PIC_ID
          , '합계'                                               AS CELL_GROUP
          , '-'                                                   AS CELL_GROUP_TARGET
          , '합계'                                               AS DEPT_ID
          , '합계'                                               AS PROJECT_CODE
          , F.UNIT_PRICE
          , F.UNIT_PRICE                                          AS UNIT_PRICE_LAST
          , F.TARGET_CELL
          , F.CELL_CF
          , F.PRODUCTION_CYCLE
          , F.SAFETY_STOCK
          , F.PRE_INSPECTION
          , P_CREATED_BY                                          AS CREATED_BY
          , SYSDATE                                               AS CREATION_DATE
          , P_CREATED_BY                                          AS LAST_UPDATED_BY
          , SYSDATE                                               AS LAST_UPDATE_DATE
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_1 ELSE NULL END   AS ATTRIBUTE1
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_2 ELSE NULL END   AS ATTRIBUTE2
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_3 ELSE NULL END   AS ATTRIBUTE3
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_4 ELSE NULL END   AS ATTRIBUTE4
          , CASE WHEN F.MEASURE = 'RTF' THEN R.RTF_NEXT_5 ELSE NULL END   AS ATTRIBUTE5
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_1  ELSE NULL END   AS ATTRIBUTE6
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_2  ELSE NULL END   AS ATTRIBUTE7
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_3  ELSE NULL END   AS ATTRIBUTE8
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_4  ELSE NULL END   AS ATTRIBUTE9
          , CASE WHEN F.MEASURE = 'RTF' THEN R.ACC_RTF_5  ELSE NULL END   AS ATTRIBUTE10
     FROM GT_PRSCP_TMP_TOTAL_DIO F
        , GT_PRSCP_TMP_RTF_FOR_TOTAL_DIO R
    WHERE R.YYYYMM(+)          = F.YYYYMM
      AND R.CELL_CONVERT_YN(+) = F.CELL_CONVERT_YN
      AND R.OPERATION_GROUP(+) = F.OPERATION_GROUP;

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* --------------------------------------------------------------------------------------------------------------------------------- */

    /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 기타충당금 복사 기능 추가 (최종 생성 DIO Trend 보고서 Plan Date) */
    BEGIN
        SELECT MAX(PLAN_START_YYYYMMDD)
          INTO V_LAST_PLAN_START_YYYYMMDD
          FROM SCP_RPT_DIO_TREND_MM
         WHERE PLAN_START_YYYYMMDD < P_PLAN_START_YYYYMMDD
           AND DIVISION_ID         = P_DIVISION_ID
           AND AGGR_DV             = 'ET'   /* 기타 충당금 */
           AND AMOUNT             != 0;     /* 금액이 입력된 정보가 있는 */
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            V_LAST_PLAN_START_YYYYMMDD := NULL;
    END;

    DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')||'@V_LAST_PLAN_START_YYYYMMDD = ' ||V_LAST_PLAN_START_YYYYMMDD);

    INSERT INTO SCP_RPT_DIO_TREND_MM (
               PLAN_START_YYYYMMDD
              , DIVISION_ID
              , AGGR_DV
              , YYYYMM
              , ITEM_ID
              , CATEGORY_DV
              , MEASURE
              , CELL_GROUP
              , CELL_GROUP_TARGET
              , QUANTITY
              , AMOUNT
              , DIO
              , CREATED_BY
              , CREATION_DATE
              , LAST_UPDATED_BY
              , LAST_UPDATE_DATE
              )
    SELECT DISTINCT
               P_PLAN_START_YYYYMMDD                            AS PLAN_START_YYYYMMDD
              , P_DIVISION_ID                                     AS DIVISION_ID
              , 'ET'                                              AS AGGR_DV
              , F.YYYYMM
              , '기타충당금'                                      AS ITEM_ID
              , CASE WHEN F.CELL_CONVERT_YN = 'Y'
                    THEN 'C'
                    ELSE F.OPERATION_GROUP
               END                                              AS CATEGORY_DV
              , 'INV'                                             AS MEASURE
              , '기타충당금'                                      AS CELL_GROUP
              , '-'                                              AS CELL_GROUP_TARGET
              , NVL(E.QUANTITY, 0.0)                             AS QUANTITY  /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 기타충당금 복사 기능 추가 */
              , NVL(E.AMOUNT, 0.0)                             AS AMOUNT    /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 기타충당금 복사 기능 추가 */
              , NVL(E.DIO, 0.0)                             AS DIO       /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 기타충당금 복사 기능 추가 */
              , P_CREATED_BY                                     AS CREATED_BY
              , SYSDATE                                           AS CREATION_DATE
              , P_CREATED_BY                                     AS LAST_UPDATED_BY
              , SYSDATE                                           AS LAST_UPDATE_DATE
     FROM GT_PRSCP_TMP_TOTAL_DIO F
          LEFT JOIN SCP_RPT_DIO_TREND_MM E  /* [PJ20230691R] LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 기타충당금 복사 기능 추가 */
                 ON 1 = 1
                AND E.PLAN_START_YYYYMMDD = V_LAST_PLAN_START_YYYYMMDD  /* 당주 이전 최종 생성 Plan Date */
                AND E.DIVISION_ID         = P_DIVISION_ID
                AND E.AGGR_DV             = 'ET'  /* 기타 충당금 */
                AND E.YYYYMM              = F.YYYYMM
                AND E.CATEGORY_DV         = CASE WHEN F.CELL_CONVERT_YN = 'Y'
                                                 THEN 'C'
                                                 ELSE F.OPERATION_GROUP
                                            END
                AND E.MEASURE             = 'INV'
                AND E.ITEM_ID             = '기타충당금'
    WHERE NOT EXISTS (
              SELECT 1                        /* 기 생성된 기타 충당금 데이터가 없을시에만 추가 */
                FROM SCP_RPT_DIO_TREND_MM ET
               WHERE ET.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                 AND ET.DIVISION_ID         = P_DIVISION_ID
                 AND ET.AGGR_DV             = 'ET'  /* 기타 충당금 */
              FETCH FIRST 1 ROWS ONLY
          );

    /* 종료 LOG */
    V_LOG_TYPE := 'END';
    V_LOG_MESSAGE := '##### END of procedure #####';
    V_DESCRIPTION := '[' ||V_EXEC_TIME||']';
    D_EVENT_DATE := SYSDATE;
    BEGIN PR_SCP_SYS_LOG_BATCH(
        $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE
      , V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT
      , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
    ); END;

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        V_SQL_CODE := TO_CHAR(SQLCODE);
        V_SQL_ERRMSG := SQLERRM;
        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
        V_LOG_TYPE := 'ERROR';
        V_LOG_MESSAGE := '########## ERROR IN PROCEDURE ##########';
        V_DESCRIPTION := 'PR_SCP_BATCH_IF:' ||P_DIVISION_ID||'/' ||P_PLAN_START_YYYYMMDD;
        D_EVENT_DATE := SYSDATE;
        V_PROC_INPUT := JSON_OBJECT('P_DIVISION_ID'          VALUE P_DIVISION_ID
                                   , 'P_PLAN_START_YYYYMMDD'  VALUE P_PLAN_START_YYYYMMDD
                                   , 'P_CREATED_BY'           VALUE P_CREATED_BY);
        BEGIN PR_SCP_SYS_LOG_BATCH(
            $$PLSQL_UNIT, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE
          , V_DESCRIPTION, D_EVENT_DATE, V_PROC_INPUT
          , V_SQL_CODE, V_SQL_ERRMSG, V_BACKTRACE
        ); END;
        RETURN;

END PR_SCP_RPT_DIO_TREND_MM;