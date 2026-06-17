-- =================================================================================================
-- DMF0043 — '기여율 버전관리' (VERSION_MGT) custom button 메타 등록
--
-- 배경 (2026-06-17 사용자 보고):
--   DMF0043 화면의 customButtons 가 hasButton('VERSION_MGT') 조건부 표시인데,
--   SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_USER_GR_MNU_BTN_MPG_M 에 'VERSION_MGT' MNU_BTN_CD 미등록
--   → BE /admin/menu/DMF0043/auth 응답 mnuBtnAuth 에 'VERSION_MGT' 없음
--   → FE hasButton('VERSION_MGT') = false
--   → '기여율 버전관리' 버튼 미표시 사고.
--
-- 해결: BLOCK 3 (button 정의) + BLOCK 7 (사용자 그룹 권한) 멱등 INSERT.
-- 멱등: NOT EXISTS 패턴 — 재실행 시 영향 없음.
-- =================================================================================================

-- ----- BLOCK 3: SCM_ADM_MNU_BTN_MPG_M (button 정의) -----
-- API_ID = NULL (VERSION_MGT 는 단순 popup 토글, BE callProc 없음)
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043', 'main', 'VERSION_MGT', NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
    WHERE MNU_ID='DMF0043' AND SHT_NM='main' AND MNU_BTN_CD='VERSION_MGT'
 );

-- ----- BLOCK 7: SCM_ADM_USER_GR_MNU_BTN_MPG_M (사용자 그룹 권한 — 자매 동적 복제) -----
-- DMF0043 main 의 SEARCH 권한을 가진 모든 사용자 그룹에 VERSION_MGT 권한 동시 부여.
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0043', 'main', 'VERSION_MGT', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 WHERE u.MNU_ID='DMF0043' AND u.SHT_NM='main' AND u.MNU_BTN_CD='SEARCH'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID=u.USER_GR_ID AND e.MNU_ID='DMF0043' AND e.SHT_NM='main' AND e.MNU_BTN_CD='VERSION_MGT'
   );

COMMIT;

-- ----- 검증 -----
-- 등록 결과 확인 — row 수 1+ 이어야 함.
SELECT b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD, b.USE_YN, COUNT(u.USER_GR_ID) AS GR_AUTH_CNT
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M b
  LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
    ON b.MNU_ID=u.MNU_ID AND b.SHT_NM=u.SHT_NM AND b.MNU_BTN_CD=u.MNU_BTN_CD AND u.USE_YN='Y'
 WHERE b.MNU_ID='DMF0043' AND b.SHT_NM='main' AND b.MNU_BTN_CD='VERSION_MGT'
 GROUP BY b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD, b.USE_YN;
