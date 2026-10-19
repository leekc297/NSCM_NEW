# SCM0010 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0010_Notice_Setup.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 1348 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0010_Notice_Setup.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 514 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:cboModule.SelectedIndexChanged | CboModule_SelectedIndexChanged | 1303 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| button:FindButton | FindButton > FindData_Main | 308 | SCM.SCM0010_GET_NOTICE_MASTER | MATCH | SP SCM0010_GET_NOTICE_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 308 | SCM.SCM0010_GET_NOTICE_MASTER | MATCH | SP SCM0010_GET_NOTICE_MASTER |
| button:SaveButton | SaveButton > SaveData | 394 | SCM.SCM0010_SAVE_NOTICE_MASTER | MATCH | SP SCM0010_SAVE_NOTICE_MASTER |
| button:SaveButton | SaveButton > SaveData | 624 | biz:AppService.GeneralPseudoBatch [batchId=update_notice] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 624 | scm\admin\scm_notice_setup#update_notice | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData | 635 | biz:AppService.GeneralPseudoBatch [batchId=delete_notice] | BIZ_MATCH |  |
| button:SaveButton | SaveButton > SaveData | 635 | scm\admin\scm_notice_setup#delete_notice | MATCH | [update-batch]  |
| button:SaveButton | SaveButton > SaveData > ShowMessage | 1166 | SCM.SCM0010_GET_NOTICE_CONTENT_MASTER | MATCH | SP SCM0010_GET_NOTICE_CONTENT_MASTER |
| event:this.Load | Form_Load > InitControls | 161 | biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 162 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 163 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.Notice.CellClick | SprNotice_CellClick > ShowMessage | 1166 | SCM.SCM0010_GET_NOTICE_CONTENT_MASTER | MATCH | SP SCM0010_GET_NOTICE_CONTENT_MASTER |
| unreached:(진입점 미연결) | <field:dtModule> | 49 | biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtSubModule> | 50 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 51 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycle> | 53 | biz:CommonData.CommonDataList [code=Cycle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub1> | 54 | biz:CommonData.CommonDataList [code=CycleSub1] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub2> | 55 | biz:CommonData.CommonDataList [code=CycleSub2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtLang> | 56 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:AppService.GeneralPseudoBatch [batchId=delete_notice] | BIZ_MATCH | 1 |  |  |  |
| biz:AppService.GeneralPseudoBatch [batchId=update_notice] | BIZ_MATCH | 1 |  |  |  |
| biz:CommonData.CommonDataList [code=Cycle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub1] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub2] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH | 2 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH | 3 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCM.SCM0010_GET_NOTICE_CONTENT_MASTER | MATCH | 1 | SP SCM0010_GET_NOTICE_CONTENT_MASTER | EXEC:SCM0010_GET_NOTICE_CONTENT_MASTER, SELECT:SCM_ADM_NOTICE_CONTENT_MASTER, SELECT:SCM_ADM_NOTICE_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0010_GET_NOTICE_MASTER | MATCH | 1 | SP SCM0010_GET_NOTICE_MASTER | EXEC:SCM0010_GET_NOTICE_MASTER, SELECT:SCM_ADM_NOTICE_MASTER, REF:VALUE, REF:NODES |  |
| SCM.SCM0010_SAVE_NOTICE_MASTER | MATCH | 1 | SP SCM0010_SAVE_NOTICE_MASTER | EXEC:SCM0010_SAVE_NOTICE_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_ADM_NOTICE_MASTER_HIST, MERGE:SCM_ADM_NOTICE_MASTER, DELETE:SCM_ADM_NOTICE_MASTER, DELETE:SCM_ADM_NOTICE_CONTENT_MASTER, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_NOTICE_MASTER_H |  |
| scm\admin\scm_notice_setup#delete_notice | MATCH | 1 | [update-batch]  |  |  |
| scm\admin\scm_notice_setup#update_notice | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnPreview_Click | UserInfoContext.Current | Language |
| SaveData | r | _OPCODE_, language_code, language |
| SaveData | bindingRow | _OPCODE_ |
| UploadFile | Filter | USER_ID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:161, InitControls:162, InitControls:163, CboModule_SelectedIndexChanged:1303 | UsrComboBox.DataBind | CODE, NAME |
| SaveData | SaveButton:286 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| InitUserNotice | btnMessageTest_Click:1311 | GSCM_MainForm.InitUserNotice | ADMIN, CAPA, DM, FP, JV, Language, MODULE, NOTICE_CONTENT, NOTICE_ID, NOTICE_IMAGE, NOTICE_TITLE, SCP, SSP, SUBMODULE, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:127 |
| this.Notice | CellClick | SprNotice_CellClick | .ctor:128 |
| this.Notice | ComboSelChange | SprNotice_ComboSelChange | .ctor:129 |
| this.Notice | CellDoubleClick | SprNotice_CellDoubleClick | .ctor:130 |
| this.Message | CellClick | SprMessage_CellClick | .ctor:132 |
| this.Message | CellDoubleClick | SprMessage_CellDoubleClick | .ctor:133 |
| Message | EditChange | Message_EditChange | .ctor:134 |
| this.btnMessageTest | Click | btnMessageTest_Click | .ctor:136 |
| this.btnPreview | Click | btnPreview_Click | .ctor:137 |
| cboModule | SelectedIndexChanged | CboModule_SelectedIndexChanged | InitControls:166 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | layoutControlItem1, layoutControlItem2, layoutControlItem3, lcTest, layoutControlItem5 |
| UsrComboBox | 3 | cboModule, cboSubModule, cboActive |
| FpSpread | 2 | Notice, Message |
| SheetView | 2 | Notice_Sheet1, Message_Sheet1 |
| UsrButton | 2 | btnPreview, btnMessageTest |
| EmptySpaceItem | 2 | emptySpaceItem2, emptySpaceItem1 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| TabControl | 1 | tabControl1 |
| TabPage | 1 | tabPage1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 7 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 692 | SCM.SCM0010_SAVE_NOTICE_CONTENT_MASTER | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Notice, Message

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 194 | 하드코딩 | AddComboColumn | Module* | MODULE_CODE | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 195 | 하드코딩 | AddComboColumn | Sub Module* | SUB_MODULE_CODE | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 196 | 하드코딩 | AddTextColumn | Notice | NOTICE_ID | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 197 | 하드코딩 | AddTextColumn | Notice* | NOTICE_MAIN_TITLE | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 198 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 200 | 하드코딩 | AddComboColumn | Main* | CYCLE_CLASS_CODE | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 201 | 하드코딩 | AddComboColumn | Sub1 | DETAIL_CLASS_CODE | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 202 | 하드코딩 | AddComboColumn | Sub2 | SEND_TIME_TEXT | if(spreadInfo.SheetName == "Notice") |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | Notice | NOTICE_ID | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Notice | NOTICE_MAIN_TITLE | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | Notice Title* | NOTICE_TITLE | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | Notice Content* | NOTICE_CONTENT | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | Image | NOTICE_IMAGE | if(spreadInfo.SheetName == "Message") |
| InitSpread |  | 229 | 하드코딩 | AddButtonColumn2 | Upload | NOTICE_IMAGE_ID | if(spreadInfo.SheetName == "Message") |
| InitializeComponent |  | 127 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 128 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 129 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 130 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 424 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 425 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 426 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 427 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Message | 코드 하드코딩 전용(메타 없음) | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | 6 |
| Notice | 코드 하드코딩 전용(메타 없음) | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 | 8 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
