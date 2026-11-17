=== FILE: business_analysis.md ===
# SSP0005 — Shipment Working Day 업무분석서

> 근거: AsisFacts 정적 추출 Fact Pack(SSP0005)과 1차 분석서(analysis.md, web_components.md, tobe_design.md)입니다. Fact Pack에 없는 내용은 **확인 필요**로 적었습니다.
> 대상 파일은 모두 현행 단일본(`only`)입니다.
> - `06.UIL\GSCM.SSP.Plan.UIL\SSP0005_ShipmentWorkingDay.cs` (955줄)
> - `SSP0005_ShipmentWorkingDay.Designer.cs` (545줄)

## 1. 업무 목적·범위

| 항목 | 내용 | 근거 |
|---|---|---|
| 화면 ID / 클래스 | SSP0005 / `SSP0005_ShipmentWorkingDay` | files |
| 도메인 | SSP (`GSCM.SSP.Plan.UIL`) | files |
| Form Text 원문 | `Working Time` | props.csv `this.Text`(501) |
| 메인 시트 | `Shipment Working Day` | grid_code `AddSheet`(179) |
| 업무 대상 데이터 | `SSP_MST_SHIP_CALENDAR`를 조회하고 저장합니다(UPDATE). | endpoints.csv objects |
| 범위(코드로 확인된 기능) | 조회(FindButton), 저장(SaveButton), 일괄 입력(btnInput), 요일 선택에 따른 입력값 활성/비활성, 헤더 더블클릭으로 컬럼 접기/펼치기 | flow.csv, events.csv |
| 범위 밖(확인된 진입점 없음) | 신규·삭제. `EditButton`(352)은 `GetSheetInfo` 호출만 추출되었습니다. | grid_code |
| 업무 목적 서술 | 출하 캘린더(`SSP_MST_SHIP_CALENDAR`)의 일자별 값을 Yes/No 콤보로 편집하는 화면입니다. 업무적 의미(근무일/출하 가능일 등)는 **확인 필요**입니다. | AddComboColumn `YesOrNo`(263) |

## 2. 사용자 시나리오 (행위 → 시스템 처리 → 결과)

| # | 사용자 행위 | 시스템 처리 | 결과 |
|---:|---|---|---|
| S1 | 화면 열기 | `Form_Load` → `InitControls`에서 `biz:CommonData.YesOrNo`를 `cboInputValue`에 바인딩합니다(168). `GetDayRange`가 `SCP.SCM0001_GET_SCP_PERIOD`(SP `SCM0001_GET_SCP_PERIOD`)를 호출합니다(941). `CreateSpread > InitSpread > GetSpdTitle`이 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`(SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`)을 호출합니다(925). | 조회조건이 초기화되고, 시트 `Shipment Working Day`의 메타 컬럼과 날짜 컬럼 헤더가 생성됩니다. 기간 값을 `drpPeriod` 초기값으로 쓰는지는 **확인 필요**입니다. |
| S2 | Company·Division·Period*·Day of the week를 지정 | Company·Division·Day of the week의 데이터 원천은 `biz:CommonData.CommonDataList`입니다(코드 Company / MyDivision / LookupCommon, 필드 45~47). 바인딩 경로는 unreached로 판정되어 **확인 필요**입니다. | 조건 입력 |
| S3 | 조회(FindButton) | `FindData_Main`이 Division 등 체크 목록 값을 `GetCheckedListValue`(387·388)로 만듭니다. 이어 `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`(SP `SSP0005_GET_SHIPMENT_WORKING_DAY`)를 호출하고(403), `InitSpread > GetSpdTitle`로 `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`을 다시 호출합니다. | 그리드가 다시 구성되고 데이터가 표시됩니다. |
| S4 | Day of the week 변경 | `CboDayWeek_SelectedIndexChanged` → `GetCheckedListValue`(660) → `cboInputValue.Enabled = false`(663) 또는 `true`(666) | Input Value가 활성화되거나 비활성화됩니다. 분기 조건은 **확인 필요**입니다. |
| S5 | Input 버튼(btnInput) 클릭 | `BtnInput_Click` → `GetCheckedListValue`(682). `dsdm.Changed -= SpdMain_Changed`(725)로 해제한 뒤 처리하고 `+=`(821)로 다시 연결합니다. 서버 호출은 추출되지 않았습니다. | 그리드에 일괄 반영됩니다. 반영 대상과 방식은 **확인 필요**입니다. |
| S6 | 그리드 셀 값 변경 | `SpdMain_Changed`가 자기 자신을 `-=`(878) / `+=`(902)로 해제·재연결합니다. | 그 사이 처리 내용은 **확인 필요**입니다. |
| S7 | 컬럼 헤더 더블클릭 | `SpdMain_CellDoubleClick`가 `e.ColumnHeader`일 때만 동작합니다. `M_` 헤더면 `W_` 컬럼과 보이는 `D_` 컬럼을 반전하고, `W_` 헤더면 `D_` 컬럼을 반전합니다. | 컬럼 접기/펼치기 |
| S8 | 저장(SaveButton) | `SaveData_Main`이 `GetChanges`(538, ROW_ID 기준)로 변경분을 추출합니다. 이어 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`(SP `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, 535·536·537 참조)를 호출하고 `FindData_Main`으로 재조회합니다. | `SSP_MST_SHIP_CALENDAR`가 UPDATE되고 `SCM_SYS_LOG_BATCH`에 INSERT됩니다. 이후 재조회합니다. |
| S9 | 그리드 스크롤 | `SpdMain_TopChange` | 내부 동작은 **확인 필요**입니다. |

## 3. 업무 흐름도 (텍스트 단계)

```
[화면 열기] Form_Load
  ├─ InitControls
  │    ├─ cboInputValue ← biz:CommonData.YesOrNo (168)
  │    └─ GetDayRange → SCP.SCM0001_GET_SCP_PERIOD (941)
  └─ CreateSpread → AddSheet("Shipment Working Day", 3, 1, 35) (179)
       └─ InitSpread
            ├─ GetSpdTitle → SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (925)
            ├─ SetSheetHeaderColumn(spdInfo, 3) : 메타 COMPANY_ID, DIVISION_ID (196)
            └─ InitSpreadDateColumn : 날짜 Combo 컬럼(YesOrNo) 루프 생성 (198/263)
        ↓
[조건 입력] cboCompany / clbDivision / drpPeriod / cboDayWeek(→ CboDayWeek_SelectedIndexChanged) / cboInputValue
        ↓
[조회] FindButton → FindData_Main
  ├─ SSP.SSP0005_GET_SHIPMENT_WORKING_DAY (403)
  └─ InitSpread > GetSpdTitle → SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN (925)
        ↓
[편집] 셀 직접 변경(SpdMain_Changed) / 일괄 입력(BtnInput_Click) / 헤더 접기(SpdMain_CellDoubleClick)
        ↓
[저장] SaveButton → SaveData_Main
  ├─ GetChanges (538, ROW_ID)
  ├─ SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW (535·536·537)
  └─ FindData_Main 재조회 (403 → 925)
```

## 4. 업무 규칙 (사실 근거)

| # | 규칙 | 근거 | 비고 |
|---:|---|---|---|
| R1 | 기간(Period)에 필수 표시 `*`가 있습니다. | props `layoutControlItem6.Text = "Period*"`(391) | 실제 미입력 검증 코드는 **확인 필요** |
| R2 | Division은 체크 목록(다중 선택)이며 값은 `CODE` 기준으로 연결됩니다. | `UsrCheckedList`, `GetCheckedListValue`(FindData_Main:387·388), 메타 컬럼 CODE | 구분자·파라미터명은 **확인 필요** |
| R3 | Division 목록은 사용자 그룹(`UserInfoContext.Current.NowGroupID`)을 기준으로 합니다. | meta_reads(45), `[code=MyDivision]` 코드분기 SELECT `SCM_MST_DIVISION`, `TB_FX_USERGROUPAUTHEXTENTION` | |
| R4 | Day of the week 선택에 따라 Input Value 활성 여부가 바뀝니다. | `CboDayWeek_SelectedIndexChanged` 663(false)/666(true) | 조건은 **확인 필요** |
| R5 | 일괄 입력 중에는 셀 변경 이벤트(`SpdMain_Changed`)를 해제합니다. | events 725(-=)/821(+=) | |
| R6 | `SpdMain_Changed`는 처리 중 자기 재호출을 막습니다. | events 878(-=)/902(+=) | |
| R7 | 날짜 컬럼은 SCP0009 결과 행마다 생성되는 Combo(YesOrNo) 셀입니다. 폭은 70이고 가로·세로 모두 Center입니다. | grid_code 263 | |
| R8 | 컬럼명에 `B_`가 포함되면(`IndexOf("B_") > 0`) AddComboColumn 분기를 타지 않습니다. | grid_code 263 조건 `else!(...)` | B_ 분기 처리 내용은 **확인 필요** |
| R9 | 요일 색상 규칙: `DAY_CODE`가 SAT이면 Blue, SUN이면 Red(ForeColor)입니다. | grid_code 267 | |
| R10 | 헤더는 3단입니다. row 0 = `LARGE_CLASS_LABEL_NAME`, row 1 = `SMALL_CLASS_LABEL_NAME`이 같은 값끼리 병합되며 높이는 20입니다. | grid_code 196(인자 3), 274·280·290·301·303 | 버킷 단위(월·주·일)와의 대응은 **확인 필요** |
| R11 | 버킷 접기/펼치기: Tag 접두어 `M_`·`W_`·`D_` 계층에 따라 Visible을 반전합니다. | grid_code 840·843·854 | 접두어의 업무 의미는 **확인 필요** |
| R12 | 저장 대상은 변경 행뿐입니다(`GetChanges`, ROW_ID). | 4-2 GetChanges(538) | |
| R13 | 저장할 때 배치 로그를 남깁니다. | SP 객체 `EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN`, `INSERT:SCM_SYS_LOG_BATCH` | |
| R14 | 저장 후 자동으로 재조회합니다. | flow `SaveButton > SaveData_Main > FindData_Main` | |
| R15 | 조회 SP는 동적 피벗을 사용합니다. | `INSERT:#TBLDYNAMICPIVOT_SSP0005`, `DYNAMIC@SSP0005_GET_SHIPMENT_WORKING_DAY`, `REF:STRING_SPLIT` | |
| R16 | 기간 산출 SP는 달력과 주차 함수를 참조합니다. | `SCM0001_GET_SCP_PERIOD`: `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, `CTE_DATE` | 산출 규칙의 상세는 **확인 필요** |

## 5. 데이터 흐름 표 (엔드포인트 → SP → 읽기/쓰기 테이블)

| 엔드포인트 | SP | 호출 지점 | 읽기 | 쓰기 | 화면설계서 §5 액션 |
|---|---|---|---|---|---|
| `biz:CommonData.YesOrNo` | - (biz) | InitControls:168, field dtYesOrNo:48 | 확인 필요 | - | A1 화면 로드 |
| `biz:CommonData.CommonDataList` [code=Company] | - (biz, 코드분기 `UP_FX_GetCommonDataList` / `UP_FX_GetCommonDataList_SCP_ALL`) | field dtCompany:46 (unreached) | `SCM_MST_COMPANY_SN`, `SCM_MST_PLANT_SN` | - | A1 화면 로드(확인 필요) |
| `biz:CommonData.CommonDataList` [code=MyDivision] | - (biz, `UP_FX_GetCommonDataList`) | field dtMyDivision:45 (unreached) | `SCM_MST_DIVISION`, `TB_FX_USERGROUPAUTHEXTENTION` | - | A1 화면 로드(확인 필요) |
| `biz:CommonData.CommonDataList` [code=LookupCommon] | - (biz, `UP_FX_GetCommonDataList`) | field dtDayWeek:47 (unreached) | `SCM_ADM_LOOKUP_MASTER`, `SCM_ADM_LOOKUP_MASTER_DETAIL` | - | A1 화면 로드(확인 필요) |
| `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | - (biz) | SetChangedPeriod:910 (unreached) | 확인 필요(결과 FROM_VALUE·TO_VALUE 사용) | - | 확인 필요 |
| `SCP.SCM0001_GET_SCP_PERIOD` | `SCM0001_GET_SCP_PERIOD` | GetDayRange:941 | `SCM_SYS_CALENDAR_M`, `SCM_ADM_LOOKUP_MASTER_DETAIL`, (함수) `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, (CTE) `CTE_DATE` | - | A1 화면 로드 |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SCP0009_GET_SHEET_CALENDAR_3SPAN` | GetSpdTitle:925 | `SCM_SYS_CALENDAR_M` | - | A1 화면 로드, A2 조회, A3 저장 후 재조회 |
| `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | `SSP0005_GET_SHIPMENT_WORKING_DAY` | FindData_Main:403 | `SSP_MST_SHIP_CALENDAR`, `SCM_SYS_CALENDAR_M` | (임시) `#TBLDYNAMICPIVOT_SSP0005` | A2 조회, A3 저장 후 재조회 |
| `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` (+ `PR_SCM_SYS_LOG_BATCH_CALL_TRAN`) | SaveData_Main:535·536·537 | - | `SSP_MST_SHIP_CALENDAR`(UPDATE), `SCM_SYS_LOG_BATCH`(INSERT) | A3 저장 |

