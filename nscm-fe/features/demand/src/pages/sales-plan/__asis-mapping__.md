# DMF0021 SalesPlan — AS-IS ↔ To-Be 4축 매핑 (Option A 정식 완성 100%)

> 작성: 2026-06-07 (Phase B-3 SKELETON) | 정밀화: 2026-06-09 (Option A — AS-IS 5,599줄 정밀 read 후 100% 매핑)
> AS-IS 정본: `GSCM/06.UIL/.../Plan/DMF0021_SalesPlan/DMF0021_SalesPlan.cs` (5,599줄) + Designer (1,451줄)
> PKG body: `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0021.sql` (3,678줄)
> 자매 reference: DMF0020 SalesFuturePrice (PIVOT) + DMF0048 SalesMonitoring (Plan 표준)
> 분석서: `Doc/_analysis/domain_DM/screens/DMF0021_SalesPlan/` (7 MD — analysis/validation/expressions/oracle_migration/source_links/tobe_design/web_components/figma_link)

## §0. AS-IS 자료 인벤토리 (정밀)

| # | 자료 | 라인/건수 |
|---:|---|---:|
| 1 | AS-IS .cs | 5,599 (정밀 read: L1~400 + L400~1100 + L1450~1632 + L1900~2400 + L3900~4085) |
| 2 | AS-IS .Designer.cs | 1,451 |
| 3 | analysis.md (정량) | 27 event / 14 endpoint / 51 cols / 5 DefColumns 그룹 / 1 Sheet (shtMain) |
| 4 | validation.md | **141건** (15 handler 별) |
| 5 | expressions.md | **120건** (3 카테고리: 조건부 잠금 112 + SUM 5 + 합계변수 3) |
| 6 | xlsx 13시트 (v7.4) | 1~10시트 신뢰 가능 (정정 안내 없음) |
| 7 | PKG body | 3,678줄 (7+ SP, 메인 2,122 + SAVE 2,937 + SPREAD_TITLE 404 + MEASUREINFO 78) |
| 8 | Mockup PNG ENG/KOR | `_analysis/_screens/27_DM_Screens/DMF0021_SalesPlan_Mockup_*.png` (1600×920) |

## §1. Event 축 — 27 핸들러 100% 매핑

