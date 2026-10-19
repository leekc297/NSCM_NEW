# FP06969 화면 Fact Pack

> AsisFacts 정적 추출 결과. 본문 표는 현행(current/only) 파일 기준이며, 구버전 사본(legacy)은 CSV 에 함께 있습니다.

## 1. 파일 구성
| 구분 | 파일 | 프로젝트 | 줄수 |
|---|---|---|---:|
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06969_Distribute.UIL\FP06969_Distribute..cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06969_Distribute.UIL\FP06969_Distribute.UIL.csproj | 1573 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06969_Distribute.UIL\FP06969_Distribute..Designer.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06969_Distribute.UIL\FP06969_Distribute.UIL.csproj | 686 |
| current | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06969_Distribute.UIL\Properties\AssemblyInfo.cs | 06.UIL\GSCM.FP.Forms.UIL\Admin\FP06969_Distribute.UIL\FP06969_Distribute.UIL.csproj | 37 |

## 2. 기능 흐름 (진입점 → 메서드 → 엔드포인트)
| 진입점 | 경로 | 줄 | 엔드포인트 | 상태 | SP / SQL |
|---|---|---:|---|---|---|
| unreached:(진입점 미연결) | Save_Data_Main | 879 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Main | 879 | FP\Master\FP00460_SetupGroup#save_item_setup_group | MATCH | [update-batch]  |
| unreached:(진입점 미연결) | Save_Data_Main | 888 | biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] | BIZ_MATCH |  |
| unreached:(진입점 미연결) | Save_Data_Main | 888 | FP\Master\FP00460_SetupGroup#delete_item_setup_group | MATCH | [update-batch]  |

## 3. 엔드포인트 목록
| 엔드포인트 | 상태 | 호출 수 | SP / SQL | 참조 객체 (SP 내부 EXEC 전이 포함) | DB 보강 |
|---|---|---:|---|---|---|
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=delete_item_setup_group] | BIZ_MATCH | 1 |  |  |  |
| biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=save_item_setup_group] | BIZ_MATCH | 1 |  |  |  |
| FP\Master\FP00460_SetupGroup#delete_item_setup_group | MATCH | 1 | [update-batch]  |  |  |
| FP\Master\FP00460_SetupGroup#save_item_setup_group | MATCH | 1 | [update-batch]  |  |  |

## 4. DB 메타/데이터 컬럼 사용 (`row["COL"]`, `Field<T>("COL")`)
| 메서드 | 대상 | 컬럼 |
|---|---|---|
| DoDownload | row | CHK, PATH, shortname |
| DoUpload | row | CHK, PATH, isfolder, shortname |
| Find_Data_Main | filter | USER_ID |
| InitControls | Filter | USER_ID |
| InitControls | row | CODE, NAME |
| onDownloadMenu | row | shortname, PATH |
| onUploadMenu | row | shortname, longname |
| onUploadMenu | row.Table.Rows[0] | longname |
| Save_Data_Main | ret.Rows[0] | COUNT |
| Save_Data_Main | resRow | Result, CNT |
| spdMain_CellClick | row | status, shortname, isfolder |
| UIFindData | ds.Tables[0].Rows[0] | longname |
| UIFindData | row | parentid, PATH, isfolder, longname, shortname, hash, hash2, status, CHK, update_time, creation |
| UIFindData | each_row | nodeid |
| UIFindData | p | shortname, parentid |
| UIFindData | spdMain.ActiveSheet.Columns | CHK, shortname, longname, creation, hash, hash2, status, PATH, CMD, parentid, nodeid, nameorder, level, img |
| UIFindData | r | isfolder, status |

### 4-2. 호출하는 프레임워크 메타 소비 메서드 (DB 값으로 Grid/컨트롤 속성 결정)
| 호출 메서드 | 호출 위치 | 프레임워크 구현 | 읽는 메타 컬럼 |
|---|---|---|---|
| GetCheckedListValue | UIFindData:462, Find_Data_Main:684, onUploadMenu:998, onDownloadMenu:1084, GoDownload:1373, goUpload:1471 | CString.GetCheckedListValue | CODE |
| FP_PseudoBatch | Save_Data_Main:879, Save_Data_Main:888 | DataService.FP_PseudoBatch | COUNT, EXCEPTION, RESULT |

