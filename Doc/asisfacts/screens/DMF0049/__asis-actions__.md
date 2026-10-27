# AS-IS 액션 대조표 — DMF0049

> 원천: `Doc/asisfacts/screens/DMF0049/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 340행 · 메서드 30 · 종류 DATA_OP 105 · GRID_LOCK 41 · GRID_SET 36 · UI_PROP 30 · GRID_COMBO 16 · RETURN 14 · FLAG 13 · COMBO_DATA 13 · ENDPOINT 13 · POPUP 12 · UI_MISC 10 · GRID_STYLE 9 · MESSAGE 9 · VALUE_SET 5 · GRID_INIT 5 · CALL_EXT 3 · LIST_REBIND 3 · VALUE_CLEAR 1 · THROW 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 3


## DMF0049_Sales_ETC_Reports.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceecfd02 | this.btnMeasure.Click | DMF0049_Sales_ETC_Reports.cs:1545 |  | POPUP | new DM0002_TitleSetForm_Popup | ("DMF0049", siMain.SheetName, false, clbDivision.SelectedValue.ToString()) | 팝업/폼 생성 |  |  |  |
| AC-c8ce4bb8 | this.btnMeasure.Click | DMF0049_Sales_ETC_Reports.cs:1547 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-769933e6 | this.btnMeasure.Click | DMF0049_Sales_ETC_Reports.cs:1548 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0049_Sales_ETC_Reports.btnSPVer_Click

진입점: this.btnSPVer.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a21977b6 | this.btnSPVer.Click | DMF0049_Sales_ETC_Reports.cs:1236 |  | POPUP | new DMF0044_United_VersionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a6769eab | this.btnSPVer.Click | DMF0049_Sales_ETC_Reports.cs:1237 |  | POPUP | pop.Form_Load | (clbDivision.ControlValues, clbType.ControlValues) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d2caad72 | this.btnSPVer.Click | DMF0049_Sales_ETC_Reports.cs:1238 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-33a02ee5 | this.btnSPVer.Click | DMF0049_Sales_ETC_Reports.cs:1240 |  | VALUE_SET | txtSPVersion.Text | pop.sVersions | 컨트롤 값 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.clbDivision_SelectedIndexChanged

진입점: this.clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbdb0c6b | this.clbDivision.SelectedIndexChanged | DMF0049_Sales_ETC_Reports.cs:1560 | if (siMain != null) | FLAG | dtMeasure | GetMeasure() | 화면 필드/플래그 변경 |  |  |  |

## DMF0049_Sales_ETC_Reports.clbType_SelectedIndexChanged

진입점: this.clbType.SelectedIndexChanged / clbType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c87f084 | this.clbType.SelectedIndexChanged 외 1 | DMF0049_Sales_ETC_Reports.cs:1533 |  | VALUE_CLEAR | txtSPVersion.Text | null | 컨트롤 값 비움 |  |  |  |
| AC-eb02d271 | this.clbType.SelectedIndexChanged 외 1 | DMF0049_Sales_ETC_Reports.cs:1536 | if (clbType.ControlValues == "REPORT_SP_W") | VALUE_SET | lblSPVersion.Text | "SP Version" | 컨트롤 값 설정 |  |  |  |
| AC-bc771621 | this.clbType.SelectedIndexChanged 외 1 | DMF0049_Sales_ETC_Reports.cs:1538 | else of (clbType.ControlValues == "REPORT_SP_W") | VALUE_SET | lblSPVersion.Text | "BP Version" | 컨트롤 값 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6aed962 | this.Load | DMF0049_Sales_ETC_Reports.cs:242 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-da5dc93a | this.Load | DMF0049_Sales_ETC_Reports.cs:243 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-96af2732 | this.Load | DMF0049_Sales_ETC_Reports.cs:244 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0049_Sales_ETC_Reports.DefineProperty

진입점: this.clbDivision.SelectedIndexChanged [if (siMain != null)] / this.clbPlanResult.SelectedIndexChanged [if (siMain != null)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6174f371 | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 2 | DMF0049_Sales_ETC_Reports.cs:229 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-1726ca6b | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 2 | DMF0049_Sales_ETC_Reports.cs:230 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-f00baacf | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 2 | DMF0049_Sales_ETC_Reports.cs:231 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-3d7ee26a | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 2 | DMF0049_Sales_ETC_Reports.cs:236 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-564cb3cf | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 2 | DMF0049_Sales_ETC_Reports.cs:237 |  | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c407e936 | DeleteButton | DMF0049_Sales_ETC_Reports.cs:307 | if (gsDivision_id == "40") ▸ if (iMeasureCnt == 2) ▸ for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-8fa8e9f0 | DeleteButton | DMF0049_Sales_ETC_Reports.cs:308 | if (gsDivision_id == "40") ▸ if (iMeasureCnt == 2) ▸ for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ebe87561 | DeleteButton | DMF0049_Sales_ETC_Reports.cs:317 | if (gsDivision_id == "40") ▸ else of (iMeasureCnt == 2) ▸ if (iMeasureCnt == 3) ▸ for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 3) | 그리드 표시 설정 |  |  |  |
| AC-1ffcf669 | DeleteButton | DMF0049_Sales_ETC_Reports.cs:318 | if (gsDivision_id == "40") ▸ else of (iMeasureCnt == 2) ▸ if (iMeasureCnt == 3) ▸ for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-59fbd7dc | DeleteButton | DMF0049_Sales_ETC_Reports.cs:330 | else of (gsDivision_id == "40") ▸ for (i >= 0) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iResult[i], 2) | 그리드 표시 설정 |  |  |  |
| AC-662447f2 | DeleteButton | DMF0049_Sales_ETC_Reports.cs:331 | else of (gsDivision_id == "40") ▸ for (i >= 0) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0049_Sales_ETC_Reports.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ac7178ed | Dispose | DMF0049_Sales_ETC_Reports.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0049_Sales_ETC_Reports.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ceaac60 | EditButton | DMF0049_Sales_ETC_Reports.cs:344 | if (UserInfoContext.Current["NowGroupID"].ToString() == "DM Planner" && gsDivision_id != "82") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fa63491d | EditButton | DMF0049_Sales_ETC_Reports.cs:345 | if (UserInfoContext.Current["NowGroupID"].ToString() == "DM Planner" && gsDivision_id != "82") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f914e23 | EditButton | DMF0049_Sales_ETC_Reports.cs:350 | if (this.fps != null) | COMBO_DATA | Data.Common | (Data.Type.DM_LOOKUP_DIV, false, gsDivision_id, "DM_SR_ETC_CURRENCY") ⇒ biz:CommonData.CommonDataList [code=DM_LOOKUP_DIV] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40976f1d | EditButton | DMF0049_Sales_ETC_Reports.cs:357 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-da08b524 | EditButton | DMF0049_Sales_ETC_Reports.cs:358 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-ad286b9b | EditButton | DMF0049_Sales_ETC_Reports.cs:360 | if (this.fps != null) ▸ if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-331ab516 | EditButton | DMF0049_Sales_ETC_Reports.cs:391 | if (this.fps != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d6b4ae39 | EditButton | DMF0049_Sales_ETC_Reports.cs:392 | if (this.fps != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPT_ID)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c7c2ee95 | EditButton | DMF0049_Sales_ETC_Reports.cs:393 | if (this.fps != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.T_DEPARTMENT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fadb7bb0 | EditButton | DMF0049_Sales_ETC_Reports.cs:394 | if (this.fps != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.T_DEPT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-be80677e | EditButton | DMF0049_Sales_ETC_Reports.cs:401 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-64724ab5 | EditButton | DMF0049_Sales_ETC_Reports.cs:402 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.T_DEPARTMENT_NAME), iRow, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-55a4b850 | EditButton | DMF0049_Sales_ETC_Reports.cs:403 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.T_DEPT_NAME), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3b523be2 | EditButton | DMF0049_Sales_ETC_Reports.cs:404 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), iRow, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-29d90bc4 | EditButton | DMF0049_Sales_ETC_Reports.cs:405 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE), iRow, siMain.GetColumnIndex(DefColumns.M… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dab9ca40 | EditButton | DMF0049_Sales_ETC_Reports.cs:409 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-aaad9c4e | EditButton | DMF0049_Sales_ETC_Reports.cs:410 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.T_DEPARTMENT_NAME), iRow, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fc2e938b | EditButton | DMF0049_Sales_ETC_Reports.cs:411 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (gsDivision_id == "40") | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.T_DEPT_NAME), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f9fe1a48 | EditButton | DMF0049_Sales_ETC_Reports.cs:419 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ if (siMain.GetColumnI… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetColumnIndex("M_" + n… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e899e5a6 | EditButton | DMF0049_Sales_ETC_Reports.cs:423 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ else of (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9182a56d | EditButton | DMF0049_Sales_ETC_Reports.cs:435 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ if (gsDivision_id != … | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex("M_" + nowYYYYMM), iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2853867f | EditButton | DMF0049_Sales_ETC_Reports.cs:444 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ if (siMain.GetCo… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex("M_" + nowYYYYMM), iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c789486f | EditButton | DMF0049_Sales_ETC_Reports.cs:456 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ if (gsDivision_i… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetColumnIndex("M_" + n… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0049_Sales_ETC_Reports.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2c366ac | ExcelButton | DMF0049_Sales_ETC_Reports.cs:477 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-9c4be1c1 | ExcelButton | DMF0049_Sales_ETC_Reports.cs:478 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-e2fb7f8d | ExcelButton | DMF0049_Sales_ETC_Reports.cs:479 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-c6a199e2 | ExcelButton | DMF0049_Sales_ETC_Reports.cs:480 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-353ae67e | ExcelButton | DMF0049_Sales_ETC_Reports.cs:481 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-50df23a0 | ExcelButton | DMF0049_Sales_ETC_Reports.cs:482 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-42ad521e | ExcelButton | DMF0049_Sales_ETC_Reports.cs:484 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-3973a1da | ExcelButton | DMF0049_Sales_ETC_Reports.cs:485 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-a9a1315d | ExcelButton | DMF0049_Sales_ETC_Reports.cs:487 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0.000;[Red]-#,##0.000" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-e9e9aaf0 | ExcelButton | DMF0049_Sales_ETC_Reports.cs:496 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-51cc85ec | ExcelButton | DMF0049_Sales_ETC_Reports.cs:501 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-67013e50 | ExcelButton | DMF0049_Sales_ETC_Reports.cs:505 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0049_Sales_ETC_Reports.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "success")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c8b5a3a | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:528 | if (txtSPVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00283") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2cf7963f | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:529 | if (txtSPVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-de3fdbff | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:532 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6f18d15f | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:535 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7fb1ac23 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:536 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9701f476 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:544 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-d700109d | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:545 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c4648abf | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:549 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0049_GET_SALES_ETC_REPORTS_DATA") ⇒ DM.DMF0049_GET_SALES_ETC_REPORTS_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-f1d28cf4 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:550 | try ▸ lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-00c7c618 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:551 | try ▸ lambda | DATA_OP | request.Parameters["division_id"] | clbDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-08774992 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:552 | try ▸ lambda | DATA_OP | request.Parameters["p_mdf_type"] | clbType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e1c9c6c6 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:553 | try ▸ lambda | DATA_OP | request.Parameters["p_yyyy"] | usrYear.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-348c0026 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:554 | try ▸ lambda | DATA_OP | request.Parameters["p_sp_version_no"] | txtSPVersion.Text | 행/컬럼 값 대입 |  |  |  |
| AC-03313dac | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:555 | try ▸ lambda | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8066b4f8 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:556 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1f796f3d | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:559 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0092f9a8 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:561 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d73473a1 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:569 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-2e136319 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:570 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b9f7358b | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:571 | try | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e05d43d6 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:572 | try | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-72439624 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:586 | try ▸ if (siMain.GetMaxRowIndex() > 0) ▸ if (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ if (siMain.GetColumnIndex(DefColumns.MEASURE… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, siMain.GetMaxRowIndex(), siMain.GetColu… | 그리드 표시 설정 |  |  |  |
| AC-e1e5b6e7 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:594 | try ▸ if (siMain.GetMaxRowIndex() > 0) ▸ else of (clbPlanResult.SelectedItem.ToString() == "Plan") ▸ if (siMain.GetColumnIndex("M_" + nowYYY… | GRID_STYLE | siMain.SetBGColor | (0, siMain.GetColumnIndex("M_" + nowYYYYMM), siMain.GetMaxRowIndex(), siMain.GetMaxColumnI… | 그리드 표시 설정 |  |  |  |
| AC-09036dd1 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:599 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0911f45f | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:600 | try | FLAG | gsDivision_id | clbDivision.SelectedValue.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-99dc7b9e | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:601 | try | FLAG | gsVersion_no | txtSPVersion.Text | 화면 필드/플래그 변경 |  |  |  |
| AC-a20f28e5 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:604 | try ▸ if (clbPlanResult.SelectedItem.ToString() == "Result") | FLAG | gsResultMonth | DateTime.Now.AddMonths(-1).ToString("yyyyMMdd").Substring(0, 6) | 화면 필드/플래그 변경 |  |  |  |
| AC-7e20fcdb | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:608 | try ▸ else of (clbPlanResult.SelectedItem.ToString() == "Result") | FLAG | gsResultMonth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-dddd25d6 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:619 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d36b610 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:623 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a284c1b8 | FindButton 외 1 | DMF0049_Sales_ETC_Reports.cs:625 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0049_Sales_ETC_Reports.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e388f412 | this.Load | DMF0049_Sales_ETC_Reports.cs:148 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-fdf9516b | this.Load | DMF0049_Sales_ETC_Reports.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetCalendarYYYY

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a71de43 | this.Load | DMF0049_Sales_ETC_Reports.cs:1184 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-1b6bed47 | this.Load | DMF0049_Sales_ETC_Reports.cs:1185 |  | DATA_OP | request.Parameters["CODE"] | "CALENDAR_YYYY" | 행/컬럼 값 대입 |  |  |  |
| AC-cb26efdd | this.Load | DMF0049_Sales_ETC_Reports.cs:1186 |  | DATA_OP | request.Parameters["PARAM1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-42a52c2e | this.Load | DMF0049_Sales_ETC_Reports.cs:1187 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1f44347f | this.Load | DMF0049_Sales_ETC_Reports.cs:1188 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1d8e1a2b | this.Load | DMF0049_Sales_ETC_Reports.cs:1189 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ffa6955f | this.Load | DMF0049_Sales_ETC_Reports.cs:1190 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c7eb332c | this.Load | DMF0049_Sales_ETC_Reports.cs:1191 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ffbd9a24 | this.Load | DMF0049_Sales_ETC_Reports.cs:1193 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetCellColor

진입점: SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= siMain.GetMaxColumnIndex())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1cbbfd7 | SaveButton [if (siMain != null && siMain.IsLock(siMain.Sheet… | DMF0049_Sales_ETC_Reports.cs:1489 |  | RETURN | return vCellColor; |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCells

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton [else of (gsDivision_id == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2fd7e19 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0049_Sales_ETC_Reports.cs:1230 |  | CALL_EXT | Math.DivRem | (iActiveRow, multiful, out div) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2da569ff | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0049_Sales_ETC_Reports.cs:1231 |  | RETURN | return Convert.ToInt32(iActiveRow - div); |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetCellIndexBySpanRowCells40

진입점: this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (gsDivision_id == "40") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID))] / DeleteButton [if (gsDivision_id == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3f86f11 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… 외 1 | DMF0049_Sales_ETC_Reports.cs:1634 |  | RETURN | return Convert.ToInt32(iFirstRow); |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetCellNumbersByRow

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / DeleteButton [else of (gsDivision_id == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8061a7e3 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0049_Sales_ETC_Reports.cs:1218 | for (i < (iRow + multiful)) ▸ if (iNo == iNo2) | DATA_OP | iResult[icount] | Convert.ToInt32(i) | 행/컬럼 값 대입 |  |  |  |
| AC-ce0b48a8 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… 외 1 | DMF0049_Sales_ETC_Reports.cs:1223 |  | RETURN | return iResult; |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetLookupData

진입점: this.Load / dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT_ID))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f30d3fc2 | this.Load 외 1 | DMF0049_Sales_ETC_Reports.cs:1130 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-f8746b6a | this.Load 외 1 | DMF0049_Sales_ETC_Reports.cs:1131 |  | DATA_OP | request.Parameters["p_lookup_type"] | strType | 행/컬럼 값 대입 |  |  |  |
| AC-417cf859 | this.Load 외 1 | DMF0049_Sales_ETC_Reports.cs:1132 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d7ecac9f | this.Load 외 1 | DMF0049_Sales_ETC_Reports.cs:1134 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetMeasure

진입점: this.clbDivision.SelectedIndexChanged [if (siMain != null)] / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8612a0 | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0049_Sales_ETC_Reports.cs:1145 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0049_GET_MEASURE") ⇒ DM.DMF0049_GET_MEASURE | 엔드포인트 요청 생성 |  |  |  |
| AC-99365b46 | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0049_Sales_ETC_Reports.cs:1146 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9160476e | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0049_Sales_ETC_Reports.cs:1147 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-171ef397 | this.clbDivision.SelectedIndexChanged [if (siMain != null)] 외 1 | DMF0049_Sales_ETC_Reports.cs:1149 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.GetMeasureCntBy40

진입점: this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (gsDivision_id == "40")] / DeleteButton [if (gsDivision_id == "40")] / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (gsDivision_id == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b0232d2 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… 외 2 | DMF0049_Sales_ETC_Reports.cs:1722 |  | RETURN | return Convert.ToInt32(iMeasureCnt); |  | 처리 중단/반환 |  |  |  |

## DMF0049_Sales_ETC_Reports.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2671fd54 | this.Load | DMF0049_Sales_ETC_Reports.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-55d16adc | this.Load | DMF0049_Sales_ETC_Reports.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtLook, clbType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-20d64f4f | this.Load | DMF0049_Sales_ETC_Reports.cs:207 |  | VALUE_SET | clbPlanResult.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-28ab9a35 | this.Load | DMF0049_Sales_ETC_Reports.cs:221 |  | FLAG | dtMeasure | GetMeasure() | 화면 필드/플래그 변경 |  |  |  |
| AC-cbbb183b | this.Load | DMF0049_Sales_ETC_Reports.cs:223 |  | FLAG | dtCompanyid | GetLookupData("DM_COMPANY") | 화면 필드/플래그 변경 |  |  |  |

## DMF0049_Sales_ETC_Reports.InitSpread

진입점: this.clbType.SelectedIndexChanged / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.clbDivision.SelectedIndexChanged [if (siMain != null)] / this.clbPlanResult.SelectedIndexChanged [if (siMain != null)] / this.Load / clbType.SelectedIndexChanged / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ if (response.DataSet.Tables[0].Rows[0][0].ToString() == "success")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-506989b6 | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:254 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0049_GET_SPREAD_TITLE") ⇒ DM.DMF0049_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-a2ffaa5d | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:256 |  | DATA_OP | request.Parameters["p_division_id"] | clbDivision.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1f330a74 | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:257 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f6d22e3c | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:258 |  | DATA_OP | request.Parameters["p_start_dt"] | usrYear.SelectedValue + "0101" | 행/컬럼 값 대입 |  |  |  |
| AC-070823e3 | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:259 |  | DATA_OP | request.Parameters["p_end_dt"] | usrYear.SelectedValue + "1231" | 행/컬럼 값 대입 |  |  |  |
| AC-da44bba6 | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:261 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-29bed7fd | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:263 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-02af27d2 | this.clbType.SelectedIndexChanged 외 7 | DMF0049_Sales_ETC_Reports.cs:265 |  | GRID_INIT | siMain.CreateSheetHeaderColumnDtDiv | (siMain, 1, dt, clbDivision.SelectedValue.ToString()) | 그리드 재구성/초기화 |  |  |  |

## DMF0049_Sales_ETC_Reports.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4d1357a | InsertButton | DMF0049_Sales_ETC_Reports.cs:932 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-3548d073 | InsertButton | DMF0049_Sales_ETC_Reports.cs:942 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_STYLE | siMain.SpreadObject.ActiveSheet.SetActiveCell | (iArray[0], iMeasureCnt) | 그리드 표시 설정 |  |  |  |
| AC-6db6d2c6 | InsertButton | DMF0049_Sales_ETC_Reports.cs:943 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | (iMeasureCnt) | 데이터 객체 조작/조회 |  |  |  |
| AC-a90398d8 | InsertButton | DMF0049_Sales_ETC_Reports.cs:946 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-92dc665a | InsertButton | DMF0049_Sales_ETC_Reports.cs:947 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.DEPT_ID)].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b24e4941 | InsertButton | DMF0049_Sales_ETC_Reports.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.T_DEPARTMENT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-40c61b94 | InsertButton | DMF0049_Sales_ETC_Reports.cs:949 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.T_DEPT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1cb63b0d | InsertButton | DMF0049_Sales_ETC_Reports.cs:951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.DM_LOOKUP_DIV, false, gsDivision_id, "DM_SR_ETC_CURRENCY") ⇒ biz:CommonData.CommonDataList [code=DM_LOOKUP_DIV] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-219830d0 | InsertButton | DMF0049_Sales_ETC_Reports.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.DMF0044_DEPARTMENT_TEAM2, false, gsDivision_id, "", "", "Y") ⇒ biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-85c0f4cd | InsertButton | DMF0049_Sales_ETC_Reports.cs:960 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-feebd477 | InsertButton | DMF0049_Sales_ETC_Reports.cs:966 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.T_DEPARTMENT_NAME), iRowNo, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0cc519e7 | InsertButton | DMF0049_Sales_ETC_Reports.cs:968 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.T_DEPT_NAME), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-83a48649 | InsertButton | DMF0049_Sales_ETC_Reports.cs:970 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CUTOFF_YYYYMMDD), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f60c9c91 | InsertButton | DMF0049_Sales_ETC_Reports.cs:972 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.NICK_NAME), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3ca312e9 | InsertButton | DMF0049_Sales_ETC_Reports.cs:974 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9b7b11e4 | InsertButton | DMF0049_Sales_ETC_Reports.cs:976 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.BIZ_TYPE_NAME), iRowNo, siMain.GetColumnIndex(De… | 그리드 편집 잠금/해제 |  |  |  |
| AC-196c9943 | InsertButton | DMF0049_Sales_ETC_Reports.cs:978 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.DMS_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-755a7f98 | InsertButton | DMF0049_Sales_ETC_Reports.cs:986 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b3f5c183 | InsertButton | DMF0049_Sales_ETC_Reports.cs:988 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.FCST_TYPE), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dd1f462b | InsertButton | DMF0049_Sales_ETC_Reports.cs:989 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, gsDivision_id, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-762bd591 | InsertButton | DMF0049_Sales_ETC_Reports.cs:991 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_COMBO | siMain.SetCellTypeCombo | (iRowNo, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cff771e0 | InsertButton | DMF0049_Sales_ETC_Reports.cs:993 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-47fe9a63 | InsertButton | DMF0049_Sales_ETC_Reports.cs:995 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CURRENCY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-32d906ad | InsertButton | DMF0049_Sales_ETC_Reports.cs:997 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ETC_DESCR), iRowNo, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-33dbd8f1 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (gs… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_MODEL_INFO), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-12f59983 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.PROJECT_CODE), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6f0c38a5 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.END_CUSTOMER), iRowNo, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |
| AC-002c0c16 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), iRowNo, siMain.GetColumnIndex(DefC… | 그리드 편집 잠금/해제 |  |  |  |
| AC-544b5c09 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CURRENCY), iRowNo, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4eb633de | InsertButton | DMF0049_Sales_ETC_Reports.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.ITEM_ID), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e503e190 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ else o… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.CELL_MODEL_INFO), iRowNo, siMain.GetColumnIndex(… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d2f614c4 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1029 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_LOCK | siMain.LockRange | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), iRowNo, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3611ddd7 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1030 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i < iMeasureCnt) ▸ if (si… | GRID_SET | siMain.SetValue | (iRowNo, siMain.GetColumnIndex(DefColumns.MEASURE), dtMeasure.Rows[i]["CODE"].ToString()) | 그리드 값 설정 |  |  |  |
| AC-530284e0 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1058 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowI… | GRID_LOCK | siMain.LockRange | (iRow, 0, iRow, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f3a64139 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1068 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowI… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetColumnIndex("M_" + n… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0256e8b6 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1072 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowI… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d841c3d | InsertButton | DMF0049_Sales_ETC_Reports.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowI… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex("M_" + nowYYYYMM), iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5d6d5245 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1093 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowI… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex("M_" + nowYYYYMM), iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c72eb5c2 | InsertButton | DMF0049_Sales_ETC_Reports.cs:1105 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (iRow <= siMain.GetMaxRowI… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetColumnIndex("M_" + n… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ae3a9eda | InsertButton | DMF0049_Sales_ETC_Reports.cs:1116 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0049_Sales_ETC_Reports.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d3a905 | SaveButton | DMF0049_Sales_ETC_Reports.cs:633 | if (txtSPVersion.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00281") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7834fae6 | SaveButton | DMF0049_Sales_ETC_Reports.cs:634 | if (txtSPVersion.Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bd46bdf | SaveButton | DMF0049_Sales_ETC_Reports.cs:642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3e114bbe | SaveButton | DMF0049_Sales_ETC_Reports.cs:643 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2c1416e9 | SaveButton | DMF0049_Sales_ETC_Reports.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Department" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b54ea16 | SaveButton | DMF0049_Sales_ETC_Reports.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-83c3723d | SaveButton | DMF0049_Sales_ETC_Reports.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45cad561 | SaveButton | DMF0049_Sales_ETC_Reports.cs:849 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("DM.DMF0049_SAVE_SALES_ETC_REPORT_C") ⇒ DM.DMF0049_SAVE_SALES_ETC_REPORT_C | 엔드포인트 요청 생성 |  |  |  |
| AC-67a1c4a9 | SaveButton | DMF0049_Sales_ETC_Reports.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4348fdc0 | SaveButton | DMF0049_Sales_ETC_Reports.cs:850 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_active_flag.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e765c01b | SaveButton | DMF0049_Sales_ETC_Reports.cs:851 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_result_month"] | p_result_month.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-18b26024 | SaveButton | DMF0049_Sales_ETC_Reports.cs:851 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_result_month.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-8f838121 | SaveButton | DMF0049_Sales_ETC_Reports.cs:852 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5e09b2e0 | SaveButton | DMF0049_Sales_ETC_Reports.cs:852 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_division_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-8bc632d3 | SaveButton | DMF0049_Sales_ETC_Reports.cs:853 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_version_no"] | p_version_no.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-7dbb10fc | SaveButton | DMF0049_Sales_ETC_Reports.cs:853 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_version_no.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-6eb9a91e | SaveButton | DMF0049_Sales_ETC_Reports.cs:854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_data_seq"] | p_data_seq.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-44b9c192 | SaveButton | DMF0049_Sales_ETC_Reports.cs:854 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_data_seq.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4b9383dd | SaveButton | DMF0049_Sales_ETC_Reports.cs:855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_department_id"] | p_department_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-b5cfc8af | SaveButton | DMF0049_Sales_ETC_Reports.cs:855 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_department_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-602089ed | SaveButton | DMF0049_Sales_ETC_Reports.cs:856 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_department_edit_flag"] | p_department_edit_flag.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5c0017b5 | SaveButton | DMF0049_Sales_ETC_Reports.cs:856 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_department_edit_flag.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-49186ca0 | SaveButton | DMF0049_Sales_ETC_Reports.cs:857 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_department_name"] | p_department_name.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0cbbe046 | SaveButton | DMF0049_Sales_ETC_Reports.cs:857 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_department_name.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-414275c4 | SaveButton | DMF0049_Sales_ETC_Reports.cs:858 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_dept_id"] | p_dept_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-f72303b9 | SaveButton | DMF0049_Sales_ETC_Reports.cs:858 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_dept_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-92d91553 | SaveButton | DMF0049_Sales_ETC_Reports.cs:859 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_cust_report"] | p_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-c3ec9781 | SaveButton | DMF0049_Sales_ETC_Reports.cs:859 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-72daa2c9 | SaveButton | DMF0049_Sales_ETC_Reports.cs:860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_end_cust_report"] | p_end_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-45bff232 | SaveButton | DMF0049_Sales_ETC_Reports.cs:860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_end_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-601dc653 | SaveButton | DMF0049_Sales_ETC_Reports.cs:861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_soldto_code"] | p_soldto_code.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-451eda2b | SaveButton | DMF0049_Sales_ETC_Reports.cs:861 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_soldto_code.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e843da99 | SaveButton | DMF0049_Sales_ETC_Reports.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_soldto_cust_report"] | p_soldto_cust_report.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-5dca3359 | SaveButton | DMF0049_Sales_ETC_Reports.cs:862 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_soldto_cust_report.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-77ec7ad7 | SaveButton | DMF0049_Sales_ETC_Reports.cs:863 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_product_group"] | p_product_group.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2343ae4d | SaveButton | DMF0049_Sales_ETC_Reports.cs:863 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_product_group.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f216088 | SaveButton | DMF0049_Sales_ETC_Reports.cs:864 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4107141f | SaveButton | DMF0049_Sales_ETC_Reports.cs:864 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_item_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9b65fb8 | SaveButton | DMF0049_Sales_ETC_Reports.cs:865 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_product_details"] | p_product_details.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ea49c374 | SaveButton | DMF0049_Sales_ETC_Reports.cs:865 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_product_details.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0db1b382 | SaveButton | DMF0049_Sales_ETC_Reports.cs:866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_currency"] | p_currency.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ac3e1428 | SaveButton | DMF0049_Sales_ETC_Reports.cs:866 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_currency.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3099ca8 | SaveButton | DMF0049_Sales_ETC_Reports.cs:867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_company_id"] | p_company_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-591e4b6f | SaveButton | DMF0049_Sales_ETC_Reports.cs:867 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_company_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-658c3761 | SaveButton | DMF0049_Sales_ETC_Reports.cs:868 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_biz_type"] | p_biz_type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-82cabcfd | SaveButton | DMF0049_Sales_ETC_Reports.cs:868 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_biz_type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0e5664b | SaveButton | DMF0049_Sales_ETC_Reports.cs:869 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_application_gr"] | p_application_gr.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-d68bf356 | SaveButton | DMF0049_Sales_ETC_Reports.cs:869 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_application_gr.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-0cef6fdd | SaveButton | DMF0049_Sales_ETC_Reports.cs:870 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_application"] | p_application.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-100cafa4 | SaveButton | DMF0049_Sales_ETC_Reports.cs:870 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_application.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-823083f1 | SaveButton | DMF0049_Sales_ETC_Reports.cs:871 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_country_code"] | p_country_code.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-40ef1f3d | SaveButton | DMF0049_Sales_ETC_Reports.cs:871 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_country_code.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-17c9cfc0 | SaveButton | DMF0049_Sales_ETC_Reports.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_project_code"] | p_project_code.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-13dff9ab | SaveButton | DMF0049_Sales_ETC_Reports.cs:872 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_project_code.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a447f56 | SaveButton | DMF0049_Sales_ETC_Reports.cs:873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-79f1737c | SaveButton | DMF0049_Sales_ETC_Reports.cs:873 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_scm_site_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f288718 | SaveButton | DMF0049_Sales_ETC_Reports.cs:874 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_fcst_type"] | p_fcst_type.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-6a270da6 | SaveButton | DMF0049_Sales_ETC_Reports.cs:874 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_fcst_type.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e0020f69 | SaveButton | DMF0049_Sales_ETC_Reports.cs:875 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_use"] | p_item_use.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-4c951660 | SaveButton | DMF0049_Sales_ETC_Reports.cs:875 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_item_use.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-44448306 | SaveButton | DMF0049_Sales_ETC_Reports.cs:876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_soldto_country"] | p_soldto_country.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2ef343c5 | SaveButton | DMF0049_Sales_ETC_Reports.cs:876 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_soldto_country.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8e7e599 | SaveButton | DMF0049_Sales_ETC_Reports.cs:877 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_shipto_country"] | p_shipto_country.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-cd7caf8f | SaveButton | DMF0049_Sales_ETC_Reports.cs:877 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_shipto_country.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-d3b5364c | SaveButton | DMF0049_Sales_ETC_Reports.cs:878 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_end_customer"] | p_end_customer.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-87b204b7 | SaveButton | DMF0049_Sales_ETC_Reports.cs:878 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_end_customer.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca5b1ee3 | SaveButton | DMF0049_Sales_ETC_Reports.cs:879 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_etc_descr"] | p_etc_descr.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-2f5157fa | SaveButton | DMF0049_Sales_ETC_Reports.cs:879 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_etc_descr.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-df844454 | SaveButton | DMF0049_Sales_ETC_Reports.cs:880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_cell_model_info"] | p_cell_model_info.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-997f61be | SaveButton | DMF0049_Sales_ETC_Reports.cs:880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_cell_model_info.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-3050ee98 | SaveButton | DMF0049_Sales_ETC_Reports.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_measure"] | p_measure.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-365b9048 | SaveButton | DMF0049_Sales_ETC_Reports.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_measure.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b095f5b9 | SaveButton | DMF0049_Sales_ETC_Reports.cs:883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_yyyymmdd"] | p_yyyymmdd.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-ea9d525a | SaveButton | DMF0049_Sales_ETC_Reports.cs:883 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_yyyymmdd.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9678b18 | SaveButton | DMF0049_Sales_ETC_Reports.cs:884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_qty"] | p_qty.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-3e1bfb8a | SaveButton | DMF0049_Sales_ETC_Reports.cs:884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_qty.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-b28aa4af | SaveButton | DMF0049_Sales_ETC_Reports.cs:885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_created_by"] | p_created_by.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-44843357 | SaveButton | DMF0049_Sales_ETC_Reports.cs:885 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_created_by.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-af590a48 | SaveButton | DMF0049_Sales_ETC_Reports.cs:886 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_cell_model"] | p_cell_model.Remove(0, 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a22f1fa1 | SaveButton | DMF0049_Sales_ETC_Reports.cs:886 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | DATA_OP | p_cell_model.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-358bade4 | SaveButton | DMF0049_Sales_ETC_Reports.cs:888 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-68725c7d | SaveButton | DMF0049_Sales_ETC_Reports.cs:890 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4eefff4e | SaveButton | DMF0049_Sales_ETC_Reports.cs:894 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-649db0f2 | SaveButton | DMF0049_Sales_ETC_Reports.cs:899 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d2a5e06 | SaveButton | DMF0049_Sales_ETC_Reports.cs:903 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7206b3d5 | SaveButton | DMF0049_Sales_ETC_Reports.cs:905 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ else o… | CALL_EXT | siMain.SpreadObject.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3318ef7 | SaveButton | DMF0049_Sales_ETC_Reports.cs:907 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ try ▸ if (iCount > 0) ▸ else o… | GRID_STYLE | siMain.SpreadObject.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-0523ebed | SaveButton | DMF0049_Sales_ETC_Reports.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39292f7b | SaveButton | DMF0049_Sales_ETC_Reports.cs:919 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0049_Sales_ETC_Reports.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a5098ba | this.Load | DMF0049_Sales_ETC_Reports.cs:167 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-b7ab946f | this.Load | DMF0049_Sales_ETC_Reports.cs:168 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e26d098f | this.Load | DMF0049_Sales_ETC_Reports.cs:174 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-03520856 | this.Load | DMF0049_Sales_ETC_Reports.cs:174 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-92c672ca | this.Load | DMF0049_Sales_ETC_Reports.cs:179 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-d3c092ce | this.Load | DMF0049_Sales_ETC_Reports.cs:180 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-2791d3ef | this.Load | DMF0049_Sales_ETC_Reports.cs:182 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f9da815 | this.Load | DMF0049_Sales_ETC_Reports.cs:182 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0049_Sales_ETC_Reports.SetRowSpanFucTwo

진입점: this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (gsDivision_id == "40") ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPARTMENT_ID))] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f46bcb96 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… 외 1 | DMF0049_Sales_ETC_Reports.cs:1511 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (sFYear != siSpread.GetText(j, i)) | GRID_STYLE | siSpread.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow - 1, 1) | 그리드 표시 설정 |  |  |  |
| AC-1a56c308 | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… 외 1 | DMF0049_Sales_ETC_Reports.cs:1519 | for (i <= iEndCol) ▸ for (j <= iEndRow) ▸ if (j == iEndRow) | GRID_STYLE | siSpread.SpreadObject.Sheets[0].AddSpanCell | (iFRow, i, iLRow, 1) | 그리드 표시 설정 |  |  |  |
| AC-a0a6a21f | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… 외 1 | DMF0049_Sales_ETC_Reports.cs:1526 | for (i <= iEndCol) | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-b1468d1e | this.spdMain.CellClick [if (!siMain.IsLock(siMain.ActiveShee… 외 1 | DMF0049_Sales_ETC_Reports.cs:1527 | for (i <= iEndCol) | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab0c4a78 | this.spdMain.CellClick | DMF0049_Sales_ETC_Reports.cs:1597 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (gsDivision_id == "40") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DEPAR… | COMBO_DATA | Data.Common | (Data.Type.DMF0005_REPORT_GROUP2, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-69e0f02a | this.spdMain.CellClick | DMF0049_Sales_ETC_Reports.cs:1598 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (gsDivision_id == "40") ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DEPAR… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c98a6344 | this.spdMain.CellDoubleClick | DMF0049_Sales_ETC_Reports.cs:1440 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a87f5e5f | this.spdMain.CellDoubleClick | DMF0049_Sales_ETC_Reports.cs:1442 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.Form_Load | (false, sDivision, sTeam, sEndCustomer, sScmSite, sProject, true) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ca52c42b | this.spdMain.CellDoubleClick | DMF0049_Sales_ETC_Reports.cs:1443 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d0a3c2b6 | this.spdMain.CellDoubleClick | DMF0049_Sales_ETC_Reports.cs:1444 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-05e73372 | this.spdMain.CellDoubleClick | DMF0049_Sales_ETC_Reports.cs:1451 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") | GRID_SET | siMain.SetText | (e.Row, e.Column, sProject) | 그리드 값 설정 |  |  |  |
| AC-cda8f216 | this.spdMain.CellDoubleClick | DMF0049_Sales_ETC_Reports.cs:1455 | if (e.Column == siMain.GetColumnIndex(DefColumns.PROJECT_CODE)) ▸ if (sProject != "") ▸ if (siMain.GetColumnIndex(DefColumns.PROJECT_NAME) >… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PROJECT_NAME), sProjectName) | 그리드 값 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.spdMain_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5d4acb3 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1268 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | COMBO_DATA | Data.Common | (Data.Type.DMF0044_DEPARTMENT_TEAM, false, sDEPARTMENT_ID, "") ⇒ biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6931d062 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1269 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3749f871 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1272 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-8ca4a98f | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1273 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-554b0388 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1278 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-72cfc2f5 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1282 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-3f5a4473 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1283 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-873b3391 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1284 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-e06ee31c | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1285 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-3037de84 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1286 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-a3026bf1 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1294 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | COMBO_DATA | Data.Common | (Data.Type.DMF0044_DEPARTMENT_TEAM2, false, gsDivision_id, "") ⇒ biz:CommonData.CommonDataList [code=DMF0044_DEPARTMENT_TEAM2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba806200 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1295 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DEPT_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4dc262a4 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1298 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-adeeca74 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1299 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-81d11eab | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1302 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | DATA_OP | dtNull.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-eb934354 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1303 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | DATA_OP | dtNull.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4ae0919c | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1304 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | DATA_OP | dtNull.Rows.Add | ("", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-07f1bd35 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1310 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-dbfc6ff6 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1314 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8aeb96b7 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1315 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-431cab39 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1316 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-25b4f137 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1318 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-ff7bf2f8 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1319 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-a6d88603 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1320 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-7129741e | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1321 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-1465c012 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1322 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPA… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-f11d74a8 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1337 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | COMBO_DATA | Data.Common | (Data.Type.END_CUST_REPORT, false, "", "") ⇒ biz:CommonData.CommonDataList [code=EndCustReport] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7d061667 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1346 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | COMBO_DATA | Data.Common | (Data.Type.DMF0005_REPORT_GROUP2, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8deb78c0 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1347 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-0ffee038 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1350 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-cf35bb1e | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1351 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-b6dd2679 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1356 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-276d0a1f | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1357 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), dtProduct) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-3d3dbb6b | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1360 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-97578962 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1361 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-7a4cdad3 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1364 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-04d79c5a | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1365 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-98f7a75b | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1367 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | COMBO_DATA | Data.Common | (Data.Type.DMF0005_REPORT_GROUP2, false, "", "") ⇒ biz:CommonData.CommonDataList [code=DMF0005_REPORT_GROUP2] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5e08fdf9 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1368 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CUST_REPORT), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7f141f82 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1371 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.HorizontalAlignment | FarPoint.Win.Spread.CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-15a26d5a | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1372 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | UI_PROP | cellrange.VerticalAlignment | FarPoint.Win.Spread.CellVerticalAlignment.Center | 속성 VerticalAlignment 설정 |  |  |  |
| AC-b53924b5 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1374 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), "") | 그리드 값 설정 |  |  |  |
| AC-5341f544 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1375 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.NICK_NAME), "") | 그리드 값 설정 |  |  |  |
| AC-9e3a675d | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1376 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-0a3c466c | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1377 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-efedfe0f | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1378 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-cb5f0767 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1385 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtNull.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1431f88f | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1386 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtNull.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c775432 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1387 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | DATA_OP | dtNull.Rows.Add | ("", "") | 데이터 객체 조작/조회 |  |  |  |
| AC-01d6db7f | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1393 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-cf9440bc | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1397 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), dtNull) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-92309a0c | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1398 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), dtProduct) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-e4c431ae | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1400 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.END_CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-9e3047aa | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1401 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CUST_REPORT), "") | 그리드 값 설정 |  |  |  |
| AC-472cc32d | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1402 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DEPT… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCT_GROUP), "") | 그리드 값 설정 |  |  |  |
| AC-bf9515d2 | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1410 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, gsDivision_id, sEn… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-aff516de | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1411 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SCM_SITE_ID), dtSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-cf39063b | dsdm.Changed | DMF0049_Sales_ETC_Reports.cs:1420 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if ((siMain.GetColumnIndex(DefColumns.MEASURE) > 0) &… | GRID_SET | siMain.SetText | (e.Row, e.Column, "0") | 그리드 값 설정 |  |  |  |

## DMF0049_Sales_ETC_Reports.YearSet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d64eeba1 | this.Load | DMF0049_Sales_ETC_Reports.cs:1173 |  | LIST_REBIND | clsCtrl.setListBox | (dtYYYY, usrYear, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-515a3cb8 | this.Load | DMF0049_Sales_ETC_Reports.cs:1174 |  | VALUE_SET | usrYear.SelectedValue | DateTime.Now.Year | 컨트롤 값 설정 |  |  |  |

