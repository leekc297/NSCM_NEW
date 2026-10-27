PROCEDURE PR_SCP_XLS_BOH
(
    P_PLAN_CYCLE           IN VARCHAR2
  , P_PLAN_START_YYYYMMDD  IN VARCHAR2
  , P_PLAN_ID              IN VARCHAR2
  , P_MODELING_ID          IN VARCHAR2
  , P_SEQ                  IN VARCHAR2
  , P_PLAN_TYPE            IN VARCHAR2
  , P_MASTER_ID            IN VARCHAR2
  , P_DIVISION_ID          IN VARCHAR2
  , P_ENGINE_PLAN_ID       IN VARCHAR2
  , P_USER_ID              IN VARCHAR2 DEFAULT 'SCP_batch'
)
/* ============================================================
 * Program ID   : PR_SCP_XLS_BOH
 * Description  : PR_SCP_PLN_CREATE_DATA 에서 호출함.
 * OutTable     :
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2019.01.08   KTH         Initial Release PJ20170278 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2019.02.19   KTH         INCOTERMS 추가
 * 2020.04.14   KTH         조건변경 AND S.LOT_ID     LIKE 'WH::%' --> 'WH::%',
 *                                  AND CONVERT(VARCHAR,RECEIVING_DTTM,112)  = @start_yyyymmdd --> = @start_yyyymmdd
 * 2020.08.11   KSW         SCM_MST_FINAL_ITEM_V 에서 Nick Name 이 없는 건이 존재함 - DISTINCT 추가
 * 2020.10.27   KSW         2020.08.11 추가된 DISTINCT를 SCM_MST_FINAL_ITEM_V 에 제한적으로 적용하는 것으로 변경 (자동차 TO_SITE_BOH 수량 누락보완)
 * 2021.03.29   KSW         PJ20209642 LGES Digital SCM Level.3 달성을 위한 개선 - 대체 BOM 적용
 * 2021.09.15   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 - 전진검사
 * 2021.10.19   KSW         PJ20214907 LGES SCP 계획 수립 시간 단축 및 분석 기능 강화 [추가개선] - Pack BOH 수량에서 Hold 수량제외
 * 2024.04.30   KSK         81_JV 재고지원
 * 2026.04.20   YMH         E20260417-001923 시뮬레이터 내 BOH 중복 반영 건 FROM_SCM_SITE_ID 반영
 * , @p_plan_start_yyyymmdd = '20190107'
 * 2026.07.06   ZIONEX      [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    V_BATCH_USER      VARCHAR2(150 CHAR);
    V_PROGRAM_NAME    VARCHAR2(150 CHAR) := 'PR_SCP_XLS_BOH';
    V_LOG_TYPE        VARCHAR2(30 CHAR);
    N_LOG_COUNT       NUMBER := 0;
    V_LOG_MESSAGE     VARCHAR2(1000 CHAR);
    V_DESCRIPTION     VARCHAR2(500 CHAR);
    V_TABLE_ID        VARCHAR2(150 CHAR) := 'SCM_SYS_LOG_BATC';
    D_EVENT_DATE      DATE;
    V_START_TIME      DATE := SYSDATE;
    V_EXEC_TIME       VARCHAR2(10 CHAR) := '';
    V_EXEC_SEC        NUMBER;
    V_START_YYYYMMDD  VARCHAR2(8 CHAR);
    V_IS_AUTO         NUMBER := 0;
BEGIN
    /* LOG 용 변수 설정 */
    V_BATCH_USER := P_USER_ID;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := V_PROGRAM_NAME || ':' || 'INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* plan_start - 1일 (YYYYMMDD) */
    V_START_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

    /* ===== 1. BOH ===== */
    DELETE
      FROM SCP_XLS_BOH
     WHERE DIVISION_ID = P_DIVISION_ID;

    INSERT
      INTO SCP_XLS_BOH
         ( DIVISION_ID
         , PLAN_START_YYYYMMDD
         , PLAN_TYPE
         , SEQ
         , SCM_SITE_ID
         , INCOTERMS
         , ITEM_ID
         , QTY
         , ORIGIN_ITEM_ID
         , ORIGIN_QTY
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
         , ATTRIBUTE10 )
    SELECT X.DIVISION_ID
         , P_PLAN_START_YYYYMMDD    AS PLAN_START_YYYYMMDD
         , P_PLAN_TYPE              AS PLAN_TYPE
         , TO_NUMBER(P_SEQ)         AS SEQ
         , X.SCM_SITE_ID
         , NVL(X.INCOTERMS, '-')    AS INCOTERMS
         , X.ITEM_ID
         , X.QTY
         , X.ORIGIN_ITEM_ID
         , X.ORIGIN_QTY
         , V_BATCH_USER             AS CREATED_BY
         , SYSDATE                  AS CREATION_DATE
         , V_BATCH_USER             AS LAST_UPDATED_BY
         , SYSDATE                  AS LAST_UPDATE_DATE
         , X.FROM_SCM_SITE_ID       AS ATTRIBUTE1       /* 2026.04.20 YMH E20260417-001923 FROM_SCM_SITE_ID 반영 */
         , NULL                     AS ATTRIBUTE2
         , NULL                     AS ATTRIBUTE3
         , NULL                     AS ATTRIBUTE4
         , NULL                     AS ATTRIBUTE5
         , NULL                     AS ATTRIBUTE6
         , NULL                     AS ATTRIBUTE7
         , NULL                     AS ATTRIBUTE8
         , NULL                     AS ATTRIBUTE9
         , X.DESCR                  AS ATTRIBUTE10      /* Pack BOH 수량에서 Hold 수량제외(HOLD 확인용) */
      FROM ( SELECT A.DIVISION_ID
                  , A.SCM_SITE_ID
                  , A.INCOTERMS
                  , B.CHILD_ITEM_ID         AS ITEM_ID
                  , (A.QTY * B.CHILD_QTY)   AS QTY
                  , A.ITEM_ID               AS ORIGIN_ITEM_ID
                  , A.QTY                   AS ORIGIN_QTY
                  , A.DESCR
                  , A.FROM_SCM_SITE_ID
               FROM ( SELECT P_DIVISION_ID AS DIVISION_ID
                           , S.ITEM_ID
                           , SUBSTR(S.SITE_ID, 1, (CASE WHEN INSTR(S.SITE_ID, '~') = 0 THEN LENGTH(S.SITE_ID) ELSE INSTR(S.SITE_ID, '~') - 1 END)) AS SCM_SITE_ID
                           , (CASE WHEN T.SITE_TYPE = 'SALES'
                                   THEN SUBSTR(S.SITE_ID, INSTR(S.SITE_ID, '~') + 1, (CASE WHEN INSTR(S.SITE_ID, '~') = 0 THEN LENGTH(S.SITE_ID) ELSE INSTR(S.SITE_ID, '~') - 1 END))
                                   ELSE NULL
                              END)                          AS INCOTERMS
                           , S.QTY                          AS QTY
                           , S.DESCR                        AS DESCR
                           , FN_SCM_SPLIT(S.LOT_ID, 6, '::') AS FROM_SCM_SITE_ID
                        FROM SCP_PLN_TH_ENG_STOCK_PLAN S
                           , SCM_MST_SITE              T
                       WHERE 1 = 1
                         AND S.MASTER_ID = P_MASTER_ID
                         AND S.PLAN_ID   = P_ENGINE_PLAN_ID
                         AND S.LOT_ID  LIKE 'WH%'
                         AND S.ITEM_ID LIKE 'AMDAU%'
                         AND TO_CHAR(S.RECEIVING_DTTM, 'YYYYMMDD') >= V_START_YYYYMMDD
                         AND FN_SCM_SPLIT(S.MASTER_ID, 1, '::') = T.DIVISION_ID
                         AND SUBSTR(S.SITE_ID, 1, (CASE WHEN INSTR(S.SITE_ID, '~') = 0 THEN LENGTH(S.SITE_ID) ELSE INSTR(S.SITE_ID, '~') - 1 END)) = T.SCM_SITE_ID
                         AND (S.INSP_TYPE IS NULL OR S.INSP_TYPE NOT IN ('INSP_PRE', 'INSP_HOLD'))
                    ) A
                  , ( SELECT DISTINCT DIVISION_ID
                           , PARENT_ITEM_ID
                           , CHILD_ITEM_ID
                           , CHILD_QTY
                        FROM SCM_MST_BOM_SN_V
                       WHERE DIVISION_ID    = P_DIVISION_ID
                         AND PARENT_ITEM_ID LIKE 'AMDAU%'
                         AND CHILD_ITEM_ID  LIKE 'ACE%'
                         AND ALT_PRIORITY   = 'Y'
                    ) B
              WHERE A.DIVISION_ID = B.DIVISION_ID
                AND A.ITEM_ID     = B.PARENT_ITEM_ID
             UNION ALL
             SELECT P_DIVISION_ID AS DIVISION_ID
                  , SUBSTR(S.SITE_ID, 1, (CASE WHEN INSTR(S.SITE_ID, '~') = 0 THEN LENGTH(S.SITE_ID) ELSE INSTR(S.SITE_ID, '~') - 1 END)) AS SCM_SITE_ID
                  , (CASE WHEN T.SITE_TYPE = 'SALES'
                          THEN SUBSTR(S.SITE_ID, INSTR(S.SITE_ID, '~') + 1, (CASE WHEN INSTR(S.SITE_ID, '~') = 0 THEN LENGTH(S.SITE_ID) ELSE INSTR(S.SITE_ID, '~') - 1 END))
                          ELSE NULL
                     END)                          AS INCOTERMS
                  , S.ITEM_ID
                  , S.QTY                          AS QTY
                  , NULL                           AS ORIGIN_ITEM_ID
                  , 0                              AS ORIGIN_QTY
                  , S.DESCR                        AS DESCR
                  , FN_SCM_SPLIT(S.LOT_ID, 6, '::') AS FROM_SCM_SITE_ID
               FROM SCP_PLN_TH_ENG_STOCK_PLAN S
                  , ( SELECT DISTINCT F.DIVISION_ID, F.ITEM_ID FROM SCM_MST_FINAL_ITEM_V F ) F
                  , SCM_MST_SITE                   T
              WHERE 1 = 1
                AND S.MASTER_ID = P_MASTER_ID
                AND S.PLAN_ID   = P_ENGINE_PLAN_ID
                AND S.LOT_ID  LIKE 'WH%'
                AND S.ITEM_ID NOT LIKE 'AMDAU%'
                AND TO_CHAR(S.RECEIVING_DTTM, 'YYYYMMDD') >= V_START_YYYYMMDD
                AND FN_SCM_SPLIT(S.MASTER_ID, 1, '::') = F.DIVISION_ID
                AND S.ITEM_ID = F.ITEM_ID
                AND FN_SCM_SPLIT(S.MASTER_ID, 1, '::') = T.DIVISION_ID
                AND SUBSTR(S.SITE_ID, 1, (CASE WHEN INSTR(S.SITE_ID, '~') = 0 THEN LENGTH(S.SITE_ID) ELSE INSTR(S.SITE_ID, '~') - 1 END)) = T.SCM_SITE_ID
                AND (S.INSP_TYPE IS NULL OR S.INSP_TYPE NOT IN ('INSP_PRE', 'INSP_HOLD'))
           ) X;

    /* ===== ADD 07/01/2023 : SCP_MST_CELL_PROD_ASSY_MAP 기준 ITEM_ID -> ITEM_ID_ASSY 치환 (JV 재고지원) ===== */
    V_IS_AUTO := FN_IS_DIVISION(P_DIVISION_ID, 'CREATE', '81');

    UPDATE SCP_XLS_BOH A
       SET A.ITEM_ID = ( SELECT B.ITEM_ID_ASSY
                           FROM ( SELECT A2.SCM_SITE_ID
                                       , A2.ITEM_ID
                                       , C2.ITEM_ID_ASSY
                                       , ROW_NUMBER() OVER (PARTITION BY A2.DIVISION_ID, A2.SCM_SITE_ID, A2.ITEM_ID ORDER BY C2.ITEM_ID_ASSY) AS ROW_SEQ
                                    FROM SCP_XLS_BOH                A2
                                       , SCP_MST_CELL_PROD_ASSY_MAP C2
                                   WHERE C2.ITEM_ID_PROD = A2.ITEM_ID
                                     AND C2.PLANT_ID || '-A' = A2.SCM_SITE_ID
                                     AND A2.DIVISION_ID = P_DIVISION_ID
                                     AND (A2.DIVISION_ID = '82' OR V_IS_AUTO = 1)
                                     AND A2.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                                     AND A2.PLAN_TYPE = P_PLAN_TYPE
                                     AND A2.SEQ = TO_NUMBER(P_SEQ)
                                ) B
                          WHERE B.ROW_SEQ     = 1
                            AND B.SCM_SITE_ID = A.SCM_SITE_ID
                            AND B.ITEM_ID     = A.ITEM_ID )
     WHERE A.DIVISION_ID = P_DIVISION_ID
       AND (A.DIVISION_ID = '82' OR V_IS_AUTO = 1)
       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
       AND A.PLAN_TYPE = P_PLAN_TYPE
       AND A.SEQ       = TO_NUMBER(P_SEQ)
       AND EXISTS ( SELECT 1
                      FROM ( SELECT A2.SCM_SITE_ID
                                  , A2.ITEM_ID
                                  , ROW_NUMBER() OVER (PARTITION BY A2.DIVISION_ID, A2.SCM_SITE_ID, A2.ITEM_ID ORDER BY C2.ITEM_ID_ASSY) AS ROW_SEQ
                               FROM SCP_XLS_BOH                A2
                                  , SCP_MST_CELL_PROD_ASSY_MAP C2
                              WHERE C2.ITEM_ID_PROD = A2.ITEM_ID
                                AND C2.PLANT_ID || '-A' = A2.SCM_SITE_ID
                                AND A2.DIVISION_ID = P_DIVISION_ID
                                AND (A2.DIVISION_ID = '82' OR V_IS_AUTO = 1)
                                AND A2.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                                AND A2.PLAN_TYPE = P_PLAN_TYPE
                                AND A2.SEQ = TO_NUMBER(P_SEQ)
                           ) B
                     WHERE B.ROW_SEQ     = 1
                       AND B.SCM_SITE_ID = A.SCM_SITE_ID
                       AND B.ITEM_ID     = A.ITEM_ID );
    N_LOG_COUNT := SQL%ROWCOUNT;

    /* ===== 실행 Logic END ===== */
    /* TXN LOG */
    V_LOG_TYPE    := 'TXN';
    V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
    V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE, 'YYYYMMDD');
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;


    V_EXEC_SEC  := ROUND((SYSDATE - V_START_TIME) * 86400);
    V_EXEC_TIME := LPAD(TO_CHAR(TRUNC(V_EXEC_SEC / 60)), 2, '0') || ':' || LPAD(TO_CHAR(MOD(V_EXEC_SEC, 60)), 2, '0');

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '[' || P_MASTER_ID || '][' || P_ENGINE_PLAN_ID || '][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        /* ERROR LOG (MSSQL CATCH: 에러 흡수 후 return -1 -> Oracle 흡수 RETURN) */
        V_LOG_TYPE    := 'ERROR';
        V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
        V_DESCRIPTION := V_PROGRAM_NAME || 'ERROR_LINE : ' || SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 470);
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
        RETURN;
END;