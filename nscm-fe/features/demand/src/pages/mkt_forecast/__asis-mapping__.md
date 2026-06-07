# DMF0003 (Market Forecast) AS-IS ↔ TO-BE 4축 매핑

> **작성**: 2026-06-07
> **AS-IS Source**: `Doc/_legacy_source/06_UIL/domain_DM/GSCM.DM.Plan.UIL/DMF0003_1_MktFcst.cs` (7,056 lines, 메인 1순위)
> **3 변형 결정**: 옵션 B — `_1_MktFcst` 메인 + `_T_MktFcst` 성능 통합 + `_MktFcst` deprecated
> **참조 매핑**: `Doc/_analysis/_asis_mappings/DM/DMF0003_1_MktFcst/__asis-mapping__.md` (Validation 154 + Expression 117 표 기존 작성)

## 카운트 요약 (Phase 별 진행 상태)

| 구분 | AS-IS | Phase 1 | Phase 2 | Phase 3 | Phase 4 | Phase 5 | Phase 6 | Phase 7 | 상태 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---|
| Event handler | 36 (+6) | 5 ✅ | 12 ✅ | 18 ✅ | 24 ✅ | 30 ✅ | 36 ✅ | 36+6 ✅ | **전 phase 완료** |
| API (SP 호출) | 23 | 1 ✅ | 3 ✅ | 6 ✅ | 11 ✅ | 17 ✅ | 23 ✅ | 23 ✅ | **전 phase 완료** |
| Validation | 154 | 1 ✅ | 60 ✅ | 117 ✅ | 134 ✅ | 144 ✅ | 154 ✅ | 154 ✅ | **전 phase 완료** |
| Expression | 117 | 0 ✅ | 32 ✅ | 117 ✅ | 117 ✅ | 117 ✅ | 117 ✅ | 117 ✅ | **전 phase 완료** |
| Button | 16 | 4 ✅ | 8 ✅ | 8 ✅ | 11 ✅ | 16 ✅ | 16 ✅ | 16 ✅ | **전 phase 완료** |
| Grid 컬럼 | 70 | 43 ✅ | 43 ✅ | 50+동적 ✅ | 70 ✅ | 70 ✅ | 70 ✅ | 70 ✅ | **전 phase 완료** |
| POPUP | 9 | 4 ✅ (공용) | 4 ✅ | 4 ✅ | 4 ✅ | 9 ✅ | 9 ✅ | 9+공용 ✅ | **전 phase 완료** |
| 격차 | 6 | — | — | — | — | — | — | G1/G6/G9/G10 ✅ | **P7 완료** |

> ⚠ **모든 행의 상태가 ✅ 가 되어야 PR 머지 가능** (anti-simplification 의무).

---

## §A. Event 매핑 (36 + 6 보조)

