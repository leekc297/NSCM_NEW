# AS-IS 액션 대조표 — SCP0023

> 원천: `Doc/asisfacts/screens/SCP0023/actions.csv` · `actions_entries.csv` (tools/AsisFacts pack — 핸들러 본문의 실행 문장 전수, 생성 2026-10-23).
> 각 행 = AS-IS 가 실제로 하는 동작 1건. TO-BE 구현 후 **상태**(구현 / 미구현 / 제외 / 해당없음)·**TO-BE 구현 위치**(파일:라인)·제외/해당없음이면 **사유** 를 채운다. 빈 칸 금지.
> **⚠ 의미 확인 필요** = 사전에 의미가 등록되지 않은 외부/상속 메서드 호출(CALL_EXT·CALL_BASE). AS-IS 원문(위치)을 열어 실제 의미를 '의미' 칸에 적고 TO-BE 대응을 판단한다(게이트 AC2).
> 조건(guard) = 이 동작이 실행되는 분기(if/else/switch case/loop/try/catch). 진입점의 [ ] = 그 메서드를 부르는 호출 지점 조건. 재생성해도 같은 ID 의 상태·위치·사유·의미는 보존된다.
건수: 80행 · 메서드 18 · 종류 DATA_OP 16 · RETURN 8 · FLAG 8 · GRID_INIT 7 · UI_MISC 6 · ENDPOINT 6 · POPUP 5 · UI_PROP 5 · MESSAGE 5 · GRID_LOCK 4 · VALIDATE 3 · COMBO_DATA 2 · LIST_REBIND 2 · VALUE_SET 1 · GRID_SET 1 · GRID_BIND 1 · ⚠ 의미 확인 필요 0


## SCP0023_OutsourcingCapacity.BtnItemId_Click

진입점: btnItemId.Click

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-63dbcb10 | btnItemId.Click | SCP0023_OutsourcingCapacity.cs:206 |  | POPUP | new SCM0002_ItembyDivisionPopup | () | 팝업/폼 생성 |  |  |  |
| AC-a56d9755 | btnItemId.Click | SCP0023_OutsourcingCapacity.cs:208 |  | POPUP | popItem.Form_Load | (true, division, sScmSite, sProject, sItemId) | 팝업 초기화(인자 전달) |  |  |  |
| AC-c196aae3 | btnItemId.Click | SCP0023_OutsourcingCapacity.cs:209 |  | UI_PROP | popItem.StartPosition | System.Windows.Forms.FormStartPosition.CenterParent | 속성 StartPosition 설정 |  |  |  |
| AC-2e2d57eb | btnItemId.Click | SCP0023_OutsourcingCapacity.cs:210 |  | POPUP | popItem.ShowDialog | () | 팝업/폼 열기 |  |  |  |
| AC-f3815a34 | btnItemId.Click | SCP0023_OutsourcingCapacity.cs:215 | if (popItem.ItemID != "") | VALUE_SET | txtItemId.Text | sItemId | 컨트롤 값 설정 |  |  |  |

## SCP0023_OutsourcingCapacity.CheckDigitValueEntered

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e3da8a48 | dsdmMain.Changed | SCP0023_OutsourcingCapacity.cs:460 | if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.DAILY_CAPA_QTY)) ▸ if (nVal < 1 \|\| res == false) | GRID_SET | spread.SetValue | (nRow, nCol, 1) | 그리드 값 설정 |  |  |  |
| AC-6e69214b | dsdmMain.Changed | SCP0023_OutsourcingCapacity.cs:461 | if (fps.Name == spdMain.Name) ▸ if (nCol == siMain.GetColumnIndex(DefMain.DAILY_CAPA_QTY)) ▸ if (nVal < 1 \|\| res == false) | MESSAGE | MessageHelper.GMessageBox | ("MSG00085", new object[] { 1 }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0023_OutsourcingCapacity.checkValidN

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount > 0)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d82f9356 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:484 | for (idx < sPlant.Length) | DATA_OP | valiList.Contains | (sPlant[idx]) | 데이터 객체 조작/조회 |  |  |  |
| AC-0168fc35 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:486 | for (idx < sPlant.Length) ▸ if (!valiList.Contains(sPlant[idx])) | DATA_OP | valiList.Add | (sPlant[idx]) | 데이터 객체 조작/조회 |  |  |  |
| AC-b99f0b82 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:526 | if (!isPass) | MESSAGE | MessageHelper.GMessageBox | ("MSG00258", new object[] { msgPlantId }) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-b2dac2ac | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:529 |  | RETURN | return isPass; |  | 처리 중단/반환 |  |  |  |

## SCP0023_OutsourcingCapacity.CreateSpread

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5c0c621f | this.Load | SCP0023_OutsourcingCapacity.cs:142 |  | GRID_INIT | this.AddSheet | (spdMain, SpdSheet.shtMain, SpdSheet.shtMain, 1, 1, 35) | 그리드 시트/컬럼 구성·표시 |  |  |  |
| AC-efefd7dc | this.Load | SCP0023_OutsourcingCapacity.cs:143 |  | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-24f97583 | this.Load | SCP0023_OutsourcingCapacity.cs:145 |  | GRID_INIT | siMain.ChangeSheet | () | 그리드 컬럼/헤더 구성 |  |  |  |

## SCP0023_OutsourcingCapacity.DefineProperty

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d6c29890 | this.Load | SCP0023_OutsourcingCapacity.cs:125 |  | UI_PROP | usrConditionPanel1.Height | 48 | 속성 Height 설정 |  |  |  |

## SCP0023_OutsourcingCapacity.Dispose

진입점: Dispose

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-f063250f | Dispose | SCP0023_OutsourcingCapacity.Designer.cs:18 | if (disposing && (components != null)) | UI_MISC | components.Dispose | () | 창 닫기/해제 |  |  |  |

## SCP0023_OutsourcingCapacity.EditButton

