=== FILE: analysis.md ===
# SCP0041 As-is 화면 분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SCP0041). Fact Pack에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 내용 |
|---|---|
| 화면 ID | SCP0041 |
| 클래스 | `SCP0041_StockOSP` |
| 도메인 | SCP (`GSCM.SCP.Forms.UIL\Master`) |
| 폼 Text (Designer) | `"Plant Qty"` (Designer.cs:765) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0041_StockOSP\SCP0041_StockOSP.csproj` |
| 시트 | `Osp Stock`, `Pack Hold Stock` (2개 시트, 탭 전환) |
| Grid 구성 방식 | `META(프레임워크) (+코드 표시/라벨 변경)` |
| 주석 처리된 호출 | 0건 |
| 확인 필요(정적 추출 단계) | 0건 (단, 본 문서 §7 에 해석상 확인 필요 항목 별도 기재) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄 수 |
|---|---|---:|
| current | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0041_StockOSP\Properties\AssemblyInfo.cs` | 37 |
| current | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0041_StockOSP\SCP0041_StockOSP.cs` | 900 |
| current | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0041_StockOSP\SCP0041_StockOSP.Designer.cs` | 821 |
| shared | 없음 (Fact Pack에 기재 없음) | - |
| legacy | 없음 (Fact Pack에 기재 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| # | 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---:|---|---|---:|---|---|---|
| 1 | event:this.Load | `Form_Load` > InitControls > GetLookupData | 165 | `SCM.SCM0001_GET_LOOKUP_VALUES` | MATCH | SCM0001_GET_LOOKUP_VALUES |
| 2 | event:this.Load | `Form_Load` > InitControls > setPeriod | 549 | `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | BIZ_MATCH | (Biz 공통: UP_FX_GetCommonDataList) |
| 3 | event:spdMain.SheetTabClick | `SpdMain_SheetTabClick` > SetSelectMenu > setPeriod | 549 | `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | BIZ_MATCH | (Biz 공통: UP_FX_GetCommonDataList) |
| 4 | button:FindButton | FindButton > FindData_Main | 662 | `SCP.SCP0041_GET_STOCK_OSP` | MATCH | SCP0041_GET_STOCK_OSP |
| 5 | button:FindButton | FindButton > FindData_Pack | 740 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | MATCH | SCP0041_GET_PACK_HOLD_STOCK |
| 6 | button:SaveButton | SaveButton > SaveDataPacker | 469 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` | MATCH | SCP0041_SAVE_PACKER_HOLD_STOCK |
| 7 | button:SaveButton | SaveButton > SaveDataPacker > FindData_Pack (저장 후 재조회) | 740 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` | MATCH | SCP0041_GET_PACK_HOLD_STOCK |
| 8 | **unreached (진입점 미연결)** | SaveData | 354 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | MATCH | SCP0040_SAVE_CHARACTERISTIC_CAPA |

- FindButton 은 FindData_Main(Osp Stock)과 FindData_Pack(Pack Hold Stock) 두 경로를 모두 가집니다. 활성 시트에 따라 분기하는지, 둘 다 호출하는지는 정적 흐름만으로는 판단되지 않습니다 → **확인 필요**.
- SaveButton 의 현행 경로는 SaveDataPacker(`Pack Hold Stock` 저장)뿐입니다.
- `SaveData`(→ `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA`)는 **어떤 진입점에서도 도달하지 않는 메서드**입니다. SP 이름이 타 화면(SCP0040) 소관이므로 복사 잔존 코드로 보입니다 → **확인 필요**(TO-BE 이관 대상 여부).

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | 호출 메서드:줄 | SP | 참조 객체 (SP 내부 EXEC 전이 포함) |
|---|---|---:|---|---|---|
| `SCM.SCM0001_GET_LOOKUP_VALUES` | MATCH | 1 | GetLookupData:165 | SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] | BIZ_MATCH | 1 | setPeriod:549 (via Data.CallBizCommonData) | - | 코드분기 UP_FX_GetCommonDataList: SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME |
| `SCP.SCP0041_GET_STOCK_OSP` | MATCH | 1 | FindData_Main:662 | SCP0041_GET_STOCK_OSP | EXEC:SCP0041_GET_STOCK_OSP, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_DNM_STOCK_OSP, SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN |
| `SCP.SCP0041_GET_PACK_HOLD_STOCK` | MATCH | 1 | FindData_Pack:740 | SCP0041_GET_PACK_HOLD_STOCK | EXEC:SCP0041_GET_PACK_HOLD_STOCK, SELECT:SCM_MST_SITE, REF:FN_GET_ITEM_NICKNAME, REF:FN_GET_USER_NAME, SELECT:SCM_DNM_STOCK_LOT_CONTROL, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN, SELECT:SCM_MST_SSO_USER_INFO |
| `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` | MATCH | 1 | SaveDataPacker:469 | SCP0041_SAVE_PACKER_HOLD_STOCK | EXEC:SCP0041_SAVE_PACKER_HOLD_STOCK, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCM_DNM_STOCK_LOT_CONTROL, INSERT:SCM_SYS_LOG_BATCH |
| `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` | MATCH (**미도달**) | 1 | SaveData:354 | SCP0040_SAVE_CHARACTERISTIC_CAPA | EXEC:SCP0040_SAVE_CHARACTERISTIC_CAPA, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_CHARACTERISTIC_HIST, MERGE:SCP_MST_CHAR_CAPA, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_CHAR_CAPA_H |

