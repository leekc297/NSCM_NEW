# AS-IS 액션 대조표 — SCP0064

> 원천: `Doc/asisfacts/screens/SCP0064/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 197행 · 메서드 27 · 종류 DATA_OP 61 · GRID_INIT 21 · FLAG 12 · UI_PROP 11 · RETURN 10 · ENDPOINT 10 · GRID_SET 10 · LIST_REBIND 9 · POPUP 7 · VALUE_SET 7 · COMBO_DATA 7 · UI_MISC 6 · GRID_CLEAR 5 · CALL_EXT 5 · STATE_RESET 5 · MESSAGE 3 · VALIDATE 3 · STATE 2 · CALL_BASE 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 6


## SCP0064_GlobalPSI_JV.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-381093af | this.btnItem_Id.Click | SCP0064_GlobalPSI_JV.cs:977 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2419ce91 | this.btnItem_Id.Click | SCP0064_GlobalPSI_JV.cs:979 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-d24616bb | this.btnItem_Id.Click | SCP0064_GlobalPSI_JV.cs:980 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1e924fc5 | this.btnItem_Id.Click | SCP0064_GlobalPSI_JV.cs:981 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-ffc72104 | this.btnItem_Id.Click | SCP0064_GlobalPSI_JV.cs:987 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0064_GlobalPSI_JV.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0d451ba | this.btnMeasure.Click | SCP0064_GlobalPSI_JV.cs:895 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0031", SpdSheet.shtMain, false) | 팝업/폼 생성 |  |  |  |
| AC-37578be9 | this.btnMeasure.Click | SCP0064_GlobalPSI_JV.cs:896 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e644df84 | this.btnMeasure.Click | SCP0064_GlobalPSI_JV.cs:897 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e7ddb664 | this.btnMeasure.Click | SCP0064_GlobalPSI_JV.cs:901 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-8cfe7164 | this.btnMeasure.Click | SCP0064_GlobalPSI_JV.cs:903 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0064_GlobalPSI_JV.CboBucketType_SelectedIndexChanged

진입점: this.cboBucketType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-28858205 | this.cboBucketType.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:919 | else of (chkAll.Checked) | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0064_GlobalPSI_JV.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f1be3438 | cboPlanDate.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:955 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-a73d9f60 | cboPlanDate.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:955 |  | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0f9af886 | cboPlanDate.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:956 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-51faf8da | cboPlanDate.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:958 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-0e19d697 | cboPlanDate.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:960 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-b6cb91e5 | cboPlanDate.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:961 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0064_GlobalPSI_JV.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-329c5e0e | cboPlanSeq.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:349 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0064_GlobalPSI_JV.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53b02139 | cboPlanType.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:941 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-4405fe0b | cboPlanType.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:941 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-619f2fb9 | cboPlanType.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:942 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-42046bce | cboPlanType.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:944 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-b386cef3 | cboPlanType.SelectedIndexChanged | SCP0064_GlobalPSI_JV.cs:947 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0064_GlobalPSI_JV.ChkAll_CheckedChanged

진입점: this.chkAll.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8b6aaf3a | this.chkAll.CheckedChanged | SCP0064_GlobalPSI_JV.cs:932 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0064_GlobalPSI_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b33bd76c | this.Load | SCP0064_GlobalPSI_JV.cs:227 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5319f79b | this.Load | SCP0064_GlobalPSI_JV.cs:228 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff824af4 | this.Load | SCP0064_GlobalPSI_JV.cs:229 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0064_GlobalPSI_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-860696bc | this.Load | SCP0064_GlobalPSI_JV.cs:162 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-b5a191fd | this.Load | SCP0064_GlobalPSI_JV.cs:163 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0064_GlobalPSI_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8e99073 | Dispose | SCP0064_GlobalPSI_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0064_GlobalPSI_JV.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b61401b8 | ExcelButton | SCP0064_GlobalPSI_JV.cs:555 |  | CALL_BASE | ExcelButtonWithoutCopy | () | ⚠ 의미 확인 필요 |  |  |  |

## SCP0064_GlobalPSI_JV.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2d9f4a2 | FindButton | SCP0064_GlobalPSI_JV.cs:519 | if (checkPlantSite == 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25e29a30 | FindButton | SCP0064_GlobalPSI_JV.cs:520 | if (checkPlantSite == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-851553c0 | FindButton | SCP0064_GlobalPSI_JV.cs:532 | if (strValue == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00352") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c2faa008 | FindButton | SCP0064_GlobalPSI_JV.cs:533 | if (strValue == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0064_GlobalPSI_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ba13659 | this.Load | SCP0064_GlobalPSI_JV.cs:993 |  | STATE | clbFromSite.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-b8a62df3 | this.Load | SCP0064_GlobalPSI_JV.cs:996 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c6a5249 | this.Load | SCP0064_GlobalPSI_JV.cs:1000 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-cb85c848 | this.Load | SCP0064_GlobalPSI_JV.cs:1002 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-06e854d5 | this.Load | SCP0064_GlobalPSI_JV.cs:1003 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-36ea301f | this.Load | SCP0064_GlobalPSI_JV.cs:1004 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-74932767 | this.Load | SCP0064_GlobalPSI_JV.cs:1005 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-845a4afb | this.Load | SCP0064_GlobalPSI_JV.cs:1006 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-dbd756dc | this.Load | SCP0064_GlobalPSI_JV.cs:1008 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7029d018 | this.Load | SCP0064_GlobalPSI_JV.cs:1017 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |
| AC-def68c42 | this.Load | SCP0064_GlobalPSI_JV.cs:1019 |  | STATE | clbFromSite.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0064_GlobalPSI_JV.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ec866ab | FindButton | SCP0064_GlobalPSI_JV.cs:565 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-baa71248 | FindButton | SCP0064_GlobalPSI_JV.cs:571 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-a4951ae0 | FindButton | SCP0064_GlobalPSI_JV.cs:571 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-15bc5e63 | FindButton | SCP0064_GlobalPSI_JV.cs:572 | try | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-1ea3654f | FindButton | SCP0064_GlobalPSI_JV.cs:572 | try ▸ if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8694613d | FindButton | SCP0064_GlobalPSI_JV.cs:575 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-58429aba | FindButton | SCP0064_GlobalPSI_JV.cs:601 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-bf858c3a | FindButton | SCP0064_GlobalPSI_JV.cs:603 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f61dae51 | FindButton | SCP0064_GlobalPSI_JV.cs:606 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0031_GET_GLOBAL_PSI") ⇒ SCP.SCP0031_GET_GLOBAL_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-f8659d96 | FindButton | SCP0064_GlobalPSI_JV.cs:607 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-6c1ea392 | FindButton | SCP0064_GlobalPSI_JV.cs:608 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-22b3373c | FindButton | SCP0064_GlobalPSI_JV.cs:609 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f95ee09c | FindButton | SCP0064_GlobalPSI_JV.cs:610 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-91db9280 | FindButton | SCP0064_GlobalPSI_JV.cs:611 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-31583197 | FindButton | SCP0064_GlobalPSI_JV.cs:612 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-c409d006 | FindButton | SCP0064_GlobalPSI_JV.cs:613 | try ▸ lambda | DATA_OP | req.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-d5e3b74d | FindButton | SCP0064_GlobalPSI_JV.cs:614 | try ▸ lambda | DATA_OP | req.Parameters["p_to_site"] | p_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-4f836804 | FindButton | SCP0064_GlobalPSI_JV.cs:615 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-8fea5722 | FindButton | SCP0064_GlobalPSI_JV.cs:616 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-5de77b87 | FindButton | SCP0064_GlobalPSI_JV.cs:617 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-059a5127 | FindButton | SCP0064_GlobalPSI_JV.cs:618 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0031" | 행/컬럼 값 대입 |  |  |  |
| AC-0dd61235 | FindButton | SCP0064_GlobalPSI_JV.cs:619 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | SpdSheet.shtMain | 행/컬럼 값 대입 |  |  |  |
| AC-aa6e1695 | FindButton | SCP0064_GlobalPSI_JV.cs:620 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-23deeaff | FindButton | SCP0064_GlobalPSI_JV.cs:622 | try ▸ lambda | DATA_OP | req.Parameters["p_bucket"] | p_bucket | 행/컬럼 값 대입 |  |  |  |
| AC-fb8f8090 | FindButton | SCP0064_GlobalPSI_JV.cs:623 | try ▸ lambda | DATA_OP | req.Parameters["p_chk_all"] | p_chk_all | 행/컬럼 값 대입 |  |  |  |
| AC-4b049670 | FindButton | SCP0064_GlobalPSI_JV.cs:625 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-34658b87 | FindButton | SCP0064_GlobalPSI_JV.cs:627 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a42ff2ed | FindButton | SCP0064_GlobalPSI_JV.cs:628 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-364857f9 | FindButton | SCP0064_GlobalPSI_JV.cs:638 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-261390f7 | FindButton | SCP0064_GlobalPSI_JV.cs:639 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-72fdff0a | FindButton | SCP0064_GlobalPSI_JV.cs:640 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a04c7dc0 | FindButton | SCP0064_GlobalPSI_JV.cs:645 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f8a72856 | FindButton | SCP0064_GlobalPSI_JV.cs:647 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-383326c6 | FindButton | SCP0064_GlobalPSI_JV.cs:657 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55541c95 | FindButton | SCP0064_GlobalPSI_JV.cs:661 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0064_GlobalPSI_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b3251465 | this.Load | SCP0064_GlobalPSI_JV.cs:150 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0064_GlobalPSI_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2e656d4c | this.Load | SCP0064_GlobalPSI_JV.cs:844 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-986645c0 | this.Load | SCP0064_GlobalPSI_JV.cs:845 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-75dc6e9d | this.Load | SCP0064_GlobalPSI_JV.cs:847 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0064_GlobalPSI_JV.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9cbce837 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:879 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5b9a3aa0 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:880 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0064_GlobalPSI_JV.GetSpdTitle

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbb25f14 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:868 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-2cc8fdd1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:869 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e036d9bb | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:870 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-d4681fb4 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:872 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-1665ccf5 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:872 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0064_GlobalPSI_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5620e0a3 | this.Load | SCP0064_GlobalPSI_JV.cs:171 | if (dtDivision.Rows.Count > 0) | DATA_OP | dtDivision.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1899f3b6 | this.Load | SCP0064_GlobalPSI_JV.cs:172 | if (dtDivision.Rows.Count > 0) | CALL_EXT | tmpDivision.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-edb5b57c | this.Load | SCP0064_GlobalPSI_JV.cs:182 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | tmpDivision.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9f831dea | this.Load | SCP0064_GlobalPSI_JV.cs:183 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["CODE"] | dr["CODE"] | 행/컬럼 값 대입 |  |  |  |
| AC-14e49a64 | this.Load | SCP0064_GlobalPSI_JV.cs:184 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | DATA_OP | dataRow["NAME"] | dr["NAME"] | 행/컬럼 값 대입 |  |  |  |
| AC-4371c91e | this.Load | SCP0064_GlobalPSI_JV.cs:186 | if (dtDivision.Rows.Count > 0) ▸ foreach (DataRow dr in dtDivision.Rows) ▸ else of (dr["CODE"].ToString() == "40") | CALL_EXT | tmpDivision.Rows.InsertAt | (dataRow, 0) | ⚠ 의미 확인 필요 |  |  |  |
| AC-8f17ee1b | this.Load | SCP0064_GlobalPSI_JV.cs:190 | if (dtDivision.Rows.Count > 0) | UI_PROP | tmpDivision.DefaultView.Sort | "CODE Asc" | 속성 Sort 설정 |  |  |  |
| AC-dff02d64 | this.Load | SCP0064_GlobalPSI_JV.cs:191 | if (dtDivision.Rows.Count > 0) | DATA_OP | tmpDivision.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-db758a01 | this.Load | SCP0064_GlobalPSI_JV.cs:193 | if (dtDivision.Rows.Count > 0) | DATA_OP | tmpDivision.DefaultView.ToTable | () | 데이터 객체 조작/조회 |  |  |  |
| AC-aec2d595 | this.Load | SCP0064_GlobalPSI_JV.cs:195 | if (dtDivision.Rows.Count > 0) | STATE_RESET | dtDivision.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-522e742f | this.Load | SCP0064_GlobalPSI_JV.cs:196 | if (dtDivision.Rows.Count > 0) | FLAG | dtDivision | dtDivisionOrder.Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-5207d1d4 | this.Load | SCP0064_GlobalPSI_JV.cs:196 | if (dtDivision.Rows.Count > 0) | DATA_OP | dtDivisionOrder.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e01d182f | this.Load | SCP0064_GlobalPSI_JV.cs:203 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-257a4a4d | this.Load | SCP0064_GlobalPSI_JV.cs:206 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-8673af60 | this.Load | SCP0064_GlobalPSI_JV.cs:207 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-f93f16b1 | this.Load | SCP0064_GlobalPSI_JV.cs:208 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-a72a0a68 | this.Load | SCP0064_GlobalPSI_JV.cs:210 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2bc4e773 | this.Load | SCP0064_GlobalPSI_JV.cs:212 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-68037fd8 | this.Load | SCP0064_GlobalPSI_JV.cs:219 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-0d8fdde8 | this.Load | SCP0064_GlobalPSI_JV.cs:221 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-05636510 | this.Load | SCP0064_GlobalPSI_JV.cs:222 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0064_GlobalPSI_JV.InitSpread

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa9caccd | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:237 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-c909294a | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:240 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-003434a8 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:244 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0064_GlobalPSI_JV.InitSpreadDateColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.cboBucketType.SelectedIndexChanged [else of (chkAll.Checked)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d5b1545 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:280 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b83c612 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:281 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-98623040 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:285 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d9f80ad | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:286 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-41b55f35 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:290 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-6cb9f5e2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:297 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-123595c6 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:298 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-079cd132 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:303 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd1eb9af | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:304 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38e14eb9 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:312 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-180c9c50 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:313 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3db7c72 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:323 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48130b4f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:324 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a26c8c1 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:325 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6c27c133 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 4 | SCP0064_GlobalPSI_JV.cs:326 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0064_GlobalPSI_JV.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ad99b3f | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0064_GlobalPSI_JV.cs:820 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aad1d0e3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0064_GlobalPSI_JV.cs:832 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-a4c4244e | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] | SCP0064_GlobalPSI_JV.cs:836 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0064_GlobalPSI_JV.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-289cf547 | (진입점 미연결) | SCP0064_GlobalPSI_JV.cs:682 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-1773b349 | (진입점 미연결) | SCP0064_GlobalPSI_JV.cs:686 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-e8686195 | (진입점 미연결) | SCP0064_GlobalPSI_JV.cs:761 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxWeek] | weekSum / nCntDayOfWeek | 그리드 속성/값 설정 |  |  |  |
| AC-23729e83 | (진입점 미연결) | SCP0064_GlobalPSI_JV.cs:773 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("MODEL_INVENTORY") \|\| measure.Equals("WH_IN_BALANCE") \|\| measure.Equals… | GRID_SET | dsBinding.Tables[0].Rows[iRow][nIdxMonth] | monthSum / nCntDayOfMonth | 그리드 속성/값 설정 |  |  |  |

## SCP0064_GlobalPSI_JV.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3883c5b8 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:404 | if (dic_JV_Plant.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9cf4d75 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:412 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtFromSite | Data.Common(Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContex… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee1c2341 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:412 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.FromSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["… ⇒ biz:CommonData.CommonDataList [code=FromSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e81ff1d0 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:415 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | CALL_EXT | dic_JV_Plant.TryGetValue | (division, out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a9ff850e | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:418 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | DATA_OP | dtFromSite.Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-0bd0f9f0 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:419 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | DATA_OP | dtFromSite.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f502538c | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:422 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | STATE_RESET | dtFromSite.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-4a8381b4 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:426 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | DATA_OP | dtFromSite_Tmp_data.Select().Where(c => c["CODE"].ToString().Contains(getValue_split[i])).… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6bfa2ddd | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:426 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | DATA_OP | dtFromSite_Tmp_data.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-448bc355 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:426 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | DATA_OP | c["CODE"].ToString().Contains | (getValue_split[i]) | 데이터 객체 조작/조회 |  |  |  |
| AC-194344f0 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:430 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | DATA_OP | dtFromSite.ImportRow | (dtFromSite_Tmp.Rows[j]) | 데이터 객체 조작/조회 |  |  |  |
| AC-c27a2c4d | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:434 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | STATE_RESET | dtFromSite_Tmp.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-e7570151 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:435 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if ((get_JV_Value != null && get_JV_Value != "") && (dt… | STATE_RESET | dtFromSite_Tmp_data.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-32ede9b3 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:440 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of ((get_JV_Value != null && get_JV_Value != "") &… | STATE_RESET | dtFromSite.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-40b163c5 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:445 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-d0b752d8 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:446 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-43281d4a | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:448 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8233269e | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:449 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0982ac68 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:450 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-1e9ed0f8 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:451 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4c5fc3c6 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:457 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtFromSite.Rows.Count) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f6d0a500 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:458 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtFromSite.Rows.Count) | DATA_OP | drRow["CODE"] | drtmp["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-8b89bf1f | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:459 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtFromSite.Rows.Count) | DATA_OP | drRow["NAME"] | drtmp["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-eb0c5dfe | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:460 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtFromSite.Rows.Count) | DATA_OP | table.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4380e57 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:463 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtFromSite.Rows.Count < 1) | UI_PROP | clbFromSite.ALL_VIEW | false | 속성 ALL_VIEW 설정 |  |  |  |
| AC-d92ad6ec | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:464 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (dtFromSite.Rows.Count < 1) | UI_PROP | clbFromSite.ALL_VIEW | true | 속성 ALL_VIEW 설정 |  |  |  |
| AC-7f353952 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:466 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (table, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b9021437 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:471 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtToSite | Data.Common(Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-5495f8bc | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:471 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.ToSiteByDivision, false, cboDivision.ControlValues, UserInfoContext.Current["No… ⇒ biz:CommonData.CommonDataList [code=ToSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-24d5d3da | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:474 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("CODE", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-19f3cd09 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:475 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Columns.Add | ("NAME", typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-9e6b6c8e | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:477 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-df0e2813 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:478 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-0c41f46c | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:479 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | dr1["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-a6f74ba5 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:480 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | DATA_OP | table.Rows.Add | (dr1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e2ad214d | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:486 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | table.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8dad4dca | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:487 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | drRow["CODE"] | drtmp["CODE"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1233c069 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:488 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | drRow["NAME"] | drtmp["NAME"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-05ecb1f5 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:489 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ for (idx < dtToSite.Rows.Count) | DATA_OP | table.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-a783526c | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:492 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (table, clbToSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9fcfd528 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:495 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 화면 필드/플래그 변경 |  |  |  |
| AC-c9dd30a8 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:495 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDate, false, division) ⇒ biz:CommonData.CommonDataList [code=PlanDate] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b593e7e | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:496 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-978ffa76 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:499 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 화면 필드/플래그 변경 |  |  |  |
| AC-59cfe133 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:499 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanType, false, division, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58fc3d71 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:500 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-10c268c1 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:503 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-321b49fc | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:506 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 화면 필드/플래그 변경 |  |  |  |
| AC-2c74d05e | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:506 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeq, false, division, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeq] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-42a1ac52 | this.Load 외 1 | SCP0064_GlobalPSI_JV.cs:507 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0064_GlobalPSI_JV.SetSpreadColumn

진입점: this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / this.Load / this.chkSum.CheckedChanged [if (siMain != null)] / this.cboBucketType.SelectedIndexChanged [if (chkAll.Checked) ▸ if (siMain != null)] / this.chkAll.CheckedChanged / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04ad056f | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:364 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a4994299 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:369 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f5640c56 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:376 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b44c1ad2 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:380 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-23844de7 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:385 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-18b518bf | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:392 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-db466364 | this.btnMeasure.Click [if (frm.DialogResult == DialogResult.… 외 5 | SCP0064_GlobalPSI_JV.cs:396 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0064_GlobalPSI_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d35f6e05 | this.spdMain.CellDoubleClick | SCP0064_GlobalPSI_JV.cs:857 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0064_GlobalPSI_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e887d8f9 | this.spdMain.TopChange | SCP0064_GlobalPSI_JV.cs:887 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

