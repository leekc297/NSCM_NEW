=== FILE: business_analysis.md ===
# SSP0014 Shipment Model PIC — 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0014)과 1차 분석서(analysis.md, web_components.md, tobe_design.md).
> Fact Pack에 없는 내용은 **확인 필요**로 적었습니다. 업무 규칙을 추측해서 만들지 않았습니다.
> 주석 처리된 호출(commented_calls)은 0건이므로, 이 문서의 기능은 모두 현재 동작하는 호출입니다.

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0014 / `SSP0014_ShipmentModelPIC` | Designer.cs:546 `this.Text` |
| 도메인 / 프로젝트 | SSP / `GSCM.SSP.Plan.UIL` | Fact Pack §1 |
| 업무 대상 데이터 | Model(ITEM_ID) 단위 담당자 정보. 그리드 컬럼에 USER_ID, PART_LEADER, TEAM_LEADER, MAIL_USER1~5, VALID_YN이 있음 | grid_effective.csv |
| 저장 대상 테이블 | `SSP_MST_MODEL_USER`(MERGE) | endpoints.csv `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| 범위 | 조회, 저장(사용자 ID 검사 포함), 저장 후 재조회 | flow.csv |
| 범위 밖 / 확인 필요 | 행 삭제(D) 기능. SAVE SP는 MERGE만 참조하고 DELETE를 참조하지 않으므로 삭제 지원 여부는 **확인 필요** | endpoints.csv |
| 업무 목적 서술 | 화면 명칭(Shipment Model PIC)과 컬럼 구성만 있고, 업무 목적 원문은 Fact Pack에 없음 → **확인 필요** | – |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 | 근거 |
|---|---|---|---|---|
| S1 | 화면 열기 | `Form_Load` 실행(.ctor:110에서 배선). InitControls에서 `DataService.FP_Log2` 호출(170·173), SetChangeControl에서 `DataService.GetSSPInnerTable` 호출(144·149) | 조회조건 콤보 초기화(어느 콤보인지는 확인 필요). 그리드 시트 `Shipment Model PIC` 생성(CreateSpread:208) | events.csv, Fact Pack §4-2, grid_code.csv |
| S2 | Division 변경 | `CboDivision_SelectedIndexChanged` 실행 | 본문이 Fact Pack에 없음 → **확인 필요** | events.csv |
| S3 | Model 버튼(btnItemId) 클릭 | `btnItemId_Click` 실행 | `txtItemId.Text = sItemId`(857). sItemId를 어디서 얻는지는 **확인 필요** | props.csv:857 |
| S4 | 조회(FindButton) | FindButton > FindData_Main. 조회조건 값을 `CString.GetCheckedListValue`(310~313)로 만든 뒤 `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` 호출(329) | 그리드에 결과 표시 | flow.csv |
| S5 | 그리드 편집 후 저장(SaveButton) | SaveButton > SaveData. 안에서 `SSP.SSP0014_GET_USER_ID_CHECK`(GetUserIDChk:562), `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`(497), `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC`(재조회, 329) 호출 | `SSP_MST_MODEL_USER`에 MERGE 반영, `SCM_SYS_LOG_BATCH`에 INSERT, 그리드 재조회. 실행 순서와 조건은 **확인 필요** | flow.csv, endpoints.csv |
| S6 | 그리드 셀 더블클릭 | `SpdMain_CellDoubleClick` 실행 | 본문 **확인 필요** | events.csv |
| S7 | 그리드 스크롤 | `SpdMain_TopChange` 실행 | 본문 **확인 필요** | events.csv |
| S8 | 편집(EditButton) | `if(fps.Name == "spdMain")`이면 GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex)(271) | 활성 시트 정보 사용. 이후 처리는 **확인 필요** | grid_code.csv |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기]
  └─ Form_Load
       ├─ InitControls : FP_Log2(로그) · insertRow["CODE"/"NAME"] 행 추가(대상 콤보 확인 필요)
       ├─ SetChangeControl : Filter GROUP_ID/USER_ID · UserInfoContext.Current.NowGroupID · GetSSPInnerTable
       └─ CreateSpread → AddSheet("Shipment Model PIC") → InitSpread → SetSheetHeaderColumn(메타 21컬럼) → 이미지 CellType 8건
[조건 입력]
  ├─ cboDivision 변경 → CboDivision_SelectedIndexChanged (본문 확인 필요)
  └─ btnItemId 클릭 → btnItemId_Click → txtItemId.Text = sItemId
[조회] FindButton → FindData_Main → SSP.SSP0014_GET_SHIPMENT_MODEL_PIC → SP SSP0014_GET_SHIPMENT_MODEL_PIC → spdMain
[저장] SaveButton → SaveData
        ├─ GetUserIDChk → SSP.SSP0014_GET_USER_ID_CHECK → SP SSP0014_GET_USER_ID_CHECK
        ├─ SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC → SP SSP0014_SAVE_SHIPMENT_MODEL_PIC (→ EXEC PR_SCM_SYS_LOG_BATCH)
        └─ FindData_Main → SSP.SSP0014_GET_SHIPMENT_MODEL_PIC (재조회)
        ※ 세 호출의 순서와 분기 조건은 확인 필요. 위 나열은 flow.csv 행을 옮긴 것이고 실행 순서를 확인한 것이 아닙니다.
[미연결] <field:dtYesOrNo>(54) → biz:CommonData.YesOrNo (진입점 미연결, 사용 컨트롤 확인 필요)
```

