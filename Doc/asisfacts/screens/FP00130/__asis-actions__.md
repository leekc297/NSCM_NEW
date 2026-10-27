# AS-IS 액션 대조표 — FP00130

> 원천: `Doc/asisfacts/screens/FP00130/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 237행 · 메서드 45 · 종류 DATA_OP 47 · FLAG 31 · RETURN 25 · LIST_REBIND 18 · UI_PROP 17 · CALL_EXT 15 · COMBO_DATA 14 · MESSAGE 12 · GRID_INIT 10 · ENDPOINT 9 · POPUP 8 · GRID_SET 8 · UI_MISC 8 · THROW 4 · GRID_BIND 3 · GRID_COMBO 3 · GRID_LOCK 2 · EXCEL 1 · VALUE_SET 1 · VALIDATE 1 · ⚠ 의미 확인 필요 15


## FP00130_Equipment..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-811ac74c | .ctor | FP00130_Equipment.cs:134 |  | FLAG | CurrentUser | UserInfoContext.Current.UserId | 화면 필드/플래그 변경 |  |  |  |

## FP00130_Equipment.btnExcelImport_Click

진입점: this.btnExcelImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec74381c | this.btnExcelImport.Click | FP00130_Equipment.cs:939 |  | POPUP | new FPC0101_AutoExcelPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2269ff26 | this.btnExcelImport.Click | FP00130_Equipment.cs:940 |  | UI_PROP | p.Filter | Filter.Copy() | 속성 Filter 설정 |  |  |  |
| AC-0618ec58 | this.btnExcelImport.Click | FP00130_Equipment.cs:940 |  | DATA_OP | Filter.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eaa67ff1 | this.btnExcelImport.Click | FP00130_Equipment.cs:941 |  | GRID_SET | p.KeyColumns["COMPANY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c448112c | this.btnExcelImport.Click | FP00130_Equipment.cs:942 |  | GRID_SET | p.KeyColumns["DIVISION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-c24e705f | this.btnExcelImport.Click | FP00130_Equipment.cs:943 |  | GRID_SET | p.KeyColumns["SITE_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-354d0a6c | this.btnExcelImport.Click | FP00130_Equipment.cs:944 |  | GRID_SET | p.KeyColumns["PLANT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-db86e7af | this.btnExcelImport.Click | FP00130_Equipment.cs:945 |  | GRID_SET | p.KeyColumns["EQUIPMENT_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-85d6e64c | this.btnExcelImport.Click | FP00130_Equipment.cs:946 |  | GRID_SET | p.KeyColumns["FACTORY_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-4fc36b23 | this.btnExcelImport.Click | FP00130_Equipment.cs:947 |  | GRID_SET | p.KeyColumns["OPERATION_ID"] | true | 그리드 속성/값 설정 |  |  |  |
| AC-cab1393b | this.btnExcelImport.Click | FP00130_Equipment.cs:949 |  | DATA_OP | p.ColumnTitle["COMPANY_ID"] | "Company" | 행/컬럼 값 대입 |  |  |  |
| AC-a8c8f80f | this.btnExcelImport.Click | FP00130_Equipment.cs:950 |  | DATA_OP | p.ColumnTitle["DIVISION_ID"] | "Division" | 행/컬럼 값 대입 |  |  |  |
| AC-ceec4101 | this.btnExcelImport.Click | FP00130_Equipment.cs:951 |  | DATA_OP | p.ColumnTitle["SITE_ID"] | "Site" | 행/컬럼 값 대입 |  |  |  |
| AC-0ea902e3 | this.btnExcelImport.Click | FP00130_Equipment.cs:952 |  | DATA_OP | p.ColumnTitle["PLANT_ID"] | "Plant" | 행/컬럼 값 대입 |  |  |  |
| AC-17d133aa | this.btnExcelImport.Click | FP00130_Equipment.cs:953 |  | DATA_OP | p.ColumnTitle["EQUIPMENT_ID"] | "Equipment" | 행/컬럼 값 대입 |  |  |  |
| AC-37cad224 | this.btnExcelImport.Click | FP00130_Equipment.cs:954 |  | DATA_OP | p.ColumnTitle["FACTORY_ID"] | "Building" | 행/컬럼 값 대입 |  |  |  |
| AC-ca8edd65 | this.btnExcelImport.Click | FP00130_Equipment.cs:955 |  | DATA_OP | p.ColumnTitle["OPERATION_ID"] | "Operation" | 행/컬럼 값 대입 |  |  |  |
| AC-6651ea2e | this.btnExcelImport.Click | FP00130_Equipment.cs:956 |  | DATA_OP | p.ColumnTitle["LINE_ID"] | "FP Line" | 행/컬럼 값 대입 |  |  |  |
| AC-e88048ed | this.btnExcelImport.Click | FP00130_Equipment.cs:957 |  | DATA_OP | p.ColumnTitle["LINE"] | "FP Line Name" | 행/컬럼 값 대입 |  |  |  |
| AC-43ee0aeb | this.btnExcelImport.Click | FP00130_Equipment.cs:959 |  | UI_PROP | p.DoSearchData | FP00130_SearchDataDelegate | 속성 DoSearchData 설정 |  |  |  |
| AC-fcc42208 | this.btnExcelImport.Click | FP00130_Equipment.cs:960 |  | UI_PROP | p.DoLineCheck | FP00130_RowCheckDelegate | 속성 DoLineCheck 설정 |  |  |  |
| AC-f69388c5 | this.btnExcelImport.Click | FP00130_Equipment.cs:961 |  | UI_PROP | p.DoSaveData | FP00130_SaveDataDelegate | 속성 DoSaveData 설정 |  |  |  |
| AC-f134301a | this.btnExcelImport.Click | FP00130_Equipment.cs:962 |  | UI_PROP | p.DoValidationData | FP00130_ValidateDataDelegate | 속성 DoValidationData 설정 |  |  |  |
| AC-a1bd207d | this.btnExcelImport.Click | FP00130_Equipment.cs:963 |  | POPUP | p.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00130_Equipment.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e41aa9df | this.btnSql.Click | FP00130_Equipment.cs:592 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ee3e09f5 | this.btnSql.Click | FP00130_Equipment.cs:593 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fbfa9229 | this.btnSql.Click | FP00130_Equipment.cs:595 |  | DATA_OP | popSql.Services.Add | ("PR2_UI_FP00130_FIND_FP00130") | 데이터 객체 조작/조회 |  |  |  |
| AC-d115bceb | this.btnSql.Click | FP00130_Equipment.cs:596 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00130_Equipment.cbo_active_SelectedIndexChanged

진입점: cbo_active.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c39fed0 | cbo_active.SelectedIndexChanged | FP00130_Equipment.cs:927 | try | CALL_EXT | Filter.setColumn | (0, "ACTIVE_FLAG", pActive) | ⚠ 의미 확인 필요 |  |  |  |
| AC-125795eb | cbo_active.SelectedIndexChanged | FP00130_Equipment.cs:931 | catch () | CALL_EXT | Filter.setColumn | (0, "ACTIVE_FLAG", "") | ⚠ 의미 확인 필요 |  |  |  |

## FP00130_Equipment.cbo_equip_clicked

진입점: cbo_equip.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13b2bac6 | cbo_equip.Click | FP00130_Equipment.cs:1297 |  | FLAG | dtEquipment | DataService.FP_ExecuteProcedure2("PR2_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-73d82101 | cbo_equip.Click | FP00130_Equipment.cs:1297 |  | ENDPOINT | DataService.FP_ExecuteProcedure2 | ("PR2_UI_XPCOMMONCOND_FINDRESOURCECODE_COMMON", Filter) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f9a0a43d | cbo_equip.Click | FP00130_Equipment.cs:1298 |  | LIST_REBIND | clsCtrl.setListBox | (dtEquipment, cbo_equip, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.cbo_equip_SelectedIndexChanged

진입점: this.Load [try] / cbo_equip.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f083b669 | this.Load [try] 외 1 | FP00130_Equipment.cs:919 | catch () | DATA_OP | Filter["RESOURCE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00130_Equipment.clbDivision_SelectedIndexChanged

진입점: this.Load [try] / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-52968ce5 | this.Load [try] 외 1 | FP00130_Equipment.cs:864 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-09bf71ca | this.Load [try] 외 1 | FP00130_Equipment.cs:866 |  | UI_PROP | clbSite.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00130_Equipment.clbFactory_SelectedIndexChanged

진입점: this.Load [try] / clbFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dc5d39c | this.Load [try] 외 1 | FP00130_Equipment.cs:887 |  | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |

## FP00130_Equipment.clbOperation_SelectedIndexChanged

진입점: this.Load [try] / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-873be402 | this.Load [try] 외 1 | FP00130_Equipment.cs:903 | try | DATA_OP | Filter["OPERATION_ID"] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-6a9509a2 | this.Load [try] 외 1 | FP00130_Equipment.cs:907 | catch ((Exception ee)) | DATA_OP | Filter["OPERATION_ID"] | "" | 행/컬럼 값 대입 |  |  |  |

## FP00130_Equipment.clbPlant_SelectedIndexChanged

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f277f5d1 | this.Load [try] 외 1 | FP00130_Equipment.cs:878 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-e666b8dd | this.Load [try] 외 1 | FP00130_Equipment.cs:880 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00130_Equipment.clbSite_SelectedIndexChanged

진입점: this.Load [try] / clbSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13e46123 | this.Load [try] 외 1 | FP00130_Equipment.cs:872 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-8135d2b3 | this.Load [try] 외 1 | FP00130_Equipment.cs:874 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | false | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00130_Equipment.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ab1c7f8c | this.Load | FP00130_Equipment.cs:290 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtEquipment, SpdSheet.shtEquipment, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-abaa79a2 | this.Load | FP00130_Equipment.cs:291 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtEquipment) | 화면 필드/플래그 변경 |  |  |  |
| AC-92b1ff17 | this.Load | FP00130_Equipment.cs:295 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1ce8270f | this.Load | FP00130_Equipment.cs:296 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-3f1e633d | this.Load | FP00130_Equipment.cs:299 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtEquipment) | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00130_Equipment.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2be19dd | DeleteButton | FP00130_Equipment.cs:387 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00130_Equipment.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e046e2e9 | Dispose | FP00130_Equipment.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00130_Equipment.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d24744ee | EditButton | FP00130_Equipment.cs:414 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-0f2cdcd7 | EditButton | FP00130_Equipment.cs:417 | if (spdMain != null) | CALL_EXT | siMain.SwitchLockFP | (!isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c77f733a | EditButton | FP00130_Equipment.cs:422 | if (spdMain != null) ▸ if (isEdit) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex("LINE_ID"), siMain.GetColumnIndex("LINE_ID"), !isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9547467c | EditButton | FP00130_Equipment.cs:423 | if (spdMain != null) ▸ if (isEdit) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex("ACTIVE_FLAG"), siMain.GetColumnIndex("ACTIVE_FLAG"), !isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c039ebfa | EditButton | FP00130_Equipment.cs:424 | if (spdMain != null) ▸ if (isEdit) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex("ELECTRODE_TYPE"), siMain.GetColumnIndex("ELECTRODE_TYPE"), !isEdit… | ⚠ 의미 확인 필요 |  |  |  |
| AC-44809148 | EditButton | FP00130_Equipment.cs:428 | if (spdMain != null) ▸ else of (isEdit) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex("LINE_ID"), siMain.GetColumnIndex("LINE_ID"), !isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6216cd2a | EditButton | FP00130_Equipment.cs:429 | if (spdMain != null) ▸ else of (isEdit) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex("ACTIVE_FLAG"), siMain.GetColumnIndex("ACTIVE_FLAG"), !isEdit) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f2c60d26 | EditButton | FP00130_Equipment.cs:430 | if (spdMain != null) ▸ else of (isEdit) | CALL_EXT | siMain.LockColumnFP | (siMain.GetColumnIndex("ELECTRODE_TYPE"), siMain.GetColumnIndex("ELECTRODE_TYPE"), !isEdit… | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f23ded2 | EditButton | FP00130_Equipment.cs:433 | if (spdMain != null) | CALL_EXT | siMain.LockColumnFPDone | () | ⚠ 의미 확인 필요 |  |  |  |

## FP00130_Equipment.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55b0bda2 | ExcelButton | FP00130_Equipment.cs:750 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00130_Equipment.FindDataEquipment

진입점: popSql.OnSql [if (programID == "PR2_UI_FP00130_FIND_FP00130")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e35d5c26 | popSql.OnSql [if (programID == "PR2_UI_FP00130_FIND_FP00130"… 외 3 | FP00130_Equipment.cs:835 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR2_UI_FP00130_FIND_FP00130", Filter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-f9dbaa24 | popSql.OnSql [if (programID == "PR2_UI_FP00130_FIND_FP00130"… 외 3 | FP00130_Equipment.cs:835 | try | RETURN | return DataService.FP_ExecuteProcedure("PR2_UI_FP00130_FIND_FP00130", Filter, p_… |  | 처리 중단/반환 |  |  |  |
| AC-97bc573a | popSql.OnSql [if (programID == "PR2_UI_FP00130_FIND_FP00130"… 외 3 | FP00130_Equipment.cs:839 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00130_Equipment.FindDataEquipmentAsync

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment)] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b1ade92 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:610 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-701cd7c9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:616 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ba66393 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:617 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-769f2406 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:620 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-1f894cb0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:627 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5699e281 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:629 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc97a304 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:632 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cb1d4605 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:634 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-70ee6cbd | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:645 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-25207195 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:647 | try | FLAG | dsMain | await asyncProxy.ExecuteAsync<DataSet>(() => FindDataEquipment(true) ) | 화면 필드/플래그 변경 |  |  |  |
| AC-0bdaef79 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:647 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => FindDataEquipment(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a3f47c6f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:658 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a7257805 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:659 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e23473f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:673 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e208f1a7 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:679 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e31b5042 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:680 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d527a00f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | FP00130_Equipment.cs:681 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00130_Equipment.FindDataEquipmentSub

진입점: this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-692837cc | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … | FP00130_Equipment.cs:852 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00130_FIND_FP00130_SUB_ALL", SubFilter, p_sys_type) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-1f116f2b | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … | FP00130_Equipment.cs:852 | try | RETURN | return DataService.FP_ExecuteProcedure("PR_UI_FP00130_FIND_FP00130_SUB_ALL", Sub… |  | 처리 중단/반환 |  |  |  |
| AC-ae8980d6 | this.spdMain.CellClick [if (siMain.ActiveSheet.SheetName == … | FP00130_Equipment.cs:856 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00130_Equipment.FindDataEquipmentSubAsync

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad420c4c | (진입점 미연결) | FP00130_Equipment.cs:692 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-42e77c58 | (진입점 미연결) | FP00130_Equipment.cs:696 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28b3bff0 | (진입점 미연결) | FP00130_Equipment.cs:698 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4a50c4ac | (진입점 미연결) | FP00130_Equipment.cs:707 | try | FLAG | dsMain | FindDataEquipment(true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f7cda4c8 | (진입점 미연결) | FP00130_Equipment.cs:713 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-faf988cf | (진입점 미연결) | FP00130_Equipment.cs:714 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-91a9d0a0 | (진입점 미연결) | FP00130_Equipment.cs:728 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86bfb7a0 | (진입점 미연결) | FP00130_Equipment.cs:734 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bcf00a1b | (진입점 미연결) | FP00130_Equipment.cs:736 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## FP00130_Equipment.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-099794c1 | this.Load | FP00130_Equipment.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00130_Equipment.FP00130_RowCheckDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0d07a03 | (진입점 미연결) | FP00130_Equipment.cs:1026 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.FP00130_SaveDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92498c7e | (진입점 미연결) | FP00130_Equipment.cs:989 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00130_Equipment", "merge_FP00130", data, 0) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=merge_FP00130] \| FP\Common\FP00… | 엔드포인트 호출 |  |  |  |
| AC-8146f0ea | (진입점 미연결) | FP00130_Equipment.cs:995 | if (ret.DataSet != null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-18bb5f29 | (진입점 미연결) | FP00130_Equipment.cs:996 |  | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-9fed36f4 | (진입점 미연결) | FP00130_Equipment.cs:998 |  | DATA_OP | tmpDs.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-69ee602a | (진입점 미연결) | FP00130_Equipment.cs:999 |  | RETURN | return tmpDs; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.FP00130_SearchDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa265f66 | (진입점 미연결) | FP00130_Equipment.cs:984 |  | RETURN | return set; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.FP00130_ValidateDataDelegate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00f94684 | (진입점 미연결) | FP00130_Equipment.cs:1005 |  | DATA_OP | data.Tables[0].Columns.Contains | ("DESCRIPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-dd49f40d | (진입점 미연결) | FP00130_Equipment.cs:1006 | if (!data.Tables[0].Columns.Contains("DESCRIPTION")) | DATA_OP | data.Tables[0].Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a201453 | (진입점 미연결) | FP00130_Equipment.cs:1008 |  | DATA_OP | column_params.Add | ("USER_ID", UserInfoContext.Current.UserId) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0ad13ba | (진입점 미연결) | FP00130_Equipment.cs:1009 |  | ENDPOINT | DataService.FP_ExecuteNonQuery | ( "FP00130_Equipment", "delete_Excel_buffer", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteNonQuery [batchId=delete_Excel_buffer] \| FP\C… | 엔드포인트 호출 |  |  |  |
| AC-c12b830b | (진입점 미연결) | FP00130_Equipment.cs:1013 |  | ENDPOINT | DataService.FP_UpdateBatch | ( "FP00130_Equipment", "insert_Excel_buffer", data) ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=insert_Excel_buffer] \| FP\Commo… | 엔드포인트 호출 |  |  |  |
| AC-c248b334 | (진입점 미연결) | FP00130_Equipment.cs:1017 | if (!dtUpdateResult.Good() \|\| dtUpdateResult.Rows[0]["RESULT"].ToString() != "SUCCESS") | THROW | throw new Exception("VALIDATION FAIL"); |  | 예외 발생 |  |  |  |
| AC-8ca69ab6 | (진입점 미연결) | FP00130_Equipment.cs:1019 |  | ENDPOINT | DataService.FP_ExecuteQuery | ( "FP00130_Equipment", "find_Excel_buffer_validation", column_params) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_Excel_buffer_validation] \… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-673364a4 | (진입점 미연결) | FP00130_Equipment.cs:1019 |  | RETURN | return DataService.FP_ExecuteQuery( "FP00130_Equipment", "find_Excel_buffer_vali… |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.GetDivision

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2dea038 | this.Load [try] | FP00130_Equipment.cs:336 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-29505dd4 | this.Load [try] | FP00130_Equipment.cs:337 |  | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-8531268e | this.Load [try] | FP00130_Equipment.cs:337 |  | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-dfcb3354 | this.Load [try] | FP00130_Equipment.cs:338 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.GetFactory

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6661185 | (진입점 미연결) | FP00130_Equipment.cs:245 |  | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.FACTORY, false, CurrentUser, _sNonAuth, _sSaveAuth , null, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-f1536c71 | (진입점 미연결) | FP00130_Equipment.cs:245 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.FACTORY, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-132c6c58 | (진입점 미연결) | FP00130_Equipment.cs:250 |  | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.GetLine

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b8d724e | (진입점 미연결) | FP00130_Equipment.cs:263 |  | FLAG | dtLine | Data_FP.Common_FP(Data_FP.Type.LINE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 화면 필드/플래그 변경 |  |  |  |
| AC-d37b99a5 | (진입점 미연결) | FP00130_Equipment.cs:263 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null , F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9820d132 | (진입점 미연결) | FP00130_Equipment.cs:270 |  | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.GetOperation

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06264b49 | (진입점 미연결) | FP00130_Equipment.cs:255 |  | FLAG | dtOperation | Data_FP.Common_FP(Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-85a045f6 | (진입점 미연결) | FP00130_Equipment.cs:255 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.OPERATION, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9da8c81f | (진입점 미연결) | FP00130_Equipment.cs:257 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.GetPlant

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-55b3d5be | (진입점 미연결) | FP00130_Equipment.cs:236 |  | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-4e21ed1f | (진입점 미연결) | FP00130_Equipment.cs:236 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, F… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-da6ac73b | (진입점 미연결) | FP00130_Equipment.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.GetSite

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b753b52 | (진입점 미연결) | FP00130_Equipment.cs:229 |  | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, nul… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-8e71a30f | (진입점 미연결) | FP00130_Equipment.cs:229 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null, Fi… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5159cf73 | (진입점 미연결) | FP00130_Equipment.cs:231 |  | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, false) | 목록 컨트롤 재구성 |  |  |  |

## FP00130_Equipment.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8827cdbc | this.Load | FP00130_Equipment.cs:173 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-883442fa | this.Load | FP00130_Equipment.cs:175 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-db7d6769 | this.Load | FP00130_Equipment.cs:176 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-c80ebe65 | this.Load | FP00130_Equipment.cs:178 | try | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cbo_active, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e907caa9 | this.Load | FP00130_Equipment.cs:179 | try | VALUE_SET | cbo_active.InitValue | "ALL" | 컨트롤 값 설정 |  |  |  |
| AC-6e5eb91b | this.Load | FP00130_Equipment.cs:180 | try | DATA_OP | Filter["EQUIPMENT_TYPE"] | "M" | 행/컬럼 값 대입 |  |  |  |
| AC-7ab36323 | this.Load | FP00130_Equipment.cs:214 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |

## FP00130_Equipment.InitSpread

진입점: this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7d53edac | this.Load 외 2 | FP00130_Equipment.cs:307 | if (spreadInfo.SheetName == SpdSheet.shtEquipment) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-5a168801 | this.Load 외 2 | FP00130_Equipment.cs:308 | if (spreadInfo.SheetName == SpdSheet.shtEquipment) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-b4c39c52 | this.Load 외 2 | FP00130_Equipment.cs:314 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-cf7bf9bc | this.Load 외 2 | FP00130_Equipment.cs:315 | if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 2) | 그리드 재구성/초기화 |  |  |  |

## FP00130_Equipment.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1784fcad | InsertButton | FP00130_Equipment.cs:379 |  | MESSAGE | MessageBox.Show | ("Equipment 정보는 이 화면에서 새로 추가할 수 없습니다 [*** 권한 보유자에게 요청하세요]") | 메시지 표시 |  |  |  |

## FP00130_Equipment.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc76d85a | (진입점 미연결) | FP00130_Equipment.cs:761 | if (spdMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## FP00130_Equipment.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-602a0493 | popSql.OnSql | FP00130_Equipment.cs:813 | if (programID == "PR2_UI_FP00130_FIND_FP00130") | RETURN | return FindDataEquipment(false); |  | 처리 중단/반환 |  |  |  |
| AC-a26d94ea | popSql.OnSql | FP00130_Equipment.cs:817 | else of (programID == "PR2_UI_FP00130_FIND_FP00130") ▸ if (programID == "PR_UI_FP00130_SAVE_FP00130") | RETURN | return SaveDataEquipment(); |  | 처리 중단/반환 |  |  |  |
| AC-b4e746c3 | popSql.OnSql | FP00130_Equipment.cs:819 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6acfcb84 | SaveButton | FP00130_Equipment.cs:444 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-877abf41 | SaveButton | FP00130_Equipment.cs:446 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f4cf80ed | SaveButton | FP00130_Equipment.cs:451 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc6b8c2a | SaveButton | FP00130_Equipment.cs:452 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8bb9abde | SaveButton | FP00130_Equipment.cs:455 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2350b1f3 | SaveButton | FP00130_Equipment.cs:462 | try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d9327ef5 | SaveButton | FP00130_Equipment.cs:464 | try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-14a98389 | SaveButton | FP00130_Equipment.cs:465 | try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-36af24ec | SaveButton | FP00130_Equipment.cs:470 | try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-887c6a69 | SaveButton | FP00130_Equipment.cs:475 | try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58c4546b | SaveButton | FP00130_Equipment.cs:484 | try ▸ if (siMain.SheetName == SpdSheet.shtEquipment) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f94badb9 | SaveButton | FP00130_Equipment.cs:488 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d511cfb8 | SaveButton | FP00130_Equipment.cs:492 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-694b0acc | SaveButton | FP00130_Equipment.cs:493 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-cde9dd72 | SaveButton | FP00130_Equipment.cs:497 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00130_Equipment.Save_Data_Line

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipment)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81b7a77d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:531 | try | DATA_OP | dsSave.Tables[0].Columns.Contains | ("DESCRIPTION") | 데이터 객체 조작/조회 |  |  |  |
| AC-aba18b90 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:532 | try ▸ if (!dsSave.Tables[0].Columns.Contains("DESCRIPTION")) | DATA_OP | dsSave.Tables[0].Columns.Add | (new DataColumn("DESCRIPTION", typeof(string))) | 데이터 객체 조작/조회 |  |  |  |
| AC-3eb26560 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:533 | try | DATA_OP | dsSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-941509db | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:536 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1eca6a38 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:543 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagI: case CAppSetting.FlagA: ▸ if (bindingRow.RowState !=… | CALL_EXT | bindingRow.SetAdded | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d7282b7d | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:547 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagM: ▸ if (bindingRow.RowState != DataRowState.Modified) | CALL_EXT | bindingRow.SetModified | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-eaf0d8fa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:551 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ switch (actionState) case CAppSetting.FlagD: ▸ if (bindingRow.RowState != DataRowState.Deleted) | DATA_OP | bindingRow.Delete | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e8da9f79 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:565 | try ▸ if (iCount > 0) | CALL_EXT | dsSave.GetChanges | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7638e9a7 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:566 | try ▸ if (iCount > 0) | ENDPOINT | DataService.FP_UpdateBatch | ("FP00130_Equipment", "saveAll_FP00130", dsSave, 0, "MASTER") ⇒ biz:FPCommonDataBLL.GeneralUpdateBatch [batchId=saveAll_FP00130] \| FP\MASTER\FP… | 엔드포인트 호출 |  |  |  |
| AC-fa48a709 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:569 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | UI_PROP | ret.TableName | "Table0" | 속성 TableName 설정 |  |  |  |
| AC-9a639ba5 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:571 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | DATA_OP | set.Tables.Add | (ret) | 데이터 객체 조작/조회 |  |  |  |
| AC-6954e1c2 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:572 | try ▸ if (iCount > 0) ▸ if (ret != null && ret.DataSet == null) | RETURN | return ret.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-636b9631 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:574 | try ▸ if (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-01526721 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:578 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-6e1ed23b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:584 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message) | 메시지 표시 |  |  |  |
| AC-330a95aa | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtEquipm… | FP00130_Equipment.cs:585 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dab35a2a | SaveButton | FP00130_Equipment.cs:439 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.SaveDataEquipment

진입점: popSql.OnSql [else of (programID == "PR2_UI_FP00130_FIND_FP00130") ▸ if (programID == "PR_UI_FP00130_SAVE_FP00130")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5229b80 | popSql.OnSql [else of (programID == "PR2_UI_FP00130_FIND_FP0… | FP00130_Equipment.cs:824 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00130_Equipment.SetChangeControl

진입점: this.Load [try] / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged [try] / clbLine.SelectedIndexChanged / cbo_equip.SelectedIndexChanged [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7a6e480 | this.Load [try] 외 7 | FP00130_Equipment.cs:1200 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c12aa1c | this.Load [try] 외 7 | FP00130_Equipment.cs:1200 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-870d843e | this.Load [try] 외 7 | FP00130_Equipment.cs:1205 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter["DIVISION_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-5bfec0c7 | this.Load [try] 외 7 | FP00130_Equipment.cs:1209 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bcd7c739 | this.Load [try] 외 7 | FP00130_Equipment.cs:1209 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-adc39489 | this.Load [try] 외 7 | FP00130_Equipment.cs:1211 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)clbSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-45da6338 | this.Load [try] 외 7 | FP00130_Equipment.cs:1213 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)clbSite is UsrCombo) ▸ if ((object)clbSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)clbSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a98e34da | this.Load [try] 외 7 | FP00130_Equipment.cs:1220 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-b2237c6b | this.Load [try] 외 7 | FP00130_Equipment.cs:1221 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbacf697 | this.Load [try] 외 7 | FP00130_Equipment.cs:1221 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ea7796a0 | this.Load [try] 외 7 | FP00130_Equipment.cs:1223 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e9dc86dd | this.Load [try] 외 7 | FP00130_Equipment.cs:1225 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-be00d15d | this.Load [try] 외 7 | FP00130_Equipment.cs:1231 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c8f26974 | this.Load [try] 외 7 | FP00130_Equipment.cs:1232 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-5004b0b7 | this.Load [try] 외 7 | FP00130_Equipment.cs:1232 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-de2a2909 | this.Load [try] 외 7 | FP00130_Equipment.cs:1234 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-329207fc | this.Load [try] 외 7 | FP00130_Equipment.cs:1236 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-60e07905 | this.Load [try] 외 7 | FP00130_Equipment.cs:1243 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-27eac522 | this.Load [try] 외 7 | FP00130_Equipment.cs:1244 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0dbb051 | this.Load [try] 외 7 | FP00130_Equipment.cs:1244 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d6407b4e | this.Load [try] 외 7 | FP00130_Equipment.cs:1246 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)clbOperation is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)clbOperation as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a6d67548 | this.Load [try] 외 7 | FP00130_Equipment.cs:1248 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)clbOperation is UsrCombo) ▸ if ((object)clbOp… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)clbOperation as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a04d3e47 | this.Load [try] 외 7 | FP00130_Equipment.cs:1256 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-50815ebd | this.Load [try] 외 7 | FP00130_Equipment.cs:1257 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddd429c1 | this.Load [try] 외 7 | FP00130_Equipment.cs:1257 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-526e1bb1 | this.Load [try] 외 7 | FP00130_Equipment.cs:1259 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ if ((object)clbLine is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-de766ee7 | this.Load [try] 외 7 | FP00130_Equipment.cs:1261 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ else of ((object)clbLine is UsrCombo) ▸ if ((object)clbLin… | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8b291476 | this.Load [try] 외 7 | FP00130_Equipment.cs:1271 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) ▸ try | DATA_OP | Filter["LINE_ID"] | pActive | 행/컬럼 값 대입 |  |  |  |
| AC-72ce88bc | this.Load [try] 외 7 | FP00130_Equipment.cs:1275 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) ▸ catch () | DATA_OP | Filter["LINE_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-7c1f72c1 | this.Load [try] 외 7 | FP00130_Equipment.cs:1277 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | FLAG | dtEquipment | null | 화면 필드/플래그 변경 |  |  |  |
| AC-7ed81ff7 | this.Load [try] 외 7 | FP00130_Equipment.cs:1278 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | CALL_EXT | cbo_equip.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7b10d8bd | this.Load [try] 외 7 | FP00130_Equipment.cs:1288 | switch (triggerControl) case "EQUIPMENT_ID": | DATA_OP | Filter["RESOURCE_ID"] | pActive | 행/컬럼 값 대입 |  |  |  |

## FP00130_Equipment.SetDevOption

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-957d6262 | this.Load | FP00130_Equipment.cs:160 |  | CALL_EXT | UserService.HasExtraRole | (CurrentUser) | ⚠ 의미 확인 필요 |  |  |  |
| AC-968fc7d0 | this.Load | FP00130_Equipment.cs:162 | if (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-aae5e946 | this.Load | FP00130_Equipment.cs:166 | else of (UserService.HasExtraRole(CurrentUser)) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00130_Equipment.SetSpreadInit

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-40742ca8 | (진입점 미연결) | FP00130_Equipment.cs:323 | if (sheetName.Equals(SpdSheet.shtEquipment)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27660dba | (진입점 미연결) | FP00130_Equipment.cs:324 | if (sheetName.Equals(SpdSheet.shtEquipment)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-39ae7728 | (진입점 미연결) | FP00130_Equipment.cs:327 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00130_Equipment.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-791ea015 | this.spdMain.CellClick | FP00130_Equipment.cs:1036 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4789d8a2 | this.spdMain.CellClick | FP00130_Equipment.cs:1055 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) | DATA_OP | itemTmp.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cab7584a | this.spdMain.CellClick | FP00130_Equipment.cs:1056 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) | DATA_OP | itemTmp.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c0ffc3af | this.spdMain.CellClick | FP00130_Equipment.cs:1061 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ if (e.Column == siMain.GetColumnInde… | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LINE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null, null , s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LINE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d1bb77bf | this.spdMain.CellClick | FP00130_Equipment.cs:1072 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ if (e.Column == siMain.GetColumnInde… | DATA_OP | itemTmp.Rows.Add | (row[0].ToString(), row[0].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba3bb61 | this.spdMain.CellClick | FP00130_Equipment.cs:1075 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ if (e.Column == siMain.GetColumnInde… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("LINE_ID"), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-afdc3e9c | this.spdMain.CellClick | FP00130_Equipment.cs:1081 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ else of (e.Column == siMain.GetColum… | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.ELECTRODE_TYPE, false, CurrentUser, _sNonAuth, _sSaveAuth , null, null, null… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=ELECTRODE_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6e17f77 | this.spdMain.CellClick | FP00130_Equipment.cs:1084 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ else of (e.Column == siMain.GetColum… | DATA_OP | siMain.GetBindingRow | (e.Row) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5ee32b7d | this.spdMain.CellClick | FP00130_Equipment.cs:1089 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ else of (e.Column == siMain.GetColum… | DATA_OP | itemTmp.Rows.Add | (r["CODE"].ToString(), r["NAME"].ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-5c7e500f | this.spdMain.CellClick | FP00130_Equipment.cs:1093 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ else of (e.Column == siMain.GetColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex("ELECTRODE_TYPE"), itemTmp) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f12915cc | this.spdMain.CellClick | FP00130_Equipment.cs:1110 | if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (true) ▸ else of (e.Column == siMain.GetColum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ACTIVE_FLAG), dtYesOrNo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7a5e4bb1 | this.spdMain.CellClick | FP00130_Equipment.cs:1120 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b599a0cd | this.spdMain.CellClick | FP00130_Equipment.cs:1139 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) | DATA_OP | SubFilter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-ff2aad49 | this.spdMain.CellClick | FP00130_Equipment.cs:1140 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) | DATA_OP | SubFilter["SITE_ID"] | sSite | 행/컬럼 값 대입 |  |  |  |
| AC-c65391e0 | this.spdMain.CellClick | FP00130_Equipment.cs:1141 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) | DATA_OP | SubFilter["PLANT_ID"] | sPlant | 행/컬럼 값 대입 |  |  |  |
| AC-b4e48c55 | this.spdMain.CellClick | FP00130_Equipment.cs:1142 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) | DATA_OP | SubFilter["FACTORY_ID"] | sFactory | 행/컬럼 값 대입 |  |  |  |
| AC-402b0e9d | this.spdMain.CellClick | FP00130_Equipment.cs:1143 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) | DATA_OP | SubFilter["LINE_ID"] | sLine | 행/컬럼 값 대입 |  |  |  |
| AC-9269463d | this.spdMain.CellClick | FP00130_Equipment.cs:1144 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) | DATA_OP | SubFilter["OPERATION_ID"] | sOperation | 행/컬럼 값 대입 |  |  |  |
| AC-d56d9f19 | this.spdMain.CellClick | FP00130_Equipment.cs:1149 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) ▸ if (dsSub.Good()) | DATA_OP | dsSub.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b884a5c0 | this.spdMain.CellClick | FP00130_Equipment.cs:1150 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment && !eventConsume) ▸ if (dsSub.Good()) | GRID_BIND | siSub.Query | (dsSub, true) | 그리드에 조회 결과 바인딩 |  |  |  |

## FP00130_Equipment.spdMain_KeyDown

진입점: this.spdMain.KeyDown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a62737c3 | this.spdMain.KeyDown | FP00130_Equipment.cs:1175 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (range != null && range.Length > 0) ▸ for (i < range.Length) ▸ for (c < ea… | GRID_SET | siMain.ActiveSheet.Cells[r + eachRange.Row, c + eachRange.Column].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1b12cdff | this.spdMain.KeyDown | FP00130_Equipment.cs:1185 | if (e.KeyCode == Keys.Delete) ▸ if (this.IsEditMode == true) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtEquipment) ▸ if (siMain.Activ… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

