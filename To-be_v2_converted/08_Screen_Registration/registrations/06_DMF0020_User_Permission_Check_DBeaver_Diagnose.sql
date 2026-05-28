/*=============================================================================================
 * File         : 06_DMF0020_User_Permission_Check_DBeaver_Diagnose.sql
 * Description  : 로그인 사용자 'minyonglee1' 기준 DMF0020 화면 데이터/권한 진단
 *              :
 *              : 7개 SECTION 한 그리드 출력 (UNION ALL 단일 SELECT — Ctrl+Enter 1회 실행):
 *              :   1.USER      → SCM_ADM_USER_M 사용자 존재/활성화
 *              :   2.GROUP     → SCM_ADM_USER_GR_MPG_M 사용자 소속 그룹
 *              :   3.MENU_PERM → DMF0020 메뉴 권한 (사용자 그룹 단위)
 *              :   4.BTN_PERM  → DMF0020 버튼 권한 (SHT_NM × MNU_BTN_CD)
 *              :   5.EDIT_AUTH → SCM_ADM_USER_MNU_EDIT_AUTH_V (UNIT_TP_CD='D' Division 단위) — SP INNER JOIN 핵심
 *              :   6.DATA      → DM_MST_EXCHANGE_RATE 마스터 데이터 카운트 / 일자 범위
 *              :   7.JOIN_SIM  → 실제 P_DMF0020_GET_FUTUREPRICE_INFO SP 의 INNER JOIN 시뮬레이션
 *              :
 *              : 본 파일 read-only — UPDATE 없음. 안전 반복 실행.
 *              :
 * 실행 방법   : 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter
 * 실행 계정   : SCM_MGR
 *
 * 판정 기준   :
 *   • 1.USER 의 STATUS = 'ACTIVE' 이어야 정상 ('LOCKED' / 'DISABLED' / 'MISSING' = 문제)
 *   • 2.GROUP 행 1개 이상 (사용자가 어느 그룹에도 안 속하면 권한 불가)
 *   • 3.MENU_PERM STATUS = 'OK' 행 1개 이상 (DMF0020 메뉴 접근 가능)
 *   • 4.BTN_PERM STATUS = 'OK' 행이 SEARCH 포함 (조회 버튼 권한)
 *   • 5.EDIT_AUTH 행 1개 이상 (Division 편집/조회 권한) — ★ 가장 자주 누락되는 영역
 *   • 6.DATA 행에서 COUNT > 0 + 일자 범위 확인
 *   • 7.JOIN_SIM COUNT > 0 → 화면 조회 결과 행 수와 일치
 *
 * 7.JOIN_SIM 이 0 이면 5.EDIT_AUTH 누락이 원인 (메뉴/버튼 권한이 있어도 EDIT_AUTH_V 없으면 그리드 빈 결과)
 *===========================================================================================*/

SELECT '1.USER'                                                          AS SECTION,
       U.USER_ID                                                         AS KEY,
       U.USER_NM                                                         AS VAL,
       CASE WHEN U.USE_YN <> 'Y'      THEN 'DISABLED'
            WHEN U.ACNT_LOK_YN = 'Y'  THEN 'LOCKED'
            ELSE 'ACTIVE' END                                            AS STATUS,
       'DEPT='||NVL(U.DEPT_ID,'(none)')||' LANG='||NVL(U.LANG_CD,'(none)') AS NOTE
  FROM SCM_ADM_USER_M U
 WHERE U.USER_ID = 'minyonglee1'
UNION ALL
SELECT '1.USER'                                                          AS SECTION,
       'minyonglee1'                                                     AS KEY,
       '(not found)'                                                     AS VAL,
       'MISSING'                                                         AS STATUS,
       'SCM_ADM_USER_M 에 행 없음 — 로그인 ID 확인 필요'                  AS NOTE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_M WHERE USER_ID = 'minyonglee1')
UNION ALL
SELECT '2.GROUP'                                                         AS SECTION,
       UGM.USER_GR_ID                                                    AS KEY,
       NVL(GR.USER_GR_NM, '(no group master)')                           AS VAL,
       CASE WHEN UGM.USE_YN = 'Y' THEN 'OK' ELSE 'DISABLED' END          AS STATUS,
       'USER_GR_MPG_M USE_YN='||UGM.USE_YN                               AS NOTE
  FROM SCM_ADM_USER_GR_MPG_M UGM
  LEFT JOIN SCM_ADM_USER_GR_M GR ON GR.USER_GR_ID = UGM.USER_GR_ID
 WHERE UGM.USER_ID = 'minyonglee1'
UNION ALL
SELECT '2.GROUP'                                                         AS SECTION,
       '(none)'                                                          AS KEY,
       '소속 그룹 없음'                                                  AS VAL,
       'MISSING'                                                         AS STATUS,
       'SCM_ADM_USER_GR_MPG_M 에 매핑 없음'                               AS NOTE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1')
