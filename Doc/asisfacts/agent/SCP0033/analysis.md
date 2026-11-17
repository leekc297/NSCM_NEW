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
