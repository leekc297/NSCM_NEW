# GSCM_USERINFO 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 03.BIZ\GSCM.Common\DLL\UserInfo.cs | 03.BIZ\GSCM.Common\GSCM.Common.csproj | 95 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\UserInfo.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 595 |
| only | 06.UIL\GSCM.SystemMgmt.UIL\UserInfo.Designer.cs | 06.UIL\GSCM.SystemMgmt.UIL\GSCM.SystemMgmt.UIL.csproj | 344 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData | 260 | SystemManager.UP_FX_GetUserInfoSearchList | MATCH | SP UP_FX_GetUserInfoSearchList |
| button:SaveButton | SaveButton > SaveData > FindData | 260 | SystemManager.UP_FX_GetUserInfoSearchList | MATCH | SP UP_FX_GetUserInfoSearchList |
| event:this.Load | Form_Load > InitControls | 129 | biz:CommonData.CommonDataList [code=GroupID] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 130 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.CellClick | SpdMain_CellClick | 527 | biz:CommonData.CommonDataList [code=MyGroupIDALL] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetUserAuthenctication | 29 | MenuContainer.UP_FX_GetGSCMUserAuthenctication | MATCH | SP UP_FX_GetGSCMUserAuthenctication |
| unreached:(진입점 미연결) | GetUserGuestAuthenctication | 42 | MenuContainer.UP_FX_GetGSCMGuestUserAuthenctication | MATCH | SP UP_FX_GetGSCMGuestUserAuthenctication |
| unreached:(진입점 미연결) | <field:dtLanguage> | 45 | biz:CommonData.CommonDataList [code=Language] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtTimeZone> | 46 | biz:CommonData.CommonDataList [code=TimeZone] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 47 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetSecurityACL | 48 | MenuContainer.UP_FX_GetGSCMSecurityACL | MATCH | SP UP_FX_GetGSCMSecurityACL |
| unreached:(진입점 미연결) | <field:dtGroupID> | 48 | biz:CommonData.CommonDataList [code=GroupID] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | SavePersonalSetting | 54 | SystemManager.UP_FX_SavePersonalSetting | MATCH | SP UP_FX_SavePersonalSetting |
| unreached:(진입점 미연결) | SaveFavorite | 59 | MenuContainer.UP_FX_SaveFavorite | MATCH | SP UP_FX_SaveFavorite |
| unreached:(진입점 미연결) | DeleteFavorite | 64 | MenuContainer.UP_FX_DeleteFavorite | MATCH | SP UP_FX_DeleteFavorite |
| unreached:(진입점 미연결) | SaveSearchCondition | 69 | MenuContainer.UP_FX_SaveSearchCondition | MATCH | SP UP_FX_SaveSearchCondition |
| unreached:(진입점 미연결) | ResetSearchCondition | 75 | MenuContainer.UP_FX_ResetSearchCondition | MATCH | SP UP_FX_ResetSearchCondition |
| unreached:(진입점 미연결) | SaveNoticeConfirm | 81 | SCM.SCM_ADM_SAVE_NOTICE_CONFIRM | MATCH | SP SCM_ADM_SAVE_NOTICE_CONFIRM |
| unreached:(진입점 미연결) | SaveUserConnect | 86 | MenuContainer.UP_FX_SaveUserConnect | MATCH | SP UP_FX_SaveUserConnect |
| unreached:(진입점 미연결) | SaveMenuConnect | 91 | MenuContainer.UP_FX_SaveMenuConnect | MATCH | SP UP_FX_SaveMenuConnect |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=GroupID] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:TB_FX_GROUPINFO |
| biz:CommonData.CommonDataList [code=Language] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyGroupIDALL] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:TB_FX_GROUPINFO, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPINFO |
| biz:CommonData.CommonDataList [code=TimeZone] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| MenuContainer.UP_FX_DeleteFavorite | MATCH | 1 | SP UP_FX_DeleteFavorite | EXEC:UP_FX_DELETEFAVORITE, DELETE:TB_FX_FAVORITE |  |
| MenuContainer.UP_FX_GetGSCMGuestUserAuthenctication | MATCH | 1 | SP UP_FX_GetGSCMGuestUserAuthenctication | EXEC:UP_FX_GETGSCMGUESTUSERAUTHENCTICATION, UPDATE:TB_FX_USER, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USER, SELECT:SCM_MST_SSO_USER_INFO, SELECT:TB_FX_USERLOCKLIST |  |
| MenuContainer.UP_FX_GetGSCMSecurityACL | MATCH | 1 | SP UP_FX_GetGSCMSecurityACL | EXEC:UP_FX_GETGSCMSECURITYACL, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPINFO, SELECT:TB_FX_GROUPMENUAUTH, SELECT:TB_FX_USERMENUAUTH, SELECT:TB_FX_EXTENSIONAUTHINFO, SELECT:TB_FX_GROUPMENUAUTHEXTENSION, SELECT:TB_FX_USERMENUAUTHEXTENSION |  |
| MenuContainer.UP_FX_GetGSCMUserAuthenctication | MATCH | 1 | SP UP_FX_GetGSCMUserAuthenctication | EXEC:UP_FX_GETGSCMUSERAUTHENCTICATION, UPDATE:TB_FX_USER, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_GROUPINFO, SELECT:TB_FX_USER |  |
| MenuContainer.UP_FX_ResetSearchCondition | MATCH | 1 | SP UP_FX_ResetSearchCondition | EXEC:UP_FX_RESETSEARCHCONDITION, DELETE:TB_FX_SEARCHCONDITION |  |
| MenuContainer.UP_FX_SaveFavorite | MATCH | 1 | SP UP_FX_SaveFavorite | EXEC:UP_FX_SAVEFAVORITE, MERGE:TB_FX_FAVORITE |  |
| MenuContainer.UP_FX_SaveMenuConnect | MATCH | 1 | SP UP_FX_SaveMenuConnect | EXEC:UP_FX_SAVEMENUCONNECT, MERGE:TB_FX_MENUCONNECT, INSERT:TB_FX_MENUCONNECTLOG |  |
| MenuContainer.UP_FX_SaveSearchCondition | MATCH | 1 | SP UP_FX_SaveSearchCondition | EXEC:UP_FX_SAVESEARCHCONDITION, MERGE:TB_FX_SEARCHCONDITION |  |
| MenuContainer.UP_FX_SaveUserConnect | MATCH | 1 | SP UP_FX_SaveUserConnect | EXEC:UP_FX_SAVEUSERCONNECT, MERGE:TB_FX_USERCONNECT, INSERT:TB_FX_USERCONNECTLOG |  |
| SCM.SCM_ADM_SAVE_NOTICE_CONFIRM | MATCH | 1 | SP SCM_ADM_SAVE_NOTICE_CONFIRM | EXEC:SCM_ADM_SAVE_NOTICE_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_SCM_ADM_NOTICE_CONFIRM_HIST, SELECT:SCM_ADM_NOTICE_CONFIRM, INSERT:SCM_ADM_NOTICE_CONFIRM, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_NOTICE_CONFIRM_H |  |
| SystemManager.UP_FX_GetUserInfoSearchList | MATCH | 1 | SP UP_FX_GetUserInfoSearchList | EXEC:UP_FX_GETUSERINFOSEARCHLIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:TB_FX_USER, SELECT:TB_FX_USERGROUPINFO |  |
| SystemManager.UP_FX_SavePersonalSetting | MATCH | 1 | SP UP_FX_SavePersonalSetting | EXEC:UP_FX_SAVEPERSONALSETTING, UPDATE:TB_FX_USER |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| SaveData | dr | A, RegtUserID |
| SaveData | row | A |
| SpdMain_CellClick | dr | Name |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:129, InitControls:130 | UsrComboBox.DataBind | CODE, NAME |
| SaveData | SaveButton:225 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:405 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:106 |
| this.spdMain | CellClick | SpdMain_CellClick | .ctor:107 |

