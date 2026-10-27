# AS-IS 액션 대조표 — DMF0039

> 원천: `Doc/asisfacts/screens/DMF0039/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 127행 · 메서드 17 · 종류 DATA_OP 44 · GRID_INIT 15 · ENDPOINT 10 · POPUP 9 · FLAG 9 · MESSAGE 6 · COMBO_DATA 6 · RETURN 5 · UI_MISC 5 · GRID_LOCK 4 · LIST_REBIND 4 · UI_PROP 3 · VALUE_SET 3 · GRID_BIND 1 · CALL_EXT 1 · GRID_SET 1 · GRID_COMBO 1 · ⚠ 의미 확인 필요 1


## DMF0039_ESS_Shipment_Priority.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-743db8fc | this.btnItemId.Click | DMF0039_ESS_Shipment_Priority.cs:676 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-a602f0eb | this.btnItemId.Click | DMF0039_ESS_Shipment_Priority.cs:679 |  | POPUP | popItem.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteId, sProject, sItemId, true) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bf10a45a | this.btnItemId.Click | DMF0039_ESS_Shipment_Priority.cs:680 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-696efef8 | this.btnItemId.Click | DMF0039_ESS_Shipment_Priority.cs:681 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-d861e41e | this.btnItemId.Click | DMF0039_ESS_Shipment_Priority.cs:683 |  | VALUE_SET | txtItemId.Text | popItem.ItemID | 컨트롤 값 설정 |  |  |  |

## DMF0039_ESS_Shipment_Priority.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5ab9722 | this.btnProject.Click | DMF0039_ESS_Shipment_Priority.cs:655 | if (cboDivision.SelectedValue.ToString() != "40") | POPUP | new DMF000_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-546a7fa1 | this.btnProject.Click | DMF0039_ESS_Shipment_Priority.cs:656 | if (cboDivision.SelectedValue.ToString() != "40") | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSite, sProject, true) | 팝업 초기화(인자 전달) |  |  |  |
| AC-632a92ae | this.btnProject.Click | DMF0039_ESS_Shipment_Priority.cs:657 | if (cboDivision.SelectedValue.ToString() != "40") | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39682377 | this.btnProject.Click | DMF0039_ESS_Shipment_Priority.cs:658 | if (cboDivision.SelectedValue.ToString() != "40") | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f3effeb8 | this.btnProject.Click | DMF0039_ESS_Shipment_Priority.cs:660 | if (cboDivision.SelectedValue.ToString() != "40") | VALUE_SET | txtProject.Text | popProject.ProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0039_ESS_Shipment_Priority.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-748f3d12 | this.Load | DMF0039_ESS_Shipment_Priority.cs:213 | if (cboDivision.SelectedIndex.ToString() == "-1") | MESSAGE | MessageHelper.GMessageBox | ("MSG00081", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a9065a89 | this.Load | DMF0039_ESS_Shipment_Priority.cs:214 | if (cboDivision.SelectedIndex.ToString() == "-1") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4296dccd | this.Load | DMF0039_ESS_Shipment_Priority.cs:219 | else of (cboDivision.SelectedIndex.ToString() == "-1") | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1af46b08 | this.Load | DMF0039_ESS_Shipment_Priority.cs:221 | else of (cboDivision.SelectedIndex.ToString() == "-1") | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMain) | 화면 필드/플래그 변경 |  |  |  |
| AC-fbeb3051 | this.Load | DMF0039_ESS_Shipment_Priority.cs:223 | else of (cboDivision.SelectedIndex.ToString() == "-1") | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5de420eb | this.Load | DMF0039_ESS_Shipment_Priority.cs:226 | else of (cboDivision.SelectedIndex.ToString() == "-1") | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0039_ESS_Shipment_Priority.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0b136c3d | Dispose | DMF0039_ESS_Shipment_Priority.Designer.cs:19 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0039_ESS_Shipment_Priority.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-042566ff | EditButton | DMF0039_ESS_Shipment_Priority.cs:276 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-45392cd5 | EditButton | DMF0039_ESS_Shipment_Priority.cs:277 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-46c371a9 | EditButton | DMF0039_ESS_Shipment_Priority.cs:279 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.MEASURE), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c04adb1 | EditButton | DMF0039_ESS_Shipment_Priority.cs:285 | if (this.fps != null) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)).ToStr… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MEASURE) + 1, iRow, siMain.GetMaxColumnIndex(), tr… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0039_ESS_Shipment_Priority.FindData

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4bbc45cf | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:305 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-980145ae | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:308 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-654f4163 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:309 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-de526bba | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:327 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-7f7f7744 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:328 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d38c740f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:332 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0039_GET_ESS_SHIPMENT_PRIORITY") ⇒ DM.DMF0039_GET_ESS_SHIPMENT_PRIORITY | 엔드포인트 요청 생성 |  |  |  |
| AC-4f2284f9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:334 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-b5cca141 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:335 | try ▸ lambda | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-ec84b89a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:336 | try ▸ lambda | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-3c3d78f9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:337 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-92f90338 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:338 | try ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | sProjectCode | 행/컬럼 값 대입 |  |  |  |
| AC-050ef684 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:339 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | sItemId | 행/컬럼 값 대입 |  |  |  |
| AC-a94644b5 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:340 | try ▸ lambda | DATA_OP | request.Parameters["p_sdate"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-211ecd97 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:341 | try ▸ lambda | DATA_OP | request.Parameters["p_edate"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-182d1ed6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:343 | try ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-a2dbdffb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:344 | try ▸ lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cb56e439 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:345 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb8cc99e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:349 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8c82cd7a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:351 | try ▸ lambda | RETURN | return response2.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7786721d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:355 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e493d45b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:356 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3be3b67c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:358 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f42645c0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:365 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dd606047 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:369 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-4defa1bd | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0039_ESS_Shipment_Priority.cs:371 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0039_ESS_Shipment_Priority.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd5313ad | this.Load | DMF0039_ESS_Shipment_Priority.cs:101 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-2f5e2a76 | this.Load | DMF0039_ESS_Shipment_Priority.cs:102 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0039_ESS_Shipment_Priority.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-006db575 | this.Load | DMF0039_ESS_Shipment_Priority.cs:635 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-cb9b4b23 | this.Load | DMF0039_ESS_Shipment_Priority.cs:636 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b504b07f | this.Load | DMF0039_ESS_Shipment_Priority.cs:637 |  | DATA_OP | request.Parameters["p_month"] | 6 | 행/컬럼 값 대입 |  |  |  |
| AC-7225a56a | this.Load | DMF0039_ESS_Shipment_Priority.cs:639 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-13f004bc | this.Load | DMF0039_ESS_Shipment_Priority.cs:642 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0039_ESS_Shipment_Priority.GetSpdTitle

진입점: this.Load [else of (cboDivision.SelectedIndex.ToString() == "-1")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14e86e77 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:616 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0039_GET_SPREAD_TITLE") ⇒ DM.DMF0039_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-fd673ebb | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:617 |  | DATA_OP | request.Parameters["p_start_dt"] | sStartDate | 행/컬럼 값 대입 |  |  |  |
| AC-7a4d9fa2 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:618 |  | DATA_OP | request.Parameters["p_end_dt"] | sEndDate | 행/컬럼 값 대입 |  |  |  |
| AC-b3b9ea97 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:619 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-fd3f1876 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:620 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-3dc7d8da | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:622 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d2e4b54c | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:626 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0039_ESS_Shipment_Priority.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-730ccbf8 | this.Load | DMF0039_ESS_Shipment_Priority.cs:114 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-4498b912 | this.Load | DMF0039_ESS_Shipment_Priority.cs:116 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-a74e6505 | this.Load | DMF0039_ESS_Shipment_Priority.cs:116 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-935543a3 | this.Load | DMF0039_ESS_Shipment_Priority.cs:122 | for (i <= dtDivision.Rows.Count - 1) ▸ if (dtDivision.Rows[i]["CODE"].ToString() == "40") | DATA_OP | dtDivision.Rows.RemoveAt | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-96cea75d | this.Load | DMF0039_ESS_Shipment_Priority.cs:127 | for (i <= dtDivision.Rows.Count - 1) ▸ if (dtDivision.Rows[i]["CODE"].ToString() == "81") | DATA_OP | dtDivision.Rows.RemoveAt | (i) | 데이터 객체 조작/조회 |  |  |  |
| AC-352fc562 | this.Load | DMF0039_ESS_Shipment_Priority.cs:130 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-00dd9c0b | this.Load | DMF0039_ESS_Shipment_Priority.cs:138 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4bdb69b6 | this.Load | DMF0039_ESS_Shipment_Priority.cs:146 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-90a99e87 | this.Load | DMF0039_ESS_Shipment_Priority.cs:154 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0039_ESS_Shipment_Priority.InitSpread

진입점: this.Load [else of (cboDivision.SelectedIndex.ToString() == "-1")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ae8cbcad | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:234 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 3, dsTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |
| AC-3ea4c604 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:239 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0039_ESS_Shipment_Priority.SaveData

진입점: SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a831224 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:377 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-04c39d7d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:404 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ for (i <= siMain.GetMaxRowInde… | CALL_EXT | siMain.GetForeColor | (i, j) | ⚠ 의미 확인 필요 |  |  |  |
| AC-dc6bdd8a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:424 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sDIVISION_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1c833fda | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:425 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sPROJECT_CODE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0b987cf | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:426 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sSCM_SITE_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-8e1ccbbb | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:427 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sEND_CUSTOMER.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-54df27d1 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:428 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sITEM_ID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb7b3971 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:429 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sMEASURE.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-269013dd | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:430 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sYYYYMMDD.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-4f8b487f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:431 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sPRIORITY.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-446f2986 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:432 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | sUSERID.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-344daa3c | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:437 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("DM.DMF0039_SAVE_MST_SHIPMENT_PRIORITY") ⇒ DM.DMF0039_SAVE_MST_SHIPMENT_PRIORITY | 엔드포인트 요청 생성 |  |  |  |
| AC-09ad3a44 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:438 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_DIVISION_ID"] | sDIVISION_ID | 행/컬럼 값 대입 |  |  |  |
| AC-759312d1 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:439 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_PROJECT_CODE"] | sPROJECT_CODE | 행/컬럼 값 대입 |  |  |  |
| AC-52379ef5 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:440 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_SCM_SITE_ID"] | sSCM_SITE_ID | 행/컬럼 값 대입 |  |  |  |
| AC-954c2f7b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:441 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_END_CUSTOMER"] | sEND_CUSTOMER | 행/컬럼 값 대입 |  |  |  |
| AC-774662ca | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:442 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_ITEM_ID"] | sITEM_ID | 행/컬럼 값 대입 |  |  |  |
| AC-98f53243 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:443 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_YYYYMMDD"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-ea27d51a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:444 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_MEASURE"] | sMEASURE | 행/컬럼 값 대입 |  |  |  |
| AC-32b17168 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:445 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_PRIORITY"] | sPRIORITY | 행/컬럼 값 대입 |  |  |  |
| AC-64728a10 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:446 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_CREATED_BY"] | sUSERID | 행/컬럼 값 대입 |  |  |  |
| AC-00859dd9 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:448 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4c2d206d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:452 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-316459d6 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:456 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-475234ea | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a739fbd1 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0039_ESS_Shipment_Priority.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0039_ESS_Shipment_Priority.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd5d2699 | this.Load | DMF0039_ESS_Shipment_Priority.cs:171 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-7dc51384 | this.Load | DMF0039_ESS_Shipment_Priority.cs:172 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-201e57a1 | this.Load | DMF0039_ESS_Shipment_Priority.cs:178 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-42daac57 | this.Load | DMF0039_ESS_Shipment_Priority.cs:178 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-dacb706c | this.Load | DMF0039_ESS_Shipment_Priority.cs:183 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-936b3c77 | this.Load | DMF0039_ESS_Shipment_Priority.cs:185 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-0c1779cf | this.Load | DMF0039_ESS_Shipment_Priority.cs:185 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-04537e22 | this.Load | DMF0039_ESS_Shipment_Priority.cs:190 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1b3a22f5 | this.Load | DMF0039_ESS_Shipment_Priority.cs:191 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-c0e77c25 | this.Load | DMF0039_ESS_Shipment_Priority.cs:193 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e5cc8673 | this.Load | DMF0039_ESS_Shipment_Priority.cs:193 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-18ad89df | this.Load | DMF0039_ESS_Shipment_Priority.cs:198 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-fc442836 | this.Load | DMF0039_ESS_Shipment_Priority.cs:199 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-d5776965 | this.Load | DMF0039_ESS_Shipment_Priority.cs:200 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-cd760025 | this.Load | DMF0039_ESS_Shipment_Priority.cs:202 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8e2d7c3 | this.Load | DMF0039_ESS_Shipment_Priority.cs:202 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0039_ESS_Shipment_Priority.SetSpreadHeaderSpan

진입점: this.Load [else of (cboDivision.SelectedIndex.ToString() == "-1")] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMain) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0c8c3b3 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:529 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 3, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dbdbbf60 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:537 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-55cd0dee | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:549 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-315f8c67 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:555 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-39be3416 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:563 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-92b736d2 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:575 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-aac76053 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:577 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-84c54bd3 | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:580 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.MEASURE) + 1) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-cc12b18d | this.Load [else of (cboDivision.SelectedIndex.ToString() == … 외 2 | DMF0039_ESS_Shipment_Priority.cs:582 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0039_ESS_Shipment_Priority.spdMain_Change

진입점: this.spdMain.Change

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6feb509f | this.spdMain.Change | DMF0039_ESS_Shipment_Priority.cs:702 | if (sText.Length > 2) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.ActiveColumnIndex, sText.Substring(0, 2)) | 그리드 값 설정 |  |  |  |

## DMF0039_ESS_Shipment_Priority.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dccf790f | this.spdMain.ComboSelChange | DMF0039_ESS_Shipment_Priority.cs:597 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(DefColumns.TEAM_ID) > 0) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-77a5a6c5 | this.spdMain.ComboSelChange | DMF0039_ESS_Shipment_Priority.cs:597 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(DefColumns.TEAM_ID) > 0) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-25baf210 | this.spdMain.ComboSelChange | DMF0039_ESS_Shipment_Priority.cs:598 | if (e.Column == siMain.GetColumnIndex(DefColumns.DIVISION_ID)) ▸ if (siMain.GetColumnIndex(DefColumns.TEAM_ID) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_ID), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0039_ESS_Shipment_Priority.spdMain_KeyUp

진입점: this.spdMain.KeyUp

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e145d2bb | this.spdMain.KeyUp | DMF0039_ESS_Shipment_Priority.cs:688 | if (siMain.GetColumnIndex(DefColumns.MEASURE) < siMain.ActiveColumnIndex) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

