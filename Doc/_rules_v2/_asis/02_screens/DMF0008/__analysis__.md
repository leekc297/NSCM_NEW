# DMF0008 (AS-IS: DMF0008_ErpEdiMaster) — ERP/EDI Master 정밀 분석

> Phase 7 PoC (2 차) — 룰 v2 의 robust 검증 + G4 Batch 검증.
> source: `GSCM/06.UIL/GSCM.DM.Master.UIL/DMF0008_ErpEdiMaster.{cs,Designer.cs}` (2937 + 948 = 3885 lines)

## §0 메타

| 항목 | 값 |
|---|---|
| AS-IS MENU_ID | DMF0008 |
| TO-BE MENU_ID | DMF0008 (동일) |
| Screen Name | ERP EDI Master (ERP↔EDI 마스터 동기화) |
| .cs lines | 2937 |
| .Designer.cs lines | 948 |
| Base class | `BaseForm` |
| Sheet 개수 | **4** (Summary + Repair + Sales_Site + SSPM) — 2 spread (`spdSummary`/`spdRepair`) + 1 sub spread (`spdSub`) 의 2 sheet tab |
| 복잡도 | DMF0015 의 ~2x (cs 2937 vs 1330) |

## §1 Layout (.Designer.cs)

### §1.1 조회조건 (Designer.cs 안 추정)
- **clbDivision** (UsrCheckedList) — 단일 선택
- **clbTeam** (public 멤버 — 동적 생성, Designer.cs 외)
- **clbEndCustomer** / **clbSalesSite** / **clbSoldToCode** / **clbShipToCode** (동적 멤버)
- **cboActive** (UsrCheckedList — 동적)
- **drpPeriod** (date range picker — 기간 from/to)

> 동적 컨트롤 다수 — Designer.cs 의 정적 정의 + .cs Form_Load 안 추가.

### §1.2 Grid 컨트롤 (4 sheet — 2 spread + 1 sub spread)

| Grid | Sheet | Sheet 이름 | 위치 |
|---|---|---|---|
| spdSummary | shtSummary | "SUMMARY" | (top) |
| spdRepair | shtRepair | "REPAIR" | (mid) |
| spdSub (tab 1) | shtSales_Site | "SALES_SITE" | (sub) |
| spdSub (tab 2) | shtSSPM | "SSPM" | (sub, 탭 전환) |

→ **DMF0015 (Master + Sub 2 sheet) 의 변형**. DMF0008 = Master + Repair (보조 master) + Sub Tab 2 sheet (Sales Site + SSPM 동등 sheet, tab 전환).

### §1.3 column 인벤토리 (DefColumns + DefColumnLabels)

**Main (Summary)**:
- DIVISION_ID / EDI_SENDER_NAME / ERP_MASTER_DATA / GSCM_MASTER_DATA
- ERP_SOLDTO / ERP_SHIPTO / ERP_ITEM_ID / GSCM_SALES_SITE_ID

**Sales_Site sub (~20 column)**:
- CITY / CITY_NAME / COMPANY_ID / COUNTRY / COUNTRY_NAME
- CUSTOMER_VALID_YN / DISTRIBUTION_CHANNEL / DIVISION_ID / EDIT_FLAG
- END_CUSTOMER / LAST_UPDATE_DATE / LAST_UPDATED_BY
- REP_SHIPTO_CODE / REP_SOLDTO_CODE / SSCM_SITE_ID
- SHIP_PLAN_AUTO / SITE_DESCRIPTION / SITE_VALID_YN
- SOLDTO_CUSTOMER / TEAM_EDIT_FLAG / TEAM_ID / TEAM_NAME / VMI_YN / REP_YN