## 6. 컨트롤 (14개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 4 | layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem4 |
| UsrComboBox | 2 | cmbUseYN, cmbGroup |
| UsrTextBox | 2 | txtDept, txtSearch |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| EmptySpaceItem | 1 | emptySpaceItem2 |
| SheetView | 1 | spdMain_Sheet1 |
| FpSpread | 1 | spdMain |

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
- 코드에서 생성하는 시트: UserInfo

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 149 | 하드코딩 | AddTextColumn | UserID* | UserID |  |
| InitSpread |  | 150 | 하드코딩 | AddTextColumn | UserName* | UserName |  |
| InitSpread |  | 151 | 하드코딩 | AddTextColumn | EnglishName | UserName_E |  |
| InitSpread |  | 152 | 하드코딩 | AddButtonColumn | Search | UserPopup |  |
| InitSpread |  | 153 | 하드코딩 | AddTextColumn | Email | Email |  |
| InitSpread |  | 154 | 하드코딩 | AddTextColumn | TempDept_ID | TempDept_ID |  |
| InitSpread |  | 155 | 하드코딩 | AddTextColumn | Dept_ID | Dept_ID |  |
| InitSpread |  | 156 | 하드코딩 | AddTextColumn | Dept_Name | Dept_Name |  |
| InitSpread |  | 157 | 하드코딩 | AddButtonColumn | Search | DeptPopup |  |
| InitSpread |  | 158 | 하드코딩 | AddTextColumn | OfficePhoneNum | OfficePhoneNum |  |
| InitSpread |  | 159 | 하드코딩 | AddTextColumn | CellPhoneNum | CellPhoneNum |  |
| InitSpread |  | 160 | 하드코딩 | AddComboColumn | Language* | Language |  |
| InitSpread |  | 161 | 하드코딩 | AddComboColumn | Default Group* | DefaultGroupID |  |
| InitSpread |  | 162 | 하드코딩 | AddButtonColumn | Assign Group | MyGroupID |  |
| InitSpread |  | 163 | 하드코딩 | AddComboColumn | Time Zone* | TimeZone |  |
| InitSpread |  | 164 | 하드코딩 | AddDateTimeColumn | LastLogin | LastLoginDateTime |  |
| InitSpread |  | 165 | 하드코딩 | AddComboColumn | PermanentYN | PermanentYN |  |
| InitSpread |  | 166 | 하드코딩 | AddComboColumn | UseYN* | UseYN |  |
| InitSpread |  | 167 | 하드코딩 | AddTextColumn | Created By | RegtUserID |  |
| InitSpread |  | 168 | 하드코딩 | AddDateTimeColumn | Creation Date | RegtDateTime |  |
| InitSpread |  | 169 | 하드코딩 | AddTextColumn | Updated By | UpdateUserID |  |
| InitSpread |  | 170 | 하드코딩 | AddDateTimeColumn | Update Date  | UpdateDateTime |  |
| InitSpread |  | 171 | 하드코딩 | AddTextColumn | Attribute1 | Attribute1 |  |
| InitSpread |  | 172 | 하드코딩 | AddTextColumn | Attribute2 | Attribute2 |  |
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | Attribute3 | Attribute3 |  |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | Attribute4 | Attribute4 |  |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | Attribute5 | Attribute5 |  |
| InitSpread |  | 176 | 하드코딩 | AddTextColumn | Attribute6 | Attribute6 |  |
| InitSpread |  | 177 | 하드코딩 | AddTextColumn | Attribute7 | Attribute7 |  |
| InitSpread |  | 178 | 하드코딩 | AddTextColumn | Attribute8 | Attribute8 |  |
| InitSpread |  | 179 | 하드코딩 | AddTextColumn | Attribute9 | Attribute9 |  |
| InitSpread |  | 180 | 하드코딩 | AddTextColumn | Attribute10 | Attribute10 |  |
| InitializeComponent |  | 263 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 264 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 265 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 266 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| UserInfo | 코드 하드코딩 전용(메타 없음) | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 | 32 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
