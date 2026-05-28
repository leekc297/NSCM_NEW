/*=============================================================================================
 * File         : 04_DMF0020_Repair_Menu_UPPR_DBeaver_Verify.sql
 * Description  : DMF0020 메뉴 트리 복구 검증 [PART 3 of 3]
 *              :
 *              : 3개 검증 결과를 SECTION 컬럼으로 구분해서 한 그리드에 출력:
 *              :   1.COMPARE  → DMF0007 / DMF0020 비교 + 부모 존재 여부
 *              :   2.CHAIN    → DMF0020 부모 체인 (root 까지 walk-up)
 *              :   3.SIBLING  → DMF0007 과 동일 부모를 가진 형제 목록
 *              :
 *              : ★ 단일 SELECT (UNION ALL) — Ctrl+Enter 한 번에 실행 가능 (ORA-00933 회피).
 *
 * 실행 방법   : 본 파일 열기 → 전체 선택 (Ctrl+A) → Ctrl+Enter (결과 그리드 확인)
 * 실행 계정   : SCM_MGR
 *
 * 판정 기준   :
 *   • 1.COMPARE 의 PARENT_EXISTS 가 두 행 모두 'YES (OK)' 이면 정상
 *   • 1.COMPARE 의 UPPR_MNU_ID / MNU_LV_NO 가 DMF0007 / DMF0020 동일하면 정상
 *   • 2.CHAIN 이 끊김 없이 최상위 (UPPR_MNU_ID 가 NULL 인 행) 까지 도달하면 정상
 *   • 3.SIBLING 에 DMF0020 이 포함되어 있으면 정상
 *===========================================================================================*/

SELECT '1.COMPARE'                                                       AS SECTION,
       NULL                                                              AS DEPTH,
       M.MNU_ID,
       M.UPPR_MNU_ID,
       M.MNU_LV_NO,
       M.SORT_ORD,
       M.USE_YN,
       M.MNU_TP_CD,
       M.MNU_URL,
       CASE WHEN P.MNU_ID IS NULL THEN 'NO (FAIL)' ELSE 'YES (OK)' END   AS PARENT_EXISTS,
       (SELECT MSG_NM FROM SCM_ADM_MSG_M
         WHERE MSG_ID = M.MNU_MSG_ID AND LANG_CD = 'KO' AND ROWNUM = 1)  AS MNU_NM_KO
  FROM SCM_ADM_MNU_M M
  LEFT JOIN SCM_ADM_MNU_M P ON P.MNU_ID = M.UPPR_MNU_ID
 WHERE M.MNU_ID IN ('DMF0007', 'DMF0020')
UNION ALL
SELECT '2.CHAIN'                                                         AS SECTION,
       C.DEPTH,
       C.MNU_ID,
       C.UPPR_MNU_ID,
       C.MNU_LV_NO,
       C.SORT_ORD,
       C.USE_YN,
       C.MNU_TP_CD,
       C.MNU_URL,
       NULL                                                              AS PARENT_EXISTS,
       (SELECT MSG_NM FROM SCM_ADM_MSG_M
         WHERE MSG_ID = C.MNU_MSG_ID AND LANG_CD = 'KO' AND ROWNUM = 1)  AS MNU_NM_KO
  FROM (SELECT LEVEL AS DEPTH,
               MNU_ID, UPPR_MNU_ID, MNU_LV_NO, SORT_ORD, USE_YN, MNU_TP_CD, MNU_URL, MNU_MSG_ID
          FROM SCM_ADM_MNU_M
         START WITH MNU_ID = 'DMF0020'
         CONNECT BY PRIOR UPPR_MNU_ID = MNU_ID) C
UNION ALL
SELECT '3.SIBLING'                                                       AS SECTION,
       NULL                                                              AS DEPTH,
       S.MNU_ID,
       S.UPPR_MNU_ID,
       S.MNU_LV_NO,
       S.SORT_ORD,
       S.USE_YN,
       S.MNU_TP_CD,
       S.MNU_URL,
       CASE WHEN S.MNU_ID = 'DMF0020' THEN 'TARGET'
            WHEN S.MNU_ID = 'DMF0007' THEN 'REF'
            ELSE NULL END                                                AS PARENT_EXISTS,
       (SELECT MSG_NM FROM SCM_ADM_MSG_M
         WHERE MSG_ID = S.MNU_MSG_ID AND LANG_CD = 'KO' AND ROWNUM = 1)  AS MNU_NM_KO
  FROM SCM_ADM_MNU_M S
 WHERE S.UPPR_MNU_ID = (SELECT UPPR_MNU_ID FROM SCM_ADM_MNU_M WHERE MNU_ID = 'DMF0007')
   AND S.USE_YN = 'Y'
 ORDER BY SECTION, DEPTH, SORT_ORD NULLS LAST, MNU_ID
