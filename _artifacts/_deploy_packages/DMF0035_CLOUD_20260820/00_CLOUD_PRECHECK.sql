-- ═══════════════════════════════════════════════════════════════════════════════
-- DMF0035_CLOUD_20260820 / 00_CLOUD_PRECHECK.sql
--   클라우드(QA/DEV) 각각에서 **적용 전** 실행. 결과를 사내 기준선과 대조한 뒤 적용 여부를 판단한다.
--   ⛔ 본 파일은 SELECT 전용 — 아무 것도 변경하지 않는다.
--   기준선 = 2026-08-20 사내 라이브 실측 (SCM_MGR@100.65.143.121:1521/OCGSCMD_P01).
-- ═══════════════════════════════════════════════════════════════════════════════
SET LINESIZE 300
SET PAGESIZE 200

-- ───────────────────────────────────────────────────────────────────────────────
-- C1. PKG 4본 현황 + 마커 기준선 (룰 #136 — 대상 객체 실측)
--     사내 기준선:
--       PKG_SCM0002  BODY VALID  4,259 lines  LAST_DDL 2026-08-20 15:48:02
--       PKG_DMF0035  BODY VALID  4,149 lines  LAST_DDL 2026-08-20 15:53:07
--       PKG_DMF0022  BODY VALID  3,668 lines  LAST_DDL 2026-08-20 16:10:44
--       PKG_DMF0051  BODY VALID  1,760 lines  LAST_DDL 2026-08-07 19:37:58
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C1. PKG 4본 현황 ===
SELECT o.OBJECT_NAME, o.OBJECT_TYPE, o.STATUS, o.LAST_DDL_TIME,
       (SELECT COUNT(*) FROM ALL_SOURCE s
         WHERE s.OWNER = o.OWNER AND s.NAME = o.OBJECT_NAME AND s.TYPE = o.OBJECT_TYPE) AS LINES
  FROM ALL_OBJECTS o
 WHERE o.OWNER = 'SCM_MGR'
   AND o.OBJECT_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002')
 ORDER BY 1, 2;

PROMPT === C1b. 마커 기준선 (적용 전 = 구세대 판정축) ===
--   사내 기준선: WFITEMPERF = 2 / V_MEASURE_SHEET = 6
--   ⚠ V_MEASURE_SHEET = 0 이면 클라우드 PKG_DMF0022 가 08-10 구세대 → SALES PLAN 0행 상태.
SELECT 'PKG_DMF0035 / E20260820-WFITEMPERF' AS MARKER,
       (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
          AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260820-WFITEMPERF%') AS CNT_NOW, 2 AS CNT_EXPECT_AFTER
  FROM DUAL
UNION ALL
SELECT 'PKG_DMF0022 / V_MEASURE_SHEET',
       (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0022'
          AND TYPE='PACKAGE BODY' AND UPPER(TEXT) LIKE '%V_MEASURE_SHEET%'), 6 FROM DUAL
UNION ALL
SELECT 'PKG_DMF0035 / E20260806-WF (통합 기반)',
       (SELECT COUNT(*) FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0035'
          AND TYPE='PACKAGE BODY' AND TEXT LIKE '%E20260806-WF%'), NULL FROM DUAL;

-- ───────────────────────────────────────────────────────────────────────────────
-- C2. GTT 49종 존재 + ⭐ 컬럼 시그니처 대조
--     -955 무시 방식의 맹점 = 이름만 같고 구조가 다른 구세대 GTT 가 조용히 통과한다.
--     아래 컬럼수를 사내 기준선(README §축별 실측 카운트 표 부록)과 대조할 것.
--     차이가 있으면 01_DDL_GTT.sql 적용 전에 해당 GTT 를 DROP 후 재생성해야 한다.
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C2. GTT 존재/구조 (사내 = 49종) ===
SELECT t.TABLE_NAME, t.DURATION,
       (SELECT COUNT(*) FROM ALL_TAB_COLUMNS c
         WHERE c.OWNER = t.OWNER AND c.TABLE_NAME = t.TABLE_NAME) AS COL_CNT
  FROM ALL_TABLES t
 WHERE t.OWNER = 'SCM_MGR' AND t.TEMPORARY = 'Y'
   AND (t.TABLE_NAME LIKE 'GT\_DM22%' ESCAPE '\'
     OR t.TABLE_NAME LIKE 'GT\_DM35%' ESCAPE '\'
     OR t.TABLE_NAME LIKE 'GT\_DM51%' ESCAPE '\'
     OR t.TABLE_NAME LIKE 'GT\_SPNC%' ESCAPE '\')
 ORDER BY 1;

PROMPT === C2b. GTT 총수 (기대 49) ===
SELECT COUNT(*) AS GTT_CNT FROM ALL_TABLES
 WHERE OWNER='SCM_MGR' AND TEMPORARY='Y'
   AND (TABLE_NAME LIKE 'GT\_DM22%' ESCAPE '\' OR TABLE_NAME LIKE 'GT\_DM35%' ESCAPE '\'
     OR TABLE_NAME LIKE 'GT\_DM51%' ESCAPE '\' OR TABLE_NAME LIKE 'GT\_SPNC%' ESCAPE '\');

-- ───────────────────────────────────────────────────────────────────────────────
-- C3. GTT 인덱스 (사내 = 2본, 2026-08-06 PERF 분)
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C3. GTT 인덱스 ===
SELECT i.TABLE_NAME, i.INDEX_NAME,
       LISTAGG(c.COLUMN_NAME, ',') WITHIN GROUP (ORDER BY c.COLUMN_POSITION) AS COLS
  FROM ALL_INDEXES i
  JOIN ALL_IND_COLUMNS c ON c.INDEX_OWNER = i.OWNER AND c.INDEX_NAME = i.INDEX_NAME
 WHERE i.OWNER='SCM_MGR'
   AND (i.TABLE_NAME LIKE 'GT\_DM22%' ESCAPE '\' OR i.TABLE_NAME LIKE 'GT\_DM35%' ESCAPE '\'
     OR i.TABLE_NAME LIKE 'GT\_DM51%' ESCAPE '\' OR i.TABLE_NAME LIKE 'GT\_SPNC%' ESCAPE '\')
 GROUP BY i.TABLE_NAME, i.INDEX_NAME
 ORDER BY 1, 2;

-- ───────────────────────────────────────────────────────────────────────────────
-- C4. ⚠ 공유 CMBO 덮어쓰기 충돌 확인
--     21_CMBO_SYNC.sql 은 7본을 MERGE(UPDATE 포함)한다. 그중 5본은 타 화면도 소비하는 공유 콤보.
--     아래에서 클라우드 본문 길이/갱신일이 사내 기준선과 다르면 **덮어쓸지 판단**한 뒤 적용할 것.
--     사내 기준선(LEN / LAST_UPDATE):
--       QtyType               219  2026-08-06 15:14:25   (DMF0035 작업분 — 덮어쓰기 필요)
--       ReportBucketType      167  2026-08-06 15:21:45   (DMF0035 작업분 — 덮어쓰기 필요)
--       BucketType2           183  2026-07-15 13:01:50   (공유: DMF0042)
--       SenderCode            205  2026-07-23 19:36:18   (공유)
--       ItemType              202  2026-02-20 15:50:53   (공유)
--       UserSiteByEndCustomer 1907 2026-08-04 20:45:06   (공유: SalesSiteField 전 화면)
--       MyDivision            438  2026-02-13 12:05:25   (공유)
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C4. CMBO 7본 현황 ===
SELECT SQL_ID, MDU_DIVS_CD, USE_YN, LENGTH(SQL_DTL_CTN) AS LEN,
       LAST_UPDATED_BY, LAST_UPDATE_DATE
  FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
 WHERE SQL_ID IN ('QtyType','ReportBucketType','BucketType2','SenderCode','ItemType',
                  'UserSiteByEndCustomer','MyDivision')
 ORDER BY 1;

-- ───────────────────────────────────────────────────────────────────────────────
-- C5. LOOKUP 축 (이관 대상 아님 — 공유 마스터. 결손 시 콤보/분기가 조용히 빈다)
--     축 확정 = PKG 4본 + CMBO 7본 소스에서 LOOKUP_TYPE 리터럴 기계 추출 (21종).
--     사내 기준선 행수는 우변 EXPECT 컬럼.
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C5. LOOKUP_TYPE 21종 (0행이면 결손) ===
WITH EXPECT AS (
  SELECT 'AS_SITE_PLANT' T, 18 N FROM DUAL UNION ALL
  SELECT 'BIZ_TYPE_BPMS', 12 FROM DUAL UNION ALL
  SELECT 'BUCKET2_TYPE_CODE', 3 FROM DUAL UNION ALL
  SELECT 'CELL_TYPE', 21 FROM DUAL UNION ALL
  SELECT 'CELL_TYPE_ITEM_CODE', 17 FROM DUAL UNION ALL
  SELECT 'CELL_TYPE_ITEM_GROUP', 6 FROM DUAL UNION ALL
  SELECT 'DM_ETC_PROJECT', 10 FROM DUAL UNION ALL
  SELECT 'DM_MEASURE_POSITIONAL_NOTATION', 29 FROM DUAL UNION ALL
  SELECT 'DM_SALES_PLAN_WATERFALL_SP_W_ADD', 32 FROM DUAL UNION ALL
  SELECT 'EDI_END_CUSTOMER', 16 FROM DUAL UNION ALL
  SELECT 'EDI_SENDER_CODE', 29 FROM DUAL UNION ALL
  SELECT 'GET_ADMIN_GROUP', 9 FROM DUAL UNION ALL
  SELECT 'ITEM_TYPE_CODE', 4 FROM DUAL UNION ALL
  SELECT 'MKT_FCST_UNIT_QTY', 4 FROM DUAL UNION ALL
  SELECT 'PM_TEAM_MAPPING', 375 FROM DUAL UNION ALL
  SELECT 'REPORT_BUCKET_TYPE_CODE', 4 FROM DUAL UNION ALL
  SELECT 'RPA_END_CUSTOMER', 4 FROM DUAL UNION ALL
  SELECT 'SALES_MGMT_TEAM', 6 FROM DUAL UNION ALL
  SELECT 'SALES_PLAN_CATCHUP', 4 FROM DUAL UNION ALL
  SELECT 'SALES_SITE_VS_WAREHOUSE', 2 FROM DUAL UNION ALL
  SELECT 'TMM_MEASURE_ADMIN', 70 FROM DUAL
)
SELECT e.T AS LOOKUP_TYPE, e.N AS CNT_CORP,
       (SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL d WHERE d.LOOKUP_TYPE = e.T) AS CNT_CLOUD
  FROM EXPECT e ORDER BY 1;

-- ───────────────────────────────────────────────────────────────────────────────
-- C6. ⭐ 공유 시트 덮어쓰기 영향 범위 (22_SHEET_META_SYNC.sql 적용 전 필수 확인)
--     22 는 SHEET_NAME 단위 DELETE 후 전량 재적재한다 (hook #98 §9).
--     대상 SHEET_NAME 에 DMF0035 외 프로그램 행이 섞여 있다 — 클라우드 값이 사내와 다르면
--     타 화면(DMF0040 / DMF0051_1 / DMF0021 / DMF0048 / DM0022 / DM0035)에 영향이 간다.
--     사내 기준선:
--       SHEET_COLUMNS 'Mkt Fcst Waterfall'   119 = DMF0035 71 + DMF0040 48
--       SHEET_COLUMNS 'salesPlanWaterfall'    65 = DMF0022 65
--       SHEET_COLUMNS 'Biz Plan Waterfall'   125 = DMF0051 61 + DMF0051_1 64
--       SHEET_MEASURE 'Mkt Fcst Waterfall'    73 = DMF0035 49 + DM0035 24
--       SHEET_MEASURE 'Sales Plan Waterfall'  84 = DMF0022 31 + DM0022 19 + DMF0021 17 + DMF0048 17
--       SHEET_MEASURE 'Biz Plan Waterfall'    16 = DMF0051 9 + DMF0051_1 7
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C6. 공유 시트 영향 범위 ===
SELECT 'SHEET_COLUMNS' AS TBL, SHEET_NAME, PROGRAM_ID, COUNT(*) AS CNT
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
 WHERE SHEET_NAME IN ('Mkt Fcst Waterfall','salesPlanWaterfall','Biz Plan Waterfall')
 GROUP BY SHEET_NAME, PROGRAM_ID
UNION ALL
SELECT 'SHEET_MEASURE', SHEET_NAME, PROGRAM_ID, COUNT(*)
  FROM SCM_MGR.SCM_MST_SHEET_MEASURE
 WHERE SHEET_NAME IN ('Mkt Fcst Waterfall','Sales Plan Waterfall','Biz Plan Waterfall')
 GROUP BY SHEET_NAME, PROGRAM_ID
 ORDER BY 1, 2, 3;

-- ───────────────────────────────────────────────────────────────────────────────
-- C7. 메뉴/버튼/권한/API 축 기준선
--     사내: MNU_M 1 / PROGRAM 1 / MNU_BTN_MPG_M 8 / USER_GR_MNU_MPG_M 5
--           USER_GR_MNU_BTN_MPG_M 40 / API_M 8 / EXCEL_COLUMNS 0
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C7. 메뉴/버튼/권한 축 ===
SELECT 'SCM_ADM_MNU_M' TBL, COUNT(*) CNT, 1 EXPECT FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID='DMF0035'
UNION ALL SELECT 'SCM_ADM_PROGRAM', COUNT(*), 1 FROM SCM_MGR.SCM_ADM_PROGRAM WHERE PROGRAM_ID='DMF0035'
UNION ALL SELECT 'SCM_ADM_MNU_BTN_MPG_M', COUNT(*), 8 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035'
UNION ALL SELECT 'SCM_ADM_USER_GR_MNU_MPG_M', COUNT(*), 5 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='DMF0035'
UNION ALL SELECT 'SCM_ADM_USER_GR_MNU_BTN_MPG_M', COUNT(*), 40 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0035'
UNION ALL SELECT 'SCM_ADM_API_M(DMF0035_%)', COUNT(*), 8 FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID LIKE 'DMF0035\_%' ESCAPE '\'
UNION ALL SELECT 'SCM_ADM_EXCEL_COLUMNS', COUNT(*), 0 FROM SCM_MGR.SCM_ADM_EXCEL_COLUMNS WHERE PROGRAM_ID='DMF0035'
UNION ALL SELECT 'SCM_MST_TITLESET_USER(제외축)', COUNT(*), NULL FROM SCM_MGR.SCM_MST_TITLESET_USER WHERE PROGRAM_ID='DMF0035';

-- ───────────────────────────────────────────────────────────────────────────────
-- C8. GRANT / SYNONYM 현황 (DMF0014 PLS-00201 사고 계보 — 메타만 고쳐도 실패)
--     사내: SCMD_APP/SCMP_APP EXECUTE 4본 × 2 = 8 / 시노님 4본 × 2 = 8
--           (+ RL_SCM_DML 이 PKG_DMF0035 에 EXECUTE/DEBUG — 롤 경유, 이관 선택)
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C8a. EXECUTE GRANT ===
SELECT GRANTEE, TABLE_NAME, PRIVILEGE, GRANTOR FROM ALL_TAB_PRIVS
 WHERE TABLE_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002')
 ORDER BY 2, 1, 3;

PROMPT === C8b. SYNONYM ===
SELECT OWNER, SYNONYM_NAME, TABLE_OWNER, TABLE_NAME FROM ALL_SYNONYMS
 WHERE TABLE_NAME IN ('PKG_DMF0035','PKG_DMF0022','PKG_DMF0051','PKG_SCM0002')
 ORDER BY 1, 2;

-- ───────────────────────────────────────────────────────────────────────────────
-- C9. MSG/LBL/MNU 22코드 현황 (사내 = 22코드 × 3언어 = 66행)
-- ───────────────────────────────────────────────────────────────────────────────
PROMPT === C9. MSG/LBL/MNU ===
SELECT MSG_ID, COUNT(*) AS LANG_CNT, MAX(LAST_UPDATE_DATE) AS LAST_UPD
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('LBL00001','LBL00031','LBL00090','LBL00112','LBL00608','LBL00627',
                  'LBL00664','LBL00665','LBL00687','LBL00710','LBL00852','LBL00853',
                  'LBL00854','MNU00179','MNU00020','MNU00691','MSG00013','MSG00097',
                  'MSG00108','MSG00137','MSG00164','MSG00283')
 GROUP BY MSG_ID ORDER BY 1;
