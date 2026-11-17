=== FILE: analysis.md ===
# SSP0019 Shipment Change History — As-is 분석

> 출처: AsisFacts 정적 추출 결과(Fact Pack). 이 묶음에 없는 내용은 **확인 필요**로 표기했습니다.

## 1. 화면 개요
| 항목 | 내용 |
|---|---|
| 화면 ID | SSP0019 |
| 클래스 | `SSP0019_ShipmentChangeHistory` |
| 도메인 | SSP (프로젝트 `GSCM.SSP.Plan.UIL`) |
| 폼 Text | `SSP0019_ShipmentChangeHistory` (Designer.cs:780) |
| 화면 성격 | 조회 전용. 연결된 버튼 진입점은 `FindButton` 1개뿐이며 저장 엔드포인트는 추출되지 않음 |

### 1-1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0019_ShipmentChangeHistory.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 543 |
| current(only) | 06.UIL\GSCM.SSP.Plan.UIL\SSP0019_ShipmentChangeHistory.Designer.cs | 06.UIL\GSCM.SSP.Plan.UIL\GSCM.SSP.Plan.UIL.csproj | 845 |
| shared | 없음(추출 결과 없음) | - | - |
| legacy | 없음(추출 결과 없음) | - | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 409 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | MATCH | SP SSP0019_GET_SHIPMENT_CHANGE_HISTORY |
| event:this.Load | Form_Load > InitControls > GetDayRange | 522 | `SCP.GET_DATE_RANGE_1MONTH` | MATCH | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql |
| unreached(진입점 미연결) | SetChangedPeriod | 500 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | BIZ_MATCH | (Data.CallBizCommonData) |

- `SetChangedPeriod` 는 정적 분석으로 진입점에 연결되지 않았습니다. 실제 호출 여부(어느 이벤트에서 부르는지)는 **확인 필요**.
- 주석 처리됨: 523줄 `SCP.SCM0001_GET_SCP_DAY_PERIOD` (commented:MATCH). 현행 기능이 아닙니다.

## 3. 엔드포인트 전체 표
| 엔드포인트 | 상태 | 호출 수 | 호출 위치 | SP / SQL | 참조 객체 |
|---|---|---:|---|---|---|
| `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | MATCH | 1 | FindData_Main:409 | SP SSP0019_GET_SHIPMENT_CHANGE_HISTORY | EXEC:SSP0019_GET_SHIPMENT_CHANGE_HISTORY, REF:FN_GET_IN_STR, DYNAMIC@SSP0019_GET_SHIPMENT_CHANGE_HISTORY, REF:FN_SCM_SPLIT |
| `SCP.GET_DATE_RANGE_1MONTH` | MATCH | 1 | GetDayRange:522 | [statement] foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M |
| `biz:CommonData.CommonDataList` | BIZ_MATCH | 1 | SetChangedPeriod:500 | (Biz 공통코드, code=PERIOD_{p:value} \|\| PERIOD_DEFAULT) | 확인 필요 |

- SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` 가 직접 참조하는 테이블은 추출되지 않았습니다. 동적 SQL(DYNAMIC) 이 포함되어 있어 **확인 필요**.

## 4. 이벤트 배선 표
| 대상 | 이벤트 | 핸들러 | 배선 위치 | 확인된 동작 |
|---|---|---|---|---|
| this | Load | `Form_Load` | .ctor:139 | InitControls > GetDayRange(`SCP.GET_DATE_RANGE_1MONTH`) 호출 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:191 | 확인 필요 |
| spdMain | CellClick | `SpdMain_CellClick` | InitEvent:192 | 확인 필요 (REQUEST_NO 가 이미지 셀이라 관련 여부 확인 필요) |
| this.btnItemId | Click | `btnItemId_Click` | InitEvent:193 | 231줄에서 `txtItemId.Text = sItemId` 설정 |
| chkCurrent | CheckedChanged | `ChkCurrent_CheckedChanged` | InitEvent:194 | 확인 필요 |
| clbDivision | SelectedIndexChanged | `clbDivision_SelectedIndexChanged` | InitEvent:196 | 확인 필요 |

