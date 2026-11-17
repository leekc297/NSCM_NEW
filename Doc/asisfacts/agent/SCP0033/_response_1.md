[LITE]
=== FILE: analysis.md ===
# SCP0033 Shipment Semi Dept Day — AS-IS 분석서

> 출처: AsisFacts 정적 추출 Fact Pack(SCP0033). Fact Pack에 없는 내용은 **확인 필요**로 표시했습니다.

## 1. 화면 개요

| 항목 | 값 |
|---|---|
| 화면 ID | SCP0033 |
| 도메인 | SCP (경로 `06.UIL\GSCM.SCP.Forms.UIL\Master\` 기준) |
| 클래스 | `SCP0033_Shipment_semi_dept_day` |
| Form Text | `SCP0033_Shipment_semi_dept_day` (Designer.cs:310) |
| 프로젝트 | `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0033_Shipment_semi_dept_day\SCP0033_Shipment_semi_dept_day.csproj` |
| 메뉴명·화면 제목(업무 명칭) | 확인 필요 (TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있지만 Fact Pack에 내용이 없음) |

### 1-1. 파일 구성

| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0033_Shipment_semi_dept_day\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0033_Shipment_semi_dept_day\SCP0033_Shipment_semi_dept_day.cs` | 584 |
| current | `...\SCP0033_Shipment_semi_dept_day\SCP0033_Shipment_semi_dept_day.Designer.cs` | 351 |
| shared | 없음 (Fact Pack에 없음) | - |
| legacy | 없음 (Fact Pack에 없음) | - |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)

| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 258 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | MATCH | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY |
| button:SaveButton | SaveButton > SaveData_Main | 380 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | MATCH | SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main (저장 후 재조회) | 258 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | MATCH | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY |
| unreached (진입점 미연결) | `<field:dtDepartureDay>` | 43 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | - |
| unreached (진입점 미연결) | `<field:dtYesOrNo>` | 44 | `biz:CommonData.YesOrNo` | BIZ_MATCH | - |

- 조회 시 `FindData_Main`은 `GetCheckedListValue`(CString.GetCheckedListValue, CODE 컬럼)를 241·242·244줄에서 호출합니다. 어떤 컨트롤의 값인지는 확인 필요입니다(조회조건 중 UsrCheckedList는 `clbDivision` 1개만 있음).
- 필드 초기화(43·44줄)에서 공통 데이터를 받지만 이벤트·버튼 진입점과의 연결은 정적으로 확인되지 않았습니다. 이 데이터를 어느 컨트롤이나 Grid 셀에 바인딩하는지는 확인 필요입니다.

## 3. 엔드포인트 전체 표

| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체 (SP 내부 EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | - (Biz) | 코드분기 UP_FX_GetCommonDataList: SELECT SCM_ADM_LOOKUP_MASTER, SELECT SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | - (Biz) | 확인 필요 |
| `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | MATCH | 1 | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | REF FN_GET_DIVISION_DIV, SELECT SCM_MST_ITEM_SN, SELECT SCP_MST_SHIPMENT_SEMI_DEPT_DAY, REF STRING_SPLIT, SELECT SCM_MST_DIVISION |
| `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | MATCH | 1 | SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY | EXEC PR_SCM_SYS_LOG_BATCH, REF SCM_ARR_SPL_CNT, REF SCM_ARR_SPL_VAL, EXEC PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, UPDATE/INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY, INSERT SCM_SYS_LOG_BATCH, INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H |

- 주석 처리된 호출: 0건

## 4. 이벤트 배선

| 대상 | 이벤트 | 핸들러 | 등록 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:83 |
| this.spdMain | CellClick | `SpdMain_CellClick` | .ctor:84 |
| this.spdMain | KeyPress | `SpdMain_KeyPress` | .ctor:85 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:107 |

- 각 핸들러의 처리 내용(본문)은 Fact Pack에 없어 확인 필요입니다.

## 5. Grid 구성 방식

**구성 방식: `META(프레임워크) (+코드 표시/라벨 변경)`**

- 시트 생성: `CreateSpread`에서 `AddSheet`(147줄, 인자 `spdMain ¦ SpdSheet.shtMain ¦ SpdSheet.shtMain ¦ 1 ¦ 1 ¦ 30`) → `GetSheetInfo`(148줄) → `ChangeSheet`(149줄). 시트 이름은 **Shipment Semi Dept Day**입니다.
- 컬럼 생성: `InitSpread`에서 `InitSheet`(156줄) → `SetSheetHeaderColumn`(161줄, 컬럼 헤더 1행)을 호출합니다. 이 메서드가 SCM_MST_SHEET_COLUMNS 메타를 읽습니다(COLUMN_NAME, COLUMN_LABEL_NAME, COLUMN_WIDTH, VISIBLE_FLAG, VALID_YN, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, UPPERCASE_APPLY_FLAG, ATTRIBUTE1~5 등).
- 코드 보정:
  - `InsertButton`(204줄): 시트가 `Shipment Semi Dept Day`이고 잠금 상태가 아니면, 새 행의 `DIVISION_ID` 셀을 Combo로 바꿉니다. 콤보 데이터는 `BLUtils.GetDivision(false, "")`(변수 `dtMyDivision`)입니다.
  - `InitializeComponent`(Designer.cs 270~273줄): 컬럼 헤더 스타일만 바꿉니다(HorizontalAlignment·VerticalAlignment = General, NoteIndicatorColor = Red, Parent = ColumnHeaderDefaultEnhanced).
- Division별 차이: **없음**. 40, 81, 81_HD/HG/HM/ST/UC, 82, EE, EE_HD/HG/HM/ST/UC 모두 메타 10컬럼(필수 10/선택 0)이고, 최종 표시도 10컬럼입니다. `S_VALID_YN`은 모든 division에서 숨김입니다.
- 분기 조건 판단불가: 0건

## 6. 확인 필요 항목

1. `dtDepartureDay`(LookupCommon)와 `dtYesOrNo`의 바인딩 대상: 진입점 미연결이고, 어떤 Lookup 코드값을 쓰는지도 Fact Pack에 없습니다.
2. 이벤트 핸들러 4개(`Form_Load`, `SpdMain_CellClick`, `SpdMain_KeyPress`, `SpdMain_TopChange`)의 본문 로직
3. `FindData_Main` 241·242·244줄 `GetCheckedListValue` 3회 호출 각각의 대상 컨트롤과 SP 파라미터 매핑
4. `cboValidYN` 콤보 항목의 데이터 소스
5. 삭제(Delete) 버튼의 존재 여부: 흐름에는 Find·Save만, grid_code에는 Insert·Edit만 나타남
6. 권한(TB_FX_GroupMenuAuth 11행)과 조회조건 메타(TB_FX_SearchCondition 2행)의 내용
7. 실제 SP 실행 결과와 일치하는 시트가 없음(grid 단계 미실행 또는 시트명 불일치)

=== FILE: source_links.md ===
# SCP0033 소스 링크

기준 폴더: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0033_Shipment_semi_dept_day\`

## 1. 엔드포인트 호출 지점

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0033_Shipment_semi_dept_day.cs | `<field:dtDepartureDay>` | 43 | `biz:CommonData.CommonDataList` [code=LookupCommon] (Data.Common → Data.CallBizCommonData) |
| SCP0033_Shipment_semi_dept_day.cs | `<field:dtYesOrNo>` | 44 | `biz:CommonData.YesOrNo` (Data.Common → Data.CallBizData) |
| SCP0033_Shipment_semi_dept_day.cs | FindData_Main | 258 | `SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` |
| SCP0033_Shipment_semi_dept_day.cs | SaveData_Main | 380 | `SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` |

## 2. 이벤트 등록

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0033_Shipment_semi_dept_day.cs | .ctor | 83 | `this.Load += Form_Load` |
| SCP0033_Shipment_semi_dept_day.cs | .ctor | 84 | `this.spdMain.CellClick += SpdMain_CellClick` |
| SCP0033_Shipment_semi_dept_day.cs | .ctor | 85 | `this.spdMain.KeyPress += SpdMain_KeyPress` |
| SCP0033_Shipment_semi_dept_day.cs | InitEvent | 107 | `spdMain.TopChange += SpdMain_TopChange` |

## 3. Grid·메타 관련

| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| SCP0033_Shipment_semi_dept_day.cs | CreateSpread | 147 | AddSheet (spdMain, SpdSheet.shtMain = "Shipment Semi Dept Day", 1, 1, 30) |
| SCP0033_Shipment_semi_dept_day.cs | CreateSpread | 148 | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) |
| SCP0033_Shipment_semi_dept_day.cs | CreateSpread | 149 | ChangeSheet |
| SCP0033_Shipment_semi_dept_day.cs | InitSpread | 156 | InitSheet(siMain.SheetName) |
| SCP0033_Shipment_semi_dept_day.cs | InitSpread | 161 | SetSheetHeaderColumn(siMain, 1): 메타 컬럼 생성 |
| SCP0033_Shipment_semi_dept_day.cs | InsertButton | 204 | SetCellTypeCombo(ActiveRowIndex, DIVISION_ID, dtMyDivision = BLUtils.GetDivision(false, "")) |
| SCP0033_Shipment_semi_dept_day.cs | EditButton | 219 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| SCP0033_Shipment_semi_dept_day.cs | FindData_Main | 241, 242, 244 | GetCheckedListValue (CODE) |
| SCP0033_Shipment_semi_dept_day.Designer.cs | InitializeComponent | 270~273 | 컬럼 헤더 스타일 (Horizontal/VerticalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 컨트롤 선언 (Designer.cs)

| 파일 | 컨트롤 | 줄 |
|---|---|---:|
| Designer.cs | usrLayoutControl1 / layoutControlGroup1 / usrConditionPanel1 / usrLayoutControl2 | 33 / 34 / 35 / 36 |
| Designer.cs | cboValidYN / txtItemId / clbDivision | 37 / 38 / 39 |
| Designer.cs | layoutControlGroup2 / layoutControlItem13 / emptySpaceItem3 / layoutControlItem3 / layoutControlItem4 | 40 / 41 / 42 / 43 / 44 |
| Designer.cs | spdMain / spdMain_Sheet1 / imageList1 | 45 / 46 / 47 |

=== FILE: web_components.md ===
# SCP0033 웹 컴포넌트 매핑

## 1. 컨트롤 → React/Wijmo 매핑

| AS-IS 컨트롤 | 유형 | 라벨 (원문) | TO-BE 후보 | 비고 |
|---|---|---|---|---|
| txtItemId | TextBox | `Model` (layoutControlItem13) | 텍스트 입력 | Size 198×24 |
| cboValidYN | UsrCombo | `Valid` (layoutControlItem3) | ComboBox (Wijmo) | Size 155×20, 항목 소스는 확인 필요 |
| clbDivision | UsrCheckedList | `Division` (layoutControlItem4) | MultiSelect (Wijmo) | Size 199×21, GetCheckedListValue(CODE) |
| emptySpaceItem3 | EmptySpaceItem | - | 여백 | 473×28 |
| usrConditionPanel1 | UsrConditionPanel | - | 조회조건 영역 | Dock Top, PanelType HidePanel |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | - | FlexGrid (Wijmo) | Dock Fill |
| usrLayoutControl1 / layoutControlGroup1 | Layout | - | 확인 필요 | 657×184, parent 미확인 |
| imageList1 | ImageList | - | 미사용 후보 | 용도는 확인 필요 |

## 2. 화면 배치

- props.csv에는 SplitContainer가 없습니다. 분할 컨트롤 없이 Dock으로만 배치합니다.
- 상단: `usrConditionPanel1` Dock Top, 1168×48
- 하단: `spdMain` Dock Fill, 1168×544
- 상/하 비율(Designer 크기 기준): 48 : 544, 약 8.1% : 91.9%
- 조회조건 순서(LayoutControl 기준): Model(239×28) · 여백(473×28) · Valid(189×28) · Division(247×28). 실제 좌표 순서는 Location이 Fact Pack에 없어 확인 필요입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Semi Dept Day`

구성: META(SetSheetHeaderColumn) + 코드 보정(InsertButton의 DIVISION_ID Combo, 헤더 스타일)

| 컬럼 | 라벨 (메타 원문) | 출처 | 40 | 81 계열 (81, _HD/_HG/_HM/_ST/_UC) | 82 | EE 계열 (EE, _HD/_HG/_HM/_ST/_UC) |
|---|---|---|---|---|---|---|
| DIVISION_ID | Division* | META (+코드 Combo, 행 추가 시) | 기본 | 기본 | 기본 | 기본 |
| ITEM_ID | Model* | META | 기본 | 기본 | 기본 | 기본 |
| NICK_NAME | Nick Name | META | 기본 | 기본 | 기본 | 기본 |
| OPERATION_GROUP | Operation Group | META | 기본 | 기본 | 기본 | 기본 |
| DEPARTURE_DAY | Departure day | META | 기본 | 기본 | 기본 | 기본 |
| VALID_YN | Valid | META | 기본 | 기본 | 기본 | 기본 |
| S_VALID_YN | S_VALID_YN | META | 숨김 | 숨김 | 숨김 | 숨김 |
| CREATED_BY | Created By | META | 기본 | 기본 | 기본 | 기본 |
| CREATION_DATE | Creation Date | META | 기본 | 기본 | 기본 | 기본 |
| LAST_UPDATED_BY | Last Updated By | META | 기본 | 기본 | 기본 | 기본 |
| LAST_UPDATE_DATE | Last Update Date | META | 기본 | 기본 | 기본 | 기본 |

- 표시 컬럼 수: 모든 division에서 10개(division별 차이 없음)
- 위 표의 행 순서는 grid_effective.csv의 순서가 아닙니다. 실제 컬럼 순서·폭·정렬·셀 타입(DEPARTURE_DAY, VALID_YN의 Combo 여부 등)은 SCM_MST_SHEET_COLUMNS 원문 확인이 필요합니다.
- 헤더 스타일: Horizontal/VerticalAlignment General, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced (Designer.cs 270~273)

## 4. 시트 연결 규칙

| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Semi Dept Day | META+코드연결 | 코드에서 AddSheet/ChangeSheet로 메타 시트를 사용함 (CreateSpread 147~149) |

- 시트는 1개이고, 마스터-디테일 연결은 없습니다.

=== FILE: oracle_migration.md ===
# SCP0033 Oracle 전환 분석

## 1. 호출 SP 인벤토리

| SP | FoxQuery 키 | 호출 위치 | 참조 테이블 | EXEC 체인 |
|---|---|---|---|---|
| `SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY` | SCP.SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | FindData_Main:258 | SELECT SCM_MST_ITEM_SN, SCP_MST_SHIPMENT_SEMI_DEPT_DAY, SCM_MST_DIVISION | REF FN_GET_DIVISION_DIV, REF STRING_SPLIT |
| `SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY` | SCP.SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY | SaveData_Main:380 | UPDATE/INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY, INSERT SCM_SYS_LOG_BATCH, INSERT SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H | EXEC PR_SCM_SYS_LOG_BATCH, EXEC PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST, REF SCM_ARR_SPL_CNT, REF SCM_ARR_SPL_VAL |

## 2. 공통코드 분기

| Biz 엔드포인트 | code | 처리 SP | 테이블 |
|---|---|---|---|
| biz:CommonData.CommonDataList | LookupCommon | UP_FX_GetCommonDataList | SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | - | 확인 필요 | 확인 필요 |

- 두 엔드포인트 모두 필드 초기화(43·44줄) 지점이고, 진입점은 연결되지 않았습니다. LookupCommon의 Lookup 코드값은 확인 필요입니다.

## 3. FoxQuery 미등록 / 직접 호출 SP

- 없음. 두 SP 모두 상태가 MATCH(FoxQuery 등록)입니다.
- 주석 처리된 호출은 0건입니다.

## 4. Oracle 전환 시 확인 포인트

| # | 항목 | 근거 | 확인 내용 |
|---|---|---|---|
| 1 | `STRING_SPLIT` | GET SP의 REF | MSSQL 전용 함수이므로 Oracle 대체 구현이 필요합니다. 분리 대상 파라미터(Division 등)는 확인 필요 |
| 2 | `FN_GET_DIVISION_DIV` | GET SP의 REF | Oracle 측에 함수가 있는지, 시그니처가 같은지 확인 |
| 3 | `SCM_ARR_SPL_CNT`, `SCM_ARR_SPL_VAL` | SAVE SP의 REF | 배열(구분자 문자열) 분해 함수의 Oracle 대응 객체 확인 |
| 4 | `PR_SCP_MST_SHIPMENT_SEMI_DEPT_DAY_HIST` → `SCP_MST_SHIPMENT_SEMI_DEPT_DAY_H` | SAVE SP의 EXEC/INSERT | 이력 SP와 이력 테이블 전환, 호출 순서 보존 |
| 5 | `PR_SCM_SYS_LOG_BATCH` → `SCM_SYS_LOG_BATCH` | SAVE SP의 EXEC/INSERT | 공통 로그 SP의 Oracle 대응 확인 |
| 6 | UPDATE + INSERT on `SCP_MST_SHIPMENT_SEMI_DEPT_DAY` | SAVE SP | 신규/수정 분기 조건(키 구성)은 확인 필요. MERGE 전환 여부는 SP 원문을 보고 판단 |
| 7 | 저장 후 재조회 | SaveButton > SaveData_Main > FindData_Main | TO-BE에서도 저장 뒤 재조회 흐름 유지 |

- 난이도: Fact Pack 기준으로 SP 2개와 MSSQL 전용 함수 참조 1종(STRING_SPLIT)이 확인됩니다. SP 본문(파라미터·로직 길이)이 Fact Pack에 없어 정량 난이도는 확인 필요입니다.

=== FILE: tobe_design.md ===
# SCP0033 TO-BE 설계 입력

## 1. 조회조건 (컨트롤 기준)

| 라벨 (AS-IS 원문) | AS-IS 컨트롤 | TO-BE 형태 | 값 소스 |
|---|---|---|---|
| Model | txtItemId (TextBox) | 텍스트 입력 | 자유 입력 |
| Valid | cboValidYN (UsrCombo) | 단일 콤보 | 확인 필요 (biz:CommonData.YesOrNo 후보, 바인딩 미확인) |
| Division | clbDivision (UsrCheckedList) | 다중 선택 | CODE 값 (GetCheckedListValue) |

- 조회조건 메타 TB_FX_SearchCondition은 2행입니다. 컨트롤은 3개라서 개수가 다르며, 원인은 확인 필요입니다.

## 2. 액션별 호출 API 후보

| 액션 | AS-IS | 호출 엔드포인트 | 비고 |
|---|---|---|---|
| 조회 | FindButton → FindData_Main | SCP0033_GET_SHIPMENT_SEMI_DEPT_DAY | |
| 저장 | SaveButton → SaveData_Main | SCP0033_SAVE_SHIPMENT_SEMI_DEPT_DAY → 재조회 GET | |
| 행 추가 | InsertButton (204줄) | 서버 호출 없음 | DIVISION_ID 셀을 Combo로 설정, 데이터는 BLUtils.GetDivision(false, "") |
| 편집 | EditButton (219줄) | 서버 호출 없음 (GetSheetInfo만 확인) | 상세 로직 확인 필요 |
| 삭제 | 확인 필요 | 확인 필요 | Fact Pack에 없음 |
| 화면 로드 | Form_Load | 확인 필요 | 본문 미추출 |
| Grid 이벤트 | SpdMain_CellClick / SpdMain_KeyPress / SpdMain_TopChange | 확인 필요 | 본문 미추출 |
| 공통 데이터 | 필드 43·44줄 | CommonData.CommonDataList [LookupCommon], CommonData.YesOrNo | 진입점 미연결 |

## 3. Division별 Grid 변형 요약

- 시트는 `Shipment Semi Dept Day` 1개입니다. 모든 division(40, 81 계열, 82, EE 계열)에서 표시 컬럼이 10개로 같아 변형이 없습니다.
- 숨김 컬럼: `S_VALID_YN`
- 필수 표시 라벨: `Division*`, `Model*`

## 4. 권한 (C/R/U/D) 관련 사실

- TB_FX_GroupMenuAuth 11행, TB_FX_MenuItemInfo 1행, TB_FX_ProgramInfo 1행이 있습니다. 그룹별 C/R/U/D 값은 Fact Pack에 없어 확인 필요입니다.
- InsertButton 처리는 `siMain.IsLock(siMain.SheetName) == false`일 때만 Combo를 설정합니다(시트 잠금 조건).

## 5. 미확정 사항

1. 이벤트 핸들러 4개의 로직
2. Valid 콤보와 Grid의 DEPARTURE_DAY·VALID_YN 셀 타입 및 콤보 소스(LookupCommon 코드값 포함)
3. 삭제 기능 여부
4. Grid 컬럼의 순서·폭·정렬·편집 가능 여부 (SCM_MST_SHEET_COLUMNS 원문)
5. GET/SAVE SP의 파라미터 목록과 저장 키 구성
6. 권한 행의 상세 값
7. usrLayoutControl1(657×184)과 imageList1의 용도
