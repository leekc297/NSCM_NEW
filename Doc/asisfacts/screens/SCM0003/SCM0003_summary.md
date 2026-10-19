# SCM0003 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0003_Lookup.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 838 |
| only | 06.UIL\GSCM.SCM.Master.UIL\SCM0003_Lookup.Designer.cs | 06.UIL\GSCM.SCM.Master.UIL\GSCM.SCM.Master.UIL.csproj | 376 |
| only | 06.UIL\GSCM.SCM.Popup.UIL\SCM0003_ProductionCapacityInsertPopup.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 319 |
| only | 06.UIL\GSCM.SCM.Popup.UIL\SCM0003_ProductionCapacityInsertPopup.Designer.cs | 06.UIL\GSCM.SCM.Popup.UIL\GSCM.SCM.Popup.UIL.csproj | 288 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| button:FindButton | FindButton > FindData_Main | 320 | SCM.SCM0003_GET_LOOKUP_MASTER | MATCH | SP SCM0003_GET_LOOKUP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData_Main | 320 | SCM.SCM0003_GET_LOOKUP_MASTER | MATCH | SP SCM0003_GET_LOOKUP_MASTER |
| button:SaveButton | SaveButton > SaveData > FindData_Sub | 359 | SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCM0003_GET_LOOKUP_MASTER_DETAIL |
| button:SaveButton | SaveButton > SaveData > DoAfterSave | 633 | SCM.SCM0003_AFTER_LOOKUP_MASTER_DETAIL | MATCH | SP SCM0003_AFTER_LOOKUP_MASTER_DETAIL |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 278 | biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH |  |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 281 | biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH |  |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 290 | biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH |  |
| event:spdMain.ComboSelChange | SpdMain_ComboSelChange | 300 | biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 133 | biz:CommonData.CommonDataList [code=System] | BIZ_MATCH |  |
| event:this.Load | Form_Load > InitControls | 134 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| event:this.spdMain.CellDoubleClick | SpdMain_CellDoubleClick > FindData_Sub | 359 | SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | SP SCM0003_GET_LOOKUP_MASTER_DETAIL |
| unreached:(진입점 미연결) | <field:dtSystem> | 33 | biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtYesOrNo> | 34 | biz:CommonData.YesOrNo | BIZ_MATCH |  |
| unreached:(진입점 미연결) | <field:dtMyDivision> | 43 | biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH |  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:CommonData.CommonDataList [code=BuildingByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_FACTORY_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LineByOperation] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=LookupCommon] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.CommonDataList [code=MyDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_DIVISION, UP_FX_GetCommonDataList:SELECT:TB_FX_USERGROUPAUTHEXTENTION |
| biz:CommonData.CommonDataList [code=OperationByBuilding] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_LINE_SN, UP_FX_GetCommonDataList:SELECT:SCM_MST_OPERATION_SN, UP_FX_GetCommonDataList:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=PlantSiteByDivision] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList:REF:STRING_SPLIT, UP_FX_GetCommonDataList_SCP:SELECT:SCM_MST_SITE, UP_FX_GetCommonDataList_SCP:REF:STRING_SPLIT |
| biz:CommonData.CommonDataList [code=System] | BIZ_MATCH | 1 |  |  | 코드분기 UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER, UP_FX_GetCommonDataList:SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |
| biz:CommonData.YesOrNo | BIZ_MATCH | 2 |  |  |  |
| SCM.SCM0003_AFTER_LOOKUP_MASTER_DETAIL | MATCH | 1 | SP SCM0003_AFTER_LOOKUP_MASTER_DETAIL | EXEC:SCM0003_AFTER_LOOKUP_MASTER_DETAIL, EXEC:PR_SCM_SYS_LOG_BATCH, INSERT:SCM_SYS_LOG_BATCH |  |
| SCM.SCM0003_GET_LOOKUP_MASTER | MATCH | 1 | SP SCM0003_GET_LOOKUP_MASTER | EXEC:SCM0003_GET_LOOKUP_MASTER, SELECT:SCM_ADM_LOOKUP_MASTER |  |
| SCM.SCM0003_GET_LOOKUP_MASTER_DETAIL | MATCH | 1 | SP SCM0003_GET_LOOKUP_MASTER_DETAIL | EXEC:SCM0003_GET_LOOKUP_MASTER_DETAIL, SELECT:SCM_ADM_LOOKUP_MASTER_DETAIL |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| <field:dtMyDivision> | UserInfoContext.Current | NowGroupID |
| DoAfterSave | ds.Tables[0].Rows[0] | result_code |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| DataBind | InitControls:133, InitControls:134 | UsrComboBox.DataBind | CODE, NAME |
| SaveData | SaveButton:298 | PersonalSettingPopup.SaveData | DefaultGroupID, Default_GroupID, Language, TimeZone, USER_ID |
| GetChanges | SaveData:494, SaveData:601 | FPExtensions.GetChanges | ROW_ID |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this | Load | Form_Load | .ctor:111 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | .ctor:112 |
| this | Load | Form_Load | .ctor:83 |
| this.btnButtonList | UsrButtonList_Click_Detected | BtnButtonList_UsrButtonList_Click_Detected | .ctor:84 |
| spdMain | ComboSelChange | SpdMain_ComboSelChange | .ctor:85 |

