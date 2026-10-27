# AS-IS 액션 대조표 — SCP0015

> 원천: `Doc/asisfacts/screens/SCP0015/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 306행 · 메서드 27 · 종류 GRID_INIT 74 · DATA_OP 46 · GRID_SET 33 · FLAG 28 · ENDPOINT 20 · RETURN 17 · CALL_EXT 16 · MESSAGE 14 · UI_PROP 13 · GRID_STYLE 11 · UI_MISC 9 · GRID_COMBO 7 · POPUP 3 · GRID_LOCK 3 · VALIDATE 3 · LIST_REBIND 3 · VALUE_SET 2 · THROW 2 · GRID_BIND 2 · ⚠ 의미 확인 필요 16


## SCP0015_PlanManagement.BtnStop_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-411ed272 | (진입점 미연결) | SCP0015_PlanManagement.cs:458 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00185", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0015_PlanManagement.CallEnginCancel

진입점: spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.CANCEL) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.CAN…) ▸ if (MessageHelper.GMessageBox("MSG00195", new object[] { "" }) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7605f18d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:600 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_SAVE_PLAN_MST_CANCEL") ⇒ SCP.SCP0015_SAVE_PLAN_MST_CANCEL | 엔드포인트 요청 생성 |  |  |  |
| AC-1f7096d3 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:604 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_ANALYSIS_SVC)) { request.P… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a1acea54 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:608 | lambda | DATA_OP | request.Parameters["p_modeling_id"] | p_modeling_id | 행/컬럼 값 대입 |  |  |  |
| AC-7fb92cb0 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:609 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6cc142c7 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:610 | lambda | DATA_OP | request.Parameters["p_revision_no"] | p_revision_no | 행/컬럼 값 대입 |  |  |  |
| AC-6b00f590 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:611 | lambda | DATA_OP | request.Parameters["p_confirm_user"] | p_confirm_user | 행/컬럼 값 대입 |  |  |  |
| AC-61ca468b | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:613 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-978436ff | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:613 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-1a7b17b5 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:623 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40b60eb1 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:632 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0015_PlanManagement.CallEnginRun

진입점: spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56564cfe | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:532 | if (string.IsNullOrEmpty(strModelingId) \|\| string.IsNullOrEmpty(strPlanType)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00205", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-830f9953 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:533 | if (string.IsNullOrEmpty(strModelingId) \|\| string.IsNullOrEmpty(strPlanType)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3393df7d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:542 |  | CALL_EXT | Thread.Sleep | (interval) | ⚠ 의미 확인 필요 |  |  |  |
| AC-509bffd9 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:554 | if (!string.IsNullOrEmpty(strNew_REVISION_NO) && strOld_REVISION_NO != strNew_REVISION_NO) | FLAG | isUserRunPlan | true | 화면 필드/플래그 변경 |  |  |  |
| AC-85d676ff | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:555 | if (!string.IsNullOrEmpty(strNew_REVISION_NO) && strOld_REVISION_NO != strNew_REVISION_NO) | FLAG | userRun_RevisonNo | strNew_REVISION_NO | 화면 필드/플래그 변경 |  |  |  |
| AC-46987182 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:562 | else of (!string.IsNullOrEmpty(strNew_REVISION_NO) && strOld_REVISION_NO != strNew_REVISION_NO) ▸ for (i < 10) | CALL_EXT | Thread.Sleep | (interval) | ⚠ 의미 확인 필요 |  |  |  |
| AC-829669fe | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:568 | else of (!string.IsNullOrEmpty(strNew_REVISION_NO) && strOld_REVISION_NO != strNew_REVISION_NO) ▸ for (i < 10) ▸ if (!string.IsNullOrEmpty(s… | FLAG | isUserRunPlan | true | 화면 필드/플래그 변경 |  |  |  |
| AC-4c0045d2 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:569 | else of (!string.IsNullOrEmpty(strNew_REVISION_NO) && strOld_REVISION_NO != strNew_REVISION_NO) ▸ for (i < 10) ▸ if (!string.IsNullOrEmpty(s… | FLAG | userRun_RevisonNo | strNew_REVISION_NO | 화면 필드/플래그 변경 |  |  |  |
| AC-4aab2b81 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:579 |  | GRID_STYLE | siPlan.ActiveSheet.SetActiveCell | (this.nSelRowSpdPlan, this.nSelColSpdPlan) | 그리드 표시 설정 |  |  |  |
| AC-559fff11 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:580 |  | CALL_EXT | spdPlan.ShowCell | (0, 0, this.nSelRowSpdPlan, this.nSelColSpdPlan, FarPoint.Win.Spread.VerticalPosition.Cent… | ⚠ 의미 확인 필요 |  |  |  |

## SCP0015_PlanManagement.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908b4ff6 | this.Load | SCP0015_PlanManagement.cs:251 |  | GRID_INIT | this.AddSheet | (spdPlan, SpdSheet.shtPlan, SpdSheet.shtPlan, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0487be9d | this.Load | SCP0015_PlanManagement.cs:252 |  | FLAG | siPlan | GetSheetInfo(spdPlan.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-e468a82f | this.Load | SCP0015_PlanManagement.cs:254 |  | GRID_INIT | this.AddSheet | (spdEngin, SpdSheet.shtEngin, SpdSheet.shtEngin, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c9134ad7 | this.Load | SCP0015_PlanManagement.cs:255 |  | FLAG | siEngin | GetSheetInfo(spdEngin.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-af6573b2 | this.Load | SCP0015_PlanManagement.cs:258 |  | GRID_INIT | siPlan.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0015_PlanManagement.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1dbf694 | this.Load | SCP0015_PlanManagement.cs:222 |  | VALUE_SET | lcRevision.Text | MessageHelper.GetTerm(lcRevision.Text) | 컨트롤 값 설정 |  |  |  |

## SCP0015_PlanManagement.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a7592f5 | Dispose | SCP0015_PlanManagement.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0015_PlanManagement.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbcaf2ac | ExcelButton | SCP0015_PlanManagement.cs:478 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-aefbcb4d | ExcelButton | SCP0015_PlanManagement.cs:479 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-393dbf89 | ExcelButton | SCP0015_PlanManagement.cs:480 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-c5473980 | ExcelButton | SCP0015_PlanManagement.cs:481 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-75cc9c51 | ExcelButton | SCP0015_PlanManagement.cs:482 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-49a9727f | ExcelButton | SCP0015_PlanManagement.cs:484 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-f40b43fb | ExcelButton | SCP0015_PlanManagement.cs:485 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-4b4f6cd3 | ExcelButton | SCP0015_PlanManagement.cs:487 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-2f55f430 | ExcelButton | SCP0015_PlanManagement.cs:492 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-49b9a29c | ExcelButton | SCP0015_PlanManagement.cs:497 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-43a8ea99 | ExcelButton | SCP0015_PlanManagement.cs:501 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0015_PlanManagement.FindData_Confirm

진입점: dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-596f5103 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1314 | if (siPlan.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7744bf95 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1324 |  | FLAG | this.strSelMODELING_ID | p_modeling_id | 화면 필드/플래그 변경 |  |  |  |
| AC-a9e573df | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1325 |  | FLAG | this.strSelDIVISION_ID | p_division_id | 화면 필드/플래그 변경 |  |  |  |
| AC-47dd9d01 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1326 |  | FLAG | this.strSelREVISION_NO | strREVISION_NO | 화면 필드/플래그 변경 |  |  |  |
| AC-ed066b4c | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1336 |  | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29798fd0 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1339 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_GET_PLAN_MST_COMFIRM") ⇒ SCP.SCP0015_GET_PLAN_MST_COMFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-580ec7b9 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1341 | lambda | DATA_OP | req.Parameters["p_modeling_id"] | p_modeling_id | 행/컬럼 값 대입 |  |  |  |
| AC-77df1350 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1342 | lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb82a574 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1343 | lambda | DATA_OP | req.Parameters["p_revision_no"] | p_revision_no | 행/컬럼 값 대입 |  |  |  |
| AC-99b3eb9d | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1348 | lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-25d9aea1 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1349 | lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eae25e73 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1363 | if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siPlan.SetText | (nSpdIdx, siPlan.GetColumnIndex(DefColumns.CONFIRM_YN), strCONFIRM_YN) | 그리드 값 설정 |  |  |  |
| AC-754fb838 | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1364 | if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siPlan.SetText | (nSpdIdx, siPlan.GetColumnIndex(DefColumns.CONFIRM_USER), strCONFIRM_USER) | 그리드 값 설정 |  |  |  |
| AC-6b28119a | dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread… | SCP0015_PlanManagement.cs:1365 | if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_SET | siPlan.SetText | (nSpdIdx, siPlan.GetColumnIndex(DefColumns.CONFIRM_TIME), strCONFIRM_TIME) | 그리드 값 설정 |  |  |  |

## SCP0015_PlanManagement.FindData_Engin

진입점: spdPlan.CellDoubleClick / spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:] / timerStatus.Tick [try] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b65bce45 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1087 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-dd84136c | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1091 | try ▸ if (siPlan.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48d68bed | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1165 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-310b1e9f | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1167 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-74bd9431 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1170 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_GET_PLAN_ENGINE_RUN") ⇒ SCP.SCP0015_GET_PLAN_ENGINE_RUN | 엔드포인트 요청 생성 |  |  |  |
| AC-7dc322b0 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1172 | try ▸ lambda | DATA_OP | req.Parameters["p_modeling_id"] | p_modeling_id | 행/컬럼 값 대입 |  |  |  |
| AC-edd2b63d | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1173 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ffc34d02 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1174 | try ▸ lambda | DATA_OP | req.Parameters["p_revision_no"] | p_revision_no | 행/컬럼 값 대입 |  |  |  |
| AC-95ab548c | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1179 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2eb28cd5 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1180 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5bd3bcd1 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1190 | try ▸ if (!isStatusCheck) | GRID_BIND | siEngin.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b60bdfb0 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1191 | try ▸ if (!isStatusCheck) | GRID_LOCK | siEngin.LockColumn | (0, siEngin.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0a15f774 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1192 | try ▸ if (!isStatusCheck) | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4004d824 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1193 | try ▸ if (!isStatusCheck) | GRID_INIT | siEngin.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-668699b2 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1218 | try ▸ if (!isStatusCheck) | VALUE_SET | txtRevision.Text | p_revision_no | 컨트롤 값 설정 |  |  |  |
| AC-e995fdfe | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1261 | try ▸ if (nRowIdx != -1) ▸ if (dsBinding.Tables.Count > 1 && dsBinding.Tables[1].Rows.Count > 0) ▸ if (strPLAN_STATUS != strNew_PLAN_STATUS) | GRID_SET | siPlan.SetText | (nRowIdx, siPlan.GetColumnIndex(DefColumns.PLAN_STATUS), strNew_PLAN_STATUS) | 그리드 값 설정 |  |  |  |
| AC-017db09b | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1262 | try ▸ if (nRowIdx != -1) ▸ if (dsBinding.Tables.Count > 1 && dsBinding.Tables[1].Rows.Count > 0) ▸ if (strPLAN_STATUS != strNew_PLAN_STATUS) | GRID_SET | siPlan.SetText | (nRowIdx, siPlan.GetColumnIndex(DefColumns.PLAN_STATUS_NAME), strNew_PLAN_STATUS_NAME) | 그리드 값 설정 |  |  |  |
| AC-76ff8451 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1270 | try ▸ if (nRowIdx != -1) ▸ if (dsBinding.Tables.Count > 1 && dsBinding.Tables[1].Rows.Count > 0) ▸ if (strPLAN_STATUS != strNew_PLAN_STATUS)… | FLAG | isUserRunPlan | false | 화면 필드/플래그 변경 |  |  |  |
| AC-31ea20ad | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1271 | try ▸ if (nRowIdx != -1) ▸ if (dsBinding.Tables.Count > 1 && dsBinding.Tables[1].Rows.Count > 0) ▸ if (strPLAN_STATUS != strNew_PLAN_STATUS)… | FLAG | userRun_RevisonNo | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-83ea3d90 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1296 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-984773c9 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1301 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b5d874c0 | spdPlan.CellDoubleClick 외 4 | SCP0015_PlanManagement.cs:1306 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0015_PlanManagement.FindData_Plan

진입점: spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37b661ea | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:962 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-17541467 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:967 | try | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-8662937f | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:967 | try ▸ if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b562d67 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:985 | try | FLAG | nSelPlanWeek | cboPlanWeek.SelectedIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-c8bd39ba | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:994 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ba71d6c6 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:995 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-fe80802d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:998 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_GET_PLAN_MST") ⇒ SCP.SCP0015_GET_PLAN_MST | 엔드포인트 요청 생성 |  |  |  |
| AC-c27353c3 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1000 | try | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8dca3be8 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1001 | try | DATA_OP | req.Parameters["p_plan_year"] | p_plan_year | 행/컬럼 값 대입 |  |  |  |
| AC-1eb030b9 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1002 | try | DATA_OP | req.Parameters["p_plan_week"] | p_plan_week | 행/컬럼 값 대입 |  |  |  |
| AC-adb4b60a | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1003 | try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea255812 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1004 | try | DATA_OP | req.Parameters["p_group_id"] | p_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc04f144 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1007 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7ff4346 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1020 | try | GRID_BIND | siPlan.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-77701f97 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1021 | try | GRID_LOCK | siPlan.LockColumn | (0, siPlan.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-56e02fb8 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1022 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6ef5a2e1 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1023 | try | GRID_INIT | siPlan.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd51a817 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1024 | try | GRID_STYLE | siPlan.ActiveSheet.SetColumnMerge | (siPlan.GetColumnIndex(DefColumns.DIVISION_NAME), FarPoint.Win.Spread.Model.MergePolicy.Al… | 그리드 표시 설정 |  |  |  |
| AC-88eba635 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1030 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionTE | ds.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-0bb46116 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1031 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionTM | ds.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-5aaa4639 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1032 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionPR | ds.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-8f1b3852 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1033 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionMA | ds.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c0b222d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1034 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionSE | ds.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c7e5a08 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1035 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionFN | ds.Tables[6] | 화면 필드/플래그 변경 |  |  |  |
| AC-8b92ad3e | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1036 | try ▸ if (ds.Tables.Count > 0) | FLAG | dtRevisionSU | ds.Tables[7] | 화면 필드/플래그 변경 |  |  |  |
| AC-fdb408ce | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1042 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ if (strPLAN_TYPE=="TE") | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionTE) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f4aefa49 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1044 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ else of (strPLAN_TYPE=="TE") ▸ if (strPLAN_TYPE == "TM") | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionTM) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-545f4270 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1046 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ else of (strPLAN_TYPE=="TE") ▸ else of (strPLAN_TYPE == "TM") ▸ i… | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionPR) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f3af0ff9 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1048 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ else of (strPLAN_TYPE=="TE") ▸ else of (strPLAN_TYPE == "TM") ▸ e… | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionMA) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-bcd2a01d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1050 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ else of (strPLAN_TYPE=="TE") ▸ else of (strPLAN_TYPE == "TM") ▸ e… | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionSE) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-03fbcd8d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1052 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ else of (strPLAN_TYPE=="TE") ▸ else of (strPLAN_TYPE == "TM") ▸ e… | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionFN) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5fc2e1e0 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1054 | try ▸ if (ds.Tables.Count > 0) ▸ for (i < siPlan.ActiveSheet.Rows.Count) ▸ else of (strPLAN_TYPE=="TE") ▸ else of (strPLAN_TYPE == "TM") ▸ e… | GRID_COMBO | siPlan.SetCellTypeCombo | (i, siPlan.GetColumnIndex(DefColumns.REVISION_NO), dtRevisionSU) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-39711f15 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1065 | try | GRID_LOCK | siPlan.LockColumn | (siPlan.GetColumnIndex(DefColumns.REVISION_NO), siPlan.GetColumnIndex(DefColumns.REVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0bf0b009 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1068 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-36f5f842 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1073 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a297a43 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 1 | SCP0015_PlanManagement.cs:1078 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0015_PlanManagement.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2022593 | this.Load | SCP0015_PlanManagement.cs:207 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0015_PlanManagement.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7825f0b5 | this.Load | SCP0015_PlanManagement.cs:232 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanWeek) | 데이터 객체 조작/조회 |  |  |  |
| AC-7fe08482 | this.Load | SCP0015_PlanManagement.cs:234 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-d8368905 | this.Load | SCP0015_PlanManagement.cs:235 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl3,false) | 권한 검사/설정 |  |  |  |
| AC-643a7a9c | this.Load | SCP0015_PlanManagement.cs:240 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c47b777a | this.Load | SCP0015_PlanManagement.cs:244 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0015_PlanManagement.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3620ac32 | this.Load | SCP0015_PlanManagement.cs:378 |  | UI_PROP | timerStatus.Interval | 1000 * 2 | 속성 Interval 설정 |  |  |  |

## SCP0015_PlanManagement.InitSpread

진입점: this.Load / spdPlan.CellDoubleClick [try ▸ if (!isStatusCheck)] / spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ try ▸ if (!isStatusCheck)] / timerStatus.Tick [try ▸ try ▸ if (!isStatusCheck)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb4210a6 | this.Load 외 5 | SCP0015_PlanManagement.cs:271 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlan) | 그리드 재구성/초기화 |  |  |  |
| AC-0f81c4ac | this.Load 외 5 | SCP0015_PlanManagement.cs:272 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3879326 | this.Load 외 5 | SCP0015_PlanManagement.cs:273 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("MODELING_ID", DefColumns.MODELING_ID, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db9ef764 | this.Load 외 5 | SCP0015_PlanManagement.cs:274 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("PLAN_ID", DefColumns.PLAN_ID, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2701631a | this.Load 외 5 | SCP0015_PlanManagement.cs:275 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Division Id", DefColumns.DIVISION_ID, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69336cf8 | this.Load 외 5 | SCP0015_PlanManagement.cs:276 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Division", DefColumns.DIVISION_NAME, FPMerge.Always, 130, true, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9a8ba87 | this.Load 외 5 | SCP0015_PlanManagement.cs:277 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Plan Type", DefColumns.PLAN_TYPE, FPMerge.Always, 100, false, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70d6af55 | this.Load 외 5 | SCP0015_PlanManagement.cs:278 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Plan Type" , DefColumns.PLAN_TYPE_DESCRIPTION, FPMerge.Always, 100, true, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e87dd066 | this.Load 외 5 | SCP0015_PlanManagement.cs:279 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddButtonColumn | ("Engine Run", DefColumns.RUN, FPMerge.Always, 120, true, FPHAlign.Center, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3da9df7c | this.Load 외 5 | SCP0015_PlanManagement.cs:280 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddButtonColumn | ("Cancel", DefColumns.CANCEL, FPMerge.Always, 120, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d173ebcc | this.Load 외 5 | SCP0015_PlanManagement.cs:281 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddButtonColumn | ("Confirm", DefColumns.CONFIRM, FPMerge.Always, 120, true, FPHAlign.Center, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51f1729f | this.Load 외 5 | SCP0015_PlanManagement.cs:282 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddComboColumn | ("Revision No", DefColumns.REVISION_NO, FPMerge.None, 120, true, dtRevision, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec68552a | this.Load 외 5 | SCP0015_PlanManagement.cs:283 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Status", DefColumns.PLAN_STATUS_NAME,FPMerge.None, 170, true, FPHAlign.Left, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce087f48 | this.Load 외 5 | SCP0015_PlanManagement.cs:284 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Status", DefColumns.PLAN_STATUS, FPMerge.None, 170, false, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a97bfb86 | this.Load 외 5 | SCP0015_PlanManagement.cs:285 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddDateTimeColumn | ("Confirm Time", DefColumns.CONFIRM_TIME, FPMerge.None, 200, true, FPHAlign.Center, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a19c0284 | this.Load 외 5 | SCP0015_PlanManagement.cs:286 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("Confirm User", DefColumns.CONFIRM_USER, FPMerge.None, 130, true, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-17c33e20 | this.Load 외 5 | SCP0015_PlanManagement.cs:287 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("CONFIRM_YN", DefColumns.CONFIRM_YN, FPMerge.Always, 130, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa0e03ab | this.Load 외 5 | SCP0015_PlanManagement.cs:288 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("CONFIRM_AUTH", DefColumns.CONFIRM_AUTH, FPMerge.Always, 130, false, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fae6f2e9 | this.Load 외 5 | SCP0015_PlanManagement.cs:289 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("RUN_AUTH", DefColumns.RUN_AUTH, FPMerge.Always, 130, false, FPHAlign.Left, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-200af2cf | this.Load 외 5 | SCP0015_PlanManagement.cs:290 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.AddTextColumn | ("CANCEL_AUTH", DefColumns.CANCEL_AUTH, FPMerge.Always, 130, false, FPHAlign.Left, FPVAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-669f432f | this.Load 외 5 | SCP0015_PlanManagement.cs:293 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.MODELING_ID) , 2, 1, 20, "Division Id", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cc83c17 | this.Load 외 5 | SCP0015_PlanManagement.cs:294 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_ID) , 2, 1, 20, "Division Id", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87ff7201 | this.Load 외 5 | SCP0015_PlanManagement.cs:295 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.DIVISION_ID) , 2, 1, 20, "Division Id" , FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebc64f71 | this.Load 외 5 | SCP0015_PlanManagement.cs:296 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.DIVISION_NAME), 2, 1, 20, "Division" , FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14dfa4fb | this.Load 외 5 | SCP0015_PlanManagement.cs:297 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_TYPE) , 2, 1, 20, "Plan Type" , FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d74eb4cc | this.Load 외 5 | SCP0015_PlanManagement.cs:298 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_TYPE_DESCRIPTION), 2, 1, 20, "Plan Type", FPHAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ece7f36b | this.Load 외 5 | SCP0015_PlanManagement.cs:299 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefColumns.RUN) , 1, 1, 20, "Engine Run" , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-845cd55f | this.Load 외 5 | SCP0015_PlanManagement.cs:300 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefColumns.CANCEL) , 1, 1, 20, "Engine Cancel" , FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-247a926b | this.Load 외 5 | SCP0015_PlanManagement.cs:301 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefColumns.CONFIRM) , 1, 1, 20, "Confirm" , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b8f6dc7 | this.Load 외 5 | SCP0015_PlanManagement.cs:302 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.REVISION_NO) , 2, 1, 20, "Revision No" , FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a0316b6 | this.Load 외 5 | SCP0015_PlanManagement.cs:303 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_STATUS_NAME), 2, 1, 20, "Status" , FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14cccd0b | this.Load 외 5 | SCP0015_PlanManagement.cs:304 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_STATUS), 2, 1, 20, "Status", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a73ac34 | this.Load 외 5 | SCP0015_PlanManagement.cs:305 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.CONFIRM_TIME) , 2, 1, 20, "Confirm Time" , FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a46cae9a | this.Load 외 5 | SCP0015_PlanManagement.cs:306 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.CONFIRM_USER) , 2, 1, 20, "Confirm User" , FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81a81dfe | this.Load 외 5 | SCP0015_PlanManagement.cs:307 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.CONFIRM_YN), 2, 1, 20, "CONFIRM_YN", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a533b1ce | this.Load 외 5 | SCP0015_PlanManagement.cs:308 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.CONFIRM_AUTH), 2, 1, 20, "CONFIRM_AUTH", FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5c18263 | this.Load 외 5 | SCP0015_PlanManagement.cs:309 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.RUN_AUTH), 2, 1, 20, "RUN_AUTH", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-208a566a | this.Load 외 5 | SCP0015_PlanManagement.cs:310 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.CANCEL_AUTH), 2, 1, 20, "CANCEL_AUTH", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64831d8a | this.Load 외 5 | SCP0015_PlanManagement.cs:315 | if (spdInfo.SheetName == SpdSheet.shtPlan) | CALL_EXT | clsCtrl.HeaderSpan | (spdInfo, 0, spdInfo.GetColumnIndex(DefColumns.RUN), 1, 3, "Action") | ⚠ 의미 확인 필요 |  |  |  |
| AC-41eebdd0 | this.Load 외 5 | SCP0015_PlanManagement.cs:318 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9609a7a4 | this.Load 외 5 | SCP0015_PlanManagement.cs:319 | if (spdInfo.SheetName == SpdSheet.shtPlan) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-be467308 | this.Load 외 5 | SCP0015_PlanManagement.cs:323 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtEngin) | 그리드 재구성/초기화 |  |  |  |
| AC-28879eee | this.Load 외 5 | SCP0015_PlanManagement.cs:325 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a51d67f8 | this.Load 외 5 | SCP0015_PlanManagement.cs:326 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("MODELING_ID", DefColumns.MODELING_ID, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a9e1e1a | this.Load 외 5 | SCP0015_PlanManagement.cs:327 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("PLAN_ID", DefColumns.PLAN_ID, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94d8c0de | this.Load 외 5 | SCP0015_PlanManagement.cs:328 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("PLAN_NAME", DefColumns.PLAN_NAME, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04cab653 | this.Load 외 5 | SCP0015_PlanManagement.cs:329 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("DIVISION_ID", DefColumns.DIVISION_ID, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6d5d3ca | this.Load 외 5 | SCP0015_PlanManagement.cs:330 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("PLAN_TYPE", DefColumns.PLAN_TYPE, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c782af3 | this.Load 외 5 | SCP0015_PlanManagement.cs:331 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("PLAN_SEQ", DefColumns.PLAN_SEQ, FPMerge.Always, 60, false, FPHAlign.Left, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9828441e | this.Load 외 5 | SCP0015_PlanManagement.cs:332 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("Step", DefColumns.STEP_NAME, FPMerge.None, 170, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51e89b6a | this.Load 외 5 | SCP0015_PlanManagement.cs:333 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("Step", DefColumns.STEP_PROCESS1, FPMerge.None, 60, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58aab0fa | this.Load 외 5 | SCP0015_PlanManagement.cs:334 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("Step", DefColumns.STEP_PROCESS2, FPMerge.None, 60, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dcdbe25a | this.Load 외 5 | SCP0015_PlanManagement.cs:335 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("Step", DefColumns.STEP_PROCESS3, FPMerge.None, 60, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a421a6e | this.Load 외 5 | SCP0015_PlanManagement.cs:336 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("Step", DefColumns.STEP_PROCESS4, FPMerge.None, 60, true, FPHAlign.Left, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6bc5e57c | this.Load 외 5 | SCP0015_PlanManagement.cs:337 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddTextColumn | ("STEP_STATUS", DefColumns.STEP_STATUS, FPMerge.None, 100, false, FPHAlign.Left, FPVAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4fb3b343 | this.Load 외 5 | SCP0015_PlanManagement.cs:338 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddDateTimeColumn | ("Start Time", DefColumns.START_TIME, FPMerge.None, 200, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d575661 | this.Load 외 5 | SCP0015_PlanManagement.cs:339 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.AddDateTimeColumn | ("End Time", DefColumns.END_TIME, FPMerge.None, 200, true, FPHAlign.Center, FPVAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ebce0c78 | this.Load 외 5 | SCP0015_PlanManagement.cs:342 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.MODELING_ID) , 2, 1, 20, "MODELING_ID", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-809c826d | this.Load 외 5 | SCP0015_PlanManagement.cs:343 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_ID) , 2, 1, 20, "PLAN_ID", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8139cea7 | this.Load 외 5 | SCP0015_PlanManagement.cs:344 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_NAME), 2, 1, 20, "PLAN_NAME", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ab532d0 | this.Load 외 5 | SCP0015_PlanManagement.cs:345 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.DIVISION_ID) , 2, 1, 20, "DIVISION_ID", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60086f77 | this.Load 외 5 | SCP0015_PlanManagement.cs:346 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_TYPE) , 2, 1, 20, "Plan Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-23415980 | this.Load 외 5 | SCP0015_PlanManagement.cs:347 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.PLAN_SEQ) , 2, 1, 20, "Plan Seq", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4eac46d9 | this.Load 외 5 | SCP0015_PlanManagement.cs:348 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.STEP_NAME) , 2, 1, 20, "Step", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0e784d5 | this.Load 외 5 | SCP0015_PlanManagement.cs:349 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, spdInfo.GetColumnIndex(DefColumns.STEP_PROCESS1), 1, 4, 20, "Step", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c43845b3 | this.Load 외 5 | SCP0015_PlanManagement.cs:350 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.STEP_STATUS), 2, 1, 20, "STEP_STATUS", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ce1e45a | this.Load 외 5 | SCP0015_PlanManagement.cs:351 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.START_TIME) , 2, 1, 20, "Start Time", FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae1d2891 | this.Load 외 5 | SCP0015_PlanManagement.cs:352 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefColumns.END_TIME) , 2, 1, 20, "End Time", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c4f7a1a | this.Load 외 5 | SCP0015_PlanManagement.cs:354 | if (spdInfo.SheetName == SpdSheet.shtEngin) | CALL_EXT | clsCtrl.HeaderSpan | (spdInfo, 0, spdInfo.GetColumnIndex(DefColumns.STEP_PROCESS1), 1, 4, "Process Log") | ⚠ 의미 확인 필요 |  |  |  |
| AC-025bc514 | this.Load 외 5 | SCP0015_PlanManagement.cs:356 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c5b09bf | this.Load 외 5 | SCP0015_PlanManagement.cs:357 | if (spdInfo.SheetName == SpdSheet.shtEngin) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0015_PlanManagement.RefreshPlanWeek

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanYear.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53498524 | this.Load 외 2 | SCP0015_PlanManagement.cs:941 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanWeek | DBUtils.Filter(dtPlanWeekAll, "DIVISION_ID = '" + division + "' AND PLAN_YEAR LIKE '%" + p… | 화면 필드/플래그 변경 |  |  |  |
| AC-2eaf2512 | this.Load 외 2 | SCP0015_PlanManagement.cs:941 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanWeekAll, "DIVISION_ID = '" + division + "' AND PLAN_YEAR LIKE '%" + pPlanYear + "%'… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-19292571 | this.Load 외 2 | SCP0015_PlanManagement.cs:945 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanWeek | dtPlanWeekAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-c7109259 | this.Load 외 2 | SCP0015_PlanManagement.cs:945 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtPlanWeekAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9a2b60f2 | this.Load 외 2 | SCP0015_PlanManagement.cs:948 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanWeek, cboPlanWeek, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0015_PlanManagement.RefreshPlanYear

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf4c2abb | this.Load 외 1 | SCP0015_PlanManagement.cs:925 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanYear | DBUtils.Filter(dtPlanYearAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-c46eb6f8 | this.Load 외 1 | SCP0015_PlanManagement.cs:925 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanYearAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2982681b | this.Load 외 1 | SCP0015_PlanManagement.cs:929 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanYear | dtPlanYearAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-f77b17c9 | this.Load 외 1 | SCP0015_PlanManagement.cs:929 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtPlanYearAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a6d32412 | this.Load 외 1 | SCP0015_PlanManagement.cs:931 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanYear, cboPlanYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0015_PlanManagement.SaveData_PlanConfirm

진입점: spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.CONFIRM) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.CO…) ▸ if (MessageHelper.GMessageBox("MSG00184", new object[] { "" }) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e820c2db | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1416 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_SAVE_PLAN_MST_COMFIRM") ⇒ SCP.SCP0015_SAVE_PLAN_MST_COMFIRM | 엔드포인트 요청 생성 |  |  |  |
| AC-d3e7ac99 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1420 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_ANALYSIS_SVC)) { request.P… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3c2b485f | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1424 | lambda | DATA_OP | request.Parameters["p_modeling_id"] | p_modeling_id | 행/컬럼 값 대입 |  |  |  |
| AC-05316678 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1425 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-930a78eb | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1426 | lambda | DATA_OP | request.Parameters["p_revision_no"] | p_revision_no | 행/컬럼 값 대입 |  |  |  |
| AC-78178d2a | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1427 | lambda | DATA_OP | request.Parameters["p_confirm_user"] | p_confirm_user | 행/컬럼 값 대입 |  |  |  |
| AC-d9a31ea8 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1429 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6694eded | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1429 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-e57c70f9 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1439 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18fe0344 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1448 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_SET | siPlan.SetText | (nSpdIdx, siPlan.GetColumnIndex(DefColumns.CONFIRM_YN), strCONFIRM_YN) | 그리드 값 설정 |  |  |  |
| AC-5022090d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1449 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_SET | siPlan.SetText | (nSpdIdx, siPlan.GetColumnIndex(DefColumns.CONFIRM_USER), strCONFIRM_USER) | 그리드 값 설정 |  |  |  |
| AC-a79c1a67 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1450 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_SET | siPlan.SetText | (nSpdIdx, siPlan.GetColumnIndex(DefColumns.CONFIRM_TIME), strCONFIRM_TIME) | 그리드 값 설정 |  |  |  |
| AC-48c65780 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1460 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0015_PlanManagement.SaveData_PlanRun

진입점: spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70d0e520 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1558 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_SAVE_PLAN_MST_RUN") ⇒ SCP.SCP0015_SAVE_PLAN_MST_RUN | 엔드포인트 요청 생성 |  |  |  |
| AC-634f703e | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1561 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4a7af60e | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1563 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_ANALYSIS_SVC)) { request.C… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2bd823bd | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1567 | lambda | UI_PROP | request.CommandTimeout | 60 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-15fe03f9 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1568 | lambda | DATA_OP | request.Parameters["p_modeling_id"] | p_modeling_id | 행/컬럼 값 대입 |  |  |  |
| AC-6d0da0c4 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1569 | lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-e3128094 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1571 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7dc43da | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1571 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-bac54bbc | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1584 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | GRID_STYLE | siPlan.ActiveSheet.SetActiveCell | (this.nSelRowSpdPlan, this.nSelColSpdPlan) | 그리드 표시 설정 |  |  |  |
| AC-f900cf55 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1585 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | CALL_EXT | spdPlan.ShowCell | (0, 0, this.nSelRowSpdPlan, this.nSelColSpdPlan, FarPoint.Win.Spread.VerticalPosition.Cent… | ⚠ 의미 확인 필요 |  |  |  |
| AC-c5b2dbb1 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… | SCP0015_PlanManagement.cs:1594 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0015_PlanManagement.SaveData_PlanStop

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3dd5dcb0 | (진입점 미연결) | SCP0015_PlanManagement.cs:1483 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0015_SAVE_PLAN_MST_STOP") ⇒ SCP.SCP0015_SAVE_PLAN_MST_STOP | 엔드포인트 요청 생성 |  |  |  |
| AC-353d30c0 | (진입점 미연결) | SCP0015_PlanManagement.cs:1487 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_ANALYSIS_SVC)) { request.P… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9544b1a0 | (진입점 미연결) | SCP0015_PlanManagement.cs:1491 | lambda | DATA_OP | request.Parameters["p_modeling_id"] | p_modeling_id | 행/컬럼 값 대입 |  |  |  |
| AC-306ecabc | (진입점 미연결) | SCP0015_PlanManagement.cs:1492 | lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-71e1f9ed | (진입점 미연결) | SCP0015_PlanManagement.cs:1493 | lambda | DATA_OP | request.Parameters["p_revision_no"] | p_revision_no | 행/컬럼 값 대입 |  |  |  |
| AC-103fb18c | (진입점 미연결) | SCP0015_PlanManagement.cs:1494 | lambda | DATA_OP | request.Parameters["p_confirm_user"] | p_confirm_user | 행/컬럼 값 대입 |  |  |  |
| AC-3a137c36 | (진입점 미연결) | SCP0015_PlanManagement.cs:1496 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-660bfbbb | (진입점 미연결) | SCP0015_PlanManagement.cs:1496 | lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-1bc6613d | (진입점 미연결) | SCP0015_PlanManagement.cs:1506 | if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { t.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28b2d75c | (진입점 미연결) | SCP0015_PlanManagement.cs:1527 | if (t.Success) ▸ else of (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0015_PlanManagement.SetColorStatus

진입점: spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|\| strPLAN_STATUS == "1" \|\| strPLAN_STATUS == "")] / spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ if (strPLAN_STATUS == "-1" \|\| strPLAN_STATUS == "1" \|\| strPLAN_STATUS == "")] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ try ▸ if (strPLAN_STATUS == "-1" \|\| strPLAN_STATUS =…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0beff129 | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1926 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ if (strSTEP_STATUS == "1") | CALL_EXT | siEngin.GetBGColor | (i, nCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b5c3a4f | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1928 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ if (strSTEP_STATUS == "1") ▸ if (siEngin.GetBGColor(i, nCol1) != ControlColor.ProcessColor) | GRID_STYLE | siEngin.SetBGColor | (i, nCol1, i, nCol4, ControlColor.ProcessColor) | 그리드 표시 설정 |  |  |  |
| AC-367fa78f | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1934 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") | CALL_EXT | siEngin.GetBGColor | (i, nCol4) | ⚠ 의미 확인 필요 |  |  |  |
| AC-034650be | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1936 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ if (siEngin.GetBGColor(i, nCol4) =… | GRID_STYLE | siEngin.SetBGColor | (i, nCol1, i, nCol4, ControlColor.DefaultBackColor) | 그리드 표시 설정 |  |  |  |
| AC-49a5e8a1 | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1938 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | CALL_EXT | siEngin.GetBGColor | (i, nCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-11592e15 | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1940 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | GRID_STYLE | siEngin.SetBGColor | (i, nCol1, i, nCol1, ControlColor.ProcessColor) | 그리드 표시 설정 |  |  |  |
| AC-6a2084c0 | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1942 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | CALL_EXT | siEngin.GetBGColor | (i, nCol2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-435c5486 | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1944 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | GRID_STYLE | siEngin.SetBGColor | (i, nCol2, i, nCol2, ControlColor.ProcessColor) | 그리드 표시 설정 |  |  |  |
| AC-7d5acd9a | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1946 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | CALL_EXT | siEngin.GetBGColor | (i, nCol3) | ⚠ 의미 확인 필요 |  |  |  |
| AC-23859bdc | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1948 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | GRID_STYLE | siEngin.SetBGColor | (i, nCol3, i, nCol3, ControlColor.ProcessColor) | 그리드 표시 설정 |  |  |  |
| AC-2385332f | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1950 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | CALL_EXT | siEngin.GetBGColor | (i, nCol4) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f5f0378e | spdPlan.CellDoubleClick [try ▸ if (strPLAN_STATUS == "-1" \|… 외 4 | SCP0015_PlanManagement.cs:1952 | for (i < siEngin.ActiveSheet.Rows.Count) ▸ else of (strSTEP_STATUS == "1") ▸ if (strSTEP_STATUS == "0") ▸ else of (siEngin.GetBGColor(i, nCo… | GRID_STYLE | siEngin.SetBGColor | (i, nCol4, i, nCol4, ControlColor.ProcessColor) | 그리드 표시 설정 |  |  |  |

## SCP0015_PlanManagement.SetEngineStatus

진입점: spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)] / spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ else of (!isStatusCheck) ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ try ▸ else of (!isStat…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee7f76d8 | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1817 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d5131bf | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1827 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e1fef497 | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1830 | try ▸ if (dt.Rows.Count != dtStatus.Rows.Count) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30cd9d9c | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1833 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.START_TIME] | dtStatus.Rows[i][DefColumns.START_TIME].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-8fbc7290 | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1834 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.END_TIME] | dtStatus.Rows[i][DefColumns.END_TIME].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-b50b9025 | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1835 | try ▸ for (i < dtStatus.Rows.Count) | GRID_SET | dt.Rows[i][DefColumns.STEP_STATUS] | dtStatus.Rows[i][DefColumns.STEP_STATUS].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-dc10d714 | spdPlan.CellDoubleClick [try ▸ else of (!isStatusCheck) ▸ if… 외 4 | SCP0015_PlanManagement.cs:1844 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0015_PlanManagement.SetGridButtonEnabled

진입점: spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ if (ds.Tables.Count > 0)] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated:] / FindButton [try ▸ if (ds.Tables.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-392c69e2 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:677 | for (i >= 0) ▸ if (strCONFIRM_AUTH == "Y") ▸ if (!isCancelOneSet) ▸ if (strPLAN_STATUS == "1") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CANCEL)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-ae6830e5 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:682 | for (i >= 0) ▸ if (strCONFIRM_AUTH == "Y") ▸ if (!isCancelOneSet) ▸ else of (strPLAN_STATUS == "1") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CANCEL)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-31367f7a | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:687 | for (i >= 0) ▸ if (strCONFIRM_AUTH == "Y") ▸ else of (!isCancelOneSet) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CANCEL)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-92148727 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:698 | for (i >= 0) ▸ if (strCONFIRM_AUTH == "Y") ▸ if (strPLAN_STATUS == "1") ▸ if (strPLAN_TYPE == "MA" \|\| strPLAN_TYPE == "FN") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CONFIRM)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-2f01def6 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:702 | for (i >= 0) ▸ if (strCONFIRM_AUTH == "Y") ▸ if (strPLAN_STATUS == "1") ▸ else of (strPLAN_TYPE == "MA" \|\| strPLAN_TYPE == "FN") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CONFIRM)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-6aa5d64b | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:707 | for (i >= 0) ▸ if (strCONFIRM_AUTH == "Y") ▸ else of (strPLAN_STATUS == "1") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CONFIRM)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-3fe37830 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:712 | for (i >= 0) ▸ else of (strCONFIRM_AUTH == "Y") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-7fb2abcd | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:713 | for (i >= 0) ▸ else of (strCONFIRM_AUTH == "Y") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CANCEL)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-7f4ba870 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:714 | for (i >= 0) ▸ else of (strCONFIRM_AUTH == "Y") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CONFIRM)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-408f9788 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:740 | for (i < siPlan.ActiveSheet.RowCount) ▸ if (strCONFIRM_AUTH == "Y") ▸ if (!isRunOneSet) ▸ if (strPLAN_STATUS == "-1" \|\| strPLAN_STATUS == … | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | false | 그리드 속성/값 설정 |  |  |  |
| AC-8096e29d | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:745 | for (i < siPlan.ActiveSheet.RowCount) ▸ if (strCONFIRM_AUTH == "Y") ▸ if (!isRunOneSet) ▸ else of (strPLAN_STATUS == "-1" \|\| strPLAN_STATU… | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-29478dc0 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:750 | for (i < siPlan.ActiveSheet.RowCount) ▸ if (strCONFIRM_AUTH == "Y") ▸ else of (!isRunOneSet) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-fa512896 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:755 | for (i < siPlan.ActiveSheet.RowCount) ▸ else of (strCONFIRM_AUTH == "Y") | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-995571b2 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:764 | if (isPlaying) ▸ for (i < siPlan.ActiveSheet.RowCount) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CONFIRM)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-80948b09 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:765 | if (isPlaying) ▸ for (i < siPlan.ActiveSheet.RowCount) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-da968894 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:766 | if (isPlaying) ▸ for (i < siPlan.ActiveSheet.RowCount) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CANCEL)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-01fed9ce | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:784 | if (monday.ToString("yyyyMMdd") != cboPlanWeek.Text.Substring(0, 8)) ▸ for (i < siPlan.ActiveSheet.RowCount) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CONFIRM)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-c063b6d8 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:785 | if (monday.ToString("yyyyMMdd") != cboPlanWeek.Text.Substring(0, 8)) ▸ for (i < siPlan.ActiveSheet.RowCount) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.RUN)].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-d558f8c4 | spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColu… 외 2 | SCP0015_PlanManagement.cs:786 | if (monday.ToString("yyyyMMdd") != cboPlanWeek.Text.Substring(0, 8)) ▸ for (i < siPlan.ActiveSheet.RowCount) | GRID_SET | siPlan.ActiveSheet.Cells[i, siPlan.GetColumnIndex(DefColumns.CANCEL)].Locked | true | 그리드 속성/값 설정 |  |  |  |

## SCP0015_PlanManagement.SpdPlan_CellClick

진입점: spdPlan.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6171ccd3 | spdPlan.CellClick | SCP0015_PlanManagement.cs:1636 |  | FLAG | this.nSelRowSpdPlan | nRow | 화면 필드/플래그 변경 |  |  |  |
| AC-aee2468d | spdPlan.CellClick | SCP0015_PlanManagement.cs:1637 |  | FLAG | this.nSelColSpdPlan | nCol | 화면 필드/플래그 변경 |  |  |  |
| AC-63af4349 | spdPlan.CellClick | SCP0015_PlanManagement.cs:1640 | if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00183", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-792fefdb | spdPlan.CellClick | SCP0015_PlanManagement.cs:1649 | if (nCol == siPlan.GetColumnIndex(DefColumns.CANCEL) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.CAN…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00195", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89632425 | spdPlan.CellClick | SCP0015_PlanManagement.cs:1658 | if (nCol == siPlan.GetColumnIndex(DefColumns.CONFIRM) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.CO…) | MESSAGE | MessageHelper.GMessageBox | ("MSG00184", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0015_PlanManagement.SpdPlan_CellDoubleClick

진입점: spdPlan.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4bc05cd | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1669 | if (siPlan.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff2d9a67 | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1672 |  | FLAG | this.nSelRowSpdPlan | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-1a216624 | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1673 |  | FLAG | this.nSelColSpdPlan | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-5724098f | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1685 | switch (strPLAN_TYPE) case "TE": | DATA_OP | dtRevisionTE.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-fcb4324f | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1688 | switch (strPLAN_TYPE) case "TM": | DATA_OP | dtRevisionTM.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d46e759 | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1691 | switch (strPLAN_TYPE) case "PR": | DATA_OP | dtRevisionPR.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c25a0c3b | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1694 | switch (strPLAN_TYPE) case "MA": | DATA_OP | dtRevisionMA.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-8753aa1c | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1697 | switch (strPLAN_TYPE) case "SE": | DATA_OP | dtRevisionSE.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-d083e5cb | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1700 | switch (strPLAN_TYPE) case "FN": | DATA_OP | dtRevisionFN.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e1aebb5f | spdPlan.CellDoubleClick | SCP0015_PlanManagement.cs:1703 | switch (strPLAN_TYPE) case "SU": | DATA_OP | dtRevisionSU.Select | ("CODE = '" + strREVISION_NO + "'") | 데이터 객체 조작/조회 |  |  |  |

## SCP0015_PlanManagement.SpdPlan_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9786d3c1 | dsdm.Changed | SCP0015_PlanManagement.cs:1724 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6418da93 | dsdm.Changed | SCP0015_PlanManagement.cs:1725 | if (e.Column != siPlan.GetColumnIndex(DefColumns.REVISION_NO)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-63e0daab | dsdm.Changed | SCP0015_PlanManagement.cs:1737 | try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04446ec5 | dsdm.Changed | SCP0015_PlanManagement.cs:1743 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: | CALL_EXT | siPlan.DisplayedSheet.GetViewRowFromModelRow | (e.Row) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1d916545 | dsdm.Changed | SCP0015_PlanManagement.cs:1758 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "TE": | DATA_OP | dtRevisionTE.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-48a397c0 | dsdm.Changed | SCP0015_PlanManagement.cs:1761 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "TM": | DATA_OP | dtRevisionTM.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-68b33119 | dsdm.Changed | SCP0015_PlanManagement.cs:1764 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "PR": | DATA_OP | dtRevisionPR.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-e2cd2e7a | dsdm.Changed | SCP0015_PlanManagement.cs:1767 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "MA": | DATA_OP | dtRevisionMA.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-9513ec7a | dsdm.Changed | SCP0015_PlanManagement.cs:1770 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "SE": | DATA_OP | dtRevisionSE.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-06bd4616 | dsdm.Changed | SCP0015_PlanManagement.cs:1773 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "FN": | DATA_OP | dtRevisionFN.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-33945c5c | dsdm.Changed | SCP0015_PlanManagement.cs:1776 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ switch (strPlanType) case "SU": | DATA_OP | dtRevisionSU.Select | ("CODE = '" + strRevisionNO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-226f3b86 | dsdm.Changed | SCP0015_PlanManagement.cs:1787 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: | GRID_SET | siPlan.SetText | (changeRowIdx, siPlan.GetColumnIndex(DefColumns.PLAN_STATUS_NAME), strSatus) | 그리드 값 설정 |  |  |  |
| AC-603bff39 | dsdm.Changed | SCP0015_PlanManagement.cs:1788 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: | GRID_SET | siPlan.SetText | (changeRowIdx, siPlan.GetColumnIndex(DefColumns.PLAN_STATUS), strSatusCode) | 그리드 값 설정 |  |  |  |
| AC-43130d43 | dsdm.Changed | SCP0015_PlanManagement.cs:1789 | try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: | GRID_SET | siPlan.SetText | (changeRowIdx, siPlan.GetColumnIndex(DefColumns.MODELING_ID), strModelingId) | 그리드 값 설정 |  |  |  |
| AC-09be8add | dsdm.Changed | SCP0015_PlanManagement.cs:1801 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-2af67ee2 | dsdm.Changed | SCP0015_PlanManagement.cs:1805 | finally | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0015_PlanManagement.timer_Start

진입점: spdPlan.CellDoubleClick [try ▸ else of (strPLAN_STATUS == "-1" \|\| strPLAN_STATUS == "1" \|\| strPLAN_STATUS == "") ▸ if (!isStatusCheck)] / spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try ▸ else of (strPLAN_STATUS == "-1" \|\| strPLAN_STATUS == "1" \|\| strPLAN_STATUS == "") ▸ if (!isStatusCheck)] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff6c3a3c | spdPlan.CellDoubleClick [try ▸ else of (strPLAN_STATUS == "-… 외 4 | SCP0015_PlanManagement.cs:1869 | if (siEngin.ActiveSheet.Rows.Count > 0) | GRID_STYLE | siEngin.SetBGColor | (0, nCol1, siEngin.ActiveSheet.Rows.Count - 1, nCol4, ControlColor.DefaultBackColor) | 그리드 표시 설정 |  |  |  |
| AC-f055c879 | spdPlan.CellDoubleClick [try ▸ else of (strPLAN_STATUS == "-… 외 4 | SCP0015_PlanManagement.cs:1872 |  | CALL_EXT | timerStatus.Start | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0015_PlanManagement.timer_Stop

진입점: spdPlan.CellDoubleClick [try ▸ if (!isStatusCheck)] / spdPlan.CellClick [if (nCol == siPlan.GetColumnIndex(DefColumns.RUN) && !siPlan.ActiveSheet.Cells[nRow, siPlan.GetColumnIndex(DefColumns.RUN)].…) ▸ if (MessageHelper.GMessageBox("MSG00183", new object[] { "" }) == DialogResult.Yes) ▸ try] / dsdm.Changed [try ▸ switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ try ▸ if (!isStatusCheck)] / timerStatus.Tick [try ▸ try ▸ if (!isStatusCheck)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b2e4a3b | spdPlan.CellDoubleClick [try ▸ if (!isStatusCheck)] 외 4 | SCP0015_PlanManagement.cs:1879 |  | CALL_EXT | timerStatus.Stop | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d74e87ea | spdPlan.CellDoubleClick [try ▸ if (!isStatusCheck)] 외 4 | SCP0015_PlanManagement.cs:1886 | if (siEngin.ActiveSheet.Rows.Count > 0) | GRID_STYLE | siEngin.SetBGColor | (0, nCol1, siEngin.ActiveSheet.Rows.Count-1, nCol4, ControlColor.DefaultBackColor) | 그리드 표시 설정 |  |  |  |