## 4. 업무 규칙

| # | 규칙 | 사실 근거 | 상태 |
|---|---|---|---|
| R1 | 조회조건 Division은 필수 | 라벨 원문 `Division*`(props.csv:325) | 라벨 `*` 기준. 코드에서 검증하는지는 **확인 필요** |
| R2 | 그리드 USER_ID, VALID_YN은 필수 입력 컬럼 | 메타 라벨 `User ID*`, `Valid*` | 라벨 기준. 저장 전 검증 로직은 **확인 필요** |
| R3 | 저장할 때 사용자 ID를 검사함 | SaveData > GetUserIDChk가 `SSP0014_GET_USER_ID_CHECK` 호출. SP가 TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION 조회 | 검사 기준(존재·권한 그룹 등)과 실패 시 처리는 **확인 필요** |
| R4 | 저장은 MERGE(있으면 갱신, 없으면 추가) | `SSP0014_SAVE_SHIPMENT_MODEL_PIC`: MERGE SSP_MST_MODEL_USER | MERGE 키 컬럼은 **확인 필요** |
| R5 | 저장하면 배치 로그를 남김 | SAVE SP: INSERT SCM_SYS_LOG_BATCH, EXEC PR_SCM_SYS_LOG_BATCH | 로그 내용은 **확인 필요** |
| R6 | 다건 값은 구분자 문자열로 전달하고 SP에서 분해함 | GET·USER_ID_CHECK SP의 REF STRING_SPLIT, SAVE SP의 REF SCM_ARR_SPL_CNT/SCM_ARR_SPL_VAL, FindData_Main의 GetCheckedListValue 4회(310~313) | 구분자와 파라미터 매핑은 **확인 필요** |
| R7 | Model 닉네임은 함수로 구함 | GET SP REF FN_GET_ITEM_NICKNAME, 그리드 NICK_NAME 컬럼 | 컬럼과 함수의 연결은 **확인 필요** |
| R8 | 날짜/버킷 규칙 | Fact Pack에 날짜 조회조건이나 버킷 로직이 없음 | 해당 없음(사실 없음) |
| R9 | SP 분기 조건 | Fact Pack에 SP 내부 분기 조건이 없음 | **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | 호출 위치 | SP | 읽기(SELECT/REF) | 쓰기 | 화면설계서 §5 |
|---|---|---|---|---|---|
| `biz:CommonData.YesOrNo` | `<field:dtYesOrNo>`:54 (진입점 미연결) | 없음(Data.Common[Type.YesOrNo] > Data.CallBizData) | 확인 필요 | 없음 | A-07 |
| `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | FindData_Main:329 | `SSP0014_GET_SHIPMENT_MODEL_PIC` | SCM_MST_SITE_ITEM, SCM_MST_SITE, SSP_MST_MODEL_USER, TB_FX_USER, SCM_MST_ITEM_SN / REF FN_GET_ITEM_NICKNAME, STRING_SPLIT | 없음 | A-01, A-02 |
| `SSP.SSP0014_GET_USER_ID_CHECK` | GetUserIDChk:562 | `SSP0014_GET_USER_ID_CHECK` | TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION / REF STRING_SPLIT | 없음 | A-02 |
| `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | SaveData:497 | `SSP0014_SAVE_SHIPMENT_MODEL_PIC` (+EXEC PR_SCM_SYS_LOG_BATCH) | REF SCM_ARR_SPL_CNT, SCM_ARR_SPL_VAL | MERGE SSP_MST_MODEL_USER, INSERT SCM_SYS_LOG_BATCH | A-02 |

