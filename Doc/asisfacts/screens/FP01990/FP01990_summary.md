# FP01990 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.UIL.csproj | 1555 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.UIL.csproj | 718 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.UIL.csproj | 37 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\Properties\Resources.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.UIL.csproj | 64 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\Properties\Settings.Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP01990_Lookup.UIL\FP01990_Lookup.UIL.csproj | 27 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| event:this.Load | Form_Load > InitControls | 219 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 39 | biz:CommonData.YesOrNo | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| ActiveSheet_CellChanged | Filter | ACTIVE_FLAG |
| btnSql_Click | Application.OpenForms | FPC0099_SqlPopup |
| Find_Data_Amend | Filter | LOOKUP_TYPE_CODE, ACTIVE_FLAG |
| Find_Data_sub | Filter | LOOKUP_TYPE_CODE |
| SaveData | SaveFilter | LOOKUP_TYPE_CODE, LOOKUP_DESCRIPTION, SYSTEM_TYPE_CODE, ACTIVE_FLAG, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, SEGMENT1_KEY, SEGMENT2_KEY, SEGMENT3_KEY, SEGMENT4_KEY, SEGMENT5_KEY, SORT_ORDER, VALUE_DESCRIPTION |
| SpdMain_CellClick | Filter | ACTIVE_FLAG |
| SpdMain_CellDoubleClick | Filter | ACTIVE_FLAG |
| spdMain_KeyUp | Filter | ACTIVE_FLAG |
| UIFindData | Filter | ACTIVE_FLAG |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:219 | UsrComboBox.DataBind | CODE, NAME |
| EditQuery | RefreshSpreadSheet:470, RefreshSpreadSheet:475 | FPExtensions.EditQuery | ROW_ID |
| SaveData | SaveButton:525 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | KeyUp | spdMain_KeyUp | InitializeComponent:125 |
| this.usrTextBox_Att | KeyUp | usrTextBox_Att_KeyUp | InitializeComponent:231 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:271 |
| this.simpleButton1 | Click | simpleButton1_Click | InitializeComponent:388 |
| this | Load | Form_Load | .ctor:147 |
| this.spdMain | CellClick | SpdMain_CellClick | InitEvent:155 |
| this.spdMain.ActiveSheet | CellChanged | ActiveSheet_CellChanged | InitEvent:156 |
| popSql | OnSql | RunSqlSource | btnSql_Click:1458 |

## 6. 컨트롤 (32개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 9 | layoutControlItem2, layoutControlItem1, layoutControlItem5, layoutControlItem3, layoutControl_segment, layoutControlItem4, layoutControlItem6, layoutControlItem8, layoutControlItem7 |
| EmptySpaceItem | 6 | emptySpaceItem1, emptySpaceItem2, emptySpaceItem3, emptySpaceItem4, emptySpaceItem5, emptySpaceItem6 |
| UsrComboBox | 4 | cboLookupGroup, cboValid, usrComboBox_Seg, SubComboBox_param |
| UsrTextBox | 3 | usrTextBox_Att, txtLookupType, usrTextBox_Seg |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrButton | 1 | btnSql |
| SimpleButton | 1 | simpleButton1 |
| LayoutControlGroup | 1 | layoutControlGroup1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.TB_FX_Favorite | 6 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 2 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 586 | SCM.SCM0003_GET_LOOKUP_MASTER | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Lookup Type, Lookup Values

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 259 | 하드코딩 | AddTextColumn | Lookup Type Name* | LOOKUP_TYPE_CODE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 260 | 하드코딩 | AddTextColumn | Lookup Description* | LOOKUP_DESCRIPTION | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 261 | 하드코딩 | AddComboColumn | System Type Code* | SYSTEM_TYPE_CODE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 262 | 하드코딩 | AddComboColumn | Active* | ACTIVE_FLAG | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 263 | 하드코딩 | AddTextColumn | Segment1* | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Segment2* | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 265 | 하드코딩 | AddTextColumn | Segment3* | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 266 | 하드코딩 | AddTextColumn | Segment4* | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 267 | 하드코딩 | AddTextColumn | Segment5* | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 268 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 269 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 270 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 271 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 272 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 273 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 274 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 275 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 276 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 277 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 278 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 279 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 280 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 281 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 282 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 285 | 하드코딩 | AddDateTimeColumn | Last Update | MODIFY_DATE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 286 | 하드코딩 | AddTextColumn | Update ID | modify_user_id | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 298 | 하드코딩 | AddTextColumn | lookup type code* | LOOKUP_TYPE_CODE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 299 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 300 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 301 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 302 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 303 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 304 | 하드코딩 | AddComboColumn | Active | ACTIVE_FLAG | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 305 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 306 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 307 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 308 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 309 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 310 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 311 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 312 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 313 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 314 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 315 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 316 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 317 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 318 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 319 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 320 | 하드코딩 | AddTextColumn | Sort Order | SORT_ORDER | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 321 | 하드코딩 | AddTextColumn | Value Description | VALUE_DESCRIPTION | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 326 | 하드코딩 | AddDateTimeColumn | Last Update Date | MODIFY_DATE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 327 | 하드코딩 | AddTextColumn | Last Updated By | modify_user_id | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 330 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 331 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 332 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 333 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 334 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitializeComponent |  | 141 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 142 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 143 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 144 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 613 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 614 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 615 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 616 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lookup Type | 코드 하드코딩 전용(메타 없음) | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 | 26 |
| Lookup Values | 코드 하드코딩 전용(메타 없음) | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 | 31 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
