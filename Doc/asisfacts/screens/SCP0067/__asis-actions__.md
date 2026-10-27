# AS-IS 액션 대조표 — SCP0067

> 원천: `Doc/asisfacts/screens/SCP0067/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 304행 · 메서드 32 · 종류 DATA_OP 141 · GRID_SET 23 · CALL_EXT 21 · UI_MISC 16 · FLAG 14 · RETURN 14 · GRID_INIT 10 · POPUP 9 · UI_PROP 9 · ENDPOINT 8 · MESSAGE 8 · LIST_REBIND 6 · GRID_LOCK 5 · COMBO_DATA 5 · STATE 4 · VALUE_SET 3 · VALIDATE 2 · GRID_STYLE 2 · GRID_CLEAR 1 · CALL_BASE 1 · GRID_BIND 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 22


## SCP0067_GlobalPSI.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e83acba | this.btnItem_Id.Click | SCP0067_GlobalPSI.cs:1532 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-d8af4519 | this.btnItem_Id.Click | SCP0067_GlobalPSI.cs:1534 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-0ab53e2f | this.btnItem_Id.Click | SCP0067_GlobalPSI.cs:1535 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-77bcc628 | this.btnItem_Id.Click | SCP0067_GlobalPSI.cs:1536 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fbaae414 | this.btnItem_Id.Click | SCP0067_GlobalPSI.cs:1541 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0067_GlobalPSI.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fabf8d98 | (진입점 미연결) | SCP0067_GlobalPSI.cs:1510 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0067", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-10c9d50a | (진입점 미연결) | SCP0067_GlobalPSI.cs:1511 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f7533031 | (진입점 미연결) | SCP0067_GlobalPSI.cs:1512 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f2898ec3 | (진입점 미연결) | SCP0067_GlobalPSI.cs:1515 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-51ec0680 | (진입점 미연결) | SCP0067_GlobalPSI.cs:1517 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0067_GlobalPSI.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5476b37f | (진입점 미연결) | SCP0067_GlobalPSI.cs:275 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0067_GlobalPSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd367c6b | this.Load | SCP0067_GlobalPSI.cs:218 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bb531590 | this.Load | SCP0067_GlobalPSI.cs:219 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-218921e6 | this.Load | SCP0067_GlobalPSI.cs:220 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0067_GlobalPSI.Cut_Operator

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.PACK_PROD) ▸ try ▸ for (iCol <= siMain.GetMaxColumnIndex())] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.PACK_PROD) ▸ try ▸ for (iCol <= siMain.…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d94b7fa8 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1451 |  | RETURN | return sFormulaText; |  | 처리 중단/반환 |  |  |  |

## SCP0067_GlobalPSI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-699f662d | this.Load | SCP0067_GlobalPSI.cs:162 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0067_GlobalPSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d2b10e47 | Dispose | SCP0067_GlobalPSI.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0067_GlobalPSI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4dc7fa42 | EditButton | SCP0067_GlobalPSI.cs:361 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6a1c115d | EditButton | SCP0067_GlobalPSI.cs:362 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-2f443b97 | EditButton | SCP0067_GlobalPSI.cs:364 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, siMain.ActiveSheet.ColumnCount - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d762ab3 | EditButton | SCP0067_GlobalPSI.cs:368 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (bEdit_Mode == false) | FLAG | bEdit_Mode | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2beb801f | EditButton | SCP0067_GlobalPSI.cs:372 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefMain.OPERATION_GROUP_NAME), row, siMain.GetColumnIndex(DefM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-25b3135e | EditButton | SCP0067_GlobalPSI.cs:378 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ if (bEdit_Mode == false) ▸ for (row < siMain.Sheet(0).Rows.Count) ▸ if (sMeasure … | GRID_LOCK | siMain.LockRange | (row, siMain.GetColumnIndex(DefMain.MEASURE_LABEL) + 1, row, siMain.ActiveSheet.ColumnCoun… | 그리드 편집 잠금/해제 |  |  |  |
| AC-16ec31b2 | EditButton | SCP0067_GlobalPSI.cs:384 | if (spdMain != null && spdMain.ActiveSheet.RowCount > 0) ▸ else of (bEdit_Mode == false) | FLAG | bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0067_GlobalPSI.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc5bc524 | ExcelButton | SCP0067_GlobalPSI.cs:396 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0067_GlobalPSI.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c381bb7 | FindButton 외 1 | SCP0067_GlobalPSI.cs:405 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-2c935b6f | FindButton 외 1 | SCP0067_GlobalPSI.cs:411 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-01680bf2 | FindButton 외 1 | SCP0067_GlobalPSI.cs:411 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c541a659 | FindButton 외 1 | SCP0067_GlobalPSI.cs:415 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-e8d80cd2 | FindButton 외 1 | SCP0067_GlobalPSI.cs:430 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-efa9bb80 | FindButton 외 1 | SCP0067_GlobalPSI.cs:432 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34440141 | FindButton 외 1 | SCP0067_GlobalPSI.cs:436 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0067_GET_GLOBAL_PSI") ⇒ SCP.SCP0067_GET_GLOBAL_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-00b43f82 | FindButton 외 1 | SCP0067_GlobalPSI.cs:437 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b6fd83c1 | FindButton 외 1 | SCP0067_GlobalPSI.cs:438 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-798f524b | FindButton 외 1 | SCP0067_GlobalPSI.cs:439 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-45dec6e4 | FindButton 외 1 | SCP0067_GlobalPSI.cs:440 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-6756e77a | FindButton 외 1 | SCP0067_GlobalPSI.cs:441 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ee770abd | FindButton 외 1 | SCP0067_GlobalPSI.cs:442 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-7e47e704 | FindButton 외 1 | SCP0067_GlobalPSI.cs:443 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0067" | 행/컬럼 값 대입 |  |  |  |
| AC-88c07022 | FindButton 외 1 | SCP0067_GlobalPSI.cs:444 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-8403986e | FindButton 외 1 | SCP0067_GlobalPSI.cs:445 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-4f9c047c | FindButton 외 1 | SCP0067_GlobalPSI.cs:446 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-18d5c699 | FindButton 외 1 | SCP0067_GlobalPSI.cs:447 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-559809ef | FindButton 외 1 | SCP0067_GlobalPSI.cs:448 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-17daa87d | FindButton 외 1 | SCP0067_GlobalPSI.cs:455 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8d6a9b38 | FindButton 외 1 | SCP0067_GlobalPSI.cs:459 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | FLAG | dtDataRowNum | dsBinding.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-effe5323 | FindButton 외 1 | SCP0067_GlobalPSI.cs:464 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d5f89c85 | FindButton 외 1 | SCP0067_GlobalPSI.cs:465 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f7de4e87 | FindButton 외 1 | SCP0067_GlobalPSI.cs:467 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bbcbfbae | FindButton 외 1 | SCP0067_GlobalPSI.cs:469 | try ▸ if (dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-010d1250 | FindButton 외 1 | SCP0067_GlobalPSI.cs:479 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2627de8b | FindButton 외 1 | SCP0067_GlobalPSI.cs:480 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e16f77e | FindButton 외 1 | SCP0067_GlobalPSI.cs:482 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c40aa452 | FindButton 외 1 | SCP0067_GlobalPSI.cs:484 | finally | FLAG | this.bEdit_Mode | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0067_GlobalPSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ed8cc4d | this.Load | SCP0067_GlobalPSI.cs:152 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0067_GlobalPSI.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cec80bd | this.Load | SCP0067_GlobalPSI.cs:491 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, "WEEKLY", cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c46aae8a | this.Load | SCP0067_GlobalPSI.cs:492 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0067_GlobalPSI.GetSpdTitle

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01fedca1 | this.Load 외 3 | SCP0067_GlobalPSI.cs:1493 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0067_GET_SPREAD_TITLE") ⇒ SCP.SCP0067_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-b84d2126 | this.Load 외 3 | SCP0067_GlobalPSI.cs:1497 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-183aebab | this.Load 외 3 | SCP0067_GlobalPSI.cs:1497 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0067_GlobalPSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-495e31ce | this.Load | SCP0067_GlobalPSI.cs:170 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-34f04ad7 | this.Load | SCP0067_GlobalPSI.cs:171 | if (dtDivision.Rows.Count>0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ccb1699 | this.Load | SCP0067_GlobalPSI.cs:181 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40" \|\| dr["CODE"].ToString() =… | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8387f140 | this.Load | SCP0067_GlobalPSI.cs:182 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40" \|\| dr["CODE"].ToString() =… | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-a8e95223 | this.Load | SCP0067_GlobalPSI.cs:183 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40" \|\| dr["CODE"].ToString() =… | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-7920cd1a | this.Load | SCP0067_GlobalPSI.cs:185 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40" \|\| dr["CODE"].ToString() =… | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68cb5100 | this.Load | SCP0067_GlobalPSI.cs:189 | if (dtDivision.Rows.Count>0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-4958497c | this.Load | SCP0067_GlobalPSI.cs:190 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-43c9a7c6 | this.Load | SCP0067_GlobalPSI.cs:192 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-47086fda | this.Load | SCP0067_GlobalPSI.cs:194 | if (dtDivision.Rows.Count>0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-33ec241a | this.Load | SCP0067_GlobalPSI.cs:195 | if (dtDivision.Rows.Count>0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1efdf9b6 | this.Load | SCP0067_GlobalPSI.cs:195 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-da047e37 | this.Load | SCP0067_GlobalPSI.cs:200 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-b64bdb3b | this.Load | SCP0067_GlobalPSI.cs:202 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-62d12668 | this.Load | SCP0067_GlobalPSI.cs:204 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-becd4019 | this.Load | SCP0067_GlobalPSI.cs:208 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-4f8e0ec8 | this.Load | SCP0067_GlobalPSI.cs:210 |  | STATE | cboPlanDate.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4ece8ab7 | this.Load | SCP0067_GlobalPSI.cs:211 |  | STATE | cboPlanType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-e507ca78 | this.Load | SCP0067_GlobalPSI.cs:212 |  | STATE | cboPlanSeq.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-23ff8cc7 | this.Load | SCP0067_GlobalPSI.cs:213 |  | STATE | dCalendar.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0067_GlobalPSI.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2aa42c81 | this.Load 외 3 | SCP0067_GlobalPSI.cs:226 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-0c18ed28 | this.Load 외 3 | SCP0067_GlobalPSI.cs:229 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 2) | 그리드 재구성/초기화 |  |  |  |
| AC-9feeb16e | this.Load 외 3 | SCP0067_GlobalPSI.cs:232 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0067_GlobalPSI.InitSpreadDateColumn

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-168a5ce7 | this.Load 외 3 | SCP0067_GlobalPSI.cs:249 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | siMain.AddNumColumn | (sColumnLabel, sColumnName, FPMerge.Restricted, 100, true, FPHAlign.Right, FPVAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19a82bad | this.Load 외 3 | SCP0067_GlobalPSI.cs:254 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sSpanLabelName != sSmallLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d13837bf | this.Load 외 3 | SCP0067_GlobalPSI.cs:261 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iStartCol, 1, iSpanCnt, 30, sSpanLabelName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0067_GlobalPSI.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d4bff59 | SaveButton | SCP0067_GlobalPSI.cs:498 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-386388e5 | SaveButton | SCP0067_GlobalPSI.cs:506 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-679370d3 | SaveButton | SCP0067_GlobalPSI.cs:514 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed5251f2 | SaveButton | SCP0067_GlobalPSI.cs:515 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a03c818 | SaveButton | SCP0067_GlobalPSI.cs:516 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_start_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ac6f32f | SaveButton | SCP0067_GlobalPSI.cs:517 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_plan_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-dcdbb9e8 | SaveButton | SCP0067_GlobalPSI.cs:518 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_seq") | 데이터 객체 조작/조회 |  |  |  |
| AC-89fa0abc | SaveButton | SCP0067_GlobalPSI.cs:519 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-15c6a704 | SaveButton | SCP0067_GlobalPSI.cs:520 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_measure") | 데이터 객체 조작/조회 |  |  |  |
| AC-288366df | SaveButton | SCP0067_GlobalPSI.cs:521 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dt.Columns.Add | ("p_xls_key1") | 데이터 객체 조작/조회 |  |  |  |
| AC-d966725d | SaveButton | SCP0067_GlobalPSI.cs:523 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-e6820977 | SaveButton | SCP0067_GlobalPSI.cs:549 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-e9831fe8 | SaveButton | SCP0067_GlobalPSI.cs:550 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-31c808ce | SaveButton | SCP0067_GlobalPSI.cs:551 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-28daefa6 | SaveButton | SCP0067_GlobalPSI.cs:555 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-fc875bf4 | SaveButton | SCP0067_GlobalPSI.cs:557 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00317", new object[] { message }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d92120f | SaveButton | SCP0067_GlobalPSI.cs:558 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b75a012d | SaveButton | SCP0067_GlobalPSI.cs:562 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c6870f25 | SaveButton | SCP0067_GlobalPSI.cs:564 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-de556864 | SaveButton | SCP0067_GlobalPSI.cs:565 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6aaf09eb | SaveButton | SCP0067_GlobalPSI.cs:566 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_start_yyyymmdd"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PLAN_START_YYYYMMDD)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-44388c4d | SaveButton | SCP0067_GlobalPSI.cs:567 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_plan_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PLAN_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5533c92d | SaveButton | SCP0067_GlobalPSI.cs:568 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_seq"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.SEQ)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b0f1ae0c | SaveButton | SCP0067_GlobalPSI.cs:569 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ede30b2d | SaveButton | SCP0067_GlobalPSI.cs:570 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_measure"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.MEASURE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dd6aed5b | SaveButton | SCP0067_GlobalPSI.cs:571 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_xls_key1"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.XLS_KEY1)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-13a7f2cd | SaveButton | SCP0067_GlobalPSI.cs:572 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dr["p_qty"] | strDayQty | 행/컬럼 값 대입 |  |  |  |
| AC-bd07f702 | SaveButton | SCP0067_GlobalPSI.cs:574 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-218ff3a2 | SaveButton | SCP0067_GlobalPSI.cs:586 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7193356f | SaveButton | SCP0067_GlobalPSI.cs:596 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0067", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c8482a4f | SaveButton | SCP0067_GlobalPSI.cs:597 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveGlobalPSIRow") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveGlobalPSIRow] \| SC… | 엔드포인트 호출 |  |  |  |
| AC-85d26206 | SaveButton | SCP0067_GlobalPSI.cs:600 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-32a95ac8 | SaveButton | SCP0067_GlobalPSI.cs:605 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != n… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12e6db39 | SaveButton | SCP0067_GlobalPSI.cs:614 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (result… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8b971bd9 | SaveButton | SCP0067_GlobalPSI.cs:623 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c0ddb9ca | SaveButton | SCP0067_GlobalPSI.cs:624 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89d73106 | SaveButton | SCP0067_GlobalPSI.cs:630 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ finally ▸ if (!prgClo… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c914e0d3 | SaveButton | SCP0067_GlobalPSI.cs:641 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ec2dda39 | SaveButton | SCP0067_GlobalPSI.cs:642 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38d9004a | SaveButton | SCP0067_GlobalPSI.cs:646 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e5e61461 | SaveButton | SCP0067_GlobalPSI.cs:648 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0067_GlobalPSI.SCM_SYS_LOG_BATCH

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-633f9ebd | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1461 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-b26a13f9 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1462 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-5264c3c2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1463 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-3da6d4a5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1464 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-2a8db444 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1465 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-c86dbd25 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1466 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-7db912e0 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1467 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-e7723397 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0067_GlobalPSI.cs:1469 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0067_GlobalPSI.Set_Calculator

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2a5a729 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SCP0067_GlobalPSI.cs:658 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d7e98c93 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SCP0067_GlobalPSI.cs:696 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_Cell_EOH

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.CELL_CHAR_PLAN)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.CELL_CHAR_PLAN)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-464fc20f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1059 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b72c760f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1059 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e043c80 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1061 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-149440db | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1062 | lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-52a5a4b4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1063 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d7b55a0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1065 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68c687b2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1065 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0c4b37e9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1066 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-db523803 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1067 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-90820e1b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1068 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-cc218366 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1070 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-bd76f357 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1070 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f53e489b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1071 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2b2569bc | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1072 | lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-78d4ce86 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1077 | if (dr_SHIP_PLAN_PLANT != null) | CALL_EXT | Convert.ToInt16 | (dr_SHIP_PLAN_PLANT["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-959cbfa6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1106 | for (iRow <= iRow_MAX_Cell_EOH) ▸ if (DefMeasure.CELL_PROD == sMeasure) | DATA_OP | idx_SEMI_CELL_PROD_List.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-816a1a41 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1199 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_CELL_EOH, iCol].Formula | sFormulaText_CELL_EOH | 그리드 속성/값 설정 |  |  |  |
| AC-b054be98 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1202 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_CELL_FORM_PROGRESS, iCol].Formula | sFormulaText_CELL_FORM_PROGRESS | 그리드 속성/값 설정 |  |  |  |
| AC-fcf8ca8d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1205 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_CELL_CHAR_AVAILABLE, iCol].Formula | sFormulaText_CELL_CHAR_AVAILABLE | 그리드 속성/값 설정 |  |  |  |
| AC-eeef047d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1207 |  | RETURN | return iRow_MAX_Cell_EOH; |  | 처리 중단/반환 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_CELL_SHIP_PLAN_TOTAL

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.CELL_CHAR_PLAN)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.CELL_CHAR_PLAN)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-62a8c3f7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1225 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c4b72d17 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1225 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-17c21289 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1227 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-70f5cf06 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1228 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d7b7a519 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1233 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow dr in listData) | CALL_EXT | Convert.ToInt16 | (dr["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ad004e18 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1241 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[targetIdx, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_PACK_CELL_EOH

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.PACK_CELL_EOH)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.PACK_CELL_EOH)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ad92d333 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1260 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1d40eb6d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1261 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c20bf4c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1262 | lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ddba99e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1265 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-30ce47ac | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1267 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-119c991d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1268 | lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fef27a4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1271 | if (dr_SEMI_WHIN_TOTAL == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c1197c6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1273 |  | CALL_EXT | Convert.ToInt16 | (dr_SEMI_WHIN_TOTAL["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-004000eb | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1284 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow drIdx in idx_PACK_PROD_List) | CALL_EXT | Convert.ToInt16 | (drIdx["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-022c3de8 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1287 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow drIdx in idx_PACK_PROD_List) | CALL_EXT | Convert.ToInt16 | (siMain.ActiveSheet.Cells[iRow, iColIdx_CELL_QTY_PACK].Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-da7aa247 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1287 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow drIdx in idx_PACK_PROD_List) | CALL_EXT | Convert.ToInt16 | (siMain.ActiveSheet.Cells[iRow, iColIdx_CELL_QTY_PACK].Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e60ac492 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1288 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow drIdx in idx_PACK_PROD_List) | CALL_EXT | Convert.ToInt16 | (siMain.ActiveSheet.Cells[iRow, iColIdx_YIELD].Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-856364ed | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1288 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow drIdx in idx_PACK_PROD_List) | CALL_EXT | Convert.ToInt16 | (siMain.ActiveSheet.Cells[iRow, iColIdx_YIELD].Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d449cb34 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1319 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow_PACK_CELL_EOH, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_PARTIAL_WEEK_EOH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e2ef5be | (진입점 미연결) | SCP0067_GlobalPSI.cs:1410 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (1, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e9d8c6ca | (진입점 미연결) | SCP0067_GlobalPSI.cs:1413 | for (iCol <= siMain.GetMaxColumnIndex()) | DATA_OP | dtSpdTitle.Select | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_PARTIAL_WEEK_LT_DAY

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SHIP_PLAN)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SHIP_PLAN)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-199924c6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1333 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (1, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70e9530b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1353 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (int iRow in idx_SHIP_PLAN_List) ▸ else of (iBodLt == 0) | DATA_OP | dtSpdTitle.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b1aecf97 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1355 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (int iRow in idx_SHIP_PLAN_List) ▸ else of (iBodLt == 0) | CALL_EXT | Convert.ToInt16 | (drCalOrderNum["CAL_ORDER_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-595d2938 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1359 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (int iRow in idx_SHIP_PLAN_List) ▸ else of (iBodLt == 0) | DATA_OP | dtSpdTitle.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-46abe267 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1366 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (int iRow in idx_SHIP_PLAN_List) ▸ else of (iBodLt == 0) ▸ if (iCalOrderNum_BodLt > 0) | CALL_EXT | siMain.GetColumnText | (1, iColBodLt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c1e9219a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1368 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (int iRow in idx_SHIP_PLAN_List) ▸ else of (iBodLt == 0) ▸ if (iCalOrderNum_BodLt > 0) | DATA_OP | dtSpdTitle.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-486c76d1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1368 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (int iRow in idx_SHIP_PLAN_List) ▸ else of (iBodLt == 0) ▸ if (iCalOrderNum_BodLt > 0) ▸ … | CALL_EXT | Convert.ToInt16 | (c["CAL_ORDER_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ae75b546 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1393 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[targetIdx, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_PLAN_FG

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SHIP_PLAN)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SHIP_PLAN)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4745c466 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:718 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-70665f3b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:718 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ade2bc85 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:719 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-26456efd | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:721 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-529098c7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:723 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-f434082a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:723 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b09dac47 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:724 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f5de1277 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:726 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-101a5666 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:729 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cdbe645f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:729 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-1dd7b9a5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:730 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9bb4841 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:732 | lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-89db4fbd | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:733 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-1b715702 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:735 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-68d34323 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:735 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b649a125 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:736 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b547ab5d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:738 | lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-e95b3e29 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:739 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ed58e31 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:773 | for (iRow <= iRow_MAX_FG) ▸ if (DefMeasure.SHIP_PLAN == sMeasure) | DATA_OP | idx_SHIP_PLAN_List.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-d48c9ebf | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:791 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_FCST_RTF_GAP, iCol].Formula | "IMSUB(" + cell_ALLOCATION + "," + cell_MKT_FCST + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-8e1b228f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:795 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_WHIN_TOTAL, iCol].Formula | "SUM(" + cell_INTRANSIT_ETA + ":" + cell_SHIP_PLAN_ETA + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-800427f1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:802 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_ALLOCATION, iCol].Formula | "MIN(" + cell_MKT_FCST + " - " + siMain.ActiveSheet.Cells[iRowIdx_FCST_RTF_ACC, iCol-1] + … | 그리드 속성/값 설정 |  |  |  |
| AC-a1e17226 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:803 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_FCST_RTF_ACC, iCol].Formula | "" + siMain.ActiveSheet.Cells[iRowIdx_FCST_RTF_GAP, iCol] + " + " + siMain.ActiveSheet.Cel… | 그리드 속성/값 설정 |  |  |  |
| AC-916c9868 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:804 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_BOH, iCol].Formula | "" + siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_EOH, iCol - 1] + "" | 그리드 속성/값 설정 |  |  |  |
| AC-f4c81e6c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:805 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_EOH, iCol].Formula | "IMSUB( SUM(" + siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_EOH, iCol - 1] + "," + cell_WHIN_… | 그리드 속성/값 설정 |  |  |  |
| AC-ed66dedb | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:809 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_ALLOCATION, iCol].Formula | "MIN(" + cell_MKT_FCST + ", SUM(" + cell_WHIN_TOTAL + "," + cell_TO_SITE_BOH + "))" | 그리드 속성/값 설정 |  |  |  |
| AC-af1f4531 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:810 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_FCST_RTF_ACC, iCol].Formula | cell_MKT_FCST_GAP.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-5d1cdbaf | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:812 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_EOH, iCol].Formula | "IMSUB( SUM(" + i_FROM_BOH_QTY_value + "," + cell_WHIN_TOTAL + "), " + cell_ALLOCATION + "… | 그리드 속성/값 설정 |  |  |  |
| AC-59b14b36 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:813 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_BOH, iCol].Value | siMain.ActiveSheet.Cells[iRowIdx_TO_SITE_BOH, iColIdx_FROM_BOH_QTY].Value | 그리드 속성/값 설정 |  |  |  |
| AC-e944aec2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:818 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_SHIP_PLAN_PLANT, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |
| AC-8d4e3f22 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:825 |  | GRID_SET | siMain.ActiveSheet.Rows[iRowIdx_TO_SITE_BOH].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e07a5bae | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:827 |  | RETURN | return iRow_MAX_FG; |  | 처리 중단/반환 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_PROD

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.PACK_PROD)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.PACK_PROD)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-354e6c6a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:841 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3634eda9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:841 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea0d8b73 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:843 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-9a4ee127 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:844 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-d4d6fc9a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:846 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-ed6c9544 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:846 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-b470de28 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:848 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-d3a858a4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:849 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-b6ff4816 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:877 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-58cfafc6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:877 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0eb99443 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:878 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-89ab4ca6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:879 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c9e0a1e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:883 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-537c2523 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:883 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8f37cdd9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:884 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-50226991 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:885 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5bbdbb4b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:891 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow dr in list_SHIP_PLAN_PLANT) | CALL_EXT | Convert.ToInt16 | (dr["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3d6d1fd9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:900 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow dr in list_PACK_PROD) | CALL_EXT | Convert.ToInt16 | (dr["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f4a6c9f9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:912 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_PACK_BOH, iCol].Formula | "" + cell_PACK_EOH_BEFORE + "" | 그리드 속성/값 설정 |  |  |  |
| AC-1b2bf775 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:918 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_PACK_EOH, iCol].Formula | sFormulaText_PACK_EOH | 그리드 속성/값 설정 |  |  |  |
| AC-db36cf5b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:928 | try ▸ for (iCol <= siMain.GetMaxColumnIndex()) ▸ else of (iCol > iStartIdx) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_PACK_EOH, iCol].Formula | sFormulaText_PACK_EOH | 그리드 속성/값 설정 |  |  |  |
| AC-e983b9dc | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:931 | try | RETURN | return iRow_MAX_PROD; |  | 처리 중단/반환 |  |  |  |
| AC-4d97bce8 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:938 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5f634c56 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:939 | catch ((Exception ex)) | RETURN | return spdMain.ActiveSheet.RowCount -1; |  | 처리 중단/반환 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_SEMI

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SEMI_SHIP_PLAN)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SEMI_SHIP_PLAN)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c54b28dd | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:995 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8cac5c8c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:995 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c7517942 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:996 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-3982a6f9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:997 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7c63b763 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:998 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bc683de | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1000 | lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a5de56d7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1000 | lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-c48b1739 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1001 | lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-668aad92 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1002 | lambda | DATA_OP | row.Field | ("FROM_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-235204cd | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1003 | lambda | DATA_OP | row.Field | ("ROW_NUM") | 데이터 객체 조작/조회 |  |  |  |
| AC-29ba82ad | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1021 | for (iRow <= iRow_MAX_SEMI) ▸ if (DefMeasure.SEMI_SHIP_PLAN == sMeasure) | DATA_OP | idx_SEMI_SHIP_PLAN_List.Add | (iRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-3a8e2d41 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1030 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRowIdx_SEMI_INTRANSIT, iCol].Formula | "SUM(" + cell_SEMI_INTRANSIT_ETA + ":" + cell_SHIP_PLAN_ETA + ")" | 그리드 속성/값 설정 |  |  |  |
| AC-1519ba4f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:1037 |  | RETURN | return iRow_MAX_SEMI; |  | 처리 중단/반환 |  |  |  |

## SCP0067_GlobalPSI.Set_Formula_SEMI_WHIN_TOTAL

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SEMI_WHIN_TOTAL)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow <= siMain.ActiveSheet.RowCount - 1) ▸ if (sMeasure == DefMeasure.SEMI_WHIN_TOTAL)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-009c50b0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:962 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("CELL_ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a025e61a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:962 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b0c7978 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:963 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("TO_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b30d2673 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:964 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ lambda | DATA_OP | row.Field | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2334799a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:969 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ foreach (DataRow dr in listData) | CALL_EXT | Convert.ToInt16 | (dr["ROW_NUM"].ToString()) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7e384841 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0) ▸ … 외 1 | SCP0067_GlobalPSI.cs:977 | for (iCol <= siMain.GetMaxColumnIndex()) | GRID_SET | siMain.ActiveSheet.Cells[iRow_WHIN_TOTAL, iCol].Formula | sFormulaText | 그리드 속성/값 설정 |  |  |  |

## SCP0067_GlobalPSI.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / EditButton [if (spdMain != null && spdMain.ActiveSheet.RowCount > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-861d79df | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0067_GlobalPSI.cs:1423 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-203aa1a3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0067_GlobalPSI.cs:1425 |  | UI_MISC | spdMain.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-c546881b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0067_GlobalPSI.cs:1437 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-eae970ab | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0067_GlobalPSI.cs:1441 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0067_GlobalPSI.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d76a7ed | this.Load 외 1 | SCP0067_GlobalPSI.cs:280 |  | FLAG | dtFromSite | Data.Common(Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContex… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-0d13292f | this.Load 외 1 | SCP0067_GlobalPSI.cs:280 |  | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ee2c2fab | this.Load 외 1 | SCP0067_GlobalPSI.cs:283 |  | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-ebb1610a | this.Load 외 1 | SCP0067_GlobalPSI.cs:284 |  | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-cc834a87 | this.Load 외 1 | SCP0067_GlobalPSI.cs:286 |  | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f96d886 | this.Load 외 1 | SCP0067_GlobalPSI.cs:287 |  | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-8d6a11e7 | this.Load 외 1 | SCP0067_GlobalPSI.cs:288 |  | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-cbb14485 | this.Load 외 1 | SCP0067_GlobalPSI.cs:289 |  | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d923340 | this.Load 외 1 | SCP0067_GlobalPSI.cs:295 | for (idx < dtFromSite.Rows.Count) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5a974978 | this.Load 외 1 | SCP0067_GlobalPSI.cs:296 | for (idx < dtFromSite.Rows.Count) | DATA_OP | drRow["CODE"] | drtmp["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-bbe81909 | this.Load 외 1 | SCP0067_GlobalPSI.cs:297 | for (idx < dtFromSite.Rows.Count) | DATA_OP | drRow["NAME"] | drtmp["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-dc307adb | this.Load 외 1 | SCP0067_GlobalPSI.cs:298 | for (idx < dtFromSite.Rows.Count) | DATA_OP | table.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f9b14c1 | this.Load 외 1 | SCP0067_GlobalPSI.cs:300 |  | LIST_REBIND | clsCtrl.setListBox | (table, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-448d61c8 | this.Load 외 1 | SCP0067_GlobalPSI.cs:305 |  | FLAG | dtToSite | Data.Common(Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-8cf7c762 | this.Load 외 1 | SCP0067_GlobalPSI.cs:305 |  | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58ffd2cc | this.Load 외 1 | SCP0067_GlobalPSI.cs:308 |  | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-346b6dbb | this.Load 외 1 | SCP0067_GlobalPSI.cs:309 |  | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d547b309 | this.Load 외 1 | SCP0067_GlobalPSI.cs:311 |  | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-519b4431 | this.Load 외 1 | SCP0067_GlobalPSI.cs:312 |  | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-7ab5c278 | this.Load 외 1 | SCP0067_GlobalPSI.cs:313 |  | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-47727035 | this.Load 외 1 | SCP0067_GlobalPSI.cs:314 |  | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-11057466 | this.Load 외 1 | SCP0067_GlobalPSI.cs:320 | for (idx < dtToSite.Rows.Count) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6f0cc6a6 | this.Load 외 1 | SCP0067_GlobalPSI.cs:321 | for (idx < dtToSite.Rows.Count) | DATA_OP | drRow["CODE"] | drtmp["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4da7b832 | this.Load 외 1 | SCP0067_GlobalPSI.cs:322 | for (idx < dtToSite.Rows.Count) | DATA_OP | drRow["NAME"] | drtmp["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-78cb5d57 | this.Load 외 1 | SCP0067_GlobalPSI.cs:323 | for (idx < dtToSite.Rows.Count) | DATA_OP | table.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f607e3d6 | this.Load 외 1 | SCP0067_GlobalPSI.cs:326 |  | LIST_REBIND | clsCtrl.setListBox | (table, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fc52179d | this.Load 외 1 | SCP0067_GlobalPSI.cs:330 |  | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-e8dec3d8 | this.Load 외 1 | SCP0067_GlobalPSI.cs:330 |  | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e245363f | this.Load 외 1 | SCP0067_GlobalPSI.cs:331 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e277bc5e | this.Load 외 1 | SCP0067_GlobalPSI.cs:334 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-f497db25 | this.Load 외 1 | SCP0067_GlobalPSI.cs:334 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ab7fb8f2 | this.Load 외 1 | SCP0067_GlobalPSI.cs:335 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-82b09ca8 | this.Load 외 1 | SCP0067_GlobalPSI.cs:338 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-40f6e9c2 | this.Load 외 1 | SCP0067_GlobalPSI.cs:341 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-82106f7e | this.Load 외 1 | SCP0067_GlobalPSI.cs:341 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c188a4b0 | this.Load 외 1 | SCP0067_GlobalPSI.cs:342 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0067_GlobalPSI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5ab0818 | this.spdMain.CellDoubleClick | SCP0067_GlobalPSI.cs:1484 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0067_GlobalPSI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6afdd2b3 | this.spdMain.TopChange | SCP0067_GlobalPSI.cs:1503 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