프레임워크 호출(엔드포인트 아님): `DataService.GetSSPInnerTable`(SetChangeControl:144·149), `DataService.FP_Log2`(InitControls:170·173), `SpreadInfo.SetSheetHeaderColumn`(InitSpread:222, SCM_MST_SHEET_COLUMNS 메타).

## 6. Division·권한별 변형

**Division**
- 시트 `Shipment Model PIC`는 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)에서 21컬럼이 모두 '기본' 표시입니다. 필수+기본은 21, 선택은 0입니다. **division별 차이는 없습니다.**
- 코드 분기 중 division을 판단하지 못한 건: 0건.
- 실제 SP 실행 결과와 시트를 대조하는 단계는 실행하지 않았습니다 → **확인 필요**.

**권한**
- SetChangeControl:137~138에서 Filter `GROUP_ID`, `USER_ID`와 `UserInfoContext.Current.NowGroupID`를 사용합니다. 그룹·사용자에 따라 조회조건이 달라지는지는 **확인 필요**입니다.
- 메뉴 권한 메타 TB_FX_GroupMenuAuth에 13행이 있습니다. 그룹별 C/R/U/D 값은 Fact Pack에 없음 → **확인 필요**.
- 저장 시 `SSP0014_GET_USER_ID_CHECK`가 TB_FX_USERGROUPAUTHEXTENTION을 조회합니다. 권한 그룹과 관련한 검사로 보이지만 내용은 **확인 필요**입니다.

## 7. 외부 인터페이스

- Fact Pack에 외부 시스템 인터페이스 사실이 없습니다 → 해당 없음.
- (참고) 배치 로그 테이블 SCM_SYS_LOG_BATCH에 INSERT하는 것은 내부 로그이며 외부 인터페이스로 확인된 사실은 아닙니다.

## 8. 미확정·확인 필요

1. SaveData 안에서 GetUserIDChk → SAVE → 재조회가 실행되는 순서, 조건, 실패 시 처리
2. SaveButton:285의 `SaveData` 해석. 추출기가 `PersonalSettingPopup.SaveData`로 해석했지만, 화면 자체 SaveData(497)일 수 있음
3. `biz:CommonData.YesOrNo`(dtYesOrNo:54)를 쓰는 컨트롤. cboValidYN과 연결된다는 것은 추정임
4. FindData_Main 310~313의 GetCheckedListValue 4회가 각각 어느 컨트롤 값인지
5. 각 조회조건의 값 원천과 필수 여부(Division 외)
6. GET_USER_ID_CHECK의 검사 기준과 메시지
7. MERGE 키와 삭제 지원 여부
8. 이벤트 핸들러 본문(Form_Load, SpdMain_TopChange, SpdMain_CellDoubleClick, CboDivision_SelectedIndexChanged)
9. Oracle 대응 객체: STRING_SPLIT, SCM_ARR_SPL_CNT/VAL, FN_GET_ITEM_NICKNAME, PR_SCM_SYS_LOG_BATCH
10. 업무 목적 원문과 메뉴 위치(TB_FX_MenuItemInfo 1행 원문 대조)

=== FILE: screen_design.md ===
# SSP0014 Shipment Model PIC — 화면설계서

> 근거: Fact Pack(controls.csv, props.csv, events.csv, grid_effective.csv, grid_code.csv). 없는 사실은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0014 |
| 화면 명칭 | Shipment Model PIC (폼 Text `SSP0014_ShipmentModelPIC`, Designer.cs:546) |
| 클래스 / 파일 | `SSP0014_ShipmentModelPIC` / SSP0014_ShipmentModelPIC.cs(864줄), .Designer.cs(596줄) |
| 메뉴 위치 | **확인 필요** (TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행 원문 대조) |
| 그리드 시트 | `Shipment Model PIC` (1개) |
| 저장 조회조건 | TB_FX_SearchCondition 112행 (컬럼 구성 확인 필요) |

## 2. 화면 레이아웃

**분할 구조 사실**
- props.csv에 **SplitContainer가 없습니다**(Orientation·SplitterDistance 값 없음). 좌/우 분할이 없고, Dock(Top/Fill)으로 상/하만 나뉩니다.
- parent 체인(controls.csv)
  - `this` → `usrConditionPanel1`(Dock=Top, 1192×67, UsrPanelType=HidePanel) → `usrLayoutControl2`(Dock=Fill, 1192×67) → cboDivision, cboOperationGroup, clbFromSite, cboValidYN, txtUser, btnItemId, txtItemId
  - `this` → `spdMain`(Dock=Fill, 1192×582) — 시트 `spdMain_Sheet1`
  - `usrButton1`(75×23): parent 없음 → 배치·사용 여부 **확인 필요**
  - `imageList1`: parent 없음(비시각 자원)
