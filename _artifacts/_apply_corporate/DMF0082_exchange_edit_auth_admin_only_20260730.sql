-- DMF0082 환율 팝업(futurePriceInfo) 편집 권한 — AS-IS 대로 ADMIN·DM ADMIN 2그룹으로 정정
-- 【SCM_MGR 세션】 사용자 승인 2026-07-30. 멱등(재실행 무해).
--
-- 근거 (AS-IS 원문 재확인 2026-07-30):
--   GSCM/06.UIL/GSCM.DM.Plan.UIL/POPUP/DMF0000_ExchangeRatePopup.cs  DefineProperty() L112~143
--     switch (UserInfoContext.Current["NowGroupID"]) {
--       case "ADMIN": case "DM ADMIN": break;                       -- 버튼 유지
--       default: list.Add(Edit); list.Add(Insert); list.Add(Save);
--                btnBPS.Dispose();                                   -- BPS I/F 버튼 제거
--     }
--     if (_division != "40" && list.Count == 0) { ... }               -- ADMIN 계열도 Div40 만
--     btnButtonList.Set_ButtonVisibleFalse(list);                    -- list = 숨길 버튼
--
--   ⚠️ Doc/화면분석서/DMF0082_FcstNPrice_제약매트릭스_상세.md §2 의 "팝업 ADMIN/DM ADMIN 게이트 부재"
--      기록은 그 문서가 이 팝업을 "본 문서 범위 밖"으로 둔 탓 — "범위 밖"을 "부재"로 읽은 오판이었다.
--
-- 범위: futurePriceInfo(환율 팝업) 시트 한정. **DMF0082 메인 화면(FcstNPrice) 5그룹 편집 권한은 무변경**
--       (사용자 확정: 메인 화면은 DM Planner / DM Planner (W/S) / SCP Planner 편집 가능 유지).

-- [백업] 적용 전 상태 (결과를 남길 것)
SELECT MNU_ID, SHT_NM, MNU_BTN_CD, USER_GR_ID, USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'futurePriceInfo'
 ORDER BY MNU_BTN_CD, USER_GR_ID;

-- [정정] 9행 (EDIT/IF/SAVE × DM Planner / DM Planner (W/S) / SCP Planner) → USE_YN='N'
--   삭제가 아니라 비활성 — 이력 보존 + 원복 용이
UPDATE SCM_ADM_USER_GR_MNU_BTN_MPG_M
   SET USE_YN           = 'N',
       LAST_UPDATED_BY  = 'admin',
       LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID     = 'DMF0082'
   AND SHT_NM     = 'futurePriceInfo'
   AND MNU_BTN_CD IN ('EDIT','IF','SAVE')
   AND USER_GR_ID IN ('DM Planner','DM Planner (W/S)','SCP Planner')
   AND NVL(USE_YN,'-') <> 'N';
COMMIT;

-- [검증] futurePriceInfo 의 EDIT/IF/SAVE 는 ADMIN·DM ADMIN 만 'Y' 여야 한다
SELECT MNU_BTN_CD, USER_GR_ID, USE_YN
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'futurePriceInfo' AND MNU_BTN_CD IN ('EDIT','IF','SAVE')
 ORDER BY MNU_BTN_CD, USER_GR_ID;

-- [검증] 메인 화면(FcstNPrice)은 무변경 — SAVE/INSERT/UPLOAD* 5그룹 'Y' 유지
SELECT MNU_BTN_CD, COUNT(*) GRPS
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M
 WHERE MNU_ID = 'DMF0082' AND SHT_NM = 'FcstNPrice' AND USE_YN = 'Y'
 GROUP BY MNU_BTN_CD ORDER BY 1;

-- [원복]
--   UPDATE SCM_ADM_USER_GR_MNU_BTN_MPG_M SET USE_YN='Y', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
--    WHERE MNU_ID='DMF0082' AND SHT_NM='futurePriceInfo' AND MNU_BTN_CD IN ('EDIT','IF','SAVE')
--      AND USER_GR_ID IN ('DM Planner','DM Planner (W/S)','SCP Planner');
--   COMMIT;