- InitEvent 195줄은 추출 결과에 없습니다(주석 등일 수 있으나 **확인 필요**).

## 5. 프레임워크 메타·DB 컬럼 사용
| 메서드 | 줄 | 대상 / 프레임워크 호출 | 컬럼 |
|---|---|---|---|
| SetChangeControl | 163, 164 | Filter / UserInfoContext.Current | GROUP_ID, USER_ID / NowGroupID |
| SetChangeControl | 170, 175, 180 | DataService.GetSSPInnerTable | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID |
| InitControls | 258, 262 | DataService.FP_Log2 | LOGTYPE, NOTE, USER_ID |
| InitControls | 273 | c | CODE |
| SetChangedControl | 293 | CString.GetCheckedListValue | CODE |
| SetChangedControl | 298, 303 | UserInfoContext.Current | NowGroupID |
| FindData_Main | 387, 388, 389, 390, 396 | CString.GetCheckedListValue | CODE |
| InitSpread | 332 | SpreadInfo.SetSheetHeaderColumn | 메타 컬럼(§6 참고) |
| SetChangedPeriod | 507, 508 | dt.Rows[0] | FROM_VALUE, TO_VALUE |

- 3번의 GetSSPInnerTable 호출이 각각 어느 컨트롤에 바인딩되는지는 **확인 필요**.

## 6. Grid 구성 방식
- 구성 방식: **`META(프레임워크) (+코드 표시/라벨 변경)`**
- 시트: `Shipment Change History` (CreateSpread:318 AddSheet → 319 GetSheetInfo → 321 ChangeSheet, InitSpread:330 InitSheet)
- 메타 컬럼 생성: `SetSheetHeaderColumn@InitSpread:332` (헤더 행 수 1). 읽는 메타 컬럼은 ATTRIBUTE1~5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG
- 코드 변경: InitSpread:339 `REQUEST_NO` 컬럼 CellType = `cellTypeImage` (조건 `spdInfo.SheetName == "Shipment Change History"`)
- Designer 114~117줄: HorizontalAlignment=General, NoteIndicatorColor=Red, Parent="ColumnHeaderDefaultEnhanced", VerticalAlignment=General (헤더 기본 스타일로 보이나 대상 객체는 **확인 필요**)

### 6-1. Division별 차이
| 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Change History (메타 필수+기본/선택) | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 | 46/0 |
| 최종 표시 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 | 46 |

- **Division별 차이 없음**. 메타 47개 컬럼 중 `LAST_SEQ` 1개는 전 division 숨김이고, 나머지 46개는 전 division 기본 표시입니다.
- 코드 분기 중 판단불가 건수는 0건입니다.

## 7. 확인 필요 항목
1. `SetChangedPeriod`(biz:CommonData.CommonDataList) 의 실제 진입점과 `{p:value}` 에 들어가는 값.
2. SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` 의 참조 테이블(동적 SQL 포함), 파라미터 목록.
3. 이벤트 핸들러 `SpdMain_TopChange`, `SpdMain_CellClick`, `ChkCurrent_CheckedChanged`, `clbDivision_SelectedIndexChanged` 의 내부 동작.
4. `btnItemId_Click` 에서 `sItemId` 를 얻는 방법(팝업 여부).
5. `TransportMode` LayoutControlItem 의 라벨 Text(props 에 없음).
6. FindData_Main:387~390, 396 의 GetCheckedListValue 5건이 각각 어느 CheckedList 에 대응하는지.
7. "실제 SP 실행 결과와 매칭되는 시트 없음": grid 단계를 실행하지 않았거나 시트명이 다름 → SP 결과 컬럼과 메타 46컬럼의 일치 여부.
8. InitEvent 195줄의 존재 여부와 내용.

=== FILE: source_links.md ===
# SSP0019 소스 링크 표

기준 파일
- CS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0019_ShipmentChangeHistory.cs`
- DS = `06.UIL\GSCM.SSP.Plan.UIL\SSP0019_ShipmentChangeHistory.Designer.cs`