## 6. 컨트롤 (26개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlGroup | 4 | layoutControlGroup1, layoutControlGroup1, layoutControlGroup2, Root |
| LayoutControlItem | 4 | layoutControlItem1, layoutControlItem5, layoutControlItem2, layoutControlItem3 |
| FpSpread | 3 | spdMain, spdSub, spdMain |
| SheetView | 3 | spdMain_Sheet1, spdSub_Sheet1, spdMain_Sheet1 |
| UsrLayoutControl | 3 | usrLayoutControl1, usrLayoutControl1, usrLayoutControl2 |
| UsrConditionPanel | 2 | usrConditionPanel1, usrConditionPanel1 |
| UsrComboBox | 2 | cboLookupGroup, cboValid |
| EmptySpaceItem | 2 | emptySpaceItem1, emptySpaceItem1 |
| SplitContainer | 1 | splitContainer1 |
| UsrTextBox | 1 | txtLookupType |
| UsrButtonList | 1 | btnButtonList |

## 7. 확인 필요 (0건)
| 줄 | 메서드 | 값 | 상태 | 비고 |
|---:|---|---|---|---|

## 8. DB 메타 데이터 (화면ID가 값으로 들어있는 메타 테이블 행)
| 메타 테이블 | 행 수 | 파일 |
|---|---:|---|
| dbo.SCM_ADM_DB_SCRIPT_BACKUP | 26 | dbmeta_dbo_SCM_ADM_DB_SCRIPT_BACKUP.csv |
| dbo.TB_FX_MenuItemInfo | 1 | dbmeta_dbo_TB_FX_MenuItemInfo.csv |
| dbo.TB_FX_ProgramInfo | 1 | dbmeta_dbo_TB_FX_ProgramInfo.csv |

## 9. 주석/비활성 처리된 호출 (0건, 활성 집계 제외)
| 줄 | 값 | 상태 |
|---:|---|---|

## 10. Division별 Grid 정의
메타 테이블에 이 화면 PROGRAM_ID 행이 없습니다.

