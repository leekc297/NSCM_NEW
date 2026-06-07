/*=============================================================================================
 * File         : 010_DMF0003_Registration_DBeaver_Verify.sql
 * Description  : DMF0003 메타 등록 검증 SELECT [PART 2 of 3]
 *              :
 *              : 7개 영역의 row count 가 EXPECT_MIN 이상이어야 정상.
 *              : 단 1개라도 부족하면 화면 동작 불가.
 *
 * 선행 파일   : 010_DMF0003_Registration_DBeaver.sql 실행 완료 후
 * 실행 방법   : 본 파일 열기 → Ctrl+Enter (결과 그리드에 표시)
 *===========================================================================================*/

SELECT '1.MENU'         AS K, COUNT(*) AS CNT,  1 AS EXPECT_MIN, 'SCM_ADM_MNU_M'                      AS TBL FROM SCM_ADM_MNU_M             WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT '2.MENU_AUTH',    COUNT(*),  3, 'SCM_ADM_USER_GR_MNU_MPG_M (ADMIN/DEMAND_USER/GUEST)' FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT '3.UI_COLS',      COUNT(*), 43, 'SCM_MST_SHEET_COLUMNS (★ 43 fixed cols)'             FROM SCM_MST_SHEET_COLUMNS  WHERE PROGRAM_ID = 'DMF0003'
UNION ALL
SELECT '4.PROC',         COUNT(*), 26, 'SCM_ADM_PROC_M (★ 22 IN + 4 OUT cursor)'             FROM SCM_ADM_PROC_M         WHERE PROC_NM = 'DMF0003_GET_MKT_FCST_DATA'
UNION ALL
SELECT '5.API',          COUNT(*),  1, 'SCM_ADM_API_M'                                       FROM SCM_ADM_API_M          WHERE API_ID LIKE 'DMF0003\_%' ESCAPE '\'
UNION ALL
SELECT '6.MNU_BTN_MPG',  COUNT(*),  1, 'SCM_ADM_MNU_BTN_MPG_M (MNU_BTN_CD=SEARCH)'           FROM SCM_ADM_MNU_BTN_MPG_M  WHERE MNU_ID = 'DMF0003'
UNION ALL
SELECT '7.I18N_MNU',     COUNT(*),  3, 'SCM_ADM_MSG_M (KO/EN/CN)'                            FROM SCM_ADM_MSG_M          WHERE MSG_ID = 'MNU_DMF0003'
UNION ALL
SELECT '8.I18N_API',     COUNT(*),  3, 'SCM_ADM_MSG_M (API SEARCH x 3 lang)'                 FROM SCM_ADM_MSG_M          WHERE MSG_ID = 'MSG_API_DMF0003_MKTFCST_SEARCH'
ORDER BY 1
