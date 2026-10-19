# SCM0008 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SystemMgmt.UIL\SCM0008_Auth_Request.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 1172 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\SCM0008_Auth_Request.Designer.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 1043 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 845 | SystemManager.UP_FX_GetReqAuthGroupInfo | MATCH | SP UP_FX_GetReqAuthGroupInfo |
| button:FindButton | FindButton > FindData > FindData_MyAddedAuthList | 893 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| button:FindButton | FindButton > FindData > FindData_Division | 944 | SystemManager.UP_FX_GetNewUserAuthRequestList | MATCH | SP UP_FX_GetNewUserAuthRequestList |
| event:this.btnAdd.Click | BtnAdd_Click > AddMyAuthList | 700 | SystemManager.UP_FX_SaveReqAuthAddMyList | MATCH | SP UP_FX_SaveReqAuthAddMyList |
| event:this.btnAdd.Click | BtnAdd_Click > AddMyAuthList > FindData_MyAddedAuthList | 893 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| event:this.btnAuthDelete.Click | BtnAuthRemove_Click > DelMyAuthList | 423 | SystemManager.UP_FX_DeleteReqAuthAddedMyList | MATCH | SP UP_FX_DeleteReqAuthAddedMyList |
| event:this.btnAuthDelete.Click | BtnAuthRemove_Click > DelMyAuthList > FindData | 845 | SystemManager.UP_FX_GetReqAuthGroupInfo | MATCH | SP UP_FX_GetReqAuthGroupInfo |
| event:this.btnAuthDelete.Click | BtnAuthRemove_Click > DelMyAuthList > FindData > FindData_MyAddedAuthList | 893 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| event:this.btnAuthDelete.Click | BtnAuthRemove_Click > DelMyAuthList > FindData > FindData_Division | 944 | SystemManager.UP_FX_GetNewUserAuthRequestList | MATCH | SP UP_FX_GetNewUserAuthRequestList |
| event:this.btnRequest.Click | BtnRequest_Click > RequestAuthList | 514 | SystemManager.UP_FX_SaveReqAuthRequestMyList | MATCH | SP UP_FX_SaveReqAuthRequestMyList |
| event:this.btnRequest.Click | BtnRequest_Click > RequestAuthList > FindData | 845 | SystemManager.UP_FX_GetReqAuthGroupInfo | MATCH | SP UP_FX_GetReqAuthGroupInfo |
| event:this.btnRequest.Click | BtnRequest_Click > RequestAuthList > FindData > FindData_MyAddedAuthList | 893 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| event:this.btnRequest.Click | BtnRequest_Click > RequestAuthList > FindData > FindData_Division | 944 | SystemManager.UP_FX_GetNewUserAuthRequestList | MATCH | SP UP_FX_GetNewUserAuthRequestList |
| event:this.Load | Form_Load > InitControls | 155 | biz:CommonData.CommonDataList [code=Language] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 159 | biz:CommonData.CommonDataList [code=TimeZone] | BIZ_MATCH |  |
| event:this.Load | Form_Load > DefineProperty > GetInsertedUserInfo | 802 | SystemManager.UP_FX_GetReqAuthCurrentUser | MATCH | SP UP_FX_GetReqAuthCurrentUser |
| event:this.Load | Form_Load > FindData | 845 | SystemManager.UP_FX_GetReqAuthGroupInfo | MATCH | SP UP_FX_GetReqAuthGroupInfo |
| event:this.Load | Form_Load > FindData > FindData_MyAddedAuthList | 893 | SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | SP UP_FX_GetReqAuthMyListAdded |
| event:this.Load | Form_Load > FindData > FindData_Division | 944 | SystemManager.UP_FX_GetNewUserAuthRequestList | MATCH | SP UP_FX_GetNewUserAuthRequestList |
| unreached:(진입점 미연결) | FindData_Plant | 969 | SystemManager.UP_FX_GetNewUserAuthRequestList | MATCH | SP UP_FX_GetNewUserAuthRequestList |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Language] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=TimeZone] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| SystemManager.UP_FX_DeleteReqAuthAddedMyList | MATCH | 1 | SP UP_FX_DeleteReqAuthAddedMyList | EXEC:UP_FX_DELETEREQAUTHADDEDMYLIST, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, DELETE:SCM_MST_AUTH_REQUEST |  |
| SystemManager.UP_FX_GetNewUserAuthRequestList | MATCH | 2 | SP UP_FX_GetNewUserAuthRequestList | EXEC:UP_FX_GETNEWUSERAUTHREQUESTLIST, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR |  |
| SystemManager.UP_FX_GetReqAuthCurrentUser | MATCH | 1 | SP UP_FX_GetReqAuthCurrentUser | EXEC:UP_FX_GETREQAUTHCURRENTUSER, SELECT:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SystemManager.UP_FX_GetReqAuthGroupInfo | MATCH | 1 | SP UP_FX_GetReqAuthGroupInfo | EXEC:UP_FX_GETREQAUTHGROUPINFO, SELECT:TB_FX_GROUPINFO, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SystemManager.UP_FX_GetReqAuthMyListAdded | MATCH | 1 | SP UP_FX_GetReqAuthMyListAdded | EXEC:UP_FX_GETREQAUTHMYLISTADDED, SELECT:SCM_MST_AUTH_REQUEST, SELECT:TB_FX_GROUPINFO, SELECT:SCM_MST_DIVISION, SELECT:TB_FX_USER, SELECT:SCM_MST_PLANT_SN, SELECT:SCM_MST_VENDOR, SELECT:TB_FX_USERGROUPAUTHEXTENTION |  |
| SystemManager.UP_FX_SaveReqAuthAddMyList | MATCH | 1 | SP UP_FX_SaveReqAuthAddMyList | EXEC:UP_FX_SAVEREQAUTHADDMYLIST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCM_MST_AUTH_REQUEST, INSERT:SCM_SYS_LOG_BATCH |  |
| SystemManager.UP_FX_SaveReqAuthRequestMyList | MATCH | 1 | SP UP_FX_SaveReqAuthRequestMyList | EXEC:UP_FX_SAVEREQAUTHREQUESTMYLIST, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCM_MST_AUTH_REQUEST, EXEC:UP_FX_SAVEUSERINFO, SELECT:TB_FX_USERLOCKLIST, UPDATE:TB_FX_USERLOCKLIST, EXEC:SCM_AUTH_REQ_MAIL_SEND, INSERT:SCM_SYS_LOG_BATCH, SELECT:TB_FX_USER, MERGE:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, EXEC:UP_FX_SAVEUSERGROUPINFO, UPDATE:TB_FX_USER, INSERT:#TBLSCMAUTHREQMAILSEND, SELECT:SCM_MST_AUTH_REQUEST, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_ASSIGN, SELECT:#TBLSCMAUTHREQMAILSEND, EXEC:SCM_ADM_MAIL_SEND, MERGE:TB_FX_USERGROUPINFO, EXEC:SP_SEND_DBMAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | UserInfoContext.Current | NewUserID, USER_ID, NewUserName, NewUserNameE, NewDeptID, NewDeptNameK, NewDeptNameE, NewDeptNameC, NewUserExistYN |
| FindData_Division | UserInfoContext.Current | NowGroupID |
| FindData_Plant | UserInfoContext.Current | NowGroupID |
| GetInsertedUserInfo | ds.Tables[0].Rows[0] | USERID, USERNAME, USERNAME_E, EMAIL, DEPT_ID, CELLPHONENUM, LANGUAGE, DEFAULTGROUPID, TIMEZONE, DEPT_NAME_KO, DEPT_NAME_EN, DEPT_NAME_CN |
| GetInsertedUserInfo | UserInfoContext.Current | NewUserExistYN |
| HasNoDuplicationAuth | a | USER_ID, GROUP_ID, DIVISION_ID, PLANT_ID |
| SetUserinfo | dtMyAuthList.Rows[0] | Language, TimeZone |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Resize | SCM0008_Auth_Request_Resize | InitializeComponent:943 |
| this | Load | Form_Load | .ctor:138 |
| this.spdDivision | CellClick | SpdDivision_CellClick | InitEvent:342 |
| this.spdMyAuthList | CellClick | SpdMyAuthList_CellClick | InitEvent:348 |
| this.btnAdd | Click | BtnAdd_Click | InitEvent:352 |
| this.btnAuthDelete | Click | BtnAuthRemove_Click | InitEvent:353 |
| this.btnRequest | Click | BtnRequest_Click | InitEvent:354 |

## 6. 컨트롤 (48개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | layoutControlItem2, layoutControlItem3, lblLanguage, lblTimeZone, layoutControlItem1, layoutControlItem4, layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem13, layoutControlItem15 |
| UsrTextBox | 5 | txtCellPhone, txtEMail, txtDeptName, txtUserName, txtUserId |
| Panel | 5 | panel3, panel2, panel1, panel4, panel5 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel3, usrConditionPanel2 |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl5, usrLayoutControl3 |
| SimpleButton | 3 | btnRequest, btnAdd, btnAuthDelete |
| LayoutControlGroup | 3 | layoutControlGroup1, layoutControlGroup4, layoutControlGroup2 |
| EmptySpaceItem | 3 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem1 |
| FpSpread | 3 | spdDivision, spdMain, spdMyAuthList |
| SheetView | 3 | spdDivision_Sheet1, spdMain_Sheet1, spdMyAuthList_Sheet1 |
| Splitter | 3 | splitter1, splitter4, splitter3 |
| UsrCombo | 2 | cboTimeZone, cboLanguage |
| UsrLabel | 1 | usrLabel1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_Favorite | 5 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 16 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 126 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 1082 | SystemManager.UP_FX_GetNewUserAuthRequestList | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Authority, Division, My Authority List

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 240 | 하드코딩 | AddTextColumn | GroupID | GroupID | if(sheetName == "Authority") |
| InitSpread |  | 241 | 하드코딩 | AddTextColumn | E-MAIL | GrpMail | if(sheetName == "Authority") |
| InitSpread |  | 242 | 하드코딩 | AddTextColumn | Authority | GrpName | if(sheetName == "Authority") |
| InitSpread |  | 243 | 하드코딩 | AddTextColumn | Description | GrpDescription | if(sheetName == "Authority") |
| InitSpread |  | 253 | 하드코딩 | AddCheckColumn | ALL | chk | else!(sheetName == "Authority") ⟫ if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 254 | 하드코딩 | AddTextColumn | Division | Code | else!(sheetName == "Authority") ⟫ if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 255 | 하드코딩 | AddTextColumn | Division | Name | else!(sheetName == "Authority") ⟫ if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 263 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | chk | else!(sheetName == "Authority") ⟫ if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 264 | 표시/라벨 변경 | set:Value | Value = {?false} | chk | else!(sheetName == "Authority") ⟫ if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 265 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | chk | else!(sheetName == "Authority") ⟫ if(sheetName == SpdSheet.shtDivision) |
| InitSpread |  | 305 | 하드코딩 | AddCheckColumn | ALL | chk | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 306 | 하드코딩 | AddTextColumn | Authority_code | GROUP_ID | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 307 | 하드코딩 | AddTextColumn | Authority | grpName | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 309 | 하드코딩 | AddTextColumn | Division | DIVISION_ID | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 310 | 하드코딩 | AddTextColumn | Division | DIVISION_NAME | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 312 | 하드코딩 | AddTextColumn | PLANT_ID | PLANT_ID | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 313 | 하드코딩 | AddTextColumn | Plant | PLANT_NAME | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 318 | 하드코딩 | AddDateTimeColumn | Request Date | creation_date | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 319 | 하드코딩 | AddTextColumn | Approval Result | APPROVAL_RESULT | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 320 | 하드코딩 | AddTextColumn | Approval User | last_updated_by | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 321 | 하드코딩 | AddDateTimeColumn | Approval Date | last_update_date | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 322 | 하드코딩 | AddTextColumn | Reject Reason | reject_reason | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 333 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | chk | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 334 | 표시/라벨 변경 | set:Value | Value = {?false} | chk | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitSpread |  | 335 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | chk | else!(sheetName == "Authority") ⟫ else!(sheetName == SpdSheet.shtDivision) ⟫ if(sheetName == "My Authority List") |
| InitializeComponent |  | 213 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 214 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 215 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 216 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 265 | 표시/라벨 변경 | set:Resizable | Resizable = {?false} |  |  |
| InitializeComponent |  | 266 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 267 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 268 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 269 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 739 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 740 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 741 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 742 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Authority | 코드 하드코딩 전용(메타 없음) | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |
| Division | 코드 하드코딩 전용(메타 없음) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) | 3 (?3) |
| My Authority List | 코드 하드코딩 전용(메타 없음) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) | 14 (?14) |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 런타임:사용자/권한 252 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 252건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
