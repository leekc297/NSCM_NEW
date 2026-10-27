# AS-IS 액션 대조표 — SSP0045

> 원천: `Doc/asisfacts/screens/SSP0045/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 280행 · 메서드 33 · 종류 DATA_OP 88 · GRID_SET 27 · RETURN 25 · GRID_INIT 21 · UI_PROP 19 · FLAG 15 · GRID_LOCK 15 · ENDPOINT 12 · UI_MISC 11 · POPUP 9 · MESSAGE 9 · LIST_REBIND 7 · COMBO_DATA 6 · VALIDATE 4 · VALUE_SET 3 · CALL_EXT 3 · GRID_COMBO 2 · GRID_STYLE 2 · STATE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 3


## SSP0045_ShipmentRequest.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-777447b2 | this.btnItem_Id.Click | SSP0045_ShipmentRequest.cs:1189 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-e6c71282 | this.btnItem_Id.Click | SSP0045_ShipmentRequest.cs:1191 |  | POPUP | popItem.Form_Load | (true, sdivision, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-47534f4a | this.btnItem_Id.Click | SSP0045_ShipmentRequest.cs:1192 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-f85f1c37 | this.btnItem_Id.Click | SSP0045_ShipmentRequest.cs:1193 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-c07a1d17 | this.btnItem_Id.Click | SSP0045_ShipmentRequest.cs:1198 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SSP0045_ShipmentRequest.CboBizType_SelectedIndexChanged

진입점: this.cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-71024882 | this.cboBizType.SelectedIndexChanged | SSP0045_ShipmentRequest.cs:413 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizTy… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-55eb1560 | this.cboBizType.SelectedIndexChanged | SSP0045_ShipmentRequest.cs:413 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizType.ControlV… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-d7a845a0 | this.cboBizType.SelectedIndexChanged | SSP0045_ShipmentRequest.cs:414 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0045_ShipmentRequest.CboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-cbf63953 | this.cboDivision.SelectedIndexChanged | SSP0045_ShipmentRequest.cs:422 |  | FLAG | bChgDiv | true | 화면 필드/플래그 변경 |  |  |  |

## SSP0045_ShipmentRequest.checkValidN0

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0ec93f81 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1377 |  | FLAG | dsInput | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-d5b9ab4e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1379 |  | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-40a5c2a1 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1380 |  | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-503cf46d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1381 |  | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-23ab1d64 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1382 |  | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-542afad4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1383 |  | DATA_OP | dt.Columns.Add | ("p_transport_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-54f14577 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1384 |  | DATA_OP | dt.Columns.Add | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b0ce54af | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1385 |  | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-0ae209ae | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1386 |  | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3a05b8e3 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1387 |  | DATA_OP | dt.Columns.Add | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-11f23197 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1388 |  | DATA_OP | dt.Columns.Add | ("p_fcst_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-10ca6474 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1389 |  | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-fcfaa840 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1395 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-99caa8bb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1396 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-6d27516b | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1397 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-d8b082a4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1398 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5e6d2d9d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1399 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-44af2682 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1400 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_transport_mode"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TR_MODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-98139862 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1401 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_plant_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-49e85032 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1402 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-8c70778e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1403 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-cec2bc37 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1404 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_project_code"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.PROJECT_CODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-4d4c819c | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1405 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_fcst_type"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FCST_TYPE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-21599fe2 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1406 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-f4be46b7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1413 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7e90cf5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1414 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-8e55c012 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1415 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-1117a362 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1416 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-f4e5ea04 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1417 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_transport_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-2c9f1825 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1418 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b2c5a762 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1419 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9f37d5f1 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1420 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-82766a72 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1421 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_fcst_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-68b25fc7 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1428 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-01c6cc05 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1429 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-66094d65 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1430 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c43ed175 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1431 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-fa462f34 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1432 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_transport_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-cbb10cfd | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1433 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f7f9c1b5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1434 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-7353d893 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1435 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_project_code") | 데이터 객체 조작/조회 |  |  |  |
| AC-74713f85 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1436 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_fcst_type") | 데이터 객체 조작/조회 |  |  |  |
| AC-24a91293 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1449 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) ▸ if (p_division_id == cp_division_id && p_scm_site_id == cp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-105f9b73 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SSP0045_ShipmentRequest.cs:1461 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SSP0045_ShipmentRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6f8d3d85 | this.Load | SSP0045_ShipmentRequest.cs:286 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5de3e8e1 | this.Load | SSP0045_ShipmentRequest.cs:287 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-51ed1b17 | this.Load | SSP0045_ShipmentRequest.cs:288 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f6b809d7 | this.Load | SSP0045_ShipmentRequest.cs:290 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-4bf9b92b | this.Load | SSP0045_ShipmentRequest.cs:291 |  | STATE | drpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SSP0045_ShipmentRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0382944b | this.Load | SSP0045_ShipmentRequest.cs:186 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-661261ac | this.Load | SSP0045_ShipmentRequest.cs:187 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-35799b11 | this.Load | SSP0045_ShipmentRequest.cs:189 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-09451b86 | this.Load | SSP0045_ShipmentRequest.cs:191 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-73128ff3 | this.Load | SSP0045_ShipmentRequest.cs:192 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-b81bf23e | this.Load | SSP0045_ShipmentRequest.cs:193 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SSP0045_ShipmentRequest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c5b8b37c | DeleteButton | SSP0045_ShipmentRequest.cs:541 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1b5427e0 | DeleteButton | SSP0045_ShipmentRequest.cs:546 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SSP0045_ShipmentRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a30ca620 | Dispose | SSP0045_ShipmentRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SSP0045_ShipmentRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-12916c0d | EditButton | SSP0045_ShipmentRequest.cs:443 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-8034dd71 | EditButton | SSP0045_ShipmentRequest.cs:447 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dfa5d982 | EditButton | SSP0045_ShipmentRequest.cs:449 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-fe1d2ce4 | EditButton | SSP0045_ShipmentRequest.cs:450 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-83f249d0 | EditButton | SSP0045_ShipmentRequest.cs:454 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-e7c04c12 | EditButton | SSP0045_ShipmentRequest.cs:455 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-51e159e6 | EditButton | SSP0045_ShipmentRequest.cs:458 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c08eeec | EditButton | SSP0045_ShipmentRequest.cs:458 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-c7726ffe | EditButton | SSP0045_ShipmentRequest.cs:461 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefMain.MEASURE)+1, siMain.ActiveSheet.RowCount - 1, siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-695cc6eb | EditButton | SSP0045_ShipmentRequest.cs:463 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-44639943 | EditButton | SSP0045_ShipmentRequest.cs:514 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetValue(i, siMain.GetColumnIndex(DefMain.MEAS… | GRID_LOCK | siMain.LockRange | (i, iBlockStartIdx, i, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0045_ShipmentRequest.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-749e408a | FindButton 외 1 | SSP0045_ShipmentRequest.cs:559 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-7b1b8e61 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:559 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-469a9339 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:560 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-8c4f6768 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:560 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-3b49ef4d | FindButton 외 1 | SSP0045_ShipmentRequest.cs:577 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-e75fa6ab | FindButton 외 1 | SSP0045_ShipmentRequest.cs:579 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-28aedf92 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:583 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-fc306b29 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:585 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-94ae2c72 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:587 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SSP.SSP0045_GET_SHIPMENT_REQUEST") ⇒ SSP.SSP0045_GET_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-76ce3cbe | FindButton 외 1 | SSP0045_ShipmentRequest.cs:589 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-fea516f1 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:591 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-da99c05e | FindButton 외 1 | SSP0045_ShipmentRequest.cs:592 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-e4e1dbad | FindButton 외 1 | SSP0045_ShipmentRequest.cs:593 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-640a5fc6 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:594 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5e78910d | FindButton 외 1 | SSP0045_ShipmentRequest.cs:595 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-84167d52 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:596 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-e400d616 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:597 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-35f31308 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:598 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-8eea1676 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:599 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-ebea3d7b | FindButton 외 1 | SSP0045_ShipmentRequest.cs:600 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-d97f660f | FindButton 외 1 | SSP0045_ShipmentRequest.cs:601 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d53f94e8 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:603 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-879962e2 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:614 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-386bcb42 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:616 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-1cc6b878 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:617 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-4aab2e59 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:623 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-4dbd1f47 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:627 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9d7d9a34 | FindButton 외 1 | SSP0045_ShipmentRequest.cs:629 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-bb32c41a | FindButton 외 1 | SSP0045_ShipmentRequest.cs:632 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0045_ShipmentRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b0c66e25 | this.Load | SSP0045_ShipmentRequest.cs:152 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SSP0045_ShipmentRequest.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b80e4fc | this.Load | SSP0045_ShipmentRequest.cs:279 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-206db2c9 | this.Load | SSP0045_ShipmentRequest.cs:280 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-ce8b59a4 | this.Load | SSP0045_ShipmentRequest.cs:282 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SSP0045_ShipmentRequest.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-106133f4 | this.Load | SSP0045_ShipmentRequest.cs:647 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-76c264c0 | this.Load | SSP0045_ShipmentRequest.cs:648 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-27a4faf4 | this.Load | SSP0045_ShipmentRequest.cs:649 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-ae20db86 | this.Load | SSP0045_ShipmentRequest.cs:650 |  | DATA_OP | request.Parameters["p_timezone"] | "AS054" | 행/컬럼 값 대입 |  |  |  |
| AC-b6980c25 | this.Load | SSP0045_ShipmentRequest.cs:651 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-457a512d | this.Load | SSP0045_ShipmentRequest.cs:654 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SSP0045_ShipmentRequest.GetSpdTitle

진입점: this.Load / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-517dfcc0 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:1115 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-797fec35 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:1116 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-231f9ae9 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:1117 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-0a7cc682 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:1119 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-d14ab57d | this.Load 외 2 | SSP0045_ShipmentRequest.cs:1119 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SSP0045_ShipmentRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8dc49941 | this.Load | SSP0045_ShipmentRequest.cs:238 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-1f99f58f | this.Load | SSP0045_ShipmentRequest.cs:240 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-366e7b7e | this.Load | SSP0045_ShipmentRequest.cs:242 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-e03e07ee | this.Load | SSP0045_ShipmentRequest.cs:247 |  | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-c58494c6 | this.Load | SSP0045_ShipmentRequest.cs:247 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-9873f0bc | this.Load | SSP0045_ShipmentRequest.cs:248 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-81f26fc4 | this.Load | SSP0045_ShipmentRequest.cs:257 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-3fa4fa0a | this.Load | SSP0045_ShipmentRequest.cs:258 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SSP0045_ShipmentRequest.InitSpread_2

진입점: this.Load / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5316554a | this.Load 외 2 | SSP0045_ShipmentRequest.cs:297 |  | GRID_INIT | spdInfo.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-9e99a402 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:299 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantSiteByDivision, false, "40,81,82") ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-452ac6f4 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:299 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivision, false, "40,81,82") ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8bb5a1fe | this.Load 외 2 | SSP0045_ShipmentRequest.cs:301 |  | DATA_OP | dtFromSite.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-babe70ad | this.Load 외 2 | SSP0045_ShipmentRequest.cs:302 |  | DATA_OP | drRow["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-32c2cd3b | this.Load 외 2 | SSP0045_ShipmentRequest.cs:303 |  | DATA_OP | drRow["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-6453a736 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:304 |  | DATA_OP | dtFromSite.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-05559d04 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:306 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-a2157b07 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:307 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ToSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-f28d7c3f | this.Load 외 2 | SSP0045_ShipmentRequest.cs:313 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-c2442ed1 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:319 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0045_ShipmentRequest.InitSpreadDateColumn

진입점: this.Load / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9a863ba | this.Load 외 2 | SSP0045_ShipmentRequest.cs:354 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-21c38b7f | this.Load 외 2 | SSP0045_ShipmentRequest.cs:355 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-c439d234 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:358 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-0b690b7b | this.Load 외 2 | SSP0045_ShipmentRequest.cs:359 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-4770a52f | this.Load 외 2 | SSP0045_ShipmentRequest.cs:362 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-97fc953f | this.Load 외 2 | SSP0045_ShipmentRequest.cs:368 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d25d29f0 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:369 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-adf40303 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:374 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b396c000 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:375 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-430a4efa | this.Load 외 2 | SSP0045_ShipmentRequest.cs:382 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-59d37e3c | this.Load 외 2 | SSP0045_ShipmentRequest.cs:383 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-19429085 | this.Load 외 2 | SSP0045_ShipmentRequest.cs:393 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-3ecbf5fc | this.Load 외 2 | SSP0045_ShipmentRequest.cs:394 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fbd6039c | this.Load 외 2 | SSP0045_ShipmentRequest.cs:395 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-5e34cead | this.Load 외 2 | SSP0045_ShipmentRequest.cs:396 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SSP0045_ShipmentRequest.InsertRow

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0c5716f6 | (진입점 미연결) | SSP0045_ShipmentRequest.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-fe50fb7f | (진입점 미연결) | SSP0045_ShipmentRequest.cs:756 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, p_division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-e9e9c4d7 | (진입점 미연결) | SSP0045_ShipmentRequest.cs:757 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE, "SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-573fb8ad | (진입점 미연결) | SSP0045_ShipmentRequest.cs:758 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, "Ship Req") | 데이터 객체 조작/조회 |  |  |  |
| AC-8394589a | (진입점 미연결) | SSP0045_ShipmentRequest.cs:760 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-760afbc9 | (진입점 미연결) | SSP0045_ShipmentRequest.cs:763 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.DIVISI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-c01383a0 | (진입점 미연결) | SSP0045_ShipmentRequest.cs:764 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.NICK_NAME), siMain.ActiveSheet.ColumnCount - 1, tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-81770ffd | (진입점 미연결) | SSP0045_ShipmentRequest.cs:772 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefMain.ITEM_ID), dtBODItem) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0045_ShipmentRequest.InsertRow2

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7bc2acc6 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:780 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9c31502b | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:787 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, p_division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-b0df0ee8 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:788 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE, "SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-08a88f1b | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:789 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, "Ship Req") | 데이터 객체 조작/조회 |  |  |  |
| AC-a1b2244c | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:791 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-16a2063c | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:794 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.DIVISI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-4df447bf | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:795 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.NICK_NAME), siMain.ActiveSheet.ColumnCount - 1, tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-b422d335 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SSP0045_ShipmentRequest.cs:803 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefMain.ITEM_ID), dtBODItem) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SSP0045_ShipmentRequest.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-41c6095d | (진입점 미연결) | SSP0045_ShipmentRequest.cs:1180 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SSP0045_ShipmentRequest.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c42e1be7 | SaveButton | SSP0045_ShipmentRequest.cs:855 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-6b09a08f | SaveButton | SSP0045_ShipmentRequest.cs:867 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-24069893 | SaveButton | SSP0045_ShipmentRequest.cs:870 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-3610b704 | SaveButton | SSP0045_ShipmentRequest.cs:870 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-af519c51 | SaveButton | SSP0045_ShipmentRequest.cs:873 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-00f54684 | SaveButton | SSP0045_ShipmentRequest.cs:914 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-b4a52742 | SaveButton | SSP0045_ShipmentRequest.cs:915 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a5ccf020 | SaveButton | SSP0045_ShipmentRequest.cs:916 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-25f95298 | SaveButton | SSP0045_ShipmentRequest.cs:941 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-481c43ad | SaveButton | SSP0045_ShipmentRequest.cs:944 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SSP.SSP0045_SAVE_SHIPMENT_REQUEST") ⇒ SSP.SSP0045_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-ef7c6e13 | SaveButton | SSP0045_ShipmentRequest.cs:947 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-665bd7ee | SaveButton | SSP0045_ShipmentRequest.cs:949 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SSP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-d648329c | SaveButton | SSP0045_ShipmentRequest.cs:954 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-86a27fca | SaveButton | SSP0045_ShipmentRequest.cs:956 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | n_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-b0d5e3d0 | SaveButton | SSP0045_ShipmentRequest.cs:957 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | n_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-ed54809c | SaveButton | SSP0045_ShipmentRequest.cs:958 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | n_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-15f76e72 | SaveButton | SSP0045_ShipmentRequest.cs:959 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | n_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-a0153f45 | SaveButton | SSP0045_ShipmentRequest.cs:960 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | n_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-04faca17 | SaveButton | SSP0045_ShipmentRequest.cs:961 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | n_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-257669fa | SaveButton | SSP0045_ShipmentRequest.cs:962 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | n_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-db6905d3 | SaveButton | SSP0045_ShipmentRequest.cs:963 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | n_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-114748ac | SaveButton | SSP0045_ShipmentRequest.cs:964 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | n_measure | 행/컬럼 값 대입 |  |  |  |
| AC-5c5c7174 | SaveButton | SSP0045_ShipmentRequest.cs:965 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | n_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-a798daf4 | SaveButton | SSP0045_ShipmentRequest.cs:966 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | n_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0c4ddc01 | SaveButton | SSP0045_ShipmentRequest.cs:967 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_project_code"] | n_project_code | 행/컬럼 값 대입 |  |  |  |
| AC-c51d703a | SaveButton | SSP0045_ShipmentRequest.cs:968 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_fcst_type"] | n_fcst_type | 행/컬럼 값 대입 |  |  |  |
| AC-8d566ba0 | SaveButton | SSP0045_ShipmentRequest.cs:969 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-edb9c2fd | SaveButton | SSP0045_ShipmentRequest.cs:970 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-c29af244 | SaveButton | SSP0045_ShipmentRequest.cs:972 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-43788cd7 | SaveButton | SSP0045_ShipmentRequest.cs:972 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-c326a9f4 | SaveButton | SSP0045_ShipmentRequest.cs:983 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-1a3200f4 | SaveButton | SSP0045_ShipmentRequest.cs:984 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-e3d20e4f | SaveButton | SSP0045_ShipmentRequest.cs:994 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b1e03bc9 | SaveButton | SSP0045_ShipmentRequest.cs:995 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c71a65d1 | SaveButton | SSP0045_ShipmentRequest.cs:1005 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-9f18904f | SaveButton | SSP0045_ShipmentRequest.cs:1006 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-0c0cb3c5 | SaveButton | SSP0045_ShipmentRequest.cs:1013 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-a97d29ec | SaveButton | SSP0045_ShipmentRequest.cs:1022 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-e26d09d7 | SaveButton | SSP0045_ShipmentRequest.cs:1023 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-25a5db60 | SaveButton | SSP0045_ShipmentRequest.cs:1029 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SSP0045_ShipmentRequest.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == false)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-3b359ff3 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SSP0045_ShipmentRequest.cs:1037 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-20da2f4d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SSP0045_ShipmentRequest.cs:1065 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-c300cf71 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SSP0045_ShipmentRequest.cs:1075 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureVal == "SCP_PLAN" && i != 0 && (model != itemId \|\| plant!= fromSite)) | UI_PROP | range1.Border | bevelbrdr | 속성 Border 설정 |  |  |  |
| AC-b0e64ea2 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SSP0045_ShipmentRequest.cs:1091 | for (i < spdMain.ActiveSheet.RowCount) ▸ if ("" != frozenYYYYMMDD && Int64.Parse(frozenYYYYMMDD) > Int64.Parse(startPeriod)) | UI_PROP | range1.BackColor | Color.FromArgb(242,242,242) | 속성 BackColor 설정 |  |  |  |
| AC-73215a23 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SSP0045_ShipmentRequest.cs:1095 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SSP0045_ShipmentRequest.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-dd36ed8d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0045_ShipmentRequest.cs:670 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-9ee71663 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0045_ShipmentRequest.cs:674 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-c97762f1 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0045_ShipmentRequest.cs:712 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |
| AC-4cb8eaf4 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SSP0045_ShipmentRequest.cs:717 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |

## SSP0045_ShipmentRequest.SetBODItemID

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (dtBODItem == null \|\| bChgDiv)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-ce838f1f | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SSP0045_ShipmentRequest.cs:1100 |  | FLAG | dtBODItem | Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, false, cboDivision.ControlValues, cboBi… | 화면 필드/플래그 변경 |  |  |  |
| AC-4eb0f0bf | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SSP0045_ShipmentRequest.cs:1100 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BODItemProjectRoute, false, cboDivision.ControlValues, cboBizType.ControlVa… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-1be29387 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SSP0045_ShipmentRequest.cs:1102 |  | FLAG | bChgDiv | false | 화면 필드/플래그 변경 |  |  |  |

## SSP0045_ShipmentRequest.SetChangeControl

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-db75f8af | this.Load | SSP0045_ShipmentRequest.cs:169 |  | DATA_OP | Filter["GROUP_ID"] | UserInfoContext.Current["NowGroupID"] | 행/컬럼 값 대입 |  |  |  |
| AC-64601f82 | this.Load | SSP0045_ShipmentRequest.cs:170 |  | DATA_OP | Filter["USER_ID"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-2e89f492 | this.Load | SSP0045_ShipmentRequest.cs:176 | switch (triggerControl) case "MyDivisionCMM": | FLAG | dtDivision | DataService.GetSSPInnerTable("MyDivisionCMM", Filter) | 화면 필드/플래그 변경 |  |  |  |
| AC-b1c54fa9 | this.Load | SSP0045_ShipmentRequest.cs:176 | switch (triggerControl) case "MyDivisionCMM": | COMBO_DATA | DataService.GetSSPInnerTable | ("MyDivisionCMM", Filter) | 콤보/조회조건 데이터 조회(프레임워크 — 큰 데이터 1회 조회 후 코드별 필터 또는 SP 코드 분기) |  |  |  |

## SSP0045_ShipmentRequest.SetChangedControl

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a6d032b8 | this.Load 외 1 | SSP0045_ShipmentRequest.cs:268 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizTy… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-100291d3 | this.Load 외 1 | SSP0045_ShipmentRequest.cs:268 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizType.ControlV… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-74252092 | this.Load 외 1 | SSP0045_ShipmentRequest.cs:269 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SSP0045_ShipmentRequest.SetImageCell

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)] / (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2235add4 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SSP0045_ShipmentRequest.cs:821 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefMain.TR_MODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SSP0045_ShipmentRequest.SetLockSumColumn

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK)] / EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e54d55a4 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SSP0045_ShipmentRequest.cs:737 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| spreadInfo.GetColumnTag(iCol).In… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0045_ShipmentRequest.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7a94a413 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1140 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-7142dec9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1144 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-af698205 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1149 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-3f8d1051 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1152 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-ece210c7 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1156 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-048c74f4 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1161 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-ccac1f75 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SSP0045_ShipmentRequest.cs:1164 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SSP0045_ShipmentRequest.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e077df8b | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1207 | if (e.ColumnHeader) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-efa6e832 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1208 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f55d59f7 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1209 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-96df7211 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1210 | if (siMain.GetText(insRow, 0) != "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-90b26b69 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1215 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 그리드 표시 설정 |  |  |  |
| AC-b961bf9b | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1222 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ if (p_item_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-597c9f49 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1231 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | POPUP | new SCM0002_GetBODItemPrjRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-fe84f8cc | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1232 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_division_id | p_divisionId | 속성 p_division_id 설정 |  |  |  |
| AC-15f2484b | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1233 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_operation_group | p_operationGroup | 속성 p_operation_group 설정 |  |  |  |
| AC-01268f83 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1234 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_item_id | p_item_id | 속성 p_item_id 설정 |  |  |  |
| AC-d5c195ed | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1235 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_from_yyyymmdd | p_from_yyyymmdd | 속성 p_from_yyyymmdd 설정 |  |  |  |
| AC-ef501763 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1236 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_prgram_id | "SSP0045" | 속성 p_prgram_id 설정 |  |  |  |
| AC-8d2cbc7c | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1237 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.Width | 1400 | 속성 Width 설정 |  |  |  |
| AC-ef89e382 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1239 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-d3addb7d | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1240 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | POPUP | bodPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-300f3248 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1246 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ if (bo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dce76fe0 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1261 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_LOCK | siMain.LockRange | (insRow, siMain.GetColumnIndex(DefMain.ITEM_ID), e.Row, siMain.GetColumnIndex(DefMain.ITEM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-65dcc501 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1264 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.ITEM_ID), p_item_id) | 그리드 값 설정 |  |  |  |
| AC-27d90702 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1265 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.FROM_SITE), bodItem.c_from_site) | 그리드 값 설정 |  |  |  |
| AC-3cede2c7 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1266 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.TO_SITE), bodItem.c_to_site) | 그리드 값 설정 |  |  |  |
| AC-7c41134f | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1267 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.TR_MODE), bodItem.c_transport_mode) | 그리드 값 설정 |  |  |  |
| AC-ac4379b9 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1268 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.INCOTERMS), bodItem.c_incoterms) | 그리드 값 설정 |  |  |  |
| AC-7ab1affb | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1269 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.LT_DAY), bodItem.c_lt_day) | 그리드 값 설정 |  |  |  |
| AC-8f0aeb40 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1270 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.FROZEN_YYYYMMDD), bodItem.c_frozen_yyyymmdd) | 그리드 값 설정 |  |  |  |
| AC-055d95c5 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1271 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.BOD_ID), bodItem.c_bod_id) | 그리드 값 설정 |  |  |  |
| AC-ba32a2ee | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1294 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_LOCK | siMain.LockRange | (insRow, siMain.GetColumnIndex(DefMain.MEASURE) + 1, insRow, siMain.ActiveSheet.ColumnCoun… | 그리드 편집 잠금/해제 |  |  |  |
| AC-6313c68f | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1295 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.MEASURE) + 1, insRow, siMain.ActiveSheet.ColumnCoun… | 그리드 값 설정 |  |  |  |
| AC-6a275f64 | this.spdMain.CellClick | SSP0045_ShipmentRequest.cs:1319 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_LOCK | siMain.LockRange | (insRow, iBlockStartIdx, insRow, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |

## SSP0045_ShipmentRequest.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a9ff924e | this.spdMain.CellDoubleClick | SSP0045_ShipmentRequest.cs:426 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SSP0045_ShipmentRequest.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange / spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5923681e | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1351 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-dd1a7203 | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1352 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-e3187b47 | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1353 | if (siMain.GetText(e.Row, 0) != "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-1092de61 | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1358 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.FROM_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-5223ed3c | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1359 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.TO_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-ecc98c0d | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1360 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.TR_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-f4f01bf6 | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1361 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-1aa6fc5d | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1362 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.LT_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-99ad576a | this.spdMain.ComboSelChange 외 1 | SSP0045_ShipmentRequest.cs:1367 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefMain.MEASURE), e.Row, siMain.ActiveSheet.ColumnCount - 1,… | 그리드 편집 잠금/해제 |  |  |  |

## SSP0045_ShipmentRequest.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-6e616a14 | this.spdMain.TopChange | SSP0045_ShipmentRequest.cs:431 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

