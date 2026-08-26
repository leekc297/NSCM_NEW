-- =====================================================================================
-- SDM1020 — [09] SCM_MST_SHEET_COLUMNS 표시축 정정 (사용자 확정 계약 반영, 2026-08-19)
--
-- [계약 확정(사용자, 2026-08-19)]
--   · DIVISION 공란(NULL) = division 무관 공통 표시(VISIBLE 'Y' 기준)
--   · DIVISION 값 보유 = 그 division 한정 그대로 유지 — 목업 우선 완화 절대 금지 ("UI CATEGORY SETUP 데이터가 우선")
--
-- [필터 실구현 실측 — PKG_NSCM_UI_COM_MENU.PR_GET_SHEET_COLUMN_LIST (ALL_SOURCE 원문 L164/L214)]
--   AND (P_DIVISION_ID IS NULL OR C.DIVISION_ID IS NULL
--        OR INSTR(','||C.DIVISION_ID||',', ','||P_DIVISION_ID||',') > 0)
--   → "공통 통과" 표현 = 진짜 NULL 뿐. ' '(스페이스 1자)는 공통 아님(INSTR 불일치로 전 division 숨김) —
--     타 화면(DMF0003 등)에 ' ' 센티널 행 실존 실측(SDM1020 은 해당 없음 — 30행 전부 진짜 NULL).
--   비개인화 경로(L199~216): DEFAULT_FLAG AS DISPLAY_FLAG 반환. SHEET_PRSL_YN(SDM1020) 미등재 → 비개인화 확정.
--   FE(ProjectListGrid L80): visible !== false && display !== false 만 컬럼 생성.
--   ∴ 화면 표시 = VISIBLE_FLAG 'Y' ∧ DEFAULT_FLAG 'Y' ∧ division 통과.
--
-- [사전 실측 (2026-08-19) — 지시 전제 정정]
--   ① DIVISION_ID: 30행 전부 NULL — "81계열 등재로 40 조회 시 숨는 상태"라는 전제는 실측 불일치
--      (03_SHEET_COLUMNS.sql 이 DIVISION_ID 컬럼 자체를 미포함 → 설계서 X열 한정값이 통째로 누락된 상태).
--      → 40 에서 division 사유로 숨는 컬럼 = 0. 숨김의 실원인은 ② DEFAULT_FLAG.
--   ② DEFAULT_FLAG: 'Y' 8행뿐(그중 VISIBLE 'Y' 5행) → 초기 표시 5컬럼
--      (DIVISION_ID/DPJT_CODE/DPJT_AUTH_TYPE_NAME/DPJT_DEVELOP_STATUS/DPJT_AUTH_MGMT)
--      = "보이는 컬럼이 몇 개 없음" 신고의 실원인. 설계서 T열(Default)을 그대로 등재한 값이나,
--      T열은 U열(User Selected)과 완전 역전 쌍(설계서 자체 U-07 '?' 미정의 열) — 초기표시 의미가 아님.
--
-- [정정 내용]
--   (A) 설계서 X열(Division) 한정값을 원문 그대로 반영 — 확정 계약 "한정 유지"의 실현.
--       VISIBLE 'N' 행 불변 지시에 따라 DPJT_AUTH_TYPE(VISIBLE N, 설계서 81계열)은 NULL 유지
--       (반환되어도 VISIBLE N 이라 표시 무영향). D1/D2 정오표 개명 매핑:
--       설계서 DPJT_AUTH_REQ_STATUS_NAME/_COLOR_TYPE → DB DPJT_AUTH_REQ_WRITE_NAME/_COLOR_TYPE,
--       설계서 중복 DPJT_AUTH_REQ_READ(링크 행) → DB DPJT_AUTH_REQ_LINK.
--   (B) DEFAULT_FLAG 'Y' 정정 — VISIBLE 'Y' 행 한정 18행. 근거 4축:
--       사용자 확정 계약(공란=공통 "표시", VISIBLE 'Y' 기준) + SP 계약(DEFAULT_FLAG AS DISPLAY_FLAG)
--       + SDM1010 판례(126/126 전행 'Y') + GRID 목업 전컬럼 표시. VISIBLE 'N' 7행 불변.
--       USER_SELECTABLE_FLAG 는 무수정(Column Setup 선택 가능 축 — 표시 판정과 무관).
-- 멱등: 컬럼 한정 UPDATE. 감사컬럼 'admin'.
-- =====================================================================================

-- [A] Division 한정값 반영 (설계서 UI컬럼 시트 X열 원문 — 행별 기재)
-- A-1. 나의 권한(명칭): 설계서 R21 = 81,81_UC,81_HM,81_ST,81_HD,81_HG
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID = '81,81_UC,81_HM,81_ST,81_HD,81_HG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1020' AND SHEET_NAME='Project List' AND COLUMN_NAME='DPJT_AUTH_TYPE_NAME';

-- A-2. 등록 완료일: 설계서 R25 = 40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG (40 포함 — 40 표시 유지)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID = '40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1020' AND SHEET_NAME='Project List' AND COLUMN_NAME='REG_COMP_DATE';

-- A-3. 개발 현황: 설계서 R26 = 82,81,81_UC,81_HM,81_ST,81_HD,81_HG (40 제외)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID = '82,81,81_UC,81_HM,81_ST,81_HD,81_HG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1020' AND SHEET_NAME='Project List' AND COLUMN_NAME='DPJT_DEVELOP_STATUS';

-- A-4. 권한 관리(모달 링크): 설계서 R27 = 81,81_UC,81_HM,81_ST,81_HD,81_HG
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID = '81,81_UC,81_HM,81_ST,81_HD,81_HG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1020' AND SHEET_NAME='Project List' AND COLUMN_NAME='DPJT_AUTH_MGMT';

-- A-5. 권한 요청 계열 6행: 설계서 R28~R33 = 82,81,81_UC,81_HM,81_ST,81_HD,81_HG
--      (D2 개명: _STATUS_NAME/_COLOR → _WRITE_NAME/_WRITE_COLOR_TYPE · D1: 중복 READ 행 → DPJT_AUTH_REQ_LINK)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DIVISION_ID = '82,81,81_UC,81_HM,81_ST,81_HD,81_HG', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1020' AND SHEET_NAME='Project List'
   AND COLUMN_NAME IN ('DPJT_AUTH_REQ_STATUS','DPJT_AUTH_REQ_WRITE_NAME','DPJT_AUTH_REQ_WRITE_COLOR_TYPE',
                       'DPJT_AUTH_REQ_WRITE','DPJT_AUTH_REQ_READ','DPJT_AUTH_REQ_LINK');

-- (설계서 R20 DPJT_AUTH_TYPE 도 81계열 한정이나 VISIBLE 'N' 행 불변 지시로 제외 — NULL 유지, 표시 무영향)

-- [B] DEFAULT_FLAG 'Y' 정정 — VISIBLE 'Y' ∧ DEFAULT 'N' 18행 한정 (VISIBLE 'N' 7행 불변)
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET DEFAULT_FLAG='Y', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SDM1020' AND SHEET_NAME='Project List'
   AND VISIBLE_FLAG='Y' AND DEFAULT_FLAG='N';

COMMIT;

-- [검증] 적용 후:
-- SELECT COLUMN_NAME, DIVISION_ID, VISIBLE_FLAG, DEFAULT_FLAG FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
--  WHERE PROGRAM_ID='SDM1020' ORDER BY SORT_ORDER_NO
-- PR_GET_SHEET_COLUMN_LIST('{user}','SDM1020','Project List','40') 직접 호출 →
--   반환 30-10=20행 · 표시(VISIBLE Y ∧ DISPLAY Y) 14컬럼 기대 (81계열/82 한정 9 가시컬럼은 40 미표시 — 확정 계약).
