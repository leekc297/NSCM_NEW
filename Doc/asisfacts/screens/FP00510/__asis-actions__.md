# AS-IS 액션 대조표 — FP00510

> 원천: `Doc/asisfacts/screens/FP00510/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 614행 · 메서드 63 · 종류 DATA_OP 197 · FLAG 83 · RETURN 51 · GRID_SET 40 · GRID_INIT 30 · UI_PROP 29 · MESSAGE 28 · UI_MISC 21 · VALUE_SET 19 · POPUP 17 · ENDPOINT 17 · COMBO_DATA 12 · STATE 12 · GRID_LOCK 11 · LIST_REBIND 11 · GRID_STYLE 8 · CALL_EXT 7 · THROW 6 · VALIDATE 5 · GRID_BIND 4 · EXCEL 2 · CALL_BASE 2 · GRID_COMBO 1 · FOCUS 1 · ⚠ 의미 확인 필요 9


## FP00510_ChangeProdTypePopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3a48599 | .ctor | FP00510_ChangeProdTypePopup.cs:127 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-6ceb0d3d | .ctor | FP00510_ChangeProdTypePopup.cs:128 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-5861a0a6 | .ctor | FP00510_ChangeProdTypePopup.cs:129 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-25ae55a1 | .ctor | FP00510_ChangeProdTypePopup.cs:130 |  | FLAG | this.sParamsFilter | pParamsFilter | 화면 필드/플래그 변경 |  |  |  |
| AC-71052e8a | .ctor | FP00510_ChangeProdTypePopup.cs:131 |  | FLAG | this.sDbParamsList | pDbParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-278c5c76 | .ctor | FP00510_ChangeProdTypePopup.cs:133 |  | UI_PROP | SpdSheet.shtTarget | this.sSheetName | 속성 shtTarget 설정 |  |  |  |
| AC-36f99e0f | .ctor | FP00510_ChangeProdTypePopup.cs:137 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | MESSAGE | MessageBox.Show | ("The ProgramID/SheetName/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK,… | 메시지 표시 |  |  |  |
| AC-a3ca90fd | .ctor | FP00510_ChangeProdTypePopup.cs:138 | if (string.IsNullOrEmpty(this.sSheetName) \|\| string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCall…) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-2ca964f0 | .ctor | FP00510_ChangeProdTypePopup.cs:142 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | MESSAGE | MessageBox.Show | ("the Filter/DB List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Err… | 메시지 표시 |  |  |  |
| AC-087cd755 | .ctor | FP00510_ChangeProdTypePopup.cs:143 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-790cdc72 | .ctor | FP00510_ChangeProdTypePopup.cs:150 |  | FLAG | iDbParmsCount | arrDbList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-bf5e5fb3 | .ctor | FP00510_ChangeProdTypePopup.cs:152 |  | UI_PROP | structParam._sParamFilter | new string[iDbParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-eca66e02 | .ctor | FP00510_ChangeProdTypePopup.cs:153 |  | UI_PROP | structParam._sDbParamsList | new string[iDbParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-8e84a4f4 | .ctor | FP00510_ChangeProdTypePopup.cs:157 | for (i < iDbParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrFilter[i] | 행/컬럼 값 대입 |  |  |  |
| AC-60be2c1d | .ctor | FP00510_ChangeProdTypePopup.cs:158 | for (i < iDbParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrDbList[i] | 행/컬럼 값 대입 |  |  |  |

## FP00510_ChangeProdTypePopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b28a99b | this.btnClose.Click | FP00510_ChangeProdTypePopup.cs:405 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00510_ChangeProdTypePopup.btnFind_Click

진입점: this.btnFind.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-247125f9 | this.btnFind.Click | FP00510_ChangeProdTypePopup.cs:391 |  | DATA_OP | structParam._sParamFilter[16] | sData | 행/컬럼 값 대입 |  |  |  |
| AC-958542c9 | this.btnFind.Click | FP00510_ChangeProdTypePopup.cs:392 |  | DATA_OP | structParam._sParamFilter[8] | txtItemID.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-14cb16f2 | this.btnFind.Click | FP00510_ChangeProdTypePopup.cs:393 |  | DATA_OP | structParam._sParamFilter[9] | txtItemName.Text.ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00510_ChangeProdTypePopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6ae392d | this.btnSql.Click | FP00510_ChangeProdTypePopup.cs:412 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f47e6ea8 | this.btnSql.Click | FP00510_ChangeProdTypePopup.cs:413 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-20bb8a40 | this.btnSql.Click | FP00510_ChangeProdTypePopup.cs:415 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00510_PRODTYPE_SELECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-59583d57 | this.btnSql.Click | FP00510_ChangeProdTypePopup.cs:416 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00510_PRODTYPE_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6eea6a52 | this.btnSql.Click | FP00510_ChangeProdTypePopup.cs:417 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00510_ChangeProdTypePopup.CboOrderType_SelectedIndexChanged

진입점: cboOrderType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76aaa6dd | cboOrderType.SelectedIndexChanged | FP00510_ChangeProdTypePopup.cs:736 | try ▸ if (sDataID.Equals("")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57983fa0 | cboOrderType.SelectedIndexChanged | FP00510_ChangeProdTypePopup.cs:742 | try ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (siTarget.GetValue(i, siTarget.GetColumnIndex(DefColumns.CHK)).ToString() == "True") | GRID_SET | siTarget.SetValue | (i, siTarget.GetColumnIndex(DefColumns.PRODUCTION_TYPE), sDataID) | 그리드 값 설정 |  |  |  |

## FP00510_ChangeProdTypePopup.chlAll_CheckedChanged

진입점: this.chlAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f5d37541 | this.chlAll.CheckedChanged | FP00510_ChangeProdTypePopup.cs:769 | if (siTarget.ActiveSheet.RowCount > 0 && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (chlAll.Checked == true) ▸ for (iRow < siTarget.… | CALL_EXT | siTarget.ActiveSheet.RowFilter.IsRowFilteredOut | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-01c9e15f | this.chlAll.CheckedChanged | FP00510_ChangeProdTypePopup.cs:770 | if (siTarget.ActiveSheet.RowCount > 0 && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (chlAll.Checked == true) ▸ for (iRow < siTarget.… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, 1, true) | 그리드 값 설정 |  |  |  |
| AC-451aed4e | this.chlAll.CheckedChanged | FP00510_ChangeProdTypePopup.cs:772 | if (siTarget.ActiveSheet.RowCount > 0 && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (chlAll.Checked == true) ▸ for (iRow < siTarget.… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, 1, false) | 그리드 값 설정 |  |  |  |
| AC-dc9109c9 | this.chlAll.CheckedChanged | FP00510_ChangeProdTypePopup.cs:777 | if (siTarget.ActiveSheet.RowCount > 0 && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (chlAll.Checked == true) ▸ for (iRow < siTarget.… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, 1, true) | 그리드 값 설정 |  |  |  |
| AC-57ccc694 | this.chlAll.CheckedChanged | FP00510_ChangeProdTypePopup.cs:786 | if (siTarget.ActiveSheet.RowCount > 0 && siTarget.IsLock(siTarget.SheetName) == false) ▸ else of (chlAll.Checked == true) ▸ for (iRow < siTa… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, 1, false) | 그리드 값 설정 |  |  |  |

## FP00510_ChangeProdTypePopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b71e470 | this.Load | FP00510_ChangeProdTypePopup.cs:229 |  | GRID_INIT | this.AddSheet | (spdTarget, SpdSheet.shtTarget, SpdSheet.shtTarget, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c377fca2 | this.Load | FP00510_ChangeProdTypePopup.cs:230 |  | FLAG | siTarget | GetSheetInfo(spdTarget.Name, spdTarget.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5e31739 | this.Load | FP00510_ChangeProdTypePopup.cs:236 |  | GRID_INIT | siTarget.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00510_ChangeProdTypePopup.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68c879a6 | this.Load | FP00510_ChangeProdTypePopup.cs:222 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## FP00510_ChangeProdTypePopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f46186da | Dispose | FP00510_ChangeProdTypePopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00510_ChangeProdTypePopup.EditButton

진입점: this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnSave.Click [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)] / this.btnFind.Click [try ▸ if (ds.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] / EditButton / SaveButton [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88f9b72e | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:309 | if (spdTarget != null) | FLAG | siTarget | GetSheetInfo(spdTarget.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9ecd4514 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:311 | if (spdTarget != null) | GRID_LOCK | siTarget.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4b30a8b8 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:317 | if (spdTarget != null) | GRID_LOCK | siTarget.LockColumn | (siTarget.GetColumnIndex(DefColumns.COMPANY_ID), siTarget.GetColumnIndex(DefColumns.LINE_N… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8bf94eaf | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:328 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) | GRID_SET | siTarget.ActiveSheet.Cells[0, siTarget.GetColumnIndex(DefColumns.CHK)].CellType | chk | 그리드 속성/값 설정 |  |  |  |
| AC-e8269494 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:329 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) | GRID_SET | siTarget.ActiveSheet.Cells[0, siTarget.GetColumnIndex(DefColumns.CHK)].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-756640f2 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:330 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) | GRID_SET | siTarget.ActiveSheet.Cells[0, siTarget.GetColumnIndex(DefColumns.CHK)].Border | bevelbrdr | 그리드 속성/값 설정 |  |  |  |
| AC-766b191c | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:335 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siTarget.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-61596b1b | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:339 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ if (i % 2 ==… | GRID_SET | siTarget.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-c151c691 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:343 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ else of (i %… | GRID_SET | siTarget.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-70bb327f | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:346 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_LOCK | siTarget.LockRange2 | (0, siTarget.GetColumnIndex(DefColumns.CHK), siTarget.ActiveSheet.RowCount - 1, siTarget.G… | 그리드 편집 잠금 전환 |  |  |  |
| AC-d8ddce5a | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:347 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siTarget.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-51793c67 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:355 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i %… | GRID_STYLE | siTarget.SetBGColor | (i, siTarget.GetColumnIndex(DefColumns.PRODUCTION_TYPE), i, siTarget.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |
| AC-34199314 | this.Load [try ▸ if (ds.Tables[0].Rows.Count > 0)] 외 5 | FP00510_ChangeProdTypePopup.cs:359 | if (spdTarget != null) ▸ if (siTarget.GetMaxRowIndex() > 0) ▸ for (i <= siTarget.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of… | GRID_STYLE | siTarget.SetBGColor | (i, siTarget.GetColumnIndex(DefColumns.PRODUCTION_TYPE), i, siTarget.GetColumnIndex(DefCol… | 그리드 표시 설정 |  |  |  |

## FP00510_ChangeProdTypePopup.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e866c354 | ExcelButton | FP00510_ChangeProdTypePopup.cs:384 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00510_ChangeProdTypePopup.Find_Data

진입점: this.Load / this.btnSave.Click [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / this.btnFind.Click / FindButton / SaveButton [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c07f439 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:428 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6e91514f | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:433 | try | CALL_EXT | spdTarget.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-eda4cb16 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:436 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-5a3f030f | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:436 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31d87333 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:442 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2f838887 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:445 | try | GRID_INIT | siTarget.ChangeSheet | (SpdSheet.shtTarget) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0781dd45 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:451 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => Find_Data_ProdType("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8352b24b | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:462 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_BIND | siTarget.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-df7d7783 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:467 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siTarget.LockColumn | (0, siTarget.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b99770da | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:472 | try ▸ if (ds.Tables[0].Rows.Count > 0) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6796fd26 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:475 | try ▸ if (ds.Tables[0].Rows.Count > 0) | FLAG | dtSheetData | ds.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f631868 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:478 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siTarget.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bcf67bee | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:486 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siTarget.SetLockFlag | (SpdSheet.shtTarget, false) | 그리드 편집 잠금/해제 |  |  |  |
| AC-871fe8a4 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:491 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_STYLE | spdTarget.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-605c70af | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:497 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f270bd3 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:498 | finally | GRID_SET | this.spdTarget.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-763ff601 | this.Load 외 4 | FP00510_ChangeProdTypePopup.cs:498 | finally | CALL_EXT | this.spdTarget.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00510_ChangeProdTypePopup.Find_Data_ProdType

진입점: this.Load [try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00510_PRODTYPE_SELECT")] / this.btnSave.Click [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / this.btnFind.Click [try ▸ lambda] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1321d1f | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:512 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-dcb774d0 | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:514 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-5c8cc1f2 | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:515 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_PRODUCTIONTYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-0957486a | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:516 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-27a9be59 | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:517 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5d07055d | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:521 | try ▸ for (i < iDbParmsCount) | DATA_OP | request.Parameters[structParam._sDbParamsList[i].ToString()] | structParam._sParamFilter[i].ToString().Equals("ALL") ? "" : structParam._sParamFilter[i].… | 행/컬럼 값 대입 |  |  |  |
| AC-17a7525b | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:524 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-580c972b | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:527 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-c29dae94 | this.Load [try ▸ lambda] 외 5 | FP00510_ChangeProdTypePopup.cs:533 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00510_ChangeProdTypePopup.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-709d251b | FindButton | FP00510_ChangeProdTypePopup.cs:298 |  | DATA_OP | structParam._sParamFilter[16] | sData | 행/컬럼 값 대입 |  |  |  |
| AC-04dba432 | FindButton | FP00510_ChangeProdTypePopup.cs:299 |  | DATA_OP | structParam._sParamFilter[8] | txtItemID.Text.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8c1b2ec1 | FindButton | FP00510_ChangeProdTypePopup.cs:300 |  | DATA_OP | structParam._sParamFilter[9] | txtItemName.Text.ToString() | 행/컬럼 값 대입 |  |  |  |

## FP00510_ChangeProdTypePopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17126dfb | this.Load | FP00510_ChangeProdTypePopup.cs:169 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c1bee2ca | this.Load | FP00510_ChangeProdTypePopup.cs:171 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00510_ChangeProdTypePopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25d63178 | this.Load | FP00510_ChangeProdTypePopup.cs:189 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-3ede4d3e | this.Load | FP00510_ChangeProdTypePopup.cs:191 |  | FLAG | dtProductionType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 화면 필드/플래그 변경 |  |  |  |
| AC-836f95ce | this.Load | FP00510_ChangeProdTypePopup.cs:191 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-22a4b7d6 | this.Load | FP00510_ChangeProdTypePopup.cs:196 |  | LIST_REBIND | clsCtrl.setListBox | (dtProductionType, cboOrderType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c5450664 | this.Load | FP00510_ChangeProdTypePopup.cs:198 |  | VALUE_SET | cboOrderType.SelectedValue | structParam._sParamFilter[16] | 컨트롤 값 설정 |  |  |  |
| AC-3589c28e | this.Load | FP00510_ChangeProdTypePopup.cs:200 |  | VALUE_SET | txtItemID.Text | structParam._sParamFilter[8].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-0db186a2 | this.Load | FP00510_ChangeProdTypePopup.cs:201 |  | VALUE_SET | txtItemName.Text | structParam._sParamFilter[9].ToString() | 컨트롤 값 설정 |  |  |  |
| AC-bf62cf66 | this.Load | FP00510_ChangeProdTypePopup.cs:213 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-a6b85da0 | this.Load | FP00510_ChangeProdTypePopup.cs:214 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-22d581ae | this.Load | FP00510_ChangeProdTypePopup.cs:215 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00510_ChangeProdTypePopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b6cf8706 | this.Load | FP00510_ChangeProdTypePopup.cs:246 | try | GRID_INIT | siTarget.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ecbef321 | this.Load | FP00510_ChangeProdTypePopup.cs:247 | try | GRID_INIT | siTarget.ChangeActiveSheet | (SpdSheet.shtTarget) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00510_ChangeProdTypePopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-501b3ffc | popSql.OnSql | FP00510_ChangeProdTypePopup.cs:861 | if (programID == "PR_UI_FP00510_PRODTYPE_SELECT") | RETURN | return Find_Data_ProdType("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-1b10709f | popSql.OnSql | FP00510_ChangeProdTypePopup.cs:865 | else of (programID == "PR_UI_FP00510_PRODTYPE_SELECT") ▸ if (programID == "PR_UI_FP00510_PRODTYPE_SAVE") | RETURN | return Save_Data_ProdType("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-2c72c768 | popSql.OnSql | FP00510_ChangeProdTypePopup.cs:867 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00510_ChangeProdTypePopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e82f154a | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:542 | if (siTarget == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a43f09a | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:544 | if (siTarget.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ba2ec19e | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:549 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1994453c | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:550 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b4544050 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:553 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-ce1028f3 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:561 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-803c2cc0 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:565 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf6c554 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:571 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddfde19c | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:580 | try ▸ if (siTarget.SheetName == SpdSheet.shtTarget) ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb597d4a | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:584 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4f08ecb5 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:588 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f21b1591 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:589 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-30491209 | this.btnSave.Click 외 1 | FP00510_ChangeProdTypePopup.cs:593 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00510_ChangeProdTypePopup.Save_Data_ProdType

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_SELECT") ▸ if (programID == "PR_UI_FP00510_PRODTYPE_SAVE")] / this.btnSave.Click [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget)] / SaveButton [try ▸ if (siTarget.SheetName == SpdSheet.shtTarget)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdc4ebd7 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:670 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-d1a00279 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:674 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5033dd33 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:676 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-d862aafa | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:677 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-a25df35e | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:678 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-2d2472ba | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:679 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-abf7d923 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:680 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-9116c126 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:681 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-637116bf | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:682 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-38da5100 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:683 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-cd9f8e93 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:685 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shop_group_id"] | p_shop_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-2002de85 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:686 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-06a888ab | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:687 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_target_id"] | p_scp_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-a487b7e2 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:688 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ce8b009d | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:689 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-cfb86d37 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:690 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-4490a60c | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:691 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-1843a232 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:692 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-80de5fe3 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:693 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_market"] | p_org_market | 행/컬럼 값 대입 |  |  |  |
| AC-1a8f4f06 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:694 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_date"] | p_mfg_date | 행/컬럼 값 대입 |  |  |  |
| AC-70288f7f | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:695 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-325d2fb8 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:696 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_chg_qty"] | p_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-57db2b50 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:697 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-416050fe | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:698 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-075c0277 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:699 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_period_type"] | p_period_type | 행/컬럼 값 대입 |  |  |  |
| AC-dfae4d48 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:700 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-deb5d4da | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:701 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-8f032f45 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:703 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2b7e341 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:704 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-94826d67 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:711 | try ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "No rows checked.!" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b941df87 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:712 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d28bdea8 | popSql.OnSql [else of (programID == "PR_UI_FP00510_PRODTYPE_… 외 2 | FP00510_ChangeProdTypePopup.cs:718 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00510_ChangeProdTypePopup.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a61d3fc7 | SaveButton | FP00510_ChangeProdTypePopup.cs:378 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00510_ChangeProdTypePopup.SetSpreadInit

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f770500 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:261 | if (sheetName.Equals(SpdSheet.shtTarget)) | GRID_INIT | siObj.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76560849 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:262 | if (sheetName.Equals(SpdSheet.shtTarget)) | GRID_INIT | siObj.InitSheet | (0) | 그리드 재구성/초기화 |  |  |  |
| AC-77208a26 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:267 |  | GRID_INIT | siTarget.SetSheetHeaderColumn_FP | (siTarget, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-85b2454d | this.Load [try] | FP00510_ChangeProdTypePopup.cs:268 |  | GRID_INIT | siTarget.Freeze | (0, 7) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e5235bf4 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:270 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5ecc036b | this.Load [try] | FP00510_ChangeProdTypePopup.cs:271 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ede0fbe1 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:272 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-89e5ddb9 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:273 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.ORG_MARKET)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9cb589e9 | this.Load [try] | FP00510_ChangeProdTypePopup.cs:274 |  | GRID_SET | siTarget.ActiveSheet.Columns[siTarget.GetColumnIndex(DefColumns.EDIT_YN)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00510_ChangeProdTypePopup.spdTarget_CellClick

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cd6838d | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:808 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | true | 그리드 속성/값 설정 |  |  |  |
| AC-c626b6ab | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:813 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.ColumnHeader.Cells[e.Row, e.Column].Value | false | 그리드 속성/값 설정 |  |  |  |
| AC-124e6318 | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:821 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-dfe8dea3 | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:829 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | CALL_EXT | siTarget.ActiveSheet.RowFilter.IsRowFilteredOut | (iRow) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7bb06e8b | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:830 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, e.Column, bChk) | 그리드 값 설정 |  |  |  |
| AC-5b28604e | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:832 | if (siTarget.ActiveSheet.RowCount >= 1 && e.ColumnHeader && siTarget.IsLock(siTarget.SheetName) == false) ▸ if (siTarget.ActiveSheet.ColumnH… | GRID_SET | siTarget.ActiveSheet.SetValue | (iRow, e.Column, false) | 그리드 값 설정 |  |  |  |
| AC-1a84cb74 | (진입점 미연결) | FP00510_ChangeProdTypePopup.cs:848 |  | FLAG | iClick_Row | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00510_SCP_Target.btnChangeProd_Click

진입점: this.btnChangeProd.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c5ab2fa | this.btnChangeProd.Click | FP00510_SCP_Target.cs:967 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5c1decd0 | this.btnChangeProd.Click | FP00510_SCP_Target.cs:968 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fd1f228b | this.btnChangeProd.Click | FP00510_SCP_Target.cs:986 | try ▸ if (iClickRow < 0 \|\| siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-62426b34 | this.btnChangeProd.Click | FP00510_SCP_Target.cs:1002 | try | POPUP | new FP00510_ChangeProdTypePopup | ("FP00510", "SCPTargetChangeProdTypePopup", "FP_Master.PR_UI_FP00510_SCP_TARGET", sParamsF… | 팝업/폼 생성 |  |  |  |
| AC-6a793f9b | this.btnChangeProd.Click | FP00510_SCP_Target.cs:1003 | try | UI_PROP | popChangeType.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8312d99b | this.btnChangeProd.Click | FP00510_SCP_Target.cs:1004 | try | POPUP | popChangeType.Show | () | 팝업/폼 열기 |  |  |  |
| AC-eef9be1f | this.btnChangeProd.Click | FP00510_SCP_Target.cs:1009 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-a23a282a | this.btnChangeProd.Click | FP00510_SCP_Target.cs:1016 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00510_SCP_Target.btnImport_Click

진입점: this.btnImport.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d04ed4d2 | this.btnImport.Click | FP00510_SCP_Target.cs:1123 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 p_division_id = CString.GetCheckedListValue… | ⚠ 의미 확인 필요 |  |  |  |
| AC-cf1add43 | this.btnImport.Click | FP00510_SCP_Target.cs:1154 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-af6cc280 | this.btnImport.Click | FP00510_SCP_Target.cs:1158 | try | POPUP | new FPC0100_ExcelImportPopup | ("FPC0100", "SCPTargetImport", "FP_Master.PR_UI_FP00510_SCP_TARGET", sParamsFilter, sDbPar… | 팝업/폼 생성 |  |  |  |
| AC-19acf732 | this.btnImport.Click | FP00510_SCP_Target.cs:1159 | try | UI_PROP | popComImport.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f78f4681 | this.btnImport.Click | FP00510_SCP_Target.cs:1160 | try | POPUP | popComImport.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-217620c1 | this.btnImport.Click | FP00510_SCP_Target.cs:1171 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00510_SCP_Target.btnSplit_Click

진입점: this.btnSplit.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-581711f4 | this.btnSplit.Click | FP00510_SCP_Target.cs:1027 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0f092da1 | this.btnSplit.Click | FP00510_SCP_Target.cs:1028 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa4fb63a | this.btnSplit.Click | FP00510_SCP_Target.cs:1035 | if (iClickRow < 0 \|\| siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a26baab2 | this.btnSplit.Click | FP00510_SCP_Target.cs:1077 | try ▸ if (fc != null) | UI_MISC | fc.Close | () | 창 닫기/해제 |  |  |  |
| AC-795e5634 | this.btnSplit.Click | FP00510_SCP_Target.cs:1081 | try | POPUP | new FP00510_TargetBalancingPopup | ("FP00510", "", "FP_Master.PR_UI_FP00510_SCP_TARGET", sParamsFilter, sDbParamsName) | 팝업/폼 생성 |  |  |  |
| AC-dc81e54f | this.btnSplit.Click | FP00510_SCP_Target.cs:1082 | try | UI_PROP | popBalance.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-778c724d | this.btnSplit.Click | FP00510_SCP_Target.cs:1083 | try | UI_PROP | popBalance.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c9a1ad7c | this.btnSplit.Click | FP00510_SCP_Target.cs:1084 | try | POPUP | popBalance.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6fdace02 | this.btnSplit.Click | FP00510_SCP_Target.cs:1095 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00510_SCP_Target.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3814d508 | this.btnSql.Click | FP00510_SCP_Target.cs:951 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-da9b2fd0 | this.btnSql.Click | FP00510_SCP_Target.cs:952 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-36751231 | this.btnSql.Click | FP00510_SCP_Target.cs:954 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00510_SCP_TARGET_MAIN") | 데이터 객체 조작/조회 |  |  |  |
| AC-dea69d6f | this.btnSql.Click | FP00510_SCP_Target.cs:955 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00510_SCP_TARGET_SUB") | 데이터 객체 조작/조회 |  |  |  |
| AC-21b403e6 | this.btnSql.Click | FP00510_SCP_Target.cs:956 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00510_SCP_TARGET_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a0ca54d4 | this.btnSql.Click | FP00510_SCP_Target.cs:957 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00510_SCP_Target.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f50c1482 | this.Load | FP00510_SCP_Target.cs:324 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6486d626 | this.Load | FP00510_SCP_Target.cs:325 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-97150a3c | this.Load | FP00510_SCP_Target.cs:328 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSub, SpdSheet.shtSub, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-03fb99f4 | this.Load | FP00510_SCP_Target.cs:329 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSub) | 화면 필드/플래그 변경 |  |  |  |
| AC-682bbe33 | this.Load | FP00510_SCP_Target.cs:332 |  | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-203ce825 | this.Load | FP00510_SCP_Target.cs:336 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00510_SCP_Target.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8474f09c | this.Load | FP00510_SCP_Target.cs:151 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-900b4b2a | this.Load | FP00510_SCP_Target.cs:153 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-d9472656 | this.Load | FP00510_SCP_Target.cs:154 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-b7272223 | this.Load | FP00510_SCP_Target.cs:155 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## FP00510_SCP_Target.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b69baa1e | Dispose | FP00510_SCP_Target.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00510_SCP_Target.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89a5d3d6 | EditButton | FP00510_SCP_Target.cs:422 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f131a96 | EditButton | FP00510_SCP_Target.cs:426 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-3e84aaea | EditButton | FP00510_SCP_Target.cs:428 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-91f432be | EditButton | FP00510_SCP_Target.cs:430 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.COMPANY_ID), siMain.GetColumnIndex(DefColumns.CHG_QTY), … | 그리드 편집 잠금/해제 |  |  |  |
| AC-f4035297 | EditButton | FP00510_SCP_Target.cs:431 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PRIORITY), siMain.GetColumnIndex(DefColumns.PERIOD_TYPE)… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c8654fd9 | EditButton | FP00510_SCP_Target.cs:432 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LINE_ID), siMain.GetColumnIndex(DefColumns.LINE_NAME), t… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4993a80d | EditButton | FP00510_SCP_Target.cs:441 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) | GRID_SET | siMain.ActiveSheet.Rows[i, i].Locked | true | 그리드 속성/값 설정 |  |  |  |
| AC-a4046b68 | EditButton | FP00510_SCP_Target.cs:445 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ if (i % 2 == 1) | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |
| AC-1447797c | EditButton | FP00510_SCP_Target.cs:449 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sEditYN.Equals("N")) ▸ else of (i % 2 == … | GRID_SET | siMain.ActiveSheet.Rows[i].BackColor | ControlColor.LockColor | 그리드 속성/값 설정 |  |  |  |
| AC-5ae5837f | EditButton | FP00510_SCP_Target.cs:456 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-00c45dde | EditButton | FP00510_SCP_Target.cs:457 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ if (i % 2 == … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MARKET), i, siMain.GetColumnIndex(DefColumns.MARKET),… | 그리드 표시 설정 |  |  |  |
| AC-0f2eec00 | EditButton | FP00510_SCP_Target.cs:461 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), i, siMain.GetColumnIndex(DefColumns… | 그리드 표시 설정 |  |  |  |
| AC-4743f6e2 | EditButton | FP00510_SCP_Target.cs:462 | if (spdMain != null) ▸ if (siMain.GetMaxRowIndex() > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sEditYN.Equals("N")) ▸ else of (i % … | GRID_STYLE | siMain.SetBGColor | (i, siMain.GetColumnIndex(DefColumns.MARKET), i, siMain.GetColumnIndex(DefColumns.MARKET),… | 그리드 표시 설정 |  |  |  |

## FP00510_SCP_Target.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-425c8a49 | ExcelButton | FP00510_SCP_Target.cs:938 |  | EXCEL | ExportExcel2 | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00510_SCP_Target.Find_Data_Main

진입점: this.btnSplit.Click [try ▸ if (popBalance.DialogResult == DialogResult.OK) ▸ try ▸ lambda] / popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_MAIN")] / FindButton [try ▸ lambda] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") ▸ try ▸ lambda] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41f3899f | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:582 |  | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //콤보별 셋팅값 구하기 pDivisionID = CString.GetCheckedListValue(d… | ⚠ 의미 확인 필요 |  |  |  |
| AC-56678764 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:602 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00510_SCP_TARGET") ⇒ FP_Master.PR_UI_FP00510_SCP_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-28b871ec | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:603 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-4756e04c | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:604 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-fe8bccdc | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:605 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-84d17a8c | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:606 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c854f80e | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:608 | try | DATA_OP | request.Parameters["p_company_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-31229936 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:609 | try | DATA_OP | request.Parameters["p_division_id"] | pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-9ab50394 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:610 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-08e7720a | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:611 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-29f46694 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:612 | try | DATA_OP | request.Parameters["p_instance_id"] | pPlanGroup.Equals("ALL") ? DBNull.Value : pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-5fdd2bb6 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:613 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | pScpPlanID.Equals("ALL") ? DBNull.Value : pScpPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-6927153e | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:614 | try | DATA_OP | request.Parameters["p_scp_target_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bcf517f6 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:615 | try | DATA_OP | request.Parameters["p_shop_group_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ffa3bc6e | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:616 | try | DATA_OP | request.Parameters["p_item_id"] | pItemID.Equals("") ? DBNull.Value : pItemID | 행/컬럼 값 대입 |  |  |  |
| AC-826305f1 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:617 | try | DATA_OP | request.Parameters["p_nick_name"] | pNickName.Equals("") ? DBNull.Value : pNickName | 행/컬럼 값 대입 |  |  |  |
| AC-2fa31306 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:618 | try | DATA_OP | request.Parameters["p_mfg_week"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c8634041 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:619 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-e7d9302b | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:620 | try | DATA_OP | request.Parameters["p_org_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-5e22c3fe | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:621 | try | DATA_OP | request.Parameters["p_mfg_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4b29872b | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:622 | try | DATA_OP | request.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c61d71a2 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:623 | try | DATA_OP | request.Parameters["p_chg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ba25ea1a | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:624 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-b8ab5785 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:625 | try | DATA_OP | request.Parameters["p_priority"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8dd1178f | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:626 | try | DATA_OP | request.Parameters["p_period_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7203d184 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:627 | try | DATA_OP | request.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7a2e4a4c | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:628 | try | DATA_OP | request.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8c0139a3 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:630 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f1a7741 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:632 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-6355fb86 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:637 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-e8ca9a9a | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 4 | FP00510_SCP_Target.cs:641 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00510_SCP_Target.Find_Data_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Row >= 0) ▸ try] / popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") ▸ if (programID == "PR_UI_FP00510_SCP_TARGET_SUB") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (siMain.GetMaxRowIndex() >0 && iClickRow > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa540dd0 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:710 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00510_SCP_TARGET") ⇒ FP_Master.PR_UI_FP00510_SCP_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-242e12f6 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:711 | try | DATA_OP | request.Parameters["p_sys_type"] | pSysType | 행/컬럼 값 대입 |  |  |  |
| AC-bf7d9fd1 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:712 | try | DATA_OP | request.Parameters["p_sys_flag"] | "SELECT_SUB" | 행/컬럼 값 대입 |  |  |  |
| AC-696d66e7 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:713 | try | DATA_OP | request.Parameters["p_sys_gubun"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-1ab46191 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:714 | try | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-54682de9 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:716 | try | DATA_OP | request.Parameters["p_company_id"] | pCompany | 행/컬럼 값 대입 |  |  |  |
| AC-19594ead | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:717 | try | DATA_OP | request.Parameters["p_division_id"] | pDivision | 행/컬럼 값 대입 |  |  |  |
| AC-dcff3d37 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:718 | try | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-4cd5c2d4 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:719 | try | DATA_OP | request.Parameters["p_plant_id"] | pPlant | 행/컬럼 값 대입 |  |  |  |
| AC-b0d2c1c9 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:720 | try | DATA_OP | request.Parameters["p_instance_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-8b931458 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:721 | try | DATA_OP | request.Parameters["p_shop_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-c5bb52fc | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:722 | try | DATA_OP | request.Parameters["p_scp_plan_id"] | pScpPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-e341edb0 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:723 | try | DATA_OP | request.Parameters["p_scp_target_id"] | pScpTargetID | 행/컬럼 값 대입 |  |  |  |
| AC-5d49f767 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:724 | try | DATA_OP | request.Parameters["p_item_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-53fa6398 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:725 | try | DATA_OP | request.Parameters["p_nick_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-24504d68 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:726 | try | DATA_OP | request.Parameters["p_mfg_week"] | pScpWeek | 행/컬럼 값 대입 |  |  |  |
| AC-ef5ff39b | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:727 | try | DATA_OP | request.Parameters["p_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-55aa5865 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:728 | try | DATA_OP | request.Parameters["p_org_market"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-7c5f5328 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:729 | try | DATA_OP | request.Parameters["p_mfg_date"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-bc9b934f | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:730 | try | DATA_OP | request.Parameters["p_mfg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-9298d8ab | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:731 | try | DATA_OP | request.Parameters["p_chg_qty"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-f082caa6 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:732 | try | DATA_OP | request.Parameters["p_production_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-76fe003a | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:733 | try | DATA_OP | request.Parameters["p_priority"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-ece8216e | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:734 | try | DATA_OP | request.Parameters["p_period_type"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3c9aacb0 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:735 | try | DATA_OP | request.Parameters["p_line_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-25a51697 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:736 | try | DATA_OP | request.Parameters["p_line_name"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3b467aec | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:738 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-52d3a8aa | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:740 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a573e96d | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… 외 1 | FP00510_SCP_Target.cs:745 | catch ((Exception e)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00510_SCP_Target.FindData_Main

진입점: this.btnSplit.Click [try ▸ if (popBalance.DialogResult == DialogResult.OK)] / FindButton / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS")] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-873ad094 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:494 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ca3c7a3d | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:499 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f19ee30a | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:500 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-48ff7783 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:503 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-94a2adc6 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:506 | try | CALL_EXT | spdMain.GetViewportTopRow | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1dd6aac | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:509 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-dc0c514f | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:509 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-102d9b8d | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:515 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-99f80ad5 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:518 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13c18f55 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:524 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-08611a39 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:525 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Main("SELECT") ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-50e595a9 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:536 | try ▸ if (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f8f5649e | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:538 | try ▸ if (ds != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fa4dd15e | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:541 | try ▸ if (ds != null) | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4e10a63c | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:544 | try ▸ if (ds != null) | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cc7fe4f6 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:552 | try ▸ if (ds != null) | GRID_STYLE | spdMain.SetViewportTopRow | (0, iTopRow) | 그리드 표시 설정 |  |  |  |
| AC-de0b9f72 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:556 | try ▸ else of (ds != null) | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-7d47a969 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:557 | try ▸ else of (ds != null) | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-996288d0 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:564 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2d730da3 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:565 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-78dede6c | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:567 | finally | GRID_SET | this.spdMain.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d9d349f9 | this.btnSplit.Click [try ▸ if (popBalance.DialogResult == Di… 외 3 | FP00510_SCP_Target.cs:567 | finally | CALL_EXT | this.spdMain.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00510_SCP_Target.FindData_Sub

진입점: this.spdMain.CellDoubleClick [if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2046939 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:648 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-184165ed | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:653 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-06b8c1f5 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:653 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3ddc060 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:662 | try | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72912c3e | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:673 | try | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9b0f1198 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:678 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siSub.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c118307e | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:683 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-da2d1e11 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:686 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b3fb2cfd | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:699 | finally | GRID_SET | this.spdSub.ActiveSheet.Columns.Get(0).Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f2b50eb5 | this.spdMain.CellDoubleClick [if (siMain != null && siMain.I… | FP00510_SCP_Target.cs:699 | finally | CALL_EXT | this.spdSub.ActiveSheet.Columns.Get | (0) | ⚠ 의미 확인 필요 |  |  |  |

## FP00510_SCP_Target.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-326766dc | this.Load | FP00510_SCP_Target.cs:125 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00510_SCP_Target.GetOrderType

진입점: this.Load [try] / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94745ec8 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:247 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-225aec1b | this.Load [try] 외 1 | FP00510_SCP_Target.cs:252 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-95f96c11 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:257 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-4efc680e | this.Load [try] 외 1 | FP00510_SCP_Target.cs:262 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-47fb4110 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:266 | try | FLAG | dtOrderType | Data_FP.Common_FP(Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-33a96434 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:266 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION_DEMAND_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSa… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION_DEMAND_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8ab3dd6c | this.Load [try] 외 1 | FP00510_SCP_Target.cs:267 | try | LIST_REBIND | clsCtrl.setListBox | (dtOrderType, cboOrderType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00510_SCP_Target.GetPlanGroup

진입점: this.Load [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35ab6492 | this.Load [try] | FP00510_SCP_Target.cs:1390 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-897fa935 | this.Load [try] | FP00510_SCP_Target.cs:1391 |  | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0b05e266 | this.Load [try] | FP00510_SCP_Target.cs:1391 |  | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-683d9c80 | this.Load [try] | FP00510_SCP_Target.cs:1393 | if (!dtInstance.Good()) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |
| AC-75dec56a | this.Load [try] | FP00510_SCP_Target.cs:1394 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboPlanGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f15e144a | this.Load [try] | FP00510_SCP_Target.cs:1397 | if (cboPlanGroup.Items.Count > 0) | VALUE_SET | cboPlanGroup.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-347db4b1 | this.Load [try] | FP00510_SCP_Target.cs:1398 | if (cboPlanGroup.Items.Count > 0) | DATA_OP | Filter["MASTER_ID"] | Filter["INSTANCE_ID"] = CString.GetCheckedListValue(dtInstance, cboPlanGroup.ControlValues… | 행/컬럼 값 대입 |  |  |  |
| AC-a70ce2cf | this.Load [try] | FP00510_SCP_Target.cs:1398 | if (cboPlanGroup.Items.Count > 0) | DATA_OP | Filter["INSTANCE_ID"] | CString.GetCheckedListValue(dtInstance, cboPlanGroup.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-baf27e6d | this.Load [try] | FP00510_SCP_Target.cs:1399 | if (cboPlanGroup.Items.Count > 0) | DATA_OP | Filter["USE_WOW_STATUS"] | dtInstance.Rows[cboPlanGroup.SelectedIndex]["USE_WOW_STATUS"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-587fc7ce | this.Load [try] | FP00510_SCP_Target.cs:1400 | if (cboPlanGroup.Items.Count > 0) | DATA_OP | Filter["CONFIRM_AREA"] | dtInstance.Rows[cboPlanGroup.SelectedIndex]["CONFIRM_AREA"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e7039671 | this.Load [try] | FP00510_SCP_Target.cs:1401 | if (cboPlanGroup.Items.Count > 0) | DATA_OP | Filter["IS_SAME_PLAN_ID"] | dtInstance.Rows[cboPlanGroup.SelectedIndex]["IS_SAME_PLAN_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b20839b5 | this.Load [try] | FP00510_SCP_Target.cs:1405 | else of (cboPlanGroup.Items.Count > 0) | THROW | throw new Exception("Cannot find Plan Group. Plan Group is required"); |  | 예외 발생 |  |  |  |

## FP00510_SCP_Target.GetScpPlantID

진입점: this.Load [try] / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1d78962 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:292 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-5620fca4 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:297 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-f473c0cb | this.Load [try] 외 1 | FP00510_SCP_Target.cs:302 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-786cd8ad | this.Load [try] 외 1 | FP00510_SCP_Target.cs:307 | try | DATA_OP | sDataID.Contains | (",") | 데이터 객체 조작/조회 |  |  |  |
| AC-e65c9697 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:311 | try | FLAG | dtScpPlanID | Data_FP.Common_FP(Data_FP.Type.SCP_PLAN, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | 화면 필드/플래그 변경 |  |  |  |
| AC-e84f0017 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:311 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SCP_PLAN, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth , pIn… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SCP_PLAN] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2f1e4bd8 | this.Load [try] 외 1 | FP00510_SCP_Target.cs:315 | try | LIST_REBIND | clsCtrl.setListBox | (dtScpPlanID, cboScpPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00510_SCP_Target.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37cda369 | this.Load | FP00510_SCP_Target.cs:165 | try | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6922604f | this.Load | FP00510_SCP_Target.cs:171 | try | FLAG | _sNonAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-7c8d9914 | this.Load | FP00510_SCP_Target.cs:172 | try | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-df4845be | this.Load | FP00510_SCP_Target.cs:177 | try ▸ if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "N" | 화면 필드/플래그 변경 |  |  |  |
| AC-e3d2f822 | this.Load | FP00510_SCP_Target.cs:179 | try ▸ if (this.ViewModel != null) ▸ else of (!ViewModel.SecurityContext.CanSave) | FLAG | _sSaveAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-d7d5ff79 | this.Load | FP00510_SCP_Target.cs:193 | try | FLAG | dtProductionType | Data_FP.Common_FP(Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd15fa18 | this.Load | FP00510_SCP_Target.cs:193 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.LOOKUP_CODE_TARGET, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=LOOKUP_CODE_TARGET] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf4e5f72 | this.Load | FP00510_SCP_Target.cs:196 | try | FLAG | dtYesOrNo | Data_FP.Common_FP(Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 화면 필드/플래그 변경 |  |  |  |
| AC-dfc48085 | this.Load | FP00510_SCP_Target.cs:196 | try | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.YesNo) ⇒ biz:FPCommonDataBLL.YesNo | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf77898b | this.Load | FP00510_SCP_Target.cs:202 | try ▸ if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-f7af2143 | this.Load | FP00510_SCP_Target.cs:203 | try ▸ if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-48823a7b | this.Load | FP00510_SCP_Target.cs:204 | try ▸ if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-71ba6201 | this.Load | FP00510_SCP_Target.cs:209 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-68452d16 | this.Load | FP00510_SCP_Target.cs:210 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnImport.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-647ce842 | this.Load | FP00510_SCP_Target.cs:211 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblExcelImport.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-aae5d194 | this.Load | FP00510_SCP_Target.cs:213 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnChangeProd.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-99800e20 | this.Load | FP00510_SCP_Target.cs:214 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnChangeProd.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-c4e68543 | this.Load | FP00510_SCP_Target.cs:215 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblChgProdType.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-bbb25043 | this.Load | FP00510_SCP_Target.cs:217 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnSplit.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-04a798dd | this.Load | FP00510_SCP_Target.cs:218 | try ▸ if (!_sSaveAuth.Equals("Y")) | STATE | btnSplit.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-1ef2b084 | this.Load | FP00510_SCP_Target.cs:219 | try ▸ if (!_sSaveAuth.Equals("Y")) | UI_PROP | lblSplit.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1363a323 | this.Load | FP00510_SCP_Target.cs:225 | catch ((Exception ex)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00510_SCP_Target.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49a6fca4 | this.Load | FP00510_SCP_Target.cs:141 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00510_SCP_Target.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-72960cbd | this.Load | FP00510_SCP_Target.cs:343 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-086e74f2 | this.Load | FP00510_SCP_Target.cs:346 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2d651271 | this.Load | FP00510_SCP_Target.cs:348 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.MFG_QTY), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5babee86 | this.Load | FP00510_SCP_Target.cs:349 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetReNumerCellType | (spreadInfo, spreadInfo.GetColumnIndex(DefColumns.CHG_QTY), 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e227af99 | this.Load | FP00510_SCP_Target.cs:351 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLANT_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a4a77d19 | this.Load | FP00510_SCP_Target.cs:354 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ab6a4b99 | this.Load | FP00510_SCP_Target.cs:355 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.ORG_MARKET)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e5ddedc0 | this.Load | FP00510_SCP_Target.cs:356 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefColumns.OPERATION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5b36d6c8 | this.Load | FP00510_SCP_Target.cs:360 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-64e2849a | this.Load | FP00510_SCP_Target.cs:363 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | spreadInfo.SetSheetHeaderColumn_FP | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-dac5e7d8 | this.Load | FP00510_SCP_Target.cs:365 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_INIT | siSub.Freeze | (0, siSub.GetColumnIndex(DefColumns.SCP_TARGET_ID)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-375b52ae | this.Load | FP00510_SCP_Target.cs:368 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.COMPANY_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f37904d1 | this.Load | FP00510_SCP_Target.cs:369 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.DIVISION_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-47060358 | this.Load | FP00510_SCP_Target.cs:370 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SITE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c2a38b1c | this.Load | FP00510_SCP_Target.cs:371 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0a200e78 | this.Load | FP00510_SCP_Target.cs:372 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.TO_PLANT_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1adb7633 | this.Load | FP00510_SCP_Target.cs:373 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.MESSAGE_ID)].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-54bc69c7 | this.Load | FP00510_SCP_Target.cs:374 | else of (spreadInfo.SheetName == SpdSheet.shtMain) ▸ if (spreadInfo.SheetName == SpdSheet.shtSub) | GRID_SET | siSub.ActiveSheet.Columns[siSub.GetColumnIndex(DefColumns.SEQ)].Visible | false | 그리드 속성/값 설정 |  |  |  |

## FP00510_SCP_Target.OnShown

진입점: OnShown

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c441335d | OnShown | FP00510_SCP_Target.cs:1289 | try | VALUE_SET | cboScpPlanID.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## FP00510_SCP_Target.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff88888d | popSql.OnSql | FP00510_SCP_Target.cs:1327 | if (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") | RETURN | return Find_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-ad0e056a | popSql.OnSql | FP00510_SCP_Target.cs:1345 | else of (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") ▸ if (programID == "PR_UI_FP00510_SCP_TARGET_SUB") ▸ if (siMain != null && siMain.IsL… | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5bb86fc | popSql.OnSql | FP00510_SCP_Target.cs:1346 | else of (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") ▸ if (programID == "PR_UI_FP00510_SCP_TARGET_SUB") ▸ if (siMain != null && siMain.IsL… | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-143a7b65 | popSql.OnSql | FP00510_SCP_Target.cs:1348 | else of (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") ▸ if (programID == "PR_UI_FP00510_SCP_TARGET_SUB") ▸ if (siMain != null && siMain.IsL… | RETURN | return Find_Data_Sub("SQL", sCompany, sDivision, sSite, sPlant, sPlanGroup, sScp… |  | 처리 중단/반환 |  |  |  |
| AC-d2fdb801 | popSql.OnSql | FP00510_SCP_Target.cs:1354 | else of (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") ▸ else of (programID == "PR_UI_FP00510_SCP_TARGET_SUB") ▸ if (programID == "PR_UI_FP0… | RETURN | return Save_Data_Main("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-b7a572cd | popSql.OnSql | FP00510_SCP_Target.cs:1356 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00510_SCP_Target.Save_Data

진입점: SaveButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c7038f6 | SaveButton 외 1 | FP00510_SCP_Target.cs:752 |  | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-e8b7f106 | SaveButton 외 1 | FP00510_SCP_Target.cs:752 | if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-763443a2 | SaveButton 외 1 | FP00510_SCP_Target.cs:754 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3113e680 | SaveButton 외 1 | FP00510_SCP_Target.cs:756 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2a46b44c | SaveButton 외 1 | FP00510_SCP_Target.cs:761 | if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c164997c | SaveButton 외 1 | FP00510_SCP_Target.cs:762 | if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ffbc119a | SaveButton 외 1 | FP00510_SCP_Target.cs:765 |  | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-d0d9439b | SaveButton 외 1 | FP00510_SCP_Target.cs:772 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-202a099e | SaveButton 외 1 | FP00510_SCP_Target.cs:774 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-88237e40 | SaveButton 외 1 | FP00510_SCP_Target.cs:775 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2340de6 | SaveButton 외 1 | FP00510_SCP_Target.cs:780 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-faf0235f | SaveButton 외 1 | FP00510_SCP_Target.cs:785 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f559380 | SaveButton 외 1 | FP00510_SCP_Target.cs:794 | try ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-953bbedb | SaveButton 외 1 | FP00510_SCP_Target.cs:798 | try | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4c34b9f3 | SaveButton 외 1 | FP00510_SCP_Target.cs:802 | catch ((Exception ex)) | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-a2b4498b | SaveButton 외 1 | FP00510_SCP_Target.cs:803 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb00582d | SaveButton 외 1 | FP00510_SCP_Target.cs:808 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |
| AC-dfc7ce4d | SaveButton 외 1 | FP00510_SCP_Target.cs:809 | finally | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |

## FP00510_SCP_Target.Save_Data_Main

진입점: popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGET_MAIN") ▸ else of (programID == "PR_UI_FP00510_SCP_TARGET_SUB") ▸ if (programID == "PR_UI_FP00510_SCP_TARGET_SAVE")] / SaveButton [try ▸ if (siMain.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da5bd535 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:887 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00510_SCP_TARGET") ⇒ FP_Master.PR_UI_FP00510_SCP_TARGET | 엔드포인트 요청 생성 |  |  |  |
| AC-f742efd7 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:888 | try ▸ if (iCount > 0) | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-56dfff7d | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:890 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-6c340aec | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:891 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_flag"] | p_sys_flag | 행/컬럼 값 대입 |  |  |  |
| AC-f7a0a0e2 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:892 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_sys_gubun"] | p_sys_gubun | 행/컬럼 값 대입 |  |  |  |
| AC-36f9621b | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:893 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-21ceaf31 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:894 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-63ef0d85 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:895 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-700ba1f4 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:896 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-577174f5 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:897 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9b24a8b8 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:898 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-803c017e | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:900 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_shop_group_id"] | p_shop_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-142fd835 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:901 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-eafeef07 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:902 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_scp_target_id"] | p_scp_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-679cb8d8 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:903 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f7bf3d74 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:904 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-bbf1994e | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:905 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-dbcff58a | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:906 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-5be6d9fd | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:907 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_org_market"] | p_org_market | 행/컬럼 값 대입 |  |  |  |
| AC-f20cacce | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:908 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_date"] | p_mfg_date | 행/컬럼 값 대입 |  |  |  |
| AC-43f65248 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:909 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-bd18f6ac | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:910 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_chg_qty"] | p_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-ce7d7bdf | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:911 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-56ec23db | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:912 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-1008d904 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:913 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_period_type"] | p_period_type | 행/컬럼 값 대입 |  |  |  |
| AC-7e4e1b7c | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:914 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-a62f9c10 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:915 | try ▸ if (iCount > 0) | DATA_OP | req.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-5ed44053 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:918 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e819afe | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:919 | try ▸ if (iCount > 0) | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-11b9509c | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:925 | try ▸ else of (iCount > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-d293e1c1 | popSql.OnSql [else of (programID == "PR_UI_FP00510_SCP_TARGE… 외 2 | FP00510_SCP_Target.cs:931 | catch ((Exception ex)) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00510_SCP_Target.SelectCombo

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cd8484b | (진입점 미연결) | FP00510_SCP_Target.cs:1314 | if (iIdx >= 0) | VALUE_SET | cCombo.SelectedIndex | iIdx | 컨트롤 값 설정 |  |  |  |

## FP00510_SCP_Target.SetChangeControl

진입점: this.Load [try] / cboPlanGroup.SelectedIndexChanged / cboDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c1b9198 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1415 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-1c667dd0 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1415 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ece4863d | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1420 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["INSTANCE_ID"] | Filter["MASTER_ID"] = sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-0f30c725 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1420 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | DATA_OP | Filter["MASTER_ID"] | sInstance_id | 행/컬럼 값 대입 |  |  |  |
| AC-c8f32e54 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1424 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-a91e491a | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1424 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d816e8e7 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1427 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ if ((object)cboDivision is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)cboDivision as UsrCombo , true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-cf98aafc | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1429 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ else of ((object)cboDivision is UsrCombo) ▸ if ((object)cboD… | LIST_REBIND | clsCtrl.setListBox | (dtDivision, (object)cboDivision as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-32fd70cd | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1431 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) ▸ if (cboDivision.Items.Count > 1) | VALUE_SET | cboDivision.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-d40d0248 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1437 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | FLAG | dtDivision | DataService.GetInnerTable("DIVISION_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-3525175a | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1437 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (!dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("DIVISION_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ef25cc71 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1446 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0774df8 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1446 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-e7a81fe1 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1448 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ if ((object)cboSite is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3e7239df | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1450 | switch (triggerControl) case DefColumns.DIVISION_ID: ▸ if (dtDivision.Good()) ▸ else of ((object)cboSite is UsrCombo) ▸ if ((object)cboSite … | LIST_REBIND | clsCtrl.setListBox | (dtSite, (object)cboSite as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d931f709 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1457 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["SITE_ID"] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-26b9f827 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1458 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c3c0806a | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1458 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ca2ab496 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1460 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ if ((object)clbPlant is UsrCombo) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCombo, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8da09c03 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1462 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) ▸ else of ((object)clbPlant is UsrCombo) ▸ if ((object)clbPlant is Usr… | LIST_REBIND | clsCtrl.setListBox | (dtPlant, (object)clbPlant as UsrCheckedList2, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-88d7c0f8 | this.Load [try] 외 4 | FP00510_SCP_Target.cs:1468 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00510_SCP_Target.SetCheckRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56280294 | (진입점 미연결) | FP00510_SCP_Target.cs:1370 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (sCheckYn == "Y") | GRID_SET | siMain.ActiveSheet.Rows[iRow].BackColor | Color.FromArgb(80, bkColor) | 그리드 속성/값 설정 |  |  |  |

## FP00510_SCP_Target.SetFilter

진입점: this.Load [try ▸ switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboPlanGroup.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboDivision.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / clbPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e034a680 | this.Load [try ▸ switch (triggerControl) case DefColumns.INS… 외 4 | FP00510_SCP_Target.cs:1385 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00510_SCP_Target.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a30e4811 | this.spdMain.CellClick | FP00510_SCP_Target.cs:1203 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-22586fe9 | this.spdMain.CellClick | FP00510_SCP_Target.cs:1204 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8fcd3f73 | this.spdMain.CellClick | FP00510_SCP_Target.cs:1222 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visib…) ▸ if (e.Colum… | DATA_OP | dtResult.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f7ca7fb | this.spdMain.CellClick | FP00510_SCP_Target.cs:1223 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visib…) ▸ if (e.Colum… | DATA_OP | dtResult.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-68ce86bc | this.spdMain.CellClick | FP00510_SCP_Target.cs:1227 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visib…) ▸ if (e.Colum… | DATA_OP | dRow.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d812d402 | this.spdMain.CellClick | FP00510_SCP_Target.cs:1232 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visib…) ▸ if (e.Colum… | DATA_OP | dtResult.Rows.Add | (row.col1.ToString(), row.col2.ToString()) | 데이터 객체 조작/조회 |  |  |  |
| AC-741eaa6b | this.spdMain.CellClick | FP00510_SCP_Target.cs:1236 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false && siMain.ActiveSheet.Columns[CAppSetting.StringAction].Visib…) ▸ if (e.Colum… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.PRODUCTION_TYPE), dtResult) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-03cfc8ce | this.spdMain.CellClick | FP00510_SCP_Target.cs:1242 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00510_SCP_Target.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b1907b2 | this.spdMain.CellDoubleClick | FP00510_SCP_Target.cs:1249 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | FLAG | iClickRow | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-faedbc7f | this.spdMain.CellDoubleClick | FP00510_SCP_Target.cs:1250 | if (siMain.Sheet().Rows.Count <= 0 \|\| e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f50e6de | this.spdMain.CellDoubleClick | FP00510_SCP_Target.cs:1266 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Row >= 0) | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSub) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0a0555d | this.spdMain.CellDoubleClick | FP00510_SCP_Target.cs:1267 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Row >= 0) | GRID_INIT | siSub.ChangeActiveSheet | (SpdSheet.shtSub) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6ac27769 | this.spdMain.CellDoubleClick | FP00510_SCP_Target.cs:1271 | if (siMain != null && siMain.IsLock(siMain.SheetName) == true) ▸ if (e.Row >= 0) | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-679deb14 | this.spdMain.CellDoubleClick | FP00510_SCP_Target.cs:1275 |  | FLAG | iClickRow | e.Row | 화면 필드/플래그 변경 |  |  |  |

## FP00510_TargetBalancingPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aceea20c | .ctor | FP00510_TargetBalancingPopup.cs:91 |  | FLAG | this.sSheetName | pSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-b9be1479 | .ctor | FP00510_TargetBalancingPopup.cs:92 |  | FLAG | this.sProgramId | pProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-83fd519e | .ctor | FP00510_TargetBalancingPopup.cs:93 |  | FLAG | this.sServiceCallName | pServiceCallName | 화면 필드/플래그 변경 |  |  |  |
| AC-254b050d | .ctor | FP00510_TargetBalancingPopup.cs:94 |  | FLAG | this.sParamsFilter | pParamsFilter | 화면 필드/플래그 변경 |  |  |  |
| AC-cdbf9fd1 | .ctor | FP00510_TargetBalancingPopup.cs:95 |  | FLAG | this.sDbParamsList | pDbParamsList | 화면 필드/플래그 변경 |  |  |  |
| AC-073fb9ec | .ctor | FP00510_TargetBalancingPopup.cs:99 | if (string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCallName)) | MESSAGE | MessageBox.Show | ("The ProgramID/ProcedureName[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBo… | 메시지 표시 |  |  |  |
| AC-cb4add4d | .ctor | FP00510_TargetBalancingPopup.cs:100 | if (string.IsNullOrEmpty(this.sProgramId) \|\| string.IsNullOrEmpty(this.sServiceCallName)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-4b746bfe | .ctor | FP00510_TargetBalancingPopup.cs:104 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | MESSAGE | MessageBox.Show | ("the Filter/DB List[Parameters] is Null!", "FP", MessageBoxButtons.OK, MessageBoxIcon.Err… | 메시지 표시 |  |  |  |
| AC-b841be77 | .ctor | FP00510_TargetBalancingPopup.cs:105 | if (string.IsNullOrEmpty(this.sParamsFilter) \|\| string.IsNullOrEmpty(this.sDbParamsList)) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-7ae8bdc1 | .ctor | FP00510_TargetBalancingPopup.cs:112 |  | FLAG | iDbParmsCount | arrDbList.Length | 화면 필드/플래그 변경 |  |  |  |
| AC-273b757d | .ctor | FP00510_TargetBalancingPopup.cs:114 |  | UI_PROP | structParam._sParamFilter | new string[iDbParmsCount] | 속성 _sParamFilter 설정 |  |  |  |
| AC-6dc21282 | .ctor | FP00510_TargetBalancingPopup.cs:115 |  | UI_PROP | structParam._sDbParamsList | new string[iDbParmsCount] | 속성 _sDbParamsList 설정 |  |  |  |
| AC-d73bc692 | .ctor | FP00510_TargetBalancingPopup.cs:119 | for (i < iDbParmsCount) | DATA_OP | structParam._sParamFilter[i] | arrFilter[i] | 행/컬럼 값 대입 |  |  |  |
| AC-9bebc7e6 | .ctor | FP00510_TargetBalancingPopup.cs:120 | for (i < iDbParmsCount) | DATA_OP | structParam._sDbParamsList[i] | arrDbList[i] | 행/컬럼 값 대입 |  |  |  |

## FP00510_TargetBalancingPopup.btnClose_Click

진입점: this.btnClose.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cda4a17 | this.btnClose.Click | FP00510_TargetBalancingPopup.cs:220 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## FP00510_TargetBalancingPopup.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-60da2418 | this.btnSql.Click | FP00510_TargetBalancingPopup.cs:233 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-b80a3f9a | this.btnSql.Click | FP00510_TargetBalancingPopup.cs:234 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0ed46e07 | this.btnSql.Click | FP00510_TargetBalancingPopup.cs:236 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP00510_SCP_TARGET_SAVE") | 데이터 객체 조작/조회 |  |  |  |
| AC-30e1302b | this.btnSql.Click | FP00510_TargetBalancingPopup.cs:237 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00510_TargetBalancingPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b177ecf5 | Dispose | FP00510_TargetBalancingPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00510_TargetBalancingPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3b2db2b | this.Load | FP00510_TargetBalancingPopup.cs:131 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d05af1fd | this.Load | FP00510_TargetBalancingPopup.cs:133 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00510_TargetBalancingPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c127f515 | this.Load | FP00510_TargetBalancingPopup.cs:148 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-838e8fab | this.Load | FP00510_TargetBalancingPopup.cs:155 |  | FLAG | pCompany | structParam._sParamFilter[0].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-106aed14 | this.Load | FP00510_TargetBalancingPopup.cs:156 |  | FLAG | pDivision | structParam._sParamFilter[1].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-fe96d15b | this.Load | FP00510_TargetBalancingPopup.cs:157 |  | FLAG | pSite | structParam._sParamFilter[2].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-2118e64c | this.Load | FP00510_TargetBalancingPopup.cs:158 |  | FLAG | pPlant | structParam._sParamFilter[3].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-836fb07e | this.Load | FP00510_TargetBalancingPopup.cs:159 |  | FLAG | pPlanGroup | structParam._sParamFilter[4].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-14b0ee2d | this.Load | FP00510_TargetBalancingPopup.cs:160 |  | FLAG | pScpPlan | structParam._sParamFilter[5].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-55d51aad | this.Load | FP00510_TargetBalancingPopup.cs:161 |  | FLAG | pScpTarget | structParam._sParamFilter[6].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-8a4c2259 | this.Load | FP00510_TargetBalancingPopup.cs:162 |  | FLAG | pShopGroup | structParam._sParamFilter[7].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1017d286 | this.Load | FP00510_TargetBalancingPopup.cs:163 |  | FLAG | pItem | structParam._sParamFilter[8].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-a9c895d0 | this.Load | FP00510_TargetBalancingPopup.cs:164 |  | FLAG | pNickName | structParam._sParamFilter[9].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e9bac486 | this.Load | FP00510_TargetBalancingPopup.cs:165 |  | FLAG | pMfgWeek | structParam._sParamFilter[10].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e0b189e9 | this.Load | FP00510_TargetBalancingPopup.cs:166 |  | FLAG | pMarket | structParam._sParamFilter[11].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-0f7d78bf | this.Load | FP00510_TargetBalancingPopup.cs:167 |  | FLAG | pOrgMarket | structParam._sParamFilter[12].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9445e735 | this.Load | FP00510_TargetBalancingPopup.cs:168 |  | FLAG | pMfgDate | structParam._sParamFilter[13].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-21af397f | this.Load | FP00510_TargetBalancingPopup.cs:169 |  | FLAG | pScpQty | structParam._sParamFilter[14].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-e7f65cc5 | this.Load | FP00510_TargetBalancingPopup.cs:170 |  | FLAG | pChgQty | structParam._sParamFilter[15].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-1d9c086c | this.Load | FP00510_TargetBalancingPopup.cs:171 |  | FLAG | pProductionType | structParam._sParamFilter[16].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-98381aa4 | this.Load | FP00510_TargetBalancingPopup.cs:172 |  | FLAG | pPriority | structParam._sParamFilter[17].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-4921002c | this.Load | FP00510_TargetBalancingPopup.cs:173 |  | FLAG | pPeriodType | structParam._sParamFilter[18].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-880e7dc2 | this.Load | FP00510_TargetBalancingPopup.cs:174 |  | FLAG | pLine | structParam._sParamFilter[19].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-9ecde18d | this.Load | FP00510_TargetBalancingPopup.cs:175 |  | FLAG | pOperation | structParam._sParamFilter[21].ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-c014f46a | this.Load | FP00510_TargetBalancingPopup.cs:177 |  | VALUE_SET | txtDivision.Text | pDivision | 컨트롤 값 설정 |  |  |  |
| AC-327753ff | this.Load | FP00510_TargetBalancingPopup.cs:178 |  | VALUE_SET | txtSite.Text | pSite | 컨트롤 값 설정 |  |  |  |
| AC-7ffc0bc6 | this.Load | FP00510_TargetBalancingPopup.cs:179 |  | VALUE_SET | txtPlant.Text | pPlant | 컨트롤 값 설정 |  |  |  |
| AC-89c7126e | this.Load | FP00510_TargetBalancingPopup.cs:180 |  | VALUE_SET | txtShopGroup.Text | pShopGroup | 컨트롤 값 설정 |  |  |  |
| AC-67ad10d0 | this.Load | FP00510_TargetBalancingPopup.cs:181 |  | VALUE_SET | txtItem.Text | pItem | 컨트롤 값 설정 |  |  |  |
| AC-5fb9b44d | this.Load | FP00510_TargetBalancingPopup.cs:182 |  | VALUE_SET | txtScpPlan.Text | pScpPlan | 컨트롤 값 설정 |  |  |  |
| AC-d43c1042 | this.Load | FP00510_TargetBalancingPopup.cs:183 |  | VALUE_SET | txtScpTarget.Text | pScpTarget | 컨트롤 값 설정 |  |  |  |
| AC-2eb4009d | this.Load | FP00510_TargetBalancingPopup.cs:184 | if (string.IsNullOrEmpty(pScpQty)) | FLAG | pScpQty | "0" | 화면 필드/플래그 변경 |  |  |  |
| AC-89f16716 | this.Load | FP00510_TargetBalancingPopup.cs:185 |  | VALUE_SET | txtQty.Text | String.Format("{0:#,0}", Convert.ToDouble(pScpQty)) | 컨트롤 값 설정 |  |  |  |
| AC-f26286d2 | this.Load | FP00510_TargetBalancingPopup.cs:186 |  | VALUE_SET | txtOrgQty.Text | String.Format("{0:#,0}", Convert.ToDouble(pScpQty)) | 컨트롤 값 설정 |  |  |  |
| AC-7ca750b9 | this.Load | FP00510_TargetBalancingPopup.cs:188 |  | UI_PROP | lblOrgQty.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-9574a237 | this.Load | FP00510_TargetBalancingPopup.cs:190 |  | VALUE_SET | txtQtySplit.Text | "0" | 컨트롤 값 설정 |  |  |  |
| AC-8af011f4 | this.Load | FP00510_TargetBalancingPopup.cs:191 |  | VALUE_SET | txtMarket.Text | pMarket | 컨트롤 값 설정 |  |  |  |
| AC-e3e12316 | this.Load | FP00510_TargetBalancingPopup.cs:193 |  | FLAG | dtMarket | Data_FP.Common_FP(Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, … ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-00dc37a0 | this.Load | FP00510_TargetBalancingPopup.cs:193 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DEMAND_MARKET_TYPE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSave… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DEMAND_MARKET_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0fc5fd9e | this.Load | FP00510_TargetBalancingPopup.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtMarket, cboMarket, false, "CODE", "CODE") | 목록 컨트롤 재구성 |  |  |  |
| AC-a0df0317 | this.Load | FP00510_TargetBalancingPopup.cs:203 | if (adminAuth == false) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-90ba6d72 | this.Load | FP00510_TargetBalancingPopup.cs:204 | if (adminAuth == false) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-93c7c092 | this.Load | FP00510_TargetBalancingPopup.cs:205 | if (adminAuth == false) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00510_TargetBalancingPopup.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33c9232b | popSql.OnSql | FP00510_TargetBalancingPopup.cs:498 | if (programID == "PR_UI_FP00510_SCP_TARGET_SAVE") | RETURN | return Save_Data_Target("SQL"); |  | 처리 중단/반환 |  |  |  |
| AC-d24acf3b | popSql.OnSql | FP00510_TargetBalancingPopup.cs:500 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00510_TargetBalancingPopup.Save_Data

진입점: this.btnSave.Click / SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88eb051f | this.btnSave.Click 외 1 | FP00510_TargetBalancingPopup.cs:260 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "1" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b49654c0 | this.btnSave.Click 외 1 | FP00510_TargetBalancingPopup.cs:262 | try ▸ else of (dsResult == null) ▸ if (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |
| AC-f26c33c7 | this.btnSave.Click 외 1 | FP00510_TargetBalancingPopup.cs:270 | try ▸ else of (dsResult == null) ▸ else of (dsResult.Tables[0].Rows[0][0].ToString() == "SUCCESS") | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-f3fddace | this.btnSave.Click 외 1 | FP00510_TargetBalancingPopup.cs:276 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |

## FP00510_TargetBalancingPopup.Save_Data_Target

진입점: popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAVE")] / this.btnSave.Click [try] / SaveButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e45de551 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:288 | try ▸ if (txtQtySplit.Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { " 0 " }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7b795bb | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:289 | try ▸ if (txtQtySplit.Text == "") | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-01f43813 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:293 | try ▸ else of (txtQtySplit.Text == "") ▸ if (txtQtySplit.Text.ToString().Equals("0")) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { " 0 " }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d7ea2f9c | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:294 | try ▸ else of (txtQtySplit.Text == "") ▸ if (txtQtySplit.Text.ToString().Equals("0")) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-bf29da71 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:298 | try ▸ else of (txtQtySplit.Text == "") ▸ else of (txtQtySplit.Text.ToString().Equals("0")) ▸ if (Convert.ToDecimal(txtQtySplit.Text) < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { " 0 " }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-21fef4a1 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:299 | try ▸ else of (txtQtySplit.Text == "") ▸ else of (txtQtySplit.Text.ToString().Equals("0")) ▸ if (Convert.ToDecimal(txtQtySplit.Text) < 1) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-e446b3f3 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:304 | try ▸ else of (txtQtySplit.Text == "") ▸ else of (txtQtySplit.Text.ToString().Equals("0")) ▸ else of (Convert.ToDecimal(txtQtySplit.Text) < … | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d1696d24 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:305 | try ▸ else of (txtQtySplit.Text == "") ▸ else of (txtQtySplit.Text.ToString().Equals("0")) ▸ else of (Convert.ToDecimal(txtQtySplit.Text) < … | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-3bd24101 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:310 | try ▸ else of (txtQtySplit.Text == "") ▸ else of (txtQtySplit.Text.ToString().Equals("0")) ▸ else of (Convert.ToDecimal(txtQtySplit.Text) < … | MESSAGE | MessageHelper.GMessageBox | ("MSG00099", new object[] { "Split 수량", "원래 수량" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb3bd059 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:311 | try ▸ else of (txtQtySplit.Text == "") ▸ else of (txtQtySplit.Text.ToString().Equals("0")) ▸ else of (Convert.ToDecimal(txtQtySplit.Text) < … | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-a98d4638 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:343 | try | ENDPOINT | new FoxDataRequest | (sServiceCallName) ⇒ {?string.Empty} \| {?pServiceCallName} | 엔드포인트 요청 생성 |  |  |  |
| AC-2bafbd33 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:347 | try | UI_PROP | req2.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-45128deb | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:349 | try | DATA_OP | req2.Parameters["p_sys_type"] | "SELECT" | 행/컬럼 값 대입 |  |  |  |
| AC-bcad0bf5 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:350 | try | DATA_OP | req2.Parameters["p_sys_flag"] | "SELECT_NEWTARGET_ID" | 행/컬럼 값 대입 |  |  |  |
| AC-dcc5c372 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:351 | try | DATA_OP | req2.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2de84599 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:352 | try | DATA_OP | req2.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-a2a668f9 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:353 | try | DATA_OP | req2.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa18cf97 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:354 | try | DATA_OP | req2.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e14dd973 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:355 | try | DATA_OP | req2.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-aa477d0e | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:356 | try | DATA_OP | req2.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-3319b0eb | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:357 | try | DATA_OP | req2.Parameters["p_shop_group_id"] | p_shop_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-1245e29a | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:358 | try | DATA_OP | req2.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-c093ac73 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:359 | try | DATA_OP | req2.Parameters["p_scp_target_id"] | p_scp_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-35dfb986 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:360 | try | DATA_OP | req2.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0b88f28f | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:361 | try | DATA_OP | req2.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-ba67a168 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:362 | try | DATA_OP | req2.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-8916701c | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:363 | try | DATA_OP | req2.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-3ce32557 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:364 | try | DATA_OP | req2.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-6fc1264e | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:365 | try | DATA_OP | req2.Parameters["p_org_market"] | p_org_market | 행/컬럼 값 대입 |  |  |  |
| AC-db864d8e | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:366 | try | DATA_OP | req2.Parameters["p_mfg_date"] | p_mfg_date | 행/컬럼 값 대입 |  |  |  |
| AC-54496190 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:367 | try | DATA_OP | req2.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-22935499 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:368 | try | DATA_OP | req2.Parameters["p_chg_qty"] | p_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-1ada214d | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:369 | try | DATA_OP | req2.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-fc32ec35 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:370 | try | DATA_OP | req2.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-4576d630 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:371 | try | DATA_OP | req2.Parameters["p_period_type"] | p_period_type | 행/컬럼 값 대입 |  |  |  |
| AC-55608b65 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:372 | try | DATA_OP | req2.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-07ea1f03 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:373 | try | DATA_OP | req2.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-3e6e2745 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:375 | try | ENDPOINT | client.ExecuteDataSet | (req2) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90bba319 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:390 | try ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows.Count > 0) | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-795bd13a | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:391 | try ▸ if (ds != null) ▸ else of (ds.Tables[0].Rows.Count > 0) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-10fcba22 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:400 | try ▸ else of (ds != null) | MESSAGE | MessageBox.Show | (errorMsg, "FP", MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2b630a10 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:401 | try ▸ else of (ds != null) | RETURN | return null; |  | 처리 중단/반환 |  |  |  |
| AC-affd8a13 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:407 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00510_SCP_TARGET_SAVE") ⇒ FP_Master.PR_UI_FP00510_SCP_TARGET_SAVE | 엔드포인트 요청 생성 |  |  |  |
| AC-7e5d9e78 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:410 | try | UI_PROP | req3.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-463d2df2 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:412 | try | DATA_OP | req3.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-10215adf | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:413 | try | DATA_OP | req3.Parameters["p_sys_flag"] | "INSERT" | 행/컬럼 값 대입 |  |  |  |
| AC-da0276a2 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:414 | try | DATA_OP | req3.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-8bbea45b | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:415 | try | DATA_OP | req3.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c6aaeea0 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:416 | try | DATA_OP | req3.Parameters["p_company_id"] | p_company_id | 행/컬럼 값 대입 |  |  |  |
| AC-60835fa7 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:417 | try | DATA_OP | req3.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-95a4d95c | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:418 | try | DATA_OP | req3.Parameters["p_site_id"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-abab5b46 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:419 | try | DATA_OP | req3.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-9cb0877e | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:420 | try | DATA_OP | req3.Parameters["p_shop_group_id"] | p_shop_group_id | 행/컬럼 값 대입 |  |  |  |
| AC-00875db9 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:421 | try | DATA_OP | req3.Parameters["p_scp_plan_id"] | p_scp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-12743de4 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:422 | try | DATA_OP | req3.Parameters["p_scp_target_id"] | p_scp_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-d2788537 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:423 | try | DATA_OP | req3.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f0db31b3 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:424 | try | DATA_OP | req3.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-072da2c8 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:425 | try | DATA_OP | req3.Parameters["p_instance_id"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2aff650 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:426 | try | DATA_OP | req3.Parameters["p_mfg_week"] | p_mfg_week | 행/컬럼 값 대입 |  |  |  |
| AC-df200298 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:427 | try | DATA_OP | req3.Parameters["p_market"] | p_market | 행/컬럼 값 대입 |  |  |  |
| AC-52accec8 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:428 | try | DATA_OP | req3.Parameters["p_org_market"] | p_org_market | 행/컬럼 값 대입 |  |  |  |
| AC-77e7c758 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:429 | try | DATA_OP | req3.Parameters["p_mfg_date"] | p_mfg_date | 행/컬럼 값 대입 |  |  |  |
| AC-8c0e2111 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:430 | try | DATA_OP | req3.Parameters["p_mfg_qty"] | p_mfg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-e111ff8e | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:431 | try | DATA_OP | req3.Parameters["p_chg_qty"] | p_chg_qty | 행/컬럼 값 대입 |  |  |  |
| AC-6fa433c3 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:432 | try | DATA_OP | req3.Parameters["p_production_type"] | p_production_type | 행/컬럼 값 대입 |  |  |  |
| AC-145bc82c | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:433 | try | DATA_OP | req3.Parameters["p_priority"] | p_priority | 행/컬럼 값 대입 |  |  |  |
| AC-252d200b | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:434 | try | DATA_OP | req3.Parameters["p_period_type"] | p_period_type | 행/컬럼 값 대입 |  |  |  |
| AC-d014d0ad | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:435 | try | DATA_OP | req3.Parameters["p_line_id"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-020c5d0a | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:436 | try | DATA_OP | req3.Parameters["p_line_name"] | p_line_name | 행/컬럼 값 대입 |  |  |  |
| AC-0d2d9114 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:437 | try | DATA_OP | req3.Parameters["p_operation_id"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-568c3fbb | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:438 | try | DATA_OP | req3.Parameters["p_new_target_id"] | p_new_target_id | 행/컬럼 값 대입 |  |  |  |
| AC-71f6bb49 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:439 | try | DATA_OP | req3.Parameters["p_new_market"] | p_new_market | 행/컬럼 값 대입 |  |  |  |
| AC-b290baf9 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:441 | try | ENDPOINT | client.ExecuteDataSet | (req3) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-61ec8959 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:444 | try | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |
| AC-23bc1715 | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:450 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba2488fa | popSql.OnSql [if (programID == "PR_UI_FP00510_SCP_TARGET_SAV… 외 2 | FP00510_TargetBalancingPopup.cs:451 | catch ((Exception ex)) | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## FP00510_TargetBalancingPopup.txtQtySplit_TextChanged

진입점: this.txtQtySplit.TextChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2015c47 | this.txtQtySplit.TextChanged | FP00510_TargetBalancingPopup.cs:475 | try | VALUE_SET | txtQty.Text | String.Format("{0:#,0}", iChg) | 컨트롤 값 설정 |  |  |  |
| AC-d52ade52 | this.txtQtySplit.TextChanged | FP00510_TargetBalancingPopup.cs:479 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | ("Invaid Number!", "Warnning", MessageBoxButtons.OK) | 메시지 표시 |  |  |  |
| AC-43b2699b | this.txtQtySplit.TextChanged | FP00510_TargetBalancingPopup.cs:480 | catch ((Exception ex)) | FOCUS | txtQtySplit.Focus | () | 포커스 이동 |  |  |  |