## 1. 엔드포인트 호출 지점
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | FindData_Main | 409 | `SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY` (FoxQuery, MATCH) |
| CS | GetDayRange | 522 | `SCP.GET_DATE_RANGE_1MONTH` (FoxQuery statement, MATCH) |
| CS | SetChangedPeriod | 500 | `biz:CommonData.CommonDataList` [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] (Data.CallBizCommonData) |
| CS | (주석) | 523 | 주석 처리됨: `SCP.SCM0001_GET_SCP_DAY_PERIOD` |

## 2. 이벤트 배선
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 139 | `this.Load += Form_Load` |
| CS | InitEvent | 191 | `spdMain.TopChange += SpdMain_TopChange` |
| CS | InitEvent | 192 | `spdMain.CellClick += SpdMain_CellClick` |
| CS | InitEvent | 193 | `this.btnItemId.Click += btnItemId_Click` |
| CS | InitEvent | 194 | `chkCurrent.CheckedChanged += ChkCurrent_CheckedChanged` |
| CS | InitEvent | 196 | `clbDivision.SelectedIndexChanged += clbDivision_SelectedIndexChanged` |
| CS | btnItemId_Click | 231 | `txtItemId.Text = sItemId` |

## 3. 프레임워크 메타 및 DB 컬럼 참조
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | SetChangeControl | 163 | Filter["GROUP_ID"], UserInfoContext.Current.NowGroupID |
| CS | SetChangeControl | 164 | Filter["USER_ID"] |
| CS | SetChangeControl | 170 | DataService.GetSSPInnerTable |
| CS | SetChangeControl | 175 | DataService.GetSSPInnerTable |
| CS | SetChangeControl | 180 | DataService.GetSSPInnerTable |
| CS | InitControls | 258 | DataService.FP_Log2 |
| CS | InitControls | 262 | DataService.FP_Log2 |
| CS | InitControls | 273 | c["CODE"] |
| CS | SetChangedControl | 293 | CString.GetCheckedListValue |
| CS | SetChangedControl | 298 | UserInfoContext.Current.NowGroupID |
| CS | SetChangedControl | 303 | UserInfoContext.Current.NowGroupID |
| CS | FindData_Main | 387 | CString.GetCheckedListValue |
| CS | FindData_Main | 388 | CString.GetCheckedListValue |
| CS | FindData_Main | 389 | CString.GetCheckedListValue |
| CS | FindData_Main | 390 | CString.GetCheckedListValue |
| CS | FindData_Main | 396 | CString.GetCheckedListValue |
| CS | SetChangedPeriod | 507 | dt.Rows[0]["FROM_VALUE"] |
| CS | SetChangedPeriod | 508 | dt.Rows[0]["TO_VALUE"] |

## 4. Grid 구성
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 318 | AddSheet(spdMain, SpdSheet.shtMain = "Shipment Change History", 1, 1, 30) |
| CS | CreateSpread | 319 | GetSheetInfo(spdMain.Name, 0) |
| CS | CreateSpread | 321 | ChangeSheet |
| CS | InitSpread | 330 | InitSheet — `if(spdInfo.SheetName == "Shipment Change History")` |
| CS | InitSpread | 332 | SetSheetHeaderColumn(spdInfo, 1) |
| CS | InitSpread | 339 | REQUEST_NO.CellType = cellTypeImage |
| DS | InitializeComponent | 114 | HorizontalAlignment = CellHorizontalAlignment.General |
| DS | InitializeComponent | 115 | NoteIndicatorColor = Color.Red |
| DS | InitializeComponent | 116 | Parent = "ColumnHeaderDefaultEnhanced" |
| DS | InitializeComponent | 117 | VerticalAlignment = CellVerticalAlignment.General |

