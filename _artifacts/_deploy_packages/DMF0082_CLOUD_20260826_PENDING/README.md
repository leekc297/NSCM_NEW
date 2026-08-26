# DMF0082 클라우드 이관 — 2026-08-25 수정분 중 미이관 전량 (적용대상본만)

> 취합일 2026-08-26. **2026-08-25 수정분은 전부 클라우드 미이관** — 본 폴더가 그 전량이다.
> 사용자 지시: 적용대상본만 취합 (수정 아닌 부분 제외 — 백업·프리뷰·도구 미동봉).
> 원천 = 사내 라이브 신선 덤프/실측 (2026-08-26 취합 시점, 컴파일 VALID·마커 16종 실측 일치).

## A_DB — 적용 순서 `21 → 23 → 24 → 02 → 90`

| # | 파일 | 방식 | 내용 |
|---|---|---|---|
| 21 | `21_LOOKUP_GET_ADMIN_GROUP_MEASURE_81.sql` | 멱등 MERGE 72행 | 81 계열 권한별 메저 (MKT_FCST 30 무속성 / LOC 24 / SCM_FCST 18 division별 TUE 창) |
| 23 | `23_LOOKUP_LOC_81.sql` | 멱등 MERGE 6행 | `DM_UI_EDITABLE_MEASURE` (DMF0082/LOC) 81계열 — Excel Form 대상 메저 축 (없으면 폼 0행) |
| 24 | `24_EXCEL_HEADER_PRICECOL.sql` | **멱등 MERGE 1행** | 업로드 메타(`SCM_ADM_EXCEL_COLUMNS`) — 클라우드 행 부재 시 INSERT(전 컬럼·validProc 배선 포함)/존재 시 UPDATE. 슬롯2 Project Code / 슬롯8 Plant Site. **⚠ 02 와 같은 배포창 연속 적용 필수** *(2026-08-26 재작성 — 구 UPDATE 단문은 클라우드 행 부재로 0건 무효 실측)* |
| 25 | `25_CMBO_MEASURE_INDENT.sql` | 멱등 UPDATE | 공유 콤보 `Measure` — CUST 종속 데이터 기반 1단 항목 게이트에 DMF0082 추가 (계층 들여쓰기 표기 정본. 타 17개 소비 화면 무영향) |
| 26 | `26_LOOKUP_INSMEAS81.sql` | 멱등 MERGE 8행 | `DM_UI_EDITABLE_MEASURE` 81 계열 Insert 후보 — 전 6 division MKT_FCST(Y) + 81/81_UC VMI_In_Req(N). 81 Insert 콤보 LOC-만 결손 정정. AS_In_Req/TMM_FCST 미등재(저장 SP 81 게이트 밖 — silent no-op 방지) |
| 02 | `02_PKG_DMF0082_BODY.sql` | 전체 교체 | BODY (라이브 신선 덤프 2026-08-26 v2) — 마커 16종 (08-25 15종 + 08-26 CUSTSUBR) · **v4: +CUSTSUBORPH(모행 없는 종속 메저 고아 제외 — 클라우드 발현 정정)** |
| 90 | `90_VERIFY.sql` | 검증 | 마커 16종 카운트·컴파일·룩업 카운트·40 축 불변(15행)·SCM_FCST 창 6종 |

**BODY 마커 16종** (원장 REQ:CHAT-20260825-1~14 전수 사상):
`SCPPLOC 1 / AFSBLANK 2 / AFSNVL 1 / 81AUTH 3 / CUSTSUB 1 / CURRNORM 2 / XLSMASTER 3 / XLSBATCH 1 / XLSBATCH2 1 / XLSPRJ 1 / XLSPRICECOL 3 / XLSPRICECOL2 11 / SAVEPOPCLOB 1 / SAVEPOPCLOB2 3 / SAVEPOPPERF 1 / CUSTSUBR(08-26) 1`

