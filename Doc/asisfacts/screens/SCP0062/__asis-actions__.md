# AS-IS 액션 대조표 — SCP0062

> 원천: `Doc/asisfacts/screens/SCP0062/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 271행 · 메서드 30 · 종류 DATA_OP 89 · GRID_INIT 58 · GRID_SET 19 · ENDPOINT 17 · RETURN 15 · MESSAGE 10 · FLAG 9 · UI_MISC 9 · VALUE_SET 8 · POPUP 6 · COMBO_DATA 6 · UI_PROP 5 · LIST_REBIND 5 · STATE 4 · VALIDATE 3 · CALL_EXT 3 · VALUE_CLEAR 2 · STATE_RESET 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 3


## SCP0062_ShipmentPlanFix_JV.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb603274 | this.btnItem_Id.Click | SCP0062_ShipmentPlanFix_JV.cs:1260 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2abbe267 | this.btnItem_Id.Click | SCP0062_ShipmentPlanFix_JV.cs:1262 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-4145df89 | this.btnItem_Id.Click | SCP0062_ShipmentPlanFix_JV.cs:1263 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-3c03c82b | this.btnItem_Id.Click | SCP0062_ShipmentPlanFix_JV.cs:1264 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1deabc59 | this.btnItem_Id.Click | SCP0062_ShipmentPlanFix_JV.cs:1270 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.BtnUnfix_Click

진입점: btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08ee04dd | btnUnfix.Click | SCP0062_ShipmentPlanFix_JV.cs:746 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-77d4fb80 | btnUnfix.Click | SCP0062_ShipmentPlanFix_JV.cs:747 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4ebd2279 | btnUnfix.Click | SCP0062_ShipmentPlanFix_JV.cs:751 |  | FLAG | dtPlanExecYn | Data_SCP.Common(Data_SCP.Type.PlanExecYn, false, CString.GetCheckedListValue(dtDivision, c… | 화면 필드/플래그 변경 |  |  |  |
| AC-913ed8dd | btnUnfix.Click | SCP0062_ShipmentPlanFix_JV.cs:751 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanExecYn, false, CString.GetCheckedListValue(dtDivision, cboDivision.Cont… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45670a67 | btnUnfix.Click | SCP0062_ShipmentPlanFix_JV.cs:755 | if (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00304") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-39bd925b | btnUnfix.Click | SCP0062_ShipmentPlanFix_JV.cs:756 | if (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce296128 | this.btnW26.Click | SCP0062_ShipmentPlanFix_JV.cs:767 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79e138c0 | this.btnW52.Click | SCP0062_ShipmentPlanFix_JV.cs:772 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c8623c67 | this.btnWLast.Click | SCP0062_ShipmentPlanFix_JV.cs:782 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(sPeriod) | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.CboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-afcec3c4 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:462 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c2eb63c7 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:239 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-bf935c64 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:240 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-c456b684 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:241 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ffaa1891 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:245 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f2476094 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:178 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-2bdb92c3 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:179 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2d6e8b88 | Dispose | SCP0062_ShipmentPlanFix_JV.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb2c14aa | EditButton | SCP0062_ShipmentPlanFix_JV.cs:487 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-24038971 | EditButton | SCP0062_ShipmentPlanFix_JV.cs:488 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.FindData_Division

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88714d52 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1280 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SystemMgmt.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e193b6a6 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1284 | lambda | ENDPOINT | new FoxDataRequest | ("SystemManager.UP_FX_GetUserGroupAuthExtentionList") ⇒ SystemManager.UP_FX_GetUserGroupAuthExtentionList | 엔드포인트 요청 생성 |  |  |  |
| AC-81fe458f | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1286 | lambda | DATA_OP | request.Parameters["GroupID"] | "JV Planner" | 행/컬럼 값 대입 |  |  |  |
| AC-9701ccc1 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1287 | lambda | DATA_OP | request.Parameters["UserID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f5ad74b9 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1288 | lambda | DATA_OP | request.Parameters["AuthType"] | "J" | 행/컬럼 값 대입 |  |  |  |
| AC-4049cf78 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1289 | lambda | DATA_OP | request.Parameters["DivisionID"] | string.Empty | 행/컬럼 값 대입 |  |  |  |
| AC-21ea96c8 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1290 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bfd9d8c1 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1292 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-2f1b8266 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:1301 | for (i < ds.Tables[0].Rows.Count) | DATA_OP | dic_JV_Plant.Add | (Code, JV_PLANT_ID) | 데이터 객체 조작/조회 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.FindData_Main

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c50ef277 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:501 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-cc3effd0 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:501 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-98601c36 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:503 |  | VALIDATE | DateUtil.Check_PeriodDate_New | (drpPeriod, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-0e3c505b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:503 | if (!DateUtil.Check_PeriodDate_New(drpPeriod, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2fccfa3 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:522 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a87740af | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:525 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-42eddf29 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:529 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-a7d409eb | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:531 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34a52bdc | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:534 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0025_GET_SHIPMENT_PLAN_FIX") ⇒ SCP.SCP0025_GET_SHIPMENT_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-77a0c796 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:536 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-8ca9427d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:538 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-005a5141 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:539 | try ▸ lambda | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-09c572dd | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:540 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-318fe11b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:541 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3aa960c0 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:542 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-f6fe75b9 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:543 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-66487e3e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:545 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0025" | 행/컬럼 값 대입 |  |  |  |
| AC-d8d59c5c | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:546 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-fc3a168e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:547 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-08d23246 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:548 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-f34d7992 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:549 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2aabd2c7 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:550 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-433f4a05 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:559 | try | CALL_EXT | dic_JV_Plant.TryGetValue | (division.ToString(), out get_JV_Value) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e86c918e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:563 | try | DATA_OP | tran.Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-dfffb07f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:567 | try ▸ for (i < tran_tmp.Tables.Count) | STATE_RESET | tran.Tables[i].Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-ec2dfaad | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:568 | try ▸ for (i < tran_tmp.Tables.Count) | DATA_OP | tran.Tables[i].Clone | () | 데이터 객체 조작/조회 |  |  |  |
| AC-48da8209 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:572 | try ▸ for (i < tran_tmp.Tables.Count) ▸ for (j < splt_get_JV_Value.Count()) | DATA_OP | tran_tmp.Tables[i].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-f76cc24f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:572 | try ▸ for (i < tran_tmp.Tables.Count) ▸ for (j < splt_get_JV_Value.Count()) ▸ lambda | DATA_OP | c[DefMain.FROM_SITE].ToString().Contains | (splt_get_JV_Value[j]) | 데이터 객체 조작/조회 |  |  |  |
| AC-2a95ea0c | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:576 | try ▸ for (i < tran_tmp.Tables.Count) ▸ for (j < splt_get_JV_Value.Count()) ▸ if (result) | DATA_OP | tran_tmp.Tables[i].Select().Where(c => c[DefMain.FROM_SITE].ToString().Contains(splt_get_J… | () | 데이터 객체 조작/조회 |  |  |  |
| AC-57fbbf60 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:576 | try ▸ for (i < tran_tmp.Tables.Count) ▸ for (j < splt_get_JV_Value.Count()) ▸ if (result) | DATA_OP | tran_tmp.Tables[i].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-111eaafb | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:576 | try ▸ for (i < tran_tmp.Tables.Count) ▸ for (j < splt_get_JV_Value.Count()) ▸ if (result) ▸ lambda | DATA_OP | c[DefMain.FROM_SITE].ToString().Contains | (splt_get_JV_Value[j]) | 데이터 객체 조작/조회 |  |  |  |
| AC-13657c7b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:577 | try ▸ for (i < tran_tmp.Tables.Count) ▸ for (j < splt_get_JV_Value.Count()) ▸ if (result) | DATA_OP | tran.Tables[i].Merge | (dtFromSite_Tmp) | 데이터 객체 조작/조회 |  |  |  |
| AC-b44ca390 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:584 | try | GRID_BIND | siMain.Query | (tran) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d72a1b01 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:593 | try ▸ if (tran.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a0f2153 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:594 | try ▸ if (tran.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1266ce3b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:597 | try | UI_MISC | SetSearchCount | (tran) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-ea09a8ec | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:601 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-5c214853 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:604 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a6c0ca3e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:608 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-49ff04a4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:609 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9a21e99 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:165 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-de0d6387 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:231 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-874b357a | this.Load | SCP0062_ShipmentPlanFix_JV.cs:232 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9988bd09 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:234 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.GetDayRange

진입점: this.Load / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41207592 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:729 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-9d804ab8 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:730 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d7d64ce2 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:731 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-4accf7ea | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:732 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-49422daa | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:733 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45f9c6bb | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:735 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.GetLastRange

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9e1f9bf1 | this.Load 외 1 | SCP0062_ShipmentPlanFix_JV.cs:715 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-63287de5 | this.Load 외 1 | SCP0062_ShipmentPlanFix_JV.cs:716 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-c6518232 | this.Load 외 1 | SCP0062_ShipmentPlanFix_JV.cs:717 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-326d2ce6 | this.Load 외 1 | SCP0062_ShipmentPlanFix_JV.cs:719 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.GetSpdTitle

진입점: this.Load / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-113e4fd2 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:288 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SCM0014", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c73b3e4 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:290 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-cbaa9f34 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:1169 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-280d1e9f | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:1170 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-cbd89ac0 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:1171 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-df593d7e | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:1173 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2b4a1c19 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:1173 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0062_ShipmentPlanFix_JV.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc888859 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:185 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-727b45ff | this.Load | SCP0062_ShipmentPlanFix_JV.cs:188 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-5941ea66 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:190 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-b6d5bb85 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:192 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c4117dcb | this.Load | SCP0062_ShipmentPlanFix_JV.cs:194 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-815bf7a8 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:194 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-904918fd | this.Load | SCP0062_ShipmentPlanFix_JV.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7feb9fbd | this.Load | SCP0062_ShipmentPlanFix_JV.cs:197 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-089e5a42 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:197 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-4c812ca2 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:198 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-df63eeeb | this.Load | SCP0062_ShipmentPlanFix_JV.cs:200 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-427bbf44 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c0580fe6 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:206 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-b85ba0bc | this.Load | SCP0062_ShipmentPlanFix_JV.cs:207 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-46cebf40 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:211 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-0bb441d4 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:220 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-df87deb6 | this.Load | SCP0062_ShipmentPlanFix_JV.cs:223 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-038007f2 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:299 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-7c3f866b | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:301 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9fc3b290 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:302 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-07cd73f8 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:303 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.BIZ_TYPE_NAME, DefMain.BIZ_TYPE_NAME, FPMerge.Restricted, 80, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10d00054 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:304 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 95, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9ff2f3f | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:305 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 65, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c89604a | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:306 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_SITE_DESCRIPTION, DefMain.TO_SITE_DESCRIPTION, FPMerge.Restricted, 65, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4506f904 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:308 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE_DESCRIPTION, DefMain.FROM_SITE_DESCRIPTION, FPMerge.Restricted, 70… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-780116f5 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:309 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.INCOTERMS, DefMain.INCOTERMS, FPMerge.Restricted, 45, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5fc2a2b3 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:310 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PROJECT_CODE, DefMain.PROJECT_CODE, FPMerge.Restricted, 85, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28a305c6 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:311 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TRANSPORT_MODE, DefMain.TRANSPORT_MODE, FPMerge.Restricted, 40, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e55641e6 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:312 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.LT_DAY, DefMain.LT_DAY, FPMerge.Restricted, 45, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f946ecd0 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:314 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE, DefMain.MEASURE, FPMerge.Restricted, 80, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd5e07e3 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:315 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 80, false, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cbccbd09 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:316 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.BIZ_TYPE, DefMain.BIZ_TYPE, FPMerge.Restricted, 110, false, FPHAlign.Right, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32d967dc | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:317 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_SITE, DefMain.TO_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a94ede37 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:318 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-10b791b3 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:320 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_YYYYMMDD, DefMain.TO_YYYYMMDD, FPMerge.Restricted, 140, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59baaace | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:323 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, DefMainLabel.DIVISION_ID, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-50006294 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:324 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.BIZ_TYPE_NAME), 3, 1, 20, DefMainLabel.BIZ_TYPE_NAME, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a755149 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:325 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, DefMainLabel.ITEM_ID, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5bd13e2c | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:326 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, DefMainLabel.NICK_NAME, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ebebc1b | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:327 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.TO_SITE_DES… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-da36e977 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:329 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.FROM_SITE… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c447054b | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:330 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.INCOTERMS), 3, 1, 20, DefMainLabel.INCOTERMS, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-abcf796b | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:331 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.PROJECT_CODE), 3, 1, 20, DefMainLabel.PROJECT_CODE, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-08131d7a | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:332 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE), 3, 1, 20, DefMainLabel.TRANSPORT_MODE, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-18349e62 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:333 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.LT_DAY), 3, 1, 20, DefMainLabel.LT_DAY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f7c6ace5 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:335 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE), 3, 1, 20, DefMainLabel.MEASURE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8209ca65 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:336 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, DefMainLabel.DIVISION_NAME, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf1693e7 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:337 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.BIZ_TYPE), 3, 1, 20, DefMainLabel.BIZ_TYPE, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ed1b9f9 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:338 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE), 3, 1, 20, DefMainLabel.TO_SITE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a29e1020 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:339 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, DefMainLabel.FROM_SITE, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5a0675c | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:341 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_YYYYMMDD), 3, 1, 20, DefMainLabel.TO_YYYYMMDD, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a3fa4d6 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:349 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfc45f3e | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:350 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.InitSpread_2

진입점: this.Load / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ebc9d13f | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:252 |  | GRID_INIT | spdInfo.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-a0130f0e | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:258 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-4f704276 | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:264 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-af6db384 | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:270 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-57ed9170 | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:271 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-61802aa7 | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:272 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-31c5e3cc | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:276 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b1404af4 | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:277 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-e550ffd8 | this.Load 외 2 | SCP0062_ShipmentPlanFix_JV.cs:278 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.InitSpreadDateColumn

진입점: this.Load / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6f06879 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:387 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d8f2589d | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:388 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7fd3e654 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:392 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f73a5ac0 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:393 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-89a60220 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:397 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-20e3e5a8 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:404 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d9f5e6c | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:405 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e861043c | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:410 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76abb728 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:411 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4331378f | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:419 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc11c156 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:420 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1542350c | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:430 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a3ac77b6 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:431 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d19f1310 | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:432 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-096e87df | this.Load 외 3 | SCP0062_ShipmentPlanFix_JV.cs:433 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-79c3b2c6 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:1250 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.SaveData_FixInfo_U

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-32b2fda1 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:901 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-5a63e967 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:907 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eefcf65f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:911 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-40f9f020 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:912 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-4b7206c0 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:913 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-a98c9b58 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:914 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-424eb003 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:915 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf9042c6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:916 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-3122b7a6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:917 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f082d4d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:918 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-e196ca36 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:919 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-d9791919 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:920 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-b718eec6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:921 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-5ade6d18 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:922 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d29e422e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:923 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-afc1deaa | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:924 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-f529992e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:925 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-71e176cb | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:926 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-1db08890 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:934 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-185c3919 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:935 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-33247ce3 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:939 | if (fps.Name == "spdMain") ▸ if (siMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1f3bf0b1 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:939 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (MessageHelper.GMessageBox("MSG00016") != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc059304 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:994 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-7f187d8a | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:995 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-e7ad35cf | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:996 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-dfbec456 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:997 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-1fcdb987 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:998 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-03346a1d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:999 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | str_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-fd927281 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1000 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | str_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-cba86d16 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1001 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | str_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-51ad6154 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1002 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-d76c485b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1003 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | str_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-90cb5a1a | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1004 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | str_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-733d19a7 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1005 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-03962fef | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1006 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | str_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e551cf28 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1007 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | str_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a1b12743 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1008 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-c96fc553 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1009 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c82790f3 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1010 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-d6fb727d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1031 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ae9b5915 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1032 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-67217b1b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1033 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-6fb8f90b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1034 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-8fb04732 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1035 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-995478e2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1036 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | str_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-53f9ac36 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1037 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | str_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-53f0af9d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1038 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | str_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-0bcdf36d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1039 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-100441f0 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1040 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | str_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-8e4205d4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1041 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | str_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-861e586f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1042 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j + nDayCntOfWeek).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-81569480 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1043 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | str_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-1bcd6596 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1044 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | str_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-91f055c2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1045 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-ecae754b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1046 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-4e0966e5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1047 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-c97b2b81 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1067 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-2e214b8e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1081 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | (SqlDbType.Structured, "@SCP0025", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-303ed127 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1082 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("dbo.SCP0025_SAVE_SHIPMENT_PLAN_FIX_DATASET") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=dbo.SCP0025_SAVE_SHIPME… | 엔드포인트 호출 |  |  |  |
| AC-a0a405b9 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1085 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b822321d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1090 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8465a7ad | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1099 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-276cca91 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1108 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-89186fdd | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1109 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c62d985 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1115 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-01549da8 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1125 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0062_ShipmentPlanFix_JV.SCM_SYS_LOG_BATCH

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8198039d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1141 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-3ac9174e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1142 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-5bcf08a6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1143 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-4472db66 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1144 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-c040c467 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1145 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-091ecd97 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1146 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-e8b1d01b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1147 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-accd40b2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0062_ShipmentPlanFix_JV.cs:1149 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0062_ShipmentPlanFix_JV.Set_FixReason

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (tran.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (tran.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d176e0ab | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:656 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_INIT | siMain.SetCellTypeText | (iRow, iCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ccbc7d70 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:661 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | DATA_OP | dtFixReason.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-8761a5d2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:672 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | DATA_OP | dtFixReason.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-ece345c2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0062_ShipmentPlanFix_JV.cs:684 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_SET | siMain.SetValue | (iRow, iCol, dr["FIX_REASON"].ToString()) | 그리드 값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6e68d2c | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:814 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-172efcaa | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:823 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-0dda882b | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:841 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-980815f1 | (진입점 미연결) | SCP0062_ShipmentPlanFix_JV.cs:842 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.SetOperationGroupByDivision

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1cefe863 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:855 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-59756012 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:855 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1270a1e9 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:859 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-67e0f094 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:859 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-33b56071 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:862 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-750ed834 | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:866 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-59b9904c | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:867 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-0fd69efe | this.cboDivision.SelectedIndexChanged | SCP0062_ShipmentPlanFix_JV.cs:871 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0062_ShipmentPlanFix_JV.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count == 1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString() == "0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (tran.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (tran.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-931b4bd6 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1199 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-154b95bb | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1204 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e1988520 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1211 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f7899ef3 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1215 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-a85bd807 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1220 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-249bfe87 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1227 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-d23e3721 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0062_ShipmentPlanFix_JV.cs:1231 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34011c53 | this.spdMain.CellDoubleClick | SCP0062_ShipmentPlanFix_JV.cs:467 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0062_ShipmentPlanFix_JV.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-19d07dd7 | this.spdMain.TopChange | SCP0062_ShipmentPlanFix_JV.cs:473 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