> 주석 처리된 호출 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`(569)와 `SCP.GET_DATE_RANGE_1MONTH`(940)는 현행 기능이 아니므로 이 표에서 제외했습니다.

## 6. Division·권한별 변형

| 항목 | 사실 |
|---|---|
| 그리드 메타 컬럼 | 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 같습니다. 필수+기본 2개 / 선택 0개입니다(COMPANY_ID, DIVISION_ID). |
| 코드 내 division 분기 | 추출되지 않았습니다(판단불가 0건). |
| 날짜 컬럼 | SCP0009 실행 결과로 정해지며 정적 집계에는 포함되지 않습니다. division에 따른 차이가 있는지는 **확인 필요**입니다. |
| Division 선택 목록 | 사용자 그룹(`NowGroupID`)과 `TB_FX_USERGROUPAUTHEXTENTION`을 기준으로 합니다. 사용자마다 목록이 다를 수 있습니다. |
| 권한 메타 | `TB_FX_GroupMenuAuth` 13행, `TB_FX_MenuItemInfo` 1행, `TB_FX_ProgramInfo` 1행, `TB_FX_Favorite` 5행이 있습니다. 그룹별 C/R/U/D 플래그 값은 **확인 필요**입니다. |
| 조회조건 메타 | `TB_FX_SearchCondition` 19행이 있습니다. 내용은 **확인 필요**입니다. |

## 7. 외부 인터페이스

Fact Pack에는 외부 시스템 인터페이스가 없습니다. 저장 시 `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` → `SCM_SYS_LOG_BATCH`에 기록하는 것은 내부 로그입니다. 이 로그가 외부 배치를 호출하는 계기가 되는지는 **확인 필요**입니다.

## 8. 미확정·확인 필요

| # | 항목 | 근거 |
|---:|---|---|
| 1 | `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`를 535·536·537 세 지점에서 참조하는 이유와 저장 파라미터 | endpoints site_kind=prop |
| 2 | 필드 초기화(45~48: MyDivision, Company, LookupCommon, YesOrNo)와 `SetChangedPeriod`(910)의 실제 실행 경로 | unreached |
| 3 | `PERIOD_{p:value}` 코드 값, FROM_VALUE·TO_VALUE 사용처 | meta_reads 916·917 |
| 4 | 화면 로컬 `GetSpdTitle`(925)과 프레임워크 `SpreadInfo.GetSpdTitle`(InitSpread:190)의 관계 | Fact Pack 4-2와 flow의 표기 차이 |
| 5 | `CboDayWeek_SelectedIndexChanged`의 Enabled 분기 조건 | 663/666 |
| 6 | `BtnInput_Click`의 일괄 입력 대상과 반영 방식 | 682, 725~821 |
| 7 | `SpdMain_Changed`의 878~902 사이 처리, `SpdMain_TopChange`의 동작 | events |
| 8 | `SaveData_Main`의 컬럼 `A`(502·527)의 의미 | meta_reads |
| 9 | `B_` 컬럼 분기, `AddSheet` 인자(3, 1, 35)의 의미 | grid_code 179·263 |
| 10 | `M_`/`W_`/`D_` 접두어와 `LARGE`/`SMALL_CLASS` 헤더의 업무 의미(버킷 단위) | grid_code |
| 11 | Period 필수 검증 코드와 오류 메시지 | 미추출 |
| 12 | 그룹별 C/R/U/D 플래그 | `TB_FX_GroupMenuAuth` 13행 |
| 13 | 메뉴 위치 | `TB_FX_MenuItemInfo` 1행(내용 미제공) |

=== FILE: screen_design.md ===
# SSP0005 — Shipment Working Day 화면설계서

> 근거: Fact Pack(SSP0005), controls.csv, props.csv, grid_code.csv, grid_effective.csv, events.csv입니다. 사실이 없는 항목은 **확인 필요**로 적었습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SSP0005 |
| 화면 명칭(Form Text 원문) | `Working Time` (Designer.cs:501) |
| 클래스 | `SSP0005_ShipmentWorkingDay` |
| 시트 | `Shipment Working Day` |
| 메뉴 위치 | **확인 필요** (`TB_FX_MenuItemInfo` 1행, 내용 미제공) |
| 구성 방식 | HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경) |

## 2. 화면 레이아웃

### 2-1. 분할 트리 (props.csv + controls.csv parent 체인)

- props.csv에 **SplitContainer가 없습니다**. Orientation과 SplitterDistance는 해당 사항이 없습니다.
- 분할은 Dock으로만 구성됩니다.
  - `usrConditionPanel1`: Dock=Top
  - `spdMain`: Dock=Fill
  - 상/하 2단입니다.
- 비율(Designer 기준 높이): 상단 65 / 하단 584 → 65÷649 = **10.0% : 90.0%**입니다. 하단은 Fill이므로 실제 높이는 창 크기에 따라 달라집니다.

```
this (Form, Text="Working Time")
├─ usrConditionPanel1  [UsrConditionPanel, Dock=Top, 1192×65, UsrPanelType=HidePanel]   ── 상단 10.0%
│   └─ usrLayoutControl2  [UsrLayoutControl, Dock=Fill, 1192×65]  (layoutControlGroup2 1192×70)
│        ├─ layoutControlItem4  (257×25) "Company"          → cboCompany     [UsrCombo 198×20]
│        ├─ layoutControlItem1  (257×25) "Day of the week"  → cboDayWeek     [UsrCombo 155×20]
│        ├─ layoutControlItem10 (81×25)                     → btnInput       [UsrButton 77×21, "Input"]
│        ├─ layoutControlItem6  (251×25) "Period*"          → drpPeriod      [UsrDateRangePicker 206×20]
│        ├─ lcDivision          (247×25) "Division"         → clbDivision    [UsrCheckedList 199×21]
│        ├─ lcInputValue        (247×25) "Input Value"      → cboInputValue  [UsrComboBox 174×20]
│        ├─ emptySpaceItem1 (170×25)
│        └─ emptySpaceItem2 (417×50)
└─ spdMain  [FpSpread, Dock=Fill, 1192×584]                                              ── 하단 90.0%
     └─ spdMain_Sheet1 [SheetView] → 시트 "Shipment Working Day"

