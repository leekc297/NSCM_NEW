# AS-IS 액션 대조표 — SCP0004

> 원천: `Doc/asisfacts/screens/SCP0004/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 66행 · 메서드 8 · 종류 GRID_INIT 21 · FLAG 8 · DATA_OP 7 · LIST_REBIND 7 · COMBO_DATA 6 · UI_MISC 4 · ENDPOINT 3 · RETURN 2 · POPUP 2 · CALL_EXT 2 · MESSAGE 1 · UI_PROP 1 · GRID_BIND 1 · GRID_LOCK 1 · ⚠ 의미 확인 필요 2


## SCP0004_SetupMatrix.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6c830f7e | this.Load | SCP0004_SetupMatrix.cs:127 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 2, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f3d1f641 | this.Load | SCP0004_SetupMatrix.cs:128 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-907dba17 | this.Load | SCP0004_SetupMatrix.cs:130 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0004_SetupMatrix.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-910cf931 | Dispose | SCP0004_SetupMatrix.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0004_SetupMatrix.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f7cc2924 | EditButton | SCP0004_SetupMatrix.cs:178 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c1b156cd | EditButton | SCP0004_SetupMatrix.cs:179 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0004_SetupMatrix.FindData

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-31287d17 | FindButton | SCP0004_SetupMatrix.cs:187 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-70d5c9c4 | FindButton | SCP0004_SetupMatrix.cs:193 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-18a9d8ce | FindButton | SCP0004_SetupMatrix.cs:208 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-8a45ffca | FindButton | SCP0004_SetupMatrix.cs:209 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-2a685e73 | FindButton | SCP0004_SetupMatrix.cs:213 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0004_GET_SETUP_MATRIX") ⇒ SCP.SCP0004_GET_SETUP_MATRIX | 엔드포인트 요청 생성 |  |  |  |
| AC-eeb82865 | FindButton | SCP0004_SetupMatrix.cs:214 | try ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-5c603793 | FindButton | SCP0004_SetupMatrix.cs:215 | try ▸ lambda | DATA_OP | request.Parameters["p_plant_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-48cd2611 | FindButton | SCP0004_SetupMatrix.cs:216 | try ▸ lambda | DATA_OP | request.Parameters["p_operation_id"] | pOperation | 행/컬럼 값 대입 |  |  |  |
| AC-a10a158c | FindButton | SCP0004_SetupMatrix.cs:217 | try ▸ lambda | DATA_OP | request.Parameters["p_from_item_setup_group_id"] | pFromSetupGroup.Equals("ALL") \|\| pFromSetupGroup.Equals("") ? DBNull.Value : pFromSetupG… | 행/컬럼 값 대입 |  |  |  |
| AC-e7d57df8 | FindButton | SCP0004_SetupMatrix.cs:218 | try ▸ lambda | DATA_OP | request.Parameters["p_to_item_setup_group_id"] | pToSetupGroup.Equals("ALL") \|\| pToSetupGroup.Equals("") ? DBNull.Value : pToSetupGroup | 행/컬럼 값 대입 |  |  |  |
| AC-6e672c34 | FindButton | SCP0004_SetupMatrix.cs:219 | try ▸ lambda | DATA_OP | request.Parameters["p_setup_condition_id"] | pSetupCondition.Equals("ALL") \|\| pSetupCondition.Equals("") ? DBNull.Value : pSetupCondi… | 행/컬럼 값 대입 |  |  |  |
| AC-5435b2fb | FindButton | SCP0004_SetupMatrix.cs:220 | try ▸ lambda | DATA_OP | request.Parameters["p_category_id"] | pCategory | 행/컬럼 값 대입 |  |  |  |
| AC-c748b622 | FindButton | SCP0004_SetupMatrix.cs:221 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a0ee9108 | FindButton | SCP0004_SetupMatrix.cs:223 | try ▸ lambda | RETURN | return response.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-f646748d | FindButton | SCP0004_SetupMatrix.cs:230 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-713c1560 | FindButton | SCP0004_SetupMatrix.cs:231 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8eb99fa6 | FindButton | SCP0004_SetupMatrix.cs:234 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-013bca4f | FindButton | SCP0004_SetupMatrix.cs:237 | try | GRID_INIT | siMain.VisibleAlternatingRow | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-0567d7d0 | FindButton | SCP0004_SetupMatrix.cs:247 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0004_SetupMatrix.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d7864336 | this.Load | SCP0004_SetupMatrix.cs:93 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0004_SetupMatrix.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e60854ce | this.Load | SCP0004_SetupMatrix.cs:109 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-d002829e | this.Load | SCP0004_SetupMatrix.cs:111 |  | LIST_REBIND | clsCtrl.setListBox | (dtMyDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0004_SetupMatrix.InitSpread

진입점: this.Load / FindButton [try]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-da098d5c | this.Load 외 1 | SCP0004_SetupMatrix.cs:139 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.InitSheet | (spreadInfo.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-6e738022 | this.Load 외 1 | SCP0004_SetupMatrix.cs:141 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Division", DefColumns.DIVISION_ID, FPMerge.None, 50, true, FPHAlign.Center, FPVAlign.Cen… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8a36f0ec | this.Load 외 1 | SCP0004_SetupMatrix.cs:142 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Division Name", DefColumns.DIVISION_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dae0eead | this.Load 외 1 | SCP0004_SetupMatrix.cs:143 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Plant", DefColumns.PLANT_ID, FPMerge.None, 60, true, FPHAlign.Center, FPVAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-12f6dd05 | this.Load 외 1 | SCP0004_SetupMatrix.cs:144 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Plant Name", DefColumns.PLANT_NAME, FPMerge.None, 160, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bc1bc91b | this.Load 외 1 | SCP0004_SetupMatrix.cs:145 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation", DefColumns.OPERATION_ID, FPMerge.None, 70, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-eb9ce381 | this.Load 외 1 | SCP0004_SetupMatrix.cs:146 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Operation Name", DefColumns.OPERATION_NAME, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-407baffc | this.Load 외 1 | SCP0004_SetupMatrix.cs:147 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Setup Group", DefColumns.LINE_SETUP_GROUP_ID, FPMerge.None, 180, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2e992cb9 | this.Load 외 1 | SCP0004_SetupMatrix.cs:148 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Category", DefColumns.SETUP_CATEGORY_ID, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8d9c7fcf | this.Load 외 1 | SCP0004_SetupMatrix.cs:149 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Class", DefColumns.CLASS, FPMerge.None, 80, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-bbddd6a2 | this.Load 외 1 | SCP0004_SetupMatrix.cs:150 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("From Setup Group", DefColumns.FROM_ITEM_SETUP_GROUP_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-ce8d3922 | this.Load 외 1 | SCP0004_SetupMatrix.cs:151 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("To Setup Group", DefColumns.TO_ITEM_SETUP_GROUP_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-593e1ade | this.Load 외 1 | SCP0004_SetupMatrix.cs:152 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddTextColumn | ("Setup Condition", DefColumns.SETUP_CONDITION_ID, FPMerge.None, 120, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-664481ca | this.Load 외 1 | SCP0004_SetupMatrix.cs:153 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.AddNumColumn | ("Setup Time", DefColumns.SETUP_TIME, FPMerge.None, 140, true, FPHAlign.Right, FPVAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-69aec3dd | this.Load 외 1 | SCP0004_SetupMatrix.cs:155 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (0, siMain.GetColumnIndex(DefColumns.PLANT_NAME)) | ⚠ 의미 확인 필요 |  |  |  |
| AC-91bde5db | this.Load 외 1 | SCP0004_SetupMatrix.cs:156 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.OPERATION_ID), 1, 3, 25, "Line Setup Group", FPHAlign… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d6719d6d | this.Load 외 1 | SCP0004_SetupMatrix.cs:157 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefColumns.SETUP_CATEGORY_ID), 1, 4, 25, "Material Setup Group",… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8316b69a | this.Load 외 1 | SCP0004_SetupMatrix.cs:158 | if (spreadInfo.SheetName == SpdSheet.shtMain) | CALL_EXT | siMain.ColumnHeaderSpanRow | (siMain.GetColumnIndex(DefColumns.SETUP_CONDITION_ID), siMain.GetColumnIndex(DefColumns.SE… | ⚠ 의미 확인 필요 |  |  |  |
| AC-1b6c8301 | this.Load 외 1 | SCP0004_SetupMatrix.cs:160 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.Freeze | (0, siMain.GetColumnIndex(DefColumns.PLANT_NAME)) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-e9d8f3dc | this.Load 외 1 | SCP0004_SetupMatrix.cs:162 | if (spreadInfo.SheetName == SpdSheet.shtMain) | GRID_INIT | spreadInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0004_SetupMatrix.SetCheckedListControl

진입점: this.Load / cboDivision.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbOperation.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-244b0d01 | this.Load 외 3 | SCP0004_SetupMatrix.cs:266 | switch (control.Name) case "clbPlant": | FLAG | dtPlantByDivision | Data.Common(Data.Type.Auth_Plant, false, UserInfoContext.Current["NowGroupID"], UserInfo.U… ⇒ biz:CommonData.CommonDataList [code=Auth_Plant] | 화면 필드/플래그 변경 |  |  |  |
| AC-de1eb87d | this.Load 외 3 | SCP0004_SetupMatrix.cs:266 | switch (control.Name) case "clbPlant": | COMBO_DATA | Data.Common | (Data.Type.Auth_Plant, false, UserInfoContext.Current["NowGroupID"], UserInfo.UserId, divi… ⇒ biz:CommonData.CommonDataList [code=Auth_Plant] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-6edde8a5 | this.Load 외 3 | SCP0004_SetupMatrix.cs:267 | switch (control.Name) case "clbPlant": | LIST_REBIND | clsCtrl.setListBox | (dtPlantByDivision, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-a1107436 | this.Load 외 3 | SCP0004_SetupMatrix.cs:271 | switch (control.Name) case "clbOperation": | FLAG | dtOperation | Data.CallBizCommonData("SETUP_MATRIX_OPERATION", division, plant) ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | 화면 필드/플래그 변경 |  |  |  |
| AC-fa75449a | this.Load 외 3 | SCP0004_SetupMatrix.cs:271 | switch (control.Name) case "clbOperation": | COMBO_DATA | Data.CallBizCommonData | ("SETUP_MATRIX_OPERATION", division, plant) ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_OPERATION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d42701b1 | this.Load 외 3 | SCP0004_SetupMatrix.cs:272 | switch (control.Name) case "clbOperation": | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-778df12c | this.Load 외 3 | SCP0004_SetupMatrix.cs:276 | switch (control.Name) case "clbCategory": | FLAG | dtCategory | Data.CallBizCommonData("SETUP_MATRIX_CATEGORY") ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | 화면 필드/플래그 변경 |  |  |  |
| AC-79ab0176 | this.Load 외 3 | SCP0004_SetupMatrix.cs:276 | switch (control.Name) case "clbCategory": | COMBO_DATA | Data.CallBizCommonData | ("SETUP_MATRIX_CATEGORY") ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_CATEGORY] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-905824f0 | this.Load 외 3 | SCP0004_SetupMatrix.cs:277 | switch (control.Name) case "clbCategory": | LIST_REBIND | clsCtrl.setListBox | (dtCategory, clbCategory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c601db84 | this.Load 외 3 | SCP0004_SetupMatrix.cs:281 | switch (control.Name) case "clbFromSetupGroup": | FLAG | dtFromSetupGroup | Data.CallBizCommonData("SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID", division, plant, operation… ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-31a49957 | this.Load 외 3 | SCP0004_SetupMatrix.cs:281 | switch (control.Name) case "clbFromSetupGroup": | COMBO_DATA | Data.CallBizCommonData | ("SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID", division, plant, operation) ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f8c87f5 | this.Load 외 3 | SCP0004_SetupMatrix.cs:282 | switch (control.Name) case "clbFromSetupGroup": | LIST_REBIND | clsCtrl.setListBox | (dtFromSetupGroup, clbFromSetupGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-55a1c9b7 | this.Load 외 3 | SCP0004_SetupMatrix.cs:286 | switch (control.Name) case "clbToSetupGroup": | FLAG | dtToSetupGroup | Data.CallBizCommonData("SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID", division, plant, operation… ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | 화면 필드/플래그 변경 |  |  |  |
| AC-62049392 | this.Load 외 3 | SCP0004_SetupMatrix.cs:286 | switch (control.Name) case "clbToSetupGroup": | COMBO_DATA | Data.CallBizCommonData | ("SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID", division, plant, operation) ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f5d29a2c | this.Load 외 3 | SCP0004_SetupMatrix.cs:287 | switch (control.Name) case "clbToSetupGroup": | LIST_REBIND | clsCtrl.setListBox | (dtToSetupGroup, clbToSetupGroup, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-151a1400 | this.Load 외 3 | SCP0004_SetupMatrix.cs:291 | switch (control.Name) case "clbSetupCondition": | FLAG | dtSetupCondition | Data.CallBizCommonData("SETUP_MATRIX_SETUP_CONDITION", division, plant, operation, fromSet… ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | 화면 필드/플래그 변경 |  |  |  |
| AC-4908d2ac | this.Load 외 3 | SCP0004_SetupMatrix.cs:291 | switch (control.Name) case "clbSetupCondition": | COMBO_DATA | Data.CallBizCommonData | ("SETUP_MATRIX_SETUP_CONDITION", division, plant, operation, fromSetupGroup, toSetupGroup) ⇒ biz:CommonData.CommonDataList [code=SETUP_MATRIX_SETUP_CONDITION] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9d951a3b | this.Load 외 3 | SCP0004_SetupMatrix.cs:292 | switch (control.Name) case "clbSetupCondition": | LIST_REBIND | clsCtrl.setListBox | (dtSetupCondition, clbSetupCondition, true) | 목록 컨트롤 재구성 |  |  |  |

