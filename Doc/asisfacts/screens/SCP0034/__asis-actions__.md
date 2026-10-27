# AS-IS 액션 대조표 — SCP0034

> 원천: `Doc/asisfacts/screens/SCP0034/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 143행 · 메서드 29 · 종류 DATA_OP 28 · GRID_INIT 22 · FLAG 12 · GRID_SET 12 · VALUE_SET 11 · LIST_REBIND 9 · UI_PROP 8 · ENDPOINT 7 · UI_MISC 6 · RETURN 6 · POPUP 5 · CALL_EXT 3 · GRID_CLEAR 3 · VALIDATE 3 · MESSAGE 2 · STATE 2 · GRID_BIND 1 · GRID_LOCK 1 · COMBO_DATA 1 · THROW 1 · ⚠ 의미 확인 필요 3


## SCP0034_PSI_Electrode.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d5af770 | this.btnItemId.Click | SCP0034_PSI_Electrode.cs:505 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df7a2a9f | this.btnItemId.Click | SCP0034_PSI_Electrode.cs:509 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e2f12378 | this.btnItemId.Click | SCP0034_PSI_Electrode.cs:511 |  | POPUP | pop.Form_Load | (true, division, pOperationGroup, sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-9069ec4d | this.btnItemId.Click | SCP0034_PSI_Electrode.cs:512 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7ca8fadf | this.btnItemId.Click | SCP0034_PSI_Electrode.cs:513 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b6440fb2 | this.btnItemId.Click | SCP0034_PSI_Electrode.cs:519 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0034_PSI_Electrode.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f313494 | cboPlanDate.SelectedIndexChanged | SCP0034_PSI_Electrode.cs:788 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-dc2bb180 | cboPlanDate.SelectedIndexChanged | SCP0034_PSI_Electrode.cs:790 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-9e3ac7e1 | cboPlanDate.SelectedIndexChanged | SCP0034_PSI_Electrode.cs:791 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0034_PSI_Electrode.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd200c7f | cboPlanSeq.SelectedIndexChanged | SCP0034_PSI_Electrode.cs:803 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0034_PSI_Electrode.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cab0487 | cboPlanType.SelectedIndexChanged | SCP0034_PSI_Electrode.cs:797 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-62469400 | cboPlanType.SelectedIndexChanged | SCP0034_PSI_Electrode.cs:799 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0034_PSI_Electrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19991dd4 | this.Load | SCP0034_PSI_Electrode.cs:234 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-37f7b1a0 | this.Load | SCP0034_PSI_Electrode.cs:235 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-cbbb89ba | this.Load | SCP0034_PSI_Electrode.cs:236 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0034_PSI_Electrode.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b60f41cf | this.Load | SCP0034_PSI_Electrode.cs:174 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-92100317 | this.Load | SCP0034_PSI_Electrode.cs:175 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0034_PSI_Electrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96f7e66b | Dispose | SCP0034_PSI_Electrode.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0034_PSI_Electrode.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-65ec9034 | EditButton | SCP0034_PSI_Electrode.cs:488 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bbf460ec | EditButton | SCP0034_PSI_Electrode.cs:489 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0034_PSI_Electrode.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ea5f85a5 | FindButton | SCP0034_PSI_Electrode.cs:549 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-48d77eb7 | FindButton | SCP0034_PSI_Electrode.cs:549 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-58883a3c | FindButton | SCP0034_PSI_Electrode.cs:550 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-86644528 | FindButton | SCP0034_PSI_Electrode.cs:550 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b243e345 | FindButton | SCP0034_PSI_Electrode.cs:577 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-87f43982 | FindButton | SCP0034_PSI_Electrode.cs:579 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-610ebfe5 | FindButton | SCP0034_PSI_Electrode.cs:582 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-19612c9c | FindButton | SCP0034_PSI_Electrode.cs:584 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5e2314e0 | FindButton | SCP0034_PSI_Electrode.cs:586 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0034_GET_ELECTRODE_PSI") ⇒ SCP.SCP0034_GET_ELECTRODE_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-732c6f99 | FindButton | SCP0034_PSI_Electrode.cs:587 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8c8cf719 | FindButton | SCP0034_PSI_Electrode.cs:588 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-44ae4824 | FindButton | SCP0034_PSI_Electrode.cs:589 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3d9d96e5 | FindButton | SCP0034_PSI_Electrode.cs:590 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-adcf81b8 | FindButton | SCP0034_PSI_Electrode.cs:591 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-155d2a65 | FindButton | SCP0034_PSI_Electrode.cs:592 | try ▸ lambda | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-a085cb0b | FindButton | SCP0034_PSI_Electrode.cs:593 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-fa9ccf0b | FindButton | SCP0034_PSI_Electrode.cs:594 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-06abeaa3 | FindButton | SCP0034_PSI_Electrode.cs:595 | try ▸ lambda | DATA_OP | req.Parameters["p_unit"] | p_unit | 행/컬럼 값 대입 |  |  |  |
| AC-b03f7b15 | FindButton | SCP0034_PSI_Electrode.cs:596 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1fc5cb11 | FindButton | SCP0034_PSI_Electrode.cs:597 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-505ee87e | FindButton | SCP0034_PSI_Electrode.cs:598 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-45d441ae | FindButton | SCP0034_PSI_Electrode.cs:599 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-c341bc4e | FindButton | SCP0034_PSI_Electrode.cs:600 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-2c2ae1c9 | FindButton | SCP0034_PSI_Electrode.cs:601 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-a40b4dab | FindButton | SCP0034_PSI_Electrode.cs:602 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3afa7e92 | FindButton | SCP0034_PSI_Electrode.cs:603 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c43c3bab | FindButton | SCP0034_PSI_Electrode.cs:610 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-b2162baf | FindButton | SCP0034_PSI_Electrode.cs:611 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a697f350 | FindButton | SCP0034_PSI_Electrode.cs:632 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | VALUE_SET | cells.Text | "Sum" | 컨트롤 값 설정 |  |  |  |
| AC-7624a6da | FindButton | SCP0034_PSI_Electrode.cs:633 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ColumnSpan | 3 | 속성 ColumnSpan 설정 |  |  |  |
| AC-19c90018 | FindButton | SCP0034_PSI_Electrode.cs:634 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-8adf5cf0 | FindButton | SCP0034_PSI_Electrode.cs:635 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-db2b3b0d | FindButton | SCP0034_PSI_Electrode.cs:636 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-42307ad4 | FindButton | SCP0034_PSI_Electrode.cs:643 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b6d285e | FindButton | SCP0034_PSI_Electrode.cs:647 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b014edd7 | FindButton | SCP0034_PSI_Electrode.cs:651 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-bd0ba1a0 | FindButton | SCP0034_PSI_Electrode.cs:653 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-92d634d4 | FindButton | SCP0034_PSI_Electrode.cs:655 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-85c636b9 | FindButton | SCP0034_PSI_Electrode.cs:656 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0034_PSI_Electrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbbe6a48 | this.Load | SCP0034_PSI_Electrode.cs:161 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0034_PSI_Electrode.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbf6e45c | this.Load | SCP0034_PSI_Electrode.cs:225 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-375216a3 | this.Load | SCP0034_PSI_Electrode.cs:226 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-90785d6e | this.Load | SCP0034_PSI_Electrode.cs:228 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0034_PSI_Electrode.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7cb824db | this.Load 외 1 | SCP0034_PSI_Electrode.cs:821 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6812b72 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:822 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0034_PSI_Electrode.GetSpdTitle

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f038af1 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:811 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-58e39f9a | this.Load 외 1 | SCP0034_PSI_Electrode.cs:812 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-f4666e28 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:813 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-0b0e1bed | this.Load 외 1 | SCP0034_PSI_Electrode.cs:815 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-8d342bdb | this.Load 외 1 | SCP0034_PSI_Electrode.cs:815 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0034_PSI_Electrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18de6c85 | this.Load | SCP0034_PSI_Electrode.cs:181 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-af912370 | this.Load | SCP0034_PSI_Electrode.cs:184 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-e7f012d4 | this.Load | SCP0034_PSI_Electrode.cs:185 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-4626ed0c | this.Load | SCP0034_PSI_Electrode.cs:186 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-f316f605 | this.Load | SCP0034_PSI_Electrode.cs:189 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-ee6a689e | this.Load | SCP0034_PSI_Electrode.cs:191 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4d2073c5 | this.Load | SCP0034_PSI_Electrode.cs:196 |  | VALUE_SET | cboDivision.ControlValues | "EE" | 컨트롤 값 설정 |  |  |  |
| AC-83eaa1ec | this.Load | SCP0034_PSI_Electrode.cs:197 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-a4686142 | this.Load | SCP0034_PSI_Electrode.cs:202 |  | VALUE_SET | cboOperGroup.ControlValues | "E" | 컨트롤 값 설정 |  |  |  |
| AC-6ef82c31 | this.Load | SCP0034_PSI_Electrode.cs:203 |  | STATE | cboOperGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-30bf0460 | this.Load | SCP0034_PSI_Electrode.cs:210 |  | VALUE_SET | cboUnit.ControlValues | "A" | 컨트롤 값 설정 |  |  |  |
| AC-88c0562e | this.Load | SCP0034_PSI_Electrode.cs:214 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-de90205b | this.Load | SCP0034_PSI_Electrode.cs:215 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1cc3aac8 | this.Load | SCP0034_PSI_Electrode.cs:217 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0034_PSI_Electrode.InitSpread_2

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6111f9d | this.Load 외 1 | SCP0034_PSI_Electrode.cs:242 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-d57dae12 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:247 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-10012d3b | this.Load 외 1 | SCP0034_PSI_Electrode.cs:253 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c7828709 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:254 |  | GRID_INIT | siMain.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0034_PSI_Electrode.InitSpreadDateColumn

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a54c735d | this.Load 외 1 | SCP0034_PSI_Electrode.cs:289 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f27f6b8b | this.Load 외 1 | SCP0034_PSI_Electrode.cs:290 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b7c5a23 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:293 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd83295e | this.Load 외 1 | SCP0034_PSI_Electrode.cs:294 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-47df3870 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:297 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-cfcb3a57 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:303 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9560795d | this.Load 외 1 | SCP0034_PSI_Electrode.cs:304 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-002a545b | this.Load 외 1 | SCP0034_PSI_Electrode.cs:309 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da1da914 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:310 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25c86a6b | this.Load 외 1 | SCP0034_PSI_Electrode.cs:317 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b749de1 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:318 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2dbae21 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:328 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c1b9c24 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:329 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a7745022 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:330 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e63968ca | this.Load 외 1 | SCP0034_PSI_Electrode.cs:331 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshDivision

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5ac9fff | this.Load | SCP0034_PSI_Electrode.cs:353 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshElecType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91060ac8 | this.Load | SCP0034_PSI_Electrode.cs:373 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshFromSite

진입점: this.Load / cboDivision.SelectedIndexChanged / cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bc65d3d | this.Load 외 2 | SCP0034_PSI_Electrode.cs:388 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteEEAll, "OPERATION_GROUP = '" + pOperationGroup + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-49841965 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:388 | if (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtFromSiteEEAll, "OPERATION_GROUP = '" + pOperationGroup + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-49252b6b | this.Load 외 2 | SCP0034_PSI_Electrode.cs:392 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtFromSite | DBUtils.Filter(dtFromSiteAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '" +… | 화면 필드/플래그 변경 |  |  |  |
| AC-5c64417f | this.Load 외 2 | SCP0034_PSI_Electrode.cs:392 | else of (division.Substring(0, 2).Equals("EE")) | DATA_OP | DBUtils.Filter | (dtFromSiteAll, "DIVISION_ID = '" + division + "' AND OPERATION_GROUP = '" + pOperationGro… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-bf3d6f4b | this.Load 외 2 | SCP0034_PSI_Electrode.cs:395 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshOperationGroup

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d3ce1a7a | this.Load | SCP0034_PSI_Electrode.cs:368 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshPlanDate

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e504950 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:404 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-a56e563e | this.Load 외 1 | SCP0034_PSI_Electrode.cs:404 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3d6d5f17 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:408 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | dtPlanDateAll.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-58d08a19 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:408 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dtPlanDateAll.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-19ef69ae | this.Load 외 1 | SCP0034_PSI_Electrode.cs:411 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshPlanSeq

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3b41120 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:444 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeqAll | Data_SCP.CommonAll(Data_SCP.Type.PlanSeq1, false, division, pPlanDate, pPlanType) | 화면 필드/플래그 변경 |  |  |  |
| AC-89fe39bb | this.Load 외 2 | SCP0034_PSI_Electrode.cs:444 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.CommonAll | (Data_SCP.Type.PlanSeq1, false, division, pPlanDate, pPlanType) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3135ea52 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:447 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDa… | 화면 필드/플래그 변경 |  |  |  |
| AC-a6cbd446 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:447 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'AND PLA… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-25cfdd99 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:449 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshPlanType

진입점: this.Load / cboDivision.SelectedIndexChanged / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b982a65 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:421 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanD… | 화면 필드/플래그 변경 |  |  |  |
| AC-04663eef | this.Load 외 2 | SCP0034_PSI_Electrode.cs:421 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + division + "' AND PLANDATE = '" + pPlanDate + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-dd4b4451 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:425 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "PLANDATE = '" + pPlanDate + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-9e549ca6 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:425 | else of (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "PLANDATE = '" + pPlanDate + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-56bc18f5 | this.Load 외 2 | SCP0034_PSI_Electrode.cs:428 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.RefreshUnit

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a9046b3 | this.Load | SCP0034_PSI_Electrode.cs:378 |  | LIST_REBIND | clsCtrl.setListBox | (dtUnit, cboUnit, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0034_PSI_Electrode.Set_Inventories

진입점: FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2987a504 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0034_PSI_Electrode.cs:692 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-8d36c6f6 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0034_PSI_Electrode.cs:699 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-47c4021b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0034_PSI_Electrode.cs:706 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-3957486b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0034_PSI_Electrode.cs:707 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-55715db6 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0034_PSI_Electrode.cs:715 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-86e79a68 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0034_PSI_Electrode.cs:717 | finally | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0034_PSI_Electrode.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3e85b200 | this.Load 외 1 | SCP0034_PSI_Electrode.cs:539 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0034_PSI_Electrode.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8cd957d4 | this.Load 외 3 | SCP0034_PSI_Electrode.cs:733 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a13ef777 | this.Load 외 3 | SCP0034_PSI_Electrode.cs:737 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0ce390e5 | this.Load 외 3 | SCP0034_PSI_Electrode.cs:742 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a4b83b0a | this.Load 외 3 | SCP0034_PSI_Electrode.cs:745 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-70296c21 | this.Load 외 3 | SCP0034_PSI_Electrode.cs:749 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-fc73fac3 | this.Load 외 3 | SCP0034_PSI_Electrode.cs:754 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-204804f8 | this.Load 외 3 | SCP0034_PSI_Electrode.cs:757 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0034_PSI_Electrode.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b137287e | this.spdMain.CellDoubleClick | SCP0034_PSI_Electrode.cs:465 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0034_PSI_Electrode.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2d6ea6c | this.spdMain.TopChange | SCP0034_PSI_Electrode.cs:460 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

