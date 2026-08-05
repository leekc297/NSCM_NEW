-- DMF0068 Demand Manager — 신규 메시지 4종 × 3언어 (2026-07-29)
-- 명칭(문구) 기준 전수 대사 결과: 재사용 9종 / 신규 4종 / 제외 1종
--   재사용 : MSG00614(필수입력) MSG00672(저장건수) MSG00611(날짜형식) MSG00096(권한)
--            MSG00108(기간대소) MSG00113(필수컬럼) MSG00260(중복) MSG00283(버전선택) MSG00618(오류)
--   신규   : MSG00699 ~ MSG00702  (현재 MAX = MSG00698)
--   제외   : AS-IS MSG00307 (도달 불가 죽은 코드)
-- 멱등: 동일 (MSG_ID, LANG_CD) 존재 시 INSERT 하지 않음

INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT V.MSG_ID, V.LANG_CD, V.MSG_NM, 'MSG', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT 'MSG00699' AS MSG_ID, 'KO' AS LANG_CD, '0보다 큰 정수를 입력하십시오.' AS MSG_NM FROM DUAL
    UNION ALL SELECT 'MSG00699', 'EN', 'Please enter an integer greater than 0.' FROM DUAL
    UNION ALL SELECT 'MSG00699', 'CN', '请输入大于0的整数.' FROM DUAL
    UNION ALL SELECT 'MSG00700', 'KO', '중첩된 기간이 있습니다.' FROM DUAL
    UNION ALL SELECT 'MSG00700', 'EN', 'The period overlaps with an existing one.' FROM DUAL
    UNION ALL SELECT 'MSG00700', 'CN', '存在重叠的期间.' FROM DUAL
    UNION ALL SELECT 'MSG00701', 'KO', '버전은 1개만 선택해 주세요.' FROM DUAL
    UNION ALL SELECT 'MSG00701', 'EN', 'Please select only one version.' FROM DUAL
    UNION ALL SELECT 'MSG00701', 'CN', '请只选择一个版本.' FROM DUAL
    UNION ALL SELECT 'MSG00702', 'KO', '40번 사업부 전용 화면입니다.' FROM DUAL
    UNION ALL SELECT 'MSG00702', 'EN', 'This screen is available for Division 40 only.' FROM DUAL
    UNION ALL SELECT 'MSG00702', 'CN', '本画面仅适用于40事业部.' FROM DUAL
) V
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M M
    WHERE M.MSG_ID = V.MSG_ID AND M.LANG_CD = V.LANG_CD
);

-- 라벨 — 화면에서 쓰는 라벨은 전부 기존 코드를 명칭 기준으로 찾아 재사용했고,
--        'Edit' 만 원장에 없어 신규 채번한다 (현재 MAX = LBL00782).
--   재사용: LBL00606(Version) LBL00013(Period) LBL00691·LBL00664(Search) LBL00663(Div)
--          LBL00052(Type) LBL00608(Description) LBL00724(View) LBL00665(Loading...)
-- ⚠️ 2026-07-30 정정: MSG_TP_CD 를 'MSG' 로 넣었던 오류 → 'LBL' (자매 LBL00774~782 와 동일).
--    이미 'MSG' 로 적재된 환경은 `03_META/97_LBL00783_TYPE_FIX.sql` 로 정정한다.
INSERT INTO SCM_MGR.SCM_ADM_MSG_M (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT V.MSG_ID, V.LANG_CD, V.MSG_NM, 'LBL', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
FROM (
    SELECT 'LBL00783' AS MSG_ID, 'KO' AS LANG_CD, 'Edit' AS MSG_NM FROM DUAL
    UNION ALL SELECT 'LBL00783', 'EN', 'Edit' FROM DUAL
    UNION ALL SELECT 'LBL00783', 'CN', '编辑' FROM DUAL
) V
WHERE NOT EXISTS (
    SELECT 1 FROM SCM_MGR.SCM_ADM_MSG_M M
    WHERE M.MSG_ID = V.MSG_ID AND M.LANG_CD = V.LANG_CD
);

COMMIT;

-- 검증
SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M
WHERE MSG_ID BETWEEN 'MSG00699' AND 'MSG00702' OR MSG_ID = 'LBL00783'
ORDER BY MSG_ID, LANG_CD;