- 상/하 비율(Size 높이 기준): 67 : 582 → **상 10.3% / 하 89.7%**

**텍스트 와이어프레임** (조회조건 줄 구분은 LayoutControlItem 높이 25/28로 판단한 것이며, 좌표는 Fact Pack에 없음 → 확인 필요)

```
┌──────────────────────────── this (SSP0014_ShipmentModelPIC) ────────────────────────────┐
│ usrConditionPanel1 [Dock=Top · 1192×67 · HidePanel]                       ── 상 10.3% ──│
│ └ usrLayoutControl2 [Dock=Fill · 1192×67] (layoutControlGroup2 1192×73)                 │
│   줄1(높이25): [Division* cboDivision 244] [Operation Group cboOperationGroup 240]      │
│                [From Site clbFromSite 301] [Valid cboValidYN 139] [emptySpaceItem2 248] │
│   줄2(높이28): [User ID(Name) txtUser 240] [Model txtItemId 201] [btnItemId 43]         │
│                [emptySpaceItem1 688]                                                    │
├──────────────────────────────────────────────────────────────────────────────────────────┤
│ spdMain [Dock=Fill · 1192×582]                                            ── 하 89.7% ──│
│ └ spdMain_Sheet1 → 시트 "Shipment Model PIC" (메타 21컬럼, 헤더 1행)                    │
└──────────────────────────────────────────────────────────────────────────────────────────┘
(배치 미확인) usrButton1 75×23 · imageList1
```

**영역**
| 영역 | 구성 |
|---|---|
| 조회조건 | usrConditionPanel1 / usrLayoutControl2 안의 7개 컨트롤 |
| 버튼 | 프레임워크 버튼 FindButton(조회), SaveButton(저장), EditButton(편집). 화면 안 버튼은 btnItemId, usrButton1(확인 필요) |
| 그리드 | spdMain / spdMain_Sheet1 |
| 팝업 | btnItemId_Click에서 팝업을 띄우는지 **확인 필요**(sItemId 원천 미확인) |

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props.csv Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| usrButton1 | UsrButton | (Text 없음) | 확인 필요 | – | 없음 | 확인 필요(사용 여부 미확인) |
| usrConditionPanel1 | UsrConditionPanel | (Text 없음) | HidePanel | – | 없음 | 조회조건 패널(공용 SearchCondition) |
| usrLayoutControl2 | UsrLayoutControl | `usrLayoutControl2` | – | – | 없음 | 조회조건 레이아웃 그리드 |
| cboDivision | UsrCombo | `Division*` (layout item `Division`) | 확인 필요 | 필수(`*`) | SelectedIndexChanged → CboDivision_SelectedIndexChanged | Wijmo ComboBox |
| cboOperationGroup | UsrCombo | `Operation Group` (layoutControlItem1) | 확인 필요 | 확인 필요 | 없음 | Wijmo ComboBox |
| clbFromSite | UsrCheckedList | `From Site` (layoutControlItem7) | 확인 필요 | 확인 필요 | 없음 | Wijmo MultiSelect |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | 확인 필요 | 확인 필요 | 없음 | Wijmo ComboBox |
| txtUser | TextBox | `User ID(Name)` (layoutControlItem2) | 확인 필요 | 확인 필요 | 없음 | Input(text) |
| txtItemId | UsrMultiLineEditor | `Model` (lblItemId) | 확인 필요 | 확인 필요 | btnItemId_Click에서 Text 설정(857) | 다중행 입력 |
| btnItemId | UsrButton | `layoutControlItem2` (layoutControlItem4 Text 원문. 표시 여부 확인 필요) | – | – | Click → btnItemId_Click | 아이콘 버튼 |
| spdMain | FpSpread | (Text 없음) | – | – | TopChange → SpdMain_TopChange / CellDoubleClick → SpdMain_CellDoubleClick | Wijmo FlexGrid |
| spdMain_Sheet1 | SheetView | (Text 없음) — 시트명 `Shipment Model PIC` | – | – | – | FlexGrid 데이터 소스(시트) |
| imageList1 | ImageList | – | – | – | – | 아이콘 자원(이미지 CellType과의 관계 확인 필요) |

## 4. 그리드 명세 — 시트 `Shipment Model PIC`

