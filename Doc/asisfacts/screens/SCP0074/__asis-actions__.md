# AS-IS 액션 대조표 — SCP0074

> 원천: `Doc/asisfacts/screens/SCP0074/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 295행 · 메서드 26 · 종류 DATA_OP 70 · GRID_SET 65 · GRID_INIT 24 · FLAG 19 · RETURN 18 · ENDPOINT 15 · UI_PROP 13 · UI_MISC 11 · CALL_EXT 11 · LIST_REBIND 10 · VALUE_SET 9 · STATE_RESET 7 · MESSAGE 6 · COMBO_DATA 5 · GRID_CLEAR 3 · POPUP 2 · VALIDATE 2 · LIST_BIND 2 · CALL_BASE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 12


## SCP0074_PSI_RTF_Balance.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-044fe2a0 | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1734 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-87217dfb | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1734 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d6f1700 | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1735 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2375fc47 | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1737 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-9a4aba94 | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1740 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-94f817d0 | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1741 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-56d8f261 | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1744 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-8fdee87f | cboPlanDate.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1745 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0074_PSI_RTF_Balance.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a80c5dc8 | cboPlanSeq.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:371 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0074_PSI_RTF_Balance.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89287c32 | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1716 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-8a225b03 | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1716 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-823afd51 | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1717 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-844a0b46 | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1719 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-0f271f31 | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1722 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-8d780a6e | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1725 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-904cb65d | cboPlanType.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:1726 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0074_PSI_RTF_Balance.cboQTY_SelectedIndexChanged

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ceda3669 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:401 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0074_PSI_RTF_Balance.Check_PeriodDate

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4b5ca47e | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1648 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-50f419f7 | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1649 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b91fce63 | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1658 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a4e3a639 | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1659 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-4959b31c | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1667 | try ▸ if (nDate2 >= nDate1After1Year) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00172", new object[] { ((82 * 7 - 1) + 7).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb920a17 | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1668 | try ▸ if (nDate2 >= nDate1After1Year) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-cc10348c | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1673 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5ee7369e | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1674 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-6e5fcb76 | FindButton [try] | SCP0074_PSI_RTF_Balance.cs:1677 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0074_PSI_RTF_Balance.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f560d8d8 | this.Load | SCP0074_PSI_RTF_Balance.cs:260 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cc48c3a6 | this.Load | SCP0074_PSI_RTF_Balance.cs:261 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef5463a2 | this.Load | SCP0074_PSI_RTF_Balance.cs:262 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0074_PSI_RTF_Balance.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-430ec2b4 | this.Load | SCP0074_PSI_RTF_Balance.cs:162 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-66eb9f43 | this.Load | SCP0074_PSI_RTF_Balance.cs:163 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0074_PSI_RTF_Balance.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-295f2bb7 | Dispose | SCP0074_PSI_RTF_Balance.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0074_PSI_RTF_Balance.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d04841f | ExcelButton | SCP0074_PSI_RTF_Balance.cs:703 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0074_PSI_RTF_Balance.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f92cfc8f | FindButton | SCP0074_PSI_RTF_Balance.cs:712 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-29aac5ee | FindButton | SCP0074_PSI_RTF_Balance.cs:717 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-90028e33 | FindButton | SCP0074_PSI_RTF_Balance.cs:717 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-402deec5 | FindButton | SCP0074_PSI_RTF_Balance.cs:718 | try ▸ if (!Check_PeriodDate(dCalendar, PeriodType.W82)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18479fb1 | FindButton | SCP0074_PSI_RTF_Balance.cs:721 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d400e44d | FindButton | SCP0074_PSI_RTF_Balance.cs:723 | try | VALUE_SET | cboQTY.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-9faa8a2b | FindButton | SCP0074_PSI_RTF_Balance.cs:741 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-91d025dc | FindButton | SCP0074_PSI_RTF_Balance.cs:744 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8228d954 | FindButton | SCP0074_PSI_RTF_Balance.cs:751 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS") ⇒ SCP.SCP0074_GET_SUPPLY_PSI_BY_MODEL_ESS | 엔드포인트 요청 생성 |  |  |  |
| AC-4605df7b | FindButton | SCP0074_PSI_RTF_Balance.cs:752 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ec2a63a9 | FindButton | SCP0074_PSI_RTF_Balance.cs:753 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d5aeb948 | FindButton | SCP0074_PSI_RTF_Balance.cs:754 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-137ec9f3 | FindButton | SCP0074_PSI_RTF_Balance.cs:755 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0385bb6e | FindButton | SCP0074_PSI_RTF_Balance.cs:756 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0c7a158c | FindButton | SCP0074_PSI_RTF_Balance.cs:757 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-7327694d | FindButton | SCP0074_PSI_RTF_Balance.cs:758 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-0a396b14 | FindButton | SCP0074_PSI_RTF_Balance.cs:759 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_program_id"] | "SCP0074" | 행/컬럼 값 대입 |  |  |  |
| AC-2ab0a449 | FindButton | SCP0074_PSI_RTF_Balance.cs:760 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-33a05b89 | FindButton | SCP0074_PSI_RTF_Balance.cs:761 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-fce51f89 | FindButton | SCP0074_PSI_RTF_Balance.cs:762 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d3569cb0 | FindButton | SCP0074_PSI_RTF_Balance.cs:766 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("MATERIAL_CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-22fc25ab | FindButton | SCP0074_PSI_RTF_Balance.cs:767 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f611476 | FindButton | SCP0074_PSI_RTF_Balance.cs:768 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b9a5484f | FindButton | SCP0074_PSI_RTF_Balance.cs:769 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SCM_SITE_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7543760f | FindButton | SCP0074_PSI_RTF_Balance.cs:770 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("LINE_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a25c4666 | FindButton | SCP0074_PSI_RTF_Balance.cs:773 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-111ce18a | FindButton | SCP0074_PSI_RTF_Balance.cs:774 | try ▸ lambda ▸ if (division.Equals("82")) ▸ if (RdoModel.Checked) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-48e506b8 | FindButton | SCP0074_PSI_RTF_Balance.cs:778 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS") ⇒ SCP.SCP0074_GET_SUPPLY_PSI_BY_SHIP_LINE_ESS | 엔드포인트 요청 생성 |  |  |  |
| AC-47383e8d | FindButton | SCP0074_PSI_RTF_Balance.cs:779 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3d899c0b | FindButton | SCP0074_PSI_RTF_Balance.cs:780 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7c6a3fc4 | FindButton | SCP0074_PSI_RTF_Balance.cs:781 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-1c69aacb | FindButton | SCP0074_PSI_RTF_Balance.cs:782 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d4c396a9 | FindButton | SCP0074_PSI_RTF_Balance.cs:783 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cd08016b | FindButton | SCP0074_PSI_RTF_Balance.cs:784 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-28db791f | FindButton | SCP0074_PSI_RTF_Balance.cs:785 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-6f3ea484 | FindButton | SCP0074_PSI_RTF_Balance.cs:786 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_program_id"] | "SCP0074" | 행/컬럼 값 대입 |  |  |  |
| AC-19f21048 | FindButton | SCP0074_PSI_RTF_Balance.cs:787 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-c43800b2 | FindButton | SCP0074_PSI_RTF_Balance.cs:788 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc3bcfde | FindButton | SCP0074_PSI_RTF_Balance.cs:789 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-19e7fb79 | FindButton | SCP0074_PSI_RTF_Balance.cs:793 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("MATERIAL_CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7f1f5864 | FindButton | SCP0074_PSI_RTF_Balance.cs:794 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2bdfec07 | FindButton | SCP0074_PSI_RTF_Balance.cs:795 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a45c1bbd | FindButton | SCP0074_PSI_RTF_Balance.cs:796 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SCM_SITE_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9843f5e3 | FindButton | SCP0074_PSI_RTF_Balance.cs:797 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("LINE_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-929c3651 | FindButton | SCP0074_PSI_RTF_Balance.cs:800 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-795642c2 | FindButton | SCP0074_PSI_RTF_Balance.cs:801 | try ▸ lambda ▸ if (division.Equals("82")) ▸ else of (RdoModel.Checked) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-1958461f | FindButton | SCP0074_PSI_RTF_Balance.cs:806 | try ▸ lambda ▸ else of (division.Equals("82")) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0074_GET_PSI_BY_MODEL_SMALL") ⇒ SCP.SCP0074_GET_PSI_BY_MODEL_SMALL | 엔드포인트 요청 생성 |  |  |  |
| AC-4798e439 | FindButton | SCP0074_PSI_RTF_Balance.cs:807 | try ▸ lambda ▸ else of (division.Equals("82")) | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0a4f9a5d | FindButton | SCP0074_PSI_RTF_Balance.cs:808 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-553302fb | FindButton | SCP0074_PSI_RTF_Balance.cs:809 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8f946436 | FindButton | SCP0074_PSI_RTF_Balance.cs:810 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-85c20fe4 | FindButton | SCP0074_PSI_RTF_Balance.cs:811 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-03fa718c | FindButton | SCP0074_PSI_RTF_Balance.cs:812 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-25d7c0b3 | FindButton | SCP0074_PSI_RTF_Balance.cs:813 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-f13107b7 | FindButton | SCP0074_PSI_RTF_Balance.cs:814 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_program_id"] | "SCP0074" | 행/컬럼 값 대입 |  |  |  |
| AC-1ebb5fd1 | FindButton | SCP0074_PSI_RTF_Balance.cs:815 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-e2d7a527 | FindButton | SCP0074_PSI_RTF_Balance.cs:816 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-09248a3b | FindButton | SCP0074_PSI_RTF_Balance.cs:817 | try ▸ lambda ▸ else of (division.Equals("82")) | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-2fca5b06 | FindButton | SCP0074_PSI_RTF_Balance.cs:821 | try ▸ lambda ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("MATERIAL_CLASS_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ce331ba0 | FindButton | SCP0074_PSI_RTF_Balance.cs:822 | try ▸ lambda ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c7948460 | FindButton | SCP0074_PSI_RTF_Balance.cs:823 | try ▸ lambda ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-33229164 | FindButton | SCP0074_PSI_RTF_Balance.cs:824 | try ▸ lambda ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SCM_SITE_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-33c0c157 | FindButton | SCP0074_PSI_RTF_Balance.cs:825 | try ▸ lambda ▸ else of (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("LINE_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-67a18660 | FindButton | SCP0074_PSI_RTF_Balance.cs:828 | try ▸ lambda ▸ else of (division.Equals("82")) | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30598485 | FindButton | SCP0074_PSI_RTF_Balance.cs:829 | try ▸ lambda ▸ else of (division.Equals("82")) | RETURN | return dsResult; |  | 처리 중단/반환 |  |  |  |
| AC-6add56b6 | FindButton | SCP0074_PSI_RTF_Balance.cs:842 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d3aaf7a0 | FindButton | SCP0074_PSI_RTF_Balance.cs:845 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-98b80ba8 | FindButton | SCP0074_PSI_RTF_Balance.cs:848 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-e54c402f | FindButton | SCP0074_PSI_RTF_Balance.cs:849 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-f4dffef9 | FindButton | SCP0074_PSI_RTF_Balance.cs:851 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-34c3c794 | FindButton | SCP0074_PSI_RTF_Balance.cs:861 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-38b52c35 | FindButton | SCP0074_PSI_RTF_Balance.cs:864 | try ▸ if (division.Equals("40")) | VALUE_SET | cboQTY.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-6c68ed72 | FindButton | SCP0074_PSI_RTF_Balance.cs:866 | try ▸ else of (division.Equals("40")) ▸ if (division.Equals("82")) | VALUE_SET | cboQTY.SelectedIndex | 1 | 컨트롤 값 설정 |  |  |  |
| AC-ebc256c9 | FindButton | SCP0074_PSI_RTF_Balance.cs:869 | try | CALL_EXT | siMain.RightColMerge | (true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f15583f3 | FindButton | SCP0074_PSI_RTF_Balance.cs:877 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8631a7a4 | FindButton | SCP0074_PSI_RTF_Balance.cs:879 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0074_PSI_RTF_Balance.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75ea8372 | this.Load | SCP0074_PSI_RTF_Balance.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0074_PSI_RTF_Balance.GetBucketType

진입점: this.Load / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5edc8b82 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1571 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_BUCKET_TYPE_CODE") ⇒ SCP.SCP0070_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-fd211686 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1572 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-13920c2c | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1574 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0074_PSI_RTF_Balance.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5d234b5 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1614 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-db77feea | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1615 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-a02d8c2c | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1625 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-4b59cf4f | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1626 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-40a0fc82 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1627 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-319f4319 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1628 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-f43aa6eb | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1629 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1e275782 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1631 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0074_PSI_RTF_Balance.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cf5d7e80 | this.Load | SCP0074_PSI_RTF_Balance.cs:1583 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_QTY_TYPE_CODE") ⇒ SCP.SCP0070_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-9fd8c405 | this.Load | SCP0074_PSI_RTF_Balance.cs:1584 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24255970 | this.Load | SCP0074_PSI_RTF_Balance.cs:1587 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0074_PSI_RTF_Balance.GetSpdTitle

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b701354 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1604 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-252ea712 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1605 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2985d033 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1606 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-02c9cd11 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1608 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-6a77e6d0 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:1608 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0074_PSI_RTF_Balance.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa95d777 | this.Load | SCP0074_PSI_RTF_Balance.cs:171 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-af1f1ecc | this.Load | SCP0074_PSI_RTF_Balance.cs:172 | if (dtDivision.Rows.Count>0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-bb1ef2e5 | this.Load | SCP0074_PSI_RTF_Balance.cs:182 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "81") | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e616403 | this.Load | SCP0074_PSI_RTF_Balance.cs:183 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "81") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-eeb01e84 | this.Load | SCP0074_PSI_RTF_Balance.cs:184 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "81") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-9bfc66fd | this.Load | SCP0074_PSI_RTF_Balance.cs:186 | if (dtDivision.Rows.Count>0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "81") | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e4592525 | this.Load | SCP0074_PSI_RTF_Balance.cs:190 | if (dtDivision.Rows.Count>0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-bdb66dbd | this.Load | SCP0074_PSI_RTF_Balance.cs:191 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-820c68c9 | this.Load | SCP0074_PSI_RTF_Balance.cs:193 | if (dtDivision.Rows.Count>0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-987c9d57 | this.Load | SCP0074_PSI_RTF_Balance.cs:195 | if (dtDivision.Rows.Count>0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-d2530aa6 | this.Load | SCP0074_PSI_RTF_Balance.cs:196 | if (dtDivision.Rows.Count>0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-4316c5d6 | this.Load | SCP0074_PSI_RTF_Balance.cs:196 | if (dtDivision.Rows.Count>0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e73fb12 | this.Load | SCP0074_PSI_RTF_Balance.cs:203 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-95cf1192 | this.Load | SCP0074_PSI_RTF_Balance.cs:206 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-5f28cd0d | this.Load | SCP0074_PSI_RTF_Balance.cs:207 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-efc6b144 | this.Load | SCP0074_PSI_RTF_Balance.cs:208 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-ca9df168 | this.Load | SCP0074_PSI_RTF_Balance.cs:210 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-54f8adf0 | this.Load | SCP0074_PSI_RTF_Balance.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-0c4f73ed | this.Load | SCP0074_PSI_RTF_Balance.cs:220 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-239f9d0b | this.Load | SCP0074_PSI_RTF_Balance.cs:222 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b6ae03a0 | this.Load | SCP0074_PSI_RTF_Balance.cs:225 | if (dtBucketType.Rows.Count > 0) | DATA_OP | dtBucketType.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f3370852 | this.Load | SCP0074_PSI_RTF_Balance.cs:226 | if (dtBucketType.Rows.Count > 0) | CALL_EXT | tmpBucketType.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d1a59fbc | this.Load | SCP0074_PSI_RTF_Balance.cs:236 | if (dtBucketType.Rows.Count > 0) ▸ foreach (DataRow dr in dtBucketType.Rows) ▸ else of (dr["CODE"].ToString() == "WEEKLY" \|\| dr["CODE"].To… | DATA_OP | tmpBucketType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b4c2dd77 | this.Load | SCP0074_PSI_RTF_Balance.cs:237 | if (dtBucketType.Rows.Count > 0) ▸ foreach (DataRow dr in dtBucketType.Rows) ▸ else of (dr["CODE"].ToString() == "WEEKLY" \|\| dr["CODE"].To… | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-b5718229 | this.Load | SCP0074_PSI_RTF_Balance.cs:238 | if (dtBucketType.Rows.Count > 0) ▸ foreach (DataRow dr in dtBucketType.Rows) ▸ else of (dr["CODE"].ToString() == "WEEKLY" \|\| dr["CODE"].To… | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-9f874ffb | this.Load | SCP0074_PSI_RTF_Balance.cs:240 | if (dtBucketType.Rows.Count > 0) ▸ foreach (DataRow dr in dtBucketType.Rows) ▸ else of (dr["CODE"].ToString() == "WEEKLY" \|\| dr["CODE"].To… | CALL_EXT | tmpBucketType.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1e4eb659 | this.Load | SCP0074_PSI_RTF_Balance.cs:244 | if (dtBucketType.Rows.Count > 0) | UI_PROP | tmpBucketType.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-b9fdaa7d | this.Load | SCP0074_PSI_RTF_Balance.cs:245 | if (dtBucketType.Rows.Count > 0) | DATA_OP | tmpBucketType.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2f6947c9 | this.Load | SCP0074_PSI_RTF_Balance.cs:247 | if (dtBucketType.Rows.Count > 0) | DATA_OP | tmpBucketType.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cb1cac8d | this.Load | SCP0074_PSI_RTF_Balance.cs:249 | if (dtBucketType.Rows.Count > 0) | STATE_RESET | dtBucketType.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ae448718 | this.Load | SCP0074_PSI_RTF_Balance.cs:250 | if (dtBucketType.Rows.Count > 0) | FLAG | dtBucketType | dtBucketTypeOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-025131ef | this.Load | SCP0074_PSI_RTF_Balance.cs:250 | if (dtBucketType.Rows.Count > 0) | DATA_OP | dtBucketTypeOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e6f86164 | this.Load | SCP0074_PSI_RTF_Balance.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-330bbb23 | this.Load | SCP0074_PSI_RTF_Balance.cs:254 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-c1f04af3 | this.Load | SCP0074_PSI_RTF_Balance.cs:255 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0074_PSI_RTF_Balance.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b19a8ba | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:269 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-66cbdbdb | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:272 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-233417d5 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:276 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0074_PSI_RTF_Balance.InitSpreadDateColumn

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-73cecb4f | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:309 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49c973b9 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:310 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-70ee7a5e | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:313 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1660acdd | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:314 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ab682a44 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:323 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f77f5555 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:324 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b2153b42 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:329 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2bd26f99 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:330 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-27e9b1e3 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:337 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a62a52c9 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:338 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eebfce62 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:348 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bed8ddb7 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:349 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6bb76de0 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:350 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f21f0ff | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:351 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0074_PSI_RTF_Balance.RdoType_CheckedChanged

진입점: RdoModel.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a942992e | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:380 |  | CALL_EXT | siMain.SpreadInit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b85d0bfa | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:385 | if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("MATERIAL_CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-801ccd13 | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:386 | if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4bd75723 | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:388 | if (division.Equals("82")) ▸ if (siMain != null) ▸ if (RdoModel.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-72e9a025 | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:390 | if (division.Equals("82")) ▸ if (siMain != null) ▸ else of (RdoModel.Checked) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-613002ee | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:392 | if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SCM_SITE_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-578f2d4b | RdoModel.CheckedChanged | SCP0074_PSI_RTF_Balance.cs:393 | if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("LINE_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0074_PSI_RTF_Balance.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d427db08 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1549 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d34baa28 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1561 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-b1e96d64 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1565 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0074_PSI_RTF_Balance.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbb8d026 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:903 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Y_") == 0) | DATA_OP | listYear.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-249477d0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:907 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Q_") == 0) | DATA_OP | listQuater.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-810328b0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:911 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5554b3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:915 | try ▸ for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a296b33 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:952 | try ▸ if (sDivisionID.Equals("40")) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-60571d3e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:972 | try ▸ if (sDivisionID.Equals("40")) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-eb2fb435 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:988 | try ▸ if (sDivisionID.Equals("40")) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-d51f3159 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1003 | try ▸ if (sDivisionID.Equals("40")) ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-44aca922 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1034 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listMonth.Count) | STATE_RESET | listHeaderItem.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-cff04699 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1050 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listMonth.Count) ▸ for (iRow < item_count) | DATA_OP | listMeasure_line.Add | (temp) | 데이터 객체 조작/조회 |  |  |  |
| AC-e66191a2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1077 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ for (ilist< item_count) ▸ … | GRID_SET | dsBinding.Tables[0].Rows[ilist][idx] | dTemp | 그리드 속성/값 설정 |  |  |  |
| AC-7bab553a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1097 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ if (measure.Equals("BALANC… | GRID_SET | dsBinding.Tables[0].Rows[iRow][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-3380dd12 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1113 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-19566569 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1130 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dTempProductionTotal | 그리드 속성/값 설정 |  |  |  |
| AC-b2cfe0c2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1139 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listWeek.Count) | STATE_RESET | listHeaderItem.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1b329d97 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1155 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listWeek.Count) ▸ for (iRow < item_count) | DATA_OP | listMeasure_line.Add | (temp) | 데이터 객체 조작/조회 |  |  |  |
| AC-ed7c173b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1181 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listWeek.Count) ▸ for (iRow < iTotal_Row) ▸ for (ilist < item_count) ▸ … | GRID_SET | dsBinding.Tables[0].Rows[ilist][idx] | dTemp | 그리드 속성/값 설정 |  |  |  |
| AC-812ebaed | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1201 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listWeek.Count) ▸ for (iRow < iTotal_Row) ▸ if (measure.Equals("BALANCE… | GRID_SET | dsBinding.Tables[0].Rows[iRow][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-d95b09ab | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1216 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-93eaf1d7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1233 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dTempProductionTotal | 그리드 속성/값 설정 |  |  |  |
| AC-fa6d7d65 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1242 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listQuater.Count) | STATE_RESET | listHeaderItem.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f83da08c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1258 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listQuater.Count) ▸ for (iRow < item_count) | DATA_OP | listMeasure_line.Add | (temp) | 데이터 객체 조작/조회 |  |  |  |
| AC-22c4db1c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1284 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listQuater.Count) ▸ for (iRow < iTotal_Row) ▸ for (ilist < item_count) … | GRID_SET | dsBinding.Tables[0].Rows[ilist][idx] | dTemp | 그리드 속성/값 설정 |  |  |  |
| AC-3a9b7230 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1304 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listQuater.Count) ▸ for (iRow < iTotal_Row) ▸ if (measure.Equals("BALAN… | GRID_SET | dsBinding.Tables[0].Rows[iRow][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-9623be14 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1319 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-8d405cf3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1336 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dTempProductionTotal | 그리드 속성/값 설정 |  |  |  |
| AC-90498095 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1345 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listYear.Count) | STATE_RESET | listHeaderItem.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bcefd5e7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1361 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listYear.Count) ▸ for (iRow < item_count) | DATA_OP | listMeasure_line.Add | (temp) | 데이터 객체 조작/조회 |  |  |  |
| AC-7c26e221 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1387 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listYear.Count) ▸ for (iRow < iTotal_Row) ▸ for (ilist < item_count) ▸ … | GRID_SET | dsBinding.Tables[0].Rows[ilist][idx] | dTemp | 그리드 속성/값 설정 |  |  |  |
| AC-c8d34bb2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1407 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listYear.Count) ▸ for (iRow < iTotal_Row) ▸ if (measure.Equals("BALANCE… | GRID_SET | dsBinding.Tables[0].Rows[iRow][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-7318e9df | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1422 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-a5d16e2c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1439 | try ▸ if (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dTempProductionTotal | 그리드 속성/값 설정 |  |  |  |
| AC-204c82a1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1476 | try ▸ else of (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ if (sDivisionID.Equals("82") && (RdoShipLine.Checked)) ▸ for (iRow < dsBind… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-37857782 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1496 | try ▸ else of (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ if (sDivisionID.Equals("82") && (RdoShipLine.Checked)) ▸ for (iRow < dsBind… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-795ae6d8 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1512 | try ▸ else of (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ if (sDivisionID.Equals("82") && (RdoShipLine.Checked)) ▸ for (iRow < dsBind… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-ebd0f5e3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1527 | try ▸ else of (sDivisionID.Equals("82") && (RdoModel.Checked)) ▸ if (sDivisionID.Equals("82") && (RdoShipLine.Checked)) ▸ for (iRow < dsBind… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-663b4ba2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0074_PSI_RTF_Balance.cs:1542 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0074_PSI_RTF_Balance.SetAmountCalculating

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eb2ee5a0 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:411 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9e0ff6c1 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:415 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-de3314e1 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:421 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-dbbcf350 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:422 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3353e906 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:425 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5e81a270 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:427 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e163f83 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:483 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-846bf5c5 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:489 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-63ba80d3 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:495 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-fa7ca607 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:499 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-80cb3fed | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:503 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-bf95f4b2 | cboQTY.SelectedIndexChanged | SCP0074_PSI_RTF_Balance.cs:506 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0074_PSI_RTF_Balance.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ee3360fe | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:595 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-3156e013 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:595 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4367c359 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:596 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-00f79ad4 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:599 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-6789b34e | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:599 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-063943b9 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:600 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d846f86c | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:603 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-265c3985 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:606 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-4e0ddf80 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:606 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7725b11e | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:607 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ad97702b | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:613 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("MATERIAL_CLASS_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7ed99a1c | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:614 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-67c424a6 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:616 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) ▸ if (siMain != null) ▸ if (… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d313c3c6 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:618 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) ▸ if (siMain != null) ▸ else… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1bef76d0 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:620 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SCM_SITE_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ac0c3e05 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:621 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) ▸ if (siMain != null) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("LINE_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-0d9fd944 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:624 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-569511e3 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:625 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-93c345fa | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:627 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-f534dfca | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:628 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Equals("82")) | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1cfe3a00 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:635 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("MATERIAL_CLASS_NAME")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-04b6250b | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:636 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-da0473a0 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:637 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("CELL_ITEM_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1b7bbc7d | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:638 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("SCM_SITE_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7cf75f08 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:639 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("LINE_NAME")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-28e4150e | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:642 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | UI_PROP | layoutControlItem1.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-1c39b267 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:643 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | UI_PROP | layoutControlItem5.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-181d835c | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:645 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-cf74c360 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:648 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | dtBucketType.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-67b120d3 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:649 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | CALL_EXT | tmpBucketType.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-d26e4bff | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:659 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | tmpBucketType.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f8aed42f | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:660 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-2b14fef7 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:661 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-2aad4679 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:663 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | CALL_EXT | tmpBucketType.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-68eb30e2 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:667 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | UI_PROP | tmpBucketType.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-77fd575d | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:668 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | tmpBucketType.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eb1be784 | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:670 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | tmpBucketType.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fd53d7eb | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:672 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | STATE_RESET | dtBucketType.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3a1ff13b | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:673 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | FLAG | dtBucketType | dtBucketTypeOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-dbb7464b | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:673 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | DATA_OP | dtBucketTypeOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6273384c | this.Load 외 1 | SCP0074_PSI_RTF_Balance.cs:674 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Equals("82")) ▸ if (division.Equals("… | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0074_PSI_RTF_Balance.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ac898e4 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:526 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-74a69e82 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:531 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("W_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3c2beb15 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:533 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4138deab | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:542 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-19cbc24b | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:547 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f2ba9ebe | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:549 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-53325e13 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:558 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-908dddcc | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:563 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2a92e4d4 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:565 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-69a1af83 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:574 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-aa606675 | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:579 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e3d4c37f | this.Load 외 2 | SCP0074_PSI_RTF_Balance.cs:581 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0074_PSI_RTF_Balance.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3d068b9 | this.spdMain.CellDoubleClick | SCP0074_PSI_RTF_Balance.cs:1594 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0074_PSI_RTF_Balance.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13a70d26 | this.spdMain.TopChange | SCP0074_PSI_RTF_Balance.cs:1681 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

