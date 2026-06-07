/*=============================================================================================
 * File         : 020_DMF0003_p2_save_meta_DBeaver_Verify.sql
 * Description  : DMF0003 Phase 2 SAVE 메타 검증 SELECT [PART 2 of 3]
 *===========================================================================================*/

SELECT '1.PROC_SAVE'   AS K, COUNT(*) AS CNT, 17 AS EXPECT, 'SCM_ADM_PROC_M (15 IN + 2 OUT)'        AS TBL FROM SCM_ADM_PROC_M               WHERE PROC_NM = 'DMF0003_SAVE_MKT_FCST'
UNION ALL
SELECT '2.API_SAVE',      COUNT(*),  1, 'SCM_ADM_API_M'                                        FROM SCM_ADM_API_M                 WHERE API_ID = 'DMF0003_main_SAVE'
UNION ALL
SELECT '3.BTN_MPG',       COUNT(*),  3, 'SCM_ADM_MNU_BTN_MPG_M (SAVE/INSERT/DELETE)'           FROM SCM_ADM_MNU_BTN_MPG_M         WHERE MNU_ID = 'DMF0003' AND MNU_BTN_CD IN ('SAVE','INSERT','DELETE')
UNION ALL
SELECT '4.BTN_PERM',      COUNT(*),  6, 'SCM_ADM_USER_GR_MNU_BTN_MPG_M (ADMIN+DEMAND_USER x 3)' FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0003' AND MNU_BTN_CD IN ('SAVE','INSERT','DELETE')
UNION ALL
SELECT '5.I18N_SAVE',     COUNT(*),  3, 'SCM_ADM_MSG_M (KO/EN/CN)'                              FROM SCM_ADM_MSG_M                 WHERE MSG_ID = 'MSG_API_DMF0003_MKTFCST_SAVE'
ORDER BY 1
