-- =============================================================================
-- 01_DMF0003_DAYRANGE_SSPCOMPARE_WIRING.sql — DMF0003 화면 오픈 시 "권한없음" 보완
-- 원인(BE 로그 실측 2026-07-29): checkMenuBtnAuth(shtNm='dayRange', SEARCH) HAS_AUTH_YN='N'
--   — FE SHEETS.DAY_RANGE 는 화면 오픈 즉시 조회하나 BTN_MPG/API_M/USER_GR 3테이블 모두 미배선.
--   sspCompare 는 API_M 만 있고 BTN 2테이블 누락(팝업 오픈 시 동일 증상 예방 차원 동시 등록).
--   measureCount 는 FE 상수만 존재·미호출 → 등록 보류.
-- 패턴 근거: 형제 4화면(DMF0014/0021/0042/0048) dayRange SEARCH → PR_GET_DAY_RANGE (VALID, PROC_M 5행).
-- DDL cross-check: API_M(API_MSG_ID NOT NULL — MSG_M 행은 형제도 미등록=선택) /
--   BTN·USER_GR(CREATED_BY/LAST_UPDATED_BY NOT NULL, DEFAULT 없음 → 명시). 감사컬럼 'admin'.
-- 멱등: 전 문장 NOT EXISTS. 실행: python _artifacts/_diagnostics/ora.py exec <본파일>
-- =============================================================================

-- [1] API_M — DMF0003_dayRange_SEARCH → PR_GET_DAY_RANGE (형제 DMF0021 패턴)
INSERT INTO SCM_ADM_API_M (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003_dayRange_SEARCH', 'PROC_SELECT', 'MSG_API_DMF0003_dayRange_SEARCH',
       'DMF0003 기본 조회기간 (당월~+6개월, DMF0021 선례)', 'PR_GET_DAY_RANGE', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_API_M WHERE API_ID = 'DMF0003_dayRange_SEARCH');

-- [2] BTN_MPG — dayRange SEARCH
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003', 'dayRange', 'SEARCH', 'DMF0003_dayRange_SEARCH', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M
                    WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'dayRange' AND MNU_BTN_CD = 'SEARCH');

-- [3] BTN_MPG — sspCompare SEARCH (API_M 기존재: DMF0003_sspCompare_SEARCH)
INSERT INTO SCM_ADM_MNU_BTN_MPG_M (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
                                   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0003', 'sspCompare', 'SEARCH', 'DMF0003_sspCompare_SEARCH', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_ADM_MNU_BTN_MPG_M
                    WHERE MNU_ID = 'DMF0003' AND SHT_NM = 'sspCompare' AND MNU_BTN_CD = 'SEARCH');

-- [4] USER_GR 버튼권한 — DMF0003 spreadTitle SEARCH 보유 그룹 전체를 dayRange/sspCompare 로 미러링
INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, 'DMF0003', 'dayRange', 'SEARCH', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G
 WHERE G.MNU_ID = 'DMF0003' AND G.SHT_NM = 'spreadTitle' AND G.MNU_BTN_CD = 'SEARCH' AND G.USE_YN = 'Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M X
                    WHERE X.USER_GR_ID = G.USER_GR_ID AND X.MNU_ID = 'DMF0003'
                      AND X.SHT_NM = 'dayRange' AND X.MNU_BTN_CD = 'SEARCH');

INSERT INTO SCM_ADM_USER_GR_MNU_BTN_MPG_M (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
                                           CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT G.USER_GR_ID, 'DMF0003', 'sspCompare', 'SEARCH', 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M G
 WHERE G.MNU_ID = 'DMF0003' AND G.SHT_NM = 'spreadTitle' AND G.MNU_BTN_CD = 'SEARCH' AND G.USE_YN = 'Y'
   AND NOT EXISTS (SELECT 1 FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M X
                    WHERE X.USER_GR_ID = G.USER_GR_ID AND X.MNU_ID = 'DMF0003'
                      AND X.SHT_NM = 'sspCompare' AND X.MNU_BTN_CD = 'SEARCH');

COMMIT;