## 5. 컨트롤 선언 (Designer)
| 파일 | 컨트롤 | 줄 | 유형 |
|---|---|---:|---|
| DS | spdMain | 33 | FarPoint.Win.Spread.FpSpread |
| DS | spdMain_Sheet1 | 34 | SheetView |
| DS | usrLayoutControl1 | 35 | UsrLayoutControl |
| DS | txtConfirmId | 36 | UsrMultiLineEditor |
| DS | chkCurrent | 37 | UsrCheckBox |
| DS | clbTransportMode | 38 | UsrCheckedList |
| DS | clbIncomterms | 39 | UsrCheckedList |
| DS | clbFromSite | 40 | UsrCheckedList |
| DS | txtSoNo | 41 | UsrMultiLineEditor |
| DS | drpPeriod | 42 | UsrDateRangePicker |
| DS | btnItemId | 43 | UsrButton |
| DS | clbToSite | 44 | UsrCheckedList |
| DS | txtItemId | 45 | UsrMultiLineEditor |
| DS | clbDivision | 46 | UsrCheckedList |
| DS | splitter1 | 63 | Splitter |
| DS | usrConditionPanel1 | 64 | UsrConditionPanel |

=== FILE: web_components.md ===
# SSP0019 Web 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑
| As-is 컨트롤 | 유형 | 라벨(원문) | LayoutItem | TO-BE 컴포넌트 후보 | 비고 |
|---|---|---|---|---|---|
| clbDivision | UsrCheckedList | Division | lcDivision | 다중선택 콤보(Wijmo MultiSelect 계열) | SelectedIndexChanged 핸들러 있음 |
| clbFromSite | UsrCheckedList | From Site | FromSite | 다중선택 콤보 | |
| clbToSite | UsrCheckedList | To Site | ToSite | 다중선택 콤보 | |
| clbTransportMode | UsrCheckedList | 확인 필요(Text 미추출) | TransportMode | 다중선택 콤보 | LayoutItem 이름은 TransportMode |
| clbIncomterms | UsrCheckedList | Incoterms | Incotemrs | 다중선택 콤보 | LayoutItem 이름 오타(Incotemrs)는 원문 그대로 |
| drpPeriod | UsrDateRangePicker | Shipment Date | ShipmentDate | 기간(From~To) 입력 | 초기값은 `SCP.GET_DATE_RANGE_1MONTH` |
| txtSoNo | UsrMultiLineEditor | SO No | lblSONo | 다건 입력 텍스트 | |
| txtItemId | UsrMultiLineEditor | Model | lblItemId | 다건 입력 텍스트 | btnItemId 결과 반영 |
| btnItemId | UsrButton | (Text 미추출) | layoutControlItem2 | 조회 팝업 버튼 | Click → txtItemId.Text 설정 |
| txtConfirmId | UsrMultiLineEditor | Confirm ID | layoutControlItem3 | 다건 입력 텍스트 | |
| chkCurrent | UsrCheckBox | Current | layoutControlItem1 | 체크박스 | CheckedChanged 핸들러 있음 |
| spdMain | FpSpread | - | - | Wijmo FlexGrid | 시트 1개 |

## 2. 화면 배치
- SplitContainer 는 없습니다. 영역은 Dock 으로 나뉩니다.

| 컨트롤 | Dock | Size |
|---|---|---|
| usrConditionPanel1 (UsrPanelType=HidePanel) | Top | 1192×69 |
| usrLayoutControl1 (조건 레이아웃) | Fill(패널 내부) | 1192×69 |
| splitter1 | Bottom | 1192×3 |
| spdMain | Fill | 1192×577 |

