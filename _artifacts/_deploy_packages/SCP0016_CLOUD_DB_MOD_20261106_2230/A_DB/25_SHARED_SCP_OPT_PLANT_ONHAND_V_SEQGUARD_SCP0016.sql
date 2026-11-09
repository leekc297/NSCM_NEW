-- 공용 객체 — 이 화면 몫만, 다른 화면 부분은 건드리지 않음 (원천 Doc/gen/SCP0016/SCP_OPT_PLANT_ONHAND_V_SEQGUARD_SCP0016.sql · 룰 H14)
-- SOURCE-FRESH: SCM_MGR.SCP_OPT_PLANT_ONHAND_V VIEW LAST_DDL=2026-10-29 18:20:30 FETCHED=2026-11-06 22:23 DB=ZIOUI1
-- 변경: TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$')) → TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$') DEFAULT NULL ON CONVERSION ERROR)

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCP_OPT_PLANT_ONHAND_V" ("MASTER_ID", "PLAN_ID", "OUT_VERSION_ID", "DIVISION_ID", "PLAN_START_YYYYMMDD", "PLAN_TYPE", "SEQ", "OPERATION_GROUP", "ITEM_ID", "SITE_ID", "YYYYMMDD", "STOCK_TYPE", "PSI_BOH_QTY", "PSI_IN_QTY", "PSI_OUT_QTY", "PSI_EOH_QTY", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "ORIGIN_DIVISION_ID", "ELECTRODE_TYPE", "PLAN_START_YYYYMMDD_DATE") AS 
  WITH SALES_SITE AS
     (  /* 판매사이트 목록 — PSI_M 생성기의 판매사이트 판정(SITE_TYPE='SALES')과 동일. 플랜트 재고 뷰이므로 제외 축 */
      SELECT S.SCM_SITE_ID
        FROM SCM_MST_SITE                   S
       WHERE S.SITE_TYPE                    = 'SALES'
         AND S.VALID_YN                     = 'Y'
       GROUP BY S.SCM_SITE_ID
     )
   , ORIGIN_SITE AS
     (  /* 사이트 대표(최소) 소속 사업부 — SCP_OPT_SALES_ONHAND_V 와 동일 규약 */
      SELECT S.SCM_SITE_ID
           , MIN(S.DIVISION_ID)                  AS MIN_DIVISION_ID
        FROM SCM_MST_SITE                   S
       WHERE S.VALID_YN                     = 'Y'
       GROUP BY S.SCM_SITE_ID
     )
   , FINAL_ITEM AS
     (  /* 품목 원장 — ELECTRODE_TYPE 복원용(전극 품목 누락 대비 외부조인으로 사용) */
      SELECT I.ITEM_ID
           , MAX(I.ELECTRODE_TYPE)               AS ELECTRODE_TYPE
        FROM SCP_MST_FINAL_ITEM_V           I
       GROUP BY I.ITEM_ID
     )
   , PSI AS
     (  /* 통합 Dataset → 플랜트사이트 × 품목 × 공정단계(STAGE) × 일자 피벗 (신형식 PLAN_ID 런만)
           — EOH 는 생성기의 공정단계별 일자 잔액 재귀 결과. BOH 는 행내 역산 = EOH − WH_IN − 생산 + 출고(전일EOH + 당일 IS) */
      SELECT M.PLAN_ID                           AS OPT_PLAN_ID
           , M.PLAN_START_YYYYMMDD
           , M.DIVISION_ID
           , M.OPERATION_GROUP
           , M.ITEM_ID
           , M.SCM_SITE_ID
           , M.STAGE
           , M.YYYYMMDD
           , SUM(CASE WHEN M.MEASURE = 'EOH'        THEN M.QTY ELSE 0 END)  AS EOH_QTY
           , SUM(CASE WHEN M.MEASURE = 'WH_IN'      THEN M.QTY ELSE 0 END)  AS IN_QTY
           , SUM(CASE WHEN M.MEASURE = 'PRODUCTION' THEN M.QTY ELSE 0 END)  AS P_QTY
           , SUM(CASE WHEN M.PSI_TYPE = 'S'         THEN M.QTY ELSE 0 END)  AS OUT_QTY
        FROM SCP_EGN_OTPT_PSI_M             M
       WHERE M.MEASURE                     IN ('EOH', 'WH_IN', 'PRODUCTION', 'SHIPPING', 'CONSUME', 'RTF')
         AND REGEXP_LIKE(REGEXP_SUBSTR(M.PLAN_ID, '[^-]+$'), '^[0-9]+$')   /* 신형식(SEQ 숫자) 런만 — 구포맷 파일럿 배제·TO_NUMBER 가드 */
         AND NOT EXISTS ( SELECT 1
                            FROM SCM_MST_SITE SS
                           WHERE SS.SCM_SITE_ID = M.SCM_SITE_ID
                             AND SS.SITE_TYPE   = 'SALES'
                             AND SS.VALID_YN    = 'Y' )
       GROUP BY M.PLAN_ID
           , M.PLAN_START_YYYYMMDD
           , M.DIVISION_ID
           , M.OPERATION_GROUP
           , M.ITEM_ID
           , M.SCM_SITE_ID
           , M.STAGE
           , M.YYYYMMDD
     )
   , EVT AS
     (  /* ① 재고형 — 공정단계(STAGE) → AS-IS STOCK_TYPE 대응. 대응 없는 단계는 이름 그대로 통과(전량 합산 보존)
           AS-IS 산식 근거 : 설비 축 ***=메인공정 · 001=활성화 · 002=특성 · 003=출하창고 (PR_SCP_PLN_PLANT_ONHAND 원문) */
      SELECT A.OPT_PLAN_ID
           , A.PLAN_START_YYYYMMDD
           , A.DIVISION_ID
           , A.OPERATION_GROUP
           , A.ITEM_ID
           , A.SCM_SITE_ID
           , A.YYYYMMDD
           , CASE WHEN A.OPERATION_GROUP = 'E' AND A.STAGE = 'COATING'   THEN 'COAT'      /* 전극 코팅완료 */
                  WHEN A.OPERATION_GROUP = 'E' AND A.STAGE = 'ELEC_POST' THEN 'SLIT'      /* 전극 슬리팅완료 */
                  WHEN A.OPERATION_GROUP = 'E' AND A.STAGE = 'TARGETBIZ' THEN 'E_OUT_WH'  /* 전극 출하창고 */
                  WHEN A.OPERATION_GROUP = 'A' AND A.STAGE = 'ASSY'      THEN 'ASSM'      /* 조립 */
                  WHEN A.OPERATION_GROUP = 'A' AND A.STAGE = 'ASY_AGING' THEN 'FORMED'    /* 활성화완료 */
                  WHEN A.OPERATION_GROUP = 'A' AND A.STAGE = 'CHAR'      THEN 'CHAR'      /* 특성완료 */
                  WHEN A.OPERATION_GROUP = 'A' AND A.STAGE = 'CELLBIZ'   THEN 'A_PACK'    /* 팩공장의 셀 */
                  WHEN A.OPERATION_GROUP = 'P' AND A.STAGE = 'PACK'      THEN 'PACK'      /* 팩 */
                  ELSE A.STAGE
             END                                  AS STOCK_TYPE
           , ROUND(A.EOH_QTY - A.IN_QTY - A.P_QTY + A.OUT_QTY, 10)          AS BOH_QTY    /* = 전일 EOH + 당일 IS */
           , A.IN_QTY
           , A.OUT_QTY
           , A.EOH_QTY
        FROM PSI                            A
       UNION ALL
        /* ② 이동(진행중)형 — 엔진 재공(WIP) → AS-IS 진행중 유형. BOH·EOH 모두 당일 재공 수량(시점차 미보유) */
      SELECT M.PLAN_ID
           , M.PLAN_START_YYYYMMDD
           , M.DIVISION_ID
           , M.OPERATION_GROUP
           , M.ITEM_ID
           , M.SCM_SITE_ID
           , M.YYYYMMDD
           , CASE WHEN M.OPERATION_GROUP = 'A' AND M.STAGE = 'ASY_AGING' THEN 'FORMING'   /* 활성화 진행중 */
                  WHEN M.OPERATION_GROUP = 'E' AND M.STAGE = 'ELEC_POST' THEN 'SLITTING'  /* 슬리팅 진행중 */
                  ELSE M.STAGE || '_WIP'
             END                                  AS STOCK_TYPE
           , SUM(M.QTY)                           AS BOH_QTY
           , 0                                    AS IN_QTY
           , 0                                    AS OUT_QTY
           , SUM(M.QTY)                           AS EOH_QTY
        FROM SCP_EGN_OTPT_PSI_M             M
       WHERE M.MEASURE                      = 'WIP'
         AND REGEXP_LIKE(REGEXP_SUBSTR(M.PLAN_ID, '[^-]+$'), '^[0-9]+$')
       GROUP BY M.PLAN_ID
           , M.PLAN_START_YYYYMMDD
           , M.DIVISION_ID
           , M.OPERATION_GROUP
           , M.ITEM_ID
           , M.SCM_SITE_ID
           , M.STAGE
           , M.YYYYMMDD
       UNION ALL
        /* ③ FOR_STOCKPLAN — 셀 활성화완료예정수량. AS-IS 산식 재현 :
           일자별 EOH = 도착일 > 해당일 인 잔여합 · BOH = 도착일 >= 해당일 인 잔여합 (원천 = 통합 Dataset 재고 FOR 계열) */
      SELECT I.PLAN_ID
           , I.PLAN_START_YYYYMMDD
           , I.DIVISION_ID
           , 'A'                                  AS OPERATION_GROUP
           , I.ITEM_ID
           , I.SCM_SITE_ID
           , C.BASIS_YYYYMMDD                     AS YYYYMMDD
           , 'FOR_STOCKPLAN'                      AS STOCK_TYPE
           , SUM(CASE WHEN I.EFFECTIVE_DATE >= C.BASIS_YYYYMMDD THEN I.QTY ELSE 0 END)  AS BOH_QTY
           , 0                                    AS IN_QTY
           , 0                                    AS OUT_QTY
           , SUM(CASE WHEN I.EFFECTIVE_DATE >  C.BASIS_YYYYMMDD THEN I.QTY ELSE 0 END)  AS EOH_QTY
        FROM SCP_EGN_OTPT_INV_M             I
           , SCP_OPT_ENG_PLAN_MASTER_SN     PM
           , SCM_SYS_CALENDAR_M             C
       WHERE I.PLAN_ID                      = PM.PLAN_ID
         AND C.BASIS_YYYYMMDD              >= PM.PLAN_START_DATE
         AND C.BASIS_YYYYMMDD              <= PM.PLAN_END_DATE
         AND I.INVENTORY_TYPE           LIKE 'FOR%'
         AND REGEXP_LIKE(REGEXP_SUBSTR(I.PLAN_ID, '[^-]+$'), '^[0-9]+$')
       GROUP BY I.PLAN_ID
           , I.PLAN_START_YYYYMMDD
           , I.DIVISION_ID
           , I.ITEM_ID
           , I.SCM_SITE_ID
           , C.BASIS_YYYYMMDD
     )
