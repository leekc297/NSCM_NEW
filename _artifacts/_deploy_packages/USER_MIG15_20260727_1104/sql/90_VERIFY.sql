-- ============================================================================
-- 90. 검증 (읽기 전용) — USER_MIG15 적용 후 확인
--     sqlplus / DBeaver 공용. SP 직접 콜 자동판정은 verify/91_verify_sp.py 사용
-- 기대값: [1] USER_M=14 / GR_MPG=14 / GR_M(SCP Planner)=1  [2] 14행 (전 조합 존재)
--         [3] 0 rows  [4] 한글 정상  [5] gap 0 은 sql/30 진단 1·2 로 확인
-- ============================================================================

-- [1] 건수 요약
SELECT 'USER_M' T, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_USER_M
 WHERE USER_ID IN ('hongjae.kim','eunah.koo','yooah.chung','dodae','jiwon.park','bpark416','jaehyeok','park6151','bottle','wonqthanq','ys_cho','miyeong.lee','yeonjusung','coeogus')
UNION ALL
SELECT 'GR_MPG', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
 WHERE USER_ID IN ('hongjae.kim','eunah.koo','yooah.chung','dodae','jiwon.park','bpark416','jaehyeok','park6151','bottle','wonqthanq','ys_cho','miyeong.lee','yeonjusung','coeogus')
UNION ALL
SELECT 'GR_M(SCP Planner)', COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_M WHERE USER_GR_ID = 'SCP Planner';

-- [2] 지정 역할 14조합 (GR × USER × Division) 존재 확인 — 14 rows 여야 함
WITH EXPECT (GR, USR, DIV) AS (
  SELECT 'DM ADMIN','hongjae.kim','40' FROM DUAL
  UNION ALL SELECT 'DM Planner','eunah.koo','40' FROM DUAL
  UNION ALL SELECT 'DM Viewer','yooah.chung','40' FROM DUAL
  UNION ALL SELECT 'SCP Planner','dodae','40' FROM DUAL
  UNION ALL SELECT 'DM ADMIN','jiwon.park','81' FROM DUAL
  UNION ALL SELECT 'DM Planner','bpark416','81' FROM DUAL
  UNION ALL SELECT 'DM Planner (W/S)','jaehyeok','81' FROM DUAL
  UNION ALL SELECT 'DM Viewer','park6151','81' FROM DUAL
  UNION ALL SELECT 'SCP Planner','bottle','81' FROM DUAL
  UNION ALL SELECT 'DM ADMIN','wonqthanq','82' FROM DUAL
  UNION ALL SELECT 'DM Planner','ys_cho','82' FROM DUAL
  UNION ALL SELECT 'DM Planner (W/S)','miyeong.lee','82' FROM DUAL
  UNION ALL SELECT 'DM Viewer','yeonjusung','82' FROM DUAL
  UNION ALL SELECT 'SCP Planner','coeogus','82' FROM DUAL
)
SELECT E.GR, E.USR, E.DIV,
       CASE WHEN M.USER_ID IS NULL THEN 'MISSING' ELSE 'OK' END AS MPG,
       CASE WHEN A.USER_ID IS NULL THEN 'MISSING' ELSE 'OK' END AS UNIT_AUTH
  FROM EXPECT E
  LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M M
    ON M.USER_GR_ID = E.GR AND M.USER_ID = E.USR
  LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
    ON A.USER_GR_ID = E.GR AND A.USER_ID = E.USR AND A.UNIT_TP_CD = 'D' AND A.UNIT_ID = E.DIV
 ORDER BY E.DIV, E.GR, E.USR;

-- [3] DEPT 미존재 리포트 (비차단 — 화면 부서명 '-' 표시 대상)
SELECT U.USER_ID, U.DEPT_ID FROM SCM_MGR.SCM_ADM_USER_M U
 WHERE U.USER_ID IN ('hongjae.kim','eunah.koo','yooah.chung','dodae','jiwon.park','bpark416','jaehyeok','park6151','bottle','wonqthanq','ys_cho','miyeong.lee','yeonjusung','coeogus')
   AND NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SSO_DEPT_INFO D WHERE D.DEPT_ID = U.DEPT_ID);

-- [4] 한글 라운드트립
SELECT USER_ID, USER_NM, USER_ENG_NM FROM SCM_MGR.SCM_ADM_USER_M
 WHERE USER_ID IN ('hongjae.kim','miyeong.lee') ORDER BY 1;

-- [5] 그룹별 메뉴/버튼 권한 카운트 (참고)
SELECT 'MNU' T, USER_GR_ID, COUNT(*) CNT FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
 WHERE USER_GR_ID IN ('DM ADMIN','DM Planner','DM Planner (W/S)','DM Viewer','SCP Planner')
 GROUP BY USER_GR_ID
UNION ALL
SELECT 'BTN', USER_GR_ID, COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE USER_GR_ID IN ('DM ADMIN','DM Planner','DM Planner (W/S)','DM Viewer','SCP Planner')
 GROUP BY USER_GR_ID
 ORDER BY 1, 2;