### 3-1. 코드에서 읽는 DB 컬럼
| 메서드 | 줄 | 대상 | 컬럼 |
|---|---:|---|---|
| setPeriod | 558 | dt.Rows[0] | FROM_VALUE |
| setPeriod | 559 | dt.Rows[0] | TO_VALUE |

→ PERIOD_DEFAULT 공통데이터 결과 1행의 FROM_VALUE/TO_VALUE 로 기간(Period) 기본값을 설정합니다. 어느 DateRangePicker(dCalendar / dCalendarCutoff)에 적용하는지는 **확인 필요**.

### 3-2. 프레임워크 메타 소비 메서드
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | SetSpreadInit:211 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| GetCheckedListValue | SetChangedControl:520, FindData_Main:639, FindData_Main:640, FindData_Pack:712, FindData_Pack:713, FindData_Pack:718 | CString.GetCheckedListValue | CODE |

## 4. 이벤트 배선 표

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 연결 엔드포인트(흐름 기준) |
|---|---|---|---|---|
| this.btnExcelUpload | Click | `btnExcelUpload_Click` | Designer InitializeComponent:380 | 추출된 엔드포인트 없음 → **확인 필요** |
| this.formDown | Click | `btnExcelFormDownload_Click` | Designer InitializeComponent:419 | 추출된 엔드포인트 없음 → **확인 필요** |
| this | Load | `Form_Load` | .ctor:117 | `SCM.SCM0001_GET_LOOKUP_VALUES`, `biz:CommonData.CommonDataList` |
| btnItemId | Click | `BtnItemId_Click` | InitEvent:219 | 없음 (txtItemId.Text = sItemId 설정, :882) |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:220 | 추출된 엔드포인트 없음 → **확인 필요** |
| spdMain | SheetTabClick | `SpdMain_SheetTabClick` | InitEvent:221 | `biz:CommonData.CommonDataList` (SetSelectMenu > setPeriod) |
| this.spdMain | EditChange | `SpdMain_EditChange` | InitEvent:223 | 없음 |
| this.siMain.ActiveSheet | CellChanged | `ActiveSheet_CellChanged` | InitEvent:224 | 없음 |

공통 툴바 버튼(오버라이드): FindButton, SaveButton, EditButton(EditButton:268 — `iFocusTabIndex == 1` 조건 하에서만 GetSheetInfo 수행).

## 5. Grid 구성 방식

- 구성 방식: **`META(프레임워크) (+코드 표시/라벨 변경)`**
- 코드가 `AddSheet` 로 시트 2개 생성 (CreateSpread:174 `Osp Stock` = SpdSheet.shtMain, CreateSpread:177 `Pack Hold Stock` = SpdSheet.shtPacker, 각 인자 `1 ¦ 1 ¦ 35`).
- SetSpreadInit:203~209 — `sheetName.Equals("Osp Stock")` 이면 시트 0, 아니면 시트 1을 ChangeSheet/InitSheet 후, SetSpreadInit:211 에서 `SetSheetHeaderColumn(siMain, 1)` 로 메타(SCM_MST_SHEET_COLUMNS) 기반 컬럼 생성.
- InitSpread:195~196 — 초기 활성 시트 = 0 (`Osp Stock`).
- 코드 표시/라벨 변경은 Designer InitializeComponent:665~668 의 ColumnHeader 기본 스타일(HorizontalAlignment/VerticalAlignment=General, NoteIndicatorColor=Red, Parent=ColumnHeaderDefaultEnhanced)뿐이며 컬럼 단위 하드코딩은 없습니다.

### 5-1. division별 차이

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Osp Stock | META+코드연결 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 | 14 |
| Pack Hold Stock | META+코드연결 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

→ 모든 division 에서 **컬럼 구성이 같습니다**(메타 전 컬럼 `기본`, 선택 컬럼 0, 코드 분기 0건).

## 6. DB 메타 데이터 현황 (화면 ID 기준)

