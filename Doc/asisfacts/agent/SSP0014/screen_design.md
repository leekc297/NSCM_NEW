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
