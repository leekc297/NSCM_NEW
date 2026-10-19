-- SOURCE-FRESH: META SCM_ADM_MNU_BTN_MPG_M / SCM_ADM_USER_GR_MNU_BTN_MPG_M (MNU_ID='DMF0043') ZIOUI1 FETCHED=2026-10-15 (24h)
--   사전값(사내 실측): MNU_BTN_MPG_M DMF0043|version = SAVE·SEARCH 2행
--                      USER_GR_MNU_BTN DMF0043|version SAVE = ADMIN Y / DM ADMIN Y / DM Viewer Y / GUEST N
-- =====================================================================================
-- [E20261015-VERPOPAUTH] DMF0043 Contribution Rate Reg. — 기여율 버전관리 팝업 버튼 권한 (GAP 291 / INT-09)
--
-- AS-IS  : GSCM.DM.Plan.UIL/POPUP/DMF0043_ContributeRatePopup.cs DefineProperty L111~123
--          switch (NowGroupID) — case "ADMIN" / "DM ADMIN" = 통과,
--                                default = Edit/Insert/Save/Delete Set_ButtonVisibleFalse
--          → ADMIN·DM ADMIN 그룹에만 Edit/Insert/Save/Delete 표시
-- TO-BE  : ContributeVersionModal 이 Insert/Delete/Save 를 무조건 렌더 + DM Viewer 가 version|SAVE 보유
--          → 전 그룹 표시·저장 가능 (GAP)
-- 보완   : 그룹×버튼 메타로 이관 (DMF0082 ExchangeRateModal EDIT 게이트 선례 1:1)
--          판정 = PKG_NSCM_UI_COM_AUTH (USER_ID → 보유 그룹 전체 JOIN = 보유 그룹 합집합 판정)
--   [1] SCM_ADM_MNU_BTN_MPG_M         : DMF0043|version 에 EDIT/INSERT/DELETE (FE 표시 게이트용, API 없음)
--   [2] SCM_ADM_USER_GR_MNU_BTN_MPG_M : 위 3종 = ADMIN·DM ADMIN 만
--   [3] version|SAVE 의 ADMIN·DM ADMIN 외 그룹 회수(USE_YN='N') — 서버 checkMenuBtnAuth 가 저장 API 차단
--       (물리 DELETE 없음 — 99_ROLLBACK 으로 원복)
-- 멱등 : NOT EXISTS / 조건부 UPDATE — 재실행 무해
-- =====================================================================================

-- [1] 메뉴 버튼 마스터 — version 시트 EDIT/INSERT/DELETE
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043', 'version', t.BTN_CD, NULL, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'EDIT' AS BTN_CD FROM DUAL UNION ALL
        SELECT 'INSERT'          FROM DUAL UNION ALL
        SELECT 'DELETE'          FROM DUAL) t
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M b
                    WHERE b.MNU_ID = 'DMF0043' AND b.SHT_NM = 'version' AND b.MNU_BTN_CD = t.BTN_CD);

-- [2] 그룹 × 버튼 — ADMIN / DM ADMIN 만 (AS-IS NowGroupID 스위치 1:1)
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT g.GR_ID, 'DMF0043', 'version', b.BTN_CD, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'ADMIN' AS GR_ID FROM DUAL UNION ALL SELECT 'DM ADMIN' FROM DUAL) g
 CROSS JOIN (SELECT 'EDIT' AS BTN_CD FROM DUAL UNION ALL
             SELECT 'INSERT'          FROM DUAL UNION ALL
             SELECT 'DELETE'          FROM DUAL) b
 WHERE EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_M m WHERE m.USER_GR_ID = g.GR_ID)
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M u
                    WHERE u.USER_GR_ID = g.GR_ID AND u.MNU_ID = 'DMF0043'
                      AND u.SHT_NM = 'version' AND u.MNU_BTN_CD = b.BTN_CD);

-- [3] version|SAVE — ADMIN·DM ADMIN 외 그룹 회수 (USE_YN='N')
UPDATE SCM_ADM_USER_GR_MNU_BTN_MPG_M
   SET USE_YN = 'N', LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE MNU_ID = 'DMF0043' AND SHT_NM = 'version' AND MNU_BTN_CD = 'SAVE'
   AND USER_GR_ID NOT IN ('ADMIN', 'DM ADMIN')
   AND USE_YN = 'Y';

COMMIT;
