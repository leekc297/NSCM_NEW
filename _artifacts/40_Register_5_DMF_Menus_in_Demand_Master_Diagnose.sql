--==============================================================================
-- 40_Register_5_DMF_Menus_in_Demand_Master_Diagnose.sql  (진단)
--
-- 적용 후 실제 등록된 행을 사람이 눈으로 확인할 때 사용. 결과를 그대로 보고.
-- DBeaver Ctrl+Enter 단일문 X — 여러 SELECT 를 순서대로 실행해 확인.
--
-- 작성: 2026-05-30
--==============================================================================

-- 1) Demand_Master 트리 (start with 'Demand_Master' connect by)
SELECT LPAD(' ', (LEVEL-1)*2) || MNU_ID AS MNU_TREE,
       MNU_URL, MNU_DESC, SORT_ORD, MNU_LV_NO, MNU_TP_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MNU_M
 START WITH MNU_ID = 'Demand_Master'
 CONNECT BY PRIOR MNU_ID = UPPR_MNU_ID
 ORDER SIBLINGS BY SORT_ORD;

-- 2) 5 화면 i18n 메시지 (3 lang × 5 = 15)
SELECT MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, USE_YN
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU_DMF0043','MNU_DMF0043_01','MNU_DMF0008','MNU_DMF0072','MNU_DMF0020')
 ORDER BY MSG_ID, LANG_CD;

-- 3) GUEST 그룹 메뉴 권한 (5 행)
SELECT USER_GR_ID, MNU_ID, USE_YN, CREATION_DATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID = 'GUEST'
   AND MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')
 ORDER BY MNU_ID;

-- 4) minyonglee1 가 속한 그룹 + 5 화면 접근 가능 여부 (GUEST = 모두 가능)
SELECT U.USER_ID, U.USER_NM, UG.USER_GR_ID, P.MNU_ID, P.USE_YN
  FROM SCM_MGR.SCM_ADM_USER_M U
  JOIN SCM_MGR.SCM_ADM_USER_GR_USER_MPG_M UG ON UG.USER_ID = U.USER_ID
  JOIN SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M  P  ON P.USER_GR_ID = UG.USER_GR_ID
 WHERE U.USER_ID = 'minyonglee1'
   AND P.MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')
 ORDER BY P.MNU_ID;

-- 5) Cleanup 39 후 보존 검증 — PKG body 존재 + 분석 자료 위치
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS
  FROM USER_OBJECTS
 WHERE OBJECT_NAME IN ('PKG_DMF0043','PKG_DMF0072','PKG_DMF0020','PKG_DMF0008')
 ORDER BY OBJECT_NAME, OBJECT_TYPE;
