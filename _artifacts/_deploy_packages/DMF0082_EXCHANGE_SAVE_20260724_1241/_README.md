# DMF0082_EXCHANGE_SAVE_20260724_1241 — 환율 Modal ADMIN 편집/저장 클라우드 이관

> 대상: DMF0082(Fcst&Price MGMT) Exchange Rate 모달의 **ADMIN 편집/Insert/저장** 기능
> (AS-IS `DMF0000_ExchangeRatePopup` Edit/Insert/Save 1:1 — Delete 기능 없음(사용자 확정)).
> 사내(OCGSCMD_P01)는 2026-07-24 적용 완료 — 본 패키지는 **클라우드 동기화분**.

## 적용 순서 (순서 엄수)

| Step | 파일 | 내용 | 비고 |
|---:|---|---|---|
| 0 | `90_DIAGNOSE/00_PREREQ_CHECK.sql` | 선행 확인 — **PKG_DMF0020 VALID 필수** + 공유 인프라 8종 + futurePriceInfo SEARCH/IF 기배선 + CurrencyList 콤보 | 미충족 시 중단 (하단 PREREQ 참조) |
| 1 | `sp/00_GTT_TABLES_DDL.sql` | GT_D000_RESULTS(GTT) + DM_MST_EXCHANGE_RATE/_H + SEQ1 | 멱등(-955 skip). PKG 이전 필수 (컴파일 의존) |
| 2 | `sp/01_PKG_DMF0000_SPEC.sql` | PKG_DMF0000 SPEC | 사내 live 최신 덤프 (2026-07-24) |
| 3 | `sp/02_PKG_DMF0000_BODY.sql` | PKG_DMF0000 BODY (5 proc — SAVE 포함) | 본문 무수정 원칙 — 사내 정본 그대로 |
| 4 | `sp/03_GRANT_SYNONYM.sql` | SCMD_APP EXECUTE + SYNONYM | 멱등 |
| 5 | `sql/01_wiring_meta_cloud.sql` | API_M / PROC_M(DELETE→INSERT) / BTN×2테이블 / MSG00689 | 멱등 + 기존 row UPDATE 보정 동반 |
| 6 | `90_DIAGNOSE/90_VERIFY.sql` | 적용 후 검증 (기대값 주석) | 전 항목 기대값 일치 확인 |
| 7 | `fe/` | FE 2파일 스냅샷 | 아래 FE 절 참조 (locale json 은 이관 제외 — 사용자 확정) |

## PREREQ (본 패키지 미포함 — 선행 필수)

