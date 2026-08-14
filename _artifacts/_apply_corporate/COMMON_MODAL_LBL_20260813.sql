-- ============================================================================
-- 공용 Measure/Column 모달 LBL 채번 (2026-08-13)
-- 근거: 공용 정본(master measureSelectModal/columnLayoutModal 호출부)이 LBL00764/765 를
--   참조하나 DB·locales 모두 미채번(런타임 fallback 표시) — hook #114 3점 동시 반영.
--   값 = fallback 실표기 그대로 (Invisible/Visible), KO=EN=CN 통일 룰. 764/765 = 미사용 갭 번호 실측.
-- 적용 후: nscm-fe 에서 pnpm gen:i18n (locales JSON 재생성 — 3점 중 ②③)
-- ============================================================================
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT T.MI, T.LC, T.NM, 'LBL', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (
    SELECT 'LBL00764' MI, 'KO' LC, 'Invisible' NM FROM DUAL UNION ALL
    SELECT 'LBL00764', 'EN', 'Invisible' FROM DUAL UNION ALL
    SELECT 'LBL00764', 'CN', 'Invisible' FROM DUAL UNION ALL
    SELECT 'LBL00765', 'KO', 'Visible' FROM DUAL UNION ALL
    SELECT 'LBL00765', 'EN', 'Visible' FROM DUAL UNION ALL
    SELECT 'LBL00765', 'CN', 'Visible' FROM DUAL
  ) T
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M X WHERE X.MSG_ID = T.MI AND X.LANG_CD = T.LC);
