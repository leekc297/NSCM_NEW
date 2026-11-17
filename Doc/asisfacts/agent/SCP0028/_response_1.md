=== FILE: analysis.md ===
# SCP0028 Shipment Lot Size — AS-IS 분석

> 출처: AsisFacts 정적 추출 Fact Pack(SCP0028). Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0028 |
| 클래스 | `SCP0028_Shipment_Lot_Size` |
| 폼 Text | `SCP0028_Shipment_Lot_Size` (Designer.cs:724) |
| 도메인 | SCP (경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\…`) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0028_Shipment_Lot_Size\SCP0028_Shipment_Lot_Size.csproj` |
| 업무 성격 | Master 폴더에 있는 화면. 저장 SP가 `SCP_MST_SHIPMENT_LOT_SIZE`를 MERGE/DELETE함(§3) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `…\SCP0028_Shipment_Lot_Size\Properties\AssemblyInfo.cs` | 37 |
| current | `…\SCP0028_Shipment_Lot_Size\SCP0028_Shipment_Lot_Size.cs` | 784 |
| current | `…\SCP0028_Shipment_Lot_Size\SCP0028_Shipment_Lot_Size.Designer.cs` | 792 |
| shared | 없음 (Fact Pack에 shared 파일 없음) | – |
| legacy | 본문 표에는 없음 (legacy 사본이 있는지는 CSV 원본에서 **확인 필요**) | – |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| `this.Load` | `Form_Load` > `InitControls` | 135 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |
| `this.Load` | `Form_Load` > `InitControls` | 137 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| `this.Load` | `Form_Load` > `InitControls` > `SetChangedControl` | 166 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | – |
| `this.Load` | `Form_Load` > `InitControls` > `SetChangedControl` | 169 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | – |
| `cboDivision.SelectedIndexChanged` | `ClbDivision_SelectedIndexChanged` > `SetChangedControl` | 166 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | – |
| `cboDivision.SelectedIndexChanged` | `ClbDivision_SelectedIndexChanged` > `SetChangedControl` | 169 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | – |
| FindButton(프레임워크 버튼) | `FindButton` > `FindData` | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE |
| SaveButton(프레임워크 버튼) | `SaveButton` > `SaveData` | 659 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_SAVE_SHIPMENT_LOT_SIZE |
| SaveButton(프레임워크 버튼) | `SaveButton` > `SaveData` > `FindData` (저장 후 재조회) | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE |
| `this.btnInput.Click` | `btnInput_Click` > `FindInput` | 417 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT |
| `this.btnDelete.Click` | `btnDelete_Click` > `FindDelete` | 511 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_SAVE_SHIPMENT_LOT_SIZE |
| `this.btnDelete.Click` | `btnDelete_Click` > `FindDelete` > `FindData` (삭제 후 재조회) | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | SCP0028_GET_SHIPMENT_LOT_SIZE |
| (진입점 미연결) | `<field:dtTransMode>` 필드 초기화 | 44 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | – |
| (진입점 미연결) | `<field:dtYesOrNo>` 필드 초기화 | 46 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – |

- 정리하면, 삭제(`btnDelete_Click`)는 별도 삭제 SP를 쓰지 않고 저장 SP `SCP0028_SAVE_SHIPMENT_LOT_SIZE`를 호출합니다(511줄). 이때 넘기는 구분 인자(삭제 플래그 등)는 Fact Pack에 없으므로 **확인 필요**입니다.
- `btnInput_Click`(265줄)과 `btnDelete_Click`(293줄)은 `CString.GetCheckedListValue`를 호출합니다(§4-2).

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=FromSiteByDivision] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=ToSiteByDivision] | BIZ_MATCH | 1 | (코드분기) UP_FX_GetCommonDataList / UP_FX_GetCommonDataList_SCP | SELECT:SCM_MST_SITE, REF:STRING_SPLIT, SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 2 | (코드분기) UP_FX_GetCommonDataList | SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 2 | – (DB 보강 없음) | – |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | MATCH | 1 | SCP0028_GET_SHIPMENT_LOT_SIZE | REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCP_MST_SHIPMENT_LOT_SIZE, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:STRING_SPLIT, SELECT:SCM_MST_SITE |
| `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | MATCH | 1 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, #TBLDYNAMIC_SCP0028IN_DIV/OPER/FROM/TO/ITEM/INPUT (INSERT/SELECT), REF:UF_FX_STRING_SPLIT, REF:FN_GET_LOOKUP_CODE_DESC, REF:FN_GET_SCM_SITE_DESCRIPTION, SELECT:SCM_MST_FINAL_ITEM_V, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCP_MST_BOD, INSERT:SCM_SYS_LOG_BATCH, SELECT:SCM_MST_SITE |
| `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | MATCH | 2 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST, MERGE:SCP_MST_SHIPMENT_LOT_SIZE, DELETE:SCP_MST_SHIPMENT_LOT_SIZE, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCP_MST_SHIPMENT_LOT_SIZE_H |

