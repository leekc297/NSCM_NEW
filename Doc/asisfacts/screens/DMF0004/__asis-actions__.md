# AS-IS 액션 대조표 — DMF0004

> 원천: `Doc/asisfacts/screens/DMF0004/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 507행 · 메서드 48 · 종류 DATA_OP 104 · GRID_SET 66 · MESSAGE 53 · RETURN 46 · GRID_LOCK 40 · FLAG 30 · UI_PROP 30 · ENDPOINT 26 · GRID_INIT 19 · POPUP 18 · LIST_REBIND 17 · COMBO_DATA 17 · UI_MISC 15 · STATE 9 · GRID_COMBO 7 · GRID_BIND 4 · CALL_EXT 3 · VALUE_SET 1 · THROW 1 · STATE_RESET 1 · ⚠ 의미 확인 필요 3


## DMF0004_SalesSite.cboDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db28c86a | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2149 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-57c16128 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2156 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-fe12cc24 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2165 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f5be1a55 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2167 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblTeam.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-ebdffd82 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2168 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblEndCustomer.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-b0096907 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2176 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7329777f | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2178 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-bd4b7da7 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2179 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-5c01fdf9 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2185 |  | FLAG | dtSoldToCustomer | GetSoldToCustomerData() | 화면 필드/플래그 변경 |  |  |  |
| AC-b5f48627 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2186 |  | LIST_REBIND | clsCtrl.setListBox | (dtSoldToCustomer, clbSoldToCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb79af0f | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2188 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-b0fcb6cb | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2188 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d428c713 | cboDivision.SelectedIndexChanged | DMF0004_SalesSite.cs:2190 |  | GRID_SET | siMain.ActiveSheet.RowCount | 0 | 그리드 속성/값 설정 |  |  |  |

## DMF0004_SalesSite.chkDetail_CheckedChanged

진입점: this.chkDetail.CheckedChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03318072 | this.chkDetail.CheckedChanged | DMF0004_SalesSite.cs:2694 |  | UI_PROP | splitContainer1.Panel2Collapsed | !chkDetail.Checked | 속성 Panel2Collapsed 설정 |  |  |  |

## DMF0004_SalesSite.clbEndCustomer_SelectedIndexChanged

진입점: this.clbEndCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d465fa80 | this.clbEndCustomer.SelectedIndexChanged | DMF0004_SalesSite.cs:2261 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0004_SalesSite.clbSoldToCustomer_SelectedIndexChanged

진입점: this.clbSoldToCustomer.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-53590af5 | this.clbSoldToCustomer.SelectedIndexChanged | DMF0004_SalesSite.cs:2269 |  | COMBO_DATA | Data.SiteByEndCustomerSold | (UserInfoContext.Current["NowGroupID"], UserInfoContext.Current.UserId, sDivision, sSoldTo… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6f7fa948 | this.clbSoldToCustomer.SelectedIndexChanged | DMF0004_SalesSite.cs:2270 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0004_SalesSite.clbTeam_SelectedIndexChanged

진입점: this.clbTeam.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dbaed347 | this.clbTeam.SelectedIndexChanged | DMF0004_SalesSite.cs:2238 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-447ea417 | this.clbTeam.SelectedIndexChanged | DMF0004_SalesSite.cs:2246 |  | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-adf70aca | this.clbTeam.SelectedIndexChanged | DMF0004_SalesSite.cs:2248 |  | FLAG | dtSoldToCustomer | GetSoldToCustomerData() | 화면 필드/플래그 변경 |  |  |  |
| AC-0311fae4 | this.clbTeam.SelectedIndexChanged | DMF0004_SalesSite.cs:2249 |  | LIST_REBIND | clsCtrl.setListBox | (dtSoldToCustomer, clbSoldToCustomer, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0004_SalesSite.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13012ee6 | this.Load | DMF0004_SalesSite.cs:395 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-943b20bd | this.Load | DMF0004_SalesSite.cs:396 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-18667bce | this.Load | DMF0004_SalesSite.cs:400 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubCustomer, SpdSheet.shtSubCustomer, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-077600d2 | this.Load | DMF0004_SalesSite.cs:401 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubLocation, SpdSheet.shtSubLocation, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d8e204ad | this.Load | DMF0004_SalesSite.cs:402 |  | GRID_INIT | this.AddSheet | (spdSub, SpdSheet.shtSubBucket, SpdSheet.shtSubBucket, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-b0e7ddcd | this.Load | DMF0004_SalesSite.cs:404 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubCustomer) | 화면 필드/플래그 변경 |  |  |  |
| AC-350c4f12 | this.Load | DMF0004_SalesSite.cs:405 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubLocation) | 화면 필드/플래그 변경 |  |  |  |
| AC-e2c5d5e7 | this.Load | DMF0004_SalesSite.cs:406 |  | FLAG | siSub | GetSheetInfo(spdSub.Name, SpdSheet.shtSubBucket) | 화면 필드/플래그 변경 |  |  |  |
| AC-45b12b1b | this.Load | DMF0004_SalesSite.cs:408 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ae4791d6 | this.Load | DMF0004_SalesSite.cs:411 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e82c1f56 | this.Load | DMF0004_SalesSite.cs:414 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6639dbc7 | this.Load | DMF0004_SalesSite.cs:417 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-52cfea93 | this.Load | DMF0004_SalesSite.cs:421 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0004_SalesSite.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5a659ea | this.Load | DMF0004_SalesSite.cs:376 |  | UI_PROP | usrConditionPanel1.Height | 45 | 속성 Height 설정 |  |  |  |
| AC-09ff168d | this.Load | DMF0004_SalesSite.cs:377 |  | STATE | usrConditionPanel2.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-3102c206 | this.Load | DMF0004_SalesSite.cs:378 |  | VALUE_SET | chkDetail.Checked | true | 컨트롤 값 설정 |  |  |  |
| AC-6236a406 | this.Load | DMF0004_SalesSite.cs:380 |  | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74b56a08 | this.Load | DMF0004_SalesSite.cs:382 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | FLAG | sMyDeptID | Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Cu… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 화면 필드/플래그 변경 |  |  |  |
| AC-f7e34114 | this.Load | DMF0004_SalesSite.cs:382 | if (Data.Common(Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId) != null) | COMBO_DATA | Data.Common | (Data.Type.Auth_Dept, false, UserInfoContext.Current.UserId, UserInfoContext.Current["NowG… ⇒ biz:CommonData.CommonDataList [code=Auth_Dept] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-40d425c2 | this.Load | DMF0004_SalesSite.cs:385 |  | UI_PROP | siSub.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-8c6214d5 | this.Load | DMF0004_SalesSite.cs:387 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-72d46db3 | this.Load | DMF0004_SalesSite.cs:388 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siSub.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-353157a2 | this.Load | DMF0004_SalesSite.cs:389 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |
| AC-f431e197 | this.Load | DMF0004_SalesSite.cs:390 |  | UI_PROP | cellTypeImage.CharacterCasing | CharacterCasing.Upper | 속성 CharacterCasing 설정 |  |  |  |

## DMF0004_SalesSite.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e178bf33 | DeleteButton | DMF0004_SalesSite.cs:506 | if (fps.Name == "spdMain") ▸ if (siMain.GetText(siMain.ActiveRowIndex, siMain.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Strin… | CALL_EXT | siMain.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-7cb8342d | DeleteButton | DMF0004_SalesSite.cs:513 | else of (fps.Name == "spdMain") ▸ if (siSub.GetText(siSub.ActiveRowIndex, siSub.GetColumnIndex(CAppSetting.StringAction)) == CAppSetting.Str… | CALL_EXT | siSub.DeleteRow | () | ⚠ 의미 확인 필요 |  |  |  |

## DMF0004_SalesSite.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03b2b797 | Dispose | DMF0004_SalesSite.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## DMF0004_SalesSite.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-02523aac | EditButton | DMF0004_SalesSite.cs:526 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siSub.ActiveSheet.SheetName, siMain.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0df5498c | EditButton | DMF0004_SalesSite.cs:527 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-79c2b0b7 | EditButton | DMF0004_SalesSite.cs:530 | if (fps != null) ▸ if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-71daa72d | EditButton | DMF0004_SalesSite.cs:531 | if (fps != null) ▸ if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d1c985ed | EditButton | DMF0004_SalesSite.cs:543 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ if (sDivision == "8… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetColumnI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ec211fe7 | EditButton | DMF0004_SalesSite.cs:544 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ if (sDivision == "8… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.UpdateDate), siMain.GetMaxRowIndex(), siMain.GetMaxCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c15d7cba | EditButton | DMF0004_SalesSite.cs:548 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ else of (sDivision … | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefColumns.Division), siMain.GetMaxRowIndex(), siMain.GetMaxColu… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b16887b6 | EditButton | DMF0004_SalesSite.cs:562 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c9ca637e | EditButton | DMF0004_SalesSite.cs:563 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.EndCustomer), iRow, siMain.GetColumnIndex(DefColum… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d9ba4578 | EditButton | DMF0004_SalesSite.cs:569 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0808b5e4 | EditButton | DMF0004_SalesSite.cs:572 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.RepSoldToCode), iRow, siMain.GetColumnIndex(DefCol… | 그리드 편집 잠금/해제 |  |  |  |
| AC-00aa00a1 | EditButton | DMF0004_SalesSite.cs:573 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.UpdateDate), iRow, siMain.GetColumnIndex(DefColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e6ab29b3 | EditButton | DMF0004_SalesSite.cs:578 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.ValidYn), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-594cf145 | EditButton | DMF0004_SalesSite.cs:585 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= s… | GRID_LOCK | siMain.LockRange | (iRow, siMain.GetColumnIndex(DefColumns.Division), iRow, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-19b0723b | EditButton | DMF0004_SalesSite.cs:600 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-205844c7 | EditButton | DMF0004_SalesSite.cs:601 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e5149078 | EditButton | DMF0004_SalesSite.cs:606 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00130", new object[] { siMain.ActiveSheet.SheetName, siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1a50cad | EditButton | DMF0004_SalesSite.cs:607 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a59b29cb | EditButton | DMF0004_SalesSite.cs:618 | if (fps != null) ▸ if (fps.Name == "spdSub") | FLAG | siSub | GetSheetInfo(spdSub.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-96001d91 | EditButton | DMF0004_SalesSite.cs:619 | if (fps != null) ▸ if (fps.Name == "spdSub") | GRID_LOCK | siSub.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-d9c2ae74 | EditButton | DMF0004_SalesSite.cs:635 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Sh… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a016018d | EditButton | DMF0004_SalesSite.cs:636 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-dbd1186a | EditButton | DMF0004_SalesSite.cs:642 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockColumn | (siSub.GetColumnIndex(DefColumns.ValidYn), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-7b973aa6 | EditButton | DMF0004_SalesSite.cs:648 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowInd… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |
| AC-a69ef1b6 | EditButton | DMF0004_SalesSite.cs:662 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.St… | 그리드 편집 잠금/해제 |  |  |  |
| AC-87755e61 | EditButton | DMF0004_SalesSite.cs:663 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-ca5163b7 | EditButton | DMF0004_SalesSite.cs:668 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.Shee… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c1e4ea5e | EditButton | DMF0004_SalesSite.cs:684 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.In… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7077edb | EditButton | DMF0004_SalesSite.cs:685 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.UpdateDate), iRow, siSub.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-bc92933d | EditButton | DMF0004_SalesSite.cs:690 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet… | GRID_LOCK | siSub.LockRange | (iRow, siSub.GetColumnIndex(DefColumns.Division), iRow, siSub.GetColumnIndex(DefColumns.Ed… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0004_SalesSite.ExcelButton

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb7bdd88 | ExcelButton | DMF0004_SalesSite.cs:739 |  | UI_PROP | exportOption.Merge | ExcelMergeOption.None | 속성 Merge 설정 |  |  |  |
| AC-a2fe6bcc | ExcelButton | DMF0004_SalesSite.cs:740 |  | UI_PROP | exportOption.Border | ExcelBorderOption.All | 속성 Border 설정 |  |  |  |
| AC-ce72dadf | ExcelButton | DMF0004_SalesSite.cs:741 |  | UI_PROP | exportOption.AheadZeroOption | ZeroOption.HideZero | 속성 AheadZeroOption 설정 |  |  |  |
| AC-598ecfa6 | ExcelButton | DMF0004_SalesSite.cs:742 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-4eac8e70 | ExcelButton | DMF0004_SalesSite.cs:743 |  | UI_PROP | exportOption.AmendNullToZero | false | 속성 AmendNullToZero 설정 |  |  |  |
| AC-dbbd80a6 | ExcelButton | DMF0004_SalesSite.cs:744 |  | UI_PROP | exportOption.AheadNullToZero | false | 속성 AheadNullToZero 설정 |  |  |  |
| AC-88dbeaee | ExcelButton | DMF0004_SalesSite.cs:745 |  | UI_PROP | exportOption.AmendZeroOption | ZeroOption.ShowZero | 속성 AmendZeroOption 설정 |  |  |  |
| AC-1a2cd66a | ExcelButton | DMF0004_SalesSite.cs:747 |  | UI_PROP | exportOption.UserName | UserInfo.UserId | 속성 UserName 설정 |  |  |  |
| AC-a2a3fc64 | ExcelButton | DMF0004_SalesSite.cs:748 |  | UI_PROP | exportOption.FileName | sFileName | 속성 FileName 설정 |  |  |  |
| AC-3b9932c7 | ExcelButton | DMF0004_SalesSite.cs:750 |  | UI_PROP | exportOption.AmendDecimalFormat | "#,##0;[Red]-#,##0" | 속성 AmendDecimalFormat 설정 |  |  |  |
| AC-77417311 | ExcelButton | DMF0004_SalesSite.cs:754 | try | CALL_EXT | SimplexelService.ExportFpSpread | (fps, exportOption) | ⚠ 의미 확인 필요 |  |  |  |
| AC-fa979832 | ExcelButton | DMF0004_SalesSite.cs:759 | catch ((Exception e)) | THROW | throw e; |  | 예외 발생 |  |  |  |
| AC-fedc1eed | ExcelButton | DMF0004_SalesSite.cs:763 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0004_SalesSite.FindButton

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8916babc | FindButton | DMF0004_SalesSite.cs:471 | if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0004_SalesSite.FindData_Main

진입점: FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-478deafa | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:774 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4044e752 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:775 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-d64a1198 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:779 |  | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-922faee8 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:790 | if (sDivisionID == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00097") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c20e1181 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:792 | if (sDivisionID == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce314692 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:799 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f0fe1b6d | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:801 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30062d01 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:805 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SALES_SITE_DATA") ⇒ DM.DMF0004_GET_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-7a907b41 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:806 | lambda | UI_PROP | request.CommandTimeout | 10 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-cca2964c | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:807 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-5a146b33 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:808 | lambda | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d3eff4c6 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:809 | lambda | DATA_OP | request.Parameters["p_end_customer"] | clbEndCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-d53f1219 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:810 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | clbSalesSite.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-ec24a47e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:811 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-9f97324e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:812 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-d642b299 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:813 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-fa20b8b6 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:814 | lambda | DATA_OP | request.Parameters["p_soldto_customer"] | clbSoldToCustomer.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-62be70ce | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:815 | lambda | DATA_OP | request.Parameters["p_user_dept_id"] | UserInfoContext.Current["Dept_ID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-c96174df | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:817 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-726bb5c3 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:819 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f896db08 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:826 |  | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-070e9e98 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:827 |  | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c686c36e | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:829 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1197475f | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:836 |  | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-621b48e0 | FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] 외 1 | DMF0004_SalesSite.cs:838 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0004_SalesSite.FindData_SubBucket

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSh…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dcdebf00 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:956 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubBucket) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-58134db9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:963 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-35066afe | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:967 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SALES_SITE_BUCKET_DATA") ⇒ DM.DMF0004_GET_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-2518c351 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:969 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-6b7c0dbc | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:970 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-d46a32b9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:971 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-c1675e66 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:972 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-1c6a58b3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:974 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4b94336e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:976 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f8c06843 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:983 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-62485116 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:984 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-9c5c6fba | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:986 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70475f04 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:993 |  | STATE_RESET | dtSubBucket.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |

## DMF0004_SalesSite.FindData_SubCustomer

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c6fdfea8 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:843 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7ea355c5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:844 |  | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-96a0e4eb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:848 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-f54de7d3 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:852 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubCustomer) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-167350b7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:858 |  | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-5079d79c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:859 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-6083102a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:863 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA") ⇒ DM.DMF0004_GET_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-5ca579a1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:865 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-647c863c | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:866 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-14ed0738 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:867 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-0ac063ac | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:868 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-e3a94811 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:869 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-e478a013 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:871 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-98185eea | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:873 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-d0a2d895 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:880 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-9b6c9fc9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:881 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-c7382662 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:885 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.SoldToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-7765879e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:886 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.ShipToCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3927dcab | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:894 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-72592fce | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:895 |  | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## DMF0004_SalesSite.FindData_SubLocation

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / FindButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub != null && siS…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18ca1ed7 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:902 |  | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-466e506b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:906 |  | GRID_INIT | siSub.ChangeSheet | (SpdSheet.shtSubLocation) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8617b58d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:913 |  | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, sBinding)) { va… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-57959c3b | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:917 | lambda | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SALES_SITE_LOCATION_DATA") ⇒ DM.DMF0004_GET_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-025dedbb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:919 | lambda | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-9e1c7ac9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:920 | lambda | DATA_OP | request.Parameters["p_scm_site_id"] | sScmSite | 행/컬럼 값 대입 |  |  |  |
| AC-5511d905 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:921 | lambda | DATA_OP | request.Parameters["p_active_flag"] | sActive | 행/컬럼 값 대입 |  |  |  |
| AC-b0159e3d | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:922 | lambda | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-3c82bca1 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:923 | lambda | DATA_OP | request.Parameters["p_userinfo"] | UserInfoContext.Current["NowGroupID"].ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-69905381 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:925 | lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-1ebd14d9 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:927 | lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-9535c08a | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:934 |  | GRID_BIND | siSub.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-41ce7f51 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:935 |  | GRID_LOCK | siSub.LockColumn | (0, siSub.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0944e614 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:939 | for (iRow <= siSub.GetMaxRowIndex()) | GRID_SET | siSub.ActiveSheet.Cells[iRow, siSub.GetColumnIndex(DefColumns.LocationCode)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-4c188625 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 2 | DMF0004_SalesSite.cs:947 |  | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0004_SalesSite.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8deff401 | this.Load | DMF0004_SalesSite.cs:256 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-760e66d8 | this.Load | DMF0004_SalesSite.cs:257 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## DMF0004_SalesSite.GetPlantbyDivision

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d43f126a | (진입점 미연결) | DMF0004_SalesSite.cs:2740 |  | ENDPOINT | new FoxDataRequest | ("SCM.SCM0001_GET_PLANT_BY_DIVISION") ⇒ SCM.SCM0001_GET_PLANT_BY_DIVISION | 엔드포인트 요청 생성 |  |  |  |
| AC-b06a4ac8 | (진입점 미연결) | DMF0004_SalesSite.cs:2741 |  | DATA_OP | request.Parameters["p_division_id"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-5feab2f0 | (진입점 미연결) | DMF0004_SalesSite.cs:2742 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a02f4ad9 | (진입점 미연결) | DMF0004_SalesSite.cs:2745 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0004_SalesSite.GetSoldToCustomerData

진입점: this.clbTeam.SelectedIndexChanged / this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fccf6692 | this.clbTeam.SelectedIndexChanged 외 2 | DMF0004_SalesSite.cs:2754 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA") ⇒ DM.DMF0004_GET_SOLDTO_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0b045520 | this.clbTeam.SelectedIndexChanged 외 2 | DMF0004_SalesSite.cs:2755 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-883ad254 | this.clbTeam.SelectedIndexChanged 외 2 | DMF0004_SalesSite.cs:2756 |  | DATA_OP | request.Parameters["p_dept_id"] | clbTeam.ControlValues | 행/컬럼 값 대입 |  |  |  |
| AC-3ce58108 | this.clbTeam.SelectedIndexChanged 외 2 | DMF0004_SalesSite.cs:2757 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-842b40ab | this.clbTeam.SelectedIndexChanged 외 2 | DMF0004_SalesSite.cs:2760 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0004_SalesSite.GetSpdTitle

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / cboDivision.SelectedIndexChanged / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-424d2208 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2719 |  | ENDPOINT | new FoxDataRequest | ("DM.DMF0000_GET_COMMON_SPREAD_TITLE") ⇒ DM.DMF0000_GET_COMMON_SPREAD_TITLE | 엔드포인트 요청 생성 |  |  |  |
| AC-abb506ad | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2720 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-ac318c7e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2721 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-36fbafab | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2722 |  | DATA_OP | request.Parameters["p_created_by"] | base.UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-53fd57b5 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2724 |  | DATA_OP | request.Parameters["p_program_id"] | "DMF0004" | 행/컬럼 값 대입 |  |  |  |
| AC-1bfb16cb | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2725 |  | DATA_OP | request.Parameters["p_sheet_name"] | sheetname | 행/컬럼 값 대입 |  |  |  |
| AC-d8027d81 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2726 |  | DATA_OP | request.Parameters["p_division_id"] | cboDivision.SelectedValue | 행/컬럼 값 대입 |  |  |  |
| AC-7c31d711 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2728 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-7a469513 | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:2730 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## DMF0004_SalesSite.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ae99b02 | this.Load | DMF0004_SalesSite.cs:327 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-787a9181 | this.Load | DMF0004_SalesSite.cs:333 |  | LIST_REBIND | clsCtrl.setListBox | (dtTeam, clbTeam, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d3f7a48b | this.Load | DMF0004_SalesSite.cs:340 |  | LIST_REBIND | clsCtrl.setListBox | (dtEndCustomer, clbEndCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-20c3fe32 | this.Load | DMF0004_SalesSite.cs:349 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-3f7fb758 | this.Load | DMF0004_SalesSite.cs:351 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblTeam.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-bdd20c8e | this.Load | DMF0004_SalesSite.cs:352 | if ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblEndCustomer.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-acf81362 | this.Load | DMF0004_SalesSite.cs:359 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | LIST_REBIND | clsCtrl.setListBox | (dtSalesSite, clbSalesSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-48aa58b9 | this.Load | DMF0004_SalesSite.cs:361 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblTeam.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-233a69ba | this.Load | DMF0004_SalesSite.cs:362 | else of ((sDivision.Substring(0, 2) == "81") \|\| (sDivision == "82")) | STATE | lblEndCustomer.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-7fa94ec8 | this.Load | DMF0004_SalesSite.cs:365 |  | FLAG | dtSoldToCustomer | GetSoldToCustomerData() | 화면 필드/플래그 변경 |  |  |  |
| AC-7cbe4d18 | this.Load | DMF0004_SalesSite.cs:366 |  | LIST_REBIND | clsCtrl.setListBox | (dtSoldToCustomer, clbSoldToCustomer, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f67541e6 | this.Load | DMF0004_SalesSite.cs:368 |  | FLAG | dtSoldTo | Data.Common(Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-b805c862 | this.Load | DMF0004_SalesSite.cs:368 |  | COMBO_DATA | Data.Common | (Data.Type.MyDivision, false, cboDivision.ControlValues) ⇒ biz:CommonData.CommonDataList [code=MyDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-341dc1fe | this.Load | DMF0004_SalesSite.cs:370 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true) | 목록 컨트롤 재구성 |  |  |  |

## DMF0004_SalesSite.InitSaveDataTable

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31c06169 | this.Load | DMF0004_SalesSite.cs:448 |  | FLAG | dtSubBucket | new DataTable("SubSubBucketSave") | 화면 필드/플래그 변경 |  |  |  |
| AC-b2592dd2 | this.Load | DMF0004_SalesSite.cs:449 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Division, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-397db93f | this.Load | DMF0004_SalesSite.cs:450 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.SiteId, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e8dd2a5 | this.Load | DMF0004_SalesSite.cs:451 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.Incoterms, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-51fc509f | this.Load | DMF0004_SalesSite.cs:452 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.YYYYMMDD, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-0ec12fb3 | this.Load | DMF0004_SalesSite.cs:453 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.BucketPer, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |
| AC-a9c05ecf | this.Load | DMF0004_SalesSite.cs:454 |  | DATA_OP | dtSubBucket.Columns.Add | (DefColumns.ConversionType, typeof(string)) | 데이터 객체 조작/조회 |  |  |  |

## DMF0004_SalesSite.InitSpread

진입점: this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / this.Load / cboDivision.SelectedIndexChanged / FindButton [if (fps != null) ▸ if (fps.Name == "spdMain")] / SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a715f22f | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:426 |  | FLAG | dtTitle | GetSpdTitle(spreadInfo.ActiveSheet.SheetName) | 화면 필드/플래그 변경 |  |  |  |
| AC-8beaef5e | this.spdMain.CellDoubleClick [if (siMain.IsLock(siMain.Sheet… 외 4 | DMF0004_SalesSite.cs:427 |  | GRID_INIT | spreadInfo.CreateSheetHeaderColumn | (spreadInfo, 1, dtTitle) | 그리드 재구성/초기화 |  |  |  |

## DMF0004_SalesSite.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e9f41ea3 | InsertButton | DMF0004_SalesSite.cs:1860 | if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | MESSAGE | MessageHelper.GMessageBox | ("MSG00096") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc7f8ddf | InsertButton | DMF0004_SalesSite.cs:1861 | if (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-88f7f83e | InsertButton | DMF0004_SalesSite.cs:1871 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-02a6fb4d | InsertButton | DMF0004_SalesSite.cs:1873 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-514d3d90 | InsertButton | DMF0004_SalesSite.cs:1879 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CountryNa… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-afce092e | InsertButton | DMF0004_SalesSite.cs:1881 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CityName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-e7f273f8 | InsertButton | DMF0004_SalesSite.cs:1883 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-f55b7eac | InsertButton | DMF0004_SalesSite.cs:1885 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.VmiYn), CAppSetting.StringN) | 그리드 값 설정 |  |  |  |
| AC-a73f3676 | InsertButton | DMF0004_SalesSite.cs:1887 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_SET | siMain.SetValue | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.Division), cboDivision.ControlVal… | 그리드 값 설정 |  |  |  |
| AC-787abdb3 | InsertButton | DMF0004_SalesSite.cs:1891 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.Ge… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-5c7baf98 | InsertButton | DMF0004_SalesSite.cs:1891 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInde… ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ba7abda7 | InsertButton | DMF0004_SalesSite.cs:1893 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_SET | siMain.ActiveSheet.Cells[siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.TeamName)… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-2d56b286 | InsertButton | DMF0004_SalesSite.cs:1895 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-55c283ea | InsertButton | DMF0004_SalesSite.cs:1895 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.GetColumnInd… ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-52bd119a | InsertButton | DMF0004_SalesSite.cs:1898 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-433977e3 | InsertButton | DMF0004_SalesSite.cs:1899 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-4265bd7e | InsertButton | DMF0004_SalesSite.cs:1901 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | FLAG | dtCompany | Data.Common(Data.Type.COMPANY_ID_INTERNAL_TXN, false, siMain.GetValue(siMain.ActiveRowInde… ⇒ biz:CommonData.CommonDataList [code=COMPANY_ID_INTERNAL_TXN] | 화면 필드/플래그 변경 |  |  |  |
| AC-d51e85ae | InsertButton | DMF0004_SalesSite.cs:1901 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | COMBO_DATA | Data.Common | (Data.Type.COMPANY_ID_INTERNAL_TXN, false, siMain.GetValue(siMain.ActiveRowIndex, siMain.G… ⇒ biz:CommonData.CommonDataList [code=COMPANY_ID_INTERNAL_TXN] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-19c77ff9 | InsertButton | DMF0004_SalesSite.cs:1903 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) ▸ i… | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefColumns.CompanyId), dtCompany) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-a59f88ff | InsertButton | DMF0004_SalesSite.cs:1905 | if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain) | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-66fca775 | InsertButton | DMF0004_SalesSite.cs:1911 | else of (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.Rows.Count == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ed73d562 | InsertButton | DMF0004_SalesSite.cs:1915 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.SuspendLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9f12fe2c | InsertButton | DMF0004_SalesSite.cs:1917 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | DATA_OP | siSub.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-68e770f5 | InsertButton | DMF0004_SalesSite.cs:1920 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_COMBO | siSub.SetCellTypeCombo | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), dtDivision) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-5833f276 | InsertButton | DMF0004_SalesSite.cs:1923 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siMain.GetValue(siMain.A… | 그리드 값 설정 |  |  |  |
| AC-80023688 | InsertButton | DMF0004_SalesSite.cs:1924 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SiteId), siMain.GetValue(siMain.Act… | 그리드 값 설정 |  |  |  |
| AC-9452e060 | InsertButton | DMF0004_SalesSite.cs:1930 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.SoldToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-6c042b03 | InsertButton | DMF0004_SalesSite.cs:1931 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ShipToCode)]… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-cda17180 | InsertButton | DMF0004_SalesSite.cs:1933 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.RepYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-9b9d3be5 | InsertButton | DMF0004_SalesSite.cs:1934 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-97bf68f7 | InsertButton | DMF0004_SalesSite.cs:1935 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValue… | 그리드 값 설정 |  |  |  |
| AC-307f7ccc | InsertButton | DMF0004_SalesSite.cs:1941 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.ActiveSheet.Cells[siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.LocationCode… | cellTypeImage | 그리드 속성/값 설정 |  |  |  |
| AC-3be87577 | InsertButton | DMF0004_SalesSite.cs:1943 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.ValidYn), CAppSetting.StringY) | 그리드 값 설정 |  |  |  |
| AC-b3a22cb2 | InsertButton | DMF0004_SalesSite.cs:1944 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValue… | 그리드 값 설정 |  |  |  |
| AC-8737d7a9 | InsertButton | DMF0004_SalesSite.cs:1951 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == Spd… | GRID_SET | siSub.SetValue | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), cboDivision.ControlValue… | 그리드 값 설정 |  |  |  |
| AC-8b38dcc7 | InsertButton | DMF0004_SalesSite.cs:1954 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | GRID_LOCK | siSub.LockRange | (siSub.ActiveRowIndex, siSub.GetColumnIndex(DefColumns.Division), siSub.ActiveRowIndex, si… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e75eae2f | InsertButton | DMF0004_SalesSite.cs:1955 | else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) | UI_MISC | siSub.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## DMF0004_SalesSite.InsertRowLockRangeMain

진입점: InsertButton [if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (siMain.SheetName == SpdSheet.shtMain)] / EditButton [if (fps != null) ▸ if (fps.Name == "spdMain") ▸ else of (UserInfoContext.Current["NowGroupID"].ToString() == "SCP Planner") ▸ for (iRow <= siMain.GetMaxRowIndex()) ▸ else of ((siMain.GetValue(iRow, siMain.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY)) ▸ else of (string.IsNullOrEmpty(siMain.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)))) ▸ if (siMain.GetValue(iRow, siMain.GetColumnIndex(CA…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1e489a1 | InsertButton [if (fps.Name == "spdMain") ▸ if (siMain != nul… 외 1 | DMF0004_SalesSite.cs:1961 |  | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.SiteId), rowIndex, siMain.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fcaa5d58 | InsertButton [if (fps.Name == "spdMain") ▸ if (siMain != nul… 외 1 | DMF0004_SalesSite.cs:1962 |  | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.RepSoldToCode), rowIndex, siMain.GetColumnInde… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2b1d99cd | InsertButton [if (fps.Name == "spdMain") ▸ if (siMain != nul… 외 1 | DMF0004_SalesSite.cs:1963 |  | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siMain.GetColumnIndex(D… | 그리드 편집 잠금/해제 |  |  |  |
| AC-97a7c0e8 | InsertButton [if (fps.Name == "spdMain") ▸ if (siMain != nul… 외 1 | DMF0004_SalesSite.cs:1964 |  | GRID_LOCK | siMain.LockRange | (rowIndex, siMain.GetColumnIndex(DefColumns.Division), rowIndex, siMain.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0004_SalesSite.InsertRowLockRangeSubBucket

진입점: InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)] / EditButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ el…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-eef59b4c | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1982 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.Division), rowIndex, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b71f28af | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1983 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0004_SalesSite.InsertRowLockRangeSubCustomer

진입점: InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)] / EditButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY) ▸ else of (string.IsNullOrEmpty(siSub.GetText(iRow, siMain.GetColumnIndex(CAppSetting.StringAction)))) ▸ if (siSub.GetValue(iRow, siSub.GetColumnIndex(CAppSet…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-74c5062d | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1969 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.Division), rowIndex, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2749b8de | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1970 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.SoldToDescription), rowIndex, siSub.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eea0ebeb | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1971 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.ShipToDescription), rowIndex, siSub.GetColumnIn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e58b03a3 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1972 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0004_SalesSite.InsertRowLockRangeSubLocation

진입점: InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub != null && siSub.IsLock(siSub.SheetName) == false) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)] / EditButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(iRow, siSub.GetColumnIndex(DefColumns.EditFlag)).ToString() == CAppSetting.StringY) ▸ else of (string.IsNull…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd72b6b7 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1976 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.Division), rowIndex, siSub.GetColumnIndex(DefCo… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4c080dcd | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1977 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.LocationDescription), rowIndex, siSub.GetColumn… | 그리드 편집 잠금/해제 |  |  |  |
| AC-59b88257 | InsertButton [else of (fps.Name == "spdMain") ▸ if (siSub !=… 외 1 | DMF0004_SalesSite.cs:1978 |  | GRID_LOCK | siSub.LockRange | (rowIndex, siSub.GetColumnIndex(DefColumns.UpdateDate), rowIndex, siSub.GetColumnIndex(Def… | 그리드 편집 잠금/해제 |  |  |  |

## DMF0004_SalesSite.SaveData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0eab34b0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1001 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f20b8d4 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1167 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivision == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b38d4e4d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1169 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ if (sDivision == "") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f412b92 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1182 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ if (((sDi… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25a8063d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1184 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ if (((sDi… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3a06f079 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1212 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1e420d8e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1214 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-205828e1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1223 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e99ce9aa | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1226 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cb433316 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1235 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-35fa2180 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1237 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2a291a0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1257 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-1ea54cc9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1259 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b3b01ca | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1268 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-8447341e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1270 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8af9e752 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1279 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bc3d9b05 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1281 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4b04fe54 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1294 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d6e7880b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1296 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ else of (sDivision == "") ▸ else of (… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c989e5f6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1312 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0004_SAVE_SALES_SITE_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0c2660e5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1313 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-6d05d0ac | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1314 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-71d487ed | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1315 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-3bdab5f5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1316 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_site_description"] | sSalesSiteDesc | 행/컬럼 값 대입 |  |  |  |
| AC-3b5bc9e3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1317 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_company_id"] | sCompanyId | 행/컬럼 값 대입 |  |  |  |
| AC-61fef8c2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1318 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_end_customer"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-a711e1bc | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1319 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_sold_customer"] | sSoldToCode | 행/컬럼 값 대입 |  |  |  |
| AC-2b065bab | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1320 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_city"] | sCity | 행/컬럼 값 대입 |  |  |  |
| AC-8f82e741 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1321 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_country"] | sCountry | 행/컬럼 값 대입 |  |  |  |
| AC-29c6b4af | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1322 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_dept_id"] | sDeptId | 행/컬럼 값 대입 |  |  |  |
| AC-9d8f0176 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1323 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_distribution_channel"] | sDistributionChannel | 행/컬럼 값 대입 |  |  |  |
| AC-5e73053c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1324 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_vmi_yn"] | sVmiYN | 행/컬럼 값 대입 |  |  |  |
| AC-a2e159b2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1325 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-2e1509a3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1326 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-7378eb1b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1327 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_ship_plan_auto"] | sShipPlanAuto | 행/컬럼 값 대입 |  |  |  |
| AC-5f050244 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1328 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_attribute5"] | sAttribute5 | 행/컬럼 값 대입 |  |  |  |
| AC-339d981b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1330 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-f8a54941 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1334 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-55eab6ee | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1338 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-316eadee | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1347 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-df79c483 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdMain")] | DMF0004_SalesSite.cs:1356 | if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0004_SalesSite.SaveSubBucketData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubBucket)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-51419f51 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1728 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85ec6719 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1783 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c40cd67 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1784 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f00cbcb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1789 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e64f56a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1790 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ebdd4b42 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1795 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ad146b10 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1796 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ for (iRow <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetV… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3ecdc83 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1809 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0004_SAVE_SALES_SITE_BUCKET_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-6b315c5e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1810 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-51f7fe8d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1811 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-942db80e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1812 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-6a5c8ae1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1813 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_Incoterms"] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-f0805eeb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1814 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_yyyymmdd"] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-4e8ce0ed | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1815 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_bucket_per"] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-3e892faf | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1816 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_conversion_type"] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-4bb6386d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1818 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-21ca1ed9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1820 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-458d1116 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1824 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e353f1ee | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1828 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-da6f0d51 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1840 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9e491a07 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1849 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubBucket) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0004_SalesSite.SaveSubCustomerData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3d08ddff | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1365 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-156d9365 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1393 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00120") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4f8d242a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1394 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (action == CAppSetting.FlagI &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-39a71da2 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1431 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb4d4568 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1433 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-74f14a62 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1442 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-40e25c56 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1444 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-18032079 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1453 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ba84e233 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1455 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da00f5b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1464 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c62a036e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1466 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b1c2aa14 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1481 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0004_SAVE_SALES_SITE_CUSTOMER_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-004bf068 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1482 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-df31dca0 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1483 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-345cb5cd | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1484 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-54dcfdf6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1485 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_code"] | sSoldTo | 행/컬럼 값 대입 |  |  |  |
| AC-a71d646c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1486 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_soldto_description"] | sSoldToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-3279ebec | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1487 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_code"] | sShipTo | 행/컬럼 값 대입 |  |  |  |
| AC-61cae72f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1488 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_shipto_description"] | sShipToDesc | 행/컬럼 값 대입 |  |  |  |
| AC-6458949c | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1489 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_rep_yn"] | sRepYN | 행/컬럼 값 대입 |  |  |  |
| AC-04b22687 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1490 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-527d7eb1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1491 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-8468b80e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1493 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4081f982 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1502 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ if … | MESSAGE | MessageHelper.GMessageBox | ("MSG00179", new object[] { SalesSiteId, ShipToCode }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-331abaf3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1506 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) ▸ els… | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-636000ba | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1511 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-790f5c6e | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1524 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2501c2f3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ i… | DMF0004_SalesSite.cs:1533 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubCustomer) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0004_SalesSite.SaveSubLocationData

진입점: SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubLocation)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e3ae145 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1542 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (siSub.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-04b6961b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1604 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-23d4c2f5 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1606 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ if (siSub.GetValue(i, siSub.GetCo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cbbf5c3a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1615 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-18230998 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1617 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7a3b8b32 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1627 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43a4109d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1629 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ else of (siSub.GetValue(i, siSub.… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f2e864a3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1653 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ecfd34b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1655 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationCode), "") | 그리드 값 설정 |  |  |  |
| AC-15bf19d3 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1656 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.LocationDescription), "") | 그리드 값 설정 |  |  |  |
| AC-b7a7a1e9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1657 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | GRID_SET | siSub.SetValue | (i, siSub.GetColumnIndex(DefColumns.PlantId), "") | 그리드 값 설정 |  |  |  |
| AC-02b9d89b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1659 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ for (i <= siSub.GetMaxRowIndex()) ▸ for (iRow <= siSub.GetMaxRowIndex… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4fe38152 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1678 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | (sProcedureName) ⇒ DM.DMF0004_SAVE_SALES_SITE_LOCATION_DATA | 엔드포인트 요청 생성 |  |  |  |
| AC-0693cc60 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1679 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_active_flag"] | sAction | 행/컬럼 값 대입 |  |  |  |
| AC-0a442417 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1680 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_seq"] | sLocationSeq | 행/컬럼 값 대입 |  |  |  |
| AC-c19b01b9 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1681 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_division_id"] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-869d8905 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1682 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_code"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-0aea5c5d | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1683 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_location_description"] | sLocationCode | 행/컬럼 값 대입 |  |  |  |
| AC-e108ee9f | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1684 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_scm_site_id"] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-901e6916 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1685 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_plant_id"] | sPlantId | 행/컬럼 값 대입 |  |  |  |
| AC-7e43d4d8 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1686 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_storage_id"] | sStorageId | 행/컬럼 값 대입 |  |  |  |
| AC-9491be5a | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1687 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_valid_yn"] | sValidYN | 행/컬럼 값 대입 |  |  |  |
| AC-5e88c1cb | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1688 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | DATA_OP | request.Parameters["p_created_by"] | sUrserId | 행/컬럼 값 대입 |  |  |  |
| AC-51a233f6 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1690 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-645dcd8b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1694 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ if (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | (response.DataSet.Tables[0].Rows[0][0].ToString()) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-90a60a71 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1698 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ try ▸ else of (response.DataSet.Tables.Count != 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0440d5b1 | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1711 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9d392f3b | SaveButton [if (fps != null) ▸ if (fps.Name == "spdSub") ▸ e… | DMF0004_SalesSite.cs:1720 | if (siSub != null && siSub.IsLock(SpdSheet.shtSubLocation) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## DMF0004_SalesSite.SetChangeControl

진입점: this.clbTeam.SelectedIndexChanged / this.clbEndCustomer.SelectedIndexChanged / this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-659226f7 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:276 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-092892eb | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:277 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-72ee58e0 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:283 | switch (triggerControl) case "MyDivision": | FLAG | dtDivision | DataService.GetDMInnerTable("MyDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-07f056e9 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:283 | switch (triggerControl) case "MyDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("MyDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f3c068c5 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:288 | switch (triggerControl) case "UserTeamByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-a5b7f9f4 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:290 | switch (triggerControl) case "UserTeamByDivision": | FLAG | dtTeam | DataService.GetDMInnerTable("UserTeamByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-294f0dd7 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:290 | switch (triggerControl) case "UserTeamByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("UserTeamByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-fa970fac | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:295 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-3d5b7e84 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:296 | switch (triggerControl) case "EndCustomerByDivision": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-f4c01452 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:298 | switch (triggerControl) case "EndCustomerByDivision": | FLAG | dtEndCustomer | DataService.GetDMInnerTable("EndCustomerByDivision", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-6399c39b | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:298 | switch (triggerControl) case "EndCustomerByDivision": | COMBO_DATA | DataService.GetDMInnerTable | ("EndCustomerByDivision", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-d1d41c4f | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:303 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DIVISION_ID"] | sDivision | 행/컬럼 값 대입 |  |  |  |
| AC-33c70407 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:304 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["DEPT_ID"] | sTeam | 행/컬럼 값 대입 |  |  |  |
| AC-eace36f4 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:305 | switch (triggerControl) case "UserSiteByEndCustomer": | DATA_OP | Filter["END_CUSTOMER"] | sEndCustomer | 행/컬럼 값 대입 |  |  |  |
| AC-20c61336 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:307 | switch (triggerControl) case "UserSiteByEndCustomer": | FLAG | dtSalesSite | DataService.GetDMInnerTable("UserSiteByEndCustomer", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-14b1f966 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:307 | switch (triggerControl) case "UserSiteByEndCustomer": | COMBO_DATA | DataService.GetDMInnerTable | ("UserSiteByEndCustomer", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-a0134305 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:312 | switch (triggerControl) case "ScmSitebyEndCustomer40": | FLAG | dtSalesSite | DataService.GetDMInnerTable("ScmSitebyEndCustomer40", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-9397aa71 | this.clbTeam.SelectedIndexChanged 외 3 | DMF0004_SalesSite.cs:312 | switch (triggerControl) case "ScmSitebyEndCustomer40": | COMBO_DATA | DataService.GetDMInnerTable | ("ScmSitebyEndCustomer40", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## DMF0004_SalesSite.SetGridHeader

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e71a328 | (진입점 미연결) | DMF0004_SalesSite.cs:2198 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "DMF0004", siMain.ActiveSheet.SheetName) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b9863096 | (진입점 미연결) | DMF0004_SalesSite.cs:2209 | if (cboDivision.ControlValues == "40") ▸ for (i < dt.Rows.Count - 1) ▸ if (sDivGbn == "81,82") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.Team].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-b14028dd | (진입점 미연결) | DMF0004_SalesSite.cs:2210 | if (cboDivision.ControlValues == "40") ▸ for (i < dt.Rows.Count - 1) ▸ if (sDivGbn == "81,82") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TeamName].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3361ecb7 | (진입점 미연결) | DMF0004_SalesSite.cs:2211 | if (cboDivision.ControlValues == "40") ▸ for (i < dt.Rows.Count - 1) ▸ if (sDivGbn == "81,82") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.EndCustomer].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-7cf649ff | (진입점 미연결) | DMF0004_SalesSite.cs:2215 | if (cboDivision.ControlValues == "40") | UI_PROP | lblTeam.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-378f2957 | (진입점 미연결) | DMF0004_SalesSite.cs:2216 | if (cboDivision.ControlValues == "40") | UI_PROP | lblEndCustomer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |
| AC-93dbe267 | (진입점 미연결) | DMF0004_SalesSite.cs:2220 | else of (cboDivision.ControlValues == "40") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.Team].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-2b02c1cd | (진입점 미연결) | DMF0004_SalesSite.cs:2221 | else of (cboDivision.ControlValues == "40") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.TeamName].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ed2163e8 | (진입점 미연결) | DMF0004_SalesSite.cs:2222 | else of (cboDivision.ControlValues == "40") | GRID_SET | siMain.ActiveSheet.Columns[DefColumns.EndCustomer].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-9994ef63 | (진입점 미연결) | DMF0004_SalesSite.cs:2224 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblTeam.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-c1c8674a | (진입점 미연결) | DMF0004_SalesSite.cs:2225 | else of (cboDivision.ControlValues == "40") | UI_PROP | lblEndCustomer.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |

## DMF0004_SalesSite.SetSubBucketData

진입점: dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20d398ed | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2582 |  | DATA_OP | dtSubBucket.Select | (sFilter) | 데이터 객체 조작/조회 |  |  |  |
| AC-23d0fb38 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2586 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1b650512 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2587 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Division] | sDivisionId | 행/컬럼 값 대입 |  |  |  |
| AC-e5a1bc51 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2588 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.SiteId] | sSalesSiteId | 행/컬럼 값 대입 |  |  |  |
| AC-c003a980 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2589 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.Incoterms] | sIncoterms | 행/컬럼 값 대입 |  |  |  |
| AC-b1b666f2 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2590 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.YYYYMMDD] | sYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-43e54f5c | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2591 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-53a517ff | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2592 | if (drFind.Length == 0) | DATA_OP | drNew[DefColumns.ConversionType] | sConversionType | 행/컬럼 값 대입 |  |  |  |
| AC-c6bb5cd6 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2594 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.Rows.Add | (drNew) | 데이터 객체 조작/조회 |  |  |  |
| AC-05ed678c | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2595 | if (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |
| AC-07f83022 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2599 | else of (drFind.Length == 0) | DATA_OP | drFind[0][DefColumns.BucketPer] | sBucketPer | 행/컬럼 값 대입 |  |  |  |
| AC-d04bf0a8 | dsdm3.Changed [switch (e.Type) case FarPoint.Win.Spread.Mode… | DMF0004_SalesSite.cs:2600 | else of (drFind.Length == 0) | DATA_OP | dtSubBucket.AcceptChanges | () | 데이터 객체 조작/조회 |  |  |  |

## DMF0004_SalesSite.shtMainDataModel_Changed

진입점: dsdm.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03eabd4e | dsdm.Changed | DMF0004_SalesSite.cs:2623 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.Sold… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), sScmSite) | 그리드 값 설정 |  |  |  |
| AC-f1bfa877 | dsdm.Changed | DMF0004_SalesSite.cs:2635 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | FLAG | mbScmSite | false | 화면 필드/플래그 변경 |  |  |  |
| AC-b6117657 | dsdm.Changed | DMF0004_SalesSite.cs:2652 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-43431975 | dsdm.Changed | DMF0004_SalesSite.cs:2654 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-eb63b226 | dsdm.Changed | DMF0004_SalesSite.cs:2665 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-abdcf595 | dsdm.Changed | DMF0004_SalesSite.cs:2666 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-f96bf955 | dsdm.Changed | DMF0004_SalesSite.cs:2673 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |
| AC-db5f116a | dsdm.Changed | DMF0004_SalesSite.cs:2674 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SiteId), "") | 그리드 값 설정 |  |  |  |
| AC-b6edc719 | dsdm.Changed | DMF0004_SalesSite.cs:2683 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | MESSAGE | MessageHelper.GMessageBox | ("VMI Site 에만 입력할 수 있습니다.") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f5f7aea | dsdm.Changed | DMF0004_SalesSite.cs:2684 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns… | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.Attribute5), "") | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.shtSubBucketDataModel_Changed

진입점: dsdm3.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-045af34f | dsdm3.Changed | DMF0004_SalesSite.cs:2517 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Division }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-57851a38 | dsdm3.Changed | DMF0004_SalesSite.cs:2518 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sDivisionId ==… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20beb010 | dsdm3.Changed | DMF0004_SalesSite.cs:2523 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.SiteId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-16ae8c93 | dsdm3.Changed | DMF0004_SalesSite.cs:2524 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sSalesSiteId =… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1777622b | dsdm3.Changed | DMF0004_SalesSite.cs:2529 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | MESSAGE | MessageHelper.GMessageBox | ("MSG00002", new object[] { DefColumnLabels.Incoterms }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-00a9615d | dsdm3.Changed | DMF0004_SalesSite.cs:2530 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName.IndexOf("D_") == 0) ▸ if (sIncoterms == … | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-df669d6e | dsdm3.Changed | DMF0004_SalesSite.cs:2561 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5d88cef6 | dsdm3.Changed | DMF0004_SalesSite.cs:2563 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName.IndexOf("D_") == 0) ▸ if (sColName … | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.Incoterms), "") | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.shtSubCustomerDataModel_Changed

진입점: dsdm2.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89b7e9d3 | dsdm2.Changed | DMF0004_SalesSite.cs:2443 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | MESSAGE | MessageHelper.GMessageBox | ("MSG00149") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6ef44729 | dsdm2.Changed | DMF0004_SalesSite.cs:2444 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ if (sColName == DefColumns.RepYn) ▸ if (iRepYnCnt > 1… | GRID_SET | siSub.SetValue | (e.Row, e.Column, "N") | 그리드 값 설정 |  |  |  |
| AC-6e596321 | dsdm2.Changed | DMF0004_SalesSite.cs:2466 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | MESSAGE | MessageHelper.GMessageBox | ("MSG00060", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ccf32540 | dsdm2.Changed | DMF0004_SalesSite.cs:2468 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), "") | 그리드 값 설정 |  |  |  |
| AC-3d8484b9 | dsdm2.Changed | DMF0004_SalesSite.cs:2469 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), "") | 그리드 값 설정 |  |  |  |
| AC-cb668f9f | dsdm2.Changed | DMF0004_SalesSite.cs:2470 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |
| AC-8300ddb1 | dsdm2.Changed | DMF0004_SalesSite.cs:2471 | switch (e.Type) case FarPoint.Win.Spread.Model.SheetDataModelEventType.CellsUpdated: ▸ else of (sColName == DefColumns.RepYn) ▸ if (sColName… | GRID_SET | siSub.SetValue | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), "") | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.spdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-524d8386 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:1994 | if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-056712d6 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2000 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00128", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b1fbcca8 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2001 | if (siMain.IsLock(siMain.SheetName)) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45cfb779 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2008 | if (siMain.IsLock(siMain.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd2ff03f | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2044 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), "") | 그리드 값 설정 |  |  |  |
| AC-e179cf07 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2046 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | new SCM.PopUp.UIL.SCM0002_SoldtobyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-3eecccde | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2048 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.Form_Load | (false, sDivisionId, sSoldToName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-33613feb | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2049 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | UI_PROP | popSoldto.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7d8bf15e | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2050 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | POPUP | popSoldto.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1b70c7f7 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2057 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), sSoldToCode.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-89b23473 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2058 | else of (siMain.IsLock(siMain.SheetName)) ▸ if (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.SoldTo… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.SoldToName), sSoldToName.TrimEnd()) | 그리드 값 설정 |  |  |  |
| AC-3516812a | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2080 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.Form_Load | (false, sCountry, sCity) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c268cbbe | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2081 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popCity.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-b0855e92 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2082 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popCity.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c33c35ca | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2091 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | msScmSite | siMain.GetText(e.Row, siMain.GetColumnIndex(DefColumns.SoldTo)) + "_" + sCity.Substring(0,… | 화면 필드/플래그 변경 |  |  |  |
| AC-b5396a2d | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2094 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | FLAG | mbScmSite | true | 화면 필드/플래그 변경 |  |  |  |
| AC-e2e73838 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2097 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), sCountry) | 그리드 값 설정 |  |  |  |
| AC-35f7bbf2 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2098 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CountryName), sCountryName) | 그리드 값 설정 |  |  |  |
| AC-6804bde3 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2099 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), sCity) | 그리드 값 설정 |  |  |  |
| AC-54cc1f5e | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2100 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.CityName), sCityName) | 그리드 값 설정 |  |  |  |
| AC-88dde180 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2120 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | new SCM0002_TeamPopup | () | 팝업/폼 생성 |  |  |  |
| AC-bbd29830 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2122 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.Form_Load | (false, sTeamID, sTeamName) | 팝업 초기화(인자 전달) |  |  |  |
| AC-7ad58296 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2123 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | UI_PROP | popTeam.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a9ffb034 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2124 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | POPUP | popTeam.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-27421749 | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2131 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), sTeamID) | 그리드 값 설정 |  |  |  |
| AC-63f46bcf | this.spdMain.CellDoubleClick | DMF0004_SalesSite.cs:2132 | else of (siMain.IsLock(siMain.SheetName)) ▸ else of (siMain.GetColumnTag(e.Column) == siMain.GetColumnTag(siMain.GetColumnIndex(DefColumns.S… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.TeamName), sTeamName) | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.spdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9f53593e | this.spdMain.ComboSelChange | DMF0004_SalesSite.cs:2282 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtCustomer | Data.Common(Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-fe5ac976 | this.spdMain.ComboSelChange | DMF0004_SalesSite.cs:2282 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.EndCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=EndCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-cb5e2508 | this.spdMain.ComboSelChange | DMF0004_SalesSite.cs:2284 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.EndCustomer), dtCustomer) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |
| AC-15edd422 | this.spdMain.ComboSelChange | DMF0004_SalesSite.cs:2286 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | FLAG | dtSoldTo | Data.Common(Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 화면 필드/플래그 변경 |  |  |  |
| AC-9c9f5f03 | this.spdMain.ComboSelChange | DMF0004_SalesSite.cs:2286 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SoldCustomer, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SoldCustomer] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c267ff69 | this.spdMain.ComboSelChange | DMF0004_SalesSite.cs:2287 | if (e.Column == siMain.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siMain.SetCellTypeCombo | (e.Row, siMain.GetColumnIndex(DefColumns.SoldTo), dtSoldTo) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0004_SalesSite.spdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4724ef42 | this.spdMain.EditChange | DMF0004_SalesSite.cs:2379 | if (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Team), "") | 그리드 값 설정 |  |  |  |
| AC-b795ac1d | this.spdMain.EditChange | DMF0004_SalesSite.cs:2383 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.Country), "") | 그리드 값 설정 |  |  |  |
| AC-d8ac4b2d | this.spdMain.EditChange | DMF0004_SalesSite.cs:2387 | else of (e.Column == siMain.GetColumnIndex(DefColumns.TeamName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.CountryName)) ▸ if … | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.City), "") | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.spdMain_LeaveCell

진입점: this.spdMain.LeaveCell

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4baadd10 | this.spdMain.LeaveCell | DMF0004_SalesSite.cs:2417 | if (e.Row != e.NewRow) ▸ if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.NewRow | iRow | 속성 NewRow 설정 |  |  |  |

## DMF0004_SalesSite.spdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3c36becb | this.spdMain.TopChange | DMF0004_SalesSite.cs:2700 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## DMF0004_SalesSite.spdSub_ActiveSheetChanging

진입점: this.spdSub.ActiveSheetChanging

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68b2b747 | this.spdSub.ActiveSheetChanging | DMF0004_SalesSite.cs:2403 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | UI_PROP | e.ActivatedSheetIndex | siSub.ActiveSheetIndex | 속성 ActivatedSheetIndex 설정 |  |  |  |
| AC-0e3b0e51 | this.spdSub.ActiveSheetChanging | DMF0004_SalesSite.cs:2405 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00129", new object[] { siSub.ActiveSheet.SheetName }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-98830a2c | this.spdSub.ActiveSheetChanging | DMF0004_SalesSite.cs:2406 | if (!siSub.IsLock(siSub.ActiveSheet.SheetName)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## DMF0004_SalesSite.spdSub_CellDoubleClick

진입점: this.spdSub.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a3a292a5 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2307 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.GetText(e.Row, siSub.GetColumnIndex(CAppSetting.StringAction)) != CAppSetting.StringI) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-45c46cc5 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2309 | if (!siSub.IsLock(siSub.SheetName)) | GRID_INIT | siSub.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fc9b9bdb | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2323 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | new SCM0002_CustomerbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-f3e0e5c7 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2325 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.Form_Load | (false, sDivisionId, sSoldToCode, sShipToCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-fb1bc286 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2326 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | UI_PROP | popCustomer.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-e54926cf | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2327 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | POPUP | popCustomer.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-771e3bbf | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2336 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToCode), popCustomer.SoldToCode) | 그리드 값 설정 |  |  |  |
| AC-206dc144 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2337 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.SoldToDescription), popCustomer.SoldToDesc) | 그리드 값 설정 |  |  |  |
| AC-903064ec | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2338 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), popCustomer.ShipToCode) | 그리드 값 설정 |  |  |  |
| AC-510b873d | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2339 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToDescription), popCustomer.ShipToDesc) | 그리드 값 설정 |  |  |  |
| AC-a28cb8ca | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2340 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoRegionName), popCustomer.ShiptoRegion) | 그리드 값 설정 |  |  |  |
| AC-bd40a600 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2341 | if (!siSub.IsLock(siSub.SheetName)) ▸ if (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.GetColumnTag(e.Column) == siSu… | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShiptoCityName), popCustomer.ShiptoCity) | 그리드 값 설정 |  |  |  |
| AC-3cc3bfbf | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2352 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | new SCM0002_StoragebyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-403172a0 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2354 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.Form_Load | (false, sDivisionId, sLocationCode) | 팝업 초기화(인자 전달) |  |  |  |
| AC-18270a49 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2355 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | UI_PROP | popLocation.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-33f3e696 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2356 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | POPUP | popLocation.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5f23aa3b | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2363 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationCode), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-76dccab4 | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2364 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.LocationDescription), popLocation.StorageDesc) | 그리드 값 설정 |  |  |  |
| AC-7d4c6b8f | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2366 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.StorageId), popLocation.StorageId) | 그리드 값 설정 |  |  |  |
| AC-4aceaa0b | this.spdSub.CellDoubleClick | DMF0004_SalesSite.cs:2367 | if (!siSub.IsLock(siSub.SheetName)) ▸ else of (siSub.ActiveSheet.SheetName == SpdSheet.shtSubCustomer) ▸ if (siSub.ActiveSheet.SheetName == … | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.PlantId), popLocation.PlantId) | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.spdSub_ComboSelChange

진입점: this.spdSub.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-61a2bbe0 | this.spdSub.ComboSelChange | DMF0004_SalesSite.cs:2297 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | FLAG | dtDetailSalesSite | Data.Common(Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-6066f7cc | this.spdSub.ComboSelChange | DMF0004_SalesSite.cs:2297 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | COMBO_DATA | Data.Common | (Data.Type.SaleSiteByDivision, false, sDivision) ⇒ biz:CommonData.CommonDataList [code=SaleSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-38e2e1d1 | this.spdSub.ComboSelChange | DMF0004_SalesSite.cs:2300 | if (e.Column == siSub.GetColumnIndex(DefColumns.Division)) | GRID_COMBO | siSub.SetCellTypeCombo | (e.Row, siSub.GetColumnIndex(DefColumns.SiteId), dtDetailSalesSite) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## DMF0004_SalesSite.spdSub_EditChange

진입점: this.spdSub.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7821b63 | this.spdSub.EditChange | DMF0004_SalesSite.cs:2395 | if (e.Column == siSub.GetColumnIndex(DefColumns.SoldToCode)) | GRID_SET | siSub.SetText | (e.Row, siSub.GetColumnIndex(DefColumns.ShipToCode), "") | 그리드 값 설정 |  |  |  |

## DMF0004_SalesSite.spdSub_TopChange

진입점: this.spdSub.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-20785650 | this.spdSub.TopChange | DMF0004_SalesSite.cs:2707 |  | GRID_INIT | siSub.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

