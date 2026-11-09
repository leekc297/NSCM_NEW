-- SOURCE-FRESH: SCM_MGR.SCP_PLN_SALES_ONHAND_V VIEW LAST_DDL=2026-10-27 13:37:07 FETCHED=2026-11-06 22:23 DB=ZIOUI1 (착수 기준본 · 원복용)

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SCM_MGR"."SCP_PLN_SALES_ONHAND_V" ("MASTER_ID", "PLAN_ID", "OUT_VERSION_ID", "DIVISION_ID", "PLAN_START_YYYYMMDD", "PLAN_TYPE", "SEQ", "OPERATION_GROUP", "ITEM_ID", "SITE_ID", "YYYYMMDD", "PSI_BOH_QTY", "PSI_IN_QTY", "PSI_OUT_QTY", "PSI_EOH_QTY", "CREATED_BY", "CREATION_DATE", "LAST_UPDATED_BY", "LAST_UPDATE_DATE", "ATTRIBUTE1", "ATTRIBUTE2", "ATTRIBUTE3", "ATTRIBUTE4", "ATTRIBUTE5", "ATTRIBUTE6", "ATTRIBUTE7", "ATTRIBUTE8", "ATTRIBUTE9", "ATTRIBUTE10", "ATTRIBUTE11", "ATTRIBUTE12", "ATTRIBUTE13", "ATTRIBUTE14", "ATTRIBUTE15", "ORIGIN_DIVISION_ID", "ELECTRODE_TYPE", "PLAN_START_YYYYMMDD_DATE") AS 
  WITH SALES_SITE AS
     (  /* 판매사이트 목록 — 생성기의 EOH 판매사이트 판정(SITE_TYPE='SALES')과 동일 */
      SELECT S.SCM_SITE_ID
        FROM SCM_MST_SITE                   S
       WHERE S.SITE_TYPE                    = 'SALES'
         AND S.VALID_YN                     = 'Y'
       GROUP BY S.SCM_SITE_ID
     )
   , ORIGIN_SITE AS
     (  /* 사이트 대표(최소) 소속 사업부 — AS-IS 적재 프로시저의 MIN(DIVISION_ID) 산식 동형 */
      SELECT S.SCM_SITE_ID
           , MIN(S.DIVISION_ID)                  AS MIN_DIVISION_ID
        FROM SCM_MST_SITE                   S
       WHERE S.VALID_YN                     = 'Y'
       GROUP BY S.SCM_SITE_ID
     )
   , FINAL_ITEM AS
     (  /* 품목 원장 — AS-IS 적재와 동일하게 FINAL ITEM 존재 품목만, ELECTRODE_TYPE 복원 */
      SELECT I.ITEM_ID
           , MAX(I.ELECTRODE_TYPE)               AS ELECTRODE_TYPE
        FROM SCP_MST_FINAL_ITEM_V           I
       GROUP BY I.ITEM_ID
     )
   , PSI AS
     (  /* 통합 Dataset → 판매사이트 × 품목 × 일자 그레인 피벗 (신형식 PLAN_ID 런만) */
      SELECT M.PLAN_ID                           AS OPT_PLAN_ID
           , M.PLAN_START_YYYYMMDD
           , M.DIVISION_ID
           , M.OPERATION_GROUP
           , M.ITEM_ID
           , M.SCM_SITE_ID
           , M.YYYYMMDD
           , SUM(CASE WHEN M.MEASURE = 'EOH'   THEN M.QTY ELSE 0 END)  AS EOH_QTY
           , SUM(CASE WHEN M.MEASURE = 'WH_IN' THEN M.QTY ELSE 0 END)  AS IN_QTY
           , SUM(CASE WHEN M.PSI_TYPE = 'S'    THEN M.QTY ELSE 0 END)  AS OUT_QTY
        FROM SCP_EGN_OTPT_PSI_M             M
           , SALES_SITE                     SS
       WHERE M.SCM_SITE_ID                  = SS.SCM_SITE_ID
         AND M.MEASURE                     IN ('EOH', 'WH_IN', 'SHIPPING', 'CONSUME', 'RTF')
         AND REGEXP_LIKE(REGEXP_SUBSTR(M.PLAN_ID, '[^-]+$'), '^[0-9]+$')   /* 신형식(SEQ 숫자) 런만 — 구포맷 파일럿 배제·TO_NUMBER 가드 */
       GROUP BY M.PLAN_ID
           , M.PLAN_START_YYYYMMDD
           , M.DIVISION_ID
           , M.OPERATION_GROUP
           , M.ITEM_ID
           , M.SCM_SITE_ID
           , M.YYYYMMDD
     )
SELECT A.DIVISION_ID || '::WEEKLY'               AS MASTER_ID
     , P.PLAN_ID                                 AS PLAN_ID
     , CASE WHEN P.PLAN_ID IS NULL
            THEN NULL
            ELSE P.PLAN_ID || '::' || REGEXP_SUBSTR(A.OPT_PLAN_ID, '([^-]+)-[^-]+$', 1, 1, NULL, 1)
                           || '::' || REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$')
       END                                       AS OUT_VERSION_ID
     , A.DIVISION_ID
     , A.PLAN_START_YYYYMMDD
     , REGEXP_SUBSTR(A.OPT_PLAN_ID, '([^-]+)-[^-]+$', 1, 1, NULL, 1)   AS PLAN_TYPE
     , TO_NUMBER(REGEXP_SUBSTR(A.OPT_PLAN_ID, '[^-]+$'))               AS SEQ
     , A.OPERATION_GROUP
     , A.ITEM_ID
     , A.SCM_SITE_ID                             AS SITE_ID
     , A.YYYYMMDD
     , ROUND(A.EOH_QTY - A.IN_QTY + A.OUT_QTY, 10)                     AS PSI_BOH_QTY   /* = 전일 EOH + 당일 IS */
     , A.IN_QTY                                  AS PSI_IN_QTY
     , A.OUT_QTY                                 AS PSI_OUT_QTY
     , A.EOH_QTY                                 AS PSI_EOH_QTY
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS CREATED_BY
     , CAST(NULL AS DATE)                        AS CREATION_DATE
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS LAST_UPDATED_BY
     , CAST(NULL AS DATE)                        AS LAST_UPDATE_DATE
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE1
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE2
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE3
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE4
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE5
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE6
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE7
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE8
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE9
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE10
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE11
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE12
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE13
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE14
     , CAST(NULL AS VARCHAR2(200 CHAR))          AS ATTRIBUTE15
     , CASE WHEN DM.ATTRIBUTE3 = 'EE'
            THEN OS.MIN_DIVISION_ID              /* 전극 가상 사업부 : 사이트 대표 사업부 */
            WHEN OS.MIN_DIVISION_ID = A.DIVISION_ID
            THEN A.DIVISION_ID                   /* 그 외 : 자기 사업부 소속 사이트만 */
       END                                       AS ORIGIN_DIVISION_ID
     , IT.ELECTRODE_TYPE
     , TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD')                      AS PLAN_START_YYYYMMDD_DATE
  FROM PSI                  A
     , FINAL_ITEM           IT
     , ORIGIN_SITE          OS
     , SCM_MST_DIVISION     DM
     , SCM_MST_PLAN         P
 WHERE A.ITEM_ID                    = IT.ITEM_ID
   AND A.SCM_SITE_ID                = OS.SCM_SITE_ID(+)
   AND A.DIVISION_ID                = DM.DIVISION_ID
   AND A.DIVISION_ID                = P.DIVISION_ID(+)
   AND A.PLAN_START_YYYYMMDD        = P.PLAN_NAME(+)
   AND P.PLAN_CYCLE(+)              = 'WEEKLY'
   AND DM.VALID_YN                  = 'Y';
