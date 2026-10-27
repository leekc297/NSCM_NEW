# AS-IS 액션 대조표 — FP00180

> 원천: `Doc/asisfacts/screens/FP00180/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 403행 · 메서드 63 · 종류 DATA_OP 136 · FLAG 43 · RETURN 36 · MESSAGE 29 · UI_PROP 26 · ENDPOINT 24 · GRID_INIT 18 · CALL_EXT 16 · UI_MISC 14 · POPUP 12 · LIST_REBIND 10 · COMBO_DATA 8 · GRID_SET 7 · THROW 6 · GRID_BIND 3 · GRID_LOCK 3 · VALIDATE 3 · GRID_COMBO 3 · EXCEL 2 · VALUE_SET 2 · GRID_STYLE 2 · ⚠ 의미 확인 필요 16


## FP00180_Material..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23a0f79e | .ctor | FP00180_Material.cs:122 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00180_Material.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f06dcc0 | this.btnExcelImport.Click | FP00180_Material.cs:856 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-751c2a62 | this.btnExcelImport.Click | FP00180_Material.cs:857 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-2d2e9ae0 | this.btnExcelImport.Click | FP00180_Material.cs:857 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-462c425f | this.btnExcelImport.Click | FP00180_Material.cs:858 |  | GRID_SET | p.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-1a28a808 | this.btnExcelImport.Click | FP00180_Material.cs:859 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-228df4df | this.btnExcelImport.Click | FP00180_Material.cs:860 |  | GRID_SET | p.KeyColumns["site_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-67fe6304 | this.btnExcelImport.Click | FP00180_Material.cs:861 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-2bb6aaba | this.btnExcelImport.Click | FP00180_Material.cs:863 |  | UI_PROP | p.DoSearchData | FP00180_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-6839c5be | this.btnExcelImport.Click | FP00180_Material.cs:864 |  | UI_PROP | p.DoLineCheck | FP00180_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-796657bf | this.btnExcelImport.Click | FP00180_Material.cs:865 |  | UI_PROP | p.DoSaveData | FP00180_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-04e77f67 | this.btnExcelImport.Click | FP00180_Material.cs:866 |  | UI_PROP | p.DoValidationData | FP00180_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-e9f25148 | this.btnExcelImport.Click | FP00180_Material.cs:867 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00180_Material.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e31aa90d | this.btnSql.Click | FP00180_Material.cs:487 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-635fdfb0 | this.btnSql.Click | FP00180_Material.cs:488 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f768595c | this.btnSql.Click | FP00180_Material.cs:490 |  | DATA_OP | popSql.Services.Add | ("PR2_UI_FP00180_FIND_FP00180") | 데이터 객체 조작/조회 |  |  |  |
| AC-fda335e6 | this.btnSql.Click | FP00180_Material.cs:491 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00180_Material.cbo_active_SelectedIndexChanged

진입점: cbo_active.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-374a5700 | cbo_active.SelectedIndexChanged | FP00180_Material.cs:793 |  | DATA_OP | Filter["ACTIVE_FLAG"] | CString.GetCheckedListValue(dtYesOrNo, cbo_active.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00180_Material.cbo_itemType_SelectedIndexChanged

진입점: cbo_itemType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1553e36 | cbo_itemType.SelectedIndexChanged | FP00180_Material.cs:759 |  | DATA_OP | Filter["ITEM_TYPE"] | CString.GetCheckedListValue(dtItemType, cbo_itemType.ControlValues, true) | 행/컬럼 값 대입 |  |  |  |

## FP00180_Material.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea218e33 | this.Load | FP00180_Material.cs:208 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMaterial, SpdSheet.shtMaterial, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b8945fef | this.Load | FP00180_Material.cs:210 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMaterial) | 화면 필드/플래그 변경 |  |  |  |
| AC-6c562adf | this.Load | FP00180_Material.cs:212 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMaterial) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00180_Material.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86b0323a | DeleteButton | FP00180_Material.cs:293 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00180_Material.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e7ab6313 | Dispose | FP00180_Material.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00180_Material.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d45bcdca | EditButton | FP00180_Material.cs:302 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7b17054a | EditButton | FP00180_Material.cs:304 | if (spdMain != null) | CALL_EXT | siMain.SwitchLockFP | (!isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4fef243 | EditButton | FP00180_Material.cs:308 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.ITEM_A… | ⚠ 의미 확인 필요 |  |  |  |
| AC-a82e60b4 | EditButton | FP00180_Material.cs:309 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex(DefColumns.SETUP_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.SETUP… | ⚠ 의미 확인 필요 |  |  |  |
| AC-fafc1d10 | EditButton | FP00180_Material.cs:310 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.FORM_A… | ⚠ 의미 확인 필요 |  |  |  |
| AC-59ddf0ad | EditButton | FP00180_Material.cs:311 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex(DefColumns.SCP_EXTRA_SPEC), siMain.GetColumnIndex(DefColumns.SCP_EX… | ⚠ 의미 확인 필요 |  |  |  |
| AC-4a11ee8c | EditButton | FP00180_Material.cs:312 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex(DefColumns.FP_EXTRA_SPEC), siMain.GetColumnIndex(DefColumns.FP_EXTR… | ⚠ 의미 확인 필요 |  |  |  |
| AC-d6128898 | EditButton | FP00180_Material.cs:314 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFPDone | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00180_Material.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61629e02 | ExcelButton | FP00180_Material.cs:589 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00180_Material.FindAttribute

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2562cd75 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:709 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | looupTypeCode | 행/컬럼 값 대입 |  |  |  |
| AC-d55f7eb6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:710 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR2_UI_FP00180_FINDATTRIBUTE", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-431b75ba | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:711 | try | DATA_OP | Filter["LOOKUP_TYPE_CODE"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c9109a61 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:712 | try | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-2f0357ac | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:716 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00180_Material.FindDataMaterial

진입점: popSql.OnSql [if (programID == "PR2_UI_FP00180_FIND_FP00180")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b375dcce | popSql.OnSql [if (programID == "PR2_UI_FP00180_FIND_FP00180"… 외 3 | FP00180_Material.cs:746 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR2_UI_FP00180_FIND_FP00180",Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-57b2a940 | popSql.OnSql [if (programID == "PR2_UI_FP00180_FIND_FP00180"… 외 3 | FP00180_Material.cs:746 | try | RETURN | return DataService.FP_ExecuteProcedure("PR2_UI_FP00180_FIND_FP00180",Filter, p_s… |  | 처리 중단/반환 |  |  |  |
| AC-74e44d92 | popSql.OnSql [if (programID == "PR2_UI_FP00180_FIND_FP00180"… 외 3 | FP00180_Material.cs:750 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00180_Material.FindDataMaterialAsync

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0351494 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:505 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c1ab825b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:511 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e017dc4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:512 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbc98bf9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:515 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-7965ee92 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:522 | try ▸ if (Filter["DIVISION_ID"] == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e4f09a99 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:524 | try ▸ if (Filter["DIVISION_ID"] == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-35c4daad | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:527 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d9ab1e43 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:529 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-b7c4512e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:539 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-b96fe87e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:541 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindDataMaterial(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-26561b5f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:541 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindDataMaterial(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0892aae0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:551 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7715a400 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:552 | try | DATA_OP | dsMain.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-78823aed | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:553 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c3a11cc6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:555 | try | FLAG | dsFormAttribute | FindFormAttribute(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8ebb9567 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:556 | try | FLAG | dsItemAttribute | FindAttribute("ITEM_ATTRIBUTE",true) | 화면 필드/플래그 변경 |  |  |  |
| AC-35b9cc4f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:557 | try | FLAG | dsSetupAttribute | FindAttribute("SETUP_ATTRIBUTE", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7a4de7fb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:567 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e921474c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:573 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2415a872 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:574 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-5c4fd0f8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:575 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00180_Material.FindFormAttribute

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9094bb7 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:728 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR2_UI_FP00180_FINDFORMATTRIBUTE", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-25d2b7c1 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:728 | try | RETURN | return DataService.FP_ExecuteProcedure("PR2_UI_FP00180_FINDFORMATTRIBUTE", Filte… |  | 처리 중단/반환 |  |  |  |
| AC-9d30164b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00180_Material.cs:732 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00180_Material.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4167169a | this.Load | FP00180_Material.cs:134 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00180_Material.FP00180_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c19497b6 | (진입점 미연결) | FP00180_Material.cs:851 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.FP00180_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b63d579d | (진입점 미연결) | FP00180_Material.cs:819 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00180_Material", "FP00180_MATERIAL_EXCEL_UPDATE_BATCH", data, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP00180_MATERIAL_EXCEL_UPDATE_BA… | 엔드포인트 호출 |  |  |  |
| AC-c075fddf | (진입점 미연결) | FP00180_Material.cs:825 | if (ret.DataSet != null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-44b3ed3c | (진입점 미연결) | FP00180_Material.cs:826 |  | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-f5c16e65 | (진입점 미연결) | FP00180_Material.cs:828 |  | DATA_OP | tmpDs.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f26f982 | (진입점 미연결) | FP00180_Material.cs:829 |  | RETURN | return tmpDs; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.FP00180_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b401ff4c | (진입점 미연결) | FP00180_Material.cs:814 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.FP00180_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34b37bb2 | (진입점 미연결) | FP00180_Material.cs:835 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-3005c705 | (진입점 미연결) | FP00180_Material.cs:836 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00180_Material","delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-99bd93e3 | (진입점 미연결) | FP00180_Material.cs:840 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00180_Material","insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-2d7f130c | (진입점 미연결) | FP00180_Material.cs:844 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00180_Material","find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-55fdd361 | (진입점 미연결) | FP00180_Material.cs:844 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00180_Material","find_Excel_buffer_valida… |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.GetClass2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9c3c2f5 | (진입점 미연결) | FP00180_Material.cs:669 |  | FLAG | dtClass2 | DataService.FP_ExecuteProcedure2("PR2_UI_FP00180_FINDCLASS2", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5d45a92e | (진입점 미연결) | FP00180_Material.cs:669 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR2_UI_FP00180_FINDCLASS2", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-fdbdaaa7 | (진입점 미연결) | FP00180_Material.cs:670 |  | LIST_REBIND | clsCtrl.setListBox | (dtClass2, cbo_class2, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00180_Material.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eafc21b0 | this.Load [try] | FP00180_Material.cs:1107 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a656d478 | this.Load [try] | FP00180_Material.cs:1108 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0295e84e | this.Load [try] | FP00180_Material.cs:1108 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-915726f0 | this.Load [try] | FP00180_Material.cs:1109 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |

## FP00180_Material.GetItemType

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-429175ce | this.Load [try] | FP00180_Material.cs:654 |  | FLAG | dtItemType | DataService.FP_ExecuteProcedure2("PR2_UI_FP00180_FINDITEMTYPE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-602cbace | this.Load [try] | FP00180_Material.cs:654 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR2_UI_FP00180_FINDITEMTYPE", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-9d3eeb7d | this.Load [try] | FP00180_Material.cs:658 |  | LIST_REBIND | clsCtrl.setListBox | (dtItemType, cbo_itemType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-673ce169 | this.Load [try] | FP00180_Material.cs:660 |  | FLAG | dtClass1 | DataService.GetInnerTable("CLASS1", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] \| FP\COM… | 화면 필드/플래그 변경 |  |  |  |
| AC-4620463a | this.Load [try] | FP00180_Material.cs:660 |  | COMBO_DATA | DataService.GetInnerTable | ("CLASS1", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] \| FP\COM… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a53134e1 | this.Load [try] | FP00180_Material.cs:661 |  | LIST_REBIND | clsCtrl.setListBox | (dtClass1, cbo_class1, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00180_Material.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b9060b03 | (진입점 미연결) | FP00180_Material.cs:640 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-9171dbeb | (진입점 미연결) | FP00180_Material.cs:640 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42dac894 | (진입점 미연결) | FP00180_Material.cs:642 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, mcbo_site, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00180_Material.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e3c6949 | this.Load | FP00180_Material.cs:171 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f331c41d | this.Load | FP00180_Material.cs:173 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-5bfcbaa7 | this.Load | FP00180_Material.cs:174 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-e6939415 | this.Load | FP00180_Material.cs:176 | try | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-45b98c22 | this.Load | FP00180_Material.cs:178 | try | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cbo_active, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-38179535 | this.Load | FP00180_Material.cs:179 | try | VALUE_SET | cbo_active.InitValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-e0c56734 | this.Load | FP00180_Material.cs:180 | try | DATA_OP | Filter["ACTIVE_FLAG"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-6723fcf1 | this.Load | FP00180_Material.cs:197 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00180_Material.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-995f5023 | this.Load 외 2 | FP00180_Material.cs:223 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-feb1fe7a | this.Load 외 2 | FP00180_Material.cs:224 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMaterial) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0850ff7 | this.Load 외 2 | FP00180_Material.cs:228 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP00180_Material.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91ecfa1a | InsertButton | FP00180_Material.cs:285 |  | MESSAGE | MessageBox.Show | ("Material 정보는 이 화면에서 새로 추가할 수 없습니다 [*** 권한 보유자에게 요청하세요]") | 메시지 표시 |  |  |  |

## FP00180_Material.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d1278d3 | (진입점 미연결) | FP00180_Material.cs:600 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00180_Material.mcbo_division_SelectedIndexChanged

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-113f62ab | this.Load [try] 외 1 | FP00180_Material.cs:807 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-f07ce213 | this.Load [try] 외 1 | FP00180_Material.cs:809 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00180_Material.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b018143e | popSql.OnSql | FP00180_Material.cs:696 | if (programID == "PR2_UI_FP00180_FIND_FP00180") | RETURN | return FindDataMaterial(false); |  | 처리 중단/반환 |  |  |  |
| AC-3fac0ee0 | popSql.OnSql | FP00180_Material.cs:698 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b53050f | SaveButton | FP00180_Material.cs:326 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01f01ab0 | SaveButton | FP00180_Material.cs:328 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5401fca0 | SaveButton | FP00180_Material.cs:333 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bbabd428 | SaveButton | FP00180_Material.cs:334 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8ffe57e | SaveButton | FP00180_Material.cs:337 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-618cf1de | SaveButton | FP00180_Material.cs:344 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-ca4f152f | SaveButton | FP00180_Material.cs:346 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9e6a8229 | SaveButton | FP00180_Material.cs:347 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6dda26c1 | SaveButton | FP00180_Material.cs:352 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-042bef7d | SaveButton | FP00180_Material.cs:357 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-833ed921 | SaveButton | FP00180_Material.cs:366 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-719d54eb | SaveButton | FP00180_Material.cs:370 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d4e86641 | SaveButton | FP00180_Material.cs:374 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0192d4a6 | SaveButton | FP00180_Material.cs:375 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-bef44189 | SaveButton | FP00180_Material.cs:379 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00180_Material.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a91a8d4c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:413 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-25ad2d58 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:416 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-93062a47 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:423 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if (bindingRow.RowState !=… | CALL_EXT | bindingRow.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-625e7dda | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:427 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-63bfb0f1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:431 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e83ebe1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:457 | try | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8606c7ca | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:461 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00180_Material", "saveAll_FP00180", dsSave, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00180] \| FP\MASTER\FP… | 엔드포인트 호출 |  |  |  |
| AC-e0bdf602 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:464 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-8fca8ebf | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:466 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-ffb03ec8 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:467 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-91638b68 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:469 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-0edf839b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:473 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-5b606428 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:479 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-5d607dff | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP00180_Material.cs:480 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7fe3017 | SaveButton | FP00180_Material.cs:321 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / mcbo_site.SelectedIndexChanged / cbo_class1.SelectedIndexChanged / cbo_class2.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-119bfd7d | this.Load [try] 외 4 | FP00180_Material.cs:1040 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-750ad150 | this.Load [try] 외 4 | FP00180_Material.cs:1040 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e68a28ff | this.Load [try] 외 4 | FP00180_Material.cs:1045 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-6ed32957 | this.Load [try] 외 4 | FP00180_Material.cs:1049 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-2dfd0b68 | this.Load [try] 외 4 | FP00180_Material.cs:1049 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-82f179a8 | this.Load [try] 외 4 | FP00180_Material.cs:1051 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)mcbo_site is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)mcbo_site as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-57259728 | this.Load [try] 외 4 | FP00180_Material.cs:1053 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)mcbo_site is UsrCombo) ▸ if ((object)mcbo_s… | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)mcbo_site as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-81ca83cf | this.Load [try] 외 4 | FP00180_Material.cs:1059 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, mcbo_site.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-d39d28e5 | this.Load [try] 외 4 | FP00180_Material.cs:1064 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (!dtClass1.Good()) | FLAG | dtClass1 | DataService.GetInnerTable("CLASS1", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] \| FP\COM… | 화면 필드/플래그 변경 |  |  |  |
| AC-aeb0c4f0 | this.Load [try] 외 4 | FP00180_Material.cs:1064 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (!dtClass1.Good()) | COMBO_DATA | DataService.GetInnerTable | ("CLASS1", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] \| FP\COM… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e25d5a76 | this.Load [try] 외 4 | FP00180_Material.cs:1072 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) ▸ if (start == 0 && end >= 2) | DATA_OP | Filter["ITEM_CLASS_LEVEL_1"] | a.Substring(1, end - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-0ea4de03 | this.Load [try] 외 4 | FP00180_Material.cs:1076 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) ▸ else of (start == 0 && end >= 2) | DATA_OP | Filter["ITEM_CLASS_LEVEL_1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ca85ebdc | this.Load [try] 외 4 | FP00180_Material.cs:1078 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) | DATA_OP | Filter["ITEM_CLASS_LEVEL_CODE"] | a | 행/컬럼 값 대입 |  |  |  |
| AC-206c9ff6 | this.Load [try] 외 4 | FP00180_Material.cs:1079 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) | FLAG | dtClass2 | DataService.GetInnerTable("CLASS2", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] \| FP\COM… | 화면 필드/플래그 변경 |  |  |  |
| AC-f8c6cc41 | this.Load [try] 외 4 | FP00180_Material.cs:1079 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) | COMBO_DATA | DataService.GetInnerTable | ("CLASS2", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_material_class2] \| FP\COM… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-16dcad5c | this.Load [try] 외 4 | FP00180_Material.cs:1081 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) ▸ if ((object)cbo_class2 is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtClass2, (object)cbo_class2 as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-da8f8eaf | this.Load [try] 외 4 | FP00180_Material.cs:1083 | switch (triggerControl) case DefColumns.CLASS1: ▸ if (dtClass1.Good()) ▸ else of ((object)cbo_class2 is UsrCombo) ▸ if ((object)cbo_class2 i… | LIST_REBIND | clsCtrl.setListBox | (dtClass2, (object)cbo_class2 as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-e39843f3 | this.Load [try] 외 4 | FP00180_Material.cs:1094 | switch (triggerControl) case DefColumns.CLASS2: ▸ if (dtClass2.Good()) ▸ if (start == 0 && end >= 2) | DATA_OP | Filter["ITEM_CLASS_LEVEL_2"] | a.Substring(1, end - 1) | 행/컬럼 값 대입 |  |  |  |
| AC-a8479222 | this.Load [try] 외 4 | FP00180_Material.cs:1098 | switch (triggerControl) case DefColumns.CLASS2: ▸ if (dtClass2.Good()) ▸ else of (start == 0 && end >= 2) | DATA_OP | Filter["ITEM_CLASS_LEVEL_2"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00180_Material.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cbc418c | this.Load | FP00180_Material.cs:158 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-954ced93 | this.Load | FP00180_Material.cs:160 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-a19dd231 | this.Load | FP00180_Material.cs:164 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00180_Material.SetSpreadInit

진입점: this.Load [try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e8976b1 | this.Load [try] 외 2 | FP00180_Material.cs:236 | if (sheetName.Equals(SpdSheet.shtMaterial)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ab8d31be | this.Load [try] 외 2 | FP00180_Material.cs:237 | if (sheetName.Equals(SpdSheet.shtMaterial)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-4c87f9fe | this.Load [try] 외 2 | FP00180_Material.cs:242 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00180_Material.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da5e75ce | this.spdMain.CellClick | FP00180_Material.cs:876 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e8d85bae | this.spdMain.CellClick | FP00180_Material.cs:891 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) | DATA_OP | itemTmp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7efba42 | this.spdMain.CellClick | FP00180_Material.cs:892 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) | DATA_OP | itemTmp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-b2155271 | this.spdMain.CellClick | FP00180_Material.cs:897 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-97faba5b | this.spdMain.CellClick | FP00180_Material.cs:898 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-9f519ce9 | this.spdMain.CellClick | FP00180_Material.cs:899 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | dRow.Field | ("CLASS_LEVEL_2_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-48a1bc53 | this.spdMain.CellClick | FP00180_Material.cs:903 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-43d5abda | this.spdMain.CellClick | FP00180_Material.cs:906 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-9b2aff22 | this.spdMain.CellClick | FP00180_Material.cs:910 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | siMain.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e7f97c92 | this.spdMain.CellClick | FP00180_Material.cs:914 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-397a261c | this.spdMain.CellClick | FP00180_Material.cs:915 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3f1cea4 | this.spdMain.CellClick | FP00180_Material.cs:916 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | ("CLASS_LEVEL_2_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb7455f1 | this.spdMain.CellClick | FP00180_Material.cs:920 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f8a76df | this.spdMain.CellClick | FP00180_Material.cs:923 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SETUP_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-aaa02355 | this.spdMain.CellClick | FP00180_Material.cs:931 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-f8f04d1c | this.spdMain.CellClick | FP00180_Material.cs:932 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-cf7451f2 | this.spdMain.CellClick | FP00180_Material.cs:933 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | ("CLASS_LEVEL_2_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5f27b0f7 | this.spdMain.CellClick | FP00180_Material.cs:937 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-214e8edd | this.spdMain.CellClick | FP00180_Material.cs:940 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP00180_Material.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a1dcf19 | this.spdMain.KeyDown | FP00180_Material.cs:968 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (range!=null && range.Length > 0) ▸ for (i< range.Length) ▸ for (c < eachR… | GRID_SET | siMain.ActiveSheet.Cells[r + eachRange.Row, c + eachRange.Column].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-58fa0bab | this.spdMain.KeyDown | FP00180_Material.cs:978 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (siMain.Active… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00180_Material.tbClass_TextChanged

진입점: tbClass.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0506f8cc | tbClass.TextChanged | FP00180_Material.cs:766 |  | DATA_OP | Filter["ITEM_CLASS"] | tbClass.Text | 행/컬럼 값 대입 |  |  |  |

## FP00180_Material.tbMaterial_TextChanged

진입점: tbMaterial.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7eae87c4 | tbMaterial.TextChanged | FP00180_Material.cs:783 |  | DATA_OP | Filter["ITEM_ID"] | tbMaterial.Text | 행/컬럼 값 대입 |  |  |  |

## FP00180_Material.tbModel_TextChanged

진입점: tbModel.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60343d58 | tbModel.TextChanged | FP00180_Material.cs:778 |  | DATA_OP | Filter["MODEL_ID"] | tbModel.Text | 행/컬럼 값 대입 |  |  |  |

## FP00180_Material.tbNickName_BeforeOpenSearch

진입점: tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cd4fed9 | tbNickName.BeforeOpenSearch | FP00180_Material.cs:992 |  | CALL_EXT | tbNickName.Filter.Set | (Filter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f98c76cc | tbNickName.BeforeOpenSearch | FP00180_Material.cs:997 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6618421 | tbNickName.BeforeOpenSearch | FP00180_Material.cs:998 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-eafaf25b | tbNickName.BeforeOpenSearch | FP00180_Material.cs:999 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-b83822f7 | tbNickName.BeforeOpenSearch | FP00180_Material.cs:1000 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4375c80 | tbNickName.BeforeOpenSearch | FP00180_Material.cs:1001 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-de69cb1b | tbNickName.BeforeOpenSearch | FP00180_Material.cs:1002 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-9902f5c9 | tbNickName.BeforeOpenSearch | FP00180_Material.cs:1007 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-fa80dbf0 | tbNickName.BeforeOpenSearch | FP00180_Material.cs:1008 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP00180_Material.tbNickName_OnSearchConditionChanged

진입점: tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55ba1b3d | tbNickName.OnSearchConditionChanged | FP00180_Material.cs:1015 | if (tbNickName.IsInMode == true) | CALL_EXT | Filter.setColumn | (0,"NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a30cfd9 | tbNickName.OnSearchConditionChanged | FP00180_Material.cs:1016 | if (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2c087e8b | tbNickName.OnSearchConditionChanged | FP00180_Material.cs:1022 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | tbNickName.Selected[0] | 행/컬럼 값 대입 |  |  |  |
| AC-6403d4d8 | tbNickName.OnSearchConditionChanged | FP00180_Material.cs:1025 | else of (tbNickName.IsInMode == true) ▸ else of (tbNickName.Selected.Count > 0) | DATA_OP | Filter["NICK_NAME"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5d5f2499 | tbNickName.OnSearchConditionChanged | FP00180_Material.cs:1026 | else of (tbNickName.IsInMode == true) | DATA_OP | Filter["NICK_NAME_LT"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00180_MaterialImportPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-562952df | .ctor | FP00180_MaterialImportPopup.cs:117 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-67a7e55a | .ctor | FP00180_MaterialImportPopup.cs:118 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-95628bb2 | .ctor | FP00180_MaterialImportPopup.cs:119 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-30c3e501 | .ctor | FP00180_MaterialImportPopup.cs:120 |  | FLAG | this.sParamsFilter | pParamsFilter | 화면 필드/플래그 변경 |  |  |  |
| AC-ac3fffbe | .ctor | FP00180_MaterialImportPopup.cs:121 |  | FLAG | this.sDbParamsList | pDbParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-50658f01 | .ctor | FP00180_MaterialImportPopup.cs:123 |  | UI_PROP | SpdSheet.shtComExcel | this.sSheetName | 속성 shtComExcel 설정 |  |  |  |
| AC-2604a684 | .ctor | FP00180_MaterialImportPopup.cs:127 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-820da817 | .ctor | FP00180_MaterialImportPopup.cs:128 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-09a88e99 | .ctor | FP00180_MaterialImportPopup.cs:132 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | MESSAGE | MessageBox.Show | ("the Filter/DB List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Err… | 메시지 표시 |  |  |  |
| AC-f04e2aaf | .ctor | FP00180_MaterialImportPopup.cs:133 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-9b87cd06 | .ctor | FP00180_MaterialImportPopup.cs:140 |  | FLAG | iDbParmsCount | arrDbList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-f30c9c41 | .ctor | FP00180_MaterialImportPopup.cs:142 |  | UI_PROP | structParam._sParamFilter | new string[iDbParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-e13e0002 | .ctor | FP00180_MaterialImportPopup.cs:143 |  | UI_PROP | structParam._sDbParamsList | new string[iDbParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-7090547e | .ctor | FP00180_MaterialImportPopup.cs:147 | for (i < iDbParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrFilter[i] | 행/컬럼 값 대입 |  |  |  |
| AC-89d78022 | .ctor | FP00180_MaterialImportPopup.cs:148 | for (i < iDbParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrDbList[i] | 행/컬럼 값 대입 |  |  |  |

## FP00180_MaterialImportPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd44c4a5 | this.btnClose.Click | FP00180_MaterialImportPopup.cs:332 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00180_MaterialImportPopup.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-174bbee6 | this.btnImport.Click | FP00180_MaterialImportPopup.cs:297 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-cc0cd631 | this.btnImport.Click | FP00180_MaterialImportPopup.cs:298 | try | UI_PROP | opd.InitialDirectory | Application.StartupPath | 속성 InitialDirectory 설정 |  |  |  |
| AC-33ef4e91 | this.btnImport.Click | FP00180_MaterialImportPopup.cs:299 | try | UI_PROP | opd.Filter | "Excel files (*.xls)\|*.xls\|All files (*.*)\|*.*" | 속성 Filter 설정 |  |  |  |
| AC-25aeaeef | this.btnImport.Click | FP00180_MaterialImportPopup.cs:300 | try | UI_PROP | opd.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-0e58b55c | this.btnImport.Click | FP00180_MaterialImportPopup.cs:302 | try | POPUP | opd.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-04537e2b | this.btnImport.Click | FP00180_MaterialImportPopup.cs:305 | try ▸ if (opd.ShowDialog() == DialogResult.OK) | COMBO_DATA | DataCommon.GetReadExcelFile | (opd.FileName, iDbParmsCount) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-66d8010b | this.btnImport.Click | FP00180_MaterialImportPopup.cs:320 | try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ else of (dtExcel != null && dtExcel.Rows.Count > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00087") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-801e568b | this.btnImport.Click | FP00180_MaterialImportPopup.cs:326 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00035") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00180_MaterialImportPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b00c4e6e | this.Load | FP00180_MaterialImportPopup.cs:196 |  | GRID_INIT | this.AddSheet | (spdComExcel, SpdSheet.shtComExcel, SpdSheet.shtComExcel, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8f0cbc94 | this.Load | FP00180_MaterialImportPopup.cs:197 |  | FLAG | siComExcel | GetSheetInfo(spdComExcel.Name, spdComExcel.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9d37fc43 | this.Load | FP00180_MaterialImportPopup.cs:199 |  | GRID_INIT | siComExcel.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00180_MaterialImportPopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1142f884 | this.Load | FP00180_MaterialImportPopup.cs:189 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00180_MaterialImportPopup.Delete_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-507ad5e6 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:831 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-8d6271c8 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:835 | try | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6952bddd | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:837 | try | DATA_OP | req.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-7a0dfc8b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:838 | try | DATA_OP | req.Parameters["p_sys_flag"] | "DELETE_BUFFER" | 행/컬럼 값 대입 |  |  |  |
| AC-de885b73 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:839 | try | DATA_OP | req.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ef12df31 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:840 | try | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-40d8d2af | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:841 | try | DATA_OP | req.Parameters["p_company_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-07dd9250 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:842 | try | DATA_OP | req.Parameters["p_division_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-de4b65b3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:843 | try | DATA_OP | req.Parameters["p_site_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0b461424 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:844 | try | DATA_OP | req.Parameters["p_plant_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-34a11f45 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:845 | try | DATA_OP | req.Parameters["p_factory_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-130ed4cd | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:846 | try | DATA_OP | req.Parameters["p_operation_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-0ade63ed | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:847 | try | DATA_OP | req.Parameters["p_material_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-eb7c662c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:848 | try | DATA_OP | req.Parameters["p_material_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ec553436 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:849 | try | DATA_OP | req.Parameters["p_material_setup_group_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9bb5c347 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:850 | try | DATA_OP | req.Parameters["p_electrode_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2121f3a3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:851 | try | DATA_OP | req.Parameters["p_material_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c6f292b2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:852 | try | DATA_OP | req.Parameters["p_material_type_name"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ab6f4380 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:853 | try | DATA_OP | req.Parameters["p_model_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9898e37d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:854 | try | DATA_OP | req.Parameters["p_material_attribute1"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2ab2970b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:855 | try | DATA_OP | req.Parameters["p_material_location"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3a9d544f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:856 | try | DATA_OP | req.Parameters["p_active_flag"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-74d12650 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:857 | try | DATA_OP | req.Parameters["p_scp_material_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-4bda3e16 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:858 | try | DATA_OP | req.Parameters["p_description"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-34e12099 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:859 | try | DATA_OP | req.Parameters["p_prod_version_type"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-1c83a065 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:860 | try | DATA_OP | req.Parameters["p_equipment_count"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7606d3a6 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:862 | try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2b8c6fe | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:877 | try ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-baa953fd | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:880 | try | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |
| AC-e01413df | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:884 | catch ((Exception ex)) | RETURN | return bTrans; |  | 처리 중단/반환 |  |  |  |

## FP00180_MaterialImportPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f10d57 | Dispose | FP00180_MaterialImportPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00180_MaterialImportPopup.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc2440c3 | EditButton | FP00180_MaterialImportPopup.cs:262 | if (spdComExcel.ActiveSheetIndex == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ef718e7f | EditButton | FP00180_MaterialImportPopup.cs:263 | if (spdComExcel.ActiveSheetIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00180_MaterialImportPopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aae062d4 | ExcelButton | FP00180_MaterialImportPopup.cs:276 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00180_MaterialImportPopup.Find_Data

진입점: this.Load / this.btnSave.Click [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / FindButton / SaveButton [try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2ead484 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:344 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ab06665d | this.Load 외 4 | FP00180_MaterialImportPopup.cs:349 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-02604e0d | this.Load 외 4 | FP00180_MaterialImportPopup.cs:352 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-e7bce936 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:352 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20141ea3 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:358 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dc9559c6 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:361 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dcd429c2 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:370 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-3c091f32 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:372 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8185605e | this.Load 외 4 | FP00180_MaterialImportPopup.cs:376 | try ▸ lambda | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-6a8b317c | this.Load 외 4 | FP00180_MaterialImportPopup.cs:378 | try ▸ lambda | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-35754087 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:379 | try ▸ lambda | DATA_OP | request.Parameters["p_sys_flag"] | "S" | 행/컬럼 값 대입 |  |  |  |
| AC-20b42e19 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:380 | try ▸ lambda | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9d07adf4 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:381 | try ▸ lambda | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-378d3b98 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:385 | try ▸ lambda ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-1e2eb72c | this.Load 외 4 | FP00180_MaterialImportPopup.cs:389 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6ca6fd04 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:391 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0e8f8488 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:399 | try | GRID_BIND | siComExcel.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d34701a1 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:401 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b8d364f | this.Load 외 4 | FP00180_MaterialImportPopup.cs:404 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-730d0f97 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:407 | try | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-280c58eb | this.Load 외 4 | FP00180_MaterialImportPopup.cs:410 | try | GRID_INIT | siComExcel.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ff68f64b | this.Load 외 4 | FP00180_MaterialImportPopup.cs:418 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-8659a841 | this.Load 외 4 | FP00180_MaterialImportPopup.cs:423 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00180_MaterialImportPopup.Find_Data_Validation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98368f47 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:431 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-23f0534a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:436 | try | CALL_EXT | spdComExcel.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-224ad4a2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:439 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bd48840d | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:439 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3dacb810 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:445 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-eec5e1f2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:448 | try | GRID_INIT | siComExcel.ChangeSheet | (SpdSheet.shtComExcel) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc83015b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:457 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-cc97fb1c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:459 | try | DATA_OP | request.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-289726f1 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:460 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_VALID" | 행/컬럼 값 대입 |  |  |  |
| AC-a71da85a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:461 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-51e63f79 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:462 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-390bcc28 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:466 | try ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-c9aa178a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:470 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-292a8e00 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:479 | try | GRID_BIND | siComExcel.Query | (dsv) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9f2fb714 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:481 | try | GRID_LOCK | siComExcel.LockColumn | (0, siComExcel.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-22921033 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:484 | try | UI_MISC | SetSearchCount | (dsv) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e4634558 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:498 | try | GRID_STYLE | spdComExcel.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-22409c20 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:502 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00003") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-715b11dd | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:506 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## FP00180_MaterialImportPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea022210 | this.Load | FP00180_MaterialImportPopup.cs:159 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5dd02af | this.Load | FP00180_MaterialImportPopup.cs:161 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e8edb9ef | this.Load | FP00180_MaterialImportPopup.cs:172 |  | VALUE_SET | this.lblSheetName.Text | "[ " + sSheetName + " ] Excel Import" | 컨트롤 값 설정 |  |  |  |

## FP00180_MaterialImportPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87e9bf87 | this.Load | FP00180_MaterialImportPopup.cs:180 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a1abaad9 | this.Load | FP00180_MaterialImportPopup.cs:183 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtComExcel) | 데이터 객체 조작/조회 |  |  |  |

## FP00180_MaterialImportPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09d5de71 | this.Load | FP00180_MaterialImportPopup.cs:212 | try | GRID_INIT | siComExcel.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce4bac07 | this.Load | FP00180_MaterialImportPopup.cs:213 | try | GRID_INIT | siComExcel.ChangeActiveSheet | (SpdSheet.shtComExcel) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2dba1fcf | this.Load | FP00180_MaterialImportPopup.cs:218 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00180_MaterialImportPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ee63686 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:515 | if (siComExcel == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b95fd885 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:517 | if (siComExcel.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bd492576 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:522 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b6d64bb9 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:523 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a4005a40 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:526 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2c4cb7d1 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:568 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00041", new object[] { sMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-08230fae | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:574 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (sValidYN.Equals("N")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00051", new object[] { "Check Validation Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc6d8792 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:607 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-10e1ec4e | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:610 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fb71474f | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:614 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9c57d9ea | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:616 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0164660d | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:617 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-e875b3ae | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:618 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-4a84be55 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:619 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0195c941 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:620 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-7a633d62 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:621 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d570ea83 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:622 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-18130736 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:623 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-8fe48ecc | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:624 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-697dc241 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:625 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-e34a8b12 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:626 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_id"] | p_material_id | 행/컬럼 값 대입 |  |  |  |
| AC-690629ce | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:627 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_name"] | p_material_name | 행/컬럼 값 대입 |  |  |  |
| AC-61f044ab | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:628 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_setup_group_id"] | p_material_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-0225ced5 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:629 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-905a5fd4 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:630 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_type"] | p_material_type | 행/컬럼 값 대입 |  |  |  |
| AC-d24e50b6 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:631 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_type_name"] | p_material_type_name | 행/컬럼 값 대입 |  |  |  |
| AC-21fe1494 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:632 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_model_type"] | p_model_type | 행/컬럼 값 대입 |  |  |  |
| AC-3db85cf5 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:633 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_attribute1"] | p_material_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-029915b0 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:634 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_material_location"] | p_material_location | 행/컬럼 값 대입 |  |  |  |
| AC-5d712d69 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:635 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-be4425ec | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:636 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_scp_material_id"] | p_scp_material_id | 행/컬럼 값 대입 |  |  |  |
| AC-5d0726b5 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:637 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e835239e | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:638 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-d3202730 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:639 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | DATA_OP | req.Parameters["p_equipment_count"] | p_equipment_count | 행/컬럼 값 대입 |  |  |  |
| AC-4ebc46fc | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:641 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f83544c | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:641 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-01dad5d7 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:647 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ if (tran.Success) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0fec3dff | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:651 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0]… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d947192d | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:660 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ if (iCount > 0 && bValid == true) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tabl… | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c7ebc27 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:666 | try ▸ if (siComExcel.SheetName == SpdSheet.shtComExcel) ▸ else of (iCount > 0 && bValid == true) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] {"Check Sheet Data" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1768d24e | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:669 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b804184f | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:673 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0969e267 | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:674 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-0a373ede | this.btnSave.Click 외 1 | FP00180_MaterialImportPopup.cs:678 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00180_MaterialImportPopup.Save_Data_Buffer

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5af76d21 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:687 | if (dtData == null \|\| dtData.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b61cd388 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:752 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-fb1f3c5a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:755 | try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.FP.Master.WSL/FoxDataService.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-247205e2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:759 | try ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b04ea7d6 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:761 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6a1cc1b3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:762 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-cad88323 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:763 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-6e6e3222 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:764 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-728eaa40 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:765 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-be798980 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:766 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-2d558537 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:767 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a20610c9 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:768 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-334ff3da | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:769 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_factory_id"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-d275e8e3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:770 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-52b08d2b | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:771 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_id"] | p_material_id | 행/컬럼 값 대입 |  |  |  |
| AC-4c694258 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:772 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_name"] | p_material_name | 행/컬럼 값 대입 |  |  |  |
| AC-09e175c0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:773 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_setup_group_id"] | p_material_setup_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-b3bb4824 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:774 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-b9c8a04f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:775 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_type"] | p_material_type | 행/컬럼 값 대입 |  |  |  |
| AC-d1cd3850 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:776 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_type_name"] | p_material_type_name | 행/컬럼 값 대입 |  |  |  |
| AC-a442c00a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:777 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_model_type"] | p_model_type | 행/컬럼 값 대입 |  |  |  |
| AC-7b047ea4 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:778 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_attribute1"] | p_material_attribute1 | 행/컬럼 값 대입 |  |  |  |
| AC-65e8c041 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:779 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_material_location"] | p_material_location | 행/컬럼 값 대입 |  |  |  |
| AC-6fe5f79e | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:780 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b55180f0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:781 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_scp_material_id"] | p_scp_material_id | 행/컬럼 값 대입 |  |  |  |
| AC-354f932a | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:782 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-fe9ff6a8 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:783 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_prod_version_type"] | p_prod_version_type | 행/컬럼 값 대입 |  |  |  |
| AC-f12079f5 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:784 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_equipment_count"] | p_equipment_count | 행/컬럼 값 대입 |  |  |  |
| AC-d27ab7c1 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:786 | try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8280d2e3 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:786 | try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-9ce985d2 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:795 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8692c68 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:805 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4d9632f0 | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:811 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e25fc49f | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:816 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00180_MaterialImportPopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2802a5a0 | SaveButton | FP00180_MaterialImportPopup.cs:270 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00180_MaterialImportPopup.SetSheetColorValidation

진입점: this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogResult.OK) ▸ if (dtExcel != null && dtExcel.Rows.Count > 0) ▸ if (bFlag) ▸ try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7674f35c | this.btnImport.Click [try ▸ if (opd.ShowDialog() == DialogRe… | FP00180_MaterialImportPopup.cs:922 | if (siComExcel.GetMaxRowIndex() > 0) ▸ for (i <= siComExcel.GetMaxRowIndex()) ▸ if (!string.IsNullOrEmpty(sMsg) \|\| sValid.Equals("N")) | GRID_SET | siComExcel.ActiveSheet.Rows[i].BackColor | ControlColor.InvalidColor | 그리드 속성/값 설정 |  |  |  |

## FP00180_MaterialImportPopup.SetSheetHeaderWidth

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c754cf4 | (진입점 미연결) | FP00180_MaterialImportPopup.cs:935 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | CALL_EXT | siComExcel.ActiveSheet.GetPreferredCellSize | (0, idx) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4a35981 | (진입점 미연결) | FP00180_MaterialImportPopup.cs:936 | for (idx < siComExcel.ActiveSheet.Columns.Count) ▸ if (Convert.ToInt32(siComExcel.ActiveSheet.Columns[idx].Width) == 0) | GRID_SET | siComExcel.ActiveSheet.Columns[idx].Width | sz.Width | 그리드 속성/값 설정 |  |  |  |

## FP00180_MaterialImportPopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a2e0a44 | this.Load [try] | FP00180_MaterialImportPopup.cs:226 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8344443b | this.Load [try] | FP00180_MaterialImportPopup.cs:227 | if (sheetName.Equals(SpdSheet.shtComExcel)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-69397923 | this.Load [try] | FP00180_MaterialImportPopup.cs:231 |  | GRID_INIT | siComExcel.SetSheetHeaderColumn_FP | (siComExcel, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-c17f3486 | this.Load [try] | FP00180_MaterialImportPopup.cs:232 |  | GRID_INIT | siComExcel.Freeze | (0, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00180_MaterialImportPopup.spdComExce_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb254122 | (진입점 미연결) | FP00180_MaterialImportPopup.cs:901 |  | FLAG | iClick_Row | e.Row | 화면 필드/플래그 변경 |  |  |  |