**SSPM sub (~40 column)** — 대량 column:
- BPMS_EXIST / CATHODE_MATERIALS / CELL_NAME / CELL_PER_CAR / CELL_PER_MODULE
- CELL_TYPE / CELL_TYPE_81 / CELL_TYPE_82 / CONTRIBUTION_TYPE / CURRENCY
- CUST_GROUP / CUST_GROUP_DTL / CUSTOMER_MODEL / DEPT_ID / DEPT_ID2
- DIVISION_ID / EDI / EDI_LT / EDIT_FLAG / EDIT_FLAG2 / EDIT_FLAG3
- END_CUSTOMER / END_CUSTOMER40 / ITEM_CLASS_NAME / ITEM_ID / ITEM_NAME / ITEM_TYPE
- KWH / LAST_UPDATE_DATE / LAST_UPDATED_BY / LIABILITY_PERIOD
- MODULE_PER_CAR / MODULE_VARIANT / NICK_NAME / OS_CORP / OWNER
- PARTIAL_PLAN_YN / PRODUCTION_PROCESS / PROJECT_CODE / PROJECT_NAME / PROJECT_OWNER / PROJECT_STATUS
- ROUTE / SALES_COMPANY / SALES_PLAN_ADJUST_YN / SALES_PLANT
- SCM_SITE_ID / SCM_SITE_ID40 / SHIPTO_CODE / SHIPTO_DESCRIPTION
- SOLDTO_CODE / SOLDTO_CUSTOMER / SOLDTO_DESCRIPTION / USER_ID / VALID_YN / VMI_LT

→ **40+ column 의 대량 grid** (SSPM). G4 (Batch) 검증 후보.

## §2 Screen Lifecycle

| 단계 | 메서드 | line | 동작 |
|---:|---|---:|---|
| 1 | Form_Load | 260 | InitForm + InitControls + CreateSpread + DefineProperty + InitEvent + InitSaveDataTable + GetUpdateHistory |
| 2 | InitControls | 331 | Filter 패턴 사용 (`SetChangeControl` — Phase 1 Big Filter 패턴 변형) + cascade combo (Division → Team → EndCustomer → SalesSite) |
| 3 | CreateSpread | 416 | 2 spread (spdSummary + spdRepair) + 1 spdSub (2 tab) AddSheet + InitSpread |
| 4 | InitSpread | 446 | GetSpdTitle → CreateSheetHeaderColumn (동적 column) |
| 5 | InitEvent | 452 | DataModel.Changed event 등록 (cascade row 처리) |

## §3 CRUD 6대 override

| 메서드 | line | body 요약 |
|---|---:|---|
| `FindButton` | 503 | fps.Name 분기 — spdSummary → FindData_Main / spdSub → (Sub 별도 trigger) |
| `InsertButton` | 522 | InsertRow() — sheet 별 LockRange 매우 복잡 |
| `DeleteButton` | 527 | **빈 메서드 (delete 기능 없음)** — INSERT/UPDATE 만 |
| `EditButton` | 532 | 권한 cross-check ("SCP Planner" → MSG00096) + Sub sheet 별 60+ LockRange 조건 |
| `SaveButton` | 700 | Sub 분기 — SaveSalesSite / SaveSSPM |
| `ExcelButton` | (default) | BaseForm.ExportExcel 자동 |

> ⚠️ **AS-IS 의 새 패턴 발견**:
> - **권한 cross-check** in EditButton — `"SCP Planner"` 그룹 명시적 차단 → MSG00096
> - **delete 기능 없음** — DMF0015 와 다른 패턴 (master 데이터는 deactivate 으로 처리)
> - **60+ LockRange 조건** — Division/Sheet/EditFlag 3축 분기 — 매우 복잡한 cell 별 권한
> - **2 spread 구조** — Master spdSummary + Repair spdRepair (보조) → DMF0015 의 Master + Sub 와 다름

## §4 Search Aux 4대

| 메서드 | override | 비고 |
|---|---|---|
| Sort/Filter/Condition/ResetCondition | X (BaseForm default) | UsrConditionPanel 사용 → G1 자동 활성 |

## §5 Validation 인벤토리

| Msg ID | trigger | 의미 |
|---|---|---|
| MSG00096 | EditButton ("SCP Planner") | 권한 없음 |
| MSG00108 | FindData (Period from > to) | 기간 순서 오류 |
| MSG00130 | EditButton (Summary 잠금 아님) | Sub 편집 충돌 |
| MSG00164 | FindData (3 년 초과) | 3 년 한도 |
| MSG00091 | (저장 검증 — 추정) | 데이터 검증 |
| MSG00092 / 060 / 002 / 137 / 357 / 379 / 136 / 141 / 358 / 166 | (저장 검증 — Phase 1 Explore agent 보고) | 다양한 validation |

→ Phase 1 보고대로 **20+ MSG ID** 사용 (DMF0015 의 8 보다 많음).