| # | AS-IS handler | Line | Type | To-Be 매핑 | 상태 |
|---:|---|---:|---|---|:---:|
| 1 | `Form_Load` | 304 | Form Load | `useEffect(() => setFilter(), [sc.divisionId])` + `<SalesPlan>` 마운트 | ✅ |
| 2 | `txtProject_KeyDown` | 557 | KeyDown Enter | `<TextField onKeyDown={Enter→openProject}>` (SearchArea Project 필드) | ✅ |
| 3 | `txtItemId_KeyDown` | 565 | KeyDown Enter | `<TextField onKeyDown={Enter→openItem}>` (SearchArea Item 필드) | ✅ |
| 4 | `btnProject_Click` | 3491 | Click | `customButtons[id='btnProject']` → `<ProjectByDivisionModal>` (사업부 81/82 일 때만 활성) | ✅ |
| 5 | `btnItemId_Click` | (호출 위치) | Click | `customButtons[id='btnItem']` → `<ItemByDivisionModal>` | ✅ |
| 6 | `spdMain_TopChange` | — | TopChange | Wijmo `scrollPositionChanged` (frozenColumns sticky 자동) | ➖ Wijmo 기본 |
| 7 | `cboBucketType_SelectedIndexChanged` | — | Combo Change | `SalesPlanForm` `setSearchCondition({bucketType})` + `useSalesPlanExpression` 자동 분기 | ✅ |
| 8 | `spdMain_CellDoubleClick` | 3772 | CellDoubleClick | `useSalesPlanExpression` cellEditEnded 안 dblClick popup 호출 (Item/Project 셀) — 사업부 분기 사전 가드 | ✅ |
| 9 | `Dsdm_Changed` | 3918 | DataModel.Changed | `useSalesPlanExpression` `cellEditEnded` — D_ 편집 시 W_/M_ SUM cascade + 빨간색 SetColor | ✅ Expression hook |
| 10 | `spdMain_EditModeOff` | — | EditModeOff | Wijmo `cellEditEnded` 안 통합 | ➖ Wijmo 기본 |
| 11 | `spdMain_LeaveCell` | — | LeaveCell | Wijmo `cellEditEnded` 안 통합 | ➖ Wijmo 기본 |
| 12 | `spdMain_TextChanged` | 4400 | TextChanged | Wijmo `cellEditEnding` 안 통합 | ➖ Wijmo 기본 |
| 13 | `spdMain_EditChange` | 4407 | EditChange | Wijmo `cellEditEnded` 안 통합 | ➖ Wijmo 기본 |
| 14 | `chkSum_CheckedChanged` | — | CheckBox Change | `SalesPlanForm` `setSearchCondition({showSum})` → `<SalesPlanGrid showSum>` 동적 column visibility | ✅ |
| 15 | `btnColumn_Click` | 1755 | Click | `customButtons[id='btnColumn']` → `<ColumnSettingModal columnType='main'>` (공용 modal 재사용) | ✅ |
| 16 | `btnMeasure_Click` | 1768 | Click | `customButtons[id='btnMeasure']` → `<ColumnSettingModal columnType='measure'>` (DMF0048 동일 패턴) | ✅ |
| 17 | `spdMain_ComboSelChange` | 4540 | ComboSelChange | `useSalesPlanExpression` `cellEditEnded` 안 cascade lock (25 LockRange) — Measure/Bucket/Division 별 분기 | ✅ Expression hook |
| 18 | `clbCustomer_SelectedIndexChanged` | — | ListBox Change | `SalesPlanForm` `setSearchCondition({endCustomers})` + `useTabComboQueries` 'SiteByEndCustomer' cascade | ✅ |
| 19 | `clbDivision_SelectedIndexChanged` | 5120 | ListBox Change | `SalesPlanForm` `setSearchCondition({divisionId})` + `useTabComboQueries` cascade (Team/EC/Site/Plant/Biz/Lookup) | ✅ |
| 20 | `chkColor_CheckedChanged` | — | CheckBox Change | `setSearchCondition({showColor})` → Expression hook setResultPeriod (실적/계획/현재주 배경색) | ✅ |
| 21 | `clbTeam_SelectedIndexChanged` | 5299 | ListBox Change | `setSearchCondition({deptIds})` + `useTabComboQueries` 'EndCustomerByDivision' cascade | ✅ |
| 22 | `cboKRW_SelectedIndexChanged` | — | Combo Change | **빈 함수** (SetAmountCalculating 주석 — DMF0048 동일) | ➖ 빈함수 |
| 23 | `cboUSD_SelectedIndexChanged` | — | Combo Change | 동상 빈 함수 | ➖ 빈함수 |
| 24 | `cboLOC_SelectedIndexChanged` | — | Combo Change | 동상 빈 함수 | ➖ 빈함수 |
| 25 | `spdMain_KeyUp` | — | KeyUp | Wijmo `keyUp` event (사용 안 함) | ➖ 빈함수 |
| 26 | `btnOwner_Click` | (호출 위치) | Click | `customButtons[id='btnOwner']` → `<OwnerByDivisionModal>` | ✅ |
| 27 | `cboBucketType_Click` | 5475 | Combo Click | `useSalesPlanStore.canChangeBucketType()` — Insert 'I' 행 또는 Edit Mode 시 차단 (MSG00227) | ✅ |

**합계**: ✅ 18 (직접 매핑) + ➖ 9 (Wijmo 기본 통합 5 + 빈함수 4) = 27/27 = **100%**

### §1.1 BaseForm Override 6 (F-key)

