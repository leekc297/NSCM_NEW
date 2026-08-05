-- ============================================================================
-- 19. SCM_ADM_USER_GR_M — 'SCP Planner' 그룹 신설 (사용자 확정 2026-07-27)
--     AS-IS TB_FX_GroupInfo 의 SCP Planner 대응 — TO-BE 그룹 마스터에 부재였음
-- 생성: build/10_build_sql.py (USER_MIG15_20260727_1104) / 원천: DEV MSSQL LGCE_SCMDEV (프로필=TB_FX_User_20260715_PROD 운영 스냅샷 우선)
-- ============================================================================
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_M (USER_GR_ID, USER_GR_NM, USE_YN,
        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SCP Planner', 'SCP Planner', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_M WHERE USER_GR_ID = 'SCP Planner');

COMMIT;
