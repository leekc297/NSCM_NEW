# AS-IS 액션 대조표 — SCP0025

> 원천: `Doc/asisfacts/screens/SCP0025/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 263행 · 메서드 30 · 종류 DATA_OP 76 · GRID_INIT 58 · GRID_SET 19 · RETURN 14 · ENDPOINT 14 · UI_PROP 13 · MESSAGE 10 · UI_MISC 10 · FLAG 9 · VALUE_SET 8 · POPUP 6 · COMBO_DATA 6 · LIST_REBIND 5 · STATE 4 · CALL_EXT 3 · VALIDATE 3 · VALUE_CLEAR 2 · THROW 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 3


## SCP0025_ShipmentPlanFix.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdcec3ba | this.btnItem_Id.Click | SCP0025_ShipmentPlanFix.cs:1254 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-67584c8f | this.btnItem_Id.Click | SCP0025_ShipmentPlanFix.cs:1256 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-8c7a77ef | this.btnItem_Id.Click | SCP0025_ShipmentPlanFix.cs:1257 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1c2ec55d | this.btnItem_Id.Click | SCP0025_ShipmentPlanFix.cs:1258 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-a5b7f352 | this.btnItem_Id.Click | SCP0025_ShipmentPlanFix.cs:1263 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.BtnUnfix_Click

진입점: btnUnfix.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-78229cfb | btnUnfix.Click | SCP0025_ShipmentPlanFix.cs:760 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3c23b8b | btnUnfix.Click | SCP0025_ShipmentPlanFix.cs:761 | if (this.ViewModel != null) ▸ if (!ViewModel.SecurityContext.CanUpdate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4489d834 | btnUnfix.Click | SCP0025_ShipmentPlanFix.cs:765 |  | FLAG | dtPlanExecYn | Data_SCP.Common(Data_SCP.Type.PlanExecYn, false, CString.GetCheckedListValue(dtDivision, c… | 화면 필드/플래그 변경 |  |  |  |
| AC-bfda302d | btnUnfix.Click | SCP0025_ShipmentPlanFix.cs:765 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanExecYn, false, CString.GetCheckedListValue(dtDivision, cboDivision.Cont… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5d1ef4a7 | btnUnfix.Click | SCP0025_ShipmentPlanFix.cs:769 | if (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") | MESSAGE | MessageHelper.GMessageBox | ("MSG00304") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2eb9b6ce | btnUnfix.Click | SCP0025_ShipmentPlanFix.cs:770 | if (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0025_ShipmentPlanFix.BtnW26_Click

진입점: this.btnW26.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02ba8c56 | this.btnW26.Click | SCP0025_ShipmentPlanFix.cs:781 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W26) | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.BtnW52_Click

진입점: this.btnW52.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-886a9ba7 | this.btnW52.Click | SCP0025_ShipmentPlanFix.cs:786 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.BtnWLast_Click

진입점: this.btnWLast.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27484a61 | this.btnWLast.Click | SCP0025_ShipmentPlanFix.cs:798 | if (success) | VALUE_SET | dCalendar.InitValue | GetDayRange(WkNum.ToString()) | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.CboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006d6981 | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:443 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f294f8d | this.Load | SCP0025_ShipmentPlanFix.cs:234 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ac4a4f83 | this.Load | SCP0025_ShipmentPlanFix.cs:235 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-aad5f14b | this.Load | SCP0025_ShipmentPlanFix.cs:236 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b64131a | this.Load | SCP0025_ShipmentPlanFix.cs:240 |  | VALUE_SET | dCalendar.InitValue | GetDayRange(PeriodType.W52) | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-102d6f75 | this.Load | SCP0025_ShipmentPlanFix.cs:177 |  | UI_PROP | usrConditionPanel1.Height | 70 | 속성 Height 설정 |  |  |  |
| AC-b2971b63 | this.Load | SCP0025_ShipmentPlanFix.cs:178 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e08dcc7 | Dispose | SCP0025_ShipmentPlanFix.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0025_ShipmentPlanFix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6af23e5 | EditButton | SCP0025_ShipmentPlanFix.cs:464 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4e62279d | EditButton | SCP0025_ShipmentPlanFix.cs:465 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0025_ShipmentPlanFix.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-94a8c077 | ExcelButton | SCP0025_ShipmentPlanFix.cs:477 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-94fad1a8 | ExcelButton | SCP0025_ShipmentPlanFix.cs:478 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-532a28f4 | ExcelButton | SCP0025_ShipmentPlanFix.cs:479 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-5d25453f | ExcelButton | SCP0025_ShipmentPlanFix.cs:480 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-6fec4053 | ExcelButton | SCP0025_ShipmentPlanFix.cs:481 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-92082f77 | ExcelButton | SCP0025_ShipmentPlanFix.cs:483 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-9f8ff742 | ExcelButton | SCP0025_ShipmentPlanFix.cs:484 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-9d0dcd2b | ExcelButton | SCP0025_ShipmentPlanFix.cs:486 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-4efa3322 | ExcelButton | SCP0025_ShipmentPlanFix.cs:491 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-bbba7cf8 | ExcelButton | SCP0025_ShipmentPlanFix.cs:496 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-f7169017 | ExcelButton | SCP0025_ShipmentPlanFix.cs:500 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0025_ShipmentPlanFix.FindData_Main

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71262fbc | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:510 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-20999739 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:510 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-77215973 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:512 |  | VALIDATE | DateUtil.Check_PeriodDate_New | (dCalendar, "1", "7") | 프레임워크 검증 |  |  |  |
| AC-95c2895e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:512 | if (!DateUtil.Check_PeriodDate_New(dCalendar, "1", "7")) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-21475093 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:531 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-eb330524 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:533 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9e8b8b06 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:537 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7cc0cd94 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:539 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d5fea1d6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:541 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0025_GET_SHIPMENT_PLAN_FIX") ⇒ SCP.SCP0025_GET_SHIPMENT_PLAN_FIX | 엔드포인트 요청 생성 |  |  |  |
| AC-701ff04e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:543 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b5fdfcda | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:545 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-babb68d9 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:546 | try ▸ lambda | DATA_OP | req.Parameters["p_biz_type"] | p_biz_type | 행/컬럼 값 대입 |  |  |  |
| AC-013ab97e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:547 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-7935110d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:548 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2d056cfe | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:549 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-013ac527 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:550 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-81e4aeba | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:552 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0025" | 행/컬럼 값 대입 |  |  |  |
| AC-0cfe3822 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:553 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-debc8290 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:554 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-5495cb7b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:555 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "T" | 행/컬럼 값 대입 |  |  |  |
| AC-0969e99f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:556 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1fdafad8 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:557 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5d39aa1f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:563 | try | GRID_BIND | siMain.Query | (tran) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-29cede96 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:571 | try ▸ if (tran.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-44632304 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:572 | try ▸ if (tran.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf71aa0b | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:575 | try | UI_MISC | SetSearchCount | (tran) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-286c5ec0 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:578 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-21ebc4d7 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:581 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c0897aea | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:583 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b56ec15d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:584 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0025_ShipmentPlanFix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c63345c | this.Load | SCP0025_ShipmentPlanFix.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0025_ShipmentPlanFix.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1343ccdd | this.Load | SCP0025_ShipmentPlanFix.cs:227 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-b058e977 | this.Load | SCP0025_ShipmentPlanFix.cs:228 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e68af639 | this.Load | SCP0025_ShipmentPlanFix.cs:230 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0025_ShipmentPlanFix.GetDayRange

진입점: this.Load / this.btnW26.Click / this.btnW52.Click / this.btnWLast.Click [if (success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-905f3865 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:743 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-c3c22988 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:744 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-67cf86f3 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:745 |  | DATA_OP | request.Parameters["p_offset_day"] | Convert.ToInt32(periodType) * 7 - 1 | 행/컬럼 값 대입 |  |  |  |
| AC-aa7a118d | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:746 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-84975216 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:747 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-524c7203 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:749 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0025_ShipmentPlanFix.GetLastRange

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-403cc5d5 | this.Load 외 1 | SCP0025_ShipmentPlanFix.cs:729 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAILY_PLAN_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6d87cb9e | this.Load 외 1 | SCP0025_ShipmentPlanFix.cs:730 |  | DATA_OP | request.Parameters["p_division_id"] | divisionId | 행/컬럼 값 대입 |  |  |  |
| AC-5b2c4dbf | this.Load 외 1 | SCP0025_ShipmentPlanFix.cs:731 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a85452bd | this.Load 외 1 | SCP0025_ShipmentPlanFix.cs:733 |  | RETURN | return dailyPlanPeriod; |  | 처리 중단/반환 |  |  |  |

## SCP0025_ShipmentPlanFix.GetSpdTitle

진입점: this.Load / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2770c773 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:280 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SCM0014", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e3c91f9c | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:282 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-80d1fbd8 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:1182 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-00e83fd6 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:1183 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-46fd5777 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:1184 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-de06b03d | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:1186 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-693e231a | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:1186 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0025_ShipmentPlanFix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cdf61510 | this.Load | SCP0025_ShipmentPlanFix.cs:183 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-37d87da9 | this.Load | SCP0025_ShipmentPlanFix.cs:186 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-1f4f5e38 | this.Load | SCP0025_ShipmentPlanFix.cs:188 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f716ca87 | this.Load | SCP0025_ShipmentPlanFix.cs:190 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-82e79a55 | this.Load | SCP0025_ShipmentPlanFix.cs:192 |  | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3fa1604 | this.Load | SCP0025_ShipmentPlanFix.cs:192 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-64499fac | this.Load | SCP0025_ShipmentPlanFix.cs:193 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-240257da | this.Load | SCP0025_ShipmentPlanFix.cs:195 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-887c0df4 | this.Load | SCP0025_ShipmentPlanFix.cs:195 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b7d7d954 | this.Load | SCP0025_ShipmentPlanFix.cs:196 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-98d272fb | this.Load | SCP0025_ShipmentPlanFix.cs:198 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-fcd16b4a | this.Load | SCP0025_ShipmentPlanFix.cs:199 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-4bdaf57a | this.Load | SCP0025_ShipmentPlanFix.cs:204 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-1b3f97ab | this.Load | SCP0025_ShipmentPlanFix.cs:205 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-f3a66324 | this.Load | SCP0025_ShipmentPlanFix.cs:209 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-8d3cd241 | this.Load | SCP0025_ShipmentPlanFix.cs:218 | if (dailyPlanPeriod == PeriodType.W52) | UI_PROP | layoutControlItem7.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-7cdf3780 | this.Load | SCP0025_ShipmentPlanFix.cs:221 |  | VALUE_SET | btnWLast.Text | "W" + dailyPlanPeriod | 컨트롤 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77d27b0e | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:289 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-2a266002 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:291 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7b117782 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:292 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cf30a3f2 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:293 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.BIZ_TYPE_NAME, DefMain.BIZ_TYPE_NAME, FPMerge.Restricted, 80, true, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ecdb8187 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:294 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 95, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-106cfa7f | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:295 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 65, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0eef389 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:296 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_SITE_DESCRIPTION, DefMain.TO_SITE_DESCRIPTION, FPMerge.Restricted, 65, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91c07ca9 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:298 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE_DESCRIPTION, DefMain.FROM_SITE_DESCRIPTION, FPMerge.Restricted, 70… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a30ad97b | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:299 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.INCOTERMS, DefMain.INCOTERMS, FPMerge.Restricted, 45, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-713a539b | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:300 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PROJECT_CODE, DefMain.PROJECT_CODE, FPMerge.Restricted, 85, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-87f3dad5 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:301 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TRANSPORT_MODE, DefMain.TRANSPORT_MODE, FPMerge.Restricted, 40, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c45e202e | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:302 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.LT_DAY, DefMain.LT_DAY, FPMerge.Restricted, 45, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f7721b3 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:304 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.MEASURE, DefMain.MEASURE, FPMerge.Restricted, 80, true , FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d76436af | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:305 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 80, false, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ce638d9 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:306 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.BIZ_TYPE, DefMain.BIZ_TYPE, FPMerge.Restricted, 110, false, FPHAlign.Right, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-597127fb | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:307 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_SITE, DefMain.TO_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f802cec3 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:308 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 110, false, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4cb95d4 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:310 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.TO_YYYYMMDD, DefMain.TO_YYYYMMDD, FPMerge.Restricted, 140, false, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-81dab50b | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:313 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, DefMainLabel.DIVISION_ID, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-884f7d38 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:314 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.BIZ_TYPE_NAME), 3, 1, 20, DefMainLabel.BIZ_TYPE_NAME, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c86dbcb0 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:315 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, DefMainLabel.ITEM_ID, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f2c260b | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:316 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, DefMainLabel.NICK_NAME, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb990c0b | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:317 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.TO_SITE_DES… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46bd329b | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:319 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE_DESCRIPTION), 3, 1, 20, DefMainLabel.FROM_SITE… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bb0e31a8 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:320 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.INCOTERMS), 3, 1, 20, DefMainLabel.INCOTERMS, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a52462ab | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:321 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.PROJECT_CODE), 3, 1, 20, DefMainLabel.PROJECT_CODE, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d56c5a2 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:322 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TRANSPORT_MODE), 3, 1, 20, DefMainLabel.TRANSPORT_MODE, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9cd1a8f4 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:323 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.LT_DAY), 3, 1, 20, DefMainLabel.LT_DAY, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11f279f5 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:325 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.MEASURE), 3, 1, 20, DefMainLabel.MEASURE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-635ad61d | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:326 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, DefMainLabel.DIVISION_NAME, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e60af57a | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:327 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.BIZ_TYPE), 3, 1, 20, DefMainLabel.BIZ_TYPE, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-51e1f43a | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:328 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_SITE), 3, 1, 20, DefMainLabel.TO_SITE, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6051d78d | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:329 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, DefMainLabel.FROM_SITE , FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b4183398 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:331 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefMain.TO_YYYYMMDD), 3, 1, 20, DefMainLabel.TO_YYYYMMDD, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12aaf353 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:339 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a57cc91 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:340 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0025_ShipmentPlanFix.InitSpread_2

진입점: this.Load / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3284bf3 | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:246 |  | GRID_INIT | spdInfo.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-10650134 | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:252 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-366d62bf | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:258 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d298a24 | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:264 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5d585eed | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:265 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-c8b1c190 | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:266 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2cb3cbc3 | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:270 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-3a53c93d | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:271 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6665f648 | this.Load 외 2 | SCP0025_ShipmentPlanFix.cs:272 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.InitSpreadDateColumn

진입점: this.Load / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S"))] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d2c221f | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:374 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8bcda058 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:375 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b71fe3f4 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:378 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99e3e07a | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:379 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9dab6e25 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:382 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-75327573 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:388 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74b1a57e | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:389 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-526af5cb | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:394 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7d64209f | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:395 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dd2fcc31 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:402 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-46a6c5e0 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:403 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49c441a6 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:413 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-64bc9783 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:414 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ed940257 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:415 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-36ff20a6 | this.Load 외 3 | SCP0025_ShipmentPlanFix.cs:416 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0025_ShipmentPlanFix.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-422667a7 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:1245 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0025_ShipmentPlanFix.SaveData_FixInfo_U

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4714ae1d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:915 | if (fps.Name == "spdMain") | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-430b20e5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:921 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-807034d3 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:925 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_active_flag") | 데이터 객체 조작/조회 |  |  |  |
| AC-f3f783d5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:926 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7e3d735c | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:927 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_operation_group") | 데이터 객체 조작/조회 |  |  |  |
| AC-05750a2d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:928 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b035ca2d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:929 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_to_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-4e4d33c6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:930 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_from_site") | 데이터 객체 조작/조회 |  |  |  |
| AC-cf85b28a | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:931 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0aa821c6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:932 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-d23acf25 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:933 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-96fc0ed7 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:934 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-adb873a4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:935 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_qty") | 데이터 객체 조작/조회 |  |  |  |
| AC-53b77eda | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:936 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_from_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-309320d4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:937 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_origin_to_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-40984d73 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:938 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_electrode_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4ac0736 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:939 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dt.Columns.Add | ("p_created_by") | 데이터 객체 조작/조회 |  |  |  |
| AC-a3228061 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:940 | if (fps.Name == "spdMain") ▸ if (siMain != null) | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-f9922655 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:948 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00134", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dffb4ee4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:949 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (selCells.Length < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-30e60830 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:953 | if (fps.Name == "spdMain") ▸ if (siMain != null) | MESSAGE | MessageHelper.GMessageBox | ("MSG00016") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a3bf6bef | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:953 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (MessageHelper.GMessageBox("MSG00016") != DialogResult.Yes) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a3bb6efa | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1008 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-478ad9b6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1009 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-0dd07e8e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1010 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cf825ae6 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1011 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-75bd7681 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1012 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-74a887fa | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1013 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | str_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-f1b17bc5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1014 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | str_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5421cbcc | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1015 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | str_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-487b9bea | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1016 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-f4591a61 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1017 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | str_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-51b63922 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1018 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | str_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-4affdf44 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1019 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-66fb104e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1020 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | str_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-251e352f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1021 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | str_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-acf26429 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1022 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-2be6c30e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1023 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e3ba50c4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1024 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-8d8e647e | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1045 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-28bd15ac | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1046 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_active_flag"] | strAction | 행/컬럼 값 대입 |  |  |  |
| AC-847dad34 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1047 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_division_id"] | str_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a8318ce5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1048 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_operation_group"] | str_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-2b3cf4f1 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1049 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_item_id"] | str_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5c8e4828 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1050 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_to_site"] | str_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-1e4932a8 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1051 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_from_site"] | str_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-174db17d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1052 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_bod_id"] | str_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-baaefdde | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1053 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_yyyymmdd"] | strYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-e7c21dbb | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1054 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_project_code"] | str_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-8ea7cea5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1055 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_incoterms"] | str_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-21164090 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1056 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_qty"] | siMain.GetValue(i, j + nDayCntOfWeek).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-972be995 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1057 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_from_division_id"] | str_origin_from_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-d7f6eb5a | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1058 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_origin_to_division_id"] | str_origin_to_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f568f0c2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1059 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_electrode_type"] | str_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-3a0af264 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1060 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dr["p_created_by"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8f2eeb78 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1061 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ foreach (CellRange range in selCells) ▸ if (nRow >= 0 && nCol >= 0) ▸ for (i < nRow + row… | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-6ae23035 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1081 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) | DATA_OP | dsInput.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-4b67480f | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1096 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | CALL_EXT | sql.AddParameter | ("@SCP0025", dsInput.Tables[0]) | ⚠ 의미 확인 필요 |  |  |  |
| AC-85822215 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1097 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | ENDPOINT | sql.ExcuteProcedure | ("SaveShipmentPlanFix") ⇒ biz:AppService.GeneralRunProcedureCustomTable [procedure=SaveShipmentPlanFix] \|… | 엔드포인트 호출 |  |  |  |
| AC-64c5a7da | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1100 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f38bba32 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1105 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["re… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { result.Rows[0]["result_cnt"].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6102d869 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1114 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ else of (result != null && result.Rows.Count > 0 && result.Rows[0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00003", new object[] { ReErrorMsg }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6331185 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1123 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-093bab58 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1124 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-640d2745 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1130 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-fdec49e2 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1140 | if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ else of (iCount > 0) ▸ if (strAction == "D") | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0025_ShipmentPlanFix.SCM_SYS_LOG_BATCH

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e08838ea | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1156 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-a884fdac | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1157 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-d9df2783 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1158 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-d83a15a4 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1159 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-9db637e0 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1160 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-f1707bc5 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1161 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-47d6f8e8 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1162 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-a7017b97 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… | SCP0025_ShipmentPlanFix.cs:1164 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0025_ShipmentPlanFix.Set_FixReason

진입점: btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (tran.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (tran.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ca9274 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:644 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_INIT | siMain.SetCellTypeText | (iRow, iCol) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fb6da96d | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:668 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | DATA_OP | dtFixReason.Select | (strFilterExpression) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb2e4daf | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:692 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | DATA_OP | dtFixReason.Select | (strFilterExpression) | 데이터 객체 조작/조회 |  |  |  |
| AC-4d154854 | btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecY… 외 1 | SCP0025_ShipmentPlanFix.cs:698 | for (iRow < siMain.ActiveSheet.RowCount) ▸ for (iCol < siMain.ActiveSheet.ColumnCount) ▸ if (siMain.ActiveSheet.Columns[iCol].Tag.ToString()… | GRID_SET | siMain.SetValue | (iRow, iCol, dr["FIX_REASON"].ToString()) | 그리드 값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.Set_SumValues

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2da301b3 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:835 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_mon… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |
| AC-5c75e369 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:842 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (co… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-d8e5c9f8 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:858 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | sum_week | 그리드 속성/값 설정 |  |  |  |
| AC-1b0ba755 | (진입점 미연결) | SCP0025_ShipmentPlanFix.cs:859 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ for (iCol < dsBinding.Tables[0].Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else o… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | sum_month | 그리드 속성/값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.SetOperationGroupByDivision

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ccf5bd5e | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:870 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-018bc53b | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:870 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23722fa2 | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:873 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-30fbf68b | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:873 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-36c5115d | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:876 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-983b0324 | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:880 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-96f283fd | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:881 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-4cc61bf4 | this.cboDivision.SelectedIndexChanged | SCP0025_ShipmentPlanFix.cs:885 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0025_ShipmentPlanFix.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / btnUnfix.Click [else of (null != dtPlanExecYn && dtPlanExecYn.Rows.Count==1 && dtPlanExecYn.Rows[0]["PLAN_STATUS"].ToString()=="0") ▸ if (fps.Name == "spdMain") ▸ if (siMain != null) ▸ if (iCount > 0) ▸ try ▸ if (result != null && result.Rows.Count > 0 && result.Rows[0]["result_code"].ToString().Equals("S")) ▸ try ▸ if (tran.Tables[0].Rows.Count > 0)] / FindButton [try ▸ if (tran.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-adc3dfdd | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1206 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-fc1e7dad | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1210 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e372b4f5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1215 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-950ee6bf | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1218 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-53329aad | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1222 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2abdcd9b | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1227 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e26aee92 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0025_ShipmentPlanFix.cs:1230 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0025_ShipmentPlanFix.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2b756a53 | this.spdMain.CellDoubleClick | SCP0025_ShipmentPlanFix.cs:447 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0025_ShipmentPlanFix.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b112f4e9 | this.spdMain.TopChange | SCP0025_ShipmentPlanFix.cs:452 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

