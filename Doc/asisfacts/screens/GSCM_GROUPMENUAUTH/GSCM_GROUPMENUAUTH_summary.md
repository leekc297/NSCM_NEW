# GSCM_GROUPMENUAUTH 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SystemMgmt.UIL\GroupMenuAuth.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 911 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\GroupMenuAuth.Designer.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 240 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 264 | SystemManager.UP_FX_GetGroupInfoList | MATCH | SP UP_FX_GetGroupInfoList |
| button:FindButton | FindButton > FindData | 296 | SystemManager.UP_FX_GetGroupMenuAuthList | MATCH | SP UP_FX_GetGroupMenuAuthList |
| button:SaveButton | SaveButton > SaveData > FindData | 264 | SystemManager.UP_FX_GetGroupInfoList | MATCH | SP UP_FX_GetGroupInfoList |
| button:SaveButton | SaveButton > SaveData > FindData | 296 | SystemManager.UP_FX_GetGroupMenuAuthList | MATCH | SP UP_FX_GetGroupMenuAuthList |
| event:this.Load | Form_Load > FindData | 264 | SystemManager.UP_FX_GetGroupInfoList | MATCH | SP UP_FX_GetGroupInfoList |
| event:this.Load | Form_Load > FindData | 296 | SystemManager.UP_FX_GetGroupMenuAuthList | MATCH | SP UP_FX_GetGroupMenuAuthList |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindSub > FindData | 264 | SystemManager.UP_FX_GetGroupInfoList | MATCH | SP UP_FX_GetGroupInfoList |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindSub > FindData | 296 | SystemManager.UP_FX_GetGroupMenuAuthList | MATCH | SP UP_FX_GetGroupMenuAuthList |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 58 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindDataList | 357 | SystemManager.UP_FX_GetGroupMenuAuthList | MATCH | SP UP_FX_GetGroupMenuAuthList |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SystemManager.UP_FX_GetGroupInfoList | MATCH | 1 | SP UP_FX_GetGroupInfoList | EXEC:UP_FX_GETGROUPINFOLIST, SELECT:TB_FX_GROUPINFO |  |
| SystemManager.UP_FX_GetGroupMenuAuthList | MATCH | 2 | SP UP_FX_GetGroupMenuAuthList | EXEC:UP_FX_GETGROUPMENUAUTHLIST, SELECT:TB_FX_MENUITEMINFO, SELECT:TB_FX_PROGRAMINFO, SELECT:TB_FX_GROUPMENUAUTH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ConvertHelpFile | row | shortname, update_time |
| GetUserGroup | UserInfoContext.Current | NowGroupID |
| OpenFileUplad | Filter | USER_ID |
| SaveData | dr | A, RegtUserID |
| SaveData | row | A |
| SetHelpFileList | dictParam | USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:245 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| OnShown | OnShown:334 | BaseForm.OnShown | NowGroupID, USER_ID |
| GetChanges | SaveData:451 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:103 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:104 |
| this.spdSub | CellClick | SpdSub_CellClick | .ctor:105 |

## 6. 컨트롤 (8개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| SplitContainer | 1 | splitContainer1 |

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
- 코드에서 생성하는 시트: GroupInfo, MenuItemInfo

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 149 | 하드코딩 | AddTextColumn | GroupID | GroupID | if(spread.SheetName == "GroupInfo") |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | GrpName | GrpName | if(spread.SheetName == "GroupInfo") |
| InitSpread |  | 151 | 하드코딩 | AddComboColumn | UseYN | UseYN | if(spread.SheetName == "GroupInfo") |
| InitSpread |  | 163 | 하드코딩 | AddTextColumn | GroupID | GroupID | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 164 | 하드코딩 | AddTextColumn | Level1Title* | Level1Title | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 165 | 하드코딩 | AddTextColumn | Level2Title* | Level2Title | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 166 | 하드코딩 | AddTextColumn | Level1MenuID | Level1MenuID | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 167 | 하드코딩 | AddTextColumn | Level2MenuID | PrntMenuID | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 168 | 하드코딩 | AddTextColumn | Level3MenuID* | MenuID | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 169 | 하드코딩 | AddTextColumn | Title* | Title | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 170 | 하드코딩 | AddCheckColumn | BasicACLC | BasicACLC | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 171 | 하드코딩 | AddCheckColumn | Read* | BasicACLR | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 172 | 하드코딩 | AddCheckColumn | Modify* | BasicACLU | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 173 | 하드코딩 | AddCheckColumn | BasicACLD | BasicACLD | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | ExtendedACL | ExtendedACL | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 175 | 하드코딩 | AddComboColumn | UseYN | UseYN | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 184 | 하드코딩 | AddTextColumn | YN | HELP_YN | if(spread.SheetName == "MenuItemInfo") ⟫ if(CheckAuthManual() && CheckAuthMenuGroup()) |
| InitSpread |  | 185 | 하드코딩 | AddButtonColumn | Open | HELP_OPEN | if(spread.SheetName == "MenuItemInfo") ⟫ if(CheckAuthManual() && CheckAuthMenuGroup()) |
| InitSpread |  | 186 | 하드코딩 | AddButtonColumn | File | HELP_UPLOAD | if(spread.SheetName == "MenuItemInfo") ⟫ if(CheckAuthManual() && CheckAuthMenuGroup()) |
| InitSpread |  | 187 | 하드코딩 | AddTextColumn | Last Update | Last Update | if(spread.SheetName == "MenuItemInfo") ⟫ if(CheckAuthManual() && CheckAuthMenuGroup()) |
| InitSpread |  | 199 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | BasicACLR | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 200 | 표시/라벨 변경 | set:Value | Value = {?false} | BasicACLR | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 201 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | BasicACLR | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 203 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | BasicACLU | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 204 | 표시/라벨 변경 | set:Value | Value = {?false} | BasicACLU | if(spread.SheetName == "MenuItemInfo") |
| InitSpread |  | 205 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | BasicACLU | if(spread.SheetName == "MenuItemInfo") |
| InitializeComponent |  | 125 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 126 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 127 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 128 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 176 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 177 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 178 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 179 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| GroupInfo | 코드 하드코딩 전용(메타 없음) | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 | 3 |
| MenuItemInfo | 코드 하드코딩 전용(메타 없음) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) | 17 (?4) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 56 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 56건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
