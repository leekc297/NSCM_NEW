=== FILE: analysis.md ===
# SCP0096 — Shipment Working Day OSP: AS-IS 분석

> 근거: AsisFacts 정적 추출(Fact Pack). 묶음에 없는 사항은 **확인 필요**로 적었습니다.

## 1. 화면 개요
| 항목 | 값 |
|---|---|
| 화면 ID | SCP0096 |
| 도메인 | SCP (`06.UIL\GSCM.SCP.Forms.UIL\Master\`) |
| 클래스 | `SCP0096_Shipment_Working_Day_OSP` |
| 화면 제목(Form Text) | `Shipment Working Day OSP` (Designer.cs:663) |
| 프로젝트 | `SCP0096_Shipment_Working_Day_OSP.csproj` |

### 1-1. 파일 구성
| 구분 | 파일 | 줄수 |
|---|---|---:|
| current | `...\SCP0096_Shipment_Working_Day_OSP\Properties\AssemblyInfo.cs` | 37 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.cs` | 852 |
| current | `...\SCP0096_Shipment_Working_Day_OSP\SCP0096_Shipment_Working_Day_OSP.Designer.cs` | 724 |
| shared | 묶음에 따로 집계되지 않음(프레임워크 `SpreadInfo`, `CString`, `FPExtensions`, `Data.Common`만 호출 대상으로 확인됨) | — |
| legacy | 본문 표에 없음. CSV에 legacy 행 없음 | — |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 호출 경로 | 줄 | 엔드포인트 | 상태 | SP |
|---|---|---:|---|---|---|
| `Form_Load` (this.Load) | Form_Load > InitControls > GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | DM0003_GET_BUCKET_TYPE_CODE |
| `Form_Load` (this.Load) | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| FindButton | FindButton > FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| FindButton | FindButton > FindData_Main > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| SaveButton | SaveButton > SaveData_Main | 608 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP |
| SaveButton | SaveButton > SaveData_Main > FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP |
| SaveButton | SaveButton > SaveData_Main > FindData_Main > InitSpread > GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | SCP0009_GET_SHEET_CALENDAR_3SPAN |
| (진입점 미연결) | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | — |
| (진입점 미연결) | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo` | BIZ_MATCH | — |

- 저장한 뒤에는 `FindData_Main`으로 다시 조회합니다(SaveButton > SaveData_Main > FindData_Main).
- `dtValidYN`은 진입점 미연결로 분류됐습니다. 하지만 `InitSpreadDateColumn:203`의 `AddComboColumn` 인자 `dt`에 `dtValidYN`이 쓰입니다(grid_code.csv raw). 그러므로 실제로는 Grid 콤보 데이터로 쓰입니다.
- `dtDayWeek`(LookupCommon)를 소비하는 컨트롤은 **확인 필요**입니다. `cboDayWeek`일 가능성이 있지만, 바인딩 코드가 묶음에 없습니다.
- 주석 처리됨: 줄 456의 `SCP.SCP0019_GET_WORKING_TIME`(commented:MATCH). 현행 기능이 아니므로 흐름 집계에서 뺐습니다.

## 3. 엔드포인트 전체 표
| 엔드포인트 | 상태 | 호출 수 | SP | 참조 객체(EXEC 전이 포함) |
|---|---|---:|---|---|
| `biz:CommonData.CommonDataList` [code=LookupCommon] | BIZ_MATCH | 1 | (UP_FX_GetCommonDataList 코드 분기) | SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `biz:CommonData.YesOrNo` | BIZ_MATCH | 1 | — | — |
| `DM.DM0003_GET_BUCKET_TYPE_CODE` | MATCH | 1 | DM0003_GET_BUCKET_TYPE_CODE | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` | MATCH | 1 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SELECT:SCM_SYS_CALENDAR_M |
| `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | MATCH | 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, REF:STRING_SPLIT, DYNAMIC SQL |
| `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | MATCH | 1 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | MERGE:SCP_MST_SHIPMENT_WORKING_DAY_OSP, MERGE:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |

## 4. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 배선 위치 |
|---|---|---|---|
| this | Load | `Form_Load` | .ctor:103 |
| spdMain | CellDoubleClick | `SpdMain_CellDoubleClick` | InitEvent:249 |
| spdMain | TopChange | `SpdMain_TopChange` | InitEvent:250 |
| cboDivision | SelectedIndexChanged | `CboDivision_SelectedIndexChanged` | InitEvent:251 |
| clbPlantSite | SelectedIndexChanged | `ClbPlantSite_SelectedIndexChanged` | InitEvent:252 |
| cboDayWeek | SelectedIndexChanged | `CboDayWeek_SelectedIndexChanged` | InitEvent:253 |
| btnInput | Click | `BtnInput_Click` | InitEvent:254 |
| this.chkSum | CheckedChanged | `chkSum_CheckedChanged` | InitEvent:255 |

추출된 핸들러 동작:
- `CboDayWeek_SelectedIndexChanged`: `GetCheckedListValue` 호출(672). 분기에 따라 `cboInputValue.Enabled = false`(675) 또는 `true`(679). 분기 조건은 **확인 필요**입니다.
- `BtnInput_Click`: `GetCheckedListValue` 호출(695, 696). 그 뒤 Grid에 값을 넣는 로직은 **확인 필요**입니다.
- `chkSum_CheckedChanged`: `SetSpreadColumn` 호출(330, 335)로 합계 컬럼(M_/W_)의 표시 여부를 바꿉니다.
- `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged`: 내부 동작이 묶음에 없습니다. **확인 필요**.
- 배선 없는 메서드: `cboBucketType_SelectedIndexChanged`(311/316에서 SetSpreadColumn 호출)는 존재하지만, 이벤트 배선 표에 없고 `cboBucketType` 컨트롤도 controls.csv에 없습니다. 사용 여부는 **확인 필요**입니다. `SetChangedControl`(417, 425)의 호출자도 **확인 필요**입니다.

## 5. Grid 구성 방식
**구성 방식: `HYBRID: META(프레임워크) + DB루프(코드) (+코드 표시/라벨 변경)`**

| 단계 | 위치 | 내용 |
|---|---|---|
| 시트 생성 | CreateSpread:142 | `AddSheet(spdMain, "Shipment Working Day OSP", "Shipment Working Day OSP", 3, 1, 35)`. 인자 3/1/35의 의미는 **확인 필요** |
| 메타 컬럼 | InitSpread:156 | `SetSheetHeaderColumn(siMain, 3)`: SCM_MST_SHEET_COLUMNS 메타 6개 컬럼 |
| 날짜 헤더 조회 | InitSpread:151 > GetSpdTitle:831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` 결과(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE/SMALL_CLASS_LABEL_NAME) |
| DB 루프 컬럼 | InitSpreadDateColumn:196/203 | 컬럼명에 `B_`가 있으면(`IndexOf("B_") > 0`) `AddTextColumn`(폭 0, 숨김). 없으면 `AddComboColumn`(폭 50, 표시, 데이터 `dtValidYN`=YesOrNo, 가운데 정렬) |
| 표시 변경 | InitSpreadDateColumn:208 | DAY_CODE가 SAT이면 ForeColor Blue, SUN이면 Red |
| 헤더 3단 Span | InitSpreadDateColumn:215~244 | 0행 Large class 라벨, 1행 Small class 라벨, 1~2행 `"SUM"` 헤더 Span |
| 표시 토글 | SetSpreadColumn:350/355 | 태그가 `D_`·`W_`로 시작하면 Visible=true. `M_`·`W_`로 시작하면 Visible=`chkSum.Checked` |
| 날짜 컬럼 삽입 위치 | InitSpread:159 | `spdInfo.GetColumnIndex(DefColumns.MEASURE)` 기준(정확한 산식 **확인 필요**) |

### 5-1. Division별 차이
- 메타 규칙상 모든 division(40, 81, 81_HD, 81_HG, 81_HM, 81_ST, 81_UC, 82, EE, EE_HD, EE_HG, EE_HM, EE_ST, EE_UC)이 **6/0**(필수+기본 6, 선택 0)입니다. 최종 표시도 6으로 같습니다.
- 코드 분기에 division 비교가 없습니다(판단 불가 0건). **division별 Grid 차이는 없습니다.**
- 날짜·합계 컬럼 수는 조회 기간과 SCP0009 결과에 따라 런타임에 정해지므로 정적으로 셀 수 없습니다.

## 6. 확인 필요 항목
1. `dtDayWeek`(LookupCommon)의 lookup 코드값과 바인딩 컨트롤
2. `GetBucketType`(DM0003) 결과를 쓰는 컨트롤. 화면에 BucketType 컨트롤이 없음
3. `cboBucketType_SelectedIndexChanged`, `SetChangedControl`의 호출 경로
4. `W_` 태그가 350·355 두 조건에 모두 해당될 때 최종 Visible 값(두 문장의 실행 순서)
5. `SaveData_Main` 파라미터 두 블록(570~573 / 578~581)의 분기 조건
6. `B_` 판정이 `IndexOf("B_") > 0`(위치 0 제외)인 의도
7. `usrButton1`(부모 없음, Text 없음)의 용도
8. SCM_MST_SHEET_COLUMNS 메타 6행의 정렬 순서(SORT_ORDER_NO), 폭, 정렬 원문
9. 주석 처리됨: `SCP.SCP0019_GET_WORKING_TIME`(456). 현행 아님

=== FILE: source_links.md ===
# SCP0096 소스 링크

기준 경로: `06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0096_Shipment_Working_Day_OSP\`
- CS = `SCP0096_Shipment_Working_Day_OSP.cs`
- DS = `SCP0096_Shipment_Working_Day_OSP.Designer.cs`

## 1. 엔드포인트 호출 지점 (전수 6건 + 주석 1건)
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | `<field:dtDayWeek>` | 49 | `biz:CommonData.CommonDataList` [code=LookupCommon]. Data.Common(LookupCommon) > CallBizCommonData |
| CS | `<field:dtValidYN>` | 51 | `biz:CommonData.YesOrNo`. Data.Common(YesOrNo) > CallBizData |
| CS | GetBucketType | 394 | `DM.DM0003_GET_BUCKET_TYPE_CODE` |
| CS | FindData_Main | 456 | (주석 처리됨) `SCP.SCP0019_GET_WORKING_TIME` |
| CS | FindData_Main | 457 | `SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` |
| CS | SaveData_Main | 608 | `SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` |
| CS | GetSpdTitle | 831 | `SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN` |

## 2. 이벤트 배선
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | .ctor | 103 | this.Load += Form_Load |
| CS | InitEvent | 249 | spdMain.CellDoubleClick += SpdMain_CellDoubleClick |
| CS | InitEvent | 250 | spdMain.TopChange += SpdMain_TopChange |
| CS | InitEvent | 251 | cboDivision.SelectedIndexChanged += CboDivision_SelectedIndexChanged |
| CS | InitEvent | 252 | clbPlantSite.SelectedIndexChanged += ClbPlantSite_SelectedIndexChanged |
| CS | InitEvent | 253 | cboDayWeek.SelectedIndexChanged += CboDayWeek_SelectedIndexChanged |
| CS | InitEvent | 254 | btnInput.Click += BtnInput_Click |
| CS | InitEvent | 255 | this.chkSum.CheckedChanged += chkSum_CheckedChanged |

## 3. Grid 구성
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | CreateSpread | 142 | AddSheet(spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) |
| CS | CreateSpread | 143–144 | GetSheetInfo(spdMain.Name, 0) / ChangeSheet |
| CS | InitSpread | 151 | GetSpdTitle (SCP0009) |
| CS | InitSpread | 155 | InitSheet(SpdSheet.shtMain) |
| CS | InitSpread | 156 | SetSheetHeaderColumn(siMain, 3) |
| CS | InitSpread | 159 | InitSpreadDateColumn(spdInfo, nIdxDataMain) |
| CS | InitSpread | 160 | SetSpreadColumn(siMain) |
| CS | InitSpreadDateColumn | 196 | AddTextColumn(B_ 컬럼, 폭 0, 숨김) |
| CS | InitSpreadDateColumn | 203 | AddComboColumn(폭 50, dtValidYN, Center/Center) |
| CS | InitSpreadDateColumn | 208 | 토/일 ForeColor(SAT Blue, 그 외 Red) |
| CS | InitSpreadDateColumn | 215–244 | ColumnHeaderSpan(Large/Small/"SUM") |
| CS | EditButton | 288 | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) |
| CS | cboBucketType_SelectedIndexChanged | 311, 316 | SetSpreadColumn(siMain) |
| CS | chkSum_CheckedChanged | 330, 335 | SetSpreadColumn(siMain) |
| CS | SetSpreadColumn | 350 | D_/W_ 컬럼 Visible = true |
| CS | SetSpreadColumn | 355 | M_/W_ 컬럼 Visible = chkSum.Checked |
| CS | FindData_Main | 484 | 조회 결과가 1행을 넘으면 SetSpreadColumn |
| DS | InitializeComponent | 628–631 | 헤더 스타일(General 정렬, NoteIndicatorColor Red, Parent ColumnHeaderDefaultEnhanced) |

## 4. 컨트롤 값과 속성
| 파일 | 메서드 | 줄 | 내용 |
|---|---|---:|---|
| CS | DefineProperty | 121 | chkSum.Checked = false |
| CS | SetChangedControl | 417, 425 | GetCheckedListValue |
| CS | FindData_Main | 442, 443 | GetCheckedListValue |
| CS | CboDayWeek_SelectedIndexChanged | 672 | GetCheckedListValue |
| CS | CboDayWeek_SelectedIndexChanged | 675 / 679 | cboInputValue.Enabled = false / true |
| CS | BtnInput_Click | 695, 696 | GetCheckedListValue |
| CS | SaveData_Main | 558–581 | dr["A"], p_division_id, p_plant_site_id, p_measure, p_user_id, p_yyyymmdd, p_shipment_yn, p_is_save_defalut, p_working_time_default |
| CS | SaveData_Main | 600 | row["A"] |
| CS | SaveData_Main | 609 | GetChanges(ROW_ID) |
| CS | GetDayOfWeek | 815, 816 | row.Field("COLUMN_NAME"), dr["DAY_CODE"] |
| DS | InitializeComponent | 346 | chkSum.Visible = false |

=== FILE: web_components.md ===
# SCP0096 웹 컴포넌트 매핑 (React + Wijmo)

## 1. 컨트롤 매핑
| AS-IS 컨트롤 | 유형 | 라벨(원문) | 크기 | TO-BE 후보 |
|---|---|---|---|---|
| cboDivision | UsrCombo | `Division*` (layoutControlItem4) | 181×20 | 단일 선택 ComboBox(필수) |
| clbPlantSite | UsrCheckedList | `Plant Site` (layoutControlItem7) | 165×21 | 다중 선택 MultiSelect |
| dCalendar | UsrDateRangePicker3 | `Period*` (layoutControlItem2) | 210×22 | 기간 DateRange(필수) |
| cboDayWeek | UsrCombo | `Day of the week` (layoutControlItem3) | 134×20 | ComboBox. 데이터원은 확인 필요(dtDayWeek/LookupCommon 후보) |
| cboInputValue | UsrCombo | `Input Value` (layoutControlItem1) | 124×20 | ComboBox. Day of the week 변경 시 Enabled 토글 |
| btnInput | UsrButton | Text `Input` (layoutControlItem10) | 77×21 | 조회조건 영역 Button |
| chkSum | UsrCheckBox | Text `Sum` (layoutSum) | 46×20 | CheckBox. Designer에서 Visible=false, 초기 Checked=false |
| usrButton1 | UsrButton | (Text 없음, 부모 없음) | 75×23 | 확인 필요(미배치 추정 불가) |
| usrConditionPanel1 | UsrConditionPanel | — | 1192×96, Dock Top, HidePanel | 조회조건 패널 |
| usrLayoutControl2 / layoutControlGroup2 | UsrLayoutControl / LayoutControlGroup | — | 1192×96 | 조회조건 레이아웃 그리드 |
| spdMain / spdMain_Sheet1 | FpSpread / SheetView | — | 1192×553, Dock Fill | Wijmo FlexGrid |
| emptySpaceItem1~10 (8개) | EmptySpaceItem | — | — | 간격(레이아웃 전용) |

## 2. 화면 배치
- props.csv에 SplitContainer 관련 값(Orientation, SplitterDistance)이 **없습니다**. 분할 컨테이너는 쓰지 않습니다.
- 상하 배치(Dock 기준):
  - 상단은 `usrConditionPanel1`(Dock Top)이며 높이 96입니다.
  - 하단은 `spdMain`(Dock Fill)이며 높이 553입니다.
  - Designer 크기 기준 비율은 96 : 553 = **약 14.8% : 85.2%**(합계 649)입니다.
- 조회조건 행 구성: LayoutControlItem 높이가 25/26이고 EmptySpaceItem 높이 조합(25·26)으로 보아 2행 배치로 보입니다. 정확한 행·열 좌표(Location)는 묶음에 없어 **확인 필요**입니다.

## 3. 시트별 Grid 컬럼 — `Shipment Working Day OSP`

### 3-1. 메타 컬럼 (SCM_MST_SHEET_COLUMNS, grid_effective 기준)
| COLUMN_NAME | 라벨 | 출처 | 전 division(14종) 표시 |
|---|---|---|---|
| DIVISION_ID | Division | META | 기본 |
| PLANT_SITE_ID | Plant Site ID | META | 기본 |
| PLANT_SITE_NAME | Plant Site | META | 기본 |
| MEASURE | Measure | META | 기본 |
| WORKING_TIME_DEFAULT | Working Time Default | META | 기본 |
| LAST_INPUT_DATE | Last Input Date | META | 기본 |

> 표의 순서는 CSV 순서가 아닌 나열 순서입니다. 실제 SORT_ORDER_NO, 폭, 정렬, 편집 속성은 **확인 필요**입니다(메타 원문 행이 묶음에 없음).

### 3-2. 코드 하드코딩·DB 루프 컬럼 (InitSpreadDateColumn)
| 조건 | API | 헤더 / 필드 | 폭 | 표시 | 편집기 |
|---|---|---|---:|---|---|
| COLUMN_NAME에 `B_` 포함(`IndexOf > 0`) | AddTextColumn | COLUMN_LABEL_NAME / COLUMN_NAME | 0 | 숨김 | Text |
| 그 외 | AddComboColumn | COLUMN_LABEL_NAME / COLUMN_NAME | 50 | 표시 | Combo(YesOrNo, `dtValidYN`), 가로·세로 Center |
| DAY_CODE = SAT | set:ForeColor | — | — | — | 글자색 Blue |
| DAY_CODE = SUN | set:ForeColor | — | — | — | 글자색 Red |

- 헤더는 3단입니다(`SetSheetHeaderColumn(siMain, 3)`, AddSheet 인자 3).
  - 0행: `LARGE_CLASS_LABEL_NAME` Span
  - 1행: `SMALL_CLASS_LABEL_NAME` Span
  - 대분류·소분류 시작 열: `"SUM"` 헤더 Span(1~2행, 높이 20/30)
- 컬럼 태그 접두어별 표시 규칙(SetSpreadColumn):
  - `D_`·`W_`: 항상 표시
  - `M_`·`W_`: `chkSum.Checked`일 때만 표시. W_가 두 조건에 겹치는 경우의 최종 값은 확인 필요
- 헤더 스타일(Designer 628~631): General 정렬, NoteIndicatorColor Red, Parent `ColumnHeaderDefaultEnhanced`

### 3-3. Division별 표시 차이
- 메타와 최종 표시 모두 14개 division에서 **6컬럼으로 같습니다**. 코드에 division 분기가 없습니다.

## 4. 시트 연결 규칙
| 시트 | 연결 규칙 | 설명 |
|---|---|---|
| Shipment Working Day OSP | META+코드연결 | 메타 시트 이름을 코드가 `AddSheet`/`ChangeSheet`/`InitSheet`(142·144·155)로 사용합니다. 메타 6컬럼 뒤에 날짜 컬럼을 DB 루프로 붙입니다(삽입 기준 MEASURE 인덱스) |

- 시트는 1개입니다. 마스터-디테일 같은 시트 간 연결은 없습니다.

=== FILE: oracle_migration.md ===
# SCP0096 Oracle 전환 분석

## 1. 호출 SP 인벤토리
| SP | 호출 키 | 용도(호출 위치) | 참조 테이블 / EXEC 체인 |
|---|---|---|---|
| `DM0003_GET_BUCKET_TYPE_CODE` | DM.DM0003_GET_BUCKET_TYPE_CODE | Form_Load > InitControls > GetBucketType(394) | SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| `SCP0009_GET_SHEET_CALENDAR_3SPAN` | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | GetSpdTitle(831). 3단 날짜 헤더 | SELECT:SCM_SYS_CALENDAR_M |
| `SCP0096_GET_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | FindData_Main(457). 조회 | INSERT:#TBLDYNAMICPIVOT_SCP0096, SELECT:SCP_MST_SHIPMENT_WORKING_DAY_OSP, SCM_MST_SITE, SCM_SYS_CALENDAR_M, SCM_MST_LINE_OSP, SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, REF:STRING_SPLIT, DYNAMIC SQL |
| `SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP` | SCP.SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | SaveData_Main(608). 저장 | MERGE:SCP_MST_SHIPMENT_WORKING_DAY_OSP, MERGE:SCP_MST_SHIPMENT_WORKING_DAY_DEFAULT, EXEC:PR_SCM_SYS_LOG_BATCH > INSERT:SCM_SYS_LOG_BATCH |

### 1-1. 저장 SP 파라미터 (SaveData_Main에서 구성한 DataRow 컬럼)
`p_division_id`, `p_plant_site_id`, `p_measure`, `p_user_id`, `p_yyyymmdd`, `p_shipment_yn`, `p_is_save_defalut`(원문 철자), `p_working_time_default`

- 행 상태 키는 `A`(558, 600)이고, 변경 행 추출은 `GetChanges(ROW_ID)`(609)입니다.
- `p_yyyymmdd`~`p_working_time_default`는 570~573과 578~581 두 블록에서 따로 설정됩니다. 분기 조건은 **확인 필요**입니다.

## 2. 공통코드 분기
| 호출 | code | 테이블 |
|---|---|---|
| `biz:CommonData.CommonDataList` | LookupCommon | UP_FX_GetCommonDataList → SCM_ADM_LOOKUP_MASTER, SCM_ADM_LOOKUP_MASTER_DETAIL (lookup 코드값은 **확인 필요**) |
| `biz:CommonData.YesOrNo` | YesOrNo | 묶음에 참조 테이블 없음(**확인 필요**) |
| `DM0003_GET_BUCKET_TYPE_CODE` | — | SCM_ADM_LOOKUP_MASTER_DETAIL |

## 3. FoxQuery 미등록·직접 호출 SP
- 활성 엔드포인트 4개 SP는 모두 **MATCH**(FoxQuery 등록 확인)입니다. 미등록이나 직접 호출은 없습니다.
- `PR_SCM_SYS_LOG_BATCH`는 화면이 직접 부르지 않습니다. SAVE SP 내부의 EXEC 체인으로만 호출됩니다.
- 주석 처리됨: `SCP.SCP0019_GET_WORKING_TIME`(456). 전환 대상이 아닙니다.

## 4. Oracle 전환 시 확인 포인트 (추출 사실 기반)
| # | 대상 SP | 사실 | 전환 포인트 |
|---|---|---|---|
| 1 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `REF:STRING_SPLIT` | MSSQL 전용 함수(금지 키워드 ⑩)입니다. Oracle 분할 방식으로 바꿔야 합니다. 구분자와 입력 파라미터(Plant Site 다중값 추정)는 원문 확인 필요 |
| 2 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `INSERT:#TBLDYNAMICPIVOT_SCP0096` | 로컬 임시 테이블입니다. GTT를 쓴다면 호출 시작 시 비우는 처리가 필요합니다(세션 상태 잔존 방지) |
| 3 | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | `DYNAMIC@...` | 동적 SQL 피벗입니다. 컬럼 이름 규칙(D_/W_/M_/B_ 접두어, 날짜 기반)이 FE 헤더(SCP0009 결과 COLUMN_NAME)와 같아야 합니다 |
| 4 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | MERGE 2건 | MSSQL MERGE 문법(세미콜론, OUTPUT 등)을 Oracle MERGE로 바꿔야 합니다. 원문 확인 필요 |
| 5 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | EXEC:PR_SCM_SYS_LOG_BATCH | 로그 프로시저의 Oracle 대응 객체가 있는지 확인해야 합니다 |
| 6 | SCP0009_GET_SHEET_CALENDAR_3SPAN | SCM_SYS_CALENDAR_M | 3단 헤더 결과 컬럼(COLUMN_NAME, COLUMN_LABEL_NAME, DAY_CODE, LARGE/SMALL_CLASS_LABEL_NAME)의 이름과 순서를 유지해야 합니다(GetSpdTitle·InitSpreadDateColumn 소비). 다른 화면(SCP0009)과 함께 쓰는 SP인지 확인해야 합니다 |
| 7 | DM0003_GET_BUCKET_TYPE_CODE | SCM_ADM_LOOKUP_MASTER_DETAIL | DM 도메인 공용 SP 여부를 확인해야 합니다. 이 화면에서 쓰는 소비 컨트롤이 확인 필요입니다 |

### 4-1. 난이도 근거
- 높은 쪽 요인(GET SP): 임시 테이블, 동적 SQL, STRING_SPLIT 세 가지가 함께 있고, 참조 테이블이 5개입니다.
- 보통 요인(SAVE SP): MERGE 2건과 로그 EXEC 체인이 있습니다.
- 낮은 쪽 요인(DM0003, SCP0009): 단일 SELECT 1테이블입니다.
- SP 본문 줄 수와 실행 결과는 묶음에 없습니다. 정량 난이도는 **미측정**입니다.

=== FILE: tobe_design.md ===
# SCP0096 TO-BE 설계 입력

## 1. 조회조건
| 순서(배치 원문 미확인) | 라벨 | AS-IS 컨트롤 | 필수 | 비고 |
|---|---|---|---|---|
| — | Division* | cboDivision (UsrCombo) | 예(라벨 `*`) | 변경 이벤트 `CboDivision_SelectedIndexChanged`(동작 확인 필요) |
| — | Plant Site | clbPlantSite (UsrCheckedList) | 확인 필요 | 다중 선택. `GetCheckedListValue`(CODE)로 값 추출(FindData_Main 442/443) |
| — | Period* | dCalendar (UsrDateRangePicker3) | 예(라벨 `*`) | 기간 |
| — | Day of the week | cboDayWeek (UsrCombo) | 확인 필요 | 변경 시 `cboInputValue.Enabled` 토글 |
| — | Input Value | cboInputValue (UsrCombo) | 확인 필요 | Input 버튼으로 일괄 입력할 값(추정 금지, 동작 확인 필요) |
| — | (버튼) Input | btnInput | — | `BtnInput_Click` |
| — | (체크) Sum | chkSum | — | Designer Visible=false, Checked=false. 합계(M_/W_) 컬럼 표시 토글 |

## 2. 액션별 API 후보
| 액션 | AS-IS 경로 | 호출 SP | TO-BE API 후보 |
|---|---|---|---|
| 화면 진입 | Form_Load > InitControls > GetBucketType | DM0003_GET_BUCKET_TYPE_CODE | 공통 코드 조회 API(소비처 확인 필요) |
| 화면 진입 / 조회 헤더 | CreateSpread·FindData_Main > InitSpread > GetSpdTitle | SCP0009_GET_SHEET_CALENDAR_3SPAN | 기간별 3단 헤더 조회 API |
| 조회(FindButton) | FindData_Main | SCP0096_GET_SHIPMENT_WORKING_DAY_OSP | 조회 API(Division, Plant Site 다중, Period) |
| 저장(SaveButton) | SaveData_Main → FindData_Main 재조회 | SCP0096_SAVE_SHIPMENT_WORKING_DAY_OSP | 저장 API(변경 행 일괄) → 저장 후 재조회 |
| Input 버튼 | BtnInput_Click | 없음(클라이언트) | 그리드 일괄 값 입력(서버 호출 없음) |
| Sum 체크 | chkSum_CheckedChanged > SetSpreadColumn | 없음 | 컬럼 표시 토글 |
| Day of the week 변경 | CboDayWeek_SelectedIndexChanged | 없음 | Input Value 활성/비활성 |
| 셀 더블클릭 / 스크롤 | SpdMain_CellDoubleClick / SpdMain_TopChange | 묶음상 호출 없음 | 동작 확인 필요 |
| 공통코드 | dtDayWeek / dtValidYN | CommonDataList(LookupCommon) / YesOrNo | 공통 코드 API. YesOrNo는 날짜 셀 콤보 데이터 |

> 주석 처리됨: `SCP.SCP0019_GET_WORKING_TIME`(456). API 후보에서 뺐습니다.

## 3. Division별 Grid 변형 요약
- 시트 `Shipment Working Day OSP` 1개입니다. 14개 division 모두 메타 6컬럼(Division, Plant Site ID, Plant Site, Measure, Working Time Default, Last Input Date)이 같습니다.
- 날짜 컬럼은 division이 아니라 **Period와 SCP0009 결과**에 따라 바뀝니다.
  - Y/N 콤보(폭 50, 가운데 정렬)
  - 토요일 파랑, 일요일 빨강
  - `B_` 컬럼은 숨김
  - 3단 헤더와 SUM 헤더
  - `M_` 합계 컬럼은 Sum 체크에 연동

## 4. 권한(C/R/U/D) 관련 사실
- `TB_FX_GroupMenuAuth`에 이 화면 행이 **4건** 있고, `TB_FX_MenuItemInfo`와 `TB_FX_ProgramInfo`에 각 1건, `TB_FX_Favorite`에 1건이 있습니다. 권한 컬럼 값(그룹별 C/R/U/D)은 묶음에 없어 **확인 필요**입니다.
- 코드상 액션: 조회(FindButton), 저장(SaveButton), `EditButton`(288, GetSheetInfo 호출)이 확인됩니다. 삭제나 신규 행 버튼 코드는 묶음에 없습니다.
- 저장 시 `p_user_id`가 전달되고, SAVE SP에서 `PR_SCM_SYS_LOG_BATCH`로 로그를 남깁니다.

## 5. 미확정 사항
1. 조회조건 배치 순서와 행·열 좌표(Designer Location 미추출)
2. `cboDayWeek`, `cboInputValue`의 데이터원과 `BtnInput_Click` 일괄 입력 규칙
3. `GetBucketType`(DM0003) 결과의 사용처. BucketType 컨트롤 부재, `cboBucketType_SelectedIndexChanged` 미배선
4. `SpdMain_CellDoubleClick`, `SpdMain_TopChange`, `CboDivision_SelectedIndexChanged`, `ClbPlantSite_SelectedIndexChanged` 내부 동작
5. `W_` 컬럼 최종 Visible(350과 355가 겹침)과 `chkSum`이 Designer에서 숨김인 상태의 실사용 여부
6. 저장 파라미터 두 블록(570~573 / 578~581)의 분기와 `p_is_save_defalut`(DEFAULT 테이블 MERGE 여부) 조건
7. 메타 6컬럼의 정렬 순서, 폭, 편집 가능 여부(SCM_MST_SHEET_COLUMNS 원문)
8. 그룹별 메뉴 권한 4행의 C/R/U/D 값
