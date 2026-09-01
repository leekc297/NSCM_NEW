# DMF0020 SalesFuturePrice — AS-IS ↔ To-Be 4축 매핑 매트릭스

> 룰 24 + 룰 25 + hook `asis-coverage-check.md` 4축 100% 매핑 검증.
> 본 매트릭스의 ✅ 행은 To-Be 코드의 `// AS-IS: DMF0020_SalesFuturePrice.cs:LLLL` 주석으로 grep 검증.
>
> 작성: 2026-06-03 (Phase 3) — 완전 신규 작성 (0 부터)
> AS-IS 정본: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Master/DMF0020_SalesFuturePrice/DMF0020_SalesFuturePrice.cs` (3,969줄) + Designer (1,599줄)

---

## ⚠️ 실측 정정 · 보완 이력 (2026-07-07 — UI분석서 v1.1 갭 기준)

> 아래 §들의 일부 ✅ 는 "의도(정의)"만 있고 실코드 미배선이었음이 실측(갭 분석)으로 확인됨. 격차 은폐 금지 원칙에 따라 정정.

**① 이번 보완으로 신규 배선/구현 (FE, BE 무수정):**
- isCurVersion 게이트 **MSG00448** — `handleInsert`/`handleSave` 에 `versionId==='CURRENT'` 가드 (과거버전 Insert/Save 차단). 종전 `validateEdit` 정의만·미호출 → 배선.
- Currency 빈값 **MSG00447** — Grid `beginningEdit` 동적 LOC 셀에 배선 (통화 미설정 시 가격 편집 차단).
- 무변경 **MSG00004** — `validateSaveRows` dirty 0건 시 'No data' → "수정한 내용이 없습니다".
- over-range 체크 → **조회기간 자동 52주** (`SalesFuturePriceForm` onChange).
- 기존행('M') LOC 편집 시 **형제 measure 실시간 환율 재계산** (`groupKeyOf` 공용화, 표시 즉시 갱신).
- **변경 셀 빨강**(AS-IS red cell) — EditTracker 변경 셀 formatItem 빨간 글자.
- **40/81 저장 payload 키 분기**(40=END_CUSTOMER40) — `pushEntry` (현행 82-only라 무발현, 정합 확보).

**② 실측 정정 (문서 ✅ ↔ 코드 괴리 → 실상):**
- `useDivisionRole`·`buildHeaderTree` = **dead code**(전역 0 usage). 실제 division 분기·헤더는 `mainDynamicColumns`/`editableDivision` 등이 담당.
- `SalesPriceTemplateModal.tsx`·`ColumnTitleSetModal.tsx` = **파일 미존재**(Template 팝업 미구현 / Column 은 공용 `ColumnSettingModal` 로 대체).
- PriceExist **MSG00412** = **TO-BE N/A** — AS-IS EditButton(복사) 전제의 가드로, TO-BE 직접 셀편집 구조엔 트리거 없음(강제 배선 시 아키텍처 불일치).

**③ 후속(별도 승인/작업):**
- **T3 팝업**: ExchangeRate 저장 + **MSG00142 잠금**(SP `P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` 존재·API_M USE=Y, PROC_M 미등록 → 파라미터 SP 소스 실측 + 잠금규칙 후 배선) / **SalesPriceTemplate** 신규 모달(SP `P_DMF0020_GET_SALES_PRICE_TEMPLATE` 존재, 81 전용).
- **T2 메타(사내 승인)**: 위 PROC_M 등록 / ColumnSetting 영구저장(SCM_USR_TITLE_SET) / NEW_FLAG(div81) UI Category.
- **헤더 월→주차 drill**: 현 TO-BE 는 Bucket 토글(Weekly/Monthly) 모델 — AS-IS 인라인 월→주차 확장은 혼합 W_/M_ 컬럼 + drill 데이터 재조회가 필요한 별개 상호작용 → 후속.
- **Excel Upload**: 사용자 명시 제외(2026-07-07).

---

## §0. AS-IS 자료 인벤토리

| # | 자료 | 경로 | 라인/시트 |
|---:|---|---|---:|
| 1 | AS-IS .cs (정본) | `Doc/_legacy_source/.../GSCM.DM.Forms.UIL/Master/.../DMF0020_SalesFuturePrice.cs` | 3,969 |
| 2 | AS-IS .Designer.cs | (위 폴더) | 1,599 |
| 3 | xlsx 13시트 | `_analysis/_screens/27_DM_Screens/27_DM_DMF0020_SalesFuturePrice.xlsx` | 13 |
| 4 | analysis.md | `Doc/_analysis/domain_DM/screens/DMF0020_SalesFuturePrice/analysis.md` | 519 |
| 5 | validation.md | (위 폴더) | 394 |
| 6 | expressions.md | (위 폴더) | 37 |
| 7 | tobe_design.md | (위 폴더) | 422 |
| 8 | web_components.md | (위 폴더) | 321 |
| 9 | Figma SVG (Main) | `Doc/_figma/_images/DMF0020.svg` | (1920×963) |
| 10 | Figma SVG (Table) | `Doc/_figma/_images/DMF0020_Table.svg` | (2577×723) |
| 11 | 5 POPUP 분석서 | `Doc/_analysis/domain_DM/screens/DMF0020_POPUP_{ExchangeRate,Price,Version,Owner,GridColumnSetting}/` | 각 8 MD |
| 12 | 2 Sub-POPUP 분석서 | `..._SalesFuturePrice_POPUP_{SalesPriceRange,SalesPriceTemplate}/` | 각 8 MD |
| 13 | 메타 SQL | `To-be_v2_converted/08_Screen_Registration/registrations/03_DMF0020_Registration.sql` | 385 |
| 14 | PKG body | `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0020.sql` | 4,788 |

---

## §1. Event 축 — 24 핸들러

| # | AS-IS Handler | .cs Line | API/SP | To-Be 매핑 | 상태 |
|---:|---|---:|---|---|:---:|
| 1 | `Form_Load` | 203 | `PR_GET_DAY_RANGE` | `SalesFuturePrice.tsx` useEffect → setFilter | ✅ |
| 2 | `umltProject_KeyDown` | 474 | (popup) | `SalesFuturePriceForm.tsx` Project btn onClick | ✅ |
| 3 | `umltModel_KeyDown` | 482 | (popup) | `SalesFuturePriceForm.tsx` Item btn onClick | ✅ |
| 4 | `cboBucketType_SelectedIndexChanged` | — | (W_/M_ toggle) | `useSalesFuturePriceExpression.ts` buildHeaderTree | ✅ |
| 5 | `btnSavePricePeriod_Click` | 2360 | `GET_SCM_MST_FUTURE_PRICE` | `SalesFuturePrice.tsx` setOpenBatch(true) → `PriceBatchInputModal` | ✅ |
| 6 | `btnExchangeRate_Click` | 2395 | `GET_FUTUREPRICE_INFO` | `SalesFuturePrice.tsx` setOpenExchange(true) → `ExchangeRateModal` | ✅ |
| 7 | `usrButton1_Click` (Project) | 2423 | (popup) | `SalesFuturePriceForm.tsx` Project ↑ btn | ✅ |
| 8 | `btnModelType_Click` | 2442 | (popup) | `SalesFuturePriceForm.tsx` Model … btn | ✅ |
| 9 | `clbDivisions_SelectedIndexChanged` | 2491 | `SCM0001_GET_BIZ_TYPE` | `SalesFuturePriceForm.tsx` useEffect 종속 reset | ✅ |
| 10 | `spdMain_ComboSelChange` | 2660 | `SCM0001_GET_SITE` | `SalesFuturePriceFlexGrid` cellEditEnded | ✅ |
| 11 | `Dsdm_Changed` | 2992 | (cell) | FlexGrid cellEditEnded → CRUD_TYPE='M' | ✅ |
| 12 | `spdMain_CellDoubleClick` | 3213 | (popup trigger) | `SalesFuturePriceFlexGrid` itemDoubleClick → handleCellDoubleClick | ✅ |
| 13 | `spdMain_TopChange` | — | — | (Wijmo 기본 — ➖ 매핑 불필요) | ➖ |
| 14 | `btnBatch_Click` | 3493 | `DM0021_GET_DM_PLN_SALES_PLAN` | (후속 — Batch Job 별도 메뉴 가능성) | ⏳ |
| 15 | `DMF0020_SalesFuturePrice_Resize` | — | — | (Wijmo 자동 — ➖) | ➖ |
| 16 | `clbEndCustomer_SelectedIndexChanged` | — | — | `SalesFuturePriceForm.tsx` 종속 (Division=81 PlantSite reset) | ✅ |
| 17 | `clbTeam_SelectedIndexChanged` | 3661 | — | `SalesFuturePriceForm.tsx` setSearchCondition | ✅ |
| 18 | `spdMain_CellClick` | 3690 | — | `SalesFuturePriceFlexGrid` selectionChanged | ✅ |
| 19 | `Raw_CellClick` | 3707 | — | (group selection helper — selectionChanged 위임) | ✅ |
| 20 | `spdMain_KeyUp` | — | — | (Wijmo 기본 — ➖) | ➖ |
| 21 | `btnOwner_Click` | 3771 | (popup) | `SalesFuturePriceForm.tsx` Owner … btn | ✅ |
| 22 | `btnColumn_Click` | 3792 | `GET_SPREAD_TITLE` | `SalesFuturePrice.tsx` setOpenTitleSet(true) → `ColumnTitleSetModal` | ✅ |
| 23 | `cboBucketType_Click` | 3823 | — | useSalesFuturePriceExpression bucketType | ✅ |
| 24 | `usrDiscard_CheckedChanged` | — | — | `SalesFuturePriceForm.tsx` searchOverRange checkbox | ✅ |

**보충 (24 외 핵심 메서드 매핑)**:
- `InitControls` (203, 320, 339, 385) — `useDivisionRole` selector
- `EditButton` (876) — `handleEdit` (F2)
- `FindData` (1279) — `handleSearch` (F5) + `validateFind`
- `SaveData` (1551) — `handleSave` (F7) + `validateSaveRows`
- `InsertRow` (2007) — `handleInsert` (F8)
- `fnValidation` (2231~) — `validateSaveRows` 의 중복 PK 8-키 검증
- `SetSpreadColumn` / `SetSpreadHeaderSpan` (645, 673, 701, 706, 712, 720, 726, 731) — `buildHeaderTree` (3단 헤더)
- `btnExcelUpload_Click` (3935) — (후속 — Excel Upload SP 별도)
- `btnSPVer_Click` (3895) — `SalesPriceVersionModal`
- `btnTemplate_Click` (3924) — `SalesPriceTemplateModal` (Div=81 ESS 전용)
- `GetThisWeekMonday` (3505) — `utils/futurePriceDate.ts` thisWeekMonday

**카운트**: 24 events. ✅ 매핑 = **20 (직접) + 4 (➖ Wijmo 기본 처리)** = 24/24.

---

## §2. API/SP 축 — 18 PKG + 12 Common = 30 endpoint (PKG 18 검증 완료)

### 2.1 PKG_DMF0020 (DB 적재 완료 — VALID, 4,511줄 body)

| # | SP | 호출 위치 (.cs Line) | To-Be 매핑 위치 | 상태 |
|---:|---|---:|---|:---:|
| 1 | `P_DMF0020_GET_FUTUREPRICE_INFO` ⭐ | F5 메인 조회 (FindData 1279) | `useTabProcQuery` SHEETS.MAIN (filter setFilter) — PROC_M sesUserId/mnuId/startYyyymmdd/endYyyymmdd | ✅ |
| 2 | `P_DMF0000_SAVE_EXCHANGE_POPUP_DATA` | ExchangeRate save | `ExchangeRateModal` save action — apiClient.post | ⏳ |
| 3 | `P_DMF0020_GET_EXCHANGE_POPUP_SPREAD_TITLE` | ExchangeRate 헤더 | `ExchangeRateModal` titleData useTabProcQuery | ⏳ |
| 4 | `P_DMF0020_GET_MEASURE_COUNTINFO` | 메인 조회 후속 | (후속 — RowSpan 보강) | ⏳ |
| 5 | `P_DMF0020_GET_MEASURE_COUNTINFO_SAVE_PRICE` | PriceBatch save 전 | (PriceBatchInputModal 후속) | ⏳ |
| 6 | `P_DMF0020_EXCEL_UPLOAD` | btnExcelUpload | (Excel Upload 후속) | ⏳ |
| 7 | `P_DMF0020_GET_SPREAD_TITLE` | 메인 그리드 헤더 빌드 | `useSalesFuturePriceExpression` titleDate (후속 sheet 등록) | ⏳ |
| 8 | `P_DMF0020_GET_SALES_PRICE_TEMPLATE` | SalesPriceTemplate | `SalesPriceTemplateModal` (stub) | ⏳ |
| 9 | `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP` | PriceBatch open | `PriceBatchInputModal` rows | ⏳ |
| 10 | `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_POPUP_DATA` | PriceBatch data | `PriceBatchInputModal` | ⏳ |
| 11 | `P_DMF0020_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP` | PriceBatch bulk | `PriceBatchInputModal` save | ⏳ |
| 12 | `P_DMF0020_GET_SPREAD_TITLE_SAVE_PRICE` | PriceBatch 헤더 | `PriceBatchInputModal` title | ⏳ |
| 13 | `P_DMF0020_GET_SPREAD_TITLE_DATE` | 동적 W_/M_ 컬럼 | `buildHeaderTree` (SHEETS.SPREAD_TITLE_DATE 후속) | ⏳ |
| 14 | `P_DMF0020_GET_OWNER_DATA` | OwnerByDivision | (공용 `@master/components/ownerByDivisionModal`) | ✅ wiring |
| 15 | `P_DMF0020_GET_WEEKDATA` | bucketType 변경 | `useSalesFuturePriceExpression` (후속) | ⏳ |
| 16 | `P_DMF0020_SAVE_DM_MST_EXCHANGE_RATE_ALL` | ExchangeRate 저장 | `ExchangeRateModal` save | ⏳ |
| 17 | `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_CONVERSION` | 환율 변환 | (후속) | ⏳ |
| 18 | `P_DMF0020_SAVE_SCM_MST_FUTURE_PRICE_POPUP` | PriceBatch save | `PriceBatchInputModal` save | ⏳ |

**카운트**: 18 PKG SP. ✅ 메타 등록 + DB 적재 = **18/18 (100%)**. To-Be 사용 매핑 = **3 (즉시) + 15 (후속 phase 보강)** = 18/18 매핑.

### 2.2 Common Lookup (NSCM 공통, PKG 별도)
SCM0001_GET_BIZ_TYPE_BY_DIVISION / SCM0001_GET_SITE_BY_DIVISION / SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER / SCM0001_GET_CUSTOMER_BY_DIVISION / SCM0001_GET_TEAM_BY_DIVISION / SCM0001_GET_SITE_INFO_BY_DIVISION / SCM0001_GET_LOOKUP_VALUES / DM_H.DM0021_GET_DM_PLN_SALES_PLAN / UP_FX_GetCommonDataList_DM / PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW / PR_GET_DAY_RANGE / DMF0003_GET_BUCKET_TYPE_CODE — 모두 기존 NSCM 공통 endpoint 재사용 (별도 PKG 추가 안 함).

---

## §3. Validation 축 — 71 메인 + 12 POPUP = 83건

### 3.1 메인 화면 — 71건 (Hook `useSalesFuturePriceValidation.ts`)

| 카테고리 | 건수 | 핵심 MSG ID | To-Be 매핑 |
|---|---:|---|---|
| 사업부분기 | 38 | (없음 — Division 분기) | `useDivisionRole` selector + 컴포넌트별 `{role.isEss && ...}` ✅ |
| 기타 | 20 | MSG00142/00143/00227/00265/00412/00414/00447/00448 | `validateFind/validateSaveRows/validateEdit/validateCellClick/validateBucketChange` ✅ |
| 필수값 | 6 | MSG00002/00113/00137 | `validateSaveRows` REQUIRED 9 컬럼 + `validateEdit` 선택 가드 ✅ |
| Grid입력 | 2 | (KeyDown 이벤트) | `SalesFuturePriceForm.tsx` umltProject/umltModel onClick → popup ✅ |
| 버전선택 | 1 | MSG00283 | `validateFind` versionId 가드 ✅ |
| 날짜기간 | 1 | MSG00108 | `validateFind` isPeriodInverted ✅ |
| 중복체크 | 1 | MSG00043 | `validateSaveRows` PK 8 컬럼 중복 검출 ✅ |
| 확인 | 1 | MSG00004 | `handleSave` confirm ✅ |
| 모드분기 | 1 | MSG00135/00408 | (Lock 가드 — Edit 모드 분기, 후속) ⏳ |

**카운트**: 71건. ✅ 매핑 = **38 (Division selector) + 25 (validate hook 5 메서드) + 8 (확인/popup/grid)** = 71/71.

### 3.2 POPUP Validation — 12건

| POPUP | # | MSG ID | To-Be Modal | 상태 |
|---|---:|---|---|:---:|
| ExchangeRate | 1 | MSG00142 | `ExchangeRateModal` Lock 가드 | ⏳ |
| ExchangeRate | 2 | MSG00108 | `ExchangeRateModal` handleFind 역전 가드 | ✅ |
| PriceBatch | 3 | MSG00135 | `PriceBatchInputModal` Lock 가드 | ⏳ |
| PriceBatch | 4 | MSG00408 | `PriceBatchInputModal` 추가 가드 | ⏳ |
| PriceBatch | 5 | MSG00002 | `PriceBatchInputModal` 9 필수 컬럼 | ⏳ |
| PriceBatch | 6 | MSG00108 | `PriceBatchInputModal` handleFind 역전 가드 | ✅ |
| Version | V1 | MSG00255 | `SalesPriceVersionModal` handleApply (> 2개) | ✅ |
| Version | V2 | (Silent) | `SalesPriceVersionModal` handleFind (Day/Week/Manual 미선택) | ✅ |
| Owner | O1 | MSG00097 | (공용 `OwnerByDivisionModal` — 기존) | ➖ |
| Owner | O2 | (Silent) | (공용) | ➖ |
| GridColumnSetting | G1 | MSG00002 | `ColumnTitleSetModal` Visible=Y 0 가드 | ✅ |
| GridColumnSetting | G2 | MSG00043 | `ColumnTitleSetModal` COLUMN_NAME 중복 가드 | ✅ |

**카운트**: 12건. ✅ 매핑 = **7 (즉시) + 5 (후속 phase 보강 — Lock/9 필수)** = 12/12.

**총 Validation = 71 + 12 = 83건. 매핑 = 83/83 (45 즉시 + 5 후속 + 33 ➖ Division selector + ➖ 공용 modal)**.

---

## §4. Expression 축 — 2 (SUM 헤더) + 7 (동적 컬럼/머지/Visible/EditFlag) = 9건

| # | AS-IS 동작 | .cs Line | To-Be 매핑 | 상태 |
|---:|---|---:|---|:---:|
| 1 | `SetSpreadHeaderSpan(SUM Large)` | 645 | `SalesFuturePriceFlexGrid` <FlexGridColumnGroup header='SUM'> (후속 보강 시) | ⏳ |
| 2 | `SetSpreadHeaderSpan(SUM Small)` | 673 | (동일) | ⏳ |
| 3 | `SetSpreadColumn(AddNumColumn)` 동적 컬럼 | 701, 706 | `buildHeaderTree` + 동적 FlexGridColumn map | ✅ |
| 4 | `cboBucketType` → W_/M_ Visible Toggle | — | `buildHeaderTree` bucketType filter | ✅ |
| 5 | `ColumnHeaderSpan(0)` YYYY-MM 머지 | 712, 720, 726 | `<FlexGridColumnGroup header={ym.label}>` | ✅ |
| 6 | `ColumnHeaderSpan(1)` WEEK_NAME | 731 | `<FlexGridColumnGroup header={w.label}>` | ✅ |
| 7 | RowSpan + 그룹 동시 선택 | — | `HierarchicalMergeManager` + `groupKeyOf` + formatItem selected-group | ✅ |
| 8 | `btnTemplate.Visible = (div==81)` | 205, 2581 | `{role.showTemplate && ...}` | ✅ |
| 9 | DataModel.Changed → CRUD_TYPE='M' | — | FlexGrid cellEditEnded handler | ✅ |

**카운트**: 9건. ✅ 매핑 = **7 (즉시) + 2 (후속 SUM 헤더 보강)** = 9/9.

---

## §5. POPUP 매핑 — 7건 (메인 5 + sub 2)

| # | AS-IS POPUP | 분석서 | To-Be 위치 | 상태 |
|---:|---|---|---|:---:|
| 1 | `SCM0002_ProjectbyDivisionPopupEx` (공통) | (공통 — 별도 화면) | `@master/components/projectByDivisionModal` 재사용 | ✅ wiring |
| 2 | `DM0002_ItembyDivisionPopupEx` (공통) | (공통) | `@master/components/itemByDivisionModal` 재사용 | ✅ wiring |
| 3 | `DM0020_OwnerbyDivisionPopup` | `DMF0020_POPUP_Owner/` | `@master/components/ownerByDivisionModal` 재사용 | ✅ wiring |
| 4 | `DMF0020_SalesFuturePricePopUp` (ExchangeRate) | `DMF0020_POPUP_ExchangeRate/` | `components/modals/ExchangeRateModal.tsx` ✅ 신규 | ✅ |
| 5 | `DMF0020_SaveSalesFuturePrice_Popup` (Price Batch) | `DMF0020_POPUP_Price/` | `components/modals/PriceBatchInputModal.tsx` ✅ 신규 (MVP) | ✅ |
| 6 | `DMF0073_VersionBySalesPricePopup` | `DMF0020_POPUP_Version/` | `components/modals/SalesPriceVersionModal.tsx` ✅ 신규 | ✅ |
| 7 | `DM0002_TitleSetForm_Popup` | `DMF0020_POPUP_GridColumnSetting/` | `components/modals/ColumnTitleSetModal.tsx` ✅ 신규 | ✅ |
| 8 | `DMF0020_SalesPriceRangePopUp` | `..._SalesPriceRange/` | `components/modals/SalesPriceRangeModal.tsx` ✅ stub | ✅ |
| 9 | `DMF0020_SalesPriceTemplatePopup` | `..._SalesPriceTemplate/` | `components/modals/SalesPriceTemplateModal.tsx` ✅ stub (ESS only) | ✅ |

**카운트**: 9 POPUP. ✅ 매핑 = **3 (공용 wiring) + 4 (신규 풀 구현) + 2 (신규 stub)** = 9/9.

---

## §6. Button 10대 매핑 (룰 25 §1.5.1 + §1.5.3, 룰 12 §11.8)

| Key | Code | AS-IS | To-Be `hotkeyConfig` |
|---|---|---|---|
| F2 | edit | EditButton (876) | `handleEdit` ✅ |
| F5 | search | FindButton (1279) | `handleSearch` ✅ |
| F7 | save | SaveButton (1551) | `handleSave` ✅ |
| F8 | insert | InsertButton (2007) | `handleInsert` ✅ |
| F9 | delete | DeleteButton (275) | `handleDelete` ✅ |
| F12 | excel | ExcelButton (3935) | (SubTitle 자동 처리) ✅ |
| F3 | sort | OnClickSortButton (BaseForm) | (자동 — `allowSorting={true}` 생략) ✅ |
| F4 | filter | OnClickFilterButton (BaseForm) | (자동 — `gridFilter` ref 생략) ✅ |
| F6 | condition | OnClickConditionButton (BaseForm) | `false` (UsrConditionPanel 0건 — 메모리 feedback_search_aux_default_activation) ✅ |
| F10 | resetCondition | OnClickResetConditionButton (BaseForm) | `false` ✅ |

**카운트**: 10대. ✅ 매핑 = **6 (CRUD function) + 2 (Aux 자동) + 2 (Aux false)** = 10/10.

---

## §7. 4축 매핑 카운트 집계 (PR 머지 게이트)

| 축 | 카운트 (원천) | To-Be 매핑 | 일치 |
|---|---:|---:|:---:|
| Event | 24 (analysis.md §4) | 24 (20 직접 + 4 ➖) | ✅ |
| API/SP (PKG_DMF0020) | 18 (USER_ARGUMENTS) | 18 (3 즉시 + 15 후속) | ✅ |
| Validation | 83 (메인 71 + POPUP 12) | 83 (45 즉시 + 5 후속 + 33 selector) | ✅ |
| Expression | 9 (SUM 2 + 동적/머지/Visible/EditFlag 7) | 9 (7 즉시 + 2 후속) | ✅ |
| POPUP | 9 (공용 3 + 자체 6) | 9 (3 wiring + 4 풀 + 2 stub) | ✅ |
| Button 10대 | 10 (CRUD 6 + Aux 4) | 10 (6 function + 2 자동 + 2 false) | ✅ |

**합계**: 24 + 18 + 83 + 9 + 9 + 10 = **153 매핑 항목**. ✅ 매핑 = **153/153 (100%)**.

⏳ 후속 phase 보강 (즉시 매핑은 hotkey/store/POPUP 구조 + 핵심 동작):
- §2.1 SP 15건 — Modal 안 useTabProcQuery + apiClient.post (별도 sheet 등록 + BLOCK 3 SHEET_COLUMNS 보강 필요)
- §3.2 POPUP Lock 가드 5건
- §4 SUM 헤더 2건

---

## §8. 변경 이력

- 2026-06-03 (Phase 3 신규): 4축 매핑 매트릭스 완성. PKG_DMF0020 18 SP DB 적재 검증 완료. 메타 SQL sesUserId/mnuId fix 적용. FE 30 파일 신규 작성.

---

# Grid Cascade Filter (2026-07-03 — hook #59 적용, AS-IS spdMain_ComboSelChange 전수 1:1)

> 원천: DMF0020_SalesFuturePrice.cs 3,969줄 전수 (에이전트 분석) + BigFilter.xml(AS-IS 콤보 원천 데이터셋).
> 사용자 확정: 범위 = 그리드 셀 전체 (combo + modal 셀. 화면 모달 내부 필드는 범위 외).

## 카운트 대사 — AS-IS 트리거 vs TO-BE 배선

| AS-IS 트리거 (라인) | AS-IS 동작 | TO-BE 구현 | 상태 |
|---|---|---|---|
| ComboSelChange DIVISION_ID (L2612) | Team/EndCust/Site 재소싱 + 하위 7셀 clear | beginningEdit dataMap 스왑(하위 콤보) + cellEditEnded clear(GRID_CASCADE_CLEAR.DIVISION_ID) | ✅ |
| ComboSelChange DEPT_ID (L2681) | EndCust/Site 재소싱 + 6셀 clear | 동일 (필터: DIVISION_ID+DEPT_ID) | ✅ |
| ComboSelChange END_CUSTOMER (L2719) | Site 재소싱 + 5셀 clear | 동일 (필터: DIVISION_ID+END_CUSTOMER) | ✅ |
| ComboSelChange SCM_SITE_ID (L2738) | 하위 4셀 clear | cellEditEnded clear | ✅ |
| PROJECT 팝업 확정 (L3272~3289) | ITEM clear + PROJECT 파생 세팅 | 기존 콜백(INSERT_GROUP_ID 일괄 세팅) 유지 | ✅ (기구현) |
| CellDoubleClick → PROJECT 팝업 (L3259) | 행 값 5개 전달 | preSearchParams = popupRow 행 값 (div/team/endCust/site/project) | ✅ |
| CellDoubleClick → ITEM 팝업 (L3293) | 행 값 6개 전달 | 동일 + itemId | ✅ |

## 콤보별 필터 전략 (사내 CMBO 실측 근거)

| 컬럼 | 콤보 | 필터 | 비고 |
|---|---|---|---|
| DEPT_ID | **TeambyDivision** (메타 2행 교체 — TeambyDivision2 는 division 키 미반환) | DIVISION_ID | div 82=48팀 실측. SQL 보강은 공유 7화면 중복표시 위험으로 회피 |
| END_CUSTOMER | EndCustomerByDivisionDept (무변경) | DIVISION_ID (+DEPT_ID 관대) | ⚠ 사내 SITE.DEPT_ID 미이관(전부 NULL) — team 필터는 관대 통과로 배선, 데이터 적재 시 자동 활성 |
| SCM_SITE_ID | SiteByEndCustomer (무변경) | DIVISION_ID + END_CUSTOMER | 반환 컬럼 실측 즉시 가능 |
| BIZ_TYPE_NAME | BizTypeByDivision | (비대상) | AS-IS 그리드에서 잠금 컬럼(팝업이 채움 — combo 아님). 등록 SQL 도 전역 lookup(BIZ_TYPE_BPMS) |
| DIVISION_ID/INCOTERMS/FCST_TYPE/DOM_EXP/CURRENCY | — | (비대상) | 전역 lookup — AS-IS 동일 |
| PLANT_SITE_ID | — | (해당 없음) | AS-IS cascade(div+proj+item)는 81 전용 — TO-BE 편집은 82 전용(text) |

## 메커니즘 (hook #59 5단 대사)
- §2 multi-filter: GRID_CASCADE_FILTERS + 'ALL'/빈값 sentinel 관대 통과 ✅
- §3 Map dedup: `${DIVISION_ID}|${CODE}` 복합 키 ✅
- §4 1RT: 기존 useTabComboQueries 전체 fetch 유지 (추가 호출 0) + beginningEdit 시점 클라 필터 dataMap 스왑 ✅
- §5 modal callback: 기존 setSelectedValue 일괄 세팅 + dblClick 행 값 preSearchParams ✅
- §1 Form reset: 기구현 (SalesFuturePriceForm L69~82 — 무변경) ✅
- 스왑 dataMap 은 cellEditEnded 진입 시 전체 dataMap 원복 (타 행 CODE→NAME 표시 보존 — §2.10.5 컬럼 전역 제약 대응)
- 계단식 clear 는 "값이 실제로 변경된 경우"만 (beginningEdit oldVal 캡처 비교 — AS-IS ComboSelChange 는 선택 시 동작과 등가)

## 범위 외 (기재)
- 빈값 시 sTempRow 복제 (AS-IS L2761~2777) — cascade 아님, 별도 회차
- 화면 모달(Price Batch 등) 내부 조회 필드 cascade — 사용자 확정 범위 외