- 상/하 분할: 조건영역 69 : 그리드 577 (높이 기준, 조건 약 10.7% / 그리드 약 89.3%. 69+577=646 기준으로 계산).
- splitter1 이 Dock=Bottom 이라 실제 분할선 위치가 의도와 같은지는 **확인 필요**.
- 조건 영역 LayoutItem 크기: FromSite 197×24, ShipmentDate 286×26, layoutControlItem2 43×28, lblSONo 157×28, ToSite 157×24, Incotemrs 406×24, lblItemId 154×28, layoutControlItem1 73×24, lcDivision 286×26, TransportMode 204×28, layoutControlItem3 202×28. 빈 칸(EmptySpaceItem): 4=126×28, 6=53×24, 7=230×26. 행·열 배치 좌표는 **확인 필요**.

## 3. 시트별 Grid 컬럼 — `Shipment Change History`
- 연결 규칙: **META+코드연결** (AddSheet/ChangeSheet + SetSheetHeaderColumn)
- 코드 하드코딩: `REQUEST_NO` CellType = cellTypeImage (InitSpread:339)
- Division별 표시 차이: 없음 (전 division 46컬럼 표시)

| # | 컬럼 | 라벨 | 출처 | 표시(전 division 공통) | 코드 변경 |
|---:|---|---|---|---|---|
| 1 | APPROVAL | Approval | META | 기본 | |
| 2 | APPROVAL_DATE | Approval Date | META | 기본 | |
| 3 | APPROVAL_DEPT_NAME | Approval Dept Name | META | 기본 | |
| 4 | BEFORE_INCOTERMS | Before Incoterms | META | 기본 | |
| 5 | BEFORE_QTY | Before QTY | META | 기본 | |
| 6 | BEFORE_SHIPMENT_DATE | Before Shipment Date | META | 기본 | |
| 7 | BEFORE_TRANSPORT_MODE | Before Trans Mode | META | 기본 | |
| 8 | BUILDING | Building | META | 기본 | |
| 9 | CHANGE_REASON_CODE | Change Reason | META | 기본 | |
| 10 | CHANGE_REASON_DETAIL | Change Reason Detail | META | 기본 | |
| 11 | CHANGE_TYPE | Change Type | META | 기본 | |
| 12 | CONFIRM_ID | Confirm ID | META | 기본 | |
| 13 | CUSTOMER_LT | L/T(Day) | META | 기본 | |
| 14 | CUSTOMER_REQUIRMENT | Customer Requirement | META | 기본 | |
| 15 | DIVISION_ID | Div | META | 기본 | |
| 16 | END_CUSTOMER | End Customer | META | 기본 | |
| 17 | ERP_SO_NO | SO No | META | 기본 | |
| 18 | FCST_TYPE | FCST Type | META | 기본 | |
| 19 | FROM_SITE | From Site | META | 기본 | |
| 20 | INCOTERMS | Incoterms | META | 기본 | |
| 21 | ITEM_ID | Model | META | 기본 | |
| 22 | LAST_SEQ | Last Seq | META | **숨김** | |
| 23 | LAST_UPDATE_DATE | Last Update Date | META | 기본 | |
| 24 | MODEL_PIC | Model PIC | META | 기본 | |
| 25 | MTK_OWNER | MKT Owner | META | 기본 | |
| 26 | NICK_NAME | Nick Name | META | 기본 | |
| 27 | PROJECT_NAME | Project Name | META | 기본 | |
| 28 | QTY | Qty | META | 기본 | |
| 29 | QTY_CHANGE | Qty Change | META | 기본 | |
| 30 | REMARKS | Remarks | META | 기본 | |
| 31 | REMARKS_CHANGE | Remarks Change | META | 기본 | |
| 32 | REQUEST_DATE | Request Date | META | 기본 | |
| 33 | REQUEST_NO | Request No | META | 기본 | CellType=cellTypeImage |
| 34 | REQUESTOR | Requestor | META | 기본 | |
| 35 | REQUESTOR_DEPT_NAME | Requestor Dept Name | META | 기본 | |
| 36 | SEQ | Seq | META | 기본 | |
| 37 | SHIP_TO_PARTY | Ship To Party | META | 기본 | |
| 38 | SHIPMENT_DATE | Shipment Date | META | 기본 | |
| 39 | SHIPMENT_DATE_CHANGE | Shipment Date Change | META | 기본 | |
| 40 | SHIPMENT_REQUESTOR | Shipment Requestor | META | 기본 | |
| 41 | SOLD_TO_PARTY | Sold To Party | META | 기본 | |
| 42 | TO_SITE | To Site | META | 기본 | |
| 43 | TRANS_MODE_CHANGE | Trans Mode Change | META | 기본 | |
| 44 | TRANSPORT_MODE | Trans Mode | META | 기본 | |
| 45 | TYPE | Type | META | 기본 | |
| 46 | VARIABLE_DATE | Variable Date | META | 기본 | |
| 47 | VARIABLE_QTY | Variable Qty | META | 기본 | |

- 위 순서는 grid_effective.csv 행 순서(알파벳순)입니다. 실제 표시 순서·폭·정렬·고정(FIXED_FLAG) 값은 SCM_MST_SHEET_COLUMNS 메타 원문으로 **확인 필요**.
- AddSheet 인자 `1 ¦ 1 ¦ 30` 의 의미(헤더 행 수·고정 등)는 **확인 필요**.

## 4. 시트 연결 규칙
- 시트는 `Shipment Change History` 1개(SpdSheet.shtMain)입니다. 다른 시트와 마스터-디테일 연결은 추출되지 않았습니다.
- `SpdMain_CellClick` 이 REQUEST_NO 이미지 셀과 연동되어 다른 동작(팝업 등)을 하는지는 **확인 필요**.

=== FILE: oracle_migration.md ===
# SSP0019 Oracle 전환 분석

## 1. 호출 SP / SQL 인벤토리
| FoxQuery 키 | 유형 | 대상 | 참조 객체 / EXEC 체인 | 호출 위치 |
|---|---|---|---|---|
| SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY | SP | `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` | EXEC:SSP0019_GET_SHIPMENT_CHANGE_HISTORY → REF:FN_GET_IN_STR, REF:FN_SCM_SPLIT, DYNAMIC@SSP0019_GET_SHIPMENT_CHANGE_HISTORY | FindData_Main:409 |
| SCP.GET_DATE_RANGE_1MONTH | statement | foxquery_sql\SCP.GET_DATE_RANGE_1MONTH.sql | SELECT:SCM_SYS_CALENDAR_M | GetDayRange:522 |

- SP `SSP0019_GET_SHIPMENT_CHANGE_HISTORY` 의 테이블 참조는 추출되지 않았습니다(동적 SQL 내부). → **확인 필요**
- 주석 처리됨: `SCP.SCM0001_GET_SCP_DAY_PERIOD` (523줄). 전환 대상에서 제외합니다.

## 2. 공통코드 분기
| 호출 | code | 대상 테이블 | 반환 컬럼 사용 |
|---|---|---|---|
| biz:CommonData.CommonDataList (SetChangedPeriod:500) | `PERIOD_{p:value}` \|\| `PERIOD_DEFAULT` | 확인 필요(Biz 내부) | FROM_VALUE(507), TO_VALUE(508) |

- `{p:value}` 는 메서드 파라미터 값입니다. 어떤 값이 들어오는지와 호출 진입점은 **확인 필요**(정적 분석상 unreached).

## 3. FoxQuery 미등록 / 직접 호출 SP
- FoxQuery 미등록 건: 없음. 활성 FoxQuery 2건 모두 MATCH.
- 직접 호출 SP: 추출되지 않음.
- Biz 호출: `Data.CallBizCommonData` 경유 1건(위 2장).