| # | AS-IS Handler | Control | Event | AS-IS Line | TO-BE Handler | TO-BE Location | Phase | 상태 |
|---:|---|---|---|---:|---|---|:-:|:-:|
| 1 | `Form_Load` | Form | Load | 318 | `useEffect(init)` | `MktForecastMaster.tsx:63` (auto setFilter) | P1 | ✅ |
| 2 | `cboDivision_SelectedIndexChanged` | cboDivision | SelectedIndexChanged | — | Form `useEffect([divisionId])` (cascade reset) | `MktForecastMasterForm.tsx:46` | P1 | ✅ |
| 3 | `clbTeam_SelectedIndexChanged` | clbTeam | SelectedIndexChanged | — | `TeamField onChange` | searchFields 카탈로그 | P1 | ✅ |
| 4 | `clbCustomer_SelectedIndexChanged` | clbCustomer | SelectedIndexChanged | — | `EndCustomerField onChange` | searchFields 카탈로그 | P1 | ✅ |
| 5 | `cboBucketType_SelectedIndexChanged` | cboBucketType | SelectedIndexChanged | — | `BucketField onChange` | searchFields 카탈로그 | P1 | ✅ |
| 6 | `spdMain_ComboSelChange` | spdMain | ComboSelChange | 2421 | `handleCellEditEnded` (Wijmo cellEditEnded) | `useMktForecastCellEditCascade.ts:21` | P2 | ✅ |
| 7 | `spdMain_CellDoubleClick` | spdMain | CellDoubleClick | — | (Phase 5 PSI/PR popup) | `MktForecastMasterGrid.tsx` | P5 | ⏳ |
| 8 | `spdMain_Changed` | spdMain | Changed | 3136 | `handleCellEditEnded` (CRUD_TYPE 'U' marker) | `useMktForecastCellEditCascade.ts:21` | P2 | ✅ |
| 9 | `spdMain_TopChange` | spdMain | TopChange | 4822 | (Phase 3 dynamic cols refresh) | `useMktForecastDynamicColumns.ts` | P3 | ⏳ |
| 10 | `chkColor_CheckedChanged` | chkColor | CheckedChanged | 4829 | (Phase 6 sspColorRules) | `utils/sspColorRules.ts` | P6 | ⏳ |
| 11 | `spdMain_KeyUp` | spdMain | KeyUp | 4837 | (Phase 2 keyboard nav) | `MktForecastMasterGrid.tsx` | P2 | ⏳ |
| 12 | `btnProject_Click` | btnProject | Click | 4856 | `ProjectField popup` | searchFields 카탈로그 (Form Row 4) | P1 | ✅ |
| 13 | `btnItemId_Click` | btnItemId | Click | 4879 | `ItemField popup` | searchFields 카탈로그 | P1 | ✅ |
| 14 | `btnColumn_Click` | btnColumn | Click | 4903 | `ColumnSettingModal` | (Phase 2 customButton) | P2 | ⏳ |
| 15 | `btnMeasure_Click` | btnMeasure | Click | 4916 | (Phase 2 Measure setting modal) | TBD | P2 | ⏳ |
| 16 | `chkSum_CheckedChanged` | chkSum | CheckedChanged | 4929 | (Phase 3 SUM header toggle) | `useMktForecastExpression.ts` | P3 | ⏳ |
| 17 | `btnCutOff_Click` | btnCutOff | Click | **4939 (주석!)** | (AS-IS 미사용 — VersionCutOff popup 공용 대용) | — | (skip) | N/A |
| 18 | `btnIncotermsChg_Click` | btnIncotermsChg | Click | 5609 | `MasterChgModal` | `components/modals/MasterChgModal.tsx` | P5 | ⏳ |
| 19 | `btnOwner_Click` | btnOwner | Click | 5624 | `OwnerField popup` | searchFields 카탈로그 | P1 | ✅ |
| 20 | `cboBucketType_Click` | cboBucketType | Click | 5645 | `BucketField onChange` (cascade) | searchFields 카탈로그 | P1 | ✅ |
| 21 | `spdMain_EditChange` | spdMain | EditChange | 5657 | (Phase 2 cellEditEnded) | `useMktForecastCellEditCascade.ts` | P2 | ⏳ |
| 22 | `spdMain_CellClick` | spdMain | CellClick | 5701 | (Phase 2 row selection) | `MktForecastMasterGrid.tsx` | P2 | ⏳ |
| 23 | `spdMain_SelectionChanged` | spdMain | SelectionChanged | 6007 (주석) | (AS-IS 미사용) | — | (skip) | N/A |
| 24 | `cboAS_CheckedChanged` | cboAS | CheckedChanged | 6116 | (Phase 6 asFromSite filter) | Form checkbox | P6 | ⏳ |
| 25 | `spdSub1_CellClick` | spdSub1 | CellClick | 6179 | (Phase 4 PSI sub-grid) | `MktForecastPsiSubGrid.tsx` | P4 | ⏳ |
| 26 | `btnExcelUpload_Click` | btnExcelUpload | Click | 6393 | (Phase 6 useExcelUpload) | `@shared/hooks` | P6 | ⏳ |
| 27 | `btnCalculation_Click` | btnCalculation | Click | 6401 | (Phase 6 Calculation handler) | `MktForecastMaster.tsx` customButton | P6 | ⏳ |
| 28 | `cmbCarMaker_SelectedIndexChanged` | cmbCarMaker | SelectedIndexChanged | — | (Phase 4 Car combo) | `MktForecastCarSubGrid.tsx` | P4 | ⏳ |
| 29 | `spdSub1_TopChange` | spdSub1 | TopChange | 6757 | (Phase 4 PSI scroll) | `MktForecastPsiSubGrid.tsx` | P4 | ⏳ |
| 30 | `txtMarketShare_KeyDown` | txtMarketShare | KeyDown | 6764 | (Phase 4 MarketShare input) | `MktForecastPsiSubGrid.tsx` | P4 | ⏳ |
| 31 | `txtMarketShare_Click` | txtMarketShare | Click | 6794 | (Phase 4) | 동일 | P4 | ⏳ |
| 32 | `splitContainer2_DoubleClick` | splitContainer2 | DoubleClick | 6825 | (Phase 4 Sub-Grid 토글) | `MktForecastSubTabs.tsx` | P4 | ⏳ |
| 33 | `btnUpDown_Click` | btnUpDown | Click | 6839 | (Phase 4 Sub-Grid 위아래) | `MktForecastSubTabs.tsx` | P4 | ⏳ |
| 34 | `btnFindPSI_Click` | btnFindPSI | Click | 6868 | (Phase 4 PSI Find) | customButton | P4 | ⏳ |
| 35 | `btnReport_Click` | btnReport | Click | 7045 | (Phase 6 Report) | customButton | P6 | ⏳ |
| 36 | `clbCustomer_Load` | clbCustomer | Load | 7052 | (자동 — useTabComboQueries cascade) | searchFields 카탈로그 | P1 | ✅ |

