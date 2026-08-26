-- =====================================================================================
-- SDM1020 — [05] LOOKUP 통합 (사내 07_LOOKUP_REG_STATUS_CAT + 08_LOOKUP_REG_STATUS_FULL 원문 통합)
-- 사내 원장 실측(2026-08-19 적용 후 최종): SPMS_DPJT_REG_STATUS VALID 'Y' 10행 = 확정 9항목
--   (작성중 = DRAFT/WRITING 2코드) + VALID 'N' 잔재 3행(REQUEST/CHG_DRAFT/CHG_REQUEST 불변) /
--   SPMS_DPJT_REG_CAT = NEW(1)/MOD(2) VALID 'Y'.
-- 기존 코드 무수정(DISPLAY_SEQ 재부여 UPDATE 만 — PK 컬럼 불변) · 신규 4코드
--   (CHG_REG/MODIFYING/CHG_COMPLETE/CHG_REJECT) + 결측 시드 2행(REQ_MOD/MOD). 멱등(NOT EXISTS/코드 한정 UPDATE).
-- 선행: SPMS_DPJT_REG_STATUS·SPMS_DPJT_REG_CAT MASTER 행 + 기본 상세(DRAFT~REJECT·NEW)는
--   SDM1010_CLOUD_20260813/sql/05_LOOKUP_COMBO.sql 기적용 전제 — 00_CLOUD_PRECHECK [P5] 확인.
-- =====================================================================================

-- ───────────────── [5-A] 결측 시드 2행 (사내 07 원문) ─────────────────
-- 07_LOOKUP_REG_STATUS_CAT.sql — SDM1020 BTN_REQ 필수 lookup 결측 2행 시드 (2026-08-19)
-- 근거(권위소스): PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG 의 엄격 SELECT INTO
--   ① SPMS_DPJT_REG_STATUS SEGMENT1='REQ_MOD' AND SEGMENT2='변경요청'
--   ② SPMS_DPJT_REG_CAT    SEGMENT1='MOD'     AND SEGMENT2='수정'
--   미존재 시 'M' 요청이 NO_DATA_FOUND(-20001) 로 전면 차단 (2026-08-19 사내 실측).
--   AS-IS 잔재 CHG_REQUEST('변경요청', VALID_YN='N') 는 TO-BE SP 미사용 — 불변.
--   REQ_MOD 는 GET RGS INNER JOIN(VALID_YN='Y' 필터) 통과 필요 → VALID_YN='Y'.
--   MODIFYING 은 설계상 lookup 비활성(미등재) 유지 — 시드 금지.
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_REG_STATUS', 'REQ_MOD', '변경요청', '-', '-', '-', 61, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND X.SEGMENT1='REQ_MOD');

INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_REG_CAT', 'MOD', '수정', '-', '-', '-', 2, 'Y',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE='SPMS_DPJT_REG_CAT' AND X.SEGMENT1='MOD');

