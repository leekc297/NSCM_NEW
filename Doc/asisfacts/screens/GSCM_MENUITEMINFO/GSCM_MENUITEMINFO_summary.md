# GSCM_MENUITEMINFO 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SystemMgmt.UIL\MenuItemInfo.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 669 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\MenuItemInfo.Designer.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 383 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 315 | SystemManager.UP_FX_GetMenuItemInfoList | MATCH | SP UP_FX_GetMenuItemInfoList |
| button:SaveButton | SaveButton > SaveData > FindData | 315 | SystemManager.UP_FX_GetMenuItemInfoList | MATCH | SP UP_FX_GetMenuItemInfoList |
| event:this.Load | Form_Load > FindData | 315 | SystemManager.UP_FX_GetMenuItemInfoList | MATCH | SP UP_FX_GetMenuItemInfoList |
| event:this.spdLevel1.CellDoubleClick | SpdLevel1_CellDoubleClick > FindData | 315 | SystemManager.UP_FX_GetMenuItemInfoList | MATCH | SP UP_FX_GetMenuItemInfoList |
| event:this.spdLevel2.CellDoubleClick | SpdLevel2_CellDoubleClick > FindData | 315 | SystemManager.UP_FX_GetMenuItemInfoList | MATCH | SP UP_FX_GetMenuItemInfoList |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 46 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SystemManager.UP_FX_GetMenuItemInfoList | MATCH | 1 | SP UP_FX_GetMenuItemInfoList | EXEC:UP_FX_GETMENUITEMINFOLIST, SELECT:TB_FX_MENUITEMINFO, SELECT:TB_FX_PROGRAMINFO |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindData | dr | Level1MenuID |
| InsertRow | a | SortOrder |
| SaveData | dr | A, RegtUserID |
| SaveData | row | A |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:277 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:463 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:93 |
| this.spdLevel1 | CellDoubleClick | SpdLevel1_CellDoubleClick | .ctor:95 |
| this.spdLevel2 | CellDoubleClick | SpdLevel2_CellDoubleClick | .ctor:96 |
| this.spdLevel2 | CellClick | SpdLevel2_CellClick | .ctor:97 |
| this.spdLevel3 | CellClick | SpdLevel3_CellClick | .ctor:98 |

## 6. 컨트롤 (14개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| FpSpread | 3 | spdLevel1, spdLevel2, spdLevel3 |
| SheetView | 3 | spdLevel1_Sheet1, spdLevel2_Sheet1, spdLevel3_Sheet1 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrPanel |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrTextBox | 1 | txtSearch |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| LayoutControlItem | 1 | layoutControlItem1 |
| EmptySpaceItem | 1 | emptySpaceItem2 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Level1, Level2, Level3

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 148 | 하드코딩 | AddTextColumn | Level1MenuID* | MenuID | if(level == 1) |
| InitSpread |  | 149 | 하드코딩 | AddTextColumn | PrntMenuID | PrntMenuID | if(level == 1) |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | Title* | Title | if(level == 1) |
| InitSpread |  | 151 | 하드코딩 | AddTextColumn | Group Title* | Description | if(level == 1) |
| InitSpread |  | 152 | 하드코딩 | AddTextColumn | ProgramID | ProgramID | if(level == 1) |
| InitSpread |  | 153 | 하드코딩 | AddTextColumn | Parameter | Parameter | if(level == 1) |
| InitSpread |  | 154 | 하드코딩 | AddNumColumn | SortOrder* | SortOrder | if(level == 1) |
| InitSpread |  | 155 | 하드코딩 | AddNumColumn | MenuLevel | MenuLevel | if(level == 1) |
| InitSpread |  | 156 | 하드코딩 | AddNumColumn | MenuAction | MenuAction | if(level == 1) |
| InitSpread |  | 157 | 하드코딩 | AddTextColumn | IconName | IConName | if(level == 1) |
| InitSpread |  | 158 | 하드코딩 | AddComboColumn | UseYN* | UseYN | if(level == 1) |
| InitSpread |  | 171 | 하드코딩 | AddTextColumn | Level1MenuID | PrntMenuID | if(level == 2) |
| InitSpread |  | 172 | 하드코딩 | AddTextColumn | Level2MenuID* | MenuID | if(level == 2) |
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | Title* | Title | if(level == 2) |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | Group Title | Description | if(level == 2) |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | ProgramID | ProgramID | if(level == 2) |
| InitSpread |  | 176 | 하드코딩 | AddTextColumn | Parameter | Parameter | if(level == 2) |
| InitSpread |  | 177 | 하드코딩 | AddNumColumn | SortOrder* | SortOrder | if(level == 2) |
| InitSpread |  | 178 | 하드코딩 | AddNumColumn | MenuLevel | MenuLevel | if(level == 2) |
| InitSpread |  | 179 | 하드코딩 | AddNumColumn | MenuAction | MenuAction | if(level == 2) |
| InitSpread |  | 180 | 하드코딩 | AddTextColumn | IconName | IConName | if(level == 2) |
| InitSpread |  | 181 | 하드코딩 | AddButtonColumn | File | File | if(level == 2) |
| InitSpread |  | 182 | 하드코딩 | AddComboColumn | UseYN* | UseYN | if(level == 2) |
| InitSpread |  | 199 | 하드코딩 | AddTextColumn | Level1MenuID | Level1MenuID | if(level == 3) |
| InitSpread |  | 200 | 하드코딩 | AddTextColumn | Level2MenuID | PrntMenuID | if(level == 3) |
| InitSpread |  | 201 | 하드코딩 | AddTextColumn | Level3MenuID* | MenuID | if(level == 3) |
| InitSpread |  | 202 | 하드코딩 | AddTextColumn | Title* | Title | if(level == 3) |
| InitSpread |  | 203 | 하드코딩 | AddTextColumn | Group Title* | Description | if(level == 3) |
| InitSpread |  | 204 | 하드코딩 | AddTextColumn | ProgramID* | ProgramID | if(level == 3) |
| InitSpread |  | 205 | 하드코딩 | AddTextColumn | ProgramName* | ProgramName | if(level == 3) |
| InitSpread |  | 206 | 하드코딩 | AddButtonColumn | Search* | ProgramPopup | if(level == 3) |
| InitSpread |  | 207 | 하드코딩 | AddTextColumn | Parameter | Parameter | if(level == 3) |
| InitSpread |  | 208 | 하드코딩 | AddNumColumn | SortOrder* | SortOrder | if(level == 3) |
| InitSpread |  | 209 | 하드코딩 | AddNumColumn | MenuLevel | MenuLevel | if(level == 3) |
| InitSpread |  | 210 | 하드코딩 | AddNumColumn | MenuAction | MenuAction | if(level == 3) |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | IconName | IConName | if(level == 3) |
| InitSpread |  | 212 | 하드코딩 | AddButtonColumn | File | File | if(level == 3) |
| InitSpread |  | 213 | 하드코딩 | AddComboColumn | UseYN* | UseYN | if(level == 3) |
| InitializeComponent |  | 214 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 215 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 216 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 217 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 261 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 262 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 263 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 264 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 308 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 309 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 310 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 311 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Level1 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |
| Level2 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |
| Level3 | 코드 하드코딩 전용(메타 없음) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) | 15 (?15) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 1596 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 1596건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