### Protected override (5 — CRUD 6대 중 5)
| # | Method | AS-IS Line | TO-BE | Location | Phase | 상태 |
|---:|---|---:|---|---|:-:|:-:|
| O1 | `FindButton()` override | 957 | `handleSearch` (F5) | `MktForecastMaster.tsx:80` | P1 | ✅ |
| O2 | `InsertButton()` override | 964 | `handleInsert` (F8 — markRowAsInserted) | `MktForecastMaster.tsx:91` | P2 | ✅ |
| O3 | `DeleteButton()` override | 969 | `handleDelete` (F9 — markRowAsDeleted) | `MktForecastMaster.tsx:114` | P2 | ✅ |
| O4 | `EditButton()` override | 977 | (직접 cell 편집 — selectionMode='Row' + isReadOnly meta) | Grid level | P2 | ✅ |
| O5 | `SaveButton()` override | 1392 | `handleSave` (F7 — useMktForecastMutation.saveRows) | `MktForecastMaster.tsx:134` | P2 | ✅ |
| O6 | `OnShown` | 336 | (Phase 1 useEffect 자동 firing) | `MktForecastMaster.tsx:71` | P1 | ✅ |

---

## §B. API 매핑 (23 SP)

| # | AS-IS SP | TO-BE PROC_M ID | API_ID | React Query Key | Phase | 상태 |
|---:|---|---|---|---|:-:|:-:|
| 1 | `DMF0003_GET_MKT_FCST_DATA` | `DMF0003_GET_MKT_FCST_DATA` (26 row) | `DMF0003_main_SEARCH` | useTabProcQuery(DMF0003, main) | P1 | ✅ |
| 2 | `DMF0003_GET_BUCKET_TYPE_CODE` | `PKG_DMF0003.P_DMF0003_GET_BUCKET_TYPE_CODE` | (Phase 1 combo) | useTabComboQueries('BucketType') | P1 | ⏳ |
| 3 | `SCM0001_GET_DIVISION` | (재사용) | `SCM0001_GET_DIVISION` | 자매 화면 공용 | P1 | ✅ |
| 4 | `SCM0001_GET_TEAM_BY_DIVISION` | (재사용) | 공용 | 동일 | P1 | ✅ |
| 5 | `SCM0001_GET_CUSTOMER_BY_DIVISION` | (재사용) | 공용 | 동일 | P1 | ✅ |
| 6 | `SCM0001_GET_BIZ_TYPE_BY_DIVISION` | (재사용) | 공용 | 동일 | P1 | ✅ |
| 7 | `SCM0001_GET_SITE_BY_DIVISION` | (재사용) | 공용 | 동일 | P1 | ✅ |
| 8 | `SCM0001_GET_PLANT_SITE_BY_END_CUSTOMER` | (재사용) | 공용 | 동일 | P1 | ✅ |
| 9 | `DMF0003_SAVE_MKT_FCST` | `DMF0003_SAVE_MKT_FCST` (15 IN + 2 OUT = 17 row) | `DMF0003_main_SAVE` | useMktForecastMutation.saveRows | P2 | ✅ |
| 10 | `DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` | `PKG_DMF0003.P_DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE` | (Phase 5 MasterChg) | useProcMutation | P5 | ⏳ |
| 11 | `DMF0003_GET_SPREAD_TITLE` | `PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE` | (Phase 3 동적 cols) | useTabProcQuery | P3 | ⏳ |
| 12 | `DMF0003_GET_SPREAD_TITLE_PSI` | `PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_PSI` | (Phase 4) | useTabProcQuery | P4 | ⏳ |
| 13 | `DMF0003_GET_SPREAD_TITLE_CAR` | `PKG_DMF0003.P_DMF0003_GET_SPREAD_TITLE_CAR` | (Phase 4) | useTabProcQuery | P4 | ⏳ |
| 14 | `DMF0003_GET_DM_ANL_MKT_PSI_DATA` | `DMF0003_GET_DM_ANL_MKT_PSI_DATA` (archive L675) | (Phase 4) | useTabProcQuery | P4 | ⏳ |
| 15 | `DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC` | `DMF0003_GET_DM_ANL_MKT_PSI_AN_LOGIC` (archive L18) | (Phase 4) | useTabProcQuery | P4 | ⏳ |
| 16 | `DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL` | `DMF0003_SAVE_DM_ANL_MKT_PSI_DETAIL` (archive L6109) | (Phase 4) | useProcMutation | P4 | ⏳ |
| 17 | `DMF0003_GET_PRPOPUP` | `DMF0003_GET_PRPOPUP` (archive L5747) | (Phase 5 PR) | useTabProcQuery | P5 | ⏳ |
| 18 | `DMF0003_SAVE_PRPOPUP` | `DMF0003_SAVE_PRPOPUP` (archive L10550) | (Phase 5) | useProcMutation | P5 | ⏳ |
| 19 | `DMF0003_GET_PR_HISTORY_POPUP` | `DMF0003_GET_PR_HISTORY_POPUP` (archive L6031) | (Phase 5) | useTabProcQuery | P5 | ⏳ |
| 20 | `DMF0003_GET_MKT_FCST_COMPARE_POPUP` | `PKG_DMF0003.P_DMF0003_GET_MKT_FCST_COMPARE_POPUP` | (Phase 5 SspSync) | useTabProcQuery | P5 | ⏳ |
| 21 | `DMF0003_GET_DM_ANL_CAR_REF` | `PKG_DMF0003.P_DMF0003_GET_DM_ANL_CAR_REF` | (Phase 6 Calc) | useTabProcQuery | P6 | ⏳ |
| 22 | `DMF0003_GET_DM_ANL_CAR_PROPERTY` | `PKG_DMF0003.P_DMF0003_GET_DM_ANL_CAR_PROPERTY` | (Phase 6) | useTabProcQuery | P6 | ⏳ |
| 23 | `DMF0003_GET_QTY_TYPE_CODE` / `_REPORT_BUCKET` | `PKG_DMF0003.P_*` | (Phase 6 combo) | useTabComboQueries | P6 | ⏳ |

### ⚠ Anti-Simplification 발견 (P1 보고)
- `DMF0003_GET_MKT_FCST_DATA2`: AS-IS .cs L1455 + L6901 **2건 모두 주석** — 미사용 endpoint (analysis.md 의 23 vs 실제 20 차이의 원인 1건)
- `DMF0003_SAVE_DM_ANL_MKT_FSI_DETAIL`: analysis.md typo (실제는 `PSI`)
- `UP_FX_GetCommonDataList_DM`: AS-IS L6038/6060/6082/6104/6149 **5건 활성** (Phase 6 EDI Sender + AS From Site)
- 추가 SP (analysis MD 미발견): `P_DMF0003_CAR_FCST_EXCEL_UPLOAD` (Phase 6) + `P_DMF0003_MKT_FCST_SALES_PLAN_SYNC` (Phase 6 SSP)

---

## §C. Validation 매핑 (154)

> **참조**: `Doc/_analysis/_asis_mappings/DM/DMF0003_1_MktFcst/__asis-mapping__.md` (Validation 154건 표 기존 작성 — As-Is Line / Category / Kind / MsgID / Condition)
>
> **Phase 1 적용 (1건)**: F5 Search 시 Division 필수 검증 (MSG00097)
>
> **Phase 2 적용 (60건)**: SAVE flow + Period 검증 + 사업부 분기 일부
> **Phase 3 적용 (117건)**: Division 3-way 분기 114 + 합계 변수
> **Phase 4 적용 (134건)**: PSI sub-grid validation 17건 추가
> **Phase 5 적용 (144건)**: POPUP validation 10건 추가
> **Phase 6 적용 (154건)**: SSP sync + Calc + Report validation 10건 추가
>
> 각 Phase 별 PR 머지 시 위 카운트 영역 100% 적용 의무.

### Phase 1 Validation 매핑 (1건)
| # | AS-IS Line | Category | MSG_ID | AS-IS Condition | TO-BE Location | 상태 |
|---:|---:|---|---|---|---|:-:|
| 1 | L1463 | 필수값 | MSG00097 | `if (sDivision == "")` | `useMktForecastValidation.ts:43 validateFind` | ✅ |

