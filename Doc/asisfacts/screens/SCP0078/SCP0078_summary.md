# SCP0078 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\POPUP\SCP0078_FileUpload.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 1584 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\POPUP\SCP0078_FileUpload.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 232 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\POPUP\SCP0078_GSCM_VOC_Popup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 243 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\POPUP\SCP0078_GSCM_VOC_Popup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 240 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\POPUP\SCP0078_UserInfoPopup.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 280 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\POPUP\SCP0078_UserInfoPopup.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 294 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 37 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 3726 |
| current | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Report\SCP0078_GSCM_VOC\SCP0078_GSCM_VOC.csproj | 823 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:ExcelButton | ExcelButton > ExportExcel > SCM_SYS_LOG_BATCH_VOC | 941 | SCP.PR_SCM_SYS_LOG_BATCH | MATCH | SP PR_SCM_SYS_LOG_BATCH |
| button:FindButton | FindButton > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| button:FindButton | FindButton > FindData > MappingFileName > GetFileMapping | 389 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| button:FindButton | FindButton > FindData_Main | 1001 | SCP.SCP0078_GET_GSCM_VOC | MATCH | SP SCP0078_GET_GSCM_VOC |
| button:FindButton | FindButton > FindData_Main > SetSpreadInit > InitSpread > GetSpdTitle | 3306 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| button:SaveButton | SaveButton > Save_Data > FindData_Main | 1001 | SCP.SCP0078_GET_GSCM_VOC | MATCH | SP SCP0078_GET_GSCM_VOC |
| button:SaveButton | SaveButton > Save_Data | 1706 | SCP.SCP0078_SAVE_GSCM_VOC | MATCH | SP SCP0078_SAVE_GSCM_VOC |
| button:SaveButton | SaveButton > Save_Data > FindData_Main > SetSpreadInit > InitSpread > GetSpdTitle | 3306 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > UpdateFileList > SetVOCFileList > FindData > MappingFileName > GetFileMapping | 389 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > UpdateFileList | 757 | SCP.SCP0078_SAVE_GSCM_VOC_FILE | MATCH | SP SCP0078_SAVE_GSCM_VOC_FILE |
| event:spdMain.CellDoubleClick | SpdMain_CellDoubleClick > UpdateFileList > SetVOCFileList | 809 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected > SaveData > SaveDetailData | 114 | SCP.SCP0078_SAVE_GSCM_VOC_DATA | MATCH | SP SCP0078_SAVE_GSCM_VOC_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > FindButton > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > CallFileUpload > UploadFileResult > SetVOCFileList > FindData > MappingFileName > GetFileMapping | 389 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > CallFileUpload > UploadFileResult > UpdateFileList | 757 | SCP.SCP0078_SAVE_GSCM_VOC_FILE | MATCH | SP SCP0078_SAVE_GSCM_VOC_FILE |
| event:this.btnButtonList.UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected > CallFileUpload > UploadFileResult > SetVOCFileList | 809 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.btnOpen.Click | BtnOpen_Click > CallFileUpload > UploadFileResult > SetVOCFileList > FindData > MappingFileName > GetFileMapping | 389 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.btnOpen.Click | BtnOpen_Click > CallFileUpload > UploadFileResult > UpdateFileList | 757 | SCP.SCP0078_SAVE_GSCM_VOC_FILE | MATCH | SP SCP0078_SAVE_GSCM_VOC_FILE |
| event:this.btnOpen.Click | BtnOpen_Click > CallFileUpload > UploadFileResult > SetVOCFileList | 809 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.Load | Form_Load > FindData | 157 | SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP |
| event:this.Load | Form_Load > ShowSQL > GetDetailText | 215 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.Load | Form_Load > InitControls | 286 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls > GetVocDivision | 313 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > FindData > MappingFileName > GetFileMapping | 389 | SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | SP SCP0078_GET_GSCM_VOC_DATA |
| event:this.Load | Form_Load > SetAPI > GetVocFileAPI | 1045 | SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | SP SCM0001_GET_LOOKUP_VALUES |
| event:this.Load | Form_Load > CreateSpread > InitSpread > GetSpdTitle | 3306 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > openFileUpload > FindData_Main | 1001 | SCP.SCP0078_GET_GSCM_VOC | MATCH | SP SCP0078_GET_GSCM_VOC |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > openFileUpload > FindData_Main > SetSpreadInit > InitSpread > GetSpdTitle | 3306 | SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | SP SCP0009_GET_SHEET_CALENDAR_3SPAN |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 1 |  |  |  |
| SCM.SCM0001_GET_LOOKUP_VALUES | MATCH | 2 | SP SCM0001_GET_LOOKUP_VALUES | EXEC:SCM0001_GET_LOOKUP_VALUES, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCP.PR_SCM_SYS_LOG_BATCH | MATCH | 1 | SP PR_SCM_SYS_LOG_BATCH | EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | MATCH | 1 | SP SCP0009_GET_SHEET_CALENDAR_3SPAN | EXEC:SCP0009_GET_SHEET_CALENDAR_3SPAN, SELECT:SCM_SYS_CALENDAR_M |  |
| SCP.SCP0050_GET_CAPA_PIC_USERINFO_POPUP | MATCH | 1 | SP SCP0050_GET_CAPA_PIC_USERINFO_POPUP | EXEC:SCP0050_GET_CAPA_PIC_USERINFO_POPUP, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO |  |
| SCP.SCP0078_GET_GSCM_VOC | MATCH | 1 | SP SCP0078_GET_GSCM_VOC | EXEC:SCP0078_GET_GSCM_VOC, SELECT:VOC_LIST, REF:FN_GET_VOC_DELAY_YN, REF:FN_GET_VOC_RUN_YN, REF:FN_GET_VOC_SOON_YN, SELECT:SCM_ADM_SYS_VOC, SELECT:SCM_MST_SSO_USER_INFO, SELECT:SCM_MST_SSO_DEPT_INFO, EXEC:PR_SCM_SYS_LOG_BATCH, REF:FN_GET_VOC_SPLIT, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0078_GET_GSCM_VOC_DATA | MATCH | 3 | SP SCP0078_GET_GSCM_VOC_DATA | EXEC:SCP0078_GET_GSCM_VOC_DATA, SELECT:SCM_ADM_SYS_VOC, SELECT:SCM_MST_SSO_USER_INFO |  |
| SCP.SCP0078_SAVE_GSCM_VOC | MATCH | 1 | SP SCP0078_SAVE_GSCM_VOC | EXEC:SCP0078_SAVE_GSCM_VOC, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, SELECT:SCM_ADM_SYS_VOC, UPDATE:SCM_ADM_SYS_VOC, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, EXEC:SCP0078_GET_GSCM_VOC_MAIL_SEND, INSERT:SCM_ADM_SYS_VOC, INSERT:SCM_SYS_LOG_BATCH, REF:FN_GET_LOOKUP_CODE_DESC, SELECT:SCM_MST_SSO_USER_INFO, EXEC:SCM_ADM_MAIL_SEND, EXEC:SP_SEND_DBMAIL |  |
| SCP.SCP0078_SAVE_GSCM_VOC_DATA | MATCH | 1 | SP SCP0078_SAVE_GSCM_VOC_DATA | EXEC:SCP0078_SAVE_GSCM_VOC_DATA, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, UPDATE:SCM_ADM_SYS_VOC, INSERT:SCM_ADM_SYS_VOC, INSERT:SCM_SYS_LOG_BATCH |  |
| SCP.SCP0078_SAVE_GSCM_VOC_FILE | MATCH | 1 | SP SCP0078_SAVE_GSCM_VOC_FILE | EXEC:SCP0078_SAVE_GSCM_VOC_FILE, EXEC:PR_SCM_SYS_LOG_BATCH, SELECT:SCM_ADM_SYS_VOC, UPDATE:SCM_ADM_SYS_VOC, INSERT:SCM_SYS_LOG_BATCH |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DownFile | response.Headers | Content-Disposition |
| FindData | json | fileInfo |
| GetDetailText | ds.Tables[0].Rows[0] | VOC_DETAIL, REMARK |
| GetFileMapping | dsReturn.Tables[0].Rows[0] | FILE_MAPPING |
| GetFileNameMapping | row | ROW, fileid, fileRealName |
| GetUserGroup | UserInfoContext.Current | NowGroupID |
| MappingFileName | row2 | fileid, fileRealName, fileSize, registerId |
| MappingFileName | row1 | fileid, fileRealName, fileSize, registerId |
| SearchFileNameMapping | row | fileId, fileRealName |
| SetAPI | row | CODE, NAME |
| SetVOCFileList | ds.Tables[0].Rows[0] | FILE_UPLOAD |
| UploadFileResult | json | fileInfo |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| SetSheetHeaderColumn | InitSpread:164, InitSpread:340 | SpreadInfo.SetSheetHeaderColumn | ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, CELL_COMBO_DATA_TYPE, CELL_CONTROL_OBJECT_TYPE_CODE, COLUMN_LABEL_NAME, COLUMN_NAME, COLUMN_WIDTH, DATA_MAX_LENGTH, DATA_SCALE_NUMBER, FIXED_FLAG, HORIZONTAL_ALIGN_CODE, PROGRAM_ID, SHEET_NAME, UPPERCASE_APPLY_FLAG, VALID_YN, VISIBLE_FLAG |
| SaveData | btnButtonList_UsrButtonList_Click_Detected:187 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetSpdTitle | InitSpread:381 | SpreadInfo.GetSpdTitle | COLUMN_NAME, SORT_ORDER_NO |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:107 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:108 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:129 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:130 |
| this.btnOpen | Click | BtnOpen_Click | Form_Load:131 |
| this.btnButtonList | UsrButtonList_Click_Detected | btnButtonList_UsrButtonList_Click_Detected | InitializeComponent:142 |
| this | Load | Form_Load | .ctor:50 |
| rtxtSQL | TextChanged | RtxtSQL_TextChanged | Form_Load:58 |
| this | Load | Form_Load | .ctor:76 |
| spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:77 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | Form_Load:92 |
| this.spdMain | CellClick | SpdMain_CellClick | Form_Load:93 |
| this | Load | Form_Load | .ctor:256 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitEvent:398 |
| this.spdMain | TopChange | SpdMain_TopChange | InitEvent:399 |
| this.spdMain | EditChange | SpdMain_EditChange | InitEvent:400 |
| this.spdMain | ClipboardChanged | SpdMain_ClipboardChanged | InitEvent:401 |
| this.spdMain | ClipboardPasting | SpdMain_ClipboardPasting | InitEvent:402 |
| this.spdMain | ClipboardPasted | SpdMain_ClipboardPasted | InitEvent:403 |
| this.spdMain | EditorFocused | SpdMain_EditorFocused | InitEvent:404 |

