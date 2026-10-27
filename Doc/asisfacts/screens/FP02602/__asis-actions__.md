# AS-IS 액션 대조표 — FP02602

> 원천: `Doc/asisfacts/screens/FP02602/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 185행 · 메서드 40 · 종류 DATA_OP 49 · RETURN 20 · UI_PROP 19 · FLAG 16 · MESSAGE 12 · COMBO_DATA 9 · CALL_EXT 8 · GRID_INIT 7 · GRID_LOCK 7 · POPUP 6 · ENDPOINT 6 · LIST_REBIND 6 · GRID_SET 5 · UI_MISC 5 · THROW 5 · GRID_COMBO 3 · EXCEL 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 8


## FP02602_Production_Result.btnExcelImport_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ba8a15b | (진입점 미연결) | FP02602_Production_Result.cs:665 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6b599559 | (진입점 미연결) | FP02602_Production_Result.cs:666 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-9cb07b57 | (진입점 미연결) | FP02602_Production_Result.cs:666 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bb93a21b | (진입점 미연결) | FP02602_Production_Result.cs:667 |  | GRID_SET | p.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-29a2d353 | (진입점 미연결) | FP02602_Production_Result.cs:668 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-de7c2982 | (진입점 미연결) | FP02602_Production_Result.cs:669 |  | GRID_SET | p.KeyColumns["site_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f9183c16 | (진입점 미연결) | FP02602_Production_Result.cs:670 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-fcc63150 | (진입점 미연결) | FP02602_Production_Result.cs:672 |  | UI_PROP | p.DoSearchData | FP00180_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-b85aba70 | (진입점 미연결) | FP02602_Production_Result.cs:673 |  | UI_PROP | p.DoLineCheck | FP00180_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-4140370f | (진입점 미연결) | FP02602_Production_Result.cs:674 |  | UI_PROP | p.DoSaveData | FP00180_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-4a0da6af | (진입점 미연결) | FP02602_Production_Result.cs:675 |  | UI_PROP | p.DoValidationData | FP00180_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-243059fd | (진입점 미연결) | FP02602_Production_Result.cs:676 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02602_Production_Result.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a4f30bba | this.btnSql.Click | FP02602_Production_Result.cs:388 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2eb03f82 | this.btnSql.Click | FP02602_Production_Result.cs:389 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-73bce3d1 | this.btnSql.Click | FP02602_Production_Result.cs:391 |  | DATA_OP | popSql.Services.Add | (FindProcedure) | 데이터 객체 조작/조회 |  |  |  |
| AC-68b52f18 | this.btnSql.Click | FP02602_Production_Result.cs:392 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02602_Production_Result.cblPlant_changed

진입점: this.Load / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e40889d5 | this.Load 외 1 | FP02602_Production_Result.cs:862 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-41f2f190 | this.Load 외 1 | FP02602_Production_Result.cs:864 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02602_Production_Result.cbo_active_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85bb05f6 | (진입점 미연결) | FP02602_Production_Result.cs:619 | try | DATA_OP | Filter["ACTIVE_FLAG"] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-a579e6c4 | (진입점 미연결) | FP02602_Production_Result.cs:623 | catch () | DATA_OP | Filter["ACTIVE_FLAG"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.cboSite_changed

진입점: this.Load / cboSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54e88cfd | this.Load 외 1 | FP02602_Production_Result.cs:855 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fed336ea | this.Load 외 1 | FP02602_Production_Result.cs:857 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02602_Production_Result.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eef6fd87 | this.Load | FP02602_Production_Result.cs:261 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6bbdbc47 | this.Load | FP02602_Production_Result.cs:263 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-2767a629 | this.Load | FP02602_Production_Result.cs:265 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02602_Production_Result.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7122831d | DeleteButton | FP02602_Production_Result.cs:345 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02602_Production_Result.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4be57a26 | Dispose | FP02602_Production_Result.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02602_Production_Result.drpPeriod_changed

진입점: drpPeriod.ValueChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d333174 | drpPeriod.ValueChanged | FP02602_Production_Result.cs:893 |  | CALL_EXT | DateUtil_FP.gfn_getDiffDay | (arrRetStart, arrRetEnd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e96f9f5f | drpPeriod.ValueChanged | FP02602_Production_Result.cs:900 | if (dayCount > 366) | MESSAGE | MessageBox.Show | ("It cannot be exceeded 365 days") | 메시지 표시 |  |  |  |
| AC-4a4ba0ef | drpPeriod.ValueChanged | FP02602_Production_Result.cs:901 | if (dayCount > 366) | UI_PROP | drpPeriod.Value2 | drpPeriod.Value1.AddDays(365) | 속성 Value2 설정 |  |  |  |
| AC-8f11e4a4 | drpPeriod.ValueChanged | FP02602_Production_Result.cs:905 |  | DATA_OP | Filter["BUCKET_FROM"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-649ed220 | drpPeriod.ValueChanged | FP02602_Production_Result.cs:906 |  | DATA_OP | Filter["DUE_FROM_DATE"] | arrRetStart | 행/컬럼 값 대입 |  |  |  |
| AC-8911b019 | drpPeriod.ValueChanged | FP02602_Production_Result.cs:907 |  | DATA_OP | Filter["BUCKET_TO"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |
| AC-7fad21ef | drpPeriod.ValueChanged | FP02602_Production_Result.cs:908 |  | DATA_OP | Filter["DUE_TO_DATE"] | arrRetEnd | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58c1b650 | EditButton | FP02602_Production_Result.cs:354 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-512f9e0e | EditButton | FP02602_Production_Result.cs:356 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a1b4cb67 | EditButton | FP02602_Production_Result.cs:366 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DEMAND_LOT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-01fdb57b | EditButton | FP02602_Production_Result.cs:367 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.SETUP_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b7122542 | EditButton | FP02602_Production_Result.cs:368 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MATERIAL_CLASS), siMain.GetColumnIndex(DefColumns.FORMAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53225560 | EditButton | FP02602_Production_Result.cs:369 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.FORM_A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3306be58 | EditButton | FP02602_Production_Result.cs:370 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), siMain.GetColumnIndex(DefColumns.ACTIVE_FL… | 그리드 편집 잠금/해제 |  |  |  |

## FP02602_Production_Result.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23e30fe4 | ExcelButton | FP02602_Production_Result.cs:486 |  | EXCEL | ExportExcel | (0) | 엑셀 내보내기/올리기 |  |  |  |

## FP02602_Production_Result.FilterValidation

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eeb37f53 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:238 | if (to > max) | MESSAGE | MessageBox.Show | ("Search period can be up to 12 months.") | 메시지 표시 |  |  |  |
| AC-4c9fef61 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:239 | if (to > max) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-fa8c6631 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:244 | if (from > to) | MESSAGE | MessageBox.Show | ("Search period can be up to 12 months.") | 메시지 표시 |  |  |  |
| AC-effe736b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:245 | if (from > to) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8d591a41 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:249 | if (string.IsNullOrWhiteSpace(Filter["DIVISION_ID"])) | MESSAGE | MessageBox.Show | ("Please inserts Division.") | 메시지 표시 |  |  |  |
| AC-35f0b1a9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:249 | if (string.IsNullOrWhiteSpace(Filter["DIVISION_ID"])) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-bc958501 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:251 | if (string.IsNullOrWhiteSpace(Filter["PLANT_ID"])) | MESSAGE | MessageBox.Show | ("Please inserts Plant.") | 메시지 표시 |  |  |  |
| AC-3041dfb6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:251 | if (string.IsNullOrWhiteSpace(Filter["PLANT_ID"])) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f9b8b9ff | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:253 | if (string.IsNullOrWhiteSpace(Filter["DUE_FROM_DATE"])) | MESSAGE | MessageBox.Show | ("Please inserts Period.") | 메시지 표시 |  |  |  |
| AC-9b37a522 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:253 | if (string.IsNullOrWhiteSpace(Filter["DUE_FROM_DATE"])) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a85dce6c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:255 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.FindAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8afcacc4 | (진입점 미연결) | FP02602_Production_Result.cs:554 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-22fc79e1 | (진입점 미연결) | FP02602_Production_Result.cs:555 | try | CALL_EXT | set.Overwrite | (0, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d8f1ebce | (진입점 미연결) | FP02602_Production_Result.cs:557 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_type) ⇒ FP_Master.PR_UI_FP00180_FINDATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-51a008a5 | (진입점 미연결) | FP02602_Production_Result.cs:557 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", se… |  | 처리 중단/반환 |  |  |  |
| AC-c8921726 | (진입점 미연결) | FP02602_Production_Result.cs:561 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02602_Production_Result.FindData

진입점: popSql.OnSql [if (programID == FindProcedure)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-059fa513 | popSql.OnSql [if (programID == FindProcedure)] 외 2 | FP02602_Production_Result.cs:596 | try | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25a4c463 | popSql.OnSql [if (programID == FindProcedure)] 외 2 | FP02602_Production_Result.cs:600 | try | ENDPOINT | DataService.FP_ExecuteProcedure | (FindProcedure, set, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-93b4b7c6 | popSql.OnSql [if (programID == FindProcedure)] 외 2 | FP02602_Production_Result.cs:600 | try | RETURN | return DataService.FP_ExecuteProcedure(FindProcedure, set, p_sys_type); |  | 처리 중단/반환 |  |  |  |
| AC-9949042b | popSql.OnSql [if (programID == FindProcedure)] 외 2 | FP02602_Production_Result.cs:604 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02602_Production_Result.FindFormAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-644d0891 | (진입점 미연결) | FP02602_Production_Result.cs:574 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-20c836e7 | (진입점 미연결) | FP02602_Production_Result.cs:575 | try | CALL_EXT | set.Overwrite | (0, Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b9d5605 | (진입점 미연결) | FP02602_Production_Result.cs:577 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_t… ⇒ FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-579ddb23 | (진입점 미연결) | FP02602_Production_Result.cs:577 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE"… |  | 처리 중단/반환 |  |  |  |
| AC-f3f9aae0 | (진입점 미연결) | FP02602_Production_Result.cs:581 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP02602_Production_Result.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71d3069c | this.Load | FP02602_Production_Result.cs:162 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02602_Production_Result.FP00180_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48c71700 | (진입점 미연결) | FP02602_Production_Result.cs:660 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.FP00180_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31bcf0b8 | (진입점 미연결) | FP02602_Production_Result.cs:634 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP02602_Production_Result", "FP02602_Production_Result_EXCEL_UPDATE_BATCH", data, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP02602_Production_Result_EXCEL_… | 엔드포인트 호출 |  |  |  |
| AC-d4835818 | (진입점 미연결) | FP02602_Production_Result.cs:638 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.FP00180_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b2ec6bc | (진입점 미연결) | FP02602_Production_Result.cs:629 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.FP00180_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85fc24e3 | (진입점 미연결) | FP02602_Production_Result.cs:644 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-da99472b | (진입점 미연결) | FP02602_Production_Result.cs:645 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP02602_Production_Result","delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\{… | 엔드포인트 호출 |  |  |  |
| AC-38976f71 | (진입점 미연결) | FP02602_Production_Result.cs:649 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP02602_Production_Result","insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\{?def… | 엔드포인트 호출 |  |  |  |
| AC-7064f7d1 | (진입점 미연결) | FP02602_Production_Result.cs:653 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP02602_Production_Result","find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-6781bd6a | (진입점 미연결) | FP02602_Production_Result.cs:653 |  | RETURN | return DataService.FP_ExecuteQuery( "FP02602_Production_Result","find_Excel_buff… |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.GetDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0e91a89 | this.Load | FP02602_Production_Result.cs:214 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fa2829a7 | this.Load | FP02602_Production_Result.cs:215 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c122d89 | this.Load | FP02602_Production_Result.cs:215 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c3d5caad | this.Load | FP02602_Production_Result.cs:216 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP02602_Production_Result.GetPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e5e684e | this.Load | FP02602_Production_Result.cs:224 |  | UI_PROP | drpPeriod.Value1 | DateTime.Now.AddDays(-7).Date | 속성 Value1 설정 |  |  |  |
| AC-31fb1000 | this.Load | FP02602_Production_Result.cs:225 |  | UI_PROP | drpPeriod.Value2 | DateTime.Now.Date | 속성 Value2 설정 |  |  |  |
| AC-a86cd9f4 | this.Load | FP02602_Production_Result.cs:226 |  | DATA_OP | Filter["DUE_FROM_DATE"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-5d82f64b | this.Load | FP02602_Production_Result.cs:227 |  | DATA_OP | Filter["DUE_TO_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.InitComponents

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed945b2d | this.Load | FP02602_Production_Result.cs:195 |  | DATA_OP | Filter["CUTOFF_DATE"] | DateTime.Now.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-4ddc75b8 | this.Load | FP02602_Production_Result.cs:206 |  | DATA_OP | Filter["BUCKET_FROM"] | drpPeriod.Value1.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |
| AC-b2833060 | this.Load | FP02602_Production_Result.cs:207 |  | DATA_OP | Filter["BUCKET_TO"] | drpPeriod.Value2.ToString("yyyyMMdd") | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89a33da6 | this.Load | FP02602_Production_Result.cs:176 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3cd8bade | this.Load | FP02602_Production_Result.cs:178 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-ca21e71f | this.Load | FP02602_Production_Result.cs:179 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5f5a02bf | this.Load | FP02602_Production_Result.cs:183 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-070581b9 | this.Load | FP02602_Production_Result.cs:186 |  | DATA_OP | Filter["USER_ID"] | CurrentUser = UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ed3f3f78 | this.Load | FP02602_Production_Result.cs:186 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP02602_Production_Result.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07764f76 | this.Load 외 1 | FP02602_Production_Result.cs:276 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2433ee23 | this.Load 외 1 | FP02602_Production_Result.cs:277 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bfe039ba | this.Load 외 1 | FP02602_Production_Result.cs:281 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP02602_Production_Result.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-052af052 | InsertButton | FP02602_Production_Result.cs:337 |  | MESSAGE | MessageBox.Show | ("Material 정보는 이 화면에서 새로 추가할 수 없습니다 [*** 권한 보유자에게 요청하세요]") | 메시지 표시 |  |  |  |

## FP02602_Production_Result.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e11867c4 | (진입점 미연결) | FP02602_Production_Result.cs:497 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP02602_Production_Result.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87ae8910 | popSql.OnSql | FP02602_Production_Result.cs:540 | if (programID == FindProcedure) | RETURN | return FindData(false); |  | 처리 중단/반환 |  |  |  |
| AC-eec4e01f | popSql.OnSql | FP02602_Production_Result.cs:542 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3f4605cc | SaveButton | FP02602_Production_Result.cs:382 |  | MESSAGE | MessageBox.Show | ("There's no data to save") | 메시지 표시 |  |  |  |

## FP02602_Production_Result.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1e3b357 | SaveButton | FP02602_Production_Result.cs:377 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / cboOperation.SelectedIndexChanged / cboLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9e14e2c | this.Load 외 6 | FP02602_Production_Result.cs:923 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-73aa1d45 | this.Load 외 6 | FP02602_Production_Result.cs:923 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f2c8a88b | this.Load 외 6 | FP02602_Production_Result.cs:935 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cbee1dd2 | this.Load 외 6 | FP02602_Production_Result.cs:935 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a758c7ec | this.Load 외 6 | FP02602_Production_Result.cs:936 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ec0431d5 | this.Load 외 6 | FP02602_Production_Result.cs:942 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c6b767ad | this.Load 외 6 | FP02602_Production_Result.cs:943 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-355fb349 | this.Load 외 6 | FP02602_Production_Result.cs:943 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-7a1de020 | this.Load 외 6 | FP02602_Production_Result.cs:944 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-66300ad7 | this.Load 외 6 | FP02602_Production_Result.cs:950 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-0246a36e | this.Load 외 6 | FP02602_Production_Result.cs:951 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | FLAG | dtFactoryAmend | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-00218021 | this.Load 외 6 | FP02602_Production_Result.cs:951 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ac5629d6 | this.Load 외 6 | FP02602_Production_Result.cs:952 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactoryAmend, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-77bf8fde | this.Load 외 6 | FP02602_Production_Result.cs:959 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactoryAmend, clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-734190a3 | this.Load 외 6 | FP02602_Production_Result.cs:960 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6e01cf1f | this.Load 외 6 | FP02602_Production_Result.cs:960 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c347aa1f | this.Load 외 6 | FP02602_Production_Result.cs:961 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactoryAmend.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, cboOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ce906e4f | this.Load 외 6 | FP02602_Production_Result.cs:967 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues,true) | 행/컬럼 값 대입 |  |  |  |
| AC-a8d6e1d9 | this.Load 외 6 | FP02602_Production_Result.cs:968 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-cea5311c | this.Load 외 6 | FP02602_Production_Result.cs:968 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-3689ed41 | this.Load 외 6 | FP02602_Production_Result.cs:969 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtLine, cboLine, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-454e4b68 | this.Load 외 6 | FP02602_Production_Result.cs:975 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, cboLine.ControlValues,true) | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef66b9a0 | this.Load | FP02602_Production_Result.cs:145 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e87a7893 | this.Load | FP02602_Production_Result.cs:147 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8892364c | this.Load | FP02602_Production_Result.cs:151 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP02602_Production_Result.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good())] / cboOperation.SelectedIndexChanged [switch (triggerContro…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e6345e6 | this.Load [switch (triggerControl) case DefColumns.DIVISION_… 외 6 | FP02602_Production_Result.cs:914 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.SetSpreadInit

진입점: this.Load [try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7727bbef | this.Load [try] 외 1 | FP02602_Production_Result.cs:289 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80ae2c3f | this.Load [try] 외 1 | FP02602_Production_Result.cs:290 | if (sheetName.Equals(SpdSheet.shtMain)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-57cd4572 | this.Load [try] 외 1 | FP02602_Production_Result.cs:295 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02602_Production_Result.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bf3dad1 | this.spdMain.CellClick | FP02602_Production_Result.cs:685 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5b591c2a | this.spdMain.CellClick | FP02602_Production_Result.cs:698 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | itemTmp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e649f0f | this.spdMain.CellClick | FP02602_Production_Result.cs:699 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | DATA_OP | itemTmp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed1d8c49 | this.spdMain.CellClick | FP02602_Production_Result.cs:704 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8126c782 | this.spdMain.CellClick | FP02602_Production_Result.cs:705 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a70ec710 | this.spdMain.CellClick | FP02602_Production_Result.cs:706 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-bde5c9c2 | this.spdMain.CellClick | FP02602_Production_Result.cs:710 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-41672547 | this.spdMain.CellClick | FP02602_Production_Result.cs:713 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-d41a51bb | this.spdMain.CellClick | FP02602_Production_Result.cs:717 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | siMain.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ac819f57 | this.spdMain.CellClick | FP02602_Production_Result.cs:721 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2d7d5a4 | this.spdMain.CellClick | FP02602_Production_Result.cs:722 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-68ec55ef | this.spdMain.CellClick | FP02602_Production_Result.cs:723 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0968216 | this.spdMain.CellClick | FP02602_Production_Result.cs:727 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-299468a8 | this.spdMain.CellClick | FP02602_Production_Result.cs:730 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SETUP_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b43fff5a | this.spdMain.CellClick | FP02602_Production_Result.cs:738 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-52f5d186 | this.spdMain.CellClick | FP02602_Production_Result.cs:739 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-8db28728 | this.spdMain.CellClick | FP02602_Production_Result.cs:740 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-f01c3d89 | this.spdMain.CellClick | FP02602_Production_Result.cs:744 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-73c36f66 | this.spdMain.CellClick | FP02602_Production_Result.cs:747 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP02602_Production_Result.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa528f8b | this.spdMain.KeyDown | FP02602_Production_Result.cs:760 | if (e.Control && e.KeyCode == Keys.Z) | UI_PROP | e.Handled | true | 속성 Handled 설정 |  |  |  |
| AC-72b4119a | this.spdMain.KeyDown | FP02602_Production_Result.cs:780 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (range!=null && range.Length … | GRID_SET | siMain.ActiveSheet.Cells[r + eachRange.Row, c + eachRange.Column].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-226c3c4a | this.spdMain.KeyDown | FP02602_Production_Result.cs:790 | else of (e.Control && e.KeyCode == Keys.Z) ▸ if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02602_Production_Result.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e15a63b | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:805 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ce105e0f | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:810 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed7be0af | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:811 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-839d2f1f | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:812 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2323b60 | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:813 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-00e32de1 | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:814 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-53d765db | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:815 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-4bfbbfc5 | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:820 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-25a3c068 | tbNickName.BeforeOpenSearch | FP02602_Production_Result.cs:821 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP02602_Production_Result.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f939fef2 | tbNickName.OnSearchConditionChanged | FP02602_Production_Result.cs:828 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b86e7df | tbNickName.OnSearchConditionChanged | FP02602_Production_Result.cs:829 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-dd026381 | tbNickName.OnSearchConditionChanged | FP02602_Production_Result.cs:835 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-caa7ac5a | tbNickName.OnSearchConditionChanged | FP02602_Production_Result.cs:838 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b77c3aa8 | tbNickName.OnSearchConditionChanged | FP02602_Production_Result.cs:839 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.txtMaterial_changed

진입점: txtMaterial.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f115e27 | txtMaterial.TextChanged | FP02602_Production_Result.cs:885 |  | DATA_OP | Filter["ITEM_ID"] | txtMaterial.Text | 행/컬럼 값 대입 |  |  |  |

## FP02602_Production_Result.UIFindData

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adff913b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:411 | if (FilterValidation() == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a4bccd2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:414 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7d430aaf | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:420 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67716fc0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:421 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01f3e083 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:424 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-9bc9937d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:425 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3c8eea8d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:427 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-e7c4bf07 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:437 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c3c2d40c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:439 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindData(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-288f3183 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:439 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindData(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b847bed2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:449 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b232b1eb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:450 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cceebee6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:464 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cdb3ffe8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:470 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ccebdb38 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:471 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0fbb2faf | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | FP02602_Production_Result.cs:472 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

