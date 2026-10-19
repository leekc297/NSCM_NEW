# SCM0005 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Master.UIL\POPUP\SCM0005_DynamicQueryListPopUp.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 783 |
| only | 06.UIL\GSCM.SCM.Master.UIL\POPUP\SCM0005_DynamicQueryListPopUp.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 670 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0005_DynamicQueryList.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 1256 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0005_DynamicQueryList.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 958 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:EditButton | EditButton > FindData | 349 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| button:EditButton | EditButton > FindData > GroupData | 443 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| button:EditButton | EditButton > FindData > ParameterData | 458 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| button:FindButton | FindButton > FindData | 346 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| button:FindButton | FindButton > FindData | 505 | DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 |
| button:FindButton | FindButton > FindData | 527 | DM_H.PR_DM_ADM_DQ_EXECUTE_HIST | MATCH | SP PR_DM_ADM_DQ_EXECUTE_HIST |
| button:SaveButton | SaveButton > SaveData > FindData | 346 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| button:SaveButton | SaveButton > SaveData > FindData | 505 | DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 |
| button:SaveButton | SaveButton > SaveData > FindData | 527 | DM_H.PR_DM_ADM_DQ_EXECUTE_HIST | MATCH | SP PR_DM_ADM_DQ_EXECUTE_HIST |
| button:SaveButton | SaveButton > SaveData | 785 | DM_H.PR_DM_ADM_DQ_CREATE | MATCH | SP PR_DM_ADM_DQ_CREATE |
| button:SaveButton | SaveButton > SaveData | 832 | DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP | MATCH | SP PR_DM_ADM_DQ_CREATE_USER_GROUP |
| button:SaveButton | SaveButton > SaveData | 863 | DM_H.PR_DM_ADM_DQ_CREATE_COLUMN | MATCH | SP PR_DM_ADM_DQ_CREATE_COLUMN |
| button:SaveButton | SaveButton > SaveData | 900 | DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER | MATCH | SP PR_DM_ADM_DQ_CREATE_PARAMETER |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData | 349 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData > GroupData | 443 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > EditButton > FindData > ParameterData | 458 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| event:this.Load | Form_Load > DefineProperty | 159 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |
| event:this.Load | Form_Load > FindData | 349 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST |
| event:this.Load | Form_Load > FindData > GroupData | 443 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| event:this.Load | Form_Load > FindData > ParameterData | 458 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > Setting_ViewTab > GroupData | 612 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS |
| event:this.spdMain.CellDoubleClick | spdMain_CellDoubleClick > Setting_ViewTab > ParameterData | 628 | DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 37 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 44 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | mSave | 524 | DM.PR_DM_ADM_DQ_CREATE | MATCH | SP PR_DM_ADM_DQ_CREATE |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | MATCH | 2 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_COLUMNS, SELECT:SCM_ADM_DQ_COLUMN |  |
| DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | MATCH | 2 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST, SELECT:TMPDQ, REF:UF_FX_STRING_SPLIT, SELECT:SCM_ADM_DQ_USER_GROUP, SELECT:TB_FX_GROUPINFO, SELECT:SCM_ADM_DQ_LIST |  |
| DM_H.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | MATCH | 2 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_PARAMETERS, SELECT:SCM_ADM_DQ_PARAMETER |  |
| DM_H.PR_DM_ADM_DQ_CREATE | MATCH | 1 | SP PR_DM_ADM_DQ_CREATE | EXEC:PR_DM_ADM_DQ_CREATE, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_DM_ADM_DQ_CREATE_HIST, INSERT:SCM_ADM_DQ_LIST, UPDATE:SCM_ADM_DQ_LIST, DELETE:SCM_ADM_DQ_LIST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_ADM_DQ_LIST_H |  |
| DM_H.PR_DM_ADM_DQ_CREATE_COLUMN | MATCH | 1 | SP PR_DM_ADM_DQ_CREATE_COLUMN | EXEC:PR_DM_ADM_DQ_CREATE_COLUMN, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCM_ADM_DQ_COLUMN, INSERT:SCM_ADM_DQ_COLUMN, UPDATE:SCM_ADM_DQ_COLUMN, EXEC:PR_DM_ADM_DQ_CREATE_COLUMN_HIST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_ADM_DQ_COLUMN_H |  |
| DM_H.PR_DM_ADM_DQ_CREATE_PARAMETER | MATCH | 1 | SP PR_DM_ADM_DQ_CREATE_PARAMETER | EXEC:PR_DM_ADM_DQ_CREATE_PARAMETER, EXEC:PR_SCM_SYS_LOG_BATCH, DELETE:SCM_ADM_DQ_PARAMETER, INSERT:SCM_ADM_DQ_PARAMETER, UPDATE:SCM_ADM_DQ_PARAMETER, EXEC:PR_DM_ADM_DQ_CREATE_PARAMETER_HIST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_ADM_DQ_PARAMETER_H |  |
| DM_H.PR_DM_ADM_DQ_CREATE_USER_GROUP | MATCH | 1 | SP PR_DM_ADM_DQ_CREATE_USER_GROUP | EXEC:PR_DM_ADM_DQ_CREATE_USER_GROUP, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_DM_ADM_DQ_CREATE_USER_GROUP_HIST, DELETE:SCM_ADM_DQ_USER_GROUP, INSERT:SCM_ADM_DQ_USER_GROUP, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_ADM_DQ_USER_GROUP_H |  |
| DM_H.PR_DM_ADM_DQ_EXECUTE_HIST | MATCH | 1 | SP PR_DM_ADM_DQ_EXECUTE_HIST | EXEC:PR_DM_ADM_DQ_EXECUTE_HIST, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_DQ_EXECUTE_H, INSERT:SCM_SYS_LOG_BATCH |  |
| DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | MATCH | 1 | SP DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | EXEC:DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2, REF:FN_GET_NORMAL_STRING2, EXEC:SP_EXECUTESQL |  |
| DM.PR_DM_ADM_DQ_CREATE | MATCH | 1 | SP PR_DM_ADM_DQ_CREATE | EXEC:PR_DM_ADM_DQ_CREATE, EXEC:PR_SCM_SYS_LOG_BATCH, EXEC:PR_DM_ADM_DQ_CREATE_HIST, INSERT:SCM_ADM_DQ_LIST, UPDATE:SCM_ADM_DQ_LIST, DELETE:SCM_ADM_DQ_LIST, INSERT:SCM_SYS_LOG_BATCH, EXEC:PR_SCM_SYS_LOG_BATCH_CALL_TRAN, INSERT:SCM_ADM_DQ_LIST_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DefineProperty | UserInfoContext.Current | NowGroupID |
| EditButton | dtCompareList.Rows[i] | CODE, NAME |
| FindData | ds.Tables[0].Rows[0] | DQ_NAME, DESCRIPTION, DQ_TEXT |
| FindData | ds.Tables[0].Rows[i] | GROUP_ID |
| SaveData | dtGroup.Rows[j] | A, COLUMN_NAME, VALUE_TYPE, VALID_YN, SEQNO |
| SaveData | dtParameter.Rows[j] | A, PARAMETER_ID, TYPE, VALID_YN, SEQNO |
| spdMain_ComboSelChange | myRow | CODE |
| spdMain_ComboSelChange | row | NAME |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SaveData | SaveButton:320 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| LoadData | spdMain_CellDoubleClick:1008 | UsrCheckedListBox.LoadData | APPLFACTORY, APPLSITE, CODE, FACTORY, NAME, OPERGROUP, PANELFACTORY, PANELSITE, RESOURCE, SCHGROUP, SHIFTTYPE, SITE, ShiftType |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | ComboSelChange | spdMain_ComboSelChange | InitializeComponent:126 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:335 |
| this.rtxtSQL | TextChanged | rtxtSQL_TextChanged | InitializeComponent:504 |
| this.fpWhere | CellDoubleClick | fpWhere_CellDoubleClick | InitializeComponent:547 |
| this.fpWhere | ComboSelChange | fpWhere_ComboSelChange | InitializeComponent:548 |
| this | Load | Form_Load | .ctor:103 |
| dsdm | Changed | Dsdm_Changed | CreateSpread:175 |
| this.spdMain | CellDoubleClick | spdMain_CellDoubleClick | InitializeComponent:148 |
| this.tabQuery | SelectedIndexChanged | tabQuery_SelectedIndexChanged | InitializeComponent:200 |
| this.fpGroup | CellDoubleClick | fpGroup_CellDoubleClick | InitializeComponent:467 |
| this | Load | Form_Load | .ctor:129 |
| dsdmWhere | Changed | DsdmWhere_Changed | CreateSpread:199 |
| dsdmGroup | Changed | DsdmGroup_Changed | CreateSpread:203 |

