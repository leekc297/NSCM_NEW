--==============================================================================
-- 050_DMF0043_01_API_PROC_Path_Fix.sql
--
-- 원인: 클라우드 SCM_ADM_API_M / SCM_ADM_PROC_M 의 API_URL/PROC_NM 가
--       'PKG_DMF0043.P_DMF0043_*' (legacy) 로 잘못 저장되어 있을 수 있음.
--       DMF0043_01 의 routing 도 동일 사고 (DMF0043 패턴 #4) 위험.
--       standalone path 로 정합.
--
-- 멱등: REGEXP_REPLACE + WHERE 가드 (재실행 안전)
-- 실행: SCM_MGR 세션
-- 작성: 2026-06-05
--==============================================================================
SET DEFINE OFF
SET SERVEROUTPUT ON
SET FEEDBACK ON

PROMPT === BLOCK 1 : DMF0043_01 BTN_MPG 가 가리키는 API_M 의 PKG path 정합 ===

UPDATE SCM_MGR.SCM_ADM_API_M
   SET API_URL          = REGEXP_REPLACE(API_URL, '^PKG_DMF0043\.P?_?', ''),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID IN (
   SELECT DISTINCT API_ID FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
    WHERE MNU_ID = 'DMF0043_01'
 )
   AND API_URL LIKE 'PKG_DMF0043.%';

PROMPT === BLOCK 2 : PROC_M PROC_NM 정합 ===

UPDATE SCM_MGR.SCM_ADM_PROC_M
   SET PROC_NM          = REGEXP_REPLACE(PROC_NM, '^PKG_DMF0043\.P?_?', ''),
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE PROC_NM LIKE 'PKG_DMF0043.%'
   AND PROC_NM IN (
     -- DMF0043_01 가 사용하는 SP 만
     SELECT DISTINCT API.API_URL
       FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
       JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
      WHERE BTN.MNU_ID = 'DMF0043_01'
   );

PROMPT === BLOCK 3 : 검증 — DMF0043_01 routing chain ===

SELECT BTN.MNU_ID, BTN.SHT_NM, BTN.MNU_BTN_CD,
       BTN.API_ID AS BTN_API_ID,
       API.API_URL,
       CASE WHEN API.API_URL LIKE 'PKG_%' THEN 'FAIL: PKG path 잔존'
            ELSE 'PASS' END AS result
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M BTN
  LEFT JOIN SCM_MGR.SCM_ADM_API_M API ON API.API_ID = BTN.API_ID
 WHERE BTN.MNU_ID = 'DMF0043_01'
 ORDER BY BTN.SHT_NM, BTN.MNU_BTN_CD;

COMMIT;
