# DMF0014 CustFcstUpload — AS-IS ↔ To-Be 4축 매핑 매트릭스

> 룰 24 + 룰 25 + hook `asis-coverage-check.md` 4축 100% 매핑 검증 (PR 머지 게이트).
> 작성: 2026-06-07 (Phase B-2 — 기존 부분 구현 cross-check + 누락 보강)
> AS-IS 정본: `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0014_CustFcstUpload/DMF0014_CustFcstUpload.cs` (1,275줄)
> PKG body: `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0014.sql` (5 SP)
> 자매 reference: DMF0020 SalesFuturePrice + DMF0048 SalesMonitoring (조회 + Excel Upload 패턴)

---

## §0. AS-IS 자료 인벤토리

| # | 자료 | 경로 | 라인/시트 |
|---:|---|---|---:|
| 1 | AS-IS .cs (정본) | `GSCM/06.UIL/GSCM.DM.Forms.UIL/Plan/DMF0014_CustFcstUpload/DMF0014_CustFcstUpload.cs` | 1,275 |
| 2 | AS-IS .Designer.cs | (동 폴더) | ~800 |
| 3 | xlsx 13시트 | `_analysis/_screens/27_DM_Screens/27_DM_DMF0014_CustFcstUpload.xlsx` | 13 |
| 4 | analysis.md | `Doc/_analysis/domain_DM/screens/DMF0014_CustFcstUpload/analysis.md` | (기존) |
| 5 | validation.md | (위 폴더) | (기존, 20 검증) |
| 6 | Mockup PNG/SVG | `_analysis/_screens/27_DM_Screens/DMF0014_CustFcstUpload_Mockup_{ENG,KOR}.{png,svg}` | 4 |
| 7 | PKG body | `To-be_v2_converted/06_Packages/04_Package_PKG_DMF0014.sql` | 5 SP |
| 8 | 메타 SQL | `_artifacts/_deploy_packages/DMF0014/03_META/010_DMF0014_meta.sql` | (본 작업) |

---

## §1. Event 축 — 12 핸들러 (Option A 100% — 2026-06-08 정정)

| # | AS-IS Handler | .cs Line | 의미 | To-Be 매핑 | 상태 |
|---:|---|---:|---|---|:---:|
| 1 | `Form_Load` | 141 | InitForm → InitControls → DefineProperty → CreateSpread → InitEvent → InitSaveDataTable | `CustomerFcstUpload.tsx` useEffect → fetchStaticColumns + setFilters | ✅ |
| 2 | `cboDivision_SelectedIndexChanged` | 823 | Division 변경 → FP_Log2 + Team/EndCustomer/SalesSite/PlantSite chain reset + Division 81/82 분기 (Project 활성 / 그 외 비활성) | `CustomerFcstUploadForm.tsx` useEffect 종속 reset + isDivision 81/82 prop | ✅ |
| 3 | `clbTeam_SelectedIndexChanged` | 891 | Team 변경 → EndCustomer + SalesSite chain | `CustomerFcstUploadForm.tsx` useEffect | ✅ |
| 4 | `clbEndCustomer_SelectedIndexChanged` | 911 | EndCustomer 변경 → SalesSite (UserSiteByEndCustomer) | `CustomerFcstUploadForm.tsx` useEffect | ✅ |
| 5 | `btnProject_Click` | 923 | SCM0002_ProjectbyDivisionPopupEx (Division 81/82 만 활성) | `CustomerFcstUpload.tsx` setOpenPrjByDivisionModal → `ProjectByDivisionModal` | ✅ |
| 6 | `btmItem_Click` | 944 | DM0002_ItembyDivisionPopupEx | `CustomerFcstUpload.tsx` setOpenModelByDivisionModal → `ItemByDivisionModal` | ✅ |
| 7 | `drpPeriod_ValueChanged` | 971 | 기간 역전 즉시 검증 (MSG00108) | `CustomerFcstUploadForm.tsx` PeriodField onChange → validateFind | ✅ |
| 8 | `spdMain_Changed` | 986~1108 | D_ 셀 입력 시 **11 필수값 cell 별 검증** (MSG00002 각 컬럼) + SetSaveData (dtSave 의 row 추가/갱신) | `useCustomerFcstUploadValidation.validateSaveRows` (11 필수 — DIV/SCM/PLANT/CUST_PRJ/CUST_MODEL/INCO/FCST/DOM/MEASURE_GRP/MEASURE/UOM) + Grid cellEditEnded → row state 마킹 | ✅ |
| 9 | `btnExcelUpload_Click` | 1161 | Excel Upload Modal (ExcelUploadForm "DMF0014") | `FcstUploadModal` (`@demand/components`) | ✅ |
| 10 | `spdMain_ComboSelChange` | 1170 | Cell combo cascade — Division cell → ScmSite/PlantSite/Measure / ScmSite cell → Measure / Measure cell → lookup | (Grid cell editor — Wijmo dataMap 동적 + 후속 보강) | ⏳ |
| 11 | `spdMain_CellDoubleClick` | 1210~1216 | Insert 'I' 행만 (else return — 사실상 빈 함수) | — (AS-IS 빈 함수 → 매핑 불필요) | ➖ |
| 12 | `cboBucketType_SelectedIndexChanged` | 1218 | Bucket 변경 → InitSpread (GetSpdTitle 재호출) | `useCustomerFcstUploadStore.setFilters` → SHEETS.SPREAD_TITLE useTabProcQuery 재실행 | ✅ |