- 생성: CreateSpread:208 `AddSheet(spdMain, "Shipment Model PIC", "Shipment Model PIC", 1, 1, 30)` → GetSheetInfo(spdMain.Name, 0) → ChangeSheet
- 컬럼: InitSpread:222 `SetSheetHeaderColumn(spdInfo, 1)` (SCM_MST_SHEET_COLUMNS 메타, 헤더 1행). AddSheet 인자 `1, 1, 30`의 의미는 확인 필요.
- 표시 순서: 아래는 grid_effective.csv 행 순서(알파벳순)입니다. 실제 순서, 폭, 정렬, 편집 가능 여부는 메타 원문(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, CELL_CONTROL_OBJECT_TYPE_CODE 등) 대조가 필요합니다 → **확인 필요**.

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | CREATED_BY | Created By | 확인 필요 | META | 14개 division 모두 기본 | 확인 필요 |
| 2 | CREATION_DATE | Creation Date | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 3 | DIVISION_ID | Division | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 4 | FROM_SITE | From Site | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 5 | ITEM_ID | Model | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 6 | LAST_UPDATE_DATE | Last Update Date | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 7 | LAST_UPDATED_BY | Last Updated By | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 8 | MAIL_USER1 | Mail User1 | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 9 | MAIL_USER2 | Mail User2 | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 10 | MAIL_USER3 | Mail User3 | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 11 | MAIL_USER4 | Mail User4 | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 12 | MAIL_USER5 | Mail User5 | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 13 | NICK_NAME | Nick Name | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 14 | OPERATION_GROUP | Operation Group | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 15 | PART_LEADER | Part Leader | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 16 | PART_LEADER_NAME | Part Leader Name | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 17 | TEAM_LEADER | Team Leader | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 18 | TEAM_LEADER_NAME | Team Leader Name | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 19 | USER_ID | User ID* | 확인 필요 | META | 모두 기본 | 확인 필요(라벨 `*` = 필수) |
| 20 | USER_NAME | User Name | 확인 필요 | META | 모두 기본 | 확인 필요 |
| 21 | VALID_YN | Valid* | 확인 필요 | META | 모두 기본 | 확인 필요(라벨 `*` = 필수) |

**코드 변경(OVERRIDE)**
| 위치 | 내용 | 조건 | 대상 컬럼 |
|---|---|---|---|
| InitSpread 225·226·227·229·230·231·232·233 | `CellType = cellTypeImage` (8건) | `if(spdInfo.SheetName == "Shipment Model PIC")` | **확인 필요** |
| Designer 411~414 | 컬럼헤더 HorizontalAlignment General / NoteIndicatorColor Red / Parent ColumnHeaderDefaultEnhanced / VerticalAlignment General | 없음 | 헤더 전체 |

- 코드로 컬럼을 추가하거나 숨기는 변경은 없습니다. division별 차이도 없습니다(14개 division 모두 21컬럼).

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A-01 | 조회(FindButton) | FindData_Main | GetCheckedListValue(CODE) 310~313로 파라미터 구성 후 호출(329) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | spdMain(`Shipment Model PIC`)에 바인딩 |
| A-02 | 저장(SaveButton) | SaveData (SaveButton:285. 해석 확인 필요) | 사용자 ID 검사(GetUserIDChk:562), 저장(497), 재조회(329). 순서와 조건은 확인 필요 | `SSP.SSP0014_GET_USER_ID_CHECK`, `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | SSP_MST_MODEL_USER MERGE 후 그리드 재조회 |
| A-03 | 편집(EditButton) | EditButton | `fps.Name == "spdMain"`이면 GetSheetInfo(spdMain.Name, ActiveSheetIndex)(271) | 없음 | 확인 필요 |
| A-04 | 화면 로드 | `Form_Load` | InitControls(FP_Log2, CODE/NAME 행 추가), SetChangeControl(GetSSPInnerTable), CreateSpread/InitSpread | 없음(프레임워크 호출만) | 콤보 초기화, 시트 생성 |
| A-05 | cboDivision 변경 | `CboDivision_SelectedIndexChanged` | 본문 확인 필요 | 확인 필요 | 확인 필요 |
| A-06 | btnItemId 클릭 | `btnItemId_Click` | `txtItemId.Text = sItemId`(857) | 없음(Fact Pack 기준) | txtItemId 값 설정 |
| A-07 | (진입점 미연결) | `<field:dtYesOrNo>`:54 | Data.Common[Type.YesOrNo] > Data.CallBizData | `biz:CommonData.YesOrNo` | 사용 컨트롤 확인 필요 |
| A-08 | spdMain 셀 더블클릭 | `SpdMain_CellDoubleClick` | 본문 확인 필요 | 확인 필요 | 확인 필요 |
| A-09 | spdMain 스크롤 | `SpdMain_TopChange` | 본문 확인 필요 | 확인 필요 | 확인 필요 |

## 6. 검증·메시지

| 항목 | 사실 | 상태 |
|---|---|---|
| Division 필수 | 라벨 `Division*` | 검증 코드와 메시지 원문 **확인 필요** |
| 그리드 필수 컬럼 | `User ID*`, `Valid*` | 검증 코드와 메시지 원문 **확인 필요** |
| 사용자 ID 검사 | `SSP.SSP0014_GET_USER_ID_CHECK`(TB_FX_USER, TB_FX_USERGROUPAUTHEXTENTION) | 실패 시 메시지 **확인 필요** |
| 기타 메시지 | Fact Pack에 메시지 키 사실이 없음 | **확인 필요** |

## 7. 권한(C/R/U/D) 사실

| 구분 | 사실 |
|---|---|
| R | FindButton → `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| C/U | SaveButton → `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` (MERGE) |
| D | 확인된 사실 없음(SAVE SP에 DELETE 참조 없음) → 확인 필요 |
| 메뉴 권한 메타 | TB_FX_GroupMenuAuth 13행. 플래그 값 확인 필요 |
| 사용자 컨텍스트 | SetChangeControl:137~138 Filter GROUP_ID/USER_ID, UserInfoContext.Current.NowGroupID |