(parent 없음) usrButton1 [UsrButton 75×23] — 배치 위치·표시 여부 확인 필요
```

> LayoutControlItem과 컨트롤의 연결은 props `Control` 값입니다. LayoutControlItem의 parent는 controls.csv에서 비어 있으며, usrLayoutControl2 아래 배치로 표기한 것은 Control 연결을 기준으로 했습니다. 행·열 좌표(어느 항목이 같은 행인지)는 **확인 필요**입니다.

### 2-2. 영역

| 영역 | 컨트롤 |
|---|---|
| 조회조건 | `usrConditionPanel1` > `usrLayoutControl2`: cboCompany, clbDivision, drpPeriod, cboDayWeek, cboInputValue |
| 버튼 | `btnInput`(조회조건 영역 안), 공통 FindButton·SaveButton(프레임워크), `usrButton1`(확인 필요) |
| 그리드 | `spdMain` / `spdMain_Sheet1` (시트 `Shipment Working Day`) |
| 팝업 | 추출된 팝업 없음 |

## 3. 컨트롤 명세

| 컨트롤명 | 타입 | 라벨(props Text 원문) | 초기값 | 필수 | 연결 이벤트 | To-Be 컴포넌트 |
|---|---|---|---|---|---|---|
| `usrConditionPanel1` | UsrConditionPanel | - | UsrPanelType=HidePanel | - | - | 조회조건 패널(접기 가능 여부 확인 필요) |
| `usrLayoutControl2` | UsrLayoutControl | `usrLayoutControl2` (컨트롤 Text, 표시용 아님 — 확인 필요) | - | - | - | 조회조건 레이아웃 그리드 |
| `cboCompany` | UsrCombo | `Company` (layoutControlItem4) | 확인 필요 | 확인 필요 | - | Wijmo ComboBox (데이터: `biz:CommonData.CommonDataList` [code=Company]) |
| `clbDivision` | UsrCheckedList | `Division` (lcDivision) | 확인 필요 | 확인 필요 | - | Wijmo MultiSelect (데이터: `biz:CommonData.CommonDataList` [code=MyDivision]) |
| `drpPeriod` | UsrDateRangePicker | `Period*` (layoutControlItem6) | `SCP.SCM0001_GET_SCP_PERIOD` 결과(GetDayRange:941)에 연결되는지 확인 필요 | Y (`*` 표시) | - | 기간 From~To 입력(InputDate 2개 또는 범위 컴포넌트) |
| `cboDayWeek` | UsrCombo | `Day of the week` (layoutControlItem1) | 확인 필요 | 확인 필요 | SelectedIndexChanged → `CboDayWeek_SelectedIndexChanged` | 콤보(다중 여부 확인 필요 — `GetCheckedListValue` 사용) (데이터: `biz:CommonData.CommonDataList` [code=LookupCommon]) |
| `cboInputValue` | UsrComboBox | `Input Value` (lcInputValue) | `biz:CommonData.YesOrNo` 바인딩(InitControls:168) / 선택값 확인 필요 | 확인 필요 | Enabled ← `CboDayWeek_SelectedIndexChanged`(663/666) | Wijmo ComboBox (disabled 동적 제어) |
| `btnInput` | UsrButton | `Input` | - | - | Click → `BtnInput_Click` | Button(일괄 입력) |
| `usrButton1` | UsrButton | 확인 필요(Text 미추출) | - | - | 미연결 | 확인 필요(parent 없음, 75×23) |
| `spdMain` | FpSpread | - | - | - | CellDoubleClick → `SpdMain_CellDoubleClick`, TopChange → `SpdMain_TopChange`, (dsdm) Changed → `SpdMain_Changed` | Wijmo FlexGrid |
| `spdMain_Sheet1` | SheetView | 시트 `Shipment Working Day` | - | - | - | FlexGrid 단일 시트 |

## 4. 그리드 명세 — 시트 `Shipment Working Day`

헤더 행 수는 3입니다(`SetSheetHeaderColumn(spdInfo, 3)`, 196). `AddSheet(spdMain, "Shipment Working Day", "Shipment Working Day", 3, 1, 35)`(179)의 인자 1·35가 무엇을 뜻하는지는 **확인 필요**입니다.

| # | 컬럼 | 헤더 | 타입 | 출처 | division별 표시 | 편집 가능 |
|---:|---|---|---|---|---|---|
| 1 | `COMPANY_ID` | `Company` | 메타 정의(CELL 타입 확인 필요) | META (`SCM_MST_SHEET_COLUMNS`) | 14개 division 모두 기본 | 확인 필요 |
| 2 | `DIVISION_ID` | `Divison` (메타 원문 철자) | 메타 정의(CELL 타입 확인 필요) | META | 14개 division 모두 기본 | 확인 필요 |
| 3~n | `{COLUMN_NAME}` (SCP0009 결과) | `{COLUMN_LABEL_NAME}` | Combo (`YesOrNo`), 폭 70, Center/Center | DB루프(HARDCODED 로직, DB_DRIVEN 값) — `InitSpreadDateColumn`:263 | 런타임 결정(정적 미집계) | Combo 셀입니다. 잠금 여부는 **확인 필요** |

날짜 컬럼의 부가 규칙:
- 시작 위치는 `GetColumnIndex(DIVISION) + 1`입니다.
- `sColumnName.IndexOf("B_") > 0`이면 Combo 컬럼 생성 분기에서 빠집니다. B_ 분기 처리 내용은 **확인 필요**입니다.
- `DAY_CODE`가 SAT이면 ForeColor Blue, SUN이면 Red입니다(267).
- 헤더 row 0에는 `LARGE_CLASS_LABEL_NAME`, row 1에는 `SMALL_CLASS_LABEL_NAME`을 `ColumnHeaderSpan`으로 병합하며 높이는 20입니다(274·280·290·301·303).
- 헤더 더블클릭: `M_` → `W_` 컬럼과 보이는 `D_` 컬럼을 반전하고(840·843), `W_` → `D_` 컬럼을 반전합니다(854).
- Designer(467~470): HorizontalAlignment General, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`, VerticalAlignment General.

