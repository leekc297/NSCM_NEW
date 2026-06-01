--==============================================================================
-- 40_Register_5_DMF_Menus_in_Demand_Master_DBeaver.sql  (DBeaver 실행 버전)
--
-- 본체 40_*.sql 에서 SQL*Plus 전용 명령 (SET / PROMPT / WHENEVER / EXIT / "/")
-- 을 제거하고 DBeaver Ctrl+Enter 단일문 실행에 안전한 형태로 재작성.
--
-- 멱등성: 모든 INSERT 는 NOT EXISTS 가드. 재실행 시 0 행 영향.
-- 검증     : _Verify.sql (단일 UNION ALL SELECT)
-- 진단     : _Diagnose.sql
--
-- 작성: 2026-05-30
--==============================================================================

-- ========== BLOCK 1 : SCM_ADM_MSG_M i18n 메시지 INSERT (12 행) ==========

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

-- ========== BLOCK 2 : SCM_ADM_MNU_M 메뉴 INSERT (5 행) ==========

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

-- ========== BLOCK 3 : SCM_ADM_USER_GR_MNU_MPG_M GUEST 메뉴 권한 INSERT (5 행) ==========

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

COMMIT;
