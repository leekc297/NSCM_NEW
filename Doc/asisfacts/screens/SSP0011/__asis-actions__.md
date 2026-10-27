# AS-IS 액션 대조표 — SSP0011

> 원천: `Doc/asisfacts/screens/SSP0011/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 221행 · 메서드 29 · 종류 GRID_INIT 56 · DATA_OP 23 · GRID_SET 19 · FLAG 15 · COMBO_DATA 14 · ENDPOINT 14 · RETURN 13 · UI_PROP 12 · VALUE_SET 12 · LIST_REBIND 11 · POPUP 8 · UI_MISC 6 · MESSAGE 4 · GRID_CLEAR 3 · VALIDATE 3 · CALL_EXT 2 · STATE 2 · GRID_BIND 1 · GRID_LOCK 1 · THROW 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 2


## SSP0011_PSI.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b38b741f | this.btnItemId.Click | SSP0011_PSI.cs:537 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-5a6d1806 | this.btnItemId.Click | SSP0011_PSI.cs:538 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a76ceccc | this.btnItemId.Click | SSP0011_PSI.cs:539 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d32454d8 | this.btnItemId.Click | SSP0011_PSI.cs:540 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-78f0cf05 | this.btnItemId.Click | SSP0011_PSI.cs:544 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0011_PSI.BtnNickName_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-06dd1a08 | (진입점 미연결) | SSP0011_PSI.cs:498 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0df5fde7 | (진입점 미연결) | SSP0011_PSI.cs:499 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-82973326 | (진입점 미연결) | SSP0011_PSI.cs:500 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-8864f816 | (진입점 미연결) | SSP0011_PSI.cs:501 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5091a0c2 | (진입점 미연결) | SSP0011_PSI.cs:505 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0011_PSI.CboOperGroup_SelectedIndexChanged

진입점: cboOperGroup.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af18a158 | cboOperGroup.SelectedIndexChanged | SSP0011_PSI.cs:440 | if (pDivisionID != "EE") | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-b423bf1b | cboOperGroup.SelectedIndexChanged | SSP0011_PSI.cs:440 | if (pDivisionID != "EE") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c81df4ae | cboOperGroup.SelectedIndexChanged | SSP0011_PSI.cs:442 | else of (pDivisionID != "EE") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlanSitePSISSP, false, pDivisionID, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-84e1ddf0 | cboOperGroup.SelectedIndexChanged | SSP0011_PSI.cs:442 | else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanSitePSISSP, false, pDivisionID, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cfce4cc6 | cboOperGroup.SelectedIndexChanged | SSP0011_PSI.cs:444 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0011_PSI.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aa088a23 | cboPlanDate.SelectedIndexChanged | SSP0011_PSI.cs:953 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-2a71ea23 | cboPlanDate.SelectedIndexChanged | SSP0011_PSI.cs:953 |  | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc0757a3 | cboPlanDate.SelectedIndexChanged | SSP0011_PSI.cs:954 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-438b4a12 | cboPlanDate.SelectedIndexChanged | SSP0011_PSI.cs:956 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-564742bb | cboPlanDate.SelectedIndexChanged | SSP0011_PSI.cs:958 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-d3a90aed | cboPlanDate.SelectedIndexChanged | SSP0011_PSI.cs:960 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0011_PSI.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c52e6904 | cboPlanSeq.SelectedIndexChanged | SSP0011_PSI.cs:980 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0011_PSI.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-711473a3 | cboPlanType.SelectedIndexChanged | SSP0011_PSI.cs:967 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-0006c859 | cboPlanType.SelectedIndexChanged | SSP0011_PSI.cs:967 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c312e892 | cboPlanType.SelectedIndexChanged | SSP0011_PSI.cs:968 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false , "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-457cf0bf | cboPlanType.SelectedIndexChanged | SSP0011_PSI.cs:970 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-10eaa328 | cboPlanType.SelectedIndexChanged | SSP0011_PSI.cs:974 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0011_PSI.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af28473b | this.Load | SSP0011_PSI.cs:217 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9602dd98 | this.Load | SSP0011_PSI.cs:218 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-771f5ebd | this.Load | SSP0011_PSI.cs:220 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0011_PSI.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e205ab7 | this.Load | SSP0011_PSI.cs:160 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-b2da7229 | this.Load | SSP0011_PSI.cs:161 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0011_PSI.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9b54465 | Dispose | SSP0011_PSI.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0011_PSI.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c421dfe | EditButton | SSP0011_PSI.cs:525 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02afc54e | EditButton | SSP0011_PSI.cs:526 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0011_PSI.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efb5184c | FindButton | SSP0011_PSI.cs:659 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-2146016e | FindButton | SSP0011_PSI.cs:659 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25db26fd | FindButton | SSP0011_PSI.cs:660 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-f77290aa | FindButton | SSP0011_PSI.cs:660 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f1f7f66 | FindButton | SSP0011_PSI.cs:691 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-70801b51 | FindButton | SSP0011_PSI.cs:693 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-dfd1b142 | FindButton | SSP0011_PSI.cs:696 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f6119c75 | FindButton | SSP0011_PSI.cs:698 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_Plan_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0b6c9fd | FindButton | SSP0011_PSI.cs:700 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0011_GET_PSI") ⇒ SSP.SSP0011_GET_PSI | 엔드포인트 요청 생성 |  |  |  |
| AC-01b444b3 | FindButton | SSP0011_PSI.cs:701 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d3b24844 | FindButton | SSP0011_PSI.cs:702 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-282c3069 | FindButton | SSP0011_PSI.cs:703 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-3614c0d0 | FindButton | SSP0011_PSI.cs:704 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e6e1cd2c | FindButton | SSP0011_PSI.cs:705 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-f427bc16 | FindButton | SSP0011_PSI.cs:706 | try ▸ lambda | DATA_OP | req.Parameters["p_From_Site"] | p_From_Site | 행/컬럼 값 대입 |  |  |  |
| AC-6775ad19 | FindButton | SSP0011_PSI.cs:707 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-17ed868b | FindButton | SSP0011_PSI.cs:708 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-255fd047 | FindButton | SSP0011_PSI.cs:709 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-b0ea2628 | FindButton | SSP0011_PSI.cs:710 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-bd8089f3 | FindButton | SSP0011_PSI.cs:711 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-e88e630c | FindButton | SSP0011_PSI.cs:712 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-4a3a272d | FindButton | SSP0011_PSI.cs:713 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | DBNull.Value | 행/컬럼 값 대입 |  |  |  |
| AC-3f5bfac5 | FindButton | SSP0011_PSI.cs:714 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-45fce2ab | FindButton | SSP0011_PSI.cs:715 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-fedf73a5 | FindButton | SSP0011_PSI.cs:722 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5092277a | FindButton | SSP0011_PSI.cs:723 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-555d95e7 | FindButton | SSP0011_PSI.cs:742 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | VALUE_SET | cells.Text | "Sum" | 컨트롤 값 설정 |  |  |  |
| AC-217e6aa7 | FindButton | SSP0011_PSI.cs:743 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ColumnSpan | 3 | 속성 ColumnSpan 설정 |  |  |  |
| AC-76914ff1 | FindButton | SSP0011_PSI.cs:744 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.ForeColor | Color.Black | 속성 ForeColor 설정 |  |  |  |
| AC-efff8401 | FindButton | SSP0011_PSI.cs:745 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.BackColor | Color.LightGray | 속성 BackColor 설정 |  |  |  |
| AC-d4dbcde6 | FindButton | SSP0011_PSI.cs:746 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ for (iRow < siMain.ActiveSheet.Rows.Count) ▸ if (IsSum.ToUpper… | UI_PROP | cells.HorizontalAlignment | CellHorizontalAlignment.Center | 속성 HorizontalAlignment 설정 |  |  |  |
| AC-5ab6335c | FindButton | SSP0011_PSI.cs:769 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8a57e2a2 | FindButton | SSP0011_PSI.cs:773 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9d6efa41 | FindButton | SSP0011_PSI.cs:777 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e08563b3 | FindButton | SSP0011_PSI.cs:779 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3f01ecf | FindButton | SSP0011_PSI.cs:781 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-37088bee | FindButton | SSP0011_PSI.cs:782 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0011_PSI.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-772fa9b5 | this.Load | SSP0011_PSI.cs:149 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0011_PSI.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4158a640 | this.Load | SSP0011_PSI.cs:197 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-f80f50ee | this.Load | SSP0011_PSI.cs:198 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ac75e062 | this.Load | SSP0011_PSI.cs:201 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0011_PSI.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c91aeb4 | this.Load 외 1 | SSP0011_PSI.cs:1023 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-02d5748a | this.Load 외 1 | SSP0011_PSI.cs:1024 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-b7154060 | this.Load 외 1 | SSP0011_PSI.cs:1025 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-08041a8c | this.Load 외 1 | SSP0011_PSI.cs:1026 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-968021b5 | this.Load 외 1 | SSP0011_PSI.cs:1027 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e26f7b9f | this.Load 외 1 | SSP0011_PSI.cs:1030 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0011_PSI.GetFromSiteByDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4e78b1a | (진입점 미연결) | SSP0011_PSI.cs:208 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_FROM_SITE") ⇒ SCM.SCM0001_GET_FROM_SITE | 엔드포인트 요청 생성 |  |  |  |
| AC-9fe6e47e | (진입점 미연결) | SSP0011_PSI.cs:210 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4158a235 | (진입점 미연결) | SSP0011_PSI.cs:213 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0011_PSI.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-43e1a083 | (진입점 미연결) | SSP0011_PSI.cs:620 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2815ebe2 | (진입점 미연결) | SSP0011_PSI.cs:621 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_Plan_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-02f1b2cb | (진입점 미연결) | SSP0011_PSI.cs:625 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP_GET_LAST_PLAN_VERSION") ⇒ SSP.SSP_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-a4f6e68d | (진입점 미연결) | SSP0011_PSI.cs:626 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-36fc6ee2 | (진입점 미연결) | SSP0011_PSI.cs:627 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8336ecdb | (진입점 미연결) | SSP0011_PSI.cs:628 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b6aa15e7 | (진입점 미연결) | SSP0011_PSI.cs:641 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-57db88f6 | (진입점 미연결) | SSP0011_PSI.cs:642 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-7242f3e4 | (진입점 미연결) | SSP0011_PSI.cs:643 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SSP0011_PSI.GetSpdTitle

진입점: this.Load / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-480e185d | this.Load 외 2 | SSP0011_PSI.cs:275 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SSP0012", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5427bbd1 | this.Load 외 2 | SSP0011_PSI.cs:277 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |
| AC-9fac2ec3 | this.Load 외 2 | SSP0011_PSI.cs:1006 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-8fa1c26d | this.Load 외 2 | SSP0011_PSI.cs:1007 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-c0fc5ac7 | this.Load 외 2 | SSP0011_PSI.cs:1008 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-4a40f5a3 | this.Load 외 2 | SSP0011_PSI.cs:1010 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-07e4caf5 | this.Load 외 2 | SSP0011_PSI.cs:1010 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0011_PSI.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4136b388 | this.Load | SSP0011_PSI.cs:166 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-f5132ae1 | this.Load | SSP0011_PSI.cs:169 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-5e70b74e | this.Load | SSP0011_PSI.cs:170 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-5d9706e8 | this.Load | SSP0011_PSI.cs:171 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c3d1b30 | this.Load | SSP0011_PSI.cs:174 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e7fa8cb | this.Load | SSP0011_PSI.cs:176 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-26e3d447 | this.Load | SSP0011_PSI.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6d4aae5d | this.Load | SSP0011_PSI.cs:183 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-25a43565 | this.Load | SSP0011_PSI.cs:187 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-b189322b | this.Load | SSP0011_PSI.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e9467d6d | this.Load | SSP0011_PSI.cs:190 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0011_PSI.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fe413f55 | (진입점 미연결) | SSP0011_PSI.cs:291 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-db397b51 | (진입점 미연결) | SSP0011_PSI.cs:292 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 40, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4f3613ef | (진입점 미연결) | SSP0011_PSI.cs:293 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP_DESC, DefMain.OPERATION_GROUP_DESC, FPMerge.Restricted, 65 ,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-429d7bd1 | (진입점 미연결) | SSP0011_PSI.cs:294 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SITE_DESCRIPTION, DefMain.SITE_DESCRIPTION, FPMerge.Restricted, 65, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-485a9b87 | (진입점 미연결) | SSP0011_PSI.cs:295 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 115 , true , FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dad6b31a | (진입점 미연결) | SSP0011_PSI.cs:296 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 80, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ecea7653 | (진입점 미연결) | SSP0011_PSI.cs:298 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ELECTRODE_TYPE, DefMain.ELECTRODE_TYPE, FPMerge.Restricted, elec_size, true … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bd95bf92 | (진입점 미연결) | SSP0011_PSI.cs:299 |  | GRID_INIT | spdInfo.AddNumColumn | (DefMainLabel.BOH, DefMain.BOH, FPMerge.Restricted , 75, true, FPHAlign.Right , FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d858d75c | (진입점 미연결) | SSP0011_PSI.cs:300 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_NAME, DefMain.PSI_NAME, FPMerge.Restricted, 75, true, FPHAlign.Left, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7efba27c | (진입점 미연결) | SSP0011_PSI.cs:301 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_VALUE, DefMain.PSI_VALUE, FPMerge.Restricted, 120, true, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0ab0c4d2 | (진입점 미연결) | SSP0011_PSI.cs:302 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PSI_TYPE, DefMain.PSI_TYPE, FPMerge.Restricted, 65, false, FPHAlign.Left, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d41ebc45 | (진입점 미연결) | SSP0011_PSI.cs:304 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FROM_SITE, DefMain.FROM_SITE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2d0e16e3 | (진입점 미연결) | SSP0011_PSI.cs:305 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 130, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b34ff1b | (진입점 미연결) | SSP0011_PSI.cs:306 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.OPERATION_GROUP, DefMain.OPERATION_GROUP, FPMerge.Restricted, 60, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02f5c137 | (진입점 미연결) | SSP0011_PSI.cs:307 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_START_YYYYMMDD, DefMain.PLAN_START_YYYYMMDD, FPMerge.Restricted, 60, fa… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-29050683 | (진입점 미연결) | SSP0011_PSI.cs:308 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_TYPE, DefMain.PLAN_TYPE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c4054013 | (진입점 미연결) | SSP0011_PSI.cs:311 |  | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SEQ, DefMain.SEQ, FPMerge.Restricted, 60, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-75a4fbcc | (진입점 미연결) | SSP0011_PSI.cs:314 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d93e3777 | (진입점 미연결) | SSP0011_PSI.cs:315 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-140eabf2 | (진입점 미연결) | SSP0011_PSI.cs:316 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_START_YYYYMMDD), 3, 1, 20, "PLAN_START_YYYYMMDD", … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc19b67f | (진입점 미연결) | SSP0011_PSI.cs:317 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_TYPE), 3, 1, 20, "PLAN_TYPE", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-48ae97b6 | (진입점 미연결) | SSP0011_PSI.cs:318 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SEQ), 3, 1, 20, "SEQ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9fea46c2 | (진입점 미연결) | SSP0011_PSI.cs:319 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.OPERATION_GROUP), 3, 1, 20, "Operation Group", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f82fcd84 | (진입점 미연결) | SSP0011_PSI.cs:320 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.OPERATION_GROUP_DESC), 3, 1, 20, "Operation Group", FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0ca7b21 | (진입점 미연결) | SSP0011_PSI.cs:321 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.FROM_SITE), 3, 1, 20, "From Site", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2722e59c | (진입점 미연결) | SSP0011_PSI.cs:322 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SITE_DESCRIPTION), 3, 1, 20, "From Site", FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-134ef1f4 | (진입점 미연결) | SSP0011_PSI.cs:323 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, "Model", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4654ca4c | (진입점 미연결) | SSP0011_PSI.cs:324 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, "Nick Name", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae0fe28e | (진입점 미연결) | SSP0011_PSI.cs:325 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ELECTRODE_TYPE), 3, 1, 20, "Electrode Type", FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-887f79e6 | (진입점 미연결) | SSP0011_PSI.cs:326 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.BOH), 3, 1, 20, "BOH (From Site)" , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1b402432 | (진입점 미연결) | SSP0011_PSI.cs:327 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_TYPE), 3, 1, 20, "PSI_Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e24ede01 | (진입점 미연결) | SSP0011_PSI.cs:328 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_NAME), 3, 1, 20, "PSI Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-15b394ac | (진입점 미연결) | SSP0011_PSI.cs:329 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PSI_VALUE), 3, 1, 20, "PSI Value", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19ddae7c | (진입점 미연결) | SSP0011_PSI.cs:339 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-715b2636 | (진입점 미연결) | SSP0011_PSI.cs:340 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefMain.PSI_VALUE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2efc430c | (진입점 미연결) | SSP0011_PSI.cs:341 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0011_PSI.InitSpread_2

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c16a1ce4 | this.Load 외 1 | SSP0011_PSI.cs:229 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-ad2460c0 | this.Load 외 1 | SSP0011_PSI.cs:235 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-0d50a36e | this.Load 외 1 | SSP0011_PSI.cs:243 | if (!pOperationGroup.Equals("E")) | GRID_SET | spdMain.ActiveSheet.Columns[siMain.GetColumnIndex(DefMain.ELECTRODE_TYPE)].Width | 0 | 그리드 속성/값 설정 |  |  |  |
| AC-56094105 | this.Load 외 1 | SSP0011_PSI.cs:246 |  | CALL_EXT | siMain.InitSpreadDateColumn | (siMain, drpPeriod.Text1, drpPeriod.Text2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-b1f48cc9 | this.Load 외 1 | SSP0011_PSI.cs:253 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9b4e1a13 | this.Load 외 1 | SSP0011_PSI.cs:255 |  | GRID_INIT | siMain.VisibleTab | (false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0442047b | this.Load 외 1 | SSP0011_PSI.cs:259 | if (pDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-e8ec3563 | this.Load 외 1 | SSP0011_PSI.cs:260 | if (pDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a47740ea | this.Load 외 1 | SSP0011_PSI.cs:261 | if (pDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-a9190514 | this.Load 외 1 | SSP0011_PSI.cs:265 | else of (pDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4db6196f | this.Load 외 1 | SSP0011_PSI.cs:266 | else of (pDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6cc9d7c4 | this.Load 외 1 | SSP0011_PSI.cs:267 | else of (pDivisionID != "EE") | GRID_SET | siMain.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0011_PSI.InitSpreadDateColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-617d16f9 | (진입점 미연결) | SSP0011_PSI.cs:374 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e238b0e9 | (진입점 미연결) | SSP0011_PSI.cs:377 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2376e692 | (진입점 미연결) | SSP0011_PSI.cs:380 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("D_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-fa8b0e0d | (진입점 미연결) | SSP0011_PSI.cs:386 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9718b474 | (진입점 미연결) | SSP0011_PSI.cs:387 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6a4cc49e | (진입점 미연결) | SSP0011_PSI.cs:392 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-31ea9035 | (진입점 미연결) | SSP0011_PSI.cs:393 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a59b98c | (진입점 미연결) | SSP0011_PSI.cs:400 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0945b97f | (진입점 미연결) | SSP0011_PSI.cs:401 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7145d9e2 | (진입점 미연결) | SSP0011_PSI.cs:411 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-37f545e3 | (진입점 미연결) | SSP0011_PSI.cs:412 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b3ab9dd2 | (진입점 미연결) | SSP0011_PSI.cs:413 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-44b49946 | (진입점 미연결) | SSP0011_PSI.cs:414 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0011_PSI.RetIntValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-856128f1 | (진입점 미연결) | SSP0011_PSI.cs:861 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0011_PSI.Set_Inventories

진입점: FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e874bb4b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0011_PSI.cs:827 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-7a1df4ae | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0011_PSI.cs:834 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-76ba84e7 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0011_PSI.cs:841 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-fdc54003 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0011_PSI.cs:842 | try ▸ for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (PSI_Type.Equals("I") && !measure.Equals("Char. Completed")) ▸ for (iCol < dsBinding.… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][bef_day_idx] | 그리드 속성/값 설정 |  |  |  |
| AC-ac6bf6f0 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0011_PSI.cs:849 | catch ((Exception et)) | THROW | throw et; |  | 예외 발생 |  |  |  |
| AC-eda91485 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0011_PSI.cs:851 | finally | DATA_OP | dsBinding.Tables[0].AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0011_PSI.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4c405cad | this.Load 외 1 | SSP0011_PSI.cs:560 | if (pDivisionID == "EE") | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroupEE, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-6704ebce | this.Load 외 1 | SSP0011_PSI.cs:560 | if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroupEE, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-616cbf8d | this.Load 외 1 | SSP0011_PSI.cs:561 | if (pDivisionID == "EE") | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlanSitePSISSP, false, pDivisionID, pOperationGroup) | 화면 필드/플래그 변경 |  |  |  |
| AC-dd122031 | this.Load 외 1 | SSP0011_PSI.cs:561 | if (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlanSitePSISSP, false, pDivisionID, pOperationGroup) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b7942717 | this.Load 외 1 | SSP0011_PSI.cs:565 | else of (pDivisionID == "EE") | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-65b8ea4c | this.Load 외 1 | SSP0011_PSI.cs:565 | else of (pDivisionID == "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1a763214 | this.Load 외 1 | SSP0011_PSI.cs:566 | else of (pDivisionID == "EE") | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-2014f4b3 | this.Load 외 1 | SSP0011_PSI.cs:566 | else of (pDivisionID == "EE") | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, pDivisionID, pOperationGroup) ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1eafe012 | this.Load 외 1 | SSP0011_PSI.cs:568 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboOperGroup, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-9d0d3a0d | this.Load 외 1 | SSP0011_PSI.cs:572 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite , true) | 목록 컨트롤 재구성 |  |  |  |
| AC-314df650 | this.Load 외 1 | SSP0011_PSI.cs:577 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-1f04aba8 | this.Load 외 1 | SSP0011_PSI.cs:577 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b45d1145 | this.Load 외 1 | SSP0011_PSI.cs:578 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-ba55ebed | this.Load 외 1 | SSP0011_PSI.cs:581 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-db9520bf | this.Load 외 1 | SSP0011_PSI.cs:581 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a2db8469 | this.Load 외 1 | SSP0011_PSI.cs:582 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-bdd13f9d | this.Load 외 1 | SSP0011_PSI.cs:585 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-af390273 | this.Load 외 1 | SSP0011_PSI.cs:588 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-62a373a2 | this.Load 외 1 | SSP0011_PSI.cs:588 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f52c2346 | this.Load 외 1 | SSP0011_PSI.cs:589 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-c85defd3 | this.Load 외 1 | SSP0011_PSI.cs:594 | if (pDivisionID != "EE") | VALUE_CLEAR | clbElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-dc407283 | this.Load 외 1 | SSP0011_PSI.cs:595 | if (pDivisionID != "EE") | STATE | clbElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-957c6fb8 | this.Load 외 1 | SSP0011_PSI.cs:599 | else of (pDivisionID != "EE") | STATE | clbElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SSP0011_PSI.SetChangedPeriod

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a4ae156 | (진입점 미연결) | SSP0011_PSI.cs:988 | if (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6601470c | (진입점 미연결) | SSP0011_PSI.cs:991 | else of (string.IsNullOrEmpty(strcboPlanDate)) | COMBO_DATA | Data.CallBizCommonData | ("PERIOD2_" + value, strcboPlanDate) ⇒ biz:CommonData.CommonDataList [code=PERIOD2_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-85ae4661 | (진입점 미연결) | SSP0011_PSI.cs:994 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-14d5c923 | (진입점 미연결) | SSP0011_PSI.cs:997 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-cbf9278f | (진입점 미연결) | SSP0011_PSI.cs:998 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0011_PSI.SetSpreadColumn

진입점: this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / this.chkSum.CheckedChanged [if (siMain != null)] / FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90f878a3 | this.Load 외 4 | SSP0011_PSI.cs:870 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-99bb10d3 | this.Load 외 4 | SSP0011_PSI.cs:874 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d2702ef0 | this.Load 외 4 | SSP0011_PSI.cs:879 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-524901e6 | this.Load 외 4 | SSP0011_PSI.cs:882 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-6a77783d | this.Load 외 4 | SSP0011_PSI.cs:886 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-696908b9 | this.Load 외 4 | SSP0011_PSI.cs:891 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f9d38ca2 | this.Load 외 4 | SSP0011_PSI.cs:894 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0011_PSI.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-87461aea | this.spdMain.CellDoubleClick | SSP0011_PSI.cs:489 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0011_PSI.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-987a9d3c | this.spdMain.TopChange | SSP0011_PSI.cs:449 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0011_PSI.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9ac750f1 | (진입점 미연결) | SSP0011_PSI.cs:911 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-20c27fda | (진입점 미연결) | SSP0011_PSI.cs:913 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-e7a253ed | (진입점 미연결) | SSP0011_PSI.cs:918 | if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days > 364) | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5e6afe03 | (진입점 미연결) | SSP0011_PSI.cs:924 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

