# AS-IS 액션 대조표 — SCP0018

> 원천: `Doc/asisfacts/screens/SCP0018/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 200행 · 메서드 28 · 종류 GRID_INIT 73 · GRID_SET 23 · UI_PROP 18 · DATA_OP 17 · FLAG 10 · RETURN 9 · POPUP 7 · COMBO_DATA 7 · LIST_REBIND 7 · UI_MISC 6 · ENDPOINT 5 · VALUE_SET 4 · CALL_EXT 4 · VALIDATE 3 · MESSAGE 2 · STATE 2 · GRID_BIND 1 · GRID_LOCK 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 4


## SCP0018_WaterfallShipmentPlanSemi.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-10c2a3ac | this.btnItem_Id.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1140 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-eb54c59d | this.btnItem_Id.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1142 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-2c402a01 | this.btnItem_Id.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1143 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b7310009 | this.btnItem_Id.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1144 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-7cc8b3c1 | this.btnItem_Id.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1150 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.btnMeasure_Click

진입점: this.btnMeasure.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4326cd5b | this.btnMeasure.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1071 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0018", measureType, false) | 팝업/폼 생성 |  |  |  |
| AC-42fd92ce | this.btnMeasure.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1072 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a52debf3 | this.btnMeasure.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1073 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-309c3b77 | this.btnMeasure.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1077 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-0d1f19c3 | this.btnMeasure.Click | SCP0018_WaterfallShipmentPlanSemi.cs:1079 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.ClbVersion_SelectedIndexChanged

진입점: this.clbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc45a787 | this.clbVersion.SelectedIndexChanged | SCP0018_WaterfallShipmentPlanSemi.cs:952 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01667c14 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:212 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 20) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-52f7134e | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:213 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f648a5e3 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:214 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ca32ca1 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:177 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-e62e994b | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:178 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99065867 | Dispose | SCP0018_WaterfallShipmentPlanSemi.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7c43681 | EditButton | SCP0018_WaterfallShipmentPlanSemi.cs:627 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e6c417f | EditButton | SCP0018_WaterfallShipmentPlanSemi.cs:628 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7b32abe | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:642 |  | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-65a56d20 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:643 | if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-841e249b | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:645 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-4169bb74 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:645 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-018d563c | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:667 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e465d717 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:670 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ef606fa9 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:674 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6e2b5b64 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:676 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5dbfdae2 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:680 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL") ⇒ SCP.SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL | 엔드포인트 요청 생성 |  |  |  |
| AC-61d2ae32 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:681 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-e758150c | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:682 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-54e8d08d | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:683 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0c21e22c | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:684 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-3eb8244a | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:685 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | pOperationGroup | 행/컬럼 값 대입 |  |  |  |
| AC-3b790fa2 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:686 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_Item_id | 행/컬럼 값 대입 |  |  |  |
| AC-37f4124f | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:687 | try ▸ lambda | DATA_OP | req.Parameters["p_version_no"] | p_version_no | 행/컬럼 값 대입 |  |  |  |
| AC-5d96fc80 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:688 | try ▸ lambda | DATA_OP | req.Parameters["p_electype"] | p_electype | 행/컬럼 값 대입 |  |  |  |
| AC-68a421b2 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:690 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | "SCP0018" | 행/컬럼 값 대입 |  |  |  |
| AC-97c1b283 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:692 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-c448993b | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:694 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d1fc3b7f | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:696 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-79edfe92 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:698 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c4e01198 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:705 | try | GRID_BIND | siMain.Query | (tranPivot) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5e398da3 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:706 | try | UI_MISC | SetSearchCount | (tranPivot) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-a15f7e99 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:716 | try ▸ if (tranPivot.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e2862a3 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:717 | try ▸ if (tranPivot.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2c51ef88 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:722 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1bc776aa | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:724 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-76760290 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:728 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-836fd977 | FindButton | SCP0018_WaterfallShipmentPlanSemi.cs:729 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1fedfe04 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:166 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-714f094b | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:959 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BucketISO, false, "", "", "", "", "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3609541 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:961 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.GetDayRange

진입점: this.Load / this.clbVersion.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acbe6638 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:1039 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, strFromDate) | ⚠ 의미 확인 필요 |  |  |  |
| AC-864c76e1 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:1041 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.GetSpdTitle

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6286d7fa | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:999 |  | ENDPOINT | new FoxDataRequest | (procName) ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN_ISO \| SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-3a518aac | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:1001 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-5f2d7e8a | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:1002 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0f8654f0 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:1004 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-30f0ed3b | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:1004 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4a9cbad6 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:184 |  | DATA_OP | this.ConditionNotUseList.Add | (clbVersion) | 데이터 객체 조작/조회 |  |  |  |
| AC-4347dc23 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:187 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c91edd0 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:190 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-bb3a1bed | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:192 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c66b37e | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:194 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1704fddb | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:199 |  | FLAG | dtElecType | Data.Common(Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-7e33b5d7 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:199 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "ELECTRODE_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2907e4e | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:200 |  | LIST_REBIND | clsCtrl.setListBox | (dtElecType, clbElecType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-64b07824 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:204 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-9f5749b9 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:205 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-95e303a1 | this.Load | SCP0018_WaterfallShipmentPlanSemi.cs:207 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6291584b | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:252 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-ef154879 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:254 |  | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-72499fa7 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:255 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.KEY_IDX, DefColumns.KEY_IDX, FPMerge.Restricted, 60, false, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-894e5e16 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:256 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.DIVISION_ID, DefColumns.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5cf07042 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:257 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.OPERATION_GROUP_DESC, DefColumns.OPERATION_GROUP_DESC, FPMerge.Restricted… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b9dde6c3 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:258 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.ITEM_ID, DefColumns.ITEM_ID, FPMerge.Restricted, 103, true, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-126650bd | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:259 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.NICK_NAME, DefColumns.NICK_NAME, FPMerge.Restricted, 65, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-57df02b2 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:260 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.FROM_SITE_DESCRIPTION, DefColumns.FROM_SITE_DESCRIPTION, FPMerge.Restrict… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-33951cbc | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:261 |  | GRID_INIT | spdInfo.AddNumColumn | (DefColumnsLabel.BOH, DefColumns.BOH, FPMerge.Restricted, 75, true, FPHAlign.Right, FPVAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-334a17c2 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:262 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.T0_SITE_DESCRIPTION, DefColumns.TO_SITE_DESCRIPTION, FPMerge.Restricted, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-babfcadc | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:263 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.TRANSPORT_MODE, DefColumns.TRANSPORT_MODE, FPMerge.Restricted, 40, true, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b43e9b2 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:264 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.LT_DAY, DefColumns.LT_DAY, FPMerge.Restricted, 40, true, FPHAlign.Right, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f12d8375 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:265 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.VERSION_NO, DefColumns.VERSION_NO, FPMerge.Restricted, 100, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9c2bdaf | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:266 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.MEASURE_LABEL, DefColumns.MEASURE_LABEL, FPMerge.Restricted, 110, true, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7354154d | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:267 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.MEASURE, DefColumns.MEASURE, FPMerge.Restricted, 80, false, FPHAlign.Left… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0162fb08 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:268 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.DIVISION_NAME, DefColumns.DIVISION_NAME, FPMerge.Restricted, 60, false, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1a742da4 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:269 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.OPERATION_GROUP, DefColumns.OPERATION_GROUP, FPMerge.Restricted, 90, fals… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0000d245 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:270 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.FROM_SITE, DefColumns.FROM_SITE, FPMerge.Restricted, 110, false, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c83f1df | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:271 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.TO_SITE, DefColumns.TO_SITE, FPMerge.Restricted, 110, false, FPHAlign.Lef… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5520fce1 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:272 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.BOD_ID, DefColumns.BOD_ID, FPMerge.Restricted, 110, false, FPHAlign.Right… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-93363df4 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:273 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.MEASURE_ORDER_NO, DefColumns.MEASURE_ORDER_NO, FPMerge.Restricted, 140, f… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-986563ba | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:274 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.FROM_YYYYMMDD, DefColumns.FROM_YYYYMMDD, FPMerge.Restricted, 140, false, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be50c3e7 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:275 |  | GRID_INIT | spdInfo.AddTextColumn | (DefColumnsLabel.TO_YYYYMMDD, DefColumns.TO_YYYYMMDD, FPMerge.Restricted, 140, false, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b6abcb9 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:278 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, 0, 3, 1, 20, " ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7cf0adcc | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:279 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.KEY_IDX), 3, 1, 20, DefColumnsLabel.KEY_IDX, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7b0e73fd | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:280 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DIVISION_ID), 3, 1, 20, DefColumnsLabel.DIVISION_ID, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4867487e | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:281 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.DIVISION_NAME), 3, 1, 20, DefColumnsLabel.DIVISION_NA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e0cf77ff | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:282 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP), 3, 1, 20, DefColumnsLabel.OPERATION… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e3fd7e63 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:283 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.OPERATION_GROUP_DESC), 3, 1, 20, DefColumnsLabel.OPER… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c8e4b1d5 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:284 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.ITEM_ID), 3, 1, 20, DefColumnsLabel.ITEM_ID, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f46e17b | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:285 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.NICK_NAME), 3, 1, 20, DefColumnsLabel.NICK_NAME, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c043f7a4 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:286 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE), 3, 1, 20, DefColumnsLabel.FROM_SITE, FPHA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f9c9327 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:287 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_SITE_DESCRIPTION), 3, 1, 20, DefColumnsLabel.FRO… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b230ef6b | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:288 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.BOH), 3, 1, 20, DefColumnsLabel.BOH, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0264847b | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:289 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_SITE), 3, 1, 20, DefColumnsLabel.TO_SITE, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02f3b818 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:290 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION), 3, 1, 20, DefColumnsLabel.T0_SI… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-78a59af0 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:291 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE), 3, 1, 20, DefColumnsLabel.TRANSPORT_… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02b49f01 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:292 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.LT_DAY), 3, 1, 20, DefColumnsLabel.LT_DAY, FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6fb2b25 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:293 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.MEASURE_LABEL), 3, 1, 20, DefColumnsLabel.MEASURE_LAB… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d467f763 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:294 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.VERSION_NO), 3, 1, 20, DefColumnsLabel.VERSION_NO, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-412a3a8f | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:295 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.MEASURE), 3, 1, 20, DefColumnsLabel.MEASURE, FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4a62a3e4 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:296 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.MEASURE_ORDER_NO), 3, 1, 20, DefColumnsLabel.MEASURE_… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-109b4e22 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:297 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD), 3, 1, 20, DefColumnsLabel.FROM_YYYYMM… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e6b75527 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:298 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), 3, 1, 20, DefColumnsLabel.TO_YYYYMMDD, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f159aaf0 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:308 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE_LABEL) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5df6d229 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:310 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.InitSpread_2

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4d70dc18 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:222 |  | GRID_INIT | siMain.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-bc2825a3 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:226 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (spreadInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-510e1558 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:232 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-215fe868 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:238 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-4b775e14 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:239 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-5578c1f4 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:240 | if (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e2aa0b14 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:244 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-862d3b77 | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:245 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d162557c | this.Load 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:246 | else of (!division.Substring(0, 2).Equals("EE")) | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.InitSpreadDateColumnISO

진입점: this.Load [if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / FindButton [if (cboBucketType.ControlValues == BucketType.WeeklyISO)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17bd7bff | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:344 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.AddNumColumn | (cCOLUMN_LABEL_NAME, cCOLUMN_NAME, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19a790ba | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:346 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(cCOLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-252453fb | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:348 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | CALL_EXT | Debug.Print | (string.Format("All Rows {0} : cCOLUMN_NAME : {1}", i, cCOLUMN_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-183885bb | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:350 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iSmallStartCol + i, 1, 1, 20, cMMDD_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2b768159 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:351 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol + i, 1, 1, 20, cCOLUMN_LABEL_NAME, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f9a1e295 | this.Load [if (cboBucketType.ControlValues == BucketType.Wee… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:352 | for (i <= dsSpdTitle.Tables[0].Rows.Count-1) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol + i, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.InitSpreadDateColumnNotISO

진입점: this.Load [else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK) ▸ else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / FindButton [else of (cboBucketType.ControlValues == BucketType.WeeklyISO)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3563794 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:413 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (COLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (COLUMN_LABEL_NAME, COLUMN_NAME, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8cb317af | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:415 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (COLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(COLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-263de4af | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:421 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (COLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (COLUMN_LABEL_NAME, COLUMN_NAME, FPMerge.None, colWidth, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60a04903 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:423 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (COLUMN_NAME.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(COLUMN_NAME), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-3982e3bd | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:427 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (COLUMN_NAME.IndexOf("B_") > 0) ▸ if (DAY_CODE == DefColumnsLabel.Saturday \|\| … | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | DAY_CODE == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-73e86c9a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:437 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, idxLargeStartCol, 1, largeSpanCnt, 20, largeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa4cc6b1 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:438 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, idxLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94368a90 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:444 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, idxSmallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a8c160fb | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:445 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (largeSpanName != LARGE_CLASS_LABEL_NAME) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, idxSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6d444ee4 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:454 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (largeSpanName != LARGE_CLASS_LABEL_NAME) ▸ if (smallSpanName != SMALL_CLASS_LAB… | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, idxSmallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8053dc34 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:455 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (largeSpanName != LARGE_CLASS_LABEL_NAME) ▸ if (smallSpanName != SMALL_CLASS_LAB… | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, idxSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5faae97c | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:467 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, idxSmallStartCol, 1, smallSpanCnt, 20, smallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4c447b81 | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:468 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, idxSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5057532a | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:469 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, idxLargeStartCol, 1, largeSpanCnt, 20, largeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b6d98b8e | this.Load [else of (cboBucketType.ControlValues == BucketTyp… 외 4 | SCP0018_WaterfallShipmentPlanSemi.cs:470 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, idxLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.RetLongValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ce7d88c | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:845 | if (obj.ToString() != "" && obj != null && obj != DBNull.Value) | CALL_EXT | Convert.ToInt64 | (obj) | ⚠ 의미 확인 필요 |  |  |  |
| AC-7318f671 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:847 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.RetValue

진입점: FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_month_idx != 0) ▸ else of (!measure.Equals("INVENTORY"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb9be770 | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0) ▸ … | SCP0018_WaterfallShipmentPlanSemi.cs:837 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.Set_SumValues

진입점: FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f8df4e40 | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:769 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_month… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, sum_month) | 그리드 값 설정 |  |  |  |
| AC-9a8ab7eb | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:775 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ if (colName.IndexOf("M_") == 0) ▸ if (bef_month… | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, val) | 그리드 값 설정 |  |  |  |
| AC-fe423414 | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:788 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (colN… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, sum_week) | 그리드 값 설정 |  |  |  |
| AC-ff10ec49 | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:794 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ if (colN… | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, val) | 그리드 값 설정 |  |  |  |
| AC-ba1bb72a | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:814 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, sum_week) | 그리드 값 설정 |  |  |  |
| AC-9fa1c69d | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:815 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, sum_month) | 그리드 값 설정 |  |  |  |
| AC-d8f5c71e | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:820 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_week_idx, val) | 그리드 값 설정 |  |  |  |
| AC-28caa18c | FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] | SCP0018_WaterfallShipmentPlanSemi.cs:821 | for (iRow < siMain.ActiveSheet.Rows.Count) ▸ for (iCol < siMain.ActiveSheet.Columns.Count) ▸ else of (colName.IndexOf("M_") == 0) ▸ else of … | GRID_SET | siMain.SetValue | (iRow, bef_month_idx, val) | 그리드 값 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.SetChangedControl

진입점: this.Load / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6b7dcf53 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:585 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-3f2bc23b | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:585 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0bb49404 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:586 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (!division.Substring(0, 2).Equals("EE")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a07dd070 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:590 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data.Common(Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI_EE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-a8c745fd | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:590 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "OPERATION_GROUP_SEMI_EE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e8e80abb | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:591 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ else of (!division.Substring(0, 2).Equals("EE")) | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f02a0ce3 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:595 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtVersion | Data_SCP.Common(Data_SCP.Type.WaterfallVer_FG2, false, division, "") | 화면 필드/플래그 변경 |  |  |  |
| AC-ad855a27 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:595 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.WaterfallVer_FG2, false, division, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-08a88c67 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:597 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtVersion, clbVersion, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-6091c940 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:602 | if (!division.Substring(0, 2).Equals("EE")) | VALUE_CLEAR | clbElecType.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-a8b466a6 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:603 | if (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-be870723 | this.Load 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:607 | else of (!division.Substring(0, 2).Equals("EE")) | STATE | clbElecType.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.SetOperationGroupByDivision

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f339ad9a | this.cboDivision.SelectedIndexChanged | SCP0018_WaterfallShipmentPlanSemi.cs:856 | if (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-f2998e3a | this.cboDivision.SelectedIndexChanged | SCP0018_WaterfallShipmentPlanSemi.cs:856 | if (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-93903ef7 | this.cboDivision.SelectedIndexChanged | SCP0018_WaterfallShipmentPlanSemi.cs:860 | else of (!division.Substring(0, 2).Equals("EE")) | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-9b05f328 | this.cboDivision.SelectedIndexChanged | SCP0018_WaterfallShipmentPlanSemi.cs:860 | else of (!division.Substring(0, 2).Equals("EE")) | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-047b95a0 | this.cboDivision.SelectedIndexChanged | SCP0018_WaterfallShipmentPlanSemi.cs:863 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.btnMeasure.Click [if (frm.DialogResult == DialogResult.OK)] / FindButton [try ▸ if (tranPivot.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e01647c | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:524 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-f36c2a22 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:529 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Daily: ▸ if (isMonthly \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-a7eab696 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:538 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isDaily) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-da5fc891 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:542 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ else of (isDaily) ▸ if (isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-48e79fdb | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:547 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Weekly: ▸ if (isMonthly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-f9c35936 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:554 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.WeeklyISO: | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | isWeeklyISO | 그리드 속성/값 설정 |  |  |  |
| AC-b8a76c54 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:562 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Monthly: ▸ if (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a68a5fe5 | this.chkSum.CheckedChanged [if (siMain != null)] 외 5 | SCP0018_WaterfallShipmentPlanSemi.cs:566 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ switch (cboBucketType.ControlValues) case BucketType.Monthly: ▸ else of (isDaily \|\| isWeekly) | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.SetVisibleSum

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7e54f104 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 1 | SCP0018_WaterfallShipmentPlanSemi.cs:1105 |  | UI_PROP | lciSum.Visibility | cboBucketType.ControlValues == BucketType.WeeklyISO ? LayoutVisibility.Never : LayoutVisib… | 속성 Visibility 설정 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57be17ce | this.spdMain.CellDoubleClick | SCP0018_WaterfallShipmentPlanSemi.cs:976 | if (cboBucketType.ControlValues == BucketType.WeeklyISO) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fd72ac1 | this.spdMain.CellDoubleClick | SCP0018_WaterfallShipmentPlanSemi.cs:978 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.spdMain_TopChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8a3a32a6 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:970 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17532a0b | this.spdMain.TopChange | SCP0018_WaterfallShipmentPlanSemi.cs:1054 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0018_WaterfallShipmentPlanSemi.TotalCellsMerge

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77ceea92 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:872 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefColumns.TO_SITE_DESCRIPTION)) | 데이터 객체 조작/조회 |  |  |  |
| AC-78f3e124 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:873 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefColumns.TRANSPORT_MODE)) | 데이터 객체 조작/조회 |  |  |  |
| AC-23f750c0 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:874 |  | DATA_OP | list.Add | (siMain.GetColumnIndex(DefColumns.LT_DAY)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4dcab9c7 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:899 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-326f5f3c | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:900 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-c4811313 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:901 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-e516f0ca | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:905 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-d3109fda | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:906 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (cur_key_idx != bef_key_idx) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-d86f57c3 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:936 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-36f6b222 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:937 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-8a54c156 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:938 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) ▸ foreach (int idx in list) | UI_PROP | range.RowSpan | rowSpan_Count | 속성 RowSpan 설정 |  |  |  |
| AC-9aefb696 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:942 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-8b10bc49 | (진입점 미연결) | SCP0018_WaterfallShipmentPlanSemi.cs:943 | for (iRow <= siMain.GetMaxRowIndex()) ▸ if (iRow == siMain.GetMaxRowIndex()) ▸ if (isSum) | UI_PROP | boh.RowSpan | bohSpan_Count | 속성 RowSpan 설정 |  |  |  |

