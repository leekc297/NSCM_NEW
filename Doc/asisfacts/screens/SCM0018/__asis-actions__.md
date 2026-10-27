# AS-IS 액션 대조표 — SCM0018

> 원천: `Doc/asisfacts/screens/SCM0018/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 52행 · 메서드 11 · 종류 DATA_OP 9 · RETURN 6 · ENDPOINT 6 · GRID_INIT 5 · UI_MISC 4 · FLAG 3 · GRID_LOCK 3 · MESSAGE 3 · UI_PROP 3 · CALL_EXT 3 · LIST_REBIND 3 · POPUP 2 · VALIDATE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 3


## SCM0018_Interface_setup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5189574 | this.Load | SCM0018_Interface_setup.cs:127 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da59c9a1 | this.Load | SCM0018_Interface_setup.cs:128 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-5f0c85f1 | this.Load | SCM0018_Interface_setup.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0018_Interface_setup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da9be37e | Dispose | SCM0018_Interface_setup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0018_Interface_setup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94c8e63c | EditButton | SCM0018_Interface_setup.cs:178 | if (spdMain != null) ▸ if (fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5ca5a6e | EditButton | SCM0018_Interface_setup.cs:179 | if (spdMain != null) ▸ if (fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e5bb603e | EditButton | SCM0018_Interface_setup.cs:181 | if (spdMain != null) ▸ if (fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.PLAN_STAR… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0018_Interface_setup.FindData_Main

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5a79c27 | FindButton 외 1 | SCM0018_Interface_setup.cs:203 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-68304676 | FindButton 외 1 | SCM0018_Interface_setup.cs:207 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-c18198e5 | FindButton 외 1 | SCM0018_Interface_setup.cs:207 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92ba9085 | FindButton 외 1 | SCM0018_Interface_setup.cs:212 | try ▸ if (!string.IsNullOrEmpty(p_plan_start_yyyymmdd.ToString()) && p_plan_start_yyyymmdd.ToString().Length!=8) | MESSAGE | MessageHelper.GMessageBox | ("MSG00049", new object[] { p_plan_start_yyyymmdd }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a777381a | FindButton 외 1 | SCM0018_Interface_setup.cs:213 | try ▸ if (!string.IsNullOrEmpty(p_plan_start_yyyymmdd.ToString()) && p_plan_start_yyyymmdd.ToString().Length!=8) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9742d957 | FindButton 외 1 | SCM0018_Interface_setup.cs:218 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c01b4a7f | FindButton 외 1 | SCM0018_Interface_setup.cs:236 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-56213f04 | FindButton 외 1 | SCM0018_Interface_setup.cs:237 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SystemMgmt… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c256bac4 | FindButton 외 1 | SCM0018_Interface_setup.cs:241 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetInterfaceSetup") ⇒ SystemManager.UP_FX_GetInterfaceSetup | 엔드포인트 요청 생성 |  |  |  |
| AC-56d2c292 | FindButton 외 1 | SCM0018_Interface_setup.cs:242 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7c98711d | FindButton 외 1 | SCM0018_Interface_setup.cs:243 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8f8a481a | FindButton 외 1 | SCM0018_Interface_setup.cs:244 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6f95aefd | FindButton 외 1 | SCM0018_Interface_setup.cs:245 | try ▸ lambda | DATA_OP | req.Parameters["p_fp_target_yn"] | p_fp_target_yn | 행/컬럼 값 대입 |  |  |  |
| AC-9e5c1ab5 | FindButton 외 1 | SCM0018_Interface_setup.cs:246 | try ▸ lambda | DATA_OP | req.Parameters["p_mrp_target_yn"] | p_mrp_target_yn | 행/컬럼 값 대입 |  |  |  |
| AC-52932018 | FindButton 외 1 | SCM0018_Interface_setup.cs:247 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-54689762 | FindButton 외 1 | SCM0018_Interface_setup.cs:248 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-633a7c84 | FindButton 외 1 | SCM0018_Interface_setup.cs:255 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-390b18fb | FindButton 외 1 | SCM0018_Interface_setup.cs:256 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-50bcc59f | FindButton 외 1 | SCM0018_Interface_setup.cs:257 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f72f1817 | FindButton 외 1 | SCM0018_Interface_setup.cs:267 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCM0018_Interface_setup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ead8dd5 | this.Load | SCM0018_Interface_setup.cs:85 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0018_Interface_setup.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d52316e2 | (진입점 미연결) | SCM0018_Interface_setup.cs:340 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, "WEEKLY", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-19c2ed9f | (진입점 미연결) | SCM0018_Interface_setup.cs:341 |  | RETURN | return sDayRange.Substring(0, 8); |  | 처리 중단/반환 |  |  |  |

## SCM0018_Interface_setup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea791d5a | this.Load | SCM0018_Interface_setup.cs:112 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8a9e2e3b | this.Load | SCM0018_Interface_setup.cs:113 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8bece37f | this.Load | SCM0018_Interface_setup.cs:114 |  | LIST_REBIND | cboFPYN.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-8fe9c41c | this.Load | SCM0018_Interface_setup.cs:115 |  | LIST_REBIND | cboMRPYN.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |

## SCM0018_Interface_setup.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (tran.Success) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29157241 | this.Load 외 2 | SCM0018_Interface_setup.cs:138 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-007c408c | this.Load 외 2 | SCM0018_Interface_setup.cs:140 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |

## SCM0018_Interface_setup.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3274c173 | SaveButton | SCM0018_Interface_setup.cs:304 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_SaveInterfaceSetup") ⇒ SystemManager.UP_FX_SaveInterfaceSetup | 엔드포인트 요청 생성 |  |  |  |
| AC-6b3e01c6 | SaveButton | SCM0018_Interface_setup.cs:306 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SystemMgmt… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bef1cec2 | SaveButton | SCM0018_Interface_setup.cs:309 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b224fb56 | SaveButton | SCM0018_Interface_setup.cs:310 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dea5b6b4 | SaveButton | SCM0018_Interface_setup.cs:311 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-aa829f59 | SaveButton | SCM0018_Interface_setup.cs:312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_fp_target_yn"] | p_fp_target_yn | 행/컬럼 값 대입 |  |  |  |
| AC-f3ecd26b | SaveButton | SCM0018_Interface_setup.cs:313 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_mrp_target_yn"] | p_mrp_target_yn | 행/컬럼 값 대입 |  |  |  |
| AC-a0f60d7c | SaveButton | SCM0018_Interface_setup.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d4de680a | SaveButton | SCM0018_Interface_setup.cs:315 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-423f31d9 | SaveButton | SCM0018_Interface_setup.cs:321 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9bef310a | SaveButton | SCM0018_Interface_setup.cs:327 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0018_Interface_setup.SpdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13e6f2ee | (진입점 미연결) | SCM0018_Interface_setup.cs:106 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0018_Interface_setup.TxtPlanDate_KeyPress

진입점: txtPlanDate.KeyPress

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1dddecee | txtPlanDate.KeyPress | SCM0018_Interface_setup.cs:348 |  | CALL_EXT | Char.IsDigit | (e.KeyChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c148e0a | txtPlanDate.KeyPress | SCM0018_Interface_setup.cs:348 |  | CALL_EXT | Char.IsControl | (e.KeyChar) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41811567 | txtPlanDate.KeyPress | SCM0018_Interface_setup.cs:349 | if (Char.IsDigit(e.KeyChar) \|\| Char.IsControl(e.KeyChar) \|\| ch == '-') | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f007db2 | txtPlanDate.KeyPress | SCM0018_Interface_setup.cs:351 |  | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |

