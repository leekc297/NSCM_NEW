# AS-IS 액션 대조표 — FP90000

> 원천: `Doc/asisfacts/screens/FP90000/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 313행 · 메서드 50 · 종류 CALL_EXT 70 · MESSAGE 43 · DATA_OP 33 · UI_PROP 28 · ENDPOINT 27 · RETURN 21 · GRID_SET 13 · COMBO_DATA 13 · FLAG 12 · VALUE_SET 9 · GRID_INIT 7 · GRID_LOCK 7 · POPUP 6 · UI_MISC 5 · THROW 5 · VALUE_CLEAR 5 · GRID_COMBO 3 · STATE_RESET 2 · EXCEL 1 · GRID_BIND 1 · LIST_REBIND 1 · VALIDATE 1 · ⚠ 의미 확인 필요 70


## FP90000_Data_Handling.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e02e34b5 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1402 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a5f72505 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1403 |  | UI_PROP | p.Filter | ds_ConditionOnload | 속성 Filter 설정 |  |  |  |
| AC-65feb548 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1404 |  | GRID_SET | p.KeyColumns["Company_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-36afcc41 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1405 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-771a2c43 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1406 |  | GRID_SET | p.KeyColumns["site_id"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-b60a92ec | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1407 |  | GRID_SET | p.KeyColumns["ITEM_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-f8f3205d | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1409 |  | UI_PROP | p.DoSearchData | FP00180_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-a6389016 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1410 |  | UI_PROP | p.DoLineCheck | FP00180_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-484702bc | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1411 |  | UI_PROP | p.DoSaveData | FP00180_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-1d769e23 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1412 |  | UI_PROP | p.DoValidationData | FP00180_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-c59c0ee0 | this.btnExcelImport.Click | FP90000_Data_Handling.cs:1413 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP90000_Data_Handling.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0166cb6d | this.btnSql.Click | FP90000_Data_Handling.cs:436 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-622d0212 | this.btnSql.Click | FP90000_Data_Handling.cs:437 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-977c6ff5 | this.btnSql.Click | FP90000_Data_Handling.cs:439 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00180_FIND_FP00180") | 데이터 객체 조작/조회 |  |  |  |
| AC-909666ec | this.btnSql.Click | FP90000_Data_Handling.cs:440 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP90000_Data_Handling.cbo_active_SelectedIndexChanged

진입점: this.cbo_active.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a040ca9 | this.cbo_active.SelectedIndexChanged | FP90000_Data_Handling.cs:1329 | try | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ACTIVE_FLAG", pActive) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b9091dc0 | this.cbo_active.SelectedIndexChanged | FP90000_Data_Handling.cs:1333 | catch () | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ACTIVE_FLAG", "") | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.cbo_class1_SelectedIndexChanged

진입점: this.cbo_class1.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9412e1f | this.cbo_class1.SelectedIndexChanged | FP90000_Data_Handling.cs:1306 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ITEM_CLASS_LEVEL_1", class1) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.cbo_class2_SelectedIndexChanged

진입점: this.cbo_class2.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a2ad59c | this.cbo_class2.SelectedIndexChanged | FP90000_Data_Handling.cs:1345 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ITEM_CLASS_LEVEL_2", class2) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.cbo_itemType_SelectedIndexChanged

진입점: this.cbo_itemType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20d5cc38 | this.cbo_itemType.SelectedIndexChanged | FP90000_Data_Handling.cs:1293 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ITEM_TYPE", sSite) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51b6b12f | this.Load | FP90000_Data_Handling.cs:177 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMaterial, SpdSheet.shtMaterial, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4d8e9eef | this.Load | FP90000_Data_Handling.cs:179 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMaterial) | 화면 필드/플래그 변경 |  |  |  |
| AC-c26a1161 | this.Load | FP90000_Data_Handling.cs:181 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMaterial) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP90000_Data_Handling.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2094a49 | DeleteButton | FP90000_Data_Handling.cs:249 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP90000_Data_Handling.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c36168cc | Dispose | FP90000_Data_Handling.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP90000_Data_Handling.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9050c486 | EditButton | FP90000_Data_Handling.cs:258 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e3c16c0a | EditButton | FP90000_Data_Handling.cs:260 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-f80eba63 | EditButton | FP90000_Data_Handling.cs:270 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.DEMAND_LOT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c4be484a | EditButton | FP90000_Data_Handling.cs:271 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.SETUP_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2accf054 | EditButton | FP90000_Data_Handling.cs:272 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.MATERIAL_CLASS), siMain.GetColumnIndex(DefColumns.FORMAT… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dcabe2ca | EditButton | FP90000_Data_Handling.cs:273 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), siMain.GetColumnIndex(DefColumns.FORM_A… | 그리드 편집 잠금/해제 |  |  |  |
| AC-280ca595 | EditButton | FP90000_Data_Handling.cs:274 | if (spdMain != null) ▸ if (isEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), siMain.GetColumnIndex(DefColumns.ACTIVE_FL… | 그리드 편집 잠금/해제 |  |  |  |

## FP90000_Data_Handling.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31c14a30 | ExcelButton | FP90000_Data_Handling.cs:775 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP90000_Data_Handling.filterForm_onload

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6127547b | this.Load | FP90000_Data_Handling.cs:818 |  | VALUE_SET | cbo_active.InitValue | "Y" | 컨트롤 값 설정 |  |  |  |

## FP90000_Data_Handling.FindAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0e8b69b | (진입점 미연결) | FP90000_Data_Handling.cs:1237 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b48e9e2 | (진입점 미연결) | FP90000_Data_Handling.cs:1238 | try | CALL_EXT | set.Overwrite | (0, ds_ConditionFilter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d4e79c2 | (진입점 미연결) | FP90000_Data_Handling.cs:1240 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_type) ⇒ FP_Master.PR_UI_FP00180_FINDATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f990c53 | (진입점 미연결) | FP90000_Data_Handling.cs:1240 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDATTRIBUTE", se… |  | 처리 중단/반환 |  |  |  |
| AC-c0fd6c9c | (진입점 미연결) | FP90000_Data_Handling.cs:1244 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP90000_Data_Handling.FindDataMaterial

진입점: popSql.OnSql [if (programID == "PR_UI_FP00180_FIND_FP00180")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b02061d4 | popSql.OnSql [if (programID == "PR_UI_FP00180_FIND_FP00180")… 외 3 | FP90000_Data_Handling.cs:1278 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("DataHandling", "test_func", ds_ConditionFilter.Dictionary, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=test_func] \| FP\MASTER\DataHan… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-3b7f081b | popSql.OnSql [if (programID == "PR_UI_FP00180_FIND_FP00180")… 외 3 | FP90000_Data_Handling.cs:1278 | try | RETURN | return DataService.FP_ExecuteQuery("DataHandling", "test_func", ds_ConditionFilt… |  | 처리 중단/반환 |  |  |  |
| AC-6db3566e | popSql.OnSql [if (programID == "PR_UI_FP00180_FIND_FP00180")… 외 3 | FP90000_Data_Handling.cs:1283 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP90000_Data_Handling.FindDataMaterialAsync

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-056e0bcc | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:454 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c825d2f6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:463 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd32d2a3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:465 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3e2f1f9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:468 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-79d2fcf3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:470 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-33f9b705 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:479 | try | FLAG | dsMain | FindDataMaterial(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-fd7e1053 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:484 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow ro in dsMain.Tables[0].Rows) | CALL_EXT | ro.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-03423a35 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:491 | try ▸ if (radioButton1.Checked) | MESSAGE | MessageBox.Show | (radioButton1.Text, "try_batch_parameter_not_define") | 메시지 표시 |  |  |  |
| AC-058e3173 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:492 | try ▸ if (radioButton1.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_not_define", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_not_define] … | 엔드포인트 호출 |  |  |  |
| AC-dea37fc0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:493 | try ▸ if (radioButton1.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_not_define", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_not_define] … | 엔드포인트 호출 |  |  |  |
| AC-06eda5bc | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:498 | try ▸ if (radioButton1.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString()=="FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-a4184ceb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:505 | try ▸ if (radioButton1.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-f87bfd3c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:512 | try ▸ if (radioButton2.Checked) | MESSAGE | MessageBox.Show | (radioButton2.Text, "try_batch_parameter_not_provided") | 메시지 표시 |  |  |  |
| AC-a3982d14 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:513 | try ▸ if (radioButton2.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_not_provided", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_not_provided… | 엔드포인트 호출 |  |  |  |
| AC-d0a22824 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:514 | try ▸ if (radioButton2.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_not_provided", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_not_provided… | 엔드포인트 호출 |  |  |  |
| AC-1be8cf64 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:519 | try ▸ if (radioButton2.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-ed2133c3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:526 | try ▸ if (radioButton2.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-8d876156 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:534 | try ▸ if (radioButton3.Checked) | MESSAGE | MessageBox.Show | (radioButton3.Text, "try_batch_parameter_define_string_send_number") | 메시지 표시 |  |  |  |
| AC-a09fb9d0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:535 | try ▸ if (radioButton3.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_string_send_number", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-1b5178c9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:536 | try ▸ if (radioButton3.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_string_send_number", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-504a9444 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:541 | try ▸ if (radioButton3.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-e24c1be2 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:548 | try ▸ if (radioButton3.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-78fb0283 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:556 | try ▸ if (radioButton4.Checked) | MESSAGE | MessageBox.Show | (radioButton4.Text, "try_batch_parameter_define_number_send_string") | 메시지 표시 |  |  |  |
| AC-e3a2b223 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:557 | try ▸ if (radioButton4.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_number_send_string", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-05562e03 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:558 | try ▸ if (radioButton4.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_number_send_string", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-068e8777 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:563 | try ▸ if (radioButton4.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-5c992bb9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:570 | try ▸ if (radioButton4.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-1aee50a4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:578 | try ▸ if (radioButton5.Checked) | MESSAGE | MessageBox.Show | (radioButton5.Text, "try_batch_parameter_define_string_send_null") | 메시지 표시 |  |  |  |
| AC-0c0e0710 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:579 | try ▸ if (radioButton5.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_string_send_null", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-a54d5aeb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:580 | try ▸ if (radioButton5.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_string_send_null", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-8e24d0a4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:585 | try ▸ if (radioButton5.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-bb68dc5f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:592 | try ▸ if (radioButton5.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-7c32ec95 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:600 | try ▸ if (radioButton6.Checked) | MESSAGE | MessageBox.Show | (radioButton6.Text, "try_batch_parameter_define_string_send_empty_string") | 메시지 표시 |  |  |  |
| AC-8874aece | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:601 | try ▸ if (radioButton6.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_string_send_empty_string", dsMain, 0, "MASTER… ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-9efced40 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:602 | try ▸ if (radioButton6.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_string_send_empty_string", dsMain, 0, "MASTER… ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-d999fcab | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:607 | try ▸ if (radioButton6.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-3e777ac8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:614 | try ▸ if (radioButton6.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-75e0e8ac | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:622 | try ▸ if (radioButton7.Checked) | MESSAGE | MessageBox.Show | (radioButton7.Text, "try_batch_parameter_define_string_send_empty_space") | 메시지 표시 |  |  |  |
| AC-e7c9023b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:623 | try ▸ if (radioButton7.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_string_send_empty_space", dsMain, 0, "MASTER"… ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-eee6b16a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:624 | try ▸ if (radioButton7.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_string_send_empty_space", dsMain, 0, "MASTER"… ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-d939caf8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:629 | try ▸ if (radioButton7.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-888e9bb6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:636 | try ▸ if (radioButton7.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-8692a9fa | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:644 | try ▸ if (radioButton8.Checked) | MESSAGE | MessageBox.Show | (radioButton8.Text, "try_batch_parameter_define_string_send_linefeed") | 메시지 표시 |  |  |  |
| AC-de073c73 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:645 | try ▸ if (radioButton8.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_string_send_linefeed", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-b4cfa5c8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:646 | try ▸ if (radioButton8.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_string_send_linefeed", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_strin… | 엔드포인트 호출 |  |  |  |
| AC-893e9378 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:651 | try ▸ if (radioButton8.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-cfc9ec0a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:658 | try ▸ if (radioButton8.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-2a3b6d26 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:666 | try ▸ if (radioButton9.Checked) | MESSAGE | MessageBox.Show | (radioButton9.Text, "try_batch_parameter_define_number_send_null") | 메시지 표시 |  |  |  |
| AC-e808af55 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:667 | try ▸ if (radioButton9.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_number_send_null", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-eb5efa76 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:668 | try ▸ if (radioButton9.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_number_send_null", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-04332349 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:673 | try ▸ if (radioButton9.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-676d9b0f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:680 | try ▸ if (radioButton9.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-a64b4015 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:688 | try ▸ if (radioButton10.Checked) | MESSAGE | MessageBox.Show | (radioButton10.Text, "try_batch_parameter_define_number_send_empty_string") | 메시지 표시 |  |  |  |
| AC-4698d010 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:689 | try ▸ if (radioButton10.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_number_send_empty_string", dsMain, 0, "MASTER… ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-6d9fd95a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:690 | try ▸ if (radioButton10.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_number_send_empty_string", dsMain, 0, "MASTER… ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-4a8a30a4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:695 | try ▸ if (radioButton10.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-1a2894da | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:702 | try ▸ if (radioButton10.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-7a78761a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:710 | try ▸ if (radioButton11.Checked) | MESSAGE | MessageBox.Show | (radioButton11.Text, "try_batch_parameter_define_number_send_space") | 메시지 표시 |  |  |  |
| AC-ba126191 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:711 | try ▸ if (radioButton11.Checked) | ENDPOINT | DataService.FP_UpdateBatch | ("DataHandling", "try_batch_parameter_define_number_send_space", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-da0bd2b3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:712 | try ▸ if (radioButton11.Checked) | ENDPOINT | DataService.FP_PseudoBatch | ("DataHandling", "try_batch_parameter_define_number_send_space", dsMain, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralPseudoBatch [batchId=try_batch_parameter_define_numbe… | 엔드포인트 호출 |  |  |  |
| AC-727be84a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:717 | try ▸ if (radioButton11.Checked) ▸ if (ubRes.Good()) ▸ if (ubRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[UpdateBatch Error] "+ ubRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-c196792c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:724 | try ▸ if (radioButton11.Checked) ▸ if (pbRes.Good()) ▸ if (pbRes.Rows[0]["RESULT"].ToString() == "FAIL") | MESSAGE | MessageBox.Show | ("[PseudoBatch Error] " +pbRes.Rows[0]["Exception"].ToString()) | 메시지 표시 |  |  |  |
| AC-22784425 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:737 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-015d68c8 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:738 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b898349c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:739 | try | CALL_EXT | siMain.RightColMerge | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-31c06320 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:753 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a376ddf | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:759 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5d06d47d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP90000_Data_Handling.cs:761 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP90000_Data_Handling.FindFormAttribute

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e61cc09b | (진입점 미연결) | FP90000_Data_Handling.cs:1257 | try | CALL_EXT | set.setInitColumns | (0, new List<string> { "lookup_type_code" }) | ⚠ 의미 확인 필요 |  |  |  |
| AC-25287ad5 | (진입점 미연결) | FP90000_Data_Handling.cs:1258 | try | CALL_EXT | set.Overwrite | (0, ds_ConditionFilter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-64746697 | (진입점 미연결) | FP90000_Data_Handling.cs:1260 | try | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE", set, UserInfoContext.Current.UserId, p_sys_t… ⇒ FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9198f30b | (진입점 미연결) | FP90000_Data_Handling.cs:1260 | try | RETURN | return Data_FP.CallStandardProcedure("FP_Master.PR_UI_FP00180_FINDFORMATTRIBUTE"… |  | 처리 중단/반환 |  |  |  |
| AC-69e207cc | (진입점 미연결) | FP90000_Data_Handling.cs:1264 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP90000_Data_Handling.fn_Callback

진입점: this.Load / this.mcbo_division.SelectedIndexChanged [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6715db7f | this.Load 외 2 | FP90000_Data_Handling.cs:1094 | else of (strErrorCode <= -1) ▸ if (strServiceId == "getListDivision") | CALL_EXT | ds_ConditionFilter.setColumn | (0, "DIVISION_LT", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-552ff2a1 | this.Load 외 2 | FP90000_Data_Handling.cs:1101 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ if (strServiceId == "getListSite") | VALUE_CLEAR | mcbo_site.InitValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-333fb3dd | this.Load 외 2 | FP90000_Data_Handling.cs:1102 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ if (strServiceId == "getListSite") | CALL_EXT | mcbo_site.updateToDataset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-723f5b6b | this.Load 외 2 | FP90000_Data_Handling.cs:1108 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_itemType.insertRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a080267c | this.Load 외 2 | FP90000_Data_Handling.cs:1109 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_itemType.setColumn | (0, "CODE", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cad387b | this.Load 외 2 | FP90000_Data_Handling.cs:1110 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_itemType.setColumn | (0, "NAME", "ALL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e032b65 | this.Load 외 2 | FP90000_Data_Handling.cs:1112 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | VALUE_CLEAR | cbo_itemType.InitValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-0eba4e2e | this.Load 외 2 | FP90000_Data_Handling.cs:1113 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | cbo_itemType.updateToDataset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-5235f9a3 | this.Load 외 2 | FP90000_Data_Handling.cs:1115 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_class1.insertRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3589ced1 | this.Load 외 2 | FP90000_Data_Handling.cs:1116 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_class1.setColumn | (0, "CODE", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-639a11f3 | this.Load 외 2 | FP90000_Data_Handling.cs:1117 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_class1.setColumn | (0, "NAME", "ALL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-04fc600e | this.Load 외 2 | FP90000_Data_Handling.cs:1119 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | VALUE_CLEAR | cbo_class1.InitValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-866aea9c | this.Load 외 2 | FP90000_Data_Handling.cs:1120 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | cbo_class1.updateToDataset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9efbeb44 | this.Load 외 2 | FP90000_Data_Handling.cs:1122 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_class2.insertRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c0e5e207 | this.Load 외 2 | FP90000_Data_Handling.cs:1123 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_class2.setColumn | (0, "CODE", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0dd9e8a5 | this.Load 외 2 | FP90000_Data_Handling.cs:1124 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | ds_class2.setColumn | (0, "NAME", "ALL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff1a8d00 | this.Load 외 2 | FP90000_Data_Handling.cs:1126 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | VALUE_CLEAR | cbo_class2.InitValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-628f1f03 | this.Load 외 2 | FP90000_Data_Handling.cs:1127 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ if (strServiceId == "… | CALL_EXT | cbo_class2.updateToDataset | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-68827b3f | this.Load 외 2 | FP90000_Data_Handling.cs:1133 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ else of (strServiceId… | CALL_EXT | ds_class2.insertRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e0c0d8f2 | this.Load 외 2 | FP90000_Data_Handling.cs:1134 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ else of (strServiceId… | CALL_EXT | ds_class2.setColumn | (0, "CODE", "") | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0f3a3c6 | this.Load 외 2 | FP90000_Data_Handling.cs:1135 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ else of (strServiceId… | CALL_EXT | ds_class2.setColumn | (0, "NAME", "ALL") | ⚠ 의미 확인 필요 |  |  |  |
| AC-d600fc6c | this.Load 외 2 | FP90000_Data_Handling.cs:1137 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ else of (strServiceId… | VALUE_CLEAR | cbo_class2.InitValue | "" | 컨트롤 값 비움 |  |  |  |
| AC-0ef704ee | this.Load 외 2 | FP90000_Data_Handling.cs:1138 | else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ else of (strServiceId == "getListSite") ▸ else of (strServiceId… | CALL_EXT | cbo_class2.updateToDataset | () | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c8ae55d | this.Load | FP90000_Data_Handling.cs:129 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP90000_Data_Handling.FP00180_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2479af1b | (진입점 미연결) | FP90000_Data_Handling.cs:1397 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.FP00180_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61f130c0 | (진입점 미연결) | FP90000_Data_Handling.cs:1371 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP90000_Data_Handling", "FP90000_Data_Handling_EXCEL_UPDATE_BATCH", data, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=FP90000_Data_Handling_EXCEL_UPDA… | 엔드포인트 호출 |  |  |  |
| AC-b284e2f9 | (진입점 미연결) | FP90000_Data_Handling.cs:1375 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.FP00180_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a44115cb | (진입점 미연결) | FP90000_Data_Handling.cs:1366 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.FP00180_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f16cb481 | (진입점 미연결) | FP90000_Data_Handling.cs:1381 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-7f01720e | (진입점 미연결) | FP90000_Data_Handling.cs:1382 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP90000_Data_Handling","delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\{… | 엔드포인트 호출 |  |  |  |
| AC-9bf58a60 | (진입점 미연결) | FP90000_Data_Handling.cs:1386 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP90000_Data_Handling","insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\{?def… | 엔드포인트 호출 |  |  |  |
| AC-d13ce485 | (진입점 미연결) | FP90000_Data_Handling.cs:1390 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP90000_Data_Handling","find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-76702f14 | (진입점 미연결) | FP90000_Data_Handling.cs:1390 |  | RETURN | return DataService.FP_ExecuteQuery( "FP90000_Data_Handling","find_Excel_buffer_v… |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.gfn_Msg

진입점: this.Load [if (strErrorCode <= -1)] / this.mcbo_division.SelectedIndexChanged [try ▸ if (strErrorCode <= -1)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-146054eb | this.Load [if (strErrorCode <= -1)] 외 2 | FP90000_Data_Handling.cs:1074 |  | MESSAGE | MessageBox.Show | (message, title) | 메시지 표시 |  |  |  |

## FP90000_Data_Handling.gfn_Service

진입점: this.Load / this.mcbo_division.SelectedIndexChanged [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d75417f | this.Load 외 2 | FP90000_Data_Handling.cs:883 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ if (service_id == _FormProce… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1ac14470 | this.Load 외 2 | FP90000_Data_Handling.cs:885 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ if (service_id == _FormProce… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d3b9fa79 | this.Load 외 2 | FP90000_Data_Handling.cs:891 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-63aa3c6e | this.Load 외 2 | FP90000_Data_Handling.cs:893 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-de8041e0 | this.Load 외 2 | FP90000_Data_Handling.cs:898 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c3a99a5 | this.Load 외 2 | FP90000_Data_Handling.cs:900 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ad3354ff | this.Load 외 2 | FP90000_Data_Handling.cs:905 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-71e46798 | this.Load 외 2 | FP90000_Data_Handling.cs:907 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-68af2789 | this.Load 외 2 | FP90000_Data_Handling.cs:912 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-62fbc3a5 | this.Load 외 2 | FP90000_Data_Handling.cs:915 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDCLASS1", set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP00180_FINDCLASS1 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5922c47 | this.Load 외 2 | FP90000_Data_Handling.cs:918 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | UI_PROP | tmp.Tables[0].TableName | "FindClass1" | 속성 TableName 설정 |  |  |  |
| AC-27693dc2 | this.Load 외 2 | FP90000_Data_Handling.cs:919 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | DATA_OP | ret.Tables.Add | (tmp.Tables[0].Copy()) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0f2ced3 | this.Load 외 2 | FP90000_Data_Handling.cs:919 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | DATA_OP | tmp.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a3f57cca | this.Load 외 2 | FP90000_Data_Handling.cs:921 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDCLASS2", set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP00180_FINDCLASS2 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-16c26773 | this.Load 외 2 | FP90000_Data_Handling.cs:924 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | UI_PROP | tmp.Tables[0].TableName | "FindClass2" | 속성 TableName 설정 |  |  |  |
| AC-fda86b39 | this.Load 외 2 | FP90000_Data_Handling.cs:925 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | DATA_OP | ret.Tables.Add | (tmp.Tables[0].Copy()) | 데이터 객체 조작/조회 |  |  |  |
| AC-c1f6b081 | this.Load 외 2 | FP90000_Data_Handling.cs:925 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | DATA_OP | tmp.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c16b524a | this.Load 외 2 | FP90000_Data_Handling.cs:927 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_FINDITEMTYPE", set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP00180_FINDITEMTYPE | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4d2de96b | this.Load 외 2 | FP90000_Data_Handling.cs:930 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | UI_PROP | tmp.Tables[0].TableName | "FindItemType" | 속성 TableName 설정 |  |  |  |
| AC-a5aabd56 | this.Load 외 2 | FP90000_Data_Handling.cs:931 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | DATA_OP | ret.Tables.Add | (tmp.Tables[0].Copy()) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4f50443 | this.Load 외 2 | FP90000_Data_Handling.cs:931 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | DATA_OP | tmp.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a18256c3 | this.Load 외 2 | FP90000_Data_Handling.cs:938 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-368aeae6 | this.Load 외 2 | FP90000_Data_Handling.cs:940 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a48646d0 | this.Load 외 2 | FP90000_Data_Handling.cs:945 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | CALL_EXT | set.Overwrite | (0, service_param) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bc329c15 | this.Load 외 2 | FP90000_Data_Handling.cs:947 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, set, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-254cc461 | this.Load 외 2 | FP90000_Data_Handling.cs:951 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (service_id == _Form… | COMBO_DATA | Data_FP.CallStandardProcedure | (full_service_id, service_param, UserInfoContext.Current.UserId) ⇒ FP_Master.PR_UI_FP_MASTER_FORM_CODE\|FP_Master.PR_UI_FP00100_LINE\|FP_Master.PR_… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2dd7fb2e | this.Load 외 2 | FP90000_Data_Handling.cs:964 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ if (ret != null) ▸ if (outpu… | STATE_RESET | output_params[i].Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-2ac27f35 | this.Load 외 2 | FP90000_Data_Handling.cs:965 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ if (ret != null) ▸ if (outpu… | DATA_OP | output_params[i].Tables.Add | (ret.Tables[i].Copy()) | 데이터 객체 조작/조회 |  |  |  |
| AC-549fd3df | this.Load 외 2 | FP90000_Data_Handling.cs:965 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ if (ret != null) ▸ if (outpu… | DATA_OP | ret.Tables[i].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9eb01d76 | this.Load 외 2 | FP90000_Data_Handling.cs:966 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ if (ret != null) ▸ if (outpu… | CALL_EXT | output_params[i].Fire | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-281d2e92 | this.Load 외 2 | FP90000_Data_Handling.cs:976 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (ret != null) ▸ if (… | STATE_RESET | output_params[i].Tables.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1fbbff70 | this.Load 외 2 | FP90000_Data_Handling.cs:977 | try ▸ foreach (LocalDataRow param in ds_Service.Rows) ▸ if (param["SVC_ID"].Value.ToLower() == key.ToLower()) ▸ else of (ret != null) ▸ if (… | CALL_EXT | output_params[i].Fire | () | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60865937 | this.Load | FP90000_Data_Handling.cs:154 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3de29c03 | this.Load | FP90000_Data_Handling.cs:156 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-609ac7a3 | this.Load | FP90000_Data_Handling.cs:157 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-b0c06652 | this.Load | FP90000_Data_Handling.cs:160 | try | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cbo_active, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c2017e96 | this.Load | FP90000_Data_Handling.cs:161 | try | VALUE_SET | cbo_active.InitValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-f9c40c24 | this.Load | FP90000_Data_Handling.cs:166 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP90000_Data_Handling.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d50f753 | this.Load | FP90000_Data_Handling.cs:219 |  | UI_PROP | mcbo_division.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d1da0396 | this.Load | FP90000_Data_Handling.cs:220 |  | UI_PROP | mcbo_site.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP90000_Data_Handling.InitLocalDataSet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eafea117 | this.Load | FP90000_Data_Handling.cs:1024 |  | UI_PROP | mcbo_division.Tag | ds_division | 속성 Tag 설정 |  |  |  |
| AC-61c8b14b | this.Load | FP90000_Data_Handling.cs:1025 |  | UI_PROP | mcbo_site.Tag | ds_site | 속성 Tag 설정 |  |  |  |
| AC-80b572f9 | this.Load | FP90000_Data_Handling.cs:1026 |  | UI_PROP | cbo_class1.Tag | ds_class1 | 속성 Tag 설정 |  |  |  |
| AC-eb8c7e53 | this.Load | FP90000_Data_Handling.cs:1027 |  | UI_PROP | cbo_class2.Tag | ds_class2 | 속성 Tag 설정 |  |  |  |
| AC-a4cc7679 | this.Load | FP90000_Data_Handling.cs:1028 |  | UI_PROP | cbo_itemType.Tag | ds_itemType | 속성 Tag 설정 |  |  |  |
| AC-2dd6e610 | this.Load | FP90000_Data_Handling.cs:1030 |  | UI_PROP | ds_division.Control | mcbo_division | 속성 Control 설정 |  |  |  |
| AC-a66c4daa | this.Load | FP90000_Data_Handling.cs:1031 |  | UI_PROP | ds_site.Control | mcbo_site | 속성 Control 설정 |  |  |  |
| AC-7a659cc7 | this.Load | FP90000_Data_Handling.cs:1032 |  | UI_PROP | ds_class1.Control | cbo_class1 | 속성 Control 설정 |  |  |  |
| AC-2f9492c9 | this.Load | FP90000_Data_Handling.cs:1033 |  | UI_PROP | ds_class2.Control | cbo_class2 | 속성 Control 설정 |  |  |  |
| AC-0c67a348 | this.Load | FP90000_Data_Handling.cs:1034 |  | UI_PROP | ds_itemType.Control | cbo_itemType | 속성 Control 설정 |  |  |  |
| AC-dfd6eb0a | this.Load | FP90000_Data_Handling.cs:1036 |  | UI_PROP | ds_division.clsCtrl | ds_site.clsCtrl = ds_class1.clsCtrl = ds_class2.clsCtrl = ds_itemType.clsCtrl = clsCtrl | 속성 clsCtrl 설정 |  |  |  |
| AC-bd5fdeea | this.Load | FP90000_Data_Handling.cs:1036 |  | UI_PROP | ds_site.clsCtrl | ds_class1.clsCtrl = ds_class2.clsCtrl = ds_itemType.clsCtrl = clsCtrl | 속성 clsCtrl 설정 |  |  |  |
| AC-ee4455af | this.Load | FP90000_Data_Handling.cs:1036 |  | UI_PROP | ds_class1.clsCtrl | ds_class2.clsCtrl = ds_itemType.clsCtrl = clsCtrl | 속성 clsCtrl 설정 |  |  |  |
| AC-67754e45 | this.Load | FP90000_Data_Handling.cs:1036 |  | UI_PROP | ds_class2.clsCtrl | ds_itemType.clsCtrl = clsCtrl | 속성 clsCtrl 설정 |  |  |  |
| AC-d6fde3ea | this.Load | FP90000_Data_Handling.cs:1036 |  | UI_PROP | ds_itemType.clsCtrl | clsCtrl | 속성 clsCtrl 설정 |  |  |  |
| AC-a540009a | this.Load | FP90000_Data_Handling.cs:1038 |  | CALL_EXT | ds_Service.addRow | (5) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cedcff5b | this.Load | FP90000_Data_Handling.cs:1040 |  | GRID_SET | ds_Service.Rows[0]["IN_DATASET_LIST"].Obj | ds_ConditionOnload | 그리드 속성/값 설정 |  |  |  |
| AC-cc8aa499 | this.Load | FP90000_Data_Handling.cs:1041 |  | GRID_SET | ds_Service.Rows[0]["OUT_DATASET_LIST"].Obj | new List<RemoteDataSet> { ds_division } | 그리드 속성/값 설정 |  |  |  |
| AC-c84ecee3 | this.Load | FP90000_Data_Handling.cs:1044 |  | GRID_SET | ds_Service.Rows[1]["IN_DATASET_LIST"].Obj | ds_ConditionOnload | 그리드 속성/값 설정 |  |  |  |
| AC-1c1d2c20 | this.Load | FP90000_Data_Handling.cs:1045 |  | GRID_SET | ds_Service.Rows[1]["OUT_DATASET_LIST"].Obj | new List<RemoteDataSet> { ds_site } | 그리드 속성/값 설정 |  |  |  |
| AC-2d7e588c | this.Load | FP90000_Data_Handling.cs:1048 |  | GRID_SET | ds_Service.Rows[3]["IN_DATASET_LIST"].Obj | ds_ConditionOnload | 그리드 속성/값 설정 |  |  |  |
| AC-d42ec60a | this.Load | FP90000_Data_Handling.cs:1049 |  | GRID_SET | ds_Service.Rows[3]["OUT_DATASET_LIST"].Obj | new List<RemoteDataSet> { ds_class1, ds_class2, ds_itemType } | 그리드 속성/값 설정 |  |  |  |
| AC-9ba84216 | this.Load | FP90000_Data_Handling.cs:1052 |  | GRID_SET | ds_Service.Rows[4]["IN_DATASET_LIST"].Obj | ds_ConditionOnload | 그리드 속성/값 설정 |  |  |  |
| AC-b959da98 | this.Load | FP90000_Data_Handling.cs:1053 |  | GRID_SET | ds_Service.Rows[4]["OUT_DATASET_LIST"].Obj | new List<RemoteDataSet> { ds_class2 } | 그리드 속성/값 설정 |  |  |  |

## FP90000_Data_Handling.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-69df1c31 | this.Load 외 2 | FP90000_Data_Handling.cs:192 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-24307cb8 | this.Load 외 2 | FP90000_Data_Handling.cs:193 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMaterial) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d7fde127 | this.Load 외 2 | FP90000_Data_Handling.cs:197 | catch ((Exception ex)) | THROW | throw ex; |  | 예외 발생 |  |  |  |

## FP90000_Data_Handling.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7f9d420 | InsertButton | FP90000_Data_Handling.cs:241 |  | MESSAGE | MessageBox.Show | ("Material 정보는 이 화면에서 새로 추가할 수 없습니다 [*** 권한 보유자에게 요청하세요]") | 메시지 표시 |  |  |  |

## FP90000_Data_Handling.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-242e8342 | (진입점 미연결) | FP90000_Data_Handling.cs:786 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP90000_Data_Handling.lfn_FilterValidation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4841f07f | (진입점 미연결) | FP90000_Data_Handling.cs:1157 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.lfn_getClass

진입점: this.Load / this.mcbo_division.SelectedIndexChanged [try ▸ else of (strErrorCode <= -1) ▸ else of (strServiceId == "getListDivision") ▸ if (strServiceId == "getListSite")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-83a54dc5 | this.Load 외 2 | FP90000_Data_Handling.cs:849 |  | CALL_EXT | ds_ConditionOnload.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc7823a6 | this.Load 외 2 | FP90000_Data_Handling.cs:851 |  | CALL_EXT | ds_ConditionOnload.setColumn | (0, "DIVISION_LT", ds_ConditionFilter.getCell(0, "DIVISION_LT")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5cf5ca6c | this.Load 외 2 | FP90000_Data_Handling.cs:851 |  | CALL_EXT | ds_ConditionFilter.getCell | (0, "DIVISION_LT") | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f7da1ef | this.Load 외 2 | FP90000_Data_Handling.cs:852 |  | CALL_EXT | ds_ConditionOnload.setColumn | (0, "SITE_LT", ds_ConditionFilter.getCell(0, "SITE_LT")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55225b7a | this.Load 외 2 | FP90000_Data_Handling.cs:852 |  | CALL_EXT | ds_ConditionFilter.getCell | (0, "SITE_LT") | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.lfn_getClass2

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-479a701f | (진입점 미연결) | FP90000_Data_Handling.cs:995 |  | CALL_EXT | ds_ConditionOnload.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f189c49b | (진입점 미연결) | FP90000_Data_Handling.cs:1004 |  | CALL_EXT | ds_ConditionOnload.setColumn | (0, "ITEM_CLASS_LEVEL_1", sel) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.lfn_getDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89e65d46 | this.Load | FP90000_Data_Handling.cs:826 |  | CALL_EXT | ds_ConditionOnload.clearData | () | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.lfn_getSite

진입점: this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId == "getListDivision") ▸ try] / this.mcbo_division.SelectedIndexChanged [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eb40975 | this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId =… 외 2 | FP90000_Data_Handling.cs:834 |  | CALL_EXT | ds_ConditionOnload.clearData | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f09899e1 | this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId =… 외 2 | FP90000_Data_Handling.cs:836 |  | CALL_EXT | ds_ConditionOnload.setColumn | (0, "DIVISION_LT", ds_ConditionFilter.getCell(0, "DIVISION_LT")) | ⚠ 의미 확인 필요 |  |  |  |
| AC-816d7635 | this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId =… 외 2 | FP90000_Data_Handling.cs:836 |  | CALL_EXT | ds_ConditionFilter.getCell | (0, "DIVISION_LT") | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.mcbo_division_SelectedIndexChanged

진입점: this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId == "getListDivision")] / this.mcbo_division.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b932ce8 | this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId =… 외 2 | FP90000_Data_Handling.cs:1353 | try | CALL_EXT | ds_ConditionFilter.setColumn | (0, "DIVISION_LT", sDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf86f06f | this.Load [else of (strErrorCode <= -1) ▸ if (strServiceId =… 외 2 | FP90000_Data_Handling.cs:1358 | catch () | CALL_EXT | ds_ConditionFilter.setColumn | (0, "DIVISION_LT", "") | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.mcbo_site_SelectedIndexChanged

진입점: this.mcbo_site.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dfea1f64 | this.mcbo_site.SelectedIndexChanged | FP90000_Data_Handling.cs:1339 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "SITE_LT", sSite) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e433aaa | popSql.OnSql | FP90000_Data_Handling.cs:1223 | if (programID == "PR_UI_FP00180_FIND_FP00180") | RETURN | return FindDataMaterial(false); |  | 처리 중단/반환 |  |  |  |
| AC-c3db1623 | popSql.OnSql | FP90000_Data_Handling.cs:1225 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7aa316a | SaveButton | FP90000_Data_Handling.cs:286 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0582d7d | SaveButton | FP90000_Data_Handling.cs:288 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d8a54126 | SaveButton | FP90000_Data_Handling.cs:293 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fab295cb | SaveButton | FP90000_Data_Handling.cs:294 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58b8ce30 | SaveButton | FP90000_Data_Handling.cs:297 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-418446ec | SaveButton | FP90000_Data_Handling.cs:304 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-b29036ce | SaveButton | FP90000_Data_Handling.cs:306 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-aa23b354 | SaveButton | FP90000_Data_Handling.cs:307 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28ac17cf | SaveButton | FP90000_Data_Handling.cs:312 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-73853e14 | SaveButton | FP90000_Data_Handling.cs:317 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-75eec6c9 | SaveButton | FP90000_Data_Handling.cs:326 | try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e668b6e | SaveButton | FP90000_Data_Handling.cs:330 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4d81064b | SaveButton | FP90000_Data_Handling.cs:334 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1053dcd1 | SaveButton | FP90000_Data_Handling.cs:335 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-dc140d9c | SaveButton | FP90000_Data_Handling.cs:339 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP90000_Data_Handling.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c64ce98 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:376 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d9441d25 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:405 | try ▸ if (iCount > 0) | CALL_EXT | set.setInitColumns | (0, RemoteDataSet.PR_UI_FP00180_SAVEALL_FP00180) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b56e1dce | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:407 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "demand_lot_size", p_demand_lot_size) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f7491253 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:408 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "item_attribute", p_item_attribute) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4ba618c7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:409 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "setup_attribute", p_setup_attribute) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3b4db599 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:410 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "form_attribute", p_form_attribute) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0ad4ba37 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:411 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "company_id", p_company_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1baefadb | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:412 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "division_id", p_division_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-79cb5f6b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:413 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "site_id", p_site_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-48b8c3ac | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:414 | try ▸ if (iCount > 0) | CALL_EXT | set.setColumn | (0, "item_id", p_item_id) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01b27385 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:417 | try ▸ if (iCount > 0) | COMBO_DATA | Data_FP.CallStandardProcedure | ("FP_Master.PR_UI_FP00180_SAVEALL_FP00180", set, UserInfoContext.Current.UserId, p_sys_typ… ⇒ FP_Master.PR_UI_FP00180_SAVEALL_FP00180 | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6e98e2c4 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:419 | try ▸ if (iCount > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-d9f9be30 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:423 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-ad643c41 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMateri… | FP90000_Data_Handling.cs:429 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb9ec077 | SaveButton | FP90000_Data_Handling.cs:281 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.ServiceParamSet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56a0f2bc | this.Load | FP90000_Data_Handling.cs:1060 | if (param != null) | VALUE_SET | param["SVC_ID"].Value | svc_id | 컨트롤 값 설정 |  |  |  |
| AC-7fff0812 | this.Load | FP90000_Data_Handling.cs:1061 | if (param != null) | VALUE_SET | param["DESCRIPTOR"].Value | descriptor | 컨트롤 값 설정 |  |  |  |
| AC-61de3fef | this.Load | FP90000_Data_Handling.cs:1062 | if (param != null) | VALUE_SET | param["SERVICE"].Value | service | 컨트롤 값 설정 |  |  |  |
| AC-bdf22d85 | this.Load | FP90000_Data_Handling.cs:1063 | if (param != null) | VALUE_SET | param["IN_DATASET_LIST"].Value | indata | 컨트롤 값 설정 |  |  |  |
| AC-123ad0da | this.Load | FP90000_Data_Handling.cs:1064 | if (param != null) | VALUE_SET | param["OUT_DATASET_LIST"].Value | outdata | 컨트롤 값 설정 |  |  |  |
| AC-bb5356e2 | this.Load | FP90000_Data_Handling.cs:1066 | if (param != null) ▸ if (sync) | VALUE_SET | param["SYNC_YN"].Value | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-ea058ffe | this.Load | FP90000_Data_Handling.cs:1068 | if (param != null) ▸ else of (sync) | VALUE_SET | param["SYNC_YN"].Value | "N" | 컨트롤 값 설정 |  |  |  |

## FP90000_Data_Handling.SetSpreadInit

진입점: this.Load [try] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ try ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMaterial) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-842c44b9 | this.Load [try] 외 2 | FP90000_Data_Handling.cs:205 | if (sheetName.Equals(SpdSheet.shtMaterial)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5219cbd | this.Load [try] 외 2 | FP90000_Data_Handling.cs:206 | if (sheetName.Equals(SpdSheet.shtMaterial)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-e6ac8e00 | this.Load [try] 외 2 | FP90000_Data_Handling.cs:211 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP90000_Data_Handling.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53013111 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1422 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa43c350 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1435 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) | DATA_OP | itemTmp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2dd39e91 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1436 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) | DATA_OP | itemTmp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0450e8e8 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1441 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-241afa7a | this.spdMain.CellClick | FP90000_Data_Handling.cs:1442 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-18739d05 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1443 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a220a61 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1447 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e36c7a2 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1450 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-66d54109 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1454 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | siMain.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6dab2967 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1458 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ca12849 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1459 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1a6e119 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1460 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-8153ea30 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1464 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-ce7bc357 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1467 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SETUP_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-441c6f6a | this.spdMain.CellClick | FP90000_Data_Handling.cs:1475 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.DIVISION_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-112b79d1 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1476 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.SITE_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6d217cb | this.spdMain.CellClick | FP90000_Data_Handling.cs:1477 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | dRow.Field | (DefColumns.ITEM_CLASS_LEVEL_2) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9bb3965 | this.spdMain.CellClick | FP90000_Data_Handling.cs:1481 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | DATA_OP | itemTmp.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-7b1619eb | this.spdMain.CellClick | FP90000_Data_Handling.cs:1484 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ else of (e.Column == siMain.GetColumnIndex(DefCol… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.FORM_ATTRIBUTE), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## FP90000_Data_Handling.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fff7b0c0 | this.spdMain.KeyDown | FP90000_Data_Handling.cs:1512 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (range!=null && range.Length > 0) ▸ for (i< range.Length) ▸ for (c < eachR… | GRID_SET | siMain.ActiveSheet.Cells[r + eachRange.Row, c + eachRange.Column].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-de17d638 | this.spdMain.KeyDown | FP90000_Data_Handling.cs:1522 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMaterial) ▸ if (siMain.Active… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP90000_Data_Handling.tbClass_TextChanged

진입점: this.tbClass.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01f7de93 | this.tbClass.TextChanged | FP90000_Data_Handling.cs:1300 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ITEM_CLASS", tbClass.Text) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.tbMaterial_TextChanged

진입점: this.tbMaterial.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10b4e25d | this.tbMaterial.TextChanged | FP90000_Data_Handling.cs:1316 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "ITEM_ID", tbMaterial.Text) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.tbModel_TextChanged

진입점: this.tbModel.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4599f0d9 | this.tbModel.TextChanged | FP90000_Data_Handling.cs:1311 |  | CALL_EXT | ds_ConditionFilter.setColumn | (0, "MODEL_ID", tbModel.Text) | ⚠ 의미 확인 필요 |  |  |  |

## FP90000_Data_Handling.tbNickName_BeforeOpenSearch

진입점: this.tbNickName.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc6b0731 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1533 |  | CALL_EXT | set.setInitColumns | (0, RemoteDataSet.PR_UI_FP00180_FIND_FP00180) | ⚠ 의미 확인 필요 |  |  |  |
| AC-97ef81ea | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1534 |  | CALL_EXT | set.Overwrite | (0, ds_ConditionFilter) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6a11d8ea | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1536 |  | CALL_EXT | tbNickName.Filter.Set | (set) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1c04e15 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1545 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 22) | 데이터 객체 조작/조회 |  |  |  |
| AC-5314b2f5 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1546 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-62161b6c | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1547 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-1012aadb | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1548 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-69963491 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1549 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 400) | 데이터 객체 조작/조회 |  |  |  |
| AC-1e75c472 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1550 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bcec524 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1554 |  | DATA_OP | _col_title.Add | ("nick_name".ToUpper(), "Nick Name") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6bb7eaf | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1556 |  | UI_PROP | tbNickName.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-bdb8bbb0 | this.tbNickName.BeforeOpenSearch | FP90000_Data_Handling.cs:1557 |  | UI_PROP | tbNickName.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |

## FP90000_Data_Handling.tbNickName_OnSearchConditionChanged

진입점: this.tbNickName.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb0a8cc2 | this.tbNickName.OnSearchConditionChanged | FP90000_Data_Handling.cs:1573 | if (tbNickName.IsInMode == true) | CALL_EXT | ds_ConditionFilter.setColumn | (0, "NICK_NAME_LT", tbNickName.Selected) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bfdf6d23 | this.tbNickName.OnSearchConditionChanged | FP90000_Data_Handling.cs:1578 | else of (tbNickName.IsInMode == true) ▸ if (tbNickName.Selected.Count > 0) | CALL_EXT | ds_ConditionFilter.setColumn | (0, "NICK_NAME", tbNickName.Selected[0]) | ⚠ 의미 확인 필요 |  |  |  |

