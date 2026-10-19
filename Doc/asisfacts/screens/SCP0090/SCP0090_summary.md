# SCP0090 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\POPUP\SCPAnalysisAlloTargetRequestPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.csproj | 378 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\POPUP\SCPAnalysisAlloTargetRequestPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.csproj | 291 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.csproj | 34 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.csproj | 1671 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Analysis\SCP0090_Allo_Target_Request\SCP0090_Allo_Target_Request.csproj | 1028 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 668 | SCP.SCP0090_GET_ALLO_TARGET_REQUEST | MATCH | SP SCP0090_GET_ALLO_TARGET_REQUEST |
| button:SaveButton | SaveButton > SaveData_Main > FindData_Main | 668 | SCP.SCP0090_GET_ALLO_TARGET_REQUEST | MATCH | SP SCP0090_GET_ALLO_TARGET_REQUEST |
| button:SaveButton | SaveButton > SaveData_Main | 917 | SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST | MATCH | SP SCP0090_SAVE_ALLO_TARGET_REQUEST |
| event:this.btnConfirm.Click | btnConfirm_Click > FindData_Main | 668 | SCP.SCP0090_GET_ALLO_TARGET_REQUEST | MATCH | SP SCP0090_GET_ALLO_TARGET_REQUEST |
| event:this.btnConfirm.Click | btnConfirm_Click | 1369 | SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM | MATCH | SP SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM |
| event:this.btnNew.Click | btnNew_Click > Get_AlloTarget_Qty | 1097 | SCP.SCP0090_GET_ALLO_TARGET_INFO | MATCH | SP SCP0090_GET_ALLO_TARGET_INFO |
| event:this.Load | Form_Load > InitControls | 153 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > GetItemByDivision | 176 | SCP.SCP0090_GET_ITEM_BY_DIVISION | MATCH | SP SCP0090_GET_ITEM_BY_DIVISION |
| event:this.Load | Form_Load > InitControls > GetItemByDivision | 278 | SCP.SCP0090_GET_ITEM_BY_DIVISION | MATCH | SP SCP0090_GET_ITEM_BY_DIVISION |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > SetToQty > Get_AlloTarget_Qty | 1097 | SCP.SCP0090_GET_ALLO_TARGET_INFO | MATCH | SP SCP0090_GET_ALLO_TARGET_INFO |
| event:this.spdMain.Change | SpdMain_Change > SetToQty > Get_AlloTarget_Qty | 1097 | SCP.SCP0090_GET_ALLO_TARGET_INFO | MATCH | SP SCP0090_GET_ALLO_TARGET_INFO |
| event:this.spdMain.ClipboardPasted | SpdMain_ClipboardPasted > SetToQty > Get_AlloTarget_Qty | 1097 | SCP.SCP0090_GET_ALLO_TARGET_INFO | MATCH | SP SCP0090_GET_ALLO_TARGET_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SCP.SCP0090_GET_ALLO_TARGET_INFO | MATCH | 1 | SP SCP0090_GET_ALLO_TARGET_INFO | EXEC:SCP0090_GET_ALLO_TARGET_INFO, SELECT:SCP_ANL_ALLO_TARGET, REF:FN_GET_ITEM_NICKNAME, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0090_GET_ALLO_TARGET_REQUEST | MATCH | 1 | SP SCP0090_GET_ALLO_TARGET_REQUEST | EXEC:SCP0090_GET_ALLO_TARGET_REQUEST, REF:FN_GET_ITEM_NICKNAME, SELECT:SCP_ANL_ALLO_TARGET_REQUEST, REF:STRING_SPLIT, SELECT:SCM_MST_ITEM_SN |  |
| SCP.SCP0090_GET_ITEM_BY_DIVISION | MATCH | 2 | SP SCP0090_GET_ITEM_BY_DIVISION | EXEC:SCP0090_GET_ITEM_BY_DIVISION, SELECT:SCM_MST_SITE_ITEM, SELECT:SCM_MST_DIVISION, SELECT:SCM_MST_SITE, SELECT:SCM_MST_ITEM_SN, REF:STRING_SPLIT |  |
| SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST | MATCH | 1 | SP SCP0090_SAVE_ALLO_TARGET_REQUEST | EXEC:SCP0090_SAVE_ALLO_TARGET_REQUEST, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, MERGE:SCP_ANL_ALLO_TARGET_REQUEST, DELETE:SCP_ANL_ALLO_TARGET_REQUEST, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM | MATCH | 1 | SP SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM | EXEC:SCP0090_SAVE_ALLO_TARGET_REQUEST_CONFIRM, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCP_ANL_ALLO_TARGET_REQUEST, SELECT:SCM_SYS_CALENDAR_M, SELECT:SCM_MST_ITEM_SN, MERGE:SCP_ANL_ALLO_TARGET, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:sUserGroup> | UserInfoContext.Current | NowGroupID |
| btnConfirm_Click | dtErr.Rows[0] | ERR_MESSAGE |
| btnNew_Click | x | NAME |
| btnNew_Click | dtAlloTargetQty.Rows[0] | QTY, NICK_NAME |
| ChkItem | x | ITEM_ID |
| ChkTeam | x | CODE |
| InitControls | UserInfoContext.Current | NowGroupID |
| SaveData_Main | x | NAME |
| SaveData_Main | dtErr.Rows[0] | ERR_MESSAGE |
| SetBtnConfirm | UserInfoContext.Current | NowGroupID |
| SetToQty | dtAlloTargetQty.Rows[0] | QTY |
| SpdMain_Change | x | ITEM_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | InitControls:146, GetItemByDivision:172, FindData_Main:651, FindData_Main:654 | CString.GetCheckedListValue | CODE |
| DataBind | InitControls:153 | UsrComboBox.DataBind | CODE, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:78 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:132 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:133 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | InitEvent:134 |
| this.spdMain | Change | SpdMain_Change | InitEvent:135 |
| this | Load | Form_Load | .ctor:116 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:252 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:253 |
| this.spdMain | ComboSelChange | SpdMain_ComboSelChange | InitEvent:254 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:255 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:256 |
| this.btnConfirm | Click | btnConfirm_Click | InitEvent:257 |
| this.spdMain | ButtonClicked | SpdMain_ButtonClicked | InitEvent:258 |
| this.BtnFromItem_Id | Click | BtnFromItem_Id_Click | InitEvent:259 |
| this.BtnToItem_Id | Click | BtnToItem_Id_Click | InitEvent:260 |
| this.btnNew | Click | btnNew_Click | InitEvent:261 |
| this.spdMain | Change | SpdMain_Change | InitEvent:262 |

