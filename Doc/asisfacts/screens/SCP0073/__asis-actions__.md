# AS-IS 액션 대조표 — SCP0073

> 원천: `Doc/asisfacts/screens/SCP0073/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 215행 · 메서드 27 · 종류 GRID_SET 37 · DATA_OP 26 · GRID_INIT 23 · FLAG 22 · RETURN 16 · COMBO_DATA 12 · LIST_REBIND 12 · UI_MISC 12 · ENDPOINT 11 · VALUE_SET 10 · UI_PROP 8 · POPUP 7 · MESSAGE 5 · GRID_CLEAR 3 · CALL_EXT 3 · VALIDATE 2 · STATE 2 · LIST_BIND 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 3


## SCP0073_CAPA_Balance_Electrode.BtnItem_Id_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e7f5b2b | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1208 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e3490704 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1210 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2f76a5c0 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1211 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-99c805e8 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1212 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf0a3e06 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1107 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0038", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-3fce3d7d | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1108 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-47604e09 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1109 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-62a16f24 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1112 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-9d2a83c0 | (진입점 미연결) | SCP0073_CAPA_Balance_Electrode.cs:1114 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.CboOperationGroup_SelectedIndexChanged

진입점: cboOperationGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9eee4ce9 | cboOperationGroup.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1174 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-1394df61 | cboOperationGroup.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1174 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b3c92e1 | cboOperationGroup.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1176 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-5fa89c15 | cboOperationGroup.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1176 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36b9876c | cboOperationGroup.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1178 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05777895 | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1147 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-71376317 | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1147 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2be6e494 | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1148 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f004ca0c | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1150 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-4c1aa147 | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1153 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-a9a42788 | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1154 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-6462f0ac | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1158 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-9b01c1b2 | cboPlanDate.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1159 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-890c4a3a | cboPlanSeq.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:318 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-8813b2f2 | cboPlanSeq.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:321 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-67aad003 | cboPlanSeq.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:322 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f5ba784 | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1130 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-7b554f2a | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1130 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecce1601 | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1131 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3cccc04f | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1133 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e435e8ba | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1136 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-8a0375c8 | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1139 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-6bb07acf | cboPlanType.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:1140 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.cboQTY_SelectedIndexChanged

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f831321 | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:329 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.Check_PeriodDate

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-84694e3d | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1068 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-494f2120 | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1069 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b54cac9c | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1078 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b85d57cf | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1079 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f9355786 | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1087 | try ▸ if (nDate2 >= nDate1After1Year) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00172", new object[] { ((82 * 7 - 1) + 7).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-abffc81e | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1088 | try ▸ if (nDate2 >= nDate1After1Year) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-99fdc293 | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1093 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f3ee5a3 | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1094 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-806adff9 | FindButton [try] | SCP0073_CAPA_Balance_Electrode.cs:1097 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8da23a54 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:206 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-aae1d21e | this.Load | SCP0073_CAPA_Balance_Electrode.cs:207 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-00e9926c | this.Load | SCP0073_CAPA_Balance_Electrode.cs:208 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88d9641d | this.Load | SCP0073_CAPA_Balance_Electrode.cs:158 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-adce805f | this.Load | SCP0073_CAPA_Balance_Electrode.cs:159 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1494f2a | Dispose | SCP0073_CAPA_Balance_Electrode.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-edb13404 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:564 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0589b95a | FindButton | SCP0073_CAPA_Balance_Electrode.cs:569 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-dc69b030 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:569 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-db359e13 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:570 | try ▸ if (!Check_PeriodDate(dCalendar, PeriodType.W82)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a25061af | FindButton | SCP0073_CAPA_Balance_Electrode.cs:574 | try | VALUE_SET | cboQTY.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-2ae3883f | FindButton | SCP0073_CAPA_Balance_Electrode.cs:575 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-cc2fa958 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:598 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-378e1bd5 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:600 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8d7fa022 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:603 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0073_GET_CAPA_BALANCE_EE") ⇒ SCP.SCP0073_GET_CAPA_BALANCE_EE | 엔드포인트 요청 생성 |  |  |  |
| AC-582e8b83 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:604 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8a1f0ceb | FindButton | SCP0073_CAPA_Balance_Electrode.cs:605 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cdb9fc0e | FindButton | SCP0073_CAPA_Balance_Electrode.cs:606 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a3db67ec | FindButton | SCP0073_CAPA_Balance_Electrode.cs:607 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab16be35 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:608 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-b1b2479e | FindButton | SCP0073_CAPA_Balance_Electrode.cs:610 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-32144d59 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:611 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-8b802222 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:612 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-0f199224 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:613 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0073" | 행/컬럼 값 대입 |  |  |  |
| AC-384f5c42 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:614 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-4d356d90 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:615 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-86da9bb8 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:616 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-00338d60 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:617 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-95b5c07e | FindButton | SCP0073_CAPA_Balance_Electrode.cs:618 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-95aa1bc1 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:628 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-03d1ebcf | FindButton | SCP0073_CAPA_Balance_Electrode.cs:629 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-16222699 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:633 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-6e95ef52 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:634 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-e37b814b | FindButton | SCP0073_CAPA_Balance_Electrode.cs:636 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-d7376517 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:641 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a0d22aa9 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:642 | try | VALUE_SET | cboQTY.SelectedIndex | iSetQty | 컨트롤 값 설정 |  |  |  |
| AC-9d85231c | FindButton | SCP0073_CAPA_Balance_Electrode.cs:643 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-300dca7d | FindButton | SCP0073_CAPA_Balance_Electrode.cs:652 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7cba4f7 | FindButton | SCP0073_CAPA_Balance_Electrode.cs:654 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afa78cc7 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:148 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eafe1cd2 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:995 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_BUCKET_TYPE_CODE") ⇒ SCP.SCP0070_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-0ce98d1f | this.Load | SCP0073_CAPA_Balance_Electrode.cs:996 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-358b8591 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:998 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c6eae55 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1037 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-72245bd0 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1038 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-f2c2341c | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1047 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-5c467cfb | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1048 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-ec4633c6 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1049 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-efae2be6 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1050 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-19357221 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1051 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-60bc51b9 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:1053 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5fa22fe | this.Load | SCP0073_CAPA_Balance_Electrode.cs:1007 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_QTY_TYPE_CODE") ⇒ SCP.SCP0070_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-37a6dd92 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:1008 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2717e69b | this.Load | SCP0073_CAPA_Balance_Electrode.cs:1011 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.GetSpdTitle

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fd61ffe3 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:1027 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-4ed59ec9 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:1028 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5e3d7cf7 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:1029 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d7985dff | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:1031 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0cd727f7 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:1031 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0073_CAPA_Balance_Electrode.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39616727 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:167 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-855bc102 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:170 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-299ebdb8 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:171 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-5344b5f2 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:172 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2f0bbcb | this.Load | SCP0073_CAPA_Balance_Electrode.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-e7586887 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:176 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-673f311d | this.Load | SCP0073_CAPA_Balance_Electrode.cs:178 |  | VALUE_SET | cboDivision.ControlValues | "EE" | 컨트롤 값 설정 |  |  |  |
| AC-feef5c70 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:179 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4c859c9f | this.Load | SCP0073_CAPA_Balance_Electrode.cs:183 |  | VALUE_SET | cboOperationGroup.ControlValues | "E" | 컨트롤 값 설정 |  |  |  |
| AC-534a3681 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:184 |  | STATE | cboOperationGroup.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b9f1ffdf | this.Load | SCP0073_CAPA_Balance_Electrode.cs:190 |  | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-866da11e | this.Load | SCP0073_CAPA_Balance_Electrode.cs:190 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4a173585 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:191 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3c5db377 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:194 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-f1ad1491 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:196 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-12acb25d | this.Load | SCP0073_CAPA_Balance_Electrode.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-32ecfad6 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:200 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-c84f5535 | this.Load | SCP0073_CAPA_Balance_Electrode.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.InitSpread

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ddf53889 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:214 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-c8bd1e79 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:217 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-991c4e05 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:224 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.InitSpreadDateColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8299c5f0 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:261 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7f535e6d | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:262 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-faf52c96 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:271 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-61328fd9 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:272 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b81665a9 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:277 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6015b4c1 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:278 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-79aeeac5 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:285 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-25b80c91 | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:286 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-932b6ecf | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:296 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-553afaba | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:297 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c3d2a0e | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:298 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a9695ebd | this.Load 외 3 | SCP0073_CAPA_Balance_Electrode.cs:299 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ba673de7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:972 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b429e88b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:984 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-9cce719e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:988 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30e7fa14 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:676 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Y_") == 0) | DATA_OP | listYear.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-e77a5e96 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:680 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Q_") == 0) | DATA_OP | listQuater.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-85bc1588 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:684 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ac8cc3d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:688 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d552ea82 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:734 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-b409d190 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:740 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 1][iCol] | temp | 그리드 속성/값 설정 |  |  |  |
| AC-8d9005eb | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:761 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-747ccc2b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:767 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 1][iCol] | temp | 그리드 속성/값 설정 |  |  |  |
| AC-a337d40c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:788 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-7864ee6d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:793 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 1][iCol] | dTempPROD_PLAN / dTempCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-fbc2941d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:813 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-f8febe24 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:819 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 1][iCol] | temp | 그리드 속성/값 설정 |  |  |  |
| AC-661d1ca7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:860 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-6d075bcf | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:861 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-3caaf050 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:862 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-c05c6fea | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:865 | for (i < listYear.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-35223890 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:867 | for (i < listYear.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-ed5d3ea4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:892 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-995aefa7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:893 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-59fb74d2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:894 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-a316f85d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:897 | for (i < listQuater.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-bb33a37e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:899 | for (i < listQuater.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-4d5d45f4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:924 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-81086061 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:925 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-edd73a53 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:926 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-f8dc947d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:929 | for (i < listMonth.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-db742578 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:931 | for (i < listMonth.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-627e6872 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:955 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-559365a3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:956 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-e61084e3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:957 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-d66bba90 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:960 | for (i < listWeek.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-5a6a72ea | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0073_CAPA_Balance_Electrode.cs:962 | for (i < listWeek.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.SetAmountCalculating

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06d74b55 | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:339 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-71d8dada | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:343 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-29b3668b | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:349 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-5b547dfd | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:350 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8df7de1 | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:353 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-97cb102b | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:355 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-36f786f2 | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:394 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-5d0ee98d | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:398 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0f48ecdd | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:403 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-af7fac26 | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:407 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-f7fb2fea | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:411 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-473c77cb | cboQTY.SelectedIndexChanged | SCP0073_CAPA_Balance_Electrode.cs:414 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82e2534a | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:492 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-e77bc956 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:492 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3b94a21c | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:494 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-a66560c7 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:494 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc43fef8 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:495 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d10b3ebf | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:506 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-bfa4025c | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:506 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95887a3b | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:507 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4ddf9dfe | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:513 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-95c548e5 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:513 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteProdPlan, false, division, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-84742b29 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:515 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-5fb52fda | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:515 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, division, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ddc797a8 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:517 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f72eee9e | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:520 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-3f9f1075 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:520 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6be7af3c | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:521 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6051a079 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:524 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-7a160256 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:527 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-51635301 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:527 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d05300a6 | this.Load 외 1 | SCP0073_CAPA_Balance_Electrode.cs:528 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90c14601 | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:429 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1f482f8a | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:434 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("W_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b2abd4f0 | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:436 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c937f457 | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:444 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ed3611b5 | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:449 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5877670e | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:451 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-70bcc1b0 | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:460 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a1b20d0d | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:465 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7306389a | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:467 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-30ea9533 | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:476 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-692a8efa | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:481 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e924ee7f | this.Load 외 4 | SCP0073_CAPA_Balance_Electrode.cs:483 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-908fdeaf | this.spdMain.CellDoubleClick | SCP0073_CAPA_Balance_Electrode.cs:1018 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0073_CAPA_Balance_Electrode.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc31f9ef | this.spdMain.TopChange | SCP0073_CAPA_Balance_Electrode.cs:1102 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