- FromSiteByDivision과 ToSiteByDivision 호출에서는 `UserInfoContext.Current.NowGroupID`를 읽습니다(SetChangedControl 166/169줄, meta_reads.csv).
- 주석 처리된 호출은 0건입니다(commented_calls.csv 0행).

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 | 연결 엔드포인트 |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:95 | YesOrNo, LookupCommon, FromSite/ToSiteByDivision |
| this.btnInput | Click | `btnInput_Click` | InitEvent:117 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| this.btnDelete | Click | `btnDelete_Click` | InitEvent:118 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` → `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:120 | 없음 (본문 동작은 **확인 필요**) |
| dsdm | Changed | `spdMain_Change` | InitEvent:124 | 없음 (`dsdm` 객체의 정체와 본문 동작은 **확인 필요**) |
| cboDivision | SelectedIndexChanged | `ClbDivision_SelectedIndexChanged` | InitControls:144 | FromSiteByDivision, ToSiteByDivision |
| this.btnItemId | Click | `btnItemId_Click` | InitControls:146 | 없음. 256줄에서 `txtItemId.Text = sItemId`를 설정함 (팝업 호출 여부는 **확인 필요**) |

## 5. Grid 구성 방식

- 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)**
- 시트는 1개 `Shipment Lot Size`이며 연결 규칙은 `META+코드연결`입니다.
  - `CreateSpread:176`에서 `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)`을 호출합니다.
  - `CreateSpread:177`의 `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)`와 `CreateSpread:178`의 `ChangeSheet`가 이어집니다.
  - `InitSpread:185`의 `InitSheet(siMain.SheetName)`와 `InitSpread:186`의 `SetSheetHeaderColumn(siMain, 1)`이 메타로 컬럼을 생성합니다(헤더 1행).
- 코드 override는 Designer.cs 633~636줄의 컬럼헤더 스타일(`HorizontalAlignment=General`, `NoteIndicatorColor=Red`, `Parent=ColumnHeaderDefaultEnhanced`, `VerticalAlignment=General`)뿐이며 컬럼을 추가하거나 숨기지 않습니다.
- 메타는 `SCM_MST_SHEET_COLUMNS` 18행이고, 이 중 표시 15개(모두 '기본'), 숨김 3개(FROM_SITE, TO_SITE, TRANS_MODE_CODE)입니다.

### 5-1. Division별 차이

| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Lot Size | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 | 15 |

- 14개 division 모두 15개 컬럼으로 같습니다. division 분기 코드 0건, 판단 불가 분기 0건입니다.

## 6. 확인 필요 항목

