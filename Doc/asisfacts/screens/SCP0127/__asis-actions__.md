# AS-IS 액션 대조표 — SCP0127

> 원천: `Doc/asisfacts/screens/SCP0127/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 178행 · 메서드 28 · 종류 DATA_OP 44 · RETURN 25 · FLAG 21 · LIST_REBIND 16 · MESSAGE 13 · POPUP 10 · UI_PROP 10 · UI_MISC 8 · ENDPOINT 8 · GRID_INIT 6 · GRID_LOCK 6 · GRID_SET 4 · GRID_CLEAR 3 · VALIDATE 2 · VALUE_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0127_PrecedeSafetyStockDay.btnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ebaf4ed | this.btnItemId.Click | SCP0127_PrecedeSafetyStockDay.cs:1082 |  | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-530ea6ea | this.btnItemId.Click | SCP0127_PrecedeSafetyStockDay.cs:1084 |  | POPUP | popItem.Form_Load | (true, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-02eed761 | this.btnItemId.Click | SCP0127_PrecedeSafetyStockDay.cs:1085 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2842582f | this.btnItemId.Click | SCP0127_PrecedeSafetyStockDay.cs:1086 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-0f81bc40 | this.btnItemId.Click | SCP0127_PrecedeSafetyStockDay.cs:1092 | if (itemId != "") | VALUE_SET | txtItemId.Text | itemId | 컨트롤 값 설정 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.CboPlanGroup_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-786f7cb3 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:888 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.CboPlanSeq_SelectedIndexChanged

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a1e07fd1 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:331 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.ClbDivision_SelectedIndexChanged

진입점: cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9c567d5a | cboDivision.SelectedIndexChanged | SCP0127_PrecedeSafetyStockDay.cs:883 |  | GRID_CLEAR | SpreadInfo.ClearDataSource | (spdMain) | 그리드 데이터/선택 비움 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-116450f8 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:288 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-70ccc48b | this.Load | SCP0127_PrecedeSafetyStockDay.cs:289 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-d5e66477 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:290 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-711e761c | this.Load | SCP0127_PrecedeSafetyStockDay.cs:151 |  | UI_PROP | pnlCondition.Height | 75 | 속성 Height 설정 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a8f7a447 | DeleteButton | SCP0127_PrecedeSafetyStockDay.cs:359 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41fcb0d2 | DeleteButton | SCP0127_PrecedeSafetyStockDay.cs:362 | if (fps.Name == "spdMain") | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-30eaf88f | Dispose | SCP0127_PrecedeSafetyStockDay.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d97926a6 | EditButton | SCP0127_PrecedeSafetyStockDay.cs:370 | if (spdMain != null) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-15466b29 | EditButton | SCP0127_PrecedeSafetyStockDay.cs:371 | if (spdMain != null) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-6f7a134d | EditButton | SCP0127_PrecedeSafetyStockDay.cs:372 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.DIVISION_… | 그리드 편집 잠금/해제 |  |  |  |
| AC-8e8c3b46 | EditButton | SCP0127_PrecedeSafetyStockDay.cs:374 | if (spdMain != null) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.PRE_KEY_VA… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b5a42919 | EditButton | SCP0127_PrecedeSafetyStockDay.cs:375 | if (spdMain != null) | FLAG | this._isEditMode | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.FindData_Main

진입점: FindButton / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d0456732 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:392 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-56eda049 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:397 | try | VALIDATE | DataUtil.checkRequired | (this.pnlCondition) | 프레임워크 검증 |  |  |  |
| AC-b79b54ca | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:397 | try ▸ if (!DataUtil.checkRequired(this.pnlCondition)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-fb74056b | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:401 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-9ed0856a | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:404 | try | GRID_INIT | siMain.ChangeSheet | (SpdSheet.shtMain) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-593078d8 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:429 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-54066425 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:430 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-482b4217 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:434 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY") ⇒ SCP.SCP0127_GET_PRECEDE_SAFETY_STOCK_DAY | 엔드포인트 요청 생성 |  |  |  |
| AC-9fafe52c | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:435 | try ▸ lambda | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-7bdcfab2 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:436 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-0ba70455 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:437 | try ▸ lambda | DATA_OP | request.Parameters["p_plan_group_id"] | pPlanGroup | 행/컬럼 값 대입 |  |  |  |
| AC-e4c9c963 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:438 | try ▸ lambda | DATA_OP | request.Parameters["p_scm_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-2ac8b092 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:439 | try ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | pItemId | 행/컬럼 값 대입 |  |  |  |
| AC-79a3fbf9 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:440 | try ▸ lambda | DATA_OP | request.Parameters["p_stage"] | pStage | 행/컬럼 값 대입 |  |  |  |
| AC-169b6741 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:441 | try ▸ lambda | DATA_OP | request.Parameters["p_valid_yn"] | pValidYn | 행/컬럼 값 대입 |  |  |  |
| AC-d3ea28cd | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:442 | try ▸ lambda | DATA_OP | request.Parameters["p_value_type"] | pType | 행/컬럼 값 대입 |  |  |  |
| AC-c278ebb4 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:444 | try ▸ lambda | DATA_OP | request.Parameters["p_period_from"] | pPeriodFrom | 행/컬럼 값 대입 |  |  |  |
| AC-67231f62 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:445 | try ▸ lambda | DATA_OP | request.Parameters["p_period_to"] | pPeriodTo | 행/컬럼 값 대입 |  |  |  |
| AC-8a0e1c1d | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:447 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d911884f | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:449 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-c5d12680 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:458 | try ▸ if (ds.Tables.Count > 0) | FLAG | this.dtPreSafeStockAll | ds.Tables[0].Copy() | 화면 필드/플래그 변경 |  |  |  |
| AC-543f806f | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:458 | try ▸ if (ds.Tables.Count > 0) | DATA_OP | ds.Tables[0].Copy | () | 데이터 객체 조작/조회 |  |  |  |
| AC-6993337f | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:462 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-fecabda9 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:463 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-d7a67778 | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:466 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-71d2acaf | FindButton 외 1 | SCP0127_PrecedeSafetyStockDay.cs:479 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5051f29 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:140 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.GetDivisionChecked

진입점: this.Load [else of (division.Equals("EE"))] / cboDivision.SelectedIndexChanged [else of (division.Equals("EE"))] / SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0cfca9a1 | this.Load [else of (division.Equals("EE"))] 외 3 | SCP0127_PrecedeSafetyStockDay.cs:252 |  | RETURN | return res; |  | 처리 중단/반환 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.GetSearchInfo

진입점: SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aacc228f | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0127_PrecedeSafetyStockDay.cs:207 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0127_GET_SEARCH_INFO") ⇒ SCP.SCP0127_GET_SEARCH_INFO | 엔드포인트 요청 생성 |  |  |  |
| AC-65810bc4 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0127_PrecedeSafetyStockDay.cs:209 |  | UI_PROP | request.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-d821ee1b | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0127_PrecedeSafetyStockDay.cs:210 |  | DATA_OP | request.Parameters["p_division_id"] | pDisvision | 행/컬럼 값 대입 |  |  |  |
| AC-9d0d65df | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0127_PrecedeSafetyStockDay.cs:211 |  | DATA_OP | request.Parameters["p_site_id"] | pSite | 행/컬럼 값 대입 |  |  |  |
| AC-d51683a8 | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0127_PrecedeSafetyStockDay.cs:212 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e60ba97f | SaveButton [for (i <= siMain.GetMaxRowIndex()) ▸ if (_change… | SCP0127_PrecedeSafetyStockDay.cs:216 |  | RETURN | return ds; |  | 처리 중단/반환 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-252bcb3c | this.Load | SCP0127_PrecedeSafetyStockDay.cs:156 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-6d2e4ccd | this.Load | SCP0127_PrecedeSafetyStockDay.cs:161 | if (dtMyDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-aa90cd4b | this.Load | SCP0127_PrecedeSafetyStockDay.cs:164 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-f7e27ec2 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:165 |  | FLAG | dtPlanGroupAll | dsSearchInfo.Tables[0] | 화면 필드/플래그 변경 |  |  |  |
| AC-fc6eb5bc | this.Load | SCP0127_PrecedeSafetyStockDay.cs:168 |  | FLAG | dtScmSiteAll | dsSearchInfo.Tables[1] | 화면 필드/플래그 변경 |  |  |  |
| AC-3621c760 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:171 |  | FLAG | dtStageAll | dsSearchInfo.Tables[2] | 화면 필드/플래그 변경 |  |  |  |
| AC-1201e458 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:174 |  | FLAG | dtType | dsSearchInfo.Tables[3] | 화면 필드/플래그 변경 |  |  |  |
| AC-b120dfed | this.Load | SCP0127_PrecedeSafetyStockDay.cs:175 |  | LIST_REBIND | clsCtrl.setListBox | (dtType, cboType, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-1238dfa7 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:178 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, true) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-9403f3b2 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:181 |  | FLAG | dtValidYn | dsSearchInfo.Tables[4] | 화면 필드/플래그 변경 |  |  |  |
| AC-b2c67db2 | this.Load | SCP0127_PrecedeSafetyStockDay.cs:183 |  | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.InitSpread

진입점: this.Load / FindButton [try] / SaveButton [if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ec6ea136 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:298 |  | UI_PROP | this.IsEditMode | false | 속성 IsEditMode 설정 |  |  |  |
| AC-e21f9a6d | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:299 |  | FLAG | this._isEditMode | false | 화면 필드/플래그 변경 |  |  |  |
| AC-29b9f7c0 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:301 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-2fecf113 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:306 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ScmSite", dtScmSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-bbfb5154 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:307 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Division", dtMyDivision) | 목록 컨트롤 재구성 |  |  |  |
| AC-281ea3cf | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:308 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlanGroup", dtPlanGroup) | 목록 컨트롤 재구성 |  |  |  |
| AC-9c631036 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:309 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("Stage", dtStage) | 목록 컨트롤 재구성 |  |  |  |
| AC-65a73233 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:310 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ValidYn", dtValidYn) | 목록 컨트롤 재구성 |  |  |  |
| AC-8f2235a8 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:313 |  | GRID_INIT | siMain.SetSheetHeaderColumnSCP | (siMain, 1, false, "") | 그리드 재구성/초기화 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.Insert_Row

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d5c89999 | InsertButton | SCP0127_PrecedeSafetyStockDay.cs:508 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-5df50fb1 | InsertButton | SCP0127_PrecedeSafetyStockDay.cs:514 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.DIVISION_ID, division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-b3f19f3a | InsertButton | SCP0127_PrecedeSafetyStockDay.cs:515 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefColumns.VALID_YN, "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-95843799 | InsertButton | SCP0127_PrecedeSafetyStockDay.cs:517 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-7622c8e5 | InsertButton | SCP0127_PrecedeSafetyStockDay.cs:519 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.DIVISION_ID), siMain.GetColumnIndex(DefColumns.… | 그리드 편집 잠금/해제 |  |  |  |
| AC-287368bf | InsertButton | SCP0127_PrecedeSafetyStockDay.cs:520 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefColumns.CREATED_BY), siMain.GetColumnIndex(DefColumns.L… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.RefreshPlanGroupByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1966ca7d | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:258 |  | FLAG | dtPlanGroup | DBUtils.Filter(dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 화면 필드/플래그 변경 |  |  |  |
| AC-bbfc70be | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:258 |  | DATA_OP | DBUtils.Filter | (dtPlanGroupAll, "DIVISION_ID = '" + division + "'", true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-ffc7e802 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:260 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlanGroup, clbPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.RefreshSiteByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9a08b0b1 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:268 | if (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 화면 필드/플래그 변경 |  |  |  |
| AC-9fbe35ab | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:268 | if (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID IN ('81','40','82')") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-fcccef8e | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:273 | else of (division.Equals("EE")) | FLAG | dtScmSite | DBUtils.Filter(dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-26857ead | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:273 | else of (division.Equals("EE")) | DATA_OP | DBUtils.Filter | (dtScmSiteAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-84459a19 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:275 |  | LIST_REBIND | clsCtrl.setListBox | (dtScmSite, clbSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.RefreshStageByDivision

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d71afc61 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:281 |  | FLAG | dtStage | DBUtils.Filter(dtStageAll, "DIVISION_ID = '" + division + "'") | 화면 필드/플래그 변경 |  |  |  |
| AC-02a5f75f | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:281 |  | DATA_OP | DBUtils.Filter | (dtStageAll, "DIVISION_ID = '" + division + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-5331c9b1 | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:283 |  | LIST_REBIND | clsCtrl.setListBox | (dtStage, cboStage, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-29a9ff5b | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:526 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8f34addc | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:528 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5c720cb5 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:648 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_value_type == string.Empty \|\| v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Em… | MESSAGE | MessageHelper.GMessageBox | ("MSG00001") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-cfcf9e78 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:649 | for (i <= siMain.GetMaxRowIndex()) ▸ if (v_value_type == string.Empty \|\| v_division_id == string.Empty \|\| v_opmz_plan_gr_id == string.Em… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a5cee864 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:674 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtPreSafeStockAll != null) | DATA_OP | DBUtils.Filter | (dtPreSafeStockAll, sb.ToString(), true) | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-0558f970 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:678 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtPreSafeStockAll != null) ▸ if (dtPreSafeStock.Rows.Count > 0 && action != CAppSetting.FlagD) | MESSAGE | MessageHelper.GMessageBox | ("MSG00260") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-895f0cb4 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:679 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtPreSafeStockAll != null) ▸ if (dtPreSafeStock.Rows.Count > 0 && action != CAppSetting.FlagD) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9c405bfd | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:699 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | MESSAGE | MessageHelper.GMessageBox | ("MSG00046", new object[] { "No Work Date" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-53c53402 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:700 | for (i <= siMain.GetMaxRowIndex()) ▸ catch ((Exception)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1a88c168 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:707 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-dc7458ee | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:708 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtFrom_date > dtTo_date) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-cc7e6b76 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:715 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt32(v_type_apply_day) < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-9fb0f1a2 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:716 | for (i <= siMain.GetMaxRowIndex()) ▸ if (Convert.ToInt32(v_type_apply_day) < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7ef5ad22 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:725 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dsSearchInfo | GetSearchInfo(CString.GetCheckedListValue(dtMyDivision, pCheckDivision).ToString()) | 화면 필드/플래그 변경 |  |  |  |
| AC-38b4f370 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:726 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | dtItemAll | dsSearchInfo.Tables[5] | 화면 필드/플래그 변경 |  |  |  |
| AC-4ac31fea | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:727 | for (i <= siMain.GetMaxRowIndex()) ▸ if (_changeDivision) | FLAG | _changeDivision | false | 화면 필드/플래그 변경 |  |  |  |
| AC-0c7569c3 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:730 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | DBUtils.Filter | (dtItemAll, "ITEM_ID = '" + v_item_id + "'") | 데이터 필터/행 값 설정·조회 |  |  |  |
| AC-cef9fff5 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:734 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00458", new object[] { v_item_id }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b3446319 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:735 | for (i <= siMain.GetMaxRowIndex()) ▸ if (dtItem.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d4547c2e | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:781 | if (iCount > 0) | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-a988888e | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:782 | if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-1429b737 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:786 | if (iCount > 0) ▸ try | ENDPOINT | new FoxDataRequest | ("SCP.SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY") ⇒ SCP.SCP0127_SAVE_PRECEDE_SAFETY_STOCK_DAY | 엔드포인트 요청 생성 |  |  |  |
| AC-8c8aa8d1 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:789 | if (iCount > 0) ▸ try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-cfe7cf3a | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:793 | if (iCount > 0) ▸ try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0eab0c38 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:795 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-42fada87 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:796 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_type"] | p_value_type | 행/컬럼 값 대입 |  |  |  |
| AC-df05cfca | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:797 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-121ae835 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:798 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_opmz_plan_gr_id"] | p_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-f668caef | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:799 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-074911c3 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:800 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-6f290ec5 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:801 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_stage"] | p_stage | 행/컬럼 값 대입 |  |  |  |
| AC-be71a9b0 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:802 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-ddab7c20 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:803 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-70d49ffd | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:804 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_type_apply_day"] | p_type_apply_day | 행/컬럼 값 대입 |  |  |  |
| AC-ae94fa09 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:805 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_value_description"] | p_value_description | 행/컬럼 값 대입 |  |  |  |
| AC-2f650fe4 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:806 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-3b989166 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:807 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-92e7f621 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:809 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_value_type"] | p_pre_value_type | 행/컬럼 값 대입 |  |  |  |
| AC-e063d994 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:810 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_division_id"] | p_pre_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-bf1f9e65 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:811 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_opmz_plan_gr_id"] | p_pre_opmz_plan_gr_id | 행/컬럼 값 대입 |  |  |  |
| AC-3db3fd4f | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:812 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_scm_site_id"] | p_pre_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-a3e57acc | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:813 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_item_id"] | p_pre_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-22bacb65 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:814 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_stage"] | p_pre_stage | 행/컬럼 값 대입 |  |  |  |
| AC-25a6ff00 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:815 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_from_yyyymmdd"] | p_pre_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7650cce9 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:816 | if (iCount > 0) ▸ try ▸ lambda | DATA_OP | req.Parameters["p_pre_to_yyyymmdd"] | p_pre_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-7f3b5806 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:818 | if (iCount > 0) ▸ try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-65e59d39 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:818 | if (iCount > 0) ▸ try ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-b6deb388 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:822 | if (iCount > 0) ▸ try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-02d8b60f | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:829 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ if (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { tran.DataSet.Tables[0].Rows[0][1] }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-995a428d | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:838 | if (iCount > 0) ▸ try ▸ if (tran.Success) ▸ else of (tran.DataSet.Tables[0].Rows[0][0].ToString() == "S") | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0cb0e5cd | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:845 | if (iCount > 0) ▸ catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-f009df8a | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:846 | if (iCount > 0) ▸ catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-efd86668 | SaveButton | SCP0127_PrecedeSafetyStockDay.cs:850 | if (iCount > 0) ▸ finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.Set_MeasureColor

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-68d4b9c2 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:486 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b95b8c5e | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:500 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b39fde8f | this.Load 외 2 | SCP0127_PrecedeSafetyStockDay.cs:337 |  | FLAG | _changeDivision | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.setPeriod

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5ef1763d | this.Load | SCP0127_PrecedeSafetyStockDay.cs:873 |  | UI_PROP | dCalendar.Text1 | sMondayDate | 속성 Text1 설정 |  |  |  |
| AC-23f9021d | this.Load | SCP0127_PrecedeSafetyStockDay.cs:874 |  | UI_PROP | dCalendar.Text2 | sToDate | 속성 Text2 설정 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.spdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a0408808 | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:908 |  | FLAG | this._currRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-81f8dfe7 | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:927 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (action != CAppSetting.FlagI && !this._isEditMode) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0f65b80d | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:935 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.OPMZ_PLAN_GR_ID, dtPlanGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b273a40c | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:940 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ if (e.Column =… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.SCM_SITE_ID, dtScmSite, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9f1df1d8 | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:944 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.STAGE, dtStage, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-62fc3a4f | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:948 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALUE_TYPE, dtType, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a39a3c38 | this.spdMain.CellClick | SCP0127_PrecedeSafetyStockDay.cs:952 | if (!siMain.IsLock(siMain.ActiveSheet.SheetName)) ▸ else of (e.Column == siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID)) ▸ else of (e.Col… | LIST_REBIND | SheetUtils.SetComboDataRow | (siMain, e.Row, DefColumns.VALID_YN, dtValidYn, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-67adce78 | this.spdMain.CellDoubleClick | SCP0127_PrecedeSafetyStockDay.cs:967 | if (!e.ColumnHeader) ▸ if (siMain.IsLock(siMain.SheetName) \|\| (siMain.GetText(e.Row, siMain.GetColumnIndex(CAppSetting.StringAction)) != C… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-777fdba8 | this.spdMain.CellDoubleClick | SCP0127_PrecedeSafetyStockDay.cs:980 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | new SCM0002_MaterialByDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a009dab6 | this.spdMain.CellDoubleClick | SCP0127_PrecedeSafetyStockDay.cs:982 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.Form_Load | (multiSelect, division, operation_group, sItemId, scp_module_type) | 팝업 초기화(인자 전달) |  |  |  |
| AC-a19d3b9e | this.spdMain.CellDoubleClick | SCP0127_PrecedeSafetyStockDay.cs:983 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-0b496377 | this.spdMain.CellDoubleClick | SCP0127_PrecedeSafetyStockDay.cs:984 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-b27f90d7 | this.spdMain.CellDoubleClick | SCP0127_PrecedeSafetyStockDay.cs:991 | if (!e.ColumnHeader) ▸ if (e.Column == siMain.GetColumnIndex(DefColumns.ITEM_ID)) ▸ if (!string.IsNullOrEmpty(sItemId)) ▸ if (siMain.GetColu… | GRID_SET | siMain.SetText | (e.Row, siMain.GetColumnIndex(DefColumns.ITEM_ID), sItemId) | 그리드 값 설정 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.SpdMain_ClipboardPasted

진입점: this.spdMain.ClipboardPasted

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1105af2d | this.spdMain.ClipboardPasted | SCP0127_PrecedeSafetyStockDay.cs:1110 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | DATA_OP | dtPlanGroup.Select | () | 데이터 객체 조작/조회 |  |  |  |
| AC-285dce89 | this.spdMain.ClipboardPasted | SCP0127_PrecedeSafetyStockDay.cs:1112 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ for (iRow < e.CellRange.Row + e.CellRange.RowCount) ▸ for (iCol < e.CellRa… | GRID_SET | siMain.SetValue | (iRow, siMain.GetColumnIndex(DefColumns.OPMZ_PLAN_GR_ID), codeVal) | 그리드 값 설정 |  |  |  |

## SCP0127_PrecedeSafetyStockDay.SpdMain_EditChange

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03d8affd | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1002 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)).T… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-91c9a07f | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1007 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (sToDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3051a48e | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1020 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2fae7121 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1021 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5cb1baf9 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1031 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | MESSAGE | MessageHelper.GMessageBox | ("MSG00219", new object[] { args }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e2a3be53 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1032 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD), "") | 그리드 값 설정 |  |  |  |
| AC-230b9f64 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1033 | if (e.Column == siMain.GetColumnIndex(DefColumns.TO_YYYYMMDD)) ▸ if (dFromDate > dToDate) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-85b173dc | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1043 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6bcd2f6f | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1048 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (string.IsNullOrWhiteSpace(sFromDate) \|\| sFromDate.Length != 10) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-5bdaeb62 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1055 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | MESSAGE | GSCM.App.Core.Text.MessageHelper.GMessageBox | ("MSG00049", new object[] { "" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6934589e | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1056 | if (e.Column == siMain.GetColumnIndex(DefColumns.FROM_YYYYMMDD)) ▸ if (!isValid) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-26db9163 | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1063 | if (e.Column == siMain.GetColumnIndex(DefColumns.TYPE_APPLY_DAY)) ▸ if (siMain.GetValue(e.Row, siMain.GetColumnIndex(DefColumns.TYPE_APPLY_D… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25ac3dea | (진입점 미연결) | SCP0127_PrecedeSafetyStockDay.cs:1070 | if (e.Column == siMain.GetColumnIndex(DefColumns.TYPE_APPLY_DAY)) ▸ if (iDayCount < 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { "0" }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0127_PrecedeSafetyStockDay.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f147f06c | this.spdMain.TopChange | SCP0127_PrecedeSafetyStockDay.cs:897 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