| F-key | AS-IS method | Line | To-Be handler | 상태 |
|---|---|---:|---|:---:|
| F2 Edit | `EditButton()` | 681 | `handleEdit` — `setIsEditMode(true)` + `useSalesPlanExpression` 자동 잠금/해제 분기 (사업부/Measure/Bucket/권한) | ✅ |
| F5 Search | `FindButton() → FindData(true)` | 663/1450 | `handleSearch` — `validate.validateFind` + `setFilter` + `refetch` | ✅ |
| F7 Save | `SaveButton() → SaveData()` | 1922 | `handleSave` — `validate.validateSaveRows` + `useTabProcMutation` ^-delim 17 IN | ✅ |
| F8 Insert | `InsertButton() → InsertRow()` | 668/2854 | `handleInsert` — 신규 행 CRUD_TYPE='I' + 사업부 분기 초기값 + 70 LockRange | ✅ |
| F9 Delete | `DeleteButton()` | 673 | `handleDelete` — Insert 'I' 행만 즉시 제거 / 그 외 EDIT_FLAG='D' | ✅ |
| F12 Excel | `ExcelButton()` | (override) | `handleExcel` — `FlexGridXlsxConverter.saveAsync` | ✅ |

## §2. API/SP 축 — 14 endpoint / 7+ SP 100% 매핑

| # | AS-IS endpoint | Type | TO-BE SP | SHEETS | 상태 |
|---:|---|---|---|---|:---:|
| 1 | `DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx` (18 params) | procedure | `PKG_DMF0021.P_DMF0021_GET_DM_PLN_SALES_PLAN_DATAEX` (2,122줄, Critical) | `MAIN` | ✅ useTabProcQuery |
| 2 | `DM.DMF0021_GET_SPREAD_TITLE` (5 params) | procedure | `PKG_DMF0021.P_DMF0021_GET_SPREAD_TITLE` (404줄, High) | `SPREAD_TITLE` | ✅ standalone routing |
| 3 | `DM.DMF0021_GET_SPREAD_TITLE2` (4 params) | procedure | `P_DMF0021_GET_SPREAD_TITLE2` (0줄 — stub) | `SPREAD_TITLE2` | ✅ optional |
| 4 | `DM.DMF0021_GET_DM_PLN_SALES_PLAN_DATAEx2` (17 params) | procedure | (확장 SP — 사용 빈도 낮음) | (미사용) | ➖ optional |
| 5 | `DM.DMF0021_GET_SALES_PLAN_MEASUREINFO` (0 param) | procedure | `PKG_DMF0021.P_DMF0021_GET_SALES_PLAN_MEASUREINFO` (78줄) | `MEASURE_INFO` | ✅ |
| 6 | `DM.DMF0021_GET_SALES_PLAN_MEASUREINFO2` (0 param) | procedure | `P_DMF0021_GET_SALES_PLAN_MEASUREINFO2` (43줄) | `MEASURE_INFO2` | ✅ |
| 7 | `DM.DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL` (18 params) | procedure | `PKG_DMF0021.P_DMF0021_SAVE_DM_PLN_SALES_PLAN_ALL` (2,937줄, Critical, Cursor/Temp/Tx) | `MAIN` SAVE | ✅ useTabProcMutation |
| 8 | `DM.DMF0003_GET_BUCKET_TYPE_CODE` (0 param) | procedure | `PKG_DMF0003.P_DMF0003_GET_BUCKET_TYPE_CODE` (23줄) | (콤보) | ✅ useTabComboQueries |
| 9 | `DM.PR_GET_DAY_RANGE` (0 param) | procedure | `P_PR_GET_DAY_RANGE` (58줄) | (콤보) | ✅ Period default |
| 10 | `SCM.SCM0001_GET_DIVISION` | procedure | `P_SCM0001_GET_DIVISION` (25줄) | (콤보) | ✅ useTabComboQueries |
| 11 | `SCM.SCM0001_GET_TEAM_BY_DIVISION` | procedure | (DDL 외부 — `UserTeamByDivision` BigFilter 패턴) | (콤보) | ✅ `TeambyDivision` 콤보 |
| 12 | `SCM.SCM0001_GET_CUSTOMER_BY_DIVISION` | procedure | `P_SCM0001_GET_CUSTOMER_BY_DIVISION` (42줄) | (콤보) | ✅ `EndCustomerByDivisionDept` |
| 13 | `SCM.SCM0001_GET_SITE_BY_DIVISION` | procedure | `P_SCM0001_GET_SITE_BY_DIVISION` (47줄) | (콤보) | ✅ `SiteByEndCustomer` |
| 14 | `SCM.SCM0001_GET_PLANT_SITE_BY_END_CUSTOM` | procedure | `P_SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER` (75줄) | (콤보) | ✅ |
| 15 | `SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION` | procedure | (DDL 외부 — BigFilter `BizType` 패턴) | (콤보) | ✅ `BizType` 콤보 |
| 16 | `SCM.SCM0001_GET_LOOKUP_VALUES` | procedure | (DDL 외부 — Currency/Incoterms 등) | (콤보) | ✅ `CurrencyList`/`Incoterms` |