| # | 항목 | 근거 |
|---|---|---|
| 1 | `<field:dtTransMode>`(44)와 `<field:dtYesOrNo>`(46)가 "진입점 미연결"로 분류된 이유. 필드 초기화 시점 호출인지, `InitControls` 135/137 호출과 중복인지 | flow.csv unreached |
| 2 | LookupCommon(137)이 바인딩되는 컨트롤. `clbTransMode`일 것으로 보이나 Fact Pack에는 연결이 명시되지 않음 | endpoints.csv 137 |
| 3 | FromSite/ToSiteByDivision(166/169) 결과가 `clbFromSite`/`clbToSite`에 바인딩되는지 | 바인딩 대상 미추출 |
| 4 | `cboOperationGroup`의 데이터 소스. 바인딩 엔드포인트가 추출되지 않음 | endpoints.csv에 없음 |
| 5 | §4-2에서 `SaveData`(SaveButton:207)를 `PersonalSettingPopup.SaveData`로 해석한 부분. 화면 자체 `SaveData`(659)와 이름이 같아 정적 해석이 섞였을 수 있음 | Fact Pack §4-2 |
| 6 | `EditButton` 메서드(231줄, `GetSheetInfo` 호출)의 역할과 진입점 | grid_code.csv |
| 7 | `FindDelete`가 저장 SP에 넘기는 삭제 구분값 | endpoints.csv 511 |
| 8 | `SpdMain_TopChange`와 `spdMain_Change`(dsdm.Changed)의 본문 동작 | events.csv |
| 9 | 메타 18개 컬럼의 표시 순서. grid_effective.csv는 정렬 기준이 명시되지 않음 | grid_effective.csv |
| 10 | `usrLayoutControl1`(657×184, parent 미지정)의 실제 배치 위치와 용도 | controls.csv, props.csv |

=== FILE: source_links.md ===
# SCP0028 소스 링크

