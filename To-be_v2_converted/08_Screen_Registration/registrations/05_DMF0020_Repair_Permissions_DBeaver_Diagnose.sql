/*=============================================================================================
 * File         : 05_DMF0020_Repair_Permissions_DBeaver_Diagnose.sql
 * Description  : DMF0020 권한 진단 [PART 1 of 3]
 *              :
 *              : 'No Permission' 오류 원인 검증:
 *              :   (1) SCM_ADM_USER_GR_MNU_MPG_M     — 메뉴 그룹 권한 (DMF0007 대비 누락 그룹)
 *              :   (2) SCM_ADM_USER_GR_MNU_BTN_MPG_M — 버튼 그룹 권한 (DMF0020 미등록 가능성)
 *              :   (3) SCM_ADM_MNU_BTN_MPG_M         — 버튼 정의 (BLOCK 6 등록 결과)
 *              :
 *              : 본 파일은 read-only — UPDATE 없음. 안전 반복 실행 가능.
 *              :
 *              : ★ 단일 SELECT (UNION ALL) — Ctrl+Enter 한 번에 실행 가능 (ORA-00933 회피).
 *
 * 실행 방법   : 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter (결과 그리드 확인)
 * 실행 계정   : SCM_MGR
 *
 * 판정 기준   :
 *   • 1.MENU_DIFF  : 'MISSING_IN_DMF0020' 표시 그룹이 있으면 메뉴 권한 누락
 *   • 2.BTN_DMF0020: ROW 수 0 이면 버튼 권한 전체 누락 (No Permission 원인)
 *   • 3.BTN_DEFINE : BLOCK 6 등록된 버튼 (SEARCH/SAVE) 확인
 *
 * 다음 단계   : 05_DMF0020_Repair_Permissions_DBeaver.sql 실행
 *===========================================================================================*/

SELECT '1.MENU_DIFF'           AS SECTION,
       D7.USER_GR_ID,
       'DMF0007 only'          AS DETAIL,
       D7.USE_YN                AS DMF0007_USE,
       NVL(D20.USE_YN, 'NONE')  AS DMF0020_USE,
       CASE WHEN D20.USER_GR_ID IS NULL THEN 'MISSING_IN_DMF0020' ELSE 'OK' END AS STATUS
  FROM (SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0007') D7
  LEFT JOIN (SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0020') D20
    ON D7.USER_GR_ID = D20.USER_GR_ID
UNION ALL
SELECT '1.MENU_DIFF'           AS SECTION,
       D20.USER_GR_ID,
       'DMF0020 only'          AS DETAIL,
       NVL(D7.USE_YN, 'NONE')   AS DMF0007_USE,
       D20.USE_YN               AS DMF0020_USE,
       CASE WHEN D7.USER_GR_ID IS NULL THEN 'EXTRA_IN_DMF0020' ELSE 'OK' END AS STATUS
  FROM (SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0020') D20
  LEFT JOIN (SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID = 'DMF0007') D7
    ON D20.USER_GR_ID = D7.USER_GR_ID
 WHERE D7.USER_GR_ID IS NULL
UNION ALL
SELECT '2.BTN_DMF0020'         AS SECTION,
       USER_GR_ID,
       SHT_NM || ' / ' || MNU_BTN_CD AS DETAIL,
       NULL                     AS DMF0007_USE,
       USE_YN                   AS DMF0020_USE,
       'EXISTING'               AS STATUS
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '2.BTN_DMF0020'         AS SECTION,
       '(none)'                 AS USER_GR_ID,
       '버튼권한 0건 — No Permission 원인' AS DETAIL,
       NULL                     AS DMF0007_USE,
       NULL                     AS DMF0020_USE,
       'MISSING_ALL'            AS STATUS
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID = 'DMF0020')
UNION ALL
SELECT '3.BTN_DEFINE'          AS SECTION,
       '(button)'               AS USER_GR_ID,
       SHT_NM || ' / ' || MNU_BTN_CD || ' -> ' || API_ID AS DETAIL,
       NULL                     AS DMF0007_USE,
       USE_YN                   AS DMF0020_USE,
       'DEFINED'                AS STATUS
  FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0020'
UNION ALL
SELECT '4.BTN_DMF0007_REF'     AS SECTION,
       USER_GR_ID,
       SHT_NM || ' / ' || MNU_BTN_CD AS DETAIL,
       USE_YN                   AS DMF0007_USE,
       NULL                     AS DMF0020_USE,
       'REFERENCE'              AS STATUS
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0007'
   AND USE_YN = 'Y'
 ORDER BY SECTION, USER_GR_ID, DETAIL