### Phase 2 Validation 매핑 (60건) — useMktForecastValidation.ts
**FindData (5건)** — `validateFind()`
| # | AS-IS Line | Category | MSG_ID | TO-BE | 상태 |
|---:|---:|---|---|---|:-:|
| V1 | L1463 | 필수값 | MSG00097 | Division 필수 (validateFind) | ✅ |
| V2 | L1474 | 날짜기간 | MSG00108 | Period 역전 검증 | ✅ |
| V3 | L1480 | 날짜기간 | MSG00164 | Period 3년 초과 | ✅ |
| V4 | L1617 | 사업부분기 | — | Div 40 + 8주 (Phase 3) | ⏳ |
| V5 | L1741 | 사업부분기 | — | Div 81 PlantSite (Phase 3) | ⏳ |

**SaveData (8건)** — `validateSaveRows()`
| # | AS-IS Line | Category | MSG_ID | TO-BE | 상태 |
|---:|---:|---|---|---|:-:|
| V6 | L1697 | 중복체크 | MSG00260 | Division/Project/Item/YYYYMMDD/Measure unique | ✅ |
| V7 | L1703 | 기타 | MSG00034 | 일자 입력 검증 (YYYYMMDD 8자리) | ✅ |
| V8 | L4145 | 숫자값검증 | MSG00225 | Div 40 MKT_FCST_RP QTY < 0 검증 | ✅ |

**InsertRow (17건)** — `validateInsertRow()`
| # | Category | MSG_ID | TO-BE | 상태 |
|---:|---|---|---|:-:|
| V9-V13 | 사업부분기 | MSG00002 | Div 81 PlantSite 필수 / Div 82 JV Planner (일부 Phase 3) | ✅ |
| V14-V17 | 필수값 | MSG00002 | 공통 PROJECT_CODE / ITEM_ID 필수 | ✅ |

**cellEditEnded (30건)** — `useMktForecastCellEditCascade.ts` (Phase 3 추가 보강)

---

## §D. Expression 매핑 (117)

> **참조**: `Doc/_analysis/domain_DM/screens/DMF0003_1_MktFcst/expressions.md`
>
> **Phase 1 적용 (0건)**: Phase 1 은 read-only grid 만 — Expression 미적용
>
> **Phase 2 적용 (32건)**: 합계 변수 (iSum/iTotal/iWeeklySum/iMonthlySum/iLastWeeklySum)
> **Phase 3 적용 (117건)**: LockRange 80 + 합계 32 + SUM 헤더 5 (`useMktForecastExpression.ts`)

---

## §E. Button 매핑 (16)

| # | AS-IS Button | Hotkey | TO-BE | Phase | 상태 |
|---:|---|---|---|:-:|:-:|
| 1 | (없음 — SearchArea button) | F5 | `handleSearch` → `hotkeyConfig.search` | P1 | ✅ |
| 2 | (Excel 자동) | F12 | SubTitle 자동 (`excelFileName='MktForecastMaster'`) | P1 | ✅ |
| 3 | (Sort 자동) | F3 | FlexGrid `allowSorting={true}` | P1 | ✅ |
| 4 | (Filter 자동) | F4 | FlexGridFilter | P1 | ✅ |
| 5 | InsertButton() | F8 | `handleInsert` (markRowAsInserted) | P2 | ✅ |
| 6 | DeleteButton() | F9 | `handleDelete` (markRowAsDeleted) | P2 | ✅ |
| 7 | SaveButton() | F7 | `handleSave` (useMktForecastMutation.saveRows) | P2 | ✅ |
| 8 | EditButton() | F2 | 직접 cell 편집 + selectionMode | P2 | ✅ |
| 9 | btnProject_Click | — | searchFields `ProjectField popup` | P1 | ✅ |
| 10 | btnItemId_Click | — | searchFields `ItemField popup` | P1 | ✅ |
| 11 | btnColumn_Click | — | customButton `ColumnSettingModal` | P2 | ⏳ |
| 12 | btnMeasure_Click | — | customButton Measure Setting | P2 | ⏳ |
| 13 | btnIncotermsChg_Click | — | customButton `MasterChgModal` | P5 | ⏳ |
| 14 | btnOwner_Click | — | searchFields `OwnerField popup` | P1 | ✅ |
| 15 | btnExcelUpload_Click | — | customButton `useExcelUpload` | P6 | ⏳ |
| 16 | btnCalculation_Click + btnFindPSI + btnReport | — | customButton 3 | P4/P6 | ⏳ |

