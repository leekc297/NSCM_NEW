# AS-IS 액션 대조표 — DMF0007

> 원천: `Doc/asisfacts/screens/DMF0007/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 360행 · 메서드 27 · 종류 DATA_OP 107 · MESSAGE 47 · RETURN 46 · COMBO_DATA 23 · FLAG 22 · GRID_LOCK 20 · LIST_REBIND 17 · GRID_SET 14 · ENDPOINT 12 · GRID_INIT 11 · UI_MISC 11 · UI_PROP 10 · CALL_EXT 5 · GRID_COMBO 5 · POPUP 4 · GRID_BIND 2 · STATE_RESET 2 · VALUE_SET 1 · THROW 1 · ⚠ 의미 확인 필요 5


## DMF0007_CustFcstMaster.clbDivision_SelectedIndexChanged

진입점: clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-503ed5a5 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:298 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-c9e715c3 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:298 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-316efcba | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:299 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4481bde6 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:308 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, clbTeam.ControlValues, UserInfoConte… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ecde9f1d | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:309 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer40, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-85a10fca | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:314 | if (sDivision == "40") | COMBO_DATA | Data.ScmSitebyEndCustomer40 | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, "") | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-a6988cac | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:315 | if (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite40, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a3fa6016 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:321 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ca427274 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:322 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aa483d36 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:326 | else of (sDivision == "40") | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9dd5b71 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:327 | else of (sDivision == "40") | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0007_CustFcstMaster.clbDivisions_SelectedIndexChanged

진입점: clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-763b7b56 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:1710 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a59adcb8 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:1715 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f6f88400 | clbDivisions.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:1720 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0007_CustFcstMaster.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5b138350 | this.clbEndCustomer.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:1762 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0007_CustFcstMaster.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a32a63a8 | this.clbTeam.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:1737 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-707ef3c5 | this.clbTeam.SelectedIndexChanged | DMF0007_CustFcstMaster.cs:1745 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0007_CustFcstMaster.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6477756d | this.Load | DMF0007_CustFcstMaster.cs:269 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainFCST, SpdSheet.shtMainFCST, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-11b482b4 | this.Load | DMF0007_CustFcstMaster.cs:270 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMainPSI, SpdSheet.shtMainPSI, 2, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d201290e | this.Load | DMF0007_CustFcstMaster.cs:272 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainFCST) | 화면 필드/플래그 변경 |  |  |  |
| AC-e6b0b6b6 | this.Load | DMF0007_CustFcstMaster.cs:273 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, SpdSheet.shtMainPSI) | 화면 필드/플래그 변경 |  |  |  |
| AC-1830d8e1 | this.Load | DMF0007_CustFcstMaster.cs:275 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainFCST) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f99e815 | this.Load | DMF0007_CustFcstMaster.cs:278 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainPSI) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d00d87ee | this.Load | DMF0007_CustFcstMaster.cs:282 |  | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainFCST) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0007_CustFcstMaster.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-115d9a48 | this.Load | DMF0007_CustFcstMaster.cs:259 |  | VALUE_SET | cboBucketType.ControlValues | BucketType.Weekly | 컨트롤 값 설정 |  |  |  |
| AC-8c8bea7f | this.Load | DMF0007_CustFcstMaster.cs:261 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6bba647d | this.Load | DMF0007_CustFcstMaster.cs:263 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-5bda9281 | this.Load | DMF0007_CustFcstMaster.cs:263 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0007_CustFcstMaster.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-91784d05 | DeleteButton | DMF0007_CustFcstMaster.cs:406 | if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.StringI) | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0007_CustFcstMaster.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bddd6422 | Dispose | DMF0007_CustFcstMaster.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0007_CustFcstMaster.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-af708c6c | EditButton | DMF0007_CustFcstMaster.cs:422 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0 \|\|… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-45efc9e2 | EditButton | DMF0007_CustFcstMaster.cs:423 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0 \|\|… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a832c22e | EditButton | DMF0007_CustFcstMaster.cs:434 | if (this.fps != null) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00113") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-340402db | EditButton | DMF0007_CustFcstMaster.cs:435 | if (this.fps != null) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ if (siMain.GetColumnIndex(DefColumns.DivisionId) < 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4d554756 | EditButton | DMF0007_CustFcstMaster.cs:438 | if (this.fps != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-47c33f27 | EditButton | DMF0007_CustFcstMaster.cs:439 | if (this.fps != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-551d68ca | EditButton | DMF0007_CustFcstMaster.cs:447 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVa… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-508bddfa | EditButton | DMF0007_CustFcstMaster.cs:448 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVa… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UploadOrder), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0f8a0f7e | EditButton | DMF0007_CustFcstMaster.cs:453 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-90b9f388 | EditButton | DMF0007_CustFcstMaster.cs:458 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BucketType), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3e0f39e2 | EditButton | DMF0007_CustFcstMaster.cs:463 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1328d248 | EditButton | DMF0007_CustFcstMaster.cs:468 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a59e40b5 | EditButton | DMF0007_CustFcstMaster.cs:490 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVal… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6e3e0eca | EditButton | DMF0007_CustFcstMaster.cs:491 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ if (siMain.GetVal… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-18c1392a | EditButton | DMF0007_CustFcstMaster.cs:496 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.PlanWeek), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-767bbcda | EditButton | DMF0007_CustFcstMaster.cs:501 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.BucketType), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-3c6765c5 | EditButton | DMF0007_CustFcstMaster.cs:506 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c609637 | EditButton | DMF0007_CustFcstMaster.cs:511 | if (this.fps != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainPSI) ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of (siMain.G… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0007_CustFcstMaster.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f99c609 | ExcelButton | DMF0007_CustFcstMaster.cs:552 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-439400c8 | ExcelButton | DMF0007_CustFcstMaster.cs:553 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-5b85e771 | ExcelButton | DMF0007_CustFcstMaster.cs:554 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-26006f04 | ExcelButton | DMF0007_CustFcstMaster.cs:555 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-9bb8110a | ExcelButton | DMF0007_CustFcstMaster.cs:556 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-69626d7c | ExcelButton | DMF0007_CustFcstMaster.cs:557 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-e22f1148 | ExcelButton | DMF0007_CustFcstMaster.cs:559 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-192774ea | ExcelButton | DMF0007_CustFcstMaster.cs:560 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-8a12b6fd | ExcelButton | DMF0007_CustFcstMaster.cs:562 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-59f75afe | ExcelButton | DMF0007_CustFcstMaster.cs:571 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cb0a52bd | ExcelButton | DMF0007_CustFcstMaster.cs:576 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-781cb215 | ExcelButton | DMF0007_CustFcstMaster.cs:580 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0007_CustFcstMaster.FindDataFCST

진입점: FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c16b3513 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:601 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6a62cda9 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:610 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c66d7809 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:612 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-89dbb7c3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:615 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-83e631c0 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:617 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-8ff1d98c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:628 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0007_GET_CUST_FCST_DATA") ⇒ DM.DMF0007_GET_CUST_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-c27f07ba | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:630 | try | DATA_OP | request.Parameters["p_plan_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-25699c9f | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:631 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-e78d3a78 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:635 | try | DATA_OP | request.Parameters["p_dept_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-d12760de | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:638 | try | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-a20b6438 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:639 | try | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-cfabe8a4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:640 | try | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-40ef0cf5 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:641 | try | DATA_OP | request.Parameters["p_valid_yn"] | cboActive.Text | 행/컬럼 값 대입 |  |  |  |
| AC-48ce09a3 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:642 | try | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-957e93a4 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:644 | try | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-07b6bb49 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:645 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3d2a68c6 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:647 | try | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-a273fe63 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:655 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0061b36c | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:656 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-cb2727bb | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:658 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-509fb682 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:665 | try | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-064d664d | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:669 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-79f266c5 | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:675 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-86771e0a | FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… 외 1 | DMF0007_CustFcstMaster.cs:677 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0007_CustFcstMaster.FindDataPSI

진입점: FindButton [else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ else of (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bac780a | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:688 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ed8308cf | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:695 | try ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6c0adbc8 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:697 | try ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4f230d63 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:700 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6c2c6e55 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:702 | try | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-bba51672 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:711 | try | ENDPOINT | new FoxDataRequest | ("DM.DMF0007_GET_CUST_PSI_DATA") ⇒ DM.DMF0007_GET_CUST_PSI_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-fe790745 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:713 | try | DATA_OP | request.Parameters["p_plan_week"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-a52c598d | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:714 | try | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-c9746a38 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:718 | try | DATA_OP | request.Parameters["p_dept_id"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-3ce7bfeb | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:721 | try | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-e3547aa2 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:722 | try | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-4b030dfb | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:723 | try | DATA_OP | request.Parameters["p_bucket_type"] | cboBucketType.SelectedValue.ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5977c4d2 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:724 | try | DATA_OP | request.Parameters["p_valid_yn"] | cboActive.Text | 행/컬럼 값 대입 |  |  |  |
| AC-878a8dcb | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:725 | try | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-422dc869 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:727 | try | DATA_OP | request.Parameters["p_user_group"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-15f85acf | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:728 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-656cc8c3 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:730 | try | FLAG | dsMain | response.DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-b1309832 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:736 | try | GRID_BIND | siMain.Query | (dsMain) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-0486ee1a | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:737 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e13f62c0 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:739 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a2939212 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:744 | try | STATE_RESET | dtSave.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-f1ee6747 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:749 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7369f5a8 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:754 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e3eceb17 | FindButton [else of (siMain.ActiveSheet.SheetName == SpdShee… 외 1 | DMF0007_CustFcstMaster.cs:756 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0007_CustFcstMaster.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e288bc56 | this.Load | DMF0007_CustFcstMaster.cs:154 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-12823c92 | this.Load | DMF0007_CustFcstMaster.cs:155 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-370ec73f | this.Load | DMF0007_CustFcstMaster.cs:163 |  | UI_PROP | lblTeam.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## DMF0007_CustFcstMaster.GetCustFcstMeasure

진입점: InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain.GetColumnIndex(DefColumns.Measure) != -1)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5f6bdff4 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1899 |  | ENDPOINT | new FoxDataRequest | ("DM.UP_FX_GetCommonDataList_DM") ⇒ DM.UP_FX_GetCommonDataList_DM | 엔드포인트 요청 생성 |  |  |  |
| AC-e6220386 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1900 |  | DATA_OP | request.Parameters["CODE"] | "CUST_FCST_MEASURE" | 행/컬럼 값 대입 |  |  |  |
| AC-972b70a5 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1901 |  | DATA_OP | request.Parameters["PARAM1"] | clbDivisions.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-94c5725c | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1902 |  | DATA_OP | request.Parameters["PARAM2"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-90c11491 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1903 |  | DATA_OP | request.Parameters["PARAM3"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-820e3ada | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1904 |  | DATA_OP | request.Parameters["PARAM4"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-2a8242a5 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1905 |  | DATA_OP | request.Parameters["PARAM5"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-9a6858c2 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1906 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1fdae854 | InsertButton [if (siMain != null && siMain.IsLock(siMain.She… | DMF0007_CustFcstMaster.cs:1908 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0007_CustFcstMaster.GetSpdTitle

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (sSheetName == SpdSheet.shtMainFCST)] / this.Load [if (sSheetName == SpdSheet.shtMainFCST)] / clbDivisions.SelectedIndexChanged [if (sSheetName == SpdSheet.shtMainFCST)] / clbDivisions.SelectedIndexChanged [if (siMain != null) ▸ if (sSheetName == SpdSheet.shtMainFCST)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try ▸ if (sSheetName == SpdSheet.shtMainFCST)] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMai…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90e2fcdf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1850 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0007_GET_SPREAD_TITLE") ⇒ DM.DMF0007_GET_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-9733260d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1851 |  | DATA_OP | request.Parameters["p_plan_week"] | sPlanWeek | 행/컬럼 값 대입 |  |  |  |
| AC-02b60800 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1852 |  | DATA_OP | request.Parameters["p_bucket_type"] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-1dd32b5f | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1853 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-b6de1511 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1855 |  | FLAG | dtTitle | client.ExecuteDataSet(request).DataSet.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-0dfb8528 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1855 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-87f89d1c | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1865 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DMF0007", SpdSheet.shtMainPSI) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2bbcca64 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1867 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0007_CustFcstMaster.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3bbfa94 | this.Load | DMF0007_CustFcstMaster.cs:219 |  | FLAG | dtDivision | Data.Common(Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoCo… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-543673e8 | this.Load | DMF0007_CustFcstMaster.cs:219 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, UserInfoContext.Current["NowGroupID"], UserInfoContext.Curre… ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-408f3370 | this.Load | DMF0007_CustFcstMaster.cs:220 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivisions, false,"CODE","NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-7ed31e58 | this.Load | DMF0007_CustFcstMaster.cs:224 |  | FLAG | dtTeam | Data.UserTeamByDivision(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.Use… | 화면 필드/플래그 변경 |  |  |  |
| AC-8bd71c95 | this.Load | DMF0007_CustFcstMaster.cs:224 |  | COMBO_DATA | Data.UserTeamByDivision | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2b23c0f8 | this.Load | DMF0007_CustFcstMaster.cs:225 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-69fed15d | this.Load | DMF0007_CustFcstMaster.cs:231 | if (sDivision == "40") | FLAG | dtEndCustomer | Data.Common(Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 화면 필드/플래그 변경 |  |  |  |
| AC-cf101761 | this.Load | DMF0007_CustFcstMaster.cs:231 | if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-778c5af1 | this.Load | DMF0007_CustFcstMaster.cs:234 | else of (sDivision == "40") | FLAG | dtEndCustomer | Data.UserEndCustomerByDivisionDept(UserInfoContext.Current["NowGroupID"], UserInfoContext.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f657ae6f | this.Load | DMF0007_CustFcstMaster.cs:234 | else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDept | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8b7836ee | this.Load | DMF0007_CustFcstMaster.cs:237 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-19f6714d | this.Load | DMF0007_CustFcstMaster.cs:241 |  | FLAG | dtScmSite | Data.UserSiteByEndCustomer(UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.… | 화면 필드/플래그 변경 |  |  |  |
| AC-f802b10b | this.Load | DMF0007_CustFcstMaster.cs:241 |  | COMBO_DATA | Data.UserSiteByEndCustomer | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-318473b8 | this.Load | DMF0007_CustFcstMaster.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b7ac91fd | this.Load | DMF0007_CustFcstMaster.cs:244 |  | FLAG | dtBucketType | Data.Common(Data.Type.BucketType) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 화면 필드/플래그 변경 |  |  |  |
| AC-1affaa79 | this.Load | DMF0007_CustFcstMaster.cs:244 |  | COMBO_DATA | Data.Common | (Data.Type.BucketType) ⇒ biz:CommonData.CommonDataList [code=BucketType] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d09e3090 | this.Load | DMF0007_CustFcstMaster.cs:245 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-6f1c4776 | this.Load | DMF0007_CustFcstMaster.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b5818631 | this.Load | DMF0007_CustFcstMaster.cs:250 |  | FLAG | dtUploadUOM | Data.Common(Data.Type.UploadUOM) ⇒ biz:CommonData.CommonDataList [code=UploadUOM] | 화면 필드/플래그 변경 |  |  |  |
| AC-404a9861 | this.Load | DMF0007_CustFcstMaster.cs:250 |  | COMBO_DATA | Data.Common | (Data.Type.UploadUOM) ⇒ biz:CommonData.CommonDataList [code=UploadUOM] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |

## DMF0007_CustFcstMaster.InitSaveDataTable

진입점: this.Load / clbDivisions.SelectedIndexChanged / clbDivisions.SelectedIndexChanged [if (siMain != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c22d0bba | this.Load 외 2 | DMF0007_CustFcstMaster.cs:362 |  | FLAG | dtSave | new DataTable("CustomerFcstSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-192090d3 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:363 |  | DATA_OP | dtSave.Columns.Add | (CAppSetting.StringAction, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-954060f5 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:364 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.DivisionId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-88fac3ad | this.Load 외 2 | DMF0007_CustFcstMaster.cs:365 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.PlanWeek, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e60136a9 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:366 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerCode, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-18eb7302 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:367 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ScmSite, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-8fa2ce51 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:368 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.MeasureGroup, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c349256 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:369 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.Measure, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-85315669 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:370 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.ActiveFlag, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a6abf24d | this.Load 외 2 | DMF0007_CustFcstMaster.cs:371 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.CustomerPSI, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-82e07fb8 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:372 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UploadUOM, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-32ab2b46 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:373 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UploadBucketType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6891a939 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:374 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BucketType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-951cd9b6 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:375 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BucketValue, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-e4f27404 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:376 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.BucketYn, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-36784da2 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:377 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.EDIFCSTFlag, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-62be7892 | this.Load 외 2 | DMF0007_CustFcstMaster.cs:378 |  | DATA_OP | dtSave.Columns.Add | (DefColumns.UserId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0007_CustFcstMaster.InitSpread

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)] / this.Load / clbDivisions.SelectedIndexChanged / clbDivisions.SelectedIndexChanged [if (siMain != null)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) ▸ if (siMain.ActiveSheet.SheetName == SpdS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b41f3d39 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:339 | if (sSheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |
| AC-a0981646 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:344 | else of (sSheetName == SpdSheet.shtMainFCST) | FLAG | dtTitle | GetSpdTitle() | 화면 필드/플래그 변경 |  |  |  |
| AC-4a685ef9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:345 | else of (sSheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.CreateSheetHeaderColumn | (siMain, 2, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0007_CustFcstMaster.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cb482db3 | InsertButton | DMF0007_CustFcstMaster.cs:1247 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-e569ce63 | InsertButton | DMF0007_CustFcstMaster.cs:1254 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.DivisionId), sDivision) | 그리드 값 설정 |  |  |  |
| AC-b489d9c4 | InsertButton | DMF0007_CustFcstMaster.cs:1256 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.DivisionId), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-5bf10982 | InsertButton | DMF0007_CustFcstMaster.cs:1260 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | COMBO_DATA | Data.UserTeamByDivisionAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2ee922d9 | InsertButton | DMF0007_CustFcstMaster.cs:1271 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | COMBO_DATA | Data.Common | (Data.Type.EndCustomerByDivision40, false, sDivision, sTeam, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=EndCustomerByDivision40] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c62d429e | InsertButton | DMF0007_CustFcstMaster.cs:1272 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-31c2e5ca | InsertButton | DMF0007_CustFcstMaster.cs:1275 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sDivision == "40") | COMBO_DATA | Data.UserEndCustomerByDivisionDeptAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sTeam) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d36e7428 | InsertButton | DMF0007_CustFcstMaster.cs:1276 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sDivision == "40") | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CustomerCode), dtEndCustomerAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-271ea943 | InsertButton | DMF0007_CustFcstMaster.cs:1280 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | COMBO_DATA | Data.UserSiteByEndCustomerAuth | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sEndCus… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c35b5fb5 | InsertButton | DMF0007_CustFcstMaster.cs:1281 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSiteAuth) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-1e9a52af | InsertButton | DMF0007_CustFcstMaster.cs:1287 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain.Get… | GRID_COMBO | siMain.SetCellTypeCombo | (iRow, siMain.GetColumnIndex(DefColumns.Measure), GetCustFcstMeasure()) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-f716daff | InsertButton | DMF0007_CustFcstMaster.cs:1293 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.BucketType) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.BucketType), cboBucketType.SelectedValue) | 그리드 값 설정 |  |  |  |
| AC-1b707f06 | InsertButton | DMF0007_CustFcstMaster.cs:1294 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.BucketType) > 0) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.BucketType), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a81ccf12 | InsertButton | DMF0007_CustFcstMaster.cs:1301 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ if (siMain.Activ… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), "CUST_FCST") | 그리드 값 설정 |  |  |  |
| AC-8343a1de | InsertButton | DMF0007_CustFcstMaster.cs:1302 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ if (siMain.Activ… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a48d531a | InsertButton | DMF0007_CustFcstMaster.cs:1306 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ else of (siMain.… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), "PSI") | 그리드 값 설정 |  |  |  |
| AC-b07d6672 | InsertButton | DMF0007_CustFcstMaster.cs:1307 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.MeasureGroup) > 0) ▸ else of (siMain.… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.MeasureGroup), iRow, siMain.GetColumnIndex(DefColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-21ee7d7c | InsertButton | DMF0007_CustFcstMaster.cs:1312 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.EDIFCSTFlag) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.EDIFCSTFlag), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-fc2febcb | InsertButton | DMF0007_CustFcstMaster.cs:1317 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.ActiveFlag) > 0) | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.ActiveFlag), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-63e70771 | InsertButton | DMF0007_CustFcstMaster.cs:1322 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.GetColumnIndex(DefColumns.UpdateDate) > 0) | GRID_LOCK | siMain.LockRange | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.ActiveRowInde… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0007_CustFcstMaster.SaveData

진입점: SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74eee1cf | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:847 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1d6e855e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:849 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b4fc16c | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:858 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a927a28a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:860 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7b9d36b5 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:869 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7658e6f3 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:871 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-66ba3a38 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:880 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3236c532 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:882 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11cece01 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:891 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d65a10e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:893 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11266454 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:902 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-071109a8 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:904 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bca75348 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:913 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-140ec60a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:915 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ec2e887e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:924 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b93355c7 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:926 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-68491ce6 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:935 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b0065b5f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:937 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ for (iRow <= s… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6234141e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:951 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0007_SAVE_CUST_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-adac4852 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:952 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-fc9fd5a9 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:953 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-0a1f15f2 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:954 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_week"] | sPlanYYYYYWW | 행/컬럼 값 대입 |  |  |  |
| AC-badfb0f3 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:955 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_code"] | sCustomerCode | 행/컬럼 값 대입 |  |  |  |
| AC-6175e024 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:956 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-4e0897c2 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:957 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure_group"] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-dbd357aa | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:958 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-06ca427f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:959 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-84042d3d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:960 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_psi"] | sCustomerPSI | 행/컬럼 값 대입 |  |  |  |
| AC-05dacf40 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:961 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_uom"] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-521322b1 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:962 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_bucket_type"] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-9ad9e3d7 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:963 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_type"] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-9cf22506 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:964 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_value"] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-229f3333 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:965 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_yn"] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-d1b84728 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:966 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_edi_fcst_yn"] | sEDIFCSTFlag | 행/컬럼 값 대입 |  |  |  |
| AC-864596ec | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:967 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-28520770 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:969 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4d3b3a27 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:975 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ if (resp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00166") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3a51481a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:979 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ if (resp… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-86f3e49d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:985 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ else of … | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00015441 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:992 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ catch ((Except… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7f162516 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1000 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (sSheetName == SpdSheet.shtMainFCST) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00141") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b961a7a8 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1076 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5606fd51 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1078 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c837e13e | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1087 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3f3da1c3 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1089 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c997d9b9 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1098 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7a64d311 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1100 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9583458d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1109 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-758f7baf | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1111 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-61e1d004 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1120 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58e7a653 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1122 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3211e563 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1131 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23b1b11c | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1133 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2e2b2e80 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1142 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-674213be | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1144 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b32123c4 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1153 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-fc3e8aec | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1155 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2ff3fd5a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1164 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-47a161aa | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1166 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74e19ac6 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1175 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2e0b1858 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1177 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ for (iRow <= siMain.GetMaxR… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20b9a4fc | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1194 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0007_SAVE_CUST_FCST_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-d89c1e5d | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1195 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c732d3d8 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1196 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-d878e141 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1197 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plan_week"] | sPlanYYYYYWW | 행/컬럼 값 대입 |  |  |  |
| AC-e62c6195 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1198 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_code"] | sCustomerCode | 행/컬럼 값 대입 |  |  |  |
| AC-568e5378 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1199 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-2ab7a7a0 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1200 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure_group"] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-222bfcef | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1201 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_measure"] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-6b8933a0 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1202 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-fece7fad | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1203 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_customer_psi"] | sCustomerPSI | 행/컬럼 값 대입 |  |  |  |
| AC-345e6ace | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1204 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_uom"] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-57d331dc | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1205 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_upload_bucket_type"] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-dcdeaabd | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1206 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_type"] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-af00cb09 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1207 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_value"] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-b40ddeb8 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1208 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_summary_bucket_yn"] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-34db5c55 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1209 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_edi_fcst_yn"] | sEDIFCSTFlag | 행/컬럼 값 대입 |  |  |  |
| AC-3128590f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1210 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-f1d36f10 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1212 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a088253a | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1216 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ if … | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f43c85a3 | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1221 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ try ▸ els… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8e6c249b | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1228 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ if (iCount > 0) ▸ catch ((E… | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0e56286f | SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.sht… | DMF0007_CustFcstMaster.cs:1236 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ else of (sSheetName == SpdSheet.shtMainFCST) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00141") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0007_CustFcstMaster.SetChangeControl

진입점: this.clbEndCustomer.SelectedIndexChanged / this.clbTeam.SelectedIndexChanged / this.spdMain.ComboSelChange [if (e.Column == siMain.GetColumnIndex(DefColumns.CustomerCode))] / clbDivisions.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-709f139d | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:176 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-5e6f2e6c | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:177 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8495b650 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:183 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-73d9d568 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:183 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-9bf8c225 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:188 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-15895d6e | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:190 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-909c7402 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:190 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-932d0da4 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:195 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-843ca438 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:196 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f0be6652 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:198 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-ddeeb075 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:198 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-5fe1e604 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:203 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9630caac | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:205 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-550e564a | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:207 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtScmSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-e54e2437 | this.clbEndCustomer.SelectedIndexChanged 외 3 | DMF0007_CustFcstMaster.cs:207 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0007_CustFcstMaster.SetSaveData

진입점: dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Column > 0 && e.Column <= siMain.GetColumnIndex(DefColumns.Measure)) ▸ else of (this.CanModelChange && e.Row > -1 && e.Column == siMain.GetColumnIndex(DefColumns.ActiveFlag)) ▸ if (this.CanModelChange && e.Row > -1 && e.Column > siMain.GetColumnIndex(DefColumns.ActiveFlag))]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9402ad6b | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1812 |  | DATA_OP | dtSave.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-01289be0 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1816 | if (drFind.Length == 0) | DATA_OP | dtSave.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-33332828 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1817 | if (drFind.Length == 0) | DATA_OP | drNew[CAppSetting.StringAction] | sActionFlag | 행/컬럼 값 대입 |  |  |  |
| AC-23663c9e | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1818 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.DivisionId] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6a27dff9 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1819 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.PlanWeek] | sPlanWeek | 행/컬럼 값 대입 |  |  |  |
| AC-8f6be61a | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1820 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerCode] | sCustomerCode | 행/컬럼 값 대입 |  |  |  |
| AC-272e7bc4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1821 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ScmSite] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-c163b098 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1822 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.MeasureGroup] | sMeasureGroup | 행/컬럼 값 대입 |  |  |  |
| AC-6a852db7 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1823 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Measure] | sMeasure | 행/컬럼 값 대입 |  |  |  |
| AC-cf002d37 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1824 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ActiveFlag] | sActiveFlag | 행/컬럼 값 대입 |  |  |  |
| AC-61defcb4 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1825 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.CustomerPSI] | sCustomerPSI | 행/컬럼 값 대입 |  |  |  |
| AC-92785159 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1826 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.UploadUOM] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-92b766ac | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1827 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.UploadBucketType] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-3dc85bed | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1828 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketType] | sBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-916ae449 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1829 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketValue] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-bf1db1a1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1830 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketYn] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-8465c2dc | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1831 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.EDIFCSTFlag] | sEDIFCSTFlag | 행/컬럼 값 대입 |  |  |  |
| AC-c3d4d68d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1833 | if (drFind.Length == 0) | DATA_OP | dtSave.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-f79423dc | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1834 | if (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fea3b6b1 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1838 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.UploadUOM] | sUploadUOM | 행/컬럼 값 대입 |  |  |  |
| AC-e69bfc8d | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1839 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.UploadBucketType] | sUploadBucketType | 행/컬럼 값 대입 |  |  |  |
| AC-f56237b3 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1840 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketValue] | sBucketValue | 행/컬럼 값 대입 |  |  |  |
| AC-f2255548 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1841 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketYn] | sBucketYn | 행/컬럼 값 대입 |  |  |  |
| AC-3b822021 | dsdm.Changed [switch (e.Type) case FarPoint.Win.Spread.Model… | DMF0007_CustFcstMaster.cs:1842 | else of (drFind.Length == 0) | DATA_OP | dtSave.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0007_CustFcstMaster.SetSpreadColor

진입점: this.cboBucketType.SelectedIndexChanged [if (siMain != null) ▸ if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (sSheetName == SpdSheet.shtMainFCST)] / this.Load [if (sSheetName == SpdSheet.shtMainFCST)] / clbDivisions.SelectedIndexChanged [if (sSheetName == SpdSheet.shtMainFCST)] / clbDivisions.SelectedIndexChanged [if (siMain != null) ▸ if (sSheetName == SpdSheet.shtMainFCST)] / FindButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ try] / SaveButton [if (siMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) ▸ if (siMain != null && siMain.IsLock(siMain.SheetNam…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0f19da40 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1873 | if (siMain.ActiveSheet.SheetName != SpdSheet.shtMainFCST) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bf23adb | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1875 | if (cboBucketType.SelectedValue.ToString() != BucketType.Daily) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7288bbe6 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1877 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-6e304ba9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1884 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-272740c9 | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1884 | for (iCol <= siMain.GetMaxColumnIndex()) | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d52fe9bf | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1886 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday \|\| siMain.GetColumnText(0, iCol) … | GRID_SET | siMain.ActiveSheet.ColumnHeader.Cells[0, iCol, 1, iCol].ForeColor | siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-1e92a0ed | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1886 | for (iCol <= siMain.GetMaxColumnIndex()) ▸ if (siMain.GetColumnText(0, iCol) == DefColumnsLabel.Saturday \|\| siMain.GetColumnText(0, iCol) … | CALL_EXT | siMain.GetColumnText | (0, iCol) | ⚠ 의미 확인 필요 |  |  |  |
| AC-2472725d | this.cboBucketType.SelectedIndexChanged [if (siMain != null)… 외 5 | DMF0007_CustFcstMaster.cs:1890 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0007_CustFcstMaster.shtMainFCSTDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-623a9981 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1332 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a6b9f244 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1343 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00379") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb930bc3 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1345 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-f9da3cc9 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1347 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0eaa2daf | dsdm.Changed | DMF0007_CustFcstMaster.cs:1380 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | MESSAGE | MessageHelper.GMessageBox | ("MSG00136") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-efa1b32a | dsdm.Changed | DMF0007_CustFcstMaster.cs:1382 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-c8302a47 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1384 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column > 0… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1ab8ae47 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1403 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetText | (e.Row, iCOl, sActiveFlag) | 그리드 값 설정 |  |  |  |
| AC-184f658b | dsdm.Changed | DMF0007_CustFcstMaster.cs:1421 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6c945a8c | dsdm.Changed | DMF0007_CustFcstMaster.cs:1430 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetText | (e.Row, iCol, sActiveFlag) | 그리드 값 설정 |  |  |  |
| AC-232c3263 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1461 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetValue | (e.Row, e.Column, sBucketYn) | 그리드 값 설정 |  |  |  |
| AC-73869e4b | dsdm.Changed | DMF0007_CustFcstMaster.cs:1471 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2f27e5fc | dsdm.Changed | DMF0007_CustFcstMaster.cs:1473 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-403c53b9 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1482 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-15e32363 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1484 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dde97029 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1493 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1f0c8b2 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1495 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6456503e | dsdm.Changed | DMF0007_CustFcstMaster.cs:1504 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8c07883e | dsdm.Changed | DMF0007_CustFcstMaster.cs:1506 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d0af03ac | dsdm.Changed | DMF0007_CustFcstMaster.cs:1515 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a712e6c7 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1517 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b9a6332f | dsdm.Changed | DMF0007_CustFcstMaster.cs:1526 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55f3ea24 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1528 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fed57af | dsdm.Changed | DMF0007_CustFcstMaster.cs:1537 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-3d849bef | dsdm.Changed | DMF0007_CustFcstMaster.cs:1539 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1e29613b | dsdm.Changed | DMF0007_CustFcstMaster.cs:1548 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c5baed32 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1550 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-11daf831 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1559 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-48b8d13a | dsdm.Changed | DMF0007_CustFcstMaster.cs:1561 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-32b014bb | dsdm.Changed | DMF0007_CustFcstMaster.cs:1582 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | MESSAGE | MessageHelper.GMessageBox | ("MSG00136") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35c526f1 | dsdm.Changed | DMF0007_CustFcstMaster.cs:1584 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-f6271f1d | dsdm.Changed | DMF0007_CustFcstMaster.cs:1586 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (this.CanModelChange && e.Row > -1 && e.Colum… | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0007_CustFcstMaster.shtMainPSIDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3491b906 | dsdm2.Changed | DMF0007_CustFcstMaster.cs:1600 | if (!this.CanModelChange) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a57a044 | dsdm2.Changed | DMF0007_CustFcstMaster.cs:1602 | if (e.Column <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-574ecbb3 | dsdm2.Changed | DMF0007_CustFcstMaster.cs:1630 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-60ec390f | dsdm2.Changed | DMF0007_CustFcstMaster.cs:1648 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | MESSAGE | MessageHelper.GMessageBox | ("MSG00136") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d723d562 | dsdm2.Changed | DMF0007_CustFcstMaster.cs:1649 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | GRID_SET | siMain.SetText | (e.Row, e.Column, "") | 그리드 값 설정 |  |  |  |
| AC-a1445506 | dsdm2.Changed | DMF0007_CustFcstMaster.cs:1651 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (this.CanModelChange && e.Row > -1 && e.Column <= … | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0007_CustFcstMaster.spdMain_ActiveSheetChanged

진입점: this.spdMain.ActiveSheetChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e6dc417e | this.spdMain.ActiveSheetChanged | DMF0007_CustFcstMaster.cs:1785 | if (siMain == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-958b945b | this.spdMain.ActiveSheetChanged | DMF0007_CustFcstMaster.cs:1789 | if (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainFCST) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9c5b7257 | this.spdMain.ActiveSheetChanged | DMF0007_CustFcstMaster.cs:1793 | else of (spdMain.ActiveSheet.SheetName == SpdSheet.shtMainFCST) | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMainPSI) | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0007_CustFcstMaster.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a742b0f3 | this.spdMain.ComboSelChange | DMF0007_CustFcstMaster.cs:1693 | if (e.Column == siMain.GetColumnIndex(DefColumns.CustomerCode)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.ScmSite), dtScmSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