## 5. 이벤트 배선
| 대상 | 이벤트 | 핸들러 | 위치 |
|---|---|---|---|
| this.spdMain | CellClick | spdMain_CellClick | InitializeComponent:100 |
| this.spdMain | CellDoubleClick | SpdMain_CellDoubleClick | InitializeComponent:101 |
| this.btnDownload | Click | btnDownload_Click | InitializeComponent:197 |
| this.btnUpload | Click | btnUpload_Click_1 | InitializeComponent:234 |
| this.btnSelect | Click | btnUpload_Click | InitializeComponent:271 |
| this.btnSql | Click | btnSql_Click | InitializeComponent:345 |
| this.tvTri | NodeMouseClick | tvTri_NodeMouseClick | InitializeComponent:605 |
| this | Load | Form_Load | .ctor:110 |
| cboDomain | SelectedIndexChanged | CboServer_SelectedIndexChanged | InitEvent:131 |
| popSql | OnSql | RunSqlSource | btnSql_Click:934 |
| download | Click | onDownloadMenu | spdMain_CellClick:1176 |
| upload | Click | onUploadMenu | spdMain_CellClick:1183 |
| download | Click | onDownloadMenu | tvTri_NodeMouseClick:1552 |
| upload | Click | onUploadMenu | tvTri_NodeMouseClick:1559 |

## 6. 컨트롤 (22개, 상세는 controls.csv)
| 유형 | 개수 | 컨트롤 |
|---|---:|---|
| LayoutControlItem | 6 | lblSql, layoutControlItem2, layoutControlItem1, layoutControlItem3, layoutControlItem4, layoutControlItem5 |
| UsrButton | 4 | btnDownload, btnUpload, btnSelect, btnSql |
| FpSpread | 1 | spdMain |
| SheetView | 1 | spdMain_Sheet1 |
| UsrLayoutControl | 1 | usrLayoutControl1 |
| UsrTextBox | 1 | txtBase |
| ImageList | 1 | imageList1 |
| UsrCombo | 1 | cboDomain |
| LayoutControlGroup | 1 | layoutControlGroup1 |
| EmptySpaceItem | 1 | emptySpaceItem7 |
| Splitter | 1 | splitter1 |
| UsrConditionPanel | 1 | usrConditionPanel1 |
| UsrTriStateTreeView | 1 | tvTri |
| SplitContainer | 1 | splitContainer1 |

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

## 11. 코드로 정의된 Grid — 구성 방식: **META(프레임워크) (+코드 표시/라벨 변경)** (상세 grid_code.csv)
메타만으로는 화면이 결정되지 않습니다. 아래 코드 정의(하드코딩 컬럼, DB 루프, 분기별 표시 변경)를 메타(10장)와 함께 봐야 합니다.
- 코드에서 생성하는 시트: spdMain
- 메타 컬럼 생성 호출(프레임워크): SetSheetHeaderColumn_FP@InitSpread:248