메타 속성(COLUMN_WIDTH, HORIZONTAL_ALIGN_CODE, FIXED_FLAG 등)의 구체적인 값은 Fact Pack에 없어 **확인 필요**입니다.

## 5. 액션 명세

| ID | 버튼/이벤트 | 핸들러 | 처리 | 엔드포인트 | 결과 반영 |
|---|---|---|---|---|---|
| A1 | 화면 로드 (this.Load) | `Form_Load` | InitControls → GetDayRange, CreateSpread → InitSpread → GetSpdTitle / SetSheetHeaderColumn / InitSpreadDateColumn | `biz:CommonData.YesOrNo`, `SCP.SCM0001_GET_SCP_PERIOD`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` / (unreached, 확인 필요) `biz:CommonData.CommonDataList` [Company / MyDivision / LookupCommon] | cboInputValue 바인딩, 기간, 그리드 헤더 생성 |
| A2 | 조회 (FindButton) | `FindData_Main` | GetCheckedListValue(387·388) → 데이터 조회 → InitSpread → GetSpdTitle | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 그리드를 다시 생성하고 데이터를 바인딩 |
| A3 | 저장 (SaveButton) | `SaveData_Main` | GetChanges(538, ROW_ID) → 저장 → FindData_Main | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` → `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | `SSP_MST_SHIP_CALENDAR` UPDATE 후 재조회 |
| A4 | btnInput Click | `BtnInput_Click` | GetCheckedListValue(682) → Changed 해제(725) → 일괄 처리 → 재연결(821) | 없음 | 그리드에 일괄 반영(상세 확인 필요) |
| A5 | cboDayWeek SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | GetCheckedListValue(660) → cboInputValue.Enabled false(663) / true(666) | 없음 | Input Value 활성/비활성 |
| A6 | spdMain CellDoubleClick | `SpdMain_CellDoubleClick` | 헤더 Tag `M_` / `W_`에 따라 하위 컬럼 Visible 반전 | 없음 | 컬럼 접기/펼치기 |
| A7 | dsdm Changed | `SpdMain_Changed` | 자기 해제(878) → 처리(확인 필요) → 재연결(902) | 없음 | 확인 필요 |
| A8 | spdMain TopChange | `SpdMain_TopChange` | 확인 필요 | 없음 | 확인 필요 |
| (참고) | SetChangedPeriod | - | unreached | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value}] | FROM_VALUE / TO_VALUE 사용(확인 필요) |

> 주석 처리된 `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY`(569)와 `SCP.GET_DATE_RANGE_1MONTH`(940)는 액션에서 제외했습니다.

## 6. 검증·메시지

| 항목 | 사실 |
|---|---|
| Period 필수 | 라벨 `Period*` 표시만 확인되었습니다. 검증 코드와 메시지 문구는 **확인 필요**입니다. |
| 저장 전 변경 없음 처리 | `GetChanges` 사용만 확인되었습니다. 메시지는 **확인 필요**입니다. |
| 조회 결과 없음 / 오류 메시지 | 추출되지 않았습니다(**확인 필요**). |

## 7. 권한 (C/R/U/D)

| 항목 | 사실 |
|---|---|
| 코드상 기능 | R(FindButton), U(SaveButton → UPDATE `SSP_MST_SHIP_CALENDAR`). C·D 진입점은 추출되지 않았습니다. |
| `EditButton`(352) | `GetSheetInfo` 호출만 추출되었습니다. |
| 메타 | `TB_FX_GroupMenuAuth` 13행. 그룹별 플래그 값은 **확인 필요**입니다. |
| Division 범위 | `NowGroupID` 기준 MyDivision 목록입니다. |

## 8. To-Be 전환 메모 (Wijmo · Oracle)

| 영역 | As-Is | To-Be 고려 사항 |
|---|---|---|
| 그리드 헤더 | FarPoint 3단 헤더, `ColumnHeaderSpan` 병합 | FlexGrid `columnHeaders`에 3행을 추가하고 병합을 설정합니다. LARGE/SMALL 라벨은 SCP0009 결과로 동적 구성합니다. |
| 날짜 컬럼 | DB 루프 `AddComboColumn`(YesOrNo) | 조회 결과로 동적 컬럼을 생성하고, `DataMap`(YesOrNo)을 적용합니다. 폭 70, center 정렬입니다. |
| 요일 색상 | SAT Blue / SUN Red ForeColor | 컬럼 단위 CSS 클래스로 처리합니다(inline style 금지 규약 준수). |
| 접기/펼치기 | 헤더 더블클릭 + Tag 접두어 | 헤더 dblclick 핸들러에서 `column.visible`을 토글합니다. Tag 대신 binding 접두어를 씁니다. |
| Changed 억제 | 이벤트 `-=`/`+=` | 일괄 입력 중에는 플래그로 cellEditEnded 처리를 억제하거나 `deferUpdate`를 사용합니다. |
| 저장 | GetChanges(ROW_ID) | CollectionView `itemsEdited` 기반으로 변경 행만 전송합니다. |
| 조회 SP | MSSQL `#TBLDYNAMICPIVOT_SSP0005`, `STRING_SPLIT`, 동적 SQL | Oracle 19c에서는 temp → GTT 등으로 바꾸고, `STRING_SPLIT` 제거(MSSQL 키워드 금지)와 동적 피벗 변환이 필요합니다. 방식은 **확인 필요**입니다. |
| 기간 SP | `FN_MULTY_TIME`, `FN_WEEKOFDAY_DATE`, `CTE_DATE` | Oracle 함수와 WITH 절로 변환합니다. |
| 저장 SP | `PR_SCM_SYS_LOG_BATCH_CALL_TRAN` 호출 | Oracle 측 로그 프로시저와 트랜잭션 경계를 확인해야 합니다. |
| 메타 라벨 | `Divison` 철자 | 메타 원문을 그대로 둘지 **확인 필요**입니다. |