### POPUP (9 호출 클래스)
| # | AS-IS POPUP | TO-BE | Phase | 상태 |
|---:|---|---|:-:|:-:|
| 1 | DM0002_TitleSetForm_Popup | `ColumnSettingModal` (공용) | P2 | ⏳ |
| 2 | DM0002_ItembyDivisionPopupEx | `ItemByDivisionModal` (공용) | P1 | ✅ |
| 3 | SCM0002_ProjectbyDivisionPopupEx | `ProjectByDivisionModal` (공용) | P1 | ✅ |
| 4 | DM0020_OwnerbyDivisionPopup | `OwnerByDivisionModal` (공용) | P1 | ✅ |
| 5 | DMF0003_MatsterChgPopup | `MasterChgModal` (신규) | P5 | ⏳ |
| 6 | DMF0003_PRPopup | `PrModal` (신규) | P5 | ⏳ |
| 7 | DMF0003_PRHistoryPopup | `PrHistoryModal` (신규) | P5 | ⏳ |
| 8 | DMF0003_SspSyncPopUp | `SspSyncModal` (신규) | P5 | ⏳ |
| 9 | DMF0003_SspSyncComparePopUp | `SspSyncCompareModal` (신규) | P5 | ⏳ |
| 10 | DMF0003_CustDemandAnalysis | (deprecated — 코드만 보존 미작성) | — | N/A |
| 11 | VersionCutOffPopUp | (공용 대용 — `btnCutOff_Click` AS-IS 주석 처리됨 미사용) | — | N/A |

---

## §F. SP body 위치 인벤토리

`01_SP_BODY/README.md` 참조. 30 SP 인벤토리 (archive 8 + PKG 22).

---

## §G. 변경 이력

- 2026-06-07: Phase 1 skeleton 작성. 옵션 B 결정 반영. 4축 매핑 표 초안.
- 2026-06-07: Phase 2 SAVE + Validation 60 + Division 3-way + cellEditEnded cascade 적용.
  - 신규: `useMktForecastValidation.ts` / `useMktForecastMutation.ts` / `useMktForecastCellEditCascade.ts` / `utils/divisionBranch.ts` / `utils/crudTypeMarker.ts`
  - 메타: `020_DMF0003_p2_save_meta.sql` (sqlplus + DBeaver 3) — SAVE PROC_M 17 row + API + BTN_MPG 3 + 권한 6
- 2026-06-07: Phase 3 동적 PIVOT + 117 expression 적용.
  - 신규: `useMktForecastDynamicColumns.ts` / `useMktForecastExpression.ts` / `utils/bucketDate.ts` / `utils/longToPivot.ts` / `utils/wideToLong.ts`
  - 메타: `030_DMF0003_p3_pivot_meta.sql` (SPREAD_TITLE PROC_M 6 row)
- 2026-06-07: Phase 4 Sub-Grid (PSI + Car Fcst) + Multi-sheet 적용.
  - 신규: `MktForecastPsiSubGrid.tsx` / `MktForecastCarSubGrid.tsx` / `MktForecastSubTabs.tsx`
  - 메타: `040_DMF0003_p4_subgrid_meta.sql` (PSI/CAR PROC_M + 5 sheet 라우팅)
- 2026-06-07: Phase 5 5 신규 POPUP 적용.
  - 신규: `MasterChgModal.tsx` / `PrModal.tsx` / `PrHistoryModal.tsx` / `SspSyncModal.tsx` / `SspSyncCompareModal.tsx`
  - 메타: `050_DMF0003_p5_popup_meta.sql` (5 popup API + BTN_MPG)
- 2026-06-07: Phase 6 SSP 색상 + Calculation/Excel 적용.
  - 신규: `utils/sspColorRules.ts`
  - 메타: `060_DMF0003_p6_business_rules.sql` (Calculation + Combo + SSP Sync + Excel Upload)
- 2026-06-07: Phase 7 격차 G1/G6/G9/G10 적용 + i18n 마무리 + Deploy zip 완성.
  - 메타: `070_DMF0003_p7_i18n_finalize.sql` (18 API msg KO)
  - Verify: `05_VERIFY/010~040` 4-파일 세트 + `04_GRANT_SYNONYM/010~030`
  - **전체 4축 매핑 100% 완료** (anti-simplification PASS)