| 메타 테이블 | 행 수 |
|---|---:|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 14 |
| dbo.SCM_ADM_EXCEL_COLUMNS | 1 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 8 |
| dbo.SCM_MST_SHEET_COLUMNS | 29 |
| dbo.TB_FX_Favorite | 38 |
| dbo.TB_FX_GroupMenuAuth | 9 |
| dbo.TB_FX_MenuItemInfo | 1 |
| dbo.TB_FX_ProgramInfo | 1 |
| dbo.TB_FX_SearchCondition | 34 |

## 7. 확인 필요 항목

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SaveData` → `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` 는 진입점에 연결되지 않음. TO-BE 이관 제외 여부 | flow.csv unreached |
| 2 | FindButton 이 활성 시트에 따라 FindData_Main / FindData_Pack 중 하나만 호출하는지, 둘 다 호출하는지 | flow 2경로 동시 추출 |
| 3 | `btnExcelUpload_Click` / `btnExcelFormDownload_Click` 의 처리 내용(업로드 대상 시트, 저장 SP). 엔드포인트가 추출되지 않음. SCM_ADM_EXCEL_COLUMNS 1행과의 관계 | events.csv, §6 |
| 4 | `CboDivision_SelectedIndexChanged` 처리 내용(Plant Site 재조회 여부 등) | 엔드포인트 미추출 |
| 5 | `SCM.SCM0001_GET_LOOKUP_VALUES` 결과가 바인딩되는 컨트롤(cboStatus 추정이나 근거 없음) | GetLookupData:165 |
| 6 | setPeriod 의 FROM_VALUE/TO_VALUE 적용 대상 DateRangePicker | meta_reads.csv |
| 7 | `layoutInspection` 라벨은 Designer `"Inspection"` → 런타임 `DefPackLabel.INSEPECTION_ID` 로 교체. 실제 표시 문구 | props.csv InitControls:156 |
| 8 | `usrButton1`(부모 없음) 사용 여부 | controls.csv |
| 9 | EditButton 이 `iFocusTabIndex == 1`(Pack Hold Stock 추정) 일 때만 동작하는 의미 | grid_code.csv EditButton:268 |
| 10 | 시트 탭 전환 시 조회조건(Inspection/Status/Cutoff Date 등) 표시 전환 여부(SetSelectMenu 내용) | flow.csv |

=== FILE: source_links.md ===
# SCP0041 소스 링크 표

기준 경로 접두: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0041_StockOSP\`

## 1. 엔드포인트 호출 지점 (전수)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | GetLookupData | 165 | `SCM.SCM0001_GET_LOOKUP_VALUES` 호출 (Form_Load > InitControls) |
| SCP0041_StockOSP.cs | SaveData | 354 | `SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA` 호출 — **진입점 미연결** |
| SCP0041_StockOSP.cs | SaveDataPacker | 469 | `SCP.SCP0041_SAVE_PACKER_HOLD_STOCK` 호출 (SaveButton) |
| SCP0041_StockOSP.cs | setPeriod | 549 | `biz:CommonData.CommonDataList` [code=PERIOD_DEFAULT] (Data.CallBizCommonData) |
| SCP0041_StockOSP.cs | FindData_Main | 662 | `SCP.SCP0041_GET_STOCK_OSP` 호출 (FindButton) |
| SCP0041_StockOSP.cs | FindData_Pack | 740 | `SCP.SCP0041_GET_PACK_HOLD_STOCK` 호출 (FindButton, SaveDataPacker 후) |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | .ctor | 117 | `this.Load += Form_Load` |
| SCP0041_StockOSP.cs | InitEvent | 219 | `btnItemId.Click += BtnItemId_Click` |
| SCP0041_StockOSP.cs | InitEvent | 220 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| SCP0041_StockOSP.cs | InitEvent | 221 | `spdMain.SheetTabClick += SpdMain_SheetTabClick` |
| SCP0041_StockOSP.cs | InitEvent | 223 | `this.spdMain.EditChange += SpdMain_EditChange` |
| SCP0041_StockOSP.cs | InitEvent | 224 | `this.siMain.ActiveSheet.CellChanged += ActiveSheet_CellChanged` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 380 | `this.btnExcelUpload.Click += btnExcelUpload_Click` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 419 | `this.formDown.Click += btnExcelFormDownload_Click` |

## 3. Grid 생성·메타 소비

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | CreateSpread | 174 | AddSheet `Osp Stock` (SpdSheet.shtMain, 1¦1¦35) |
| SCP0041_StockOSP.cs | CreateSpread | 175 | GetSheetInfo(spdMain.Name, ActiveSheetIndex) |
| SCP0041_StockOSP.cs | CreateSpread | 177 | AddSheet `Pack Hold Stock` (SpdSheet.shtPacker, 1¦1¦35) |
| SCP0041_StockOSP.cs | CreateSpread | 178 | GetSheetInfo |
| SCP0041_StockOSP.cs | CreateSpread | 180 | ChangeSheet |
| SCP0041_StockOSP.cs | InitSpread | 195 | ChangeSheet(0) |
| SCP0041_StockOSP.cs | InitSpread | 196 | ChangeActiveSheet(SpdSheet.shtMain = `Osp Stock`) |
| SCP0041_StockOSP.cs | SetSpreadInit | 203–204 | `if(sheetName.Equals("Osp Stock"))` → ChangeSheet(0)/InitSheet(0) |
| SCP0041_StockOSP.cs | SetSpreadInit | 208–209 | else → ChangeSheet(1)/InitSheet(1) |
| SCP0041_StockOSP.cs | SetSpreadInit | 211 | `SetSheetHeaderColumn(siMain, 1)` — 메타 컬럼 생성 |
| SCP0041_StockOSP.cs | EditButton | 268 | `if(iFocusTabIndex == 1) ⟫ … ⟫ GetSheetInfo` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 665–668 | ColumnHeader 기본 스타일 (정렬 General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 조회조건 값 추출(GetCheckedListValue) · 메타/데이터 읽기

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | SetChangedControl | 520 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Main | 639 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Main | 640 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Pack | 712 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Pack | 713 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | FindData_Pack | 718 | GetCheckedListValue (CODE) |
| SCP0041_StockOSP.cs | setPeriod | 558 | `dt.Rows[0]["FROM_VALUE"]` |
| SCP0041_StockOSP.cs | setPeriod | 559 | `dt.Rows[0]["TO_VALUE"]` |

## 5. 런타임 속성 변경

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.cs | InitControls | 156 | `layoutInspection.Text = DefPackLabel.INSEPECTION_ID` |
| SCP0041_StockOSP.cs | BtnItemId_Click | 882 | `txtItemId.Text = sItemId` |

## 6. Designer 주요 컨트롤 선언/속성

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0041_StockOSP.Designer.cs | (선언) | 33–59 | 컨트롤 27개 선언 |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 119–124 | usrConditionPanel1 Dock=Top, Size(1469,48), HidePanel |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 519 | Division Text `"Division*"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 533 | layoutControlItem7 Text `"Plant Site"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 551 | lblItemId Text `"Model"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 376 | btnExcelUpload Text `"Upload"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 416 | formDown Text `"Excel Form"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 605 | layoutControlItem5 Text `"Period*"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 620 | layoutInspection Text `"Inspection"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 635 | layStatus Text `"Status"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 643–648 | spdMain Dock=Fill, Size(1469,554) |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 751 | layoutCutoffDate Text `"Cutoff Date"` |
| SCP0041_StockOSP.Designer.cs | InitializeComponent | 765 | 폼 Text `"Plant Qty"` |

=== FILE: web_components.md ===
# SCP0041 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 라벨 출처 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | LayoutControlItem `Division`.Text | 공용 Division 콤보 | 필수(`*`). SelectedIndexChanged 처리 내용 확인 필요 |
| clbPlantSite | UsrCheckedList | `Plant Site` | layoutControlItem7.Text | 공용 멀티선택 콤보 | GetCheckedListValue(CODE) 로 값 전달 |
| txtItemId | UsrMultiLineEditor | `Model` | lblItemId.Text | 멀티라인 입력 | BtnItemId_Click 결과가 Text 로 설정(:882) |
| btnItemId | UsrButton | (Text 없음) | layoutControlItem4 | 모델 검색 팝업 버튼 | 팝업 대상 확인 필요 |
| dCalendar | UsrDateRangePicker3 | `Period*` | layoutControlItem5.Text | 공용 기간(DateRange) 컨트롤 | 필수. PERIOD_DEFAULT 기본값 적용 대상 여부 확인 필요 |
| txtInspection | UsrMultiLineEditor | `Inspection` (런타임 `DefPackLabel.INSEPECTION_ID`) | layoutInspection.Text | 멀티라인 입력 | 런타임 라벨 문구 확인 필요 |
| cboStatus | UsrCombo | `Status` | layStatus.Text | 공용 콤보 | 데이터 원천 확인 필요 |
| dCalendarCutoff | UsrDateRangePicker3 | `Cutoff Date` | layoutCutoffDate.Text | 공용 기간 컨트롤 | |
| btnExcelUpload | UsrButton | `Upload` | 컨트롤 Text | 엑셀 업로드 버튼 | layoutControlItem1 의 Text 미지정 |
| formDown | UsrButton | `Excel Form` | 컨트롤 Text | 엑셀 양식 다운로드 버튼 | layoutControlItem2.Text 는 `"layoutControlItem1"`(라벨 비표시 여부 확인 필요) |
| usrButton1 | UsrButton | - | - | 없음 | 부모 미지정 — 사용 여부 확인 필요 |
| usrConditionPanel1 | UsrConditionPanel | - | - | 조회조건 영역 | HidePanel 형 |
| usrLayoutControl2 / layoutControlGroup2 / emptySpaceItem1 | 레이아웃 | - | - | 조회조건 레이아웃 | |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | - | Wijmo FlexGrid + 시트 탭 | 시트 2개(`Osp Stock`, `Pack Hold Stock`) |

## 2. 화면 배치

- props.csv 에 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 없음).
- 배치는 Dock 기반 상/하 구성입니다.

| 영역 | 컨트롤 | Dock | Size | 비율(높이) |
|---|---|---|---|---:|
| 상단 | usrConditionPanel1 (조회조건) | Top | 1469 × 48 | 약 8% (48/602) |
| 하단 | spdMain (Grid, 시트 탭 2개) | Fill | 1469 × 554 | 약 92% (554/602) |

조회조건 배치 순서는 Designer 상 위치 좌표가 Fact Pack에 없어 **확인 필요**합니다. 너비(LayoutControlItem Size): Division 75 · Plant Site 172 · Model 141 · 모델버튼 43 · Upload 103 · Excel Form 103 · Period 260 · Inspection 166 · Status 114 · Cutoff Date 260.

## 3. 시트별 Grid 컬럼 (grid_effective 기준)

모든 컬럼의 출처는 META(SCM_MST_SHEET_COLUMNS)이고, 14개 division 전부 `기본`(표시)입니다. 코드로 추가하거나 숨기는 컬럼은 없습니다.

### 3-1. `Osp Stock` (14컬럼)

| # | COLUMN_NAME | 라벨 | 출처 | division 차이 |
|---:|---|---|---|---|
| 1 | ATTRIBUTE1 | Valuation Type | META | 없음 (전 division 기본) |
| 2 | ATTRIBUTE2 | Cell From Site | META | 없음 |
| 3 | ATTRIBUTE3 | Box | META | 없음 |
| 4 | COMMENT | Comment | META | 없음 |
| 5 | CREATED_BY | Created By | META | 없음 |
| 6 | CREATION_DATE | Creation Date | META | 없음 |
| 7 | DIVISION_ID | Division* | META | 없음 |
| 8 | ITEM_ID | Model* | META | 없음 |
| 9 | LAST_UPDATE_DATE | Last Update Date | META | 없음 |
| 10 | LAST_UPDATED_BY | Last Updated By | META | 없음 |
| 11 | NICK_NAME | Nick Name | META | 없음 |
| 12 | QTY | Qty* | META | 없음 |
| 13 | SITE_DESCRIPTION | Plant Site* | META | 없음 |
| 14 | YYYYMMDD | Date* | META | 없음 |

※ 표는 grid_effective.csv 행 순서(컬럼명 순)입니다. 실제 표시 순서·폭·정렬·편집 여부는 메타(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE 등) 원문을 보고 **확인해야** 합니다.

### 3-2. `Pack Hold Stock` (15컬럼)

| # | COLUMN_NAME | 라벨 | 출처 | division 차이 |
|---:|---|---|---|---|
| 1 | CREATION_DATE | Create Date | META | 없음 |
| 2 | CUTOFF_DATE | Cutoff Date | META | 없음 |
| 3 | DATE_FINISH_REAL | 실제 완료일 | META | 없음 |
| 4 | DATE_FORECAST_FINISH | 예상 완료일 | META | 없음 |
| 5 | DATE_FORECAST_START | 예상 시작일 | META | 없음 |
| 6 | DIR | Status | META | 없음 |
| 7 | INSPECTION_ID | 관리번호 | META | 없음 |
| 8 | MODIFIER | 수정자 | META | 없음 |
| 9 | MODIFIER_DATE | Change Date | META | 없음 |
| 10 | NICK_NAME | Nick Name | META | 없음 |
| 11 | PLANT_ID | PLANT | META | 없음 |
| 12 | PROD_ID | Model | META | 없음 |
| 13 | QTY | 수량 | META | 없음 |
| 14 | REQUSET_USER | 변경점 신청자 | META | 없음 |
| 15 | SITE_DESCRIPTION | Plant Site | META | 없음 |

※ 컬럼명 `REQUSET_USER` 는 메타 원문 표기(오타형) 그대로입니다. 라벨에 한국어/영어가 섞여 있어(메타 원문) TO-BE 다국어 LBL 매핑을 확인해야 합니다.

### 3-3. 코드 표시/라벨 변경
| 줄 | 내용 | 적용 범위 |
|---:|---|---|
| Designer:665 | HorizontalAlignment = General | ColumnHeader 기본 스타일 |
| Designer:666 | NoteIndicatorColor = Red | ColumnHeader 기본 스타일 |
| Designer:667 | Parent = ColumnHeaderDefaultEnhanced | ColumnHeader 기본 스타일 |
| Designer:668 | VerticalAlignment = General | ColumnHeader 기본 스타일 |

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 생성 | 인덱스 | 조회 SP | 저장 SP |
|---|---|---|---:|---|---|
| `Osp Stock` | META+코드연결 | CreateSpread:174 AddSheet(SpdSheet.shtMain) | 0 (초기 활성) | SCP0041_GET_STOCK_OSP | 없음(현행 경로) |
| `Pack Hold Stock` | META+코드연결 | CreateSpread:177 AddSheet(SpdSheet.shtPacker) | 1 | SCP0041_GET_PACK_HOLD_STOCK | SCP0041_SAVE_PACKER_HOLD_STOCK |

- 두 시트는 마스터-디테일 관계가 아닌 **독립 탭**입니다(셀 선택으로 다른 시트를 조회하는 흐름이 추출되지 않음).
- 탭 전환(`SpdMain_SheetTabClick`) → SetSelectMenu → setPeriod(PERIOD_DEFAULT) 실행.
- EditButton 은 `iFocusTabIndex == 1` 조건에서만 시트 정보를 가져옵니다(편집은 `Pack Hold Stock` 전용으로 보이나 **확인 필요**).

=== FILE: oracle_migration.md ===
# SCP0041 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 엔드포인트 | 현행 도달 | 유형 | 참조 테이블 | EXEC/함수 체인 |
|---|---|---|---|---|---|
| `SCM0001_GET_LOOKUP_VALUES` | SCM.SCM0001_GET_LOOKUP_VALUES | 도달 (Form_Load) | 조회(공통) | SELECT: SCM_ADM_LOOKUP_MASTER_DETAIL | - |
| `SCP0041_GET_STOCK_OSP` | SCP.SCP0041_GET_STOCK_OSP | 도달 (FindButton) | 조회 | SELECT: SCM_DNM_STOCK_OSP, SCM_MST_SITE, SCM_MST_ITEM_SN | REF: FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| `SCP0041_GET_PACK_HOLD_STOCK` | SCP.SCP0041_GET_PACK_HOLD_STOCK | 도달 (FindButton, 저장 후) | 조회 | SELECT: SCM_MST_SITE, SCM_DNM_STOCK_LOT_CONTROL, SCM_MST_ITEM_SN, SCM_MST_SSO_USER_INFO | REF: FN_GET_ITEM_NICKNAME, FN_GET_USER_NAME, STRING_SPLIT |
| `SCP0041_SAVE_PACKER_HOLD_STOCK` | SCP.SCP0041_SAVE_PACKER_HOLD_STOCK | 도달 (SaveButton) | 저장 | UPDATE: SCM_DNM_STOCK_LOT_CONTROL / INSERT: SCM_SYS_LOG_BATCH | EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SCP0040_SAVE_CHARACTERISTIC_CAPA` | SCP.SCP0040_SAVE_CHARACTERISTIC_CAPA | **미도달** (SaveData, 진입점 없음) | 저장 | MERGE: SCP_MST_CHAR_CAPA / INSERT: SCM_SYS_LOG_BATCH, SCP_MST_CHAR_CAPA_H | EXEC: PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_CHARACTERISTIC_HIST / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |

