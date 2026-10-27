# AS-IS 액션 대조표 — SCM0014

> 원천: `Doc/asisfacts/screens/SCM0014/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 109행 · 메서드 13 · 종류 GRID_INIT 54 · DATA_OP 10 · POPUP 8 · UI_MISC 6 · ENDPOINT 5 · UI_PROP 4 · RETURN 4 · VALUE_SET 3 · LIST_REBIND 3 · FLAG 3 · MESSAGE 2 · VALIDATE 2 · STATE_RESET 1 · CALL_EXT 1 · GRID_BIND 1 · GRID_LOCK 1 · COMBO_DATA 1 · ⚠ 의미 확인 필요 1


## SCM0014_ValidationShipmentResult.BtnItemId_Click

진입점: this.btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-57bbcfb6 | this.btnItemId.Click | SCM0014_ValidationShipmentResult.cs:385 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-20e87b2c | this.btnItemId.Click | SCM0014_ValidationShipmentResult.cs:386 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-829e38d8 | this.btnItemId.Click | SCM0014_ValidationShipmentResult.cs:387 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-48eaf3e3 | this.btnItemId.Click | SCM0014_ValidationShipmentResult.cs:388 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-2f3a5df1 | this.btnItemId.Click | SCM0014_ValidationShipmentResult.cs:393 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCM0014_ValidationShipmentResult.BtnProject_Click

진입점: this.btnProjectID.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-17bcc5e0 | this.btnProjectID.Click | SCM0014_ValidationShipmentResult.cs:402 |  | POPUP | new SCM0002_ProjectbyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-9d88b077 | this.btnProjectID.Click | SCM0014_ValidationShipmentResult.cs:403 |  | POPUP | popProject.Form_Load | (true, division, sProject) | 팝업 초기화(인자 전달) |  |  |  |
| AC-486cd9a1 | this.btnProjectID.Click | SCM0014_ValidationShipmentResult.cs:404 |  | UI_PROP | popProject.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-7c415e84 | this.btnProjectID.Click | SCM0014_ValidationShipmentResult.cs:405 |  | POPUP | popProject.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-50f4d587 | this.btnProjectID.Click | SCM0014_ValidationShipmentResult.cs:410 | if (popProject.ProjectCode != "") | VALUE_SET | txtProject.Text | sProjectCode | 컨트롤 값 설정 |  |  |  |

## SCM0014_ValidationShipmentResult.ClearUsrCheckedList

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-aaade155 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:364 | if (dt != null) | STATE_RESET | dt.Clear | () | 데이터 버퍼/목록 비움 |  |  |  |
| AC-1d33bca9 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:365 | if (dt != null) | LIST_REBIND | clsCtrl.setListBox | (dt, control, true) | 목록 컨트롤 재구성 |  |  |  |

## SCM0014_ValidationShipmentResult.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7f2b66b7 | this.Load | SCM0014_ValidationShipmentResult.cs:183 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain , SpdSheet.shtMain, 2, 1, 45) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-40288d3f | this.Load | SCM0014_ValidationShipmentResult.cs:184 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, 0) | 화면 필드/플래그 변경 |  |  |  |
| AC-4af0e696 | this.Load | SCM0014_ValidationShipmentResult.cs:185 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCM0014_ValidationShipmentResult.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-07e7ede2 | this.Load | SCM0014_ValidationShipmentResult.cs:196 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |

## SCM0014_ValidationShipmentResult.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-114f079f | Dispose | SCM0014_ValidationShipmentResult.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCM0014_ValidationShipmentResult.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7364cf4a | EditButton | SCM0014_ValidationShipmentResult.cs:284 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00109", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-af2f2ced | EditButton | SCM0014_ValidationShipmentResult.cs:285 |  | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCM0014_ValidationShipmentResult.Find_Data

진입점: FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f0aa18cc | FindButton | SCM0014_ValidationShipmentResult.cs:293 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-8e4d3010 | FindButton | SCM0014_ValidationShipmentResult.cs:293 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-986d3b3e | FindButton | SCM0014_ValidationShipmentResult.cs:308 |  | CALL_EXT | CString.GetComboBoxValue | (cboResultType.SelectedValue) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e3b2280b | FindButton | SCM0014_ValidationShipmentResult.cs:313 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-63542f49 | FindButton | SCM0014_ValidationShipmentResult.cs:315 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-484a6f20 | FindButton | SCM0014_ValidationShipmentResult.cs:318 | try | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-eb740730 | FindButton | SCM0014_ValidationShipmentResult.cs:320 | try | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCM.Validation.WSL/FoxDataSer… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-4e397cb1 | FindButton | SCM0014_ValidationShipmentResult.cs:322 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCM.SCM0014_GET_VALIDATION_SHIPMENT_RESULT") ⇒ SCM.SCM0014_GET_VALIDATION_SHIPMENT_RESULT | 엔드포인트 요청 생성 |  |  |  |
| AC-acf39945 | FindButton | SCM0014_ValidationShipmentResult.cs:323 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | division | 행/컬럼 값 대입 |  |  |  |
| AC-4c78f73c | FindButton | SCM0014_ValidationShipmentResult.cs:324 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | pPlantSite | 행/컬럼 값 대입 |  |  |  |
| AC-f434088c | FindButton | SCM0014_ValidationShipmentResult.cs:325 | try ▸ lambda | DATA_OP | req.Parameters["p_sales_site_id"] | pSalesSite | 행/컬럼 값 대입 |  |  |  |
| AC-161b96cc | FindButton | SCM0014_ValidationShipmentResult.cs:326 | try ▸ lambda | DATA_OP | req.Parameters["p_project_code"] | pProject | 행/컬럼 값 대입 |  |  |  |
| AC-78c8d554 | FindButton | SCM0014_ValidationShipmentResult.cs:327 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | pItem_Id | 행/컬럼 값 대입 |  |  |  |
| AC-cbbcd50b | FindButton | SCM0014_ValidationShipmentResult.cs:328 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | pFromYYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-66b1c9a4 | FindButton | SCM0014_ValidationShipmentResult.cs:329 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | pToYYYMMDD | 행/컬럼 값 대입 |  |  |  |
| AC-0ff4250b | FindButton | SCM0014_ValidationShipmentResult.cs:330 | try ▸ lambda | DATA_OP | req.Parameters["p_result_type"] | pResultType | 행/컬럼 값 대입 |  |  |  |
| AC-59f8f41a | FindButton | SCM0014_ValidationShipmentResult.cs:331 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-5c37bb48 | FindButton | SCM0014_ValidationShipmentResult.cs:332 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-56a1d823 | FindButton | SCM0014_ValidationShipmentResult.cs:339 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-5ad84287 | FindButton | SCM0014_ValidationShipmentResult.cs:342 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e5c67565 | FindButton | SCM0014_ValidationShipmentResult.cs:345 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-9a316459 | FindButton | SCM0014_ValidationShipmentResult.cs:348 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-7c8dd809 | FindButton | SCM0014_ValidationShipmentResult.cs:350 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-2636c4c8 | FindButton | SCM0014_ValidationShipmentResult.cs:352 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1f1b06e3 | FindButton | SCM0014_ValidationShipmentResult.cs:353 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCM0014_ValidationShipmentResult.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-89aa21bf | this.Load | SCM0014_ValidationShipmentResult.cs:129 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCM0014_ValidationShipmentResult.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58f16c28 | this.Load | SCM0014_ValidationShipmentResult.cs:165 |  | ENDPOINT | new FoxDataRequest | ("SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH") ⇒ SCM.GET_DATE_RANGE_YESTERDAY_BEFORE_1MONTH | 엔드포인트 요청 생성 |  |  |  |
| AC-a4b9121e | this.Load | SCM0014_ValidationShipmentResult.cs:166 |  | DATA_OP | request.Parameters["p_timezone"] | UserInfoContext.Current[UserInfoProperites.TimeZone] | 행/컬럼 값 대입 |  |  |  |
| AC-095217ba | this.Load | SCM0014_ValidationShipmentResult.cs:167 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-3acb6f2a | this.Load | SCM0014_ValidationShipmentResult.cs:170 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCM0014_ValidationShipmentResult.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bf520980 | this.Load | SCM0014_ValidationShipmentResult.cs:144 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-37af65c9 | this.Load | SCM0014_ValidationShipmentResult.cs:147 |  | DATA_OP | ReadOnlySheetList.Add | (SpdSheet.shtMain) | 데이터 객체 조작/조회 |  |  |  |
| AC-f044e4ed | this.Load | SCM0014_ValidationShipmentResult.cs:149 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-5e6938ae | this.Load | SCM0014_ValidationShipmentResult.cs:151 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-540fab77 | this.Load | SCM0014_ValidationShipmentResult.cs:155 |  | FLAG | dtResultType | Data.Common(Data.Type.LookupCommon, false, "SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 화면 필드/플래그 변경 |  |  |  |
| AC-33942bae | this.Load | SCM0014_ValidationShipmentResult.cs:155 |  | COMBO_DATA | Data.Common | (Data.Type.LookupCommon, false, "SHIPMENT_RESULT_TYPE") ⇒ biz:CommonData.CommonDataList [code=LookupCommon] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c9b99121 | this.Load | SCM0014_ValidationShipmentResult.cs:156 |  | LIST_REBIND | clsCtrl.setListBox | (dtResultType, cboResultType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-a1ab93eb | this.Load | SCM0014_ValidationShipmentResult.cs:158 |  | VALUE_SET | dCalendar.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |

## SCM0014_ValidationShipmentResult.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-fc27872d | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:216 |  | GRID_INIT | siMain.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-e58f194b | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:219 |  | GRID_INIT | siMain.AddActionTextBox | () | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-fff7ad55 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:220 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.RESULT_DATE, DefCols.RESULT_DATE, FPMerge.Restricted, 80 , true , FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-8f4092fc | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:221 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.RESULT_TYPE , DefCols.RESULT_TYPE, FPMerge.Restricted, 90, true, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3d855988 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:222 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.DIVISION_ID , DefCols.DIVISION_ID, FPMerge.Restricted, 60, true, FPHAlign.Cente… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-6ad0d008 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:223 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.SHIPMENT_NO , DefCols.SHIPMENT_NO , FPMerge.Restricted, 100, true, FPHAlign.Lef… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-74abf552 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:224 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.PROJECT_CODE , DefCols.PROJECT_CODE , FPMerge.Restricted, 100, true, FPHAlign.L… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1c71fde3 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:225 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.ITEM_ID , DefCols.ITEM_ID , FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-dcc4ed33 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:226 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.PLANT, DefCols.PLANT, FPMerge.Restricted, 80, true, FPHAlign.Center, FPVAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e20315cf | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:227 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.TRANS_MODE, DefCols.TRANS_MODE, FPMerge.Restricted, 100, true, FPHAlign.Center,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-70d5a3c1 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:228 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.OPERATION_GROUP, DefCols.OPERATION_GROUP, FPMerge.Restricted, 100, true, FPHAli… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a0431851 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:229 |  | GRID_INIT | siMain.AddNumColumn | (DefLabels.DELIVERY_QTY, DefCols.DELIVERY_QTY, FPMerge.Restricted, 100, true, FPHAlign.Rig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-382c4809 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:230 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.SOLD_TO , DefCols.SOLD_TO , FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19e7f398 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:231 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.SHIP_TO , DefCols.SHIP_TO , FPMerge.Restricted, 100, true, FPHAlign.Left, FPVAl… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-02771da8 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:232 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.INCOTERMS , DefCols.INCOTERMS , FPMerge.Restricted, 80, true, FPHAlign.Center, … | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7ed998cf | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:233 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.PLANT_SITE , DefCols.PLANT_SITE , FPMerge.Restricted, 80 , true, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-625ac281 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:234 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.SALES_SITE , DefCols.SALES_SITE , FPMerge.Restricted, 140, true, FPHAlign.Left,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a87f4a6c | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:235 |  | GRID_INIT | siMain.AddTextColumn | (DefLabels.BOD , DefCols.BOD , FPMerge.Restricted, 80, true, FPHAlign.Right, FPVAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-28e8104c | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:236 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.PLANT_ISSUE_DATE , DefCols.PLANT_ISSUE_DATE , FPMerge.Restricted, 80, true, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b42cbab2 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:237 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.POL_DATE , DefCols.POL_DATE , FPMerge.Restricted, 80, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-7997b70e | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:238 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.POD_DATE , DefCols.POD_DATE , FPMerge.Restricted, 80, true, FPHAlign.Center, FP… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-99bfbc23 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:239 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.FDEST_DATE , DefCols.FDEST_DATE , FPMerge.Restricted, 80, true, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-1669850f | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:240 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.ETA_POD_DATE , DefCols.ETA_POD_DATE , FPMerge.Restricted, 80, true, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a6595117 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:241 |  | GRID_INIT | siMain.AddDateColumn | (DefLabels.ETA_FDEST_DATE , DefCols.ETA_FDEST_DATE , FPMerge.Restricted, 80, true, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e9edecbd | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:244 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefCols.RESULT_DATE), 2, 1, 20, DefLabels.RESULT_DATE, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5d887109 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:245 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefCols.RESULT_TYPE), 2, 1, 20, DefLabels.RESULT_TYPE, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5ced28fc | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:247 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefCols.DIVISION_ID), 1, 11, 30, "ERP_Shipment_Performance_Info"… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2031ee0b | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:248 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.DIVISION_ID), 1, 1, 30, DefLabels.DIVISION_ID, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c487f1bc | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:249 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.SHIPMENT_NO), 1, 1, 30, DefLabels.SHIPMENT_NO, FPHAlign.… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-db0ca37b | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:250 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.PROJECT_CODE), 1, 1, 30, DefLabels.PROJECT_CODE, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d4f1e1e1 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:251 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.ITEM_ID), 1, 1, 30, DefLabels.ITEM_ID, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-60367891 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:252 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.PLANT), 1, 1, 30, DefLabels.PLANT, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-2109a64f | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:253 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.TRANS_MODE), 1, 1, 30, DefLabels.TRANS_MODE, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fd107928 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:254 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.OPERATION_GROUP), 1, 1, 30, DefLabels.OPERATION_GROUP, F… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-96199eda | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:255 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.DELIVERY_QTY), 1, 1, 30, DefLabels.DELIVERY_QTY, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-42771b98 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:256 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.SOLD_TO), 1, 1, 30, DefLabels.SOLD_TO, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-11bde100 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:257 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.SHIP_TO), 1, 1, 30, DefLabels.SHIP_TO, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-90e8bbea | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:258 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.INCOTERMS), 1, 1, 30, DefLabels.INCOTERMS, FPHAlign.Cent… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d050dc9b | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:260 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefCols.PLANT_SITE), 1, 3, 30, "SCM Info", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-20a864bb | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:261 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.PLANT_SITE), 1, 1, 30, DefLabels.PLANT_SITE , FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-e4866ac2 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:262 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.SALES_SITE), 1, 1, 30, DefLabels.SALES_SITE , FPHAlign.C… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-9dc5530a | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:263 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.BOD), 1, 1, 30, DefLabels.BOD , FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4da646a8 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:265 |  | GRID_INIT | siMain.ColumnHeaderSpan | (0, siMain.GetColumnIndex(DefCols.PLANT_ISSUE_DATE), 1, 6, 30, "GTS Info", FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe7e5d66 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:266 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.PLANT_ISSUE_DATE), 1, 1, 30, DefLabels.PLANT_ISSUE_DATE,… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-187f0728 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:267 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.POL_DATE), 1, 1, 30, DefLabels.POL_DATE, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4156b72d | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:268 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.POD_DATE), 1, 1, 30, DefLabels.POD_DATE, FPHAlign.Center… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a4a9acf2 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:269 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.FDEST_DATE), 1, 1, 30, DefLabels.FDEST_DATE, FPHAlign.Ce… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d5e3f2b0 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:270 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.ETA_POD_DATE), 1, 1, 30, DefLabels.ETA_POD_DATE, FPHAlig… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-22ce8856 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:271 |  | GRID_INIT | siMain.ColumnHeaderSpan | (1, siMain.GetColumnIndex(DefCols.ETA_FDEST_DATE), 1, 1, 30, DefLabels.ETA_FDEST_DATE, FPH… | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-76f0f576 | (진입점 미연결) | SCM0014_ValidationShipmentResult.cs:273 |  | GRID_INIT | siMain.Freeze | (0, siMain.GetColumnIndex(DefCols.RESULT_DATE)) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCM0014_ValidationShipmentResult.InitSpread_2

진입점: this.Load / FindButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8bbaa20b | this.Load 외 1 | SCM0014_ValidationShipmentResult.cs:202 |  | GRID_INIT | siMain.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-39be7a2b | this.Load 외 1 | SCM0014_ValidationShipmentResult.cs:203 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 2) | 그리드 재구성/초기화 |  |  |  |

