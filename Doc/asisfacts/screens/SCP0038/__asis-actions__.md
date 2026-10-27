# AS-IS 액션 대조표 — SCP0038

> 원천: `Doc/asisfacts/screens/SCP0038/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 151행 · 메서드 28 · 종류 DATA_OP 28 · GRID_INIT 21 · UI_PROP 14 · GRID_SET 14 · FLAG 11 · VALUE_SET 9 · ENDPOINT 9 · LIST_REBIND 9 · RETURN 8 · POPUP 7 · UI_MISC 6 · GRID_CLEAR 3 · VALIDATE 3 · CALL_EXT 3 · MESSAGE 2 · GRID_BIND 1 · GRID_LOCK 1 · STATE 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 3


## SCP0038_GlobalPSI_small.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f97544f | this.btnItem_Id.Click | SCP0038_GlobalPSI_small.cs:889 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-00f81865 | this.btnItem_Id.Click | SCP0038_GlobalPSI_small.cs:891 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-10740003 | this.btnItem_Id.Click | SCP0038_GlobalPSI_small.cs:892 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c1496158 | this.btnItem_Id.Click | SCP0038_GlobalPSI_small.cs:893 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d2663000 | this.btnItem_Id.Click | SCP0038_GlobalPSI_small.cs:899 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0038_GlobalPSI_small.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ca32806 | this.btnMeasure.Click | SCP0038_GlobalPSI_small.cs:833 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0038", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-2e0333e0 | this.btnMeasure.Click | SCP0038_GlobalPSI_small.cs:834 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-4f297e68 | this.btnMeasure.Click | SCP0038_GlobalPSI_small.cs:835 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e3547513 | this.btnMeasure.Click | SCP0038_GlobalPSI_small.cs:838 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-a26ddee8 | this.btnMeasure.Click | SCP0038_GlobalPSI_small.cs:840 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0038_GlobalPSI_small.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aae2adbd | cboPlanDate.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:874 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-32b2ff11 | cboPlanDate.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:875 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0038_GlobalPSI_small.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-93604405 | cboPlanSeq.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:327 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0038_GlobalPSI_small.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da58493a | cboPlanType.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:861 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-7015943e | cboPlanType.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:864 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0038_GlobalPSI_small.clbFromSite_SelectedIndexChanged

진입점: clbFromSite.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dcc5823 | clbFromSite.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:335 | if (clbFromSite.ControlValues != null && !clbFromSite.ControlValues.Equals("ALL")) | VALUE_SET | lblItemId.Text | "Material" | 컨트롤 값 설정 |  |  |  |
| AC-d0697256 | clbFromSite.SelectedIndexChanged | SCP0038_GlobalPSI_small.cs:339 | else of (clbFromSite.ControlValues != null && !clbFromSite.ControlValues.Equals("ALL")) | VALUE_SET | lblItemId.Text | "Material*" | 컨트롤 값 설정 |  |  |  |

## SCP0038_GlobalPSI_small.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b1581b8 | this.Load | SCP0038_GlobalPSI_small.cs:215 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6a37f361 | this.Load | SCP0038_GlobalPSI_small.cs:216 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0ad789a | this.Load | SCP0038_GlobalPSI_small.cs:217 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0038_GlobalPSI_small.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da62e103 | this.Load | SCP0038_GlobalPSI_small.cs:166 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-856a3b9c | this.Load | SCP0038_GlobalPSI_small.cs:170 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0038_GlobalPSI_small.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c83f453 | Dispose | SCP0038_GlobalPSI_small.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0038_GlobalPSI_small.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd7ab9d9 | FindButton | SCP0038_GlobalPSI_small.cs:479 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-3fe3ef4e | FindButton | SCP0038_GlobalPSI_small.cs:484 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-6a4439bd | FindButton | SCP0038_GlobalPSI_small.cs:484 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a0fe3e9f | FindButton | SCP0038_GlobalPSI_small.cs:485 | try | VALIDATE | SCPPlan.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-97dd2ecb | FindButton | SCP0038_GlobalPSI_small.cs:485 | try ▸ if (!SCPPlan.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a002f4f | FindButton | SCP0038_GlobalPSI_small.cs:487 | try | UI_PROP | SCPPlan.p_div | CString.GetCheckedListValue(dtDivision, cboDivision.ControlValues) | 속성 p_div 설정 |  |  |  |
| AC-8646b7cf | FindButton | SCP0038_GlobalPSI_small.cs:488 | try | UI_PROP | SCPPlan.p_bucket | CString.GetCheckedListValue(dtBucketType, cboBucketType.ControlValues) | 속성 p_bucket 설정 |  |  |  |
| AC-458915db | FindButton | SCP0038_GlobalPSI_small.cs:489 | try | UI_PROP | SCPPlan.p_plan_date | CString.GetCheckedListValue(dtPlanDate, cboPlanDate.ControlValues) | 속성 p_plan_date 설정 |  |  |  |
| AC-28db4542 | FindButton | SCP0038_GlobalPSI_small.cs:490 | try | UI_PROP | SCPPlan.p_to_yyyymmdd | dCalendar.Text2.Replace("-", "") | 속성 p_to_yyyymmdd 설정 |  |  |  |
| AC-8001b693 | FindButton | SCP0038_GlobalPSI_small.cs:491 | try | CALL_EXT | SCPPlan.CheckPlanPeriodRange | (ref returnMessage, ref plan_end_date) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d456eeb | FindButton | SCP0038_GlobalPSI_small.cs:493 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | MESSAGE | MessageHelper.GMessageBox | (returnMessage) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7af8c80 | FindButton | SCP0038_GlobalPSI_small.cs:494 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | UI_PROP | dCalendar.Text2 | plan_end_date | 속성 Text2 설정 |  |  |  |
| AC-c3ca91cb | FindButton | SCP0038_GlobalPSI_small.cs:495 | try ▸ if (SCPPlan.CheckPlanPeriodRange(ref returnMessage, ref plan_end_date) == false) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d6262f3a | FindButton | SCP0038_GlobalPSI_small.cs:499 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9cb1effa | FindButton | SCP0038_GlobalPSI_small.cs:524 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-029f4cff | FindButton | SCP0038_GlobalPSI_small.cs:526 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e382a2c1 | FindButton | SCP0038_GlobalPSI_small.cs:529 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0038_GET_GLOBAL_PSI_SMALL") ⇒ SCP.SCP0038_GET_GLOBAL_PSI_SMALL | 엔드포인트 요청 생성 |  |  |  |
| AC-f3abfeac | FindButton | SCP0038_GlobalPSI_small.cs:530 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-945e3f88 | FindButton | SCP0038_GlobalPSI_small.cs:531 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-96b8424a | FindButton | SCP0038_GlobalPSI_small.cs:532 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e33b073e | FindButton | SCP0038_GlobalPSI_small.cs:533 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1892b32a | FindButton | SCP0038_GlobalPSI_small.cs:534 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-fddc3e12 | FindButton | SCP0038_GlobalPSI_small.cs:535 | try ▸ lambda | DATA_OP | req.Parameters["p_cell_type"] | p_cell_type | 행/컬럼 값 대입 |  |  |  |
| AC-208f8b39 | FindButton | SCP0038_GlobalPSI_small.cs:536 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-68b7e124 | FindButton | SCP0038_GlobalPSI_small.cs:537 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-3f311adb | FindButton | SCP0038_GlobalPSI_small.cs:538 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a1c58f33 | FindButton | SCP0038_GlobalPSI_small.cs:539 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-f6d28484 | FindButton | SCP0038_GlobalPSI_small.cs:540 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6f10fe97 | FindButton | SCP0038_GlobalPSI_small.cs:541 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-3dc06e72 | FindButton | SCP0038_GlobalPSI_small.cs:542 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-3d4e1034 | FindButton | SCP0038_GlobalPSI_small.cs:543 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0038" | 행/컬럼 값 대입 |  |  |  |
| AC-dee87414 | FindButton | SCP0038_GlobalPSI_small.cs:544 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-aeecf210 | FindButton | SCP0038_GlobalPSI_small.cs:545 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6338577f | FindButton | SCP0038_GlobalPSI_small.cs:546 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-bc411d3a | FindButton | SCP0038_GlobalPSI_small.cs:547 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-620c479a | FindButton | SCP0038_GlobalPSI_small.cs:548 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-8820f70b | FindButton | SCP0038_GlobalPSI_small.cs:558 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b52189bc | FindButton | SCP0038_GlobalPSI_small.cs:559 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-795ac07b | FindButton | SCP0038_GlobalPSI_small.cs:560 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f9d4fd2e | FindButton | SCP0038_GlobalPSI_small.cs:565 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-2a14dacf | FindButton | SCP0038_GlobalPSI_small.cs:567 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-659d9791 | FindButton | SCP0038_GlobalPSI_small.cs:576 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-edde2296 | FindButton | SCP0038_GlobalPSI_small.cs:578 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0038_GlobalPSI_small.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12fd7b0d | this.Load | SCP0038_GlobalPSI_small.cs:155 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0038_GlobalPSI_small.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58ec280c | this.Load | SCP0038_GlobalPSI_small.cs:764 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-d9a3a720 | this.Load | SCP0038_GlobalPSI_small.cs:765 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-10657bb4 | this.Load | SCP0038_GlobalPSI_small.cs:767 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0038_GlobalPSI_small.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b8d960b | this.Load 외 1 | SCP0038_GlobalPSI_small.cs:817 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40c2ae2d | this.Load 외 1 | SCP0038_GlobalPSI_small.cs:818 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0038_GlobalPSI_small.GetEm0101

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-340f2244 | this.Load | SCP0038_GlobalPSI_small.cs:789 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0038_GET_CELLTYPE_EM0101") ⇒ SCP.SCP0038_GET_CELLTYPE_EM0101 | 엔드포인트 요청 생성 |  |  |  |
| AC-014e8c34 | this.Load | SCP0038_GlobalPSI_small.cs:791 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c894ead4 | this.Load | SCP0038_GlobalPSI_small.cs:793 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ffd1c7ae | this.Load | SCP0038_GlobalPSI_small.cs:797 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0038_GlobalPSI_small.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b26468d3 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:806 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-cfa41090 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:807 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1b6a35f8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:808 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-981ac39c | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:810 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-71a54500 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:810 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0038_GlobalPSI_small.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d875b3a0 | this.Load | SCP0038_GlobalPSI_small.cs:177 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-72d404cc | this.Load | SCP0038_GlobalPSI_small.cs:180 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb562861 | this.Load | SCP0038_GlobalPSI_small.cs:181 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-fbaed873 | this.Load | SCP0038_GlobalPSI_small.cs:182 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-c64dab94 | this.Load | SCP0038_GlobalPSI_small.cs:184 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-1fb91dce | this.Load | SCP0038_GlobalPSI_small.cs:186 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9840a742 | this.Load | SCP0038_GlobalPSI_small.cs:188 |  | VALUE_SET | cboDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-60cb3fc1 | this.Load | SCP0038_GlobalPSI_small.cs:189 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-cc8d368a | this.Load | SCP0038_GlobalPSI_small.cs:193 |  | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-d119a091 | this.Load | SCP0038_GlobalPSI_small.cs:193 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-48718225 | this.Load | SCP0038_GlobalPSI_small.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-e8867df0 | this.Load | SCP0038_GlobalPSI_small.cs:198 |  | FLAG | dtCellTypeEM0101 | GetEm0101() | 화면 필드/플래그 변경 |  |  |  |
| AC-daf66989 | this.Load | SCP0038_GlobalPSI_small.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtCellTypeEM0101, cboCellTypeGr, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-9d024dfd | this.Load | SCP0038_GlobalPSI_small.cs:207 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-be4fe64e | this.Load | SCP0038_GlobalPSI_small.cs:209 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-536dfb4b | this.Load | SCP0038_GlobalPSI_small.cs:210 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0038_GlobalPSI_small.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23cffb0a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:224 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-d24bd19a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:227 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-07e634d6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:231 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0038_GlobalPSI_small.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bdc33da | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:264 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4d35df83 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:265 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-904658ec | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:268 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cd43844 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:269 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-07d39e70 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:272 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-0f1ac180 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:278 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc647d68 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:279 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39a14abf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:284 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd3be9c0 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:285 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c00ec2f6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:292 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae6e5c40 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:293 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b33afcc2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:303 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c9e385a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:304 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-838e4496 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:305 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8351d53 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 2 | SCP0038_GlobalPSI_small.cs:306 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0038_GlobalPSI_small.RefreshFromSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a039f2f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:384 |  | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, "DIVISION_ID = '" + cboDivision.ControlValues + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-dfaeef11 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:384 |  | DATA_OP | DBUtils.Filter | (dtFromSiteAll, "DIVISION_ID = '" + cboDivision.ControlValues + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2b312e6f | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:386 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0038_GlobalPSI_small.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-33355dda | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:399 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-08d86342 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:399 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2f74acb2 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:401 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0038_GlobalPSI_small.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2acf9d9 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:422 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE= '" + pPlanDat… | 화면 필드/플래그 변경 |  |  |  |
| AC-b5e14c92 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:422 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE= '" + pPlanDate + "' AND PLA… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f4224d7d | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:424 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0038_GlobalPSI_small.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-38154dbb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:408 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE= '" + pPlanDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-1b858725 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:408 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE= '" + pPlanDate + "'", true… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e38e94bb | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:410 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-690f729a | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0038_GlobalPSI_small.cs:413 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0038_GlobalPSI_small.RefreshToSite

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e2eb2a3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:391 |  | FLAG | dtToSite | DBUtils.Filter(dtToSiteAll, "DIVISION_ID = '" + cboDivision.ControlValues + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-ba1196fe | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:391 |  | DATA_OP | DBUtils.Filter | (dtToSiteAll, "DIVISION_ID = '" + cboDivision.ControlValues + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9e4016bf | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0038_GlobalPSI_small.cs:393 |  | LIST_REBIND | clsCtrl.setListBox | (dtToSite, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0038_GlobalPSI_small.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-261d6d53 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:740 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c38c04ff | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:752 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-fc05cc2d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:756 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0038_GlobalPSI_small.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-45d7d58d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:599 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-01358d85 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:603 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-dce8fcfe | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:681 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxWeek] | weekSum / nCntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-5ff83bb7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:693 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxMonth] | monthSum / nCntDayOfMonth | 그리드 속성/값 설정 |  |  |  |
| AC-fb219490 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:707 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-7f87254c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:715 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-abaff208 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:725 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-3a56b075 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0038_GlobalPSI_small.cs:726 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |

## SCP0038_GlobalPSI_small.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88807c51 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:351 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-71eebbc7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:355 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-3dffbe4b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:360 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2abe7b0b | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:363 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f3d3ee12 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:367 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8371ea9f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:372 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-57be1fdc | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0038_GlobalPSI_small.cs:376 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0038_GlobalPSI_small.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-153bdd35 | this.spdMain.CellDoubleClick | SCP0038_GlobalPSI_small.cs:776 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0038_GlobalPSI_small.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-374ff336 | this.spdMain.TopChange | SCP0038_GlobalPSI_small.cs:825 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

