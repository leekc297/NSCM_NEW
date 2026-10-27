# AS-IS 액션 대조표 — DM0007

> 원천: `Doc/asisfacts/screens/DM0007/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 361행 · 메서드 30 · 종류 DATA_OP 103 · RETURN 51 · MESSAGE 45 · FLAG 31 · COMBO_DATA 24 · ENDPOINT 24 · GRID_LOCK 19 · GRID_SET 13 · LIST_REBIND 12 · GRID_INIT 11 · GRID_COMBO 10 · UI_MISC 7 · CALL_EXT 4 · POPUP 2 · GRID_BIND 2 · STATE_RESET 2 · VALUE_SET 1 · ⚠ 의미 확인 필요 4


## DM0007_CustFcstMaster.clbDivision_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-732457b7 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1558 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-2d56f188 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1558 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-628ff10c | (진입점 미연결) | DM0007_CustFcstMaster.cs:1559 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a06b92cc | (진입점 미연결) | DM0007_CustFcstMaster.cs:1563 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-cdd7e5f4 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1563 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e1a5ee05 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1564 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d5016044 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1568 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-faaca8a9 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1568 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ae47c0a1 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1569 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0007_CustFcstMaster.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54ef74b6 | this.clbEndCustomer.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1591 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-9d8847b7 | this.clbEndCustomer.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1591 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-728cd5f1 | this.clbEndCustomer.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1593 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0007_CustFcstMaster.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4aa23087 | this.clbTeam.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1577 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-73a8bdb0 | this.clbTeam.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1577 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d522a9d4 | this.clbTeam.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1578 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-13864d21 | this.clbTeam.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1582 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-87a565a9 | this.clbTeam.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1582 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-05aa04e1 | this.clbTeam.SelectedIndexChanged | DM0007_CustFcstMaster.cs:1583 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DM0007_CustFcstMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b35ca214 | this.Load | DM0007_CustFcstMaster.cs:205 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainFCST, SpdSheet.shtMainFCST, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0160c56 | this.Load | DM0007_CustFcstMaster.cs:206 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainPSI, SpdSheet.shtMainPSI, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d2c38dab | this.Load | DM0007_CustFcstMaster.cs:208 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainFCST) | 화면 필드/플래그 변경 |  |  |  |
| AC-46ec8c59 | this.Load | DM0007_CustFcstMaster.cs:209 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainPSI) | 화면 필드/플래그 변경 |  |  |  |
| AC-d3eb719e | this.Load | DM0007_CustFcstMaster.cs:211 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainFCST) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8da23492 | this.Load | DM0007_CustFcstMaster.cs:214 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainPSI) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20810478 | this.Load | DM0007_CustFcstMaster.cs:218 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainFCST) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0007_CustFcstMaster.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b3bc57d | this.Load | DM0007_CustFcstMaster.cs:195 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-92860f71 | this.Load | DM0007_CustFcstMaster.cs:197 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-95637fa4 | this.Load | DM0007_CustFcstMaster.cs:199 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-9989721c | this.Load | DM0007_CustFcstMaster.cs:199 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0007_CustFcstMaster.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6a717efd | DeleteButton | DM0007_CustFcstMaster.cs:291 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DM0007_CustFcstMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfe19bfa | Dispose | DM0007_CustFcstMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DM0007_CustFcstMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2fe6ff4 | EditButton | DM0007_CustFcstMaster.cs:307 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0 \|\|… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-37b7f392 | EditButton | DM0007_CustFcstMaster.cs:308 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0 \|\|… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-31856fc7 | EditButton | DM0007_CustFcstMaster.cs:319 | if (this.fps != null) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2508b3c4 | EditButton | DM0007_CustFcstMaster.cs:320 | if (this.fps != null) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4956f6ee | EditButton | DM0007_CustFcstMaster.cs:323 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-e0910a15 | EditButton | DM0007_CustFcstMaster.cs:324 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-34e4078f | EditButton | DM0007_CustFcstMaster.cs:332 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVa… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-88ba79e1 | EditButton | DM0007_CustFcstMaster.cs:333 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVa… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UploadOrder), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a5810667 | EditButton | DM0007_CustFcstMaster.cs:338 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-08f27579 | EditButton | DM0007_CustFcstMaster.cs:343 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BucketType), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-471cc427 | EditButton | DM0007_CustFcstMaster.cs:348 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5c2011f9 | EditButton | DM0007_CustFcstMaster.cs:353 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f6ab7ef | EditButton | DM0007_CustFcstMaster.cs:375 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVal… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-7ac4696a | EditButton | DM0007_CustFcstMaster.cs:376 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVal… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9ddae0f0 | EditButton | DM0007_CustFcstMaster.cs:381 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f15a8d94 | EditButton | DM0007_CustFcstMaster.cs:386 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BucketType), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2470fb5a | EditButton | DM0007_CustFcstMaster.cs:391 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c624d022 | EditButton | DM0007_CustFcstMaster.cs:396 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |

## DM0007_CustFcstMaster.FindDataFCST

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-27db4c21 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:438 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-cfc081c9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:447 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc7e2f0f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:449 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4904c137 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:452 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-8797fbc6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:454 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8522fa25 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:465 | try | ENDPOINT | new FoxDataRequest | ("DM.DM0007_GET_CUST_FCST_DATA") ⇒ DM.DM0007_GET_CUST_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-6892e60a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:467 | try | DATA_OP | request.Parameters["p_plan_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-5558087e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:468 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-416445b1 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:469 | try | DATA_OP | request.Parameters["p_dept_id"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-31b2676e | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:470 | try | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-b296d6b3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:471 | try | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-7d1f0e04 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:472 | try | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d1402d9a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:473 | try | DATA_OP | request.Parameters["p_valid_yn"] | cboActive.Text | 행/컬럼 값 대입 |  |  |  |
| AC-ec994c84 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:474 | try | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-7b497c2d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:476 | try | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-718f1d07 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:477 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0adfa146 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:479 | try | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-17435c76 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:487 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-71824bb6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:488 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-2db563bf | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:490 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4cd5553b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:497 | try | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-3882158b | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:501 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-de827139 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:507 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-98449d97 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DM0007_CustFcstMaster.cs:509 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0007_CustFcstMaster.FindDataPSI

진입점: FindButton [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e38aba9 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:522 | if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cc196f0a | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:524 | if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1bf6e00 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:535 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0007_GET_CUST_PSI_DATA") ⇒ DM.DM0007_GET_CUST_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-7ff595f8 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:537 |  | DATA_OP | request.Parameters["p_plan_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-142211b0 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:538 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5fbca4a8 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:539 |  | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-bd13e637 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:540 |  | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-8cf2cbd2 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:541 |  | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-1ee0a900 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:542 |  | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-86af6459 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:543 |  | DATA_OP | request.Parameters["p_valid_yn"] | cboActive.Text | 행/컬럼 값 대입 |  |  |  |
| AC-b6193969 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:544 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d9458d7e | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:546 |  | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-80e41a20 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:547 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8766c31d | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:549 |  | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-caf418a7 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:555 |  | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-697ad1cd | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:556 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-a7a69606 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:558 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b834b3ce | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DM0007_CustFcstMaster.cs:565 |  | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DM0007_CustFcstMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acad3fce | this.Load | DM0007_CustFcstMaster.cs:144 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-f93d8491 | this.Load | DM0007_CustFcstMaster.cs:145 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DM0007_CustFcstMaster.GetBucketType

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ffb3df9 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1788 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-4348d113 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1789 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3cc25ab7 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1792 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1367d02 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1730 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_DIVISION") ⇒ SCM.SCM0001_GET_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-f5071c4c | (진입점 미연결) | DM0007_CustFcstMaster.cs:1732 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d9663000 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1735 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetEndCustomerbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f802ab9b | (진입점 미연결) | DM0007_CustFcstMaster.cs:1757 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_CUSTOMER_BY_DIVISION") ⇒ SCM.SCM0001_GET_CUSTOMER_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-41a373d6 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1758 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-1f8f3e94 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1759 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-52e1a1b9 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1760 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8f060fd0 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1763 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetScmSitebyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbd8d8c5 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1772 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-80355cfe | (진입점 미연결) | DM0007_CustFcstMaster.cs:1773 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a5a7a268 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1774 |  | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-7d995bbd | (진입점 미연결) | DM0007_CustFcstMaster.cs:1775 |  | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomerName | 행/컬럼 값 대입 |  |  |  |
| AC-40d37be6 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1776 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-92cf8420 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1779 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetScmSiteInfobyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84fbaa5 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1823 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_SITE_INFO_BY_DIVISION") ⇒ SCM.SCM0001_GET_SITE_INFO_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-9a9ab543 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1824 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-8baddfcf | (진입점 미연결) | DM0007_CustFcstMaster.cs:1825 |  | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-cff8fee1 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1826 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-34248de5 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1829 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetSpdTitle

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (sSheetName == SpdSheet.shtMainFCST)] / this.Load [if (sSheetName == SpdSheet.shtMainFCST)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try ▸ if (sSheetName == SpdSheet.shtMainFCST)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (siMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fa8fb456 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1703 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0007_GET_SPREAD_TITLE") ⇒ DM.DM0007_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-c824e616 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1704 |  | DATA_OP | request.Parameters["p_plan_week"] | sPlanWeek | 행/컬럼 값 대입 |  |  |  |
| AC-62517d6e | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1705 |  | DATA_OP | request.Parameters["p_bucket_type"] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-12ca175f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1706 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-97c3c157 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1708 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-35f0ae2c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1708 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-005eb984 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1718 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DM0007", SpdSheet.shtMainPSI) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-dd30242f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1720 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetTeambyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7ac8218a | (진입점 미연결) | DM0007_CustFcstMaster.cs:1743 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_TEAM_BY_DIVISION") ⇒ SCM.SCM0001_GET_TEAM_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-bb09fcd3 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1744 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-4979b624 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1745 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9c9f1163 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1748 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.GetUploadUOM

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a1bcaa7 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1838 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_LOOKUP_VALUES") ⇒ SCM.SCM0001_GET_LOOKUP_VALUES | 엔드포인트 요청 생성 |  |  |  |
| AC-6d2153c1 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1839 |  | DATA_OP | request.Parameters["p_lookup_type"] | "UPLOAD_UOM_TYPE_CODE" | 행/컬럼 값 대입 |  |  |  |
| AC-a1c42111 | (진입점 미연결) | DM0007_CustFcstMaster.cs:1840 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bdca0e0d | (진입점 미연결) | DM0007_CustFcstMaster.cs:1843 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8e10ed4a | this.Load | DM0007_CustFcstMaster.cs:158 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-88156ac4 | this.Load | DM0007_CustFcstMaster.cs:158 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bd249527 | this.Load | DM0007_CustFcstMaster.cs:159 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d99fc688 | this.Load | DM0007_CustFcstMaster.cs:163 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-23d29587 | this.Load | DM0007_CustFcstMaster.cs:163 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7a068172 | this.Load | DM0007_CustFcstMaster.cs:164 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ff3cfdf5 | this.Load | DM0007_CustFcstMaster.cs:168 |  | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-d91215b3 | this.Load | DM0007_CustFcstMaster.cs:168 |  | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-e31cc886 | this.Load | DM0007_CustFcstMaster.cs:169 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a204a4c3 | this.Load | DM0007_CustFcstMaster.cs:174 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-5c2f728c | this.Load | DM0007_CustFcstMaster.cs:174 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5c22474e | this.Load | DM0007_CustFcstMaster.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bf00cf0e | this.Load | DM0007_CustFcstMaster.cs:177 |  | FLAG | dtBucketType | Data.Common(Data.Type.BucketType) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 화면 필드/플래그 변경 |  |  |  |
| AC-0dbd8150 | this.Load | DM0007_CustFcstMaster.cs:177 |  | COMBO_DATA | Data.Common | (Data.Type.BucketType) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0882c321 | this.Load | DM0007_CustFcstMaster.cs:178 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-00e0671a | this.Load | DM0007_CustFcstMaster.cs:181 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0488e5a9 | this.Load | DM0007_CustFcstMaster.cs:183 |  | FLAG | dtUploadUOM | Data.Common(Data.Type.UploadUOM) ⇒ biz:CommonData.CommonDataList [code=UploadUOM] | 화면 필드/플래그 변경 |  |  |  |
| AC-fa4a7f8a | this.Load | DM0007_CustFcstMaster.cs:183 |  | COMBO_DATA | Data.Common | (Data.Type.UploadUOM) ⇒ biz:CommonData.CommonDataList [code=UploadUOM] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DM0007_CustFcstMaster.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6d562fa4 | this.Load | DM0007_CustFcstMaster.cs:247 |  | FLAG | dtSave | new DataTable("CustomerFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-2fb420fa | this.Load | DM0007_CustFcstMaster.cs:248 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-4e1eef4c | this.Load | DM0007_CustFcstMaster.cs:249 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DivisionId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-1a8e131d | this.Load | DM0007_CustFcstMaster.cs:250 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlanWeek, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-fb72d849 | this.Load | DM0007_CustFcstMaster.cs:251 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerCode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e1bfd60e | this.Load | DM0007_CustFcstMaster.cs:252 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-c9019176 | this.Load | DM0007_CustFcstMaster.cs:253 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MeasureGroup, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-73cabf0e | this.Load | DM0007_CustFcstMaster.cs:254 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a4df9e54 | this.Load | DM0007_CustFcstMaster.cs:255 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ActiveFlag, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2f8aebc9 | this.Load | DM0007_CustFcstMaster.cs:256 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerPSI, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2b14afc7 | this.Load | DM0007_CustFcstMaster.cs:257 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UploadUOM, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-60368474 | this.Load | DM0007_CustFcstMaster.cs:258 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UploadBucketType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-5af4026a | this.Load | DM0007_CustFcstMaster.cs:259 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BucketType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a954d224 | this.Load | DM0007_CustFcstMaster.cs:260 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BucketValue, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-de1e1d35 | this.Load | DM0007_CustFcstMaster.cs:261 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BucketYn, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-facc6187 | this.Load | DM0007_CustFcstMaster.cs:262 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.EDIFCSTFlag, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32deadec | this.Load | DM0007_CustFcstMaster.cs:263 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UserId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DM0007_CustFcstMaster.InitSpread

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)] / this.Load / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c9b7c8f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:226 | if (sSheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-5d73f04a | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:231 | else of (sSheetName == SpdSheet.shtMainFCST) | FLAG | dtTitle | GetSpdTitle() | 화면 필드/플래그 변경 |  |  |  |
| AC-8dc414b6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:232 | else of (sSheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DM0007_CustFcstMaster.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f2b2d01 | InsertButton | DM0007_CustFcstMaster.cs:1054 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-10a96000 | InsertButton | DM0007_CustFcstMaster.cs:1057 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DivisionId), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b3e6d14e | InsertButton | DM0007_CustFcstMaster.cs:1058 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DivisionId), clbDivisions.Control… | 그리드 값 설정 |  |  |  |
| AC-0dab4170 | InsertButton | DM0007_CustFcstMaster.cs:1062 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-435d927d | InsertButton | DM0007_CustFcstMaster.cs:1062 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f17caa37 | InsertButton | DM0007_CustFcstMaster.cs:1063 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.DeptId), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-27bde799 | InsertButton | DM0007_CustFcstMaster.cs:1066 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-58efa0c3 | InsertButton | DM0007_CustFcstMaster.cs:1066 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6ade289c | InsertButton | DM0007_CustFcstMaster.cs:1067 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-573403e5 | InsertButton | DM0007_CustFcstMaster.cs:1070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | FLAG | dtScmSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-28628f53 | InsertButton | DM0007_CustFcstMaster.cs:1070 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-17354e79 | InsertButton | DM0007_CustFcstMaster.cs:1071 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-552141e0 | InsertButton | DM0007_CustFcstMaster.cs:1083 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.BucketType) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.BucketType), cboBucketType.SelectedValue) | 그리드 값 설정 |  |  |  |
| AC-6964b6cc | InsertButton | DM0007_CustFcstMaster.cs:1084 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.BucketType) > 0) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BucketType), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f93358b | InsertButton | DM0007_CustFcstMaster.cs:1091 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ if (siMain.Activ… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), "CUST_FCST") | 그리드 값 설정 |  |  |  |
| AC-ac151aa4 | InsertButton | DM0007_CustFcstMaster.cs:1092 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ if (siMain.Activ… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d4efd402 | InsertButton | DM0007_CustFcstMaster.cs:1096 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ else of (siMain.… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), "PSI") | 그리드 값 설정 |  |  |  |
| AC-c00c9c54 | InsertButton | DM0007_CustFcstMaster.cs:1097 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c62d1235 | InsertButton | DM0007_CustFcstMaster.cs:1102 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.EDIFCSTFlag) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-0abe08bf | InsertButton | DM0007_CustFcstMaster.cs:1107 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.ActiveFlag) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-00650df0 | InsertButton | DM0007_CustFcstMaster.cs:1112 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.UpdateDate) > 0) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |

## DM0007_CustFcstMaster.SaveData

진입점: SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6213605f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:653 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e76f0671 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:655 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dab02e3d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:664 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d13fe700 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:666 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e79b8b24 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:675 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e9ddf797 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:677 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d5f6f36a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:686 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fdb6d029 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:688 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-43b69211 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:697 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d19aa511 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:699 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fbb88a3b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:708 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c5cf6fd | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a2e8b00 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:719 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bde2fc93 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:721 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8cb2d9ba | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:730 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e7ccae0 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:732 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10307361 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-05c5a39d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:743 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d84b021f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:757 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0007_SAVE_CUST_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-06bf7a91 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-ae38e41b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:759 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-9ffe2b6b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_week"] | sPlanYYYYYWW | 행/컬럼 값 대입 |  |  |  |
| AC-f8ad3057 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:761 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_code"] | sCustomerCode | 행/컬럼 값 대입 |  |  |  |
| AC-eb06083f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:762 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-1239d23f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure_group"] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-4a553897 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:764 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-cb1a3546 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:765 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-1608178d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:766 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_psi"] | sCustomerPSI | 행/컬럼 값 대입 |  |  |  |
| AC-14e2c5dd | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:767 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_uom"] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-95488cbb | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:768 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_bucket_type"] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-51354896 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:769 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_type"] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-83e6876b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:770 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_value"] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-600ec985 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:771 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_yn"] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-980a941e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:772 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_edi_fcst_yn"] | sEDIFCSTFlag | 행/컬럼 값 대입 |  |  |  |
| AC-6aabc961 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:773 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-0f37376e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:775 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-bc00dac6 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:781 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ if (resp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00166") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7ba803b2 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:785 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ if (resp… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc680de5 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:791 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f780c6d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:798 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ catch ((Except… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7c052cd8 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:806 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00141") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8338392a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ea114790 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:884 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8c541304 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:893 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3b102924 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:895 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df184963 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7030041a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:906 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ef4cb3c0 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d03d885 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:917 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74ba4d13 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1a758cee | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:928 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dcd13e71 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-912e0bd3 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:939 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85f3bca4 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:948 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-28892047 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:950 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-964f4bd5 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5fe34965 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f73a5449 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:970 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-254a473c | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:972 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11f16fa6 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:981 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-baee7968 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:983 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c1f5247e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DM0007_SAVE_CUST_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-71afff7b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1001 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-54cc485f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1002 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-501838f6 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1003 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_week"] | sPlanYYYYYWW | 행/컬럼 값 대입 |  |  |  |
| AC-784574e8 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1004 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_code"] | sCustomerCode | 행/컬럼 값 대입 |  |  |  |
| AC-88f3eda0 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1005 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-2ececb52 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1006 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure_group"] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-f17adbb2 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1007 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-fac1f8d4 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1008 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-d7dddb7a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1009 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_psi"] | sCustomerPSI | 행/컬럼 값 대입 |  |  |  |
| AC-fd3fd55c | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1010 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_uom"] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-598949ae | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1011 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_bucket_type"] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-3605a95f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1012 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_type"] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-5b746cbd | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1013 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_value"] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-ddf1750c | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1014 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_yn"] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-44f1422a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1015 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_edi_fcst_yn"] | sEDIFCSTFlag | 행/컬럼 값 대입 |  |  |  |
| AC-d5e70044 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1016 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-8e0b4bde | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1018 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b64d9f48 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1022 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ if … | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6f849b50 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1027 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ els… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86421c5a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1034 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ catch ((E… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f6a561b5 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DM0007_CustFcstMaster.cs:1042 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00141") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DM0007_CustFcstMaster.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Column > 0 && e.Column <= siMain.GetColumnIndex(DefColumns.Measure)) ▸ else of (this.CanModelChange && e.Row > -1 && e.Column == siMain.GetColumnIndex(DefColumns.ActiveFlag)) ▸ if (this.CanModelChange && e.Row > -1 && e.Column > siMain.GetColumnIndex(DefColumns.ActiveFlag))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5e7b43e4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1665 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-2fa142ae | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1669 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-992129ee | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1670 | if (drFind.Length == 0) | DATA_OP | drNew[CAppSetting.StringAction] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-2dbdc660 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1671 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DivisionId] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e9abfafe | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1672 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlanWeek] | sPlanWeek | 행/컬럼 값 대입 |  |  |  |
| AC-14038fb7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1673 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerCode] | sCustomerCode | 행/컬럼 값 대입 |  |  |  |
| AC-b77418ab | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1674 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSite] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-9f8011d7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1675 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MeasureGroup] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-2d032725 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1676 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-edd21bb5 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1677 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ActiveFlag] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-97b788d4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1678 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerPSI] | sCustomerPSI | 행/컬럼 값 대입 |  |  |  |
| AC-19f33d37 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1679 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.UploadUOM] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-0c770c4c | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1680 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.UploadBucketType] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-43969575 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1681 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketType] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-7f233733 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1682 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketValue] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-3c759d36 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1683 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketYn] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-017cbbb9 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1684 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.EDIFCSTFlag] | sEDIFCSTFlag | 행/컬럼 값 대입 |  |  |  |
| AC-37744858 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1686 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-3eb9d2ae | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1687 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b2039e94 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1691 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.UploadUOM] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-d7217007 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1692 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.UploadBucketType] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-b9d5c15a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1693 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketValue] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-affbe5d1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1694 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketYn] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-e84163c8 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DM0007_CustFcstMaster.cs:1695 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DM0007_CustFcstMaster.SetSpreadColor

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (sSheetName == SpdSheet.shtMainFCST)] / this.Load [if (sSheetName == SpdSheet.shtMainFCST)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMa…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da65dad3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1797 | if (siMain.ActiveSheet.SheetName != SpdSheet.shtMainFCST) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55a28e7b | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1799 | if (cboBucketType.SelectedValue.ToString() != BucketType.Daily) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b22d6b3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1801 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-586d15c3 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1808 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-0604a332 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1808 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d38521fa | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1810 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday \|\| siMain.GetColumnText(0, iCol) … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iCol, 1, iCol].ForeColor | siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-edd163ee | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1810 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday \|\| siMain.GetColumnText(0, iCol) … | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5bf82e42 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 3 | DM0007_CustFcstMaster.cs:1814 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DM0007_CustFcstMaster.shtMainFCSTDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7746cba9 | dsdm.Changed | DM0007_CustFcstMaster.cs:1133 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f7760aaf | dsdm.Changed | DM0007_CustFcstMaster.cs:1171 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00136") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f99e2c5a | dsdm.Changed | DM0007_CustFcstMaster.cs:1173 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-fab88d41 | dsdm.Changed | DM0007_CustFcstMaster.cs:1175 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4b80c86 | dsdm.Changed | DM0007_CustFcstMaster.cs:1232 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetText | (e.Row, iCOl, sActiveFlag) | 그리드 값 설정 |  |  |  |
| AC-de34b524 | dsdm.Changed | DM0007_CustFcstMaster.cs:1254 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-782db67f | dsdm.Changed | DM0007_CustFcstMaster.cs:1263 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetText | (e.Row, iCol, sActiveFlag) | 그리드 값 설정 |  |  |  |
| AC-95b44c62 | dsdm.Changed | DM0007_CustFcstMaster.cs:1300 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetValue | (e.Row, e.Column, sBucketYn) | 그리드 값 설정 |  |  |  |
| AC-87a4c241 | dsdm.Changed | DM0007_CustFcstMaster.cs:1310 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-82d390fe | dsdm.Changed | DM0007_CustFcstMaster.cs:1312 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-458b62de | dsdm.Changed | DM0007_CustFcstMaster.cs:1321 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-158468d9 | dsdm.Changed | DM0007_CustFcstMaster.cs:1323 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-588ac25e | dsdm.Changed | DM0007_CustFcstMaster.cs:1332 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7cf3b85c | dsdm.Changed | DM0007_CustFcstMaster.cs:1334 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-12df5d90 | dsdm.Changed | DM0007_CustFcstMaster.cs:1343 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5702beef | dsdm.Changed | DM0007_CustFcstMaster.cs:1345 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5550f7b | dsdm.Changed | DM0007_CustFcstMaster.cs:1354 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6e816736 | dsdm.Changed | DM0007_CustFcstMaster.cs:1356 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-eb16c6e9 | dsdm.Changed | DM0007_CustFcstMaster.cs:1365 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7e52f570 | dsdm.Changed | DM0007_CustFcstMaster.cs:1367 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb5c3afe | dsdm.Changed | DM0007_CustFcstMaster.cs:1376 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-be0d9e58 | dsdm.Changed | DM0007_CustFcstMaster.cs:1378 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c215062a | dsdm.Changed | DM0007_CustFcstMaster.cs:1387 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f31afb5e | dsdm.Changed | DM0007_CustFcstMaster.cs:1389 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-228d552e | dsdm.Changed | DM0007_CustFcstMaster.cs:1398 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e8fb9584 | dsdm.Changed | DM0007_CustFcstMaster.cs:1400 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-deca7adf | dsdm.Changed | DM0007_CustFcstMaster.cs:1421 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00136") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-acdfa929 | dsdm.Changed | DM0007_CustFcstMaster.cs:1423 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-30a992ad | dsdm.Changed | DM0007_CustFcstMaster.cs:1425 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.shtMainPSIDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f690a4f6 | dsdm2.Changed | DM0007_CustFcstMaster.cs:1439 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-419b6d5b | dsdm2.Changed | DM0007_CustFcstMaster.cs:1441 | if (e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-64bc2723 | dsdm2.Changed | DM0007_CustFcstMaster.cs:1469 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a2738f3 | dsdm2.Changed | DM0007_CustFcstMaster.cs:1487 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | MESSAGE | MessageHelper.GMessageBox | ("MSG00136") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-62ec6602 | dsdm2.Changed | DM0007_CustFcstMaster.cs:1488 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-99960c81 | dsdm2.Changed | DM0007_CustFcstMaster.cs:1490 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DM0007_CustFcstMaster.spdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d768dbdc | this.spdMain.ActiveSheetChanged | DM0007_CustFcstMaster.cs:1638 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93a33e33 | this.spdMain.ActiveSheetChanged | DM0007_CustFcstMaster.cs:1642 | if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainFCST) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9a7bab6a | this.spdMain.ActiveSheetChanged | DM0007_CustFcstMaster.cs:1646 | else of (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainPSI) | 그리드 컬럼/헤더 구성 |  |  |  |

## DM0007_CustFcstMaster.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5967cd24 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1510 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (siMain.GetColumnIndex(DefColumns.DeptId) > 0) | FLAG | dtTeam | Data.UserTeamByDivisionAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current… | 화면 필드/플래그 변경 |  |  |  |
| AC-a3c1774c | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1510 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (siMain.GetColumnIndex(DefColumns.DeptId) > 0) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-5b22f418 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1511 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (siMain.GetColumnIndex(DefColumns.DeptId) > 0) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.DeptId), dtTeam) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-04523e38 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1515 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-54d0d97c | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1515 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1fb23353 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1516 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-b65b3afb | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1519 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | FLAG | dtScmSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-ce966633 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1519 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fd0a332 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1520 | if (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-7d559874 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1526 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDeptAuth(UserInfoContext.Current["NowGroupID"], UserInfoCont… | 화면 필드/플래그 변경 |  |  |  |
| AC-c06b7d6c | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1526 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c2d4b9d4 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1527 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-8e1ed0bd | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1530 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) | FLAG | dtScmSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-f3979fa9 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1530 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6b976b0a | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1531 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-ab921bb6 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1537 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) ▸ if (e.… | FLAG | dtScmSite | Data.UserSiteByEndCustomerAuth(UserInfoContext.Current["NowGroupID"], UserInfoContext.Curr… | 화면 필드/플래그 변경 |  |  |  |
| AC-a618f32c | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1537 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) ▸ if (e.… | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f6930dc2 | this.spdMain.ComboSelChange | DM0007_CustFcstMaster.cs:1538 | else of (e.Column == siMain.GetColumnIndex(DefColumns.DivisionId)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.DeptId)) ▸ if (e.… | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

