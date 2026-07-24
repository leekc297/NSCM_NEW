-- ============================================================================
-- [Step 5] DMF0082 환율 Modal ADMIN 저장 — 메타 배선 (클라우드용)
-- 사내 정본 = _artifacts/_apply_corporate/DMF0082_exchange_modal_save_wiring_20260724.sql
--   (사내 2026-07-24 적용 완료 — 본 파일은 클라우드 이관본:
--    ① PROC_M = SP 단위 DELETE 후 INSERT — MERGE 는 PK(PROC_NM,COL_NM,COL_TP_CD)
--      환경에서 ORA-00001 (hook deploy-package-completeness §4.5 #2)
--    ② API_M / MSG = NOT EXISTS INSERT + 기존 row 표준값 UPDATE 보정 동반 (§1.7 —
--      클라우드에 다른 값의 동일 키가 있으면 INSERT skip 만으로는 못 고침)
--
-- ⚠ 감사 2키 COL_NM = createdByBulk / lastUpdatedByBulk (변경 금지):
--   BE NDaoInterface L436~437 이 'createdBy'/'lastUpdatedBy' 키를 세션 단일값으로
--   무조건 덮어씀 → '^' N-토큰 병렬 파싱 SP 에서 2행부터 NULL → ORA-01400.
--   별도 키명으로 FE 가 N-반복 토큰을 그대로 전달 (AS-IS FE L414~415 1:1).
-- ============================================================================

-- [1] API_M — 저장 API (NOT EXISTS + API_URL/USE_YN 보정)
INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0082_futurePriceInfo_SAVE', 'PROC_SAVE', 'MSG_API_DMF0082_futurePriceInfo_SAVE',
       'DMF0082 환율(Exchange Rate) 팝업 저장', 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE API_ID = 'DMF0082_futurePriceInfo_SAVE');

UPDATE SCM_ADM_API_M
   SET API_URL = 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA',
       API_TP_CD = 'PROC_SAVE', USE_YN = 'Y',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE API_ID = 'DMF0082_futurePriceInfo_SAVE'
   AND (API_URL <> 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA'
        OR API_TP_CD <> 'PROC_SAVE' OR USE_YN <> 'Y');

-- [2] PROC_M — SP 단위 DELETE 후 INSERT (ALL_ARGUMENTS 실측 순서 — 8 IN + OUT)
DELETE FROM SCM_ADM_PROC_M WHERE PROC_NM = 'PKG_DMF0000.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA';

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
) t;

-- [3-1] MNU_BTN_MPG_M — futurePriceInfo 시트 버튼 3종
--   SAVE = call-proc 호출 대상(API_ID 연결) / EDIT·INSERT = FE hasButton gating 신호(API 없음)
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

UPDATE SCM_ADM_MNU_BTN_MPG_M
   SET API_ID = 'DMF0082_futurePriceInfo_SAVE', USE_YN = 'Y',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'futurePriceInfo' AND MNU_BTN_CD = 'SAVE'
   AND (API_ID IS NULL OR API_ID <> 'DMF0082_futurePriceInfo_SAVE' OR USE_YN <> 'Y');

-- [3-2] USER_GR_MNU_BTN_MPG_M — ADMIN / DM ADMIN 만
--   (AS-IS DMF0000_ExchangeRatePopup.DefineProperty NowGroupID 스위치 1:1 — 'IF' 버튼 선례)
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

-- [4] MSG_M — MSG00689 (AS-IS MSG00456 원문 1:1, 사내 신규 채번분 동기.
--   클라우드에 동일 ID 가 다른 문구로 선점돼 있으면 UPDATE 보정 — 사내가 채번 권위)
INSERT INTO SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'MSG00689', t.LANG_CD, 'Sales Price Recalculation is complete.', 'MSG', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
FROM (SELECT 'KO' AS LANG_CD FROM DUAL UNION ALL SELECT 'EN' FROM DUAL UNION ALL SELECT 'CN' FROM DUAL) t
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_ADM_MSG_M m WHERE m.MSG_ID = 'MSG00689' AND m.LANG_CD = t.LANG_CD
);

UPDATE SCM_ADM_MSG_M
   SET MSG_NM = 'Sales Price Recalculation is complete.', USE_YN = 'Y',
       LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE MSG_ID = 'MSG00689'
   AND (MSG_NM <> 'Sales Price Recalculation is complete.' OR USE_YN <> 'Y');

COMMIT;
