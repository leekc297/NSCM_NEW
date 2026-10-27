# AS-IS 액션 대조표 — SCM0004

> 원천: `Doc/asisfacts/screens/SCM0004/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 425행 · 메서드 24 · 종류 DATA_OP 153 · GRID_INIT 146 · ENDPOINT 24 · GRID_LOCK 20 · FLAG 18 · RETURN 18 · UI_MISC 10 · COMBO_DATA 10 · GRID_SET 6 · MESSAGE 6 · CALL_EXT 4 · GRID_BIND 4 · VALIDATE 4 · LIST_REBIND 2 · ⚠ 의미 확인 필요 4


## SCM0004_UICategorySetup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7aaa7bf2 | this.Load | SCM0004_UICategorySetup.cs:172 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtColumn, SpdSheet.shtColumn, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0d748bf | this.Load | SCM0004_UICategorySetup.cs:173 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-b87dc03f | this.Load | SCM0004_UICategorySetup.cs:175 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMeasure, SpdSheet.shtMeasure, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e26dccd | this.Load | SCM0004_UICategorySetup.cs:176 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-dc9b0602 | this.Load | SCM0004_UICategorySetup.cs:178 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0004_UICategorySetup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acc1c107 | Dispose | SCM0004_UICategorySetup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0004_UICategorySetup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cd35432 | EditButton | SCM0004_UICategorySetup.cs:312 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4aa21d0e | EditButton | SCM0004_UICategorySetup.cs:314 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-57d42e82 | EditButton | SCM0004_UICategorySetup.cs:315 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Column.Program_ID), siMain.GetColumnIndex(DefCols_Column.Sh… | 그리드 편집 잠금/해제 |  |  |  |
| AC-af58f48b | EditButton | SCM0004_UICategorySetup.cs:316 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Column.Created_By), siMain.GetColumnIndex(DefCols_Column.La… | 그리드 편집 잠금/해제 |  |  |  |
| AC-cfdc2632 | EditButton | SCM0004_UICategorySetup.cs:318 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ac0a8b40 | EditButton | SCM0004_UICategorySetup.cs:320 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b9c7a7ea | EditButton | SCM0004_UICategorySetup.cs:321 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Measure.Program_ID), siMain.GetColumnIndex(DefCols_Measure.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-702f4c33 | EditButton | SCM0004_UICategorySetup.cs:322 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Measure.Created_By), siMain.GetColumnIndex(DefCols_Measure.… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0004_UICategorySetup.Find_Column

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e8e45bf | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:346 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtColumn) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11517cd9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:355 |  | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ea24dc3 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:359 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8acf1fd5 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:361 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_GET_UI_CATEGORY_SETUP_COLUMN") ⇒ SCM.SCM0004_GET_UI_CATEGORY_SETUP_COLUMN | 엔드포인트 요청 생성 |  |  |  |
| AC-39f8c16d | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:362 | lambda | DATA_OP | req.Parameters["p_program_id"] | ProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-f26010cb | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:363 | lambda | DATA_OP | req.Parameters["p_sheet_name"] | SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-9e753658 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:364 | lambda | DATA_OP | req.Parameters["p_column_name"] | ColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-000b9c3e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:365 | lambda | DATA_OP | req.Parameters["p_colmum_lavel_name"] | ColumnLabelName | 행/컬럼 값 대입 |  |  |  |
| AC-ccfe5195 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:366 | lambda | DATA_OP | req.Parameters["p_default_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-57f79ca6 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:367 | lambda | DATA_OP | req.Parameters["p_valid_yn"] | Valid | 행/컬럼 값 대입 |  |  |  |
| AC-0b09852f | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:369 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b8d3e481 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:370 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d45cc297 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:374 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-28701600 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:375 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fb46e680 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:377 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-225cc75e | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004_UICategorySetup.cs:378 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004_UICategorySetup.Find_Measure

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bfe0d9d | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:387 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMeasure) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9e2fbee5 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:396 |  | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0bd4104 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:399 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df19c7d0 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:401 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE") ⇒ SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | 엔드포인트 요청 생성 |  |  |  |
| AC-16981fd8 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:402 | lambda | DATA_OP | req.Parameters["p_program_id"] | ProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-56744be2 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:403 | lambda | DATA_OP | req.Parameters["p_sheet_name"] | SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-795c8089 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:404 | lambda | DATA_OP | req.Parameters["p_column_name"] | ColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-26da9835 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:405 | lambda | DATA_OP | req.Parameters["p_colmum_lavel_name"] | ColumnLabelName | 행/컬럼 값 대입 |  |  |  |
| AC-7abbc46b | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:406 | lambda | DATA_OP | req.Parameters["p_default_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-bbdd03e0 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:407 | lambda | DATA_OP | req.Parameters["p_valid_yn"] | Valid | 행/컬럼 값 대입 |  |  |  |
| AC-a5a72bda | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:409 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e2829d3a | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:410 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-55c64711 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:414 |  | GRID_BIND | siMain.Query | (tran) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ccea323e | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:415 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2caa1eba | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:417 |  | UI_MISC | SetSearchCount | (tran) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-916500d8 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:418 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004_UICategorySetup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73b7ed5d | this.Load | SCM0004_UICategorySetup.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0004_UICategorySetup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ab5c5d4 | this.Load | SCM0004_UICategorySetup.cs:159 |  | FLAG | dtYesOrNo | Data.Common(Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 화면 필드/플래그 변경 |  |  |  |
| AC-f584a18d | this.Load | SCM0004_UICategorySetup.cs:159 |  | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecf997b5 | this.Load | SCM0004_UICategorySetup.cs:162 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, false) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-be91a8b3 | this.Load | SCM0004_UICategorySetup.cs:164 |  | FLAG | dtDataSortMethod | Data.CallBizCommonData("DATA_SORT_METHOD") ⇒ biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | 화면 필드/플래그 변경 |  |  |  |
| AC-6bbca4d3 | this.Load | SCM0004_UICategorySetup.cs:164 |  | COMBO_DATA | Data.CallBizCommonData | ("DATA_SORT_METHOD") ⇒ biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-542d7c30 | this.Load | SCM0004_UICategorySetup.cs:165 |  | FLAG | dtDefaultFlag | Data.CallBizCommonData("DEFAULT_FLAG") ⇒ biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | 화면 필드/플래그 변경 |  |  |  |
| AC-718cda98 | this.Load | SCM0004_UICategorySetup.cs:165 |  | COMBO_DATA | Data.CallBizCommonData | ("DEFAULT_FLAG") ⇒ biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-797b4b0f | this.Load | SCM0004_UICategorySetup.cs:167 |  | FLAG | dtCellObject | Data.CallBizCommonData("CELL_CONTROL_OBJECT_TYPE_CODE") ⇒ biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f63182a | this.Load | SCM0004_UICategorySetup.cs:167 |  | COMBO_DATA | Data.CallBizCommonData | ("CELL_CONTROL_OBJECT_TYPE_CODE") ⇒ biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94546edf | this.Load | SCM0004_UICategorySetup.cs:168 |  | FLAG | dtHorizontalAlign | Data.CallBizCommonData("HORIZONTAL_ALIGN_CODE") ⇒ biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-03d89a73 | this.Load | SCM0004_UICategorySetup.cs:168 |  | COMBO_DATA | Data.CallBizCommonData | ("HORIZONTAL_ALIGN_CODE") ⇒ biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCM0004_UICategorySetup.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-851d8816 | this.Load 외 2 | SCM0004_UICategorySetup.cs:217 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1b75507c | this.Load 외 2 | SCM0004_UICategorySetup.cs:219 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1280dd61 | this.Load 외 2 | SCM0004_UICategorySetup.cs:220 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("ProgramID* ", DefCols_Column.Program_ID, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ad023e1 | this.Load 외 2 | SCM0004_UICategorySetup.cs:221 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Program Name ", DefCols_Column.Program_Name, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7126971 | this.Load 외 2 | SCM0004_UICategorySetup.cs:222 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Sheet Name*", DefCols_Column.Sheet_Name, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63d2aef3 | this.Load 외 2 | SCM0004_UICategorySetup.cs:223 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Name* ", DefCols_Column.Column_Name, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14eaed0a | this.Load 외 2 | SCM0004_UICategorySetup.cs:224 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Label Name*", DefCols_Column.Column_Label_Name, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c10e0680 | this.Load 외 2 | SCM0004_UICategorySetup.cs:225 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Sort Order No*", DefCols_Column.Sort_Order_No, FPMerge.None, 110, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0694a219 | this.Load 외 2 | SCM0004_UICategorySetup.cs:226 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Data Sort Method", DefCols_Column.Data_Sort_Method_Code, FPMerge.None, 140, true, dtData… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-066f40d4 | this.Load 외 2 | SCM0004_UICategorySetup.cs:227 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Small Label", DefCols_Column.Small_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cdfd5a51 | this.Load 외 2 | SCM0004_UICategorySetup.cs:228 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Large Label", DefCols_Column.Large_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-964a2909 | this.Load 외 2 | SCM0004_UICategorySetup.cs:229 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Fixed", DefCols_Column.Fixed, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d53c3926 | this.Load 외 2 | SCM0004_UICategorySetup.cs:230 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Width*", DefCols_Column.Column_Width, FPMerge.None, 95, true, FPHAlign.Right, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-701d2848 | this.Load 외 2 | SCM0004_UICategorySetup.cs:231 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Cell Object", DefCols_Column.Cell_Control_Object_Type_Code, FPMerge.None, 185, true, dtC… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95fc4266 | this.Load 외 2 | SCM0004_UICategorySetup.cs:232 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Cell Combo Data Type", DefCols_Column.CELL_COMBO_DATA_TYPE, FPMerge.None, 185, true, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09518e83 | this.Load 외 2 | SCM0004_UICategorySetup.cs:233 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Data Scale Num", DefCols_Column.Data_Scale_Number, FPMerge.None, 120, true, FPHAlign.Rig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-567a1ce0 | this.Load 외 2 | SCM0004_UICategorySetup.cs:234 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Data Max Length", DefCols_Column.Data_Max_Length, FPMerge.None, 110, true, FPHAlign.Righ… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6bc497fa | this.Load 외 2 | SCM0004_UICategorySetup.cs:235 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Horizontal Align*", DefCols_Column.Horizontal_Align_Code, FPMerge.None, 130, true, dtHor… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d2d1a8a | this.Load 외 2 | SCM0004_UICategorySetup.cs:236 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Uppercase Apply", DefCols_Column.Uppercase_Apply_Flag, FPMerge.None, 100, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04205fad | this.Load 외 2 | SCM0004_UICategorySetup.cs:237 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Visible*", DefCols_Column.Visible_Flag, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-994f8ffb | this.Load 외 2 | SCM0004_UICategorySetup.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("User Visible Flag", DefCols_Column.User_Visible_Flag, FPMerge.None, 100, true, dtYesOrNo… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66123c10 | this.Load 외 2 | SCM0004_UICategorySetup.cs:239 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Default", DefCols_Column.Default_Flag, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac984eae | this.Load 외 2 | SCM0004_UICategorySetup.cs:240 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("User Selected Flag", DefCols_Column.USER_SELECTABLE_FLAG, FPMerge.None, 100, true, dtYes… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6614d92d | this.Load 외 2 | SCM0004_UICategorySetup.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Division", DefCols_Column.DIVISION_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f97480f | this.Load 외 2 | SCM0004_UICategorySetup.cs:242 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid*", DefCols_Column.Valid, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b393495e | this.Load 외 2 | SCM0004_UICategorySetup.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param1", DefCols_Column.Attribute1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b438d85b | this.Load 외 2 | SCM0004_UICategorySetup.cs:244 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param2", DefCols_Column.Attribute2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7559f87e | this.Load 외 2 | SCM0004_UICategorySetup.cs:245 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param3", DefCols_Column.Attribute3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72cdfae9 | this.Load 외 2 | SCM0004_UICategorySetup.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param4", DefCols_Column.Attribute4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ec555c5 | this.Load 외 2 | SCM0004_UICategorySetup.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param5", DefCols_Column.Attribute5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f26aa6a | this.Load 외 2 | SCM0004_UICategorySetup.cs:248 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefCols_Column.Created_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4002cb52 | this.Load 외 2 | SCM0004_UICategorySetup.cs:249 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefCols_Column.Creation_Date, FPMerge.None, 165, true , FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-afdd4e72 | this.Load 외 2 | SCM0004_UICategorySetup.cs:250 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefCols_Column.Last_Updated_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48a7d11a | this.Load 외 2 | SCM0004_UICategorySetup.cs:251 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefCols_Column.Last_Update_Date, FPMerge.None, 165, true, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf38bdf8 | this.Load 외 2 | SCM0004_UICategorySetup.cs:253 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefCols_Column.Column_Name) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e34e8b65 | this.Load 외 2 | SCM0004_UICategorySetup.cs:257 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-67932fe7 | this.Load 외 2 | SCM0004_UICategorySetup.cs:259 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1ae6a629 | this.Load 외 2 | SCM0004_UICategorySetup.cs:260 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ProgramID* ", DefCols_Measure.Program_ID, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e8bde1c8 | this.Load 외 2 | SCM0004_UICategorySetup.cs:261 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Program Name ", DefCols_Measure.Program_Name, FPMerge.None, 200, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-039ed40d | this.Load 외 2 | SCM0004_UICategorySetup.cs:262 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Sheet Name*", DefCols_Measure.Sheet_Name, FPMerge.None, 175, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6c25d02 | this.Load 외 2 | SCM0004_UICategorySetup.cs:263 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Name* ", DefCols_Measure.Column_Name, FPMerge.None, 175, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f505bdd1 | this.Load 외 2 | SCM0004_UICategorySetup.cs:264 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Label Name*", DefCols_Measure.Column_Label_Name, FPMerge.None, 175, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-726dcad4 | this.Load 외 2 | SCM0004_UICategorySetup.cs:265 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Sort Order No*", DefCols_Measure.Sort_Order_No, FPMerge.None, 110, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4894e13 | this.Load 외 2 | SCM0004_UICategorySetup.cs:266 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Small Label", DefCols_Measure.Small_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3f57549 | this.Load 외 2 | SCM0004_UICategorySetup.cs:267 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Large Label", DefCols_Measure.Large_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-750aa7d8 | this.Load 외 2 | SCM0004_UICategorySetup.cs:269 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Measure Color", DefCols_Measure.MEASURE_COLOR, FPMerge.None, 120, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cae300d | this.Load 외 2 | SCM0004_UICategorySetup.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("Default Flag", DefCols_Measure.Default_Flag, FPMerge.None, 90, true, dtYesOrNo, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7442f2f | this.Load 외 2 | SCM0004_UICategorySetup.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("User Selected Flag", DefCols_Measure.USER_SELECTABLE_FLAG, FPMerge.None, 100, true, dtYe… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa713ad0 | this.Load 외 2 | SCM0004_UICategorySetup.cs:274 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Division", DefCols_Measure.DIVISION_ID , FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cb070ee4 | this.Load 외 2 | SCM0004_UICategorySetup.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid*", DefCols_Measure.Valid, FPMerge.None, 90, true, dtYesOrNo, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-353c6787 | this.Load 외 2 | SCM0004_UICategorySetup.cs:278 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ATTRIBUTE1", DefCols_Measure.ATTRIBUTE1, FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f8e95b0 | this.Load 외 2 | SCM0004_UICategorySetup.cs:279 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ATTRIBUTE2", DefCols_Measure.ATTRIBUTE2, FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f4ef17e | this.Load 외 2 | SCM0004_UICategorySetup.cs:280 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ATTRIBUTE4", DefCols_Measure.ATTRIBUTE4, FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a11dedc | this.Load 외 2 | SCM0004_UICategorySetup.cs:281 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Result Mapping (ATTRIBUTE5)", DefCols_Measure.ATTRIBUTE5, FPMerge.None, 90, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36d8cea7 | this.Load 외 2 | SCM0004_UICategorySetup.cs:282 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Plan Mapping (ATTRIBUTE6)", DefCols_Measure.ATTRIBUTE6, FPMerge.None, 90, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8c3a01d4 | this.Load 외 2 | SCM0004_UICategorySetup.cs:283 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("Section Create YN (ATTRIBUTE7)", DefCols_Measure.ATTRIBUTE7, FPMerge.None, 110, true, dt… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5af88911 | this.Load 외 2 | SCM0004_UICategorySetup.cs:284 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ATTRIBUTE8", DefCols_Measure.ATTRIBUTE8, FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d4d2864 | this.Load 외 2 | SCM0004_UICategorySetup.cs:285 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ATTRIBUTE9", DefCols_Measure.ATTRIBUTE9, FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a16e289 | this.Load 외 2 | SCM0004_UICategorySetup.cs:286 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ATTRIBUTE10", DefCols_Measure.ATTRIBUTE10, FPMerge.None, 90, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-821cd680 | this.Load 외 2 | SCM0004_UICategorySetup.cs:289 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefCols_Measure.Created_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-176e07d4 | this.Load 외 2 | SCM0004_UICategorySetup.cs:290 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefCols_Measure.Creation_Date, FPMerge.None, 165, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15281dc3 | this.Load 외 2 | SCM0004_UICategorySetup.cs:291 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefCols_Measure.Last_Updated_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3878edc | this.Load 외 2 | SCM0004_UICategorySetup.cs:292 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefCols_Measure.Last_Update_Date, FPMerge.None, 165, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-894518bd | this.Load 외 2 | SCM0004_UICategorySetup.cs:294 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefCols_Measure.Column_Name) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004_UICategorySetup.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe31cf5e | InsertButton | SCM0004_UICategorySetup.cs:431 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1edc5250 | InsertButton | SCM0004_UICategorySetup.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Data_Sort_Method_Code, "ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d6110e2 | InsertButton | SCM0004_UICategorySetup.cs:434 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Cell_Control_Object_Type_Code, "FPText") | 데이터 객체 조작/조회 |  |  |  |
| AC-82054df1 | InsertButton | SCM0004_UICategorySetup.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Visible_Flag, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-4abf8538 | InsertButton | SCM0004_UICategorySetup.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Default_Flag, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c6684c1 | InsertButton | SCM0004_UICategorySetup.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Valid, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac24b3e3 | InsertButton | SCM0004_UICategorySetup.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Horizontal_Align_Code, "C") | 데이터 객체 조작/조회 |  |  |  |
| AC-83432f25 | InsertButton | SCM0004_UICategorySetup.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Column_Width, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-d8c31db1 | InsertButton | SCM0004_UICategorySetup.cs:441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Data_Scale_Number, null) | 데이터 객체 조작/조회 |  |  |  |
| AC-cafd09f0 | InsertButton | SCM0004_UICategorySetup.cs:442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Data_Max_Length, null) | 데이터 객체 조작/조회 |  |  |  |
| AC-e43a4655 | InsertButton | SCM0004_UICategorySetup.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-4af74cac | InsertButton | SCM0004_UICategorySetup.cs:446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCols_Column.Created_By), siMain.GetColumnIndex(DefCols_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fdeb35f5 | InsertButton | SCM0004_UICategorySetup.cs:449 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cefae2b3 | InsertButton | SCM0004_UICategorySetup.cs:451 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | DATA_OP | defaultData.Add | (DefCols_Measure.Default_Flag, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a8b5a95 | InsertButton | SCM0004_UICategorySetup.cs:452 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | DATA_OP | defaultData.Add | (DefCols_Measure.Valid, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-99d21b74 | InsertButton | SCM0004_UICategorySetup.cs:453 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-91941949 | InsertButton | SCM0004_UICategorySetup.cs:455 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCols_Measure.Created_By), siMain.GetColumnIndex(DefCols… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0004_UICategorySetup.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d236a463 | SaveButton | SCM0004_UICategorySetup.cs:464 | if (siMain.SheetName == SpdSheet.shtColumn) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8ed2a655 | SaveButton | SCM0004_UICategorySetup.cs:465 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-22813151 | SaveButton | SCM0004_UICategorySetup.cs:558 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN") ⇒ SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | 엔드포인트 요청 생성 |  |  |  |
| AC-7185bb00 | SaveButton | SCM0004_UICategorySetup.cs:561 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9fc717a1 | SaveButton | SCM0004_UICategorySetup.cs:563 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-863f375a | SaveButton | SCM0004_UICategorySetup.cs:564 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab3ad1e1 | SaveButton | SCM0004_UICategorySetup.cs:565 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-b5da5856 | SaveButton | SCM0004_UICategorySetup.cs:566 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_name"] | p_column_name | 행/컬럼 값 대입 |  |  |  |
| AC-7943931d | SaveButton | SCM0004_UICategorySetup.cs:567 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_label_name"] | p_column_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-8468de4e | SaveButton | SCM0004_UICategorySetup.cs:568 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sort_order_no"] | p_sort_order_no | 행/컬럼 값 대입 |  |  |  |
| AC-38578ede | SaveButton | SCM0004_UICategorySetup.cs:569 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_data_sort_method_code"] | p_data_sort_method_code | 행/컬럼 값 대입 |  |  |  |
| AC-a4e1b3b6 | SaveButton | SCM0004_UICategorySetup.cs:570 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_small_class_label_name"] | p_small_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-3dae19df | SaveButton | SCM0004_UICategorySetup.cs:571 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_large_class_label_name"] | p_large_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-9badff94 | SaveButton | SCM0004_UICategorySetup.cs:572 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_fixed_flag"] | p_fixed_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e603d7e3 | SaveButton | SCM0004_UICategorySetup.cs:573 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_width"] | p_column_width | 행/컬럼 값 대입 |  |  |  |
| AC-408e5492 | SaveButton | SCM0004_UICategorySetup.cs:574 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_control_object_type_code"] | p_cell_control_object_type_code | 행/컬럼 값 대입 |  |  |  |
| AC-ff46119e | SaveButton | SCM0004_UICategorySetup.cs:575 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_combo_data_type"] | p_cell_combo_data_type | 행/컬럼 값 대입 |  |  |  |
| AC-21629efb | SaveButton | SCM0004_UICategorySetup.cs:576 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_data_scale_number"] | p_data_scale_number | 행/컬럼 값 대입 |  |  |  |
| AC-81df8184 | SaveButton | SCM0004_UICategorySetup.cs:577 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_data_max_length"] | p_data_max_length | 행/컬럼 값 대입 |  |  |  |
| AC-ee7a0fbb | SaveButton | SCM0004_UICategorySetup.cs:578 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_horizontal_align_code"] | p_horizontal_align_code | 행/컬럼 값 대입 |  |  |  |
| AC-c0257bad | SaveButton | SCM0004_UICategorySetup.cs:579 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_uppercase_apply_flag"] | p_uppercase_apply_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e105e87d | SaveButton | SCM0004_UICategorySetup.cs:580 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_visible_flag"] | p_visible_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6a7c634c | SaveButton | SCM0004_UICategorySetup.cs:581 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_default_flag"] | p_default_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3040dd41 | SaveButton | SCM0004_UICategorySetup.cs:582 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_selectable_flag"] | p_user_selectable_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5bbadcb2 | SaveButton | SCM0004_UICategorySetup.cs:583 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ad005c58 | SaveButton | SCM0004_UICategorySetup.cs:584 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-02f3e720 | SaveButton | SCM0004_UICategorySetup.cs:585 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute1"] | p_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-3358671a | SaveButton | SCM0004_UICategorySetup.cs:586 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute2"] | p_attribute2 | 행/컬럼 값 대입 |  |  |  |
| AC-fa1677e2 | SaveButton | SCM0004_UICategorySetup.cs:587 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute3"] | p_attribute3 | 행/컬럼 값 대입 |  |  |  |
| AC-f9434eaa | SaveButton | SCM0004_UICategorySetup.cs:588 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute4"] | p_attribute4 | 행/컬럼 값 대입 |  |  |  |
| AC-362b7cb5 | SaveButton | SCM0004_UICategorySetup.cs:589 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute5"] | p_attribute5 | 행/컬럼 값 대입 |  |  |  |
| AC-c4507575 | SaveButton | SCM0004_UICategorySetup.cs:590 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-0dc8ca3e | SaveButton | SCM0004_UICategorySetup.cs:591 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-f68310b7 | SaveButton | SCM0004_UICategorySetup.cs:592 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-3d5b5d38 | SaveButton | SCM0004_UICategorySetup.cs:593 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute6"] | p_attribute6 | 행/컬럼 값 대입 |  |  |  |
| AC-854ea888 | SaveButton | SCM0004_UICategorySetup.cs:594 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b920492a | SaveButton | SCM0004_UICategorySetup.cs:594 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-d80f479b | SaveButton | SCM0004_UICategorySetup.cs:600 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][0] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3c587804 | SaveButton | SCM0004_UICategorySetup.cs:608 | if (siMain.SheetName == SpdSheet.shtMeasure) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-9cbb20c3 | SaveButton | SCM0004_UICategorySetup.cs:609 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0543d163 | SaveButton | SCM0004_UICategorySetup.cs:691 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (null!= cp_measure_Color && cp_measure_Color != "") ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00052", new object[] { "(ex:255,255,255)" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ee8c5cce | SaveButton | SCM0004_UICategorySetup.cs:723 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (!rgbChk) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e04591f5 | SaveButton | SCM0004_UICategorySetup.cs:726 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE") ⇒ SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | 엔드포인트 요청 생성 |  |  |  |
| AC-b578ce58 | SaveButton | SCM0004_UICategorySetup.cs:728 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c7d3ba4 | SaveButton | SCM0004_UICategorySetup.cs:730 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5b75e48d | SaveButton | SCM0004_UICategorySetup.cs:731 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-55000172 | SaveButton | SCM0004_UICategorySetup.cs:732 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-1f59b297 | SaveButton | SCM0004_UICategorySetup.cs:733 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_name"] | p_Column_Name | 행/컬럼 값 대입 |  |  |  |
| AC-e65c8b6d | SaveButton | SCM0004_UICategorySetup.cs:734 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_label_name"] | p_column_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-79c99262 | SaveButton | SCM0004_UICategorySetup.cs:735 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sort_order_no"] | p_sort_order_no | 행/컬럼 값 대입 |  |  |  |
| AC-e66bd932 | SaveButton | SCM0004_UICategorySetup.cs:736 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_small_class_label_name"] | p_small_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-06fdc218 | SaveButton | SCM0004_UICategorySetup.cs:737 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_large_class_label_name"] | p_large_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-d6d70de1 | SaveButton | SCM0004_UICategorySetup.cs:738 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_default_flag"] | p_default_flag | 행/컬럼 값 대입 |  |  |  |
| AC-657c5766 | SaveButton | SCM0004_UICategorySetup.cs:739 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_selectable_flag"] | p_user_selectable_flag | 행/컬럼 값 대입 |  |  |  |
| AC-dbdb4eba | SaveButton | SCM0004_UICategorySetup.cs:741 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab8099fb | SaveButton | SCM0004_UICategorySetup.cs:742 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-8890ed51 | SaveButton | SCM0004_UICategorySetup.cs:743 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-f013d1f3 | SaveButton | SCM0004_UICategorySetup.cs:744 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-a6100b50 | SaveButton | SCM0004_UICategorySetup.cs:745 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-a0ac7502 | SaveButton | SCM0004_UICategorySetup.cs:747 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_measure_Color"] | p_measure_Color | 행/컬럼 값 대입 |  |  |  |
| AC-d607b2a8 | SaveButton | SCM0004_UICategorySetup.cs:750 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute1"] | p_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-13d330c7 | SaveButton | SCM0004_UICategorySetup.cs:751 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute2"] | p_attribute2 | 행/컬럼 값 대입 |  |  |  |
| AC-572b56ef | SaveButton | SCM0004_UICategorySetup.cs:752 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute4"] | p_attribute4 | 행/컬럼 값 대입 |  |  |  |
| AC-2d394f99 | SaveButton | SCM0004_UICategorySetup.cs:753 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute5"] | p_attribute5 | 행/컬럼 값 대입 |  |  |  |
| AC-697999e5 | SaveButton | SCM0004_UICategorySetup.cs:754 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute6"] | p_attribute6 | 행/컬럼 값 대입 |  |  |  |
| AC-41a4bb1b | SaveButton | SCM0004_UICategorySetup.cs:755 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute7"] | p_attribute7 | 행/컬럼 값 대입 |  |  |  |
| AC-76d35b46 | SaveButton | SCM0004_UICategorySetup.cs:756 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute8"] | p_attribute8 | 행/컬럼 값 대입 |  |  |  |
| AC-dc7a7c44 | SaveButton | SCM0004_UICategorySetup.cs:757 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute9"] | p_attribute9 | 행/컬럼 값 대입 |  |  |  |
| AC-fe66d22d | SaveButton | SCM0004_UICategorySetup.cs:758 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute10"] | p_attribute10 | 행/컬럼 값 대입 |  |  |  |
| AC-8bf1e8c1 | SaveButton | SCM0004_UICategorySetup.cs:761 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31801e67 | SaveButton | SCM0004_UICategorySetup.cs:761 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-cca4caee | SaveButton | SCM0004_UICategorySetup.cs:767 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][0] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0004_UICategorySetup.Set_CellBackColor

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc1f2633 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:777 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82cd8570 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:783 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMeasure) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6b3efea | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:790 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMeasure) ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain… | GRID_SET | spdMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefCols_Measure.MEASURE_COLOR), i, siMa… | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 그리드 속성/값 설정 |  |  |  |
| AC-f2980596 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004_UICategorySetup.cs:794 | if (fps.Name == "spdMain") | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCM0004_UICategorySetup.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c747abe | this.Load 외 2 | SCM0004_UICategorySetup.cs:187 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6416b5e3 | this.Load 외 2 | SCM0004_UICategorySetup.cs:191 | if (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0386929 | this.Load 외 2 | SCM0004_UICategorySetup.cs:192 | if (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-6763db55 | this.Load 외 2 | SCM0004_UICategorySetup.cs:194 | else of (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4785623 | this.Load 외 2 | SCM0004_UICategorySetup.cs:195 | else of (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-a9659e2a | this.Load 외 2 | SCM0004_UICategorySetup.cs:198 |  | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004MOD_UI_CategorySetup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88c8877f | this.Load | SCM0004MOD_UI_Category_Setup.cs:164 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtColumn, SpdSheet.shtColumn, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0d3e4fa8 | this.Load | SCM0004MOD_UI_Category_Setup.cs:165 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-5b9dc85b | this.Load | SCM0004MOD_UI_Category_Setup.cs:167 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMeasure, SpdSheet.shtMeasure, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-798fc1d0 | this.Load | SCM0004MOD_UI_Category_Setup.cs:168 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ccce20f | this.Load | SCM0004MOD_UI_Category_Setup.cs:170 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0004MOD_UI_CategorySetup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8ea2ae0 | Dispose | SCM0004MOD_UI_Category_Setup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0004MOD_UI_CategorySetup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af9b92ee | EditButton | SCM0004MOD_UI_Category_Setup.cs:296 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-55155311 | EditButton | SCM0004MOD_UI_Category_Setup.cs:298 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-7c63255a | EditButton | SCM0004MOD_UI_Category_Setup.cs:299 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Column.Program_ID), siMain.GetColumnIndex(DefCols_Column.Sh… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b83b6293 | EditButton | SCM0004MOD_UI_Category_Setup.cs:300 | if (spdMain != null) ▸ if (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Column.Created_By), siMain.GetColumnIndex(DefCols_Column.La… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d1cda84 | EditButton | SCM0004MOD_UI_Category_Setup.cs:302 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c8306488 | EditButton | SCM0004MOD_UI_Category_Setup.cs:304 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-701b2f33 | EditButton | SCM0004MOD_UI_Category_Setup.cs:305 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Measure.Program_ID), siMain.GetColumnIndex(DefCols_Measure.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4e7a362 | EditButton | SCM0004MOD_UI_Category_Setup.cs:306 | if (spdMain != null) ▸ else of (spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefCols_Measure.Created_By), siMain.GetColumnIndex(DefCols_Measure.… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0004MOD_UI_CategorySetup.Find_Column

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e516ab5 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:330 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtColumn) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0cab95cf | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:339 |  | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7afb6378 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:343 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b746fa9 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:345 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX") ⇒ SCM.GET_UI_CATEGORY_SETUP_COLUMN_EX | 엔드포인트 요청 생성 |  |  |  |
| AC-63779767 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:346 | lambda | DATA_OP | req.Parameters["p_program_id"] | ProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-b1e3437d | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:347 | lambda | DATA_OP | req.Parameters["p_sheet_name"] | SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-ef8cdc62 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:348 | lambda | DATA_OP | req.Parameters["p_column_name"] | ColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-b9539017 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:349 | lambda | DATA_OP | req.Parameters["p_colmum_lavel_name"] | ColumnLabelName | 행/컬럼 값 대입 |  |  |  |
| AC-80924263 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:350 | lambda | DATA_OP | req.Parameters["p_default_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7b1ab7f4 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:351 | lambda | DATA_OP | req.Parameters["p_valid_yn"] | Valid | 행/컬럼 값 대입 |  |  |  |
| AC-34d5a52a | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:353 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-49008f6b | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:354 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-31126f1d | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:358 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3e28a459 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:359 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2f06084 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:361 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-73e7c160 | FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.Act… 외 1 | SCM0004MOD_UI_Category_Setup.cs:362 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004MOD_UI_CategorySetup.Find_Measure

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fc57a9b | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:371 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMeasure) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03dacffc | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:380 |  | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b550754 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:383 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4ff4a889 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:385 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE") ⇒ SCM.SCM0004_GET_UI_CATEGORY_SETUP_MEASURE | 엔드포인트 요청 생성 |  |  |  |
| AC-fa27f019 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:386 | lambda | DATA_OP | req.Parameters["p_program_id"] | ProgramID | 행/컬럼 값 대입 |  |  |  |
| AC-2b778bd9 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:387 | lambda | DATA_OP | req.Parameters["p_sheet_name"] | SheetName | 행/컬럼 값 대입 |  |  |  |
| AC-2b1090f0 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:388 | lambda | DATA_OP | req.Parameters["p_column_name"] | ColumnName | 행/컬럼 값 대입 |  |  |  |
| AC-52f671df | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:389 | lambda | DATA_OP | req.Parameters["p_colmum_lavel_name"] | ColumnLabelName | 행/컬럼 값 대입 |  |  |  |
| AC-b959a128 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:390 | lambda | DATA_OP | req.Parameters["p_default_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c7520c7 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:391 | lambda | DATA_OP | req.Parameters["p_valid_yn"] | Valid | 행/컬럼 값 대입 |  |  |  |
| AC-5f0875ed | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:393 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-193d2d41 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:394 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-62678350 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:398 |  | GRID_BIND | siMain.Query | (tran) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bee975b1 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:399 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ec57b98 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:401 |  | UI_MISC | SetSearchCount | (tran) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-db5fd5b2 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:402 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004MOD_UI_CategorySetup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fd82bea | this.Load | SCM0004MOD_UI_Category_Setup.cs:137 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0004MOD_UI_CategorySetup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1638658f | this.Load | SCM0004MOD_UI_Category_Setup.cs:151 |  | FLAG | dtYesOrNo | Data.Common(Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 화면 필드/플래그 변경 |  |  |  |
| AC-b639fa75 | this.Load | SCM0004MOD_UI_Category_Setup.cs:151 |  | COMBO_DATA | Data.Common | (Data.Type.YesOrNo) ⇒ biz:CommonData.YesOrNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-268793ce | this.Load | SCM0004MOD_UI_Category_Setup.cs:154 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, false) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-68f87099 | this.Load | SCM0004MOD_UI_Category_Setup.cs:156 |  | FLAG | dtDataSortMethod | Data.CallBizCommonData("DATA_SORT_METHOD") ⇒ biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | 화면 필드/플래그 변경 |  |  |  |
| AC-5ebc3e93 | this.Load | SCM0004MOD_UI_Category_Setup.cs:156 |  | COMBO_DATA | Data.CallBizCommonData | ("DATA_SORT_METHOD") ⇒ biz:CommonData.CommonDataList [code=DATA_SORT_METHOD] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4ada829 | this.Load | SCM0004MOD_UI_Category_Setup.cs:157 |  | FLAG | dtDefaultFlag | Data.CallBizCommonData("DEFAULT_FLAG") ⇒ biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | 화면 필드/플래그 변경 |  |  |  |
| AC-3bc81e66 | this.Load | SCM0004MOD_UI_Category_Setup.cs:157 |  | COMBO_DATA | Data.CallBizCommonData | ("DEFAULT_FLAG") ⇒ biz:CommonData.CommonDataList [code=DEFAULT_FLAG] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-702fa772 | this.Load | SCM0004MOD_UI_Category_Setup.cs:159 |  | FLAG | dtCellObject | Data.CallBizCommonData("CELL_CONTROL_OBJECT_TYPE_CODE") ⇒ biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-929ff0c6 | this.Load | SCM0004MOD_UI_Category_Setup.cs:159 |  | COMBO_DATA | Data.CallBizCommonData | ("CELL_CONTROL_OBJECT_TYPE_CODE") ⇒ biz:CommonData.CommonDataList [code=CELL_CONTROL_OBJECT_TYPE_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-726daabb | this.Load | SCM0004MOD_UI_Category_Setup.cs:160 |  | FLAG | dtHorizontalAlign | Data.CallBizCommonData("HORIZONTAL_ALIGN_CODE") ⇒ biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9a37badb | this.Load | SCM0004MOD_UI_Category_Setup.cs:160 |  | COMBO_DATA | Data.CallBizCommonData | ("HORIZONTAL_ALIGN_CODE") ⇒ biz:CommonData.CommonDataList [code=HORIZONTAL_ALIGN_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCM0004MOD_UI_CategorySetup.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a7a8d0b | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:209 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3bf1ddac | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:211 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4b509e84 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:212 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("ProgramID* ", DefCols_Column.Program_ID, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2408f77e | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:213 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Sheet Name*", DefCols_Column.Sheet_Name, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56e987f4 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:214 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Name* ", DefCols_Column.Column_Name, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ff776a6 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:215 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Label Name*", DefCols_Column.Column_Label_Name, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ba30224 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:217 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param7", DefCols_Column.Attribute7, FPMerge.None, 500, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ed4a77f | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:218 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param8", DefCols_Column.Attribute8, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e01ab94b | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:219 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param9", DefCols_Column.Attribute9, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6305995 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:221 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Sort Order No*", DefCols_Column.Sort_Order_No, FPMerge.None, 110, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f86bd1b | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:222 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Data Sort Method", DefCols_Column.Data_Sort_Method_Code, FPMerge.None, 140, true, dtData… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8c0e84f | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:223 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Small Label", DefCols_Column.Small_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28311228 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:224 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Large Label", DefCols_Column.Large_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c54d6bac | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:225 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Fixed", DefCols_Column.Fixed, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f514434 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:226 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Width*", DefCols_Column.Column_Width, FPMerge.None, 95, true, FPHAlign.Right, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e480ef8 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:227 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Cell Object", DefCols_Column.Cell_Control_Object_Type_Code, FPMerge.None, 185, true, dtC… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c849be0c | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:228 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Cell Combo Data Type", DefCols_Column.CELL_COMBO_DATA_TYPE, FPMerge.None, 185, true, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cff140e | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:229 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Data Scale Num", DefCols_Column.Data_Scale_Number, FPMerge.None, 120, true, FPHAlign.Rig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a422cc9 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:230 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Data Max Length", DefCols_Column.Data_Max_Length, FPMerge.None, 110, true, FPHAlign.Righ… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8efeca93 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:231 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Horizontal Align*", DefCols_Column.Horizontal_Align_Code, FPMerge.None, 130, true, dtHor… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6fccdf69 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:232 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Uppercase Apply", DefCols_Column.Uppercase_Apply_Flag, FPMerge.None, 100, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08b3253b | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:233 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Visible*", DefCols_Column.Visible_Flag, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0a658c4 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:234 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("User Visible Flag", DefCols_Column.User_Visible_Flag, FPMerge.None, 100, true, dtYesOrNo… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-941d37a5 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:235 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Default", DefCols_Column.Default_Flag, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08f43b5d | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:236 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("User Selected Flag", DefCols_Column.USER_SELECTABLE_FLAG, FPMerge.None, 100, true, dtYes… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48938eb6 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:237 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Division", DefCols_Column.DIVISION_ID, FPMerge.None, 100, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0582bd6f | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:238 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid*", DefCols_Column.Valid, FPMerge.None, 100, true, dtYesOrNo, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64d18285 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:239 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param1", DefCols_Column.Attribute1, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-656c79a4 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:240 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param2", DefCols_Column.Attribute2, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eefed857 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:241 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param3", DefCols_Column.Attribute3, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08ea0666 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:242 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param4", DefCols_Column.Attribute4, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5af5b9d5 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:243 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Column param5", DefCols_Column.Attribute5, FPMerge.None, 100, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4e32874 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:246 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefCols_Column.Created_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f446e152 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:247 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefCols_Column.Creation_Date, FPMerge.None, 165, true , FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c9f3a2f4 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:248 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefCols_Column.Last_Updated_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec052342 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:249 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefCols_Column.Last_Update_Date, FPMerge.None, 165, true, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b9e2b19 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:251 | if (spreadInfo.SheetName == SpdSheet.shtColumn) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefCols_Column.Column_Name) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-031933b4 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:255 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5f0f45c9 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:257 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5952d0ba | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:258 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("ProgramID* ", DefCols_Measure.Program_ID, FPMerge.None, 110, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6c583ef | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:259 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Sheet Name*", DefCols_Measure.Sheet_Name, FPMerge.None, 175, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d466d560 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:260 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Name* ", DefCols_Measure.Column_Name, FPMerge.None, 175, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e602b81e | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:261 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Column Label Name*", DefCols_Measure.Column_Label_Name, FPMerge.None, 175, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf498c5b | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:262 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Sort Order No*", DefCols_Measure.Sort_Order_No, FPMerge.None, 110, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09bf1013 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:263 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Small Label", DefCols_Measure.Small_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c1f43d53 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:264 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Large Label", DefCols_Measure.Large_Class_Label_Name, FPMerge.None, 165, true, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09428992 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:266 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Measure Color", DefCols_Measure.MEASURE_COLOR, FPMerge.None, 120, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79d8f1ce | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:268 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("Default Flag", DefCols_Measure.Default_Flag, FPMerge.None, 90, true, dtYesOrNo, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9a77458 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:269 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("User Selected Flag", DefCols_Measure.USER_SELECTABLE_FLAG, FPMerge.None, 100, true, dtYe… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9367dc76 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:271 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Division", DefCols_Measure.DIVISION_ID , FPMerge.None, 90, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd329dd3 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:272 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddComboColumn | ("Valid*", DefCols_Measure.Valid, FPMerge.None, 90, true, dtYesOrNo, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c6d842a6 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:273 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Created By", DefCols_Measure.Created_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d3dfcada | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:274 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Creation Date", DefCols_Measure.Creation_Date, FPMerge.None, 165, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fbeb565 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:275 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Updated By", DefCols_Measure.Last_Updated_By, FPMerge.None, 105, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-215c8b09 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:276 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.AddDateTimeColumn | ("Last Update Date", DefCols_Measure.Last_Update_Date, FPMerge.None, 165, true, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4bb06a89 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:278 | if (spreadInfo.SheetName == SpdSheet.shtMeasure) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefCols_Measure.Column_Name) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0004MOD_UI_CategorySetup.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a69420d | InsertButton | SCM0004MOD_UI_Category_Setup.cs:415 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b1f74264 | InsertButton | SCM0004MOD_UI_Category_Setup.cs:417 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Data_Sort_Method_Code, "ASC") | 데이터 객체 조작/조회 |  |  |  |
| AC-ef1ad9df | InsertButton | SCM0004MOD_UI_Category_Setup.cs:418 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Cell_Control_Object_Type_Code, "FPText") | 데이터 객체 조작/조회 |  |  |  |
| AC-2dfc953c | InsertButton | SCM0004MOD_UI_Category_Setup.cs:419 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Visible_Flag, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee2ef6dd | InsertButton | SCM0004MOD_UI_Category_Setup.cs:420 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Default_Flag, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e2f34e8 | InsertButton | SCM0004MOD_UI_Category_Setup.cs:421 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Valid, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-6398f567 | InsertButton | SCM0004MOD_UI_Category_Setup.cs:422 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Horizontal_Align_Code, "C") | 데이터 객체 조작/조회 |  |  |  |
| AC-23afd2bf | InsertButton | SCM0004MOD_UI_Category_Setup.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Column_Width, "0") | 데이터 객체 조작/조회 |  |  |  |
| AC-944f1a2e | InsertButton | SCM0004MOD_UI_Category_Setup.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Data_Scale_Number, null) | 데이터 객체 조작/조회 |  |  |  |
| AC-9958872b | InsertButton | SCM0004MOD_UI_Category_Setup.cs:426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | DATA_OP | defaultData.Add | (DefCols_Column.Data_Max_Length, null) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1984bf | InsertButton | SCM0004MOD_UI_Category_Setup.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-9bf3944d | InsertButton | SCM0004MOD_UI_Category_Setup.cs:430 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtColumn) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCols_Column.Created_By), siMain.GetColumnIndex(DefCols_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-18be324e | InsertButton | SCM0004MOD_UI_Category_Setup.cs:433 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f8af9c5 | InsertButton | SCM0004MOD_UI_Category_Setup.cs:435 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | DATA_OP | defaultData.Add | (DefCols_Measure.Default_Flag, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-afc065fa | InsertButton | SCM0004MOD_UI_Category_Setup.cs:436 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | DATA_OP | defaultData.Add | (DefCols_Measure.Valid, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-da14dd3a | InsertButton | SCM0004MOD_UI_Category_Setup.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-53981489 | InsertButton | SCM0004MOD_UI_Category_Setup.cs:439 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMeasure) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefCols_Measure.Created_By), siMain.GetColumnIndex(DefCols… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0004MOD_UI_CategorySetup.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41428e29 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:448 | if (siMain.SheetName == SpdSheet.shtColumn) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-2da8cdcc | SaveButton | SCM0004MOD_UI_Category_Setup.cs:449 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0d9dc477 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:546 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN") ⇒ SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_COLUMN | 엔드포인트 요청 생성 |  |  |  |
| AC-ca832d85 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:549 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8b3c205 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:551 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-1f6ad0ea | SaveButton | SCM0004MOD_UI_Category_Setup.cs:552 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc94a82e | SaveButton | SCM0004MOD_UI_Category_Setup.cs:553 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-dcd9d27a | SaveButton | SCM0004MOD_UI_Category_Setup.cs:554 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_name"] | p_column_name | 행/컬럼 값 대입 |  |  |  |
| AC-68637a1b | SaveButton | SCM0004MOD_UI_Category_Setup.cs:555 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_label_name"] | p_column_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-c525f7d7 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:556 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sort_order_no"] | p_sort_order_no | 행/컬럼 값 대입 |  |  |  |
| AC-b35c89cb | SaveButton | SCM0004MOD_UI_Category_Setup.cs:557 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_data_sort_method_code"] | p_data_sort_method_code | 행/컬럼 값 대입 |  |  |  |
| AC-3e78acc2 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:558 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_small_class_label_name"] | p_small_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-780e4402 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:559 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_large_class_label_name"] | p_large_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-440dcabd | SaveButton | SCM0004MOD_UI_Category_Setup.cs:560 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_fixed_flag"] | p_fixed_flag | 행/컬럼 값 대입 |  |  |  |
| AC-5b07534e | SaveButton | SCM0004MOD_UI_Category_Setup.cs:561 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_width"] | p_column_width | 행/컬럼 값 대입 |  |  |  |
| AC-dafb0989 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:562 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_control_object_type_code"] | p_cell_control_object_type_code | 행/컬럼 값 대입 |  |  |  |
| AC-a4b35b0b | SaveButton | SCM0004MOD_UI_Category_Setup.cs:563 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_combo_data_type"] | p_cell_combo_data_type | 행/컬럼 값 대입 |  |  |  |
| AC-916a6eb0 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:564 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_data_scale_number"] | p_data_scale_number | 행/컬럼 값 대입 |  |  |  |
| AC-e5aad9da | SaveButton | SCM0004MOD_UI_Category_Setup.cs:565 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_data_max_length"] | p_data_max_length | 행/컬럼 값 대입 |  |  |  |
| AC-b5daec9f | SaveButton | SCM0004MOD_UI_Category_Setup.cs:566 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_horizontal_align_code"] | p_horizontal_align_code | 행/컬럼 값 대입 |  |  |  |
| AC-41a78bd8 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:567 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_uppercase_apply_flag"] | p_uppercase_apply_flag | 행/컬럼 값 대입 |  |  |  |
| AC-95c093f5 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:568 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_visible_flag"] | p_visible_flag | 행/컬럼 값 대입 |  |  |  |
| AC-034a709e | SaveButton | SCM0004MOD_UI_Category_Setup.cs:569 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_default_flag"] | p_default_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6e35304b | SaveButton | SCM0004MOD_UI_Category_Setup.cs:570 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_selectable_flag"] | p_user_selectable_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0adb426e | SaveButton | SCM0004MOD_UI_Category_Setup.cs:571 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-62ef073c | SaveButton | SCM0004MOD_UI_Category_Setup.cs:572 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-b03d8589 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:573 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute1"] | p_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-00ce18cf | SaveButton | SCM0004MOD_UI_Category_Setup.cs:574 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute2"] | p_attribute2 | 행/컬럼 값 대입 |  |  |  |
| AC-802d4251 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:575 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute3"] | p_attribute3 | 행/컬럼 값 대입 |  |  |  |
| AC-0c7b2f8e | SaveButton | SCM0004MOD_UI_Category_Setup.cs:576 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute4"] | p_attribute4 | 행/컬럼 값 대입 |  |  |  |
| AC-e3fe42f0 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:577 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute5"] | p_attribute5 | 행/컬럼 값 대입 |  |  |  |
| AC-996597aa | SaveButton | SCM0004MOD_UI_Category_Setup.cs:578 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-52141cc7 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:579 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-bf9fedbd | SaveButton | SCM0004MOD_UI_Category_Setup.cs:580 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-395cc492 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:581 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_attribute6"] | p_attribute6 | 행/컬럼 값 대입 |  |  |  |
| AC-5fbeba1c | SaveButton | SCM0004MOD_UI_Category_Setup.cs:582 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e4afbd7 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:582 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-efc05b9b | SaveButton | SCM0004MOD_UI_Category_Setup.cs:588 | if (siMain.SheetName == SpdSheet.shtColumn) ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][0] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8288ef3e | SaveButton | SCM0004MOD_UI_Category_Setup.cs:596 | if (siMain.SheetName == SpdSheet.shtMeasure) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-3b87ad0d | SaveButton | SCM0004MOD_UI_Category_Setup.cs:597 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a70b6c54 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:668 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (null!= cp_measure_Color && cp_measure_Color != "") ▸… | MESSAGE | MessageHelper.GMessageBox | ("MSG00052", new object[] { "(ex:255,255,255)" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfc15340 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:678 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (!rgbChk) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e254220f | SaveButton | SCM0004MOD_UI_Category_Setup.cs:681 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE") ⇒ SCM.SCM0004_SAVE_UI_CATEGORY_SETUP_MEASURE | 엔드포인트 요청 생성 |  |  |  |
| AC-2cb94759 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:683 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dafcdd71 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:685 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-3d78c1b9 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:686 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e1650bb | SaveButton | SCM0004MOD_UI_Category_Setup.cs:687 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-47425ef5 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:688 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_name"] | p_Column_Name | 행/컬럼 값 대입 |  |  |  |
| AC-c6ea796d | SaveButton | SCM0004MOD_UI_Category_Setup.cs:689 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_column_label_name"] | p_column_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-4e50a503 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:690 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sort_order_no"] | p_sort_order_no | 행/컬럼 값 대입 |  |  |  |
| AC-71b1d6ec | SaveButton | SCM0004MOD_UI_Category_Setup.cs:691 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_small_class_label_name"] | p_small_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-e367cf19 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:692 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_large_class_label_name"] | p_large_class_label_name | 행/컬럼 값 대입 |  |  |  |
| AC-486c02ba | SaveButton | SCM0004MOD_UI_Category_Setup.cs:693 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_default_flag"] | p_default_flag | 행/컬럼 값 대입 |  |  |  |
| AC-307a5c38 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:694 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_selectable_flag"] | p_user_selectable_flag | 행/컬럼 값 대입 |  |  |  |
| AC-858f53fa | SaveButton | SCM0004MOD_UI_Category_Setup.cs:696 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cbe0fae3 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:697 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-30562ca8 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:698 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-76cce833 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:699 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_creation_date"] | p_creation_date | 행/컬럼 값 대입 |  |  |  |
| AC-314ab5ef | SaveButton | SCM0004MOD_UI_Category_Setup.cs:700 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-5e9d3722 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:702 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_measure_Color"] | p_measure_Color | 행/컬럼 값 대입 |  |  |  |
| AC-3f4c881b | SaveButton | SCM0004MOD_UI_Category_Setup.cs:704 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-62d9c184 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:704 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-aed129c2 | SaveButton | SCM0004MOD_UI_Category_Setup.cs:710 | if (siMain.SheetName == SpdSheet.shtMeasure) ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][0] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0004MOD_UI_CategorySetup.Set_CellBackColor

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.GetMaxRowIndex() > 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ else of (siMain.ActiveSheetIndex == 0) ▸ if (siMain.GetMaxRowIndex() > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e108ab88 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:720 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eaa501f3 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:726 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMeasure) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42a6f315 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:733 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMeasure) ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain… | GRID_SET | spdMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefCols_Measure.MEASURE_COLOR), i, siMa… | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 그리드 속성/값 설정 |  |  |  |
| AC-24644e64 | FindButton [if (siMain.ActiveSheet != null) ▸ else of (siMai… 외 1 | SCM0004MOD_UI_Category_Setup.cs:737 | if (fps.Name == "spdMain") | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCM0004MOD_UI_CategorySetup.SetSpreadInit

진입점: this.Load / FindButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)] / SaveButton [if (siMain.ActiveSheet != null) ▸ if (siMain.ActiveSheetIndex == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c4bc77e | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:179 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7eb4c0ff | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:183 | if (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-65a7f3f6 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:184 | if (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-de1406a6 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:186 | else of (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.ChangeSheet | (1) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bebc2fa1 | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:187 | else of (sheetName.Equals(SpdSheet.shtColumn)) | GRID_INIT | siObj.InitSheet | (1) | 그리드 재구성/초기화 |  |  |  |
| AC-a6e366ad | this.Load 외 2 | SCM0004MOD_UI_Category_Setup.cs:190 |  | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