## 6. 컨트롤 (68개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 11 | layoutControlItem1, layoutControlItem2, layoutControlItem3, layoutControlItem5, layoutControlItem4, layoutControlItem5, layoutControlItem7, layoutControlItem3, layoutControlItem2, layoutControlItem1, layoutControlItem6 |
| EmptySpaceItem | 9 | emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem1, emptySpaceItem5, emptySpaceItem3, emptySpaceItem4, emptySpaceItem1, emptySpaceItem6 |
| FpSpread | 6 | spdMain, fpWhere, spdMain, fpGroup, fpWhere, fpResult |
| SheetView | 6 | spdMain_Sheet1, fpWhere_Sheet1, spdMain_Sheet1, fpGroup_Sheet1, fpWhere_Sheet1, fpResult_Sheet1 |
| UsrLayoutControl | 5 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl3, usrLayoutControl2 |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup2, layoutControlGroup1, layoutControlGroup3, layoutControlGroup2 |
| SplitContainer | 5 | splitContainer1, splitContainer2, splitContainer1, splitContainer2, splitContainer3 |
| UsrMultiLineEditor | 4 | umltReportName, txtDescription, umltReportNameResult, txtDescrptionResult |
| UsrConditionPanel | 3 | usrConditionPanel1, usrConditionPanel2, usrConditionPanel1 |
| UsrCheckedList | 3 | clbRole, clbRole, clbRoleResult |
| Label | 3 | lbl_DQ_ID, label1, lbl_DQ_ID |
| UsrTextBox | 2 | txtReportName, txtDescription |
| RichTextBox | 2 | rtxtSQL, rtxtSQL |
| TabPage | 2 | tpRegister, tpView |
| UsrButtonList | 1 | btnButtonList |
| TabControl | 1 | tabQuery |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 2 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (4건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 144 | DM.DMF0027_GET_DM_DYNAMIC_QUERYS | commented:MATCH |
| 484 | DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | commented:MATCH |
| 706 | DM.DMF0027_GET_DM_TMP_DYNAMIC_QUERY_LIST2 | commented:MATCH |
| 719 | DM_H.PR_DM_ADM_DQ_EXECUTE_HIST | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: XXXX, XXXX2, DynamicList, DynamicResult, DynamicWhere, DynamicGroup

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_Group |  | 686 | 하드코딩 | AddTextColumn | Column | COLUMN_NAME |  |
| InitSpread_Group |  | 687 | 하드코딩 | AddTextColumn | Type | VALUE_TYPE |  |
| InitSpread_Group |  | 688 | 하드코딩 | AddComboColumn | Valid | VALID_YN |  |
| InitSpread_Group |  | 689 | 하드코딩 | AddTextColumn | Seq No | SEQNO |  |
| InitSpread_Where |  | 699 | 하드코딩 | AddComboColumn | Type | PARAMETER_TYPE |  |
| InitSpread_Where |  | 700 | 하드코딩 | AddTextColumn | Column | PARAMETER_ID |  |
| InitSpread_Where |  | 701 | 하드코딩 | AddComboColumn | Valid | VALID_YN |  |
| InitSpread_Where |  | 702 | 하드코딩 | AddTextColumn | Seq No | SEQNO |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 145 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 564 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 565 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 566 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 567 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread_Register |  | 211 | 하드코딩 | AddTextColumn | Report Name | DQ_NAME |  |
| InitSpread_Register |  | 212 | 하드코딩 | AddTextColumn | Description | DESCRIPTION |  |
| InitSpread_Register |  | 213 | 하드코딩 | AddTextColumn | Role | GROUP_NAME |  |
| InitSpread_Register |  | 214 | 하드코딩 | AddComboColumn | Valid | VALID_YN |  |
| InitSpread_Register |  | 216 | 하드코딩 | AddTextColumn | Created By | CREATED_BY |  |
| InitSpread_Register |  | 217 | 하드코딩 | AddTextColumn | Created Date | CREATION_DATE |  |
| InitSpread_Register |  | 218 | 하드코딩 | AddTextColumn | Updated By | LAST_UPDATED_BY |  |
| InitSpread_Register |  | 219 | 하드코딩 | AddTextColumn | Updated Date | LAST_UPDATE_DATE |  |
| InitSpread_Register |  | 220 | 하드코딩 | AddTextColumn | DQ_ID | DQ_ID |  |
| InitSpread_Register |  | 221 | 하드코딩 | AddTextColumn | DIVISION_ID | DIVISION_ID |  |
| InitSpread_Register |  | 222 | 하드코딩 | AddTextColumn | QUERY | DQ_TEXT |  |
| InitSpread_Register |  | 223 | 하드코딩 | AddComboColumn | Admin | ADMIN_ONLY_YN |  |
| InitSpread_Register |  | 225 | 하드코딩 | AddTextColumn | ROLE_ID | GROUP_ID |  |
| InitSpread_Register |  | 226 | 하드코딩 | AddTextColumn | COMUMNS | COMUMNS |  |
| InitSpread_Register |  | 227 | 하드코딩 | AddTextColumn | PARAMETERS | PARAMETERS |  |
| InitSpread_Register |  | 228 | 하드코딩 | AddTextColumn | POPUPFLAG | POPUPFLAG |  |
| InitSpread_Result |  | 239 | 하드코딩 | AddTextColumn | Col1 | Col1 |  |
| InitSpread_Result |  | 240 | 하드코딩 | AddTextColumn | Col2 | Col2 |  |
| InitSpread_Result |  | 241 | 하드코딩 | AddTextColumn | Col3 | Col3 |  |
| InitSpread_Result |  | 242 | 하드코딩 | AddTextColumn | Col4 | Col4 |  |
| InitSpread_Group |  | 252 | 하드코딩 | AddTextColumn | Column | COLUMN_NAME |  |
| InitSpread_Group |  | 253 | 하드코딩 | AddTextColumn | Type | VALUE_TYPE |  |
| InitSpread_Group |  | 254 | 하드코딩 | AddComboColumn | Vaild | VALID_YN |  |
| InitSpread_Group |  | 256 | 하드코딩 | AddTextColumn | AGGREGATE | AGGREGATE |  |
| InitSpread_Group |  | 257 | 하드코딩 | AddNumColumn | SEQNO | SEQNO |  |
| InitSpread_Group |  | 258 | 하드코딩 | AddComboColumn | USE | USE |  |
| InitSpread_Where |  | 268 | 하드코딩 | AddComboColumn | Type | PARAMETER_TYPE |  |
| InitSpread_Where |  | 269 | 하드코딩 | AddTextColumn | Column | PARAMETER_ID |  |
| InitSpread_Where |  | 270 | 하드코딩 | AddComboColumn | Vaild | VALID_YN |  |
| InitSpread_Where |  | 272 | 하드코딩 | AddTextColumn | OPORATOR | OPORATOR |  |
| InitSpread_Where |  | 273 | 하드코딩 | AddTextColumn | VALUE | VALUE |  |
| InitSpread_Where |  | 274 | 하드코딩 | AddComboColumn | USE | USE |  |
| InitializeComponent |  | 164 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 165 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 166 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 167 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 483 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 484 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 485 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 486 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 552 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 553 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 554 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 555 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 613 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 614 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 615 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 616 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| DynamicGroup | 코드 하드코딩 전용(메타 없음) | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 |
| DynamicList | 코드 하드코딩 전용(메타 없음) | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 |
| DynamicResult | 코드 하드코딩 전용(메타 없음) | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 |
| DynamicWhere | 코드 하드코딩 전용(메타 없음) | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 |
| XXXX | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| XXXX2 | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