## 6. 컨트롤 (56개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 13 | layoutControlItem3, layoutControlItem1, layoutControlItem3, lblVocStep, lcVocStatus, lblVocName, lblReqUserID, lblUseYN, lblCSR, lblVocType, lblCombo1, lblVocConfirm, layoutControlItem1 |
| UsrCombo | 6 | cboVocStep, cboVocType, cboUseYN, cboVocStatus, cboDivision, cboConfirm |
| LayoutControlGroup | 5 | layoutControlGroup1, layoutControlGroup2, Root, layoutControlGroup1, layoutControlGroup2 |
| UsrConditionPanel | 4 | usrConditionPanel1, usrConditionPanel1, usrConditionPanel1, usrConditionPanel1 |
| UsrLayoutControl | 4 | usrLayoutControl1, usrLayoutControl2, usrLayoutControl1, usrLayoutControl2 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem2, emptySpaceItem1 |
| UsrButtonList | 3 | btnButtonList, btnButtonList, btnButtonList |
| FpSpread | 3 | spdMain, spdMain, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdMain_Sheet1, spdMain_Sheet1 |
| UsrTextBox | 3 | txtSearch, txtCSR, txtVocName |
| UsrButton | 2 | usrButton1, usrButton2 |
| Panel | 1 | pnlBottom |
| Button | 1 | btnOpen |
| ImageList | 1 | imageList1 |
| RichTextBox | 1 | rtxtSQL |
| UsrDateRangePicker3 | 1 | dCalendar |
| UsrMultiLineEditor | 1 | txtReqUserID |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 23 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_MST_SHEET_COLUMNS | 72 | dbmeta_dbo_SCM_MST_SHEET_COLUMNS.csv |
| dbo.TB_FX_Favorite | 4 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 15 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 2 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 33 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의 (메타 규칙 전개, 상세 grid_rule.csv)
규칙: DIVISION_ID 빈값=전체 / VISIBLE_FLAG·VALID_YN='Y' / USER_SELECTABLE_FLAG='N'=필수 / DEFAULT_FLAG='Y'=기본 / 그 외=선택. 셀 값은 `필수+기본/선택` 컬럼 수.

