-- =============================================================================
-- DMF0003_P2_CMBO_CELL_AUTH_20260804.sql  (v2 — 2026-08-04 사용자 방침 반영: 데이터 무변경, 필터/쿼리만 보완)
-- 목적: DMF0003 그리드 셀 Sales Site 콤보의 AS-IS 부서제약 필터 복원 + AS 전용 Incoterms 편집콤보 등록
--
-- 근거 (AS-IS 원문 실측 2026-08-04):
--  [1] 셀 콤보(81/82) = UP_FX_GetCommonDataList 'SiteByEndCustomerAuth' (SP10_DDL L13026):
--      SALES + VALID_YN='Y' + 권한(D) + ⭐부서제약 — @v_group_id='ADMIN' 이면 전체,
--      아니면 SITE.DEPT_ID ∈ ( PM_TEAM_MAPPING(SEGMENT1=사용자부서).SEGMENT3 ∪ 사용자부서(TB_FX_User) ).
--      TO-BE 는 공용 'SiteByEndCustomer'(부서제약 없음) 사용 중 → 부서제약 필터 갭.
--  [2] Incoterms 편집콤보 = 사이트 변경 시 UP_FX_DM 'AS_INCOTERMS'(div,site) 재설정 (.cs L3442):
--      AS 사이트(AS_SITE_PLANT)면 AS 전용 lookup, 아니면 일반. FE(MktFcstGrid)가 AS 사이트 행
--      편집 진입 시 'AsIncotermsEdit' dataMap 으로 스왑 (FE 반영 완료 — CMBO 등록만 필요).
--  [3] 40 셀(SCM_SITE_ID40)은 AS-IS 기본판 'SiteByEndCustomer' 40브랜치(부서제약 없음) → 기존 공용 CMBO 유지.
--
-- ⭐ 데이터 무변경 방침 (2026-08-04 사용자 확정: "Table 데이터는 Insert/Update 하지 않고 Filter/query 만 보완"):
--    TO-BE SCM_MST_SITE.DEPT_ID 는 현재 전건 NULL(이관 미적재). 부서제약 필터에 `A.DEPT_ID IS NULL` 허용을
--    포함해 미적재 사이트는 통과시킨다 → 오늘 동작은 기존과 동일(전 권한 사이트), DEPT_ID 가 적재되는 즉시
--    해당 사이트부터 AS-IS 부서제약이 자동 활성화된다. (AS-IS 는 DEPT_ID 전건 적재 상태라 NULL 케이스 부재)
--
-- ADMIN 판정: AS-IS 는 NowGroupID='ADMIN' 정확 일치 → TO-BE 는 보유그룹 합집합(AUTHUNION 2026-08-04 확정)으로
--             'ADMIN' 그룹 보유 시 전체. 권한(D) = SCM_ADM_USER_GR_UNIT_AUTH_MPG_M(USER_ID, UNIT_TP_CD='D').
-- 정책: INSERT-only(NOT EXISTS) + SHEET_COLUMNS 1건 UPDATE / 감사 'admin' / 멱등 / 테이블 데이터 무변경.
-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV
--   (클라우드 DB 적용물은 QA·DEV 2군데 동시 적용 의무 — 2026-08-04 사용자 확정)
-- =============================================================================

