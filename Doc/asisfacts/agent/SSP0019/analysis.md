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
