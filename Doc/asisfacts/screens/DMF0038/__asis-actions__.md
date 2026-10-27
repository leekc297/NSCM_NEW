# AS-IS 액션 대조표 — DMF0038

> 원천: `Doc/asisfacts/screens/DMF0038/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 149행 · 메서드 17 · 종류 DATA_OP 40 · FLAG 18 · COMBO_DATA 13 · LIST_REBIND 13 · POPUP 11 · GRID_INIT 11 · GRID_LOCK 10 · ENDPOINT 10 · UI_MISC 5 · VALUE_SET 4 · MESSAGE 4 · UI_PROP 3 · RETURN 3 · STATE 2 · VALUE_CLEAR 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## DMF0038_EOL.btnCutOff_Click

진입점: this.btnCutOff.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-691cabf5 | this.btnCutOff.Click | DMF0038_EOL.cs:691 |  | POPUP | new DMF0000_EOL_BasicMngPopup | () | 팝업/폼 생성 |  |  |  |
| AC-4ab9bb58 | this.btnCutOff.Click | DMF0038_EOL.cs:692 |  | POPUP | popBasicMng.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject, sItemID) | 팝업 초기화(인자 전달) |  |  |  |
| AC-bbbc468e | this.btnCutOff.Click | DMF0038_EOL.cs:694 |  | UI_PROP | popBasicMng.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-37f2dec2 | this.btnCutOff.Click | DMF0038_EOL.cs:695 |  | POPUP | popBasicMng.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## DMF0038_EOL.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b384b4e4 | this.btnItemId.Click | DMF0038_EOL.cs:731 |  | POPUP | new DM0002_ItembyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-b00af8f2 | this.btnItemId.Click | DMF0038_EOL.cs:733 |  | POPUP | popItem.Form_Load | (true, sdivision, sTeam, sEndCustomer, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-be9f188c | this.btnItemId.Click | DMF0038_EOL.cs:734 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-6c060287 | this.btnItemId.Click | DMF0038_EOL.cs:735 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-72c9a223 | this.btnItemId.Click | DMF0038_EOL.cs:741 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## DMF0038_EOL.btnProject_Click

진입점: this.btnProject.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-22d17661 | this.btnProject.Click | DMF0038_EOL.cs:708 |  | POPUP | new SCM0002_ProjectbyDivisionPopupEx | () | 팝업/폼 생성 |  |  |  |
| AC-36e4eda5 | this.btnProject.Click | DMF0038_EOL.cs:710 |  | POPUP | popProject.Form_Load | (true, sDivision, sTeam, sEndCustomer, sScmSiteID, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-394606fd | this.btnProject.Click | DMF0038_EOL.cs:711 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7228021d | this.btnProject.Click | DMF0038_EOL.cs:712 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-025d0212 | this.btnProject.Click | DMF0038_EOL.cs:718 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## DMF0038_EOL.cboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-595243f9 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:751 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-0301b3b8 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:751 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5111c1e3 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:752 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-af3db448 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:752 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a93a066 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:753 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-46e9b439 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:760 | if (cboDivision.ControlValues == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-c4bd4396 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:760 | if (cboDivision.ControlValues == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-810387f6 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:761 | if (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-1b3a18c4 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:763 | if (cboDivision.ControlValues == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ef1cd61a | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:763 | if (cboDivision.ControlValues == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b479c38a | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:764 | if (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-50bbda03 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:768 | if (cboDivision.ControlValues == "40") | STATE | lblProject.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-ba5a96d8 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:772 | else of (cboDivision.ControlValues == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-13b1d3aa | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:772 | else of (cboDivision.ControlValues == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-29427d6a | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:773 | else of (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-74554a9d | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:775 | else of (cboDivision.ControlValues == "40") | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-25d98056 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:776 | else of (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-05c05098 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:780 | else of (cboDivision.ControlValues == "40") | STATE | lblProject.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-c8f8384d | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:783 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d72a2d54 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:783 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a9e05dcb | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:784 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b38a813 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:786 |  | VALUE_SET | txtProject.Text | txtItemId.Text = "" | 컨트롤 값 설정 |  |  |  |
| AC-1bcf7037 | cboDivision.SelectedIndexChanged | DMF0038_EOL.cs:786 |  | VALUE_CLEAR | txtItemId.Text | "" | 컨트롤 값 비움 |  |  |  |

## DMF0038_EOL.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-14f5615d | this.Load | DMF0038_EOL.cs:202 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-1b48742f | this.Load | DMF0038_EOL.cs:203 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-eeae1b90 | this.Load | DMF0038_EOL.cs:204 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0038_EOL.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a7ac7099 | Dispose | DMF0038_EOL.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0038_EOL.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-caf26745 | EditButton | DMF0038_EOL.cs:248 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-840ff76d | EditButton | DMF0038_EOL.cs:249 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-a52748bb | EditButton | DMF0038_EOL.cs:251 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-3012f642 | EditButton | DMF0038_EOL.cs:252 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EOL_STATUS), siMain.GetColumnIndex(DefColumns.EOL_STATUS… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2c673d03 | EditButton | DMF0038_EOL.cs:253 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EOL_A), siMain.GetColumnIndex(DefColumns.EOL_A), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-15666a83 | EditButton | DMF0038_EOL.cs:254 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EOL_B), siMain.GetColumnIndex(DefColumns.EOL_B), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcb7cf3c | EditButton | DMF0038_EOL.cs:255 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.EOL_C), siMain.GetColumnIndex(DefColumns.EOL_C), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-02eba7d5 | EditButton | DMF0038_EOL.cs:256 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.PERSON5), siMain.GetColumnIndex(DefColumns.PERSON5), tru… | 그리드 편집 잠금/해제 |  |  |  |
| AC-026f2d0f | EditButton | DMF0038_EOL.cs:257 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATED_BY), siMain.GetColumnIndex(DefColumns.LAST_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-24b0219d | EditButton | DMF0038_EOL.cs:258 | if (this.fps != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.LAST_UPDATE_DATE), siMain.GetColumnIndex(DefColumns.LAST… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0038_EOL.FindData

진입점: FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1a2c0cd3 | FindButton 외 1 | DMF0038_EOL.cs:273 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-65ab0045 | FindButton 외 1 | DMF0038_EOL.cs:274 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-83d889d7 | FindButton 외 1 | DMF0038_EOL.cs:276 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-ec1cb520 | FindButton 외 1 | DMF0038_EOL.cs:295 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0038_GET_DM_MST_EOL_DATA") ⇒ DM.DMF0038_GET_DM_MST_EOL_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-a20041e1 | FindButton 외 1 | DMF0038_EOL.cs:299 |  | DATA_OP | request.Parameters["p_Division_id"] | p_Division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c4591229 | FindButton 외 1 | DMF0038_EOL.cs:300 |  | DATA_OP | request.Parameters["p_TeamId"] | p_TeamId | 행/컬럼 값 대입 |  |  |  |
| AC-4f73a303 | FindButton 외 1 | DMF0038_EOL.cs:301 |  | DATA_OP | request.Parameters["p_Customer"] | p_Customer | 행/컬럼 값 대입 |  |  |  |
| AC-ee150861 | FindButton 외 1 | DMF0038_EOL.cs:302 |  | DATA_OP | request.Parameters["p_SalesSite"] | p_SalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-99360075 | FindButton 외 1 | DMF0038_EOL.cs:303 |  | DATA_OP | request.Parameters["p_BizType"] | p_BizType | 행/컬럼 값 대입 |  |  |  |
| AC-21fbdcf5 | FindButton 외 1 | DMF0038_EOL.cs:304 |  | DATA_OP | request.Parameters["p_Project"] | p_Project | 행/컬럼 값 대입 |  |  |  |
| AC-719be54f | FindButton 외 1 | DMF0038_EOL.cs:305 |  | DATA_OP | request.Parameters["p_ItemId"] | p_ItemId | 행/컬럼 값 대입 |  |  |  |
| AC-d60a76a8 | FindButton 외 1 | DMF0038_EOL.cs:306 |  | DATA_OP | request.Parameters["p_SDate"] | p_SDate | 행/컬럼 값 대입 |  |  |  |
| AC-702413cc | FindButton 외 1 | DMF0038_EOL.cs:307 |  | DATA_OP | request.Parameters["p_EDate"] | p_EDate | 행/컬럼 값 대입 |  |  |  |
| AC-2a503138 | FindButton 외 1 | DMF0038_EOL.cs:309 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a1830491 | FindButton 외 1 | DMF0038_EOL.cs:315 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-3b0f5605 | FindButton 외 1 | DMF0038_EOL.cs:316 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-bcdad320 | FindButton 외 1 | DMF0038_EOL.cs:318 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-53ef7aff | FindButton 외 1 | DMF0038_EOL.cs:319 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6b026d93 | FindButton 외 1 | DMF0038_EOL.cs:322 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0038_EOL.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f4f4a7e4 | this.Load | DMF0038_EOL.cs:143 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-652b48b7 | this.Load | DMF0038_EOL.cs:144 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0038_EOL.GetBizTypebyDivision

진입점: this.Load [else of (cboDivision.ControlValues == "40")] / cboDivision.SelectedIndexChanged [else of (cboDivision.ControlValues == "40")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17e587d6 | this.Load [else of (cboDivision.ControlValues == "40")] 외 1 | DMF0038_EOL.cs:572 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION") ⇒ SCM.SCM0001_GET_BIZ_TYPE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-c7a617bc | this.Load [else of (cboDivision.ControlValues == "40")] 외 1 | DMF0038_EOL.cs:573 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-0ea8520c | this.Load [else of (cboDivision.ControlValues == "40")] 외 1 | DMF0038_EOL.cs:574 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ab2ebae | this.Load [else of (cboDivision.ControlValues == "40")] 외 1 | DMF0038_EOL.cs:577 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0038_EOL.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-698abd46 | this.Load | DMF0038_EOL.cs:586 |  | ENDPOINT | new FoxDataRequest | ("DM.PR_GET_DAY_RANGE") ⇒ DM.PR_GET_DAY_RANGE | 엔드포인트 요청 생성 |  |  |  |
| AC-093141ce | this.Load | DMF0038_EOL.cs:587 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-f86d0e2f | this.Load | DMF0038_EOL.cs:588 |  | DATA_OP | request.Parameters["p_month"] | 7 | 행/컬럼 값 대입 |  |  |  |
| AC-d4ac00fb | this.Load | DMF0038_EOL.cs:590 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0d0599a6 | this.Load | DMF0038_EOL.cs:593 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## DMF0038_EOL.GetSpdTitle

진입점: this.Load / cboDivision.SelectedIndexChanged / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c0a1bda | this.Load 외 3 | DMF0038_EOL.cs:557 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0038_GET_SPREAD_TITLE") ⇒ DM.DMF0038_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-1e4710c8 | this.Load 외 3 | DMF0038_EOL.cs:558 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-0636ff0f | this.Load 외 3 | DMF0038_EOL.cs:560 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cb616c45 | this.Load 외 3 | DMF0038_EOL.cs:563 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## DMF0038_EOL.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-01e6fbf1 | this.Load | DMF0038_EOL.cs:161 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e7b61fe9 | this.Load | DMF0038_EOL.cs:161 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bf7231b1 | this.Load | DMF0038_EOL.cs:162 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5564be98 | this.Load | DMF0038_EOL.cs:166 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-ddd1e2cb | this.Load | DMF0038_EOL.cs:166 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1442c97c | this.Load | DMF0038_EOL.cs:167 |  | FLAG | dtTeamSpr | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-4cb95027 | this.Load | DMF0038_EOL.cs:167 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-58144222 | this.Load | DMF0038_EOL.cs:168 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-812e1370 | this.Load | DMF0038_EOL.cs:175 | if (cboDivision.ControlValues == "40") | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoC… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-a396a0bc | this.Load | DMF0038_EOL.cs:175 | if (cboDivision.ControlValues == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, "", clbTeam.ControlValues, UserInfoContext.Curr… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-da875781 | this.Load | DMF0038_EOL.cs:176 | if (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-caa750fe | this.Load | DMF0038_EOL.cs:178 | if (cboDivision.ControlValues == "40") | FLAG | dtBizType | Data.Common(Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 화면 필드/플래그 변경 |  |  |  |
| AC-cd8747b3 | this.Load | DMF0038_EOL.cs:178 | if (cboDivision.ControlValues == "40") | COMBO_DATA | Data.Common | (Data.Type.DM_BIZ_TYPE, false, "", "", "", "") ⇒ biz:CommonData.CommonDataList [code=DM_BIZ_TYPE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54589cb8 | this.Load | DMF0038_EOL.cs:179 | if (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-251dbc7b | this.Load | DMF0038_EOL.cs:185 | else of (cboDivision.ControlValues == "40") | FLAG | dtCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-71d9a0a6 | this.Load | DMF0038_EOL.cs:185 | else of (cboDivision.ControlValues == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-23bae235 | this.Load | DMF0038_EOL.cs:186 | else of (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-290f4ec3 | this.Load | DMF0038_EOL.cs:188 | else of (cboDivision.ControlValues == "40") | FLAG | dtBizType | GetBizTypebyDivision(cboDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-14f90b6d | this.Load | DMF0038_EOL.cs:189 | else of (cboDivision.ControlValues == "40") | LIST_REBIND | clsCtrl.setListBox | (dtBizType, clbBizType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-02259632 | this.Load | DMF0038_EOL.cs:194 |  | FLAG | dtSalesSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-70ad3a36 | this.Load | DMF0038_EOL.cs:194 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fc94b639 | this.Load | DMF0038_EOL.cs:195 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-dbbe911a | this.Load | DMF0038_EOL.cs:197 |  | VALUE_SET | drpDateTime.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## DMF0038_EOL.InitSpread

진입점: this.Load / cboDivision.SelectedIndexChanged / FindButton / SaveButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0e01fdef | this.Load 외 3 | DMF0038_EOL.cs:213 |  | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dsTitle.Tables[0]) | 그리드 재구성/초기화 |  |  |  |
| AC-d5dc6d51 | this.Load 외 3 | DMF0038_EOL.cs:218 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefColumns.EDIT_FLAG)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## DMF0038_EOL.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cb39945 | (진입점 미연결) | DMF0038_EOL.cs:535 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0038_EOL.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4e7c1d56 | SaveButton | DMF0038_EOL.cs:460 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_division_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-e500cb67 | SaveButton | DMF0038_EOL.cs:461 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_project_code.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a3794f3f | SaveButton | DMF0038_EOL.cs:462 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_scm_site_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-57b80cfc | SaveButton | DMF0038_EOL.cs:463 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_item_id.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-c04f6d0e | SaveButton | DMF0038_EOL.cs:464 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_reason_code.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-42365cec | SaveButton | DMF0038_EOL.cs:465 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_reason_description.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-24ef5298 | SaveButton | DMF0038_EOL.cs:466 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_project_status.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a3d59d2 | SaveButton | DMF0038_EOL.cs:467 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_change_date.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-072fab77 | SaveButton | DMF0038_EOL.cs:468 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_change_date2.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-37700385 | SaveButton | DMF0038_EOL.cs:469 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_eos_date.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-f6f71b02 | SaveButton | DMF0038_EOL.cs:470 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_eop_date.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-ba47b31f | SaveButton | DMF0038_EOL.cs:471 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_owner.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-a0cd98c7 | SaveButton | DMF0038_EOL.cs:472 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | p_created_by.Remove | (0, 1) | 데이터 객체 조작/조회 |  |  |  |
| AC-74db9b3e | SaveButton | DMF0038_EOL.cs:482 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("DM.DMF0038_SAVE_DM_MST_EOL_MAIN_STATUS") ⇒ DM.DMF0038_SAVE_DM_MST_EOL_MAIN_STATUS | 엔드포인트 요청 생성 |  |  |  |
| AC-50e002d3 | SaveButton | DMF0038_EOL.cs:483 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-21fee5e2 | SaveButton | DMF0038_EOL.cs:484 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_code"] | p_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-b67a10a6 | SaveButton | DMF0038_EOL.cs:485 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-fb78a893 | SaveButton | DMF0038_EOL.cs:486 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-54d43f2e | SaveButton | DMF0038_EOL.cs:487 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_reason_code"] | p_reason_code | 행/컬럼 값 대입 |  |  |  |
| AC-cc00337e | SaveButton | DMF0038_EOL.cs:488 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_reason_description"] | p_reason_description | 행/컬럼 값 대입 |  |  |  |
| AC-f9166095 | SaveButton | DMF0038_EOL.cs:489 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_project_status"] | p_project_status | 행/컬럼 값 대입 |  |  |  |
| AC-5132640f | SaveButton | DMF0038_EOL.cs:490 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_change_date"] | p_change_date | 행/컬럼 값 대입 |  |  |  |
| AC-219de239 | SaveButton | DMF0038_EOL.cs:491 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_change_date2"] | p_change_date2 | 행/컬럼 값 대입 |  |  |  |
| AC-c0e94aa5 | SaveButton | DMF0038_EOL.cs:492 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_eos_date"] | p_eos_date | 행/컬럼 값 대입 |  |  |  |
| AC-f917fc43 | SaveButton | DMF0038_EOL.cs:493 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_eop_date"] | p_eop_date | 행/컬럼 값 대입 |  |  |  |
| AC-c861bc78 | SaveButton | DMF0038_EOL.cs:494 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_owner"] | p_owner | 행/컬럼 값 대입 |  |  |  |
| AC-304886b1 | SaveButton | DMF0038_EOL.cs:495 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-8cad1a38 | SaveButton | DMF0038_EOL.cs:497 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-69865e2f | SaveButton | DMF0038_EOL.cs:501 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ if (re… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-41b110b7 | SaveButton | DMF0038_EOL.cs:505 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ try ▸ else o… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d320238 | SaveButton | DMF0038_EOL.cs:513 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ if (iCount > 0) ▸ catch ((Exce… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de2b6aaa | SaveButton | DMF0038_EOL.cs:522 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0038_EOL.SetSpreadHeaderSpan

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-288bef4b | (진입점 미연결) | DMF0038_EOL.cs:623 | foreach (DataRow dr in dt.Rows) ▸ if (iCellCnt <= iSmallStartCol) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iCellCnt, 2, 1, 20, sColumnLabel, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-82a535cc | (진입점 미연결) | DMF0038_EOL.cs:631 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (dr[DefColumns.ColumnName].ToString().IndexOf("B_") > 0) | GRID_INIT | siMain.VisibleColumns | (iCellCnt, false) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-8bdf1206 | (진입점 미연결) | DMF0038_EOL.cs:643 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5a6c9a00 | (진입점 미연결) | DMF0038_EOL.cs:649 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58f647a2 | (진입점 미연결) | DMF0038_EOL.cs:657 | foreach (DataRow dr in dt.Rows) ▸ else of (iCellCnt <= iSmallStartCol) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName !=… | GRID_INIT | siMain.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59aa8a25 | (진입점 미연결) | DMF0038_EOL.cs:678 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

