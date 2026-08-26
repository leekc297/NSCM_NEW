# DMF0082 클라우드 이관 — 금일(2026-08-25) 수정분 전용

> **범위: 오늘 수정분만** (사용자 지시 — 전체 항목 아님). 전체 취합본 = `DMF0082_CLOUD_20260823_FULL` (별건·미적용).
> 원천은 전부 사내 라이브 신선 덤프/실측 (2026-08-25).

## 담긴 정정 15건

| # | 마커 | 내용 | 원장 |
|---|---|---|---|
| 1 | `E20260825-SCPPLOC` ×1 | SCP Planner LOC 편집 불가 정정 (AS-IS 파리티) | REQ:CHAT-20260825-1 |
| 2 | `E20260825-AFSBLANK` ×2 | AS_FROM_SITE NULL→' ' 스테이징 정규화 (GET/CURRENT — 실적/계획 2행 분리 해소) | AS_FROM_SITE 건 |
| 3 | `E20260825-AFSNVL` ×1 | 조회 전 투영 AS_FROM_SITE = NVL(x,' ') 27치환 (RTF 계열 포함) | 동일 건 |
| 4 | `E20260825-81AUTH` ×3 | 81 권한체계: 룩업 등재 + 그룹잠금(LIMIT_AUTH) 해석 + LOC 강제개방 81 제외 | REQ:CHAT-20260825-2 |
| 5 | `E20260825-CUSTSUB` ×1 | 81 CUST FCST 종속 메저(EDI·Commercial_Agreement) 데이터 기반 산출 (DMF0003 이식) | REQ:CHAT-20260825-6 |
| 6 | `E20260825-CURRNORM` ×2 | CUST_FCST 실적 CURRENCY '-' 정규화 — 계획과 행 분리 해소 | REQ:CHAT-20260825-8 |
| 7 | `E20260825-XLSMASTER` ×7 | Excel Form 행 원천 = 판가 마스터 직생성 (MAIN GET 종속 폐지) + 성능 3겹 | REQ:CHAT-20260825-9 |
| 8 | `E20260825-XLSBATCH` ×4 | Excel Form 추출 기준 = **Price Batch Input(일괄입력) 동일** — 동적 구간 BETWEEN + SITE(SALES)/SITE_ITEM 게이트 + ITEM_V INNER (일괄입력 PRICE 축만 제외) | 동일 건 후속 |
| 9 | `E20260825-XLSBATCH2` ×1 | ITEM_V 선실현(MATERIALIZE) — INNER 전환이 유발한 VIEW PUSHED PREDICATE 행별 폭발 차단 (일괄입력 원문의 GTT 선적재 등가) | 동일 건 후속 |
| 10 | `E20260825-XLSPRJ` ×3 | Excel Form 에 PROJECT_CODE/PROJECT_NAME/PROJECT_OWNER 출력(제 컬럼 정정, SCM_MST_PROJECT LEFT) + FE 빈 정보성 컬럼 숨김 | REQ:CHAT-20260825-11 |
| 11 | `E20260825-XLSPRICECOL` ×3 | **Excel Form 컬럼 = 단가 테이블(SCM_MST_FUTURE_PRICE) 컬럼 구성** — 행 축 = 원장 키(PLANT 포함), END_CUSTOMER 컬럼 제거, MAIN 메타 종속 폐지 | REQ:CHAT-20260825-12 |
| 12 | `E20260825-XLSPRICECOL2` ×11 | 업로드 검증 SP 슬롯 재편 — 슬롯2 Project Code(코드 항등)/슬롯8 Plant Site(마스터∪원장 도메인 검증) + T_MAIN **Plant 직송**(구 'Plant Site 축 미결' 해소)·CELL_PROD '-' | 동일 건 |
| 13 | `E20260825-SAVEPOPCLOB` ×1 | 일괄입력 팝업 동적 SQL 버퍼 VARCHAR2(4000)→CLOB — 재적재로 기간 도메인 확대 후 동적 PIVOT 조립 4000 초과 = ORA-06502 정정 (hook #106) | REQ:CHAT-20260825-13 |
| 14 | `E20260825-SAVEPOPCLOB2` ×3 | 동일 SP 의 동적 PIVOT 목록 LISTAGG(SQL 4000 한계)→CLOB 루프 집계 — 넓은 구간(22주)에서 ORA-01489 정정 | 동일 건 |
| 15 | `E20260825-SAVEPOPPERF` ×1 | 일괄입력 B1 CC(직전/마지막 주차 가격) 집계+재조인 → KEEP LAST 단일 스캔 — 67s→9.5s (등가 실측: 6,171행·행해시 동일) | REQ:CHAT-20260825-14 |

## 이관 파일 (필수 대상만)

| 파일 | 방식 | 내용 |
|---|---|---|
| `A_DB/21_LOOKUP_GET_ADMIN_GROUP_MEASURE_81.sql` | 멱등 MERGE 72행 | 금일 생성 룩업 **최종 상태 스냅샷** — MKT_FCST 30(무속성)/LOC 24(4그룹)/SCM_FCST 18(division별 TUE 창+LIMIT=MKT_FCST) |
| `A_DB/23_LOOKUP_LOC_81.sql` | 멱등 MERGE 6행 | `DM_UI_EDITABLE_MEASURE` (DMF0082/LOC) 81계열 — Excel Form 대상 메저 축 (없으면 폼 0행) |
| `A_DB/24_EXCEL_HEADER_PRICECOL.sql` | UPDATE 1행 | `SCM_ADM_EXCEL_COLUMNS` HEADER_CONTENT — 슬롯2 Project Code/슬롯8 Plant Site (위치 보존, **02 BODY 와 동시 적용 필수** — 한쪽만 적용 시 업로드 슬롯 계약 불일치) |
| `A_DB/02_PKG_DMF0082_BODY.sql` | 전체 교체 | 사내 라이브 BODY (2026-08-25k) — 금일 마커 15종 포함 |
| `A_DB/90_VERIFY.sql` | 검증 | 마커 15종·컴파일·룩업 카운트·40 불변(15행)·SCM_FCST 창 6종 |

**적용 순서: `21` → `23` → `24` → `02` → `90`** (24·02 는 같은 배포창에서 연속 적용) — BODY 의 LOC 분기·폼 메저 축이 룩업 존재 여부로 갈리므로 룩업 선행.

## FE — 이관 대상 3건 (2026-08-25 추가)

`B_FE/forecast-price/components/ForecastPriceGrid.tsx` — **음수 = 빨간 글자** 배선 (REQ:CHAT-20260825-7).
AS-IS `CustomCell.NegativeRed=true`(:1876)·공용 SpreadInfo 기본 파리티. 정본 헬퍼
`@foundation/utils paintNegativeText/toGridNumber` 사용 — **전제: 클라우드 FE 공통소스가
`gridNegativeText.ts` 포함 세대(common/main d2d7c282, 2026-08-24)여야 함.** 구세대면 TS2305.
배선 3곳: import + 동적 값 셀(진입 시 일괄) + 정적 셀(음수 빨강 > 개인화 Text Color 우선순위).
type-check @demand PASS.

`B_FE/forecast-price/components/modals/ForecastTemplateModal.tsx` + `B_FE/forecast-price/utils/forecast-price.excelForm.ts`
— Excel Form **빈 정보성 컬럼 숨김** (`pruneEmptyInfoColumns`, REQ:CHAT-20260825-11). 전 행이 빈값인
정보성 컬럼을 그리드·다운로드에서 제외(토큰 10+주차는 계약상 보존, 조회 전에는 전체 유지).
PROJECT_CODE/NAME/OWNER 는 SP(XLSPRJ) 값이 채워져 자동 표시된다. type-check @demand 강제 재실행 PASS.

## FE — 그 외 이관 대상 없음 (실측 사유)

- 금일 DMF0082 정정 4건은 **전부 SP·룩업 수정** — FE 무수정.
- FE 편집 게이트는 이미 룩업 소비 구조: `forecast-price.wsAuth.ts` `isMeasureEditableByAuth` 가
  MKT_FCST/SCM_FCST/LOC 를 **GET drop3(O_RC4 = GET_ADMIN_GROUP_MEASURE 산출) 값 그대로** 판정.
  AS_In_Req(W/S)·VMI_In_Req(사이트 VMI)는 의도된 별도 규칙(현업 검수 41번 원문 — 룩업 무관).
- 오늘 forecast-price 파일 변경 3건(ForecastPrice.tsx/ForecastPriceGrid.tsx/forecast-price.combo.ts)은
  **공통소스(common/main d2d7c282) 동기화 산물** — 3건 모두 공통 최신본과 diff 0 실측.
  클라우드 FE 는 공통소스 배포 경로가 정본이므로 본 패키지에 동봉하지 않음.

## ⚠ 주의

1. **BODY 는 전체 교체 방식** — 클라우드 BODY 가 08-23 FULL 미적용 상태(구세대)면 이 파일로
   08-18/20/23 누적 delta 까지 한꺼번에 반영된다. 금일분만 골라 넣는 것은 불가(단일 본문).
   세대 판정 = FULL 패키지 `00_CLOUD_PRECHECK.sql` C1.
2. **GTT/DDL 미동봉** — 클라우드에 `GT_DMF0082_*` 33종·`DEFAULT ON NULL` 미적용이면
   FULL 패키지 `00_GTT_DDL.sql`/`00B` 선행 필수 (BODY 컴파일 실패).
3. 사내 실측: 컴파일 VALID·마커 1/2/1/3·실호출 매트릭스 5계정×div 81/81_UC/40 기대 1:1·40 회귀 0.
4. FE 한계 (향후): 룩업에 **새 메저**(TMM_FCST 등)를 추가해도 FE `GROUP_AUTH_MEASURES` 화이트리스트
   (MKT_FCST/SCM_FCST/LOC 3종) 밖이라 read-only — 그때는 FE 1줄 확장 필요. 기존 3메저 권한 변경은 DB 만으로 완결.

**상태: 취합 완료 / 클라우드 미적용** (적용 후 90_VERIFY 결과 보존)