## §6 Event 인벤토리

| Grid/컨트롤 | event | handler | line | 동작 |
|---|---|---|---:|---|
| spdSummary | CellDoubleClick | spdSummary_CellDoubleClick | 1494 | sub sheet refresh (FindData_SubSalesSite / FindData_SubSalesSiteProjectModel) |
| spdRepair | CellDoubleClick | spdRepair_CellDoubleClick | 1546 | (Repair 행 클릭 시 동작) |
| spdMain | ComboSelChange | spdMain_ComboSelChange | 1582 | (cascade combo) |
| spdSub | ComboSelChange | spdSub_ComboSelChange | 1596 | Division 등 cascade |
| spdSub | CellDoubleClick | spdSub_CellDoubleClick | 1706 (+2628) | **popup 호출 (6+ popup)** |
| spdMain | EditChange | spdMain_EditChange | 2010 | EditFlag 자동 설정 |
| spdSub | EditChange | spdSub_EditChange | 2026 | EditFlag 자동 |
| spdSub | ActiveSheetChanging | spdSub_ActiveSheetChanging | 2034 | tab 전환 시 검증 |
| spdSub | SheetTabClick | spdSub_SheetTabClick | 2046 | tab click 시 |
| spdMain / spdSub | TopChange | (2484, 2491) | SmartColMerge 재적용 |
| spdMain / spdSub | LeaveCell | (2067, 2899) | row 변경 차단 |
| **DataModel.Changed** | shtSALES_SITEDataModel_Changed | 2080 | **cascade row 처리** — Division 변경 시 의존 column 자동 갱신 |
| **DataModel.Changed** | shtSSPMDataModel_Changed | 2279 | 동일 (SSPM sheet) |
| **DataModel.Changed** | shtSummaryDataModel_Changed | 2391 | Summary sheet |
| **DataModel.Changed** | spdSub_Changed | 2786 | 통합 changed |
| clbDivision | SelectedIndexChanged | clbDivision_SelectedIndexChanged | 1566 | cascade FromSite 등 |

> ⚠️ **DataModel.Changed 4 종 동시 사용** — DMF0015 (1 종) 대비 복잡. cell 단위 cascade 처리 의무.

## §7 API / SP 호출 인벤토리

| # | SP / 메서드 | 호출 위치 | parameter | 결과 |
|---:|---|---|---|---|
| 1 | `DM.DMF0008_GET_EDI_MST_SUMMARY` | FindData_Main (727) | p_from_yyyymmdd, p_to_yyyymmdd, p_division_id (CommandTimeout 10*60) | DataSet (Main) |
| 2 | `DM.DMF0008_GET_EDI_MST_REPAIR` | FindData_SubRepair (800) | p_from_yyyymmdd, p_to_yyyymmdd, p_sender_name, p_division_id | DataSet (Repair) |
| 3 | `DM.DMF0008_GET_SALES_SITE` | FindData_SubSalesSite (895) | p_division_id, p_soldto, p_shipto | DataSet (Sales Site) |
| 4 | `DM.DMF0008_GET_SALES_SITE_PROJECT_MODEL` | FindData_SubSalesSiteProjectModel (946) | p_item_id, p_division_id, p_scm_site_id | DataSet (SSPM) |
| 5 | (저장 SaveSalesSite) | line 1000+ | (다수 IN) | 저장 |
| 6 | (저장 SaveSSPM) | line ~1200 | (다수 IN, 40 column) | 저장 |
| 7 | `DataService.GetDMInnerTable("MyDivision"/"UserTeamByDivision"/"EndCustomerByDivision"/"UserSiteByEndCustomer"/"ScmSitebyEndCustomer40")` | SetChangeControl (283) | filter | 5 lookup |
| 8 | `Data.Common(SoldCustomer / Auth_Dept / SpreadTitle / YesOrNo / Incoterms)` | various | varies | lookup |
| 9 | `DataService.FP_Log2("SpeedUp", "DMF0008", "division_id_changed", "start"/"end")` | InitControls | - | **G3 Performance log** (FP_Log2) — DMF0015 와 차이! |

> ⚠️ **G3 PerfLog 의 AS-IS 실 사용 사례 발견** — DMF0008 의 InitControls 에서 SpeedUp log. 룰 v2 의 G3 `usePerfTrace` 검증 후보.

