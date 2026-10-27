# AS-IS 액션 대조표 — SCP0083

> 원천: `Doc/asisfacts/screens/SCP0083/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 966행 · 메서드 73 · 종류 DATA_OP 280 · GRID_INIT 232 · CALL_EXT 84 · GRID_SET 57 · UI_PROP 55 · RETURN 52 · UI_MISC 38 · MESSAGE 35 · ENDPOINT 30 · FLAG 28 · POPUP 22 · GRID_LOCK 13 · STATE 8 · GRID_CLEAR 7 · VALIDATE 5 · VALUE_SET 5 · GRID_BIND 5 · GRID_STYLE 5 · LIST_REBIND 3 · LIST_CLEAR 1 · THROW 1 · ⚠ 의미 확인 필요 84


## SCP0083_DIOReport.BtnVersionCreate_Click

진입점: btnVersionCreate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-410a1ce2 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2880 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ce214c11 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2884 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-78da21e2 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2884 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d88c0ce9 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2888 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6e003d1b | btnVersionCreate.Click | SCP0083_DIOReport.cs:2897 | try | CALL_EXT | ScpUtils.ConvertInt | (CString.GetCheckedListValue(dtVersion, cboVersion.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79d6717e | btnVersionCreate.Click | SCP0083_DIOReport.cs:2903 | try ▸ if (p_ver_type.Equals("C")) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f86fa295 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2904 | try ▸ if (p_ver_type.Equals("C")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00081") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8f9a32b1 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2905 | try ▸ if (p_ver_type.Equals("C")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27a028c1 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2909 | try ▸ else of (p_ver_type.Equals("C")) ▸ if (p_ver_type.Equals("P")) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3bc33431 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2910 | try ▸ else of (p_ver_type.Equals("C")) ▸ if (p_ver_type.Equals("P")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00082") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b62471ed | btnVersionCreate.Click | SCP0083_DIOReport.cs:2911 | try ▸ else of (p_ver_type.Equals("C")) ▸ if (p_ver_type.Equals("P")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d699c890 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2917 | try ▸ if (p_month < 3) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-74137330 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2918 | try ▸ if (p_month < 3) | MESSAGE | MessageHelper.GMessageBox | ("MSG00384") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b78f37a | btnVersionCreate.Click | SCP0083_DIOReport.cs:2919 | try ▸ if (p_month < 3) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c8496e8 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2923 | try ▸ else of (p_month < 3) ▸ if (p_month > 12) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dcc913d2 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2924 | try ▸ else of (p_month < 3) ▸ if (p_month > 12) | MESSAGE | MessageHelper.GMessageBox | ("MSG00384") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3590749d | btnVersionCreate.Click | SCP0083_DIOReport.cs:2925 | try ▸ else of (p_month < 3) ▸ if (p_month > 12) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-025056c0 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2929 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-36a54bee | btnVersionCreate.Click | SCP0083_DIOReport.cs:2930 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-14563625 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2934 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCP_ANL_DIO_REPORT") ⇒ SCP.PR_SCP_ANL_DIO_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-8753baac | btnVersionCreate.Click | SCP0083_DIOReport.cs:2935 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5046ed99 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2936 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1779ffcf | btnVersionCreate.Click | SCP0083_DIOReport.cs:2937 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-797d2199 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2938 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-946a8e7a | btnVersionCreate.Click | SCP0083_DIOReport.cs:2939 | try ▸ lambda | DATA_OP | request.Parameters["p_month"] | p_month | 행/컬럼 값 대입 |  |  |  |
| AC-8852b4c4 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2940 | try ▸ lambda | DATA_OP | request.Parameters["p_ver"] | p_ver | 행/컬럼 값 대입 |  |  |  |
| AC-752be8a2 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2941 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9d78675 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2943 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-187506bf | btnVersionCreate.Click | SCP0083_DIOReport.cs:2948 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ba8501f7 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2966 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a6875f01 | btnVersionCreate.Click | SCP0083_DIOReport.cs:2967 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-776742ae | btnVersionCreate.Click | SCP0083_DIOReport.cs:2971 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1abdb62d | btnVersionCreate.Click | SCP0083_DIOReport.cs:2982 | finally ▸ if (ScpUtils.CheckDataEmpty(resultMessage) == false) ▸ if (resultMessage != "!") | MESSAGE | MessageHelper.GMessageBox | (string.Format("[오류코드 = {0}]", resultMessage)) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0083_DIOReport.BtnVersionDelete_Click

진입점: btnVersionDelete.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7646d8a2 | btnVersionDelete.Click | SCP0083_DIOReport.cs:2999 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8febe212 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3003 | try | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e56e025f | btnVersionDelete.Click | SCP0083_DIOReport.cs:3005 | try ▸ if (MessageHelper.GMessageBox("MSG00016") != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5a087517 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3011 | try ▸ if (p_ver_type.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00083") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fb43b595 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3012 | try ▸ if (p_ver_type.Equals("N")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-699df8a3 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3016 | try ▸ else of (p_ver_type.Equals("N")) ▸ if (p_ver_type.Equals("P")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00082") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8838a8b4 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3017 | try ▸ else of (p_ver_type.Equals("N")) ▸ if (p_ver_type.Equals("P")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2746e8d3 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3020 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-58aa1d76 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3020 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c08ce99f | btnVersionDelete.Click | SCP0083_DIOReport.cs:3024 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-488ed563 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3032 | try | CALL_EXT | ScpUtils.ConvertInt | (CString.GetCheckedListValue(dtVersion, cboVersion.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f3f2cb65 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3036 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-ad21af77 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3037 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c3db7234 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3041 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCP_ANL_DIO_REPORT_VERSION_DELETE") ⇒ SCP.PR_SCP_ANL_DIO_REPORT_VERSION_DELETE | 엔드포인트 요청 생성 |  |  |  |
| AC-5d47a2e8 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3042 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-083736af | btnVersionDelete.Click | SCP0083_DIOReport.cs:3043 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-40d5242b | btnVersionDelete.Click | SCP0083_DIOReport.cs:3044 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7d9c73da | btnVersionDelete.Click | SCP0083_DIOReport.cs:3045 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-89c13e3b | btnVersionDelete.Click | SCP0083_DIOReport.cs:3046 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8a7dfc5d | btnVersionDelete.Click | SCP0083_DIOReport.cs:3047 | try ▸ lambda | DATA_OP | request.Parameters["p_ver"] | p_ver | 행/컬럼 값 대입 |  |  |  |
| AC-402b0d94 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3048 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-d8e50e22 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3050 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c0ae2ca3 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3055 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1f26e19b | btnVersionDelete.Click | SCP0083_DIOReport.cs:3068 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3a54b20c | btnVersionDelete.Click | SCP0083_DIOReport.cs:3069 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-49b6a6d5 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3073 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-998bf3f4 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3085 | finally ▸ if (ScpUtils.CheckDataEmpty(resultMessage) == false) ▸ if (resultMessage != "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { resultMessage }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45106dc3 | btnVersionDelete.Click | SCP0083_DIOReport.cs:3090 | finally ▸ if (ScpUtils.CheckDataEmpty(resultMessage) == false) ▸ else of (resultMessage != "1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00031") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0083_DIOReport.CalculateAllOff

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50181f43 | (진입점 미연결) | SCP0083_DIOReport.cs:1663 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (ScpUtils.CheckDataEmpty(formula) == false) | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol].Formula | null | 그리드 속성/값 설정 |  |  |  |

## SCP0083_DIOReport.CalculateCycle

진입점: btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdCycle.Visible) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (this.spdCycle.Visible) ▸ try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (ds.Tables[0].Rows.Count …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83f6af2e | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:1321 | for (i < siCycle.ActiveSheet.RowCount) | GRID_SET | siCycle.ActiveSheet.Cells[i, siCycle.GetColumnIndex(DefColumns.CYCLE_STOCK)].Formula | "(30.4 *" + cycle + "/" + "2 *" + non_operation + ")*0.01" | 그리드 속성/값 설정 |  |  |  |
| AC-965a8750 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:1326 | for (i < siCycle.ActiveSheet.RowCount) | GRID_SET | siCycle.ActiveSheet.Cells[i, siCycle.GetColumnIndex(DefColumns.WEIGHT_CYCLE_STOCK)].Formul… | "(30.4 *" + cycle + "/" + "2 *" + non_operation + ")*0.01" + "*" + global_ratio + "* 0.01" | 그리드 속성/값 설정 |  |  |  |

## SCP0083_DIOReport.CalculateSum

진입점: btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdMain.Visible) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (IsEditMode)] / SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb4bf768 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1440 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_CELL_SUM].Formula | "SUM(" + cell_aging_lt + ":" + cell_eol_shipping_lot + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-63f8ef3b | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1445 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_PACK_SUM].Formula | "SUM(" + pack_incomming + ":" + pack_operation_lt + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-def02168 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1459 | for (i < siMain.ActiveSheet.RowCount) ▸ try | CALL_EXT | ScpUtils.CheckNumberCellValueEmpty | (shipment_cell_sum_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-45d36169 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1463 | for (i < siMain.ActiveSheet.RowCount) ▸ try | CALL_EXT | ScpUtils.CheckNumberCellValueEmpty | (shipment_pack_sum_value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2cd4f2ba | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1471 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ if (use_shipment_cell_sum \|\| use_shipment_pack_sum) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_CELL_SUM].Value | shipment_cell_sum_value | 그리드 속성/값 설정 |  |  |  |
| AC-1633fcb3 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1472 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ if (use_shipment_cell_sum \|\| use_shipment_pack_sum) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_PACK_SUM].Value | shipment_pack_sum_value | 그리드 속성/값 설정 |  |  |  |
| AC-6834597a | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1476 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ else of (use_shipment_cell_sum \|\| use_shipment_pack_sum) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_CELL_SUM].Formula | "SUM(" + shipment_cell_inspection_load + ":" + shipment_cell_inspection_waiting + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-c216478d | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1477 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ else of (use_shipment_cell_sum \|\| use_shipment_pack_sum) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_PACK_SUM].Formula | "SUM(" + shipment_pack_inspection_load + ":" + shipment_pack_inspection_waiting + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-182bd445 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1484 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_INSPECTION_LOAD_SUM].Formula | "SUM(" + shipment_cell_inspection_load + "+" + shipment_pack_inspection_load + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-7c5c96b0 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1485 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_INSPECTION_WAITING_SUM].Formula | "SUM(" + shipment_cell_inspection_waiting + "+" + shipment_pack_inspection_waiting + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-d693c404 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1492 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ if (use_shipment_cell_sum \|\| use_shipment_pack_sum) | VALUE_SET | shipment_sum.Value | (ScpUtils.GetValueDecimal(shipment_cell_sum.Value) + ScpUtils.GetValueDecimal(shipment_pac… | 컨트롤 값 설정 |  |  |  |
| AC-39977c02 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1492 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ if (use_shipment_cell_sum \|\| use_shipment_pack_sum) | CALL_EXT | ScpUtils.GetValueDecimal | (shipment_cell_sum.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bd72cf97 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1492 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ if (use_shipment_cell_sum \|\| use_shipment_pack_sum) | CALL_EXT | ScpUtils.GetValueDecimal | (shipment_pack_sum.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02211574 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1496 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ else of (use_shipment_cell_sum \|\| use_shipment_pack_sum) | UI_PROP | shipment_sum.Formula | "SUM(" + shipment_inspection_load_sum + ":" + shipment_inspection_waiting_sum + ")" | 속성 Formula 설정 |  |  |  |
| AC-b078348e | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1503 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_PRE_INSPECTION_SUM].Formula | "SUM(" + pre_inspection_cell + ":" + pre_inspection_pack + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-95f7cf7e | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1508 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_VMI_SUM].Formula | "SUM(" + vmi_cell + ":" + vmi_pack + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-dcdd261c | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1520 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_DEPARTURE_INTRANSIT_VMI_AUTO].Formula | "SUM(" + shipemnt_sum + "+" + dni_sum + "+" + pre_inspection_sum + "+" + vmi_sum + "+" + f… | 그리드 속성/값 설정 |  |  |  |
| AC-0e4d2ff0 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1526 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SAFETY_STOCK_SUM].Formula | "SUM(" + safety_stock_cell + ":" + safety_stock_pack + ":" + safety_stock_pin_house + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-daad3635 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1531 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_OTHER_STOCK_SUM].Formula | "SUM(" + other_stock_cell + ":" + other_stock_pack + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-f21ab569 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1536 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_PRODUCTION_CYCLE_SUM].Formula | "SUM(" + production_cycle_cell + ":" + production_cycle_pack + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-2ca1b637 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1544 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_STANDARD_DIO_AUTO].Formula | "SUM(" + cell_sum + "+" + pack_sum + "+" + departure_days_intransit_vmi_auto + "+" + safet… | 그리드 속성/값 설정 |  |  |  |
| AC-a2fd5c7d | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1558 | for (i < siMain.ActiveSheet.RowCount) ▸ try | CALL_EXT | ScpUtils.CheckNumberCellValueEmpty | (weight_dio.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b19d6869 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1560 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ if (ScpUtils.CheckNumberCellValueEmpty(weight_dio.Value) == false) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_DIO_AUTO].Value | weight_dio.Value | 그리드 속성/값 설정 |  |  |  |
| AC-98851c38 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1564 | for (i < siMain.ActiveSheet.RowCount) ▸ try ▸ else of (ScpUtils.CheckNumberCellValueEmpty(weight_dio.Value) == false) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_DIO_AUTO].Formula | "(" + standard_dio + "*" + assembly_total_ratio + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-830f7eac | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1570 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_OP_LT_TOTAL_AUTO].Formula | "SUM(" + cell_sum + "," + pack_sum + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-968ff6b3 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1574 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_CYCLE_TOTAL_AUTO].Formula | "SUM(" + oroduction_cycle_sum + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-34d24529 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1577 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_INTRANSIT_TOTAL_AUTO].Formula | "SUM(" + shipemnt_pack_sum + "+" + dni_sum + "+" + pre_inspection_sum + "+" + vmi_sum + "+… | 그리드 속성/값 설정 |  |  |  |
| AC-24909007 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1581 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_OPEARTION_TYPE_AUTO].Formula | "SUM(" + op_lt_total + "+" + assembly_type_ratio + ") " | 그리드 속성/값 설정 |  |  |  |
| AC-b8872e88 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1589 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_OPEARTION_TOTAL_AUTO].Formula | "" + assembly_total_ratio + "*" + op_lt_total_auto + "" | 그리드 속성/값 설정 |  |  |  |
| AC-462a8fbb | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1593 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_CYCLE_TYPE_AUTO].Formula | "SUM(" + intransit_total_auto + "+" + assembly_type_ratio + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-cb21e36b | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1598 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_CYCLE_TOTAL_AUTO].Formula | "" + assembly_total_ratio + "*" + cycle_total + "" | 그리드 속성/값 설정 |  |  |  |
| AC-1142c132 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1601 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_INTRANSIT_TYPE_AUTO].Formula | "SUM(" + cycle_total + "+" + assembly_total_ratio + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-3036f28e | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:1606 | for (i < siMain.ActiveSheet.RowCount) ▸ try | GRID_SET | siMain.ActiveSheet.Cells[i, idx_WEIGHT_INTRANSIT_TOTAL_AUTO].Formula | "" + assembly_total_ratio + "*" + intransit_total_auto + "" | 그리드 속성/값 설정 |  |  |  |

## SCP0083_DIOReport.CalculateSumOFF

진입점: EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c65efa9 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1628 | try ▸ for (i < siMain.ActiveSheet.RowCount) | UI_PROP | shipment_cell_sum.Formula | null | 속성 Formula 설정 |  |  |  |
| AC-dea4621c | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1630 | try ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_CELL_SUM].Value | focusValue | 그리드 속성/값 설정 |  |  |  |
| AC-9b0a9cce | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1634 | try ▸ for (i < siMain.ActiveSheet.RowCount) | UI_PROP | shipment_pack_sum.Formula | null | 속성 Formula 설정 |  |  |  |
| AC-defdd895 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1636 | try ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_PACK_SUM].Value | focusValue | 그리드 속성/값 설정 |  |  |  |
| AC-bf64ff66 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1639 | try ▸ for (i < siMain.ActiveSheet.RowCount) | UI_PROP | shipment_sum.Formula | null | 속성 Formula 설정 |  |  |  |
| AC-0291de7b | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1641 | try ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[i, idx_SHIPMENT_SUM].Value | focusValue | 그리드 속성/값 설정 |  |  |  |
| AC-599f3bda | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1643 | try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | ScpUtils.SetActionFlag | (siMain, i, null) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4b40ccf | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1644 | try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | ScpUtils.SetCellForeColor | (siMain, i, idx_SHIPMENT_CELL_SUM, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d19515cc | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1645 | try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | ScpUtils.SetCellForeColor | (siMain, i, idx_SHIPMENT_PACK_SUM, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-efdaddbd | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:1646 | try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | ScpUtils.SetCellForeColor | (siMain, i, idx_SHIPMENT_SUM, true) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0083_DIOReport.CalculateTotalRatio

진입점: btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdCycle.Visible) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (this.spdCycle.Visible) ▸ try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (ds.Tables[0].Rows.Count …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eecb881c | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:1336 | try ▸ lambda | DATA_OP | row.Field | (DefColumns.OPERATION_GROUP) | 데이터 객체 조작/조회 |  |  |  |
| AC-e3252c08 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:1337 | try ▸ lambda | DATA_OP | a.Field | ("MODEL_SUM2") | 데이터 객체 조작/조회 |  |  |  |
| AC-326dab73 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:1347 | try ▸ for (i < siMain.ActiveSheet.RowCount) | GRID_SET | siMain.ActiveSheet.Cells[i, iCol_Assembly_Total_ratio].Formula | "" + assemble_qty + "/" + MODEL_SUM2_value_2 + "" | 그리드 속성/값 설정 |  |  |  |
| AC-88ca31d9 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:1353 | try ▸ for (i < siMain.ActiveSheet.RowCount) | UI_PROP | weight_dio.Formula | "(" + standard_dio + "*" + assembly_total_ratio + ")" | 속성 Formula 설정 |  |  |  |

## SCP0083_DIOReport.CboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45175ee2 | cboDivision.SelectedIndexChanged | SCP0083_DIOReport.cs:2836 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-91818fd9 | cboDivision.SelectedIndexChanged | SCP0083_DIOReport.cs:2837 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdCycle) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0083_DIOReport.CboOperationGroup_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7f5174e | (진입점 미연결) | SCP0083_DIOReport.cs:2867 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdCycle) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0083_DIOReport.CboPlan_SelectedIndexChanged

진입점: cboPlan.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0fb9e4e | cboPlan.SelectedIndexChanged | SCP0083_DIOReport.cs:2845 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-4be9badb | cboPlan.SelectedIndexChanged | SCP0083_DIOReport.cs:2846 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdCycle) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0083_DIOReport.CboVersion_SelectedIndexChanged

진입점: cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff4d3ba1 | cboVersion.SelectedIndexChanged | SCP0083_DIOReport.cs:2856 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-23033254 | cboVersion.SelectedIndexChanged | SCP0083_DIOReport.cs:2857 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdCycle) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0083_DIOReport.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-701fccd4 | this.Load | SCP0083_DIOReport.cs:270 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2dfc5c64 | this.Load | SCP0083_DIOReport.cs:271 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-5fdd9068 | this.Load | SCP0083_DIOReport.cs:273 |  | GRID_INIT | this.AddSheet | (spdCycle, SpdSheet.shtCycle, SpdSheet.shtCycle, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c93d7c85 | this.Load | SCP0083_DIOReport.cs:274 |  | FLAG | siCycle | GetSheetInfo(spdCycle.Name, spdCycle.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7075287d | this.Load | SCP0083_DIOReport.cs:276 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0083_DIOReport.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10fa90b2 | Dispose | SCP0083_DIOReport.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReport.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf69cce6 | EditButton | SCP0083_DIOReport.cs:368 |  | FLAG | isEditAfter | true | 화면 필드/플래그 변경 |  |  |  |
| AC-6e6a7de1 | EditButton | SCP0083_DIOReport.cs:369 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-83fc3da9 | EditButton | SCP0083_DIOReport.cs:375 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cfee486b | EditButton | SCP0083_DIOReport.cs:376 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d91bd2c4 | EditButton | SCP0083_DIOReport.cs:377 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d3facedd | EditButton | SCP0083_DIOReport.cs:381 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode == false) | FLAG | isEditAfter | false | 화면 필드/플래그 변경 |  |  |  |
| AC-39a1df5b | EditButton | SCP0083_DIOReport.cs:383 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6d19c18a | EditButton | SCP0083_DIOReport.cs:399 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | CALL_EXT | siMain.GetValue2 | (0, siMain.GetColumnIndex(DefColumns.VERSION)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2bae0758 | EditButton | SCP0083_DIOReport.cs:401 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e7aa7dd2 | EditButton | SCP0083_DIOReport.cs:402 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7cf4ded6 | EditButton | SCP0083_DIOReport.cs:406 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19723c5f | EditButton | SCP0083_DIOReport.cs:407 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1f8f7bd2 | EditButton | SCP0083_DIOReport.cs:409 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-12ea20fb | EditButton | SCP0083_DIOReport.cs:412 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c41af634 | EditButton | SCP0083_DIOReport.cs:416 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ea3afbb5 | EditButton | SCP0083_DIOReport.cs:417 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-399f4575 | EditButton | SCP0083_DIOReport.cs:418 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1bc55eb6 | EditButton | SCP0083_DIOReport.cs:421 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c3405f7d | EditButton | SCP0083_DIOReport.cs:424 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca444d57 | EditButton | SCP0083_DIOReport.cs:425 | if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.s… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.CELL_AGING_LT), spdMain.ActiveSheet.RowCount - 1, siM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5baddd21 | EditButton | SCP0083_DIOReport.cs:434 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ if (siCycle.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6a02fefc | EditButton | SCP0083_DIOReport.cs:435 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | FLAG | siCycle | GetSheetInfo(spdCycle.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-425715c7 | EditButton | SCP0083_DIOReport.cs:450 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ if (!isCycleEdit) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a624b5d2 | EditButton | SCP0083_DIOReport.cs:451 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ if (!isCycleEdit) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c4707e8 | EditButton | SCP0083_DIOReport.cs:453 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | GRID_LOCK | siCycle.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-72ea80cb | EditButton | SCP0083_DIOReport.cs:456 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-deab7d5d | EditButton | SCP0083_DIOReport.cs:457 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ed6afeac | EditButton | SCP0083_DIOReport.cs:459 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visi… | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d8eba4c9 | EditButton | SCP0083_DIOReport.cs:462 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | GRID_LOCK | siCycle.LockRange | (0, 0, siCycle.ActiveSheet.RowCount - 1, siCycle.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-609f3b11 | EditButton | SCP0083_DIOReport.cs:464 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | fps.ActiveSheet.Columns.Get | (xCol1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6d2a39d2 | EditButton | SCP0083_DIOReport.cs:466 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visi… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13c9787c | EditButton | SCP0083_DIOReport.cs:469 | else of (this.spdMain.Visible) ▸ if (spdCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | GRID_LOCK | siCycle.LockRange | (0, siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG), spdCycle.ActiveSheet.RowCount - 1, si… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0083_DIOReport.Find_Data

진입점: btnVersionCreate.Click [try] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1"))] / FindButton [if (this.spdMain.Visible)] / SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3061d864 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:508 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98877028 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:509 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64d80c89 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:512 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0e6058b6 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:515 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-a0c8d133 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:517 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-aa9aae6f | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:517 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-29fadd3e | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:521 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-4418ba74 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:528 | try ▸ if (type.Equals(2)) | VALUE_SET | cboPlan.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-9374f6a2 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:535 | try | CALL_EXT | ScpUtils.ConvertInt | (CString.GetCheckedListValue(dtVersion, cboVersion.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e47fc0da | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:546 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-e6e41425 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:547 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a40f0dbf | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:551 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_DIO_REPORT") ⇒ SCP.SCP0083_GET_DIO_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-3d2731ed | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:552 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2e229be9 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:553 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-5fa19637 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:554 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-bc3cdbf8 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:555 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-fc60ec32 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:556 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4653c100 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:557 | try ▸ lambda | DATA_OP | request.Parameters["p_ver"] | p_ver | 행/컬럼 값 대입 |  |  |  |
| AC-87ec4834 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:558 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-36aa9dda | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:559 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-285bac02 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:561 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bb34d8e9 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:562 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ebc7dc1e | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:569 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-51f0c043 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:571 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d84b4ea | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:574 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-1e5c1f2d | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:580 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c687a97b | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:581 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ed8c1d9b | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:584 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dsOrigianlCopy | ScpUtils.GetDataSource(siMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-a627575c | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:584 | try ▸ if (ds.Tables[0].Rows.Count > 0) | ENDPOINT | ScpUtils.GetDataSource | (siMain) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-510e2f37 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:591 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d5d6435 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:607 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c7684e21 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:608 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2557f9e4 | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:612 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-87b10a7e | btnVersionCreate.Click [try] 외 3 | SCP0083_DIOReport.cs:613 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReport.Find_Data_Cycle

진입점: btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (type >= 2)] / FindButton [if (this.spdCycle.Visible)] / SaveButton [if (this.spdCycle.Visible) ▸ try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cca854a | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:669 | if (blnWorkSub) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad943425 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:670 | if (blnWorkSub) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55d43b24 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:673 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b8be25d0 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:676 | try | FLAG | blnWorkSub | true | 화면 필드/플래그 변경 |  |  |  |
| AC-55370def | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:677 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-d4251ef2 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:677 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2b434d4b | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:681 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-160b2809 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:696 | try | CALL_EXT | ScpUtils.ConvertInt | (CString.GetCheckedListValue(dtVersion, cboVersion.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-790b0c07 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:714 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-4e26cebd | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:715 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Analysis.WSL/FoxDataServi… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-215cc11b | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:719 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (strQryName) ⇒ SCP.SCP0083_GET_DIO_CYCLE_INVENTORY | 엔드포인트 요청 생성 |  |  |  |
| AC-00a0434b | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:720 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-16d42536 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:721 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bcf55bb3 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:722 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3885ab60 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:723 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-220a8a14 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:724 | try ▸ lambda | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-44d3a8ad | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:725 | try ▸ lambda | DATA_OP | request.Parameters["p_ver"] | p_ver | 행/컬럼 값 대입 |  |  |  |
| AC-905a48c5 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:726 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-00848f6c | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:727 | try ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-151c52d8 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:729 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6dba8980 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:731 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-89f43b02 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:738 | try | CALL_EXT | siCycle.FilterRemove | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c259ef6 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:740 | try | GRID_BIND | siCycle.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-66f463ad | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:742 | try | GRID_LOCK | siCycle.LockColumn | (0, siCycle.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-36e2a278 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:745 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7c165949 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:762 | try | GRID_INIT | siCycle.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-55e4c87d | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:777 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3baa8fb4 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:778 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31b4601d | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:782 | finally | FLAG | blnWorkSub | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b4397c90 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2)] 외 3 | SCP0083_DIOReport.cs:783 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReport.Find_Data_Reset

진입점: EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72ec0c11 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:619 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-94b2af47 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:623 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-85b9bd81 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:626 | try | LIST_CLEAR | siMain.SpreadObject.DataSource | null | 목록/그리드 데이터 원천 해제 |  |  |  |
| AC-fcbf5968 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:627 | try | GRID_SET | siMain.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-86964e5a | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:637 | try | CALL_EXT | siMain.BindChangeSheet | (siMain.ActiveSheet.SheetName, dsOrigianlCopy) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c23136fd | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:639 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a2eb4f74 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:648 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94f282df | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:653 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dea0b240 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:654 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ae89f753 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:658 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReport.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3594370e | FindButton | SCP0083_DIOReport.cs:356 | if (this.spdMain.Visible) | FLAG | isEditAfter | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0083_DIOReport.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-599b3f57 | this.Load | SCP0083_DIOReport.cs:239 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0083_DIOReport.GetParamVersion

진입점: SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e08acd3f | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:1747 | try ▸ if (cboVersion != null) | CALL_EXT | ScpUtils.ConvertInt | (ver) | ⚠ 의미 확인 필요 |  |  |  |
| AC-170abbac | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:1753 |  | RETURN | return version; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.GetParamVersionRange

진입점: cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f76dac | cboVersion.SelectedIndexChanged | SCP0083_DIOReport.cs:1789 | try ▸ if (cboVersion != null) ▸ if (dtVersion == null \|\| string.IsNullOrEmpty(cboVersion.ControlValues)) | RETURN | return versionRange; |  | 처리 중단/반환 |  |  |  |
| AC-2f2c956e | cboVersion.SelectedIndexChanged | SCP0083_DIOReport.cs:1795 | try ▸ if (cboVersion != null) ▸ for (i < dtVersion.Rows.Count) | DATA_OP | type.Contains | ("C") | 데이터 객체 조작/조회 |  |  |  |
| AC-7383b9d8 | cboVersion.SelectedIndexChanged | SCP0083_DIOReport.cs:1806 |  | RETURN | return versionRange; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.GetParamVersionType

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlan.SelectedIndexChanged / cboVersion.SelectedIndexChanged / btnVersionCreate.Click [try] / btnVersionDelete.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74e4a138 | this.Load 외 5 | SCP0083_DIOReport.cs:1764 | try ▸ try ▸ if (cboVersion != null) | CALL_EXT | ScpUtils.GetComboSelectName | (dtVersion, cboVersion.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ed1da29 | this.Load 외 5 | SCP0083_DIOReport.cs:1777 |  | RETURN | return versionType; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.GetPlanCombo

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-846e7919 | this.Load 외 1 | SCP0083_DIOReport.cs:1710 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_PLAN_VERSION_INFO") ⇒ SCP.SCP0083_GET_PLAN_VERSION_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-fbdf0899 | this.Load 외 1 | SCP0083_DIOReport.cs:1711 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-d005ffc7 | this.Load 외 1 | SCP0083_DIOReport.cs:1713 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1d51f110 | this.Load 외 1 | SCP0083_DIOReport.cs:1713 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.GetVersionCombo

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlan.SelectedIndexChanged / btnVersionCreate.Click [try] / btnVersionDelete.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc064f4 | this.Load 외 4 | SCP0083_DIOReport.cs:1729 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_DIO_VERSION_INFO") ⇒ SCP.SCP0083_GET_DIO_VERSION_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-bf0a396f | this.Load 외 4 | SCP0083_DIOReport.cs:1731 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7fc7ea81 | this.Load 외 4 | SCP0083_DIOReport.cs:1732 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-45ab6da4 | this.Load 외 4 | SCP0083_DIOReport.cs:1733 |  | DATA_OP | request.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-be3ba399 | this.Load 외 4 | SCP0083_DIOReport.cs:1734 |  | DATA_OP | request.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-5ac61a32 | this.Load 외 4 | SCP0083_DIOReport.cs:1736 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-463a4c48 | this.Load 외 4 | SCP0083_DIOReport.cs:1736 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a71802b6 | this.Load | SCP0083_DIOReport.cs:258 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1fa3b6d | this.Load | SCP0083_DIOReport.cs:261 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-90963804 | this.Load | SCP0083_DIOReport.cs:263 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0083_DIOReport.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7321d5a | this.Load | SCP0083_DIOReport.cs:285 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-141fbc47 | this.Load | SCP0083_DIOReport.cs:286 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a5ad092c | this.Load | SCP0083_DIOReport.cs:287 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-293027a2 | this.Load | SCP0083_DIOReport.cs:289 |  | GRID_INIT | siCycle.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72c596be | this.Load | SCP0083_DIOReport.cs:290 |  | GRID_INIT | siCycle.ChangeActiveSheet | (SpdSheet.shtCycle) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2fd1900 | this.Load | SCP0083_DIOReport.cs:291 |  | GRID_INIT | siCycle.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReport.IsEditColumn

진입점: this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f75789ed | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1672 |  | DATA_OP | calTag.Contains | ("DNI") | 데이터 객체 조작/조회 |  |  |  |
| AC-232d0d5f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1674 | if (calTag.Contains("DNI")) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-563a623f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1682 | if (calTag.Equals(DefColumns.SHIPMENT_CELL_SUM) \|\| calTag.Equals(DefColumns.SHIPMENT_PACK_SUM)) | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-7145bcd7 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1685 |  | DATA_OP | calTag.Contains | ("SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbe17d13 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1685 |  | DATA_OP | calTag.Contains | ("AUTO") | 데이터 객체 조작/조회 |  |  |  |
| AC-5621ccff | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1686 |  | DATA_OP | calTag.Contains | (DefColumns.STANDARD_DIO_AUTO) | 데이터 객체 조작/조회 |  |  |  |
| AC-fca6351c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1687 |  | DATA_OP | calTag.Contains | (DefColumns.WEIGHT_DIO_AUTO) | 데이터 객체 조작/조회 |  |  |  |
| AC-85f84c98 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1689 |  | DATA_OP | calTag.Contains | (DefColumns.FOREIGN_CORP) | 데이터 객체 조작/조회 |  |  |  |
| AC-398736c8 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1690 |  | DATA_OP | calTag.Contains | (DefColumns.RACK_BIZ) | 데이터 객체 조작/조회 |  |  |  |
| AC-1864b67f | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1691 |  | DATA_OP | calTag.Contains | (DefColumns.SHIPMENT_SUM) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f9b4b9c | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1694 |  | DATA_OP | calTag.Contains | (DefColumns.DEPARTURE_INTRANSIT_VMI_AUTO) | 데이터 객체 조작/조회 |  |  |  |
| AC-f574ac08 | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1696 | if ((calTag.Contains("SUM") \|\| calTag.Contains("AUTO") && !(calTag.Contains(DefColumns.STANDARD_DIO_AUTO) \|\| calTag.Contains…) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7317d35e | this.spdMain.CellDoubleClick [if (siMain.ActiveSheet.SheetNa… | SCP0083_DIOReport.cs:1699 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.SaveData_Cycle

진입점: SaveButton [if (this.spdCycle.Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f35dcb2 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1114 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2dc7d1d3 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1121 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (siCycle.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e4f1feb | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1127 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-0113d975 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1128 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff18b236 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1129 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-2bcf8449 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1130 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-30c47c11 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1131 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5607acbd | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1132 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("VER") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7631845 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1133 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("NICK_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7f60092 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1134 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-56b71935 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1135 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("TRANSPORT_MODE_LINE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3d7d0722 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1136 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-469fdbc6 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1137 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("DATA_RANGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3cd7043 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1138 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("FROM_SITE_DESCRIPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-15f55b55 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1139 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("CELL_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3df227c0 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1140 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("PACK_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ebdbf34 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1141 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("OPERATION_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-dbd98ee1 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1142 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M1") | 데이터 객체 조작/조회 |  |  |  |
| AC-9beb3ec3 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1143 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M2") | 데이터 객체 조작/조회 |  |  |  |
| AC-946921ce | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1144 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M3") | 데이터 객체 조작/조회 |  |  |  |
| AC-40bebd2a | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1145 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M4") | 데이터 객체 조작/조회 |  |  |  |
| AC-0301b388 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1146 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M5") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d2341a8 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1147 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M6") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f084e3b | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1148 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M7") | 데이터 객체 조작/조회 |  |  |  |
| AC-b26cc650 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1149 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M8") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ca3e29d | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1150 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M9") | 데이터 객체 조작/조회 |  |  |  |
| AC-d2b23ecd | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1151 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M10") | 데이터 객체 조작/조회 |  |  |  |
| AC-50f5cfbf | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1152 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M11") | 데이터 객체 조작/조회 |  |  |  |
| AC-fe543517 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1153 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("M12") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea7797f5 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1154 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("PRIVATE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-0eaf5b70 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1155 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("CYCLE") | 데이터 객체 조작/조회 |  |  |  |
| AC-74bdbecb | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1156 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-d90f8b7e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1157 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc71ec13 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1158 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE3") | 데이터 객체 조작/조회 |  |  |  |
| AC-877932ca | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1159 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE4") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ef434d1 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1160 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE5") | 데이터 객체 조작/조회 |  |  |  |
| AC-120f792a | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1161 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE6") | 데이터 객체 조작/조회 |  |  |  |
| AC-9565e0f9 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1162 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE7") | 데이터 객체 조작/조회 |  |  |  |
| AC-feff9b7d | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1163 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE8") | 데이터 객체 조작/조회 |  |  |  |
| AC-0872b616 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1164 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE9") | 데이터 객체 조작/조회 |  |  |  |
| AC-d438b903 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1165 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE10") | 데이터 객체 조작/조회 |  |  |  |
| AC-42be2877 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1166 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("WEIGHT_CYCLE_STOCK") | 데이터 객체 조작/조회 |  |  |  |
| AC-dccbe28b | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1167 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("GLOBAL_MODEL_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-959a537e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1168 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("GLOBAL_SITE_RATIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd8a9e4f | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1169 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-635e4399 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1170 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("PROGRAM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ffc54a7c | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1171 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dt.Columns.Add | ("DEBUG_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1cb9b9e5 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1173 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-832ad605 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1183 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3422737e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1185 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-056da84b | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1186 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-076219fb | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1187 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.PLAN_TYPE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6b71be1c | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1188 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.SEQ)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d0015a37 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1189 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.NICK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ddb3312 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1190 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.FROM_SITE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fe69458 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1191 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.OPERATION_GROUP)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07e930a7 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1196 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a4129c50 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1197 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce7ba4cc | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1198 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.PLAN_TYPE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-76657352 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1199 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.SEQ)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7022b25f | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1200 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.NICK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1324eeb3 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1201 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.FROM_SITE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9cb844c5 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1202 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) ▸ for (k < siCycle.ActiveShee… | CALL_EXT | siCycle.GetValue2 | (k, siCycle.GetColumnIndex(DefColumns.OPERATION_GROUP)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d56892d4 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1211 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["ACTIVE_FLAG"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-91060485 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1212 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["DIVISION_ID"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-71ad5d6e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1213 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["PLAN_START_YYYYMMDD"] | plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d9c1a780 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1214 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["PLAN_TYPE"] | plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-2c158cc3 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1215 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["SEQ"] | seq | 행/컬럼 값 대입 |  |  |  |
| AC-77b97ee4 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1216 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["VER"] | GetParamVersion() | 행/컬럼 값 대입 |  |  |  |
| AC-5b062632 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1217 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["NICK_NAME"] | nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-3c300f02 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1218 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["PLANT_ID"] | siCycle.GetValue2(i, siCycle.GetColumnIndex(DefColumns.PLANT_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-6f03f5f4 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1218 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e7590626 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1219 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["TRANSPORT_MODE_LINE"] | siCycle.GetValue2(i, siCycle.GetColumnIndex(DefColumns.TRANSPORT_MODE_LINE)) | 행/컬럼 값 대입 |  |  |  |
| AC-459e48fa | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1219 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.TRANSPORT_MODE_LINE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8621820 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1220 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["FROM_SITE"] | from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5d03849e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1221 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["PACK_GROUP"] | siCycle.GetValue2(i, siCycle.GetColumnIndex(DefColumns.PACK_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-5d49f9ac | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1221 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.PACK_GROUP)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-52e44a32 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1222 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["OPERATION_GROUP"] | siCycle.GetValue2(i, siCycle.GetColumnIndex(DefColumns.OPERATION_GROUP)) | 행/컬럼 값 대입 |  |  |  |
| AC-8d338487 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1222 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | CALL_EXT | siCycle.GetValue2 | (i, siCycle.GetColumnIndex(DefColumns.OPERATION_GROUP)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b9e4ace | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1223 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["PRIVATE_FLAG"] | siCycle.GetText(i, siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG)) | 행/컬럼 값 대입 |  |  |  |
| AC-7d5df26e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1224 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["CYCLE"] | siCycle.GetText(i, siCycle.GetColumnIndex(DefColumns.CYCLE)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-f6d7a7b6 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1225 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["WEIGHT_CYCLE_STOCK"] | t_weight_cycle_stock.ToString().Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-f69ebab9 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1226 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["GLOBAL_MODEL_SUM"] | siCycle.GetText(i, siCycle.GetColumnIndex(DefColumns.GLOBAL_MODEL_SUM)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-bb7ad752 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1227 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["GLOBAL_SITE_RATIO"] | siCycle.GetText(i, siCycle.GetColumnIndex(DefColumns.GLOBAL_SITE_RATIO)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-76919938 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1228 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-556a82b2 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1229 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["PROGRAM_ID"] | "SCP0083" | 행/컬럼 값 대입 |  |  |  |
| AC-1d8d2085 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1230 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dr["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-0727bfa8 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1232 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ for (i <= siCycle.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4e97f8a | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1240 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-74b4e815 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1248 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d4c8d46a | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1257 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0083_CYCLE", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf63061c | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1258 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveDioCycleInventory") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDioCycleInventory] … | 엔드포인트 호출 |  |  |  |
| AC-a0f0795f | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1261 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-98557e1d | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1266 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count >… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eae502f5 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1275 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Co… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65615b48 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1284 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3dcc36d0 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1286 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9a0cfb35 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1292 | try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-77e1296e | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1301 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8e9046b4 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1302 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90ecf675 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1306 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f1ee7893 | SaveButton [if (this.spdCycle.Visible)] | SCP0083_DIOReport.cs:1307 | finally | UI_MISC | siCycle.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0083_DIOReport.SaveData_Main

진입점: SaveButton [if (this.spdMain.Visible)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a81e756 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:791 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b08f6f53 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:815 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-929f04c7 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:821 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-993fb2cf | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:822 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1060fcab | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:823 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-20eb418f | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:824 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d376793f | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:825 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-58ae56b5 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:826 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("VER") | 데이터 객체 조작/조회 |  |  |  |
| AC-d14a1a7f | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:827 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-089c3776 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:828 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("NICK_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-f8821eef | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:829 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PLANT_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-64ec9fd9 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:830 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("VERSION") | 데이터 객체 조작/조회 |  |  |  |
| AC-135bc914 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:831 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b76c3de | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:832 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("FROM_SITE_DESCRIPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-f73cb4bd | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:833 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("OPERATION_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-b240d80e | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:834 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-65a50286 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:835 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("TO_BOH_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-8da450d1 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:836 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("BOD_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-47a05073 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:837 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("TRANSPORT_MODE_LINE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3f6a06b | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:838 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-41449f09 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:839 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIP_PLAN_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-78d8abf7 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:840 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("END_CUSTOME") | 데이터 객체 조작/조회 |  |  |  |
| AC-42f4e6cf | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:841 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PRODUCTION_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7367b62d | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:842 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("EXTRA_SPEC") | 데이터 객체 조작/조회 |  |  |  |
| AC-95beb6dc | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:843 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0391f82 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:844 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("BIZ_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-234f341b | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:845 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-16808dc0 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:846 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("CELL_AGING_LT") | 데이터 객체 조작/조회 |  |  |  |
| AC-99ffcf55 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:847 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("CELL_EOL_SHIPPING_LOT") | 데이터 객체 조작/조회 |  |  |  |
| AC-497c6a26 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:848 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PACK_INCOMMIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-0288b34a | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:849 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PACK_OPERATION_LT") | 데이터 객체 조작/조회 |  |  |  |
| AC-5950f737 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:850 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_CELL_INSPECTION_LOAD") | 데이터 객체 조작/조회 |  |  |  |
| AC-e6de9a64 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:851 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_CELL_INSPECTION_WAITING") | 데이터 객체 조작/조회 |  |  |  |
| AC-5e51b1ad | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:852 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_PACK_INSPECTION_LOAD") | 데이터 객체 조작/조회 |  |  |  |
| AC-1fbe1b2d | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:853 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_PACK_INSPECTION_WAITING") | 데이터 객체 조작/조회 |  |  |  |
| AC-73a2353d | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:854 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_CELL_DEPARTURE_DAYS") | 데이터 객체 조작/조회 |  |  |  |
| AC-450d25dd | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:855 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_CELL_DEPARTURE_INLAND") | 데이터 객체 조작/조회 |  |  |  |
| AC-730f19c2 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:856 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_CELL_WAITING_FOR_SHIPPING") | 데이터 객체 조작/조회 |  |  |  |
| AC-62373665 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:857 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_CELL_VOYAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7f7e1298 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:858 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f8c7632 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:859 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_CELL_ARRIVAL_INLAND") | 데이터 객체 조작/조회 |  |  |  |
| AC-b54ba486 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:860 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_PACK_DEPARTURE_DAYS") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4c76d00 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:861 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_PACK_DEPARTURE_INLAND") | 데이터 객체 조작/조회 |  |  |  |
| AC-81971549 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:862 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_PACK_WAITING_FOR_SHIPPING") | 데이터 객체 조작/조회 |  |  |  |
| AC-a42c062a | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:863 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_PACK_VOYAGE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c12d325 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:864 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE") | 데이터 객체 조작/조회 |  |  |  |
| AC-87e5e8d5 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:865 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DNI_PACK_ARRIVAL_INLAND") | 데이터 객체 조작/조회 |  |  |  |
| AC-ff3e0940 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:866 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PRE_INSPECTION_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-4382092c | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:867 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PRE_INSPECTION_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e80f75c | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:868 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("VMI_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-5948b357 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:869 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("VMI_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-53c6ef1d | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:870 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("FOREIGN_CORP") | 데이터 객체 조작/조회 |  |  |  |
| AC-28b3c8b3 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:871 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("RACK_BIZ") | 데이터 객체 조작/조회 |  |  |  |
| AC-72753389 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:872 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DEPARTURE_INTRANSIT_VMI") | 데이터 객체 조작/조회 |  |  |  |
| AC-ca2b5421 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:873 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SAFETY_STOCK_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-9485dad6 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:874 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SAFETY_STOCK_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-9c1476c3 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:875 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("OTHER_STOCK_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-85e7d2a3 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:876 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("OTHER_STOCK_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-771a3628 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:877 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PRODUCTION_CYCLE_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-04a9cf31 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:878 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PRODUCTION_CYCLE_PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-61a3e5fc | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:879 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("STANDARD_DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-385ec08c | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:880 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ASSEMBLY_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-e004a499 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:881 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ASSEMBLY_TYPE_RATIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-e9b7822b | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:882 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ASSEMBLY_TOTAL_RATIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-74126bbf | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:883 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("WEIGHT_DIO") | 데이터 객체 조작/조회 |  |  |  |
| AC-e11424f3 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:884 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-db7b0f50 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:885 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-9534dcaa | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:886 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE3") | 데이터 객체 조작/조회 |  |  |  |
| AC-14fc2e34 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:887 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE4") | 데이터 객체 조작/조회 |  |  |  |
| AC-f1401e39 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:888 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE5") | 데이터 객체 조작/조회 |  |  |  |
| AC-20304abd | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:889 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE6") | 데이터 객체 조작/조회 |  |  |  |
| AC-42bc860f | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:890 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE7") | 데이터 객체 조작/조회 |  |  |  |
| AC-64c90f45 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:891 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE8") | 데이터 객체 조작/조회 |  |  |  |
| AC-94a8e0d8 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:892 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE9") | 데이터 객체 조작/조회 |  |  |  |
| AC-7011634c | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:893 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("ATTRIBUTE10") | 데이터 객체 조작/조회 |  |  |  |
| AC-7ad57bb2 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:894 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_CELL_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-93489be6 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:895 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_PACK_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-43d7714b | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:896 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("SHIPMENT_SUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-72037615 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:897 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9774e4e6 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:898 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("PROGRAM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f89b018e | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:899 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("DEBUG_MODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1021e8c3 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:901 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-dea08f36 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:919 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-8b80080a | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:920 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a8815359 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:921 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e51693ec | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:925 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-11ef21fb | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:927 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f27f3e3 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:928 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffd91492 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:943 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | ScpUtils.CheckNumberCellValueEmpty | (SHIPMENT_CELL_SUM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6078407 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:948 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | ScpUtils.CheckNumberCellValueEmpty | (SHIPMENT_CELL_SUM) | ⚠ 의미 확인 필요 |  |  |  |
| AC-34d07853 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:955 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5c7ce2d5 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:957 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ACTIVE_FLAG"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-a97037ab | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:958 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f6e421da | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:959 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PLAN_START_YYYYMMDD"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-47da2b52 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:960 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PLAN_TYPE"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-f625fc0b | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:961 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SEQ"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-d3de80fc | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:962 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["VER"] | GetParamVersion() | 행/컬럼 값 대입 |  |  |  |
| AC-93cbff92 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:963 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ITEM_ID"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-fa5c4ffa | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:963 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.ITEM_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-375678a8 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:964 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["NICK_NAME"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.NICK_NAME)) | 행/컬럼 값 대입 |  |  |  |
| AC-20e13f42 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:964 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.NICK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-679bbbe8 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:965 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PLANT_ID"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 행/컬럼 값 대입 |  |  |  |
| AC-35795ab6 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:965 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-41ba6060 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:966 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["VERSION"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.VERSION)) | 행/컬럼 값 대입 |  |  |  |
| AC-1e28207c | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:966 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.VERSION)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-756406a7 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:967 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["FROM_SITE"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.FROM_SITE)) | 행/컬럼 값 대입 |  |  |  |
| AC-350b5836 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:967 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.FROM_SITE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-344be4d8 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:982 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CELL_AGING_LT"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.CELL_AGING_LT)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-617ba948 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:983 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CELL_EOL_SHIPPING_LOT"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT)).Replace(",", ""… | 행/컬럼 값 대입 |  |  |  |
| AC-f6121173 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:984 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PACK_INCOMMIN"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PACK_INCOMMING)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-64b679d0 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:985 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PACK_OPERATION_LT"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-2b3154ff | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:986 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_CELL_INSPECTION_LOAD"] | SHIPMENT_CELL_INSPECTION_LOAD | 행/컬럼 값 대입 |  |  |  |
| AC-b51878b4 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:987 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_CELL_INSPECTION_WAITING"] | SHIPMENT_CELL_INSPECTION_WAITING | 행/컬럼 값 대입 |  |  |  |
| AC-f9624957 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:988 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_PACK_INSPECTION_LOAD"] | SHIPMENT_PACK_INSPECTION_LOAD | 행/컬럼 값 대입 |  |  |  |
| AC-64f39ed9 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:989 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_PACK_INSPECTION_WAITING"] | SHIPMENT_PACK_INSPECTION_WAITING | 행/컬럼 값 대입 |  |  |  |
| AC-2f0654d9 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1003 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PRE_INSPECTION_CELL"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4ef98ecd | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1004 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PRE_INSPECTION_PACK"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-1b98d4e1 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1005 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["VMI_CELL"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.VMI_CELL)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-8bd81f95 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1006 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["VMI_PACK"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.VMI_PACK)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-5590a96b | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1007 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["FOREIGN_CORP"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.FOREIGN_CORP)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-aaf74b4f | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1008 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["RACK_BIZ"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.RACK_BIZ)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-b78ee54a | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1009 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DEPARTURE_INTRANSIT_VMI"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.DEPARTURE_INTRANSIT_VMI_AUTO)).Replace(… | 행/컬럼 값 대입 |  |  |  |
| AC-4dbb3022 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1010 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SAFETY_STOCK_CELL"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-75721831 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1011 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SAFETY_STOCK_PACK"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-c69845f8 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1012 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["OTHER_STOCK_CELL"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.OTHER_STOCK_CELL)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-3931ea07 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1013 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["OTHER_STOCK_PACK"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.OTHER_STOCK_PACK)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-7f0dbad4 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1014 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PRODUCTION_CYCLE_CELL"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL)).Replace(",", ""… | 행/컬럼 값 대입 |  |  |  |
| AC-92c2f542 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1015 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PRODUCTION_CYCLE_PACK"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK)).Replace(",", ""… | 행/컬럼 값 대입 |  |  |  |
| AC-211851d0 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1016 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["STANDARD_DIO"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.STANDARD_DIO_AUTO)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-569d544c | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1017 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ASSEMBLY_QTY"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ASSEMBLY_QTY)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-87f92d19 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1018 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ASSEMBLY_TYPE_RATIO"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ASSEMBLY_TYPE_RATIO)).Replace(",", "").… | 행/컬럼 값 대입 |  |  |  |
| AC-9ad6c1d0 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1019 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ASSEMBLY_TOTAL_RATIO"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.ASSEMBLY_TOTAL_RATIO)).Replace(",", "")… | 행/컬럼 값 대입 |  |  |  |
| AC-c9a032d2 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1020 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["WEIGHT_DIO"] | siMain.GetText(i, siMain.GetColumnIndex(DefColumns.WEIGHT_DIO_AUTO)).Replace(",", "") | 행/컬럼 값 대입 |  |  |  |
| AC-8f248b0d | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1023 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_CELL_SUM"] | SHIPMENT_CELL_SUM | 행/컬럼 값 대입 |  |  |  |
| AC-a1b873d0 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1024 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_PACK_SUM"] | SHIPMENT_PACK_SUM | 행/컬럼 값 대입 |  |  |  |
| AC-a0168d15 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1025 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SHIPMENT_SUM"] | SHIPMENT_SUM | 행/컬럼 값 대입 |  |  |  |
| AC-a9983827 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1027 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b6674817 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1028 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROGRAM_ID"] | "SCP0083" | 행/컬럼 값 대입 |  |  |  |
| AC-6859d2b2 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1029 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["DEBUG_MODE"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-add1a427 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1031 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ATTRIBUTE1"] | siMain.GetValue2(i, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE)) | 행/컬럼 값 대입 |  |  |  |
| AC-79999723 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1031 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-507967d2 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1032 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3cba1de | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1036 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8d36af13 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1044 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1d35261e | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1054 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0083", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58f7bdb5 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1055 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveDioReport") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveDioReport] \| SCP\R… | 엔드포인트 호출 |  |  |  |
| AC-6dace15e | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1058 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3bdb978 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1063 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f8131af | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1072 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f1ebc0c7 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1081 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-afbae61a | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1083 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7efcb1b7 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1089 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fe408528 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1099 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e4da1771 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1100 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20242f14 | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1104 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8d95d06d | SaveButton [if (this.spdMain.Visible)] | SCP0083_DIOReport.cs:1105 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0083_DIOReport.SCM_SYS_LOG_BATCH

진입점: SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0542b0fa | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2808 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-8e7b52f3 | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2809 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-48b74c14 | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2810 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-6df35b98 | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2811 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-03edccdb | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2812 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-7cde6be6 | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2813 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-f75ae7fa | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2814 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-dbaaf59c | SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name =… | SCP0083_DIOReport.cs:2816 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0083_DIOReport.Set_BtnCreateVisible

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlan.SelectedIndexChanged / cboVersion.SelectedIndexChanged / btnVersionCreate.Click [try] / btnVersionDelete.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-115e11b6 | this.Load 외 5 | SCP0083_DIOReport.cs:2394 | if (dtPlan.Rows[cboPlan.SelectedIndex][2].ToString() == "Y") | STATE | btnVersionCreate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-f8c39a26 | this.Load 외 5 | SCP0083_DIOReport.cs:2395 | if (dtPlan.Rows[cboPlan.SelectedIndex][2].ToString() == "Y") | STATE | txtRange.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4644275f | this.Load 외 5 | SCP0083_DIOReport.cs:2399 | else of (dtPlan.Rows[cboPlan.SelectedIndex][2].ToString() == "Y") | STATE | btnVersionCreate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7d284908 | this.Load 외 5 | SCP0083_DIOReport.cs:2400 | else of (dtPlan.Rows[cboPlan.SelectedIndex][2].ToString() == "Y") | STATE | txtRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2e668b27 | this.Load 외 5 | SCP0083_DIOReport.cs:2405 | if (GetParamVersionType() == "N") | STATE | btnVersionCreate.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-55b53953 | this.Load 외 5 | SCP0083_DIOReport.cs:2406 | if (GetParamVersionType() == "N") | STATE | txtRange.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-328326cc | this.Load 외 5 | SCP0083_DIOReport.cs:2410 | else of (GetParamVersionType() == "N") | STATE | btnVersionCreate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-46a37029 | this.Load 외 5 | SCP0083_DIOReport.cs:2411 | else of (GetParamVersionType() == "N") | STATE | txtRange.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0083_DIOReport.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7c71562 | this.Load 외 1 | SCP0083_DIOReport.cs:2376 |  | FLAG | dtPlan | GetPlanCombo() | 화면 필드/플래그 변경 |  |  |  |
| AC-78693755 | this.Load 외 1 | SCP0083_DIOReport.cs:2377 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlan, cboPlan, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0083_DIOReport.SetComboVersion

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlan.SelectedIndexChanged / btnVersionCreate.Click [try] / btnVersionDelete.Click [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46d4a9ca | this.Load 외 4 | SCP0083_DIOReport.cs:2341 |  | FLAG | dtVersion | GetVersionCombo() | 화면 필드/플래그 변경 |  |  |  |
| AC-6da4d9b2 | this.Load 외 4 | SCP0083_DIOReport.cs:2342 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cboVersion, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-90a2ad58 | this.Load 외 4 | SCP0083_DIOReport.cs:2355 | if (ScpUtils.CheckDataEmpty(dtVersion) == false) ▸ foreach (DataRow row in dtVersion.Rows) | DATA_OP | verType.Contains | ("-") | 데이터 객체 조작/조회 |  |  |  |
| AC-4962e259 | this.Load 외 4 | SCP0083_DIOReport.cs:2364 | if (ScpUtils.CheckDataEmpty(dtVersion) == false) ▸ foreach (DataRow row in dtVersion.Rows) ▸ if (ScpUtils.CheckDataEmpty(verType) == false &… | VALUE_SET | cboVersion.ControlValues | ver | 컨트롤 값 설정 |  |  |  |

## SCP0083_DIOReport.SetDetailSetting

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88cfa042 | (진입점 미연결) | SCP0083_DIOReport.cs:2694 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0f3418ad | (진입점 미연결) | SCP0083_DIOReport.cs:2697 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-768929c4 | (진입점 미연결) | SCP0083_DIOReport.cs:2699 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_DAYS), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b06ff61 | (진입점 미연결) | SCP0083_DIOReport.cs:2700 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_INLAND), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0541cf70 | (진입점 미연결) | SCP0083_DIOReport.cs:2701 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_WAITING_FOR_SHIPPING), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c2ae7dff | (진입점 미연결) | SCP0083_DIOReport.cs:2702 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_VOYAGE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7bee2ba9 | (진입점 미연결) | SCP0083_DIOReport.cs:2703 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dde48035 | (진입점 미연결) | SCP0083_DIOReport.cs:2704 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_ARRIVAL_INLAND), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9cdbff79 | (진입점 미연결) | SCP0083_DIOReport.cs:2706 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_DAYS), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d6da0519 | (진입점 미연결) | SCP0083_DIOReport.cs:2707 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_INLAND), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-662f54b4 | (진입점 미연결) | SCP0083_DIOReport.cs:2708 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_WAITING_FOR_SHIPPING), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68093177 | (진입점 미연결) | SCP0083_DIOReport.cs:2709 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_VOYAGE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-64906335 | (진입점 미연결) | SCP0083_DIOReport.cs:2710 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b4545b82 | (진입점 미연결) | SCP0083_DIOReport.cs:2711 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_ARRIVAL_INLAND), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c6e8fa48 | (진입점 미연결) | SCP0083_DIOReport.cs:2715 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_AGING_LT), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3bdbaf3f | (진입점 미연결) | SCP0083_DIOReport.cs:2716 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-179640df | (진입점 미연결) | SCP0083_DIOReport.cs:2717 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_INCOMMING), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d536be75 | (진입점 미연결) | SCP0083_DIOReport.cs:2718 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c063afa | (진입점 미연결) | SCP0083_DIOReport.cs:2719 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1ee6fbd1 | (진입점 미연결) | SCP0083_DIOReport.cs:2720 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3b751ca4 | (진입점 미연결) | SCP0083_DIOReport.cs:2722 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_DAYS_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9f8b0276 | (진입점 미연결) | SCP0083_DIOReport.cs:2723 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_INLAND_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-85b9ef93 | (진입점 미연결) | SCP0083_DIOReport.cs:2724 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_WAITING_FOR_SHIPPING_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00eb9e96 | (진입점 미연결) | SCP0083_DIOReport.cs:2725 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_VOYAGE_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9f3c4083 | (진입점 미연결) | SCP0083_DIOReport.cs:2726 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e1f3754d | (진입점 미연결) | SCP0083_DIOReport.cs:2727 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_ARRIVAL_INLAND_SUM), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a7c5e999 | (진입점 미연결) | SCP0083_DIOReport.cs:2730 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-205090c3 | (진입점 미연결) | SCP0083_DIOReport.cs:2731 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-621d72e9 | (진입점 미연결) | SCP0083_DIOReport.cs:2734 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f80e0c6b | (진입점 미연결) | SCP0083_DIOReport.cs:2735 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-164000e2 | (진입점 미연결) | SCP0083_DIOReport.cs:2736 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-383225b8 | (진입점 미연결) | SCP0083_DIOReport.cs:2739 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f74b988d | (진입점 미연결) | SCP0083_DIOReport.cs:2740 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-94660686 | (진입점 미연결) | SCP0083_DIOReport.cs:2748 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3dbb3d8e | (진입점 미연결) | SCP0083_DIOReport.cs:2751 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-295dbdc5 | (진입점 미연결) | SCP0083_DIOReport.cs:2753 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_DAYS), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3b02672c | (진입점 미연결) | SCP0083_DIOReport.cs:2754 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_INLAND), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31885119 | (진입점 미연결) | SCP0083_DIOReport.cs:2755 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_WAITING_FOR_SHIPPING), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a8967c3 | (진입점 미연결) | SCP0083_DIOReport.cs:2756 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_VOYAGE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ca488e88 | (진입점 미연결) | SCP0083_DIOReport.cs:2757 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fab852a6 | (진입점 미연결) | SCP0083_DIOReport.cs:2758 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_ARRIVAL_INLAND), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-926a0367 | (진입점 미연결) | SCP0083_DIOReport.cs:2760 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_DAYS), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9f23a48a | (진입점 미연결) | SCP0083_DIOReport.cs:2761 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_INLAND), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-348668e4 | (진입점 미연결) | SCP0083_DIOReport.cs:2762 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_WAITING_FOR_SHIPPING), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aa4aa750 | (진입점 미연결) | SCP0083_DIOReport.cs:2763 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_VOYAGE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-681349a2 | (진입점 미연결) | SCP0083_DIOReport.cs:2764 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d5fa4522 | (진입점 미연결) | SCP0083_DIOReport.cs:2765 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_ARRIVAL_INLAND), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e2ca000 | (진입점 미연결) | SCP0083_DIOReport.cs:2769 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_AGING_LT), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8835578b | (진입점 미연결) | SCP0083_DIOReport.cs:2770 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec08843c | (진입점 미연결) | SCP0083_DIOReport.cs:2771 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_INCOMMING), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-816516d1 | (진입점 미연결) | SCP0083_DIOReport.cs:2772 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c6f594a6 | (진입점 미연결) | SCP0083_DIOReport.cs:2773 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-16491b59 | (진입점 미연결) | SCP0083_DIOReport.cs:2774 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c22cec93 | (진입점 미연결) | SCP0083_DIOReport.cs:2776 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_DAYS_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da23ee34 | (진입점 미연결) | SCP0083_DIOReport.cs:2777 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_INLAND_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2fd8ec3 | (진입점 미연결) | SCP0083_DIOReport.cs:2778 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_WAITING_FOR_SHIPPING_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da592356 | (진입점 미연결) | SCP0083_DIOReport.cs:2779 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_VOYAGE_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a9bbffd9 | (진입점 미연결) | SCP0083_DIOReport.cs:2780 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1f841850 | (진입점 미연결) | SCP0083_DIOReport.cs:2781 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_ARRIVAL_INLAND_SUM), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3a9cbce7 | (진입점 미연결) | SCP0083_DIOReport.cs:2784 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7245d731 | (진입점 미연결) | SCP0083_DIOReport.cs:2785 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8c742065 | (진입점 미연결) | SCP0083_DIOReport.cs:2788 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-47637ab8 | (진입점 미연결) | SCP0083_DIOReport.cs:2789 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-db28c126 | (진입점 미연결) | SCP0083_DIOReport.cs:2790 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a581a890 | (진입점 미연결) | SCP0083_DIOReport.cs:2793 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-29f51ff6 | (진입점 미연결) | SCP0083_DIOReport.cs:2794 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (chkDetail.Checked) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReport.SetDioAssemblyQty

진입점: btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdCycle.Visible) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (this.spdCycle.Visible) ▸ try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (ds.Tables[0].Rows.Count …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db0ed3ac | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2592 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b43ca1d4 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2633 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) | DATA_OP | dt.Select | (exfilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-8a649d45 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2640 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ca994a66 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2641 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-95fbedd8 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2642 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4cb8fede | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2643 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.SEQ)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aba589c2 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2644 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.NICK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aae9c947 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2646 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-90a8467a | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2657 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ foreach (DataRow row in dtCycle.Rows) ▸ if (rows.Length > 0) ▸ for (i <… | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.ASSEMBLY_QTY), global_model_sum.ToString()) | 그리드 값 설정 |  |  |  |
| AC-bb5b3559 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2669 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0083_DIOReport.SetDioCycleStock

진입점: this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount)] / this.spdCycle.ClipboardPasted [else of (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount)] / this.spdCycle.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d56d16d4 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2449 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f68be1b1 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2450 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1fd710f1 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2451 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.PLAN_TYPE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e874ec15 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2452 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.SEQ)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-09b067b0 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2453 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.NICK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62aa2bdb | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2455 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7a0d5734 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2456 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.OPERATION_GROUP)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c86de83a | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2462 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) | CALL_EXT | siCycle.GetValue2 | (idx, siCycle.GetColumnIndex(DefColumns.GLOBAL_SITE_RATIO)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-47256620 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2483 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iCol_DIVISION_ID_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-480af164 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2484 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iCol_PLAN_START_YYYYMMDD_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-30b799b2 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2485 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iColPLAN_TYPE_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ebdeeccb | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2486 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iCol_SEQ_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55e33ae0 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2487 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iCol_NICK_NAME_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-44b78460 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2489 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iCol_PLANT_ID_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-21f3ed4c | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2490 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ for (i < siCycle.ActiveSheet.RowCount) | CALL_EXT | siCycle.GetValue2 | (i, iCol_OPERATION_GROUP_CYCLE) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b6fc35a | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2512 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ if (ds == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ea0bae45 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2531 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try | DATA_OP | dt.Select | (exfilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-721fd4d7 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2533 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ if (rows.Length == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-05a8b1d6 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2538 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.DIVISION_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-14d9220b | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2539 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8be8851f | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2540 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-115e83ca | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2541 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.SEQ)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf298b15 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2542 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.NICK_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0592d13 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2544 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | siMain.GetValue2 | (i, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ba8885a | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2553 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (division_id.Equals(division… | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL), t_weight_cycle_stock.ToString… | 그리드 값 설정 |  |  |  |
| AC-8ff6e125 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2554 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (division_id.Equals(division… | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.ASSEMBLY_QTY), global_model_sum) | 그리드 값 설정 |  |  |  |
| AC-a964d5c5 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2560 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (division_id.Equals(division… | GRID_SET | siMain.SetText | (i, siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK), t_weight_cycle_stock.ToString… | 그리드 값 설정 |  |  |  |
| AC-c54cb4d5 | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2566 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ try ▸ for (i < siMain.ActiveSheet.RowCount) ▸ if (chkcnt == rows.Length) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b1e337b | this.spdMain.ClipboardPasted [else of (p.ActiveSheet.SheetNa… 외 2 | SCP0083_DIOReport.cs:2571 | if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0083_DIOReport.SetGridDefault

진입점: EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14aeadcc | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:481 | for (i <= si.GetMaxRowIndex()) ▸ for (j < si.ActiveSheet.ColumnCount) | GRID_SET | si.ActiveSheet.Cells[i, j].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-2a04447c | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:482 | for (i <= si.GetMaxRowIndex()) ▸ for (j < si.ActiveSheet.ColumnCount) | GRID_STYLE | si.SetBGColor | (i, j, i, j, ControlColor.DefaultBackColor) | 그리드 표시 설정 |  |  |  |
| AC-b1927218 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:483 | for (i <= si.GetMaxRowIndex()) ▸ for (j < si.ActiveSheet.ColumnCount) | GRID_STYLE | si.SetForeColor | (i, j, i, j, ControlColor.DefaultBackColor, false) | 그리드 표시 설정 |  |  |  |

## SCP0083_DIOReport.SetLayout

진입점: this.Load / cboDivision.SelectedIndexChanged / btnVersionCreate.Click [try ▸ try] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try] / chkDetail.CheckedChanged / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode == false) ▸ try] / SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccd049de | this.Load 외 7 | SCP0083_DIOReport.cs:1821 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), SetLayoutShow(DefColumns.FROM_SI… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-55a6f3a5 | this.Load 외 7 | SCP0083_DIOReport.cs:1822 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), SetLayoutShow(DefColumns.END_CUSTOMER, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e439d8f9 | this.Load 외 7 | SCP0083_DIOReport.cs:1823 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), SetLayoutShow(DefColumns.PRODUCTION_TY… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-debddb0e | this.Load 외 7 | SCP0083_DIOReport.cs:1824 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), SetLayoutShow(DefColumns.EXTRA_SPEC, isDeta… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7193af7f | this.Load 외 7 | SCP0083_DIOReport.cs:1825 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.NICK_NAME), SetLayoutShow(DefColumns.NICK_NAME, isDetail… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3a934cb5 | this.Load 외 7 | SCP0083_DIOReport.cs:1826 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.ITEM_ID), SetLayoutShow(DefColumns.ITEM_ID, isDetail, p_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ec7618bb | this.Load 외 7 | SCP0083_DIOReport.cs:1827 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), SetLayoutShow(DefColumns.CELL_ITEM_ID, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf92e262 | this.Load 외 7 | SCP0083_DIOReport.cs:1828 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.BIZ_TYPE), SetLayoutShow(DefColumns.BIZ_TYPE, isDetail, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7a14b73 | this.Load 외 7 | SCP0083_DIOReport.cs:1829 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.INCOTERMS), SetLayoutShow(DefColumns.INCOTERMS, isDetail… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e0fde0b6 | this.Load 외 7 | SCP0083_DIOReport.cs:1830 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_AGING_LT), SetLayoutShow(DefColumns.CELL_AGING_LT, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-13c8b4d2 | this.Load 외 7 | SCP0083_DIOReport.cs:1831 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_EOL_SHIPPING_LOT), SetLayoutShow(DefColumns.CELL_EO… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40030b9e | this.Load 외 7 | SCP0083_DIOReport.cs:1832 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_SUM), SetLayoutShow(DefColumns.CELL_SUM, isDetail, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-100d2017 | this.Load 외 7 | SCP0083_DIOReport.cs:1833 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_INCOMMING), SetLayoutShow(DefColumns.PACK_INCOMMING… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-de08e78e | this.Load 외 7 | SCP0083_DIOReport.cs:1834 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_OPERATION_LT), SetLayoutShow(DefColumns.PACK_OPERAT… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-900dcfef | this.Load 외 7 | SCP0083_DIOReport.cs:1835 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PACK_SUM), SetLayoutShow(DefColumns.PACK_SUM, isDetail, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6b8f3a9 | this.Load 외 7 | SCP0083_DIOReport.cs:1836 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM), SetLayoutShow(DefColumns.SHIPMENT_CE… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b3b10a4 | this.Load 외 7 | SCP0083_DIOReport.cs:1837 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_PACK_SUM), SetLayoutShow(DefColumns.SHIPMENT_PA… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3a1d0daf | this.Load 외 7 | SCP0083_DIOReport.cs:1838 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SHIPMENT_SUM), SetLayoutShow(DefColumns.SHIPMENT_SUM, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-531135f6 | this.Load 외 7 | SCP0083_DIOReport.cs:1839 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_DAYS), SetLayoutShow(DefColumns.DNI_C… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3ed6fd75 | this.Load 외 7 | SCP0083_DIOReport.cs:1840 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_DEPARTURE_INLAND), SetLayoutShow(DefColumns.DNI… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d0b98c49 | this.Load 외 7 | SCP0083_DIOReport.cs:1841 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_WAITING_FOR_SHIPPING), SetLayoutShow(DefColumns… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-890a5fd5 | this.Load 외 7 | SCP0083_DIOReport.cs:1842 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_VOYAGE), SetLayoutShow(DefColumns.DNI_CELL_VOYA… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c32f1cf6 | this.Load 외 7 | SCP0083_DIOReport.cs:1843 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_LAY_OFF_CUSTOMS_CLEARANCE), SetLayoutShow(DefCo… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5ba8d6cf | this.Load 외 7 | SCP0083_DIOReport.cs:1844 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_ARRIVAL_INLAND), SetLayoutShow(DefColumns.DNI_C… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5f79c497 | this.Load 외 7 | SCP0083_DIOReport.cs:1845 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_CELL_SUM), SetLayoutShow(DefColumns.DNI_CELL_SUM, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fda48c23 | this.Load 외 7 | SCP0083_DIOReport.cs:1846 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_DAYS), SetLayoutShow(DefColumns.DNI_P… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-75195c08 | this.Load 외 7 | SCP0083_DIOReport.cs:1847 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_DEPARTURE_INLAND), SetLayoutShow(DefColumns.DNI… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f2a5901f | this.Load 외 7 | SCP0083_DIOReport.cs:1848 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_WAITING_FOR_SHIPPING), SetLayoutShow(DefColumns… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8e798510 | this.Load 외 7 | SCP0083_DIOReport.cs:1849 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_VOYAGE), SetLayoutShow(DefColumns.DNI_PACK_VOYA… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e489dfe8 | this.Load 외 7 | SCP0083_DIOReport.cs:1850 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_LAY_OFF_CUSTOMS_CLEARANCE), SetLayoutShow(DefCo… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-88937808 | this.Load 외 7 | SCP0083_DIOReport.cs:1851 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_ARRIVAL_INLAND), SetLayoutShow(DefColumns.DNI_P… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-19dcded3 | this.Load 외 7 | SCP0083_DIOReport.cs:1852 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_PACK_SUM), SetLayoutShow(DefColumns.DNI_PACK_SUM, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-38d6f74f | this.Load 외 7 | SCP0083_DIOReport.cs:1853 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_DAYS_SUM), SetLayoutShow(DefColumns.DNI_DE… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-94c7e1ec | this.Load 외 7 | SCP0083_DIOReport.cs:1854 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_DEPARTURE_INLAND_SUM), SetLayoutShow(DefColumns.DNI_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df901fc6 | this.Load 외 7 | SCP0083_DIOReport.cs:1855 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_WAITING_FOR_SHIPPING_SUM), SetLayoutShow(DefColumns.… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-90541825 | this.Load 외 7 | SCP0083_DIOReport.cs:1856 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_VOYAGE_SUM), SetLayoutShow(DefColumns.DNI_VOYAGE_SUM… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-88a13bd9 | this.Load 외 7 | SCP0083_DIOReport.cs:1857 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_LAY_OFF_CUSTOMS_CLEARANCE_SUM), SetLayoutShow(DefCol… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4e92fa11 | this.Load 외 7 | SCP0083_DIOReport.cs:1858 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_ARRIVAL_INLAND_SUM), SetLayoutShow(DefColumns.DNI_AR… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bebbad86 | this.Load 외 7 | SCP0083_DIOReport.cs:1859 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.DNI_SUM), SetLayoutShow(DefColumns.DNI_SUM, isDetail, p_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fd2fcb88 | this.Load 외 7 | SCP0083_DIOReport.cs:1860 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_CELL), SetLayoutShow(DefColumns.PRE_INSPE… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-43503b5d | this.Load 외 7 | SCP0083_DIOReport.cs:1861 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_PACK), SetLayoutShow(DefColumns.PRE_INSPE… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3e4ea1fd | this.Load 외 7 | SCP0083_DIOReport.cs:1862 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRE_INSPECTION_SUM), SetLayoutShow(DefColumns.PRE_INSPEC… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-650f6dbe | this.Load 외 7 | SCP0083_DIOReport.cs:1863 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.VMI_CELL), SetLayoutShow(DefColumns.VMI_CELL, isDetail, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0325442b | this.Load 외 7 | SCP0083_DIOReport.cs:1864 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.VMI_PACK), SetLayoutShow(DefColumns.VMI_PACK, isDetail, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0c1f45c1 | this.Load 외 7 | SCP0083_DIOReport.cs:1865 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.VMI_SUM), SetLayoutShow(DefColumns.VMI_SUM, isDetail, p_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-00f67aee | this.Load 외 7 | SCP0083_DIOReport.cs:1866 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.FOREIGN_CORP), SetLayoutShow(DefColumns.FOREIGN_CORP, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-84673f9f | this.Load 외 7 | SCP0083_DIOReport.cs:1867 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.RACK_BIZ), SetLayoutShow(DefColumns.RACK_BIZ, isDetail, … | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bb2c3d7a | this.Load 외 7 | SCP0083_DIOReport.cs:1868 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_CELL), SetLayoutShow(DefColumns.SAFETY_STOC… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d8db1a60 | this.Load 외 7 | SCP0083_DIOReport.cs:1869 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PACK), SetLayoutShow(DefColumns.SAFETY_STOC… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cae1651f | this.Load 외 7 | SCP0083_DIOReport.cs:1870 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_PIN_HOUSE), SetLayoutShow(DefColumns.SAFETY… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9f41bc9 | this.Load 외 7 | SCP0083_DIOReport.cs:1871 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.SAFETY_STOCK_SUM), SetLayoutShow(DefColumns.SAFETY_STOCK… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-744de6c7 | this.Load 외 7 | SCP0083_DIOReport.cs:1872 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.OTHER_STOCK_CELL), SetLayoutShow(DefColumns.OTHER_STOCK_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-caf6e1bb | this.Load 외 7 | SCP0083_DIOReport.cs:1873 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.OTHER_STOCK_PACK), SetLayoutShow(DefColumns.OTHER_STOCK_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c18447a | this.Load 외 7 | SCP0083_DIOReport.cs:1874 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.OTHER_STOCK_SUM), SetLayoutShow(DefColumns.OTHER_STOCK_S… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-edec9ad8 | this.Load 외 7 | SCP0083_DIOReport.cs:1875 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_CELL), SetLayoutShow(DefColumns.PRODUCT… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b4212320 | this.Load 외 7 | SCP0083_DIOReport.cs:1876 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_PACK), SetLayoutShow(DefColumns.PRODUCT… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d79e0dbc | this.Load 외 7 | SCP0083_DIOReport.cs:1877 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_CYCLE_SUM), SetLayoutShow(DefColumns.PRODUCTI… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f6270a74 | this.Load 외 7 | SCP0083_DIOReport.cs:1878 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.STANDARD_DIO_AUTO), SetLayoutShow(DefColumns.STANDARD_DI… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9039a25 | this.Load 외 7 | SCP0083_DIOReport.cs:1879 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.ASSEMBLY_QTY), SetLayoutShow(DefColumns.ASSEMBLY_QTY, is… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-271a26e8 | this.Load 외 7 | SCP0083_DIOReport.cs:1880 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.ASSEMBLY_TYPE_RATIO), SetLayoutShow(DefColumns.ASSEMBLY_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2bbdef0f | this.Load 외 7 | SCP0083_DIOReport.cs:1881 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.ASSEMBLY_TOTAL_RATIO), SetLayoutShow(DefColumns.ASSEMBLY… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9648967 | this.Load 외 7 | SCP0083_DIOReport.cs:1882 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_DIO_AUTO), SetLayoutShow(DefColumns.WEIGHT_DIO_AU… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-672fff2d | this.Load 외 7 | SCP0083_DIOReport.cs:1883 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.OP_LT_TOTAL_AUTO), SetLayoutShow(DefColumns.OP_LT_TOTAL_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-02aacba0 | this.Load 외 7 | SCP0083_DIOReport.cs:1884 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CYCLE_TOTAL_AUTO), SetLayoutShow(DefColumns.CYCLE_TOTAL_… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-debd0be4 | this.Load 외 7 | SCP0083_DIOReport.cs:1885 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.INTRANSIT_TOTAL_AUTO), SetLayoutShow(DefColumns.INTRANSI… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-31959882 | this.Load 외 7 | SCP0083_DIOReport.cs:1886 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_OPEARTION_TYPE_AUTO), SetLayoutShow(DefColumns.WE… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4a6bea52 | this.Load 외 7 | SCP0083_DIOReport.cs:1887 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_OPEARTION_TOTAL_AUTO), SetLayoutShow(DefColumns.W… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cce8cebb | this.Load 외 7 | SCP0083_DIOReport.cs:1888 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_CYCLE_TYPE_AUTO), SetLayoutShow(DefColumns.WEIGHT… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4f52c9b0 | this.Load 외 7 | SCP0083_DIOReport.cs:1889 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_CYCLE_TOTAL_AUTO), SetLayoutShow(DefColumns.WEIGH… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-56402d43 | this.Load 외 7 | SCP0083_DIOReport.cs:1890 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_INTRANSIT_TYPE_AUTO), SetLayoutShow(DefColumns.WE… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-44c3ec26 | this.Load 외 7 | SCP0083_DIOReport.cs:1891 | try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.WEIGHT_INTRANSIT_TOTAL_AUTO), SetLayoutShow(DefColumns.W… | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb12e1b9 | this.Load 외 7 | SCP0083_DIOReport.cs:1898 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.NICK_NAME), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a337d891 | this.Load 외 7 | SCP0083_DIOReport.cs:1899 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.ITEM_ID), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b984d631 | this.Load 외 7 | SCP0083_DIOReport.cs:1900 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.MODEL_AVG), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-60cb451e | this.Load 외 7 | SCP0083_DIOReport.cs:1901 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.EXTRA_SPEC), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-44ac2064 | this.Load 외 7 | SCP0083_DIOReport.cs:1902 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.PACK_GROUP), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-065f2cba | this.Load 외 7 | SCP0083_DIOReport.cs:1903 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CELL_GROUP), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-756ddd17 | this.Load 외 7 | SCP0083_DIOReport.cs:1904 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CELL_TYPE_GROUP_CODE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ff2946d | this.Load 외 7 | SCP0083_DIOReport.cs:1905 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5fd2a11d | this.Load 외 7 | SCP0083_DIOReport.cs:1906 | try ▸ if (p_division_id.Equals("81")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CYCLE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-766a5214 | this.Load 외 7 | SCP0083_DIOReport.cs:1911 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.NICK_NAME), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-26c882ab | this.Load 외 7 | SCP0083_DIOReport.cs:1912 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.ITEM_ID), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7bb6fbf0 | this.Load 외 7 | SCP0083_DIOReport.cs:1913 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.MODEL_AVG), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-730fc8c5 | this.Load 외 7 | SCP0083_DIOReport.cs:1914 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.EXTRA_SPEC), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2bb4b4f3 | this.Load 외 7 | SCP0083_DIOReport.cs:1915 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.PACK_GROUP), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-90f1b755 | this.Load 외 7 | SCP0083_DIOReport.cs:1916 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CELL_GROUP), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ca2988c1 | this.Load 외 7 | SCP0083_DIOReport.cs:1917 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CELL_TYPE_GROUP_CODE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0b97b7e | this.Load 외 7 | SCP0083_DIOReport.cs:1918 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-94f537a9 | this.Load 외 7 | SCP0083_DIOReport.cs:1919 | try ▸ else of (p_division_id.Equals("81")) ▸ if (p_division_id.Equals("40")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CYCLE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f159e761 | this.Load 외 7 | SCP0083_DIOReport.cs:1925 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.NICK_NAME), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5c49a6c4 | this.Load 외 7 | SCP0083_DIOReport.cs:1926 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.ITEM_ID), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0f21df83 | this.Load 외 7 | SCP0083_DIOReport.cs:1927 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.MODEL_AVG), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-46165fe2 | this.Load 외 7 | SCP0083_DIOReport.cs:1928 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.EXTRA_SPEC), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-898f91c9 | this.Load 외 7 | SCP0083_DIOReport.cs:1929 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.PACK_GROUP), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fe3348e9 | this.Load 외 7 | SCP0083_DIOReport.cs:1930 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CELL_GROUP), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-72380e86 | this.Load 외 7 | SCP0083_DIOReport.cs:1931 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CELL_TYPE_GROUP_CODE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9012f40c | this.Load 외 7 | SCP0083_DIOReport.cs:1932 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.PRIVATE_FLAG), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a3f8edf8 | this.Load 외 7 | SCP0083_DIOReport.cs:1933 | try ▸ else of (p_division_id.Equals("81")) ▸ else of (p_division_id.Equals("40")) ▸ if (p_division_id.Equals("82")) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(DefColumns.CYCLE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReport.SetLayoutShow

진입점: this.Load [try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))] / cboDivision.SelectedIndexChanged [try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))] / btnVersionCreate.Click [try ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))] / chkDetail.CheckedChanged [try ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))] / FindButton [if (this.spdMain.Visible) ▸ try ▸ try ▸ if (siMain.Acti…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a34e1576 | this.Load [try ▸ if (siMain.ActiveSheet.SheetName.Equals(Spd… 외 7 | SCP0083_DIOReport.cs:2073 |  | RETURN | return show; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReport.SetLoadSpreadColumn

진입점: this.Load [if (sheetName.Equals(SpdSheet.shtMain))] / btnVersionCreate.Click [try ▸ try ▸ if (sheetName.Equals(SpdSheet.shtMain))] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtMain))] / FindButton [if (this.spdMain.Visible) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtMain))] / EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode == false) ▸ try ▸ if (sheetName.Equals(SpdSheet.shtMain))] / SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain"…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49e38f6f | this.Load [if (sheetName.Equals(SpdSheet.shtMain))] 외 5 | SCP0083_DIOReport.cs:2137 | for (j < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[j].Font | new System.Drawing.Font("굴림", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUn… | 그리드 속성/값 설정 |  |  |  |

## SCP0083_DIOReport.SetLockSumColumn

진입점: EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b12d8dc | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:2108 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("_SUM") > 0 \|\| (spreadInfo.GetColumnTag(iCol).… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5ca1c224 | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:2121 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).Equals(DefColumns.SHIPMENT_CELL_SUM) \|\| spreadInfo.Get… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7cf25f2e | EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSh… | SCP0083_DIOReport.cs:2125 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).Equals(DefColumns.SHIPMENT_CELL_SUM) \|\| spreadInfo.Get… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0083_DIOReport.SetRange

진입점: cboVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be57a328 | cboVersion.SelectedIndexChanged | SCP0083_DIOReport.cs:2678 |  | VALUE_SET | txtRange.Text | GetParamVersionRange() | 컨트롤 값 설정 |  |  |  |

## SCP0083_DIOReport.SetSpreadColumn

진입점: btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdMain.Visible) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (fps.ActiveSheet.Columns.Get(xCol1).Visible == false)] / SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21ec725e | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2145 |  | FLAG | isEditAfter | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3d87fbe5 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2223 | if (isEditAfter) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < colEnd) ▸ switch (colTag) case "CELL_SUM": case "PACK_SUM": case "SHIPME… | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | DefGridColor.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-d3364e04 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2230 | if (isEditAfter) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < colEnd) ▸ switch (colTag) case "DNI_CELL_SUM": case "DNI_PACK_SUM": | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | DefGridColor.Honeydew | 그리드 속성/값 설정 |  |  |  |
| AC-0b3029d3 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2236 | if (isEditAfter) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < colEnd) ▸ switch (colTag) case "STANDARD_DIO_AUTO": | GRID_SET | siMain.ActiveSheet.Cells[i, j].BackColor | DefGridColor.MistyRose | 그리드 속성/값 설정 |  |  |  |
| AC-8eecf21b | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2258 | if (isEditAfter) ▸ for (i < siMain.ActiveSheet.RowCount) ▸ for (j < colEnd) ▸ if (IsEditMode == false) | GRID_SET | siMain.ActiveSheet.Cells[i, j].ForeColor | DefGridColor.Black | 그리드 속성/값 설정 |  |  |  |
| AC-e8813092 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2271 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Columns[j].Font | fontCellBold | 그리드 속성/값 설정 |  |  |  |
| AC-7d000a79 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2290 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ switch (colTag) case "CELL_SUM": case "PACK_SUM": case "SHIPMENT_SUM": ca… | GRID_SET | siMain.ActiveSheet.Columns[j].Font | fontCellBold | 그리드 속성/값 설정 |  |  |  |
| AC-68fc7d2e | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2307 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ switch (colTag) case "CELL_SUM": case "PACK_SUM": case "SHIPMENT_SUM": ca… | GRID_SET | siMain.ActiveSheet.Columns[j].BackColor | DefGridColor.Gainsboro | 그리드 속성/값 설정 |  |  |  |
| AC-578508d8 | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2312 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ switch (colTag) case "DNI_CELL_SUM": case "DNI_PACK_SUM": | GRID_SET | siMain.ActiveSheet.Columns[j].BackColor | DefGridColor.Honeydew | 그리드 속성/값 설정 |  |  |  |
| AC-fd1de95f | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2316 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ switch (colTag) case "STANDARD_DIO_AUTO": | GRID_SET | siMain.ActiveSheet.Columns[j].BackColor | DefGridColor.MistyRose | 그리드 속성/값 설정 |  |  |  |
| AC-5cbe739c | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2319 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ switch (colTag) default: | GRID_SET | siMain.ActiveSheet.Columns[j].ForeColor | DefGridColor.Black | 그리드 속성/값 설정 |  |  |  |
| AC-4bc98a2c | btnVersionCreate.Click [try ▸ try ▸ if (ds.Tables[0].Rows.Co… 외 4 | SCP0083_DIOReport.cs:2329 | else of (isEditAfter) ▸ for (j < siMain.ActiveSheet.ColumnCount) ▸ switch (colTag) case "SHIPMENT_CELL_SUM": case "SHIPMENT_PACK_SUM": | GRID_SET | siMain.ActiveSheet.Columns[j].ForeColor | DefGridColor.Black | 그리드 속성/값 설정 |  |  |  |

## SCP0083_DIOReport.SetSpreadInit

진입점: this.Load / btnVersionCreate.Click [try ▸ try] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try] / FindButton [if (this.spdMain.Visible) ▸ try] / EditButton [if (this.spdMain.Visible) ▸ if (spdMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (IsEditMode == false) ▸ try] / SaveButton [if (this.spdMain.Visible) ▸ try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9531f6c | this.Load 외 5 | SCP0083_DIOReport.cs:299 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42c2061a | this.Load 외 5 | SCP0083_DIOReport.cs:300 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-7b52f483 | this.Load 외 5 | SCP0083_DIOReport.cs:302 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-928ef1dd | this.Load 외 5 | SCP0083_DIOReport.cs:303 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.ColumnHeaderHeight | (0, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e51333a | this.Load 외 5 | SCP0083_DIOReport.cs:304 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.ColumnHeaderHeight | (1, 20) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9088cc2 | this.Load 외 5 | SCP0083_DIOReport.cs:305 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.ColumnHeaderHeight | (2, 30) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3090daa6 | this.Load 외 5 | SCP0083_DIOReport.cs:306 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5d7412e | this.Load 외 5 | SCP0083_DIOReport.cs:313 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd07c754 | this.Load 외 5 | SCP0083_DIOReport.cs:314 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-c553bdca | this.Load 외 5 | SCP0083_DIOReport.cs:316 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-16bf1a70 | this.Load 외 5 | SCP0083_DIOReport.cs:317 | else of (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | spdInfo.ColumnHeaderHeight | (0, 35) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e5ff91bd | this.Load 외 5 | SCP0083_DIOReport.cs:320 |  | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-240b2b20 | this.Load 외 5 | SCP0083_DIOReport.cs:321 |  | GRID_INIT | siCycle.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReport.SetVisibleColumnCycle

진입점: btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / btnVersionDelete.Click [try ▸ if (ds.Tables[0].Rows[0]["RESULT"].Equals("1")) ▸ try ▸ if (type >= 2) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [if (this.spdCycle.Visible) ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / SaveButton [if (this.spdCycle.Visible) ▸ try ▸ if (siCycle != null && siCycle.IsLock(SpdSheet.shtCycle) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (ds.Tables[0].Rows.Count …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de8c250 | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2430 | for (i < 13) ▸ if (i <= data_range) | GRID_INIT | siCycle.SetColumnHeader | (0, siCycle.GetColumnIndex(month), row[month].ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-70eee9de | btnVersionCreate.Click [try ▸ try ▸ if (type >= 2) ▸ try ▸ i… 외 3 | SCP0083_DIOReport.cs:2434 | for (i < 13) ▸ else of (i <= data_range) | GRID_INIT | siCycle.VisibleColumns | (siCycle.GetColumnIndex(month), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReport.SpdCycle_DragDrop

진입점: this.spdCycle.DragDrop

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fe0ccb8 | this.spdCycle.DragDrop | SCP0083_DIOReport.cs:3485 |  | THROW | throw new NotImplementedException(); |  | 예외 발생 |  |  |  |

## SCP0083_DIOReport.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a50ef38 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3211 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | CALL_EXT | ScpUtils.ConvertInt | (CString.GetCheckedListValue(dtVersion, cboVersion.ControlValues)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ee4ad315 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3218 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (!iseditcolumn) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1318551d | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3223 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) | DATA_OP | selCol.Contains | ("_AUTO") | 데이터 객체 조작/조회 |  |  |  |
| AC-80e6fb7c | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3231 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("SHIPMENT") == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cf13ccf1 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3238 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | POPUP | new SCP0083_DIOReportOperationPopup | () | 팝업/폼 생성 |  |  |  |
| AC-352edff1 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3240 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.Width | 1300 | 속성 Width 설정 |  |  |  |
| AC-8243de40 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3241 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-4f894e80 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3242 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-819f74c4 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3244 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | DATA_OP | selCol.Contains | ("CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-99b33473 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3244 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | DATA_OP | selCol.Contains | ("PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc052342 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3246 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.DIVISION_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 속성 DIVISION_ID 설정 |  |  |  |
| AC-1574bdca | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3247 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.PLAN_START_YYYYMMDD | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)).ToString() | 속성 PLAN_START_YYYYMMDD 설정 |  |  |  |
| AC-13439e68 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3248 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.PLAN_TYPE | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-b753399f | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3249 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.SEQ | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 속성 SEQ 설정 |  |  |  |
| AC-9fe81786 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3250 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.NICK_NAME | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME)).ToString() | 속성 NICK_NAME 설정 |  |  |  |
| AC-d83be56d | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3251 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.PLANT_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 속성 PLANT_ID 설정 |  |  |  |
| AC-0e95b690 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3252 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.OPERATION_GROUP | op | 속성 OPERATION_GROUP 설정 |  |  |  |
| AC-0bb7c708 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3253 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.FROM_SITE | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_SITE)).ToString() | 속성 FROM_SITE 설정 |  |  |  |
| AC-a209ad3f | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3254 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.TO_SITE | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_SITE)).ToString() | 속성 TO_SITE 설정 |  |  |  |
| AC-70267622 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3255 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | UI_PROP | popup.VERSION | p_ver | 속성 VERSION 설정 |  |  |  |
| AC-3de333b3 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3256 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (selCol.IndexOf("DNI") == 0) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-29b39028 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3265 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | POPUP | new SCP0083_DIOReportAgingPopup | () | 팝업/폼 생성 |  |  |  |
| AC-13b6587f | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3267 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.Width | 1150 | 속성 Width 설정 |  |  |  |
| AC-68c7ff38 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3268 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-cd22be90 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3269 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e6f192a9 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3271 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.DIVISION_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 속성 DIVISION_ID 설정 |  |  |  |
| AC-5c80a180 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3272 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.PLAN_START_YYYYMMDD | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)).ToString() | 속성 PLAN_START_YYYYMMDD 설정 |  |  |  |
| AC-a07974a6 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3273 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.PLAN_TYPE | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-740cad97 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3274 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.SEQ | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 속성 SEQ 설정 |  |  |  |
| AC-d476b31a | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3275 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.ITEM_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 속성 ITEM_ID 설정 |  |  |  |
| AC-bafe9712 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3276 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.NICK_NAME | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME)).ToString() | 속성 NICK_NAME 설정 |  |  |  |
| AC-6239f279 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3277 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.PLANT_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 속성 PLANT_ID 설정 |  |  |  |
| AC-be94b096 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3278 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.VERSION | p_ver | 속성 VERSION 설정 |  |  |  |
| AC-1abdd6b2 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3279 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.SEL_COLUMN | selCol | 속성 SEL_COLUMN 설정 |  |  |  |
| AC-ae246523 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3280 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | UI_PROP | popup.SEL_COLUMN_TEXT | siMain.GetColumnText(2, e.Column) | 속성 SEL_COLUMN_TEXT 설정 |  |  |  |
| AC-7607c5a2 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3280 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | CALL_EXT | siMain.GetColumnText | (2, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-50f2ff6c | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3282 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ if (selCol.IndexOf("CELL_AGING_LT") == 0… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-adccd23e | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3288 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | POPUP | new SCP0083_DIOReportPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e5cbe45a | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3290 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.Width | 1150 | 속성 Width 설정 |  |  |  |
| AC-88f64770 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3291 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-2a8b4bb6 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3292 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cf6670c9 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3294 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.DIVISION_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.DIVISION_ID)).ToString() | 속성 DIVISION_ID 설정 |  |  |  |
| AC-9931cc75 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3295 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.PLAN_START_YYYYMMDD | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_START_YYYYMMDD)).ToString() | 속성 PLAN_START_YYYYMMDD 설정 |  |  |  |
| AC-5e8e8b6a | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3296 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.PLAN_TYPE | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLAN_TYPE)).ToString() | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-ecfe9d57 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3297 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.SEQ | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.SEQ)).ToString() | 속성 SEQ 설정 |  |  |  |
| AC-9bc7650f | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3298 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.ITEM_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID)).ToString() | 속성 ITEM_ID 설정 |  |  |  |
| AC-21861338 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3299 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.NICK_NAME | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME)).ToString() | 속성 NICK_NAME 설정 |  |  |  |
| AC-9a5b0df5 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3300 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.PLANT_ID | siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.PLANT_ID)).ToString() | 속성 PLANT_ID 설정 |  |  |  |
| AC-6b8a88cb | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3301 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.VERSION | p_ver | 속성 VERSION 설정 |  |  |  |
| AC-917c96fb | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3302 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.SEL_COLUMN | selCol | 속성 SEL_COLUMN 설정 |  |  |  |
| AC-643d17b5 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3303 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | UI_PROP | popup.SEL_COLUMN_TEXT | siMain.GetColumnText(2, e.Column) | 속성 SEL_COLUMN_TEXT 설정 |  |  |  |
| AC-adf6f644 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3303 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | CALL_EXT | siMain.GetColumnText | (2, e.Column) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c72ab217 | this.spdMain.CellDoubleClick | SCP0083_DIOReport.cs:3305 | if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ else of (selCol.IndexOf("DNI") == 0) ▸ else of (selCol.IndexOf("CELL_AGING_LT")… | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0083_DIOReport.spdMain_Change

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b7734f8 | (진입점 미연결) | SCP0083_DIOReport.cs:3117 | if (colTag == "DNI_CELL_SUM" \|\| colTag == "DNI_PACK_SUM") | GRID_STYLE | siMain.SetForeColor | (e.Row, e.Column, e.Row, e.Column, DefGridColor.Red, true) | 그리드 표시 설정 |  |  |  |

## SCP0083_DIOReport.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted / this.spdCycle.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8c76a54 | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3135 | if (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-65467cf3 | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3136 | if (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01ea5981 | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3151 | if (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ try ▸ for (iRow < e.Cel… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-801cc8cb | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3157 | if (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-440f688c | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3158 | if (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ catch ((Exception ex)) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b2a039b2 | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3162 | if (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siMain.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-3621a7c5 | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3182 | else of (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ catch ((Exceptio… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bafa72e6 | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3183 | else of (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ catch ((Exceptio… | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1f5fec3b | this.spdMain.ClipboardPasted 외 1 | SCP0083_DIOReport.cs:3187 | else of (p.ActiveSheet.SheetName.Equals(SpdSheet.shtMain)) ▸ if (siCycle.ActiveSheet.SheetName.Equals(SpdSheet.shtCycle)) ▸ finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0083_DIOReport.SpdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting / this.spdCycle.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76baedd7 | this.spdMain.ClipboardPasting 외 1 | SCP0083_DIOReport.cs:3197 |  | FLAG | cellclipboardPast | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0083_DIOReport.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f95f8b85 | this.spdMain.EditChange | SCP0083_DIOReport.cs:3329 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM) \|\| e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT…) | VALUE_SET | shipment_sum.Value | (ScpUtils.GetValueDecimal(shipment_cell_sum.Value) + ScpUtils.GetValueDecimal(shipment_pac… | 컨트롤 값 설정 |  |  |  |
| AC-11c66097 | this.spdMain.EditChange | SCP0083_DIOReport.cs:3329 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM) \|\| e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT…) | CALL_EXT | ScpUtils.GetValueDecimal | (shipment_cell_sum.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3e0867c | this.spdMain.EditChange | SCP0083_DIOReport.cs:3329 | try ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT_CELL_SUM) \|\| e.Column == siMain.GetColumnIndex(DefColumns.SHIPMENT…) | CALL_EXT | ScpUtils.GetValueDecimal | (shipment_pack_sum.Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d84092f9 | this.spdMain.EditChange | SCP0083_DIOReport.cs:3336 | try | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b5384c6 | this.spdMain.EditChange | SCP0083_DIOReport.cs:3342 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |

## SCP0083_DIOReport.TxtRange_CommonValueChanged

진입점: txtRange.CommonValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-237f8dc1 | txtRange.CommonValueChanged | SCP0083_DIOReport.cs:3107 | if (!(range >= 3 && range <= 12)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00151", new object[] { range }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d56a113e | txtRange.CommonValueChanged | SCP0083_DIOReport.cs:3108 | if (!(range >= 3 && range <= 12)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0083_DIOReportAgingPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1da181c | this.Load | SCP0083_DIOReportAgingPopup.cs:98 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-28e7d6c0 | this.Load | SCP0083_DIOReportAgingPopup.cs:99 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-55075924 | this.Load | SCP0083_DIOReportAgingPopup.cs:101 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0083_DIOReportAgingPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba3dfd10 | this.Load | SCP0083_DIOReportAgingPopup.cs:92 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0083_DIOReportAgingPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-025efd03 | Dispose | SCP0083_DIOReportAgingPopup.designer.cs:20 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReportAgingPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c43e8edb | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:165 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6f2b666e | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:170 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_DIO_AGING_LT") ⇒ SCP.SCP0083_GET_DIO_AGING_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-b1d7ba21 | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:171 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fe82b8dc | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:172 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | PLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-eeee031c | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:173 | lambda | DATA_OP | request.Parameters["p_plan_type"] | PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-a64f6158 | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:174 | lambda | DATA_OP | request.Parameters["p_seq"] | SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-f3a05b1f | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:175 | lambda | DATA_OP | request.Parameters["p_item_id"] | ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-8846377c | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:176 | lambda | DATA_OP | request.Parameters["p_nick_name"] | NICK_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-38ffc19d | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:179 | lambda | DATA_OP | request.Parameters["p_ver"] | VERSION | 행/컬럼 값 대입 |  |  |  |
| AC-6ee38b1d | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:180 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8907e0bf | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:181 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b426528a | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:183 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6d89621a | this.Load 외 1 | SCP0083_DIOReportAgingPopup.cs:187 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCP0083_DIOReportAgingPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f3aaa79 | this.Load | SCP0083_DIOReportAgingPopup.cs:77 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0083_DIOReportAgingPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65862d39 | this.Load | SCP0083_DIOReportAgingPopup.cs:108 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-71a5dc33 | this.Load | SCP0083_DIOReportAgingPopup.cs:109 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0083_DIOReportAgingPopup.SetVisibleColumnCycle

진입점: this.Load [if (ds.Tables[1].Rows.Count > 0)] / FindButton [if (ds.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d8cc3aa | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportAgingPopup.cs:208 | for (i < 13) ▸ if (i <= data_range) | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(month), row[month].ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-8db70886 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportAgingPopup.cs:212 | for (i < 13) ▸ else of (i <= data_range) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(month), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReportOperationPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4f7c9fa4 | this.Load | SCP0083_DIOReportOperationPopup.cs:94 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8ed24afc | this.Load | SCP0083_DIOReportOperationPopup.cs:95 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-141fdcaf | this.Load | SCP0083_DIOReportOperationPopup.cs:97 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0083_DIOReportOperationPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1562a308 | this.Load | SCP0083_DIOReportOperationPopup.cs:88 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0083_DIOReportOperationPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57e09993 | Dispose | SCP0083_DIOReportOperationPopup.designer.cs:20 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReportOperationPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63a504b0 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:148 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d9f5ea73 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:152 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_DIO_OPERATION_LT") ⇒ SCP.SCP0083_GET_DIO_OPERATION_LT | 엔드포인트 요청 생성 |  |  |  |
| AC-eeacd196 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:153 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-3979985c | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:154 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | PLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-7be66b88 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:155 | lambda | DATA_OP | request.Parameters["p_plan_type"] | PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-bcfa6def | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:156 | lambda | DATA_OP | request.Parameters["p_seq"] | SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-3ecb89da | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:157 | lambda | DATA_OP | request.Parameters["p_nick_name"] | NICK_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-03b552c9 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:158 | lambda | DATA_OP | request.Parameters["p_plant_id"] | PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-456c2893 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:159 | lambda | DATA_OP | request.Parameters["p_operation_group"] | OPERATION_GROUP | 행/컬럼 값 대입 |  |  |  |
| AC-32d6c883 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:160 | lambda | DATA_OP | request.Parameters["p_from_site"] | FROM_SITE | 행/컬럼 값 대입 |  |  |  |
| AC-6af787b0 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:161 | lambda | DATA_OP | request.Parameters["p_to_site"] | TO_SITE | 행/컬럼 값 대입 |  |  |  |
| AC-21e857fd | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:162 | lambda | DATA_OP | request.Parameters["p_ver"] | VERSION | 행/컬럼 값 대입 |  |  |  |
| AC-b48b4295 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:163 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7cc2efef | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:164 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-686bc807 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:166 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-70803754 | this.Load 외 1 | SCP0083_DIOReportOperationPopup.cs:170 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCP0083_DIOReportOperationPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-740187a3 | this.Load | SCP0083_DIOReportOperationPopup.cs:74 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0083_DIOReportOperationPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0903ba3 | this.Load | SCP0083_DIOReportOperationPopup.cs:104 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5f6897e0 | this.Load | SCP0083_DIOReportOperationPopup.cs:105 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-ed2b85a1 | this.Load | SCP0083_DIOReportOperationPopup.cs:109 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ea924a0d | this.Load | SCP0083_DIOReportOperationPopup.cs:110 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f9adc2fe | this.Load | SCP0083_DIOReportOperationPopup.cs:111 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9ba55d1f | this.Load | SCP0083_DIOReportOperationPopup.cs:112 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a0a4892e | this.Load | SCP0083_DIOReportOperationPopup.cs:117 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-737d3729 | this.Load | SCP0083_DIOReportOperationPopup.cs:118 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-334023ad | this.Load | SCP0083_DIOReportOperationPopup.cs:119 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8864c7a1 | this.Load | SCP0083_DIOReportOperationPopup.cs:120 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a233e5b8 | this.Load | SCP0083_DIOReportOperationPopup.cs:124 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9b44f621 | this.Load | SCP0083_DIOReportOperationPopup.cs:125 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df3257e7 | this.Load | SCP0083_DIOReportOperationPopup.cs:126 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-069e5a13 | this.Load | SCP0083_DIOReportOperationPopup.cs:127 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReportOperationPopup.SetSpreadColumn

진입점: this.Load [if (ds.Tables[1].Rows.Count > 0)] / FindButton [if (ds.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae5a5e38 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:228 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "LT_INCOTERMS_CONST":… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol + 1].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-e00bf07b | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:229 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "LT_INCOTERMS_CONST":… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol + 2].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-13568caa | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:230 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "LT_INCOTERMS_CONST":… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol + 3].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-a276ff90 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:231 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "LT_INCOTERMS_CONST":… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol + 4].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-d1eeb8bd | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:232 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "LT_INCOTERMS_CONST":… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol + 5].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |
| AC-54d1d7a3 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:233 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (focusHeaderName) case "LT_INCOTERMS_CONST":… | GRID_SET | siMain.ActiveSheet.Cells[iRow, iCol + 6].BackColor | Color.LightPink | 그리드 속성/값 설정 |  |  |  |

## SCP0083_DIOReportOperationPopup.SetVisibleColumnCycle

진입점: this.Load [if (ds.Tables[1].Rows.Count > 0)] / FindButton [if (ds.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dab948b | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:192 | for (i < 13) ▸ if (i <= data_range) | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(month), row[month].ToString()) | 그리드 재구성/초기화 |  |  |  |
| AC-2bdf5c08 | this.Load [if (ds.Tables[1].Rows.Count > 0)] 외 1 | SCP0083_DIOReportOperationPopup.cs:196 | for (i < 13) ▸ else of (i <= data_range) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(month), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0083_DIOReportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71c3f134 | this.Load | SCP0083_DIOReportPopup.cs:96 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-892b7280 | this.Load | SCP0083_DIOReportPopup.cs:97 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3b82c8d3 | this.Load | SCP0083_DIOReportPopup.cs:99 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0083_DIOReportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c48926e | this.Load | SCP0083_DIOReportPopup.cs:90 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0083_DIOReportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a44ac6d8 | Dispose | SCP0083_DIOReportPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0083_DIOReportPopup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-905abab2 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:159 |  | GRID_INIT | siMain.SetColumnHeader | (0, siMain.GetColumnIndex(DefColumns.SEL_COLUMN), SEL_COLUMN_TEXT) | 그리드 재구성/초기화 |  |  |  |
| AC-ecc20e02 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:163 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3862b072 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:167 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0083_GET_DIO_REPORT_H") ⇒ SCP.SCP0083_GET_DIO_REPORT_H | 엔드포인트 요청 생성 |  |  |  |
| AC-5cd75843 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:168 | lambda | DATA_OP | request.Parameters["p_division_id"] | DIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fe12477a | this.Load 외 1 | SCP0083_DIOReportPopup.cs:169 | lambda | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | PLAN_START_YYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-0a467817 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:170 | lambda | DATA_OP | request.Parameters["p_plan_type"] | PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-4f4f94c5 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:171 | lambda | DATA_OP | request.Parameters["p_seq"] | SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-defaf406 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:172 | lambda | DATA_OP | request.Parameters["p_item_id"] | ITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-ac836b63 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:173 | lambda | DATA_OP | request.Parameters["p_nick_name"] | NICK_NAME | 행/컬럼 값 대입 |  |  |  |
| AC-7677ae8e | this.Load 외 1 | SCP0083_DIOReportPopup.cs:174 | lambda | DATA_OP | request.Parameters["p_plant_id"] | PLANT_ID | 행/컬럼 값 대입 |  |  |  |
| AC-2688cd9f | this.Load 외 1 | SCP0083_DIOReportPopup.cs:175 | lambda | DATA_OP | request.Parameters["p_sel_column"] | SEL_COLUMN | 행/컬럼 값 대입 |  |  |  |
| AC-137edd3e | this.Load 외 1 | SCP0083_DIOReportPopup.cs:176 | lambda | DATA_OP | request.Parameters["p_ver"] | VERSION | 행/컬럼 값 대입 |  |  |  |
| AC-f6316c43 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:177 | lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-aeebd290 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:178 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a2464dc6 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:180 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-e780c934 | this.Load 외 1 | SCP0083_DIOReportPopup.cs:184 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCP0083_DIOReportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ee4dd99 | this.Load | SCP0083_DIOReportPopup.cs:75 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0083_DIOReportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41ea8dda | this.Load | SCP0083_DIOReportPopup.cs:106 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-e7b0eff2 | this.Load | SCP0083_DIOReportPopup.cs:107 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f091e8ea | this.Load | SCP0083_DIOReportPopup.cs:111 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-067f73fe | this.Load | SCP0083_DIOReportPopup.cs:113 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-08fa11b7 | this.Load | SCP0083_DIOReportPopup.cs:114 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8d735229 | this.Load | SCP0083_DIOReportPopup.cs:116 | if (DIVISION_ID.Equals("81")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bb4dc44c | this.Load | SCP0083_DIOReportPopup.cs:122 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6bbc1a60 | this.Load | SCP0083_DIOReportPopup.cs:124 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7f33e33f | this.Load | SCP0083_DIOReportPopup.cs:125 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b89f55a8 | this.Load | SCP0083_DIOReportPopup.cs:127 | else of (DIVISION_ID.Equals("81")) ▸ if (DIVISION_ID.Equals("40")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b7de6380 | this.Load | SCP0083_DIOReportPopup.cs:132 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.END_CUSTOMER), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-68ee749f | this.Load | SCP0083_DIOReportPopup.cs:134 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-72f7d399 | this.Load | SCP0083_DIOReportPopup.cs:135 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.EXTRA_SPEC), false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c186c282 | this.Load | SCP0083_DIOReportPopup.cs:137 | else of (DIVISION_ID.Equals("81")) ▸ else of (DIVISION_ID.Equals("40")) ▸ if (DIVISION_ID.Equals("82")) | GRID_INIT | siMain.VisibleColumns | (siMain.GetColumnIndex(DefColumns.CELL_ITEM_ID), true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

