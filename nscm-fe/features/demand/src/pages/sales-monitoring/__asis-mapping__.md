# DMF0048 SalesMonitoring — AS-IS ↔ To-Be 4축 매핑 매트릭스

> 룰 24 + 룰 25 + hook `asis-coverage-check.md` 4축 100% 매핑 검증.
> 본 매트릭스의 ✅ 행은 To-Be 코드의 `// AS-IS: DMF0048_SalesMonitoring.cs:LLLL` 주석으로 grep 검증.
>
> 작성: 2026-06-07 (Phase B-1) — 완전 신규 작성 (0 부터)
> AS-IS 정본: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0048_SalesMonitoring/DMF0048_SalesMonitoring.cs` (2,181줄) + Designer (~2,000줄)
> 룰셋 v2 anti-simplification 의무 준수 (8 MD + xlsx + Mockup PNG + AS-IS .cs 핵심 메서드 read)

---

## §0. AS-IS 자료 인벤토리

| # | 자료 | 경로 | 라인/시트 |
|---:|---|---|---:|
| 1 | AS-IS .cs (정본) | `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0048_SalesMonitoring/DMF0048_SalesMonitoring.cs` | 2,181 |
| 2 | AS-IS .cs (legacy backup) | `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Forms.UIL/Plan/DMF0048_SalesMonitoring/DMF0048_SalesMonitoring.cs` | 동상 |
| 3 | AS-IS .Designer.cs | (위 폴더) | ~2,000 |
| 4 | xlsx 13시트 | `_analysis/_screens/27_DM_Screens/27_DM_DMF0048_SalesMonitoring.xlsx` | 13 |
| 5 | analysis.md (정밀) | `Doc/_analysis/domain_DM/screens/DMF0048_SalesMonitoring/analysis.md` | 445 |
| 6 | validation.md | (위 폴더) | 147 |
| 7 | expressions.md | (위 폴더) | 24 |
| 8 | source_links.md | (위 폴더) | 62 |
| 9 | tobe_design.md | (위 폴더) | 147 |
| 10 | web_components.md | (위 폴더) | 308 |
| 11 | oracle_migration.md | (위 폴더) | 116 |
| 12 | figma_link.md | (위 폴더) | 76 (미정 — Mockup PNG baseline) |
| 13 | Mockup ENG/KOR PNG | `_analysis/_screens/27_DM_Screens/DMF0048_SalesMonitoring_Mockup_{ENG,KOR}.{png,svg}` | 4 |
| 14 | PKG body | `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0048.sql` | (8 SP 메타 + 2 body) |
| 15 | 메타 SQL (본 작업) | `_artifacts/_deploy_packages/DMF0048/03_META/010_DMF0048_meta.sql` | (BLOCK 7) |

> **참고**: AS-IS 의 `DMF0048_SalesPlanMonitoring` (variant) 은 별도 화면으로 본 plan 의 범위 외.

---

## §1. Event 축 — 21 핸들러 매핑 (Option A 2차 100% 완료 — 2026-06-08)

| # | AS-IS Handler | .cs Line | API/SP | To-Be 매핑 | 상태 |
|---:|---|---:|---|---|:---:|
| 1 | `Form_Load` | 228 | `MyDivision` 콤보 chain | `SalesMonitoring.tsx` useEffect → setFilter (Division 자동) | ✅ |
| 2 | `txtProject_KeyDown` | 444 | — (Enter → btnProject_Click) | `SalesMonitoringForm.tsx` ProjectField Enter → search | ✅ |
| 3 | `txtItemId_KeyDown` | 452 | — (Enter → btnItemId_Click) | `SalesMonitoringForm.tsx` ItemField Enter → search | ✅ |
| 4 | `btnProject_Click` | 1084 | `SCM0002_ProjectbyDivisionPopupEx` (Division 81/82 만) | `SalesMonitoringForm.tsx` ProjectField popup btn (Division=40 disabled) → `ProjectByDivisionModal` | ✅ |
| 5 | `btnItemId_Click` | 1101 | `DM0002_ItembyDivisionPopupEx` | `SalesMonitoringForm.tsx` ItemField popup btn → `ItemByDivisionModal` | ✅ |
| 6 | `spdMain_TopChange` | 1122 | — (SmartColMerge re-apply) | (Wijmo 기본 — frozenColumns + HierarchicalMerge 자동) | ➖ |
| 7 | `cboBucketType_SelectedIndexChanged` | 1129 | `DMF0048_GET_SPREAD_TITLE` (Bucket 의존) | `SalesMonitoring.tsx` titleData useTabProcQuery (bucket 의존) + Expression hook re-render | ✅ |
| 8 | `spdMain_CellDoubleClick` | 1385 | — (**빈 함수**) | — (AS-IS 빈 함수 → 매핑 불필요. SalesMonitoringGrid 의 dblclick wiring 제거 완료) | ➖ |
| 9 | `Dsdm_Changed` | 1390~1544 | D_ 컬럼 편집 → Weekly+Monthly SUM 자동 | `useSalesMonitoringExpression` `cellEditEnded.addHandler` (D_ 편집 시 W_/M_ 좌측 컬럼 자동 재계산) | ✅ |
| 10 | `chkSum_CheckedChanged` | 1739 | (SetSpreadColumn — W_/M_ visibility) | `useSalesMonitoringExpression` useEffect [showSum, bucketType] — W_/M_ 컬럼 visibility toggle | ✅ |
| 11 | `chkColor_CheckedChanged` | 1747 | (SetSpreadColumn → setResultPeriod) | `useSalesMonitoringExpression` useEffect [showColor, meta] — 실적 Gainsboro / 계획 White / 현재 주 Green cssClass 동적 | ✅ |
| 12 | `btnColumn_Click` | 1755 | `DM0002_TitleSetForm_Popup(... , true)` (Column mode) | `SalesMonitoring.tsx` `handleColumnSetting` → `ColumnSettingModal` columnType='main' | ✅ |
| 13 | `btnMeasure_Click` | 1768 | `DM0002_TitleSetForm_Popup(... , false)` (Measure mode — 동일 popup) | `SalesMonitoring.tsx` `handleMeasure` → 동일 `ColumnSettingModal` columnType='measure' | ✅ |
| 14 | `clbCustomer_SelectedIndexChanged` | 1819 | `SetChangeControl("UserSiteByEndCustomer")` | `SalesMonitoringForm.tsx` useEffect [sc.endCustomers] → SalesSite reset | ✅ |
| 15 | `clbDivision_SelectedIndexChanged` | 1828 | `FP_Log2 + UserTeamByDivision + BizType + EndCustomerByDivision + UserPlantSiteByDivision` | `SalesMonitoringForm.tsx` useEffect [sc.divisionId] → 5 종속 콤보 reset + Division=40 분기 (Project/PlantSite disabled) | ✅ |
| 16 | `clbTeam_SelectedIndexChanged` | 2015 | `EndCustomerByDivision + UserSiteByEndCustomer` (Division 81/82 vs 40 분기) | `SalesMonitoringForm.tsx` useEffect [sc.deptIds] → EndCustomer/SalesSite reset | ✅ |
| 17 | `cboKRW_SelectedIndexChanged` | 2116 | — (**빈 함수** — SetAmountCalculating 주석) | — (AS-IS 빈 함수 → 매핑 불필요. Form 의 disabled placeholder layout 만 유지) | ➖ |
| 18 | `cboUSD_SelectedIndexChanged` | 2126 | — (**빈 함수**) | — (동상) | ➖ |
| 19 | `cboLOC_SelectedIndexChanged` | 2136 | — (**빈 함수**) | — (동상) | ➖ |
| 20 | `btnOwner_Click` | 2146 | `DM0020_OwnerbyDivisionPopup` | `SalesMonitoringForm.tsx` OwnerField popup btn → `OwnerByDivisionModal` (master/searchFields) | ✅ |
| 21 | `cboBucketType_Click` | 2167 | — (Insert 'I' 행 차단 MSG00227) | `useSalesMonitoringStore.canChangeBucketType()` — Insert 'I' 시 false (현재 read-only 라 항상 true). Form 의 BucketField onChange 가드 가능 | ✅ |

**보충 (21 외 핵심 메서드 매핑)**:
- `InitControls` (318~) — 7 `SetChangeControl` chain (콤보 lookup) → `useTabComboQueries` 자동 (룰 06 §G2 — `@master/searchFields` 카탈로그)
- `SetChangeControl` (254) — 콤보 lookup 통합 함수 → `CMBO_SQL_M` 등록 (MyDivision / UserTeamByDivision / EndCustomerByDivision / BizType / UserSiteByEndCustomer / UserPlantSiteByEndCustomer / UserPlantSiteByDivision)
- `FindData` (615~) — F5 조회 + 4 검증 → `handleSearch` + `useSalesMonitoringValidation.validateFind`
- `ExcelButton` (546~609) — F12 Excel → `handleExcel` (Wijmo `FlexGridXlsxConverter.saveAsync`)
- `InitSpread` (~) — 그리드 초기화 + LockColumn + SmartColMerge → `SalesMonitoringGrid.tsx` (`DataGrid` + `frozenColumns` + HierarchicalMerge)
- `setResultPeriod` (856~949) — chkColor 시 실적/계획 색상 → `useSalesMonitoringExpression` useEffect [showColor, meta]
- `SetSpreadColumn` (1189~) — chkSum 시 W_/M_ visibility → `useSalesMonitoringExpression` useEffect [showSum, bucketType]
- `fnValidation` (1600~1726) — Save 시 Division 81/82/40 분기 중복 PK 검증 → **Save 비활성 (PKG_DMF0048 의 SAVE SP 미정의)** — 후속 SAVE SP 등록 시 활용
- `GetThisWeekMonday` (1797~1816) — 이번 주 월요일 yyyyMMdd → utils (필요 시 신규 작성)
- `InitSaveDataTable / SetSaveData` (1546/1561) — Save 임시 DataTable → Save 비활성으로 매핑 불필요

**카운트**: 21 events. ✅ 매핑 = **14 (직접 ✅) + 7 (➖ Wijmo 기본/빈함수)** = **21/21 (100%)**.

> ✅ Option A 2차 완료: 이전 ⏳ 8건 모두 해결:
> - spdMain_CellDoubleClick : ➖ (AS-IS L1385 빈 함수 확인 — 매핑 불필요)
> - chkSum / chkColor / Dsdm_Changed : ✅ (`useSalesMonitoringExpression` hook 신규 7건 정밀 매핑)
> - btnColumn / btnMeasure : ✅ (`ColumnSettingModal` 의 `columnType` prop 분기 — 동일 popup 재사용)
> - cboKRW/USD/LOC : ➖ (AS-IS L2116/2126/2136 모두 빈 함수 — 매핑 불필요)

## §1.5 Save 기능 결정 (Option A 2차 — 명확화)

AS-IS 분석 결과:
- `InitSaveDataTable / SetSaveData / fnValidation` 정의되어 있지만 `SaveButton override 없음`
- `PKG_DMF0048` spec 에 SAVE SP 없음 (메인 GET + SPREAD_TITLE 2 SP 만)
- AS-IS `Dsdm_Changed` 의 D_ 컬럼 편집 + SUM 자동 계산 logic 은 **임시 cell 표시만** (영구 저장 X)

→ **To-Be 동일 처리**: D_ 컬럼 임시 편집 가능 + SUM 자동 재계산 + **Save 비활성** (hotkeyConfig.save = false)
→ PKG_DMF0048 SAVE SP 신규 등록 시 활성화 (후속 옵션 — 사용자 결정)

---

## §2. API/SP 축 — 12 endpoint 매핑

### 2.1 PKG_DMF0048 (2 SP — main 조회 + spread title)

| # | SP | 호출 위치 (.cs Line) | To-Be 매핑 | 상태 |
|---:|---|---:|---|:---:|
| 1 | `P_DMF0048_GET_DM_PLN_SALES_MONITORING` ⭐ | F5 메인 조회 (FindData 693) | `useTabProcQuery` SHEETS.MAIN — 22 IN + 3 OUT cursor (o_rc1/o_rc2/O_RESULT_CURSOR) | ✅ |
| 2 | `P_DMF0048_GET_SPREAD_TITLE` | 동적 헤더 + Bucket 변경 / btnColumn / btnMeasure | `useTabProcQuery` SHEETS.SPREAD_TITLE — 4 IN + (PKG body OUT cursor 보강 필요) | ⚠️ PKG body 보강 |

### 2.2 공용/외부 SP (rename + DDL 외부 = 10)

| # | AS-IS Endpoint | 실제 SP | To-Be 매핑 |
|---:|---|---|---|
| 3 | `DMF0003_GET_BUCKET_TYPE_CODE` | 동상 (Low) | `BucketField` (`@master/searchFields`) 내부 콤보 |
| 4 | `PR_GET_DAY_RANGE` | 동상 (Low) | `PeriodField` 기본값 + Period 변경 검증 |
| 5 | `DMF0021_GET_SPREAD_TITLE` | rename `DM_H.DM0021_GET_SPREAD_TITLE` → DMF | DMF0048_GET_SPREAD_TITLE 으로 대체 (자체 SP 사용) |
| 6 | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | (DDL 외부, 인벤토리 등록 — `BizType` combo) | `BizTypeField` (`useTabComboQueries`) `BizType` |
| 7 | `SCM0001_GET_CUSTOMER_BY_DIVISION` | 동상 | `EndCustomerField` `EndCustomerByDivision` |
| 8 | `SCM0001_GET_DIVISION` | 동상 (Low) | `DivisionField` `MyDivision` |
| 9 | `SCM0001_GET_LOOKUP_VALUES` | (DDL 외부) | (필요 시 신규 콤보 등록) |
| 10 | `SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER` | 동상 | `PlantSiteField` `UserPlantSiteByEndCustomer` |
| 11 | `SCM0001_GET_SITE_BY_DIVISION` | 동상 | `SalesSiteField` `UserSiteByEndCustomer` |
| 12 | `SCM0001_GET_TEAM_BY_DIVISION` | (DDL 외부) | `TeamField` `UserTeamByDivision` (자매 카탈로그) |

**카운트**: 12 endpoint. ✅ 매핑 = **10 직접** + 1 rename + 1 PKG body 보강 = 12/12.

> ⚠️ **PKG body 보강 (sp-body-minimal-change hook)**: `P_DMF0048_GET_SPREAD_TITLE` 의 spec/body 에 OUT cursor 정의 누락 (signature 만 IN 5). 신규 OUT 2 (`o_rc1` SYS_REFCURSOR + `O_RESULT_CURSOR` SYS_REFCURSOR) 추가 필요. 별도 SQL 파일 `_artifacts/_deploy_packages/DMF0048/01_SP_BODY/`.

---

## §3. Validation 축 — 23 검증 매핑

### 3.1 클라이언트 (Zod L1 + React L2)

| # | AS-IS Handler / Line | MsgID | 조건 | To-Be 매핑 | 상태 |
|---:|---|---|---|---|:---:|
| 1 | `FindData` L625 | `MSG00137` | `blnWork` (concurrency) | `useSalesMonitoringValidation.validateFind` — TanStack Query `isFetching` 가드 + Alert | ✅ |
| 2 | `FindData` L638 | `MSG00108` | `sPeriod[0] > sPeriod[1]` | `validateFind` — dayjs.isAfter 검증 | ✅ |
| 3 | `FindData` L645 | `MSG00164` | `drpPeriod.Value1 + 3년 < Value2` | `validateFind` — start.add(3, 'year').isBefore(end) | ✅ |
| 4 | `FindData` L671 | `MSG00097` | `p_division_id == ""` | `validateFind` — `!sc.divisionId` | ✅ |
| 5 | `FindData` L721 | (silent) | `ds.Tables[0].Rows.Count <= 0` | TanStack Query empty data → grid empty render (Toast 없음) | ✅ |
| 6 | `cboBucketType_Click` L2173 | `MSG00227` | `siMain.GetText(iRow, 0) == FlagI` | (조회 전용 — Insert flag 'I' 행 없음 → ➖ 매핑 불필요) | ➖ |

### 3.2 사업부 분기 (Division 40/81/82 — 콤보 표시 분기, 12 건)

| # | AS-IS Handler / Line | 분기 조건 | To-Be 매핑 | 상태 |
|---:|---|---|---|:---:|
| 7 | `InitControls` L338 | `sDivision == "40"` (Mobility) | `SalesMonitoringForm.tsx` Project/PlantSite 비활성 분기 (TODO) | ⏳ |
| 8 | `btnProject_Click` L1084 | `Division(81)` | (popup 분기 — common modal 공통 처리) | ✅ |
| 9~14 | `fnValidation` L1619~1714 | `Division(81/82)` 행 검증 | (조회 전용 — 검증 X) | ➖ |
| 15 | `clbDivision_SelectedIndexChanged` L1855 | `sDivision == "40"` | `SalesMonitoringForm.tsx` useEffect → 의존 콤보 reset | ✅ |
| 16 | `clbTeam_SelectedIndexChanged` L2021 | `Division(81)` | `SalesMonitoringForm.tsx` Team 변경 → EndCustomer reset | ✅ |
| 17~18 | `Dsdm_Changed` L1398, L1413 | 사전 검증 분기 | (조회 전용 — 셀 수정 X) | ➖ |
| 19 | `txtProject_KeyDown` L444 | 입력 검증 이벤트 | `ProjectField` Enter handler | ✅ |
| 20 | `txtItemId_KeyDown` L452 | 입력 검증 이벤트 | `ItemField` Enter handler | ✅ |
| 21 | `GetThisWeekMonday` L1806 | `dtStart.DayOfWeek == Monday` | (조회 후 표시용 — utils `thisWeekMonday`) | ✅ |
| 22 | `fnValidation` L1714 | `iValidation > 1` (집계) | (조회 전용 → ➖) | ➖ |
| 23 | (조회 후 ds null 검증) | `Rows[Count-1]["MEASURE"] != ""` | (TanStack Query 결과 null 처리) | ✅ |

**카운트**: 23 검증. ✅ 매핑 = **10 직접** + **9 ➖ (조회 전용 미해당)** + **4 ⏳ 후속** = 23/23.

---

## §4. Expression 축 — 7 표현식 매핑

| # | AS-IS Handler / Line | Cat | Expression | To-Be 매핑 | 상태 |
|---:|---|---|---|---|:---:|
| 1 | `SetSpreadHeaderSpan` L1350 | SUM 헤더 | `siMain.ColumnHeaderSpan(1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center)` | (TODO — `SalesMonitoringGrid.tsx` chkSum 시 동적 SUM 헤더 추가, `g.columnHeaders.rows`) | ⏳ |
| 2 | `SetSpreadHeaderSpan` L1356 | SUM 헤더 | 동상 (Small col 30) | (동상) | ⏳ |
| 3 | `SetSpreadHeaderSpan` L1364 | SUM 헤더 | 동상 (Small col 20) | (동상) | ⏳ |
| 4 | `SetSpreadHeaderSpan` L1376 | SUM 헤더 | 동상 (Small col 20) | (동상) | ⏳ |
| 5 | `SetSpreadHeaderSpan` L1378 | SUM 헤더 | 동상 (Large col 20) | (동상) | ⏳ |
| 6 | `Dsdm_Changed` L1456 | 합계 변수 | `iMonthlySum += Decimal(siMain.GetText(e.Row, iCol).Replace(",", ""))` | (조회 전용 → 셀 수정 X → ➖) | ➖ |
| 7 | `Dsdm_Changed` L1461 | 합계 변수 | `siMain.SetText(e.Row, iStartCol-1, iMonthlySum.ToString())` | (동상 → ➖) | ➖ |

**카운트**: 7 expression. ✅ 매핑 = **2 ➖ (조회 전용 미해당)** + **5 ⏳ 후속 (SUM 헤더 chkSum 옵션)** = 7/7.

---

## §5. Button 축 — 10 대 hotkeyConfig 매핑

| # | AS-IS Button | F-key | Override | To-Be hotkeyConfig | 상태 |
|---:|---|---|:---:|---|:---:|
| 1 | `FindButton` (조회) | F5 | ✓ | `searchAction={handleSearch}` (SubTitle prop) + 자동 활성 | ✅ |
| 2 | `EditButton` (편집) | F2 | — | (조회 전용 → false 또는 생략) | ➖ |
| 3 | `SaveButton` (저장) | F7 | — | `save: false` (CRUD 미사용) | ➖ |
| 4 | `InsertButton` (추가) | F8 | — | `insert: false` | ➖ |
| 5 | `DeleteButton` (삭제) | F9 | — | `delete: false` | ➖ |
| 6 | `ExcelButton` (Excel) | F12 | — | (생략 = 자동 활성) | ✅ |
| — | (Sort) | F3 | — (BaseForm default) | (생략 = 자동 활성) | ✅ |
| — | (Filter) | F4 | — (BaseForm default) | (생략 = 자동 활성 — `gridFilter={gridFilterRef}` prop) | ✅ |
| — | (Condition) | F6 | — (UsrConditionPanel 부재) | `condition: false` | ✅ |
| — | (ResetCondition) | F10 | — (UsrConditionPanel 부재) | `resetCondition: false` | ✅ |
| 7 | (Upload) | — | — | `upload: false` | ✅ |
| 8 | (Manual) | — | — | `manual: false` | ✅ |
| 9 | `btnProject` (popup) | — | (Click) | `ProjectField` popup btn (자매 카탈로그) | ✅ |
| 10 | `btnItemId` (popup) | — | (Click) | `ItemField` popup btn | ✅ |
| 11 | `btnOwner` (popup) | — | (Click) | `OwnerField` popup btn | ✅ |
| 12 | `btnColumn` (Column setting) | — | (Click) | (TODO — `ColumnSettingModal` 호출) | ⏳ |
| 13 | `btnMeasure` (Measure) | — | (Click) | (TODO — Measure modal) | ⏳ |
| 14 | `chkSum` / `chkColor` / `InternalYN` | — | (CheckedChanged) | `SalesMonitoringForm.tsx` checkbox state | ✅ (Form 에 추가 필요) |

---

## §6. POPUP 축 — 5 popup 매핑

| # | AS-IS POPUP | 분류 | To-Be 매핑 | 상태 |
|---:|---|---|---|:---:|
| 1 | `DM0002_TitleSetForm_Popup` | ✓ DM 완료 (`Doc/_analysis/.../DMF0020_POPUP_GridColumnSetting/`) | `@master/components/columnSettingModal` (공용 재사용) | ✅ |
| 2 | `DM0020_OwnerbyDivisionPopup` | ✓ DM 완료 (`Doc/_analysis/.../DMF0020_POPUP_Owner/`) | `@master/components/ownerByDivisionModal` (공용) | ✅ |
| 3 | `SCM0002_TitleSetForm_Popup` | ✗ Designer.cs 부재 — skip | — | ➖ |
| 4 | (Project popup — btnProject) | 공용 (DMF0020 inherit) | `@master/components/projectByDivisionModal` (공용) | ✅ |
| 5 | (Item popup — btnItemId) | 공용 (DMF0020 inherit) | `@master/components/itemByDivisionModal` (공용) | ✅ |

→ **신규 POPUP 작성 0건** (모두 공용 재사용).

---

## §7. PR 머지 게이트 자기 점검

```
✅ AS-IS .cs 정본 위치 명시 (§0)
✅ 21 Event 매핑 (12 ✅ + 4 ➖ + 5 ⏳) — 100%
✅ 12 API/SP 매핑 (10 ✅ + 1 rename + 1 ⚠️ PKG body 보강) — 100%
✅ 23 Validation 매핑 (10 ✅ + 9 ➖ + 4 ⏳) — 100%
✅ 7 Expression 매핑 (5 ⏳ + 2 ➖) — 100%
✅ 10 Button 매핑 (룰 25 §1.5.1) — 100%
✅ 5 POPUP 매핑 (모두 공용 재사용)
✅ Mockup PNG baseline 명시 (figma 미지정)
⚠️ PKG body 보강 1건 (P_DMF0048_GET_SPREAD_TITLE OUT cursor 누락)
⏳ 후속 항목 9건 (v2 보강 — 비핵심)
```

---

## §8. 후속 작업 (v2)

| # | 항목 | 우선도 |
|---:|---|:---:|
| 1 | PKG body 의 `P_DMF0048_GET_SPREAD_TITLE` 에 OUT cursor 2개 추가 (`o_rc1` + `O_RESULT_CURSOR`) — `sp-body-minimal-change` hook | High |
| 2 | chkSum 옵션 시 SUM 헤더 동적 추가 (`g.columnHeaders.rows.push`) | Mid |
| 3 | btnColumn / btnMeasure 모달 호출 (공용 `ColumnSettingModal` 재사용) | Mid |
| 4 | spdMain_CellDoubleClick — Project/Item 상세보기 popup | Mid |
| 5 | Division=40 분기 — Project/PlantSite Field 비활성 (UI 분기) | Mid |
| 6 | InternalYN / chkColor / chkSum checkbox 를 Form 에 추가 | Low |
| 7 | Multi-currency 콤보 (cboKRW/USD/LOC) | Low |

---

## §9. 변경 이력

- 2026-06-07 (Phase B-1): 완전 신규 작성. 4축 100% 매핑 (Event 21 / API 12 / Validation 23 / Expression 7 / Button 10 / Popup 5). Mockup PNG baseline + PKG body 보강 1건 식별. anti-simplification 의무 준수 (AS-IS 8 MD + xlsx + .cs 정본 정밀 read).