## §8 Expression / Auto-Sync 인벤토리

| 패턴 | line | 의미 |
|---|---:|---|
| `siSub.LockRange(iRow, col, iRow, col, true)` × **60+** | EditButton 463-690 | Division 81/82/40 + Sheet (Sales/SSPM) + EditFlag (Insert/Modify) 3 축 분기로 60+ LockRange 호출 |
| `cellTypeImage = new TextCellType()` + `BackgroundImage = imageList1.Images[0]` | DefineProperty 403 | popup 셀에 image (cellTypeImage) — DMF0015 에 없는 패턴 |
| `siSub.ImagePopUp = imageList1.Images[0]` | 402 | popup image |
| 4 DataModel.Changed events | 2080~2391 | cascade row 처리 (Division 변경 시 의존 column 자동) |

## §9 Combo / Lookup 인벤토리

### §9.1 조회조건 combo
- clbDivision / clbTeam / clbEndCustomer / clbSalesSite / clbSoldToCode / clbShipToCode / cboActive (7)

### §9.2 Sub grid cell combo
- Division 별로 다른 column set (Division 40 에 6 추가 column, 82 에 4 추가) — **Division 별 cell 가용성 분기**

### §9.3 Lookup SQL_ID
- MyDivision / UserTeamByDivision / EndCustomerByDivision / UserSiteByEndCustomer / ScmSitebyEndCustomer40
- SoldCustomer / Auth_Dept / Incoterms / YesOrNo
- ItemType / Country / City / Plant / Currency / Project / CustomerGroup / SalesCompany / SalesPlant / DistributionChannel (Sub grid 의 cell combo 다수)

→ 20+ lookup SQL_ID. G2 `useBigFilterDM` 의 robust 검증 후보.

## §10 Popup 호출 인벤토리

> spdSub_CellDoubleClick (1706 + 2628) 안에 popup 호출 — Phase 1/2 Explore agent 보고에서 식별된 6 popup:

| AS-IS Popup | TO-BE Modal | 격차 |
|---|---|---|
| `SCM0002_CustomerbyDivisionPopup` | CustomerModal | ✅ 매핑 |
| `SCM0002_CityPopup` | RegionModal | ✅ |
| `SCM0002_TeamPopup` | TeamModal | ✅ |
| `SCM0002_ProjectbyDivisionPopup` | ProjectByDivisionModal | ✅ |
| `DM0002_ItembySmallDivPopup` | ItemByDivisionModal (확장) | ⚠️ **G13 후보** (ItembySmallDiv 의 정밀 매핑 — preSearchParams 확장 필요) |
| `DMF000_OwnerSet_Popup` | OwnerByDivisionModal | ⚠️ 매핑 확인 |

> ⚠️ **G13 격차 후보 발견**: `DM0002_ItembySmallDivPopup` — DMF0008 의 SSPM grid 의 Item 선택 popup (small division 기반 — DMF0015 의 ItemBySite 와 다른 변형)

## §11 Dynamic Column

| 패턴 | 위치 | source |
|---|---|---|
| `GetSpdTitle(sheetname)` | line 2516 | SP `SpreadTitle` (사용자 별 column setting) |
| 4 sheet 각각 CreateSheetHeaderColumn | InitSpread | 동적 column 4 sheet |
| Division 별 column 가용성 분기 (40/81/82) | EditButton + DataModel.Changed | **Division 별 cell coloring + lockable** |

## §12 권한

| 패턴 | 위치 | 동작 |
|---|---|---|
| `UserInfoContext.Current["NowGroupID"] == "SCP Planner"` | EditButton 540 | SCP Planner 그룹은 Edit 차단 → MSG00096 |
| Filter["GROUP_ID"] / "USER_ID" | SetChangeControl 285 | SP 권한 cross-check |

→ AS-IS 화면 안에서 **명시적 권한 그룹 cross-check** — DMF0015 의 (BaseForm 자동 권한) 보다 강함.

## §13 로깅

| 패턴 | 위치 | 동작 |
|---|---|---|
| `DataService.FP_Log2("SpeedUp", "DMF0008", "division_id_changed", "start"/"end")` | InitControls 335/379 | 성능 trace (G3 매핑 후보) |
| `lblRepair_Cnt.Text = "정비 필요 합계 수량 : " + TotalCount` | FindData_SubRepair 863 | UI display (count log) |

