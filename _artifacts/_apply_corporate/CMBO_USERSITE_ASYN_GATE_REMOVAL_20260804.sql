-- =============================================================================
-- CMBO_USERSITE_ASYN_GATE_REMOVAL_20260804.sql
-- 목적: Sales Site 콤보 CMBO 의 AS 사이트(@asYn) 게이트 제거 — AS-IS 최신 사양 정합 (D-2 해소)
--
-- 근거 (AS-IS 원문 실측 2026-08-04):
--   AS-IS UP_FX_GetCommonDataList_DM 의 'SiteByEndCustomer'/'SiteByEndCustomer40' 양 분기에서
--   [E20260211-001189] 로 `AND 1 = CASE WHEN @Param5='Y' ...` 게이트가 주석 처리됨
--   → AS_SITE_PLANT(AS 사이트) UNION 은 전 사용자 "무조건 포함" 이 정본 사양.
--   (FE DMF0003_MktFcst.cs L7037 은 PARAM5 를 여전히 전송하지만 SP 가 무시 — cboAS 체크박스도 visible=false)
--   TO-BE CMBO 'UserSiteByEndCustomer'(+사본 'SiteByEndCustomer_DMF0003')는 구사양 게이트
--   `AND NVL(TRIM(@asYn), 'N') = 'Y'` 를 유지 + FE 소비자 전원(DMF0003/DMF0042/Waterfall) asYn 미바인드
--   → AS 사이트 전 사용자 상시 누락 상태였음. 본 패치로 게이트 라인 1줄 제거 = AS-IS 파리티.
--
-- 영향 소비자 (2026-08-04 전수 grep — 전원 asYn 미사용 확인, 회귀 없음):
--   DMF0003 MktFcstForm / DMF0042 BusinessPlanForm(SalesSiteField comboId) / Report SalesPlanWaterfallForm
--   'SiteByEndCustomer'(DMF0021/0020 용, AS union 자체 없음) · 'SalesSite' · 'ScmSitebyEndCustomer40' 은 대상 아님.
--
-- 정책: 게이트 라인만 REPLACE 제거(그 외 본문 무수정) / 멱등(INSTR 가드) / 감사컬럼 'admin'.
-- 백업: BACKUP_CMBO_USERSITE_pre_asyn_removal_20260804.txt (2본 전문)
-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내(2026-08-04 적용 완료) ②클라우드 QA ③클라우드 DEV
--   (클라우드 DB 적용물은 QA·DEV 2군데 동시 적용 의무 — 2026-08-04 사용자 확정)
-- =============================================================================

UPDATE SCM_MGR.SCM_ADM_CMBO_SQL_M
   SET SQL_DTL_CTN     = REPLACE(SQL_DTL_CTN, CHR(10) || '  AND NVL(TRIM(@asYn), ''N'') = ''Y''', ''),
       LAST_UPDATED_BY = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE SQL_ID IN ('UserSiteByEndCustomer', 'SiteByEndCustomer_DMF0003')
   AND DBMS_LOB.INSTR(SQL_DTL_CTN, '@asYn') > 0;

COMMIT;

-- ===== 검증 1: 잔존 @asYn = 0 이어야 함 (2행 모두 0) =====
SELECT SQL_ID, DBMS_LOB.INSTR(SQL_DTL_CTN, '@asYn') AS ASYN_REMAIN
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID IN ('UserSiteByEndCustomer', 'SiteByEndCustomer_DMF0003');

-- ===== 검증 2: AS 사이트 branch 존치 확인 (AS_SITE_PLANT 문자열 > 0 이어야 함) =====
SELECT SQL_ID, DBMS_LOB.INSTR(SQL_DTL_CTN, 'AS_SITE_PLANT') AS AS_BRANCH
FROM   SCM_MGR.SCM_ADM_CMBO_SQL_M
WHERE  SQL_ID IN ('UserSiteByEndCustomer', 'SiteByEndCustomer_DMF0003');