기준 경로(공통 접두): `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0028_Shipment_Lot_Size\`
- `.cs` = `SCP0028_Shipment_Lot_Size.cs`
- `Designer.cs` = `SCP0028_Shipment_Lot_Size.Designer.cs`

## 1. 엔드포인트 호출 지점 (전부)

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `<field:dtTransMode>` | 44 | `biz:CommonData.CommonDataList` [code=LookupCommon], 경로 `Data.Common` > `Data.CallBizCommonData` (진입점 미연결) |
| .cs | `<field:dtYesOrNo>` | 46 | `biz:CommonData.YesOrNo`, 경로 `Data.Common` > `Data.CallBizData` (진입점 미연결) |
| .cs | `InitControls` | 135 | `biz:CommonData.YesOrNo`, 경로 `UsrComboBox.DataBind` > `Data.Common` > `Data.CallBizData` |
| .cs | `InitControls` | 137 | `biz:CommonData.CommonDataList` [code=LookupCommon] |
| .cs | `SetChangedControl` | 166 | `biz:CommonData.CommonDataList` [code=FromSiteByDivision], `UserInfoContext.Current.NowGroupID` 사용 |
| .cs | `SetChangedControl` | 169 | `biz:CommonData.CommonDataList` [code=ToSiteByDivision], `UserInfoContext.Current.NowGroupID` 사용 |
| .cs | `FindData` | 349 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` (FoxQuery ctor) |
| .cs | `FindInput` | 417 | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` (FoxQuery ctor) |
| .cs | `FindDelete` | 511 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` (FoxQuery ctor) |
| .cs | `SaveData` | 659 | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` (FoxQuery ctor) |

## 2. 이벤트 배선 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `.ctor` | 95 | `this.Load += Form_Load` |
| .cs | `InitEvent` | 117 | `this.btnInput.Click += btnInput_Click` |
| .cs | `InitEvent` | 118 | `this.btnDelete.Click += btnDelete_Click` |
| .cs | `InitEvent` | 120 | `spdMain.TopChange += SpdMain_TopChange` |
| .cs | `InitEvent` | 124 | `dsdm.Changed += spdMain_Change` |
| .cs | `InitControls` | 144 | `cboDivision.SelectedIndexChanged += ClbDivision_SelectedIndexChanged` |
| .cs | `InitControls` | 146 | `this.btnItemId.Click += btnItemId_Click` |

## 3. 메타 소비 / 체크리스트 값 추출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `InitControls` | 135 | `DataBind` → `UsrComboBox.DataBind` (CODE, NAME) |
| .cs | `SetChangedControl` | 160 | `GetCheckedListValue` (CODE) |
| .cs | `btnInput_Click` | 265 | `GetCheckedListValue` (CODE) |
| .cs | `btnDelete_Click` | 293 | `GetCheckedListValue` (CODE) |
| .cs | `FindData` | 332~336 | `GetCheckedListValue` 5회 (CODE) |
| .cs | `InitSpread` | 186 | `SetSheetHeaderColumn` → `SpreadInfo.SetSheetHeaderColumn` |
| .cs | `SaveButton` | 207 | `SaveData` (정적 해석 결과 `PersonalSettingPopup.SaveData`, 확인 필요) |
| .cs | `btnItemId_Click` | 256 | `txtItemId.Text = sItemId` |

## 4. Grid 생성 코드

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| .cs | `CreateSpread` | 176 | `AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30)`, 시트 `Shipment Lot Size` |
| .cs | `CreateSpread` | 177 | `GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex)` |
| .cs | `CreateSpread` | 178 | `ChangeSheet` |
| .cs | `InitSpread` | 185 | `InitSheet(siMain.SheetName)` |
| .cs | `InitSpread` | 186 | `SetSheetHeaderColumn(siMain, 1)` |
| .cs | `EditButton` | 231 | `GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)` |
| Designer.cs | `InitializeComponent` | 633 | ColumnHeader `HorizontalAlignment = General` |
| Designer.cs | `InitializeComponent` | 634 | `NoteIndicatorColor = Red` |
| Designer.cs | `InitializeComponent` | 635 | `Parent = "ColumnHeaderDefaultEnhanced"` |
| Designer.cs | `InitializeComponent` | 636 | `VerticalAlignment = General` |

## 5. 컨트롤 선언 (Designer.cs)

| 컨트롤 | 유형 | 줄 |
|---|---|---:|
| usrLayoutControl1 | UsrLayoutControl | 33 |
| layoutControlGroup1 | LayoutControlGroup | 34 |
| usrConditionPanel1 | UsrConditionPanel | 35 |
| usrLayoutControl2 | UsrLayoutControl | 36 |
| cboValid | UsrComboBox | 37 |
| cboDivision | UsrCombo | 38 |
| btnItemId | UsrButton | 39 |
| txtItemId | UsrMultiLineEditor | 40 |
| cboOperationGroup | UsrCombo | 41 |
| clbFromSite | UsrCheckedList | 42 |
| clbTransMode | UsrCheckedList | 43 |
| btnInput | UsrButton | 44 |
| btnDelete | UsrButton | 45 |
| layoutControlGroup2 | LayoutControlGroup | 46 |
| Division / layoutControlItem1·7·6·3·11·9·5·2 | LayoutControlItem | 47, 49~53, 55, 58, 59 |
| emptySpaceItem1·3·2·4 | EmptySpaceItem | 48, 54, 56, 57 |
| spdMain | FpSpread | 60 |
| spdMain_Sheet1 | SheetView | 61 |
| imageList1 | ImageList | 62 |
| clbToSite | UsrCheckedList | 63 |
| layoutControlItem4 | LayoutControlItem | 64 |

=== FILE: web_components.md ===
# SCP0028 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 컴포넌트 매핑

| AS-IS 컨트롤 | 유형 | 라벨 (원문) | 근거 | TO-BE 후보 | 데이터 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | LayoutControlItem `Division`.Text (Designer:472) | 단일 ComboBox (필수 `*`) | 바인딩 엔드포인트 미추출 (**확인 필요**). 변경 시 Site 목록 재조회 |
| cboOperationGroup | UsrCombo | `Operation Group` | layoutControlItem1.Text (492) | 단일 ComboBox | 데이터 소스 **확인 필요** |
| clbFromSite | UsrCheckedList | `From Site` | layoutControlItem7.Text (504) | 멀티 체크 ComboBox | `CommonDataList` [code=FromSiteByDivision] (바인딩 대상 **확인 필요**) |
| clbToSite | UsrCheckedList | `To Site` | layoutControlItem4.Text (711) | 멀티 체크 ComboBox | `CommonDataList` [code=ToSiteByDivision] (바인딩 대상 **확인 필요**) |
| clbTransMode | UsrCheckedList | `Trans Mode` | layoutControlItem6.Text (516) | 멀티 체크 ComboBox | `CommonDataList` [code=LookupCommon] 추정 (**확인 필요**) |
| txtItemId | UsrMultiLineEditor | `Model` | layoutControlItem3.Text (528) | 멀티라인 입력 | `btnItemId_Click`이 값을 채움(256) |
| btnItemId | UsrButton | 텍스트 없음 | layoutControlItem11 (Text 미설정) | 검색 아이콘 버튼 | `btnItemId_Click` |
| cboValid | UsrComboBox | `Valid` | layoutControlItem9.Text (560) | 단일 ComboBox | `biz:CommonData.YesOrNo` (DataBind, 135) |
| btnInput | UsrButton | `Input` | btnInput.Text (401) | 화면 버튼 | `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` |
| btnDelete | UsrButton | `Delete` | btnDelete.Text (437). 단, 감싸는 layoutControlItem2.Text는 `layoutControlItem5`(604) | 화면 버튼 | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` → 재조회 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | – | – | Wijmo FlexGrid (메타 기반) | 시트 `Shipment Lot Size` |
| usrConditionPanel1 | UsrConditionPanel | – | `UsrPanelType = HidePanel` (117) | 접이식 조회조건 영역 | – |
| 조회·저장 | 프레임워크 버튼 | FindButton / SaveButton | flow.csv | 공통 툴바 Search / Save | GET / SAVE SP |