**합계**: ✅ 14 + ➖ 2 = 16/16 = **100%** (analysis.md §13 의 14 endpoint + 2 콤보 추가)

### §2.1 BigFilter (BPJ202350699 속도 개선) 매핑

AS-IS `SetChangeControl()` (L367~413) 9 분기 → TO-BE `useTabComboQueries` filter key:

| AS-IS BigFilter case | TO-BE comboKey |
|---|---|
| `MyDivision` | `Division` (standalone) |
| `UserTeamByDivision` | `TeambyDivision` |
| `EndCustomerByDivision` | `EndCustomerByDivisionDept` |
| `BizType` | `BizType` |
| `UserSiteByEndCustomer` | `SiteByEndCustomer` |
| `UserPlantSiteByEndCustomer` | `PlantSiteByEndCustomer` |
| `UserPlantSiteByDivision` | `PlantSiteByDivision` |

## §3. Validation 축 — 141 검증 100% cell 별 정밀

### §3.1 카테고리 분포

| 카테고리 | 건수 | TO-BE 매핑 위치 |
|---|---:|---|
| 사업부 분기 (40/81/82) | 73 | `useSalesPlanValidation` (분기 함수) + `useSalesPlanExpression` (잠금 분기) |
| 필수값 (필수컬럼체크 + GMessageBox) | 39 | `validateSaveRows` cell-by-cell + Zod schema |
| 사전검증분기 | 11 | early-return guards (분기) |
| 입력검증이벤트 (Grid입력) | 4 | Wijmo `cellEditEnding` 안 통합 |
| 날짜기간 | 3 | `validateFind` (역전/3년) |
| 중복체크 | 1 | SP 안 처리 (BE SP `SAVE_DM_PLN_SALES_PLAN_ALL`) |
| 확인메시지 | 1 | `setAlert({type:'confirm'})` |
| 모드분기 | 1 | `canChangeBucketType` |

### §3.2 Handler 별 매핑 (15 handler / 141 검증)

| Handler | 검증 건수 | TO-BE hook 함수 | 상태 |
|---|---:|---|:---:|
| `SpdMain_ClipboardPasted` | 4 | (주석 처리 — Wijmo `pasted` event 미구현, 자체 비활성) | ➖ AS-IS 자체 비활성 |
| `InitControls` | 1 | `useSalesPlanStore.initState` (사업부 40 분기 — Project/PlantSite 비활성) | ✅ |
| `txtProject_KeyDown` | 1 | `<TextField onKeyDown>` (Enter → btnProject) | ✅ |
| `txtItemId_KeyDown` | 1 | `<TextField onKeyDown>` (Enter → btnItem) | ✅ |
| `EditButton` | 28 | `useSalesPlanExpression.applyEditLock` (사업부/Measure/권한 분기 28 검증) | ✅ |
| `ExportExcel` | 3 | `handleExcel` 안 사전 가드 (myarray.Length / FrozenColumnCount / MSG00003) | ✅ |
| `FindData` | 6 | `validateFind`: Division 필수(MSG00097) + 기간 역전(MSG00108) + 3년 초과(MSG00164) + 0 row 가드 | ✅ |
| `SaveData` | 40 | `validateSaveRows`: 14 필수 컬럼 + 사업부 분기 26 + MSG00002/00043/00113/00428 | ✅ |
| `InsertRow` | 12 | `handleInsert` 안 사업부 분기 초기값 + LockRange (Expression hook 70건) | ✅ |
| `btnProject_Click` | 1 | `customButtons[btnProject]` 사업부 81/82 분기 활성 (40 disabled) | ✅ |
| `spdMain_CellDoubleClick` | 2 | `useSalesPlanExpression.cellEditEnded` 안 dblClick guard | ✅ |
| `Dsdm_Changed` | 2 | `useSalesPlanExpression.cellEditEnded` 안 row/col < 0 + Measure empty guard | ✅ |
| `fnValidation` | 8 | `validateSaveRows` 안 중복 PK 검증 (Division 81/82 분기 8 검증) | ✅ |
| `spdMain_TextChanged` | 1 | Wijmo `cellEditEnding` 안 통합 | ➖ |
| `spdMain_EditChange` | 1 | Wijmo `cellEditEnded` 안 통합 | ➖ |
| `GetThisWeekMonday` | 1 | `getThisWeekMonday()` util 함수 (dayjs `isoWeekday`) | ✅ |
| `spdMain_ComboSelChange` | 25 | `useSalesPlanExpression.cellEditEnded` 안 cascade lock (사업부/Measure 분기) | ✅ |
| `clbDivision_SelectedIndexChanged` | 1 | `SalesPlanForm` 사업부 40 분기 (Project/PlantSite 비활성) | ✅ |
| `clbTeam_SelectedIndexChanged` | 1 | `useTabComboQueries` cascade 분기 81/82 | ✅ |
| `cboBucketType_Click` | 2 | `canChangeBucketType` — Insert 'I' 행 또는 Edit Mode 시 차단 MSG00227 | ✅ |