## 11. 코드로 정의된 Grid — 구성 방식: **HARDCODED (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: Lookup Type, Lookup Values, Production Capacity Inert

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 167 | 하드코딩 | AddTextColumn | Lookup TypeKey | LOOKUP_TYPE_KEY | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 168 | 하드코딩 | AddTextColumn | Lookup Type* | LOOKUP_TYPE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 169 | 하드코딩 | AddTextColumn | Description* | DESCRIPTION | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 170 | 하드코딩 | AddComboColumn | System* | LOOKUP_GROUP | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 171 | 하드코딩 | AddComboColumn | Valid | VALID_YN | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 172 | 하드코딩 | AddTextColumn | Segment1* | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 173 | 하드코딩 | AddTextColumn | Segment2* | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 174 | 하드코딩 | AddTextColumn | Segment3* | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 175 | 하드코딩 | AddTextColumn | Segment4* | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 176 | 하드코딩 | AddTextColumn | Segment5* | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 177 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 178 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 179 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 180 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 181 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 182 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 183 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 184 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 185 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 186 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 187 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 188 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 189 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 190 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 191 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 192 | 하드코딩 | AddTextColumn | Created By | CREATED_BY | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 193 | 하드코딩 | AddDateTimeColumn | Creation Date | CREATION_DATE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 194 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 195 | 하드코딩 | AddDateTimeColumn | Last Update Date | LAST_UPDATE_DATE | if(spreadInfo.SheetName == "Lookup Type") |
| InitSpread |  | 207 | 하드코딩 | AddTextColumn | Lookup Type* | LOOKUP_TYPE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 208 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 209 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 210 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 211 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 212 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 213 | 하드코딩 | AddComboColumn | Valid | VALID_YN | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 214 | 하드코딩 | AddTextColumn | Attribute1 | ATTRIBUTE1 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 215 | 하드코딩 | AddTextColumn | Attribute2 | ATTRIBUTE2 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 216 | 하드코딩 | AddTextColumn | Attribute3 | ATTRIBUTE3 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 217 | 하드코딩 | AddTextColumn | Attribute4 | ATTRIBUTE4 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 218 | 하드코딩 | AddTextColumn | Attribute5 | ATTRIBUTE5 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 219 | 하드코딩 | AddTextColumn | Attribute6 | ATTRIBUTE6 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 220 | 하드코딩 | AddTextColumn | Attribute7 | ATTRIBUTE7 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 221 | 하드코딩 | AddTextColumn | Attribute8 | ATTRIBUTE8 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 222 | 하드코딩 | AddTextColumn | Attribute9 | ATTRIBUTE9 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 223 | 하드코딩 | AddTextColumn | Attribute10 | ATTRIBUTE10 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 224 | 하드코딩 | AddTextColumn | Attribute11 | ATTRIBUTE11 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 225 | 하드코딩 | AddTextColumn | Attribute12 | ATTRIBUTE12 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 226 | 하드코딩 | AddTextColumn | Attribute13 | ATTRIBUTE13 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 227 | 하드코딩 | AddTextColumn | Attribute14 | ATTRIBUTE14 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 228 | 하드코딩 | AddTextColumn | Attribute15 | ATTRIBUTE15 | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 229 | 하드코딩 | AddTextColumn | Desplay Seq | DISPLAY_SEQ | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 230 | 하드코딩 | AddTextColumn | Description | DESCRIPTION | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 231 | 하드코딩 | AddTextColumn | Created By | CREATED_BY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 232 | 하드코딩 | AddDateTimeColumn | Creation Date | CREATION_DATE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 233 | 하드코딩 | AddTextColumn | Last Updated By | LAST_UPDATED_BY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 234 | 하드코딩 | AddDateTimeColumn | Last Update Date | LAST_UPDATE_DATE | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 237 | 하드코딩 | AddTextColumn | Segment1 | SEGMENT1_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 238 | 하드코딩 | AddTextColumn | Segment2 | SEGMENT2_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 239 | 하드코딩 | AddTextColumn | Segment3 | SEGMENT3_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 240 | 하드코딩 | AddTextColumn | Segment4 | SEGMENT4_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitSpread |  | 241 | 하드코딩 | AddTextColumn | Segment5 | SEGMENT5_KEY | if(spreadInfo.SheetName == "Lookup Values") |
| InitializeComponent |  | 110 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 111 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 112 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 113 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitializeComponent |  | 302 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 303 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 304 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 305 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |
| InitSpread |  | 125 | 하드코딩 | AddComboColumn | Division* | DIVISION_ID |  |
| InitSpread |  | 126 | 하드코딩 | AddComboColumn | Plant Site* | SCM_SITE_ID |  |
| InitSpread |  | 127 | 하드코딩 | AddComboColumn | Building* | FACTORY_ID |  |
| InitSpread |  | 128 | 하드코딩 | AddComboColumn | Operation* | OPERATION_ID |  |
| InitSpread |  | 129 | 하드코딩 | AddComboColumn | Line* | LINE_ID |  |
| InitSpread |  | 130 | 하드코딩 | AddTextColumn | Project* | PROJECT_ID |  |
| InitSpread |  | 131 | 하드코딩 | AddTextColumn | Model* | ITEM_ID |  |
| InitializeComponent |  | 224 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 225 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 226 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 227 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Lookup Type | 코드 하드코딩 전용(메타 없음) | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 | 29 |
| Lookup Values | 코드 하드코딩 전용(메타 없음) | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 | 33 |
| Production Capacity Inert | 코드 하드코딩 전용(메타 없음) | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | 7 |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