| 테이블 | 프로그램 | 시트 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| SCM_MST_SHEET_COLUMNS | SCP0078 | Main | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 | 50/0 |
| SCM_MST_SHEET_COLUMNS | SCP0078 | VOC_FILE | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 | 4/0 |

실제 SP 실행 결과와 매칭되는 시트가 없습니다 (grid 단계 미실행 또는 시트명 불일치).

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: VOC_FILE, UserInfo, Main
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn@InitSpread:164, SetSheetHeaderColumn@InitSpread:340
- 화면이 직접 정의한 Grid 메서드(프레임워크와 이름만 같음, 내부 코드가 위 표에 전개됨): SetSpreadColumn

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| SpdMain_CellClick |  | 1274 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 1279 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 174 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 175 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 176 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 177 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 126 | 하드코딩 | AddTextColumn | UserID | USER_ID |  |
| InitSpread |  | 127 | 하드코딩 | AddTextColumn | UserName | USER_NAME |  |
| InitSpread |  | 128 | 하드코딩 | AddTextColumn | EnglishName | USER_NAME_EN |  |
| InitSpread |  | 129 | 하드코딩 | AddTextColumn | Dept_ID | DEPT_ID |  |
| InitSpread |  | 130 | 하드코딩 | AddTextColumn | Dept_Name | DEPT_NAME |  |
| SpdMain_CellClick |  | 201 | 표시/라벨 변경 | set:Value | Value = {?false} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ if(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| SpdMain_CellClick |  | 206 | 표시/라벨 변경 | set:Value | Value = {?true} |  | if(siMain.ActiveSheet.RowCount >= 1 && e.ColumnHeader) ⟫ if(siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType != null && siMain.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].CellType.GetType() == typeof(FarPoint.Win.Spread.CellType.CheckBoxCell…) ⟫ for(iRow < siMain.ActiveSheet.RowCount) ⟫ else!(Convert.ToBoolean(siMain.ActiveSheet.GetValue("0", e.Column))) |
| InitializeComponent |  | 228 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 229 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 230 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 231 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| ExportExcel |  | 814 | 표시/라벨 변경 | set:Formula | Formula =  |  | for(iSheetIndex < spSpread.Sheets.Count) ⟫ for(i >= 0) ⟫ else!(newSheet.Columns[i].Visible == false) ⟫ if(newSheet.Columns[i].CellType != null) ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.ComboBoxCellType") ⟫ else!(newSheet.Columns[i].CellType.GetType().FullName == "FarPoint.Win.Spread.CellType.MultiColumnComboBoxCellType") ⟫ if(newSheet.Columns[i].Formula != string.Empty) |
| ExportExcel |  | 856 | 표시/라벨 변경 | set:DefaultStyle | DefaultStyle = {?siNewColHeader} |  |  |
| InitializeComponent |  | 728 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 729 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 730 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 731 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Main | META+코드연결 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 | 50 |
| UserInfo | 코드 하드코딩 전용(메타 없음) | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 | 5 |
| VOC_FILE | META+코드연결 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
