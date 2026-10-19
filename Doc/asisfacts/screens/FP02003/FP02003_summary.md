# FP02003 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP2003_SMS_MAIL_SEND.UIL\FP02003_SMS_MAIL_SEND.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP2003_SMS_MAIL_SEND.UIL\FP02003_SMS_MAIL_SEND.UIL.csproj | 1261 |
| current(sln미등록) | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP2003_SMS_MAIL_SEND.UIL\FP02003_SMS_MAIL_SEND.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP2003_SMS_MAIL_SEND.UIL\FP02003_SMS_MAIL_SEND.UIL.csproj | 621 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > UIFindData > Find_Data_Main | 1072 | SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCM0003_GET_LOOKUP_MASTER_DETAIL |
| button:FindButton | FindButton > UIFindData > Find_Data_Main | 1074 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL")}#{?serviceUri} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data_Sub_SMS | 1154 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| button:FindButton | FindButton > Find_Data_Sub_SMS | 1160 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| button:FindButton | FindButton > Find_Data_Sub_Mail | 1193 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| button:FindButton | FindButton > Find_Data_Sub_Mail | 1199 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData | 896 | SCM.SCM0006_SAVE_RECIPIENT_MASTER | MATCH | SP SCM0006_SAVE_RECIPIENT_MASTER |
| button:SaveButton | SaveButton > SaveData | 920 | {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData | 920 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_SAVE_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData | 1006 | SCM.SCM0006_SAVE_RECIPIENT_MASTER | MATCH | SP SCM0006_SAVE_RECIPIENT_MASTER |
| button:SaveButton | SaveButton > SaveData | 1030 | {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData | 1030 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_SAVE_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Main | 1072 | SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCM0003_GET_LOOKUP_MASTER_DETAIL |
| button:SaveButton | SaveButton > SaveData > UIFindData > Find_Data_Main | 1074 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL")}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData > Find_Data_Sub_SMS | 1154 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| button:SaveButton | SaveButton > SaveData > Find_Data_Sub_SMS | 1160 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| button:SaveButton | SaveButton > SaveData > Find_Data_Sub_Mail | 1193 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| button:SaveButton | SaveButton > SaveData > Find_Data_Sub_Mail | 1199 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| event:spdMain.CellClick | SpdMain_CellClick > Find_Data_Sub_SMS | 1154 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| event:spdMain.CellClick | SpdMain_CellClick > Find_Data_Sub_SMS | 1160 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| event:spdMain.CellClick | SpdMain_CellClick > Find_Data_Sub_Mail | 1193 | SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | SP SCM0006_GET_RECIPIENT_MASTER |
| event:spdMain.CellClick | SpdMain_CellClick > Find_Data_Sub_Mail | 1199 | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED |  |
| event:this.Load | Form_Load > InitControls | 388 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtModule> | 35 | biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtSubModule> | 36 | biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 37 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycle> | 39 | biz:CommonData.CommonDataList [code=Cycle] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub1> | 40 | biz:CommonData.CommonDataList [code=CycleSub1] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub2> | 41 | biz:CommonData.CommonDataList [code=CycleSub2_v2] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtCycleSub3> | 42 | biz:CommonData.CommonDataList [code=CycleSub3] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtLang> | 43 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL")}#{?serviceUri} | UNRESOLVED | 1 |  |  |  |
| {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED | 2 |  |  |  |
| {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_SAVE_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED | 2 |  |  |  |
| {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} | UNRESOLVED | 2 |  |  |  |
| biz:CommonData.CommonDataList [code=Cycle] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub1] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub2_v2] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=CycleSub3] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=Module] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=SubModule] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | 1 | SP SCM0003_GET_LOOKUP_MASTER_DETAIL | EXEC:SCM0003_GET_LOOKUP_MASTER_DETAIL, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |
| SCM.SCM0006_GET_RECIPIENT_MASTER | MATCH | 2 | SP SCM0006_GET_RECIPIENT_MASTER | EXEC:SCM0006_GET_RECIPIENT_MASTER, SELECT:SCM_ADM_RECIPIENT_LIST, REF:VALUE, REF:NODES |  |
| SCM.SCM0006_SAVE_RECIPIENT_MASTER | MATCH | 2 | SP SCM0006_SAVE_RECIPIENT_MASTER | EXEC:SCM0006_SAVE_RECIPIENT_MASTER, EXEC:PR_SCM_SYS_LOG_BATCH, REF:SCM_ARR_SPL_CNT, REF:SCM_ARR_SPL_VAL, EXEC:PR_SCM_ADM_RECIPIENT_LIST_HIST, MERGE:SCM_ADM_RECIPIENT_LIST, DELETE:SCM_ADM_RECIPIENT_LIST, DELETE:SCM_ADM_RECIPIENT_MESSAGE, DELETE:SCM_ADM_RECIPIENT_SMS_ASSIGN, DELETE:SCM_ADM_RECIPIENT_ASSIGN, INSERT:SCM_SYS_LOG_BATCH, INSERT:SCM_ADM_RECIPIENT_LIST_H |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| Find_Data_Main | ds.Tables[0].Rows[i] | VALID_YN |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| LoadCombo | SprCategory_CellClick:238, SprCategory_CellClick:263, SprCategory_CellClick:302 | SpreadInfo.LoadCombo | CODE, NAME |
| DataBind | InitControls:388 | UsrComboBox.DataBind | CODE, NAME |
| SaveData | SaveButton:714 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:818 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.btnSql | Click | btnSql_Click | InitializeComponent:367 |
| this | Load | Form_Load | .ctor:158 |
| spdMain | CellClick | SpdMain_CellClick | EventInit:173 |
| spdMain | MouseMove | SpdMain_MouseMove | EventInit:174 |
| spdMail | CellClick | SprCategory_CellClick | EventInit:176 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1243 |

