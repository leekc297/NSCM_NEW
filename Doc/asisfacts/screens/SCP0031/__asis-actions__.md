# AS-IS 액션 대조표 — SCP0031

> 원천: `Doc/asisfacts/screens/SCP0031/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 204행 · 메서드 33 · 종류 DATA_OP 53 · FLAG 23 · GRID_INIT 21 · RETURN 19 · UI_PROP 14 · GRID_SET 10 · MESSAGE 8 · POPUP 7 · VALUE_SET 7 · CALL_EXT 7 · ENDPOINT 7 · LIST_REBIND 7 · UI_MISC 6 · GRID_CLEAR 5 · VALIDATE 3 · COMBO_DATA 3 · CALL_BASE 1 · GRID_BIND 1 · GRID_LOCK 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 8


## SCP0031_GlobalPSI.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-103729b5 | this.btnItem_Id.Click | SCP0031_GlobalPSI.cs:925 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-36b606e2 | this.btnItem_Id.Click | SCP0031_GlobalPSI.cs:927 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4548be38 | this.btnItem_Id.Click | SCP0031_GlobalPSI.cs:928 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-afd7c359 | this.btnItem_Id.Click | SCP0031_GlobalPSI.cs:929 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-03f0af0c | this.btnItem_Id.Click | SCP0031_GlobalPSI.cs:935 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0031_GlobalPSI.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e63e1e68 | this.btnMeasure.Click | SCP0031_GlobalPSI.cs:852 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0031", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-1e3ba2df | this.btnMeasure.Click | SCP0031_GlobalPSI.cs:853 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3809dae3 | this.btnMeasure.Click | SCP0031_GlobalPSI.cs:854 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e56cac6f | this.btnMeasure.Click | SCP0031_GlobalPSI.cs:857 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-fb5059df | this.btnMeasure.Click | SCP0031_GlobalPSI.cs:859 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0031_GlobalPSI.CboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-466a9ebc | this.cboBucketType.SelectedIndexChanged | SCP0031_GlobalPSI.cs:874 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0031_GlobalPSI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d457e5f2 | cboPlanDate.SelectedIndexChanged | SCP0031_GlobalPSI.cs:907 | if (cboPlanType.Items.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | cboPlanType.Items.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-7ca99491 | cboPlanDate.SelectedIndexChanged | SCP0031_GlobalPSI.cs:910 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-c6a034f5 | cboPlanDate.SelectedIndexChanged | SCP0031_GlobalPSI.cs:911 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0031_GlobalPSI.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88b96009 | cboPlanSeq.SelectedIndexChanged | SCP0031_GlobalPSI.cs:346 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0031_GlobalPSI.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7261fb4 | cboPlanType.SelectedIndexChanged | SCP0031_GlobalPSI.cs:893 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3ca0481e | cboPlanType.SelectedIndexChanged | SCP0031_GlobalPSI.cs:896 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0031_GlobalPSI.ChkAll_CheckedChanged

진입점: this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c21347b0 | this.chkAll.CheckedChanged | SCP0031_GlobalPSI.cs:886 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0031_GlobalPSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-86d05735 | this.Load | SCP0031_GlobalPSI.cs:232 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ae5b7008 | this.Load | SCP0031_GlobalPSI.cs:233 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-7f6bf5ae | this.Load | SCP0031_GlobalPSI.cs:234 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0031_GlobalPSI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b4fa37f | this.Load | SCP0031_GlobalPSI.cs:167 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-1e03e6db | this.Load | SCP0031_GlobalPSI.cs:168 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0031_GlobalPSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdc891a0 | Dispose | SCP0031_GlobalPSI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0031_GlobalPSI.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c23d87c2 | ExcelButton | SCP0031_GlobalPSI.cs:514 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0031_GlobalPSI.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-733ce4da | FindButton | SCP0031_GlobalPSI.cs:524 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cf6a3cf4 | FindButton | SCP0031_GlobalPSI.cs:529 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-80800fa8 | FindButton | SCP0031_GlobalPSI.cs:529 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d83aa0aa | FindButton | SCP0031_GlobalPSI.cs:530 | try | VALIDATE | SCPPlan.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-d19d7ca0 | FindButton | SCP0031_GlobalPSI.cs:530 | try ▸ if (!SCPPlan.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4edd4429 | FindButton | SCP0031_GlobalPSI.cs:532 | try | UI_PROP | SCPPlan.p_div | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 속성 p_div 설정 |  |  |  |
| AC-3c65372e | FindButton | SCP0031_GlobalPSI.cs:533 | try | UI_PROP | SCPPlan.p_bucket | CString.GetCheckedListValue(dtBucketType, cboBucketType.ControlValues) | 속성 p_bucket 설정 |  |  |  |
| AC-e1911f23 | FindButton | SCP0031_GlobalPSI.cs:534 | try | UI_PROP | SCPPlan.p_plan_date | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues) | 속성 p_plan_date 설정 |  |  |  |
| AC-4160cc34 | FindButton | SCP0031_GlobalPSI.cs:535 | try | UI_PROP | SCPPlan.p_to_yyyymmdd | dCalendar.Text2.Replace("-", "") | 속성 p_to_yyyymmdd 설정 |  |  |  |
| AC-a5e23ec1 | FindButton | SCP0031_GlobalPSI.cs:537 | try | CALL_EXT | SCPPlan.CheckPlanPeriodRange | (ref returnMessage, ref plan_end_date) | ⚠ 의미 확인 필요 |  |  |  |
| AC-295ca4ee | FindButton | SCP0031_GlobalPSI.cs:539 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | MESSAGE | MessageHelper.GMessageBox | (returnMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3af0acaa | FindButton | SCP0031_GlobalPSI.cs:540 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | UI_PROP | dCalendar.Text2 | plan_end_date | 속성 Text2 설정 |  |  |  |
| AC-6bd5842f | FindButton | SCP0031_GlobalPSI.cs:541 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9443bbf8 | FindButton | SCP0031_GlobalPSI.cs:545 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f1637878 | FindButton | SCP0031_GlobalPSI.cs:570 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6bd9e7af | FindButton | SCP0031_GlobalPSI.cs:572 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3ea0394 | FindButton | SCP0031_GlobalPSI.cs:575 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0031_GET_GLOBAL_PSI") ⇒ SCP.SCP0031_GET_GLOBAL_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-fcfb1dbb | FindButton | SCP0031_GlobalPSI.cs:576 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-f9c6ad81 | FindButton | SCP0031_GlobalPSI.cs:577 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-34ca2249 | FindButton | SCP0031_GlobalPSI.cs:578 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-48207f8b | FindButton | SCP0031_GlobalPSI.cs:579 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8129a8bc | FindButton | SCP0031_GlobalPSI.cs:580 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fa2fde57 | FindButton | SCP0031_GlobalPSI.cs:581 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-ed1b63aa | FindButton | SCP0031_GlobalPSI.cs:582 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-99344b41 | FindButton | SCP0031_GlobalPSI.cs:583 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-a176f013 | FindButton | SCP0031_GlobalPSI.cs:584 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-edb33abe | FindButton | SCP0031_GlobalPSI.cs:585 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-5b3937b3 | FindButton | SCP0031_GlobalPSI.cs:586 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-9e349c9f | FindButton | SCP0031_GlobalPSI.cs:587 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0031" | 행/컬럼 값 대입 |  |  |  |
| AC-2fe889cc | FindButton | SCP0031_GlobalPSI.cs:588 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-10189d34 | FindButton | SCP0031_GlobalPSI.cs:589 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cb71f7b8 | FindButton | SCP0031_GlobalPSI.cs:590 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-92a4d404 | FindButton | SCP0031_GlobalPSI.cs:591 | try ▸ lambda | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-518b71cf | FindButton | SCP0031_GlobalPSI.cs:592 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-9d1150a8 | FindButton | SCP0031_GlobalPSI.cs:594 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f356904 | FindButton | SCP0031_GlobalPSI.cs:595 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-053c40d6 | FindButton | SCP0031_GlobalPSI.cs:605 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5a75c18c | FindButton | SCP0031_GlobalPSI.cs:606 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-407b92a5 | FindButton | SCP0031_GlobalPSI.cs:607 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ff4bd4bd | FindButton | SCP0031_GlobalPSI.cs:612 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-93fdf007 | FindButton | SCP0031_GlobalPSI.cs:614 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6fa9d2a | FindButton | SCP0031_GlobalPSI.cs:623 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f56ba34a | FindButton | SCP0031_GlobalPSI.cs:625 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0031_GlobalPSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da35043e | this.Load | SCP0031_GlobalPSI.cs:156 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0031_GlobalPSI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39d07e4f | this.Load | SCP0031_GlobalPSI.cs:805 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-c1adbb4b | this.Load | SCP0031_GlobalPSI.cs:806 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a1850d2 | this.Load | SCP0031_GlobalPSI.cs:808 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0031_GlobalPSI.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cb7cc8e | this.Load 외 1 | SCP0031_GlobalPSI.cs:838 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-23a65984 | this.Load 외 1 | SCP0031_GlobalPSI.cs:839 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0031_GlobalPSI.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d16bc8e5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:827 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-da05bb71 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:828 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-61b64bf6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:829 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2371567d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:831 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1e844cf2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:831 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0031_GlobalPSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bb372af | this.Load | SCP0031_GlobalPSI.cs:176 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8e74c3aa | this.Load | SCP0031_GlobalPSI.cs:177 | if (dtDivision.Rows.Count>0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d221e064 | this.Load | SCP0031_GlobalPSI.cs:187 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ac5dda4 | this.Load | SCP0031_GlobalPSI.cs:188 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-34ad36ad | this.Load | SCP0031_GlobalPSI.cs:189 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-43c15d17 | this.Load | SCP0031_GlobalPSI.cs:191 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6e46340f | this.Load | SCP0031_GlobalPSI.cs:195 | if (dtDivision.Rows.Count>0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-5cdab555 | this.Load | SCP0031_GlobalPSI.cs:196 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-49abb38f | this.Load | SCP0031_GlobalPSI.cs:198 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bafcff49 | this.Load | SCP0031_GlobalPSI.cs:200 | if (dtDivision.Rows.Count>0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-49c278ad | this.Load | SCP0031_GlobalPSI.cs:201 | if (dtDivision.Rows.Count>0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-2dcc4401 | this.Load | SCP0031_GlobalPSI.cs:201 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b6a69e4c | this.Load | SCP0031_GlobalPSI.cs:208 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-2a02a421 | this.Load | SCP0031_GlobalPSI.cs:211 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-85680af8 | this.Load | SCP0031_GlobalPSI.cs:212 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-52aef8ae | this.Load | SCP0031_GlobalPSI.cs:213 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-a76a5ebd | this.Load | SCP0031_GlobalPSI.cs:215 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-78097691 | this.Load | SCP0031_GlobalPSI.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a58875ae | this.Load | SCP0031_GlobalPSI.cs:224 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-03ac2225 | this.Load | SCP0031_GlobalPSI.cs:226 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-a8a317b6 | this.Load | SCP0031_GlobalPSI.cs:227 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0031_GlobalPSI.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19f5eb34 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:241 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-359f8c2d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:244 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-1ebd1f36 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:248 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0031_GlobalPSI.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee143d2f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:282 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7719c1f1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:283 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d6243ad8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:286 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4e291a86 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:287 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c17c0074 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:290 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-9980bc9c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:296 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-de18e95a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:297 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d7aa6f5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:302 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a42711b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:303 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0fa34e2d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:310 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-333f07ee | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:311 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-41b365c6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:321 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d8cb385 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:322 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-710966f8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:323 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1990925f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0031_GlobalPSI.cs:324 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0031_GlobalPSI.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bd8957d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0031_GlobalPSI.cs:392 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-b3e3c337 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0031_GlobalPSI.cs:392 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f3342dca | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0031_GlobalPSI.cs:393 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0031_GlobalPSI.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-036a4cb9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0031_GlobalPSI.cs:414 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-68a5f29c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0031_GlobalPSI.cs:414 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "' AND PL… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e0d2af09 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0031_GlobalPSI.cs:415 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0031_GlobalPSI.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-97c5c1c5 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0031_GlobalPSI.cs:400 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" +pPlanDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-03c58481 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0031_GlobalPSI.cs:400 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" +pPlanDate + "'", true… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2975ce25 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0031_GlobalPSI.cs:402 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0031_GlobalPSI.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6592b9e1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0031_GlobalPSI.cs:782 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64532b94 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0031_GlobalPSI.cs:794 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-67c8a2f0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0031_GlobalPSI.cs:798 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0031_GlobalPSI.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78893a50 | (진입점 미연결) | SCP0031_GlobalPSI.cs:645 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5eae4157 | (진입점 미연결) | SCP0031_GlobalPSI.cs:649 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-3f05623c | (진입점 미연결) | SCP0031_GlobalPSI.cs:723 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxWeek] | weekSum / nCntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-abdf04f8 | (진입점 미연결) | SCP0031_GlobalPSI.cs:735 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxMonth] | monthSum / nCntDayOfMonth | 그리드 속성/값 설정 |  |  |  |

## SCP0031_GlobalPSI.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-11bd7294 | this.Load 외 1 | SCP0031_GlobalPSI.cs:425 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtFromSite | Data.Common(Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContex… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d14e7b23 | this.Load 외 1 | SCP0031_GlobalPSI.cs:425 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-908103bd | this.Load 외 1 | SCP0031_GlobalPSI.cs:428 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-57a02f8a | this.Load 외 1 | SCP0031_GlobalPSI.cs:429 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2735724a | this.Load 외 1 | SCP0031_GlobalPSI.cs:431 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-bfa8e06f | this.Load 외 1 | SCP0031_GlobalPSI.cs:432 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-99b48680 | this.Load 외 1 | SCP0031_GlobalPSI.cs:433 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-11d5762d | this.Load 외 1 | SCP0031_GlobalPSI.cs:434 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c6ee4dd7 | this.Load 외 1 | SCP0031_GlobalPSI.cs:440 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx<dtFromSite.Rows.Count) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c1f36be4 | this.Load 외 1 | SCP0031_GlobalPSI.cs:441 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx<dtFromSite.Rows.Count) | DATA_OP | drRow["CODE"] | drtmp["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f6810955 | this.Load 외 1 | SCP0031_GlobalPSI.cs:442 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx<dtFromSite.Rows.Count) | DATA_OP | drRow["NAME"] | drtmp["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c1161722 | this.Load 외 1 | SCP0031_GlobalPSI.cs:443 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx<dtFromSite.Rows.Count) | DATA_OP | table.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f2814649 | this.Load 외 1 | SCP0031_GlobalPSI.cs:445 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (table, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b4b700d | this.Load 외 1 | SCP0031_GlobalPSI.cs:450 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtToSite | Data.Common(Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-d0719f0f | this.Load 외 1 | SCP0031_GlobalPSI.cs:450 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-81696ce2 | this.Load 외 1 | SCP0031_GlobalPSI.cs:453 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9ea5ecd | this.Load 외 1 | SCP0031_GlobalPSI.cs:454 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6f727bb6 | this.Load 외 1 | SCP0031_GlobalPSI.cs:456 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-afc1bc5e | this.Load 외 1 | SCP0031_GlobalPSI.cs:457 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-39ffc60f | this.Load 외 1 | SCP0031_GlobalPSI.cs:458 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-b2e214ea | this.Load 외 1 | SCP0031_GlobalPSI.cs:459 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-83e0cf5a | this.Load 외 1 | SCP0031_GlobalPSI.cs:465 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c524e839 | this.Load 외 1 | SCP0031_GlobalPSI.cs:466 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | drRow["CODE"] | drtmp["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a806403a | this.Load 외 1 | SCP0031_GlobalPSI.cs:467 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | drRow["NAME"] | drtmp["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-f3448375 | this.Load 외 1 | SCP0031_GlobalPSI.cs:468 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | table.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c2c80c7 | this.Load 외 1 | SCP0031_GlobalPSI.cs:471 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (table, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a1b7de42 | this.Load 외 1 | SCP0031_GlobalPSI.cs:482 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (cboPlanType.Items.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | cboPlanType.Items.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0031_GlobalPSI.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (chkAll.Checked) ▸ if (siMain != null)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29096939 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:357 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1efda1a1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:361 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-dace192c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:366 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e3f98a38 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:369 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3e5a3661 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:373 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-5a4f3088 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:378 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-14b2b416 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0031_GlobalPSI.cs:382 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0031_GlobalPSI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fa7e1d9 | this.spdMain.CellDoubleClick | SCP0031_GlobalPSI.cs:817 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0031_GlobalPSI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ca6394d | this.spdMain.TopChange | SCP0031_GlobalPSI.cs:845 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCPPlan.Check_PeriodDate

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-578349af | (진입점 미연결) | SCP0031_GlobalPSI.cs:1098 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8d872d44 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1099 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-28abc7c6 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1108 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b43247c | (진입점 미연결) | SCP0031_GlobalPSI.cs:1109 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-ccc4f9d1 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1125 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c689946c | (진입점 미연결) | SCP0031_GlobalPSI.cs:1126 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-52db4b35 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1129 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCPPlan.Check_PeriodDate_New

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-35619785 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1146 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3183c36d | (진입점 미연결) | SCP0031_GlobalPSI.cs:1147 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1c70e41b | (진입점 미연결) | SCP0031_GlobalPSI.cs:1156 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2e3356c | (진입점 미연결) | SCP0031_GlobalPSI.cs:1157 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8369db46 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1173 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e26f0214 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1174 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-c6ad9489 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1177 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCPPlan.CheckArrayPlanPeriodRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4978bfe | (진입점 미연결) | SCP0031_GlobalPSI.cs:1006 |  | FLAG | checkResult | true | 화면 필드/플래그 변경 |  |  |  |
| AC-2f0431d6 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1011 | try ▸ if (string.IsNullOrWhiteSpace(p_version)) | RETURN | return checkResult; |  | 처리 중단/반환 |  |  |  |
| AC-c6af8041 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1014 | try | FLAG | arr_version | p_version.ToString().Split(',') | 화면 필드/플래그 변경 |  |  |  |
| AC-313daf15 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1019 | try ▸ foreach (string ver in arr_version) | FLAG | p_plan_date | ver.Substring(5, 8) | 화면 필드/플래그 변경 |  |  |  |
| AC-dae863a0 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1024 | try ▸ foreach (string ver in arr_version) ▸ if (string.IsNullOrWhiteSpace(p_plan_end_date)) | FLAG | p_plan_end_date | p_plan_end_date_focus | 화면 필드/플래그 변경 |  |  |  |
| AC-8a4f2660 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1030 | try ▸ foreach (string ver in arr_version) ▸ else of (string.IsNullOrWhiteSpace(p_plan_end_date)) ▸ if (Int64.Parse(p_plan_end_date_focus) > … | FLAG | p_plan_end_date | p_plan_end_date_focus | 화면 필드/플래그 변경 |  |  |  |
| AC-62679db3 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1038 | try ▸ if (Int64.Parse(p_to_yyyymmdd) > Int64.Parse(p_plan_end_date)) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00402", GSCM.App.Core.GAppSettings.LanguageCode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-abbc0e7d | (진입점 미연결) | SCP0031_GlobalPSI.cs:1040 | try ▸ if (Int64.Parse(p_to_yyyymmdd) > Int64.Parse(p_plan_end_date)) | FLAG | checkResult | false | 화면 필드/플래그 변경 |  |  |  |
| AC-f5fa38d0 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1041 | try ▸ if (Int64.Parse(p_to_yyyymmdd) > Int64.Parse(p_plan_end_date)) | RETURN | return checkResult; |  | 처리 중단/반환 |  |  |  |
| AC-06c5a378 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1047 |  | RETURN | return checkResult; |  | 처리 중단/반환 |  |  |  |

## SCPPlan.CheckPlanPeriodRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24bfc596 | (진입점 미연결) | SCP0031_GlobalPSI.cs:981 |  | FLAG | checkResult | true | 화면 필드/플래그 변경 |  |  |  |
| AC-b036fa78 | (진입점 미연결) | SCP0031_GlobalPSI.cs:988 | try ▸ if (Int64.Parse(p_to_yyyymmdd) > Int64.Parse(p_plan_end_date)) | CALL_EXT | MessageHelper.GetMessageInfo | ("MSG00402", GSCM.App.Core.GAppSettings.LanguageCode) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7c702151 | (진입점 미연결) | SCP0031_GlobalPSI.cs:990 | try ▸ if (Int64.Parse(p_to_yyyymmdd) > Int64.Parse(p_plan_end_date)) | FLAG | checkResult | false | 화면 필드/플래그 변경 |  |  |  |
| AC-1ea35efd | (진입점 미연결) | SCP0031_GlobalPSI.cs:996 |  | RETURN | return checkResult; |  | 처리 중단/반환 |  |  |  |

## SCPPlan.GetPeriodRange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23b66678 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1059 | try | FLAG | dtPlanPeriodRange | Data_SCP.Common(Data_SCP.Type.SCPPlanPeriod, false, p_plan_date, p_div, p_bucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-7075ed69 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1059 | try | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SCPPlanPeriod, false, p_plan_date, p_div, p_bucket) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-96294d8e | (진입점 미연결) | SCP0031_GlobalPSI.cs:1062 | try ▸ if (dtPlanPeriodRange != null && dtPlanPeriodRange.Rows.Count > 0) | FLAG | oPlanEndDate | dtPlanPeriodRange.Rows[0]["HORIZON_END_DATE"] | 화면 필드/플래그 변경 |  |  |  |
| AC-4f1734c8 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1063 | try ▸ if (dtPlanPeriodRange != null && dtPlanPeriodRange.Rows.Count > 0) | FLAG | oDiff_Week | dtPlanPeriodRange.Rows[0]["DIFF_WEEK"] | 화면 필드/플래그 변경 |  |  |  |
| AC-bc9d476d | (진입점 미연결) | SCP0031_GlobalPSI.cs:1067 | try ▸ if (dtPlanPeriodRange != null && dtPlanPeriodRange.Rows.Count > 0) ▸ if (oPlanEndDate != null) | FLAG | p_plan_end_date | oPlanEndDate.ToString() | 화면 필드/플래그 변경 |  |  |  |
| AC-6d5e4106 | (진입점 미연결) | SCP0031_GlobalPSI.cs:1071 | try ▸ if (dtPlanPeriodRange != null && dtPlanPeriodRange.Rows.Count > 0) ▸ if (oDiff_Week != null) | FLAG | diff_week | oDiff_Week.ToString() | 화면 필드/플래그 변경 |  |  |  |

