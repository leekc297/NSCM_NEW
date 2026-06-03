# DMF0020 — Sales Future Price (환율/판매단가 관리) Deploy Package

> 룰 22 §9 (Deploy Package 완전성) + hook `deploy-package-completeness.md` 준수.
> 작성: 2026-06-03 (DMF0020 완전 신규 풀스택, Phase 1~7).

## 화면 정보

| 항목 | 값 |
|---|---|
| MENU_ID | `DMF0020` |
| 도메인 | DM (Demand Master) |
| 부모 메뉴 | `DEMAND_MASTER` (lv 3, sort 50) |
| FE 경로 | `/master/demand-master/sales-future-price` |
| Sheet명 (메인) | `main` (메타 SQL 의 `futurePrice` 와 차이 — 확인 필요) |
| 메인 SP | `PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO` (4 IN + 2 OUT) |
| 저장 SP | `PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` (8 IN + 1 OUT) |
| AS-IS .cs | 3,969줄 (Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/...) |
| To-Be FE | 22 파일 (`01_FE/sales-future-price/`) |

## 5-종 인벤토리 (룰 22 §9.2)

### 1. FE Sheet
- `main` — 메인 그리드 (P_DMF0020_GET_FUTUREPRICE_INFO)
- `pivot` — Tab2 PivotGrid (클라이언트 측 unpivot)
- `exchange` — ExchangeRate Popup
- `priceBatch` — Price 일괄입력 Popup
- `version` — Version 선택 Popup
- `titleSet` — Grid Column Setting Popup
- `owner` — Owner 조회
- `spreadTitle` / `spreadTitleDate` — 동적 컬럼 메타
- `measureCount` — Item별 Measure 개수 (RowSpan)

### 2. POPUP Modal (7개)
| 분류 | Modal | 분석서 | 상태 |
|---|---|---|---|
| 공용 (재사용) | `ProjectByDivisionModal` | `Doc/_analysis/.../DMF0020_POPUP_*` | wiring |
| 공용 (재사용) | `ItemByDivisionModal` | (공통) | wiring |
| 공용 (재사용) | `OwnerByDivisionModal` | `DMF0020_POPUP_Owner/` | wiring |
| 신규 | `ExchangeRateModal` | `DMF0020_POPUP_ExchangeRate/` | ✅ |
| 신규 | `SalesPriceVersionModal` | `DMF0020_POPUP_Version/` | ✅ |
| 신규 | `ColumnTitleSetModal` | `DMF0020_POPUP_GridColumnSetting/` | ✅ |
| 신규 | `PriceBatchInputModal` | `DMF0020_POPUP_Price/` | ✅ MVP |
| 신규 (stub) | `SalesPriceRangeModal` | `..._SalesPriceRange/` | stub |
| 신규 (stub) | `SalesPriceTemplateModal` | `..._SalesPriceTemplate/` | stub (ESS only) |

### 3. BE SP (PKG_DMF0020 — 18개, DB VALID)
| # | SP | 동봉 |
|---:|---|:---:|
| 1 | P_DMF0020_GET_FUTUREPRICE_INFO ⭐ | ✅ |
| 2 | P_DMF0000_SAVE_EXCHANGE_POPUP_DATA ⭐ | ✅ |
| 3 | P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE | ✅ |
| 4 | P_DMF0020_GET_MEASURE_COUNTINFO | ✅ |
| 5 | P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE | ✅ |
| 6 | P_DMF0020_EXCEL_UPLOAD | ✅ |
| 7 | P_DMF0020_GET_SPREAD_TITLE | ✅ |
| 8 | P_DMF0020_GET_SALES_PRICE_TEMPLATE | ✅ |
| 9 | P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP | ✅ |
| 10 | P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA | ✅ |
| 11 | P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP | ✅ |
| 12 | P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE | ✅ |
| 13 | P_DMF0020_GET_SPREAD_TITLE_DATE | ✅ |
| 14 | P_DMF0020_GET_OWNER_DATA | ✅ |
| 15 | P_DMF0020_GET_WEEKDATA | ✅ |
| 16 | P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL | ✅ |
| 17 | P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION | ✅ |
| 18 | P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP | ✅ |

**공용/wrapper SP** (별도 표시 — PKG 외):
- `SCM0001_GET_*` (Common Division/Site/Team/EndCustomer/BizType/Plant lookup) — NSCM 공통 PKG
- `PR_GET_DAY_RANGE`, `DM0021_GET_DM_PLN_SALES_PLAN`, `DMF0003_GET_BUCKET_TYPE_CODE` — 공통 endpoint

