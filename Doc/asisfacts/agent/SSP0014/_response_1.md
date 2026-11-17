=== FILE: analysis.md ===
# SSP0014 Shipment Model PIC — As-is 분석

> 출처: AsisFacts 정적 추출(Fact Pack SSP0014). 이 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0014 |
| 클래스 | `SSP0014_ShipmentModelPIC` |
| 폼 Text | `SSP0014_ShipmentModelPIC` (Designer.cs:546) |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| 메타 시트 | `Shipment Model PIC` (SCM_MST_SHEET_COLUMNS 21행) |
| 메뉴/프로그램 메타 | TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행, TB_FX_GroupMenuAuth 13행, TB_FX_Favorite 56행, TB_FX_SearchCondition 112행, SCM_ADM_DB_SCRIPT_BACKUP 5행 |

### 1-1. 파일 구성

| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.cs | GSCM.SSP.Plan.UIL.csproj | 864 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0014_ShipmentModelPIC.Designer.cs | GSCM.SSP.Plan.UIL.csproj | 596 |
| shared | 없음 (Fact Pack에 없음) | – | – |
| legacy | 없음 (variant 전부 `only`) | – | – |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 호출 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| FindButton (조회) | FindButton > FindData_Main | 329 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | MATCH | SSP0014_GET_SHIPMENT_MODEL_PIC |
| SaveButton (저장) | SaveButton > SaveData > GetUserIDChk | 562 | `SSP.SSP0014_GET_USER_ID_CHECK` | MATCH | SSP0014_GET_USER_ID_CHECK |
| SaveButton (저장) | SaveButton > SaveData | 497 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | MATCH | SSP0014_SAVE_SHIPMENT_MODEL_PIC |
| SaveButton (저장 후 재조회) | SaveButton > SaveData > FindData_Main | 329 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | MATCH | SSP0014_GET_SHIPMENT_MODEL_PIC |
| (진입점 미연결) | `<field:dtYesOrNo>` | 54 | `biz:CommonData.YesOrNo` | BIZ_MATCH | – (Data.Common[Type.YesOrNo] > Data.CallBizData) |

- SaveData 안에서 GetUserIDChk(562)·SAVE(497)·재조회(329)가 **어떤 순서로, 어떤 조건에서** 실행되는지는 Fact Pack에 없습니다 → **확인 필요**. 위 표의 순서는 흐름 행을 나열한 것이고 실행 순서를 확인한 것이 아닙니다.
- 조회 파라미터 구성: FindData_Main 310~313줄에서 `CString.GetCheckedListValue`(CODE)를 4회 호출합니다. 어느 컨트롤의 값인지는 **확인 필요**입니다(체크리스트 컨트롤은 `clbFromSite` 1개뿐).

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 테이블/객체 (EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | – | – |
| `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | MATCH | 1 | SSP0014_GET_SHIPMENT_MODEL_PIC | SELECT: SCM_MST_SITE_ITEM, SCM_MST_SITE, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_ITEM_SN / REF: FN_GET_ITEM_NICKNAME, STRING_SPLIT |
| `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | MATCH | 1 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | MERGE: SSP_MST_MODEL_USER / INSERT: SCM_SYS_LOG_BATCH / EXEC: PR_SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL |
| `SSP.SSP0014_GET_USER_ID_CHECK` | MATCH | 1 | SSP0014_GET_USER_ID_CHECK | SELECT: TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION / REF: STRING_SPLIT |

- 주석 처리된 호출: 0건.
- 확인 필요 행(Fact Pack §7): 0건.

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:110 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:240 |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:241 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:242 |
| btnItemId | Click | `btnItemId_Click` | InitEvent:243 |

- `btnItemId_Click`: 857줄에서 `txtItemId.Text = sItemId`로 값을 넣습니다. `sItemId`를 어디서 얻는지(팝업 여부 등)는 **확인 필요**입니다.
- `SpdMain_TopChange`, `SpdMain_CellDoubleClick`, `CboDivision_SelectedIndexChanged`, `Form_Load`의 본문 동작은 Fact Pack에 없습니다 → **확인 필요**.

## 5. 초기화·메타 소비 메서드

| 메서드 | 줄 | 내용 |
|---|---|---|
| SetChangeControl | 137~138 | `Filter` 의 GROUP_ID, USER_ID 를 읽고 `UserInfoContext.Current.NowGroupID` 를 참조 |
| SetChangeControl | 144, 149 | `DataService.GetSSPInnerTable` 호출. 읽는 메타 컬럼: CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| InitControls | 170, 173 | `DataService.FP_Log2` 호출 (LOGTYPE, NOTE, USER_ID) |
| InitControls | 184~185 | `insertRow["CODE"]`, `insertRow["NAME"]` 로 행 추가. 어느 콤보에 넣는지는 **확인 필요** |
| SetChangedControl | 197 | `CString.GetCheckedListValue` (CODE). SetChangeControl 과 이름이 다른 메서드로 추출되었으므로 **확인 필요** |
| CreateSpread | 208~211 | AddSheet("Shipment Model PIC", 1, 1, 30) → GetSheetInfo(spdMain.Name, 0) → ChangeSheet |
| InitSpread | 220~233 | InitSheet → `SpreadInfo.SetSheetHeaderColumn(spdInfo, 1)` → 이미지 CellType 지정 8회 |
| EditButton | 271 | `if(fps.Name == "spdMain")` 일 때 GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| SaveButton | 285 | `SaveData` 호출. 추출기는 이 호출을 `PersonalSettingPopup.SaveData` 로 해석했지만, 이 화면 클래스의 SaveData(497줄 SAVE 호출)일 수 있습니다 → **확인 필요** |

## 6. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

- 시트 `Shipment Model PIC` 1개. 연결 규칙은 `META+코드연결`입니다(코드가 AddSheet 로 메타 시트명을 사용).
- 컬럼은 `SetSheetHeaderColumn`(InitSpread:222)이 SCM_MST_SHEET_COLUMNS 메타 21행으로 만듭니다.
- 코드 변경: InitSpread 225·226·227·229·230·231·232·233줄에서 `CellType = cellTypeImage`를 지정합니다(8건). 어느 컬럼에 적용되는지는 추출되지 않았습니다 → **확인 필요**.
- Designer.cs 411~414줄: 컬럼헤더 스타일(HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General).

### Division별 차이
- 40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC 등 **모든 division에서 21컬럼, 모두 '기본'**(필수+기본 21 / 선택 0)입니다. division별 차이는 **없습니다**.
- 코드 분기 중 division 판단 불가 건: 0건.
- 실제 SP 실행 결과와 맞춘 시트 매칭은 미실행입니다(Fact Pack 기재) → **확인 필요**.

## 7. 확인 필요 항목

1. SaveData 안에서 GetUserIDChk·SAVE·재조회가 실행되는 순서와 조건
2. SaveButton:285 의 SaveData 해석(PersonalSettingPopup.SaveData 로 추출됨)이 맞는지
3. `biz:CommonData.YesOrNo`(dtYesOrNo, 54줄)를 쓰는 컨트롤 — 진입점 미연결로 추출되었습니다. cboValidYN 과의 연결은 추정이므로 확인 필요
4. FindData_Main 310~313 의 GetCheckedListValue 4회가 각각 어느 컨트롤 값인지
5. InitSpread 이미지 CellType 8건의 대상 컬럼
6. 각 이벤트 핸들러 본문(TopChange, CellDoubleClick, Division 변경, Form_Load)
7. `usrButton1`(parent 없음, 75×23) 사용 여부
8. Add/Delete 등 행 편집 버튼 존재 여부 (Fact Pack에는 FindButton, SaveButton, EditButton 만 있음)

=== FILE: source_links.md ===
# SSP0014 소스 링크

기준 경로: `06.UIL\GSCM.SSP.Plan.UIL\`

## 1. 엔드포인트 호출 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | `<field:dtYesOrNo>` | 54 | `biz:CommonData.YesOrNo` (Data.Common[Type.YesOrNo] > Data.CallBizData), 진입점 미연결 |
| SSP0014_ShipmentModelPIC.cs | FindData_Main | 329 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| SSP0014_ShipmentModelPIC.cs | SaveData | 497 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| SSP0014_ShipmentModelPIC.cs | GetUserIDChk | 562 | `SSP.SSP0014_GET_USER_ID_CHECK` |

## 2. 이벤트 배선

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | .ctor | 110 | `this.Load += Form_Load` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 240 | `spdMain.TopChange += SpdMain_TopChange` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 241 | `spdMain.CellDoubleClick += SpdMain_CellDoubleClick` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 242 | `cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged` |
| SSP0014_ShipmentModelPIC.cs | InitEvent | 243 | `btnItemId.Click += btnItemId_Click` |
| SSP0014_ShipmentModelPIC.cs | btnItemId_Click | 857 | `txtItemId.Text = sItemId` |

## 3. 메타·프레임워크 호출

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 137 | Filter GROUP_ID / UserInfoContext.Current.NowGroupID |
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 138 | Filter USER_ID |
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 144 | DataService.GetSSPInnerTable |
| SSP0014_ShipmentModelPIC.cs | SetChangeControl | 149 | DataService.GetSSPInnerTable |
| SSP0014_ShipmentModelPIC.cs | InitControls | 170 | DataService.FP_Log2 |
| SSP0014_ShipmentModelPIC.cs | InitControls | 173 | DataService.FP_Log2 |
| SSP0014_ShipmentModelPIC.cs | InitControls | 184 | insertRow["CODE"] |
| SSP0014_ShipmentModelPIC.cs | InitControls | 185 | insertRow["NAME"] |
| SSP0014_ShipmentModelPIC.cs | SetChangedControl | 197 | CString.GetCheckedListValue |
| SSP0014_ShipmentModelPIC.cs | FindData_Main | 310~313 | CString.GetCheckedListValue (4회) |
| SSP0014_ShipmentModelPIC.cs | SaveButton | 285 | SaveData 호출 (추출기 해석: PersonalSettingPopup.SaveData, 확인 필요) |

## 4. Grid 정의

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SSP0014_ShipmentModelPIC.cs | CreateSpread | 208 | AddSheet(spdMain, SpdSheet.shtMain = "Shipment Model PIC", 1, 1, 30) |
| SSP0014_ShipmentModelPIC.cs | CreateSpread | 209 | GetSheetInfo(spdMain.Name, 0) |
| SSP0014_ShipmentModelPIC.cs | CreateSpread | 211 | ChangeSheet |
| SSP0014_ShipmentModelPIC.cs | InitSpread | 220 | InitSheet(SpdSheet.shtMain), 조건 `spdInfo.SheetName == "Shipment Model PIC"` |
| SSP0014_ShipmentModelPIC.cs | InitSpread | 222 | SpreadInfo.SetSheetHeaderColumn(spdInfo, 1) |
| SSP0014_ShipmentModelPIC.cs | InitSpread | 225, 226, 227, 229, 230, 231, 232, 233 | CellType = cellTypeImage |
| SSP0014_ShipmentModelPIC.cs | EditButton | 271 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| SSP0014_ShipmentModelPIC.Designer.cs | InitializeComponent | 411~414 | 컬럼헤더 HorizontalAlignment / NoteIndicatorColor / Parent / VerticalAlignment |

## 5. Designer 컨트롤 선언 (Designer.cs)

| 컨트롤 | 유형 | 선언 줄 | 주요 속성 줄 |
|---|---|---:|---|
| usrButton1 | UsrButton | 33 | Size 104 |
| usrConditionPanel1 | UsrConditionPanel | 34 | Dock 113, Size 116, UsrPanelType 118 |
| usrLayoutControl2 | UsrLayoutControl | 35 | Dock 130, Size 135, Text 137 |
| cboDivision | UsrCombo | 36 | Size 171 |
| cboOperationGroup | UsrCombo | 37 | Size 207 |
| clbFromSite | UsrCheckedList | 38 | Size 243 |
| cboValidYN | UsrCombo | 39 | Size 280 |
| txtUser | TextBox | 40 | Size 288 |
| layoutControlGroup2 | LayoutControlGroup | 41 | Size 307 |
| emptySpaceItem2 | EmptySpaceItem | 42 | Size 315 |
| Division | LayoutControlItem | 43 | Control 320, Size 324, Text 325 |
| layoutControlItem1 | LayoutControlItem | 44 | Control 332, Size 336, Text 337 |
| layoutControlItem7 | LayoutControlItem | 45 | Control 342, Size 346, Text 347 |
| layoutControlItem3 | LayoutControlItem | 46 | Control 354, Size 358, Text 359 |
| layoutControlItem2 | LayoutControlItem | 47 | Control 366, Size 371, Text 373 |
| emptySpaceItem1 | EmptySpaceItem | 48 | Size 383 |
| spdMain | FpSpread | 49 | Dock 389, Size 394 |
| spdMain_Sheet1 | SheetView | 50 | – |
| btnItemId | UsrButton | 51 | Size 466 |
| layoutControlItem4 | LayoutControlItem | 52 | Control 474, Size 480, Text 482 |
| txtItemId | UsrMultiLineEditor | 53 | Size 516 |
| lblItemId | LayoutControlItem | 54 | Control 522, Size 526, Text 527 |
| imageList1 | ImageList | 55 | – |
| this (Form) | – | – | Text 546 |

=== FILE: web_components.md ===
# SSP0014 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| As-is 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` | 189×20 | Wijmo ComboBox (필수) | SelectedIndexChanged 핸들러 있음 |
| cboOperationGroup | UsrCombo | `Operation Group` | 142×20 | Wijmo ComboBox | 데이터 원천 확인 필요 |
| clbFromSite | UsrCheckedList | `From Site` | 240×21 | Wijmo MultiSelect | GetCheckedListValue(CODE) 사용 |
| cboValidYN | UsrCombo | `Valid` | 105×20 | Wijmo ComboBox | YesOrNo 연결 여부 확인 필요 |
| txtUser | TextBox | `User ID(Name)` | 150×24 | 텍스트 입력 | – |
| txtItemId | UsrMultiLineEditor | `Model` | 160×21 | 다중행 입력 | btnItemId_Click 에서 값 설정 |
| btnItemId | UsrButton | (layoutControlItem4.Text = `layoutControlItem2`) | 39×24 | 아이콘 버튼 | 라벨 표시 여부 확인 필요 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | – | 1192×582 | Wijmo FlexGrid | 시트 `Shipment Model PIC` |
| usrButton1 | UsrButton | – | 75×23 | 확인 필요 | parent 없음, 사용 여부 확인 필요 |
| usrConditionPanel1 | UsrConditionPanel | – | 1192×67 | 조회조건 패널 | UsrPanelType = HidePanel |
| imageList1 | ImageList | – | – | 아이콘 자원 | 이미지 CellType 과의 관계 확인 필요 |

## 2. 화면 배치

- props.csv 에 **SplitContainer 가 없습니다**(Orientation·SplitterDistance 값 없음). 좌/우 분할은 없습니다.
- 상/하 구성:
  - 상단: `usrConditionPanel1` Dock = Top, 1192×67 (안쪽 `usrLayoutControl2` Dock = Fill, 1192×67, layoutControlGroup2 1192×73)
  - 하단: `spdMain` Dock = Fill, 1192×582
  - 높이 비율(크기 값 기준): 67 : 582 ≈ 10.3% : 89.7%
- 조회조건 레이아웃 항목 크기(LayoutControlItem): Division 244×25, Operation Group 240×25, From Site 301×25, Valid 139×25, emptySpaceItem2 248×25 (높이 25 줄) / User ID(Name) 240×28, Model 201×28, btnItemId 43×28, emptySpaceItem1 688×28 (높이 28 줄). 높이 값 기준 2줄로 보이지만 실제 배치 좌표는 Fact Pack에 없음 → **확인 필요**.

## 3. 시트별 Grid 컬럼 — `Shipment Model PIC`

- 연결 규칙: META+코드연결 (AddSheet 208줄, SetSheetHeaderColumn 222줄)
- 컬럼헤더 행 수: 1 (SetSheetHeaderColumn 인자). AddSheet 인자 `1, 1, 30` 의 의미는 확인 필요.
- grid_effective 기준 21컬럼. 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 **기본 표시**.

| # | COLUMN_NAME | 라벨 | 출처 | Division별 표시 |
|---:|---|---|---|---|
| 1 | CREATED_BY | Created By | META | 전체 기본 |
| 2 | CREATION_DATE | Creation Date | META | 전체 기본 |
| 3 | DIVISION_ID | Division | META | 전체 기본 |
| 4 | FROM_SITE | From Site | META | 전체 기본 |
| 5 | ITEM_ID | Model | META | 전체 기본 |
| 6 | LAST_UPDATE_DATE | Last Update Date | META | 전체 기본 |
| 7 | LAST_UPDATED_BY | Last Updated By | META | 전체 기본 |
| 8 | MAIL_USER1 | Mail User1 | META | 전체 기본 |
| 9 | MAIL_USER2 | Mail User2 | META | 전체 기본 |
| 10 | MAIL_USER3 | Mail User3 | META | 전체 기본 |
| 11 | MAIL_USER4 | Mail User4 | META | 전체 기본 |
| 12 | MAIL_USER5 | Mail User5 | META | 전체 기본 |
| 13 | NICK_NAME | Nick Name | META | 전체 기본 |
| 14 | OPERATION_GROUP | Operation Group | META | 전체 기본 |
| 15 | PART_LEADER | Part Leader | META | 전체 기본 |
| 16 | PART_LEADER_NAME | Part Leader Name | META | 전체 기본 |
| 17 | TEAM_LEADER | Team Leader | META | 전체 기본 |
| 18 | TEAM_LEADER_NAME | Team Leader Name | META | 전체 기본 |
| 19 | USER_ID | User ID* | META | 전체 기본 |
| 20 | USER_NAME | User Name | META | 전체 기본 |
| 21 | VALID_YN | Valid* | META | 전체 기본 |

> 위 순서는 grid_effective.csv 의 행 순서(알파벳순)입니다. 실제 표시 순서·폭·정렬·편집 여부(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE 등)는 Fact Pack에 값이 없습니다 → **확인 필요**(SCM_MST_SHEET_COLUMNS 원문 대조).

### 코드 하드코딩 / 표시 변경
| 줄 | 내용 | 대상 컬럼 |
|---|---|---|
| InitSpread 225, 226, 227, 229, 230, 231, 232, 233 | `CellType = cellTypeImage` (조건: SheetName == "Shipment Model PIC") | 확인 필요 (8건. 사용자 선택용 이미지 셀일 수 있으나 추정이므로 원문 확인 필요) |
| Designer 411~414 | 컬럼헤더: HorizontalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced, VerticalAlignment General | 헤더 전체 |

- 코드로 추가하는 컬럼은 없습니다. 숨김으로 바꾸는 변경도 없습니다.

## 4. 시트 연결 규칙

- 시트 1개(`Shipment Model PIC`)이므로 시트 간 연결(마스터-디테일)은 없습니다.
- 그리드 이벤트: `SpdMain_CellDoubleClick`, `SpdMain_TopChange`. 동작 내용은 확인 필요입니다.

=== FILE: oracle_migration.md ===
# SSP0014 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | 호출 지점 | 동작 | 참조 객체 | EXEC 체인 |
|---|---|---|---|---|
| `SSP0014_GET_SHIPMENT_MODEL_PIC` | FindData_Main:329 (조회 / 저장 후 재조회) | 조회 | SELECT: SCM_MST_SITE_ITEM, SCM_MST_SITE, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_ITEM_SN / REF: FN_GET_ITEM_NICKNAME, STRING_SPLIT | 없음 |
| `SSP0014_SAVE_SHIPMENT_MODEL_PIC` | SaveData:497 | 저장 | MERGE: SSP_MST_MODEL_USER / INSERT: SCM_SYS_LOG_BATCH / REF: SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | → `PR_SCM_SYS_LOG_BATCH` |
| `SSP0014_GET_USER_ID_CHECK` | GetUserIDChk:562 | 저장 전 사용자 ID 검사 | SELECT: TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION / REF: STRING_SPLIT | 없음 |

- 세 SP 모두 FoxQuery 키 `SSP.<SP명>` 이 등록되어 있습니다(상태 MATCH).
- 저장 대상 테이블: **SSP_MST_MODEL_USER**(MERGE). 저장 로그: SCM_SYS_LOG_BATCH(직접 INSERT + PR_SCM_SYS_LOG_BATCH EXEC).

## 2. 공통코드 분기

| 키 | 경로 | 원천 테이블 |
|---|---|---|
| `biz:CommonData.YesOrNo` | Data.Common[case Type.YesOrNo] > Data.CallBizData | Fact Pack에 없음 → 확인 필요 |
| GetSSPInnerTable (SetChangeControl:144, 149) | DataService.GetSSPInnerTable | 읽는 컬럼: CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID. 어떤 code 값으로 어떤 테이블을 조회하는지는 확인 필요 |

- `code=X → 테이블` 형태의 분기 사실은 Fact Pack에 없습니다 → **확인 필요**.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 미등록(NOT MATCH) 엔드포인트: 0건
- 직접 SQL 호출: 0건
- 주석 처리된 호출: 0건

## 4. Oracle 전환 확인 포인트 (Fact Pack 근거만)

| # | 대상 | 사실 | 확인 포인트 |
|---|---|---|---|
| 1 | SSP0014_GET_SHIPMENT_MODEL_PIC, SSP0014_GET_USER_ID_CHECK | `REF:STRING_SPLIT` 참조 | MSSQL `STRING_SPLIT` 은 Oracle에 없습니다. 프로젝트 금지 키워드(⑩)이므로 대체 구현이 필요합니다(REGEXP_SUBSTR/CONNECT BY, 공용 분할 함수 등. 방식은 확인 필요) |
| 2 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | `REF:SCM_ARR_SPL_CNT`, `REF:SCM_ARR_SPL_VAL` | 배열 분할 함수입니다. Oracle 쪽에 같은 이름의 함수가 있는지 확인 필요 |
| 3 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | `MERGE:SSP_MST_MODEL_USER` | MSSQL MERGE 문법(문장 끝 `;`, `WHEN NOT MATCHED BY SOURCE` 등)을 쓰는지 원문 확인 필요. Oracle MERGE 는 BY SOURCE 를 지원하지 않습니다 |
| 4 | SSP0014_SAVE_SHIPMENT_MODEL_PIC | `EXEC:PR_SCM_SYS_LOG_BATCH`, `INSERT:SCM_SYS_LOG_BATCH` | 로그 프로시저의 Oracle 이관 여부 확인 필요 |
| 5 | SSP0014_GET_SHIPMENT_MODEL_PIC | `REF:FN_GET_ITEM_NICKNAME` | 스칼라 함수의 Oracle 이관 여부 확인 필요 |
| 6 | SSP0014_GET_USER_ID_CHECK | `SELECT:TB_FX_USERGROUPAUTHEXTENTION` | 프레임워크 권한 테이블의 TO-BE 대응 테이블 확인 필요 |
| 7 | 공통 | TB_FX_USER 참조 (조회·검사 SP 2개) | TO-BE 사용자 테이블 매핑 확인 필요 |

### 난이도
- 사실 근거: SP 3개, EXEC 체인 1단계(PR_SCM_SYS_LOG_BATCH), MSSQL 전용 함수 STRING_SPLIT 2개 SP에서 참조, MERGE 1건.
- SP 원문 줄 수·동적 SQL 여부·임시테이블 사용은 Fact Pack에 없어 난이도 등급은 매기지 않았습니다 → **확인 필요**.

=== FILE: tobe_design.md ===
# SSP0014 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 순 | 라벨(원문) | As-is 컨트롤 | 필수 | 값 원천 | 비고 |
|---:|---|---|---|---|---|
| 1 | Division* | cboDivision (UsrCombo) | 필수(`*` 표기) | GetSSPInnerTable 추정 → 확인 필요 | 변경 시 CboDivision_SelectedIndexChanged |
| 2 | Operation Group | cboOperationGroup (UsrCombo) | 확인 필요 | 확인 필요 | – |
| 3 | From Site | clbFromSite (UsrCheckedList) | 확인 필요 | 확인 필요 | 다중 선택, GetCheckedListValue(CODE) |
| 4 | Valid | cboValidYN (UsrCombo) | 확인 필요 | YesOrNo 연결 여부 확인 필요 | – |
| 5 | User ID(Name) | txtUser (TextBox) | 확인 필요 | 직접 입력 | – |
| 6 | Model | txtItemId (UsrMultiLineEditor) + btnItemId | 확인 필요 | 직접 입력 / btnItemId_Click | 다중행 |

- 표의 순서는 Designer 선언 순서입니다. 실제 화면 배치 순서는 확인 필요입니다.
- TB_FX_SearchCondition 에 SSP0014 행이 112개 있습니다(저장된 조회조건). 컬럼 구성은 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | As-is 경로 | 호출 API(As-is 키) | TO-BE API 후보 |
|---|---|---|---|
| 조회 | FindButton > FindData_Main | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | 조회 API (SP SSP0014_GET_SHIPMENT_MODEL_PIC) |
| 저장 | SaveButton > SaveData > GetUserIDChk | `SSP.SSP0014_GET_USER_ID_CHECK` | 사용자 ID 검사 (저장 서비스 안 또는 별도 API, 확인 필요) |
| 저장 | SaveButton > SaveData | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | 저장 API (SP SSP0014_SAVE_SHIPMENT_MODEL_PIC) |
| 저장 후 | SaveData > FindData_Main | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | 재조회 |
| Model 버튼 | btnItemId_Click | 없음(Fact Pack 기준) | txtItemId 값 설정. 팝업 여부 확인 필요 |
| Division 변경 | CboDivision_SelectedIndexChanged | 확인 필요 | 종속 조회조건 갱신 여부 확인 필요 |
| 셀 더블클릭 | SpdMain_CellDoubleClick | 확인 필요 | 확인 필요 |
| 스크롤 | SpdMain_TopChange | 확인 필요 | 확인 필요 |
| 편집 | EditButton | GetSheetInfo(spdMain, ActiveSheetIndex) | 그리드 편집 모드 처리 |
| 화면 로드 | Form_Load | 확인 필요 (InitControls 의 FP_Log2 로그, SetChangeControl 의 GetSSPInnerTable) | 초기 콤보 로드 |

## 3. Division별 Grid 변형 요약

- 시트 `Shipment Model PIC` 1개, 21컬럼.
- 모든 division(40, 81 계열, 82, EE 계열)에서 21컬럼 모두 기본 표시 → **division별 변형 없음**.
- 코드 변경: 이미지 CellType 8건(InitSpread 225~233, 대상 컬럼 확인 필요). 라벨 변경·숨김 없음.
- 필수 표시 라벨: `User ID*`, `Valid*`.

## 4. 권한(C/R/U/D) 관련 사실

| 사실 | 출처 |
|---|---|
| 메뉴 권한 메타 TB_FX_GroupMenuAuth 13행 | DB 메타 |
| SetChangeControl:137~138 에서 Filter GROUP_ID / USER_ID 와 `UserInfoContext.Current.NowGroupID` 사용 | meta_reads |
| 저장 전 `SSP0014_GET_USER_ID_CHECK` 가 TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION 조회 | endpoints |
| 버튼 진입점: FindButton(R), SaveButton(C/U), EditButton | flow / grid_code |

- Delete 기능(D), 행 추가 버튼은 Fact Pack에서 확인되지 않습니다. SAVE SP 는 MERGE 만 참조합니다 → 삭제 지원 여부 **확인 필요**.
- 그룹별 C/R/U/D 플래그 값은 Fact Pack에 없습니다 → **확인 필요**.

## 5. 미확정 사항

1. SaveData 안의 실행 순서(사용자 검사 → 저장 → 재조회)와 실패 시 처리
2. SaveButton:285 호출 해석(PersonalSettingPopup.SaveData)이 맞는지
3. `biz:CommonData.YesOrNo` 를 쓰는 컨트롤(진입점 미연결)
4. 각 조회조건의 값 원천과 필수 여부(Division 외)
5. 이미지 CellType 8건의 대상 컬럼과 동작(CellDoubleClick 과의 관련 여부)
6. SpdMain_TopChange / SpdMain_CellDoubleClick / CboDivision_SelectedIndexChanged 본문
7. btnItemId_Click 의 sItemId 원천
8. usrButton1, imageList1 사용 여부
9. STRING_SPLIT, SCM_ARR_SPL_CNT/VAL, FN_GET_ITEM_NICKNAME, PR_SCM_SYS_LOG_BATCH 의 Oracle 대응 객체
10. 메타 컬럼 순서·폭·정렬·편집 여부(SCM_MST_SHEET_COLUMNS 원문 대조)
