# AS-IS 액션 대조표 — SSP0006

> 원천: `Doc/asisfacts/screens/SSP0006/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 351행 · 메서드 35 · 종류 GRID_INIT 92 · DATA_OP 62 · FLAG 27 · UI_PROP 23 · ENDPOINT 22 · GRID_SET 20 · RETURN 17 · POPUP 13 · VALUE_SET 11 · COMBO_DATA 11 · LIST_REBIND 11 · UI_MISC 10 · GRID_CLEAR 9 · MESSAGE 6 · CALL_EXT 5 · VALIDATE 3 · GRID_BIND 3 · GRID_LOCK 3 · STATE 2 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 5


## clsSCP0014_Search_Cond.Clear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bdd37e57 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1365 |  | FLAG | this.DIVISION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c964c83c | (진입점 미연결) | SSP0006_Plan_Problem.cs:1366 |  | FLAG | this.PLAN_START_YYYYMMDD | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4862d0b6 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1367 |  | FLAG | this.PLAN_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-647c3a0f | (진입점 미연결) | SSP0006_Plan_Problem.cs:1368 |  | FLAG | this.SEQ | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-dfb24c72 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1369 |  | FLAG | this.DEMAND_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b1362e4c | (진입점 미연결) | SSP0006_Plan_Problem.cs:1370 |  | FLAG | this.ITEM_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-a35552be | (진입점 미연결) | SSP0006_Plan_Problem.cs:1371 |  | FLAG | this.PROBLEM_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-c92afdf7 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1372 |  | FLAG | this.ELECTRODE_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SSP0006_Plan_Problem.btnItemId_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-483ccaf1 | this.btnItem_Id.Click | SSP0006_Plan_Problem.cs:648 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a5c55abc | this.btnItem_Id.Click | SSP0006_Plan_Problem.cs:649 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-17f8881a | this.btnItem_Id.Click | SSP0006_Plan_Problem.cs:650 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fbf5a573 | this.btnItem_Id.Click | SSP0006_Plan_Problem.cs:651 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3fd1fd9c | this.btnItem_Id.Click | SSP0006_Plan_Problem.cs:655 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0006_Plan_Problem.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fef0bf8e | (진입점 미연결) | SSP0006_Plan_Problem.cs:660 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SSP0011", SpdSheet.shtPeggingInfo, false) | 팝업/폼 생성 |  |  |  |
| AC-b4412eac | (진입점 미연결) | SSP0006_Plan_Problem.cs:661 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a613adf3 | (진입점 미연결) | SSP0006_Plan_Problem.cs:662 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-bd278048 | (진입점 미연결) | SSP0006_Plan_Problem.cs:665 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-3ab32c1e | (진입점 미연결) | SSP0006_Plan_Problem.cs:677 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SSP0006_Plan_Problem.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e98a1834 | this.btnProject.Click | SSP0006_Plan_Problem.cs:628 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f2462583 | this.btnProject.Click | SSP0006_Plan_Problem.cs:629 |  | POPUP | popProject.Form_Load | (true, sDivision, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c0bee47e | this.btnProject.Click | SSP0006_Plan_Problem.cs:630 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68325cd5 | this.btnProject.Click | SSP0006_Plan_Problem.cs:631 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-3a1ac13e | this.btnProject.Click | SSP0006_Plan_Problem.cs:636 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SSP0006_Plan_Problem.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a690eb7 | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1201 |  | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-f1fa0485 | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1201 |  | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b0662934 | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1202 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-515c6040 | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1204 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-03bb6b76 | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1206 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-ab6d69cf | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1208 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-e4cc7d37 | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1209 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-f26167fc | cboPlanDate.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1210 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0006_Plan_Problem.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a43889ac | cboPlanSeq.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1233 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-63b0e52f | cboPlanSeq.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1234 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-94603ddc | cboPlanSeq.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1235 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0006_Plan_Problem.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f648ac77 | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1218 |  | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-d4975a0b | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1218 |  | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f3d0afbb | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1219 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-002d0d89 | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1221 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-c91241a5 | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1225 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-6c3869ea | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1226 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-7c09b85d | cboPlanType.SelectedIndexChanged | SSP0006_Plan_Problem.cs:1227 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SSP0006_Plan_Problem.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a48ee8e | this.Load | SSP0006_Plan_Problem.cs:390 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2cf04bb2 | this.Load | SSP0006_Plan_Problem.cs:391 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-2dee442e | this.Load | SSP0006_Plan_Problem.cs:393 |  | GRID_INIT | this.AddSheet | (spdPeggingInfo, SpdSheet.shtPeggingInfo, SpdSheet.shtPeggingInfo, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1bbffe28 | this.Load | SSP0006_Plan_Problem.cs:394 |  | FLAG | siPeggingInfo | GetSheetInfo(spdPeggingInfo.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-6ea7401f | this.Load | SSP0006_Plan_Problem.cs:396 |  | GRID_INIT | this.AddSheet | (spdPlanProblem, SpdSheet.shtPlanProblem, SpdSheet.shtPlanProblem, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2ae36e57 | this.Load | SSP0006_Plan_Problem.cs:397 |  | FLAG | siPlanProblem | GetSheetInfo(spdPlanProblem.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-bdf457e1 | this.Load | SSP0006_Plan_Problem.cs:399 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0006_Plan_Problem.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5bed3df1 | this.Load | SSP0006_Plan_Problem.cs:229 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-2d835843 | this.Load | SSP0006_Plan_Problem.cs:230 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SSP0006_Plan_Problem.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9dc2abe9 | Dispose | SSP0006_Plan_Problem.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0006_Plan_Problem.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6cdab3a3 | EditButton | SSP0006_Plan_Problem.cs:617 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-02e05ba1 | EditButton | SSP0006_Plan_Problem.cs:618 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SSP0006_Plan_Problem.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0879d816 | FindButton | SSP0006_Plan_Problem.cs:812 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-46b8588f | FindButton | SSP0006_Plan_Problem.cs:812 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-01f54848 | FindButton | SSP0006_Plan_Problem.cs:813 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-67c6dbd3 | FindButton | SSP0006_Plan_Problem.cs:813 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-42476720 | FindButton | SSP0006_Plan_Problem.cs:855 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ec379de7 | FindButton | SSP0006_Plan_Problem.cs:857 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7fb4a2b3 | FindButton | SSP0006_Plan_Problem.cs:860 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-6ba22e91 | FindButton | SSP0006_Plan_Problem.cs:862 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9e3828c6 | FindButton | SSP0006_Plan_Problem.cs:864 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0006_GET_PROBLEM_REPORT") ⇒ SSP.SSP0006_GET_PROBLEM_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-acd15706 | FindButton | SSP0006_Plan_Problem.cs:865 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-757fdbaa | FindButton | SSP0006_Plan_Problem.cs:866 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e07ee12 | FindButton | SSP0006_Plan_Problem.cs:867 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-1de9b328 | FindButton | SSP0006_Plan_Problem.cs:868 | try ▸ lambda | DATA_OP | req.Parameters["p_sales_site_id"] | p_sales_site | 행/컬럼 값 대입 |  |  |  |
| AC-9fcc77a1 | FindButton | SSP0006_Plan_Problem.cs:869 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project | 행/컬럼 값 대입 |  |  |  |
| AC-fdb68648 | FindButton | SSP0006_Plan_Problem.cs:870 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-bae6d67a | FindButton | SSP0006_Plan_Problem.cs:871 | try ▸ lambda | DATA_OP | req.Parameters["p_problem_type"] | p_problem_type | 행/컬럼 값 대입 |  |  |  |
| AC-04cda72b | FindButton | SSP0006_Plan_Problem.cs:872 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b320d1d5 | FindButton | SSP0006_Plan_Problem.cs:873 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-58824283 | FindButton | SSP0006_Plan_Problem.cs:874 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-27843409 | FindButton | SSP0006_Plan_Problem.cs:875 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-89d9ddda | FindButton | SSP0006_Plan_Problem.cs:876 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-7187aa2a | FindButton | SSP0006_Plan_Problem.cs:877 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-83e36111 | FindButton | SSP0006_Plan_Problem.cs:879 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-920e4a4b | FindButton | SSP0006_Plan_Problem.cs:880 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c41b1ba6 | FindButton | SSP0006_Plan_Problem.cs:887 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4a786640 | FindButton | SSP0006_Plan_Problem.cs:889 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-40aa2c4a | FindButton | SSP0006_Plan_Problem.cs:890 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-b243c9b7 | FindButton | SSP0006_Plan_Problem.cs:892 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c66ce4de | FindButton | SSP0006_Plan_Problem.cs:896 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0) | FLAG | dtMainInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-212be51b | FindButton | SSP0006_Plan_Problem.cs:897 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0) | FLAG | dtMainInfo | dsBinding.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-42a055e2 | FindButton | SSP0006_Plan_Problem.cs:897 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0) | DATA_OP | dsBinding.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b064b6b | FindButton | SSP0006_Plan_Problem.cs:907 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f9ab694b | FindButton | SSP0006_Plan_Problem.cs:910 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-33457c2c | FindButton | SSP0006_Plan_Problem.cs:912 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-720e36c9 | FindButton | SSP0006_Plan_Problem.cs:913 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0006_Plan_Problem.FindData_PeggingInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce7eb381 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1002 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0e2a2bdf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1003 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f57764e4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1007 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-575e2bda | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1009 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c8a4ed1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1011 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0006_GET_PEGGING_INFO") ⇒ SSP.SSP0006_GET_PEGGING_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-ad06099a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1012 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1ac01d4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1013 | try ▸ lambda | DATA_OP | req.Parameters["p_Plan_Start_yyyymmdd"] | p_Plan_Start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-086c18ba | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1014 | try ▸ lambda | DATA_OP | req.Parameters["p_PLAN_TYPE"] | p_PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-9c085413 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1015 | try ▸ lambda | DATA_OP | req.Parameters["p_SEQ"] | p_SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-84f2b5c0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1016 | try ▸ lambda | DATA_OP | req.Parameters["p_ENG_DEMAND_ID"] | p_ENG_DEMAND_ID | 행/컬럼 값 대입 |  |  |  |
| AC-f6b0e193 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1017 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-01f9eb1c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1018 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-4397531d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1020 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-32e95432 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1021 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-dc750cc6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1028 | try | GRID_BIND | siPeggingInfo.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-93341535 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1029 | try | GRID_LOCK | siPeggingInfo.LockColumn | (0, siPeggingInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-75855251 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1030 | try | GRID_INIT | siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee91daaf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1033 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1537c157 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1036 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bd05ef0a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1039 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0006_Plan_Problem.FindData_PlanProblem

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d99086f5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1062 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-101d600c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1065 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-2cd7bb76 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1067 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1b1088c8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1069 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0006_GET_PLAN_PROBLEM") ⇒ SSP.SSP0006_GET_PLAN_PROBLEM | 엔드포인트 요청 생성 |  |  |  |
| AC-ebb855af | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1070 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-071a0202 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1071 | try ▸ lambda | DATA_OP | req.Parameters["p_Plan_Start_yyyymmdd"] | p_Plan_Start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4516ce73 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1072 | try ▸ lambda | DATA_OP | req.Parameters["p_PLAN_TYPE"] | p_PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-f3fd44ae | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1073 | try ▸ lambda | DATA_OP | req.Parameters["p_SEQ"] | p_SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-9a1f66ff | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1074 | try ▸ lambda | DATA_OP | req.Parameters["p_ENG_DEMAND_ID"] | p_ENG_DEMAND_ID | 행/컬럼 값 대입 |  |  |  |
| AC-0e147643 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1075 | try ▸ lambda | DATA_OP | req.Parameters["p_ProblemType"] | p_ProblemType | 행/컬럼 값 대입 |  |  |  |
| AC-3913df57 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1078 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-56186a62 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1079 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-ed05ec48 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1086 | try | GRID_BIND | siPlanProblem.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-137d7fd1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1087 | try | GRID_LOCK | siPlanProblem.LockColumn | (0, siPlanProblem.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c0cbf096 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1090 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-8790d875 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1093 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3bef4448 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:1098 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0006_Plan_Problem.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f68cfe50 | this.Load | SSP0006_Plan_Problem.cs:218 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0006_Plan_Problem.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6ae5f12 | this.Load | SSP0006_Plan_Problem.cs:1109 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-3e983d80 | this.Load | SSP0006_Plan_Problem.cs:1110 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-feebb4ea | this.Load | SSP0006_Plan_Problem.cs:1113 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0006_Plan_Problem.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e00f5357 | this.Load 외 1 | SSP0006_Plan_Problem.cs:1334 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-6c9a4653 | this.Load 외 1 | SSP0006_Plan_Problem.cs:1335 |  | DATA_OP | request.Parameters["p_from_date"] | p_from_date | 행/컬럼 값 대입 |  |  |  |
| AC-527c5912 | this.Load 외 1 | SSP0006_Plan_Problem.cs:1337 |  | DATA_OP | request.Parameters["p_offset_day"] | "112" | 행/컬럼 값 대입 |  |  |  |
| AC-45bc21c4 | this.Load 외 1 | SSP0006_Plan_Problem.cs:1338 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-97cd25e2 | this.Load 외 1 | SSP0006_Plan_Problem.cs:1339 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-509391fe | this.Load 외 1 | SSP0006_Plan_Problem.cs:1342 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0006_Plan_Problem.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a5db90a | (진입점 미연결) | SSP0006_Plan_Problem.cs:1295 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-7c664425 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1296 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c47e2bfc | (진입점 미연결) | SSP0006_Plan_Problem.cs:1298 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0006_Plan_Problem.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a449635d | (진입점 미연결) | SSP0006_Plan_Problem.cs:775 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-964f4ef8 | (진입점 미연결) | SSP0006_Plan_Problem.cs:776 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_PLAN_S… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7ff5ac4a | (진입점 미연결) | SSP0006_Plan_Problem.cs:780 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP_GET_LAST_PLAN_VERSION") ⇒ SSP.SSP_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-55fb99bc | (진입점 미연결) | SSP0006_Plan_Problem.cs:781 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-cc11c941 | (진입점 미연결) | SSP0006_Plan_Problem.cs:782 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-347fefee | (진입점 미연결) | SSP0006_Plan_Problem.cs:783 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f56d6041 | (진입점 미연결) | SSP0006_Plan_Problem.cs:795 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-d1f4f627 | (진입점 미연결) | SSP0006_Plan_Problem.cs:796 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-eb3b8322 | (진입점 미연결) | SSP0006_Plan_Problem.cs:797 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SSP0006_Plan_Problem.GetSalesSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0be07d5e | (진입점 미연결) | SSP0006_Plan_Problem.cs:380 |  | ENDPOINT | new FoxDataRequest | ("SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION") ⇒ SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-bbf33b51 | (진입점 미연결) | SSP0006_Plan_Problem.cs:381 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-74851c0b | (진입점 미연결) | SSP0006_Plan_Problem.cs:382 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db17d60a | (진입점 미연결) | SSP0006_Plan_Problem.cs:385 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0006_Plan_Problem.GetSearchCondition

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e189a8f6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:240 | if (dtMainInfo.Rows.Count > 0) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(row, siMain.GetColumnIndex(DefMain.SEQ))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-07ec627c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:251 | if (dtMainInfo.Rows.Count > 0) | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-cbfd45ec | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:255 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3f1112eb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:256 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac2bbe0d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:257 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-da1365ba | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:258 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-5323c066 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:260 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLANT_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-0d5889af | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:261 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("SALES_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-d78a747b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:262 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-0b057ca2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:263 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-7355939f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:264 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("DOM_EXP") | 데이터 객체 조작/조회 |  |  |  |
| AC-7a13a284 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:265 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-62d94456 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:266 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e5e9dd2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:267 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f63fd353 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:270 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.DIVISION_ID | dr["DIVISION_ID"].ToString() | 속성 DIVISION_ID 설정 |  |  |  |
| AC-14ab5179 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:271 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.PLAN_START_YYYYMMDD | dr["PLAN_START_YYYYMMDD"].ToString() | 속성 PLAN_START_YYYYMMDD 설정 |  |  |  |
| AC-edf1d454 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:272 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.PLAN_TYPE | dr["PLAN_TYPE"].ToString() | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-1d8249a0 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:273 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.SEQ | dr["SEQ"].ToString() | 속성 SEQ 설정 |  |  |  |
| AC-5f291939 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:274 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.DEMAND_ID | dr["ENG_DEMAND_ID"].ToString() | 속성 DEMAND_ID 설정 |  |  |  |
| AC-e328b9f6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:275 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.ITEM_ID | dr["ITEM_ID"].ToString() | 속성 ITEM_ID 설정 |  |  |  |
| AC-2ae98a14 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:276 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.PROBLEM_TYPE | dr["problem_type"].ToString() | 속성 PROBLEM_TYPE 설정 |  |  |  |
| AC-d2de36d1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:277 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.ELECTRODE_TYPE | dr["ELECTRODE_TYPE"].ToString() | 속성 ELECTRODE_TYPE 설정 |  |  |  |
| AC-fb065335 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SSP0006_Plan_Problem.cs:281 |  | RETURN | return _search; |  | 처리 중단/반환 |  |  |  |

## SSP0006_Plan_Problem.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ee99222 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1316 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-8625a265 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1317 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | drpPeriod.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-79e24a70 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1318 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | drpPeriod.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-1a40ee72 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1320 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a95f5105 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1320 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0006_Plan_Problem.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-81c120aa | this.Load | SSP0006_Plan_Problem.cs:347 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ee7a5cc2 | this.Load | SSP0006_Plan_Problem.cs:350 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-08b7351a | this.Load | SSP0006_Plan_Problem.cs:351 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-46968dd0 | this.Load | SSP0006_Plan_Problem.cs:352 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-73d3fb73 | this.Load | SSP0006_Plan_Problem.cs:355 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-3cde8656 | this.Load | SSP0006_Plan_Problem.cs:356 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPeggingInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-3844eced | this.Load | SSP0006_Plan_Problem.cs:357 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanProblem) | 데이터 객체 조작/조회 |  |  |  |
| AC-0c224ba3 | this.Load | SSP0006_Plan_Problem.cs:359 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a64bfdb | this.Load | SSP0006_Plan_Problem.cs:361 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-26cc5dd3 | this.Load | SSP0006_Plan_Problem.cs:363 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-018fcfdb | this.Load | SSP0006_Plan_Problem.cs:364 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-26b01f8b | this.Load | SSP0006_Plan_Problem.cs:366 |  | FLAG | dtProblem | Data.Common(Data.Type.LookupCommon, false, "PROBLEM_LIST") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-96c95be1 | this.Load | SSP0006_Plan_Problem.cs:366 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "PROBLEM_LIST") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6cd11465 | this.Load | SSP0006_Plan_Problem.cs:367 |  | LIST_REBIND | clsCtrl.setListBox | (dtProblem, clbProblem, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-33f39d57 | this.Load | SSP0006_Plan_Problem.cs:369 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrode, clbElectrode, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-695d7559 | this.Load | SSP0006_Plan_Problem.cs:373 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SSP0006_Plan_Problem.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc9a6cf3 | (진입점 미연결) | SSP0006_Plan_Problem.cs:411 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-2573740f | (진입점 미연결) | SSP0006_Plan_Problem.cs:412 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_ID, DefMain.DIVISION_ID, FPMerge.Restricted, 60, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-80569cd5 | (진입점 미연결) | SSP0006_Plan_Problem.cs:413 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DIVISION_NAME, DefMain.DIVISION_NAME, FPMerge.Restricted, 160, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69e04b79 | (진입점 미연결) | SSP0006_Plan_Problem.cs:414 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_START_YYYYMMDD, DefMain.PLAN_START_YYYYMMDD, FPMerge.Restricted, 60, fa… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0e8c51c1 | (진입점 미연결) | SSP0006_Plan_Problem.cs:415 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLAN_TYPE, DefMain.PLAN_TYPE, FPMerge.Restricted, 60, false, FPHAlign.Left, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-38de34be | (진입점 미연결) | SSP0006_Plan_Problem.cs:416 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SEQ, DefMain.SEQ, FPMerge.Restricted, 60, false, FPHAlign.Left, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98af0fba | (진입점 미연결) | SSP0006_Plan_Problem.cs:417 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLANT_SITE_ID, DefMain.PLANT_SITE_ID, FPMerge.Restricted, 60, false, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-66cce3d2 | (진입점 미연결) | SSP0006_Plan_Problem.cs:418 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PLANT_SITE_DESCRIPTION, DefMain.PLANT_SITE_DESCRIPTION, FPMerge.Restricted, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-98e4fb38 | (진입점 미연결) | SSP0006_Plan_Problem.cs:419 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SALES_SITE_ID, DefMain.SALES_SITE_ID, FPMerge.Restricted, 120, false, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ac2f62b6 | (진입점 미연결) | SSP0006_Plan_Problem.cs:420 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.SALES_SITE_DESCRIPTION, DefMain.SALES_SITE_DESCRIPTION, FPMerge.Restricted, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aa2ebfc6 | (진입점 미연결) | SSP0006_Plan_Problem.cs:421 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PROJECT_CODE, DefMain.PROJECT_CODE, FPMerge.Restricted, 80, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c0d39964 | (진입점 미연결) | SSP0006_Plan_Problem.cs:422 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ITEM_ID, DefMain.ITEM_ID, FPMerge.Restricted, 100, true, FPHAlign.Left, FPVA… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-604c8751 | (진입점 미연결) | SSP0006_Plan_Problem.cs:423 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.NICK_NAME, DefMain.NICK_NAME, FPMerge.Restricted, 90, true, FPHAlign.Left, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-488c811c | (진입점 미연결) | SSP0006_Plan_Problem.cs:425 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.DOM_EXP, DefMain.DOM_EXP, FPMerge.Restricted, 60, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7604e69d | (진입점 미연결) | SSP0006_Plan_Problem.cs:426 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.FCST_TYPE, DefMain.FCST_TYPE, FPMerge.Restricted, 60, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f68ecd9 | (진입점 미연결) | SSP0006_Plan_Problem.cs:427 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.PROBLEM_TYPE, DefMain.PROBLEM_TYPE, FPMerge.Restricted, 80, false, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-431e5175 | (진입점 미연결) | SSP0006_Plan_Problem.cs:428 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.AddTextColumn | (DefMainLabel.ENG_DEMAND_ID, DefMain.ENG_DEMAND_ID, FPMerge.Restricted, 60, false, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d42b50b9 | (진입점 미연결) | SSP0006_Plan_Problem.cs:431 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_ID), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-195db301 | (진입점 미연결) | SSP0006_Plan_Problem.cs:432 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DIVISION_NAME), 3, 1, 20, "Division", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-94cfebd8 | (진입점 미연결) | SSP0006_Plan_Problem.cs:433 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_START_YYYYMMDD), 3, 1, 20, "PLAN_START_YYYYMMDD", … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5eb6513f | (진입점 미연결) | SSP0006_Plan_Problem.cs:434 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLAN_TYPE), 3, 1, 20, "PLAN_TYPE", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3deed26 | (진입점 미연결) | SSP0006_Plan_Problem.cs:435 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SEQ), 3, 1, 20, "SEQ", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7e16e22f | (진입점 미연결) | SSP0006_Plan_Problem.cs:436 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ENG_DEMAND_ID), 3, 1, 20, "ENG_DEMAND_ID", FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1f2f346a | (진입점 미연결) | SSP0006_Plan_Problem.cs:437 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLANT_SITE_ID), 3, 1, 20, "Plant", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-72139f49 | (진입점 미연결) | SSP0006_Plan_Problem.cs:438 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PLANT_SITE_DESCRIPTION), 3, 1, 20, "Plant Site", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58eab2d2 | (진입점 미연결) | SSP0006_Plan_Problem.cs:439 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SALES_SITE_ID), 3, 1, 20, "Sales Site", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-49b82cb6 | (진입점 미연결) | SSP0006_Plan_Problem.cs:440 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.SALES_SITE_DESCRIPTION), 3, 1, 20, "Sales Site", FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2897b8c1 | (진입점 미연결) | SSP0006_Plan_Problem.cs:441 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PROJECT_CODE), 3, 1, 20, "Project", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82939da3 | (진입점 미연결) | SSP0006_Plan_Problem.cs:442 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.ITEM_ID), 3, 1, 20, "Model", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4afe9df | (진입점 미연결) | SSP0006_Plan_Problem.cs:443 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.NICK_NAME), 3, 1, 20, "Nick Name", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-40a93d3e | (진입점 미연결) | SSP0006_Plan_Problem.cs:444 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.DOM_EXP), 3, 1, 20, "DOM/EXP", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4380ebd9 | (진입점 미연결) | SSP0006_Plan_Problem.cs:445 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.FCST_TYPE), 3, 1, 20, "FCST Type", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9010e0b2 | (진입점 미연결) | SSP0006_Plan_Problem.cs:446 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, spdInfo.GetColumnIndex(DefMain.PROBLEM_TYPE), 3, 1, 20, "Problem", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e70fad14 | (진입점 미연결) | SSP0006_Plan_Problem.cs:455 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bf904e05 | (진입점 미연결) | SSP0006_Plan_Problem.cs:456 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-04fd6f5d | (진입점 미연결) | SSP0006_Plan_Problem.cs:459 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPeggingInfo) | 그리드 재구성/초기화 |  |  |  |
| AC-ff472a42 | (진입점 미연결) | SSP0006_Plan_Problem.cs:460 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2a0b6bb9 | (진입점 미연결) | SSP0006_Plan_Problem.cs:461 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.PEGGING_OPERATION, DefPegging.PEGGING_OPERATION, FPMerge.Restricted, 80, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a244a904 | (진입점 미연결) | SSP0006_Plan_Problem.cs:462 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.ITEM_ID, DefPegging.ITEM_ID, FPMerge.Restricted, 90, true, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0a141fb2 | (진입점 미연결) | SSP0006_Plan_Problem.cs:463 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.FROM_SITE, DefPegging.FROM_SITE, FPMerge.Restricted, 80, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9671ee9e | (진입점 미연결) | SSP0006_Plan_Problem.cs:464 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.TO_SITE, DefPegging.TO_SITE, FPMerge.Restricted, 80, true, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-91ef7ffa | (진입점 미연결) | SSP0006_Plan_Problem.cs:465 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddDateColumn | (DefPeggingLabel.DUE_DATE, DefPegging.DUE_DATE, FPMerge.Restricted, 75, true, FPHAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3c0e51f | (진입점 미연결) | SSP0006_Plan_Problem.cs:466 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddDateColumn | (DefPeggingLabel.PLAN_START_DATE, DefPegging.PLAN_START_DATE, FPMerge.Restricted, 75, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0c955fd9 | (진입점 미연결) | SSP0006_Plan_Problem.cs:467 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddDateColumn | (DefPeggingLabel.PLAN_END_DATE, DefPegging.PLAN_END_DATE, FPMerge.Restricted, 75, true, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-769f03c0 | (진입점 미연결) | SSP0006_Plan_Problem.cs:468 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.OPERATION_GROUP, DefPegging.OPERATION_GROUP, FPMerge.Restricted, 70, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7507d42b | (진입점 미연결) | SSP0006_Plan_Problem.cs:470 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.REQUIRED_QTY, DefPegging.REQUIRED_QTY, FPMerge.Restricted, 80, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee73d924 | (진입점 미연결) | SSP0006_Plan_Problem.cs:471 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddNumColumn | (DefPeggingLabel.PLANNED_QTY, DefPegging.PLANNED_QTY, FPMerge.Restricted, 60, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c3d1cc1d | (진입점 미연결) | SSP0006_Plan_Problem.cs:473 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddDateTextColumn | (DefPeggingLabel.LPST, DefPegging.LPST, FPMerge.Restricted, 75, true, FPHAlign.Center, FPV… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5f307e47 | (진입점 미연결) | SSP0006_Plan_Problem.cs:474 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.STOCK_PLAN_LOT_ID, DefPegging.STOCK_PLAN_LOT_ID, FPMerge.Restricted, 280,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8b88ca46 | (진입점 미연결) | SSP0006_Plan_Problem.cs:476 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.AddTextColumn | (DefPeggingLabel.PROBLEM_TYPE, DefPegging.PROBLEM_TYPE, FPMerge.Restricted, 70, false, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-889b6fef | (진입점 미연결) | SSP0006_Plan_Problem.cs:478 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9656a55c | (진입점 미연결) | SSP0006_Plan_Problem.cs:481 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlanProblem) | 그리드 재구성/초기화 |  |  |  |
| AC-1bacd796 | (진입점 미연결) | SSP0006_Plan_Problem.cs:482 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cfec9761 | (진입점 미연결) | SSP0006_Plan_Problem.cs:483 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddTextColumn | (DefPlanProblemLabel.PROBLEM_SEQ, DefPlanProblem.PROBLEM_SEQ, FPMerge.Restricted, 70, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9f3366e1 | (진입점 미연결) | SSP0006_Plan_Problem.cs:484 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddTextColumn | (DefPlanProblemLabel.ENG_PROBLEM_TYPE, DefPlanProblem.ENG_PROBLEM_TYPE, FPMerge.Restricted… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-901dda3f | (진입점 미연결) | SSP0006_Plan_Problem.cs:485 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddTextColumn | (DefPlanProblemLabel.ENG_PROBLEM_DESC, DefPlanProblem.ENG_PROBLEM_DESC, FPMerge.Restricted… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-88e27dde | (진입점 미연결) | SSP0006_Plan_Problem.cs:486 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddDateColumn | (DefPlanProblemLabel.REQUEST_TIME, DefPlanProblem.REQUEST_TIME, FPMerge.Restricted, 75, tr… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1ab422be | (진입점 미연결) | SSP0006_Plan_Problem.cs:487 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddDateColumn | (DefPlanProblemLabel.RESPONSE_TIME, DefPlanProblem.RESPONSE_TIME, FPMerge.Restricted, 75, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ee8e459c | (진입점 미연결) | SSP0006_Plan_Problem.cs:488 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.AddNumColumn | (DefPlanProblemLabel.PROBLEM_QTY, DefPlanProblem.PROBLEM_QTY, FPMerge.Restricted, 60, true… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-302f02a3 | (진입점 미연결) | SSP0006_Plan_Problem.cs:495 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0006_Plan_Problem.InitSpread_2

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-25b02abc | this.Load 외 3 | SSP0006_Plan_Problem.cs:289 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-9ad03f49 | this.Load 외 3 | SSP0006_Plan_Problem.cs:293 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-f79b8627 | this.Load 외 3 | SSP0006_Plan_Problem.cs:294 | if (spdInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.InitSpreadDateColumn | (spdInfo, drpPeriod.Text1, drpPeriod.Text2) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0f59b5e8 | this.Load 외 3 | SSP0006_Plan_Problem.cs:299 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1bd7de42 | this.Load 외 3 | SSP0006_Plan_Problem.cs:300 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1188c8ed | this.Load 외 3 | SSP0006_Plan_Problem.cs:304 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-57225626 | this.Load 외 3 | SSP0006_Plan_Problem.cs:305 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2c6dffc5 | this.Load 외 3 | SSP0006_Plan_Problem.cs:306 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-18f9b1b6 | this.Load 외 3 | SSP0006_Plan_Problem.cs:310 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-63b9567f | this.Load 외 3 | SSP0006_Plan_Problem.cs:311 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-1dac9feb | this.Load 외 3 | SSP0006_Plan_Problem.cs:312 | if (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7b9b51d7 | this.Load 외 3 | SSP0006_Plan_Problem.cs:317 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPeggingInfo) | 그리드 재구성/초기화 |  |  |  |
| AC-bdc64b15 | this.Load 외 3 | SSP0006_Plan_Problem.cs:319 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | siPeggingInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-fbe303aa | this.Load 외 3 | SSP0006_Plan_Problem.cs:321 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d39ee933 | this.Load 외 3 | SSP0006_Plan_Problem.cs:325 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | false | 그리드 속성/값 설정 |  |  |  |
| AC-2ace562c | this.Load 외 3 | SSP0006_Plan_Problem.cs:326 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-2493ad39 | this.Load 외 3 | SSP0006_Plan_Problem.cs:327 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-713f5c6c | this.Load 외 3 | SSP0006_Plan_Problem.cs:331 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | true | 그리드 속성/값 설정 |  |  |  |
| AC-15a9d517 | this.Load 외 3 | SSP0006_Plan_Problem.cs:332 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-c6a2b6b6 | this.Load 외 3 | SSP0006_Plan_Problem.cs:333 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ else of (pDivisionID != "EE") | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d073e151 | this.Load 외 3 | SSP0006_Plan_Problem.cs:337 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlanProblem) | 그리드 재구성/초기화 |  |  |  |
| AC-01fd1266 | this.Load 외 3 | SSP0006_Plan_Problem.cs:339 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | siPlanProblem.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-edadfa08 | this.Load 외 3 | SSP0006_Plan_Problem.cs:341 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SSP0006_Plan_Problem.InitSpreadDateColumn

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c283e987 | (진입점 미연결) | SSP0006_Plan_Problem.cs:531 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cd3de016 | (진입점 미연결) | SSP0006_Plan_Problem.cs:535 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d99171da | (진입점 미연결) | SSP0006_Plan_Problem.cs:536 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), 0, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5e35b921 | (진입점 미연결) | SSP0006_Plan_Problem.cs:540 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-9c5d8802 | (진입점 미연결) | SSP0006_Plan_Problem.cs:547 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a5d02e19 | (진입점 미연결) | SSP0006_Plan_Problem.cs:548 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7371e49f | (진입점 미연결) | SSP0006_Plan_Problem.cs:553 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-45b35fa8 | (진입점 미연결) | SSP0006_Plan_Problem.cs:554 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dc4b5a03 | (진입점 미연결) | SSP0006_Plan_Problem.cs:562 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7c3047d9 | (진입점 미연결) | SSP0006_Plan_Problem.cs:563 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-cad9d524 | (진입점 미연결) | SSP0006_Plan_Problem.cs:573 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-26ba3fbb | (진입점 미연결) | SSP0006_Plan_Problem.cs:574 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7af1a857 | (진입점 미연결) | SSP0006_Plan_Problem.cs:575 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f3b45935 | (진입점 미연결) | SSP0006_Plan_Problem.cs:576 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0006_Plan_Problem.PaintProblemCell

진입점: FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0802d9b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:929 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(i, siMain.GetColumnIndex(DefMain.SEQ))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-92615985 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:941 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-05bf2b23 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:942 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-7fc36575 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:943 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-481b2f7f | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:944 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-ce8b1adb | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:946 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PLANT_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-a9cebdef | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:947 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("SALES_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-4c741136 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:948 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-028c2793 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:949 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-49f8edb1 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:950 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("DOM_EXP") | 데이터 객체 조작/조회 |  |  |  |
| AC-b254329b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:951 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-5b7c1dbc | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:952 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-7bbf4644 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:970 | for (i < siMain.ActiveSheet.RowCount) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == divisi… | UI_PROP | cell.ForeColor | Color.Red | 속성 ForeColor 설정 |  |  |  |
| AC-84ed186d | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SSP0006_Plan_Problem.cs:973 | for (i < siMain.ActiveSheet.RowCount) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == divisi… | UI_PROP | cell.ForeColor | Color.Green | 속성 ForeColor 설정 |  |  |  |

## SSP0006_Plan_Problem.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-23e56fa0 | this.Load 외 1 | SSP0006_Plan_Problem.cs:718 | if (pDivisionID != "EE") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-beb91ea6 | this.Load 외 1 | SSP0006_Plan_Problem.cs:718 | if (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1c5ca08a | this.Load 외 1 | SSP0006_Plan_Problem.cs:719 | if (pDivisionID != "EE") | FLAG | dtSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-0f079b65 | this.Load 외 1 | SSP0006_Plan_Problem.cs:719 | if (pDivisionID != "EE") | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2c72d5f0 | this.Load 외 1 | SSP0006_Plan_Problem.cs:723 | else of (pDivisionID != "EE") | FLAG | dtPlantSiteByDivision | Data_SCP.Common(Data_SCP.Type.PlantSitePlanProblemSSP, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-0a44ce8f | this.Load 외 1 | SSP0006_Plan_Problem.cs:723 | else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSitePlanProblemSSP, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-814a7fcf | this.Load 외 1 | SSP0006_Plan_Problem.cs:724 | else of (pDivisionID != "EE") | FLAG | dtSalesSite | Data_SCP.Common(Data_SCP.Type.SalesSitePlanProblemSSP, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-00239abc | this.Load 외 1 | SSP0006_Plan_Problem.cs:724 | else of (pDivisionID != "EE") | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.SalesSitePlanProblemSSP, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd6cc631 | this.Load 외 1 | SSP0006_Plan_Problem.cs:728 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b077e945 | this.Load 외 1 | SSP0006_Plan_Problem.cs:732 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-76797d81 | this.Load 외 1 | SSP0006_Plan_Problem.cs:735 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanDate | Data.Common(Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-deaa7ccc | this.Load 외 1 | SSP0006_Plan_Problem.cs:735 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanDateShip, false, pDivisionID) ⇒ biz:CommonData.CommonDataList [code=PlanDateShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-59e967fa | this.Load 외 1 | SSP0006_Plan_Problem.cs:736 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6690a521 | this.Load 외 1 | SSP0006_Plan_Problem.cs:739 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanType | Data.Common(Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-06164045 | this.Load 외 1 | SSP0006_Plan_Problem.cs:739 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanTypeShip, false, pDivisionID, pPlanDate) ⇒ biz:CommonData.CommonDataList [code=PlanTypeShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d901b6a7 | this.Load 외 1 | SSP0006_Plan_Problem.cs:740 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7760bb6b | this.Load 외 1 | SSP0006_Plan_Problem.cs:743 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) ▸ if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-2a13b1ed | this.Load 외 1 | SSP0006_Plan_Problem.cs:746 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtPlanSeq | Data.Common(Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 화면 필드/플래그 변경 |  |  |  |
| AC-b3a86c92 | this.Load 외 1 | SSP0006_Plan_Problem.cs:746 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlanSeqShip, false, pDivisionID, pPlanDate, pPlanType) ⇒ biz:CommonData.CommonDataList [code=PlanSeqShip] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6382d0a8 | this.Load 외 1 | SSP0006_Plan_Problem.cs:747 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7232c990 | this.Load 외 1 | SSP0006_Plan_Problem.cs:752 | if (pDivisionID != "EE") | VALUE_CLEAR | clbElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-6ded6158 | this.Load 외 1 | SSP0006_Plan_Problem.cs:753 | if (pDivisionID != "EE") | STATE | clbElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-d6e75ce6 | this.Load 외 1 | SSP0006_Plan_Problem.cs:757 | else of (pDivisionID != "EE") | STATE | clbElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SSP0006_Plan_Problem.SetChangedPeriods

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8aa52003 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1302 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f7c2e91 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1304 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a87140f2 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1307 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-76cd1c47 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1308 | if (dt.Rows.Count > 0) | UI_PROP | drpPeriod.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SSP0006_Plan_Problem.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / cboBucketType.SelectedIndexChanged / chkSum.CheckedChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b36c370f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1126 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7a90e701 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1131 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-e738055b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1138 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-f35a5148 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1142 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-b55586e5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1147 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-d79d5f46 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1154 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b4338f3c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SSP0006_Plan_Problem.cs:1157 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0006_Plan_Problem.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efe48c1e | this.spdMain.CellDoubleClick | SSP0006_Plan_Problem.cs:1269 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e23c374d | this.spdMain.CellDoubleClick | SSP0006_Plan_Problem.cs:1279 | if (siMain.GetColumnTag(e.Column).IndexOf("D_") != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f887485 | this.spdMain.CellDoubleClick | SSP0006_Plan_Problem.cs:1284 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, e.Column).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61ed1754 | this.spdMain.CellDoubleClick | SSP0006_Plan_Problem.cs:1285 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | _search | GetSearchCondition(e.Row, e.Column) | 화면 필드/플래그 변경 |  |  |  |

## SSP0006_Plan_Problem.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ea225d4 | this.spdMain.TopChange | SSP0006_Plan_Problem.cs:698 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0006_Plan_Problem.SpdPeggingInfo_TopChange

진입점: this.spdPeggingInfo.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13fcc39a | this.spdPeggingInfo.TopChange | SSP0006_Plan_Problem.cs:691 |  | GRID_INIT | this.siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0006_Plan_Problem.SpdPlanProblem_TopChange

진입점: this.spdPlanProblem.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bc722eb | this.spdPlanProblem.TopChange | SSP0006_Plan_Problem.cs:684 |  | GRID_INIT | this.siPlanProblem.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0006_Plan_Problem.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-05e24808 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1174 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8f879ce | (진입점 미연결) | SSP0006_Plan_Problem.cs:1176 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-579086d2 | (진입점 미연결) | SSP0006_Plan_Problem.cs:1181 | if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days > 364) | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec63899e | (진입점 미연결) | SSP0006_Plan_Problem.cs:1187 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

