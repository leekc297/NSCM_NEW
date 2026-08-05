-- ============================================================================
-- MSG00454 / MSG00455 사내 등록 — DMF0082 ExchangeRateModal BPS I/F 성공/실패 안내
-- 근거: Doc/단위테스트/_결함대장_TestCases4.1.md D5 (2026-08-02)
--       FE ExchangeRateModal.tsx L198~203 이 t('MSG00454'/'MSG00455') 사용 중이나
--       사내 SCM_ADM_MSG_M 전 LANG 0행 (결번 — 타 화면 선점 없음 실측 2026-08-02).
--       locales JSON 3종 (KO/EN/CN) 은 2026-08-02 로컬 등록 완료 — 본 SQL 은 사내 MSG_M 동기.
-- DDL: SCM_ADM_MSG_M (MSG_ID/LANG_CD/MSG_TP_CD/USE_YN/감사 4컬럼 = NOT NULL, MSG_DESC nullable)
-- 멱등: NOT EXISTS — 기존재 시 무수정 skip. 감사컬럼 = 'admin' (룰 — claude ID 금지)
-- ============================================================================

INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT t.MSG_ID, t.LANG_CD, t.MSG_NM, 'MSG', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT 'MSG00454' AS MSG_ID, 'KO' AS LANG_CD, '환율 정보가 정상적으로 반영되었습니다.' AS MSG_NM FROM DUAL UNION ALL
    SELECT 'MSG00454', 'EN', 'Exchange rate information has been applied successfully.' FROM DUAL UNION ALL
    SELECT 'MSG00454', 'CN', '汇率信息已成功应用.' FROM DUAL UNION ALL
    SELECT 'MSG00455', 'KO', '환율 정보 반영에 실패했습니다.' FROM DUAL UNION ALL
    SELECT 'MSG00455', 'EN', 'Failed to apply exchange rate information.' FROM DUAL UNION ALL
    SELECT 'MSG00455', 'CN', '汇率信息应用失败.' FROM DUAL
) t
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_MSG_M m WHERE m.MSG_ID = t.MSG_ID AND m.LANG_CD = t.LANG_CD
);

-- 검증 (기대 6행): SELECT MSG_ID, LANG_CD, MSG_NM, USE_YN FROM SCM_ADM_MSG_M
--                 WHERE MSG_ID IN ('MSG00454','MSG00455') ORDER BY MSG_ID, LANG_CD;
-- 적용 결과: 2026-08-02 사내 6행 INSERT + 검증 통과 (CREATED_BY=admin)
COMMIT;