## 2. 공통코드 분기

| 호출 | code | 처리 | 참조 객체 |
|---|---|---|---|
| `biz:CommonData.CommonDataList` (Data.CallBizCommonData) | `PERIOD_DEFAULT` | UP_FX_GetCommonDataList 의 PERIOD_DEFAULT 분기 | SELECT: SCM_SYS_CALENDAR_M, REF: FN_MULTY_TIME |

- 결과 컬럼: FROM_VALUE, TO_VALUE (setPeriod:558–559) → 기간 기본값.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 상태가 `MATCH`/`BIZ_MATCH` 가 아닌 엔드포인트(미등록·불일치)는 **0건**입니다.
- 직접 SQL 문자열 호출은 추출되지 않았습니다.
- 주석 처리된 호출: 0건.

## 4. Oracle 전환 확인 포인트

| # | 대상 | 확인 포인트 | 근거 |
|---:|---|---|---|
| 1 | `SCP0041_GET_STOCK_OSP`, `SCP0041_GET_PACK_HOLD_STOCK` | **`STRING_SPLIT`(MSSQL 전용) 참조** — Oracle 에서는 금지 키워드이므로 TO-BE 표준 분해 방식(공통 분해 함수/GTT 등)으로 바꿔야 함. 멀티선택 인자(Plant Site 등 GetCheckedListValue 결과)로 보임 | objects REF:STRING_SPLIT, GetCheckedListValue FindData_Main:639/640, FindData_Pack:712/713/718 |
| 2 | `SCP0041_SAVE_PACKER_HOLD_STOCK` | 배열 분해 함수 `SCM_ARR_SPL_CNT` / `SCM_ARR_SPL_VAL` 의 Oracle 대응 객체 존재 여부 | objects REF |
| 3 | `SCP0041_SAVE_PACKER_HOLD_STOCK` | `PR_SCM_SYS_LOG_BATCH` 하위 호출·SCM_SYS_LOG_BATCH INSERT — 트랜잭션/COMMIT 위치 | EXEC 체인 |
| 4 | `SCP0041_GET_PACK_HOLD_STOCK` | `FN_GET_USER_NAME`, `FN_GET_ITEM_NICKNAME` 이 행마다 호출되는 스칼라 함수 — Oracle 이관 여부와 성능 | REF |
| 5 | `SCP0041_GET_PACK_HOLD_STOCK` | `SCM_MST_SSO_USER_INFO` 의 Oracle 측 존재 여부와 시노님 | SELECT |
| 6 | `SCP0041_GET_STOCK_OSP` | `SCM_DNM_STOCK_OSP` Oracle 이관 여부 | SELECT |
| 7 | `SCM0001_GET_LOOKUP_VALUES` | 공통 SP — 기존 Oracle 이관본 재사용 여부. SCM_ADM_LOOKUP_MASTER_DETAIL 에 SCP0041 행 1건(+이력 8건) | dbmeta |
| 8 | `SCP0040_SAVE_CHARACTERISTIC_CAPA` | SCP0041 에서는 도달하지 않음 → SCP0041 이관 범위에서 빼도 되는지 결정 필요(SCP0040 화면 소관) | flow unreached |
| 9 | PERIOD_DEFAULT | UP_FX_GetCommonDataList 분기의 `FN_MULTY_TIME` Oracle 대응 | 코드분기 |
| 10 | 메타 | SCM_MST_SHEET_COLUMNS 29행(14+15), SCM_ADM_EXCEL_COLUMNS 1행, TB_FX_SearchCondition 34행의 TO-BE 메타 이관 | dbmeta |

