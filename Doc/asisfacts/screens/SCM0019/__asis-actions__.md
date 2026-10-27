# AS-IS 액션 대조표 — SCM0019

> 원천: `Doc/asisfacts/screens/SCM0019/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 45행 · 메서드 9 · 종류 DATA_OP 9 · ENDPOINT 6 · GRID_INIT 4 · UI_MISC 4 · RETURN 4 · FLAG 3 · GRID_LOCK 3 · POPUP 2 · VALIDATE 2 · UI_PROP 2 · MESSAGE 2 · GRID_BIND 1 · LIST_REBIND 1 · COMBO_DATA 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 0


## SCM0019_SCP_Interface_Blocking.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e7568ef | this.Load | SCM0019_SCP_Interface_Blocking.cs:118 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-856722e7 | this.Load | SCM0019_SCP_Interface_Blocking.cs:119 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e8dd3980 | this.Load | SCM0019_SCP_Interface_Blocking.cs:120 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0019_SCP_Interface_Blocking.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e5df583 | Dispose | SCM0019_SCP_Interface_Blocking.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0019_SCP_Interface_Blocking.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50617d18 | EditButton | SCM0019_SCP_Interface_Blocking.cs:155 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9860bf41 | EditButton | SCM0019_SCP_Interface_Blocking.cs:156 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5072c94a | EditButton | SCM0019_SCP_Interface_Blocking.cs:157 |  | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.PLAN_STAR… | 그리드 편집 잠금/해제 |  |  |  |

## SCM0019_SCP_Interface_Blocking.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a709825 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:166 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b4dfaf3a | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:170 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0fc9d7f2 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:170 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4f0113a | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:174 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-120e8047 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:185 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1971f189 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:186 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45ee6f1f | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:190 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0019_GET_SCP_INTERFACE_BLOCKING") ⇒ SCM.SCM0019_GET_SCP_INTERFACE_BLOCKING | 엔드포인트 요청 생성 |  |  |  |
| AC-a599e3c3 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:191 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f11f8453 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:192 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bfb53c5f | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:193 | try ▸ lambda | DATA_OP | request.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9c38d41a | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:194 | try ▸ lambda | DATA_OP | request.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-be6ab9a6 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:195 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-97906d13 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:197 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-284bd0d1 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:204 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d9f10526 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:205 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-680e2a89 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:208 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d5a47a99 | FindButton 외 1 | SCM0019_SCP_Interface_Blocking.cs:219 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCM0019_SCP_Interface_Blocking.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db37eacf | this.Load | SCM0019_SCP_Interface_Blocking.cs:78 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0019_SCP_Interface_Blocking.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5124e442 | this.Load | SCM0019_SCP_Interface_Blocking.cs:99 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c6b179e5 | this.Load | SCM0019_SCP_Interface_Blocking.cs:102 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-67f0ec18 | this.Load | SCM0019_SCP_Interface_Blocking.cs:104 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0019_SCP_Interface_Blocking.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-42cdd1c3 | this.Load 외 2 | SCM0019_SCP_Interface_Blocking.cs:127 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-10b56a61 | this.Load 외 2 | SCM0019_SCP_Interface_Blocking.cs:128 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCM0019_SCP_Interface_Blocking.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbacd0a2 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:283 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCM.SCM0019_SAVE_SCP_INTERFACE_BLOCKING") ⇒ SCM.SCM0019_SAVE_SCP_INTERFACE_BLOCKING | 엔드포인트 요청 생성 |  |  |  |
| AC-5729c575 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:287 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f4086fe | SaveButton | SCM0019_SCP_Interface_Blocking.cs:291 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b8855ee3 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:292 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-20ad6530 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8077cc74 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:294 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fp_target_yn"] | p_fp_target_yn | 행/컬럼 값 대입 |  |  |  |
| AC-045fcc1d | SaveButton | SCM0019_SCP_Interface_Blocking.cs:295 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_mrp_target_yn"] | p_mrp_target_yn | 행/컬럼 값 대입 |  |  |  |
| AC-06ea21b8 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:296 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_dm_rtf_yn"] | p_dm_rtf_yn | 행/컬럼 값 대입 |  |  |  |
| AC-504c28f6 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99955e76 | SaveButton | SCM0019_SCP_Interface_Blocking.cs:298 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-5d680f5a | SaveButton | SCM0019_SCP_Interface_Blocking.cs:308 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e94b09da | SaveButton | SCM0019_SCP_Interface_Blocking.cs:317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ if (t.Succes… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCM0019_SCP_Interface_Blocking.SetChangedPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac746cd5 | this.Load | SCM0019_SCP_Interface_Blocking.cs:230 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value} \|\| PERIOD_DEFAULT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e4961fff | this.Load | SCM0019_SCP_Interface_Blocking.cs:233 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f5372cd | this.Load | SCM0019_SCP_Interface_Blocking.cs:237 | if (dt.Rows.Count > 0) | VALUE_SET | drpPeriod.InitValue | dt.Rows[0]["FROM_VALUE"].ToString() + ":" + dt.Rows[0]["TO_VALUE"].ToString() | 컨트롤 값 설정 |  |  |  |