## 8. To-Be 전환 메모 (Wijmo·Oracle)

1. FpSpread `spdMain` → Wijmo FlexGrid. 컬럼은 SCM_MST_SHEET_COLUMNS 메타(PROGRAM_ID=SSP0014, SHEET_NAME=`Shipment Model PIC`) 기반 동적 구성을 그대로 따릅니다. 이미지 CellType 8건은 대상 컬럼을 확인한 뒤 cellTemplate으로 옮깁니다.
2. UsrCheckedList `clbFromSite` → MultiSelect. 체크한 값을 구분자 문자열(GetCheckedListValue CODE)로 보내는 방식은 그대로 유지합니다.
3. usrConditionPanel1 HidePanel → 접이식 조회조건 패널(공용 컴포넌트).
4. Oracle 변환: `STRING_SPLIT`(MSSQL)은 Oracle 대응 함수/구문으로 바꿔야 합니다. SCM_ARR_SPL_CNT/VAL, FN_GET_ITEM_NICKNAME, PR_SCM_SYS_LOG_BATCH는 Oracle 대응 객체가 있는지 **확인 필요**합니다. MERGE SSP_MST_MODEL_USER는 Oracle MERGE로 옮깁니다.
5. 저장 체인(사용자 검사 → 저장 → 재조회)을 서비스 하나로 묶을지 API로 나눌지는, 실행 순서를 확인한 뒤 결정합니다.

## 9. 미확정

1. SplitContainer가 없어서 상/하 비율은 Size 값에서 계산한 것이며, 조회조건 내부 좌표는 확인 필요
2. usrButton1(parent 없음) 사용 여부
3. btnItemId 라벨 원문 `layoutControlItem2`가 화면에 표시되는지
4. 각 콤보의 데이터 원천과 초기값, `biz:CommonData.YesOrNo`의 사용 컨트롤
5. 이미지 CellType 8건의 대상 컬럼과 SpdMain_CellDoubleClick의 관계
6. 그리드 컬럼 순서, 폭, 정렬, 편집 여부(메타 원문 대조)
7. 핸들러 본문: Form_Load, SpdMain_TopChange, SpdMain_CellDoubleClick, CboDivision_SelectedIndexChanged, btnItemId_Click의 sItemId 원천
8. SaveButton:285 SaveData 해석(PersonalSettingPopup.SaveData)

=== FILE: unit_test.md ===
# SSP0014 Shipment Model PIC — 단위테스트