| 메서드 | 시트(추정) | 줄 | 구분 | API | 헤더 / 값 | 필드 | 분기 조건 |
|---|---|---:|---|---|---|---|---|
| InitSpread |  | 256 | 표시/라벨 변경 | set:Visible | Visible = {?false} | MESSAGE_ID | if(spreadInfo.SheetName == "spdMain") |
| InitSpread |  | 257 | 표시/라벨 변경 | set:Visible | Visible = {?false} | EDIT_YN | if(spreadInfo.SheetName == "spdMain") |
| UIFindData | spdMain | 577 | 표시/라벨 변경 | set:Width | Width = 40 | CHK |  |
| UIFindData | spdMain | 578 | 표시/라벨 변경 | set:Width | Width = 200 | shortname |  |
| UIFindData | spdMain | 579 | 표시/라벨 변경 | set:Width | Width = 0 | longname |  |
| UIFindData | spdMain | 580 | 표시/라벨 변경 | set:Width | Width = 160 | creation |  |
| UIFindData | spdMain | 581 | 표시/라벨 변경 | set:Width | Width = 3 | hash |  |
| UIFindData | spdMain | 582 | 표시/라벨 변경 | set:Width | Width = 3 | hash2 |  |
| UIFindData | spdMain | 583 | 표시/라벨 변경 | set:Width | Width = 40 | status |  |
| UIFindData | spdMain | 584 | 표시/라벨 변경 | set:Width | Width = 300 | PATH |  |
| UIFindData | spdMain | 585 | 표시/라벨 변경 | set:Width | Width = 100 | CMD |  |
| UIFindData | spdMain | 588 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | CHK |  |
| UIFindData | spdMain | 589 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | shortname |  |
| UIFindData | spdMain | 590 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | longname |  |
| UIFindData | spdMain | 591 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | creation |  |
| UIFindData | spdMain | 592 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | hash |  |
| UIFindData | spdMain | 593 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | hash2 |  |
| UIFindData | spdMain | 594 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?CellHorizontalAlignment.Left} | status |  |
| UIFindData | spdMain | 597 | 표시/라벨 변경 | set:Width | Width = 0 | parentid |  |
| UIFindData | spdMain | 598 | 표시/라벨 변경 | set:Width | Width = 0 | nodeid |  |
| UIFindData | spdMain | 599 | 표시/라벨 변경 | set:Width | Width = 0 | nameorder |  |
| UIFindData | spdMain | 600 | 표시/라벨 변경 | set:Width | Width = 0 | level |  |
| UIFindData | spdMain | 601 | 표시/라벨 변경 | set:Width | Width = 0 | img |  |
| UIFindData | spdMain | 662 | 표시/라벨 변경 | set:Visible | Visible = {?false} |  |  |
| InitializeComponent |  | 117 | 표시/라벨 변경 | set:HorizontalAlignment | HorizontalAlignment = {?FarPoint.Win.Spread.CellHorizontalAlignment.General} |  |  |
| InitializeComponent |  | 118 | 표시/라벨 변경 | set:NoteIndicatorColor | NoteIndicatorColor = {?System.Drawing.Color.Red} |  |  |
| InitializeComponent |  | 119 | 표시/라벨 변경 | set:Parent | Parent = ColumnHeaderDefaultEnhanced |  |  |
| InitializeComponent |  | 120 | 표시/라벨 변경 | set:VerticalAlignment | VerticalAlignment = {?FarPoint.Win.Spread.CellVerticalAlignment.General} |  |  |

## 12. 최종 Grid (메타 + 코드 합성, division별 표시 컬럼 수 — 상세 grid_effective.csv)
최종 표시 = 메타(필수/기본) 또는 코드추가, 단 마지막 코드 변경이 →숨김이면 제외. `?` = 분기 조건을 정적으로 판단 못 한 건(실행 확인 필요).

| 시트 | 연결 규칙 | 40 | 81 | 81_HD | 81_HG | 81_HM | 81_ST | 81_UC | 82 | EE | EE_HD | EE_HG | EE_HM | EE_ST | EE_UC |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| spdMain | 코드 시트, 컬럼 미확인(DB루프/동적) | · | · | · | · | · | · | · | · | · | · | · | · | · | · |

연결 규칙: `META+코드연결` 메타 시트를 코드가 AddSheet/ChangeSheet 로 사용 · `메타 미연결(코드는 하드코딩)` 메타에 시트 정의가 있지만 코드는 그 이름을 쓰지 않고 Add*Column 으로 직접 구성(메타 행은 사실상 미사용) · `메타 정의만, 코드 미참조` 메타에만 있고 코드 어디서도 안 씀(폐기 후보) · `코드 하드코딩 전용` 메타 없이 코드로만 구성.
분기 조건 판단불가 적용 0건. 코드 분기는 division 변수 비교(==, Equals, StartsWith, Substring 등)만 평가합니다.
