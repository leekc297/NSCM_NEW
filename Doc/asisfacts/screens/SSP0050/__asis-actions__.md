# AS-IS 액션 대조표 — SSP0050

> 원천: `Doc/asisfacts/screens/SSP0050/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 177행 · 메서드 17 · 종류 UI_PROP 60 · POPUP 25 · DATA_OP 23 · RETURN 13 · GRID_SET 10 · GRID_INIT 7 · FLAG 7 · UI_MISC 7 · ENDPOINT 7 · LIST_REBIND 5 · VALIDATE 3 · MESSAGE 3 · COMBO_DATA 3 · GRID_LOCK 2 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SSP0050_ShipmentChangeRequestIntegration.BtnApprovalUser_Click

진입점: btnApprovalUser.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e0d036ff | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:865 |  | POPUP | new SSP0002_UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-406f0ce8 | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:867 |  | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-14c7f681 | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:868 |  | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-9bde6cfd | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:869 |  | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-071d1286 | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:870 |  | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-ac5359ab | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:871 |  | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-5404e837 | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:873 |  | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-f41cebed | btnApprovalUser.Click | SSP0050_ShipmentChangeRequestIntegration.cs:875 |  | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.btnItemId_Click

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c33963f | (진입점 미연결) | SSP0050_ShipmentChangeRequestIntegration.cs:846 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fc4d7ad7 | (진입점 미연결) | SSP0050_ShipmentChangeRequestIntegration.cs:848 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-48728421 | (진입점 미연결) | SSP0050_ShipmentChangeRequestIntegration.cs:849 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-9c3ccdaf | (진입점 미연결) | SSP0050_ShipmentChangeRequestIntegration.cs:850 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-539d2899 | (진입점 미연결) | SSP0050_ShipmentChangeRequestIntegration.cs:856 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91d5e17a | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:206 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9d2fae05 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:207 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-a2ba708a | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:209 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1c52a76e | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:158 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-11cc1326 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:160 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-02e4a6e7 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:161 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-4139503e | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:162 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c8b84ad | Dispose | SSP0050_ShipmentChangeRequestIntegration.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc8db060 | EditButton | SSP0050_ShipmentChangeRequestIntegration.cs:270 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-ef85ec8d | EditButton | SSP0050_ShipmentChangeRequestIntegration.cs:271 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-445901ac | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:294 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a5bf4dd2 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:299 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-4881fa9c | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:299 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-894affff | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:303 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-3f9cdf14 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:323 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fc776e48 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:324 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, "GSCM.SSP.Plan.… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c1fde392 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:328 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0050_GET_SHIPMENT_APPORVAL") ⇒ SSP.SSP0050_GET_SHIPMENT_APPORVAL | 엔드포인트 요청 생성 |  |  |  |
| AC-c981dff9 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:329 | try ▸ lambda | UI_PROP | req.CommandTimeout | 60 * 10 | 속성 CommandTimeout 설정 |  |  |  |
| AC-5c58bae5 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:335 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-c77b4251 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:337 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-695c6c66 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:338 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9e0c9983 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:345 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-bc4d20f6 | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:347 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-31daf80f | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:349 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-f4fb460a | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:363 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3071682b | FindButton 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:371 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-636b8af1 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:114 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.GetUserIDChk

진입점: SaveButton [try ▸ if (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-919c5a82 | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:561 | try | ENDPOINT | new FoxDataRequest | ("SSP.SSP0014_GET_USER_ID_CHECK") ⇒ SSP.SSP0014_GET_USER_ID_CHECK | 엔드포인트 요청 생성 |  |  |  |
| AC-2aae308c | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:562 | try | DATA_OP | request.Parameters["p_user_id"] | sUserID | 행/컬럼 값 대입 |  |  |  |
| AC-04b42301 | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:564 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-444e8b8e | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:577 | try ▸ if (ds.Tables[0].Rows.Count > 0) ▸ foreach (string user in strUSer) | DATA_OP | ds.Tables[0].Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e65573d4 | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:599 | try ▸ if (iCnt > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00251", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea709470 | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:603 | catch ((Exception ex)) | RETURN | return false; |  | 처리 중단/반환 |  |  |  |
| AC-533ed5a6 | SaveButton [try ▸ if (iCount > 0)] | SSP0050_ShipmentChangeRequestIntegration.cs:605 |  | RETURN | return bReturn; |  | 처리 중단/반환 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-21a1455b | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:174 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-8e1ca013 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:177 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-db454129 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:181 |  | DATA_OP | dtOpreationGroup.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-eea67b13 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:182 |  | DATA_OP | insertRow["CODE"] | "W" | 행/컬럼 값 대입 |  |  |  |
| AC-265a86d5 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:183 |  | DATA_OP | insertRow["NAME"] | "Warrnaty" | 행/컬럼 값 대입 |  |  |  |
| AC-44dab046 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:185 |  | DATA_OP | dtOpreationGroup.Rows.Add | (insertRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-06ca64a6 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:187 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1e2c84d6 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:188 |  | LIST_REBIND | clsCtrl.setListBox | (dtOpreationGroup, cboOperationGroup, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-3c111029 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:189 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboValidYN, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-211d44dc | this.Load 외 2 | SSP0050_ShipmentChangeRequestIntegration.cs:218 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-084b5ada | this.Load 외 2 | SSP0050_ShipmentChangeRequestIntegration.cs:219 | if (spdInfo.SheetName == SpdSheet.shtMain) | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-fb137cfc | this.Load 외 2 | SSP0050_ShipmentChangeRequestIntegration.cs:220 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-3b93760c | this.Load 외 2 | SSP0050_ShipmentChangeRequestIntegration.cs:221 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b832f975 | this.Load 외 2 | SSP0050_ShipmentChangeRequestIntegration.cs:223 | if (spdInfo.SheetName == SpdSheet.shtMain) | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.USER_ID].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f094a0c | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:386 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-c89b999c | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:390 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-ef3a3dd9 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:392 | try | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-9fe92f6b | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:392 | try ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bcb50045 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:440 | try ▸ if (iCount > 0) ▸ if (!GetUserIDChk(p_user_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a65cdd58 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:443 | try ▸ if (iCount > 0) ▸ if (p_part_leader.Replace("^", "") != null && p_part_leader.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_part_leade… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-769fcecd | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:447 | try ▸ if (iCount > 0) ▸ if (p_team_leader.Replace("^", "") != null && p_team_leader.Replace("^", "") != "") ▸ if (!GetUserIDChk(p_team_leade… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-628c0192 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:456 | try ▸ if (iCount > 0) ▸ foreach (string mailUser1 in arrMailUser1) ▸ if (!string.IsNullOrEmpty(mailUser1) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79872d24 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:465 | try ▸ if (iCount > 0) ▸ foreach (string mailUser2 in arrMailUser2) ▸ if (!string.IsNullOrEmpty(mailUser2) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a7007819 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:474 | try ▸ if (iCount > 0) ▸ foreach (string mailUser3 in arrMailUser3) ▸ if (!string.IsNullOrEmpty(mailUser3) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fda79e82 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:483 | try ▸ if (iCount > 0) ▸ foreach (string mailUser4 in arrMailUser4) ▸ if (!string.IsNullOrEmpty(mailUser4) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f6222955 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:492 | try ▸ if (iCount > 0) ▸ foreach (string mailUser5 in arrMailUser5) ▸ if (!string.IsNullOrEmpty(mailUser5) && !string.IsNullOrWhiteSpace(mail… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-46f5dfdc | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:496 | try ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC") ⇒ SSP.SSP0014_SAVE_SHIPMENT_MODEL_PIC | 엔드포인트 요청 생성 |  |  |  |
| AC-8af99d86 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:500 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-22eb58db | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:501 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-c6a9c02a | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:502 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_from_site"] | p_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-a965ee8d | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:503 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-29579613 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:504 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-7b290543 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:505 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-496bdee5 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:506 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_create_id"] | p_create_id | 행/컬럼 값 대입 |  |  |  |
| AC-60eb24a6 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:507 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_part_leader"] | p_part_leader | 행/컬럼 값 대입 |  |  |  |
| AC-560e665a | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:508 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_team_leader"] | p_team_leader | 행/컬럼 값 대입 |  |  |  |
| AC-daa4b7a3 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:510 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user1"] | p_mail_user1 | 행/컬럼 값 대입 |  |  |  |
| AC-982853ed | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:511 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user2"] | p_mail_user2 | 행/컬럼 값 대입 |  |  |  |
| AC-a64a9893 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:512 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user3"] | p_mail_user3 | 행/컬럼 값 대입 |  |  |  |
| AC-6144759a | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:513 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user4"] | p_mail_user4 | 행/컬럼 값 대입 |  |  |  |
| AC-9ccf7698 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:514 | try ▸ if (iCount > 0) | DATA_OP | request.Parameters["p_mail_user5"] | p_mail_user5 | 행/컬럼 값 대입 |  |  |  |
| AC-0a3aa492 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:516 | try ▸ if (iCount > 0) | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6abb37ac | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:521 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7326552e | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:523 | try ▸ if (iCount > 0) ▸ if (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { ds.Tables[0].Rows[0][1].ToString() }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad8e5b56 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:528 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-d4ecf9b3 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:541 | try ▸ if (iCount > 0) ▸ else of (ds.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00284", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b4e61fd9 | SaveButton | SSP0050_ShipmentChangeRequestIntegration.cs:549 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80b51880 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:135 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-800bbe43 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:136 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-1224b1c0 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:142 | switch (triggerControl) case "MyDivisionCMM": | FLAG | dtMyDivision | DataService.GetSSPInnerTable("MyDivisionCMM", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-c9eee142 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:142 | switch (triggerControl) case "MyDivisionCMM": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivisionCMM", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-6f07495d | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:147 | switch (triggerControl) case "OPERATION_GROUP": | FLAG | dtOpreationGroup | DataService.GetSSPInnerTable("OPERATION_GROUP", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-7ee22c47 | this.Load | SSP0050_ShipmentChangeRequestIntegration.cs:147 | switch (triggerControl) case "OPERATION_GROUP": | COMBO_DATA | DataService.GetSSPInnerTable | ("OPERATION_GROUP", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c68ed5a3 | this.Load 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:200 |  | FLAG | dtFromSite | Data_SCP.Common(Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 화면 필드/플래그 변경 |  |  |  |
| AC-2ab147cd | this.Load 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:200 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.PlantSiteByDivision, false, pDivisionID) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d8efd959 | this.Load 외 1 | SSP0050_ShipmentChangeRequestIntegration.cs:201 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, this.clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.SetImageCell

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-80177b85 | (진입점 미연결) | SSP0050_ShipmentChangeRequestIntegration.cs:380 | for (iRow < siMain.ActiveSheet.RowCount) ▸ if (siMain.GetColumnIndex(DefColumns.USER_ID) > -1) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefColumns.USER_ID)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.SpdMain_CellDoubleClick

진입점: spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5a5012d | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:632 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-df23f981 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:634 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-8b3f0709 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:635 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-500c2e00 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:636 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7a69edf3 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:637 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-c71fb9d0 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:638 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-bf1c25d1 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:640 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-dee31f70 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:642 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e0b71d29 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:648 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.USER_ID)) ▸ if (popup.Sho… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.USER_ID), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-964075df | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:657 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-30a0428d | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:659 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-ecfa8034 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:660 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-49de4a0e | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:661 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d818d57c | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:662 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-fa20058a | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:663 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-6f2b848b | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:665 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-b4ad4567 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:667 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-8d27b7bc | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:673 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.PART_LEADER)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.PART_LEADER), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-73e565d2 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:682 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-021aa149 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:684 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-05bcad7a | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:685 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-7027cba7 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-68aafe46 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:687 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-5294ceab | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:688 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-64a987f1 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:690 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-a2fc6dd3 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:692 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-27b10d4d | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:698 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.TEAM_LEADER)) ▸ if (popup… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TEAM_LEADER), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-806cd083 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:707 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-27b031ef | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:709 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-c9fb002c | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-81c2f731 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:711 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-cf088dee | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:712 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-cda9c2ce | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:713 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-e67f846a | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:715 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-f80aceb5 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-78d04796 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:723 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER1)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER1), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-a6ce4f44 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:732 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-da11461b | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:734 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-c1a78965 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:735 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-6e1074e0 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:736 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-1b635a77 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:737 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-62020d8e | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:738 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-339afe11 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:740 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-fa9478f5 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:742 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b042e946 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER2)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER2), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-8ba98a87 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:757 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bc4e53b3 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:759 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-c16ce812 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-b1492037 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-50567a09 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:762 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-dc283486 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-52995eae | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:765 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-5cae4024 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:767 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-22c624c4 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:773 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER3)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER3), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-7d396677 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:782 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-7a9355fc | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:784 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-193e1cb6 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:785 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-3f13484a | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:786 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-284b2486 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:787 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-17042d8b | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:788 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-ad26bcef | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:790 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-3a5d34f1 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:792 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f9b2c46 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:798 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER4)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER4), item.UserID) | 그리드 값 설정 |  |  |  |
| AC-b8a0a48a | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:807 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | POPUP | new UserInfoPopup | () | 팝업/폼 생성 |  |  |  |
| AC-796e5398 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:809 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.Width | 500 | 속성 Width 설정 |  |  |  |
| AC-ed861ec9 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:810 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.Height | 400 | 속성 Height 설정 |  |  |  |
| AC-b2038868 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:811 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.StartPosition | FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d42b6b1e | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:812 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.SSOUserYN | false | 속성 SSOUserYN 설정 |  |  |  |
| AC-ad5e13fa | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:813 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.SingleSelectYn | true | 속성 SingleSelectYn 설정 |  |  |  |
| AC-db69be90 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:815 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | UI_PROP | popup.Language | UserInfoContext.Current[UserInfoProperites.Language].ToString() | 속성 Language 설정 |  |  |  |
| AC-548c8455 | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:817 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) | POPUP | popup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-505c753b | spdMain.CellDoubleClick | SSP0050_ShipmentChangeRequestIntegration.cs:823 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.MAIL_USER5)) ▸ if (popup.… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.MAIL_USER5), item.UserID) | 그리드 값 설정 |  |  |  |

## SSP0050_ShipmentChangeRequestIntegration.SpdMain_TopChange

진입점: spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5901fec9 | spdMain.TopChange | SSP0050_ShipmentChangeRequestIntegration.cs:621 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