진입점: EditButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-2244925d | EditButton | SCP0023_OutsourcingCapacity.cs:245 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | FLAG | siMain | GetSheetInfo(spdMain.Name, spdMain.ActiveSheetIndex) | 화면 필드/플래그 변경 |  |  |  |
| AC-f5c8fbbc | EditButton | SCP0023_OutsourcingCapacity.cs:246 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.SwitchLock | () | 그리드 편집 잠금 전환 |  |  |  |
| AC-b69c84d9 | EditButton | SCP0023_OutsourcingCapacity.cs:247 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | ( 0 , siMain.GetColumnIndex(DefMain.NICK_NAME), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-07c1f1c3 | EditButton | SCP0023_OutsourcingCapacity.cs:248 | if (spdMain != null) ▸ if (this.fps != null) ▸ if (fps.Name.Equals(spdMain.Name)) | GRID_LOCK | siMain.LockColumn | (siMain.GetColumnIndex(DefMain.CREATED_BY), siMain.GetColumnIndex(DefMain.LAST_UPDATE_DATE… | 그리드 편집 잠금/해제 |  |  |  |

## SCP0023_OutsourcingCapacity.FindData_Main

진입점: FindButton / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-c80f3fce | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:335 |  | VALIDATE | DataUtil.checkRequiredOfSearch | (this.Controls) | 프레임워크 검증 |  |  |  |
| AC-0eebc005 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:335 | if (!DataUtil.checkRequiredOfSearch(this.Controls)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-4279749b | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:354 |  | POPUP | new GSCM.Windows.Forms.UI.ProgressForm | () | 팝업/폼 생성 |  |  |  |
| AC-7d83a9ad | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:356 | try | POPUP | prg.Show | () | 팝업/폼 열기 |  |  |  |
| AC-6bc6f2fc | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:361 | try | UI_PROP | proxyPivot.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-354fea19 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:363 | try | ENDPOINT | proxyPivot.ExecuteAsync | (() => { using (var client = new FoxDataClient(CAppSetting.SystemTypeGSCM, GSCM_SCP_MASTER… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-9abef19e | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:365 | try ▸ lambda | ENDPOINT | new FoxDataRequest | ("SCP.SCP0023_GET_OUTSOURCING_CAPA") ⇒ SCP.SCP0023_GET_OUTSOURCING_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-590a4797 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:366 | try ▸ lambda | UI_PROP | req.CommandTimeout | 15 * 60 | 속성 CommandTimeout 설정 |  |  |  |
| AC-65b66017 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:367 | try ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-77131a65 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:368 | try ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-9d8af103 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:369 | try ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-8304db16 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:370 | try ▸ lambda | DATA_OP | req.Parameters["p_valid"] | p_valid | 행/컬럼 값 대입 |  |  |  |
| AC-6814462d | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:371 | try ▸ lambda | DATA_OP | req.Parameters["debug_mode"] | debug_mode | 행/컬럼 값 대입 |  |  |  |
| AC-c2ac5e78 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:372 | try ▸ lambda | DATA_OP | req.Parameters["p_nick_name"] | p_nick_name | 행/컬럼 값 대입 |  |  |  |
| AC-aebc7ddb | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:374 | try ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-285cce7d | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:375 | try ▸ lambda | RETURN | return res.DataSet; |  | 처리 중단/반환 |  |  |  |
| AC-5cfd8750 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:382 | try | GRID_BIND | siMain.Query | (ds) | 그리드에 조회 결과 바인딩 |  |  |  |
| AC-e7c1ca28 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:383 | try | UI_MISC | SetSearchCount | (ds) | 진행창·조회건수·화면 보기 상태 |  |  |  |
| AC-0b594167 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:386 | try ▸ if (ds.Tables[0].Rows.Count > 0) | GRID_LOCK | siMain.LockColumn | (1, siMain.GetMaxColumnIndex(), true) | 그리드 편집 잠금/해제 |  |  |  |
| AC-f50cd9a0 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:391 | catch ((Exception ex)) | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-a19299a0 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:393 | catch ((Exception ex)) | MESSAGE | MessageHelper.GMessageBoxForException | (ex) | 메시지 표시(확인창이면 결과로 분기) |  |  |  |
| AC-715c19a6 | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:395 | finally | UI_MISC | prg.Close | () | 창 닫기/해제 |  |  |  |
| AC-da833f2d | FindButton 외 1 | SCP0023_OutsourcingCapacity.cs:396 | finally | UI_MISC | siMain.SpreadObject.ResumeLayout | () | 화면 갱신/대기창 |  |  |  |

## SCP0023_OutsourcingCapacity.Form_Load

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-24aaeffc | this.Load | SCP0023_OutsourcingCapacity.cs:112 |  | UI_MISC | InitForm | () | 진행창·조회건수·화면 보기 상태 |  |  |  |

## SCP0023_OutsourcingCapacity.GetSpdTitle

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-524bcfe4 | (진입점 미연결) | SCP0023_OutsourcingCapacity.cs:158 |  | COMBO_DATA | Data.Common | (Data.Type.SpreadTitle, false, "SCP0023", sheetname) ⇒ biz:CommonData.CommonDataList [code=SpreadTitle] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-bb4e7c56 | (진입점 미연결) | SCP0023_OutsourcingCapacity.cs:160 |  | RETURN | return dt; |  | 처리 중단/반환 |  |  |  |

## SCP0023_OutsourcingCapacity.InitControls

진입점: this.Load

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-d23b9a74 | this.Load | SCP0023_OutsourcingCapacity.cs:131 | if (dtDivision.Rows.Count == 0) | VALIDATE | this.SetDivisionAuthCheck | (this.usrLayoutControl2) | 권한 검사/설정 |  |  |  |
| AC-0434654f | this.Load | SCP0023_OutsourcingCapacity.cs:133 |  | FLAG | clsCtrl | new CControl(this) | 화면 필드/플래그 변경 |  |  |  |
| AC-106f8848 | this.Load | SCP0023_OutsourcingCapacity.cs:135 |  | LIST_REBIND | clsCtrl.setListBox | (dtDivision, cboDivision, false, "CODE", "NAME") | 목록 컨트롤 재구성 |  |  |  |

## SCP0023_OutsourcingCapacity.InitSpread

진입점: (진입점 미연결)

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-18cc1f77 | (진입점 미연결) | SCP0023_OutsourcingCapacity.cs:165 |  | GRID_INIT | spdInfo.InitSheet | (SpdSheet.shtMain) | 그리드 재구성/초기화 |  |  |  |
| AC-6a90109f | (진입점 미연결) | SCP0023_OutsourcingCapacity.cs:167 |  | GRID_INIT | spdInfo.SetSheetHeaderColumn | (spdInfo, 1) | 그리드 재구성/초기화 |  |  |  |
| AC-f348fecd | (진입점 미연결) | SCP0023_OutsourcingCapacity.cs:168 |  | GRID_INIT | spdInfo.SmartColMerge | () | 그리드 컬럼/헤더 구성 |  |  |  |
| AC-a285b704 | (진입점 미연결) | SCP0023_OutsourcingCapacity.cs:169 |  | GRID_INIT | spdInfo.VisibleTab | (true) | 그리드 시트/컬럼 구성·표시 |  |  |  |

## SCP0023_OutsourcingCapacity.InitSpread_2

진입점: this.Load / FindButton / SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes) ▸ if (iCount > 0) ▸ if (tran.Success)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-a5b41b04 | this.Load 외 2 | SCP0023_OutsourcingCapacity.cs:152 |  | GRID_INIT | siMain.SetSheetHeaderColumn | (siMain, 1) | 그리드 재구성/초기화 |  |  |  |

## SCP0023_OutsourcingCapacity.SaveButton

진입점: SaveButton

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5a26a3fe | SaveButton | SCP0023_OutsourcingCapacity.cs:255 |  | MESSAGE | MessageHelper.GMessageBox | ("MSG00012") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0023_OutsourcingCapacity.SaveData

진입점: SaveButton [if (MessageHelper.GMessageBox("MSG00012") == DialogResult.Yes)]

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-9fbbe445 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:291 | if (iCount > 0) | VALIDATE | DataUtil.checkRequiredOfSpread | (siMain) | 프레임워크 검증 |  |  |  |
| AC-25a0f962 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:291 | if (iCount > 0) ▸ if (!DataUtil.checkRequiredOfSpread(siMain)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-a219e0af | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:292 | if (iCount > 0) ▸ if (!checkValidN(p_plant_site_id)) | RETURN | return; |  | 처리 중단/반환 |  |  |  |
| AC-234be1d1 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:296 | if (iCount > 0) | ENDPOINT | new FoxDataRequest | ("SCP.SCP0023_SAVE_OUTSOURCING_CAPA") ⇒ SCP.SCP0023_SAVE_OUTSOURCING_CAPA | 엔드포인트 요청 생성 |  |  |  |
| AC-356eb2a3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:298 | if (iCount > 0) | UI_PROP | asyncProxy.ShowProgress | false | 속성 ShowProgress 설정 |  |  |  |
| AC-f775fe98 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:300 | if (iCount > 0) | ENDPOINT | asyncProxy.ExecuteAsync | (() => { using (var client = new FoxDataClient("GSCM", "GSCM.SCP.Master.WSL/FoxDataService… | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-a1a17ed1 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:302 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_active_flag"] | p_active_flag | 행/컬럼 값 대입 |  |  |  |
| AC-c93de2b6 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:303 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_division_id"] | p_division_id | 행/컬럼 값 대입 |  |  |  |
| AC-e647b857 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:304 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_plant_site_id"] | p_plant_site_id | 행/컬럼 값 대입 |  |  |  |
| AC-6abb308d | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:305 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_item_id"] | p_item_id | 행/컬럼 값 대입 |  |  |  |
| AC-748c4da3 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:306 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_daily_capa_qty"] | p_daily_capa_qty | 행/컬럼 값 대입 |  |  |  |
| AC-d95c8071 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:307 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_valid_yn"] | p_valid_yn | 행/컬럼 값 대입 |  |  |  |
| AC-0e86c75c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:308 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_created_by"] | p_created_by | 행/컬럼 값 대입 |  |  |  |
| AC-e3080309 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:309 | if (iCount > 0) ▸ lambda | DATA_OP | req.Parameters["p_last_updated_by"] | p_last_updated_by | 행/컬럼 값 대입 |  |  |  |
| AC-614b0b7c | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:310 | if (iCount > 0) ▸ lambda | ENDPOINT | client.ExecuteDataSet | (req) | 데이터 조회/저장 호출(엔드포인트는 endpoint 열) |  |  |  |
| AC-fb391230 | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:310 | if (iCount > 0) ▸ lambda | RETURN | return client.ExecuteDataSet(req); |  | 처리 중단/반환 |  |  |  |
| AC-297f69dc | SaveButton [if (MessageHelper.GMessageBox("MSG00012") == Dia… | SCP0023_OutsourcingCapacity.cs:315 | if (iCount > 0) ▸ if (tran.Success) | MESSAGE | MessageHelper.GMessageBox | ("MSG00020") | 메시지 표시(확인창이면 결과로 분기) |  |  |  |

## SCP0023_OutsourcingCapacity.SetChangedControl

진입점: this.Load / cboDivision.SelectedIndexChanged

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-e31204f0 | this.Load 외 1 | SCP0023_OutsourcingCapacity.cs:328 |  | FLAG | dtPlantSiteByDivision | Data.Common(Data.Type.PlantSiteByDivisionOSP, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivisionOSP] | 화면 필드/플래그 변경 |  |  |  |
| AC-3c4624f7 | this.Load 외 1 | SCP0023_OutsourcingCapacity.cs:328 |  | COMBO_DATA | Data.Common | (Data.Type.PlantSiteByDivisionOSP, false, division) ⇒ biz:CommonData.CommonDataList [code=PlantSiteByDivisionOSP] | 콤보/조회조건 데이터 조회(Data.* 프레임워크 — 코드별 SP 분기) |  |  |  |
| AC-8809cee1 | this.Load 외 1 | SCP0023_OutsourcingCapacity.cs:330 |  | LIST_REBIND | clsCtrl.setListBox | (dtPlantSiteByDivision, clbPlantSite, false) | 목록 컨트롤 재구성 |  |  |  |

## SCP0023_OutsourcingCapacity.SpdMain_Changed

진입점: dsdmMain.Changed

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-236c3bbc | dsdmMain.Changed | SCP0023_OutsourcingCapacity.cs:435 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-a44cd5c4 | dsdmMain.Changed | SCP0023_OutsourcingCapacity.cs:436 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |
| AC-5f05d686 | dsdmMain.Changed | SCP0023_OutsourcingCapacity.cs:439 | if (this._siMainCellRowIdx < 0 \|\| this._siMainCellColIdx < 0) | RETURN | return; |  | 처리 중단/반환 |  |  |  |

## SCP0023_OutsourcingCapacity.SpdMain_EditChange

진입점: this.spdMain.EditChange

| ID | 진입점 | 위치 | 조건(guard) | 종류 | 대상 | 값 | 의미 | TO-BE 구현 위치 | 상태 | 사유/비고 |
|---|---|---|---|---|---|---|---|---|---|---|
| AC-5dfcb431 | this.spdMain.EditChange | SCP0023_OutsourcingCapacity.cs:414 |  | FLAG | this._siMainCellRowIdx | e.Row | 화면 필드/플래그 변경 |  |  |  |
| AC-ecffc4ac | this.spdMain.EditChange | SCP0023_OutsourcingCapacity.cs:415 |  | FLAG | this._siMainCellColIdx | e.Column | 화면 필드/플래그 변경 |  |  |  |