## 2. 화면 배치

- `props.csv`에 SplitContainer가 없어 Orientation·SplitterDistance 값은 없습니다. 영역은 Dock으로 나뉩니다.

| 영역 | 컨트롤 | Dock | Size |
|---|---|---|---|
| 상단 조회조건 | usrConditionPanel1 (내부 usrLayoutControl2 Fill) | Top | 1093 × 72 |
| 하단 Grid | spdMain | Fill | 1093 × 502 |

- 상/하 높이 비율(디자인 기준)은 72 : 502이며, 합계 574 기준 약 12.5% : 87.5%입니다. 좌/우 분할은 없습니다.
- 조회조건 레이아웃 그룹 `layoutControlGroup2`의 Size는 1093 × 78로 패널(72)과 다릅니다.
- 조회조건 항목 Size(폭×높이 29):

| 항목 | 폭 |
|---|---:|
| Division* | 217 |
| Operation Group | 228 |
| From Site | 241 |
| Trans Mode | 241 |
| To Site | 214 |
| Model | 174 |
| btnItemId | 43 |
| Valid | 228 |
| Input | 75 |
| Delete | 75 |
| 빈 공간 1/2/3/4 | 10 / 145 / 242 / 13 |

- 항목의 행·열 배치 순서(Location)는 Fact Pack에 없어 **확인 필요**입니다.
- `usrLayoutControl1`(Fill, 657×184)과 `layoutControlGroup1`은 parent가 비어 있어 실제 표시 여부를 **확인 필요**합니다.

## 3. 시트별 Grid 컬럼 — `Shipment Lot Size`

- 연결 규칙: `META+코드연결` (`AddSheet` 176 → `SetSheetHeaderColumn` 186, 헤더 1행)
- 코드 하드코딩 컬럼은 0개입니다. 코드는 컬럼헤더 스타일만 변경합니다(Designer 633~636).
- 아래 표는 grid_effective.csv 기준이며 14개 division이 모두 같습니다.

| # | COLUMN | 라벨 | 소스 | 표시 (전 division) |
|---:|---|---|---|---|
| 1 | CREATED_BY | Created By | META | 기본 |
| 2 | CREATION_DATE | Creation Date | META | 기본 |
| 3 | DIVISION_ID | Division | META | 기본 |
| 4 | FROM_SITE | From Site | META | 숨김 |
| 5 | FROM_SITE_DESCRIPTION | From Site | META | 기본 |
| 6 | INCREMENT | Increment* | META | 기본 |
| 7 | ITEM_ID | Model | META | 기본 |
| 8 | LAST_UPDATE_DATE | Last Update Date | META | 기본 |
| 9 | LAST_UPDATED_BY | Last Updated By | META | 기본 |
| 10 | LOT_SIZE | Lot Size* | META | 기본 |
| 11 | NICK_NAME | Nick Name | META | 기본 |
| 12 | OPERATION_GROUP_ID | Operation Group | META | 기본 |
| 13 | SPLIT_YN | Container Split* | META | 기본 |
| 14 | TO_SITE | To Site | META | 숨김 |
| 15 | TO_SITE_DESCRIPTION | To Site | META | 기본 |
| 16 | TRANS_MODE_CODE | Trans Mode | META | 숨김 |
| 17 | TRANS_MODE_NAME | Trans Mode | META | 기본 |
| 18 | VALID_YN | Valid* | META | 기본 |

