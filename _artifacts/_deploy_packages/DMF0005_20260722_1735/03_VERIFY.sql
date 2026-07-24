-- ============================================================================
-- [DMF0005 PERF 20260722] Step 4: 배포 후 검증
-- ============================================================================

-- 1) 패키지 상태: PACKAGE / PACKAGE BODY 모두 VALID
SELECT object_type, status FROM user_objects WHERE object_name = 'PKG_DMF0005';

-- 2) 컴파일 오류: 0행
SELECT line, position, text FROM user_errors WHERE name = 'PKG_DMF0005' ORDER BY sequence;

-- 3) 변경 마커: 12행 (P1~P6)
SELECT COUNT(*) AS marker_lines
  FROM user_source
 WHERE name = 'PKG_DMF0005' AND type = 'PACKAGE BODY'
   AND text LIKE '%[PERF-DMF0005 20260722]%';

-- 4) GTT 7종 존재 (SYS$SESSION)
SELECT table_name, duration
  FROM user_tables
 WHERE table_name IN ('GT_GGET_SPLIT_TEAM_ID','GT_GGET_SPLIT_CUSTOMER','GT_GGET_SPLIT_SCM_SITE_ID',
                      'GT_GGET_SPLIT_VALID_YN','GT_GGET_SPLIT_ITEM_ID','GT_GGET_SPLIT_PROJECT_CODE',
                      'GT_GGET_SPLIT_OWNER')
 ORDER BY table_name;

-- 5) FBI: VALID / ENABLED
SELECT index_name, status, funcidx_status FROM user_indexes WHERE index_name = 'IDX02_SCM_MST_SSO_USER_INFO';

-- 6) 실행 smoke ('81' 기본 조회 — 3초 내외, 행수 > 0)
--    DBeaver 등에서:
--    DECLARE
--        O_RC1 SYS_REFCURSOR; O_RESULT SYS_REFCURSOR;
--    BEGIN
--        PKG_DMF0005.P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION(
--            '81','ALL','ALL','ALL','','','Y','','minyonglee1', O_RC1, O_RESULT);
--    END;
--    /