## 6. 컨트롤 (25개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 5 | layoutControlItem4, layoutControlItem8, layoutControlItem3, layoutControl_segment, layoutControlItem2 |
| EmptySpaceItem | 4 | emptySpaceItem1, emptySpaceItem5, emptySpaceItem2, emptySpaceItem3 |
| SplitContainer | 3 | splitContainer1, splitContainer2, splitContainer3 |
| FpSpread | 3 | spdMain, spdSMS, spdMail |
| SheetView | 3 | spdMain_Sheet1, spdSMS_Sheet1, spdMail_Sheet1 |
| UsrComboBox | 2 | cboActive, usrComboBox_Seg |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrButton | 1 | btnSql |
| UsrTextBox | 1 | usrTextBox_Seg |
| LayoutControlGroup | 1 | layoutControlGroup1 |

## 7. 확인 필요 (7건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|
| 920 | SaveData | {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 920 | SaveData | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_SAVE_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 1030 | SaveData | {?new TheOne.ServiceModel.Data.FoxDataRequest(null)}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 1030 | SaveData | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_SAVE_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 1074 | Find_Data_Main | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL")}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 1160 | Find_Data_Sub_SMS | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |
| 1199 | Find_Data_Sub_Mail | {?new TheOne.ServiceModel.Data.FoxDataRequest("SCM.SCM0006_GET_RECIPIENT_MASTER")}#{?serviceUri} | UNRESOLVED | 정적 결정 불가 — 식 확인 필요 |

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HYBRID: META(프레임워크) + HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Main, SMS, Mail
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@SetSpreadInit:553

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread_S |  | 455 | 하드코딩 | AddComboColumn | USE_TYPE_CODE | USE_TYPE_CODE | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 456 | 하드코딩 | AddComboColumn | Module* | MODULE_CODE | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 457 | 하드코딩 | AddComboColumn | Sub Module* | SUB_MODULE_CODE | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 458 | 하드코딩 | AddTextColumn | Category | CATEGORY_ID | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 459 | 하드코딩 | AddTextColumn | Category* | CATEGORY_DESC | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 460 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 462 | 하드코딩 | AddComboColumn | Main* | CYCLE_CLASS_CODE | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 463 | 하드코딩 | AddComboColumn | Sub1 | DETAIL_CLASS_CODE | if(spreadInfo.SheetName == "SMS") |
| InitSpread_S |  | 464 | 하드코딩 | AddComboColumn | Sub2 | SEND_TIME_TEXT | if(spreadInfo.SheetName == "SMS") |
| InitSpread_M |  | 501 | 하드코딩 | AddComboColumn | USE_TYPE_CODE | USE_TYPE_CODE | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 502 | 하드코딩 | AddComboColumn | Module* | MODULE_CODE | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 503 | 하드코딩 | AddComboColumn | Sub Module* | SUB_MODULE_CODE | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 504 | 하드코딩 | AddTextColumn | Category | CATEGORY_ID | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 505 | 하드코딩 | AddTextColumn | Category* | CATEGORY_DESC | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 506 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 508 | 하드코딩 | AddComboColumn | Main* | CYCLE_CLASS_CODE | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 509 | 하드코딩 | AddComboColumn | Sub1 | DETAIL_CLASS_CODE | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 510 | 하드코딩 | AddComboColumn | Sub2 | SEND_TIME_TEXT | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 511 | 하드코딩 | AddComboColumn | Sub3 | SEND_MIN_TIME_TEXT | if(spreadInfo.SheetName == "Mail") |
| InitSpread_M |  | 513 | 하드코딩 | AddButtonColumn | SQL VIEW | VIEW | if(spreadInfo.SheetName == "Mail") |
| InitializeComponent |  | 153 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 154 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 155 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 156 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 224 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 225 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 226 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 227 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 276 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 277 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 278 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 279 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Mail | 코드 하드코딩 전용(메타 없음) | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 | 11 |
| Main | 코드 하드코딩 전용(메타 없음) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |
| SMS | 코드 하드코딩 전용(메타 없음) | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 | 9 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