## 5. 난이도 (사실 근거)

| SP | 근거 사실 | 판단 |
|---|---|---|
| `SCM0001_GET_LOOKUP_VALUES` | 단일 SELECT, 공통 SP | 낮음 |
| `SCP0041_GET_STOCK_OSP` | SELECT 3테이블 + STRING_SPLIT + 함수 1 | 중 (STRING_SPLIT 치환 필요) |
| `SCP0041_GET_PACK_HOLD_STOCK` | SELECT 4테이블 + STRING_SPLIT + 함수 2 | 중 (STRING_SPLIT 치환, 함수 2종) |
| `SCP0041_SAVE_PACKER_HOLD_STOCK` | UPDATE 1 + INSERT 로그 + EXEC 1 + 배열 분해 함수 2 | 중 |
| `SCP0040_SAVE_CHARACTERISTIC_CAPA` | MERGE + INSERT 2 + EXEC 2 + 배열 분해 함수 2 (미도달) | 범위 결정이 먼저 필요 |

※ SP 본문 줄 수·커서·동적 SQL 여부는 Fact Pack에 없습니다 → SP 원문을 보고 **확인 필요**.

=== FILE: tobe_design.md ===
# SCP0041 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨(원문) | As-is 컨트롤 | 필수 표기 | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| Division* | cboDivision (UsrCombo) | `*` | Division 콤보 | 변경 이벤트 처리 내용 확인 필요 |
| Plant Site | clbPlantSite (UsrCheckedList) | - | 멀티선택 콤보 | CODE 값 전달 |
| Model | txtItemId (UsrMultiLineEditor) + btnItemId | - | 멀티라인 입력 + 검색 팝업 | |
| Period* | dCalendar (UsrDateRangePicker3) | `*` | 기간 컨트롤 | 기본값 = PERIOD_DEFAULT FROM/TO (적용 대상 확인 필요) |
| Inspection (런타임 DefPackLabel.INSEPECTION_ID) | txtInspection (UsrMultiLineEditor) | - | 멀티라인 입력 | |
| Status | cboStatus (UsrCombo) | - | 콤보 | 원천 확인 필요 |
| Cutoff Date | dCalendarCutoff (UsrDateRangePicker3) | - | 기간 컨트롤 | |

