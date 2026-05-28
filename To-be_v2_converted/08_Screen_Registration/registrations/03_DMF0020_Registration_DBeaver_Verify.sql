/*=============================================================================================
 * File         : 03_DMF0020_Registration_DBeaver_Verify.sql
 * Description  : DMF0020 메타 등록 검증 SELECT [PART 2 of 3]
 *              :
 *              : 7개 영역의 row count 가 EXPECT_MIN 이상이어야 정상.
 *              : 단 1개라도 부족하면 화면 동작 불가.
 *
 * 선행 파일   : 03_DMF0020_Registration_DBeaver.sql 실행 완료 후
 * 실행 방법   : 본 파일 열기 → Ctrl+Enter (결과 그리드에 표시)
 *===========================================================================================*/

SELECT '1.MENU'         AS K, COUNT(*) AS CNT, 1 AS EXPECT_MIN, 'SCM_ADM_MNU_M' AS TBL              FROM SCM_ADM_MNU_M             WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '2.MENU_AUTH',    COUNT(*), 1, 'SCM_ADM_USER_GR_MNU_MPG_M' FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '3.UI_COLS',      COUNT(*), 7, 'SCM_MST_SHEET_COLUMNS'     FROM SCM_MST_SHEET_COLUMNS     WHERE PROGRAM_ID = 'DMF0020'
UNION ALL
SELECT '4.PROC',         COUNT(*), 9, 'SCM_ADM_PROC_M  (CORE)'    FROM SCM_ADM_PROC_M            WHERE PROC_NM LIKE 'PKG_DMF0020.%'
UNION ALL
SELECT '5.API',          COUNT(*), 2, 'SCM_ADM_API_M'             FROM SCM_ADM_API_M             WHERE API_ID LIKE 'DMF0020\_%' ESCAPE '\'
UNION ALL
SELECT '6.MNU_BTN_MPG',  COUNT(*), 2, 'SCM_ADM_MNU_BTN_MPG_M'     FROM SCM_ADM_MNU_BTN_MPG_M     WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '7.I18N_MNU',     COUNT(*), 3, 'SCM_ADM_MSG_M (3 langs)'   FROM SCM_ADM_MSG_M             WHERE MSG_ID = 'MNU_DMF0020'
UNION ALL
SELECT '8.I18N_API',     COUNT(*), 6, 'SCM_ADM_MSG_M (2 API x 3)' FROM SCM_ADM_MSG_M             WHERE MSG_ID IN ('MSG_API_DMF0020_FUTUREPRICE_SEARCH', 'MSG_API_DMF0020_FUTUREPRICE_SAVE')
ORDER BY 1