UNION ALL
SELECT '3.MENU_PERM'                                                     AS SECTION,
       UGMNU.USER_GR_ID                                                  AS KEY,
       'DMF0020'                                                         AS VAL,
       CASE WHEN UGMNU.USE_YN = 'Y' THEN 'OK' ELSE 'DISABLED' END        AS STATUS,
       TO_CHAR(UGMNU.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI')             AS NOTE
  FROM SCM_ADM_USER_GR_MNU_MPG_M UGMNU
 WHERE UGMNU.MNU_ID = 'DMF0020'
   AND UGMNU.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1')
UNION ALL
SELECT '3.MENU_PERM'                                                     AS SECTION,
       '(none)'                                                          AS KEY,
       'DMF0020 메뉴 권한 없음'                                          AS VAL,
       'MISSING'                                                         AS STATUS,
       '05_DMF0020_Repair_Permissions_DBeaver.sql 실행 필요'              AS NOTE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_MPG_M
                    WHERE MNU_ID = 'DMF0020'
                      AND USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1'))
UNION ALL
SELECT '4.BTN_PERM'                                                      AS SECTION,
       UGBTN.USER_GR_ID                                                  AS KEY,
       UGBTN.SHT_NM||' / '||UGBTN.MNU_BTN_CD                             AS VAL,
       CASE WHEN UGBTN.USE_YN = 'Y' THEN 'OK' ELSE 'DISABLED' END        AS STATUS,
       TO_CHAR(UGBTN.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI')             AS NOTE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M UGBTN
 WHERE UGBTN.MNU_ID = 'DMF0020'
   AND UGBTN.USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1')
UNION ALL
SELECT '4.BTN_PERM'                                                      AS SECTION,
       '(none)'                                                          AS KEY,
       'DMF0020 버튼 권한 없음'                                          AS VAL,
       'MISSING'                                                         AS STATUS,
       'No Permission 오류 직접 원인 가능'                                AS NOTE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
                    WHERE MNU_ID = 'DMF0020'
                      AND USER_GR_ID IN (SELECT USER_GR_ID FROM SCM_ADM_USER_GR_MPG_M WHERE USER_ID = 'minyonglee1'))
UNION ALL
SELECT '5.EDIT_AUTH'                                                     AS SECTION,
       EA.UNIT_ID                                                        AS KEY,
       'Division (UNIT_TP_CD=D)'                                         AS VAL,
       NVL(EA.EDIT_YN, 'NULL')                                           AS STATUS,
       '★ P_DMF0020_GET_FUTUREPRICE_INFO 가 INNER JOIN 하는 뷰'           AS NOTE
  FROM SCM_ADM_USER_MNU_EDIT_AUTH_V EA
 WHERE EA.USER_ID = 'minyonglee1'
   AND EA.MNU_ID = 'DMF0020'
   AND EA.UNIT_TP_CD = 'D'
UNION ALL
SELECT '5.EDIT_AUTH'                                                     AS SECTION,
       '(none)'                                                          AS KEY,
       'EDIT_AUTH_V 행 없음'                                             AS VAL,
       'MISSING'                                                         AS STATUS,
       '★ 화면 조회 시 빈 결과 또는 No Permission 의 가장 흔한 원인'     AS NOTE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
                    WHERE USER_ID = 'minyonglee1' AND MNU_ID = 'DMF0020' AND UNIT_TP_CD = 'D')
UNION ALL
SELECT '6.DATA'                                                          AS SECTION,
       'DM_MST_EXCHANGE_RATE'                                            AS KEY,
       'rows='||TO_CHAR(COUNT(*))                                        AS VAL,
       CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'EMPTY' END                 AS STATUS,
       'min='||NVL(MIN(YYYYMMDD),'-')||' max='||NVL(MAX(YYYYMMDD),'-')   AS NOTE
  FROM DM_MST_EXCHANGE_RATE
UNION ALL
SELECT '7.JOIN_SIM'                                                      AS SECTION,
       'minyonglee1 × DMF0020'                                           AS KEY,
       'visible rows = '||TO_CHAR(COUNT(*))                              AS VAL,
       CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'EMPTY (No Permission)' END AS STATUS,
       'distinct DIV='||COUNT(DISTINCT T1.DIVISION_ID)
       ||' / 일자범위 '||NVL(MIN(T1.YYYYMMDD),'-')||'~'||NVL(MAX(T1.YYYYMMDD),'-') AS NOTE
  FROM DM_MST_EXCHANGE_RATE T1
  INNER JOIN (SELECT UNIT_ID, EDIT_YN FROM SCM_ADM_USER_MNU_EDIT_AUTH_V
               WHERE USER_ID = 'minyonglee1' AND MNU_ID = 'DMF0020' AND UNIT_TP_CD = 'D') T2
    ON T1.DIVISION_ID = T2.UNIT_ID
 ORDER BY SECTION, KEY NULLS LAST, VAL
