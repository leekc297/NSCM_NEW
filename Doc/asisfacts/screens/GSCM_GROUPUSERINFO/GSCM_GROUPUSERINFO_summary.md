# GSCM_GROUPUSERINFO 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SystemMgmt.UIL\GroupUserInfo.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 1134 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\GroupUserInfo.Designer.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 410 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData > InitSpread | 176 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData | 317 | SystemManager.UP_FX_GetGroupInfoList | MATCH | SP UP_FX_GetGroupInfoList |
| button:SaveButton | SaveButton > SaveData > FindData_Customer > InitSpread | 176 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData > FindData_User | 355 | SystemManager.UP_FX_GetUserGroupInfoList | MATCH | SP UP_FX_GetUserGroupInfoList |
| button:SaveButton | SaveButton > SaveData > FindData_Division | 388 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| button:SaveButton | SaveButton > SaveData > FindData_Customer | 465 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| event:this.Load | Form_Load > FindData > InitSpread | 176 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 317 | SystemManager.UP_FX_GetGroupInfoList | MATCH | SP UP_FX_GetGroupInfoList |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > InitSpread | 176 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_User | 355 | SystemManager.UP_FX_GetUserGroupInfoList | MATCH | SP UP_FX_GetUserGroupInfoList |
| event:this.spdUserInfo.CellDoubleClick | SpdUserInfo_CellDoubleClick > FindData_Division > InitSpread | 176 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdUserInfo.CellDoubleClick | SpdUserInfo_CellDoubleClick > FindData_Division | 388 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 52 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | FindData_Plant | 431 | SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | SP UP_FX_GetUserGroupAuthExtentionList |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SystemManager.UP_FX_GetGroupInfoList | MATCH | 1 | SP UP_FX_GetGroupInfoList | EXEC:UP_FX_GETGROUPINFOLIST, SELECT:TB_FX_GROUPINFO |  |
| SystemManager.UP_FX_GetUserGroupAuthExtentionList | MATCH | 3 | SP UP_FX_GetUserGroupAuthExtentionList | EXEC:UP_FX_GETUSERGROUPAUTHEXTENTIONLIST, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USERGROUPAUTHEXTENTION, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:SCM_MST_SITE |  |
| SystemManager.UP_FX_GetUserGroupInfoList | MATCH | 1 | SP UP_FX_GetUserGroupInfoList | EXEC:UP_FX_GETUSERGROUPINFOLIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_USER |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SaveData | dr | A, RegtUserID, AuthType, PrntCode |
| SaveData | row | A |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:299 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:538, SaveData:607, SaveData:683, SaveData:749 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:97 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:99 |
| this.spdUserInfo | CellDoubleClick | SpdUserInfo_CellDoubleClick | .ctor:100 |
| this.spdDivision | CellDoubleClick | SpdDivision_CellDoubleClick | .ctor:101 |

## 6. 컨트롤 (15개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| FpSpread | 3 | spdMain, spdUserInfo, spdDivision |
| SheetView | 3 | spdMain_Sheet1, spdUserInfo_Sheet1, spdDivision_Sheet1 |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrTextBox | 1 | txtSearch |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| LayoutControlItem | 1 | layoutControlItem1 |
| EmptySpaceItem | 1 | emptySpaceItem2 |
| Panel | 1 | panel1 |

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
- 코드에서 생성하는 시트: GroupInfo, UserInfo, Division

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 155 | 하드코딩 | AddTextColumn | GroupID | GroupID | if(sheetName == "GroupInfo") |
| InitSpread |  | 156 | 하드코딩 | AddTextColumn | GrpName | GrpName | if(sheetName == "GroupInfo") |
| InitSpread |  | 157 | 하드코딩 | AddComboColumn | UseYN | UseYN | if(sheetName == "GroupInfo") |
| InitSpread |  | 169 | 하드코딩 | AddTextColumn | GroupID* | GroupID | if(sheetName == "UserInfo") |
| InitSpread |  | 170 | 하드코딩 | AddTextColumn | UserID* | UserID | if(sheetName == "UserInfo") |
| InitSpread |  | 171 | 하드코딩 | AddTextColumn | UserName* | UserName | if(sheetName == "UserInfo") |
| InitSpread |  | 172 | 하드코딩 | AddTextColumn | EnglishName | UserName_E | if(sheetName == "UserInfo") |
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | Email | Email | if(sheetName == "UserInfo") |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | Dept_ID* | Dept_ID | if(sheetName == "UserInfo") |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | Dept_Name* | Dept_Name | if(sheetName == "UserInfo") |
| InitSpread |  | 176 | 하드코딩 | AddComboColumn | UseYN | UseYN | if(sheetName == "UserInfo") |
| InitSpread |  | 188 | 하드코딩 | AddTextColumn | Name* | Name | if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 189 | 하드코딩 | AddTextColumn | Code | Code | if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 190 | 하드코딩 | AddTextColumn | JV Plant* | JV_PLANT_ID | if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 202 | 하드코딩 | AddTextColumn | Name* | Name | if(sheetName == "Plant") |
| InitSpread |  | 203 | 하드코딩 | AddTextColumn | Code | Code | if(sheetName == "Plant") |
| JVPlantColumn |  | 214 | 표시/라벨 변경 | VisibleColumns | {?siDivision.GetColumnIndex(DefColumns.JV_Plant)} |  | if(JV_ColumnIndex != -1) |
| SaveData |  | 631 | 표시/라벨 변경 | VisibleColumns | {?siDivision.GetColumnIndex(DefColumns.JV_Plant)} |  | if(fps.Name == "spdDivision") ⟫ if(siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ⟫ if(siDivision.SheetName == SpdSheet.shtDivision) ⟫ if(groupID == "JV Planner") |
| InsertRow |  | 860 | 표시/라벨 변경 | VisibleColumns | {?siDivision.GetColumnIndex(DefColumns.JV_Plant)} |  | if(fps.Name == "spdDivision") ⟫ if(siDivision != null && siDivision.IsLock(siDivision.SheetName) == false) ⟫ if(popup.ShowDialog() == DialogResult.OK) ⟫ if(popup.selectedCommonDataInfoList.Count > 0) |
| InitializeComponent |  | 200 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 201 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 202 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 203 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 269 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 270 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 271 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 272 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 329 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 330 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 331 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 332 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Division | 코드 하드코딩 전용(메타 없음) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) |
| GroupInfo | 코드 하드코딩 전용(메타 없음) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) | 6 (?3) |
| UserInfo | 코드 하드코딩 전용(메타 없음) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) | 11 (?3) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 126 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 126건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
