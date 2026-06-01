--==============================================================================
-- 40_Register_5_DMF_Menus_in_Demand_Master.sql  (SQL*Plus 본체)
--
-- 목적:
--   Demand Master 부모 메뉴 아래에 5 화면을 일괄 등록 (Phase 0).
--   - DMF0043     contribute-main      Contribute Main
--   - DMF0043_01  contribute-view      Contribute View
--   - DMF0008     erp-edi-master       ERP EDI Master
--   - DMF0072     nn-master-mapping    N:N Master Mapping
--   - DMF0020     sales-future-price   Sales Future Price
--
--   이전에 39_Cleanup_5_DMF_Screens_Dev.sql 로 5 화면의 모든 DB 메타가 삭제됨.
--   본 SQL 은 메뉴 가시화 (UI 트리 노출) 까지만 수행.
--   각 화면의 PROC/API/BTN/PERM 메타는 후속 41~45 화면별 SQL 로 등록.
--
-- BLOCK 구조:
--   B0  사전 카운트
--   B1  SCM_ADM_MSG_M    i18n 메시지 12 행 (DMF0020 은 기존 보존, 나머지 4 화면 × 3 lang)
--   B2  SCM_ADM_MNU_M    메뉴 5 행 (Demand_Master 부모, MNU_LV_NO=3, MNU_TP_CD=SCREEN)
--   B3  SCM_ADM_USER_GR_MNU_MPG_M  GUEST 그룹 메뉴 권한 5 행
--   B4  사후 카운트 (메인 검증은 _Verify.sql 에서 별도 수행)
--
-- 멱등성: 모든 INSERT 는 NOT EXISTS 가드. 재실행 시 0 행 영향.
--
-- 작성: 2026-05-30
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON
SET LINESIZE 200
SET PAGESIZE 100
WHENEVER SQLERROR EXIT FAILURE

PROMPT
PROMPT === BLOCK 0 : 사전 카운트 ===

SELECT 'PRE: MSG_M (5 MNU msg)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU_DMF0043','MNU_DMF0043_01','MNU_DMF0008','MNU_DMF0072','MNU_DMF0020')
UNION ALL
SELECT 'PRE: MNU_M (5 screens)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')
UNION ALL
SELECT 'PRE: GUEST PERM', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID='GUEST' AND MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020');

PROMPT
PROMPT === BLOCK 1 : SCM_ADM_MSG_M i18n 메시지 INSERT (12 행, DMF0020 은 기존 보존) ===
PROMPT (DMF0043 / 0043_01 / 0008 / 0072 = 4 화면 × 3 lang = 12)

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, MSG_DESC, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MSG_ID, NEW.LANG_CD, 'MNU', NEW.MSG_NM, NEW.MSG_NM, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'MNU_DMF0043'    AS MSG_ID, 'KO' AS LANG_CD, '해외법인 기여율 등록'            AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MNU_DMF0043',           'EN', 'Contribute Main'                                FROM DUAL UNION ALL
    SELECT 'MNU_DMF0043',           'CN', '海外法人贡献率'                                  FROM DUAL UNION ALL
    SELECT 'MNU_DMF0043_01',        'KO', '기여율 조회'                                     FROM DUAL UNION ALL
    SELECT 'MNU_DMF0043_01',        'EN', 'Contribute View'                                FROM DUAL UNION ALL
    SELECT 'MNU_DMF0043_01',        'CN', '贡献率查询'                                       FROM DUAL UNION ALL
    SELECT 'MNU_DMF0008',           'KO', 'ERP EDI 마스터'                                  FROM DUAL UNION ALL
    SELECT 'MNU_DMF0008',           'EN', 'ERP EDI Master'                                 FROM DUAL UNION ALL
    SELECT 'MNU_DMF0008',           'CN', 'ERP EDI 主数据'                                  FROM DUAL UNION ALL
    SELECT 'MNU_DMF0072',           'KO', 'N:N 마스터 매핑'                                  FROM DUAL UNION ALL
    SELECT 'MNU_DMF0072',           'EN', 'N:N Master Mapping'                             FROM DUAL UNION ALL
    SELECT 'MNU_DMF0072',           'CN', 'N:N主数据映射'                                    FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X
    WHERE X.MSG_ID = NEW.MSG_ID AND X.LANG_CD = NEW.LANG_CD
 );

PROMPT
PROMPT === BLOCK 2 : SCM_ADM_MNU_M 메뉴 INSERT (5 행) ===
PROMPT (UPPR_MNU_ID=Demand_Master / MNU_LV_NO=3 / MNU_TP_CD=SCREEN / UNIT_TP_CD=D / SORT_ORD 60~100)

INSERT INTO SCM_MGR.SCM_ADM_MNU_M
  (MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, UNIT_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT NEW.MNU_ID, 'Demand_Master', NEW.MNU_URL, NEW.MNU_MSG_ID, NEW.MNU_DESC, NEW.SORT_ORD, 3, 'SCREEN', 'D', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'DMF0043'    AS MNU_ID, 'contribute-main'    AS MNU_URL, 'MNU_DMF0043'    AS MNU_MSG_ID, 'Contribute Main'    AS MNU_DESC,  60 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'DMF0043_01',        'contribute-view',        'MNU_DMF0043_01',           'Contribute View',                  70 FROM DUAL UNION ALL
    SELECT 'DMF0008',           'erp-edi-master',         'MNU_DMF0008',              'ERP EDI Master',                   80 FROM DUAL UNION ALL
    SELECT 'DMF0072',           'nn-master-mapping',      'MNU_DMF0072',              'N:N Master Mapping',               90 FROM DUAL UNION ALL
    SELECT 'DMF0020',           'sales-future-price',     'MNU_DMF0020',              'Sales Future Price',              100 FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_M X WHERE X.MNU_ID = NEW.MNU_ID
 );

PROMPT
PROMPT === BLOCK 3 : SCM_ADM_USER_GR_MNU_MPG_M GUEST 메뉴 권한 INSERT (5 행) ===

INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
  (USER_GR_ID, MNU_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', NEW.MNU_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'DMF0043'    AS MNU_ID FROM DUAL UNION ALL
    SELECT 'DMF0043_01'           FROM DUAL UNION ALL
    SELECT 'DMF0008'              FROM DUAL UNION ALL
    SELECT 'DMF0072'              FROM DUAL UNION ALL
    SELECT 'DMF0020'              FROM DUAL
  ) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M X
    WHERE X.USER_GR_ID = 'GUEST' AND X.MNU_ID = NEW.MNU_ID
 );

PROMPT
PROMPT === BLOCK 4 : 사후 카운트 ===

SELECT 'POST: MSG_M (5 MNU msg)' AS K, COUNT(*) AS V FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU_DMF0043','MNU_DMF0043_01','MNU_DMF0008','MNU_DMF0072','MNU_DMF0020')
UNION ALL
SELECT 'POST: MNU_M (5 screens)', COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')
UNION ALL
SELECT 'POST: GUEST PERM', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID='GUEST' AND MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020');

COMMIT;

PROMPT
PROMPT === COMPLETE ===
EXIT;