- 시트별로 쓰는 조회조건(예: Inspection/Status/Cutoff Date 가 `Pack Hold Stock` 전용인지)은 SetSelectMenu 원문을 보고 **확인해야** 합니다.
- TB_FX_SearchCondition 에 SCP0041 행이 34건 있습니다(내용은 확인 필요).
- 조회영역 버튼: `Upload`(btnExcelUpload), `Excel Form`(formDown).

## 2. 액션별 호출 API 후보

| 액션 | As-is 핸들러/경로 | API 후보 (SP) |
|---|---|---|
| 화면 진입 | `Form_Load` > InitControls > GetLookupData | SCM0001_GET_LOOKUP_VALUES |
| 화면 진입 / 탭 전환 | setPeriod (Form_Load, `SpdMain_SheetTabClick` > SetSelectMenu) | CommonDataList code=PERIOD_DEFAULT (UP_FX_GetCommonDataList) |
| 조회 (Osp Stock) | FindButton > FindData_Main | SCP0041_GET_STOCK_OSP |
| 조회 (Pack Hold Stock) | FindButton > FindData_Pack | SCP0041_GET_PACK_HOLD_STOCK |
| 저장 (Pack Hold Stock) | SaveButton > SaveDataPacker → FindData_Pack 재조회 | SCP0041_SAVE_PACKER_HOLD_STOCK → SCP0041_GET_PACK_HOLD_STOCK |
| 편집 | EditButton (iFocusTabIndex == 1) | API 없음 (그리드 편집 모드) |
| 모델 검색 | `BtnItemId_Click` | 추출 API 없음 → 팝업 대상 확인 필요 |
| Division 변경 | `CboDivision_SelectedIndexChanged` | 추출 API 없음 → 확인 필요 |
| 엑셀 업로드 | `btnExcelUpload_Click` | 추출 API 없음 → 확인 필요 (SCM_ADM_EXCEL_COLUMNS 1행) |
| 엑셀 양식 다운로드 | `btnExcelFormDownload_Click` | 추출 API 없음 → 확인 필요 |
| 셀 편집 | `SpdMain_EditChange`, `ActiveSheet_CellChanged` | API 없음 (변경 플래그 처리로 보임 — 확인 필요) |
| (미도달) | SaveData | SCP0040_SAVE_CHARACTERISTIC_CAPA — 이관 제외 후보 |

