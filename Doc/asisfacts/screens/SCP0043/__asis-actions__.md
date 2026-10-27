# AS-IS 액션 대조표 — SCP0043

> 원천: `Doc/asisfacts/screens/SCP0043/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 111행 · 메서드 11 · 종류 FLAG 20 · LIST_REBIND 20 · COMBO_DATA 19 · DATA_OP 15 · UI_MISC 6 · GRID_INIT 4 · RETURN 4 · CALL_EXT 4 · VALUE_SET 4 · UI_PROP 3 · ENDPOINT 3 · GRID_STYLE 3 · POPUP 2 · VALIDATE 1 · GRID_BIND 1 · GRID_LOCK 1 · MESSAGE 1 · ⚠ 의미 확인 필요 4


## SCP0043_WOCreate.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f84e16a8 | this.Load | SCP0043_WOCreate.cs:119 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-24dbaec1 | this.Load | SCP0043_WOCreate.cs:120 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-8bcb55ca | this.Load | SCP0043_WOCreate.cs:122 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0043_WOCreate.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1321aec | this.Load | SCP0043_WOCreate.cs:97 |  | UI_PROP | usrConditionPanel1.Height | 100 | 속성 Height 설정 |  |  |  |

## SCP0043_WOCreate.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-759dd231 | Dispose | SCP0043_WOCreate.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0043_WOCreate.FindData_Main

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-efb8145f | FindButton | SCP0043_WOCreate.cs:313 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-acc7c628 | FindButton | SCP0043_WOCreate.cs:313 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-348ddbc8 | FindButton | SCP0043_WOCreate.cs:321 |  | CALL_EXT | CString.GetComboBoxValue | (cboInstance.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-817288e7 | FindButton | SCP0043_WOCreate.cs:322 |  | CALL_EXT | CString.GetComboBoxValue | (cboPlanID.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-5e671290 | FindButton | SCP0043_WOCreate.cs:325 |  | CALL_EXT | CString.GetComboBoxValue | (cboSite.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-d278fcbf | FindButton | SCP0043_WOCreate.cs:332 |  | CALL_EXT | CString.GetComboBoxValue | (cboValid.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-cc4c0522 | FindButton | SCP0043_WOCreate.cs:340 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-4273d667 | FindButton | SCP0043_WOCreate.cs:342 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-f5e50e06 | FindButton | SCP0043_WOCreate.cs:345 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-cc6d8778 | FindButton | SCP0043_WOCreate.cs:348 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-aee951d6 | FindButton | SCP0043_WOCreate.cs:351 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("FP.SCP0043_GET_WO_CREATE") ⇒ FP.SCP0043_GET_WO_CREATE | 엔드포인트 요청 생성 |  |  |  |
| AC-e5d6aff3 | FindButton | SCP0043_WOCreate.cs:352 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-0fb16361 | FindButton | SCP0043_WOCreate.cs:353 | try ▸ lambda | DATA_OP | req.Parameters["P_INSTANCE_ID"] | p_instance_id | 행/컬럼 값 대입 |  |  |  |
| AC-20ef16f6 | FindButton | SCP0043_WOCreate.cs:354 | try ▸ lambda | DATA_OP | req.Parameters["P_FP_PLAN_ID"] | p_fp_plan_id | 행/컬럼 값 대입 |  |  |  |
| AC-f926945e | FindButton | SCP0043_WOCreate.cs:355 | try ▸ lambda | DATA_OP | req.Parameters["P_PLAN_DATE"] | p_plan_date | 행/컬럼 값 대입 |  |  |  |
| AC-4e1cb613 | FindButton | SCP0043_WOCreate.cs:356 | try ▸ lambda | DATA_OP | req.Parameters["P_DIVISION_ID"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-de222c40 | FindButton | SCP0043_WOCreate.cs:357 | try ▸ lambda | DATA_OP | req.Parameters["P_SITE_ID"] | p_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-cea8425b | FindButton | SCP0043_WOCreate.cs:358 | try ▸ lambda | DATA_OP | req.Parameters["P_PLANT_ID"] | p_plant_id | 행/컬럼 값 대입 |  |  |  |
| AC-abb9178d | FindButton | SCP0043_WOCreate.cs:359 | try ▸ lambda | DATA_OP | req.Parameters["P_FACTORY_ID"] | p_factory_id | 행/컬럼 값 대입 |  |  |  |
| AC-1d30c131 | FindButton | SCP0043_WOCreate.cs:360 | try ▸ lambda | DATA_OP | req.Parameters["P_OPERATION_ID"] | p_operation_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e715051 | FindButton | SCP0043_WOCreate.cs:361 | try ▸ lambda | DATA_OP | req.Parameters["P_LINE_ID"] | p_line_id | 행/컬럼 값 대입 |  |  |  |
| AC-f390bde3 | FindButton | SCP0043_WOCreate.cs:362 | try ▸ lambda | DATA_OP | req.Parameters["P_ITEM_ID"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-73c3c11c | FindButton | SCP0043_WOCreate.cs:363 | try ▸ lambda | DATA_OP | req.Parameters["P_WORK_ORDER_ID"] | p_work_order_id | 행/컬럼 값 대입 |  |  |  |
| AC-51bcaf45 | FindButton | SCP0043_WOCreate.cs:364 | try ▸ lambda | DATA_OP | req.Parameters["P_PUBLICATION_TARGET_ONLY"] | p_publication_target | 행/컬럼 값 대입 |  |  |  |
| AC-065c661b | FindButton | SCP0043_WOCreate.cs:365 | try ▸ lambda | DATA_OP | req.Parameters["P_BUCKET_FROM"] | p_bucket_from | 행/컬럼 값 대입 |  |  |  |
| AC-d4156393 | FindButton | SCP0043_WOCreate.cs:366 | try ▸ lambda | DATA_OP | req.Parameters["P_BUCKET_TO"] | p_bucket_to | 행/컬럼 값 대입 |  |  |  |
| AC-caf984ac | FindButton | SCP0043_WOCreate.cs:367 | try ▸ lambda | DATA_OP | req.Parameters["P_USER_ID"] | p_user_id | 행/컬럼 값 대입 |  |  |  |
| AC-0ec7ae68 | FindButton | SCP0043_WOCreate.cs:369 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-e7ce3cd9 | FindButton | SCP0043_WOCreate.cs:370 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-0191c432 | FindButton | SCP0043_WOCreate.cs:377 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-ca3939db | FindButton | SCP0043_WOCreate.cs:378 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-797b907a | FindButton | SCP0043_WOCreate.cs:381 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1b3dacdd | FindButton | SCP0043_WOCreate.cs:384 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-89f57e49 | FindButton | SCP0043_WOCreate.cs:390 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7acb7ff7 | FindButton | SCP0043_WOCreate.cs:392 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0fd301cf | FindButton | SCP0043_WOCreate.cs:394 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a2035022 | FindButton | SCP0043_WOCreate.cs:395 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0043_WOCreate.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3cac487b | this.Load | SCP0043_WOCreate.cs:84 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0043_WOCreate.GetDayRange

진입점: this.Load / cboInstance.SelectedIndexChanged [else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE")] / drpPlanDate.ValueChanged [else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE")] / cboPlanID.SelectedIndexChanged [else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE")] / clbDivision.SelectedIndexChanged [else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE")] / cboSite.SelectedIndexChanged [else of (arg…

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c1a550c7 | this.Load 외 9 | SCP0043_WOCreate.cs:477 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0043_WOCreate.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b09c344 | (진입점 미연결) | SCP0043_WOCreate.cs:135 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SCP0043", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-45810144 | (진입점 미연결) | SCP0043_WOCreate.cs:137 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0043_WOCreate.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ccc06e1 | this.Load | SCP0043_WOCreate.cs:105 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-4bcae194 | this.Load | SCP0043_WOCreate.cs:107 |  | LIST_REBIND | clsCtrl.setListBox | (dtInstance, cboInstance, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-60610863 | this.Load | SCP0043_WOCreate.cs:109 |  | LIST_REBIND | cboValid.DataBind | (Data.Type.YesOrNo, false) ⇒ biz:CommonData.YesOrNo | 목록 컨트롤 재구성 |  |  |  |
| AC-127b7dde | this.Load | SCP0043_WOCreate.cs:110 |  | VALUE_SET | cboValid.SelectedValue | "Y" | 컨트롤 값 설정 |  |  |  |
| AC-30ec85cd | this.Load | SCP0043_WOCreate.cs:114 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCP0043_WOCreate.InitSpread

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f6d78905 | this.Load 외 1 | SCP0043_WOCreate.cs:128 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0043_WOCreate.SetChangedControl

진입점: this.Load / cboInstance.SelectedIndexChanged / drpPlanDate.ValueChanged / cboPlanID.SelectedIndexChanged / clbDivision.SelectedIndexChanged / cboSite.SelectedIndexChanged / clbPlant.SelectedIndexChanged / clbFactory.SelectedIndexChanged / clbOperation.SelectedIndexChanged / clbLine.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9100b9e | this.Load 외 9 | SCP0043_WOCreate.cs:196 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | VALUE_SET | drpPlanDate.InitValue | (string)dtCurDate.Rows[0]["CUR_DATE"] | 컨트롤 값 설정 |  |  |  |
| AC-30558c57 | this.Load 외 9 | SCP0043_WOCreate.cs:199 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtFpPlanId | Data_FP.CallBizCommonData("PLAN_ID", pInstanceID, sCurDate, "RELEASE", UserInfoContext.Cur… ⇒ biz:CommonData.CommonDataList_FP [code=PLAN_ID] \| biz:CommonData.CommonDataList… | 화면 필드/플래그 변경 |  |  |  |
| AC-e441bf44 | this.Load 외 9 | SCP0043_WOCreate.cs:199 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("PLAN_ID", pInstanceID, sCurDate, "RELEASE", UserInfoContext.Current.UserId) ⇒ biz:CommonData.CommonDataList_FP [code=PLAN_ID] \| biz:CommonData.CommonDataList… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b99a88c8 | this.Load 외 9 | SCP0043_WOCreate.cs:202 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtDivision | Data_FP.CallBizCommonData("DIVISION", pInstanceID, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=DIVISION] \| biz:CommonData.CommonDataLis… | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d7eb3e | this.Load 외 9 | SCP0043_WOCreate.cs:202 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("DIVISION", pInstanceID, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=DIVISION] \| biz:CommonData.CommonDataLis… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9a0ad848 | this.Load 외 9 | SCP0043_WOCreate.cs:203 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtSite | Data_FP.CallBizCommonData("SITE", pInstanceID, "DEMO121", null, null, null, null, true) ⇒ biz:CommonData.CommonDataList_FP [code=SITE] | 화면 필드/플래그 변경 |  |  |  |
| AC-b221201d | this.Load 외 9 | SCP0043_WOCreate.cs:203 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("SITE", pInstanceID, "DEMO121", null, null, null, null, true) ⇒ biz:CommonData.CommonDataList_FP [code=SITE] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-70a15e88 | this.Load 외 9 | SCP0043_WOCreate.cs:205 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtFpPlanId, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-16444ff4 | this.Load 외 9 | SCP0043_WOCreate.cs:206 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtDivision, clbDivision, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-14718eb5 | this.Load 외 9 | SCP0043_WOCreate.cs:207 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtSite, cboSite, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-fdd90d57 | this.Load 외 9 | SCP0043_WOCreate.cs:211 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtPlant | Data_FP.CallBizCommonData("PLANT", pInstanceID, plDivisionID, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=PLANT] \| biz:CommonData.CommonDataList [… | 화면 필드/플래그 변경 |  |  |  |
| AC-54986f3d | this.Load 외 9 | SCP0043_WOCreate.cs:211 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("PLANT", pInstanceID, plDivisionID, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=PLANT] \| biz:CommonData.CommonDataList [… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-296ab7f4 | this.Load 외 9 | SCP0043_WOCreate.cs:212 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7b887692 | this.Load 외 9 | SCP0043_WOCreate.cs:215 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtFactory | Data_FP.CallBizCommonData("FACTORY", pInstanceID, plDivisionID, plPlant, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=FACTORY] \| biz:CommonData.CommonDataList… | 화면 필드/플래그 변경 |  |  |  |
| AC-fb9881cc | this.Load 외 9 | SCP0043_WOCreate.cs:215 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("FACTORY", pInstanceID, plDivisionID, plPlant, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=FACTORY] \| biz:CommonData.CommonDataList… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-ac576716 | this.Load 외 9 | SCP0043_WOCreate.cs:216 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-4b4c470e | this.Load 외 9 | SCP0043_WOCreate.cs:219 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtOperation | Data_FP.CallBizCommonData("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEM… ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 화면 필드/플래그 변경 |  |  |  |
| AC-7c1894d8 | this.Load 외 9 | SCP0043_WOCreate.cs:219 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-b66b8c44 | this.Load 외 9 | SCP0043_WOCreate.cs:220 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9791bbc7 | this.Load 외 9 | SCP0043_WOCreate.cs:223 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | FLAG | dtLine | Data_FP.CallBizCommonData("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperati… ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 화면 필드/플래그 변경 |  |  |  |
| AC-bca48eba | this.Load 외 9 | SCP0043_WOCreate.cs:223 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | COMBO_DATA | Data_FP.CallBizCommonData | ("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperation, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1b2b8d3b | this.Load 외 9 | SCP0043_WOCreate.cs:224 | if (argType == null \|\| argType == "" \|\| argType == "INSTANCE") | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-9fe6404c | this.Load 외 9 | SCP0043_WOCreate.cs:233 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE") | FLAG | dtFpPlanId | Data_FP.CallBizCommonData("PLAN_ID", pInstanceID, sCurDate, "RELEASE", "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=PLAN_ID] \| biz:CommonData.CommonDataList… | 화면 필드/플래그 변경 |  |  |  |
| AC-6892982b | this.Load 외 9 | SCP0043_WOCreate.cs:233 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE") | COMBO_DATA | Data_FP.CallBizCommonData | ("PLAN_ID", pInstanceID, sCurDate, "RELEASE", "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=PLAN_ID] \| biz:CommonData.CommonDataList… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44d13ae7 | this.Load 외 9 | SCP0043_WOCreate.cs:235 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE") | LIST_REBIND | clsCtrl.setListBox | (dtFpPlanId, cboPlanID, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-8428b06a | this.Load 외 9 | SCP0043_WOCreate.cs:237 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ if (argType == "PLAN_DATE") | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-5d189bf7 | this.Load 외 9 | SCP0043_WOCreate.cs:247 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtPlant | Data_FP.CallBizCommonData("PLANT", pInstanceID, plDivisionID, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=PLANT] \| biz:CommonData.CommonDataList [… | 화면 필드/플래그 변경 |  |  |  |
| AC-46dd3b96 | this.Load 외 9 | SCP0043_WOCreate.cs:247 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("PLANT", pInstanceID, plDivisionID, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=PLANT] \| biz:CommonData.CommonDataList [… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-f80d1d56 | this.Load 외 9 | SCP0043_WOCreate.cs:248 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtPlant, clbPlant, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-0a807d5a | this.Load 외 9 | SCP0043_WOCreate.cs:251 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtFactory | Data_FP.CallBizCommonData("FACTORY", pInstanceID, plDivisionID, plPlant, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=FACTORY] \| biz:CommonData.CommonDataList… | 화면 필드/플래그 변경 |  |  |  |
| AC-5ce7de3d | this.Load 외 9 | SCP0043_WOCreate.cs:251 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("FACTORY", pInstanceID, plDivisionID, plPlant, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=FACTORY] \| biz:CommonData.CommonDataList… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-37a3d322 | this.Load 외 9 | SCP0043_WOCreate.cs:252 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-bb4ba0d0 | this.Load 외 9 | SCP0043_WOCreate.cs:255 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtOperation | Data_FP.CallBizCommonData("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEM… ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 화면 필드/플래그 변경 |  |  |  |
| AC-672c039e | this.Load 외 9 | SCP0043_WOCreate.cs:255 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-7b6614f6 | this.Load 외 9 | SCP0043_WOCreate.cs:256 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-241f05f7 | this.Load 외 9 | SCP0043_WOCreate.cs:259 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtLine | Data_FP.CallBizCommonData("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperati… ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 화면 필드/플래그 변경 |  |  |  |
| AC-82ea6782 | this.Load 외 9 | SCP0043_WOCreate.cs:259 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperation, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-2a6a6438 | this.Load 외 9 | SCP0043_WOCreate.cs:260 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-c4c94546 | this.Load 외 9 | SCP0043_WOCreate.cs:268 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtFactory | Data_FP.CallBizCommonData("FACTORY", pInstanceID, plDivisionID, plPlant, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=FACTORY] \| biz:CommonData.CommonDataList… | 화면 필드/플래그 변경 |  |  |  |
| AC-1aab0d43 | this.Load 외 9 | SCP0043_WOCreate.cs:268 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("FACTORY", pInstanceID, plDivisionID, plPlant, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=FACTORY] \| biz:CommonData.CommonDataList… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3384a988 | this.Load 외 9 | SCP0043_WOCreate.cs:269 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtFactory, clbFactory, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-b95d69cd | this.Load 외 9 | SCP0043_WOCreate.cs:272 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtOperation | Data_FP.CallBizCommonData("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEM… ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 화면 필드/플래그 변경 |  |  |  |
| AC-98eebb5f | this.Load 외 9 | SCP0043_WOCreate.cs:272 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-3f015668 | this.Load 외 9 | SCP0043_WOCreate.cs:273 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-7a9ef920 | this.Load 외 9 | SCP0043_WOCreate.cs:276 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtLine | Data_FP.CallBizCommonData("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperati… ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 화면 필드/플래그 변경 |  |  |  |
| AC-8e54fe22 | this.Load 외 9 | SCP0043_WOCreate.cs:276 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperation, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d6f9cd2f | this.Load 외 9 | SCP0043_WOCreate.cs:277 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-ddb76ca8 | this.Load 외 9 | SCP0043_WOCreate.cs:286 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtOperation | Data_FP.CallBizCommonData("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEM… ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 화면 필드/플래그 변경 |  |  |  |
| AC-28ad0910 | this.Load 외 9 | SCP0043_WOCreate.cs:286 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("OPERATION", pInstanceID, plDivisionID, plPlant, plFactory, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=OPERATION] \| biz:CommonData.CommonDataLi… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d554c2bd | this.Load 외 9 | SCP0043_WOCreate.cs:287 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtOperation, clbOperation, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-33cbd420 | this.Load 외 9 | SCP0043_WOCreate.cs:290 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtLine | Data_FP.CallBizCommonData("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperati… ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 화면 필드/플래그 변경 |  |  |  |
| AC-88131cd1 | this.Load 외 9 | SCP0043_WOCreate.cs:290 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperation, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-44ec8dd6 | this.Load 외 9 | SCP0043_WOCreate.cs:291 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |
| AC-8a4afc32 | this.Load 외 9 | SCP0043_WOCreate.cs:301 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | FLAG | dtLine | Data_FP.CallBizCommonData("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperati… ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 화면 필드/플래그 변경 |  |  |  |
| AC-d49a6fda | this.Load 외 9 | SCP0043_WOCreate.cs:301 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | COMBO_DATA | Data_FP.CallBizCommonData | ("LINE", pInstanceID, plDivisionID, plPlant, plFactory, plOperation, "DEMO121") ⇒ biz:CommonData.CommonDataList_FP [code=LINE] \| biz:CommonData.CommonDataList [c… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d15bbecf | this.Load 외 9 | SCP0043_WOCreate.cs:302 | else of (argType == null \|\| argType == "" \|\| argType == "INSTANCE") ▸ else of (argType == "PLAN_DATE") ▸ else of (argType == "PLAN_ID") … | LIST_REBIND | clsCtrl.setListBox | (dtLine, clbLine, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0043_WOCreate.SetSpreadColumn

진입점: FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-03a0195c | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SCP0043_WOCreate.cs:499 | for (i < siMain.ActiveSheet.RowCount) ▸ if ((string)(siMain.GetValue(i, iStatusCol)) == "Error") | GRID_STYLE | siMain.SetForeColor | (i, iStatusCol, i, iStatusCol + 1, Color.Red, false) | 그리드 표시 설정 |  |  |  |
| AC-c29ebc90 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SCP0043_WOCreate.cs:500 | for (i < siMain.ActiveSheet.RowCount) ▸ if ((string)(siMain.GetValue(i, iStatusCol)) == "Error") | GRID_STYLE | siMain.SetBGColor | (i, iStartCol, i, iEndCol, Color.FromArgb(242, 220, 219)) | 그리드 표시 설정 |  |  |  |
| AC-4146f0c3 | FindButton [try ▸ if (ds.Tables[0].Rows.Count > 0)] | SCP0043_WOCreate.cs:504 | for (i < siMain.ActiveSheet.RowCount) ▸ else of ((string)(siMain.GetValue(i, iStatusCol)) == "Error") | GRID_STYLE | siMain.SetForeColor | (i, iStatusCol, i, iStatusCol, Color.Blue, false) | 그리드 표시 설정 |  |  |  |