- SCP Planner LOC 편집 정정 / AS_FROM_SITE·CURRENCY 정규화(행 분리 해소) / 81 권한체계(룩업+그룹잠금)
- CUST FCST 종속 메저 데이터 기반 산출
- Excel Form: 단가 테이블 컬럼 구성(원장 키·PLANT 포함)·일괄입력 추출 기준·성능(뷰 선실현)
- Excel Upload: 검증 SP 슬롯 2·8 재편 + T_MAIN Plant 직송('Plant Site 축 미결' 해소)
- Price Batch Input: 동적 SQL CLOB 2건(ORA-06502/01489, 데이터 확대 유발) + CC KEEP LAST 튜닝(67s→9.5s)
- **[08-26 추가] CUST 종속 메저(└ EDI/└ Commercial_Agreement) 실적 축** — 실적 원장 `DM_PLN_MKT_FCST_RESULT`(AS-IS 동일) arm 신설. 과거 구간에만 값이 있는 키의 종속 행 누락(클라우드 파일 대사 14행) 정정 (`E20260826-CUSTSUBR`)

## B_FE — 수정 6본 (실제 저장소 디렉토리 구조 그대로 — `B_FE/` 하위를 `nscm-fe/` 루트에 그대로 덮어쓰기)

| 파일 (B_FE/features/demand/src/pages/forecast-price/) | 내용 |
|---|---|
| `components/ForecastPriceGrid.tsx` | 그리드 음수 = 빨간 글자 (REQ-7) + **[08-26] CUST 종속 메저 단계별 들여쓰기** — MEASURE 셀 white-space:pre 보존 (DMF0003 MktFcstGrid 파리티, 공백 collapse 로 단계가 안 보이던 것 정정). ⚠ 전제: 공통소스 `gridNegativeText.ts` 포함 세대(common/main d2d7c282, 2026-08-24) — 구세대면 TS2305 |
| `components/modals/ForecastTemplateModal.tsx` | Excel Form 모달 — MAIN 미조회 독립 조회·Search 명시 게이트·빈 정보성 컬럼 숨김 |
| `utils/forecast-price.excelForm.ts` | 양식 컬럼 = 단가 테이블 고정 계약(토큰 10 + Project/Owner + 동적 주차)·`pruneEmptyInfoColumns` |
| `ForecastPrice.tsx` | 모달 배선(staticColumns 폐지)·SiteEndCustomerMap 콤보 q() 인용 |
| `components/ForecastPriceForm.tsx` | **[08-26] 조회조건 Reset 버튼** — 공용 SearchArea `onResetCondition` 첫 적용 (AS-IS F10 파리티: MSG00009 confirm → 전체 초기화 → MSG00011. 기존 메시지 재사용 — 메타 이관물 없음) |
| `useForecastPriceStore.ts` | **[08-26] `resetSearchParams` 액션** — 조회조건 전체 초기화 (persisted 저장분 포함) |

type-check @demand 강제 재실행 PASS (2026-08-25).

## ⚠ 주의

1. **02 BODY 는 전체 교체** — 클라우드가 08-23 FULL 미적용(구세대)이면 그 누적 delta 까지 함께 반영된다. 세대 판정 = FULL 패키지 `00_CLOUD_PRECHECK.sql` C1. GTT/DDL 미비 시 FULL 의 `00_GTT_DDL.sql`/`00B` 선행(컴파일 실패 방지).
2. **24 와 02 는 원자적 세트** — 한쪽만 적용하면 업로드 슬롯 계약(ATTRIBUTE2/8 의미)이 어긋난다. 같은 배포창에서 연속 적용.
3. **구양식 Excel 파일**(End Customer/Cell Prod Site 열)은 적용 후 'Invalid Project Code/Plant Site' 로 명시 거부 — 신양식 재다운로드가 정본 (2세대 호환 없음).
4. 사내 대비 검증 기준(취합 시점 실측): 폼 2,431행=독립 기준 일치·업로드 왕복 SUCCESS 3/ERROR 0·일괄입력 2,433행/9.5s.
5. DMF0074 DATECONV 등 **타 UI 미이관분은 본 폴더 범위 아님** (DMF0082 한정 지시).

**상태: 취합 완료 / 클라우드 미적용** (적용 후 90_VERIFY 결과 보존)