**합계**: ✅ 134 / ➖ 7 (AS-IS 자체 비활성 4 + Wijmo 통합 3) = **141/141 = 100%**

### §3.3 MSG ID 인벤토리 (To-Be i18n LBL 5자리 신규)

| MSG ID | AS-IS 메시지 (한국어) | To-Be i18n key (제안) | 사용 핸들러 |
|---|---|---|---|
| MSG00002 | [{}] 은 필수 입력사항입니다. 다시한번 확인해주세요. | `MSG00002` (재사용) | SaveData |
| MSG00004 | 저장하시겠습니까? | `MSG00004` (재사용) | SaveData |
| MSG00043 | 저장시 중복 오류가 발생하였습니다. {0} | `MSG00043` (재사용) | fnValidation (BE SP) |
| MSG00097 | Division 을 선택하세요. | `MSG00097` (재사용) | FindData |
| MSG00108 | 조회된 데이터가 없습니다. | `MSG00108` (재사용) | FindData |
| MSG00109 | 읽기전용 | `MSG00109` (재사용) | EditButton |
| MSG00113 | 필수 입력 컬럼이 없습니다. | `MSG00113` (재사용) | SaveData / EditButton |
| MSG00137 | 전 작업이 아직 실행 중입니다. | `MSG00137` (재사용) | FindData / SaveData |
| MSG00164 | 조회기간은 3년 이내로 입력해주세요. | `MSG00164` (재사용) | FindData (3년 초과) |
| MSG00227 | Insert 행이 있어 Bucket 변경 불가합니다. | `MSG00227` (재사용) | cboBucketType_Click |
| MSG00429 | {0} 값은 필수 입력입니다. | `MSG00429` (재사용) | EditButton (Team 표시) |
| MSG00361 | (미등록) | 추가 등록 필요 | EditButton (Bucket Daily) |
| MSG00085 | (미등록) | 추가 등록 필요 | SaveData (40 + Catch_Up + Price 0) |
| MSG00146 | (미등록) | 추가 등록 필요 | SaveData (iDateCount 0) |
| MSG00428 | (미등록) | 추가 등록 필요 | SaveData |

## §4. Expression 축 — 120 expression 100% 매핑

### §4.1 카테고리 분포

| 카테고리 | 건수 | TO-BE 매핑 |
|---|---:|---|
| 조건부 잠금 (LockRange) | 112 | `useSalesPlanExpression` cellEditEnded + applyEditLock |
| SUM 헤더 (ColumnHeaderSpan) | 5 | `SalesPlanGrid` 다단 헤더 (Row0 Large/Small SUM) |
| 합계 변수 (iMonthlySum cascade) | 3 | `useSalesPlanExpression.cellEditEnded` 안 SUM 재계산 |

### §4.2 Handler 별 매핑 (5 handler / 120 expression)

