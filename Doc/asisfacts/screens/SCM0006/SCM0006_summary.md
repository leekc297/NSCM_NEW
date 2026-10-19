# SCM0006 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Master.UIL\POPUP\SCM0006_PopContent.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 241 |
| only | 06.UIL\GSCM.SCM.Master.UIL\POPUP\SCM0006_PopContent.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 240 |
| only | 06.UIL\GSCM.SCM.Master.UIL\POPUP\SCM0006_PopSQL.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 293 |
| only | 06.UIL\GSCM.SCM.Master.UIL\POPUP\SCM0006_PopSQL.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 240 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0006_Mail_Setup.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 1650 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0006_Mail_Setup.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 771 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboModule.SelectedIndexChanged | CboModule_SelectedIndexChanged | 1638 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 368 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| button:FindButton | FindButton > FindData_AllReceiver | 417 | SCM.SCM0006_GET_USERINFO_LIST | MATCH | SP SCM0006_GET_USERINFO_LIST |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 368 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| button:SaveButton | SaveButton > SaveData | 505 | SCM.SCM0006_SAVE_RECIPIENT_MASTER | MATCH | SP SCM0006_SAVE_RECIPIENT_MASTER |
| button:SaveButton | SaveButton > SaveData | 600 | SCM.SCM0006_SAVE_RECIPIENT_MESSAGE | MATCH | SP SCM0006_SAVE_RECIPIENT_MESSAGE |
| button:SaveButton | SaveButton > SaveData | 680 | SCM.SCM0006_SAVE_RECIPIENT_ASSIGN | MATCH | SP SCM0006_SAVE_RECIPIENT_ASSIGN |
| button:SaveButton | SaveButton > SaveData > ShowMessage | 1331 | SCM.SCM0006_GET_RECIPIENT_MESSAGE | MATCH | SP SCM0006_GET_RECIPIENT_MESSAGE |
| button:SaveButton | SaveButton > SaveData > ShowReceiver | 1370 | SCM.SCM0006_GET_RECIPIENT_ASSIGN | MATCH | SP SCM0006_GET_RECIPIENT_ASSIGN |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > SaveMailSqlData | 148 | SCM.SCM0006_SAVE_RECIPIENT_MASTER_U | MATCH | SP SCM0006_SAVE_RECIPIENT_MASTER_U |
| event:this.Category.CellDoubleClick | SprCategory_CellDoubleClick > ShowMessage | 1331 | SCM.SCM0006_GET_RECIPIENT_MESSAGE | MATCH | SP SCM0006_GET_RECIPIENT_MESSAGE |
| event:this.Category.CellDoubleClick | SprCategory_CellDoubleClick > ShowReceiver | 1370 | SCM.SCM0006_GET_RECIPIENT_ASSIGN | MATCH | SP SCM0006_GET_RECIPIENT_ASSIGN |
| event:this.Load | Form_Load > InitControls | 178 | biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 179 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 180 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > ShowSQL > GetMailSqlLongText | 262 | SCM.SCM0006_GET_SQL_LONG_TEXT | MATCH | SP SCM0006_GET_SQL_LONG_TEXT |
| unreached:(진입점 미연결) | <field:dtModule> | 38 | biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtSubModule> | 39 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 40 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycle> | 42 | biz:CommonData.CommonDataList [code=Cycle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub1> | 43 | biz:CommonData.CommonDataList [code=CycleSub1] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub2> | 44 | biz:CommonData.CommonDataList [code=CycleSub2_v2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub3> | 45 | biz:CommonData.CommonDataList [code=CycleSub3] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtLang> | 46 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=Cycle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub1] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub2_v2] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub3] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCM.SCM0006_GET_RECIPIENT_ASSIGN | MATCH | 1 | SP SCM0006_GET_RECIPIENT_ASSIGN | EXEC:SCM0006_GET_RECIPIENT_ASSIGN, SELECT:SCM_ADM_RECIPIENT_ASSIGN, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_MST_SSO_USER_INFO, SELECT:TB_FX_USER, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | 1 | SP SCM0006_GET_RECIPIENT_MASTER | EXEC:SCM0006_GET_RECIPIENT_MASTER, SELECT:SCM_ADM_RECIPIENT_LIST, REF:VALUE, REF:NODES |  |
| SCM.SCM0006_GET_RECIPIENT_MESSAGE | MATCH | 1 | SP SCM0006_GET_RECIPIENT_MESSAGE | EXEC:SCM0006_GET_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_MESSAGE, SELECT:SCM_ADM_RECIPIENT_LIST, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0006_GET_SQL_LONG_TEXT | MATCH | 1 | SP SCM0006_GET_SQL_LONG_TEXT | EXEC:SCM0006_GET_SQL_LONG_TEXT, REF:FN_GET_SOURCE_CODE, SELECT:SCM_ADM_RECIPIENT_LIST |  |
| SCM.SCM0006_GET_USERINFO_LIST | MATCH | 1 | SP SCM0006_GET_USERINFO_LIST | EXEC:SCM0006_GET_USERINFO_LIST, SELECT:SCM_MST_SSO_DEPT_INFO, SELECT:SCM_MST_SSO_USER_INFO, SELECT:TB_FX_USER |  |
| SCM.SCM0006_SAVE_RECIPIENT_ASSIGN | MATCH | 1 | SP SCM0006_SAVE_RECIPIENT_ASSIGN | EXEC:SCM0006_SAVE_RECIPIENT_ASSIGN, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_ADM_RECIPIENT_ASSIGN_HIST, MERGE:SCM_ADM_RECIPIENT_ASSIGN, DELETE:SCM_ADM_RECIPIENT_ASSIGN, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_RECIPIENT_ASSIGN_H |  |
| SCM.SCM0006_SAVE_RECIPIENT_MASTER | MATCH | 1 | SP SCM0006_SAVE_RECIPIENT_MASTER | EXEC:SCM0006_SAVE_RECIPIENT_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_ADM_RECIPIENT_LIST_HIST, MERGE:SCM_ADM_RECIPIENT_LIST, DELETE:SCM_ADM_RECIPIENT_LIST, DELETE:SCM_ADM_RECIPIENT_MESSAGE, DELETE:SCM_ADM_RECIPIENT_SMS_ASSIGN, DELETE:SCM_ADM_RECIPIENT_ASSIGN, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_RECIPIENT_LIST_H |  |
| SCM.SCM0006_SAVE_RECIPIENT_MASTER_U | MATCH | 1 | SP SCM0006_SAVE_RECIPIENT_MASTER_U | EXEC:SCM0006_SAVE_RECIPIENT_MASTER_U, EXEC:PR_SCM_SYS_LOG_BATCH, UPDATE:SCM_ADM_RECIPIENT_LIST, INSERT:SCM_SYS_LOG_BATCH |  |
| SCM.SCM0006_SAVE_RECIPIENT_MESSAGE | MATCH | 1 | SP SCM0006_SAVE_RECIPIENT_MESSAGE | EXEC:SCM0006_SAVE_RECIPIENT_MESSAGE, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_ADM_RECIPIENT_MESSAGE_HIST, MERGE:SCM_ADM_RECIPIENT_MESSAGE, DELETE:SCM_ADM_RECIPIENT_MESSAGE, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_RECIPIENT_MESSAGE_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| GetMailSqlLongText | ds.Tables[0].Rows[0] | TEXT1, TEXT2, TEXT3, TEXT4, TEXT5, TEXT6, TEXT7, TEXT8 |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | btnButtonList_UsrButtonList_Click_Detected:183, btnButtonList_UsrButtonList_Click_Detected:226, SaveButton:346 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| DataBind | InitControls:178, InitControls:179, InitControls:180, CboModule_SelectedIndexChanged:1638 | UsrComboBox.DataBind | CODE, NAME |
| LoadCombo | SprCategory_CellClick:812, SprCategory_CellClick:837, SprCategory_CellClick:876, SprCategory_CellDoubleClick:1006, SprCategory_CellDoubleClick:1031, SprCategory_CellDoubleClick:1070 | SpreadInfo.LoadCombo | CODE, NAME |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:142 |
| this | Load | Form_Load | .ctor:79 |
| rtxtContent | TextChanged | RtxtContent_TextChanged | Define:106 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:142 |
| this | Load | Form_Load | .ctor:86 |
| rtxtSQL | TextChanged | RtxtSQL_TextChanged | Form_Load:99 |
| this | Load | Form_Load | .ctor:135 |
| this.Category | CellClick | SprCategory_CellClick | .ctor:136 |
| this.Category | ComboSelChange | SprCategory_ComboSelChange | .ctor:137 |
| this.Category | CellDoubleClick | SprCategory_CellDoubleClick | .ctor:138 |
| this.Message | CellClick | SprMessage_CellClick | .ctor:140 |
| this.Message | CellDoubleClick | SprMessage_CellDoubleClick | .ctor:141 |
| this.btnRAdd | Click | BtnRAdd_Click | .ctor:142 |
| this.btnRDel | Click | BtnRDel_Click | .ctor:143 |
| this.txtUser | Click | Tx_Click | .ctor:144 |
| this.txtDept | Click | Tx_Click | .ctor:145 |
| this.txtUser | TextChanged | Tx_Click | .ctor:146 |
| this.txtDept | TextChanged | Tx_Click | .ctor:147 |
| Message | EditChange | Message_EditChange | .ctor:148 |
| All_Receiver | CellDoubleClick | All_Receiver_CellDoubleClick | .ctor:149 |
| cboModule | SelectedIndexChanged | CboModule_SelectedIndexChanged | InitControls:184 |

## 6. 컨트롤 (55개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlGroup | 8 | layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2 |
| LayoutControlItem | 7 | layoutControlItem3, layoutControlItem3, layoutControlItem1, layoutControlItem2, layoutControlItem3, lcDepartment, lcUserID |
| UsrLayoutControl | 6 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| EmptySpaceItem | 5 | emptySpaceItem1, emptySpaceItem1, emptySpaceItem1, emptySpaceItem2, emptySpaceItem3 |
| FpSpread | 4 | Category, Message, All_Receiver, Sel_Receiver |
| SheetView | 4 | Category_Sheet1, Message_Sheet1, All_Receiver_Sheet1, Sel_Receiver_Sheet1 |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrComboBox | 3 | cboModule, cboSubModule, cboActive |
| UsrButtonList | 2 | btnButtonList, btnButtonList |
| RichTextBox | 2 | rtxtContent, rtxtSQL |
| SplitContainer | 2 | splitContainer1, splitContainer2 |
| TabPage | 2 | tabPage1, tabPage2 |
| Panel | 2 | panel2, panel1 |
| Button | 2 | btnRDel, btnRAdd |
| UsrTextBox | 2 | txtDept, txtUser |
| TabControl | 1 | tabControl1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 13 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Category, Message, All_Receiver, Sel_Receiver

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 216 | 하드코딩 | AddComboColumn | USE_TYPE_CODE | USE_TYPE_CODE | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 217 | 하드코딩 | AddComboColumn | Module* | MODULE_CODE | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 218 | 하드코딩 | AddComboColumn | Sub Module* | SUB_MODULE_CODE | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Category | CATEGORY_ID | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 220 | 하드코딩 | AddTextColumn | Category* | CATEGORY_DESC | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 221 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 223 | 하드코딩 | AddComboColumn | Main* | CYCLE_CLASS_CODE | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 224 | 하드코딩 | AddComboColumn | Sub1 | DETAIL_CLASS_CODE | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 225 | 하드코딩 | AddComboColumn | Sub2 | SEND_TIME_TEXT | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 226 | 하드코딩 | AddComboColumn | Sub3 | SEND_MIN_TIME_TEXT | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 228 | 하드코딩 | AddButtonColumn | SQL VIEW | VIEW | if(spreadInfo.SheetName == "Category") |
| InitSpread |  | 248 | 하드코딩 | AddTextColumn | USE_TYPE_CODE | USE_TYPE_CODE | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 249 | 하드코딩 | AddTextColumn | Category | CATEGORY_ID | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 250 | 하드코딩 | AddTextColumn | Category | CATEGORY_DESC | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 251 | 하드코딩 | AddComboColumn | Language* | LANGUAGE_CODE | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 252 | 하드코딩 | AddTextColumn | Mail Title* | MAIL_TITLE | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 253 | 하드코딩 | AddTextColumn | Mail Content* | MESSAGE_CONTENT | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 262 | 하드코딩 | AddTextColumn | UserID | USERID | if(spreadInfo.SheetName == "All_Receiver") |
| InitSpread |  | 263 | 하드코딩 | AddTextColumn | Name | USERNAME | if(spreadInfo.SheetName == "All_Receiver") |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Department | DEPT_NAME | if(spreadInfo.SheetName == "All_Receiver") |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | Email | EMAIL | if(spreadInfo.SheetName == "All_Receiver") |
| InitSpread |  | 266 | 하드코딩 | AddTextColumn | TEL | CELLPHONENUM | if(spreadInfo.SheetName == "All_Receiver") |
| InitSpread |  | 267 | 하드코딩 | AddComboColumn | Language | LANGUAGE_CODE | if(spreadInfo.SheetName == "All_Receiver") |
| InitSpread |  | 275 | 하드코딩 | AddTextColumn | USE_TYPE_CODE | USE_TYPE_CODE | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 276 | 하드코딩 | AddTextColumn | Category | CATEGORY_ID | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 277 | 하드코딩 | AddTextColumn | Category | CATEGORY_DESC | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 278 | 하드코딩 | AddTextColumn | UserID | USERID | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 279 | 하드코딩 | AddTextColumn | Name | USERNAME | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 280 | 하드코딩 | AddTextColumn | Department | DEPT_NAME | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 281 | 하드코딩 | AddTextColumn | Email | EMAIL | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 282 | 하드코딩 | AddTextColumn | TEL | CELLPHONENUM | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitSpread |  | 283 | 하드코딩 | AddComboColumn | Language | LANGUAGE_CODE | if(spreadInfo.SheetName == "Sel_Receiver") |
| InitializeComponent |  | 153 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 154 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 155 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 156 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 346 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 347 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 348 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 349 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 427 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 428 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 429 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 430 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 655 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 656 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 657 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 658 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| All_Receiver | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Category | 코드 하드코딩 전용(메타 없음) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| Message | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Sel_Receiver | 코드 하드코딩 전용(메타 없음) | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
