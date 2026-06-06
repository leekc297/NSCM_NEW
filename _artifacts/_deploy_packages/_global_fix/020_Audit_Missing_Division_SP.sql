--==============================================================================
-- 020_Audit_Missing_Division_SP.sql
--
-- 목적:
--   DMF0008_GET_MY_DIVISION_LIST 같은 미존재 SP 가 API_M 에 잔존하는 화면 인벤토리.
--   NextSCM Pilot 메타 자동 변환 사고 패턴.
--
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET LINESIZE 250

PROMPT === DIAG 1 : 미존재 SP 를 가리키는 API_M 인벤토리 ===

SELECT api.api_id, api.api_url,
       (SELECT COUNT(*) FROM all_objects o
         WHERE o.owner='SCM_MGR' AND o.object_name = api.api_url
           AND o.object_type IN ('PROCEDURE','PACKAGE')) AS sp_exists
  FROM SCM_MGR.SCM_ADM_API_M api
 WHERE api.api_url IS NOT NULL
   AND api.api_url NOT LIKE '%.%'  -- standalone path 만 (PKG path 제외)
   AND NOT EXISTS (
     SELECT 1 FROM all_objects o
      WHERE o.owner = 'SCM_MGR'
        AND o.object_name = api.api_url
        AND o.object_type IN ('PROCEDURE','PACKAGE')
   )
 ORDER BY api.api_url, api.api_id;

PROMPT === DIAG 2 : DMF0008_GET_MY_DIVISION_LIST 가리키는 모든 API_ID ===

SELECT api.api_id, api.api_url, btn.mnu_id, btn.sht_nm
  FROM SCM_MGR.SCM_ADM_API_M api
  LEFT JOIN SCM_MGR.SCM_ADM_MNU_BTN_MPG_M btn ON btn.api_id = api.api_id
 WHERE api.api_url = 'DMF0008_GET_MY_DIVISION_LIST'
 ORDER BY btn.mnu_id, api.api_id;

PROMPT === 판독 ===
PROMPT - DIAG 1 : 미존재 SP 잔존 인벤토리 (각각 표준 patch 필요)
PROMPT - DIAG 2 : DMF0008_GET_MY_DIVISION_LIST 가리키는 모든 화면 — 일괄 fix 대상
