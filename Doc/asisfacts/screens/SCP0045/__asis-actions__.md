# AS-IS 액션 대조표 — SCP0045

> 원천: `Doc/asisfacts/screens/SCP0045/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 274행 · 메서드 33 · 종류 DATA_OP 82 · GRID_SET 27 · RETURN 25 · GRID_INIT 21 · UI_PROP 19 · GRID_LOCK 15 · FLAG 14 · ENDPOINT 14 · UI_MISC 11 · POPUP 9 · MESSAGE 9 · LIST_REBIND 7 · COMBO_DATA 5 · VALIDATE 4 · VALUE_SET 3 · CALL_EXT 3 · GRID_COMBO 2 · GRID_STYLE 2 · STATE 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 3


## SCP0045_ShipmentRequest.BtnItem_Id_Click

진입점: this.btnItem_Id.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cca40a3 | this.btnItem_Id.Click | SCP0045_ShipmentRequest.cs:1144 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-6c308d93 | this.btnItem_Id.Click | SCP0045_ShipmentRequest.cs:1146 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c0e242ad | this.btnItem_Id.Click | SCP0045_ShipmentRequest.cs:1147 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-db4c539f | this.btnItem_Id.Click | SCP0045_ShipmentRequest.cs:1148 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-5e778bf9 | this.btnItem_Id.Click | SCP0045_ShipmentRequest.cs:1153 | if (popItem.ItemID != "") | VALUE_SET | txtItem_Id.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0045_ShipmentRequest.CboBizType_SelectedIndexChanged

진입점: this.cboBizType.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2a56d9f6 | this.cboBizType.SelectedIndexChanged | SCP0045_ShipmentRequest.cs:374 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizTy… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-ca1ef6c0 | this.cboBizType.SelectedIndexChanged | SCP0045_ShipmentRequest.cs:374 |  | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizType.ControlV… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8c565c22 | this.cboBizType.SelectedIndexChanged | SCP0045_ShipmentRequest.cs:375 |  | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0045_ShipmentRequest.CboDivision_SelectedIndexChanged

진입점: this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c57b8165 | this.cboDivision.SelectedIndexChanged | SCP0045_ShipmentRequest.cs:383 |  | FLAG | bChgDiv | true | 화면 필드/플래그 변경 |  |  |  |

## SCP0045_ShipmentRequest.checkValidN0

진입점: SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-bca4c94a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1332 |  | FLAG | dsInput | new DataSet() | 화면 필드/플래그 변경 |  |  |  |
| AC-15388808 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1334 |  | DATA_OP | dt.Columns.Add | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-6c34fa93 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1335 |  | DATA_OP | dt.Columns.Add | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-ac9d8215 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1336 |  | DATA_OP | dt.Columns.Add | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-6abd328e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1337 |  | DATA_OP | dt.Columns.Add | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-a53e8bde | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1338 |  | DATA_OP | dt.Columns.Add | ("p_transport_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-45e9a899 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1339 |  | DATA_OP | dt.Columns.Add | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-9525c9bb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1340 |  | DATA_OP | dt.Columns.Add | ("p_user_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-138c9feb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1341 |  | DATA_OP | dt.Columns.Add | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b7c553fc | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1342 |  | DATA_OP | dsInput.Tables.Add | (dt) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e4da97e | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1348 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-49a146f8 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1349 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_division_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.DIVISION_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-17c90209 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1350 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_scm_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TO_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-5fe4a595 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1351 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_item_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.ITEM_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-3c157323 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1352 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_incoterms"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.INCOTERMS)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-b60c764a | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1353 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_transport_mode"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.TR_MODE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-76e1b447 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1354 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_plant_site_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.FROM_SITE)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-ee6b7912 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1355 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-38d5b54d | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1356 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dr["p_bod_id"] | siMain.GetValue(i, siMain.GetColumnIndex(DefMain.BOD_ID)).ToString() | 행/컬럼 값 대입 |  |  |  |
| AC-a73d25fe | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1357 | for (i <= siMain.GetMaxRowIndex()) | DATA_OP | dsInput.Tables[0].Rows.Add | (dr) | 데이터 객체 조작/조회 |  |  |  |
| AC-b87b8fd4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1364 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-b13f60ca | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1365 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-47774b64 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1366 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-3ec2fa14 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1367 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-b9ba75fb | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1368 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_transport_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-02b2a775 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1369 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-d72d6fb4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1370 | for (i < dsInput.Tables[0].Rows.Count) | DATA_OP | dr.Field | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-c0e28d36 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1377 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_division_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-a8dcb801 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1378 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_scm_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-dc50bad5 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1379 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_item_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-f037bd86 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1380 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_incoterms") | 데이터 객체 조작/조회 |  |  |  |
| AC-90db2ab4 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1381 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_transport_mode") | 데이터 객체 조작/조회 |  |  |  |
| AC-65be7ac0 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1382 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_plant_site_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-22166298 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1383 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) | DATA_OP | cpDr.Field | ("p_bod_id") | 데이터 객체 조작/조회 |  |  |  |
| AC-34a0cfe3 | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1394 | for (i < dsInput.Tables[0].Rows.Count) ▸ for (j < dsInput.Tables[0].Rows.Count) ▸ if (p_division_id == cp_division_id && p_scm_site_id == cp… | MESSAGE | MessageHelper.GMessageBox | ("MSG00260", null) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-152baffc | SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain !=… | SCP0045_ShipmentRequest.cs:1406 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0045_ShipmentRequest.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-458fd062 | this.Load | SCP0045_ShipmentRequest.cs:247 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 3, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-f66291cd | this.Load | SCP0045_ShipmentRequest.cs:248 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-16ec4a2b | this.Load | SCP0045_ShipmentRequest.cs:249 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-13dc1603 | this.Load | SCP0045_ShipmentRequest.cs:251 |  | VALUE_SET | drpPeriod.InitValue | GetDayRange() | 컨트롤 값 설정 |  |  |  |
| AC-b3c37dea | this.Load | SCP0045_ShipmentRequest.cs:252 |  | STATE | drpPeriod.Enabled | false | 컨트롤 상태 Enabled |  |  |  |

## SCP0045_ShipmentRequest.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a2d9c20d | this.Load | SCP0045_ShipmentRequest.cs:153 |  | UI_PROP | usrConditionPanel1.Height | 75 | 속성 Height 설정 |  |  |  |
| AC-e37277c4 | this.Load | SCP0045_ShipmentRequest.cs:154 |  | VALUE_SET | cboBucketType.SelectedValue | BucketType.Daily | 컨트롤 값 설정 |  |  |  |
| AC-98c4bee1 | this.Load | SCP0045_ShipmentRequest.cs:156 |  | UI_PROP | siMain.ImagePopUp | imageList1.Images[0] | 속성 ImagePopUp 설정 |  |  |  |
| AC-f83441b1 | this.Load | SCP0045_ShipmentRequest.cs:158 |  | FLAG | cellTypeImage | new TextCellType() | 화면 필드/플래그 변경 |  |  |  |
| AC-6090f040 | this.Load | SCP0045_ShipmentRequest.cs:159 |  | UI_PROP | cellTypeImage.BackgroundImage | new FarPoint.Win.Picture(siMain.ImagePopUp) | 속성 BackgroundImage 설정 |  |  |  |
| AC-0cba9e14 | this.Load | SCP0045_ShipmentRequest.cs:160 |  | UI_PROP | cellTypeImage.BackgroundImage.AlignHorz | FarPoint.Win.HorizontalAlignment.Right | 속성 AlignHorz 설정 |  |  |  |

## SCP0045_ShipmentRequest.DeleteButton

진입점: DeleteButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f67449b3 | DeleteButton | SCP0045_ShipmentRequest.cs:502 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.ActiveRow == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-9b98babf | DeleteButton | SCP0045_ShipmentRequest.cs:507 | if (fps != null) ▸ if (fps.Name == "spdMain") ▸ if (action == CAppSetting.FlagI) | DATA_OP | siMain.Delete | () | 데이터 객체 조작/조회 |  |  |  |

## SCP0045_ShipmentRequest.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-98acfefe | Dispose | SCP0045_ShipmentRequest.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0045_ShipmentRequest.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c9b01e8d | EditButton | SCP0045_ShipmentRequest.cs:404 | if (fps == null) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d456308f | EditButton | SCP0045_ShipmentRequest.cs:408 | if (fps.Name == "spdMain") ▸ if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b824df84 | EditButton | SCP0045_ShipmentRequest.cs:410 | if (fps.Name == "spdMain") | FLAG | siMain | GetSheetInfo(spdMain.Name, fps.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-b8d9223b | EditButton | SCP0045_ShipmentRequest.cs:411 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-99c3520c | EditButton | SCP0045_ShipmentRequest.cs:415 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-8969f23c | EditButton | SCP0045_ShipmentRequest.cs:416 | if (fps.Name == "spdMain") | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-845413b2 | EditButton | SCP0045_ShipmentRequest.cs:419 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.Columns.Get | (fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index) | ⚠ 의미 확인 필요 |  |  |  |
| AC-e66d4da2 | EditButton | SCP0045_ShipmentRequest.cs:419 | if (fps.Name == "spdMain") | CALL_EXT | fps.ActiveSheet.GetColumnFromTag | (null, CAppSetting.StringAction) | ⚠ 의미 확인 필요 |  |  |  |
| AC-3c5f148a | EditButton | SCP0045_ShipmentRequest.cs:422 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible… | GRID_LOCK | siMain.LockRange | (0, siMain.GetColumnIndex(DefMain.MEASURE)+1, siMain.ActiveSheet.RowCount - 1, siMain.Acti… | 그리드 편집 잠금/해제 |  |  |  |
| AC-f92f11eb | EditButton | SCP0045_ShipmentRequest.cs:424 | if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f54473f3 | EditButton | SCP0045_ShipmentRequest.cs:475 | if (fps.Name == "spdMain") ▸ for (i < spdMain.ActiveSheet.RowCount) ▸ if (spdMain.ActiveSheet.GetValue(i, siMain.GetColumnIndex(DefMain.MEAS… | GRID_LOCK | siMain.LockRange | (i, iBlockStartIdx, i, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0045_ShipmentRequest.FindData_Main

진입점: FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d81a5951 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:520 |  | VALIDATE | DataUtil.checkRequired | (this.usrConditionPanel1) | 프레임워크 검증 |  |  |  |
| AC-100cb3e7 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:520 | if (!DataUtil.checkRequired(this.usrConditionPanel1)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-6f1496b0 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:521 |  | VALIDATE | DateUtil.Check_PeriodDate | (drpPeriod) | 프레임워크 검증 |  |  |  |
| AC-21609c7e | FindButton 외 1 | SCP0045_ShipmentRequest.cs:521 | if (!DateUtil.Check_PeriodDate(drpPeriod)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-0b9e1822 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:538 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-83199c4a | FindButton 외 1 | SCP0045_ShipmentRequest.cs:540 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6a7cc09c | FindButton 외 1 | SCP0045_ShipmentRequest.cs:544 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-97732211 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:546 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a4af63e3 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:548 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0045_GET_SHIPMENT_REQUEST") ⇒ SCP.SCP0045_GET_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-3cb601ba | FindButton 외 1 | SCP0045_ShipmentRequest.cs:550 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-23138386 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:552 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-f41a8a47 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:553 | try ▸ lambda | DATA_OP | req.Parameters["p_operation_group"] | p_operation_group | 행/컬럼 값 대입 |  |  |  |
| AC-477e3827 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:554 | try ▸ lambda | DATA_OP | req.Parameters["p_scm_site_id"] | p_scm_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-aea05ca7 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:555 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-f9663d65 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:556 | try ▸ lambda | DATA_OP | req.Parameters["p_from_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-2b855d4c | FindButton 외 1 | SCP0045_ShipmentRequest.cs:557 | try ▸ lambda | DATA_OP | req.Parameters["p_to_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-66a0a07d | FindButton 외 1 | SCP0045_ShipmentRequest.cs:558 | try ▸ lambda | DATA_OP | req.Parameters["p_program_id"] | p_program_id | 행/컬럼 값 대입 |  |  |  |
| AC-9fba87cd | FindButton 외 1 | SCP0045_ShipmentRequest.cs:559 | try ▸ lambda | DATA_OP | req.Parameters["p_sheet_name"] | p_sheet_name | 행/컬럼 값 대입 |  |  |  |
| AC-0927df78 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:560 | try ▸ lambda | DATA_OP | req.Parameters["p_user_id"] | UserInfoContext.Current.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-86fb7fc3 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:561 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-cc4f7563 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:562 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-be614648 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:564 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-7eaf0c9c | FindButton 외 1 | SCP0045_ShipmentRequest.cs:575 | try | GRID_BIND | siMain.Query | (dsBinding) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-c8e0b997 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:577 | try | GRID_LOCK | siMain.LockColumn | (0, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-b93a3b5d | FindButton 외 1 | SCP0045_ShipmentRequest.cs:578 | try | UI_MISC | SetSearchCount | (dsBinding) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-be50e183 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:584 | try | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-f2a67209 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:588 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-dbf3bc34 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:590 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-6d54e571 | FindButton 외 1 | SCP0045_ShipmentRequest.cs:593 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0045_ShipmentRequest.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-8ac85b8e | this.Load | SCP0045_ShipmentRequest.cs:143 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0045_ShipmentRequest.GetBucketType

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e838093f | this.Load | SCP0045_ShipmentRequest.cs:240 |  | ENDPOINT | new FoxDataRequest | ("DM.DM0003_GET_BUCKET_TYPE_CODE") ⇒ DM.DM0003_GET_BUCKET_TYPE_CODE | 엔드포인트 요청 생성 |  |  |  |
| AC-6e3a9925 | this.Load | SCP0045_ShipmentRequest.cs:241 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-78c958d1 | this.Load | SCP0045_ShipmentRequest.cs:243 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0045_ShipmentRequest.GetDayRange

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c06f76d0 | this.Load | SCP0045_ShipmentRequest.cs:608 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCM0001_GET_SCP_DAY_PERIOD") ⇒ SCP.SCM0001_GET_SCP_DAY_PERIOD | 엔드포인트 요청 생성 |  |  |  |
| AC-57ff9837 | this.Load | SCP0045_ShipmentRequest.cs:609 |  | DATA_OP | request.Parameters["p_from_date"] | "" | 행/컬럼 값 대입 |  |  |  |
| AC-b193f460 | this.Load | SCP0045_ShipmentRequest.cs:610 |  | DATA_OP | request.Parameters["p_offset_day"] | "55" | 행/컬럼 값 대입 |  |  |  |
| AC-8f999e84 | this.Load | SCP0045_ShipmentRequest.cs:611 |  | DATA_OP | request.Parameters["p_timezone"] | "AS054" | 행/컬럼 값 대입 |  |  |  |
| AC-43bfc030 | this.Load | SCP0045_ShipmentRequest.cs:612 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-17cc75d1 | this.Load | SCP0045_ShipmentRequest.cs:615 |  | RETURN | return sDayRange; |  | 처리 중단/반환 |  |  |  |

## SCP0045_ShipmentRequest.GetSpdTitle

진입점: this.Load / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e410d6e8 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:1070 |  | ENDPOINT | new FoxDataRequest | ("SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN") ⇒ SCP.SCP0009_GET_SHEET_CALENDAR_3SPAN | 엔드포인트 요청 생성 |  |  |  |
| AC-b6fe4686 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:1071 |  | DATA_OP | request.Parameters["p_start_yyyymmdd"] | p_from_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-441ec422 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:1072 |  | DATA_OP | request.Parameters["p_end_yyyymmdd"] | p_to_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-9fc42d98 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:1074 |  | FLAG | dsSpdTitle | client.ExecuteDataSet(request).DataSet | 화면 필드/플래그 변경 |  |  |  |
| AC-988a7efb | this.Load 외 2 | SCP0045_ShipmentRequest.cs:1074 |  | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0045_ShipmentRequest.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1b1dc829 | this.Load | SCP0045_ShipmentRequest.cs:199 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-04438ef0 | this.Load | SCP0045_ShipmentRequest.cs:201 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-89b3477a | this.Load | SCP0045_ShipmentRequest.cs:203 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-30405dcd | this.Load | SCP0045_ShipmentRequest.cs:208 |  | FLAG | dtOperGrp | Data_SCP.Common(Data_SCP.Type.OperationGroup, false) | 화면 필드/플래그 변경 |  |  |  |
| AC-463a01a3 | this.Load | SCP0045_ShipmentRequest.cs:208 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.OperationGroup, false) | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8fcbbccb | this.Load | SCP0045_ShipmentRequest.cs:209 |  | LIST_REBIND | clsCtrl.setListBox | (dtOperGrp, cboBizType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |
| AC-d9255ca0 | this.Load | SCP0045_ShipmentRequest.cs:218 |  | FLAG | dtBucketType | GetBucketType() | 화면 필드/플래그 변경 |  |  |  |
| AC-89c35cc5 | this.Load | SCP0045_ShipmentRequest.cs:219 |  | LIST_REBIND | clsCtrl.setListBox | (dtBucketType, cboBucketType, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0045_ShipmentRequest.InitSpread_2

진입점: this.Load / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-040e8f3a | this.Load 외 2 | SCP0045_ShipmentRequest.cs:258 |  | GRID_INIT | spdInfo.InitSheet | (siMain.SheetName) | 그리드 재구성/초기화 |  |  |  |
| AC-45726549 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:260 |  | FLAG | dtFromSite | Data.Common(Data.Type.PlantSiteByDivision, false, "40,81,82") ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 화면 필드/플래그 변경 |  |  |  |
| AC-e243357c | this.Load 외 2 | SCP0045_ShipmentRequest.cs:260 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivision, false, "40,81,82") ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivision] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-0efd47de | this.Load 외 2 | SCP0045_ShipmentRequest.cs:262 |  | DATA_OP | dtFromSite.NewRow | () | 데이터 객체 조작/조회 |  |  |  |
| AC-b5b8bd67 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:263 |  | DATA_OP | drRow["CODE"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-4dd74cb4 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:264 |  | DATA_OP | drRow["NAME"] | "-" | 행/컬럼 값 대입 |  |  |  |
| AC-f08318c7 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:265 |  | DATA_OP | dtFromSite.Rows.Add | (drRow) | 데이터 객체 조작/조회 |  |  |  |
| AC-60c27eeb | this.Load 외 2 | SCP0045_ShipmentRequest.cs:267 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("PlantSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-cecda432 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:268 |  | LIST_REBIND | SpreadInfo.SetComBoParam | ("ToSiteByDivision", dtFromSite) | 목록 컨트롤 재구성 |  |  |  |
| AC-b55d7e58 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:274 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 3) | 그리드 재구성/초기화 |  |  |  |
| AC-338a9f27 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:280 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0045_ShipmentRequest.InitSpreadDateColumn

진입점: this.Load / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2cd81d6b | this.Load 외 2 | SCP0045_ShipmentRequest.cs:315 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddTextColumn | (sColumnLabelname, sColumnName, FPMerge.None, 0, false) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-271f2ed8 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:316 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-5b8ff338 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:319 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.AddNumColumn | (sColumnLabelname, sColumnName, FPMerge.None, 70, true) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-c2137425 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:320 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) | GRID_INIT | spdInfo.SetReNumerCellType | (spdInfo, spdInfo.GetColumnIndex(sColumnName), -9999999999, 0) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-d15837e3 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:323 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sColumnName.IndexOf("B_") > 0) ▸ if (sDayCode == DefMainLabel.Saturday \|\| sDa… | GRID_SET | spdInfo.Sheet().ColumnHeader.Cells[2, spdInfo.GetMaxColumnIndex()].ForeColor | sDayCode == DefMainLabel.Saturday ? Color.Blue : Color.Red | 그리드 속성/값 설정 |  |  |  |
| AC-5ed3d56a | this.Load 외 2 | SCP0045_ShipmentRequest.cs:329 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fdbb357f | this.Load 외 2 | SCP0045_ShipmentRequest.cs:330 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-b39c87ef | this.Load 외 2 | SCP0045_ShipmentRequest.cs:335 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-d51cd7c6 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:336 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ if (sLargeSpanName != sLargeLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 30, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-32cfbf81 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:343 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-fe980905 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:344 | foreach (DataRow dr in dsSpdTitle.Tables[0].Rows) ▸ else of (sLargeSpanName != sLargeLabelName) ▸ if (sSmallSpanName != sSmallLabelName) | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-04d7890c | this.Load 외 2 | SCP0045_ShipmentRequest.cs:354 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iSmallStartCol, 1, iSmallSpanCnt, 20, sSmallSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-30ab0278 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:355 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (2, iSmallStartCol, 1, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-118eda02 | this.Load 외 2 | SCP0045_ShipmentRequest.cs:356 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (0, iLargeStartCol, 1, iLargeSpanCnt, 20, sLargeSpanName, FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-14580d4e | this.Load 외 2 | SCP0045_ShipmentRequest.cs:357 |  | GRID_INIT | spdInfo.ColumnHeaderSpan | (1, iLargeStartCol, 2, 1, 20, "SUM", FPHAlign.Center) | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0045_ShipmentRequest.InsertRow

진입점: InsertButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0af05a4f | InsertButton | SCP0045_ShipmentRequest.cs:710 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-1fdc311b | InsertButton | SCP0045_ShipmentRequest.cs:717 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, p_division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-16137d73 | InsertButton | SCP0045_ShipmentRequest.cs:718 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE, "SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-38d3b3c7 | InsertButton | SCP0045_ShipmentRequest.cs:719 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, "Ship Req") | 데이터 객체 조작/조회 |  |  |  |
| AC-6e00133a | InsertButton | SCP0045_ShipmentRequest.cs:721 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-0a967ca5 | InsertButton | SCP0045_ShipmentRequest.cs:724 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.DIVISI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-53882935 | InsertButton | SCP0045_ShipmentRequest.cs:725 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.NICK_NAME), siMain.ActiveSheet.ColumnCount - 1, tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-fdbfe13b | InsertButton | SCP0045_ShipmentRequest.cs:733 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefMain.ITEM_ID), dtBODItem) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0045_ShipmentRequest.InsertRow2

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-99f4520e | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:741 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | siMain.Insert | () | 데이터 객체 조작/조회 |  |  |  |
| AC-9ee04c99 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:748 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.DIVISION_ID, p_division_id) | 데이터 객체 조작/조회 |  |  |  |
| AC-2c560c93 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:749 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE, "SHIP_REQ") | 데이터 객체 조작/조회 |  |  |  |
| AC-8ed7d6d3 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:750 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | DATA_OP | defaultData.Add | (DefMain.MEASURE_LABEL, "Ship Req") | 데이터 객체 조작/조회 |  |  |  |
| AC-b42333e2 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:752 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_SET | this.siMain.SetValue | (insCell, defaultData) | 그리드 값 설정 |  |  |  |
| AC-9e7500df | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:755 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.DIVISION_ID), siMain.GetColumnIndex(DefMain.DIVISI… | 그리드 편집 잠금/해제 |  |  |  |
| AC-e2983710 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:756 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_LOCK | siMain.LockRange | (insCell, siMain.GetColumnIndex(DefMain.NICK_NAME), siMain.ActiveSheet.ColumnCount - 1, tr… | 그리드 편집 잠금/해제 |  |  |  |
| AC-eaa5385b | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… | SCP0045_ShipmentRequest.cs:764 | if (siMain != null && siMain.IsLock(siMain.SheetName) == false) | GRID_COMBO | siMain.SetCellTypeCombo | (siMain.ActiveRowIndex, siMain.GetColumnIndex(DefMain.ITEM_ID), dtBODItem) | 그리드 셀을 콤보로 바꾸고 목록 설정 |  |  |  |

## SCP0045_ShipmentRequest.RetValue

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-664911ac | (진입점 미연결) | SCP0045_ShipmentRequest.cs:1135 |  | RETURN | return ret; |  | 처리 중단/반환 |  |  |  |

## SCP0045_ShipmentRequest.SaveData

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-0752928f | SaveButton | SCP0045_ShipmentRequest.cs:816 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-9d94d4c1 | SaveButton | SCP0045_ShipmentRequest.cs:828 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (siMain.ActiveSheet.Rows.Count <= 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-55e0e479 | SaveButton | SCP0045_ShipmentRequest.cs:831 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-d1fcdd50 | SaveButton | SCP0045_ShipmentRequest.cs:831 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!DataUtil.checkRequiredOfSpread(siM… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d9550b66 | SaveButton | SCP0045_ShipmentRequest.cs:834 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (!checkValidN0()) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-07018ba5 | SaveButton | SCP0045_ShipmentRequest.cs:873 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | GRID_STYLE | siMain.SetBGColor | (i, j, i, j, ControlColor.InvalidColor) | 그리드 표시 설정 |  |  |  |
| AC-9f14f94c | SaveButton | SCP0045_ShipmentRequest.cs:874 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | MESSAGE | MessageHelper.GMessageBox | ("MSG00084", new object[] { null }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-65bcbc1a | SaveButton | SCP0045_ShipmentRequest.cs:875 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ for (i <= siMain.GetMaxRowIndex()) ▸ fo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-13305345 | SaveButton | SCP0045_ShipmentRequest.cs:898 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6e5561ba | SaveButton | SCP0045_ShipmentRequest.cs:901 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0045_SAVE_SHIPMENT_REQUEST") ⇒ SCP.SCP0045_SAVE_SHIPMENT_REQUEST | 엔드포인트 요청 생성 |  |  |  |
| AC-d5c600c9 | SaveButton | SCP0045_ShipmentRequest.cs:904 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-c4047924 | SaveButton | SCP0045_ShipmentRequest.cs:906 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_ANALYS… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-24b42e86 | SaveButton | SCP0045_ShipmentRequest.cs:911 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | UI_PROP | request.CommandTimeout | 3 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-bbf659ce | SaveButton | SCP0045_ShipmentRequest.cs:913 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_active_flag"] | n_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-44a4f026 | SaveButton | SCP0045_ShipmentRequest.cs:914 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_division_id"] | n_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-7e871b74 | SaveButton | SCP0045_ShipmentRequest.cs:915 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_from_site"] | n_from_site | 행/컬럼 값 대입 |  |  |  |
| AC-5f58003d | SaveButton | SCP0045_ShipmentRequest.cs:916 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_item_id"] | n_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-5dc9bc8f | SaveButton | SCP0045_ShipmentRequest.cs:917 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_incoterms"] | n_incoterms | 행/컬럼 값 대입 |  |  |  |
| AC-48a06793 | SaveButton | SCP0045_ShipmentRequest.cs:918 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_transport_mode"] | n_transport_mode | 행/컬럼 값 대입 |  |  |  |
| AC-61ada1f1 | SaveButton | SCP0045_ShipmentRequest.cs:919 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_to_site"] | n_to_site | 행/컬럼 값 대입 |  |  |  |
| AC-9d33aaaf | SaveButton | SCP0045_ShipmentRequest.cs:920 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_bod_id"] | n_bod_id | 행/컬럼 값 대입 |  |  |  |
| AC-85025e5b | SaveButton | SCP0045_ShipmentRequest.cs:921 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_measure"] | n_measure | 행/컬럼 값 대입 |  |  |  |
| AC-ddabc219 | SaveButton | SCP0045_ShipmentRequest.cs:922 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_yyyymmdd"] | n_yyyymmdd | 행/컬럼 값 대입 |  |  |  |
| AC-b12d9d2c | SaveButton | SCP0045_ShipmentRequest.cs:923 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_qty"] | n_qty | 행/컬럼 값 대입 |  |  |  |
| AC-0750110d | SaveButton | SCP0045_ShipmentRequest.cs:924 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["p_created_by"] | UserInfo.UserId | 행/컬럼 값 대입 |  |  |  |
| AC-37723611 | SaveButton | SCP0045_ShipmentRequest.cs:925 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | DATA_OP | request.Parameters["debug_mode"] | "F" | 행/컬럼 값 대입 |  |  |  |
| AC-26388dad | SaveButton | SCP0045_ShipmentRequest.cs:927 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-0f4d748b | SaveButton | SCP0045_ShipmentRequest.cs:927 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(request); |  | 처리 중단/반환 |  |  |  |
| AC-2f4fedb9 | SaveButton | SCP0045_ShipmentRequest.cs:938 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0f81dc79 | SaveButton | SCP0045_ShipmentRequest.cs:939 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (… | MESSAGE | MessageHelper.GMessageBox | ("MSG00004", new object[] { iCount }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-72af8c5e | SaveButton | SCP0045_ShipmentRequest.cs:949 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-ef36ffd6 | SaveButton | SCP0045_ShipmentRequest.cs:950 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | MESSAGE | MessageHelper.GMessageBox | (errorMsg) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b02205dd | SaveButton | SCP0045_ShipmentRequest.cs:960 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-0b2c3550 | SaveButton | SCP0045_ShipmentRequest.cs:961 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ else… | MESSAGE | MessageHelper.GMessageBox | ("MSG00042") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-c7464a47 | SaveButton | SCP0045_ShipmentRequest.cs:968 | try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ else of (iCount > 0) | MESSAGE | MessageHelper.GMessageBox | ("MSG00005") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-7537ad48 | SaveButton | SCP0045_ShipmentRequest.cs:977 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-b3f4b356 | SaveButton | SCP0045_ShipmentRequest.cs:978 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-ac5a711e | SaveButton | SCP0045_ShipmentRequest.cs:984 | finally ▸ if (!prgCloseF) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |

## SCP0045_ShipmentRequest.SCM_SYS_LOG_BATCH

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-acebd81f | (진입점 미연결) | SCP0045_ShipmentRequest.cs:795 | try | ENDPOINT | new FoxDataRequest | ("SCP.PR_SCM_SYS_LOG_BATCH") ⇒ SCP.PR_SCM_SYS_LOG_BATCH | 엔드포인트 요청 생성 |  |  |  |
| AC-94a2ca0b | (진입점 미연결) | SCP0045_ShipmentRequest.cs:796 | try | DATA_OP | request.Parameters["p_program_name"] | p_program_name | 행/컬럼 값 대입 |  |  |  |
| AC-1c557a88 | (진입점 미연결) | SCP0045_ShipmentRequest.cs:797 | try | DATA_OP | request.Parameters["p_log_type"] | p_log_type | 행/컬럼 값 대입 |  |  |  |
| AC-2ca45635 | (진입점 미연결) | SCP0045_ShipmentRequest.cs:798 | try | DATA_OP | request.Parameters["p_log_count"] | p_log_count | 행/컬럼 값 대입 |  |  |  |
| AC-1f109ff0 | (진입점 미연결) | SCP0045_ShipmentRequest.cs:799 | try | DATA_OP | request.Parameters["p_log_message"] | p_log_message | 행/컬럼 값 대입 |  |  |  |
| AC-f005dac1 | (진입점 미연결) | SCP0045_ShipmentRequest.cs:800 | try | DATA_OP | request.Parameters["p_description"] | p_description | 행/컬럼 값 대입 |  |  |  |
| AC-0eb32b91 | (진입점 미연결) | SCP0045_ShipmentRequest.cs:801 | try | DATA_OP | request.Parameters["p_event_date"] | DateTime.Now | 행/컬럼 값 대입 |  |  |  |
| AC-e3fb6ab8 | (진입점 미연결) | SCP0045_ShipmentRequest.cs:803 | try | ENDPOINT | client.ExecuteDataSet | (request) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |

## SCP0045_ShipmentRequest.Set_MeasureColor

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == false)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1277b2e7 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0045_ShipmentRequest.cs:992 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-916d4d5d | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0045_ShipmentRequest.cs:1020 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureColor != "") | UI_PROP | range1.BackColor | Color.FromArgb(Convert.ToInt32(sValues[0]), Convert.ToInt32(sValues[1]), Convert.ToInt32(s… | 속성 BackColor 설정 |  |  |  |
| AC-f61cf0f6 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0045_ShipmentRequest.cs:1030 | for (i < spdMain.ActiveSheet.RowCount) ▸ if (measureVal == "SCP_PLAN" && i != 0 && (model != itemId \|\| plant!= fromSite)) | UI_PROP | range1.Border | bevelbrdr | 속성 Border 설정 |  |  |  |
| AC-83054e5c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0045_ShipmentRequest.cs:1046 | for (i < spdMain.ActiveSheet.RowCount) ▸ if ("" != frozenYYYYMMDD && Int64.Parse(frozenYYYYMMDD) > Int64.Parse(startPeriod)) | UI_PROP | range1.BackColor | Color.FromArgb(242,242,242) | 속성 BackColor 설정 |  |  |  |
| AC-941eeb84 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 2 | SCP0045_ShipmentRequest.cs:1050 |  | UI_MISC | spdMain.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0045_ShipmentRequest.Set_SumValues

진입점: FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S") ▸ try ▸ if (dsBinding.Tables[0].Rows.Count > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-70a3c7d0 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SCP0045_ShipmentRequest.cs:631 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("M_") == 0) | DATA_OP | listMonth.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-6e8eb42c | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SCP0045_ShipmentRequest.cs:635 | for (nCol < dsBinding.Tables[0].Columns.Count) ▸ if (dsBinding.Tables[0].Columns[nCol].ColumnName.IndexOf("W_") == 0) | DATA_OP | listWeek.Add | (nCol) | 데이터 객체 조작/조회 |  |  |  |
| AC-5bebf462 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SCP0045_ShipmentRequest.cs:673 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_month_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |
| AC-97ba36c5 | FindButton [try ▸ if (dsBinding.Tables[0].Rows.Count > 0)] 외 1 | SCP0045_ShipmentRequest.cs:678 | for (iRow < dsBinding.Tables[0].Rows.Count) ▸ if (measure.Equals("WH_BOH_PLAN") \|\| measure.Equals("WH_BOH_REQ")) ▸ for (iCol < dsBinding.T… | GRID_SET | dsBinding.Tables[0].Rows[iRow][bef_week_idx] | dsBinding.Tables[0].Rows[iRow][iCol] | 그리드 속성/값 설정 |  |  |  |

## SCP0045_ShipmentRequest.SetBODItemID

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (dtBODItem == null \|\| bChgDiv)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false) ▸ if (dtBODItem == null \|\| bChgDiv)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-7fc9c2f7 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0045_ShipmentRequest.cs:1055 |  | FLAG | dtBODItem | Data_SCP.Common(Data_SCP.Type.BODItemProjectRoute, false, cboDivision.ControlValues, cboBi… | 화면 필드/플래그 변경 |  |  |  |
| AC-6ba0be45 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0045_ShipmentRequest.cs:1055 |  | COMBO_DATA | Data_SCP.Common | (Data_SCP.Type.BODItemProjectRoute, false, cboDivision.ControlValues, cboBizType.ControlVa… | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-c5677b44 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0045_ShipmentRequest.cs:1057 |  | FLAG | bChgDiv | false | 화면 필드/플래그 변경 |  |  |  |

## SCP0045_ShipmentRequest.SetChangedControl

진입점: this.Load / this.cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1d92dc8b | this.Load 외 1 | SCP0045_ShipmentRequest.cs:229 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | FLAG | dtFromSite | Data.Common(Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizTy… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 화면 필드/플래그 변경 |  |  |  |
| AC-d2b489a1 | this.Load 외 1 | SCP0045_ShipmentRequest.cs:229 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | COMBO_DATA | Data.Common | (Data.Type.PlantByDivisionOperation, false, cboDivision.ControlValues, cboBizType.ControlV… ⇒ biz:CommonData.CommonDataList [code=PlantByDivisionOperation] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-59ac1864 | this.Load 외 1 | SCP0045_ShipmentRequest.cs:230 | if (cboDivision.ControlValues != null && !cboDivision.ControlValues.Equals("ALL")) | LIST_REBIND | clsCtrl.setListBox | (dtFromSite, clbFromSite, true) | 목록 컨트롤 재구성 |  |  |  |

## SCP0045_ShipmentRequest.SetImageCell

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreach (var bodItem in bodPopup.retList) ▸ if (idx > 0) ▸ if (siMain != null && siMain.IsLock(siMain.SheetName) == false)] / InsertButton [if (siMain != null && siMain.IsLock(siMain.SheetName) == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-1ece3048 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0045_ShipmentRequest.cs:782 | for (iRow <= maxRow) | GRID_SET | siMain.ActiveSheet.Cells[iRow, siMain.GetColumnIndex(DefMain.TR_MODE)].CellType | cellTypeImage | 그리드 속성/값 설정 |  |  |  |

## SCP0045_ShipmentRequest.SetLockSumColumn

진입점: this.spdMain.CellClick [if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK)] / EditButton [if (fps.Name == "spdMain") ▸ if (fps.ActiveSheet.Columns.Get(fps.ActiveSheet.GetColumnFromTag(null, CAppSetting.StringAction).Index).Visible == false)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2c135ec0 | this.spdMain.CellClick [if (e.Column == siMain.GetColumnInde… 외 1 | SCP0045_ShipmentRequest.cs:698 | for (iCol < spreadInfo.ActiveSheet.ColumnCount) ▸ if (spreadInfo.GetColumnTag(iCol).IndexOf("M_") == 0 \|\| spreadInfo.GetColumnTag(iCol).In… | GRID_LOCK | spreadInfo.LockRange | (0, iCol, spreadInfo.ActiveSheet.RowCount - 1, iCol, true) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0045_ShipmentRequest.SetSpreadColumn

진입점: this.chkSum.CheckedChanged [if (siMain != null)] / this.Load / this.cboBucketType.SelectedIndexChanged [if (siMain != null)] / FindButton / SaveButton [try ▸ if (fps.Name == "spdMain") ▸ if (siMain != null && siMain.IsLock(SpdSheet.shtMain) == false) ▸ if (iCount > 0) ▸ if (t.Success) ▸ if (t.DataSet.Tables[0].Rows[0][0].ToString() == "S")]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c238a91a | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1095 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("D_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-4394a49b | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1099 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ if (cboBucketType.ControlValues == BucketType.Daily) ▸ if (siObj.GetColumnTag(iCol).IndexOf("M_") … | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-38b8b010 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1104 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-fccc0a12 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1107 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |
| AC-fe1536a9 | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1111 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ if (cboBucketType.ControlValues == Buc… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | chkSum.Checked | 그리드 속성/값 설정 |  |  |  |
| AC-8d089faf | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1116 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | false | 그리드 속성/값 설정 |  |  |  |
| AC-1ed0270c | this.chkSum.CheckedChanged [if (siMain != null)] 외 4 | SCP0045_ShipmentRequest.cs:1119 | for (iCol <= siObj.GetMaxColumnIndex()) ▸ else of (cboBucketType.ControlValues == BucketType.Daily) ▸ else of (cboBucketType.ControlValues =… | GRID_SET | siObj.ActiveSheet.Columns[iCol].Visible | true | 그리드 속성/값 설정 |  |  |  |

## SCP0045_ShipmentRequest.SpdMain_CellClick

진입점: this.spdMain.CellClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-b5af0ab2 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1162 | if (e.ColumnHeader) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-09845dd8 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1163 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-2cfc70ae | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1164 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-b731e035 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1165 | if (siMain.GetText(insRow, 0) != "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-53c31c8f | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1170 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) | GRID_STYLE | siMain.ActiveSheet.SetActiveCell | (e.Row, siMain.GetColumnIndex(DefMain.ITEM_ID)) | 그리드 표시 설정 |  |  |  |
| AC-faf18ab2 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1177 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ if (p_item_id == "") | MESSAGE | MessageHelper.GMessageBox | ("MSG00098", new object[] { MessageHelper.GetTerm("Model") }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-58ee1fea | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1186 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | POPUP | new SCM0002_GetBODItemPrjRoutePopup | () | 팝업/폼 생성 |  |  |  |
| AC-c5502817 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1187 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_division_id | p_divisionId | 속성 p_division_id 설정 |  |  |  |
| AC-1c5ea135 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1188 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_operation_group | p_operationGroup | 속성 p_operation_group 설정 |  |  |  |
| AC-5d1ea93e | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1189 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_item_id | p_item_id | 속성 p_item_id 설정 |  |  |  |
| AC-2fe9cc46 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1190 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_from_yyyymmdd | p_from_yyyymmdd | 속성 p_from_yyyymmdd 설정 |  |  |  |
| AC-80fb2095 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1191 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.p_prgram_id | "SCP0045" | 속성 p_prgram_id 설정 |  |  |  |
| AC-87f0cc15 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1192 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.Width | 1400 | 속성 Width 설정 |  |  |  |
| AC-2b17ebe6 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1194 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | UI_PROP | bodPopup.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-a0852e91 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1195 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") | POPUP | bodPopup.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-6921bd95 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1201 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ if (bo… | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-d04b3b2e | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1216 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_LOCK | siMain.LockRange | (insRow, siMain.GetColumnIndex(DefMain.ITEM_ID), e.Row, siMain.GetColumnIndex(DefMain.ITEM… | 그리드 편집 잠금/해제 |  |  |  |
| AC-9a7ea3ce | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1219 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.ITEM_ID), p_item_id) | 그리드 값 설정 |  |  |  |
| AC-fb158a2e | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1220 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.FROM_SITE), bodItem.c_from_site) | 그리드 값 설정 |  |  |  |
| AC-1e892b89 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1221 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.TO_SITE), bodItem.c_to_site) | 그리드 값 설정 |  |  |  |
| AC-97f65e32 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1222 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.TR_MODE), bodItem.c_transport_mode) | 그리드 값 설정 |  |  |  |
| AC-6e58ba57 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1223 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.INCOTERMS), bodItem.c_incoterms) | 그리드 값 설정 |  |  |  |
| AC-1655b377 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1224 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.LT_DAY), bodItem.c_lt_day) | 그리드 값 설정 |  |  |  |
| AC-b35d3cce | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1225 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.FROZEN_YYYYMMDD), bodItem.c_frozen_yyyymmdd) | 그리드 값 설정 |  |  |  |
| AC-eaabdd8e | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1226 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.BOD_ID), bodItem.c_bod_id) | 그리드 값 설정 |  |  |  |
| AC-b993da29 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1249 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_LOCK | siMain.LockRange | (insRow, siMain.GetColumnIndex(DefMain.MEASURE) + 1, insRow, siMain.ActiveSheet.ColumnCoun… | 그리드 편집 잠금/해제 |  |  |  |
| AC-55a566b8 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1250 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_SET | siMain.SetValue | (insRow, siMain.GetColumnIndex(DefMain.MEASURE) + 1, insRow, siMain.ActiveSheet.ColumnCoun… | 그리드 값 설정 |  |  |  |
| AC-84350f49 | this.spdMain.CellClick | SCP0045_ShipmentRequest.cs:1274 | if (e.Column == siMain.GetColumnIndex(DefMain.TR_MODE)) ▸ else of (p_item_id == "") ▸ if (bodPopup.DialogResult == DialogResult.OK) ▸ foreac… | GRID_LOCK | siMain.LockRange | (insRow, iBlockStartIdx, insRow, iBlockLastIdx, false) | 그리드 편집 잠금/해제 |  |  |  |

## SCP0045_ShipmentRequest.SpdMain_CellDoubleClick

진입점: this.spdMain.CellDoubleClick

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f451cc44 | this.spdMain.CellDoubleClick | SCP0045_ShipmentRequest.cs:387 |  | CALL_EXT | siMain.SetDblClickColumnShowHide | (sender, e) | ⚠ 의미 확인 필요 |  |  |  |

## SCP0045_ShipmentRequest.SpdMain_ComboSelChange

진입점: this.spdMain.ComboSelChange / spdMain.ComboSelChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-58f8b8f0 | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1306 | if (siMain.ActiveSheet.RowCount == 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-41f25f04 | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1307 | if (siMain == null \|\| siMain.IsLock(siMain.SheetName) == true) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-f5160642 | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1308 | if (siMain.GetText(e.Row, 0) != "I") | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-7c453e11 | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1313 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.FROM_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-04f7a4cd | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1314 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.TO_SITE), "") | 그리드 값 설정 |  |  |  |
| AC-dee98d0c | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1315 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.TR_MODE), "") | 그리드 값 설정 |  |  |  |
| AC-7954fd7f | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1316 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.INCOTERMS), "") | 그리드 값 설정 |  |  |  |
| AC-144bd61c | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1317 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_SET | siMain.SetValue | (e.Row, siMain.GetColumnIndex(DefMain.LT_DAY), "") | 그리드 값 설정 |  |  |  |
| AC-3a53e76f | this.spdMain.ComboSelChange 외 1 | SCP0045_ShipmentRequest.cs:1322 | if (e.Column == siMain.GetColumnIndex(DefMain.ITEM_ID)) | GRID_LOCK | siMain.LockRange | (e.Row, siMain.GetColumnIndex(DefMain.MEASURE), e.Row, siMain.ActiveSheet.ColumnCount - 1,… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0045_ShipmentRequest.SpdMain_TopChange

진입점: this.spdMain.TopChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9303e921 | this.spdMain.TopChange | SCP0045_ShipmentRequest.cs:392 |  | GRID_INIT | siMain.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |

