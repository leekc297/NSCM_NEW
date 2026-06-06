--==============================================================================
-- 200_DMF0072_MNU_URL_Slug_Check.sql
--
-- 목적:
--   DMF0072 화면 오픈 시 URL `/master/demand-master/n-n-master-mapping` 으로 호출되나
--   실제 FE 폴더 = `nn-master-mapping`. slug 불일치 → 404.
--   DB SCM_ADM_MNU_M.MNU_URL 의 등록값 확인.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET LINESIZE 200

PROMPT === DIAG 1 : DMF0072 MNU_URL 등록값 ===

SELECT mnu_id, mnu_url, uppr_mnu_id, mnu_tp_cd, use_yn
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_id = 'DMF0072';

PROMPT === DIAG 2 : 자매 화면 (Demand_Master) 의 MNU_URL 인벤토리 — slug naming 패턴 비교 ===

SELECT mnu_id, mnu_url, mnu_tp_cd
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE uppr_mnu_id = 'Demand_Master'
   AND mnu_tp_cd = 'SCREEN'
 ORDER BY mnu_id;

PROMPT === DIAG 3 : 'n-n' 패턴 MNU_URL 검색 (잘못 등록된 slug) ===

SELECT mnu_id, mnu_url
  FROM SCM_MGR.SCM_ADM_MNU_M
 WHERE mnu_url LIKE '%n-n-%'
    OR mnu_url LIKE '%-n-n%'
 ORDER BY mnu_id;

PROMPT === 판독 ===
PROMPT - DIAG 1 : MNU_URL 가 'n-n-master-mapping' 이면 → 'nn-master-mapping' 으로 UPDATE 필요
PROMPT - DIAG 2 : 자매 화면 slug 패턴 cross-check
PROMPT - DIAG 3 : 다른 화면도 동일 사고 패턴 있는지
