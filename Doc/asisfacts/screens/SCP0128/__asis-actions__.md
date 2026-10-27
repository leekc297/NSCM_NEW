# AS-IS 액션 대조표 — SCP0128

> 원천: `Doc/asisfacts/screens/SCP0128/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 178행 · 메서드 28 · 종류 DATA_OP 44 · RETURN 25 · FLAG 21 · LIST_REBIND 16 · MESSAGE 13 · POPUP 10 · UI_PROP 10 · UI_MISC 8 · ENDPOINT 8 · GRID_INIT 6 · GRID_LOCK 6 · GRID_SET 4 · GRID_CLEAR 3 · VALIDATE 2 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0128_SafetyStock.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dc47958c | this.btnItemId.Click | SCP0128_SafetyStock.cs:1097 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-1df4e0be | this.btnItemId.Click | SCP0128_SafetyStock.cs:1099 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c8055f68 | this.btnItemId.Click | SCP0128_SafetyStock.cs:1100 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-fcaa9cc7 | this.btnItemId.Click | SCP0128_SafetyStock.cs:1101 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-e1abbb2e | this.btnItemId.Click | SCP0128_SafetyStock.cs:1107 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0128_SafetyStock.CboPlanGroup_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2f84107e | (진입점 미연결) | SCP0128_SafetyStock.cs:903 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0128_SafetyStock.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a9c1995 | (진입점 미연결) | SCP0128_SafetyStock.cs:329 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0128_SafetyStock.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0597b5e2 | cboDivision.SelectedIndexChanged | SCP0128_SafetyStock.cs:898 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0128_SafetyStock.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7490a889 | this.Load | SCP0128_SafetyStock.cs:286 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-001abf35 | this.Load | SCP0128_SafetyStock.cs:287 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-4a779381 | this.Load | SCP0128_SafetyStock.cs:288 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0128_SafetyStock.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-49793e28 | this.Load | SCP0128_SafetyStock.cs:149 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0128_SafetyStock.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b515d89b | DeleteButton | SCP0128_SafetyStock.cs:357 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-27e2cdc2 | DeleteButton | SCP0128_SafetyStock.cs:360 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0128_SafetyStock.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-88f6c0cc | Dispose | SCP0128_SafetyStock.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0128_SafetyStock.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c54ab1d1 | EditButton | SCP0128_SafetyStock.cs:368 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b9daa5a2 | EditButton | SCP0128_SafetyStock.cs:369 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-bc838a28 | EditButton | SCP0128_SafetyStock.cs:370 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b8cf66a2 | EditButton | SCP0128_SafetyStock.cs:372 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.PRE_KEY_VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-0774b438 | EditButton | SCP0128_SafetyStock.cs:373 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0128_SafetyStock.FindData_Main

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-08587355 | FindButton 외 1 | SCP0128_SafetyStock.cs:390 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-11726ff6 | FindButton 외 1 | SCP0128_SafetyStock.cs:395 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-7122b3ac | FindButton 외 1 | SCP0128_SafetyStock.cs:395 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-aa0f8b39 | FindButton 외 1 | SCP0128_SafetyStock.cs:399 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-26bfe38f | FindButton 외 1 | SCP0128_SafetyStock.cs:402 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b5893214 | FindButton 외 1 | SCP0128_SafetyStock.cs:427 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c61ac868 | FindButton 외 1 | SCP0128_SafetyStock.cs:428 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-df44c4af | FindButton 외 1 | SCP0128_SafetyStock.cs:432 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0128_GET_SAFETY_STOCK") ⇒ SCP.SCP0128_GET_SAFETY_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-20dd82ae | FindButton 외 1 | SCP0128_SafetyStock.cs:433 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-9828db7b | FindButton 외 1 | SCP0128_SafetyStock.cs:434 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-ac6d509a | FindButton 외 1 | SCP0128_SafetyStock.cs:435 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-7d7e3b0b | FindButton 외 1 | SCP0128_SafetyStock.cs:436 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-e08de5a1 | FindButton 외 1 | SCP0128_SafetyStock.cs:437 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-2f0a19de | FindButton 외 1 | SCP0128_SafetyStock.cs:438 | try ▸ lambda | DATA_OP | request.Parameters["p_stage"] | pStage | 행/컬럼 값 대입 |  |  |  |
| AC-1f3631dc | FindButton 외 1 | SCP0128_SafetyStock.cs:439 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-10e195ef | FindButton 외 1 | SCP0128_SafetyStock.cs:440 | try ▸ lambda | DATA_OP | request.Parameters["p_value_type"] | pType | 행/컬럼 값 대입 |  |  |  |
| AC-655f3266 | FindButton 외 1 | SCP0128_SafetyStock.cs:442 | try ▸ lambda | DATA_OP | request.Parameters["p_period_from"] | pPeriodFrom | 행/컬럼 값 대입 |  |  |  |
| AC-1fd39a6f | FindButton 외 1 | SCP0128_SafetyStock.cs:443 | try ▸ lambda | DATA_OP | request.Parameters["p_period_to"] | pPeriodTo | 행/컬럼 값 대입 |  |  |  |
| AC-3b8b295b | FindButton 외 1 | SCP0128_SafetyStock.cs:445 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3abe8997 | FindButton 외 1 | SCP0128_SafetyStock.cs:447 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-b3fa37ce | FindButton 외 1 | SCP0128_SafetyStock.cs:456 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPreSafeStockAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-b2c67c04 | FindButton 외 1 | SCP0128_SafetyStock.cs:456 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-15db86d4 | FindButton 외 1 | SCP0128_SafetyStock.cs:460 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-dda32914 | FindButton 외 1 | SCP0128_SafetyStock.cs:461 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-6e991a26 | FindButton 외 1 | SCP0128_SafetyStock.cs:464 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-6c9d21af | FindButton 외 1 | SCP0128_SafetyStock.cs:477 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0128_SafetyStock.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce343dbc | this.Load | SCP0128_SafetyStock.cs:138 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0128_SafetyStock.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6ecace12 | this.Load [else of (division.Equals("EE"))] 외 3 | SCP0128_SafetyStock.cs:250 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0128_SafetyStock.GetSearchInfo

진입점: SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18b6d643 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0128_SafetyStock.cs:205 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0128_GET_SEARCH_INFO") ⇒ SCP.SCP0128_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-2c781780 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0128_SafetyStock.cs:207 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-ff7575fd | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0128_SafetyStock.cs:208 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-a111b050 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0128_SafetyStock.cs:209 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-79c700ad | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0128_SafetyStock.cs:210 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d3070be1 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0128_SafetyStock.cs:214 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0128_SafetyStock.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-638bf073 | this.Load | SCP0128_SafetyStock.cs:154 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-ff4d1cbb | this.Load | SCP0128_SafetyStock.cs:159 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-ec0d1f10 | this.Load | SCP0128_SafetyStock.cs:162 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d2ceb1f8 | this.Load | SCP0128_SafetyStock.cs:163 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-4fb0e9ee | this.Load | SCP0128_SafetyStock.cs:166 |  | FLAG | dtScmSiteAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-8704a0d7 | this.Load | SCP0128_SafetyStock.cs:169 |  | FLAG | dtStageAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-e2493998 | this.Load | SCP0128_SafetyStock.cs:172 |  | FLAG | dtType | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-ebd83d54 | this.Load | SCP0128_SafetyStock.cs:173 |  | LIST_REBIND | clsCtrl.setListBox | (dtType, cboType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5f71e0d6 | this.Load | SCP0128_SafetyStock.cs:176 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-311aa6cf | this.Load | SCP0128_SafetyStock.cs:179 |  | FLAG | dtValidYn | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-b0ad8418 | this.Load | SCP0128_SafetyStock.cs:181 |  | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |

## SCP0128_SafetyStock.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-92851190 | this.Load 외 2 | SCP0128_SafetyStock.cs:296 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-b2930886 | this.Load 외 2 | SCP0128_SafetyStock.cs:297 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-9c1f04e8 | this.Load 외 2 | SCP0128_SafetyStock.cs:299 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-0d3c59cd | this.Load 외 2 | SCP0128_SafetyStock.cs:304 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ScmSite", dtScmSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-847b1e34 | this.Load 외 2 | SCP0128_SafetyStock.cs:305 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Division", dtMyDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-01254db0 | this.Load 외 2 | SCP0128_SafetyStock.cs:306 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-c4b7308e | this.Load 외 2 | SCP0128_SafetyStock.cs:307 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Stage", dtStage) | 목록 컨트롤 재구성 |  |  |  |
| AC-5c1f0613 | this.Load 외 2 | SCP0128_SafetyStock.cs:308 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ValidYn", dtValidYn) | 목록 컨트롤 재구성 |  |  |  |
| AC-907a95f7 | this.Load 외 2 | SCP0128_SafetyStock.cs:311 |  | GRID_INIT | siMain.SetSheetHeaderColumnSCP | (siMain, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0128_SafetyStock.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-237369ce | InsertButton | SCP0128_SafetyStock.cs:506 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5471d635 | InsertButton | SCP0128_SafetyStock.cs:512 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-7d75d5ac | InsertButton | SCP0128_SafetyStock.cs:513 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-2a775c2e | InsertButton | SCP0128_SafetyStock.cs:515 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-cbe77b2e | InsertButton | SCP0128_SafetyStock.cs:517 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-d841bcfe | InsertButton | SCP0128_SafetyStock.cs:518 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0128_SafetyStock.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b776f42a | this.Load 외 2 | SCP0128_SafetyStock.cs:256 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-7dd74d78 | this.Load 외 2 | SCP0128_SafetyStock.cs:256 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-67f86330 | this.Load 외 2 | SCP0128_SafetyStock.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0128_SafetyStock.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7257ccc1 | this.Load 외 2 | SCP0128_SafetyStock.cs:266 | if (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-b3ffe591 | this.Load 외 2 | SCP0128_SafetyStock.cs:266 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b0d77c03 | this.Load 외 2 | SCP0128_SafetyStock.cs:271 | else of (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-f24589b8 | this.Load 외 2 | SCP0128_SafetyStock.cs:271 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-2abc80b8 | this.Load 외 2 | SCP0128_SafetyStock.cs:273 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0128_SafetyStock.RefreshStageByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ca301beb | this.Load 외 2 | SCP0128_SafetyStock.cs:279 |  | FLAG | dtStage | DBUtils.Filter(dtStageAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-3508f4d2 | this.Load 외 2 | SCP0128_SafetyStock.cs:279 |  | DATA_OP | DBUtils.Filter | (dtStageAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-b93df203 | this.Load 외 2 | SCP0128_SafetyStock.cs:281 |  | LIST_REBIND | clsCtrl.setListBox | (dtStage, cboStage, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0128_SafetyStock.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d29400e6 | SaveButton | SCP0128_SafetyStock.cs:524 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7db6ca5b | SaveButton | SCP0128_SafetyStock.cs:526 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a06f3201 | SaveButton | SCP0128_SafetyStock.cs:643 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_value_type == string.Empty \|\| v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Em… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ec290b1c | SaveButton | SCP0128_SafetyStock.cs:644 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_value_type == string.Empty \|\| v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Em… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e6fedcde | SaveButton | SCP0128_SafetyStock.cs:686 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtPreSafeStockAll != null) | DATA_OP | DBUtils.Filter | (dtPreSafeStockAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-788efda9 | SaveButton | SCP0128_SafetyStock.cs:690 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtPreSafeStockAll != null) ▸ if (dtPreSafeStock.Rows.Count > 0 && action != CAppSetting.FlagD) | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9c530463 | SaveButton | SCP0128_SafetyStock.cs:691 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtPreSafeStockAll != null) ▸ if (dtPreSafeStock.Rows.Count > 0 && action != CAppSetting.FlagD) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-bb269dae | SaveButton | SCP0128_SafetyStock.cs:711 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "No Work Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0efdd4b9 | SaveButton | SCP0128_SafetyStock.cs:712 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-57fbbcda | SaveButton | SCP0128_SafetyStock.cs:719 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-807697d6 | SaveButton | SCP0128_SafetyStock.cs:720 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9cee1ecb | SaveButton | SCP0128_SafetyStock.cs:728 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt32(v_apl_qty) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e238a77e | SaveButton | SCP0128_SafetyStock.cs:729 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt32(v_apl_qty) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-72094654 | SaveButton | SCP0128_SafetyStock.cs:738 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dsSearchInfo | GetSearchInfo(CString.GetCheckedListValue(dtMyDivision, pCheckDivision).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-8d066a82 | SaveButton | SCP0128_SafetyStock.cs:739 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-1b824f44 | SaveButton | SCP0128_SafetyStock.cs:740 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | _changeDivision | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0ccf93d3 | SaveButton | SCP0128_SafetyStock.cs:743 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | DBUtils.Filter | (dtItemAll, "ITEM_ID = '" + v_item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-d809000a | SaveButton | SCP0128_SafetyStock.cs:747 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { v_item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-85c731c6 | SaveButton | SCP0128_SafetyStock.cs:748 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b0fdb338 | SaveButton | SCP0128_SafetyStock.cs:795 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-bc1bf188 | SaveButton | SCP0128_SafetyStock.cs:796 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-09215e68 | SaveButton | SCP0128_SafetyStock.cs:800 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0128_SAVE_SAFETY_STOCK") ⇒ SCP.SCP0128_SAVE_SAFETY_STOCK | 엔드포인트 요청 생성 |  |  |  |
| AC-67120f78 | SaveButton | SCP0128_SafetyStock.cs:803 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-db1eea13 | SaveButton | SCP0128_SafetyStock.cs:807 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-2edaaf31 | SaveButton | SCP0128_SafetyStock.cs:809 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c49636a6 | SaveButton | SCP0128_SafetyStock.cs:810 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_type"] | p_value_type | 행/컬럼 값 대입 |  |  |  |
| AC-23d1b20d | SaveButton | SCP0128_SafetyStock.cs:811 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-89f7960f | SaveButton | SCP0128_SafetyStock.cs:812 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-b2696c76 | SaveButton | SCP0128_SafetyStock.cs:813 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-f1586b55 | SaveButton | SCP0128_SafetyStock.cs:814 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-774ba152 | SaveButton | SCP0128_SafetyStock.cs:815 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stage"] | p_stage | 행/컬럼 값 대입 |  |  |  |
| AC-8d5b0576 | SaveButton | SCP0128_SafetyStock.cs:816 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-52a91433 | SaveButton | SCP0128_SafetyStock.cs:817 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-27462f83 | SaveButton | SCP0128_SafetyStock.cs:818 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_apl_qty"] | p_apl_qty | 행/컬럼 값 대입 |  |  |  |
| AC-107797af | SaveButton | SCP0128_SafetyStock.cs:819 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-b007480e | SaveButton | SCP0128_SafetyStock.cs:820 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-c78917b8 | SaveButton | SCP0128_SafetyStock.cs:821 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-23a0c184 | SaveButton | SCP0128_SafetyStock.cs:823 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_value_type"] | p_pre_value_type | 행/컬럼 값 대입 |  |  |  |
| AC-daed9459 | SaveButton | SCP0128_SafetyStock.cs:824 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-06d13f46 | SaveButton | SCP0128_SafetyStock.cs:825 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-14116b0b | SaveButton | SCP0128_SafetyStock.cs:826 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_scm_site_id"] | p_pre_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-2bdb9b13 | SaveButton | SCP0128_SafetyStock.cs:827 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-0530f851 | SaveButton | SCP0128_SafetyStock.cs:828 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_stage"] | p_pre_stage | 행/컬럼 값 대입 |  |  |  |
| AC-5690096c | SaveButton | SCP0128_SafetyStock.cs:829 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_yyyymmdd"] | p_pre_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-118be067 | SaveButton | SCP0128_SafetyStock.cs:830 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_yyyymmdd"] | p_pre_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7d465867 | SaveButton | SCP0128_SafetyStock.cs:832 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-30e073a7 | SaveButton | SCP0128_SafetyStock.cs:832 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-948b09b8 | SaveButton | SCP0128_SafetyStock.cs:836 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ff0b6d61 | SaveButton | SCP0128_SafetyStock.cs:843 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b91fce8b | SaveButton | SCP0128_SafetyStock.cs:852 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-4b689b9e | SaveButton | SCP0128_SafetyStock.cs:859 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a58697d8 | SaveButton | SCP0128_SafetyStock.cs:860 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-530fafb4 | SaveButton | SCP0128_SafetyStock.cs:864 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0128_SafetyStock.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-77a80f95 | (진입점 미연결) | SCP0128_SafetyStock.cs:484 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c5fb4339 | (진입점 미연결) | SCP0128_SafetyStock.cs:498 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0128_SafetyStock.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12e6886e | this.Load 외 2 | SCP0128_SafetyStock.cs:335 |  | FLAG | _changeDivision | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0128_SafetyStock.setPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0347035f | this.Load | SCP0128_SafetyStock.cs:887 |  | UI_PROP | dCalendar.Text1 | sMondayDate | 속성 Text1 설정 |  |  |  |
| AC-818c98b5 | this.Load | SCP0128_SafetyStock.cs:888 |  | UI_PROP | dCalendar.Text2 | sToDate | 속성 Text2 설정 |  |  |  |

## SCP0128_SafetyStock.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-741a8850 | this.spdMain.CellClick | SCP0128_SafetyStock.cs:923 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-06886bb7 | this.spdMain.CellClick | SCP0128_SafetyStock.cs:942 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7430d8d1 | this.spdMain.CellClick | SCP0128_SafetyStock.cs:950 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-cf131dc8 | this.spdMain.CellClick | SCP0128_SafetyStock.cs:955 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-d18a62b5 | this.spdMain.CellClick | SCP0128_SafetyStock.cs:959 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STAGE, dtStage, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bec2e5da | this.spdMain.CellClick | SCP0128_SafetyStock.cs:963 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALUE_TYPE, dtType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-717362e1 | this.spdMain.CellClick | SCP0128_SafetyStock.cs:967 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALID_YN, dtValidYn, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0128_SafetyStock.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b8e7d379 | this.spdMain.CellDoubleClick | SCP0128_SafetyStock.cs:982 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-92b23120 | this.spdMain.CellDoubleClick | SCP0128_SafetyStock.cs:995 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-fe08316d | this.spdMain.CellDoubleClick | SCP0128_SafetyStock.cs:997 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c40d2884 | this.spdMain.CellDoubleClick | SCP0128_SafetyStock.cs:998 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f734d57d | this.spdMain.CellDoubleClick | SCP0128_SafetyStock.cs:999 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b0ac05cf | this.spdMain.CellDoubleClick | SCP0128_SafetyStock.cs:1006 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0128_SafetyStock.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1e0c1f46 | this.spdMain.ClipboardPasted | SCP0128_SafetyStock.cs:1123 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-085c529c | this.spdMain.ClipboardPasted | SCP0128_SafetyStock.cs:1125 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0128_SafetyStock.SpdMain_EditChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-34b086f9 | (진입점 미연결) | SCP0128_SafetyStock.cs:1017 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)).T… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f0a61e5 | (진입점 미연결) | SCP0128_SafetyStock.cs:1022 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (sToDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-afbcdddb | (진입점 미연결) | SCP0128_SafetyStock.cs:1035 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-defd15ed | (진입점 미연결) | SCP0128_SafetyStock.cs:1036 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b31876e | (진입점 미연결) | SCP0128_SafetyStock.cs:1046 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-eb2996fe | (진입점 미연결) | SCP0128_SafetyStock.cs:1047 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), "") | 그리드 값 설정 |  |  |  |
| AC-74dac33f | (진입점 미연결) | SCP0128_SafetyStock.cs:1048 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-685af3b8 | (진입점 미연결) | SCP0128_SafetyStock.cs:1058 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1f011996 | (진입점 미연결) | SCP0128_SafetyStock.cs:1062 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (string.IsNullOrWhiteSpace(sFromDate) \|\|sFromDate.Length != 8) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c8e227c4 | (진입점 미연결) | SCP0128_SafetyStock.cs:1069 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9beef2ea | (진입점 미연결) | SCP0128_SafetyStock.cs:1070 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-c449fa92 | (진입점 미연결) | SCP0128_SafetyStock.cs:1077 | if (e.Column == siMain.GetColumnIndex(DefColumns.APL_QTY)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.APL_QTY)).ToString(… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2f4fe8ee | (진입점 미연결) | SCP0128_SafetyStock.cs:1084 | if (e.Column == siMain.GetColumnIndex(DefColumns.APL_QTY)) ▸ if (iDayCount < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0128_SafetyStock.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e96a8b75 | this.spdMain.TopChange | SCP0128_SafetyStock.cs:912 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

