# AS-IS 액션 대조표 — SCP0077

> 원천: `Doc/asisfacts/screens/SCP0077/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 315행 · 메서드 24 · 종류 GRID_INIT 169 · GRID_SET 37 · DATA_OP 26 · ENDPOINT 13 · RETURN 11 · FLAG 9 · UI_MISC 8 · UI_PROP 7 · POPUP 6 · MESSAGE 5 · GRID_LOCK 5 · VALIDATE 4 · LIST_REBIND 4 · STATE 2 · GRID_BIND 2 · CALL_EXT 2 · VALUE_SET 2 · COMBO_DATA 2 · GRID_CLEAR 1 · ⚠ 의미 확인 필요 2


## SCP0077_Shipping_Result_Check.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdd7a26e | this.btnColumn.Click | SCP0077_Shipping_Result_Check.cs:1185 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0077", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-725aecb8 | this.btnColumn.Click | SCP0077_Shipping_Result_Check.cs:1186 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9290909e | this.btnColumn.Click | SCP0077_Shipping_Result_Check.cs:1187 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0077_Shipping_Result_Check.CboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c48af86f | this.cboBucketType.SelectedIndexChanged | SCP0077_Shipping_Result_Check.cs:332 | if (cboBucketType.ControlValues == BucketType.Daily) | STATE | cboPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a0b46a61 | this.cboBucketType.SelectedIndexChanged | SCP0077_Shipping_Result_Check.cs:337 | else of (cboBucketType.ControlValues == BucketType.Daily) | STATE | cboPlanDate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0077_Shipping_Result_Check.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a47d5f4 | cboPlanDate.SelectedIndexChanged | SCP0077_Shipping_Result_Check.cs:1172 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0077_Shipping_Result_Check.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-481437ff | this.Load | SCP0077_Shipping_Result_Check.cs:234 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-10e796dd | this.Load | SCP0077_Shipping_Result_Check.cs:235 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff1ea34a | this.Load | SCP0077_Shipping_Result_Check.cs:237 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0077_Shipping_Result_Check.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8702a6e6 | Dispose | SCP0077_Shipping_Result_Check.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0077_Shipping_Result_Check.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78d6d154 | EditButton | SCP0077_Shipping_Result_Check.cs:364 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if ("N".Equals(this._IsEditable)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00364", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-988b6b30 | EditButton | SCP0077_Shipping_Result_Check.cs:365 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if ("N".Equals(this._IsEditable)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fa350331 | EditButton | SCP0077_Shipping_Result_Check.cs:368 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e90186d | EditButton | SCP0077_Shipping_Result_Check.cs:369 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-580ea91e | EditButton | SCP0077_Shipping_Result_Check.cs:370 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColHeader.REASON_DESCRIPTION) - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eaf86125 | EditButton | SCP0077_Shipping_Result_Check.cs:371 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColHeader.REASON_DESCRIPTION) + 1, siMain.ActiveSheet.ColumnCoun… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0077_Shipping_Result_Check.Find_Data

진입점: FindButton [else of (cboBucketType.ControlValues == BucketType.Daily)] / SaveButton [if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97049107 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:387 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-33636fe9 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:390 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8df4e2ec | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:390 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8fad3a9 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:394 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-52ec3954 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:410 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4a898355 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:411 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69325b51 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:415 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0077_GET_SHIPPING_RESULT_CHECK") ⇒ SCP.SCP0077_GET_SHIPPING_RESULT_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-7745d852 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:416 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-44cd3e10 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:417 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6bf3ed3a | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:418 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8630e3bc | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:419 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-0d050426 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:420 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ea7646e6 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:421 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ac78c8b8 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:423 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6c8f2394 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:425 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ded68146 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:434 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4adebf0d | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:436 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | this._IsEditable | ds.Tables[1].Rows[0]["IS_EDITABLE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-666c9689 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:439 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-75128a56 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:442 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7744c2f8 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:449 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-472a8334 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:458 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-64ee6be1 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:459 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1bba57dc | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:463 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0077_Shipping_Result_Check.Find_Data_Daily

진입점: FindButton [if (cboBucketType.ControlValues == BucketType.Daily)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b9da705 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:469 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-50ec9955 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:472 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2b355209 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:472 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e763db3c | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:476 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dae02a6c | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:490 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-bb42998d | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:491 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f7294a8 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:495 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY") ⇒ SCP.SCP0077_GET_SHIPPING_RESULT_CHECK_DAILY | 엔드포인트 요청 생성 |  |  |  |
| AC-4b65252b | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:496 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-a953a2c1 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:497 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-16ce0ff0 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:498 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-90db56af | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:499 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-8ce13b4d | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:500 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-30a9d267 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:501 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-cc017882 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:503 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ca580a5b | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:505 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eec8c3ec | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:514 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4f6eafa1 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:517 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5898079b | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:520 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1823679e | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:521 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-186f2101 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:530 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-36dd1998 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:531 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12479596 | FindButton [if (cboBucketType.ControlValues == BucketType.Da… | SCP0077_Shipping_Result_Check.cs:535 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0077_Shipping_Result_Check.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc83026a | this.Load | SCP0077_Shipping_Result_Check.cs:181 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0077_Shipping_Result_Check.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-518cbbe2 | this.Load | SCP0077_Shipping_Result_Check.cs:1162 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-da26957c | this.Load | SCP0077_Shipping_Result_Check.cs:1163 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e8e6f5b3 | this.Load | SCP0077_Shipping_Result_Check.cs:1165 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0077_Shipping_Result_Check.GetSpdTitle

진입점: this.Load / cboPlanDate.SelectedIndexChanged / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (cboBucketType.ControlValues == BucketType.Daily) ▸ try] / SaveButton [if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a172335 | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:545 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0077_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-3ab2707d | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:547 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-ced8da90 | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:549 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6d922ea0 | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:549 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0077_Shipping_Result_Check.HeaderSpan_Daily

진입점: this.Load [if (cboBucketType.ControlValues == BucketType.Daily)] / cboPlanDate.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / FindButton [if (cboBucketType.ControlValues == BucketType.Daily) ▸ try ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / SaveButton [if (iCount > 0) ▸ if (tran.Su…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ffce2361 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:919 | for (iCol < ColLoopCnt_0) | CALL_EXT | siMain.Sheet(0).AddColumnHeaderSpanCell | (0, iStartCol, 1, iColSpanCnt_0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee57fc07 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:926 | for (iCol < ColLoopCnt_1) | CALL_EXT | siMain.Sheet(0).AddColumnHeaderSpanCell | (1, iStartCol, 1, iColSpanCnt_1) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0077_Shipping_Result_Check.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90006cc1 | this.Load | SCP0077_Shipping_Result_Check.cs:202 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d6c555d9 | this.Load | SCP0077_Shipping_Result_Check.cs:205 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-fa9d2a09 | this.Load | SCP0077_Shipping_Result_Check.cs:207 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d043a4eb | this.Load | SCP0077_Shipping_Result_Check.cs:210 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-c75b5c0a | this.Load | SCP0077_Shipping_Result_Check.cs:211 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-298f7f1f | this.Load | SCP0077_Shipping_Result_Check.cs:212 |  | DATA_OP | dtBucketType.Rows.Remove | (dtBucketType.Rows[2]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2384aa9c | this.Load | SCP0077_Shipping_Result_Check.cs:213 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-a8e800bb | this.Load | SCP0077_Shipping_Result_Check.cs:216 |  | VALUE_SET | rdUOM.Checked | true | 컨트롤 값 설정 |  |  |  |

## SCP0077_Shipping_Result_Check.InitSpread

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2e31bb8 | this.Load 외 2 | SCP0077_Shipping_Result_Check.cs:246 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4232c26 | this.Load 외 2 | SCP0077_Shipping_Result_Check.cs:247 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0077_Shipping_Result_Check.InitSpreadDateColumn

진입점: this.Load [else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Weekly)] / cboPlanDate.SelectedIndexChanged [else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Weekly)] / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Weekly)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (cboBucketType.ControlValues == Buc…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40f878bb | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:571 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_PLAN_SCP, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1efc266 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:572 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_PLAN_SCP), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0a8e4f4 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:574 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-06fd0f1e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:575 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-7ecc7c07 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:576 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SCP) | 그리드 재구성/초기화 |  |  |  |
| AC-5cae0ab0 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:580 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_PLAN_SSP, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9ee1d0f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:581 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_PLAN_SSP), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b294d4fc | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:583 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-d9b53a79 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:584 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-eb37d199 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:585 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SSP) | 그리드 재구성/초기화 |  |  |  |
| AC-b39ebdcc | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:589 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_RESULT, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72582e90 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:590 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_RESULT), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0af92456 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:592 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-60f3c15b | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:593 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.RESULT) | 그리드 재구성/초기화 |  |  |  |
| AC-f5af8ff6 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:594 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.OBSERVANCE) | 그리드 재구성/초기화 |  |  |  |
| AC-9089b764 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:598 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_RESULT_TOT, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d0ff5b25 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:599 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_RESULT_TOT), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-84cbe69d | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:601 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-d5f5e1de | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:602 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.RESULT) | 그리드 재구성/초기화 |  |  |  |
| AC-1a62069b | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:603 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.TOTAL) | 그리드 재구성/초기화 |  |  |  |
| AC-3c2271dd | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:608 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_PLAN_SCP_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40630d75 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:609 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_PLAN_SCP_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3f1d8dda | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:611 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-2a366432 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:612 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-7b399ce0 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:613 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SCP) | 그리드 재구성/초기화 |  |  |  |
| AC-17429e33 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:617 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_PLAN_SSP_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d7b67e3 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:618 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_PLAN_SSP_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-94c1d15c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:620 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-19e926ef | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:621 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-e8b0111c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:622 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SSP) | 그리드 재구성/초기화 |  |  |  |
| AC-438f4863 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:626 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_RESULT_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2ccff5c7 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:627 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_RESULT_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-34ad879f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:629 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-634f79c8 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:630 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.OBSERVANCE) | 그리드 재구성/초기화 |  |  |  |
| AC-5be1fcca | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:631 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.OBSERVANCE) | 그리드 재구성/초기화 |  |  |  |
| AC-6a1a2676 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:635 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.SHIP_RESULT_TOT_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e15556fe | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:636 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.SHIP_RESULT_TOT_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2823fad | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:638 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-effea982 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:639 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.TOTAL) | 그리드 재구성/초기화 |  |  |  |
| AC-5e2251ec | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:640 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.TOTAL) | 그리드 재구성/초기화 |  |  |  |
| AC-10af1461 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:644 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.CO_RATE, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fac12d04 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:645 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.CO_RATE), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8d529a70 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:647 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-cf65651a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:648 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-053dbc58 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:649 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-c3ae07f4 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:653 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.AC_RATE, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f22358d | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:654 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.AC_RATE), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7ceb936f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:656 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-79d80810 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:657 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-0bf173a6 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:658 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-2be0a83a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:662 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.CO_RATE_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45a7a99f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:663 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.CO_RATE_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-635e72df | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:665 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-4757f61d | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:666 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-29bfec25 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:667 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-c0d4a904 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:671 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, DefColHeader.AC_RATE_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9a2073b | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:672 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeader.AC_RATE_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e76ac7c8 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:674 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-fdced02e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:675 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-6243d928 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:676 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-16c4cf63 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:680 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddTextColumn | (sWeekName, DefColHeader.REASON_CODE, FPMerge.None, 100, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-924baa41 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:681 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-f1319d00 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:682 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.REASON_CODE) | 그리드 재구성/초기화 |  |  |  |
| AC-da14b1d6 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:683 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.REASON_CODE) | 그리드 재구성/초기화 |  |  |  |
| AC-80f7c7b2 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:687 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddTextColumn | (sWeekName, DefColHeader.REASON_DESCRIPTION, FPMerge.None, 140, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9db061e3 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:688 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-876f5263 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:689 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.REASON_DESCRIPTION) | 그리드 재구성/초기화 |  |  |  |
| AC-d62fa9b8 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:690 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.REASON_DESCRIPTION) | 그리드 재구성/초기화 |  |  |  |
| AC-e50ddfde | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:695 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iStartCol, 1, 14, 30, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8ebfd000 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:696 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol, 1, 2, 30, DefColName.PLAN, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-063f63e4 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:697 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol + 2, 1, 2, 30, DefColName.RESULT, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e66cf546 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:699 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol + 4, 1, 2, 30, DefColName.PLAN, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0080cdba | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:700 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol + 6, 1, 2, 30, DefColName.RESULT, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df900bca | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:702 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol + 8, 1, 2, 30, DefColName.SSP_RATE, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4ec7028 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:703 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol + 10, 1, 2, 30, DefColName.SSP_RATE, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-03269e90 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:705 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iStartCol + 12, 1, 2, 30, DefColName.REASON, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7acb4aea | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:744 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_CO_Rate, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4deeda1c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:745 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_CO_Rate), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f792ccfb | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:747 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-2721bf4c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:748 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-40fab125 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:749 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-bd62e42a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:753 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_AC_Rate, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a21dab3 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:754 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_AC_Rate), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d3715f90 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:756 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-9e11e5f2 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:757 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-bbaea5d7 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:758 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-9f44171f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:761 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_CO_Rate_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-645ec5eb | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:762 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_CO_Rate_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-940f05d3 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:764 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-5e848c9b | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:765 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-b373523c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:766 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-d159992e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:770 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_AC_Rate_CELL, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c65e3ccd | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:771 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_AC_Rate_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-82b20f18 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:773 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-f994724b | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:774 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-2d327d8f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:775 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-a5e4ca3e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:780 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurCol - 4, 1, 4, 30, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-465729f1 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:781 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 4, 2, 1, 30, DefColName.ACCURACY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e90e047a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:782 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 3, 2, 1, 30, DefColName.ACHIEVEMENT, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59965771 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:783 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 2, 2, 1, 30, DefColName.ACCURACY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b62895a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 5 | SCP0077_Shipping_Result_Check.cs:784 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate == sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 1, 2, 1, 30, DefColName.ACHIEVEMENT, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0077_Shipping_Result_Check.InitSpreadDateColumn_Daily

진입점: this.Load [if (cboBucketType.ControlValues == BucketType.Daily)] / cboPlanDate.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / FindButton [if (cboBucketType.ControlValues == BucketType.Daily) ▸ try ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / SaveButton [if (iCount > 0) ▸ if (tran.Su…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cb6f7e8 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:807 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_PLAN_SCP_D + iCnt.ToString(), FPMerge.None, colWidth, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c735c4bc | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:808 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_PLAN_SCP_D + iCnt.ToString()), -99… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-140b31d9 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:809 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-adcbfcc9 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:810 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-b5c1d306 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:811 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SCP) | 그리드 재구성/초기화 |  |  |  |
| AC-1b6c5db2 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:814 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_PLAN_SSP_D + iCnt.ToString(), FPMerge.None, colWidth, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0671344 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:815 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_PLAN_SSP_D + iCnt.ToString()), -99… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf86ddf7 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:816 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-e8a8f069 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:817 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-13f48e53 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:818 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SSP) | 그리드 재구성/초기화 |  |  |  |
| AC-2d868620 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:822 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_RESULT_D + iCnt.ToString(), FPMerge.None, colWidth, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2f79900 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:823 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_RESULT_D + iCnt.ToString()), -9999… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ed39a44f | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:824 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-4133889d | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:825 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.RESULT) | 그리드 재구성/초기화 |  |  |  |
| AC-c3df55d9 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:826 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.OBSERVANCE) | 그리드 재구성/초기화 |  |  |  |
| AC-593c3207 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:829 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_RESULT_TOT_D + iCnt.ToString(), FPMerge.None, colWidth, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-324a79fd | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:830 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_RESULT_TOT_D + iCnt.ToString()), -… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-79825b7b | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:831 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-6deadc04 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:832 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.RESULT) | 그리드 재구성/초기화 |  |  |  |
| AC-6ac789e6 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:833 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.TOTAL) | 그리드 재구성/초기화 |  |  |  |
| AC-6768baf3 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:836 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_CO_RATE_D + iCnt.ToString(), FPMerge.None, colWidth, tru… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41618308 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:837 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_CO_RATE_D + iCnt.ToString()), -999… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c0fb76c3 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:838 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-90826fe4 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:839 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.SSP_RATE) | 그리드 재구성/초기화 |  |  |  |
| AC-450ab83e | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:840 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-22855e4b | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:843 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_AC_RATE_D + iCnt.ToString(), FPMerge.None, colWidth, tru… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7989fe6 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:844 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_AC_RATE_D + iCnt.ToString()), -999… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e9ef889 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:845 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-7920370d | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:846 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.SSP_RATE) | 그리드 재구성/초기화 |  |  |  |
| AC-22d52f61 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:847 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |
| AC-95da1eac | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:858 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_PLAN_SCP_CELL_D + iCnt.ToString(), FPMerge.None, colWidt… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e18cee8a | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:859 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_PLAN_SCP_CELL_D + iCnt.ToString())… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5900a643 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:860 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-458ba336 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:861 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-1956bb0d | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:862 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SCP) | 그리드 재구성/초기화 |  |  |  |
| AC-c503ee57 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:865 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_PLAN_SSP_CELL_D + iCnt.ToString(), FPMerge.None, colWidt… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9d52369 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:866 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_PLAN_SSP_CELL_D + iCnt.ToString())… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-93509657 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:867 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-b6f2c03a | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:868 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.PLAN) | 그리드 재구성/초기화 |  |  |  |
| AC-d98e9438 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:869 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.SSP) | 그리드 재구성/초기화 |  |  |  |
| AC-52d9b380 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:873 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_RESULT_CELL_D + iCnt.ToString(), FPMerge.None, colWidth,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b4944af | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:874 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_RESULT_CELL_D + iCnt.ToString()), … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1240d4b8 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:875 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-3524bfa4 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:876 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.RESULT) | 그리드 재구성/초기화 |  |  |  |
| AC-7ed3af9d | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:877 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.OBSERVANCE) | 그리드 재구성/초기화 |  |  |  |
| AC-f416ced6 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:880 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_RESULT_TOT_CELL_D + iCnt.ToString(), FPMerge.None, colWi… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3df5a05 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:881 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_RESULT_TOT_CELL_D + iCnt.ToString(… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e27696d | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:882 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-8ee35e71 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:883 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.RESULT) | 그리드 재구성/초기화 |  |  |  |
| AC-58ec1570 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:884 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.TOTAL) | 그리드 재구성/초기화 |  |  |  |
| AC-726b4496 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:887 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_CO_RATE_CELL_D + iCnt.ToString(), FPMerge.None, colWidth… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33b9940c | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:888 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_CO_RATE_CELL_D + iCnt.ToString()),… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-323f4c4f | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:889 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-365a4728 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:890 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.SSP_RATE) | 그리드 재구성/초기화 |  |  |  |
| AC-0b2f08f1 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:891 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACCURACY) | 그리드 재구성/초기화 |  |  |  |
| AC-cc1ad1bb | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:894 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sDayName, DefColHeaderDaily.SHIP_AC_RATE_CELL_D + iCnt.ToString(), FPMerge.None, colWidth… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88ca0ab7 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:895 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(DefColHeaderDaily.SHIP_AC_RATE_CELL_D + iCnt.ToString()),… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6d936726 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:896 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sDayName) | 그리드 재구성/초기화 |  |  |  |
| AC-e7953624 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:897 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, DefColName.SSP_RATE) | 그리드 재구성/초기화 |  |  |  |
| AC-87a7b9cd | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 5 | SCP0077_Shipping_Result_Check.cs:898 | foreach (DataRow dr in dsSpdTitle.Tables[1].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, DefColName.ACHIEVEMENT) | 그리드 재구성/초기화 |  |  |  |

## SCP0077_Shipping_Result_Check.Re_Design

진입점: FindButton [else of (cboBucketType.ControlValues == BucketType.Daily) ▸ try] / SaveButton [if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0262889 | FindButton [else of (cboBucketType.ControlValues == BucketTy… 외 1 | SCP0077_Shipping_Result_Check.cs:1152 | for (i < iRowcnt) ▸ if (i % 2 == 1) | GRID_SET | spdMain.ActiveSheet.Cells[i, iStartCol, i, iEndCol].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |

## SCP0077_Shipping_Result_Check.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b16eee3 | SaveButton | SCP0077_Shipping_Result_Check.cs:377 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0077_Shipping_Result_Check.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d83f6f26 | SaveButton | SCP0077_Shipping_Result_Check.cs:1038 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54702fb6 | SaveButton | SCP0077_Shipping_Result_Check.cs:1040 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0aec0a55 | SaveButton | SCP0077_Shipping_Result_Check.cs:1042 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-77d81593 | SaveButton | SCP0077_Shipping_Result_Check.cs:1044 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba4f8aab | SaveButton | SCP0077_Shipping_Result_Check.cs:1092 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0077_SAVE_SHIPPING_RESULT_CHECK") ⇒ SCP.SCP0077_SAVE_SHIPPING_RESULT_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-3803679b | SaveButton | SCP0077_Shipping_Result_Check.cs:1095 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ee4e57cf | SaveButton | SCP0077_Shipping_Result_Check.cs:1098 | if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0d11754b | SaveButton | SCP0077_Shipping_Result_Check.cs:1100 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e8d68f48 | SaveButton | SCP0077_Shipping_Result_Check.cs:1101 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c91e447a | SaveButton | SCP0077_Shipping_Result_Check.cs:1102 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_week"] | p_plan_week | 행/컬럼 값 대입 |  |  |  |
| AC-738d68a2 | SaveButton | SCP0077_Shipping_Result_Check.cs:1103 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-f2975461 | SaveButton | SCP0077_Shipping_Result_Check.cs:1104 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5bf6337 | SaveButton | SCP0077_Shipping_Result_Check.cs:1105 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-e609d4f8 | SaveButton | SCP0077_Shipping_Result_Check.cs:1106 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-fc688f93 | SaveButton | SCP0077_Shipping_Result_Check.cs:1107 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_model_type_gr"] | p_model_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-1ad9738c | SaveButton | SCP0077_Shipping_Result_Check.cs:1108 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_to_scm_site_id"] | p_to_scm_site_id_org | 행/컬럼 값 대입 |  |  |  |
| AC-a5b3f8f6 | SaveButton | SCP0077_Shipping_Result_Check.cs:1109 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_reason_code"] | p_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-5972dab0 | SaveButton | SCP0077_Shipping_Result_Check.cs:1110 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_reason_description"] | p_reason_description | 행/컬럼 값 대입 |  |  |  |
| AC-b3c946cb | SaveButton | SCP0077_Shipping_Result_Check.cs:1111 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-5f955f11 | SaveButton | SCP0077_Shipping_Result_Check.cs:1113 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6081a3db | SaveButton | SCP0077_Shipping_Result_Check.cs:1113 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-2bc4cad1 | SaveButton | SCP0077_Shipping_Result_Check.cs:1122 | if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4b2bb65 | SaveButton | SCP0077_Shipping_Result_Check.cs:1131 | if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0077_Shipping_Result_Check.Set_Calculator

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e3e2c3f | (진입점 미연결) | SCP0077_Shipping_Result_Check.cs:309 | for (iRow <= siMain.ActiveSheet.RowCount - 1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iColIdx_CO_Rate].Formula | "(" + cell_SHIP_RESULT + " / IF(" + cell_SHIP_PLAN_SCP + "= 0,1," + cell_SHIP_PLAN_SCP + "… | 그리드 속성/값 설정 |  |  |  |
| AC-699f2bbe | (진입점 미연결) | SCP0077_Shipping_Result_Check.cs:310 | for (iRow <= siMain.ActiveSheet.RowCount - 1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iColIdx_AC_Rate].Formula | "(" + cell_SHIP_RESULT_TOT + " / IF(" + cell_SHIP_PLAN_SCP + "= 0,1," + cell_SHIP_PLAN_SCP… | 그리드 속성/값 설정 |  |  |  |
| AC-baf1eee8 | (진입점 미연결) | SCP0077_Shipping_Result_Check.cs:311 | for (iRow <= siMain.ActiveSheet.RowCount - 1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iColIdx_CO_RATE_CELL].Formula | "(" + cell_SHIP_RESULT_CELL + " / IF(" + cell_SHIP_PLAN_SCP_CELL + "= 0,1," + cell_SHIP_PL… | 그리드 속성/값 설정 |  |  |  |
| AC-87d13ddf | (진입점 미연결) | SCP0077_Shipping_Result_Check.cs:312 | for (iRow <= siMain.ActiveSheet.RowCount - 1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iColIdx_AC_RATE_CELL].Formula | "(" + cell_SHIP_RESULT_TOT_CELL + " / IF(" + cell_SHIP_PLAN_SCP_CELL + "= 0,1," + cell_SHI… | 그리드 속성/값 설정 |  |  |  |

## SCP0077_Shipping_Result_Check.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e3ecd6c | this.Load 외 1 | SCP0077_Shipping_Result_Check.cs:225 |  | FLAG | dtPlanDate | Data_SCP.Common(Data_SCP.Type.PlanDate_REPORT, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ce1ed60 | this.Load 외 1 | SCP0077_Shipping_Result_Check.cs:225 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanDate_REPORT, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9f435b7d | this.Load 외 1 | SCP0077_Shipping_Result_Check.cs:226 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5bce23a2 | this.Load 외 1 | SCP0077_Shipping_Result_Check.cs:228 |  | FLAG | dtPlantReport | Data_SCP.Common(Data_SCP.Type.Plant_REPORT, false, division) | 화면 필드/플래그 변경 |  |  |  |
| AC-fc1a201b | this.Load 외 1 | SCP0077_Shipping_Result_Check.cs:228 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.Plant_REPORT, false, division) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-186b4d5d | this.Load 외 1 | SCP0077_Shipping_Result_Check.cs:229 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantReport, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0077_Shipping_Result_Check.SetColumnVisible

진입점: this.Load [else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Weekly)] / cboPlanDate.SelectedIndexChanged [else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Weekly)] / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Weekly)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (cboBucketType.ControlValues == Buc…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96e39b9f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:968 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_PLAN_SCP].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a5b33f6e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:969 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_PLAN_SSP].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f7845eb8 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:970 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_RESULT].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0ed604e2 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:971 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_RESULT_TOT].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-516b9263 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:972 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_CO_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-01aa84cb | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:973 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_AC_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-31fe1c0f | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:974 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF4_CO_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-afc83088 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:975 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF4_AC_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c1eafae0 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:976 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF3_CO_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0d852941 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:977 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF3_AC_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-19a48ec1 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:978 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF2_CO_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9b66231c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:979 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF2_AC_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9baedbfe | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:980 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF1_CO_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-65714117 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:981 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF1_AC_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8b9cce4a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:984 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_PLAN_SCP_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-ca84917e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:985 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_PLAN_SSP_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-1b2fb1ba | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:986 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_RESULT_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2e9055b5 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:987 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_SHIP_RESULT_TOT_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2605a06e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:988 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_CO_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-9249a851 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:989 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_AC_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-38b8d7fd | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:991 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF4_CO_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-38d8e6ef | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:992 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF4_AC_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-45c610a7 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:993 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF3_CO_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a3ba6a63 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:994 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF3_AC_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-de4ff09e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:995 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF2_CO_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-cb8a1b37 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:996 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF2_AC_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-b04c01e4 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:997 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF1_CO_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-11fa0141 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 7 | SCP0077_Shipping_Result_Check.cs:998 |  | GRID_SET | siMain.ActiveSheet.Columns[idxCol_BEF1_AC_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0077_Shipping_Result_Check.SetColumnVisible_Daily

진입점: this.Load [if (cboBucketType.ControlValues == BucketType.Daily)] / cboPlanDate.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (cboBucketType.ControlValues == BucketType.Daily)] / this.rdUOM.CheckedChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.rdCell.CheckedChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / Fin…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df240d80 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 7 | SCP0077_Shipping_Result_Check.cs:1013 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdCell.Checked) | DATA_OP | colName.Contains | ("_CELL_") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cd862e3 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 7 | SCP0077_Shipping_Result_Check.cs:1015 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdCell.Checked) ▸ if (colName.Contains("_CELL_")) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b28b1091 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 7 | SCP0077_Shipping_Result_Check.cs:1019 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (rdCell.Checked) ▸ else of (colName.Contains("_CELL_")) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ab33b6bc | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 7 | SCP0077_Shipping_Result_Check.cs:1024 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdCell.Checked) ▸ if (rdUOM.Checked) | DATA_OP | colName.Contains | ("_CELL_") | 데이터 객체 조작/조회 |  |  |  |
| AC-0fe31c32 | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 7 | SCP0077_Shipping_Result_Check.cs:1026 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdCell.Checked) ▸ if (rdUOM.Checked) ▸ if (colName.Contains("_CELL_")) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5b562d1a | this.Load [if (cboBucketType.ControlValues == BucketType.Dai… 외 7 | SCP0077_Shipping_Result_Check.cs:1030 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (rdCell.Checked) ▸ if (rdUOM.Checked) ▸ else of (colName.Contains("_CELL_")) | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0077_Shipping_Result_Check.SetSpreadInit

진입점: this.Load / cboPlanDate.SelectedIndexChanged / this.cboBucketType.SelectedIndexChanged [if (cboBucketType.ControlValues == BucketType.Daily)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (cboBucketType.ControlValues == BucketType.Daily) ▸ try] / SaveButton [if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff145a7d | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:252 |  | GRID_INIT | siMain.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-f4796fcf | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:255 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-1efcd64d | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:257 |  | FLAG | nIdxDataMain | spdInfo.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-0eb36d03 | this.Load 외 5 | SCP0077_Shipping_Result_Check.cs:258 |  | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |

