-- DBeaver 호환 (PROMPT/SET/SQL*Plus 명령 0건) — 메모리 feedback_dbeaver_sql_mandatory_grep
-- 본 파일은 001_DMF12_menu_fix.sql 의 DML 부분만 추출 (멱등 — 재실행 안전)

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

UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='customer-fcst-upload', LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0014' AND MNU_URL<>'customer-fcst-upload';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='sales-plan',           LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0021' AND MNU_URL<>'sales-plan';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='business-plan',        LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0042' AND MNU_URL<>'business-plan';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='sales-reports',        LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0044' AND MNU_URL<>'sales-reports';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='sales-monitoring',     LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0048' AND MNU_URL<>'sales-monitoring';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='etc-sales-reports',    LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0049' AND MNU_URL<>'etc-sales-reports';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='metal-link-price',     LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0074' AND MNU_URL<>'metal-link-price';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET MNU_URL='mkt-forecast-auto',    LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0081' AND MNU_URL<>'mkt-forecast-auto';

UPDATE SCM_MGR.SCM_ADM_MNU_M SET UPPR_MNU_ID='Bizplan',      LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0042' AND UPPR_MNU_ID<>'Bizplan';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET UPPR_MNU_ID='Sales_Report', LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0044' AND UPPR_MNU_ID<>'Sales_Report';
UPDATE SCM_MGR.SCM_ADM_MNU_M SET UPPR_MNU_ID='Sales_Report', LAST_UPDATED_BY='minyonglee1', LAST_UPDATE_DATE=SYSDATE WHERE MNU_ID='DMF0049' AND UPPR_MNU_ID<>'Sales_Report';

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
