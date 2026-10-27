# AS-IS 액션 대조표 — SCP0044

> 원천: `Doc/asisfacts/screens/SCP0044/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 153행 · 메서드 26 · 종류 DATA_OP 33 · GRID_INIT 21 · GRID_SET 16 · UI_PROP 14 · FLAG 10 · VALUE_SET 8 · POPUP 7 · RETURN 7 · ENDPOINT 7 · LIST_REBIND 7 · UI_MISC 6 · CALL_EXT 5 · GRID_CLEAR 3 · VALIDATE 3 · MESSAGE 2 · GRID_BIND 1 · GRID_LOCK 1 · STATE_RESET 1 · STATE 1 · ⚠ 의미 확인 필요 5


## SCP0044_GlobalPSI_ESS.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d390d37 | this.btnItem_Id.Click | SCP0044_GlobalPSI_ESS.cs:865 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-c0a60298 | this.btnItem_Id.Click | SCP0044_GlobalPSI_ESS.cs:867 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-17471bdc | this.btnItem_Id.Click | SCP0044_GlobalPSI_ESS.cs:868 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6a1df572 | this.btnItem_Id.Click | SCP0044_GlobalPSI_ESS.cs:869 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-df664aa2 | this.btnItem_Id.Click | SCP0044_GlobalPSI_ESS.cs:875 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0044_GlobalPSI_ESS.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-420d27dc | this.btnMeasure.Click | SCP0044_GlobalPSI_ESS.cs:802 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0044", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-85807d95 | this.btnMeasure.Click | SCP0044_GlobalPSI_ESS.cs:803 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cde54b37 | this.btnMeasure.Click | SCP0044_GlobalPSI_ESS.cs:804 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d5420234 | this.btnMeasure.Click | SCP0044_GlobalPSI_ESS.cs:807 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-6d19042d | this.btnMeasure.Click | SCP0044_GlobalPSI_ESS.cs:809 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0044_GlobalPSI_ESS.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54867c47 | cboPlanDate.SelectedIndexChanged | SCP0044_GlobalPSI_ESS.cs:847 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-e9699740 | cboPlanDate.SelectedIndexChanged | SCP0044_GlobalPSI_ESS.cs:849 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-602a2232 | cboPlanDate.SelectedIndexChanged | SCP0044_GlobalPSI_ESS.cs:850 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0044_GlobalPSI_ESS.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed8d68bc | cboPlanSeq.SelectedIndexChanged | SCP0044_GlobalPSI_ESS.cs:341 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0044_GlobalPSI_ESS.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e5138799 | cboPlanType.SelectedIndexChanged | SCP0044_GlobalPSI_ESS.cs:834 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-ce19e40d | cboPlanType.SelectedIndexChanged | SCP0044_GlobalPSI_ESS.cs:837 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0044_GlobalPSI_ESS.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fa1e0a4 | this.Load | SCP0044_GlobalPSI_ESS.cs:230 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0fbfc579 | this.Load | SCP0044_GlobalPSI_ESS.cs:231 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-cdb5ad54 | this.Load | SCP0044_GlobalPSI_ESS.cs:232 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b800bacb | this.Load | SCP0044_GlobalPSI_ESS.cs:165 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-d03e58cc | this.Load | SCP0044_GlobalPSI_ESS.cs:166 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0044_GlobalPSI_ESS.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-016c6914 | Dispose | SCP0044_GlobalPSI_ESS.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0044_GlobalPSI_ESS.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-310cf65f | FindButton | SCP0044_GlobalPSI_ESS.cs:471 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-18e3ac6a | FindButton | SCP0044_GlobalPSI_ESS.cs:476 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-1e90c066 | FindButton | SCP0044_GlobalPSI_ESS.cs:476 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1228d01d | FindButton | SCP0044_GlobalPSI_ESS.cs:477 | try | VALIDATE | SCPPlan.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-4930c512 | FindButton | SCP0044_GlobalPSI_ESS.cs:477 | try ▸ if (!SCPPlan.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-54715875 | FindButton | SCP0044_GlobalPSI_ESS.cs:479 | try | UI_PROP | SCPPlan.p_div | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 속성 p_div 설정 |  |  |  |
| AC-a73a6730 | FindButton | SCP0044_GlobalPSI_ESS.cs:480 | try | UI_PROP | SCPPlan.p_bucket | CString.GetCheckedListValue(dtBucketType, cboBucketType.ControlValues) | 속성 p_bucket 설정 |  |  |  |
| AC-53a3b36e | FindButton | SCP0044_GlobalPSI_ESS.cs:481 | try | UI_PROP | SCPPlan.p_plan_date | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues) | 속성 p_plan_date 설정 |  |  |  |
| AC-aa8c92b5 | FindButton | SCP0044_GlobalPSI_ESS.cs:482 | try | UI_PROP | SCPPlan.p_to_yyyymmdd | dCalendar.Text2.Replace("-", "") | 속성 p_to_yyyymmdd 설정 |  |  |  |
| AC-5de2377d | FindButton | SCP0044_GlobalPSI_ESS.cs:483 | try | CALL_EXT | SCPPlan.CheckPlanPeriodRange | (ref returnMessage, ref plan_end_date) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5fe0488a | FindButton | SCP0044_GlobalPSI_ESS.cs:485 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | MESSAGE | MessageHelper.GMessageBox | (returnMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fd3dba68 | FindButton | SCP0044_GlobalPSI_ESS.cs:486 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | UI_PROP | dCalendar.Text2 | plan_end_date | 속성 Text2 설정 |  |  |  |
| AC-f9c47f38 | FindButton | SCP0044_GlobalPSI_ESS.cs:487 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d00d8dbe | FindButton | SCP0044_GlobalPSI_ESS.cs:491 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-77274a9b | FindButton | SCP0044_GlobalPSI_ESS.cs:514 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a36b71dc | FindButton | SCP0044_GlobalPSI_ESS.cs:516 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-974096fa | FindButton | SCP0044_GlobalPSI_ESS.cs:519 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0044_GET_GLOBAL_PSI_ESS") ⇒ SCP.SCP0044_GET_GLOBAL_PSI_ESS | 엔드포인트 요청 생성 |  |  |  |
| AC-97c445c3 | FindButton | SCP0044_GlobalPSI_ESS.cs:520 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-60699752 | FindButton | SCP0044_GlobalPSI_ESS.cs:521 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2cca4c1a | FindButton | SCP0044_GlobalPSI_ESS.cs:522 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8fa605b7 | FindButton | SCP0044_GlobalPSI_ESS.cs:523 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-14ef1b3b | FindButton | SCP0044_GlobalPSI_ESS.cs:524 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-562962e1 | FindButton | SCP0044_GlobalPSI_ESS.cs:525 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-40fc700c | FindButton | SCP0044_GlobalPSI_ESS.cs:526 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-ae41511b | FindButton | SCP0044_GlobalPSI_ESS.cs:527 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-773eae9f | FindButton | SCP0044_GlobalPSI_ESS.cs:528 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-683e961d | FindButton | SCP0044_GlobalPSI_ESS.cs:529 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-02137746 | FindButton | SCP0044_GlobalPSI_ESS.cs:530 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-8ed5ee3f | FindButton | SCP0044_GlobalPSI_ESS.cs:531 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0044" | 행/컬럼 값 대입 |  |  |  |
| AC-1a63f815 | FindButton | SCP0044_GlobalPSI_ESS.cs:532 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-0d767a9f | FindButton | SCP0044_GlobalPSI_ESS.cs:533 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-1de4098c | FindButton | SCP0044_GlobalPSI_ESS.cs:534 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-ad0dfd7d | FindButton | SCP0044_GlobalPSI_ESS.cs:535 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-77bf0f47 | FindButton | SCP0044_GlobalPSI_ESS.cs:536 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-71369be5 | FindButton | SCP0044_GlobalPSI_ESS.cs:546 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f79c6d20 | FindButton | SCP0044_GlobalPSI_ESS.cs:547 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-03f65f4c | FindButton | SCP0044_GlobalPSI_ESS.cs:548 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-372ddf40 | FindButton | SCP0044_GlobalPSI_ESS.cs:553 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bb0fbd23 | FindButton | SCP0044_GlobalPSI_ESS.cs:555 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c77d4bb0 | FindButton | SCP0044_GlobalPSI_ESS.cs:564 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ecfeae6 | FindButton | SCP0044_GlobalPSI_ESS.cs:566 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0044_GlobalPSI_ESS.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cde020da | this.Load | SCP0044_GlobalPSI_ESS.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0044_GlobalPSI_ESS.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-253d325a | this.Load | SCP0044_GlobalPSI_ESS.cs:753 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-7d07729f | this.Load | SCP0044_GlobalPSI_ESS.cs:754 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-976612d9 | this.Load | SCP0044_GlobalPSI_ESS.cs:756 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0044_GlobalPSI_ESS.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-750fcd15 | this.Load 외 1 | SCP0044_GlobalPSI_ESS.cs:786 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b0cc0a9b | this.Load 외 1 | SCP0044_GlobalPSI_ESS.cs:787 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0044_GlobalPSI_ESS.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdf0d712 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:775 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-717c61ed | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:776 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-37f9be3f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:777 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ef1e2a45 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:779 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-490831cb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:779 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0044_GlobalPSI_ESS.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3e13969 | this.Load | SCP0044_GlobalPSI_ESS.cs:174 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8ffb61c2 | this.Load | SCP0044_GlobalPSI_ESS.cs:175 | if (dtDivision.Rows.Count>0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7da4de2f | this.Load | SCP0044_GlobalPSI_ESS.cs:185 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6b6718e5 | this.Load | SCP0044_GlobalPSI_ESS.cs:186 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b7219e5 | this.Load | SCP0044_GlobalPSI_ESS.cs:187 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-05f2c71a | this.Load | SCP0044_GlobalPSI_ESS.cs:189 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5ccf3c6a | this.Load | SCP0044_GlobalPSI_ESS.cs:193 | if (dtDivision.Rows.Count>0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-c7ba9338 | this.Load | SCP0044_GlobalPSI_ESS.cs:194 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4424db5b | this.Load | SCP0044_GlobalPSI_ESS.cs:196 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00d26d28 | this.Load | SCP0044_GlobalPSI_ESS.cs:198 | if (dtDivision.Rows.Count>0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cf04f986 | this.Load | SCP0044_GlobalPSI_ESS.cs:199 | if (dtDivision.Rows.Count>0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4be1b64f | this.Load | SCP0044_GlobalPSI_ESS.cs:199 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7bfbc071 | this.Load | SCP0044_GlobalPSI_ESS.cs:206 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-463bcee8 | this.Load | SCP0044_GlobalPSI_ESS.cs:209 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-15ada542 | this.Load | SCP0044_GlobalPSI_ESS.cs:210 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-804dc8a2 | this.Load | SCP0044_GlobalPSI_ESS.cs:211 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e4fae6a | this.Load | SCP0044_GlobalPSI_ESS.cs:213 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c4b6154 | this.Load | SCP0044_GlobalPSI_ESS.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-35b01edf | this.Load | SCP0044_GlobalPSI_ESS.cs:217 |  | VALUE_SET | cboDivision.ControlValues | "82" | 컨트롤 값 설정 |  |  |  |
| AC-93f1c411 | this.Load | SCP0044_GlobalPSI_ESS.cs:218 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-13e341b6 | this.Load | SCP0044_GlobalPSI_ESS.cs:222 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-8405c0ee | this.Load | SCP0044_GlobalPSI_ESS.cs:224 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-176ed98e | this.Load | SCP0044_GlobalPSI_ESS.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5037baf8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:239 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-c96af79d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:242 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-f566f533 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:246 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3f320f6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:279 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-df374b08 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:280 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb1cc4db | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:283 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b27beb79 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:284 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-985ed463 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:287 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-45925c08 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:293 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d0b0edf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:294 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e1743e07 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:299 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4ad4136 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:300 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4889b7e9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:307 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bcaeb33c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:308 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-53abb3e6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:318 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3448b07d | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:319 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3c1e20f7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:320 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-389bd7c4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0044_GlobalPSI_ESS.cs:321 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19f69736 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:383 |  | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, "DIVISION_ID ='" + cboDivision.ControlValues + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-9861b84d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:383 |  | DATA_OP | DBUtils.Filter | (dtFromSiteAll, "DIVISION_ID ='" + cboDivision.ControlValues + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2c6d1f04 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:385 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d94aad95 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:398 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID ='" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-29d278c7 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:398 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID ='" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f3cd46e3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:400 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ac898aa | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:422 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID ='" + division + "' AND PLANDATE = '" + pPlanDat… | 화면 필드/플래그 변경 |  |  |  |
| AC-5bbc8927 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:422 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID ='" + division + "' AND PLANDATE = '" + pPlanDate + "'AND PLAN… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cb97d830 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:424 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d51a4254 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:408 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID ='" + division + "' AND PLANDATE = '" + pPlanDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-e50a27e3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:408 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID ='" + division + "' AND PLANDATE = '" + pPlanDate + "'", true… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-484fb951 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:410 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ee73ddf9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0044_GlobalPSI_ESS.cs:413 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0044_GlobalPSI_ESS.RefreshToSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d62fed8 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:390 |  | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, "DIVISION_ID ='" + cboDivision.ControlValues + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8c365342 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:390 |  | DATA_OP | DBUtils.Filter | (dtToSiteAll, "DIVISION_ID ='" + cboDivision.ControlValues + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9ddcfffb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0044_GlobalPSI_ESS.cs:392 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0044_GlobalPSI_ESS.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37bdf272 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:730 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9a61851d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:742 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-73c4c62a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:746 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0044_GlobalPSI_ESS.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a476f31 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:586 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-960cd9cb | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:590 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d1ba3dd5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:668 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxWeek] | weekSum / nCntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-460602f1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:680 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxMonth] | monthSum / nCntDayOfMonth | 그리드 속성/값 설정 |  |  |  |
| AC-5e68b1d6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:694 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-6e3dffe9 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:702 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-5415ea73 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:712 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-534dcdbf | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:713 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-7dbff17f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:721 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-b1c609f2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0044_GlobalPSI_ESS.cs:722 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SCP0044_GlobalPSI_ESS.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c33e74e7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:351 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6c495126 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:355 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e1954b75 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:360 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-777c94c8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:363 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-383a9afc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:367 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-67c694cd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:372 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-56337f3b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0044_GlobalPSI_ESS.cs:376 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0044_GlobalPSI_ESS.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d224385d | this.spdMain.CellDoubleClick | SCP0044_GlobalPSI_ESS.cs:765 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0044_GlobalPSI_ESS.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb768b5d | this.spdMain.TopChange | SCP0044_GlobalPSI_ESS.cs:794 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

