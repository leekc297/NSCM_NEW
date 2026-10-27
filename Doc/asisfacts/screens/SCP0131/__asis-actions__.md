# AS-IS 액션 대조표 — SCP0131

> 원천: `Doc/asisfacts/screens/SCP0131/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 164행 · 메서드 26 · 종류 DATA_OP 39 · RETURN 24 · FLAG 20 · MESSAGE 12 · LIST_REBIND 11 · POPUP 10 · UI_PROP 9 · UI_MISC 8 · ENDPOINT 8 · GRID_INIT 6 · GRID_LOCK 6 · GRID_SET 4 · GRID_CLEAR 3 · VALIDATE 2 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0131_SalesSitePriority.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f25d76a | this.btnItemId.Click | SCP0131_SalesSitePriority.cs:959 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-2df5134a | this.btnItemId.Click | SCP0131_SalesSitePriority.cs:961 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-20b1646f | this.btnItemId.Click | SCP0131_SalesSitePriority.cs:962 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fb5f5f83 | this.btnItemId.Click | SCP0131_SalesSitePriority.cs:963 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50b22189 | this.btnItemId.Click | SCP0131_SalesSitePriority.cs:969 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0131_SalesSitePriority.CboPlanGroup_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-670d49be | (진입점 미연결) | SCP0131_SalesSitePriority.cs:845 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0131_SalesSitePriority.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0a51d683 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:333 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0131_SalesSitePriority.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b2293626 | cboDivision.SelectedIndexChanged | SCP0131_SalesSitePriority.cs:840 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0131_SalesSitePriority.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08cc99f8 | this.Load | SCP0131_SalesSitePriority.cs:290 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-9c35bd80 | this.Load | SCP0131_SalesSitePriority.cs:291 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4c61672c | this.Load | SCP0131_SalesSitePriority.cs:292 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0131_SalesSitePriority.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5723d67 | DeleteButton | SCP0131_SalesSitePriority.cs:362 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b821932e | DeleteButton | SCP0131_SalesSitePriority.cs:365 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0131_SalesSitePriority.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bb5dfed4 | Dispose | SCP0131_SalesSitePriority.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0131_SalesSitePriority.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e1c28921 | EditButton | SCP0131_SalesSitePriority.cs:373 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-9a102f84 | EditButton | SCP0131_SalesSitePriority.cs:374 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-af0ea878 | EditButton | SCP0131_SalesSitePriority.cs:375 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2f0eae29 | EditButton | SCP0131_SalesSitePriority.cs:377 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.PRE_KEY_VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-2d88e10d | EditButton | SCP0131_SalesSitePriority.cs:378 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0131_SalesSitePriority.FindData_Main

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e8c8a1c5 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:395 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-ac3a60d2 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:400 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-b38a92da | FindButton 외 1 | SCP0131_SalesSitePriority.cs:400 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-87605c40 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:404 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f8578f64 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:407 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f5bf89e5 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:429 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-06f04bb8 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:430 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0a7ca8e0 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:434 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0131_GET_SALES_SITE_PRIORITY") ⇒ SCP.SCP0131_GET_SALES_SITE_PRIORITY | 엔드포인트 요청 생성 |  |  |  |
| AC-07b5045a | FindButton 외 1 | SCP0131_SalesSitePriority.cs:435 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-b33179da | FindButton 외 1 | SCP0131_SalesSitePriority.cs:436 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-11f0c535 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:437 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-c25bde1b | FindButton 외 1 | SCP0131_SalesSitePriority.cs:438 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-2458bb41 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:439 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-fcd73438 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:441 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-c17aab13 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:443 | try ▸ lambda | DATA_OP | request.Parameters["p_period_from"] | pPeriodFrom | 행/컬럼 값 대입 |  |  |  |
| AC-636da487 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:444 | try ▸ lambda | DATA_OP | request.Parameters["p_period_to"] | pPeriodTo | 행/컬럼 값 대입 |  |  |  |
| AC-02e07d7b | FindButton 외 1 | SCP0131_SalesSitePriority.cs:446 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-8641fe2c | FindButton 외 1 | SCP0131_SalesSitePriority.cs:448 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-1b49f33e | FindButton 외 1 | SCP0131_SalesSitePriority.cs:457 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPreSafeStockAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-774b2db0 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:457 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-58d6769b | FindButton 외 1 | SCP0131_SalesSitePriority.cs:461 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-986c7675 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:462 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-5e7f6df0 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:465 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-90e211d2 | FindButton 외 1 | SCP0131_SalesSitePriority.cs:478 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0131_SalesSitePriority.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3457e188 | this.Load | SCP0131_SalesSitePriority.cs:131 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0131_SalesSitePriority.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b76d957f | this.Load [else of (division.Equals("EE"))] 외 3 | SCP0131_SalesSitePriority.cs:244 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0131_SalesSitePriority.GetSearchInfo

진입점: SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ff77df7 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0131_SalesSitePriority.cs:199 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0128_GET_SEARCH_INFO") ⇒ SCP.SCP0128_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-9756a683 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0131_SalesSitePriority.cs:201 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-90f67e70 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0131_SalesSitePriority.cs:202 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-dfd557eb | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0131_SalesSitePriority.cs:203 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-cfe8cd8c | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0131_SalesSitePriority.cs:204 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-33862a18 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0131_SalesSitePriority.cs:208 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0131_SalesSitePriority.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a767c24 | this.Load | SCP0131_SalesSitePriority.cs:147 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-420e7a69 | this.Load | SCP0131_SalesSitePriority.cs:152 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-a74984d4 | this.Load | SCP0131_SalesSitePriority.cs:155 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1f729c80 | this.Load | SCP0131_SalesSitePriority.cs:156 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-1859dadb | this.Load | SCP0131_SalesSitePriority.cs:159 |  | FLAG | dtScmSiteAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-52598ef7 | this.Load | SCP0131_SalesSitePriority.cs:166 |  | FLAG | dtType | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-cfaa3781 | this.Load | SCP0131_SalesSitePriority.cs:170 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-937d7e75 | this.Load | SCP0131_SalesSitePriority.cs:173 |  | FLAG | dtValidYn | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-6b55b5ca | this.Load | SCP0131_SalesSitePriority.cs:175 |  | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |

## SCP0131_SalesSitePriority.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8f8d0daa | this.Load 외 2 | SCP0131_SalesSitePriority.cs:300 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-af7af744 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:301 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-4ac7196f | this.Load 외 2 | SCP0131_SalesSitePriority.cs:303 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-658262cd | this.Load 외 2 | SCP0131_SalesSitePriority.cs:306 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ScmSite", dtScmSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-df43d7c8 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:307 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Division", dtMyDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-05b68d30 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:308 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-c17b790e | this.Load 외 2 | SCP0131_SalesSitePriority.cs:309 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ValidYn", dtValidYn) | 목록 컨트롤 재구성 |  |  |  |
| AC-87e5349f | this.Load 외 2 | SCP0131_SalesSitePriority.cs:315 |  | GRID_INIT | siMain.SetSheetHeaderColumnSCP | (siMain, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0131_SalesSitePriority.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7de28f2a | InsertButton | SCP0131_SalesSitePriority.cs:507 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5cc458a8 | InsertButton | SCP0131_SalesSitePriority.cs:513 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-48997bc9 | InsertButton | SCP0131_SalesSitePriority.cs:514 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-be71067d | InsertButton | SCP0131_SalesSitePriority.cs:516 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-5ba9f449 | InsertButton | SCP0131_SalesSitePriority.cs:518 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-94f71912 | InsertButton | SCP0131_SalesSitePriority.cs:519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0131_SalesSitePriority.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-beeaa2e7 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:250 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-4cfc4548 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:250 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-e2e56ce2 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:252 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0131_SalesSitePriority.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-90f4d16f | this.Load 외 2 | SCP0131_SalesSitePriority.cs:260 | if (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-657ce75b | this.Load 외 2 | SCP0131_SalesSitePriority.cs:260 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-254c88de | this.Load 외 2 | SCP0131_SalesSitePriority.cs:265 | else of (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-d2794a38 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:265 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fdfea69a | this.Load 외 2 | SCP0131_SalesSitePriority.cs:267 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0131_SalesSitePriority.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cd93476a | SaveButton | SCP0131_SalesSitePriority.cs:525 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b5d1a6fe | SaveButton | SCP0131_SalesSitePriority.cs:527 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a2009521 | SaveButton | SCP0131_SalesSitePriority.cs:616 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Empty \|\| v_scm_site_id == string.E… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-67a228b5 | SaveButton | SCP0131_SalesSitePriority.cs:617 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Empty \|\| v_scm_site_id == string.E… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b450e1f9 | SaveButton | SCP0131_SalesSitePriority.cs:637 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((dtPreSafeStockAll != null) && (action == CAppSetting.FlagI)) | DATA_OP | DBUtils.Filter | (dtPreSafeStockAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-444380ab | SaveButton | SCP0131_SalesSitePriority.cs:641 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((dtPreSafeStockAll != null) && (action == CAppSetting.FlagI)) ▸ if (dtPreSafeStock.Rows.Count > 0 &… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b22960af | SaveButton | SCP0131_SalesSitePriority.cs:642 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((dtPreSafeStockAll != null) && (action == CAppSetting.FlagI)) ▸ if (dtPreSafeStock.Rows.Count > 0 &… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3797bc32 | SaveButton | SCP0131_SalesSitePriority.cs:662 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "Sales Site Priority" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cb600d6c | SaveButton | SCP0131_SalesSitePriority.cs:663 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b54a05c8 | SaveButton | SCP0131_SalesSitePriority.cs:669 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-54fdf3ed | SaveButton | SCP0131_SalesSitePriority.cs:670 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-47c31301 | SaveButton | SCP0131_SalesSitePriority.cs:677 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt32(v_prio_rank) < 1) | MESSAGE | MessageHelper.GMessageBox | ("MSG00175", new object[] { "PRIORITY" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9b8883c3 | SaveButton | SCP0131_SalesSitePriority.cs:678 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt32(v_prio_rank) < 1) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-582009d4 | SaveButton | SCP0131_SalesSitePriority.cs:687 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dsSearchInfo | GetSearchInfo(CString.GetCheckedListValue(dtMyDivision, pCheckDivision).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-114e96b9 | SaveButton | SCP0131_SalesSitePriority.cs:688 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-12d470de | SaveButton | SCP0131_SalesSitePriority.cs:689 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | _changeDivision | false | 화면 필드/플래그 변경 |  |  |  |
| AC-6731a235 | SaveButton | SCP0131_SalesSitePriority.cs:692 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | DBUtils.Filter | (dtItemAll, "ITEM_ID = '" + v_item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-413875b4 | SaveButton | SCP0131_SalesSitePriority.cs:695 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { v_item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-51034313 | SaveButton | SCP0131_SalesSitePriority.cs:696 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5fef2bbd | SaveButton | SCP0131_SalesSitePriority.cs:738 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-38df1621 | SaveButton | SCP0131_SalesSitePriority.cs:739 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-2e44577b | SaveButton | SCP0131_SalesSitePriority.cs:743 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0131_SAVE_SALES_SITE_PRIORITY") ⇒ SCP.SCP0131_SAVE_SALES_SITE_PRIORITY | 엔드포인트 요청 생성 |  |  |  |
| AC-0ebcb7d7 | SaveButton | SCP0131_SalesSitePriority.cs:746 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-c7353b77 | SaveButton | SCP0131_SalesSitePriority.cs:750 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-33497d68 | SaveButton | SCP0131_SalesSitePriority.cs:752 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-6ba337c3 | SaveButton | SCP0131_SalesSitePriority.cs:753 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-38394814 | SaveButton | SCP0131_SalesSitePriority.cs:754 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-72ea0f11 | SaveButton | SCP0131_SalesSitePriority.cs:755 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f85d34a1 | SaveButton | SCP0131_SalesSitePriority.cs:756 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-689e446c | SaveButton | SCP0131_SalesSitePriority.cs:757 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_prio_rank"] | p_prio_rank | 행/컬럼 값 대입 |  |  |  |
| AC-4b6ab959 | SaveButton | SCP0131_SalesSitePriority.cs:758 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-69cfdd41 | SaveButton | SCP0131_SalesSitePriority.cs:759 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ae6f8659 | SaveButton | SCP0131_SalesSitePriority.cs:760 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-3c07b88a | SaveButton | SCP0131_SalesSitePriority.cs:761 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-60a1ee04 | SaveButton | SCP0131_SalesSitePriority.cs:762 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-eb0a51e0 | SaveButton | SCP0131_SalesSitePriority.cs:764 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-0312dc96 | SaveButton | SCP0131_SalesSitePriority.cs:765 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-c195d973 | SaveButton | SCP0131_SalesSitePriority.cs:766 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_scm_site_id"] | p_pre_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fb42006 | SaveButton | SCP0131_SalesSitePriority.cs:767 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-358575fe | SaveButton | SCP0131_SalesSitePriority.cs:768 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_prio_rank"] | p_pre_prio_rank | 행/컬럼 값 대입 |  |  |  |
| AC-3a3bc808 | SaveButton | SCP0131_SalesSitePriority.cs:769 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_yyyymmdd"] | p_pre_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-837776b1 | SaveButton | SCP0131_SalesSitePriority.cs:770 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_yyyymmdd"] | p_pre_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-99e80a52 | SaveButton | SCP0131_SalesSitePriority.cs:772 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e404e0a4 | SaveButton | SCP0131_SalesSitePriority.cs:772 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-7bfdf38c | SaveButton | SCP0131_SalesSitePriority.cs:776 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-30aa479f | SaveButton | SCP0131_SalesSitePriority.cs:783 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-13c20c82 | SaveButton | SCP0131_SalesSitePriority.cs:792 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c3c57450 | SaveButton | SCP0131_SalesSitePriority.cs:799 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-38ee307b | SaveButton | SCP0131_SalesSitePriority.cs:800 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9f407d6f | SaveButton | SCP0131_SalesSitePriority.cs:804 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0131_SalesSitePriority.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-00abf5cb | (진입점 미연결) | SCP0131_SalesSitePriority.cs:485 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f429ab41 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:499 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0131_SalesSitePriority.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b6ea5f0 | this.Load 외 2 | SCP0131_SalesSitePriority.cs:339 |  | FLAG | _changeDivision | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0131_SalesSitePriority.setPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cfa3e3a5 | this.Load | SCP0131_SalesSitePriority.cs:828 |  | UI_PROP | dCalendar.Text1 | sMondayDate | 속성 Text1 설정 |  |  |  |
| AC-0df963dd | this.Load | SCP0131_SalesSitePriority.cs:829 |  | UI_PROP | dCalendar.Text2 | sToDate | 속성 Text2 설정 |  |  |  |

## SCP0131_SalesSitePriority.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6d8acc9 | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:865 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-05944048 | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:878 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-b25db12a | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:878 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-1d937dce | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:884 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96c66ade | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:892 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-edab47a6 | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:897 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-955dd05f | this.spdMain.CellClick | SCP0131_SalesSitePriority.cs:909 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALID_YN, dtValidYn, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0131_SalesSitePriority.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-144fd35f | this.spdMain.CellDoubleClick | SCP0131_SalesSitePriority.cs:922 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c4fc77f4 | this.spdMain.CellDoubleClick | SCP0131_SalesSitePriority.cs:934 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-0176f644 | this.spdMain.CellDoubleClick | SCP0131_SalesSitePriority.cs:936 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-dd630e67 | this.spdMain.CellDoubleClick | SCP0131_SalesSitePriority.cs:937 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-39762868 | this.spdMain.CellDoubleClick | SCP0131_SalesSitePriority.cs:938 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e545ab7a | this.spdMain.CellDoubleClick | SCP0131_SalesSitePriority.cs:945 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0131_SalesSitePriority.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f87af63a | this.spdMain.ClipboardPasted | SCP0131_SalesSitePriority.cs:1062 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-00006401 | this.spdMain.ClipboardPasted | SCP0131_SalesSitePriority.cs:1064 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0131_SalesSitePriority.SpdMain_EditChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0f13e8f | (진입점 미연결) | SCP0131_SalesSitePriority.cs:977 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)).T… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-512f45f6 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:982 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (sToDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-426fe6d3 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:992 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-88aec67e | (진입점 미연결) | SCP0131_SalesSitePriority.cs:993 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-ce4fa6e8 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1003 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f88953e1 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1004 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), "") | 그리드 값 설정 |  |  |  |
| AC-3672d4a1 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1005 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-97fe7f34 | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1016 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-772d7e5d | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1021 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (string.IsNullOrWhiteSpace(sFromDate) \|\| sFromDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00d01eaf | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1028 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fdd46ff | (진입점 미연결) | SCP0131_SalesSitePriority.cs:1029 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0131_SalesSitePriority.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7b6aaf98 | this.spdMain.TopChange | SCP0131_SalesSitePriority.cs:854 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

