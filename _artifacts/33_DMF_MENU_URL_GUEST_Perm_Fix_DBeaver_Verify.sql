--==============================================================================
-- 33_DMF_MENU_URL_GUEST_Perm_Fix_DBeaver_Verify.sql
--
-- 단일 SELECT (UNION ALL) — Ctrl+Enter 한 번에 전체 검증
-- 룰: feedback_dbeaver_single_statement.md / feedback_verify_sql_scalar_pattern.md
--
-- 기대: 모든 행에서 ACTUAL = EXPECT
--
-- 작성: 2026-05-29
--==============================================================================

SELECT 'BLOCK 1 DMF0043 MNU_URL=contribute-main' BLOCK_NAME,
       (SELECT MNU_URL FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0043') ACTUAL,
       'contribute-main' EXPECT,
       'string' UNIT FROM DUAL
UNION ALL
SELECT 'BLOCK 2 DMF0043_01 MNU_URL=contribute-view',
       (SELECT MNU_URL FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0043_01'),
       'contribute-view',
       'string' FROM DUAL
UNION ALL
SELECT 'BLOCK 3 DMF0072 MNU_URL=nn-master-mapping',
       (SELECT MNU_URL FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0072'),
       'nn-master-mapping',
       'string' FROM DUAL
UNION ALL
SELECT 'BLOCK 4 GUEST DMF0008 MNU perm (=1)',
       TO_CHAR((SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_MPG_M
                 WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0008' AND USE_YN = 'Y')),
       '1',
       'rows' FROM DUAL
UNION ALL
SELECT 'BLOCK 5 GUEST DMF0008 BTN perm (= master count)',
       TO_CHAR((SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
                 WHERE USER_GR_ID = 'GUEST' AND MNU_ID = 'DMF0008' AND USE_YN = 'Y')),
       TO_CHAR((SELECT COUNT(*) FROM SCM_ADM_MNU_BTN_MPG_M
                 WHERE MNU_ID = 'DMF0008' AND USE_YN = 'Y')),
       'rows' FROM DUAL
ORDER BY BLOCK_NAME;
