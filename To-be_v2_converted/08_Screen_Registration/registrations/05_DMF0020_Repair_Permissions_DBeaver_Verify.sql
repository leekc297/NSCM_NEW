/*=============================================================================================
 * File         : 05_DMF0020_Repair_Permissions_DBeaver_Verify.sql
 * Description  : DMF0020 권한 복구 검증 [PART 3 of 3]
 *              :
 *              : 1.MENU  → 메뉴 권한 (그룹별)
 *              : 2.BTN   → 버튼 권한 (그룹/시트/버튼별)
 *              : 3.COUNT → DMF0007 vs DMF0020 카운트 비교 (일치해야 정상)
 *              :
 *              : ★ 단일 SELECT (UNION ALL) — Ctrl+Enter 한 번에 실행 가능
 *
 * 판정 기준   :
 *   • 1.MENU 행 수 ≥ DMF0007 의 그룹 수
 *   • 2.BTN  행 수 ≥ (DMF0007 그룹 수) × (DMF0020 버튼 수)
 *   • 3.COUNT 의 DMF0020 / DMF0007 비율이 100% (= 동일 그룹 수)
 *===========================================================================================*/

SELECT '1.MENU'                                                          AS SECTION,
       USER_GR_ID,
       NULL                                                              AS SHT_NM,
       NULL                                                              AS MNU_BTN_CD,
       USE_YN,
       TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS')                AS LAST_UPDATE
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '2.BTN'                                                           AS SECTION,
       USER_GR_ID,
       SHT_NM,
       MNU_BTN_CD,
       USE_YN,
       TO_CHAR(LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS')                AS LAST_UPDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '3.COUNT'                                                         AS SECTION,
       'MENU_GR_DMF0020'                                                 AS USER_GR_ID,
       NULL                                                              AS SHT_NM,
       NULL                                                              AS MNU_BTN_CD,
       TO_CHAR(COUNT(*))                                                 AS USE_YN,
       NULL                                                              AS LAST_UPDATE
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID = 'DMF0020' AND USE_YN = 'Y'
UNION ALL
SELECT '3.COUNT'                                                         AS SECTION,
       'MENU_GR_DMF0007 (ref)'                                           AS USER_GR_ID,
       NULL                                                              AS SHT_NM,
       NULL                                                              AS MNU_BTN_CD,
       TO_CHAR(COUNT(*))                                                 AS USE_YN,
       NULL                                                              AS LAST_UPDATE
  FROM SCM_ADM_USER_GR_MNU_MPG_M
 WHERE MNU_ID = 'DMF0007' AND USE_YN = 'Y'
UNION ALL
SELECT '3.COUNT'                                                         AS SECTION,
       'BTN_TOTAL_DMF0020'                                               AS USER_GR_ID,
       NULL                                                              AS SHT_NM,
       NULL                                                              AS MNU_BTN_CD,
       TO_CHAR(COUNT(*))                                                 AS USE_YN,
       NULL                                                              AS LAST_UPDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020' AND USE_YN = 'Y'
UNION ALL
SELECT '3.COUNT'                                                         AS SECTION,
       'BTN_TOTAL_DMF0007 (ref)'                                         AS USER_GR_ID,
       NULL                                                              AS SHT_NM,
       NULL                                                              AS MNU_BTN_CD,
       TO_CHAR(COUNT(*))                                                 AS USE_YN,
       NULL                                                              AS LAST_UPDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0007' AND USE_YN = 'Y'
 ORDER BY SECTION, USER_GR_ID NULLS LAST, SHT_NM NULLS LAST, MNU_BTN_CD NULLS LAST