- 위 `#`는 CSV 행 순서이며 실제 표시 순서가 아닙니다. 실제 순서는 메타의 정렬 컬럼으로 **확인 필요**합니다.
- 표시 컬럼은 15개(전 division 15/0, 필수+기본/선택)이고, 숨김은 코드 컬럼 3개(FROM_SITE, TO_SITE, TRANS_MODE_CODE)입니다. 각 코드 컬럼에는 설명 컬럼(…_DESCRIPTION / TRANS_MODE_NAME)이 함께 표시됩니다.
- 라벨의 `*`(Increment*, Lot Size*, Container Split*, Valid*)는 메타 COLUMN_LABEL_NAME 원문입니다. 필수 입력 검증 로직은 Fact Pack에 없어 **확인 필요**입니다.
- 셀 편집 유형(CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE), 폭, 정렬, 고정 컬럼은 `SetSheetHeaderColumn`이 메타에서 읽지만 컬럼별 값은 Fact Pack에 없습니다(dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv 확인 필요).

## 4. 시트 연결 규칙

| 시트 | 생성 | 메타 연결 | 다른 시트 연계 |
|---|---|---|---|
| Shipment Lot Size | `AddSheet` (CreateSpread:176) | `SetSheetHeaderColumn` (InitSpread:186) | 단일 시트, 연계 없음 |