## 9. 미확정

1. `usrButton1`의 용도와 표시 여부
2. 조회조건 행·열 배치 좌표
3. 각 콤보의 초기값과 필수 여부(Period 제외)
4. `CboDayWeek_SelectedIndexChanged`의 Enabled 조건, `BtnInput_Click`의 일괄 입력 상세
5. `SpdMain_Changed`(878~902), `SpdMain_TopChange`의 동작
6. `B_` 컬럼 분기, `AddSheet` 인자 1·35
7. Company / MyDivision / LookupCommon / PERIOD 공통코드의 실제 바인딩 경로(unreached)
8. 메타 컬럼 속성값(폭·정렬·고정·편집)
9. 메뉴 위치와 그룹별 C/R/U/D 플래그

=== FILE: unit_test.md ===
# SSP0005 — Shipment Working Day 단위테스트

> 절차 열의 컨트롤명은 화면설계서 §3과 같고, 근거 열의 엔드포인트·SP 이름은 업무분석서 §5·화면설계서 §5와 같습니다.
> 기대결과가 Fact Pack으로 확정되지 않은 경우 **확인 필요**로 적었습니다.
> 주석 처리된 호출(569, 940)은 테스트 대상에서 제외했습니다.

| TC-ID | 구분 | 사전조건 | 절차 | 입력값 | 기대결과 | 근거 |
|---|---|---|---|---|---|---|
| TC-SSP0005-001 | 초기화 | 로그인 완료, SSP0005 메뉴 권한 보유 | 화면을 엽니다 → `cboInputValue` 목록을 확인합니다 | - | `cboInputValue`에 YesOrNo 공통코드가 바인딩됩니다(CODE/NAME) | `Form_Load` > InitControls:168, `biz:CommonData.YesOrNo` |
| TC-SSP0005-002 | 초기화 | 위와 같음 | 화면을 엽니다 → `drpPeriod` 값을 확인합니다 | - | 기간 조회 SP가 호출됩니다. `drpPeriod`에 반영되는지는 **확인 필요** | `Form_Load` > InitControls > GetDayRange:941, `SCP.SCM0001_GET_SCP_PERIOD`, SP `SCM0001_GET_SCP_PERIOD` |
| TC-SSP0005-003 | 초기화 | 위와 같음 | 화면을 엽니다 → `spdMain` 헤더를 확인합니다 | - | 시트 `Shipment Working Day`가 생성되고 SCP0009 결과로 날짜 컬럼 헤더가 만들어집니다 | `Form_Load` > CreateSpread > InitSpread > GetSpdTitle:925, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN`, SP `SCP0009_GET_SHEET_CALENDAR_3SPAN`, 시트 `Shipment Working Day` |
| TC-SSP0005-004 | 초기화 | 위와 같음 | `cboCompany` 목록을 엽니다 | - | Company 목록(`SCM_MST_COMPANY_SN` 기준)이 표시됩니다. 바인딩 경로는 unreached이므로 **확인 필요** | field dtCompany:46, `biz:CommonData.CommonDataList` [code=Company] |
| TC-SSP0005-005 | 초기화 | 사용자 그룹(NowGroupID) 확인 | `clbDivision` 목록을 엽니다 | - | 사용자 그룹에 허용된 Division만 표시됩니다(`SCM_MST_DIVISION`, `TB_FX_USERGROUPAUTHEXTENTION`). 경로는 **확인 필요** | field dtMyDivision:45, `biz:CommonData.CommonDataList` [code=MyDivision] |
| TC-SSP0005-006 | 초기화 | 위와 같음 | `cboDayWeek` 목록을 엽니다 | - | LookupCommon 요일 목록이 표시됩니다. 경로는 **확인 필요** | field dtDayWeek:47, `biz:CommonData.CommonDataList` [code=LookupCommon] |
| TC-SSP0005-007 | 그리드 | 화면 로드 완료 | `spdMain` 고정 컬럼을 확인합니다 | - | `COMPANY_ID`(헤더 `Company`)와 `DIVISION_ID`(헤더 `Divison`)가 표시됩니다 | 시트 `Shipment Working Day`, `SCM_MST_SHEET_COLUMNS`, SetSheetHeaderColumn:196 |
| TC-SSP0005-008 | 그리드 | 조회 완료 | `spdMain` 날짜 컬럼 셀을 클릭합니다 | - | 셀이 YesOrNo Combo입니다. 폭 70, Center 정렬이고 DIVISION 컬럼 다음부터 시작합니다 | 시트 `Shipment Working Day`, InitSpreadDateColumn:263, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0005-009 | 그리드 | 조회 기간에 토·일 포함 | 날짜 컬럼 글자색을 확인합니다 | - | DAY_CODE가 SAT인 컬럼은 Blue, SUN인 컬럼은 Red입니다 | 시트 `Shipment Working Day`, InitSpreadDateColumn:267 |
| TC-SSP0005-010 | 그리드 | 조회 완료 | 헤더 1·2행 병합을 확인합니다 | - | row 0은 LARGE_CLASS_LABEL_NAME, row 1은 SMALL_CLASS_LABEL_NAME으로 같은 값끼리 병합됩니다(높이 20) | 시트 `Shipment Working Day`, ColumnHeaderSpan 274·280·290·301·303, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0005-011 | 조회 | 데이터가 있는 조건 | `cboCompany`, `clbDivision`(1개 이상), `drpPeriod`를 지정하고 조회(FindButton)를 누릅니다 | Company/Division/Period 유효값 | 그리드가 다시 생성되고 `SSP_MST_SHIP_CALENDAR` 데이터가 날짜 컬럼에 Y/N으로 표시됩니다 | `FindData_Main`:403, `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, SP `SSP0005_GET_SHIPMENT_WORKING_DAY`, `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |
| TC-SSP0005-012 | 조회 | 데이터가 없는 조건 | 데이터가 없는 Division·기간으로 조회합니다 | 데이터 없는 조합 | 오류 없이 0행 그리드가 표시됩니다. 메시지는 **확인 필요** | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, SP `SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-013 | 조회 | - | `drpPeriod`를 비우고 조회합니다 | Period 빈값 | 필수(`Period*`) 검증이 동작합니다. 메시지와 차단 여부는 **확인 필요** | `FindData_Main`, `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-014 | 조회 | SP 오류 유발 환경(예: DB 연결 차단) | 조회합니다 | - | 오류 응답이 표시되고 기존 그리드가 손상되지 않습니다. 메시지는 **확인 필요** | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY`, SP `SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-015 | 저장 | 조회 완료, 시험 대상 행의 저장 전 값 기록 | `spdMain` 날짜 셀 1개를 Y→N으로 바꾸고 저장(SaveButton)을 누릅니다 | 변경 셀 1건 | 변경 행만 전송됩니다(GetChanges/ROW_ID). `SSP_MST_SHIP_CALENDAR`가 UPDATE되고 `SCM_SYS_LOG_BATCH`에 1건 이상 INSERT된 뒤 재조회됩니다. 시험 후 원복합니다 | `SaveData_Main`:535·536·537, `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, SP `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` |
| TC-SSP0005-016 | 저장 | 조회 완료, 변경 없음 | 저장(SaveButton)을 누릅니다 | - | 변경분 0건으로 처리됩니다. SP 호출 여부와 메시지는 **확인 필요** | `SaveData_Main` GetChanges:538, `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| TC-SSP0005-017 | 저장 | SP 오류 유발 환경 | 셀을 변경하고 저장합니다 | 변경 셀 1건 | 오류 응답이 표시되고 `SSP_MST_SHIP_CALENDAR`는 바뀌지 않습니다(롤백). 메시지는 **확인 필요** | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW`, SP `SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` |
| TC-SSP0005-018 | 이벤트 | 조회 완료, `M_` 헤더 존재 | `spdMain`의 `M_` 컬럼 헤더를 더블클릭합니다 | - | `W_` 컬럼과 보이는 `D_` 컬럼의 Visible이 반전됩니다. 다시 더블클릭하면 원래대로 돌아옵니다 | `SpdMain_CellDoubleClick`:840·843, 시트 `Shipment Working Day` |
| TC-SSP0005-019 | 이벤트 | 조회 완료, `W_` 헤더 존재 | `W_` 컬럼 헤더를 더블클릭합니다 | - | `D_` 컬럼의 Visible이 반전됩니다 | `SpdMain_CellDoubleClick`:854 |
| TC-SSP0005-020 | 이벤트 | 조회 완료 | 데이터 셀(헤더 아님)을 더블클릭합니다 | - | 컬럼 표시가 바뀌지 않습니다(`e.ColumnHeader` 조건) | `SpdMain_CellDoubleClick` |
| TC-SSP0005-021 | 이벤트 | 화면 로드 완료 | `cboDayWeek`에서 값을 바꿉니다 | 요일 항목 각각 | `cboInputValue`가 비활성(663) 또는 활성(666)으로 바뀝니다. 항목별 기대 상태는 **확인 필요** | `CboDayWeek_SelectedIndexChanged`:660·663·666 |
| TC-SSP0005-022 | 이벤트 | 조회 완료, `cboInputValue` 활성 | `cboDayWeek`·`cboInputValue`를 선택하고 `btnInput`을 클릭합니다 | 요일, Input Value=Y | 선택 조건에 해당하는 그리드 셀에 값이 일괄 반영됩니다. 처리 중 `SpdMain_Changed`는 호출되지 않습니다(725/821). 반영 범위는 **확인 필요** | `BtnInput_Click`:682·725·821 |
| TC-SSP0005-023 | 이벤트 | 조회 완료 | `spdMain` 셀 값을 직접 변경합니다 | 셀 1건 | `SpdMain_Changed`가 1회만 수행되고 재귀 호출이 없습니다(878/902). 후속 처리는 **확인 필요** | `SpdMain_Changed`:878·902 |
| TC-SSP0005-024 | 이벤트 | 조회 완료, 다수 행 | `spdMain`을 세로 스크롤합니다 | - | 오류 없이 스크롤됩니다. 핸들러 처리 결과는 **확인 필요** | `SpdMain_TopChange` (InitEvent:312) |
| TC-SSP0005-025 | division | Division 40 사용자 | 조회 후 메타 컬럼을 확인합니다 | Division=40 | 메타 컬럼 2개(Company, Divison)가 표시됩니다 | 시트 `Shipment Working Day`, grid_effective(40=기본 2) |
| TC-SSP0005-026 | division | Division 81 / EE 계열 사용자 | 조회 후 메타 컬럼을 확인합니다 | Division=81, EE | 40과 같은 메타 컬럼 2개가 표시됩니다(division 분기 없음) | 시트 `Shipment Working Day`, grid_effective(81·EE=기본 2) |
| TC-SSP0005-027 | 권한 | 서로 다른 그룹의 사용자 2명 | 각 사용자로 `clbDivision` 목록과 조회·저장 가능 여부를 확인합니다 | - | Division 목록이 그룹별로 다릅니다. 조회·저장 허용 여부는 `TB_FX_GroupMenuAuth`(13행) 플래그를 따릅니다(값 **확인 필요**) | `biz:CommonData.CommonDataList` [code=MyDivision], `FindData_Main`, `SaveData_Main` |

### 커버리지 점검

| 대상 | 항목 | TC |
|---|---|---|
| 이벤트 핸들러 | `Form_Load` | 001, 002, 003 |
| | `SpdMain_CellDoubleClick` | 018, 019, 020 |
| | `SpdMain_TopChange` | 024 |
| | `CboDayWeek_SelectedIndexChanged` | 021 |
| | `BtnInput_Click` | 022 |
| | `SpdMain_Changed` | 023 |
| 엔드포인트 | `biz:CommonData.CommonDataList` | 004, 005, 006, 027 |
| | `biz:CommonData.YesOrNo` | 001 |
| | `SSP.SSP0005_GET_SHIPMENT_WORKING_DAY` | 011, 012, 013, 014 |
| | `SSP.SSP0005_SAVE_SHIPMENT_WORKING_DAY_ROW` | 015, 016, 017 |
| | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | 003, 008, 010, 011 |
| | `SCP.SCM0001_GET_SCP_PERIOD` | 002 |
| 시트 | `Shipment Working Day` | 003, 007, 008, 009, 010, 018, 025, 026 |
| 빈 결과 / 오류 응답 | - | 012 / 014, 017 |
