# SCM0001 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0001_CommonListBox.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 314 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0001_CommonListBox.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 1199 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_Division_Data | 151 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_FromSite_Data | 164 | SCM.SCM0001_GET_FROM_SITE | MATCH | SP SCM0001_GET_FROM_SITE |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_ToSite_Data | 177 | SCM.SCM0001_GET_TO_SITE | MATCH | SP SCM0001_GET_TO_SITE |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_Site_By_Division_Data | 193 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_Plant_Data | 207 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_Building_Data | 221 | SCM.SCM0001_GET_BUILDING_BY_PLANT | MATCH | SP SCM0001_GET_BUILDING_BY_PLANT |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_Operation_Data | 235 | SCM.SCM0001_GET_OPERATION_BY_BUILDING | MATCH | SP SCM0001_GET_OPERATION_BY_BUILDING |
| event:this.Load | Form_Load > InitControls > List_SetUp > Get_Line_Data | 251 | SCM.SCM0001_GET_LINE_BY_OPERATION | MATCH | SP SCM0001_GET_LINE_BY_OPERATION |
| event:this.usrCheckedList3.SelectedIndexChanged | sDivision_SelectedIndexChanged > Get_Site_By_Division_Data | 193 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.usrCheckedList3.SelectedIndexChanged | sDivision_SelectedIndexChanged > Get_Plant_Data | 207 | SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | SP SCM0001_GET_PLANT_BY_DIVISION |
| event:this.usrCheckedList6.SelectedIndexChanged | sPlant_SelectedIndexChanged > Get_Building_Data | 221 | SCM.SCM0001_GET_BUILDING_BY_PLANT | MATCH | SP SCM0001_GET_BUILDING_BY_PLANT |
| event:this.usrCheckedList7.SelectedIndexChanged | sBuilding_SelectedIndexChanged > Get_Operation_Data | 235 | SCM.SCM0001_GET_OPERATION_BY_BUILDING | MATCH | SP SCM0001_GET_OPERATION_BY_BUILDING |
| event:this.usrCheckedList8.SelectedIndexChanged | sOperation_SelectedIndexChanged > Get_Line_Data | 251 | SCM.SCM0001_GET_LINE_BY_OPERATION | MATCH | SP SCM0001_GET_LINE_BY_OPERATION |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| SCM.SCM0001_GET_BUILDING_BY_PLANT | MATCH | 1 | SP SCM0001_GET_BUILDING_BY_PLANT | EXEC:SCM0001_GET_BUILDING_BY_PLANT, SELECT:SCM_MST_FACTORY_SN, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_FROM_SITE | MATCH | 1 | SP SCM0001_GET_FROM_SITE | EXEC:SCM0001_GET_FROM_SITE, SELECT:SCM_MST_SITE |  |
| SCM.SCM0001_GET_LINE_BY_OPERATION | MATCH | 1 | SP SCM0001_GET_LINE_BY_OPERATION | EXEC:SCM0001_GET_LINE_BY_OPERATION, SELECT:SCM_MST_LINE_SN, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_OPERATION_BY_BUILDING | MATCH | 1 | SP SCM0001_GET_OPERATION_BY_BUILDING | EXEC:SCM0001_GET_OPERATION_BY_BUILDING, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_OPERATION_SN, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_PLANT_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_PLANT_BY_DIVISION | EXEC:SCM0001_GET_PLANT_BY_DIVISION, SELECT:SCM_MST_PLANT_SN, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |
| SCM.SCM0001_GET_TO_SITE | MATCH | 1 | SP SCM0001_GET_TO_SITE | EXEC:SCM0001_GET_TO_SITE, SELECT:SCM_MST_SITE |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.Column | Click | Column_Click | InitializeComponent:208 |
| this.button1 | Click | Measure_Click | InitializeComponent:217 |
| this.usrCheckedList3 | SelectedIndexChanged | sDivision_SelectedIndexChanged | InitializeComponent:279 |
| this.usrCheckedList6 | SelectedIndexChanged | sPlant_SelectedIndexChanged | InitializeComponent:716 |
| this.usrCheckedList7 | SelectedIndexChanged | sBuilding_SelectedIndexChanged | InitializeComponent:806 |
| this.button2 | Click | Column_Click | InitializeComponent:844 |
| this.usrCheckedList8 | SelectedIndexChanged | sOperation_SelectedIndexChanged | InitializeComponent:905 |
| this.button3 | Click | Customer_Click | InitializeComponent:1032 |
| this.button4 | Click | button4_Click | InitializeComponent:1041 |
| this | Load | Form_Load | .ctor:28 |

## 6. 컨트롤 (62개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| UsrConditionPanel | 13 | usrConditionPanel1, usrConditionPanel2, usrConditionPanel3, usrConditionPanel4, usrConditionPanel5, usrConditionPanel6, usrConditionPanel10, usrConditionPanel11, usrConditionPanel7, usrConditionPanel8, usrConditionPanel9, usrConditionPanel12, usrConditionPanel13 |
| UsrCheckedList | 9 | usrCheckedList3, usrCheckedList4, usrCheckedList2, usrCheckedList5, usrCheckedList10, usrCheckedList6, usrCheckedList7, usrCheckedList8, usrCheckedList9 |
| UsrLayoutControl | 8 | usrLayoutControl2, usrLayoutControl3, usrLayoutControl4, usrLayoutControl5, usrLayoutControl6, usrLayoutControl7, usrLayoutControl8, usrLayoutControl1 |
| LayoutControlGroup | 8 | layoutControlGroup2, layoutControlGroup3, layoutControlGroup4, layoutControlGroup5, layoutControlGroup6, layoutControlGroup7, layoutControlGroup8, layoutControlGroup1 |
| LayoutControlItem | 8 | layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem8, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7 |
| EmptySpaceItem | 8 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6, emptySpaceItem7, emptySpaceItem8, emptySpaceItem1 |
| Button | 5 | Column, button1, button2, button3, button4 |
| UsrRadio | 1 | usrRadio1 |
| ColorDialog | 1 | colorDialog1 |
| EventLog | 1 | eventLog1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 28 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **META(행 존재, 생성 호출 미발견)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
