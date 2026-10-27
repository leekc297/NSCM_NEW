# AS-IS 액션 대조표 — SCP0014

> 원천: `Doc/asisfacts/screens/SCP0014/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 288행 · 메서드 40 · 종류 DATA_OP 65 · GRID_INIT 33 · UI_PROP 32 · FLAG 25 · ENDPOINT 19 · RETURN 16 · GRID_SET 15 · POPUP 13 · VALUE_SET 11 · UI_MISC 11 · CALL_EXT 9 · GRID_CLEAR 9 · LIST_REBIND 9 · MESSAGE 6 · VALIDATE 3 · GRID_BIND 3 · GRID_LOCK 3 · COMBO_DATA 2 · STATE 2 · THROW 1 · VALUE_CLEAR 1 · ⚠ 의미 확인 필요 9


## clsSCP0014_Search_Cond.Clear

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5d50d396 | (진입점 미연결) | SCP0014_Problem_Report.cs:1458 |  | FLAG | this.DIVISION_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-29bcf993 | (진입점 미연결) | SCP0014_Problem_Report.cs:1459 |  | FLAG | this.PLAN_START_YYYYMMDD | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-37c1ed4f | (진입점 미연결) | SCP0014_Problem_Report.cs:1460 |  | FLAG | this.PLAN_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-116bd510 | (진입점 미연결) | SCP0014_Problem_Report.cs:1461 |  | FLAG | this.SEQ | 0 | 화면 필드/플래그 변경 |  |  |  |
| AC-d98e5d7d | (진입점 미연결) | SCP0014_Problem_Report.cs:1462 |  | FLAG | this.DEMAND_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-4a76b714 | (진입점 미연결) | SCP0014_Problem_Report.cs:1463 |  | FLAG | this.ITEM_ID | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-b3584fad | (진입점 미연결) | SCP0014_Problem_Report.cs:1464 |  | FLAG | this.PROBLEM_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |
| AC-cf0d9296 | (진입점 미연결) | SCP0014_Problem_Report.cs:1465 |  | FLAG | this.ELECTRODE_TYPE | string.Empty | 화면 필드/플래그 변경 |  |  |  |

## SCP0014_Problem_Report.btnItemId_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8f60dbd | this.btnItem_Id.Click | SCP0014_Problem_Report.cs:641 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-6db7e81c | this.btnItem_Id.Click | SCP0014_Problem_Report.cs:646 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-ee870932 | this.btnItem_Id.Click | SCP0014_Problem_Report.cs:648 |  | POPUP | pop.Form_Load | (true, division, "", sItemId, this.Name.Substring(0, 7)) | 팝업 초기화(인자 전달) |  |  |  |
| AC-301011ee | this.btnItem_Id.Click | SCP0014_Problem_Report.cs:649 |  | UI_PROP | pop.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f0961de6 | this.btnItem_Id.Click | SCP0014_Problem_Report.cs:650 |  | POPUP | pop.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f20f0b3e | this.btnItem_Id.Click | SCP0014_Problem_Report.cs:656 | if (pop.selectedItemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0014_Problem_Report.btnMeasure_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98bc13df | (진입점 미연결) | SCP0014_Problem_Report.cs:661 |  | POPUP | new SCM0002_TitleSetForm_Popup | ("SCP0011", SpdSheet.shtPeggingInfo, false) | 팝업/폼 생성 |  |  |  |
| AC-f2b2b9f6 | (진입점 미연결) | SCP0014_Problem_Report.cs:662 |  | UI_PROP | frm.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-05883ee8 | (진입점 미연결) | SCP0014_Problem_Report.cs:663 |  | POPUP | frm.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-fe782405 | (진입점 미연결) | SCP0014_Problem_Report.cs:666 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | false | 속성 CanModelChange 설정 |  |  |  |
| AC-42675e12 | (진입점 미연결) | SCP0014_Problem_Report.cs:678 | if (frm.DialogResult == DialogResult.OK) | UI_PROP | this.CanModelChange | true | 속성 CanModelChange 설정 |  |  |  |

## SCP0014_Problem_Report.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b85de64 | this.btnProject.Click | SCP0014_Problem_Report.cs:623 |  | CALL_EXT | UIUtils.GetAllDivisionCheckedElectrode | (cboDivision) | ⚠ 의미 확인 필요 |  |  |  |
| AC-4c834110 | this.btnProject.Click | SCP0014_Problem_Report.cs:627 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-de574331 | this.btnProject.Click | SCP0014_Problem_Report.cs:628 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-face67f8 | this.btnProject.Click | SCP0014_Problem_Report.cs:629 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-35b15c8d | this.btnProject.Click | SCP0014_Problem_Report.cs:630 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-9fc69f5d | this.btnProject.Click | SCP0014_Problem_Report.cs:635 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCP0014_Problem_Report.CboPlanDate_SelectedIndexChanged

진입점: cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-045b7a2c | cboPlanDate.SelectedIndexChanged | SCP0014_Problem_Report.cs:1303 |  | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |
| AC-dfa6e85c | cboPlanDate.SelectedIndexChanged | SCP0014_Problem_Report.cs:1305 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-1021f415 | cboPlanDate.SelectedIndexChanged | SCP0014_Problem_Report.cs:1306 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-ea73a645 | cboPlanDate.SelectedIndexChanged | SCP0014_Problem_Report.cs:1307 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-79393c18 | cboPlanDate.SelectedIndexChanged | SCP0014_Problem_Report.cs:1308 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0014_Problem_Report.CboPlanSeq_SelectedIndexChanged

진입점: cboPlanSeq.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2253c092 | cboPlanSeq.SelectedIndexChanged | SCP0014_Problem_Report.cs:1324 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-04e9f7fc | cboPlanSeq.SelectedIndexChanged | SCP0014_Problem_Report.cs:1325 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-6d38de19 | cboPlanSeq.SelectedIndexChanged | SCP0014_Problem_Report.cs:1326 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0014_Problem_Report.CboPlanType_SelectedIndexChanged

진입점: cboPlanType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-876e315d | cboPlanType.SelectedIndexChanged | SCP0014_Problem_Report.cs:1314 |  | VALUE_SET | cboPlanSeq.SelectedIndex | 0 | 컨트롤 값 설정 |  |  |  |
| AC-02e2c1d5 | cboPlanType.SelectedIndexChanged | SCP0014_Problem_Report.cs:1317 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |
| AC-5dee2986 | cboPlanType.SelectedIndexChanged | SCP0014_Problem_Report.cs:1318 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPeggingInfo) | 그리드 데이터/선택 비움 |  |  |  |
| AC-f1bd8c31 | cboPlanType.SelectedIndexChanged | SCP0014_Problem_Report.cs:1319 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdPlanProblem) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0014_Problem_Report.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dee92c88 | this.Load | SCP0014_Problem_Report.cs:390 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-7e088b04 | this.Load | SCP0014_Problem_Report.cs:391 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-714a9b1e | this.Load | SCP0014_Problem_Report.cs:393 |  | GRID_INIT | this.AddSheet | (spdPeggingInfo, SpdSheet.shtPeggingInfo, SpdSheet.shtPeggingInfo, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-240bccbb | this.Load | SCP0014_Problem_Report.cs:394 |  | FLAG | siPeggingInfo | GetSheetInfo(spdPeggingInfo.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-321c70f2 | this.Load | SCP0014_Problem_Report.cs:396 |  | GRID_INIT | this.AddSheet | (spdPlanProblem, SpdSheet.shtPlanProblem, SpdSheet.shtPlanProblem, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-2f3c2bc1 | this.Load | SCP0014_Problem_Report.cs:397 |  | FLAG | siPlanProblem | GetSheetInfo(spdPlanProblem.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-86988011 | this.Load | SCP0014_Problem_Report.cs:399 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0014_Problem_Report.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1eb97738 | this.Load | SCP0014_Problem_Report.cs:246 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |
| AC-3f1af46e | this.Load | SCP0014_Problem_Report.cs:247 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Daily | 컨트롤 값 설정 |  |  |  |

## SCP0014_Problem_Report.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9d7e9bfb | Dispose | SCP0014_Problem_Report.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0014_Problem_Report.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b096ac66 | EditButton | SCP0014_Problem_Report.cs:617 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-36036db9 | EditButton | SCP0014_Problem_Report.cs:618 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0014_Problem_Report.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-814e4039 | ExcelButton | SCP0014_Problem_Report.cs:711 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-4c720dc6 | ExcelButton | SCP0014_Problem_Report.cs:712 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-cf3a95e6 | ExcelButton | SCP0014_Problem_Report.cs:713 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-b641f535 | ExcelButton | SCP0014_Problem_Report.cs:714 |  | UI_PROP | exportOption.AmendNullToZero | true | 속성 AmendNullToZero 설정 |  |  |  |
| AC-5f530170 | ExcelButton | SCP0014_Problem_Report.cs:715 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-cde08ec5 | ExcelButton | SCP0014_Problem_Report.cs:717 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-2b10f7be | ExcelButton | SCP0014_Problem_Report.cs:718 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-fd933347 | ExcelButton | SCP0014_Problem_Report.cs:720 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,###;[red]-#,###" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-e85dd224 | ExcelButton | SCP0014_Problem_Report.cs:725 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-67b30c63 | ExcelButton | SCP0014_Problem_Report.cs:730 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-0617716c | ExcelButton | SCP0014_Problem_Report.cs:734 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0014_Problem_Report.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4be60f15 | FindButton | SCP0014_Problem_Report.cs:915 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8167cf3a | FindButton | SCP0014_Problem_Report.cs:915 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-52b3f30d | FindButton | SCP0014_Problem_Report.cs:916 |  | VALIDATE | DateUtil.Check_PeriodDate | (dCalendar) | 프레임워크 검증 |  |  |  |
| AC-d182e7c0 | FindButton | SCP0014_Problem_Report.cs:916 | if (!DateUtil.Check_PeriodDate(dCalendar)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b67d45bf | FindButton | SCP0014_Problem_Report.cs:954 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-0747a6c0 | FindButton | SCP0014_Problem_Report.cs:956 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9e1796ed | FindButton | SCP0014_Problem_Report.cs:959 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-076e0929 | FindButton | SCP0014_Problem_Report.cs:961 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d569a695 | FindButton | SCP0014_Problem_Report.cs:963 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0014_GET_PROBLEM_REPORT") ⇒ SCP.SCP0014_GET_PROBLEM_REPORT | 엔드포인트 요청 생성 |  |  |  |
| AC-e874dee2 | FindButton | SCP0014_Problem_Report.cs:964 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bc364f64 | FindButton | SCP0014_Problem_Report.cs:965 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ef87215a | FindButton | SCP0014_Problem_Report.cs:966 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site | 행/컬럼 값 대입 |  |  |  |
| AC-eff58b60 | FindButton | SCP0014_Problem_Report.cs:967 | try ▸ lambda | DATA_OP | req.Parameters["p_sales_site_id"] | p_sales_site | 행/컬럼 값 대입 |  |  |  |
| AC-6d1a2943 | FindButton | SCP0014_Problem_Report.cs:968 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | p_project | 행/컬럼 값 대입 |  |  |  |
| AC-4112fd6c | FindButton | SCP0014_Problem_Report.cs:969 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-1decf1bd | FindButton | SCP0014_Problem_Report.cs:970 | try ▸ lambda | DATA_OP | req.Parameters["p_problem_type"] | p_problem_type | 행/컬럼 값 대입 |  |  |  |
| AC-ed7e6f10 | FindButton | SCP0014_Problem_Report.cs:971 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ec7a2b59 | FindButton | SCP0014_Problem_Report.cs:972 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ae190135 | FindButton | SCP0014_Problem_Report.cs:973 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_start_yyyymmdd"] | p_plan_start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-c0b74702 | FindButton | SCP0014_Problem_Report.cs:974 | try ▸ lambda | DATA_OP | req.Parameters["p_plan_type"] | p_plan_type | 행/컬럼 값 대입 |  |  |  |
| AC-a8bb6187 | FindButton | SCP0014_Problem_Report.cs:975 | try ▸ lambda | DATA_OP | req.Parameters["p_seq"] | p_seq | 행/컬럼 값 대입 |  |  |  |
| AC-bfc8c70d | FindButton | SCP0014_Problem_Report.cs:977 | try ▸ lambda | DATA_OP | req.Parameters["p_electrodeType"] | p_electrodeType | 행/컬럼 값 대입 |  |  |  |
| AC-24e321f0 | FindButton | SCP0014_Problem_Report.cs:979 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-83598651 | FindButton | SCP0014_Problem_Report.cs:980 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-52c41e8e | FindButton | SCP0014_Problem_Report.cs:987 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4eee2cb1 | FindButton | SCP0014_Problem_Report.cs:989 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2a14c26e | FindButton | SCP0014_Problem_Report.cs:990 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6f2e51db | FindButton | SCP0014_Problem_Report.cs:992 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e22b3225 | FindButton | SCP0014_Problem_Report.cs:996 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0) | FLAG | dtMainInfo | new DataTable() | 화면 필드/플래그 변경 |  |  |  |
| AC-32f93403 | FindButton | SCP0014_Problem_Report.cs:997 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0) | FLAG | dtMainInfo | dsBinding.Tables[1].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-cd8f34d8 | FindButton | SCP0014_Problem_Report.cs:997 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0) | DATA_OP | dsBinding.Tables[1].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6eb6ec48 | FindButton | SCP0014_Problem_Report.cs:1007 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-3c64fc38 | FindButton | SCP0014_Problem_Report.cs:1010 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2bb215b8 | FindButton | SCP0014_Problem_Report.cs:1012 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cccfbb73 | FindButton | SCP0014_Problem_Report.cs:1013 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0014_Problem_Report.FindData_PeggingInfo

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-891e42fc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1104 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7e7b2c67 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1105 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-7b253f79 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1109 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-33190b5c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1111 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65dd9e1f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1113 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0014_GET_PEGGING_INFO") ⇒ SCP.SCP0014_GET_PEGGING_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-46761478 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1114 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c49bc583 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1115 | try ▸ lambda | DATA_OP | req.Parameters["p_Plan_Start_yyyymmdd"] | p_Plan_Start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-4d577ae3 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1116 | try ▸ lambda | DATA_OP | req.Parameters["p_PLAN_TYPE"] | p_PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-18cee564 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1117 | try ▸ lambda | DATA_OP | req.Parameters["p_SEQ"] | p_SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-8d3b003b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1118 | try ▸ lambda | DATA_OP | req.Parameters["p_ENG_DEMAND_ID"] | p_ENG_DEMAND_ID | 행/컬럼 값 대입 |  |  |  |
| AC-85b63f3b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1119 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-ab0ce0ec | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1120 | try ▸ lambda | DATA_OP | req.Parameters["p_electrode_type"] | p_electrode_type | 행/컬럼 값 대입 |  |  |  |
| AC-715ecce4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1122 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4840f6e6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1123 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-428960dc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1130 | try | GRID_BIND | siPeggingInfo.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-cdd76793 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1131 | try | GRID_LOCK | siPeggingInfo.LockColumn | (0, siPeggingInfo.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-eabbc8d5 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1132 | try | GRID_INIT | siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-884a0d4e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1135 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e780f539 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1138 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e19a2a95 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1141 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0014_Problem_Report.FindData_PlanProblem

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d1e4254c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1164 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a0e2e7a4 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1167 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-94805af1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1169 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-91b0ce5b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1171 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0014_GET_PLAN_PROBLEM") ⇒ SCP.SCP0014_GET_PLAN_PROBLEM | 엔드포인트 요청 생성 |  |  |  |
| AC-0f6e19c2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1172 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-967dbd6f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1173 | try ▸ lambda | DATA_OP | req.Parameters["p_Plan_Start_yyyymmdd"] | p_Plan_Start_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-60ca685a | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1174 | try ▸ lambda | DATA_OP | req.Parameters["p_PLAN_TYPE"] | p_PLAN_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-48911f94 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1175 | try ▸ lambda | DATA_OP | req.Parameters["p_SEQ"] | p_SEQ | 행/컬럼 값 대입 |  |  |  |
| AC-937bf10f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1176 | try ▸ lambda | DATA_OP | req.Parameters["p_ENG_DEMAND_ID"] | p_ENG_DEMAND_ID | 행/컬럼 값 대입 |  |  |  |
| AC-fa1e0533 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1177 | try ▸ lambda | DATA_OP | req.Parameters["p_ProblemType"] | p_ProblemType | 행/컬럼 값 대입 |  |  |  |
| AC-3bcb9afb | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1180 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d276cdb1 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1181 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-34be2642 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1188 | try | GRID_BIND | siPlanProblem.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-4a9e89e7 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1189 | try | GRID_LOCK | siPlanProblem.LockColumn | (0, siPlanProblem.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f28255bf | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1192 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7fe3c1f9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1195 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f057931e | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:1198 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0014_Problem_Report.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d02876a | this.Load | SCP0014_Problem_Report.cs:235 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0014_Problem_Report.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fdef8a79 | this.Load | SCP0014_Problem_Report.cs:1211 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-bd0703c8 | this.Load | SCP0014_Problem_Report.cs:1212 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f6bb3966 | this.Load | SCP0014_Problem_Report.cs:1215 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0014_Problem_Report.GetDayRange

진입점: this.Load / cboPlanDate.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-04b8a487 | this.Load 외 1 | SCP0014_Problem_Report.cs:1433 |  | CALL_EXT | DateUtil.GetDayRange | (cboDivision.ControlValues, cboBucketType.ControlValues, cboPlanDate.ControlValues) | ⚠ 의미 확인 필요 |  |  |  |
| AC-a1d0ea29 | this.Load 외 1 | SCP0014_Problem_Report.cs:1435 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0014_Problem_Report.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbb4afa1 | (진입점 미연결) | SCP0014_Problem_Report.cs:1389 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-cc4db23e | (진입점 미연결) | SCP0014_Problem_Report.cs:1390 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9ccf23b8 | (진입점 미연결) | SCP0014_Problem_Report.cs:1392 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0014_Problem_Report.GetLastPlanVersion

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8976fe80 | (진입점 미연결) | SCP0014_Problem_Report.cs:882 | try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0011_GET_LAST_PLAN_VERSION") ⇒ SCP.SCP0011_GET_LAST_PLAN_VERSION | 엔드포인트 요청 생성 |  |  |  |
| AC-ecd1012b | (진입점 미연결) | SCP0014_Problem_Report.cs:884 | try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-a85eeece | (진입점 미연결) | SCP0014_Problem_Report.cs:885 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8a2c1cba | (진입점 미연결) | SCP0014_Problem_Report.cs:896 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanDate.SelectedValue | PLAN_START_YYYYMMDD | 컨트롤 값 설정 |  |  |  |
| AC-bb539d74 | (진입점 미연결) | SCP0014_Problem_Report.cs:897 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedValue | PLAN_TYPE | 컨트롤 값 설정 |  |  |  |
| AC-f1e96ee3 | (진입점 미연결) | SCP0014_Problem_Report.cs:898 | try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) | VALUE_SET | cboPlanSeq.SelectedValue | PLAN_SEQ | 컨트롤 값 설정 |  |  |  |

## SCP0014_Problem_Report.GetSalesSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a5f4fa2 | (진입점 미연결) | SCP0014_Problem_Report.cs:380 |  | ENDPOINT | new FoxDataRequest | ("SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION") ⇒ SCM_SYS.SCM_SYS_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-a6856144 | (진입점 미연결) | SCP0014_Problem_Report.cs:381 |  | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-6d4cb7a9 | (진입점 미연결) | SCP0014_Problem_Report.cs:382 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6eb77339 | (진입점 미연결) | SCP0014_Problem_Report.cs:385 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0014_Problem_Report.GetSearchCondition

진입점: this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51f650bc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:257 | if (dtMainInfo.Rows.Count > 0) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(row, siMain.GetColumnIndex(DefMain.SEQ))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-df5e81d2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:268 | if (dtMainInfo.Rows.Count > 0) | CALL_EXT | _search.Clear | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-701b3190 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:272 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6f1cc3a9 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:273 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-040b4e72 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:274 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-1643e91c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:275 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-39b80cb6 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:277 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PLANT_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-5cac81a2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:278 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("SALES_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-31f5d26b | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:279 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-81ab4738 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:280 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-6d6af8f8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:281 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("DOM_EXP") | 데이터 객체 조작/조회 |  |  |  |
| AC-526e6e52 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:282 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-cb6b6533 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:283 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("yyyymmdd") | 데이터 객체 조작/조회 |  |  |  |
| AC-4913e5e2 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:284 | if (dtMainInfo.Rows.Count > 0) ▸ lambda | DATA_OP | a.Field | ("ELECTRODE_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-a6621fed | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:286 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.DIVISION_ID | dr["DIVISION_ID"].ToString() | 속성 DIVISION_ID 설정 |  |  |  |
| AC-c7ca0610 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:287 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.PLAN_START_YYYYMMDD | dr["PLAN_START_YYYYMMDD"].ToString() | 속성 PLAN_START_YYYYMMDD 설정 |  |  |  |
| AC-82786f92 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:288 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.PLAN_TYPE | dr["PLAN_TYPE"].ToString() | 속성 PLAN_TYPE 설정 |  |  |  |
| AC-11e4e88f | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:289 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.SEQ | dr["SEQ"].ToString() | 속성 SEQ 설정 |  |  |  |
| AC-e1215ff8 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:290 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.DEMAND_ID | dr["ENG_DEMAND_ID"].ToString() | 속성 DEMAND_ID 설정 |  |  |  |
| AC-538bd8cc | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:291 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.ITEM_ID | dr["ITEM_ID"].ToString() | 속성 ITEM_ID 설정 |  |  |  |
| AC-a9ddf76c | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:292 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.PROBLEM_TYPE | dr["problem_type"].ToString() | 속성 PROBLEM_TYPE 설정 |  |  |  |
| AC-7b0c1b1d | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:293 | if (dtMainInfo.Rows.Count > 0) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == division_id &… | UI_PROP | _search.ELECTRODE_TYPE | dr["ELECTRODE_TYPE"].ToString() | 속성 ELECTRODE_TYPE 설정 |  |  |  |
| AC-cafd0f23 | this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >… | SCP0014_Problem_Report.cs:297 |  | RETURN | return _search; |  | 처리 중단/반환 |  |  |  |

## SCP0014_Problem_Report.GetSpdTitle

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4afe3ead | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:1410 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-3d46cc54 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:1411 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | dCalendar.Text1.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-a3334ce1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:1412 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | dCalendar.Text2.Replace("-", "") | 행/컬럼 값 대입 |  |  |  |
| AC-6d0334fe | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:1414 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-2ba68817 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:1414 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0014_Problem_Report.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0734b9ad | this.Load | SCP0014_Problem_Report.cs:347 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-a18c7b55 | this.Load | SCP0014_Problem_Report.cs:350 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-5a5cc55e | this.Load | SCP0014_Problem_Report.cs:351 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPeggingInfo) | 데이터 객체 조작/조회 |  |  |  |
| AC-ac6c817c | this.Load | SCP0014_Problem_Report.cs:352 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtPlanProblem) | 데이터 객체 조작/조회 |  |  |  |
| AC-6843cea2 | this.Load | SCP0014_Problem_Report.cs:355 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanDate) | 데이터 객체 조작/조회 |  |  |  |
| AC-32954306 | this.Load | SCP0014_Problem_Report.cs:356 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanType) | 데이터 객체 조작/조회 |  |  |  |
| AC-b6c18b9f | this.Load | SCP0014_Problem_Report.cs:357 |  | DATA_OP | this.ConditionNotUseList.Add | (cboPlanSeq) | 데이터 객체 조작/조회 |  |  |  |
| AC-c94e52ae | this.Load | SCP0014_Problem_Report.cs:359 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-a0999390 | this.Load | SCP0014_Problem_Report.cs:361 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f2abae84 | this.Load | SCP0014_Problem_Report.cs:363 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-8fe43a13 | this.Load | SCP0014_Problem_Report.cs:364 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b2bd2b69 | this.Load | SCP0014_Problem_Report.cs:366 |  | FLAG | dtProblem | Data.Common(Data.Type.LookupCommon, false, "PROBLEM_LIST") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-354bf63f | this.Load | SCP0014_Problem_Report.cs:366 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "PROBLEM_LIST") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3d445297 | this.Load | SCP0014_Problem_Report.cs:367 |  | LIST_REBIND | clsCtrl.setListBox | (dtProblem, clbProblem, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-45336ad0 | this.Load | SCP0014_Problem_Report.cs:369 |  | LIST_REBIND | clsCtrl.setListBox | (dtElectrodeType, cboElectrode, false) | 목록 컨트롤 재구성 |  |  |  |
| AC-39304506 | this.Load | SCP0014_Problem_Report.cs:373 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0014_Problem_Report.InitSpread_2

진입점: this.Load / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0)] / FindButton / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-878508a9 | this.Load 외 3 | SCP0014_Problem_Report.cs:303 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-cbab7231 | this.Load 외 3 | SCP0014_Problem_Report.cs:307 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.SetSheetHeaderColumn | (spdInfo, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-25567fcc | this.Load 외 3 | SCP0014_Problem_Report.cs:314 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20326d2b | this.Load 외 3 | SCP0014_Problem_Report.cs:315 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-563b7664 | this.Load 외 3 | SCP0014_Problem_Report.cs:317 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visible | this._isEE | 그리드 속성/값 설정 |  |  |  |
| AC-d586495f | this.Load 외 3 | SCP0014_Problem_Report.cs:318 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | this._isEE | 그리드 속성/값 설정 |  |  |  |
| AC-62418253 | this.Load 외 3 | SCP0014_Problem_Report.cs:319 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | spdInfo.ActiveSheet.Columns[siMain.GetColumnIndex("ELECTRODE_TYPE")].Visible | this._isEE | 그리드 속성/값 설정 |  |  |  |
| AC-7251155b | this.Load 외 3 | SCP0014_Problem_Report.cs:323 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPeggingInfo) | 그리드 재구성/초기화 |  |  |  |
| AC-920fdca1 | this.Load 외 3 | SCP0014_Problem_Report.cs:325 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | siPeggingInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-8bde7685 | this.Load 외 3 | SCP0014_Problem_Report.cs:328 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_SET | siPeggingInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("PLANNED_QTY")].MergePolicy | FarPoint.Win.Spread.Model.MergePolicy.None | 그리드 속성/값 설정 |  |  |  |
| AC-61cd13f8 | this.Load 외 3 | SCP0014_Problem_Report.cs:330 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9c2abc1b | this.Load 외 3 | SCP0014_Problem_Report.cs:332 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_FROM_DIVISION_ID")].Visib… | this._isEE | 그리드 속성/값 설정 |  |  |  |
| AC-eb805a2f | this.Load 외 3 | SCP0014_Problem_Report.cs:333 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ORIGIN_TO_DIVISION_ID")].Visible | this._isEE | 그리드 속성/값 설정 |  |  |  |
| AC-f12d006b | this.Load 외 3 | SCP0014_Problem_Report.cs:334 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ if (spdInfo.SheetName == SpdSheet.shtPeggingInfo) | GRID_SET | spdInfo.ActiveSheet.Columns[siPeggingInfo.GetColumnIndex("ELECTRODE_TYPE")].Visible | this._isEE | 그리드 속성/값 설정 |  |  |  |
| AC-e08278b6 | this.Load 외 3 | SCP0014_Problem_Report.cs:337 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtPlanProblem) | 그리드 재구성/초기화 |  |  |  |
| AC-fdd44e27 | this.Load 외 3 | SCP0014_Problem_Report.cs:339 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | siPlanProblem.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-c8260989 | this.Load 외 3 | SCP0014_Problem_Report.cs:341 | else of (spdInfo.SheetName == SpdSheet.shtMain) ▸ else of (spdInfo.SheetName == SpdSheet.shtPeggingInfo) ▸ if (spdInfo.SheetName == SpdSheet… | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0014_Problem_Report.InitSpreadDateColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / FindButton [if (spdInfo.SheetName == SpdSheet.shtMain)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7456ba09 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:532 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13cb4ab8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:533 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-08291ba5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:537 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b586c04e | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:538 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-a5892267 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:542 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-c9345c12 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:549 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb37aef4 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:550 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0217de83 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:555 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2b9aeec | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:556 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8bae83a7 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:564 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-09f7c0ac | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:565 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fa676d6c | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:575 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dece2167 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:576 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d1da1645 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:577 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-be205212 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 3 | SCP0014_Problem_Report.cs:578 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0014_Problem_Report.PaintProblemCell

진입점: FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBinding.Tables[0].Rows.Count > 0) ▸ if (dsBinding.Tables[1].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-664fbd03 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1030 | for (i < siMain.ActiveSheet.RowCount) | CALL_EXT | Convert.ToInt64 | (siMain.GetValue(i, siMain.GetColumnIndex(DefMain.SEQ))) | ⚠ 의미 확인 필요 |  |  |  |
| AC-40fd69d6 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1041 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("DIVISION_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a8f64fa | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1042 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PLAN_START_YYYYMMDD") | 데이터 객체 조작/조회 |  |  |  |
| AC-957776e3 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1043 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PLAN_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-f6fc2fd4 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1044 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("SEQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-2ae322b6 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1046 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PLANT_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-8b13798b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1047 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("SALES_SITE_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-707397d9 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1048 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("PROJECT_CODE") | 데이터 객체 조작/조회 |  |  |  |
| AC-dfc46421 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1049 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("ITEM_ID") | 데이터 객체 조작/조회 |  |  |  |
| AC-13b347c8 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1050 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("DOM_EXP") | 데이터 객체 조작/조회 |  |  |  |
| AC-c5cc700b | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1051 | for (i < siMain.ActiveSheet.RowCount) ▸ lambda | DATA_OP | a.Field | ("FCST_TYPE") | 데이터 객체 조작/조회 |  |  |  |
| AC-bb90ebb7 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1068 | for (i < siMain.ActiveSheet.RowCount) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == divisi… | UI_PROP | cell.ForeColor | Color.Red | 속성 ForeColor 설정 |  |  |  |
| AC-94783d7d | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1070 | for (i < siMain.ActiveSheet.RowCount) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == divisi… | UI_PROP | cell.Font | new Font("Tahoma", 9f) | 속성 Font 설정 |  |  |  |
| AC-d429a7b0 | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1072 | for (i < siMain.ActiveSheet.RowCount) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == divisi… | UI_PROP | cell.Font | new Font(xFont, FontStyle.Bold) | 속성 Font 설정 |  |  |  |
| AC-2dc6f88f | FindButton [try ▸ if (dsBinding.Tables.Count > 0 && dsBindin… | SCP0014_Problem_Report.cs:1076 | for (i < siMain.ActiveSheet.RowCount) ▸ foreach (DataRow dr in dtMainInfo.AsEnumerable().Where(a => a.Field<string>("DIVISION_ID") == divisi… | UI_PROP | cell.ForeColor | ControlColor.OrangeColor | 속성 ForeColor 설정 |  |  |  |

## SCP0014_Problem_Report.RefreshPlanDate

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f3270290 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0014_Problem_Report.cs:807 |  | FLAG | dtPlanDate | DBUtils.Filter(dtPlanDateAll, "DIVISION_ID = '" + this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-8294920c | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0014_Problem_Report.cs:807 |  | DATA_OP | DBUtils.Filter | (dtPlanDateAll, "DIVISION_ID = '" + this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-9f7a8bd3 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 1 | SCP0014_Problem_Report.cs:809 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanDate, cboPlanDate, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0014_Problem_Report.RefreshPlanSeq

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanType.SelectedIndexChanged / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ff618e90 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:829 |  | CALL_EXT | DBUtils.GetAndFilterString | (new List<string>() { "DIVISION_ID", "PLANDATE", "PLANTYPE" }, new List<string>() { pDivsi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-29aca0ac | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:830 |  | FLAG | dtPlanSeq | DBUtils.Filter(dtPlanSeqAll, filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ea88d221 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:830 |  | DATA_OP | DBUtils.Filter | (dtPlanSeqAll, filter) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-21cdee65 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:833 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanSeq, cboPlanSeq, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0014_Problem_Report.RefreshPlantSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9f62db5 | this.Load 외 1 | SCP0014_Problem_Report.cs:779 | if (this._isEE) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionEEAll, "DIVISION_ID = '" + this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-96142550 | this.Load 외 1 | SCP0014_Problem_Report.cs:779 | if (this._isEE) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionEEAll, "DIVISION_ID = '" + this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f567bccd | this.Load 외 1 | SCP0014_Problem_Report.cs:783 | else of (this._isEE) | FLAG | dtPlantSiteByDivision | DBUtils.Filter(dtPlantSiteByDivisionAll, "DIVISION_ID = '" + this._division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-19615afe | this.Load 외 1 | SCP0014_Problem_Report.cs:783 | else of (this._isEE) | DATA_OP | DBUtils.Filter | (dtPlantSiteByDivisionAll, "DIVISION_ID = '" + this._division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0014_Problem_Report.RefreshPlanType

진입점: this.Load [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))] / cboPlanDate.SelectedIndexChanged / cboDivision.SelectedIndexChanged [if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL"))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cc52d4ec | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:817 |  | FLAG | dtPlanType | DBUtils.Filter(dtPlanTypeAll, "DIVISION_ID = '" + pDivsion + "' AND PLANDATE = '" + pPlanD… | 화면 필드/플래그 변경 |  |  |  |
| AC-f1a3b992 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:817 |  | DATA_OP | DBUtils.Filter | (dtPlanTypeAll, "DIVISION_ID = '" + pDivsion + "' AND PLANDATE = '" + pPlanDate + "'", tru… | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-3e049a19 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:819 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanType, cboPlanType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fda1c793 | this.Load [if (cboDivision.ControlValues != null && !cboDivi… 외 2 | SCP0014_Problem_Report.cs:822 | if (dtPlanType.Rows.Count > 0) | VALUE_SET | cboPlanType.SelectedIndex | dtPlanType.Rows.Count - 1 | 컨트롤 값 설정 |  |  |  |

## SCP0014_Problem_Report.RefreshSalesSite

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-26c7e116 | this.Load 외 1 | SCP0014_Problem_Report.cs:793 | if (this._isEE) | FLAG | dtSalesSite | DBUtils.Filter(dtSalesSiteEEAll, "DIVISION_ID = '" + pDivsion + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-f73f8607 | this.Load 외 1 | SCP0014_Problem_Report.cs:793 | if (this._isEE) | DATA_OP | DBUtils.Filter | (dtSalesSiteEEAll, "DIVISION_ID = '" + pDivsion + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cd9e3819 | this.Load 외 1 | SCP0014_Problem_Report.cs:799 | else of (this._isEE) | FLAG | dtSalesSite | DBUtils.Filter(dtSalesSiteAll, "DIVISION_ID = '" + pDivsion + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-a3f3a580 | this.Load 외 1 | SCP0014_Problem_Report.cs:799 | else of (this._isEE) | DATA_OP | DBUtils.Filter | (dtSalesSiteAll, "DIVISION_ID = '" + pDivsion + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |

## SCP0014_Problem_Report.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-992f7fe1 | this.Load 외 1 | SCP0014_Problem_Report.cs:846 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bad836d2 | this.Load 외 1 | SCP0014_Problem_Report.cs:850 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9e403f42 | this.Load 외 1 | SCP0014_Problem_Report.cs:861 | if (!this._isEE) | VALUE_CLEAR | cboElectrode.ControlValues | "" | 컨트롤 값 비움 |  |  |  |
| AC-d531b2ea | this.Load 외 1 | SCP0014_Problem_Report.cs:862 | if (!this._isEE) | STATE | cboElectrode.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-af068023 | this.Load 외 1 | SCP0014_Problem_Report.cs:866 | else of (!this._isEE) | STATE | cboElectrode.Enabled | true | 컨트롤 상태 Enabled |  |  |  |

## SCP0014_Problem_Report.SetChangedPeriods

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f111773 | (진입점 미연결) | SCP0014_Problem_Report.cs:1396 |  | COMBO_DATA | Data.CallBizCommonData | ("PERIOD_" + value) ⇒ biz:CommonData.CommonDataList [code=PERIOD_{p:value}] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-26a1c9b8 | (진입점 미연결) | SCP0014_Problem_Report.cs:1398 | if (dt == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-577f8246 | (진입점 미연결) | SCP0014_Problem_Report.cs:1401 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text1 | dt.Rows[0]["FROM_VALUE"].ToString() | 속성 Text1 설정 |  |  |  |
| AC-2b006ec1 | (진입점 미연결) | SCP0014_Problem_Report.cs:1402 | if (dt.Rows.Count > 0) | UI_PROP | dCalendar.Text2 | dt.Rows[0]["TO_VALUE"].ToString() | 속성 Text2 설정 |  |  |  |

## SCP0014_Problem_Report.SetSpreadColumn

진입점: this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] / this.spdMain.CellDoubleClick [if (!e.ColumnHeader && e.Row >= 0) ▸ if (spdInfo.SheetName == SpdSheet.shtMain)] / cboBucketType.SelectedIndexChanged / chkSum.CheckedChanged / FindButton [try] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d880cc3b | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1229 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-13c506d8 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1234 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-2c6c060f | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1241 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-76d763b1 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1245 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-d2f9c581 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1250 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-c8fb6da9 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1257 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b5ff21f5 | this.Load [if (spdInfo.SheetName == SpdSheet.shtMain)] 외 5 | SCP0014_Problem_Report.cs:1260 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0014_Problem_Report.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a21be3ce | this.spdMain.CellDoubleClick | SCP0014_Problem_Report.cs:1360 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |
| AC-59261b5f | this.spdMain.CellDoubleClick | SCP0014_Problem_Report.cs:1371 | if (siMain.GetColumnTag(e.Column).IndexOf("D_") != 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5f9ac895 | this.spdMain.CellDoubleClick | SCP0014_Problem_Report.cs:1378 | if (!e.ColumnHeader && e.Row >= 0) ▸ if (string.IsNullOrWhiteSpace(siMain.GetValue(e.Row, e.Column).ToString())) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3f57e24b | this.spdMain.CellDoubleClick | SCP0014_Problem_Report.cs:1379 | if (!e.ColumnHeader && e.Row >= 0) | FLAG | _search | GetSearchCondition(e.Row, e.Column) | 화면 필드/플래그 변경 |  |  |  |

## SCP0014_Problem_Report.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31096ff3 | this.spdMain.TopChange | SCP0014_Problem_Report.cs:699 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0014_Problem_Report.SpdPeggingInfo_TopChange

진입점: this.spdPeggingInfo.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70a7950d | this.spdPeggingInfo.TopChange | SCP0014_Problem_Report.cs:692 |  | GRID_INIT | this.siPeggingInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0014_Problem_Report.SpdPlanProblem_TopChange

진입점: this.spdPlanProblem.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-934fa302 | this.spdPlanProblem.TopChange | SCP0014_Problem_Report.cs:685 |  | GRID_INIT | this.siPlanProblem.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0014_Problem_Report.ValidateUserInput

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a709b17 | (진입점 미연결) | SCP0014_Problem_Report.cs:1277 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00171") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-755a35b8 | (진입점 미연결) | SCP0014_Problem_Report.cs:1279 | if (action_name.Equals("CHK_PERIOD")) ▸ if (DateTime.Compare(dtPlanStart, dtFrom) > 0) | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |
| AC-5961bc40 | (진입점 미연결) | SCP0014_Problem_Report.cs:1284 | if (action_name.Equals("CHK_PERIOD")) ▸ if (diff.Days > 364) | MESSAGE | MessageHelper.GMessageBox | ("MSG00172", new object[] { 364 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b63881dc | (진입점 미연결) | SCP0014_Problem_Report.cs:1290 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