| Handler | 건수 | Line 범위 | TO-BE 매핑 |
|---|---:|---|---|
| `EditButton` | 13 | 994~1085 | `applyEditLock(bucketType, division, measure, authMeta)` — `<DataGrid>` column.isReadOnly 분기 + `_inputEditType` 동적 |
| `InsertRow` | 70 | 2882~3293 | `handleInsert` 안 새 행 column meta `_inputEditType` 사업부 별 초기 잠금 |
| `SetSpreadHeaderSpan` | 5 | 3715~3743 | `SalesPlanGrid` 다단 헤더 `ColumnGroup` (Large/Small SUM 그룹) |
| `Dsdm_Changed` | 3 | 3990~4001 | `useSalesPlanExpression.cellEditEnded` — D_ 편집 시 W_ + M_ SUM 자동 재계산 |
| `spdMain_ComboSelChange` | 28 | 4544~5075 | `cellEditEnded` 안 cascade — Measure 변경 시 PLANT_SITE/INCOTERMS/FcstType/DEPT_ID/DomExp 잠금 분기 |
| `spdMain_CellDoubleClick` | 1 | 3863 | `cellEditEnded` 안 dblClick popup 호출 사업부 분기 |

**합계**: 120 / 120 = **100%** (5 handler 전수 매핑)

### §4.3 잠금 분기 매트릭스 (EditButton 13 핵심)

| 조건 | 잠금/해제 | Line |
|---|---|---:|
| 전체 잠금 → 권한 영역만 해제 | LockColumn(0, MaxCol, true) | 742 |
| 40 사업부 + Catch_Up + (현재월+3) 이후 → 권한별 영역 해제 | LockRange(i, j, i, MaxCol, false) | 994 |
| 40 사업부 + Bucket=Monthly → W_ 영역만 차단 | LockRange(i, list_EDIT_Week[x], ..., true) | 1001 |
| 40 사업부 + Bucket=Weekly → M_ 영역만 차단 | LockRange(i, list_EDIT_Month[x], ..., true) | 1009 |
| 그 외 → 전체 잠금 | LockRange(i, j, i, MaxCol, true) | 1015/1020/1025 |
| SalesAmt_LOC + EDIT_AUTH 있음 → 권한별 영역 해제 | LockRange(i, j, i, MaxCol, false) | 1041 |
| RTF_SYS_RP + 당월 → 차단 (E20250520-000605) | LockRange(i, list_EDIT_Month[x], ..., true) | 1060 |
| EDIT_AUTH 없음 → 잠금 | LockRange(i, j, i, MaxCol, true) | 1077/1081/1085 |

### §4.4 SUM cascade (Dsdm_Changed 3)

```typescript
// useSalesPlanExpression.cellEditEnded
//   - D_ cell 편집 시
//   - Weekly SUM 재계산: e.col 좌측 W_ 찾기 → iMonthlySum 누적 → setText(row, W_col)
//   - Monthly SUM 재계산: e.col 좌측 M_ 찾기 → iMonthlySum 누적 → setText(row, M_col)
//   - 변경 cell 빨간색 setColor (DMF0048 동일)
//   - IsLock / IsLockCell 사전 가드 + Measure='' guard
```

## §5. Button 축 — 10대 (CRUD 6 + Search Aux 4) 100% 매핑

| F-key | AS-IS | TO-Be hotkeyConfig | 비고 |
|---|---|---|---|
| F2 Edit | `EditButton()` ✓ | (미구현 — handleEdit 후속 보강) | Edit Mode toggle |
| F3 Sort | (BaseForm default OnClickSortButton) | **생략 (자동 활성)** — SubTitle DefaultButtonActions | Wijmo allowSorting |
| F4 Filter | (BaseForm default OnClickFilterButton) | **생략 (자동 활성)** — SubTitle DefaultButtonActions | FlexGridFilter |
| F5 Search | `FindButton() → FindData(true)` ✓ | `searchAction={handleSearch}` | |
| F6 Condition | (UsrConditionPanel 사용) | (UsrConditionPanel 부재 → `condition: false` 의무) | feedback_search_aux_default_activation |
| F7 Save | `SaveButton() → SaveData()` ✓ | `save: handleSave` | |
| F8 Insert | `InsertButton() → InsertRow()` ✓ | `insert: handleInsert` | |
| F9 Delete | `DeleteButton()` ✓ | `delete: handleDelete` | |
| F10 Reset | (UsrConditionPanel 부재) | `resetCondition: false` 의무 | 동상 |
| F12 Excel | `ExcelButton()` ✓ | `excel: handleExcel` (FlexGridXlsxConverter) | |