SELECT CAST(A.DIVISION_ID || '::WEEKLY' AS VARCHAR2(50 CHAR))               AS MASTER_ID
     , CAST(P.PLAN_ID AS VARCHAR2(30 CHAR))                                 AS PLAN_ID
     , CAST(CASE WHEN P.PLAN_ID IS NULL
                 THEN NULL
                 ELSE P.PLAN_ID || '::' || REGEXP_SUBSTR(A.OPT_PLAN_ID, '([^-]+)-[^-]+$', 1, 1, NULL, 1)
                                || '::' || TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$') DEFAULT NULL ON CONVERSION ERROR) /* 2026-11-06 W8 SEQ 변환 가드(ORA-01722 구포맷 ID) — DEFAULT NULL ON CONVERSION ERROR */
            END AS VARCHAR2(30 CHAR))                                       AS OUT_VERSION_ID
     , CAST(A.DIVISION_ID AS VARCHAR2(30 CHAR))                             AS DIVISION_ID
     , CAST(A.PLAN_START_YYYYMMDD AS VARCHAR2(8 CHAR))                      AS PLAN_START_YYYYMMDD
     , CAST(REGEXP_SUBSTR(A.OPT_PLAN_ID, '([^-]+)-[^-]+$', 1, 1, NULL, 1) AS VARCHAR2(50 CHAR))  AS PLAN_TYPE
     , CAST(TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$') DEFAULT NULL ON CONVERSION ERROR) /* 2026-11-06 W8 SEQ 변환 가드(ORA-01722 구포맷 ID) — DEFAULT NULL ON CONVERSION ERROR */ AS NUMBER(19,0))                   AS SEQ
     , CAST(A.OPERATION_GROUP AS VARCHAR2(10 CHAR))                         AS OPERATION_GROUP
     , CAST(A.ITEM_ID AS VARCHAR2(50 CHAR))                                 AS ITEM_ID
     , CAST(A.SCM_SITE_ID AS VARCHAR2(30 CHAR))                             AS SITE_ID
     , CAST(A.YYYYMMDD AS VARCHAR2(8 CHAR))                                 AS YYYYMMDD
     , CAST(A.STOCK_TYPE AS VARCHAR2(50 CHAR))                              AS STOCK_TYPE
     , CAST(A.BOH_QTY AS NUMBER(20,10))                                     AS PSI_BOH_QTY
     , CAST(A.IN_QTY AS NUMBER(20,10))                                      AS PSI_IN_QTY
     , CAST(A.OUT_QTY AS NUMBER(20,10))                                     AS PSI_OUT_QTY
     , CAST(A.EOH_QTY AS NUMBER(20,10))                                     AS PSI_EOH_QTY
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS CREATED_BY
     , CAST(NULL AS DATE)                                                   AS CREATION_DATE
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS LAST_UPDATED_BY
     , CAST(NULL AS DATE)                                                   AS LAST_UPDATE_DATE
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE1
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE2
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE3
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE4
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE5
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE6
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE7
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE8
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE9
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE10
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE11
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE12
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE13
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE14
     , CAST(NULL AS VARCHAR2(150 CHAR))                                     AS ATTRIBUTE15
     , CAST(CASE WHEN DM.ATTRIBUTE3 = 'EE'
                 THEN OS.MIN_DIVISION_ID          /* 전극 가상 사업부 : 사이트 대표 사업부 */
                 WHEN OS.MIN_DIVISION_ID = A.DIVISION_ID
                 THEN A.DIVISION_ID               /* 그 외 : 자기 사업부 소속 사이트만 */
            END AS VARCHAR2(30 CHAR))                                       AS ORIGIN_DIVISION_ID
     , CAST(IT.ELECTRODE_TYPE AS VARCHAR2(30 CHAR))                         AS ELECTRODE_TYPE
     , TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD')                           AS PLAN_START_YYYYMMDD_DATE
  FROM EVT                  A
     , FINAL_ITEM           IT
     , ORIGIN_SITE          OS
     , SCM_MST_DIVISION     DM
     , SCM_MST_PLAN         P
 WHERE A.ITEM_ID                    = IT.ITEM_ID(+)
   AND A.SCM_SITE_ID                = OS.SCM_SITE_ID(+)
   AND A.DIVISION_ID                = DM.DIVISION_ID
   AND A.DIVISION_ID                = P.DIVISION_ID(+)
   AND A.PLAN_START_YYYYMMDD        = P.PLAN_NAME(+)
   AND P.PLAN_CYCLE(+)              = 'WEEKLY'
   AND DM.VALID_YN                  = 'Y';
