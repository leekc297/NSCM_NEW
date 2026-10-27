# AS-IS 액션 대조표 — SCP0072

> 원천: `Doc/asisfacts/screens/SCP0072/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 208행 · 메서드 26 · 종류 GRID_SET 41 · DATA_OP 32 · GRID_INIT 23 · FLAG 16 · RETURN 16 · UI_MISC 12 · ENDPOINT 11 · UI_PROP 9 · LIST_REBIND 8 · VALUE_SET 8 · POPUP 7 · COMBO_DATA 5 · MESSAGE 5 · CALL_EXT 5 · GRID_CLEAR 3 · VALIDATE 2 · LIST_BIND 2 · GRID_BIND 1 · GRID_LOCK 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 5


## SCP0072_CAPA_Balance.BtnItem_Id_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af7f6129 | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1183 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-402bedc2 | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1185 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f21f0e94 | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1186 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-bc5bdb82 | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1187 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0072_CAPA_Balance.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13f0c5ba | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1118 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0038", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-bab821ca | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1119 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f2ea687c | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1120 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f46522b1 | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1123 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-04b40f39 | (진입점 미연결) | SCP0072_CAPA_Balance.cs:1125 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0072_CAPA_Balance.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-584464e1 | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1158 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-74af4c7d | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1158 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-200c188f | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1159 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1f00ac38 | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1161 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-b301e99e | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1164 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-1da097e7 | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1165 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-a5f0a507 | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1169 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-1e4787e1 | cboPlanDate.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1170 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0072_CAPA_Balance.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc586121 | cboPlanSeq.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:332 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-cb46f406 | cboPlanSeq.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:335 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-493fb9b8 | cboPlanSeq.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:336 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0072_CAPA_Balance.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61c13d7e | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1141 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-e935053b | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1141 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ccc74ba3 | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1142 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-079608b7 | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1144 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-f41abee6 | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1147 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-fe51def3 | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1150 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-957added | cboPlanType.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:1151 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0072_CAPA_Balance.cboQTY_SelectedIndexChanged

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-410f6e08 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:343 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0072_CAPA_Balance.Check_PeriodDate

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05c519a2 | FindButton [try] | SCP0072_CAPA_Balance.cs:1079 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-73ab3f5f | FindButton [try] | SCP0072_CAPA_Balance.cs:1080 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-3c262ded | FindButton [try] | SCP0072_CAPA_Balance.cs:1089 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-04c523a2 | FindButton [try] | SCP0072_CAPA_Balance.cs:1090 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-0fa51631 | FindButton [try] | SCP0072_CAPA_Balance.cs:1098 | try ▸ if (nDate2 >= nDate1After1Year) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00172", new object[] { ((82 * 7 - 1) + 7).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2a427235 | FindButton [try] | SCP0072_CAPA_Balance.cs:1099 | try ▸ if (nDate2 >= nDate1After1Year) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-eff0cbc0 | FindButton [try] | SCP0072_CAPA_Balance.cs:1104 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-975c09d1 | FindButton [try] | SCP0072_CAPA_Balance.cs:1105 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f981dd4c | FindButton [try] | SCP0072_CAPA_Balance.cs:1108 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0072_CAPA_Balance.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-295a1166 | this.Load | SCP0072_CAPA_Balance.cs:222 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4200de91 | this.Load | SCP0072_CAPA_Balance.cs:223 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-97e4ac2b | this.Load | SCP0072_CAPA_Balance.cs:224 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0072_CAPA_Balance.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-48781606 | this.Load | SCP0072_CAPA_Balance.cs:155 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-79406913 | this.Load | SCP0072_CAPA_Balance.cs:156 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |

## SCP0072_CAPA_Balance.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-218bcdc9 | Dispose | SCP0072_CAPA_Balance.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0072_CAPA_Balance.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bac1590 | FindButton | SCP0072_CAPA_Balance.cs:562 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-aca7fc50 | FindButton | SCP0072_CAPA_Balance.cs:567 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-345b6b89 | FindButton | SCP0072_CAPA_Balance.cs:567 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92190b4c | FindButton | SCP0072_CAPA_Balance.cs:568 | try ▸ if (!Check_PeriodDate(dCalendar, PeriodType.W82)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cef28110 | FindButton | SCP0072_CAPA_Balance.cs:571 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f05b2310 | FindButton | SCP0072_CAPA_Balance.cs:588 | try | VALUE_SET | cboQTY.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-e95db94c | FindButton | SCP0072_CAPA_Balance.cs:593 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-69e5a8da | FindButton | SCP0072_CAPA_Balance.cs:595 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a889834e | FindButton | SCP0072_CAPA_Balance.cs:598 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0072_GET_CAPA_BALANCE_8182") ⇒ SCP.SCP0072_GET_CAPA_BALANCE_8182 | 엔드포인트 요청 생성 |  |  |  |
| AC-14a9cfb5 | FindButton | SCP0072_CAPA_Balance.cs:599 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d36ab3a4 | FindButton | SCP0072_CAPA_Balance.cs:600 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b265412a | FindButton | SCP0072_CAPA_Balance.cs:601 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0aea7dfd | FindButton | SCP0072_CAPA_Balance.cs:602 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-024944dc | FindButton | SCP0072_CAPA_Balance.cs:604 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4155e526 | FindButton | SCP0072_CAPA_Balance.cs:605 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-fd7d5e13 | FindButton | SCP0072_CAPA_Balance.cs:606 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-b26cd66f | FindButton | SCP0072_CAPA_Balance.cs:607 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0072" | 행/컬럼 값 대입 |  |  |  |
| AC-c90aaf29 | FindButton | SCP0072_CAPA_Balance.cs:608 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-65b81380 | FindButton | SCP0072_CAPA_Balance.cs:609 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-ffcc19b0 | FindButton | SCP0072_CAPA_Balance.cs:610 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-6b1ecd4b | FindButton | SCP0072_CAPA_Balance.cs:611 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35a2a9d4 | FindButton | SCP0072_CAPA_Balance.cs:612 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5d4a4a46 | FindButton | SCP0072_CAPA_Balance.cs:622 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c9da3a59 | FindButton | SCP0072_CAPA_Balance.cs:623 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e701e671 | FindButton | SCP0072_CAPA_Balance.cs:627 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-bcf50b6e | FindButton | SCP0072_CAPA_Balance.cs:628 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-28d3f943 | FindButton | SCP0072_CAPA_Balance.cs:630 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-e1ec88b3 | FindButton | SCP0072_CAPA_Balance.cs:635 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5b3f10e3 | FindButton | SCP0072_CAPA_Balance.cs:636 | try | VALUE_SET | cboQTY.SelectedIndex | iSetQty | 컨트롤 값 설정 |  |  |  |
| AC-cba38f2d | FindButton | SCP0072_CAPA_Balance.cs:637 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-56a43fa8 | FindButton | SCP0072_CAPA_Balance.cs:646 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ce48b41 | FindButton | SCP0072_CAPA_Balance.cs:648 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0072_CAPA_Balance.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1c870f6 | this.Load | SCP0072_CAPA_Balance.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0072_CAPA_Balance.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2783452 | this.Load | SCP0072_CAPA_Balance.cs:1006 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_BUCKET_TYPE_CODE") ⇒ SCP.SCP0070_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-978613e3 | this.Load | SCP0072_CAPA_Balance.cs:1007 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f9442504 | this.Load | SCP0072_CAPA_Balance.cs:1009 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0072_CAPA_Balance.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-974ca01e | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1048 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c3f31f40 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1049 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-805317bd | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1058 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-d3a48182 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1059 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-cbe6d905 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1060 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-5c11b643 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1061 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-abb814fe | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1062 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65926438 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:1064 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0072_CAPA_Balance.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b06f2a8a | this.Load | SCP0072_CAPA_Balance.cs:1018 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_QTY_TYPE_CODE") ⇒ SCP.SCP0070_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-5ec41cb1 | this.Load | SCP0072_CAPA_Balance.cs:1019 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0ead331 | this.Load | SCP0072_CAPA_Balance.cs:1022 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0072_CAPA_Balance.GetSpdTitle

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d8f6293 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:1038 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-bb87323d | this.Load 외 3 | SCP0072_CAPA_Balance.cs:1039 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8d640773 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:1040 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-08b41eb2 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:1042 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-97d2afd8 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:1042 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0072_CAPA_Balance.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61fa7fa2 | this.Load | SCP0072_CAPA_Balance.cs:164 | if (dtDivision.Rows.Count > 0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b1b520fe | this.Load | SCP0072_CAPA_Balance.cs:165 | if (dtDivision.Rows.Count > 0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-443bf6fd | this.Load | SCP0072_CAPA_Balance.cs:175 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-c4628e60 | this.Load | SCP0072_CAPA_Balance.cs:176 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-6055ea67 | this.Load | SCP0072_CAPA_Balance.cs:177 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-31f69dc4 | this.Load | SCP0072_CAPA_Balance.cs:179 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-1de8d2ea | this.Load | SCP0072_CAPA_Balance.cs:183 | if (dtDivision.Rows.Count > 0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-7a3fa74e | this.Load | SCP0072_CAPA_Balance.cs:184 | if (dtDivision.Rows.Count > 0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-a2b75d16 | this.Load | SCP0072_CAPA_Balance.cs:186 | if (dtDivision.Rows.Count > 0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ebc5f7e1 | this.Load | SCP0072_CAPA_Balance.cs:188 | if (dtDivision.Rows.Count > 0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-bb5fd4c7 | this.Load | SCP0072_CAPA_Balance.cs:189 | if (dtDivision.Rows.Count > 0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-dc7c3530 | this.Load | SCP0072_CAPA_Balance.cs:189 | if (dtDivision.Rows.Count > 0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ec5a1d90 | this.Load | SCP0072_CAPA_Balance.cs:196 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-8b10adae | this.Load | SCP0072_CAPA_Balance.cs:199 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-633ff0fd | this.Load | SCP0072_CAPA_Balance.cs:200 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-e5319cf2 | this.Load | SCP0072_CAPA_Balance.cs:201 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-dfd3979f | this.Load | SCP0072_CAPA_Balance.cs:203 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6f8f056b | this.Load | SCP0072_CAPA_Balance.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-af6261cd | this.Load | SCP0072_CAPA_Balance.cs:210 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-6668e30e | this.Load | SCP0072_CAPA_Balance.cs:212 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-904020a5 | this.Load | SCP0072_CAPA_Balance.cs:214 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ae24154e | this.Load | SCP0072_CAPA_Balance.cs:216 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-c974fa2b | this.Load | SCP0072_CAPA_Balance.cs:217 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0072_CAPA_Balance.InitSpread

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ed08868 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:230 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-41efa603 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:233 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-ac03255a | this.Load 외 3 | SCP0072_CAPA_Balance.cs:240 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0072_CAPA_Balance.InitSpreadDateColumn

진입점: this.Load / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76a3187f | this.Load 외 3 | SCP0072_CAPA_Balance.cs:277 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ba35e468 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:278 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a4ef9597 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:287 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10e7f45e | this.Load 외 3 | SCP0072_CAPA_Balance.cs:288 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93b0e18d | this.Load 외 3 | SCP0072_CAPA_Balance.cs:293 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da44950c | this.Load 외 3 | SCP0072_CAPA_Balance.cs:294 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f4c478d5 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:301 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f0e9b065 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:302 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13fa1bec | this.Load 외 3 | SCP0072_CAPA_Balance.cs:312 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cb9a7d6 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:313 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-694799df | this.Load 외 3 | SCP0072_CAPA_Balance.cs:314 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bdc25a89 | this.Load 외 3 | SCP0072_CAPA_Balance.cs:315 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0072_CAPA_Balance.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca050eac | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:983 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15793f1b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:995 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-1c87745f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:999 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0072_CAPA_Balance.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8687f9e6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:670 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Y_") == 0) | DATA_OP | listYear.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5b03324b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:674 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("Q_") == 0) | DATA_OP | listQuater.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-3b6dedef | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:678 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-c654f141 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:682 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-d20c7cdb | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:728 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-cc28c858 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:734 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 2][iCol] | temp | 그리드 속성/값 설정 |  |  |  |
| AC-caa7d1bc | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:755 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-71b7ef1c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:761 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 2][iCol] | temp | 그리드 속성/값 설정 |  |  |  |
| AC-992ffbfd | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:782 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-179cbc5a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:787 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 2][iCol] | dTempPROD_PLAN / dTempCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-d6f43e66 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:807 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-560ec714 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:813 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (col… | GRID_SET | dsBinding.Tables[0].Rows[iRow + 2][iCol] | temp | 그리드 속성/값 설정 |  |  |  |
| AC-fc8dff1e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:857 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-3494f13c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:858 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-fee554fd | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:859 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-1fe372c3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:860 | for (i < listYear.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHearderSumMcQty | 그리드 속성/값 설정 |  |  |  |
| AC-bbc58085 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:863 | for (i < listYear.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-f1b1808f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:865 | for (i < listYear.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-9b44a393 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:893 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-26ec7a27 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:894 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-d2fa7674 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:895 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-67c79c32 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:896 | for (i < listQuater.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHearderSumMcQty | 그리드 속성/값 설정 |  |  |  |
| AC-0b4aa6a0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:899 | for (i < listQuater.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-e7aaa573 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:901 | for (i < listQuater.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-d99d4c3a | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:929 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-43809484 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:930 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-e28da8d2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:931 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-da14311b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:932 | for (i < listMonth.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHearderSumMcQty | 그리드 속성/값 설정 |  |  |  |
| AC-a00655d5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:935 | for (i < listMonth.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-3115ad8c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:937 | for (i < listMonth.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |
| AC-99dbeda1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:964 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[0][idx] | dHeaderSumPROD_PLAN | 그리드 속성/값 설정 |  |  |  |
| AC-799e5608 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:965 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[1][idx] | dHeaderSumCAPA | 그리드 속성/값 설정 |  |  |  |
| AC-23e4617b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:966 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[2][idx] | dHearderSumBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-34d39639 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:967 | for (i < listWeek.Count) | GRID_SET | dsBinding.Tables[0].Rows[3][idx] | dHearderSumMcQty | 그리드 속성/값 설정 |  |  |  |
| AC-b027a450 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:970 | for (i < listWeek.Count) ▸ if (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-477977dc | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0072_CAPA_Balance.cs:972 | for (i < listWeek.Count) ▸ else of (dHeaderSumCAPA == 0) | GRID_SET | dsBinding.Tables[0].Rows[4][idx] | dHeaderSumPROD_PLAN / dHeaderSumCAPA * 100 | 그리드 속성/값 설정 |  |  |  |

## SCP0072_CAPA_Balance.SetAmountCalculating

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4fb93478 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:353 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-522328a7 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:357 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b52d73e9 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:363 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-24802a38 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:364 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bd0cdff | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:367 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ac4a5ae1 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:369 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4ffcc84a | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:408 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-80a34077 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:412 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-15a1a5f5 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:417 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-a9bd2315 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:421 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-30d1044f | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:425 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-549b8b42 | cboQTY.SelectedIndexChanged | SCP0072_CAPA_Balance.cs:428 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0072_CAPA_Balance.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a95f5be | this.Load 외 1 | SCP0072_CAPA_Balance.cs:514 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-02a7d6ea | this.Load 외 1 | SCP0072_CAPA_Balance.cs:514 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-197c7395 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:515 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2bad8d57 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:518 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-6c111e62 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:518 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cf5f2999 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:519 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9b2859e1 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:522 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-c10711d0 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:525 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-803c9266 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:525 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7c698325 | this.Load 외 1 | SCP0072_CAPA_Balance.cs:526 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0072_CAPA_Balance.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / cboPlanDate.SelectedIndexChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc0faa91 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:443 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-af5c87a1 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:448 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("W_")… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f45f7df6 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:450 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Weekly) | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cb54deb2 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:458 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6df721db | this.Load 외 4 | SCP0072_CAPA_Balance.cs:463 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-5f366c0b | this.Load 외 4 | SCP0072_CAPA_Balance.cs:465 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ if (cboBucketType.ControlValues == Bu… | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0c77d403 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:474 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-773c68bc | this.Load 외 4 | SCP0072_CAPA_Balance.cs:479 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a47b2575 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:481 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-55eb481d | this.Load 외 4 | SCP0072_CAPA_Balance.cs:490 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ace17e0a | this.Load 외 4 | SCP0072_CAPA_Balance.cs:495 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e27b2393 | this.Load 외 4 | SCP0072_CAPA_Balance.cs:497 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Weekly) ▸ else of (cboBucketType.ControlValues … | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0072_CAPA_Balance.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef852bb7 | this.spdMain.CellDoubleClick | SCP0072_CAPA_Balance.cs:1029 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0072_CAPA_Balance.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-154258b1 | this.spdMain.TopChange | SCP0072_CAPA_Balance.cs:1113 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

