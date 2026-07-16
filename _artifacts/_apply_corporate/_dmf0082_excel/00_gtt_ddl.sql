/*=====================================================================================================================================================
 * File        : 00_gtt_ddl.sql
 * Program ID  : DMF0082 Excel Upload — GTT DDL (신규 5종)
 * Description : DMF0082_GET_EXCEL_UPLOAD_DATA 전용 GTT 5종 신규 생성 DDL
 *               (AS-IS #FCST_PRICE_EXCEL / #FCST_PRICE_UNPIVOT / #FCST_PRICE_BUCKET / #FCST_PRICE_WEEKLY / #FCST_PRICE_DAILY)
 *
 *               ⚠️ 본 파일은 "파일 산출물"이며 DB 에 적용하지 않았음 (작업 지시: DB 적용 절대 금지).
 *
 * 재사용 실측 (2026-07-12, SCM_MGR@OCGSCMD_P01 SELECT 실측):
 *   - DMF0082_GET_MAIN_DATA_CURRENT 용 GTT 는 기존 GTT_* family 12종 전량 재사용 (신규 생성 불필요):
 *       GTT_TEMP_DM_MST_ITEM_SINGLE_V / GTT_TEMPSITEITEMALL / GTT_TEMPSITEITEM / GTT_TEMPSELECTMEASURE
 *       GTT_T_LAST_DATA_SETUP_FCST / GTT_T_LAST_DATA_SETUP_PRICE / GTT_T_WS_FCST / GTT_TEMPFCSTNPRICE
 *       GTT_TEMP_INTO_GROUP_MEASURE / GTT_TEMP_ADMIN_GROUP_MEASURE / GTT_CAL_MONTH_END_DATE / GTT_CAL_WEEK_END_DATE / GTT_MF_SP
 *       (AS-IS CURRENT #temp 13종과 컬럼 1:1 일치 — ALL_TAB_COLUMNS 실측 완료)
 *   - DMF0082_EXCEL_UPLOAD 는 활성 코드에 #temp 없음 (temp 는 주석 블록에만 존재) — GTT 불필요.
 *   - GT_DMF0082_% / GTT_% / %FCST_PRICE% 검색 결과 아래 5종은 미존재 → 본 파일에서 신규 정의.
 *
 * 규칙 적용:
 *   - GTT 는 ON COMMIT PRESERVE ROWS (커넥션 풀 재사용 대비, SP 시작부에서 DELETE FROM 의무 — 부록 C-2/C-5)
 *   - GLOBAL_TEMP_TABLE_STATS = SESSION (19c)
 *   - MAIN KEY 인덱스 (oracle-sp-perf 룰 4)
 *   - SCMD_APP 은 SP(정의자 권한) 경유 접근이므로 GTT 직접 GRANT 는 필수 아님. 단, 진단 편의를 위해 SELECT GRANT + SYNONYM 포함.
 *=====================================================================================================================================================
 * Date         In Charge    Description
 *=====================================================================================================================================================
 * 2026-07-12   Claude       최초 작성 (MSSQL dbo.DMF0082_GET_EXCEL_UPLOAD_DATA #temp 5종 → GTT 변환)
 *===================================================================================================================================================*/