### 4. PROC_M 메타 (SCM_ADM_PROC_M)
- `PKG_DMF0020.P_DMF0020_GET_FUTUREPRICE_INFO` 6 row (`startYyyymmdd / endYyyymmdd / sesUserId / mnuId / o_rc1 / o_result_cursor`)
- `PKG_DMF0020.P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` 9 row
- **2026-06-03 fix**: `userId` → `sesUserId`, `menuId` → `mnuId` (BE 자동 채움 키 정합, 메모리 `feedback_proc_meta_col_nm_be_auto_keys`)

### 5. SP body (03_SP_Body/)
- `04_Package_PKG_DMF0020.sql` (4,788줄, SPEC + BODY)
- 컴파일 검증 통과 — DB Docker Oracle 적재 시 PACKAGE / PACKAGE BODY 모두 VALID

## 적용 순서

```bash
# 1. SP body 적재 (Docker Oracle)
sqlplus SCM_MGR/...@localhost:1521/FREEPDB1 @03_SP_Body/04_Package_PKG_DMF0020.sql
# 확인: PKG_DMF0020 PACKAGE / PACKAGE BODY 모두 VALID

# 2. 메타 등록 (BLOCK 1~7)
sqlplus SCM_MGR/...@localhost:1521/FREEPDB1 @02_DB_Meta_SQL/03_DMF0020_Registration.sql
# 확인: 7-BLOCK 모두 PASS (BLOCK 4 PROC 15개)

# 3. (이미 03_DMF0020_Registration.sql 안에 sesUserId/mnuId 반영) — 별도 fix 불필요
# 10_DMF0020_proc_meta_be_auto_keys_fix.sql 는 이전 버전 SQL 호환용 보존

# 4. FE 코드 복사
cp -r 01_FE/sales-future-price/ nscm-fe/features/master/src/pages/sales-future-price/

# 5. BE 재기동 + 로컬 검증
gradlew bootRun  # BE
# 브라우저: http://127.0.0.1:5173/master/demand-master/sales-future-price
```

## 검증 결과 (Phase 1~5)

- ✅ Phase 1: AS-IS 5종 자료 모두 확인 (.cs 3969 + .Designer.cs 1599 + xlsx + 9 MD + Figma 2 SVG)
- ✅ Phase 2: PKG_DMF0020 18 SP DB VALID + PROC_M 6 row 라우팅 검증 PASS
- ✅ Phase 3: `__asis-mapping__.md` 4축 매트릭스 — 153/153 (100%) 매핑
- ✅ Phase 4: FE 22 파일 신규 작성 (component 4 + modal 8 + hook 2 + util 2 + 메인 4 + mapping 1 + index 1)
- ✅ Phase 5: 메타 SQL 7-BLOCK 재실행 PASS + minyonglee1 ADMIN 그룹 → DMF0020 권한 부여 확인
- ⏳ Phase 6: Deploy package 작성 (본 문서)
- ⏳ Phase 7: 로컬 검증 (BE 재기동 + FE 진입 + POPUP 동작)

## 후속 보강 (Phase 4 MVP 단계 → 풀 구현)

- §2.1 SP 15건 (Modal 안 useTabProcQuery + apiClient.post 연동)
- §3.2 POPUP Lock 가드 5건 (MSG00135/00408/00142)
- §4 SUM 헤더 2건 (E1, E2)
- E1, E2 (SUM 헤더) — FlexGridColumnGroup `<header="SUM">` 그룹 보강
- 동적 시간축 컬럼 SP 연동 (spreadTitleDate sheet 등록 + BLOCK 4 PROC_M 추가)
- BLOCK 3 SHEET_COLUMNS 메인 그리드 32 col 보강 (현 7 col = ExchangeRate Popup 용)

## 참조 룰

- 룰 25 §0.5 / §1.5 / §1.5.1 / §1.5.2 / §1.5.3 / §1.6 / §3.3.1
- 룰 22 §9 (Deploy Package 완전성)
- 룰 23 (`@shared/mui` import 인벤토리)
- 룰 24 (As-Is Cross-Check 4축)
- 룰 12 §11.6 / §11.7 / §11.8 (Grid Common)
- 룰 08 §3 / §3.0 / §4.4 (Screen Registration 7-BLOCK)
- 룰 31 §5.0 / §6.1 / §6.2 (Figma Integration)
- 룰 09 (Validation/Expression)
- 룰 10 (Dynamic Proc Call)
- 룰 27 §F (FlexGridColumnGroup single-child 회피)

## 변경 이력

- 2026-06-03: 완전 신규 풀스택 작성. AS-IS 정본 Forms.UIL/Master (3,969줄) 기반.