-- ───────────────── [5-B] 등록상태 9항목 재구성 (사내 08 원문) ─────────────────
-- =====================================================================================
-- SDM1020 — [08] SPMS_DPJT_REG_STATUS 등록상태 lookup 상세 재구성 (사용자 확정 9항목, 2026-08-19)
-- 확정 순서: 작성중 / 승인대기 / 등록완료 / 반려 / 변경등록 / 변경중 / 변경요청 / 등록완료(변경 후) / 등록반려
--
-- [0] 적용 전 기존 상세 전행 실측 덤프 (2026-08-19 사내 OCGSCMD_P01 — 보존 기록)
--   LOOKUP_TYPE=SPMS_DPJT_REG_STATUS | SEG1        | SEG2     | SEG3(COLOR) | VALID | SEQ | DESCRIPTION
--   ------------------------------------------------------------------------------------------------
--                                    | WRITING     | 작성중    | Gray  | Y | 2  | (없음)
--                                    | WAITING     | 승인대기  | Amber | Y | 3  | (없음)
--                                    | DRAFT       | 작성중    | Gray  | Y | 10 | 작성중
--                                    | REQUEST     | 승인대기  | -     | N | 20 | 등록요청 후 승인대기
--                                    | COMPLETE    | 등록완료  | Green | Y | 30 | 등록완료
--                                    | REJECT      | 반려      | Red   | Y | 40 | 반려
--                                    | CHG_DRAFT   | 변경등록  | -     | N | 50 | 변경등록 (후속 설계 — 정오표 #12)
--                                    | CHG_REQUEST | 변경요청  | -     | N | 60 | 변경요청 (후속 설계 — 정오표 #12)
--                                    | REQ_MOD     | 변경요청  | -     | Y | 61 | (없음)
--   * PK 실측: PK_SCM_ADM_LOOKUP_MASTER_DETAIL = (LOOKUP_TYPE, SEGMENT1~5). FK 자식 0건 실측.
--   * MASTER 행: SPMS_DPJT_REG_STATUS VALID_YN='Y' 실존.
--
-- [1] SP 계약 코드 실측 (PKG_SDM1010/PKG_SDM1020 ALL_SOURCE 원문 — 주석 제거(strip_code_comments) 후 LIVE 코드만 집계, hook #138)
--   PKG_SDM1010: INSERT 초기상태 = 'DRAFT'(엄격 SELECT INTO SEG1='DRAFT') /
--                등록요청: IN ('WRITING','DRAFT') → 'WAITING' / 요청취소: 'WAITING' → 'WRITING'
--   PKG_SDM1020: 변경요청(BTN_REQ_PJT_REG): 엄격 SELECT INTO SEG1='REQ_MOD' AND SEG2='변경요청'
--                (⛔ SEG2 까지 계약 — REQ_MOD 행의 SEGMENT2/명칭 변경 절대 금지)
--                + 원본행 전이 UPDATE DPJT_REG_STATUS='MODIFYING' (L610 리터럴 — 코드 고정)
--   COMPLETE/REJECT 를 DPJT_REG_STATUS 에 대입하는 SP 문은 전무(승인 흐름 미구현) — ALL_SOURCE 전 OWNER=SCM_MGR
--   스윕 실측: DPJT_REG_STATUS 참조 객체 = PKG_SDM1010/PKG_SDM1020 뿐.
--   원장 실측: SPMS_PROJECT_MST 현재 상태 분포 = COMPLETE 3 / DRAFT 1 / REJECT 1 / WAITING 1 (전부 lookup 보유).
--
-- [2] 판정 (근거 명기 — 근거 없는 단정 금지 지시 준수)
--   ① 작성중 = 기존 2코드(DRAFT·WRITING) 공존 유지. 둘 다 SP 계약 코드(초기=DRAFT, 요청취소 복귀=WRITING)라
--      개명·삭제 불가. GET 이 INNER JOIN VALID='Y' 이므로 둘 다 VALID 'Y' 필수. SEQ 는 초기상태 DRAFT=10, WRITING=11 연번.
--   ② '등록완료(변경 후)' = 별코드 신설(CHG_COMPLETE). 근거:
--      - GRID 시트 R39(등록완료)와 R44(등록완료 — "수정후 등록 완료")가 별도 상태 정의 행(설계서 실측).
--      - 사용자 확정 목록(2026-08-19)이 '등록완료'와 '등록완료(변경 후)'를 별개 항목·별개 순서로 명시
--        → 한 코드의 SEGMENT2(명칭)는 1개뿐이므로 COMPLETE 재사용으로는 두 명칭 표현 불가.
--      - GET RGS 조인이 SEGMENT1 단위 매칭 → VALID 'Y' 에서 SEGMENT1 중복 시 프로젝트 행 복제(fan-out)
--        → COMPLETE 별행 추가 방식 불가. ∴ 별코드가 유일해.
--      - SP 원문은 어느 쪽도 강제하지 않음(승인 흐름 미구현 — [1] 실측).
--   ③ 변경등록/등록반려 = 신규 코드(사용자 지시 예시 명시). 명명 관례 = 변경 계열 접두 CHG_
--      (기존 CHG_DRAFT/CHG_REQUEST 관례) → CHG_REG(변경등록) / CHG_REJECT(등록반려).
--      GRID 시트 근거: R41 변경등록="수정등록 승인 후 원래 프로젝트 상태" / R45 "수정후 등록 요청 반려"(명칭 ?
--      → 사용자 확정 '등록반려', 구 정오표 U-04 해소).
--   ④ 변경중 = MODIFYING — SP 리터럴 고정(PKG_SDM1020 L610 실측)이라 코드 선택 여지 없음. GET INNER JOIN
--      VALID='Y' 특성상 미등재 시 변경중 프로젝트가 화면에서 소실 → VALID 'Y' 등재 필수.
--      (구 07 스크립트의 "MODIFYING 미등재 유지" 판단은 본 사용자 확정(2026-08-19)으로 폐기.)
--   ⑤ SEGMENT3(COLOR_TYPE): 기존 관례 실측 = 기본 4상태만 유색(Gray/Amber/Green/Red), 변경 계열은
--      CHG_REQUEST·CHG_DRAFT·REQ_MOD 모두 '-'(무색) 관례 → 신규 변경 계열 4행도 '-' 지정, REQ_MOD '-' 유지.
--      (SEGMENT3 는 PK 구성 컬럼 — 기존 행 PK 컬럼 무수정 원칙에도 부합.)
--   ⑥ AS-IS/후속설계 잔재 REQUEST·CHG_DRAFT·CHG_REQUEST(VALID 'N') = 불변(사용자 지시).
--      명칭 중복(CHG_DRAFT '변경등록' vs 신규 CHG_REG '변경등록')은 VALID 'N' 필터로 화면 무영향.
--      DISPLAY_SEQ 50/60 이 잔재 N 행과 겹치나 VALID 'N' 행은 표시 경로 전무 — 무해.
--
-- [3] 최종 구성 (VALID 'Y' 9행 · DISPLAY_SEQ = 확정 순서)
--   10 DRAFT 작성중(Gray) · 11 WRITING 작성중(Gray) · 20 WAITING 승인대기(Amber) · 30 COMPLETE 등록완료(Green)
--   40 REJECT 반려(Red) · 50 CHG_REG 변경등록(-) [신규] · 60 MODIFYING 변경중(-) [신규]
--   70 REQ_MOD 변경요청(-) · 80 CHG_COMPLETE 등록완료(변경 후)(-) [신규] · 90 CHG_REJECT 등록반려(-) [신규]
-- 멱등: UPDATE 는 코드 한정, INSERT 는 NOT EXISTS(SEGMENT1 한정) 가드. 감사컬럼 'admin'.
-- =====================================================================================

-- [A] 기존 행 DISPLAY_SEQ 정렬 재부여 (코드/명칭/색 무수정 — PK 컬럼 불변)
UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
   SET DISPLAY_SEQ = 11, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS' AND SEGMENT1 = 'WRITING' AND VALID_YN = 'Y';

UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
   SET DISPLAY_SEQ = 20, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS' AND SEGMENT1 = 'WAITING' AND VALID_YN = 'Y';

-- DRAFT=10 / COMPLETE=30 / REJECT=40 은 현행 유지 (무수정)

UPDATE SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
   SET DISPLAY_SEQ = 70, LAST_UPDATED_BY = 'admin', LAST_UPDATE_DATE = SYSDATE
 WHERE LOOKUP_TYPE = 'SPMS_DPJT_REG_STATUS' AND SEGMENT1 = 'REQ_MOD' AND VALID_YN = 'Y';

-- [B] 부족분 신규 INSERT 4행 (판정 근거 = 상단 [2])
INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN, DESCRIPTION,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_REG_STATUS', 'CHG_REG', '변경등록', '-', '-', '-', 50, 'Y',
       '수정등록 승인 후 원래 프로젝트 상태 (설계서 GRID R41 · 사용자 확정 2026-08-19 · CHG_ 관례 신규)',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND X.SEGMENT1='CHG_REG');

INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN, DESCRIPTION,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_REG_STATUS', 'MODIFYING', '변경중', '-', '-', '-', 60, 'Y',
       '변경(수정) 진행 중 — PKG_SDM1020.P_SDM1020_BTN_REQ_PJT_REG 전이 리터럴(원문 L610) 고정 코드. GET INNER JOIN VALID=Y 소실 방지 필수 (설계서 GRID R42 · 사용자 확정 2026-08-19)',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND X.SEGMENT1='MODIFYING');

INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN, DESCRIPTION,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_REG_STATUS', 'CHG_COMPLETE', '등록완료(변경 후)', '-', '-', '-', 80, 'Y',
       '수정후 등록 완료 (설계서 GRID R44). COMPLETE 재사용 아님 — 판정 근거: 확정 목록이 등록완료와 별개 항목 명시 + GET RGS 조인 SEGMENT1 매칭이라 동일코드 별행 시 fan-out + SP 는 미구현으로 무강제 (2026-08-19)',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND X.SEGMENT1='CHG_COMPLETE');

