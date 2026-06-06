--==============================================================================
-- 60_DMF0072_lookup_meta_boost.sql
--
-- DMF0072 (NN Master Mapping) lookup combo 5종 메타 보강
--   - DataType / Division (공용 DMF0008 SP 재사용) / Team / EndCustomer / SalesSite
--
-- 배경 (2026-06-02):
--   기존 44_DMF0072_meta.sql 은 메인 SP 2건 (GET/SAVE) 만 등록.
--   조회 조건 dropdown 5종 (BLOCK 2 API_M / BLOCK 3 BTN_MPG / BLOCK 4 PROC_M) 누락 발견.
--   사용자 명시 요구 (2026-06-02): "신규 화면 압축 파일 생성 중 누락 항목 추가 요청".
--
-- 멱등성: BLOCK 1~5 모두 NOT EXISTS 패턴 — 재실행 시 충돌 없음.
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
WHENEVER SQLERROR EXIT FAILURE

PROMPT === BLOCK 1 : MSG_M (5 건 lookup) ===
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, 'KO', 'API', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MSG_API_DMF0072_DATATYPE_GET'   AS MSG_ID, 'DMF0072 DataType lookup'      AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0072_DIVISION_GET',            'DMF0072 Division lookup'                FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0072_TEAM_GET',                'DMF0072 Team lookup'                    FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0072_ENDCUST_GET',             'DMF0072 EndCustomer lookup'             FROM DUAL UNION ALL
    SELECT 'MSG_API_DMF0072_SALESSITE_GET',           'DMF0072 SalesSite lookup'               FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID=NEW.MSG_ID AND X.LANG_CD='KO');

PROMPT === BLOCK 2 : API_M (5 건 lookup) ===
INSERT INTO SCM_MGR.SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.API_ID, NEW.API_TP_CD, NEW.API_MSG_ID, NEW.API_MSG_DESC, NEW.API_URL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- 자체 SP
    SELECT 'P_DMF0072_DATATYPE_GET'    AS API_ID, 'PROC_SELECT' AS API_TP_CD, 'MSG_API_DMF0072_DATATYPE_GET'   AS API_MSG_ID, 'DataType lookup'    AS API_MSG_DESC, 'DMF0072_GET_DATA_TYPE_LIST'    AS API_URL FROM DUAL UNION ALL
    SELECT 'P_DMF0072_TEAM_GET',                  'PROC_SELECT',              'MSG_API_DMF0072_TEAM_GET',                    'Team lookup',                       'DMF0072_GET_TEAM_LIST'                    FROM DUAL UNION ALL
    SELECT 'P_DMF0072_ENDCUST_GET',               'PROC_SELECT',              'MSG_API_DMF0072_ENDCUST_GET',                 'EndCustomer lookup',                'DMF0072_GET_END_CUSTOMER_LIST'            FROM DUAL UNION ALL
    SELECT 'P_DMF0072_SALESSITE_GET',             'PROC_SELECT',              'MSG_API_DMF0072_SALESSITE_GET',               'SalesSite lookup',                  'DMF0072_GET_SALES_SITE_LIST'              FROM DUAL UNION ALL
    -- 공용 SP 재사용 (DMF0008_GET_MY_DIVISION_LIST) — API_ID 만 별도, URL 은 동일 SP
    SELECT 'P_DMF0072_DIVISION_GET',              'PROC_SELECT',              'MSG_API_DMF0072_DIVISION_GET',                'Division lookup (공용 SP 재사용)',  'DMF0008_GET_MY_DIVISION_LIST'             FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_API_M X WHERE X.API_ID=NEW.API_ID);

PROMPT === BLOCK 3 : BTN_MPG (5 건 lookup) ===
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0072', NEW.SHT_NM, NEW.MNU_BTN_CD, NEW.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'dataType'    AS SHT_NM, 'SEARCH' AS MNU_BTN_CD, 'P_DMF0072_DATATYPE_GET'   AS API_ID FROM DUAL UNION ALL
    SELECT 'division',              'SEARCH',                'P_DMF0072_DIVISION_GET'              FROM DUAL UNION ALL
    SELECT 'team',                  'SEARCH',                'P_DMF0072_TEAM_GET'                  FROM DUAL UNION ALL
    SELECT 'endCustomer',           'SEARCH',                'P_DMF0072_ENDCUST_GET'               FROM DUAL UNION ALL
    SELECT 'salesSite',             'SEARCH',                'P_DMF0072_SALESSITE_GET'             FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X WHERE X.MNU_ID='DMF0072' AND X.SHT_NM=NEW.SHT_NM AND X.MNU_BTN_CD=NEW.MNU_BTN_CD);

