# SCP0120 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\Properties\AssemblyInfo.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\SCP0120_ConstraintMgmt.csproj | 37 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\Properties\Resources.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\SCP0120_ConstraintMgmt.csproj | 72 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\SCP0120_ConstraintMgmt.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\SCP0120_ConstraintMgmt.csproj | 1013 |
| current(sln미등록) | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\SCP0120_ConstraintMgmt.Designer.cs | 06.UIL\GSCM.SCP.Forms.UIL\Master\SCP0120_ConstraintMgmt\SCP0120_ConstraintMgmt.csproj | 437 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 399 | SCP.SCP0120_GET_LOOKUP_MASTER | MATCH | SP SCP0120_GET_LOOKUP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 399 | SCP.SCP0120_GET_LOOKUP_MASTER | MATCH | SP SCP0120_GET_LOOKUP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 438 | SCP.SCP0120_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCP0120_GET_LOOKUP_MASTER_DETAIL |
| event:this.Load | Form_Load > InitControls | 152 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 438 | SCP.SCP0120_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCP0120_GET_LOOKUP_MASTER_DETAIL |
| unreached:(진입점 미연결) | <field:dtSystem> | 35 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 36 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | GetPlanGroupByUserID | 306 | SCP.SCP0121_GET_SEARCH_INFO | MATCH | SP SCP0121_GET_SEARCH_INFO |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCP.SCP0120_GET_LOOKUP_MASTER | MATCH | 1 | SP SCP0120_GET_LOOKUP_MASTER | EXEC:SCP0120_GET_LOOKUP_MASTER, SELECT:SCP_OPMZ_LOOKUP_MASTER |  |
| SCP.SCP0120_GET_LOOKUP_MASTER_DETAIL | MATCH | 1 | SP SCP0120_GET_LOOKUP_MASTER_DETAIL | EXEC:SCP0120_GET_LOOKUP_MASTER_DETAIL, SELECT:SCP_OPMZ_LOOKUP_MASTER_DETAIL |  |
| SCP.SCP0121_GET_SEARCH_INFO | MATCH | 1 | SP SCP0121_GET_SEARCH_INFO | EXEC:SCP0121_GET_SEARCH_INFO, INSERT:#DIVISION_INFO, SELECT:SCM_MST_DIVISION, INSERT:#LINE_MASTER, SELECT:SCM_MST_LINE_SN, SELECT:SCM_MST_FACTORY_SN, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, INSERT:#OSP_PLANT_INFO, SELECT:SCM_MST_LINE_OSP, SELECT:SCM_MST_SITE, SELECT:SCM_MST_VENDOR, SELECT:#LINE_MASTER, SELECT:#DIVISION_INFO, SELECT:SCP_MST_CAPA_LINE, SELECT:#OSP_PLANT_INFO, SELECT:SCP_OPMZ_PLAN_GR_M, SELECT:SCM_ADM_LOOKUP_MASTER, SELECT:SCM_OPERATION_M_SN |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| FindData_Main | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| FindData_Sub | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |
| FindData_Sub | dtPlanGroupAll.Rows[i] | NAME |
| GetPlanGroupByUserID | TheOne.Security.FoxUserInfoContext.Current | NowGroupID |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:152 | UsrComboBox.DataBind | CODE, NAME |
| SaveData | SaveButton:369 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetCheckedListValue | FindData_Main:382 | CString.GetCheckedListValue | CODE |
| GetChanges | SaveData:634, SaveData:751 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:128 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:129 |

## 6. 컨트롤 (16개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 3 | layoutControlItem1, layoutControlItem5, layoutControlItem2 |
| FpSpread | 2 | spdMain, spdSub |
| SheetView | 2 | spdMain_Sheet1, spdSub_Sheet1 |
| UsrComboBox | 2 | cboValid, cboLookupGroup |
| SplitContainer | 1 | splitContainer1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrCheckedList2 | 1 | clbPlanGroup |
| UsrTextBox | 1 | txtLookupType |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| EmptySpaceItem | 1 | emptySpaceItem1 |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 61 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL.csv |
| dbo.SCM_ADM_LOOKUP_MASTER_DETAIL_H | 1 | dbmeta_dbo_SCM_ADM_LOOKUP_MASTER_DETAIL_H.csv |
| dbo.TB_FX_Favorite | 1 | dbmeta_dbo_TB_FX_Favorite.csv |
| dbo.TB_FX_GroupMenuAuth | 3 | dbmeta_dbo_TB_FX_GroupMenuAuth.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |
| dbo.TB_FX_SearchCondition | 4 | dbmeta_dbo_TB_FX_SearchCondition.csv |

