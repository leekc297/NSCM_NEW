-- ============================================================================
-- DMF0082 환율(Exchange Rate) Modal — ADMIN 편집/저장 기능 메타 배선
-- 작성: 2026-07-24 (AS-IS DMF0000_ExchangeRatePopup 편집/저장 기능 TO-BE 구현)
--
-- AS-IS: GSCM\06.UIL\GSCM.DM.Plan.UIL\POPUP\DMF0000_ExchangeRatePopup.cs
--   - DefineProperty L120~141: NowGroupID IN ('ADMIN','DM ADMIN') && division='40'
--     에서만 Edit/Insert/Save 버튼 노출 → TO-BE = 그룹×버튼 매핑 (IF 버튼 선례 1:1)
--   - SaveData L440: DM.DMF0000_SAVE_EXCHANGE_POPUP_DATA ('^' bulk 8키)
--     → TO-BE 기배포 PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA (본문 무수정)
--
-- 배선 3점 (hook #98 corp-meta-integrity-and-wiring):
--   [1] SCM_ADM_API_M          : DMF0082_futurePriceInfo_SAVE → PKG_DMF0000 SAVE
--   [2] SCM_ADM_PROC_M         : SAVE SP 8 IN + 1 OUT (camelCase — DMF0082 POPUP 선례)
--       ⚠ 감사 2키 COL_NM = createdByBulk/lastUpdatedByBulk
--         (BE NDaoInterface L436~437 이 'createdBy'/'lastUpdatedBy' 키를 세션 단일값으로
--          무조건 덮어씀 → '^' N-토큰 병렬 파싱 SP 에서 2행부터 NULL → ORA-01400.
--          다른 키명으로 등록해 FE 가 N-반복 토큰을 그대로 전달 — AS-IS FE L414~415 1:1)
--   [3] SCM_ADM_MNU_BTN_MPG_M + SCM_ADM_USER_GR_MNU_BTN_MPG_M
--       : futurePriceInfo 시트 SAVE(호출용)/EDIT·INSERT(FE 표시 gating용)
--         → ADMIN, DM ADMIN 만 (AS-IS 그룹 스위치 1:1. 서버측 call-proc 는
--           CustomAuthorizationManager 가 시트단위 checkMenuBtnAuth 로 강제)
--   [4] SCM_ADM_MSG_M          : MSG00689 (AS-IS MSG00456 'Sales Price Recalculation is
--         complete.' — TO-BE 부재 → MAX(MSG00688)+1 신규 채번. hook #114 절차)
--
-- 멱등: 전 INSERT NOT EXISTS 가드. 감사컬럼 = 'admin' (메모리 meta_audit_column_admin_only)
-- ============================================================================

-- [1] API_M — 저장 API 등록
INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0082_futurePriceInfo_SAVE', 'PROC_SAVE', 'MSG_API_DMF0082_futurePriceInfo_SAVE',
       'DMF0082 환율(Exchange Rate) 팝업 저장', 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE API_ID = 'DMF0082_futurePriceInfo_SAVE');

-- [2] PROC_M — SAVE SP 시그니처 (ALL_ARGUMENTS 실측 8 IN + O_RESULT_CURSOR OUT 순서 일치)
INSERT INTO SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
                            CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', t.COL_NM, t.DATA_TP_CD, t.COL_TP_CD, t.SORT_ORD,
       'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT 'activeFlag'        AS COL_NM, 'VARCHAR'     AS DATA_TP_CD, 'IN'  AS COL_TP_CD, 1 AS SORT_ORD FROM DUAL UNION ALL
    SELECT 'divisionId',              'VARCHAR',     'IN',  2 FROM DUAL UNION ALL
    SELECT 'yyyymmdd',                'VARCHAR',     'IN',  3 FROM DUAL UNION ALL
    SELECT 'currency',                'VARCHAR',     'IN',  4 FROM DUAL UNION ALL
    SELECT 'unitCurrency',            'VARCHAR',     'IN',  5 FROM DUAL UNION ALL
    SELECT 'exchangePrice',           'VARCHAR',     'IN',  6 FROM DUAL UNION ALL
    SELECT 'createdByBulk',           'VARCHAR',     'IN',  7 FROM DUAL UNION ALL
    SELECT 'lastUpdatedByBulk',       'VARCHAR',     'IN',  8 FROM DUAL UNION ALL
    SELECT 'o_result_cursor',         'PROC_RESULT', 'OUT', 9 FROM DUAL
) t
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_PROC_M p
    WHERE p.PROC_NM = 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA'
      AND p.COL_NM = t.COL_NM AND p.COL_TP_CD = t.COL_TP_CD
);

-- [3-1] MNU_BTN_MPG_M — futurePriceInfo 시트 버튼 3종
--   SAVE  : call-proc 호출 대상 (API_ID 연결)
--   EDIT  : FE 셀 편집 gating 신호 (hasButton — 메뉴 유일 코드, API 없음)
--   INSERT: FE Insert 버튼 gating 신호 (API 없음)
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0082', 'futurePriceInfo', t.BTN_CD, t.API_ID, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT 'SAVE' AS BTN_CD, 'DMF0082_futurePriceInfo_SAVE' AS API_ID FROM DUAL UNION ALL
    SELECT 'EDIT',   NULL FROM DUAL UNION ALL
    SELECT 'INSERT', NULL FROM DUAL
) t
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M b
    WHERE b.MNU_ID = 'DMF0082' AND b.SHT_NM = 'futurePriceInfo' AND b.MNU_BTN_CD = t.BTN_CD
);

-- [3-2] USER_GR_MNU_BTN_MPG_M — ADMIN / DM ADMIN 만 (AS-IS NowGroupID 스위치 1:1, IF 버튼 선례)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT g.GR_ID, 'DMF0082', 'futurePriceInfo', b.BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM (SELECT 'ADMIN' AS GR_ID FROM DUAL UNION ALL SELECT 'DM ADMIN' FROM DUAL) g
CROSS JOIN (SELECT 'SAVE' AS BTN_CD FROM DUAL UNION ALL SELECT 'EDIT' FROM DUAL UNION ALL SELECT 'INSERT' FROM DUAL) b
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
    WHERE u.USER_GR_ID = g.GR_ID AND u.MNU_ID = 'DMF0082'
      AND u.SHT_NM = 'futurePriceInfo' AND u.MNU_BTN_CD = b.BTN_CD
);

-- [4] MSG_M — MSG00689 신규 채번 (AS-IS MSG00456 실문구. MAX 실측 MSG00688 + 1, KO=EN=CN 동일)
INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00689', t.LANG_CD, 'Sales Price Recalculation is complete.', 'MSG', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM (SELECT 'KO' AS LANG_CD FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) t
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_MSG_M m WHERE m.MSG_ID = 'MSG00689' AND m.LANG_CD = t.LANG_CD
);

COMMIT;

-- 검증
SELECT API_ID, API_URL FROM SCM_ADM_API_M WHERE API_ID = 'DMF0082_futurePriceInfo_SAVE';
SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_ADM_PROC_M
 WHERE PROC_NM = 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA' ORDER BY SORT_ORD;
SELECT MNU_BTN_CD, API_ID FROM SCM_ADM_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'futurePriceInfo' ORDER BY MNU_BTN_CD;
SELECT USER_GR_ID, MNU_BTN_CD FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'futurePriceInfo' ORDER BY USER_GR_ID, MNU_BTN_CD;
SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_ADM_MSG_M WHERE MSG_ID = 'MSG00689' ORDER BY LANG_CD;
