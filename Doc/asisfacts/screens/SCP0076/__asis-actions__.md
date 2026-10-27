# AS-IS 액션 대조표 — SCP0076

> 원천: `Doc/asisfacts/screens/SCP0076/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 246행 · 메서드 31 · 종류 GRID_INIT 94 · RETURN 24 · GRID_SET 24 · DATA_OP 22 · FLAG 19 · MESSAGE 12 · ENDPOINT 8 · CALL_EXT 7 · LIST_REBIND 7 · UI_MISC 6 · UI_PROP 5 · POPUP 4 · VALUE_SET 4 · GRID_LOCK 4 · GRID_CLEAR 2 · VALIDATE 2 · STATE_RESET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 7


## SCP0076_Production_Result_Check.BtnColumn_Click

진입점: this.btnColumn.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-768ddabd | this.btnColumn.Click | SCP0076_Production_Result_Check.cs:1200 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0076", sSheetName, true) | 팝업/폼 생성 |  |  |  |
| AC-243f712e | this.btnColumn.Click | SCP0076_Production_Result_Check.cs:1201 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-c976200b | this.btnColumn.Click | SCP0076_Production_Result_Check.cs:1202 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SCP0076_Production_Result_Check.CboPlanDateEnd_SelectedIndexChanged

진입점: cboPlanDateEnd.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2bf68cc8 | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:795 |  | FLAG | p_plan_date_start | cboPlanDateStart.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-a8009a46 | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:796 |  | FLAG | p_plan_date_end | cboPlanDateEnd.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-51b21cfe | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:798 |  | CALL_EXT | ScpUtils.CheckDateFast | (p_plan_date_end, p_plan_date_start) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d3cc9643 | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:800 | if (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dbeb79e4 | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:801 | if (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | VALUE_SET | cboPlanDateEnd.ControlValues | p_plan_date_start | 컨트롤 값 설정 |  |  |  |
| AC-399fb39a | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:802 | if (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1d65a7c6 | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:804 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | CALL_EXT | ScpUtils.CheckDiffDay | (p_plan_date_end, p_plan_date_start, 365) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b33540b | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:806 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) ▸ if (ScpUtils.CheckDiffDay(p_plan_date_end, p_plan_date_start, 365)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00365") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-429c9d2b | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:807 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) ▸ if (ScpUtils.CheckDiffDay(p_plan_date_end, p_plan_date_start, 365)) | VALUE_SET | cboPlanDateEnd.ControlValues | p_plan_date_start | 컨트롤 값 설정 |  |  |  |
| AC-6d937369 | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:808 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) ▸ if (ScpUtils.CheckDiffDay(p_plan_date_end, p_plan_date_start, 365)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26bc679a | cboPlanDateEnd.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:811 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0076_Production_Result_Check.CboPlanDateStart_SelectedIndexChanged

진입점: cboPlanDateStart.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0fcbcfb3 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:817 |  | FLAG | p_plan_date_start | cboPlanDateStart.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-d343c0c9 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:818 |  | FLAG | p_plan_date_end | cboPlanDateEnd.ControlValues | 화면 필드/플래그 변경 |  |  |  |
| AC-2767fc10 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:820 |  | CALL_EXT | ScpUtils.CheckDateFast | (p_plan_date_end, p_plan_date_start) | ⚠ 의미 확인 필요 |  |  |  |
| AC-430a2a51 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:822 | if (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00108") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-19ca1ff3 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:823 | if (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | VALUE_SET | cboPlanDateStart.ControlValues | p_plan_date_end | 컨트롤 값 설정 |  |  |  |
| AC-e5087974 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:824 | if (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5ab080f | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:826 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) | CALL_EXT | ScpUtils.CheckDiffDay | (p_plan_date_end, p_plan_date_start, 365) | ⚠ 의미 확인 필요 |  |  |  |
| AC-55340694 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:828 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) ▸ if (ScpUtils.CheckDiffDay(p_plan_date_end, p_plan_date_start, 365)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00365") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-479a8f59 | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:829 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) ▸ if (ScpUtils.CheckDiffDay(p_plan_date_end, p_plan_date_start, 365)) | VALUE_SET | cboPlanDateStart.ControlValues | p_plan_date_end | 컨트롤 값 설정 |  |  |  |
| AC-7a12ca7f | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:830 | else of (ScpUtils.CheckDateFast(p_plan_date_end, p_plan_date_start)) ▸ if (ScpUtils.CheckDiffDay(p_plan_date_end, p_plan_date_start, 365)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2838b9bd | cboPlanDateStart.SelectedIndexChanged | SCP0076_Production_Result_Check.cs:833 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0076_Production_Result_Check.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a39317ef | (진입점 미연결) | SCP0076_Production_Result_Check.cs:266 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-35ae2d1d | (진입점 미연결) | SCP0076_Production_Result_Check.cs:267 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0076_Production_Result_Check.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-56283eb2 | this.Load | SCP0076_Production_Result_Check.cs:324 | try | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 50) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-df5e3e70 | this.Load | SCP0076_Production_Result_Check.cs:325 | try | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-2eb353f8 | this.Load | SCP0076_Production_Result_Check.cs:327 | try | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0076_Production_Result_Check.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ea14295 | DeleteButton | SCP0076_Production_Result_Check.cs:936 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0076_Production_Result_Check.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca67f6aa | Dispose | SCP0076_Production_Result_Check.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0076_Production_Result_Check.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37c5b328 | EditButton | SCP0076_Production_Result_Check.cs:870 | if (fps != null) ▸ if (iColIdx_temp < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00364") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-12ec6dd9 | EditButton | SCP0076_Production_Result_Check.cs:871 | if (fps != null) ▸ if (iColIdx_temp < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31c8eae9 | EditButton | SCP0076_Production_Result_Check.cs:876 | if (fps != null) ▸ if (iColIdx_temp < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00364") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e685d73a | EditButton | SCP0076_Production_Result_Check.cs:877 | if (fps != null) ▸ if (iColIdx_temp < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6174f69a | EditButton | SCP0076_Production_Result_Check.cs:882 | if (fps != null) ▸ if (iColIdx_temp < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00364") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9444a3a4 | EditButton | SCP0076_Production_Result_Check.cs:883 | if (fps != null) ▸ if (iColIdx_temp < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fcbc801 | EditButton | SCP0076_Production_Result_Check.cs:888 | if (fps != null) ▸ if (iColIdx_temp < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00364") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7473ab1f | EditButton | SCP0076_Production_Result_Check.cs:889 | if (fps != null) ▸ if (iColIdx_temp < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b515271 | EditButton | SCP0076_Production_Result_Check.cs:894 | if (fps != null) ▸ if (iColIdx_temp < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00364") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fcced204 | EditButton | SCP0076_Production_Result_Check.cs:895 | if (fps != null) ▸ if (iColIdx_temp < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2d252280 | EditButton | SCP0076_Production_Result_Check.cs:919 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | UI_PROP | rtb.Multiline | true | 속성 Multiline 설정 |  |  |  |
| AC-73162e67 | EditButton | SCP0076_Production_Result_Check.cs:920 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | UI_PROP | rtb.WordWrap | true | 속성 WordWrap 설정 |  |  |  |
| AC-b4e8df6c | EditButton | SCP0076_Production_Result_Check.cs:922 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6fb376c | EditButton | SCP0076_Production_Result_Check.cs:923 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-4dcd7202 | EditButton | SCP0076_Production_Result_Check.cs:925 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (1, iColIdx_Reason - 1, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-335f56d5 | EditButton | SCP0076_Production_Result_Check.cs:926 | if (fps != null) ▸ if (fps.Name == "spdMain" && spdMain.ActiveSheetIndex == 0) | GRID_LOCK | siMain.LockColumn | (iColIdx_BEF4_Result, iColIdx_BEF1_Result_TOT, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0076_Production_Result_Check.FindData_Main

진입점: FindButton [if (siMain.ActiveSheet != null)] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c382d5c8 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:951 | try | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-d69c3876 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:976 | try | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f42116b8 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:980 | try ▸ try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2f7b1a03 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:982 | try ▸ try | CALL_EXT | FoxUserInfoContext.CreateScope | (new FoxUserInfoContext(p_user_id.ToString())) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e51a8cc9 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:985 | try ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0076_GET_PRODUCTION_RESULT_CHECK") ⇒ SCP.SCP0076_GET_PRODUCTION_RESULT_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-b7abdb7b | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:987 | try ▸ try | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0000fcce | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:989 | try ▸ try | DATA_OP | req.Parameters["p_from_yyyymmdd"] | pPlanDateFrom.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-3f4efa16 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:990 | try ▸ try | DATA_OP | req.Parameters["p_to_yyyymmdd"] | pPlanDateTo.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a41b9a47 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:991 | try ▸ try | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-8d7527fe | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:992 | try ▸ try | DATA_OP | req.Parameters["p_plant_id"] | p_Plant_Site | 행/컬럼 값 대입 |  |  |  |
| AC-a887b643 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:993 | try ▸ try | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0047024f | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:994 | try ▸ try | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-22b53c5b | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:995 | try ▸ try | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c1a2fd10 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1004 | try ▸ try | GRID_BIND | siMain.Query | (dsResult) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-21669eee | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1006 | try ▸ try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6d18458b | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1010 | try ▸ try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f10b34d7 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1011 | try ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9e0fc6a2 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1016 | try ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-c27ae3b1 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1018 | try ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77737084 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1022 | try ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ead58eb4 | FindButton [if (siMain.ActiveSheet != null)] 외 1 | SCP0076_Production_Result_Check.cs:1023 | try ▸ finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0076_Production_Result_Check.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9718a8d | this.Load | SCP0076_Production_Result_Check.cs:214 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0076_Production_Result_Check.GetColumnLastName

진입점: this.Load [try ▸ try ▸ try ▸ try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ if (colName.StartsWith("REASON"))] / this.rdUOM.CheckedChanged [try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ if (colName.StartsWith("REASON"))] / this.rdCell.CheckedChanged [try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ if (colName.StartsWith("REASON"))] / cboPlanDateStart.SelectedIndexChanged [try ▸ try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ if (colName.StartsWith("REASON"))] / cbo…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2ee50134 | this.Load [try ▸ try ▸ try ▸ try ▸ for (iCol < siMain.Active… 외 7 | SCP0076_Production_Result_Check.cs:749 | try ▸ if (ScpUtils.CheckDataEmpty(colName)) | RETURN | return colName; |  | 처리 중단/반환 |  |  |  |
| AC-28a10307 | this.Load [try ▸ try ▸ try ▸ try ▸ for (iCol < siMain.Active… 외 7 | SCP0076_Production_Result_Check.cs:756 | try ▸ if (arrColName.Length <= 2) | RETURN | return colName; |  | 처리 중단/반환 |  |  |  |
| AC-b7ef9871 | this.Load [try ▸ try ▸ try ▸ try ▸ for (iCol < siMain.Active… 외 7 | SCP0076_Production_Result_Check.cs:762 |  | RETURN | return colName; |  | 처리 중단/반환 |  |  |  |

## SCP0076_Production_Result_Check.GetSpdTitle

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / cboPlanDateStart.SelectedIndexChanged [try] / cboPlanDateEnd.SelectedIndexChanged [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)] / FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-540ad635 | this.Load 외 7 | SCP0076_Production_Result_Check.cs:358 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0076_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-ec9adcc7 | this.Load 외 7 | SCP0076_Production_Result_Check.cs:359 |  | DATA_OP | request.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e75517df | this.Load 외 7 | SCP0076_Production_Result_Check.cs:360 |  | DATA_OP | request.Parameters["p_plan_end_yyyymmdd"] | p_plan_end_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9d82dd8c | this.Load 외 7 | SCP0076_Production_Result_Check.cs:362 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d2760511 | this.Load 외 7 | SCP0076_Production_Result_Check.cs:362 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f0a580a | this.Load 외 7 | SCP0076_Production_Result_Check.cs:371 | try ▸ if (ScpUtils.CheckDataEmpty(dtPlanDate)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-623719ed | this.Load 외 7 | SCP0076_Production_Result_Check.cs:376 | try ▸ if (CommonUtils.CheckDataEmpty(p_plan_date_start)) | FLAG | p_plan_date_start | ScpUtils.GetValue(dtPlanDate.Rows[1][0]) | 화면 필드/플래그 변경 |  |  |  |
| AC-6bf1131e | this.Load 외 7 | SCP0076_Production_Result_Check.cs:381 | try ▸ if (CommonUtils.CheckDataEmpty(p_plan_date_end)) | FLAG | p_plan_date_end | ScpUtils.GetValue(dtPlanDate.Rows[0][0]) | 화면 필드/플래그 변경 |  |  |  |

## SCP0076_Production_Result_Check.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34ad50f7 | this.Load | SCP0076_Production_Result_Check.cs:233 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8084bdf3 | this.Load | SCP0076_Production_Result_Check.cs:236 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-064a2578 | this.Load | SCP0076_Production_Result_Check.cs:238 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0076_Production_Result_Check.InitSpread

진입점: this.Load [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [if (siMain.ActiveSheet != null) ▸ try] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3550acd | this.Load [try] 외 3 | SCP0076_Production_Result_Check.cs:340 | try | GRID_INIT | siMain.ChangeSheet | (0) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a784dab4 | this.Load [try] 외 3 | SCP0076_Production_Result_Check.cs:341 | try | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0076_Production_Result_Check.InitSpreadDateColumn

진입점: this.Load [try ▸ try ▸ try] / cboPlanDateStart.SelectedIndexChanged [try] / cboPlanDateEnd.SelectedIndexChanged [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5084f6f4 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:441 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_PLAN_SCP, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6362dace | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:442 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_PLAN_SCP), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bcb3a854 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:443 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-4f4c0ef0 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:444 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "PLAN") | 그리드 재구성/초기화 |  |  |  |
| AC-f6eb5168 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:445 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "SCP") | 그리드 재구성/초기화 |  |  |  |
| AC-065695f2 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:448 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_PLAN_FP, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93949aff | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:449 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_PLAN_FP), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9e2cd40c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:450 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-0a1b1e53 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:451 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "PLAN") | 그리드 재구성/초기화 |  |  |  |
| AC-0c12deae | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:452 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "FP") | 그리드 재구성/초기화 |  |  |  |
| AC-ddbb2a0f | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:458 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_RESULT, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92b44049 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:459 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_RESULT), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cf6c1c81 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:460 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-7666861f | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:461 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "RESULT") | 그리드 재구성/초기화 |  |  |  |
| AC-42aad32a | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:462 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Observance") | 그리드 재구성/초기화 |  |  |  |
| AC-84122fa6 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:465 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_RESULT_TOT, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ddc32d61 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:466 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_RESULT_TOT), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-553ca5e8 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:467 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-9ad59efd | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:468 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "RESULT") | 그리드 재구성/초기화 |  |  |  |
| AC-5233cc42 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:469 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "TOTAL") | 그리드 재구성/초기화 |  |  |  |
| AC-90bb04e2 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:474 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_CO_RATE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49f52b92 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:475 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_CO_RATE), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-6625ec81 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:476 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-ed477382 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:477 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "FP Rate") | 그리드 재구성/초기화 |  |  |  |
| AC-37403526 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:478 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Accuracy") | 그리드 재구성/초기화 |  |  |  |
| AC-b7741193 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:482 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_AC_RATE, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-667fe657 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:483 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_AC_RATE), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d524503b | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:484 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-81ad99f7 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:485 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "FP Rate") | 그리드 재구성/초기화 |  |  |  |
| AC-0b4a0b79 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:486 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Achievement") | 그리드 재구성/초기화 |  |  |  |
| AC-35a7132f | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:492 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_PLAN_SCP_CELL, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf0df62b | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:493 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_PLAN_SCP_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f7b13784 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:494 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-b610ded4 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:495 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "PLAN (C)") | 그리드 재구성/초기화 |  |  |  |
| AC-234b4fba | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:496 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "SCP") | 그리드 재구성/초기화 |  |  |  |
| AC-4cfd86e2 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:499 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_PLAN_FP_CELL, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ad73bbf | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:500 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_PLAN_FP_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-085c236c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:501 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-675a198f | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:502 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "PLAN (C)") | 그리드 재구성/초기화 |  |  |  |
| AC-7ef5c13c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:503 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "FP") | 그리드 재구성/초기화 |  |  |  |
| AC-b6330b3e | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:508 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_RESULT_CELL, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b7b9592c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:509 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_RESULT_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-dd527c8a | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:510 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-bdd28345 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:511 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "RESULT (C)") | 그리드 재구성/초기화 |  |  |  |
| AC-9f79a43e | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:512 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Observance") | 그리드 재구성/초기화 |  |  |  |
| AC-9590f6af | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:515 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_PROD_RESULT_TOT_CELL, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2991c213 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:516 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_PROD_RESULT_TOT_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-852eae41 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:517 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-2c9f3dea | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:518 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "RESULT (C)") | 그리드 재구성/초기화 |  |  |  |
| AC-88dbe459 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:519 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "TOTAL") | 그리드 재구성/초기화 |  |  |  |
| AC-efbd0c71 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:523 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_CO_RATE_CELL, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a53256f7 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:524 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_CO_RATE_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c84bb229 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:525 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-8cfdf354 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:526 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "FP Rate (C)") | 그리드 재구성/초기화 |  |  |  |
| AC-c61598be | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:527 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Accuracy") | 그리드 재구성/초기화 |  |  |  |
| AC-6e78b1e7 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:531 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.AddNumColumn | (sWeekName, sFieldName_AC_RATE_CELL, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-daf747ca | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:532 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sFieldName_AC_RATE_CELL), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3538119e | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:533 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-a409283c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:534 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "FP Rate (C)") | 그리드 재구성/초기화 |  |  |  |
| AC-e3f1a2b6 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:535 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Achievement") | 그리드 재구성/초기화 |  |  |  |
| AC-f75eb216 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:543 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurCol - 12, 1, 12, 30, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-05ddb0a6 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:544 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 12, 1, 2, 30, "PLAN", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0f1217a2 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:545 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 10, 1, 2, 30, "RESULT", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94e42824 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:546 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 8, 1, 2, 30, "Rate", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7be2b8c8 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:547 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 6, 1, 2, 30, "PLAN (C)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-83843955 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:548 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 4, 1, 2, 30, "RESULT (C)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72dffa43 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:549 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 2, 1, 2, 30, "Rate (C)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d591b558 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:556 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.AddComboColumn | (sWeekName, DefMain.REASON_CODE, FPMerge.Restricted, 80, true, dtReason, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-67092e9f | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:557 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-4e11b4c0 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:558 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "REASON") | 그리드 재구성/초기화 |  |  |  |
| AC-3416bf2c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:559 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Code") | 그리드 재구성/초기화 |  |  |  |
| AC-16698912 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:563 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.AddTextColumn | (sWeekName, DefMain.REASON_DESCRIPTION, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5e27933 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:564 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (0, iCurCol, sWeekName) | 그리드 재구성/초기화 |  |  |  |
| AC-d7ab0d82 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:565 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (1, iCurCol, "REASON") | 그리드 재구성/초기화 |  |  |  |
| AC-3711c376 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:566 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.SetColumnHeader | (2, iCurCol, "Description") | 그리드 재구성/초기화 |  |  |  |
| AC-85720629 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:571 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iCurCol - 14, 1, 14, 30, sWeekName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7a241164 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:572 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 14, 1, 2, 30, "PLAN", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a83c023c | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:573 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 12, 1, 2, 30, "RESULT", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-63ef432e | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:574 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 10, 1, 2, 30, "Rate", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c65a0995 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:575 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 8, 1, 2, 30, "PLAN (C)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-139c1d77 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:576 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 6, 1, 2, 30, "RESULT (C)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3597f08 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:577 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 4, 1, 2, 30, "Rate (C)", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c86273e8 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:578 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iCurCol - 2, 1, 2, 30, "REASON", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ec1a4333 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:581 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, iCurCol - 14].ForeColor | Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-518f7d97 | this.Load [try ▸ try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:582 | try ▸ foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sPlanDate != sBasisYyyymmdd) | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[0, iCurCol - 14].Font | fontCellBold | 그리드 속성/값 설정 |  |  |  |

## SCP0076_Production_Result_Check.InsertButton

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc27a6df | InsertButton | SCP0076_Production_Result_Check.cs:941 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0076_Production_Result_Check.Re_Design

진입점: FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1386d80e | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] 외 1 | SCP0076_Production_Result_Check.cs:1149 | try | ENDPOINT | ScpUtils.FindDataValue | (dsSpdTitle.Tables[0], "BASIS_YYYYMMDD", p_plan_date_start, "ISO_YYYYWW") | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c5f34b34 | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] 외 1 | SCP0076_Production_Result_Check.cs:1158 | try ▸ if (iStartCol < 0 \|\| iRowcnt < 0 \|\| iRowcnt < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5115a354 | FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] 외 1 | SCP0076_Production_Result_Check.cs:1166 | try ▸ for (i < iRowcnt) ▸ if (i % 2 == 1) | GRID_SET | spdMain.ActiveSheet.Cells[i, iStartCol, i, iEndCol].BackColor | ControlColor.AlternatingRow | 그리드 속성/값 설정 |  |  |  |

## SCP0076_Production_Result_Check.RefreshanDateFrom

진입점: this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_start))] / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (CommonUtils.CheckDataEmpty(p_plan_date_start))] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (CommonUtils.CheckDataEmpty(p_plan_date_start))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6fc6c9d | this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_start)… 외 2 | SCP0076_Production_Result_Check.cs:275 |  | FLAG | dtPlanDateFrom | DBUtils.Filter(dtPlanDateFromAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-9aaa46c8 | this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_start)… 외 2 | SCP0076_Production_Result_Check.cs:275 |  | DATA_OP | DBUtils.Filter | (dtPlanDateFromAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-7be1cfc7 | this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_start)… 외 2 | SCP0076_Production_Result_Check.cs:277 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDateFrom, cboPlanDateStart, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0076_Production_Result_Check.RefreshanDateTo

진입점: this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_end))] / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (CommonUtils.CheckDataEmpty(p_plan_date_end))] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (CommonUtils.CheckDataEmpty(p_plan_date_end))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70bede6c | this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_end))] 외 2 | SCP0076_Production_Result_Check.cs:284 |  | FLAG | dtPlanDateTo | DBUtils.Filter(dtPlanDateToAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-7ad58647 | this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_end))] 외 2 | SCP0076_Production_Result_Check.cs:284 |  | DATA_OP | DBUtils.Filter | (dtPlanDateToAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0283b74f | this.Load [if (CommonUtils.CheckDataEmpty(p_plan_date_end))] 외 2 | SCP0076_Production_Result_Check.cs:286 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDateTo, cboPlanDateEnd, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0076_Production_Result_Check.RefreshReport

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20d01003 | this.Load 외 2 | SCP0076_Production_Result_Check.cs:293 |  | FLAG | dtPlantReport | DBUtils.Filter(dtPlantReportAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-b8345e85 | this.Load 외 2 | SCP0076_Production_Result_Check.cs:293 |  | DATA_OP | DBUtils.Filter | (dtPlantReportAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-6bccb413 | this.Load 외 2 | SCP0076_Production_Result_Check.cs:295 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantReport, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0076_Production_Result_Check.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32cd1a2a | SaveButton | SCP0076_Production_Result_Check.cs:857 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0076_Production_Result_Check.SaveData_Main

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8fd3b26 | SaveButton | SCP0076_Production_Result_Check.cs:1040 | try ▸ if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b566e6e6 | SaveButton | SCP0076_Production_Result_Check.cs:1042 | try ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed3c69bc | SaveButton | SCP0076_Production_Result_Check.cs:1044 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-a855f084 | SaveButton | SCP0076_Production_Result_Check.cs:1046 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2fefb3a3 | SaveButton | SCP0076_Production_Result_Check.cs:1092 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0076_SAVE_PROD_RESULT_CHECK") ⇒ SCP.SCP0076_SAVE_PROD_RESULT_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-4a0d0440 | SaveButton | SCP0076_Production_Result_Check.cs:1095 | try ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", GSCM_SCP_ANALYSIS_SVC)) { req.Comma… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-98611326 | SaveButton | SCP0076_Production_Result_Check.cs:1098 | try ▸ if (iCount > 0) ▸ lambda | UI_PROP | req.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-268cbb70 | SaveButton | SCP0076_Production_Result_Check.cs:1100 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6bcc915d | SaveButton | SCP0076_Production_Result_Check.cs:1101 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4d3b0608 | SaveButton | SCP0076_Production_Result_Check.cs:1102 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plan_week"] | p_plan_week | 행/컬럼 값 대입 |  |  |  |
| AC-869e9049 | SaveButton | SCP0076_Production_Result_Check.cs:1103 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-b4c9c99d | SaveButton | SCP0076_Production_Result_Check.cs:1104 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-39396baf | SaveButton | SCP0076_Production_Result_Check.cs:1105 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_cell_type_gr"] | p_cell_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-22580718 | SaveButton | SCP0076_Production_Result_Check.cs:1106 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_id"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-4e533138 | SaveButton | SCP0076_Production_Result_Check.cs:1107 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_model_type_gr"] | p_model_type_gr | 행/컬럼 값 대입 |  |  |  |
| AC-53d11569 | SaveButton | SCP0076_Production_Result_Check.cs:1108 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_reason_code"] | p_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-792c0209 | SaveButton | SCP0076_Production_Result_Check.cs:1109 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_reason_description"] | p_reason_description | 행/컬럼 값 대입 |  |  |  |
| AC-cb5de89c | SaveButton | SCP0076_Production_Result_Check.cs:1110 | try ▸ if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-e7e6fe6b | SaveButton | SCP0076_Production_Result_Check.cs:1112 | try ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ccd04f5 | SaveButton | SCP0076_Production_Result_Check.cs:1112 | try ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-64046741 | SaveButton | SCP0076_Production_Result_Check.cs:1121 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-431ce35c | SaveButton | SCP0076_Production_Result_Check.cs:1130 | try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00006") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0076_Production_Result_Check.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / this.spdMain.ActiveSheetChanged [if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-36c9cf67 | this.Load 외 2 | SCP0076_Production_Result_Check.cs:314 |  | LIST_REBIND | ScpUtils.SetComboSelect | (cboPlanDateStart, p_plan_date_start) | 목록 컨트롤 재구성 |  |  |  |
| AC-680cfe43 | this.Load 외 2 | SCP0076_Production_Result_Check.cs:315 |  | LIST_REBIND | ScpUtils.SetComboSelect | (cboPlanDateEnd, p_plan_date_end) | 목록 컨트롤 재구성 |  |  |  |

## SCP0076_Production_Result_Check.SetColumnVisible

진입점: this.Load [try ▸ try ▸ try] / this.rdUOM.CheckedChanged / this.rdCell.CheckedChanged / cboPlanDateStart.SelectedIndexChanged [try] / cboPlanDateEnd.SelectedIndexChanged [try] / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ try ▸ try] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ try ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-76664823 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:646 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) | CALL_EXT | ScpUtils.GetColumnName | (siMain, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-04caf727 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:658 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "": case "ACTION": case "PLAN_START_YYYYMMDD": case "PLAN_WEEK": c… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c73d7fca | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:666 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "DIVISION_NAME": case "CELL_TYPE_GR": case "OPERATION_GROUP_NAME":… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-76fe7a9d | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:671 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "REASON_CODE": case "REASON_DESCRIPTION": | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-173e6281 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:689 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_PLAN_SCP].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-35578455 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:690 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_PLAN_FP].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d418c09e | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:691 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_RESULT].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a369dc8c | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:692 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_RESULT_TOT].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-99be3a6b | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:693 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_CO_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-32de8027 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:694 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_AC_RATE].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f134addd | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:695 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_PLAN_SCP_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f65db14e | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:696 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_PLAN_FP_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-400b4b32 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:697 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_RESULT_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-0b2f87d6 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:698 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_RESULT_TOT_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-75de1e33 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:699 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_PROD_RESULT_TOT_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f11a463b | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:700 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_CO_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e2698dfd | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:701 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) case "PROD_PLAN_SCP": case "PROD_PLAN_FP": case "PROD_RESULT": case "PR… | GRID_SET | siMain.ActiveSheet.Columns[idxCol_AC_RATE_CELL].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c86bf5e6 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:709 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1f1fa553 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:716 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ if (colName.StartsWith("REASON")) ▸ if (p_plan_date_end == c… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6701bf2e | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:726 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ else of (colName.StartsWith("REASON")) ▸ switch (colNameLast… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-27f132af | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:729 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ else of (colName.StartsWith("REASON")) ▸ switch (colNameLast… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | rdCell.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-899044b4 | this.Load [try ▸ try ▸ try] 외 7 | SCP0076_Production_Result_Check.cs:732 | try ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ switch (colName) default: ▸ else of (colName.StartsWith("REASON")) ▸ switch (colNameLast… | GRID_SET | siMain.ActiveSheet.Columns[iCol].Visible | rdUOM.Checked | 그리드 속성/값 설정 |  |  |  |

## SCP0076_Production_Result_Check.SetSpreadInit

진입점: this.Load [try ▸ try] / cboPlanDateStart.SelectedIndexChanged / cboPlanDateEnd.SelectedIndexChanged / this.btnColumn.Click [if (frm.DialogResult == DialogResult.OK) ▸ try] / FindButton [if (siMain.ActiveSheet != null) ▸ try] / SaveButton [try ▸ if (iCount > 0) ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ if (siMain.ActiveSheet != null) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-389bbaf0 | this.Load [try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:600 | try | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-a73e142d | this.Load [try ▸ try] 외 5 | SCP0076_Production_Result_Check.cs:604 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0076_Production_Result_Check.SpdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-badf6ddf | this.spdMain.ActiveSheetChanged | SCP0076_Production_Result_Check.cs:1244 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81718450 | this.spdMain.ActiveSheetChanged | SCP0076_Production_Result_Check.cs:1245 | if (((FarPoint.Win.Spread.FpSpread)sender).ActiveSheet.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ChangeActiveSheet | (SpdSheet.shtMain) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0076_Production_Result_Check.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-582c1390 | spdMain.CellClick | SCP0076_Production_Result_Check.cs:1192 |  | CALL_EXT | siMain.IsLockCell | (e.Row, e.Column) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0076_Production_Result_Check.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-928be6ad | spdMain.CellDoubleClick | SCP0076_Production_Result_Check.cs:246 | if (siMain.Sheet().Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7836cb5a | spdMain.CellDoubleClick | SCP0076_Production_Result_Check.cs:250 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelRow | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-27628349 | spdMain.CellDoubleClick | SCP0076_Production_Result_Check.cs:251 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | this.nMainSelCol | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0076_Production_Result_Check.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d69a905 | dsdmMain.Changed | SCP0076_Production_Result_Check.cs:1213 | if (!this.CanModelChange \|\| e.Row == -1 \|\| e.Column == -1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebaaf2fc | dsdmMain.Changed | SCP0076_Production_Result_Check.cs:1214 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25020ff6 | dsdmMain.Changed | SCP0076_Production_Result_Check.cs:1223 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-60a5751f | dsdmMain.Changed | SCP0076_Production_Result_Check.cs:1224 | if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0076_Production_Result_Check.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ee2a600 | this.spdMain.EditChange | SCP0076_Production_Result_Check.cs:1253 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-7af62766 | this.spdMain.EditChange | SCP0076_Production_Result_Check.cs:1254 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

## SCP0076_Production_Result_Check.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d60015a | spdMain.TopChange | SCP0076_Production_Result_Check.cs:258 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

