-- ============================================================================
-- 55. 메뉴/MSG i18n 통합 정합화 (VERIFY — 적용 후 검증)
-- ----------------------------------------------------------------------------
-- 기대: 4 검증 모두 적용 후 기대 상태
-- ============================================================================

-- [A] LOOKUP_MASTER_DETAIL — MSG_TP_CD : Korean 0건, Label/Message/Menu 3건
SELECT '[A] LOOKUP DESCRIPTION' AS CHECK_ITEM,
       SEGMENT1, DESCRIPTION, DISPLAY_SEQ
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
 WHERE LOOKUP_TYPE='MSG_TP_CD'
 ORDER BY DISPLAY_SEQ;
-- 기대: LBL=Label / MSG=Message / MNU=Menu

-- [B] SCM_ADM_MSG_M.MSG_TP_CD 분포 : MENU/API 0건, LBL/MNU/MSG 3종
SELECT '[B] MSG_TP_CD 분포' AS CHECK_ITEM,
       MSG_TP_CD, COUNT(*) CNT
  FROM SCM_ADM_MSG_M
 GROUP BY MSG_TP_CD
 ORDER BY MSG_TP_CD;
-- 기대 (이전→이후):
--   API=31  (제거)  / MENU=3  (제거)
--   LBL=541 (유지) / MNU=630 (627+3=630) / MSG=82 (51+31=82)

-- [C] SCM_ADM_MNU_M — DMF0043 / DMF0043_01 영문 확인
SELECT '[C] DMF0043 MNU_DESC' AS CHECK_ITEM,
       MNU_ID, MNU_DESC, MNU_MSG_ID
  FROM SCM_ADM_MNU_M
 WHERE MNU_ID LIKE 'DMF0043%';
-- 기대:
--   DMF0043    : "Overseas Subs. Contribution Rate Reg." | MNU00030
--   DMF0043_01 : "Overseas Subs. Contribution Sales"     | MNU00031

-- [D] MessageType combo 시뮬레이션 (KO/EN/CN 세션 결과 동일하게 영문)
SELECT '[D] MessageType combo ('||LANG.LANG_CD||')' AS CHECK_ITEM,
       T1.SEGMENT1 CODE, NVL(MSG.MSG_NM, T1.DESCRIPTION) NAME
  FROM SCM_ADM_LOOKUP_MASTER_DETAIL T1
  CROSS JOIN (SELECT 'KO' LANG_CD FROM DUAL UNION ALL
              SELECT 'EN' FROM DUAL UNION ALL
              SELECT 'CN' FROM DUAL) LANG
  LEFT JOIN SCM_ADM_MSG_M MSG
    ON T1.SEGMENT2 = MSG.MSG_ID AND MSG.LANG_CD = LANG.LANG_CD
 WHERE T1.LOOKUP_TYPE = 'MSG_TP_CD' AND T1.VALID_YN = 'Y'
 ORDER BY LANG.LANG_CD, T1.DISPLAY_SEQ;
-- 기대: 각 언어별 (LBL=Label / MSG=Message / MNU=Menu) — 9 row