-- [1] CMBO 'SiteByEndCustomerAuth' 신규 등록 (AS-IS L13026 필터 1:1 + DEPT_ID 미적재 허용
--     — DIVISION_ID/END_CUSTOMER 컬럼 반환 = FE GRID_CASCADE_FILTERS 클라 cascade 용)
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'SiteByEndCustomerAuth'
 , 'DM'
 , 'DMF0003 셀 Sales Site (AS-IS Auth 1:1 부서제약)'
 , 'SELECT DISTINCT A.DIVISION_ID, A.END_CUSTOMER, A.SCM_SITE_ID AS CODE, A.SCM_SITE_ID AS NAME' || CHR(10) ||
   'FROM SCM_MST_SITE A' || CHR(10) ||
   'WHERE A.SITE_TYPE = ''SALES''' || CHR(10) ||
   '  AND A.VALID_YN = ''Y''' || CHR(10) ||
   '  AND A.DIVISION_ID IN (SELECT UNIT_ID FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M' || CHR(10) ||
   '                        WHERE USER_ID = @sesUserId AND UNIT_TP_CD = ''D'' AND USE_YN = ''Y'')' || CHR(10) ||
   '  AND ( A.DEPT_ID IS NULL' || CHR(10) ||
   '     OR EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M G' || CHR(10) ||
   '                WHERE G.USER_ID = @sesUserId AND G.USER_GR_ID = ''ADMIN'' AND G.USE_YN = ''Y'')' || CHR(10) ||
   '     OR A.DEPT_ID IN (' || CHR(10) ||
   '          SELECT L.SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL L' || CHR(10) ||
   '          WHERE L.LOOKUP_TYPE = ''PM_TEAM_MAPPING'' AND L.VALID_YN = ''Y''' || CHR(10) ||
   '            AND L.SEGMENT1 IN (SELECT U.DEPT_ID FROM TB_FX_USER U WHERE U.USERID = @sesUserId)' || CHR(10) ||
   '          UNION' || CHR(10) ||
   '          SELECT U.DEPT_ID FROM TB_FX_USER U WHERE U.USERID = @sesUserId))' || CHR(10) ||
   'ORDER BY CODE'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'SiteByEndCustomerAuth');

-- [2] CMBO 'AsIncotermsEdit' 신규 등록 (AS-IS UP_FX_DM 'AS_INCOTERMS' AS분기 1:1 — @divisionId 바인드)
INSERT INTO SCM_MGR.SCM_ADM_CMBO_SQL_M
  (SQL_ID, MDU_DIVS_CD, SQL_NM, SQL_DTL_CTN, USE_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT
   'AsIncotermsEdit'
 , 'DM'
 , 'DMF0003 AS 사이트 전용 Incoterms 편집 (AS-IS AS_INCOTERMS lookup 1:1)'
 , 'SELECT SEGMENT2 AS CODE, ATTRIBUTE1 AS NAME' || CHR(10) ||
   'FROM SCM_ADM_LOOKUP_MASTER_DETAIL' || CHR(10) ||
   'WHERE LOOKUP_TYPE = ''AS_INCOTERMS''' || CHR(10) ||
   '  AND VALID_YN = ''Y''' || CHR(10) ||
   '  AND SEGMENT1 = @divisionId' || CHR(10) ||
   'ORDER BY SEGMENT2'
 , 'Y'
 , 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_CMBO_SQL_M X WHERE X.SQL_ID = 'AsIncotermsEdit');

-- [3] DMF0003 'Mkt Fcst' SCM_SITE_ID 셀 콤보 → Auth판 전환 (SCM_SITE_ID40 은 기존 유지)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET CELL_COMBO_DATA_TYPE = 'SiteByEndCustomerAuth',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE PROGRAM_ID = 'DMF0003' AND SHEET_NAME = 'Mkt Fcst' AND COLUMN_NAME = 'SCM_SITE_ID'
   AND CELL_COMBO_DATA_TYPE = 'SiteByEndCustomer';

COMMIT;

-- ===== 검증 1: CMBO 2본 등록 =====
SELECT SQL_ID, USE_YN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID IN ('SiteByEndCustomerAuth','AsIncotermsEdit');
-- ===== 검증 2: SHEET_COLUMNS 전환 =====
SELECT SHEET_NAME, COLUMN_NAME, CELL_COMBO_DATA_TYPE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
WHERE PROGRAM_ID='DMF0003' AND COLUMN_NAME IN ('SCM_SITE_ID','SCM_SITE_ID40');
-- 원복: [3] 역UPDATE ('SiteByEndCustomerAuth'→'SiteByEndCustomer') + CMBO 2본 DELETE
