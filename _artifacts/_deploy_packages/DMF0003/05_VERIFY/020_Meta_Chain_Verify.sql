/*=============================================================================================
 * File         : 020_Meta_Chain_Verify.sql
 * Description  : DMF0003 메타 chain 5-join 검증
 *              :   MNU_M ↔ MNU_BTN_MPG_M ↔ API_M ↔ PROC_M ↔ USER_GR_MNU_BTN_MPG_M
 *===========================================================================================*/

-- 메타 체인 5-join (sheet 별 button 라우팅)
SELECT
    m.MNU_ID,
    m.MNU_URL,
    bm.SHT_NM,
    bm.MNU_BTN_CD,
    bm.API_ID,
    a.API_URL AS PROC_NM,
    (SELECT COUNT(*) FROM SCM_ADM_PROC_M p WHERE p.PROC_NM = a.API_URL) AS PROC_PARAM_CNT,
    (SELECT COUNT(*) FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M ugbm
      WHERE ugbm.MNU_ID = bm.MNU_ID AND ugbm.MNU_BTN_CD = bm.MNU_BTN_CD AND ugbm.SHT_NM = bm.SHT_NM
    ) AS PERM_GROUP_CNT
FROM SCM_ADM_MNU_M m
JOIN SCM_ADM_MNU_BTN_MPG_M bm ON bm.MNU_ID = m.MNU_ID
JOIN SCM_ADM_API_M a ON a.API_ID = bm.API_ID
WHERE m.MNU_ID = 'DMF0003'
ORDER BY bm.SHT_NM, bm.MNU_BTN_CD;

-- 메뉴 권한 체크 (USER_GR_MNU_MPG)
SELECT 'MNU_PERM' AS K, USER_GR_ID, MNU_ID, USE_YN
FROM SCM_ADM_USER_GR_MNU_MPG_M
WHERE MNU_ID = 'DMF0003'
ORDER BY USER_GR_ID;

-- i18n (메뉴명 3 lang + API 메시지)
SELECT MSG_ID, LANG_CD, MSG_NM
FROM SCM_ADM_MSG_M
WHERE MSG_ID = 'MNU_DMF0003' OR MSG_ID LIKE 'MSG_API_DMF0003%'
ORDER BY MSG_ID, LANG_CD;