## 4. 프레임워크 메타 의존 (Oracle 측 메타 이관 필요)
| 프레임워크 | 메타 원천 | 비고 |
|---|---|---|
| SpreadInfo.SetSheetHeaderColumn | SCM_MST_SHEET_COLUMNS (SSP0019, 47행) | 시트 `Shipment Change History` |
| DataService.GetSSPInnerTable | 확인 필요 | CODE, COMPANY_ID, DEPT_ID, DIVISION_ID, END_CUSTOMER, LANGUAGE_CODE, NAME, PLANT_ID, SCM_SITE_ID 읽음 |
| DataService.FP_Log2 | 확인 필요 | LOGTYPE, NOTE, USER_ID |
| 기타 메타 테이블 | TB_FX_SearchCondition 96행, TB_FX_Favorite 17행, TB_FX_GroupMenuAuth 16행, TB_FX_MenuItemInfo 4행, TB_FX_ProgramInfo 4행, SCM_ADM_DB_SCRIPT_BACKUP 26행 | |

## 5. Oracle 전환 시 확인 포인트
1. **SSP0019_GET_SHIPMENT_CHANGE_HISTORY**
   - 동적 SQL(DYNAMIC) 포함 → 문자열 조립 구문을 Oracle 문법(`||`, EXECUTE IMMEDIATE / OPEN cursor FOR)으로 바꿔야 합니다. 원문 확인 필요.
   - `FN_GET_IN_STR`, `FN_SCM_SPLIT` 함수 의존 → Oracle 에 같은 함수가 있는지, 반환 형식(IN 문자열 / 분할 테이블)이 같은지 확인해야 합니다.
   - 다건 입력 파라미터(SO No·Model·Confirm ID 멀티라인, CheckedList 값 5건)를 분할 함수로 처리하는 것으로 보이나, 파라미터와 함수의 대응은 **확인 필요**.
   - 결과 컬럼 46(+LAST_SEQ) 과 메타 컬럼의 일치 여부: grid 단계 미실행으로 **확인 필요**.
2. **SCP.GET_DATE_RANGE_1MONTH**: SCM_SYS_CALENDAR_M 단일 SELECT 입니다. 날짜 함수의 MSSQL→Oracle 변환 여부는 SQL 원문으로 확인해야 합니다.
3. **공통코드 PERIOD_***: CommonDataList 의 TO-BE 대응 API와 원천 테이블을 확인해야 합니다.

## 6. 난이도 (사실 근거)
| 대상 | 근거 | 판단 |
|---|---|---|
| SSP0019_GET_SHIPMENT_CHANGE_HISTORY | 동적 SQL + 함수 2종(FN_GET_IN_STR, FN_SCM_SPLIT) 참조, 테이블 미추출 | 중 이상 (원문 확인 전 확정 불가) |
| SCP.GET_DATE_RANGE_1MONTH | 단일 테이블 SELECT statement | 하 (원문 확인 필요) |
| CommonData PERIOD | Biz 경유, 원천 미확인 | 확인 필요 |

=== FILE: tobe_design.md ===
# SSP0019 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)
| 순 | 라벨(원문) | As-is 컨트롤 | 유형 | 초기값 / 비고 |
|---:|---|---|---|---|
| 1 | Division | clbDivision | 다중 체크 목록 | SelectedIndexChanged 이벤트 있음(동작 확인 필요) |
| 2 | From Site | clbFromSite | 다중 체크 목록 | 데이터 원천 확인 필요(GetSSPInnerTable 후보) |
| 3 | To Site | clbToSite | 다중 체크 목록 | 데이터 원천 확인 필요 |
| 4 | 확인 필요(TransportMode) | clbTransportMode | 다중 체크 목록 | 라벨 Text 미추출 |
| 5 | Incoterms | clbIncomterms | 다중 체크 목록 | |
| 6 | Shipment Date | drpPeriod | 기간 | Form_Load 시 `SCP.GET_DATE_RANGE_1MONTH` 로 초기화 |
| 7 | SO No | txtSoNo | 다건 텍스트 | |
| 8 | Model | txtItemId + btnItemId | 다건 텍스트 + 찾기 버튼 | 버튼 클릭 시 txtItemId 설정 |
| 9 | Confirm ID | txtConfirmId | 다건 텍스트 | |
| 10 | Current | chkCurrent | 체크박스 | CheckedChanged 이벤트 있음(동작 확인 필요) |

