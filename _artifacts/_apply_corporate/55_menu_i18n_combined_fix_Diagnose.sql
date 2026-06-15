-- ============================================================================
-- 55. 메뉴/MSG i18n 통합 정합화 (DIAGNOSE — 적용 전 사전 점검, DML 없음)
-- ----------------------------------------------------------------------------
-- 적용 환경 (다른 클라우드 / 운영) 에 대해 사전 영향 범위 확인
-- ============================================================================

-- [Pre-1] LOOKUP DESCRIPTION 현재 값 (Korean 잔존 여부)
SELECT '[Pre-1] LOOKUP MSG_TP_CD' AS CHECK_ITEM,
       SEGMENT1, DESCRIPTION, DISPLAY_SEQ, VALID_YN
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='MSG_TP_CD'
 ORDER BY DISPLAY_SEQ;

-- [Pre-2] MSG_TP_CD 분포 (MENU/API 잔존 여부)
SELECT '[Pre-2] MSG_TP_CD 분포' AS CHECK_ITEM,
       MSG_TP_CD, COUNT(*) CNT
  FROM SCM_ADM_MSG_M
 GROUP BY MSG_TP_CD
 ORDER BY MSG_TP_CD;

-- [Pre-3] MSG_TP_CD='MENU' / 'API' row 인벤토리
SELECT '[Pre-3] MENU row' AS CHECK_ITEM, MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_TP_CD='MENU'
UNION ALL
SELECT '[Pre-3] API row 상위 10', MSG_ID, LANG_CD, MSG_NM
  FROM (SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M
         WHERE MSG_TP_CD='API' ORDER BY MSG_ID)
 WHERE ROWNUM <= 10;

-- [Pre-4] DMF0043 / DMF0043_01 MNU_DESC 현재 값 (한글 잔존 여부)
SELECT '[Pre-4] DMF0043 MNU_DESC' AS CHECK_ITEM,
       MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID LIKE 'DMF0043%';

-- [Pre-5] DMF0043 i18n key (MNU00030/00031) i18n 영문화 여부
SELECT '[Pre-5] MNU00030/00031 i18n' AS CHECK_ITEM,
       MSG_ID, LANG_CD, MSG_NM
  FROM SCM_ADM_MSG_M
 WHERE MSG_ID IN ('MNU00030','MNU00031')
 ORDER BY MSG_ID, LANG_CD;

-- [Pre-6] 자매 화면 MNU_DESC 영문 표준 참고
SELECT '[Pre-6] 자매 DMF004*' AS CHECK_ITEM,
       MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID LIKE 'DMF004%'
 ORDER BY MNU_ID;
