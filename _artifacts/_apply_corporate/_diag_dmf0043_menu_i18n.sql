-- ============================================================================
-- DIAG : DMF0043 / DMF0043_01 메뉴 명칭 i18n + MNU_DESC 현재 값 점검
-- ============================================================================

PROMPT === 1. SCM_ADM_MSG_M (i18n) — KO/EN/CN row ===
SELECT MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU_DMF0043','MNU_DMF0043_01')
 ORDER BY MSG_ID, LANG_CD;

PROMPT === 2. SCM_ADM_MNU_M — MNU_DESC + MNU_NM + MNU_MSG_ID ===
SELECT MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0043','DMF0043_01');

PROMPT === 3. 자매 화면 (DMF0041~DMF0045) 패턴 참고 — MNU_DESC 영문 사례 ===
SELECT MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID LIKE 'DMF004%'
 ORDER BY MNU_ID;
