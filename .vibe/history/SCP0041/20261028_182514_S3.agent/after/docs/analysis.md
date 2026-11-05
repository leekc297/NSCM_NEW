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
