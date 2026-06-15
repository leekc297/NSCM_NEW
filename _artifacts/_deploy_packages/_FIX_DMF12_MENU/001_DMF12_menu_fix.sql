--======================================================================
-- 001_DMF12_menu_fix.sql
-- 목적: DMF12 신규 화면 메뉴 연결 fix (hook menu-not-displayed-debug 7단계)
-- 사고 6건:
--   #1 URL slug 8건 — DB `dmf0014` → FE `customer-fcst-upload` 불일치
--   #2 UPPR_MNU_ID 3건 — DMF0042/0044/0049 = Demand_Plan → Bizplan/Sales_Report
--   #3 부모 메뉴 2건 누락 — BIZPLAN, SALES_REPORT 미등록
--   #4 자식 3건 누락 — DMF0042_1/2/3 row 자체 없음
--   #5 i18n 5건 누락 — MNU_BIZPLAN/SALES_REPORT/DMF0042_1/2/3
--   #6 권한 누락 — 3 그룹 × 신규 5 메뉴 = 15 row
-- 사용자 요구:
--   "메뉴명칭은 기존에 있던 한글 사용시에도 기존에 등록되어 있던 영문명칭으로 해주세요"
-- 멱등성: NOT EXISTS / MERGE — 재실행 안전
-- 작성: 2026-06-08 (minyonglee1)
--======================================================================

SET DEFINE OFF;
SET SERVEROUTPUT ON SIZE UNLIMITED;
SET LINESIZE 200
SET PAGESIZE 100

PROMPT
PROMPT === BLOCK 1: i18n 메시지 INSERT (5 신규 MSG_ID × 3 LANG = 15 row) ===

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, NEW.MSG_NM, 'MNU', 'Y', 'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
FROM (
  SELECT 'MNU_BIZPLAN'     AS MSG_ID, 'KO' AS LANG_CD, 'Biz Plan'          AS MSG_NM FROM DUAL UNION ALL
  SELECT 'MNU_BIZPLAN',          'EN', 'Biz Plan'          FROM DUAL UNION ALL
  SELECT 'MNU_BIZPLAN',          'CN', 'Biz Plan'          FROM DUAL UNION ALL
  SELECT 'MNU_SALES_REPORT',     'KO', 'Sales Report'      FROM DUAL UNION ALL
  SELECT 'MNU_SALES_REPORT',     'EN', 'Sales Report'      FROM DUAL UNION ALL
  SELECT 'MNU_SALES_REPORT',     'CN', 'Sales Report'      FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_1',        'KO', 'Business Plan 1'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_1',        'EN', 'Business Plan 1'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_1',        'CN', 'Business Plan 1'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_2',        'KO', 'Business Plan 2'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_2',        'EN', 'Business Plan 2'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_2',        'CN', 'Business Plan 2'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_3',        'KO', 'Business Plan 3'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_3',        'EN', 'Business Plan 3'   FROM DUAL UNION ALL
  SELECT 'MNU_DMF0042_3',        'CN', 'Business Plan 3'   FROM DUAL
) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M E
  WHERE E.MSG_ID = NEW.MSG_ID AND E.LANG_CD = NEW.LANG_CD
);

PROMPT
PROMPT === BLOCK 2: 신규 부모 메뉴 2건 INSERT (Bizplan, Sales_Report — UPPR=Report) ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_M (
  MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC,
  SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT NEW.MNU_ID, NEW.UPPR_MNU_ID, NEW.MNU_URL, NEW.MNU_MSG_ID, NEW.MNU_DESC,
       NEW.SORT_ORD, NEW.MNU_LV_NO, 'MENU', '-', 'Y',
       'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
FROM (
  SELECT 'Bizplan'      AS MNU_ID, 'Report' AS UPPR_MNU_ID, 'biz-plan'     AS MNU_URL, 'MNU_BIZPLAN'      AS MNU_MSG_ID, 'Biz Plan'     AS MNU_DESC, 2 AS SORT_ORD, 2 AS MNU_LV_NO FROM DUAL UNION ALL
  SELECT 'Sales_Report',          'Report',                  'sales-report',                'MNU_SALES_REPORT',                   'Sales Report',              4,             2             FROM DUAL
) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M E WHERE E.MNU_ID = NEW.MNU_ID
);

PROMPT
PROMPT === BLOCK 3: 자식 신규 메뉴 3건 INSERT (DMF0042_1/2/3 — UPPR=Bizplan) ===

INSERT INTO SCM_MGR.SCM_ADM_MNU_M (
  MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC,
  SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT NEW.MNU_ID, 'Bizplan', NEW.MNU_URL, NEW.MNU_MSG_ID, NEW.MNU_DESC,
       NEW.SORT_ORD, 3, 'SCREEN', 'D', 'Y',
       'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
FROM (
  SELECT 'DMF0042_1' AS MNU_ID, 'business-plan-1' AS MNU_URL, 'MNU_DMF0042_1' AS MNU_MSG_ID, 'Business Plan 1' AS MNU_DESC, 81 AS SORT_ORD FROM DUAL UNION ALL
  SELECT 'DMF0042_2',            'business-plan-2',                'MNU_DMF0042_2',                  'Business Plan 2',                82                    FROM DUAL UNION ALL
  SELECT 'DMF0042_3',            'business-plan-3',                'MNU_DMF0042_3',                  'Business Plan 3',                83                    FROM DUAL
) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M E WHERE E.MNU_ID = NEW.MNU_ID
);

PROMPT
PROMPT === BLOCK 4: URL slug UPDATE (8 화면 — DB 소문자 dmf0014 → FE 의미 slug) ===

UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='customer-fcst-upload', LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0014' AND MNU_URL<>'customer-fcst-upload';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='sales-plan',           LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0021' AND MNU_URL<>'sales-plan';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='business-plan',        LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0042' AND MNU_URL<>'business-plan';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='sales-reports',        LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0044' AND MNU_URL<>'sales-reports';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='sales-monitoring',     LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0048' AND MNU_URL<>'sales-monitoring';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='etc-sales-reports',    LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0049' AND MNU_URL<>'etc-sales-reports';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='metal-link-price',     LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0074' AND MNU_URL<>'metal-link-price';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='mkt-forecast-auto',    LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0081' AND MNU_URL<>'mkt-forecast-auto';

PROMPT
PROMPT === BLOCK 5: UPPR_MNU_ID UPDATE (3 화면 — Demand_Plan → Bizplan/Sales_Report) ===

UPDATE SCM_MGR.SCM_ADM_MNU_M SET UPPR_MNU_ID='Bizplan',      LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0042' AND UPPR_MNU_ID<>'Bizplan';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET UPPR_MNU_ID='Sales_Report', LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0044' AND UPPR_MNU_ID<>'Sales_Report';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET UPPR_MNU_ID='Sales_Report', LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0049' AND UPPR_MNU_ID<>'Sales_Report';

PROMPT
PROMPT === BLOCK 6: 권한 INSERT (USER_GR_MNU_MPG_M — 3 그룹 × 신규 5 메뉴 = 15 row) ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M (
  USER_GR_ID, MNU_ID, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT NEW.USER_GR_ID, NEW.MNU_ID, 'Y',
       'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
FROM (
  SELECT 'ADMIN'     AS USER_GR_ID, 'Bizplan'      AS MNU_ID FROM DUAL UNION ALL
  SELECT 'ADMIN',                   'Sales_Report'           FROM DUAL UNION ALL
  SELECT 'ADMIN',                   'DMF0042_1'              FROM DUAL UNION ALL
  SELECT 'ADMIN',                   'DMF0042_2'              FROM DUAL UNION ALL
  SELECT 'ADMIN',                   'DMF0042_3'              FROM DUAL UNION ALL
  SELECT 'DM ADMIN',                'Bizplan'                FROM DUAL UNION ALL
  SELECT 'DM ADMIN',                'Sales_Report'           FROM DUAL UNION ALL
  SELECT 'DM ADMIN',                'DMF0042_1'              FROM DUAL UNION ALL
  SELECT 'DM ADMIN',                'DMF0042_2'              FROM DUAL UNION ALL
  SELECT 'DM ADMIN',                'DMF0042_3'              FROM DUAL UNION ALL
  SELECT 'DM Viewer',               'Bizplan'                FROM DUAL UNION ALL
  SELECT 'DM Viewer',               'Sales_Report'           FROM DUAL UNION ALL
  SELECT 'DM Viewer',               'DMF0042_1'              FROM DUAL UNION ALL
  SELECT 'DM Viewer',               'DMF0042_2'              FROM DUAL UNION ALL
  SELECT 'DM Viewer',               'DMF0042_3'              FROM DUAL
) NEW
WHERE NOT EXISTS (
  SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M E
  WHERE E.USER_GR_ID = NEW.USER_GR_ID AND E.MNU_ID = NEW.MNU_ID
);

COMMIT;

PROMPT
PROMPT === BLOCK 7: POST-VERIFY (각 BLOCK 결과 카운트) ===

SELECT 'i18n MNU 신규' AS chk, COUNT(*) AS cnt FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('MNU_BIZPLAN','MNU_SALES_REPORT','MNU_DMF0042_1','MNU_DMF0042_2','MNU_DMF0042_3')
UNION ALL SELECT '부모 메뉴 2건 (Bizplan/Sales_Report)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('Bizplan','Sales_Report')
UNION ALL SELECT '자식 신규 3건 (DMF0042_1/2/3)',         COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('DMF0042_1','DMF0042_2','DMF0042_3')
UNION ALL SELECT 'URL slug 의미 (= 8건 OK)',              COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('DMF0014','DMF0021','DMF0042','DMF0044','DMF0048','DMF0049','DMF0074','DMF0081') AND MNU_URL NOT LIKE 'dmf%'
UNION ALL SELECT 'UPPR fix (= 3건 Bizplan/Sales_Report)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M WHERE MNU_ID IN ('DMF0042','DMF0044','DMF0049') AND UPPR_MNU_ID IN ('Bizplan','Sales_Report')
UNION ALL SELECT '권한 신규 15건',                        COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M WHERE USER_GR_ID IN ('ADMIN','DM ADMIN','DM Viewer') AND MNU_ID IN ('Bizplan','Sales_Report','DMF0042_1','DMF0042_2','DMF0042_3');

PROMPT
PROMPT === BLOCK 8: 12 화면 최종 상태 ===

SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_DESC, MNU_TP_CD, USE_YN
FROM SCM_MGR.SCM_ADM_MNU_M
WHERE MNU_ID IN ('DMF0014','DMF0021','DMF0042','DMF0042_1','DMF0042_2','DMF0042_3','DMF0044','DMF0048','DMF0049','DMF0074','DMF0081','DMF0082','Bizplan','Sales_Report')
ORDER BY DECODE(UPPR_MNU_ID, 'Demand_Plan', 1, 'Bizplan', 2, 'Sales_Report', 3, 'Report', 0, 9), SORT_ORD, MNU_ID;

PROMPT
PROMPT 완료 (전체 fix). 사용자 브라우저 F12 → Application → Clear site data → 새로고침.