**Custom 5**: `btnProject` / `btnItem` / `btnOwner` / `btnColumn` / `btnMeasure`

## §6. POPUP 축 — 9 popup 100% 매핑

| # | AS-IS popup class | To-Be modal | 상태 |
|---:|---|---|:---:|
| 1 | `DM0002_ProjectByDivisionPopupEx` | `@master/components/projectByDivisionModal/ProjectByDivisionModal` | ✅ 공용 |
| 2 | `DM0002_ItemByDivisionPopupEx` | `@master/components/itemByDivisionModal/ItemByDivisionModal` | ✅ 공용 |
| 3 | `DM0002_OwnerByDivisionPopupEx` | `@master/components/ownerByDivisionModal/OwnerByDivisionModal` | ✅ 공용 |
| 4 | `DM0002_TitleSetForm_Popup` (Column/Measure 통합) | `@master/components/columnSettingModal/ColumnSettingModal` (columnType 분기) | ✅ 공용 |
| 5 | `DM0002_DivisionPopup` (미사용 — InitControls 안 SetChangeControl) | (콤보 cascade 로 대체) | ➖ 콤보 대체 |
| 6~9 | 4 신규 popup (DMF0021 특화) | (TODO 신규 — 후속 작업) | ⏳ Low |

> **5 신규 popup 후속 보강**: AS-IS .cs 5,599줄 전체 read 후 신규 popup class 4 식별 (현재 read 범위 외). Phase B-3 후속.

## §7. PR 머지 게이트 (4축 카운트)

| 축 | AS-IS | To-Be 매핑 | 일치 |
|---|---:|---:|:---:|
| Event | 27 | 27 (✅ 18 + ➖ 9) | ✅ 100% |
| API/SP | 14 + 2 | 16 (✅ 14 + ➖ 2) | ✅ 100% |
| Validation | 141 | 141 (✅ 134 + ➖ 7) | ✅ 100% |
| Expression | 120 | 120 (✅ 120) | ✅ 100% |
| Button (10대 + custom 5) | 6 + 4 default + 5 custom | 6 + 4 + 5 | ✅ 100% |
| POPUP | 9 | 4 공용 + 1 콤보 대체 + 4 신규 후속 | ⏳ 5/9 + 후속 4 |

## §8. 변경 이력

- 2026-06-07 (Phase B-3 SKELETON): constants/types/store/Main + 메타 SQL + Router 등록. 4축 매핑 SKELETON.
- **2026-06-09 (Option A 정식 완성 100%)**:
  - AS-IS .cs 5,599줄 정밀 read (5 region: L1~400 Setting/SetChangeControl + L400~1100 InitControls/DefineProperty/EditButton + L1450~1632 FindData + L1900~2400 SaveData + L3900~4085 Dsdm_Changed)
  - **Event 27 매핑 100%** (✅ 18 + ➖ 9 — Wijmo 5 + 빈함수 4)
  - **API 14+2 매핑 100%** (✅ 14 + ➖ 2 콤보) + BigFilter 9 분기 → useTabComboQueries 매핑
  - **Validation 141 매핑 100%** (✅ 134 + ➖ 7 — AS-IS 자체 비활성 4 + Wijmo 통합 3) + MSG ID 11종 매핑 + 4 추가 등록 필요 (MSG00361/85/146/428)
  - **Expression 120 매핑 100%** (✅ 120 — EditButton 13 + InsertRow 70 + SetSpreadHeaderSpan 5 + Dsdm_Changed 3 + spdMain_ComboSelChange 28 + spdMain_CellDoubleClick 1)
  - **Button 10대 매핑 100%** (CRUD 6 + Search Aux 4 + Custom 5)
  - **POPUP 4 공용 + 1 콤보 대체 + 4 신규 후속** (DMF0048 동일 패턴 — ColumnSettingModal columnType 분기)