## 3. division별 Grid 변형 요약

| 시트 | 표시 컬럼 수 (14개 division 공통) | 변형 |
|---|---:|---|
| Osp Stock | 14 | 없음 |
| Pack Hold Stock | 15 | 없음 |

- 메타 선택 컬럼 0, 코드 분기 0건 → division 에 따라 컬럼이 바뀌지 않습니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 근거 |
|---|---|
| 조회(R): FindButton 오버라이드 존재 | flow.csv |
| 수정(U): SaveButton → SaveDataPacker(UPDATE SCM_DNM_STOCK_LOT_CONTROL) | flow.csv, objects |
| 편집 진입: EditButton 오버라이드(`iFocusTabIndex == 1` 조건) | grid_code.csv:268 |
| 생성(C)/삭제(D): 이 화면 SP 에서 INSERT/DELETE 대상 업무 테이블은 추출되지 않음(INSERT 는 SCM_SYS_LOG_BATCH 로그만) | objects |
| 메뉴 권한 메타: TB_FX_GroupMenuAuth 9행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 | dbmeta (내용 확인 필요) |

## 5. 미확정 사항

1. FindButton 의 시트별 분기 방식(활성 시트만 조회하는지, 둘 다 조회하는지).
2. 엑셀 업로드/양식 다운로드의 대상 시트·저장 SP.
3. `CboDivision_SelectedIndexChanged`, `BtnItemId_Click`(팝업 종류)의 처리 내용.
4. cboStatus 데이터 원천(SCM0001_GET_LOOKUP_VALUES 여부).
5. PERIOD_DEFAULT 기본값 적용 대상(dCalendar / dCalendarCutoff).
6. Inspection 라벨의 런타임 문구(DefPackLabel.INSEPECTION_ID).
7. `SaveData`(SCP0040_SAVE_CHARACTERISTIC_CAPA) 이관 제외 여부.
8. `Pack Hold Stock` 편집 가능 컬럼(메타 CELL_CONTROL_OBJECT_TYPE_CODE 등 원문 필요).
9. 시트 탭별 툴바 버튼 노출(Save/Edit 가 `Pack Hold Stock` 전용인지).
10. `usrButton1`(부모 미지정)의 용도.