--------------------------------------------------------------------------------
-- 1. GT_DMF0082_FCST_PRICE_EXCEL  (AS-IS #FCST_PRICE_EXCEL)
--    SCM_ADM_EXCEL_UPLOAD 의 SUCCESS 행 (코드 10 + 명칭 5 + 월버킷 M4~M16 13)
--------------------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL
(
    DIVISION_ID           VARCHAR2(100 CHAR)
  , END_CUSTOMER          VARCHAR2(100 CHAR)
  , SCM_SITE_ID           VARCHAR2(100 CHAR)
  , ITEM_ID               VARCHAR2(100 CHAR)
  , INCOTERMS             VARCHAR2(100 CHAR)
  , FCST_TYPE             VARCHAR2(100 CHAR)
  , DOM_EXP               VARCHAR2(100 CHAR)
  , CELL_PROD_SITE        VARCHAR2(100 CHAR)
  , CURRENCY              VARCHAR2(100 CHAR)
  , MEASURE               VARCHAR2(100 CHAR)
  , END_CUSTOMER_NAME     VARCHAR2(300 CHAR)
  , SCM_SITE_ID_NAME      VARCHAR2(300 CHAR)
  , FCST_TYPE_NAME        VARCHAR2(300 CHAR)
  , CELL_PROD_SITE_NAME   VARCHAR2(300 CHAR)
  , MEASURE_NAME          VARCHAR2(300 CHAR)
  , M4                    VARCHAR2(100 CHAR)
  , M5                    VARCHAR2(100 CHAR)
  , M6                    VARCHAR2(100 CHAR)
  , M7                    VARCHAR2(100 CHAR)
  , M8                    VARCHAR2(100 CHAR)
  , M9                    VARCHAR2(100 CHAR)
  , M10                   VARCHAR2(100 CHAR)
  , M11                   VARCHAR2(100 CHAR)
  , M12                   VARCHAR2(100 CHAR)
  , M13                   VARCHAR2(100 CHAR)
  , M14                   VARCHAR2(100 CHAR)
  , M15                   VARCHAR2(100 CHAR)
  , M16                   VARCHAR2(100 CHAR)
)
ON COMMIT PRESERVE ROWS;

--------------------------------------------------------------------------------
-- 2. GT_DMF0082_FCST_PRICE_UNPIVOT  (AS-IS #FCST_PRICE_UNPIVOT)
--    월버킷 UNPIVOT (M4~M16 → YYYYMM/QTY)
--------------------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT
(
    DIVISION_ID           VARCHAR2(100 CHAR)
  , END_CUSTOMER          VARCHAR2(100 CHAR)
  , SCM_SITE_ID           VARCHAR2(100 CHAR)
  , ITEM_ID               VARCHAR2(100 CHAR)
  , INCOTERMS             VARCHAR2(100 CHAR)
  , FCST_TYPE             VARCHAR2(100 CHAR)
  , DOM_EXP               VARCHAR2(100 CHAR)
  , CELL_PROD_SITE        VARCHAR2(100 CHAR)
  , CURRENCY              VARCHAR2(100 CHAR)
  , MEASURE               VARCHAR2(100 CHAR)
  , END_CUSTOMER_NAME     VARCHAR2(300 CHAR)
  , SCM_SITE_ID_NAME      VARCHAR2(300 CHAR)
  , FCST_TYPE_NAME        VARCHAR2(300 CHAR)
  , CELL_PROD_SITE_NAME   VARCHAR2(300 CHAR)
  , MEASURE_NAME          VARCHAR2(300 CHAR)
  , KEY_VALUE             VARCHAR2(1000 CHAR)
  , YYYYMM                VARCHAR2(6 CHAR)
  , QTY                   NUMBER(23,2)
)
ON COMMIT PRESERVE ROWS;

--------------------------------------------------------------------------------
-- 3. GT_DMF0082_FCST_PRICE_BUCKET  (AS-IS #FCST_PRICE_BUCKET)
--    MKT_FCST 월수량을 나눠야 할 대상 주차(버킷 요일 포함 주차)
--------------------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET
(
    DIVISION_ID           VARCHAR2(100 CHAR)
  , END_CUSTOMER          VARCHAR2(100 CHAR)
  , SCM_SITE_ID           VARCHAR2(100 CHAR)
  , ITEM_ID               VARCHAR2(100 CHAR)
  , INCOTERMS             VARCHAR2(100 CHAR)
  , FCST_TYPE             VARCHAR2(100 CHAR)
  , DOM_EXP               VARCHAR2(100 CHAR)
  , CELL_PROD_SITE        VARCHAR2(100 CHAR)
  , CURRENCY              VARCHAR2(100 CHAR)
  , MEASURE               VARCHAR2(100 CHAR)
  , KEY_VALUE             VARCHAR2(1000 CHAR)
  , BASIS_YYYYMM          VARCHAR2(6 CHAR)
  , BASIS_YYYYMMDD        VARCHAR2(8 CHAR)
  , ISO_YYYYWW            VARCHAR2(20 CHAR)
)
ON COMMIT PRESERVE ROWS;

--------------------------------------------------------------------------------
-- 4. GT_DMF0082_FCST_PRICE_WEEKLY  (AS-IS #FCST_PRICE_WEEKLY)
--    MKT_FCST 주차별 분배 수량
--------------------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY
(
    DIVISION_ID           VARCHAR2(100 CHAR)
  , END_CUSTOMER          VARCHAR2(100 CHAR)
  , SCM_SITE_ID           VARCHAR2(100 CHAR)
  , ITEM_ID               VARCHAR2(100 CHAR)
  , INCOTERMS             VARCHAR2(100 CHAR)
  , FCST_TYPE             VARCHAR2(100 CHAR)
  , DOM_EXP               VARCHAR2(100 CHAR)
  , CELL_PROD_SITE        VARCHAR2(100 CHAR)
  , CURRENCY              VARCHAR2(100 CHAR)
  , MEASURE               VARCHAR2(100 CHAR)
  , KEY_VALUE             VARCHAR2(1000 CHAR)
  , YYYYMM                VARCHAR2(6 CHAR)
  , ISO_YYYYWW            VARCHAR2(20 CHAR)
  , WEEK_DAY_CNT          NUMBER
  , MONTHLY_QTY           NUMBER(23,2)
  , WEEKLY_QTY            NUMBER(23,2)
)
ON COMMIT PRESERVE ROWS;

--------------------------------------------------------------------------------
-- 5. GT_DMF0082_FCST_PRICE_DAILY  (AS-IS #FCST_PRICE_DAILY)
--    MKT_FCST 일자별 분배 수량 + LOC 일자별 PRICE
--------------------------------------------------------------------------------
CREATE GLOBAL TEMPORARY TABLE SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY
(
    DIVISION_ID           VARCHAR2(100 CHAR)
  , END_CUSTOMER          VARCHAR2(100 CHAR)
  , SCM_SITE_ID           VARCHAR2(100 CHAR)
  , ITEM_ID               VARCHAR2(100 CHAR)
  , INCOTERMS             VARCHAR2(100 CHAR)
  , FCST_TYPE             VARCHAR2(100 CHAR)
  , DOM_EXP               VARCHAR2(100 CHAR)
  , CELL_PROD_SITE        VARCHAR2(100 CHAR)
  , CURRENCY              VARCHAR2(100 CHAR)
  , MEASURE               VARCHAR2(100 CHAR)
  , KEY_VALUE             VARCHAR2(1000 CHAR)
  , YYYYMM                VARCHAR2(6 CHAR)
  , BASIS_YYYYMMDD        VARCHAR2(8 CHAR)
  , ISO_YYYYWW            VARCHAR2(20 CHAR)
  , BUCKET_CNT            NUMBER
  , MONTHLY_QTY           NUMBER(23,2)
  , WEEKLY_QTY            NUMBER(23,2)
  , LAST_DAY_YN           VARCHAR2(1 CHAR)     /* AS-IS '' AS LAST_DAY_YN → Oracle NULL (C-7: '' = NULL) */
  , DAILY_QTY             NUMBER(23,2)
)
ON COMMIT PRESERVE ROWS;

--------------------------------------------------------------------------------
-- 인덱스 (oracle-sp-perf 룰 4 — JOIN/GROUP 키)
--------------------------------------------------------------------------------
CREATE INDEX SCM_MGR.IX_GT_D82_FP_UNPIVOT_01 ON SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT (KEY_VALUE, YYYYMM);
CREATE INDEX SCM_MGR.IX_GT_D82_FP_BUCKET_01  ON SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET  (KEY_VALUE, BASIS_YYYYMM, ISO_YYYYWW);
CREATE INDEX SCM_MGR.IX_GT_D82_FP_WEEKLY_01  ON SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY  (KEY_VALUE, YYYYMM, ISO_YYYYWW);
CREATE INDEX SCM_MGR.IX_GT_D82_FP_DAILY_01   ON SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY   (KEY_VALUE, BASIS_YYYYMMDD);

--------------------------------------------------------------------------------
-- GTT 통계 옵션 (19c: 세션 단위 통계)
--------------------------------------------------------------------------------
EXEC DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_FCST_PRICE_EXCEL'  ,'GLOBAL_TEMP_TABLE_STATS','SESSION');
EXEC DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_FCST_PRICE_UNPIVOT','GLOBAL_TEMP_TABLE_STATS','SESSION');
EXEC DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_FCST_PRICE_BUCKET' ,'GLOBAL_TEMP_TABLE_STATS','SESSION');
EXEC DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_FCST_PRICE_WEEKLY' ,'GLOBAL_TEMP_TABLE_STATS','SESSION');
EXEC DBMS_STATS.SET_TABLE_PREFS('SCM_MGR','GT_DMF0082_FCST_PRICE_DAILY'  ,'GLOBAL_TEMP_TABLE_STATS','SESSION');

--------------------------------------------------------------------------------
-- (선택) 진단 편의용 GRANT + SYNONYM — SP 는 정의자(SCM_MGR) 권한으로 접근하므로 필수 아님
--------------------------------------------------------------------------------
GRANT SELECT ON SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL   TO SCMD_APP;
GRANT SELECT ON SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT TO SCMD_APP;
GRANT SELECT ON SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET  TO SCMD_APP;
GRANT SELECT ON SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY  TO SCMD_APP;
GRANT SELECT ON SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY   TO SCMD_APP;

CREATE OR REPLACE SYNONYM SCMD_APP.GT_DMF0082_FCST_PRICE_EXCEL   FOR SCM_MGR.GT_DMF0082_FCST_PRICE_EXCEL;
CREATE OR REPLACE SYNONYM SCMD_APP.GT_DMF0082_FCST_PRICE_UNPIVOT FOR SCM_MGR.GT_DMF0082_FCST_PRICE_UNPIVOT;
CREATE OR REPLACE SYNONYM SCMD_APP.GT_DMF0082_FCST_PRICE_BUCKET  FOR SCM_MGR.GT_DMF0082_FCST_PRICE_BUCKET;
CREATE OR REPLACE SYNONYM SCMD_APP.GT_DMF0082_FCST_PRICE_WEEKLY  FOR SCM_MGR.GT_DMF0082_FCST_PRICE_WEEKLY;
CREATE OR REPLACE SYNONYM SCMD_APP.GT_DMF0082_FCST_PRICE_DAILY   FOR SCM_MGR.GT_DMF0082_FCST_PRICE_DAILY;
