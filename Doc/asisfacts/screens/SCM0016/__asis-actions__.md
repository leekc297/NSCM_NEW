# AS-IS 액션 대조표 — SCM0016

> 원천: `Doc/asisfacts/screens/SCM0016/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 79행 · 메서드 10 · 종류 GRID_INIT 43 · ENDPOINT 9 · FLAG 6 · DATA_OP 6 · RETURN 4 · UI_MISC 3 · GRID_BIND 3 · GRID_LOCK 3 · MESSAGE 1 · LIST_REBIND 1 · ⚠ 의미 확인 필요 0


## SCM0016_BatchLog.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-011dd02a | this.Load | SCM0016_BatchLog.cs:159 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4ef5fd68 | this.Load | SCM0016_BatchLog.cs:160 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-c543fb9d | this.Load | SCM0016_BatchLog.cs:161 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df1d4d4e | this.Load | SCM0016_BatchLog.cs:163 |  | GRID_INIT | AddSheet | (spdStep, SpdSheet.shtStep, SpdSheet.shtStep, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6168c118 | this.Load | SCM0016_BatchLog.cs:164 |  | FLAG | siStep | GetSheetInfo(spdStep.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-a19a887e | this.Load | SCM0016_BatchLog.cs:166 |  | GRID_INIT | AddSheet | (spdHist, SpdSheet.shtHist, SpdSheet.shtHist, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-272384bf | this.Load | SCM0016_BatchLog.cs:167 |  | FLAG | siHist | GetSheetInfo(spdHist.Name, 0) | 화면 필드/플래그 변경 |  |  |  |

## SCM0016_BatchLog.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da4d2f5a | Dispose | SCM0016_BatchLog.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0016_BatchLog.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfc2e554 | EditButton | SCM0016_BatchLog.cs:245 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-718b998c | EditButton | SCM0016_BatchLog.cs:246 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0016_BatchLog.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02241ff6 | FindButton | SCM0016_BatchLog.cs:284 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be3e1cae | FindButton | SCM0016_BatchLog.cs:288 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0016_GET_BATCH_LOG") ⇒ SCM.SCM0016_GET_BATCH_LOG | 엔드포인트 요청 생성 |  |  |  |
| AC-6aca722b | FindButton | SCM0016_BatchLog.cs:289 | lambda | DATA_OP | request.Parameters["p_run_status"] | pRunStatus | 행/컬럼 값 대입 |  |  |  |
| AC-7c7bf1d4 | FindButton | SCM0016_BatchLog.cs:291 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b9de0d94 | FindButton | SCM0016_BatchLog.cs:293 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e07d9580 | FindButton | SCM0016_BatchLog.cs:297 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bda2cec9 | FindButton | SCM0016_BatchLog.cs:298 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d0837f3c | FindButton | SCM0016_BatchLog.cs:301 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b3cfa8f0 | FindButton | SCM0016_BatchLog.cs:304 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0016_BatchLog.FindData_Hist

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de2b480f | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:354 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cd476a8e | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:358 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0016_GET_BATCH_LOG_HIST") ⇒ SCM.SCM0016_GET_BATCH_LOG_HIST | 엔드포인트 요청 생성 |  |  |  |
| AC-8ced55b7 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:359 | lambda | DATA_OP | request.Parameters["p_job_id"] | strJobId | 행/컬럼 값 대입 |  |  |  |
| AC-9bfecb61 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:361 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b9288418 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:363 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7e26494e | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:367 |  | GRID_BIND | siHist.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6678b6bc | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:368 |  | GRID_LOCK | siHist.LockColumn | (0, siHist.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-781ec9aa | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:374 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0016_BatchLog.FindData_Step

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5311f7a3 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:318 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ffe61e7f | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:322 | lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0016_GET_BATCH_STEP_INFO") ⇒ SCM.SCM0016_GET_BATCH_STEP_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-4b22473f | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:323 | lambda | DATA_OP | request.Parameters["p_job_id"] | strJobId | 행/컬럼 값 대입 |  |  |  |
| AC-7af2ee5b | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:325 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14cf3799 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:327 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-88575311 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:331 |  | GRID_BIND | siStep.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a5aa1e6f | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:332 |  | GRID_LOCK | siStep.LockColumn | (0, siStep.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-dff3e710 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:338 |  | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0016_BatchLog.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2131a3e | this.Load | SCM0016_BatchLog.cs:109 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0016_BatchLog.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-634b7355 | this.Load | SCM0016_BatchLog.cs:127 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-89e605d0 | this.Load | SCM0016_BatchLog.cs:128 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtHist) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1615e91 | this.Load | SCM0016_BatchLog.cs:129 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtStep) | 데이터 객체 조작/조회 |  |  |  |
| AC-499042ef | this.Load | SCM0016_BatchLog.cs:131 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8071a8ed | this.Load | SCM0016_BatchLog.cs:133 |  | LIST_REBIND | clsCtrl.setListBox | (dtRunStatus, clbRunStatus, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0016_BatchLog.InitSpread

진입점: this.Load / spdMain.CellDoubleClick / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b3c2f3e | this.Load 외 2 | SCM0016_BatchLog.cs:180 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-8d3bb93b | this.Load 외 2 | SCM0016_BatchLog.cs:182 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("JOB_ID", DefColumns.JOB_ID, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-629f7589 | this.Load 외 2 | SCM0016_BatchLog.cs:183 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("JobName", DefColumns.JOB_NAME, FPMerge.None, 300, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6980d1e | this.Load 외 2 | SCM0016_BatchLog.cs:184 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Job Description", DefColumns.JOB_DESCRIPTION, FPMerge.None, 200, true, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af4ea274 | this.Load 외 2 | SCM0016_BatchLog.cs:185 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("STEP_ID", DefColumns.STEP_ID, FPMerge.None, 160, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4157bf1 | this.Load 외 2 | SCM0016_BatchLog.cs:186 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Step Name", DefColumns.STEP_NAME, FPMerge.None, 120, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5196c01 | this.Load 외 2 | SCM0016_BatchLog.cs:187 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("SCHEDULE_UID", DefColumns.SCHEDULE_UID, FPMerge.None, 160, false, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12a13ae0 | this.Load 외 2 | SCM0016_BatchLog.cs:188 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Schedule Name", DefColumns.SCHEDULE_NAME, FPMerge.None, 170, true, FPHAlign.Left, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b7d5d8d | this.Load 외 2 | SCM0016_BatchLog.cs:189 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Run Date", DefColumns.RUN_DATE, FPMerge.None, 150, true, FPHAlign.Center, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96bdcb5f | this.Load 외 2 | SCM0016_BatchLog.cs:190 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("RUN_STATUS", DefColumns.RUN_STATUS, FPMerge.None, 80, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-798403e8 | this.Load 외 2 | SCM0016_BatchLog.cs:191 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Run Status", DefColumns.RUN_STATUS_NAME, FPMerge.None, 80, true, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7ba06e2 | this.Load 외 2 | SCM0016_BatchLog.cs:192 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Run Duration", DefColumns.RUN_DURATION, FPMerge.None, 80, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-486b1a41 | this.Load 외 2 | SCM0016_BatchLog.cs:193 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Last Run Status Message", DefColumns.RUN_STATUS_MESSAGE, FPMerge.None, 250, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3faf8fd6 | this.Load 외 2 | SCM0016_BatchLog.cs:194 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Next Run Date", DefColumns.NEXT_RUN_DATE, FPMerge.None, 150, true, FPHAlign.Center, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40f6df1b | this.Load 외 2 | SCM0016_BatchLog.cs:196 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, spreadInfo.GetColumnIndex(DefColumns.SCHEDULE_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8b0d51d6 | this.Load 외 2 | SCM0016_BatchLog.cs:200 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d99d49c2 | this.Load 외 2 | SCM0016_BatchLog.cs:202 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("JOB_ID", DefColumns.JOB_ID, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ef6cf7f | this.Load 외 2 | SCM0016_BatchLog.cs:203 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("JOB_NAME", DefColumns.JOB_NAME, FPMerge.None, 300, false, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d88f2e86 | this.Load 외 2 | SCM0016_BatchLog.cs:204 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("STEP_UID", DefColumns.STEP_UID, FPMerge.None, 200, false, FPHAlign.Left, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-461aa5d4 | this.Load 외 2 | SCM0016_BatchLog.cs:205 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("STEP_ID", DefColumns.STEP_ID, FPMerge.None, 160, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-742c23fc | this.Load 외 2 | SCM0016_BatchLog.cs:206 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("Step Name", DefColumns.STEP_NAME, FPMerge.None, 120, true, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d1f7d0c | this.Load 외 2 | SCM0016_BatchLog.cs:207 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("Step Type", DefColumns.STEP_TYPE, FPMerge.None, 160, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-212523b2 | this.Load 외 2 | SCM0016_BatchLog.cs:208 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("Command", DefColumns.EXEC_COMMAND, FPMerge.None, 170, true, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-450db8c9 | this.Load 외 2 | SCM0016_BatchLog.cs:209 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("OnSuccessAction", DefColumns.ON_SUCCESS_ACTION, FPMerge.None, 200, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9b9e8d1 | this.Load 외 2 | SCM0016_BatchLog.cs:210 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("Retry Attempts", DefColumns.RETRY_ATTEMPTS, FPMerge.None, 100, true, FPHAlign.Right, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5491c041 | this.Load 외 2 | SCM0016_BatchLog.cs:211 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("Retry Interval(Minutes)", DefColumns.RETRY_INTERVAL, FPMerge.None, 100, true, FPHAlign.R… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29b26c1c | this.Load 외 2 | SCM0016_BatchLog.cs:212 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.AddTextColumn | ("OnFailureAction", DefColumns.ON_FAILURE_ACTION, FPMerge.None, 200, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5350c7c | this.Load 외 2 | SCM0016_BatchLog.cs:215 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtStep) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1d04b7ea | this.Load 외 2 | SCM0016_BatchLog.cs:220 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ea61d336 | this.Load 외 2 | SCM0016_BatchLog.cs:222 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.AddTextColumn | ("JOB_ID", DefColumns.JOB_ID, FPMerge.None, 40, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ad764731 | this.Load 외 2 | SCM0016_BatchLog.cs:223 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.AddTextColumn | ("RUN_DATE", DefColumns.RUN_DATE, FPMerge.None, 150, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ca96009 | this.Load 외 2 | SCM0016_BatchLog.cs:224 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.AddTextColumn | ("RUN_STATUS", DefColumns.RUN_STATUS, FPMerge.None, 200, false, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11df0755 | this.Load 외 2 | SCM0016_BatchLog.cs:225 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.AddTextColumn | ("Run Status", DefColumns.RUN_STATUS_NAME, FPMerge.None, 80, true, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c76125b3 | this.Load 외 2 | SCM0016_BatchLog.cs:226 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.AddTextColumn | ("Run Duration", DefColumns.RUN_DURATION, FPMerge.None, 80, true, FPHAlign.Center, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08b0f1c0 | this.Load 외 2 | SCM0016_BatchLog.cs:227 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.AddTextColumn | ("Run Status Message", DefColumns.RUN_STATUS_MESSAGE, FPMerge.None, 250, true, FPHAlign.Le… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-770dd0b9 | this.Load 외 2 | SCM0016_BatchLog.cs:228 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ else of (spreadInfo.SheetName == SpdSheet.shtStep) ▸ if (spreadInfo.SheetName == SpdShe… | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0016_BatchLog.spdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-44708843 | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:258 |  | FLAG | this.spdMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ad2872bd | spdMain.CellDoubleClick | SCM0016_BatchLog.cs:259 |  | FLAG | this.spdMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

