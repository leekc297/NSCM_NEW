-- ====================================================================
-- DMF0082 이관 — 공용 라벨 LBL00764 / LBL00765 등록 (2026-08-09)
--
-- [왜 필요한가]
--   ForecastPrice.tsx:530-531 이 ColumnSetting 모달의 좌/우 제목으로 참조:
--       leftTitle={t('LBL00764', 'Invisible')}
--       rightTitle={t('LBL00765', 'Visible')}
--   그런데 두 코드는 **사내 DB·locales 양쪽 모두 부재**(2026-08-09 실측) →
--   t() 의 2번째 인자(영문 폴백)로만 표시된다.
--
-- [영향도 — 화면 표시 결함 아님]
--   본 프로젝트는 **KO 라벨도 영문**이다(LBL00766 KO='Save Price Period' 실측, i18n KO=EN 통일 룰).
--   따라서 폴백 'Invisible'/'Visible' 과 등록 후 표시가 **동일**하다 → 사용자 눈에 보이는 차이 없음.
--   실제 결손은 **admin 라벨 관리 UI 에서 이 두 라벨을 바꿀 수 없다**는 점(운영 결정 미반영 경로).
--   ⇒ 본 파일은 **선택 적용**. 미적용해도 DMF0082 동작·표시에 영향 없음.
--
-- [채번 근거 — 임의 채번 아님]
--   LBL00760~763 / LBL00766~770 은 모두 등재돼 있고 **764·765 만 비어 있다**(연속 블록의 공백).
--   FE 는 이미 이 번호를 쓰고 있으므로 신규 채번이 아니라 **누락된 등록을 채우는 것**이다.
--   동일 의미의 기존 라벨 재사용 후보 없음(MSG_NM IN ('Visible','Invisible',…) 조회 0행).
--
-- [영향 범위 — DMF0082 전용 아님]
--   동일 코드를 8개 이상 화면이 공유한다(실측):
--     demand : forecast-price(DMF0082) / mkt-fcst / sales-plan / business-plan
--              / sales-reports / etc-sales-reports
--     supply : production-plan-line
--   → 등록되면 해당 화면 전체가 함께 정상화된다. INSERT-only 이므로 회귀 위험 없음.
--
-- [형상 근거] LBL00766 실측 1:1 — LANG_CD 3종(KO/EN/CN) · MSG_NM 동일 영문 ·
--   MSG_DESC NULL · MSG_TP_CD='LBL' · USE_YN='Y' · 감사컬럼 'admin'(hook: 메타 감사컬럼 admin 만)
--
-- ⚠️ 멱등 — 이미 있으면 건너뛴다. DELETE / UPDATE 없음.
-- ⚠️ QA·DEV 2곳 동시 적용 의무
-- ====================================================================

INSERT INTO SCM_MGR.SCM_ADM_MSG_M
    (MSG_ID, LANG_CD, MSG_NM, MSG_DESC, MSG_TP_CD, USE_YN,
     CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT s.MSG_ID, s.LANG_CD, s.MSG_NM, NULL, 'LBL', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM (
        SELECT 'LBL00764' MSG_ID, 'KO' LANG_CD, 'Invisible' MSG_NM FROM DUAL UNION ALL
        SELECT 'LBL00764', 'EN', 'Invisible' FROM DUAL UNION ALL
        SELECT 'LBL00764', 'CN', 'Invisible' FROM DUAL UNION ALL
        SELECT 'LBL00765', 'KO', 'Visible'   FROM DUAL UNION ALL
        SELECT 'LBL00765', 'EN', 'Visible'   FROM DUAL UNION ALL
        SELECT 'LBL00765', 'CN', 'Visible'   FROM DUAL
       ) s
 WHERE NOT EXISTS (
        SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M m
         WHERE m.MSG_ID = s.MSG_ID AND m.LANG_CD = s.LANG_CD
       );

COMMIT;

-- [검증] 기대 6행 (LBL00764 × 3 + LBL00765 × 3)
SELECT MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN
  FROM SCM_MGR.SCM_ADM_MSG_M
 WHERE MSG_ID IN ('LBL00764','LBL00765')
 ORDER BY MSG_ID, LANG_CD;
