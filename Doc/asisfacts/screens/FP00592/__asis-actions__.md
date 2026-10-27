# AS-IS 액션 대조표 — FP00592

> 원천: `Doc/asisfacts/screens/FP00592/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 69행 · 메서드 10 · 종류 DATA_OP 14 · FLAG 12 · UI_MISC 8 · GRID_INIT 7 · COMBO_DATA 5 · LIST_REBIND 4 · GRID_BIND 3 · RETURN 3 · CALL_EXT 3 · POPUP 2 · ENDPOINT 2 · MESSAGE 2 · GRID_SET 2 · GRID_STYLE 1 · VALIDATE 1 · ⚠ 의미 확인 필요 3


## FP00592_Initial_Setup_Validation.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7c7c331a | this.Load | FP00592_Initial_Setup_Validation.cs:198 |  | GRID_INIT | AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f33a7e14 | this.Load | FP00592_Initial_Setup_Validation.cs:199 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |

## FP00592_Initial_Setup_Validation.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41584ae7 | Dispose | FP00592_Initial_Setup_Validation.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## FP00592_Initial_Setup_Validation.FindGoData

진입점: spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) ▸ try ▸ if (r != null)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-85963f61 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:276 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-f4b76e1b | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:277 |  | DATA_OP | dictSpread.ContainsKey | (VALIDATION_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-e656e78d | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:279 | if (dictSpread.ContainsKey(VALIDATION_TYPE)) | FLAG | siData | GetSheetInfo(spdData.Name, VALIDATION_TYPE) | 화면 필드/플래그 변경 |  |  |  |
| AC-49a8c5be | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:280 | if (dictSpread.ContainsKey(VALIDATION_TYPE)) | GRID_INIT | siData.ChangeActiveSheet | (VALIDATION_TYPE) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-555c5847 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:287 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-c6600dcf | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:298 | try | DATA_OP | Filter["setup_code"] | VALIDATION_TYPE | 행/컬럼 값 대입 |  |  |  |
| AC-7dbb18b4 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:301 | try | ENDPOINT | DataService.FP_ExecuteProcedure | ("PR_UI_FP00592_VALIDATION", Filter, p_sys_type ) | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-eec00aa0 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:302 | try | DATA_OP | dictDs.ContainsKey | (VALIDATION_TYPE) | 데이터 객체 조작/조회 |  |  |  |
| AC-777a4a0b | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:303 | try ▸ if (dictDs.ContainsKey(VALIDATION_TYPE)) | DATA_OP | dictDs[VALIDATION_TYPE] | dsValidation | 행/컬럼 값 대입 |  |  |  |
| AC-34491f1a | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:305 | try ▸ else of (dictDs.ContainsKey(VALIDATION_TYPE)) | DATA_OP | dictDs.Add | (VALIDATION_TYPE, dsValidation) | 데이터 객체 조작/조회 |  |  |  |
| AC-f0f233ec | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:310 | try ▸ if (dsValidation.Good()) | GRID_INIT | siData.SetSheetHeaderFromDataSource | (siData, dsValidation, null, null, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-a01be3ac | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:312 | try ▸ if (dsValidation.Good()) | GRID_STYLE | siData.setColumnWidth | (1, 0) | 그리드 표시 설정 |  |  |  |
| AC-c2aca140 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:314 | try ▸ if (dsValidation.Good()) | GRID_BIND | siData.Query | (dictDs[VALIDATION_TYPE], true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-88f39a63 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:318 | try ▸ else of (dsValidation.Good()) | GRID_BIND | siData.Query | (null, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-d47efcf3 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:326 | try | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-677b8aa4 | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:331 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-cfa7d6dd | spdMain.CellClick [if (nCol == siMain.GetColumnIndex(DefColu… | FP00592_Initial_Setup_Validation.cs:334 |  | RETURN | return totalRow; |  | 처리 중단/반환 |  |  |  |

## FP00592_Initial_Setup_Validation.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e2520077 | this.Load | FP00592_Initial_Setup_Validation.cs:99 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-fbf88da5 | this.Load | FP00592_Initial_Setup_Validation.cs:102 |  | DATA_OP | Filter["SCREEN_EXCEPTION"] | "Y" | 행/컬럼 값 대입 |  |  |  |
| AC-b170fe34 | this.Load | FP00592_Initial_Setup_Validation.cs:103 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |

## FP00592_Initial_Setup_Validation.GoMain

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c954d19c | this.Load | FP00592_Initial_Setup_Validation.cs:345 | try ▸ if (blnWork) | MESSAGE | MessageHelper.GMessageBox | ("MSG00137") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-d4bcd3a9 | this.Load | FP00592_Initial_Setup_Validation.cs:346 | try ▸ if (blnWork) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f3bd2113 | this.Load | FP00592_Initial_Setup_Validation.cs:349 | try | FLAG | blnWork | true | 화면 필드/플래그 변경 |  |  |  |
| AC-0a94a280 | this.Load | FP00592_Initial_Setup_Validation.cs:351 | try | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-42098726 | this.Load | FP00592_Initial_Setup_Validation.cs:351 | try ▸ if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b6baf509 | this.Load | FP00592_Initial_Setup_Validation.cs:354 | try | UI_MISC | MessageService.ShowProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-beb0ad9e | this.Load | FP00592_Initial_Setup_Validation.cs:358 | try | FLAG | dsMain | null | 화면 필드/플래그 변경 |  |  |  |
| AC-a106c3b0 | this.Load | FP00592_Initial_Setup_Validation.cs:368 | try | DATA_OP | column_params.Add | ("ACTIVE_FLAG", "Y") | 데이터 객체 조작/조회 |  |  |  |
| AC-fecfc711 | this.Load | FP00592_Initial_Setup_Validation.cs:370 | try | FLAG | dsMain | DataService.FP_ExecuteQuery("FP00592_Initial_Setup_Validation", "find_InitalSetup", column… ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InitalSetup] \| FP\ADMIN\F… | 화면 필드/플래그 변경 |  |  |  |
| AC-6920daff | this.Load | FP00592_Initial_Setup_Validation.cs:370 | try | ENDPOINT | DataService.FP_ExecuteQuery | ("FP00592_Initial_Setup_Validation", "find_InitalSetup", column_params, "ADMIN") ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=find_InitalSetup] \| FP\ADMIN\F… | 프레임워크 경유 SP/쿼리 실행(첫 인자 = SP·쿼리 ID) |  |  |  |
| AC-97b3f648 | this.Load | FP00592_Initial_Setup_Validation.cs:371 | try | GRID_BIND | siMain.Query | (dsMain, true) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-75d516ec | this.Load | FP00592_Initial_Setup_Validation.cs:377 | try | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-9a13cd24 | this.Load | FP00592_Initial_Setup_Validation.cs:384 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | CALL_EXT | r["setup_code"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-40594956 | this.Load | FP00592_Initial_Setup_Validation.cs:385 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | CALL_EXT | r["setup_desc"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-9a0cfa05 | this.Load | FP00592_Initial_Setup_Validation.cs:386 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | GRID_INIT | AddSheet | (spdData, setup_desc, setup_desc, 1, 1, 30) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5675f39c | this.Load | FP00592_Initial_Setup_Validation.cs:387 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) | DATA_OP | dictSpread.ContainsKey | (setup_desc) | 데이터 객체 조작/조회 |  |  |  |
| AC-ab4b8dbc | this.Load | FP00592_Initial_Setup_Validation.cs:389 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ if (!dictSpread.ContainsKey(setup_desc)) | DATA_OP | dictSpread.Add | (setup_desc, index) | 데이터 객체 조작/조회 |  |  |  |
| AC-c730ee3c | this.Load | FP00592_Initial_Setup_Validation.cs:390 | try ▸ if (dsMain.Good()) ▸ foreach (DataRow r in dsMain.Tables[0].Rows) ▸ if (!dictSpread.ContainsKey(setup_desc)) | FLAG | siData | GetSheetInfo(spdData.Name, setup_desc) | 화면 필드/플래그 변경 |  |  |  |
| AC-b2970017 | this.Load | FP00592_Initial_Setup_Validation.cs:401 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0d6aecf3 | this.Load | FP00592_Initial_Setup_Validation.cs:406 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |
| AC-eecab6ae | this.Load | FP00592_Initial_Setup_Validation.cs:407 | finally | UI_MISC | MessageService.CloseProgress | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## FP00592_Initial_Setup_Validation.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-50b29cfc | this.Load | FP00592_Initial_Setup_Validation.cs:124 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |

## FP00592_Initial_Setup_Validation.InitSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fab6ea3 | this.Load | FP00592_Initial_Setup_Validation.cs:208 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-3139d41a | this.Load | FP00592_Initial_Setup_Validation.cs:209 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.SetSheetHeaderColumn | (spreadInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-da29ce4b | this.Load | FP00592_Initial_Setup_Validation.cs:210 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## FP00592_Initial_Setup_Validation.SetChangeControl

진입점: this.Load / cboSite.SelectedIndexChanged / cboInstance.SelectedIndexChanged / cboPlant.SelectedIndexChanged / cboFactory.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c79b46a9 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:145 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (!dtSite.Good()) | FLAG | dtSite | DataService.GetInnerTable("SITE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b576866f | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:145 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (!dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("SITE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-c85002f0 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:149 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-b7f1cae8 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:150 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | DATA_OP | Filter[DefColumns.SITE_ID] | CString.GetCheckedListValue(dtSite, cboSite.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-f93c82e0 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:154 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_BY_SITE", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-18274864 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:154 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_BY_SITE", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-ed3b85a1 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:155 | switch (triggerControl) case DefColumns.SITE_ID: ▸ if (dtSite.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-5f2778ce | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:161 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | FLAG | dtInstance | DataService.GetInnerTable("INSTANCE_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-5dd887f4 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:161 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (!dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("INSTANCE_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-0b705a0c | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:169 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | FLAG | dtPlant | DataService.GetInnerTable("PLANT_ID", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-4e56595d | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:169 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | COMBO_DATA | DataService.GetInnerTable | ("PLANT_ID", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-863d1276 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:170 | switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtPlant, cboPlant, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-2f39888e | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:176 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | DATA_OP | Filter["PLANT_ID"] | CString.GetCheckedListValue(dtPlant, cboPlant.ControlValues) | 행/컬럼 값 대입 |  |  |  |
| AC-c2b493cc | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:177 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | FLAG | dtFactory | DataService.GetInnerTable("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 화면 필드/플래그 변경 |  |  |  |
| AC-c5236ce7 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:177 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | COMBO_DATA | DataService.GetInnerTable | ("FACTORY_ID", Filter) ⇒ biz:FPCommonDataBLL.GeneralExecuteQuery [batchId=list_release_building] \| FP\CO… | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |
| AC-f8ce36eb | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:178 | switch (triggerControl) case DefColumns.PLANT_ID: ▸ if (dtPlant.Good()) | LIST_REBIND | clsCtrl.setListBox | (dtFactory, cboFactory, true, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-eb6b6342 | this.Load 외 4 | FP00592_Initial_Setup_Validation.cs:185 | switch (triggerControl) case DefColumns.FACTORY_ID: ▸ if (dtFactory.Good()) | DATA_OP | Filter["FACTORY_ID"] | CString.GetCheckedListValue(dtFactory, cboFactory.ControlValues) | 행/컬럼 값 대입 |  |  |  |

## FP00592_Initial_Setup_Validation.SetFilter

진입점: this.Load [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboSite.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboInstance.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboPlant.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())] / cboFactory.SelectedIndexChanged [switch (triggerControl) case DefColumns.INSTANCE_ID: ▸ if (dtInstance.Good())]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f9d9099c | this.Load [switch (triggerControl) case DefColumns.INSTANCE_… 외 4 | FP00592_Initial_Setup_Validation.cs:135 |  | DATA_OP | Filter[key] | value | 행/컬럼 값 대입 |  |  |  |

## FP00592_Initial_Setup_Validation.SpdMain_CellClick

진입점: spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-4ca5ffce | spdMain.CellClick | FP00592_Initial_Setup_Validation.cs:432 | if (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.COUNT), "") | 그리드 값 설정 |  |  |  |
| AC-1732a25c | spdMain.CellClick | FP00592_Initial_Setup_Validation.cs:439 | if (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) ▸ try ▸ if (r != null) | CALL_EXT | r["setup_desc"].ToSafeString | () | ⚠ 의미 확인 필요 |  |  |  |
| AC-b669abf0 | spdMain.CellClick | FP00592_Initial_Setup_Validation.cs:440 | if (nCol == siMain.GetColumnIndex(DefColumns.QUERY) && !e.ColumnHeader) ▸ try ▸ if (r != null) | GRID_SET | siMain.SetValue | (nRow, siMain.GetColumnIndex(DefColumns.COUNT), total_row) | 그리드 값 설정 |  |  |  |

