# AS-IS 액션 대조표 — SCP0069

> 원천: `Doc/asisfacts/screens/SCP0069/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 439행 · 메서드 43 · 종류 DATA_OP 167 · FLAG 91 · GRID_INIT 29 · UI_MISC 21 · ENDPOINT 17 · GRID_SET 17 · RETURN 14 · CALL_EXT 13 · POPUP 12 · VALUE_SET 10 · MESSAGE 8 · LIST_REBIND 8 · STATE 8 · GRID_LOCK 8 · UI_PROP 6 · COMBO_DATA 3 · GRID_CLEAR 3 · GRID_BIND 3 · VALIDATE 1 · ⚠ 의미 확인 필요 13


## SCP0069_GlobalPSI_EE.BtnCalculation_Click

진입점: this.BtnCalculation.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-772b07ff | this.BtnCalculation.Click | SCP0069_GlobalPSI_EE.cs:1806 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ for (i < siMain.ActiveSheet.Rows.Count) ▸ if (siMain.DisplayedSheet.GetValue(i, 0) != null) | DATA_OP | ListItem.Add | (siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ITEM_ID)).ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2e9ea945 | this.BtnCalculation.Click | SCP0069_GlobalPSI_EE.cs:1816 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) | FLAG | sItemFormulaList | "'" + string.Join("','", ListDistinctItem.ToArray()) + "'" | 화면 필드/플래그 변경 |  |  |  |
| AC-3ab76a24 | this.BtnCalculation.Click | SCP0069_GlobalPSI_EE.cs:1822 | if (siMain.ActiveSheet.Rows.Count > 0) ▸ else of (iActionChk > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00133", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0069_GlobalPSI_EE.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13ea6b80 | cboPlanDate.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1911 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-5777b70f | cboPlanDate.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1911 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f225e6d1 | cboPlanDate.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1912 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5e159804 | cboPlanDate.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1914 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-02280cb0 | cboPlanDate.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1916 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-50e60364 | cboPlanDate.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1917 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0069_GlobalPSI_EE.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbec28ac | cboPlanSeq.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1925 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0069_GlobalPSI_EE.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d676ec6 | cboPlanType.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1883 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-127692cf | cboPlanType.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1883 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4bf85f2f | cboPlanType.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1884 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-47f0232a | cboPlanType.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1886 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-a21aea5f | cboPlanType.SelectedIndexChanged | SCP0069_GlobalPSI_EE.cs:1889 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0069_GlobalPSI_EE.chkAutoCalculation_CheckedChanged

진입점: this.chkAutoCalculation.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-733b130e | this.chkAutoCalculation.CheckedChanged | SCP0069_GlobalPSI_EE.cs:1896 | if (chkAutoCalculation.Checked) | STATE | BtnCalculation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-de547a0c | this.chkAutoCalculation.CheckedChanged | SCP0069_GlobalPSI_EE.cs:1897 | if (chkAutoCalculation.Checked) | VALUE_SET | BtnCalculation.Text | "자동계산" | 컨트롤 값 설정 |  |  |  |
| AC-a773b934 | this.chkAutoCalculation.CheckedChanged | SCP0069_GlobalPSI_EE.cs:1901 | else of (chkAutoCalculation.Checked) | STATE | BtnCalculation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-fe5ae627 | this.chkAutoCalculation.CheckedChanged | SCP0069_GlobalPSI_EE.cs:1902 | else of (chkAutoCalculation.Checked) | VALUE_SET | BtnCalculation.Text | "수동계산" | 컨트롤 값 설정 |  |  |  |

## SCP0069_GlobalPSI_EE.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fd2a482 | this.Load | SCP0069_GlobalPSI_EE.cs:263 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f79a1198 | this.Load | SCP0069_GlobalPSI_EE.cs:264 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-79c771e8 | this.Load | SCP0069_GlobalPSI_EE.cs:265 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0069_GlobalPSI_EE.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3acee4e3 | DeleteButton | SCP0069_GlobalPSI_EE.cs:377 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0069_GlobalPSI_EE.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d829778 | Dispose | SCP0069_GlobalPSI_EE.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0069_GlobalPSI_EE.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-428ae481 | EditButton | SCP0069_GlobalPSI_EE.cs:386 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-95e23dd9 | EditButton | SCP0069_GlobalPSI_EE.cs:387 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-5f795250 | EditButton | SCP0069_GlobalPSI_EE.cs:389 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5c89221 | EditButton | SCP0069_GlobalPSI_EE.cs:393 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-794b8a8c | EditButton | SCP0069_GlobalPSI_EE.cs:397 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefCol.DIVISION_ID), row, siMain.GetColumnIndex(DefCol.BOH), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f420103b | EditButton | SCP0069_GlobalPSI_EE.cs:400 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefCol.BOH) + 1, row, siMain.ActiveSheet.ColumnCount - 1, fals… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3a873f86 | EditButton | SCP0069_GlobalPSI_EE.cs:405 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0… | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefCol.BOH), row, siMain.GetColumnIndex(DefCol.BOH), false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a69ad5d9 | EditButton | SCP0069_GlobalPSI_EE.cs:410 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ if (bEdit_Mode == false) | STATE | this.btnNew.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-2397e580 | EditButton | SCP0069_GlobalPSI_EE.cs:415 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain") ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0069_GlobalPSI_EE.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba118150 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:434 |  | POPUP | new ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-59502541 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:440 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-792e0660 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:443 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3260fa2a | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:463 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-12a320ae | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:465 | try | FLAG | dsBinding | await proxyPivot.ExecuteAsync<DataSet>(() => { using (var client = new FoxDataClient(CAppS… | 화면 필드/플래그 변경 |  |  |  |
| AC-32e13559 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:465 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8dbe11fc | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:468 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0069_GET_GLOBAL_PSI_EE") ⇒ SCP.SCP0069_GET_GLOBAL_PSI_EE | 엔드포인트 요청 생성 |  |  |  |
| AC-32cc54f1 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:469 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e5a81997 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:473 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0a3b5623 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:474 | try ▸ lambda | DATA_OP | req.Parameters["p_pgm_code"] | p_pgm_code | 행/컬럼 값 대입 |  |  |  |
| AC-4427305d | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:475 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site_id"] | p_from_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2429c3de | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:476 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-45d3f837 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:477 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-d58fc9b0 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:478 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf2971f9 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:479 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-18a27b1c | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:480 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3a685738 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:481 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-dcfd4369 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:482 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3bc602eb | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:483 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-c22d7282 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:484 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-7d4c173a | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:485 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-42e019fc | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:486 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-17e2e98b | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:496 | try ▸ if (dsBinding.Tables[0].Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ab071a9b | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:499 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b35cfeaf | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:502 | try | CALL_EXT | siMain.AddRows | (siMain.GetMaxRowIndex() + 1, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8523bc8e | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:503 | try | CALL_EXT | spdMain.Sheets[0].SetRowVisible | (siMain.GetMaxRowIndex(), false) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0a862fb8 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:507 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells.Get(siMain.GetMaxRowIndex(), iCol).Value | dsSpdTitle.Tables[0].Rows[iCol - (siMain.GetColumnIndex(DefCol.BOH) + 1)][3].ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-11f81446 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:507 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.ActiveSheet.Cells.Get | (siMain.GetMaxRowIndex(), iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-aaa3d120 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:515 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5169f99c | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:516 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4eb3719f | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:522 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc98610e | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:523 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-94ac5406 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:535 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b1df629 | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:539 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f9bdd29f | FindButton 외 1 | SCP0069_GlobalPSI_EE.cs:541 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0069_GlobalPSI_EE.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a236846f | this.Load | SCP0069_GlobalPSI_EE.cs:192 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0069_GlobalPSI_EE.Get_All_Measure_Idx

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0)] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0)] / FindButton [try ▸ if (chkAutoCalculation.Checked)] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e181c11 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:704 |  | DATA_OP | dt.Columns.Add | ("SUPPLY_SITE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ae4b6334 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:705 |  | DATA_OP | dt.Columns.Add | ("ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c8a6fec | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:706 |  | DATA_OP | dt.Columns.Add | ("ELECTRODE_TYPE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-78d066d1 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:707 |  | DATA_OP | dt.Columns.Add | ("MEASURE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cbdfad3 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:708 |  | DATA_OP | dt.Columns.Add | ("MEASURE_VALUE2_LABEL", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e884db89 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:709 |  | DATA_OP | dt.Columns.Add | ("CELL_ITEM_ID", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2a45117 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:710 |  | DATA_OP | dt.Columns.Add | ("PX", typeof(int)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc5c6afe | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:727 | for (iRow < spdMain.ActiveSheet.RowCount) ▸ if (measure.Equals(DefMeasure.SHIP_PLAN_TOTAL) \|\| measure.Equals(DefMeasure.SHIP_PLAN) \|\| me… | DATA_OP | dt.Rows.Add | (supply_site, itemid, electrode_type, measure, measure_value2_label, cell_item_id, iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-016eced7 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:731 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0069_GlobalPSI_EE.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3ea6f90 | this.Load | SCP0069_GlobalPSI_EE.cs:1857 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-1a678893 | this.Load | SCP0069_GlobalPSI_EE.cs:1858 |  | FLAG | dt | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-8f3a079b | this.Load | SCP0069_GlobalPSI_EE.cs:1858 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c51bbf8 | this.Load | SCP0069_GlobalPSI_EE.cs:1860 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0069_GlobalPSI_EE.GetComboInfo

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eab32a8e | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1835 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0069_GET_PLANT_EE") ⇒ SCP.SCP0069_GET_PLANT_EE | 엔드포인트 요청 생성 |  |  |  |
| AC-436c538c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1836 |  | FLAG | dtPlant | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-722ab10f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1836 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9ce9bff | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1838 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32631db9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1839 |  | FLAG | dtPlanDate | ViewDate.ToTable(true, new string[] { "code","name" }) | 화면 필드/플래그 변경 |  |  |  |
| AC-d59bf0a4 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1839 |  | DATA_OP | ViewDate.ToTable | (true, new string[] { "code","name" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3c3bb96 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1841 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-55874585 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1842 |  | FLAG | dtPlanType | ViewType.ToTable(true, new string[] { "code", "name" }) | 화면 필드/플래그 변경 |  |  |  |
| AC-e34e357f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… | SCP0069_GlobalPSI_EE.cs:1842 |  | DATA_OP | ViewType.ToTable | (true, new string[] { "code", "name" }) | 데이터 객체 조작/조회 |  |  |  |

## SCP0069_GlobalPSI_EE.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3b687f0 | this.Load 외 1 | SCP0069_GlobalPSI_EE.cs:1849 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0bbbcbed | this.Load 외 1 | SCP0069_GlobalPSI_EE.cs:1850 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0069_GlobalPSI_EE.GetSpdTitle

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count < 1)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count < 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20ab3d47 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:1869 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0069_GET_SPREAD_TITLE") ⇒ SCP.SCP0069_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-1050e6a7 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:1870 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | sDate[0] | 행/컬럼 값 대입 |  |  |  |
| AC-8a37a022 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:1871 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | sDate[1] | 행/컬럼 값 대입 |  |  |  |
| AC-7e8a4b29 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:1873 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-81a236c7 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:1873 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0069_GlobalPSI_EE.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74297a87 | this.Load | SCP0069_GlobalPSI_EE.cs:214 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-70fc655e | this.Load | SCP0069_GlobalPSI_EE.cs:215 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-70c72064 | this.Load | SCP0069_GlobalPSI_EE.cs:216 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-bbd22b01 | this.Load | SCP0069_GlobalPSI_EE.cs:218 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-45268ab4 | this.Load | SCP0069_GlobalPSI_EE.cs:220 |  | FLAG | dtDivision | BLUtils.GetDivision(false, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-5a3ada2f | this.Load | SCP0069_GlobalPSI_EE.cs:220 |  | CALL_EXT | BLUtils.GetDivision | (false, "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8cb0dc2 | this.Load | SCP0069_GlobalPSI_EE.cs:222 |  | DATA_OP | dtDivision.Select | ("CODE= 'EE'") | 데이터 객체 조작/조회 |  |  |  |
| AC-1286c45e | this.Load | SCP0069_GlobalPSI_EE.cs:223 |  | DATA_OP | dr.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-11e7be03 | this.Load | SCP0069_GlobalPSI_EE.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dt, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-40a5254f | this.Load | SCP0069_GlobalPSI_EE.cs:227 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-903ddfc6 | this.Load | SCP0069_GlobalPSI_EE.cs:228 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ea498942 | this.Load | SCP0069_GlobalPSI_EE.cs:231 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-7efccc6a | this.Load | SCP0069_GlobalPSI_EE.cs:244 |  | STATE | this.btnNew.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1fd71e63 | this.Load | SCP0069_GlobalPSI_EE.cs:246 |  | VALUE_SET | chkAutoCalculation.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-3d222b0a | this.Load | SCP0069_GlobalPSI_EE.cs:251 | if (chkAutoCalculation.Checked) | STATE | BtnCalculation.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-2d916cae | this.Load | SCP0069_GlobalPSI_EE.cs:252 | if (chkAutoCalculation.Checked) | VALUE_SET | BtnCalculation.Text | "자동계산" | 컨트롤 값 설정 |  |  |  |
| AC-99031bbb | this.Load | SCP0069_GlobalPSI_EE.cs:256 | else of (chkAutoCalculation.Checked) | STATE | BtnCalculation.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-4a173555 | this.Load | SCP0069_GlobalPSI_EE.cs:257 | else of (chkAutoCalculation.Checked) | VALUE_SET | BtnCalculation.Text | "수동계산" | 컨트롤 값 설정 |  |  |  |

## SCP0069_GlobalPSI_EE.InitSpread

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count < 1)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count < 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-46599fe5 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:280 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-a24e287e | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:282 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## SCP0069_GlobalPSI_EE.InitSpreadDateColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count < 1)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count < 1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6855dc0 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:301 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | siMain.AddNumColumn | (sColumnLabel, sColumnName, FPMerge.Restricted, 100, true, FPHAlign.Right, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-999f8b20 | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:305 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sSpanLabelName != sSmallLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9034331b | this.Load 외 3 | SCP0069_GlobalPSI_EE.cs:312 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0069_GlobalPSI_EE.InputScript

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30bf1a77 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1593 |  | DATA_OP | dt.Columns.Add | ("ACTIVE_FLAG") | 데이터 객체 조작/조회 |  |  |  |
| AC-30e0911c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1595 |  | DATA_OP | dt.Columns.Add | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa092537 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1596 |  | DATA_OP | dt.Columns.Add | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-86d6f539 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1597 |  | DATA_OP | dt.Columns.Add | ("CREATE_FROM_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-09e7e2b7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1598 |  | DATA_OP | dt.Columns.Add | ("CREATE_TO_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-84162a14 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1599 |  | DATA_OP | dt.Columns.Add | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-612d2087 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1600 |  | DATA_OP | dt.Columns.Add | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-b88f9332 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1601 |  | DATA_OP | dt.Columns.Add | ("CELL_TYPE_GROUP_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-4510f98d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1602 |  | DATA_OP | dt.Columns.Add | ("SUPPLY_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5058396 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1603 |  | DATA_OP | dt.Columns.Add | ("SUPPLY_SITE_DESC") | 데이터 객체 조작/조회 |  |  |  |
| AC-5466c6e7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1604 |  | DATA_OP | dt.Columns.Add | ("NICK_NAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-518a5a01 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1605 |  | DATA_OP | dt.Columns.Add | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8c7abc8f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1606 |  | DATA_OP | dt.Columns.Add | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc44e210 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1608 |  | DATA_OP | dt.Columns.Add | ("TO_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ccae8959 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1609 |  | DATA_OP | dt.Columns.Add | ("TO_SITE_DESCRIPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-9000923c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1610 |  | DATA_OP | dt.Columns.Add | ("LT_WEEK") | 데이터 객체 조작/조회 |  |  |  |
| AC-1f2ebc9b | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1611 |  | DATA_OP | dt.Columns.Add | ("CONVERT_QTY_CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2e28dec | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1612 |  | DATA_OP | dt.Columns.Add | ("PROD_LINE") | 데이터 객체 조작/조회 |  |  |  |
| AC-ee9ef895 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1613 |  | DATA_OP | dt.Columns.Add | ("PSI_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9e5f7929 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1614 |  | DATA_OP | dt.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-59328da0 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1615 |  | DATA_OP | dt.Columns.Add | ("MEASURE_LABEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-2cb80d43 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1616 |  | DATA_OP | dt.Columns.Add | ("MEASURE_VALUE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b652a4a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1617 |  | DATA_OP | dt.Columns.Add | ("MEASURE_VALUE1_LABEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-07ba6356 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1618 |  | DATA_OP | dt.Columns.Add | ("MEASURE_VALUE2") | 데이터 객체 조작/조회 |  |  |  |
| AC-8853fe2d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1619 |  | DATA_OP | dt.Columns.Add | ("MEASURE_VALUE2_LABEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-086defd0 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1621 |  | DATA_OP | dt.Columns.Add | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-052c4ae7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1622 |  | DATA_OP | dt.Columns.Add | ("UNIT") | 데이터 객체 조작/조회 |  |  |  |
| AC-591b563f | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1623 |  | DATA_OP | dt.Columns.Add | ("SORT_ORDER_NO") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c8011a4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1624 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-303cc01a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1625 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE3") | 데이터 객체 조작/조회 |  |  |  |
| AC-d1bbb6b5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1626 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE8") | 데이터 객체 조작/조회 |  |  |  |
| AC-17b9c046 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1627 |  | DATA_OP | dt.Columns.Add | ("ATTRIBUTE9") | 데이터 객체 조작/조회 |  |  |  |
| AC-11eb5dbf | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1628 |  | DATA_OP | dt.Columns.Add | ("XLS_KEY1") | 데이터 객체 조작/조회 |  |  |  |
| AC-f0e8a4d3 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1629 |  | DATA_OP | dt.Columns.Add | ("XLS_ATTRIBUTE1") | 데이터 객체 조작/조회 |  |  |  |
| AC-8311aa17 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1630 |  | DATA_OP | dt.Columns.Add | ("BOH") | 데이터 객체 조작/조회 |  |  |  |
| AC-1ea87fa0 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1632 |  | DATA_OP | dt.Columns.Add | ("USER_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f848266d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1646 | for (iCol < siMain.ActiveSheet.ColumnCount) | DATA_OP | sHeaderWeekName.Contains | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-31fa37ff | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1648 | for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (sHeaderWeekName.Contains("A")) ▸ if (sHeaderWeekName.Length > 1) | DATA_OP | sHeaderWeekName.Remove | (3, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a2dfc2bd | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1652 | for (iCol < siMain.ActiveSheet.ColumnCount) ▸ else of (sHeaderWeekName.Contains("A")) | DATA_OP | sHeaderWeekName.Contains | ("B") | 데이터 객체 조작/조회 |  |  |  |
| AC-eae1aecd | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1661 | for (iCol < siMain.ActiveSheet.ColumnCount) | DATA_OP | dt.Columns.Add | (sb.Insert(1, "QTY").ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-719d6635 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1670 | for (iCol < siMain.ActiveSheet.ColumnCount) ▸ for (iRow < dtCalendar.Rows.Count) ▸ if (sHeaderWeekName.Equals(sWeekNmae)) | DATA_OP | dt.Columns.Add | (sDayNmae) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8cbe0c5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1675 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0069_GlobalPSI_EE.InsertRow

진입점: this.btnNew.Click / InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86aee790 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1683 |  | POPUP | new SCPAnalysisScp0069Popup | () | 팝업/폼 생성 |  |  |  |
| AC-82c02cf3 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1685 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b17b9c28 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1687 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2ac7e30e | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1691 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) | POPUP | new ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-102c5db0 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1693 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0225b9c1 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1711 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | DATA_OP | dsBinding.Tables[0].Select | ("PSI_TYPE='" + sPsiType + "' AND SUPPLY_SITE='" + sSupplySite + "' AND ITEM_ID='" + sItem… | 데이터 객체 조작/조회 |  |  |  |
| AC-8d178bef | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1715 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | CALL_EXT | dsBinding.Tables[0].Select("PSI_TYPE='" + sPsiType + "' AND SUPPLY_SITE='" + sSupplySite +… | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b7e8f582 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1715 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | DATA_OP | dsBinding.Tables[0].Select | ("PSI_TYPE='" + sPsiType + "' AND SUPPLY_SITE='" + sSupplySite + "' AND ITEM_ID='" + sItem… | 데이터 객체 조작/조회 |  |  |  |
| AC-e026b7a2 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1724 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | CALL_EXT | siMain.InsertNewRow | (iItemMaxRow + 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aa6633d | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1727 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | CALL_EXT | siMain.Sheet(0).GetClip | (iItemMaxRow, 0, 1, siMain.GetMaxColumnIndex()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4b04eb03 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1728 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | CALL_EXT | siMain.Sheet(0).SetClip | (iItemMaxRow + 1, 0, 1, siMain.GetMaxColumnIndex(), sCopy) | ⚠ 의미 확인 필요 |  |  |  |
| AC-084af58a | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1733 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) ▸ for (iCol < siMain… | GRID_SET | siMain.SetValue | (iItemMaxRow + 1, iCol, 0.0) | 그리드 값 설정 |  |  |  |
| AC-4f398fa6 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1734 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) ▸ for (iCol < siMain… | GRID_SET | siMain.ActiveSheet.Cells[iItemMaxRow + 1, iCol].ForeColor | Color.Black | 그리드 속성/값 설정 |  |  |  |
| AC-1d1fc0f0 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1739 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | GRID_SET | siMain.SetValue | (iItemMaxRow + 1, siMain.GetColumnIndex(DefCol.XLS_KEY1), iXlsKey1) | 그리드 값 설정 |  |  |  |
| AC-738d93f5 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1740 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | GRID_SET | siMain.SetValue | (iItemMaxRow + 1, siMain.GetColumnIndex(DefCol.MEASURE), DefMeasure.PROD_PLAN_AMEND) | 그리드 값 설정 |  |  |  |
| AC-299f29da | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1741 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | GRID_SET | siMain.SetValue | (iItemMaxRow + 1, siMain.GetColumnIndex(DefCol.MEASURE_VALUE1_LABEL), sMeasureValue1Label) | 그리드 값 설정 |  |  |  |
| AC-22c40ead | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1744 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ foreach (var item in popup.ChkInfoList) | GRID_LOCK | siMain.LockRange | (iItemMaxRow + 1, 1, iItemMaxRow + 1, siMain.GetColumnIndex(DefCol.BOH), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a1529b49 | this.btnNew.Click 외 1 | SCP0069_GlobalPSI_EE.cs:1750 | if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0069_GlobalPSI_EE.INVENTORY_PRE_DIO

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80448efd | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1187 | if (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.INVENTORY_PRE_DIO + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-2de54619 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1187 | if (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.INVENTORY_PRE_DIO + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-6bce1363 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1189 | else of (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.INVENTORY_PRE_DIO + "' AND ITEM_ID IN(" + sItemFormul… | 화면 필드/플래그 변경 |  |  |  |
| AC-8a1732cc | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1189 | else of (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.INVENTORY_PRE_DIO + "' AND ITEM_ID IN(" + sItemFormulaList + "… | 데이터 객체 조작/조회 |  |  |  |
| AC-14a1b89f | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1195 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sSupply_Site | row["SUPPLY_SITE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1929f1e5 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1196 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sItem | row["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4728f56e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1197 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sElectrode_Type | row["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-95056c59 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1198 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | iStdIdx | Convert.ToInt32(row["PX"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-1d4a5ee6 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1200 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | dr2 | dt.Select("MEASURE='" + DefMeasure.Y_SUM + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND I… | 화면 필드/플래그 변경 |  |  |  |
| AC-c181ef0e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1200 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.Y_SUM + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND ITEM_ID='"… | 데이터 객체 조작/조회 |  |  |  |
| AC-5ff9574f | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1206 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (iCol < siMain.GetMaxColumnIndex() - 1) | DATA_OP | dt.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f9d4d452 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1284 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (iCol < siMain.GetMaxColumnIndex() - 1) ▸ if (!string.IsNullOrEmpty(sFormulaText)) | GRID_SET | spdMain.ActiveSheet.Cells[iStdIdx, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0069_GlobalPSI_EE.INVENTORY_TOTAL

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fa6a8e8 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1019 |  | FLAG | sCondition | "\"" + "=INVENTORY_BOH" + "\"" | 화면 필드/플래그 변경 |  |  |  |
| AC-f165361b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1024 | if (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.INVENTORY_TOTAL + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-98a083cd | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1024 | if (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.INVENTORY_TOTAL + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-02dc34e3 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1026 | else of (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.INVENTORY_TOTAL + "' AND ITEM_ID IN(" + sItemFormulaL… | 화면 필드/플래그 변경 |  |  |  |
| AC-f7e2b304 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1026 | else of (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.INVENTORY_TOTAL + "' AND ITEM_ID IN(" + sItemFormulaList + ")"… | 데이터 객체 조작/조회 |  |  |  |
| AC-15fa7b90 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1032 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sSupply_Site | row["SUPPLY_SITE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8d69f8db | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1033 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sItem | row["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-079ef4b2 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1034 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sElectrode_Type | row["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-88079521 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1035 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | iStdIdx | Convert.ToInt32(row["PX"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-52e72745 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1040 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | dr2 | dt.Select("MEASURE='" + DefMeasure.INVENTORY_BOH + "' AND SUPPLY_SITE='" + sSupply_Site + … | 화면 필드/플래그 변경 |  |  |  |
| AC-2625c9f9 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1040 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.INVENTORY_BOH + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND IT… | 데이터 객체 조작/조회 |  |  |  |
| AC-c4de34db | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1045 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | dt2 | dr2.CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-98bd7271 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1045 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dr2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c55c37b5 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1047 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | iMin | Convert.ToInt32(dt2.Compute("min(PX)", null)) | 화면 필드/플래그 변경 |  |  |  |
| AC-cafab7a3 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1047 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dt2.Compute | ("min(PX)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-dd621395 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1048 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | iMax | Convert.ToInt32(dt2.Compute("max(PX)", null)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a9e0a82c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1048 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dt2.Compute | ("max(PX)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-0a1b2e11 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1051 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | cConfMinIdx | siMain.ActiveSheet.Cells[iMin, iCol_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-490420af | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1052 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | cConfMaxIdx | siMain.ActiveSheet.Cells[iMax, iCol_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-cf35f8fe | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1055 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | cMinIdx | siMain.ActiveSheet.Cells[iMin, iCol_BOH] | 화면 필드/플래그 변경 |  |  |  |
| AC-9cc7f780 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1056 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | cMaxIdx | siMain.ActiveSheet.Cells[iMax, iCol_BOH] | 화면 필드/플래그 변경 |  |  |  |
| AC-8556f5e7 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1058 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | GRID_SET | spdMain.ActiveSheet.Cells[iStdIdx, iCol_BOH].Formula | "SUMIF(" + cConfMinIdx.ToString() + ":" + cConfMaxIdx.ToString() + "," + sCondition + "," … | 그리드 속성/값 설정 |  |  |  |
| AC-f3bcf1e1 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1091 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | iStdIdx | Convert.ToInt32(row["PX"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-f73e592c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1093 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sSupply_Site | row["SUPPLY_SITE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a30017a4 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1094 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sItem | row["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fd375d30 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1095 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sElectrode_Type | row["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a4ff439d | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1108 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (j < siMain.ActiveSheet.Columns.Count) | FLAG | dr2 | dt.Select("MEASURE='" + DefMeasure.PROD_PLAN_TOTAL + "' AND SUPPLY_SITE='" + sSupply_Site … | 화면 필드/플래그 변경 |  |  |  |
| AC-cef1b23e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1108 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (j < siMain.ActiveSheet.Columns.Count) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.PROD_PLAN_TOTAL + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND … | 데이터 객체 조작/조회 |  |  |  |
| AC-ef59c1d8 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1120 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (j < siMain.ActiveSheet.Columns.Count) | FLAG | dr3 | dt.Select("MEASURE='" + DefMeasure.Y_SUM + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND I… | 화면 필드/플래그 변경 |  |  |  |
| AC-24ba987c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1120 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (j < siMain.ActiveSheet.Columns.Count) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.Y_SUM + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND ITEM_ID='"… | 데이터 객체 조작/조회 |  |  |  |
| AC-98b8101b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:1133 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (j < siMain.ActiveSheet.Columns.Count) | GRID_SET | spdMain.ActiveSheet.Cells[iStdIdx, j].Formula | "(" + sFormulaText + ")" | 그리드 속성/값 설정 |  |  |  |

## SCP0069_GlobalPSI_EE.PROD_PLAN_TOTAL

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6fc3b36b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:837 |  | FLAG | dt2 | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a6f08b6c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:839 |  | FLAG | sCondition | "\"" + "=PROD_PLAN_AMEND" + "\"" | 화면 필드/플래그 변경 |  |  |  |
| AC-ec9956a8 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:842 | if (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.PROD_PLAN_TOTAL + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-dc4dd7bc | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:842 | if (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.PROD_PLAN_TOTAL + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1548787 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:845 | else of (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.PROD_PLAN_TOTAL + "' AND ITEM_ID IN(" + sItemFormulaL… | 화면 필드/플래그 변경 |  |  |  |
| AC-bc4f2b87 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:845 | else of (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.PROD_PLAN_TOTAL + "' AND ITEM_ID IN(" + sItemFormulaList + ")"… | 데이터 객체 조작/조회 |  |  |  |
| AC-4313d182 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:851 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sSupply_Site | row["SUPPLY_SITE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3d2a003a | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:852 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sItem | row["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-75f8fb7e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:853 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sElectrode_Type | row["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-77891b32 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:855 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | iStdIdx | Convert.ToInt32(row["PX"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-b71b30b0 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:858 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | dr2 | dt.Select("MEASURE='" + DefMeasure.PROD_PLAN_AMEND + "' AND SUPPLY_SITE='" + sSupply_Site … | 화면 필드/플래그 변경 |  |  |  |
| AC-bce3f043 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:858 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.PROD_PLAN_AMEND + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND … | 데이터 객체 조작/조회 |  |  |  |
| AC-d01639a7 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:863 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | dt2 | dr2.CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-94e75042 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:863 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dr2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5836ebdd | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:865 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | iMin | Convert.ToInt32(dt2.Compute("min(PX)", null)) | 화면 필드/플래그 변경 |  |  |  |
| AC-68885cfa | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:865 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dt2.Compute | ("min(PX)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-722c12f2 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:866 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | iMax | Convert.ToInt32(dt2.Compute("max(PX)", null)) | 화면 필드/플래그 변경 |  |  |  |
| AC-599b1342 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:866 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dt2.Compute | ("max(PX)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-18a8a4f9 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:869 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | cConfMinIdx | siMain.ActiveSheet.Cells[iMin, iCol_Measure] | 화면 필드/플래그 변경 |  |  |  |
| AC-a81959ef | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:870 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | cConfMaxIdx | siMain.ActiveSheet.Cells[iMax, iCol_Measure] | 화면 필드/플래그 변경 |  |  |  |

## SCP0069_GlobalPSI_EE.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e534d21d | SaveButton | SCP0069_GlobalPSI_EE.cs:1295 |  | POPUP | new ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c04b233a | SaveButton | SCP0069_GlobalPSI_EE.cs:1312 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-777dab50 | SaveButton | SCP0069_GlobalPSI_EE.cs:1315 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-8b618992 | SaveButton | SCP0069_GlobalPSI_EE.cs:1315 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10414bb1 | SaveButton | SCP0069_GlobalPSI_EE.cs:1323 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (SaveInputDT) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7b8d315 | SaveButton | SCP0069_GlobalPSI_EE.cs:1342 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec1267cb | SaveButton | SCP0069_GlobalPSI_EE.cs:1371 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ACTIVE_FLAG"] | action | 행/컬럼 값 대입 |  |  |  |
| AC-7628f0ba | SaveButton | SCP0069_GlobalPSI_EE.cs:1372 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["DIVISION_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1ed2364a | SaveButton | SCP0069_GlobalPSI_EE.cs:1373 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["PLAN_START_YYYYMMDD"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.PLAN_START_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-94410256 | SaveButton | SCP0069_GlobalPSI_EE.cs:1374 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["CREATE_FROM_YYYYMMDD"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.CREATE_FROM_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-aa8431f2 | SaveButton | SCP0069_GlobalPSI_EE.cs:1375 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["CREATE_TO_YYYYMMDD"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.CREATE_TO_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-63fdf3d4 | SaveButton | SCP0069_GlobalPSI_EE.cs:1377 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["PLAN_TYPE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.PLAN_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7587f15 | SaveButton | SCP0069_GlobalPSI_EE.cs:1378 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["SEQ"] | Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefCol.SEQ)) ?? 0) | 행/컬럼 값 대입 |  |  |  |
| AC-a5992807 | SaveButton | SCP0069_GlobalPSI_EE.cs:1379 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["CELL_TYPE_GROUP_CODE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.CELL_TYPE_GROUP_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c3073e27 | SaveButton | SCP0069_GlobalPSI_EE.cs:1380 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["SUPPLY_SITE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.SUPPLY_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-0ae528e4 | SaveButton | SCP0069_GlobalPSI_EE.cs:1381 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["SUPPLY_SITE_DESC"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.SUPPLY_SITE_DESC)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-97000611 | SaveButton | SCP0069_GlobalPSI_EE.cs:1382 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["NICK_NAME"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.NICK_NAME)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3a67177 | SaveButton | SCP0069_GlobalPSI_EE.cs:1383 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ITEM_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f503960c | SaveButton | SCP0069_GlobalPSI_EE.cs:1384 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ELECTRODE_TYPE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ELECTRODE_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-739aeb24 | SaveButton | SCP0069_GlobalPSI_EE.cs:1386 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["TO_SITE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.TO_SITE_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c081203d | SaveButton | SCP0069_GlobalPSI_EE.cs:1387 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["TO_SITE_DESCRIPTION"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.TO_SITE_DESCRIPTION)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-79717141 | SaveButton | SCP0069_GlobalPSI_EE.cs:1388 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["LT_WEEK"] | Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefCol.LT_WEEK)) ?? 0) | 행/컬럼 값 대입 |  |  |  |
| AC-f7cc928c | SaveButton | SCP0069_GlobalPSI_EE.cs:1389 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["CONVERT_QTY_CELL"] | Convert.ToDecimal(siMain.GetValue(i, siMain.GetColumnIndex(DefCol.CONVERT_QTY_CELL)) ?? 0.… | 행/컬럼 값 대입 |  |  |  |
| AC-a61c0c56 | SaveButton | SCP0069_GlobalPSI_EE.cs:1390 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["PROD_LINE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.PROD_LINE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-2a969dc9 | SaveButton | SCP0069_GlobalPSI_EE.cs:1391 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["PSI_TYPE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.PSI_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ac7c88b3 | SaveButton | SCP0069_GlobalPSI_EE.cs:1392 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["MEASURE"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f7dbcbd9 | SaveButton | SCP0069_GlobalPSI_EE.cs:1393 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["MEASURE_LABEL"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.MEASURE_LABEL)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8af669f2 | SaveButton | SCP0069_GlobalPSI_EE.cs:1394 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["MEASURE_VALUE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.MEASURE_VALUE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ef23973c | SaveButton | SCP0069_GlobalPSI_EE.cs:1395 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["MEASURE_VALUE1_LABEL"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.MEASURE_VALUE1_LABEL)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8196de51 | SaveButton | SCP0069_GlobalPSI_EE.cs:1396 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["MEASURE_VALUE2"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.MEASURE_VALUE2)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-06e34721 | SaveButton | SCP0069_GlobalPSI_EE.cs:1397 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["MEASURE_VALUE2_LABEL"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.MEASURE_VALUE2_LABEL)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07cab52e | SaveButton | SCP0069_GlobalPSI_EE.cs:1399 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["CELL_ITEM_ID"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.CELL_ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9df6bc7e | SaveButton | SCP0069_GlobalPSI_EE.cs:1400 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.UNIT)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a48f56da | SaveButton | SCP0069_GlobalPSI_EE.cs:1401 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["SORT_ORDER_NO"] | Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefCol.SORT_ORDER_NO)) ?? 0) | 행/컬럼 값 대입 |  |  |  |
| AC-823f5a28 | SaveButton | SCP0069_GlobalPSI_EE.cs:1402 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-9701d5d3 | SaveButton | SCP0069_GlobalPSI_EE.cs:1403 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ATTRIBUTE3"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ATTRIBUTE3)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d7596d57 | SaveButton | SCP0069_GlobalPSI_EE.cs:1404 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ATTRIBUTE8"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ATTRIBUTE8)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-61679f7a | SaveButton | SCP0069_GlobalPSI_EE.cs:1405 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["ATTRIBUTE9"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.ATTRIBUTE9)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a6748c00 | SaveButton | SCP0069_GlobalPSI_EE.cs:1406 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["XLS_KEY1"] | Convert.ToInt32(siMain.GetValue(i, siMain.GetColumnIndex(DefCol.XLS_KEY1)) ?? 0) | 행/컬럼 값 대입 |  |  |  |
| AC-d300bac7 | SaveButton | SCP0069_GlobalPSI_EE.cs:1407 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["XLS_ATTRIBUTE1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefCol.XLS_ATTRIBUTE1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-074d0f5d | SaveButton | SCP0069_GlobalPSI_EE.cs:1410 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["BOH"] | string.IsNullOrEmpty(siMain.GetValue(i, siMain.GetColumnIndex(DefCol.BOH)).ToString()) ? 0… | 행/컬럼 값 대입 |  |  |  |
| AC-85b8443e | SaveButton | SCP0069_GlobalPSI_EE.cs:1412 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-695cec4b | SaveButton | SCP0069_GlobalPSI_EE.cs:1419 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | sHeaderCol.Contains | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-ba65d31f | SaveButton | SCP0069_GlobalPSI_EE.cs:1419 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | sHeaderCol.Contains | ("B") | 데이터 객체 조작/조회 |  |  |  |
| AC-8917992d | SaveButton | SCP0069_GlobalPSI_EE.cs:1423 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | sHeaderCol.Remove | (3, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-daa6845a | SaveButton | SCP0069_GlobalPSI_EE.cs:1450 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr[sSaveColNm] | dSUmPatialWeekQty | 행/컬럼 값 대입 |  |  |  |
| AC-810d7227 | SaveButton | SCP0069_GlobalPSI_EE.cs:1457 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr[sSaveColNm] | dCellVal | 행/컬럼 값 대입 |  |  |  |
| AC-66cddefb | SaveButton | SCP0069_GlobalPSI_EE.cs:1466 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | sPatialChk.Contains | ("A") | 데이터 객체 조작/조회 |  |  |  |
| AC-32b3f840 | SaveButton | SCP0069_GlobalPSI_EE.cs:1475 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr[sDayColNm] | dDayValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3f523369 | SaveButton | SCP0069_GlobalPSI_EE.cs:1482 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | sPatialChk.Contains | ("B") | 데이터 객체 조작/조회 |  |  |  |
| AC-5a0e233f | SaveButton | SCP0069_GlobalPSI_EE.cs:1488 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr[sDayColNm] | dDayValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-608e1c36 | SaveButton | SCP0069_GlobalPSI_EE.cs:1497 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) ▸ for… | DATA_OP | dr[sDayColNm] | dDayValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b958aaa0 | SaveButton | SCP0069_GlobalPSI_EE.cs:1508 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i < siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-7bc2ab74 | SaveButton | SCP0069_GlobalPSI_EE.cs:1513 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ff691cf | SaveButton | SCP0069_GlobalPSI_EE.cs:1521 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6a69b699 | SaveButton | SCP0069_GlobalPSI_EE.cs:1530 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | CALL_EXT | sql.AddParameter | ("@SCP0069", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-600b52a1 | SaveButton | SCP0069_GlobalPSI_EE.cs:1531 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | ENDPOINT | sql.ExcuteProcedure | ("SaveGlobalPsiEE") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveGlobalPsiEE] \| SCP… | 엔드포인트 호출 |  |  |  |
| AC-5c1eec77 | SaveButton | SCP0069_GlobalPSI_EE.cs:1534 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fc6fe98c | SaveButton | SCP0069_GlobalPSI_EE.cs:1539 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c592bcff | SaveButton | SCP0069_GlobalPSI_EE.cs:1548 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e558f445 | SaveButton | SCP0069_GlobalPSI_EE.cs:1557 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-896acf21 | SaveButton | SCP0069_GlobalPSI_EE.cs:1558 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-314a1d1d | SaveButton | SCP0069_GlobalPSI_EE.cs:1564 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c747aa2c | SaveButton | SCP0069_GlobalPSI_EE.cs:1571 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0 && !string.IsNullOr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f70a675 | SaveButton | SCP0069_GlobalPSI_EE.cs:1579 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-81bc507c | SaveButton | SCP0069_GlobalPSI_EE.cs:1580 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc2f5e93 | SaveButton | SCP0069_GlobalPSI_EE.cs:1584 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cfdf626d | SaveButton | SCP0069_GlobalPSI_EE.cs:1585 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0069_GlobalPSI_EE.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08ce4049 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1764 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-9f969176 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1765 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-8e1c13f7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1766 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-596c4fda | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1767 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-d86b627a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1768 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-e3d546b4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1769 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-17132bbb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1770 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-53aa853c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0069_GlobalPSI_EE.cs:1772 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0069_GlobalPSI_EE.Set_MeasureColor

진입점: FindButton [try] / EditButton [if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (fps.Name == "spdMain")] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c7d26a0 | FindButton [try] 외 2 | SCP0069_GlobalPSI_EE.cs:575 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5191371 | FindButton [try] 외 2 | SCP0069_GlobalPSI_EE.cs:577 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-1837f765 | FindButton [try] 외 2 | SCP0069_GlobalPSI_EE.cs:589 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-bff4c75e | FindButton [try] 외 2 | SCP0069_GlobalPSI_EE.cs:593 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0069_GlobalPSI_EE.SetCombo

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c4bc955 | this.Load | SCP0069_GlobalPSI_EE.cs:334 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-10bdcf83 | this.Load | SCP0069_GlobalPSI_EE.cs:337 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7f922acf | this.Load | SCP0069_GlobalPSI_EE.cs:341 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5d678967 | this.Load | SCP0069_GlobalPSI_EE.cs:348 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-5af98185 | this.Load | SCP0069_GlobalPSI_EE.cs:351 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-ec2350a7 | this.Load | SCP0069_GlobalPSI_EE.cs:351 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c1e8eb04 | this.Load | SCP0069_GlobalPSI_EE.cs:352 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ed980e4d | this.Load | SCP0069_GlobalPSI_EE.cs:355 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | STATE | cboPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d9553693 | this.Load | SCP0069_GlobalPSI_EE.cs:356 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | STATE | cboPlanType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0069_GlobalPSI_EE.SetCommonFomulaExec

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try ▸ if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0)] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try ▸ if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0)] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try ▸ if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0)] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoLi…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba6e1f68 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:748 | for (j < siMain.ActiveSheet.Columns.Count) ▸ switch (sCategory) case DefMeasure.SHIP_PLAN_TOTAL: | FLAG | cMinIdx | siMain.ActiveSheet.Cells[iMin, j] | 화면 필드/플래그 변경 |  |  |  |
| AC-3d0d7118 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:749 | for (j < siMain.ActiveSheet.Columns.Count) ▸ switch (sCategory) case DefMeasure.SHIP_PLAN_TOTAL: | FLAG | cMaxIdx | siMain.ActiveSheet.Cells[iMax, j] | 화면 필드/플래그 변경 |  |  |  |
| AC-397b04ba | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:752 | for (j < siMain.ActiveSheet.Columns.Count) ▸ switch (sCategory) case DefMeasure.SHIP_PLAN_TOTAL: | GRID_SET | spdMain.ActiveSheet.Cells[iStdIdx, j].Formula | "SUM(" + cMinIdx.ToString() + ":" + cMaxIdx.ToString() + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-91807f29 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:759 | for (j < siMain.ActiveSheet.Columns.Count) ▸ switch (sCategory) case DefMeasure.PROD_PLAN_TOTAL: | FLAG | cMinIdx | siMain.ActiveSheet.Cells[iMin, j] | 화면 필드/플래그 변경 |  |  |  |
| AC-6c25ee1f | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:760 | for (j < siMain.ActiveSheet.Columns.Count) ▸ switch (sCategory) case DefMeasure.PROD_PLAN_TOTAL: | FLAG | cMaxIdx | siMain.ActiveSheet.Cells[iMax, j] | 화면 필드/플래그 변경 |  |  |  |
| AC-390ea57e | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:764 | for (j < siMain.ActiveSheet.Columns.Count) ▸ switch (sCategory) case DefMeasure.PROD_PLAN_TOTAL: | GRID_SET | spdMain.ActiveSheet.Cells[iStdIdx, j].Formula | "SUMIF(" + cConfMinIdx.ToString() + ":" + cConfMaxIdx.ToString() + "," + sCondition + "," … | 그리드 속성/값 설정 |  |  |  |

## SCP0069_GlobalPSI_EE.SetFormulaLowFormat

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b5488fd | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:554 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b933018a | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:556 |  | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.ETC_YIELD + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-b0b0b579 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:556 |  | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.ETC_YIELD + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-97207224 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:566 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | UI_PROP | range1.CellType | percentCellType | 속성 CellType 설정 |  |  |  |
| AC-bb058f9f | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 5 | SCP0069_GlobalPSI_EE.cs:570 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0069_GlobalPSI_EE.SetFormulas

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0)] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0)] / FindButton [try ▸ if (chkAutoCalculation.Checked)] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result …

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78fe7f69 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:599 | if (siMain.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e2b16a20 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:602 |  | FLAG | dt | Get_All_Measure_Idx() | 화면 필드/플래그 변경 |  |  |  |
| AC-0845d663 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:603 | if (dt.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47d589bb | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:605 |  | POPUP | new ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c913f0df | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:609 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-bf7beb63 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:621 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da1d0ca6 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:625 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0069_GlobalPSI_EE.SetFormulas_2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b630455 | (진입점 미연결) | SCP0069_GlobalPSI_EE.cs:632 | if (siMain.ActiveSheet.Rows.Count < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-396e378a | (진입점 미연결) | SCP0069_GlobalPSI_EE.cs:637 |  | FLAG | dt | Get_All_Measure_Idx() | 화면 필드/플래그 변경 |  |  |  |
| AC-d84a4a59 | (진입점 미연결) | SCP0069_GlobalPSI_EE.cs:638 | if (dt.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-634a4a28 | (진입점 미연결) | SCP0069_GlobalPSI_EE.cs:640 |  | POPUP | new ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f5ecf3ea | (진입점 미연결) | SCP0069_GlobalPSI_EE.cs:641 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d0440df0 | (진입점 미연결) | SCP0069_GlobalPSI_EE.cs:690 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0069_GlobalPSI_EE.SetSpreadInit

진입점: FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString())) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c71bd595 | FindButton [try] 외 1 | SCP0069_GlobalPSI_EE.cs:271 |  | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5afa6eb2 | FindButton [try] 외 1 | SCP0069_GlobalPSI_EE.cs:272 |  | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-b68f2f54 | FindButton [try] 외 1 | SCP0069_GlobalPSI_EE.cs:275 |  | GRID_INIT | siObj.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0069_GlobalPSI_EE.SHIP_PLAN_TOTAL

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb2a6c18 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:784 | if (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.SHIP_PLAN_TOTAL + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-f12a83e6 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:784 | if (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.SHIP_PLAN_TOTAL + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-4620b6cd | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:787 | else of (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.SHIP_PLAN_TOTAL + "' AND ITEM_ID IN(" + sItemFormulaL… | 화면 필드/플래그 변경 |  |  |  |
| AC-81df92ba | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:787 | else of (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.SHIP_PLAN_TOTAL + "' AND ITEM_ID IN(" + sItemFormulaList + ")"… | 데이터 객체 조작/조회 |  |  |  |
| AC-27413bb3 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:793 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sSupply_Site | row["SUPPLY_SITE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-3a6a197b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:794 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sItem | row["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-88e564d1 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:795 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sElectrode_Type | row["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-ff80b819 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:797 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | iStdIdx | Convert.ToInt32(row["PX"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b3d75fc | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:800 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | dr2 | dt.Select("MEASURE='" + DefMeasure.SHIP_PLAN + "' AND SUPPLY_SITE='" + sSupply_Site + "' A… | 화면 필드/플래그 변경 |  |  |  |
| AC-4faf30a7 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:800 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.SHIP_PLAN + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND ITEM_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-0a395b3b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:805 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | dt2 | dr2.CopyToDataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-35559831 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:805 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dr2.CopyToDataTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2f96905 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:807 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | iMin | Convert.ToInt32(dt2.Compute("min(PX)", null)) | 화면 필드/플래그 변경 |  |  |  |
| AC-a482b37b | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:807 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dt2.Compute | ("min(PX)", null) | 데이터 객체 조작/조회 |  |  |  |
| AC-fc13f018 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:808 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | FLAG | iMax | Convert.ToInt32(dt2.Compute("max(PX)", null)) | 화면 필드/플래그 변경 |  |  |  |
| AC-0e46ea75 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:808 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ if (dr2.Length > 0) | DATA_OP | dt2.Compute | ("max(PX)", null) | 데이터 객체 조작/조회 |  |  |  |

## SCP0069_GlobalPSI_EE.Y_SUM

진입점: this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / this.BtnCalculation.Click [if (siMain.ActiveSheet.Rows.Count > 0) ▸ if (iActionChk > 0) ▸ if (sItemFormulaList.Length > 0) ▸ try] / FindButton [try ▸ if (chkAutoCalculation.Checked) ▸ try] / InsertButton [if (popup.ShowDialog() == DialogResult.OK) ▸ if (popup.ChkInfoList.Count > 0) ▸ try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0 && !string.IsNullOrEmpty(dsInput.Tables[0].Rows[0]["DIVISION_ID"].ToString…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8886237 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:923 |  | FLAG | dt2 | null | 화면 필드/플래그 변경 |  |  |  |
| AC-ad607507 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:928 | if (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.Y_SUM + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-e4c17eeb | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:928 | if (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.Y_SUM + "'") | 데이터 객체 조작/조회 |  |  |  |
| AC-c05931d9 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:930 | else of (chkAutoCalculation.Checked) | FLAG | dr1 | dt.Select("MEASURE = '" + DefMeasure.Y_SUM + "' AND ITEM_ID IN(" + sItemFormulaList + ")") | 화면 필드/플래그 변경 |  |  |  |
| AC-19383727 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:930 | else of (chkAutoCalculation.Checked) | DATA_OP | dt.Select | ("MEASURE = '" + DefMeasure.Y_SUM + "' AND ITEM_ID IN(" + sItemFormulaList + ")") | 데이터 객체 조작/조회 |  |  |  |
| AC-96ed0f45 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:936 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sSupply_Site | row["SUPPLY_SITE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-274da03c | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:937 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sItem | row["ITEM_ID"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-acff9f5d | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:938 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | sElectrode_Type | row["ELECTRODE_TYPE"].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-595567a6 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:940 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | iStdIdx | Convert.ToInt32(row["PX"].ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-edc36ddb | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:943 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | dr2 | dt.Select("MEASURE='" + DefMeasure.SHIP_PLAN + "' AND SUPPLY_SITE='" + sSupply_Site + "' A… | 화면 필드/플래그 변경 |  |  |  |
| AC-ee4ad4e3 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:943 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.SHIP_PLAN + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND ITEM_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-7d1593a4 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:944 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | FLAG | dr3 | dt.Select("MEASURE='" + DefMeasure.ETC_YIELD + "' AND SUPPLY_SITE='" + sSupply_Site + "' A… | 화면 필드/플래그 변경 |  |  |  |
| AC-d299df67 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:944 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) | DATA_OP | dt.Select | ("MEASURE='" + DefMeasure.ETC_YIELD + "' AND SUPPLY_SITE='" + sSupply_Site + "' AND ITEM_I… | 데이터 객체 조작/조회 |  |  |  |
| AC-a2821089 | this.btnNew.Click [if (popup.ShowDialog() == DialogResult.OK… 외 4 | SCP0069_GlobalPSI_EE.cs:995 | if (dr1.Length > 0) ▸ foreach (DataRow row in dr1) ▸ for (j < siMain.ActiveSheet.Columns.Count) ▸ if (!string.IsNullOrEmpty(sFormulaText) &&… | GRID_SET | spdMain.ActiveSheet.Cells[iStdIdx, j].Formula | "(" + sFormulaText + "/" + sFormulaTmpStd + ")" | 그리드 속성/값 설정 |  |  |  |

## SCPAnalysisScp0069Popup.ChangeAllCheckboxes

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29871244 | this.spdMain.CellClick | SCPAnalysisScp0069Popup.cs:255 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.IsLockCell | (i, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a40dfec7 | this.spdMain.CellClick | SCPAnalysisScp0069Popup.cs:258 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) | CALL_EXT | spread.ActiveSheet.GetRowVisible | (i) | ⚠ 의미 확인 필요 |  |  |  |
| AC-12a55a71 | this.spdMain.CellClick | SCPAnalysisScp0069Popup.cs:259 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ if (spread.ActiveSheet.… | GRID_SET | spread.SetText | (i, 0, AllCheck.ToString()) | 그리드 값 설정 |  |  |  |
| AC-4c8474d6 | this.spdMain.CellClick | SCPAnalysisScp0069Popup.cs:261 | if (nRow >= 0 && bColumnHeader && spread.GetColumnTag(nColumn).Equals("CHK")) ▸ for (i <= spread.GetMaxRowIndex()) ▸ else of (spread.ActiveS… | GRID_SET | spread.SetText | (i, 0, false.ToString()) | 그리드 값 설정 |  |  |  |

## SCPAnalysisScp0069Popup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b5ed193 | this.Load | SCPAnalysisScp0069Popup.cs:105 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-77189bc2 | this.Load | SCPAnalysisScp0069Popup.cs:107 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ed6f5180 | this.Load | SCPAnalysisScp0069Popup.cs:108 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-50bcc4e7 | this.Load | SCPAnalysisScp0069Popup.cs:109 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d899192 | this.Load | SCPAnalysisScp0069Popup.cs:112 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-079fd4ae | this.Load | SCPAnalysisScp0069Popup.cs:113 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, spdSub.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-27122edb | this.Load | SCPAnalysisScp0069Popup.cs:114 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCPAnalysisScp0069Popup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27156485 | Dispose | SCPAnalysisScp0069Popup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCPAnalysisScp0069Popup.FindData

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c0dc42a2 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:179 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5d15c44d | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:183 | lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0069_LOOKUP_DATA") ⇒ SCP.SCP0069_LOOKUP_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-42dd38ae | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:184 | lambda | DATA_OP | request.Parameters["p_division_id"] | "EE" | 행/컬럼 값 대입 |  |  |  |
| AC-f052f06a | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:185 | lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-6cdac929 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:186 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4eca4b58 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:188 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-951487aa | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:196 |  | FLAG | dtMain | view.ToTable(true, new string[] { "SUPPLY_SITE", "ITEM_ID", "LINE_ID" }) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6f8415a | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:196 |  | DATA_OP | view.ToTable | (true, new string[] { "SUPPLY_SITE", "ITEM_ID", "LINE_ID" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-190f4e76 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:199 |  | FLAG | dtSub | view.ToTable(true, new string[] { "MEASURE", "ITEM_ID", "WORKING_TIME", "TACT_TIME" }) | 화면 필드/플래그 변경 |  |  |  |
| AC-a73200b2 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:199 |  | DATA_OP | view.ToTable | (true, new string[] { "MEASURE", "ITEM_ID", "WORKING_TIME", "TACT_TIME" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f94f5e3 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:202 |  | GRID_BIND | siMain.Query | (dtMain) | 그리드에 조회 결과 바인딩 |  |  |  |

## SCPAnalysisScp0069Popup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3e15251 | this.Load | SCPAnalysisScp0069Popup.cs:92 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCPAnalysisScp0069Popup.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e20b6e7c | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:129 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-de1e15f3 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:130 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddCheckColumn | (DefColumns.CHK, DefColumns.CHK, FPMerge.None, 25, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0d000332 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:131 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("SUPPLY_SITE", DefColumns.SUPPLY_SITE, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b0f3b421 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:132 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("ITEM_ID", DefColumns.ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b03f94b | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:133 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.AddTextColumn | ("LINE_ID", DefColumns.LINE_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6cc64f3 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:134 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d03fb6a7 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:142 | if (sheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-d2217dc4 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:143 | if (sheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-5d7cd9e7 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:144 | if (sheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, spread.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-032207f4 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:146 | if (sheetName == SpdSheet.shtMain) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-44441743 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:151 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtSub) | GRID_INIT | siSub.InitSheet | (siSub.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-998df4e3 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:152 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | ("MEASURE", DefColumns.MEASURE, FPMerge.None, 130, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31c1eab1 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:153 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | ("ITEM_ID", DefColumns.ITEM_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21d943a9 | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:154 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | ("WORKING_TIME", DefColumns.WORKING_TIME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c137ebaa | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:155 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtSub) | GRID_INIT | siSub.AddTextColumn | ("TACT_TIME", DefColumns.TACT_TIME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52a8809c | this.Load 외 1 | SCPAnalysisScp0069Popup.cs:156 | else of (sheetName == SpdSheet.shtMain) ▸ if (sheetName == SpdSheet.shtSub) | GRID_INIT | siSub.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCPAnalysisScp0069Popup.SaveData

진입점: btnSave.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4465fa27 | btnSave.Click | SCPAnalysisScp0069Popup.cs:216 | for (i <= siMain.GetMaxRowIndex()) ▸ if (chk.Equals("True")) | DATA_OP | lstChkInfo.Add | (new ChkList() { SUPPLY_SITE = siMain.GetText(i, siMain.GetColumnIndex(DefColumns.SUPPLY_S… | 데이터 객체 조작/조회 |  |  |  |
| AC-eee0477a | btnSave.Click | SCPAnalysisScp0069Popup.cs:225 |  | FLAG | ChkInfoList | lstChkInfo | 화면 필드/플래그 변경 |  |  |  |
| AC-79fc0624 | btnSave.Click | SCPAnalysisScp0069Popup.cs:228 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCPAnalysisScp0069Popup.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-552468f8 | spdMain.CellDoubleClick | SCPAnalysisScp0069Popup.cs:276 |  | DATA_OP | dtSub.AsEnumerable().Where(row => row.Field<String>("ITEM_ID") == sItemID).OrderByDescendi… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6da098c7 | spdMain.CellDoubleClick | SCPAnalysisScp0069Popup.cs:276 |  | CALL_EXT | dtSub.AsEnumerable().Where(row => row.Field<String>("ITEM_ID") == sItemID).OrderByDescendi… | (row => row.Field<String>("ITEM_ID")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4bcb63b3 | spdMain.CellDoubleClick | SCPAnalysisScp0069Popup.cs:276 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-9129f901 | spdMain.CellDoubleClick | SCPAnalysisScp0069Popup.cs:276 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-085cd1cf | spdMain.CellDoubleClick | SCPAnalysisScp0069Popup.cs:278 |  | GRID_BIND | siSub.Query | (dt) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-881930e8 | spdMain.CellDoubleClick | SCPAnalysisScp0069Popup.cs:279 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |

