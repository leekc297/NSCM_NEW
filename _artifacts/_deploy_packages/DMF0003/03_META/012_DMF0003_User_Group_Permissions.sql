/*=============================================================================================
 * File         : 012_DMF0003_User_Group_Permissions.sql
 * Description  : DMF0003 — UI 동적 속성관리 hook §3 (Menu Button 권한) 그룹 권한 부여
 *              :   - 010 등록한 SEARCH + 011 신규 9 button 의 사용자 그룹 권한 부여
 *              :   - 자매 화면 (DMF0007 = Customer FCST Master) 의 그룹 권한 동적 복제
 *              :     → admin 화면에서 사용자 그룹별 권한 토글로 화면 즉시 반영 가능
 *              :
 *              : 의무 사항 (메모리 feedback_scmd_app_grant_mandatory + child hook §3 Step 2):
 *              :   - SCM_ADM_USER_GR_MNU_BTN_MPG_M 에 자매 화면 모든 그룹 × DMF0003 모든 button 동적 복제
 *              :   - NOT EXISTS 멱등 패턴 (재실행 안전)
 *
 * Author       : 마리소프트 이규철
 * Created      : 2026-06-15
 * Plan         : C:\Users\ejene\.claude\plans\dmf0003-jazzy-ullman.md
 *
 * 관련 hook    : Doc/_rules_v2/hooks/menu-button-dynamic-fetch.md §3 Step 2
 * 사전 조건   : 010 + 011 실행 완료 (10 button 정의 존재)
 * 실행 계정   : SCM_MGR
 *===========================================================================================*/

SET DEFINE ON
SET SERVEROUTPUT ON SIZE UNLIMITED

DEFINE V_MENU_ID        = 'DMF0003'
DEFINE V_SISTER_MENU_ID = 'DMF0007'
DEFINE V_SHT_NM         = 'main'
DEFINE V_USER_ID        = 'admin'


-- =============================================================================================
-- BLOCK 1: USER_GR_MNU_BTN_MPG_M — 자매 화면 그룹 × DMF0003 모든 button 동적 복제 (멱등)
--   자매 = DMF0007 (Customer FCST Master, Demand_Master 동일 부모)
--   자매 그룹이 DMF0007 의 button 권한 있으면 → DMF0003 도 같은 button 권한 부여
-- =============================================================================================

INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD, 'Y',
       '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM SCM_ADM_MNU_BTN_MPG_M b
  CROSS JOIN (
    SELECT DISTINCT USER_GR_ID
      FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
     WHERE MNU_ID = '&V_SISTER_MENU_ID' AND SHT_NM = '&V_SHT_NM' AND USE_YN = 'Y'
  ) u
 WHERE b.MNU_ID = '&V_MENU_ID' AND b.SHT_NM = '&V_SHT_NM' AND b.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID
        AND e.MNU_ID     = b.MNU_ID
        AND e.SHT_NM     = b.SHT_NM
        AND e.MNU_BTN_CD = b.MNU_BTN_CD
   );


-- =============================================================================================
-- BLOCK 2: Fallback — 자매 (DMF0007) 권한이 없으면 표준 그룹 (ADMIN/DEMAND_USER/GUEST) 직접 부여
--   사내 환경에서 DMF0007 미등록 사고 대비
-- =============================================================================================

INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT u.USER_GR_ID, b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD, 'Y',
       '&V_USER_ID', SYSDATE, '&V_USER_ID', SYSDATE
  FROM SCM_ADM_MNU_BTN_MPG_M b
  CROSS JOIN (SELECT 'ADMIN' USER_GR_ID FROM DUAL UNION ALL
              SELECT 'DEMAND_USER'      FROM DUAL UNION ALL
              SELECT 'GUEST'            FROM DUAL) u
 WHERE b.MNU_ID = '&V_MENU_ID' AND b.SHT_NM = '&V_SHT_NM' AND b.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID
        AND e.MNU_ID     = b.MNU_ID
        AND e.SHT_NM     = b.SHT_NM
        AND e.MNU_BTN_CD = b.MNU_BTN_CD
   );


COMMIT;


-- =============================================================================================
-- BLOCK 3: 검증 SELECT
-- =============================================================================================

PROMPT
PROMPT ============================================================
PROMPT DMF0003 사용자 그룹 권한 부여 결과
PROMPT ============================================================

SELECT USER_GR_ID, MNU_BTN_CD, USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM'
 ORDER BY USER_GR_ID, MNU_BTN_CD;

PROMPT
PROMPT === 그룹별 button 권한 카운트 (button=10 권장) ===
SELECT USER_GR_ID, COUNT(*) AS BTN_CNT
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = '&V_MENU_ID' AND SHT_NM = '&V_SHT_NM' AND USE_YN = 'Y'
 GROUP BY USER_GR_ID
 ORDER BY USER_GR_ID;
