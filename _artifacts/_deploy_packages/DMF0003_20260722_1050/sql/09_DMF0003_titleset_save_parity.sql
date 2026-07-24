-- =====================================================================
-- DMF0003 titleSet SAVE 권한 AS-IS 파리티 정정 (2026-07-20)
--   AS-IS: titleSet 개인 저장은 권한 무관(SP SCM0002_SET_TITLESET_POPUP 게이트 없음,
--          팝업 무게이트, p_user_id 저장) → 조회 가능한 전 사용자 저장 가능.
--   TO-BE 결함: titleSet SAVE 를 ADMIN/DM ADMIN/DM Viewer 에만 부여 → DM Planner(DEMAND_USER)
--          저장 시 -9994 거부. 사용자 실측 지적(2026-07-20).
--   정정: 팝업 열기(COLUMN_SETUP/MEASURE_SELECT)·titleSet SEARCH 를 가진 그룹과 동일하게
--          titleSet SAVE 를 DEMAND_USER·GUEST 에도 부여(ADMIN 은 기존). 기존 3그룹 유지.
--   멱등 MERGE. 감사 'admin'.
-- =====================================================================
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M t
USING (
  SELECT 'DEMAND_USER' USER_GR_ID, 'DMF0003' MNU_ID, 'titleSet' SHT_NM, 'SAVE' MNU_BTN_CD FROM DUAL
  UNION ALL SELECT 'GUEST', 'DMF0003', 'titleSet', 'SAVE' FROM DUAL
) s
ON (t.USER_GR_ID = s.USER_GR_ID AND t.MNU_ID = s.MNU_ID AND t.SHT_NM = s.SHT_NM AND t.MNU_BTN_CD = s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.USE_YN = 'Y', t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.USER_GR_ID, s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;
