# AS-IS 액션 대조표 — SCP0070

> 원천: `Doc/asisfacts/screens/SCP0070/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 286행 · 메서드 26 · 종류 GRID_SET 87 · DATA_OP 54 · GRID_INIT 24 · RETURN 18 · FLAG 15 · ENDPOINT 15 · UI_PROP 13 · UI_MISC 11 · LIST_REBIND 8 · VALUE_SET 8 · CALL_EXT 7 · MESSAGE 6 · COMBO_DATA 5 · GRID_CLEAR 3 · POPUP 2 · VALIDATE 2 · GRID_STYLE 2 · LIST_BIND 2 · CALL_BASE 1 · GRID_BIND 1 · GRID_LOCK 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 8


## SCP0070_DemandRTF_Balance.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-883cdaf1 | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1372 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-c2f6edbf | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1372 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5538e2e | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1373 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0f917e69 | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1375 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-55219592 | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1378 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-3ba8c717 | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1379 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-80683ee8 | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1382 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-47589aa3 | cboPlanDate.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1383 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0070_DemandRTF_Balance.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bd63f46e | cboPlanSeq.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:349 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0070_DemandRTF_Balance.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-accda397 | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1354 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f546835 | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1354 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-769fe497 | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1355 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b9873ad1 | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1357 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-3754409f | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1360 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-1658b2ac | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1363 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5f2b912d | cboPlanType.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:1364 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0070_DemandRTF_Balance.cboQTY_SelectedIndexChanged

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a384bfaa | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:398 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0070_DemandRTF_Balance.Check_PeriodDate

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-541d8da6 | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1286 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cafdffa2 | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1287 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eaa0715c | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1296 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f491a43 | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1297 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-8e1fe638 | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1305 | try ▸ if (nDate2 >= nDate1After1Year) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00172", new object[] { ((82 * 7 - 1) + 7).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-127aa8c3 | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1306 | try ▸ if (nDate2 >= nDate1After1Year) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-e1ccc4f5 | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1311 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0b9e5e5f | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1312 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-2b1069db | FindButton [try] | SCP0070_DemandRTF_Balance.cs:1315 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0070_DemandRTF_Balance.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c064ccf6 | this.Load | SCP0070_DemandRTF_Balance.cs:238 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7c8f0b71 | this.Load | SCP0070_DemandRTF_Balance.cs:239 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-6b580510 | this.Load | SCP0070_DemandRTF_Balance.cs:240 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0070_DemandRTF_Balance.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b8e8175 | this.Load | SCP0070_DemandRTF_Balance.cs:169 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-b03c39d6 | this.Load | SCP0070_DemandRTF_Balance.cs:170 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0070_DemandRTF_Balance.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-364d2895 | Dispose | SCP0070_DemandRTF_Balance.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0070_DemandRTF_Balance.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7833a0ef | ExcelButton | SCP0070_DemandRTF_Balance.cs:716 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0070_DemandRTF_Balance.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48da1f74 | FindButton | SCP0070_DemandRTF_Balance.cs:725 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b3d2b84f | FindButton | SCP0070_DemandRTF_Balance.cs:730 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-fb28468b | FindButton | SCP0070_DemandRTF_Balance.cs:730 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55add67c | FindButton | SCP0070_DemandRTF_Balance.cs:731 | try ▸ if (!Check_PeriodDate(dCalendar, PeriodType.W82)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-16c10d6f | FindButton | SCP0070_DemandRTF_Balance.cs:734 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-a8568e61 | FindButton | SCP0070_DemandRTF_Balance.cs:757 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-cf8e5b24 | FindButton | SCP0070_DemandRTF_Balance.cs:760 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-905db663 | FindButton | SCP0070_DemandRTF_Balance.cs:765 | try ▸ lambda ▸ if (division.Equals("81")) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_DEMAND_RTF_BALANCE_81") ⇒ SCP.SCP0070_GET_DEMAND_RTF_BALANCE_81 | 엔드포인트 요청 생성 |  |  |  |
| AC-f13d9951 | FindButton | SCP0070_DemandRTF_Balance.cs:766 | try ▸ lambda ▸ if (division.Equals("81")) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-86a5d708 | FindButton | SCP0070_DemandRTF_Balance.cs:767 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a79d72b9 | FindButton | SCP0070_DemandRTF_Balance.cs:768 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-80bb113f | FindButton | SCP0070_DemandRTF_Balance.cs:769 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e4a58267 | FindButton | SCP0070_DemandRTF_Balance.cs:772 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (RdoType.Checked) | DATA_OP | req.Parameters["p_production_flag"] | "TYPE" | 행/컬럼 값 대입 |  |  |  |
| AC-fba29cb5 | FindButton | SCP0070_DemandRTF_Balance.cs:776 | try ▸ lambda ▸ if (division.Equals("81")) ▸ else of (RdoType.Checked) | DATA_OP | req.Parameters["p_production_flag"] | "NAME" | 행/컬럼 값 대입 |  |  |  |
| AC-dfc44775 | FindButton | SCP0070_DemandRTF_Balance.cs:778 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4e8d0b4a | FindButton | SCP0070_DemandRTF_Balance.cs:779 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b74e63ee | FindButton | SCP0070_DemandRTF_Balance.cs:780 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-66416690 | FindButton | SCP0070_DemandRTF_Balance.cs:781 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_program_id"] | "SCP0070" | 행/컬럼 값 대입 |  |  |  |
| AC-bf40a434 | FindButton | SCP0070_DemandRTF_Balance.cs:782 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-f3555158 | FindButton | SCP0070_DemandRTF_Balance.cs:783 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-6a75bc03 | FindButton | SCP0070_DemandRTF_Balance.cs:784 | try ▸ lambda ▸ if (division.Equals("81")) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-71b3f30a | FindButton | SCP0070_DemandRTF_Balance.cs:789 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("DIV")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f274cc2d | FindButton | SCP0070_DemandRTF_Balance.cs:790 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a4af7e9a | FindButton | SCP0070_DemandRTF_Balance.cs:793 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ if (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-99b647c1 | FindButton | SCP0070_DemandRTF_Balance.cs:794 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ if (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-76a7e996 | FindButton | SCP0070_DemandRTF_Balance.cs:798 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ else of (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-76d65e94 | FindButton | SCP0070_DemandRTF_Balance.cs:799 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ else of (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6cb480ae | FindButton | SCP0070_DemandRTF_Balance.cs:801 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-94ad3399 | FindButton | SCP0070_DemandRTF_Balance.cs:802 | try ▸ lambda ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SOLDTO_CUSTOMER")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7664e961 | FindButton | SCP0070_DemandRTF_Balance.cs:804 | try ▸ lambda ▸ if (division.Equals("81")) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-290a8b3b | FindButton | SCP0070_DemandRTF_Balance.cs:805 | try ▸ lambda ▸ if (division.Equals("81")) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-9d733fca | FindButton | SCP0070_DemandRTF_Balance.cs:809 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_DEMAND_RTF_BALANCE_82") ⇒ SCP.SCP0070_GET_DEMAND_RTF_BALANCE_82 | 엔드포인트 요청 생성 |  |  |  |
| AC-4ba3f251 | FindButton | SCP0070_DemandRTF_Balance.cs:810 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-09c9d229 | FindButton | SCP0070_DemandRTF_Balance.cs:811 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-50bc845f | FindButton | SCP0070_DemandRTF_Balance.cs:812 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2e53d28c | FindButton | SCP0070_DemandRTF_Balance.cs:813 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-9cc90d18 | FindButton | SCP0070_DemandRTF_Balance.cs:814 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4cbe1b1c | FindButton | SCP0070_DemandRTF_Balance.cs:815 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-2658a19b | FindButton | SCP0070_DemandRTF_Balance.cs:816 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-7f405658 | FindButton | SCP0070_DemandRTF_Balance.cs:817 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_program_id"] | "SCP0070" | 행/컬럼 값 대입 |  |  |  |
| AC-e089564d | FindButton | SCP0070_DemandRTF_Balance.cs:818 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-07f5286c | FindButton | SCP0070_DemandRTF_Balance.cs:819 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-55639e40 | FindButton | SCP0070_DemandRTF_Balance.cs:820 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-558c69cd | FindButton | SCP0070_DemandRTF_Balance.cs:824 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c9f3d5e0 | FindButton | SCP0070_DemandRTF_Balance.cs:825 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ffb84bf6 | FindButton | SCP0070_DemandRTF_Balance.cs:826 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-901c566c | FindButton | SCP0070_DemandRTF_Balance.cs:827 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e5f01246 | FindButton | SCP0070_DemandRTF_Balance.cs:828 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SOLDTO_CUSTOMER")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5a8f2512 | FindButton | SCP0070_DemandRTF_Balance.cs:830 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cc4ae22f | FindButton | SCP0070_DemandRTF_Balance.cs:831 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-7a57313a | FindButton | SCP0070_DemandRTF_Balance.cs:834 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_DEMAND_RTF_BALANCE_40") ⇒ SCP.SCP0070_GET_DEMAND_RTF_BALANCE_40 | 엔드포인트 요청 생성 |  |  |  |
| AC-5403963c | FindButton | SCP0070_DemandRTF_Balance.cs:835 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-261a6893 | FindButton | SCP0070_DemandRTF_Balance.cs:836 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0fcc6131 | FindButton | SCP0070_DemandRTF_Balance.cs:837 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d032443f | FindButton | SCP0070_DemandRTF_Balance.cs:838 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-013c4e54 | FindButton | SCP0070_DemandRTF_Balance.cs:839 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f5103f1d | FindButton | SCP0070_DemandRTF_Balance.cs:840 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-becc5261 | FindButton | SCP0070_DemandRTF_Balance.cs:841 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-75c6e195 | FindButton | SCP0070_DemandRTF_Balance.cs:842 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_program_id"] | "SCP0070" | 행/컬럼 값 대입 |  |  |  |
| AC-c079f7f9 | FindButton | SCP0070_DemandRTF_Balance.cs:843 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-235c3982 | FindButton | SCP0070_DemandRTF_Balance.cs:844 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-5b7ec210 | FindButton | SCP0070_DemandRTF_Balance.cs:845 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-8e7f3a8a | FindButton | SCP0070_DemandRTF_Balance.cs:849 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CLASS_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-826d9cba | FindButton | SCP0070_DemandRTF_Balance.cs:850 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-15b96d8a | FindButton | SCP0070_DemandRTF_Balance.cs:851 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7174066f | FindButton | SCP0070_DemandRTF_Balance.cs:852 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-0a88b934 | FindButton | SCP0070_DemandRTF_Balance.cs:853 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SOLDTO_CUSTOMER")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-29e1ca06 | FindButton | SCP0070_DemandRTF_Balance.cs:855 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b5ff858 | FindButton | SCP0070_DemandRTF_Balance.cs:856 | try ▸ lambda ▸ else of (division.Equals("81")) ▸ else of (division.Equals("82")) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-e9b50747 | FindButton | SCP0070_DemandRTF_Balance.cs:869 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-12b81af8 | FindButton | SCP0070_DemandRTF_Balance.cs:872 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-71571447 | FindButton | SCP0070_DemandRTF_Balance.cs:875 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-4b3ffee8 | FindButton | SCP0070_DemandRTF_Balance.cs:876 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-1bac365c | FindButton | SCP0070_DemandRTF_Balance.cs:878 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9f4b13ec | FindButton | SCP0070_DemandRTF_Balance.cs:880 | try ▸ if (division.Equals("81")) | VALUE_SET | cboQTY.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-28e19aa5 | FindButton | SCP0070_DemandRTF_Balance.cs:882 | try ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | VALUE_SET | cboQTY.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-2578dc08 | FindButton | SCP0070_DemandRTF_Balance.cs:890 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9c5125f5 | FindButton | SCP0070_DemandRTF_Balance.cs:893 | try | CALL_EXT | siMain.RightColMerge | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-59a4a59f | FindButton | SCP0070_DemandRTF_Balance.cs:902 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d2768fb | FindButton | SCP0070_DemandRTF_Balance.cs:904 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0070_DemandRTF_Balance.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec909e11 | this.Load | SCP0070_DemandRTF_Balance.cs:154 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fe7fbe80 | this.Load | SCP0070_DemandRTF_Balance.cs:161 | if (siMain != null) | GRID_STYLE | siMain.ActiveSheet.SetColumnVisible | (3, false) | 그리드 표시 설정 |  |  |  |
| AC-dca01439 | this.Load | SCP0070_DemandRTF_Balance.cs:162 | if (siMain != null) | GRID_STYLE | siMain.ActiveSheet.SetColumnVisible | (4, false) | 그리드 표시 설정 |  |  |  |

## SCP0070_DemandRTF_Balance.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24153351 | this.Load | SCP0070_DemandRTF_Balance.cs:1209 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_BUCKET_TYPE_CODE") ⇒ SCP.SCP0070_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-ec43d2a2 | this.Load | SCP0070_DemandRTF_Balance.cs:1210 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2725f930 | this.Load | SCP0070_DemandRTF_Balance.cs:1212 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0070_DemandRTF_Balance.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2482794a | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1252 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0997c84d | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1253 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-2509b945 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1263 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-d8aa55cb | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1264 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-43c3b290 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1265 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-e618b382 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1266 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-761e705a | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1267 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2e7fbff | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1269 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0070_DemandRTF_Balance.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef7a3ce3 | this.Load | SCP0070_DemandRTF_Balance.cs:1221 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_QTY_TYPE_CODE") ⇒ SCP.SCP0070_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-6f627a9f | this.Load | SCP0070_DemandRTF_Balance.cs:1222 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0ab7f26e | this.Load | SCP0070_DemandRTF_Balance.cs:1225 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0070_DemandRTF_Balance.GetSpdTitle

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fa33e78 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1242 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-81a1e84c | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1243 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7f1bee76 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1244 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-6c97d160 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1246 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-69983e9d | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:1246 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0070_DemandRTF_Balance.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2da2eb85 | this.Load | SCP0070_DemandRTF_Balance.cs:178 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e8074b3a | this.Load | SCP0070_DemandRTF_Balance.cs:179 | if (dtDivision.Rows.Count>0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-8e734ab3 | this.Load | SCP0070_DemandRTF_Balance.cs:189 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-90985871 | this.Load | SCP0070_DemandRTF_Balance.cs:190 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-e761dadf | this.Load | SCP0070_DemandRTF_Balance.cs:191 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-501f5b18 | this.Load | SCP0070_DemandRTF_Balance.cs:193 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0091baed | this.Load | SCP0070_DemandRTF_Balance.cs:197 | if (dtDivision.Rows.Count>0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-8e7d7125 | this.Load | SCP0070_DemandRTF_Balance.cs:198 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0d80c18f | this.Load | SCP0070_DemandRTF_Balance.cs:200 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5f7d061e | this.Load | SCP0070_DemandRTF_Balance.cs:202 | if (dtDivision.Rows.Count>0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cbfafeff | this.Load | SCP0070_DemandRTF_Balance.cs:203 | if (dtDivision.Rows.Count>0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-1b94deb8 | this.Load | SCP0070_DemandRTF_Balance.cs:203 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-61f30bf2 | this.Load | SCP0070_DemandRTF_Balance.cs:210 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-a656633a | this.Load | SCP0070_DemandRTF_Balance.cs:213 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-a84aaf84 | this.Load | SCP0070_DemandRTF_Balance.cs:214 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b2e9704 | this.Load | SCP0070_DemandRTF_Balance.cs:215 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e1d5711 | this.Load | SCP0070_DemandRTF_Balance.cs:217 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-312d7b6c | this.Load | SCP0070_DemandRTF_Balance.cs:219 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c5ac2649 | this.Load | SCP0070_DemandRTF_Balance.cs:227 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-919dfd1b | this.Load | SCP0070_DemandRTF_Balance.cs:229 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6043ec2d | this.Load | SCP0070_DemandRTF_Balance.cs:230 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-79bf5ada | this.Load | SCP0070_DemandRTF_Balance.cs:232 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-335fdfa1 | this.Load | SCP0070_DemandRTF_Balance.cs:233 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0070_DemandRTF_Balance.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4cb9980a | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:247 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-3707aebf | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:250 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-abd8a9bb | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:254 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0070_DemandRTF_Balance.InitSpreadDateColumn

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9482d35e | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:287 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4ad92430 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:288 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-842a4d0b | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:291 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbb57e07 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:292 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d9b8f98a | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:301 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5adf5cc | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:302 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2a527c80 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:307 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3cc9a362 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:308 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4765eb02 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:315 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04d5e32b | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:316 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76589c55 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:326 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6e6e8290 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:327 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4931f14c | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:328 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-597978bb | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:329 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0070_DemandRTF_Balance.RdoType_CheckedChanged

진입점: RdoType.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee04d53c | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:358 |  | CALL_EXT | siMain.SpreadInit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bf8ebbf9 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:361 | if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("DIV")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a5b01c33 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:367 | if (siMain != null) ▸ if (division.Equals("81")) ▸ if (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5d34507f | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:368 | if (siMain != null) ▸ if (division.Equals("81")) ▸ if (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d7f3160c | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:372 | if (siMain != null) ▸ if (division.Equals("81")) ▸ else of (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b6e7790f | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:373 | if (siMain != null) ▸ if (division.Equals("81")) ▸ else of (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-08474ea2 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:375 | if (siMain != null) ▸ if (division.Equals("81")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d40cd249 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:381 | if (siMain != null) ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a954ea92 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:382 | if (siMain != null) ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ if (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-36d63828 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:386 | if (siMain != null) ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ else of (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e47129a1 | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:387 | if (siMain != null) ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) ▸ else of (RdoType.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bf2ee07c | RdoType.CheckedChanged | SCP0070_DemandRTF_Balance.cs:389 | if (siMain != null) ▸ else of (division.Equals("81")) ▸ if (division.Equals("82")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0070_DemandRTF_Balance.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b96a1e1f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1187 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bde6a478 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1199 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-4e615ff7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1203 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0070_DemandRTF_Balance.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a874bcc | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:928 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Y_") == 0) | DATA_OP | listYear.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-3bd7a7c0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:932 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Q_") == 0) | DATA_OP | listQuater.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-ff6c3366 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:936 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-28f2dbe7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:940 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-b8b6b444 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:976 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-cc2b83b4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:996 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-cf4b5f52 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1012 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-17ee3620 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1027 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-ec6ab774 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1065 | try ▸ for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumMKT_FCST | 그리드 속성/값 설정 |  |  |  |
| AC-c0f793d1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1066 | try ▸ for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumRTF | 그리드 속성/값 설정 |  |  |  |
| AC-9b44ab18 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1067 | try ▸ for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-600dd363 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1089 | try ▸ for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumMKT_FCST | 그리드 속성/값 설정 |  |  |  |
| AC-92070100 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1090 | try ▸ for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumRTF | 그리드 속성/값 설정 |  |  |  |
| AC-927983ee | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1091 | try ▸ for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-f2671976 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1113 | try ▸ for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumMKT_FCST | 그리드 속성/값 설정 |  |  |  |
| AC-a101cf85 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1114 | try ▸ for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumRTF | 그리드 속성/값 설정 |  |  |  |
| AC-ffc3d0f2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1115 | try ▸ for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-fca83c60 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1136 | try ▸ for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumMKT_FCST | 그리드 속성/값 설정 |  |  |  |
| AC-d72cc1f6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1137 | try ▸ for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumRTF | 그리드 속성/값 설정 |  |  |  |
| AC-797582d5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1138 | try ▸ for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-a987b050 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1144 | try | GRID_SET | dsBinding.Tables[0].Rows[0][0] | sDivisionID | 그리드 속성/값 설정 |  |  |  |
| AC-de560724 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1145 | try | GRID_SET | dsBinding.Tables[0].Rows[1][0] | sDivisionID | 그리드 속성/값 설정 |  |  |  |
| AC-edae3c2e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1146 | try | GRID_SET | dsBinding.Tables[0].Rows[2][0] | sDivisionID | 그리드 속성/값 설정 |  |  |  |
| AC-2dd1b2de | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1151 | try ▸ if (sDivisionID.Equals("81")) ▸ if (RdoName.Checked) | GRID_SET | dsBinding.Tables[0].Rows[0][1] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-b66e8e6a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1152 | try ▸ if (sDivisionID.Equals("81")) ▸ if (RdoName.Checked) | GRID_SET | dsBinding.Tables[0].Rows[1][1] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-71577ec3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1153 | try ▸ if (sDivisionID.Equals("81")) ▸ if (RdoName.Checked) | GRID_SET | dsBinding.Tables[0].Rows[2][1] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-95457929 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1157 | try ▸ if (sDivisionID.Equals("81")) ▸ else of (RdoName.Checked) | GRID_SET | dsBinding.Tables[0].Rows[0][2] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-3c0b71ae | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1158 | try ▸ if (sDivisionID.Equals("81")) ▸ else of (RdoName.Checked) | GRID_SET | dsBinding.Tables[0].Rows[1][2] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-ad7d885e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1159 | try ▸ if (sDivisionID.Equals("81")) ▸ else of (RdoName.Checked) | GRID_SET | dsBinding.Tables[0].Rows[2][2] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-d1e93c1e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1165 | try ▸ else of (sDivisionID.Equals("81")) ▸ if (sDivisionID.Equals("82")) | GRID_SET | dsBinding.Tables[0].Rows[0][1] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-012b4e58 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1166 | try ▸ else of (sDivisionID.Equals("81")) ▸ if (sDivisionID.Equals("82")) | GRID_SET | dsBinding.Tables[0].Rows[1][1] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-ec9e9aba | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1167 | try ▸ else of (sDivisionID.Equals("81")) ▸ if (sDivisionID.Equals("82")) | GRID_SET | dsBinding.Tables[0].Rows[2][1] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-a4fad7d3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1169 | try ▸ else of (sDivisionID.Equals("81")) ▸ if (sDivisionID.Equals("82")) | GRID_SET | dsBinding.Tables[0].Rows[0][3] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-0a7e8e7c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1170 | try ▸ else of (sDivisionID.Equals("81")) ▸ if (sDivisionID.Equals("82")) | GRID_SET | dsBinding.Tables[0].Rows[1][3] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-5438bf9a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1171 | try ▸ else of (sDivisionID.Equals("81")) ▸ if (sDivisionID.Equals("82")) | GRID_SET | dsBinding.Tables[0].Rows[2][3] | "Total" | 그리드 속성/값 설정 |  |  |  |
| AC-69bbc199 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0070_DemandRTF_Balance.cs:1180 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0070_DemandRTF_Balance.SetAmountCalculating

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d313d2c | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:408 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a557dfd | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:412 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1751b89d | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:418 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-775d4f6a | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:419 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6e6c28b7 | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:422 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-914c8f9f | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:424 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-11448199 | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:464 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-6c75a149 | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:470 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-df1f7f44 | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:476 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-abe6646d | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:480 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-e6941928 | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:484 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-2f8e379f | cboQTY.SelectedIndexChanged | SCP0070_DemandRTF_Balance.cs:487 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0070_DemandRTF_Balance.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a8bf4da | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:626 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-dd81f58e | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:626 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-492f4e5e | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:627 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ce73b250 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:630 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-b5b12f63 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:630 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f10d5d7c | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:631 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b4abd8dc | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:634 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-6e271976 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:637 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-9621bd28 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:637 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae8831af | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:638 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-dcd8dfd7 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:647 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("DIV")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f5542d40 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:648 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d3bb7df0 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:651 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-71ab124e | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:652 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-9b6d09b6 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:656 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ else… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ecf623d1 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:657 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) ▸ else… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-174ee44e | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:659 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-69662fbc | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:660 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SOLDTO_CUSTOMER")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d5f26ca2 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:662 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-16038945 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:663 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("81")) | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-4280c5e8 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:669 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-cfbbed2a | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:670 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-47cc6435 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:671 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2f650a76 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:672 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c7fb03f9 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:673 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SOLDTO_CUSTOMER")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-01530eab | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:675 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-e59f34bc | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:676 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ if (division.Equals("… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-ab8b7e99 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:682 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CLASS_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1fded3c3 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:683 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-be03231f | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:684 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("NICK_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ade7e158 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:685 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e7971d66 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:686 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SOLDTO_CUSTOMER")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f81c21a0 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:688 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-669dd470 | this.Load 외 1 | SCP0070_DemandRTF_Balance.cs:689 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("81")) ▸ else of (division.Equ… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## SCP0070_DemandRTF_Balance.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14e58748 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:507 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6f58956a | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:512 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("W_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-305e201a | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:514 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-716b42a9 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:523 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f4f04fb7 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:528 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0eeeec63 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:530 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ab2881b7 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:539 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d0e81d44 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:544 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-bd513b2e | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:546 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-09dfe2c9 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:555 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f8136dba | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:560 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-378f1f69 | this.Load 외 2 | SCP0070_DemandRTF_Balance.cs:562 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0070_DemandRTF_Balance.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-797945f4 | this.spdMain.CellDoubleClick | SCP0070_DemandRTF_Balance.cs:1232 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0070_DemandRTF_Balance.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af02b9d5 | this.spdMain.TopChange | SCP0070_DemandRTF_Balance.cs:1319 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

