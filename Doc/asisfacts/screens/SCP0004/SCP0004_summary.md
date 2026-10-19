# SCP0004 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0004_SetupMatrix\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0004_SetupMatrix\SCP0004_SetupMatrix.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0004_SetupMatrix\SCP0004_SetupMatrix.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0004_SetupMatrix\SCP0004_SetupMatrix.csproj | 357 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0004_SetupMatrix\SCP0004_SetupMatrix.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0004_SetupMatrix\SCP0004_SetupMatrix.csproj | 604 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetCheckedListControl | 266 | biz:CommonData.CommonDataList [code=Auth_Plant] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetCheckedListControl | 271 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetCheckedListControl | 276 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetCheckedListControl | 281 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetCheckedListControl | 286 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:cboDivision.SelectedIndexChanged | ClbDivision_SelectedIndexChanged > SetCheckedListControl | 291 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetCheckedListControl | 266 | biz:CommonData.CommonDataList [code=Auth_Plant] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetCheckedListControl | 271 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetCheckedListControl | 276 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetCheckedListControl | 281 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetCheckedListControl | 286 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:clbOperation.SelectedIndexChanged | ClbOperation_SelectedIndexChanged > SetCheckedListControl | 291 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetCheckedListControl | 266 | biz:CommonData.CommonDataList [code=Auth_Plant] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetCheckedListControl | 271 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetCheckedListControl | 276 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetCheckedListControl | 281 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetCheckedListControl | 286 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:clbPlant.SelectedIndexChanged | ClbPlant_SelectedIndexChanged > SetCheckedListControl | 291 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 213 | SCP.SCP0004_GET_SETUP_MATRIX | MATCH | SP SCP0004_GET_SETUP_MATRIX |
| event:this.Load | Form_Load > InitControls > SetCheckedListControl | 266 | biz:CommonData.CommonDataList [code=Auth_Plant] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCheckedListControl | 271 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCheckedListControl | 276 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCheckedListControl | 281 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCheckedListControl | 286 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > SetCheckedListControl | 291 | biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Auth_Plant] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SETUP_MATRIX_SN |
| biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SETUP_MATRIX_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SETUP_MATRIX_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SETUP_MATRIX_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| SCP.SCP0004_GET_SETUP_MATRIX | MATCH | 1 | SP SCP0004_GET_SETUP_MATRIX | EXEC:SCP0004_GET_SETUP_MATRIX | ⚠ DB에 SP 없음 |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SetCheckedListControl | UserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | FindData:196, FindData:197, FindData:198, FindData:199, FindData:200, FindData:201, FindData:202, SetCheckedListControl:254 | CString.GetCheckedListValue | CODE |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:88 |
| cboDivision | SelectedIndexChanged | ClbDivision_SelectedIndexChanged | InitControls:120 |
| clbPlant | SelectedIndexChanged | ClbPlant_SelectedIndexChanged | InitControls:121 |
| clbOperation | SelectedIndexChanged | ClbOperation_SelectedIndexChanged | InitControls:122 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 7 | layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7, Division |
| UsrCheckedList | 6 | clbSetupCondition, clbToSetupGroup, clbFromSetupGroup, clbCategory, clbOperation, clbPlant |
| EmptySpaceItem | 3 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrCombo | 1 | cboDivision |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 4 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Setup Matrix

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 141 | 하드코딩 | AddTextColumn | Division | DIVISION_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 142 | 하드코딩 | AddTextColumn | Division Name | DIVISION_NAME | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 143 | 하드코딩 | AddTextColumn | Plant | PLANT_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 144 | 하드코딩 | AddTextColumn | Plant Name | PLANT_NAME | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 145 | 하드코딩 | AddTextColumn | Operation | OPERATION_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 146 | 하드코딩 | AddTextColumn | Operation Name | OPERATION_NAME | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 147 | 하드코딩 | AddTextColumn | Setup Group | LINE_SETUP_GROUP_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 148 | 하드코딩 | AddTextColumn | Category | SETUP_CATEGORY_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 149 | 하드코딩 | AddTextColumn | Class | CLASS | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | From Setup Group | FROM_ITEM_SETUP_GROUP_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 151 | 하드코딩 | AddTextColumn | To Setup Group | TO_ITEM_SETUP_GROUP_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 152 | 하드코딩 | AddTextColumn | Setup Condition | SETUP_CONDITION_ID | if(spreadInfo.SheetName == "Setup Matrix") |
| InitSpread |  | 153 | 하드코딩 | AddNumColumn | Setup Time | SETUP_TIME | if(spreadInfo.SheetName == "Setup Matrix") |
| InitializeComponent |  | 473 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 474 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 475 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 476 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Setup Matrix | 코드 하드코딩 전용(메타 없음) | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 | 13 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
