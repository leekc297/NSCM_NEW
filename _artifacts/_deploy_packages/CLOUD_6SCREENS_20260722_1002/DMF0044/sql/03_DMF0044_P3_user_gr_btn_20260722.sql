-- =====================================================================
-- DMF0044 P3 — USER_GR_MNU_BTN_MPG_M 권한 배선 (2026-07-22)
-- USER_GR_MNU_MPG_M 은 기배정 실측(ADMIN/DM ADMIN/DM Viewer 3그룹) — BTN 만 신규.
-- 정책: ADMIN=전 28 / DM ADMIN=전 28 (Transfer 포함 — AS-IS United 게이트는 SEND_YN 뿐, 권한 게이트 없음)
--      / DM Viewer=조회 계열 16 (INSERT/DELETE/SAVE/SAVE_CF/ACTION/ACTION_BP/TRANSFER/
--        exchangeRate SAVE/textbox SAVE 제외. titleSet SAVE 는 부여 — DMF0042 P4 선례)
-- 멱등 MERGE. 감사 'admin'.
-- =====================================================================
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M t
USING (
  SELECT g.USER_GR_ID, b.MNU_ID, b.SHT_NM, b.MNU_BTN_CD
  FROM (SELECT 'ADMIN' USER_GR_ID FROM DUAL
        UNION ALL SELECT 'DM ADMIN' FROM DUAL
        UNION ALL SELECT 'DM Viewer' FROM DUAL) g
  CROSS JOIN (
    SELECT MNU_ID, SHT_NM, MNU_BTN_CD FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0044'
  ) b
  WHERE NOT (g.USER_GR_ID = 'DM Viewer' AND (
          (b.SHT_NM = 'MDF Reports'  AND b.MNU_BTN_CD IN ('INSERT','DELETE','SAVE','SAVE_CF'))
       OR (b.SHT_NM = 'unitedVersion' AND b.MNU_BTN_CD IN ('ACTION','ACTION_BP','TRANSFER'))
       OR (b.SHT_NM = 'exchangeRate'  AND b.MNU_BTN_CD = 'SAVE')
       OR (b.SHT_NM = 'textbox'       AND b.MNU_BTN_CD = 'SAVE')
  ))
) s
ON (t.USER_GR_ID = s.USER_GR_ID AND t.MNU_ID = s.MNU_ID AND t.SHT_NM = s.SHT_NM AND t.MNU_BTN_CD = s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.USE_YN = 'Y', t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.USER_GR_ID, s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 검증 (기대: ADMIN 28 / DM ADMIN 28 / DM Viewer 19):
-- SELECT USER_GR_ID, COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0044' GROUP BY USER_GR_ID;
-- 원복: DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0044'; COMMIT;
-- =====================================================================
