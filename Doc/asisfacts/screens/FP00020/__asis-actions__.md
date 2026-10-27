# AS-IS 액션 대조표 — FP00020

> 원천: `Doc/asisfacts/screens/FP00020/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 96행 · 메서드 15 · 종류 FLAG 29 · DATA_OP 11 · UI_PROP 9 · LIST_REBIND 8 · COMBO_DATA 7 · RETURN 6 · POPUP 4 · GRID_INIT 4 · STATE 4 · UI_MISC 4 · ENDPOINT 3 · MESSAGE 2 · EXCEL 1 · CALL_BASE 1 · THROW 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 1


## FP00020_Site_Plant.btnSql_Click

진입점: this.btnSql.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-54bbf153 | this.btnSql.Click | FP00020_Site_Plant.cs:271 |  | POPUP | new FPC0099_SqlPopup | () | 팝업/폼 생성 |  |  |  |
| AC-26a9ea50 | this.btnSql.Click | FP00020_Site_Plant.cs:272 |  | UI_PROP | popSql.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-ec85f65c | this.btnSql.Click | FP00020_Site_Plant.cs:274 |  | DATA_OP | popSql.Services.Add | ("PR_UI_FP0020_SITE_PLANT") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0b9bd18 | this.btnSql.Click | FP00020_Site_Plant.cs:275 |  | POPUP | popSql.ShowDialog | () | 팝업/폼 열기 |  |  |  |

## FP00020_Site_Plant.checkValidItem

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d96deb6 | (진입점 미연결) | FP00020_Site_Plant.cs:477 |  | RETURN | return false; |  | 처리 중단/반환 |  |  |  |

## FP00020_Site_Plant.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1013305e | this.Load | FP00020_Site_Plant.cs:249 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-ecc4049a | this.Load | FP00020_Site_Plant.cs:250 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-a6659201 | this.Load | FP00020_Site_Plant.cs:251 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## FP00020_Site_Plant.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-df09126d | this.Load | FP00020_Site_Plant.cs:132 | if (adminAuth) | STATE | btnSql.Enabled | true | 컨트롤 상태 Enabled |  |  |  |
| AC-7bfc8495 | this.Load | FP00020_Site_Plant.cs:133 | if (adminAuth) | STATE | btnSql.Visible | true | 컨트롤 상태 Visible |  |  |  |
| AC-7401d8a4 | this.Load | FP00020_Site_Plant.cs:134 | if (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Always | 속성 Visibility 설정 |  |  |  |
| AC-8d5dcec4 | this.Load | FP00020_Site_Plant.cs:138 | else of (adminAuth) | STATE | btnSql.Enabled | false | 컨트롤 상태 Enabled |  |  |  |
| AC-780a8e6d | this.Load | FP00020_Site_Plant.cs:139 | else of (adminAuth) | STATE | btnSql.Visible | false | 컨트롤 상태 Visible |  |  |  |
| AC-c19339f1 | this.Load | FP00020_Site_Plant.cs:140 | else of (adminAuth) | UI_PROP | lblSql.Visibility | DevExpress.XtraLayout.Utils.LayoutVisibility.Never | 속성 Visibility 설정 |  |  |  |

## FP00020_Site_Plant.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0d9c98f4 | Dispose | FP00020_Site_Plant.designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00020_Site_Plant.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f293a9c3 | EditButton | FP00020_Site_Plant.cs:287 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-30d735d8 | EditButton | FP00020_Site_Plant.cs:288 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## FP00020_Site_Plant.Excel_Export

진입점: ExcelButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b07d6e4f | ExcelButton | FP00020_Site_Plant.cs:298 |  | EXCEL | ExportExcel | () | 엑셀 내보내기/올리기 |  |  |  |

## FP00020_Site_Plant.Find_Data_Execute

진입점: popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] / FindButton [try ▸ lambda]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24fb3c09 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:379 | try | CALL_BASE | this.Invoke | (new MethodInvoker(delegate () { //LocalDataSet localDataSet = new LocalDataSet(); pDivisi… | ⚠ 의미 확인 필요 |  |  |  |
| AC-7173f4d3 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:382 | try ▸ lambda | FLAG | pDivisionID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-cce94fb8 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:383 | try ▸ lambda | FLAG | pSiteID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-46ce62b6 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:384 | try ▸ lambda | FLAG | pPlantID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-242cb2dd | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:385 | try ▸ lambda | FLAG | pFactoryID | CString.GetCheckedListValue(dtFactory, clbFactory.ControlValues, true) | 화면 필드/플래그 변경 |  |  |  |
| AC-97ecd1d1 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:405 | try | ENDPOINT | new FoxDataRequest | ("FP_Master.PR_UI_FP00020_SITE_PLANT") ⇒ FP_Master.PR_UI_FP00020_SITE_PLANT | 엔드포인트 요청 생성 |  |  |  |
| AC-83ae9c92 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:406 | try | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-37f691e3 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:407 | try | DATA_OP | request.Parameters["p_sys_type"] | p_sys_type | 행/컬럼 값 대입 |  |  |  |
| AC-0974e444 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:408 | try | DATA_OP | request.Parameters["p_sys_flag"] | "MAIN" | 행/컬럼 값 대입 |  |  |  |
| AC-ca3235af | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:409 | try | DATA_OP | request.Parameters["p_sys_gubun"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-81218c93 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:410 | try | DATA_OP | request.Parameters["p_user_id"] | sUserId | 행/컬럼 값 대입 |  |  |  |
| AC-d7e89a36 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:412 | try | DATA_OP | request.Parameters["p_division_lt"] | pDivisionID.Equals("ALL") ? DBNull.Value : pDivisionID | 행/컬럼 값 대입 |  |  |  |
| AC-ddeed861 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:413 | try | DATA_OP | request.Parameters["p_site_id"] | pSiteID.Equals("ALL") ? DBNull.Value : pSiteID | 행/컬럼 값 대입 |  |  |  |
| AC-26bd083a | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:414 | try | DATA_OP | request.Parameters["p_plant_lt"] | pPlantID.Equals("ALL") ? DBNull.Value : pPlantID | 행/컬럼 값 대입 |  |  |  |
| AC-712e5184 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:415 | try | DATA_OP | request.Parameters["p_factory_lt"] | pFactoryID.Equals("ALL") ? DBNull.Value : pFactoryID | 행/컬럼 값 대입 |  |  |  |
| AC-2c9a3542 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:416 | try | DATA_OP | request.Parameters["p_active"] | pActive.Equals("ALL") ? DBNull.Value : pActive | 행/컬럼 값 대입 |  |  |  |
| AC-4cac58b6 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:418 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-da314001 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:420 | try | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-60efb4c0 | popSql.OnSql [if (programID == "PR_UI_FP0020_SITE_PLANT")] 외 1 | FP00020_Site_Plant.cs:427 | catch ((Exception)) | THROW | throw; |  | 예외 발생 |  |  |  |

## FP00020_Site_Plant.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b694360e | FindButton | FP00020_Site_Plant.cs:306 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-59a7fb2b | FindButton | FP00020_Site_Plant.cs:312 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-295aec00 | FindButton | FP00020_Site_Plant.cs:313 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a42547fc | FindButton | FP00020_Site_Plant.cs:316 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-f074e844 | FindButton | FP00020_Site_Plant.cs:324 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-88a183ad | FindButton | FP00020_Site_Plant.cs:333 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-50cf78bc | FindButton | FP00020_Site_Plant.cs:335 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => Find_Data_Execute(true) ) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a8d54714 | FindButton | FP00020_Site_Plant.cs:345 | try | GRID_BIND | siMain.Query | (ds, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-8db1b784 | FindButton | FP00020_Site_Plant.cs:346 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-0d3cdce5 | FindButton | FP00020_Site_Plant.cs:349 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-982c0c55 | FindButton | FP00020_Site_Plant.cs:362 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b9a274c2 | FindButton | FP00020_Site_Plant.cs:363 | finally | FLAG | blnWork | false | 화면 필드/플래그 변경 |  |  |  |

## FP00020_Site_Plant.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6af5affb | this.Load | FP00020_Site_Plant.cs:111 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00020_Site_Plant.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7595a67e | this.Load | FP00020_Site_Plant.cs:147 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-cb2283ea | this.Load | FP00020_Site_Plant.cs:149 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-a230b64f | this.Load | FP00020_Site_Plant.cs:152 |  | FLAG | _sNonAuth | "Y" | 화면 필드/플래그 변경 |  |  |  |
| AC-a9322254 | this.Load | FP00020_Site_Plant.cs:153 |  | FLAG | _sSaveAuth | "" | 화면 필드/플래그 변경 |  |  |  |
| AC-d810f185 | this.Load | FP00020_Site_Plant.cs:155 |  | FLAG | dtDivision | Data_FP.Common_FP(Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth,… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 화면 필드/플래그 변경 |  |  |  |
| AC-3d56dc1e | this.Load | FP00020_Site_Plant.cs:155 |  | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.DIVISION, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth) ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=DIVISION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b5dbc2c9 | this.Load | FP00020_Site_Plant.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9ea1e514 | this.Load | FP00020_Site_Plant.cs:158 |  | LIST_REBIND | clsCtrl.setListBox | (dtYesOrNo, cboActive, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## FP00020_Site_Plant.InitEvent

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-087af439 | this.Load | FP00020_Site_Plant.cs:218 |  | UI_PROP | clbDivision.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-a510bb99 | this.Load | FP00020_Site_Plant.cs:219 |  | UI_PROP | clbPlant.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-7fdf6514 | this.Load | FP00020_Site_Plant.cs:220 |  | UI_PROP | clbSite.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |
| AC-93264551 | this.Load | FP00020_Site_Plant.cs:221 |  | UI_PROP | clbFactory.RaiseDataSourceEvent | true | 속성 RaiseDataSourceEvent 설정 |  |  |  |

## FP00020_Site_Plant.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-053f48e6 | this.Load 외 1 | FP00020_Site_Plant.cs:258 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-1c8e1716 | this.Load 외 1 | FP00020_Site_Plant.cs:260 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## FP00020_Site_Plant.RunSqlSource

진입점: popSql.OnSql

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e973f0e6 | popSql.OnSql | FP00020_Site_Plant.cs:440 | if (programID == "PR_UI_FP0020_SITE_PLANT") | RETURN | return Find_Data_Execute(bSysType); |  | 처리 중단/반환 |  |  |  |
| AC-d2621bbd | popSql.OnSql | FP00020_Site_Plant.cs:443 |  | RETURN | return null; |  | 처리 중단/반환 |  |  |  |

## FP00020_Site_Plant.SetChangeControl

진입점: this.Load / clbDivision.SelectedIndexChanged / clbSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ae1bade | this.Load 외 3 | FP00020_Site_Plant.cs:170 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtDivision, clbDivision.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-63e6e6fa | this.Load 외 3 | FP00020_Site_Plant.cs:171 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | pDivisionID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-293e0e0f | this.Load 외 3 | FP00020_Site_Plant.cs:172 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | dtSite | Data_FP.Common_FP(Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sS… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-ee8253be | this.Load 외 3 | FP00020_Site_Plant.cs:172 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.SITE, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, nu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-54bba148 | this.Load 외 3 | FP00020_Site_Plant.cs:173 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-26e4bb35 | this.Load 외 3 | FP00020_Site_Plant.cs:176 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-478e5d84 | this.Load 외 3 | FP00020_Site_Plant.cs:177 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-d9d2ff62 | this.Load 외 3 | FP00020_Site_Plant.cs:178 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-5f21671a | this.Load 외 3 | FP00020_Site_Plant.cs:178 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7199e74d | this.Load 외 3 | FP00020_Site_Plant.cs:179 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-79184d0e | this.Load 외 3 | FP00020_Site_Plant.cs:183 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-0fb04c27 | this.Load 외 3 | FP00020_Site_Plant.cs:184 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-101ed87a | this.Load 외 3 | FP00020_Site_Plant.cs:185 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.NON_AUTH_FACTORY, false, UserInfoContext.Current.UserId, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=NON_AUTH_FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-dfe3eed7 | this.Load 외 3 | FP00020_Site_Plant.cs:185 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.NON_AUTH_FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=NON_AUTH_FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ff1bb0ba | this.Load 외 3 | FP00020_Site_Plant.cs:186 | if (argType == null \|\| argType == "" \|\| argType == "DIVISION") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-be718c67 | this.Load 외 3 | FP00020_Site_Plant.cs:192 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtSite, clbSite.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-806f87f4 | this.Load 외 3 | FP00020_Site_Plant.cs:193 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | pSiteID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-2a06b216 | this.Load 외 3 | FP00020_Site_Plant.cs:194 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | dtPlant | Data_FP.Common_FP(Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 화면 필드/플래그 변경 |  |  |  |
| AC-b9bbd4e7 | this.Load 외 3 | FP00020_Site_Plant.cs:194 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.PLANT, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAuth, null, n… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=PLANT] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-fe9c9628 | this.Load 외 3 | FP00020_Site_Plant.cs:195 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-102f8c74 | this.Load 외 3 | FP00020_Site_Plant.cs:199 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-56e320a4 | this.Load 외 3 | FP00020_Site_Plant.cs:200 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-64c721a8 | this.Load 외 3 | FP00020_Site_Plant.cs:201 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.NON_AUTH_FACTORY, false, UserInfoContext.Current.UserId, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=NON_AUTH_FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-2894473d | this.Load 외 3 | FP00020_Site_Plant.cs:201 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.NON_AUTH_FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=NON_AUTH_FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d2e623a4 | this.Load 외 3 | FP00020_Site_Plant.cs:202 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ if (argType == "SITE") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c0d7bab3 | this.Load 외 3 | FP00020_Site_Plant.cs:208 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | sDataID | CString.GetCheckedListValue(dtPlant, clbPlant.ControlValues) | 화면 필드/플래그 변경 |  |  |  |
| AC-c7e67824 | this.Load 외 3 | FP00020_Site_Plant.cs:209 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | pPlantID | sDataID | 화면 필드/플래그 변경 |  |  |  |
| AC-8ccdbf09 | this.Load 외 3 | FP00020_Site_Plant.cs:210 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | FLAG | dtFactory | Data_FP.Common_FP(Data_FP.Type.NON_AUTH_FACTORY, false, UserInfoContext.Current.UserId, _s… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=NON_AUTH_FACTORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-55a4c574 | this.Load 외 3 | FP00020_Site_Plant.cs:210 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | COMBO_DATA | Data_FP.Common_FP | (Data_FP.Type.NON_AUTH_FACTORY, false, UserInfoContext.Current.UserId, _sNonAuth, _sSaveAu… ⇒ biz:FPCommonDataBLL.FPCommonDataList [code=NON_AUTH_FACTORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0a4bfacb | this.Load 외 3 | FP00020_Site_Plant.cs:211 | else of (argType == null \|\| argType == "" \|\| argType == "DIVISION") ▸ else of (argType == "SITE") ▸ if (argType == "PLANT") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |

