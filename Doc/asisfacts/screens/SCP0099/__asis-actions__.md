# AS-IS 액션 대조표 — SCP0099

> 원천: `Doc/asisfacts/screens/SCP0099/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 673행 · 메서드 70 · 종류 DATA_OP 205 · MESSAGE 58 · GRID_SET 58 · FLAG 52 · UI_PROP 47 · CALL_EXT 44 · RETURN 40 · ENDPOINT 37 · UI_MISC 33 · POPUP 24 · GRID_INIT 23 · GRID_LOCK 14 · VALUE_SET 11 · LIST_REBIND 11 · VALUE_CLEAR 3 · GRID_BIND 3 · COMBO_DATA 3 · STATE_RESET 2 · STATE 2 · CALL_BASE 1 · GRID_STYLE 1 · VALIDATE 1 · ⚠ 의미 확인 필요 45


## SCP0099_Business_Plan_LongTerm.btnCopy_Click

진입점: this.btnCopy.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-545ff4a0 | this.btnCopy.Click | SCP0099_Business_Plan_LongTerm.cs:1211 |  | POPUP | new SCP0099_PlanCopyPopup | (cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-bf572364 | this.btnCopy.Click | SCP0099_Business_Plan_LongTerm.cs:1212 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-84e43b80 | this.btnCopy.Click | SCP0099_Business_Plan_LongTerm.cs:1213 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-897649ab | this.btnCopy.Click | SCP0099_Business_Plan_LongTerm.cs:1215 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0099_Business_Plan_LongTerm.btnExcelUpload_Click

진입점: this.btnExcelUpload.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c3f7ed4f | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1156 | if (cboPlan.SelectedIndex < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { "Select PLAN" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bccbbce1 | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1157 | if (cboPlan.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-965e169e | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1160 |  | POPUP | new SCP0099_ExcelUploadPopup | ("SCP0099", "", cboDivision.ControlValues, cboPlan.SelectedValue.ToString()) | 팝업/폼 생성 |  |  |  |
| AC-0636f5af | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1161 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2d7d8455 | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1163 |  | UI_PROP | popup.Width | 850 | 속성 Width 설정 |  |  |  |
| AC-dfb0fd5e | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1164 |  | UI_PROP | popup.Height | 500 | 속성 Height 설정 |  |  |  |
| AC-177b5358 | this.btnExcelUpload.Click | SCP0099_Business_Plan_LongTerm.cs:1166 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0099_Business_Plan_LongTerm.BtnNew_Click

진입점: btnNew.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c819aed6 | btnNew.Click | SCP0099_Business_Plan_LongTerm.cs:914 |  | POPUP | new SCP0099_CreatePlanPopup | (cboDivision.ControlValues) | 팝업/폼 생성 |  |  |  |
| AC-4ba343d9 | btnNew.Click | SCP0099_Business_Plan_LongTerm.cs:915 |  | UI_PROP | popup.Owner | this | 속성 Owner 설정 |  |  |  |
| AC-7cdde6ae | btnNew.Click | SCP0099_Business_Plan_LongTerm.cs:916 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-78bc5c33 | btnNew.Click | SCP0099_Business_Plan_LongTerm.cs:918 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0099_Business_Plan_LongTerm.btnPlanInfo_Click

진입점: this.btnPlanInfo.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0860407e | this.btnPlanInfo.Click | SCP0099_Business_Plan_LongTerm.cs:1100 |  | POPUP | new SCP0099_PlanInfoPopup | (cboDivision.ControlValues, cboDivision.Text) | 팝업/폼 생성 |  |  |  |
| AC-dfe2af87 | this.btnPlanInfo.Click | SCP0099_Business_Plan_LongTerm.cs:1101 |  | UI_PROP | popup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6ef4eec0 | this.btnPlanInfo.Click | SCP0099_Business_Plan_LongTerm.cs:1102 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0099_Business_Plan_LongTerm.btnRelease_Click

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a17c113 | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1115 | if (cboPlan.SelectedIndex < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { "RERLEASE PLAN" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c8b19794 | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1116 | if (cboPlan.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef7b8872 | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1121 | if (spdMain.Sheets[0].RowCount == 0 && spdMain.Sheets[1].RowCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "RERLEASE PLAN" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30f5cf0d | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1122 | if (spdMain.Sheets[0].RowCount == 0 && spdMain.Sheets[1].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-82c553da | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1125 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00015") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8cdf763b | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1129 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE") ⇒ SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-038e850f | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1133 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ec9267da | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1135 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3eb14df9 | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1136 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | DATA_OP | request.Parameters["v_plan_id"] | cboPlan.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-86cb37f9 | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1138 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c02ccc0a | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1142 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c714a6c | this.btnRelease.Click | SCP0099_Business_Plan_LongTerm.cs:1146 | if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) ▸ else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0099_Business_Plan_LongTerm.btnTemplate_Click

진입점: this.btnTemplate.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b35aae3d | this.btnTemplate.Click | SCP0099_Business_Plan_LongTerm.cs:1171 |  | CALL_BASE | MenuEtcFileDownButton | ("BusinessPlan_ExcelForm.xlsx") | ⚠ 의미 확인 필요 |  |  |  |

## SCP0099_Business_Plan_LongTerm.cboPlan_SelectedIndexChanged

진입점: this.cboPlan.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c2c6f7d | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1176 | if (cboPlan.SelectedValue.ToString() == "System.Data.DataRowView") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66ccd9d9 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1178 |  | VALUE_CLEAR | lblPeriod.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-848ff4aa | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1179 |  | FLAG | strStartDt | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf46ca3 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1182 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_LONGTERM_PLAN") ⇒ SCP.SCP0099_GET_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-02dab354 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1188 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-0bc9d019 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1189 |  | DATA_OP | request.Parameters["p_valid_yn"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-13db9f88 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1190 |  | DATA_OP | request.Parameters["p_PLAN_ID"] | cboPlan.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-178c3349 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1192 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-334136c0 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1195 |  | FLAG | strStartDt | result.Tables[0].Rows[0]["PLAN_START_DATE"].ToString().Substring(0, 4) + "-" + result.Tabl… | 화면 필드/플래그 변경 |  |  |  |
| AC-c406a1f3 | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1196 |  | VALUE_SET | lblPeriod.Text | strStartDt + " ~ " + result.Tables[0].Rows[0]["PLAN_END_DATE"].ToString().Substring(0, 4) … | 컨트롤 값 설정 |  |  |  |
| AC-da942fbe | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1202 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-4734da3b | this.cboPlan.SelectedIndexChanged | SCP0099_Business_Plan_LongTerm.cs:1204 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_Business_Plan_LongTerm.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eab95399 | this.Load | SCP0099_Business_Plan_LongTerm.cs:328 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-151eb41b | this.Load | SCP0099_Business_Plan_LongTerm.cs:329 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain2, SpdSheet.shtMain2, 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-446b0883 | this.Load | SCP0099_Business_Plan_LongTerm.cs:331 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-936beafb | this.Load | SCP0099_Business_Plan_LongTerm.cs:333 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9678238 | this.Load | SCP0099_Business_Plan_LongTerm.cs:336 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_Business_Plan_LongTerm.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-026550e4 | DeleteButton | SCP0099_Business_Plan_LongTerm.cs:447 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, siMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ce2926e6 | DeleteButton | SCP0099_Business_Plan_LongTerm.cs:448 |  | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0099_Business_Plan_LongTerm.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b299df45 | Dispose | SCP0099_Business_Plan_LongTerm.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0099_Business_Plan_LongTerm.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc520979 | EditButton | SCP0099_Business_Plan_LongTerm.cs:495 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-d54ea894 | EditButton | SCP0099_Business_Plan_LongTerm.cs:496 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-56cc0cdf | EditButton | SCP0099_Business_Plan_LongTerm.cs:497 |  | GRID_LOCK | siMain.LockColumn | (0, 12, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-afe32a13 | EditButton | SCP0099_Business_Plan_LongTerm.cs:500 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-dbc55799 | EditButton | SCP0099_Business_Plan_LongTerm.cs:501 |  | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-157225a2 | EditButton | SCP0099_Business_Plan_LongTerm.cs:502 |  | GRID_LOCK | siMain.LockColumn | (0, 11, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b2cc7a39 | EditButton | SCP0099_Business_Plan_LongTerm.cs:503 |  | GRID_LOCK | siMain.LockColumn | (15, 17, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0099_Business_Plan_LongTerm.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (bolReload)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6076ff9 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:953 | if (cboPlan.SelectedIndex < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00030", new object[] { "PLAN" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3e0a3a94 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:954 | if (cboPlan.SelectedIndex < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-110a5bd4 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:957 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-13f36bc6 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:964 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8b8868ab | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:966 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-e137500c | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:969 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-431f5da3 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:985 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-74ad84ed | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:987 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", BLUtils.GSCM_DM_MASTER_SVC)) { var … | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2bc30802 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:990 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_LONGTERM_PLAN_DETAIL") ⇒ SCP.SCP0099_GET_LONGTERM_PLAN_DETAIL | 엔드포인트 요청 생성 |  |  |  |
| AC-b07a7b9b | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:991 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6133550b | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:992 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-02f66cde | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:993 | try ▸ lambda | DATA_OP | req.Parameters["P_PLAN_ID"] | p_planId | 행/컬럼 값 대입 |  |  |  |
| AC-76b86c0a | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:994 | try ▸ lambda | DATA_OP | req.Parameters["P_OPERATION_GROUP"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-7c95fbac | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:995 | try ▸ lambda | DATA_OP | req.Parameters["P_SITE"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-92426f6e | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:996 | try ▸ lambda | DATA_OP | req.Parameters["P_LINE"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-b11d26d0 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:997 | try ▸ lambda | DATA_OP | req.Parameters["P_MODEL"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f14104a7 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:998 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b6650a61 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:999 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-eea9b924 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1005 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab5f940 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1006 | try | GRID_BIND | siMain.Query | (dsBinding.Tables[0]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-a0ab6190 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1008 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d183cc06 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1009 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-69680ae7 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1011 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81d7def5 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1023 | try ▸ for (i <= 60) | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, siMain.GetColumnIndex("M" + i.ToString() + "_QTY")].T… | dt.AddMonths(intAddMonth).ToString("yyyy.MM") | 그리드 속성/값 설정 |  |  |  |
| AC-d7404885 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1030 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (this.nSelRowOfMain, this.nSelColOfMain) | 그리드 표시 설정 |  |  |  |
| AC-edc49f88 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1031 | try ▸ if (this.nSelRowOfMain >= 0 && isReload) | CALL_EXT | spdMain.ShowCell | (0, 0, this.nSelRowOfMain, this.nSelColOfMain, FarPoint.Win.Spread.VerticalPosition.Center… | ⚠ 의미 확인 필요 |  |  |  |
| AC-86d583be | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1035 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-05df51c3 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1036 | try | GRID_BIND | siMain.Query | (dsBinding.Tables[1]) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-f8aee255 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1037 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f276b627 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1039 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9ca9aa9e | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1050 | try ▸ for (i <= 60) | GRID_SET | siMain.Sheet().ColumnHeader.Cells[0, siMain.GetColumnIndex("M" + i.ToString() + "_QTY")].T… | dt.AddMonths(intAddMonth).ToString("yyyy.MM") | 그리드 속성/값 설정 |  |  |  |
| AC-b5655f70 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1056 | try | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-d37891e8 | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1061 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-032beadd | FindButton 외 1 | SCP0099_Business_Plan_LongTerm.cs:1066 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_Business_Plan_LongTerm.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0929c39c | this.Load | SCP0099_Business_Plan_LongTerm.cs:266 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0099_Business_Plan_LongTerm.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d9f321b | this.Load | SCP0099_Business_Plan_LongTerm.cs:313 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-25df35d4 | this.Load | SCP0099_Business_Plan_LongTerm.cs:316 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-67174a39 | this.Load | SCP0099_Business_Plan_LongTerm.cs:320 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0099_Business_Plan_LongTerm.InitSpread

진입점: this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResult.OK)] / this.cboPlan.SelectedIndexChanged / this.Load / cboDivision.SelectedIndexChanged / btnNew.Click [if (popup.ShowDialog() == DialogResult.OK)] / FindButton [try] / SaveButton [try ▸ if (bolReload) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a244ba62 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 6 | SCP0099_Business_Plan_LongTerm.cs:345 | if (spdInfo == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4da7a242 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 6 | SCP0099_Business_Plan_LongTerm.cs:346 |  | GRID_INIT | spdInfo.InitSheet | (spdInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-78a0d59c | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 6 | SCP0099_Business_Plan_LongTerm.cs:347 |  | GRID_SET | spdInfo.ActiveSheet.DataSource | null | 그리드 속성/값 설정 |  |  |  |
| AC-4266d25a | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 6 | SCP0099_Business_Plan_LongTerm.cs:348 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-2a4669d6 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 6 | SCP0099_Business_Plan_LongTerm.cs:349 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2ffb309 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 6 | SCP0099_Business_Plan_LongTerm.cs:350 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0099_Business_Plan_LongTerm.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58e95e2b | InsertButton | SCP0099_Business_Plan_LongTerm.cs:1073 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, siMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-18c1c316 | InsertButton | SCP0099_Business_Plan_LongTerm.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-111b2309 | InsertButton | SCP0099_Business_Plan_LongTerm.cs:1079 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns_Prod.DIVISION_ID, cboDivision.ControlValues) | 데이터 객체 조작/조회 |  |  |  |
| AC-be9b919e | InsertButton | SCP0099_Business_Plan_LongTerm.cs:1081 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns_Prod.MEASURE, siMain.ActiveSheetIndex == 0 ? "Prod. Plan" : "RTF") | 데이터 객체 조작/조회 |  |  |  |
| AC-12bf2662 | InsertButton | SCP0099_Business_Plan_LongTerm.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-272c15fc | SaveButton | SCP0099_Business_Plan_LongTerm.cs:531 | if (spdMain.Sheets[0].RowCount == 0 && spdMain.Sheets[1].RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8400bb1 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:533 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-da4f5eaf | SaveButton | SCP0099_Business_Plan_LongTerm.cs:534 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-49d38452 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:552 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-df904d8e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:555 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-25d012fa | SaveButton | SCP0099_Business_Plan_LongTerm.cs:556 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, 11, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-466399ab | SaveButton | SCP0099_Business_Plan_LongTerm.cs:558 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("OPERATION_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-932eeb70 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:559 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b134c5a | SaveButton | SCP0099_Business_Plan_LongTerm.cs:560 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("BUILDING") | 데이터 객체 조작/조회 |  |  |  |
| AC-9d5ca79c | SaveButton | SCP0099_Business_Plan_LongTerm.cs:561 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-703ad2e7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:562 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("NICKNAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6eaebfc | SaveButton | SCP0099_Business_Plan_LongTerm.cs:563 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-3e19299f | SaveButton | SCP0099_Business_Plan_LongTerm.cs:564 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("CUST") | 데이터 객체 조작/조회 |  |  |  |
| AC-8d47bece | SaveButton | SCP0099_Business_Plan_LongTerm.cs:565 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("PROJECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-3203a7f7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:566 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("UNIT") | 데이터 객체 조작/조회 |  |  |  |
| AC-d6fb1e8e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:567 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-abe19c14 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:570 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= 60) | DATA_OP | dtProd.Columns.Add | ("M" + i.ToString() + "_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b377a2c1 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:574 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-3add12b5 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:575 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b24c3386 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:582 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dtProd.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-54774dee | SaveButton | SCP0099_Business_Plan_LongTerm.cs:585 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dr["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex("KEYVALUE")) | 행/컬럼 값 대입 |  |  |  |
| AC-b0516089 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:590 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") ▸ for (j <= 60… | DATA_OP | dr["M" + j.ToString() + "_QTY"] | siMain.GetValue(i, siMain.GetColumnIndex("M" + j.ToString() + "_QTY")).ToString() == "" ? … | 행/컬럼 값 대입 |  |  |  |
| AC-a07081d0 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:592 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dtProd.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-446ccc34 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:596 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dtProd_ins.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9b0faf17 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:598 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["OPERATION_GROUP"] | siMain.GetValue(i, siMain.GetColumnIndex("OPERATION_GROUP")) | 행/컬럼 값 대입 |  |  |  |
| AC-551994f6 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:599 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["SITE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("SITE_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-e3f3eca8 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:600 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["BUILDING"] | siMain.GetValue(i, siMain.GetColumnIndex("BUILDING")) | 행/컬럼 값 대입 |  |  |  |
| AC-88c46d6c | SaveButton | SCP0099_Business_Plan_LongTerm.cs:601 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["LINE_ID"] | siMain.GetValue(i, siMain.GetColumnIndex("LINE_ID")) | 행/컬럼 값 대입 |  |  |  |
| AC-a0d9389e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:602 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["NICKNAME"] | siMain.GetValue(i, siMain.GetColumnIndex("NICKNAME")) | 행/컬럼 값 대입 |  |  |  |
| AC-dc54cbab | SaveButton | SCP0099_Business_Plan_LongTerm.cs:603 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["MODEL"] | siMain.GetValue(i, siMain.GetColumnIndex("MODEL")) | 행/컬럼 값 대입 |  |  |  |
| AC-d6606fe2 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:604 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["CUST"] | siMain.GetValue(i, siMain.GetColumnIndex("CUST")) | 행/컬럼 값 대입 |  |  |  |
| AC-e475d3b7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:605 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["PROJECT"] | siMain.GetValue(i, siMain.GetColumnIndex("PROJECT")) | 행/컬럼 값 대입 |  |  |  |
| AC-7b9f15b9 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:606 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex("UNIT")) | 행/컬럼 값 대입 |  |  |  |
| AC-fdf16a04 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:607 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["MEASURE"] | siMain.GetValue(i, siMain.GetColumnIndex("MEASURE")) | 행/컬럼 값 대입 |  |  |  |
| AC-e4b9e2da | SaveButton | SCP0099_Business_Plan_LongTerm.cs:612 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["M" + j.ToString() + "_QTY"] | siMain.GetValue(i, siMain.GetColumnIndex("M" + j.ToString() + "_QTY")).ToString() == "" ? … | 행/컬럼 값 대입 |  |  |  |
| AC-4ae6a0d5 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:615 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dtProd_ins.Rows.Add | (dr_ins) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e1b20b2 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:619 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ else of… | DATA_OP | dtProd_del.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-948af7be | SaveButton | SCP0099_Business_Plan_LongTerm.cs:620 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ else of… | DATA_OP | dr_del["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex("KEYVALUE")) | 행/컬럼 값 대입 |  |  |  |
| AC-1b8311a1 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:621 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ else of… | DATA_OP | dtProd_del.Rows.Add | (dr_del) | 데이터 객체 조작/조회 |  |  |  |
| AC-edb655cc | SaveButton | SCP0099_Business_Plan_LongTerm.cs:624 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7ff6f825 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:625 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd_ins.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a7ed2705 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:626 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtProd_del.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-de06c8e0 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:636 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@SCP0099_PROD", dtProd) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5f04c5cc | SaveButton | SCP0099_Business_Plan_LongTerm.cs:637 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7fd4b468 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:639 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd.Rows.Count > 0) | ENDPOINT | sql.ExcuteProcedure | ("SavePlanProdEdit") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProdEdit] \| SC… | 엔드포인트 호출 |  |  |  |
| AC-6f427a5f | SaveButton | SCP0099_Business_Plan_LongTerm.cs:644 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "PRODUCTION EDIT : " + result.Rows[0]["result_cnt"].ToString()… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f727946 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:645 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-4910c2b0 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:650 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd.Rows.Count > 0) ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8a55eac1 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:662 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@SCP0099_PROD", dtProd_ins) | ⚠ 의미 확인 필요 |  |  |  |
| AC-70151307 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:663 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_DIV", cboDivision.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-9abe19f5 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:664 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_PLAN", cboPlan.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-24b6e3c0 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:665 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b3ac2725 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:666 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_DEL_YN", "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-309f1d7b | SaveButton | SCP0099_Business_Plan_LongTerm.cs:668 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) | ENDPOINT | sql.ExcuteProcedure | ("SavePlanProd") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProd] \| SCP\An… | 엔드포인트 호출 |  |  |  |
| AC-b624d259 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:673 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "PRODUCTION ADD : " + result.Rows[0]["result_cnt"].ToString() … | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35db62fd | SaveButton | SCP0099_Business_Plan_LongTerm.cs:674 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-2be546c5 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:679 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_ins.Rows.Count > 0) ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c5764ab | SaveButton | SCP0099_Business_Plan_LongTerm.cs:691 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_del.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@SCP0099_PROD", dtProd_del) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a706519a | SaveButton | SCP0099_Business_Plan_LongTerm.cs:693 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_del.Rows.Count > 0) | ENDPOINT | sql.ExcuteProcedure | ("SavePlanProdDel") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProdDel] \| SCP… | 엔드포인트 호출 |  |  |  |
| AC-24bcc6a4 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:698 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_del.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "PRODUCTION DELETE : " + result.Rows[0]["result_cnt"].ToString… | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-442f94da | SaveButton | SCP0099_Business_Plan_LongTerm.cs:699 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_del.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-93267f67 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:704 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtProd_del.Rows.Count > 0) ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6332eab4 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:712 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, 1) | 화면 필드/플래그 변경 |  |  |  |
| AC-5a2f4a1f | SaveButton | SCP0099_Business_Plan_LongTerm.cs:715 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4004cd8b | SaveButton | SCP0099_Business_Plan_LongTerm.cs:716 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | GRID_LOCK | siMain.LockRange | (0, 0, siMain.ActiveSheet.RowCount - 1, 12, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bcb05fd4 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:718 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("SALES_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2fae652 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:719 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("BIZ_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cfaacef4 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:720 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("CUST") | 데이터 객체 조작/조회 |  |  |  |
| AC-4f760eed | SaveButton | SCP0099_Business_Plan_LongTerm.cs:721 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("PROJECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-bfcdaf9d | SaveButton | SCP0099_Business_Plan_LongTerm.cs:722 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("PROJECT_DESC") | 데이터 객체 조작/조회 |  |  |  |
| AC-71809b90 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:723 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ee8828e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:724 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("MODEL_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-38d651a1 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:725 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("CELL_NICKNAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f5d7286 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:726 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("CELL_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-08207b91 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:727 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("ELECTRODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-92bf610b | SaveButton | SCP0099_Business_Plan_LongTerm.cs:728 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-00d608ff | SaveButton | SCP0099_Business_Plan_LongTerm.cs:729 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-c1de4598 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:730 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("UNIT") | 데이터 객체 조작/조회 |  |  |  |
| AC-bc34ade7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:731 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-f94ac7ee | SaveButton | SCP0099_Business_Plan_LongTerm.cs:732 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ba59d1a | SaveButton | SCP0099_Business_Plan_LongTerm.cs:735 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= 60) | DATA_OP | dtRTF.Columns.Add | ("M" + i.ToString() + "_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-20f281d6 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:739 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ddc83279 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:740 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5fed48e5 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:747 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dtRTF.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2d451c50 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:749 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dr["ELECTRODE"] | siMain.GetValue(i, siMain.GetColumnIndex("ELECTRODE")) | 행/컬럼 값 대입 |  |  |  |
| AC-2e6e4fb9 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:750 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dr["CELL"] | siMain.GetValue(i, siMain.GetColumnIndex("CELL")) | 행/컬럼 값 대입 |  |  |  |
| AC-44e0b86c | SaveButton | SCP0099_Business_Plan_LongTerm.cs:751 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dr["PACK"] | siMain.GetValue(i, siMain.GetColumnIndex("PACK")) | 행/컬럼 값 대입 |  |  |  |
| AC-3ebda8d6 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:754 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dr["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex("KEYVALUE")) | 행/컬럼 값 대입 |  |  |  |
| AC-69c99d0f | SaveButton | SCP0099_Business_Plan_LongTerm.cs:759 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") ▸ for (j <= 60… | DATA_OP | dr["M" + j.ToString() + "_QTY"] | siMain.GetValue(i, siMain.GetColumnIndex("M" + j.ToString() + "_QTY")).ToString() == "" ? … | 행/컬럼 값 대입 |  |  |  |
| AC-77fb80ce | SaveButton | SCP0099_Business_Plan_LongTerm.cs:761 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.Sheet().Cells[i, 0].Text == "M") | DATA_OP | dtRTF.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-db6b509c | SaveButton | SCP0099_Business_Plan_LongTerm.cs:765 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dtRTF_ins.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c95f66e7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:767 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["SALES_SITE"] | siMain.GetValue(i, siMain.GetColumnIndex("SALES_SITE")) | 행/컬럼 값 대입 |  |  |  |
| AC-2036be7f | SaveButton | SCP0099_Business_Plan_LongTerm.cs:768 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["BIZ_TYPE"] | siMain.GetValue(i, siMain.GetColumnIndex("BIZ_TYPE")) | 행/컬럼 값 대입 |  |  |  |
| AC-77e8057c | SaveButton | SCP0099_Business_Plan_LongTerm.cs:769 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["CUST"] | siMain.GetValue(i, siMain.GetColumnIndex("CUST")) | 행/컬럼 값 대입 |  |  |  |
| AC-1b422bb7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:770 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["PROJECT"] | siMain.GetValue(i, siMain.GetColumnIndex("PROJECT")) | 행/컬럼 값 대입 |  |  |  |
| AC-87905674 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:771 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["PROJECT_DESC"] | siMain.GetValue(i, siMain.GetColumnIndex("PROJECT_DESC")) | 행/컬럼 값 대입 |  |  |  |
| AC-363a4284 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:772 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["MODEL"] | siMain.GetValue(i, siMain.GetColumnIndex("MODEL")) | 행/컬럼 값 대입 |  |  |  |
| AC-5f16e1c3 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:773 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["MODEL_CODE"] | siMain.GetValue(i, siMain.GetColumnIndex("MODEL_CODE")) | 행/컬럼 값 대입 |  |  |  |
| AC-e2bfa75e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:774 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["CELL_NICKNAME"] | siMain.GetValue(i, siMain.GetColumnIndex("CELL_NICKNAME")) | 행/컬럼 값 대입 |  |  |  |
| AC-a46c481d | SaveButton | SCP0099_Business_Plan_LongTerm.cs:775 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["CELL_CODE"] | siMain.GetValue(i, siMain.GetColumnIndex("CELL_CODE")) | 행/컬럼 값 대입 |  |  |  |
| AC-b9ff9e25 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:776 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["ELECTRODE"] | siMain.GetValue(i, siMain.GetColumnIndex("ELECTRODE")) | 행/컬럼 값 대입 |  |  |  |
| AC-ae95c624 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:777 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["CELL"] | siMain.GetValue(i, siMain.GetColumnIndex("CELL")) | 행/컬럼 값 대입 |  |  |  |
| AC-129282a3 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:778 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["PACK"] | siMain.GetValue(i, siMain.GetColumnIndex("PACK")) | 행/컬럼 값 대입 |  |  |  |
| AC-d79730a2 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:779 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex("UNIT")) | 행/컬럼 값 대입 |  |  |  |
| AC-4aecc7ec | SaveButton | SCP0099_Business_Plan_LongTerm.cs:780 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["INCOTERMS"] | siMain.GetValue(i, siMain.GetColumnIndex("INCOTERMS")) | 행/컬럼 값 대입 |  |  |  |
| AC-7893da55 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:781 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["MEASURE"] | siMain.GetValue(i, siMain.GetColumnIndex("MEASURE")) | 행/컬럼 값 대입 |  |  |  |
| AC-d2260747 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:786 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dr_ins["M" + j.ToString() + "_QTY"] | siMain.GetValue(i, siMain.GetColumnIndex("M" + j.ToString() + "_QTY")).ToString() == "" ? … | 행/컬럼 값 대입 |  |  |  |
| AC-2002246e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:789 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ if (siM… | DATA_OP | dtRTF_ins.Rows.Add | (dr_ins) | 데이터 객체 조작/조회 |  |  |  |
| AC-a1f439e6 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:793 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ else of… | DATA_OP | dtRTF_del.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-654df08a | SaveButton | SCP0099_Business_Plan_LongTerm.cs:794 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ else of… | DATA_OP | dr_del["UNIT"] | siMain.GetValue(i, siMain.GetColumnIndex("KEYVALUE")) | 행/컬럼 값 대입 |  |  |  |
| AC-bec55c70 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:795 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (siMain.Sheet().Cells[i, 0].Text == "M") ▸ else of… | DATA_OP | dtRTF_del.Rows.Add | (dr_del) | 데이터 객체 조작/조회 |  |  |  |
| AC-f514e2d4 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:799 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0904095b | SaveButton | SCP0099_Business_Plan_LongTerm.cs:800 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF_ins.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6d4f01f2 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:801 | try ▸ if (siMain.ActiveSheet.RowCount > 0) | DATA_OP | dtRTF_del.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c4fd6e71 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:812 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@SCP0099_RTF", dtRTF) | ⚠ 의미 확인 필요 |  |  |  |
| AC-701aa4d0 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:813 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4aecc313 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:815 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF.Rows.Count > 0) | ENDPOINT | sql.ExcuteProcedure | ("SavePlanRtfEdit") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtfEdit] \| SCP… | 엔드포인트 호출 |  |  |  |
| AC-a435f907 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:821 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "RTF EDIT : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25235a2e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:822 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-17287fc5 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:826 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF.Rows.Count > 0) ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da436f54 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:838 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@SCP0099_RTF", dtRTF_ins) | ⚠ 의미 확인 필요 |  |  |  |
| AC-065a1749 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:839 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_DIV", cboDivision.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c6e506a3 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:840 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_PLAN", cboPlan.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1c288f80 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:841 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-27b86013 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:842 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@P_DEL_YN", "N") | ⚠ 의미 확인 필요 |  |  |  |
| AC-f46dbbf0 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:844 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) | ENDPOINT | sql.ExcuteProcedure | ("SavePlanRtf") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtf] \| SCP\Ana… | 엔드포인트 호출 |  |  |  |
| AC-d764ae5b | SaveButton | SCP0099_Business_Plan_LongTerm.cs:849 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "RTF ADD : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ddbd8814 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:850 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-985ab11c | SaveButton | SCP0099_Business_Plan_LongTerm.cs:855 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_ins.Rows.Count > 0) ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-89963b02 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:867 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_del.Rows.Count > 0) | CALL_EXT | sql.AddParameter | ("@SCP0099_RTF", dtRTF_del) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92e0826d | SaveButton | SCP0099_Business_Plan_LongTerm.cs:869 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_del.Rows.Count > 0) | ENDPOINT | sql.ExcuteProcedure | ("SavePlanRtfDel") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtfDel] \| SCP\… | 엔드포인트 호출 |  |  |  |
| AC-2442005e | SaveButton | SCP0099_Business_Plan_LongTerm.cs:874 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_del.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "RTF DELETE : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47b43c44 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:875 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_del.Rows.Count > 0) ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-d2f3bbe7 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:880 | try ▸ if (siMain.ActiveSheet.RowCount > 0) ▸ if (dtRTF_del.Rows.Count > 0) ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0387e1f3 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:901 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7577ed99 | SaveButton | SCP0099_Business_Plan_LongTerm.cs:902 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-009a81ff | SaveButton | SCP0099_Business_Plan_LongTerm.cs:906 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SCP0099_Div

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-39770ebe | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:73 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4d77121 | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:74 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0df562d3 | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:76 |  | DATA_OP | dt.Rows.Add | (new object[] { "81", "81 Automotive Battery" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-38b29231 | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:77 |  | DATA_OP | dt.Rows.Add | (new object[] { "40", "40 Mobility & IT Battery" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab72aa64 | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:78 |  | DATA_OP | dt.Rows.Add | (new object[] { "82", "82 ESS Battery" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e2dd157 | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:79 |  | DATA_OP | dt.Rows.Add | (new object[] { "EE_81", "EE_81 Electrode_Auto/ESS" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-4a1d6db2 | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:80 |  | DATA_OP | dt.Rows.Add | (new object[] { "EE_40", "EE_40 Electrode_Mobility" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-52f3aeff | (진입점 미연결) | SCP0099_Business_Plan_LongTerm.cs:82 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0099_Business_Plan_LongTerm.setCboPlan

진입점: this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResult.OK)] / this.Load / cboDivision.SelectedIndexChanged / btnNew.Click [if (popup.ShowDialog() == DialogResult.OK)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cda4ed6f | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:280 |  | VALUE_CLEAR | lblPeriod.Text | "" | 컨트롤 값 비움 |  |  |  |
| AC-7bb58a79 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:281 |  | FLAG | strStartDt | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d0c19ced | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:284 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_LONGTERM_PLAN") ⇒ SCP.SCP0099_GET_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-9494b4db | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:288 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-3de7783a | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:290 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-34e4902f | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:291 |  | DATA_OP | request.Parameters["p_valid_yn"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-d9d5f857 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:292 |  | DATA_OP | request.Parameters["p_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-39f0adc8 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:294 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2e91c51f | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:298 |  | LIST_REBIND | clsCtrl.setListBox | (result.Tables[0], cboPlan, false, "PLAN_ID", "PLAN_ID") | 목록 컨트롤 재구성 |  |  |  |
| AC-a1fcf762 | this.btnPlanInfo.Click [if (popup.ShowDialog() == DialogResu… 외 3 | SCP0099_Business_Plan_LongTerm.cs:299 | if (cboPlan.Items.Count > 0) | VALUE_SET | cboPlan.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-898b2a7f | this.Load 외 1 | SCP0099_Business_Plan_LongTerm.cs:939 | if (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-cfa6d1dd | this.Load 외 1 | SCP0099_Business_Plan_LongTerm.cs:939 | if (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b61c6ac9 | this.Load 외 1 | SCP0099_Business_Plan_LongTerm.cs:941 | else of (division.Substring(0, 2).Equals("EE")) | FLAG | dtOperationGroup | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-355ad11d | this.Load 외 1 | SCP0099_Business_Plan_LongTerm.cs:941 | else of (division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c5e593fa | this.Load 외 1 | SCP0099_Business_Plan_LongTerm.cs:942 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c294bd8f | this.spdMain.CellClick | SCP0099_Business_Plan_LongTerm.cs:417 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelRowOfMain | spdMain.ActiveSheet.ActiveRowIndex | 화면 필드/플래그 변경 |  |  |  |
| AC-5ffad301 | this.spdMain.CellClick | SCP0099_Business_Plan_LongTerm.cs:418 | if (spdMain.ActiveSheet.ActiveRowIndex > 0) | FLAG | this.nSelColOfMain | spdMain.ActiveSheet.ActiveColumnIndex | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3a744952 | this.spdMain.ClipboardPasted | SCP0099_Business_Plan_LongTerm.cs:376 | if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2079b77a | this.spdMain.ClipboardPasted | SCP0099_Business_Plan_LongTerm.cs:377 | if (siMain.Sheet().Rows.Count <= 0 \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff13d4fe | this.spdMain.ClipboardPasted | SCP0099_Business_Plan_LongTerm.cs:396 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8df9ed1f | this.spdMain.ClipboardPasted | SCP0099_Business_Plan_LongTerm.cs:397 | catch ((Exception ex)) | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-c8bcff2a | this.spdMain.ClipboardPasted | SCP0099_Business_Plan_LongTerm.cs:401 | finally | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |
| AC-2557616e | this.spdMain.ClipboardPasted | SCP0099_Business_Plan_LongTerm.cs:403 |  | FLAG | cellclipboardPast | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SpdMain_ClipboardPasting

진입점: this.spdMain.ClipboardPasting

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-169a2e4a | this.spdMain.ClipboardPasting | SCP0099_Business_Plan_LongTerm.cs:410 |  | FLAG | cellclipboardPast | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_Business_Plan_LongTerm.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8cd4ad7 | this.spdMain.TopChange | SCP0099_Business_Plan_LongTerm.cs:425 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0099_CreatePlanPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af9b199e | .ctor | SCP0099_CreatePlanPopup.cs:55 |  | FLAG | division_id | pDivId | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_CreatePlanPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aba447be | this.btnButtonList.UsrButtonList_Click_Detected | SCP0099_CreatePlanPopup.cs:209 | else of (buttonItem.UserType == ButtonListType.Save) ▸ if (buttonItem.UserType == ButtonListType.Close) | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_CreatePlanPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fb5cbc99 | Dispose | SCP0099_CreatePlanPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0099_CreatePlanPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae5d8e6f | this.Load | SCP0099_CreatePlanPopup.cs:64 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-44839165 | this.Load | SCP0099_CreatePlanPopup.cs:71 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-15200960 | this.Load | SCP0099_CreatePlanPopup.cs:77 |  | FLAG | action_flag | _action_flag | 화면 필드/플래그 변경 |  |  |  |
| AC-187ae062 | this.Load | SCP0099_CreatePlanPopup.cs:78 |  | FLAG | division_id | _division_id | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_CreatePlanPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0153c33 | this.Load | SCP0099_CreatePlanPopup.cs:95 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-082f0ff0 | this.Load | SCP0099_CreatePlanPopup.cs:96 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f9e60ad0 | this.Load | SCP0099_CreatePlanPopup.cs:97 |  | VALUE_SET | cboDivision.ControlValues | this.division_id | 컨트롤 값 설정 |  |  |  |
| AC-e9429815 | this.Load | SCP0099_CreatePlanPopup.cs:100 |  | UI_PROP | drpPeriodMonth.MonthText1 | DateTime.Now.AddYears(1).ToString("yyyy") + "01" | 속성 MonthText1 설정 |  |  |  |
| AC-e3ca660d | this.Load | SCP0099_CreatePlanPopup.cs:102 |  | UI_PROP | drpPeriodMonth.MonthText2 | DateTime.Now.AddYears(1).ToString("yyyy") + "12" | 속성 MonthText2 설정 |  |  |  |
| AC-9dcc170d | this.Load | SCP0099_CreatePlanPopup.cs:107 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_VERSION_INFO") ⇒ SCP.SCP0099_GET_VERSION_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-a06a8899 | this.Load | SCP0099_CreatePlanPopup.cs:111 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c3cc19bc | this.Load | SCP0099_CreatePlanPopup.cs:113 |  | DATA_OP | request.Parameters["p_division_id"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-8cd6d4fc | this.Load | SCP0099_CreatePlanPopup.cs:115 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-105beed3 | this.Load | SCP0099_CreatePlanPopup.cs:117 |  | LIST_REBIND | clsCtrl.setListBox | (result.Tables[0], clbSaleVer, false, "VERSION_NO", "VERSION_NO") | 목록 컨트롤 재구성 |  |  |  |

## SCP0099_CreatePlanPopup.SaveData

진입점: this.btnButtonList.UsrButtonList_Click_Detected [if (buttonItem.UserType == ButtonListType.Save)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-75d6818d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:154 | if (drpPeriodMonth.MonthText1 == "" \|\| drpPeriodMonth.MonthText2 == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { "Plan Horizon" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cf4a4fed | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:155 | if (drpPeriodMonth.MonthText1 == "" \|\| drpPeriodMonth.MonthText2 == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a102d98e | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:160 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_SAVE_LONGTERM_PLAN") ⇒ SCP.SCP0099_SAVE_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-4a3790ce | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:164 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b6d4ded9 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:166 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-df970d30 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:167 |  | DATA_OP | request.Parameters["p_sale_ver"] | clbSaleVer.SelectedIndex == -1 ? "" : clbSaleVer.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-26e149a9 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:168 |  | DATA_OP | request.Parameters["p_plan_start_date"] | drpPeriodMonth.MonthText1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-7daa83e4 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:169 |  | DATA_OP | request.Parameters["p_plan_end_date"] | drpPeriodMonth.MonthText2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-9f2f2f5d | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:170 |  | DATA_OP | request.Parameters["p_plan_desc"] | txtDesc.Text | 행/컬럼 값 대입 |  |  |  |
| AC-46c723b9 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:171 |  | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a359bbfc | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:173 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56f01110 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:177 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6cfc3de | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:182 | if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-d945991c | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:187 | else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72f07750 | this.btnButtonList.UsrButtonList_Click_Detected [if (buttonI… | SCP0099_CreatePlanPopup.cs:191 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48fd3e1d | .ctor | SCP0099_ExcelUploadPopup.cs:69 |  | FLAG | this.ProgramId | sXlProgramId | 화면 필드/플래그 변경 |  |  |  |
| AC-e30945fb | .ctor | SCP0099_ExcelUploadPopup.cs:70 |  | FLAG | this.SheetName | sXlSheetName | 화면 필드/플래그 변경 |  |  |  |
| AC-79929774 | .ctor | SCP0099_ExcelUploadPopup.cs:71 |  | FLAG | this.NullChk | sXlNullChk | 화면 필드/플래그 변경 |  |  |  |
| AC-48f168d7 | .ctor | SCP0099_ExcelUploadPopup.cs:73 |  | FLAG | DIV_ID | pDivId | 화면 필드/플래그 변경 |  |  |  |
| AC-0b2ebd20 | .ctor | SCP0099_ExcelUploadPopup.cs:74 |  | FLAG | PLAN_ID | pPlanId | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_ExcelUploadPopup.btnOK_Click

진입점: this.btnOK.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8728c1f3 | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:930 | if (sprdResult.Sheets[0].Cells[0, 3].Text == "" && sprdResult.Sheets[0].Cells[1, 3].Text == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00386") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6965828 | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:931 | if (sprdResult.Sheets[0].Cells[0, 3].Text == "" && sprdResult.Sheets[0].Cells[1, 3].Text == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c7f6424d | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:938 | if (sprdResult.Sheets[0].Cells[0, 3].Text != "") ▸ if (sprdResult.Sheets[0].Cells[0, 3].Text != "0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Production EXCEL DATA" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-94d61909 | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:939 | if (sprdResult.Sheets[0].Cells[0, 3].Text != "") ▸ if (sprdResult.Sheets[0].Cells[0, 3].Text != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-493b2722 | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:948 | if (sprdResult.Sheets[0].Cells[1, 3].Text != "") ▸ if (sprdResult.Sheets[0].Cells[1, 3].Text != "0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "RTF EXCEL DATA" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fe0ed3b | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:949 | if (sprdResult.Sheets[0].Cells[1, 3].Text != "") ▸ if (sprdResult.Sheets[0].Cells[1, 3].Text != "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f740ebef | this.btnOK.Click | SCP0099_ExcelUploadPopup.cs:954 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup.Convert_Number

진입점: this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount > 0) ▸ try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ for (j < sprdDetail.Sheets[0].Columns.Count)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-392b303a | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:919 |  | RETURN | return canConvert; |  | 처리 중단/반환 |  |  |  |

## SCP0099_ExcelUploadPopup.ConvertDatatableToXML

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bc18c9d7 | (진입점 미연결) | SCP0099_ExcelUploadPopup.cs:964 |  | CALL_EXT | dt.WriteXml | (str, true) | ⚠ 의미 확인 필요 |  |  |  |
| AC-15cc0900 | (진입점 미연결) | SCP0099_ExcelUploadPopup.cs:965 |  | CALL_EXT | str.Seek | (0, SeekOrigin.Begin) | ⚠ 의미 확인 필요 |  |  |  |
| AC-ff206a57 | (진입점 미연결) | SCP0099_ExcelUploadPopup.cs:967 |  | CALL_EXT | sr.ReadToEnd | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b869a447 | (진입점 미연결) | SCP0099_ExcelUploadPopup.cs:967 |  | RETURN | return sr.ReadToEnd(); |  | 처리 중단/반환 |  |  |  |

## SCP0099_ExcelUploadPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-64abc3fa | Dispose | SCP0099_ExcelUploadPopup.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup.Excel_TempUpload

진입점: this.btnOpen.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-291b09cc | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:205 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-6b7f5d21 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:206 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 3].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-1cffdc05 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:207 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 5].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-583c0758 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:208 |  | GRID_SET | sprdResult.Sheets[0].Cells[1, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-c8a2efa3 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:209 |  | GRID_SET | sprdResult.Sheets[0].Cells[1, 3].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-47a0342b | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:210 |  | GRID_SET | sprdResult.Sheets[0].Cells[1, 5].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-31a5253b | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:211 |  | STATE_RESET | sprdDetail.Sheets[0].Reset | () | 저장/작업 상태 초기화 |  |  |  |
| AC-2b09788e | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:224 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-b60e1be1 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:228 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-914467a0 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:230 | try | STATE | xlApp.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-d0d8eabe | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:231 | try | UI_PROP | xlApp.DisplayAlerts | false | 속성 DisplayAlerts 설정 |  |  |  |
| AC-97e43708 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:233 | try | CALL_EXT | xlApp.Workbooks.Open | (sFileName, Missing.Value, Missing.Value, Missing.Value, Missing.Value, Missing.Value , Mi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-b08ca2f6 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:348 | try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc51c72c | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:352 | try | CALL_EXT | obj.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f259a19a | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:355 | try ▸ if (obj.GetLength(0) == 0) | MESSAGE | MessageBox.Show | ("CMsg.CommonMsg(CRM-00028)", this.SheetName, MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-1492d7c9 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:356 | try ▸ if (obj.GetLength(0) == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f3f95223 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:366 | try | GRID_SET | sprdDetail.Sheets[0].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-6dfc9cef | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:367 | try | GRID_SET | sprdDetail.Sheets[0].ColumnCount | iCCnt | 그리드 속성/값 설정 |  |  |  |
| AC-e79daea2 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:380 | try ▸ for (i < iRCnt + 1) ▸ if (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" … | DATA_OP | sprdDetail.Sheets[0].ColumnHeader.Rows.Add | (iHeadRowIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-76c88066 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:386 | try ▸ for (i < iRCnt + 1) ▸ if (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" … | GRID_SET | sprdDetail.Sheets[0].Cells[iDataRowIdx, iDataColIdx].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-dafbf208 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:390 | try ▸ for (i < iRCnt + 1) ▸ if (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" … | GRID_SET | sprdDetail.Sheets[0].ColumnHeader.Cells[iHeadRowIdx, iDataColIdx].Value | obj.GetValue(i, j).ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "") | 그리드 속성/값 설정 |  |  |  |
| AC-0e36455c | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:398 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | CALL_EXT | sprdDetail.Sheets[0].AddRows | (iDataRowIdx, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7ee76e7f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:403 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | GRID_SET | sprdDetail.Sheets[0].Cells[iDataRowIdx, iDataColIdx].Value | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-7bc4be2b | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:407 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | GRID_SET | sprdDetail.Sheets[0].Cells[iDataRowIdx, iDataColIdx].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-37f98692 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:411 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | GRID_SET | sprdDetail.Sheets[0].Cells[iDataRowIdx, iDataColIdx].Value | obj.GetValue(i, j).ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "") | 그리드 속성/값 설정 |  |  |  |
| AC-de03397f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:535 | try | CALL_EXT | xlRange.get_Value | (Type.Missing) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f569519e | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:539 | try | CALL_EXT | obj.GetLength | (0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3930e3dc | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:542 | try ▸ if (obj.GetLength(0) == 0) | MESSAGE | MessageBox.Show | ("CMsg.CommonMsg(CRM-00028)", this.SheetName, MessageBoxButtons.OK, MessageBoxIcon.Informa… | 메시지 표시 |  |  |  |
| AC-3d4145a2 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:543 | try ▸ if (obj.GetLength(0) == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-a1bcb94a | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:553 | try | GRID_SET | sprdDetail.Sheets[1].RowCount | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-420090fc | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:554 | try | GRID_SET | sprdDetail.Sheets[1].ColumnCount | iCCnt | 그리드 속성/값 설정 |  |  |  |
| AC-5f06f6b2 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:567 | try ▸ for (i < iRCnt + 1) ▸ if (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" … | DATA_OP | sprdDetail.Sheets[1].ColumnHeader.Rows.Add | (iHeadRowIdx, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a893b1f8 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:573 | try ▸ for (i < iRCnt + 1) ▸ if (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" … | GRID_SET | sprdDetail.Sheets[1].Cells[iDataRowIdx, iDataColIdx].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-120f74b6 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:577 | try ▸ for (i < iRCnt + 1) ▸ if (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Replace(" … | GRID_SET | sprdDetail.Sheets[1].ColumnHeader.Cells[iHeadRowIdx, iDataColIdx].Value | obj.GetValue(i, j).ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "") | 그리드 속성/값 설정 |  |  |  |
| AC-9c3dc51e | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:585 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | CALL_EXT | sprdDetail.Sheets[1].AddRows | (iDataRowIdx, 1) | ⚠ 의미 확인 필요 |  |  |  |
| AC-553c8cc4 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:590 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | GRID_SET | sprdDetail.Sheets[1].Cells[iDataRowIdx, iDataColIdx].Value | "0" | 그리드 속성/값 설정 |  |  |  |
| AC-9f04175f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:594 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | GRID_SET | sprdDetail.Sheets[1].Cells[iDataRowIdx, iDataColIdx].Value | "" | 그리드 속성/값 설정 |  |  |  |
| AC-4ba175d8 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:598 | try ▸ for (i < iRCnt + 1) ▸ else of (sFirstTitle == obj.GetValue(i, intAstaFirstIdx + 1).ToString().Trim().ToUpper().Replace("\n", "").Repla… | GRID_SET | sprdDetail.Sheets[1].Cells[iDataRowIdx, iDataColIdx].Value | obj.GetValue(i, j).ToString().Trim().ToUpper().Replace("\n", "").Replace(" ", "") | 그리드 속성/값 설정 |  |  |  |
| AC-48647b8d | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:615 | try ▸ if (sprdDetail.Sheets[0].RowCount == 0 && sprdDetail.Sheets[1].RowCount == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00386") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0ce3f03c | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:616 | try ▸ if (sprdDetail.Sheets[0].RowCount == 0 && sprdDetail.Sheets[1].RowCount == 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-b73638c4 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:624 | try ▸ if (sprdDetail.Sheets[0].RowCount > 0) | GRID_LOCK | si3.LockColumn | (0, si3.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7aef95f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:631 | try ▸ if (sprdDetail.Sheets[1].RowCount > 0) | GRID_LOCK | si3.LockColumn | (0, si3.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-46339130 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:635 | try ▸ if (sprdDetail.Sheets[0].RowCount > 0 \|\| sprdDetail.Sheets[1].RowCount > 0) | UI_PROP | this.Height | this.ResultFormHeight | 속성 Height 설정 |  |  |  |
| AC-54801651 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:637 | try | GRID_SET | sprdDetail.Sheets[0].SheetName | "PRODUCTION" | 그리드 속성/값 설정 |  |  |  |
| AC-b2d4b3f8 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:639 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-e73b482f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:644 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dee54554 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:646 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00055") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1b1cdd4f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:647 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-af13b644 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:651 | finally | CALL_EXT | xlApp.Quit | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-f6d83780 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:652 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup.ExcelUpload2_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c21ecce6 | this.Load | SCP0099_ExcelUploadPopup.cs:80 |  | UI_MISC | this.InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0099_ExcelUploadPopup.GetExcelFileName

진입점: this.btnOpen.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b20b6490 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:184 | try | POPUP | new OpenFileDialog | () | 팝업/폼 생성 |  |  |  |
| AC-622e370f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:186 | try | UI_PROP | openFile.Filter | "Excel files (*.xls;*.xlsx)\|*.xls;*.xlsx\|xls files (*.xls)\|*.xls\|xlsx files (*.xlsx)\|… | 속성 Filter 설정 |  |  |  |
| AC-9fe95a14 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:187 | try | UI_PROP | openFile.FilterIndex | 1 | 속성 FilterIndex 설정 |  |  |  |
| AC-210c4fbb | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:188 | try | UI_PROP | openFile.RestoreDirectory | true | 속성 RestoreDirectory 설정 |  |  |  |
| AC-67173b00 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:189 | try | UI_PROP | openFile.InitialDirectory | @"C:\My Documents\" | 속성 InitialDirectory 설정 |  |  |  |
| AC-b91b7a1f | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:190 | try | UI_PROP | openFile.FileName | string.Empty | 속성 FileName 설정 |  |  |  |
| AC-7deb29ba | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:191 | try | POPUP | openFile.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-854ea2e8 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:193 | try | FLAG | this.FileName | openFile.FileName | 화면 필드/플래그 변경 |  |  |  |
| AC-4e2a9d94 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:194 | try | RETURN | return this.FileName; |  | 처리 중단/반환 |  |  |  |
| AC-7c94bfd0 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:198 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-2ae112da | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:199 | catch ((Exception ex)) | RETURN | return string.Empty; |  | 처리 중단/반환 |  |  |  |

## SCP0099_ExcelUploadPopup.InitClass

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e70f733 | this.Load | SCP0099_ExcelUploadPopup.cs:89 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6105d889 | this.Load | SCP0099_ExcelUploadPopup.cs:90 |  | UI_PROP | this.MaximizeBox | true | 속성 MaximizeBox 설정 |  |  |  |
| AC-35101d3b | this.Load | SCP0099_ExcelUploadPopup.cs:92 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |

## SCP0099_ExcelUploadPopup.InitControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-09410a1e | this.Load | SCP0099_ExcelUploadPopup.cs:96 |  | VALUE_SET | this.Text | SheetName | 컨트롤 값 설정 |  |  |  |
| AC-2b1fe607 | this.Load | SCP0099_ExcelUploadPopup.cs:98 |  | FLAG | InitFormHeight | 140 | 화면 필드/플래그 변경 |  |  |  |
| AC-820f386b | this.Load | SCP0099_ExcelUploadPopup.cs:99 |  | FLAG | ResultFormHeight | 450 | 화면 필드/플래그 변경 |  |  |  |
| AC-e6085a0b | this.Load | SCP0099_ExcelUploadPopup.cs:101 |  | STATE | txtFileName.ReadOnly | true | 컨트롤 상태 ReadOnly |  |  |  |

## SCP0099_ExcelUploadPopup.InitSheet

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91221f04 | this.Load | SCP0099_ExcelUploadPopup.cs:108 |  | GRID_INIT | this.AddSheet | (sprdResult, "Upload Result", "Upload Result", 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-72437fbf | this.Load | SCP0099_ExcelUploadPopup.cs:110 |  | GRID_INIT | si.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8a6e5514 | this.Load | SCP0099_ExcelUploadPopup.cs:112 |  | GRID_INIT | clsCtrl.InitSheet | (si, 0) | 그리드 재구성/초기화 |  |  |  |
| AC-0bc7e610 | this.Load | SCP0099_ExcelUploadPopup.cs:116 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Success", "success_title", FPMerge.None, 150, true, FPHAlign.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-98169ddd | this.Load | SCP0099_ExcelUploadPopup.cs:117 |  | CALL_EXT | clsCtrl.AddNumColumnHash | (si, "Success Count", "success_count", FPMerge.None, 80, true, FPHAlign.Right, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f9e53b0c | this.Load | SCP0099_ExcelUploadPopup.cs:118 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Error", "error_title", FPMerge.None, 80, true, FPHAlign.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc75fa16 | this.Load | SCP0099_ExcelUploadPopup.cs:119 |  | CALL_EXT | clsCtrl.AddNumColumnHash | (si, "Error Count", "error_count", FPMerge.None, 80, true, FPHAlign.Right, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dfb43223 | this.Load | SCP0099_ExcelUploadPopup.cs:120 |  | CALL_EXT | clsCtrl.AddTextColumnHash | (si, "Total", "total_title", FPMerge.None, 80, true, FPHAlign.Right) | ⚠ 의미 확인 필요 |  |  |  |
| AC-33031462 | this.Load | SCP0099_ExcelUploadPopup.cs:121 |  | CALL_EXT | clsCtrl.AddNumColumnHash | (si, "Total Count", "total_count", FPMerge.None, 80, true, FPHAlign.Right, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-58404ba2 | this.Load | SCP0099_ExcelUploadPopup.cs:122 |  | GRID_LOCK | si.LockColumn | (0, si.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d68d1e2 | this.Load | SCP0099_ExcelUploadPopup.cs:124 |  | UI_PROP | sprdResult.HorizontalScrollBarPolicy | ScrollBarPolicy.Never | 속성 HorizontalScrollBarPolicy 설정 |  |  |  |
| AC-1f04b1c6 | this.Load | SCP0099_ExcelUploadPopup.cs:125 |  | UI_PROP | sprdResult.VerticalScrollBarPolicy | ScrollBarPolicy.Never | 속성 VerticalScrollBarPolicy 설정 |  |  |  |
| AC-bb0d944e | this.Load | SCP0099_ExcelUploadPopup.cs:126 |  | UI_PROP | si.Sheet().RowHeaderVisible | false | 속성 RowHeaderVisible 설정 |  |  |  |
| AC-dc74c558 | this.Load | SCP0099_ExcelUploadPopup.cs:127 |  | UI_PROP | si.Sheet().ColumnHeaderVisible | false | 속성 ColumnHeaderVisible 설정 |  |  |  |
| AC-3d562875 | this.Load | SCP0099_ExcelUploadPopup.cs:129 |  | UI_PROP | si.Sheet().RowCount | 2 | 속성 RowCount 설정 |  |  |  |
| AC-26a86045 | this.Load | SCP0099_ExcelUploadPopup.cs:130 |  | GRID_SET | si.Sheet().Columns[0].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-ae0acdca | this.Load | SCP0099_ExcelUploadPopup.cs:131 |  | GRID_SET | si.Sheet().Columns[2].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-bd7b068c | this.Load | SCP0099_ExcelUploadPopup.cs:132 |  | GRID_SET | si.Sheet().Columns[4].BackColor | Color.LightGray | 그리드 속성/값 설정 |  |  |  |
| AC-46c93535 | this.Load | SCP0099_ExcelUploadPopup.cs:134 |  | GRID_SET | si.Sheet().Cells[0, 0].Text | "PRODUCTION : Success Row" | 그리드 속성/값 설정 |  |  |  |
| AC-10e814b6 | this.Load | SCP0099_ExcelUploadPopup.cs:135 |  | GRID_SET | si.Sheet().Cells[0, 2].Text | "Error Row" | 그리드 속성/값 설정 |  |  |  |
| AC-a5c437a2 | this.Load | SCP0099_ExcelUploadPopup.cs:136 |  | GRID_SET | si.Sheet().Cells[0, 4].Text | "Total Row" | 그리드 속성/값 설정 |  |  |  |
| AC-b1d4da38 | this.Load | SCP0099_ExcelUploadPopup.cs:138 |  | GRID_SET | si.Sheet().Cells[1, 0].Text | "RTF : Success Row" | 그리드 속성/값 설정 |  |  |  |
| AC-ac1b47f7 | this.Load | SCP0099_ExcelUploadPopup.cs:139 |  | GRID_SET | si.Sheet().Cells[1, 2].Text | "Error Row" | 그리드 속성/값 설정 |  |  |  |
| AC-0b1e6d4b | this.Load | SCP0099_ExcelUploadPopup.cs:140 |  | GRID_SET | si.Sheet().Cells[1, 4].Text | "Total Row" | 그리드 속성/값 설정 |  |  |  |
| AC-82e36602 | this.Load | SCP0099_ExcelUploadPopup.cs:144 |  | GRID_INIT | this.AddSheet | (sprdDetail, "PRODUCTION", "PRODUCTION", 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9de6f185 | this.Load | SCP0099_ExcelUploadPopup.cs:145 |  | GRID_INIT | this.AddSheet | (sprdDetail, "RTF", "RTF", 1, 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-eb4d6a84 | this.Load | SCP0099_ExcelUploadPopup.cs:148 |  | GRID_INIT | si2.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f54a4115 | this.Load | SCP0099_ExcelUploadPopup.cs:150 |  | GRID_INIT | clsCtrl.InitSheet | (si2, 0) | 그리드 재구성/초기화 |  |  |  |

## SCP0099_ExcelUploadPopup.OnClose_Click

진입점: this.btnCancel.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cacb7423 | this.btnCancel.Click | SCP0099_ExcelUploadPopup.cs:659 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00195") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2ce04f1 | this.btnCancel.Click | SCP0099_ExcelUploadPopup.cs:660 | if (MessageHelper.GMessageBox("MSG00195") == DialogResult.No) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-94562cad | this.btnCancel.Click | SCP0099_ExcelUploadPopup.cs:661 |  | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup.OnOpen_Click

진입점: this.btnOpen.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-665a4ee9 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:173 | if (GetExcelFileName() == string.Empty) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fdea5561 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:174 |  | VALUE_SET | txtFileName.Text | FileName | 컨트롤 값 설정 |  |  |  |
| AC-cdcfdd99 | this.btnOpen.Click | SCP0099_ExcelUploadPopup.cs:176 | if (!Excel_TempUpload(txtFileName.Text)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0099_ExcelUploadPopup.ResetForm

진입점: this.btnOpen.Click / this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c8fb21f | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:156 |  | VALUE_CLEAR | txtFileName.Text | string.Empty | 컨트롤 값 비움 |  |  |  |
| AC-e0a0a543 | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:159 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-36b6bfa8 | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:160 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 3].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-ad15e84b | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:161 |  | GRID_SET | sprdResult.Sheets[0].Cells[0, 5].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-4212471a | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:162 |  | GRID_SET | sprdResult.Sheets[0].Cells[1, 1].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-f810b15f | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:163 |  | GRID_SET | sprdResult.Sheets[0].Cells[1, 3].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-eab3d7ff | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:164 |  | GRID_SET | sprdResult.Sheets[0].Cells[1, 5].Text | "" | 그리드 속성/값 설정 |  |  |  |
| AC-97053730 | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:165 |  | STATE_RESET | sprdDetail.Sheets[0].Reset | () | 저장/작업 상태 초기화 |  |  |  |
| AC-44845a48 | this.btnOpen.Click 외 1 | SCP0099_ExcelUploadPopup.cs:166 |  | UI_PROP | this.Height | InitFormHeight | 속성 Height 설정 |  |  |  |

## SCP0099_ExcelUploadPopup.SaveProd

진입점: this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2afd981e | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:972 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8f1dbd42 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:976 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-51e0b079 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:980 | try | DATA_OP | dt.Columns.Add | ("OPERATION_GROUP") | 데이터 객체 조작/조회 |  |  |  |
| AC-aa21f8cb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:981 | try | DATA_OP | dt.Columns.Add | ("SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4cdc6ecb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:982 | try | DATA_OP | dt.Columns.Add | ("BUILDING") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a103031 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:983 | try | DATA_OP | dt.Columns.Add | ("LINE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-cef982c3 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:984 | try | DATA_OP | dt.Columns.Add | ("NICKNAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-485dc949 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:985 | try | DATA_OP | dt.Columns.Add | ("MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-b76e8d32 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:986 | try | DATA_OP | dt.Columns.Add | ("CUST") | 데이터 객체 조작/조회 |  |  |  |
| AC-c949f332 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:987 | try | DATA_OP | dt.Columns.Add | ("PROJECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-d5bd2fc4 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:988 | try | DATA_OP | dt.Columns.Add | ("UNIT") | 데이터 객체 조작/조회 |  |  |  |
| AC-fc2fe055 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:989 | try | DATA_OP | dt.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-09dc267a | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:992 | try ▸ for (i <= 60) | DATA_OP | dt.Columns.Add | ("M" + i.ToString() + "_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-8fb91bf4 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1000 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6e55a684 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1002 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["OPERATION_GROUP"] | siMain.Sheet().Cells[i, 1].Text | 행/컬럼 값 대입 |  |  |  |
| AC-b93970ae | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1003 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SITE_ID"] | siMain.Sheet().Cells[i, 2].Text | 행/컬럼 값 대입 |  |  |  |
| AC-870ed1f6 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1004 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["BUILDING"] | siMain.Sheet().Cells[i, 3].Text | 행/컬럼 값 대입 |  |  |  |
| AC-322ae0fb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1005 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["LINE_ID"] | siMain.Sheet().Cells[i, 4].Text | 행/컬럼 값 대입 |  |  |  |
| AC-3e22e322 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1006 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["NICKNAME"] | siMain.Sheet().Cells[i, 5].Text | 행/컬럼 값 대입 |  |  |  |
| AC-48f0ed0f | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1007 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["MODEL"] | siMain.Sheet().Cells[i, 6].Text | 행/컬럼 값 대입 |  |  |  |
| AC-38f4cced | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1008 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CUST"] | siMain.Sheet().Cells[i, 7].Text | 행/컬럼 값 대입 |  |  |  |
| AC-db3d3574 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1009 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROJECT"] | siMain.Sheet().Cells[i, 8].Text | 행/컬럼 값 대입 |  |  |  |
| AC-c343b299 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1010 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["UNIT"] | siMain.Sheet().Cells[i, 9].Text | 행/컬럼 값 대입 |  |  |  |
| AC-a4f8cc5f | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1011 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["MEASURE"] | siMain.Sheet().Cells[i, 10].Text | 행/컬럼 값 대입 |  |  |  |
| AC-476c2dc6 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1014 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= 60) | DATA_OP | dr["M" + j.ToString() + "_QTY"] | siMain.Sheet().Cells[i, j + 10].Text == "" ? "0" : siMain.Sheet().Cells[i, j + 10].Text | 행/컬럼 값 대입 |  |  |  |
| AC-16143bab | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1019 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-09860ce3 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1022 | try | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-d245bc0a | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1028 | try | CALL_EXT | sql.AddParameter | ("@SCP0099_PROD", dt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7d78407e | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1029 | try | CALL_EXT | sql.AddParameter | ("@P_DIV", DIV_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6401272f | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1030 | try | CALL_EXT | sql.AddParameter | ("@P_PLAN", PLAN_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d767e951 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1031 | try | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6fadf240 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1032 | try | CALL_EXT | sql.AddParameter | ("@P_DEL_YN", "Y") | ⚠ 의미 확인 필요 |  |  |  |
| AC-3ab4c01d | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1034 | try | ENDPOINT | sql.ExcuteProcedure | ("SavePlanProd") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanProd] \| SCP\An… | 엔드포인트 호출 |  |  |  |
| AC-b695b573 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1039 | try ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "PRODUCTION : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-803d425c | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1041 | try ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-c5aa48dc | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1045 | try ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b090b6bb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1050 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-67a453a4 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1051 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-c1c70ea7 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[0, 3].Text … | SCP0099_ExcelUploadPopup.cs:1055 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup.SaveRTF

진입점: this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text != "")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c6a34d0 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1062 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-202a8359 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1066 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-0f9381cb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1070 | try | DATA_OP | dt.Columns.Add | ("SALES_SITE") | 데이터 객체 조작/조회 |  |  |  |
| AC-62f53893 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1071 | try | DATA_OP | dt.Columns.Add | ("BIZ_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-09c9d042 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1072 | try | DATA_OP | dt.Columns.Add | ("CUST") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0a43069 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1073 | try | DATA_OP | dt.Columns.Add | ("PROJECT") | 데이터 객체 조작/조회 |  |  |  |
| AC-f00db955 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1074 | try | DATA_OP | dt.Columns.Add | ("PROJECT_DESC") | 데이터 객체 조작/조회 |  |  |  |
| AC-ea8a46b7 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1075 | try | DATA_OP | dt.Columns.Add | ("MODEL") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ed2bcaf | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1076 | try | DATA_OP | dt.Columns.Add | ("MODEL_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-faf26ac9 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1077 | try | DATA_OP | dt.Columns.Add | ("CELL_NICKNAME") | 데이터 객체 조작/조회 |  |  |  |
| AC-365c039d | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1078 | try | DATA_OP | dt.Columns.Add | ("CELL_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-72f9d205 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1079 | try | DATA_OP | dt.Columns.Add | ("ELECTRODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e81924a | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1080 | try | DATA_OP | dt.Columns.Add | ("CELL") | 데이터 객체 조작/조회 |  |  |  |
| AC-c917d9e0 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1081 | try | DATA_OP | dt.Columns.Add | ("PACK") | 데이터 객체 조작/조회 |  |  |  |
| AC-b80eca5c | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1082 | try | DATA_OP | dt.Columns.Add | ("UNIT") | 데이터 객체 조작/조회 |  |  |  |
| AC-fd0528c1 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1083 | try | DATA_OP | dt.Columns.Add | ("INCOTERMS") | 데이터 객체 조작/조회 |  |  |  |
| AC-8a273928 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1084 | try | DATA_OP | dt.Columns.Add | ("MEASURE") | 데이터 객체 조작/조회 |  |  |  |
| AC-6444f0b9 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1087 | try ▸ for (i <= 60) | DATA_OP | dt.Columns.Add | ("M" + i.ToString() + "_QTY") | 데이터 객체 조작/조회 |  |  |  |
| AC-b57a9405 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1094 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-123ae48e | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1096 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["SALES_SITE"] | siMain.Sheet().Cells[i, 1].Text | 행/컬럼 값 대입 |  |  |  |
| AC-f6219e43 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1097 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["BIZ_TYPE"] | siMain.Sheet().Cells[i, 2].Text | 행/컬럼 값 대입 |  |  |  |
| AC-9a6ff84c | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1098 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CUST"] | siMain.Sheet().Cells[i, 3].Text | 행/컬럼 값 대입 |  |  |  |
| AC-8fb252eb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1099 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROJECT"] | siMain.Sheet().Cells[i, 4].Text | 행/컬럼 값 대입 |  |  |  |
| AC-cc7d1d0c | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1100 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PROJECT_DESC"] | siMain.Sheet().Cells[i, 5].Text | 행/컬럼 값 대입 |  |  |  |
| AC-1a3cba1d | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1101 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["MODEL"] | siMain.Sheet().Cells[i, 6].Text | 행/컬럼 값 대입 |  |  |  |
| AC-0cdf3402 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1102 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["MODEL_CODE"] | siMain.Sheet().Cells[i, 7].Text | 행/컬럼 값 대입 |  |  |  |
| AC-d1de3de4 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1103 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CELL_NICKNAME"] | siMain.Sheet().Cells[i, 8].Text | 행/컬럼 값 대입 |  |  |  |
| AC-011e849a | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1104 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CELL_CODE"] | siMain.Sheet().Cells[i, 9].Text | 행/컬럼 값 대입 |  |  |  |
| AC-e67e6c58 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1105 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["ELECTRODE"] | siMain.Sheet().Cells[i, 10].Text | 행/컬럼 값 대입 |  |  |  |
| AC-413b8a20 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1106 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["CELL"] | siMain.Sheet().Cells[i, 11].Text | 행/컬럼 값 대입 |  |  |  |
| AC-8ae93d78 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1107 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["PACK"] | siMain.Sheet().Cells[i, 12].Text | 행/컬럼 값 대입 |  |  |  |
| AC-c05cddfb | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1108 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["UNIT"] | siMain.Sheet().Cells[i, 13].Text | 행/컬럼 값 대입 |  |  |  |
| AC-178de94a | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1109 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["INCOTERMS"] | siMain.Sheet().Cells[i, 14].Text | 행/컬럼 값 대입 |  |  |  |
| AC-838624a8 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1110 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["MEASURE"] | siMain.Sheet().Cells[i, 15].Text | 행/컬럼 값 대입 |  |  |  |
| AC-0a1c81dc | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1113 | try ▸ for (i <= siMain.GetMaxRowIndex()) ▸ for (j <= 60) | DATA_OP | dr["M" + j.ToString() + "_QTY"] | siMain.Sheet().Cells[i, j + 15].Text == "" ? "0" : siMain.Sheet().Cells[i, j + 15].Text | 행/컬럼 값 대입 |  |  |  |
| AC-83693c68 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1116 | try ▸ for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dt.Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d8bf8a6f | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1119 | try | DATA_OP | dt.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-197bb3a3 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1125 | try | CALL_EXT | sql.AddParameter | ("@SCP0099_RTF", dt) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7627fdcf | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1126 | try | CALL_EXT | sql.AddParameter | ("@P_DIV", DIV_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb39f253 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1127 | try | CALL_EXT | sql.AddParameter | ("@P_PLAN", PLAN_ID) | ⚠ 의미 확인 필요 |  |  |  |
| AC-f825e995 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1128 | try | CALL_EXT | sql.AddParameter | ("@P_USER_ID", UserInfoContext.Current.UserId) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d06f4485 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1129 | try | CALL_EXT | sql.AddParameter | ("@P_DEL_YN", "Y") | ⚠ 의미 확인 필요 |  |  |  |
| AC-c4ffa6e0 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1131 | try | ENDPOINT | sql.ExcuteProcedure | ("SavePlanRtf") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SavePlanRtf] \| SCP\Ana… | 엔드포인트 호출 |  |  |  |
| AC-3d79a2df | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1136 | try ▸ if (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { "RTF : " + result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-622d95fc | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1138 | try ▸ if (result.Rows[0]["result_code"].ToString() == "S") | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-a76a70f2 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1142 | try ▸ else of (result.Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-27735e26 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1147 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8cf1eed7 | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1148 | catch ((Exception ex)) | MESSAGE | MessageBox.Show | (ex.Message, ex.Source, MessageBoxButtons.OK, MessageBoxIcon.Error) | 메시지 표시 |  |  |  |
| AC-5d3984fd | this.btnOK.Click [if (sprdResult.Sheets[0].Cells[1, 3].Text … | SCP0099_ExcelUploadPopup.cs:1152 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_ExcelUploadPopup.ValidChk_Prod

진입점: this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a515c7c8 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:678 | try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ if (sprdDetail.Sheets[0].Cells[i, 0].Value.ToString() == "" \|\| sprdDetail.Sheets[0].Cells[… | GRID_SET | sprdDetail.Sheets[0].Cells[i, 0].Value | "Error-Division" | 그리드 속성/값 설정 |  |  |  |
| AC-00504303 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:679 | try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ if (sprdDetail.Sheets[0].Cells[i, 0].Value.ToString() == "" \|\| sprdDetail.Sheets[0].Cells[… | GRID_SET | sprdDetail.Sheets[0].Cells[i, 0].ForeColor | ErrorTxtColor | 그리드 속성/값 설정 |  |  |  |
| AC-4dba3dd3 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:747 | try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ for (j < sprdDetail.Sheets[0].Columns.Count) ▸ if (!Convert_Number(sprdDetail.Sheets[0].Cell… | GRID_SET | sprdDetail.Sheets[0].Cells[i, j].Value | "Error-Number" | 그리드 속성/값 설정 |  |  |  |
| AC-776fae69 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:748 | try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ for (j < sprdDetail.Sheets[0].Columns.Count) ▸ if (!Convert_Number(sprdDetail.Sheets[0].Cell… | GRID_SET | sprdDetail.Sheets[0].Cells[i, j].ForeColor | ErrorTxtColor | 그리드 속성/값 설정 |  |  |  |
| AC-b5bb08c1 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:753 | try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ for (j < sprdDetail.Sheets[0].Columns.Count) ▸ else of (!Convert_Number(sprdDetail.Sheets[0]… | GRID_SET | sprdDetail.Sheets[0].Cells[i, j].CellType | numCell | 그리드 속성/값 설정 |  |  |  |
| AC-94b6fb79 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:758 | try ▸ for (i < sprdDetail.Sheets[0].RowCount) ▸ if (intError > 0) | GRID_SET | sprdDetail.Sheets[0].Rows[i].BackColor | ErrorColor | 그리드 속성/값 설정 |  |  |  |
| AC-e21a068b | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:765 | try | GRID_SET | sprdResult.Sheets[0].Cells[0, 1].Text | intSuccess.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-b8b7d995 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:766 | try | GRID_SET | sprdResult.Sheets[0].Cells[0, 3].Text | intRowError.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-bba170a5 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:767 | try | GRID_SET | sprdResult.Sheets[0].Cells[0, 5].Text | intTotal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-bc277b16 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:771 | try ▸ if (intError > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-498a72d6 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:773 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-6d72f0d7 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[0].RowCount … | SCP0099_ExcelUploadPopup.cs:778 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0099_ExcelUploadPopup.ValidChk_RTF

진입점: this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e347e300 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:796 | try ▸ for (i < sprdDetail.Sheets[1].RowCount) ▸ if (sprdDetail.Sheets[1].Cells[i, 0].Value.ToString() == "" \|\| sprdDetail.Sheets[1].Cells[… | GRID_SET | sprdDetail.Sheets[1].Cells[i, 0].Value | "Error-Division" | 그리드 속성/값 설정 |  |  |  |
| AC-a17e765b | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:797 | try ▸ for (i < sprdDetail.Sheets[1].RowCount) ▸ if (sprdDetail.Sheets[1].Cells[i, 0].Value.ToString() == "" \|\| sprdDetail.Sheets[1].Cells[… | GRID_SET | sprdDetail.Sheets[1].Cells[i, 0].ForeColor | ErrorTxtColor | 그리드 속성/값 설정 |  |  |  |
| AC-2e02e6a5 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:878 | try ▸ for (i < sprdDetail.Sheets[1].RowCount) ▸ for (j < sprdDetail.Sheets[1].Columns.Count) ▸ if (!Convert_Number(sprdDetail.Sheets[1].Cell… | GRID_SET | sprdDetail.Sheets[1].Cells[i, j].Value | "Error-Number" | 그리드 속성/값 설정 |  |  |  |
| AC-994753ae | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:879 | try ▸ for (i < sprdDetail.Sheets[1].RowCount) ▸ for (j < sprdDetail.Sheets[1].Columns.Count) ▸ if (!Convert_Number(sprdDetail.Sheets[1].Cell… | GRID_SET | sprdDetail.Sheets[1].Cells[i, j].ForeColor | ErrorTxtColor | 그리드 속성/값 설정 |  |  |  |
| AC-12a5b6bf | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:884 | try ▸ for (i < sprdDetail.Sheets[1].RowCount) ▸ for (j < sprdDetail.Sheets[1].Columns.Count) ▸ else of (!Convert_Number(sprdDetail.Sheets[1]… | GRID_SET | sprdDetail.Sheets[1].Cells[i, j].CellType | numCell | 그리드 속성/값 설정 |  |  |  |
| AC-acbaa81f | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:889 | try ▸ for (i < sprdDetail.Sheets[1].RowCount) ▸ if (intError > 0) | GRID_SET | sprdDetail.Sheets[1].Rows[i].BackColor | ErrorColor | 그리드 속성/값 설정 |  |  |  |
| AC-3a280605 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:896 | try | GRID_SET | sprdResult.Sheets[0].Cells[1, 1].Text | intSuccess.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-a29749be | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:897 | try | GRID_SET | sprdResult.Sheets[0].Cells[1, 3].Text | intRowError.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-4c5a0555 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:898 | try | GRID_SET | sprdResult.Sheets[0].Cells[1, 5].Text | intTotal.ToString() | 그리드 속성/값 설정 |  |  |  |
| AC-c5d37557 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:902 | try ▸ if (intError > 0) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-9a20c975 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:904 | try | RETURN | return true; |  | 처리 중단/반환 |  |  |  |
| AC-27652f70 | this.btnOpen.Click [try ▸ if (sprdDetail.Sheets[1].RowCount … | SCP0099_ExcelUploadPopup.cs:909 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## SCP0099_PlanCopyPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0853295 | .ctor | SCP0099_PlanCopyPopup.cs:55 |  | FLAG | division_id | pDivId | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_PlanCopyPopup.btnCopy_Click

진입점: this.btnCopy.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fb44539 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:226 | if (cboPlanDate.ControlValues == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Plan Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0dcacf67 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:227 | if (cboPlanDate.ControlValues == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-134a8a79 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:232 | if (cboPlanSeq.ControlValues == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Plan Seq" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-38ed014b | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:233 | if (cboPlanSeq.ControlValues == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e0b85285 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:237 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00077", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-60267061 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:239 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-97ac1108 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:240 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1b388f25 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:244 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_SAVE_LONGTERM_PLAN_COPY") ⇒ SCP.SCP0099_SAVE_LONGTERM_PLAN_COPY | 엔드포인트 요청 생성 |  |  |  |
| AC-859e961c | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:248 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b891d66b | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:250 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | DATA_OP | request.Parameters["p_division_id"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c2a5d181 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:251 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | cboPlanDate.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d9fe655b | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:252 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | DATA_OP | request.Parameters["p_plan_type"] | cboPlanType.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-bd4841d7 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:253 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | DATA_OP | request.Parameters["p_plan_seq"] | cboPlanSeq.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-88533ef3 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:254 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | DATA_OP | request.Parameters["p_plan_id"] | cboPlan.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-2b1c36ac | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:255 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-9fbee090 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:257 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1691cfb4 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:261 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToString()… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Tables[0].Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aea67c89 | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:263 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToString()… | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |
| AC-14a6caba | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:267 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) ▸ else of (result.Tables[0].Rows[0]["result_code"].ToStr… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44086d5d | this.btnCopy.Click | SCP0099_PlanCopyPopup.cs:270 | if (MessageHelper.GMessageBox("MSG00077", new object[] { "" }) == DialogResult.Yes) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_PlanCopyPopup.cboPlanDate_SelectedIndexChanged

진입점: this.cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a8372a6 | this.cboPlanDate.SelectedIndexChanged | SCP0099_PlanCopyPopup.cs:212 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, this.division_id, this.cboPlanDate.ControlValues, "FN") ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-eaba488a | this.cboPlanDate.SelectedIndexChanged | SCP0099_PlanCopyPopup.cs:213 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1331c134 | this.cboPlanDate.SelectedIndexChanged | SCP0099_PlanCopyPopup.cs:217 | if (dtPlanSeq.Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0099_PlanCopyPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-035f267d | Dispose | SCP0099_PlanCopyPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0099_PlanCopyPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d72f1e85 | this.Load | SCP0099_PlanCopyPopup.cs:64 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-907b8db2 | this.Load | SCP0099_PlanCopyPopup.cs:71 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-4dc0d64c | this.Load | SCP0099_PlanCopyPopup.cs:81 |  | FLAG | action_flag | _action_flag | 화면 필드/플래그 변경 |  |  |  |
| AC-ff77c9dd | this.Load | SCP0099_PlanCopyPopup.cs:82 |  | FLAG | division_id | _division_id | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_PlanCopyPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b0c3f3e | this.Load | SCP0099_PlanCopyPopup.cs:155 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-c0634d80 | this.Load | SCP0099_PlanCopyPopup.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e11c4c6d | this.Load | SCP0099_PlanCopyPopup.cs:157 |  | VALUE_SET | cboDivision.ControlValues | this.division_id | 컨트롤 값 설정 |  |  |  |
| AC-a6bdb504 | this.Load | SCP0099_PlanCopyPopup.cs:162 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_VERSION_INFO") ⇒ SCP.SCP0099_GET_VERSION_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-6f9e5848 | this.Load | SCP0099_PlanCopyPopup.cs:166 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cab4c26a | this.Load | SCP0099_PlanCopyPopup.cs:168 |  | DATA_OP | request.Parameters["p_division_id"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c81c88b3 | this.Load | SCP0099_PlanCopyPopup.cs:170 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-31a4f956 | this.Load | SCP0099_PlanCopyPopup.cs:172 |  | LIST_REBIND | clsCtrl.setListBox | (result.Tables[0], cboPlan, false, "VERSION_NO", "VERSION_NO") | 목록 컨트롤 재구성 |  |  |  |

## SCP0099_PlanCopyPopup.setCboPlan

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-861403e1 | this.Load | SCP0099_PlanCopyPopup.cs:89 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_LONGTERM_PLAN") ⇒ SCP.SCP0099_GET_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-4a9092f2 | this.Load | SCP0099_PlanCopyPopup.cs:93 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8e6bb577 | this.Load | SCP0099_PlanCopyPopup.cs:95 |  | DATA_OP | request.Parameters["p_division_id"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c6964824 | this.Load | SCP0099_PlanCopyPopup.cs:96 |  | DATA_OP | request.Parameters["p_valid_yn"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-4c53bea9 | this.Load | SCP0099_PlanCopyPopup.cs:97 |  | DATA_OP | request.Parameters["p_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-6af665fc | this.Load | SCP0099_PlanCopyPopup.cs:99 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-367e9143 | this.Load | SCP0099_PlanCopyPopup.cs:103 |  | LIST_REBIND | clsCtrl.setListBox | (result.Tables[0], cboPlan, false, "PLAN_ID", "PLAN_ID") | 목록 컨트롤 재구성 |  |  |  |
| AC-86ba31b8 | this.Load | SCP0099_PlanCopyPopup.cs:104 | if (cboPlan.Items.Count > 0) | VALUE_SET | cboPlan.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0099_PlanCopyPopup.setPlanDate

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f8a43cf | this.Load | SCP0099_PlanCopyPopup.cs:115 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_LONGTERM_PLAN_DATE") ⇒ SCP.SCP0099_GET_LONGTERM_PLAN_DATE | 엔드포인트 요청 생성 |  |  |  |
| AC-dd6cb560 | this.Load | SCP0099_PlanCopyPopup.cs:119 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fea7c2d6 | this.Load | SCP0099_PlanCopyPopup.cs:121 |  | DATA_OP | request.Parameters["p_division_id"] | division_id | 행/컬럼 값 대입 |  |  |  |
| AC-813e64bc | this.Load | SCP0099_PlanCopyPopup.cs:123 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ba6fe602 | this.Load | SCP0099_PlanCopyPopup.cs:127 |  | LIST_REBIND | clsCtrl.setListBox | (result.Tables[0], cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-84b59e05 | this.Load | SCP0099_PlanCopyPopup.cs:128 | if (cboPlanDate.Items.Count > 0) | VALUE_SET | cboPlanDate.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0099_PlanCopyPopup.setPlanType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb4362a4 | this.Load | SCP0099_PlanCopyPopup.cs:134 |  | DATA_OP | dt.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-819d5e34 | this.Load | SCP0099_PlanCopyPopup.cs:135 |  | DATA_OP | dt.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-f333d4db | this.Load | SCP0099_PlanCopyPopup.cs:137 |  | DATA_OP | dt.Rows.Add | (new object[] { "FN", "FN" }) | 데이터 객체 조작/조회 |  |  |  |
| AC-db9aae20 | this.Load | SCP0099_PlanCopyPopup.cs:138 |  | LIST_REBIND | clsCtrl.setListBox | (dt, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a57d92ab | this.Load | SCP0099_PlanCopyPopup.cs:139 |  | VALUE_SET | cboPlanType.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |

## SCP0099_PlanInfoPopup..ctor

진입점: .ctor

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-749cb1c8 | .ctor | SCP0099_PlanInfoPopup.cs:86 |  | UI_PROP | this.IsPopup | true | 속성 IsPopup 설정 |  |  |  |
| AC-209f1d1f | .ctor | SCP0099_PlanInfoPopup.cs:89 |  | FLAG | p_division_id | pDivId | 화면 필드/플래그 변경 |  |  |  |
| AC-6637599a | .ctor | SCP0099_PlanInfoPopup.cs:90 |  | VALUE_SET | this.lblDivision.Text | pDiVTxt | 컨트롤 값 설정 |  |  |  |

## SCP0099_PlanInfoPopup.btnButtonList_UsrButtonList_Click_Detected

진입점: this.btnButtonList.UsrButtonList_Click_Detected

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c52a686 | this.btnButtonList.UsrButtonList_Click_Detected | SCP0099_PlanInfoPopup.cs:204 | switch (buttonItem.UserType) case ButtonListType.Close: | UI_MISC | this.Close | () | 창 닫기/해제 |  |  |  |

## SCP0099_PlanInfoPopup.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6bdea8b | this.Load | SCP0099_PlanInfoPopup.cs:130 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4edc435c | this.Load | SCP0099_PlanInfoPopup.cs:131 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f602e624 | this.Load | SCP0099_PlanInfoPopup.cs:132 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0099_PlanInfoPopup.DelPlan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21054274 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:217 | if (strSelectedPlanID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00071") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c28c5899 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:218 | if (strSelectedPlanID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32d9f3e7 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:220 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d8243afb | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:224 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_DEL_LONGTERM_PLAN") ⇒ SCP.SCP0099_DEL_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-c51eb973 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:228 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-c7db78c8 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:230 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c5c00cd6 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:231 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | DATA_OP | request.Parameters["v_plan_id"] | strSelectedPlanID | 행/컬럼 값 대입 |  |  |  |
| AC-860e1b23 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:232 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-10d249de | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:234 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f823b56 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:238 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | FLAG | isEdit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-efbb4337 | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:239 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00031") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-537d9eca | (진입점 미연결) | SCP0099_PlanInfoPopup.cs:244 | if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ else of (result.Tables[0].Rows[0]["result_code"].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0099_PlanInfoPopup.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c76044e9 | Dispose | SCP0099_PlanInfoPopup.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0099_PlanInfoPopup.FindData

진입점: this.btnRelease.Click [else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes)] / this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete: ▸ else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes)] / this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76fef5d8 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:171 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_GET_LONGTERM_PLAN") ⇒ SCP.SCP0099_GET_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-a6965f33 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:175 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2c053aa9 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:177 |  | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e0139ca0 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:178 |  | DATA_OP | request.Parameters["p_valid_yn"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-6c5d56c1 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:179 |  | DATA_OP | request.Parameters["p_PLAN_ID"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-f4905d4c | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:181 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-39e84163 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:185 |  | GRID_BIND | siMain.Query | (result) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5bc9b099 | this.btnRelease.Click [else of (strSelVal == "") ▸ if (Messa… 외 4 | SCP0099_PlanInfoPopup.cs:190 |  | FLAG | strSelectedPlanID | "" | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_PlanInfoPopup.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3acedbfc | this.Load | SCP0099_PlanInfoPopup.cs:106 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0099_PlanInfoPopup.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-414e0a53 | this.Load | SCP0099_PlanInfoPopup.cs:125 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## SCP0099_PlanInfoPopup.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d64631e | this.Load | SCP0099_PlanInfoPopup.cs:139 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-ebfd0767 | this.Load | SCP0099_PlanInfoPopup.cs:140 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-70d22651 | this.Load | SCP0099_PlanInfoPopup.cs:141 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d963c9c2 | this.Load | SCP0099_PlanInfoPopup.cs:142 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0099_PlanInfoPopup.OKButtonClick

진입점: this.btnButtonList.UsrButtonList_Click_Detected [switch (buttonItem.UserType) case ButtonListType.Delete:]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fbcaede | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:256 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ececb2ca | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:273 | if (siMain.Sheet().Rows.Count > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK)).ToSt… | MESSAGE | MessageHelper.GMessageBox | ("MSG00086", new object[] { "Released plans cannot be deleted" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-aff24b69 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:274 | if (siMain.Sheet().Rows.Count > 0) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(i, siMain.GetColumnIndex(DefColumns.CHK)).ToSt… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-349b4c2c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:291 | if (strSelVal == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00021") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a605e07 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:292 | if (strSelVal == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ff497f6d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:296 | else of (strSelVal == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5a2f892d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:300 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_DEL_LONGTERM_PLAN") ⇒ SCP.SCP0099_DEL_LONGTERM_PLAN | 엔드포인트 요청 생성 |  |  |  |
| AC-103344d6 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:304 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5ba34a50 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:306 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-da1e81f9 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:307 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | DATA_OP | request.Parameters["v_plan_id"] | strSelVal | 행/컬럼 값 대입 |  |  |  |
| AC-5fb6d118 | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:308 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a7bfd74c | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:310 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-99635b4d | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:314 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToS… | FLAG | isEdit | true | 화면 필드/플래그 변경 |  |  |  |
| AC-cbd90d3e | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:315 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00031") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58c61b3f | this.btnButtonList.UsrButtonList_Click_Detected [switch (but… | SCP0099_PlanInfoPopup.cs:320 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00016") == DialogResult.Yes) ▸ else of (result.Tables[0].Rows[0]["result_code"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0099_PlanInfoPopup.ReleasePlan

진입점: this.btnRelease.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5962e5b | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:334 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e153a0df | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:371 | if (strSelVal == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00021") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d422f69 | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:372 | if (strSelVal == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f315ba5 | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:376 | else of (strSelVal == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00015") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-66038f0f | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:378 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-8d82d888 | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:379 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7f03b476 | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:383 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE") ⇒ SCP.SCP0099_SAVE_LONGTERM_PLAN_RELEASE | 엔드포인트 요청 생성 |  |  |  |
| AC-a000284b | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:387 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-43cbbb3e | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:389 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-60e6456c | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:390 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | DATA_OP | request.Parameters["v_plan_id"] | strSelVal | 행/컬럼 값 대입 |  |  |  |
| AC-2cc58c44 | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:391 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | DATA_OP | request.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-0e97ebec | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:393 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6cd0036b | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:395 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-15384fc5 | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:399 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) ▸ if (result.Tables[0].Rows[0]["result_code"].ToS… | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e81b489b | this.btnRelease.Click | SCP0099_PlanInfoPopup.cs:403 | else of (strSelVal == "") ▸ if (MessageHelper.GMessageBox("MSG00015") == DialogResult.Yes) ▸ else of (result.Tables[0].Rows[0]["result_code"… | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0099_PlanInfoPopup.SCP0099_PlanInfoPopup_FormClosing

진입점: this.FormClosing

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5411201c | this.FormClosing | SCP0099_PlanInfoPopup.cs:418 | if (isEdit) | UI_PROP | this.DialogResult | DialogResult.OK | 속성 DialogResult 설정 |  |  |  |

## SCP0099_PlanInfoPopup.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d8b3e43d | this.spdMain.CellClick | SCP0099_PlanInfoPopup.cs:413 |  | FLAG | strSelectedPlanID | siMain.GetValue(e.Row, siMain.GetColumnIndex("PLAN_ID")).ToString() | 화면 필드/플래그 변경 |  |  |  |

