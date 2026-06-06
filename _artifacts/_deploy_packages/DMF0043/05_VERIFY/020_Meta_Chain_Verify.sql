--==============================================================================
-- 020_Meta_Chain_Verify.sql
--
-- 목적: DMF0043 의 메뉴-버튼 → API → PROC 메타 routing chain 정합 검증
--       (MNU_BTN_MPG_M ← API_M ← PROC_M LEFT JOIN)
-- 실행: SCM_MGR 또는 SCMD_APP 세션. READ-ONLY
-- 작성: 2026-06-04
--
-- 본 fix 가 적용된 후의 정상 상태:
--   - SCM_ADM_MNU_M.MNU_URL  = 'contribute-main' / 'contribute-view' (slug 정합)
--   - SCM_ADM_API_M.API_URL  = standalone path (PKG_DMF0043. prefix 없음)
--   - SCM_ADM_PROC_M.PROC_NM = standalone path (위와 동일)
--   - chain 끊김 없음 (모두 PASS)
--==============================================================================
SET LINESIZE 250
SET PAGESIZE 200
SET SERVEROUTPUT ON

PROMPT === VERIFY 1 : DMF0043 / DMF0043_01 MNU_URL slug 정합 ===

SELECT mnu_id, mnu_url,
       CASE
         WHEN mnu_id = 'DMF0043'    AND mnu_url = 'contribute-main' THEN 'PASS'
         WHEN mnu_id = 'DMF0043_01' AND mnu_url = 'contribute-view' THEN 'PASS'
         ELSE 'FAIL: slug mismatch (FE Router 와 정합 X)'
       END AS RESULT
  FROM scm_adm_mnu_m
 WHERE mnu_id IN ('DMF0043', 'DMF0043_01');

PROMPT === VERIFY 2 : SCM_ADM_API_M / SCM_ADM_PROC_M 의 PKG path 잔존 (FAIL 시 030_META/040 재실행) ===

SELECT 'API_M' AS source, api_id AS name, api_url AS value
  FROM scm_adm_api_m
 WHERE api_id LIKE '%DMF0043%'
   AND (api_url LIKE 'PKG_DMF0043.%' OR api_url LIKE 'PKG_DMF0043_%')
UNION ALL
SELECT 'PROC_M', proc_nm, col_nm
  FROM scm_adm_proc_m
 WHERE proc_nm LIKE 'PKG_DMF0043%';

PROMPT === VERIFY 3 : DMF0043 / DMF0043_01 메뉴-버튼 → API → PROC chain ===

SELECT btn.mnu_id, btn.sht_nm, btn.mnu_btn_cd, btn.api_id AS btn_api_id,
       api.api_url,
       (SELECT COUNT(*) FROM scm_adm_proc_m p WHERE p.proc_nm = api.api_url) AS proc_m_col_cnt,
       CASE
         WHEN api.api_url IS NULL THEN 'FAIL: API_M missing for ' || btn.api_id
         WHEN (SELECT COUNT(*) FROM scm_adm_proc_m p WHERE p.proc_nm = api.api_url) = 0
           THEN 'FAIL: PROC_M missing for ' || api.api_url
         ELSE 'PASS'
       END AS result
  FROM scm_adm_mnu_btn_mpg_m btn
  LEFT JOIN scm_adm_api_m api ON api.api_id = btn.api_id
 WHERE btn.mnu_id IN ('DMF0043', 'DMF0043_01')
 ORDER BY btn.mnu_id, btn.sht_nm, btn.mnu_btn_cd;

PROMPT === VERIFY 4 : GUEST 권한 (메뉴 + 버튼) 등록 여부 ===

SELECT 'MENU_PERM' AS perm_type,
       (SELECT COUNT(*) FROM scm_adm_user_gr_mnu_mpg_m
         WHERE user_gr_id = 'GUEST' AND mnu_id IN ('DMF0043', 'DMF0043_01')) AS gr_perm_count,
       'expect 2' AS expected
  FROM dual
UNION ALL
SELECT 'BTN_PERM',
       (SELECT COUNT(*) FROM scm_adm_user_gr_mnu_btn_mpg_m
         WHERE user_gr_id = 'GUEST' AND mnu_id IN ('DMF0043', 'DMF0043_01')),
       'expect > 0 (DMF0043 10 button + DMF0043_01 5 button)'
  FROM dual;

PROMPT === VERIFY 5 : main/SEARCH 단일 시나리오 — caller 호출 시 PROC param 인벤토리 ===

SELECT p.col_nm, p.data_tp_cd, p.col_tp_cd, p.sort_ord
  FROM scm_adm_mnu_btn_mpg_m btn
       JOIN scm_adm_api_m  api ON api.api_id = btn.api_id
       JOIN scm_adm_proc_m p   ON p.proc_nm = api.api_url
 WHERE btn.mnu_id = 'DMF0043' AND btn.sht_nm = 'main' AND btn.mnu_btn_cd = 'SEARCH'
 ORDER BY p.sort_ord;

PROMPT === 판독 ===
PROMPT - VERIFY 1 2 row PASS → OK
PROMPT - VERIFY 2 0 row → OK (PKG path 잔존 없음)
PROMPT - VERIFY 3 모든 row RESULT=PASS → OK
PROMPT - VERIFY 4 MENU=2, BTN > 0 → OK
PROMPT - VERIFY 5 expect 7 row (yyyy/verSeq/dis/his/sesUserId/userGroup IN + o_rc1 OUT)