## 6. 컨트롤 (55개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 14 | layoutControlItem3, layoutDivision, layoutControlItem1, layoutNickName2, layoutControlItem3, layoutControlItem4, layoutNickName3, layoutControlItem9, layoutControlItem5, layoutControlItem6, layoutControlItem7, layoutControlItem2, layoutConfirm, layoutNew |
| EmptySpaceItem | 13 | emptySpaceItem1, emptySpaceItem8, emptySpaceItem1, emptySpaceItem10, emptySpaceItem9, emptySpaceItem6, emptySpaceItem5, emptySpaceItem7, emptySpaceItem2, emptySpaceItem3, emptySpaceItem11, emptySpaceItem12, emptySpaceItem4 |
| UsrButton | 5 | usrButton1, btnNew, btnConfirm, BtnFromItem_Id, BtnToItem_Id |
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup2 |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| FpSpread | 2 | spdMain, spdMain |
| SheetView | 2 | spdMain_Sheet1, spdMain_Sheet1 |
| UsrMultiLineEditor | 2 | txtFromModel, txtToModel |
| TextBox | 2 | txtFromMonth, txtToMonth |
| UsrCheckedList2 | 2 | cboToTeam, cboFromTeam |
| UsrButtonList | 1 | btnButtonList |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrCombo | 1 | cboDivision |
| UsrComboBox | 1 | cboConfirmYN |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 10 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_Favorite | 2 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 8 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: UserInfo, Allo Target Request

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 123 | 하드코딩 | AddTextColumn | Model* | MODEL_ID |  |
| InitSpread |  | 125 | 하드코딩 | AddComboColumn | Dept* | DEPT_NAME |  |
| InitSpread |  | 126 | 하드코딩 | AddNumTextColumn | Month* | MONTH |  |
| InitSpread |  | 127 | 하드코딩 | AddNumColumn | Row* | ROW_COUNT |  |
| InitializeComponent |  | 221 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 222 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 223 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 224 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread | Allo Target Request | 207 | 하드코딩 | AddCheckColumn | chk | CHK | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 208 | 하드코딩 | AddTextColumn | Seq | SEQ | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 209 | 하드코딩 | AddNumTextColumn | CutOff* | CUTOFF_YYYYMMDD | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 211 | 하드코딩 | AddTextColumn | Model* | FROM_ITEM_ID | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 212 | 하드코딩 | AddTextColumn | NickName | FROM_NICK_NAME | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 213 | 하드코딩 | AddTextColumn | Deptid | FROM_DEPT_ID | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 214 | 하드코딩 | AddTextColumn | Dept* | FROM_DEPT_NAME | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 215 | 하드코딩 | AddNumTextColumn | Month* | FROM_YYYYMM | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 216 | 하드코딩 | AddNumColumn | Qty* | FROM_QTY | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 218 | 하드코딩 | AddTextColumn | Model* | TO_ITEM_ID | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 219 | 하드코딩 | AddTextColumn | NickName | TO_NICK_NAME | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 220 | 하드코딩 | AddTextColumn | Deptid | TO_DEPT_ID | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 221 | 하드코딩 | AddComboColumn | Dept* | TO_DEPT_NAME | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 222 | 하드코딩 | AddNumTextColumn | Month* | TO_YYYYMM | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 223 | 하드코딩 | AddNumColumn | Qty(AsIs) | TO_QTY | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 224 | 하드코딩 | AddNumColumn | Qty(ToBe)* | TO_QTY_TOBE | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 225 | 하드코딩 | AddTextColumn | Remark | COMMENTS | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 226 | 하드코딩 | AddTextColumn | Confirm | CONFIRM | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 227 | 하드코딩 | AddTextColumn | Confirm Remark | CONFIRM_COMMENTS | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 228 | 하드코딩 | AddTextColumn | Request_User | REQUEST_USER | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 229 | 하드코딩 | AddDateTimeColumn | Request_Date | REQUEST_DATE | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 230 | 하드코딩 | AddTextColumn | Confirm_User | CONFIRM_USER | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 231 | 하드코딩 | AddDateTimeColumn | Confirm_Date | CONFIRM_DATE | if(spdInfo.SheetName == "Allo Target Request") |
| InitSpread | Allo Target Request | 233 | 하드코딩 | AddTextColumn | Ins_Flag | INS_FLAG | if(spdInfo.SheetName == "Allo Target Request") |
| SetHeaderCheckBox |  | 391 | 표시/라벨 변경 | set:CellType | CellType = {?chk} | CHK | if(bCheckVisible) |
| SetHeaderCheckBox |  | 392 | 표시/라벨 변경 | set:Value | Value = {?false} | CHK | if(bCheckVisible) |
| SetHeaderCheckBox |  | 393 | 표시/라벨 변경 | set:Border | Border = {?bevelbrdr} | CHK | if(bCheckVisible) |
| SetHeaderCheckBox |  | 398 | 표시/라벨 변경 | set:CellType | CellType = {?txt} | CHK | else!(bCheckVisible) |
| SetHeaderCheckBox |  | 399 | 표시/라벨 변경 | set:Value | Value =  | CHK | else!(bCheckVisible) |
| SetChkVisible |  | 618 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.CHK)} | CHK | if(bUserRole) |
| SetChkVisible |  | 622 | 표시/라벨 변경 | SetColumnVisible | {?siMain.GetColumnIndex(DefColumns.CHK)} | CHK | else!(bUserRole) |
| InitializeComponent |  | 907 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 908 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 909 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 910 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Allo Target Request | 코드 하드코딩 전용(메타 없음) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) | 23 (?1) |
| UserInfo | 코드 하드코딩 전용(메타 없음) | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
판단불가(?) 분류: 정적평가 미지원식 28 — 런타임 분류는 실행 시점에만 결정되는 정상 동적 분기, '미지원식'만 파서 보완 대상.
분기 조건 판단불가 적용 28건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
