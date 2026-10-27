# AS-IS 액션 대조표 — SCP0081

> 원천: `Doc/asisfacts/screens/SCP0081/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 148행 · 메서드 43 · 종류 DATA_OP 37 · RETURN 18 · GRID_INIT 18 · FLAG 15 · UI_PROP 12 · GRID_SET 8 · LIST_REBIND 7 · CALL_EXT 6 · ENDPOINT 5 · POPUP 4 · UI_MISC 3 · VALUE_SET 3 · COMBO_DATA 3 · GRID_CLEAR 2 · VALIDATE 2 · GRID_BIND 1 · GRID_LOCK 1 · MESSAGE 1 · VALUE_CLEAR 1 · GRID_STYLE 1 · ⚠ 의미 확인 필요 6


## SCP0081_ProductionPlanReport.AfterFindData

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46bc2ae9 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:688 | if (lst.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fae75f0a | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:692 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-89c29bad | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:694 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7627b73 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:697 |  | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b1ed655a | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:702 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0081_ProductionPlanReport.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12d8a5e0 | this.btnColumn.Click | SCP0081_ProductionPlanReport.cs:969 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0081", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-7d8ea8ca | this.btnColumn.Click | SCP0081_ProductionPlanReport.cs:970 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2bcb5e61 | this.btnColumn.Click | SCP0081_ProductionPlanReport.cs:971 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0081_ProductionPlanReport.BtnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1af89ec | this.btnMeasure.Click | SCP0081_ProductionPlanReport.cs:984 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0081", sSheetName, false) | 팝업/폼 생성 |  |  |  |
| AC-658aa8b3 | this.btnMeasure.Click | SCP0081_ProductionPlanReport.cs:985 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-252be53b | this.btnMeasure.Click | SCP0081_ProductionPlanReport.cs:986 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0081_ProductionPlanReport.cmbSubTotal_SelectedIndexChanged

진입점: this.cmbSubTotal.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97a9664e | this.cmbSubTotal.SelectedIndexChanged | SCP0081_ProductionPlanReport.cs:952 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0081_ProductionPlanReport.cmbVersion_SelectedIndexChanged

진입점: this.cmbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eac605c | this.cmbVersion.SelectedIndexChanged | SCP0081_ProductionPlanReport.cs:961 | if (fps != null) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0081_ProductionPlanReport.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf937273 | this.Load | SCP0081_ProductionPlanReport.cs:510 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-145da394 | this.Load | SCP0081_ProductionPlanReport.cs:511 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fb87e98b | this.Load | SCP0081_ProductionPlanReport.cs:513 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0081_ProductionPlanReport.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a28b0e6 | this.Load | SCP0081_ProductionPlanReport.cs:464 |  | VALUE_SET | chkSum.Checked | false | 컨트롤 값 설정 |  |  |  |

## SCP0081_ProductionPlanReport.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f83b100a | Dispose | SCP0081_ProductionPlanReport.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0081_ProductionPlanReport.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfeefb82 | FindButton | SCP0081_ProductionPlanReport.cs:707 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0a2442fd | FindButton | SCP0081_ProductionPlanReport.cs:707 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-885bbea3 | FindButton | SCP0081_ProductionPlanReport.cs:714 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) ▸ if (this.QueryDics[DIC_PRODUCTION_PLAN_REPORT].Count > 0) | CALL_EXT | this.QueryDics[DIC_PRODUCTION_PLAN_REPORT].Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-a700fcd5 | FindButton | SCP0081_ProductionPlanReport.cs:720 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | UI_PROP | qi.BeforeExecuteSQLProc | this.InitSpreadSheet | 속성 BeforeExecuteSQLProc 설정 |  |  |  |
| AC-6178aa44 | FindButton | SCP0081_ProductionPlanReport.cs:721 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | UI_PROP | qi.AfterExecuteSQLProc | this.AfterFindData | 속성 AfterExecuteSQLProc 설정 |  |  |  |
| AC-08582ed0 | FindButton | SCP0081_ProductionPlanReport.cs:722 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | UI_PROP | qi.ServiceUri | "GSCM.SCP.Analysis.WSL/FoxDataService.svc" | 속성 ServiceUri 설정 |  |  |  |
| AC-db01d7c2 | FindButton | SCP0081_ProductionPlanReport.cs:723 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | UI_PROP | qi.QueryId | "SCP.SCP0081_GET_PRODUCTION_PLAN_REPORT" | 속성 QueryId 설정 |  |  |  |
| AC-9eb3a787 | FindButton | SCP0081_ProductionPlanReport.cs:725 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_from_yyyymmdd", this._from_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d4d143a3 | FindButton | SCP0081_ProductionPlanReport.cs:726 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_to_yyyymmdd", this._to_yyyymmdd)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8c0bd4ea | FindButton | SCP0081_ProductionPlanReport.cs:727 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_division_id", this._division)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6a5a5d6 | FindButton | SCP0081_ProductionPlanReport.cs:728 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_operation_id", this._operation)) | 데이터 객체 조작/조회 |  |  |  |
| AC-816dd1b6 | FindButton | SCP0081_ProductionPlanReport.cs:729 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_line_id", this._lineId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5e3ec9f | FindButton | SCP0081_ProductionPlanReport.cs:730 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_item_id", this._modelId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eb518ce | FindButton | SCP0081_ProductionPlanReport.cs:731 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_nickname", this._nickName)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e39363c1 | FindButton | SCP0081_ProductionPlanReport.cs:732 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_user_id", base.UserInfo.UserId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-718a2880 | FindButton | SCP0081_ProductionPlanReport.cs:733 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_id", this._versionId)) | 데이터 객체 조작/조회 |  |  |  |
| AC-3c987bac | FindButton | SCP0081_ProductionPlanReport.cs:734 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_a", this._version_a)) | 데이터 객체 조작/조회 |  |  |  |
| AC-aba517c4 | FindButton | SCP0081_ProductionPlanReport.cs:735 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_version_b", this._version_b)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9775dd0 | FindButton | SCP0081_ProductionPlanReport.cs:736 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("p_group_column", this._group_column)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c54fec16 | FindButton | SCP0081_ProductionPlanReport.cs:737 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | qi.SQLParams.Add | (new KeyValuePair<string, object>("debug_mode", "F")) | 데이터 객체 조작/조회 |  |  |  |
| AC-9044751c | FindButton | SCP0081_ProductionPlanReport.cs:739 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | DATA_OP | this.QueryDics[DIC_PRODUCTION_PLAN_REPORT] | new List<QueryInfo>() { qi } | 행/컬럼 값 대입 |  |  |  |
| AC-b52c2ca9 | FindButton | SCP0081_ProductionPlanReport.cs:742 | if (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | ENDPOINT | this.ExecuteSQL | (siMain, DIC_PRODUCTION_PLAN_REPORT, true) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6cb7f77e | FindButton | SCP0081_ProductionPlanReport.cs:746 | else of (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00255") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c02f33a4 | FindButton | SCP0081_ProductionPlanReport.cs:748 | else of (cmbVersion.CheckedItems.Count == 2 \|\| cmbVersion.CheckedItems.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c615a835 | this.Load | SCP0081_ProductionPlanReport.cs:449 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0081_ProductionPlanReport.GetDayRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-707a9c9d | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:859 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0052_GET_DAY_RANGE") ⇒ SCP.SCP0052_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-ad7f38d5 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:860 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b1282e7c | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:861 |  | DATA_OP | request.Parameters["p_month"] | 13 | 행/컬럼 값 대입 |  |  |  |
| AC-3ad295bb | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:863 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9b60f8f5 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:863 |  | RETURN | return client.ExecuteDataSet(request).DataSet.Tables[0]; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eff9b43 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:140 |  | RETURN | return cmbDivision.SelectedItem.ToString() == "ALL" ? "" : CString.GetCheckedLis… |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getFromYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb2f4d49 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:231 |  | RETURN | return dCalendar.Text1.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getGroupColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16ae7ebe | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:329 |  | RETURN | return CString.GetCheckedListValue(dtSubTotal, cmbSubTotal.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getLineId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-be4fd53f | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:186 |  | RETURN | return cmbLine.ControlValues.ToString() == "ALL" ? "" : CString.GetCheckedListVa… |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getModelId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16ef718d | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:201 |  | RETURN | return txtModelId.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getNickName

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe0bb8aa | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:216 |  | RETURN | return txtNickName.Text; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09455de9 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:156 |  | RETURN | return CString.GetCheckedListValue(dtOperation, cmbOperationGroup.ControlValues)… |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getPlantId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-625f7144 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:171 |  | RETURN | return cmbPlant.ControlValues.ToString() == "ALL" ? "" : CString.GetCheckedListV… |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.GetSpdTitle

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79053dcc | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:756 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-537c64bf | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:758 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | this._from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3c24bb2d | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:759 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | this._to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f475f15d | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:761 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-4b4caee6 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:761 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0081_ProductionPlanReport.getToYYYYMMDD

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04663bfa | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:246 |  | RETURN | return dCalendar.Text2.Replace("-", ""); |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getVersionA

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05f24f18 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:287 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getVersionB

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a5a11c6 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:313 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.getVersionId

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01532fae | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:261 |  | RETURN | return CString.GetCheckedListValue(dtVersion, cmbVersion.ControlValues, true); |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-081ed819 | this.Load | SCP0081_ProductionPlanReport.cs:470 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a0b4606 | this.Load | SCP0081_ProductionPlanReport.cs:472 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f4b51f0f | this.Load | SCP0081_ProductionPlanReport.cs:477 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |

## SCP0081_ProductionPlanReport.InitQueryDics

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-95f40138 | this.Load | SCP0081_ProductionPlanReport.cs:444 |  | DATA_OP | QueryDics.Add | (DIC_PRODUCTION_PLAN_REPORT, new List<QueryInfo>()) | 데이터 객체 조작/조회 |  |  |  |

## SCP0081_ProductionPlanReport.InitSpread

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35158a08 | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:522 |  | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c27de730 | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:523 |  | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0081_ProductionPlanReport.InitSpreadDateColumn

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-443f5894 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:810 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a013e0d2 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:814 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-51e2b28d | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:821 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-95a4e216 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:822 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1fdea0f5 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:828 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f989c6e8 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:829 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-738eee8e | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:837 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-924e5473 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:838 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f43d5da5 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:849 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28c763fb | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:850 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b79ddd1 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:851 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-01c67868 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:852 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0081_ProductionPlanReport.initSubTotal

진입점: this.Load / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12f7c30f | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1015 |  | FLAG | dtSubTotal | siMain.GetSpdTitle("SCP0081", UserInfo.UserId, "Production Plan Report") | 화면 필드/플래그 변경 |  |  |  |
| AC-f6ae796e | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1015 |  | CALL_EXT | siMain.GetSpdTitle | ("SCP0081", UserInfo.UserId, "Production Plan Report") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d4663401 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1025 |  | DATA_OP | tmpSubTotal.Columns.Add | ("CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f507f8d | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1026 |  | DATA_OP | tmpSubTotal.Columns.Add | ("NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-805858bc | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1028 |  | CALL_EXT | tmpSubTotal.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b6a085a7 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1032 | foreach (DataRow dr in dtSubTotal.Rows) | DATA_OP | tmpSubTotal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e2ab4f0 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1033 | foreach (DataRow dr in dtSubTotal.Rows) | DATA_OP | dataRow["CODE"] | dr["COLUMN_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-9db6500c | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1034 | foreach (DataRow dr in dtSubTotal.Rows) | DATA_OP | dataRow["NAME"] | dr["COLUMN_LABEL_NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-0d529528 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1038 | foreach (DataRow dr in dtSubTotal.Rows) | DATA_OP | tmpSubTotal.Rows.Add | (dataRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-eee8f976 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1041 |  | DATA_OP | tmpSubTotal.Columns.Add | ("SORT_ORDER") | 데이터 객체 조작/조회 |  |  |  |
| AC-0785f0ab | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1042 |  | DATA_OP | tmpSubTotal.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7063e1d8 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1043 |  | DATA_OP | row["CODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a80e14d8 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1044 |  | DATA_OP | row["NAME"] | "선택" | 행/컬럼 값 대입 |  |  |  |
| AC-dbc44486 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1045 |  | DATA_OP | row["SORT_ORDER"] | 0 | 행/컬럼 값 대입 |  |  |  |
| AC-85bcfe7c | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1046 |  | CALL_EXT | tmpSubTotal.Rows.InsertAt | (row, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0cec4d82 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1049 |  | DATA_OP | tmpSubTotal.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f15194ad | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1051 |  | LIST_REBIND | clsCtrl.setListBox | (tmpSubTotal, cmbSubTotal, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ff65f20f | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:1052 |  | VALUE_CLEAR | cmbSubTotal.SelectedValue | "" | 컨트롤 값 비움 |  |  |  |

## SCP0081_ProductionPlanReport.IsPartialRight

진입점: this.Load [for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] / this.cmbBucketType.SelectedIndexChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] / this.chkSum.CheckedChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] / this.rdUOM.CheckedChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] / this.rdCell.CheckedChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] / this.btnColumn.Click [if (frm…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acb933f2 | this.Load [for (iCol <= siObj.GetMaxColumnIndex()) ▸ try] 외 7 | SCP0081_ProductionPlanReport.cs:551 |  | RETURN | return s.Substring(s.Length - sub.Length, sub.Length).Equals(sub); |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.IsVisibleCell

진입점: this.Load [for (iCol <= siObj.GetMaxColumnIndex())] / this.cmbBucketType.SelectedIndexChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex())] / this.chkSum.CheckedChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex())] / this.rdUOM.CheckedChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex())] / this.rdCell.CheckedChanged [if (fps != null) ▸ for (iCol <= siObj.GetMaxColumnIndex())] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ for (iCol <= siObj.GetMaxColumnIndex())] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14ee51e9 | this.Load [for (iCol <= siObj.GetMaxColumnIndex())] 외 7 | SCP0081_ProductionPlanReport.cs:575 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0081_ProductionPlanReport.Re_Design

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e485062 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:910 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (row <= lastRowIdx) ▸ if (startTotal == f… | VALUE_SET | cells.Text | "Sub Total" | 컨트롤 값 설정 |  |  |  |
| AC-1d69dc02 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:911 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (row <= lastRowIdx) ▸ if (startTotal == f… | UI_PROP | cells.ColumnSpan | lastCol - startCol | 속성 ColumnSpan 설정 |  |  |  |
| AC-7c043611 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:912 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (row <= lastRowIdx) ▸ if (startTotal == f… | UI_PROP | cells.RowSpan | subTotalendRow - subTotalStartRow + 1 | 속성 RowSpan 설정 |  |  |  |
| AC-012ee02d | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:913 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (row <= lastRowIdx) ▸ if (startTotal == f… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-4da02cc3 | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:914 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (row <= lastRowIdx) ▸ if (startTotal == f… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-fab89a2f | (진입점 미연결) | SCP0081_ProductionPlanReport.cs:916 | if (siMain.ActiveSheet.RowCount > 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ for (row <= lastRowIdx) ▸ if (startTotal == f… | GRID_STYLE | siMain.SetBGColor | (subTotalStartRow, lastCol, subTotalendRow, lastCol, Color.LightGray) | 그리드 표시 설정 |  |  |  |

## SCP0081_ProductionPlanReport.RefreshBucket

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae104ef4 | this.Load | SCP0081_ProductionPlanReport.cs:427 |  | FLAG | dtBucketType | Data.Common(Data.Type.BucketType, false) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 화면 필드/플래그 변경 |  |  |  |
| AC-000e7ba1 | this.Load | SCP0081_ProductionPlanReport.cs:427 |  | COMBO_DATA | Data.Common | (Data.Type.BucketType, false) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-89009f6f | this.Load | SCP0081_ProductionPlanReport.cs:428 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cmbBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0081_ProductionPlanReport.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58e84dfe | this.Load | SCP0081_ProductionPlanReport.cs:377 |  | FLAG | dtDivision | BLUtils.GetDivision(false) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b65c4e6 | this.Load | SCP0081_ProductionPlanReport.cs:377 |  | CALL_EXT | BLUtils.GetDivision | (false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1674635 | this.Load | SCP0081_ProductionPlanReport.cs:378 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cmbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0081_ProductionPlanReport.RefreshLine

진입점: this.Load / this.cmbDivision.SelectedIndexChanged / this.cmbOperationGroup.SelectedIndexChanged / this.cmbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1aa0dd87 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:408 | if (this._isEE) | FLAG | dtLine | DBUtils.Filter(dtLineEEAll, "DIVISION_ID = '" + this._division + "' AND" + filterOperation… | 화면 필드/플래그 변경 |  |  |  |
| AC-0a9bf06b | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:408 | if (this._isEE) | DATA_OP | DBUtils.Filter | (dtLineEEAll, "DIVISION_ID = '" + this._division + "' AND" + filterOperationValues + filte… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fbbc0fab | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:413 | else of (this._isEE) | FLAG | dtLine | DBUtils.Filter(dtLineAll, "DIVISION_ID = '" + this._division + "'" + filterPlantValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-d0e65de7 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:413 | else of (this._isEE) | DATA_OP | DBUtils.Filter | (dtLineAll, "DIVISION_ID = '" + this._division + "'" + filterPlantValues) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-002420e7 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:416 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, cmbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0081_ProductionPlanReport.RefreshOperation

진입점: this.Load / this.cmbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d55ad95 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:383 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cmbOperationGroup, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0081_ProductionPlanReport.RefreshPlant

진입점: this.Load / this.cmbDivision.SelectedIndexChanged / this.cmbOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b8d1080 | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:388 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cmbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0081_ProductionPlanReport.RefreshVersion

진입점: this.Load / this.cmbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1f44c796 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:420 |  | FLAG | dtVersion | DBUtils.Filter(dtVersionBuff, "DIVISION_ID = '" + this._division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-219aa6a2 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:420 |  | DATA_OP | DBUtils.Filter | (dtVersionBuff, "DIVISION_ID = '" + this._division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3d1179db | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:422 |  | LIST_REBIND | clsCtrl.setListBox | (dtVersion, cmbVersion, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0081_ProductionPlanReport.SetChangedControl

진입점: this.Load / this.cmbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0137e96c | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:503 |  | VALUE_SET | dCalendar.InitValue | DateUtil.GetDayRange(this._division, cmbBucketType.ControlValues, sToday) | 컨트롤 값 설정 |  |  |  |
| AC-61f1541e | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:503 |  | CALL_EXT | DateUtil.GetDayRange | (this._division, cmbBucketType.ControlValues, sToday) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0081_ProductionPlanReport.SetOperationGroupByDivision

진입점: this.Load / this.cmbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39019f1c | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:348 | if (this._isEE) | FLAG | dtOperation | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-4f6af9cd | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:348 | if (this._isEE) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bde12ab1 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:352 | else of (this._isEE) | FLAG | dtOperation | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-f3a0afd3 | this.Load 외 1 | SCP0081_ProductionPlanReport.cs:352 | else of (this._isEE) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## SCP0081_ProductionPlanReport.SetPlantSiteByDivision

진입점: this.Load / this.cmbDivision.SelectedIndexChanged / this.cmbOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2dbc5dd | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:362 | if (this._isEE) | FLAG | dtPlant | DBUtils.Filter(dtPlantEEAll, "DIVISION_ID = '" + this._division + "'" + filterExpression) | 화면 필드/플래그 변경 |  |  |  |
| AC-8aa25e5c | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:362 | if (this._isEE) | DATA_OP | DBUtils.Filter | (dtPlantEEAll, "DIVISION_ID = '" + this._division + "'" + filterExpression) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-db07da39 | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:366 | else of (this._isEE) | FLAG | dtPlant | DBUtils.Filter(dtPlantAll, "DIVISION_ID = '" + this._division + "'" + filterExpression) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d4a7c42 | this.Load 외 2 | SCP0081_ProductionPlanReport.cs:366 | else of (this._isEE) | DATA_OP | DBUtils.Filter | (dtPlantAll, "DIVISION_ID = '" + this._division + "'" + filterExpression) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0081_ProductionPlanReport.SetSpreadColumn

진입점: this.Load / this.cmbBucketType.SelectedIndexChanged [if (fps != null)] / this.chkSum.CheckedChanged [if (fps != null)] / this.rdUOM.CheckedChanged [if (fps != null)] / this.rdCell.CheckedChanged [if (fps != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74aa3bf8 | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:594 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("D_") == 0 \|\| … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | this.IsVisibleCell(colName) | 그리드 속성/값 설정 |  |  |  |
| AC-86ac8955 | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:600 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Daily: ▸ if (colName.IndexOf("M_") == 0 \|\| … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked && this.IsVisibleCell(colName) | 그리드 속성/값 설정 |  |  |  |
| AC-74819945 | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:609 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Weekly: ▸ if (colName.IndexOf("D_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c27de4a9 | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:613 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Weekly: ▸ else of (colName.IndexOf("D_") == 0… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | this.IsVisibleCell(colName) | 그리드 속성/값 설정 |  |  |  |
| AC-d88a36cb | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:618 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Weekly: ▸ if (colName.IndexOf("M_") == 0) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked && this.IsVisibleCell(colName) | 그리드 속성/값 설정 |  |  |  |
| AC-5dd55e25 | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:627 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Monthly: ▸ if (colName.IndexOf("D_") == 0 \|\… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-573de971 | this.Load 외 7 | SCP0081_ProductionPlanReport.cs:631 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cmbBucketType.ControlValues) case BucketType.Monthly: ▸ else of (colName.IndexOf("D_") == … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | this.IsVisibleCell(colName) | 그리드 속성/값 설정 |  |  |  |

## SCP0081_ProductionPlanReport.SetSpreadInit

진입점: this.Load / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-453ddc37 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:532 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-dfe21622 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:534 |  | FLAG | nIdxDataMain | spdInfo.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-9b4a386e | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:535 |  | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-cbb5b11c | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:538 |  | FLAG | nIdxDataMain | spdInfo.GetMaxColumnIndex() + 1 | 화면 필드/플래그 변경 |  |  |  |
| AC-454bb896 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:539 |  | UI_PROP | spdInfo.nIdxData | nIdxDataMain | 속성 nIdxData 설정 |  |  |  |
| AC-c1e3e6a4 | this.Load 외 3 | SCP0081_ProductionPlanReport.cs:544 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

