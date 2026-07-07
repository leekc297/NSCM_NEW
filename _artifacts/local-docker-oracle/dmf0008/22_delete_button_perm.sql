-- =====================================================================================
-- DMF0008 Delete(F9) 버튼 권한 등록 (2026-06-28) — Figma 디자인 + 사용자 요구.
--   hasButton('DELETE') = /admin/menu/DMF0008/auth = SCM_ADM_USER_GR_MNU_BTN_MPG_M 조회.
--   AS-IS DeleteButton 빈 함수 + delete SP 없음 → FE 전용(신규행 제거). 권한만 등록(api 불필요).
--   기존 INSERT 권한 행(USER_GR_ID, SHT_NM)을 그대로 DELETE 로 미러 → Insert 가능한 그룹/시트 = Delete 가능.
-- 멱등: NOT EXISTS. 적용: python _artifacts/_diagnostics/ora.py exec <this>
-- =====================================================================================
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT src.USER_GR_ID, src.MNU_ID, src.SHT_NM, 'DELETE', 'Y',
       'minyonglee1', SYSDATE, 'minyonglee1', SYSDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M src
 WHERE src.MNU_ID = 'DMF0008'
   AND src.MNU_BTN_CD = 'INSERT'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M x
      WHERE x.USER_GR_ID = src.USER_GR_ID AND x.MNU_ID = src.MNU_ID
        AND x.SHT_NM = src.SHT_NM AND x.MNU_BTN_CD = 'DELETE'
   );

COMMIT;
