# AS-IS 액션 대조표 — SCP0071

> 원천: `Doc/asisfacts/screens/SCP0071/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 163행 · 메서드 26 · 종류 DATA_OP 23 · GRID_INIT 20 · RETURN 16 · FLAG 15 · UI_MISC 12 · ENDPOINT 11 · VALUE_SET 9 · UI_PROP 8 · LIST_REBIND 8 · GRID_SET 8 · POPUP 7 · COMBO_DATA 5 · MESSAGE 5 · GRID_CLEAR 3 · CALL_EXT 3 · VALIDATE 2 · STATE 2 · STATE_RESET 2 · LIST_BIND 2 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 3


## SCP0071_CAPA_Balance_Small.BtnItem_Id_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8c3846c0 | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:994 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a40c0b8a | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:996 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4423b7ca | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:997 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2adacea6 | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:998 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0071_CAPA_Balance_Small.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05836828 | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:923 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0038", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-2047b99e | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:924 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b6bcb46b | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:925 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0be7b8e6 | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:928 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-1a427be3 | (진입점 미연결) | SCP0071_CAPA_Balance_Small.cs:930 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0071_CAPA_Balance_Small.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c32f9fff | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:968 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-185293d6 | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:968 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a04c1f6 | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:969 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e39e91c2 | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:971 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-aa20b343 | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:974 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-3973331c | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:975 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-82dc3899 | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:978 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-5c08f161 | cboPlanDate.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:979 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0071_CAPA_Balance_Small.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-584da87f | cboPlanSeq.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:314 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-2cfa8384 | cboPlanSeq.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:317 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-f79768f2 | cboPlanSeq.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:318 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0071_CAPA_Balance_Small.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58532854 | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:950 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-e881f5a2 | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:950 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cd4a4f7b | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:951 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e88878a1 | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:953 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-de1086b1 | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:956 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-2739ea30 | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:959 | if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-0a0b6305 | cboPlanType.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:960 | if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |

## SCP0071_CAPA_Balance_Small.cboQTY_SelectedIndexChanged

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13381ab6 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:325 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0071_CAPA_Balance_Small.Check_PeriodDate

진입점: FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07422076 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:882 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d85382c1 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:883 | try ▸ if (string.IsNullOrEmpty(date1) \|\| string.IsNullOrEmpty(date2)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-1e5bbc4b | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:892 | try ▸ if (nDate1 > nDate2) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00108", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0a0b5fd8 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:893 | try ▸ if (nDate1 > nDate2) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-7df09ba6 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:901 | try ▸ if (nDate2 >= nDate1After1Year) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00172", new object[] { ((82 * 7 - 1) + 7).ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37f96138 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:902 | try ▸ if (nDate2 >= nDate1After1Year) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-f9bed606 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:907 | catch ((Exception e)) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51784d03 | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:908 | catch ((Exception e)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-d2b8e62f | FindButton [try] | SCP0071_CAPA_Balance_Small.cs:911 |  | RETURN | return true; |  | 처리 중단/반환 |  |  |  |

## SCP0071_CAPA_Balance_Small.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-715cea43 | this.Load | SCP0071_CAPA_Balance_Small.cs:200 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f33c9cab | this.Load | SCP0071_CAPA_Balance_Small.cs:201 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-24cc9033 | this.Load | SCP0071_CAPA_Balance_Small.cs:202 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0071_CAPA_Balance_Small.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-811824f9 | this.Load | SCP0071_CAPA_Balance_Small.cs:161 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-629d060b | this.Load | SCP0071_CAPA_Balance_Small.cs:164 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |

## SCP0071_CAPA_Balance_Small.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-213b2226 | Dispose | SCP0071_CAPA_Balance_Small.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0071_CAPA_Balance_Small.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3e1c53e | FindButton | SCP0071_CAPA_Balance_Small.cs:497 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a72ecde6 | FindButton | SCP0071_CAPA_Balance_Small.cs:502 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-b743cfa4 | FindButton | SCP0071_CAPA_Balance_Small.cs:502 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ddf084a | FindButton | SCP0071_CAPA_Balance_Small.cs:503 | try ▸ if (!Check_PeriodDate(dCalendar, PeriodType.W82)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb5cefa1 | FindButton | SCP0071_CAPA_Balance_Small.cs:506 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-940f8fdf | FindButton | SCP0071_CAPA_Balance_Small.cs:529 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-1136e666 | FindButton | SCP0071_CAPA_Balance_Small.cs:531 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8cc753a6 | FindButton | SCP0071_CAPA_Balance_Small.cs:534 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0071_GET_CAPA_BALANCE_SMALL") ⇒ SCP.SCP0071_GET_CAPA_BALANCE_SMALL | 엔드포인트 요청 생성 |  |  |  |
| AC-1625d2f2 | FindButton | SCP0071_CAPA_Balance_Small.cs:535 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d3046d88 | FindButton | SCP0071_CAPA_Balance_Small.cs:536 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-326a9820 | FindButton | SCP0071_CAPA_Balance_Small.cs:537 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cea58001 | FindButton | SCP0071_CAPA_Balance_Small.cs:538 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-624d361a | FindButton | SCP0071_CAPA_Balance_Small.cs:543 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-24b34647 | FindButton | SCP0071_CAPA_Balance_Small.cs:544 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-56ac0533 | FindButton | SCP0071_CAPA_Balance_Small.cs:545 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-4d40e406 | FindButton | SCP0071_CAPA_Balance_Small.cs:546 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0071" | 행/컬럼 값 대입 |  |  |  |
| AC-0231421b | FindButton | SCP0071_CAPA_Balance_Small.cs:547 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-58bc84e8 | FindButton | SCP0071_CAPA_Balance_Small.cs:548 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-e1e671d7 | FindButton | SCP0071_CAPA_Balance_Small.cs:549 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-839f83f4 | FindButton | SCP0071_CAPA_Balance_Small.cs:550 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7d9240c8 | FindButton | SCP0071_CAPA_Balance_Small.cs:551 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-a279c4e9 | FindButton | SCP0071_CAPA_Balance_Small.cs:561 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-827d8400 | FindButton | SCP0071_CAPA_Balance_Small.cs:562 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fd5545b4 | FindButton | SCP0071_CAPA_Balance_Small.cs:566 | try ▸ if (dsOrigianlCopy != null) | UI_MISC | dsOrigianlCopy.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-48e332ac | FindButton | SCP0071_CAPA_Balance_Small.cs:567 | try ▸ if (dsOrigianlCopy != null) | FLAG | dsOrigianlCopy | null | 화면 필드/플래그 변경 |  |  |  |
| AC-cac7c5ea | FindButton | SCP0071_CAPA_Balance_Small.cs:569 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9be0facd | FindButton | SCP0071_CAPA_Balance_Small.cs:574 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c48656b5 | FindButton | SCP0071_CAPA_Balance_Small.cs:575 | try | VALUE_SET | cboQTY.SelectedIndex | 2 | 컨트롤 값 설정 |  |  |  |
| AC-8be0d791 | FindButton | SCP0071_CAPA_Balance_Small.cs:576 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d5a991f | FindButton | SCP0071_CAPA_Balance_Small.cs:585 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b7f5ac51 | FindButton | SCP0071_CAPA_Balance_Small.cs:587 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0071_CAPA_Balance_Small.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6ea78aa | this.Load | SCP0071_CAPA_Balance_Small.cs:151 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0071_CAPA_Balance_Small.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-156ab246 | this.Load | SCP0071_CAPA_Balance_Small.cs:807 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_BUCKET_TYPE_CODE") ⇒ SCP.SCP0070_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-e4dfcfe2 | this.Load | SCP0071_CAPA_Balance_Small.cs:808 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02acaa3e | this.Load | SCP0071_CAPA_Balance_Small.cs:810 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0071_CAPA_Balance_Small.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef4f8baa | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:849 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4f1cc4cf | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:850 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |
| AC-45fd876b | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:859 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6f227442 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:860 |  | DATA_OP | request.Parameters["p_from_date"] | p_plan_start_date == null ? "" : p_plan_start_date | 행/컬럼 값 대입 |  |  |  |
| AC-4740eced | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:861 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-079c7819 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:862 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-2984fbf9 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:863 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c30d91e0 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:865 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0071_CAPA_Balance_Small.GetQtyData

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fb6e6e7 | this.Load | SCP0071_CAPA_Balance_Small.cs:819 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_QTY_TYPE_CODE") ⇒ SCP.SCP0070_GET_QTY_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-87057778 | this.Load | SCP0071_CAPA_Balance_Small.cs:820 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d264a248 | this.Load | SCP0071_CAPA_Balance_Small.cs:823 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0071_CAPA_Balance_Small.GetSpdTitle

진입점: this.Load / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a488dd7e | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:839 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0070_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-26c412ca | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:840 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b789d562 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:841 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c52582d9 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:843 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-0cb76deb | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:843 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0071_CAPA_Balance_Small.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aea112cc | this.Load | SCP0071_CAPA_Balance_Small.cs:171 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-639e0d8b | this.Load | SCP0071_CAPA_Balance_Small.cs:174 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-5fb062d3 | this.Load | SCP0071_CAPA_Balance_Small.cs:175 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d8106f8 | this.Load | SCP0071_CAPA_Balance_Small.cs:176 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-c71556f8 | this.Load | SCP0071_CAPA_Balance_Small.cs:178 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-0ef9ab40 | this.Load | SCP0071_CAPA_Balance_Small.cs:180 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6ccb04aa | this.Load | SCP0071_CAPA_Balance_Small.cs:182 |  | VALUE_SET | cboDivision.ControlValues | "40" | 컨트롤 값 설정 |  |  |  |
| AC-8de21adf | this.Load | SCP0071_CAPA_Balance_Small.cs:183 |  | STATE | cboDivision.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d662d03f | this.Load | SCP0071_CAPA_Balance_Small.cs:188 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W82) | 컨트롤 값 설정 |  |  |  |
| AC-272dda8a | this.Load | SCP0071_CAPA_Balance_Small.cs:190 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8b19fe1c | this.Load | SCP0071_CAPA_Balance_Small.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eff9678b | this.Load | SCP0071_CAPA_Balance_Small.cs:194 |  | FLAG | dtQty | GetQtyData() | 화면 필드/플래그 변경 |  |  |  |
| AC-661e3785 | this.Load | SCP0071_CAPA_Balance_Small.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtQty, cboQTY, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0071_CAPA_Balance_Small.InitSpread

진입점: this.Load / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f59b133 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:209 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-03715ba2 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:212 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-d83a214d | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:215 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Monthly | 컨트롤 값 설정 |  |  |  |
| AC-e10e0e87 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:216 |  | STATE | cboBucketType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-9805d948 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:219 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0071_CAPA_Balance_Small.InitSpreadDateColumn

진입점: this.Load / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d662cf | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:256 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce7e8854 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:257 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5ff1d724 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:266 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22315a14 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:267 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f1755f9 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:272 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b97b9ec6 | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:273 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc941edf | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:280 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9b319ec | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:281 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12ca27ae | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:291 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91c2ab3c | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:292 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3f2daa9a | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:293 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cc7d6cec | this.Load 외 2 | SCP0071_CAPA_Balance_Small.cs:294 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0071_CAPA_Balance_Small.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-371584f5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:784 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8e4c7e68 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:796 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-b17d002c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:800 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0071_CAPA_Balance_Small.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ed7fba0b | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:606 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9adbf1d1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:644 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("BALANCE")) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][iCol] | dTempBALANCE | 그리드 속성/값 설정 |  |  |  |
| AC-ee6d0005 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:671 | for (i < listMonth.Count) | STATE_RESET | listHeaderItem.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-c3bbd746 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:705 | for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ if (TypeName.Equals("Total")) ▸ if (MeasureName.Equals("MKT_FCST")) ▸ for (xx<listHead… | GRID_SET | dsBinding.Tables[0].Rows[iMKT_FCST_Row + xx - del][idx] | AddValue + CurrentValue | 그리드 속성/값 설정 |  |  |  |
| AC-9fd76e68 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:720 | for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ if (TypeName.Equals("Total")) ▸ if (MeasureName.Equals("MKT_FCST")) ▸ for (yy<item_cou… | GRID_SET | dsBinding.Tables[0].Rows[iMKT_FCST_Row + yy][idx] | divide | 그리드 속성/값 설정 |  |  |  |
| AC-f66f4a85 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:728 | for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ if (TypeName.Equals("Total")) ▸ if (MeasureName.Equals("MKT_FCST")) | STATE_RESET | listHeaderItem.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-50eea791 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:740 | for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ else of (TypeName.Equals("Total")) ▸ if (temp.Length > 0) | DATA_OP | listHeaderItem.Add | (double.Parse(temp)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4638d65c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:756 | for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ if (iRow == iTotal_Row-1) ▸ for (xx < listHeaderItem.Count) | GRID_SET | dsBinding.Tables[0].Rows[iMKT_FCST_Row + xx - del][idx] | AddValue+ CurrentValue | 그리드 속성/값 설정 |  |  |  |
| AC-75c410ab | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0071_CAPA_Balance_Small.cs:771 | for (i < listMonth.Count) ▸ for (iRow < iTotal_Row) ▸ if (iRow == iTotal_Row-1) ▸ for (yy < item_count) ▸ if (ColName.Length >= 12) ▸ if (Co… | GRID_SET | dsBinding.Tables[0].Rows[iMKT_FCST_Row + yy][idx] | divide | 그리드 속성/값 설정 |  |  |  |

## SCP0071_CAPA_Balance_Small.SetAmountCalculating

진입점: cboQTY.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8559c2a4 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:335 | if (siMain.GetMaxRowIndex() < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5665cd3 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:339 | if (dsOrigianlCopy == null) | FLAG | dsOrigianlCopy | siMain.SpreadObject.DataSource as DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-9c439896 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:345 | if (cboQTY.SelectedIndex == 0) | LIST_BIND | siMain.SpreadObject.DataSource | dsOrigianlCopy | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-eebc19a7 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:346 | if (cboQTY.SelectedIndex == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-009ccf34 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:349 |  | DATA_OP | dsOrigianlCopy.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aeb58293 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:351 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9acb3f20 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:390 | for (i < dsOrigianlCopy.Tables[0].Rows.Count) ▸ for (j < dsKrw.Tables[0].Columns.Count) | GRID_SET | dsKrw.Tables[0].Rows[i][j] | Math.Round(Convert.ToDouble(slValue) / dbQtyDivideAmount, 2) | 그리드 속성/값 설정 |  |  |  |
| AC-51653942 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:395 |  | DATA_OP | dsKrw.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e861a60a | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:400 | if (ds != null) | UI_MISC | ds.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-c889f6e3 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:404 |  | LIST_BIND | siMain.SpreadObject.DataSource | dsKrw | 목록/그리드 데이터 원천 연결 |  |  |  |
| AC-756dd438 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:408 | if (dsKrw != null) | UI_MISC | dsKrw.Dispose | () | 창 닫기/해제 |  |  |  |
| AC-afb05330 | cboQTY.SelectedIndexChanged | SCP0071_CAPA_Balance_Small.cs:411 |  | CALL_EXT | GC.Collect | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0071_CAPA_Balance_Small.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98ea0062 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:449 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 화면 필드/플래그 변경 |  |  |  |
| AC-25b576d4 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:449 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.DATE_WEEKLY, false, division) ⇒ biz:CommonData.CommonDataList [code=DATE_WEEKLY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bc4c1dd7 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:450 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-62f4e149 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:453 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-51fe40d6 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:453 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-91b835d9 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:454 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9cedbbe4 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:457 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-b8409405 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:460 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-d31c0b77 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:460 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-43e122c5 | this.Load 외 1 | SCP0071_CAPA_Balance_Small.cs:461 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0071_CAPA_Balance_Small.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6cbc91c | this.Load 외 3 | SCP0071_CAPA_Balance_Small.cs:425 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("W_"… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-6fea6b83 | this.Load 외 3 | SCP0071_CAPA_Balance_Small.cs:430 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_"… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-631e9f66 | this.Load 외 3 | SCP0071_CAPA_Balance_Small.cs:431 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Monthly) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_"… | GRID_INIT | siObj.SetReNumerCellType | (siObj, iCol, 0, 2, 999999999) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0071_CAPA_Balance_Small.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-59c8e978 | this.spdMain.CellDoubleClick | SCP0071_CAPA_Balance_Small.cs:830 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0071_CAPA_Balance_Small.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8016dc75 | this.spdMain.TopChange | SCP0071_CAPA_Balance_Small.cs:916 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

