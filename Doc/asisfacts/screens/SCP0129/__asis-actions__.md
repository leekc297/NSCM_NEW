# AS-IS 액션 대조표 — SCP0129

> 원천: `Doc/asisfacts/screens/SCP0129/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 170행 · 메서드 28 · 종류 DATA_OP 42 · RETURN 23 · FLAG 21 · LIST_REBIND 14 · MESSAGE 11 · POPUP 10 · UI_PROP 10 · UI_MISC 8 · ENDPOINT 8 · GRID_INIT 6 · GRID_LOCK 6 · GRID_SET 4 · GRID_CLEAR 3 · VALIDATE 2 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0129_DemandException.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f24ca75 | this.btnItemId.Click | SCP0129_DemandException.cs:1051 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9d47dcea | this.btnItemId.Click | SCP0129_DemandException.cs:1053 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-f82fab0b | this.btnItemId.Click | SCP0129_DemandException.cs:1054 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-511a3461 | this.btnItemId.Click | SCP0129_DemandException.cs:1055 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f3e89d51 | this.btnItemId.Click | SCP0129_DemandException.cs:1061 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0129_DemandException.CboPlanGroup_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e4b1d58 | (진입점 미연결) | SCP0129_DemandException.cs:859 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0129_DemandException.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fbe1f0c6 | (진입점 미연결) | SCP0129_DemandException.cs:339 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0129_DemandException.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2af3d1d4 | cboDivision.SelectedIndexChanged | SCP0129_DemandException.cs:854 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0129_DemandException.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-547e8e2e | this.Load | SCP0129_DemandException.cs:296 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-22df45dc | this.Load | SCP0129_DemandException.cs:297 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-375ef1bd | this.Load | SCP0129_DemandException.cs:298 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0129_DemandException.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7969bf70 | this.Load | SCP0129_DemandException.cs:150 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0129_DemandException.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b979b7a | DeleteButton | SCP0129_DemandException.cs:368 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c2f159c5 | DeleteButton | SCP0129_DemandException.cs:371 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0129_DemandException.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ef694705 | Dispose | SCP0129_DemandException.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0129_DemandException.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c064d40 | EditButton | SCP0129_DemandException.cs:379 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4803ded0 | EditButton | SCP0129_DemandException.cs:380 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-e587f7f6 | EditButton | SCP0129_DemandException.cs:381 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-1a31d2a2 | EditButton | SCP0129_DemandException.cs:383 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.PRE_KEY_VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fb9d4ca6 | EditButton | SCP0129_DemandException.cs:384 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0129_DemandException.FindData_Main

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-96b3264a | FindButton 외 1 | SCP0129_DemandException.cs:401 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6fc23f83 | FindButton 외 1 | SCP0129_DemandException.cs:406 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-b5ed814b | FindButton 외 1 | SCP0129_DemandException.cs:406 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b8f024ea | FindButton 외 1 | SCP0129_DemandException.cs:410 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-609eb3ab | FindButton 외 1 | SCP0129_DemandException.cs:413 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6f9a01cf | FindButton 외 1 | SCP0129_DemandException.cs:435 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f0941a4c | FindButton 외 1 | SCP0129_DemandException.cs:436 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-b2c54f26 | FindButton 외 1 | SCP0129_DemandException.cs:440 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0129_GET_DEMAND_EXCEPTION") ⇒ SCP.SCP0129_GET_DEMAND_EXCEPTION | 엔드포인트 요청 생성 |  |  |  |
| AC-effc2fcd | FindButton 외 1 | SCP0129_DemandException.cs:441 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-07335e76 | FindButton 외 1 | SCP0129_DemandException.cs:442 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-239bb999 | FindButton 외 1 | SCP0129_DemandException.cs:443 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-52190087 | FindButton 외 1 | SCP0129_DemandException.cs:444 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-7ae8ffe3 | FindButton 외 1 | SCP0129_DemandException.cs:445 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-477adb51 | FindButton 외 1 | SCP0129_DemandException.cs:446 | try ▸ lambda | DATA_OP | request.Parameters["p_stage"] | pModelTypeCd | 행/컬럼 값 대입 |  |  |  |
| AC-cbb93588 | FindButton 외 1 | SCP0129_DemandException.cs:447 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-317c3403 | FindButton 외 1 | SCP0129_DemandException.cs:449 | try ▸ lambda | DATA_OP | request.Parameters["p_period_from"] | pPeriodFrom | 행/컬럼 값 대입 |  |  |  |
| AC-72b38857 | FindButton 외 1 | SCP0129_DemandException.cs:450 | try ▸ lambda | DATA_OP | request.Parameters["p_period_to"] | pPeriodTo | 행/컬럼 값 대입 |  |  |  |
| AC-1b95e1c4 | FindButton 외 1 | SCP0129_DemandException.cs:452 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-681a89ba | FindButton 외 1 | SCP0129_DemandException.cs:454 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-13158982 | FindButton 외 1 | SCP0129_DemandException.cs:463 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPreSafeStockAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-15f89e2c | FindButton 외 1 | SCP0129_DemandException.cs:463 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9de290e3 | FindButton 외 1 | SCP0129_DemandException.cs:467 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-74dc6769 | FindButton 외 1 | SCP0129_DemandException.cs:468 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-4f62f3a5 | FindButton 외 1 | SCP0129_DemandException.cs:471 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-8ceca5cc | FindButton 외 1 | SCP0129_DemandException.cs:484 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0129_DemandException.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ecb351a8 | this.Load | SCP0129_DemandException.cs:139 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0129_DemandException.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec24f051 | this.Load [else of (division.Equals("EE"))] 외 3 | SCP0129_DemandException.cs:251 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0129_DemandException.GetSearchInfo

진입점: SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c7d042d4 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0129_DemandException.cs:206 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0128_GET_SEARCH_INFO") ⇒ SCP.SCP0128_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-37b5331c | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0129_DemandException.cs:208 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d52697c1 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0129_DemandException.cs:209 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-1aa51dff | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0129_DemandException.cs:210 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-7ad7972b | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0129_DemandException.cs:211 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0db5dd51 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0129_DemandException.cs:215 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0129_DemandException.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5cbc2529 | this.Load | SCP0129_DemandException.cs:155 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-be8357c0 | this.Load | SCP0129_DemandException.cs:160 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-6fee3f47 | this.Load | SCP0129_DemandException.cs:163 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-859e1228 | this.Load | SCP0129_DemandException.cs:164 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-66e371de | this.Load | SCP0129_DemandException.cs:167 |  | FLAG | dtScmSiteAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-d3b28909 | this.Load | SCP0129_DemandException.cs:170 |  | FLAG | dtType | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-1da41f1a | this.Load | SCP0129_DemandException.cs:174 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-b564d4bb | this.Load | SCP0129_DemandException.cs:177 |  | FLAG | dtValidYn | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-758bffd5 | this.Load | SCP0129_DemandException.cs:179 |  | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-a7bf4621 | this.Load | SCP0129_DemandException.cs:182 |  | FLAG | dtStageAll | dsSearchInfo.Tables[6] | 화면 필드/플래그 변경 |  |  |  |

## SCP0129_DemandException.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c908525 | this.Load 외 2 | SCP0129_DemandException.cs:306 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-d0133945 | this.Load 외 2 | SCP0129_DemandException.cs:307 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-76f18102 | this.Load 외 2 | SCP0129_DemandException.cs:309 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-4b5398ea | this.Load 외 2 | SCP0129_DemandException.cs:313 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ScmSite", dtScmSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-066ec969 | this.Load 외 2 | SCP0129_DemandException.cs:314 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Division", dtMyDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-4febb251 | this.Load 외 2 | SCP0129_DemandException.cs:315 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-6384c22f | this.Load 외 2 | SCP0129_DemandException.cs:316 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Stage", dtStage) | 목록 컨트롤 재구성 |  |  |  |
| AC-f1739e1e | this.Load 외 2 | SCP0129_DemandException.cs:317 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ValidYn", dtValidYn) | 목록 컨트롤 재구성 |  |  |  |
| AC-b9023b16 | this.Load 외 2 | SCP0129_DemandException.cs:321 |  | GRID_INIT | siMain.SetSheetHeaderColumnSCP | (siMain, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0129_DemandException.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3ba85e1d | InsertButton | SCP0129_DemandException.cs:513 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1e4b8276 | InsertButton | SCP0129_DemandException.cs:519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-9eb1f8c2 | InsertButton | SCP0129_DemandException.cs:520 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-e43aa33a | InsertButton | SCP0129_DemandException.cs:521 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.STOCK_EXCEPTION, "N") | 데이터 객체 조작/조회 |  |  |  |
| AC-1663e9dc | InsertButton | SCP0129_DemandException.cs:523 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-6be661ce | InsertButton | SCP0129_DemandException.cs:525 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-518ac368 | InsertButton | SCP0129_DemandException.cs:526 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0129_DemandException.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d4098570 | this.Load 외 2 | SCP0129_DemandException.cs:257 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7c62d1d7 | this.Load 외 2 | SCP0129_DemandException.cs:257 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-092c6508 | this.Load 외 2 | SCP0129_DemandException.cs:259 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0129_DemandException.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4eb6feda | this.Load 외 2 | SCP0129_DemandException.cs:267 | if (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-af7bb9b5 | this.Load 외 2 | SCP0129_DemandException.cs:267 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-18af2d7b | this.Load 외 2 | SCP0129_DemandException.cs:272 | else of (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-1f735473 | this.Load 외 2 | SCP0129_DemandException.cs:272 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d5e22afe | this.Load 외 2 | SCP0129_DemandException.cs:274 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0129_DemandException.RefreshStageByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9bed8507 | this.Load 외 2 | SCP0129_DemandException.cs:280 |  | FLAG | dtStage | DBUtils.Filter(dtStageAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-edb4bb0e | this.Load 외 2 | SCP0129_DemandException.cs:280 |  | DATA_OP | DBUtils.Filter | (dtStageAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-a8f0dffa | this.Load 외 2 | SCP0129_DemandException.cs:282 |  | LIST_REBIND | clsCtrl.setListBox | (dtStage, cboStage, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0129_DemandException.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f970819c | SaveButton | SCP0129_DemandException.cs:532 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-009a2882 | SaveButton | SCP0129_DemandException.cs:534 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a99c7ac1 | SaveButton | SCP0129_DemandException.cs:628 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Empty \|\| v_scm_site_id == string.E… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-84c42216 | SaveButton | SCP0129_DemandException.cs:629 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Empty \|\| v_scm_site_id == string.E… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-93c48079 | SaveButton | SCP0129_DemandException.cs:651 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((dtPreSafeStockAll != null)&& (action == CAppSetting.FlagI)) | DATA_OP | DBUtils.Filter | (dtPreSafeStockAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-f988ee7b | SaveButton | SCP0129_DemandException.cs:655 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((dtPreSafeStockAll != null)&& (action == CAppSetting.FlagI)) ▸ if (dtPreSafeStock.Rows.Count > 0 &&… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c6828d51 | SaveButton | SCP0129_DemandException.cs:656 | for (i <= siMain.GetMaxRowIndex()) ▸ if ((dtPreSafeStockAll != null)&& (action == CAppSetting.FlagI)) ▸ if (dtPreSafeStock.Rows.Count > 0 &&… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f8ee7cae | SaveButton | SCP0129_DemandException.cs:676 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "No Work Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-5cd3309e | SaveButton | SCP0129_DemandException.cs:677 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-da06c600 | SaveButton | SCP0129_DemandException.cs:683 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9283bc5a | SaveButton | SCP0129_DemandException.cs:684 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7e476984 | SaveButton | SCP0129_DemandException.cs:702 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dsSearchInfo | GetSearchInfo(CString.GetCheckedListValue(dtMyDivision, pCheckDivision).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-a57d9e8a | SaveButton | SCP0129_DemandException.cs:703 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-c665afe5 | SaveButton | SCP0129_DemandException.cs:704 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | _changeDivision | false | 화면 필드/플래그 변경 |  |  |  |
| AC-13357a1f | SaveButton | SCP0129_DemandException.cs:707 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | DBUtils.Filter | (dtItemAll, "ITEM_ID = '" + v_item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-c1d40be3 | SaveButton | SCP0129_DemandException.cs:710 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { v_item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e87fba3b | SaveButton | SCP0129_DemandException.cs:711 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa9d2c20 | SaveButton | SCP0129_DemandException.cs:754 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-52de9012 | SaveButton | SCP0129_DemandException.cs:755 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-af3fddbb | SaveButton | SCP0129_DemandException.cs:759 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0129_SAVE_DEMAND_EXCEPTION") ⇒ SCP.SCP0129_SAVE_DEMAND_EXCEPTION | 엔드포인트 요청 생성 |  |  |  |
| AC-c4d990df | SaveButton | SCP0129_DemandException.cs:762 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5ca55779 | SaveButton | SCP0129_DemandException.cs:766 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-52a112e6 | SaveButton | SCP0129_DemandException.cs:768 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-0e101802 | SaveButton | SCP0129_DemandException.cs:769 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-49af0dd2 | SaveButton | SCP0129_DemandException.cs:770 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-06ce6dd3 | SaveButton | SCP0129_DemandException.cs:771 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-5f74dd3c | SaveButton | SCP0129_DemandException.cs:772 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-b225a6b3 | SaveButton | SCP0129_DemandException.cs:773 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stage"] | p_stage | 행/컬럼 값 대입 |  |  |  |
| AC-03417180 | SaveButton | SCP0129_DemandException.cs:774 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-69caca09 | SaveButton | SCP0129_DemandException.cs:775 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ca650dfe | SaveButton | SCP0129_DemandException.cs:776 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stock_exception"] | p_stock_exception | 행/컬럼 값 대입 |  |  |  |
| AC-3200715c | SaveButton | SCP0129_DemandException.cs:777 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-ba332276 | SaveButton | SCP0129_DemandException.cs:778 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-7220efda | SaveButton | SCP0129_DemandException.cs:779 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-082d93d3 | SaveButton | SCP0129_DemandException.cs:781 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ee659be8 | SaveButton | SCP0129_DemandException.cs:782 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-89de46e6 | SaveButton | SCP0129_DemandException.cs:783 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_scm_site_id"] | p_pre_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-68692e26 | SaveButton | SCP0129_DemandException.cs:784 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0264cb88 | SaveButton | SCP0129_DemandException.cs:785 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_stage"] | p_pre_stage | 행/컬럼 값 대입 |  |  |  |
| AC-e5bd6a7a | SaveButton | SCP0129_DemandException.cs:786 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_yyyymmdd"] | p_pre_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-59e54dae | SaveButton | SCP0129_DemandException.cs:787 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_yyyymmdd"] | p_pre_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2c1fd876 | SaveButton | SCP0129_DemandException.cs:789 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4d3db99d | SaveButton | SCP0129_DemandException.cs:789 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-02e477d9 | SaveButton | SCP0129_DemandException.cs:793 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-aad4f9cb | SaveButton | SCP0129_DemandException.cs:800 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25da659e | SaveButton | SCP0129_DemandException.cs:809 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-f8df2392 | SaveButton | SCP0129_DemandException.cs:816 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-72dc3d20 | SaveButton | SCP0129_DemandException.cs:817 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-44572448 | SaveButton | SCP0129_DemandException.cs:821 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0129_DemandException.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b1da1c50 | (진입점 미연결) | SCP0129_DemandException.cs:491 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-10329934 | (진입점 미연결) | SCP0129_DemandException.cs:505 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0129_DemandException.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-82a4905e | this.Load 외 2 | SCP0129_DemandException.cs:345 |  | FLAG | _changeDivision | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0129_DemandException.setPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-37ecfdd7 | this.Load | SCP0129_DemandException.cs:844 |  | UI_PROP | dCalendar.Text1 | sMondayDate | 속성 Text1 설정 |  |  |  |
| AC-b74c8c90 | this.Load | SCP0129_DemandException.cs:845 |  | UI_PROP | dCalendar.Text2 | sToDate | 속성 Text2 설정 |  |  |  |

## SCP0129_DemandException.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-13bc5bb4 | this.spdMain.CellClick | SCP0129_DemandException.cs:879 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a0f48f6c | this.spdMain.CellClick | SCP0129_DemandException.cs:898 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8982adcf | this.spdMain.CellClick | SCP0129_DemandException.cs:906 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-aeed34b5 | this.spdMain.CellClick | SCP0129_DemandException.cs:911 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-f163c39a | this.spdMain.CellClick | SCP0129_DemandException.cs:915 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STAGE, dtStage, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0c979469 | this.spdMain.CellClick | SCP0129_DemandException.cs:923 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALID_YN, dtValidYn, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0129_DemandException.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d9f93fe4 | this.spdMain.CellDoubleClick | SCP0129_DemandException.cs:938 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-197f3a0e | this.spdMain.CellDoubleClick | SCP0129_DemandException.cs:951 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-483ea515 | this.spdMain.CellDoubleClick | SCP0129_DemandException.cs:953 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-ab6875c1 | this.spdMain.CellDoubleClick | SCP0129_DemandException.cs:954 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-43c3ad18 | this.spdMain.CellDoubleClick | SCP0129_DemandException.cs:955 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-1109d78c | this.spdMain.CellDoubleClick | SCP0129_DemandException.cs:962 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0129_DemandException.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1dfeb1f | this.spdMain.ClipboardPasted | SCP0129_DemandException.cs:1077 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-cffa4adb | this.spdMain.ClipboardPasted | SCP0129_DemandException.cs:1079 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0129_DemandException.SpdMain_EditChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8d95a62c | (진입점 미연결) | SCP0129_DemandException.cs:972 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)).T… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3ab2a20e | (진입점 미연결) | SCP0129_DemandException.cs:977 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (sToDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5db7245e | (진입점 미연결) | SCP0129_DemandException.cs:987 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-394d2cc9 | (진입점 미연결) | SCP0129_DemandException.cs:988 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-742106b1 | (진입점 미연결) | SCP0129_DemandException.cs:998 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-501991cc | (진입점 미연결) | SCP0129_DemandException.cs:999 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), "") | 그리드 값 설정 |  |  |  |
| AC-a607a7e4 | (진입점 미연결) | SCP0129_DemandException.cs:1000 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b0e3b2b | (진입점 미연결) | SCP0129_DemandException.cs:1011 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-922a81ba | (진입점 미연결) | SCP0129_DemandException.cs:1016 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (string.IsNullOrWhiteSpace(sFromDate) \|\|sFromDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4a9296b3 | (진입점 미연결) | SCP0129_DemandException.cs:1023 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-09cd33dd | (진입점 미연결) | SCP0129_DemandException.cs:1024 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0129_DemandException.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b7c598d6 | this.spdMain.TopChange | SCP0129_DemandException.cs:868 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

