--==============================================================================
-- 33_DMF_MENU_URL_GUEST_Perm_Fix_DBeaver_Diagnose.sql
--
-- 적용 전후 상태 진단용 SELECT 들 (각 블록 별도 Ctrl+Enter).
--
-- 작성: 2026-05-29
--==============================================================================

-- [1] 대상 4개 메뉴의 현재 MNU_URL / 부모 / 상태
SELECT MNU_ID, MNU_MSG_ID, MNU_TP_CD, UPPR_MNU_ID, MNU_URL, USE_YN, SORT_ORD,
       LAST_UPDATED_BY, LAST_UPDATE_DATE
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID IN ('DMF0008','DMF0043','DMF0043_01','DMF0072')
 ORDER BY MNU_ID;

-- [2] minyonglee1 소속 그룹
SELECT USER_GR_ID, USER_ID, USE_YN
  FROM SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID = 'minyonglee1'
 ORDER BY USER_GR_ID;

-- [3] minyonglee1 그룹들의 4개 메뉴 권한 현황
SELECT M.USER_GR_ID, M.MNU_ID, M.USE_YN
  FROM SCM_ADM_USER_GR_MNU_MPG_M M
 WHERE M.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1')
   AND M.MNU_ID IN ('DMF0008','DMF0043','DMF0043_01','DMF0072')
 ORDER BY M.MNU_ID, M.USER_GR_ID;

-- [4] minyonglee1 그룹들의 4개 메뉴 버튼 권한 현황 (그룹×메뉴 COUNT)
SELECT B.USER_GR_ID, B.MNU_ID, COUNT(*) BTN_CNT
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M B
 WHERE B.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1')
   AND B.MNU_ID IN ('DMF0008','DMF0043','DMF0043_01','DMF0072')
   AND B.USE_YN = 'Y'
 GROUP BY B.USER_GR_ID, B.MNU_ID
 ORDER BY B.MNU_ID, B.USER_GR_ID;

-- [5] 4개 메뉴의 마스터 버튼 정의 (SCM_ADM_MNU_BTN_MPG_M)
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID IN ('DMF0008','DMF0043','DMF0043_01','DMF0072')
 ORDER BY MNU_ID, SHT_NM, MNU_BTN_CD;

-- [6] 부모 메뉴 Demand_Master 권한 (GUEST 포함)
SELECT M.USER_GR_ID, M.MNU_ID, M.USE_YN
  FROM SCM_ADM_USER_GR_MNU_MPG_M M
 WHERE M.MNU_ID = 'Demand_Master'
 ORDER BY M.USER_GR_ID;