## §14 TO-BE 매핑 종합

| AS-IS 요소 | TO-BE 매핑 | 위치 |
|---|---|---|
| 4 sheet (Summary + Repair + Sales_Site + SSPM) | `SHEETS = { MAIN, REPAIR, SALES_SITE, SSPM }` + `gridRefs[4]` | constants + Main 컴포넌트 |
| `FindButton override` (spdSummary 분기) | `hotkeyConfig.search = handleSearchMain` + activeTab 별 분기 | Main 컴포넌트 |
| `InsertButton override` | `handleInsert` + sheet 별 default value | 동일 |
| `DeleteButton override` (**빈 메서드**) | `hotkeyConfig.delete = false` (버튼 숨김) — AS-IS 의 의도 명시 | 동일 |
| `EditButton override` (60+ LockRange) | column meta `_inputEditType` per column (Division 별 분기 시 BE 가 column meta 동적 결정) | 룰 08 |
| `SaveButton override` (Sub 분기) | `handleSave` switch(activeTab) — SaveSalesSite / SaveSSPM | 동일 |
| `spdSummary_CellDoubleClick` (sub refresh) | dblClick → setSubFilter (Sales Site / SSPM) | Grid 컴포넌트 |
| `4 DataModel.Changed events` | `cellEditEnded` per sheet + cascade handler | 룰 07 §2.4 |
| `60+ LockRange Division 별 분기` | **BE 가 division 별 column meta 동적 응답** (column meta 의 `_inputEditType` 가 division dependent) | 룰 08 + BE BLOCK 6 의 division 분기 |
| `"SCP Planner" 그룹 차단` | `useSessionStore.session.currentGrId === 'SCP Planner'` 시 disable | Main 컴포넌트 |
| 4 SP 호출 | useTabProcQuery × 4 sheet | Main 컴포넌트 |
| **`FP_Log2("SpeedUp", ...)`** | **`usePerfTrace.measure('division_change', ...)`** | **G3 실전 검증** |
| 20+ MSG ID | i18n 등록 (BLOCK 1) | 메타 SQL |
| 6 popup (특히 ItembySmallDiv) | ItemByDivisionModal 확장 (G13) | 룰 10 |
| `cellTypeImage` (popup icon) | column meta `_ctrlType: 'FPModal' + _modalKey` | 룰 08 §1.3 |
| Division 별 cell 가용성 (40/81/82) | column meta 의 `_display` per division (BE 분기) | 룰 08 |
| SaveSalesSite + SaveSSPM (40+ column) | **G4 useBatchMutation 검증** — 대량 row 시 chunk | G4 |

## §15 G13 (ItembySmallDiv) 격차 식별

- **G13 후보**: `DM0002_ItembySmallDivPopup` 의 TO-BE 매핑
- ItemByDivisionModal 의 `preSearchParams` 에 추가 prop (smallDivision / sCmSiteId 등) 가능성
- 추가 분석 후 결정 — Phase 7 후속

## §16 Phase 7 PoC 가치

### §16.1 룰 v2 robust 검증
- DMF0015 (Master + Sub 2 sheet) 와 다른 변형 — **4 sheet (Master + Repair + Sub Tab 2)**
- 60+ LockRange Division 별 분기 → 룰 08 의 column meta 검증
- 4 DataModel.Changed events → 룰 07 §2.4 (cascade) 검증

### §16.2 격차 신규 검증
- **G3 PerfLog 실전 검증** — DMF0008 의 `FP_Log2("SpeedUp", ...)` 가 `usePerfTrace.measure` 로 매핑
- **G4 Batch 검증** — SSPM sheet 의 40+ column × N rows 저장 시 `useBatchMutation` chunk 처리

### §16.3 메타-룰 진화 기회
- DMF0015 의 룰 11 재작성과 유사하게 — DMF0008 의 60+ LockRange 패턴이 룰 08 의 결함 발견 가능?
- AS-IS `"SCP Planner"` 명시적 그룹 차단 → TO-BE 권한 메타로 표현 가능한지 검증
- 4 sheet 구조 (Master + Repair + Sub Tab 2) — 룰 03 §2.1 의 Multi-sheet 변형 확장 필요?