## 9. 주석/비활성 처리된 호출 (1건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|
| 783 | SCM.SCM0003_AFTER_LOOKUP_MASTER_DETAIL | commented:MATCH |

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Lookup Type, Lookup Values

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 188 | 하드코딩 | AddTextColumn | Lookup TypeKey | LOOKUP_TYPE_KEY | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 189 | 하드코딩 | AddTextColumn | Lookup Type* | LOOKUP_TYPE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 190 | 하드코딩 | AddTextColumn | Description* | DESCRIPTION | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 191 | 하드코딩 | AddComboColumn | System* | LOOKUP_GROUP | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 192 | 하드코딩 | AddComboColumn | Valid | VALID_YN | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 193 | 하드코딩 | AddTextColumn | Segment1* | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 194 | 하드코딩 | AddTextColumn | Segment2* | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 195 | 하드코딩 | AddTextColumn | Segment3* | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 196 | 하드코딩 | AddTextColumn | Segment4* | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 197 | 하드코딩 | AddTextColumn | Segment5* | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 198 | 하드코딩 | AddTextColumn | Segment6* | SEGMENT6 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 199 | 하드코딩 | AddTextColumn | Segment7* | SEGMENT7 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 200 | 하드코딩 | AddTextColumn | Segment8* | SEGMENT8 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 201 | 하드코딩 | AddTextColumn | Segment9* | SEGMENT9 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 203 | 하드코딩 | AddComboColumn | Admin* | SEGMENT10 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 204 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 205 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 206 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 207 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 213 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 216 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 217 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 218 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Created By | CREATED_BY | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 220 | 하드코딩 | AddDateTimeColumn | Creation Date | CREATION_DATE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 222 | 하드코딩 | AddDateTimeColumn | Last Update Date | LAST_UPDATE_DATE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 234 | 하드코딩 | AddTextColumn | Lookup Type* | LOOKUP_TYPE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 235 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 236 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 237 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 238 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 239 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 240 | 하드코딩 | AddTextColumn | Segment6 | SEGMENT6 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 241 | 하드코딩 | AddTextColumn | Segment7 | SEGMENT7 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 242 | 하드코딩 | AddTextColumn | Segment8 | SEGMENT8 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 243 | 하드코딩 | AddTextColumn | Segment9 | SEGMENT9 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 244 | 하드코딩 | AddComboColumn | Valid | VALID_YN | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 245 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 246 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 247 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 248 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 249 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 250 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 251 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 252 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 253 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 254 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 255 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 256 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 257 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 258 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 259 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 260 | 하드코딩 | AddTextColumn | Display Seq | DISPLAY_SEQ | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 261 | 하드코딩 | AddTextColumn | Description | DESCRIPTION | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 262 | 하드코딩 | AddTextColumn | Created By | CREATED_BY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 263 | 하드코딩 | AddDateTimeColumn | Creation Date | CREATION_DATE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 264 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 265 | 하드코딩 | AddDateTimeColumn | Last Update Date | LAST_UPDATE_DATE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 267 | 하드코딩 | AddTextColumn | Segment10 | SEGMENT10 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 270 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 271 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 272 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 273 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 274 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 275 | 하드코딩 | AddTextColumn | Segment6 | SEGMENT6_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 276 | 하드코딩 | AddTextColumn | Segment7 | SEGMENT7_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 277 | 하드코딩 | AddTextColumn | Segment8 | SEGMENT8_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 278 | 하드코딩 | AddTextColumn | Segment9 | SEGMENT9_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 279 | 하드코딩 | AddTextColumn | Segment10 | SEGMENT10_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitializeComponent |  | 116 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 117 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 118 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 119 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 344 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 345 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 346 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 347 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lookup Type | 코드 하드코딩 전용(메타 없음) | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 | 34 |
| Lookup Values | 코드 하드코딩 전용(메타 없음) | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 | 43 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
