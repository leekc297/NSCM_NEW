--==============================================================================
-- 40_Register_5_DMF_Menus_in_Demand_Master_Verify.sql  (단일 SELECT 검증)
--
-- 단일 UNION ALL SELECT 로 모든 머지 게이트 항목을 한 번에 검증.
-- DBeaver Ctrl+Enter 로 실행해 RESULT 컬럼이 모두 OK 인지 확인.
--
-- 작성: 2026-05-30
--==============================================================================
SELECT CHECK_ITEM, ACTUAL, EXPECTED,
       CASE WHEN ACTUAL = EXPECTED THEN 'OK' ELSE 'FAIL' END AS RESULT
  FROM (
    -- 1) i18n 메시지 (5 화면 × 3 lang = 15 행. DMF0020 기존 3 행 + 신규 4 화면 × 3 = 12 행 = 합 15)
    SELECT '1.MSG_M (15)' AS CHECK_ITEM,
           TO_CHAR(COUNT(*)) AS ACTUAL, '15' AS EXPECTED,
           1 AS ORD
      FROM SCM_MGR.SCM_ADM_MSG_M
     WHERE MSG_ID IN ('MNU_DMF0043','MNU_DMF0043_01','MNU_DMF0008','MNU_DMF0072','MNU_DMF0020')

    UNION ALL
    -- 2) MNU_M 5 행
    SELECT '2.MNU_M (5)',
           TO_CHAR(COUNT(*)), '5', 2
      FROM SCM_MGR.SCM_ADM_MNU_M
     WHERE MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')

    UNION ALL
    -- 3) GUEST 메뉴 권한 5 행
    SELECT '3.GUEST PERM (5)',
           TO_CHAR(COUNT(*)), '5', 3
      FROM SCM_MGR.SCM_ADM_USER_GR_MNU_MPG_M
     WHERE USER_GR_ID = 'GUEST' AND MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')

    UNION ALL
    -- 4) 모든 5 행이 Demand_Master 부모 + MNU_LV_NO=3 + SCREEN + UNIT D
    SELECT '4.MNU_M tree (5)',
           TO_CHAR(COUNT(*)), '5', 4
      FROM SCM_MGR.SCM_ADM_MNU_M
     WHERE MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')
       AND UPPR_MNU_ID = 'Demand_Master'
       AND MNU_LV_NO = 3
       AND MNU_TP_CD = 'SCREEN'
       AND UNIT_TP_CD = 'D'
       AND USE_YN = 'Y'

    UNION ALL
    -- 5) MNU_URL 매핑 (FE route-paths.ts slug 와 정합)
    SELECT '5.MNU_URL slug (5)',
           TO_CHAR(COUNT(*)), '5', 5
      FROM SCM_MGR.SCM_ADM_MNU_M
     WHERE (MNU_ID='DMF0043'    AND MNU_URL='contribute-main')
        OR (MNU_ID='DMF0043_01' AND MNU_URL='contribute-view')
        OR (MNU_ID='DMF0008'    AND MNU_URL='erp-edi-master')
        OR (MNU_ID='DMF0072'    AND MNU_URL='nn-master-mapping')
        OR (MNU_ID='DMF0020'    AND MNU_URL='sales-future-price')

    UNION ALL
    -- 6) MNU_MSG_ID 정합 (각 화면 → 해당 MSG_ID 3 lang 존재)
    SELECT '6.MNU_MSG_ID join (15)',
           TO_CHAR(COUNT(*)), '15', 6
      FROM SCM_MGR.SCM_ADM_MNU_M M
      JOIN SCM_MGR.SCM_ADM_MSG_M S ON S.MSG_ID = M.MNU_MSG_ID
     WHERE M.MNU_ID IN ('DMF0043','DMF0043_01','DMF0008','DMF0072','DMF0020')

    UNION ALL
    -- 7) SORT_ORD 충돌 (Demand_Master 자식 메뉴 sort_ord 중복 0 건)
    SELECT '7.SORT_ORD conflict (0)',
           TO_CHAR(COUNT(*)), '0', 7
      FROM (
        SELECT SORT_ORD, COUNT(*) C
          FROM SCM_MGR.SCM_ADM_MNU_M
         WHERE UPPR_MNU_ID = 'Demand_Master'
         GROUP BY SORT_ORD
        HAVING COUNT(*) > 1
      )
  )
 ORDER BY ORD;
