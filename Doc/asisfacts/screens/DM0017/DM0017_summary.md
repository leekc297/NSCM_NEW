# DM0017 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.DM.Shipment.UIL\DM0017_ShipmentRequest.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 482 |
| only | 06.UIL\GSCM.DM.Shipment.UIL\DM0017_ShipmentRequest.Designer.cs | 06.UIL\GSCM.DM.Shipment.UIL\GSCM.DM.Shipment.UIL.csproj | 1186 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread > GetSpdTitle | 251 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| button:FindButton | FindButton > FindData | 312 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| button:SaveButton | SaveButton > SaveData > FindData > InitSpread > GetSpdTitle | 251 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| button:SaveButton | SaveButton > SaveData > FindData | 312 | DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 251 | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY |  |
| event:this.Load | Form_Load > InitControls > GetDivision | 446 | SCM.SCM0001_GET_DIVISION | MATCH | SP SCM0001_GET_DIVISION |
| event:this.Load | Form_Load > InitControls > GetScmSitebyDivision | 460 | SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | SP SCM0001_GET_SITE_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetBucketType | 474 | DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | SP DM0003_GET_BUCKET_TYPE_CODE |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 163 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| DM.DM0003_GET_BUCKET_TYPE_CODE | MATCH | 1 | SP DM0003_GET_BUCKET_TYPE_CODE | EXEC:DM0003_GET_BUCKET_TYPE_CODE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY | 1 |  |  | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, EXEC:SP_EXECUTESQL, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE |
| DM.DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | MATCH | 1 | SP DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA | EXEC:DMF0006_GET_CUSTOMER_MODEL_MAPPING_DATA, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, REF:FN_GET_DEPT_LIST, SELECT:DM_MST_CUSTOMER_MODEL, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, REF:STRING_SPLIT, SELECT:DM_MST_ITEM_SINGLE_V, SELECT:SCM_MST_PROJECT, REF:UF_FX_STRING_SPLITFORIN, REF:UF_FX_STRING_SPLIT, SELECT:TB_FX_USER, SELECT:SPLIT |  |
| SCM.SCM0001_GET_DIVISION | MATCH | 1 | SP SCM0001_GET_DIVISION | EXEC:SCM0001_GET_DIVISION, SELECT:SCM_MST_DIVISION |  |
| SCM.SCM0001_GET_SITE_BY_DIVISION | MATCH | 1 | SP SCM0001_GET_SITE_BY_DIVISION | EXEC:SCM0001_GET_SITE_BY_DIVISION, SELECT:SCM_MST_SITE, REF:VALUE, REF:NODES |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| InitSpread | dr | COLUMN_NAME, COLUMN_LABEL, SMALL_LABEL_NAME |
| SaveData | dr | A, RegtUserID |
| SaveData | saveDS.Tables[0].Rows[i] | A |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetSpdTitle | InitSpread:216 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |
| SaveData | SaveButton:290 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:395 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:110 |

## 6. 컨트롤 (45개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 16 | lblDivision, Period, lblSalesSite, layoutControlItem9, layoutControlItem3, layoutControlItem1, layoutControlItem2, layoutControlItem4, layoutControlItem6, layoutControlItem7, layoutControlItem8, lblBucket, lblBucket1, layoutControlItem10, lblSalesSite1 … |
| UsrMultiLineEditor | 5 | umltModel, umltProject, usrMultiLineEditor1, usrMultiLineEditor3, usrMultiLineEditor4 |
| EmptySpaceItem | 5 | emptySpaceItem2, emptySpaceItem1, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5 |
| UsrCombo | 4 | usrCombo2, cboBucketType, usrCombo1, usrCombo3 |
| UsrButton | 4 | usrButton2, usrButton1, usrButton3, btnProject |
| UsrCheckedList | 3 | clbDivision, clbSalesSite, usrCheckedList1 |
| UsrLayoutControl | 2 | usrLayoutControl1, usrLayoutControl2 |
| LayoutControlGroup | 2 | layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrDateRangePicker | 1 | drpPeriod |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

## 7. 확인 필요 (1건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 251 | GetSpdTitle | DM.DM0007_GET_SPREAD_TITLE | NOT_IN_FOXQUERY | DB 객체 존재(P) → FoxQuery 없이 직접 호출: SELECT:TB_FX_USER, SELECT:SCM_SYS_CALENDAR_M, REF:FN_MULTY_TIME, EXEC:SP_EXECUTESQL, REF:FN_WEEKOFDAY_DATE, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:CTE_DATE · SP 직접호출 또는 미등록 — DB 단계에서 확인 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 447 | DM.Get_Division | commented:NOT_IN_FOXQUERY |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: DB루프(코드) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Shipment Request

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread0 |  | 156 | 하드코딩 | AddTextColumn | Plan Week | PLAN_WEEK |  |
| InitSpread0 |  | 157 | 하드코딩 | AddTextColumn | Division | DIVISION_ID |  |
| InitSpread |  | 172 | 하드코딩 | AddTextColumn | Division | Column1 |  |
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | Biz. Type | Column2 |  |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | Project | Column3 |  |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | Model | 4 |  |
| InitSpread |  | 176 | 하드코딩 | AddTextColumn | Nick Name | 5 |  |
| InitSpread |  | 177 | 하드코딩 | AddTextColumn | Sales Site | 6 |  |
| InitSpread |  | 178 | 하드코딩 | AddTextColumn | Sold to Party | 7 |  |
| InitSpread |  | 179 | 하드코딩 | AddTextColumn | Ship to Party | 8 |  |
| InitSpread |  | 180 | 하드코딩 | AddTextColumn | Ship. Type | 9 |  |
| InitSpread |  | 181 | 하드코딩 | AddTextColumn | Do/Ex | 10 |  |
| InitSpread |  | 182 | 하드코딩 | AddTextColumn | Prod. Site | 11 |  |
| InitSpread |  | 183 | 하드코딩 | AddTextColumn | Trans. Mode | 12 |  |
| InitSpread |  | 184 | 하드코딩 | AddTextColumn | L/T(Day) | 13 |  |
| InitSpread |  | 185 | 하드코딩 | AddTextColumn | BOH | 14 |  |
| InitSpread |  | 186 | 하드코딩 | AddTextColumn | Measure | 15 |  |
| InitSpread |  | 231 | DB루프 | AddComboColumn | {?string.Empty} \|\| {?dr["COLUMN_LABEL"]} | {?string.Empty} \|\| {?dr["COLUMN_NAME"]} | foreach(dr in dtTitle.Rows) |
| InitializeComponent |  | 1055 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 1056 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 1057 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 1058 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Shipment Request | 코드 하드코딩 전용(메타 없음) | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 | 17 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