=== FILE: oracle_migration.md ===
# SCP0028 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 지점 | 참조 테이블/객체 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0028_GET_SHIPMENT_LOT_SIZE` | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE` | FindData:349 (조회, 저장·삭제 후 재조회) | SCP_MST_SHIPMENT_LOT_SIZE, SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCM_MST_SITE / 함수 FN_GET_SCM_SITE_DESCRIPTION, STRING_SPLIT | 없음 |
| `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | `SCP.SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | FindInput:417 (Input 버튼) | SCM_MST_FINAL_ITEM_V, SCM_ADM_LOOKUP_MASTER_DETAIL, SCP_MST_BOD, SCM_MST_SITE, SCM_SYS_LOG_BATCH(INSERT) / 임시테이블 #TBLDYNAMIC_SCP0028IN_DIV·OPER·FROM·TO·ITEM·INPUT / 함수 UF_FX_STRING_SPLIT, FN_GET_LOOKUP_CODE_DESC, FN_GET_SCM_SITE_DESCRIPTION | PR_SCM_SYS_LOG_BATCH_CALL_TRAN |
| `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `SCP.SCP0028_SAVE_SHIPMENT_LOT_SIZE` | SaveData:659 (저장), FindDelete:511 (삭제) | SCP_MST_SHIPMENT_LOT_SIZE(MERGE, DELETE), SCP_MST_SHIPMENT_LOT_SIZE_H(INSERT), SCM_SYS_LOG_BATCH(INSERT) / SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | PR_SCM_SYS_LOG_BATCH_CALL_TRAN, PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST |

## 2. 공통코드 분기 (code=X → 테이블)

| 엔드포인트 | code | 분기 SP | 테이블 | 비고 |
|---|---|---|---|---|
| `biz:CommonData.CommonDataList` | FromSiteByDivision | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+STRING_SPLIT) | `NowGroupID` 사용 (SetChangedControl:166) |
| `biz:CommonData.CommonDataList` | ToSiteByDivision | UP_FX_GetCommonDataList, UP_FX_GetCommonDataList_SCP | SCM_MST_SITE, TB_FX_USERGROUPAUTHEXTENTION (+STRING_SPLIT) | `NowGroupID` 사용 (SetChangedControl:169) |
| `biz:CommonData.CommonDataList` | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL | 조회할 LOOKUP 유형 값은 **확인 필요** |
| `biz:CommonData.YesOrNo` | – | – | DB 보강 없음 | `Data.CallBizData` 경로 |

- `UP_FX_GetCommonDataList`와 `_SCP` 중 실제로 어느 쪽이 실행되는지 정하는 조건은 Fact Pack에 없어 **확인 필요**입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- FoxQuery 엔드포인트 3개는 모두 `MATCH` 상태입니다. 미등록은 0건입니다.
- 직접 SQL 호출이나 미등록 SP 호출은 추출되지 않았습니다(0건).
- 주석 처리된 호출은 0건입니다.

## 4. Oracle 전환 확인 포인트 (Fact Pack 근거만)

| # | 대상 | 사실 | 확인 포인트 |
|---|---|---|---|
| 1 | SCP0028_GET_SHIPMENT_LOT_SIZE, UP_FX_GetCommonDataList(_SCP) | `REF:STRING_SPLIT` | MSSQL 전용 함수(CLAUDE.md 금지 ⑩)이므로 Oracle 분해 방식으로 바꿔야 함 |
| 2 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | `#TBLDYNAMIC_SCP0028IN_*` 임시테이블 6종 INSERT/SELECT | Oracle GTT 또는 WITH절 전환. GTT를 쓰면 호출 시작 시 비우는지 확인(세션 재사용 시 잔존 위험) |
| 3 | SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | `REF:UF_FX_STRING_SPLIT` | 사용자 함수의 Oracle 대응 객체가 있는지 확인 |
| 4 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | `REF:SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` | 배열 분해 함수의 Oracle 대응 객체가 있는지 확인 |
| 5 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | `MERGE:SCP_MST_SHIPMENT_LOT_SIZE` + `DELETE` | Oracle MERGE 문법(ON 키, DELETE 절)으로 전환. 저장과 삭제가 한 SP에서 어떻게 분기하는지 **확인 필요** |
| 6 | SCP0028_SAVE_SHIPMENT_LOT_SIZE | `EXEC:PR_SCP_MST_SHIPMENT_LOT_SIZE_HIST` → `INSERT:SCP_MST_SHIPMENT_LOT_SIZE_H` | 이력 SP의 Oracle 존재 여부와 호출 순서(변경 전/후) |
| 7 | INPUT / SAVE SP | `EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `INSERT:SCM_SYS_LOG_BATCH` | 로그 SP 대응. 트랜잭션 경계(자율 트랜잭션 여부) **확인 필요** |
| 8 | GET / INPUT SP | `FN_GET_SCM_SITE_DESCRIPTION`, `FN_GET_LOOKUP_CODE_DESC` | Oracle 함수가 있는지 확인 |
| 9 | 시노님/권한 | SCM_MST_FINAL_ITEM_V(뷰), SCP_MST_BOD 등 | 스키마 시노님 확인 |

## 5. 난이도 (사실 근거)

| SP | 근거 지표 | 판정 |
|---|---|---|
| SCP0028_GET_SHIPMENT_LOT_SIZE | 테이블 4개 + 함수 1개 + STRING_SPLIT. EXEC 체인 없음 | 3개 중 가장 단순 |
| SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT | 임시테이블 6종, 함수 3개, 테이블 5개, EXEC 1개 | 3개 중 참조 객체가 가장 많음 |
| SCP0028_SAVE_SHIPMENT_LOT_SIZE | MERGE+DELETE, 하위 EXEC 2개, 배열 함수 2개 | 쓰기 경로이며 이력·로그 연동 |

- 줄수나 동적 SQL 여부는 Fact Pack에 없어 판정에 반영하지 않았습니다.

=== FILE: tobe_design.md ===
# SCP0028 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨 (AS-IS 원문) | AS-IS 컨트롤 | 형태 | 필수 | 데이터 소스 | 연동 |
|---|---|---|---|---|---|
| Division* | cboDivision | 단일 콤보 | `*` 표기 | **확인 필요** | 변경 시 From/To Site 재조회 (`ClbDivision_SelectedIndexChanged` → `SetChangedControl`) |
| Operation Group | cboOperationGroup | 단일 콤보 | – | **확인 필요** | – |
| From Site | clbFromSite | 멀티 체크 | – | CommonDataList FromSiteByDivision (NowGroupID) | Division 종속 |
| To Site | clbToSite | 멀티 체크 | – | CommonDataList ToSiteByDivision (NowGroupID) | Division 종속 |
| Trans Mode | clbTransMode | 멀티 체크 | – | CommonDataList LookupCommon (추정, **확인 필요**) | – |
| Model | txtItemId + btnItemId | 멀티라인 입력 + 검색 버튼 | – | `btnItemId_Click`이 `txtItemId.Text` 설정 | 팝업 여부 **확인 필요** |
| Valid | cboValid | 단일 콤보 | – | `biz:CommonData.YesOrNo` | – |

- `FindData`는 332~336줄에서 `GetCheckedListValue`를 5회 호출합니다. 어느 5개 컨트롤에서 값을 꺼내는지는 **확인 필요**입니다.
- `TB_FX_SearchCondition`에 54행이 있습니다(조회조건 저장/복원 메타). 내용은 **확인 필요**입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS 경로 | 호출 SP | 후속 |
|---|---|---|---|
| 화면 진입 | `Form_Load` > `InitControls` | YesOrNo, LookupCommon, From/ToSiteByDivision | – |
| Division 변경 | `ClbDivision_SelectedIndexChanged` > `SetChangedControl` | From/ToSiteByDivision | – |
| 조회 (Search) | `FindButton` > `FindData` | `SCP0028_GET_SHIPMENT_LOT_SIZE` | – |
| 저장 (Save) | `SaveButton` > `SaveData` | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `FindData` 재조회 |
| Input | `btnInput_Click` > `FindInput` | `SCP0028_GET_SHIPMENT_LOT_SIZE_INPUT` | Grid 반영 방식(행 추가 또는 대체) **확인 필요** |
| Delete | `btnDelete_Click` > `FindDelete` | `SCP0028_SAVE_SHIPMENT_LOT_SIZE` | `FindData` 재조회 |
| Model 검색 | `btnItemId_Click` | 없음 | `txtItemId.Text` 설정 |
| Grid 편집 | `spdMain_Change` (dsdm.Changed) | 없음 | 본문 **확인 필요** |
| Grid 스크롤 | `SpdMain_TopChange` | 없음 | 본문 **확인 필요** |

- BE 후보: Controller → Service → `SCP0028` 패키지의 조회 / Input 조회 / 저장(삭제 겸용) 3개 프로시저.
- Delete가 저장 SP를 공유하므로 TO-BE에서도 같은 SP를 호출하는 방식(구분 인자)을 유지할지 **확인 필요**합니다.

## 3. Division별 Grid 변형 요약

- 시트 `Shipment Lot Size` 1개. 14개 division(40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC) 모두 표시 15개로 같아 division별 변형은 없습니다.
- 숨김 컬럼은 FROM_SITE, TO_SITE, TRANS_MODE_CODE입니다(전 division 공통).
- 코드에 의한 컬럼 추가나 숨김은 없고, 헤더 스타일만 override합니다.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| `TB_FX_GroupMenuAuth` 13행 존재 | DB 메타 §8 |
| `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 10행 존재 | DB 메타 §8 |
| Site 목록이 `TB_FX_USERGROUPAUTHEXTENTION`과 `NowGroupID`로 사용자 그룹별 제한됨 | §2 공통코드 분기 |
| 프레임워크 버튼 FindButton, SaveButton 사용 / `EditButton` 메서드 존재(231) | flow.csv, grid_code.csv |

- 그룹별 C/R/U/D 플래그 값, Input/Delete 버튼의 권한 연동 여부는 Fact Pack에 없어 **확인 필요**입니다.

## 5. 미확정 사항

1. cboDivision과 cboOperationGroup의 데이터 소스
2. LookupCommon(137)과 clbTransMode의 연결, 그리고 LOOKUP 유형 값
3. `FindDelete`가 저장 SP에 넘기는 삭제 구분값과, SP 안에서 MERGE/DELETE가 분기되는 조건
4. Input 결과를 Grid에 반영하는 방식
5. `spdMain_Change`, `SpdMain_TopChange`, `EditButton`의 동작
6. 메타 컬럼 표시 순서, 편집 유형, 필수(`*`) 검증 로직
7. `SaveButton:207`이 `PersonalSettingPopup.SaveData`로 해석된 정적 분석 결과의 정확성
8. 조회조건 항목의 배치 순서(Location)와 `usrLayoutControl1`의 용도
9. `UP_FX_GetCommonDataList`와 `_SCP` 중 실행되는 분기 조건