> 근거 열은 업무분석서 §5와 화면설계서 §5의 이름을 그대로 씁니다. 절차 열의 컨트롤명은 화면설계서 §3과 같습니다.
> 핸들러 본문이 확인되지 않은 케이스는 기대결과를 'AS-IS 실행 결과와 동일'로 적고, 판정 기준은 확인 필요로 남깁니다.
> 주석 처리된 호출(0건)은 테스트 케이스로 만들지 않았습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0014-001 | 초기화 | 로그인. SSP0014 메뉴 권한 보유 | 1) 화면을 연다 | – | `Form_Load` 실행. 조회조건(cboDivision, cboOperationGroup, clbFromSite, cboValidYN, txtUser, txtItemId)이 표시되고 spdMain에 시트 `Shipment Model PIC`가 생성됨. 콤보 초기값은 AS-IS와 동일(값은 확인 필요) | `Form_Load`, `Shipment Model PIC` |
| TC-SSP0014-002 | 초기화 | TC-001 | 1) usrConditionPanel1 영역 확인 2) usrLayoutControl2 안의 컨트롤 라벨 확인 | – | 라벨 원문 `Division*`, `Operation Group`, `From Site`, `Valid`, `User ID(Name)`, `Model`이 표시되고 btnItemId가 txtItemId 옆에 있음 | `Form_Load` |
| TC-SSP0014-003 | 그리드 | TC-001 | 1) spdMain / spdMain_Sheet1의 컬럼 헤더를 확인 | – | 21컬럼 헤더(Created By, Creation Date, Division, From Site, Model, Last Update Date, Last Updated By, Mail User1~5, Nick Name, Operation Group, Part Leader, Part Leader Name, Team Leader, Team Leader Name, User ID*, User Name, Valid*)가 모두 표시됨. 순서와 폭은 메타 원문과 일치 | `Shipment Model PIC` (SetSheetHeaderColumn) |
| TC-SSP0014-004 | 그리드 | TC-001 | 1) spdMain에서 이미지 셀이 적용된 컬럼 확인 | – | InitSpread 225~233의 이미지 CellType 8건이 AS-IS와 같은 컬럼에 적용됨(대상 컬럼은 확인 필요) | `Shipment Model PIC` |
| TC-SSP0014-005 | 조회 | 해당 조건의 데이터가 SSP_MST_MODEL_USER에 있음 | 1) cboDivision 선택 2) clbFromSite 체크 3) 조회 클릭 | Division=시험 계정 Division, From Site=1건 이상 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` 1회 호출, spdMain에 결과 행 표시, 행 수가 SP 직접 실행 결과와 같음 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC`, `SSP0014_GET_SHIPMENT_MODEL_PIC`, `Shipment Model PIC` |
| TC-SSP0014-006 | 조회 | TC-001 | 1) cboDivision 선택 2) clbFromSite 다건 체크 3) cboValidYN, txtUser, txtItemId 입력 4) 조회 | 다건 From Site, txtItemId 다중행 | 다건 값이 구분자 문자열로 전달되어(GetCheckedListValue, STRING_SPLIT) 조건에 맞는 행만 조회됨 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-007 | 조회 | 해당 조건 데이터 없음 | 1) txtItemId에 없는 Model 입력 2) 조회 | Model=존재하지 않는 값 | 오류 없이 0행 표시(빈 결과 메시지는 AS-IS와 동일, 확인 필요) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-008 | 조회 | cboDivision 미선택 상태를 만들 수 있음 | 1) cboDivision을 비움 2) 조회 | Division=빈값 | 필수(`Division*`) 처리가 AS-IS와 동일(검증 메시지 또는 동작은 확인 필요) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-009 | 저장 | TC-005 조회 완료 | 1) spdMain 행의 USER_ID를 유효한 사용자로 수정 2) 저장 | USER_ID=TB_FX_USER에 있는 ID | `SSP.SSP0014_GET_USER_ID_CHECK` 통과 → `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`가 SSP_MST_MODEL_USER에 MERGE, SCM_SYS_LOG_BATCH에 INSERT → `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` 재조회로 수정값 표시. 시험 후 원래 행으로 복원 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP.SSP0014_GET_USER_ID_CHECK`, `SSP0014_GET_USER_ID_CHECK`, `Shipment Model PIC` |
| TC-SSP0014-010 | 저장 | TC-005 조회 완료 | 1) spdMain 행의 USER_ID를 존재하지 않는 ID로 수정 2) 저장 | USER_ID=TB_FX_USER에 없는 ID | `SSP.SSP0014_GET_USER_ID_CHECK` 검사 결과에 따라 저장이 차단되거나 AS-IS와 같은 오류 메시지 표시. SSP_MST_MODEL_USER 변경 없음(검사 기준과 메시지는 확인 필요) | `SSP.SSP0014_GET_USER_ID_CHECK`, `SSP0014_GET_USER_ID_CHECK` |
| TC-SSP0014-011 | 저장 | TC-005 조회 완료 | 1) 필수 컬럼 VALID_YN 또는 USER_ID를 비움 2) 저장 | Valid*=빈값 | AS-IS와 같은 필수값 처리(오류 응답 또는 메시지). 데이터 변경 없음 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `Shipment Model PIC` |
| TC-SSP0014-012 | 저장 | 해당 키의 행이 SSP_MST_MODEL_USER에 없음 | 1) 신규 키로 저장할 수 있는 상태 만들기(방법은 확인 필요) 2) 저장 | 신규 Model/Site | MERGE로 INSERT 반영, 재조회에 표시. 시험 후 삭제 복원 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC`, `SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-013 | 저장 | SAVE SP 오류를 유발할 수 있는 시험 환경 | 1) SP 오류가 나는 값으로 저장 | 오류 유발 값(확인 필요) | 오류 메시지 표시, 부분 저장 없음(롤백), 그리드 유지 | `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-014 | 이벤트 | TC-001 | 1) cboDivision 값을 다른 Division으로 변경 | Division=다른 값 | `CboDivision_SelectedIndexChanged` 실행. 종속 조회조건(cboOperationGroup, clbFromSite 등) 갱신 여부가 AS-IS와 동일(본문 확인 필요) | `CboDivision_SelectedIndexChanged` |
| TC-SSP0014-015 | 이벤트 | TC-001 | 1) btnItemId 클릭 2) 값 선택(팝업 여부 확인 필요) | Model 1건 이상 | `btnItemId_Click` 실행, txtItemId.Text에 sItemId 값이 설정됨 | `btnItemId_Click` |
| TC-SSP0014-016 | 이벤트 | TC-005 조회 완료(여러 행) | 1) spdMain 셀 더블클릭 | 임의 행/컬럼(이미지 셀 포함) | `SpdMain_CellDoubleClick` 실행 결과가 AS-IS와 동일(본문 확인 필요) | `SpdMain_CellDoubleClick`, `Shipment Model PIC` |
| TC-SSP0014-017 | 이벤트 | TC-005 조회 완료(화면을 넘는 행 수) | 1) spdMain 세로 스크롤 | – | `SpdMain_TopChange` 실행 결과가 AS-IS와 동일(본문 확인 필요). 오류 없음 | `SpdMain_TopChange` |
| TC-SSP0014-018 | 초기화 | `biz:CommonData.YesOrNo`를 쓰는 컨트롤 확인(진입점 미연결) | 1) 해당 컨트롤(cboValidYN 후보, 확인 필요)의 항목 확인 | – | YesOrNo 공통 코드 목록이 AS-IS와 같은 항목으로 표시됨 | `biz:CommonData.YesOrNo` |
| TC-SSP0014-019 | division | Division 40 계정과 81 계정 각각 | 1) 각 계정으로 화면을 연다 2) spdMain 컬럼 수 확인 | Division=40, 81 | 두 Division 모두 `Shipment Model PIC` 21컬럼이 동일하게 표시됨(division별 변형 없음 확인) | `Shipment Model PIC`, `Form_Load` |
| TC-SSP0014-020 | division | Division 82 / EE 계정 각각 | TC-019와 같은 절차 | Division=82, EE | 21컬럼 동일 표시 | `Shipment Model PIC` |
| TC-SSP0014-021 | 권한 | 조회 권한만 있는 그룹 계정(TB_FX_GroupMenuAuth 기준, 확인 필요) | 1) 화면 열기 2) 조회 3) 저장 시도 | – | 조회는 되고, 저장 버튼 동작은 권한 메타에 따름(AS-IS와 동일) | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC`, `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` |
| TC-SSP0014-022 | 권한 | 그룹이 다른 두 계정 | 1) 각 계정으로 화면 열기 2) 조회조건 기본값 비교 | – | SetChangeControl(GROUP_ID/USER_ID, NowGroupID)에 따른 조회조건 차이가 AS-IS와 동일 | `Form_Load` |
| TC-SSP0014-023 | 조회 | 조회 SP 오류(예: 연결 단절)를 재현할 수 있는 시험 환경 | 1) 조회 | – | 오류 메시지 표시, 화면 비정상 종료 없음, 이전 그리드 상태 유지 | `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` |

**커버리지 확인**
| 대상 | 케이스 |
|---|---|
| `Form_Load` | 001, 002, 019, 022 |
| `SpdMain_TopChange` | 017 |
| `SpdMain_CellDoubleClick` | 016 |
| `CboDivision_SelectedIndexChanged` | 014 |
| `btnItemId_Click` | 015 |
| `biz:CommonData.YesOrNo` | 018 |
| `SSP.SSP0014_GET_SHIPMENT_MODEL_PIC` | 005, 006, 007, 008, 009, 021, 023 |
| `SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC` | 009, 011, 012, 013, 021 |
| `SSP.SSP0014_GET_USER_ID_CHECK` | 009, 010 |
| 시트 `Shipment Model PIC` | 001, 003, 004, 005, 009, 011, 016, 019, 020 |
| 빈 결과 / 오류 응답 | 007 / 010, 011, 013, 023 |
