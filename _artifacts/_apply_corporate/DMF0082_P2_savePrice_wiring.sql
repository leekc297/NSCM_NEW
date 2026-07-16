-- =====================================================================
-- DMF0082 (Fcst&Price MGMT) P2 — SavePricePeriodModal (Price 기간 일괄저장 POPUP) 메타 배선
--   (2026-07-12 — AS-IS DMF0082_SaveSalesFuturePrice_Popup 1:1 TO-BE 전환분)
--
-- 구성: ① MSG 3종 (MSG00330/MSG00409 = AS-IS ID 승계 신규 등록 + MSG00672 = 신규 채번)
--       ② PROC_M 2종 (POPUP GET / SPREAD_TITLE_SAVE_PRICE — ALL_ARGUMENTS positional 실측 대조)
--       ③ API_M 2종 (savePriceData / savePriceTitle SEARCH)
--       ④ BTN_MPG 2종 (SHT_NM = FE SHEETS value 그대로: savePriceData / savePriceTitle)
--       ⑤ USER_GR 3그룹 × 2시트 (조회성 시트 → ADMIN / DM ADMIN / DM Viewer 3그룹.
--          저장은 기배선 fcstNPrice SAVE(DMF0082_SAVE_MAIN_DATA — PROC_M 17행 실측 일치) 재사용이라
--          본 SQL 에 저장 배선 없음 → Viewer 저장권한 변화 없음)
--
-- 실측 근거 (2026-07-12 ora.py):
--   - DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP: 17 IN + O_CURSOR(18)
--   - DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE: 4 IN + O_RESULT_CURSOR(5)
--   - SCM_ADM_MSG_M: MSG00330/MSG00409 미존재(빈 슬롯 — AS-IS ID 승계) / MAX 신규채번 = MSG00672
--   - BTN_MPG 기존 6행 (fcstNPrice SEARCH·SAVE / spreadTitle / version / futurePriceInfo / titleSet)
--
-- ⚠️ 알려진 SP 잠재결함 (본 SQL 범위 밖 — 후속 SP patch 필요):
--   DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP 의 V_Prod 조립부(LISTAGG '[' || YYYYMMDD || ']')가
--   MSSQL bracket 잔재 → 동적 PIVOT IN ([W_yyyymmdd]) 는 Oracle 런타임 ORA-00936 (DUAL 재현 실측).
--   교정 시 PIVOT alias(AS PVT)로 컬럼명이 W_yyyymmdd_PVT 가 되어도 FE 는 키 정규화(/W_(\d{8})/)로 흡수.
--
-- 멱등 MERGE (PROC_M 은 DELETE+INSERT — 표준) / 감사 'admin' (hook #98 §1.1).
-- =====================================================================

-- ① MSG 3종
--   MSG00330/MSG00409: TO-BE MSG_M 빈 슬롯 — AS-IS TB_FX_MessageInfo 원문 승계 등록
--   (FE 는 DMF0020 PriceBatchInputModal 도 동일 키 t('MSG00330')/t('MSG00409') 참조 중 — 키 정합 회복)
--   MSG00672: 신규 채번 ({0}개 저장 — AS-IS MSG00004. TO-BE MSG00002 는 건수 없는 일반 저장성공이라 별도 채번)
MERGE INTO SCM_MGR.SCM_ADM_MSG_M t
USING (
  SELECT 'MSG00330' MSG_ID, 'KO' LANG_CD, '기간을 다시 선택하여 주십시오.(월요일)' MSG_NM FROM DUAL
  UNION ALL SELECT 'MSG00330', 'EN', 'Select period again. (Monday)' FROM DUAL
  UNION ALL SELECT 'MSG00330', 'CN', '请重新选择期间.(星期一)' FROM DUAL
  UNION ALL SELECT 'MSG00409', 'KO', '과거 구간은 일괄입력이 불가합니다. 현재/미래 구간으로 기간 설정해주세요.' FROM DUAL
  UNION ALL SELECT 'MSG00409', 'EN', 'Batch input is not allowed for past periods. Set the period to current/future weeks.' FROM DUAL
  UNION ALL SELECT 'MSG00409', 'CN', '过去区间无法批量输入. 请将期间设置为当前/未来区间.' FROM DUAL
  UNION ALL SELECT 'MSG00672', 'KO', '{0}개의 데이터가 저장되었습니다.' FROM DUAL
  UNION ALL SELECT 'MSG00672', 'EN', '{0} data saved.' FROM DUAL
  UNION ALL SELECT 'MSG00672', 'CN', '已保存 {0} 条数据.' FROM DUAL
) s
ON (t.MSG_ID = s.MSG_ID AND t.LANG_CD = s.LANG_CD)
WHEN MATCHED THEN UPDATE SET t.MSG_NM = s.MSG_NM, t.MSG_TP_CD = 'MSG', t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.MSG_ID, s.LANG_CD, s.MSG_NM, NULL, 'MSG', 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ② PROC_M — DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP
--    (ALL_ARGUMENTS 실측 positional 1:1 — 17 IN + O_CURSOR.
--     COL_NM = FE filters 키(procedures.d.ts savePriceData 정합).
--     13 P_CREATED_BY → sesUserId (BE 세션 자동 주입 명칭) / 14 P_USERINFO → userGroup)
DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP';
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP', COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
  'admin', SYSDATE, 'admin', SYSDATE
FROM (
  SELECT 'divisionId' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL          -- P_DIVISION_ID
  UNION ALL SELECT 'deptId', 'VARCHAR', 'IN', 2 FROM DUAL                                          -- P_DEPT_ID
  UNION ALL SELECT 'endCustomer', 'VARCHAR', 'IN', 3 FROM DUAL                                     -- P_END_CUSTOMER
  UNION ALL SELECT 'scmSiteId', 'VARCHAR', 'IN', 4 FROM DUAL                                       -- P_SCM_SITE_ID
  UNION ALL SELECT 'plantSiteId', 'VARCHAR', 'IN', 5 FROM DUAL                                     -- P_PLANT_SITE_ID
  UNION ALL SELECT 'projectCode', 'VARCHAR', 'IN', 6 FROM DUAL                                     -- P_PROJECT_CODE
  UNION ALL SELECT 'itemId', 'VARCHAR', 'IN', 7 FROM DUAL                                          -- P_ITEM_ID
  UNION ALL SELECT 'customerProjectCode', 'VARCHAR', 'IN', 8 FROM DUAL                             -- P_CUSTOMER_PROJECT_CODE
  UNION ALL SELECT 'customerModel', 'VARCHAR', 'IN', 9 FROM DUAL                                   -- P_CUSTOMER_MODEL
  UNION ALL SELECT 'fromYyyymmdd', 'VARCHAR', 'IN', 10 FROM DUAL                                   -- P_FROM_YYYYMMDD
  UNION ALL SELECT 'toYyyymmdd', 'VARCHAR', 'IN', 11 FROM DUAL                                     -- P_TO_YYYYMMDD
  UNION ALL SELECT 'biztype', 'VARCHAR', 'IN', 12 FROM DUAL                                        -- P_BIZTYPE
  UNION ALL SELECT 'sesUserId', 'VARCHAR', 'IN', 13 FROM DUAL                                      -- P_CREATED_BY (BE 자동)
  UNION ALL SELECT 'userGroup', 'VARCHAR', 'IN', 14 FROM DUAL                                      -- P_USERINFO
  UNION ALL SELECT 'owner', 'VARCHAR', 'IN', 15 FROM DUAL                                          -- P_OWNER
  UNION ALL SELECT 'overRange', 'VARCHAR', 'IN', 16 FROM DUAL                                      -- P_OVER_RANGE
  UNION ALL SELECT 'invalidExec', 'VARCHAR', 'IN', 17 FROM DUAL                                    -- P_INVALID_EXEC
  UNION ALL SELECT 'data', 'CURSOR', 'OUT', 18 FROM DUAL                                           -- O_CURSOR
);

-- ② PROC_M — DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE
--    (실측: P_START_DT / P_END_DT / P_CREATED_BY / P_DIVISION_ID + O_RESULT_CURSOR.
--     기존 DMF0082_GET_SPREAD_TITLE(P1) 과 동일 4-IN 계약 형태 — COL_NM 도 동일 관례)
DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM = 'DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE';
INSERT INTO SCM_MGR.SCM_ADM_PROC_M (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE', COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
  'admin', SYSDATE, 'admin', SYSDATE
FROM (
  SELECT 'startYyyymmdd' COL_NM, 'VARCHAR' DATA_TP_CD, 'IN' COL_TP_CD, 1 SORT_ORD FROM DUAL        -- P_START_DT
  UNION ALL SELECT 'endYyyymmdd', 'VARCHAR', 'IN', 2 FROM DUAL                                     -- P_END_DT
  UNION ALL SELECT 'sesUserId', 'VARCHAR', 'IN', 3 FROM DUAL                                       -- P_CREATED_BY (BE 자동)
  UNION ALL SELECT 'divisionId', 'VARCHAR', 'IN', 4 FROM DUAL                                      -- P_DIVISION_ID
  UNION ALL SELECT 'data', 'CURSOR', 'OUT', 5 FROM DUAL                                            -- O_RESULT_CURSOR
);

-- ③ API_M 2종 (API_URL = SP 명 — API_ID 정확조회 진단 룰 정합)
MERGE INTO SCM_MGR.SCM_ADM_API_M t
USING (
  SELECT 'DMF0082_savePriceData_SEARCH' API_ID, 'PROC_SELECT' API_TP_CD,
         'DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP' API_URL,
         'DMF0082 Price 기간 일괄저장 팝업 조회 (LOC 주차 PIVOT)' API_MSG_DESC FROM DUAL
  UNION ALL SELECT 'DMF0082_savePriceTitle_SEARCH', 'PROC_SELECT',
         'DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE',
         'DMF0082 Price 기간 일괄저장 팝업 시간축(W_주차) 조회' FROM DUAL
) s
ON (t.API_ID = s.API_ID)
WHEN MATCHED THEN UPDATE SET t.API_TP_CD = s.API_TP_CD, t.API_URL = s.API_URL,
  t.API_MSG_DESC = s.API_MSG_DESC, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.API_ID, s.API_TP_CD, 'MSG_API_' || s.API_ID, s.API_MSG_DESC, s.API_URL, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ④ BTN_MPG 2종 (SHT_NM = FE SHEETS value: 'savePriceData' / 'savePriceTitle' — MNU_BTN_CD 표준 SEARCH)
MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M t
USING (
  SELECT 'DMF0082' MNU_ID, 'savePriceData' SHT_NM, 'SEARCH' MNU_BTN_CD, 'DMF0082_savePriceData_SEARCH' API_ID FROM DUAL
  UNION ALL SELECT 'DMF0082', 'savePriceTitle', 'SEARCH', 'DMF0082_savePriceTitle_SEARCH' FROM DUAL
) s
ON (t.MNU_ID = s.MNU_ID AND t.SHT_NM = s.SHT_NM AND t.MNU_BTN_CD = s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.API_ID = s.API_ID, t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, s.API_ID, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

-- ⑤ USER_GR — 조회성 2시트 × 3그룹 (ADMIN / DM ADMIN / DM Viewer — P1 선례 동일.
--    팝업 저장 권한은 기배선 fcstNPrice SAVE 의 기존 그룹 매핑을 그대로 따름 — 본 SQL 무변경)
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M t
USING (
  SELECT g.USER_GR_ID, 'DMF0082' MNU_ID, b.SHT_NM, b.MNU_BTN_CD
  FROM (SELECT 'ADMIN' USER_GR_ID FROM DUAL
        UNION ALL SELECT 'DM ADMIN' FROM DUAL
        UNION ALL SELECT 'DM Viewer' FROM DUAL) g
  CROSS JOIN (
    SELECT 'savePriceData' SHT_NM, 'SEARCH' MNU_BTN_CD FROM DUAL
    UNION ALL SELECT 'savePriceTitle', 'SEARCH' FROM DUAL
  ) b
) s
ON (t.USER_GR_ID = s.USER_GR_ID AND t.MNU_ID = s.MNU_ID AND t.SHT_NM = s.SHT_NM AND t.MNU_BTN_CD = s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.USE_YN = 'Y',
  t.LAST_UPDATED_BY = 'admin', t.LAST_UPDATE_DATE = SYSDATE
WHEN NOT MATCHED THEN INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (s.USER_GR_ID, s.MNU_ID, s.SHT_NM, s.MNU_BTN_CD, 'Y',
  'admin', SYSDATE, 'admin', SYSDATE);

COMMIT;

-- 검증 (적용 후 실행 권장)
-- SELECT PROC_NM, COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M
--  WHERE PROC_NM IN ('DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP',   -- 기대 18
--                    'DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE')                 -- 기대 5
--  GROUP BY PROC_NM;
-- SELECT * FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' AND SHT_NM LIKE 'savePrice%';
-- SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M
--  WHERE MSG_ID IN ('MSG00330','MSG00409','MSG00672') ORDER BY MSG_ID, LANG_CD;   -- 기대 9행

-- 원복 (ROLLBACK — 필요 시 수동)
-- DELETE FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID IN ('MSG00330','MSG00409','MSG00672');
-- DELETE FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM IN ('DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP','DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE');
-- DELETE FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' AND SHT_NM IN ('savePriceData','savePriceTitle');
-- DELETE FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='DMF0082' AND SHT_NM IN ('savePriceData','savePriceTitle');
-- DELETE FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID IN ('DMF0082_savePriceData_SEARCH','DMF0082_savePriceTitle_SEARCH');
-- COMMIT;
