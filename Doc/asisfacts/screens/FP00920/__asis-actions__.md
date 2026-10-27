# AS-IS 액션 대조표 — FP00920

> 원천: `Doc/asisfacts/screens/FP00920/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 185행 · 메서드 46 · 종류 DATA_OP 50 · RETURN 22 · UI_PROP 16 · FLAG 15 · MESSAGE 12 · COMBO_DATA 8 · GRID_INIT 7 · GRID_LOCK 7 · ENDPOINT 7 · POPUP 6 · GRID_SET 6 · CALL_EXT 6 · UI_MISC 5 · THROW 5 · LIST_REBIND 5 · GRID_COMBO 3 · VALUE_SET 2 · EXCEL 1 · CALL_BASE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 7


## FP00920_Shipping_Result.btnExcelImport_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c41bc658 | (진입점 미연결) | FP00920_Shipping_Result.cs:780 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0b9274db | (진입점 미연결) | FP00920_Shipping_Result.cs:781 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-a5e40066 | (진입점 미연결) | FP00920_Shipping_Result.cs:781 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4558d63f | (진입점 미연결) | FP00920_Shipping_Result.cs:782 |  | GRID_SET | p.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-3c3f46e3 | (진입점 미연결) | FP00920_Shipping_Result.cs:783 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-8f4aef56 | (진입점 미연결) | FP00920_Shipping_Result.cs:784 |  | GRID_SET | p.KeyColumns["site_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-d89bd09e | (진입점 미연결) | FP00920_Shipping_Result.cs:785 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-87b3cb79 | (진입점 미연결) | FP00920_Shipping_Result.cs:787 |  | UI_PROP | p.DoSearchData | FP00180_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-b92b5a5b | (진입점 미연결) | FP00920_Shipping_Result.cs:788 |  | UI_PROP | p.DoLineCheck | FP00180_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-5da02a1c | (진입점 미연결) | FP00920_Shipping_Result.cs:789 |  | UI_PROP | p.DoSaveData | FP00180_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-206d527c | (진입점 미연결) | FP00920_Shipping_Result.cs:790 |  | UI_PROP | p.DoValidationData | FP00180_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-54394793 | (진입점 미연결) | FP00920_Shipping_Result.cs:791 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00920_Shipping_Result.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f38ac102 | this.btnSql.Click | FP00920_Shipping_Result.cs:466 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ad6e4665 | this.btnSql.Click | FP00920_Shipping_Result.cs:467 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c65a9e9b | this.btnSql.Click | FP00920_Shipping_Result.cs:469 |  | DATA_OP | popSql.Services.Add | (FindProcedure) | 데이터 객체 조작/조회 |  |  |  |
| AC-f84aa090 | this.btnSql.Click | FP00920_Shipping_Result.cs:470 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00920_Shipping_Result.cblPlant_changed

진입점: clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf6644bf | clbPlant.SelectedIndexChanged | FP00920_Shipping_Result.cs:975 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.cboSite_changed

진입점: cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07b25773 | cboSite.SelectedIndexChanged | FP00920_Shipping_Result.cs:969 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.clbDivision_changed

진입점: clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-315caac3 | clbDivision.SelectedIndexChanged | FP00920_Shipping_Result.cs:960 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.clboToSite_changed

진입점: cboToSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f31cc4db | cboToSite.SelectedIndexChanged | FP00920_Shipping_Result.cs:982 |  | DATA_OP | Filter["TO_SITE_ID"] | CString.GetCheckedListValue(dtSite, cboToSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c53ccea8 | this.Load | FP00920_Shipping_Result.cs:335 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dca6660d | this.Load | FP00920_Shipping_Result.cs:337 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-efa9039a | this.Load | FP00920_Shipping_Result.cs:339 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00920_Shipping_Result.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d864aa5d | DeleteButton | FP00920_Shipping_Result.cs:423 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00920_Shipping_Result.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-114bea4b | Dispose | FP00920_Shipping_Result.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00920_Shipping_Result.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5c60f36 | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1004 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-19d8356b | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1011 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-12cee5af | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1012 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-f55d8079 | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1016 |  | DATA_OP | Filter["BUCKET_FROM"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-eda4b37e | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1017 |  | DATA_OP | Filter["DUE_FROM_DATE"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-867a2a20 | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1018 |  | DATA_OP | Filter["BUCKET_TO"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |
| AC-379d011b | drpPeriod.ValueChanged | FP00920_Shipping_Result.cs:1019 |  | DATA_OP | Filter["DUE_TO_DATE"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5d5f280 | EditButton | FP00920_Shipping_Result.cs:432 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1c5c1d5 | EditButton | FP00920_Shipping_Result.cs:434 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6b9c2c2f | EditButton | FP00920_Shipping_Result.cs:444 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DEMAND_LOT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-60a1b868 | EditButton | FP00920_Shipping_Result.cs:445 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.SETUP_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-15a3147c | EditButton | FP00920_Shipping_Result.cs:446 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MATERIAL_CLASS), siMain.GetColumnIndex(DefColumns.FORMAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e9268755 | EditButton | FP00920_Shipping_Result.cs:447 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.FORM_A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f2f37cf | EditButton | FP00920_Shipping_Result.cs:448 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), siMain.GetColumnIndex(DefColumns.ACTIVE_FL… | 그리드 편집 잠금/해제 |  |  |  |

## FP00920_Shipping_Result.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35f86530 | ExcelButton | FP00920_Shipping_Result.cs:602 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP00920_Shipping_Result.FilterValidation

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83c6ea8f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:312 | if (to > max) | MESSAGE | MessageBox.Show | ("COM1201") | 메시지 표시 |  |  |  |
| AC-7c156d82 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:313 | if (to > max) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a4c2e709 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:318 | if (from > to) | MESSAGE | MessageBox.Show | ("COM1201") | 메시지 표시 |  |  |  |
| AC-d86dea7e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:319 | if (from > to) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-26702ce7 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:323 | if (string.IsNullOrWhiteSpace(Filter["DIVISION_ID"])) | MESSAGE | MessageBox.Show | ("COM_0022") | 메시지 표시 |  |  |  |
| AC-72ff6d2e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:323 | if (string.IsNullOrWhiteSpace(Filter["DIVISION_ID"])) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2a8c73c4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:325 | if (string.IsNullOrWhiteSpace(Filter["PLANT_ID"])) | MESSAGE | MessageBox.Show | ("COM_0022") | 메시지 표시 |  |  |  |
| AC-c470f1c2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:325 | if (string.IsNullOrWhiteSpace(Filter["PLANT_ID"])) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-dd9c3271 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:327 | if (string.IsNullOrWhiteSpace(Filter["DUE_FROM_DATE"])) | MESSAGE | MessageBox.Show | ("COM_0022") | 메시지 표시 |  |  |  |
| AC-b27aa58d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:327 | if (string.IsNullOrWhiteSpace(Filter["DUE_FROM_DATE"])) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ba416a6f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:329 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.Find_Data_Amend

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12fab440 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:575 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { Filter["DIVISION_ID"] = CString.GetCheckedListValue(dtDiv… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b2f0365a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:577 | try ▸ lambda | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-441fc455 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:578 | try ▸ lambda | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-eddde1ee | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:579 | try ▸ lambda | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-74f1c227 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:580 | try ▸ lambda | DATA_OP | Filter["TO_SITE_ID"] | CString.GetCheckedListValue(dtSite, cboToSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-be01dc0d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:581 | try ▸ lambda | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-231902fe | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:582 | try ▸ lambda | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-f9e0bf64 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:585 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00920_Shipping_Result", Filter, user_id, pSysType, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fd27a72d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:587 | try | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-04c05f22 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:591 | catch () | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.FindAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e80226e | (진입점 미연결) | FP00920_Shipping_Result.cs:670 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f1e56b34 | (진입점 미연결) | FP00920_Shipping_Result.cs:671 | try | CALL_EXT | set.Overwrite | (0, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f135b880 | (진입점 미연결) | FP00920_Shipping_Result.cs:673 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_type) ⇒ FP_Master.PR_UI_FP00180_FINDATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66f6b0c1 | (진입점 미연결) | FP00920_Shipping_Result.cs:673 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", se… |  | 처리 중단/반환 |  |  |  |
| AC-c9bd245e | (진입점 미연결) | FP00920_Shipping_Result.cs:677 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00920_Shipping_Result.FindData

진입점: popSql.OnSql [if (programID == FindProcedure)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02531562 | popSql.OnSql [if (programID == FindProcedure)] 외 1 | FP00920_Shipping_Result.cs:712 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ef726fa | popSql.OnSql [if (programID == FindProcedure)] 외 1 | FP00920_Shipping_Result.cs:715 | try | ENDPOINT | Data_FP.CallGeneralProcedure | ("PR_UI_FP00920_Shipping_Result", Filter, user_id, p_sys_type, "SELECT_MAIN") | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-0b068e72 | popSql.OnSql [if (programID == FindProcedure)] 외 1 | FP00920_Shipping_Result.cs:715 | try | RETURN | return Data_FP.CallGeneralProcedure("PR_UI_FP00920_Shipping_Result", Filter, use… |  | 처리 중단/반환 |  |  |  |
| AC-9e358ed2 | popSql.OnSql [if (programID == FindProcedure)] 외 1 | FP00920_Shipping_Result.cs:719 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00920_Shipping_Result.FindFormAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-928bcbf1 | (진입점 미연결) | FP00920_Shipping_Result.cs:690 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-396ed2f6 | (진입점 미연결) | FP00920_Shipping_Result.cs:691 | try | CALL_EXT | set.Overwrite | (0, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a0c3f57c | (진입점 미연결) | FP00920_Shipping_Result.cs:693 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_t… ⇒ FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d4b0aaaf | (진입점 미연결) | FP00920_Shipping_Result.cs:693 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE"… |  | 처리 중단/반환 |  |  |  |
| AC-cf758c6f | (진입점 미연결) | FP00920_Shipping_Result.cs:697 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00920_Shipping_Result.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6616dd6 | this.Load | FP00920_Shipping_Result.cs:158 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00920_Shipping_Result.FP00180_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65bb261e | (진입점 미연결) | FP00920_Shipping_Result.cs:775 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.FP00180_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41c73c0d | (진입점 미연결) | FP00920_Shipping_Result.cs:749 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00920_Shipping_Result", "FP00920_Shipping_Result_EXCEL_UPDATE_BATCH", data, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP00920_Shipping_Result_EXCEL_UP… | 엔드포인트 호출 |  |  |  |
| AC-c8cca8d0 | (진입점 미연결) | FP00920_Shipping_Result.cs:753 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.FP00180_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94c41a1c | (진입점 미연결) | FP00920_Shipping_Result.cs:744 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.FP00180_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b6b231c | (진입점 미연결) | FP00920_Shipping_Result.cs:759 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-695aab33 | (진입점 미연결) | FP00920_Shipping_Result.cs:760 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00920_Shipping_Result", "delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\{… | 엔드포인트 호출 |  |  |  |
| AC-c307fde9 | (진입점 미연결) | FP00920_Shipping_Result.cs:764 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00920_Shipping_Result", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\{?def… | 엔드포인트 호출 |  |  |  |
| AC-42c1c706 | (진입점 미연결) | FP00920_Shipping_Result.cs:768 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00920_Shipping_Result", "find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-a5a9ab0b | (진입점 미연결) | FP00920_Shipping_Result.cs:768 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00920_Shipping_Result", "find_Excel_buffe… |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-302d7db1 | this.Load | FP00920_Shipping_Result.cs:234 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-7d7e1fe4 | this.Load | FP00920_Shipping_Result.cs:234 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c08aadb3 | this.Load | FP00920_Shipping_Result.cs:236 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00920_Shipping_Result.GetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-547eaed2 | (진입점 미연결) | FP00920_Shipping_Result.cs:263 |  | FLAG | dtFactoryAmend | Data_FP.Common_FP(Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 화면 필드/플래그 변경 |  |  |  |
| AC-da277e73 | (진입점 미연결) | FP00920_Shipping_Result.cs:263 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY_CODE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY_CODE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4700bb16 | (진입점 미연결) | FP00920_Shipping_Result.cs:268 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, cboToSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00920_Shipping_Result.GetLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9ab9538 | (진입점 미연결) | FP00920_Shipping_Result.cs:286 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-6b22559f | (진입점 미연결) | FP00920_Shipping_Result.cs:286 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00920_Shipping_Result.GetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee202440 | (진입점 미연결) | FP00920_Shipping_Result.cs:274 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-1189f4d8 | (진입점 미연결) | FP00920_Shipping_Result.cs:274 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## FP00920_Shipping_Result.GetPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a75b778e | this.Load | FP00920_Shipping_Result.cs:298 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now.Date.AddMonths(-1) | 속성 Value1 설정 |  |  |  |
| AC-edca8060 | this.Load | FP00920_Shipping_Result.cs:299 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.Date.AddDays(-1) | 속성 Value2 설정 |  |  |  |
| AC-827bd1c3 | this.Load | FP00920_Shipping_Result.cs:300 |  | DATA_OP | Filter["DUE_FROM_DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-afcf88db | this.Load | FP00920_Shipping_Result.cs:301 |  | DATA_OP | Filter["DUE_TO_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.GetPlant

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b6a0029 | this.Load 외 2 | FP00920_Shipping_Result.cs:255 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-515aa0a8 | this.Load 외 2 | FP00920_Shipping_Result.cs:255 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c3807a7c | this.Load 외 2 | FP00920_Shipping_Result.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00920_Shipping_Result.GetSite

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3743f7fb | this.Load | FP00920_Shipping_Result.cs:241 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-15a382b5 | this.Load | FP00920_Shipping_Result.cs:241 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19f14c3e | this.Load | FP00920_Shipping_Result.cs:243 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c871b660 | this.Load | FP00920_Shipping_Result.cs:245 | if (cboSite.Items.Count > 1) | VALUE_SET | cboSite.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-5d4e7e38 | this.Load | FP00920_Shipping_Result.cs:247 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboToSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-41afdad1 | this.Load | FP00920_Shipping_Result.cs:249 | if (cboSite.Items.Count > 1) | VALUE_SET | cboSite.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00920_Shipping_Result.InitComponents

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34944878 | this.Load | FP00920_Shipping_Result.cs:196 |  | DATA_OP | Filter["CUTOFF_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-08d3ca2d | this.Load | FP00920_Shipping_Result.cs:199 |  | DATA_OP | Filter["DIVISION_ID"] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c0aec788 | this.Load | FP00920_Shipping_Result.cs:203 |  | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |
| AC-6ba2ef35 | this.Load | FP00920_Shipping_Result.cs:208 |  | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b8adac78 | this.Load | FP00920_Shipping_Result.cs:213 |  | DATA_OP | Filter["TO_SITE_ID"] | CString.GetCheckedListValue(dtSite, cboToSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ff7170f7 | this.Load | FP00920_Shipping_Result.cs:225 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-178c0d74 | this.Load | FP00920_Shipping_Result.cs:226 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d5ad18b | this.Load | FP00920_Shipping_Result.cs:172 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-88c2dbed | this.Load | FP00920_Shipping_Result.cs:174 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b2240e79 | this.Load | FP00920_Shipping_Result.cs:175 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7b747663 | this.Load | FP00920_Shipping_Result.cs:184 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-859ab018 | this.Load | FP00920_Shipping_Result.cs:187 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5d68dbe0 | this.Load | FP00920_Shipping_Result.cs:187 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00920_Shipping_Result.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb3d42a | this.Load | FP00920_Shipping_Result.cs:377 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-2e29b1a2 | this.Load | FP00920_Shipping_Result.cs:378 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00920_Shipping_Result.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5fd42dda | this.Load 외 1 | FP00920_Shipping_Result.cs:350 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b2a24ba | this.Load 외 1 | FP00920_Shipping_Result.cs:351 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0ef19b41 | this.Load 외 1 | FP00920_Shipping_Result.cs:355 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00920_Shipping_Result.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7049c8bf | InsertButton | FP00920_Shipping_Result.cs:415 |  | MESSAGE | MessageBox.Show | ("Material 정보는 이 화면에서 새로 추가할 수 없습니다 [*** 권한 보유자에게 요청하세요]") | 메시지 표시 |  |  |  |

## FP00920_Shipping_Result.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d546b7bc | (진입점 미연결) | FP00920_Shipping_Result.cs:613 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00920_Shipping_Result.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3291428 | popSql.OnSql | FP00920_Shipping_Result.cs:656 | if (programID == FindProcedure) | RETURN | return FindData(false); |  | 처리 중단/반환 |  |  |  |
| AC-7c9aeddd | popSql.OnSql | FP00920_Shipping_Result.cs:658 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-16421049 | SaveButton | FP00920_Shipping_Result.cs:460 |  | MESSAGE | MessageBox.Show | ("There's no data to save") | 메시지 표시 |  |  |  |

## FP00920_Shipping_Result.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12daa087 | SaveButton | FP00920_Shipping_Result.cs:455 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.SetColumnChangeType

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d145ff0a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:560 |  | UI_PROP | GnlcellType.FormatString | "###,###.#" | 속성 FormatString 설정 |  |  |  |
| AC-202c6f78 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:566 | if (ordinal_QTY != -1) | GRID_SET | siMain.ActiveSheet.Columns[ordinal_QTY].CellType | GnlcellType | 그리드 속성/값 설정 |  |  |  |

## FP00920_Shipping_Result.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36456342 | this.Load | FP00920_Shipping_Result.cs:141 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c23b9901 | this.Load | FP00920_Shipping_Result.cs:143 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-496afb2d | this.Load | FP00920_Shipping_Result.cs:147 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00920_Shipping_Result.SetSpreadInit

진입점: this.Load [try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e4f7fd50 | this.Load [try] 외 1 | FP00920_Shipping_Result.cs:363 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50df20ec | this.Load [try] 외 1 | FP00920_Shipping_Result.cs:364 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-0273774b | this.Load [try] 외 1 | FP00920_Shipping_Result.cs:369 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00920_Shipping_Result.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d527692 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:800 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4cff684 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:813 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | itemTmp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b5a0baac | this.spdMain.CellClick | FP00920_Shipping_Result.cs:814 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | itemTmp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2520f020 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:819 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9c44a8b7 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:820 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dbc11ae | this.spdMain.CellClick | FP00920_Shipping_Result.cs:821 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d26bbda | this.spdMain.CellClick | FP00920_Shipping_Result.cs:825 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c977fbce | this.spdMain.CellClick | FP00920_Shipping_Result.cs:828 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-01a44247 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:832 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | siMain.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-245c6ae9 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:836 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-e50e2961 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:837 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-46e9bb55 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:838 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-6c09fa6d | this.spdMain.CellClick | FP00920_Shipping_Result.cs:842 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba420b0c | this.spdMain.CellClick | FP00920_Shipping_Result.cs:845 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SETUP_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9660614a | this.spdMain.CellClick | FP00920_Shipping_Result.cs:853 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ddc5126 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:854 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-18c9b5b9 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:855 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-547ffaf3 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:859 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-b861ac87 | this.spdMain.CellClick | FP00920_Shipping_Result.cs:862 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP00920_Shipping_Result.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45b36378 | this.spdMain.KeyDown | FP00920_Shipping_Result.cs:874 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-9678e350 | this.spdMain.KeyDown | FP00920_Shipping_Result.cs:894 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (range != null && range.Lengt… | GRID_SET | siMain.ActiveSheet.Cells[r + eachRange.Row, c + eachRange.Column].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-ca683959 | this.spdMain.KeyDown | FP00920_Shipping_Result.cs:904 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00920_Shipping_Result.tbNickName_BeforeOpenSearch

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56c1701e | (진입점 미연결) | FP00920_Shipping_Result.cs:924 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-4181f579 | (진입점 미연결) | FP00920_Shipping_Result.cs:925 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-f17bbdee | (진입점 미연결) | FP00920_Shipping_Result.cs:926 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-22e1ec97 | (진입점 미연결) | FP00920_Shipping_Result.cs:927 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-140dd519 | (진입점 미연결) | FP00920_Shipping_Result.cs:928 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-f85ce59e | (진입점 미연결) | FP00920_Shipping_Result.cs:929 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |

## FP00920_Shipping_Result.txtMaterial_changed

진입점: txtMaterial.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17693d70 | txtMaterial.TextChanged | FP00920_Shipping_Result.cs:996 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |

## FP00920_Shipping_Result.UIFindData

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e5663f4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:488 | if (FilterValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a32f6026 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:491 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-18fd05c0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:497 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d53266e7 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:498 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-504c7fb9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:501 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-aaa57b91 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:503 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8964c365 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:505 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-715c763c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:517 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1f86ee9e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:519 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => Find_Data_Amend("SELECT") ) | 화면 필드/플래그 변경 |  |  |  |
| AC-2fa6e8d2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:519 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Amend("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-46b7ce40 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:528 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0d629eb2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:529 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-12f003fd | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:541 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9969f1f0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:547 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d4fad0a1 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:548 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c5a39ec3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP00920_Shipping_Result.cs:549 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