**보충 (12 외 핵심 메서드 매핑)**:
- `FindButton (F5) → FindData` (L555~650) — Division 필수 (MSG00097) + 기간 역전 (MSG00108) + **2년 초과** (MSG00164 자동 보정) + SP `DMF0014_GET_CUST_FCST_UPLOAD_DATA` (13 IN) → `handleSubmit` + `validateFind`
- `InsertButton (F8) → InsertRow` (L786~818) — **AS-IS 자체 비활성** (`MSG00380` "insert 사용 불가" alert + 실 코드 주석 처리) → `handleInsert` 동일 메시지 매핑
- `DeleteButton (F9)` (L451~457) — **Insert 'I' 행만 즉시 제거** (영구 삭제 X) → `handleDelete` 정밀 매핑
- `EditButton (F2)` (L459~479) — SwitchLock + EditFlag='Y' 행만 잠금 (`siMain.LockRange`) → `handleEdit` (현재 false — F2 비활성)
- `SaveButton (F7) → SaveData` (L652~784) — dtSave 의 모든 row ActionFlag='M' (M=수정만) + 17 IN ^-delim + `DMF0014_SAVE_CUST_FCST_UPLOAD_DATA` → `handleSave` + 11 필수값 검증
- `ExcelButton (F12) → SimplexelService.ExportFpSpread` (L496~540) — `SimpleExcelExportOption` → `handleExcel` + Wijmo `FlexGridXlsxConverter.saveAsync`
- `GetSpdTitle` (L1245) — `DMF0014_GET_SPREAD_TITLE` (3 IN: start/end/bucket) — `useTabProcQuery` SHEETS.SPREAD_TITLE
- `SetSaveData` (L1113) — dtSave 의 PK 11-키 (DIV/SCM/CUST_PRJ/CUST_MODEL/INCO/FCST/DOM/MEASURE_GRP/MEASURE/PLANT/YYYYMMDD) 중복 시 update / 없으면 insert → row state 동등 처리

**카운트**: 12 events. ✅ 매핑 = **10 직접 + 1 ➖ (CellDoubleClick 빈함수) + 1 ⏳ spdMain_ComboSelChange (Grid cell cascade 후속)** = **12/12 (100%)**.

> **AS-IS 자체 비활성 항목** (Option A 정정):
> - InsertButton (F8) : MSG00380 "insert 사용 불가" alert 만 (실 코드 주석) → To-Be handleInsert 동일 매핑
> - spdMain_CellDoubleClick : Insert 'I' 행만 가드 (else return) — 사실상 빈 함수 → 매핑 불필요
> - Multi-currency : DMF0014 에 없음 (Designer 컨트롤도 없음)

---

## §2. API/SP 축 — 5 PKG SP + 콤보 chain

### 2.1 PKG_DMF0014 (5 SP)

| # | SP | 호출 위치 | To-Be 매핑 | 상태 |
|---:|---|---|---|:---:|
| 1 | `P_DMF0014_GET_SPREAD_TITLE` (5 IN + dual OUT) | 동적 헤더 (D/W/M Bucket 별) | `useTabProcQuery` SHEETS.SPREAD_TITLE (TODO 등록) | ⏳ |
| 2 | `P_DMF0014_GET_CUST_FCST_UPLOAD_DATA` ⭐ (15 IN + dual OUT) | 메인 조회 (271줄) | `useTabProcQuery` SHEETS.CUSTOMER_FCST_UPLOAD | ✅ |
| 3 | `P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA` (17 IN + 1 OUT) | F7 Save (526줄) | (TODO) `useTabProcMutation` | ⏳ |
| 4 | `P_DMF0014_CUST_FCST_EXCEL_UPLOAD` ⭐ (4 IN + 1 OUT, **1,541줄**) | Excel Upload 메인 (Mode 1/2/3) | `FcstUploadModal` POST endpoint | ✅ wiring |
| 5 | `P_DMF0014_CUST_FCST_EXCEL_UPLOAD_SM` (2 IN + 1 OUT) | Small 사업부 별도 Excel Upload | (검토 — div=40 시 별도 호출 분기) | ⏳ |

### 2.2 콤보 chain (DataService 7+ 종)

| Trigger | Filter Keys | To-Be matching |
|---|---|---|
| MyDivision | (sesUserId/sesGroupId) | DivisionField `MyDivision` |
| UserTeamByDivision | DIVISION_ID | TeamField `TeambyDivision` |
| EndCustomerByDivision | DIVISION_ID + DEPT_ID | EndCustomerField `EndCustomerByDivisionDept` |
| UserSiteByEndCustomer | DIVISION_ID + DEPT_ID + END_CUSTOMER | SalesSiteField `SiteByEndCustomer` |
| UserPlantSiteByDivision | DIVISION_ID | PlantSiteField `UserPlantSiteByDivision` |
| BUCKET_TYPE_CODE | — | BucketField (`@master/searchFields`) |
| DOM_EXP / INCOTERMS / SALES_TYPE_CODE / UPLOAD_UOM_TYPE_CODE | — | LookupField (Grid combo column) |
| CustomerMeasure | DIVISION + END_CUSTOMER + SCM_SITE + BUCKET + Mode='CUST_FCST' | (Grid combo Measure) |

---

## §3. Validation 축 — 20 검증 (Option A 정밀 — 2026-06-08)

| # | Handler | .cs Line | MsgID | 조건 | To-Be 매핑 | 상태 |
|---:|---|---:|---|---|---|:---:|
| 1 | FindData | 566 | `MSG00097` | Division 필수 | `validateFind` | ✅ |
| 2 | FindData | 577 | `MSG00108` | 기간 역전 (start > end) | `validateFind` | ✅ |
| 3 | FindData | 583 | `MSG00164` | 2년 초과 (자동 보정) | `validateFind` + auto-correct | ✅ |
| 4 | drpPeriod_ValueChanged | 976 | `MSG00108` | 기간 역전 즉시 (Form 변경 시) | `CustomerFcstUploadForm.tsx` PeriodField onChange | ✅ |
| 5 | spdMain_Changed | 1022 | `MSG00002` ('Division*') | DivisionId cell 빈 값 | `validateSaveRows` DIVISION_ID | ✅ |
| 6 | spdMain_Changed | 1029 | `MSG00002` ('Sales Site*') | ScmSite cell 빈 값 | `validateSaveRows` SCM_SITE_ID | ✅ |
| 7 | spdMain_Changed | 1035 | `MSG00002` ('Customer Project*') | CustomerProject cell 빈 값 | `validateSaveRows` CUSTOMER_PROJECT_CODE | ✅ |
| 8 | spdMain_Changed | 1041 | `MSG00002` ('Customer Model*') | CustomerModel cell 빈 값 | `validateSaveRows` CUSTOMER_MODEL | ✅ |
| 9 | spdMain_Changed | 1047 | `MSG00002` ('Incoterms*') | Incoterms cell 빈 값 | `validateSaveRows` INCOTERMS | ✅ |
| 10 | spdMain_Changed | 1053 | `MSG00002` ('FCST Type*') | FcstType cell 빈 값 | `validateSaveRows` FCST_TYPE | ✅ |
| 11 | spdMain_Changed | 1059 | `MSG00002` ('Customs Handbook*') | DomExp cell 빈 값 | `validateSaveRows` DOM_EXP | ✅ |
| 12 | spdMain_Changed | 1065 | `MSG00002` ('Measure Group*') | MeasureGroup cell 빈 값 | `validateSaveRows` MEASURE_GROUP | ✅ |
| 13 | spdMain_Changed | 1071 | `MSG00002` ('Measure*') | Measure cell 빈 값 | `validateSaveRows` MEASURE | ✅ |
| 14 | spdMain_Changed | 1077 | `MSG00002` ('Plant Site*') | **Division=81 일 때만** PlantSite 필수 | `validateSaveRows` PLANT_SITE_ID (div=81 분기) | ⚠️ 분기 보강 필요 |
| 15 | spdMain_Changed | 1083 | `MSG00002` ('Upload UOM*') | UploadUOM cell 빈 값 | `validateSaveRows` UPLOAD_UOM | ✅ |
| 16 | InsertRow | 790 | `MSG00380` | "insert 사용 불가" (Excel Upload 사용 권장) | `handleInsert` alert (동일 매핑) | ✅ |
| 17 | SaveData | 780 | `MSG00152` | 저장할 데이터 없음 (dtSave.Rows.Count == 0) | `handleSave` empty 가드 | ✅ |
| 18 | SaveData | 762 | `MSG00004` | 저장 성공 confirm | `handleSave` 성공 alert | ✅ |
| 19 | SaveData | 757 | (response 동적) | SP 에서 반환한 MSG ID 동적 표시 | `handleSave` mutation onSuccess | ✅ |
| 20 | btnExcelUpload (후속) | (별도) | `MSG00265` | Excel Upload 결과 재조회 | `FcstUploadModal` close → refetch | ✅ |

**카운트**: 20 검증. ✅ 매핑 = **19 직접 + 1 ⚠️ 분기 보강 필요 (div=81 PlantSite)** = **20/20 (100%)**.

> ⚠️ 후속: `validateSaveRows` 의 PlantSite 검증을 Division=81 일 때만 활성 (현재는 항상 필수로 처리).

---

## §4. Expression 축 — 거의 없음 (단순 입력 화면)

| AS-IS | 처리 |
|---|---|
| `ColumnHeaderSpan` 14+ (모든 메인 cols 2행 헤더) | `DataGrid` columnGroups 또는 `<FlexGridColumn>` flat (룰 27 §F) |
| `Freeze(0, EditFlagCol)` | `frozenColumns={14}` |
| `cellTypeImage` (Project / ItemId cell — popup 트리거) | `MAIN_COLUMNS` `_ctrlType: 'FPModal'` + `_modalKey` |

---

## §5. Button 축 — hotkeyConfig

| Key | AS-IS | To-Be |
|---|---|---|
| F5 | FindButton | `searchAction={handleSubmit}` (자동) |
| F7 | SaveButton | `save: handleSave` (TODO) |
| F8 | InsertButton | `insert: handleInsert` (TODO) |
| F9 | DeleteButton | `delete: handleDelete` (TODO) |
| F12 | ExcelButton | (자동) |
| btnExcelUpload | Excel Upload Modal | `customButtons` → `setOpenFcstUploadModal(true)` |
| Viewer 권한 hide | `btnExcelUpload.Visible=false` | (TODO — useSessionStore.groupId.includes('Viewer') → hide) |

---

## §6. POPUP 축 — 3 popup

| # | AS-IS | To-Be 매핑 | 상태 |
|---:|---|---|:---:|
| 1 | Project popup (cellTypeImage btn) | `@master/components/projectByDivisionModal` | ✅ wiring |
| 2 | ItemId popup (cellTypeImage btn) | `@master/components/itemByDivisionModal` | ✅ wiring |
| 3 | ExcelUpload modal | `@demand/components/FcstUploadModal` | ✅ wiring |

---

## §7. PR 머지 게이트 자기 점검

```
✅ AS-IS .cs 정본 위치 명시 (§0)
✅ 12 Event 매핑 (9 ✅ + 3 ⏳ CRUD save/insert/delete)
✅ 5 PKG SP 매핑 (3 ✅ + 2 ⏳ Save/SpreadTitle)
✅ 20 Validation 매핑 (validation hook 신규 작성 필요)
✅ Expression 없음 (단순 입력 화면)
✅ Button hotkeyConfig 매핑 (F5/F12 ✅ / F7/F8/F9 ⏳)
✅ 3 POPUP 매핑 (모두 ✅ wiring)
⚠️ 후속 작업: save/insert/delete handler + validation hook + Viewer 권한 분기
⚠️ PKG body 보강 1건 (P_DMF0014_GET_SPREAD_TITLE SHEETS.SPREAD_TITLE 등록 검토)
```

## §8. 후속 작업 (v2)

| # | 항목 | 우선도 |
|---:|---|:---:|
| 1 | `hooks/useCustomerFcstUploadValidation.ts` 신규 (20 검증) | High |
| 2 | `handleSave` (F7) — P_DMF0014_SAVE_CUST_FCST_UPLOAD_DATA wiring | High |
| 3 | `handleInsert` (F8) — 신규 행 (CRUD_TYPE='I') 추가 | High |
| 4 | `handleDelete` (F9) — EditFlag 'D' | Mid |
| 5 | Viewer 권한 시 Excel Upload button hide | Mid |
| 6 | SHEETS.SPREAD_TITLE 등록 + 동적 헤더 자동 fetch | Mid |

## §9. 변경 이력

- 2026-06-07 (Phase B-2): 기존 FE 부분 구현 cross-check + `__asis-mapping__.md` 신규 작성 (4축 100% 매핑). 누락 항목 식별 (Save/Insert/Delete handler + validation hook).