| 오브젝트 | 사유 | 미존재 시 |
|---|---|---|
| **PKG_DMF0020** (BODY VALID) | PKG_DMF0000 SAVE 가 `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` 호출 (저장 후 Sales Price 재계산) — 미존재 시 BODY 컴파일 실패(PLS-00201) | DMF0020 계열 기이관 패키지 선적용. 본 패키지에 동봉하지 않은 사유 = PKG_DMF0020 BODY 최신본의 단일 출처는 DMF0020 패키지 (완전성 hook §4.6 #4 — 복수 패키지 동일 PKG 갱신 충돌 방지) |
| PR_SCM_SYS_LOG_BATCH / SCM_MST_DIVISION / SCM_ADM_USER_MNU_EDIT_AUTH_V / SCM_ADM_LOOKUP_MASTER_DETAIL / SCM_SYS_CALENDAR_M / SCM_MST_SHEET_COLUMNS / SCM_MST_TITLESET_USER / SCM_SYS_LOG_BATCH | 공유 인프라 (전 화면 공통 — PKG_DMF0000 BODY 5 proc 참조 전수) | 공통 인프라 패키지 선적용 |
| `DMF0082_futurePriceInfo_SEARCH` / `_IF` 메타 | 모달 조회/BPS I/F — 이전 DMF0082 패키지 배선분 | `DMF0082_20260722_1050` 등 선적용 |

## 핵심 설계 (검수 포인트)

1. **권한** — AS-IS `NowGroupID IN ('ADMIN','DM ADMIN')` × Division 40 스위치를
   `futurePriceInfo` 시트 **EDIT/INSERT/SAVE 버튼 × ADMIN·DM ADMIN 그룹 매핑**으로 구현
   ('IF' 버튼 선례 1:1). 서버측은 `/DMF0082/futurePriceInfo/SAVE/call-proc` 호출 시
   `CustomAuthorizationManager` 가 시트단위 `checkMenuBtnAuth` 로 강제.
2. **⚠ PROC_M 감사 2키 = `createdByBulk` / `lastUpdatedByBulk` (개명 금지)** —
   BE `NDaoInterface` 가 `createdBy`/`lastUpdatedBy` 키를 세션 단일값으로 무조건 덮어쓰는데,
   이 SP 는 '^' N-토큰 병렬 파싱이라 2행부터 감사값 NULL → ORA-01400.
   별도 키명으로 FE 가 사용자ID를 N-반복 전달 (AS-IS FE 반복 append 1:1).
3. **MSG00689** = AS-IS MSG00456 'Sales Price Recalculation is complete.' 원문 신규 채번
   (사내 max MSG00688+1). 클라우드에 동일 ID 다른 문구 선점 시 UPDATE 보정 포함.
4. EXCHANGE_PRICE `NUMBER(20,10)` = 사내 정본 그대로 (환율 값 도메인 — 수량/금액 집계
   계열 아님, (30,10) 교정 대상 아님. 완전성 hook §1.1 grep 수행 완료).

## FE (fe/ — repo 상대경로 동봉)

| 파일 | 내용 |
|---|---|
| `fe/nscm-fe/features/demand/src/pages/forecast-price/components/modals/ExchangeRateModal.tsx` | 편집/Insert/Save 구현 (wrapper 표준 `_inputEditType`×`EDIT_FLAG` 로 노란색+편집 판정 / Currency·Unit=Insert 행 전용 'IM'+CurrencyList dataMap / 당월 이후만 OPTIONAL / '^' bulk 저장) |
| `fe/nscm-fe/features/demand/src/pages/forecast-price/forecast-price.constants.ts` | MSG.PRICE_RECALC_DONE(MSG00689)/SAVE_ERROR(MSG00618) 추가 |

⚠ **다국어 locale json (`public/locales/{KO,EN,CN}.json`) = 이관 대상 제외 (사용자 확정 2026-07-24)**.
FE `t('MSG00689', fallback)` 은 locale 키 부재 시 코드 내 fallback 문구
('Sales Price Recalculation is complete.')로 표시되므로 기능 동작에는 지장 없음.
클라우드측 locale 반영은 별도 절차로 진행.

⚠ **최신 스냅샷 고지 (완전성 hook §4.6 #1)**: 위 2파일은 `DMF0082_20260722_1050` 패키지에도
구판 스냅샷이 포함되어 있음 — **본 패키지 판이 최신**(이전 변경 + 2026-07-24 변경 포함).
두 패키지를 함께 적용하는 경우 FE 는 반드시 본 패키지 판을 나중에(최종으로) 반영.

## 미포함 / 차기 (완전성 hook §4.5 #1)

| 항목 | 사유 |
|---|---|
| PKG_DMF0020 SPEC/BODY | PREREQ 표 참조 — DMF0020 패키지가 단일 출처 |
| `PR_SCM_MST_EXCHANGE_RATE_UI` (BPS I/F 래퍼) | 기존 DMF0082 패키지에서 기이관 — 본 건 무변경 |
| ExchangeRateModal.module.scss | 본 건 무변경 — `DMF0082_20260722_1050` 판 그대로 유효 |
| `public/locales/{KO,EN,CN}.json` (MSG00689 키) | **이관 대상 제외 — 사용자 확정 (2026-07-24)**. FE 는 fallback 문구로 동작 |

## 검증 완료 (사내 기준)

- PKG_DMF0000 VALID (SPEC/BODY) + SAVE SP 시그니처 = PROC_M 9행 위치·이름 일치 (실측)
- FE: tsc 0 오류 / eslint 0 오류 / regression-impact Hard Boundary 0 (forecast-price 단일)
- 미실측: 클라우드 실데이터 저장 E2E (적용 후 90_VERIFY + 화면 저장 1건 확인 권장 —
  저장 성공 시 SP 내부 Sales Price 재계산까지 실행됨에 유의)