- 순서는 정리용이며 실제 배치 순서는 Layout 좌표로 **확인 필요**합니다.
- 저장된 조회조건(TB_FX_SearchCondition 96행)이 있으므로 조회조건 저장·복원 기능이 대상입니다.

## 2. 액션별 호출 API 후보
| 액션 | As-is 경로 | 호출 | TO-BE API 후보 |
|---|---|---|---|
| 화면 로드 | Form_Load > InitControls > GetDayRange | SCP.GET_DATE_RANGE_1MONTH | 기간 기본값 조회 API (공통) |
| 화면 로드(콤보) | SetChangeControl > GetSSPInnerTable ×3 | 프레임워크 | SSP 공통 콤보 API (대상 컨트롤 확인 필요) |
| 조회(FindButton) | FindData_Main | SSP.SSP0019_GET_SHIPMENT_CHANGE_HISTORY | `SSP0019` 조회 API → SP SSP0019_GET_SHIPMENT_CHANGE_HISTORY |
| 기간 변경(진입점 미확정) | SetChangedPeriod | biz:CommonData.CommonDataList (PERIOD_*) | 공통코드 API (진입점 확인 필요) |
| Model 찾기 | btnItemId_Click | 확인 필요 | Model 선택 팝업 |
| 그리드 클릭 | SpdMain_CellClick | 확인 필요 | 확인 필요 |
| 그리드 스크롤 | SpdMain_TopChange | 확인 필요 | 확인 필요 |

- 저장/삭제 엔드포인트는 추출되지 않았습니다. 조회 전용 화면입니다.

## 3. Division별 Grid 변형 요약
- 시트 `Shipment Change History` 1개. 메타 기반(SetSheetHeaderColumn)으로 구성합니다.
- 14개 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC) 모두 46컬럼 표시로 **변형 없음**.
- LAST_SEQ 는 숨김 컬럼으로 유지합니다.
- REQUEST_NO 는 이미지 셀 타입(코드 하드코딩)이므로 TO-BE 에서 셀 템플릿(이미지/아이콘)이 필요합니다.

## 4. 권한(C/R/U/D) 관련 사실
- TB_FX_GroupMenuAuth 에 SSP0019 관련 16행이 있습니다. 행별 C/R/U/D 값은 Fact Pack 에 없어 **확인 필요**.
- 코드에서 사용자/그룹 정보를 사용합니다: SetChangeControl:163~164 (Filter GROUP_ID·USER_ID, NowGroupID), SetChangedControl:298·303 (NowGroupID). 그룹별 조건 컨트롤 분기로 보이나 구체 동작은 **확인 필요**.
- InitControls:258·262 에서 FP_Log2 로 사용 로그(LOGTYPE, NOTE, USER_ID)를 남깁니다.

## 5. 미확정 사항
1. SP 파라미터 목록과 각 조회조건의 대응(GetCheckedListValue 5건: FindData_Main 387~390, 396).
2. SP 결과 컬럼과 메타 46컬럼의 일치 여부(grid 단계 미실행).
3. SetChangedPeriod / CommonData PERIOD_* 의 진입점과 코드값.
4. btnItemId_Click 팝업의 종류와 반환값(sItemId) 출처.
5. Current 체크, Division 변경, CellClick, TopChange 핸들러의 동작.
6. TransportMode 라벨 원문.
7. 조회조건 레이아웃 좌표와 splitter1(Dock=Bottom) 의 실제 역할.
8. GroupMenuAuth 16행의 권한 값.
