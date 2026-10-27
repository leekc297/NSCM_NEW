# AS-IS 액션 대조표 — FP02641

> 원천: `Doc/asisfacts/screens/FP02641/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 223행 · 메서드 24 · 종류 DATA_OP 55 · FLAG 36 · GRID_SET 20 · RETURN 17 · LIST_REBIND 15 · UI_PROP 14 · GRID_LOCK 11 · COMBO_DATA 10 · GRID_STYLE 9 · GRID_INIT 5 · ENDPOINT 5 · MESSAGE 5 · POPUP 4 · UI_MISC 4 · CALL_EXT 4 · THROW 3 · VALIDATE 2 · EXCEL 1 · CALL_BASE 1 · GRID_BIND 1 · VALUE_SET 1 · ⚠ 의미 확인 필요 5


## FP02641_WO_Status.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-597f65bc | this.btnSql.Click | FP02641_WO_Status.cs:757 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7d8cf1aa | this.btnSql.Click | FP02641_WO_Status.cs:758 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-18b7ad77 | this.btnSql.Click | FP02641_WO_Status.cs:760 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP02641_WO_STATUS") | 데이터 객체 조작/조회 |  |  |  |
| AC-b3431d7d | this.btnSql.Click | FP02641_WO_Status.cs:761 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP02641_WO_Status.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c16f1a5b | (진입점 미연결) | FP02641_WO_Status.cs:1237 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP02641_WO_Status.ClbDivision_SelectedIndexChanged

진입점: this.Load / clbDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bfcca597 | this.Load 외 1 | FP02641_WO_Status.cs:1106 |  | FLAG | dtProdType | Data_FP.Common_FP(Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sN… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-110dec42 | this.Load 외 1 | FP02641_WO_Status.cs:1106 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PRODUCTION_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAut… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PRODUCTION_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37325614 | this.Load 외 1 | FP02641_WO_Status.cs:1107 |  | LIST_REBIND | clsCtrl.setListBox | (dtProdType, cboProdType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02641_WO_Status.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3515c85 | this.Load | FP02641_WO_Status.cs:613 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d7827589 | this.Load | FP02641_WO_Status.cs:614 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a7b6b402 | this.Load | FP02641_WO_Status.cs:615 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP02641_WO_Status.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e69d5be | Dispose | FP02641_WO_Status.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP02641_WO_Status.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f983b6a9 | EditButton | FP02641_WO_Status.cs:643 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-63be8d0b | EditButton | FP02641_WO_Status.cs:646 | if (spdMain != null) | CALL_EXT | siMain.SwitchLockEx | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-26aa5299 | EditButton | FP02641_WO_Status.cs:650 | if (spdMain != null) ▸ if (!blnEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PLANT_ID), siMain.GetColumnIndex(DefColumns.ELECTRODE_TY… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8c4aaa28 | EditButton | FP02641_WO_Status.cs:651 | if (spdMain != null) ▸ if (!blnEdit) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PLAN_IN_QTY), siMain.GetColumnIndex(DefColumns.UPDATE_ID… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6eb26d13 | EditButton | FP02641_WO_Status.cs:659 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-af456516 | EditButton | FP02641_WO_Status.cs:670 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_first_test_wo.Equals… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-49ccb400 | EditButton | FP02641_WO_Status.cs:674 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_first_test_wo.Equals… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-3724ccb8 | EditButton | FP02641_WO_Status.cs:676 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_first_test_wo.Equals… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7d4accf8 | EditButton | FP02641_WO_Status.cs:681 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sIs_first_test_wo.E… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), siMain.GetColumnIndex(DefColumns.FIRST_T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-64f22429 | EditButton | FP02641_WO_Status.cs:682 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sIs_first_test_wo.E… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumns.F… | 그리드 표시 설정 |  |  |  |
| AC-f3d70913 | EditButton | FP02641_WO_Status.cs:688 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_vd_first_test_wo.Equ… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-1f1d00d8 | EditButton | FP02641_WO_Status.cs:692 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_vd_first_test_wo.Equ… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-cc06e48f | EditButton | FP02641_WO_Status.cs:694 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_vd_first_test_wo.Equ… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-af808f6f | EditButton | FP02641_WO_Status.cs:698 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sIs_vd_first_test_w… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), siMain.GetColumnIndex(DefColumns.VD_F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-459176ab | EditButton | FP02641_WO_Status.cs:699 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sIs_vd_first_test_w… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-6457bda6 | EditButton | FP02641_WO_Status.cs:705 | if (spdMain != null) ▸ if (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sWO_Status.Equals("Delet… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.UP… | 그리드 표시 설정 |  |  |  |
| AC-ed485e3b | EditButton | FP02641_WO_Status.cs:720 | if (spdMain != null) ▸ else of (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7ac98dbe | EditButton | FP02641_WO_Status.cs:725 | if (spdMain != null) ▸ else of (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sWO_Status.Equals("… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.UP… | 그리드 표시 설정 |  |  |  |
| AC-24653f43 | EditButton | FP02641_WO_Status.cs:728 | if (spdMain != null) ▸ else of (!blnEdit) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sWO_Status.Equ… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.UP… | 그리드 표시 설정 |  |  |  |

## FP02641_WO_Status.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-754b46a1 | ExcelButton | FP02641_WO_Status.cs:750 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP02641_WO_Status.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-675a288f | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:858 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { pInstanceID = CString.GetCheckedListValue(dtInstance, cbo… | ⚠ 의미 확인 필요 |  |  |  |
| AC-f748acc6 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:860 | try ▸ lambda | FLAG | pInstanceID | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-d7f6efd4 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:861 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-48a67416 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:862 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c985cfe9 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:863 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-81b5f519 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:864 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-46871f2e | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:865 | try ▸ lambda | FLAG | pOperationID | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-fe852fa7 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:866 | try ▸ lambda | FLAG | pLineID | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-49dc84d1 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:871 | try ▸ lambda | FLAG | pProdType | CString.GetCheckedListValue(dtProdType, cboProdType.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-37b59263 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:892 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02641_WO_STATUS") ⇒ FP_Master.PR_UI_FP02641_WO_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-6c87a9bf | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:893 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-72ee2753 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:894 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6bd6fb12 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:895 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-a1fffee3 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:896 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-76094d98 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:897 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-82ab5d89 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:899 | try | DATA_OP | request.Parameters["p_instance_id"] | pInstanceID.Equals("ALL") ? DBNull.Value : pInstanceID | 행/컬럼 값 대입 |  |  |  |
| AC-684fe34c | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:900 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-2e1df7b9 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:901 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-4258b29d | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:902 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-8738a19f | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:903 | try | DATA_OP | request.Parameters["p_factory_id"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-45f59001 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:904 | try | DATA_OP | request.Parameters["p_operation_id"] | pOperationID.Equals("ALL") ? DBNull.Value : pOperationID | 행/컬럼 값 대입 |  |  |  |
| AC-571d70f6 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:905 | try | DATA_OP | request.Parameters["p_line_id"] | pLineID.Equals("ALL") ? DBNull.Value : pLineID | 행/컬럼 값 대입 |  |  |  |
| AC-5a8b5caa | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:906 | try | DATA_OP | request.Parameters["p_top_item_id"] | pTopItemId.Equals("ALL") ? DBNull.Value : pTopItemId | 행/컬럼 값 대입 |  |  |  |
| AC-a884e9f4 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:907 | try | DATA_OP | request.Parameters["p_item_id"] | pItemId.Equals("ALL") ? DBNull.Value : pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-1aa4bd9a | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:908 | try | DATA_OP | request.Parameters["p_work_order_id"] | pWorkOrderId.Equals("ALL") ? DBNull.Value : pWorkOrderId | 행/컬럼 값 대입 |  |  |  |
| AC-e8dd6d23 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:909 | try | DATA_OP | request.Parameters["p_from_date"] | p_from_date.Equals("ALL") ? DBNull.Value : p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-61471572 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:910 | try | DATA_OP | request.Parameters["p_to_date"] | p_to_date.Equals("ALL") ? DBNull.Value : p_to_date | 행/컬럼 값 대입 |  |  |  |
| AC-55250932 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:911 | try | DATA_OP | request.Parameters["p_prod_type"] | pProdType.Equals("ALL") ? DBNull.Value : pProdType | 행/컬럼 값 대입 |  |  |  |
| AC-54ef5393 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:912 | try | DATA_OP | request.Parameters["p_status"] | pStatus.Equals("ALL") ? DBNull.Value : pStatus | 행/컬럼 값 대입 |  |  |  |
| AC-5a5c5595 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:915 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b348b97a | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:917 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c20f5650 | popSql.OnSql [if (programID == "PR_UI_FP02641_WO_STATUS")] 외 2 | FP02641_WO_Status.cs:924 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP02641_WO_Status.FindData

진입점: FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4db88658 | FindButton 외 1 | FP02641_WO_Status.cs:769 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-74f2b83d | FindButton 외 1 | FP02641_WO_Status.cs:773 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-bdcb9a36 | FindButton 외 1 | FP02641_WO_Status.cs:773 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4167c58 | FindButton 외 1 | FP02641_WO_Status.cs:777 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a87aebb2 | FindButton 외 1 | FP02641_WO_Status.cs:778 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07fd0b2d | FindButton 외 1 | FP02641_WO_Status.cs:781 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-93209251 | FindButton 외 1 | FP02641_WO_Status.cs:788 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28b626e1 | FindButton 외 1 | FP02641_WO_Status.cs:795 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5d8468a9 | FindButton 외 1 | FP02641_WO_Status.cs:797 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-204b5a06 | FindButton 외 1 | FP02641_WO_Status.cs:806 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-6475439b | FindButton 외 1 | FP02641_WO_Status.cs:810 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c6d2431 | FindButton 외 1 | FP02641_WO_Status.cs:813 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-7a912ffb | FindButton 외 1 | FP02641_WO_Status.cs:818 | try | CALL_EXT | siMain.SetRightMerge | (siMain.GetMaxColumnIndex(), true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-08998c07 | FindButton 외 1 | FP02641_WO_Status.cs:819 | try | CALL_EXT | siMain.SetMergeRange | (1, 6) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9ec93803 | FindButton 외 1 | FP02641_WO_Status.cs:820 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4b06dac9 | FindButton 외 1 | FP02641_WO_Status.cs:832 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-53dd02d7 | FindButton 외 1 | FP02641_WO_Status.cs:833 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02641_WO_Status.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2fc0ed00 | this.Load | FP02641_WO_Status.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP02641_WO_Status.GetPlanGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a9fa62b | this.Load | FP02641_WO_Status.cs:460 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-53ea97c7 | this.Load | FP02641_WO_Status.cs:461 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-02a71156 | this.Load | FP02641_WO_Status.cs:461 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-510d13b5 | this.Load | FP02641_WO_Status.cs:463 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-ddc11054 | this.Load | FP02641_WO_Status.cs:465 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ceab9b8d | this.Load | FP02641_WO_Status.cs:468 | if (cboInstance.Items.Count > 0) | VALUE_SET | cboInstance.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3f41c717 | this.Load | FP02641_WO_Status.cs:469 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-37af9c20 | this.Load | FP02641_WO_Status.cs:469 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboInstance.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-3e5a22ba | this.Load | FP02641_WO_Status.cs:470 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cboInstance.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3de57c9b | this.Load | FP02641_WO_Status.cs:471 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cboInstance.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3180142b | this.Load | FP02641_WO_Status.cs:472 | if (cboInstance.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cboInstance.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3082a7f4 | this.Load | FP02641_WO_Status.cs:476 | else of (cboInstance.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP02641_WO_Status.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2352182e | this.Load | FP02641_WO_Status.cs:166 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ece6490 | this.Load | FP02641_WO_Status.cs:173 |  | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-3efc3089 | this.Load | FP02641_WO_Status.cs:174 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-6efc7649 | this.Load | FP02641_WO_Status.cs:183 |  | FLAG | dtCurDate | Data_FP.Common_FP(Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonA… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 화면 필드/플래그 변경 |  |  |  |
| AC-a7bd757f | this.Load | FP02641_WO_Status.cs:183 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.CURRENT_DATE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=CURRENT_DATE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-94f58808 | this.Load | FP02641_WO_Status.cs:185 |  | FLAG | sCurDate | (string)dtCurDate.Rows[0]["CUR_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-fd3f7eb2 | this.Load | FP02641_WO_Status.cs:186 |  | FLAG | sPlanDate | sCurDate.Replace("-", "") | 화면 필드/플래그 변경 |  |  |  |
| AC-9b7f54f9 | this.Load | FP02641_WO_Status.cs:187 |  | FLAG | sPrevDate | sCurDate | 화면 필드/플래그 변경 |  |  |  |
| AC-47041206 | this.Load | FP02641_WO_Status.cs:192 |  | UI_PROP | drpPeriod.Text1 | DateUtil.GetDateAdd(sCurDate.Replace("-", ""), -7, "D") | 속성 Text1 설정 |  |  |  |
| AC-f134ee23 | this.Load | FP02641_WO_Status.cs:193 |  | UI_PROP | drpPeriod.Text2 | DateUtil.GetDateAdd(sCurDate.Replace("-", ""), 7, "D") | 속성 Text2 설정 |  |  |  |
| AC-d8e79e48 | this.Load | FP02641_WO_Status.cs:196 |  | FLAG | dtStatus | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp("FP02641_WO_STATUS", "WO_STATUS") | 화면 필드/플래그 변경 |  |  |  |
| AC-1a95451e | this.Load | FP02641_WO_Status.cs:196 |  | CALL_EXT | GSCM.Windows.Forms.Service.LookupService.GetAsTableFp | ("FP02641_WO_STATUS", "WO_STATUS") | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc0ce8fc | this.Load | FP02641_WO_Status.cs:221 |  | LIST_REBIND | clsCtrl.setListBox | (dtStatus, cboStatus, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP02641_WO_Status.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37eb0613 | this.Load | FP02641_WO_Status.cs:585 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-d7922dc6 | this.Load | FP02641_WO_Status.cs:586 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-fa3eabb1 | this.Load | FP02641_WO_Status.cs:587 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-aa1439de | this.Load | FP02641_WO_Status.cs:588 |  | UI_PROP | clbLine.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP02641_WO_Status.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22fb0e55 | this.Load 외 2 | FP02641_WO_Status.cs:622 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-dee05392 | this.Load 외 2 | FP02641_WO_Status.cs:624 |  | GRID_INIT | siMain.SetSheetHeaderColumn_FP | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP02641_WO_Status.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b6479a6 | popSql.OnSql | FP02641_WO_Status.cs:1250 | if (programID == "PR_UI_FP02641_WO_STATUS") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-69b29a7e | popSql.OnSql | FP02641_WO_Status.cs:1253 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02641_WO_Status.Save_Data

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6179e66 | SaveButton | FP02641_WO_Status.cs:930 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a52e580b | SaveButton | FP02641_WO_Status.cs:932 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26519e8b | SaveButton | FP02641_WO_Status.cs:937 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4cc9f05c | SaveButton | FP02641_WO_Status.cs:938 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-057e3fcc | SaveButton | FP02641_WO_Status.cs:941 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-05ee0315 | SaveButton | FP02641_WO_Status.cs:948 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d223a017 | SaveButton | FP02641_WO_Status.cs:950 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d1396d0d | SaveButton | FP02641_WO_Status.cs:951 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a636db92 | SaveButton | FP02641_WO_Status.cs:956 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-22c38e97 | SaveButton | FP02641_WO_Status.cs:961 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2ef883f9 | SaveButton | FP02641_WO_Status.cs:970 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e41409e3 | SaveButton | FP02641_WO_Status.cs:974 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2d317554 | SaveButton | FP02641_WO_Status.cs:978 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-daf12764 | SaveButton | FP02641_WO_Status.cs:979 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-59bafc89 | SaveButton | FP02641_WO_Status.cs:983 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP02641_WO_Status.Save_Data_Execute

진입점: SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7237278c | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1025 | try ▸ if (sQueryType.Equals("MAIN")) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-453b6a87 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1045 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP02641_SAVE") ⇒ FP_Master.PR_UI_FP02641_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-98c04033 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1046 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-be7a6c8b | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1048 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-c43dd7ba | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1049 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b9011475 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1050 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-fd2ca390 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1051 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-664976e0 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1053 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_first_test_wo"] | p_first_test_wo | 행/컬럼 값 대입 |  |  |  |
| AC-fc6255b1 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1054 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_vd_first_test_wo"] | p_vd_first_test_wo | 행/컬럼 값 대입 |  |  |  |
| AC-9ee27995 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1055 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_work_order_id"] | p_work_order_id | 행/컬럼 값 대입 |  |  |  |
| AC-4eaa64c9 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1057 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a481bd4a | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1058 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5fcf4b50 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1064 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-50a5fa35 | SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] | FP02641_WO_Status.cs:1070 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP02641_WO_Status.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e09e17a | SaveButton | FP02641_WO_Status.cs:739 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP02641_WO_Status.Search_After

진입점: FindButton [finally] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ finally]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0210bb3a | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1142 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f6ac2d39 | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1150 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9c09794c | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1160 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sWO_Status.Equals("Deleted")) | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.UP… | 그리드 표시 설정 |  |  |  |
| AC-6a0ad379 | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1167 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_first_test_wo.Equals("Y") && !sVd_fi… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-5244cd43 | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1170 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_first_test_wo.Equals("Y") && !sVd_fi… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-64c2e851 | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1174 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sIs_first_test_wo.Equals("Y") && !s… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].Value | string.Empty | 그리드 속성/값 설정 |  |  |  |
| AC-9e75e752 | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1183 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_vd_first_test_wo.Equals("Y") && !sfi… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-f80617f7 | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1186 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sIs_vd_first_test_wo.Equals("Y") && !sfi… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-7e622ead | FindButton [finally] 외 1 | FP02641_WO_Status.cs:1190 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() >= 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sIs_vd_first_test_wo.Equals("Y") &&… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].Value | string.Empty | 그리드 속성/값 설정 |  |  |  |

## FP02641_WO_Status.SetChangeControl

진입점: this.Load / cboInstance.SelectedIndexChanged / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / cboOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-301a21e6 | this.Load 외 7 | FP02641_WO_Status.cs:487 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d0376f0 | this.Load 외 7 | FP02641_WO_Status.cs:487 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-21a405b4 | this.Load 외 7 | FP02641_WO_Status.cs:496 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] | 행/컬럼 값 대입 |  |  |  |
| AC-6725683f | this.Load 외 7 | FP02641_WO_Status.cs:497 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-684593ea | this.Load 외 7 | FP02641_WO_Status.cs:497 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fdb4a29f | this.Load 외 7 | FP02641_WO_Status.cs:500 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ if ((object)clbDivision is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)clbDivision as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0f31a25e | this.Load 외 7 | FP02641_WO_Status.cs:502 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ else of ((object)clbDivision is UsrCombo) ▸ if ((object)clbD… | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)clbDivision as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ef428a7a | this.Load 외 7 | FP02641_WO_Status.cs:508 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | DATA_OP | Filter[DefColumns.DIVISION_ID] | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-fef1a532 | this.Load 외 7 | FP02641_WO_Status.cs:509 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1f64a9b8 | this.Load 외 7 | FP02641_WO_Status.cs:509 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ffe66a46 | this.Load 외 7 | FP02641_WO_Status.cs:512 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9928539a | this.Load 외 7 | FP02641_WO_Status.cs:514 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fccc1c24 | this.Load 외 7 | FP02641_WO_Status.cs:520 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-40fd9ad8 | this.Load 외 7 | FP02641_WO_Status.cs:521 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f7c3fd5 | this.Load 외 7 | FP02641_WO_Status.cs:521 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-8a47028b | this.Load 외 7 | FP02641_WO_Status.cs:524 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6eb6268f | this.Load 외 7 | FP02641_WO_Status.cs:526 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-96634e69 | this.Load 외 7 | FP02641_WO_Status.cs:532 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-ef60599d | this.Load 외 7 | FP02641_WO_Status.cs:533 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-fd72e90e | this.Load 외 7 | FP02641_WO_Status.cs:533 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d34fb98f | this.Load 외 7 | FP02641_WO_Status.cs:535 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ if ((object)clbFactory is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-22e3df96 | this.Load 외 7 | FP02641_WO_Status.cs:537 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) ▸ else of ((object)clbFactory is UsrCombo) ▸ if ((object)clbFactory … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, (object)clbFactory as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ab58f64b | this.Load 외 7 | FP02641_WO_Status.cs:543 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory,clbFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-66374f16 | this.Load 외 7 | FP02641_WO_Status.cs:544 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | FLAG | dtOperation | DataService.GetInnerTable("OPERATION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4835d967 | this.Load 외 7 | FP02641_WO_Status.cs:544 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | COMBO_DATA | DataService.GetInnerTable | ("OPERATION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6e51a02e | this.Load 외 7 | FP02641_WO_Status.cs:546 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ if ((object)cboOperation is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)cboOperation as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bb5eb8bf | this.Load 외 7 | FP02641_WO_Status.cs:548 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) ▸ else of ((object)cboOperation is UsrCombo) ▸ if ((object)cboOp… | LIST_REBIND | clsCtrl.setListBox | (dtOperation, (object)cboOperation as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f7f1c304 | this.Load 외 7 | FP02641_WO_Status.cs:554 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | DATA_OP | Filter["OPERATION_ID"] | CString.GetCheckedListValue(dtOperation, cboOperation.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-90d3586e | this.Load 외 7 | FP02641_WO_Status.cs:555 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | FLAG | dtLine | DataService.GetInnerTable("LINE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-92128626 | this.Load 외 7 | FP02641_WO_Status.cs:555 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) | COMBO_DATA | DataService.GetInnerTable | ("LINE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-cf469029 | this.Load 외 7 | FP02641_WO_Status.cs:557 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ if ((object)clbLine is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f93f5c1f | this.Load 외 7 | FP02641_WO_Status.cs:559 | switch (triggerControl) case DefColumns.OPERATION_ID: ▸ if (dtOperation.Good()) ▸ else of ((object)clbLine is UsrCombo) ▸ if ((object)clbLin… | LIST_REBIND | clsCtrl.setListBox | (dtLine, (object)clbLine as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3c601050 | this.Load 외 7 | FP02641_WO_Status.cs:565 | switch (triggerControl) case DefColumns.LINE_ID: ▸ if (dtLine.Good()) | DATA_OP | Filter["LINE_ID"] | CString.GetCheckedListValue(dtLine, clbLine.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP02641_WO_Status.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboInstance.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbFactory.SelectedIndexChanged [switch (triggerControl…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d8335e9 | this.Load [switch (triggerControl) case DefColumns.INSTANCE_… 외 7 | FP02641_WO_Status.cs:455 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP02641_WO_Status.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c2a31b3 | dsdmMain.Changed | FP02641_WO_Status.cs:1321 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4320117a | dsdmMain.Changed | FP02641_WO_Status.cs:1322 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15836bb4 | dsdmMain.Changed | FP02641_WO_Status.cs:1338 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | DATA_OP | siMain.GetBindingRow | (i) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5e253b06 | dsdmMain.Changed | FP02641_WO_Status.cs:1361 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-0213076f | dsdmMain.Changed | FP02641_WO_Status.cs:1366 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), true) | 그리드 값 설정 |  |  |  |
| AC-558d718b | dsdmMain.Changed | FP02641_WO_Status.cs:1369 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-2bf15205 | dsdmMain.Changed | FP02641_WO_Status.cs:1371 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumns.F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d42bcdec | dsdmMain.Changed | FP02641_WO_Status.cs:1377 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-95ec84e4 | dsdmMain.Changed | FP02641_WO_Status.cs:1379 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO)].CellType | emptyCell | 그리드 속성/값 설정 |  |  |  |
| AC-3e6b4c1d | dsdmMain.Changed | FP02641_WO_Status.cs:1380 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), siMain.GetColumnIndex(DefColumns.FIRST_T… | 그리드 편집 잠금/해제 |  |  |  |
| AC-143281f6 | dsdmMain.Changed | FP02641_WO_Status.cs:1381 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumns.F… | 그리드 표시 설정 |  |  |  |
| AC-b86a4e9d | dsdmMain.Changed | FP02641_WO_Status.cs:1386 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-dc0b3320 | dsdmMain.Changed | FP02641_WO_Status.cs:1391 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), true) | 그리드 값 설정 |  |  |  |
| AC-ebd87713 | dsdmMain.Changed | FP02641_WO_Status.cs:1394 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), false) | 그리드 값 설정 |  |  |  |
| AC-97914a45 | dsdmMain.Changed | FP02641_WO_Status.cs:1396 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_LOCK | siMain.LockRange | (i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6c6981d0 | dsdmMain.Changed | FP02641_WO_Status.cs:1400 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), string.Empty) | 그리드 값 설정 |  |  |  |
| AC-6a1459d0 | dsdmMain.Changed | FP02641_WO_Status.cs:1402 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_SET | siMain.ActiveSheet.Cells[i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO)].CellType | emptyCell | 그리드 속성/값 설정 |  |  |  |
| AC-025adc42 | dsdmMain.Changed | FP02641_WO_Status.cs:1403 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), siMain.GetColumnIndex(DefColumns.VD_F… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5455deca | dsdmMain.Changed | FP02641_WO_Status.cs:1404 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.VD_FIRST_TEST_WO), i, siMain.GetColumnIndex(DefColumn… | 그리드 표시 설정 |  |  |  |
| AC-209cb4cd | dsdmMain.Changed | FP02641_WO_Status.cs:1409 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (e.Type == FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated && ( si… | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.OPERATION_ID), i, siMain.GetColumnIndex(DefColumns.UP… | 그리드 표시 설정 |  |  |  |

## FP02641_WO_Status.tbItemId_BeforeOpenSearch

진입점: this.tbItemId.BeforeOpenSearch

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2cb888b | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1267 |  | DATA_OP | tbItemId.Filter["division_lt"] | clbDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3e70c7a9 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1268 |  | DATA_OP | tbItemId.Filter["site_lt"] | cboSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-80ef8b39 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1272 |  | DATA_OP | _col_width.Add | ("chk".ToUpper(), 25) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9f9ce77 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1273 |  | DATA_OP | _col_width.Add | ("company".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-6d23cfc4 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1274 |  | DATA_OP | _col_width.Add | ("division".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-38dca70c | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1275 |  | DATA_OP | _col_width.Add | ("site".ToUpper(), 100) | 데이터 객체 조작/조회 |  |  |  |
| AC-189d84ed | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1276 |  | DATA_OP | _col_width.Add | ("item".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-c163efc0 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1277 |  | DATA_OP | _col_width.Add | ("nick_name".ToUpper(), 150) | 데이터 객체 조작/조회 |  |  |  |
| AC-95cd433a | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1278 |  | DATA_OP | _col_width.Add | ("_default_column_width_".ToUpper(), 0) | 데이터 객체 조작/조회 |  |  |  |
| AC-6a211265 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1282 |  | DATA_OP | _col_title.Add | ("Material".ToUpper(), "Material") | 데이터 객체 조작/조회 |  |  |  |
| AC-97efb453 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1284 |  | UI_PROP | tbItemId.ColumnWidth | _col_width | 속성 ColumnWidth 설정 |  |  |  |
| AC-db204b30 | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1285 |  | UI_PROP | tbItemId.ColumnTitle | _col_title | 속성 ColumnTitle 설정 |  |  |  |
| AC-dea018fc | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1287 |  | UI_PROP | tbItemId.PopupWidth | 800 | 속성 PopupWidth 설정 |  |  |  |
| AC-cd6ace0e | this.tbItemId.BeforeOpenSearch | FP02641_WO_Status.cs:1288 |  | UI_PROP | tbItemId.PopupHeight | 600 | 속성 PopupHeight 설정 |  |  |  |

## FP02641_WO_Status.tbItemId_OnSearchConditionChanged

진입점: this.tbItemId.OnSearchConditionChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006197ca | this.tbItemId.OnSearchConditionChanged | FP02641_WO_Status.cs:1302 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