INSERT INTO SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
  (LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN, DESCRIPTION,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'SPMS_DPJT_REG_STATUS', 'CHG_REJECT', '등록반려', '-', '-', '-', 90, 'Y',
       '수정후 등록 요청 반려 (설계서 GRID R45 명칭 ? → 사용자 확정 2026-08-19 등록반려 · 구 정오표 U-04 해소 · CHG_ 관례 신규)',
       'admin', SYSDATE, 'admin', SYSDATE FROM DUAL
 WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL X
                    WHERE X.LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND X.SEGMENT1='CHG_REJECT');

COMMIT;

-- [C] 검증 (적용 후 실행 — SP 계약 코드 전부 VALID 'Y' 존재해야 0행 = PASS)
-- SELECT C FROM (
--   SELECT COLUMN_VALUE C FROM TABLE(SYS.ODCIVARCHAR2LIST('DRAFT','WRITING','WAITING','COMPLETE','REJECT','REQ_MOD','MODIFYING'))
--   MINUS
--   SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
--    WHERE LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND VALID_YN='Y')
-- SELECT DPJT_REG_STATUS FROM SCM_MGR.SPMS_PROJECT_MST
--  MINUS SELECT SEGMENT1 FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
--        WHERE LOOKUP_TYPE='SPMS_DPJT_REG_STATUS' AND VALID_YN='Y';  -- 원장 소실 0행 = PASS