PROMPT === BLOCK 4 : PROC_M (9 row — 4 lookup SP) ===
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.PROC_NM, NEW.COL_NM, NEW.DATA_TP_CD, NEW.COL_TP_CD, NEW.SORT_ORD, 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    -- DMF0072_GET_DATA_TYPE_LIST (1 row)
    SELECT 'DMF0072_GET_DATA_TYPE_LIST'     AS PROC_NM, 'o_rc1'         AS COL_NM, 'CURSOR'  AS DATA_TP_CD, 'OUT' AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    -- DMF0072_GET_TEAM_LIST (2 row)
    SELECT 'DMF0072_GET_TEAM_LIST',                   'divisionId',                 'VARCHAR',              'IN',                1                FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_TEAM_LIST',                   'o_rc1',                      'CURSOR',               'OUT',               2                FROM DUAL UNION ALL
    -- DMF0072_GET_END_CUSTOMER_LIST (3 row)
    SELECT 'DMF0072_GET_END_CUSTOMER_LIST',           'divisionId',                 'VARCHAR',              'IN',                1                FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_END_CUSTOMER_LIST',           'deptId',                     'VARCHAR',              'IN',                2                FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_END_CUSTOMER_LIST',           'o_rc1',                      'CURSOR',               'OUT',               3                FROM DUAL UNION ALL
    -- DMF0072_GET_SALES_SITE_LIST (3 row)
    SELECT 'DMF0072_GET_SALES_SITE_LIST',             'divisionId',                 'VARCHAR',              'IN',                1                FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_SALES_SITE_LIST',             'endCustomer',                'VARCHAR',              'IN',                2                FROM DUAL UNION ALL
    SELECT 'DMF0072_GET_SALES_SITE_LIST',             'o_rc1',                      'CURSOR',               'OUT',               3                FROM DUAL
  ) NEW
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_PROC_M X WHERE X.PROC_NM=NEW.PROC_NM AND X.COL_NM=NEW.COL_NM AND X.COL_TP_CD=NEW.COL_TP_CD);

PROMPT === BLOCK 5 : GUEST 권한 (5 건 신규 BTN 자동 복제) ===
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
 WHERE BTN.MNU_ID='DMF0072'
   AND BTN.SHT_NM IN ('dataType','division','team','endCustomer','salesSite')
   AND BTN.USE_YN='Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
                    WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID=BTN.MNU_ID
                      AND X.SHT_NM=BTN.SHT_NM AND X.MNU_BTN_CD=BTN.MNU_BTN_CD);

PROMPT === BLOCK 6 : 사후 카운트 ===
SELECT 'POST: MSG_M lookup (5)'      AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID LIKE 'MSG_API_DMF0072_%' AND LANG_CD='KO'
UNION ALL SELECT 'POST: API_M lookup (5)',         COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN ('P_DMF0072_DATATYPE_GET','P_DMF0072_DIVISION_GET','P_DMF0072_TEAM_GET','P_DMF0072_ENDCUST_GET','P_DMF0072_SALESSITE_GET')
UNION ALL SELECT 'POST: BTN_MPG lookup (5)',       COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0072' AND SHT_NM IN ('dataType','division','team','endCustomer','salesSite')
UNION ALL SELECT 'POST: PROC_M lookup (9)',        COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ('DMF0072_GET_DATA_TYPE_LIST','DMF0072_GET_TEAM_LIST','DMF0072_GET_END_CUSTOMER_LIST','DMF0072_GET_SALES_SITE_LIST')
UNION ALL SELECT 'POST: GUEST BTN (5)',            COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE USER_GR_ID='GUEST' AND MNU_ID='DMF0072' AND SHT_NM IN ('dataType','division','team','endCustomer','salesSite');

COMMIT;
PROMPT === 60_DMF0072_lookup_meta_boost.sql 완료 ===
